"""
    Dataset151

A struct containing UFF Dataset 151 (Header) data.

**Fields**
- `type::Symbol`: Data set type
- `name::String`: Data set name
- `model_name::String`: model file name
- `description::String`: model file description
- `application::String`: Program which created the dataset
- `datetime_created::DateTime`: dataset creation date and time
- `version::String`: version from dataset
- `file_type::Int`: file type
- `datetime_last_saved::DateTime`: dataset last saved date and time
- `program::String`: program which created uff file
- `datetime_written::DateTime`: uff file written date and time
"""
@show_data struct Dataset151 <: UFFDataset
    # Fields specific to Dataset151
    type::Symbol                    # Data set type
    name::String                    # Data set name
    model_name::String              # Record 1 - field 1
    description::String             # Record 2 - field 1
    application::String             # Record 3 - field 1
    datetime_created::String        # Record 4 - fields 1 and 2
    version::String                 # Record 4 - fields 3 and 4
    file_type::Int                  # Record 4 - field 5
    datetime_last_saved::String     # Record 5 - fields 1 and 2
    program::String                 # Record 6 - field 1
    datetime_written::String        # Record 7 - fields 1 and 2

    Dataset151(
        model_name = "",
        description = "",
        application = "",
        datetime_created = "",
        version = "",
        file_type = 0,
        datetime_last_saved = "",
        program = "",
        datetime_written = ""
    ) = new(:Dataset151, "Header", model_name, description, application, datetime_created, version, file_type, datetime_last_saved, program, datetime_written)
end

"""
Universal Dataset Number: 151

**Name:   Header**

    Record 1: FORMAT(80A1)
                Field 1      -- model file name

    Record 2: FORMAT(80A1)
                Field 1      -- model file description

    Record 3: FORMAT(80A1)
                Field 1      -- program which created DB

    Record 4: FORMAT(10A1,10A1,3I10)
                Field 1      -- date database created (DD-MMM-YY)
                Field 2      -- time database created (HH:MM:SS)
                Field 3      -- Version from database
                Field 4      -- Version from database
                Field 5      -- File type
                                =0  Universal
                                =1  Archive
                                =2  Other

    Record 5: FORMAT(10A1,10A1)
                Field 1      -- date database last saved (DD-MMM-YY)
                Field 2      -- time database last saved (HH:MM:SS)

    Record 6: FORMAT(80A1)
                Field 1      -- program which created universal file

    Record 7: FORMAT(10A1,10A1)
                Field 1      -- date universal file written (DD-MMM-YY)
                Field 2      -- time universal file written (HH:MM:SS)
"""
function parse_dataset151(block)
    model_name = strip(block[2])
    description = strip(block[3])
    application = strip(block[4])

    # Record 4 contains multiple fields in one line
    line_creation = extend_line(strip(block[5]))
    datetime_created = strip(line_creation[1:20])
    version = strip(line_creation[21:40])
    if isempty(strip(line_creation[41:end]))
        file_type = 0
    else
        file_type = parse(Int, strip(line_creation[41:end]))
    end

    datetime_last_saved = strip(block[6])
    program = strip(block[7])
    datetime_written = strip(block[8])

    return Dataset151(
        model_name,
        description,
        application,
        datetime_created,
        version,
        file_type,
        datetime_last_saved,
        program,
        datetime_written
    )
end

"""
    write_dataset(dataset::Dataset151) -> Vector{String}

Write a UFF Dataset 151 (Header) to a vector of strings.

**Input**
- `dataset::Dataset151`: The dataset structure containing header information

**Output**
- `Vector{String}`: Vector of formatted strings representing the UFF file content
"""
function write_dataset(dataset::Dataset151)
    lines = String[]

    # Write header
    push!(lines, "    -1")
    push!(lines, "   151")

    # Record 1: FORMAT(80A1) - model file name
    push!(lines, dataset.model_name)

    # Record 2: FORMAT(80A1) - model file description (empty line if no description)
    push!(lines, dataset.description)

    # Record 3: FORMAT(80A1) - program which created DB
    push!(lines, dataset.application)

    # Record 4: FORMAT(10A1,10A1,3I10) - date/time created, version, file_type
    # The datetime_created field should already contain both date and time
    # The version field should be formatted as two 10-character fields
    # File type should be formatted as I10
    record4 = dataset.datetime_created
    if !isempty(dataset.version)
        record4 *= dataset.version
    end
    if dataset.file_type != 0
        record4 *= @sprintf("%10d", dataset.file_type)
    end
    push!(lines, record4)

    # Record 5: FORMAT(10A1,10A1) - date/time last saved
    push!(lines, dataset.datetime_last_saved)

    # Record 6: FORMAT(80A1) - program which created universal file
    push!(lines, dataset.program)

    # Record 7: FORMAT(10A1,10A1) - date/time written
    push!(lines, dataset.datetime_written)

    # Write footer
    push!(lines, "    -1")

    return lines
end