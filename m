From: Bodong Wang <wbd2905-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/1] Add support for TX/RX checksum offload
Date: Wed, 16 Sep 2015 18:59:51 +0300
Message-ID: <111bfe6983bbc80a5e48d71f59b45a0d1b6766b4.1442413267.git.bodong@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add a device capability field csum_cap to denote IPv4 checksum offload
support. Devices should configure this field if they support
insertion/verification of IPv4, TCP and UDP checksums on outgoing/incoming
IPv4 packets according link layer and QP types.

Flags IBV_SEND_IP_CSUM and IBV_WC_IP_CSUM_OK are added for utilizing this
capability for send and receive separately.

Signed-off-by: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 examples/devinfo.c            | 33 +++++++++++++++++++++++++++++++++
 include/infiniband/kern-abi.h |  7 +++++++
 include/infiniband/verbs.h    | 22 ++++++++++++++++++++--
 man/ibv_poll_cq.3             |  5 +++++
 man/ibv_post_send.3           |  4 ++++
 src/cmd.c                     | 13 +++++++++++++
 6 files changed, 82 insertions(+), 2 deletions(-)

diff --git a/examples/devinfo.c b/examples/devinfo.c
index a8de982..46d4614 100644
--- a/examples/devinfo.c
+++ b/examples/devinfo.c
@@ -253,6 +253,38 @@ void print_odp_caps(const struct ibv_odp_caps *caps)
 	print_odp_trans_caps(caps->per_transport_caps.ud_odp_caps);
 }
 
+void print_csum_caps(const struct ibv_csum_cap_per_link *caps)
+{
+	uint32_t unknown_csum_caps = ~(IBV_CSUM_SUPPORT_RAW |
+				       IBV_CSUM_SUPPORT_UD);
+
+	printf("\teth_csum_cap:\n");
+	if (!caps->eth_csum_cap) {
+		printf("\t\t\t\t\tNO_SUPPORT\n");
+	} else {
+		if (caps->eth_csum_cap & IBV_CSUM_SUPPORT_RAW)
+			printf("\t\t\t\t\tRAW_QP_SUPPORT\n");
+		if (caps->eth_csum_cap & IBV_CSUM_SUPPORT_UD)
+			printf("\t\t\t\t\tUD_QP_SUPPORT\n");
+		if (caps->eth_csum_cap & unknown_csum_caps)
+			printf("\t\t\t\t\tUnknown flags: 0x%" PRIX32 "\n",
+			       caps->eth_csum_cap & unknown_csum_caps);
+	}
+
+	printf("\tib_csum_cap:\n");
+	if (!caps->ib_csum_cap) {
+		printf("\t\t\t\t\tNO_SUPPORT\n");
+	} else {
+		if (caps->ib_csum_cap & IBV_CSUM_SUPPORT_RAW)
+			printf("\t\t\t\t\tRAW_QP_SUPPORT\n");
+		if (caps->ib_csum_cap & IBV_CSUM_SUPPORT_UD)
+			printf("\t\t\t\t\tUD_QP_SUPPORT\n");
+		if (caps->ib_csum_cap & unknown_csum_caps)
+			printf("\t\t\t\t\tUnknown flags: 0x%" PRIX32 "\n",
+			       caps->ib_csum_cap & unknown_csum_caps);
+	}
+}
+
 static int print_hca_cap(struct ibv_device *ib_dev, uint8_t ib_port)
 {
 	struct ibv_context *ctx;
@@ -339,6 +371,7 @@ static int print_hca_cap(struct ibv_device *ib_dev, uint8_t ib_port)
 		printf("\tlocal_ca_ack_delay:\t\t%d\n", device_attr.orig_attr.local_ca_ack_delay);
 
 		print_odp_caps(&device_attr.odp_caps);
+		print_csum_caps(&device_attr.csum_cap);
 	}
 
 	for (port = 1; port <= device_attr.orig_attr.phys_port_cnt; ++port) {
diff --git a/include/infiniband/kern-abi.h b/include/infiniband/kern-abi.h
index 800c5ab..51d4fb0 100644
--- a/include/infiniband/kern-abi.h
+++ b/include/infiniband/kern-abi.h
@@ -262,11 +262,18 @@ struct ibv_odp_caps_resp {
 	__u32 reserved;
 };
 
+struct ibv_csum_cap_per_link_resp {
+	__u32 eth_csum_cap;
+	__u32 ib_csum_cap;
+};
+
 struct ibv_query_device_resp_ex {
 	struct ibv_query_device_resp base;
 	__u32 comp_mask;
 	__u32 response_length;
 	struct ibv_odp_caps_resp odp_caps;
+	__u64 reserved0[2];
+	struct ibv_csum_cap_per_link_resp csum_cap;
 };
 
 struct ibv_query_port {
diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index 1ff5265..134359f 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -196,10 +196,16 @@ enum ibv_odp_general_caps {
 	IBV_ODP_SUPPORT = 1 << 0,
 };
 
+struct ibv_csum_cap_per_link {
+	uint32_t eth_csum_cap;
+	uint32_t ib_csum_cap;
+};
+
 struct ibv_device_attr_ex {
 	struct ibv_device_attr	orig_attr;
 	uint32_t		comp_mask;
 	struct ibv_odp_caps	odp_caps;
+	struct ibv_csum_cap_per_link csum_cap;
 };
 
 enum ibv_mtu {
@@ -348,9 +354,14 @@ enum ibv_wc_opcode {
 	IBV_WC_RECV_RDMA_WITH_IMM
 };
 
+enum {
+	IBV_WC_IP_CSUM_OK_SHIFT	= 2
+};
+
 enum ibv_wc_flags {
 	IBV_WC_GRH		= 1 << 0,
-	IBV_WC_WITH_IMM		= 1 << 1
+	IBV_WC_WITH_IMM		= 1 << 1,
+	IBV_WC_IP_CSUM_OK	= 1 << IBV_WC_IP_CSUM_OK_SHIFT
 };
 
 struct ibv_wc {
@@ -646,6 +657,11 @@ enum ibv_mig_state {
 	IBV_MIG_ARMED
 };
 
+enum ibv_csum_cap_flags {
+	IBV_CSUM_SUPPORT_UD	= 1 << IBV_QPT_UD,
+	IBV_CSUM_SUPPORT_RAW	= 1 << IBV_QPT_RAW_PACKET,
+};
+
 struct ibv_qp_attr {
 	enum ibv_qp_state	qp_state;
 	enum ibv_qp_state	cur_qp_state;
@@ -688,7 +704,8 @@ enum ibv_send_flags {
 	IBV_SEND_FENCE		= 1 << 0,
 	IBV_SEND_SIGNALED	= 1 << 1,
 	IBV_SEND_SOLICITED	= 1 << 2,
-	IBV_SEND_INLINE		= 1 << 3
+	IBV_SEND_INLINE		= 1 << 3,
+	IBV_SEND_IP_CSUM	= 1 << 4
 };
 
 struct ibv_sge {
@@ -1459,6 +1476,7 @@ ibv_query_device_ex(struct ibv_context *context,
 legacy:
 	memset(attr, 0, sizeof(*attr));
 	ret = ibv_query_device(context, &attr->orig_attr);
+
 	return ret;
 }
 
diff --git a/man/ibv_poll_cq.3 b/man/ibv_poll_cq.3
index 57c6daa..ba5d2ef 100644
--- a/man/ibv_poll_cq.3
+++ b/man/ibv_poll_cq.3
@@ -50,6 +50,11 @@ It is either 0 or the bitwise OR of one or more of the following flags:
 .B IBV_WC_GRH \fR      GRH is present (valid only for UD QPs)
 .TP
 .B IBV_WC_WITH_IMM \fR Immediate data value is valid
+.TP
+.B IBV_WC_IP_CSUM_OK \fR TCP/UDP checksum over IPv4 and IPv4 header checksum are
+verified.
+This feature is supported only when \fBcsum_cap\fR in device_attr indicates
+current QP under current link layer is supported.
 .PP
 Not all
 .I wc
diff --git a/man/ibv_post_send.3 b/man/ibv_post_send.3
index 33fbb50..00afd66 100644
--- a/man/ibv_post_send.3
+++ b/man/ibv_post_send.3
@@ -98,6 +98,10 @@ The attribute send_flags describes the properties of the \s-1WR\s0. It is either
 .TP
 .B IBV_SEND_INLINE \fR Send data in given gather list as inline data
 in a send WQE.  Valid only for Send and RDMA Write.  The L_Key will not be checked.
+.TP
+.B IBV_SEND_IP_CSUM \fR Offload the IPv4 and TCP/UDP checksum calculation.
+This feature is supported only when \fBcsum_cap\fR in device_attr indicates
+current QP under current link layer is supported.
 .SH "RETURN VALUE"
 .B ibv_post_send()
 returns 0 on success, or the value of errno on failure (which indicates the failure reason).
diff --git a/src/cmd.c b/src/cmd.c
index e1914e9..17fc386 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -160,6 +160,7 @@ int ibv_cmd_query_device_ex(struct ibv_context *context,
 	IBV_INIT_CMD_RESP_EX_V(cmd, cmd_core_size, cmd_size,
 			       QUERY_DEVICE_EX, resp, resp_core_size,
 			       resp_size);
+
 	cmd->comp_mask = 0;
 	cmd->reserved = 0;
 	memset(attr->orig_attr.fw_ver, 0, sizeof(attr->orig_attr.fw_ver));
@@ -189,6 +190,18 @@ int ibv_cmd_query_device_ex(struct ibv_context *context,
 		}
 	}
 
+	if (attr_size >= offsetof(struct ibv_device_attr_ex, csum_cap) +
+	    sizeof(attr->csum_cap)) {
+		if (resp->response_length >=
+		    offsetof(struct ibv_query_device_resp_ex, csum_cap) +
+		    sizeof(resp->csum_cap)) {
+			attr->csum_cap.eth_csum_cap = resp->csum_cap.eth_csum_cap;
+			attr->csum_cap.ib_csum_cap = resp->csum_cap.ib_csum_cap;
+		} else {
+			memset(&attr->csum_cap, 0, sizeof(attr->csum_cap));
+		}
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
