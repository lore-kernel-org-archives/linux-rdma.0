From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: [PATCH v4 4/6] infiniband: cxgb4: Eliminate duplicate barriers on weakly-ordered archs
Date: Thu, 22 Mar 2018 09:40:25 -0500
Message-ID: <03d201d3c1eb$b71fb460$255f1d20$@opengridcomputing.com>
References: <1521514068-8856-5-git-send-email-okaya@codeaurora.org> <201803221430.P43GJl9U%fengguang.wu@intel.com> <3664b253c730dbf83f4528acaedb3a88@codeaurora.org> <3e9c006e4541acbce11743dbda553e84@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3e9c006e4541acbce11743dbda553e84@codeaurora.org>
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
To: okaya@codeaurora.org, 'kbuild test robot' <lkp@intel.com>
Cc: kbuild-all@01.org, linux-rdma@vger.kernel.org, timur@codeaurora.org, sulrich@codeaurora.org, linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 'Steve Wise' <swise@chelsio.com>, 'Doug Ledford' <dledford@redhat.com>, 'Jason Gunthorpe' <jgg@ziepe.ca>, linux-kernel@vger.kernel.org, 'Casey Leedom' <leedom@chelsio.com>, 'Michael Werner' <werner@chelsio.com>
List-Id: linux-rdma@vger.kernel.org

> 
> On 2018-03-22 08:24, okaya@codeaurora.org wrote:
> > On 2018-03-22 02:44, kbuild test robot wrote:
> >> Hi Sinan,
> >>
> >> Thank you for the patch! Yet something to improve:
> >>
> >> [auto build test ERROR on linus/master]
> >> [also build test ERROR on v4.16-rc6 next-20180321]
> >> [if your patch is applied to the wrong git tree, please drop us a note
> >> to help improve the system]
> >>
> >> url:
> >> https://github.com/0day-ci/linux/commits/Sinan-Kaya/ib-Eliminate-
> duplicate-barriers-on-weakly-ordered-archs/20180321-091659
> >> config: xtensa-allyesconfig (attached as .config)
> >> compiler: xtensa-linux-gcc (GCC) 7.2.0
> >> reproduce:
> >>         wget
> >> https://raw.githubusercontent.com/intel/lkp-
> tests/master/sbin/make.cross
> >> -O ~/bin/make.cross
> >>         chmod +x ~/bin/make.cross
> >>         # save the attached .config to linux build tree
> >>         make.cross ARCH=xtensa
> >>
> >
> > Jason,
> >
> > Can you remove the writeq change if it is too late for me to fix?
> >
> > This is an infrastructural issue on xtensa arch.
> >
> > Probably, it won't get fixed today.
> 
> AFAIS, even writeq won't compile on this arch. I started questioning
> this build test.
> 

I think all these iw_cxgb4 changes should be reverted until we really have a
plan for multi-platform that works.  

> 
> >
> > Sinan
> >
> >
> >> All errors (new ones prefixed by >>):
> >>
> >>    In file included from drivers/infiniband/hw/cxgb4/iw_cxgb4.h:73:0,
> >>                     from drivers/infiniband/hw/cxgb4/device.c:40:
> >>    drivers/infiniband/hw/cxgb4/t4.h: In function 'pio_copy':
> >>>> drivers/infiniband/hw/cxgb4/t4.h:460:3: error: implicit declaration
> >>>> of function 'writeq_relaxed'; did you mean 'writel_relaxed'?
> >>>> [-Werror=implicit-function-declaration]
> >>       writeq_relaxed(*src, dst);
> >>       ^~~~~~~~~~~~~~
> >>       writel_relaxed
> >>    cc1: some warnings being treated as errors
> >>
> >> vim +460 drivers/infiniband/hw/cxgb4/t4.h
> >>
> >>    450
> >>    451	/* This function copies 64 byte coalesced work request to
> >> memory
> >>    452	 * mapped BAR2 space. For coalesced WRs, the SGE fetches
> data
> >>    453	 * from the FIFO instead of from Host.
> >>    454	 */
> >>    455	static inline void pio_copy(u64 __iomem *dst, u64 *src)
> >>    456	{
> >>    457		int count = 8;
> >>    458
> >>    459		while (count) {
> >>  > 460			writeq_relaxed(*src, dst);
> >>    461			src++;
> >>    462			dst++;
> >>    463			count--;
> >>    464		}
> >>    465	}
> >>    466
> >>
> >> ---
> >> 0-DAY kernel test infrastructure                Open Source Technology
> >> Center
> >> https://lists.01.org/pipermail/kbuild-all                   Intel
> >> Corporation
