From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 04/12] IB/hfi1: Return ENODEV for unsupported PCI device ids.
Date: Mon, 17 Oct 2016 04:19:24 -0700
Message-ID: <20161017111924.7934.95134.stgit@scvm10.sc.intel.com>
References: <20161017103326.7934.21558.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161017103326.7934.21558.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tymoteusz Kielan <tymoteusz.kielan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Krzysztof Blaszkowski <krzysztof.blaszkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Krzysztof Blaszkowski <krzysztof.blaszkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Clean up device type checking.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Krzysztof Blaszkowski <krzysztof.blaszkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Tymoteusz Kielan <tymoteusz.kielan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/init.c |   25 ++++++++++++-------------
 1 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 18f1976..5872f10 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1402,7 +1402,7 @@ static void postinit_cleanup(struct hfi1_devdata *dd)
 static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	int ret = 0, j, pidx, initfail;
-	struct hfi1_devdata *dd = ERR_PTR(-EINVAL);
+	struct hfi1_devdata *dd;
 	struct hfi1_pportdata *ppd;
 
 	/* First, lock the non-writable module parameters */
@@ -1461,26 +1461,25 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (ret)
 		goto bail;
 
-	/*
-	 * Do device-specific initialization, function table setup, dd
-	 * allocation, etc.
-	 */
-	switch (ent->device) {
-	case PCI_DEVICE_ID_INTEL0:
-	case PCI_DEVICE_ID_INTEL1:
-		dd = hfi1_init_dd(pdev, ent);
-		break;
-	default:
+	if (!(ent->device == PCI_DEVICE_ID_INTEL0 ||
+	      ent->device == PCI_DEVICE_ID_INTEL1)) {
 		hfi1_early_err(&pdev->dev,
 			       "Failing on unknown Intel deviceid 0x%x\n",
 			       ent->device);
 		ret = -ENODEV;
+		goto clean_bail;
 	}
 
-	if (IS_ERR(dd))
+	/*
+	 * Do device-specific initialization, function table setup, dd
+	 * allocation, etc.
+	 */
+	dd = hfi1_init_dd(pdev, ent);
+
+	if (IS_ERR(dd)) {
 		ret = PTR_ERR(dd);
-	if (ret)
 		goto clean_bail; /* error already printed */
+	}
 
 	ret = create_workqueues(dd);
 	if (ret)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
