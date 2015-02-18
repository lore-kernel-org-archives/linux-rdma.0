From: kbuild test robot <fengguang.wu@intel.com>
Subject: [PATCH next] RDMA/ocrdma: ocrdma_free_pd_pool() can be static
Date: Wed, 18 Feb 2015 11:49:30 +0800
Message-ID: <20150218034930.GA54160@snb>
References: <201502181113.2969SUKJ%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201502181113.2969SUKJ%fengguang.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mitesh Ahuja <mitesh.ahuja@emulex.com>
Cc: kbuild-all@01.org, Roland Dreier <roland@purestorage.com>, Devesh Sharma <devesh.sharma@emulex.com>, Selvin Xavier <selvin.xavier@emulex.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Jes Sorensen <Jes.Sorensen@redhat.com>, Prarit Bhargava <prarit@redhat.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

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
