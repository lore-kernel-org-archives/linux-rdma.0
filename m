From: Allen Pais <allen.lkml-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 7/8] infiniband: nes: use setup_timer() helper.
Date: Fri, 22 Sep 2017 15:57:15 +0530
Message-ID: <1506076036-16496-8-git-send-email-allen.lkml@gmail.com>
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
 drivers/infiniband/hw/nes/nes_cm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index de4025d..b1de123 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -2670,8 +2670,7 @@ static struct nes_cm_core *nes_cm_alloc_core(void)
 		return NULL;
 
 	INIT_LIST_HEAD(&cm_core->connected_nodes);
-	init_timer(&cm_core->tcp_timer);
-	cm_core->tcp_timer.function = nes_cm_timer_tick;
+	setup_timer(&cm_core->tcp_timer, nes_cm_timer_tick, 0UL);
 
 	cm_core->mtu = NES_CM_DEFAULT_MTU;
 	cm_core->state = NES_CM_STATE_INITED;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
