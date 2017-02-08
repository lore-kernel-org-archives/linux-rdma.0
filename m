From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH qperf] Destroy server's QP in CM mode.
Date: Wed, 8 Feb 2017 12:08:45 +0200
Message-ID: <1486548525-7518-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 src/rdma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/rdma.c b/src/rdma.c
index 0d370bd..117b429 100644
--- a/src/rdma.c
+++ b/src/rdma.c
@@ -1937,6 +1937,7 @@ cm_close(DEVICE *dev)
             error(SYS, "rdma_disconnect failed");
     cm_expect_event(dev, RDMA_CM_EVENT_DISCONNECTED);
     cm_ack_event(dev);
+    rdma_destroy_qp(dev->cm.id);
     rdma_destroy_id(dev->cm.id);
     rdma_destroy_event_channel(dev->cm.channel);
 }
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
