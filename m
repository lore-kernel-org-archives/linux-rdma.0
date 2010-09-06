From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2] opensm/osm_qos_policy.c: change a log message
Date: Mon, 6 Sep 2010 19:47:28 +0300
Message-ID: <20100906164728.GE11502@me>
References: <4C83B646.7070903@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4C83B646.7070903-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 18:24 Sun 05 Sep     , Yevgeny Kliteynik wrote:
> Pring multicast group GID rather than LID -
> MGID is more relevant than MLID in this context.
> 
> Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

Applied with tiny change (see below). Thanks.

> ---
> V2: fixed the log message
> 
>  opensm/opensm/osm_qos_policy.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/opensm/opensm/osm_qos_policy.c b/opensm/opensm/osm_qos_policy.c
> index 72df6c8..fa04e10 100644
> --- a/opensm/opensm/osm_qos_policy.c
> +++ b/opensm/opensm/osm_qos_policy.c
> @@ -48,6 +48,7 @@
>  #include <stdlib.h>
>  #include <string.h>
>  #include <ctype.h>
> +#include <arpa/inet.h>
>  #include <opensm/osm_log.h>
>  #include <opensm/osm_node.h>
>  #include <opensm/osm_port.h>
> @@ -772,6 +773,7 @@ static void __qos_policy_validate_pkey(
>  	uint8_t sl;
>  	uint32_t flow;
>  	uint8_t hop;
> +	char gid_str[INET6_ADDRSTRLEN];

I moved this string declaration to be under related 'if'...

> 
>  	if (!p_qos_policy || !p_qos_match_rule || !p_prtn)
>  		return;
> @@ -801,9 +803,10 @@ static void __qos_policy_validate_pkey(
>  				  &sl, &flow, &hop);
>  	if (sl != p_prtn->sl) {

there...

Sasha

>  		OSM_LOG(&p_qos_policy->p_subn->p_osm->log, OSM_LOG_DEBUG,
> -			"Updating MCGroup (MLID 0x%04x) SL to "
> +			"Updating MCGroup (MGID %s) SL to "
>  			"match partition SL (%u)\n",
> -			cl_hton16(p_prtn->mgrp->mcmember_rec.mlid),
> +			inet_ntop(AF_INET6, p_prtn->mgrp->mcmember_rec.mgid.raw,
> +				  gid_str, sizeof gid_str),
>  			p_prtn->sl);
>  		p_prtn->mgrp->mcmember_rec.sl_flow_hop =
>  			ib_member_set_sl_flow_hop(p_prtn->sl, flow, hop);
> -- 
> 1.6.2.4
> 
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
