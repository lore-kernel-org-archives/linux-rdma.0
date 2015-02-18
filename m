From: Mitesh Ahuja <Mitesh.Ahuja-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH next] RDMA/ocrdma: ocrdma_free_pd_pool() can be static
Date: Wed, 18 Feb 2015 11:30:17 +0000
Message-ID: <d8545856-19be-4d21-a4fe-bc1e24b6ef96@CMEXHTCAS1.ad.emulex.com>
References: <201502181113.2969SUKJ%fengguang.wu@intel.com>
 <20150218034930.GA54160@snb>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150218034930.GA54160@snb>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "kbuild-all-JC7UmRfGjtg@public.gmane.org" <kbuild-all-JC7UmRfGjtg@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, Selvin Xavier <Selvin.Xavier-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jes Sorensen <Jes.Sorensen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Acked-by: Mitesh Ahuja.

-----Original Message-----
From: kbuild test robot [mailto:fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org] 
Sent: Wednesday, February 18, 2015 9:20 AM
To: Mitesh Ahuja
Cc: kbuild-all-JC7UmRfGjtg@public.gmane.org; Roland Dreier; Devesh Sharma; Selvin Xavier; Sean Hefty; Hal Rosenstock; Jes Sorensen; Prarit Bhargava; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: [PATCH next] RDMA/ocrdma: ocrdma_free_pd_pool() can be static

drivers/infiniband/hw/ocrdma/ocrdma_hw.c:1510:6: sparse: symbol 'ocrdma_free_pd_pool' was not declared. Should it be static?

Signed-off-by: Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 ocrdma_hw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index ec4571b..037893a 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -1507,7 +1507,7 @@ void ocrdma_alloc_pd_pool(struct ocrdma_dev *dev)
 	}
 }
 
-void ocrdma_free_pd_pool(struct ocrdma_dev *dev)
+static void ocrdma_free_pd_pool(struct ocrdma_dev *dev)
 {
 	ocrdma_mbx_dealloc_pd_range(dev);
 	kfree(dev->pd_mgr->pd_norm_bitmap);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
