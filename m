From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] opensm: Add better error output when parsing node name maps
Date: Fri, 09 Nov 2012 13:55:24 -0800
Message-ID: <1352498124.25353.139.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Presently, any error in opening a node name map file leads
to a generic:

"WARNING failed to open node name map"

error.  This patch adds better error output when the issue
is specifically parsing errors in the file.  The user
will get:

"WARNING failed to parse node name map"

and an output of the line with the particular issue.

Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 complib/cl_nodenamemap.c |   55 ++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 48 insertions(+), 7 deletions(-)

diff --git a/complib/cl_nodenamemap.c b/complib/cl_nodenamemap.c
index a99d46d..f47ad40 100644
--- a/complib/cl_nodenamemap.c
+++ b/complib/cl_nodenamemap.c
@@ -43,8 +43,18 @@
 #include <unistd.h>
 #include <ctype.h>
 #include <config.h>
+#include <errno.h>
 
 #include <complib/cl_nodenamemap.h>
+#include <complib/cl_math.h>
+
+#define PARSE_NODE_MAP_BUFLEN  256
+
+static int parse_node_map_wrap(const char *file_name,
+			       int (*create)(void *, uint64_t, char *),
+			       void *cxt,
+			       char *linebuf,
+			       unsigned int linebuflen);
 
 static int map_name(void *cxt, uint64_t guid, char *p)
 {
@@ -67,6 +77,7 @@ static int map_name(void *cxt, uint64_t guid, char *p)
 nn_map_t *open_node_name_map(char *node_name_map)
 {
 	nn_map_t *map;
+	char linebuf[PARSE_NODE_MAP_BUFLEN + 1];
 
 	if (!node_name_map) {
 #ifdef HAVE_DEFAULT_NODENAME_MAP
@@ -84,10 +95,23 @@ nn_map_t *open_node_name_map(char *node_name_map)
 		return NULL;
 	cl_qmap_init(map);
 
-	if (parse_node_map(node_name_map, map_name, map)) {
-		fprintf(stderr,
-			"WARNING failed to open node name map \"%s\" (%s)\n",
-			node_name_map, strerror(errno));
+	memset(linebuf, '\0', PARSE_NODE_MAP_BUFLEN + 1);
+	if (parse_node_map_wrap(node_name_map, map_name, map,
+				linebuf, PARSE_NODE_MAP_BUFLEN)) {
+		if (errno == EIO) {
+			fprintf(stderr,
+				"WARNING failed to parse node name map "
+				"\"%s\"\n",
+				node_name_map);
+			fprintf(stderr,
+				"WARNING failed line: \"%s\"\n",
+				linebuf);
+		}
+		else
+			fprintf(stderr,
+				"WARNING failed to open node name map "
+				"\"%s\" (%s)\n",
+				node_name_map, strerror(errno));
 		close_node_name_map(map);
 		return NULL;
 	}
@@ -144,10 +168,13 @@ char *clean_nodedesc(char *nodedesc)
 	return (nodedesc);
 }
 
-int parse_node_map(const char *file_name,
-		   int (*create) (void *, uint64_t, char *), void *cxt)
+static int parse_node_map_wrap(const char *file_name,
+			       int (*create) (void *, uint64_t, char *),
+			       void *cxt,
+			       char *linebuf,
+			       unsigned int linebuflen)
 {
-	char line[256];
+	char line[PARSE_NODE_MAP_BUFLEN];
 	FILE *f;
 
 	if (!(f = fopen(file_name, "r")))
@@ -166,6 +193,14 @@ int parse_node_map(const char *file_name,
 		guid = strtoull(p, &e, 0);
 		if (e == p || (!isspace(*e) && *e != '#' && *e != '\0')) {
 			fclose(f);
+			errno = EIO;
+			if (linebuf) {
+				memcpy(linebuf, line,
+				       MIN(PARSE_NODE_MAP_BUFLEN, linebuflen));
+				e = strpbrk(linebuf, "\n");
+				if (e)
+					*e = '\0';
+			}
 			return -1;
 		}
 
@@ -186,3 +221,9 @@ int parse_node_map(const char *file_name,
 	fclose(f);
 	return 0;
 }
+
+int parse_node_map(const char *file_name,
+		   int (*create) (void *, uint64_t, char *), void *cxt)
+{
+	return parse_node_map_wrap(file_name, create, cxt, NULL, 0);
+}
-- 
1.7.1



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
