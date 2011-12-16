From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] opensm/libvendor/osm_vendor_ibumad.c: Fix DR path
 printing on send timeouts
Date: Fri, 16 Dec 2011 11:51:25 -0800
Message-ID: <20111216115125.68c52d60.weiny2@llnl.gov>
References: <4EEB9B06.8090908@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4EEB9B06.8090908-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 16 Dec 2011 11:24:54 -0800
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> 
> Also, make log_send_error into a routine and also call when MAD is cancelled.
> 
> This patch is an alternative to Ira's v4 patch entitled 
> "opensm: Move Error printing to MAD error call back functions"
> which pushes this functionality up into the send error callbacks.
> 
> This patch is currently compile tested only.
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

I think this is acceptable as well.  My main need was to report which request MAD did not get a response.  I will test when I get back on the system which was having the issues.

Acked-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>

> ---
> diff --git a/libvendor/osm_vendor_ibumad.c b/libvendor/osm_vendor_ibumad.c
> index e2ebd8e..3781792 100644
> --- a/libvendor/osm_vendor_ibumad.c
> +++ b/libvendor/osm_vendor_ibumad.c
> @@ -98,6 +98,37 @@ typedef struct _umad_receiver {
>  
>  static void osm_vendor_close_port(osm_vendor_t * const p_vend);
>  
> +static void log_send_error(osm_vendor_t * const p_vend, osm_madw_t *p_madw)
> +{
> +	if (p_madw->p_mad->mgmt_class != IB_MCLASS_SUBN_DIR) {
> +		/* LID routed */
> +		OSM_LOG(p_vend->p_log, OSM_LOG_ERROR, "ERR 5410: "
> +			"Send completed with error (%s) -- dropping\n"
> +			"\t\t\tClass 0x%x, Method 0x%X, Attr 0x%X, "
> +			"TID 0x%" PRIx64 ", LID %u\n",
> +			ib_get_err_str(p_madw->status),
> +			p_madw->p_mad->mgmt_class, p_madw->p_mad->method,
> +			cl_ntoh16(p_madw->p_mad->attr_id),
> +			cl_ntoh64(p_madw->p_mad->trans_id),
> +			cl_ntoh16(p_madw->mad_addr.dest_lid));
> +	} else {
> +		ib_smp_t *p_smp;
> +
> +		/* Direct routed SMP */
> +		p_smp = osm_madw_get_smp_ptr(p_madw);
> +		OSM_LOG(p_vend->p_log, OSM_LOG_ERROR, "ERR 5411: "
> +			"DR SMP Send completed with error (%s) -- dropping\n"
> +			"\t\t\tMethod 0x%X, Attr 0x%X, TID 0x%" PRIx64
> +			", Hop Ptr: 0x%X\n",
> +			ib_get_err_str(p_madw->status),
> +			p_madw->p_mad->method,
> +			cl_ntoh16(p_madw->p_mad->attr_id),
> +			cl_ntoh64(p_madw->p_mad->trans_id),
> +			p_smp->hop_ptr);
> +		osm_dump_smp_dr_path(p_vend->p_log, p_smp, OSM_LOG_ERROR);
> +	}
> +}
> +
>  static void clear_madw(osm_vendor_t * p_vend)
>  {
>  	umad_match_t *m, *e, *old_m;
> @@ -185,6 +216,7 @@ put_madw(osm_vendor_t * p_vend, osm_madw_t * p_madw, ib_net64_t tid)
>  	p_req_madw = old_lru->v;
>  	p_bind = p_req_madw->h_bind;
>  	p_req_madw->status = IB_CANCELED;
> +	log_send_error(p_vend, p_req_madw);
>  	pthread_mutex_lock(&p_vend->cb_mutex);
>  	(*p_bind->send_err_callback) (p_bind->client_context, p_req_madw);
>  	pthread_mutex_unlock(&p_vend->cb_mutex);
> @@ -326,32 +358,6 @@ static void *umad_receiver(void *p_ptr)
>  
>  		/* if status != 0 then we are handling recv timeout on send */
>  		if (umad_status(p_madw->vend_wrap.umad)) {
> -
> -			if (mad->mgmt_class != IB_MCLASS_SUBN_DIR) {
> -				/* LID routed */
> -				OSM_LOG(p_vend->p_log, OSM_LOG_ERROR, "ERR 5410: "
> -					"Send completed with error -- dropping\n"
> -					"\t\t\tClass 0x%x, Method 0x%X, Attr 0x%X, "
> -					"TID 0x%" PRIx64 ", LID %u\n",
> -					mad->mgmt_class, mad->method,
> -					cl_ntoh16(mad->attr_id),
> -					cl_ntoh64(mad->trans_id),
> -					cl_ntoh16(ib_mad_addr->lid));
> -			} else {
> -				ib_smp_t *smp;
> -
> -				/* Direct routed SMP */
> -				smp = (ib_smp_t *) mad;
> -				OSM_LOG(p_vend->p_log, OSM_LOG_ERROR, "ERR 5411: "
> -					"DR SMP Send completed with error -- dropping\n"
> -					"\t\t\tMethod 0x%X, Attr 0x%X, TID 0x%" PRIx64
> -					", Hop Ptr: 0x%X\n",
> -					mad->method, cl_ntoh16(mad->attr_id),
> -					cl_ntoh64(mad->trans_id), smp->hop_ptr);
> -				osm_dump_smp_dr_path(p_vend->p_log, smp,
> -						     OSM_LOG_ERROR);
> -			}
> -
>  			if (!(p_req_madw = get_madw(p_vend, &mad->trans_id))) {
>  				OSM_LOG(p_vend->p_log, OSM_LOG_ERROR,
>  					"ERR 5412: "
> @@ -361,6 +367,7 @@ static void *umad_receiver(void *p_ptr)
>  					cl_ntoh64(mad->trans_id));
>  			} else {
>  				p_req_madw->status = IB_TIMEOUT;
> +				log_send_error(p_vend, p_req_madw);
>  				/* cb frees req_madw */
>  				pthread_mutex_lock(&p_vend->cb_mutex);
>  				pthread_cleanup_push(unlock_mutex,


-- 
Ira Weiny
Member of Technical Staff
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
