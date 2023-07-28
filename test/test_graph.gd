extends GutTest

const Graph = preload("res://graph.gd")

func test_claim_node_available_node():
	# Given a graph
	var graph = Graph.new()

	# When I claim an available node
	var result = graph.claim_node(1, "BLUE")

	# Then the node is claimed
	assert_true(result, "Should be able to claim an available node")

func test_claim_node_non_existing_node():
	# Given a graph
	var graph = Graph.new()

	# When I claim a node that does not exist
	var result = graph.claim_node(29, "BLUE")

	# Then the node is not claimed
	assert_false(result, "Should not be able to claim a non existing node")

func test_claim_node_already_claimed_node():
	# Given a graph
	var graph = Graph.new()
	graph.claim_node(1, "BLUE")

	# When I claim a node that has already been claimed
	var result = graph.claim_node(1, "RED")

	# Then the node is not claimed
	assert_false(result, "Should not be able to claim an already claimed node")
