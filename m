From: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH net] net: hns3: Updates MSI/MSI-X alloc/free APIs(depricated) to new APIs
Date: Wed, 8 Nov 2017 11:56:06 +0000
Message-ID: <20171108115606.8012-1-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org
Cc: hch-jcswGhMUV9g@public.gmane.org, salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yisen.zhuang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, lipeng321-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mehta.salil.lnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch migrates the HNS3 driver code from use of depricated PCI
MSI/MSI-X interrupt vector allocation/free APIs to new common APIs.

Signed-off-by: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Suggested-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 108 +++++++--------------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  15 ++-
 2 files changed, 42 insertions(+), 81 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index c1cdbfd..09fa068 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -885,14 +885,14 @@ static int hclge_query_pf_resource(struct hclge_dev *hdev)
 	hdev->pkt_buf_size = __le16_to_cpu(req->buf_size) << HCLGE_BUF_UNIT_S;
 
 	if (hnae3_dev_roce_supported(hdev)) {
-		hdev->num_roce_msix =
+		hdev->num_roce_msi =
 		hnae_get_field(__le16_to_cpu(req->pf_intr_vector_number),
 			       HCLGE_PF_VEC_NUM_M, HCLGE_PF_VEC_NUM_S);
 
 		/* PF should have NIC vectors and Roce vectors,
 		 * NIC vectors are queued before Roce vectors.
 		 */
-		hdev->num_msi = hdev->num_roce_msix  + HCLGE_ROCE_VECTOR_OFFSET;
+		hdev->num_msi = hdev->num_roce_msi  + HCLGE_ROCE_VECTOR_OFFSET;
 	} else {
 		hdev->num_msi =
 		hnae_get_field(__le16_to_cpu(req->pf_intr_vector_number),
@@ -1835,7 +1835,7 @@ static int hclge_init_roce_base_info(struct hclge_vport *vport)
 	struct hnae3_handle *roce = &vport->roce;
 	struct hnae3_handle *nic = &vport->nic;
 
-	roce->rinfo.num_vectors = vport->back->num_roce_msix;
+	roce->rinfo.num_vectors = vport->back->num_roce_msi;
 
 	if (vport->back->num_msi_left < vport->roce.rinfo.num_vectors ||
 	    vport->back->num_msi_left == 0)
@@ -1853,67 +1853,46 @@ static int hclge_init_roce_base_info(struct hclge_vport *vport)
 	return 0;
 }
 
-static int hclge_init_msix(struct hclge_dev *hdev)
+static int hclge_init_msi(struct hclge_dev *hdev)
 {
 	struct pci_dev *pdev = hdev->pdev;
-	int ret, i;
-
-	hdev->msix_entries = devm_kcalloc(&pdev->dev, hdev->num_msi,
-					  sizeof(struct msix_entry),
-					  GFP_KERNEL);
-	if (!hdev->msix_entries)
-		return -ENOMEM;
-
-	hdev->vector_status = devm_kcalloc(&pdev->dev, hdev->num_msi,
-					   sizeof(u16), GFP_KERNEL);
-	if (!hdev->vector_status)
-		return -ENOMEM;
+	int vectors;
+	int i;
 
-	for (i = 0; i < hdev->num_msi; i++) {
-		hdev->msix_entries[i].entry = i;
-		hdev->vector_status[i] = HCLGE_INVALID_VPORT;
+	vectors = pci_alloc_irq_vectors(pdev, 1, hdev->num_msi,
+					PCI_IRQ_MSI | PCI_IRQ_MSIX);
+	if (vectors < 0) {
+		dev_err(&pdev->dev, "failed to allocate MSI/MSI-X vectors %d\n",
+			vectors);
+		return vectors;
 	}
+	if (vectors < hdev->num_msi)
+		dev_warn(&hdev->pdev->dev,
+			 "could not alloc(=%d) all requested(=%d) MSI/MSI-X\n",
+			 hdev->num_msi, vectors);
 
-	hdev->num_msi_left = hdev->num_msi;
-	hdev->base_msi_vector = hdev->pdev->irq;
+	hdev->num_msi = vectors;
+	hdev->num_msi_left = vectors;
+	hdev->base_msi_vector = pdev->irq;
 	hdev->roce_base_vector = hdev->base_msi_vector +
-				HCLGE_ROCE_VECTOR_OFFSET;
-
-	ret = pci_enable_msix_range(hdev->pdev, hdev->msix_entries,
-				    hdev->num_msi, hdev->num_msi);
-	if (ret < 0) {
-		dev_info(&hdev->pdev->dev,
-			 "MSI-X vector alloc failed: %d\n", ret);
-		return ret;
-	}
-
-	return 0;
-}
-
-static int hclge_init_msi(struct hclge_dev *hdev)
-{
-	struct pci_dev *pdev = hdev->pdev;
-	int vectors;
-	int i;
+				 HCLGE_ROCE_VECTOR_OFFSET;
 
 	hdev->vector_status = devm_kcalloc(&pdev->dev, hdev->num_msi,
 					   sizeof(u16), GFP_KERNEL);
-	if (!hdev->vector_status)
+	if (!hdev->vector_status) {
+		pci_free_irq_vectors(pdev);
 		return -ENOMEM;
+	}
 
 	for (i = 0; i < hdev->num_msi; i++)
 		hdev->vector_status[i] = HCLGE_INVALID_VPORT;
 
-	vectors = pci_alloc_irq_vectors(pdev, 1, hdev->num_msi, PCI_IRQ_MSI);
-	if (vectors < 0) {
-		dev_err(&pdev->dev, "MSI vectors enable failed %d\n", vectors);
-		return -EINVAL;
+	hdev->vector_irq = devm_kcalloc(&pdev->dev, hdev->num_msi,
+					   sizeof(int), GFP_KERNEL);
+	if (!hdev->vector_irq) {
+		pci_free_irq_vectors(pdev);
+		return -ENOMEM;
 	}
-	hdev->num_msi = vectors;
-	hdev->num_msi_left = vectors;
-	hdev->base_msi_vector = pdev->irq;
-	hdev->roce_base_vector = hdev->base_msi_vector +
-				HCLGE_ROCE_VECTOR_OFFSET;
 
 	return 0;
 }
@@ -2341,6 +2320,7 @@ static int hclge_get_vector(struct hnae3_handle *handle, u16 vector_num,
 					vport->vport_id *
 					HCLGE_VECTOR_VF_OFFSET;
 				hdev->vector_status[i] = vport->vport_id;
+				hdev->vector_irq[i] = vector->vector;
 
 				vector++;
 				alloc++;
@@ -2359,15 +2339,10 @@ static int hclge_get_vector_index(struct hclge_dev *hdev, int vector)
 {
 	int i;
 
-	for (i = 0; i < hdev->num_msi; i++) {
-		if (hdev->msix_entries) {
-			if (vector == hdev->msix_entries[i].vector)
-				return i;
-		} else {
-			if (vector == (hdev->base_msi_vector + i))
-				return i;
-		}
-	}
+	for (i = 0; i < hdev->num_msi; i++)
+		if (vector == hdev->vector_irq[i])
+			return i;
+
 	return -EINVAL;
 }
 
@@ -4072,14 +4047,7 @@ static void hclge_pci_uninit(struct hclge_dev *hdev)
 {
 	struct pci_dev *pdev = hdev->pdev;
 
-	if (hdev->flag & HCLGE_FLAG_USE_MSIX) {
-		pci_disable_msix(pdev);
-		devm_kfree(&pdev->dev, hdev->msix_entries);
-		hdev->msix_entries = NULL;
-	} else {
-		pci_disable_msi(pdev);
-	}
-
+	pci_free_irq_vectors(pdev);
 	pci_clear_master(pdev);
 	pci_release_mem_regions(pdev);
 	pci_disable_device(pdev);
@@ -4097,7 +4065,6 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 		goto err_hclge_dev;
 	}
 
-	hdev->flag |= HCLGE_FLAG_USE_MSIX;
 	hdev->pdev = pdev;
 	hdev->ae_dev = ae_dev;
 	ae_dev->priv = hdev;
@@ -4126,12 +4093,9 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 		return ret;
 	}
 
-	if (hdev->flag & HCLGE_FLAG_USE_MSIX)
-		ret = hclge_init_msix(hdev);
-	else
-		ret = hclge_init_msi(hdev);
+	ret = hclge_init_msi(hdev);
 	if (ret) {
-		dev_err(&pdev->dev, "Init msix/msi error, ret = %d.\n", ret);
+		dev_err(&pdev->dev, "Init MSI/MSI-X error, ret = %d.\n", ret);
 		return ret;
 	}
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 9fcfd93..ab87843 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -400,9 +400,6 @@ struct hclge_dev {
 	u16 num_tqps;			/* Num task queue pairs of this PF */
 	u16 num_req_vfs;		/* Num VFs requested for this PF */
 
-	u16 num_roce_msix;		/* Num of roce vectors for this PF */
-	int roce_base_vector;
-
 	/* Base task tqp physical id of this PF */
 	u16 base_tqp_pid;
 	u16 alloc_rss_size;		/* Allocated RSS task queue */
@@ -429,8 +426,10 @@ struct hclge_dev {
 	u16 num_msi_left;
 	u16 num_msi_used;
 	u32 base_msi_vector;
-	struct msix_entry *msix_entries;
 	u16 *vector_status;
+	int *vector_irq;
+	u16 num_roce_msi;	/* Num of roce vectors for this PF */
+	int roce_base_vector;
 
 	u16 pending_udp_bitmap;
 
@@ -454,11 +453,9 @@ struct hclge_dev {
 	struct hnae3_client *nic_client;
 	struct hnae3_client *roce_client;
 
-#define HCLGE_FLAG_USE_MSI	0x00000001
-#define HCLGE_FLAG_USE_MSIX	0x00000002
-#define HCLGE_FLAG_MAIN		0x00000004
-#define HCLGE_FLAG_DCB_CAPABLE	0x00000008
-#define HCLGE_FLAG_DCB_ENABLE	0x00000010
+#define HCLGE_FLAG_MAIN			BIT(0)
+#define HCLGE_FLAG_DCB_CAPABLE		BIT(1)
+#define HCLGE_FLAG_DCB_ENABLE		BIT(2)
 	u32 flag;
 
 	u32 pkt_buf_size; /* Total pf buf size for tx/rx */
-- 
2.7.4


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
