From: Dan Jurgens <danielj@mellanox.com>
Subject: [PATCH v7 2/9] IB/core: Enforce PKey security on QPs
Date: Fri, 19 May 2017 15:48:52 +0300
Message-ID: <1495198139-69993-3-git-send-email-danielj@mellanox.com>
References: <1495198139-69993-1-git-send-email-danielj@mellanox.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1495198139-69993-1-git-send-email-danielj@mellanox.com>
Sender: owner-linux-security-module@vger.kernel.org
To: chrisw@sous-sol.org, paul@paul-moore.com, sds@tycho.nsa.gov, eparis@parisplace.org, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com
Cc: selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org, linux-rdma@vger.kernel.org, yevgenyp@mellanox.com, Daniel Jurgens <danielj@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Jurgens <danielj@mellanox.com>

Add new LSM hooks to allocate and free security contexts and check for
permission to access a PKey.

Allocate and free a security context when creating and destroying a QP.
This context is used for controlling access to PKeys.

When a request is made to modify a QP that changes the port, PKey index,
or alternate path, check that the QP has permission for the PKey in the
PKey table index on the subnet prefix of the port. If the QP is shared
make sure all handles to the QP also have access.

Store which port and PKey index a QP is using. After the reset to init
transition the user can modify the port, PKey index and alternate path
independently. So port and PKey settings changes can be a merge of the
previous settings and the new ones.

In order to maintain access control if there are PKey table or subnet
prefix change keep a list of all QPs are using each PKey index on
each port. If a change occurs all QPs using that device and port must
have access enforced for the new cache settings.

These changes add a transaction to the QP modify process. Association
with the old port and PKey index must be maintained if the modify fails,
and must be removed if it succeeds. Association with the new port and
PKey index must be established prior to the modify and removed if the
modify fails.

1. When a QP is modified to a particular Port, PKey index or alternate
   path insert that QP into the appropriate lists.

2. Check permission to access the new settings.

3. If step 2 grants access attempt to modify the QP.

4a. If steps 2 and 3 succeed remove any prior associations.

4b. If ether fails remove the new setting associations.

If a PKey table or subnet prefix changes walk the list of QPs and
check that they have permission. If not send the QP to the error state
and raise a fatal error event. If it's a shared QP make sure all the
QPs that share the real_qp have permission as well. If the QP that
owns a security structure is denied access the security structure is
marked as such and the QP is added to an error_list. Once the moving
the QP to error is complete the security structure mark is cleared.

Maintaining the lists correctly turns QP destroy into a transaction.
The hardware driver for the device frees the ib_qp structure, so while
the destroy is in progress the ib_qp pointer in the ib_qp_security
struct is undefined. When the destroy process begins the ib_qp_security
structure is marked as destroying. This prevents any action from being
taken on the QP pointer. After the QP is destroyed successfully it
could still listed on an error_list wait for it to be processed by that
flow before cleaning up the structure.

If the destroy fails the QPs port and PKey settings are reinserted into
the appropriate lists, the destroying flag is cleared, and access control
is enforced, in case there were any cache changes during the destroy
flow.

To keep the security changes isolated a new file is used to hold security
related functionality.

Signed-off-by: Daniel Jurgens <danielj@mellanox.com>

---
v2:
- Squashed LSM hook additions. Paul Moore
- Changed security blobs to void*. Paul Moore

v3:
- Change parameter order of pkey_access hook. Paul Moore

v7:
- Exclude IB_QPT_RESERVED* types from enforcement, they are special like
  SMI and GSI.
- Use kcalloc vs kzalloc for port_pkey_list allocation. Parav Pandit

 drivers/infiniband/core/Makefile     |   3 +-
 drivers/infiniband/core/cache.c      |  21 +-
 drivers/infiniband/core/core_priv.h  |  77 +++++
 drivers/infiniband/core/device.c     |  33 ++
 drivers/infiniband/core/security.c   | 618 +++++++++++++++++++++++++++++++++++
 drivers/infiniband/core/uverbs_cmd.c |  15 +-
 drivers/infiniband/core/verbs.c      |  27 +-
 include/linux/lsm_hooks.h            |  27 ++
 include/linux/security.h             |  21 ++
 include/rdma/ib_verbs.h              |  48 +++
 security/Kconfig                     |   9 +
 security/security.c                  | 385 ++++++++++++++++++++++
 12 files changed, 1275 insertions(+), 9 deletions(-)
 create mode 100644 drivers/infiniband/core/security.c

diff --git a/drivers/infiniband/core/Makefile b/drivers/infiniband/core/Makefile
index e426ac8..d6c8715 100644
--- a/drivers/infiniband/core/Makefile
+++ b/drivers/infiniband/core/Makefile
@@ -10,7 +10,8 @@ obj-$(CONFIG_INFINIBAND_USER_ACCESS) +=	ib_uverbs.o ib_ucm.o \
 ib_core-y :=			packer.o ud_header.o verbs.o cq.o rw.o sysfs.o \
 				device.o fmr_pool.o cache.o netlink.o \
 				roce_gid_mgmt.o mr_pool.o addr.o sa_query.o \
-				multicast.o mad.o smi.o agent.o mad_rmpp.o
+				multicast.o mad.o smi.o agent.o mad_rmpp.o \
+				security.o
 ib_core-$(CONFIG_INFINIBAND_USER_MEM) += umem.o
 ib_core-$(CONFIG_INFINIBAND_ON_DEMAND_PAGING) += umem_odp.o umem_rbtree.o
 ib_core-$(CONFIG_CGROUP_RDMA) += cgroup.o
diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index b9c0066..efc9430 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -53,6 +53,7 @@ struct ib_update_work {
 	struct work_struct work;
 	struct ib_device  *device;
 	u8                 port_num;
+	bool		   enforce_security;
 };
 
 union ib_gid zgid;
@@ -1042,7 +1043,8 @@ int ib_get_cached_port_state(struct ib_device   *device,
 EXPORT_SYMBOL(ib_get_cached_port_state);
 
 static void ib_cache_update(struct ib_device *device,
-			    u8                port)
+			    u8                port,
+			    bool	      enforce_security)
 {
 	struct ib_port_attr       *tprops = NULL;
 	struct ib_pkey_cache      *pkey_cache = NULL, *old_pkey_cache;
@@ -1132,6 +1134,11 @@ static void ib_cache_update(struct ib_device *device,
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
@@ -1148,7 +1155,9 @@ static void ib_cache_task(struct work_struct *_work)
 	struct ib_update_work *work =
 		container_of(_work, struct ib_update_work, work);
 
-	ib_cache_update(work->device, work->port_num);
+	ib_cache_update(work->device,
+			work->port_num,
+			work->enforce_security);
 	kfree(work);
 }
 
@@ -1169,6 +1178,12 @@ static void ib_cache_event(struct ib_event_handler *handler,
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
@@ -1194,7 +1209,7 @@ int ib_cache_setup_one(struct ib_device *device)
 		goto out;
 
 	for (p = 0; p <= rdma_end_port(device) - rdma_start_port(device); ++p)
-		ib_cache_update(device, p + rdma_start_port(device));
+		ib_cache_update(device, p + rdma_start_port(device), true);
 
 	INIT_IB_EVENT_HANDLER(&device->cache.event_handler,
 			      device, ib_cache_event);
diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index 249e3ed..7b63215 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -39,6 +39,14 @@
 
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
@@ -179,4 +187,73 @@ int ib_nl_handle_ip_res_resp(struct sk_buff *skb,
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
index 7c9e34d..92e0b89 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -317,6 +317,30 @@ void ib_get_device_fw_str(struct ib_device *dev, char *str, size_t str_len)
 }
 EXPORT_SYMBOL(ib_get_device_fw_str);
 
+static int setup_port_pkey_list(struct ib_device *device)
+{
+	int i;
+
+	/**
+	 * device->port_pkey_list is indexed directly by the port number,
+	 * Therefore it is declared as a 1 based array with potential empty
+	 * slots at the beginning.
+	 */
+	device->port_pkey_list = kcalloc(rdma_end_port(device) + 1,
+					 sizeof(*device->port_pkey_list),
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
@@ -377,6 +401,12 @@ int ib_register_device(struct ib_device *device,
 		goto out;
 	}
 
+	ret = setup_port_pkey_list(device);
+	if (ret) {
+		pr_warn("Couldn't create per port_pkey_list\n");
+		goto out;
+	}
+
 	ret = ib_cache_setup_one(device);
 	if (ret) {
 		pr_warn("Couldn't set up InfiniBand P_Key/GID cache\n");
@@ -457,6 +487,9 @@ void ib_unregister_device(struct ib_device *device)
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
index 0000000..1ec913c
--- /dev/null
+++ b/drivers/infiniband/core/security.c
@@ -0,0 +1,618 @@
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
+				    struct ib_qp_security *qp_sec)
+{
+	struct ib_qp_security *shared_qp_sec;
+	int ret;
+
+	ret = security_ib_pkey_access(qp_sec->security, subnet_prefix, pkey);
+	if (ret)
+		return ret;
+
+	if (qp_sec->qp == qp_sec->qp->real_qp) {
+		list_for_each_entry(shared_qp_sec,
+				    &qp_sec->shared_qp_list,
+				    shared_qp_list) {
+			ret = security_ib_pkey_access(shared_qp_sec->security,
+						      subnet_prefix,
+						      pkey);
+			if (ret)
+				return ret;
+		}
+	}
+	return 0;
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
+	security_ib_free_security(sec->security);
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
+	ret = security_ib_alloc_security(&qp->qp_sec->security);
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
+			   qp->qp_type == IB_QPT_GSI ||
+			   qp->qp_type >= IB_QPT_RESERVED1);
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
index 7b7a76e..268ff28 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1970,6 +1970,10 @@ static int create_qp(struct ib_uverbs_file *file,
 	}
 
 	if (cmd->qp_type != IB_QPT_XRC_TGT) {
+		ret = ib_create_qp_security(qp, device);
+		if (ret)
+			goto err_destroy;
+
 		qp->real_qp	  = qp;
 		qp->device	  = device;
 		qp->pd		  = pd;
@@ -2459,14 +2463,17 @@ static int modify_qp(struct ib_uverbs_file *file,
 			if (ret)
 				goto release_qp;
 		}
-		ret = qp->device->modify_qp(qp, attr,
+		ret = ib_security_modify_qp(qp,
+					    attr,
 					    modify_qp_mask(qp->qp_type,
 							   cmd->base.attr_mask),
 					    udata);
 	} else {
-		ret = ib_modify_qp(qp, attr,
-				   modify_qp_mask(qp->qp_type,
-						  cmd->base.attr_mask));
+		ret = ib_security_modify_qp(qp,
+					    attr,
+					    modify_qp_mask(qp->qp_type,
+							   cmd->base.attr_mask),
+					    NULL);
 	}
 
 release_qp:
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 85ed505..fc985a5 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -44,6 +44,7 @@
 #include <linux/in.h>
 #include <linux/in6.h>
 #include <net/addrconf.h>
+#include <linux/security.h>
 
 #include <rdma/ib_verbs.h>
 #include <rdma/ib_cache.h>
@@ -710,12 +711,20 @@ static struct ib_qp *__ib_open_qp(struct ib_qp *real_qp,
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
@@ -801,6 +810,12 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
 	if (IS_ERR(qp))
 		return qp;
 
+	ret = ib_create_qp_security(qp, device);
+	if (ret) {
+		ib_destroy_qp(qp);
+		return ERR_PTR(ret);
+	}
+
 	qp->device     = device;
 	qp->real_qp    = qp;
 	qp->uobject    = NULL;
@@ -1260,7 +1275,7 @@ int ib_modify_qp(struct ib_qp *qp,
 			return ret;
 	}
 
-	return qp->device->modify_qp(qp->real_qp, qp_attr, qp_attr_mask, NULL);
+	return ib_security_modify_qp(qp->real_qp, qp_attr, qp_attr_mask, NULL);
 }
 EXPORT_SYMBOL(ib_modify_qp);
 
@@ -1289,6 +1304,7 @@ int ib_close_qp(struct ib_qp *qp)
 	spin_unlock_irqrestore(&real_qp->device->event_handler_lock, flags);
 
 	atomic_dec(&real_qp->usecnt);
+	ib_close_shared_qp_security(qp->qp_sec);
 	kfree(qp);
 
 	return 0;
@@ -1329,6 +1345,7 @@ int ib_destroy_qp(struct ib_qp *qp)
 	struct ib_cq *scq, *rcq;
 	struct ib_srq *srq;
 	struct ib_rwq_ind_table *ind_tbl;
+	struct ib_qp_security *sec;
 	int ret;
 
 	WARN_ON_ONCE(qp->mrs_used > 0);
@@ -1344,6 +1361,9 @@ int ib_destroy_qp(struct ib_qp *qp)
 	rcq  = qp->recv_cq;
 	srq  = qp->srq;
 	ind_tbl = qp->rwq_ind_tbl;
+	sec  = qp->qp_sec;
+	if (sec)
+		ib_destroy_qp_security_begin(sec);
 
 	if (!qp->uobject)
 		rdma_rw_cleanup_mrs(qp);
@@ -1360,6 +1380,11 @@ int ib_destroy_qp(struct ib_qp *qp)
 			atomic_dec(&srq->usecnt);
 		if (ind_tbl)
 			atomic_dec(&ind_tbl->usecnt);
+		if (sec)
+			ib_destroy_qp_security_end(sec);
+	} else {
+		if (sec)
+			ib_destroy_qp_security_abort(sec);
 	}
 
 	return ret;
diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index 080f34e..6d9f41f 100644
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
@@ -911,6 +912,21 @@
  *	associated with the TUN device's security structure.
  *	@security pointer to the TUN devices's security structure.
  *
+ * Security hooks for Infiniband
+ *
+ * @ib_pkey_access:
+ *	Check permission to access a pkey when modifing a QP.
+ *	@subnet_prefix the subnet prefix of the port being used.
+ *	@pkey the pkey to be accessed.
+ *	@sec pointer to a security structure.
+ * @ib_alloc_security:
+ *	Allocate a security structure for Infiniband objects.
+ *	@sec pointer to a security structure pointer.
+ *	Returns 0 on success, non-zero on failure
+ * @ib_free_security:
+ *	Deallocate an Infiniband security structure.
+ *	@sec contains the security structure to be freed.
+ *
  * Security hooks for XFRM operations.
  *
  * @xfrm_policy_alloc_security:
@@ -1620,6 +1636,12 @@ union security_list_options {
 	int (*tun_dev_open)(void *security);
 #endif	/* CONFIG_SECURITY_NETWORK */
 
+#ifdef CONFIG_SECURITY_INFINIBAND
+	int (*ib_pkey_access)(void *sec, u64 subnet_prefix, u16 pkey);
+	int (*ib_alloc_security)(void **sec);
+	void (*ib_free_security)(void *sec);
+#endif	/* CONFIG_SECURITY_INFINIBAND */
+
 #ifdef CONFIG_SECURITY_NETWORK_XFRM
 	int (*xfrm_policy_alloc_security)(struct xfrm_sec_ctx **ctxp,
 					  struct xfrm_user_sec_ctx *sec_ctx,
@@ -1851,6 +1873,11 @@ struct security_hook_heads {
 	struct list_head tun_dev_attach;
 	struct list_head tun_dev_open;
 #endif	/* CONFIG_SECURITY_NETWORK */
+#ifdef CONFIG_SECURITY_INFINIBAND
+	struct list_head ib_pkey_access;
+	struct list_head ib_alloc_security;
+	struct list_head ib_free_security;
+#endif	/* CONFIG_SECURITY_INFINIBAND */
 #ifdef CONFIG_SECURITY_NETWORK_XFRM
 	struct list_head xfrm_policy_alloc_security;
 	struct list_head xfrm_policy_clone_security;
diff --git a/include/linux/security.h b/include/linux/security.h
index af675b5..8c73ee0 100644
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
@@ -1406,6 +1407,26 @@ static inline int security_tun_dev_open(void *security)
 }
 #endif	/* CONFIG_SECURITY_NETWORK */
 
+#ifdef CONFIG_SECURITY_INFINIBAND
+int security_ib_pkey_access(void *sec, u64 subnet_prefix, u16 pkey);
+int security_ib_alloc_security(void **sec);
+void security_ib_free_security(void *sec);
+#else	/* CONFIG_SECURITY_INFINIBAND */
+static inline int security_ib_pkey_access(void *sec, u64 subnet_prefix, u16 pkey)
+{
+	return 0;
+}
+
+static inline int security_ib_alloc_security(void **sec)
+{
+	return 0;
+}
+
+static inline void security_ib_free_security(void *sec)
+{
+}
+#endif	/* CONFIG_SECURITY_INFINIBAND */
+
 #ifdef CONFIG_SECURITY_NETWORK_XFRM
 
 int security_xfrm_policy_alloc(struct xfrm_sec_ctx **ctxp,
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 23486d3..c9e903f 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1569,6 +1569,45 @@ struct ib_rwq_ind_table_init_attr {
 	struct ib_wq	**ind_tbl;
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
+struct ib_qp_security {
+	struct ib_qp	       *qp;
+	struct ib_device       *dev;
+	/* Hold this mutex when changing port and pkey settings. */
+	struct mutex		mutex;
+	struct ib_ports_pkeys  *ports_pkeys;
+	/* A list of all open shared QP handles.  Required to enforce security
+	 * properly for all users of a shared QP.
+	 */
+	struct list_head        shared_qp_list;
+	void                   *security;
+	bool			destroying;
+	atomic_t		error_list_count;
+	struct completion	error_complete;
+	int			error_comps_pending;
+};
+
 /*
  * @max_write_sge: Maximum SGE elements per RDMA WRITE request.
  * @max_read_sge:  Maximum SGE elements per RDMA READ request.
@@ -1598,6 +1637,7 @@ struct ib_qp {
 	u32			max_read_sge;
 	enum ib_qp_type		qp_type;
 	struct ib_rwq_ind_table *rwq_ind_tbl;
+	struct ib_qp_security  *qp_sec;
 };
 
 struct ib_mr {
@@ -1863,6 +1903,12 @@ struct ib_port_immutable {
 	u32                           max_mad_size;
 };
 
+struct ib_port_pkey_list {
+	/* Lock to hold while modifying the list. */
+	spinlock_t		      list_lock;
+	struct list_head	      pkey_list;
+};
+
 struct ib_device {
 	/* Do not access @dma_device directly from ULP nor from HW drivers. */
 	struct device                *dma_device;
@@ -1886,6 +1932,8 @@ struct ib_device {
 
 	int			      num_comp_vectors;
 
+	struct ib_port_pkey_list     *port_pkey_list;
+
 	struct iw_cm_verbs	     *iwcm;
 
 	/**
diff --git a/security/Kconfig b/security/Kconfig
index 823ca1a..c1d0228 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -54,6 +54,15 @@ config SECURITY_NETWORK
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
index 54b1e39..a142a0b 100644
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
@@ -1511,6 +1512,27 @@ EXPORT_SYMBOL(security_tun_dev_open);
 
 #endif	/* CONFIG_SECURITY_NETWORK */
 
+#ifdef CONFIG_SECURITY_INFINIBAND
+
+int security_ib_pkey_access(void *sec, u64 subnet_prefix, u16 pkey)
+{
+	return call_int_hook(ib_pkey_access, 0, sec, subnet_prefix, pkey);
+}
+EXPORT_SYMBOL(security_ib_pkey_access);
+
+int security_ib_alloc_security(void **sec)
+{
+	return call_int_hook(ib_alloc_security, 0, sec);
+}
+EXPORT_SYMBOL(security_ib_alloc_security);
+
+void security_ib_free_security(void *sec)
+{
+	call_void_hook(ib_free_security, sec);
+}
+EXPORT_SYMBOL(security_ib_free_security);
+#endif	/* CONFIG_SECURITY_INFINIBAND */
+
 #ifdef CONFIG_SECURITY_NETWORK_XFRM
 
 int security_xfrm_policy_alloc(struct xfrm_sec_ctx **ctxp,
@@ -1658,3 +1680,366 @@ int security_audit_rule_match(u32 secid, u32 field, u32 op, void *lsmrule,
 				actx);
 }
 #endif /* CONFIG_AUDIT */
+
+struct security_hook_heads security_hook_heads __lsm_ro_after_init = {
+	.binder_set_context_mgr =
+		LIST_HEAD_INIT(security_hook_heads.binder_set_context_mgr),
+	.binder_transaction =
+		LIST_HEAD_INIT(security_hook_heads.binder_transaction),
+	.binder_transfer_binder =
+		LIST_HEAD_INIT(security_hook_heads.binder_transfer_binder),
+	.binder_transfer_file =
+		LIST_HEAD_INIT(security_hook_heads.binder_transfer_file),
+
+	.ptrace_access_check =
+		LIST_HEAD_INIT(security_hook_heads.ptrace_access_check),
+	.ptrace_traceme =
+		LIST_HEAD_INIT(security_hook_heads.ptrace_traceme),
+	.capget =	LIST_HEAD_INIT(security_hook_heads.capget),
+	.capset =	LIST_HEAD_INIT(security_hook_heads.capset),
+	.capable =	LIST_HEAD_INIT(security_hook_heads.capable),
+	.quotactl =	LIST_HEAD_INIT(security_hook_heads.quotactl),
+	.quota_on =	LIST_HEAD_INIT(security_hook_heads.quota_on),
+	.syslog =	LIST_HEAD_INIT(security_hook_heads.syslog),
+	.settime =	LIST_HEAD_INIT(security_hook_heads.settime),
+	.vm_enough_memory =
+		LIST_HEAD_INIT(security_hook_heads.vm_enough_memory),
+	.bprm_set_creds =
+		LIST_HEAD_INIT(security_hook_heads.bprm_set_creds),
+	.bprm_check_security =
+		LIST_HEAD_INIT(security_hook_heads.bprm_check_security),
+	.bprm_secureexec =
+		LIST_HEAD_INIT(security_hook_heads.bprm_secureexec),
+	.bprm_committing_creds =
+		LIST_HEAD_INIT(security_hook_heads.bprm_committing_creds),
+	.bprm_committed_creds =
+		LIST_HEAD_INIT(security_hook_heads.bprm_committed_creds),
+	.sb_alloc_security =
+		LIST_HEAD_INIT(security_hook_heads.sb_alloc_security),
+	.sb_free_security =
+		LIST_HEAD_INIT(security_hook_heads.sb_free_security),
+	.sb_copy_data =	LIST_HEAD_INIT(security_hook_heads.sb_copy_data),
+	.sb_remount =	LIST_HEAD_INIT(security_hook_heads.sb_remount),
+	.sb_kern_mount =
+		LIST_HEAD_INIT(security_hook_heads.sb_kern_mount),
+	.sb_show_options =
+		LIST_HEAD_INIT(security_hook_heads.sb_show_options),
+	.sb_statfs =	LIST_HEAD_INIT(security_hook_heads.sb_statfs),
+	.sb_mount =	LIST_HEAD_INIT(security_hook_heads.sb_mount),
+	.sb_umount =	LIST_HEAD_INIT(security_hook_heads.sb_umount),
+	.sb_pivotroot =	LIST_HEAD_INIT(security_hook_heads.sb_pivotroot),
+	.sb_set_mnt_opts =
+		LIST_HEAD_INIT(security_hook_heads.sb_set_mnt_opts),
+	.sb_clone_mnt_opts =
+		LIST_HEAD_INIT(security_hook_heads.sb_clone_mnt_opts),
+	.sb_parse_opts_str =
+		LIST_HEAD_INIT(security_hook_heads.sb_parse_opts_str),
+	.dentry_init_security =
+		LIST_HEAD_INIT(security_hook_heads.dentry_init_security),
+	.dentry_create_files_as =
+		LIST_HEAD_INIT(security_hook_heads.dentry_create_files_as),
+#ifdef CONFIG_SECURITY_PATH
+	.path_unlink =	LIST_HEAD_INIT(security_hook_heads.path_unlink),
+	.path_mkdir =	LIST_HEAD_INIT(security_hook_heads.path_mkdir),
+	.path_rmdir =	LIST_HEAD_INIT(security_hook_heads.path_rmdir),
+	.path_mknod =	LIST_HEAD_INIT(security_hook_heads.path_mknod),
+	.path_truncate =
+		LIST_HEAD_INIT(security_hook_heads.path_truncate),
+	.path_symlink =	LIST_HEAD_INIT(security_hook_heads.path_symlink),
+	.path_link =	LIST_HEAD_INIT(security_hook_heads.path_link),
+	.path_rename =	LIST_HEAD_INIT(security_hook_heads.path_rename),
+	.path_chmod =	LIST_HEAD_INIT(security_hook_heads.path_chmod),
+	.path_chown =	LIST_HEAD_INIT(security_hook_heads.path_chown),
+	.path_chroot =	LIST_HEAD_INIT(security_hook_heads.path_chroot),
+#endif
+	.inode_alloc_security =
+		LIST_HEAD_INIT(security_hook_heads.inode_alloc_security),
+	.inode_free_security =
+		LIST_HEAD_INIT(security_hook_heads.inode_free_security),
+	.inode_init_security =
+		LIST_HEAD_INIT(security_hook_heads.inode_init_security),
+	.inode_create =	LIST_HEAD_INIT(security_hook_heads.inode_create),
+	.inode_link =	LIST_HEAD_INIT(security_hook_heads.inode_link),
+	.inode_unlink =	LIST_HEAD_INIT(security_hook_heads.inode_unlink),
+	.inode_symlink =
+		LIST_HEAD_INIT(security_hook_heads.inode_symlink),
+	.inode_mkdir =	LIST_HEAD_INIT(security_hook_heads.inode_mkdir),
+	.inode_rmdir =	LIST_HEAD_INIT(security_hook_heads.inode_rmdir),
+	.inode_mknod =	LIST_HEAD_INIT(security_hook_heads.inode_mknod),
+	.inode_rename =	LIST_HEAD_INIT(security_hook_heads.inode_rename),
+	.inode_readlink =
+		LIST_HEAD_INIT(security_hook_heads.inode_readlink),
+	.inode_follow_link =
+		LIST_HEAD_INIT(security_hook_heads.inode_follow_link),
+	.inode_permission =
+		LIST_HEAD_INIT(security_hook_heads.inode_permission),
+	.inode_setattr =
+		LIST_HEAD_INIT(security_hook_heads.inode_setattr),
+	.inode_getattr =
+		LIST_HEAD_INIT(security_hook_heads.inode_getattr),
+	.inode_setxattr =
+		LIST_HEAD_INIT(security_hook_heads.inode_setxattr),
+	.inode_post_setxattr =
+		LIST_HEAD_INIT(security_hook_heads.inode_post_setxattr),
+	.inode_getxattr =
+		LIST_HEAD_INIT(security_hook_heads.inode_getxattr),
+	.inode_listxattr =
+		LIST_HEAD_INIT(security_hook_heads.inode_listxattr),
+	.inode_removexattr =
+		LIST_HEAD_INIT(security_hook_heads.inode_removexattr),
+	.inode_need_killpriv =
+		LIST_HEAD_INIT(security_hook_heads.inode_need_killpriv),
+	.inode_killpriv =
+		LIST_HEAD_INIT(security_hook_heads.inode_killpriv),
+	.inode_getsecurity =
+		LIST_HEAD_INIT(security_hook_heads.inode_getsecurity),
+	.inode_setsecurity =
+		LIST_HEAD_INIT(security_hook_heads.inode_setsecurity),
+	.inode_listsecurity =
+		LIST_HEAD_INIT(security_hook_heads.inode_listsecurity),
+	.inode_getsecid =
+		LIST_HEAD_INIT(security_hook_heads.inode_getsecid),
+	.inode_copy_up =
+		LIST_HEAD_INIT(security_hook_heads.inode_copy_up),
+	.inode_copy_up_xattr =
+		LIST_HEAD_INIT(security_hook_heads.inode_copy_up_xattr),
+	.file_permission =
+		LIST_HEAD_INIT(security_hook_heads.file_permission),
+	.file_alloc_security =
+		LIST_HEAD_INIT(security_hook_heads.file_alloc_security),
+	.file_free_security =
+		LIST_HEAD_INIT(security_hook_heads.file_free_security),
+	.file_ioctl =	LIST_HEAD_INIT(security_hook_heads.file_ioctl),
+	.mmap_addr =	LIST_HEAD_INIT(security_hook_heads.mmap_addr),
+	.mmap_file =	LIST_HEAD_INIT(security_hook_heads.mmap_file),
+	.file_mprotect =
+		LIST_HEAD_INIT(security_hook_heads.file_mprotect),
+	.file_lock =	LIST_HEAD_INIT(security_hook_heads.file_lock),
+	.file_fcntl =	LIST_HEAD_INIT(security_hook_heads.file_fcntl),
+	.file_set_fowner =
+		LIST_HEAD_INIT(security_hook_heads.file_set_fowner),
+	.file_send_sigiotask =
+		LIST_HEAD_INIT(security_hook_heads.file_send_sigiotask),
+	.file_receive =	LIST_HEAD_INIT(security_hook_heads.file_receive),
+	.file_open =	LIST_HEAD_INIT(security_hook_heads.file_open),
+	.task_create =	LIST_HEAD_INIT(security_hook_heads.task_create),
+	.task_free =	LIST_HEAD_INIT(security_hook_heads.task_free),
+	.cred_alloc_blank =
+		LIST_HEAD_INIT(security_hook_heads.cred_alloc_blank),
+	.cred_free =	LIST_HEAD_INIT(security_hook_heads.cred_free),
+	.cred_prepare =	LIST_HEAD_INIT(security_hook_heads.cred_prepare),
+	.cred_transfer =
+		LIST_HEAD_INIT(security_hook_heads.cred_transfer),
+	.kernel_act_as =
+		LIST_HEAD_INIT(security_hook_heads.kernel_act_as),
+	.kernel_create_files_as =
+		LIST_HEAD_INIT(security_hook_heads.kernel_create_files_as),
+	.kernel_module_request =
+		LIST_HEAD_INIT(security_hook_heads.kernel_module_request),
+	.kernel_read_file =
+		LIST_HEAD_INIT(security_hook_heads.kernel_read_file),
+	.kernel_post_read_file =
+		LIST_HEAD_INIT(security_hook_heads.kernel_post_read_file),
+	.task_fix_setuid =
+		LIST_HEAD_INIT(security_hook_heads.task_fix_setuid),
+	.task_setpgid =	LIST_HEAD_INIT(security_hook_heads.task_setpgid),
+	.task_getpgid =	LIST_HEAD_INIT(security_hook_heads.task_getpgid),
+	.task_getsid =	LIST_HEAD_INIT(security_hook_heads.task_getsid),
+	.task_getsecid =
+		LIST_HEAD_INIT(security_hook_heads.task_getsecid),
+	.task_setnice =	LIST_HEAD_INIT(security_hook_heads.task_setnice),
+	.task_setioprio =
+		LIST_HEAD_INIT(security_hook_heads.task_setioprio),
+	.task_getioprio =
+		LIST_HEAD_INIT(security_hook_heads.task_getioprio),
+	.task_prlimit =
+		LIST_HEAD_INIT(security_hook_heads.task_prlimit),
+	.task_setrlimit =
+		LIST_HEAD_INIT(security_hook_heads.task_setrlimit),
+	.task_setscheduler =
+		LIST_HEAD_INIT(security_hook_heads.task_setscheduler),
+	.task_getscheduler =
+		LIST_HEAD_INIT(security_hook_heads.task_getscheduler),
+	.task_movememory =
+		LIST_HEAD_INIT(security_hook_heads.task_movememory),
+	.task_kill =	LIST_HEAD_INIT(security_hook_heads.task_kill),
+	.task_prctl =	LIST_HEAD_INIT(security_hook_heads.task_prctl),
+	.task_to_inode =
+		LIST_HEAD_INIT(security_hook_heads.task_to_inode),
+	.ipc_permission =
+		LIST_HEAD_INIT(security_hook_heads.ipc_permission),
+	.ipc_getsecid =	LIST_HEAD_INIT(security_hook_heads.ipc_getsecid),
+	.msg_msg_alloc_security =
+		LIST_HEAD_INIT(security_hook_heads.msg_msg_alloc_security),
+	.msg_msg_free_security =
+		LIST_HEAD_INIT(security_hook_heads.msg_msg_free_security),
+	.msg_queue_alloc_security =
+		LIST_HEAD_INIT(security_hook_heads.msg_queue_alloc_security),
+	.msg_queue_free_security =
+		LIST_HEAD_INIT(security_hook_heads.msg_queue_free_security),
+	.msg_queue_associate =
+		LIST_HEAD_INIT(security_hook_heads.msg_queue_associate),
+	.msg_queue_msgctl =
+		LIST_HEAD_INIT(security_hook_heads.msg_queue_msgctl),
+	.msg_queue_msgsnd =
+		LIST_HEAD_INIT(security_hook_heads.msg_queue_msgsnd),
+	.msg_queue_msgrcv =
+		LIST_HEAD_INIT(security_hook_heads.msg_queue_msgrcv),
+	.shm_alloc_security =
+		LIST_HEAD_INIT(security_hook_heads.shm_alloc_security),
+	.shm_free_security =
+		LIST_HEAD_INIT(security_hook_heads.shm_free_security),
+	.shm_associate =
+		LIST_HEAD_INIT(security_hook_heads.shm_associate),
+	.shm_shmctl =	LIST_HEAD_INIT(security_hook_heads.shm_shmctl),
+	.shm_shmat =	LIST_HEAD_INIT(security_hook_heads.shm_shmat),
+	.sem_alloc_security =
+		LIST_HEAD_INIT(security_hook_heads.sem_alloc_security),
+	.sem_free_security =
+		LIST_HEAD_INIT(security_hook_heads.sem_free_security),
+	.sem_associate =
+		LIST_HEAD_INIT(security_hook_heads.sem_associate),
+	.sem_semctl =	LIST_HEAD_INIT(security_hook_heads.sem_semctl),
+	.sem_semop =	LIST_HEAD_INIT(security_hook_heads.sem_semop),
+	.netlink_send =	LIST_HEAD_INIT(security_hook_heads.netlink_send),
+	.d_instantiate =
+		LIST_HEAD_INIT(security_hook_heads.d_instantiate),
+	.getprocattr =	LIST_HEAD_INIT(security_hook_heads.getprocattr),
+	.setprocattr =	LIST_HEAD_INIT(security_hook_heads.setprocattr),
+	.ismaclabel =	LIST_HEAD_INIT(security_hook_heads.ismaclabel),
+	.secid_to_secctx =
+		LIST_HEAD_INIT(security_hook_heads.secid_to_secctx),
+	.secctx_to_secid =
+		LIST_HEAD_INIT(security_hook_heads.secctx_to_secid),
+	.release_secctx =
+		LIST_HEAD_INIT(security_hook_heads.release_secctx),
+	.inode_invalidate_secctx =
+		LIST_HEAD_INIT(security_hook_heads.inode_invalidate_secctx),
+	.inode_notifysecctx =
+		LIST_HEAD_INIT(security_hook_heads.inode_notifysecctx),
+	.inode_setsecctx =
+		LIST_HEAD_INIT(security_hook_heads.inode_setsecctx),
+	.inode_getsecctx =
+		LIST_HEAD_INIT(security_hook_heads.inode_getsecctx),
+#ifdef CONFIG_SECURITY_NETWORK
+	.unix_stream_connect =
+		LIST_HEAD_INIT(security_hook_heads.unix_stream_connect),
+	.unix_may_send =
+		LIST_HEAD_INIT(security_hook_heads.unix_may_send),
+	.socket_create =
+		LIST_HEAD_INIT(security_hook_heads.socket_create),
+	.socket_post_create =
+		LIST_HEAD_INIT(security_hook_heads.socket_post_create),
+	.socket_bind =	LIST_HEAD_INIT(security_hook_heads.socket_bind),
+	.socket_connect =
+		LIST_HEAD_INIT(security_hook_heads.socket_connect),
+	.socket_listen =
+		LIST_HEAD_INIT(security_hook_heads.socket_listen),
+	.socket_accept =
+		LIST_HEAD_INIT(security_hook_heads.socket_accept),
+	.socket_sendmsg =
+		LIST_HEAD_INIT(security_hook_heads.socket_sendmsg),
+	.socket_recvmsg =
+		LIST_HEAD_INIT(security_hook_heads.socket_recvmsg),
+	.socket_getsockname =
+		LIST_HEAD_INIT(security_hook_heads.socket_getsockname),
+	.socket_getpeername =
+		LIST_HEAD_INIT(security_hook_heads.socket_getpeername),
+	.socket_getsockopt =
+		LIST_HEAD_INIT(security_hook_heads.socket_getsockopt),
+	.socket_setsockopt =
+		LIST_HEAD_INIT(security_hook_heads.socket_setsockopt),
+	.socket_shutdown =
+		LIST_HEAD_INIT(security_hook_heads.socket_shutdown),
+	.socket_sock_rcv_skb =
+		LIST_HEAD_INIT(security_hook_heads.socket_sock_rcv_skb),
+	.socket_getpeersec_stream =
+		LIST_HEAD_INIT(security_hook_heads.socket_getpeersec_stream),
+	.socket_getpeersec_dgram =
+		LIST_HEAD_INIT(security_hook_heads.socket_getpeersec_dgram),
+	.sk_alloc_security =
+		LIST_HEAD_INIT(security_hook_heads.sk_alloc_security),
+	.sk_free_security =
+		LIST_HEAD_INIT(security_hook_heads.sk_free_security),
+	.sk_clone_security =
+		LIST_HEAD_INIT(security_hook_heads.sk_clone_security),
+	.sk_getsecid =	LIST_HEAD_INIT(security_hook_heads.sk_getsecid),
+	.sock_graft =	LIST_HEAD_INIT(security_hook_heads.sock_graft),
+	.inet_conn_request =
+		LIST_HEAD_INIT(security_hook_heads.inet_conn_request),
+	.inet_csk_clone =
+		LIST_HEAD_INIT(security_hook_heads.inet_csk_clone),
+	.inet_conn_established =
+		LIST_HEAD_INIT(security_hook_heads.inet_conn_established),
+	.secmark_relabel_packet =
+		LIST_HEAD_INIT(security_hook_heads.secmark_relabel_packet),
+	.secmark_refcount_inc =
+		LIST_HEAD_INIT(security_hook_heads.secmark_refcount_inc),
+	.secmark_refcount_dec =
+		LIST_HEAD_INIT(security_hook_heads.secmark_refcount_dec),
+	.req_classify_flow =
+		LIST_HEAD_INIT(security_hook_heads.req_classify_flow),
+	.tun_dev_alloc_security =
+		LIST_HEAD_INIT(security_hook_heads.tun_dev_alloc_security),
+	.tun_dev_free_security =
+		LIST_HEAD_INIT(security_hook_heads.tun_dev_free_security),
+	.tun_dev_create =
+		LIST_HEAD_INIT(security_hook_heads.tun_dev_create),
+	.tun_dev_attach_queue =
+		LIST_HEAD_INIT(security_hook_heads.tun_dev_attach_queue),
+	.tun_dev_attach =
+		LIST_HEAD_INIT(security_hook_heads.tun_dev_attach),
+	.tun_dev_open =	LIST_HEAD_INIT(security_hook_heads.tun_dev_open),
+#endif	/* CONFIG_SECURITY_NETWORK */
+
+#ifdef CONFIG_SECURITY_INFINIBAND
+	.ib_pkey_access = LIST_HEAD_INIT(security_hook_heads.ib_pkey_access),
+	.ib_alloc_security =
+		LIST_HEAD_INIT(security_hook_heads.ib_alloc_security),
+	.ib_free_security =
+		LIST_HEAD_INIT(security_hook_heads.ib_free_security),
+#endif	/* CONFIG_SECURITY_INFINIBAND */
+
+#ifdef CONFIG_SECURITY_NETWORK_XFRM
+	.xfrm_policy_alloc_security =
+		LIST_HEAD_INIT(security_hook_heads.xfrm_policy_alloc_security),
+	.xfrm_policy_clone_security =
+		LIST_HEAD_INIT(security_hook_heads.xfrm_policy_clone_security),
+	.xfrm_policy_free_security =
+		LIST_HEAD_INIT(security_hook_heads.xfrm_policy_free_security),
+	.xfrm_policy_delete_security =
+		LIST_HEAD_INIT(security_hook_heads.xfrm_policy_delete_security),
+	.xfrm_state_alloc =
+		LIST_HEAD_INIT(security_hook_heads.xfrm_state_alloc),
+	.xfrm_state_alloc_acquire =
+		LIST_HEAD_INIT(security_hook_heads.xfrm_state_alloc_acquire),
+	.xfrm_state_free_security =
+		LIST_HEAD_INIT(security_hook_heads.xfrm_state_free_security),
+	.xfrm_state_delete_security =
+		LIST_HEAD_INIT(security_hook_heads.xfrm_state_delete_security),
+	.xfrm_policy_lookup =
+		LIST_HEAD_INIT(security_hook_heads.xfrm_policy_lookup),
+	.xfrm_state_pol_flow_match =
+		LIST_HEAD_INIT(security_hook_heads.xfrm_state_pol_flow_match),
+	.xfrm_decode_session =
+		LIST_HEAD_INIT(security_hook_heads.xfrm_decode_session),
+#endif	/* CONFIG_SECURITY_NETWORK_XFRM */
+#ifdef CONFIG_KEYS
+	.key_alloc =	LIST_HEAD_INIT(security_hook_heads.key_alloc),
+	.key_free =	LIST_HEAD_INIT(security_hook_heads.key_free),
+	.key_permission =
+		LIST_HEAD_INIT(security_hook_heads.key_permission),
+	.key_getsecurity =
+		LIST_HEAD_INIT(security_hook_heads.key_getsecurity),
+#endif	/* CONFIG_KEYS */
+#ifdef CONFIG_AUDIT
+	.audit_rule_init =
+		LIST_HEAD_INIT(security_hook_heads.audit_rule_init),
+	.audit_rule_known =
+		LIST_HEAD_INIT(security_hook_heads.audit_rule_known),
+	.audit_rule_match =
+		LIST_HEAD_INIT(security_hook_heads.audit_rule_match),
+	.audit_rule_free =
+		LIST_HEAD_INIT(security_hook_heads.audit_rule_free),
+#endif /* CONFIG_AUDIT */
+};
-- 
2.7.4

