From: Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v7 4/9] IB/core: Enforce security on management datagrams
Date: Fri, 19 May 2017 15:48:54 +0300
Message-ID: <1495198139-69993-5-git-send-email-danielj@mellanox.com>
References: <1495198139-69993-1-git-send-email-danielj@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1495198139-69993-1-git-send-email-danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org, paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org, sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Allocate and free a security context when creating and destroying a MAD
agent.  This context is used for controlling access to PKeys and sending
and receiving SMPs.

When sending or receiving a MAD check that the agent has permission to
access the PKey for the Subnet Prefix of the port.

During MAD and snoop agent registration for SMI QPs check that the
calling process has permission to access the manage the subnet  and
register a callback with the LSM to be notified of policy changes. When
notificaiton of a policy change occurs recheck permission and set a flag
indicating sending and receiving SMPs is allowed.

When sending and receiving MADs check that the agent has access to the
SMI if it's on an SMI QP.  Because security policy can change it's
possible permission was allowed when creating the agent, but no longer
is.

Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

---
v2:
- Squashed LSM hook additions. Paul Moore
- Changed security blobs to void*. Paul Moore
- Shorten end_port to port. Paul Moore
- Change "smp" to "manage_subnet". Paul Moore
- Use the LSM policy change notification and a flag to track permission
  instead of calling the LSM hook for every SMP. Dan Jurgens
- Squashed PKey and SMP enforcement into the same patch and moved the
  logic into security.c. Dan Jurgens

v3:
- ib_port -> ib_endport. Paul Moore
- Use notifier chains for LSM notification. Paul Moore
- Reorder LSM hook parameters to put sec first. Paul Moore

 drivers/infiniband/core/core_priv.h | 35 ++++++++++++++
 drivers/infiniband/core/mad.c       | 52 +++++++++++++++++----
 drivers/infiniband/core/security.c  | 92 +++++++++++++++++++++++++++++++++++++
 include/linux/lsm_hooks.h           |  8 ++++
 include/linux/security.h            |  6 +++
 include/rdma/ib_mad.h               |  4 ++
 security/security.c                 |  8 ++++
 7 files changed, 197 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index 7b63215..0664527 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -38,6 +38,8 @@
 #include <linux/cgroup_rdma.h>
 
 #include <rdma/ib_verbs.h>
+#include <rdma/ib_mad.h>
+#include "mad_priv.h"
 
 struct pkey_index_qp_list {
 	struct list_head    pkey_index_list;
@@ -189,6 +191,11 @@ int ib_get_cached_subnet_prefix(struct ib_device *device,
 				u64              *sn_pfx);
 
 #ifdef CONFIG_SECURITY_INFINIBAND
+int ib_security_pkey_access(struct ib_device *dev,
+			    u8 port_num,
+			    u16 pkey_index,
+			    void *sec);
+
 void ib_security_destroy_port_pkey_list(struct ib_device *device);
 
 void ib_security_cache_change(struct ib_device *device,
@@ -206,7 +213,19 @@ void ib_destroy_qp_security_abort(struct ib_qp_security *sec);
 void ib_destroy_qp_security_end(struct ib_qp_security *sec);
 int ib_open_shared_qp_security(struct ib_qp *qp, struct ib_device *dev);
 void ib_close_shared_qp_security(struct ib_qp_security *sec);
+int ib_mad_agent_security_setup(struct ib_mad_agent *agent,
+				enum ib_qp_type qp_type);
+void ib_mad_agent_security_cleanup(struct ib_mad_agent *agent);
+int ib_mad_enforce_security(struct ib_mad_agent_private *map, u16 pkey_index);
 #else
+static inline int ib_security_pkey_access(struct ib_device *dev,
+					  u8 port_num,
+					  u16 pkey_index,
+					  void *sec)
+{
+	return 0;
+}
+
 static inline void ib_security_destroy_port_pkey_list(struct ib_device *device)
 {
 }
@@ -255,5 +274,21 @@ static inline int ib_open_shared_qp_security(struct ib_qp *qp,
 static inline void ib_close_shared_qp_security(struct ib_qp_security *sec)
 {
 }
+
+static inline int ib_mad_agent_security_setup(struct ib_mad_agent *agent,
+					      enum ib_qp_type qp_type)
+{
+	return 0;
+}
+
+static inline void ib_mad_agent_security_cleanup(struct ib_mad_agent *agent)
+{
+}
+
+static inline int ib_mad_enforce_security(struct ib_mad_agent_private *map,
+					  u16 pkey_index)
+{
+	return 0;
+}
 #endif
 #endif /* _CORE_PRIV_H */
diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 57f231f..46b3c98 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -40,9 +40,11 @@
 #include <linux/dma-mapping.h>
 #include <linux/slab.h>
 #include <linux/module.h>
+#include <linux/security.h>
 #include <rdma/ib_cache.h>
 
 #include "mad_priv.h"
+#include "core_priv.h"
 #include "mad_rmpp.h"
 #include "smi.h"
 #include "opa_smi.h"
@@ -369,6 +371,12 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
 	atomic_set(&mad_agent_priv->refcount, 1);
 	init_completion(&mad_agent_priv->comp);
 
+	ret2 = ib_mad_agent_security_setup(&mad_agent_priv->agent, qp_type);
+	if (ret2) {
+		ret = ERR_PTR(ret2);
+		goto error4;
+	}
+
 	spin_lock_irqsave(&port_priv->reg_lock, flags);
 	mad_agent_priv->agent.hi_tid = ++ib_mad_client_id;
 
@@ -386,7 +394,7 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
 				if (method) {
 					if (method_in_use(&method,
 							   mad_reg_req))
-						goto error4;
+						goto error5;
 				}
 			}
 			ret2 = add_nonoui_reg_req(mad_reg_req, mad_agent_priv,
@@ -402,14 +410,14 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
 					if (is_vendor_method_in_use(
 							vendor_class,
 							mad_reg_req))
-						goto error4;
+						goto error5;
 				}
 			}
 			ret2 = add_oui_reg_req(mad_reg_req, mad_agent_priv);
 		}
 		if (ret2) {
 			ret = ERR_PTR(ret2);
-			goto error4;
+			goto error5;
 		}
 	}
 
@@ -418,9 +426,10 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
 	spin_unlock_irqrestore(&port_priv->reg_lock, flags);
 
 	return &mad_agent_priv->agent;
-
-error4:
+error5:
 	spin_unlock_irqrestore(&port_priv->reg_lock, flags);
+	ib_mad_agent_security_cleanup(&mad_agent_priv->agent);
+error4:
 	kfree(reg_req);
 error3:
 	kfree(mad_agent_priv);
@@ -491,6 +500,7 @@ struct ib_mad_agent *ib_register_mad_snoop(struct ib_device *device,
 	struct ib_mad_agent *ret;
 	struct ib_mad_snoop_private *mad_snoop_priv;
 	int qpn;
+	int err;
 
 	/* Validate parameters */
 	if ((is_snooping_sends(mad_snoop_flags) && !snoop_handler) ||
@@ -525,17 +535,25 @@ struct ib_mad_agent *ib_register_mad_snoop(struct ib_device *device,
 	mad_snoop_priv->agent.port_num = port_num;
 	mad_snoop_priv->mad_snoop_flags = mad_snoop_flags;
 	init_completion(&mad_snoop_priv->comp);
+
+	err = ib_mad_agent_security_setup(&mad_snoop_priv->agent, qp_type);
+	if (err) {
+		ret = ERR_PTR(err);
+		goto error2;
+	}
+
 	mad_snoop_priv->snoop_index = register_snoop_agent(
 						&port_priv->qp_info[qpn],
 						mad_snoop_priv);
 	if (mad_snoop_priv->snoop_index < 0) {
 		ret = ERR_PTR(mad_snoop_priv->snoop_index);
-		goto error2;
+		goto error3;
 	}
 
 	atomic_set(&mad_snoop_priv->refcount, 1);
 	return &mad_snoop_priv->agent;
-
+error3:
+	ib_mad_agent_security_cleanup(&mad_snoop_priv->agent);
 error2:
 	kfree(mad_snoop_priv);
 error1:
@@ -581,6 +599,8 @@ static void unregister_mad_agent(struct ib_mad_agent_private *mad_agent_priv)
 	deref_mad_agent(mad_agent_priv);
 	wait_for_completion(&mad_agent_priv->comp);
 
+	ib_mad_agent_security_cleanup(&mad_agent_priv->agent);
+
 	kfree(mad_agent_priv->reg_req);
 	kfree(mad_agent_priv);
 }
@@ -599,6 +619,8 @@ static void unregister_mad_snoop(struct ib_mad_snoop_private *mad_snoop_priv)
 	deref_snoop_agent(mad_snoop_priv);
 	wait_for_completion(&mad_snoop_priv->comp);
 
+	ib_mad_agent_security_cleanup(&mad_snoop_priv->agent);
+
 	kfree(mad_snoop_priv);
 }
 
@@ -1216,12 +1238,16 @@ int ib_post_send_mad(struct ib_mad_send_buf *send_buf,
 
 	/* Walk list of send WRs and post each on send list */
 	for (; send_buf; send_buf = next_send_buf) {
-
 		mad_send_wr = container_of(send_buf,
 					   struct ib_mad_send_wr_private,
 					   send_buf);
 		mad_agent_priv = mad_send_wr->mad_agent_priv;
 
+		ret = ib_mad_enforce_security(mad_agent_priv,
+					      mad_send_wr->send_wr.pkey_index);
+		if (ret)
+			goto error;
+
 		if (!send_buf->mad_agent->send_handler ||
 		    (send_buf->timeout_ms &&
 		     !send_buf->mad_agent->recv_handler)) {
@@ -1942,6 +1968,14 @@ static void ib_mad_complete_recv(struct ib_mad_agent_private *mad_agent_priv,
 	struct ib_mad_send_wr_private *mad_send_wr;
 	struct ib_mad_send_wc mad_send_wc;
 	unsigned long flags;
+	int ret;
+
+	ret = ib_mad_enforce_security(mad_agent_priv,
+				      mad_recv_wc->wc->pkey_index);
+	if (ret) {
+		ib_free_recv_mad(mad_recv_wc);
+		deref_mad_agent(mad_agent_priv);
+	}
 
 	INIT_LIST_HEAD(&mad_recv_wc->rmpp_list);
 	list_add(&mad_recv_wc->recv_buf.list, &mad_recv_wc->rmpp_list);
@@ -1999,6 +2033,8 @@ static void ib_mad_complete_recv(struct ib_mad_agent_private *mad_agent_priv,
 						   mad_recv_wc);
 		deref_mad_agent(mad_agent_priv);
 	}
+
+	return;
 }
 
 static enum smi_action handle_ib_smi(const struct ib_mad_port_private *port_priv,
diff --git a/drivers/infiniband/core/security.c b/drivers/infiniband/core/security.c
index 1ec913c..1644ddb 100644
--- a/drivers/infiniband/core/security.c
+++ b/drivers/infiniband/core/security.c
@@ -39,6 +39,7 @@
 #include <rdma/ib_verbs.h>
 #include <rdma/ib_cache.h>
 #include "core_priv.h"
+#include "mad_priv.h"
 
 static struct pkey_index_qp_list *get_pkey_idx_qp_list(struct ib_port_pkey *pp)
 {
@@ -615,4 +616,95 @@ int ib_security_modify_qp(struct ib_qp *qp,
 }
 EXPORT_SYMBOL(ib_security_modify_qp);
 
+int ib_security_pkey_access(struct ib_device *dev,
+			    u8 port_num,
+			    u16 pkey_index,
+			    void *sec)
+{
+	u64 subnet_prefix;
+	u16 pkey;
+	int ret;
+
+	ret = ib_get_cached_pkey(dev, port_num, pkey_index, &pkey);
+	if (ret)
+		return ret;
+
+	ret = ib_get_cached_subnet_prefix(dev, port_num, &subnet_prefix);
+
+	if (ret)
+		return ret;
+
+	return security_ib_pkey_access(sec, subnet_prefix, pkey);
+}
+EXPORT_SYMBOL(ib_security_pkey_access);
+
+static int ib_mad_agent_security_change(struct notifier_block *nb,
+					unsigned long event,
+					void *data)
+{
+	struct ib_mad_agent *ag = container_of(nb, struct ib_mad_agent, lsm_nb);
+
+	if (event != LSM_POLICY_CHANGE)
+		return NOTIFY_DONE;
+
+	ag->smp_allowed = !security_ib_endport_manage_subnet(ag->security,
+							     ag->device->name,
+							     ag->port_num);
+
+	return NOTIFY_OK;
+}
+
+int ib_mad_agent_security_setup(struct ib_mad_agent *agent,
+				enum ib_qp_type qp_type)
+{
+	int ret;
+
+	ret = security_ib_alloc_security(&agent->security);
+	if (ret)
+		return ret;
+
+	if (qp_type != IB_QPT_SMI)
+		return 0;
+
+	ret = security_ib_endport_manage_subnet(agent->security,
+						agent->device->name,
+						agent->port_num);
+	if (ret)
+		return ret;
+
+	agent->lsm_nb.notifier_call = ib_mad_agent_security_change;
+	ret = register_lsm_notifier(&agent->lsm_nb);
+	if (ret)
+		return ret;
+
+	agent->smp_allowed = true;
+	agent->lsm_nb_reg = true;
+	return 0;
+}
+
+void ib_mad_agent_security_cleanup(struct ib_mad_agent *agent)
+{
+	security_ib_free_security(agent->security);
+	if (agent->lsm_nb_reg)
+		unregister_lsm_notifier(&agent->lsm_nb);
+}
+
+int ib_mad_enforce_security(struct ib_mad_agent_private *map, u16 pkey_index)
+{
+	int ret;
+
+	if (map->agent.qp->qp_type == IB_QPT_SMI && !map->agent.smp_allowed)
+		return -EACCES;
+
+	ret = ib_security_pkey_access(map->agent.device,
+				      map->agent.port_num,
+				      pkey_index,
+				      map->agent.security);
+
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
 #endif /* CONFIG_SECURITY_INFINIBAND */
diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index 6d9f41f..68d91e4 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -919,6 +919,11 @@
  *	@subnet_prefix the subnet prefix of the port being used.
  *	@pkey the pkey to be accessed.
  *	@sec pointer to a security structure.
+ * @ib_endport_manage_subnet:
+ *	Check permissions to send and receive SMPs on a end port.
+ *	@dev_name the IB device name (i.e. mlx4_0).
+ *	@port_num the port number.
+ *	@sec pointer to a security structure.
  * @ib_alloc_security:
  *	Allocate a security structure for Infiniband objects.
  *	@sec pointer to a security structure pointer.
@@ -1638,6 +1643,8 @@ union security_list_options {
 
 #ifdef CONFIG_SECURITY_INFINIBAND
 	int (*ib_pkey_access)(void *sec, u64 subnet_prefix, u16 pkey);
+	int (*ib_endport_manage_subnet)(void *sec, const char *dev_name,
+					u8 port_num);
 	int (*ib_alloc_security)(void **sec);
 	void (*ib_free_security)(void *sec);
 #endif	/* CONFIG_SECURITY_INFINIBAND */
@@ -1875,6 +1882,7 @@ struct security_hook_heads {
 #endif	/* CONFIG_SECURITY_NETWORK */
 #ifdef CONFIG_SECURITY_INFINIBAND
 	struct list_head ib_pkey_access;
+	struct list_head ib_endport_manage_subnet;
 	struct list_head ib_alloc_security;
 	struct list_head ib_free_security;
 #endif	/* CONFIG_SECURITY_INFINIBAND */
diff --git a/include/linux/security.h b/include/linux/security.h
index f96e333..549cb82 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1432,6 +1432,7 @@ static inline int security_tun_dev_open(void *security)
 
 #ifdef CONFIG_SECURITY_INFINIBAND
 int security_ib_pkey_access(void *sec, u64 subnet_prefix, u16 pkey);
+int security_ib_endport_manage_subnet(void *sec, const char *name, u8 port_num);
 int security_ib_alloc_security(void **sec);
 void security_ib_free_security(void *sec);
 #else	/* CONFIG_SECURITY_INFINIBAND */
@@ -1440,6 +1441,11 @@ static inline int security_ib_pkey_access(void *sec, u64 subnet_prefix, u16 pkey
 	return 0;
 }
 
+static inline int security_ib_endport_manage_subnet(void *sec, const char *dev_name, u8 port_num)
+{
+	return 0;
+}
+
 static inline int security_ib_alloc_security(void **sec)
 {
 	return 0;
diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
index 981214b..12eb539 100644
--- a/include/rdma/ib_mad.h
+++ b/include/rdma/ib_mad.h
@@ -537,6 +537,10 @@ struct ib_mad_agent {
 	u32			flags;
 	u8			port_num;
 	u8			rmpp_version;
+	void			*security;
+	bool			smp_allowed;
+	bool			lsm_nb_reg;
+	struct notifier_block   lsm_nb;
 };
 
 /**
diff --git a/security/security.c b/security/security.c
index 6eef315..b69fe6f 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1540,6 +1540,12 @@ int security_ib_pkey_access(void *sec, u64 subnet_prefix, u16 pkey)
 }
 EXPORT_SYMBOL(security_ib_pkey_access);
 
+int security_ib_endport_manage_subnet(void *sec, const char *dev_name, u8 port_num)
+{
+	return call_int_hook(ib_endport_manage_subnet, 0, sec, dev_name, port_num);
+}
+EXPORT_SYMBOL(security_ib_endport_manage_subnet);
+
 int security_ib_alloc_security(void **sec)
 {
 	return call_int_hook(ib_alloc_security, 0, sec);
@@ -2014,6 +2020,8 @@ struct security_hook_heads security_hook_heads __lsm_ro_after_init = {
 
 #ifdef CONFIG_SECURITY_INFINIBAND
 	.ib_pkey_access = LIST_HEAD_INIT(security_hook_heads.ib_pkey_access),
+	.ib_endport_manage_subnet =
+		LIST_HEAD_INIT(security_hook_heads.ib_endport_manage_subnet),
 	.ib_alloc_security =
 		LIST_HEAD_INIT(security_hook_heads.ib_alloc_security),
 	.ib_free_security =
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
