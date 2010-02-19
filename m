From: Arthur Kepner <akepner-sJ/iWh9BUns@public.gmane.org>
Subject: [PATCH/RFC] opensm: toggle sweeping
Date: Thu, 18 Feb 2010 17:31:07 -0800
Message-ID: <20100219013107.GD20950@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Dale Talcott <Dale.R.Talcott-NSQ8wuThN14@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


One of our customers recently merged some new systems into a 
large, existing cluster. They requested a mechanism to prevent 
opensm from sweeping while the new equipment was being added to 
the IB fabric, and then resume sweeping once they felt confident 
that the newly added (sub)fabric was correctly cabled, and fully 
functional. They used the following patch. 

Would it be worth adding this (or something with similar functionality)  
to opensm?

Signed-off-by: Dale Talcott <Dale.R.Talcott-NSQ8wuThN14@public.gmane.org>
Signed-off-by: Arthur Kepner <akepner-sJ/iWh9BUns@public.gmane.org>

--- 

 main.c          |   16 ++++++++++++++++
 osm_state_mgr.c |    9 ++++++++-
 osm_trap_rcv.c  |   36 ++++++++++++++++++++++--------------
 3 files changed, 46 insertions(+), 15 deletions(-)

diff --git a/opensm/opensm/main.c b/opensm/opensm/main.c
index f9a33af..ee29d22 100644
--- a/opensm/opensm/main.c
+++ b/opensm/opensm/main.c
@@ -86,6 +86,12 @@ static void mark_usr1_flag(int signum)
 	osm_usr1_flag = 1;
 }
 
+int sweeping = 1;
+static void toggle_sweeping(int signum)
+{
+	sweeping = !sweeping;
+}
+
 static sigset_t saved_sigset;
 
 static void block_signals()
@@ -99,6 +105,7 @@ static void block_signals()
 #ifndef HAVE_OLD_LINUX_THREADS
 	sigaddset(&set, SIGUSR1);
 #endif
+	sigaddset(&set, SIGUSR2);
 	pthread_sigmask(SIG_SETMASK, &set, &saved_sigset);
 }
 
@@ -118,6 +125,8 @@ static void setup_signals()
 	act.sa_handler = mark_usr1_flag;
 	sigaction(SIGUSR1, &act, NULL);
 #endif
+	act.sa_handler = toggle_sweeping;
+	sigaction(SIGUSR2, &act, NULL);
 	pthread_sigmask(SIG_SETMASK, &saved_sigset, NULL);
 }
 
@@ -494,6 +503,7 @@ static int daemonize(osm_opensm_t * osm)
 int osm_manager_loop(osm_subn_opt_t * p_opt, osm_opensm_t * p_osm)
 {
 	int console_init_flag = 0;
+	int prev_sweeping = sweeping;
 
 	if (is_console_enabled(p_opt)) {
 		if (!osm_console_init(p_opt, &p_osm->console, &p_osm->log))
@@ -520,6 +530,12 @@ int osm_manager_loop(osm_subn_opt_t * p_opt, osm_opensm_t * p_osm)
 			p_osm->subn.force_heavy_sweep = TRUE;
 			osm_opensm_sweep(p_osm);
 		}
+		if (prev_sweeping != sweeping) {
+			prev_sweeping = sweeping;
+			OSM_LOG(&p_osm->log, OSM_LOG_INFO,
+				"Sweeping is now %s\n",
+				 	(sweeping ? "enabled" : "disabled") );
+		}
 	}
 	if (is_console_enabled(p_opt))
 		osm_console_exit(&p_osm->console, &p_osm->log);
diff --git a/opensm/opensm/osm_state_mgr.c b/opensm/opensm/osm_state_mgr.c
index e43463f..e8eb47b 100644
--- a/opensm/opensm/osm_state_mgr.c
+++ b/opensm/opensm/osm_state_mgr.c
@@ -1405,6 +1405,7 @@ static void do_process_mgrp_queue(osm_sm_t * sm)
 
 void osm_state_mgr_process(IN osm_sm_t * sm, IN osm_signal_t signal)
 {
+	extern int sweeping;
 	CL_ASSERT(sm);
 
 	OSM_LOG_ENTER(sm->p_log);
@@ -1415,7 +1416,13 @@ void osm_state_mgr_process(IN osm_sm_t * sm, IN osm_signal_t signal)
 
 	switch (signal) {
 	case OSM_SIGNAL_SWEEP:
-		do_sweep(sm);
+		if (!sweeping)
+			OSM_LOG(sm->p_log, OSM_LOG_DEBUG, "sweeping disabled - "
+				"ignoring signal %s in state %s\n",
+				osm_get_sm_signal_str(signal),
+				osm_get_sm_mgr_state_str(sm->p_subn->sm_state));
+		else
+			do_sweep(sm);
 		break;
 	case OSM_SIGNAL_IDLE_TIME_PROCESS_REQUEST:
 		do_process_mgrp_queue(sm);
diff --git a/opensm/opensm/osm_trap_rcv.c b/opensm/opensm/osm_trap_rcv.c
index 52f8832..09cdd35 100644
--- a/opensm/opensm/osm_trap_rcv.c
+++ b/opensm/opensm/osm_trap_rcv.c
@@ -338,6 +338,7 @@ static void trap_rcv_process_request(IN osm_sm_t * sm,
 	boolean_t physp_change_trap = FALSE;
 	uint64_t event_wheel_timeout = OSM_DEFAULT_TRAP_SUPRESSION_TIMEOUT;
 	boolean_t run_heavy_sweep = FALSE;
+	extern int sweeping;
 
 	OSM_LOG_ENTER(sm->p_log);
 
@@ -522,23 +523,30 @@ static void trap_rcv_process_request(IN osm_sm_t * sm,
 check_sweep:
 	/* do a sweep if we received a trap */
 	if (sm->p_subn->opt.sweep_on_trap) {
-		/* if this is trap number 128 or run_heavy_sweep is TRUE -
-		   update the force_heavy_sweep flag of the subnet.
-		   Sweep also on traps 144 - these traps signal a change of
-		   certain port capabilities.
-		   TODO: In the future this can be changed to just getting
-		   PortInfo on this port instead of sweeping the entire subnet. */
-		if (ib_notice_is_generic(p_ntci) &&
-		    (cl_ntoh16(p_ntci->g_or_v.generic.trap_num) == 128 ||
-		     cl_ntoh16(p_ntci->g_or_v.generic.trap_num) == 144 ||
-		     run_heavy_sweep)) {
-			OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
-				"Forcing heavy sweep. Received trap:%u\n",
+		if (!sweeping) {
+			OSM_LOG(sm->p_log, OSM_LOG_DEBUG, "sweeping disabled - "
+				"ignoring trap %u\n", 
+				cl_ntoh16(p_ntci->g_or_v.generic.trap_num));
+		} else {
+			/* if this is trap number 128 or run_heavy_sweep is 
+			 * TRUE - update the force_heavy_sweep flag of the 
+			 * subnet. Sweep also on traps 144 - these traps signal
+			 * a change of certain port capabilities.
+		  	 * TODO: In the future this can be changed to just 
+			 * getting PortInfo on this port instead of sweeping 
+			 * the entire subnet. */
+			if (ib_notice_is_generic(p_ntci) &&
+			    (cl_ntoh16(p_ntci->g_or_v.generic.trap_num) == 128 ||
+			     cl_ntoh16(p_ntci->g_or_v.generic.trap_num) == 144 ||
+			     run_heavy_sweep)) {
+				OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
+					"Forcing heavy sweep. Received trap:%u\n", 
 				cl_ntoh16(p_ntci->g_or_v.generic.trap_num));
 
-			sm->p_subn->force_heavy_sweep = TRUE;
+				sm->p_subn->force_heavy_sweep = TRUE;
+			}
+			osm_sm_signal(sm, OSM_SIGNAL_SWEEP);
 		}
-		osm_sm_signal(sm, OSM_SIGNAL_SWEEP);
 	}
 
 	/* If we reached here due to trap 129/130/131 - do not need to do
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
