From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 2/3] Add on-demand paging support
Date: Thu, 27 Aug 2015 18:22:34 +0300
Message-ID: <1440688955-7709-3-git-send-email-haggaie@mellanox.com>
References: <1440688955-7709-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1440688955-7709-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On-demand paging feature allows registering memory regions without pinning
their pages. Unfortunately the feature doesn't work together will all
transports and all operations. This patch adds the ability to report on-demand
paging capabilities through the ibv_query_device_ex.

The patch also add the IBV_ACCESS_ON_DEMAND access flag to allow registration
of on-demand paging enabled memory regions.

Signed-off-by: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 examples/devinfo.c            | 51 +++++++++++++++++++++++++++++++++++++++++++
 include/infiniband/kern-abi.h | 12 +++++++++-
 include/infiniband/verbs.h    | 25 ++++++++++++++++++++-
 man/ibv_query_device_ex.3     | 23 +++++++++++++++++++
 man/ibv_reg_mr.3              |  2 ++
 src/cmd.c                     | 11 ++++++++++
 6 files changed, 122 insertions(+), 2 deletions(-)

diff --git a/examples/devinfo.c b/examples/devinfo.c
index 95e8f83753ca..61cfdf520be6 100644
--- a/examples/devinfo.c
+++ b/examples/devinfo.c
@@ -43,6 +43,7 @@
 #include <netinet/in.h>
 #include <endian.h>
 #include <byteswap.h>
+#include <inttypes.h>
 
 #include <infiniband/verbs.h>
 #include <infiniband/driver.h>
@@ -204,6 +205,54 @@ static const char *link_layer_str(uint8_t link_layer)
 	}
 }
 
+void print_odp_trans_caps(uint32_t trans)
+{
+	uint32_t unknown_transport_caps = ~(IBV_ODP_SUPPORT_SEND |
+					    IBV_ODP_SUPPORT_RECV |
+					    IBV_ODP_SUPPORT_WRITE |
+					    IBV_ODP_SUPPORT_READ |
+					    IBV_ODP_SUPPORT_ATOMIC);
+
+	if (!trans) {
+		printf("\t\t\t\t\tNO SUPPORT\n");
+	} else {
+		if (trans & IBV_ODP_SUPPORT_SEND)
+			printf("\t\t\t\t\tSUPPORT_SEND\n");
+		if (trans & IBV_ODP_SUPPORT_RECV)
+			printf("\t\t\t\t\tSUPPORT_RECV\n");
+		if (trans & IBV_ODP_SUPPORT_WRITE)
+			printf("\t\t\t\t\tSUPPORT_WRITE\n");
+		if (trans & IBV_ODP_SUPPORT_READ)
+			printf("\t\t\t\t\tSUPPORT_READ\n");
+		if (trans & IBV_ODP_SUPPORT_ATOMIC)
+			printf("\t\t\t\t\tSUPPORT_ATOMIC\n");
+		if (trans & unknown_transport_caps)
+			printf("\t\t\t\t\tUnknown flags: 0x%" PRIX32 "\n",
+			       trans & unknown_transport_caps);
+	}
+}
+
+void print_odp_caps(struct ibv_odp_caps caps)
+{
+	uint64_t unknown_general_caps = ~(IBV_ODP_SUPPORT);
+
+	/* general odp caps */
+	printf("\tgeneral_odp_caps:\n");
+	if (caps.general_caps & IBV_ODP_SUPPORT)
+		printf("\t\t\t\t\tODP_SUPPORT\n");
+	if (caps.general_caps & unknown_general_caps)
+		printf("\t\t\t\t\tUnknown flags: 0x%" PRIX64 "\n",
+		       caps.general_caps & unknown_general_caps);
+
+	/* RC transport */
+	printf("\trc_odp_caps:\n");
+	print_odp_trans_caps(caps.per_transport_caps.rc_odp_caps);
+	printf("\tuc_odp_caps:\n");
+	print_odp_trans_caps(caps.per_transport_caps.uc_odp_caps);
+	printf("\tud_odp_caps:\n");
+	print_odp_trans_caps(caps.per_transport_caps.ud_odp_caps);
+}
+
 static int print_hca_cap(struct ibv_device *ib_dev, uint8_t ib_port)
 {
 	struct ibv_context *ctx;
@@ -296,6 +345,8 @@ static int print_hca_cap(struct ibv_device *ib_dev, uint8_t ib_port)
 		}
 		printf("\tmax_pkeys:\t\t\t%d\n", device_attr.max_pkeys);
 		printf("\tlocal_ca_ack_delay:\t\t%d\n", device_attr.local_ca_ack_delay);
+
+		print_odp_caps(attrx.odp_caps);
 	}
 
 	for (port = 1; port <= device_attr.phys_port_cnt; ++port) {
diff --git a/include/infiniband/kern-abi.h b/include/infiniband/kern-abi.h
index af2a1bebf683..1c0d0d30c612 100644
--- a/include/infiniband/kern-abi.h
+++ b/include/infiniband/kern-abi.h
@@ -254,11 +254,21 @@ struct ibv_query_device_ex {
 	__u32		reserved;
 };
 
+struct ibv_odp_caps_resp {
+	__u64 general_caps;
+	struct {
+		__u32 rc_odp_caps;
+		__u32 uc_odp_caps;
+		__u32 ud_odp_caps;
+	} per_transport_caps;
+	__u32 reserved;
+};
+
 struct ibv_query_device_resp_ex {
 	struct ibv_query_device_resp base;
 	__u32 comp_mask;
 	__u32 response_length;
-	__u64 reserved[3];
+	struct ibv_odp_caps_resp odp_caps;
 };
 
 struct ibv_query_port {
diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index ff806bf8555d..ce56315b236e 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -168,9 +168,31 @@ struct ibv_device_attr {
 	uint8_t			phys_port_cnt;
 };
 
+enum ibv_odp_transport_cap_bits {
+	IBV_ODP_SUPPORT_SEND     = 1 << 0,
+	IBV_ODP_SUPPORT_RECV     = 1 << 1,
+	IBV_ODP_SUPPORT_WRITE    = 1 << 2,
+	IBV_ODP_SUPPORT_READ     = 1 << 3,
+	IBV_ODP_SUPPORT_ATOMIC   = 1 << 4,
+};
+
+struct ibv_odp_caps {
+	uint64_t general_caps;
+	struct {
+		uint32_t rc_odp_caps;
+		uint32_t uc_odp_caps;
+		uint32_t ud_odp_caps;
+	} per_transport_caps;
+};
+
+enum ibv_odp_general_caps {
+	IBV_ODP_SUPPORT = 1 << 0,
+};
+
 struct ibv_device_attr_ex {
 	struct ibv_device_attr	orig_attr;
 	uint32_t		comp_mask;
+	struct ibv_odp_caps	odp_caps;
 };
 
 struct ibv_device_attr_ex_resp {
@@ -350,7 +372,8 @@ enum ibv_access_flags {
 	IBV_ACCESS_REMOTE_WRITE		= (1<<1),
 	IBV_ACCESS_REMOTE_READ		= (1<<2),
 	IBV_ACCESS_REMOTE_ATOMIC	= (1<<3),
-	IBV_ACCESS_MW_BIND		= (1<<4)
+	IBV_ACCESS_MW_BIND		= (1<<4),
+	IBV_ACCESS_ON_DEMAND		= (1<<6),
 };
 
 struct ibv_pd {
diff --git a/man/ibv_query_device_ex.3 b/man/ibv_query_device_ex.3
index 6b33f9f92ab1..1f483d276628 100644
--- a/man/ibv_query_device_ex.3
+++ b/man/ibv_query_device_ex.3
@@ -23,8 +23,31 @@ struct ibv_device_attr_ex {
 .in +8
 struct ibv_device_attr orig_attr;
 uint32_t               comp_mask;              /* Compatibility mask that defines which of the following variables are valid */
+struct ibv_odp_caps    odp_caps;               /* On-Demand Paging capabilities */
 .in -8
 };
+
+struct ibv_exp_odp_caps {
+	uint64_t	general_odp_caps;  /* Mask with enum ibv_odp_general_cap_bits */
+	struct {
+		uint32_t	rc_odp_caps;      /* Mask with enum ibv_odp_tranport_cap_bits to know which operations are supported. */
+		uint32_t	uc_odp_caps;      /* Mask with enum ibv_odp_tranport_cap_bits to know which operations are supported. */
+		uint32_t	ud_odp_caps;      /* Mask with enum ibv_odp_tranport_cap_bits to know which operations are supported. */
+	} per_transport_caps;
+};
+
+enum ibv_odp_general_cap_bits {
+        IBV_ODP_SUPPORT = 1 << 0, /* On demand paging is supported */
+};
+
+enum ibv_odp_transport_cap_bits {
+        IBV_ODP_SUPPORT_SEND     = 1 << 0, /* Send operations support on-demand paging */
+        IBV_ODP_SUPPORT_RECV     = 1 << 1, /* Receive operations support on-demand paging */
+        IBV_ODP_SUPPORT_WRITE    = 1 << 2, /* RDMA-Write operations support on-demand paging */
+        IBV_ODP_SUPPORT_READ     = 1 << 3, /* RDMA-Read operations support on-demand paging */
+        IBV_ODP_SUPPORT_ATOMIC   = 1 << 4, /* RDMA-Atomic operations support on-demand paging */
+};
+
 .fi
 .SH "RETURN VALUE"
 .B ibv_query_device_ex()
diff --git a/man/ibv_reg_mr.3 b/man/ibv_reg_mr.3
index 77237716b47c..cf151113070c 100644
--- a/man/ibv_reg_mr.3
+++ b/man/ibv_reg_mr.3
@@ -34,6 +34,8 @@ describes the desired memory protection attributes; it is either 0 or the bitwis
 .B IBV_ACCESS_REMOTE_ATOMIC\fR Enable Remote Atomic Operation Access (if supported)
 .TP
 .B IBV_ACCESS_MW_BIND\fR       Enable Memory Window Binding
+.TP
+.B IBV_ACCESS_ON_DEMAND\fR    Create an on-demand paging MR
 .PP
 If
 .B IBV_ACCESS_REMOTE_WRITE
diff --git a/src/cmd.c b/src/cmd.c
index 47f1acd33d68..215dc0159a2c 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -159,6 +159,17 @@ int ibv_cmd_query_device_ex(struct ibv_context *context,
 			      (struct ibv_query_device_resp *)resp,
 			      raw_fw_ver);
 	attr->comp_mask = 0;
+	if (resp->response_length >= sizeof(*resp)) {
+		attr->odp_caps.general_caps = resp->odp_caps.general_caps;
+		attr->odp_caps.per_transport_caps.rc_odp_caps =
+			resp->odp_caps.per_transport_caps.rc_odp_caps;
+		attr->odp_caps.per_transport_caps.uc_odp_caps =
+			resp->odp_caps.per_transport_caps.uc_odp_caps;
+		attr->odp_caps.per_transport_caps.ud_odp_caps =
+			resp->odp_caps.per_transport_caps.ud_odp_caps;
+	} else {
+		memset(&attr->odp_caps, 0, sizeof(attr->odp_caps));
+	}
 
 	return 0;
 }
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
