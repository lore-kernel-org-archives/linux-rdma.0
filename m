From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH 06/12] IB/srpt: Verify port numbers in srpt_event_handler()
Date: Mon,  8 Jan 2018 11:00:45 -0800
Message-ID: <20180108190051.32008-7-bart.vanassche@wdc.com>
References: <20180108190051.32008-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180108190051.32008-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Verify whether port numbers are in the expected range before using
these as an array index. Complain if a port number is out of range.

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index a71664fe939b..c5efe0afa2c8 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -134,6 +134,7 @@ static void srpt_event_handler(struct ib_event_handler *handler,
 {
 	struct srpt_device *sdev;
 	struct srpt_port *sport;
+	u8 port_num;
 
 	sdev = ib_get_client_data(event->device, &srpt_client);
 	if (!sdev || sdev->device != event->device)
@@ -144,10 +145,15 @@ static void srpt_event_handler(struct ib_event_handler *handler,
 
 	switch (event->event) {
 	case IB_EVENT_PORT_ERR:
-		if (event->element.port_num <= sdev->device->phys_port_cnt) {
-			sport = &sdev->port[event->element.port_num - 1];
+		port_num = event->element.port_num - 1;
+		if (port_num < sdev->device->phys_port_cnt) {
+			sport = &sdev->port[port_num];
 			sport->lid = 0;
 			sport->sm_lid = 0;
+		} else {
+			WARN(true, "event %d: port_num %d out of range 1..%d\n",
+			     event->event, port_num + 1,
+			     sdev->device->phys_port_cnt);
 		}
 		break;
 	case IB_EVENT_PORT_ACTIVE:
@@ -157,15 +163,19 @@ static void srpt_event_handler(struct ib_event_handler *handler,
 	case IB_EVENT_CLIENT_REREGISTER:
 	case IB_EVENT_GID_CHANGE:
 		/* Refresh port data asynchronously. */
-		if (event->element.port_num <= sdev->device->phys_port_cnt) {
-			sport = &sdev->port[event->element.port_num - 1];
+		port_num = event->element.port_num - 1;
+		if (port_num < sdev->device->phys_port_cnt) {
+			sport = &sdev->port[port_num];
 			if (!sport->lid && !sport->sm_lid)
 				schedule_work(&sport->work);
+		} else {
+			WARN(true, "event %d: port_num %d out of range 1..%d\n",
+			     event->event, port_num + 1,
+			     sdev->device->phys_port_cnt);
 		}
 		break;
 	default:
-		pr_err("received unrecognized IB event %d\n",
-		       event->event);
+		pr_err("received unrecognized IB event %d\n", event->event);
 		break;
 	}
 }
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
