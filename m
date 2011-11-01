From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] infiniband-diags: ibqueryerrors: don't exit on reset error
Date: Mon, 31 Oct 2011 23:24:25 -0700
Message-ID: <20111031232425.9c8bc2ad.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


IBERROR exits the process.  ibqueryerrors should continue despite this error.

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 src/ibqueryerrors.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/src/ibqueryerrors.c b/src/ibqueryerrors.c
index d37d268..e070baf 100644
--- a/src/ibqueryerrors.c
+++ b/src/ibqueryerrors.c
@@ -629,7 +629,7 @@ static void clear_port(ib_portid_t * portid, uint16_t cap_mask,
 	if (mask)
 		if (!performance_reset_via(pc, portid, port, mask, ibd_timeout,
 					   IB_GSI_PORT_COUNTERS, ibmad_port))
-			IBERROR("Failed to reset errors %s port %d", node_name,
+			fprintf(stderr, "Failed to reset errors %s port %d\n", node_name,
 				port);
 
 	if (clear_errors && details) {
@@ -653,8 +653,8 @@ static void clear_port(ib_portid_t * portid, uint16_t cap_mask,
 
 		if (!reset_pc_ext(pc, portid, port, mask, ibd_timeout,
 		    ibmad_port))
-			IBERROR("Failed to reset extended data counters %s, "
-				"%s port %d", node_name, portid2str(portid),
+			fprintf(stderr, "Failed to reset extended data counters %s, "
+				"%s port %d\n", node_name, portid2str(portid),
 				port);
 	}
 }
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
