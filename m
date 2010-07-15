From: miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH resend] RDMA/nes: corrected link type for nes card
Date: Thu, 15 Jul 2010 17:01:05 +0200
Message-ID: <20100715145854.2995.87831.stgit@gkslx010.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Now correct interface link type is set for ibv_query_port()

Signed-off-by: Mirek Walukiewicz <miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 drivers/infiniband/hw/nes/nes_verbs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index f179586..45bf56c 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -599,7 +599,7 @@ static int nes_query_port(struct ib_device *ibdev, u8 port, struct ib_port_attr
 	props->active_width = IB_WIDTH_4X;
 	props->active_speed = 1;
 	props->max_msg_sz = 0x80000000;
-
+	props->link_layer = IB_LINK_LAYER_ETHERNET;
 	return 0;
 }
 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
