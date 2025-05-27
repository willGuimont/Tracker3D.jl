# Tracker3D

Tracker3D is a Julia-based tool for generating 3D-printable models of AprilTags.
Pre-generated models are available on [Tracking Cube](https://www.thingiverse.com/thing:6983741).

## Quick Start

To generate a 3D model of a tag, run the following command:

``` shell
julia --project=. src/Tracker3D.jl <output_dir> <tag_id> <square_size> <tag_height> <layer_height>

# For example
julia --project=. src/Tracker3D.jl data/tags 0 5.0 1.0 0.2
```

## Usage

Here are the parameters to pass to the script
``` shell
Usage: julia src/Tracker3D.jl <output_dir> <tag_id> <square_size> <total_tag_height> <layer_height>
           output_dir: directory in which to generate the tag
           tad_id: ID of the tag to generate
           square_size: size in mm of each square on the tag, so that the full tag is of size 10*square_size (5.0)
           total_tag_height: height in mm of the full 3D tag (1.0)
           layer_height: size of the black top layer in mm (0.2)
```

