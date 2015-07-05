From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH V3 3/5] RDMA/isert: Use transport independent MR allocation
Date: Sun, 05 Jul 2015 18:22:12 -0500
Message-ID: <20150705232211.12029.78085.stgit@build2.ogc.int>
References: <20150705231831.12029.80307.stgit@build2.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150705231831.12029.80307.stgit-PBeJgSbIpn97NCTnQtmixQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Use rdma_get_dma_mr() to allocate the DMA MR.

Use rdma_fast_reg_access_flags() to set the access_flags for fast
register work requests.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/ulp/isert/ib_isert.c |   36 +++++--------------------------
 1 files changed, 6 insertions(+), 30 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 35015c9..ea6f540 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -350,21 +350,11 @@ out_cq:
 	return ret;
 }
 
-static int any_port_is_iwarp(struct isert_device *device)
-{
-	int i;
-
-	for (i = rdma_start_port(device->ib_device);
-	     i <= rdma_end_port(device->ib_device); i++)
-		if (rdma_protocol_iwarp(device->ib_device, i))
-			return 1;
-	return 0;
-}
-
 static int
 isert_create_device_ib_res(struct isert_device *device)
 {
 	struct ib_device_attr *dev_attr;
+	int mr_roles;
 	int ret;
 
 	dev_attr = &device->dev_attr;
@@ -396,16 +386,9 @@ isert_create_device_ib_res(struct isert_device *device)
 		goto out_cq;
 	}
 
-	/*
-	 * IWARP transports need REMOTE_WRITE for MRs used as the target of
-	 * an RDMA_READ.  Since the DMA MR is used for all ports, then if
-	 * any port is running IWARP, add REMOTE_WRITE.
-	 */
-	if (any_port_is_iwarp(device))
-		device->mr = ib_get_dma_mr(device->pd, IB_ACCESS_LOCAL_WRITE |
-						       IB_ACCESS_REMOTE_WRITE);
-	else
-		device->mr = ib_get_dma_mr(device->pd, IB_ACCESS_LOCAL_WRITE);
+	mr_roles = RDMA_MRR_RECV | RDMA_MRR_SEND | RDMA_MRR_WRITE_SOURCE |
+		   RDMA_MRR_READ_DEST;
+	device->mr = rdma_get_dma_mr(device->pd, mr_roles, 0);
 	if (IS_ERR(device->mr)) {
 		ret = PTR_ERR(device->mr);
 		isert_err("failed to create dma mr, device %p, ret=%d\n",
@@ -2644,15 +2627,8 @@ isert_fast_reg_mr(struct isert_conn *isert_conn,
 	fr_wr.wr.fast_reg.page_shift = PAGE_SHIFT;
 	fr_wr.wr.fast_reg.length = mem->len;
 	fr_wr.wr.fast_reg.rkey = mr->rkey;
-	fr_wr.wr.fast_reg.access_flags = IB_ACCESS_LOCAL_WRITE;
-
-	/*
-	 * IWARP transports need REMOTE_WRITE for MRs used as the target of
-	 * an RDMA_READ.
-	 */
-	if (rdma_protocol_iwarp(ib_dev, isert_conn->cm_id->port_num))
-		fr_wr.wr.fast_reg.access_flags |= IB_ACCESS_REMOTE_WRITE;
-
+	fr_wr.wr.fast_reg.access_flags = rdma_fast_reg_access_flags(
+		device->pd, RDMA_MRR_WRITE_SOURCE | RDMA_MRR_READ_DEST, 0);
 	if (!wr)
 		wr = &fr_wr;
 	else

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
