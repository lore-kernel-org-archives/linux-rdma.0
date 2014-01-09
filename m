From: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next] IB/usnic: Remove superflous parentheses
Date: Thu,  9 Jan 2014 14:48:36 -0800
Message-ID: <1389307716-11627-1-git-send-email-umalhi@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Depends on "[PATCH v1 for-next] IB/usnic: usNIC UDP Support" series.

Remove superflous parentheses from one line ifs.

Signed-off-by: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/usnic/usnic_ib_main.c   |  6 +++---
 drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c | 18 +++++++++---------
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c  |  4 ++--
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_ib_main.c b/drivers/infiniband/hw/usnic/usnic_ib_main.c
index 3b7e8bd..f7be445 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_main.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_main.c
@@ -470,7 +470,7 @@ static struct usnic_ib_dev *usnic_ib_discover_pf(struct usnic_vnic *vnic)

 	us_ibdev = usnic_ib_device_add(parent_pci);
 	if (IS_ERR_OR_NULL(us_ibdev)) {
-		us_ibdev = (us_ibdev) ? us_ibdev : ERR_PTR(-EFAULT);
+		us_ibdev = us_ibdev ? us_ibdev : ERR_PTR(-EFAULT);
 		goto out;
 	}

@@ -526,7 +526,7 @@ static int usnic_ib_pci_probe(struct pci_dev *pdev,

 	vf->vnic = usnic_vnic_alloc(pdev);
 	if (IS_ERR_OR_NULL(vf->vnic)) {
-		err = (vf->vnic ? PTR_ERR(vf->vnic) : -ENOMEM);
+		err = vf->vnic ? PTR_ERR(vf->vnic) : -ENOMEM;
 		usnic_err("Failed to alloc vnic for %s with err %d\n",
 				pci_name(pdev), err);
 		goto out_release_regions;
@@ -536,7 +536,7 @@ static int usnic_ib_pci_probe(struct pci_dev *pdev,
 	if (IS_ERR_OR_NULL(pf)) {
 		usnic_err("Failed to discover pf of vnic %s with err%ld\n",
 				pci_name(pdev), PTR_ERR(pf));
-		err = (pf ? PTR_ERR(pf) : -EFAULT);
+		err = pf ? PTR_ERR(pf) : -EFAULT;
 		goto out_clean_vnic;
 	}

diff --git a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
index 7967c8b..7ecc606 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
@@ -215,14 +215,14 @@ create_roce_custom_flow(struct usnic_ib_qp_grp *qp_grp,
 	if (IS_ERR_OR_NULL(flow)) {
 		usnic_err("Unable to alloc flow failed with err %ld\n",
 				PTR_ERR(flow));
-		err = (flow) ? PTR_ERR(flow) : -EFAULT;
+		err = flow ? PTR_ERR(flow) : -EFAULT;
 		goto out_unreserve_port;
 	}

 	/* Create Flow Handle */
 	qp_flow = kzalloc(sizeof(*qp_flow), GFP_ATOMIC);
 	if (IS_ERR_OR_NULL(qp_flow)) {
-		err = (qp_flow) ? PTR_ERR(qp_flow) : -ENOMEM;
+		err = qp_flow ? PTR_ERR(qp_flow) : -ENOMEM;
 		goto out_dealloc_flow;
 	}
 	qp_flow->flow = flow;
@@ -290,14 +290,14 @@ create_udp_flow(struct usnic_ib_qp_grp *qp_grp,
 	if (IS_ERR_OR_NULL(flow)) {
 		usnic_err("Unable to alloc flow failed with err %ld\n",
 				PTR_ERR(flow));
-		err = (flow) ? PTR_ERR(flow) : -EFAULT;
+		err = flow ? PTR_ERR(flow) : -EFAULT;
 		goto out_put_sock;
 	}

 	/* Create qp_flow */
 	qp_flow = kzalloc(sizeof(*qp_flow), GFP_ATOMIC);
 	if (IS_ERR_OR_NULL(qp_flow)) {
-		err = (qp_flow) ? PTR_ERR(qp_flow) : -ENOMEM;
+		err = qp_flow ? PTR_ERR(qp_flow) : -ENOMEM;
 		goto out_dealloc_flow;
 	}
 	qp_flow->flow = flow;
@@ -419,7 +419,7 @@ int usnic_ib_qp_grp_modify(struct usnic_ib_qp_grp *qp_grp,
 				qp_flow = create_and_add_flow(qp_grp,
 								trans_spec);
 				if (IS_ERR_OR_NULL(qp_flow)) {
-					status = (qp_flow) ? PTR_ERR(qp_flow) : -EFAULT;
+					status = qp_flow ? PTR_ERR(qp_flow) : -EFAULT;
 					break;
 				}
 			} else {
@@ -434,7 +434,7 @@ int usnic_ib_qp_grp_modify(struct usnic_ib_qp_grp *qp_grp,
 				qp_flow = create_and_add_flow(qp_grp,
 								trans_spec);
 				if (IS_ERR_OR_NULL(qp_flow)) {
-					status = (qp_flow) ? PTR_ERR(qp_flow) : -EFAULT;
+					status = qp_flow ? PTR_ERR(qp_flow) : -EFAULT;
 					break;
 				}
 			} else {
@@ -547,8 +547,8 @@ alloc_res_chunk_list(struct usnic_vnic *vnic,
 		res_chunk_list[i] = usnic_vnic_get_resources(vnic, res_type,
 					res_cnt, owner_obj);
 		if (IS_ERR_OR_NULL(res_chunk_list[i])) {
-			err = (res_chunk_list[i] ?
-					PTR_ERR(res_chunk_list[i]) : -ENOMEM);
+			err = res_chunk_list[i] ?
+					PTR_ERR(res_chunk_list[i]) : -ENOMEM;
 			usnic_err("Failed to get %s from %s with err %d\n",
 				usnic_vnic_res_type_to_str(res_type),
 				usnic_vnic_pci_name(vnic),
@@ -701,7 +701,7 @@ usnic_ib_qp_grp_create(struct usnic_fwd_dev *ufdev, struct usnic_ib_vf *vf,
 	if (IS_ERR_OR_NULL(qp_flow)) {
 		usnic_err("Unable to create and add flow with err %ld\n",
 				PTR_ERR(qp_flow));
-		err = (qp_flow) ? PTR_ERR(qp_flow) : -EFAULT;
+		err = qp_flow ? PTR_ERR(qp_flow) : -EFAULT;
 		goto out_qp_grp_vf_unbind;
 	}

diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
index 937113f..d48d2c0 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
@@ -495,7 +495,7 @@ struct ib_qp *usnic_ib_create_qp(struct ib_pd *pd,
 						&trans_spec,
 						&res_spec);
 	if (IS_ERR_OR_NULL(qp_grp)) {
-		err = (qp_grp ? PTR_ERR(qp_grp) : -ENOMEM);
+		err = qp_grp ? PTR_ERR(qp_grp) : -ENOMEM;
 		goto out_release_mutex;
 	}

@@ -605,7 +605,7 @@ struct ib_mr *usnic_ib_reg_mr(struct ib_pd *pd, u64 start, u64 length,
 	mr->umem = usnic_uiom_reg_get(to_upd(pd)->umem_pd, start, length,
 					access_flags, 0);
 	if (IS_ERR_OR_NULL(mr->umem)) {
-		err = (mr->umem) ? PTR_ERR(mr->umem) : -EFAULT;
+		err = mr->umem ? PTR_ERR(mr->umem) : -EFAULT;
 		goto err_free;
 	}

--
1.8.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
