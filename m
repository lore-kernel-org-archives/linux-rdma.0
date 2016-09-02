From: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/9] ib: Add udata argument to create_ah
Date: Fri, 02 Sep 2016 10:01:31 +0200
Message-ID: <1472803291.3975.25.camel@oracle.com>
References: <201609020848.QliVPrIS%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201609020848.QliVPrIS%fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Good catch by the robot - I am obviously missing a few options in my test .config
Will fix both of these.

Knut

On Fri, 2016-09-02 at 08:39 +0800, kbuild test robot wrote:
> Hi Knut,
> 
> [auto build test WARNING on rdma/master]
> [also build test WARNING on v4.8-rc4 next-20160825]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> [Suggest to use git(>=2.9.0) format-patch --base=<commit> (or --base=auto for convenience) to record what (public, well-known) commit your patch
> series was built on]
> [Check https://git-scm.com/docs/git-format-patch for more information]
> 
> url:    https://github.com/0day-ci/linux/commits/Knut-Omang/SIF-related-verbs-patches/20160902-081205
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git master
> config: tile-allyesconfig (attached as .config)
> compiler: tilegx-linux-gcc (GCC) 4.6.2
> reproduce:
>         wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         make.cross ARCH=tile 
> 
> All warnings (new ones prefixed by >>):
> 
>    drivers/infiniband/hw/i40iw/i40iw_verbs.c: In function 'i40iw_init_rdma_device':
> > 
> > > 
> > > drivers/infiniband/hw/i40iw/i40iw_verbs.c:2650:27: warning: assignment from incompatible pointer type [enabled by default]
> vim +2650 drivers/infiniband/hw/i40iw/i40iw_verbs.c
> 
> d3749841 Faisal Latif      2016-01-20  2634  	iwibdev->ibdev.dealloc_ucontext = i40iw_dealloc_ucontext;
> d3749841 Faisal Latif      2016-01-20  2635  	iwibdev->ibdev.mmap = i40iw_mmap;
> d3749841 Faisal Latif      2016-01-20  2636  	iwibdev->ibdev.alloc_pd = i40iw_alloc_pd;
> d3749841 Faisal Latif      2016-01-20  2637  	iwibdev->ibdev.dealloc_pd = i40iw_dealloc_pd;
> d3749841 Faisal Latif      2016-01-20  2638  	iwibdev->ibdev.create_qp = i40iw_create_qp;
> d3749841 Faisal Latif      2016-01-20  2639  	iwibdev->ibdev.modify_qp = i40iw_modify_qp;
> d3749841 Faisal Latif      2016-01-20  2640  	iwibdev->ibdev.query_qp = i40iw_query_qp;
> d3749841 Faisal Latif      2016-01-20  2641  	iwibdev->ibdev.destroy_qp = i40iw_destroy_qp;
> d3749841 Faisal Latif      2016-01-20  2642  	iwibdev->ibdev.create_cq = i40iw_create_cq;
> d3749841 Faisal Latif      2016-01-20  2643  	iwibdev->ibdev.destroy_cq = i40iw_destroy_cq;
> d3749841 Faisal Latif      2016-01-20  2644  	iwibdev->ibdev.get_dma_mr = i40iw_get_dma_mr;
> d3749841 Faisal Latif      2016-01-20  2645  	iwibdev->ibdev.reg_user_mr = i40iw_reg_user_mr;
> d3749841 Faisal Latif      2016-01-20  2646  	iwibdev->ibdev.dereg_mr = i40iw_dereg_mr;
> b40f4757 Christoph Lameter 2016-05-16  2647  	iwibdev->ibdev.alloc_hw_stats = i40iw_alloc_hw_stats;
> b40f4757 Christoph Lameter 2016-05-16  2648  	iwibdev->ibdev.get_hw_stats = i40iw_get_hw_stats;
> d3749841 Faisal Latif      2016-01-20  2649  	iwibdev->ibdev.query_device = i40iw_query_device;
> d3749841 Faisal Latif      2016-01-20 @2650  	iwibdev->ibdev.create_ah = i40iw_create_ah;
> d3749841 Faisal Latif      2016-01-20  2651  	iwibdev->ibdev.destroy_ah = i40iw_destroy_ah;
> c2b75ef7 Ismail, Mustafa   2016-04-18  2652  	iwibdev->ibdev.drain_sq = i40iw_drain_sq;
> c2b75ef7 Ismail, Mustafa   2016-04-18  2653  	iwibdev->ibdev.drain_rq = i40iw_drain_rq;
> b7aee855 Ismail, Mustafa   2016-04-18  2654  	iwibdev->ibdev.alloc_mr = i40iw_alloc_mr;
> b7aee855 Ismail, Mustafa   2016-04-18  2655  	iwibdev->ibdev.map_mr_sg = i40iw_map_mr_sg;
> d3749841 Faisal Latif      2016-01-20  2656  	iwibdev->ibdev.iwcm = kzalloc(sizeof(*iwibdev->ibdev.iwcm), GFP_KERNEL);
> d3749841 Faisal Latif      2016-01-20  2657  	if (!iwibdev->ibdev.iwcm) {
> d3749841 Faisal Latif      2016-01-20  2658  		ib_dealloc_device(&iwibdev->ibdev);
> 
> :::::: The code at line 2650 was first introduced by commit
> :::::: d37498417947cb2299fc749ae4af1d204c768cba i40iw: add files for iwarp interface
> 
> :::::: TO: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> :::::: CC: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
