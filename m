From: Dan Jurgens <danielj@mellanox.com>
Subject: [RFC PATCH v3 10/12] ib/core: Enforce PKey security on management datagrams
Date: Tue, 19 Apr 2016 22:51:27 +0300
Message-ID: <1461095489-18732-11-git-send-email-danielj@mellanox.com>
References: <1461095489-18732-1-git-send-email-danielj@mellanox.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1461095489-18732-1-git-send-email-danielj@mellanox.com>
Sender: owner-linux-security-module@vger.kernel.org
To: selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: yevgenyp@mellanox.com, Daniel Jurgens <danielj@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Jurgens <danielj@mellanox.com>

Allocate and free a security context when creating and destroying a MAD
agent.  This context is used for controlling access to PKeys.

When sending or receiving a MAD check that the agent has permission to
access the PKey for the Subnet Prefix of the port.

Signed-off-by: Daniel Jurgens <danielj@mellanox.com>
Reviewed-by: Eli Cohen <eli@mellanox.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

---
v2: Added patch to series

v3:
1. Shortened name of ib_security_enforce_mad_agent_pkey_access to
ib_security_ma_pkey_acces.  Leon

2. Refactored how the pkey index and subnet prefix are retreived due to
changes in the previous patch.

3. Changed call to security_mad_agent_pkey_access to add the ib_
---
 drivers/infiniband/core/core_priv.h |   13 +++++++
 drivers/infiniband/core/mad.c       |   63 +++++++++++++++++++++++++++++++----
 drivers/infiniband/core/security.c  |   24 +++++++++++++
 3 files changed, 93 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index 0482e12..ea577f0 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -150,6 +150,11 @@ int ib_get_cached_subnet_prefix(struct ib_device *device,
 				u64              *sn_pfx);
 
 #ifdef CONFIG_SECURITY_INFINIBAND
+int ib_security_ma_pkey_access(struct ib_device *dev,
+			       u8 port_num,
+			       u16 pkey_index,
+			       struct ib_mad_agent *mad_agent);
+
 void ib_security_destroy_port_pkey_list(struct ib_device *device);
 
 void ib_security_cache_change(struct ib_device *device,
@@ -168,6 +173,14 @@ void ib_destroy_qp_security_end(struct ib_qp_security *sec);
 int ib_open_shared_qp_security(struct ib_qp *qp, struct ib_device *dev);
 void ib_close_shared_qp_security(struct ib_qp_security *sec);
 #else
+static inline int ib_security_ma_pkey_access(struct ib_device *dev,
+					     u8 port_num,
+					     u16 pkey_index,
+					     struct ib_mad_agent *mad_agent)
+{
+	return 0;
+}
+
 static inline void ib_security_destroy_port_pkey_list(struct ib_device *device)
 {
 }
diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 9fa5bf3..f76a409 100644
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
@@ -341,11 +343,17 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
 		goto error1;
 	}
 
+	ret2 = security_ib_mad_agent_alloc_security(&mad_agent_priv->agent);
+	if (ret2) {
+		ret = ERR_PTR(ret2);
+		goto error3;
+	}
+
 	if (mad_reg_req) {
 		reg_req = kmemdup(mad_reg_req, sizeof *reg_req, GFP_KERNEL);
 		if (!reg_req) {
 			ret = ERR_PTR(-ENOMEM);
-			goto error3;
+			goto error4;
 		}
 	}
 
@@ -388,7 +396,7 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
 				if (method) {
 					if (method_in_use(&method,
 							   mad_reg_req))
-						goto error4;
+						goto error5;
 				}
 			}
 			ret2 = add_nonoui_reg_req(mad_reg_req, mad_agent_priv,
@@ -404,14 +412,14 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
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
 
@@ -421,9 +429,11 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
 
 	return &mad_agent_priv->agent;
 
-error4:
+error5:
 	spin_unlock_irqrestore(&port_priv->reg_lock, flags);
 	kfree(reg_req);
+error4:
+	security_ib_mad_agent_free_security(&mad_agent_priv->agent);
 error3:
 	kfree(mad_agent_priv);
 error1:
@@ -493,6 +503,7 @@ struct ib_mad_agent *ib_register_mad_snoop(struct ib_device *device,
 	struct ib_mad_agent *ret;
 	struct ib_mad_snoop_private *mad_snoop_priv;
 	int qpn;
+	int err;
 
 	/* Validate parameters */
 	if ((is_snooping_sends(mad_snoop_flags) && !snoop_handler) ||
@@ -517,6 +528,13 @@ struct ib_mad_agent *ib_register_mad_snoop(struct ib_device *device,
 		goto error1;
 	}
 
+	err = security_ib_mad_agent_alloc_security(&mad_snoop_priv->agent);
+
+	if (err) {
+		ret = ERR_PTR(err);
+		goto error2;
+	}
+
 	/* Now, fill in the various structures */
 	mad_snoop_priv->qp_info = &port_priv->qp_info[qpn];
 	mad_snoop_priv->agent.device = device;
@@ -527,17 +545,19 @@ struct ib_mad_agent *ib_register_mad_snoop(struct ib_device *device,
 	mad_snoop_priv->agent.port_num = port_num;
 	mad_snoop_priv->mad_snoop_flags = mad_snoop_flags;
 	init_completion(&mad_snoop_priv->comp);
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
+	security_ib_mad_agent_free_security(&mad_snoop_priv->agent);
 error2:
 	kfree(mad_snoop_priv);
 error1:
@@ -583,6 +603,8 @@ static void unregister_mad_agent(struct ib_mad_agent_private *mad_agent_priv)
 	deref_mad_agent(mad_agent_priv);
 	wait_for_completion(&mad_agent_priv->comp);
 
+	security_ib_mad_agent_free_security(&mad_agent_priv->agent);
+
 	kfree(mad_agent_priv->reg_req);
 	kfree(mad_agent_priv);
 }
@@ -601,6 +623,8 @@ static void unregister_mad_snoop(struct ib_mad_snoop_private *mad_snoop_priv)
 	deref_snoop_agent(mad_snoop_priv);
 	wait_for_completion(&mad_snoop_priv->comp);
 
+	security_ib_mad_agent_free_security(&mad_snoop_priv->agent);
+
 	kfree(mad_snoop_priv);
 }
 
@@ -1220,6 +1244,7 @@ int ib_post_send_mad(struct ib_mad_send_buf *send_buf,
 	struct ib_mad_send_wr_private *mad_send_wr;
 	unsigned long flags;
 	int ret = -EINVAL;
+	u16 pkey_index;
 
 	/* Walk list of send WRs and post each on send list */
 	for (; send_buf; send_buf = next_send_buf) {
@@ -1228,6 +1253,15 @@ int ib_post_send_mad(struct ib_mad_send_buf *send_buf,
 					   struct ib_mad_send_wr_private,
 					   send_buf);
 		mad_agent_priv = mad_send_wr->mad_agent_priv;
+		pkey_index = mad_send_wr->send_wr.pkey_index;
+
+		ret = ib_security_ma_pkey_access(mad_agent_priv->agent.device,
+						 mad_agent_priv->agent.port_num,
+						 pkey_index,
+						 &mad_agent_priv->agent);
+
+		if (ret)
+			goto error;
 
 		if (!send_buf->mad_agent->send_handler ||
 		    (send_buf->timeout_ms &&
@@ -1962,6 +1996,15 @@ static void ib_mad_complete_recv(struct ib_mad_agent_private *mad_agent_priv,
 	struct ib_mad_send_wr_private *mad_send_wr;
 	struct ib_mad_send_wc mad_send_wc;
 	unsigned long flags;
+	int ret;
+
+	ret = ib_security_ma_pkey_access(mad_agent_priv->agent.device,
+					 mad_agent_priv->agent.port_num,
+					 mad_recv_wc->wc->pkey_index,
+					 &mad_agent_priv->agent);
+
+	if (ret)
+		goto security_error;
 
 	INIT_LIST_HEAD(&mad_recv_wc->rmpp_list);
 	list_add(&mad_recv_wc->recv_buf.list, &mad_recv_wc->rmpp_list);
@@ -2019,6 +2062,12 @@ static void ib_mad_complete_recv(struct ib_mad_agent_private *mad_agent_priv,
 						   mad_recv_wc);
 		deref_mad_agent(mad_agent_priv);
 	}
+
+	return;
+
+security_error:
+	ib_free_recv_mad(mad_recv_wc);
+	deref_mad_agent(mad_agent_priv);
 }
 
 static enum smi_action handle_ib_smi(const struct ib_mad_port_private *port_priv,
diff --git a/drivers/infiniband/core/security.c b/drivers/infiniband/core/security.c
index 71a72e7..f88b328 100644
--- a/drivers/infiniband/core/security.c
+++ b/drivers/infiniband/core/security.c
@@ -614,4 +614,28 @@ int ib_security_modify_qp(struct ib_qp *qp,
 }
 EXPORT_SYMBOL(ib_security_modify_qp);
 
+int ib_security_ma_pkey_access(struct ib_device *dev,
+			       u8 port_num,
+			       u16 pkey_index,
+			       struct ib_mad_agent *mad_agent)
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
+	return security_ib_mad_agent_pkey_access(subnet_prefix,
+						 pkey,
+						 mad_agent);
+}
+EXPORT_SYMBOL(ib_security_ma_pkey_access);
+
 #endif /* CONFIG_SECURITY_INFINIBAND */
-- 
1.7.1

