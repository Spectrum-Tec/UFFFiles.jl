using UFFFiles, FileIO, UUIDs

const idUFFFiles = :UFFFiles => UUID("20c5726e-8372-4c34-be2c-190a5a70d483")

add_format(format"UFF", (), [".uff", ".unv"], [idUFFFiles])

data = load("test/datasets/dataset15.unv")
save("test/datasets/output_dataset15.unv", data)