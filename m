From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH v2] ib-diags: Add cast to fix build on windows
Date: Thu, 22 Sep 2011 15:17:01 -0700
Message-ID: <20110922151701.c4517b71.weiny2@llnl.gov>
References: <1828884A29C6694DAF28B7E6B8A8237316E6756F@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237316E6756F-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 22 Sep 2011 13:37:23 -0700
"Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Thanks applied.

Ira

> ---
> changes from v1: reset mode back to 644
> 
>  libibnetdisc/src/ibnetdisc.c |    2 +-
>  src/ibportstate.c            |    4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/libibnetdisc/src/ibnetdisc.c b/libibnetdisc/src/ibnetdisc.c
> index 86210eb..c93e7ad 100644
> --- a/libibnetdisc/src/ibnetdisc.c
> +++ b/libibnetdisc/src/ibnetdisc.c
> @@ -201,7 +201,7 @@ static void debug_port(ib_portid_t * portid, ibnd_port_t * port)
>  
>  static int is_mlnx_ext_port_info_supported(ibnd_port_t * port)
>  {
> -	uint16_t devid = mad_get_field(port->node->info, 0, IB_NODE_DEVID_F);
> +	uint16_t devid = (uint16_t) mad_get_field(port->node->info, 0, IB_NODE_DEVID_F);
>  
>  	if (devid == 0xc738)
>  		return 1;
> diff --git a/src/ibportstate.c b/src/ibportstate.c
> index 81d5b58..daa8514 100644
> --- a/src/ibportstate.c
> +++ b/src/ibportstate.c
> @@ -462,7 +462,7 @@ int main(int argc, char **argv)
>  		port_op = QUERY;
>  
>  	is_switch = get_node_info(&portid, data);
> -	devid = mad_get_field(data, 0, IB_NODE_DEVID_F);
> +	devid = (uint16_t) mad_get_field(data, 0, IB_NODE_DEVID_F);
>  
>  	if (port_op != QUERY || changed)
>  		printf("Initial %s PortInfo:\n", is_switch ? "Switch" : "CA");
> @@ -591,7 +591,7 @@ int main(int argc, char **argv)
>  
>  			/* Get peer port NodeInfo to obtain peer port number */
>  			is_peer_switch = get_node_info(&peerportid, data);
> -			rem_devid = mad_get_field(data, 0, IB_NODE_DEVID_F);
> +			rem_devid = (uint16_t) mad_get_field(data, 0, IB_NODE_DEVID_F);
>  
>  			mad_decode_field(data, IB_NODE_LOCAL_PORT_F,
>  					 &peerlocalportnum);
> 
> 


-- 
Ira Weiny
Math Programmer/Computer Scientist
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
