From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] staging/rdma/hfi1: Fix for module parameter hdrq_entsize
 when it's 0
Date: Thu, 10 Dec 2015 16:02:49 -0500
Message-ID: <20151210210249.2436.56776.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

If driver is loaded with parameter hdrq_entsize=0, then
there's a NULL dereference when the driver gets unloaded.
This causes a kernel Oops and prevents the module  from
being unloaded. This patch fixes this issue by making sure
-EINVAL gets returned when hdrq_entsize=0.

Reviewed-by: Chegondi, Harish <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Haralanov, Mitko <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/init.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/rdma/hfi1/init.c b/drivers/staging/rdma/hfi1/init.c
index 1c8286f..b61a854 100644
--- a/drivers/staging/rdma/hfi1/init.c
+++ b/drivers/staging/rdma/hfi1/init.c
@@ -1350,6 +1350,7 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (!encode_rcv_header_entry_size(hfi1_hdrq_entsize)) {
 		hfi1_early_err(&pdev->dev, "Invalid HdrQ Entry size %u\n",
 			       hfi1_hdrq_entsize);
+		ret = -EINVAL;
 		goto bail;
 	}
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
