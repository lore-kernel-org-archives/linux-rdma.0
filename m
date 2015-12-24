From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 1/6] IB/uapi: expose uverbs WR opcodes
Date: Thu, 24 Dec 2015 15:39:22 +0100
Message-ID: <1450967967-12479-2-git-send-email-hch@lst.de>
References: <1450967967-12479-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450967967-12479-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This exposes the WR opcodes supported by uverbs as part of the uapi
headers. For this I had to create a new uapi/rdma/ib_verbs.h headers
so that we don't have to drag ib_user_verbs.h into the main ib_verbs.h.

There are now three tiers of WR opcodes: uapi ones that are fixe=D1=95 =
and
must not change [1], kernel-wide ones that follow the uapi ones
and can be reordered at will, and driver-private ones that follow the
kernel-wide ones, and will also be frequently reordered.

[1] we also assign explicitly values to them just so that this is obvio=
us!

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  2 +-
 include/rdma/ib_verbs.h              | 39 ++++++++++++++++------------=
--------
 include/uapi/rdma/ib_user_verbs.h    |  2 ++
 include/uapi/rdma/ib_verbs.h         | 23 +++++++++++++++++++++
 4 files changed, 43 insertions(+), 23 deletions(-)
 create mode 100644 include/uapi/rdma/ib_verbs.h

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/=
hw/mlx5/mlx5_ib.h
index d4b2271..2f82a08 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -122,7 +122,7 @@ struct mlx5_ib_pd {
 #define MLX5_IB_SEND_UMR_FAIL_IF_FREE (IB_SEND_RESERVED_START << 1)
 #define MLX5_IB_SEND_UMR_UPDATE_MTT (IB_SEND_RESERVED_START << 2)
 #define MLX5_IB_QPT_REG_UMR	IB_QPT_RESERVED1
-#define MLX5_IB_WR_UMR		IB_WR_RESERVED1
+#define MLX5_IB_WR_UMR		(IB_WR_END + 0)
=20
 struct wr_list {
 	u16	opcode;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 75fcc97..94509e0 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -60,6 +60,8 @@
 #include <linux/mmu_notifier.h>
 #include <asm/uaccess.h>
=20
+#include <uapi/rdma/ib_verbs.h>
+
 extern struct workqueue_struct *ib_wq;
 extern struct workqueue_struct *ib_comp_wq;
=20
@@ -1108,34 +1110,27 @@ struct ib_qp_attr {
 };
=20
 enum ib_wr_opcode {
-	IB_WR_RDMA_WRITE,
-	IB_WR_RDMA_WRITE_WITH_IMM,
-	IB_WR_SEND,
-	IB_WR_SEND_WITH_IMM,
-	IB_WR_RDMA_READ,
-	IB_WR_ATOMIC_CMP_AND_SWP,
-	IB_WR_ATOMIC_FETCH_AND_ADD,
-	IB_WR_LSO,
-	IB_WR_SEND_WITH_INV,
+	/* opcodes directly passed through from userspace: */
+	IB_WR_RDMA_WRITE		=3D IB_UVERBS_WR_RDMA_WRITE,
+	IB_WR_RDMA_WRITE_WITH_IMM	=3D IB_UVERBS_WR_RDMA_WRITE_WITH_IMM,
+	IB_WR_SEND			=3D IB_UVERBS_WR_SEND,
+	IB_WR_SEND_WITH_IMM		=3D IB_UVERBS_WR_SEND_WITH_IMM,
+	IB_WR_RDMA_READ			=3D IB_UVERBS_WR_RDMA_READ,
+	IB_WR_ATOMIC_CMP_AND_SWP	=3D IB_UVERBS_WR_ATOMIC_CMP_AND_SWP,
+	IB_WR_ATOMIC_FETCH_AND_ADD	=3D IB_UVERBS_WR_ATOMIC_FETCH_AND_ADD,
+	IB_WR_SEND_WITH_INV		=3D IB_UVERBS_WR_SEND_WITH_INV,
+
+	/* kernel-internal opcodes: */
+	IB_WR_LSO			=3D IB_UVERBS_WR_END,
 	IB_WR_RDMA_READ_WITH_INV,
 	IB_WR_LOCAL_INV,
 	IB_WR_REG_MR,
 	IB_WR_MASKED_ATOMIC_CMP_AND_SWP,
 	IB_WR_MASKED_ATOMIC_FETCH_AND_ADD,
 	IB_WR_REG_SIG_MR,
-	/* reserve values for low level drivers' internal use.
-	 * These values will not be used at all in the ib core layer.
-	 */
-	IB_WR_RESERVED1 =3D 0xf0,
-	IB_WR_RESERVED2,
-	IB_WR_RESERVED3,
-	IB_WR_RESERVED4,
-	IB_WR_RESERVED5,
-	IB_WR_RESERVED6,
-	IB_WR_RESERVED7,
-	IB_WR_RESERVED8,
-	IB_WR_RESERVED9,
-	IB_WR_RESERVED10,
+
+	/* drivers may use any value greater or equal to IB_WR_END internally=
 */
+	IB_WR_END,
 };
=20
 enum ib_send_flags {
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_u=
ser_verbs.h
index 8126c14..358a656 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -38,6 +38,8 @@
=20
 #include <linux/types.h>
=20
+#include <uapi/rdma/ib_verbs.h>
+
 /*
  * Increment this value if any changes that break userspace ABI
  * compatibility are made.
diff --git a/include/uapi/rdma/ib_verbs.h b/include/uapi/rdma/ib_verbs.=
h
new file mode 100644
index 0000000..330175e
--- /dev/null
+++ b/include/uapi/rdma/ib_verbs.h
@@ -0,0 +1,23 @@
+#ifndef _UAPI_RDMA_IB_VERBS_H
+#define _UAPI_RDMA_IB_VERBS_H 1
+
+/*
+ * This file contains constants exposed through the uverbs ABI that ar=
e also
+ * used internall by the RDMA stack.  It is separte from ib_user_verbs=
=2Eh to
+ * having to pull that into the kernel-internal internal ib_verbs.h
+ */
+
+enum ib_uverbs_wr_opcode {
+	IB_UVERBS_WR_RDMA_WRITE			=3D 0,
+	IB_UVERBS_WR_RDMA_WRITE_WITH_IMM	=3D 1,
+	IB_UVERBS_WR_SEND			=3D 2,
+	IB_UVERBS_WR_SEND_WITH_IMM		=3D 3,
+	IB_UVERBS_WR_RDMA_READ			=3D 4,
+	IB_UVERBS_WR_ATOMIC_CMP_AND_SWP		=3D 5,
+	IB_UVERBS_WR_ATOMIC_FETCH_AND_ADD	=3D 6,
+	/* 7 is still available */
+	IB_UVERBS_WR_SEND_WITH_INV		=3D 8,
+	IB_UVERBS_WR_END			=3D 9,
+};
+
+#endif /* _UAPI_RDMA_IB_VERBS_H */
--=20
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
