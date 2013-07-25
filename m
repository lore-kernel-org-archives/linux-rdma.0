From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] RDMA/nes: info leaks in nes_create_qp() and nes_create_cq()
Date: Thu, 25 Jul 2013 20:04:59 +0300
Message-ID: <20130725170459.GD7026@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: Faisal Latif <faisal.latif@intel.com>
Cc: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

We pass a few bytes of uninitialized stack memory to the user here.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 8f67fe2..5b53ca5 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -1384,6 +1384,7 @@ static struct ib_qp *nes_create_qp(struct ib_pd *ibpd,
 
 			if (ibpd->uobject) {
 				uresp.mmap_sq_db_index = nesqp->mmap_sq_db_index;
+				uresp.mmap_rq_db_index = 0;
 				uresp.actual_sq_size = sq_size;
 				uresp.actual_rq_size = rq_size;
 				uresp.qp_id = nesqp->hwqp.qp_id;
@@ -1767,7 +1768,7 @@ static struct ib_cq *nes_create_cq(struct ib_device *ibdev, int entries,
 		resp.cq_id = nescq->hw_cq.cq_number;
 		resp.cq_size = nescq->hw_cq.cq_size;
 		resp.mmap_db_index = 0;
-		if (ib_copy_to_udata(udata, &resp, sizeof resp)) {
+		if (ib_copy_to_udata(udata, &resp, sizeof resp - sizeof resp.reserved)) {
 			nes_free_resource(nesadapter, nesadapter->allocated_cqs, cq_num);
 			kfree(nescq);
 			return ERR_PTR(-EFAULT);
