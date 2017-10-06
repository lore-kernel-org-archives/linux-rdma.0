From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH 26/47] IB/mlx5: Suppress gcc 7 fall-through complaints
Date: Fri,  6 Oct 2017 14:33:12 -0700
Message-ID: <20171006213333.6721-27-bart.vanassche@wdc.com>
References: <20171006213333.6721-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171006213333.6721-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Avoid that gcc 7 reports the following warning when building with W=1:

warning: this statement may fall through [-Wimplicit-fallthrough=]

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/cq.c | 2 ++
 drivers/infiniband/hw/mlx5/qp.c | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 2aa53f427685..b8a116d0e063 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -124,11 +124,13 @@ static void handle_good_req(struct ib_wc *wc, struct mlx5_cqe64 *cqe,
 	switch (be32_to_cpu(cqe->sop_drop_qpn) >> 24) {
 	case MLX5_OPCODE_RDMA_WRITE_IMM:
 		wc->wc_flags |= IB_WC_WITH_IMM;
+		/* fall through */
 	case MLX5_OPCODE_RDMA_WRITE:
 		wc->opcode    = IB_WC_RDMA_WRITE;
 		break;
 	case MLX5_OPCODE_SEND_IMM:
 		wc->wc_flags |= IB_WC_WITH_IMM;
+		/* fall through */
 	case MLX5_OPCODE_SEND:
 	case MLX5_OPCODE_SEND_INVAL:
 		wc->opcode    = IB_WC_SEND;
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index acb79d3a4f1d..b0b09febafda 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -4053,6 +4053,7 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 				*bad_wr = wr;
 				goto out;
 			}
+			/* fall through */
 		case MLX5_IB_QPT_HW_GSI:
 			set_datagram_seg(seg, wr);
 			seg += sizeof(struct mlx5_wqe_datagram_seg);
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
