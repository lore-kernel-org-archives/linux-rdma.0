From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 02/10] verbs: Expose tag matching capabilities
Date: Mon, 23 Oct 2017 16:17:53 +0300
Message-ID: <1508764681-4531-3-git-send-email-yishaih@mellanox.com>
References: <1508764681-4531-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1508764681-4531-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Expose tag matching capabilities and show them in ibv_devinfo.

Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 Documentation/tag_matching.md        | 14 ++++++++++++++
 libibverbs/cmd.c                     | 17 +++++++++++++++++
 libibverbs/examples/devinfo.c        | 17 +++++++++++++++++
 libibverbs/kern-abi.h                | 10 ++++++++++
 libibverbs/man/ibv_query_device_ex.3 | 17 +++++++++++++++++
 libibverbs/verbs.h                   | 18 ++++++++++++++++++
 6 files changed, 93 insertions(+)

diff --git a/Documentation/tag_matching.md b/Documentation/tag_matching.md
index 5b5cd7d..8e62440 100644
--- a/Documentation/tag_matching.md
+++ b/Documentation/tag_matching.md
@@ -130,3 +130,17 @@ achieved by reporting to HW the number of unexpected messages handled by SW
 (with respect to the current posted tags). When the SW and HW are in synch, tag
 matching resumes normally.
 
+## Tag Matching Verbs
+
+### Capabilities
+
+Tag matching capabilities are queried by ibv_query_device_ex(), and report the
+following attributes:
+
+* **max_rndv_hdr_size** - Max size of rendezvous request header
+* **max_num_tags** - Max number of tagged buffers in a TM-SRQ matching list
+* **max_ops** - Max number of outstanding tag matching list operations
+* **max_sge** - Max number of SGEs in a tagged buffer
+* **flags** - the following flags are currently defined:
+    - IBV_TM_CAP_RC - Support tag matching on RC transport
+
diff --git a/libibverbs/cmd.c b/libibverbs/cmd.c
index 9d2140f..97351de 100644
--- a/libibverbs/cmd.c
+++ b/libibverbs/cmd.c
@@ -238,6 +238,23 @@ int ibv_cmd_query_device_ex(struct ibv_context *context,
 			attr->raw_packet_caps = resp->raw_packet_caps;
 	}
 
+	if (attr_size >= offsetof(struct ibv_device_attr_ex, tm_caps) +
+			 sizeof(attr->tm_caps)) {
+		if (resp->response_length >=
+		    offsetof(struct ibv_query_device_resp_ex, tm_caps) +
+		    sizeof(resp->tm_caps)) {
+			attr->tm_caps.max_rndv_hdr_size =
+				resp->tm_caps.max_rndv_hdr_size;
+			attr->tm_caps.max_num_tags =
+				resp->tm_caps.max_num_tags;
+			attr->tm_caps.flags = resp->tm_caps.flags;
+			attr->tm_caps.max_ops =
+				resp->tm_caps.max_ops;
+			attr->tm_caps.max_sge =
+				resp->tm_caps.max_sge;
+		}
+	}
+
 	return 0;
 }
 
diff --git a/libibverbs/examples/devinfo.c b/libibverbs/examples/devinfo.c
index f03c53e..33f7e95 100644
--- a/libibverbs/examples/devinfo.c
+++ b/libibverbs/examples/devinfo.c
@@ -340,6 +340,22 @@ static void print_device_cap_flags_ex(uint64_t device_cap_flags_ex)
 		       ex_flags & unknown_flags);
 }
 
+static void print_tm_caps(const struct ibv_tm_caps *caps)
+{
+	if (caps->max_num_tags) {
+		printf("\tmax_rndv_hdr_size:\t\t%u\n",
+				caps->max_rndv_hdr_size);
+		printf("\tmax_num_tags:\t\t\t%u\n", caps->max_num_tags);
+		printf("\tmax_ops:\t\t\t%u\n", caps->max_ops);
+		printf("\tmax_sge:\t\t\t%u\n", caps->max_sge);
+		printf("\tflags:\n");
+		if (caps->flags & IBV_TM_CAP_RC)
+			printf("\t\t\t\t\tIBV_TM_CAP_RC\n");
+	} else {
+		printf("\ttag matching not supported\n");
+	}
+}
+
 static void print_tso_caps(const struct ibv_tso_caps *caps)
 {
 	uint32_t unknown_general_caps = ~(1 << IBV_QPT_RAW_PACKET |
@@ -521,6 +537,7 @@ static int print_hca_cap(struct ibv_device *ib_dev, uint8_t ib_port)
 		print_rss_caps(&device_attr.rss_caps);
 		printf("\tmax_wq_type_rq:\t\t\t%u\n", device_attr.max_wq_type_rq);
 		print_packet_pacing_caps(&device_attr.packet_pacing_caps);
+		print_tm_caps(&device_attr.tm_caps);
 	}
 
 	for (port = 1; port <= device_attr.orig_attr.phys_port_cnt; ++port) {
diff --git a/libibverbs/kern-abi.h b/libibverbs/kern-abi.h
index 3a0e02a..5f3f28c 100644
--- a/libibverbs/kern-abi.h
+++ b/libibverbs/kern-abi.h
@@ -280,6 +280,15 @@ struct ibv_rss_caps_resp {
 	__u32 reserved;
 };
 
+struct ibv_tm_caps_resp {
+	__u32 max_rndv_hdr_size;
+	__u32 max_num_tags;
+	__u32 flags;
+	__u32 max_ops;
+	__u32 max_sge;
+	__u32 reserved;
+};
+
 struct ibv_query_device_resp_ex {
 	struct ibv_query_device_resp base;
 	__u32 comp_mask;
@@ -291,6 +300,7 @@ struct ibv_query_device_resp_ex {
 	struct ibv_rss_caps_resp rss_caps;
 	__u32  max_wq_type_rq;
 	__u32 raw_packet_caps;
+	struct ibv_tm_caps_resp tm_caps;
 };
 
 struct ibv_query_port {
diff --git a/libibverbs/man/ibv_query_device_ex.3 b/libibverbs/man/ibv_query_device_ex.3
index fdfb708..c0cb77b 100644
--- a/libibverbs/man/ibv_query_device_ex.3
+++ b/libibverbs/man/ibv_query_device_ex.3
@@ -33,6 +33,7 @@ struct ibv_rss_caps    rss_caps;                   /* RSS capabilities */
 uint32_t               max_wq_type_rq;             /* Max Work Queue from type RQ */
 struct ibv_packet_pacing_caps packet_pacing_caps; /* Packet pacing capabilities */
 uint32_t               raw_packet_caps;            /* Raw packet capabilities, use enum ibv_raw_packet_caps */
+struct ibv_tm_caps     tm_caps;                    /* Tag matching capabilities */
 .in -8
 };
 
@@ -84,6 +85,22 @@ IBV_RAW_PACKET_CAP_IP_CSUM		= 1 << 2, /* IP CSUM offload is supported */
 .in -8
 };
 
+enum ibv_tm_cap_flags {
+.in +8
+IBV_TM_CAP_RC   = 1 << 0,            /* Support tag matching on RC transport */
+.in -8
+};
+
+struct ibv_tm_caps {
+.in +8
+uint32_t        max_rndv_hdr_size;   /* Max size of rendezvous request header */
+uint32_t        max_num_tags;        /* Max number of tagged buffers in a TM-SRQ matching list */
+uint32_t        flags;    	     /* From enum ibv_tm_cap_flags */
+uint32_t        max_ops;             /* Max number of outstanding list operations */
+uint32_t        max_sge;             /* Max number of SGEs in a tagged buffer */
+.in -8
+};
+
 .fi
 .SH "RETURN VALUE"
 .B ibv_query_device_ex()
diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index 4e2f338..2ef9132 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -266,6 +266,23 @@ enum ibv_raw_packet_caps {
 	IBV_RAW_PACKET_CAP_DELAY_DROP		= 1 << 3,
 };
 
+enum ibv_tm_cap_flags {
+	IBV_TM_CAP_RC		    = 1 << 0,
+};
+
+struct ibv_tm_caps {
+	/* Max size of rendezvous request header */
+	uint32_t max_rndv_hdr_size;
+	/* Max number of tagged buffers in a TM-SRQ matching list */
+	uint32_t max_num_tags;
+	/* From enum ibv_tm_cap_flags */
+	uint32_t flags;
+	/* Max number of outstanding list operations */
+	uint32_t max_ops;
+	/* Max number of SGEs in a tagged buffer */
+	uint32_t max_sge;
+};
+
 struct ibv_device_attr_ex {
 	struct ibv_device_attr	orig_attr;
 	uint32_t		comp_mask;
@@ -278,6 +295,7 @@ struct ibv_device_attr_ex {
 	uint32_t		max_wq_type_rq;
 	struct ibv_packet_pacing_caps packet_pacing_caps;
 	uint32_t		raw_packet_caps; /* Use ibv_raw_packet_caps */
+	struct ibv_tm_caps	tm_caps;
 };
 
 enum ibv_mtu {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
