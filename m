From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] opensm: on MAD error call back print DR PATH or LID of
 request MAD
Date: Wed, 14 Dec 2011 21:21:28 -0500
Message-ID: <4EE959A8.3000409@dev.mellanox.co.il>
References: <20111213210918.9cf79850.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111213210918.9cf79850.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/14/2011 12:09 AM, Ira Weiny wrote:
> 
> In addition print transaction ID of all DR PATH dumps to make sure we know
> which MAD's they refer to.
> 
> Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> ---
>  opensm/osm_helper.c      |    5 +++--
>  opensm/osm_sm_mad_ctrl.c |    7 +++++++
>  2 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/opensm/osm_helper.c b/opensm/osm_helper.c
> index f9f3d9d..b6591c4 100644
> --- a/opensm/osm_helper.c
> +++ b/opensm/osm_helper.c
> @@ -2059,8 +2059,9 @@ void osm_dump_smp_dr_path(IN osm_log_t * p_log, IN const ib_smp_t * p_smp,
>  		char buf[BUF_SIZE];
>  		unsigned n;
>  
> -		n = sprintf(buf, "Received SMP on a %u hop path: "
> -			    "Initial path = ", p_smp->hop_count);
> +		n = sprintf(buf, "Received SMP (TID 0x%" PRIx64 ") on a %u hop path: "
> +			    "Initial path = ",
> +			    cl_ntoh64(p_smp->trans_id), p_smp->hop_count);
>  		n += sprint_uint8_arr(buf + n, sizeof(buf) - n,
>  				      p_smp->initial_path,
>  				      p_smp->hop_count + 1);
> diff --git a/opensm/osm_sm_mad_ctrl.c b/opensm/osm_sm_mad_ctrl.c
> index ee92c66..6abf8b8 100644
> --- a/opensm/osm_sm_mad_ctrl.c
> +++ b/opensm/osm_sm_mad_ctrl.c
> @@ -721,6 +721,13 @@ static void sm_mad_ctrl_send_err_cb(IN void *context, IN osm_madw_t * p_madw)
>  		ib_get_sm_attr_str(p_smp->attr_id), cl_ntoh32(p_smp->attr_mod),
>  		cl_ntoh64(p_smp->trans_id));
>  
> +	if (p_smp->mgmt_class == IB_MCLASS_SUBN_DIR) {
> +		osm_dump_smp_dr_path(p_ctrl->p_log, p_smp, OSM_LOG_ERROR);

Rather than here, should this be in osm_vendor_ibumad.c ? There's
already one similar log there but looks like evicted entry logging was
not done. If not, then do any logs there need to be removed as redundant ?

Also, does this log every timeout (at error level) ? If so, that might
not be a good thing in all subnets as timeouts are common.

> +	} else {
> +		OSM_LOG(p_ctrl->p_log, OSM_LOG_ERROR, "LID %u\n",
> +			cl_ntoh16(p_madw->mad_addr.dest_lid));

Log the TID here too ?

-- Hal

> +	}
> +
>  	/*
>  	   If this was a SubnSet MAD, then this error might indicate a problem
>  	   in configuring the subnet. In this case - need to mark that there was

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
