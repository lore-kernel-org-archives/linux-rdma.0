From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 4/6] IB/hfi1: Fix indentation
Date: Fri, 3 Jun 2016 12:09:56 -0700
Message-ID: <54ad6b3b-4185-9345-26d0-ab3fd9ce36e4@sandisk.com>
References: <86c06ca1-753c-6b45-3f65-f9a19f7693cf@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <86c06ca1-753c-6b45-3f65-f9a19f7693cf-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Make the indentation of the source code consistent. Detected by
smatch.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c | 6 +++---
 drivers/infiniband/hw/hfi1/init.c | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 3b876da..81619fb 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -7832,8 +7832,8 @@ static void handle_dcc_err(struct hfi1_devdata *dd, u32 unused, u64 reg)
 			 * save first 2 flits in the packet that caused
 			 * the error
 			 */
-			 dd->err_info_rcvport.packet_flit1 = hdr0;
-			 dd->err_info_rcvport.packet_flit2 = hdr1;
+			dd->err_info_rcvport.packet_flit1 = hdr0;
+			dd->err_info_rcvport.packet_flit2 = hdr1;
 		}
 		switch (info) {
 		case 1:
@@ -11906,7 +11906,7 @@ static void update_synth_timer(unsigned long opaque)
 		hfi1_cdbg(CNTR, "[%d] No update necessary", dd->unit);
 	}
 
-mod_timer(&dd->synth_stats_timer, jiffies + HZ * SYNTH_CNT_TIME);
+	mod_timer(&dd->synth_stats_timer, jiffies + HZ * SYNTH_CNT_TIME);
 }
 
 #define C_MAX_NAME 13 /* 12 chars + one for /0 */
diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 5cc492e..0d28a5a 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1337,7 +1337,7 @@ static void cleanup_device_data(struct hfi1_devdata *dd)
 		dma_free_coherent(&dd->pcidev->dev, sizeof(u64),
 				  (void *)dd->rcvhdrtail_dummy_kvaddr,
 				  dd->rcvhdrtail_dummy_physaddr);
-				  dd->rcvhdrtail_dummy_kvaddr = NULL;
+		dd->rcvhdrtail_dummy_kvaddr = NULL;
 	}
 
 	for (ctxt = 0; tmp && ctxt < dd->num_rcv_contexts; ctxt++) {
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
