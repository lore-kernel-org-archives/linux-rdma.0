From: Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC PATCH 4/7] selinux: Allocate and free infiniband security hooks
Date: Tue,  5 Apr 2016 00:48:21 +0300
Message-ID: <1459806504-16135-5-git-send-email-danielj@mellanox.com>
References: <1459806504-16135-1-git-send-email-danielj@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1459806504-16135-1-git-send-email-danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Implement and attach hooks to allocate and free infiniband security
structures.

Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 security/selinux/hooks.c          |   29 +++++++++++++++++++++++++++++
 security/selinux/include/objsec.h |    6 ++++++
 2 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 156e232..cd0c6f4 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -17,6 +17,8 @@
  *	Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>
  *  Copyright (C) 2007 Hitachi Software Engineering Co., Ltd.
  *		       Yuichi Nakamura <ynakam-FkO1umbPgv4fag7Bw7Dlfw@public.gmane.org>
+ *  Copyright (C) 2016 Mellanox Technologies,
+ *					Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
  *
  *	This program is free software; you can redistribute it and/or modify
  *	it under the terms of the GNU General Public License version 2,
@@ -5934,6 +5936,26 @@ static int selinux_key_getsecurity(struct key *key, char **_buffer)
 
 #endif
 
+#ifdef CONFIG_SECURITY_INFINIBAND
+static int selinux_infiniband_alloc_security(void **security)
+{
+	struct infiniband_security_struct *sec;
+
+	sec = kzalloc(sizeof(*sec), GFP_ATOMIC);
+	if (!sec)
+		return -ENOMEM;
+	sec->sid = current_sid();
+
+	*security = sec;
+	return 0;
+}
+
+static void selinux_infiniband_free_security(void *security)
+{
+	kfree(security);
+}
+#endif
+
 static struct security_hook_list selinux_hooks[] = {
 	LSM_HOOK_INIT(binder_set_context_mgr, selinux_binder_set_context_mgr),
 	LSM_HOOK_INIT(binder_transaction, selinux_binder_transaction),
@@ -6115,6 +6137,13 @@ static struct security_hook_list selinux_hooks[] = {
 	LSM_HOOK_INIT(tun_dev_attach, selinux_tun_dev_attach),
 	LSM_HOOK_INIT(tun_dev_open, selinux_tun_dev_open),
 
+#ifdef CONFIG_SECURITY_INFINIBAND
+	LSM_HOOK_INIT(infiniband_alloc_security,
+		      selinux_infiniband_alloc_security),
+	LSM_HOOK_INIT(infiniband_free_security,
+		      selinux_infiniband_free_security),
+#endif
+
 #ifdef CONFIG_SECURITY_NETWORK_XFRM
 	LSM_HOOK_INIT(xfrm_policy_alloc_security, selinux_xfrm_policy_alloc),
 	LSM_HOOK_INIT(xfrm_policy_clone_security, selinux_xfrm_policy_clone),
diff --git a/security/selinux/include/objsec.h b/security/selinux/include/objsec.h
index a2ae054..4e36976 100644
--- a/security/selinux/include/objsec.h
+++ b/security/selinux/include/objsec.h
@@ -10,6 +10,8 @@
  *
  *  Copyright (C) 2001,2002 Networks Associates Technology, Inc.
  *  Copyright (C) 2003 Red Hat, Inc., James Morris <jmorris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
+ *  Copyright (C) 2016 Mellanox Technologies,
+ *					Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
  *
  *	This program is free software; you can redistribute it and/or modify
  *	it under the terms of the GNU General Public License version 2,
@@ -129,6 +131,10 @@ struct key_security_struct {
 	u32 sid;	/* SID of key */
 };
 
+struct infiniband_security_struct {
+	u32 sid;        /* SID of the queue pair or MAD agent */
+};
+
 extern unsigned int selinux_checkreqprot;
 
 #endif /* _SELINUX_OBJSEC_H_ */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
