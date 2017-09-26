From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 08/12] IB/hfi1: Remove unnecessary error messages
 on alloc failures
Date: Tue, 26 Sep 2017 07:00:50 -0700
Message-ID: <20170926140048.15601.19915.stgit@scvm10.sc.intel.com>
References: <20170926135843.15601.95865.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170926135843.15601.95865.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Per-cpu variables int_counter, rcv_limit, and send_schedule
print unnecessary error messages on failed allocations.
Remove the error messages.

Reviewed-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/init.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index fba7700..3e686d2 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1272,24 +1272,18 @@ struct hfi1_devdata *hfi1_alloc_devdata(struct pci_dev *pdev, size_t extra)
 	dd->int_counter = alloc_percpu(u64);
 	if (!dd->int_counter) {
 		ret = -ENOMEM;
-		hfi1_early_err(&pdev->dev,
-			       "Could not allocate per-cpu int_counter\n");
 		goto bail;
 	}
 
 	dd->rcv_limit = alloc_percpu(u64);
 	if (!dd->rcv_limit) {
 		ret = -ENOMEM;
-		hfi1_early_err(&pdev->dev,
-			       "Could not allocate per-cpu rcv_limit\n");
 		goto bail;
 	}
 
 	dd->send_schedule = alloc_percpu(u64);
 	if (!dd->send_schedule) {
 		ret = -ENOMEM;
-		hfi1_early_err(&pdev->dev,
-			       "Could not allocate per-cpu int_counter\n");
 		goto bail;
 	}
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
