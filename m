From: Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [infiniband-diags] [PATCH] [2/2] support --cache and --load-cache
	options in ibnetdiscover
Date: Wed, 09 Dec 2009 15:42:24 -0800
Message-ID: <1260402144.4557.68.camel@auk31.llnl.gov>
Reply-To: chu11-i2BcT+NCU+M@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-C5HPEWtG6Fq+iJYjO7bX"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-C5HPEWtG6Fq+iJYjO7bX
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Sasha,

This adds the --cache and --load-cache options to ibnetdiscover.
Al

-- 
Albert Chu
chu11-i2BcT+NCU+M@public.gmane.org
Computer Scientist
High Performance Systems Division
Lawrence Livermore National Laboratory

--=-C5HPEWtG6Fq+iJYjO7bX
Content-Disposition: attachment; filename=0002-support-cache-and-load-cache-options-in-ibnetdis.patch
Content-Type: text/plain; name=0002-support-cache-and-load-cache-options-in-ibnetdis.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Date: Wed, 9 Dec 2009 15:19:47 -0800
Subject: [PATCH] support --cache and --load-cache options in ibnetdiscover


Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 infiniband-diags/man/ibnetdiscover.8 |   12 +++++++++++-
 infiniband-diags/src/ibnetdiscover.c |   26 ++++++++++++++++++++++++--
 2 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/infiniband-diags/man/ibnetdiscover.8 b/infiniband-diags/man/ibnetdiscover.8
index abf3588..082a8e4 100644
--- a/infiniband-diags/man/ibnetdiscover.8
+++ b/infiniband-diags/man/ibnetdiscover.8
@@ -8,7 +8,8 @@ ibnetdiscover \- discover InfiniBand topology
 [\-d(ebug)] [\-e(rr_show)] [\-v(erbose)] [\-s(how)] [\-l(ist)]
 [\-g(rouping)] [\-H(ca_list)] [\-S(witch_list)] [\-R(outer_list)]
 [\-C ca_name] [\-P ca_port] [\-t(imeout) timeout_ms] [\-V(ersion)]
-[\--node-name-map <node-name-map>] [\-p(orts)] [\-m(ax_hops)]
+[\--node-name-map <node-name-map>] [\-\-cache <filename>]
+[\-\-load\-cache <filename>] [\-p(orts)] [\-m(ax_hops)]
 [\-h(elp)] [<topology-file>]
 
 .SH DESCRIPTION
@@ -47,6 +48,15 @@ Show progress information during discovery.
 Specify a node name map.  The node name map file maps GUIDs to more user
 friendly names.  See file format below.
 .TP
+\fB\-\-cache\fR <filename>
+Cache the ibnetdiscover network data in the specified filename.  This
+cache may be used by other tools for later analysis.
+.TP
+\fB\-\-load\-cache\fR <filename>
+Load and use the cached ibnetdiscover data stored in the specified
+filename.  May be useful for outputting and learning about other
+fabrics or a previous state of a fabric.
+.TP
 \fB\-p\fR, \fB\-\-ports\fR
 Obtain a ports report which is a
 list of connected ports with relevant information (like LID, portnum,
diff --git a/infiniband-diags/src/ibnetdiscover.c b/infiniband-diags/src/ibnetdiscover.c
index e081a36..e87f42e 100644
--- a/infiniband-diags/src/ibnetdiscover.c
+++ b/infiniband-diags/src/ibnetdiscover.c
@@ -63,6 +63,8 @@ static FILE *f;
 
 static char *node_name_map_file = NULL;
 static nn_map_t *node_name_map = NULL;
+static char *cache_file = NULL;
+static char *load_cache_file = NULL;
 
 static int report_max_hops = 0;
 
@@ -616,6 +618,12 @@ static int process_opt(void *context, int ch, char *optarg)
 	case 1:
 		node_name_map_file = strdup(optarg);
 		break;
+	case 2:
+		cache_file = strdup(optarg);
+		break;
+	case 3:
+		load_cache_file = strdup(optarg);
+		break;
 	case 's':
 		ibnd_show_progress(1);
 		break;
@@ -662,6 +670,8 @@ int main(int argc, char **argv)
 		{"Switch_list", 'S', 0, NULL, "list of connected switches"},
 		{"Router_list", 'R', 0, NULL, "list of connected routers"},
 		{"node-name-map", 1, 1, "<file>", "node name map file"},
+		{"cache", 2, 1, "<file>", "filename to cache ibnetdiscover data to"},
+		{"load-cache", 3, 1, "<file>", "filename of ibnetdiscover cache to load"},
 		{"ports", 'p', 0, NULL, "obtain a ports report"},
 		{"max_hops", 'm', 0, NULL,
 		 "report max hops discovered by the library"},
@@ -692,8 +702,14 @@ int main(int argc, char **argv)
 
 	node_name_map = open_node_name_map(node_name_map_file);
 
-	if ((fabric = ibnd_discover_fabric(ibmad_port, NULL, -1)) == NULL)
-		IBERROR("discover failed\n");
+	if (load_cache_file) {
+		if ((fabric = ibnd_load_fabric(load_cache_file, 0)) == NULL)
+			IBERROR("loading cached fabric failed\n");
+	}
+	else {
+		if ((fabric = ibnd_discover_fabric(ibmad_port, NULL, -1)) == NULL)
+			IBERROR("discover failed\n");
+	}
 
 	if (ports_report)
 		ibnd_iter_nodes(fabric, dump_ports_report, NULL);
@@ -702,6 +718,12 @@ int main(int argc, char **argv)
 	else
 		dump_topology(group, fabric);
 
+	if (cache_file)
+		if (ibnd_cache_fabric(fabric,
+				      cache_file,
+				      0) < 0)
+			IBERROR("caching ibnetdiscover data failed\n");
+
 	ibnd_destroy_fabric(fabric);
 	close_node_name_map(node_name_map);
 	mad_rpc_close_port(ibmad_port);
-- 
1.5.4.5


--=-C5HPEWtG6Fq+iJYjO7bX--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
