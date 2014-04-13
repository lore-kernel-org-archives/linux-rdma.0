From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH] ibacm: Fix invalid memory dereference in acm_process_join_resp
Date: Sun, 13 Apr 2014 14:47:38 -0700
Message-ID: <1397425658-30876-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

If a join request fails, the dest pointer may not be initialized.
This can result in the ibacm daemon crashing.  Fix the crash and
ensure that the multicast state is set correctly in case the
join fails by initializing the state to ACM_INIT before sending
the join request.

Problem reported by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/acm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index 851a258..fcbe313 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -801,7 +801,6 @@ err2:
 	ibv_destroy_ah(dest->ah);
 	dest->ah = NULL;
 err1:
-	dest->state = ACM_INIT;
 	lock_release(&ep->lock);
 }
 
@@ -1568,6 +1567,7 @@ static void acm_join_group(struct acm_ep *ep, union ibv_gid *port_gid,
 	acm_log(0, "%s %d pkey 0x%x, sl 0x%x, rate 0x%x, mtu 0x%x\n",
 		ep->port->dev->verbs->device->name, ep->port->port_num,
 		ep->pkey, sl, rate, mtu);
+	ep->mc_dest[ep->mc_cnt].state = ACM_INIT;
 	mad = (struct ib_sa_mad *) umad->data;
 	acm_init_join(mad, port_gid, ep->pkey, tos, tclass, sl, rate, mtu);
 	mc_rec = (struct ib_mc_member_rec *) mad->data;
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
