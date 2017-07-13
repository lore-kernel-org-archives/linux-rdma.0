From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 1/2] RDMA/ocrdma: Fix an error code in ocrdma_alloc_pd()
Date: Thu, 13 Jul 2017 10:46:14 +0300
Message-ID: <20170713074614.obgl5mxxygcluyog@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Selvin Xavier <selvin.xavier@broadcom.com>, Naresh Gottumukkala <bgottumukkala@emulex.com>
Cc: Devesh Sharma <devesh.sharma@broadcom.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Leon Romanovsky <leon@kernel.org>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli@intel.com>, Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>, Artemy Kovalyov <artemyko@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Dan Carpenter <dan.carpenter@oracle.com>, ssh10 <mayhs11saini@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

We should preserve the original "status" error code instead of resetting
it to zero.  Returning ERR_PTR(0) is the same as NULL and results in a
NULL dereference in the callers.  I added a printk() on error instead.

Fixes: 45e86b33ec8b ("RDMA/ocrdma: Cache recv DB until QP moved to RTR")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 2f30bda8457a..cc317e858040 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -744,7 +744,8 @@ struct ib_pd *ocrdma_alloc_pd(struct ib_device *ibdev,
 	if (is_uctx_pd) {
 		ocrdma_release_ucontext_pd(uctx);
 	} else {
-		status = _ocrdma_dealloc_pd(dev, pd);
+		if (_ocrdma_dealloc_pd(dev, pd))
+			pr_err("%s: _ocrdma_dealloc_pd() failed\n", __func__);
 	}
 exit:
 	return ERR_PTR(status);
