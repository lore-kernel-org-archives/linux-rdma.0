From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: Re: [PATCH 02/11] opensm: Allow the routing engine to influence
 SL2VL calculations.
Date: Mon, 15 Feb 2010 14:45:29 -0700
Message-ID: <1266270329.31472.112.camel@sale659.sandia.gov>
References: <1258744509-11148-1-git-send-email-jaschut@sandia.gov>
 <1258744509-11148-3-git-send-email-jaschut@sandia.gov>
 <4B72DBBD.9020709@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B72DBBD.9020709-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org" <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "eitan-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <eitan-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Wed, 2010-02-10 at 09:15 -0700, Yevgeny Kliteynik wrote:
> Hi Jim,
> 
> [snip...]
> 
> On 20/Nov/09 21:15, Jim Schutt wrote:
> > diff --git a/opensm/opensm/osm_qos.c b/opensm/opensm/osm_qos.c
> > index 08f9a60..f42c334 100644
> > --- a/opensm/opensm/osm_qos.c
> > +++ b/opensm/opensm/osm_qos.c
> > @@ -194,6 +194,7 @@ static ib_api_status_t sl2vl_update(osm_sm_t * sm, osm_port_t * p_port,
> >   {
> >   	ib_api_status_t status;
> >   	uint8_t i, num_ports;
> > +	struct osm_routing_engine *re = sm->p_subn->p_osm->routing_engine_used;
> >   	osm_physp_t *p_physp;
> >
> >   	if (osm_node_get_type(osm_physp_get_node_ptr(p)) == IB_NODE_TYPE_SWITCH) {
> > @@ -213,8 +214,24 @@ static ib_api_status_t sl2vl_update(osm_sm_t * sm, osm_port_t * p_port,
> >   	}
> >
> >   	for (i = 0; i<  num_ports; i++) {
> > +		ib_slvl_table_t routing_sl2vl;
> > +		const ib_slvl_table_t *port_sl2vl;
> > +		const ib_slvl_table_t *port_sl2vl_old;
> > +
> > +		if (re->update_sl2vl) {
> >    
> 
> If routing failed, and no_fallback specified, OSM crashes here.
> The simple fix is, of course, just fixing the condition to
> "(re && re->update_sl2vl)", but 

This could cause message deadlock for applications still running
on parts of fabric that are sill operational, if the last successful
routing was via a routing engine that wants to set SL2VL map values,
because we would overwrite them with inappropriate values.

But the following equivalent change would be OK:

diff --git a/opensm/opensm/osm_qos.c b/opensm/opensm/osm_qos.c
index 0f0b24f..07f4836 100644
--- a/opensm/opensm/osm_qos.c
+++ b/opensm/opensm/osm_qos.c
@@ -197,6 +197,12 @@ static ib_api_status_t sl2vl_update(osm_sm_t * sm, osm_port_t * p_port,
 	struct osm_routing_engine *re = sm->p_subn->p_osm->routing_engine_used;
 	osm_physp_t *p_physp;
 
+	/*
+	 * Do nothing unless the most recent routing attempt was successful.
+	 */
+	if (!re)
+		return IB_SUCCESS;
+
 	if (osm_node_get_type(osm_physp_get_node_ptr(p)) == IB_NODE_TYPE_SWITCH) {
 		if (ib_port_info_get_vl_cap(&p->port_info) == 1) {
 			/* Check port 0's capability mask */


> I think that it would be better
> not to apply QoS configuration if unicast manager failed - just
> restart the sweep.

I think you are right.  Something like this?


diff --git a/opensm/opensm/osm_state_mgr.c
b/opensm/opensm/osm_state_mgr.c
index 10d5e09..d8d4c9e 100644
--- a/opensm/opensm/osm_state_mgr.c
+++ b/opensm/opensm/osm_state_mgr.c
@@ -1113,7 +1113,11 @@ static void do_sweep(osm_sm_t * sm)
 		/* Re-program the switches fully */
 		sm->p_subn->ignore_existing_lfts = TRUE;
 
-		osm_ucast_mgr_process(&sm->ucast_mgr);
+		if (osm_ucast_mgr_process(&sm->ucast_mgr)) {
+			OSM_LOG_MSG_BOX(sm->p_log, OSM_LOG_VERBOSE,
+					"REROUTE FAILED");
+			return;
+		}
 		osm_qos_setup(sm->p_subn->p_osm);
 
 		/* Reset flag */
@@ -1272,12 +1276,14 @@ repeat_discovery:
 			"LID ASSIGNMENT COMPLETE - STARTING SWITCH TABLE CONFIG");
 
 	/*
-	 * Proceed with unicast forwarding table configuration.
+	 * Proceed with unicast forwarding table configuration; repeat
+	 * if unicast routing fails.
 	 */
 
 	if (!sm->ucast_mgr.cache_valid ||
 	    osm_ucast_cache_process(&sm->ucast_mgr))
-		osm_ucast_mgr_process(&sm->ucast_mgr);
+		if (osm_ucast_mgr_process(&sm->ucast_mgr))
+			goto repeat_discovery;
 
 	osm_qos_setup(sm->p_subn->p_osm);
 
diff --git a/opensm/opensm/osm_ucast_mgr.c
b/opensm/opensm/osm_ucast_mgr.c
index fbc9244..8ea2e52 100644
--- a/opensm/opensm/osm_ucast_mgr.c
+++ b/opensm/opensm/osm_ucast_mgr.c
@@ -955,6 +955,7 @@ int osm_ucast_mgr_process(IN osm_ucast_mgr_t *
p_mgr)
 	osm_opensm_t *p_osm;
 	struct osm_routing_engine *p_routing_eng;
 	cl_qmap_t *p_sw_guid_tbl;
+	int failed = 0;
 
 	OSM_LOG_ENTER(p_mgr->p_log);
 
@@ -973,7 +974,8 @@ int osm_ucast_mgr_process(IN osm_ucast_mgr_t *
p_mgr)
 
 	p_osm->routing_engine_used = NULL;
 	while (p_routing_eng) {
-		if (!ucast_mgr_route(p_routing_eng, p_osm))
+		failed = ucast_mgr_route(p_routing_eng, p_osm);
+		if (!failed)
 			break;
 		p_routing_eng = p_routing_eng->next;
 	}
@@ -984,9 +986,11 @@ int osm_ucast_mgr_process(IN osm_ucast_mgr_t *
p_mgr)
 		struct osm_routing_engine *r = p_osm->default_routing_engine;
 
 		r->build_lid_matrices(r->context);
-		r->ucast_build_fwd_tables(r->context);
-		p_osm->routing_engine_used = r;
-		osm_ucast_mgr_set_fwd_tables(p_mgr);
+		failed = r->ucast_build_fwd_tables(r->context);
+		if (!failed) {
+			p_osm->routing_engine_used = r;
+			osm_ucast_mgr_set_fwd_tables(p_mgr);
+		}
 	}
 
 	if (p_osm->routing_engine_used) {
@@ -1006,7 +1010,7 @@ int osm_ucast_mgr_process(IN osm_ucast_mgr_t *
p_mgr)
 Exit:
 	CL_PLOCK_RELEASE(p_mgr->p_lock);
 	OSM_LOG_EXIT(p_mgr->p_log);
-	return 0;
+	return failed;
 }
 
 static int ucast_build_lid_matrices(void *context)


Thanks -- Jim


> 
> -- Yevgeny
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
