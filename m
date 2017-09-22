From: Allen Pais <allen.lkml-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 5/8] infiniband: nes: use setup_timer() helper.
Date: Fri, 22 Sep 2017 15:57:13 +0530
Message-ID: <1506076036-16496-6-git-send-email-allen.lkml@gmail.com>
References: <1506076036-16496-1-git-send-email-allen.lkml@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1506076036-16496-1-git-send-email-allen.lkml-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Allen Pais <allen.lkml-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

   Use setup_timer function instead of initializing timer with the
   function and data fields.

Signed-off-by: Allen Pais <allen.lkml-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_hw.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_hw.c b/drivers/infiniband/hw/nes/nes_hw.c
index b0adf65..248505f 100644
--- a/drivers/infiniband/hw/nes/nes_hw.c
+++ b/drivers/infiniband/hw/nes/nes_hw.c
@@ -598,19 +598,16 @@ struct nes_adapter *nes_init_adapter(struct nes_device *nesdev, u8 hw_rev) {
 	}
 
 	if (nesadapter->hw_rev == NE020_REV) {
-		init_timer(&nesadapter->mh_timer);
-		nesadapter->mh_timer.function = nes_mh_fix;
+		setup_timer(&nesadapter->mh_timer, nes_mh_fix,
+			    (unsigned long)nesdev);
 		nesadapter->mh_timer.expires = jiffies + (HZ/5);  /* 1 second */
-		nesadapter->mh_timer.data = (unsigned long)nesdev;
 		add_timer(&nesadapter->mh_timer);
 	} else {
 		nes_write32(nesdev->regs+NES_INTF_INT_STAT, 0x0f000000);
 	}
 
-	init_timer(&nesadapter->lc_timer);
-	nesadapter->lc_timer.function = nes_clc;
+	setup_timer(&nesadapter->lc_timer, nes_clc, (unsigned long)nesdev);
 	nesadapter->lc_timer.expires = jiffies + 3600 * HZ;  /* 1 hour */
-	nesadapter->lc_timer.data = (unsigned long)nesdev;
 	add_timer(&nesadapter->lc_timer);
 
 	list_add_tail(&nesadapter->list, &nes_adapter_list);
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
