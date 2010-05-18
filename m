From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH V2 1/4] ib_core: changes to support XRC RCV qp's
Date: Tue, 18 May 2010 14:55:02 +0300
Message-ID: <201005181455.02623.jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The core layer does reference counting on XRC RCV qp's,
and also is responsible for distributing async events generated
for XRC RCV qp's to all registered processes.

Methods:  ib_create_xrc_rcv_qp, ib_destroy_xrc_rcv_qp, ib_reg_xrc_rcv_qp
and ib_unreg_xrc_rcv_qp -- and a XRC RCV QP cleanup function called
when a process terminates (this function removes all registrations for
that process, and destroys any XRC RCV QPs which have no processes registered
after the cleanup).

All other functions serve to support keeping track of the XRC RCV qp's
(in a radix tree), and to distribute the async events.

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 drivers/infiniband/core/device.c |    6 +-
 drivers/infiniband/core/verbs.c  |  275 ++++++++++++++++++++++++++++++++++++++
 include/rdma/ib_verbs.h          |   45 ++++++
 3 files changed, 325 insertions(+), 1 deletions(-)

Index: infiniband/drivers/infiniband/core/device.c
===================================================================
--- infiniband.orig/drivers/infiniband/core/device.c
+++ infiniband/drivers/infiniband/core/device.c
@@ -172,9 +172,13 @@ static int end_port(struct ib_device *de
  */
 struct ib_device *ib_alloc_device(size_t size)
 {
+	struct ib_device *ibdev;
 	BUG_ON(size < sizeof (struct ib_device));
 
-	return kzalloc(size, GFP_KERNEL);
+	ibdev = kzalloc(size, GFP_KERNEL);
+	if (ibdev)
+		ib_xrc_rcv_qp_table_init(ibdev);
+	return ibdev;
 }
 EXPORT_SYMBOL(ib_alloc_device);
 
Index: infiniband/drivers/infiniband/core/verbs.c
===================================================================
--- infiniband.orig/drivers/infiniband/core/verbs.c
+++ infiniband/drivers/infiniband/core/verbs.c
@@ -39,6 +39,8 @@
 #include <linux/errno.h>
 #include <linux/err.h>
 #include <linux/string.h>
+#include <linux/list.h>
+#include <linux/slab.h>
 
 #include <rdma/ib_verbs.h>
 #include <rdma/ib_cache.h>
@@ -1030,3 +1032,280 @@ int ib_dealloc_xrcd(struct ib_xrcd *xrcd
 	return xrcd->device->dealloc_xrcd(xrcd);
 }
 EXPORT_SYMBOL(ib_dealloc_xrcd);
+
+void ib_xrc_rcv_qp_table_init(struct ib_device *dev)
+{
+	spin_lock_init(&dev->xrc_rcv_qp_table_lock);
+	INIT_RADIX_TREE(&dev->xrc_rcv_qp_table, GFP_ATOMIC);
+}
+
+struct ib_xrc_rcv_qp_table_entry *
+ib_xrc_rcv_tbl_find(struct ib_device *dev, u32 qpn)
+{
+        return radix_tree_lookup(&dev->xrc_rcv_qp_table, qpn);
+}
+
+int ib_xrc_rcv_qp_table_new(struct ib_device *dev, void *event_handler,
+			    u32 qpn, struct ib_xrcd *xrcd, void *context)
+{
+	struct ib_xrc_rcv_qp_table_entry *qp;
+	struct ib_xrc_rcv_reg_entry *reg_entry;
+	unsigned long flags;
+	int rc = -ENOMEM;
+
+	qp = kzalloc(sizeof *qp, GFP_ATOMIC);
+	if (!qp)
+		return -ENOMEM;
+
+	reg_entry = kzalloc(sizeof *reg_entry, GFP_KERNEL);
+	if (!reg_entry)
+		goto out_alloc;
+
+	INIT_LIST_HEAD(&qp->list);
+	qp->event_handler = event_handler;
+	qp->xrcd = xrcd;
+	qp->qpn = qpn;
+
+	reg_entry->context = context;
+	list_add_tail(&reg_entry->list, &qp->list);
+
+	spin_lock_irqsave(&dev->xrc_rcv_qp_table_lock, flags);
+	rc = radix_tree_insert(&dev->xrc_rcv_qp_table, qpn, qp);
+	spin_unlock_irqrestore(&dev->xrc_rcv_qp_table_lock, flags);
+	if (rc)
+		goto out_radix;
+	atomic_inc(&xrcd->usecnt);
+	return 0;
+
+out_radix:
+	kfree(reg_entry);
+out_alloc:
+	kfree(qp);
+	return rc;
+}
+EXPORT_SYMBOL(ib_xrc_rcv_qp_table_new);
+
+
+int ib_xrc_rcv_qp_table_add_reg_entry(struct ib_device *dev, u32 qpn,
+				      void *context)
+{
+	struct ib_xrc_rcv_reg_entry *reg_entry, *tmp;
+	struct ib_xrc_rcv_qp_table_entry *qp;
+	unsigned long flags;
+	int err = -EINVAL, found = 0;
+
+	reg_entry = kzalloc(sizeof *reg_entry, GFP_KERNEL);
+	if (!reg_entry)
+		return -ENOMEM;
+	reg_entry->context = context;
+
+	spin_lock_irqsave(&dev->xrc_rcv_qp_table_lock, flags);
+	qp = ib_xrc_rcv_tbl_find(dev, qpn);
+	if (unlikely(!qp))
+		goto free_out;
+	list_for_each_entry(tmp, &qp->list, list)
+		if (tmp->context == context) {
+			found = 1;
+			break;
+		}
+	/* add only a single entry per user context */
+	if (unlikely(found)) {
+		err = 0;
+		goto free_out;
+	}
+	atomic_inc(&qp->xrcd->usecnt);
+	list_add_tail(&reg_entry->list, &qp->list);
+	spin_unlock_irqrestore(&dev->xrc_rcv_qp_table_lock, flags);
+	return 0;
+
+free_out:
+	spin_unlock_irqrestore(&dev->xrc_rcv_qp_table_lock, flags);
+	kfree(reg_entry);
+	return err;
+}
+EXPORT_SYMBOL(ib_xrc_rcv_qp_table_add_reg_entry);
+
+int ib_xrc_rcv_qp_table_remove_reg_entry(struct ib_device *dev, u32 qpn,
+					 void *context)
+{
+	struct ib_xrc_rcv_reg_entry *uninitialized_var(reg_entry), *tmp;
+	struct ib_xrc_rcv_qp_table_entry *qp;
+	unsigned long flags;
+	int found = 0, destroy = 0;
+
+	spin_lock_irqsave(&dev->xrc_rcv_qp_table_lock, flags);
+	qp = ib_xrc_rcv_tbl_find(dev, qpn);
+	if (unlikely(!qp))
+		goto out;
+	if (!list_empty(&qp->list)) {
+		list_for_each_entry_safe(reg_entry, tmp,
+					 &qp->list, list) {
+			if (reg_entry->context == context) {
+				list_del(&reg_entry->list);
+				found = 1;
+				atomic_dec(&qp->xrcd->usecnt);
+				break;
+			}
+		}
+
+		if (unlikely(!found))
+			goto out;
+	}
+
+	/* now, remove the entry if the list is empty */
+	if (unlikely(list_empty(&qp->list))) {
+		destroy = 1;
+		radix_tree_delete(&dev->xrc_rcv_qp_table, qpn);
+	}
+	spin_unlock_irqrestore(&dev->xrc_rcv_qp_table_lock, flags);
+	if (destroy) {
+		dev->destroy_xrc_rcv_qp(qp->xrcd, qpn);
+		kfree(qp);
+	}
+	if (found)
+		kfree(reg_entry);
+	return 0;
+
+out:
+	spin_unlock_irqrestore(&dev->xrc_rcv_qp_table_lock, flags);
+	return -EINVAL;
+}
+EXPORT_SYMBOL(ib_xrc_rcv_qp_table_remove_reg_entry);
+
+int ib_xrc_rcv_qp_table_remove(struct ib_device *dev, u32 qpn)
+{
+	struct ib_xrc_rcv_reg_entry *reg_entry, *tmp;
+	struct ib_xrc_rcv_qp_table_entry *qp;
+	struct list_head xrc_local;
+	unsigned long flags;
+
+	INIT_LIST_HEAD(&xrc_local);
+
+	spin_lock_irqsave(&dev->xrc_rcv_qp_table_lock, flags);
+
+	qp = ib_xrc_rcv_tbl_find(dev, qpn);
+	if (unlikely(!qp))
+		goto out;
+	/* ASSERT(!list_empty(&qp->list)); */
+	list_replace_init(&qp->list, &xrc_local);
+	radix_tree_delete(&dev->xrc_rcv_qp_table, qpn);
+	spin_unlock_irqrestore(&dev->xrc_rcv_qp_table_lock, flags);
+
+	dev->destroy_xrc_rcv_qp(qp->xrcd, qpn);
+	kfree(qp);
+	list_for_each_entry_safe(reg_entry, tmp, &xrc_local, list) {
+		list_del(&reg_entry->list);
+		kfree(reg_entry);
+		atomic_dec(&qp->xrcd->usecnt);
+	}
+	return 0;
+
+out:
+	spin_unlock_irqrestore(&dev->xrc_rcv_qp_table_lock, flags);
+	return -EINVAL;
+}
+EXPORT_SYMBOL(ib_xrc_rcv_qp_table_remove);
+
+/* cleanup.  If context is NULL, clean up everything */
+void ib_xrc_rcv_table_cleanup(struct ib_device *dev, void *context)
+{
+	struct ib_xrc_rcv_qp_table_entry *qp, *qp1, *qp2;
+	struct ib_xrc_rcv_reg_entry *reg_entry, *tmp;
+	struct list_head delete_list, qp_del_list;
+	unsigned long flags, next = 0;
+
+	INIT_LIST_HEAD(&delete_list);
+	INIT_LIST_HEAD(&qp_del_list);
+
+	spin_lock_irqsave(&dev->xrc_rcv_qp_table_lock, flags);
+	while (radix_tree_gang_lookup(&dev->xrc_rcv_qp_table, (void **) &qp,
+				      next, 1)) {
+		next = qp->qpn + 1;
+		list_for_each_entry_safe(reg_entry, tmp, &qp->list, list) {
+			if (!context || reg_entry->context == context) {
+				atomic_dec(&qp->xrcd->usecnt);
+				list_move_tail(&reg_entry->list, &delete_list);
+			}
+		}
+		if (unlikely(list_empty(&qp->list))) {
+			qp = radix_tree_delete(&dev->xrc_rcv_qp_table, qp->qpn);
+			if (qp)
+				list_add(&qp->list, &qp_del_list);
+		}
+	}
+	spin_unlock_irqrestore(&dev->xrc_rcv_qp_table_lock, flags);
+
+	list_for_each_entry_safe(reg_entry, tmp, &delete_list, list) {
+		list_del(&reg_entry->list);
+		kfree(reg_entry);
+	}
+
+	list_for_each_entry_safe(qp1, qp2, &qp_del_list, list) {
+		list_del(&qp1->list);
+		dev->destroy_xrc_rcv_qp(qp1->xrcd, qp1->qpn);
+		kfree(qp1);
+	}
+}
+EXPORT_SYMBOL(ib_xrc_rcv_table_cleanup);
+
+void ib_xrc_rcv_qp_event_handler(struct ib_event *event, void *context_ptr)
+{
+	struct ib_device *dev = context_ptr;
+	struct ib_xrc_rcv_qp_table_entry *qp;
+	struct ib_xrc_rcv_reg_entry *reg_entry;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->xrc_rcv_qp_table_lock, flags);
+	qp = ib_xrc_rcv_tbl_find(dev, event->element.xrc_qp_num);
+	if (unlikely(!qp))
+		goto out;
+
+	list_for_each_entry(reg_entry, &qp->list, list) {
+		qp->event_handler(event, reg_entry->context);
+	}
+
+out:
+	spin_unlock_irqrestore(&dev->xrc_rcv_qp_table_lock, flags);
+}
+
+int ib_create_xrc_rcv_qp(struct ib_xrcd *xrcd, struct ib_qp_init_attr *attr,
+			 u32 *qp_num)
+{
+	struct ib_qp_init_attr init_attr;
+	int err;
+
+	memcpy(&init_attr, attr, sizeof(*attr));
+	init_attr.event_handler = ib_xrc_rcv_qp_event_handler;
+	init_attr.qp_context = xrcd->device;
+	err = xrcd->device->create_xrc_rcv_qp(&init_attr, qp_num);
+	if (err)
+		return err;
+
+	err = ib_xrc_rcv_qp_table_new(xrcd->device, attr->event_handler,
+				      *qp_num, xrcd, attr->qp_context);
+	if (err)
+		xrcd->device->destroy_xrc_rcv_qp(xrcd, *qp_num);
+	return err;
+}
+EXPORT_SYMBOL(ib_create_xrc_rcv_qp);
+
+int ib_destroy_xrc_rcv_qp(struct ib_xrcd *xrcd, u32 qp_num)
+{
+	return ib_xrc_rcv_qp_table_remove(xrcd->device, qp_num);
+}
+EXPORT_SYMBOL(ib_destroy_xrc_rcv_qp);
+
+int ib_reg_xrc_rcv_qp(struct ib_xrcd *xrcd, void *context, u32 qp_num)
+{
+	return ib_xrc_rcv_qp_table_add_reg_entry(xrcd->device, qp_num,
+						 context);
+}
+EXPORT_SYMBOL(ib_reg_xrc_rcv_qp);
+
+int ib_unreg_xrc_rcv_qp(struct ib_xrcd *xrcd, void *context, u32 qp_num)
+{
+	return ib_xrc_rcv_qp_table_remove_reg_entry(xrcd->device, qp_num,
+						    context);
+}
+EXPORT_SYMBOL(ib_unreg_xrc_rcv_qp);
+
Index: infiniband/include/rdma/ib_verbs.h
===================================================================
--- infiniband.orig/include/rdma/ib_verbs.h
+++ infiniband/include/rdma/ib_verbs.h
@@ -47,6 +47,7 @@
 #include <linux/list.h>
 #include <linux/rwsem.h>
 #include <linux/scatterlist.h>
+#include <linux/radix-tree.h>
 
 #include <asm/atomic.h>
 #include <asm/uaccess.h>
@@ -344,12 +345,17 @@ enum ib_event_type {
 	IB_EVENT_CLIENT_REREGISTER
 };
 
+enum ib_event_flags {
+	IB_XRC_QP_EVENT_FLAG = 0x80000000,
+};
+
 struct ib_event {
 	struct ib_device	*device;
 	union {
 		struct ib_cq	*cq;
 		struct ib_qp	*qp;
 		struct ib_srq	*srq;
+		u32		xrc_qp_num;
 		u8		port_num;
 	} element;
 	enum ib_event_type	event;
@@ -1154,6 +1160,23 @@ struct ib_device {
 						 struct ib_ucontext *context,
 						 struct ib_udata *udata);
 	int			   (*dealloc_xrcd)(struct ib_xrcd *xrcd);
+	int			   (*create_xrc_rcv_qp)(struct ib_qp_init_attr *init_attr,
+							u32 *qp_num);
+	int			   (*modify_xrc_rcv_qp)(struct ib_xrcd *xrcd,
+							u32 qp_num,
+							struct ib_qp_attr *attr,
+							int attr_mask);
+	int			   (*query_xrc_rcv_qp)(struct ib_xrcd *xrcd,
+						       u32 qp_num,
+						       struct ib_qp_attr *attr,
+						       int attr_mask,
+						       struct ib_qp_init_attr *init_attr);
+	int 			   (*destroy_xrc_rcv_qp)(struct ib_xrcd *xrcd,
+							 u32 qp_num);
+	int 			   (*reg_xrc_rcv_qp)(struct ib_xrcd *xrcd, void *context,
+						     u32 qp_num);
+	int 			   (*unreg_xrc_rcv_qp)(struct ib_xrcd *xrcd, void *context,
+						       u32 qp_num);
 
 	struct ib_dma_mapping_ops   *dma_ops;
 
@@ -1161,6 +1184,8 @@ struct ib_device {
 	struct device                dev;
 	struct kobject               *ports_parent;
 	struct list_head             port_list;
+	struct radix_tree_root       xrc_rcv_qp_table;
+	spinlock_t                   xrc_rcv_qp_table_lock;
 
 	enum {
 		IB_DEV_UNINITIALIZED,
@@ -1178,6 +1203,18 @@ struct ib_device {
 	u8                           phys_port_cnt;
 };
 
+struct ib_xrc_rcv_qp_table_entry {
+	struct list_head list;
+	void (*event_handler)(struct ib_event *, void *);
+	struct ib_xrcd *xrcd;
+	u32 qpn;
+};
+
+struct ib_xrc_rcv_reg_entry {
+	struct list_head list;
+	void *context;
+};
+
 struct ib_client {
 	char  *name;
 	void (*add)   (struct ib_device *);
@@ -2092,4 +2129,12 @@ struct ib_xrcd *ib_alloc_xrcd(struct ib_
  */
 int ib_dealloc_xrcd(struct ib_xrcd *xrcd);
 
+void ib_xrc_rcv_qp_table_init(struct ib_device *dev);
+void ib_xrc_rcv_table_cleanup(struct ib_device *dev, void *context);
+int ib_create_xrc_rcv_qp(struct ib_xrcd *xrcd, struct ib_qp_init_attr *attr,
+			 u32 *qp_num);
+int ib_destroy_xrc_rcv_qp(struct ib_xrcd *xrcd, u32 qp_num);
+int ib_reg_xrc_rcv_qp(struct ib_xrcd *xrcd, void *context, u32 qp_num);
+int ib_unreg_xrc_rcv_qp(struct ib_xrcd *xrcd, void *context, u32 qp_num);
+
 #endif /* IB_VERBS_H */
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
