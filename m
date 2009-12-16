From: Line Holen <Line.Holen-UdXhSnd/wVw@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_vl15intf.c: reverting commit
 546399c3b983cdfe7adf4bd0b179358744603478
Date: Wed, 16 Dec 2009 11:20:25 +0100
Message-ID: <4B28B469.4060309@Sun.COM>
References: <4B28A235.9090900@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <4B28A235.9090900-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Ached-by: Line Holen <Line.Holen-xsfywfwIY+M@public.gmane.org>

On 12/16/09 10:02 AM, Yevgeny Kliteynik wrote:
> OSM crashes when accessing fields of mad that has already
> been returned to the pool.
> 
> Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> ---
>  opensm/opensm/osm_vl15intf.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/opensm/opensm/osm_vl15intf.c b/opensm/opensm/osm_vl15intf.c
> index e2b3888..005dbd0 100644
> --- a/opensm/opensm/osm_vl15intf.c
> +++ b/opensm/opensm/osm_vl15intf.c
> @@ -97,8 +97,7 @@ static void vl15_send_mad(osm_vl15_t * p_vl, osm_madw_t * p_madw,
>  	}
> 
>  	OSM_LOG(p_vl->p_log, OSM_LOG_ERROR, "ERR 3E03: "
> -		"MAD send failed (%s), TID 0x%" PRIx64 "\n",
> -		ib_get_err_str(status), cl_ntoh64(p_madw->p_mad->trans_id));
> +		"MAD send failed (%s)\n", ib_get_err_str(status));
> 
>  	/*
>  	   The MAD was never successfully sent, so

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
