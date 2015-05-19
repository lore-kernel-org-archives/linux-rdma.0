From: Matthew Finlay <matt-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH][RESEND] IB/cma: Resolve AF_IB UD support
Date: Tue, 19 May 2015 00:11:48 -0700
Message-ID: <1432019508-95824-1-git-send-email-matt@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hari Shankar <Hari.Shankar-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, Matt Finlay <matt-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Resent due to mailer issues

Support for using UD and AF_IB is currently broken.  The IB_CM_SIDR_REQ_RECEIVED
message is not handled properly in cma_save_net_info() and we end up falling
into code that will try and process the request as ipv4/ipv6, which will end
up failing.

The resolution is to add a check for the SIDR_REQ and call cma_save_ib_info()
with a NULL path record.  Change cma_save_ib_info() to copy the src sib info 
from the listen_id when the path record is NULL.

Reported-by: Hari Shankar <Hari.Shankar-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Matt Finlay <matt-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
drivers/infiniband/core/cma.c | 32 +++++++++++++++++++++-----------
1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 06441a4..38ffe09 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -845,18 +845,26 @@ static void cma_save_ib_info(struct rdma_cm_id *id, struct rdma_cm_id *listen_id
 	listen_ib = (struct sockaddr_ib *) &listen_id->route.addr.src_addr;
 	ib = (struct sockaddr_ib *) &id->route.addr.src_addr;
 	ib->sib_family = listen_ib->sib_family;
-	ib->sib_pkey = path->pkey;
-	ib->sib_flowinfo = path->flow_label;
-	memcpy(&ib->sib_addr, &path->sgid, 16);
+	if (path) {
+		ib->sib_pkey = path->pkey;
+		ib->sib_flowinfo = path->flow_label;
+		memcpy(&ib->sib_addr, &path->sgid, 16);
+	} else {
+		ib->sib_pkey = listen_ib->sib_pkey;
+		ib->sib_flowinfo = listen_ib->sib_flowinfo;
+		ib->sib_addr = listen_ib->sib_addr;
+	}
 	ib->sib_sid = listen_ib->sib_sid;
 	ib->sib_sid_mask = cpu_to_be64(0xffffffffffffffffULL);
 	ib->sib_scope_id = listen_ib->sib_scope_id;
 
-	ib = (struct sockaddr_ib *) &id->route.addr.dst_addr;
-	ib->sib_family = listen_ib->sib_family;
-	ib->sib_pkey = path->pkey;
-	ib->sib_flowinfo = path->flow_label;
-	memcpy(&ib->sib_addr, &path->dgid, 16);
+	if (path) {
+		ib = (struct sockaddr_ib *) &id->route.addr.dst_addr;
+		ib->sib_family = listen_ib->sib_family;
+		ib->sib_pkey = path->pkey;
+		ib->sib_flowinfo = path->flow_label;
+		memcpy(&ib->sib_addr, &path->dgid, 16);
+	}
 }
 
 static __be16 ss_get_port(const struct sockaddr_storage *ss)
@@ -905,9 +913,11 @@ static int cma_save_net_info(struct rdma_cm_id *id, struct rdma_cm_id *listen_id
 {
 	struct cma_hdr *hdr;
 
-	if ((listen_id->route.addr.src_addr.ss_family == AF_IB) &&
-	    (ib_event->event == IB_CM_REQ_RECEIVED)) {
-		cma_save_ib_info(id, listen_id, ib_event->param.req_rcvd.primary_path);
+	if (listen_id->route.addr.src_addr.ss_family == AF_IB) {
+		if (ib_event->event == IB_CM_REQ_RECEIVED)
+			cma_save_ib_info(id, listen_id, ib_event->param.req_rcvd.primary_path);
+		else if (ib_event->event == IB_CM_SIDR_REQ_RECEIVED)
+			cma_save_ib_info(id, listen_id, NULL);
 		return 0;
 	}
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
