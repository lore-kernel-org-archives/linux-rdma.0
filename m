From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] ibnetdisc.c: Fix partial scan of the fabric.
Date: Fri, 30 Jul 2010 17:51:42 -0700
Message-ID: <20100730175142.08649dfa.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Date: Fri, 30 Jul 2010 14:26:39 -0700
Subject: [PATCH] ibnetdisc.c: Fix partial scan of the fabric.

   When max_hops was specified it did not result in a correct limited scan of
   the fabric.
   In addition the -S and -D options of iblinkinfo/ibqueryerrors should by
   default only scan 1 hop from the node specified to allow for faster
   processing.

Signed-off-by: Ira Weiny <weiny2-eSE4LqFkL++LYFxP40JT4w@public.gmane.org>
---
 infiniband-diags/libibnetdisc/src/ibnetdisc.c |   17 ++++++++++-------
 infiniband-diags/src/iblinkinfo.c             |   13 ++++++++-----
 infiniband-diags/src/ibqueryerrors.c          |   11 +++++++----
 3 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/infiniband-diags/libibnetdisc/src/ibnetdisc.c b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
index f525d71..83353b1 100644
--- a/infiniband-diags/libibnetdisc/src/ibnetdisc.c
+++ b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
@@ -93,7 +93,7 @@ static int extend_dpath(smp_engine_t * engine, ib_portid_t * portid,
 	ibnd_fabric_t *fabric = scan->fabric;
 
 	if (scan->cfg->max_hops &&
-	    fabric->maxhops_discovered >= scan->cfg->max_hops)
+	    fabric->maxhops_discovered > scan->cfg->max_hops)
 		return 0;
 
 	if (portid->lid) {
@@ -449,7 +449,8 @@ void add_to_type_list(ibnd_node_t * node, ibnd_fabric_t * fabric)
 	}
 }
 
-static int set_config(struct ibnd_config *config, struct ibnd_config *cfg)
+static int set_config(struct ibnd_config *config, struct ibnd_config *cfg,
+		      int initial_hops)
 {
 	if (!config)
 		return (-EINVAL);
@@ -463,6 +464,8 @@ static int set_config(struct ibnd_config *config, struct ibnd_config *cfg)
 		config->timeout_ms = DEFAULT_TIMEOUT;
 	if (!config->retries)
 		config->retries = DEFAULT_RETRIES;
+	if (config->max_hops)
+		config->max_hops += initial_hops;
 
 	return (0);
 }
@@ -479,15 +482,15 @@ ibnd_fabric_t *ibnd_discover_fabric(char * ca_name, int ca_port,
 	int nc = 2;
 	int mc[2] = { IB_SMI_CLASS, IB_SMI_DIRECT_CLASS };
 
-	if (set_config(&config, cfg)) {
-		IBND_ERROR("Invalid ibnd_config\n");
-		return NULL;
-	}
-
 	/* If not specified start from "my" port */
 	if (!from)
 		from = &my_portid;
 
+	if (set_config(&config, cfg, from->drpath.cnt)) {
+		IBND_ERROR("Invalid ibnd_config\n");
+		return NULL;
+	}
+
 	fabric = calloc(1, sizeof(*fabric));
 	if (!fabric) {
 		IBND_ERROR("OOM: failed to calloc ibnd_fabric_t\n");
diff --git a/infiniband-diags/src/iblinkinfo.c b/infiniband-diags/src/iblinkinfo.c
index d0c9b13..b075fd0 100644
--- a/infiniband-diags/src/iblinkinfo.c
+++ b/infiniband-diags/src/iblinkinfo.c
@@ -371,11 +371,14 @@ int main(int argc, char **argv)
 			exit(1);
 		}
 	} else {
-		if (resolved >= 0 &&
-		    !(fabric =
-		      ibnd_discover_fabric(ibd_ca, ibd_ca_port, &port_id, &config)))
-			IBWARN("Single node discover failed;"
-			       " attempting full scan\n");
+		if (resolved >= 0) {
+			if (!config.max_hops)
+				config.max_hops = 1;
+			if (!(fabric =
+			    ibnd_discover_fabric(ibd_ca, ibd_ca_port, &port_id, &config)))
+				IBWARN("Single node discover failed;"
+				       " attempting full scan\n");
+		}
 
 		if (!fabric &&
 		    !(fabric = ibnd_discover_fabric(ibd_ca, ibd_ca_port, NULL, &config))) {
diff --git a/infiniband-diags/src/ibqueryerrors.c b/infiniband-diags/src/ibqueryerrors.c
index e0b1c0b..4317b67 100644
--- a/infiniband-diags/src/ibqueryerrors.c
+++ b/infiniband-diags/src/ibqueryerrors.c
@@ -655,11 +655,14 @@ int main(int argc, char **argv)
 			exit(1);
 		}
 	} else {
-		if (resolved >= 0 &&
-		    !(fabric = ibnd_discover_fabric(ibd_ca, ibd_ca_port,
+		if (resolved >= 0) {
+			if (!config.max_hops)
+				config.max_hops = 1;
+			if (!(fabric = ibnd_discover_fabric(ibd_ca, ibd_ca_port,
 						    &portid, &config)))
-			IBWARN("Single node discover failed;"
-			       " attempting full scan");
+				IBWARN("Single node discover failed;"
+				       " attempting full scan");
+		}
 
 		if (!fabric && !(fabric = ibnd_discover_fabric(ibd_ca,
 							       ibd_ca_port,
-- 
1.5.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
