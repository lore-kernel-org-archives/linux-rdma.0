From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 rdma-core 1/6] ibverbs: Report raw packet caps as part of query device
Date: Wed, 15 Mar 2017 17:27:41 +0200
Message-ID: <1489591666-14062-2-git-send-email-yishaih@mellanox.com>
References: <1489591666-14062-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1489591666-14062-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Currently, existing raw packet capabilities (IP CSUM and scatter FCS)
are reported separately to the user via ibv_query_device_ex.

Unify those capabilities into a single enum and report them together
for a better user experience.

Also introduce CVLAN stripping offload capability. CVLAN is the
customer VLAN tag (inner tag).
CVLAN stripping offload is the device's ability to strip this tag
from incoming raw Ethernet packets and report the data in the
matching work completion.

This patch includes:
- Reading from the uverbs layer and report back to an application.
- Extending ibv_devinfo to print that information.

Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/cmd.c                     |  8 ++++++++
 libibverbs/examples/devinfo.c        | 14 ++++++++++++++
 libibverbs/kern-abi.h                |  2 +-
 libibverbs/man/ibv_query_device_ex.3 |  9 +++++++++
 libibverbs/verbs.h                   |  7 +++++++
 5 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/libibverbs/cmd.c b/libibverbs/cmd.c
index 9b49da0..4aebbb5 100644
--- a/libibverbs/cmd.c
+++ b/libibverbs/cmd.c
@@ -230,6 +230,14 @@ int ibv_cmd_query_device_ex(struct ibv_context *context,
 			attr->max_wq_type_rq = resp->max_wq_type_rq;
 	}
 
+	if (attr_size >= offsetof(struct ibv_device_attr_ex, raw_packet_caps) +
+			 sizeof(attr->raw_packet_caps)) {
+		if (resp->response_length >=
+		    offsetof(struct ibv_query_device_resp_ex, raw_packet_caps) +
+		    sizeof(resp->raw_packet_caps))
+			attr->raw_packet_caps = resp->raw_packet_caps;
+	}
+
 	return 0;
 }
 
diff --git a/libibverbs/examples/devinfo.c b/libibverbs/examples/devinfo.c
index d88562f..42222c4 100644
--- a/libibverbs/examples/devinfo.c
+++ b/libibverbs/examples/devinfo.c
@@ -401,6 +401,17 @@ static void print_packet_pacing_caps(const struct ibv_packet_pacing_caps *caps)
 	}
 }
 
+static void print_raw_packet_caps(uint32_t raw_packet_caps)
+{
+	printf("\traw packet caps:\n");
+	if (raw_packet_caps & IBV_RAW_PACKET_CAP_CVLAN_STRIPPING)
+		printf("\t\t\t\t\tC-VLAN stripping offload\n");
+	if (raw_packet_caps & IBV_RAW_PACKET_CAP_SCATTER_FCS)
+		printf("\t\t\t\t\tScatter FCS offload\n");
+	if (raw_packet_caps & IBV_RAW_PACKET_CAP_IP_CSUM)
+		printf("\t\t\t\t\tIP csum offload\n");
+}
+
 static int print_hca_cap(struct ibv_device *ib_dev, uint8_t ib_port)
 {
 	struct ibv_context *ctx;
@@ -499,6 +510,9 @@ static int print_hca_cap(struct ibv_device *ib_dev, uint8_t ib_port)
 		else
 			printf("\tcore clock not supported\n");
 
+		if (device_attr.raw_packet_caps)
+			print_raw_packet_caps(device_attr.raw_packet_caps);
+
 		printf("\tdevice_cap_flags_ex:\t\t0x%" PRIX64 "\n", device_attr.device_cap_flags_ex);
 		print_device_cap_flags_ex(device_attr.device_cap_flags_ex);
 		print_tso_caps(&device_attr.tso_caps);
diff --git a/libibverbs/kern-abi.h b/libibverbs/kern-abi.h
index 210dd3e..3958f0c 100644
--- a/libibverbs/kern-abi.h
+++ b/libibverbs/kern-abi.h
@@ -290,7 +290,7 @@ struct ibv_query_device_resp_ex {
 	__u64 device_cap_flags_ex;
 	struct ibv_rss_caps_resp rss_caps;
 	__u32  max_wq_type_rq;
-	__u32 reserved;
+	__u32 raw_packet_caps;
 };
 
 struct ibv_query_port {
diff --git a/libibverbs/man/ibv_query_device_ex.3 b/libibverbs/man/ibv_query_device_ex.3
index c291017..fdfb708 100644
--- a/libibverbs/man/ibv_query_device_ex.3
+++ b/libibverbs/man/ibv_query_device_ex.3
@@ -32,6 +32,7 @@ struct ibv_tso_caps    tso_caps;                   /* TCP segmentation offload c
 struct ibv_rss_caps    rss_caps;                   /* RSS capabilities */
 uint32_t               max_wq_type_rq;             /* Max Work Queue from type RQ */
 struct ibv_packet_pacing_caps packet_pacing_caps; /* Packet pacing capabilities */
+uint32_t               raw_packet_caps;            /* Raw packet capabilities, use enum ibv_raw_packet_caps */
 .in -8
 };
 
@@ -75,6 +76,14 @@ struct ibv_packet_pacing_caps {
        uint32_t supported_qpts;    /* Bitmap showing which QP types are supported. */
 };
 
+enum ibv_raw_packet_caps {
+.in +8
+IBV_RAW_PACKET_CAP_CVLAN_STRIPPING	= 1 << 0, /* CVLAN stripping is supported */
+IBV_RAW_PACKET_CAP_SCATTER_FCS		= 1 << 1, /* FCS scattering is supported */
+IBV_RAW_PACKET_CAP_IP_CSUM		= 1 << 2, /* IP CSUM offload is supported */
+.in -8
+};
+
 .fi
 .SH "RETURN VALUE"
 .B ibv_query_device_ex()
diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index 25f4ede..604b09e 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -252,6 +252,12 @@ struct ibv_packet_pacing_caps {
 	uint32_t supported_qpts;
 };
 
+enum ibv_raw_packet_caps {
+	IBV_RAW_PACKET_CAP_CVLAN_STRIPPING	= 1 << 0,
+	IBV_RAW_PACKET_CAP_SCATTER_FCS		= 1 << 1,
+	IBV_RAW_PACKET_CAP_IP_CSUM		= 1 << 2,
+};
+
 struct ibv_device_attr_ex {
 	struct ibv_device_attr	orig_attr;
 	uint32_t		comp_mask;
@@ -263,6 +269,7 @@ struct ibv_device_attr_ex {
 	struct ibv_rss_caps     rss_caps;
 	uint32_t		max_wq_type_rq;
 	struct ibv_packet_pacing_caps packet_pacing_caps;
+	uint32_t		raw_packet_caps; /* Use ibv_raw_packet_caps */
 };
 
 enum ibv_mtu {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
