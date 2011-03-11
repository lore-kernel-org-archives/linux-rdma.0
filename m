From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 7/7] RDMA/cxgb4: Dispatch FATAL event on EEH errors.
Date: Fri, 11 Mar 2011 16:30:53 -0600
Message-ID: <20110311223052.16418.31.stgit@build.ogc.int>
References: <20110311222826.16418.43582.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110311222826.16418.43582.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This at least kicks the user mode applications that are watching
for device events.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/device.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index 3e46b80..0bcd383 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -527,8 +527,16 @@ static int c4iw_uld_state_change(void *handle, enum cxgb4_state new_state)
 	case CXGB4_STATE_START_RECOVERY:
 		printk(KERN_INFO MOD "%s: Fatal Error\n",
 		       pci_name(dev->rdev.lldi.pdev));
-		if (dev->registered)
+		dev->rdev.flags |= T4_FATAL_ERROR;
+		if (dev->registered) {
+			struct ib_event event;
+
+			memset(&event, 0, sizeof event);
+			event.event  = IB_EVENT_DEVICE_FATAL;
+			event.device = &dev->ibdev;
+			ib_dispatch_event(&event);
 			c4iw_unregister_device(dev);
+		}
 		break;
 	case CXGB4_STATE_DETACH:
 		printk(KERN_INFO MOD "%s: Detach\n",

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
