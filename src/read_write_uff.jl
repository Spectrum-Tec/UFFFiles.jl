"""
    readuff(filename::String) -> Vector{UFFDataset}

Reads a UFF (Universal File Format) file and parses its contents into a vector of UFFDataset objects.

**Input**
- `filename::String`: The path to the UFF file to be read.

**Output**
- `data::Vector{UFFDataset}`: A vector containing the parsed UFF datasets.
"""
function readuff(filename::String)

    # Extract blocks from the UFF file
    blocks = extract_blocks(filename)
    nblocks = length(blocks)

    # Check each block for support
    supported_blocks = issupported.(blocks)
    nunsup= count(.!supported_blocks)
    nsup= nblocks - nunsup

    # Initialize an array to hold parsed datasets
    data = Vector{UFFDataset}(undef, nsup)

    i = 1
    for (b, block) in enumerate(blocks)
        # Determine dataset type from the first line of the block
        dtype = strip(block[1])
        if !supported_blocks[b]
            @warn "Unsupported dataset type: $dtype - skipping this block."
            continue
        end

        # Parse the block based on its dataset type
        # https://stackoverflow.com/questions/34016768/julia-invoke-a-function-by-a-given-string/34023458#34023458
        parse_dataset = getfield(UFFFiles, Symbol("parse_dataset", dtype))
        data[i] = parse_dataset(block)
        i += 1
    end

    return data
end

# FileIO integration
fileio_load(file::File{FileIO.format"UFF"}) = readuff(file.filename)

"""
    writeuff(filename::String, data::Vector{UFFDataset})

Writes a vector of UFFDataset objects to a UFF file.

**Input**
- `filename::String`: The path to the UFF file to be written.
- `data::Vector{UFFDataset}`: A vector containing the UFF datasets to be
written.
"""
function writeuff(filename::String, data)
    open(filename, "w") do io
        for dataset in data
            lines = write_dataset(dataset)

            # Write the formatted lines to the file
            for line in lines
                println(io, line)
            end
        end
    end
end

# FileIO integration
fileio_save(file::File{format"UFF"}, data) = writeuff(file.filename, data)