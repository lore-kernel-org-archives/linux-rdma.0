From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] RDMA/cxgb4: four byte info leak in c4iw_create_cq()
Date: Sat, 19 Oct 2013 12:14:35 +0300
Message-ID: <20131019091435.GH9312@longonot.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: Steve Wise <swise@chelsio.com>
Cc: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

There is a four byte hole at the end of the "uresp" struct after the
->qid_mask member.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/infiniband/hw/cxgb4/cq.c b/drivers/infiniband/hw/cxgb4/cq.c
index 88de3aa..e436ead 100644
--- a/drivers/infiniband/hw/cxgb4/cq.c
+++ b/drivers/infiniband/hw/cxgb4/cq.c
@@ -930,6 +930,7 @@ struct ib_cq *c4iw_create_cq(struct ib_device *ibdev, int entries,
 		if (!mm2)
 			goto err4;
 
+		memset(&uresp, 0, sizeof(uresp));
 		uresp.qid_mask = rhp->rdev.cqmask;
 		uresp.cqid = chp->cq.cqid;
 		uresp.size = chp->cq.size;
