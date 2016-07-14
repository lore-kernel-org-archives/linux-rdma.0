From: Dan Jurgens <danielj@mellanox.com>
Subject: [PATCH v2 4/9] IB/core: Enforce security on management datagrams
Date: Fri, 15 Jul 2016 01:56:46 +0300
Message-ID: <1468537011-20407-5-git-send-email-danielj@mellanox.com>
References: <1468537011-20407-1-git-send-email-danielj@mellanox.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1468537011-20407-1-git-send-email-danielj@mellanox.com>
Sender: owner-linux-security-module@vger.kernel.org
To: chrisw@sous-sol.org, paul@paul-moore.com, sds@tycho.nsa.gov, eparis@parisplace.org, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com
Cc: selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org, linux-rdma@vger.kernel.org, yevgenyp@mellanox.com, Daniel Jurgens <danielj@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Jurgens <danielj@mellanox.com>

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

Signed-off-by: Daniel Jurgens <danielj@mellanox.com>

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
---
 drivers/infiniband/core/core_priv.h |   35 +++++++++++++
 drivers/infiniband/core/mad.c       |   52 +++++++++++++++++---
 drivers/infiniband/core/security.c  |   90 +++++++++++++++++++++++++++++++++++
 include/linux/lsm_hooks.h           |    7 +++
 include/linux/security.h            |    6 ++
 include/rdma/ib_mad.h               |    4 ++
 security/security.c                 |    8 +++
 7 files changed, 194 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index 68e3de0..2c35162 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -37,6 +37,8 @@
 #include <linux/spinlock.h>
 
 #include <rdma/ib_verbs.h>
+#include <rdma/ib_mad.h>
+#include "mad_priv.h"
 
 struct pkey_index_qp_list {
 	struct list_head    pkey_index_list;
@@ -166,6 +168,11 @@ int ib_get_cached_subnet_prefix(struct ib_device *device,
 				u64              *sn_pfx);
 
 #ifdef CONFIG_SECURITY_INFINIBAND
+int ib_security_pkey_access(struct ib_device *dev,
+			    u8 port_num,
+			    u16 pkey_index,
+			    void *sec);
+
 void ib_security_destroy_port_pkey_list(struct ib_device *device);
 
 void ib_security_cache_change(struct ib_device *device,
@@ -183,7 +190,19 @@ void ib_destroy_qp_security_abort(struct ib_qp_security *sec);
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
@@ -232,5 +251,21 @@ static inline int ib_open_shared_qp_security(struct ib_qp *qp,
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
index 2d49228..94ebc3e 100644
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
@@ -367,6 +369,12 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
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
 
@@ -384,7 +392,7 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
 				if (method) {
 					if (method_in_use(&method,
 							   mad_reg_req))
-						goto error4;
+						goto error5;
 				}
 			}
 			ret2 = add_nonoui_reg_req(mad_reg_req, mad_agent_priv,
@@ -400,14 +408,14 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
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
 
@@ -416,9 +424,10 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
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
@@ -489,6 +498,7 @@ struct ib_mad_agent *ib_register_mad_snoop(struct ib_device *device,
 	struct ib_mad_agent *ret;
 	struct ib_mad_snoop_private *mad_snoop_priv;
 	int qpn;
+	int err;
 
 	/* Validate parameters */
 	if ((is_snooping_sends(mad_snoop_flags) && !snoop_handler) ||
@@ -523,17 +533,25 @@ struct ib_mad_agent *ib_register_mad_snoop(struct ib_device *device,
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
@@ -579,6 +597,8 @@ static void unregister_mad_agent(struct ib_mad_agent_private *mad_agent_priv)
 	deref_mad_agent(mad_agent_priv);
 	wait_for_completion(&mad_agent_priv->comp);
 
+	ib_mad_agent_security_cleanup(&mad_agent_priv->agent);
+
 	kfree(mad_agent_priv->reg_req);
 	kfree(mad_agent_priv);
 }
@@ -597,6 +617,8 @@ static void unregister_mad_snoop(struct ib_mad_snoop_private *mad_snoop_priv)
 	deref_snoop_agent(mad_snoop_priv);
 	wait_for_completion(&mad_snoop_priv->comp);
 
+	ib_mad_agent_security_cleanup(&mad_snoop_priv->agent);
+
 	kfree(mad_snoop_priv);
 }
 
@@ -1219,12 +1241,16 @@ int ib_post_send_mad(struct ib_mad_send_buf *send_buf,
 
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
@@ -1958,6 +1984,14 @@ static void ib_mad_complete_recv(struct ib_mad_agent_private *mad_agent_priv,
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
@@ -2015,6 +2049,8 @@ static void ib_mad_complete_recv(struct ib_mad_agent_private *mad_agent_priv,
 						   mad_recv_wc);
 		deref_mad_agent(mad_agent_priv);
 	}
+
+	return;
 }
 
 static enum smi_action handle_ib_smi(const struct ib_mad_port_private *port_priv,
diff --git a/drivers/infiniband/core/security.c b/drivers/infiniband/core/security.c
index 44ff452..915e3ac 100644
--- a/drivers/infiniband/core/security.c
+++ b/drivers/infiniband/core/security.c
@@ -39,6 +39,7 @@
 #include <rdma/ib_verbs.h>
 #include <rdma/ib_cache.h>
 #include "core_priv.h"
+#include "mad_priv.h"
 
 static struct pkey_index_qp_list *get_pkey_idx_qp_list(struct ib_port_pkey *pp)
 {
@@ -614,4 +615,93 @@ int ib_security_modify_qp(struct ib_qp *qp,
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
+	return security_ib_pkey_access(subnet_prefix, pkey, sec);
+}
+EXPORT_SYMBOL(ib_security_pkey_access);
+
+static void ib_mad_agent_security_change(enum lsm_event event, void *ctx,
+					 void *data)
+{
+	struct ib_mad_agent *ag = (struct ib_mad_agent *)ctx;
+
+	if (event != LSM_POLICY_CHANGE)
+		return;
+
+	ag->smp_allowed = !security_ib_port_manage_subnet(ag->device->name,
+							  ag->port_num,
+							  ag->security);
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
+	ret = security_ib_port_manage_subnet(agent->device->name,
+					     agent->port_num,
+					     agent->security);
+	if (ret)
+		return ret;
+
+	ret = security_register_lsm_notifier(&ib_mad_agent_security_change,
+					     agent,
+					     &agent->lsm_id);
+	if (ret)
+		return ret;
+
+	agent->smp_allowed = true;
+	agent->lsm_reg = true;
+	return 0;
+}
+
+void ib_mad_agent_security_cleanup(struct ib_mad_agent *agent)
+{
+	security_ib_free_security(agent->security);
+	if (agent->lsm_reg)
+		security_unregister_lsm_notifier(agent->lsm_id);
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
index f85a8f3..97c81ad 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -884,6 +884,11 @@
  *	@subnet_prefix the subnet prefix of the port being used.
  *	@pkey the pkey to be accessed.
  *	@sec pointer to a security structure.
+ * @ib_port_manage_subnet:
+ *	Check permissions to send and receive SMPs on a end port.
+ *	@dev_name the IB device name (i.e. mlx4_0).
+ *	@port_num the port number.
+ *	@sec pointer to a security structure.
  * @ib_alloc_security:
  *	Allocate a security structure for Infiniband objects.
  *	@sec pointer to a security structure pointer.
@@ -1597,6 +1602,7 @@ union security_list_options {
 
 #ifdef CONFIG_SECURITY_INFINIBAND
 	int (*ib_pkey_access)(u64 subnet_prefix, u16 pkey, void *sec);
+	int (*ib_port_manage_subnet)(const char *dev_name, u8 port, void *sec);
 	int (*ib_alloc_security)(void **sec);
 	void (*ib_free_security)(void *sec);
 #endif	/* CONFIG_SECURITY_INFINIBAND */
@@ -1830,6 +1836,7 @@ struct security_hook_heads {
 #endif	/* CONFIG_SECURITY_NETWORK */
 #ifdef CONFIG_SECURITY_INFINIBAND
 	struct list_head ib_pkey_access;
+	struct list_head ib_port_manage_subnet;
 	struct list_head ib_alloc_security;
 	struct list_head ib_free_security;
 #endif	/* CONFIG_SECURITY_INFINIBAND */
diff --git a/include/linux/security.h b/include/linux/security.h
index bf53911..2600098 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1383,6 +1383,7 @@ static inline int security_tun_dev_open(void *security)
 
 #ifdef CONFIG_SECURITY_INFINIBAND
 int security_ib_pkey_access(u64 subnet_prefix, u16 pkey, void *sec);
+int security_ib_port_manage_subnet(const char *name, u8 port, void *sec);
 int security_ib_alloc_security(void **sec);
 void security_ib_free_security(void *sec);
 #else	/* CONFIG_SECURITY_INFINIBAND */
@@ -1391,6 +1392,11 @@ static inline int security_ib_pkey_access(u64 subnet_prefix, u16 pkey, void *sec
 	return 0;
 }
 
+static inline int security_ib_port_manage_subnet(const char *dev_name, u8 port, void *sec)
+{
+	return 0;
+}
+
 static inline int security_ib_alloc_security(void **sec)
 {
 	return 0;
diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
index c8a773f..f846a61 100644
--- a/include/rdma/ib_mad.h
+++ b/include/rdma/ib_mad.h
@@ -537,6 +537,10 @@ struct ib_mad_agent {
 	u32			flags;
 	u8			port_num;
 	u8			rmpp_version;
+	void			*security;
+	bool			smp_allowed;
+	u32			lsm_id;
+	bool			lsm_reg;
 };
 
 /**
diff --git a/security/security.c b/security/security.c
index 1263c1d..fb46e90 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1466,6 +1466,12 @@ int security_ib_pkey_access(u64 subnet_prefix, u16 pkey, void *sec)
 }
 EXPORT_SYMBOL(security_ib_pkey_access);
 
+int security_ib_port_manage_subnet(const char *dev_name, u8 port, void *sec)
+{
+	return call_int_hook(ib_port_manage_subnet, 0, dev_name, port, sec);
+}
+EXPORT_SYMBOL(security_ib_port_manage_subnet);
+
 int security_ib_alloc_security(void **sec)
 {
 	return call_int_hook(ib_alloc_security, 0, sec);
@@ -1933,6 +1939,8 @@ struct security_hook_heads security_hook_heads = {
 
 #ifdef CONFIG_SECURITY_INFINIBAND
 	.ib_pkey_access = LIST_HEAD_INIT(security_hook_heads.ib_pkey_access),
+	.ib_port_manage_subnet =
+		LIST_HEAD_INIT(security_hook_heads.ib_port_manage_subnet),
 	.ib_alloc_security =
 		LIST_HEAD_INIT(security_hook_heads.ib_alloc_security),
 	.ib_free_security =
-- 
1.7.1

