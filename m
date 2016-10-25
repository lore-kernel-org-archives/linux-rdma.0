From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/7] IB/hfi1: Relocate rcvhdrcnt module parameter check.
Date: Tue, 25 Oct 2016 13:12:11 -0700
Message-ID: <20161025201209.15765.45767.stgit@scvm10.sc.intel.com>
References: <20161025194241.15765.8903.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161025194241.15765.8903.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tymoteusz Kielan <tymoteusz.kielan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Krzysztof Blaszkowski <krzysztof.blaszkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Krzysztof Blaszkowski <krzysztof.blaszkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Validate the rcvhdrcnt module parameter in a single function at module
load time. This allows proper error reporting.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Krzysztof Blaszkowski <krzysztof.blaszkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Tymoteusz Kielan <tymoteusz.kielan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/init.c |   44 ++++++++++++++++++++++---------------
 1 files changed, 26 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index c317e69..3920bbf 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -262,13 +262,6 @@ struct hfi1_ctxtdata *hfi1_create_ctxtdata(struct hfi1_pportdata *ppd, u32 ctxt,
 		}
 		rcd->eager_base = base * dd->rcv_entries.group_size;
 
-		/* Validate and initialize Rcv Hdr Q variables */
-		if (rcvhdrcnt % HDRQ_INCREMENT) {
-			dd_dev_err(dd,
-				   "ctxt%u: header queue count %d must be divisible by %lu\n",
-				   rcd->ctxt, rcvhdrcnt, HDRQ_INCREMENT);
-			goto bail;
-		}
 		rcd->rcvhdrq_cnt = rcvhdrcnt;
 		rcd->rcvhdrqentsize = hfi1_hdrq_entsize;
 		/*
@@ -1399,6 +1392,29 @@ static void postinit_cleanup(struct hfi1_devdata *dd)
 	hfi1_free_devdata(dd);
 }
 
+static int init_validate_rcvhdrcnt(struct device *dev, uint thecnt)
+{
+	if (thecnt <= HFI1_MIN_HDRQ_EGRBUF_CNT) {
+		hfi1_early_err(dev, "Receive header queue count too small\n");
+		return -EINVAL;
+	}
+
+	if (thecnt > HFI1_MAX_HDRQ_EGRBUF_CNT) {
+		hfi1_early_err(dev,
+			       "Receive header queue count cannot be greater than %u\n",
+			       HFI1_MAX_HDRQ_EGRBUF_CNT);
+		return -EINVAL;
+	}
+
+	if (thecnt % HDRQ_INCREMENT) {
+		hfi1_early_err(dev, "Receive header queue count %d must be divisible by %lu\n",
+			       thecnt, HDRQ_INCREMENT);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	int ret = 0, j, pidx, initfail;
@@ -1409,18 +1425,10 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	HFI1_CAP_LOCK();
 
 	/* Validate some global module parameters */
-	if (rcvhdrcnt <= HFI1_MIN_HDRQ_EGRBUF_CNT) {
-		hfi1_early_err(&pdev->dev, "Header queue  count too small\n");
-		ret = -EINVAL;
-		goto bail;
-	}
-	if (rcvhdrcnt > HFI1_MAX_HDRQ_EGRBUF_CNT) {
-		hfi1_early_err(&pdev->dev,
-			       "Receive header queue count cannot be greater than %u\n",
-			       HFI1_MAX_HDRQ_EGRBUF_CNT);
-		ret = -EINVAL;
+	ret = init_validate_rcvhdrcnt(&pdev->dev, rcvhdrcnt);
+	if (ret)
 		goto bail;
-	}
+
 	/* use the encoding function as a sanitization check */
 	if (!encode_rcv_header_entry_size(hfi1_hdrq_entsize)) {
 		hfi1_early_err(&pdev->dev, "Invalid HdrQ Entry size %u\n",

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
