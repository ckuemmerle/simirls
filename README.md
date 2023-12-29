
# Recovering Simultaneously Structured Data via Non-Convex Iteratively Reweighted Least Squares - SimIRLS

[Christian Kümmerle](http://ckuemmerle.com) and [Johannes Maly](https://johannes-maly.github.io)

This repository contains the code for the *NeurIPS 2023* paper [*Recovering Simultaneously Structured Data via Non-Convex Iteratively Reweighted Least Squares*](https://openreview.net/pdf?id=50hs53Zb3w) [[KM23]](#KM23), which studies an iteratively reweighted least squares approach (`IRLS` or `IRLS-LRRS`) based on a smoothing strategy and a non-convex surrogate modelling for the problem of recovering simultaneously low-rank and row-sparse matrices from linear masureuments.

[[arXiv]](https://arxiv.org/pdf/2306.04961.pdf) [[Paper at OpenReview]](https://openreview.net/pdf?id=50hs53Zb3w)

Reproducibile experiments and algorithmic implementations are provided in MATLAB. 

### Citation
Please cite this work as:

```
@inproceedings{KuemmerleMaly2023,
 title = {Recovering Simultaneously Structured Data via Non-Convex Iteratively Reweighted Least Squares},
 author = {K{\"u}mmerle, Christian and Maly, Johannes},
 booktitle = {Advances in Neural Information Processing Systems (NeurIPS 2023)},
 volume = {36},
 year = {2023}
}

```

## Installation
   
1. Obtain files of repository via either:
  -  Clone repository via `git clone --recurse-submodules https://github.com/ckuemmerle/simirls.git` (note the flag `--recurse-submodules` due to usage of submodule [riemannian_thresholding](https://github.com/ckuemmerle/riemannian_thresholding)))
  -  Download files and unpack into your MATLAB path, then download [riemannian_thresholding](https://github.com/ckuemmerle/riemannian_thresholding) and unpack into `/algorithms/riemannian_thresholding`.  
2. Run `setup.m` from main folder of repository as current MATLAB folder.

## Usage
* `demo_LRRS_Gaussian_rank1_IRLS`: Minimal example of how to use `IRLS-LRRS` [[KM23]](#KM23) to solve a randomly generated simultaneous low-rank and row-sparse recovery problem (Gaussian measurements).
* `demo_LRRS_Gaussian_rank1`: Also runs `SPF` [[LWB18]](#LWB18) and `RiemAdaIHT` [[EKPU23]](#EKPU23) alongside of `IRLS-LRRS` for problem above.
* `run_single_Example_LRRS`: Run to choose one of the problem setups of folder `/Examples/` via text input. Use repository's main folder as current folder when doing this.

### Subfolders
* `/Examples`: Contains files to define the parameters various example problem setups.
* `/algorithms`: Contains algorithm implementations
* `/experiment_setup`: Code to setup and run experiments
* `/experiments`: Scripts to load data and reproduce experiments of Figures 1-7 in [[KM23]](#KM23)
* `/results`: Plots containing experimental results of Figures 1-7 of [[KM23]](#KM23)
* `/utilities`: Contains various helper functions

Please contact the authors [[KM23]](#KM23) for access to the original data for phase transitions experiments of Figure 1-2, 4-5 in [[KM23]](#KM23).

## List of algorithms
* `IRLS` (or `IRLS-LRRS`): *Iteratively Reweighted Least Squares (for Low-Rank and Row-Sparse recovery)*, Algorithm 1 of [[KM23]](#KM23).
* `SPF`: *Sparse Power Factorization* [[LWB18]](#LWB18) in the version of Algorithm 4 of [[LWB18]](#LWB18) (`rSPF_HTP`).
* `RiemAdaIHT`: *Adaptive Riemannian Iterative Hard Thresholding* as used in [[EKPU23]](#EKPU23), cf. also [repository here](https://github.com/maxpfeffer/riemannian_thresholding).

## References
 - **[KM23]** Christian Kümmerle and Johannes Maly, [**Recovering Simultaneously Structured Data via Non-Convex Iteratively Reweighted Least Squares**](https://openreview.net/pdf?id=50hs53Zb3w). _NeurIPS 2023_, 2023. <a name="KM23"></a>
 - **[EKPU23]** Henrik Eisenmann, Felix Krahmer, Max Pfeffer, and André Uschmajew. [**Riemannian thresholding methods for row-sparse and low-rank matrix recovery**](https://doi.org/10.1007/s11075-022-01433-5). _Numerical Algorithms_, 93 (2):669–693, 2023. <a name="EKPU23"></a>
 - **[LWB18]** Kiryung Lee, Yihong Wu, and Yoram Bresler. [**Near-optimal compressed sensing of a class of sparse low-rank matrices via sparse power factorization**](https://doi.org/10.1109/TIT.2017.2784479). IEEE Transactions on Information Theory, 64(3):1666–1698, 2018. <a name="LWB18"></a>
