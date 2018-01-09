From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 1/4] IB/core: Perform modify QP on real one
Date: Tue,  9 Jan 2018 15:24:50 +0200
Message-ID: <20180109132453.29038-2-leon@kernel.org>
References: <20180109132453.29038-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180109132453.29038-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Currently qp->port stores the port number whenever IB_QP_PORT
QP attribute mask is set (during QP state transition to INIT state).
This port number should be stored for the real QP when XRC target QP
is used.

Follow the ib_modify_qp() implementation and hide the access to ->real_qp.

Fixes: a512c2fbef9c ("IB/core: Introduce modify QP operation with udata")
Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/verbs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index bace97c3d986..1436f8c7906a 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1325,7 +1325,7 @@ static int ib_resolve_eth_dmac(struct ib_device *device,
 
 /**
  * ib_modify_qp_with_udata - Modifies the attributes for the specified QP.
- * @qp: The QP to modify.
+ * @ib_qp: The QP to modify.
  * @attr: On input, specifies the QP attributes to modify.  On output,
  *   the current values of selected QP attributes are returned.
  * @attr_mask: A bit-mask used to specify which attributes of the QP
@@ -1334,9 +1334,10 @@ static int ib_resolve_eth_dmac(struct ib_device *device,
  *   are being modified.
  * It returns 0 on success and returns appropriate error code on error.
  */
-int ib_modify_qp_with_udata(struct ib_qp *qp, struct ib_qp_attr *attr,
+int ib_modify_qp_with_udata(struct ib_qp *ib_qp, struct ib_qp_attr *attr,
 			    int attr_mask, struct ib_udata *udata)
 {
+	struct ib_qp *qp = ib_qp->real_qp;
 	u8 port = attr_mask & IB_QP_PORT ? attr->port_num : qp->port;
 	int ret;
 
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
