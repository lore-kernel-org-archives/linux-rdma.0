From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 3/3] IB/mlx5: Add support for CSUM in RX flow
Date: Wed, 10 Feb 2016 15:35:38 +0200
Message-ID: <1455111338-26748-4-git-send-email-erezsh@mellanox.com>
References: <1455111338-26748-1-git-send-email-erezsh@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1455111338-26748-1-git-send-email-erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


The driver checks the csum from the HW when completion arrived and marks
it in the wc->wc_flags field for the ulp drivers.
These is for packets from type IB_WC_RECV only.

Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/cq.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 7ddc790..98dfe6e 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -208,6 +208,9 @@ static void handle_responder(struct ib_wc *wc, struct mlx5_cqe64 *cqe,
 	case MLX5_CQE_RESP_SEND:
 		wc->opcode   = IB_WC_RECV;
 		wc->wc_flags = 0;
+		if (likely(cqe->hds_ip_ext & CQE_L3_OK) &&
+		    likely(cqe->hds_ip_ext & CQE_L4_OK))
+			wc->wc_flags |= IB_WC_IP_CSUM_OK;
 		break;
 	case MLX5_CQE_RESP_SEND_IMM:
 		wc->opcode	= IB_WC_RECV;
-- 
1.7.11.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
