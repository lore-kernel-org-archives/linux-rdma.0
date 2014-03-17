From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/qib: Fix memory leak of recv context when driver fails
 to initialize.
Date: Mon, 17 Mar 2014 14:07:16 -0400
Message-ID: <20140317180716.25881.96400.stgit@phlsvslse11.ph.intel.com>
References: <20140317180457.25881.47937.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140317180457.25881.47937.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In qib_create_ctxts() we allocate an array to hold recv contexts. Then attempt
to create data for those recv contexts. If that call to qib_create_ctxtdata()
fails then an error is returned but the previously allocated memory is not
freed.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_init.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
index 24e802f..1179a63 100644
--- a/drivers/infiniband/hw/qib/qib_init.c
+++ b/drivers/infiniband/hw/qib/qib_init.c
@@ -130,7 +130,6 @@ void qib_set_ctxtcnt(struct qib_devdata *dd)
 int qib_create_ctxts(struct qib_devdata *dd)
 {
 	unsigned i;
-	int ret;
 	int local_node_id = pcibus_to_node(dd->pcidev->bus);
 
 	if (local_node_id < 0)
@@ -145,8 +144,7 @@ int qib_create_ctxts(struct qib_devdata *dd)
 	if (!dd->rcd) {
 		qib_dev_err(dd,
 			"Unable to allocate ctxtdata array, failing\n");
-		ret = -ENOMEM;
-		goto done;
+		return -ENOMEM;
 	}
 
 	/* create (one or more) kctxt */
@@ -163,15 +161,14 @@ int qib_create_ctxts(struct qib_devdata *dd)
 		if (!rcd) {
 			qib_dev_err(dd,
 				"Unable to allocate ctxtdata for Kernel ctxt, failing\n");
-			ret = -ENOMEM;
-			goto done;
+			kfree(dd->rcd);
+			dd->rcd = NULL;
+			return -ENOMEM;
 		}
 		rcd->pkeys[0] = QIB_DEFAULT_P_KEY;
 		rcd->seq_cnt = 1;
 	}
-	ret = 0;
-done:
-	return ret;
+	return 0;
 }
 
 /*

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
