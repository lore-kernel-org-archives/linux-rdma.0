From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 13/13] ibacm: mark large integer constant as unsigned long long
Date: Mon, 17 Oct 2016 21:11:22 +0200
Message-ID: <1476731482-26491-14-git-send-email-hch@lst.de>
References: <1476731482-26491-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476731482-26491-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 ibacm/src/acm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ibacm/src/acm.c b/ibacm/src/acm.c
index b7f1dc0..2d0d1d4 100644
--- a/ibacm/src/acm.c
+++ b/ibacm/src/acm.c
@@ -2772,7 +2772,7 @@ static void acmc_recv_mad(struct acmc_port *port)
 	pthread_mutex_lock(&port->lock);
 	list_for_each(&port->sa_pending, req, entry) {
 		/* The lower 32-bit of the tid is used for agentid in umad */
-		if (req->mad.sa_mad.mad_hdr.tid == (hdr->tid & 0xFFFFFFFF00000000)) {
+		if (req->mad.sa_mad.mad_hdr.tid == (hdr->tid & 0xFFFFFFFF00000000ULL)) {
 			found = 1;
 			list_del(&req->entry);
 			port->sa_credits++;
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
