From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 5/7] acm: Fix incorrect TID masking
Date: Tue, 14 Mar 2017 10:21:12 -0600
Message-ID: <1489508474-16664-6-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1489508474-16664-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1489508474-16664-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The kernel uses the upper 32 bits of the TID for the agent ID
(see drivers/infiniband/core/user_mad.c ib_umad_write)

This worked on x86 because the TID is in BE at this point and the upper
32 bit masking is correct when working with BE data.

Noticed by sparse.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 ibacm/src/acm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/ibacm/src/acm.c b/ibacm/src/acm.c
index f3512dac106815..cf107815221b14 100644
--- a/ibacm/src/acm.c
+++ b/ibacm/src/acm.c
@@ -2770,8 +2770,8 @@ static void acmc_recv_mad(struct acmc_port *port)
 	found = 0;
 	pthread_mutex_lock(&port->lock);
 	list_for_each(&port->sa_pending, req, entry) {
-		/* The lower 32-bit of the tid is used for agentid in umad */
-		if (req->mad.sa_mad.mad_hdr.tid == (hdr->tid & 0xFFFFFFFF00000000ULL)) {
+		/* The upper 32-bit of the tid is used for agentid in umad */
+		if (req->mad.sa_mad.mad_hdr.tid == (hdr->tid & htobe64(0xFFFFFFFF))) {
 			found = 1;
 			list_del(&req->entry);
 			port->sa_credits++;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
