From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] [librdmacm] librdmacm/ucmatose: Fix number of connections
 to disconnect
Date: Thu, 4 Oct 2012 19:54:44 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A99224@FMSMSX151.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When ucmatose aborts because of issues trying to connect
to the server, it moves to disconnecting all connections.
However, not all connections may have been established.
The result is that ucmatose will hang in disconnect_events.
Fix this by setting the number of times that we need to
disconnect to the number of times that we successfully
connect.

This problem is based on a report by Doug Ledford
<dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 examples/cmatose.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/examples/cmatose.c b/examples/cmatose.c
index 94fc4cd..9ea6777 100644
--- a/examples/cmatose.c
+++ b/examples/cmatose.c
@@ -211,7 +211,6 @@ static int post_sends(struct cmatest_node *node)
 
 static void connect_error(void)
 {
-	test.disconnects_left--;
 	test.connects_left--;
 }
 
@@ -323,6 +322,7 @@ static int cma_handler(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 	case RDMA_CM_EVENT_ESTABLISHED:
 		((struct cmatest_node *) cma_id->context)->connected = 1;
 		test.connects_left--;
+		test.disconnects_left++;
 		break;
 	case RDMA_CM_EVENT_ADDR_ERROR:
 	case RDMA_CM_EVENT_ROUTE_ERROR:
@@ -688,7 +688,6 @@ int main(int argc, char **argv)
 	}
 
 	test.connects_left = connections;
-	test.disconnects_left = connections;
 
 	test.channel = rdma_create_event_channel();
 	if (!test.channel) {


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
