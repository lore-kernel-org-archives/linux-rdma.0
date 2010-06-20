From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v4] opensm/osmeventplugin: added new events to monitor
 SM
Date: Sun, 20 Jun 2010 13:05:48 +0300
Message-ID: <4C1DE7FC.1050301@dev.mellanox.co.il>
References: <4C1DDFF7.8080103@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C1DDFF7.8080103-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 20-Jun-10 12:31 PM, Yevgeny Kliteynik wrote:
> Adding new events that allow event plug-in to see
> when SM finishes heavy sweep and routing configuration,
> when it updates dump files, when it is no longer master,
> when SM port is down, and when SA DB is actually dumped
> at the end of light sweep:
>
>    OSM_EVENT_ID_HEAVY_SWEEP_DONE
>    OSM_EVENT_ID_UCAST_ROUTING_DONE
>    OSM_EVENT_ID_STATE_CHANGE
>    OSM_EVENT_ID_SA_DB_DUMPED
>
> Signed-off-by: Yevgeny Kliteynik<kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> ---
>
> Changes since v3:
>   - OSM_EVENT_ID_ENTERING_STANDBY and OSM_EVENT_ID_SM_PORT_DOWN
>     replaced by OSM_EVENT_STATE_CHANGE
>   - OSM_EVENT_ID_SA_DB_DUMPED is not reported during
>     heavy sweep, but only if SA DB was actually dumped

Nope, still reported during heavy sweep. V5 is on its way...

-- Yevgeny

>     at the end of light sweep
>   - fixed bug with OSM_EVENT_ID_MAX
>
>   opensm/include/opensm/osm_event_plugin.h   |    4 ++++
>   opensm/opensm/osm_state_mgr.c              |   22 +++++++++++++++++++---
>   opensm/osmeventplugin/src/osmeventplugin.c |   14 ++++++++++++++
>   3 files changed, 37 insertions(+), 3 deletions(-)
>
> diff --git a/opensm/include/opensm/osm_event_plugin.h b/opensm/include/opensm/osm_event_plugin.h
> index 33d1920..0b3464e 100644
> --- a/opensm/include/opensm/osm_event_plugin.h
> +++ b/opensm/include/opensm/osm_event_plugin.h
> @@ -72,6 +72,10 @@ typedef enum {
>   	OSM_EVENT_ID_PORT_SELECT,
>   	OSM_EVENT_ID_TRAP,
>   	OSM_EVENT_ID_SUBNET_UP,
> +	OSM_EVENT_ID_HEAVY_SWEEP_DONE,
> +	OSM_EVENT_ID_UCAST_ROUTING_DONE,
> +	OSM_EVENT_ID_STATE_CHANGE,
> +	OSM_EVENT_ID_SA_DB_DUMPED,
>   	OSM_EVENT_ID_MAX
>   } osm_epi_event_id_t;
>
> diff --git a/opensm/opensm/osm_state_mgr.c b/opensm/opensm/osm_state_mgr.c
> index 81c8f54..be6e67d 100644
> --- a/opensm/opensm/osm_state_mgr.c
> +++ b/opensm/opensm/osm_state_mgr.c
> @@ -1107,8 +1107,10 @@ static void do_sweep(osm_sm_t * sm)
>   		if (wait_for_pending_transactions(&sm->p_subn->p_osm->stats))
>   			return;
>   		if (!sm->p_subn->force_heavy_sweep) {
> -			if (sm->p_subn->opt.sa_db_dump)
> -				osm_sa_db_file_dump(sm->p_subn->p_osm);
> +			if (sm->p_subn->opt.sa_db_dump&&
> +			    !osm_sa_db_file_dump(sm->p_subn->p_osm))
> +				osm_opensm_report_event(sm->p_subn->p_osm,
> +					OSM_EVENT_ID_SA_DB_DUMPED, NULL);
>   			OSM_LOG_MSG_BOX(sm->p_log, OSM_LOG_VERBOSE,
>   					"LIGHT SWEEP COMPLETE");
>   			return;
> @@ -1151,6 +1153,8 @@ static void do_sweep(osm_sm_t * sm)
>   		if (!sm->p_subn->subnet_initialization_error) {
>   			OSM_LOG_MSG_BOX(sm->p_log, OSM_LOG_VERBOSE,
>   					"REROUTE COMPLETE");
> +			osm_opensm_report_event(sm->p_subn->p_osm,
> +				OSM_EVENT_ID_UCAST_ROUTING_DONE, NULL);
>   			return;
>   		}
>   	}
> @@ -1185,6 +1189,8 @@ repeat_discovery:
>
>   		/* Move to DISCOVERING state */
>   		osm_sm_state_mgr_process(sm, OSM_SM_SIGNAL_DISCOVER);
> +		osm_opensm_report_event(sm->p_subn->p_osm,
> +				OSM_EVENT_ID_STATE_CHANGE, NULL);
>   		return;
>   	}
>
> @@ -1205,6 +1211,8 @@ repeat_discovery:
>   				"ENTERING STANDBY STATE");
>   		/* notify master SM about us */
>   		osm_send_trap144(sm, 0);
> +		osm_opensm_report_event(sm->p_subn->p_osm,
> +				OSM_EVENT_ID_STATE_CHANGE, NULL);
>   		return;
>   	}
>
> @@ -1212,6 +1220,9 @@ repeat_discovery:
>   	if (sm->p_subn->force_heavy_sweep)
>   		goto repeat_discovery;
>
> +	osm_opensm_report_event(sm->p_subn->p_osm,
> +				OSM_EVENT_ID_HEAVY_SWEEP_DONE, NULL);
> +
>   	OSM_LOG_MSG_BOX(sm->p_log, OSM_LOG_VERBOSE, "HEAVY SWEEP COMPLETE");
>
>   	/* If we are MASTER - get the highest remote_sm, and
> @@ -1314,6 +1325,8 @@ repeat_discovery:
>
>   	OSM_LOG_MSG_BOX(sm->p_log, OSM_LOG_VERBOSE,
>   			"SWITCHES CONFIGURED FOR UNICAST");
> +	osm_opensm_report_event(sm->p_subn->p_osm,
> +			OSM_EVENT_ID_UCAST_ROUTING_DONE, NULL);
>
>   	if (!sm->p_subn->opt.disable_multicast) {
>   		osm_mcast_mgr_process(sm);
> @@ -1375,7 +1388,10 @@ repeat_discovery:
>
>   		if (osm_log_is_active(sm->p_log, OSM_LOG_VERBOSE) ||
>   		    sm->p_subn->opt.sa_db_dump)
> -			osm_sa_db_file_dump(sm->p_subn->p_osm);
> +			if (!osm_sa_db_file_dump(sm->p_subn->p_osm))
> +				osm_opensm_report_event(sm->p_subn->p_osm,
> +					OSM_EVENT_ID_SA_DB_DUMPED, NULL);
> +
>   	}
>
>   	/*
> diff --git a/opensm/osmeventplugin/src/osmeventplugin.c b/opensm/osmeventplugin/src/osmeventplugin.c
> index b4d9ce9..ea3b9a5 100644
> --- a/opensm/osmeventplugin/src/osmeventplugin.c
> +++ b/opensm/osmeventplugin/src/osmeventplugin.c
> @@ -49,6 +49,8 @@
>   #include<opensm/osm_opensm.h>
>   #include<opensm/osm_log.h>
>
> +#include "opensm/osm_event_plugin.h"
> +
>   /** =========================================================================
>    * This is a simple example plugin which logs some of the events the OSM
>    * generates to this interface.
> @@ -176,6 +178,18 @@ static void report(void *_log, osm_epi_event_id_t event_id, void *event_data)
>   	case OSM_EVENT_ID_SUBNET_UP:
>   		fprintf(log->log_file, "Subnet up reported\n");
>   		break;
> +	case OSM_EVENT_ID_HEAVY_SWEEP_DONE:
> +		fprintf(log->log_file, "Heavy sweep completed\n");
> +		break;
> +	case OSM_EVENT_ID_UCAST_ROUTING_DONE:
> +		fprintf(log->log_file, "Unicast routing completed\n");
> +		break;
> +	case OSM_EVENT_ID_STATE_CHANGE:
> +		fprintf(log->log_file, "SM state changed\n");
> +		break;
> +	case OSM_EVENT_ID_SA_DB_DUMPED:
> +		fprintf(log->log_file, "SA DB dump file updated\n");
> +		break;
>   	case OSM_EVENT_ID_MAX:
>   	default:
>   		osm_log(log->osmlog, OSM_LOG_ERROR,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
