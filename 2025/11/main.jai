#import "Basic";
#import "File";
#import "Treemap";
str :: #import "String";

main :: () {
    lines :: #run -> []string {
        input := read_entire_file("./example.txt");
        // input := read_entire_file("./input.txt");
        lines := str.split(input, "\n");
        lines.count -= 1;
        return lines;
    }
    lines2 := array_copy(lines);

    part1(lines);
    // part2(lines2);
}

Device :: struct {
    label: string;
    parents: [..]string;
}

device_find :: (devices: []Device, label: string) -> bool, int {
    for device: devices if label == device.label return true, it_index;
    return false, -1;
}

parse_devices :: (lines: []string) -> []Device {
    devices: [..]Device;

    array_add(*devices, Device.{label = "out"});
    for line: lines {
        s := str.split(line, ": ");
        label := s[0];

        array_add(*devices, Device.{label = label});
    }

    for line: lines {
        s := str.split(line, ": ");
        label := s[0];
        outputs := str.split(s[1], " ");

        for output: outputs {
            found, idx := device_find(devices, output);
            if found {
                array_add(*devices[idx].parents, label);
            }
        }
    }

    return devices;
}

Graph_Node :: struct {
    device_label: string;
    edges: [..]Graph_Node;
}

/// Graph using an Adjacency List
Graph :: struct {
    nodes: [..]Graph_Node;
}

graph_add_node :: (graph: *Graph, device_label: string) -> Graph_Node {
    node := Graph_Node.{ device_label = device_label };
    array_add(*graph.nodes, node);
    return node;
}

graph_add_edge :: (graph: *Graph, from: Graph_Node, to: Graph_Node) {
    array_add(*from.edges, to);
}

graph_print :: (graph: Graph) {
    for node: graph.nodes {
        print("% -> ", node.device_label);
        for edge: node.edges {
            print("% ", edge.device_label);
        }
        print("\n");
    }
}

parse_graph :: ($devices: []Device) -> Graph {
    graph: Graph;

    a :: (devices: []Device) -> string {
        add_nodes: String_Builder;
        for device: devices {
            print_to_builder(*add_nodes, #string DONE
                %1 := graph_add_node(*graph, "%1");
            DONE, device.label);
        }

        add_edges: String_Builder;
        for device: devices {
            for parent: device.parents {
                print_to_builder(*add_edges, #string DONE
                    graph_add_edge(*graph, %, %);
                DONE, parent, device.label);
            }
        }

        arr := string.[
            builder_to_string(*add_nodes),
            builder_to_string(*add_edges),
        ];
        return str.join(..arr);
    }
    #insert #run a(devices);

    return graph;
}


part1 :: ($lines: []string) {
    devices :: #run parse_devices(lines);
    graph := parse_graph(devices);

    graph_print(graph);

    path_count := 0;

    print("There are % different paths that lead from \"you\" to \"out\".\n", path_count);
}

// part2 :: (lines: []string) {
// }

char_to_string :: (char: u8) -> string {
    s: string;
    s.count = 1;
    s.data = alloc(1);
    s[0] = char;
    return s;
}
