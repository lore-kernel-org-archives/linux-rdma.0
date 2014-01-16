From: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH -next] IB/cm: Fix missing unlock on error in cm_init_qp_rtr_attr()
Date: Thu, 16 Jan 2014 16:28:13 +0800
Message-ID: <CAPgLHd92QCSZmjtgO9216MbD2b_i40nwzU_=fwx5-aeB=YvumQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, zhaohongjiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>

Add the missing unlock before return from function cm_init_qp_rtr_attr()
in the error handling case.

Fixes: dd5f03beb4f7 ('IB/core: Ethernet L2 attributes in verbs/cm structures')
Signed-off-by: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>
---
 drivers/infiniband/core/cm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index c6d543c..0601b9d 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -3526,8 +3526,10 @@ static int cm_init_qp_rtr_attr(struct cm_id_private *cm_id_priv,
 		*qp_attr_mask = IB_QP_STATE | IB_QP_AV | IB_QP_PATH_MTU |
 				IB_QP_DEST_QPN | IB_QP_RQ_PSN;
 		qp_attr->ah_attr = cm_id_priv->av.ah_attr;
-		if (!cm_id_priv->av.valid)
+		if (!cm_id_priv->av.valid) {
+			spin_unlock_irqrestore(&cm_id_priv->lock, flags);
 			return -EINVAL;
+		}
 		if (cm_id_priv->av.ah_attr.vlan_id != 0xffff) {
 			qp_attr->vlan_id = cm_id_priv->av.ah_attr.vlan_id;
 			*qp_attr_mask |= IB_QP_VID;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
