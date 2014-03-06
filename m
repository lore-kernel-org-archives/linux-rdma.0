From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] Revert "Reset client reregistration when receiving
 handover"
Date: Thu, 06 Mar 2014 08:46:42 -0500
Message-ID: <53187C42.7070808@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Chu, Al" <chu11-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Mon, 3 Dec 2012 14:45:24 +0200

This reverts commit f4722b0f833ed7a060f80b6757cfb9af78252678.

This patch is no longer needed since first_master_sweep is now set
when reaching MASTER state even if SM was in MASTER before. This is
equivalent to the set_client_rereg_on_sweep flag that was added in
the patch being reverted.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/opensm/osm_subnet.h |   22 +++++++---------------
 opensm/osm_console.c        |    2 --
 opensm/osm_lid_mgr.c        |   12 +++---------
 opensm/osm_sm_state_mgr.c   |    4 ----
 opensm/osm_state_mgr.c      |    2 +-
 5 files changed, 11 insertions(+), 31 deletions(-)

diff --git a/include/opensm/osm_subnet.h b/include/opensm/osm_subnet.h
index 35d022b..37e0fb3 100644
--- a/include/opensm/osm_subnet.h
+++ b/include/opensm/osm_subnet.h
@@ -763,7 +763,6 @@ typedef struct osm_subn {
 	boolean_t force_reroute;
 	boolean_t in_sweep_hop_0;
 	boolean_t first_time_master_sweep;
-	boolean_t set_client_rereg_on_sweep;
 	boolean_t coming_out_of_standby;
 	boolean_t sweeping_enabled;
 	unsigned need_update;
@@ -872,20 +871,13 @@ typedef struct osm_subn {
 *		the sweeping.
 *
 *	first_time_master_sweep
-*		This flag is to indicate the first sweep as master (meaning
-*		after moving from Standby|Discovering state).  The flag is
-*		used to notify some alternate actions that must be done on
-*		the first master sweep.  It may perform some actions indicated
-*		by flags below, such as set_client_rereg_on_sweep.
-*
-*	set_client_rereg_on_sweep
-*		This flag is used for the PortInfo setting client rereg.
-*		When configuring the subnet for the first time, and several
-*		other circumstances, SM must send a PortInfoSet to all ports.
-*		After that - we want to minimize the number of PortInfoSet
-*		requests sent, and to send only requests that change the value
-*		from what is updated in the port (or send a first request if
-*		this is a new port). We will set this flag to TRUE when entering
+*		This flag is used for the PortInfo setting. On the first
+*		sweep as master (meaning after moving from Standby|Discovering
+*		state), the SM must send a PortInfoSet to all ports. After
+*		that - we want to minimize the number of PortInfoSet requests
+*		sent, and to send only requests that change the value from
+*		what is updated in the port (or send a first request if this
+*		is a new port). We will set this flag to TRUE when entering
 *		the master state, and set it back to FALSE at the end of the
 *		drop manager. This is done since at the end of the drop manager
 *		we have updated all the ports that are reachable, and from now
diff --git a/opensm/osm_console.c b/opensm/osm_console.c
index 665b8a5..1a05902 100644
--- a/opensm/osm_console.c
+++ b/opensm/osm_console.c
@@ -512,7 +512,6 @@ static void print_status(osm_opensm_t * p_osm, FILE * out)
 			"   Subnet Init errors             : %d\n"
 			"   In sweep hop 0                 : %d\n"
 			"   First time master sweep        : %d\n"
-			"   Set client rereg on sweep      : %d\n"
 			"   Coming out of standby          : %d\n",
 			p_osm->subn.sweeping_enabled,
 			p_osm->subn.opt.sweep_interval,
@@ -520,7 +519,6 @@ static void print_status(osm_opensm_t * p_osm, FILE * out)
 			p_osm->subn.subnet_initialization_error,
 			p_osm->subn.in_sweep_hop_0,
 			p_osm->subn.first_time_master_sweep,
-			p_osm->subn.set_client_rereg_on_sweep,
 			p_osm->subn.coming_out_of_standby);
 		dump_sms(p_osm, out);
 		fprintf(out, "\n");
diff --git a/opensm/osm_lid_mgr.c b/opensm/osm_lid_mgr.c
index 757a9e3..ba103cb 100644
--- a/opensm/osm_lid_mgr.c
+++ b/opensm/osm_lid_mgr.c
@@ -1034,9 +1034,7 @@ static int lid_mgr_set_physp_pi(IN osm_lid_mgr_t * p_mgr,
 	   the cli_rereg bit. We know that the port was just discovered if its
 	   is_new field is set.
 	 */
-	if ((p_mgr->p_subn->first_time_master_sweep == TRUE
-	     || p_mgr->p_subn->set_client_rereg_on_sweep == TRUE
-	     || p_port->is_new)
+	if ((p_mgr->p_subn->first_time_master_sweep == TRUE || p_port->is_new)
 	    && !p_mgr->p_subn->opt.no_clients_rereg
 	    && (p_old_pi->capability_mask & IB_PORT_CAP_HAS_CLIENT_REREG)) {
 		OSM_LOG(p_mgr->p_log, OSM_LOG_DEBUG,
@@ -1056,13 +1054,8 @@ static int lid_mgr_set_physp_pi(IN osm_lid_mgr_t * p_mgr,
 	   2. first_time_master_sweep flag on the subnet is TRUE. This means the
 	   SM just became master, and it then needs to send a PortInfo Set to
 	   every port.
-	   3. set_client_rereg_on_sweep is TRUE.  The one situation in which this
-	   is true but first_time_master_sweep is FALSE is when the SM receives
-	   a HANDOVER while in master.  We don't want to re-setup everything by
-	   setting first_time_master_sweep, but we do want to reset up this.
 	 */
-	if (p_mgr->p_subn->first_time_master_sweep == TRUE
-	    || p_mgr->p_subn->set_client_rereg_on_sweep == TRUE)
+	if (p_mgr->p_subn->first_time_master_sweep == TRUE)
 		send_set = TRUE;
 
 	if (!send_set)
diff --git a/opensm/osm_sm_state_mgr.c b/opensm/osm_sm_state_mgr.c
index 868caed..76ccf81 100644
--- a/opensm/osm_sm_state_mgr.c
+++ b/opensm/osm_sm_state_mgr.c
@@ -455,11 +455,7 @@ ib_api_status_t osm_sm_state_mgr_process(osm_sm_t * sm,
 			OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
 				"Forcing heavy sweep. Received signal %s\n",
 				osm_get_sm_mgr_signal_str(signal));
-			/* Force set_client_rereg_on_sweep, we don't know what the other
-			 * SM may have configure/done on the fabric.
-			 */
 			CL_PLOCK_EXCL_ACQUIRE(sm->p_lock);
-			sm->p_subn->set_client_rereg_on_sweep = TRUE;
 			sm->polling_sm_guid = 0;
 			sm->p_subn->first_time_master_sweep = TRUE;
 			sm->p_subn->coming_out_of_standby = TRUE;
diff --git a/opensm/osm_state_mgr.c b/opensm/osm_state_mgr.c
index c4f4978..1872f31 100644
--- a/opensm/osm_state_mgr.c
+++ b/opensm/osm_state_mgr.c
@@ -1538,7 +1538,6 @@ repeat_discovery:
 		osm_dump_all(sm->p_subn->p_osm);
 		state_mgr_up_msg(sm);
 		sm->p_subn->first_time_master_sweep = FALSE;
-		sm->p_subn->set_client_rereg_on_sweep = FALSE;
 
 		if (OSM_LOG_IS_ACTIVE_V2(sm->p_log, OSM_LOG_VERBOSE) ||
 		    sm->p_subn->opt.sa_db_dump)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
