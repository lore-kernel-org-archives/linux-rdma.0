From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 06/12] IB/hfi1: Set default_desc1 just one time
Date: Tue, 26 Sep 2017 07:00:37 -0700
Message-ID: <20170926140035.15601.15210.stgit@scvm10.sc.intel.com>
References: <20170926135843.15601.95865.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170926135843.15601.95865.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

There is no reason to set the default descriptor flag on every SDMA
engine initialization.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/sdma.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/sdma.c b/drivers/infiniband/hw/hfi1/sdma.c
index 6781bcd..e7df779 100644
--- a/drivers/infiniband/hw/hfi1/sdma.c
+++ b/drivers/infiniband/hw/hfi1/sdma.c
@@ -1392,6 +1392,13 @@ int sdma_init(struct hfi1_devdata *dd, u8 port)
 		return ret;
 
 	idle_cnt = ns_to_cclock(dd, idle_cnt);
+	if (idle_cnt)
+		dd->default_desc1 =
+			SDMA_DESC1_HEAD_TO_HOST_FLAG;
+	else
+		dd->default_desc1 =
+			SDMA_DESC1_INT_REQ_FLAG;
+
 	if (!sdma_desct_intr)
 		sdma_desct_intr = SDMA_DESC_INTR;
 
@@ -1436,13 +1443,6 @@ int sdma_init(struct hfi1_devdata *dd, u8 port)
 		sde->tail_csr =
 			get_kctxt_csr_addr(dd, this_idx, SD(TAIL));
 
-		if (idle_cnt)
-			dd->default_desc1 =
-				SDMA_DESC1_HEAD_TO_HOST_FLAG;
-		else
-			dd->default_desc1 =
-				SDMA_DESC1_INT_REQ_FLAG;
-
 		tasklet_init(&sde->sdma_hw_clean_up_task, sdma_hw_clean_up_task,
 			     (unsigned long)sde);
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
