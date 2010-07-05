From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v6] opensm/osmeventplugin: added new events to monitor
 SM
Date: Mon, 5 Jul 2010 21:01:18 +0300
Message-ID: <20100705180118.GE22860@me>
References: <4C2B15C6.2050701@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4C2B15C6.2050701-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Yevgeny,

On 13:00 Wed 30 Jun     , Yevgeny Kliteynik wrote:
> Adding new events that allow event plug-in to see
> when SM starts/finishes heavy sweep and routing
> configuration, when it updates dump files, when it
> is no longer master, when SM port is down, and when
> SA DB is actually dumped at the end of light sweep:
> 
>   OSM_EVENT_ID_HEAVY_SWEEP_START
>   OSM_EVENT_ID_HEAVY_SWEEP_DONE
>   OSM_EVENT_ID_UCAST_ROUTING_DONE
>   OSM_EVENT_ID_STATE_CHANGE
>   OSM_EVENT_ID_SA_DB_DUMPED
> 
> Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

I'm applying this, Thanks.

However I would strongly suggest few improvements - see below.

> ---
> 
> Changes since v5:
>  - Added OSM_EVENT_ID_HEAVY_SWEEP_START event.
> 
> Changes since v4:
>  - OSM_EVENT_ID_SA_DB_DUMPED was still reported during
>    heavy sweep - removed.
> 
> Changes since v3:
>  - OSM_EVENT_ID_ENTERING_STANDBY and OSM_EVENT_ID_SM_PORT_DOWN
>    replaced by OSM_EVENT_STATE_CHANGE
>  - OSM_EVENT_ID_SA_DB_DUMPED is not reported during
>    heavy sweep, but only if SA DB was actually dumped
>    at the end of light sweep
>  - fixed bug with OSM_EVENT_ID_MAX
> 
> Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> ---
>  opensm/include/opensm/osm_event_plugin.h   |    5 +++++
>  opensm/opensm/osm_state_mgr.c              |   20 ++++++++++++++++++--
>  opensm/osmeventplugin/src/osmeventplugin.c |   15 +++++++++++++++
>  3 files changed, 38 insertions(+), 2 deletions(-)
> 
> diff --git a/opensm/include/opensm/osm_event_plugin.h b/opensm/include/opensm/osm_event_plugin.h
> index 33d1920..6a99ed9 100644
> --- a/opensm/include/opensm/osm_event_plugin.h
> +++ b/opensm/include/opensm/osm_event_plugin.h
> @@ -72,6 +72,11 @@ typedef enum {
>  	OSM_EVENT_ID_PORT_SELECT,
>  	OSM_EVENT_ID_TRAP,
>  	OSM_EVENT_ID_SUBNET_UP,
> +	OSM_EVENT_ID_HEAVY_SWEEP_START,
> +	OSM_EVENT_ID_HEAVY_SWEEP_DONE,

I see that this one is used to indicate a discovery sweep phase
completion. Would it be better to rename this as
OSM_EVENT_ID_DISCOVERY_DONE?

> +	OSM_EVENT_ID_UCAST_ROUTING_DONE,
> +	OSM_EVENT_ID_STATE_CHANGE,
> +	OSM_EVENT_ID_SA_DB_DUMPED,
>  	OSM_EVENT_ID_MAX
>  } osm_epi_event_id_t;
> 
> diff --git a/opensm/opensm/osm_state_mgr.c b/opensm/opensm/osm_state_mgr.c
> index 81c8f54..e7bff46 100644
> --- a/opensm/opensm/osm_state_mgr.c
> +++ b/opensm/opensm/osm_state_mgr.c
> @@ -1107,8 +1107,10 @@ static void do_sweep(osm_sm_t * sm)
>  		if (wait_for_pending_transactions(&sm->p_subn->p_osm->stats))
>  			return;
>  		if (!sm->p_subn->force_heavy_sweep) {
> -			if (sm->p_subn->opt.sa_db_dump)
> -				osm_sa_db_file_dump(sm->p_subn->p_osm);
> +			if (sm->p_subn->opt.sa_db_dump &&
> +			    !osm_sa_db_file_dump(sm->p_subn->p_osm))
> +				osm_opensm_report_event(sm->p_subn->p_osm,
> +					OSM_EVENT_ID_SA_DB_DUMPED, NULL);
>  			OSM_LOG_MSG_BOX(sm->p_log, OSM_LOG_VERBOSE,
>  					"LIGHT SWEEP COMPLETE");
>  			return;
> @@ -1151,10 +1153,15 @@ static void do_sweep(osm_sm_t * sm)
>  		if (!sm->p_subn->subnet_initialization_error) {
>  			OSM_LOG_MSG_BOX(sm->p_log, OSM_LOG_VERBOSE,
>  					"REROUTE COMPLETE");
> +			osm_opensm_report_event(sm->p_subn->p_osm,
> +				OSM_EVENT_ID_UCAST_ROUTING_DONE, NULL);
>  			return;
>  		}
>  	}
> 
> +	osm_opensm_report_event(sm->p_subn->p_osm,
> +				OSM_EVENT_ID_HEAVY_SWEEP_START, NULL);
> +
>  	/* go to heavy sweep */
>  repeat_discovery:
> 
> @@ -1185,6 +1192,8 @@ repeat_discovery:
> 
>  		/* Move to DISCOVERING state */
>  		osm_sm_state_mgr_process(sm, OSM_SM_SIGNAL_DISCOVER);
> +		osm_opensm_report_event(sm->p_subn->p_osm,
> +				OSM_EVENT_ID_STATE_CHANGE, NULL);

I think, that if we are introducing "SM state change" event then this
should report any state change and not only "going to stand-by". I would
prefer to see this report call inside osm_sm_state_mgr_process().

>  		return;
>  	}
> 
> @@ -1205,6 +1214,8 @@ repeat_discovery:
>  				"ENTERING STANDBY STATE");
>  		/* notify master SM about us */
>  		osm_send_trap144(sm, 0);
> +		osm_opensm_report_event(sm->p_subn->p_osm,
> +				OSM_EVENT_ID_STATE_CHANGE, NULL);

Ditto.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
