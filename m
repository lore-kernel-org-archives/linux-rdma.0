From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/3] ibacm: Reduce overhead on multicast groups not used
Date: Fri, 1 Apr 2011 16:55:20 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25DC95015A@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

ACM may join several multicast groups when using the multicast
group protocol.  No data is ever sent on those groups.  They exist
simply to see if a port *could* send data across those groups, for
example, to validate the mtu or rate between two endpoints.  Since
we don't send data on them, there's no need to create an address
handle for them or attach the ACM UD QP to it.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/acm.c |   30 ++++++++++++++++++++----------
 1 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index 15f2631..3df996b 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -724,22 +724,32 @@ static void acm_process_join_resp(struct acm_ep *ep, struct ib_user_mad *umad)
 	mc_rec = (struct ib_mc_member_rec *) mad->data;
 	lock_acquire(&ep->lock);
 	index = acm_mc_index(ep, &mc_rec->mgid);
-	if (index >= 0) {
-		dest = &ep->mc_dest[index];
-		dest->remote_qpn = IB_MC_QPN;
-		dest->mgid = mc_rec->mgid;
-		acm_record_mc_av(ep->port, mc_rec, dest);
+	if (index < 0) {
+		acm_log(0, "ERROR - MGID in join response not found\n");
+		goto out;
+	}
+
+	dest = &ep->mc_dest[index];
+	dest->remote_qpn = IB_MC_QPN;
+	dest->mgid = mc_rec->mgid;
+	acm_record_mc_av(ep->port, mc_rec, dest);
+
+	if (index == 0) {
 		dest->ah = ibv_create_ah(ep->port->dev->pd, &dest->av);
+		if (!dest->ah) {
+			acm_log(0, "ERROR - unable to create ah\n");
+			goto out;
+		}
 		ret = ibv_attach_mcast(ep->qp, &mc_rec->mgid, mc_rec->mlid);
 		if (ret) {
 			acm_log(0, "ERROR - unable to attach QP to multicast group\n");
-		} else {
-			dest->state = ACM_READY;
-			acm_log(1, "join successful\n");
+			goto out;
 		}
-	} else {
-		acm_log(0, "ERROR - MGID in join response not found\n");
 	}
+
+	dest->state = ACM_READY;
+	acm_log(1, "join successful\n");
+out:
 	lock_release(&ep->lock);
 }
 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
