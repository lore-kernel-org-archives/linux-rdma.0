From: Line Holen <line.holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH opensm] osm_sm_state_mgr.c: Fix race condition during
 sm_state_mgr_send_master_sm_info_req
Date: Thu, 05 Dec 2013 11:20:39 +0100
Message-ID: <52A05377.5070606@oracle.com>
References: <529DDBB2.80309@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <529DDBB2.80309-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Acked-by: Line Holen<Line.Holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

On 12/03/13 14:25, Hal Rosenstock wrote:
> From: Daniel Klein<danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> When OpenSM changes SM state from standby to master, it sets m->p_polling_sm
> to NULL.
>
> When this occurs while calling sm_state_mgr_send_master_sm_info_req, it can
> result in a segmentation fault.
>
> Signed-off-by: Daniel Klein<danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Hal Rosenstock<hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
> diff --git a/opensm/osm_sm_state_mgr.c b/opensm/osm_sm_state_mgr.c
> index 596ad8f..770c5f9 100644
> --- a/opensm/osm_sm_state_mgr.c
> +++ b/opensm/osm_sm_state_mgr.c
> @@ -74,7 +74,7 @@ void osm_report_sm_state(osm_sm_t * sm)
>   	OSM_LOG_MSG_BOX(sm->p_log, OSM_LOG_VERBOSE, buf);
>   }
>
> -static void sm_state_mgr_send_master_sm_info_req(osm_sm_t * sm)
> +static void sm_state_mgr_send_master_sm_info_req(osm_sm_t * sm, uint8_t sm_state)
>   {
>   	osm_madw_context_t context;
>   	const osm_port_t *p_port;
> @@ -85,8 +85,7 @@ static void sm_state_mgr_send_master_sm_info_req(osm_sm_t * sm)
>   	OSM_LOG_ENTER(sm->p_log);
>
>   	memset(&context, 0, sizeof(context));
> -	CL_PLOCK_ACQUIRE(sm->p_lock);
> -	if (sm->p_subn->sm_state == IB_SMINFO_STATE_STANDBY) {
> +	if (sm_state == IB_SMINFO_STATE_STANDBY) {
>   		/*
>   		 * We are in STANDBY state - this means we need to poll the
>   		 * master SM (according to master_guid).
> @@ -104,13 +103,19 @@ static void sm_state_mgr_send_master_sm_info_req(osm_sm_t * sm)
>   		guid = sm->p_polling_sm->smi.guid;
>   	}
>
> +	/* Verify that SM is not polling itself */
> +	if (guid == sm->p_subn->sm_port_guid) {
> +		OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
> +			"OpenSM doesn't poll itself\n");
> +		goto Exit;
> +	}
> +
>   	p_port = osm_get_port_by_guid(sm->p_subn, guid);
>
>   	if (p_port == NULL) {
>   		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 3203: "
>   			"No port object for GUID 0x%016" PRIx64 "\n",
>   			cl_ntoh64(guid));
> -		CL_PLOCK_RELEASE(sm->p_lock);
>   		goto Exit;
>   	}
>
> @@ -122,7 +127,6 @@ static void sm_state_mgr_send_master_sm_info_req(osm_sm_t * sm)
>   			     IB_MAD_ATTR_SM_INFO, 0, FALSE,
>   			     ib_port_info_get_m_key(&p_port->p_physp->port_info),
>   			     CL_DISP_MSGID_NONE,&context);
> -	CL_PLOCK_RELEASE(sm->p_lock);
>
>   	if (status != IB_SUCCESS)
>   		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 3204: "
> @@ -135,7 +139,7 @@ Exit:
>
>   static void sm_state_mgr_start_polling(osm_sm_t * sm)
>   {
> -	uint32_t timeout = sm->p_subn->opt.sminfo_polling_timeout;
> +	uint32_t timeout;
>   	cl_status_t cl_status;
>
>   	OSM_LOG_ENTER(sm->p_log);
> @@ -148,7 +152,10 @@ static void sm_state_mgr_start_polling(osm_sm_t * sm)
>   	/*
>   	 * Send a SubnGet(SMInfo) query to the current (or new) master found.
>   	 */
> -	sm_state_mgr_send_master_sm_info_req(sm);
> +	CL_PLOCK_ACQUIRE(sm->p_lock);
> +	timeout = sm->p_subn->opt.sminfo_polling_timeout;
> +	sm_state_mgr_send_master_sm_info_req(sm, sm->p_subn->sm_state);
> +	CL_PLOCK_RELEASE(sm->p_lock);
>
>   	/*
>   	 * Start a timer that will wake up every sminfo_polling_timeout milliseconds.
> @@ -166,21 +173,31 @@ static void sm_state_mgr_start_polling(osm_sm_t * sm)
>   void osm_sm_state_mgr_polling_callback(IN void *context)
>   {
>   	osm_sm_t *sm = context;
> -	uint32_t timeout = sm->p_subn->opt.sminfo_polling_timeout;
> +	uint32_t timeout;
>   	cl_status_t cl_status;
> +	uint8_t sm_state;
>
>   	OSM_LOG_ENTER(sm->p_log);
>
> +	cl_spinlock_acquire(&sm->state_lock);
> +	sm_state = sm->p_subn->sm_state;
> +	cl_spinlock_release(&sm->state_lock);
> +
> +	CL_PLOCK_ACQUIRE(sm->p_lock);
> +	timeout = sm->p_subn->opt.sminfo_polling_timeout;
> +
>   	/*
>   	 * We can be here in one of two cases:
>   	 * 1. We are a STANDBY sm polling on the master SM.
>   	 * 2. We are a MASTER sm, waiting for a handover from a remote master sm.
>   	 * If we are not in one of these cases - don't need to restart the poller.
>   	 */
> -	if (!((sm->p_subn->sm_state == IB_SMINFO_STATE_MASTER&&
> +	if (!((sm_state == IB_SMINFO_STATE_MASTER&&
>   	sm->p_polling_sm != NULL) ||
> -	      sm->p_subn->sm_state == IB_SMINFO_STATE_STANDBY))
> +	      sm_state == IB_SMINFO_STATE_STANDBY)) {
> +		CL_PLOCK_RELEASE(sm->p_lock);
>   		goto Exit;
> +	}
>
>   	/*
>   	 * If we are a STANDBY sm and the osm_exit_flag is set, then let's
> @@ -189,7 +206,8 @@ void osm_sm_state_mgr_polling_callback(IN void *context)
>   	 * received. In other cases - it is not relevant whether or not the
>   	 * signal is on - since we are currently in exit flow
>   	 */
> -	if (sm->p_subn->sm_state == IB_SMINFO_STATE_STANDBY&&  osm_exit_flag) {
> +	if (sm_state == IB_SMINFO_STATE_STANDBY&&  osm_exit_flag) {
> +		CL_PLOCK_RELEASE(sm->p_lock);
>   		OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
>   			"Signalling subnet_up_event\n");
>   		cl_event_signal(&sm->subnet_up_event);
> @@ -207,6 +225,7 @@ void osm_sm_state_mgr_polling_callback(IN void *context)
>   		sm->retry_number);
>
>   	if (sm->retry_number>= sm->p_subn->opt.polling_retry_number) {
> +		CL_PLOCK_RELEASE(sm->p_lock);
>   		OSM_LOG(sm->p_log, OSM_LOG_DEBUG,
>   			"Reached polling_retry_number value in retry_number. "
>   			"Go to DISCOVERY state\n");
> @@ -215,7 +234,9 @@ void osm_sm_state_mgr_polling_callback(IN void *context)
>   	}
>
>   	/* Send a SubnGet(SMInfo) request to the remote sm (depends on our state) */
> -	sm_state_mgr_send_master_sm_info_req(sm);
> +	sm_state_mgr_send_master_sm_info_req(sm, sm_state);
> +
> +	CL_PLOCK_RELEASE(sm->p_lock);
>
>   	/* restart the timer */
>   	cl_status = cl_timer_start(&sm->polling_timer, timeout);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
