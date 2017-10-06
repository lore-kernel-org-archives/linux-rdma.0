From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH 25/47] IB/mlx4: Suppress gcc 7 fall-through complaints
Date: Fri,  6 Oct 2017 14:33:11 -0700
Message-ID: <20171006213333.6721-26-bart.vanassche@wdc.com>
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
 drivers/infiniband/hw/mlx4/cq.c  | 2 ++
 drivers/infiniband/hw/mlx4/mcg.c | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/mlx4/cq.c
index cab796341697..6d5f405912dd 100644
--- a/drivers/infiniband/hw/mlx4/cq.c
+++ b/drivers/infiniband/hw/mlx4/cq.c
@@ -768,11 +768,13 @@ static int mlx4_ib_poll_one(struct mlx4_ib_cq *cq,
 		switch (cqe->owner_sr_opcode & MLX4_CQE_OPCODE_MASK) {
 		case MLX4_OPCODE_RDMA_WRITE_IMM:
 			wc->wc_flags |= IB_WC_WITH_IMM;
+			/* fall through */
 		case MLX4_OPCODE_RDMA_WRITE:
 			wc->opcode    = IB_WC_RDMA_WRITE;
 			break;
 		case MLX4_OPCODE_SEND_IMM:
 			wc->wc_flags |= IB_WC_WITH_IMM;
+			/* fall through */
 		case MLX4_OPCODE_SEND:
 		case MLX4_OPCODE_SEND_INVAL:
 			wc->opcode    = IB_WC_SEND;
diff --git a/drivers/infiniband/hw/mlx4/mcg.c b/drivers/infiniband/hw/mlx4/mcg.c
index 70eb9f917303..81ffc007e0a1 100644
--- a/drivers/infiniband/hw/mlx4/mcg.c
+++ b/drivers/infiniband/hw/mlx4/mcg.c
@@ -944,6 +944,7 @@ int mlx4_ib_mcg_multiplex_handler(struct ib_device *ibdev, int port,
 	switch (sa_mad->mad_hdr.method) {
 	case IB_MGMT_METHOD_SET:
 		may_create = 1;
+		/* fall through */
 	case IB_SA_METHOD_DELETE:
 		req = kzalloc(sizeof *req, GFP_KERNEL);
 		if (!req)
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
