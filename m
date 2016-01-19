From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 29/31] staging/rdma/hfi1: Use rdmavt device allocation
 function
Date: Tue, 19 Jan 2016 14:44:06 -0800
Message-ID: <20160119224406.32765.32425.stgit@scvm10.sc.intel.com>
References: <20160119223610.32765.10571.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160119223610.32765.10571.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

No longer do drivers need to call into the IB core to allocate the verbs
device.  Use the functionality provided by rdmavt.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/init.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/init.c b/drivers/staging/rdma/hfi1/init.c
index d1cb2c8..7def3f3 100644
--- a/drivers/staging/rdma/hfi1/init.c
+++ b/drivers/staging/rdma/hfi1/init.c
@@ -998,13 +998,16 @@ struct hfi1_devdata *hfi1_alloc_devdata(struct pci_dev *pdev, size_t extra)
 {
 	unsigned long flags;
 	struct hfi1_devdata *dd;
-	int ret;
+	int ret, nports;
+
+	/* extra is * number of ports */
+	nports = extra / sizeof(struct hfi1_pportdata);
 
-	dd = (struct hfi1_devdata *)ib_alloc_device(sizeof(*dd) + extra);
+	dd = (struct hfi1_devdata *)rvt_alloc_device(sizeof(*dd) + extra,
+						     nports);
 	if (!dd)
 		return ERR_PTR(-ENOMEM);
-	/* extra is * number of ports */
-	dd->num_pports = extra / sizeof(struct hfi1_pportdata);
+	dd->num_pports = nports;
 	dd->pport = (struct hfi1_pportdata *)(dd + 1);
 
 	INIT_LIST_HEAD(&dd->list);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
