From: Dan Jurgens <danielj@mellanox.com>
Subject: [PATCH 01/12] security: Add LSM hooks for Infiniband security
Date: Thu, 23 Jun 2016 22:52:47 +0300
Message-ID: <1466711578-64398-2-git-send-email-danielj@mellanox.com>
References: <1466711578-64398-1-git-send-email-danielj@mellanox.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1466711578-64398-1-git-send-email-danielj@mellanox.com>
Sender: owner-linux-security-module@vger.kernel.org
To: chrisw@sous-sol.org, paul@paul-moore.com, sds@tycho.nsa.gov, eparis@parisplace.org, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com
Cc: selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org, linux-rdma@vger.kernel.org, yevgenyp@mellanox.com, Daniel Jurgens <danielj@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Jurgens <danielj@mellanox.com>

Add nine new hooks
 1. Allocate security contexts for Infiniband QPs.
 2. Free security contexts for Infiniband QPs.
 3. Allocate security contexts for Infiniband MAD agents.
 4. Free security contexts for Infiniband MAD agents.
 5. Enforce QP access to Pkeys
 6. Enforce MAD agent access to Pkeys
 7. Enforce MAD agent access to Infiniband End Ports for sending Subnet
    Management Packets (SMP)
 8. A hook to register a callback to receive notifications of
    security policy or enforcement changes.  Restricting a QPs access to
    a pkey will be done during setup and not on a per packet basis
    access must be enforced again.
 9. A hook to unregister the callback.

Signed-off-by: Daniel Jurgens <danielj@mellanox.com>
Reviewed-by: Eli Cohen <eli@mellanox.com>
---
 include/linux/lsm_hooks.h | 71 ++++++++++++++++++++++++++++++++++++++++
 include/linux/security.h  | 63 +++++++++++++++++++++++++++++++++++
 include/rdma/ib_verbs.h   |  4 +++
 security/Kconfig          |  9 +++++
 security/security.c       | 83 +++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 230 insertions(+)

diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index 7ae3976..6b47c8d 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -8,6 +8,7 @@
  * Copyright (C) 2001 Silicon Graphics, Inc. (Trust Technology Group)
  * Copyright (C) 2015 Intel Corporation.
  * Copyright (C) 2015 Casey Schaufler <casey@schaufler-ca.com>
+ * Copyright (C) 2016 Mellanox Techonologies
  *
  *	This program is free software; you can redistribute it and/or modify
  *	it under the terms of the GNU General Public License as published by
@@ -876,6 +877,50 @@
  *	associated with the TUN device's security structure.
  *	@security pointer to the TUN devices's security structure.
  *
+ * Security hooks for Infiniband
+ *
+ * @ib_qp_pkey_access:
+ *	Check permission to access a pkey when modifing a QP.
+ *	@subnet_prefix the subnet prefix of the port being used.
+ *	@pkey the pkey to be accessed.
+ *	@qp_sec pointer to the ib_qp_security structure.
+ * @ib_mad_agent_pkey_access:
+ *	Check permission to access a pkey when transmiting and receiving MADS.
+ *	@subnet_prefix the subnet prefix of the port being used.
+ *	@pkey the pkey to be accessed.
+ *	@mad_agent pointer to the ib_mad_agent structure.
+ * @ib_end_port_smp:
+ *	Check permissions to send and receive SMPs on a end port.
+ *	@dev_name the IB device name (i.e. mlx4_0).
+ *	@port_num the port number.
+ *	@mad_agent pointer to the ib_mad_agent structure.
+ * @ib_qp_alloc_security:
+ *	Allocate and attach a security structure to the qp_sec->q_security
+ *	field. The q_security field is initialized to NULL when the structure
+ *	is allocated.  A separate QP security structure is used instead of the
+ *	QP structure because when a QP is destroyed the memory is freed by the
+ *	hardware driver.  That operation can fail so the security info must be
+ *	maintained until the destroy completes successfully.
+ *	@qp_sec contains the ib_qp_security structure to be modified.
+ *	Return 0 if operation was successful.
+ * @ib_mad_agent_alloc_security:
+ *	Allocate and attach a security structure to the mad_agent->m_security
+ *	field. The m_security field is initialized to NULL when the structure
+ *	is allocated.
+ *	@mad_agent contains the ib_mad_agent structure to be modified.
+ *	Return 0 if operation was successful.
+ * @ib_qp_free_security:
+ *	Deallocate and clear the qp_sec->q_security field.
+ *	@qp_sec contains the ib_qp_security structure to be modified.
+ * @ib_mad_agent_free_security:
+ *	Deallocate and clear the mad_agent->m_security field.
+ *	@mad_agent contains the ib_mad_agent structure to be modified.
+ * @register_ib_flush_callback:
+ *	Provide a way for security modules to notify ib_core of policy changes.
+ *	@callback function pointer to call when policy changes.
+ * @unregister_ib_flush_callback:
+ *	Unregister the callback function.
+ *
  * Security hooks for XFRM operations.
  *
  * @xfrm_policy_alloc_security:
@@ -1579,6 +1624,21 @@ union security_list_options {
 	int (*tun_dev_open)(void *security);
 #endif	/* CONFIG_SECURITY_NETWORK */
 
+#ifdef CONFIG_SECURITY_INFINIBAND
+	int (*ib_qp_pkey_access)(u64 subnet_prefix, u16 pkey,
+				 struct ib_qp_security *qp_sec);
+	int (*ib_mad_agent_pkey_access)(u64 subnet_prefix, u16 pkey,
+					struct ib_mad_agent *mad_agent);
+	int (*ib_end_port_smp)(const char *dev_name, u8 port,
+			       struct ib_mad_agent *mad_agent);
+	int (*ib_qp_alloc_security)(struct ib_qp_security *qp_sec);
+	int (*ib_mad_agent_alloc_security)(struct ib_mad_agent *mad_agent);
+	void (*ib_qp_free_security)(struct ib_qp_security *qp_sec);
+	void (*ib_mad_agent_free_security)(struct ib_mad_agent *mad_agent);
+	void (*register_ib_flush_callback)(void (*callback)(void));
+	void (*unregister_ib_flush_callback)(void);
+#endif	/* CONFIG_SECURITY_INFINIBAND */
+
 #ifdef CONFIG_SECURITY_NETWORK_XFRM
 	int (*xfrm_policy_alloc_security)(struct xfrm_sec_ctx **ctxp,
 					  struct xfrm_user_sec_ctx *sec_ctx,
@@ -1806,6 +1866,17 @@ struct security_hook_heads {
 	struct list_head tun_dev_attach;
 	struct list_head tun_dev_open;
 #endif	/* CONFIG_SECURITY_NETWORK */
+#ifdef CONFIG_SECURITY_INFINIBAND
+	struct list_head ib_qp_pkey_access;
+	struct list_head ib_mad_agent_pkey_access;
+	struct list_head ib_end_port_smp;
+	struct list_head ib_qp_alloc_security;
+	struct list_head ib_qp_free_security;
+	struct list_head ib_mad_agent_alloc_security;
+	struct list_head ib_mad_agent_free_security;
+	struct list_head register_ib_flush_callback;
+	struct list_head unregister_ib_flush_callback;
+#endif	/* CONFIG_SECURITY_INFINIBAND */
 #ifdef CONFIG_SECURITY_NETWORK_XFRM
 	struct list_head xfrm_policy_alloc_security;
 	struct list_head xfrm_policy_clone_security;
diff --git a/include/linux/security.h b/include/linux/security.h
index 14df373..a75d3e6 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -6,6 +6,7 @@
  * Copyright (C) 2001 Networks Associates Technology, Inc <ssmalley@nai.com>
  * Copyright (C) 2001 James Morris <jmorris@intercode.com.au>
  * Copyright (C) 2001 Silicon Graphics, Inc. (Trust Technology Group)
+ * Copyright (C) 2016 Mellanox Techonologies
  *
  *	This program is free software; you can redistribute it and/or modify
  *	it under the terms of the GNU General Public License as published by
@@ -55,6 +56,8 @@ struct msg_queue;
 struct xattr;
 struct xfrm_sec_ctx;
 struct mm_struct;
+struct ib_qp_security;
+struct ib_mad_agent;
 
 /* If capable should audit the security request */
 #define SECURITY_CAP_NOAUDIT 0
@@ -1370,6 +1373,66 @@ static inline int security_tun_dev_open(void *security)
 }
 #endif	/* CONFIG_SECURITY_NETWORK */
 
+#ifdef CONFIG_SECURITY_INFINIBAND
+int security_ib_qp_pkey_access(u64 subnet_prefix, u16 pkey,
+			       struct ib_qp_security *qp_sec);
+int security_ib_mad_agent_pkey_access(u64 subnet_prefix, u16 pkey,
+				      struct ib_mad_agent *mad_agent);
+int security_ib_end_port_smp(const char *name, u8 port,
+			     struct ib_mad_agent *mad_agent);
+int security_ib_qp_alloc_security(struct ib_qp_security *qp_sec);
+void security_ib_qp_free_security(struct ib_qp_security *qp_sec);
+int security_ib_mad_agent_alloc_security(struct ib_mad_agent *mad_agent);
+void security_ib_mad_agent_free_security(struct ib_mad_agent *mad_agent);
+void security_register_ib_flush_callback(void (*callback)(void));
+void security_unregister_ib_flush_callback(void);
+#else	/* CONFIG_SECURITY_INFINIBAND */
+static inline int security_ib_qp_pkey_access(u64 subnet_prefix, u16 pkey,
+					     struct ib_qp_security *qp_sec)
+{
+	return 0;
+}
+
+static inline int security_ib_mad_agent_pkey_access(u64 subnet_prefix,
+						    u16 pkey,
+						    struct ib_mad_agent *mad_agent)
+{
+	return 0;
+}
+
+static inline int security_ib_end_port_smp(const char *dev_name, u8 port,
+					   struct ib_mad_agent *mad_agent)
+{
+	return 0;
+}
+
+static inline int security_ib_qp_alloc_security(struct ib_qp_security *qp_sec)
+{
+	return 0;
+}
+
+static inline void security_ib_qp_free_security(struct ib_qp_security *qp_sec)
+{
+}
+
+static inline int security_ib_mad_agent_alloc_security(struct ib_mad_agent *mad_agent)
+{
+	return 0;
+}
+
+static inline void security_ib_mad_agent_free_security(struct ib_mad_agent *mad_agent)
+{
+}
+
+static inline void security_register_ib_flush_callback(void (*callback)(void))
+{
+}
+
+static inline void security_unregister_ib_flush_callback(void)
+{
+}
+#endif	/* CONFIG_SECURITY_INFINIBAND */
+
 #ifdef CONFIG_SECURITY_NETWORK_XFRM
 
 int security_xfrm_policy_alloc(struct xfrm_sec_ctx **ctxp,
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 432bed5..3f6780b 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1428,6 +1428,10 @@ struct ib_srq {
 	} ext;
 };
 
+struct ib_qp_security {
+	void *q_security;
+};
+
 struct ib_qp {
 	struct ib_device       *device;
 	struct ib_pd	       *pd;
diff --git a/security/Kconfig b/security/Kconfig
index 176758c..ce965c6 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -49,6 +49,15 @@ config SECURITY_NETWORK
 	  implement socket and networking access controls.
 	  If you are unsure how to answer this question, answer N.
 
+config SECURITY_INFINIBAND
+	bool "Infiniband Security Hooks"
+	depends on SECURITY && INFINIBAND
+	help
+	  This enables the Infiniband security hooks.
+	  If enabled, a security module can use these hooks to
+	  implement Infiniband access controls.
+	  If you are unsure how to answer this question, answer N.
+
 config SECURITY_NETWORK_XFRM
 	bool "XFRM (IPSec) Networking Security Hooks"
 	depends on XFRM && SECURITY_NETWORK
diff --git a/security/security.c b/security/security.c
index 7095693..d75a0e9 100644
--- a/security/security.c
+++ b/security/security.c
@@ -4,6 +4,7 @@
  * Copyright (C) 2001 WireX Communications, Inc <chris@wirex.com>
  * Copyright (C) 2001-2002 Greg Kroah-Hartman <greg@kroah.com>
  * Copyright (C) 2001 Networks Associates Technology, Inc <ssmalley@nai.com>
+ * Copyright (C) 2016 Mellanox Technologies
  *
  *	This program is free software; you can redistribute it and/or modify
  *	it under the terms of the GNU General Public License as published by
@@ -1399,6 +1400,67 @@ EXPORT_SYMBOL(security_tun_dev_open);
 
 #endif	/* CONFIG_SECURITY_NETWORK */
 
+#ifdef CONFIG_SECURITY_INFINIBAND
+
+int security_ib_qp_pkey_access(u64 subnet_prefix, u16 pkey,
+			       struct ib_qp_security *qp_sec)
+{
+	return call_int_hook(ib_qp_pkey_access, 0, subnet_prefix, pkey, qp_sec);
+}
+EXPORT_SYMBOL(security_ib_qp_pkey_access);
+
+int security_ib_mad_agent_pkey_access(u64 subnet_prefix, u16 pkey,
+				      struct ib_mad_agent *mad_agent)
+{
+	return call_int_hook(ib_mad_agent_pkey_access, 0, subnet_prefix, pkey, mad_agent);
+}
+EXPORT_SYMBOL(security_ib_mad_agent_pkey_access);
+
+int security_ib_end_port_smp(const char *dev_name, u8 port,
+			     struct ib_mad_agent *mad_agent)
+{
+	return call_int_hook(ib_end_port_smp, 0, dev_name, port, mad_agent);
+}
+EXPORT_SYMBOL(security_ib_end_port_smp);
+
+int security_ib_qp_alloc_security(struct ib_qp_security *qp_sec)
+{
+	return call_int_hook(ib_qp_alloc_security, 0, qp_sec);
+}
+EXPORT_SYMBOL(security_ib_qp_alloc_security);
+
+void security_ib_qp_free_security(struct ib_qp_security *qp_sec)
+{
+	call_void_hook(ib_qp_free_security, qp_sec);
+}
+EXPORT_SYMBOL(security_ib_qp_free_security);
+
+int security_ib_mad_agent_alloc_security(struct ib_mad_agent *mad_agent)
+{
+	return call_int_hook(ib_mad_agent_alloc_security, 0, mad_agent);
+}
+EXPORT_SYMBOL(security_ib_mad_agent_alloc_security);
+
+void security_ib_mad_agent_free_security(struct ib_mad_agent *mad_agent)
+{
+	call_void_hook(ib_mad_agent_free_security, mad_agent);
+}
+EXPORT_SYMBOL(security_ib_mad_agent_free_security);
+
+void security_register_ib_flush_callback(void (*callback)(void))
+{
+	call_void_hook(register_ib_flush_callback, callback);
+}
+EXPORT_SYMBOL(security_register_ib_flush_callback);
+
+void security_unregister_ib_flush_callback(void)
+{
+	call_void_hook(unregister_ib_flush_callback);
+}
+EXPORT_SYMBOL(security_unregister_ib_flush_callback);
+
+#endif	/* CONFIG_SECURITY_INFINIBAND */
+
 #ifdef CONFIG_SECURITY_NETWORK_XFRM
 
 int security_xfrm_policy_alloc(struct xfrm_sec_ctx **ctxp,
@@ -1850,6 +1912,27 @@ struct security_hook_heads security_hook_heads = {
 		LIST_HEAD_INIT(security_hook_heads.tun_dev_attach),
 	.tun_dev_open =	LIST_HEAD_INIT(security_hook_heads.tun_dev_open),
 #endif	/* CONFIG_SECURITY_NETWORK */
+
+#ifdef CONFIG_SECURITY_INFINIBAND
+	.ib_qp_pkey_access =
+		LIST_HEAD_INIT(security_hook_heads.ib_qp_pkey_access),
+	.ib_mad_agent_pkey_access =
+		LIST_HEAD_INIT(security_hook_heads.ib_mad_agent_pkey_access),
+	.ib_end_port_smp = LIST_HEAD_INIT(security_hook_heads.ib_end_port_smp),
+	.ib_qp_alloc_security =
+		LIST_HEAD_INIT(security_hook_heads.ib_qp_alloc_security),
+	.ib_qp_free_security =
+		LIST_HEAD_INIT(security_hook_heads.ib_qp_free_security),
+	.ib_mad_agent_alloc_security =
+		LIST_HEAD_INIT(security_hook_heads.ib_mad_agent_alloc_security),
+	.ib_mad_agent_free_security =
+		LIST_HEAD_INIT(security_hook_heads.ib_mad_agent_free_security),
+	.register_ib_flush_callback =
+		LIST_HEAD_INIT(security_hook_heads.register_ib_flush_callback),
+	.unregister_ib_flush_callback =
+		LIST_HEAD_INIT(security_hook_heads.unregister_ib_flush_callback),
+#endif	/* CONFIG_SECURITY_INFINIBAND */
+
 #ifdef CONFIG_SECURITY_NETWORK_XFRM
 	.xfrm_policy_alloc_security =
 		LIST_HEAD_INIT(security_hook_heads.xfrm_policy_alloc_security),
-- 
1.8.3.1

