from pymatbridge import Matlab
import matplotlib.pylab as plt
import os
import numpy as np

mlab = Matlab()
mlab.start()
dir_path = os.path.dirname(os.path.realpath(__file__))
dir_list = ['/HHT_MATLAB_package', '/HHT_MATLAB_package/EEMD',
          '/HHT_MATLAB_package/checkIMFs', '/HHT_MATLAB_package/HSA']
for d in dir_list:
    res = mlab.run_func('addpath', dir_path + d)

class HSA():
    def __init__(self, imfs, dt, ifmethod='hilbtm', normmethod='pchip', nfilter=0):
        fa_res = mlab.run_func('fa', imfs, dt, ifmethod, normmethod, nfilter, nargout=2)
        fa = fa_res['result']
        self.imfs = imfs
        self.ifmethod = ifmethod
        self.normmethod = normmethod
        self.ifreq = fa[0]
        self.iamp = fa[1]

    def plot_hs(self, time, trange, frange, tres, fres, hsize, sigma,
                tunit='s', funit='Hz', colorbar = 'energy', savefig_name=''):
        time = time - time[0]
        tstart = trange[0]
        tend = trange[1]
        fstart = frange[0]
        fend = frange[1]
        if colorbar == 'amplitude':
            runfunc = 'nnspa'
        elif colorbar == 'energy':
            runfunc = 'nnspe'
        res_nnspe = mlab.run_func(runfunc, self.imfs, time[0], time[-1], fres, tres,
                                  fstart, fend, tstart, tend, self.ifmethod,
                                  self.normmethod, 0, 0, nargout=3)
        nt = res_nnspe['result'][0]
        tscale = res_nnspe['result'][1].reshape(-1)
        fscale = res_nnspe['result'][2].reshape(-1)
        res_fspecial = mlab.run_func('fspecial', 'gaussian', hsize, sigma)
        q = res_fspecial['result']
        res_filter2 = mlab.run_func('filter2', q, nt)
        res_nsu = mlab.run_func('filter2', q, res_filter2['result'])
        nsu = res_nsu['result']
        fig = plt.figure()
        ax = plt.axes()
        hs = ax.pcolormesh(tscale, fscale, nsu ** 0.5)
        cb = plt.colorbar(hs)
        cb.set_label('Gaussian smoothing ' + colorbar)
        ax.set_ylabel('Frequency (' + funit + ')')
        ax.set_xlabel('Time (' + tunit + ')')
        if savefig_name == '':
            plt.show()
        else:
            plt.savefig(savefig_name, format='eps', dpi=1000)
