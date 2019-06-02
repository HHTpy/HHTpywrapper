from setuptools import setup, find_packages
import os
import shutil
import urllib.request
from pyunpack import Archive
from pymatbridge import Matlab

NAME = 'hhtpywrapper'

# VERSION should be PEP440 compatible (https://www.python.org/dev/peps/pep-0440/)
VERSION = '0.1.dev'

# Define base paths for directories and create directories
HHT_MATLAB_package_root = './hhtpywrapper/HHT_MATLAB_package/'
EEMD_dir = HHT_MATLAB_package_root + 'EEMD/'
HSA_dir = HHT_MATLAB_package_root + 'HSA/'
checkIMFs_dir = HHT_MATLAB_package_root + 'checkIMFs/'
os.mkdir(HHT_MATLAB_package_root)
os.mkdir(HSA_dir)
os.mkdir(checkIMFs_dir)

# Download and extract the HHT MATLAB package from the RCADA website
print('* Downloading & extracting the HHT MATLAB package...')
urllib.request.urlretrieve('http://in.ncu.edu.tw/ncu34951/FEEMD.rar', 'EEMD.rar')
urllib.request.urlretrieve('http://in.ncu.edu.tw/ncu34951/Matlab_runcode.zip',
                           'Matlab_runcode.zip')
Archive('Matlab_runcode.zip').extractall('./')
Archive('EEMD.rar').extractall(EEMD_dir, auto_create_dir=True)
print('...Done.')

# Rename directories/files & delete unnecessary files
print('* Rearranging directories & files...')
os.rename('Matlab runcode', 'Matlab_runcode')
os.rename('Matlab_runcode/eemd.m', 'Matlab_runcode/eemd_old.m')
os.rename('Matlab_runcode/FAimphilbert.m', 'Matlab_runcode/FAimpHilbert.m')
os.remove('Matlab_runcode/endprocess1.p')
os.remove('Matlab_runcode/ex02d.m')
os.remove('Matlab_runcode/LOD78.csv')
os.remove('Matlab_runcode/LOD-imf.csv')
os.remove('Matlab_runcode/NCU2009V1.txt')
os.remove('Matlab_runcode/test.m')
os.remove(EEMD_dir + 'ref.pdf')
os.remove(EEMD_dir + 'example_eemd.m')
os.remove(EEMD_dir + 'BFVL.mat')

# Rearrange files
shutil.move('Matlab_runcode/eemd_old.m', EEMD_dir)

checkIMFs_mfile_list = ['ratio1.m', 'ratioa.m', 'findEEfsp.m', 'findEE.m',
                        'signiplotIMF.m', 'significanceIMF.m', 'ifndq.m',
                        'confidenceLine.m', 'dist_value.m', 'extrema.m']
for files in checkIMFs_mfile_list:
    shutil.move('./Matlab_runcode/' + files, checkIMFs_dir)

HSA_mfile_list = os.listdir('./Matlab_runcode/')
for files in HSA_mfile_list:
    shutil.move('./Matlab_runcode/' + files, HSA_dir)

# Delete unnecessary directories/files
os.remove('EEMD.rar')
os.remove('Matlab_runcode.zip')
os.rmdir('Matlab_runcode')
print('...Done.')

# Check the MATLAB version & replace the deprecated function with the new one.
mlab = Matlab()
print('* Checking your MATLAB version...')
mlab.start()
mlab.run_code('v = version;')
version = mlab.get_variable('v')
mlab.stop()
print('Your MATLAB version is: ' + version)
version = version.split('.')
if int(version[0]) >= 8:
    print('The function "getDefaultStream" in eemd.m is no longer be used ' +
          'in your MATLAB version.')
    print('* Replacing it with the function "getGlobalStream"...')
    with open(EEMD_dir + 'rcada_eemd.m', 'r', encoding='iso-8859-1') as infile:
            data = infile.read().replace('getDefaultStream', 'getGlobalStream')
    infile.close()
    with open(EEMD_dir + 'rcada_eemd2.m', 'w',encoding='iso-8859-1') as outfile:
        outfile.write(data)
    outfile.close()
    os.remove(EEMD_dir + 'rcada_eemd.m')
    os.rename(EEMD_dir + 'rcada_eemd2.m', EEMD_dir + 'rcada_eemd.m')
    print('...Done.')

print('* All done.')

setup(name=NAME,
      version=VERSION,
      description='Python Wrapper for Hilbert–Huang Transform MATLAB Package',
      install_requires=['numpy', 'scipy', 'matplotlib'],
      author='Yi-Hao Su',
      author_email='yhsu@astro.ncu.edu.tw',
      license='MIT',
      packages=find_packages(),
      url='https://github.com/HHTpy/HHTpywrapper',
      long_description='hhtpywrapper is a python interface to call Hilbert–Huang Transform MATLAB package',
      zip_safe=False,
      package_data={
        'hhtpywrapper': ['HHT_MATLAB_package/EEMD/*', 'HHT_MATLAB_package/checkIMFs/*',
                         'HHT_MATLAB_package/HSA/*', 'Input_data/*',
                         'addpaths.m', 'examples.ipynb'],
      },
)
