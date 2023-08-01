extends Object
## This class tracks which nodes are owned by which team
## and provides path finding to determine the winning condition.

const adjacency_list = {
	1: [2, 3],
	2: [1, 3, 4, 5],
	3: [1, 2, 5, 6],
	4: [2, 5, 7, 8],
	5: [2, 3, 4, 6, 8, 9],
	6: [3, 5, 9, 10],
	7: [4, 8, 11, 12],
	8: [4, 5, 7, 9, 12, 13],
	9: [5, 6, 8, 10, 13, 14],
	10: [6, 9, 14, 15],
	11: [7, 12, 16, 17],
	12: [7, 8, 11, 13, 17, 18],
	13: [8, 9, 12, 14, 18, 19],
	14: [9, 10, 13, 15, 19, 20],
	15: [10, 14, 20, 21],
	16: [11, 17, 22, 23],
	17: [11, 12, 16, 18, 23, 24],
	18: [12, 13, 17, 19, 24, 25],
	19: [13, 14, 18, 20, 25, 26],
	20: [15, 16, 19, 21, 26, 27],
	21: [15, 20, 27, 28],
	22: [16, 23],
	23: [16, 17, 22, 24],
	24: [17, 18, 23, 25],
	25: [18, 19, 24, 26],
	26: [19, 20, 25, 27],
	27: [20, 21, 26, 28],
	28: [21, 27]
}

var claimed_nodes = {}

## Claims a node if it is available (True), otherwise returns (False).
func claim_node(node: int, team: String) -> bool:
	if node not in adjacency_list:
		return false
	if node in claimed_nodes:
		return false
	else:
		claimed_nodes[node] = team
		return true

## Runs BFS from each left-most node (left side of the triangle)
## and checks if we can visit the bottom and the right sides
## by building a path for particular team.
func check_path_exists(team: String) -> bool:
	for left_side_tile in [1, 2, 4, 7, 11, 16, 22]:
		if left_side_tile in claimed_nodes and claimed_nodes[left_side_tile] == team:
			var visited_right_side = false
			var visited_bottom_side = false
			var visited = {}
			var frontier = [left_side_tile]
			while frontier:
				var hex = frontier.pop_at(0)
				visited[hex] = true

				if hex in [1, 3, 6, 10, 15, 21, 28]:
					visited_right_side = true

				if hex in [22, 23, 24, 25, 26, 27, 28]:
					visited_bottom_side = true

				if visited_right_side and visited_bottom_side:
					print("Found path:")
					print(visited)
					return true

				for neighbor in adjacency_list[hex]:
					if neighbor not in visited and neighbor not in frontier:
						if neighbor in claimed_nodes and claimed_nodes[neighbor] == team:
							frontier.append(neighbor)
	return false
