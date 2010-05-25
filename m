From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags/libibnetdisc/ibnetdisc.c: Fix compile
 warns on 32 bit archs
Date: Tue, 25 May 2010 21:45:52 +0300
Message-ID: <20100525184552.GY28549@me>
References: <20100524194508.GC26919@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100524194508.GC26919-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 15:45 Mon 24 May     , Hal Rosenstock wrote:
> 
> src/ibnetdisc.c: In function `query_port_info':
> src/ibnetdisc.c:216: warning: long unsigned int format, different type arg (arg 5)
> src/ibnetdisc.c: In function `recv_node_info':
> src/ibnetdisc.c:311: warning: long unsigned int format, different type arg (arg 5)
> src/ibnetdisc.c:335: warning: long unsigned int format, different type arg (arg 6)
> 
> Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Applied with minor fixes (see below). Thanks.

> ---
>  infiniband-diags/libibnetdisc/src/ibnetdisc.c |   12 +++++++-----
>  1 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/infiniband-diags/libibnetdisc/src/ibnetdisc.c b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
> index 98801de..157b866 100644
> --- a/infiniband-diags/libibnetdisc/src/ibnetdisc.c
> +++ b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
> @@ -211,8 +211,8 @@ static int recv_port_info(smp_engine_t * engine, ibnd_smp_t * smp,
>  static int query_port_info(smp_engine_t * engine, ib_portid_t * portid,
>  			   ibnd_node_t * node, int portnum)
>  {
> -	IBND_DEBUG("Query Port Info; %s (%lx):%d\n", portid2str(portid),
> -		   node->guid, portnum);
> +	IBND_DEBUG("Query Port Info; %s (0x%" PRIx64 "):%d\n",
> +		   portid2str(portid), node->guid, portnum);
>  	return issue_smp(engine, portid, IB_ATTR_PORT_INFO, portnum,
>  			 recv_port_info, node);
>  }
> @@ -307,8 +307,9 @@ static int recv_node_info(smp_engine_t * engine, ibnd_smp_t * smp,
>  			return -1;
>  		node_is_new = 1;
>  	}
> -	IBND_DEBUG("Found %s node GUID %lx (%s)\n", node_is_new ? "new" : "old",
> -		   node->guid, portid2str(&smp->path));
> +	IBND_DEBUG("Found %s node GUID 0x%" PRIx64 "(%s)\n",

The space is missed after GUID value printing and before '(', so adding
this back.

> +		   node_is_new ? "new" : "old", node->guid,
> +		   portid2str(&smp->path));
>  
>  	port = node->ports[port_num];
>  	if (!port) {
> @@ -331,7 +332,8 @@ static int recv_node_info(smp_engine_t * engine, ibnd_smp_t * smp,
>  
>  		if (!rem_node->ports[rem_port_num]) {
>  			IBND_ERROR("Internal Error; "
> -				   "Node(%p) %lx Port %d no port created!?!?!?\n\n",
> +				   "Node(%p) 0x%" PRIx64
> +				   "Port %d no port created!?!?!?\n\n",

The space is missed between GUID value and 'Port' word. Adding back.

Sasha

>  				   rem_node, rem_node->guid, rem_port_num);
>  			return -1;
>  		}
> -- 
> 1.5.6.4
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
