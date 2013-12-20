From: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 12/15] IB/usnic: Change GFP_KERNEL TO GFP_ATOMIC if spinlock is held
Date: Fri, 20 Dec 2013 12:26:43 -0800
Message-ID: <1387571206-8043-13-git-send-email-umalhi@cisco.com>
References: <1387571206-8043-1-git-send-email-umalhi@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1387571206-8043-1-git-send-email-umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

usNIC code at few places, calls kzalloc with GFP_KERNEL flag while
holding a spinlock.  Change GPF_KERNEL to GFP_ATOMIC at such places.

Signed-off-by: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/usnic/usnic_fwd.c                | 2 +-
 drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c          | 4 ++--
 drivers/infiniband/hw/usnic/usnic_uiom_interval_tree.c | 2 +-
 drivers/infiniband/hw/usnic/usnic_vnic.c               | 4 ++--
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_fwd.c b/drivers/infiniband/hw/usnic/usnic_fwd.c
index b5719fc..8e42216 100644
--- a/drivers/infiniband/hw/usnic/usnic_fwd.c
+++ b/drivers/infiniband/hw/usnic/usnic_fwd.c
@@ -98,7 +98,7 @@ int usnic_fwd_add_usnic_filter(struct usnic_fwd_dev *ufdev, int vnic_idx,
 		return -ENOMEM;
 	}
 
-	usnic_filter_hndl = kzalloc(sizeof(*usnic_filter_hndl), GFP_KERNEL);
+	usnic_filter_hndl = kzalloc(sizeof(*usnic_filter_hndl), GFP_ATOMIC);
 	if (!usnic_filter_hndl) {
 		usnic_err("Failed to allocate memory for hndl\n");
 		pci_free_consistent(pdev, tlv_size, tlv, tlv_pa);
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
index 0daf7e9..ca5fa6a 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
@@ -346,7 +346,7 @@ alloc_res_chunk_list(struct usnic_vnic *vnic,
 	}
 
 	res_chunk_list = kzalloc(sizeof(*res_chunk_list)*(res_lst_sz+1),
-					GFP_KERNEL);
+					GFP_ATOMIC);
 	if (!res_chunk_list)
 		return ERR_PTR(-ENOMEM);
 
@@ -464,7 +464,7 @@ usnic_ib_qp_grp_create(struct usnic_fwd_dev *ufdev,
 		return ERR_PTR(-EINVAL);
 	}
 
-	qp_grp = kzalloc(sizeof(*qp_grp), GFP_KERNEL);
+	qp_grp = kzalloc(sizeof(*qp_grp), GFP_ATOMIC);
 	if (!qp_grp) {
 		usnic_err("Unable to alloc qp_grp - Out of memory\n");
 		return NULL;
diff --git a/drivers/infiniband/hw/usnic/usnic_uiom_interval_tree.c b/drivers/infiniband/hw/usnic/usnic_uiom_interval_tree.c
index b6e3a6b..7e1dafc 100644
--- a/drivers/infiniband/hw/usnic/usnic_uiom_interval_tree.c
+++ b/drivers/infiniband/hw/usnic/usnic_uiom_interval_tree.c
@@ -39,7 +39,7 @@ usnic_uiom_interval_node_alloc(long int start, long int last, int ref_cnt,
 				int flags)
 {
 	struct usnic_uiom_interval_node *interval = kzalloc(sizeof(*interval),
-								GFP_KERNEL);
+								GFP_ATOMIC);
 	if (!interval)
 		return NULL;
 
diff --git a/drivers/infiniband/hw/usnic/usnic_vnic.c b/drivers/infiniband/hw/usnic/usnic_vnic.c
index 74e4e5b..656b88c 100644
--- a/drivers/infiniband/hw/usnic/usnic_vnic.c
+++ b/drivers/infiniband/hw/usnic/usnic_vnic.c
@@ -225,14 +225,14 @@ usnic_vnic_get_resources(struct usnic_vnic *vnic, enum usnic_vnic_res_type type,
 	if (usnic_vnic_res_free_cnt(vnic, type) < cnt || cnt < 1 || !owner)
 		return ERR_PTR(-EINVAL);
 
-	ret = kzalloc(sizeof(*ret), GFP_KERNEL);
+	ret = kzalloc(sizeof(*ret), GFP_ATOMIC);
 	if (!ret) {
 		usnic_err("Failed to allocate chunk for %s - Out of memory\n",
 				usnic_vnic_pci_name(vnic));
 		return ERR_PTR(-ENOMEM);
 	}
 
-	ret->res = kzalloc(sizeof(*(ret->res))*cnt, GFP_KERNEL);
+	ret->res = kzalloc(sizeof(*(ret->res))*cnt, GFP_ATOMIC);
 	if (!ret->res) {
 		usnic_err("Failed to allocate resources for %s. Out of memory\n",
 				usnic_vnic_pci_name(vnic));
-- 
1.8.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
