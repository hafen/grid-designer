# Geo Grid Designer

For use with [geofacet](https://github.com/hafen/geofacet).

To try it out, click [here](https://hafen.github.io/grid-designer/).

To try it out with a pre-populated example, click [here](https://hafen.github.io/grid-designer/#img=http%3A%2F%2F1.bp.blogspot.com%2F-DztsF0ghmtE%2FT3r-Y1M-VPI%2FAAAAAAAAAss%2F-hYbi2iORz8%2Fs1600%2Fusa-map-region.gif&data=row%2Ccol%2Ccode%2Cname%0A1%2C11%2CME%2CMaine%0A1%2C10%2CNH%2CNew%20Hampshire%0A1%2C9%2CVT%2CVermont%0A1%2C6%2CWI%2CWisconsin%0A2%2C2%2CID%2CIdaho%0A2%2C6%2CIL%2CIllinois%0A2%2C10%2CMA%2CMassachusetts%0A2%2C7%2CMI%2CMichigan%0A2%2C5%2CMN%2CMinnesota%0A2%2C3%2CMT%2CMontana%0A2%2C9%2CNY%2CNew%20York%0A2%2C4%2CND%2CNorth%20Dakota%0A2%2C1%2CWA%2CWashington%0A3%2C10%2CCT%2CConnecticut%0A3%2C6%2CIN%2CIndiana%0A3%2C5%2CIA%2CIowa%0A3%2C2%2CNV%2CNevada%0A3%2C9%2CNJ%2CNew%20Jersey%0A3%2C7%2COH%2COhio%0A3%2C1%2COR%2COregon%0A3%2C8%2CPA%2CPennsylvania%0A3%2C11%2CRI%2CRhode%20Island%0A3%2C4%2CSD%2CSouth%20Dakota%0A3%2C3%2CWY%2CWyoming%0A4%2C1%2CCA%2CCalifornia%0A4%2C3%2CCO%2CColorado%0A4%2C10%2CDE%2CDelaware%0A4%2C6%2CKY%2CKentucky%0A4%2C9%2CMD%2CMaryland%0A4%2C5%2CMO%2CMissouri%0A4%2C4%2CNE%2CNebraska%0A4%2C2%2CUT%2CUtah%0A4%2C8%2CVA%2CVirginia%0A4%2C7%2CWV%2CWest%20Virginia%0A5%2C2%2CAZ%2CArizona%0A5%2C5%2CAR%2CArkansas%0A5%2C4%2CKS%2CKansas%0A5%2C3%2CNM%2CNew%20Mexico%0A5%2C7%2CNC%2CNorth%20Carolina%0A5%2C8%2CSC%2CSouth%20Carolina%0A5%2C6%2CTN%2CTennessee%0A5%2C9%2CDC%2CDistrict%20of%20Columbia%0A6%2C7%2CAL%2CAlabama%0A6%2C8%2CGA%2CGeorgia%0A6%2C5%2CLA%2CLouisiana%0A6%2C6%2CMS%2CMississippi%0A6%2C4%2COK%2COklahoma%0A7%2C2%2CAK%2CAlaska%0A7%2C9%2CFL%2CFlorida%0A7%2C1%2CHI%2CHawaii%0A7%2C4%2CTX%2CTexas).

## Adding Grids

Although initially created to support the [R geofacet package](https://github.com/hafen/geofacet), this repository is intended to be a place for the community to share and grow a large collection of grids that might be useful for any project that can make use of them. You can contribute by submitting pull requests that add new grids following the guidelines outlined below.

Note that when a user of the geofacet R package creates a new grid, they are prompted to share it with others. To help streamline the process for them, a GitHub issue is automatically created for them that is populated with the grid data and instructions for them to provide some additional info such as an image file that represents the geographical region referred to by the grid.

### Grid Data Format

To add a new grid, there are two pieces of information that must be added or updated in this repository.

1. Add a csv file containing the grid data in the `grids/` directory
2. Add an entry to the list of grids, `grid_list.json`, with the appropriate information about your grid.

### Grid csv File Guidelines

- Every grid must only have column names `code`, `name`, `row`, and `col`, and column names are always lowercase. One exception is that it is possible for there to be multiple `code` and `name` columns, in which case they can be appended with an underscore and suffix to differentiate them. For example, we might have `code_fips` and `code_iso`. Or `name_en` and `name_de`. Or `name` and `name_abb`.
- The values of the columns `row` and `col` must be jointly distinct (no overlapping grid tiles).
- The values in the “name” columns should have proper noun capitalization. No all caps.
- Naming the csv file: The general rule is lowercase / snake case with the first part of the name being the overarching geographic entity, the next being the type of geographic partitioning (e.g. county, state, province, etc.), followed by “grid[n]”, where “n” indicates the grid number. I put the grid number in just in case different users submit different layouts for the same grid. Some example names of grids can be seen [here](https://github.com/hafen/grid-designer/tree/master/grids).

Good resourcea for choosing aspects of the file name include a list of [ISO_3166-1_alpha-2 codes for countries](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2). You can search for similar lists of codes for other geographic entities as well.

For example, suppose we want to take a user-submitted grid provided in [this GitHub issue](https://github.com/hafen/geofacet/issues/180) and get it ready to officially submit as a grid in this repository. The submitted grid data looks like this:

```
cod_provincias,PROVINCIAS,row,col
04,CARCHI,2,4
21,SUCUMBIOS,3,7
08,ESMERALDAS,3,2
...
```

There are a few things that must be corrected when submitting this data as a csv file here.

- The column names should be renamed to `code`, `name` , `row`, `col`.
- Since the `code` column appears to contain codes that are numeric but with leading zeros, we would probably want to place quotes around the `code` values in each row so that the leading zero is not lost when read in (many csv parsers would read the column as numeric and remove the leading zeros).
- The values in the `name` column should not be all caps.

A correct version of the csv file should look more like this:

```
code,name,row,col
"04",Carchi,2,4
"21",Sucumbios,3,7
"08",Esmeraldas,3,2
...
```

This grid has been added to this repository and the file was named `ec_prov_grid1.csv`

### Grid List Updating Guidelines

The `grid_list.json` file in this repository contains an index to all of the available grids, with a few pieces of metadata that can be useful for providing some more context around the grid.

Each new grid entry should provide the following information:

- `name`: The name of the corresponding .csv file found in the `grids/` directory (without the .csv extension). This file must exist. In the example Equador provinces grid described above, the value would be `ec_prov_grid1`.
- `desc`: A description of the grid. For example, in the Equador example, it was described as `Grid layout for provinces of Ecuador`.
- `contrib`: A URL pointing to the GitHub user page for the person who contributed the grid, for attribution. For example, for this grid it was `https://github.com/Ricardo95RM`.
- `ref_img`: We want to have a reference image that makes it convenient for users to get a quick visual feel for what geography the grid refers to. In the Ecuador example, the user uploaded a reference image attached to the GitHub issue, found [here](https://camo.githubusercontent.com/7eabd24db749e5335f13c911df65f15516c10bef/68747470733a2f2f65637561646f726e6f7469636961732e636f6d2f77702d636f6e74656e742f75706c6f6164732f323031372f30342f70726f76696e636961732d65637561646f722e6a7067). In this case, we simply need to add the URL associated with this image to the grid list entry.

Note: In the past, we encouraged users to upload a reference image in their GitHub issues. However, GitHub has since [made it difficult to publicly access images in GitHub issues](https://www.reddit.com/r/github/comments/13foas2/github_no_longer_allows_image_uploads_to_be_public/) so we need to find an anternative free public place to store reference images for new grids, ideally one that we feel is going to be around for a long time. It is preferred for a reference image to be uploaded somewhere that we feel confident that it will stick around, vs. just providing a direct link to the original source of the image, which could change or disappear.

### Validating a Grid

If you want to validate a grid csv data file that you have created, you can install the R `{geofacet}` package, read the csv file into R, and call  `geofacet::grid_preview()` on it. This will check that the grid is valid (checks column names, unique row/col values, etc.), and will plot the grid so that you can visually verify that it looks good (sometimes people will submit grids that are just rectangular and don’t look like they did anything to actually create a grid).
