From: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 9/9] IB/usnic: Fix sparse should be static warnings
Date: Tue, 17 Dec 2013 08:48:37 -0800
Message-ID: <1387298917-7365-10-git-send-email-umalhi@cisco.com>
References: <1387298917-7365-1-git-send-email-umalhi@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1387298917-7365-1-git-send-email-umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sparse spit out few functions should be static warnings.  This
patch provides a fix for the warnings.

Signed-off-by: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/usnic/usnic_ib_main.c   | 4 +++-
 drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c | 4 ++--
 drivers/infiniband/hw/usnic/usnic_ib_sysfs.c  | 2 +-
 drivers/infiniband/hw/usnic/usnic_transport.c | 4 ++--
 drivers/infiniband/hw/usnic/usnic_transport.h | 1 +
 drivers/infiniband/hw/usnic/usnic_uiom.c      | 2 +-
 6 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_ib_main.c b/drivers/infiniband/hw/usnic/usnic_ib_main.c
index 7200861..76bd097 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_main.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_main.c
@@ -423,7 +423,8 @@ static DEFINE_PCI_DEVICE_TABLE(usnic_ib_pci_ids) = {
 	{0,}
 };
 
-int usnic_ib_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+static int usnic_ib_pci_probe(struct pci_dev *pdev,
+				const struct pci_device_id *id)
 {
 	int err;
 	struct usnic_ib_dev *pf;
@@ -579,6 +580,7 @@ static void __exit usnic_ib_destroy(void)
 {
 	usnic_dbg("\n");
 	usnic_debugfs_exit();
+	usnic_transport_fini();
 	unregister_netdevice_notifier(&usnic_ib_netdevice_notifier);
 	pci_unregister_driver(&usnic_ib_pci_driver);
 	usnic_uiom_fini();
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
index b5fb4d4..788f47a 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
@@ -331,7 +331,7 @@ int usnic_ib_qp_grp_modify(struct usnic_ib_qp_grp *qp_grp,
 	return status;
 }
 
-struct usnic_vnic_res_chunk**
+static struct usnic_vnic_res_chunk**
 alloc_res_chunk_list(struct usnic_vnic *vnic,
 			struct usnic_vnic_res_spec *res_spec, void *owner_obj)
 {
@@ -377,7 +377,7 @@ out_free_res:
 	return ERR_PTR(err);
 }
 
-void free_qp_grp_res(struct usnic_vnic_res_chunk **res_chunk_list)
+static void free_qp_grp_res(struct usnic_vnic_res_chunk **res_chunk_list)
 {
 	int i;
 	for (i = 0; res_chunk_list[i]; i++)
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_sysfs.c b/drivers/infiniband/hw/usnic/usnic_ib_sysfs.c
index e7925e4..bad985e 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_sysfs.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_sysfs.c
@@ -282,7 +282,7 @@ static struct attribute *usnic_ib_qpn_default_attrs[] = {
 	NULL
 };
 
-struct kobj_type usnic_ib_qpn_type = {
+static struct kobj_type usnic_ib_qpn_type = {
 	.sysfs_ops = &usnic_ib_qpn_sysfs_ops,
 	.default_attrs = usnic_ib_qpn_default_attrs
 };
diff --git a/drivers/infiniband/hw/usnic/usnic_transport.c b/drivers/infiniband/hw/usnic/usnic_transport.c
index 6f3d245..723bd6c 100644
--- a/drivers/infiniband/hw/usnic/usnic_transport.c
+++ b/drivers/infiniband/hw/usnic/usnic_transport.c
@@ -26,7 +26,7 @@
 static unsigned long *roce_bitmap;
 static u16 roce_next_port = 1;
 #define ROCE_BITMAP_SZ ((1 << (8 /*CHAR_BIT*/ * sizeof(u16)))/8 /*CHAR BIT*/)
-DEFINE_SPINLOCK(roce_bitmap_lock);
+static DEFINE_SPINLOCK(roce_bitmap_lock);
 
 static const char *transport_to_str(enum usnic_transport_type type)
 {
@@ -106,7 +106,7 @@ out_roce_custom:
 	}
 }
 
-int usnic_transport_init()
+int usnic_transport_init(void)
 {
 	roce_bitmap = kzalloc(ROCE_BITMAP_SZ, GFP_KERNEL);
 	if (!roce_bitmap) {
diff --git a/drivers/infiniband/hw/usnic/usnic_transport.h b/drivers/infiniband/hw/usnic/usnic_transport.h
index e4c924e..091fdaf 100644
--- a/drivers/infiniband/hw/usnic/usnic_transport.h
+++ b/drivers/infiniband/hw/usnic/usnic_transport.h
@@ -24,4 +24,5 @@
 u16 usnic_transport_rsrv_port(enum usnic_transport_type type, u16 port_num);
 void usnic_transport_unrsrv_port(enum usnic_transport_type type, u16 port_num);
 int usnic_transport_init(void);
+void usnic_transport_fini(void);
 #endif /* !USNIC_TRANSPORT_H */
diff --git a/drivers/infiniband/hw/usnic/usnic_uiom.c b/drivers/infiniband/hw/usnic/usnic_uiom.c
index 0477d70..200941f 100644
--- a/drivers/infiniband/hw/usnic/usnic_uiom.c
+++ b/drivers/infiniband/hw/usnic/usnic_uiom.c
@@ -46,7 +46,7 @@
 #include "usnic_uiom.h"
 #include "usnic_uiom_interval_tree.h"
 
-struct workqueue_struct *usnic_uiom_wq;
+static struct workqueue_struct *usnic_uiom_wq;
 
 #define USNIC_UIOM_PAGE_CHUNK						\
 	((PAGE_SIZE - offsetof(struct usnic_uiom_chunk, page_list))	/\
-- 
1.8.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
