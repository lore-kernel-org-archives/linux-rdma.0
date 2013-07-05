From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] infiniband-diags: convert IBERROR to IBEXIT
Date: Fri, 5 Jul 2013 08:40:29 -0700
Message-ID: <20130705084029.5dfb3812370547dbcdfeef3e@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


NOTE: IBERROR has always exited; this simply clarifies the macro and function behavior

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/ibdiag_common.h |    4 +-
 src/dump_fts.c          |    2 +-
 src/ibaddr.c            |    8 +++---
 src/ibcacheedit.c       |   18 ++++++++--------
 src/ibccconfig.c        |    8 +++---
 src/ibccquery.c         |    8 +++---
 src/ibdiag_common.c     |    8 +++---
 src/iblinkinfo.c        |    4 +-
 src/ibnetdiscover.c     |   10 ++++----
 src/ibping.c            |   10 ++++----
 src/ibportstate.c       |   50 +++++++++++++++++++++++-----------------------
 src/ibqueryerrors.c     |    4 +-
 src/ibroute.c           |    6 ++--
 src/ibsendtrap.c        |    6 ++--
 src/ibsysstat.c         |   12 +++++-----
 src/ibtracert.c         |   28 +++++++++++++-------------
 src/perfquery.c         |   34 ++++++++++++++++----------------
 src/saquery.c           |    2 +-
 src/sminfo.c            |   10 ++++----
 src/smpquery.c          |   12 +++++-----
 src/vendstat.c          |   28 +++++++++++++-------------
 21 files changed, 136 insertions(+), 136 deletions(-)

diff --git a/include/ibdiag_common.h b/include/ibdiag_common.h
index b9f59f9..ef3a46b 100644
--- a/include/ibdiag_common.h
+++ b/include/ibdiag_common.h
@@ -66,7 +66,7 @@ extern int show_keys;
 #define VERBOSE(fmt, ...) do { \
 	if (ibverbose) IBVERBOSE(fmt, ## __VA_ARGS__); \
 } while (0)
-#define IBERROR(fmt, ...) iberror(__FUNCTION__, fmt, ## __VA_ARGS__)
+#define IBEXIT(fmt, ...) ibexit(__FUNCTION__, fmt, ## __VA_ARGS__)
 
 #define NOT_DISPLAYED_STR "<not displayed>"
 
@@ -91,7 +91,7 @@ extern int ibdiag_process_opts(int argc, char *const argv[], void *context,
 			       const char *usage_args,
 			       const char *usage_examples[]);
 extern void ibdiag_show_usage();
-extern void iberror(const char *fn, char *msg, ...);
+extern void ibexit(const char *fn, char *msg, ...);
 
 /* convert counter values to a float with a unit specifier returned (using
  * binary prefix)
diff --git a/src/dump_fts.c b/src/dump_fts.c
index 89f0dce..26f44c2 100644
--- a/src/dump_fts.c
+++ b/src/dump_fts.c
@@ -459,7 +459,7 @@ int main(int argc, char **argv)
 
 	srcport = mad_rpc_open_port(ibd_ca, ibd_ca_port, mgmt_classes, 3);
 	if (!srcport)
-		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
+		IBEXIT("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
 
 	node_name_map = open_node_name_map(node_name_map_file);
 
diff --git a/src/ibaddr.c b/src/ibaddr.c
index 9d208f5..5845b4e 100644
--- a/src/ibaddr.c
+++ b/src/ibaddr.c
@@ -147,21 +147,21 @@ int main(int argc, char **argv)
 
 	srcport = mad_rpc_open_port(ibd_ca, ibd_ca_port, mgmt_classes, 3);
 	if (!srcport)
-		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
+		IBEXIT("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
 
 	smp_mkey_set(srcport, ibd_mkey);
 
 	if (argc) {
 		if (resolve_portid_str(ibd_ca, ibd_ca_port, &portid, argv[0],
 				       ibd_dest_type, ibd_sm_id, srcport) < 0)
-			IBERROR("can't resolve destination port %s", argv[0]);
+			IBEXIT("can't resolve destination port %s", argv[0]);
 	} else {
 		if (resolve_self(ibd_ca, ibd_ca_port, &portid, &port, NULL) < 0)
-			IBERROR("can't resolve self port %s", argv[0]);
+			IBEXIT("can't resolve self port %s", argv[0]);
 	}
 
 	if (ib_resolve_addr(&portid, port, show_lid, show_gid) < 0)
-		IBERROR("can't resolve requested address");
+		IBEXIT("can't resolve requested address");
 
 	mad_rpc_close_port(srcport);
 	exit(0);
diff --git a/src/ibcacheedit.c b/src/ibcacheedit.c
index f302813..983c0ab 100644
--- a/src/ibcacheedit.c
+++ b/src/ibcacheedit.c
@@ -280,13 +280,13 @@ int main(int argc, char **argv)
 	new_cache_file = argv[1];
 
 	if (!orig_cache_file)
-		IBERROR("original cache file not specified");
+		IBEXIT("original cache file not specified");
 
 	if (!new_cache_file)
-		IBERROR("new cache file not specified");
+		IBEXIT("new cache file not specified");
 
 	if ((fabric = ibnd_load_fabric(orig_cache_file, 0)) == NULL)
-		IBERROR("loading original cached fabric failed");
+		IBEXIT("loading original cached fabric failed");
 
 	if (switchguid_flag) {
 		guids.before = switchguid_before;
@@ -298,7 +298,7 @@ int main(int argc, char **argv)
 				     &guids);
 
 		if (!guids.found)
-			IBERROR("switchguid = %" PRIx64 " not found",
+			IBEXIT("switchguid = %" PRIx64 " not found",
 				switchguid_before);
 	}
 
@@ -312,7 +312,7 @@ int main(int argc, char **argv)
 				     &guids);
 
 		if (!guids.found)
-			IBERROR("caguid = %" PRIx64 " not found",
+			IBEXIT("caguid = %" PRIx64 " not found",
 				caguid_before);
 	}
 
@@ -325,7 +325,7 @@ int main(int argc, char **argv)
 				&guids);
 
 		if (!guids.found)
-			IBERROR("sysimgguid = %" PRIx64 " not found",
+			IBEXIT("sysimgguid = %" PRIx64 " not found",
 				sysimgguid_before);
 	}
 
@@ -340,16 +340,16 @@ int main(int argc, char **argv)
 				&guids);
 
 		if (!guids.searchguid_found)
-			IBERROR("nodeguid = %" PRIx64 " not found",
+			IBEXIT("nodeguid = %" PRIx64 " not found",
 				portguid_nodeguid);
 
 		if (!guids.found)
-			IBERROR("portguid = %" PRIx64 " not found",
+			IBEXIT("portguid = %" PRIx64 " not found",
 				portguid_before);
 	}
 
 	if (ibnd_cache_fabric(fabric, new_cache_file, 0) < 0)
-		IBERROR("caching new cache data failed");
+		IBEXIT("caching new cache data failed");
 
 	ibnd_destroy_fabric(fabric);
 	exit(0);
diff --git a/src/ibccconfig.c b/src/ibccconfig.c
index 79a0e71..11dfc07 100644
--- a/src/ibccconfig.c
+++ b/src/ibccconfig.c
@@ -605,19 +605,19 @@ int main(int argc, char **argv)
 		ibdiag_show_usage();
 
 	if (!(fn = match_op(match_tbl, argv[0])))
-		IBERROR("operation '%s' not supported", argv[0]);
+		IBEXIT("operation '%s' not supported", argv[0]);
 
 	srcport = mad_rpc_open_port(ibd_ca, ibd_ca_port, mgmt_classes, 3);
 	if (!srcport)
-		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
+		IBEXIT("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
 
 	smp_mkey_set(srcport, ibd_mkey);
 
 	if (resolve_portid_str(ibd_ca, ibd_ca_port, &portid, argv[1],
 			       ibd_dest_type, ibd_sm_id, srcport) < 0)
-		IBERROR("can't resolve destination %s", argv[1]);
+		IBEXIT("can't resolve destination %s", argv[1]);
 	if ((err = fn(&portid, argv + 2, argc - 2)))
-		IBERROR("operation %s: %s", argv[0], err);
+		IBEXIT("operation %s: %s", argv[0], err);
 
 	mad_rpc_close_port(srcport);
 	exit(0);
diff --git a/src/ibccquery.c b/src/ibccquery.c
index 5e0e283..ac8bca2 100644
--- a/src/ibccquery.c
+++ b/src/ibccquery.c
@@ -390,19 +390,19 @@ int main(int argc, char **argv)
 		ibdiag_show_usage();
 
 	if (!(fn = match_op(match_tbl, argv[0])))
-		IBERROR("operation '%s' not supported", argv[0]);
+		IBEXIT("operation '%s' not supported", argv[0]);
 
 	srcport = mad_rpc_open_port(ibd_ca, ibd_ca_port, mgmt_classes, 3);
 	if (!srcport)
-		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
+		IBEXIT("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
 
 	smp_mkey_set(srcport, ibd_mkey);
 
 	if (resolve_portid_str(ibd_ca, ibd_ca_port, &portid, argv[1],
 			       ibd_dest_type, ibd_sm_id, srcport) < 0)
-		IBERROR("can't resolve destination %s", argv[1]);
+		IBEXIT("can't resolve destination %s", argv[1]);
 	if ((err = fn(&portid, argv + 2, argc - 2)))
-		IBERROR("operation %s: %s", argv[0], err);
+		IBEXIT("operation %s: %s", argv[0], err);
 
 	mad_rpc_close_port(srcport);
 	exit(0);
diff --git a/src/ibdiag_common.c b/src/ibdiag_common.c
index 3d9e1ad..8c749c7 100644
--- a/src/ibdiag_common.c
+++ b/src/ibdiag_common.c
@@ -254,7 +254,7 @@ static int process_opt(int ch, char *optarg)
 		val = strtol(optarg, &endp, 0);
 		if (errno || (endp && *endp != '\0') || val <= 0 ||
 		    val > INT_MAX)
-			IBERROR("Invalid timeout \"%s\".  Timeout requires a "
+			IBEXIT("Invalid timeout \"%s\".  Timeout requires a "
 				"positive integer value < %d.", optarg, INT_MAX);
 		else {
 			madrpc_set_timeout((int)val);
@@ -265,7 +265,7 @@ static int process_opt(int ch, char *optarg)
 		/* srcport is not required when resolving via IB_DEST_LID */
 		if (resolve_portid_str(ibd_ca, ibd_ca_port, &sm_portid, optarg,
 				IB_DEST_LID, 0, NULL) < 0)
-			IBERROR("cannot resolve SM destination port %s",
+			IBEXIT("cannot resolve SM destination port %s",
 				optarg);
 		ibd_sm_id = &sm_portid;
 		break;
@@ -279,7 +279,7 @@ static int process_opt(int ch, char *optarg)
 			errno = 0;
 			ibd_mkey = strtoull(getpass("M_Key: "), &endp, 0);
 			if (errno || *endp != '\0') {
-				IBERROR("Bad M_Key");
+				IBEXIT("Bad M_Key");
 			}
                 }
                 break;
@@ -409,7 +409,7 @@ int ibdiag_process_opts(int argc, char *const argv[], void *cxt,
 	return 0;
 }
 
-void iberror(const char *fn, char *msg, ...)
+void ibexit(const char *fn, char *msg, ...)
 {
 	char buf[512];
 	va_list va;
diff --git a/src/iblinkinfo.c b/src/iblinkinfo.c
index 5a4cfe5..deffbd1 100644
--- a/src/iblinkinfo.c
+++ b/src/iblinkinfo.c
@@ -683,11 +683,11 @@ int main(int argc, char **argv)
 
 	if (diff_cache_file &&
 	    !(diff_fabric = ibnd_load_fabric(diff_cache_file, 0)))
-		IBERROR("loading cached fabric for diff failed\n");
+		IBEXIT("loading cached fabric for diff failed\n");
 
 	if (filterdownports_cache_file &&
 	    !(filterdownports_fabric = ibnd_load_fabric(filterdownports_cache_file, 0)))
-		IBERROR("loading cached fabric for filterdownports failed\n");
+		IBEXIT("loading cached fabric for filterdownports failed\n");
 
 	if (load_cache_file) {
 		if ((fabric = ibnd_load_fabric(load_cache_file, 0)) == NULL) {
diff --git a/src/ibnetdiscover.c b/src/ibnetdiscover.c
index c8c19aa..0ad5e31 100644
--- a/src/ibnetdiscover.c
+++ b/src/ibnetdiscover.c
@@ -1107,7 +1107,7 @@ int main(int argc, char **argv)
 	config.flags = ibd_ibnetdisc_flags;
 
 	if (argc && !(f = fopen(argv[0], "w")))
-		IBERROR("can't open file %s for writing", argv[0]);
+		IBEXIT("can't open file %s for writing", argv[0]);
 
 	config.mkey = ibd_mkey;
 
@@ -1115,15 +1115,15 @@ int main(int argc, char **argv)
 
 	if (diff_cache_file &&
 	    !(diff_fabric = ibnd_load_fabric(diff_cache_file, 0)))
-		IBERROR("loading cached fabric for diff failed\n");
+		IBEXIT("loading cached fabric for diff failed\n");
 
 	if (load_cache_file) {
 		if ((fabric = ibnd_load_fabric(load_cache_file, 0)) == NULL)
-			IBERROR("loading cached fabric failed\n");
+			IBEXIT("loading cached fabric failed\n");
 	} else {
 		if ((fabric =
 		     ibnd_discover_fabric(ibd_ca, ibd_ca_port, NULL, &config)) == NULL)
-			IBERROR("discover failed\n");
+			IBEXIT("discover failed\n");
 	}
 
 	if (ports_report)
@@ -1137,7 +1137,7 @@ int main(int argc, char **argv)
 
 	if (cache_file)
 		if (ibnd_cache_fabric(fabric, cache_file, 0) < 0)
-			IBERROR("caching ibnetdiscover data failed\n");
+			IBEXIT("caching ibnetdiscover data failed\n");
 
 	ibnd_destroy_fabric(fabric);
 	if (diff_fabric)
diff --git a/src/ibping.c b/src/ibping.c
index beea26d..b697158 100644
--- a/src/ibping.c
+++ b/src/ibping.c
@@ -213,27 +213,27 @@ int main(int argc, char **argv)
 
 	srcport = mad_rpc_open_port(ibd_ca, ibd_ca_port, mgmt_classes, 1);
 	if (!srcport)
-		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
+		IBEXIT("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
 
 	if (server) {
 		if (mad_register_server_via(ping_class, 0, 0, oui, srcport) < 0)
-			IBERROR("can't serve class %d on this port",
+			IBEXIT("can't serve class %d on this port",
 				ping_class);
 
 		get_host_and_domain(host_and_domain, sizeof host_and_domain);
 
 		if ((err = ibping_serv()))
-			IBERROR("ibping to %s: %s", portid2str(&portid), err);
+			IBEXIT("ibping to %s: %s", portid2str(&portid), err);
 		exit(0);
 	}
 
 	if (mad_register_client_via(ping_class, 0, srcport) < 0)
-		IBERROR("can't register ping class %d on this port",
+		IBEXIT("can't register ping class %d on this port",
 			ping_class);
 
 	if (resolve_portid_str(ibd_ca, ibd_ca_port, &portid, argv[0],
 			       ibd_dest_type, ibd_sm_id, srcport) < 0)
-		IBERROR("can't resolve destination port %s", argv[0]);
+		IBEXIT("can't resolve destination port %s", argv[0]);
 
 	signal(SIGINT, report);
 	signal(SIGTERM, report);
diff --git a/src/ibportstate.c b/src/ibportstate.c
index 12ed442..54933c5 100644
--- a/src/ibportstate.c
+++ b/src/ibportstate.c
@@ -126,7 +126,7 @@ static int get_node_info(ib_portid_t * dest, uint8_t * data)
 	int node_type;
 
 	if (!smp_query_via(data, dest, IB_ATTR_NODE_INFO, 0, 0, srcport))
-		IBERROR("smp query nodeinfo failed");
+		IBEXIT("smp query nodeinfo failed");
 
 	node_type = mad_get_field(data, 0, IB_NODE_TYPE_F);
 	if (node_type == IB_NODE_SWITCH)	/* Switch NodeType ? */
@@ -144,13 +144,13 @@ static int get_port_info(ib_portid_t * dest, uint8_t * data, int portnum,
 
 	if (is_switch) {
 		if (!smp_query_via(smp, dest, IB_ATTR_PORT_INFO, 0, 0, srcport))
-			IBERROR("smp query port 0 portinfo failed");
+			IBEXIT("smp query port 0 portinfo failed");
 		info = smp;
 	} else
 		info = data;
 
 	if (!smp_query_via(data, dest, IB_ATTR_PORT_INFO, portnum, 0, srcport))
-		IBERROR("smp query portinfo failed");
+		IBEXIT("smp query portinfo failed");
 	cap_mask = mad_get_field(info, 0, IB_PORT_CAPMASK_F);
 	return (cap_mask & CL_NTOH32(IB_PORT_CAP_HAS_EXT_SPEEDS));
 }
@@ -246,7 +246,7 @@ static void set_port_info(ib_portid_t * dest, uint8_t * data, int portnum,
 	if (espeed_cap)
 		mod |= 1<<31;
 	if (!smp_set_via(data, dest, IB_ATTR_PORT_INFO, mod, 0, srcport))
-		IBERROR("smp set portinfo failed");
+		IBEXIT("smp set portinfo failed");
 
 	printf("\nAfter PortInfo set:\n");
 	show_port_info(dest, data, portnum, espeed_cap, is_switch);
@@ -256,7 +256,7 @@ static void get_ext_port_info(ib_portid_t * dest, uint8_t * data, int portnum)
 {
 	if (!smp_query_via(data, dest, IB_ATTR_MLNX_EXT_PORT_INFO,
 			   portnum, 0, srcport))
-		IBERROR("smp query ext portinfo failed");
+		IBEXIT("smp query ext portinfo failed");
 }
 
 static void show_ext_port_info(ib_portid_t * dest, uint8_t * data, int portnum)
@@ -273,7 +273,7 @@ static void set_ext_port_info(ib_portid_t * dest, uint8_t * data, int portnum)
 {
 	if (!smp_set_via(data, dest, IB_ATTR_MLNX_EXT_PORT_INFO,
 			 portnum, 0, srcport))
-		IBERROR("smp set ext portinfo failed");
+		IBEXIT("smp set ext portinfo failed");
 
 	printf("\nAfter ExtendedPortInfo set:\n");
 	show_ext_port_info(dest, data, portnum);
@@ -413,13 +413,13 @@ int main(int argc, char **argv)
 
 	srcport = mad_rpc_open_port(ibd_ca, ibd_ca_port, mgmt_classes, 3);
 	if (!srcport)
-		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
+		IBEXIT("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
 
 	smp_mkey_set(srcport, ibd_mkey);
 
 	if (resolve_portid_str(ibd_ca, ibd_ca_port, &portid, argv[0],
 			       ibd_dest_type, ibd_sm_id, srcport) < 0)
-		IBERROR("can't resolve destination port %s", argv[0]);
+		IBEXIT("can't resolve destination port %s", argv[0]);
 
 	if (argc > 1)
 		portnum = strtol(argv[1], 0, 0);
@@ -433,7 +433,7 @@ int main(int argc, char **argv)
 			port_args[j].set = 1;
 			if (!port_args[j].val) {
 				if (port_op >= 0)
-					IBERROR("%s only one of: ",
+					IBEXIT("%s only one of: ",
 						"query, enable, disable, "
 						"reset, down, arm, active, "
 						"can be specified",
@@ -442,46 +442,46 @@ int main(int argc, char **argv)
 				break;
 			}
 			if (++i >= argc)
-				IBERROR("%s requires an additional parameter",
+				IBEXIT("%s requires an additional parameter",
 					port_args[j].name);
 			val = strtoull(argv[i], 0, 0);
 			switch (j) {
 			case SPEED:
 				if (val < 0 || val > 15)
-					IBERROR("invalid speed value %ld", val);
+					IBEXIT("invalid speed value %ld", val);
 				break;
 			case ESPEED:
 				if (val < 0 || val > 31)
-					IBERROR("invalid extended speed value %ld", val);
+					IBEXIT("invalid extended speed value %ld", val);
 				break;
 			case FDR10SPEED:
 				if (val < 0 || val > 1)
-					IBERROR("invalid fdr10 speed value %ld", val);
+					IBEXIT("invalid fdr10 speed value %ld", val);
 				break;
 			case WIDTH:
 				if (val < 0 || (val > 15 && val != 255))
-					IBERROR("invalid width value %ld", val);
+					IBEXIT("invalid width value %ld", val);
 				break;
 			case VLS:
 				if (val <= 0 || val > 5)
-					IBERROR("invalid vls value %ld", val);
+					IBEXIT("invalid vls value %ld", val);
 				break;
 			case MTU:
 				if (val <= 0 || val > 5)
-					IBERROR("invalid mtu value %ld", val);
+					IBEXIT("invalid mtu value %ld", val);
 				break;
 			case LID:
 				if (val <= 0 || val >= 0xC000)
-					IBERROR("invalid lid value 0x%lx", val);
+					IBEXIT("invalid lid value 0x%lx", val);
 				break;
 			case SMLID:
 				if (val <= 0 || val >= 0xC000)
-					IBERROR("invalid smlid value 0x%lx",
+					IBEXIT("invalid smlid value 0x%lx",
 						val);
 				break;
 			case LMC:
 				if (val < 0 || val > 7)
-					IBERROR("invalid lmc value %ld", val);
+					IBEXIT("invalid lmc value %ld", val);
 				break;
 			case MKEY:
 				errno = 0;
@@ -491,25 +491,25 @@ int main(int argc, char **argv)
 					val = strtoull(getpass("New M_Key: "),
 						       &endp, 0);
 					if (errno || *endp != '\0') {
-						IBERROR("Bad new M_Key\n");
+						IBEXIT("Bad new M_Key\n");
 					}
 				}
 				/* All 64-bit values are legal */
 				break;
 			case MKEYLEASE:
 				if (val < 0 || val > 0xFFFF)
-					IBERROR("invalid mkey lease time %ld", val);
+					IBEXIT("invalid mkey lease time %ld", val);
 				break;
 			case MKEYPROT:
 				if (val < 0 || val > 3)
-					IBERROR("invalid mkey protection bit setting %ld", val);
+					IBEXIT("invalid mkey protection bit setting %ld", val);
 			}
 			*port_args[j].val = val;
 			changed = 1;
 			break;
 		}
 		if (j == NPORT_ARGS)
-			IBERROR("invalid operation: %s", argv[i]);
+			IBEXIT("invalid operation: %s", argv[i]);
 	}
 	if (port_op < 0)
 		port_op = QUERY;
@@ -519,7 +519,7 @@ int main(int argc, char **argv)
 
 	if ((port_args[MKEY].set || port_args[MKEYLEASE].set ||
 	     port_args[MKEYPROT].set) && is_switch && portnum != 0)
-		IBERROR("Can't set M_Key fields on switch port != 0");
+		IBEXIT("Can't set M_Key fields on switch port != 0");
 
 	if (port_op != QUERY || changed)
 		printf("Initial %s PortInfo:\n", is_switch ? "Switch" : "CA");
@@ -661,7 +661,7 @@ int main(int argc, char **argv)
 			/* Set DrSLID to local lid */
 			if (resolve_self(ibd_ca, ibd_ca_port, &selfportid,
 						&selfport, 0) < 0)
-				IBERROR("could not resolve self");
+				IBEXIT("could not resolve self");
 			peerportid.drpath.drslid = (uint16_t) selfportid.lid;
 			peerportid.drpath.drdlid = 0xffff;
 
diff --git a/src/ibqueryerrors.c b/src/ibqueryerrors.c
index cf9cff2..9d9ec45 100644
--- a/src/ibqueryerrors.c
+++ b/src/ibqueryerrors.c
@@ -986,7 +986,7 @@ int main(int argc, char **argv)
 
 	ibmad_port = mad_rpc_open_port(ibd_ca, ibd_ca_port, mgmt_classes, 4);
 	if (!ibmad_port)
-		IBERROR("Failed to open port; %s:%d\n", ibd_ca, ibd_ca_port);
+		IBEXIT("Failed to open port; %s:%d\n", ibd_ca, ibd_ca_port);
 
 	smp_mkey_set(ibmad_port, ibd_mkey);
 
@@ -1006,7 +1006,7 @@ int main(int argc, char **argv)
 	}
 
 	if (resolve_self(ibd_ca, ibd_ca_port, &self_portid, &port, &self_gid.raw) < 0) {
-		IBERROR("can't resolve self port %s", argv[0]);
+		IBEXIT("can't resolve self port %s", argv[0]);
 		goto close_port;
 	}
 
diff --git a/src/ibroute.c b/src/ibroute.c
index d4827c9..4a6ed60 100644
--- a/src/ibroute.c
+++ b/src/ibroute.c
@@ -466,13 +466,13 @@ int main(int argc, char **argv)
 
 	srcport = mad_rpc_open_port(ibd_ca, ibd_ca_port, mgmt_classes, 3);
 	if (!srcport)
-		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
+		IBEXIT("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
 
 	smp_mkey_set(srcport, ibd_mkey);
 
 	if (resolve_portid_str(ibd_ca, ibd_ca_port, &portid, argv[0],
 			       ibd_dest_type, ibd_sm_id, srcport) < 0)
-		IBERROR("can't resolve destination port %s", argv[0]);
+		IBEXIT("can't resolve destination port %s", argv[0]);
 
 	if (multicast)
 		err = dump_multicast_tables(&portid, startlid, endlid);
@@ -480,7 +480,7 @@ int main(int argc, char **argv)
 		err = dump_unicast_tables(&portid, startlid, endlid);
 
 	if (err)
-		IBERROR("dump tables: %s", err);
+		IBEXIT("dump tables: %s", err);
 
 	mad_rpc_close_port(srcport);
 	close_node_name_map(node_name_map);
diff --git a/src/ibsendtrap.c b/src/ibsendtrap.c
index 39b75c2..46fd6e7 100644
--- a/src/ibsendtrap.c
+++ b/src/ibsendtrap.c
@@ -131,10 +131,10 @@ static int send_trap(const char *name,
 	ib_mad_notice_attr_t notice;
 
 	if (resolve_self(ibd_ca, ibd_ca_port, &selfportid, &selfport, NULL))
-		IBERROR("can't resolve self");
+		IBEXIT("can't resolve self");
 
 	if (resolve_sm_portid(ibd_ca, ibd_ca_port, &sm_port))
-		IBERROR("can't resolve SM destination port");
+		IBEXIT("can't resolve SM destination port");
 
 	memset(&trap_rpc, 0, sizeof(trap_rpc));
 	trap_rpc.mgtclass = IB_SMI_CLASS;
@@ -207,7 +207,7 @@ int main(int argc, char **argv)
 
 	srcport = mad_rpc_open_port(ibd_ca, ibd_ca_port, mgmt_classes, 2);
 	if (!srcport)
-		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
+		IBEXIT("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
 
 	smp_mkey_set(srcport, ibd_mkey);
 
diff --git a/src/ibsysstat.c b/src/ibsysstat.c
index c1438c1..ec3b86b 100644
--- a/src/ibsysstat.c
+++ b/src/ibsysstat.c
@@ -341,30 +341,30 @@ int main(int argc, char **argv)
 
 	srcport = mad_rpc_open_port(ibd_ca, ibd_ca_port, mgmt_classes, 3);
 	if (!srcport)
-		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
+		IBEXIT("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
 
 	if (server) {
 		if (mad_register_server_via(sysstat_class, 1, 0, oui, srcport) <
 		    0)
-			IBERROR("can't serve class %d", sysstat_class);
+			IBEXIT("can't serve class %d", sysstat_class);
 
 		host_ncpu = build_cpuinfo();
 
 		if ((err = ibsystat_serv()))
-			IBERROR("ibssystat to %s: %s", portid2str(&portid),
+			IBEXIT("ibssystat to %s: %s", portid2str(&portid),
 				err);
 		exit(0);
 	}
 
 	if (mad_register_client_via(sysstat_class, 1, srcport) < 0)
-		IBERROR("can't register to sysstat class %d", sysstat_class);
+		IBEXIT("can't register to sysstat class %d", sysstat_class);
 
 	if (resolve_portid_str(ibd_ca, ibd_ca_port, &portid, argv[0],
 			       ibd_dest_type, ibd_sm_id, srcport) < 0)
-		IBERROR("can't resolve destination port %s", argv[0]);
+		IBEXIT("can't resolve destination port %s", argv[0]);
 
 	if ((err = ibsystat(&portid, attr)))
-		IBERROR("ibsystat to %s: %s", portid2str(&portid), err);
+		IBEXIT("ibsystat to %s: %s", portid2str(&portid), err);
 
 	mad_rpc_close_port(srcport);
 	exit(0);
diff --git a/src/ibtracert.c b/src/ibtracert.c
index 02a9f1c..d32968b 100644
--- a/src/ibtracert.c
+++ b/src/ibtracert.c
@@ -509,10 +509,10 @@ static Node *find_mcpath(ib_portid_t * from, int mlid)
 	DEBUG("from %s", portid2str(from));
 
 	if (!(node = calloc(1, sizeof(Node))))
-		IBERROR("out of memory");
+		IBEXIT("out of memory");
 
 	if (!(port = calloc(1, sizeof(Port))))
-		IBERROR("out of memory");
+		IBEXIT("out of memory");
 
 	if (get_node(node, port, from) < 0) {
 		IBWARN("can't reach node %s", portid2str(from));
@@ -575,7 +575,7 @@ static Node *find_mcpath(ib_portid_t * from, int mlid)
 						path->drpath.cnt--;
 				} else {
 					if (!(port = calloc(1, sizeof(Port))))
-						IBERROR("out of memory");
+						IBEXIT("out of memory");
 
 					if (get_port(port, i, path) < 0) {
 						IBWARN
@@ -600,10 +600,10 @@ static Node *find_mcpath(ib_portid_t * from, int mlid)
 				}
 
 				if (!(remotenode = calloc(1, sizeof(Node))))
-					IBERROR("out of memory");
+					IBEXIT("out of memory");
 
 				if (!(remoteport = calloc(1, sizeof(Port))))
-					IBERROR("out of memory");
+					IBEXIT("out of memory");
 
 				if (get_node(remotenode, remoteport, path) < 0) {
 					IBWARN
@@ -782,7 +782,7 @@ int main(int argc, char **argv)
 
 	srcport = mad_rpc_open_port(ibd_ca, ibd_ca_port, mgmt_classes, 3);
 	if (!srcport)
-		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
+		IBEXIT("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
 
 	smp_mkey_set(srcport, ibd_mkey);
 
@@ -790,18 +790,18 @@ int main(int argc, char **argv)
 
 	if (resolve_portid_str(ibd_ca, ibd_ca_port, &src_portid, argv[0],
 			       ibd_dest_type, ibd_sm_id, srcport) < 0)
-		IBERROR("can't resolve source port %s", argv[0]);
+		IBEXIT("can't resolve source port %s", argv[0]);
 
 	if (resolve_portid_str(ibd_ca, ibd_ca_port, &dest_portid, argv[1],
 			       ibd_dest_type, ibd_sm_id, srcport) < 0)
-		IBERROR("can't resolve destination port %s", argv[1]);
+		IBEXIT("can't resolve destination port %s", argv[1]);
 
 	if (ibd_dest_type == IB_DEST_DRPATH) {
 		if (resolve_lid(&src_portid, NULL) < 0)
-			IBERROR("cannot resolve lid for port \'%s\'",
+			IBEXIT("cannot resolve lid for port \'%s\'",
 				portid2str(&src_portid));
 		if (resolve_lid(&dest_portid, NULL) < 0)
-			IBERROR("cannot resolve lid for port \'%s\'",
+			IBEXIT("cannot resolve lid for port \'%s\'",
 				portid2str(&dest_portid));
 	}
 
@@ -813,14 +813,14 @@ int main(int argc, char **argv)
 	if (ibd_dest_type != IB_DEST_DRPATH) {
 		/* first find a direct path to the src port */
 		if (find_route(&my_portid, &src_portid, 0) < 0)
-			IBERROR("can't find a route to the src port");
+			IBEXIT("can't find a route to the src port");
 
 		src_portid = my_portid;
 	}
 
 	if (!multicast) {
 		if (find_route(&src_portid, &dest_portid, dumplevel) < 0)
-			IBERROR("can't find a route from src to dest");
+			IBEXIT("can't find a route from src to dest");
 		exit(0);
 	} else {
 		if (mlid < 0xc000)
@@ -828,10 +828,10 @@ int main(int argc, char **argv)
 	}
 
 	if (!(target_portguid = find_target_portguid(&dest_portid)))
-		IBERROR("can't reach target lid %d", dest_portid.lid);
+		IBEXIT("can't reach target lid %d", dest_portid.lid);
 
 	if (!(endnode = find_mcpath(&src_portid, mlid)))
-		IBERROR("can't find a multicast route from src to dest");
+		IBEXIT("can't find a multicast route from src to dest");
 
 	/* dump multicast path */
 	dump_mcpath(endnode, dumplevel);
diff --git a/src/perfquery.c b/src/perfquery.c
index df8556b..9a69ee1 100644
--- a/src/perfquery.c
+++ b/src/perfquery.c
@@ -304,7 +304,7 @@ static void dump_perfcounters(int extended, int timeout, uint16_t cap_mask,
 		memset(pc, 0, sizeof(pc));
 		if (!pma_query_via(pc, portid, port, timeout,
 				   IB_GSI_PORT_COUNTERS, srcport))
-			IBERROR("perfquery");
+			IBEXIT("perfquery");
 		if (!(cap_mask & IB_PM_PC_XMIT_WAIT_SUP)) {
 			/* if PortCounters:PortXmitWait not supported clear this counter */
 			VERBOSE("PortXmitWait not indicated"
@@ -333,7 +333,7 @@ static void dump_perfcounters(int extended, int timeout, uint16_t cap_mask,
 		memset(pc, 0, sizeof(pc));
 		if (!pma_query_via(pc, portid, port, timeout,
 				   IB_GSI_PORT_COUNTERS_EXT, srcport))
-			IBERROR("perfextquery");
+			IBEXIT("perfextquery");
 		if (aggregate)
 			aggregate_perfcounters_ext(cap_mask);
 		else
@@ -360,11 +360,11 @@ static void reset_counters(int extended, int timeout, int mask,
 	if (extended != 1) {
 		if (!performance_reset_via(pc, portid, port, mask, timeout,
 					   IB_GSI_PORT_COUNTERS, srcport))
-			IBERROR("perf reset");
+			IBEXIT("perf reset");
 	} else {
 		if (!performance_reset_via(pc, portid, port, mask, timeout,
 					   IB_GSI_PORT_COUNTERS_EXT, srcport))
-			IBERROR("perf ext reset");
+			IBEXIT("perf ext reset");
 	}
 }
 
@@ -386,7 +386,7 @@ static void common_func(ib_portid_t * portid, int port_num, int mask,
 		memset(pc, 0, sizeof(pc));
 		if (!pma_query_via(pc, portid, port_num, ibd_timeout, attr,
 				   srcport))
-			IBERROR("cannot query %s", name);
+			IBEXIT("cannot query %s", name);
 
 		dump_func(buf, sizeof(buf), pc, sizeof(pc));
 
@@ -397,7 +397,7 @@ static void common_func(ib_portid_t * portid, int port_num, int mask,
 	memset(pc, 0, sizeof(pc));
 	if (reset && !performance_reset_via(pc, portid, port, mask, ibd_timeout,
 					    attr, srcport))
-		IBERROR("cannot reset %s", name);
+		IBEXIT("cannot reset %s", name);
 }
 
 static void xmt_sl_query(ib_portid_t * portid, int port, int mask)
@@ -477,7 +477,7 @@ static void extended_speeds_query(ib_portid_t * portid, int port, uint64_t ext_m
 
 	if ((reset_only || reset) &&
 	    !ext_speeds_reset_via(pc, portid, port, ext_mask, ibd_timeout, srcport))
-		IBERROR("cannot reset PortExtendedSpeedsCounters");
+		IBEXIT("cannot reset PortExtendedSpeedsCounters");
 }
 
 static void oprcvcounters_query(ib_portid_t * portid, int port, int mask)
@@ -571,7 +571,7 @@ void dump_portsamples_control(ib_portid_t * portid, int port)
 	memset(pc, 0, sizeof(pc));
 	if (!pma_query_via(pc, portid, port, ibd_timeout,
 			   IB_GSI_PORT_SAMPLES_CONTROL, srcport))
-		IBERROR("sampctlquery");
+		IBEXIT("sampctlquery");
 
 	mad_dump_portsamples_control(buf, sizeof buf, pc, sizeof pc);
 	printf("# PortSamplesControl: %s port %d\n%s", portid2str(portid),
@@ -743,7 +743,7 @@ int main(int argc, char **argv)
 			pmax = strtoul(tmpstr, 0, 0);
 
 			if (pmin >= pmax)
-				IBERROR("max port must be greater than min port in range");
+				IBEXIT("max port must be greater than min port in range");
 
 			while (pmin <= pmax)
 				ports[ports_count++] = pmin++;
@@ -760,29 +760,29 @@ int main(int argc, char **argv)
 
 	srcport = mad_rpc_open_port(ibd_ca, ibd_ca_port, mgmt_classes, 3);
 	if (!srcport)
-		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
+		IBEXIT("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
 
 	smp_mkey_set(srcport, ibd_mkey);
 
 	if (argc) {
 		if (resolve_portid_str(ibd_ca, ibd_ca_port, &portid, argv[0],
 				       ibd_dest_type, ibd_sm_id, srcport) < 0)
-			IBERROR("can't resolve destination port %s", argv[0]);
+			IBEXIT("can't resolve destination port %s", argv[0]);
 	} else {
 		if (resolve_self(ibd_ca, ibd_ca_port, &portid, &port, 0) < 0)
-			IBERROR("can't resolve self port %s", argv[0]);
+			IBEXIT("can't resolve self port %s", argv[0]);
 	}
 
 	/* PerfMgt ClassPortInfo is a required attribute */
 	memset(pc, 0, sizeof(pc));
 	if (!pma_query_via(pc, &portid, port, ibd_timeout, CLASS_PORT_INFO,
 			   srcport))
-		IBERROR("classportinfo query");
+		IBEXIT("classportinfo query");
 	/* ClassPortInfo should be supported as part of libibmad */
 	memcpy(&cap_mask, pc + 2, sizeof(cap_mask));	/* CapabilityMask */
 	if (!(cap_mask & IB_PM_ALL_PORT_SELECT)) {	/* bit 8 is AllPortSelect */
 		if (!all_ports && port == ALL_PORTS)
-			IBERROR("AllPortSelect not supported");
+			IBEXIT("AllPortSelect not supported");
 		if (all_ports && port == ALL_PORTS)
 			all_ports_loop = 1;
 	}
@@ -881,16 +881,16 @@ int main(int argc, char **argv)
 	if (all_ports_loop || (loop_ports && (all_ports || port == ALL_PORTS))) {
 		if (smp_query_via(data, &portid, IB_ATTR_NODE_INFO, 0, 0,
 				  srcport) < 0)
-			IBERROR("smp query nodeinfo failed");
+			IBEXIT("smp query nodeinfo failed");
 		node_type = mad_get_field(data, 0, IB_NODE_TYPE_F);
 		mad_decode_field(data, IB_NODE_NPORTS_F, &num_ports);
 		if (!num_ports)
-			IBERROR("smp query nodeinfo: num ports invalid");
+			IBEXIT("smp query nodeinfo: num ports invalid");
 
 		if (node_type == IB_NODE_SWITCH) {
 			if (smp_query_via(data, &portid, IB_ATTR_SWITCH_INFO,
 					  0, 0, srcport) < 0)
-				IBERROR("smp query nodeinfo failed");
+				IBEXIT("smp query nodeinfo failed");
 			enhancedport0 =
 			    mad_get_field(data, 0, IB_SW_ENHANCED_PORT0_F);
 			if (enhancedport0)
diff --git a/src/saquery.c b/src/saquery.c
index b27686b..e4fbc87 100644
--- a/src/saquery.c
+++ b/src/saquery.c
@@ -1843,7 +1843,7 @@ int main(int argc, char **argv)
 	}
 
 	if (umad_init())
-		IBERROR("Failed to initialized umad library");
+		IBEXIT("Failed to initialized umad library");
 
 	h = sa_get_handle();
 	if (!h)
diff --git a/src/sminfo.c b/src/sminfo.c
index 2471a08..894d9fc 100644
--- a/src/sminfo.c
+++ b/src/sminfo.c
@@ -120,17 +120,17 @@ int main(int argc, char **argv)
 
 	srcport = mad_rpc_open_port(ibd_ca, ibd_ca_port, mgmt_classes, 3);
 	if (!srcport)
-		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
+		IBEXIT("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
 
 	smp_mkey_set(srcport, ibd_mkey);
 
 	if (argc) {
 		if (resolve_portid_str(ibd_ca, ibd_ca_port, &portid, argv[0],
 				       ibd_dest_type, 0, srcport) < 0)
-			IBERROR("can't resolve destination port %s", argv[0]);
+			IBEXIT("can't resolve destination port %s", argv[0]);
 	} else {
 		if (resolve_sm_portid(ibd_ca, ibd_ca_port, &portid) < 0)
-			IBERROR("can't resolve sm port %s", argv[0]);
+			IBEXIT("can't resolve sm port %s", argv[0]);
 	}
 
 	mad_encode_field(sminfo, IB_SMINFO_GUID_F, &guid);
@@ -142,10 +142,10 @@ int main(int argc, char **argv)
 	if (mod) {
 		if (!(p = smp_set_via(sminfo, &portid, IB_ATTR_SMINFO, mod,
 				      ibd_timeout, srcport)))
-			IBERROR("query");
+			IBEXIT("query");
 	} else if (!(p = smp_query_via(sminfo, &portid, IB_ATTR_SMINFO, 0,
 				       ibd_timeout, srcport)))
-		IBERROR("query");
+		IBEXIT("query");
 
 	mad_decode_field(sminfo, IB_SMINFO_GUID_F, &guid);
 	mad_decode_field(sminfo, IB_SMINFO_ACT_F, &act);
diff --git a/src/smpquery.c b/src/smpquery.c
index 5ba0a05..e2d509a 100644
--- a/src/smpquery.c
+++ b/src/smpquery.c
@@ -453,11 +453,11 @@ int main(int argc, char **argv)
 		ibdiag_show_usage();
 
 	if (!(fn = match_op(match_tbl, argv[0])))
-		IBERROR("operation '%s' not supported", argv[0]);
+		IBEXIT("operation '%s' not supported", argv[0]);
 
 	srcport = mad_rpc_open_port(ibd_ca, ibd_ca_port, mgmt_classes, 3);
 	if (!srcport)
-		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
+		IBEXIT("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
 
 	smp_mkey_set(srcport, ibd_mkey);
 
@@ -466,9 +466,9 @@ int main(int argc, char **argv)
 	if (ibd_dest_type != IB_DEST_DRSLID) {
 		if (resolve_portid_str(ibd_ca, ibd_ca_port, &portid, argv[1],
 				       ibd_dest_type, ibd_sm_id, srcport) < 0)
-			IBERROR("can't resolve destination port %s", argv[1]);
+			IBEXIT("can't resolve destination port %s", argv[1]);
 		if ((err = fn(&portid, argv + 2, argc - 2)))
-			IBERROR("operation %s: %s", argv[0], err);
+			IBEXIT("operation %s: %s", argv[0], err);
 	} else {
 		char concat[64];
 
@@ -476,9 +476,9 @@ int main(int argc, char **argv)
 		snprintf(concat, sizeof(concat), "%s %s", argv[1], argv[2]);
 		if (resolve_portid_str(ibd_ca, ibd_ca_port, &portid, concat,
 				       ibd_dest_type, ibd_sm_id, srcport) < 0)
-			IBERROR("can't resolve destination port %s", concat);
+			IBEXIT("can't resolve destination port %s", concat);
 		if ((err = fn(&portid, argv + 3, argc - 3)))
-			IBERROR("operation %s: %s", argv[0], err);
+			IBEXIT("operation %s: %s", argv[0], err);
 	}
 	close_node_name_map(node_name_map);
 	mad_rpc_close_port(srcport);
diff --git a/src/vendstat.c b/src/vendstat.c
index 8535792..a53e80d 100644
--- a/src/vendstat.c
+++ b/src/vendstat.c
@@ -171,7 +171,7 @@ static int do_vendor(ib_portid_t *portid, struct ibmad_port *srcport,
 	call.mod = attr_mod;
 
 	if (!ib_vendor_call_via(data, portid, &call, srcport))
-		IBERROR("vendstat: method %u, attribute %u", method, attr_id);
+		IBEXIT("vendstat: method %u, attribute %u", method, attr_id);
 
 	return 0;
 }
@@ -193,7 +193,7 @@ static void do_config_space_records(ib_portid_t *portid, unsigned set,
 		      set ? IB_MAD_METHOD_SET : IB_MAD_METHOD_GET,
 		      IB_MLX_IS3_CONFIG_SPACE_ACCESS, 2 << 22 | records << 16,
 		      cs))
-		IBERROR("cannot %s config space records", set ? "set" : "get");
+		IBEXIT("cannot %s config space records", set ? "set" : "get");
 
 	for (i = 0; i < records; i++) {
 		printf("Config space record at 0x%x: 0x%x\n",
@@ -212,7 +212,7 @@ static void counter_groups_info(ib_portid_t * portid, int port)
 	memset(&buf, 0, sizeof(buf));
 	if (do_vendor(portid, srcport, IB_MLX_VENDOR_CLASS, IB_MAD_METHOD_GET,
 		      IB_MLX_IS4_COUNTER_GROUP_INFO, port, buf))
-		IBERROR("counter group info query");
+		IBEXIT("counter group info query");
 
 	cg_info = (is4_counter_group_info_t *) & buf;
 	num_cg = cg_info->num_of_counter_groups;
@@ -250,14 +250,14 @@ static void config_counter_groups(ib_portid_t * portid, int port)
 
 	if (do_vendor(portid, srcport, IB_MLX_VENDOR_CLASS, IB_MAD_METHOD_SET,
 		      IB_MLX_IS4_CONFIG_COUNTER_GROUP, port, buf))
-		IBERROR("config counter group set");
+		IBEXIT("config counter group set");
 
 	/* get config counter groups */
 	memset(&buf, 0, sizeof(buf));
 
 	if (do_vendor(portid, srcport, IB_MLX_VENDOR_CLASS, IB_MAD_METHOD_GET,
 		      IB_MLX_IS4_CONFIG_COUNTER_GROUP, port, buf))
-		IBERROR("config counter group query");
+		IBEXIT("config counter group query");
 }
 
 static int general_info, xmit_wait, counter_group_info, config_counter_group;
@@ -357,15 +357,15 @@ int main(int argc, char **argv)
 
 	srcport = mad_rpc_open_port(ibd_ca, ibd_ca_port, mgmt_classes, 2);
 	if (!srcport)
-		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
+		IBEXIT("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
 
 	if (argc) {
 		if (resolve_portid_str(ibd_ca, ibd_ca_port, &portid, argv[0],
 				       ibd_dest_type, ibd_sm_id, srcport) < 0)
-			IBERROR("can't resolve destination port %s", argv[0]);
+			IBEXIT("can't resolve destination port %s", argv[0]);
 	} else {
 		if (resolve_self(ibd_ca, ibd_ca_port, &portid, &port, 0) < 0)
-			IBERROR("can't resolve self port %s", argv[0]);
+			IBEXIT("can't resolve self port %s", argv[0]);
 	}
 
 	if (counter_group_info) {
@@ -393,7 +393,7 @@ int main(int argc, char **argv)
 	/* Only General Info and Port Xmit Wait Counters */
 	/* queries are currently supported */
 	if (!general_info && !xmit_wait)
-		IBERROR("at least one of -N and -w must be specified");
+		IBEXIT("at least one of -N and -w must be specified");
 
 	/* Would need a list of these and it might not be complete */
 	/* so for right now, punt on this */
@@ -402,13 +402,13 @@ int main(int argc, char **argv)
 	memset(&buf, 0, sizeof(buf));
 	if (do_vendor(&portid, srcport, IB_MLX_VENDOR_CLASS, IB_MAD_METHOD_GET,
 		      CLASS_PORT_INFO, 0, buf))
-		IBERROR("classportinfo query");
+		IBEXIT("classportinfo query");
 
 	memset(&buf, 0, sizeof(buf));
 	gi_is3 = (is3_general_info_t *) &buf;
 	if (do_vendor(&portid, srcport, IB_MLX_VENDOR_CLASS, IB_MAD_METHOD_GET,
 		      IB_MLX_IS3_GENERAL_INFO, 0, gi_is3))
-		IBERROR("generalinfo query");
+		IBEXIT("generalinfo query");
 
 	if (is_ext_fw_info_supported(ntohs(gi_is3->hw_info.device_id))) {
 		gi_is4 = (is4_general_info_t *) &buf;
@@ -444,7 +444,7 @@ int main(int argc, char **argv)
 		unsigned i;
 
 		if (ntohs(gi_is3->hw_info.device_id) != IS3_DEVICE_ID)
-			IBERROR("Unsupported device ID 0x%x",
+			IBEXIT("Unsupported device ID 0x%x",
 				ntohs(gi_is3->hw_info.device_id));
 
 		memset(&buf, 0, sizeof(buf));
@@ -456,7 +456,7 @@ int main(int argc, char **argv)
 		if (do_vendor(&portid, srcport, IB_MLX_VENDOR_CLASS,
 			      IB_MAD_METHOD_GET, IB_MLX_IS3_CONFIG_SPACE_ACCESS,
 			      2 << 22 | 16 << 16, cs))
-			IBERROR("vendstat");
+			IBEXIT("vendstat");
 
 		for (i = 0; i < 16; i++)
 			if (cs->record[i].data)	/* PortXmitWait is 32 bit counter */
@@ -472,7 +472,7 @@ int main(int argc, char **argv)
 		if (do_vendor(&portid, srcport, IB_MLX_VENDOR_CLASS,
 			      IB_MAD_METHOD_GET, IB_MLX_IS3_CONFIG_SPACE_ACCESS,
 			      2 << 22 | 8 << 16, cs))
-			IBERROR("vendstat");
+			IBEXIT("vendstat");
 
 		for (i = 0; i < 8; i++)
 			if (cs->record[i].data)	/* PortXmitWait is 32 bit counter */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
