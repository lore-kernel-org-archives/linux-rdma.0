From: Chris Moore <Chris.Moore-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/isert: Adjust CQ size to HW limits
Date: Fri, 31 Oct 2014 19:50:43 +0000
Message-ID: <462EF229174FDB4D92ACE4656EA5610051E3C4E6@CMEXMB1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


This is the isert version of the patch that Minh Tran submitted for iser.
isert has the same issue of trying to create a CQ with more CQEs than are supported by
the hardware.

Signed-off-by: Chris Moore <chris.moore-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

---

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 3effa93..f837a23 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -225,12 +225,16 @@ isert_create_device_ib_res(struct isert_device *device)
 	struct isert_cq_desc *cq_desc;
 	struct ib_device_attr *dev_attr;
 	int ret = 0, i, j;
+	int max_rx_cqe, max_tx_cqe;
 
 	dev_attr = &device->dev_attr;
 	ret = isert_query_device(ib_dev, dev_attr);
 	if (ret)
 		return ret;
 
+	max_rx_cqe = min(ISER_MAX_RX_CQ_LEN, dev_attr->max_cqe);
+	max_tx_cqe = min(ISER_MAX_TX_CQ_LEN, dev_attr->max_cqe);
+
 	/* asign function handlers */
 	if (dev_attr->device_cap_flags & IB_DEVICE_MEM_MGT_EXTENSIONS &&
 	    dev_attr->device_cap_flags & IB_DEVICE_SIGNATURE_HANDOVER) {
@@ -272,7 +276,7 @@ isert_create_device_ib_res(struct isert_device *device)
 						isert_cq_rx_callback,
 						isert_cq_event_callback,
 						(void *)&cq_desc[i],
-						ISER_MAX_RX_CQ_LEN, i);
+						max_rx_cqe, i);
 		if (IS_ERR(device->dev_rx_cq[i])) {
 			ret = PTR_ERR(device->dev_rx_cq[i]);
 			device->dev_rx_cq[i] = NULL;
@@ -284,7 +288,7 @@ isert_create_device_ib_res(struct isert_device *device)
 						isert_cq_tx_callback,
 						isert_cq_event_callback,
 						(void *)&cq_desc[i],
-						ISER_MAX_TX_CQ_LEN, i);
+						max_tx_cqe, i);
 		if (IS_ERR(device->dev_tx_cq[i])) {
 			ret = PTR_ERR(device->dev_tx_cq[i]);
 			device->dev_tx_cq[i] = NULL;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
