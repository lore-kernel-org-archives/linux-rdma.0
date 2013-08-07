From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH ibacm 2/8] acm.c: In acm_port_up, handle noncontiguous
 pkeys
Date: Wed, 7 Aug 2013 17:35:46 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237388CA48C0@ORSMSX109.amr.corp.intel.com>
References: <5200E1CD.6070705@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5200E1CD.6070705-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> There can be "holes" in pkey table although this is not usually the case
> but since IBA spec allows for this, it should be handled.
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  src/acm.c |   14 +++++++-------
>  1 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/src/acm.c b/src/acm.c
> index 81aeeb4..a15f094 100644
> --- a/src/acm.c
> +++ b/src/acm.c
> @@ -3192,11 +3192,6 @@ static void acm_port_up(struct acm_port *port)
>  			break;
>  	}
> 
> -	for (port->pkey_cnt = 0;; port->pkey_cnt++) {
> -		ret = ibv_query_pkey(port->dev->verbs, port->port_num, port-
> >pkey_cnt, &pkey);
> -		if (ret || !pkey)
> -			break;
> -	}
>  	port->lid = attr.lid;
>  	port->lid_mask = 0xffff - ((1 << attr.lmc) - 1);
> 
> @@ -3214,8 +3209,13 @@ static void acm_port_up(struct acm_port *port)
>  		return;
> 
>  	atomic_set(&port->sa_dest.refcnt, 1);
> -	for (i = 0; i < port->pkey_cnt; i++)
> -		 acm_ep_up(port, (uint16_t) i);
> +	for (i = 0; i < attr.pkey_tbl_len; i++) {
> +		ret = ibv_query_pkey(port->dev->verbs, port->port_num, i, &pkey);
> +		if (ret || !pkey)
> +			continue;
> +		port->pkey_cnt++;
> +		acm_ep_up(port, (uint16_t) i);
> +	}

I think we can remove pkey_cnt from struct acm_port as part of this change.  If you agree, I can fix that up when applying the patch (no need to update).
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
