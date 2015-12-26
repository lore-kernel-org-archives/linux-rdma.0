From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 1/6] InfiniBand-ocrdma: One variable and jump label less
 in ocrdma_alloc_ucontext_pd()
Date: Sun, 27 Dec 2015 03:41:48 +0800
Message-ID: <201512270304.PMbiMdOa%fengguang.wu@intel.com>
References: <567EDFDF.5000801@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <567EDFDF.5000801@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: kbuild-all@01.org, linux-rdma@vger.kernel.org, Devesh Sharma <devesh.sharma@avagotech.com>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Mitesh Ahuja <mitesh.ahuja@avagotech.com>, Sean Hefty <sean.hefty@intel.com>, Selvin Xavier <selvin.xavier@avagotech.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-rdma@vger.kernel.org

[if your patch is applied to the wrong git tree, please drop us a note to help improving the system]
Hi Markus,

[auto build test WARNING on v4.4-rc6]
[also build test WARNING on next-20151223]

url:    https://github.com/0day-ci/linux/commits/SF-Markus-Elfring/InfiniBand-ocrdma-Fine-tuning-for-some-function-implementations/20151227-025304


coccinelle warnings: (new ones prefixed by >>)

>> drivers/infiniband/hw/ocrdma/ocrdma_verbs.c:489:9-16: ERROR: PTR_ERR applied after initialization to constant on line 488

vim +489 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c

   482	static int ocrdma_alloc_ucontext_pd(struct ocrdma_dev *dev,
   483					    struct ocrdma_ucontext *uctx,
   484					    struct ib_udata *udata)
   485	{
   486		uctx->cntxt_pd = _ocrdma_alloc_pd(dev, uctx, udata);
   487		if (IS_ERR(uctx->cntxt_pd)) {
 > 488			uctx->cntxt_pd = NULL;
 > 489			return PTR_ERR(uctx->cntxt_pd);
   490		}
   491	
   492		uctx->cntxt_pd->uctx = uctx;

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
