From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/qib: Minor fixes to qib per SFF 8636
Date: Mon, 02 Nov 2015 12:13:14 -0500
Message-ID: <20151102171314.7574.32816.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Minor errors found via code inspection during future development.
SFF 8636 defines bit position 2 to hold the status indication of
QSFP memory paging. The mask used to test for the value was
incorrect and is fixed in this patch. Additionally, the dump
function had a mismatch between the field being printed out and
the field used to source the data which was fixed.

Reviewed-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reported-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_qsfp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_qsfp.c b/drivers/infiniband/hw/qib/qib_qsfp.c
index 5e27f76..4c7c3c8 100644
--- a/drivers/infiniband/hw/qib/qib_qsfp.c
+++ b/drivers/infiniband/hw/qib/qib_qsfp.c
@@ -292,7 +292,7 @@ int qib_refresh_qsfp_cache(struct qib_pportdata *ppd, struct qib_qsfp_cache *cp)
 		qib_dev_porterr(ppd->dd, ppd->port,
 				"QSFP byte0 is 0x%02X, S/B 0x0C/D\n", peek[0]);
 
-	if ((peek[2] & 2) == 0) {
+	if ((peek[2] & 4) == 0) {
 		/*
 		 * If cable is paged, rather than "flat memory", we need to
 		 * set the page to zero, Even if it already appears to be zero.
@@ -538,7 +538,7 @@ int qib_qsfp_dump(struct qib_pportdata *ppd, char *buf, int len)
 	sofar += scnprintf(buf + sofar, len - sofar, "Date:%.*s\n",
 			   QSFP_DATE_LEN, cd.date);
 	sofar += scnprintf(buf + sofar, len - sofar, "Lot:%.*s\n",
-			   QSFP_LOT_LEN, cd.date);
+			   QSFP_LOT_LEN, cd.lot);
 
 	while (bidx < QSFP_DEFAULT_HDR_CNT) {
 		int iidx;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
