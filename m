From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/4] ibacm: Add lock to prevent multiple daemons from running
Date: Wed, 8 Dec 2010 12:39:13 -0800
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B8C1ECAB@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Use a lock file to prevent multiple daemons from running
simultaneously.

Without this lock, a second instance of ib_acm eventually
fails to bind to the server's TCP port and exits, but not
before it overwrites a portion of the log file. 

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 acm_opts.cfg |    6 ++++++
 src/acm.c    |   27 +++++++++++++++++++++++++++
 src/acme.c   |    6 ++++++
 3 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/acm_opts.cfg b/acm_opts.cfg
index 372cd7b..7147fe2 100644
--- a/acm_opts.cfg
+++ b/acm_opts.cfg
@@ -26,6 +26,12 @@ log_file /var/log/ibacm.log
 
 log_level 0
 
+# lock_file:
+# Specifies the location of the ACM lock file used to ensure that only a
+# single instance of ACM is running.
+
+lock_file /var/lock/ibacm.pid
+
 # addr_prot:
 # Default resolution protocol to resolve IP addresses into IB GIDs.
 # Supported protocols are:
diff --git a/src/acm.c b/src/acm.c
index 3152392..bc7124f 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -36,8 +36,10 @@
 #include <string.h>
 #include <osd.h>
 #include <arpa/inet.h>
+#include <sys/types.h>
 #include <sys/stat.h>
 #include <sys/time.h>
+#include <fcntl.h>
 #include <infiniband/acm.h>
 #include <infiniband/umad.h>
 #include <infiniband/verbs.h>
@@ -208,6 +210,7 @@ static char *opts_file = "/etc/ibacm/acm_opts.cfg";
 static char *addr_file = "/etc/ibacm/acm_addr.cfg";
 static char log_file[128] = "stdout";
 static int log_level = 0;
+static char lock_file[128] = "/var/lock/ibacm.pid";
 static enum acm_addr_prot addr_prot = ACM_ADDR_PROT_ACM;
 static enum acm_route_prot route_prot = ACM_ROUTE_PROT_ACM;
 static enum acm_loopback_prot loopback_prot = ACM_LOOPBACK_PROT_LOCAL;
@@ -2654,6 +2657,8 @@ static void acm_set_options(void)
 			strcpy(log_file, value);
 		else if (!stricmp("log_level", opt))
 			log_level = atoi(value);
+		else if (!stricmp("lock_file", opt))
+			strcpy(lock_file, value);
 		else if (!stricmp("addr_prot", opt))
 			addr_prot = acm_convert_addr_prot(value);
 		else if (!stricmp("route_prot", opt))
@@ -2686,6 +2691,7 @@ static void acm_set_options(void)
 static void acm_log_options(void)
 {
 	acm_log(0, "log level %d\n", log_level);
+	acm_log(0, "lock file %s\n", lock_file);
 	acm_log(0, "address resolution %d\n", addr_prot);
 	acm_log(0, "route resolution %d\n", route_prot);
 	acm_log(0, "loopback resolution %d\n", loopback_prot);
@@ -2716,6 +2722,25 @@ static FILE *acm_open_log(void)
 	return f;
 }
 
+static int acm_open_lock_file(void)
+{
+	int lock_fd;
+	char pid[16];
+
+	lock_fd = open(lock_file, O_RDWR | O_CREAT, 0640);
+	if (lock_fd < 0)
+		return lock_fd;
+
+	if (lockf(lock_fd, F_TLOCK, 0)) {
+		close(lock_fd);
+		return -1;
+	}
+
+	sprintf(pid, "%d\n", getpid());
+	write(lock_fd, pid, strlen(pid));
+	return 0;
+}
+
 static void daemonize(void)
 {
 	pid_t pid, sid;
@@ -2778,6 +2803,8 @@ int CDECL_FUNC main(int argc, char **argv)
 		return -1;
 
 	acm_set_options();
+	if (acm_open_lock_file())
+		return -1;
 
 	lock_init(&log_lock);
 	flog = acm_open_log();
diff --git a/src/acme.c b/src/acme.c
index 218dbe8..552f42a 100644
--- a/src/acme.c
+++ b/src/acme.c
@@ -106,6 +106,12 @@ static void gen_opts_temp(FILE *f)
 	fprintf(f, "\n");
 	fprintf(f, "log_level 0\n");
 	fprintf(f, "\n");
+	fprintf(f, "# lock_file:\n");
+	fprintf(f, "# Specifies the location of the ACM lock file used to ensure that only a\n");
+	fprintf(f, "# single instance of ACM is running.\n");
+	fprintf(f, "\n");
+	fprintf(f, "lock_file /var/lock/ibacm.pid\n");
+	fprintf(f, "\n");
 	fprintf(f, "# addr_prot:\n");
 	fprintf(f, "# Default resolution protocol to resolve IP addresses into IB GIDs.\n");
 	fprintf(f, "# Supported protocols are:\n");


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
