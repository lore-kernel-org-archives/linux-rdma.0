From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/7] ibacm: Track inactive devices and ports
Date: Fri, 4 Mar 2011 16:02:35 -0800
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25CC92EAC0@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When obtaining a list of devices and ports, store all that are
available in the local device list, including those that are not
active.  This will allow the ib_acm service to handle dynamic
changes, like port up/down events.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/acm.c |   20 +++++---------------
 1 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index 38f41d2..f21f702 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -123,7 +123,6 @@ struct acm_device
 	struct ibv_pd           *pd;
 	uint64_t                guid;
 	DLIST_ENTRY             entry;
-	uint8_t                 active;
 	int                     port_cnt;
 	struct acm_port         port[0];
 };
@@ -2646,7 +2645,6 @@ err2:
 	ibv_destroy_ah(port->sa_dest.ah);
 err1:
 	port->state = IBV_PORT_NOP;
-	port->dev->active--;
 }
 
 static int acm_activate_dev(struct acm_device *dev)
@@ -2661,7 +2659,7 @@ static int acm_activate_dev(struct acm_device *dev)
 	dev->channel = ibv_create_comp_channel(dev->verbs);
 	if (!dev->channel) {
 		acm_log(0, "ERROR - unable to create comp channel\n");
-		goto err1;
+		goto err;
 	}
 
 	for (i = 0; i < dev->port_cnt; i++) {
@@ -2670,16 +2668,11 @@ static int acm_activate_dev(struct acm_device *dev)
 			acm_activate_port(&dev->port[i]);
 	}
 
-	if (!dev->active)
-		goto err2;
-
 	acm_log(1, "starting completion thread\n");
 	beginthread(acm_comp_handler, dev);
 	return 0;
 
-err2:
-	ibv_destroy_comp_channel(dev->channel);
-err1:
+err:
 	ibv_dealloc_pd(dev->pd);
 	return -1;
 }
@@ -2723,9 +2716,6 @@ static void acm_init_port(struct acm_port *port)
 	port->sa_dest.av.sl = attr.sm_sl;
 	port->sa_dest.av.port_num = port->port_num;
 	port->sa_dest.remote_qpn = 1;
-
-	if (port->state == IBV_PORT_ACTIVE)
-		port->dev->active++;
 }
 
 static void acm_open_dev(struct ibv_device *ibdev)
@@ -2764,10 +2754,10 @@ static void acm_open_dev(struct ibv_device *ibdev)
 		acm_init_port(&dev->port[i]);
 	}
 
-	if (!dev->active || acm_activate_dev(dev))
+	if (acm_activate_dev(dev))
 		goto err2;
 
-	acm_log(1, "%s now active\n", ibdev->name);
+	acm_log(1, "%s opened\n", ibdev->name);
 	DListInsertHead(&dev->entry, &dev_list);
 	return;
 
@@ -2987,7 +2977,7 @@ int CDECL_FUNC main(int argc, char **argv)
 
 	ibv_free_device_list(ibdev);
 	if (DListEmpty(&dev_list)) {
-		acm_log(0, "ERROR - no active devices\n");
+		acm_log(0, "ERROR - no devices\n");
 		return -1;
 	}
 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
