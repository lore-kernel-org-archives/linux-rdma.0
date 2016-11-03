From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 13/17] IB/usninc: Remove and fix debug prints after allocation failure
Date: Thu,  3 Nov 2016 07:02:29 +0200
Message-ID: <1478149353-12125-14-git-send-email-leon@kernel.org>
References: <1478149353-12125-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1478149353-12125-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch removes unneeded prints after allocation failure
and moves one debug print into the appropriate place.

Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c | 10 +---------
 drivers/infiniband/hw/usnic/usnic_vnic.c      | 22 ++++++----------------
 2 files changed, 7 insertions(+), 25 deletions(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
index 5b0248a..0e813ec 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
@@ -228,8 +228,6 @@ create_roce_custom_flow(struct usnic_ib_qp_grp *qp_grp,
 
 	flow = usnic_fwd_alloc_flow(qp_grp->ufdev, &filter, &uaction);
 	if (IS_ERR_OR_NULL(flow)) {
-		usnic_err("Unable to alloc flow failed with err %ld\n",
-				PTR_ERR(flow));
 		err = flow ? PTR_ERR(flow) : -EFAULT;
 		goto out_unreserve_port;
 	}
@@ -303,8 +301,6 @@ create_udp_flow(struct usnic_ib_qp_grp *qp_grp,
 
 	flow = usnic_fwd_alloc_flow(qp_grp->ufdev, &filter, &uaction);
 	if (IS_ERR_OR_NULL(flow)) {
-		usnic_err("Unable to alloc flow failed with err %ld\n",
-				PTR_ERR(flow));
 		err = flow ? PTR_ERR(flow) : -EFAULT;
 		goto out_put_sock;
 	}
@@ -694,18 +690,14 @@ usnic_ib_qp_grp_create(struct usnic_fwd_dev *ufdev, struct usnic_ib_vf *vf,
 	}
 
 	qp_grp = kzalloc(sizeof(*qp_grp), GFP_ATOMIC);
-	if (!qp_grp) {
-		usnic_err("Unable to alloc qp_grp - Out of memory\n");
+	if (!qp_grp)
 		return NULL;
-	}
 
 	qp_grp->res_chunk_list = alloc_res_chunk_list(vf->vnic, res_spec,
 							qp_grp);
 	if (IS_ERR_OR_NULL(qp_grp->res_chunk_list)) {
 		err = qp_grp->res_chunk_list ?
 				PTR_ERR(qp_grp->res_chunk_list) : -ENOMEM;
-		usnic_err("Unable to alloc res for %d with err %d\n",
-				qp_grp->grp_id, err);
 		goto out_free_qp_grp;
 	}
 
diff --git a/drivers/infiniband/hw/usnic/usnic_vnic.c b/drivers/infiniband/hw/usnic/usnic_vnic.c
index 8875107..e7b0030 100644
--- a/drivers/infiniband/hw/usnic/usnic_vnic.c
+++ b/drivers/infiniband/hw/usnic/usnic_vnic.c
@@ -241,17 +241,12 @@ usnic_vnic_get_resources(struct usnic_vnic *vnic, enum usnic_vnic_res_type type,
 		return ERR_PTR(-EINVAL);
 
 	ret = kzalloc(sizeof(*ret), GFP_ATOMIC);
-	if (!ret) {
-		usnic_err("Failed to allocate chunk for %s - Out of memory\n",
-				usnic_vnic_pci_name(vnic));
+	if (!ret)
 		return ERR_PTR(-ENOMEM);
-	}
 
 	if (cnt > 0) {
 		ret->res = kcalloc(cnt, sizeof(*(ret->res)), GFP_ATOMIC);
 		if (!ret->res) {
-			usnic_err("Failed to allocate resources for %s. Out of memory\n",
-					usnic_vnic_pci_name(vnic));
 			kfree(ret);
 			return ERR_PTR(-ENOMEM);
 		}
@@ -311,8 +306,10 @@ static int usnic_vnic_alloc_res_chunk(struct usnic_vnic *vnic,
 	struct usnic_vnic_res *res;
 
 	cnt = vnic_dev_get_res_count(vnic->vdev, _to_vnic_res_type(type));
-	if (cnt < 1)
+	if (cnt < 1) {
+		usnic_err("Wrong res count with cnt %d\n", cnt);
 		return -EINVAL;
+	}
 
 	chunk->cnt = chunk->free_cnt = cnt;
 	chunk->res = kzalloc(sizeof(*(chunk->res))*cnt, GFP_KERNEL);
@@ -384,12 +381,8 @@ static int usnic_vnic_discover_resources(struct pci_dev *pdev,
 			res_type < USNIC_VNIC_RES_TYPE_MAX; res_type++) {
 		err = usnic_vnic_alloc_res_chunk(vnic, res_type,
 						&vnic->chunks[res_type]);
-		if (err) {
-			usnic_err("Failed to alloc res %s with err %d\n",
-					usnic_vnic_res_type_to_str(res_type),
-					err);
+		if (err)
 			goto out_clean_chunks;
-		}
 	}
 
 	return 0;
@@ -454,11 +447,8 @@ struct usnic_vnic *usnic_vnic_alloc(struct pci_dev *pdev)
 	}
 
 	vnic = kzalloc(sizeof(*vnic), GFP_KERNEL);
-	if (!vnic) {
-		usnic_err("Failed to alloc vnic for %s - out of memory\n",
-				pci_name(pdev));
+	if (!vnic)
 		return ERR_PTR(-ENOMEM);
-	}
 
 	spin_lock_init(&vnic->res_lock);
 
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
