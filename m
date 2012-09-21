From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 1/4 for opensm] Add command-line option --pidfile
Date: Fri, 21 Sep 2012 16:42:04 +0200
Message-ID: <505C7CBC.3050803@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This option is necessary to control opensm from an LSB-compliant
init script.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
---
 man/opensm.8.in |    5 +++++
 opensm/main.c   |   26 ++++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/man/opensm.8.in b/man/opensm.8.in
index 4e61c2e..37e2eee 100644
--- a/man/opensm.8.in
+++ b/man/opensm.8.in
@@ -52,6 +52,7 @@ opensm \- InfiniBand subnet manager and administration (SM/SA)
 [\-\-cckey <key>]
 [\-y | \-\-stay_on_fatal]
 [\-B | \-\-daemon]
+[\-J | \-\-pidfile <file_name>]
 [\-I | \-\-inactive]
 [\-\-perfmgr]
 [\-\-perfmgr_sweep_time_s <seconds>]
@@ -403,6 +404,10 @@ By default, the SM will exit on these errors.
 \fB\-B\fR, \fB\-\-daemon\fR
 Run in daemon mode - OpenSM will run in the background.
 .TP
+\fB\-J\fR, \fB\-\-pidfile <file_name>\fR
+Makes the SM write its own PID to the specified file when started in daemon
+mode.
+.TP
 \fB\-I\fR, \fB\-\-inactive\fR
 Start SM in inactive rather than init SM state.  This
 option can be used in conjunction with the perfmgr so as to
diff --git a/opensm/main.c b/opensm/main.c
index e9a0b4c..1a061a8 100644
--- a/opensm/main.c
+++ b/opensm/main.c
@@ -68,6 +68,7 @@ volatile unsigned int osm_exit_flag = 0;
 
 static volatile unsigned int osm_hup_flag = 0;
 static volatile unsigned int osm_usr1_flag = 0;
+static char *pidfile;
 
 #define MAX_LOCAL_IBPORTS 64
 #define INVALID_GUID (0xFFFFFFFFFFFFFFFFULL)
@@ -498,10 +499,17 @@ static ib_net64_t get_port_guid(IN osm_opensm_t * p_osm, uint64_t port_guid)
 	return attr_array[choice].port_guid;
 }
 
+static void remove_pidfile(void)
+{
+	if (pidfile)
+		unlink(pidfile);
+}
+
 static int daemonize(osm_opensm_t * osm)
 {
 	pid_t pid;
 	int fd;
+	FILE *f;
 
 	fd = open("/dev/null", O_WRONLY);
 	if (fd < 0) {
@@ -523,6 +531,18 @@ static int daemonize(osm_opensm_t * osm)
 	} else if (pid > 0)
 		exit(0);
 
+	if (pidfile) {
+		remove_pidfile();
+		f = fopen(pidfile, "w");
+		if (f) {
+			fprintf(f, "%d\n", getpid());
+			fclose(f);
+		} else {
+			perror("fopen");
+			exit(1);
+		}
+	}
+
 	close(0);
 	close(1);
 	close(2);
@@ -649,6 +669,7 @@ int main(int argc, char *argv[])
 		{"console-port", 1, NULL, 'C'},
 #endif
 		{"daemon", 0, NULL, 'B'},
+		{"pidfile", 1, NULL, 'J'},
 		{"inactive", 0, NULL, 'I'},
 #ifdef ENABLE_OSM_PERF_MGR
 		{"perfmgr", 0, NULL, 1},
@@ -887,6 +908,10 @@ int main(int argc, char *argv[])
 			printf(" Creating new log file\n");
 			break;
 
+		case 'J':
+			pidfile = optarg;
+			break;
+
 		case 'P':
 			SET_STR_OPT(opt.partition_config_file, optarg);
 			break;
@@ -1212,6 +1237,7 @@ int main(int argc, char *argv[])
 Exit:
 	osm_opensm_destroy(&osm);
 	complib_exit();
+	remove_pidfile();
 
 	exit(0);
 }
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
