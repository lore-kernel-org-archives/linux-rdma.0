From: rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org
Subject: [patch 29/44] rxe_mcast.c
Date: Fri, 01 Jul 2011 08:18:50 -0500
Message-ID: <20110701132202.097919357@systemfabricworks.com>
References: <20110701131821.928693424@systemfabricworks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline; filename=patch29
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Bob Pearson <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Multicast implemtation details.

Signed-off-by: Bob Pearson <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>

---
 drivers/infiniband/hw/rxe/rxe_mcast.c |  192 ++++++++++++++++++++++++++++++++++
 1 file changed, 192 insertions(+)

Index: infiniband/drivers/infiniband/hw/rxe/rxe_mcast.c
===================================================================
--- /dev/null
+++ infiniband/drivers/infiniband/hw/rxe/rxe_mcast.c
@@ -0,0 +1,192 @@
+/*
+ * Copyright (c) 2009-2011 Mellanox Technologies Ltd. All rights reserved.
+ * Copyright (c) 2009-2011 System Fabric Works, Inc. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *	   Redistribution and use in source and binary forms, with or
+ *	   without modification, are permitted provided that the following
+ *	   conditions are met:
+ *
+ *		- Redistributions of source code must retain the above
+ *		  copyright notice, this list of conditions and the following
+ *		  disclaimer.
+ *
+ *		- Redistributions in binary form must reproduce the above
+ *		  copyright notice, this list of conditions and the following
+ *		  disclaimer in the documentation and/or other materials
+ *		  provided with the distribution.
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
+/* multicast implemtation details */
+
+#include "rxe.h"
+#include "rxe_mcast.h"
+
+int rxe_mcast_get_grp(struct rxe_dev *rxe, union ib_gid *mgid, u16 mlid,
+		      struct rxe_mc_grp **grp_p)
+{
+	int err;
+	struct rxe_mc_grp *grp;
+
+	if (rxe->attr.max_mcast_qp_attach == 0) {
+		err = -EINVAL;
+		goto err1;
+	}
+
+	grp = rxe_pool_get_key(&rxe->mc_grp_pool, mgid);
+	if (grp)
+		goto done;
+
+	grp = rxe_alloc(&rxe->mc_grp_pool);
+	if (!grp) {
+		err = -ENOMEM;
+		goto err1;
+	}
+
+	INIT_LIST_HEAD(&grp->qp_list);
+	spin_lock_init(&grp->mcg_lock);
+	grp->mlid = mlid;
+	grp->rxe = rxe;
+
+	err = rxe->ifc_ops->mcast_add(rxe, mgid);
+	if (err)
+		goto err2;
+
+	rxe_add_key(grp, mgid);
+done:
+	*grp_p = grp;
+	return 0;
+
+err2:
+	rxe_drop_ref(grp);
+err1:
+	return err;
+}
+
+int rxe_mcast_add_grp_elem(struct rxe_dev *rxe, struct rxe_qp *qp,
+			   struct rxe_mc_grp *grp)
+{
+	int err;
+	struct rxe_mc_elem *elem;
+
+	/* check to see of the qp is already a member of the group */
+	spin_lock_bh(&qp->grp_lock);
+	spin_lock_bh(&grp->mcg_lock);
+	list_for_each_entry(elem, &grp->qp_list, qp_list) {
+		if (elem->qp == qp) {
+			err = 0;
+			goto out;
+		}
+	}
+
+	if (grp->num_qp >= rxe->attr.max_mcast_qp_attach) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	elem = rxe_alloc(&rxe->mc_elem_pool);
+	if (!elem) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	/* each qp holds a ref on the grp */
+	rxe_add_ref(grp);
+
+	grp->num_qp++;
+	elem->qp = qp;
+	elem->grp = grp;
+
+	list_add(&elem->qp_list, &grp->qp_list);
+	list_add(&elem->grp_list, &qp->grp_list);
+
+	err = 0;
+out:
+	spin_unlock_bh(&grp->mcg_lock);
+	spin_unlock_bh(&qp->grp_lock);
+	return err;
+}
+
+int rxe_mcast_drop_grp_elem(struct rxe_dev *rxe, struct rxe_qp *qp,
+			    union ib_gid *mgid, u16 mlid)
+{
+	struct rxe_mc_grp *grp;
+	struct rxe_mc_elem *elem, *tmp;
+
+	grp = rxe_pool_get_key(&rxe->mc_grp_pool, mgid);
+	if (!grp)
+		goto err1;
+
+	spin_lock_bh(&qp->grp_lock);
+	spin_lock_bh(&grp->mcg_lock);
+
+	list_for_each_entry_safe(elem, tmp, &grp->qp_list, qp_list) {
+		if (elem->qp == qp) {
+			list_del(&elem->qp_list);
+			list_del(&elem->grp_list);
+			grp->num_qp--;
+
+			spin_unlock_bh(&grp->mcg_lock);
+			spin_unlock_bh(&qp->grp_lock);
+			rxe_drop_ref(elem);
+			rxe_drop_ref(grp);	/* ref held by QP */
+			rxe_drop_ref(grp);	/* ref from get_key */
+			return 0;
+		}
+	}
+
+	spin_unlock_bh(&grp->mcg_lock);
+	spin_unlock_bh(&qp->grp_lock);
+	rxe_drop_ref(grp);			/* ref from get_key */
+err1:
+	return -EINVAL;
+}
+
+void rxe_drop_all_mcast_groups(struct rxe_qp *qp)
+{
+	struct rxe_mc_grp *grp;
+	struct rxe_mc_elem *elem;
+
+	while (1) {
+		spin_lock_bh(&qp->grp_lock);
+		if (list_empty(&qp->grp_list)) {
+			spin_unlock_bh(&qp->grp_lock);
+			break;
+		}
+		elem = list_first_entry(&qp->grp_list, struct rxe_mc_elem,
+					grp_list);
+		list_del(&elem->grp_list);
+		spin_unlock_bh(&qp->grp_lock);
+
+		grp = elem->grp;
+		spin_lock_bh(&grp->mcg_lock);
+		list_del(&elem->qp_list);
+		grp->num_qp--;
+		spin_unlock_bh(&grp->mcg_lock);
+		rxe_drop_ref(grp);
+		rxe_drop_ref(elem);
+	}
+}
+
+void rxe_mc_cleanup(void *arg)
+{
+	struct rxe_mc_grp *grp = arg;
+	struct rxe_dev *rxe = grp->rxe;
+
+	rxe_drop_key(grp);
+	rxe->ifc_ops->mcast_delete(rxe, &grp->mgid);
+}

-- 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
