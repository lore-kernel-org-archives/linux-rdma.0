From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH V3 1/3] infiniband-diags: libibnetdisc add find node by lid
Date: Wed, 6 Feb 2013 15:46:17 -0800
Message-ID: <20130206154617.c52e16f51b92103db1a96006@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



NOTE: this change adds a glib requirement to the package.

Changes since V1:
	Use GINT_TO_POINTER rather than allocating keys

Changes since V2:
	Use internal object everywhere rather than just hacked into
	discover_fabric
	Generate lid2port hash when reading cached fabrics

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 configure.in                                |    7 ++
 infiniband-diags.spec.in                    |    4 +-
 libibnetdisc/Makefile.am                    |    4 +-
 libibnetdisc/include/infiniband/ibnetdisc.h |    3 +
 libibnetdisc/libibnetdisc.ver               |    2 +-
 libibnetdisc/src/ibnetdisc.c                |  126 ++++++++++++++++++--------
 libibnetdisc/src/ibnetdisc_cache.c          |   32 ++++----
 libibnetdisc/src/internal.h                 |   15 +++-
 libibnetdisc/src/libibnetdisc.map           |    1 +
 9 files changed, 132 insertions(+), 62 deletions(-)

diff --git a/configure.in b/configure.in
index 2dc60a0..ca62d5b 100644
--- a/configure.in
+++ b/configure.in
@@ -161,6 +161,13 @@ IBSCRIPTPATH_TMP2="`echo $IBSCRIPTPATH_TMP1 | sed 's/^NONE/$ac_default_prefix/'`
 IBSCRIPTPATH="${with_ibpath_override:-`eval echo $IBSCRIPTPATH_TMP2`}"
 AC_SUBST(IBSCRIPTPATH)
 
+dnl check for glib
+PKG_CHECK_MODULES([GLIB], [glib-2.0], ac_glib=yes, ac_glib=no)
+AM_CONDITIONAL([HAVE_GLIB], test "$ac_glib" = "yes")
+if test "$ac_glib" = "yes"; then
+   AC_DEFINE([HAVE_GLIB], 1, [Define to 1 to indicate GLIB support])
+fi
+
 dnl Begin libibnetdisc stuff
 ibnetdisc_api_version=`grep LIBVERSION $srcdir/libibnetdisc/libibnetdisc.ver | sed 's/LIBVERSION=//'`
 if test -z $ibnetdisc_api_version; then
diff --git a/infiniband-diags.spec.in b/infiniband-diags.spec.in
index d3fcd13..9cd195b 100644
--- a/infiniband-diags.spec.in
+++ b/infiniband-diags.spec.in
@@ -11,8 +11,8 @@ Group: System Environment/Libraries
 BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
 Source: http://www.openfabrics.org/downloads/management/@TARBALL@
 Url: http://openfabrics.org/
-BuildRequires: libibmad-devel, opensm-devel, libibumad-devel
-Requires: libibmad, opensm-libs, libibumad
+BuildRequires: libibmad-devel, opensm-devel, libibumad-devel, glib-devel
+Requires: libibmad, opensm-libs, libibumad, glib
 Provides: perl(IBswcountlimits)
 Obsoletes: openib-diags
 
diff --git a/libibnetdisc/Makefile.am b/libibnetdisc/Makefile.am
index fbf0e60..d05604f 100644
--- a/libibnetdisc/Makefile.am
+++ b/libibnetdisc/Makefile.am
@@ -24,10 +24,10 @@ endif
 
 libibnetdisc_la_SOURCES = src/ibnetdisc.c src/ibnetdisc_cache.c src/chassis.c \
 			  src/chassis.h src/internal.h src/query_smp.c
-libibnetdisc_la_CFLAGS = -Wall $(DBGFLAGS)
+libibnetdisc_la_CFLAGS = -Wall $(DBGFLAGS) $(GLIB_CFLAGS)
 libibnetdisc_la_LDFLAGS = -version-info $(ibnetdisc_api_version) \
 	-export-dynamic $(libibnetdisc_version_script) \
-	-libmad
+	-libmad $(GLIB_LIBS)
 libibnetdisc_la_DEPENDENCIES = $(srcdir)/src/libibnetdisc.map
 
 libibnetdiscincludedir = $(includedir)/infiniband
diff --git a/libibnetdisc/include/infiniband/ibnetdisc.h b/libibnetdisc/include/infiniband/ibnetdisc.h
index e41c92c..acde1dc 100644
--- a/libibnetdisc/include/infiniband/ibnetdisc.h
+++ b/libibnetdisc/include/infiniband/ibnetdisc.h
@@ -231,6 +231,9 @@ IBND_EXPORT ibnd_port_t *ibnd_find_port_guid(ibnd_fabric_t * fabric,
 					uint64_t guid);
 IBND_EXPORT ibnd_port_t *ibnd_find_port_dr(ibnd_fabric_t * fabric,
 					char *dr_str);
+IBND_EXPORT ibnd_port_t *ibnd_find_port_lid(ibnd_fabric_t * fabric,
+					    uint16_t lid);
+
 typedef void (*ibnd_iter_port_func_t) (ibnd_port_t * port, void *user_data);
 IBND_EXPORT void ibnd_iter_ports(ibnd_fabric_t * fabric,
 				ibnd_iter_port_func_t func, void *user_data);
diff --git a/libibnetdisc/libibnetdisc.ver b/libibnetdisc/libibnetdisc.ver
index c513f2a..59fca19 100644
--- a/libibnetdisc/libibnetdisc.ver
+++ b/libibnetdisc/libibnetdisc.ver
@@ -6,4 +6,4 @@
 # API_REV - advance on any added API
 # RUNNING_REV - advance any change to the vendor files
 # AGE - number of backward versions the API still supports
-LIBVERSION=7:0:2
+LIBVERSION=8:0:3
diff --git a/libibnetdisc/src/ibnetdisc.c b/libibnetdisc/src/ibnetdisc.c
index 3a7dd8f..9d120dd 100644
--- a/libibnetdisc/src/ibnetdisc.c
+++ b/libibnetdisc/src/ibnetdisc.c
@@ -98,10 +98,10 @@ static int add_port_to_dpath(ib_dr_path_t * path, int nextport)
 static int retract_dpath(smp_engine_t * engine, ib_portid_t * portid)
 {
 	ibnd_scan_t *scan = engine->user_data;
-	ibnd_fabric_t *fabric = scan->fabric;
+	f_internal_t *f_int = scan->f_int;
 
 	if (scan->cfg->max_hops &&
-	    fabric->maxhops_discovered > scan->cfg->max_hops)
+	    f_int->fabric.maxhops_discovered > scan->cfg->max_hops)
 		return 0;
 
 	/* this may seem wrong but the only time we would retract the path is
@@ -109,7 +109,7 @@ static int retract_dpath(smp_engine_t * engine, ib_portid_t * portid)
 	 * from that to find the node it is connected to.  This counts as a
 	 * positive hop discovered
 	 */
-	fabric->maxhops_discovered++;
+	f_int->fabric.maxhops_discovered++;
 	portid->drpath.p[portid->drpath.cnt] = 0;
 	portid->drpath.cnt--;
 	return 1;
@@ -119,10 +119,10 @@ static int extend_dpath(smp_engine_t * engine, ib_portid_t * portid,
 			int nextport)
 {
 	ibnd_scan_t *scan = engine->user_data;
-	ibnd_fabric_t *fabric = scan->fabric;
+	f_internal_t *f_int = scan->f_int;
 
 	if (scan->cfg->max_hops &&
-	    fabric->maxhops_discovered > scan->cfg->max_hops)
+	    f_int->fabric.maxhops_discovered > scan->cfg->max_hops)
 		return 0;
 
 	if (portid->lid) {
@@ -144,8 +144,8 @@ static int extend_dpath(smp_engine_t * engine, ib_portid_t * portid,
 	}
 
 	if (((unsigned) portid->drpath.cnt - scan->initial_hops) >
-	    fabric->maxhops_discovered)
-		fabric->maxhops_discovered++;
+	    f_int->fabric.maxhops_discovered)
+		f_int->fabric.maxhops_discovered++;
 
 	return 1;
 }
@@ -213,7 +213,7 @@ static int is_mlnx_ext_port_info_supported(ibnd_port_t * port)
 int mlnx_ext_port_info_err(smp_engine_t * engine, ibnd_smp_t * smp,
 			   uint8_t * mad, void *cb_data)
 {
-	ibnd_fabric_t *fabric = ((ibnd_scan_t *) engine->user_data)->fabric;
+	f_internal_t *f_int = ((ibnd_scan_t *) engine->user_data)->f_int;
 	ibnd_node_t *node = cb_data;
 	ibnd_port_t *port;
 	uint8_t port_num, local_port;
@@ -232,12 +232,12 @@ int mlnx_ext_port_info_err(smp_engine_t * engine, ibnd_smp_t * smp,
 	if (port_num && mad_get_field(port->info, 0, IB_PORT_PHYS_STATE_F)
 	    == IB_PORT_PHYS_STATE_LINKUP
 	    && ((node->type == IB_NODE_SWITCH && port_num != local_port) ||
-		(node == fabric->from_node && port_num == fabric->from_portnum))) {
+		(node == f_int->fabric.from_node && port_num == f_int->fabric.from_portnum))) {
 		int rc = 0;
 		ib_portid_t path = smp->path;
 
 		if (node->type != IB_NODE_SWITCH &&
-		    node == fabric->from_node &&
+		    node == f_int->fabric.from_node &&
 		    path.drpath.cnt > 1)
 			rc = retract_dpath(engine, &path);
 		else {
@@ -260,7 +260,7 @@ int mlnx_ext_port_info_err(smp_engine_t * engine, ibnd_smp_t * smp,
 static int recv_mlnx_ext_port_info(smp_engine_t * engine, ibnd_smp_t * smp,
 				   uint8_t * mad, void *cb_data)
 {
-	ibnd_fabric_t *fabric = ((ibnd_scan_t *) engine->user_data)->fabric;
+	f_internal_t *f_int = ((ibnd_scan_t *) engine->user_data)->f_int;
 	ibnd_node_t *node = cb_data;
 	ibnd_port_t *port;
 	uint8_t *ext_port_info = mad + IB_SMP_DATA_OFFS;
@@ -281,12 +281,12 @@ static int recv_mlnx_ext_port_info(smp_engine_t * engine, ibnd_smp_t * smp,
 	if (port_num && mad_get_field(port->info, 0, IB_PORT_PHYS_STATE_F)
 	    == IB_PORT_PHYS_STATE_LINKUP
 	    && ((node->type == IB_NODE_SWITCH && port_num != local_port) ||
-		(node == fabric->from_node && port_num == fabric->from_portnum))) {
+		(node == f_int->fabric.from_node && port_num == f_int->fabric.from_portnum))) {
 		int rc = 0;
 		ib_portid_t path = smp->path;
 
 		if (node->type != IB_NODE_SWITCH &&
-		    node == fabric->from_node &&
+		    node == f_int->fabric.from_node &&
 		    path.drpath.cnt > 1)
 			rc = retract_dpath(engine, &path);
 		else {
@@ -319,7 +319,7 @@ static int recv_port_info(smp_engine_t * engine, ibnd_smp_t * smp,
 			  uint8_t * mad, void *cb_data)
 {
 	ibnd_scan_t *scan = (ibnd_scan_t *)engine->user_data;
-	ibnd_fabric_t *fabric = scan->fabric;
+	f_internal_t *f_int = scan->f_int;
 	ibnd_node_t *node = cb_data;
 	ibnd_port_t *port;
 	uint8_t *port_info = mad + IB_SMP_DATA_OFFS;
@@ -359,7 +359,8 @@ static int recv_port_info(smp_engine_t * engine, ibnd_smp_t * smp,
 		port->lmc = node->smalmc;
 	}
 
-	add_to_portguid_hash(port, fabric->portstbl);
+	add_to_portguid_hash(port, f_int->fabric.portstbl);
+	add_to_portlid_hash(port, f_int->lid2guid);
 
 	if ((scan->cfg->flags & IBND_CONFIG_MLX_EPI)
 	    && is_mlnx_ext_port_info_supported(port)) {
@@ -389,13 +390,13 @@ static int recv_port_info(smp_engine_t * engine, ibnd_smp_t * smp,
 	if (port_num && mad_get_field(port->info, 0, IB_PORT_PHYS_STATE_F)
 	    == IB_PORT_PHYS_STATE_LINKUP
 	    && ((node->type == IB_NODE_SWITCH && port_num != local_port) ||
-		(node == fabric->from_node && port_num == fabric->from_portnum))) {
+		(node == f_int->fabric.from_node && port_num == f_int->fabric.from_portnum))) {
 
 		int rc = 0;
 		ib_portid_t path = smp->path;
 
 		if (node->type != IB_NODE_SWITCH &&
-		    node == fabric->from_node &&
+		    node == f_int->fabric.from_node &&
 		    path.drpath.cnt > 1)
 			rc = retract_dpath(engine, &path);
 		else {
@@ -441,7 +442,7 @@ static int query_port_info(smp_engine_t * engine, ib_portid_t * portid,
 static ibnd_node_t *create_node(smp_engine_t * engine, ib_portid_t * path,
 				uint8_t * node_info)
 {
-	ibnd_fabric_t *fabric = ((ibnd_scan_t *) engine->user_data)->fabric;
+	f_internal_t *f_int = ((ibnd_scan_t *) engine->user_data)->f_int;
 	ibnd_node_t *rc = calloc(1, sizeof(*rc));
 	if (!rc) {
 		IBND_ERROR("OOM: node creation failed\n");
@@ -463,13 +464,13 @@ static ibnd_node_t *create_node(smp_engine_t * engine, ib_portid_t * path,
 	rc->path_portid = *path;
 	memcpy(rc->info, node_info, sizeof(rc->info));
 
-	add_to_nodeguid_hash(rc, fabric->nodestbl);
+	add_to_nodeguid_hash(rc, f_int->fabric.nodestbl);
 
 	/* add this to the all nodes list */
-	rc->next = fabric->nodes;
-	fabric->nodes = rc;
+	rc->next = f_int->fabric.nodes;
+	f_int->fabric.nodes = rc;
 
-	add_to_type_list(rc, fabric);
+	add_to_type_list(rc, f_int);
 
 	return rc;
 }
@@ -505,7 +506,7 @@ static int recv_node_info(smp_engine_t * engine, ibnd_smp_t * smp,
 			  uint8_t * mad, void *cb_data)
 {
 	ibnd_scan_t *scan = engine->user_data;
-	ibnd_fabric_t *fabric = scan->fabric;
+	f_internal_t *f_int = scan->f_int;
 	uint8_t *node_info = mad + IB_SMP_DATA_OFFS;
 	struct ni_cbdata *ni_cbdata = (struct ni_cbdata *)cb_data;
 	ibnd_node_t *rem_node = NULL;
@@ -523,7 +524,7 @@ static int recv_node_info(smp_engine_t * engine, ibnd_smp_t * smp,
 		free(ni_cbdata);
 	}
 
-	node = ibnd_find_node_guid(fabric, node_guid);
+	node = ibnd_find_node_guid(&f_int->fabric, node_guid);
 	if (!node) {
 		node = create_node(engine, &smp->path, node_info);
 		if (!node)
@@ -550,8 +551,8 @@ static int recv_node_info(smp_engine_t * engine, ibnd_smp_t * smp,
 			     node, port);
 
 	if (rem_node == NULL) {	/* this is the start node */
-		fabric->from_node = node;
-		fabric->from_portnum = port_num;
+		f_int->fabric.from_node = node;
+		f_int->fabric.from_portnum = port_num;
 	} else {
 		/* link ports... */
 		if (!rem_node->ports[rem_port_num]) {
@@ -628,8 +629,35 @@ void add_to_portguid_hash(ibnd_port_t * port, ibnd_port_t * hash[])
 	hash[hash_idx] = port;
 }
 
-void add_to_type_list(ibnd_node_t * node, ibnd_fabric_t * fabric)
+void create_lid2guid(f_internal_t *f_int)
 {
+	f_int->lid2guid = g_hash_table_new_full(g_direct_hash, g_direct_equal,
+				NULL, NULL);
+}
+
+void destroy_lid2guid(f_internal_t *f_int)
+{
+	if (f_int->lid2guid) {
+		g_hash_table_destroy(f_int->lid2guid);
+	}
+}
+
+void add_to_portlid_hash(ibnd_port_t * port, GHashTable *htable)
+{
+	uint16_t base_lid = port->base_lid;
+	uint16_t lid_mask = ((1 << port->lmc) -1);
+	uint16_t lid = 0;
+
+	/* We add the port for all lids
+	 * so it is easier to find any "random" lid specified */
+	for (lid = base_lid; lid <= (base_lid + lid_mask); lid++) {
+		g_hash_table_insert(htable, GINT_TO_POINTER(lid), port);
+	}
+}
+
+void add_to_type_list(ibnd_node_t * node, f_internal_t * f_int)
+{
+	ibnd_fabric_t *fabric = &f_int->fabric;
 	switch (node->type) {
 	case IB_NODE_CA:
 		node->type_next = fabric->ch_adapters;
@@ -664,12 +692,21 @@ static int set_config(struct ibnd_config *config, struct ibnd_config *cfg)
 	return (0);
 }
 
+f_internal_t *allocate_fabric_internal(void)
+{
+	f_internal_t *f = calloc(1, sizeof(*f));
+	if (f)
+		create_lid2guid(f);
+
+	return (f);
+}
+
 ibnd_fabric_t *ibnd_discover_fabric(char * ca_name, int ca_port,
 				    ib_portid_t * from,
 				    struct ibnd_config *cfg)
 {
 	struct ibnd_config config = { 0 };
-	ibnd_fabric_t *fabric = NULL;
+	f_internal_t *f_int = NULL;
 	ib_portid_t my_portid = { 0 };
 	smp_engine_t engine;
 	ibnd_scan_t scan;
@@ -685,21 +722,19 @@ ibnd_fabric_t *ibnd_discover_fabric(char * ca_name, int ca_port,
 		return NULL;
 	}
 
-	fabric = calloc(1, sizeof(*fabric));
-	if (!fabric) {
+	f_int = allocate_fabric_internal();
+	if (!f_int) {
 		IBND_ERROR("OOM: failed to calloc ibnd_fabric_t\n");
 		return NULL;
 	}
 
-	memset(fabric, 0, sizeof(*fabric));
-
 	memset(&scan.selfportid, 0, sizeof(scan.selfportid));
-	scan.fabric = fabric;
+	scan.f_int = f_int;
 	scan.cfg = &config;
 	scan.initial_hops = from->drpath.cnt;
 
 	if (smp_engine_init(&engine, ca_name, ca_port, &scan, &config)) {
-		free(fabric);
+		free(f_int);
 		return (NULL);
 	}
 
@@ -719,19 +754,19 @@ ibnd_fabric_t *ibnd_discover_fabric(char * ca_name, int ca_port,
 		if (process_mads(&engine) != 0)
 			goto error;
 
-	fabric->total_mads_used = engine.total_smps;
-	fabric->maxhops_discovered += scan.initial_hops;
+	f_int->fabric.total_mads_used = engine.total_smps;
+	f_int->fabric.maxhops_discovered += scan.initial_hops;
 
-	if (group_nodes(fabric))
+	if (group_nodes(&f_int->fabric))
 		goto error;
 
 	smp_engine_destroy(&engine);
 	mad_rpc_close_port(scan.ibmad_port);
-	return fabric;
+	return (ibnd_fabric_t *)f_int;
 error:
 	smp_engine_destroy(&engine);
 	mad_rpc_close_port(scan.ibmad_port);
-	ibnd_destroy_fabric(fabric);
+	ibnd_destroy_fabric(&f_int->fabric);
 	return NULL;
 }
 
@@ -768,6 +803,7 @@ void ibnd_destroy_fabric(ibnd_fabric_t * fabric)
 		destroy_node(node);
 		node = next;
 	}
+	destroy_lid2guid((f_internal_t *)fabric);
 	free(fabric);
 }
 
@@ -825,6 +861,18 @@ void ibnd_iter_nodes_type(ibnd_fabric_t * fabric, ibnd_iter_node_func_t func,
 		func(cur, user_data);
 }
 
+ibnd_port_t *ibnd_find_port_lid(ibnd_fabric_t * fabric,
+				uint16_t lid)
+{
+	ibnd_port_t *port;
+	f_internal_t *f = (f_internal_t *)fabric;
+
+	port = (ibnd_port_t *)g_hash_table_lookup(f->lid2guid,
+					GINT_TO_POINTER(lid));
+
+	return port;
+}
+
 ibnd_port_t *ibnd_find_port_guid(ibnd_fabric_t * fabric, uint64_t guid)
 {
 	int hash = HASHGUID(guid) % HTSZ;
diff --git a/libibnetdisc/src/ibnetdisc_cache.c b/libibnetdisc/src/ibnetdisc_cache.c
index 2690373..d4663bf 100644
--- a/libibnetdisc/src/ibnetdisc_cache.c
+++ b/libibnetdisc/src/ibnetdisc_cache.c
@@ -127,7 +127,7 @@ typedef struct ibnd_port_cache {
 } ibnd_port_cache_t;
 
 typedef struct ibnd_fabric_cache {
-	ibnd_fabric_t *fabric;
+	f_internal_t *f_int;
 	uint64_t from_node_guid;
 	ibnd_node_cache_t *nodes_cache;
 	ibnd_port_cache_t *ports_cache;
@@ -250,7 +250,7 @@ static int _load_header_info(int fd, ibnd_fabric_cache_t * fabric_cache,
 
 	offset += _unmarshall64(buf + offset, &fabric_cache->from_node_guid);
 	offset += _unmarshall32(buf + offset, &tmp32);
-	fabric_cache->fabric->maxhops_discovered = tmp32;
+	fabric_cache->f_int->fabric.maxhops_discovered = tmp32;
 
 	return 0;
 }
@@ -515,7 +515,7 @@ static int _fill_port(ibnd_fabric_cache_t * fabric_cache, ibnd_node_t * node,
 	/* achu: needed if user wishes to re-cache a loaded fabric.
 	 * Otherwise, mostly unnecessary to do this.
 	 */
-	add_to_portguid_hash(port_cache->port, fabric_cache->fabric->portstbl);
+	add_to_portguid_hash(port_cache->port, fabric_cache->f_int->fabric.portstbl);
 	return 0;
 }
 
@@ -535,13 +535,13 @@ static int _rebuild_nodes(ibnd_fabric_cache_t * fabric_cache)
 
 		/* Insert node into appropriate data structures */
 
-		node->next = fabric_cache->fabric->nodes;
-		fabric_cache->fabric->nodes = node;
+		node->next = fabric_cache->f_int->fabric.nodes;
+		fabric_cache->f_int->fabric.nodes = node;
 
 		add_to_nodeguid_hash(node_cache->node,
-				     fabric_cache->fabric->nodestbl);
+				     fabric_cache->f_int->fabric.nodestbl);
 
-		add_to_type_list(node_cache->node, fabric_cache->fabric);
+		add_to_type_list(node_cache->node, fabric_cache->f_int);
 
 		node_cache->node_stored_to_fabric++;
 
@@ -601,6 +601,7 @@ static int _rebuild_ports(ibnd_fabric_cache_t * fabric_cache)
 		} else
 			port->remoteport = NULL;
 
+		add_to_portlid_hash(port, fabric_cache->f_int->lid2guid);
 		port_cache = port_cache_next;
 	}
 
@@ -612,7 +613,7 @@ ibnd_fabric_t *ibnd_load_fabric(const char *file, unsigned int flags)
 	unsigned int node_count = 0;
 	unsigned int port_count = 0;
 	ibnd_fabric_cache_t *fabric_cache = NULL;
-	ibnd_fabric_t *fabric = NULL;
+	f_internal_t *f_int = NULL;
 	ibnd_node_cache_t *node_cache = NULL;
 	int fd = -1;
 	unsigned int i;
@@ -635,14 +636,13 @@ ibnd_fabric_t *ibnd_load_fabric(const char *file, unsigned int flags)
 	}
 	memset(fabric_cache, '\0', sizeof(ibnd_fabric_cache_t));
 
-	fabric = (ibnd_fabric_t *) malloc(sizeof(ibnd_fabric_t));
-	if (!fabric) {
+	f_int = allocate_fabric_internal();
+	if (!f_int) {
 		IBND_DEBUG("OOM: fabric\n");
 		goto cleanup;
 	}
-	memset(fabric, '\0', sizeof(ibnd_fabric_t));
 
-	fabric_cache->fabric = fabric;
+	fabric_cache->f_int = f_int;
 
 	if (_load_header_info(fd, fabric_cache, &node_count, &port_count) < 0)
 		goto cleanup;
@@ -663,7 +663,7 @@ ibnd_fabric_t *ibnd_load_fabric(const char *file, unsigned int flags)
 		IBND_DEBUG("Cache invalid: cannot find from node\n");
 		goto cleanup;
 	}
-	fabric->from_node = node_cache->node;
+	f_int->fabric.from_node = node_cache->node;
 
 	if (_rebuild_nodes(fabric_cache) < 0)
 		goto cleanup;
@@ -671,15 +671,15 @@ ibnd_fabric_t *ibnd_load_fabric(const char *file, unsigned int flags)
 	if (_rebuild_ports(fabric_cache) < 0)
 		goto cleanup;
 
-	if (group_nodes(fabric))
+	if (group_nodes(&f_int->fabric))
 		goto cleanup;
 
 	_destroy_ibnd_fabric_cache(fabric_cache);
 	close(fd);
-	return fabric;
+	return (ibnd_fabric_t *)&f_int->fabric;
 
 cleanup:
-	ibnd_destroy_fabric(fabric);
+	ibnd_destroy_fabric((ibnd_fabric_t *)f_int);
 	_destroy_ibnd_fabric_cache(fabric_cache);
 	close(fd);
 	return NULL;
diff --git a/libibnetdisc/src/internal.h b/libibnetdisc/src/internal.h
index 80918c4..1ccd29c 100644
--- a/libibnetdisc/src/internal.h
+++ b/libibnetdisc/src/internal.h
@@ -40,6 +40,7 @@
 
 #include <infiniband/ibnetdisc.h>
 #include <complib/cl_qmap.h>
+#include <glib.h>
 
 #define	IBND_DEBUG(fmt, ...) \
 	if (ibdebug) { \
@@ -57,9 +58,18 @@
 #define DEFAULT_TIMEOUT 1000
 #define DEFAULT_RETRIES 3
 
+typedef struct f_internal {
+	ibnd_fabric_t fabric;
+	GHashTable *lid2guid;
+} f_internal_t;
+f_internal_t *allocate_fabric_internal(void);
+void create_lid2guid(f_internal_t *f_int);
+void destroy_lid2guid(f_internal_t *f_int);
+void add_to_portlid_hash(ibnd_port_t * port, GHashTable *htable);
+
 typedef struct ibnd_scan {
 	ib_portid_t selfportid;
-	ibnd_fabric_t *fabric;
+	f_internal_t *f_int;
 	struct ibnd_config *cfg;
 	struct ibmad_port *ibmad_port;
 	unsigned initial_hops;
@@ -100,8 +110,9 @@ void smp_engine_destroy(smp_engine_t * engine);
 void add_to_nodeguid_hash(ibnd_node_t * node, ibnd_node_t * hash[]);
 
 void add_to_portguid_hash(ibnd_port_t * port, ibnd_port_t * hash[]);
+void add_to_portlid_hash(ibnd_port_t * port, GHashTable *htable);
 
-void add_to_type_list(ibnd_node_t * node, ibnd_fabric_t * fabric);
+void add_to_type_list(ibnd_node_t * node, f_internal_t * fabric);
 
 void destroy_node(ibnd_node_t * node);
 
diff --git a/libibnetdisc/src/libibnetdisc.map b/libibnetdisc/src/libibnetdisc.map
index 1c42e7b..f1b7229 100644
--- a/libibnetdisc/src/libibnetdisc.map
+++ b/libibnetdisc/src/libibnetdisc.map
@@ -16,6 +16,7 @@ IBNETDISC_1.0 {
 		ibnd_iter_nodes_type;
 		ibnd_find_port_guid;
 		ibnd_find_port_dr;
+		ibnd_find_port_lid;
 		ibnd_iter_ports;
 	local: *;
 };
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
