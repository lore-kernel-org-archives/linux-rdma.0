From: Mitesh Ahuja <Mitesh.Ahuja@Emulex.Com>
Subject: RE: [PATCH next] RDMA/ocrdma: ocrdma_free_pd_pool() can be static
Date: Wed, 18 Feb 2015 11:35:38 +0000
Message-ID: <4905019e-66b6-41d1-8f19-211fd34e162f@CMEXHTCAS1.ad.emulex.com>
References: <201502181113.2969SUKJ%fengguang.wu@intel.com>
 <20150218034930.GA54160@snb>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150218034930.GA54160@snb>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: kbuild test robot <fengguang.wu@intel.com>
Cc: "kbuild-all@01.org" <kbuild-all@01.org>, Roland Dreier <roland@purestorage.com>, Devesh Sharma <Devesh.Sharma@Emulex.Com>, Selvin Xavier <Selvin.Xavier@Emulex.Com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Jes Sorensen <Jes.Sorensen@redhat.com>, Prarit Bhargava <prarit@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Acked-by: Mitesh Ahuja <mitesh.ahuja@emulex.com>

-----Original Message-----
From: kbuild test robot [mailto:fengguang.wu@intel.com] 
Sent: Wednesday, February 18, 2015 9:20 AM
To: Mitesh Ahuja
Cc: kbuild-all@01.org; Roland Dreier; Devesh Sharma; Selvin Xavier; Sean Hefty; Hal Rosenstock; Jes Sorensen; Prarit Bhargava; linux-rdma@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: [PATCH next] RDMA/ocrdma: ocrdma_free_pd_pool() can be static

drivers/infiniband/hw/ocrdma/ocrdma_hw.c:1510:6: sparse: symbol 'ocrdma_free_pd_pool' was not declared. Should it be static?

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
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
