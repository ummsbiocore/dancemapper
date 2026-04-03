[![Static Badge](https://img.shields.io/badge/DOI-10.5281/zenodo.5847984-blue?style=for-the-badge)](https://zenodo.org/records/5847984)

DanceMapper is a bioinformatics pipeline for analyzing high-throughput RNA structure probing data (e.g., SHAPE-MaP). It automates read preprocessing, alignment, mutation counting, and reactivity calculation, producing per-nucleotide reactivity profiles suitable for RNA secondary structure modeling.

Version 1.1 integrates updated workflows for improved read handling and background correction, and it bundles RingMapper 1.3 for detection and analysis of correlated mutation events (“RINGs”) that report on RNA tertiary interactions. Together, these tools provide a comprehensive framework for mapping RNA structure at both secondary and tertiary levels.


### Required Inputs

#### profile
* **Description:** Profile file containing SHAPE reactivity profile or similar structured data.  
* **Format:** File (e.g., `.txt` or `.prof`).  

#### modified_mut
* **Description:** Parsed mutations file from the modified sample.  
* **Format:** File (e.g., `.mut`).  

#### name
* **Description:** Sample name or identifier used for output labeling.  
* **Format:** String (automatically inferred from profile base name).  

---

### Optional Inputs

#### untreated_mut
* **Description:** Parsed mutations file from untreated (control) sample.  
* **Format:** File (e.g., `.mut`) or placeholder (`NO_FILE_*`).  

#### min_cov_ceck & min_coverage
* **Description:** Minimum read coverage filter.  
* **Format:** `min_cov_ceck` is a Boolean string; `min_coverage` is an integer threshold.  
* **Options (min_cov_ceck):** `"true"`, `"false"`.  

#### fit_check
* **Description:** Enable fitting mode during analysis.  
* **Format:** Boolean string.  

#### pair_check
* **Description:** Enable pair-mapping mode.  
* **Format:** Boolean string.  

#### ring_check
* **Description:** Enable ring-mapping mode.  
* **Format:** Boolean string.  

#### minrxbg
* **Description:** Minimum reactive background value.  
* **Format:** Float or integer.  

#### chisq_cut
* **Description:** Chi-squared cut-off for analysis filtering.  
* **Format:** Float or integer.  

#### undersample
* **Description:** Undersampling factor or method for data balancing.  
* **Format:** Integer or float.  

#### ff_check & forcefitN
* **Description:** Force-fit number of clusters.  
* **Format:** `ff_check` is a Boolean string; `forcefitN` is an integer.  

#### maskG_check, maskU_check, maskN_check
* **Description:** Mask specific nucleotides during analysis.  
* **Format:** Boolean string for each.  

#### other_parameters
* **Description:** Pass any additional parameters directly to DanceMaPper.  
* **Format:** String (command-line arguments).  
* **Details:**
```
options for fitting data:
  --maxcomponents MAXCOMPONENTS: Maximum number of components to fit (default=5)
  --trials TRIALS: 	Maximum number of fitting trials at each component number (default=50)
  --badcol_cutoff BADCOL_CUTOFF: Inactivate column after it causes a failure X number of times *after* a valid soln has already been found (default=5)
  --writeintermediates  Write each BM solution to file with specified prefix. Will be saved as prefix-intermediate-[component]-[trial].bm
  --priorWeight PRIORWEIGHT: Weight of prior on Mu (default=0.01). Prior = priorWeight*readDepth*bgRate at each nt. Prior is disabled by passing -1, upon which a naive prior is used.
options for performing RING/PAIR analysis on clustered reads:
  --window WINDOW: Window size for computing correlations (default=1)
  --readprob_cut READPROB_CUT: Posterior probability cutoff for assigning reads for inclusion in ring/pairmap analysis. Reads must haveposterior prob greater than the cutoff (default=0.9). If set to -1, assign reads using maximum a posteriori (MAP) criteria
  --mincount MINCOUNT: Set mincount cutoff for RING/PAIR-MaP analysis (default = 10)
  --pm_secondary_reactivity PM_SECONDARY_REACTIVITY: Set secondary_reactivity cutoff for pairmapper analysis (default = 0.4)
  --inclwindow: Include considered windows in read probability calculation and assignment. By default windows are EXCLUDED from calculations
optional arguments:
  --readfromfile READFROMFILE: Read in solved BM model from BM file
  --ignore_untreated: Ignore untreated mutation rates from profile.txt file. If ShapeMapper was run without an untreated sample, this argument is superfluous. Untreated rates are used for establishing priors during fitting, and computing normalized rates)
  --oldDMSnorm: Use old style (pre-eDMS) normalization
  --suppressverbal: Suppress verbal output
```
---

### Cluster Analysis (Optional Secondary Process)

#### plot_type
* **Description:** Type of plot generated for cluster analysis.  
* **Format:** String.  

#### bm_react
* **Description:** Selects input format for plotting (bm or react).  
* **Format:** String.  
* **Options:** `"bm"`, `"react"`.  

#### fold_other_params
* **Description:** Extra parameters passed to `foldClusters.py`.  
* **Format:** String.  

#### plot_other_params
* **Description:** Extra parameters passed to `plotClusters.py`.  
* **Format:** String.  

---
