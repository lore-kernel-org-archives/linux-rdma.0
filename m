From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v5 1/4] rsockets: fine grained interception mechanism
 for rsocket preloading
Date: Thu, 25 Sep 2014 22:59:06 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237399DE3905@ORSMSX109.amr.corp.intel.com>
References: <87f9777bcbfe4f5daa8bd9b78d74ac9f@imap.linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87f9777bcbfe4f5daa8bd9b78d74ac9f-FJGp5E75HVmZamtmwQBW5tBPR1lH4CV8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org" <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

By default the R-Sockets pre-loading library intercepts all
the stream and datagram sockets belonging to a launched
program processes and threads.

However, distributed application and database servers may
require fine grained interception to ensure that only the
processes which are listening for remote connections on the
RDMA transport need to be enabled with RDMA while remaining
can continue to use TCP as before.  This allows proper
communication happening between various server components locally.

A configuration file based mechanism is introduced to facilitate
this fine grained interception mechanism.  As part of preload
initialization, the configuration file is scanned and an
in-memory record store is created with all the entries found.
When a request is made to intercept a socket, its attributes
are cross checked with stored records to see whether we
should proceed with rsocket switch over.

Note: Right now, the fine grained interception mechanism is
enabled only for newly created sockets.  Going forward,
this can be extened to select connections based on the
specified host/IP addresses and ports as well.

"preload_config" is the name of the configuration file which
should exist in the default configuration location
(usually the full path to this configuration file is:
<install-root>/etc/rdma/rsocket/preload_config)
of an installed rsocket library.

The sample format for this configuration file is shown below:

# Sample config file for preloading in a program specific way
#
# Each line entry should have the following format:
#
#   program domain type protocol
#
# where,
#
# program    - program or command name (string without spaces)
# domain     - the socket domain: AF_INET / AF_INET6 / AF_IB
# type       - the socket type: SOCK_STREAM / SOCK_DGRAM
# protocol   - the socket protocol: IPPROTO_TCP / IPPROTO_UDP
#
# The wildcard value of '*' is supported for any
#
# Note:
#  Lines beginning with '#' character are treated as comments.

Signed-off-by: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Reviewed-by: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
I made several adjustments to the submitted patch.  Please
verify that these work for you.  Changes from v5:

- Simplified input file format slightly.
- Removed typedef
- Rename entryp and removed unneeded variable
- Replaced token parsing with sscanf
- Added wildcard support for the program name
- Wildcard values now stored as 0
- Enhanced checks for domain, type, and protocol strings
- Fixed realloc error handling
- Simplified free_config implementation
- Added support for app passing in 0 for protocol

 src/preload.c |  138 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 136 insertions(+), 2 deletions(-)

diff --git a/src/preload.c b/src/preload.c
index fb2149b..05ac48f 100644
--- a/src/preload.c
+++ b/src/preload.c
@@ -50,6 +50,9 @@
 #include <netinet/tcp.h>
 #include <unistd.h>
 #include <semaphore.h>
+#include <ctype.h>
+#include <stdlib.h>
+#include <stdio.h>
 
 #include <rdma/rdma_cma.h>
 #include <rdma/rdma_verbs.h>
@@ -122,6 +125,135 @@ struct fd_info {
 	atomic_t refcnt;
 };
 
+struct config_entry {
+	char *name;
+	int domain;
+	int type;
+	int protocol;
+};
+
+static struct config_entry *config;
+static int config_cnt;
+extern char *program_invocation_short_name;
+
+
+static void free_config(void)
+{
+	while (config_cnt)
+		free(config[--config_cnt].name);
+
+	free(config);
+}
+
+/*
+ * Config file format:
+ * # Starting '#' indicates comment
+ * # wild card values are supported using '*'
+ * # domain - *, INET, INET6, IB
+ * # type - *, STREAM, DGRAM
+ * # protocol - *, TCP, UDP
+ * program_name domain type protocol
+ */
+static void scan_config(void)
+{
+	struct config_entry *new_config;
+	FILE *fp;
+	char line[120], prog[64], dom[16], type[16], proto[16];
+
+	fp = fopen(RS_CONF_DIR "/preload_config", "r");
+	if (!fp)
+		return;
+
+	while (fgets(line, sizeof(line), fp)) {
+		if (line[0] == '#')
+			continue;
+
+		if (sscanf(line, "%64s%16s%16s%16s", prog, dom, type, proto) != 4)
+			continue;
+
+		new_config = realloc(config, (config_cnt + 1) *
+					     sizeof(struct config_entry));
+		if (!new_config)
+			break;
+
+		config = new_config;
+		memset(&config[config_cnt], 0, sizeof(struct config_entry));
+
+		if (!strcasecmp(dom, "INET") ||
+		    !strcasecmp(dom, "AF_INET") ||
+		    !strcasecmp(dom, "PF_INET")) {
+			config[config_cnt].domain = AF_INET;
+		} else if (!strcasecmp(dom, "INET6") ||
+			   !strcasecmp(dom, "AF_INET6") ||
+			   !strcasecmp(dom, "PF_INET6")) {
+			config[config_cnt].domain = AF_INET6;
+		} else if (!strcasecmp(dom, "IB") ||
+			   !strcasecmp(dom, "AF_IB") ||
+			   !strcasecmp(dom, "PF_IB")) {
+			config[config_cnt].domain = AF_IB;
+		} else if (strcmp(dom, "*")) {
+			continue;
+		}
+
+		if (!strcasecmp(type, "STREAM") ||
+		    !strcasecmp(type, "SOCK_STREAM")) {
+			config[config_cnt].type = SOCK_STREAM;
+		} else if (!strcasecmp(type, "DGRAM") ||
+			   !strcasecmp(type, "SOCK_DGRAM")) {
+			config[config_cnt].type = SOCK_DGRAM;
+		} else if (strcmp(type, "*")) {
+			continue;
+		}
+
+		if (!strcasecmp(proto, "TCP") ||
+		    !strcasecmp(proto, "IPPROTO_TCP")) {
+			config[config_cnt].protocol = IPPROTO_TCP;
+		} else if (!strcasecmp(proto, "UDP") ||
+			   !strcasecmp(proto, "IPPROTO_UDP")) {
+			config[config_cnt].protocol = IPPROTO_UDP;
+		} else if (strcmp(proto, "*")) {
+			continue;
+		}
+
+		if (strcmp(prog, "*")) {
+		    if (!(config[config_cnt].name = strdup(prog)))
+			    continue;
+		}
+
+		config_cnt++;
+	}
+
+	fclose(fp);
+	if (config_cnt)
+		atexit(free_config);
+}
+
+static int intercept_socket(int domain, int type, int protocol)
+{
+	int i;
+
+	if (!config_cnt)
+		return 1;
+
+	if (!protocol) {
+		if (type == SOCK_STREAM)
+			protocol = IPPROTO_TCP;
+		else if (type == SOCK_DGRAM)
+			protocol = IPPROTO_UDP;
+	}
+
+	for (i = 0; i < config_cnt; i++) {
+		if ((!config[i].name ||
+		     !strcasecmp(config[i].name, program_invocation_short_name)) &&
+		    (!config[i].domain || config[i].domain == domain) &&
+		    (!config[i].type || config[i].type == type) &&
+		    (!config[i].protocol || config[i].protocol == protocol))
+			return 1;
+	}
+
+	return 0;
+}
+
 static int fd_open(void)
 {
 	struct fd_info *fdi;
@@ -308,6 +440,7 @@ static void init_preload(void)
 	rs.fcntl = dlsym(RTLD_DEFAULT, "rfcntl");
 
 	getenv_options();
+	scan_config();
 	init = 1;
 out:
 	pthread_mutex_unlock(&mut);
@@ -404,10 +537,11 @@ int socket(int domain, int type, int protocol)
 	static __thread int recursive;
 	int index, ret;
 
-	if (recursive)
+	init_preload();
+
+	if (recursive || !intercept_socket(domain, type, protocol))
 		goto real;
 
-	init_preload();
 	index = fd_open();
 	if (index < 0)
 		return index;


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
