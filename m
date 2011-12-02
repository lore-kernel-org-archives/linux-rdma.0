From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] infiniband-diags: fix printing of extended speeds when port
 is down
Date: Fri, 2 Dec 2011 13:42:04 -0800
Message-ID: <20111202134204.a8365612.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 src/iblinkinfo.c    |   20 ++++++++++----------
 src/ibqueryerrors.c |   18 +++++++++---------
 2 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/src/iblinkinfo.c b/src/iblinkinfo.c
index 00c7bc0..0a652ba 100644
--- a/src/iblinkinfo.c
+++ b/src/iblinkinfo.c
@@ -153,17 +153,17 @@ void print_port(ibnd_node_t * node, ibnd_port_t * port, char *out_prefix)
 	/* C14-24.2.1 states that a down port allows for invalid data to be
 	 * returned for all PortInfo components except PortState and
 	 * PortPhysicalState */
-	if (!espeed) {
-		if (fdr10)
-			sprintf(speed, "10.0 Gbps (FDR10)");
-		else
-			mad_dump_val(IB_PORT_LINK_SPEED_ACTIVE_F, speed,
-				     64, &ispeed);
-	} else
-		mad_dump_val(IB_PORT_LINK_SPEED_EXT_ACTIVE_F, speed,
-			     64, &espeed);
-
 	if (istate != IB_LINK_DOWN) {
+		if (!espeed) {
+			if (fdr10)
+				sprintf(speed, "10.0 Gbps (FDR10)");
+			else
+				mad_dump_val(IB_PORT_LINK_SPEED_ACTIVE_F, speed,
+					     64, &ispeed);
+		} else
+			mad_dump_val(IB_PORT_LINK_SPEED_EXT_ACTIVE_F, speed,
+				     64, &espeed);
+
 		n = snprintf(link_str, 256, "(%3s %18s %6s/%8s)",
 		     mad_dump_val(IB_PORT_LINK_WIDTH_ACTIVE_F, width, 64,
 				  &iwidth),
diff --git a/src/ibqueryerrors.c b/src/ibqueryerrors.c
index e070baf..eded6a8 100644
--- a/src/ibqueryerrors.c
+++ b/src/ibqueryerrors.c
@@ -203,17 +203,17 @@ static void print_port_config(char *node_name, ibnd_node_t * node, int portnum)
 	/* C14-24.2.1 states that a down port allows for invalid data to be
 	 * returned for all PortInfo components except PortState and
 	 * PortPhysicalState */
-	if (!espeed) {
-		if (fdr10)
-			sprintf(speed, "10.0 Gbps (FDR10)");
-		else
-			mad_dump_val(IB_PORT_LINK_SPEED_ACTIVE_F, speed,
-				     64, &ispeed);
-	} else
-		mad_dump_val(IB_PORT_LINK_SPEED_EXT_ACTIVE_F, speed,
+	if (istate != IB_LINK_DOWN) {
+		if (!espeed) {
+			if (fdr10)
+				sprintf(speed, "10.0 Gbps (FDR10)");
+			else
+				mad_dump_val(IB_PORT_LINK_SPEED_ACTIVE_F, speed,
+					     64, &ispeed);
+		} else
+			mad_dump_val(IB_PORT_LINK_SPEED_EXT_ACTIVE_F, speed,
 			     64, &espeed);
 
-	if (istate != IB_LINK_DOWN) {
 		snprintf(link_str, 256, "(%3s %18s %6s/%8s)",
 			 mad_dump_val(IB_PORT_LINK_WIDTH_ACTIVE_F, width, 64, &iwidth),
 			 speed,
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
