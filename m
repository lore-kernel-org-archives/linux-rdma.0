From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] IB/hfi1: Fix sleep inside atomic issue in init_asic_data
Date: Fri, 01 Jul 2016 15:57:08 -0700
Message-ID: <20160701225707.19381.34804.stgit@scvm10.sc.intel.com>
References: <20160701225447.19381.90323.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160701225447.19381.90323.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The critical section should protect only the list traversal
and dd->asic_data modification, not the memory allocation.
The fix pulls the allocation out of the critical section.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c |   21 ++++++++++++++-------
 1 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index f5de851..0662451 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -14113,8 +14113,14 @@ static int init_asic_data(struct hfi1_devdata *dd)
 {
 	unsigned long flags;
 	struct hfi1_devdata *tmp, *peer = NULL;
+	struct hfi1_asic_data *asic_data;
 	int ret = 0;
 
+	/* pre-allocate the asic structure in case we are the first device */
+	asic_data = kzalloc(sizeof(*dd->asic_data), GFP_KERNEL);
+	if (!asic_data)
+		return -ENOMEM;
+
 	spin_lock_irqsave(&hfi1_devs_lock, flags);
 	/* Find our peer device */
 	list_for_each_entry(tmp, &hfi1_dev_list, list) {
@@ -14126,19 +14132,20 @@ static int init_asic_data(struct hfi1_devdata *dd)
 	}
 
 	if (peer) {
+		/* use already allocated structure */
 		dd->asic_data = peer->asic_data;
+		kfree(asic_data);
 	} else {
-		dd->asic_data = kzalloc(sizeof(*dd->asic_data), GFP_KERNEL);
-		if (!dd->asic_data) {
-			ret = -ENOMEM;
-			goto done;
-		}
+		dd->asic_data = asic_data;
 		mutex_init(&dd->asic_data->asic_resource_mutex);
 	}
 	dd->asic_data->dds[dd->hfi1_id] = dd; /* self back-pointer */
-
-done:
 	spin_unlock_irqrestore(&hfi1_devs_lock, flags);
+
+	/* first one through - set up i2c devices */
+	if (!peer)
+		ret = set_up_i2c(dd, dd->asic_data);
+
 	return ret;
 }
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
