From: Seth Howell <seth.howell@intel.com>
Subject: [PATCH] rdma: move the ib_wr_opcode enum to include/uapi
Date: Tue, 14 Aug 2018 15:33:02 -0700
Message-ID: <20180814223303.83556-1-seth.howell@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: benjamin.walker@intel.com, Seth Howell <seth.howell@intel.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

By making this enum accessible to the userspace API, we can avoid
conflicts between the kernel-space ib_wr_opcode and the user-space
ibv_wr_opcode enums.

When using the rxe software driver interface between kernel and user
space, the enum value IBV_WR_SEND_WITH_INV was being improperly
translated to IB_WR_READ_WITH_INV causing the userspace application to
fail.

Signed-off-by: Seth Howell <seth.howell@intel.com>
---
 include/rdma/ib_verbs.h           | 31 -------------------------------
 include/uapi/rdma/ib_user_verbs.h | 31 +++++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 6c003995347a..02fe3960378d 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1295,37 +1295,6 @@ struct ib_qp_attr {
 	u32			rate_limit;
 };
 
-enum ib_wr_opcode {
-	IB_WR_RDMA_WRITE,
-	IB_WR_RDMA_WRITE_WITH_IMM,
-	IB_WR_SEND,
-	IB_WR_SEND_WITH_IMM,
-	IB_WR_RDMA_READ,
-	IB_WR_ATOMIC_CMP_AND_SWP,
-	IB_WR_ATOMIC_FETCH_AND_ADD,
-	IB_WR_LSO,
-	IB_WR_SEND_WITH_INV,
-	IB_WR_RDMA_READ_WITH_INV,
-	IB_WR_LOCAL_INV,
-	IB_WR_REG_MR,
-	IB_WR_MASKED_ATOMIC_CMP_AND_SWP,
-	IB_WR_MASKED_ATOMIC_FETCH_AND_ADD,
-	IB_WR_REG_SIG_MR,
-	/* reserve values for low level drivers' internal use.
-	 * These values will not be used at all in the ib core layer.
-	 */
-	IB_WR_RESERVED1 = 0xf0,
-	IB_WR_RESERVED2,
-	IB_WR_RESERVED3,
-	IB_WR_RESERVED4,
-	IB_WR_RESERVED5,
-	IB_WR_RESERVED6,
-	IB_WR_RESERVED7,
-	IB_WR_RESERVED8,
-	IB_WR_RESERVED9,
-	IB_WR_RESERVED10,
-};
-
 enum ib_send_flags {
 	IB_SEND_FENCE		= 1,
 	IB_SEND_SIGNALED	= (1<<1),
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index 4f9991de8e3a..7c1132f953d8 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -46,6 +46,37 @@
 #define IB_USER_VERBS_ABI_VERSION	6
 #define IB_USER_VERBS_CMD_THRESHOLD    50
 
+enum ib_wr_opcode {
+	IB_WR_RDMA_WRITE,
+	IB_WR_RDMA_WRITE_WITH_IMM,
+	IB_WR_SEND,
+	IB_WR_SEND_WITH_IMM,
+	IB_WR_RDMA_READ,
+	IB_WR_ATOMIC_CMP_AND_SWP,
+	IB_WR_ATOMIC_FETCH_AND_ADD,
+	IB_WR_LSO,
+	IB_WR_SEND_WITH_INV,
+	IB_WR_RDMA_READ_WITH_INV,
+	IB_WR_LOCAL_INV,
+	IB_WR_REG_MR,
+	IB_WR_MASKED_ATOMIC_CMP_AND_SWP,
+	IB_WR_MASKED_ATOMIC_FETCH_AND_ADD,
+	IB_WR_REG_SIG_MR,
+	/* reserve values for low level drivers' internal use.
+	 * These values will not be used at all in the ib core layer.
+	 */
+	IB_WR_RESERVED1 = 0xf0,
+	IB_WR_RESERVED2,
+	IB_WR_RESERVED3,
+	IB_WR_RESERVED4,
+	IB_WR_RESERVED5,
+	IB_WR_RESERVED6,
+	IB_WR_RESERVED7,
+	IB_WR_RESERVED8,
+	IB_WR_RESERVED9,
+	IB_WR_RESERVED10,
+};
+
 enum {
 	IB_USER_VERBS_CMD_GET_CONTEXT,
 	IB_USER_VERBS_CMD_QUERY_DEVICE,
-- 
2.14.4
