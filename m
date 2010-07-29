From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/3] ibacm: move default location of log file
Date: Thu, 29 Jul 2010 11:08:53 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A9272635@orsmsx501.amr.corp.intel.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A9272612@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A9272612-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Make /var/log the default location of the acm log file.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 acm_opts.cfg |    8 +++-----
 src/acm.c    |    3 ---
 src/acme.c   |    8 +++-----
 3 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/acm_opts.cfg b/acm_opts.cfg
index 95ac15a..3dbb0c6 100644
--- a/acm_opts.cfg
+++ b/acm_opts.cfg
@@ -9,15 +9,13 @@
 # log_file:
 # Specifies the location of the ACM service output.  The log file is used to
 # assist with ACM service debugging and troubleshooting.  The log_file can
-# be set to 'stdout', 'stderr', or the base name of a file.  If a file name
-# is specified, the actual name formed by appending a process ID and '.log'
-# extension to the end of the specified file name.
+# be set to 'stdout', 'stderr', or the name of a file.
 # Examples:
 # log_file stdout
 # log_file stderr
-# log_file /tmp/acm_
+# log_file /var/log/ibacm.log
 
-log_file acm_
+log_file /var/log/ibacm.log
 
 # log_level:
 # Indicates the amount of detailed data written to the log file.  Log levels
diff --git a/src/acm.c b/src/acm.c
index 535a755..7c8b84b 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -2598,7 +2598,6 @@ static void acm_log_options(void)
 static FILE *acm_open_log(void)
 {
 	FILE *f;
-	int n;
 
 	if (!stricmp(log_file, "stdout"))
 		return stdout;
@@ -2606,8 +2605,6 @@ static FILE *acm_open_log(void)
 	if (!stricmp(log_file, "stderr"))
 		return stderr;
 
-	n = strlen(log_file);
-	sprintf(&log_file[n], "%05u.log", getpid());
 	if (!(f = fopen(log_file, "w")))
 		f = stdout;
 
diff --git a/src/acme.c b/src/acme.c
index 03e96ad..7428a57 100644
--- a/src/acme.c
+++ b/src/acme.c
@@ -85,15 +85,13 @@ static void gen_opts_temp(FILE *f)
 	fprintf(f, "# log_file:\n");
 	fprintf(f, "# Specifies the location of the ACM service output.  The log file is used to\n");
 	fprintf(f, "# assist with ACM service debugging and troubleshooting.  The log_file can\n");
-	fprintf(f, "# be set to 'stdout', 'stderr', or the base name of a file.  If a file name\n");
-	fprintf(f, "# is specified, the actual name formed by appending a process ID and '.log'\n");
-	fprintf(f, "# extension to the end of the specified file name.\n");
+	fprintf(f, "# be set to 'stdout', 'stderr', or the name of a file.\n");
 	fprintf(f, "# Examples:\n");
 	fprintf(f, "# log_file stdout\n");
 	fprintf(f, "# log_file stderr\n");
-	fprintf(f, "# log_file /tmp/acm_\n");
+	fprintf(f, "# log_file /var/log/ibacm.log\n");
 	fprintf(f, "\n");
-	fprintf(f, "log_file acm_\n");
+	fprintf(f, "log_file /var/log/ibacm.log\n");
 	fprintf(f, "\n");
 	fprintf(f, "# log_level:\n");
 	fprintf(f, "# Indicates the amount of detailed data written to the log file.  Log levels\n");


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
