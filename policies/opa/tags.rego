package main

import rego.v1

required_tags := {"Environment", "Service", "ManagedBy", "SecurityTier"}

deny contains msg if {
	some resource in input.resource_changes
	resource.change.actions[_] in ["create", "update"]
	tags := object.get(resource.change.after, "tags", {})
	missing := {tag | some tag in required_tags; object.get(tags, tag, "") == ""}
	count(missing) > 0
	msg := sprintf("Resource '%s' is missing mandatory constitution tags: %v", [resource.address, missing])
}
