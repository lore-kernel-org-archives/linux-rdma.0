From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] IB/qib: Cleanup qib_set_part_key() with direct returns
Date: Tue, 14 Nov 2017 16:29:41 -0500
Message-ID: <20171114212941.17403.71398.stgit@phlsvslse11.ph.intel.com>
References: <20171114212905.17403.77778.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114212905.17403.77778.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>

Perhaps the function is better written without
the empty bail: label and without setting ret
and just using return.

Combining the int/bool conversion of any and the
direct returns makes the resulting code clearer.

Tested-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_file_ops.c |   66 +++++++++++-------------------
 1 file changed, 24 insertions(+), 42 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_file_ops.c b/drivers/infiniband/hw/qib/qib_file_ops.c
index b25571f..7613564 100644
--- a/drivers/infiniband/hw/qib/qib_file_ops.c
+++ b/drivers/infiniband/hw/qib/qib_file_ops.c
@@ -568,20 +568,16 @@ static int qib_tid_free(struct qib_ctxtdata *rcd, unsigned subctxt,
 static int qib_set_part_key(struct qib_ctxtdata *rcd, u16 key)
 {
 	struct qib_pportdata *ppd = rcd->ppd;
-	int i, any = 0, pidx = -1;
+	int i, pidx = -1;
+	bool any = false;
 	u16 lkey = key & 0x7FFF;
-	int ret;
 
-	if (lkey == (QIB_DEFAULT_P_KEY & 0x7FFF)) {
+	if (lkey == (QIB_DEFAULT_P_KEY & 0x7FFF))
 		/* nothing to do; this key always valid */
-		ret = 0;
-		goto bail;
-	}
+		return 0;
 
-	if (!lkey) {
-		ret = -EINVAL;
-		goto bail;
-	}
+	if (!lkey)
+		return -EINVAL;
 
 	/*
 	 * Set the full membership bit, because it has to be
@@ -594,18 +590,14 @@ static int qib_set_part_key(struct qib_ctxtdata *rcd, u16 key)
 	for (i = 0; i < ARRAY_SIZE(rcd->pkeys); i++) {
 		if (!rcd->pkeys[i] && pidx == -1)
 			pidx = i;
-		if (rcd->pkeys[i] == key) {
-			ret = -EEXIST;
-			goto bail;
-		}
+		if (rcd->pkeys[i] == key)
+			return -EEXIST;
 	}
-	if (pidx == -1) {
-		ret = -EBUSY;
-		goto bail;
-	}
-	for (any = i = 0; i < ARRAY_SIZE(ppd->pkeys); i++) {
+	if (pidx == -1)
+		return -EBUSY;
+	for (i = 0; i < ARRAY_SIZE(ppd->pkeys); i++) {
 		if (!ppd->pkeys[i]) {
-			any++;
+			any = true;
 			continue;
 		}
 		if (ppd->pkeys[i] == key) {
@@ -613,44 +605,34 @@ static int qib_set_part_key(struct qib_ctxtdata *rcd, u16 key)
 
 			if (atomic_inc_return(pkrefs) > 1) {
 				rcd->pkeys[pidx] = key;
-				ret = 0;
-				goto bail;
-			} else {
-				/*
-				 * lost race, decrement count, catch below
-				 */
-				atomic_dec(pkrefs);
-				any++;
+				return 0;
 			}
+			/*
+			 * lost race, decrement count, catch below
+			 */
+			atomic_dec(pkrefs);
+			any = true;
 		}
-		if ((ppd->pkeys[i] & 0x7FFF) == lkey) {
+		if ((ppd->pkeys[i] & 0x7FFF) == lkey)
 			/*
 			 * It makes no sense to have both the limited and
 			 * full membership PKEY set at the same time since
 			 * the unlimited one will disable the limited one.
 			 */
-			ret = -EEXIST;
-			goto bail;
-		}
-	}
-	if (!any) {
-		ret = -EBUSY;
-		goto bail;
+			return -EEXIST;
 	}
+	if (!any)
+		return -EBUSY;
 	for (i = 0; i < ARRAY_SIZE(ppd->pkeys); i++) {
 		if (!ppd->pkeys[i] &&
 		    atomic_inc_return(&ppd->pkeyrefs[i]) == 1) {
 			rcd->pkeys[pidx] = key;
 			ppd->pkeys[i] = key;
 			(void) ppd->dd->f_set_ib_cfg(ppd, QIB_IB_CFG_PKEYS, 0);
-			ret = 0;
-			goto bail;
+			return 0;
 		}
 	}
-	ret = -EBUSY;
-
-bail:
-	return ret;
+	return -EBUSY;
 }
 
 /**

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
