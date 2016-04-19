From: Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC PATCH v3 09/12] ib/core: Enforce PKey security on QPs
Date: Tue, 19 Apr 2016 22:51:26 +0300
Message-ID: <1461095489-18732-10-git-send-email-danielj@mellanox.com>
References: <1461095489-18732-1-git-send-email-danielj@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1461095489-18732-1-git-send-email-danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Allocate and free a security context when creating and destroying a QP.
This context is used for controlling access to PKeys.

When a request is made to modify a QP that changes the port, PKey index,
or alternate path, check that the QP has permission for the PKey in the
PKey table index on the subnet prefix of the port. If the QP is shared
make sure all handles to the QP also have access.

Store which port and PKey index a QP is using.  After the reset to init
transition the user can modify the port, PKey index and alternate path
independently. So port and PKey settings changes can be a merge of the
previous settings and the new ones.

In order to maintain access control if there are PKey table or subnet
prefix change  keep a list of all QPs are using each PKey index on
each port  If a change occurs all QPs using that device and port must
have access enforced for the new cache settings.

These changes add a transaction to the QP modify process.  Association
with the old port and PKey index must be maintained if the modify fails,
and must be removed if it succeeds.  Association with the new port and
PKey index must be established prior to the modify and removed if the
modify fails.

1. When a QP is modified to a particular Port, PKey index or alternate
   path insert that QP into the appropriate lists.

2. Check permission to access the new settings.

3. If step 2 grants access attempt to modify the QP.

4a. If steps 2 and 3 succeed remove any prior associations.

4b. If ether fails remove the new setting associations.

If a PKey table or subnet prefix changes walk the list of QPs and
check that they have permission.  If not send the QP to the error state
and raise a fatal error event.  If it's a shared QP make sure all the
QPs that share the real_qp have permission as well. If the QP that
owns a security structure is denied access the security structure is
marked as such and the QP is added to an error_list. Once the moving
the QP to error is complete the security structure mark is cleared.

Maintaining the lists correctly turns QP destroy into a transaction.
The hardware driver for the device frees the ib_qp structure, so while
the destroy is in progress the ib_qp pointer in the ib_qp_security
struct is undefined.  When the destroy process begins the ib_qp_security
structure is marked as destroying.  This prevents any action from being
taken on the QP pointer.   After the QP is destroyed successfully it
could still listed on an error_list wait for it to be processed by that
flow before cleaning up the structure.

If the destroy fails the QPs port and PKey settings are reinserted into
the appropriate lists, the destroying flag is cleared, and access control
is enforced, in case there were any cache changes during the destroy
flow.

To keep the security changes isolated a new file is used to hold security
related functionality.

Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

---
v2: Added patch to series

v3:
1. Squashed "ib/core: Track which QPs are using which port and PKey
index" into "ib/core: Enforce PKey security when modifying QPs". The are
tightly coupled, making review each difficult.

Comments from "ib/core: Track ..."
2. Renamed destroy functions to ib_destroy_qp_security_x in the style of
ib_create_qp_security change from "ib/core: Enforce PKey security when
modifying QPs".  Leon

3. Remove junk from copyright block.  Leon

Comments from "ib/core: Enforce ..."
4. Fixed comparison between qp->qp_num and IB_QPT_X. Leon

5. Renamed ib_security_create_qp_security to ib_create_qp_security.
Changed open/close shared qp and destroys to postpend _security as
well. Leon

6. Renamed core_security.c to security.c. Leon

Other changes:
7. Refactored the QP modify path to flatten the call graph and hopefully
make the locking clearer. Leon

8. Added more comments to clarify locking.

9. Closed a race condition between destroying a QP and sending it to
error during a cache change.

10. Changed call to security_qp_pkey_access to security_ib_qp_pkey_access
due to name change.
---
 drivers/infiniband/core/Makefile     |    2 +-
 drivers/infiniband/core/cache.c      |   21 +-
 drivers/infiniband/core/core_priv.h  |   77 +++++
 drivers/infiniband/core/device.c     |   33 ++
 drivers/infiniband/core/security.c   |  617 ++++++++++++++++++++++++++++++++++
 drivers/infiniband/core/uverbs_cmd.c |   20 +-
 drivers/infiniband/core/verbs.c      |   30 ++-
 include/rdma/ib_verbs.h              |   45 +++-
 8 files changed, 835 insertions(+), 10 deletions(-)
 create mode 100644 drivers/infiniband/core/security.c

diff --git a/drivers/infiniband/core/Makefile b/drivers/infiniband/core/Makefile
index f818538..6101680 100644
--- a/drivers/infiniband/core/Makefile
+++ b/drivers/infiniband/core/Makefile
@@ -10,7 +10,7 @@ obj-$(CONFIG_INFINIBAND_USER_ACCESS) +=	ib_uverbs.o ib_ucm.o \
 
 ib_core-y :=			packer.o ud_header.o verbs.o cq.o sysfs.o \
 				device.o fmr_pool.o cache.o netlink.o \
-				roce_gid_mgmt.o
+				roce_gid_mgmt.o security.o
 ib_core-$(CONFIG_INFINIBAND_USER_MEM) += umem.o
 ib_core-$(CONFIG_INFINIBAND_ON_DEMAND_PAGING) += umem_odp.o umem_rbtree.o
 
diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index f1d602f..61998e4 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -53,6 +53,7 @@ struct ib_update_work {
 	struct work_struct work;
 	struct ib_device  *device;
 	u8                 port_num;
+	bool		   enforce_security;
 };
 
 union ib_gid zgid;
@@ -1036,7 +1037,8 @@ int ib_get_cached_lmc(struct ib_device *device,
 EXPORT_SYMBOL(ib_get_cached_lmc);
 
 static void ib_cache_update(struct ib_device *device,
-			    u8                port)
+			    u8                port,
+			    bool	      enforce_security)
 {
 	struct ib_port_attr       *tprops = NULL;
 	struct ib_pkey_cache      *pkey_cache = NULL, *old_pkey_cache;
@@ -1124,6 +1126,11 @@ static void ib_cache_update(struct ib_device *device,
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
@@ -1140,7 +1147,9 @@ static void ib_cache_task(struct work_struct *_work)
 	struct ib_update_work *work =
 		container_of(_work, struct ib_update_work, work);
 
-	ib_cache_update(work->device, work->port_num);
+	ib_cache_update(work->device,
+			work->port_num,
+			work->enforce_security);
 	kfree(work);
 }
 
@@ -1161,6 +1170,12 @@ static void ib_cache_event(struct ib_event_handler *handler,
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
@@ -1201,7 +1216,7 @@ int ib_cache_setup_one(struct ib_device *device)
 		return err;
 
 	for (p = 0; p <= rdma_end_port(device) - rdma_start_port(device); ++p)
-		ib_cache_update(device, p + rdma_start_port(device));
+		ib_cache_update(device, p + rdma_start_port(device), true);
 
 	INIT_IB_EVENT_HANDLER(&device->cache.event_handler,
 			      device, ib_cache_event);
diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index 722b866..0482e12 100644
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
@@ -140,4 +148,73 @@ static inline bool rdma_is_upper_dev_rcu(struct net_device *dev,
 int ib_get_cached_subnet_prefix(struct ib_device *device,
 				u8                port_num,
 				u64              *sn_pfx);
+
+#ifdef CONFIG_SECURITY_INFINIBAND
+void ib_security_destroy_port_pkey_list(struct ib_device *device);
+
+void ib_security_cache_change(struct ib_device *device,
+			      u8 port_num,
+			      u64 subnet_prefix);
+
+int ib_security_modify_qp(struct ib_qp *qp,
+			  struct ib_qp_attr *qp_attr,
+			  int qp_attr_mask,
+			  struct ib_udata *udata);
+
+int ib_create_qp_security(struct ib_qp *qp, struct ib_device *dev);
+void ib_destroy_qp_security_begin(struct ib_qp_security *sec);
+void ib_destroy_qp_security_abort(struct ib_qp_security *sec);
+void ib_destroy_qp_security_end(struct ib_qp_security *sec);
+int ib_open_shared_qp_security(struct ib_qp *qp, struct ib_device *dev);
+void ib_close_shared_qp_security(struct ib_qp_security *sec);
+#else
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
+static inline int ib_create_qp_security(struct ib_qp *qp,
+					struct ib_device *dev)
+{
+	return 0;
+}
+
+static inline void ib_destroy_qp_security_begin(struct ib_qp_security *sec)
+{
+}
+
+static inline void ib_destroy_qp_security_abort(struct ib_qp_security *sec)
+{
+}
+
+static inline void ib_destroy_qp_security_end(struct ib_qp_security *sec)
+{
+}
+
+static inline int ib_open_shared_qp_security(struct ib_qp *qp,
+					     struct ib_device *dev)
+{
+	return 0;
+}
+
+static inline void ib_close_shared_qp_security(struct ib_qp_security *sec)
+{
+}
+#endif
 #endif /* _CORE_PRIV_H */
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
diff --git a/drivers/infiniband/core/security.c b/drivers/infiniband/core/security.c
new file mode 100644
index 0000000..71a72e7
--- /dev/null
+++ b/drivers/infiniband/core/security.c
@@ -0,0 +1,617 @@
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
+#include <linux/completion.h>
+#include <linux/list.h>
+
+#include <rdma/ib_verbs.h>
+#include <rdma/ib_cache.h>
+#include "core_priv.h"
+
+static struct pkey_index_qp_list *get_pkey_idx_qp_list(struct ib_port_pkey *pp)
+{
+	struct pkey_index_qp_list *pkey = NULL;
+	struct pkey_index_qp_list *tmp_pkey;
+	struct ib_device *dev = pp->sec->dev;
+
+	spin_lock(&dev->port_pkey_list[pp->port_num].list_lock);
+	list_for_each_entry(tmp_pkey,
+			    &dev->port_pkey_list[pp->port_num].pkey_list,
+			    pkey_index_list) {
+		if (tmp_pkey->pkey_index == pp->pkey_index) {
+			pkey = tmp_pkey;
+			break;
+		}
+	}
+	spin_unlock(&dev->port_pkey_list[pp->port_num].list_lock);
+	return pkey;
+}
+
+static int get_pkey_and_subnet_prefix(struct ib_port_pkey *pp,
+				      u16 *pkey,
+				      u64 *subnet_prefix)
+{
+	struct ib_device *dev = pp->sec->dev;
+	int ret;
+
+	ret = ib_get_cached_pkey(dev, pp->port_num, pp->pkey_index, pkey);
+	if (ret)
+		return ret;
+
+	ret = ib_get_cached_subnet_prefix(dev, pp->port_num, subnet_prefix);
+
+	return ret;
+}
+
+static int enforce_qp_pkey_security(u16 pkey,
+				    u64 subnet_prefix,
+				    struct ib_qp_security *sec)
+{
+	struct ib_qp_security *shared_qp_sec;
+	int ret = 0;
+
+	ret = security_ib_qp_pkey_access(subnet_prefix, pkey, sec);
+	if (ret)
+		return ret;
+
+	if (sec->qp == sec->qp->real_qp) {
+		list_for_each_entry(shared_qp_sec,
+				    &sec->shared_qp_list,
+				    shared_qp_list) {
+			ret = security_ib_qp_pkey_access(subnet_prefix,
+							 pkey,
+							 shared_qp_sec);
+			if (ret)
+				break;
+		}
+	}
+	return ret;
+}
+
+/* The caller of this function must hold the QP security
+ * mutex of the QP of the security structure in *pps.
+ *
+ * It takes separate ports_pkeys and security structure
+ * because in some cases the pps will be for a new settings
+ * or the pps will be for the real QP and security structure
+ * will be for a shared QP.
+ */
+static int check_qp_port_pkey_settings(struct ib_ports_pkeys *pps,
+				       struct ib_qp_security *sec)
+{
+	u64 subnet_prefix;
+	u16 pkey;
+	int ret = 0;
+
+	if (!pps)
+		return 0;
+
+	if (pps->main.state != IB_PORT_PKEY_NOT_VALID) {
+		get_pkey_and_subnet_prefix(&pps->main,
+					   &pkey,
+					   &subnet_prefix);
+
+		ret = enforce_qp_pkey_security(pkey,
+					       subnet_prefix,
+					       sec);
+	}
+	if (ret)
+		goto out;
+
+	if (pps->alt.state != IB_PORT_PKEY_NOT_VALID) {
+		get_pkey_and_subnet_prefix(&pps->alt,
+					   &pkey,
+					   &subnet_prefix);
+
+		ret = enforce_qp_pkey_security(pkey,
+					       subnet_prefix,
+					       sec);
+	}
+
+	if (ret)
+		goto out;
+
+out:
+	return ret;
+}
+
+/* The caller of this function must hold the QP security
+ * mutex.
+ */
+static void qp_to_error(struct ib_qp_security *sec)
+{
+	struct ib_qp_security *shared_qp_sec;
+	struct ib_qp_attr attr = {
+		.qp_state = IB_QPS_ERR
+	};
+	struct ib_event event = {
+		.event = IB_EVENT_QP_FATAL
+	};
+
+	/* If the QP is in the process of being destroyed
+	 * the qp pointer in the security structure is
+	 * undefined.  It cannot be modified now.
+	 */
+	if (sec->destroying)
+		return;
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
+}
+
+static inline void check_pkey_qps(struct pkey_index_qp_list *pkey,
+				  struct ib_device *device,
+				  u8 port_num,
+				  u64 subnet_prefix)
+{
+	struct ib_port_pkey *pp, *tmp_pp;
+	bool comp;
+	LIST_HEAD(to_error_list);
+	u16 pkey_val;
+
+	if (!ib_get_cached_pkey(device,
+				port_num,
+				pkey->pkey_index,
+				&pkey_val)) {
+		spin_lock(&pkey->qp_list_lock);
+		list_for_each_entry(pp, &pkey->qp_list, qp_list) {
+			if (atomic_read(&pp->sec->error_list_count))
+				continue;
+
+			if (enforce_qp_pkey_security(pkey_val,
+						     subnet_prefix,
+						     pp->sec)) {
+				atomic_inc(&pp->sec->error_list_count);
+				list_add(&pp->to_error_list,
+					 &to_error_list);
+			}
+		}
+		spin_unlock(&pkey->qp_list_lock);
+	}
+
+	list_for_each_entry_safe(pp,
+				 tmp_pp,
+				 &to_error_list,
+				 to_error_list) {
+		mutex_lock(&pp->sec->mutex);
+		qp_to_error(pp->sec);
+		list_del(&pp->to_error_list);
+		atomic_dec(&pp->sec->error_list_count);
+		comp = pp->sec->destroying;
+		mutex_unlock(&pp->sec->mutex);
+
+		if (comp)
+			complete(&pp->sec->error_complete);
+	}
+}
+
+/* The caller of this function must hold the QP security
+ * mutex.
+ */
+static int port_pkey_list_insert(struct ib_port_pkey *pp)
+{
+	struct pkey_index_qp_list *tmp_pkey;
+	struct pkey_index_qp_list *pkey;
+	struct ib_device *dev;
+	u8 port_num = pp->port_num;
+	int ret = 0;
+
+	if (pp->state != IB_PORT_PKEY_VALID)
+		return 0;
+
+	dev = pp->sec->dev;
+
+	pkey = get_pkey_idx_qp_list(pp);
+
+	if (!pkey) {
+		bool found = false;
+
+		pkey = kzalloc(sizeof(*pkey), GFP_KERNEL);
+		if (!pkey)
+			return -ENOMEM;
+
+		spin_lock(&dev->port_pkey_list[port_num].list_lock);
+		/* Check for the PKey again.  A racing process may
+		 * have created it.
+		 */
+		list_for_each_entry(tmp_pkey,
+				    &dev->port_pkey_list[port_num].pkey_list,
+				    pkey_index_list) {
+			if (tmp_pkey->pkey_index == pp->pkey_index) {
+				kfree(pkey);
+				pkey = tmp_pkey;
+				found = true;
+				break;
+			}
+		}
+
+		if (!found) {
+			pkey->pkey_index = pp->pkey_index;
+			spin_lock_init(&pkey->qp_list_lock);
+			INIT_LIST_HEAD(&pkey->qp_list);
+			list_add(&pkey->pkey_index_list,
+				 &dev->port_pkey_list[port_num].pkey_list);
+		}
+		spin_unlock(&dev->port_pkey_list[port_num].list_lock);
+	}
+
+	spin_lock(&pkey->qp_list_lock);
+	list_add(&pp->qp_list, &pkey->qp_list);
+	spin_unlock(&pkey->qp_list_lock);
+
+	pp->state = IB_PORT_PKEY_LISTED;
+
+	return ret;
+}
+
+/* The caller of this function must hold the QP security
+ * mutex.
+ */
+static void port_pkey_list_remove(struct ib_port_pkey *pp)
+{
+	struct pkey_index_qp_list *pkey;
+
+	if (pp->state != IB_PORT_PKEY_LISTED)
+		return;
+
+	pkey = get_pkey_idx_qp_list(pp);
+
+	spin_lock(&pkey->qp_list_lock);
+	list_del(&pp->qp_list);
+	spin_unlock(&pkey->qp_list_lock);
+
+	/* The setting may still be valid, i.e. after
+	 * a destroy has failed for example.
+	 */
+	pp->state = IB_PORT_PKEY_VALID;
+}
+
+static void destroy_qp_security(struct ib_qp_security *sec)
+{
+	security_ib_qp_free_security(sec);
+	kfree(sec->ports_pkeys);
+	kfree(sec);
+}
+
+/* The caller of this function must hold the QP security
+ * mutex.
+ */
+static struct ib_ports_pkeys *get_new_pps(const struct ib_qp *qp,
+					  const struct ib_qp_attr *qp_attr,
+					  int qp_attr_mask)
+{
+	struct ib_ports_pkeys *new_pps;
+	struct ib_ports_pkeys *qp_pps = qp->qp_sec->ports_pkeys;
+
+	new_pps = kzalloc(sizeof(*new_pps), GFP_KERNEL);
+	if (!new_pps)
+		return NULL;
+
+	if (qp_attr_mask & (IB_QP_PKEY_INDEX | IB_QP_PORT)) {
+		if (!qp_pps) {
+			new_pps->main.port_num = qp_attr->port_num;
+			new_pps->main.pkey_index = qp_attr->pkey_index;
+		} else {
+			new_pps->main.port_num = (qp_attr_mask & IB_QP_PORT) ?
+						  qp_attr->port_num :
+						  qp_pps->main.port_num;
+
+			new_pps->main.pkey_index =
+					(qp_attr_mask & IB_QP_PKEY_INDEX) ?
+					 qp_attr->pkey_index :
+					 qp_pps->main.pkey_index;
+		}
+		new_pps->main.state = IB_PORT_PKEY_VALID;
+	} else if (qp_pps) {
+		new_pps->main.port_num = qp_pps->main.port_num;
+		new_pps->main.pkey_index = qp_pps->main.pkey_index;
+		if (qp_pps->main.state != IB_PORT_PKEY_NOT_VALID)
+			new_pps->main.state = IB_PORT_PKEY_VALID;
+	}
+
+	if (qp_attr_mask & IB_QP_ALT_PATH) {
+		new_pps->alt.port_num = qp_attr->alt_port_num;
+		new_pps->alt.pkey_index = qp_attr->alt_pkey_index;
+		new_pps->alt.state = IB_PORT_PKEY_VALID;
+	} else if (qp_pps) {
+		new_pps->alt.port_num = qp_pps->alt.port_num;
+		new_pps->alt.pkey_index = qp_pps->alt.pkey_index;
+		if (qp_pps->alt.state != IB_PORT_PKEY_NOT_VALID)
+			new_pps->alt.state = IB_PORT_PKEY_VALID;
+	}
+
+	new_pps->main.sec = qp->qp_sec;
+	new_pps->alt.sec = qp->qp_sec;
+	return new_pps;
+}
+
+int ib_open_shared_qp_security(struct ib_qp *qp, struct ib_device *dev)
+{
+	struct ib_qp *real_qp = qp->real_qp;
+	int ret;
+
+	ret = ib_create_qp_security(qp, dev);
+
+	if (ret)
+		goto out;
+
+	mutex_lock(&real_qp->qp_sec->mutex);
+	ret = check_qp_port_pkey_settings(real_qp->qp_sec->ports_pkeys,
+					  qp->qp_sec);
+
+	if (ret)
+		goto ret;
+
+	if (qp != real_qp)
+		list_add(&qp->qp_sec->shared_qp_list,
+			 &real_qp->qp_sec->shared_qp_list);
+ret:
+	mutex_unlock(&real_qp->qp_sec->mutex);
+	if (ret)
+		destroy_qp_security(qp->qp_sec);
+
+out:
+	return ret;
+}
+
+void ib_close_shared_qp_security(struct ib_qp_security *sec)
+{
+	struct ib_qp *real_qp = sec->qp->real_qp;
+
+	mutex_lock(&real_qp->qp_sec->mutex);
+	list_del(&sec->shared_qp_list);
+	mutex_unlock(&real_qp->qp_sec->mutex);
+
+	destroy_qp_security(sec);
+}
+
+int ib_create_qp_security(struct ib_qp *qp, struct ib_device *dev)
+{
+	int ret;
+
+	qp->qp_sec = kzalloc(sizeof(*qp->qp_sec), GFP_KERNEL);
+	if (!qp->qp_sec)
+		return -ENOMEM;
+
+	qp->qp_sec->qp = qp;
+	qp->qp_sec->dev = dev;
+	mutex_init(&qp->qp_sec->mutex);
+	INIT_LIST_HEAD(&qp->qp_sec->shared_qp_list);
+	atomic_set(&qp->qp_sec->error_list_count, 0);
+	init_completion(&qp->qp_sec->error_complete);
+	ret = security_ib_qp_alloc_security(qp->qp_sec);
+	if (ret)
+		kfree(qp->qp_sec);
+
+	return ret;
+}
+EXPORT_SYMBOL(ib_create_qp_security);
+
+void ib_destroy_qp_security_begin(struct ib_qp_security *sec)
+{
+	mutex_lock(&sec->mutex);
+
+	/* Remove the QP from the lists so it won't get added to
+	 * a to_error_list during the destroy process.
+	 */
+	if (sec->ports_pkeys) {
+		port_pkey_list_remove(&sec->ports_pkeys->main);
+		port_pkey_list_remove(&sec->ports_pkeys->alt);
+	}
+
+	/* If the QP is already in one or more of those lists
+	 * the destroying flag will ensure the to error flow
+	 * doesn't operate on an undefined QP.
+	 */
+	sec->destroying = true;
+
+	/* Record the error list count to know how many completions
+	 * to wait for.
+	 */
+	sec->error_comps_pending = atomic_read(&sec->error_list_count);
+
+	mutex_unlock(&sec->mutex);
+}
+
+void ib_destroy_qp_security_abort(struct ib_qp_security *sec)
+{
+	int ret;
+	int i;
+
+	/* If a concurrent cache update is in progress this
+	 * QP security could be marked for an error state
+	 * transition.  Wait for this to complete.
+	 */
+	for (i = 0; i < sec->error_comps_pending; i++)
+		wait_for_completion(&sec->error_complete);
+
+	mutex_lock(&sec->mutex);
+	sec->destroying = false;
+
+	/* Restore the position in the lists and verify
+	 * access is still allowed in case a cache update
+	 * occurred while attempting to destroy.
+	 *
+	 * Because these setting were listed already
+	 * and removed during ib_destroy_qp_security_begin
+	 * we know the pkey_index_qp_list for the PKey
+	 * already exists so port_pkey_list_insert won't fail.
+	 */
+	if (sec->ports_pkeys) {
+		port_pkey_list_insert(&sec->ports_pkeys->main);
+		port_pkey_list_insert(&sec->ports_pkeys->alt);
+	}
+
+	ret = check_qp_port_pkey_settings(sec->ports_pkeys, sec);
+	if (ret)
+		qp_to_error(sec);
+
+	mutex_unlock(&sec->mutex);
+}
+
+void ib_destroy_qp_security_end(struct ib_qp_security *sec)
+{
+	int i;
+
+	/* If a concurrent cache update is occurring we must
+	 * wait until this QP security structure is processed
+	 * in the QP to error flow before destroying it because
+	 * the to_error_list is in use.
+	 */
+	for (i = 0; i < sec->error_comps_pending; i++)
+		wait_for_completion(&sec->error_complete);
+
+	destroy_qp_security(sec);
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
+	int i;
+
+	for (i = rdma_start_port(device); i <= rdma_end_port(device); i++) {
+		spin_lock(&device->port_pkey_list[i].list_lock);
+		list_for_each_entry_safe(pkey,
+					 tmp_pkey,
+					 &device->port_pkey_list[i].pkey_list,
+					 pkey_index_list) {
+			list_del(&pkey->pkey_index_list);
+			kfree(pkey);
+		}
+		spin_unlock(&device->port_pkey_list[i].list_lock);
+	}
+}
+
+int ib_security_modify_qp(struct ib_qp *qp,
+			  struct ib_qp_attr *qp_attr,
+			  int qp_attr_mask,
+			  struct ib_udata *udata)
+{
+	int ret = 0;
+	struct ib_ports_pkeys *tmp_pps;
+	struct ib_ports_pkeys *new_pps;
+	bool special_qp = (qp->qp_type == IB_QPT_SMI ||
+			   qp->qp_type == IB_QPT_GSI);
+	bool pps_change = ((qp_attr_mask & (IB_QP_PKEY_INDEX | IB_QP_PORT)) ||
+			   (qp_attr_mask & IB_QP_ALT_PATH));
+
+	if (pps_change && !special_qp) {
+		mutex_lock(&qp->qp_sec->mutex);
+		new_pps = get_new_pps(qp,
+				      qp_attr,
+				      qp_attr_mask);
+
+		/* Add this QP to the lists for the new port
+		 * and pkey settings before checking for permission
+		 * in case there is a concurrent cache update
+		 * occurring.  Walking the list for a cache change
+		 * doesn't acquire the security mutex unless it's
+		 * sending the QP to error.
+		 */
+		ret = port_pkey_list_insert(&new_pps->main);
+
+		if (!ret)
+			ret = port_pkey_list_insert(&new_pps->alt);
+
+		if (!ret)
+			ret = check_qp_port_pkey_settings(new_pps,
+							  qp->qp_sec);
+	}
+
+	if (!ret)
+		ret = qp->device->modify_qp(qp->real_qp,
+					    qp_attr,
+					    qp_attr_mask,
+					    udata);
+
+	if (pps_change && !special_qp) {
+		/* Clean up the lists and free the appropriate
+		 * ports_pkeys structure.
+		 */
+		if (ret) {
+			tmp_pps = new_pps;
+		} else {
+			tmp_pps = qp->qp_sec->ports_pkeys;
+			qp->qp_sec->ports_pkeys = new_pps;
+		}
+
+		if (tmp_pps) {
+			port_pkey_list_remove(&tmp_pps->main);
+			port_pkey_list_remove(&tmp_pps->alt);
+		}
+		kfree(tmp_pps);
+		mutex_unlock(&qp->qp_sec->mutex);
+	}
+	return ret;
+}
+EXPORT_SYMBOL(ib_security_modify_qp);
+
+#endif /* CONFIG_SECURITY_INFINIBAND */
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 6fdc7ec..17bff33 100644
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
+		ret = ib_create_qp_security(qp, device);
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
index 15b8adb..7a35688 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -44,6 +44,7 @@
 #include <linux/in.h>
 #include <linux/in6.h>
 #include <net/addrconf.h>
+#include <linux/security.h>
 
 #include <rdma/ib_verbs.h>
 #include <rdma/ib_cache.h>
@@ -681,12 +682,20 @@ static struct ib_qp *__ib_open_qp(struct ib_qp *real_qp,
 {
 	struct ib_qp *qp;
 	unsigned long flags;
+	int err;
 
 	qp = kzalloc(sizeof *qp, GFP_KERNEL);
 	if (!qp)
 		return ERR_PTR(-ENOMEM);
 
 	qp->real_qp = real_qp;
+	err = ib_open_shared_qp_security(qp, real_qp->device);
+	if (err) {
+		kfree(qp);
+		return ERR_PTR(err);
+	}
+
+	qp->real_qp = real_qp;
 	atomic_inc(&real_qp->usecnt);
 	qp->device = real_qp->device;
 	qp->event_handler = event_handler;
@@ -728,11 +737,16 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
 {
 	struct ib_qp *qp, *real_qp;
 	struct ib_device *device;
+	int err;
 
 	device = pd ? pd->device : qp_init_attr->xrcd->device;
 	qp = device->create_qp(pd, qp_init_attr, NULL);
 
 	if (!IS_ERR(qp)) {
+		err = ib_create_qp_security(qp, device);
+		if (err)
+			goto destroy_qp;
+
 		qp->device     = device;
 		qp->real_qp    = qp;
 		qp->uobject    = NULL;
@@ -780,6 +794,10 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
 	}
 
 	return qp;
+
+destroy_qp:
+	ib_destroy_qp(qp);
+	return ERR_PTR(err);
 }
 EXPORT_SYMBOL(ib_create_qp);
 
@@ -1180,7 +1198,7 @@ int ib_modify_qp(struct ib_qp *qp,
 	if (ret)
 		return ret;
 
-	return qp->device->modify_qp(qp->real_qp, qp_attr, qp_attr_mask, NULL);
+	return ib_security_modify_qp(qp->real_qp, qp_attr, qp_attr_mask, NULL);
 }
 EXPORT_SYMBOL(ib_modify_qp);
 
@@ -1209,6 +1227,7 @@ int ib_close_qp(struct ib_qp *qp)
 	spin_unlock_irqrestore(&real_qp->device->event_handler_lock, flags);
 
 	atomic_dec(&real_qp->usecnt);
+	ib_close_shared_qp_security(qp->qp_sec);
 	kfree(qp);
 
 	return 0;
@@ -1248,6 +1267,7 @@ int ib_destroy_qp(struct ib_qp *qp)
 	struct ib_pd *pd;
 	struct ib_cq *scq, *rcq;
 	struct ib_srq *srq;
+	struct ib_qp_security *sec;
 	int ret;
 
 	if (atomic_read(&qp->usecnt))
@@ -1260,6 +1280,9 @@ int ib_destroy_qp(struct ib_qp *qp)
 	scq  = qp->send_cq;
 	rcq  = qp->recv_cq;
 	srq  = qp->srq;
+	sec  = qp->qp_sec;
+	if (sec)
+		ib_destroy_qp_security_begin(sec);
 
 	ret = qp->device->destroy_qp(qp);
 	if (!ret) {
@@ -1271,6 +1294,11 @@ int ib_destroy_qp(struct ib_qp *qp)
 			atomic_dec(&rcq->usecnt);
 		if (srq)
 			atomic_dec(&srq->usecnt);
+		if (sec)
+			ib_destroy_qp_security_end(sec);
+	} else {
+		if (sec)
+			ib_destroy_qp_security_abort(sec);
 	}
 
 	return ret;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 870c5ac..a986951 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1416,8 +1416,43 @@ struct ib_srq {
 	} ext;
 };
 
+enum port_pkey_state {
+	IB_PORT_PKEY_NOT_VALID = 0,
+	IB_PORT_PKEY_VALID = 1,
+	IB_PORT_PKEY_LISTED = 2,
+};
+
+struct ib_qp_security;
+
+struct ib_port_pkey {
+	enum port_pkey_state	state;
+	u16			pkey_index;
+	u8			port_num;
+	struct list_head	qp_list;
+	struct list_head	to_error_list;
+	struct ib_qp_security  *sec;
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
+	struct ib_device       *dev;
+	/* Hold this mutex when changing port and pkey settings. */
+	struct mutex		mutex;
+	struct ib_ports_pkeys  *ports_pkeys;
+	/* A list of all open shared QP handles.  Required to enforce security
+	 * properly for all users of a shared QP.
+	 */
+	struct list_head        shared_qp_list;
+	void                   *q_security;
+	bool			destroying;
+	atomic_t		error_list_count;
+	struct completion	error_complete;
+	int			error_comps_pending;
 };
 
 struct ib_qp {
@@ -1667,6 +1702,12 @@ struct ib_port_immutable {
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
 
@@ -1689,6 +1730,8 @@ struct ib_device {
 
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
