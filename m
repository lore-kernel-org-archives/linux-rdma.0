From: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V2 for-next 3/3] IB/mlx5: Add support for CSUM in RX flow
Date: Sun, 21 Feb 2016 16:27:18 +0200
Message-ID: <1456064838-31710-4-git-send-email-eranbe@mellanox.com>
References: <1456064838-31710-1-git-send-email-eranbe@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456064838-31710-1-git-send-email-eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The driver checks the csum from the HW when completion arrived and marks
it in the wc->wc_flags field for the ulp drivers.
These is for packets from type IB_WC_RECV only.

Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/cq.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 7ddc790..fe7921b 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -207,7 +207,10 @@ static void handle_responder(struct ib_wc *wc, struct mlx5_cqe64 *cqe,
 		break;
 	case MLX5_CQE_RESP_SEND:
 		wc->opcode   = IB_WC_RECV;
-		wc->wc_flags = 0;
+		wc->wc_flags = IB_WC_IP_CSUM_OK;
+		if (unlikely(!((cqe->hds_ip_ext & CQE_L3_OK) &&
+			       (cqe->hds_ip_ext & CQE_L4_OK))))
+			wc->wc_flags = 0;
 		break;
 	case MLX5_CQE_RESP_SEND_IMM:
 		wc->opcode	= IB_WC_RECV;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
