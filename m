From: wbd2905-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [v1] libibverbs: Report checksum offload capabilities
Date: Tue, 22 Sep 2015 23:20:21 +0300
Message-ID: <1442953221-104830-2-git-send-email-bodong@mellanox.com>
References: <1442953221-104830-1-git-send-email-bodong@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442953221-104830-1-git-send-email-bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add IBV_DEVICE_UD_IP_CSUM, IBV_DEVICE_RAW_IP_CSUM and IBV_DEVICE_RC_IP_CSUM to
device capability enum field. These enum will denote IPv4 checksum offload
support for UD, RAW and RC QPs.

Flags IBV_SEND_IP_CSUM and IBV_WC_IP_CSUM_OK are added for utilizing this
capability for send and receive separately.

Signed-off-by: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/infiniband/verbs.h | 14 ++++++++++++--
 man/ibv_poll_cq.3          |  5 +++++
 man/ibv_post_send.3        |  4 ++++
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index 1ff5265..ae22768 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -116,7 +116,10 @@ enum ibv_device_cap_flags {
 	IBV_DEVICE_RC_RNR_NAK_GEN	= 1 << 12,
 	IBV_DEVICE_SRQ_RESIZE		= 1 << 13,
 	IBV_DEVICE_N_NOTIFY_CQ		= 1 << 14,
+	IBV_DEVICE_UD_IP_CSUM		= 1 << 18,
 	IBV_DEVICE_XRC			= 1 << 20,
+	IBV_DEVICE_RC_IP_CSUM		= 1 << 25,
+	IBV_DEVICE_RAW_IP_CSUM		= 1 << 26,
 	IBV_DEVICE_MANAGED_FLOW_STEERING = 1 << 29
 };
 
@@ -348,9 +351,14 @@ enum ibv_wc_opcode {
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
@@ -688,7 +696,8 @@ enum ibv_send_flags {
 	IBV_SEND_FENCE		= 1 << 0,
 	IBV_SEND_SIGNALED	= 1 << 1,
 	IBV_SEND_SOLICITED	= 1 << 2,
-	IBV_SEND_INLINE		= 1 << 3
+	IBV_SEND_INLINE		= 1 << 3,
+	IBV_SEND_IP_CSUM	= 1 << 4
 };
 
 struct ibv_sge {
@@ -1459,6 +1468,7 @@ ibv_query_device_ex(struct ibv_context *context,
 legacy:
 	memset(attr, 0, sizeof(*attr));
 	ret = ibv_query_device(context, &attr->orig_attr);
+
 	return ret;
 }
 
diff --git a/man/ibv_poll_cq.3 b/man/ibv_poll_cq.3
index 57c6daa..bbf48ff 100644
--- a/man/ibv_poll_cq.3
+++ b/man/ibv_poll_cq.3
@@ -50,6 +50,11 @@ It is either 0 or the bitwise OR of one or more of the following flags:
 .B IBV_WC_GRH \fR      GRH is present (valid only for UD QPs)
 .TP
 .B IBV_WC_WITH_IMM \fR Immediate data value is valid
+.TP
+.B IBV_WC_IP_CSUM_OK \fR TCP/UDP checksum over IPv4 and IPv4 header checksum are
+verified.
+Valid only when \fBdevice_cap_flags\fR in device_attr indicates current QP is
+supported by checksum offload.
 .PP
 Not all
 .I wc
diff --git a/man/ibv_post_send.3 b/man/ibv_post_send.3
index 33fbb50..eeea078 100644
--- a/man/ibv_post_send.3
+++ b/man/ibv_post_send.3
@@ -98,6 +98,10 @@ The attribute send_flags describes the properties of the \s-1WR\s0. It is either
 .TP
 .B IBV_SEND_INLINE \fR Send data in given gather list as inline data
 in a send WQE.  Valid only for Send and RDMA Write.  The L_Key will not be checked.
+.TP
+.B IBV_SEND_IP_CSUM \fR Offload the IPv4 and TCP/UDP checksum calculation.
+Valid only when \fBdevice_cap_flags\fR in device_attr indicates current QP is
+supported by checksum offload.
 .SH "RETURN VALUE"
 .B ibv_post_send()
 returns 0 on success, or the value of errno on failure (which indicates the failure reason).
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
