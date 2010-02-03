From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm: bug in trap report for MC create(66) and
 delete(67) traps
Date: Wed, 3 Feb 2010 11:49:23 +0200
Message-ID: <20100203094923.GQ26338@me>
References: <4B6832F8.9090200@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4B6832F8.9090200-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vladimir Koushnir <vladimirk-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Eli,

On 16:13 Tue 02 Feb     , Eli Dorfman (Voltaire) wrote:
> 
> In this case the GID in the data details is the MGID and
> not the source gid. So the SM gid should be taken as the source gid.

There the source port is detected in order P_Key matching check between
source and trap destination port.

So in case of 66,67 trap you will just check P_Key match between trap
destination port and SM port, which is likely useless due to fact of
already working SA communication between both.

What should be really checked in this case is a good question. At least
I cannot find some explicit explanations in the spec.

I would guess that the needed check is that trap destination port has MC
group's P_Key (as present in MCMember Record) value.

Thoughts?

> There was also an error in comparing the subnet prefix and guid due to
> host/network order mismatch.

Agree about this.

> 
> Signed-off-by: Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>
> ---
>  opensm/opensm/osm_inform.c |   19 +++++++++----------
>  1 files changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/opensm/opensm/osm_inform.c b/opensm/opensm/osm_inform.c
> index 8108213..5f48376 100644
> --- a/opensm/opensm/osm_inform.c
> +++ b/opensm/opensm/osm_inform.c
> @@ -460,18 +460,16 @@ static void match_notice_to_inf_rec(IN cl_list_item_t * p_list_item,
>  		}
>  	}
>  
> -	/* Check if there is a pkey match. o13-17.1.1 */
> -	/* Check if the issuer of the trap is the SM. If it is, then the gid
> +	/* In case of GID IN(64) or GID OUT(65) traps the source gid
>  	   comparison should be done on the trap source (saved as the gid in the
>  	   data details field).
> -	   If the issuer gid is not the SM - then it is the guid of the trap
> -	   source */
> -	if ((cl_ntoh64(p_ntc->issuer_gid.unicast.prefix) ==
> -	     p_subn->opt.subnet_prefix)
> -	    && (cl_ntoh64(p_ntc->issuer_gid.unicast.interface_id) ==
> -		p_subn->sm_port_guid))
> -		/* The issuer is the SM then this is trap 64-67 - compare the gid
> -		   with the gid saved on the data details */
> +	   In all other cases the issuer gis is the trap source.
> +	   This is also the case for MC CREATE(66) and MC DELETE(67) where the
> +	   data details gid is MGID */
> +	if (p_ntc->g_or_v.generic.trap_num == 64 ||
> +	    p_ntc->g_or_v.generic.trap_num == 65 )

ib_mad_notice_attr_t.g_or_v.generic.trap_num is encoded in network byte
order.

Sasha

> +		/* The issuer of these traps is the SM so source_gid 
> +		   is the gid saved on the data details */
>  		source_gid = p_ntc->data_details.ntc_64_67.gid;
>  	else
>  		source_gid = p_ntc->issuer_gid;
> @@ -495,6 +493,7 @@ static void match_notice_to_inf_rec(IN cl_list_item_t * p_list_item,
>  		goto Exit;
>  	}
>  
> +	/* Check if there is a pkey match. o13-17.1.1 */
>  	if (osm_port_share_pkey(p_log, p_src_port, p_dest_port) == FALSE) {
>  		OSM_LOG(p_log, OSM_LOG_DEBUG, "Mismatch by Pkey\n");
>  		/* According to o13-17.1.2 - If this informInfo does not have
> -- 
> 1.5.5
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
