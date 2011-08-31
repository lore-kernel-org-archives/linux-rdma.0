From: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 2/2] mlx4: Fix the SQ size of an RC QP to support masked atomic operation
Date: Wed, 31 Aug 2011 16:29:37 +0300
Message-ID: <201108311629.37966.dotanb@sw.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When calculating the required size of an RC QP send queue, leave enough space
for masked atomic operation (which requires more space than "regular" atomic
operation).

Signed-off-by: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Reviewed-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/qp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index c825567..d094552 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -312,7 +312,7 @@ static int send_wqe_overhead(enum ib_qp_type type, u32 flags)
 	case IB_QPT_XRC:
 	case IB_QPT_RC:
 		return sizeof (struct mlx4_wqe_ctrl_seg) +
-			sizeof (struct mlx4_wqe_atomic_seg) +
+			sizeof (struct mlx4_wqe_masked_atomic_seg) +
 			sizeof (struct mlx4_wqe_raddr_seg);
 	case IB_QPT_SMI:
 	case IB_QPT_GSI:
-- 
1.7.4.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
