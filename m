From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH ibacm] acm.c: Handle client reregister local event
Date: Fri, 02 Aug 2013 08:00:37 -0400
Message-ID: <51FB9F65.4040804@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


When client reregister is requested, ACM should rejoin/recreate
ACM multicast groups.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/acm.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index 0da20f8..81aeeb4 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -3282,6 +3282,13 @@ static void CDECL_FUNC acm_event_handler(void *context)
 			if (dev->port[i].state == IBV_PORT_ACTIVE)
 				acm_port_down(&dev->port[i]);
 			break;
+		case IBV_EVENT_CLIENT_REREGISTER:
+			if (dev->port[i].state == IBV_PORT_ACTIVE) {
+				acm_port_join(&dev->port[i]);
+				acm_log(1, "%s %d has reregistered\n",
+					dev->verbs->device->name, i);
+			}
+			break;
 		default:
 			break;
 		}
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
