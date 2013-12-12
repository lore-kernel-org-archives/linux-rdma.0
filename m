From: "Nicholas A. Bellinger" <nab-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Subject: [PATCH] iser-target: Move INIT_WORK setup into isert_create_device_ib_res
Date: Thu, 12 Dec 2013 00:05:12 +0000
Message-ID: <1386806712-18686-1-git-send-email-nab@daterainc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>

This patch moves INIT_WORK setup for cq_desc->cq_[rx,tx]_work into
isert_create_device_ib_res(), instead of being done each callback
invocation in isert_cq_[rx,tx]_callback().

This also fixes a 'INFO: trying to register non-static key' warning
when cancel_work_sync() is called before INIT_WORK has setup the
struct work_struct.

Reported-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 78f6e92..9804fca 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -207,7 +207,9 @@ isert_free_rx_descriptors(struct isert_conn *isert_conn)
 	isert_conn->conn_rx_descs = NULL;
 }
 
+static void isert_cq_tx_work(struct work_struct *);
 static void isert_cq_tx_callback(struct ib_cq *, void *);
+static void isert_cq_rx_work(struct work_struct *);
 static void isert_cq_rx_callback(struct ib_cq *, void *);
 
 static int
@@ -259,6 +261,7 @@ isert_create_device_ib_res(struct isert_device *device)
 		cq_desc[i].device = device;
 		cq_desc[i].cq_index = i;
 
+		INIT_WORK(&cq_desc[i].cq_rx_work, isert_cq_rx_work);
 		device->dev_rx_cq[i] = ib_create_cq(device->ib_device,
 						isert_cq_rx_callback,
 						isert_cq_event_callback,
@@ -270,6 +273,7 @@ isert_create_device_ib_res(struct isert_device *device)
 			goto out_cq;
 		}
 
+		INIT_WORK(&cq_desc[i].cq_tx_work, isert_cq_tx_work);
 		device->dev_tx_cq[i] = ib_create_cq(device->ib_device,
 						isert_cq_tx_callback,
 						isert_cq_event_callback,
@@ -1732,7 +1736,6 @@ isert_cq_tx_callback(struct ib_cq *cq, void *context)
 {
 	struct isert_cq_desc *cq_desc = (struct isert_cq_desc *)context;
 
-	INIT_WORK(&cq_desc->cq_tx_work, isert_cq_tx_work);
 	queue_work(isert_comp_wq, &cq_desc->cq_tx_work);
 }
 
@@ -1776,7 +1779,6 @@ isert_cq_rx_callback(struct ib_cq *cq, void *context)
 {
 	struct isert_cq_desc *cq_desc = (struct isert_cq_desc *)context;
 
-	INIT_WORK(&cq_desc->cq_rx_work, isert_cq_rx_work);
 	queue_work(isert_rx_wq, &cq_desc->cq_rx_work);
 }
 
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
