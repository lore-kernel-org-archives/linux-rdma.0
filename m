From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] librdmacm/mckey: add notifications on events
Date: Wed, 11 Nov 2009 18:15:08 +0200 (IST)
Message-ID: <Pine.LNX.4.64.0911111814350.6979@zuben.voltaire.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

add notifications on multicast error and address change events which
can take place while traffic is running.

Signed-off-by: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>

Index: librdmacm/examples/mckey.c
===================================================================
--- librdmacm.orig/examples/mckey.c
+++ librdmacm/examples/mckey.c
@@ -62,6 +62,7 @@ struct cmatest_node {

 struct cmatest {
 	struct rdma_event_channel *channel;
+	pthread_t 		cmathread;
 	struct cmatest_node	*nodes;
 	int			conn_index;
 	int			connects_left;
@@ -319,6 +320,30 @@ static int cma_handler(struct rdma_cm_id
 	return ret;
 }

+static void *cma_thread(void *arg)
+{
+	struct rdma_cm_event *event;
+	int ret;
+
+	while (1) {
+		ret = rdma_get_cm_event(test.channel, &event);
+		if (ret) {
+			perror("rdma_get_cm_event");
+			exit(ret);
+		}
+		switch (event->event) {
+		case RDMA_CM_EVENT_MULTICAST_ERROR:
+		case RDMA_CM_EVENT_ADDR_CHANGE:
+			printf("mckey: event: %s, status: %d\n",
+			       rdma_event_str(event->event), event->status);
+			break;
+		default:
+			break;
+		}
+		rdma_ack_cm_event(event);
+	}
+}
+
 static void destroy_node(struct cmatest_node *node)
 {
 	if (!node->cma_id)
@@ -475,6 +500,7 @@ static int run(void)
 	if (ret)
 		goto out;

+	pthread_create(&test.cmathread, NULL, cma_thread, NULL);
 	/*
 	 * Pause to give SM chance to configure switches.  We don't want to
 	 * handle reliability issue in this simple test program.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
