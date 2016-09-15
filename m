From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V2 libibverbs 6/7] Expose RSS related capabilities
Date: Thu, 15 Sep 2016 15:48:10 +0300
Message-ID: <1473943691-3087-7-git-send-email-yishaih@mellanox.com>
References: <1473943691-3087-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473943691-3087-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Expose RSS related capabilities, it includes:

- QP types that support RSS on the device.
- Max number of receive work queue indirection tables that
  could be opened on the device.
- Max size of a receive work queue indirection table.
- Max number of work queues of receive type that
  could be opened on the device.

- Bit mask of the supported types of hash functions.
- Bit mask of the supported RX fields that can participate
  in the RX hashing.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 examples/devinfo.c            | 24 ++++++++++++++++++++++++
 include/infiniband/kern-abi.h | 10 ++++++++++
 include/infiniband/verbs.h    | 10 ++++++++++
 src/cmd.c                     | 19 +++++++++++++++++++
 4 files changed, 63 insertions(+)

diff --git a/examples/devinfo.c b/examples/devinfo.c
index c497650..1d0c2db 100644
--- a/examples/devinfo.c
+++ b/examples/devinfo.c
@@ -364,6 +364,28 @@ static void print_tso_caps(const struct ibv_tso_caps *caps)
 	}
 }
 
+static void print_rss_caps(const struct ibv_rss_caps *caps)
+{
+	uint32_t unknown_general_caps = ~(1 << IBV_QPT_RAW_PACKET |
+					  1 << IBV_QPT_UD);
+	printf("\trss_caps:\n");
+	printf("\t\tmax_rwq_indirection_tables:\t\t\t%u\n", caps->max_rwq_indirection_tables);
+	printf("\t\tmax_rwq_indirection_table_size:\t\t\t%u\n", caps->max_rwq_indirection_table_size);
+	printf("\t\trx_hash_function:\t\t\t\t0x%x\n", caps->rx_hash_function);
+	printf("\t\trx_hash_fields_mask:\t\t\t\t0x%" PRIX64 "\n", caps->rx_hash_fields_mask);
+
+	if (caps->supported_qpts) {
+		printf("\t\tsupported_qp:\n");
+		if (ibv_is_qpt_supported(caps->supported_qpts, IBV_QPT_RAW_PACKET))
+			printf("\t\t\t\t\tSUPPORT_RAW_PACKET\n");
+		if (ibv_is_qpt_supported(caps->supported_qpts, IBV_QPT_UD))
+			printf("\t\t\t\t\tSUPPORT_UD\n");
+		if (caps->supported_qpts & unknown_general_caps)
+			printf("\t\t\t\t\tUnknown flags: 0x%" PRIX32 "\n",
+			       caps->supported_qpts & unknown_general_caps);
+	}
+}
+
 static int print_hca_cap(struct ibv_device *ib_dev, uint8_t ib_port)
 {
 	struct ibv_context *ctx;
@@ -465,6 +487,8 @@ static int print_hca_cap(struct ibv_device *ib_dev, uint8_t ib_port)
 		printf("\tdevice_cap_flags_ex:\t\t0x%" PRIX64 "\n", device_attr.device_cap_flags_ex);
 		print_device_cap_flags_ex(device_attr.device_cap_flags_ex);
 		print_tso_caps(&device_attr.tso_caps);
+		print_rss_caps(&device_attr.rss_caps);
+		printf("\tmax_wq_type_rq:\t\t\t%u\n", device_attr.max_wq_type_rq);
 	}
 
 	for (port = 1; port <= device_attr.orig_attr.phys_port_cnt; ++port) {
diff --git a/include/infiniband/kern-abi.h b/include/infiniband/kern-abi.h
index 9f7964e..381fd50 100644
--- a/include/infiniband/kern-abi.h
+++ b/include/infiniband/kern-abi.h
@@ -271,6 +271,13 @@ struct ibv_odp_caps_resp {
 	__u32 reserved;
 };
 
+struct ibv_rss_caps_resp {
+	__u32 supported_qpts;
+	__u32 max_rwq_indirection_tables;
+	__u32 max_rwq_indirection_table_size;
+	__u32 reserved;
+};
+
 struct ibv_query_device_resp_ex {
 	struct ibv_query_device_resp base;
 	__u32 comp_mask;
@@ -279,6 +286,9 @@ struct ibv_query_device_resp_ex {
 	__u64 timestamp_mask;
 	__u64 hca_core_clock;
 	__u64 device_cap_flags_ex;
+	struct ibv_rss_caps_resp rss_caps;
+	__u32  max_wq_type_rq;
+	__u32 reserved;
 };
 
 struct ibv_query_port {
diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index eab5d1b..e994c21 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -238,6 +238,14 @@ enum ibv_rx_hash_fields {
 	IBV_RX_HASH_DST_PORT_UDP	= 1 << 7
 };
 
+struct ibv_rss_caps {
+	uint32_t supported_qpts;
+	uint32_t max_rwq_indirection_tables;
+	uint32_t max_rwq_indirection_table_size;
+	uint64_t rx_hash_fields_mask; /* enum ibv_rx_hash_fields */
+	uint8_t  rx_hash_function; /* enum ibv_rx_hash_function_flags */
+};
+
 struct ibv_device_attr_ex {
 	struct ibv_device_attr	orig_attr;
 	uint32_t		comp_mask;
@@ -246,6 +254,8 @@ struct ibv_device_attr_ex {
 	uint64_t		hca_core_clock;
 	uint64_t		device_cap_flags_ex;
 	struct ibv_tso_caps	tso_caps;
+	struct ibv_rss_caps     rss_caps;
+	uint32_t		max_wq_type_rq;
 };
 
 enum ibv_mtu {
diff --git a/src/cmd.c b/src/cmd.c
index 21f972a..11f6509 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -213,6 +213,25 @@ int ibv_cmd_query_device_ex(struct ibv_context *context,
 			attr->device_cap_flags_ex = resp->device_cap_flags_ex;
 	}
 
+	if (attr_size >= offsetof(struct ibv_device_attr_ex, rss_caps) +
+			 sizeof(attr->rss_caps)) {
+		if (resp->response_length >=
+		    offsetof(struct ibv_query_device_resp_ex, rss_caps) +
+		    sizeof(resp->rss_caps)) {
+			attr->rss_caps.supported_qpts = resp->rss_caps.supported_qpts;
+			attr->rss_caps.max_rwq_indirection_tables = resp->rss_caps.max_rwq_indirection_tables;
+			attr->rss_caps.max_rwq_indirection_table_size = resp->rss_caps.max_rwq_indirection_table_size;
+		}
+	}
+
+	if (attr_size >= offsetof(struct ibv_device_attr_ex, max_wq_type_rq) +
+			 sizeof(attr->max_wq_type_rq)) {
+		if (resp->response_length >=
+		    offsetof(struct ibv_query_device_resp_ex, max_wq_type_rq) +
+		    sizeof(resp->max_wq_type_rq))
+			attr->max_wq_type_rq = resp->max_wq_type_rq;
+	}
+
 	return 0;
 }
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
