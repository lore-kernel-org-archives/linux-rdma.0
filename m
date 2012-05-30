From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/16] librdmacm: Check that send and recv CQs are different
 before destroying
Date: Wed, 30 May 2012 17:21:41 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A24BDB@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

ucma_destroy_cqs() destroys both the send and recv CQs if they
are non-null.  If the two CQs are actually the same one, this
results in a crash when trying to destroy the second CQ.  Check
that the CQs are different before destroying the second CQ.

This fixes a crash when using rsockets, which sets the send and
recv CQs to the same CQ.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/cma.c     |    4 ++--
 src/rsocket.c |    5 +----
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/src/cma.c b/src/cma.c
index c32803d..9cd34cf 100755
--- a/src/cma.c
+++ b/src/cma.c
@@ -1096,10 +1096,10 @@ static void ucma_destroy_cqs(struct rdma_cm_id *id)
 	if (id->recv_cq_channel)
 		ibv_destroy_comp_channel(id->recv_cq_channel);
 
-	if (id->send_cq)
+	if (id->send_cq && (id->send_cq != id->recv_cq))
 		ibv_destroy_cq(id->send_cq);
 
-	if (id->send_cq_channel)
+	if (id->send_cq_channel && (id->send_cq_channel != id->recv_cq_channel))
 		ibv_destroy_comp_channel(id->send_cq_channel);
 }
 
diff --git a/src/rsocket.c b/src/rsocket.c
index de0ec3e..01b7248 100644
--- a/src/rsocket.c
+++ b/src/rsocket.c
@@ -366,11 +366,8 @@ static void rs_free(struct rsocket *rs)
 		rdma_dereg_mr(rs->target_mr);
 
 	if (rs->cm_id) {
-		if (rs->cm_id->qp) {
-			rs->cm_id->send_cq_channel = NULL;
-			rs->cm_id->send_cq = NULL;
+		if (rs->cm_id->qp)
 			rdma_destroy_qp(rs->cm_id);
-		}
 		rdma_destroy_id(rs->cm_id);
 	}
 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
