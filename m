From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v2 16/17] IB/mlx5: Add support for RDMA read/write responder page faults
Date: Tue, 11 Nov 2014 18:36:22 +0200
Message-ID: <1415723783-2138-17-git-send-email-haggaie@mellanox.com>
References: <1415723783-2138-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415723783-2138-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jerome Glisse <j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/odp.c | 79 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 79 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index bd1dbe5ebc15..936a6cd4ecc7 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -35,6 +35,8 @@
 
 #include "mlx5_ib.h"
 
+#define MAX_PREFETCH_LEN (4*1024*1024U)
+
 struct workqueue_struct *mlx5_ib_page_fault_wq;
 
 #define COPY_ODP_BIT_MLX_TO_IB(reg, ib_caps, field_name, bit_name) do {	\
@@ -490,6 +492,80 @@ resolve_page_fault:
 	free_page((unsigned long)buffer);
 }
 
+static int pages_in_range(u64 address, u32 length)
+{
+	return (ALIGN(address + length, PAGE_SIZE) -
+		(address & PAGE_MASK)) >> PAGE_SHIFT;
+}
+
+static void mlx5_ib_mr_rdma_pfault_handler(struct mlx5_ib_qp *qp,
+					   struct mlx5_ib_pfault *pfault)
+{
+	struct mlx5_pagefault *mpfault = &pfault->mpfault;
+	u64 address;
+	u32 length;
+	u32 prefetch_len = mpfault->bytes_committed;
+	int prefetch_activated = 0;
+	u32 rkey = mpfault->rdma.r_key;
+	int ret;
+
+	/* The RDMA responder handler handles the page fault in two parts.
+	 * First it brings the necessary pages for the current packet
+	 * (and uses the pfault context), and then (after resuming the QP)
+	 * prefetches more pages. The second operation cannot use the pfault
+	 * context and therefore uses the dummy_pfault context allocated on
+	 * the stack */
+	struct mlx5_ib_pfault dummy_pfault = {};
+
+	dummy_pfault.mpfault.bytes_committed = 0;
+
+	mpfault->rdma.rdma_va += mpfault->bytes_committed;
+	mpfault->rdma.rdma_op_len -= min(mpfault->bytes_committed,
+					 mpfault->rdma.rdma_op_len);
+	mpfault->bytes_committed = 0;
+
+	address = mpfault->rdma.rdma_va;
+	length  = mpfault->rdma.rdma_op_len;
+
+	/* For some operations, the hardware cannot tell the exact message
+	 * length, and in those cases it reports zero. Use prefetch
+	 * logic. */
+	if (length == 0) {
+		prefetch_activated = 1;
+		length = mpfault->rdma.packet_size;
+		prefetch_len = min(MAX_PREFETCH_LEN, prefetch_len);
+	}
+
+	ret = pagefault_single_data_segment(qp, pfault, rkey, address, length,
+					    NULL);
+	if (ret == -EAGAIN) {
+		/* We're racing with an invalidation, don't prefetch */
+		prefetch_activated = 0;
+	} else if (ret < 0 || pages_in_range(address, length) > ret) {
+		mlx5_ib_page_fault_resume(qp, pfault, 1);
+		return;
+	}
+
+	mlx5_ib_page_fault_resume(qp, pfault, 0);
+
+	/* At this point, there might be a new pagefault already arriving in
+	 * the eq, switch to the dummy pagefault for the rest of the
+	 * processing. We're still OK with the objects being alive as the
+	 * work-queue is being fenced. */
+
+	if (prefetch_activated) {
+		ret = pagefault_single_data_segment(qp, &dummy_pfault, rkey,
+						    address,
+						    prefetch_len,
+						    NULL);
+		if (ret < 0) {
+			pr_warn("Prefetch failed (ret = %d, prefetch_activated = %d) for QPN %d, address: 0x%.16llx, length = 0x%.16x\n",
+				ret, prefetch_activated,
+				qp->ibqp.qp_num, address, prefetch_len);
+		}
+	}
+}
+
 void mlx5_ib_mr_pfault_handler(struct mlx5_ib_qp *qp,
 			       struct mlx5_ib_pfault *pfault)
 {
@@ -499,6 +575,9 @@ void mlx5_ib_mr_pfault_handler(struct mlx5_ib_qp *qp,
 	case MLX5_PFAULT_SUBTYPE_WQE:
 		mlx5_ib_mr_wqe_pfault_handler(qp, pfault);
 		break;
+	case MLX5_PFAULT_SUBTYPE_RDMA:
+		mlx5_ib_mr_rdma_pfault_handler(qp, pfault);
+		break;
 	default:
 		pr_warn("Invalid page fault event subtype: 0x%x\n",
 			event_subtype);
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
