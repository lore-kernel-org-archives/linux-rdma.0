From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libibverbs 2/5] Add timestamp_mask and hca_core_clock to ibv_query_device_ex
Date: Tue, 27 Oct 2015 18:51:37 +0200
Message-ID: <1445964700-13235-3-git-send-email-matanb@mellanox.com>
References: <1445964700-13235-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445964700-13235-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The fields timestamp_mask and hca_core_clock were added
to the extended version of ibv_query_device verb.
timestamp_mask represents the allowed mask of the timestamp.
Users could infer the accuracy of the reported possible
timestamp.
hca_core_clock represents the frequency of the HCA (in HZ).
Since timestamp and reading the HCA's core clock is given
in hardware cycles, knowing the frequency is mandatory in order
to convert this number into seconds.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 examples/devinfo.c            | 10 ++++++++++
 include/infiniband/kern-abi.h |  2 ++
 include/infiniband/verbs.h    | 28 +++++++++++++++-------------
 man/ibv_query_device_ex.3     |  6 ++++--
 src/cmd.c                     | 21 +++++++++++++++++++++
 src/ibverbs.h                 |  7 +++++++
 6 files changed, 59 insertions(+), 15 deletions(-)

diff --git a/examples/devinfo.c b/examples/devinfo.c
index a8de982..0af8c3b 100644
--- a/examples/devinfo.c
+++ b/examples/devinfo.c
@@ -339,6 +339,16 @@ static int print_hca_cap(struct ibv_device *ib_dev, uint8_t ib_port)
 		printf("\tlocal_ca_ack_delay:\t\t%d\n", device_attr.orig_attr.local_ca_ack_delay);
 
 		print_odp_caps(&device_attr.odp_caps);
+		if (device_attr.completion_timestamp_mask)
+			printf("\tcompletion timestamp_mask:\t\t\t0x%016lx\n",
+			       device_attr.completion_timestamp_mask);
+		else
+			printf("\tcompletion_timestamp_mask not supported\n");
+
+		if (device_attr.hca_core_clock)
+			printf("\thca_core_clock:\t\t\t%lukHZ\n", device_attr.hca_core_clock);
+		else
+			printf("\tcore clock not supported\n");
 	}
 
 	for (port = 1; port <= device_attr.orig_attr.phys_port_cnt; ++port) {
diff --git a/include/infiniband/kern-abi.h b/include/infiniband/kern-abi.h
index 800c5ab..cce6ade 100644
--- a/include/infiniband/kern-abi.h
+++ b/include/infiniband/kern-abi.h
@@ -267,6 +267,8 @@ struct ibv_query_device_resp_ex {
 	__u32 comp_mask;
 	__u32 response_length;
 	struct ibv_odp_caps_resp odp_caps;
+	__u64 timestamp_mask;
+	__u64 hca_core_clock;
 };
 
 struct ibv_query_port {
diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index 479bfca..51b880b 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -204,6 +204,8 @@ struct ibv_device_attr_ex {
 	struct ibv_device_attr	orig_attr;
 	uint32_t		comp_mask;
 	struct ibv_odp_caps	odp_caps;
+	uint64_t		completion_timestamp_mask;
+	uint64_t		hca_core_clock;
 };
 
 enum ibv_mtu {
@@ -378,6 +380,19 @@ struct ibv_wc {
 	uint8_t			dlid_path_bits;
 };
 
+enum ibv_wc_flags_ex {
+	IBV_WC_EX_GRH			= 1 << 0,
+	IBV_WC_EX_IMM			= 1 << 1,
+	IBV_WC_EX_WITH_BYTE_LEN		= 1 << 2,
+	IBV_WC_EX_WITH_IMM		= 1 << 3,
+	IBV_WC_EX_WITH_QP_NUM		= 1 << 4,
+	IBV_WC_EX_WITH_SRC_QP		= 1 << 5,
+	IBV_WC_EX_WITH_PKEY_INDEX	= 1 << 6,
+	IBV_WC_EX_WITH_SLID		= 1 << 7,
+	IBV_WC_EX_WITH_SL		= 1 << 8,
+	IBV_WC_EX_WITH_DLID_PATH_BITS	= 1 << 9,
+};
+
 enum {
 	IBV_WC_FEATURE_FLAGS = IBV_WC_EX_GRH | IBV_WC_EX_IMM
 };
@@ -393,19 +408,6 @@ enum {
 				 IBV_WC_EX_WITH_DLID_PATH_BITS
 };
 
-enum ibv_wc_flags_ex {
-	IBV_WC_EX_GRH			= 1 << 0,
-	IBV_WC_EX_IMM			= 1 << 1,
-	IBV_WC_EX_WITH_BYTE_LEN		= 1 << 2,
-	IBV_WC_EX_WITH_IMM		= 1 << 3,
-	IBV_WC_EX_WITH_QP_NUM		= 1 << 4,
-	IBV_WC_EX_WITH_SRC_QP		= 1 << 5,
-	IBV_WC_EX_WITH_PKEY_INDEX	= 1 << 6,
-	IBV_WC_EX_WITH_SLID		= 1 << 7,
-	IBV_WC_EX_WITH_SL		= 1 << 8,
-	IBV_WC_EX_WITH_DLID_PATH_BITS	= 1 << 9,
-};
-
 /* fields order in wc_ex
  *	uint32_t		byte_len,
  *	uint32_t		imm_data;	// in network byte order
diff --git a/man/ibv_query_device_ex.3 b/man/ibv_query_device_ex.3
index 1f483d2..db12c2b 100644
--- a/man/ibv_query_device_ex.3
+++ b/man/ibv_query_device_ex.3
@@ -22,8 +22,10 @@ is a pointer to an ibv_device_attr_ex struct, as defined in <infiniband/verbs.h>
 struct ibv_device_attr_ex {
 .in +8
 struct ibv_device_attr orig_attr;
-uint32_t               comp_mask;              /* Compatibility mask that defines which of the following variables are valid */
-struct ibv_odp_caps    odp_caps;               /* On-Demand Paging capabilities */
+uint32_t               comp_mask;                  /* Compatibility mask that defines which of the following variables are valid */
+struct ibv_odp_caps    odp_caps;                   /* On-Demand Paging capabilities */
+uint64_t               completion_timestamp_mask;  /* Completion timestamp mask (0 = unsupported) */
+uint64_t               hca_core_clock;             /* The frequency (in kHZ) of the HCA (0 = unsupported) */
 .in -8
 };
 
diff --git a/src/cmd.c b/src/cmd.c
index e1914e9..a65b6b9 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -189,6 +189,27 @@ int ibv_cmd_query_device_ex(struct ibv_context *context,
 		}
 	}
 
+	if (attr_size >= offsetof(struct ibv_device_attr_ex,
+				  completion_timestamp_mask) +
+			 sizeof(attr->completion_timestamp_mask)) {
+		if (IBV_IS_FIELD_IN_RESP(resp, resp_core_size, timestamp_mask))
+			attr->completion_timestamp_mask = resp->timestamp_mask;
+		else
+			attr->completion_timestamp_mask = 0;
+	}
+
+	if (attr_size >= offsetof(struct ibv_device_attr_ex, hca_core_clock) +
+			 sizeof(attr->hca_core_clock)) {
+		if (IBV_IS_FIELD_IN_RESP(resp, resp_core_size, hca_core_clock))
+			attr->hca_core_clock = resp->hca_core_clock;
+		else
+			attr->hca_core_clock = 0;
+	}
+
+	if (attr_size > sizeof(*attr))
+		memset((void *)attr + sizeof(*attr), 0,
+		       attr_size - sizeof(*attr));
+
 	return 0;
 }
 
diff --git a/src/ibverbs.h b/src/ibverbs.h
index ff206f9..b3feb89 100644
--- a/src/ibverbs.h
+++ b/src/ibverbs.h
@@ -131,4 +131,11 @@ HIDDEN int ibverbs_init(struct ibv_device ***list);
 #define IBV_INIT_CMD_EX(cmd, size, opcode)				     \
 	IBV_INIT_CMD_RESP_EX_V(cmd, sizeof(*(cmd)), size, opcode, NULL, 0, 0)
 
+#define _FILED_SZ_IN_STRUCT(resp, field)				\
+	(((void *)(&(resp)->field) - (void *)(resp)) + sizeof((resp)->field))
+
+#define IBV_IS_FIELD_IN_RESP(resp, resp_len, field)			\
+	((resp_len) >= _FILED_SZ_IN_STRUCT(resp, field) &&		\
+	 (resp)->response_length >= _FILED_SZ_IN_STRUCT(resp, field))
+
 #endif /* IB_VERBS_H */
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
