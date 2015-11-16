From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH for-next 06/10] iser-target: Remove unused file iser_proto.h
Date: Mon, 16 Nov 2015 18:37:37 +0200
Message-ID: <1447691861-3796-7-git-send-email-sagig@mellanox.com>
References: <1447691861-3796-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1447691861-3796-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Or Gerlitz <ogerlitz@mellanox.com>, Steve Wise <swise@opengridcomputing.com>
List-Id: linux-rdma@vger.kernel.org

We don't need iser_proto.h anymore, remove it and
move (non-protocol) declarations to ib_isert.h

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Jenny Derzhavetz <jennyf@mellanox.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c    |  1 -
 drivers/infiniband/ulp/isert/ib_isert.h    | 31 ++++++++++++++++++++
 drivers/infiniband/ulp/isert/isert_proto.h | 47 ------------------------------
 3 files changed, 31 insertions(+), 48 deletions(-)
 delete mode 100644 drivers/infiniband/ulp/isert/isert_proto.h

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 97ac9ffaf1eb..bdda42638629 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -29,7 +29,6 @@
 #include <target/iscsi/iscsi_transport.h>
 #include <linux/semaphore.h>
 
-#include "isert_proto.h"
 #include "ib_isert.h"
 
 #define	ISERT_MAX_CONN		8
diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
index 03ddc3e0087f..00edd5b68ca8 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -33,6 +33,37 @@
 #define isert_err(fmt, arg...) \
 	pr_err(PFX "%s: " fmt, __func__ , ## arg)
 
+/*Constant PDU lengths calculations */
+#define ISER_HEADERS_LEN	(sizeof(struct iser_ctrl) + sizeof(struct iscsi_hdr))
+#define ISER_RECV_DATA_SEG_LEN	8192
+#define ISER_RX_PAYLOAD_SIZE	(ISER_HEADERS_LEN + ISER_RECV_DATA_SEG_LEN)
+#define ISER_RX_LOGIN_SIZE	(ISER_HEADERS_LEN + ISCSI_DEF_MAX_RECV_SEG_LEN)
+
+/* QP settings */
+/* Maximal bounds on received asynchronous PDUs */
+#define ISERT_MAX_TX_MISC_PDUS	4 /* NOOP_IN(2) , ASYNC_EVENT(2)   */
+
+#define ISERT_MAX_RX_MISC_PDUS	6 /*
+				   * NOOP_OUT(2), TEXT(1),
+				   * SCSI_TMFUNC(2), LOGOUT(1)
+				   */
+
+#define ISCSI_DEF_XMIT_CMDS_MAX 128 /* from libiscsi.h, must be power of 2 */
+
+#define ISERT_QP_MAX_RECV_DTOS	(ISCSI_DEF_XMIT_CMDS_MAX)
+
+#define ISERT_MIN_POSTED_RX	(ISCSI_DEF_XMIT_CMDS_MAX >> 2)
+
+#define ISERT_INFLIGHT_DATAOUTS	8
+
+#define ISERT_QP_MAX_REQ_DTOS	(ISCSI_DEF_XMIT_CMDS_MAX *    \
+				(1 + ISERT_INFLIGHT_DATAOUTS) + \
+				ISERT_MAX_TX_MISC_PDUS	+ \
+				ISERT_MAX_RX_MISC_PDUS)
+
+#define ISER_RX_PAD_SIZE	(ISER_RECV_DATA_SEG_LEN + 4096 - \
+		(ISER_RX_PAYLOAD_SIZE + sizeof(u64) + sizeof(struct ib_sge)))
+
 #define ISCSI_ISER_SG_TABLESIZE		256
 #define ISER_FASTREG_LI_WRID		0xffffffffffffffffULL
 #define ISER_BEACON_WRID               0xfffffffffffffffeULL
diff --git a/drivers/infiniband/ulp/isert/isert_proto.h b/drivers/infiniband/ulp/isert/isert_proto.h
deleted file mode 100644
index 4dccd313b777..000000000000
--- a/drivers/infiniband/ulp/isert/isert_proto.h
+++ /dev/null
@@ -1,47 +0,0 @@
-/* From iscsi_iser.h */
-
-struct iser_hdr {
-	u8	flags;
-	u8	rsvd[3];
-	__be32	write_stag; /* write rkey */
-	__be64	write_va;
-	__be32	read_stag;  /* read rkey */
-	__be64	read_va;
-} __packed;
-
-/*Constant PDU lengths calculations */
-#define ISER_HEADERS_LEN  (sizeof(struct iser_hdr) + sizeof(struct iscsi_hdr))
-
-#define ISER_RECV_DATA_SEG_LEN  8192
-#define ISER_RX_PAYLOAD_SIZE    (ISER_HEADERS_LEN + ISER_RECV_DATA_SEG_LEN)
-#define ISER_RX_LOGIN_SIZE      (ISER_HEADERS_LEN + ISCSI_DEF_MAX_RECV_SEG_LEN)
-
-/* QP settings */
-/* Maximal bounds on received asynchronous PDUs */
-#define ISERT_MAX_TX_MISC_PDUS	4 /* NOOP_IN(2) , ASYNC_EVENT(2)   */
-
-#define ISERT_MAX_RX_MISC_PDUS	6 /* NOOP_OUT(2), TEXT(1),         *
-				   * SCSI_TMFUNC(2), LOGOUT(1) */
-
-#define ISCSI_DEF_XMIT_CMDS_MAX 128 /* from libiscsi.h, must be power of 2 */
-
-#define ISERT_QP_MAX_RECV_DTOS	(ISCSI_DEF_XMIT_CMDS_MAX)
-
-#define ISERT_MIN_POSTED_RX	(ISCSI_DEF_XMIT_CMDS_MAX >> 2)
-
-#define ISERT_INFLIGHT_DATAOUTS	8
-
-#define ISERT_QP_MAX_REQ_DTOS	(ISCSI_DEF_XMIT_CMDS_MAX *    \
-				(1 + ISERT_INFLIGHT_DATAOUTS) + \
-				ISERT_MAX_TX_MISC_PDUS	+ \
-				ISERT_MAX_RX_MISC_PDUS)
-
-#define ISER_RX_PAD_SIZE	(ISER_RECV_DATA_SEG_LEN + 4096 - \
-		(ISER_RX_PAYLOAD_SIZE + sizeof(u64) + sizeof(struct ib_sge)))
-
-#define ISER_VER	0x10
-#define ISER_WSV	0x08
-#define ISER_RSV	0x04
-#define ISCSI_CTRL	0x10
-#define ISER_HELLO	0x20
-#define ISER_HELLORPLY	0x30
-- 
1.8.4.3
