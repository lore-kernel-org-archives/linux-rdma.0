From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH RESEND 06/11] staging/rdma/hfi1: Select only devices with active links
Date: Fri,  6 Nov 2015 20:07:01 -0500
Message-ID: <1446858426-30509-7-git-send-email-jubin.john@intel.com>
References: <1446858426-30509-1-git-send-email-jubin.john@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1446858426-30509-1-git-send-email-jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

When looking for or validating a user device, only use devices
that are currently active.

Reviewed-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/file_ops.c |   21 ++++++++++++++++++---
 1 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/file_ops.c b/drivers/staging/rdma/hfi1/file_ops.c
index fba5889..6fc7691 100644
--- a/drivers/staging/rdma/hfi1/file_ops.c
+++ b/drivers/staging/rdma/hfi1/file_ops.c
@@ -874,6 +874,14 @@ done:
 	return ret;
 }
 
+/* return true if the device available for general use */
+static int usable_device(struct hfi1_devdata *dd)
+{
+	struct hfi1_pportdata *ppd = dd->pport;
+
+	return driver_lstate(ppd) == IB_PORT_ACTIVE;
+}
+
 static int get_user_context(struct file *fp, struct hfi1_user_info *uinfo,
 			    int devno, unsigned alg)
 {
@@ -903,7 +911,11 @@ static int get_user_context(struct file *fp, struct hfi1_user_info *uinfo,
 
 			for (dev = 0; dev < devmax; dev++) {
 				pdd = hfi1_lookup(dev);
-				if (pdd && pdd->freectxts &&
+				if (!pdd)
+					continue;
+				if (!usable_device(pdd))
+					continue;
+				if (pdd->freectxts &&
 				    pdd->freectxts > free) {
 					dd = pdd;
 					free = pdd->freectxts;
@@ -912,7 +924,11 @@ static int get_user_context(struct file *fp, struct hfi1_user_info *uinfo,
 		} else {
 			for (dev = 0; dev < devmax; dev++) {
 				pdd = hfi1_lookup(dev);
-				if (pdd && pdd->freectxts) {
+				if (!pdd)
+					continue;
+				if (!usable_device(pdd))
+					continue;
+				if (pdd->freectxts) {
 					dd = pdd;
 					break;
 				}
@@ -936,7 +952,6 @@ static int find_shared_ctxt(struct file *fp,
 	for (ndev = 0; ndev < devmax; ndev++) {
 		struct hfi1_devdata *dd = hfi1_lookup(ndev);
 
-		/* device portion of usable() */
 		if (!(dd && (dd->flags & HFI1_PRESENT) && dd->kregbase))
 			continue;
 		for (i = dd->first_user_ctxt; i < dd->num_rcv_contexts; i++) {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
