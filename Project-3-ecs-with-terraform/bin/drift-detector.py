#!/usr/bin/env python3
import json
import sys
from pathlib import Path
from typing import Dict, Any, List, Tuple
from dataclasses import dataclass
from deepdiff import DeepDiff

@dataclass
class StateComparison:
    added_resources: List[str]
    removed_resources: List[str]
    modified_resources: Dict[str, Dict]
    unchanged_resources: List[str]

def load_state_file(filepath: str) -> Dict[str, Any]:
    """Load and parse a terraform state file."""
    try:
        with open(filepath, 'r') as f:
            return json.load(f)
    except FileNotFoundError:
        print(f"Error: State file '{filepath}' not found")
        sys.exit(1)
    except json.JSONDecodeError:
        print(f"Error: '{filepath}' is not a valid JSON file")
        sys.exit(1)

def extract_resources(state: Dict[str, Any]) -> Dict[str, Dict]:
    """Extract resources from state file as a dictionary keyed by address."""
    resources = {}
    
    if "resources" in state:
        for resource in state["resources"]:
            addr = resource.get("address", "unknown")
            resources[addr] = resource
    
    return resources

def compare_states(old_resources: Dict[str, Dict], new_resources: Dict[str, Dict]) -> StateComparison:
    """Compare two sets of resources and identify changes."""
    old_addrs = set(old_resources.keys())
    new_addrs = set(new_resources.keys())
    
    # Resources that were added
    added = list(new_addrs - old_addrs)
    
    # Resources that were removed
    removed = list(old_addrs - new_addrs)
    
    # Resources that exist in both
    common = old_addrs & new_addrs
    
    # Find modified resources
    modified = {}
    unchanged = []
    
    for addr in common:
        if old_resources[addr] != new_resources[addr]:
            # Use DeepDiff to show what changed
            diff = DeepDiff(
                old_resources[addr],
                new_resources[addr],
                ignore_order=True,
                verbose_level=2
            )
            modified[addr] = diff.to_dict()
        else:
            unchanged.append(addr)
    
    return StateComparison(
        added_resources=sorted(added),
        removed_resources=sorted(removed),
        modified_resources=modified,
        unchanged_resources=sorted(unchanged)
    )

def print_summary(comparison: StateComparison) -> None:
    """Print a summary of changes."""
    total_changes = (
        len(comparison.added_resources) +
        len(comparison.removed_resources) +
        len(comparison.modified_resources)
    )
    
    print("\n" + "="*70)
    print("TERRAFORM STATE COMPARISON SUMMARY")
    print("="*70)
    
    print(f"\nTotal Resources Unchanged: {len(comparison.unchanged_resources)}")
    print(f"Total Changes Detected: {total_changes}\n")
    
    # Added resources
    if comparison.added_resources:
        print(f"✓ ADDED ({len(comparison.added_resources)}):")
        for resource in comparison.added_resources:
            print(f"  + {resource}")
    
    # Removed resources
    if comparison.removed_resources:
        print(f"\n✗ REMOVED ({len(comparison.removed_resources)}):")
        for resource in comparison.removed_resources:
            print(f"  - {resource}")
    
    # Modified resources
    if comparison.modified_resources:
        print(f"\n⟳ MODIFIED ({len(comparison.modified_resources)}):")
        for resource, diff in comparison.modified_resources.items():
            print(f"  ~ {resource}")
            for change_type, changes in diff.items():
                if isinstance(changes, dict):
                    for key, value in changes.items():
                        print(f"    {change_type}: {key}")
                        if isinstance(value, dict) and 'old_value' in value and 'new_value' in value:
                            print(f"      Old: {value['old_value']}")
                            print(f"      New: {value['new_value']}")

def print_detailed_changes(comparison: StateComparison) -> None:
    """Print detailed information about each change."""
    if not comparison.modified_resources:
        return
    
    print("\n" + "="*70)
    print("DETAILED CHANGES")
    print("="*70)
    
    for resource, diff in comparison.modified_resources.items():
        print(f"\n{resource}:")
        print(json.dumps(diff, indent=2))

def main():
    if len(sys.argv) < 3:
        print("Usage: python script.py <old_state_file> <new_state_file> [--detailed]")
        print("\nExample:")
        print("  python script.py terraform.tfstate.old terraform.tfstate --detailed")
        sys.exit(1)
    
    old_file = sys.argv[1]
    new_file = sys.argv[2]
    detailed = "--detailed" in sys.argv
    
    print(f"Loading old state from: {old_file}")
    old_state = load_state_file(old_file)
    
    print(f"Loading new state from: {new_file}")
    new_state = load_state_file(new_file)
    
    # Extract and compare resources
    old_resources = extract_resources(old_state)
    new_resources = extract_resources(new_state)
    
    print(f"\nOld state has {len(old_resources)} resources")
    print(f"New state has {len(new_resources)} resources")
    
    comparison = compare_states(old_resources, new_resources)
    
    # Print results
    print_summary(comparison)
    
    if detailed:
        print_detailed_changes(comparison)

if __name__ == "__main__":
    main()