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
