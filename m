From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 09/17] staging/rdma/hfi1: Correctly limit VLs against SDMA engines
Date: Tue,  1 Dec 2015 15:38:18 -0500
Message-ID: <1449002306-15180-10-git-send-email-jubin.john@intel.com>
References: <1449002306-15180-1-git-send-email-jubin.john@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449002306-15180-1-git-send-email-jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Correctly reduce the number of VLs when limited by the number
of SDMA engines.

The hardware has multiple egress mechanisms, SDMA and pio, and multiples
of those. These mechanisms are chosen using the VL (8)

The fix corrects a panic issue with one of the platforms that doesn't have
enough SDMA (4) mechanisms for the typical number of VLs.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
Changes in v2:
	- Added more information in commit message

 drivers/staging/rdma/hfi1/chip.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index d9bb389..d17fd29 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -10610,9 +10610,9 @@ struct hfi1_devdata *hfi1_init_dd(struct pci_dev *pdev,
 	/* insure num_vls isn't larger than number of sdma engines */
 	if (HFI1_CAP_IS_KSET(SDMA) && num_vls > dd->chip_sdma_engines) {
 		dd_dev_err(dd, "num_vls %u too large, using %u VLs\n",
-				num_vls, HFI1_MAX_VLS_SUPPORTED);
-		ppd->vls_supported = num_vls = HFI1_MAX_VLS_SUPPORTED;
-		ppd->vls_operational = ppd->vls_supported;
+			   num_vls, dd->chip_sdma_engines);
+		num_vls = dd->chip_sdma_engines;
+		ppd->vls_supported = dd->chip_sdma_engines;
 	}
 
 	/*
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
