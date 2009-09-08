From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 2/2] RDMA/cxgb3: clean up properly on FW mismatch failures.
Date: Tue, 08 Sep 2009 16:30:06 -0500
Message-ID: <20090908213006.15369.19707.stgit@build.ogc.int>
References: <20090908213001.15369.15629.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090908213001.15369.15629.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

FW mismatches can cause a crash in the iw_cxgb3 event handler.

- NULL the t3cdev->ulp pointer on failures in cxio_rdev_open()

- Silently ignore events with the ulp ptr is null in iwch_err_handler()

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb3/cxio_hal.c |    1 +
 drivers/infiniband/hw/cxgb3/iwch.c     |    5 ++++-
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/cxio_hal.c b/drivers/infiniband/hw/cxgb3/cxio_hal.c
index 4dec515..68955f8 100644
--- a/drivers/infiniband/hw/cxgb3/cxio_hal.c
+++ b/drivers/infiniband/hw/cxgb3/cxio_hal.c
@@ -1034,6 +1034,7 @@ err3:
 err2:
 	cxio_hal_destroy_ctrl_qp(rdev_p);
 err1:
+	rdev_p->t3cdev_p->ulp = (void *) NULL;
 	list_del(&rdev_p->entry);
 	return err;
 }
diff --git a/drivers/infiniband/hw/cxgb3/iwch.c b/drivers/infiniband/hw/cxgb3/iwch.c
index 5796170..3f0c99d 100644
--- a/drivers/infiniband/hw/cxgb3/iwch.c
+++ b/drivers/infiniband/hw/cxgb3/iwch.c
@@ -165,10 +165,13 @@ static void close_rnic_dev(struct t3cdev *tdev)
 static void iwch_event_handler(struct t3cdev *tdev, u32 evt, u32 port_id)
 {
 	struct cxio_rdev *rdev = tdev->ulp;
-	struct iwch_dev *rnicp = rdev_to_iwch_dev(rdev);
+	struct iwch_dev *rnicp;
 	struct ib_event event;
 	u32    portnum = port_id + 1;
 
+	if (!rdev)
+		return;
+	rnicp = rdev_to_iwch_dev(rdev);
 	switch (evt) {
 	case OFFLOAD_STATUS_DOWN: {
 		rdev->flags = CXIO_ERROR_FATAL;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
