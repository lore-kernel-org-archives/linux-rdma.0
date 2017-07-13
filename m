From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] IB/i40iw: Fix error code in i40iw_create_cq()
Date: Thu, 13 Jul 2017 10:47:22 +0300
Message-ID: <20170713074722.ki7o5k5vvdjbzpff@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: Faisal Latif <faisal.latif@intel.com>
Cc: Shiraz Saleem <shiraz.saleem@intel.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

We accidentally forgot to set the error code if ib_copy_from_udata()
fails.  It means we return ERR_PTR(0) which is NULL and results in a
NULL dereference in the callers.

Fixes: d37498417947 ("i40iw: add files for iwarp interface")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index 4dbe61ec7a77..91f1631ff32d 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -1161,8 +1161,10 @@ static struct ib_cq *i40iw_create_cq(struct ib_device *ibdev,
 		memset(&req, 0, sizeof(req));
 		iwcq->user_mode = true;
 		ucontext = to_ucontext(context);
-		if (ib_copy_from_udata(&req, udata, sizeof(struct i40iw_create_cq_req)))
+		if (ib_copy_from_udata(&req, udata, sizeof(struct i40iw_create_cq_req))) {
+			err_code = -EFAULT;
 			goto cq_free_resources;
+		}
 
 		spin_lock_irqsave(&ucontext->cq_reg_mem_list_lock, flags);
 		iwpbl = i40iw_get_pbl((unsigned long)req.user_cq_buffer,
