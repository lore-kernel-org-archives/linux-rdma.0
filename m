From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next v4 1/7] RDMA/restrack: Add general infrastructure to track RDMA resources
Date: Mon, 15 Jan 2018 17:12:49 +0200
Message-ID: <20180115151255.30167-2-leon@kernel.org>
References: <20180115151255.30167-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180115151255.30167-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
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

There are four new functions in use by RDMA/core:
 * rdma_restrack_init(...)   - initializes restrack database
 * rdma_restrack_clean(...)  - cleans restrack database
 * rdma_restrack_add(...)    - adds object to be tracked
 * rdma_restrack_del(...)    - removes object from tracking

3 functions and one iterator visible to kernel users:
 * rdma_restrack_count(...) - returns number of allocated objects of
			      specific type
 * rdma_restrack_lock(...)  - Lock primitive to protect access to list
			      of resources
 * rdma_restrack_unlock(...)- Unlock primitive to protect access to list
			      of resources
 * for_each_res_safe(...)   - iterates over all relevant objects in
   the restrack database.

Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/core/Makefile    |   2 +-
 drivers/infiniband/core/core_priv.h |   1 +
 drivers/infiniband/core/device.c    |   7 ++
 drivers/infiniband/core/restrack.c  | 182 +++++++++++++++++++++++++++++++++
 include/rdma/ib_verbs.h             |  17 +++-
 include/rdma/restrack.h             | 197 ++++++++++++++++++++++++++++++++++++
 6 files changed, 404 insertions(+), 2 deletions(-)
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
index 000000000000..879b79ea31da
--- /dev/null
+++ b/drivers/infiniband/core/restrack.c
@@ -0,0 +1,182 @@
+/*
+ * Copyright (c) 2017 Mellanox Technologies. All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions are met:
+ *
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ * 3. Neither the names of the copyright holders nor the names of its
+ *    contributors may be used to endorse or promote products derived from
+ *    this software without specific prior written permission.
+ *
+ * Alternatively, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") version 2 as published by the Free
+ * Software Foundation.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+ * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
+ * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+ * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
+ * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
+ * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+ * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#include <rdma/ib_verbs.h>
+#include <rdma/restrack.h>
+#include <linux/rculist.h>
+#include <linux/sched/task.h>
+
+int rdma_restrack_init(struct rdma_restrack_root *res)
+{
+	int i = 0;
+
+	for (; i < _RDMA_RESTRACK_MAX; i++) {
+		refcount_set(&res->cnt[i], 1);
+		INIT_LIST_HEAD_RCU(&res->list[i]);
+		init_rwsem(&res->rwsem[i]);
+	}
+
+	return 0;
+}
+
+void rdma_restrack_clean(struct rdma_restrack_root *res)
+{
+	int i = 0;
+
+	for (; i < _RDMA_RESTRACK_MAX; i++) {
+		WARN_ON_ONCE(!refcount_dec_and_test(&res->cnt[i]));
+		WARN_ON_ONCE(!list_empty(&res->list[i]));
+	}
+}
+
+static bool is_restrack_valid(enum rdma_restrack_obj type)
+{
+	return !(type >= _RDMA_RESTRACK_MAX);
+}
+
+int rdma_restrack_count(struct rdma_restrack_root *res,
+			enum rdma_restrack_obj type)
+{
+	if (!is_restrack_valid(type))
+		return 0;
+
+	/*
+	 * The counter was initialized to 1 at the beginning.
+	 */
+	return refcount_read(&res->cnt[type]) - 1;
+}
+EXPORT_SYMBOL(rdma_restrack_count);
+
+void rdma_restrack_add(struct rdma_restrack_entry *res,
+		       enum rdma_restrack_obj type, const char *comm)
+{
+	struct ib_device *dev;
+	struct ib_pd *pd;
+	struct ib_cq *cq;
+	struct ib_qp *qp;
+
+	if (!is_restrack_valid(type))
+		return;
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
+		/* unreachable */
+		return;
+	}
+
+	if (init_srcu_struct(&res->srcu))
+		/*
+		 * We are not returning error, because there is nothing
+		 * we can do it in such case, it is already too late to
+		 * crash the driver just of failure in resource tracking.
+		 *
+		 * Simply leave this resource as not valid.
+		 */
+		return;
+
+	if (!comm || !strlen(comm)) {
+		res->kern_name = NULL;
+		get_task_struct(current);
+		res->task = current;
+	} else {
+		res->task = NULL;
+		res->kern_name = kstrdup_const(comm, GFP_KERNEL);
+		if (!res->kern_name)
+			goto out;
+	}
+
+	refcount_inc(&dev->res.cnt[type]);
+
+	down_write(&dev->res.rwsem[type]);
+	list_add(&res->list, &dev->res.list[type]);
+	res->valid = true;
+	up_write(&dev->res.rwsem[type]);
+	return;
+
+out:
+	res->valid = false;
+	cleanup_srcu_struct(&res->srcu);
+}
+EXPORT_SYMBOL(rdma_restrack_add);
+
+void rdma_restrack_del(struct rdma_restrack_entry *res,
+		       enum rdma_restrack_obj type)
+{
+	struct ib_device *dev;
+	struct ib_pd *pd;
+	struct ib_cq *cq;
+	struct ib_qp *qp;
+
+	if (!is_restrack_valid(type) || !res->valid)
+		return;
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
+		/* unreachable */
+		return;
+	}
+
+	refcount_dec(&dev->res.cnt[type]);
+	down_write(&dev->res.rwsem[type]);
+	list_del(&res->list);
+	res->valid = false;
+	kfree_const(res->kern_name);
+	put_task_struct(res->task);
+	up_write(&dev->res.rwsem[type]);
+	synchronize_srcu(&res->srcu);
+	cleanup_srcu_struct(&res->srcu);
+}
+EXPORT_SYMBOL(rdma_restrack_del);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index f25c03687ee9..271265cd7c1a 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -63,6 +63,7 @@
 #include <linux/uaccess.h>
 #include <linux/cgroup_rdma.h>
 #include <uapi/rdma/ib_user_verbs.h>
+#include <rdma/restrack.h>
 
 #define IB_FW_VERSION_NAME_MAX	ETHTOOL_FWVERS_LEN
 
@@ -1527,9 +1528,10 @@ struct ib_pd {
 	u32			unsafe_global_rkey;
 
 	/*
-	 * Implementation details of the RDMA core, don't use in drivers:
+	 * Implementation details of the RDMA core, don't use in the drivers
 	 */
 	struct ib_mr	       *__internal_mr;
+	struct rdma_restrack_entry res;
 };
 
 struct ib_xrcd {
@@ -1570,6 +1572,10 @@ struct ib_cq {
 		struct irq_poll		iop;
 		struct work_struct	work;
 	};
+	/*
+	 * Internal to RDMA/core, don't use in the drivers
+	 */
+	struct rdma_restrack_entry res;
 };
 
 struct ib_srq {
@@ -1746,6 +1752,11 @@ struct ib_qp {
 	struct ib_rwq_ind_table *rwq_ind_tbl;
 	struct ib_qp_security  *qp_sec;
 	u8			port;
+
+	/*
+	 * Internal to RDMA/core, don't use in the drivers
+	 */
+	struct rdma_restrack_entry     res;
 };
 
 struct ib_mr {
@@ -2352,6 +2363,10 @@ struct ib_device {
 #endif
 
 	u32                          index;
+	/*
+	 * Implementation details of the RDMA core, don't use in the drivers
+	 */
+	struct rdma_restrack_root     res;
 
 	/**
 	 * The following mandatory functions are used only at device
diff --git a/include/rdma/restrack.h b/include/rdma/restrack.h
new file mode 100644
index 000000000000..fa9a2f792897
--- /dev/null
+++ b/include/rdma/restrack.h
@@ -0,0 +1,197 @@
+/*
+ * Copyright (c) 2017 Mellanox Technologies. All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions are met:
+ *
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ * 3. Neither the names of the copyright holders nor the names of its
+ *    contributors may be used to endorse or promote products derived from
+ *    this software without specific prior written permission.
+ *
+ * Alternatively, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") version 2 as published by the Free
+ * Software Foundation.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+ * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
+ * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+ * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
+ * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
+ * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+ * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGE.
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
+ * enum rdma_restrack_obj - HW objects to track
+ */
+enum rdma_restrack_obj {
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
+	/* private: counts number of elements, always last */
+	_RDMA_RESTRACK_MAX
+};
+
+/**
+ * struct rdma_restrack_root - main resource tracking management
+ * entity, per-device
+ */
+struct rdma_restrack_root {
+	/**
+	 * @cnt: global counter to avoid the need to count number
+	 * of elements in the object's list.
+	 *
+	 * It can be different from the list_count, because we are
+	 * not taking lock during counter increment and don't
+	 * synchronize the RCU.
+	 */
+	refcount_t		cnt[_RDMA_RESTRACK_MAX];
+	/**
+	 * @list: linked list of all entries per-object
+	 */
+	struct list_head	list[_RDMA_RESTRACK_MAX];
+	/* private: Internal read/write lock.
+	 * It is needed to protect the add/delete list operations.
+	 */
+	struct rw_semaphore	rwsem[_RDMA_RESTRACK_MAX];
+};
+
+/**
+ * struct rdma_restrack_entry - metadata per-entry
+ */
+struct rdma_restrack_entry {
+	/**
+	 * @list: linked list between entries
+	 */
+	struct list_head	list;
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
+	 * @srcu: sleepable RCU to protect object data.
+	 */
+	struct srcu_struct	srcu;
+	/**
+	 * @task: owner of resource tracking entity
+	 *
+	 * There are two types of entities: created by user and created
+	 * by kernel.
+	 *
+	 * This is relevant for the entities created by users.
+	 * For the entieies created by kernel, this pointer will be NULL.
+	 */
+	struct task_struct	*task;
+	/**
+	 * @kern_name: name of owner for the kernel created entities.
+	 */
+	const char		*kern_name;
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
+ * for_each_res_safe() - resource iterator
+ * @r:    resource entity
+ * @n:    next resrouce entity
+ * @type: actual type of object to operate
+ * @dev:  IB device to operate on
+ * Use rdma_restrack_lock/rdma_restrack_unlock to protect it
+ */
+#define for_each_res_safe(r, n, type, dev) \
+	list_for_each_entry_safe(r, n, &(dev)->res.list[type], list)
+
+/**
+ * rdma_restrack_lock() - lock to protect reads of restrack_obj structs
+ * @res:  resource entry
+ * @type: actual type of object to operate
+ */
+static inline void rdma_restrack_lock(struct rdma_restrack_root *res,
+				      enum rdma_restrack_obj type)
+{
+	down_read(&res->rwsem[type]);
+}
+
+/**
+ * rdma_restrack_unlock() - unlock to protect reads of restrack_obj structs
+ * @res:  resource entry
+ * @type: actual type of object to operate
+ */
+static inline void rdma_restrack_unlock(struct rdma_restrack_root *res,
+					enum rdma_restrack_obj type)
+{
+	up_read(&res->rwsem[type]);
+}
+
+/**
+ * rdma_restrack_count() - the current usage of specific object
+ * @res:  resource entry
+ * @type: actual type of object to operate
+ *
+ * Users can get device utilization by comparing with max_objname
+ * (e.g. max_qp, max_pd e.t.c),
+ */
+int rdma_restrack_count(struct rdma_restrack_root *res,
+			enum rdma_restrack_obj type);
+
+/**
+ * rdma_restrack_add() - add object to the reource tracking database
+ * @res:  resource entry
+ * @type: actual type of object to operate
+ * @comm: the owner of this resource. For kernel created resources,
+ *        there is a need to pass a name here, which will be visible to users.
+ *        For user created resources, there is a need to pass NULL here and the
+ *        owner will be taken from current struct task_struct.
+ */
+void rdma_restrack_add(struct rdma_restrack_entry *res,
+		       enum rdma_restrack_obj type, const char *comm);
+
+/**
+ * rdma_restrack_add() - delete object from the reource tracking database
+ * @res:  resource entry
+ * @type: actual type of object to operate
+ */
+void rdma_restrack_del(struct rdma_restrack_entry *res,
+		       enum rdma_restrack_obj type);
+#endif /* _RDMA_RESTRACK_H_ */
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
