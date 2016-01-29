From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 03/22] IB/srpt: Inline srpt_sdev_name()
Date: Fri, 29 Jan 2016 15:12:04 -0800
Message-ID: <56ABF1C4.3090106@sandisk.com>
References: <56ABF16E.7070006@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56ABF16E.7070006-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

srpt_sdev_name() is too trivial to keep it as a separate function.
Hence inline this function.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index fde32ed..0194624 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -109,16 +109,6 @@ enum dma_data_direction opposite_dma_dir(enum dma_data_direction dir)
 	}
 }
 
-/**
- * srpt_sdev_name() - Return the name associated with the HCA.
- *
- * Examples are ib0, ib1, ...
- */
-static inline const char *srpt_sdev_name(struct srpt_device *sdev)
-{
-	return sdev->device->name;
-}
-
 static enum rdma_ch_state srpt_get_ch_state(struct srpt_rdma_ch *ch)
 {
 	unsigned long flags;
@@ -182,7 +172,7 @@ static void srpt_event_handler(struct ib_event_handler *handler,
 		return;
 
 	pr_debug("ASYNC event= %d on device= %s\n", event->event,
-		 srpt_sdev_name(sdev));
+		 sdev->device->name);
 
 	switch (event->event) {
 	case IB_EVENT_PORT_ERR:
@@ -3082,7 +3072,7 @@ static void srpt_add_one(struct ib_device *device)
 
 		if (srpt_refresh_port(sport)) {
 			pr_err("MAD registration failed for %s-%d.\n",
-			       srpt_sdev_name(sdev), i);
+			       sdev->device->name, i);
 			goto err_ring;
 		}
 		snprintf(sport->port_guid, sizeof(sport->port_guid),
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
