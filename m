From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: Re: [PATCH 02/11] opensm: Allow the routing engine to influence
 SL2VL calculations.
Date: Thu, 14 Jan 2010 09:01:02 -0700
Message-ID: <1263484862.5361.71.camel@sale659.sandia.gov>
References: <1258744509-11148-1-git-send-email-jaschut@sandia.gov>
 <1258744509-11148-3-git-send-email-jaschut@sandia.gov>
 <4B4F0FBD.3040308@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B4F0FBD.3040308-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org" <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "eitan-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <eitan-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Thu, 2010-01-14 at 05:36 -0700, Yevgeny Kliteynik wrote:
> Hi Jim,
> 
> Just started reading this stuff, so it's going to take a while :-)

Thanks for taking a look.

> Meanwhile, first question:
> 
> On 20/Nov/09 21:15, Jim Schutt wrote:
> > Note that the original code assumes that QoS setup is mostly static and
> > based only on user configuration.  As a result, there is no provision for
> > routing engines that want to compute contributions to the SL2VL maps.
> >
> > Fix this up by adding a callback to struct osm_routing_engine that computes
> > a per-port SL2VL map, and call it from the appropriate place in the QoS
> > setup path.
> >
> > Also need to move the call to osm_qos_setup() in do_sweep() to after the
> > call to the routing engine, so that any SL2VL map contributions from the
> > routing engine are based on the latest information.
> 
> [snip...]
> 
> > diff --git a/opensm/opensm/osm_state_mgr.c b/opensm/opensm/osm_state_mgr.c
> > index 7540adc..c3f49dc 100644
> > --- a/opensm/opensm/osm_state_mgr.c
> > +++ b/opensm/opensm/osm_state_mgr.c
> > @@ -1228,8 +1228,6 @@ repeat_discovery:
> >
> >   	osm_pkey_mgr_process(sm->p_subn->p_osm);
> >
> > -	osm_qos_setup(sm->p_subn->p_osm);
> > -
> >   	/* try to restore SA DB (this should be before lid_mgr
> >   	   because we may want to disable clients reregistration
> >   	when SA DB is restored) */
> > @@ -1270,6 +1268,8 @@ repeat_discovery:
> >   	    osm_ucast_cache_process(&sm->ucast_mgr))
> >   		osm_ucast_mgr_process(&sm->ucast_mgr);
> >
> > +	osm_qos_setup(sm->p_subn->p_osm);
> > +
> >   	if (wait_for_pending_transactions(&sm->p_subn->p_osm->stats))
> >   		return;
> >    
> 
> So I understand that QoS setup has to be re-applied every time routing
> engine is executed. There's also another place where routing engine is
> executed - when re-route is specifically required:
> 
>    1100          /*
>    1101           * If we don't need to do a heavy sweep and we want to 
> do a reroute,
>    1102           * just reroute only.
>    1103           */
>    1104          if (cl_qmap_count(&sm->p_subn->sw_guid_tbl)
>    1105 && sm->p_subn->sm_state != IB_SMINFO_STATE_DISCOVERING
>    1106 && sm->p_subn->opt.force_heavy_sweep == FALSE
>    1107 && sm->p_subn->force_heavy_sweep == FALSE
>    1108 && sm->p_subn->force_reroute == TRUE
>    1109 && sm->p_subn->subnet_initialization_error == FALSE) {
>    ....
>    1115
>    1116                  osm_ucast_mgr_process(&sm->ucast_mgr);
>    1117
>    ....
> 
> Guess you need to call osm_qos_setup() here as well, right?

Yep.  I missed that one.

Good catch, thanks.

-- Jim

> 
> -- Yevgeny
> 
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
