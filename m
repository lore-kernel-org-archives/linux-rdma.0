From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 1/3] ibverbs: Report packet pacing capabilities when querying device
Date: Sun,  8 Jan 2017 18:32:26 +0200
Message-ID: <1483893148-8211-2-git-send-email-yishaih@mellanox.com>
References: <1483893148-8211-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1483893148-8211-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The capabilities include two parts:
1. The minimum (qp_rate_limit_min) and maximum(qp_rate_limit_max)
   rate limit in kbps.
2. QP types supported by the device (supported_qpts).

Signed-off-by: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/examples/devinfo.c        | 21 +++++++++++++++++++++
 libibverbs/man/ibv_query_device_ex.3 |  7 +++++++
 libibverbs/verbs.h                   |  7 +++++++
 3 files changed, 35 insertions(+)

diff --git a/libibverbs/examples/devinfo.c b/libibverbs/examples/devinfo.c
index 78e92b9..54976bb 100644
--- a/libibverbs/examples/devinfo.c
+++ b/libibverbs/examples/devinfo.c
@@ -384,6 +384,26 @@ static void print_rss_caps(const struct ibv_rss_caps *caps)
 	}
 }
 
+static void print_packet_pacing_caps(const struct ibv_packet_pacing_caps *caps)
+{
+	uint32_t unknown_general_caps = ~(1 << IBV_QPT_RAW_PACKET |
+					  1 << IBV_QPT_UD);
+	printf("\tpacket_pacing_caps:\n");
+	printf("\t\tqp_rate_limit_min:\t%ukbps\n", caps->qp_rate_limit_min);
+	printf("\t\tqp_rate_limit_max:\t%ukbps\n", caps->qp_rate_limit_max);
+
+	if (caps->qp_rate_limit_max) {
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
@@ -487,6 +507,7 @@ static int print_hca_cap(struct ibv_device *ib_dev, uint8_t ib_port)
 		print_tso_caps(&device_attr.tso_caps);
 		print_rss_caps(&device_attr.rss_caps);
 		printf("\tmax_wq_type_rq:\t\t\t%u\n", device_attr.max_wq_type_rq);
+		print_packet_pacing_caps(&device_attr.packet_pacing_caps);
 	}
 
 	for (port = 1; port <= device_attr.orig_attr.phys_port_cnt; ++port) {
diff --git a/libibverbs/man/ibv_query_device_ex.3 b/libibverbs/man/ibv_query_device_ex.3
index 4da63a0..c291017 100644
--- a/libibverbs/man/ibv_query_device_ex.3
+++ b/libibverbs/man/ibv_query_device_ex.3
@@ -31,6 +31,7 @@ uint64_t               device_cap_flags_ex;        /* Extended device capability
 struct ibv_tso_caps    tso_caps;                   /* TCP segmentation offload capabilities */
 struct ibv_rss_caps    rss_caps;                   /* RSS capabilities */
 uint32_t               max_wq_type_rq;             /* Max Work Queue from type RQ */
+struct ibv_packet_pacing_caps packet_pacing_caps; /* Packet pacing capabilities */
 .in -8
 };
 
@@ -68,6 +69,12 @@ struct ibv_rss_caps {
         uint8_t  rx_hash_function;                 /* Mask with enum ibv_rx_hash_function_flags to know which hash functions are supported */
 };
 
+struct ibv_packet_pacing_caps {
+       uint32_t qp_rate_limit_min; /* Minimum rate limit in kbps */
+       uint32_t qp_rate_limit_max; /* Maximum rate limit in kbps */
+       uint32_t supported_qpts;    /* Bitmap showing which QP types are supported. */
+};
+
 .fi
 .SH "RETURN VALUE"
 .B ibv_query_device_ex()
diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index 29f287b..6606196 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -246,6 +246,12 @@ struct ibv_rss_caps {
 	uint8_t  rx_hash_function; /* enum ibv_rx_hash_function_flags */
 };
 
+struct ibv_packet_pacing_caps {
+	uint32_t qp_rate_limit_min;
+	uint32_t qp_rate_limit_max; /* In kbps */
+	uint32_t supported_qpts;
+};
+
 struct ibv_device_attr_ex {
 	struct ibv_device_attr	orig_attr;
 	uint32_t		comp_mask;
@@ -256,6 +262,7 @@ struct ibv_device_attr_ex {
 	struct ibv_tso_caps	tso_caps;
 	struct ibv_rss_caps     rss_caps;
 	uint32_t		max_wq_type_rq;
+	struct ibv_packet_pacing_caps packet_pacing_caps;
 };
 
 enum ibv_mtu {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
