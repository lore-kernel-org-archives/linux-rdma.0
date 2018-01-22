From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next v5 3/8] RDMA/restrack: Add general infrastructure to track RDMA resources
Date: Mon, 22 Jan 2018 14:51:14 +0200
Message-ID: <20180122125119.26419-4-leon@kernel.org>
References: <20180122125119.26419-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180122125119.26419-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The RDMA subsystem has very strict set of objects to work on it,
but it completely lacks tracking facilities and no visibility of
resource utilization.

The following patch adds such infrastructure to keep track of RDMA
resources to help with debugging of user space applications. The primary
user of this infrastructure is RDMA nldev netlink (following patches),
but it is not limited too.

At this stage, the main three objects (PD, CQ and QP) are added,
and more will be added later.

Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/core/Makefile    |   2 +-
 drivers/infiniband/core/core_priv.h |   1 +
 drivers/infiniband/core/device.c    |   7 ++
 drivers/infiniband/core/restrack.c  | 135 +++++++++++++++++++++++++++++++++++
 include/rdma/ib_verbs.h             |  12 ++++
 include/rdma/restrack.h             | 136 ++++++++++++++++++++++++++++++++++++
 6 files changed, 292 insertions(+), 1 deletion(-)
 create mode 100644 drivers/infiniband/core/restrack.c
 create mode 100644 include/rdma/restrack.h

diff --git a/drivers/infiniband/core/Makefile b/drivers/infiniband/core/Makefile
index 504b926552c6..f69833db0a32 100644
--- a/drivers/infiniband/core/Makefile
+++ b/drivers/infiniband/core/Makefile
@@ -12,7 +12,7 @@ ib_core-y :=			packer.o ud_header.o verbs.o cq.o rw.o sysfs.o \
 				device.o fmr_pool.o cache.o netlink.o \
 				roce_gid_mgmt.o mr_pool.o addr.o sa_query.o \
 				multicast.o mad.o smi.o agent.o mad_rmpp.o \
-				security.o nldev.o
+				security.o nldev.o restrack.o
 
 ib_core-$(CONFIG_INFINIBAND_USER_MEM) += umem.o
 ib_core-$(CONFIG_INFINIBAND_ON_DEMAND_PAGING) += umem_odp.o
diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index aef9aa0ac0e6..2b1372da708a 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -40,6 +40,7 @@
 #include <rdma/ib_verbs.h>
 #include <rdma/opa_addr.h>
 #include <rdma/ib_mad.h>
+#include <rdma/restrack.h>
 #include "mad_priv.h"
 
 /* Total number of ports combined across all struct ib_devices's */
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 2826e06311a5..c3e389f8c99a 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -263,6 +263,11 @@ struct ib_device *ib_alloc_device(size_t size)
 	if (!device)
 		return NULL;
 
+	if (rdma_restrack_init(&device->res)) {
+		kfree(device);
+		return NULL;
+	}
+
 	device->dev.class = &ib_class;
 	device_initialize(&device->dev);
 
@@ -596,6 +601,8 @@ void ib_unregister_device(struct ib_device *device)
 	}
 	up_read(&lists_rwsem);
 
+	rdma_restrack_clean(&device->res);
+
 	ib_device_unregister_rdmacg(device);
 	ib_device_unregister_sysfs(device);
 
diff --git a/drivers/infiniband/core/restrack.c b/drivers/infiniband/core/restrack.c
new file mode 100644
index 000000000000..a1eb6e3e7ec6
--- /dev/null
+++ b/drivers/infiniband/core/restrack.c
@@ -0,0 +1,135 @@
+/* SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause) */
+/*
+ * Copyright (c) 2017-2018 Mellanox Technologies. All rights reserved.
+ */
+
+#include <rdma/ib_verbs.h>
+#include <rdma/restrack.h>
+#include <linux/srcu.h>
+#include <linux/mutex.h>
+#include <linux/sched/task.h>
+#include <linux/uaccess.h>
+#include <linux/pid_namespace.h>
+
+int rdma_restrack_init(struct rdma_restrack_root *res)
+{
+	mutex_init(&res->mutex);
+	return init_srcu_struct(&res->srcu);
+}
+
+void rdma_restrack_clean(struct rdma_restrack_root *res)
+{
+	cleanup_srcu_struct(&res->srcu);
+	WARN_ON_ONCE(!hash_empty(res->hash));
+}
+
+int rdma_restrack_count(struct rdma_restrack_root *res,
+			enum rdma_restrack_type type,
+			struct pid_namespace *ns)
+{
+	struct rdma_restrack_entry *e;
+	u32 cnt = 0;
+	int key;
+
+	key = srcu_read_lock(&res->srcu);
+	hash_for_each_possible_rcu(res->hash, e, node, type) {
+		if (ns == &init_pid_ns ||
+		    (!rdma_is_kernel_res(e) &&
+		     ns == task_active_pid_ns(e->task)))
+			cnt++;
+	}
+	srcu_read_unlock(&res->srcu, key);
+	return cnt;
+}
+EXPORT_SYMBOL(rdma_restrack_count);
+
+void rdma_restrack_add(struct rdma_restrack_entry *res)
+{
+	enum rdma_restrack_type type = res->type;
+	struct ib_device *dev;
+	const char *caller;
+	struct ib_pd *pd;
+	struct ib_cq *cq;
+	struct ib_qp *qp;
+
+	switch (type) {
+	case RDMA_RESTRACK_PD:
+		pd = container_of(res, struct ib_pd, res);
+		dev = pd->device;
+		caller = pd->caller;
+		break;
+	case RDMA_RESTRACK_CQ:
+		cq = container_of(res, struct ib_cq, res);
+		dev = cq->device;
+		caller = cq->caller;
+		break;
+	case RDMA_RESTRACK_QP:
+		qp = container_of(res, struct ib_qp, res);
+		dev = qp->device;
+		caller = qp->pd->caller;
+		break;
+	default:
+		WARN_ONCE(true, "Wrong resource tracking type %u\n", type);
+		return;
+	}
+
+	res->kern_name = NULL;
+	res->task = NULL;
+
+	if (!uaccess_kernel()) {
+		get_task_struct(current);
+		res->task = current;
+	} else {
+		res->kern_name = caller;
+	}
+
+	res->valid = true;
+
+	mutex_lock(&dev->res.mutex);
+	hash_add_rcu(dev->res.hash, &res->node, res->type);
+	mutex_unlock(&dev->res.mutex);
+}
+EXPORT_SYMBOL(rdma_restrack_add);
+
+void rdma_restrack_del(struct rdma_restrack_entry *res)
+{
+	enum rdma_restrack_type type;
+	struct ib_device *dev;
+	struct ib_pd *pd;
+	struct ib_cq *cq;
+	struct ib_qp *qp;
+
+	if (!res->valid)
+		return;
+
+	type = res->type;
+
+	switch (type) {
+	case RDMA_RESTRACK_PD:
+		pd = container_of(res, struct ib_pd, res);
+		dev = pd->device;
+		break;
+	case RDMA_RESTRACK_CQ:
+		cq = container_of(res, struct ib_cq, res);
+		dev = cq->device;
+		break;
+	case RDMA_RESTRACK_QP:
+		qp = container_of(res, struct ib_qp, res);
+		dev = qp->device;
+		break;
+	default:
+		WARN_ONCE(true, "Wrong resource tracking type %u\n", type);
+		return;
+	}
+
+	mutex_lock(&dev->res.mutex);
+	hash_del_rcu(&res->node);
+	mutex_unlock(&dev->res.mutex);
+
+	res->valid = false;
+
+	if (res->task)
+		put_task_struct(res->task);
+	synchronize_srcu(&dev->res.srcu);
+}
+EXPORT_SYMBOL(rdma_restrack_del);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 4cb18bcc2f34..23b0188a766c 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -63,6 +63,7 @@
 #include <linux/uaccess.h>
 #include <linux/cgroup_rdma.h>
 #include <uapi/rdma/ib_user_verbs.h>
+#include <rdma/restrack.h>
 
 #define IB_FW_VERSION_NAME_MAX	ETHTOOL_FWVERS_LEN
 
@@ -1531,6 +1532,7 @@ struct ib_pd {
 	 */
 	struct ib_mr	       *__internal_mr;
 	const char		*caller;
+	struct rdma_restrack_entry res;
 };
 
 struct ib_xrcd {
@@ -1575,6 +1577,7 @@ struct ib_cq {
 	 * Implementation details of the RDMA core, don't use in drivers:
 	 */
 	const char		*caller;
+	struct rdma_restrack_entry res;
 };
 
 struct ib_srq {
@@ -1751,6 +1754,11 @@ struct ib_qp {
 	struct ib_rwq_ind_table *rwq_ind_tbl;
 	struct ib_qp_security  *qp_sec;
 	u8			port;
+
+	/*
+	 * Implementation details of the RDMA core, don't use in drivers:
+	 */
+	struct rdma_restrack_entry     res;
 };
 
 struct ib_mr {
@@ -2357,6 +2365,10 @@ struct ib_device {
 #endif
 
 	u32                          index;
+	/*
+	 * Implementation details of the RDMA core, don't use in drivers
+	 */
+	struct rdma_restrack_root     res;
 
 	/**
 	 * The following mandatory functions are used only at device
diff --git a/include/rdma/restrack.h b/include/rdma/restrack.h
new file mode 100644
index 000000000000..e1c51a786be3
--- /dev/null
+++ b/include/rdma/restrack.h
@@ -0,0 +1,136 @@
+/* SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause) */
+/*
+ * Copyright (c) 2017-2018 Mellanox Technologies. All rights reserved.
+ */
+
+#ifndef _RDMA_RESTRACK_H_
+#define _RDMA_RESTRACK_H_
+
+#include <linux/typecheck.h>
+#include <linux/srcu.h>
+#include <linux/refcount.h>
+#include <linux/sched.h>
+
+/**
+ * enum rdma_restrack_type - HW objects to track
+ */
+enum rdma_restrack_type {
+	/**
+	 * @RDMA_RESTRACK_PD: Protection domain (PD)
+	 */
+	RDMA_RESTRACK_PD,
+	/**
+	 * @RDMA_RESTRACK_CQ: Completion queue (CQ)
+	 */
+	RDMA_RESTRACK_CQ,
+	/**
+	 * @RDMA_RESTRACK_QP: Queue pair (QP)
+	 */
+	RDMA_RESTRACK_QP,
+	/**
+	 * @RDMA_RESTRACK_MAX: Last entry, used for array dclarations
+	 */
+	RDMA_RESTRACK_MAX
+};
+
+#define RDMA_RESTRACK_HASH_BITS	8
+/**
+ * struct rdma_restrack_root - main resource tracking management
+ * entity, per-device
+ */
+struct rdma_restrack_root {
+	/**
+	 * @srcu: sleepable RCU to protect object data.
+	 */
+	struct srcu_struct	srcu;
+	/*
+	 * @mutex: Protect add/delete list operations
+	 */
+	struct mutex		mutex;
+	/**
+	 * @hash: global database for all resources per-device
+	 */
+	DECLARE_HASHTABLE(hash, RDMA_RESTRACK_HASH_BITS);
+};
+
+/**
+ * struct rdma_restrack_entry - metadata per-entry
+ */
+struct rdma_restrack_entry {
+	/**
+	 * @valid: validity indicator
+	 *
+	 * The entries are filled during rdma_restrack_add,
+	 * can be attempted to be free during rdma_restrack_del.
+	 *
+	 * As an example for that, see mlx5 QPs with type MLX5_IB_QPT_HW_GSI
+	 */
+	bool			valid;
+	/**
+	 * @task: owner of resource tracking entity
+	 *
+	 * There are two types of entities: created by user and created
+	 * by kernel.
+	 *
+	 * This is relevant for the entities created by users.
+	 * For the entities created by kernel, this pointer will be NULL.
+	 */
+	struct task_struct	*task;
+	/**
+	 * @kern_name: name of owner for the kernel created entities.
+	 */
+	const char		*kern_name;
+	/**
+	 * @node: hash table entry
+	 */
+	struct hlist_node	node;
+	/**
+	 * @type: various objects in restrack database
+	 */
+	enum rdma_restrack_type	type;
+};
+
+/**
+ * rdma_restrack_init() - initialize resource tracking
+ * @res:  resource tracking root
+ */
+int rdma_restrack_init(struct rdma_restrack_root *res);
+
+/**
+ * rdma_restrack_clean() - clean resource tracking
+ * @res:  resource tracking root
+ */
+void rdma_restrack_clean(struct rdma_restrack_root *res);
+
+/**
+ * rdma_restrack_count() - the current usage of specific object
+ * @res:  resource entry
+ * @type: actual type of object to operate
+ * @ns:   PID namespace
+ */
+int rdma_restrack_count(struct rdma_restrack_root *res,
+			enum rdma_restrack_type type,
+			struct pid_namespace *ns);
+
+/**
+ * rdma_restrack_add() - add object to the reource tracking database
+ * @res:  resource entry
+ */
+void rdma_restrack_add(struct rdma_restrack_entry *res);
+
+/**
+ * rdma_restrack_del() - delete object from the reource tracking database
+ * @res:  resource entry
+ * @type: actual type of object to operate
+ */
+void rdma_restrack_del(struct rdma_restrack_entry *res);
+
+/**
+ * rdma_is_kernel_res() - check the owner of resource
+ * @res:  resource entry
+ */
+static inline bool rdma_is_kernel_res(struct rdma_restrack_entry *res)
+{
+	return !res->task;
+}
+#endif /* _RDMA_RESTRACK_H_ */
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
