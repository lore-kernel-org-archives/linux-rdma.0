From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm: Add support for PID file
Date: Wed, 13 Jul 2011 11:26:40 +0300
Message-ID: <20110713082640.GA2024@localhost.localdomain>
References: <20110710120442.GA11284@localhost.localdomain>
 <20110712162740.29e2d7d1.weiny2@llnl.gov>
 <20110712235222.GG10216@obsidianresearch.com>
 <20110712165817.16076a3d.weiny2@llnl.gov>
 <20110713041441.GA26663@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110713041441.GA26663-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Aleksey Senin <alekseys-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 22:14 Tue 12 Jul     , Jason Gunthorpe wrote:
> On Tue, Jul 12, 2011 at 04:58:17PM -0700, Ira Weiny wrote:
> 
> > > The usual way to do this is to have the daemon drop a pidfile to the
> > > location set by its --pidfile argument after it forks, but before the
> > > command returns.
> > 
> > You mean like Alex's patch did?  I have not seen this done before.
> > I checked out apache's httpd command and I don't see it doing this.
> 
> I didn't look closely..
> 
> At least sshd, ntpd, acpid, and dbus are working that way on my ubuntu
> system.. Some commands write a default pidfile automaticaly rather
> than doing nothing, but upstart and systemd eliminate the need
> for a pid file at all, so I prefer to see a no write option.

I based on sshd/ntpd approach when doing this. But now I agree with Jason.
We should have this as a backward compatibility support for SysV and it should
be off by default, unless you are running with --daemon, which is designed for
SysV. I'm not familiar with upstart, but systemd doesn't need the double fork
stuff within main.c: daemonize().

Bellow is a revised patch.

When OpenSM executed as daemon, opensm.pid created by default
in /var/run and contains PID of the last executed instance of OpenSM.
opensm.pid is used by opensm.init stop, to kill only the last
executed instance of OpenSM.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
Changes since ver1:
-create pid file only when executed as daemon
---
 configure.in                |   25 +++++++++++++++++++++++++
 include/opensm/osm_base.h   |   18 ++++++++++++++++++
 include/opensm/osm_subnet.h |    1 +
 man/opensm.8.in             |    5 +++++
 opensm/main.c               |   18 ++++++++++++++++++
 opensm/osm_subnet.c         |    2 ++
 scripts/opensm.init.in      |    5 ++++-
 7 files changed, 73 insertions(+), 1 deletions(-)

diff --git a/configure.in b/configure.in
index 7c5eb65..c6f5d53 100644
--- a/configure.in
+++ b/configure.in
@@ -231,6 +231,31 @@ dnl Checks for headers and libraries
 OPENIB_APP_OSMV_CHECK_HEADER
 OPENIB_APP_OSMV_CHECK_LIB
 
+dnl Where to place opensm.pid
+piddir=/var/run
+dnl make sure the directory exists
+if test ! -d $piddir ; then
+	piddir=`eval echo ${sysconfdir}`
+	case $piddir in
+		NONE/*) piddir=`echo $piddir | sed "s~NONE~$ac_default_prefix~"` ;;
+	esac
+fi
+
+AC_ARG_WITH(pid-dir,
+	[  --with-pid-dir=<dir>    define the dir of opensm.pid file (default is /var/run)],
+	[
+		if test -n "$withval"  &&  test "x$withval" != "xno"  &&  \
+		    test "x${withval}" != "xyes"; then
+			piddir=$withval
+			if test ! -d $piddir ; then
+			AC_MSG_WARN([** no $piddir directory on this system **])
+			fi
+		fi
+	]
+)
+AC_DEFINE_UNQUOTED(OPENSM_PID_DIR, "$piddir", [Specify location of opensm.pid])
+AC_SUBST(piddir)
+
 AC_CONFIG_FILES([man/opensm.8 man/torus-2QoS.8 man/torus-2QoS.conf.5 scripts/opensm.init scripts/redhat-opensm.init scripts/sldd.sh])
 
 dnl Create the following Makefiles
diff --git a/include/opensm/osm_base.h b/include/opensm/osm_base.h
index c1a52b5..13bfbb0 100644
--- a/include/opensm/osm_base.h
+++ b/include/opensm/osm_base.h
@@ -318,6 +318,24 @@ BEGIN_C_DECLS
 #endif
 /***********/
 
+/****d* OpenSM: Base/OSM_DEFAULT_PID_FILE
+* NAME
+*	OSM_DEFAULT_PID_FILE
+*
+* DESCRIPTION
+*	Specifies the default pid file name
+*
+* SYNOPSIS
+*/
+#if defined(HAVE_DEFAULT_PID_FILE)
+#define OSM_DEFAULT_PID_FILE HAVE_DEFAULT_PID_FILE
+#elif defined(OPENSM_PID_DIR)
+#define OSM_DEFAULT_PID_FILE OPENSM_PID_DIR "/opensm.pid"
+#else
+#define OSM_DEFAULT_PID_FILE "/var/run/opensm.pid"
+#endif
+/***********/
+
 /****d* OpenSM: Base/OSM_DEFAULT_SWEEP_INTERVAL_SECS
 * NAME
 *	OSM_DEFAULT_SWEEP_INTERVAL_SECS
diff --git a/include/opensm/osm_subnet.h b/include/opensm/osm_subnet.h
index 6d17c31..9bbbd2f 100644
--- a/include/opensm/osm_subnet.h
+++ b/include/opensm/osm_subnet.h
@@ -208,6 +208,7 @@ typedef struct osm_subn_opt {
 	char *sa_db_file;
 	boolean_t sa_db_dump;
 	char *torus_conf_file;
+	char *pid_file;
 	boolean_t do_mesh_analysis;
 	boolean_t exit_on_fatal;
 	boolean_t honor_guid2lid_file;
diff --git a/man/opensm.8.in b/man/opensm.8.in
index f360739..76096c0 100644
--- a/man/opensm.8.in
+++ b/man/opensm.8.in
@@ -55,6 +55,7 @@ opensm \- InfiniBand subnet manager and administration (SM/SA)
 [\-\-consolidate_ipv6_snm_req]
 [\-\-log_prefix <prefix text>]
 [\-\-torus_config <path to file>]
+[\-\-pid_file <path to file>]
 [\-v(erbose)] [\-V] [\-D <flags>] [\-d(ebug) <number>]
 [\-h(elp)] [\-?]
 
@@ -407,6 +408,10 @@ This option defines the file name for the extra configuration
 information needed for the torus-2QoS routing engine.   The default
 name is \fB\%@OPENSM_CONFIG_DIR@/@TORUS2QOS_CONF_FILE@\fP
 .TP
+\fB\-\-pid_file\fR <path to pid file>
+Specifies the file that contains the process ID of the opensm daemon.
+The default is \fB/var/run/opensm.pid\fP
+.TP
 \fB\-v\fR, \fB\-\-verbose\fR
 This option increases the log verbosity level.
 The -v option may be specified multiple times
diff --git a/opensm/main.c b/opensm/main.c
index 798cb20..7aedcd5 100644
--- a/opensm/main.c
+++ b/opensm/main.c
@@ -347,6 +347,9 @@ static void show_usage(void)
 	printf("--consolidate_ipv6_snm_req\n"
 	       "          Use shared MLID for IPv6 Solicited Node Multicast groups\n"
 	       "          per MGID scope and P_Key.\n\n");
+	printf("--pid_file <path to file>\n"
+	       "          Specifies the file that contains the process ID of the\n"
+	       "          opensm daemon.The default is /var/run/opensm.pid\n");
 	printf("--log_prefix <prefix text>\n"
 	       "          Prefix to syslog messages from OpenSM.\n\n");
 	printf("--verbose, -v\n"
@@ -638,6 +641,7 @@ int main(int argc, char *argv[])
 		{"retries", 1, NULL, 8},
 		{"log_prefix", 1, NULL, 9},
 		{"torus_config", 1, NULL, 10},
+		{"pid_file", 1, NULL, 15},
 		{NULL, 0, NULL, 0}	/* Required at the end of the array */
 	};
 
@@ -1047,6 +1051,9 @@ int main(int argc, char *argv[])
 			SET_STR_OPT(opt.torus_conf_file, optarg);
 			printf("Torus-2QoS config file = %s\n", opt.torus_conf_file);
 			break;
+		case 15:
+			SET_STR_OPT(opt.pid_file, optarg);
+			break;
 		case 'h':
 		case '?':
 		case ':':
@@ -1116,6 +1123,16 @@ int main(int argc, char *argv[])
 
 	setup_signals();
 
+	if (opt.daemon) {
+		FILE *f = fopen(opt.pid_file, "w");
+		if (f == NULL)
+			printf("Couldn't create pid file \"%s\"\n", opt.pid_file);
+		else {
+			fprintf(f, "%ld\n", (long) getpid());
+			fclose(f);
+		}
+	}
+
 	osm_opensm_sweep(&osm);
 
 	if (run_once_flag == TRUE) {
@@ -1147,6 +1164,7 @@ int main(int argc, char *argv[])
 	}
 
 Exit:
+	unlink(opt.pid_file);
 	osm_opensm_destroy(&osm);
 	complib_exit();
 
diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index 0b79d3a..3de622e 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -404,6 +404,7 @@ static const opt_rec_t opt_tbl[] = {
 	{ "no_clients_rereg", OPT_OFFSET(no_clients_rereg), opts_parse_boolean, NULL, 1 },
 	{ "prefix_routes_file", OPT_OFFSET(prefix_routes_file), opts_parse_charp, NULL, 0 },
 	{ "consolidate_ipv6_snm_req", OPT_OFFSET(consolidate_ipv6_snm_req), opts_parse_boolean, NULL, 1 },
+	{ "pid_file", OPT_OFFSET(pid_file), opts_parse_charp, NULL, 0},
 	{ "lash_start_vl", OPT_OFFSET(lash_start_vl), opts_parse_uint8, NULL, 1 },
 	{ "sm_sl", OPT_OFFSET(sm_sl), opts_parse_uint8, NULL, 1 },
 	{ "log_prefix", OPT_OFFSET(log_prefix), opts_parse_charp, NULL, 1 },
@@ -791,6 +792,7 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
 	p_opt->no_clients_rereg = FALSE;
 	p_opt->prefix_routes_file = strdup(OSM_DEFAULT_PREFIX_ROUTES_FILE);
 	p_opt->consolidate_ipv6_snm_req = FALSE;
+	p_opt->pid_file = strdup(OSM_DEFAULT_PID_FILE);
 	p_opt->lash_start_vl = 0;
 	p_opt->sm_sl = OSM_DEFAULT_SL;
 	p_opt->log_prefix = NULL;
diff --git a/scripts/opensm.init.in b/scripts/opensm.init.in
index 0c84bd3..f8bbfb1 100644
--- a/scripts/opensm.init.in
+++ b/scripts/opensm.init.in
@@ -42,6 +42,9 @@
 
 prefix=@prefix@
 exec_prefix=@exec_prefix@
+piddir=@piddir@
+
+PIDFILE=${piddir}/opensm.pid
 
 # Source function library.
 if [[ -s /etc/init.d/functions ]]; then
@@ -74,7 +77,7 @@ start () {
 
 stop () {
     echo -n "Shutting down opensm: "
-    killproc opensm
+    killproc -p $PIDFILE opensm
     if [[ $RETVAL -eq 0 ]]; then
         rm -f /var/lock/subsys/opensm
         success
-- 
1.7.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
