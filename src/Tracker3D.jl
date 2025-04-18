module Tracker3D

using LinearAlgebra
using Printf
using FileIO
using Meshes
using MeshIO
using AprilTags

function get_tag_data(tag_id::Int, tag_family::AprilTags.TagFamilies=AprilTags.tag36h11)
    return AprilTags.getAprilTagImage(tag_id, tag_family)
end

function generate_3d_model(tag_data, filename::String;
    square_size::Float64=1.0,
    height_black::Float64=0.5,
    height_white::Float64=0.1)

    size_x, size_y = size(tag_data)

    open("$filename.stl", "w") do file
        # STL header
        write(file, "solid AprilTag3D\n")

        # Generate squares
        for y in 1:size_y
            for x in 1:size_x
                idx = (y - 1) * size_x + x
                is_black = tag_data[idx] == 0

                # Position of the square
                x_pos = (x - 1) * square_size
                y_pos = (y - 1) * square_size
                z_pos = 0.0

                # Height of the square based on color
                height = is_black ? height_black : height_white

                # Create the square (6 faces for a cube)
                # Bottom face
                write_square_face(file,
                    [x_pos, y_pos, z_pos],
                    [x_pos + square_size, y_pos, z_pos],
                    [x_pos + square_size, y_pos - square_size, z_pos],
                    [x_pos, y_pos - square_size, z_pos])

                # Top face
                write_square_face(file,
                    [x_pos, y_pos, z_pos + height],
                    [x_pos, y_pos - square_size, z_pos + height],
                    [x_pos + square_size, y_pos - square_size, z_pos + height],
                    [x_pos + square_size, y_pos, z_pos + height])

                # Side faces
                # Front face
                write_square_face(file,
                    [x_pos, y_pos, z_pos],
                    [x_pos, y_pos, z_pos + height],
                    [x_pos + square_size, y_pos, z_pos + height],
                    [x_pos + square_size, y_pos, z_pos])

                # Back face
                write_square_face(file,
                    [x_pos, y_pos - square_size, z_pos],
                    [x_pos + square_size, y_pos - square_size, z_pos],
                    [x_pos + square_size, y_pos - square_size, z_pos + height],
                    [x_pos, y_pos - square_size, z_pos + height])

                # Left face
                write_square_face(file,
                    [x_pos, y_pos, z_pos],
                    [x_pos, y_pos - square_size, z_pos],
                    [x_pos, y_pos - square_size, z_pos + height],
                    [x_pos, y_pos, z_pos + height])

                # Right face
                write_square_face(file,
                    [x_pos + square_size, y_pos, z_pos],
                    [x_pos + square_size, y_pos, z_pos + height],
                    [x_pos + square_size, y_pos - square_size, z_pos + height],
                    [x_pos + square_size, y_pos - square_size, z_pos])
            end
        end

        # STL footer
        write(file, "endsolid AprilTag3D\n")
    end
end

function write_square_face(file, v1, v2, v3, v4)
    normal = normalize(cross(v2 .- v1, v3 .- v1))
    write_triangle(file, v1, v2, v3, normal)
    write_triangle(file, v1, v3, v4, normal)
end

function write_triangle(file, v1, v2, v3, normal)
    @printf(file, "facet normal %.6f %.6f %.6f\n", normal[1], normal[2], normal[3])
    write(file, "    outer loop\n")
    @printf(file, "        vertex %.6f %.6f %.6f\n", v1[1], v1[2], v1[3])
    @printf(file, "        vertex %.6f %.6f %.6f\n", v2[1], v2[2], v2[3])
    @printf(file, "        vertex %.6f %.6f %.6f\n", v3[1], v3[2], v3[3])
    write(file, "    endloop\n")
    write(file, "endfacet\n")
end

function visualize_tag(tag_data, filename::String)
    size_y, size_x = size(tag_data)

    open("$filename.txt", "w") do file
        for x in 1:size_y
            for y in 1:size_x
                idx = (y - 1) * size_x + x
                is_black = tag_data[idx] == 0
                write(file, is_black ? "  " : "██")
            end
            write(file, "\n")
        end
    end
end

function main()
    output_dir = "output/"
    if !isdir(output_dir)
        mkdir(output_dir)
    end

    tag_id = 0
    layer_height = 0.2
    total_tag_height = 1.0

    height_black = total_tag_height
    height_white = total_tag_height - layer_height

    for tag_id in 0:10
        tag_data = get_tag_data(tag_id)
        visualize_tag(tag_data, "$(output_dir)/apriltag_tag36h11_id$(tag_id)")
        generate_3d_model(tag_data, "$(output_dir)/apriltag_tag36h11_id$(tag_id)_3d", square_size=5.0, height_black=height_black, height_white=height_white)
        @printf "Tag ID: %d\n" tag_id
    end
end

main()

end # module Tracker3D
