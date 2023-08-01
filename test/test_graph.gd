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

func test_check_path_exists_path_does_not_exist():
	# Given a graph and no path connecting three triangle sides
	var graph = Graph.new()
	graph.claim_node(1, "BLUE")
	graph.claim_node(7, "RED")
	graph.claim_node(21, "BLUE")

	# When I check for complete paths
	var result = graph.check_path_exists("BLUE")

	# Then there are no complete paths
	assert_false(result, "Should not have any complete paths")

func test_check_path_exists_path_does_exist():
	# Given a graph and a path connecting three triangle sides
	var graph = Graph.new()
	graph.claim_node(1, "BLUE")
	graph.claim_node(2, "BLUE")
	graph.claim_node(4, "BLUE")
	graph.claim_node(7, "BLUE")
	graph.claim_node(11, "BLUE")
	graph.claim_node(16, "BLUE")
	graph.claim_node(22, "BLUE")
	graph.claim_node(3, "RED")
	graph.claim_node(6, "RED")

	# When I check for complete paths
	var result = graph.check_path_exists("BLUE")

	# Then there is a complete path (1, 2, 4, 7, 11, 16, 22)
	assert_true(result, "Should have a complete path")

func test_check_path_exists_complex_path_does_exist():
	# Given a graph and a complex path connecting three triangle sides
	var graph = Graph.new()
	graph.claim_node(1, "RED")
	graph.claim_node(3, "RED")
	graph.claim_node(6, "RED")
	graph.claim_node(9, "RED")
	graph.claim_node(13, "RED")
	graph.claim_node(12, "RED")
	graph.claim_node(17, "RED")
	graph.claim_node(24, "RED")
	graph.claim_node(5, "BLUE")
	graph.claim_node(4, "BLUE")
	graph.claim_node(8, "BLUE")
	graph.claim_node(18, "BLUE")
	graph.claim_node(11, "BLUE")

	# When I check for complete paths
	var result = graph.check_path_exists("RED")

	# Then there is a complete path (1, 3, 6, 9, 13, 12, 17, 24)
	assert_true(result, "Should have a complete path")
