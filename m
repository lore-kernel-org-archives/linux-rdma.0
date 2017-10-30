From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 1/4] verbs: Expose CQ moderation capabilities
Date: Mon, 30 Oct 2017 16:09:00 +0200
Message-ID: <1509372543-26603-2-git-send-email-yishaih@mellanox.com>
References: <1509372543-26603-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1509372543-26603-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Extend ibv_query_device_ex to read from the kernel the CQ moderation
capabilities as of cq_max_count and cq_max_period.
Those CAPs represent the valid values that can be set to accumulate
CQEs before the hardware generates an event.
A returned value of 0 denotes that CQ moderation is not supported.

Signed-off-by: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/cmd.c                     | 10 ++++++++++
 libibverbs/examples/devinfo.c        | 11 +++++++++++
 libibverbs/kern-abi.h                |  7 +++++++
 libibverbs/man/ibv_query_device_ex.3 |  6 ++++++
 libibverbs/verbs.h                   |  6 ++++++
 5 files changed, 40 insertions(+)

diff --git a/libibverbs/cmd.c b/libibverbs/cmd.c
index 713a13c..b903ade 100644
--- a/libibverbs/cmd.c
+++ b/libibverbs/cmd.c
@@ -255,6 +255,16 @@ int ibv_cmd_query_device_ex(struct ibv_context *context,
 		}
 	}
 
+	if (attr_size >= offsetof(struct ibv_device_attr_ex, cq_mod_caps) +
+			 sizeof(attr->cq_mod_caps)) {
+		if (resp->response_length >=
+		    offsetof(struct ibv_query_device_resp_ex, cq_mod_caps) +
+		    sizeof(resp->cq_mod_caps)) {
+			attr->cq_mod_caps.max_cq_count = resp->cq_mod_caps.cq_count;
+			attr->cq_mod_caps.max_cq_period = resp->cq_mod_caps.cq_period;
+		}
+	}
+
 	return 0;
 }
 
diff --git a/libibverbs/examples/devinfo.c b/libibverbs/examples/devinfo.c
index 33f7e95..169da2e 100644
--- a/libibverbs/examples/devinfo.c
+++ b/libibverbs/examples/devinfo.c
@@ -397,6 +397,16 @@ static void print_rss_caps(const struct ibv_rss_caps *caps)
 	}
 }
 
+static void print_cq_moderation_caps(const struct ibv_cq_moderation_caps *cq_caps)
+{
+	if (!cq_caps->max_cq_count || !cq_caps->max_cq_period)
+		return;
+
+	printf("\n\tcq moderation caps:\n");
+	printf("\t\tmax_cq_count:\t%u\n", cq_caps->max_cq_count);
+	printf("\t\tmax_cq_period:\t%u us\n\n", cq_caps->max_cq_period);
+}
+
 static void print_packet_pacing_caps(const struct ibv_packet_pacing_caps *caps)
 {
 	uint32_t unknown_general_caps = ~(1 << IBV_QPT_RAW_PACKET |
@@ -538,6 +548,7 @@ static int print_hca_cap(struct ibv_device *ib_dev, uint8_t ib_port)
 		printf("\tmax_wq_type_rq:\t\t\t%u\n", device_attr.max_wq_type_rq);
 		print_packet_pacing_caps(&device_attr.packet_pacing_caps);
 		print_tm_caps(&device_attr.tm_caps);
+		print_cq_moderation_caps(&device_attr.cq_mod_caps);
 	}
 
 	for (port = 1; port <= device_attr.orig_attr.phys_port_cnt; ++port) {
diff --git a/libibverbs/kern-abi.h b/libibverbs/kern-abi.h
index 6a16566..a80d2e6 100644
--- a/libibverbs/kern-abi.h
+++ b/libibverbs/kern-abi.h
@@ -289,6 +289,12 @@ struct ibv_tm_caps_resp {
 	__u32 reserved;
 };
 
+struct ibv_cq_moderation_caps_resp {
+	__u16  cq_count;
+	__u16  cq_period;
+	__u32  reserved;
+};
+
 struct ibv_query_device_resp_ex {
 	struct ibv_query_device_resp base;
 	__u32 comp_mask;
@@ -301,6 +307,7 @@ struct ibv_query_device_resp_ex {
 	__u32  max_wq_type_rq;
 	__u32 raw_packet_caps;
 	struct ibv_tm_caps_resp tm_caps;
+	struct ibv_cq_moderation_caps_resp cq_mod_caps;
 };
 
 struct ibv_query_port {
diff --git a/libibverbs/man/ibv_query_device_ex.3 b/libibverbs/man/ibv_query_device_ex.3
index c0cb77b..1a5c008 100644
--- a/libibverbs/man/ibv_query_device_ex.3
+++ b/libibverbs/man/ibv_query_device_ex.3
@@ -34,6 +34,7 @@ uint32_t               max_wq_type_rq;             /* Max Work Queue from type R
 struct ibv_packet_pacing_caps packet_pacing_caps; /* Packet pacing capabilities */
 uint32_t               raw_packet_caps;            /* Raw packet capabilities, use enum ibv_raw_packet_caps */
 struct ibv_tm_caps     tm_caps;                    /* Tag matching capabilities */
+struct ibv_cq_moderation_caps  cq_mod_caps;        /* CQ moderation max capabilities */
 .in -8
 };
 
@@ -101,6 +102,11 @@ uint32_t        max_sge;             /* Max number of SGEs in a tagged buffer */
 .in -8
 };
 
+struct ibv_cq_moderation_caps {
+	uint16_t max_cq_count;
+	uint16_t max_cq_period;
+};
+
 .fi
 .SH "RETURN VALUE"
 .B ibv_query_device_ex()
diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index 1ab747b..dbc95cb 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -286,6 +286,11 @@ struct ibv_tm_caps {
 	uint32_t max_sge;
 };
 
+struct ibv_cq_moderation_caps {
+	uint16_t max_cq_count;
+	uint16_t max_cq_period; /* in micro seconds */
+};
+
 struct ibv_device_attr_ex {
 	struct ibv_device_attr	orig_attr;
 	uint32_t		comp_mask;
@@ -299,6 +304,7 @@ struct ibv_device_attr_ex {
 	struct ibv_packet_pacing_caps packet_pacing_caps;
 	uint32_t		raw_packet_caps; /* Use ibv_raw_packet_caps */
 	struct ibv_tm_caps	tm_caps;
+	struct ibv_cq_moderation_caps  cq_mod_caps;
 };
 
 enum ibv_mtu {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
