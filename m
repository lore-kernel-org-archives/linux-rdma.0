From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH REPOST libibverbs] Add IP and TCP/UDP TX checksum offload support
Date: Sun, 14 Jun 2015 13:13:04 +0300
Message-ID: <1434276784-15909-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add a device capability flag IB_DEVICE_IP_SUM to denote checksum offload
support. Devices should set this flag if they support insertion of IP, TCP
and UDP checksums on outgoing IP packets sent over IB UD or ETH RAW_PACKET QPs.

In addition add a send flag IBV_SEND_IP_CSUM to utilize this capability.

Signed-off-by: Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---

This is a rpost of the code we sent earlier on January, 
I understand that people's focus nowadays is around
the few threads that deal with kernel changes, but
let's get it in to sit in the patchworks again...

 include/infiniband/verbs.h |    4 +++-
 man/ibv_post_send.3        |    4 ++++
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index cfa1156..78b5997 100644
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
@@ -627,7 +628,8 @@ enum ibv_send_flags {
 	IBV_SEND_FENCE		= 1 << 0,
 	IBV_SEND_SIGNALED	= 1 << 1,
 	IBV_SEND_SOLICITED	= 1 << 2,
-	IBV_SEND_INLINE		= 1 << 3
+	IBV_SEND_INLINE		= 1 << 3,
+	IBV_SEND_IP_CSUM        = 1 << 4
 };
 
 struct ibv_sge {
diff --git a/man/ibv_post_send.3 b/man/ibv_post_send.3
index 33fbb50..8070996 100644
--- a/man/ibv_post_send.3
+++ b/man/ibv_post_send.3
@@ -98,6 +98,10 @@ The attribute send_flags describes the properties of the \s-1WR\s0. It is either
 .TP
 .B IBV_SEND_INLINE \fR Send data in given gather list as inline data
 in a send WQE.  Valid only for Send and RDMA Write.  The L_Key will not be checked.
+.TP
+.B IBV_SEND_IP_CSUM \fR Offload the IP and TCP/UDP checksum calculation.
+Valid only for QPs with Transport Service Type \fBIBV_QPT_UD\fR or \fBIBV_QPT_RAW_PACKET\fR.
+This feature supported only when \fBIBV_DEVICE_IP_CSUM\fR the flag is set in the device capability flags.
 .SH "RETURN VALUE"
 .B ibv_post_send()
 returns 0 on success, or the value of errno on failure (which indicates the failure reason).
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
