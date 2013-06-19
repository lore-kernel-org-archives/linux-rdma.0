From: "Venkat R. Patnala" <patnala1-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH ibsim] Parse and use portguid from input, rather than inferring it.
Date: Wed, 19 Jun 2013 11:50:53 -0700
Message-ID: <1371667853-120634-1-git-send-email-patnala1@llnl.gov>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "Venkat R. Patnala" <patnala1-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Ibsim seems to assume that the portguid is nodeguid + portnum. This is
observed to be true for Mellanox CAs, however not necessarily for other
vendors. This is an issue when trying to simulate fabrics when guid inputs
are used (i.e. opensm ftree routing cn/io guid files).

ibsim/sim_net.c: Parse and set portguid when parsing non-switch ports.
ibsim/sim_mad.c: Use portguid instead of constructing it with nodeguid and
portnum.

Signed-off-by: Venkat R. Patnala <patnala1-i2BcT+NCU+M@public.gmane.org>
---
 ibsim/sim_mad.c |    4 ++--
 ibsim/sim_net.c |   15 +++++++++++++++
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/ibsim/sim_mad.c b/ibsim/sim_mad.c
index 223d507..e73d0bd 100644
--- a/ibsim/sim_mad.c
+++ b/ibsim/sim_mad.c
@@ -266,7 +266,7 @@ static int do_nodeinfo(Port * port, unsigned op, uint32_t mod, uint8_t * data)
 {
 	Node *node = port->node;
 	int status = 0;
-	uint64_t portguid = node->nodeguid + port->portnum;
+	uint64_t portguid = port->portguid;
 
 	if (op != IB_MAD_METHOD_GET)
 		status = ERR_METHOD_UNSUPPORTED;
@@ -406,7 +406,7 @@ static int do_guidinfo(Port * port, unsigned op, uint32_t mod, uint8_t * data)
 {
 	Node *node = port->node;
 	int status = 0;
-	uint64_t portguid = node->nodeguid + port->portnum;
+	uint64_t portguid = port->portguid;
 
 	if (op != IB_MAD_METHOD_GET)    // only get currently supported (non compliant)
 		status = ERR_METHOD_UNSUPPORTED;
diff --git a/ibsim/sim_net.c b/ibsim/sim_net.c
index 13c3b8c..ba20a75 100644
--- a/ibsim/sim_net.c
+++ b/ibsim/sim_net.c
@@ -355,6 +355,18 @@ static int parse_node_ports(char *buf)
 	return strtoul(buf, 0, 0);
 }
 
+static char *parse_port_guid(char *buf, char **rest_buf)
+{
+	char *s, *e = 0;
+	
+	if (!(s = strchr(buf, '(')) || !(e = strchr(s + 1, ')')))
+		return 0;
+	*e = 0;
+	if (rest_buf)
+		*rest_buf = e + 1;
+	return s + 1;
+}
+
 static char *parse_node_id(char *buf, char **rest_buf)
 {
 	char *s, *e = 0;
@@ -635,6 +647,9 @@ static int parse_port(char *line, Node * node, int type, int maxports)
 		return -1;
 	}
 
+	if (type != SWITCH_NODE && (s = parse_port_guid(line, &line)))
+ 		port->portguid = strtoull(s, 0, 16);
+
 	if (!(s = parse_node_id(line, NULL))) {
 		IBWARN("invalid remote nodeid: <%s>", line);
 		return -1;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
