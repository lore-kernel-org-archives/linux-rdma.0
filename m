From: Arthur Kepner <akepner-sJ/iWh9BUns@public.gmane.org>
Subject: [PATCH/RFC] opensm: toggle sweeping V2
Date: Wed, 19 May 2010 16:57:27 -0700
Message-ID: <20100519235727.GP7678@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org, Dale.R.Talcott-NSQ8wuThN14@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


One of our customers recently merged some new systems into a 
large, existing cluster. They requested a mechanism to prevent 
opensm from sweeping while the new equipment was being added to 
the IB fabric, and then resume sweeping once they felt confident 
that the newly added (sub)fabric was correctly cabled, and fully 
functional. They used something similar to the following patch. 

Comments?

Signed-off-by: Arthur Kepner <akepner-sJ/iWh9BUns@public.gmane.org>

--- 

 include/opensm/osm_subnet.h |    6 ++++++
 opensm/osm_console.c        |   32 ++++++++++++++++++++++++++++++++
 opensm/osm_state_mgr.c      |    8 +++++++-
 opensm/osm_subnet.c         |    1 +
 opensm/osm_trap_rcv.c       |   35 +++++++++++++++++++++--------------
 5 files changed, 67 insertions(+), 15 deletions(-)

diff --git a/opensm/include/opensm/osm_subnet.h b/opensm/include/opensm/osm_subnet.h
index d79ed8f..2a1db99 100644
--- a/opensm/include/opensm/osm_subnet.h
+++ b/opensm/include/opensm/osm_subnet.h
@@ -532,6 +532,7 @@ typedef struct osm_subn {
 	boolean_t in_sweep_hop_0;
 	boolean_t first_time_master_sweep;
 	boolean_t coming_out_of_standby;
+	boolean_t sweeping_enabled;
 	unsigned need_update;
 	cl_fmap_t mgrp_mgid_tbl;
 	void *mboxes[IB_LID_MCAST_END_HO - IB_LID_MCAST_START_HO + 1];
@@ -651,6 +652,11 @@ typedef struct osm_subn {
 *		The flag is set true if the SM state was standby and now
 *		changed to MASTER it is reset at the end of the sweep.
 *
+*	sweeping_enabled
+*		FALSE - sweeping is administratively disabled, all
+*		sweeping is inhibited, TRUE - sweeping is done
+*		normally
+*
 *	need_update
 *		This flag should be on during first non-master heavy
 *		(including pre-master discovery stage)
diff --git a/opensm/opensm/osm_console.c b/opensm/opensm/osm_console.c
index 968486e..bc7bea3 100644
--- a/opensm/opensm/osm_console.c
+++ b/opensm/opensm/osm_console.c
@@ -150,6 +150,16 @@ static void help_reroute(FILE * out, int detail)
 	}
 }
 
+static void help_sweep(FILE * out, int detail)
+{
+	fprintf(out, "sweep [on|off]\n");
+	if (detail) {
+		fprintf(out, "enable or disable sweeping\n");
+		fprintf(out, "   [on] sweep normally\n");
+		fprintf(out, "   [off] inhibit all sweeping\n");
+	}
+}
+
 static void help_status(FILE * out, int detail)
 {
 	fprintf(out, "status [loop]\n");
@@ -427,11 +437,15 @@ static void print_status(osm_opensm_t * p_osm, FILE * out)
 			p_osm->stats.sa_mads_ignored);
 		fprintf(out, "\n   Subnet flags\n"
 			"   ------------\n"
+			"   Sweeping enabled               : %d\n"
+			"   Sweep interval (seconds)       : %d\n"
 			"   Ignore existing lfts           : %d\n"
 			"   Subnet Init errors             : %d\n"
 			"   In sweep hop 0                 : %d\n"
 			"   First time master sweep        : %d\n"
 			"   Coming out of standby          : %d\n",
+			p_osm->subn.sweeping_enabled,
+			p_osm->subn.opt.sweep_interval,
 			p_osm->subn.ignore_existing_lfts,
 			p_osm->subn.subnet_initialization_error,
 			p_osm->subn.in_sweep_hop_0,
@@ -495,6 +509,23 @@ static void reroute_parse(char **p_last, osm_opensm_t * p_osm, FILE * out)
 	osm_opensm_sweep(p_osm);
 }
 
+static void sweep_parse(char **p_last, osm_opensm_t * p_osm, FILE * out)
+{
+	char *p_cmd;
+
+	p_cmd = next_token(p_last);
+	if (!p_cmd ||
+	    (strcmp(p_cmd, "on") != 0 && strcmp(p_cmd, "off") != 0)) {
+		fprintf(out, "Invalid sweep command\n");
+		help_sweep(out, 1);
+	} else {
+		if (strcmp(p_cmd, "on") == 0)
+			p_osm->subn.sweeping_enabled = TRUE;
+		else
+			p_osm->subn.sweeping_enabled = FALSE;
+	}
+}
+
 static void logflush_parse(char **p_last, osm_opensm_t * p_osm, FILE * out)
 {
 	fflush(p_osm->log.out_port);
@@ -1332,6 +1363,7 @@ static const struct command console_cmds[] = {
 	{"priority", &help_priority, &priority_parse},
 	{"resweep", &help_resweep, &resweep_parse},
 	{"reroute", &help_reroute, &reroute_parse},
+	{"sweep", &help_sweep, &sweep_parse},
 	{"status", &help_status, &status_parse},
 	{"logflush", &help_logflush, &logflush_parse},
 	{"querylid", &help_querylid, &querylid_parse},
diff --git a/opensm/opensm/osm_state_mgr.c b/opensm/opensm/osm_state_mgr.c
index e43463f..81c8f54 100644
--- a/opensm/opensm/osm_state_mgr.c
+++ b/opensm/opensm/osm_state_mgr.c
@@ -1415,7 +1415,13 @@ void osm_state_mgr_process(IN osm_sm_t * sm, IN osm_signal_t signal)
 
 	switch (signal) {
 	case OSM_SIGNAL_SWEEP:
-		do_sweep(sm);
+		if (!sm->p_subn->sweeping_enabled) {
+			OSM_LOG(sm->p_log, OSM_LOG_DEBUG, "sweeping disabled - "
+				"ignoring signal %s in state %s\n",
+				osm_get_sm_signal_str(signal),
+				osm_get_sm_mgr_state_str(sm->p_subn->sm_state));
+		} else
+			do_sweep(sm);
 		break;
 	case OSM_SIGNAL_IDLE_TIME_PROCESS_REQUEST:
 		do_process_mgrp_queue(sm);
diff --git a/opensm/opensm/osm_subnet.c b/opensm/opensm/osm_subnet.c
index ac8cb37..ba2c812 100644
--- a/opensm/opensm/osm_subnet.c
+++ b/opensm/opensm/osm_subnet.c
@@ -531,6 +531,7 @@ ib_api_status_t osm_subn_init(IN osm_subn_t * p_subn, IN osm_opensm_t * p_osm,
 
 	/* we assume master by default - so we only need to set it true if STANDBY */
 	p_subn->coming_out_of_standby = FALSE;
+	p_subn->sweeping_enabled = TRUE;
 
 	return IB_SUCCESS;
 }
diff --git a/opensm/opensm/osm_trap_rcv.c b/opensm/opensm/osm_trap_rcv.c
index bf13239..ba366a9 100644
--- a/opensm/opensm/osm_trap_rcv.c
+++ b/opensm/opensm/osm_trap_rcv.c
@@ -515,23 +515,30 @@ static void trap_rcv_process_request(IN osm_sm_t * sm,
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
+		if (!sm->p_subn->sweeping_enabled) {
+			OSM_LOG(sm->p_log, OSM_LOG_DEBUG,
+				"sweeping disabled - ignoring trap %u\n",
 				cl_ntoh16(p_ntci->g_or_v.generic.trap_num));
+		} else {
+			/* if this is trap number 128 or run_heavy_sweep is
+			   TRUE - update the force_heavy_sweep flag of the
+			   subnet.  Sweep also on traps 144 - these traps
+			   signal a change of certain port capabilities.
+			   TODO: In the future this can be changed to just
+			   getting PortInfo on this port instead of sweeping
+			   the entire subnet. */
+			if (ib_notice_is_generic(p_ntci) &&
+			    (cl_ntoh16(p_ntci->g_or_v.generic.trap_num) == 128 ||
+			     cl_ntoh16(p_ntci->g_or_v.generic.trap_num) == 144 ||
+			     run_heavy_sweep)) {
+				OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
+					"Forcing heavy sweep. Received trap:%u\n",
+					cl_ntoh16(p_ntci->g_or_v.generic.trap_num));
 
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
