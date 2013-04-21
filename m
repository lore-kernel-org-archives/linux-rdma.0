From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 3/3] IB/mlx4: Set link type for RAW PACKET QPs in the QP context
Date: Sun, 21 Apr 2013 18:10:01 +0300
Message-ID: <1366557001-29408-4-git-send-email-ogerlitz@mellanox.com>
References: <1366557001-29408-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1366557001-29408-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When the link type is Ethernet, setting the link type in the QP context will
enable TCP/IP stateless offloads (checksum, LSO, RSS) for RAW PACKET Ethernet
QPs. For IB UD QPs this worked OK since the value assumed by the firmware for
IB link layer is zero.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/qp.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index d4e87c2..4f10af2 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -1460,6 +1460,10 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 		}
 	}
 
+	if (qp->ibqp.qp_type == IB_QPT_RAW_PACKET)
+		context->pri_path.ackto = (context->pri_path.ackto & 0xf8) |
+					MLX4_IB_LINK_TYPE_ETH;
+
 	if (cur_state == IB_QPS_RTS && new_state == IB_QPS_SQD	&&
 	    attr_mask & IB_QP_EN_SQD_ASYNC_NOTIFY && attr->en_sqd_async_notify)
 		sqd_event = 1;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
