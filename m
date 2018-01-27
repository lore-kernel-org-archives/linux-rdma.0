From: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Subject: [PATCH 2/2] RDMA/bnxt_re: Use common error handling code in
 bnxt_qplib_alloc_dpi_tbl()
Date: Sat, 27 Jan 2018 21:17:51 +0100
Message-ID: <30f2eb91-16c6-6c13-343d-64c5f42f2497@users.sourceforge.net>
References: <19c755a6-8c52-bbd5-a425-48fc08cecd4f@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <19c755a6-8c52-bbd5-a425-48fc08cecd4f-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Language: en-GB
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Himanshu Jha <himanshujha199640-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Date: Sat, 27 Jan 2018 20:56:56 +0100

Add a jump target so that a bit of exception handling can be better reused
at the end of this function.

Signed-off-by: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_res.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_res.c b/drivers/infiniband/hw/bnxt_re/qplib_res.c
index 9dacfd24869b..539a5d44e6db 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_res.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_res.c
@@ -705,10 +705,8 @@ static int bnxt_qplib_alloc_dpi_tbl(struct bnxt_qplib_res     *res,
 	dpit->max = dbr_len / PAGE_SIZE;
 
 	dpit->app_tbl = kcalloc(dpit->max, sizeof(void *), GFP_KERNEL);
-	if (!dpit->app_tbl) {
-		pci_iounmap(res->pdev, dpit->dbr_bar_reg_iomem);
-		return -ENOMEM;
-	}
+	if (!dpit->app_tbl)
+		goto unmap_io;
 
 	bytes = dpit->max >> 3;
 	if (!bytes)
@@ -716,15 +714,18 @@ static int bnxt_qplib_alloc_dpi_tbl(struct bnxt_qplib_res     *res,
 
 	dpit->tbl = kmalloc(bytes, GFP_KERNEL);
 	if (!dpit->tbl) {
-		pci_iounmap(res->pdev, dpit->dbr_bar_reg_iomem);
 		kfree(dpit->app_tbl);
 		dpit->app_tbl = NULL;
-		return -ENOMEM;
+		goto unmap_io;
 	}
 
 	memset((u8 *)dpit->tbl, 0xFF, bytes);
 
 	return 0;
+
+unmap_io:
+	pci_iounmap(res->pdev, dpit->dbr_bar_reg_iomem);
+	return -ENOMEM;
 }
 
 /* PKEYs */
-- 
2.16.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
