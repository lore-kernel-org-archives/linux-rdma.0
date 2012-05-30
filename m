From: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH V3 4/8] infiniband-diags: Allow specification of an mkey to use on the command line
Date: Wed, 30 May 2012 10:21:33 -0700
Message-ID: <1338398497-12444-4-git-send-email-foraker1@llnl.gov>
References: <1338398414.11948.29.camel@auk75.llnl.gov>
 <1338398497-12444-1-git-send-email-foraker1@llnl.gov>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1338398497-12444-1-git-send-email-foraker1-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: weiny2-i2BcT+NCU+M@public.gmane.org, Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
---
 doc/rst/common/opt_m.rst                    |    6 ++++++
 doc/rst/ibaddr.8.in.rst                     |    1 +
 doc/rst/ibccconfig.8.in.rst                 |    1 +
 doc/rst/ibccquery.8.in.rst                  |    1 +
 doc/rst/iblinkinfo.8.in.rst                 |    1 +
 doc/rst/ibnetdiscover.8.in.rst              |    1 +
 doc/rst/ibportstate.8.in.rst                |    1 +
 doc/rst/ibqueryerrors.8.in.rst              |    1 +
 doc/rst/ibroute.8.in.rst                    |    1 +
 doc/rst/ibtracert.8.in.rst                  |    6 ++++++
 doc/rst/perfquery.8.in.rst                  |    1 +
 doc/rst/sminfo.8.in.rst                     |    1 +
 doc/rst/smpquery.8.in.rst                   |    1 +
 include/ibdiag_common.h                     |    1 +
 libibnetdisc/include/infiniband/ibnetdisc.h |    3 ++-
 libibnetdisc/src/ibnetdisc.c                |    1 +
 src/ibaddr.c                                |    2 ++
 src/ibcacheedit.c                           |    2 +-
 src/ibccconfig.c                            |    2 ++
 src/ibccquery.c                             |    2 ++
 src/ibdiag_common.c                         |   13 +++++++++++++
 src/iblinkinfo.c                            |    3 +++
 src/ibnetdiscover.c                         |    2 +-
 src/ibping.c                                |    2 +-
 src/ibportstate.c                           |    2 ++
 src/ibqueryerrors.c                         |    3 +++
 src/ibroute.c                               |    2 ++
 src/ibsendtrap.c                            |    2 ++
 src/ibstat.c                                |    2 +-
 src/ibsysstat.c                             |    2 +-
 src/ibtracert.c                             |    4 +++-
 src/perfquery.c                             |    2 ++
 src/saquery.c                               |    2 +-
 src/sminfo.c                                |    2 ++
 src/smpquery.c                              |    2 ++
 src/vendstat.c                              |    2 +-
 36 files changed, 74 insertions(+), 9 deletions(-)
 create mode 100644 doc/rst/common/opt_m.rst

diff --git a/doc/rst/common/opt_m.rst b/doc/rst/common/opt_m.rst
new file mode 100644
index 0000000..13082e8
--- /dev/null
+++ b/doc/rst/common/opt_m.rst
@@ -0,0 +1,6 @@
+.. Define the common option -m
+
+**-m, --m_key <key>**
+        use the specified M_key for requests. If non-numeric value (like 'x')
+        is specified then a value will be prompted for.
+
diff --git a/doc/rst/ibaddr.8.in.rst b/doc/rst/ibaddr.8.in.rst
index 93de897..a1fc42b 100644
--- a/doc/rst/ibaddr.8.in.rst
+++ b/doc/rst/ibaddr.8.in.rst
@@ -68,6 +68,7 @@ Port Selection flags
 Configuration flags
 -------------------
 
+.. include:: common/opt_m.rst
 .. include:: common/opt_z-config.rst
 
 FILES
diff --git a/doc/rst/ibccconfig.8.in.rst b/doc/rst/ibccconfig.8.in.rst
index 3ab31b6..44d8c72 100644
--- a/doc/rst/ibccconfig.8.in.rst
+++ b/doc/rst/ibccconfig.8.in.rst
@@ -67,6 +67,7 @@ Port Selection flags
 Configuration flags
 -------------------
 
+.. include:: common/opt_m.rst
 .. include:: common/opt_z-config.rst
 
 
diff --git a/doc/rst/ibccquery.8.in.rst b/doc/rst/ibccquery.8.in.rst
index 89b741c..183f2e3 100644
--- a/doc/rst/ibccquery.8.in.rst
+++ b/doc/rst/ibccquery.8.in.rst
@@ -66,6 +66,7 @@ Port Selection flags
 Configuration flags
 -------------------
 
+.. include:: common/opt_m.rst
 .. include:: common/opt_z-config.rst
 
 FILES
diff --git a/doc/rst/iblinkinfo.8.in.rst b/doc/rst/iblinkinfo.8.in.rst
index 1496bfc..de23de2 100644
--- a/doc/rst/iblinkinfo.8.in.rst
+++ b/doc/rst/iblinkinfo.8.in.rst
@@ -99,6 +99,7 @@ Configuration flags
 .. include:: common/opt_o-outstanding_smps.rst
 .. include:: common/opt_node_name_map.rst
 .. include:: common/opt_t.rst
+.. include:: common/opt_m.rst
 
 Debugging flags
 ---------------
diff --git a/doc/rst/ibnetdiscover.8.in.rst b/doc/rst/ibnetdiscover.8.in.rst
index fb7c4c9..c858200 100644
--- a/doc/rst/ibnetdiscover.8.in.rst
+++ b/doc/rst/ibnetdiscover.8.in.rst
@@ -83,6 +83,7 @@ Configuration flags
 .. include:: common/opt_o-outstanding_smps.rst
 .. include:: common/opt_node_name_map.rst
 .. include:: common/opt_t.rst
+.. include:: common/opt_m.rst
 
 Debugging flags
 ---------------
diff --git a/doc/rst/ibportstate.8.in.rst b/doc/rst/ibportstate.8.in.rst
index 1fc9bb2..fca3f7a 100644
--- a/doc/rst/ibportstate.8.in.rst
+++ b/doc/rst/ibportstate.8.in.rst
@@ -82,6 +82,7 @@ Configuration flags
 
 .. include:: common/opt_z-config.rst
 .. include:: common/opt_t.rst
+.. include:: common/opt_m.rst
 
 Debugging flags
 ---------------
diff --git a/doc/rst/ibqueryerrors.8.in.rst b/doc/rst/ibqueryerrors.8.in.rst
index 15d488d..d0e9bc9 100644
--- a/doc/rst/ibqueryerrors.8.in.rst
+++ b/doc/rst/ibqueryerrors.8.in.rst
@@ -102,6 +102,7 @@ Configuration flags
 .. include:: common/opt_o-outstanding_smps.rst
 .. include:: common/opt_node_name_map.rst
 .. include:: common/opt_t.rst
+.. include:: common/opt_m.rst
 
 Debugging flags
 ---------------
diff --git a/doc/rst/ibroute.8.in.rst b/doc/rst/ibroute.8.in.rst
index 0070dd6..1cde5ea 100644
--- a/doc/rst/ibroute.8.in.rst
+++ b/doc/rst/ibroute.8.in.rst
@@ -66,6 +66,7 @@ Debugging flags
 Configuration flags
 -------------------
 
+.. include:: common/opt_m.rst
 .. include:: common/opt_t.rst
 .. include:: common/opt_z-config.rst
 
diff --git a/doc/rst/ibtracert.8.in.rst b/doc/rst/ibtracert.8.in.rst
index b002fa8..fecdcdd 100644
--- a/doc/rst/ibtracert.8.in.rst
+++ b/doc/rst/ibtracert.8.in.rst
@@ -65,6 +65,12 @@ Debugging flags
 Configuration flags
 -------------------
 
+
+**--m_key <key>**
+        use the specified M_key for requests. If non-numeric value (like 'x')
+        is specified then a value will be prompted for. Note that unlike other
+        utilities, the '-m' short option is unavailable in ibtracert.
+
 .. include:: common/opt_t.rst
 .. include:: common/opt_node_name_map.rst
 .. include:: common/opt_z-config.rst
diff --git a/doc/rst/perfquery.8.in.rst b/doc/rst/perfquery.8.in.rst
index f5d0e61..caf197c 100644
--- a/doc/rst/perfquery.8.in.rst
+++ b/doc/rst/perfquery.8.in.rst
@@ -144,6 +144,7 @@ Debugging flags
 Configuration flags
 -------------------
 
+.. include:: common/opt_m.rst
 .. include:: common/opt_t.rst
 .. include:: common/opt_z-config.rst
 
diff --git a/doc/rst/sminfo.8.in.rst b/doc/rst/sminfo.8.in.rst
index 1d7e69f..e4ba39a 100644
--- a/doc/rst/sminfo.8.in.rst
+++ b/doc/rst/sminfo.8.in.rst
@@ -70,6 +70,7 @@ Debugging flags
 Configuration flags
 -------------------
 
+.. include:: common/opt_m.rst
 .. include:: common/opt_t.rst
 .. include:: common/opt_z-config.rst
 
diff --git a/doc/rst/smpquery.8.in.rst b/doc/rst/smpquery.8.in.rst
index b422731..4182b32 100644
--- a/doc/rst/smpquery.8.in.rst
+++ b/doc/rst/smpquery.8.in.rst
@@ -79,6 +79,7 @@ Debugging flags
 Configuration flags
 -------------------
 
+.. include:: common/opt_m.rst
 .. include:: common/opt_t.rst
 .. include:: common/opt_node_name_map.rst
 .. include:: common/opt_z-config.rst
diff --git a/include/ibdiag_common.h b/include/ibdiag_common.h
index e989088..0120203 100644
--- a/include/ibdiag_common.h
+++ b/include/ibdiag_common.h
@@ -51,6 +51,7 @@ extern enum MAD_DEST ibd_dest_type;
 extern ib_portid_t *ibd_sm_id;
 extern int ibd_timeout;
 extern uint32_t ibd_ibnetdisc_flags;
+extern uint64_t ibd_mkey;
 extern int show_keys;
 
 /*========================================================*/
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
 
diff --git a/src/ibaddr.c b/src/ibaddr.c
index 0735837..9d208f5 100644
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
diff --git a/src/ibcacheedit.c b/src/ibcacheedit.c
index 2f9a634..5a656c9 100644
--- a/src/ibcacheedit.c
+++ b/src/ibcacheedit.c
@@ -269,7 +269,7 @@ int main(int argc, char **argv)
 	};
 	char *usage_args = "<orig.cache> <new.cache>";
 
-	ibdiag_process_opts(argc, argv, NULL, "CDdeGKLPstv",
+	ibdiag_process_opts(argc, argv, NULL, "CDdeGKLmPstv",
 			    opts, process_opt, usage_args,
 			    NULL);
 
diff --git a/src/ibccconfig.c b/src/ibccconfig.c
index d796ed8..207c821 100644
--- a/src/ibccconfig.c
+++ b/src/ibccconfig.c
@@ -631,6 +631,8 @@ int main(int argc, char **argv)
 	if (!srcport)
 		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
 
+	smp_mkey_set(srcport, ibd_mkey);
+
 	if (resolve_portid_str(ibd_ca, ibd_ca_port, &portid, argv[1],
 			       ibd_dest_type, ibd_sm_id, srcport) < 0)
 		IBERROR("can't resolve destination %s", argv[1]);
diff --git a/src/ibccquery.c b/src/ibccquery.c
index 34a9afd..f9d7b2f 100644
--- a/src/ibccquery.c
+++ b/src/ibccquery.c
@@ -415,6 +415,8 @@ int main(int argc, char **argv)
 	if (!srcport)
 		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
 
+	smp_mkey_set(srcport, ibd_mkey);
+
 	if (resolve_portid_str(ibd_ca, ibd_ca_port, &portid, argv[1],
 			       ibd_dest_type, ibd_sm_id, srcport) < 0)
 		IBERROR("can't resolve destination %s", argv[1]);
diff --git a/src/ibdiag_common.c b/src/ibdiag_common.c
index 2662b9b..069f6e5 100644
--- a/src/ibdiag_common.c
+++ b/src/ibdiag_common.c
@@ -71,6 +71,7 @@ char *ibd_ca = NULL;
 int ibd_ca_port = 0;
 int ibd_timeout = 0;
 uint32_t ibd_ibnetdisc_flags = IBND_CONFIG_MLX_EPI;
+uint64_t ibd_mkey;
 int show_keys = 0;
 
 static const char *prog_name;
@@ -265,6 +266,17 @@ static int process_opt(int ch, char *optarg)
 	case 'K':
 		show_keys = 1;
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
@@ -282,6 +294,7 @@ static const struct ibdiag_opt common_opts[] = {
 	{"timeout", 't', 1, "<ms>", "timeout in ms"},
 	{"sm_port", 's', 1, "<lid>", "SM port lid"},
 	{"show_keys", 'K', 0, NULL, "display security keys in output"},
+	{"m_key", 'm', 1, "<key>", "M_Key to use in request"},
 	{"errors", 'e', 0, NULL, "show send and receive errors"},
 	{"verbose", 'v', 0, NULL, "increase verbosity level"},
 	{"debug", 'd', 0, NULL, "raise debug level"},
diff --git a/src/iblinkinfo.c b/src/iblinkinfo.c
index e4a8d65..2a55cf5 100644
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
 
diff --git a/src/ibnetdiscover.c b/src/ibnetdiscover.c
index 6ed0801..eca88a4 100644
--- a/src/ibnetdiscover.c
+++ b/src/ibnetdiscover.c
@@ -1074,7 +1074,7 @@ int main(int argc, char **argv)
 	};
 	char usage_args[] = "[topology-file]";
 
-	ibdiag_process_opts(argc, argv, &config, "DGKLs", opts, process_opt,
+	ibdiag_process_opts(argc, argv, &config, "DGKLms", opts, process_opt,
 			    usage_args, NULL);
 
 	f = stdout;
diff --git a/src/ibping.c b/src/ibping.c
index 6d3246c..0243dd1 100644
--- a/src/ibping.c
+++ b/src/ibping.c
@@ -202,7 +202,7 @@ int main(int argc, char **argv)
 	};
 	char usage_args[] = "<dest lid|guid>";
 
-	ibdiag_process_opts(argc, argv, NULL, "DK", opts, process_opt,
+	ibdiag_process_opts(argc, argv, NULL, "DKm", opts, process_opt,
 			    usage_args, NULL);
 
 	argc -= optind;
diff --git a/src/ibportstate.c b/src/ibportstate.c
index b2df212..02cf333 100644
--- a/src/ibportstate.c
+++ b/src/ibportstate.c
@@ -394,6 +394,8 @@ int main(int argc, char **argv)
 	if (!srcport)
 		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
 
+	smp_mkey_set(srcport, ibd_mkey);
+
 	if (resolve_portid_str(ibd_ca, ibd_ca_port, &portid, argv[0],
 			       ibd_dest_type, ibd_sm_id, srcport) < 0)
 		IBERROR("can't resolve destination port %s", argv[0]);
diff --git a/src/ibqueryerrors.c b/src/ibqueryerrors.c
index c4ffcf1..076327c 100644
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
index 63baf04..06549f5 100644
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
index 98bacf1..39b75c2 100644
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
diff --git a/src/ibstat.c b/src/ibstat.c
index 12d3c20..87fd9dd 100644
--- a/src/ibstat.c
+++ b/src/ibstat.c
@@ -292,7 +292,7 @@ int main(int argc, char *argv[])
 		NULL
 	};
 
-	ibdiag_process_opts(argc, argv, NULL, "CDeGKLPst", opts, process_opt,
+	ibdiag_process_opts(argc, argv, NULL, "CDeGKLmPst", opts, process_opt,
 			    usage_args, usage_examples);
 
 	argc -= optind;
diff --git a/src/ibsysstat.c b/src/ibsysstat.c
index bac4bb1..ac967c4 100644
--- a/src/ibsysstat.c
+++ b/src/ibsysstat.c
@@ -326,7 +326,7 @@ int main(int argc, char **argv)
 	};
 	char usage_args[] = "<dest lid|guid> [<op>]";
 
-	ibdiag_process_opts(argc, argv, NULL, "DK", opts, process_opt,
+	ibdiag_process_opts(argc, argv, NULL, "DKm", opts, process_opt,
 			    usage_args, NULL);
 
 	argc -= optind;
diff --git a/src/ibtracert.c b/src/ibtracert.c
index 575d9d0..6932f34 100644
--- a/src/ibtracert.c
+++ b/src/ibtracert.c
@@ -757,7 +757,7 @@ int main(int argc, char **argv)
 		NULL,
 	};
 
-	ibdiag_process_opts(argc, argv, NULL, "DK", opts, process_opt,
+	ibdiag_process_opts(argc, argv, NULL, "DKm", opts, process_opt,
 			    usage_args, usage_examples);
 
 	f = stdout;
@@ -774,6 +774,8 @@ int main(int argc, char **argv)
 	if (!srcport)
 		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
 
+	smp_mkey_set(srcport, ibd_mkey);
+
 	node_name_map = open_node_name_map(node_name_map_file);
 
 	if (resolve_portid_str(ibd_ca, ibd_ca_port, &src_portid, argv[0],
diff --git a/src/perfquery.c b/src/perfquery.c
index 9ca2e15..e85b14e 100644
--- a/src/perfquery.c
+++ b/src/perfquery.c
@@ -727,6 +727,8 @@ int main(int argc, char **argv)
 	if (!srcport)
 		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
 
+	smp_mkey_set(srcport, ibd_mkey);
+
 	if (argc) {
 		if (resolve_portid_str(ibd_ca, ibd_ca_port, &portid, argv[0],
 				       ibd_dest_type, ibd_sm_id, srcport) < 0)
diff --git a/src/saquery.c b/src/saquery.c
index 90feb2d..dec990a 100644
--- a/src/saquery.c
+++ b/src/saquery.c
@@ -1636,7 +1636,7 @@ int main(int argc, char **argv)
 	q = NULL;
 	ibd_timeout = DEFAULT_SA_TIMEOUT_MS;
 
-	ibdiag_process_opts(argc, argv, &params, "DGLs", opts, process_opt,
+	ibdiag_process_opts(argc, argv, &params, "DGLms", opts, process_opt,
 			    usage_args, NULL);
 
 	argc -= optind;
diff --git a/src/sminfo.c b/src/sminfo.c
index 1c12204..2471a08 100644
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
index 2909dc5..7b7036b 100644
--- a/src/smpquery.c
+++ b/src/smpquery.c
@@ -478,6 +478,8 @@ int main(int argc, char **argv)
 	if (!srcport)
 		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
 
+	smp_mkey_set(srcport, ibd_mkey);
+
 	node_name_map = open_node_name_map(node_name_map_file);
 
 	if (ibd_dest_type != IB_DEST_DRSLID) {
diff --git a/src/vendstat.c b/src/vendstat.c
index dd89da7..4750cdd 100644
--- a/src/vendstat.c
+++ b/src/vendstat.c
@@ -332,7 +332,7 @@ int main(int argc, char **argv)
 		NULL
 	};
 
-	ibdiag_process_opts(argc, argv, NULL, "DK", opts, process_opt,
+	ibdiag_process_opts(argc, argv, NULL, "DKm", opts, process_opt,
 			    usage_args, usage_examples);
 
 	argc -= optind;
-- 
1.7.9.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
