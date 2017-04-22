From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 3/4] IB/usnic: Simplify the code to balance loc/unlock calls
Date: Sat, 22 Apr 2017 17:28:51 +0300
Message-ID: <20170422142852.18882-4-leon@kernel.org>
References: <20170422142852.18882-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170422142852.18882-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian Benvenuti <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Simplify code in find_free_vf_and_create_qp_grp() to avoid sparse error
regarding call to unlock in the block other than lock was called.

drivers/infiniband/hw/usnic/usnic_ib_verbs.c:206:9: warning: context imbalance
			in 'find_free_vf_and_create_qp_grp' - different lock
			contexts for basic block

CC: Christian Benvenuti <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c | 45 ++++++++++++++--------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
index bcd6f7b1c634..44a93326f7b5 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
@@ -152,7 +152,7 @@ find_free_vf_and_create_qp_grp(struct usnic_ib_dev *us_ibdev,
 	struct usnic_vnic *vnic;
 	struct usnic_ib_qp_grp *qp_grp;
 	struct device *dev, **dev_list;
-	int i, found = 0;
+	int i;

 	BUG_ON(!mutex_is_locked(&us_ibdev->usdev_lock));

@@ -174,8 +174,13 @@ find_free_vf_and_create_qp_grp(struct usnic_ib_dev *us_ibdev,
 						us_ibdev->ib_dev.name,
 						pci_name(usnic_vnic_get_pdev(
 									vnic)));
-				found = 1;
-				break;
+				qp_grp = usnic_ib_qp_grp_create(us_ibdev->ufdev,
+								vf, pd,
+								res_spec,
+								trans_spec);
+
+				spin_unlock(&vf->lock);
+				goto qp_grp_check;
 			}
 			spin_unlock(&vf->lock);

@@ -183,34 +188,30 @@ find_free_vf_and_create_qp_grp(struct usnic_ib_dev *us_ibdev,
 		usnic_uiom_free_dev_list(dev_list);
 	}

-	if (!found) {
-		/* Try to find resources on an unused vf */
-		list_for_each_entry(vf, &us_ibdev->vf_dev_list, link) {
-			spin_lock(&vf->lock);
-			vnic = vf->vnic;
-			if (vf->qp_grp_ref_cnt == 0 &&
-				usnic_vnic_check_room(vnic, res_spec) == 0) {
-				found = 1;
-				break;
-			}
+	/* Try to find resources on an unused vf */
+	list_for_each_entry(vf, &us_ibdev->vf_dev_list, link) {
+		spin_lock(&vf->lock);
+		vnic = vf->vnic;
+		if (vf->qp_grp_ref_cnt == 0 &&
+		    usnic_vnic_check_room(vnic, res_spec) == 0) {
+			qp_grp = usnic_ib_qp_grp_create(us_ibdev->ufdev, vf,
+							pd, res_spec,
+							trans_spec);
+
 			spin_unlock(&vf->lock);
+			goto qp_grp_check;
 		}
+		spin_unlock(&vf->lock);
 	}

-	if (!found) {
-		usnic_info("No free qp grp found on %s\n",
-				us_ibdev->ib_dev.name);
-		return ERR_PTR(-ENOMEM);
-	}
+	usnic_info("No free qp grp found on %s\n", us_ibdev->ib_dev.name);
+	return ERR_PTR(-ENOMEM);

-	qp_grp = usnic_ib_qp_grp_create(us_ibdev->ufdev, vf, pd, res_spec,
-						trans_spec);
-	spin_unlock(&vf->lock);
+qp_grp_check:
 	if (IS_ERR_OR_NULL(qp_grp)) {
 		usnic_err("Failed to allocate qp_grp\n");
 		return ERR_PTR(qp_grp ? PTR_ERR(qp_grp) : -ENOMEM);
 	}
-
 	return qp_grp;
 }

--
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
