From: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Subject: [PATCH 4/5] IB/qib: Use kcalloc() in qib_init_pportdata()
Date: Wed, 5 Apr 2017 15:54:45 +0200
Message-ID: <e715e921-acef-b406-943c-b61b76d0ff42@users.sourceforge.net>
References: <c16b18ac-287f-5faf-b79a-c86e2adfa22c@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <c16b18ac-287f-5faf-b79a-c86e2adfa22c-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Language: en-GB
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Date: Wed, 5 Apr 2017 14:20:10 +0200

* Multiplications for the size determination of memory allocations
  indicated that array data structures should be processed.
  Thus use the corresponding function "kcalloc".

  This issue was detected by using the Coccinelle software.

* Replace the specification of data structures by pointer dereferences
  to make the corresponding size determination a bit safer according to
  the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_init.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
index 9e680ca971e3..101580f0460a 100644
--- a/drivers/infiniband/hw/qib/qib_init.c
+++ b/drivers/infiniband/hw/qib/qib_init.c
@@ -258,15 +258,15 @@ int qib_init_pportdata(struct qib_pportdata *ppd, struct qib_devdata *dd,
 
 	ppd->cc_max_table_entries =
 		ppd->cc_supported_table_entries/IB_CCT_ENTRIES;
-
-	size = IB_CC_TABLE_CAP_DEFAULT * sizeof(struct ib_cc_table_entry)
-		* IB_CCT_ENTRIES;
-	ppd->ccti_entries = kzalloc(size, GFP_KERNEL);
+	ppd->ccti_entries = kcalloc(IB_CC_TABLE_CAP_DEFAULT * IB_CCT_ENTRIES,
+				    sizeof(*ppd->ccti_entries),
+				    GFP_KERNEL);
 	if (!ppd->ccti_entries)
 		goto bail;
 
-	size = IB_CC_CCS_ENTRIES * sizeof(struct ib_cc_congestion_entry);
-	ppd->congestion_entries = kzalloc(size, GFP_KERNEL);
+	ppd->congestion_entries = kcalloc(IB_CC_CCS_ENTRIES,
+					  sizeof(*ppd->congestion_entries),
+					  GFP_KERNEL);
 	if (!ppd->congestion_entries)
 		goto bail_1;
 
-- 
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
