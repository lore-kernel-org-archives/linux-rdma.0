From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] opensm: Reset client reregistration when receiving handover
Date: Thu, 16 Feb 2012 10:46:55 -0800
Message-ID: <1329418015.4779.1197.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When in master state and receiving a handover from another SM, reset the
client reregistration bit while reconfguring PortInfo settings.  While
this is normally handled only the first time a master sweep is done,
this is a special case in which it is required, because we do not know how
the other master SM may have configured/setup the fabric.  Most notably,
this is needed when multicast groups are re-created and we wish for
end nodes to re-join the multicast group of the new master SM.

Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 include/opensm/osm_subnet.h |   22 +++++++++++++++-------
 opensm/osm_console.c        |    2 ++
 opensm/osm_lid_mgr.c        |   11 +++++++++--
 opensm/osm_sm_state_mgr.c   |    4 ++++
 opensm/osm_state_mgr.c      |    1 +
 5 files changed, 31 insertions(+), 9 deletions(-)

diff --git a/include/opensm/osm_subnet.h b/include/opensm/osm_subnet.h
index 90eae8b..e444ee5 100644
--- a/include/opensm/osm_subnet.h
+++ b/include/opensm/osm_subnet.h
@@ -562,6 +562,7 @@ typedef struct osm_subn {
 	boolean_t force_reroute;
 	boolean_t in_sweep_hop_0;
 	boolean_t first_time_master_sweep;
+	boolean_t set_client_rereg_on_sweep;
 	boolean_t coming_out_of_standby;
 	boolean_t sweeping_enabled;
 	unsigned need_update;
@@ -668,13 +669,20 @@ typedef struct osm_subn {
 *		the sweeping.
 *
 *	first_time_master_sweep
-*		This flag is used for the PortInfo setting. On the first
-*		sweep as master (meaning after moving from Standby|Discovering
-*		state), the SM must send a PortInfoSet to all ports. After
-*		that - we want to minimize the number of PortInfoSet requests
-*		sent, and to send only requests that change the value from
-*		what is updated in the port (or send a first request if this
-*		is a new port). We will set this flag to TRUE when entering
+*		This flag is to indicate the first sweep as master (meaning
+*		after moving from Standby|Discovering state).  The flag is
+*		used to notify some alternate actions that must be done on
+*		the first master sweep.  It may perform some actions indicated
+*		by flags below, such as set_client_rereg_on_sweep.
+*
+*	set_client_rereg_on_sweep
+*		This flag is used for the PortInfo setting client rereg.
+*		When configuring the subnet for the first time, and several
+*		other circumstances, SM must send a PortInfoSet to all ports.
+*		After that - we want to minimize the number of PortInfoSet
+*		requests sent, and to send only requests that change the value
+*		from what is updated in the port (or send a first request if
+*		this is a new port). We will set this flag to TRUE when entering
 *		the master state, and set it back to FALSE at the end of the
 *		drop manager. This is done since at the end of the drop manager
 *		we have updated all the ports that are reachable, and from now
diff --git a/opensm/osm_console.c b/opensm/osm_console.c
index 019ed0c..c13431d 100644
--- a/opensm/osm_console.c
+++ b/opensm/osm_console.c
@@ -452,6 +452,7 @@ static void print_status(osm_opensm_t * p_osm, FILE * out)
 			"   Subnet Init errors             : %d\n"
 			"   In sweep hop 0                 : %d\n"
 			"   First time master sweep        : %d\n"
+			"   Set client rereg on sweep      : %d\n"
 			"   Coming out of standby          : %d\n",
 			p_osm->subn.sweeping_enabled,
 			p_osm->subn.opt.sweep_interval,
@@ -459,6 +460,7 @@ static void print_status(osm_opensm_t * p_osm, FILE * out)
 			p_osm->subn.subnet_initialization_error,
 			p_osm->subn.in_sweep_hop_0,
 			p_osm->subn.first_time_master_sweep,
+			p_osm->subn.set_client_rereg_on_sweep,
 			p_osm->subn.coming_out_of_standby);
 		dump_sms(p_osm, out);
 		fprintf(out, "\n");
diff --git a/opensm/osm_lid_mgr.c b/opensm/osm_lid_mgr.c
index c6221c1..7610df7 100644
--- a/opensm/osm_lid_mgr.c
+++ b/opensm/osm_lid_mgr.c
@@ -1012,7 +1012,9 @@ static int lid_mgr_set_physp_pi(IN osm_lid_mgr_t * p_mgr,
 	   the cli_rereg bit. We know that the port was just discovered if its
 	   is_new field is set.
 	 */
-	if ((p_mgr->p_subn->first_time_master_sweep == TRUE || p_port->is_new)
+	if ((p_mgr->p_subn->first_time_master_sweep == TRUE
+	     || p_mgr->p_subn->set_client_rereg_on_sweep == TRUE
+	     || p_port->is_new)
 	    && !p_mgr->p_subn->opt.no_clients_rereg
 	    && (p_old_pi->capability_mask & IB_PORT_CAP_HAS_CLIENT_REREG)) {
 		OSM_LOG(p_mgr->p_log, OSM_LOG_DEBUG,
@@ -1029,8 +1031,13 @@ static int lid_mgr_set_physp_pi(IN osm_lid_mgr_t * p_mgr,
 	   2. first_time_master_sweep flag on the subnet is TRUE. This means the
 	   SM just became master, and it then needs to send a PortInfo Set to
 	   every port.
+	   3. set_client_rereg_on_sweep is TRUE.  The one situation in which this
+	   is true but first_time_master_sweep is FALSE is when the SM receives
+	   a HANDOVER while in master.  We don't want to re-setup everything by
+	   setting first_time_master_sweep, but we do want to reset up this.
 	 */
-	if (p_mgr->p_subn->first_time_master_sweep == TRUE)
+	if (p_mgr->p_subn->first_time_master_sweep == TRUE
+	    || p_mgr->p_subn->set_client_rereg_on_sweep == TRUE)
 		send_set = TRUE;
 
 	if (!send_set)
diff --git a/opensm/osm_sm_state_mgr.c b/opensm/osm_sm_state_mgr.c
index a568267..64544f4 100644
--- a/opensm/osm_sm_state_mgr.c
+++ b/opensm/osm_sm_state_mgr.c
@@ -403,6 +403,10 @@ ib_api_status_t osm_sm_state_mgr_process(osm_sm_t * sm,
 			OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
 				"Forcing heavy sweep. "
 				"Received OSM_SM_SIGNAL_HANDOVER or OSM_SM_SIGNAL_POLLING_TIMEOUT\n");
+			/* Force set_client_rereg_on_sweep, we don't know what the other
+			 * SM may have configure/done on the fabric.
+			 */ 
+			sm->p_subn->set_client_rereg_on_sweep = TRUE;
 			sm->p_polling_sm = NULL;
 			sm->p_subn->force_heavy_sweep = TRUE;
 			osm_sm_signal(sm, OSM_SIGNAL_SWEEP);
diff --git a/opensm/osm_state_mgr.c b/opensm/osm_state_mgr.c
index 96b445f..14d1b7f 100644
--- a/opensm/osm_state_mgr.c
+++ b/opensm/osm_state_mgr.c
@@ -1416,6 +1416,7 @@ repeat_discovery:
 		osm_dump_all(sm->p_subn->p_osm);
 		state_mgr_up_msg(sm);
 		sm->p_subn->first_time_master_sweep = FALSE;
+		sm->p_subn->set_client_rereg_on_sweep = FALSE;
 
 		if (osm_log_is_active(sm->p_log, OSM_LOG_VERBOSE) ||
 		    sm->p_subn->opt.sa_db_dump)
-- 
1.7.1



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
