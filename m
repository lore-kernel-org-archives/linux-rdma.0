From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 7/9] ibacm: Reset endpoint state on error
Date: Sun, 23 Mar 2014 13:18:19 -0700
Message-ID: <1395605901-9080-8-git-send-email-sean.hefty@intel.com>
References: <1395605901-9080-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1395605901-9080-1-git-send-email-sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

An endpoint will be set to the ACM_READY state after
joining its multicast group.  If we later receive a
reregister event or port down followed by port up and
try to join the group again but fail, we will leave the
endpoint state as READY, rather than reset it back to INIT.

To fix, always set the mc_dest state to ACM_INIT on
any failure.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/acm.c |   20 +++++++++++++-------
 1 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index a8a1fb9..eba027d 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -750,21 +750,21 @@ static void acm_process_join_resp(struct acm_ep *ep, struct ib_user_mad *umad)
 	mad = (struct ib_sa_mad *) umad->data;
 	acm_log(1, "response status: 0x%x, mad status: 0x%x\n",
 		umad->status, mad->status);
+	lock_acquire(&ep->lock);
 	if (umad->status) {
 		acm_log(0, "ERROR - send join failed 0x%x\n", umad->status);
-		return;
+		goto err1;
 	}
 	if (mad->status) {
 		acm_log(0, "ERROR - join response status 0x%x\n", mad->status);
-		return;
+		goto err1;
 	}
 
 	mc_rec = (struct ib_mc_member_rec *) mad->data;
-	lock_acquire(&ep->lock);
 	index = acm_mc_index(ep, &mc_rec->mgid);
 	if (index < 0) {
 		acm_log(0, "ERROR - MGID in join response not found\n");
-		goto out;
+		goto err1;
 	}
 
 	dest = &ep->mc_dest[index];
@@ -776,19 +776,25 @@ static void acm_process_join_resp(struct acm_ep *ep, struct ib_user_mad *umad)
 		dest->ah = ibv_create_ah(ep->port->dev->pd, &dest->av);
 		if (!dest->ah) {
 			acm_log(0, "ERROR - unable to create ah\n");
-			goto out;
+			goto err1;
 		}
 		ret = ibv_attach_mcast(ep->qp, &mc_rec->mgid, mc_rec->mlid);
 		if (ret) {
 			acm_log(0, "ERROR - unable to attach QP to multicast group\n");
-			goto out;
+			goto err2;
 		}
 	}
 
 	atomic_set(&dest->refcnt, 1);
 	dest->state = ACM_READY;
 	acm_log(1, "join successful\n");
-out:
+	lock_release(&ep->lock);
+	return;
+err2:
+	ibv_destroy_ah(dest->ah);
+	dest->ah = NULL;
+err1:
+	dest->state = ACM_INIT;
 	lock_release(&ep->lock);
 }
 
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
