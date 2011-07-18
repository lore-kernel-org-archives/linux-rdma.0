From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] rdma/addr: Avoid referencing NULL neighbour
Date: Mon, 18 Jul 2011 18:29:46 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237302E759@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Reported by Dave Miller:

In drivers/infiniband/core/addr.c:

	neigh = dst->neighbour;
	if (!neigh || !(neigh->nud_state & NUD_VALID)) {
		neigh_event_send(dst->neighbour, NULL);
		ret = -ENODATA;
		goto put;
	}

neigh_event_send() can be passed a NULL pointer, and it will
OOPS when this happens.

Avoid passing in a NULL neighbour pointer to neigh_event_send().
Add checks when resolving both ipv4 and ipv6 addresses.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
I added a check to addr4_resolve() as well, but tried to keep the same overall
logic.  There may be a cleaner way of handling this, but we should at least
avoid an OOPS in neigh_event_send().

 drivers/infiniband/core/addr.c |   29 +++++++++++++++++------------
 1 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index 8e21d45..29e8571 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -214,17 +214,18 @@ static int addr4_resolve(struct sockaddr_in *src_in,
 	}
 
 	neigh = neigh_lookup(&arp_tbl, &rt->rt_gateway, rt->dst.dev);
-	if (!neigh || !(neigh->nud_state & NUD_VALID)) {
+	if (neigh && (neigh->nud_state & NUD_VALID)) {
+		ret = rdma_copy_addr(addr, neigh->dev, neigh->ha);
+	} else if (rt->dst.neighbour) {
 		neigh_event_send(rt->dst.neighbour, NULL);
 		ret = -ENODATA;
-		if (neigh)
-			goto release;
-		goto put;
+	} else {
+		ret = -EHOSTUNREACH;
 	}
 
-	ret = rdma_copy_addr(addr, neigh->dev, neigh->ha);
-release:
-	neigh_release(neigh);
+	if (neigh)
+		neigh_release(neigh);
+
 put:
 	ip_rt_put(rt);
 out:
@@ -274,13 +275,17 @@ static int addr6_resolve(struct sockaddr_in6 *src_in,
 	}
 
 	neigh = dst->neighbour;
-	if (!neigh || !(neigh->nud_state & NUD_VALID)) {
-		neigh_event_send(dst->neighbour, NULL);
-		ret = -ENODATA;
-		goto put;
+	if (neigh) {
+		if (neigh->nud_state & NUD_VALID) {
+			ret = rdma_copy_addr(addr, dst->dev, neigh->ha);
+		} else {
+			neigh_event_send(neigh, NULL);
+			ret = -ENODATA;
+		}
+	} else {
+		ret = -EHOSTUNREACH;
 	}
 
-	ret = rdma_copy_addr(addr, dst->dev, neigh->ha);
 put:
 	dst_release(dst);
 	return ret;


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
