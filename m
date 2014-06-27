From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 3/3] opensm/osm_perfmgr.c: Fix perfmgr sweep_state race
Date: Fri, 27 Jun 2014 17:36:14 -0400
Message-ID: <53ADE3CE.3090606@dev.mellanox.co.il>
References: <1403891774.30332.421.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1403891774.30332.421.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Susan Coulter (skc-YOWKrPYUwWM@public.gmane.org)" <skc-YOWKrPYUwWM@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 6/27/2014 1:56 PM, Albert Chu wrote:
> Introduce new sweep state PERFMGR_SWEEP_POST_PROCESSING to fix
> race in perfmgr.
> 
> Race occurs as follows:

Nice find!

> 
> Under typical conditions, osm_perfmgr_process() is entered
> with sweep_state set to PERFMGR_SWEEP_SLEEP.  osm_perfmgr_process()
> sets sweep_state to PERFMGR_SWEEP_ACTIVE when it begins to sweep.
> 
> osm_perfmgr_process() will eventually call perfmgr_send_mad() by
> way of perfmgr_query_counters() and several other functions.
> 
> Responses to performance counter MADs may initiate the sending
> of more MADs via perfmgr_send_mad(), such as through redirection
> or the desire to clear counters.
> 
> If too many MADs have been put on the wire, perfmgr_send_mad()
> will throttle sending out MADS and temporarily change sweep_state
> between PERFMGR_SWEEP_SUSPENDED and PERFMGR_SWEEP_ACTIVE as it
> throttles.  The sweep_state is set to PERFMGR_SWEEP_ACTIVE
> when all performance counter MADs have been sent out by the sweeper.
> 
> osm_perfmgr_process() eventually completes its sweep and puts
> sweep_state back into PERFMGR_SWEEP_SLEEP.
> 
> At this point, some MADs may still be on the wire.  New MADs may be
> put back on the wire if responses necessitate it (redirection or
> clearing counters).  If enough MADs are put back onto the wire,
> perfmgr_send_mad() will throttle as normal, temporarily moving
> between PERFMGR_SWEEP_SUSPENDED and PERFMGR_SWEEP_ACTIVE.  After
> the throttling is complete, sweep_state is put into
> PERFMGR_SWEEP_ACTIVE state.
> 
> This is the key problem, the sweep_state is changed from
> PERFMGR_SWEEP_SLEEP to PERFMGR_SWEEP_ACTIVE outside of
> osm_perfmgr_process().
> 
> Now that the perfmgr is in ACTIVE state, any future sweep call to
> osm_perfmgr_process() will not sweep b/c the sweep_state is set
> to PERFMGR_SWEEP_ACTIVE.
> 
> The introduction of a new sweep_state PERFMGR_SWEEP_POST_PROCESSING
> fixes this problem.
> 
> If perfmgr_send_mad() throttles mads while in PERFMGR_SWEEP_SLEEP.
> sweep_state will be moved into the PERFMGR_SWEEP_POST_PROCESSING
> state instead of PERFMGR_SWEEP_SUSPENDED/PERFMGR_SWEEP_ACTIVE.
> 
> When all post-SLEEP state MAD processing is complete, the sweep_state
> will move from PERFMGR_SWEEP_POST_PROCESSING back to PERFMGR_SWEEP_SLEEP,
> so that future sweeps can operate as normal.
> 
> Signed-off-by: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>
> ---
>  include/opensm/osm_perfmgr.h |    6 +++++-
>  opensm/osm_perfmgr.c         |   21 +++++++++++++++++++--
>  2 files changed, 24 insertions(+), 3 deletions(-)
> 
> diff --git a/include/opensm/osm_perfmgr.h b/include/opensm/osm_perfmgr.h
> index ab02c26..44a278d 100644
> --- a/include/opensm/osm_perfmgr.h
> +++ b/include/opensm/osm_perfmgr.h
> @@ -88,7 +88,8 @@ typedef enum {
>  typedef enum {
>  	PERFMGR_SWEEP_SLEEP,
>  	PERFMGR_SWEEP_ACTIVE,
> -	PERFMGR_SWEEP_SUSPENDED
> +	PERFMGR_SWEEP_SUSPENDED,
> +	PERFMGR_SWEEP_POST_PROCESSING
>  } osm_perfmgr_sweep_state_t;
>  
>  typedef struct monitored_port {
> @@ -239,6 +240,9 @@ inline static const char *osm_perfmgr_get_sweep_state_str(osm_perfmgr_t * perfmg
>  	case PERFMGR_SWEEP_SUSPENDED:
>  		return "Suspended";
>  		break;
> +	case PERFMGR_SWEEP_POST_PROCESSING:
> +		return "PostProcessing";
> +		break;
>  	}
>  	return "UNKNOWN";
>  }
> diff --git a/opensm/osm_perfmgr.c b/opensm/osm_perfmgr.c
> index bfa63dc..863e9bf 100644
> --- a/opensm/osm_perfmgr.c
> +++ b/opensm/osm_perfmgr.c
> @@ -164,6 +164,16 @@ static inline void decrement_outstanding_queries(osm_perfmgr_t * pm)
>  {
>  	cl_atomic_dec(&pm->outstanding_queries);
>  	cl_event_signal(&pm->sig_query);
> +
> +	if (!pm->outstanding_queries) {
> +		cl_spinlock_acquire(&pm->lock);
> +		if (pm->sweep_state == PERFMGR_SWEEP_POST_PROCESSING) {
> +			pm->sweep_state = PERFMGR_SWEEP_SLEEP;
> +			OSM_LOG(pm->log, OSM_LOG_INFO,
> +				"PM sweep state exiting Post Processing\n");
> +		}
> +		cl_spinlock_release(&pm->lock);
> +	}

Shouldn't this potential sweep state update occur prior to the event
being signaled ?

-- Hal

>  }
>  
>  /**********************************************************************
> @@ -439,7 +449,13 @@ static ib_api_status_t perfmgr_send_mad(osm_perfmgr_t *perfmgr,
>  		while (perfmgr->outstanding_queries >
>  		       (int32_t)perfmgr->max_outstanding_queries) {
>  			cl_spinlock_acquire(&perfmgr->lock);
> -			perfmgr->sweep_state = PERFMGR_SWEEP_SUSPENDED;
> +			if (perfmgr->sweep_state == PERFMGR_SWEEP_SLEEP) {
> +				perfmgr->sweep_state = PERFMGR_SWEEP_POST_PROCESSING;
> +				OSM_LOG(perfmgr->log, OSM_LOG_INFO,
> +					"PM sweep state going into Post Processing\n");
> +			}
> +			else if (perfmgr->sweep_state == PERFMGR_SWEEP_ACTIVE)
> +				perfmgr->sweep_state = PERFMGR_SWEEP_SUSPENDED;
>  			cl_spinlock_release(&perfmgr->lock);
>  wait:
>  			sts = cl_event_wait_on(&perfmgr->sig_query,
> @@ -1015,7 +1031,8 @@ void osm_perfmgr_process(osm_perfmgr_t * pm)
>  
>  	cl_spinlock_acquire(&pm->lock);
>  	if (pm->sweep_state == PERFMGR_SWEEP_ACTIVE ||
> -	    pm->sweep_state == PERFMGR_SWEEP_SUSPENDED) {
> +	    pm->sweep_state == PERFMGR_SWEEP_SUSPENDED ||
> +	    pm->sweep_state == PERFMGR_SWEEP_POST_PROCESSING) {
>  		cl_spinlock_release(&pm->lock);
>  		OSM_LOG(pm->log, OSM_LOG_INFO,
>  			"PM sweep state %d, skipping sweep\n",

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
