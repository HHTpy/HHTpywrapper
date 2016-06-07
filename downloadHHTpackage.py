import os
import shutil
import urllib.request
from pyunpack import Archive

# Define base paths for directories and create directories
HHT_MATLAB_package_root = "./HHT_MATLAB_package/"
EMD_dir = HHT_MATLAB_package_root + "EMD/"
HT_dir = HHT_MATLAB_package_root + "HT/"
checkIMFs_dir = HHT_MATLAB_package_root + "checkIMFs/"
os.mkdir(HT_dir)
os.mkdir(checkIMFs_dir)

# Download and extract the HHT MATLAB package from RCADA website
urllib.request.urlretrieve('http://rcada.ncu.edu.tw/FEEMD.rar', 'EEMD.rar')
urllib.request.urlretrieve('http://rcada.ncu.edu.tw/Matlab%20runcode.zip',
                           'Matlab_runcode.zip')
Archive('Matlab_runcode.zip').extractall('./')
Archive('EEMD.rar').extractall(HHT_MATLAB_package_root)

# Rename directories/files & delete unnecessary files
os.rename("Matlab runcode", "Matlab_runcode")
os.rename("Matlab_runcode/eemd.m", "Matlab_runcode/eemd_old.m")
os.rename("Matlab_runcode/FAimphilbert.m", "Matlab_runcode/FAimpHilbert.m")
os.rename(HHT_MATLAB_package_root + "FEEMD", EMD_dir)
os.remove("Matlab_runcode/endprocess1.p")
os.remove("Matlab_runcode/ex02d.m")
os.remove("Matlab_runcode/LOD78.csv")
os.remove("Matlab_runcode/LOD-imf.csv")
os.remove("Matlab_runcode/NCU2009V1.txt")
os.remove("Matlab_runcode/test.m")
os.remove(EMD_dir + "ref.pdf")
os.remove(EMD_dir + "example_eemd.m")
os.remove(EMD_dir + "BFVL.mat")

# Rearrange files
shutil.move(HHT_MATLAB_package_root + "feemd_post_pro.m", EMD_dir)
shutil.move(HHT_MATLAB_package_root + "meemd.m", EMD_dir)
shutil.move("Matlab_runcode/eemd_old.m", EMD_dir)

checkIMFs_mfile_list = ["ratio1.m", "ratioa.m", "findEEfsp.m", "findEE.m",
                        "signiplotIMF.m", "significanceIMF.m", "ifndq.m",
                        "confidenceLine.m", "dist_value.m", "extrema.m"]
for files in checkIMFs_mfile_list:
    shutil.move("./Matlab_runcode/" + files, checkIMFs_dir)

HT_mfile_list = os.listdir("./Matlab_runcode/")
for files in HT_mfile_list:
    shutil.move("./Matlab_runcode/" + files, HT_dir)

# Delete unnecessary directories/files
os.remove("EEMD.rar")
os.remove("Matlab_runcode.zip")
os.rmdir("Matlab_runcode")
