From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH v2 22/45] RDMA/i40iw: Remove a set-but-not-used variable
Date: Wed, 11 Oct 2017 10:49:04 -0700
Message-ID: <20171011174927.25113-23-bart.vanassche@wdc.com>
References: <20171011174927.25113-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171011174927.25113-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Reviewed-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_cm.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
index 4e1ff81c5ba0..f5cfb224e153 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
@@ -1199,7 +1199,6 @@ static void i40iw_cm_timer_tick(unsigned long pass)
 	struct i40iw_cm_core *cm_core = (struct i40iw_cm_core *)pass;
 	u32 settimer = 0;
 	unsigned long timetosend;
-	struct i40iw_sc_dev *dev;
 	unsigned long flags;
 
 	struct list_head timer_list;
@@ -1270,7 +1269,6 @@ static void i40iw_cm_timer_tick(unsigned long pass)
 		spin_unlock_irqrestore(&cm_node->retrans_list_lock, flags);
 
 		vsi = &cm_node->iwdev->vsi;
-		dev = cm_node->dev;
 
 		if (!cm_node->ack_rcvd) {
 			atomic_inc(&send_entry->sqbuf->refcount);
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
