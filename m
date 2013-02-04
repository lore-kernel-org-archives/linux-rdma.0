From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] infiniband-diags: ibroute: add MAD status to query failure
 message
Date: Sun, 3 Feb 2013 21:33:00 -0800
Message-ID: <20130203213300.a709c5004635e2f821679f64@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 src/ibroute.c |   22 ++++++++++++++++------
 1 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/src/ibroute.c b/src/ibroute.c
index a0c7de8..df48382 100644
--- a/src/ibroute.c
+++ b/src/ibroute.c
@@ -210,15 +210,20 @@ char *dump_multicast_tables(ib_portid_t * portid, unsigned startlid,
 	lastblock = endlid / IB_MLIDS_IN_BLOCK;
 	for (block = startblock; block <= lastblock; block++) {
 		for (j = 0; j < chunks; j++) {
+			int status;
 			mod = (block - IB_MIN_MCAST_LID / IB_MLIDS_IN_BLOCK)
 			    | (j << 28);
 
 			DEBUG("reading block %x chunk %d mod %x", block, j,
 			      mod);
-			if (!smp_query_via
+			if (!smp_query_status_via
 			    (mft + j, portid, IB_ATTR_MULTICASTFORWTBL, mod, 0,
-			     srcport))
-				return "multicast forwarding table get failed";
+			     &status, srcport)) {
+				fprintf(stderr, "SubnGet() failed"
+						"; MAD status 0x%x AM 0x%x\n",
+						status, mod);
+				return NULL;
+			}
 		}
 
 		i = block * IB_MLIDS_IN_BLOCK;
@@ -356,10 +361,15 @@ char *dump_unicast_tables(ib_portid_t * portid, int startlid, int endlid)
 	startblock = startlid / IB_SMP_DATA_SIZE;
 	endblock = ALIGN(endlid, IB_SMP_DATA_SIZE) / IB_SMP_DATA_SIZE;
 	for (block = startblock; block <= endblock; block++) {
+		int status;
 		DEBUG("reading block %d", block);
-		if (!smp_query_via(lft, portid, IB_ATTR_LINEARFORWTBL, block,
-				   0, srcport))
-			return "linear forwarding table get failed";
+		if (!smp_query_status_via(lft, portid, IB_ATTR_LINEARFORWTBL, block,
+				   0, &status, srcport)) {
+			fprintf(stderr, "SubnGet() failed"
+					"; MAD status 0x%x AM 0x%x\n",
+					status, block);
+			return NULL;
+		}
 		i = block * IB_SMP_DATA_SIZE;
 		e = i + IB_SMP_DATA_SIZE;
 		if (i < startlid)
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
