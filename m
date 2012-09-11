From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 5/6] opensm: Add command-line option --pidfile
Date: Tue, 11 Sep 2012 16:20:25 +0200
Message-ID: <504F48A9.3030802@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This option is necessary to control opensm from an LSB-compliant
init script.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
---
 opensm/main.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

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
1.7.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
