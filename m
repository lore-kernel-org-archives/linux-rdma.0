From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: [PATCH] RDMA/nes: use designated initializers
Date: Fri, 16 Dec 2016 17:03:16 -0800
Message-ID: <20161217010316.GA140509@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Prepare to mark sensitive kernel structures for randomization by making
sure they're using designated initializers. These were identified during
allyesconfig builds of x86, arm, and arm64, with most initializer fixes
extracted from grsecurity.

Signed-off-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_cm.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index 8e703479e7ce..fb983df7c157 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -135,17 +135,17 @@ static void record_ird_ord(struct nes_cm_node *, u16, u16);
 /* instance of function pointers for client API */
 /* set address of this instance to cm_core->cm_ops at cm_core alloc */
 static const struct nes_cm_ops nes_cm_api = {
-	mini_cm_accelerated,
-	mini_cm_listen,
-	mini_cm_del_listen,
-	mini_cm_connect,
-	mini_cm_close,
-	mini_cm_accept,
-	mini_cm_reject,
-	mini_cm_recv_pkt,
-	mini_cm_dealloc_core,
-	mini_cm_get,
-	mini_cm_set
+	.accelerated = mini_cm_accelerated,
+	.listen = mini_cm_listen,
+	.stop_listener = mini_cm_del_listen,
+	.connect = mini_cm_connect,
+	.close = mini_cm_close,
+	.accept = mini_cm_accept,
+	.reject = mini_cm_reject,
+	.recv_pkt = mini_cm_recv_pkt,
+	.destroy_cm_core = mini_cm_dealloc_core,
+	.get = mini_cm_get,
+	.set = mini_cm_set
 };
 
 static struct nes_cm_core *g_cm_core;
-- 
2.7.4


-- 
Kees Cook
Nexus Security
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
