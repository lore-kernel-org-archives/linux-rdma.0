From: Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC PATCH v2 09/13] ib/core: Enforce PKey security when modifying QPs
Date: Thu,  7 Apr 2016 02:33:54 +0300
Message-ID: <1459985638-37233-10-git-send-email-danielj@mellanox.com>
References: <1459985638-37233-1-git-send-email-danielj@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1459985638-37233-1-git-send-email-danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Allocate and free a security context when creating and destroying a QP.
This context is used for controlling access to PKeys.

When a request is made to modify a QP that changes the port, PKey index,
alternate path port, or alternate path PKey index, check that the QP has
permission for the PKey in the index on the subnet prefix of the port.
If the QP is shared make sure all handles to the QP also have access.

Store which port and pkey a QP is using.  After the reset to init
transition the user can modify the port and pkey independently.  This
adds a transactional aspect to modify QP when the port, pkey, or
alternate path change.  Permission must be checked for the new settings,
then the modify can be attempted.  If the modify fails the old setting
should be restored.

To keep the security changes isolated a new file is used to hold security
related functionality.

Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/Makefile        |    2 +-
 drivers/infiniband/core/core_priv.h     |   41 ++++
 drivers/infiniband/core/core_security.c |  331 +++++++++++++++++++++++++++++++
 drivers/infiniband/core/uverbs_cmd.c    |   20 ++-
 drivers/infiniband/core/verbs.c         |   24 +++-
 include/rdma/ib_verbs.h                 |   28 +++-
 6 files changed, 439 insertions(+), 7 deletions(-)
 create mode 100644 drivers/infiniband/core/core_security.c

diff --git a/drivers/infiniband/core/Makefile b/drivers/infiniband/core/Makefile
index f818538..48a4013 100644
--- a/drivers/infiniband/core/Makefile
+++ b/drivers/infiniband/core/Makefile
@@ -10,7 +10,7 @@ obj-$(CONFIG_INFINIBAND_USER_ACCESS) +=	ib_uverbs.o ib_ucm.o \
 
 ib_core-y :=			packer.o ud_header.o verbs.o cq.o sysfs.o \
 				device.o fmr_pool.o cache.o netlink.o \
-				roce_gid_mgmt.o
+				roce_gid_mgmt.o core_security.o
 ib_core-$(CONFIG_INFINIBAND_USER_MEM) += umem.o
 ib_core-$(CONFIG_INFINIBAND_ON_DEMAND_PAGING) += umem_odp.o umem_rbtree.o
 
diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index 722b866..27f2fa8 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -140,4 +140,45 @@ static inline bool rdma_is_upper_dev_rcu(struct net_device *dev,
 int ib_get_cached_subnet_prefix(struct ib_device *device,
 				u8                port_num,
 				u64              *sn_pfx);
+
+#ifdef CONFIG_SECURITY_INFINIBAND
+int ib_security_modify_qp(struct ib_qp *qp,
+			  struct ib_qp_attr *qp_attr,
+			  int qp_attr_mask,
+			  struct ib_udata *udata);
+
+int ib_security_create_qp_security(struct ib_qp *qp);
+void ib_security_destroy_qp(struct ib_qp_security *sec);
+int ib_security_open_shared_qp(struct ib_qp *qp);
+void ib_security_close_shared_qp(struct ib_qp_security *sec);
+#else
+static inline int ib_security_modify_qp(struct ib_qp *qp,
+					struct ib_qp_attr *qp_attr,
+					int qp_attr_mask,
+					struct ib_udata *udata)
+{
+	return qp->device->modify_qp(qp->real_qp,
+				     qp_attr,
+				     qp_attr_mask,
+				     udata);
+}
+
+static inline int ib_security_create_qp_security(struct ib_qp *qp)
+{
+	return 0;
+}
+
+static inline void ib_security_destroy_qp(struct ib_qp_security *sec)
+{
+}
+
+static inline int ib_security_open_shared_qp(struct ib_qp *qp)
+{
+	return 0;
+}
+
+static inline void ib_security_close_shared_qp(struct ib_qp_security *sec)
+{
+}
+#endif
 #endif /* _CORE_PRIV_H */
diff --git a/drivers/infiniband/core/core_security.c b/drivers/infiniband/core/core_security.c
new file mode 100644
index 0000000..768edea
--- /dev/null
+++ b/drivers/infiniband/core/core_security.c
@@ -0,0 +1,331 @@
+/*
+ * Copyright (c) 2016 Mellanox Technologies Ltd.  All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#ifdef CONFIG_SECURITY_INFINIBAND
+
+#include <linux/security.h>
+
+#include <rdma/ib_verbs.h>
+#include <rdma/ib_cache.h>
+#include "core_priv.h"
+
+static int get_pkey_info(struct ib_device *dev,
+			 u8 port_num,
+			 u16 pkey_index,
+			 u64 *subnet_prefix,
+			 u16 *pkey)
+{
+	int err;
+
+	err = ib_get_cached_pkey(dev, port_num, pkey_index, pkey);
+	if (err)
+		return err;
+
+	err = ib_get_cached_subnet_prefix(dev, port_num, subnet_prefix);
+
+	return err;
+}
+
+static int enforce_qp_pkey_security(struct ib_device *dev,
+				    u8 port_num,
+				    u16 pkey_index,
+				    struct ib_qp_security *sec)
+{
+	struct ib_qp_security *shared_qp_sec;
+	u64 subnet_prefix;
+	int err = 0;
+	u16 pkey;
+
+	err = get_pkey_info(dev, port_num, pkey_index, &subnet_prefix, &pkey);
+	if (err)
+		return err;
+
+	err = security_qp_pkey_access(subnet_prefix, pkey, sec);
+	if (err)
+		return err;
+
+	if (sec->qp == sec->qp->real_qp) {
+		/* The caller of this function holds the QP security
+		 * mutex so this list traversal is safe
+		*/
+		list_for_each_entry(shared_qp_sec,
+				    &sec->shared_qp_list,
+				    shared_qp_list) {
+			err = security_qp_pkey_access(subnet_prefix,
+						      pkey,
+						      shared_qp_sec);
+			if (err)
+				break;
+		}
+	}
+	return err;
+}
+
+static int check_pkey(const struct ib_qp *qp,
+		      const struct ib_qp_attr *qp_attr,
+		      int qp_attr_mask)
+{
+	bool check_pkey = !!(qp_attr_mask & (IB_QP_PKEY_INDEX | IB_QP_PORT));
+
+	return check_pkey && (qp->qp_num != IB_QPT_SMI &&
+			      qp->qp_num != IB_QPT_GSI);
+}
+
+static int check_alt_pkey(const struct ib_qp *qp,
+			  const struct ib_qp_attr *qp_attr,
+			  int qp_attr_mask)
+{
+	bool check_alt_pkey = !!(qp_attr_mask & IB_QP_ALT_PATH);
+
+	return check_alt_pkey && (qp->qp_num != IB_QPT_SMI &&
+				  qp->qp_num != IB_QPT_GSI);
+}
+
+static int affects_security_settings(const struct ib_qp *qp,
+				     const struct ib_qp_attr *qp_attr,
+				     int qp_attr_mask)
+{
+	return check_pkey(qp, qp_attr, qp_attr_mask) ||
+	       check_alt_pkey(qp, qp_attr, qp_attr_mask);
+}
+
+static void begin_port_pkey_change(struct ib_qp *qp,
+				   struct ib_port_pkey *pp,
+				   struct ib_port_pkey *old_pp,
+				   u8 port_num,
+				   u16 pkey_index)
+{
+	if (pp->state == IB_PORT_PKEY_NOT_VALID ||
+	    (pkey_index != pp->pkey_index ||
+	     port_num != pp->port_num)) {
+		old_pp->pkey_index = pp->pkey_index;
+		old_pp->port_num = pp->port_num;
+		old_pp->state = pp->state;
+
+		pp->port_num = port_num;
+		pp->pkey_index = pkey_index;
+		pp->state = IB_PORT_PKEY_CHANGING;
+	}
+}
+
+static int qp_modify_enforce_security(struct ib_qp *qp,
+				      const struct ib_qp_attr *qp_attr,
+				      int qp_attr_mask)
+{
+	struct ib_qp_security *sec = qp->qp_sec;
+	int err = 0;
+
+	if (check_pkey(qp, qp_attr, qp_attr_mask)) {
+		u8 port_num = (qp_attr_mask & IB_QP_PORT) ?
+			       qp_attr->port_num :
+			       sec->ports_pkeys.main.port_num;
+
+		u16 pkey_index = (qp_attr_mask & IB_QP_PKEY_INDEX) ?
+				  qp_attr->pkey_index :
+				  sec->ports_pkeys.main.pkey_index;
+
+		err = enforce_qp_pkey_security(qp->device,
+					       port_num,
+					       pkey_index,
+					       sec);
+
+		if (err)
+			return err;
+
+		begin_port_pkey_change(qp,
+				       &sec->ports_pkeys.main,
+				       &sec->old_ports_pkeys.main,
+				       port_num,
+				       pkey_index);
+	}
+
+	if (check_alt_pkey(qp, qp_attr, qp_attr_mask)) {
+		err = enforce_qp_pkey_security(qp->device,
+					       qp_attr->alt_port_num,
+					       qp_attr->alt_pkey_index,
+					       sec);
+
+		if (err)
+			return err;
+
+		begin_port_pkey_change(qp,
+				       &sec->ports_pkeys.alt,
+				       &sec->old_ports_pkeys.alt,
+				       qp_attr->alt_port_num,
+				       qp_attr->alt_pkey_index);
+	}
+	return err;
+}
+
+static void abort_port_pkey_change(struct ib_qp *qp,
+				   struct ib_port_pkey *pp,
+				   struct ib_port_pkey *old_pp)
+{
+	if (pp->state == IB_PORT_PKEY_CHANGING) {
+		pp->pkey_index = old_pp->pkey_index;
+		pp->port_num = old_pp->port_num;
+		pp->state = old_pp->state;
+	}
+}
+
+static int cleanup_qp_pkey_associations(struct ib_qp *qp,
+					bool revert_to_old)
+{
+	struct ib_qp_security *sec = qp->qp_sec;
+
+	if (revert_to_old) {
+		abort_port_pkey_change(qp,
+				       &qp->qp_sec->ports_pkeys.main,
+				       &qp->qp_sec->old_ports_pkeys.main);
+
+		abort_port_pkey_change(qp,
+				       &qp->qp_sec->ports_pkeys.alt,
+				       &qp->qp_sec->old_ports_pkeys.alt);
+	} else {
+		if (sec->ports_pkeys.main.state == IB_PORT_PKEY_CHANGING)
+			sec->ports_pkeys.main.state = IB_PORT_PKEY_VALID;
+
+		if (sec->ports_pkeys.alt.state == IB_PORT_PKEY_CHANGING)
+			sec->ports_pkeys.alt.state = IB_PORT_PKEY_VALID;
+	}
+
+	memset(&sec->old_ports_pkeys, 0, sizeof(sec->old_ports_pkeys));
+
+	return 0;
+}
+
+int ib_security_open_shared_qp(struct ib_qp *qp)
+{
+	struct ib_qp *real_qp = qp->real_qp;
+	int err;
+
+	err = ib_security_create_qp_security(qp);
+	if (err)
+		goto out;
+
+	mutex_lock(&real_qp->qp_sec->mutex);
+
+	if (real_qp->qp_sec->ports_pkeys.main.state != IB_PORT_PKEY_NOT_VALID)
+		err = enforce_qp_pkey_security(real_qp->device,
+					       real_qp->qp_sec->ports_pkeys.main.port_num,
+					       real_qp->qp_sec->ports_pkeys.main.pkey_index,
+					       qp->qp_sec);
+	if (err)
+		goto err;
+
+	if (real_qp->qp_sec->ports_pkeys.alt.state != IB_PORT_PKEY_NOT_VALID)
+		err = enforce_qp_pkey_security(real_qp->device,
+					       real_qp->qp_sec->ports_pkeys.alt.port_num,
+					       real_qp->qp_sec->ports_pkeys.alt.pkey_index,
+					       qp->qp_sec);
+
+	if (err)
+		goto err;
+
+	if (qp != real_qp)
+		list_add(&qp->qp_sec->shared_qp_list,
+			 &real_qp->qp_sec->shared_qp_list);
+err:
+	mutex_unlock(&real_qp->qp_sec->mutex);
+	if (err)
+		ib_security_destroy_qp(qp->qp_sec);
+
+out:
+	return err;
+}
+
+void ib_security_close_shared_qp(struct ib_qp_security *sec)
+{
+	struct ib_qp *real_qp = sec->qp->real_qp;
+
+	mutex_lock(&real_qp->qp_sec->mutex);
+	list_del(&sec->shared_qp_list);
+	mutex_unlock(&real_qp->qp_sec->mutex);
+
+	ib_security_destroy_qp(sec);
+}
+
+int ib_security_create_qp_security(struct ib_qp *qp)
+{
+	int err;
+
+	qp->qp_sec = kzalloc(sizeof(*qp->qp_sec), GFP_KERNEL);
+	if (!qp->qp_sec)
+		return -ENOMEM;
+
+	qp->qp_sec->qp = qp;
+	mutex_init(&qp->qp_sec->mutex);
+	INIT_LIST_HEAD(&qp->qp_sec->shared_qp_list);
+	err = security_ib_qp_alloc_security(qp->qp_sec);
+	if (err)
+		kfree(qp->qp_sec);
+
+	return err;
+}
+EXPORT_SYMBOL(ib_security_create_qp_security);
+
+void ib_security_destroy_qp(struct ib_qp_security *sec)
+{
+	security_ib_qp_free_security(sec);
+	kfree(sec);
+}
+
+int ib_security_modify_qp(struct ib_qp *qp,
+			  struct ib_qp_attr *qp_attr,
+			  int qp_attr_mask,
+			  struct ib_udata *udata)
+{
+	int err = 0;
+	bool enforce_security = affects_security_settings(qp,
+							  qp_attr,
+							  qp_attr_mask);
+
+	if (enforce_security) {
+		mutex_lock(&qp->qp_sec->mutex);
+
+		err = qp_modify_enforce_security(qp, qp_attr, qp_attr_mask);
+	}
+
+	if (!err)
+		err = qp->device->modify_qp(qp->real_qp,
+					    qp_attr,
+					    qp_attr_mask,
+					    udata);
+	if (enforce_security) {
+		cleanup_qp_pkey_associations(qp, !!err);
+		mutex_unlock(&qp->qp_sec->mutex);
+	}
+	return err;
+}
+EXPORT_SYMBOL(ib_security_modify_qp);
+
+#endif /* CONFIG_SECURITY_INFINIBAND */
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 6fdc7ec..6df15ea 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -37,7 +37,7 @@
 #include <linux/fs.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
-
+#include <linux/security.h>
 #include <asm/uaccess.h>
 
 #include "uverbs.h"
@@ -1857,6 +1857,10 @@ static int create_qp(struct ib_uverbs_file *file,
 	}
 
 	if (cmd->qp_type != IB_QPT_XRC_TGT) {
+		ret = ib_security_create_qp_security(qp);
+		if (ret)
+			goto err_destroy;
+
 		qp->real_qp	  = qp;
 		qp->device	  = device;
 		qp->pd		  = pd;
@@ -2339,10 +2343,18 @@ ssize_t ib_uverbs_modify_qp(struct ib_uverbs_file *file,
 		ret = ib_resolve_eth_dmac(qp, attr, &cmd.attr_mask);
 		if (ret)
 			goto release_qp;
-		ret = qp->device->modify_qp(qp, attr,
-			modify_qp_mask(qp->qp_type, cmd.attr_mask), &udata);
+
+		ret = ib_security_modify_qp(qp,
+					    attr,
+					    modify_qp_mask(qp->qp_type,
+							   cmd.attr_mask),
+					    &udata);
 	} else {
-		ret = ib_modify_qp(qp, attr, modify_qp_mask(qp->qp_type, cmd.attr_mask));
+		ret = ib_security_modify_qp(qp,
+					    attr,
+					    modify_qp_mask(qp->qp_type,
+							   cmd.attr_mask),
+					    NULL);
 	}
 
 	if (ret)
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 15b8adb..47000ee 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -44,6 +44,7 @@
 #include <linux/in.h>
 #include <linux/in6.h>
 #include <net/addrconf.h>
+#include <linux/security.h>
 
 #include <rdma/ib_verbs.h>
 #include <rdma/ib_cache.h>
@@ -681,12 +682,19 @@ static struct ib_qp *__ib_open_qp(struct ib_qp *real_qp,
 {
 	struct ib_qp *qp;
 	unsigned long flags;
+	int err;
 
 	qp = kzalloc(sizeof *qp, GFP_KERNEL);
 	if (!qp)
 		return ERR_PTR(-ENOMEM);
 
 	qp->real_qp = real_qp;
+	err = ib_security_open_shared_qp(qp);
+	if (err) {
+		kfree(qp);
+		return ERR_PTR(err);
+	}
+
 	atomic_inc(&real_qp->usecnt);
 	qp->device = real_qp->device;
 	qp->event_handler = event_handler;
@@ -728,11 +736,16 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
 {
 	struct ib_qp *qp, *real_qp;
 	struct ib_device *device;
+	int err;
 
 	device = pd ? pd->device : qp_init_attr->xrcd->device;
 	qp = device->create_qp(pd, qp_init_attr, NULL);
 
 	if (!IS_ERR(qp)) {
+		err = ib_security_create_qp_security(qp);
+		if (err)
+			goto destroy_qp;
+
 		qp->device     = device;
 		qp->real_qp    = qp;
 		qp->uobject    = NULL;
@@ -780,6 +793,10 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
 	}
 
 	return qp;
+
+destroy_qp:
+	ib_destroy_qp(qp);
+	return ERR_PTR(err);
 }
 EXPORT_SYMBOL(ib_create_qp);
 
@@ -1180,7 +1197,7 @@ int ib_modify_qp(struct ib_qp *qp,
 	if (ret)
 		return ret;
 
-	return qp->device->modify_qp(qp->real_qp, qp_attr, qp_attr_mask, NULL);
+	return ib_security_modify_qp(qp->real_qp, qp_attr, qp_attr_mask, NULL);
 }
 EXPORT_SYMBOL(ib_modify_qp);
 
@@ -1209,6 +1226,7 @@ int ib_close_qp(struct ib_qp *qp)
 	spin_unlock_irqrestore(&real_qp->device->event_handler_lock, flags);
 
 	atomic_dec(&real_qp->usecnt);
+	ib_security_close_shared_qp(qp->qp_sec);
 	kfree(qp);
 
 	return 0;
@@ -1248,6 +1266,7 @@ int ib_destroy_qp(struct ib_qp *qp)
 	struct ib_pd *pd;
 	struct ib_cq *scq, *rcq;
 	struct ib_srq *srq;
+	struct ib_qp_security *sec;
 	int ret;
 
 	if (atomic_read(&qp->usecnt))
@@ -1260,6 +1279,7 @@ int ib_destroy_qp(struct ib_qp *qp)
 	scq  = qp->send_cq;
 	rcq  = qp->recv_cq;
 	srq  = qp->srq;
+	sec  = qp->qp_sec;
 
 	ret = qp->device->destroy_qp(qp);
 	if (!ret) {
@@ -1271,6 +1291,8 @@ int ib_destroy_qp(struct ib_qp *qp)
 			atomic_dec(&rcq->usecnt);
 		if (srq)
 			atomic_dec(&srq->usecnt);
+		if (sec)
+			ib_security_destroy_qp(sec);
 	}
 
 	return ret;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 870c5ac..f71cb47 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1416,8 +1416,34 @@ struct ib_srq {
 	} ext;
 };
 
+enum port_pkey_state {
+	IB_PORT_PKEY_NOT_VALID = 0,
+	IB_PORT_PKEY_VALID = 1,
+	IB_PORT_PKEY_CHANGING = 2,
+};
+
+struct ib_port_pkey {
+	enum port_pkey_state	state;
+	u16			pkey_index;
+	u8			port_num;
+};
+
+struct ib_ports_pkeys {
+	struct ib_port_pkey	main;
+	struct ib_port_pkey	alt;
+};
+
 struct ib_qp_security {
-	void *q_security;
+	struct ib_qp	       *qp;
+	/* Hold this mutex when changing port and pkey settings. */
+	struct mutex		mutex;
+	struct ib_ports_pkeys	ports_pkeys;
+	struct ib_ports_pkeys	old_ports_pkeys;
+	/* A list of all open shared QP handles.  Required to enforce security
+	 * properly for all users of a shared QP.
+	 */
+	struct list_head        shared_qp_list;
+	void                   *q_security;
 };
 
 struct ib_qp {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
