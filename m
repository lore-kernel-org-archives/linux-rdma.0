From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 09/20] IB/hfi1: Check device id early during init
Date: Mon, 20 Mar 2017 17:25:29 -0700
Message-ID: <20170321002528.28538.87308.stgit@scvm10.sc.intel.com>
References: <20170321001900.28538.38175.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170321001900.28538.38175.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

If there is a wrong device passed to the driver it should fail early,
without trying to initialize the device only to find out that it has
an invalid device later during the init.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/init.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index f40864e..9bfb8eb 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1425,6 +1425,16 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* First, lock the non-writable module parameters */
 	HFI1_CAP_LOCK();
 
+	/* Validate dev ids */
+	if (!(ent->device == PCI_DEVICE_ID_INTEL0 ||
+	      ent->device == PCI_DEVICE_ID_INTEL1)) {
+		hfi1_early_err(&pdev->dev,
+			       "Failing on unknown Intel deviceid 0x%x\n",
+			       ent->device);
+		ret = -ENODEV;
+		goto bail;
+	}
+
 	/* Validate some global module parameters */
 	ret = init_validate_rcvhdrcnt(&pdev->dev, rcvhdrcnt);
 	if (ret)
@@ -1470,15 +1480,6 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (ret)
 		goto bail;
 
-	if (!(ent->device == PCI_DEVICE_ID_INTEL0 ||
-	      ent->device == PCI_DEVICE_ID_INTEL1)) {
-		hfi1_early_err(&pdev->dev,
-			       "Failing on unknown Intel deviceid 0x%x\n",
-			       ent->device);
-		ret = -ENODEV;
-		goto clean_bail;
-	}
-
 	/*
 	 * Do device-specific initialization, function table setup, dd
 	 * allocation, etc.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
