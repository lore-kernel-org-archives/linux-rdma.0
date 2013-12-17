From: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 4/9] IB/usnic: Fix error handling with IS_ERR_OR_NULL
Date: Tue, 17 Dec 2013 08:48:32 -0800
Message-ID: <1387298917-7365-5-git-send-email-umalhi@cisco.com>
References: <1387298917-7365-1-git-send-email-umalhi@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1387298917-7365-1-git-send-email-umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Errors with IS_ERR_OR_NULL are not handleded correctly in few places
in usNIC.  This patch remedies that.

Signed-off-by: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/usnic/usnic_ib_main.c  | 10 ++++++----
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c |  2 +-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_ib_main.c b/drivers/infiniband/hw/usnic/usnic_ib_main.c
index 4d8cadc..7200861 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_main.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_main.c
@@ -398,13 +398,14 @@ static struct usnic_ib_dev *usnic_ib_discover_pf(struct usnic_vnic *vnic)
 
 	us_ibdev = usnic_ib_device_add(parent_pci);
 	if (IS_ERR_OR_NULL(us_ibdev)) {
-		us_ibdev = ERR_PTR(-EINVAL);
+		us_ibdev = (us_ibdev) ? us_ibdev : ERR_PTR(-EFAULT);
 		goto out;
 	}
 
 	err = usnic_ib_sysfs_register_usdev(us_ibdev);
 	if (err) {
 		usnic_ib_device_remove(us_ibdev);
+		us_ibdev = ERR_PTR(err);
 		goto out;
 	}
 
@@ -459,9 +460,10 @@ int usnic_ib_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 
 	pf = usnic_ib_discover_pf(vf->vnic);
-	if (!pf) {
-		usnic_err("Failed to discover pf of vnic %s with err%d\n",
-				pci_name(pdev), err);
+	if (IS_ERR_OR_NULL(pf)) {
+		usnic_err("Failed to discover pf of vnic %s with err%ld\n",
+				pci_name(pdev), PTR_ERR(pf));
+		err = (pf ? PTR_ERR(pf) : -EFAULT);
 		goto out_clean_vnic;
 	}
 
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
index d305e4e..e19ca90 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
@@ -574,7 +574,7 @@ struct ib_mr *usnic_ib_reg_mr(struct ib_pd *pd, u64 start, u64 length,
 	mr->umem = usnic_uiom_reg_get(to_upd(pd)->umem_pd, start, length,
 					access_flags, 0);
 	if (IS_ERR_OR_NULL(mr->umem)) {
-		err = PTR_ERR(mr->umem);
+		err = (mr->umem) ? PTR_ERR(mr->umem) : -EFAULT;
 		goto err_free;
 	}
 
-- 
1.8.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
