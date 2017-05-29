Python Wrapper for Hilbert–Huang Transform MATLAB Package
=========================================================
 [![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://github.com/HHTpy/HHTpywrapper/blob/master/LICENSE)

HHTpywrapper is a python interface to call the [Hilbert–Huang Transform (HHT) MATLAB package](http://rcada.ncu.edu.tw/research1.htm). HHT is a time-frequency analysis method to adaptively decompose a signal, that could be generated by non-stationary and/or nonlinear processes, into basis components at different timescales, and then Hilbert transform these components into instantaneous phases, frequencies and amplitudes as functions of time. HHT has been successfully applied to analyzing X-ray quasi-periodic oscillations (QPOs) from the active galactic nucleus
RE J1034+396 ([Hu et al. 2014](http://adsabs.harvard.edu/abs/2014ApJ...788...31H)) and two black hole X-ray binaries, XTE J1550–564 ([Su et al. 2015](http://adsabs.harvard.edu/abs/2015ApJ...815...74S)) and GX 339-4 (Su et al. 2017). HHTpywrapper provides
examples of reproducing HHT analysis results in [Su et al. (2015)](http://adsabs.harvard.edu/abs/2015ApJ...815...74S) and Su et al. (2017). This project is originated from [Astro Hack Week 2015](https://github.com/AstroHackWeek/AstroHackWeek2015/).

Requirements
------------
- Linux or Windows operating system (The fast EEMD code in the HHT MATLAB package has not supported Mac yet)
- Python 3.x+
- MATLAB
- Numpy
- Scipy
- Astropy
- Matplotlib
- [pymatbridge](https://github.com/arokem/python-matlab-bridge) (A simple Python => MATLAB(R) interface and a matlab magic for ipython)
- [pyunpack](https://pypi.python.org/pypi/pyunpack) and [patool](http://wummel.github.io/patool/) (For extracting the .zip/.rar HHT MATLAB package files)
- UNZIP and UNRAR (sudo apt-get install unzip unrar)

Installation
------------
1. Clone this project from GitHub:

        $ git clone https://github.com/HHTpy/HHTpywrapper.git

2. In the project directory, install required packages:

        $ pip install -r requirements.txt

3. In the project directory, execute:

        $ python setup.py install

Examples of Package Usage
-----
- [Example of reproducing HHT analysis results in Su et al. 2015](https://github.com/HHTpy/HHTpywrapper/blob/master/notebooks/example_Su_etal2015.ipynb)
- [Example of reproducing HHT analysis results in Su et al. 2017](https://github.com/HHTpy/HHTpywrapper/blob/master/notebooks/example_Su_etal2017.ipynb)
- Example of characterizing intermittency of an intermittent, frequency varying oscillation (To be added)

Directory Structure (To be rewritten)
-------------------
- HHTpywrapper/ :

  This is the root directory, including the directory of HHT MATLAB package and the Python API for using the MATLAB package. You need to run downloadHHTpackage.py first to download, extract and rearrange these HHT MATLAB files.

- HHTpywrapper/Input_data/ :

   You can put your input files in this directory.

- HHTpywrapper/HHT_MATLAB_package/ :

   This is the base directory of HHT MATLAB package. There are three subdirectories: EMD, checkIMFs and HT.

- HHTpywrapper/HHT_MATLAB_package/EMD/ :

   This directory collects MATLAB M-files for decomposing a signal into basis components (intrinsic mode functions, IMFs) defined by the signal itself. This adaptive decomposition method is called empirical mode decomposition (EMD). The M-files accomplished the most recently developed modified version of EMD, fast complementary ensemble empirical mode decomposition (CEEMD). Reference:
     * [The empirical mode decomposition and the Hilbert spectrum for nonlinear and non-stationary time series analysis](http://rcada.ncu.edu.tw/ref/reference002.pdf)
     * [Ensemble Empirical Mode Decomposition: a noise-assisted data analysis method](http://rcada.ncu.edu.tw/ref/reference007.pdf)
     * [On the computational complexity of the empirical mode decomposition algorithm](http://www.sciencedirect.com/science/article/pii/S0378437114000247)


- HHTpywrapper/HHT_MATLAB_package/checkIMFs/ :

   This directory collects MATLAB M-files for checking IMF properties, including significance, index of orthogonality, and excessive extrema value. Reference:
   * [The empirical mode decomposition and the Hilbert spectrum for nonlinear and non-stationary time series analysis](http://rcada.ncu.edu.tw/ref/reference002.pdf)
   * [A confidence limit for the Empirical Mode Decomposition and Hilbert Spectral Analysis](http://rcada.ncu.edu.tw/ref/reference004.pdf)
   * [A study of the characteristics of white noise using the empirical mode decomposition method](http://rcada.ncu.edu.tw/ref/reference006.pdf)
   * [Ensemble Empirical Mode Decomposition: a noise-assisted data analysis method](http://rcada.ncu.edu.tw/ref/reference007.pdf)
   * [On Intrinsic Mode Function](http://rcada.ncu.edu.tw/ref/reference013.pdf)


- HHTpywrapper/HHT_MATLAB_package/HT/ :

   This directory collects MATLAB M-files for calculating instantaneous amplitudes, phases and frequencies of IMFs. Reference:
   * [The empirical mode decomposition and the Hilbert spectrum for nonlinear and non-stationary time series analysis](http://rcada.ncu.edu.tw/ref/reference002.pdf)
   * [On instantaneous frequency](http://rcada.ncu.edu.tw/ref/reference005.pdf)

Important Links
---------------
- [HHT MATLAB package](http://rcada.ncu.edu.tw/research1.htm)
- [References of HHT](http://rcada.ncu.edu.tw/research1_clip_reference.htm)

Other HHT-related Python Codes
------------------------------
- [PyHHT](https://github.com/jaidevd/pyhht) ; [PyHHT’s documentation](http://pyhht.readthedocs.io/en/latest/index.html) (by Jaidev Deshpande)
- [pyeemd](http://pyeemd.readthedocs.io/en/latest/) (by Perttu Luukko)
- [Python implementation of EMD/EEMD](https://laszukdawid.com/codes/) (by Dawid Laszuk)

Authors
-------
- [Yi-Hao Su](https://github.com/YihaoSu) (yhsu@astro.ncu.edu.tw) <br>
HHTpywrapper is my project during the [Astro Hack Week 2015](https://github.com/AstroHackWeek/AstroHackWeek2015/). Welcome any contributions and suggestions!
