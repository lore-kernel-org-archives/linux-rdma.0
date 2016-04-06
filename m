From: Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC PATCH v2 03/13] selinux: Implement Infiniband flush callback
Date: Thu,  7 Apr 2016 02:33:48 +0300
Message-ID: <1459985638-37233-4-git-send-email-danielj@mellanox.com>
References: <1459985638-37233-1-git-send-email-danielj@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1459985638-37233-1-git-send-email-danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Because access for infiniband is enforced in the setup phase of a
connection there must be a way to notify ib_core if the policy or
enforcement setting have changed.

Added register and unregister_ib_flush_callback hooks so infiniband can
setup notification of policy and enforment changes.  In the AVC reset
callback function call the ib_flush callback if it's registered. Also
renamed the callback function, the previous name was 'net' specific.

Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 security/selinux/hooks.c |   36 ++++++++++++++++++++++++++++++++++--
 1 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index fce7dc8..0fbf3f8 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -94,6 +94,9 @@
 #include "audit.h"
 #include "avc_ss.h"
 
+static void (*ib_flush_callback)(void);
+static DEFINE_MUTEX(ib_flush_mutex);
+
 /* SECMARK reference count */
 static atomic_t selinux_secmark_refcount = ATOMIC_INIT(0);
 
@@ -159,13 +162,17 @@ static int selinux_peerlbl_enabled(void)
 	return (selinux_policycap_alwaysnetwork || netlbl_enabled() || selinux_xfrm_enabled());
 }
 
-static int selinux_netcache_avc_callback(u32 event)
+static int selinux_cache_avc_callback(u32 event)
 {
 	if (event == AVC_CALLBACK_RESET) {
 		sel_netif_flush();
 		sel_netnode_flush();
 		sel_netport_flush();
 		synchronize_net();
+		mutex_lock(&ib_flush_mutex);
+		if (ib_flush_callback)
+			ib_flush_callback();
+		mutex_unlock(&ib_flush_mutex);
 	}
 	return 0;
 }
@@ -5977,6 +5984,23 @@ static int selinux_key_getsecurity(struct key *key, char **_buffer)
 
 #endif
 
+#ifdef CONFIG_SECURITY_INFINIBAND
+static void selinux_register_ib_flush_callback(void (*callback)(void))
+{
+	mutex_lock(&ib_flush_mutex);
+	ib_flush_callback = callback;
+	mutex_unlock(&ib_flush_mutex);
+}
+
+static void selinux_unregister_ib_flush_callback(void)
+{
+	mutex_lock(&ib_flush_mutex);
+	ib_flush_callback = NULL;
+	mutex_unlock(&ib_flush_mutex);
+}
+
+#endif
+
 static struct security_hook_list selinux_hooks[] = {
 	LSM_HOOK_INIT(binder_set_context_mgr, selinux_binder_set_context_mgr),
 	LSM_HOOK_INIT(binder_transaction, selinux_binder_transaction),
@@ -6158,6 +6182,12 @@ static struct security_hook_list selinux_hooks[] = {
 	LSM_HOOK_INIT(tun_dev_attach_queue, selinux_tun_dev_attach_queue),
 	LSM_HOOK_INIT(tun_dev_attach, selinux_tun_dev_attach),
 	LSM_HOOK_INIT(tun_dev_open, selinux_tun_dev_open),
+#ifdef CONFIG_SECURITY_INFINIBAND
+	LSM_HOOK_INIT(register_ib_flush_callback,
+		      selinux_register_ib_flush_callback),
+	LSM_HOOK_INIT(unregister_ib_flush_callback,
+		      selinux_unregister_ib_flush_callback),
+#endif
 
 #ifdef CONFIG_SECURITY_NETWORK_XFRM
 	LSM_HOOK_INIT(xfrm_policy_alloc_security, selinux_xfrm_policy_alloc),
@@ -6217,9 +6247,11 @@ static __init int selinux_init(void)
 					    0, SLAB_PANIC, NULL);
 	avc_init();
 
+	ib_flush_callback = NULL;
+
 	security_add_hooks(selinux_hooks, ARRAY_SIZE(selinux_hooks));
 
-	if (avc_add_callback(selinux_netcache_avc_callback, AVC_CALLBACK_RESET))
+	if (avc_add_callback(selinux_cache_avc_callback, AVC_CALLBACK_RESET))
 		panic("SELinux: Unable to register AVC netcache callback\n");
 
 	if (selinux_enforcing)
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
