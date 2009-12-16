From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_vl15intf.c: Fix transaction ID printing in
 vl15_send_mad
Date: Wed, 16 Dec 2009 14:05:00 +0200
Message-ID: <4B28CCEC.9010805@dev.mellanox.co.il>
References: <20091216115732.GA21723@comcast.net>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091216115732.GA21723-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Cc: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org, Line.Holen-xsfywfwIY+M@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 16/Dec/09 13:57, Hal Rosenstock wrote:
>
> opensm/osm_vl15intf.c: Fix transaction ID printing in vl15_send_mad
>
> Rather than reverting commit 546399c3b983cdfe7adf4bd0b179358744603478,
> another alternative is to save off the transaction ID prior to
> sending the MAD.

Right, this one is much better :)

-- Yevgeny

> This resolves OpenSM crash when accessing fields of mad that has already
> been returned to the pool.
>
> Signed-off-by: Hal Rosenstock<hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> diff --git a/opensm/opensm/osm_vl15intf.c b/opensm/opensm/osm_vl15intf.c
> index cc3ff33..ec7dadf 100644
> --- a/opensm/opensm/osm_vl15intf.c
> +++ b/opensm/opensm/osm_vl15intf.c
> @@ -3,6 +3,7 @@
>    * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
>    * Copyright (c) 2002-2006 Mellanox Technologies LTD. All rights reserved.
>    * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
> + * Copyright (c) 2009 HNR Consulting. All rights reserved.
>    *
>    * This software is available to you under a choice of one of two
>    * licenses.  You may choose to be licensed under the terms of the GNU
> @@ -57,6 +58,7 @@
>   static void vl15_send_mad(osm_vl15_t * p_vl, osm_madw_t * p_madw)
>   {
>   	ib_api_status_t status;
> +	ib_net64_t trans_id;
>
>   	/*
>   	   Non-response-expected mads are not throttled on the wire
> @@ -76,6 +78,7 @@ static void vl15_send_mad(osm_vl15_t * p_vl, osm_madw_t * p_madw)
>   		cl_atomic_inc(&p_vl->p_stats->qp0_unicasts_sent);
>
>   	cl_atomic_inc(&p_vl->p_stats->qp0_mads_sent);
> +	trans_id = p_madw->p_mad->trans_id;
>
>   	status = osm_vendor_send(osm_madw_get_bind_handle(p_madw),
>   				 p_madw, p_madw->resp_expected);
> @@ -93,7 +96,7 @@ static void vl15_send_mad(osm_vl15_t * p_vl, osm_madw_t * p_madw)
>
>   	OSM_LOG(p_vl->p_log, OSM_LOG_ERROR, "ERR 3E03: "
>   		"MAD send failed (%s), TID 0x%" PRIx64 "\n",
> -		ib_get_err_str(status), cl_ntoh64(p_madw->p_mad->trans_id));
> +		ib_get_err_str(status), cl_ntoh64(trans_id));
>
>   	/*
>   	   The MAD was never successfully sent, so
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
