From: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v2 1/4] rsockets: fine grained interception mechanism for
 rsocket preloading
Date: Fri, 05 Sep 2014 18:38:10 +0530
Message-ID: <bcb66f862cc014a6305816cb8dd45deb@imap.linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 From: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

     By default the R-Sockets pre-loading library intercepts all the 
stream
     and datagram sockets belonging to a launched program processes and 
threads.

     However, distributed application and database servers may require 
fine
     grained interception to ensure that only the processes which are 
listening
     for remote connections on the RDMA transport need to be enabled with 
RDMA
     while remaining can continue to use TCP as before.  This allows 
proper
     communication happening between various server components locally.

     A configuration file based mechanism is introduced to facilitate 
this
     fine grained interception mechanism.  As part of preload 
initialization,
     the configuration file is scanned and an in-memory record store is 
created
     with all the entries found.  When a request is made to intercept a 
socket,
     its attributes are cross checked with stored records to see whether 
we
     should proceed with rsocket switch over.

     Note: Right now, the fine grained interception mechanism is enabled 
only
           for newly created sockets.  Going forward, this can be extened 
to
           select connections based on the specified host/IP addresses 
and
           ports as well.

     "preload_config" is the name of the configuration file which should 
exist
     in the default configuration location (usually the full path to this
     configuration file is: 
<install-root>/etc/rdma/rsocket/preload_config)
     of an installed rsocket library.

     The sample format for this configuration file is shown below:

     @#
     @# Sample config file for preloading in a program specific way
     @#
     @# Each line entry should have the following format:
     @#
     @#   prog_name <space> dom_spec <space> type_spec <space> proto_spec
     @#
     @# where,
     @#
     @# prog_name  - program or command name (string without spaces)
     @# dom_spec   - one or more socket domain strings separated by 
commas
     @#            - format: {*|domain,[,domain,...]}
     @#            - '*' means any valid domain
     @#            - valid domains: inet/inet6/ib
     @# type_spec  - one or more socket type strings separated by commas
     @#            - format: {*|type[,type,...]}
     @#            - '*' means any valid type
     @#            - valid types: stream/dgram
     @# proto_spec - one or more socket protocol strings separated by 
commas
     @#            - format: {*|protocol[,protocol,...]}
     @#            - '*' means any valid protocol
     @#            - valid protocols: tcp/udp
     @# <space>    - one ore more tab or space characters
     @#
     @# Note:
     @#  Lines beginning with '#' character are treated as comments.
     @#  Comments at the end of an entry are allowed and should be 
preceded
     @#  by '#' character.
     @#  Blank lines are ignored.
     @
     @progA inet stream tcp # intercept progA's internet stream sockets
     @progB inet6 dgram udp # intercept progB's ipv6 datagram sockets
     @progC * * * # intercept progC's sockets

     Signed-off-by: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
     Reviewed-by: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
     ---

diff --git a/src/preload.c b/src/preload.c
index fb2149b..7330a38 100644
--- a/src/preload.c
+++ b/src/preload.c
@@ -50,6 +50,8 @@
  #include <netinet/tcp.h>
  #include <unistd.h>
  #include <semaphore.h>
+#include <ctype.h>
+#include <stdlib.h>

  #include <rdma/rdma_cma.h>
  #include <rdma/rdma_verbs.h>
@@ -122,6 +124,210 @@ struct fd_info {
  	atomic_t refcnt;
  };

+typedef struct {
+	char *name;
+	uint32_t domain;
+	uint32_t type;
+	uint32_t protocol;
+} config_entry_t;
+
+static config_entry_t *entryp;
+static int16_t nentries;
+static int16_t config_avail;
+extern char *program_invocation_short_name;
+
+/* scan preload configuration file and create
+ * in-memory config store
+ * should be called only once under lock
+ */
+static int scan_preload_config(void)
+{
+	FILE *fp;
+	char line[512];
+	char *lp, *cp, *str1, *str2;
+	char *token, *subtoken, *saveptr1, *saveptr2;
+	int i, j, ret = 0;
+
+	fp = fopen(RS_CONF_DIR "/preload_config", "r");
+	if (fp == NULL) {
+		return -1;
+	}
+
+	while ((lp = fgets(line, sizeof(line), fp)) != NULL) {
+
+		/* trim white space at the beginning of each line */
+		while (*lp != '\0') {
+			if (isspace(*lp)) {
+				lp++;
+				continue;
+			} else {
+				break;
+			}
+		}
+
+		/* skip comment and blank lines */
+		if (*lp == '\0' || *lp == '#') {
+			continue;
+		}
+
+		/* trim comments and newlines at the end of each line */
+		if ((cp = strpbrk(lp, "#\n")) != NULL) {
+			*cp = '\0';
+		}
+
+		/* now allocate memory for new configuration entry */
+		entryp = (config_entry_t *) realloc(entryp, (nentries + 1) * 
sizeof(config_entry_t));
+		if (!entryp) {
+			ret = -1;
+			goto scan_done;
+		}
+		memset(entryp + nentries, '\0', sizeof(config_entry_t));
+
+		/* tokenize the retrieved line and parse individual fields */
+		for (i = 1, str1 = lp; ; i++, str1 = NULL) {
+			token = strtok_r(str1, " \t", &saveptr1);
+			if (token == NULL) {
+				break;
+			}
+
+			/* first field should contain program name */
+			if (i == 1) {
+				entryp[nentries].name = (char *) malloc((strlen(token) + 1));
+				if (!entryp[nentries].name) {
+					ret = -1;
+					goto scan_done;
+				}
+				memcpy(entryp[nentries].name, token, strlen(token) + 1);
+				continue;
+			}
+
+			/* second field onwards can contain multiple entries separate by 
comma */
+			for (j = 1, str2 = token; ; j++, str2 = NULL) {
+				subtoken = strtok_r(str2, ",", &saveptr2);
+				if (subtoken == NULL) {
+					break;
+				}
+
+				/* second field is socket domain
+				 * rsocket currently recognizes only AF_INET, AF_INET6 and AF_IB 
domains
+				 * '*' implies all the valid domains
+				 */
+				if (i == 2) {
+					if (*subtoken == '*') {
+						entryp[nentries].domain |= (1 << AF_INET);
+						entryp[nentries].domain |= (1 << AF_INET6);
+						entryp[nentries].domain |= (1 << AF_IB);
+						break;
+					} else if (strcmp(subtoken, "inet6") == 0) {
+						entryp[nentries].domain |= (1 << AF_INET6);
+					} else if (strcmp(subtoken, "inet") == 0) {
+						entryp[nentries].domain |= (1 << AF_INET);
+					} else if (strcmp(subtoken, "ib") == 0) {
+						entryp[nentries].domain |= (1 << AF_IB);
+					}
+					continue;
+				}
+
+				/* third field is socket type
+				 * rsocket currently recognizes only SOCK_STREAM and SOCK_DGRAM 
types
+				 * '*' implies all the valid types
+				 */
+				if (i == 3) {
+					if (*subtoken == '*') {
+						entryp[nentries].type |= (1 << SOCK_STREAM);
+						entryp[nentries].type |= (1 << SOCK_DGRAM);
+						break;
+					} else if (strcmp(subtoken, "stream") == 0) {
+						entryp[nentries].type |= (1 << SOCK_STREAM);
+					} else if (strcmp(subtoken, "dgram") == 0) {
+						entryp[nentries].type |= (1 << SOCK_DGRAM);
+					}
+					continue;
+				}
+
+				/* fourth field is socket protocol
+				 * rsocket currently recgonizes only IPPROTO_TCP and IPPROTO_UDP 
protocols
+				 * '*' implies all the valid protocols
+				 */
+				if (i == 4) {
+					if (*subtoken == '*') {
+						entryp[nentries].protocol |= (1 << IPPROTO_TCP);
+						entryp[nentries].protocol |= (1 << IPPROTO_UDP);
+						break;
+					} else if (strcmp(subtoken, "tcp") == 0) {
+						entryp[nentries].protocol |= (1 << IPPROTO_TCP);
+					} else if (strcmp(subtoken, "udp") == 0) {
+						entryp[nentries].protocol |= (1 << IPPROTO_UDP);
+					}
+					continue;
+				}
+			}
+		}
+		nentries += 1;
+	}
+
+scan_done:
+	fclose(fp);
+	return ret;
+}
+
+/* free in-memory config store
+ * should be called only once during finalization
+ */
+static void free_preload_config(void)
+{
+	int i;
+
+	if (entryp) {
+		for (i = 0; i < nentries; i++) {
+			if (entryp[i].name) {
+				free(entryp[i].name);
+			}
+		}
+		free(entryp);
+	}
+
+	return;
+}
+
+/* check whether interception is required for this socket
+ * compares the provided attributes with that available in the 
in-memory
+ * data store for the current process
+ * sets-up in-memory config store if it's already not done
+ */
+static int intercept_socket(int domain, int type, int protocol)
+{
+	int i;
+
+	/* locate the config entry */
+	for (i = 0; i < nentries; i++) {
+		if (strncmp(entryp[i].name, program_invocation_short_name, 
strlen(entryp[i].name)) == 0) {
+			break;
+		}
+	}
+	if (i == nentries) {
+		return 0;
+	}
+
+	/* match domain field */
+	if (!(entryp[i].domain & (1 << domain))) {
+		return 0;
+	}
+
+	/* match type field */
+	if (!(entryp[i].type & (1 << type))) {
+		return 0;
+	}
+
+	/* match protocol field only if protocol is specified */
+	if (protocol && !(entryp[i].protocol & (1 << protocol))) {
+		return 0;
+	}
+
+	/* entry matched */
+	return 1;
+}
+
  static int fd_open(void)
  {
  	struct fd_info *fdi;
@@ -308,6 +514,14 @@ static void init_preload(void)
  	rs.fcntl = dlsym(RTLD_DEFAULT, "rfcntl");

  	getenv_options();
+
+	if (scan_preload_config() == 0) {
+		config_avail = 1;
+	}
+	if (entryp) {
+		atexit(free_preload_config);
+	}
+
  	init = 1;
  out:
  	pthread_mutex_unlock(&mut);
@@ -404,10 +618,15 @@ int socket(int domain, int type, int protocol)
  	static __thread int recursive;
  	int index, ret;

+	init_preload();
+
+	if (config_avail && intercept_socket(domain, type, protocol) == 0) {
+		goto real;
+	}
+
  	if (recursive)
  		goto real;

-	init_preload();
  	index = fd_open();
  	if (index < 0)
  		return index;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
