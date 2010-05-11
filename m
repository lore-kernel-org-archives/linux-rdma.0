From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] ibnetdisc: Separate calls to umad and mad layer to avoid
 race condition on response MAD's
Date: Tue, 11 May 2010 16:48:12 -0700
Message-ID: <20100511164812.e16e41e6.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Date: Tue, 11 May 2010 15:36:08 -0700
Subject: [PATCH] ibnetdisc: Separate calls to umad and mad layer to avoid race condition on response MAD's

	Specify CA/Port to use which allows parallel scanning to other operations.

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 .../libibnetdisc/include/infiniband/ibnetdisc.h    |   15 ++--
 infiniband-diags/libibnetdisc/src/ibnetdisc.c      |   52 +++++++-----
 infiniband-diags/libibnetdisc/src/internal.h       |   11 ++-
 infiniband-diags/libibnetdisc/src/query_smp.c      |   83 ++++++++++++++++----
 infiniband-diags/libibnetdisc/test/testleaks.c     |   16 +---
 infiniband-diags/src/iblinkinfo.c                  |    8 +-
 infiniband-diags/src/ibnetdiscover.c               |   14 +---
 infiniband-diags/src/ibqueryerrors.c               |   11 ++-
 8 files changed, 134 insertions(+), 76 deletions(-)

diff --git a/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h b/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h
index 2735224..83d0ba7 100644
--- a/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h
+++ b/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h
@@ -134,7 +134,9 @@ typedef struct ibnd_config {
 	unsigned show_progress;
 	unsigned max_hops;
 	unsigned debug;
-	uint8_t pad[64];
+	unsigned timeout_ms;
+	unsigned retries;
+	uint8_t pad[56];
 } ibnd_config_t;
 
 /** =========================================================================
@@ -166,15 +168,16 @@ typedef struct ibnd_fabric {
  * Initialization (fabric operations)
  */
 
-MAD_EXPORT ibnd_fabric_t *ibnd_discover_fabric(struct ibmad_port *ibmad_port,
+MAD_EXPORT ibnd_fabric_t *ibnd_discover_fabric(char * ca_name,
+					       int ca_port,
 					       ib_portid_t * from,
 					       struct ibnd_config *config);
 	/**
-	 * open: (required) ibmad_port object from libibmad
+	 * ca_name: (optional) name of the CA to use
+	 * ca_port: (optional) CA port to use
 	 * from: (optional) specify the node to start scanning from.
-	 *       If NULL start from the node we are running on.
-	 * hops: (optional) Specify how much of the fabric to traverse.
-	 *       negative value == scan entire fabric
+	 *       If NULL start from the CA/CA port specified
+	 * config: (optional) additional config options for the scan
 	 */
 MAD_EXPORT void ibnd_destroy_fabric(ibnd_fabric_t * fabric);
 
diff --git a/infiniband-diags/libibnetdisc/src/ibnetdisc.c b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
index 98801de..3c374c7 100644
--- a/infiniband-diags/libibnetdisc/src/ibnetdisc.c
+++ b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
@@ -380,21 +380,6 @@ ibnd_node_t *ibnd_find_node_guid(ibnd_fabric_t * fabric, uint64_t guid)
 	return NULL;
 }
 
-static int _check_ibmad_port(struct ibmad_port *ibmad_port)
-{
-	if (!ibmad_port) {
-		IBND_DEBUG("ibmad_port must be specified\n");
-		return -1;
-	}
-	if (mad_rpc_class_agent(ibmad_port, IB_SMI_CLASS) == -1
-	    || mad_rpc_class_agent(ibmad_port, IB_SMI_DIRECT_CLASS) == -1) {
-		IBND_DEBUG("ibmad_port must be opened with "
-			   "IB_SMI_CLASS && IB_SMI_DIRECT_CLASS\n");
-		return -1;
-	}
-	return 0;
-}
-
 ibnd_node_t *ibnd_find_node_dr(ibnd_fabric_t * fabric, char *dr_str)
 {
 	int i = 0;
@@ -462,17 +447,38 @@ void add_to_type_list(ibnd_node_t * node, ibnd_fabric_t * fabric)
 	}
 }
 
-ibnd_fabric_t *ibnd_discover_fabric(struct ibmad_port *ibmad_port,
-				    ib_portid_t * from, struct ibnd_config *cfg)
+static int set_config(struct ibnd_config *config, struct ibnd_config *cfg)
 {
-	struct ibnd_config default_config = { 0 };
+	if (!config)
+		return (-EINVAL);
+
+	if (cfg)
+		memcpy(config, cfg, sizeof(*config));
+
+	if (!config->max_smps)
+		config->max_smps = DEFAULT_MAX_SMP_ON_WIRE;
+	if (!config->timeout_ms)
+		config->timeout_ms = DEFAULT_TIMEOUT;
+	if (!config->retries)
+		config->retries = DEFAULT_RETRIES;
+
+	return (0);
+}
+
+ibnd_fabric_t *ibnd_discover_fabric(char * ca_name, int ca_port,
+				    ib_portid_t * from,
+				    struct ibnd_config *cfg)
+{
+	struct ibnd_config config = { 0 };
 	ibnd_fabric_t *fabric = NULL;
 	ib_portid_t my_portid = { 0 };
 	smp_engine_t engine;
 	ibnd_scan_t scan;
 
-	if (_check_ibmad_port(ibmad_port) < 0)
+	if (set_config(&config, cfg)) {
+		IBND_ERROR("Invalid ibnd_config\n");
 		return NULL;
+	}
 
 	/* If not specified start from "my" port */
 	if (!from)
@@ -488,10 +494,12 @@ ibnd_fabric_t *ibnd_discover_fabric(struct ibmad_port *ibmad_port,
 
 	memset(&scan.selfportid, 0, sizeof(scan.selfportid));
 	scan.fabric = fabric;
-	scan.cfg = cfg ? cfg : &default_config;
+	scan.cfg = &config;
 
-	smp_engine_init(&engine, ibmad_port, &scan, cfg->max_smps ?
-			cfg->max_smps : DEFAULT_MAX_SMP_ON_WIRE);
+	if (smp_engine_init(&engine, ca_name, ca_port, &scan, &config)) {
+		free(fabric);
+		return (NULL);
+	}
 
 	IBND_DEBUG("from %s\n", portid2str(from));
 
diff --git a/infiniband-diags/libibnetdisc/src/internal.h b/infiniband-diags/libibnetdisc/src/internal.h
index 2cfde02..d037a60 100644
--- a/infiniband-diags/libibnetdisc/src/internal.h
+++ b/infiniband-diags/libibnetdisc/src/internal.h
@@ -54,6 +54,8 @@
 #define MAXHOPS         63
 
 #define DEFAULT_MAX_SMP_ON_WIRE 2
+#define DEFAULT_TIMEOUT 1000
+#define DEFAULT_RETRIES 3
 
 typedef struct ibnd_scan {
 	ib_portid_t selfportid;
@@ -76,16 +78,19 @@ struct ibnd_smp {
 
 struct smp_engine {
 	struct ibmad_port *ibmad_port;
+	int umad_fd;
+	int smi_agent;
+	int smi_dir_agent;
 	ibnd_smp_t *smp_queue_head;
 	ibnd_smp_t *smp_queue_tail;
 	void *user_data;
 	cl_qmap_t smps_on_wire;
-	int max_smps_on_wire;
+	struct ibnd_config *cfg;
 	unsigned total_smps;
 };
 
-void smp_engine_init(smp_engine_t * engine, struct ibmad_port *ibmad_port,
-		     void *user_data, int max_smps_on_wire);
+int smp_engine_init(smp_engine_t * engine, char * ca_name, int ca_port,
+		    void *user_data, ibnd_config_t *cfg);
 int issue_smp(smp_engine_t * engine, ib_portid_t * portid,
 	      unsigned attrid, unsigned mod, smp_comp_cb_t cb, void *cb_data);
 int process_mads(smp_engine_t * engine);
diff --git a/infiniband-diags/libibnetdisc/src/query_smp.c b/infiniband-diags/libibnetdisc/src/query_smp.c
index 7234844..4dbfa0d 100644
--- a/infiniband-diags/libibnetdisc/src/query_smp.c
+++ b/infiniband-diags/libibnetdisc/src/query_smp.c
@@ -61,25 +61,32 @@ static ibnd_smp_t *get_smp(smp_engine_t * engine)
 	return rc;
 }
 
-static int send_smp(ibnd_smp_t * smp, struct ibmad_port *srcport)
+static int send_smp(ibnd_smp_t * smp, smp_engine_t * engine)
 {
 	int rc = 0;
 	uint8_t umad[1024];
 	ib_rpc_t *rpc = &smp->rpc;
+	int agent = 0;
 
 	memset(umad, 0, umad_size() + IB_MAD_SIZE);
 
+	if (rpc->mgtclass == IB_SMI_CLASS) {
+		agent = engine->smi_agent;
+	} else if (rpc->mgtclass == IB_SMI_DIRECT_CLASS) {
+		agent = engine->smi_dir_agent;
+	} else {
+		IBND_ERROR("Invalid class for RPC\n");
+		return (-EIO);
+	}
+
 	if ((rc = mad_build_pkt(umad, &smp->rpc, &smp->path, NULL, NULL))
 	    < 0) {
 		IBND_ERROR("mad_build_pkt failed; %d\n", rc);
 		return rc;
 	}
 
-	if ((rc = umad_send(mad_rpc_portid(srcport),
-			    mad_rpc_class_agent(srcport, rpc->mgtclass),
-			    umad, IB_MAD_SIZE,
-			    mad_get_timeout(srcport, rpc->timeout),
-			    mad_get_retries(srcport))) < 0) {
+	if ((rc = umad_send(engine->umad_fd, agent, umad, IB_MAD_SIZE,
+			    engine->cfg->timeout_ms, engine->cfg->retries)) < 0) {
 		IBND_ERROR("send failed; %d\n", rc);
 		return rc;
 	}
@@ -91,12 +98,13 @@ static int process_smp_queue(smp_engine_t * engine)
 {
 	int rc = 0;
 	ibnd_smp_t *smp;
-	while (cl_qmap_count(&engine->smps_on_wire) < engine->max_smps_on_wire) {
+	while (cl_qmap_count(&engine->smps_on_wire)
+	       < engine->cfg->max_smps) {
 		smp = get_smp(engine);
 		if (!smp)
 			return 0;
 
-		if ((rc = send_smp(smp, engine->ibmad_port)) != 0) {
+		if ((rc = send_smp(smp, engine)) != 0) {
 			free(smp);
 			return rc;
 		}
@@ -122,7 +130,7 @@ int issue_smp(smp_engine_t * engine, ib_portid_t * portid,
 	smp->rpc.method = IB_MAD_METHOD_GET;
 	smp->rpc.attr.id = attrid;
 	smp->rpc.attr.mod = mod;
-	smp->rpc.timeout = mad_get_timeout(engine->ibmad_port, 0);
+	smp->rpc.timeout = engine->cfg->timeout_ms;
 	smp->rpc.datasz = IB_SMP_DATA_SIZE;
 	smp->rpc.dataoffs = IB_SMP_DATA_OFFS;
 	smp->rpc.trid = mad_trid();
@@ -153,7 +161,7 @@ static int process_one_recv(smp_engine_t * engine)
 	memset(umad, 0, sizeof(umad));
 
 	/* wait for the next message */
-	if ((rc = umad_recv(mad_rpc_portid(engine->ibmad_port), umad, &length,
+	if ((rc = umad_recv(engine->umad_fd, umad, &length,
 			    0)) < 0) {
 		if (rc == -EWOULDBLOCK)
 			return 0;
@@ -190,14 +198,58 @@ error:
 	return rc;
 }
 
-void smp_engine_init(smp_engine_t * engine, struct ibmad_port *ibmad_port,
-		     void *user_data, int max_smps_on_wire)
+int smp_engine_init(smp_engine_t * engine, char * ca_name, int ca_port,
+		    void *user_data, ibnd_config_t *cfg)
 {
+	int nc = 2;
+	int mc[2] = { IB_SMI_CLASS, IB_SMI_DIRECT_CLASS };
+
 	memset(engine, 0, sizeof(*engine));
-	engine->ibmad_port = ibmad_port;
+
+	engine->ibmad_port = mad_rpc_open_port(ca_name, ca_port, mc, nc);
+	if (!engine->ibmad_port) {
+		IBND_ERROR("can't open MAD port (%s:%d)\n", ca_name, ca_port);
+		return -EIO;
+	}
+	mad_rpc_set_timeout(engine->ibmad_port, cfg->timeout_ms);
+	mad_rpc_set_retries(engine->ibmad_port, cfg->retries);
+
+	if (umad_init() < 0) {
+		IBND_ERROR("umad_init failed\n");
+		mad_rpc_close_port(engine->ibmad_port);
+		return -EIO;
+	}
+
+	engine->umad_fd = umad_open_port(ca_name, ca_port);
+	if (engine->umad_fd < 0) {
+		IBND_ERROR("can't open UMAD port (%s:%d)\n", ca_name, ca_port);
+		mad_rpc_close_port(engine->ibmad_port);
+		return -EIO;
+	}
+
+	if ((engine->smi_agent = umad_register(engine->umad_fd,
+	     IB_SMI_CLASS, 1, 0, 0)) < 0) {
+		IBND_ERROR("Failed to register SMI agent on (%s:%d)\n",
+			   ca_name, ca_port);
+		goto eio_close;
+	}
+
+	if ((engine->smi_dir_agent = umad_register(engine->umad_fd,
+	     IB_SMI_DIRECT_CLASS, 1, 0, 0)) < 0) {
+		IBND_ERROR("Failed to register SMI_DIRECT agent on (%s:%d)\n",
+			   ca_name, ca_port);
+		goto eio_close;
+	}
+
 	engine->user_data = user_data;
 	cl_qmap_init(&engine->smps_on_wire);
-	engine->max_smps_on_wire = max_smps_on_wire;
+	engine->cfg = cfg;
+	return (0);
+
+eio_close:
+	mad_rpc_close_port(engine->ibmad_port);
+	umad_close_port(engine->umad_fd);
+	return (-EIO);
 }
 
 void smp_engine_destroy(smp_engine_t * engine)
@@ -221,6 +273,9 @@ void smp_engine_destroy(smp_engine_t * engine)
 		cl_qmap_remove_item(&engine->smps_on_wire, item);
 		free(item);
 	}
+
+	umad_close_port(engine->umad_fd);
+	mad_rpc_close_port(engine->ibmad_port);
 }
 
 int process_mads(smp_engine_t * engine)
diff --git a/infiniband-diags/libibnetdisc/test/testleaks.c b/infiniband-diags/libibnetdisc/test/testleaks.c
index da2fc0a..9a91f50 100644
--- a/infiniband-diags/libibnetdisc/test/testleaks.c
+++ b/infiniband-diags/libibnetdisc/test/testleaks.c
@@ -54,8 +54,6 @@
 char *argv0 = "iblinkinfotest";
 static FILE *f;
 
-static int timeout_ms = 500;
-
 void usage(void)
 {
 	fprintf(stderr,
@@ -88,9 +86,6 @@ int main(int argc, char **argv)
 	ib_portid_t port_id;
 	int iters = -1;
 
-	struct ibmad_port *ibmad_port;
-	int mgmt_classes[2] = { IB_SMI_CLASS, IB_SMI_DIRECT_CLASS };
-
 	static char const str_opts[] = "S:D:n:C:P:t:shuf:i:";
 	static const struct option long_opts[] = {
 		{"S", 1, 0, 'S'},
@@ -139,7 +134,7 @@ int main(int argc, char **argv)
 			iters = (int)strtol(optarg, NULL, 0);
 			break;
 		case 't':
-			timeout_ms = strtoul(optarg, 0, 0);
+			config.timeout_ms = strtoul(optarg, 0, 0);
 			break;
 		case 'S':
 			guid = (uint64_t) strtoull(optarg, 0, 0);
@@ -152,15 +147,11 @@ int main(int argc, char **argv)
 	argc -= optind;
 	argv += optind;
 
-	ibmad_port = mad_rpc_open_port(ca, ca_port, mgmt_classes, 2);
-
-	mad_rpc_set_timeout(ibmad_port, timeout_ms);
-
 	while (iters == -1 || iters-- > 0) {
 		if (from) {
 			/* only scan part of the fabric */
 			str2drpath(&(port_id.drpath), from, 0, 0);
-			if ((fabric = ibnd_discover_fabric(ibmad_port,
+			if ((fabric = ibnd_discover_fabric(ca, ca_port,
 							   &port_id, &config))
 			    == NULL) {
 				fprintf(stderr, "discover failed\n");
@@ -168,7 +159,7 @@ int main(int argc, char **argv)
 				goto close_port;
 			}
 			guid = 0;
-		} else if ((fabric = ibnd_discover_fabric(ibmad_port, NULL,
+		} else if ((fabric = ibnd_discover_fabric(ca, ca_port, NULL,
 							  &config)) == NULL) {
 			fprintf(stderr, "discover failed\n");
 			rc = 1;
@@ -179,6 +170,5 @@ int main(int argc, char **argv)
 	}
 
 close_port:
-	mad_rpc_close_port(ibmad_port);
 	exit(rc);
 }
diff --git a/infiniband-diags/src/iblinkinfo.c b/infiniband-diags/src/iblinkinfo.c
index 029573f..d0c9b13 100644
--- a/infiniband-diags/src/iblinkinfo.c
+++ b/infiniband-diags/src/iblinkinfo.c
@@ -337,8 +337,10 @@ int main(int argc, char **argv)
 		exit(1);
 	}
 
-	if (ibd_timeout)
+	if (ibd_timeout) {
 		mad_rpc_set_timeout(ibmad_port, ibd_timeout);
+		config.timeout_ms = ibd_timeout;
+	}
 
 	node_name_map = open_node_name_map(node_name_map_file);
 
@@ -371,12 +373,12 @@ int main(int argc, char **argv)
 	} else {
 		if (resolved >= 0 &&
 		    !(fabric =
-		      ibnd_discover_fabric(ibmad_port, &port_id, &config)))
+		      ibnd_discover_fabric(ibd_ca, ibd_ca_port, &port_id, &config)))
 			IBWARN("Single node discover failed;"
 			       " attempting full scan\n");
 
 		if (!fabric &&
-		    !(fabric = ibnd_discover_fabric(ibmad_port, NULL, &config))) {
+		    !(fabric = ibnd_discover_fabric(ibd_ca, ibd_ca_port, NULL, &config))) {
 			fprintf(stderr, "discover failed\n");
 			rc = 1;
 			goto close_port;
diff --git a/infiniband-diags/src/ibnetdiscover.c b/infiniband-diags/src/ibnetdiscover.c
index 57f9625..8f08f06 100644
--- a/infiniband-diags/src/ibnetdiscover.c
+++ b/infiniband-diags/src/ibnetdiscover.c
@@ -67,8 +67,6 @@
 #define DIFF_FLAG_DEFAULT (DIFF_FLAG_SWITCH | DIFF_FLAG_CA | DIFF_FLAG_ROUTER \
 			   | DIFF_FLAG_PORT_CONNECTION)
 
-struct ibmad_port *srcport;
-
 static FILE *f;
 
 static char *node_name_map_file = NULL;
@@ -938,9 +936,6 @@ int main(int argc, char **argv)
 	ibnd_fabric_t *fabric = NULL;
 	ibnd_fabric_t *diff_fabric = NULL;
 
-	struct ibmad_port *ibmad_port;
-	int mgmt_classes[2] = { IB_SMI_CLASS, IB_SMI_DIRECT_CLASS };
-
 	const struct ibdiag_opt opts[] = {
 		{"show", 's', 0, NULL, "show more information"},
 		{"list", 'l', 0, NULL, "list of connected nodes"},
@@ -975,12 +970,8 @@ int main(int argc, char **argv)
 	argc -= optind;
 	argv += optind;
 
-	ibmad_port = mad_rpc_open_port(ibd_ca, ibd_ca_port, mgmt_classes, 2);
-	if (!ibmad_port)
-		IBERROR("Failed to open %s port %d", ibd_ca, ibd_ca_port);
-
 	if (ibd_timeout)
-		mad_rpc_set_timeout(ibmad_port, ibd_timeout);
+		config.timeout_ms = ibd_timeout;
 
 	if (argc && !(f = fopen(argv[0], "w")))
 		IBERROR("can't open file %s for writing", argv[0]);
@@ -996,7 +987,7 @@ int main(int argc, char **argv)
 			IBERROR("loading cached fabric failed\n");
 	} else {
 		if ((fabric =
-		     ibnd_discover_fabric(ibmad_port, NULL, &config)) == NULL)
+		     ibnd_discover_fabric(ibd_ca, ibd_ca_port, NULL, &config)) == NULL)
 			IBERROR("discover failed\n");
 	}
 
@@ -1017,6 +1008,5 @@ int main(int argc, char **argv)
 	if (diff_fabric)
 		ibnd_destroy_fabric(diff_fabric);
 	close_node_name_map(node_name_map);
-	mad_rpc_close_port(ibmad_port);
 	exit(0);
 }
diff --git a/infiniband-diags/src/ibqueryerrors.c b/infiniband-diags/src/ibqueryerrors.c
index e896254..f04e47f 100644
--- a/infiniband-diags/src/ibqueryerrors.c
+++ b/infiniband-diags/src/ibqueryerrors.c
@@ -600,8 +600,10 @@ int main(int argc, char **argv)
 	if (!ibmad_port)
 		IBERROR("Failed to open port; %s:%d\n", ibd_ca, ibd_ca_port);
 
-	if (ibd_timeout)
+	if (ibd_timeout) {
 		mad_rpc_set_timeout(ibmad_port, ibd_timeout);
+		config.timeout_ms = ibd_timeout;
+	}
 
 	node_name_map = open_node_name_map(node_name_map_file);
 
@@ -633,11 +635,14 @@ int main(int argc, char **argv)
 		}
 	} else {
 		if (resolved >= 0 &&
-		    !(fabric = ibnd_discover_fabric(ibmad_port, &portid, 0)))
+		    !(fabric = ibnd_discover_fabric(ibd_ca, ibd_ca_port,
+						    &portid, &config)))
 			IBWARN("Single node discover failed;"
 			       " attempting full scan");
 
-		if (!fabric && !(fabric = ibnd_discover_fabric(ibmad_port, NULL,
+		if (!fabric && !(fabric = ibnd_discover_fabric(ibd_ca,
+							       ibd_ca_port,
+							       NULL,
 							       &config))) {
 			fprintf(stderr, "discover failed\n");
 			rc = 1;
-- 
1.5.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
