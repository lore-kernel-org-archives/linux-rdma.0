From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] IB/rdmavt: Use struct_size() helper
Date: Wed, 29 May 2019 10:12:48 -0500
Message-ID: <20190529151248.GA24080@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Dennis Dalessandro <dennis.dalessandro@intel.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-rdma@vger.kernel.org

Make use of the struct_size() helper instead of an open-coded version
in order to avoid any potential type mistakes, in particular in the
context in which this code is being used.

So, replace the following form:

sizeof(struct rvt_sge) * init_attr->cap.max_send_sge + sizeof(struct rvt_swqe)

with:

struct_size(swq, sg_list, init_attr->cap.max_send_sge)

and so on...

Also, notice that variable size is unnecessary, hence it is removed.

This code was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/infiniband/sw/rdmavt/qp.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index 31a2e65e4906..a60f5faea198 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -988,9 +988,7 @@ struct ib_qp *rvt_create_qp(struct ib_pd *ibpd,
 	case IB_QPT_UC:
 	case IB_QPT_RC:
 	case IB_QPT_UD:
-		sz = sizeof(struct rvt_sge) *
-			init_attr->cap.max_send_sge +
-			sizeof(struct rvt_swqe);
+		sz = struct_size(swq, sg_list, init_attr->cap.max_send_sge);
 		swq = vzalloc_node(array_size(sz, sqsize), rdi->dparms.node);
 		if (!swq)
 			return ERR_PTR(-ENOMEM);
-- 
2.21.0
