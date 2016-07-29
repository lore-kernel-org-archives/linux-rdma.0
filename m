From: Dan Jurgens <danielj@mellanox.com>
Subject: [PATCH v3 6/9] selinux: Allocate and free infiniband security hooks
Date: Fri, 29 Jul 2016 16:53:33 +0300
Message-ID: <1469800416-125043-7-git-send-email-danielj@mellanox.com>
References: <1469800416-125043-1-git-send-email-danielj@mellanox.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1469800416-125043-1-git-send-email-danielj@mellanox.com>
Sender: owner-linux-security-module@vger.kernel.org
To: chrisw@sous-sol.org, paul@paul-moore.com, sds@tycho.nsa.gov, eparis@parisplace.org, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com
Cc: selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org, linux-rdma@vger.kernel.org, yevgenyp@mellanox.com, Daniel Jurgens <danielj@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Jurgens <danielj@mellanox.com>

Implement and attach hooks to allocate and free Infiniband object
security structures.

Signed-off-by: Daniel Jurgens <danielj@mellanox.com>

---
v2:
- Use void * blobs for security structs.  Paul Moore
- Shorten ib_end_port to ib_port.  Paul Moore
- Allocate memory for security struct with GFP_KERNEL. Yuval Shaia

 security/selinux/hooks.c          | 25 ++++++++++++++++++++++++-
 security/selinux/include/objsec.h |  5 +++++
 2 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 7c22703..ef1088c 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -17,6 +17,7 @@
  *	Paul Moore <paul@paul-moore.com>
  *  Copyright (C) 2007 Hitachi Software Engineering Co., Ltd.
  *		       Yuichi Nakamura <ynakam@hitachisoft.jp>
+ *  Copyright (C) 2016 Mellanox Technologies
  *
  *	This program is free software; you can redistribute it and/or modify
  *	it under the terms of the GNU General Public License version 2,
@@ -5991,7 +5992,26 @@ static int selinux_key_getsecurity(struct key *key, char **_buffer)
 	*_buffer = context;
 	return rc;
 }
+#endif
+
+#ifdef CONFIG_SECURITY_INFINIBAND
+static int selinux_ib_alloc_security(void **ib_sec)
+{
+	struct ib_security_struct *sec;
+
+	sec = kzalloc(sizeof(*sec), GFP_KERNEL);
+	if (!sec)
+		return -ENOMEM;
+	sec->sid = current_sid();
+
+	*ib_sec = sec;
+	return 0;
+}
 
+static void selinux_ib_free_security(void *ib_sec)
+{
+	kfree(ib_sec);
+}
 #endif
 
 static struct security_hook_list selinux_hooks[] = {
@@ -6175,7 +6195,10 @@ static struct security_hook_list selinux_hooks[] = {
 	LSM_HOOK_INIT(tun_dev_attach_queue, selinux_tun_dev_attach_queue),
 	LSM_HOOK_INIT(tun_dev_attach, selinux_tun_dev_attach),
 	LSM_HOOK_INIT(tun_dev_open, selinux_tun_dev_open),
-
+#ifdef CONFIG_SECURITY_INFINIBAND
+	LSM_HOOK_INIT(ib_alloc_security, selinux_ib_alloc_security),
+	LSM_HOOK_INIT(ib_free_security, selinux_ib_free_security),
+#endif
 #ifdef CONFIG_SECURITY_NETWORK_XFRM
 	LSM_HOOK_INIT(xfrm_policy_alloc_security, selinux_xfrm_policy_alloc),
 	LSM_HOOK_INIT(xfrm_policy_clone_security, selinux_xfrm_policy_clone),
diff --git a/security/selinux/include/objsec.h b/security/selinux/include/objsec.h
index c21e135..8e7db43 100644
--- a/security/selinux/include/objsec.h
+++ b/security/selinux/include/objsec.h
@@ -10,6 +10,7 @@
  *
  *  Copyright (C) 2001,2002 Networks Associates Technology, Inc.
  *  Copyright (C) 2003 Red Hat, Inc., James Morris <jmorris@redhat.com>
+ *  Copyright (C) 2016 Mellanox Technologies
  *
  *	This program is free software; you can redistribute it and/or modify
  *	it under the terms of the GNU General Public License version 2,
@@ -128,6 +129,10 @@ struct key_security_struct {
 	u32 sid;	/* SID of key */
 };
 
+struct ib_security_struct {
+	u32 sid;        /* SID of the queue pair or MAD agent */
+};
+
 extern unsigned int selinux_checkreqprot;
 
 #endif /* _SELINUX_OBJSEC_H_ */
-- 
1.8.3.1

