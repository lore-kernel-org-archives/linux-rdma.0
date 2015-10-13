From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH infiniband-diags] ibcacheedit.c: Eliminate unused parameter passed to update_switchportguids
Date: Tue, 13 Oct 2015 12:52:15 -0400
Message-ID: <20151013165214.GA13386@phlsvsds.ph.intel.com>
References: <561CFB2A.1030103@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <561CFB2A.1030103-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 13, 2015 at 08:38:02AM -0400, Hal Rosenstock wrote:
> 
> src/ibcacheedit.c: In function ?update_switchportguids?:
> src/ibcacheedit.c:168: warning: unused parameter ?guid?
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks applied,
Ira

> ---
> diff --git a/src/ibcacheedit.c b/src/ibcacheedit.c
> index 983c0ab..b520839 100644
> --- a/src/ibcacheedit.c
> +++ b/src/ibcacheedit.c
> @@ -165,7 +165,7 @@ static int process_opt(void *context, int ch, char *optarg)
>  	return 0;
>  }
>  
> -static void update_switchportguids(ibnd_node_t *node, uint64_t guid)
> +static void update_switchportguids(ibnd_node_t *node)
>  {
>  	ibnd_port_t *port;
>  	int p;
> @@ -191,7 +191,7 @@ static void replace_node_guid(ibnd_node_t *node, void *user_data)
>  		 * switches, so update port guids too
>  		 */
>  		if (node->type == IB_NODE_SWITCH)
> -			update_switchportguids(node, guids->after);
> +			update_switchportguids(node);
>  
>  		guids->found++;
>  	}
> @@ -229,7 +229,7 @@ static void replace_portguid(ibnd_node_t *node, void *user_data)
>  		 */
>  		if (node->guid == guids->before) {
>  			node->guid = guids->after;
> -			update_switchportguids(node, guids->after);
> +			update_switchportguids(node);
>  			guids->found++;
>  		}
>  	}
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
