# COTAN

<details>

* Version: 2.8.1
* GitHub: https://github.com/seriph78/COTAN
* Source code: https://github.com/cran/COTAN
* Date/Publication: 2025-04-30
* Number of recursive dependencies: 269

Run `revdepcheck::revdep_details(, "COTAN")` for more info

</details>

## In both

*   checking examples ... ERROR
    ```
    Running examples in ‘COTAN-Ex.R’ failed
    The error most likely occurred in:
    
    > ### Name: Conversions
    > ### Title: Data class conversions
    > ### Aliases: Conversions convertToSingleCellExperiment
    > ###   convertFromSingleCellExperiment
    > 
    > ### ** Examples
    > 
    ...
    >   obj <- proceedToCoex(obj, calcCoex = FALSE, saveObj = FALSE)
    Cotan analysis functions started
    Working on [600] genes and [1200] cells
    dispersion | min: 0.2197265625 | max: 6.08056640625 | % negative: 0
    > 
    >   sce <- convertToSingleCellExperiment(objCOTAN = obj)
    Error in validObject(.Object) : 
      invalid class “SingleCellExperiment” object: superclass "ExpData" not defined in the environment of the object's class
    Calls: convertToSingleCellExperiment ... .rse_to_sce -> new -> initialize -> initialize -> validObject
    Execution halted
    ```

*   checking tests ...
    ```
      Running ‘outputTestDatasetCreation.R’
      Running ‘spelling.R’
      Running ‘testthat.R’
     ERROR
    Running the tests in ‘tests/testthat.R’ failed.
    Last 13 lines of output:
      Backtrace:
          ▆
       1. ├─Seurat::as.SingleCellExperiment(sratObj) at test-convertSingleCellExperiment.R:81:3
       2. └─Seurat:::as.SingleCellExperiment.Seurat(sratObj)
    ...
       4.     └─SingleCellExperiment (local) asMethod(object)
       5.       └─SingleCellExperiment:::.rse_to_sce(as(from, "RangedSummarizedExperiment"))
       6.         └─methods::new(...)
       7.           ├─methods::initialize(value, ...)
       8.           └─methods::initialize(value, ...)
       9.             └─methods::validObject(.Object)
      
      [ FAIL 2 | WARN 2 | SKIP 0 | PASS 485 ]
      Error: Test failures
      Execution halted
    ```

*   R CMD check timed out
    

*   checking dependencies in R code ... NOTE
    ```
    'library' or 'require' call to ‘torch’ in package code.
      Please use :: or requireNamespace() instead.
      See section 'Suggested packages' in the 'Writing R Extensions' manual.
    Unexported object imported by a ':::' call: ‘ggplot2:::ggname’
      See the note in ?`:::` about the use of this operator.
    ```

*   checking R code for possible problems ... NOTE
    ```
    mergeUniformCellsClusters : fromMergedName: warning in
      vapply(currentClNames, function(clName, mergedName) {: partial
      argument match of 'FUN.VAL' to 'FUN.VALUE'
    mergeUniformCellsClusters : fromMergedName: warning in
      return(str_detect(mergedName, clName)): partial argument match of
      'FUN.VAL' to 'FUN.VALUE'
    mergeUniformCellsClusters : fromMergedName: warning in }, FUN.VAL =
      logical(1L), mergedClName): partial argument match of 'FUN.VAL' to
      'FUN.VALUE'
    GDIPlot: no visible binding for global variable ‘sum.raw.norm’
    ...
    heatmapPlot: no visible binding for global variable ‘coex’
    mitochondrialPercentagePlot: no visible binding for global variable
      ‘mit.percentage’
    scatterPlot: no visible binding for global variable ‘.x’
    screePlot: no visible binding for global variable ‘PC’
    screePlot: no visible binding for global variable ‘Variance’
    Undefined global functions or variables:
      .x CellNumber Cluster Condition ExpGenes GDI PC PC1 PC2 Variance coex
      g2 group keys means mit.percentage n nu obj sum.raw.norm type types
      values violinwidth width x xmax xmaxv xminv y
    ```

# SpatialFeatureExperiment

<details>

* Version: 1.10.0
* GitHub: https://github.com/pachterlab/SpatialFeatureExperiment
* Source code: https://github.com/cran/SpatialFeatureExperiment
* Date/Publication: 2025-04-15
* Number of recursive dependencies: 270

Run `revdepcheck::revdep_details(, "SpatialFeatureExperiment")` for more info

</details>

## In both

*   checking whether package ‘SpatialFeatureExperiment’ can be installed ... ERROR
    ```
    Installation failed.
    See ‘/Users/nteetor/haufinch/projects/zeallot/revdep/checks.noindex/SpatialFeatureExperiment/new/SpatialFeatureExperiment.Rcheck/00install.out’ for details.
    ```

## Installation

### Devel

```
* installing *source* package ‘SpatialFeatureExperiment’ ...
** this is package ‘SpatialFeatureExperiment’ version ‘1.10.0’
** using staged installation
** R
** data
** inst
** byte-compile and prepare package for lazy loading
Error in cliDef@subclasses : 
  no applicable method for `@` applied to an object of class "NULL"
Error in setClass("SpatialFeatureExperiment", contains = "SpatialExperiment") : 
  error in contained classes ("SpatialExperiment") for class “SpatialFeatureExperiment”; class definition removed from ‘SpatialFeatureExperiment’
Error: unable to load R code in package ‘SpatialFeatureExperiment’
Execution halted
ERROR: lazy loading failed for package ‘SpatialFeatureExperiment’
* removing ‘/Users/nteetor/haufinch/projects/zeallot/revdep/checks.noindex/SpatialFeatureExperiment/new/SpatialFeatureExperiment.Rcheck/SpatialFeatureExperiment’


```
### CRAN

```
* installing *source* package ‘SpatialFeatureExperiment’ ...
** this is package ‘SpatialFeatureExperiment’ version ‘1.10.0’
** using staged installation
** R
** data
** inst
** byte-compile and prepare package for lazy loading
Error in cliDef@subclasses : 
  no applicable method for `@` applied to an object of class "NULL"
Error in setClass("SpatialFeatureExperiment", contains = "SpatialExperiment") : 
  error in contained classes ("SpatialExperiment") for class “SpatialFeatureExperiment”; class definition removed from ‘SpatialFeatureExperiment’
Error: unable to load R code in package ‘SpatialFeatureExperiment’
Execution halted
ERROR: lazy loading failed for package ‘SpatialFeatureExperiment’
* removing ‘/Users/nteetor/haufinch/projects/zeallot/revdep/checks.noindex/SpatialFeatureExperiment/old/SpatialFeatureExperiment.Rcheck/SpatialFeatureExperiment’


```
# tfevents

<details>

* Version: 0.0.4
* GitHub: https://github.com/mlverse/tfevents
* Source code: https://github.com/cran/tfevents
* Date/Publication: 2024-06-27 12:40:02 UTC
* Number of recursive dependencies: 83

Run `revdepcheck::revdep_details(, "tfevents")` for more info

</details>

## In both

*   checking whether package ‘tfevents’ can be installed ... ERROR
    ```
    Installation failed.
    See ‘/Users/nteetor/haufinch/projects/zeallot/revdep/checks.noindex/tfevents/new/tfevents.Rcheck/00install.out’ for details.
    ```

## Installation

### Devel

```
* installing *source* package ‘tfevents’ ...
** this is package ‘tfevents’ version ‘0.0.4’
** package ‘tfevents’ successfully unpacked and MD5 sums checked
** using staged installation
Homebrew 4.4.3
Using PKG_CFLAGS=-I/opt/homebrew/include
Using PKG_LIBS=-L/opt/homebrew/lib -lprotobuf
Using C++17 compiler: clang++ -arch arm64 -std=gnu++17
------------------------------[ ANTICONF ]-----------------------------
Configuration failed to find protobuf. Try installing:
...
is unavailable you can set INCLUDE_DIR and LIB_DIR manually via:
R CMD INSTALL --configure-vars='INCLUDE_DIR=... LIB_DIR=...'
----------------------------[ ERROR MESSAGE ]----------------------------
<stdin>:1:10: fatal error: 'google/protobuf/message.h' file not found
    1 | #include <google/protobuf/message.h>
      |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~
1 error generated.
------------------------------------------------------------------------
ERROR: configuration failed for package ‘tfevents’
* removing ‘/Users/nteetor/haufinch/projects/zeallot/revdep/checks.noindex/tfevents/new/tfevents.Rcheck/tfevents’


```
### CRAN

```
* installing *source* package ‘tfevents’ ...
** this is package ‘tfevents’ version ‘0.0.4’
** package ‘tfevents’ successfully unpacked and MD5 sums checked
** using staged installation
Homebrew 4.4.3
Using PKG_CFLAGS=-I/opt/homebrew/include
Using PKG_LIBS=-L/opt/homebrew/lib -lprotobuf
Using C++17 compiler: clang++ -arch arm64 -std=gnu++17
------------------------------[ ANTICONF ]-----------------------------
Configuration failed to find protobuf. Try installing:
...
is unavailable you can set INCLUDE_DIR and LIB_DIR manually via:
R CMD INSTALL --configure-vars='INCLUDE_DIR=... LIB_DIR=...'
----------------------------[ ERROR MESSAGE ]----------------------------
<stdin>:1:10: fatal error: 'google/protobuf/message.h' file not found
    1 | #include <google/protobuf/message.h>
      |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~
1 error generated.
------------------------------------------------------------------------
ERROR: configuration failed for package ‘tfevents’
* removing ‘/Users/nteetor/haufinch/projects/zeallot/revdep/checks.noindex/tfevents/old/tfevents.Rcheck/tfevents’


```
