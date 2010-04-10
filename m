From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] libibnetdisc: restore hops limited discovery
Date: Sat, 10 Apr 2010 03:57:11 +0300
Message-ID: <20100410005711.GK4808@me>
References: <20100218124931.4d6ef34b.weiny2@llnl.gov>
 <20100410005245.GH4808@me>
 <20100410005536.GI4808@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100410005536.GI4808@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Restore hops limited discovery.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 infiniband-diags/libibnetdisc/src/ibnetdisc.c |   12 ++++++------
 infiniband-diags/libibnetdisc/src/internal.h  |    1 +
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/infiniband-diags/libibnetdisc/src/ibnetdisc.c b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
index b438d4f..4012eff 100644
--- a/infiniband-diags/libibnetdisc/src/ibnetdisc.c
+++ b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
@@ -96,6 +96,9 @@ static int extend_dpath(smp_engine_t * engine, ib_portid_t * portid,
 	ibnd_scan_t *scan = engine->user_data;
 	ibnd_fabric_t *fabric = scan->fabric;
 
+	if (scan->max_hops && fabric->maxhops_discovered >= scan->max_hops)
+		return 0;
+
 	if (portid->lid) {
 		/* If we were LID routed we need to set up the drslid */
 		if (!scan->selfportid.lid)
@@ -198,7 +201,7 @@ static int recv_port_info(smp_engine_t * engine, ibnd_smp_t * smp,
 	    == IB_PORT_PHYS_STATE_LINKUP
 	    && (node->type == IB_NODE_SWITCH || node == fabric->from_node)) {
 		ib_portid_t path = smp->path;
-		if (extend_dpath(engine, &path, port_num) != -1)
+		if (extend_dpath(engine, &path, port_num) > 0)
 			query_node_info(engine, &path, node);
 	}
 
@@ -471,17 +474,12 @@ ibnd_fabric_t *ibnd_discover_fabric(struct ibmad_port * ibmad_port,
 {
 	ibnd_fabric_t *fabric = NULL;
 	ib_portid_t my_portid = { 0 };
-	int max_hops = MAXHOPS - 1;	/* default find everything */
 	smp_engine_t engine;
 	ibnd_scan_t scan;
 
 	if (_check_ibmad_port(ibmad_port) < 0)
 		return NULL;
 
-	/* if not everything how much? */
-	if (hops >= 0)
-		max_hops = hops;
-
 	/* If not specified start from "my" port */
 	if (!from)
 		from = &my_portid;
@@ -496,6 +494,8 @@ ibnd_fabric_t *ibnd_discover_fabric(struct ibmad_port * ibmad_port,
 
 	memset(&scan.selfportid, 0, sizeof(scan.selfportid));
 	scan.fabric = fabric;
+	if (hops >= 0)
+		scan.max_hops = hops;
 
 	smp_engine_init(&engine, ibmad_port, &scan, max_smps_on_wire);
 
diff --git a/infiniband-diags/libibnetdisc/src/internal.h b/infiniband-diags/libibnetdisc/src/internal.h
index 179eac6..05e254d 100644
--- a/infiniband-diags/libibnetdisc/src/internal.h
+++ b/infiniband-diags/libibnetdisc/src/internal.h
@@ -58,6 +58,7 @@
 typedef struct ibnd_scan {
 	ib_portid_t selfportid;
 	ibnd_fabric_t *fabric;
+	unsigned max_hops;
 } ibnd_scan_t;
 
 typedef struct ibnd_smp ibnd_smp_t;
-- 
1.7.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
