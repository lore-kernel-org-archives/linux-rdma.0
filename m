From: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH V2 2/5] infiniband-diags: Allow specification of an mkey to use on the command line
Date: Mon, 23 Apr 2012 17:56:54 -0700
Message-ID: <1335229017-10677-2-git-send-email-foraker1@llnl.gov>
References: <1335228837.17237.302.camel@auk75.llnl.gov>
 <1335229017-10677-1-git-send-email-foraker1@llnl.gov>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1335229017-10677-1-git-send-email-foraker1-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: weiny2-i2BcT+NCU+M@public.gmane.org, Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
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
 src/ibdiag_common.c                         |   13 +++++++++++++
 src/iblinkinfo.c                            |    3 +++
 src/ibportstate.c                           |    2 ++
 src/ibqueryerrors.c                         |    3 +++
 src/ibroute.c                               |    2 ++
 src/ibsendtrap.c                            |    2 ++
 src/ibtracert.c                             |    2 ++
 src/perfquery.c                             |    2 ++
 src/sminfo.c                                |    2 ++
 src/smpquery.c                              |    2 ++
 17 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/include/ibdiag_common.h b/include/ibdiag_common.h
index 09dc319..409abdb 100644
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
index 455d941..dc50046 100644
--- a/src/ibaddr.c
+++ b/src/ibaddr.c
@@ -149,6 +149,8 @@ int main(int argc, char **argv)
 	if (!srcport)
 		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
 
+	smp_mkey_set(srcport, ibd_mkey);
+
 	if (argc) {
 		if (resolve_portid_str(ibd_ca, ibd_ca_port, &portid, argv[0],
 				       ibd_dest_type, ibd_sm_id, srcport) < 0)
diff --git a/src/ibccconfig.c b/src/ibccconfig.c
index 71d408a..e3a10ae 100644
--- a/src/ibccconfig.c
+++ b/src/ibccconfig.c
@@ -636,6 +636,8 @@ int main(int argc, char **argv)
 	if (!srcport)
 		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
 
+	smp_mkey_set(srcport, ibd_mkey);
+
 	if (resolve_portid_str(ibd_ca, ibd_ca_port, &portid, argv[1],
 			       ibd_dest_type, ibd_sm_id, srcport) < 0)
 		IBERROR("can't resolve destination %s", argv[1]);
diff --git a/src/ibccquery.c b/src/ibccquery.c
index 2bf62fa..e7cae5a 100644
--- a/src/ibccquery.c
+++ b/src/ibccquery.c
@@ -416,6 +416,8 @@ int main(int argc, char **argv)
 	if (!srcport)
 		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
 
+	smp_mkey_set(srcport, ibd_mkey);
+
 	if (resolve_portid_str(ibd_ca, ibd_ca_port, &portid, argv[1],
 			       ibd_dest_type, ibd_sm_id, srcport) < 0)
 		IBERROR("can't resolve destination %s", argv[1]);
diff --git a/src/ibdiag_common.c b/src/ibdiag_common.c
index 5752f95..2288ab3 100644
--- a/src/ibdiag_common.c
+++ b/src/ibdiag_common.c
@@ -70,6 +70,7 @@ char *ibd_ca = NULL;
 int ibd_ca_port = 0;
 int ibd_timeout = 0;
 uint32_t ibd_ibnetdisc_flags = IBND_CONFIG_MLX_EPI;
+uint64_t ibd_mkey;
 
 static const char *prog_name;
 static const char *prog_args;
@@ -261,6 +262,17 @@ static int process_opt(int ch, char *optarg)
 				optarg);
 		ibd_sm_id = &sm_portid;
 		break;
+	case 'm':
+		errno = 0;
+		ibd_mkey = strtoull(optarg, &endp, 0);
+		if (errno || *endp != '\0') {
+			errno = 0;
+			ibd_mkey = strtoull(getpass("M_Key: "), &endp, 0);
+			if (errno || *endp != '\0') {
+				IBERROR("Bad M_Key");
+			}
+                }
+                break;
 	default:
 		return -1;
 	}
@@ -277,6 +289,7 @@ static const struct ibdiag_opt common_opts[] = {
 	{"Guid", 'G', 0, NULL, "use GUID address argument"},
 	{"timeout", 't', 1, "<ms>", "timeout in ms"},
 	{"sm_port", 's', 1, "<lid>", "SM port lid"},
+	{"m_key", 'm', 1, "<key>", "M_Key to use in request"},
 	{"errors", 'e', 0, NULL, "show send and receive errors"},
 	{"verbose", 'v', 0, NULL, "increase verbosity level"},
 	{"debug", 'd', 0, NULL, "raise debug level"},
diff --git a/src/iblinkinfo.c b/src/iblinkinfo.c
index 36aa6d1..acaab54 100644
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
 
diff --git a/src/ibportstate.c b/src/ibportstate.c
index 21cd431..c7d89f3 100644
--- a/src/ibportstate.c
+++ b/src/ibportstate.c
@@ -401,6 +401,8 @@ int main(int argc, char **argv)
 	if (!srcport)
 		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
 
+	smp_mkey_set(srcport, ibd_mkey);
+
 	if (resolve_portid_str(ibd_ca, ibd_ca_port, &portid, argv[0],
 			       ibd_dest_type, ibd_sm_id, srcport) < 0)
 		IBERROR("can't resolve destination port %s", argv[0]);
diff --git a/src/ibqueryerrors.c b/src/ibqueryerrors.c
index 4fec240..77c57fc 100644
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
index faff34d..b8dcc54 100644
--- a/src/ibroute.c
+++ b/src/ibroute.c
@@ -432,6 +432,8 @@ int main(int argc, char **argv)
 	if (!srcport)
 		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
 
+	smp_mkey_set(srcport, ibd_mkey);
+
 	if (resolve_portid_str(ibd_ca, ibd_ca_port, &portid, argv[0],
 			       ibd_dest_type, ibd_sm_id, srcport) < 0)
 		IBERROR("can't resolve destination port %s", argv[1]);
diff --git a/src/ibsendtrap.c b/src/ibsendtrap.c
index 2d63e35..b9bf5c0 100644
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
diff --git a/src/ibtracert.c b/src/ibtracert.c
index e8fedf3..32aba19 100644
--- a/src/ibtracert.c
+++ b/src/ibtracert.c
@@ -774,6 +774,8 @@ int main(int argc, char **argv)
 	if (!srcport)
 		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
 
+	smp_mkey_set(srcport, ibd_mkey);
+
 	node_name_map = open_node_name_map(node_name_map_file);
 
 	if (resolve_portid_str(ibd_ca, ibd_ca_port, &src_portid, argv[0],
diff --git a/src/perfquery.c b/src/perfquery.c
index 8835d3d..388d04a 100644
--- a/src/perfquery.c
+++ b/src/perfquery.c
@@ -729,6 +729,8 @@ int main(int argc, char **argv)
 	if (!srcport)
 		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
 
+	smp_mkey_set(srcport, ibd_mkey);
+
 	if (argc) {
 		if (resolve_portid_str(ibd_ca, ibd_ca_port, &portid, argv[0],
 				       ibd_dest_type, ibd_sm_id, srcport) < 0)
diff --git a/src/sminfo.c b/src/sminfo.c
index f1abc6a..0f723d0 100644
--- a/src/sminfo.c
+++ b/src/sminfo.c
@@ -122,6 +122,8 @@ int main(int argc, char **argv)
 	if (!srcport)
 		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
 
+	smp_mkey_set(srcport, ibd_mkey);
+
 	if (argc) {
 		if (resolve_portid_str(ibd_ca, ibd_ca_port, &portid, argv[0],
 				       ibd_dest_type, 0, srcport) < 0)
diff --git a/src/smpquery.c b/src/smpquery.c
index 533b2c3..2ef2086 100644
--- a/src/smpquery.c
+++ b/src/smpquery.c
@@ -480,6 +480,8 @@ int main(int argc, char **argv)
 	if (!srcport)
 		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
 
+	smp_mkey_set(srcport, ibd_mkey);
+
 	node_name_map = open_node_name_map(node_name_map_file);
 
 	if (ibd_dest_type != IB_DEST_DRSLID) {
-- 
1.7.9.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
