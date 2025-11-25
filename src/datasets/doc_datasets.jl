"""
    srdc_doc(data::UFFDataset)

Displays the documentation developed by the SRDC (Structural Dynamics Research Corporation) for a given dataset type.

**Input**
- `data::UFFDataset`: An instance of a UFF dataset type (e.g., Dataset15, Dataset18, etc.).

**Output**
- Displays the documentation for the SRDC of the specified dataset type.
"""
srdc_doc(data::Dataset15) = display(@doc parse_dataset15)
srdc_doc(data::Dataset18) = display(@doc parse_dataset18)
srdc_doc(data::Dataset55) = display(@doc parse_dataset55)

# Special case for Dataset58
function srdc_doc(data::Dataset58)
    display(@doc parse_dataset58)
    display(@doc parse_dataset58b)
end
srdc_doc(data::Dataset82) = display(@doc parse_dataset82)
srdc_doc(data::Dataset151) = display(@doc parse_dataset151)
srdc_doc(data::Dataset164) = display(@doc parse_dataset164)
srdc_doc(data::Dataset1858) = display(@doc parse_dataset1858)
srdc_doc(data::Dataset2411) = display(@doc parse_dataset2411)
srdc_doc(data::Dataset2412) = display(@doc parse_dataset2412)
srdc_doc(data::Dataset2414) = display(@doc parse_dataset2414)