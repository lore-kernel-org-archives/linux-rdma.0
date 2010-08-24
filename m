From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] ibnetdiscover: add '-f' flag to show full information
 (ports' speed and width).
Date: Tue, 24 Aug 2010 07:03:54 +0300
Message-ID: <20100824040354.GH5837@me>
References: <4C6B9A42.9020505@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4C6B9A42.9020505-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doron Shoham <dorons-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11:30 Wed 18 Aug     , Doron Shoham wrote:
> add '-f' flag to show full information (ports' speed and witdh).
> mainly to work with ibsim (using links real speed and width).

Seems almost fine. However see the comments below.

> 
> Signed-off-by: Doron Shoham <dorons-smomgflXvOZWk0Htik3J/w@public.gmane.org>
> ---
>  infiniband-diags/src/ibnetdiscover.c |   10 +++++++++-
>  1 files changed, 9 insertions(+), 1 deletions(-)
> 
> diff --git a/infiniband-diags/src/ibnetdiscover.c b/infiniband-diags/src/ibnetdiscover.c
> index f20058c..0a020a2 100644
> --- a/infiniband-diags/src/ibnetdiscover.c
> +++ b/infiniband-diags/src/ibnetdiscover.c
> @@ -77,6 +77,7 @@ static char *diff_cache_file = NULL;
>  static unsigned diffcheck_flags = DIFF_FLAG_DEFAULT;
>  
>  static int report_max_hops = 0;
> +static int full_info = 0;
>  
>  /**
>   * Define our own conversion functions to maintain compatibility with the old
> @@ -357,6 +358,8 @@ void out_switch_port(ibnd_port_t * port, int group, char *out_prefix)
>  		ext_port_str ? ext_port_str : "");
>  	if (port->remoteport->node->type != IB_NODE_SWITCH)
>  		fprintf(f, "(%" PRIx64 ") ", port->remoteport->guid);
> +	if (full_info)
> +			fprintf(f, " s=%d w=%d", ispeed, iwidth);

I think that in order to not potentially break any ibnetdiscover output
parsers it would be better to put such "f" output after a comment line.
Would it work with ibsim in a same way?

>  	fprintf(f, "\t\t# \"%s\" lid %d %s%s",
>  		rem_nodename,
>  		port->remoteport->node->type == IB_NODE_SWITCH ?
> @@ -396,7 +399,8 @@ void out_ca_port(ibnd_port_t * port, int group, char *out_prefix)
>  	rem_nodename = remap_node_name(node_name_map,
>  				       port->remoteport->node->guid,
>  				       port->remoteport->node->nodedesc);
> -
> +	if (full_info)
> +			fprintf(f, " s=%d w=%d", ispeed, iwidth);

Ditto.

Sasha

>  	fprintf(f, "\t\t# lid %d lmc %d \"%s\" lid %d %s%s\n",
>  		port->base_lid, port->lmc, rem_nodename,
>  		port->remoteport->node->type == IB_NODE_SWITCH ?
> @@ -926,6 +930,9 @@ static int process_opt(void *context, int ch, char *optarg)
>  	case 's':
>  		cfg->show_progress = 1;
>  		break;
> +	case 'f':
> +		full_info = 1;
> +		break;
>  	case 'l':
>  		list = LIST_CA_NODE | LIST_SWITCH_NODE | LIST_ROUTER_NODE;
>  		break;
> @@ -964,6 +971,7 @@ int main(int argc, char **argv)
>  	ibnd_fabric_t *diff_fabric = NULL;
>  
>  	const struct ibdiag_opt opts[] = {
> +		{"full", 'f', 0, NULL, "show full information (ports' speed and witdh)"},
>  		{"show", 's', 0, NULL, "show more information"},
>  		{"list", 'l', 0, NULL, "list of connected nodes"},
>  		{"grouping", 'g', 0, NULL, "show grouping"},
> -- 
> 1.5.4
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
