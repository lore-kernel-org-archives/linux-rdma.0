From: Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] libibvers: Add new enums
Date: Sun, 19 Dec 2010 11:28:58 +0200
Message-ID: <4D0DD05A.2090600@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add new enums to verbs:
IBV_SEND_IP_CSUM - checksum control
IBV_WC_WITH_VLAN - VLAN control

Signed-off-by: Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 fixes/series                 |    1 +
 fixes/verbs_enum_flags.patch |   43 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+), 0 deletions(-)
 create mode 100644 fixes/verbs_enum_flags.patch

diff --git a/fixes/series b/fixes/series
index e3fa53a..e64de3d 100644
--- a/fixes/series
+++ b/fixes/series
@@ -12,3 +12,4 @@ configure_in-AC_PROG_LIBTOOL-for-automake.patch
 rpm_spec_changelog_fix.patch
 iboe_adapt_new_api.patch
 support_gid_change.patch
+verbs_enum_flags.patch
diff --git a/fixes/verbs_enum_flags.patch b/fixes/verbs_enum_flags.patch
new file mode 100644
index 0000000..dac26b2
--- /dev/null
+++ b/fixes/verbs_enum_flags.patch
@@ -0,0 +1,43 @@
+From e9a0d91fdb1ece1d4605f2fbbcf79cc85f59deda Mon Sep 17 00:00:00 2001
+From: Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>
+Date: Sun, 19 Dec 2010 10:54:52 +0200
+Subject: [PATCH] New enum flags
+
+IBV_SEND_IP_CSUM added to ibv_send_flags. Should be used to control
+caclulation checksum at hardware layer.
+
+IBV_WC_WITH_VLAN added to ibv_wc_flags, Should be used to add VLAN
+support to WC flags.
+
+Signed-off-by: Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>
+---
+ include/infiniband/verbs.h |    6 ++++--
+ 1 files changed, 4 insertions(+), 2 deletions(-)
+
+diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
+index 0f1cb2e..d6b807b 100644
+--- a/include/infiniband/verbs.h
++++ b/include/infiniband/verbs.h
+@@ -257,7 +257,8 @@ enum ibv_wc_opcode {
+ 
+ enum ibv_wc_flags {
+ 	IBV_WC_GRH		= 1 << 0,
+-	IBV_WC_WITH_IMM		= 1 << 1
++	IBV_WC_WITH_IMM		= 1 << 1,
++	IBV_WC_WITH_VLAN	= 1 << 3
+ };
+ 
+ struct ibv_wc {
+@@ -493,7 +494,8 @@ enum ibv_send_flags {
+ 	IBV_SEND_FENCE		= 1 << 0,
+ 	IBV_SEND_SIGNALED	= 1 << 1,
+ 	IBV_SEND_SOLICITED	= 1 << 2,
+-	IBV_SEND_INLINE		= 1 << 3
++	IBV_SEND_INLINE		= 1 << 3,
++	IBV_SEND_IP_CSUM	= 1 << 4
+ };
+ 
+ struct ibv_sge {
+-- 
+1.6.4.2
+
-- 
1.6.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
