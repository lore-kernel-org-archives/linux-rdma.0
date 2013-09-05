From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH][MINOR] osm_sa_informinfo.c Add attribute info to log
 messages
Date: Thu, 05 Sep 2013 10:18:22 -0400
Message-ID: <522892AE.8080801@dev.mellanox.co.il>
References: <a845067b-2e87-4bd0-bd60-e19a85f586bc@default>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <a845067b-2e87-4bd0-bd60-e19a85f586bc@default>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Line Holen <line.holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Linux-Rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 9/3/2013 7:31 AM, Line Holen wrote:
> Signed-off-by: Line Holen <line.holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Thanks. Applied with minor change noted below.

> 
> ---
> 
> diff --git a/opensm/osm_sa_informinfo.c b/opensm/osm_sa_informinfo.c
> index f32b88b..bf1fe97 100644
> --- a/opensm/osm_sa_informinfo.c
> +++ b/opensm/osm_sa_informinfo.c
> @@ -598,7 +598,8 @@ void osm_infr_rcv_process(IN void *context, IN void *data)
>  	CL_ASSERT(p_sa_mad->attr_id == IB_MAD_ATTR_INFORM_INFO);
>  
>  	if (p_sa_mad->method != IB_MAD_METHOD_SET) {
> -		OSM_LOG(sa->p_log, OSM_LOG_DEBUG, "Unsupported Method (%s)\n",
> +		OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
> +			"Unsupported Method (%s) for InformInfo\n",
>  			ib_get_sa_method_str(p_sa_mad->method));
>  		osm_sa_send_error(sa, p_madw, IB_MAD_STATUS_UNSUP_METHOD_ATTR);
>  		goto Exit;
> @@ -626,7 +627,8 @@ void osm_infir_rcv_process(IN void *context, IN void *data)
>  
>  	if (p_sa_mad->method != IB_MAD_METHOD_GET &&
>  	    p_sa_mad->method != IB_MAD_METHOD_GETTABLE) {
> -		OSM_LOG(sa->p_log, OSM_LOG_DEBUG, "Unsupported Method (%s)\n",
> +		OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
> +			"Unsupported Method (%s) for InformInfo\n",

InformInfoRecord r.t. InformInfo

-- Hal

>  			ib_get_sa_method_str(p_sa_mad->method));
>  		osm_sa_send_error(sa, p_madw, IB_MAD_STATUS_UNSUP_METHOD_ATTR);
>  		goto Exit;
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
