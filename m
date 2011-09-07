From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/4] [for-3.2] rdma/addr: Do not call neigh_event_send()
 with NULL neighbour
Date: Wed, 7 Sep 2011 23:24:21 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E5A094@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The following code in addr6_resolve can result in calling
neigh_event_send() with a NULL neighbour:

   neigh = dst->neighbour;
   if (!neigh || !(neigh->nud_state & NUD_VALID)) {
       neigh_event_send(dst->neighbour, NULL);
       ret = -ENODATA;
       goto put;
   }

Fix this.  Found by code inspection.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
The fact that I've never seen a crash makes me think that dst->neighbour is
never NULL, but I can't confirm that this is the case.

 drivers/infiniband/core/addr.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index 8e21d45..2a756ed 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -275,7 +275,8 @@ static int addr6_resolve(struct sockaddr_in6 *src_in,
 
 	neigh = dst->neighbour;
 	if (!neigh || !(neigh->nud_state & NUD_VALID)) {
-		neigh_event_send(dst->neighbour, NULL);
+		if (neigh)
+			neigh_event_send(neigh, NULL);
 		ret = -ENODATA;
 		goto put;
 	}


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
