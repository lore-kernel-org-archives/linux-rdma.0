From: Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC PATCH v2 12/13] ib/core: Track which QPs are using which port and PKey index
Date: Thu,  7 Apr 2016 02:33:57 +0300
Message-ID: <1459985638-37233-13-git-send-email-danielj@mellanox.com>
References: <1459985638-37233-1-git-send-email-danielj@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1459985638-37233-1-git-send-email-danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In order to maintain access control to PKeys keep a list of which QPs
are using each PKey index on a particular port because the PKey table
can change. If that happens all QPs using a particular PKey index must
have access to the new PKey enforced.

This adds a transaction to the QP modify process.  Association with
the old port and PKey index must be maintained if the modify fails,
and must be removed if it succeeds.  Association with the new port and
Pkey index must be removed if the modify fails and maintained if it
succeeds.

1. When a QP is modified to a particular port and PKey index insert that
  QP into the list.

2. If the modify succeeds remove any prior associations.

3. If the modify fails remove the new association.

4. The alternate path port and PKey index must be maintained similarly.

When the PKey table or subnet prefix changes walk the list of QPs and
check that they have permission.  If not send the QP to the error state
and raise a fatal error event.  If it's a shared QP also make sure all
the QPs that share the real_qp also have permission.

Maintaining the list correctly also turns QP destroy into a transaction.
Before attempting to destroy the QP via the hardware driver the list
must be marked so that a cache update doesn't cause an attempt to reset
the QP in question.  After the hardware driver returns the QP security
information is cleaned up if the destroy was successful, or the PKey
security for the QP is verified and it's position in the list unmarked
if the destroy failed.

Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/cache.c         |   21 ++-
 drivers/infiniband/core/core_priv.h     |   48 +++-
 drivers/infiniband/core/core_security.c |  427 +++++++++++++++++++++++++++----
 drivers/infiniband/core/device.c        |   33 +++
 drivers/infiniband/core/uverbs_cmd.c    |    2 +-
 drivers/infiniband/core/verbs.c         |   13 +-
 include/rdma/ib_verbs.h                 |   15 +
 7 files changed, 492 insertions(+), 67 deletions(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index 83cf528..a4c406d 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -53,6 +53,7 @@ struct ib_update_work {
 	struct work_struct work;
 	struct ib_device  *device;
 	u8                 port_num;
+	bool		   enforce_security;
 };
 
 union ib_gid zgid;
@@ -1037,7 +1038,8 @@ int ib_get_cached_lmc(struct ib_device *device,
 EXPORT_SYMBOL(ib_get_cached_lmc);
 
 static void ib_cache_update(struct ib_device *device,
-			    u8                port)
+			    u8                port,
+			    bool	      enforce_security)
 {
 	struct ib_port_attr       *tprops = NULL;
 	struct ib_pkey_cache      *pkey_cache = NULL, *old_pkey_cache;
@@ -1125,6 +1127,11 @@ static void ib_cache_update(struct ib_device *device,
 							tprops->subnet_prefix;
 	write_unlock_irq(&device->cache.lock);
 
+	if (enforce_security)
+		ib_security_cache_change(device,
+					 port,
+					 tprops->subnet_prefix);
+
 	kfree(gid_cache);
 	kfree(old_pkey_cache);
 	kfree(tprops);
@@ -1141,7 +1148,9 @@ static void ib_cache_task(struct work_struct *_work)
 	struct ib_update_work *work =
 		container_of(_work, struct ib_update_work, work);
 
-	ib_cache_update(work->device, work->port_num);
+	ib_cache_update(work->device,
+			work->port_num,
+			work->enforce_security);
 	kfree(work);
 }
 
@@ -1162,6 +1171,12 @@ static void ib_cache_event(struct ib_event_handler *handler,
 			INIT_WORK(&work->work, ib_cache_task);
 			work->device   = event->device;
 			work->port_num = event->element.port_num;
+			if (event->event == IB_EVENT_PKEY_CHANGE ||
+			    event->event == IB_EVENT_GID_CHANGE)
+				work->enforce_security = true;
+			else
+				work->enforce_security = false;
+
 			queue_work(ib_wq, &work->work);
 		}
 	}
@@ -1204,7 +1219,7 @@ int ib_cache_setup_one(struct ib_device *device)
 		return err;
 
 	for (p = 0; p <= rdma_end_port(device) - rdma_start_port(device); ++p)
-		ib_cache_update(device, p + rdma_start_port(device));
+		ib_cache_update(device, p + rdma_start_port(device), true);
 
 	INIT_IB_EVENT_HANDLER(&device->cache.event_handler,
 			      device, ib_cache_event);
diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index 2759a18..216c288 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -38,6 +38,14 @@
 
 #include <rdma/ib_verbs.h>
 
+struct pkey_index_qp_list {
+	struct list_head    pkey_index_list;
+	u16                 pkey_index;
+	/* Lock to hold while iterating the qp_list. */
+	spinlock_t          qp_list_lock;
+	struct list_head    qp_list;
+};
+
 #if IS_ENABLED(CONFIG_INFINIBAND_ADDR_TRANS_CONFIGFS)
 int cma_configfs_init(void);
 void cma_configfs_exit(void);
@@ -147,14 +155,22 @@ int ib_security_enforce_mad_agent_pkey_access(struct ib_device *dev,
 					      u16 pkey_index,
 					      struct ib_mad_agent *mad_agent);
 
+void ib_security_destroy_port_pkey_list(struct ib_device *device);
+
+void ib_security_cache_change(struct ib_device *device,
+			      u8 port_num,
+			      u64 subnet_prefix);
+
 int ib_security_modify_qp(struct ib_qp *qp,
 			  struct ib_qp_attr *qp_attr,
 			  int qp_attr_mask,
 			  struct ib_udata *udata);
 
-int ib_security_create_qp_security(struct ib_qp *qp);
-void ib_security_destroy_qp(struct ib_qp_security *sec);
-int ib_security_open_shared_qp(struct ib_qp *qp);
+int ib_security_create_qp_security(struct ib_qp *qp, struct ib_device *dev);
+void ib_security_destroy_qp_begin(struct ib_qp_security *sec);
+void ib_security_destroy_qp_abort(struct ib_qp_security *sec);
+void ib_security_destroy_qp_end(struct ib_qp_security *sec);
+int ib_security_open_shared_qp(struct ib_qp *qp, struct ib_device *dev);
 void ib_security_close_shared_qp(struct ib_qp_security *sec);
 #else
 static inline int ib_security_enforce_mad_agent_pkey_access(
@@ -166,6 +182,16 @@ static inline int ib_security_enforce_mad_agent_pkey_access(
 	return 0;
 }
 
+static inline void ib_security_destroy_port_pkey_list(struct ib_device *device)
+{
+}
+
+static inline void ib_security_cache_change(struct ib_device *device,
+					    u8 port_num,
+					    u64 subnet_prefix)
+{
+}
+
 static inline int ib_security_modify_qp(struct ib_qp *qp,
 					struct ib_qp_attr *qp_attr,
 					int qp_attr_mask,
@@ -177,16 +203,26 @@ static inline int ib_security_modify_qp(struct ib_qp *qp,
 				     udata);
 }
 
-static inline int ib_security_create_qp_security(struct ib_qp *qp)
+static inline int ib_security_create_qp_security(struct ib_qp *qp,
+						 struct ib_device *dev)
 {
 	return 0;
 }
 
-static inline void ib_security_destroy_qp(struct ib_qp_security *sec)
+static inline void ib_security_destroy_qp_begin(struct ib_qp_security *sec)
+{
+}
+
+static inline void ib_security_destroy_qp_abort(struct ib_qp_security *sec)
+{
+}
+
+static inline void ib_security_destroy_qp_end(struct ib_qp_security *sec)
 {
 }
 
-static inline int ib_security_open_shared_qp(struct ib_qp *qp)
+static inline int ib_security_open_shared_qp(struct ib_qp *qp,
+					     struct ib_device *dev)
 {
 	return 0;
 }
diff --git a/drivers/infiniband/core/core_security.c b/drivers/infiniband/core/core_security.c
index dda680b..ebc66c1 100644
--- a/drivers/infiniband/core/core_security.c
+++ b/drivers/infiniband/core/core_security.c
@@ -1,4 +1,5 @@
-/*
+/* NEW COMMIT TO INSERT INTO REBASE
+ *
  * Copyright (c) 2016 Mellanox Technologies Ltd.  All rights reserved.
  *
  * This software is available to you under a choice of one of two
@@ -33,11 +34,27 @@
 #ifdef CONFIG_SECURITY_INFINIBAND
 
 #include <linux/security.h>
+#include <linux/list.h>
 
 #include <rdma/ib_verbs.h>
 #include <rdma/ib_cache.h>
 #include "core_priv.h"
 
+static struct pkey_index_qp_list *get_pkey_index_qp_list(struct ib_device *dev,
+							 u8 port_num,
+							 u16 index)
+{
+	struct pkey_index_qp_list *tmp_pkey;
+
+	list_for_each_entry(tmp_pkey,
+			    &dev->port_pkey_list[port_num].pkey_list,
+			    pkey_index_list) {
+		if (tmp_pkey->pkey_index == index)
+			return tmp_pkey;
+	}
+	return NULL;
+}
+
 static int get_pkey_info(struct ib_device *dev,
 			 u8 port_num,
 			 u16 pkey_index,
@@ -90,6 +107,175 @@ static int enforce_qp_pkey_security(struct ib_device *dev,
 	return err;
 }
 
+static int check_qp_port_pkey_settings(struct ib_qp_security *sec)
+{
+	struct ib_qp *real_qp = sec->qp->real_qp;
+	int err = 0;
+
+	if (real_qp->qp_sec->ports_pkeys.main.state != IB_PORT_PKEY_NOT_VALID)
+		err = enforce_qp_pkey_security(real_qp->device,
+					       real_qp->qp_sec->ports_pkeys.main.port_num,
+					       real_qp->qp_sec->ports_pkeys.main.pkey_index,
+					       sec);
+	if (err)
+		goto out;
+
+	if (real_qp->qp_sec->ports_pkeys.alt.state != IB_PORT_PKEY_NOT_VALID)
+		err = enforce_qp_pkey_security(real_qp->device,
+					       real_qp->qp_sec->ports_pkeys.alt.port_num,
+					       real_qp->qp_sec->ports_pkeys.alt.pkey_index,
+					       sec);
+
+	if (err)
+		goto out;
+
+out:
+	return err;
+}
+
+static void reset_qp(struct ib_qp_security *sec)
+{
+	struct ib_qp_security *shared_qp_sec;
+	struct ib_qp_attr attr = {
+		.qp_state = IB_QPS_ERR
+	};
+	struct ib_event event = {
+		.event = IB_EVENT_QP_FATAL
+	};
+
+	mutex_lock(&sec->mutex);
+	if (sec->destroying)
+		goto unlock;
+
+	ib_modify_qp(sec->qp,
+		     &attr,
+		     IB_QP_STATE);
+
+	if (sec->qp->event_handler && sec->qp->qp_context) {
+		event.element.qp = sec->qp;
+		sec->qp->event_handler(&event,
+				       sec->qp->qp_context);
+	}
+
+	list_for_each_entry(shared_qp_sec,
+			    &sec->shared_qp_list,
+			    shared_qp_list) {
+		struct ib_qp *qp = shared_qp_sec->qp;
+
+		if (qp->event_handler && qp->qp_context) {
+			event.element.qp = qp;
+			event.device = qp->device;
+			qp->event_handler(&event,
+					  qp->qp_context);
+		}
+	}
+unlock:
+	mutex_unlock(&sec->mutex);
+}
+
+static inline void check_pkey_qps(struct pkey_index_qp_list *pkey,
+				  struct ib_device *device,
+				  u8 port_num,
+				  u64 subnet_prefix)
+{
+	struct ib_qp_security *shared_qp_sec;
+	struct ib_port_pkey *pp, *tmp_pp;
+	LIST_HEAD(reset_list);
+	u16 pkey_val;
+
+	if (!ib_get_cached_pkey(device,
+				port_num,
+				pkey->pkey_index,
+				&pkey_val)) {
+		spin_lock(&pkey->qp_list_lock);
+		list_for_each_entry(pp, &pkey->qp_list, qp_list) {
+			if (pp->sec->destroying)
+				continue;
+
+			if (security_qp_pkey_access(subnet_prefix,
+						    pkey_val,
+						    pp->sec)) {
+				list_add(&pp->reset_list,
+					 &reset_list);
+			} else {
+				list_for_each_entry(shared_qp_sec,
+						    &pp->sec->shared_qp_list,
+						    shared_qp_list) {
+					if (security_qp_pkey_access(subnet_prefix,
+								    pkey_val,
+								    shared_qp_sec)) {
+						list_add(&pp->reset_list,
+							 &reset_list);
+						break;
+					}
+				}
+			}
+		}
+		spin_unlock(&pkey->qp_list_lock);
+	}
+
+	list_for_each_entry_safe(pp,
+				 tmp_pp,
+				 &reset_list,
+				 reset_list) {
+		reset_qp(pp->sec);
+		list_del(&pp->reset_list);
+	}
+}
+
+static int port_pkey_list_insert(struct ib_port_pkey *pp,
+				 u8  port_num,
+				 u16 index)
+{
+	struct pkey_index_qp_list *pkey;
+	struct ib_device *device = pp->sec->dev;
+	int err = 0;
+
+	spin_lock(&device->port_pkey_list[port_num].list_lock);
+	pkey = get_pkey_index_qp_list(pp->sec->dev, port_num, index);
+	if (pkey)
+		goto list_qp;
+
+	pkey = kzalloc(sizeof(*pkey), GFP_ATOMIC);
+	if (!pkey) {
+		spin_unlock(&device->port_pkey_list[port_num].list_lock);
+		return -ENOMEM;
+	}
+
+	pkey->pkey_index = index;
+	spin_lock_init(&pkey->qp_list_lock);
+	INIT_LIST_HEAD(&pkey->qp_list);
+	list_add(&pkey->pkey_index_list,
+		 &device->port_pkey_list[port_num].pkey_list);
+
+list_qp:
+	spin_unlock(&device->port_pkey_list[port_num].list_lock);
+
+	spin_lock(&pkey->qp_list_lock);
+	list_add(&pp->qp_list, &pkey->qp_list);
+	spin_unlock(&pkey->qp_list_lock);
+
+	return err;
+}
+
+static int port_pkey_list_remove(struct ib_port_pkey *pp)
+{
+	struct pkey_index_qp_list *pkey;
+	int err = 0;
+
+	pkey = get_pkey_index_qp_list(pp->sec->dev,
+				      pp->port_num,
+				      pp->pkey_index);
+	if (!pkey)
+		return -ENOENT;
+
+	spin_lock(&pkey->qp_list_lock);
+	list_del(&pp->qp_list);
+	pp->state = IB_PORT_PKEY_NOT_VALID;
+	spin_unlock(&pkey->qp_list_lock);
+	return err;
+}
+
 static int check_pkey(const struct ib_qp *qp,
 		      const struct ib_qp_attr *qp_attr,
 		      int qp_attr_mask)
@@ -118,15 +304,23 @@ static int affects_security_settings(const struct ib_qp *qp,
 	       check_alt_pkey(qp, qp_attr, qp_attr_mask);
 }
 
-static void begin_port_pkey_change(struct ib_qp *qp,
-				   struct ib_port_pkey *pp,
-				   struct ib_port_pkey *old_pp,
-				   u8 port_num,
-				   u16 pkey_index)
+static int begin_port_pkey_change(struct ib_port_pkey *pp,
+				  struct ib_port_pkey *old_pp,
+				  u8 port_num,
+				  u16 pkey_index)
 {
+	int err;
+
 	if (pp->state == IB_PORT_PKEY_NOT_VALID ||
 	    (pkey_index != pp->pkey_index ||
 	     port_num != pp->port_num)) {
+		err = port_pkey_list_insert(pp,
+					    port_num,
+					    pkey_index);
+
+		if (err)
+			return err;
+
 		old_pp->pkey_index = pp->pkey_index;
 		old_pp->port_num = pp->port_num;
 		old_pp->state = pp->state;
@@ -135,6 +329,7 @@ static void begin_port_pkey_change(struct ib_qp *qp,
 		pp->pkey_index = pkey_index;
 		pp->state = IB_PORT_PKEY_CHANGING;
 	}
+	return 0;
 }
 
 static int qp_modify_enforce_security(struct ib_qp *qp,
@@ -161,11 +356,12 @@ static int qp_modify_enforce_security(struct ib_qp *qp,
 		if (err)
 			return err;
 
-		begin_port_pkey_change(qp,
-				       &sec->ports_pkeys.main,
-				       &sec->old_ports_pkeys.main,
-				       port_num,
-				       pkey_index);
+		err = begin_port_pkey_change(&sec->ports_pkeys.main,
+					     &sec->old_ports_pkeys.main,
+					     port_num,
+					     pkey_index);
+		if (err)
+			return err;
 	}
 
 	if (check_alt_pkey(qp, qp_attr, qp_attr_mask)) {
@@ -177,76 +373,123 @@ static int qp_modify_enforce_security(struct ib_qp *qp,
 		if (err)
 			return err;
 
-		begin_port_pkey_change(qp,
-				       &sec->ports_pkeys.alt,
-				       &sec->old_ports_pkeys.alt,
-				       qp_attr->alt_port_num,
-				       qp_attr->alt_pkey_index);
+		err = begin_port_pkey_change(&sec->ports_pkeys.alt,
+					     &sec->old_ports_pkeys.alt,
+					     qp_attr->alt_port_num,
+					     qp_attr->alt_pkey_index);
 	}
 	return err;
 }
 
-static void abort_port_pkey_change(struct ib_qp *qp,
-				   struct ib_port_pkey *pp,
+static void abort_port_pkey_change(struct ib_port_pkey *pp,
 				   struct ib_port_pkey *old_pp)
 {
 	if (pp->state == IB_PORT_PKEY_CHANGING) {
+		port_pkey_list_remove(pp);
+
 		pp->pkey_index = old_pp->pkey_index;
 		pp->port_num = old_pp->port_num;
 		pp->state = old_pp->state;
 	}
 }
 
+static void end_port_pkey_change(struct ib_port_pkey *pp,
+				 struct ib_port_pkey *old_pp)
+{
+	if (pp->state == IB_PORT_PKEY_CHANGING)
+		pp->state = IB_PORT_PKEY_VALID;
+
+	if (old_pp->state == IB_PORT_PKEY_VALID)
+		port_pkey_list_remove(old_pp);
+}
+
 static int cleanup_qp_pkey_associations(struct ib_qp *qp,
 					bool revert_to_old)
 {
-	struct ib_qp_security *sec = qp->qp_sec;
-
 	if (revert_to_old) {
-		abort_port_pkey_change(qp,
-				       &qp->qp_sec->ports_pkeys.main,
+		abort_port_pkey_change(&qp->qp_sec->ports_pkeys.main,
 				       &qp->qp_sec->old_ports_pkeys.main);
 
-		abort_port_pkey_change(qp,
-				       &qp->qp_sec->ports_pkeys.alt,
+		abort_port_pkey_change(&qp->qp_sec->ports_pkeys.alt,
 				       &qp->qp_sec->old_ports_pkeys.alt);
 	} else {
-		if (sec->ports_pkeys.main.state == IB_PORT_PKEY_CHANGING)
-			sec->ports_pkeys.main.state = IB_PORT_PKEY_VALID;
+		end_port_pkey_change(&qp->qp_sec->ports_pkeys.main,
+				     &qp->qp_sec->old_ports_pkeys.main);
 
-		if (sec->ports_pkeys.alt.state == IB_PORT_PKEY_CHANGING)
-			sec->ports_pkeys.alt.state = IB_PORT_PKEY_VALID;
+		end_port_pkey_change(&qp->qp_sec->ports_pkeys.alt,
+				     &qp->qp_sec->old_ports_pkeys.alt);
 	}
 
-	memset(&sec->old_ports_pkeys, 0, sizeof(sec->old_ports_pkeys));
-
 	return 0;
 }
 
-int ib_security_open_shared_qp(struct ib_qp *qp)
+static void destroy_qp_security(struct ib_qp_security *sec)
+{
+	security_ib_qp_free_security(sec);
+	kfree(sec);
+}
+
+static void qp_lists_lock_unlock(struct ib_qp_security *sec,
+				 bool lock)
+{
+	struct ib_port_pkey *prim = NULL;
+	struct ib_port_pkey *alt = NULL;
+	struct ib_port_pkey *first = NULL;
+	struct ib_port_pkey *second = NULL;
+	struct pkey_index_qp_list *pkey;
+
+	if (sec->ports_pkeys.main.state != IB_PORT_PKEY_NOT_VALID)
+		prim = &sec->ports_pkeys.main;
+
+	if (sec->ports_pkeys.alt.state != IB_PORT_PKEY_NOT_VALID)
+		alt = &sec->ports_pkeys.alt;
+
+	if (prim && alt) {
+		if (prim->port_num != alt->port_num) {
+			first = prim->port_num < alt->port_num ? prim : alt;
+			second = prim->port_num >= alt->port_num ? prim : alt;
+		} else {
+			first = prim->pkey_index < alt->pkey_index ?
+				prim : alt;
+			second = prim->pkey_index >= alt->pkey_index ?
+				alt : prim;
+		}
+	} else {
+		first = !prim ? alt : prim;
+	}
+
+	if (first) {
+		pkey = get_pkey_index_qp_list(sec->dev,
+					      first->port_num,
+					      first->pkey_index);
+		if (lock)
+			spin_lock(&pkey->qp_list_lock);
+		else
+			spin_unlock(&pkey->qp_list_lock);
+	}
+
+	if (second) {
+		pkey = get_pkey_index_qp_list(sec->dev,
+					      second->port_num,
+					      second->pkey_index);
+		if (lock)
+			spin_lock(&pkey->qp_list_lock);
+		else
+			spin_unlock(&pkey->qp_list_lock);
+	}
+}
+
+int ib_security_open_shared_qp(struct ib_qp *qp, struct ib_device *dev)
 {
 	struct ib_qp *real_qp = qp->real_qp;
 	int err;
 
-	err = ib_security_create_qp_security(qp);
+	err = ib_security_create_qp_security(qp, dev);
 	if (err)
 		goto out;
 
 	mutex_lock(&real_qp->qp_sec->mutex);
-
-	if (real_qp->qp_sec->ports_pkeys.main.state != IB_PORT_PKEY_NOT_VALID)
-		err = enforce_qp_pkey_security(real_qp->device,
-					       real_qp->qp_sec->ports_pkeys.main.port_num,
-					       real_qp->qp_sec->ports_pkeys.main.pkey_index,
-					       qp->qp_sec);
-	if (err)
-		goto err;
-
-	if (real_qp->qp_sec->ports_pkeys.alt.state != IB_PORT_PKEY_NOT_VALID)
-		err = enforce_qp_pkey_security(real_qp->device,
-					       real_qp->qp_sec->ports_pkeys.alt.port_num,
-					       real_qp->qp_sec->ports_pkeys.alt.pkey_index,
-					       qp->qp_sec);
+	err = check_qp_port_pkey_settings(qp->qp_sec);
 
 	if (err)
 		goto err;
@@ -257,7 +500,7 @@ int ib_security_open_shared_qp(struct ib_qp *qp)
 err:
 	mutex_unlock(&real_qp->qp_sec->mutex);
 	if (err)
-		ib_security_destroy_qp(qp->qp_sec);
+		destroy_qp_security(qp->qp_sec);
 
 out:
 	return err;
@@ -271,10 +514,10 @@ void ib_security_close_shared_qp(struct ib_qp_security *sec)
 	list_del(&sec->shared_qp_list);
 	mutex_unlock(&real_qp->qp_sec->mutex);
 
-	ib_security_destroy_qp(sec);
+	destroy_qp_security(sec);
 }
 
-int ib_security_create_qp_security(struct ib_qp *qp)
+int ib_security_create_qp_security(struct ib_qp *qp, struct ib_device *dev)
 {
 	int err;
 
@@ -283,6 +526,9 @@ int ib_security_create_qp_security(struct ib_qp *qp)
 		return -ENOMEM;
 
 	qp->qp_sec->qp = qp;
+	qp->qp_sec->dev = dev;
+	qp->qp_sec->ports_pkeys.main.sec = qp->qp_sec;
+	qp->qp_sec->ports_pkeys.alt.sec = qp->qp_sec;
 	mutex_init(&qp->qp_sec->mutex);
 	INIT_LIST_HEAD(&qp->qp_sec->shared_qp_list);
 	err = security_ib_qp_alloc_security(qp->qp_sec);
@@ -293,10 +539,86 @@ int ib_security_create_qp_security(struct ib_qp *qp)
 }
 EXPORT_SYMBOL(ib_security_create_qp_security);
 
-void ib_security_destroy_qp(struct ib_qp_security *sec)
+void ib_security_destroy_qp_end(struct ib_qp_security *sec)
 {
-	security_ib_qp_free_security(sec);
-	kfree(sec);
+	mutex_lock(&sec->mutex);
+	if (sec->ports_pkeys.main.state != IB_PORT_PKEY_NOT_VALID)
+		port_pkey_list_remove(&sec->ports_pkeys.main);
+
+	if (sec->ports_pkeys.alt.state != IB_PORT_PKEY_NOT_VALID)
+		port_pkey_list_remove(&sec->ports_pkeys.alt);
+
+	memset(&sec->ports_pkeys, 0, sizeof(sec->ports_pkeys));
+	mutex_unlock(&sec->mutex);
+	destroy_qp_security(sec);
+}
+
+void ib_security_destroy_qp_abort(struct ib_qp_security *sec)
+{
+	int err;
+
+	mutex_lock(&sec->mutex);
+	qp_lists_lock_unlock(sec, true);
+	err = check_qp_port_pkey_settings(sec);
+	if (err)
+		reset_qp(sec);
+	sec->destroying = false;
+	qp_lists_lock_unlock(sec, false);
+	mutex_unlock(&sec->mutex);
+}
+
+void ib_security_destroy_qp_begin(struct ib_qp_security *sec)
+{
+	mutex_lock(&sec->mutex);
+	qp_lists_lock_unlock(sec, true);
+	sec->destroying = true;
+	qp_lists_lock_unlock(sec, false);
+	mutex_unlock(&sec->mutex);
+}
+
+void ib_security_cache_change(struct ib_device *device,
+			      u8 port_num,
+			      u64 subnet_prefix)
+{
+	struct pkey_index_qp_list *pkey;
+
+	list_for_each_entry(pkey,
+			    &device->port_pkey_list[port_num].pkey_list,
+			    pkey_index_list) {
+		check_pkey_qps(pkey,
+			       device,
+			       port_num,
+			       subnet_prefix);
+	}
+}
+
+void ib_security_destroy_port_pkey_list(struct ib_device *device)
+{
+	struct pkey_index_qp_list *pkey, *tmp_pkey;
+	struct ib_port_pkey *pp, *tmp_pp;
+	int i;
+
+	for (i = rdma_start_port(device); i <= rdma_end_port(device); i++) {
+		spin_lock(&device->port_pkey_list[i].list_lock);
+		list_for_each_entry_safe(pkey,
+					 tmp_pkey,
+					 &device->port_pkey_list[i].pkey_list,
+					 pkey_index_list) {
+			spin_lock(&pkey->qp_list_lock);
+			list_for_each_entry_safe(pp,
+						 tmp_pp,
+						 &pkey->qp_list,
+						 qp_list) {
+				if (pp->state != IB_PORT_PKEY_NOT_VALID)
+					list_del(&pp->qp_list);
+			}
+			spin_unlock(&pkey->qp_list_lock);
+
+			list_del(&pkey->pkey_index_list);
+			kfree(pkey);
+		}
+		spin_unlock(&device->port_pkey_list[i].list_lock);
+	}
 }
 
 int ib_security_modify_qp(struct ib_qp *qp,
@@ -311,7 +633,6 @@ int ib_security_modify_qp(struct ib_qp *qp,
 
 	if (enforce_security) {
 		mutex_lock(&qp->qp_sec->mutex);
-
 		err = qp_modify_enforce_security(qp, qp_attr, qp_attr_mask);
 	}
 
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 1097984..f39a2a1 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -311,6 +311,30 @@ static int read_port_immutable(struct ib_device *device)
 	return 0;
 }
 
+static int setup_port_pkey_list(struct ib_device *device)
+{
+	int i;
+
+	/**
+	 * device->port_pkey_list is indexed directly by the port number,
+	 * Therefore it is declared as a 1 based array with potential empty
+	 * slots at the beginning.
+	 */
+	device->port_pkey_list = kzalloc(sizeof(*device->port_pkey_list)
+					 * (rdma_end_port(device) + 1),
+					 GFP_KERNEL);
+
+	if (!device->port_pkey_list)
+		return -ENOMEM;
+
+	for (i = 0; i < (rdma_end_port(device) + 1); i++) {
+		spin_lock_init(&device->port_pkey_list[i].list_lock);
+		INIT_LIST_HEAD(&device->port_pkey_list[i].pkey_list);
+	}
+
+	return 0;
+}
+
 /**
  * ib_register_device - Register an IB device with IB core
  * @device:Device to register
@@ -348,6 +372,12 @@ int ib_register_device(struct ib_device *device,
 		goto out;
 	}
 
+	ret = setup_port_pkey_list(device);
+	if (ret) {
+		dev_warn(device->dma_device, "Couldn't create per port_pkey_list\n");
+		goto out;
+	}
+
 	ret = ib_cache_setup_one(device);
 	if (ret) {
 		pr_warn("Couldn't set up InfiniBand P_Key/GID cache\n");
@@ -418,6 +448,9 @@ void ib_unregister_device(struct ib_device *device)
 	ib_device_unregister_sysfs(device);
 	ib_cache_cleanup_one(device);
 
+	ib_security_destroy_port_pkey_list(device);
+	kfree(device->port_pkey_list);
+
 	down_write(&lists_rwsem);
 	spin_lock_irqsave(&device->client_data_lock, flags);
 	list_for_each_entry_safe(context, tmp, &device->client_data_list, list)
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 6df15ea..a887129 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1857,7 +1857,7 @@ static int create_qp(struct ib_uverbs_file *file,
 	}
 
 	if (cmd->qp_type != IB_QPT_XRC_TGT) {
-		ret = ib_security_create_qp_security(qp);
+		ret = ib_security_create_qp_security(qp, device);
 		if (ret)
 			goto err_destroy;
 
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 47000ee..dddb2b7 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -688,13 +688,13 @@ static struct ib_qp *__ib_open_qp(struct ib_qp *real_qp,
 	if (!qp)
 		return ERR_PTR(-ENOMEM);
 
-	qp->real_qp = real_qp;
-	err = ib_security_open_shared_qp(qp);
+	err = ib_security_open_shared_qp(qp, real_qp->device);
 	if (err) {
 		kfree(qp);
 		return ERR_PTR(err);
 	}
 
+	qp->real_qp = real_qp;
 	atomic_inc(&real_qp->usecnt);
 	qp->device = real_qp->device;
 	qp->event_handler = event_handler;
@@ -742,7 +742,7 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
 	qp = device->create_qp(pd, qp_init_attr, NULL);
 
 	if (!IS_ERR(qp)) {
-		err = ib_security_create_qp_security(qp);
+		err = ib_security_create_qp_security(qp, device);
 		if (err)
 			goto destroy_qp;
 
@@ -1280,6 +1280,8 @@ int ib_destroy_qp(struct ib_qp *qp)
 	rcq  = qp->recv_cq;
 	srq  = qp->srq;
 	sec  = qp->qp_sec;
+	if (sec)
+		ib_security_destroy_qp_begin(sec);
 
 	ret = qp->device->destroy_qp(qp);
 	if (!ret) {
@@ -1292,7 +1294,10 @@ int ib_destroy_qp(struct ib_qp *qp)
 		if (srq)
 			atomic_dec(&srq->usecnt);
 		if (sec)
-			ib_security_destroy_qp(sec);
+			ib_security_destroy_qp_end(sec);
+	} else {
+		if (sec)
+			ib_security_destroy_qp_abort(sec);
 	}
 
 	return ret;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index f71cb47..77d6158 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1422,10 +1422,15 @@ enum port_pkey_state {
 	IB_PORT_PKEY_CHANGING = 2,
 };
 
+struct ib_qp_security;
+
 struct ib_port_pkey {
 	enum port_pkey_state	state;
 	u16			pkey_index;
 	u8			port_num;
+	struct list_head	qp_list;
+	struct list_head	reset_list;
+	struct ib_qp_security  *sec;
 };
 
 struct ib_ports_pkeys {
@@ -1435,6 +1440,7 @@ struct ib_ports_pkeys {
 
 struct ib_qp_security {
 	struct ib_qp	       *qp;
+	struct ib_device       *dev;
 	/* Hold this mutex when changing port and pkey settings. */
 	struct mutex		mutex;
 	struct ib_ports_pkeys	ports_pkeys;
@@ -1444,6 +1450,7 @@ struct ib_qp_security {
 	 */
 	struct list_head        shared_qp_list;
 	void                   *q_security;
+	bool			destroying;
 };
 
 struct ib_qp {
@@ -1693,6 +1700,12 @@ struct ib_port_immutable {
 	u32                           max_mad_size;
 };
 
+struct ib_port_pkey_list {
+	/* Lock to hold while modifying the list. */
+	spinlock_t		      list_lock;
+	struct list_head	      pkey_list;
+};
+
 struct ib_device {
 	struct device                *dma_device;
 
@@ -1715,6 +1728,8 @@ struct ib_device {
 
 	int			      num_comp_vectors;
 
+	struct ib_port_pkey_list     *port_pkey_list;
+
 	struct iw_cm_verbs	     *iwcm;
 
 	int		           (*get_protocol_stats)(struct ib_device *device,
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
