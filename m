From: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 2/3 fixed] infiniband-diags: Allow specification of an mkey
	on	the command line
Date: Tue, 06 Mar 2012 14:18:03 -0800
Message-ID: <1331072283.17729.16.camel@auk75.llnl.gov>
References: <1331065551.10889.14.camel@auk75.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1331065551.10889.14.camel-mxTxeWJot8FliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
---
 include/ibdiag_common.h                     |    1 +
 libibnetdisc/include/infiniband/ibnetdisc.h |    3 ++-
 libibnetdisc/src/ibnetdisc.c                |    1 +
 man/ibaddr.8                                |    2 ++
 src/ibaddr.c                                |    2 ++
 src/ibccconfig.c                            |    2 ++
 src/ibccquery.c                             |    2 ++
 src/ibdiag_common.c                         |    5 +++++
 src/iblinkinfo.c                            |    3 +++
 src/ibping.c                                |    2 ++
 src/ibportstate.c                           |    2 ++
 src/ibqueryerrors.c                         |    3 +++
 src/ibroute.c                               |    2 ++
 src/ibsendtrap.c                            |    2 ++
 src/ibsysstat.c                             |    2 ++
 src/ibtracert.c                             |    2 ++
 src/mcm_rereg_test.c                        |    3 +++
 src/perfquery.c                             |    2 ++
 src/sminfo.c                                |    2 ++
 src/smpquery.c                              |    2 ++
 src/vendstat.c                              |    2 ++
 21 files changed, 46 insertions(+), 1 deletions(-)

diff --git a/include/ibdiag_common.h b/include/ibdiag_common.h
index 0131193..e44725d 100644
--- a/include/ibdiag_common.h
+++ b/include/ibdiag_common.h
@@ -50,6 +50,7 @@ extern enum MAD_DEST ibd_dest_type;
 extern ib_portid_t *ibd_sm_id;
 extern int ibd_timeout;
 extern uint32_t ibd_ibnetdisc_flags;
+extern uint64_t ibd_mkey;
 
 /*========================================================*/
 /*                External interface                      */
diff --git a/libibnetdisc/include/infiniband/ibnetdisc.h b/libibnetdisc/include/infiniband/ibnetdisc.h
index 2ae2b06..335ad83 100644
--- a/libibnetdisc/include/infiniband/ibnetdisc.h
+++ b/libibnetdisc/include/infiniband/ibnetdisc.h
@@ -151,7 +151,8 @@ typedef struct ibnd_config {
 	unsigned timeout_ms;
 	unsigned retries;
 	uint32_t flags;
-	uint8_t pad[52];
+	uint64_t mkey;
+	uint8_t pad[44];
 } ibnd_config_t;
 
 /** =========================================================================
diff --git a/libibnetdisc/src/ibnetdisc.c b/libibnetdisc/src/ibnetdisc.c
index 8d38ab7..a0cbe3e 100644
--- a/libibnetdisc/src/ibnetdisc.c
+++ b/libibnetdisc/src/ibnetdisc.c
@@ -711,6 +711,7 @@ ibnd_fabric_t *ibnd_discover_fabric(char * ca_name, int ca_port,
 	}
 	mad_rpc_set_timeout(scan.ibmad_port, cfg->timeout_ms);
 	mad_rpc_set_retries(scan.ibmad_port, cfg->retries);
+	smp_mkey_set(scan.ibmad_port, cfg->mkey);
 
 	IBND_DEBUG("from %s\n", portid2str(from));
 
diff --git a/man/ibaddr.8 b/man/ibaddr.8
index 51f5a1c..86ede0a 100644
--- a/man/ibaddr.8
+++ b/man/ibaddr.8
@@ -73,6 +73,8 @@ using the util_name -h syntax.
 \-P <ca_port>    use the specified ca_port.
 .PP
 \-t <timeout_ms> override the default timeout for the solicited mads.
+.PP
+\-m <M_Key> Use specified M_Key (default 0)
 
 Multiple CA/Multiple Port Support
 
diff --git a/src/ibaddr.c b/src/ibaddr.c
index 397ef77..8a4425a 100644
--- a/src/ibaddr.c
+++ b/src/ibaddr.c
@@ -149,6 +149,8 @@ int main(int argc, char **argv)
 	if (!srcport)
 		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
 
+	smp_mkey_set(srcport, ibd_mkey);
+
 	if (argc) {
 		if (ib_resolve_portid_str_via(&portid, argv[0], ibd_dest_type,
 					      ibd_sm_id, srcport) < 0)
diff --git a/src/ibccconfig.c b/src/ibccconfig.c
index c81b7fa..1530721 100644
--- a/src/ibccconfig.c
+++ b/src/ibccconfig.c
@@ -636,6 +636,8 @@ int main(int argc, char **argv)
 	if (!srcport)
 		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
 
+	smp_mkey_set(srcport, ibd_mkey);
+
 	if (ib_resolve_portid_str_via(&portid, argv[1], ibd_dest_type,
 				      ibd_sm_id, srcport) < 0)
 		IBERROR("can't resolve destination %s", argv[1]);
diff --git a/src/ibccquery.c b/src/ibccquery.c
index cf8b35a..ecbac8e 100644
--- a/src/ibccquery.c
+++ b/src/ibccquery.c
@@ -416,6 +416,8 @@ int main(int argc, char **argv)
 	if (!srcport)
 		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
 
+	smp_mkey_set(srcport, ibd_mkey);
+
 	if (ib_resolve_portid_str_via(&portid, argv[1], ibd_dest_type,
 				      ibd_sm_id, srcport) < 0)
 		IBERROR("can't resolve destination %s", argv[1]);
diff --git a/src/ibdiag_common.c b/src/ibdiag_common.c
index b22ed60..0901231 100644
--- a/src/ibdiag_common.c
+++ b/src/ibdiag_common.c
@@ -70,6 +70,7 @@ char *ibd_ca = NULL;
 int ibd_ca_port = 0;
 int ibd_timeout = 0;
 uint32_t ibd_ibnetdisc_flags = IBND_CONFIG_MLX_EPI;
+uint64_t ibd_mkey;
 
 static const char *prog_name;
 static const char *prog_args;
@@ -261,6 +262,9 @@ static int process_opt(int ch, char *optarg)
 				optarg);
 		ibd_sm_id = &sm_portid;
 		break;
+	case 'm':
+		ibd_mkey = strtoull(optarg, 0, 0);
+		break;
 	default:
 		return -1;
 	}
@@ -277,6 +281,7 @@ static const struct ibdiag_opt common_opts[] = {
 	{"Guid", 'G', 0, NULL, "use GUID address argument"},
 	{"timeout", 't', 1, "<ms>", "timeout in ms"},
 	{"sm_port", 's', 1, "<lid>", "SM port lid"},
+	{"m_key", 'm', 1, "<key>", "M_Key to use in request"},
 	{"errors", 'e', 0, NULL, "show send and receive errors"},
 	{"verbose", 'v', 0, NULL, "increase verbosity level"},
 	{"debug", 'd', 0, NULL, "raise debug level"},
diff --git a/src/iblinkinfo.c b/src/iblinkinfo.c
index 575be0a..54c75d4 100644
--- a/src/iblinkinfo.c
+++ b/src/iblinkinfo.c
@@ -632,12 +632,15 @@ int main(int argc, char **argv)
 		exit(1);
 	}
 
+	smp_mkey_set(ibmad_port, ibd_mkey);
+
 	if (ibd_timeout) {
 		mad_rpc_set_timeout(ibmad_port, ibd_timeout);
 		config.timeout_ms = ibd_timeout;
 	}
 
 	config.flags = ibd_ibnetdisc_flags;
+	config.mkey = ibd_mkey;
 
 	node_name_map = open_node_name_map(node_name_map_file);
 
diff --git a/src/ibping.c b/src/ibping.c
index 16ffb34..c00d4cc 100644
--- a/src/ibping.c
+++ b/src/ibping.c
@@ -216,6 +216,8 @@ int main(int argc, char **argv)
 	if (!srcport)
 		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
 
+	smp_mkey_set(srcport, ibd_mkey);
+
 	if (server) {
 		if (mad_register_server_via(ping_class, 0, 0, oui, srcport) < 0)
 			IBERROR("can't serve class %d on this port",
diff --git a/src/ibportstate.c b/src/ibportstate.c
index b5a1a98..a2ebcd4 100644
--- a/src/ibportstate.c
+++ b/src/ibportstate.c
@@ -400,6 +400,8 @@ int main(int argc, char **argv)
 	if (!srcport)
 		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
 
+	smp_mkey_set(srcport, ibd_mkey);
+
 	if (ib_resolve_portid_str_via(&portid, argv[0], ibd_dest_type,
 				      ibd_sm_id, srcport) < 0)
 		IBERROR("can't resolve destination port %s", argv[0]);
diff --git a/src/ibqueryerrors.c b/src/ibqueryerrors.c
index f877527..631b65c 100644
--- a/src/ibqueryerrors.c
+++ b/src/ibqueryerrors.c
@@ -914,12 +914,15 @@ int main(int argc, char **argv)
 	if (!ibmad_port)
 		IBERROR("Failed to open port; %s:%d\n", ibd_ca, ibd_ca_port);
 
+	smp_mkey_set(ibmad_port, ibd_mkey);
+
 	if (ibd_timeout) {
 		mad_rpc_set_timeout(ibmad_port, ibd_timeout);
 		config.timeout_ms = ibd_timeout;
 	}
 
 	config.flags = ibd_ibnetdisc_flags;
+	config.mkey = ibd_mkey;
 
 	node_name_map = open_node_name_map(node_name_map_file);
 
diff --git a/src/ibroute.c b/src/ibroute.c
index 7339218..6b4c2ae 100644
--- a/src/ibroute.c
+++ b/src/ibroute.c
@@ -432,6 +432,8 @@ int main(int argc, char **argv)
 	if (!srcport)
 		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
 
+	smp_mkey_set(srcport, ibd_mkey);
+
 	if (!argc) {
 		if (ib_resolve_self_via(&portid, 0, 0, srcport) < 0)
 			IBERROR("can't resolve self addr");
diff --git a/src/ibsendtrap.c b/src/ibsendtrap.c
index 618706b..2dddb7d 100644
--- a/src/ibsendtrap.c
+++ b/src/ibsendtrap.c
@@ -209,6 +209,8 @@ int main(int argc, char **argv)
 	if (!srcport)
 		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
 
+	smp_mkey_set(srcport, ibd_mkey);
+
 	rc = process_send_trap(trap_name);
 	mad_rpc_close_port(srcport);
 	return rc;
diff --git a/src/ibsysstat.c b/src/ibsysstat.c
index f007aa3..9f4bfe1 100644
--- a/src/ibsysstat.c
+++ b/src/ibsysstat.c
@@ -342,6 +342,8 @@ int main(int argc, char **argv)
 	if (!srcport)
 		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
 
+	smp_mkey_set(srcport, ibd_mkey);
+
 	if (server) {
 		if (mad_register_server_via(sysstat_class, 1, 0, oui, srcport) <
 		    0)
diff --git a/src/ibtracert.c b/src/ibtracert.c
index c9f511b..8325536 100644
--- a/src/ibtracert.c
+++ b/src/ibtracert.c
@@ -774,6 +774,8 @@ int main(int argc, char **argv)
 	if (!srcport)
 		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
 
+	smp_mkey_set(srcport, ibd_mkey);
+
 	node_name_map = open_node_name_map(node_name_map_file);
 
 	if (ib_resolve_portid_str_via(&src_portid, argv[0], ibd_dest_type,
diff --git a/src/mcm_rereg_test.c b/src/mcm_rereg_test.c
index a764d02..4faa76e 100644
--- a/src/mcm_rereg_test.c
+++ b/src/mcm_rereg_test.c
@@ -451,6 +451,9 @@ int main(int argc, char **argv)
 	if (!srcport)
 		err("Failed to open port");
 
+	// If and when mkey is supported here.
+	//smp_mkey_set(srcport, ibd_mkey);
+
 #if 1
 	ib_resolve_smlid_via(&dport_id, TMO, srcport);
 #else
diff --git a/src/perfquery.c b/src/perfquery.c
index c747d11..373a5ad 100644
--- a/src/perfquery.c
+++ b/src/perfquery.c
@@ -729,6 +729,8 @@ int main(int argc, char **argv)
 	if (!srcport)
 		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
 
+	smp_mkey_set(srcport, ibd_mkey);
+
 	if (argc) {
 		if (ib_resolve_portid_str_via(&portid, argv[0], ibd_dest_type,
 					      ibd_sm_id, srcport) < 0)
diff --git a/src/sminfo.c b/src/sminfo.c
index b02906f..a31fdc8 100644
--- a/src/sminfo.c
+++ b/src/sminfo.c
@@ -122,6 +122,8 @@ int main(int argc, char **argv)
 	if (!srcport)
 		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
 
+	smp_mkey_set(srcport, ibd_mkey);
+
 	if (argc) {
 		if (ib_resolve_portid_str_via(&portid, argv[0], ibd_dest_type,
 					      0, srcport) < 0)
diff --git a/src/smpquery.c b/src/smpquery.c
index cecfa68..9548b17 100644
--- a/src/smpquery.c
+++ b/src/smpquery.c
@@ -480,6 +480,8 @@ int main(int argc, char **argv)
 	if (!srcport)
 		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
 
+	smp_mkey_set(srcport, ibd_mkey);
+
 	node_name_map = open_node_name_map(node_name_map_file);
 
 	if (ibd_dest_type != IB_DEST_DRSLID) {
diff --git a/src/vendstat.c b/src/vendstat.c
index 8dbd1ee..adfb0ee 100644
--- a/src/vendstat.c
+++ b/src/vendstat.c
@@ -326,6 +326,8 @@ int main(int argc, char **argv)
 	if (!srcport)
 		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
 
+	smp_mkey_set(srcport, ibd_mkey);
+
 	if (argc) {
 		if (ib_resolve_portid_str_via(&portid, argv[0], ibd_dest_type,
 					      ibd_sm_id, srcport) < 0)
-- 
1.7.1



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
