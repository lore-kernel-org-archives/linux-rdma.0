From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_sa_mcmember_record.c: optimization in zero
 mgid comparison
Date: Mon, 2 Nov 2009 00:12:18 +0200
Message-ID: <20091101221218.GA1153@me>
References: <4AED56C0.4080006@dev.mellanox.co.il>
 <20091101160216.GF29434@me>
 <4AEDEEEB.8010401@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4AEDEEEB.8010401-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 22:26 Sun 01 Nov     , Yevgeny Kliteynik wrote:
> 
> So it might as well just be something like that:
> 
>  opensm/opensm/osm_sa_mcmember_record.c |   10 +---------
>  1 files changed, 1 insertions(+), 9 deletions(-)
> 
> diff --git a/opensm/opensm/osm_sa_mcmember_record.c b/opensm/opensm/osm_sa_mcmember_record.c
> index 45e743f..617f352 100644
> --- a/opensm/opensm/osm_sa_mcmember_record.c
> +++ b/opensm/opensm/osm_sa_mcmember_record.c
> @@ -731,22 +731,14 @@ static ib_api_status_t mcmr_rcv_create_new_mgrp(IN osm_sa_t * sa,
>  						OUT osm_mgrp_t ** pp_mgrp)
>  {
>  	ib_net16_t mlid;
> -	unsigned zero_mgid, i;
>  	uint8_t scope;
>  	ib_gid_t *p_mgid;
>  	ib_api_status_t status = IB_SUCCESS;
>  	ib_member_rec_t mcm_rec = *p_recvd_mcmember_rec;	/* copy for modifications */
> +	boolean_t zero_mgid = !ib_gid_is_notzero(&p_recvd_mcmember_rec->mgid);
>  
>  	OSM_LOG_ENTER(sa->p_log);
>  
> -	/* but what if the given MGID was not 0 ? */
> -	zero_mgid = 1;
> -	for (i = 0; i < sizeof(p_recvd_mcmember_rec->mgid); i++)
> -		if (p_recvd_mcmember_rec->mgid.raw[i] != 0) {
> -			zero_mgid = 0;
> -			break;
> -		}
> -
>  	/*
>  	   we allocate a new mlid number before we might use it
>  	   for MGID ...
> 
> Want me to send a patch against the new master?

Yes please. Also you can eliminate 'zero_mgid' variable - it is used
only once.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
