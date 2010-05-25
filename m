From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] libibnetdisc: move ibmad_port out of smp_engine
Date: Tue, 25 May 2010 13:36:16 -0700
Message-ID: <20100525133616.03f2dace.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Date: Tue, 25 May 2010 13:32:18 -0700
Subject: [PATCH] libibnetdisc: move ibmad_port out of smp_engine


Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 infiniband-diags/libibnetdisc/src/ibnetdisc.c |   15 ++++++++++++++-
 infiniband-diags/libibnetdisc/src/internal.h  |    2 +-
 infiniband-diags/libibnetdisc/src/query_smp.c |   15 ---------------
 3 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/infiniband-diags/libibnetdisc/src/ibnetdisc.c b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
index 3c374c7..945e02c 100644
--- a/infiniband-diags/libibnetdisc/src/ibnetdisc.c
+++ b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
@@ -100,7 +100,7 @@ static int extend_dpath(smp_engine_t * engine, ib_portid_t * portid,
 		/* If we were LID routed we need to set up the drslid */
 		if (!scan->selfportid.lid)
 			if (ib_resolve_self_via(&scan->selfportid, NULL, NULL,
-						engine->ibmad_port) < 0) {
+						scan->ibmad_port) < 0) {
 				IBND_ERROR("Failed to resolve self\n");
 				return -1;
 			}
@@ -474,6 +474,8 @@ ibnd_fabric_t *ibnd_discover_fabric(char * ca_name, int ca_port,
 	ib_portid_t my_portid = { 0 };
 	smp_engine_t engine;
 	ibnd_scan_t scan;
+	int nc = 2;
+	int mc[2] = { IB_SMI_CLASS, IB_SMI_DIRECT_CLASS };
 
 	if (set_config(&config, cfg)) {
 		IBND_ERROR("Invalid ibnd_config\n");
@@ -501,6 +503,15 @@ ibnd_fabric_t *ibnd_discover_fabric(char * ca_name, int ca_port,
 		return (NULL);
 	}
 
+	scan.ibmad_port = mad_rpc_open_port(ca_name, ca_port, mc, nc);
+	if (!scan.ibmad_port) {
+		IBND_ERROR("can't open MAD port (%s:%d)\n", ca_name, ca_port);
+		smp_engine_destroy(&engine);
+		return (NULL);
+	}
+	mad_rpc_set_timeout(scan.ibmad_port, cfg->timeout_ms);
+	mad_rpc_set_retries(scan.ibmad_port, cfg->retries);
+
 	IBND_DEBUG("from %s\n", portid2str(from));
 
 	if (!query_node_info(&engine, from, NULL))
@@ -513,9 +524,11 @@ ibnd_fabric_t *ibnd_discover_fabric(char * ca_name, int ca_port,
 		goto error;
 
 	smp_engine_destroy(&engine);
+	mad_rpc_close_port(scan.ibmad_port);
 	return fabric;
 error:
 	smp_engine_destroy(&engine);
+	mad_rpc_close_port(scan.ibmad_port);
 	ibnd_destroy_fabric(fabric);
 	return NULL;
 }
diff --git a/infiniband-diags/libibnetdisc/src/internal.h b/infiniband-diags/libibnetdisc/src/internal.h
index d037a60..3c599ec 100644
--- a/infiniband-diags/libibnetdisc/src/internal.h
+++ b/infiniband-diags/libibnetdisc/src/internal.h
@@ -61,6 +61,7 @@ typedef struct ibnd_scan {
 	ib_portid_t selfportid;
 	ibnd_fabric_t *fabric;
 	struct ibnd_config *cfg;
+	struct ibmad_port *ibmad_port;
 } ibnd_scan_t;
 
 typedef struct ibnd_smp ibnd_smp_t;
@@ -77,7 +78,6 @@ struct ibnd_smp {
 };
 
 struct smp_engine {
-	struct ibmad_port *ibmad_port;
 	int umad_fd;
 	int smi_agent;
 	int smi_dir_agent;
diff --git a/infiniband-diags/libibnetdisc/src/query_smp.c b/infiniband-diags/libibnetdisc/src/query_smp.c
index 4dbfa0d..b68e08a 100644
--- a/infiniband-diags/libibnetdisc/src/query_smp.c
+++ b/infiniband-diags/libibnetdisc/src/query_smp.c
@@ -201,29 +201,16 @@ error:
 int smp_engine_init(smp_engine_t * engine, char * ca_name, int ca_port,
 		    void *user_data, ibnd_config_t *cfg)
 {
-	int nc = 2;
-	int mc[2] = { IB_SMI_CLASS, IB_SMI_DIRECT_CLASS };
-
 	memset(engine, 0, sizeof(*engine));
 
-	engine->ibmad_port = mad_rpc_open_port(ca_name, ca_port, mc, nc);
-	if (!engine->ibmad_port) {
-		IBND_ERROR("can't open MAD port (%s:%d)\n", ca_name, ca_port);
-		return -EIO;
-	}
-	mad_rpc_set_timeout(engine->ibmad_port, cfg->timeout_ms);
-	mad_rpc_set_retries(engine->ibmad_port, cfg->retries);
-
 	if (umad_init() < 0) {
 		IBND_ERROR("umad_init failed\n");
-		mad_rpc_close_port(engine->ibmad_port);
 		return -EIO;
 	}
 
 	engine->umad_fd = umad_open_port(ca_name, ca_port);
 	if (engine->umad_fd < 0) {
 		IBND_ERROR("can't open UMAD port (%s:%d)\n", ca_name, ca_port);
-		mad_rpc_close_port(engine->ibmad_port);
 		return -EIO;
 	}
 
@@ -247,7 +234,6 @@ int smp_engine_init(smp_engine_t * engine, char * ca_name, int ca_port,
 	return (0);
 
 eio_close:
-	mad_rpc_close_port(engine->ibmad_port);
 	umad_close_port(engine->umad_fd);
 	return (-EIO);
 }
@@ -275,7 +261,6 @@ void smp_engine_destroy(smp_engine_t * engine)
 	}
 
 	umad_close_port(engine->umad_fd);
-	mad_rpc_close_port(engine->ibmad_port);
 }
 
 int process_mads(smp_engine_t * engine)
-- 
1.5.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
