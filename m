From: Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [infiniband-diags] [UPDATED PATCH] [3/3] support --load-cache in
	iblinkinfo and ibqueryerrors
Date: Fri, 15 Jan 2010 10:23:19 -0800
Message-ID: <1263579799.15172.168.camel@auk31.llnl.gov>
Reply-To: chu11-i2BcT+NCU+M@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-hS7/3er4mw+eJLOaKC56"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-hS7/3er4mw+eJLOaKC56
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Sasha,

This adds the --load-cache options to iblinkinfo and ibqueryerrors.

Al

-- 
Albert Chu
chu11-i2BcT+NCU+M@public.gmane.org
Computer Scientist
High Performance Systems Division
Lawrence Livermore National Laboratory

--=-hS7/3er4mw+eJLOaKC56
Content-Disposition: attachment; filename=0003-support-load-cache-in-iblinkinfo-and-ibqueryerrors.patch
Content-Type: text/plain; name=0003-support-load-cache-in-iblinkinfo-and-ibqueryerrors.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Date: Thu, 10 Dec 2009 11:22:50 -0800
Subject: [PATCH] support --load-cache in iblinkinfo and ibqueryerrors


Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 infiniband-diags/man/iblinkinfo.8    |   11 ++++++-
 infiniband-diags/man/ibqueryerrors.8 |   10 ++++++-
 infiniband-diags/src/iblinkinfo.c    |   52 +++++++++++++++++++++++++-------
 infiniband-diags/src/ibqueryerrors.c |   53 ++++++++++++++++++++++++++-------
 4 files changed, 99 insertions(+), 27 deletions(-)

diff --git a/infiniband-diags/man/iblinkinfo.8 b/infiniband-diags/man/iblinkinfo.8
index 0f53b00..f184edf 100644
--- a/infiniband-diags/man/iblinkinfo.8
+++ b/infiniband-diags/man/iblinkinfo.8
@@ -6,7 +6,7 @@ iblinkinfo \- report link info for all links in the fabric
 .SH SYNOPSIS
 .B iblinkinfo
    [-hcdl -C <ca_name> -P <ca_port> -v <lt,hoq,vlstall> -S <guid>
--D <direct_route>]
+-D <direct_route> \-\-load\-cache <filename>]
 
 .SH DESCRIPTION
 .PP
@@ -42,7 +42,14 @@ Print port capabilities (enabled and supported values)
 \fB\-P <ca_port>\fR    use the specified ca_port for the search.
 .TP
 \fB\-R\fR (This option is obsolete and does nothing)
-
+.TP
+\fB\-\-load\-cache\fR <filename>
+Load and use the cached ibnetdiscover data stored in the specified
+filename.  May be useful for outputting and learning about other
+fabrics or a previous state of a fabric.  Cannot be used if user
+specifies a directo route path.  See
+.B ibnetdiscover
+for information on caching ibnetdiscover output.
 
 .SH AUTHOR
 .TP
diff --git a/infiniband-diags/man/ibqueryerrors.8 b/infiniband-diags/man/ibqueryerrors.8
index 83a2b5a..56a0d67 100644
--- a/infiniband-diags/man/ibqueryerrors.8
+++ b/infiniband-diags/man/ibqueryerrors.8
@@ -6,7 +6,7 @@ ibqueryerrors \- query and report non-zero IB port counters
 .SH SYNOPSIS
 .B ibqueryerrors
 [-s <err1,err2,...> -c -r -C <ca_name> -P <ca_port> -G <node_guid>
--D <direct_route> -d -k -K]
+-D <direct_route> -d -k -K \-\-load\-cache <filename>]
 
 .SH DESCRIPTION
 .PP
@@ -60,6 +60,14 @@ specified the data counters will be cleared without any printed output.
 .TP
 \fB\-\-details\fR include transmit discard details
 .TP
+\fB\-\-load\-cache\fR <filename>
+Load and use the cached ibnetdiscover data stored in the specified
+filename.  May be useful for outputting and learning about other
+fabrics or a previous state of a fabric.  Cannot be used if user
+specifies a directo route path.  See
+.B ibnetdiscover
+for information on caching ibnetdiscover output.
+.TP
 \fB\-R\fR  (This option is obsolete and does nothing)
 
 .SH COMMON OPTIONS
diff --git a/infiniband-diags/src/iblinkinfo.c b/infiniband-diags/src/iblinkinfo.c
index 21b31bb..10e3ad5 100644
--- a/infiniband-diags/src/iblinkinfo.c
+++ b/infiniband-diags/src/iblinkinfo.c
@@ -55,6 +55,7 @@
 
 static char *node_name_map_file = NULL;
 static nn_map_t *node_name_map = NULL;
+static char *load_cache_file = NULL;
 
 static uint64_t guid = 0;
 static char *guid_str = NULL;
@@ -230,6 +231,9 @@ static int process_opt(void *context, int ch, char *optarg)
 	case 1:
 		node_name_map_file = strdup(optarg);
 		break;
+	case 2:
+		load_cache_file = strdup(optarg);
+		break;
 	case 'S':
 		guid_str = optarg;
 		guid = (uint64_t) strtoull(guid_str, 0, 0);
@@ -291,6 +295,7 @@ int main(int argc, char **argv)
 		 "print additional switch settings (PktLifeTime, HoqLife, VLStallCount)"},
 		{"portguids", 'g', 0, NULL,
 		 "print port guids instead of node guids"},
+		{"load-cache", 2, 1, "<file>", "filename of ibnetdiscover cache to load"},
 		{"GNDN", 'R', 0, NULL,
 		 "(This option is obsolete and does nothing)"},
 		{0}
@@ -317,6 +322,11 @@ int main(int argc, char **argv)
 		mad_rpc_set_timeout(ibmad_port, ibd_timeout);
 
 	node_name_map = open_node_name_map(node_name_map_file);
+	
+	if (dr_path && load_cache_file) {
+		fprintf(stderr, "Cannot specify cache and direct route path\n");
+		exit(1);
+	}
 
 	if (dr_path) {
 		/* only scan part of the fabric */
@@ -334,19 +344,37 @@ int main(int argc, char **argv)
 			       guid_str);
 	}
 
-	if (resolved >= 0)
-		if ((fabric = ibnd_discover_fabric(ibmad_port, &port_id,
-						   hops)) == NULL)
-			IBWARN
-			    ("Single node discover failed; attempting full scan\n");
-
-	if (!fabric)
-		if ((fabric =
-		     ibnd_discover_fabric(ibmad_port, NULL, -1)) == NULL) {
-			fprintf(stderr, "discover failed\n");
-			rc = 1;
-			goto close_port;
+	if (resolved >= 0) {
+		if (load_cache_file) {
+			if ((fabric = ibnd_load_fabric(load_cache_file, 0)) == NULL) {
+				fprintf(stderr, "loading cached fabric failed\n");
+				exit(1);
+			}
+		}
+		else {
+			if ((fabric = ibnd_discover_fabric(ibmad_port, &port_id,
+							   hops)) == NULL)
+				IBWARN
+				    ("Single node discover failed; attempting full scan\n");
+		}
+	}
+
+	if (!fabric) {
+		if (load_cache_file) {
+			if ((fabric = ibnd_load_fabric(load_cache_file, 0)) == NULL) {
+				fprintf(stderr, "loading cached fabric failed\n");
+				exit(1);
+			}
 		}
+		else {
+			if ((fabric =
+		     		ibnd_discover_fabric(ibmad_port, NULL, -1)) == NULL) {
+					fprintf(stderr, "discover failed\n");
+					rc = 1;
+					goto close_port;
+			}
+		}
+	}
 
 	if (!all && guid_str) {
 		ibnd_node_t *sw = ibnd_find_node_guid(fabric, guid);
diff --git a/infiniband-diags/src/ibqueryerrors.c b/infiniband-diags/src/ibqueryerrors.c
index 47bd2af..3ed0ed1 100644
--- a/infiniband-diags/src/ibqueryerrors.c
+++ b/infiniband-diags/src/ibqueryerrors.c
@@ -58,6 +58,8 @@
 struct ibmad_port *ibmad_port;
 static char *node_name_map_file = NULL;
 static nn_map_t *node_name_map = NULL;
+static char *load_cache_file = NULL;
+
 int data_counters = 0;
 int port_config = 0;
 uint64_t node_guid = 0;
@@ -481,6 +483,9 @@ static int process_opt(void *context, int ch, char *optarg)
 	case 6:
 		details = 1;
 		break;
+	case 7:
+		load_cache_file = strdup(optarg);
+		break;
 	case 'G':
 	case 'S':
 		node_guid_str = optarg;
@@ -542,6 +547,7 @@ int main(int argc, char **argv)
 		 "Clear error counters after read"},
 		{"clear-counts", 'K', 0, NULL,
 		 "Clear data counters after read"},
+		{"load-cache", 7, 1, "<file>", "filename of ibnetdiscover cache to load"},
 		{0}
 	};
 	char usage_args[] = "";
@@ -568,6 +574,11 @@ int main(int argc, char **argv)
 
 	node_name_map = open_node_name_map(node_name_map_file);
 
+	if (dr_path && load_cache_file) {
+		fprintf(stderr, "Cannot specify cache and direct route path\n");
+		exit(1);
+	}
+
 	/* limit the scan the fabric around the target */
 	if (dr_path) {
 		if ((resolved =
@@ -584,19 +595,37 @@ int main(int argc, char **argv)
 			       node_guid_str);
 	}
 
-	if (resolved >= 0)
-		if ((fabric = ibnd_discover_fabric(ibmad_port, &portid,
-						   0)) == NULL)
-			IBWARN
-			    ("Single node discover failed; attempting full scan");
-
-	if (!fabric)		/* do a full scan */
-		if ((fabric =
-		     ibnd_discover_fabric(ibmad_port, NULL, -1)) == NULL) {
-			fprintf(stderr, "discover failed\n");
-			rc = 1;
-			goto close_port;
+	if (resolved >= 0) {
+		if (load_cache_file) {
+			if ((fabric = ibnd_load_fabric(load_cache_file, 0)) == NULL) {
+				fprintf(stderr, "loading cached fabric failed\n");
+				exit(1);
+			}
+		}
+		else {
+			if ((fabric = ibnd_discover_fabric(ibmad_port, &portid,
+							   0)) == NULL)
+				IBWARN
+				    ("Single node discover failed; attempting full scan");
 		}
+	}
+
+	if (!fabric) {		/* do a full scan */
+		if (load_cache_file) {
+			if ((fabric = ibnd_load_fabric(load_cache_file, 0)) == NULL) {
+				fprintf(stderr, "loading cached fabric failed\n");
+				exit(1);
+			}
+		}
+		else {
+			if ((fabric =
+			     ibnd_discover_fabric(ibmad_port, NULL, -1)) == NULL) {
+				fprintf(stderr, "discover failed\n");
+				rc = 1;
+				goto close_port;
+			}
+		}
+	}
 
 	report_suppressed();
 
-- 
1.5.4.5


--=-hS7/3er4mw+eJLOaKC56--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
