From: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libibverbs] Add support for TX/RX checksum offload
Date: Mon, 17 Aug 2015 18:50:18 +0300
Message-ID: <1439826618-3015-1-git-send-email-bodong@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add a device capability flag IBV_DEVICE_IP_CSUM to denote IPv4 checksum
offload support. Devices should set this flag if they support
insertion/verification of IPv4, TCP and UDP checksums on
outgoing/incoming IPv4 packets sent over IB UD or ETH RAW PACKET QPs.

Flags IBV_SEND_IP_CSUM and IBV_WC_IP_CSUM_OK are added for utilizing this
capability for send and receive separately.

Change-Id: Ie02d708dcbef07ca0d2eac1b156f12aafdba6a97
Signed-off-by: Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/infiniband/verbs.h | 11 +++++++++--
 man/ibv_poll_cq.3          |  3 +++
 man/ibv_post_send.3        |  4 ++++
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index 28e1586..6ae7e6e 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -115,6 +115,7 @@ enum ibv_device_cap_flags {
 	IBV_DEVICE_RC_RNR_NAK_GEN	= 1 << 12,
 	IBV_DEVICE_SRQ_RESIZE		= 1 << 13,
 	IBV_DEVICE_N_NOTIFY_CQ		= 1 << 14,
+	IBV_DEVICE_IP_CSUM		= 1 << 18,
 	IBV_DEVICE_XRC			= 1 << 20,
 	IBV_DEVICE_MANAGED_FLOW_STEERING = 1 << 29
 };
@@ -314,9 +315,14 @@ enum ibv_wc_opcode {
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
@@ -653,7 +659,8 @@ enum ibv_send_flags {
 	IBV_SEND_FENCE		= 1 << 0,
 	IBV_SEND_SIGNALED	= 1 << 1,
 	IBV_SEND_SOLICITED	= 1 << 2,
-	IBV_SEND_INLINE		= 1 << 3
+	IBV_SEND_INLINE		= 1 << 3,
+	IBV_SEND_IP_CSUM	= 1 << 4
 };
 
 struct ibv_sge {
diff --git a/man/ibv_poll_cq.3 b/man/ibv_poll_cq.3
index 57c6daa..539940d 100644
--- a/man/ibv_poll_cq.3
+++ b/man/ibv_poll_cq.3
@@ -50,6 +50,9 @@ It is either 0 or the bitwise OR of one or more of the following flags:
 .B IBV_WC_GRH \fR      GRH is present (valid only for UD QPs)
 .TP
 .B IBV_WC_WITH_IMM \fR Immediate data value is valid
+.TP
+.B IBV_WC_IP_CSUM_OK \fR TCP/UDP checksum over IPv4 and IPv4 header checksum are verified.
+This feature is supported only when \fBIBV_DEVICE_IP_CSUM\fR flag is set in the device capability flags.
 .PP
 Not all
 .I wc
diff --git a/man/ibv_post_send.3 b/man/ibv_post_send.3
index 33fbb50..3b07bcb 100644
--- a/man/ibv_post_send.3
+++ b/man/ibv_post_send.3
@@ -98,6 +98,10 @@ The attribute send_flags describes the properties of the \s-1WR\s0. It is either
 .TP
 .B IBV_SEND_INLINE \fR Send data in given gather list as inline data
 in a send WQE.  Valid only for Send and RDMA Write.  The L_Key will not be checked.
++.TP
++.B IBV_SEND_IP_CSUM \fR Offload the IPv4 and TCP/UDP checksum calculation.
++Valid only for QPs with Transport Service Type \fBIBV_QPT_UD\fR or \fBIBV_QPT_RAW_PACKET\fR.
++This feature supported only when \fBIBV_DEVICE_IP_CSUM\fR the flag is set in the device capability flags.
 .SH "RETURN VALUE"
 .B ibv_post_send()
 returns 0 on success, or the value of errno on failure (which indicates the failure reason).
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
