import matplotlib.pylab as plt
import numpy as np
import hhtpywrapper.matlab as matlab


class HSA():
    def __init__(self, imfs, dt, ifmethod='hilbtm', normmethod='pchip', nfilter=0):
        self.mlab = matlab.start_mlab()
        fa_res = self.mlab.run_func('fa', imfs, dt, ifmethod, normmethod, nfilter, nargout=2)
        fa = fa_res['result']
        self.imfs = imfs
        self.ifmethod = ifmethod
        self.normmethod = normmethod
        if len(fa[0]) != 1:
            ifreq = fa[0]
            iamp = fa[1]
        else:
            ifreq = fa[0].T
            iamp = fa[1].T
        self.ifreq = ifreq
        self.iamp = iamp

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
        res_nnspe = self.mlab.run_func(runfunc, self.imfs, time[0], time[-1], fres, tres,
                                  fstart, fend, tstart, tend, self.ifmethod,
                                  self.normmethod, 0, 0, nargout=3)
        nt = res_nnspe['result'][0]
        tscale = res_nnspe['result'][1].reshape(-1)
        fscale = res_nnspe['result'][2].reshape(-1)
        res_fspecial = self.mlab.run_func('fspecial', 'gaussian', hsize, sigma)
        q = res_fspecial['result']
        res_filter2 = self.mlab.run_func('filter2', q, nt)
        res_nsu = self.mlab.run_func('filter2', q, res_filter2['result'])
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
