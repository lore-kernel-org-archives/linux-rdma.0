From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: Found one reason libibnetdisc is slower than subnet_discover
Date: Mon, 25 Jan 2010 17:19:28 +0200
Message-ID: <20100125151928.GN13519@me>
References: <20100121181418.a9e955bb.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100121181418.a9e955bb.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 18:14 Thu 21 Jan     , Ira Weiny wrote:
> From: Ira Weiny <weiny2-ig7AzVSIIG5IWGcSWN6Auu1ftBKYq+Ku@public.gmane.org>
> Date: Thu, 21 Jan 2010 17:13:37 -0800
> Subject: [PATCH] optimize query_node
> 
>    recognize when we have found a switch we have already processed and skip the
>    SwitchInfo and NodeDescription queries.
> 
> Signed-off-by: Ira Weiny <weiny2-ig7AzVSIIG5IWGcSWN6Auu1ftBKYq+Ku@public.gmane.org>
> ---
>  infiniband-diags/libibnetdisc/src/ibnetdisc.c |   45 +++++++++++++++----------
>  1 files changed, 27 insertions(+), 18 deletions(-)
> 
> diff --git a/infiniband-diags/libibnetdisc/src/ibnetdisc.c b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
> index d0c97a1..fa0dbe4 100644
> --- a/infiniband-diags/libibnetdisc/src/ibnetdisc.c
> +++ b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
> @@ -101,19 +101,30 @@ static int query_node_info(struct ibmad_port *ibmad_port,
>  	return 0;
>  }
>  
> +static ibnd_node_t *find_existing_node(ibnd_fabric_t * fabric,
> +				       uint64_t guid)
> +{
> +	int hash = HASHGUID(guid) % HTSZ;
> +	ibnd_node_t *node;
> +
> +	for (node = fabric->nodestbl[hash]; node; node = node->htnext)
> +		if (node->guid == guid)
> +			return node;
> +
> +	return NULL;
> +}
> +
>  static int query_node(struct ibmad_port *ibmad_port, ibnd_fabric_t * fabric,
>  		      ibnd_node_t * node, ibnd_port_t * port,
>  		      ib_portid_t * portid)
>  {
>  	int rc = 0;
>  	void *nd = node->nodedesc;
> +	ibnd_node_t *existing;
>  
>  	if ((rc = query_node_info(ibmad_port, fabric, node, portid)) != 0)
>  		return rc;
>  
> -	if (!smp_query_via(nd, portid, IB_ATTR_NODE_DESC, 0, 0, ibmad_port))
> -		return -1;
> -
>  	if ((rc = query_port_info(ibmad_port, portid, 0, port)) != 0)
>  		return rc;
>  
> @@ -121,7 +132,7 @@ static int query_node(struct ibmad_port *ibmad_port, ibnd_fabric_t * fabric,
>  	port->guid = mad_get_field64(node->info, 0, IB_NODE_PORT_GUID_F);
>  
>  	if (node->type != IB_NODE_SWITCH)
> -		return 0;
> +		goto query_nd;

Is this change related to the patch?

In any case why should we repeat NodeDesription query for non switch
nodes?

Sasha

>  
>  	node->smalid = port->base_lid;
>  	node->smalmc = port->lmc;
> @@ -135,6 +146,12 @@ static int query_node(struct ibmad_port *ibmad_port, ibnd_fabric_t * fabric,
>  	port->base_lid = (uint16_t) node->smalid;	/* LID is still defined by port 0 */
>  	port->lmc = (uint8_t) node->smalmc;
>  
> +	if ((existing = find_existing_node(fabric, node->guid)) != NULL) {
> +		/* probably don't even need this memcpy */
> +		memcpy(node, existing, sizeof *node);
> +		return (0);
> +	}
> +
>  	if (!smp_query_via(node->switchinfo, portid, IB_ATTR_SWITCH_INFO, 0, 0,
>  			   ibmad_port))
>  		node->smaenhsp0 = 0;	/* assume base SP0 */
> @@ -144,6 +161,11 @@ static int query_node(struct ibmad_port *ibmad_port, ibnd_fabric_t * fabric,
>  
>  	IBND_DEBUG("portid %s: got switch node %" PRIx64 " '%s'\n",
>  		   portid2str(portid), node->guid, node->nodedesc);
> +
> +query_nd:
> +	if (!smp_query_via(nd, portid, IB_ATTR_NODE_DESC, 0, 0, ibmad_port))
> +		return -1;
> +
>  	return 0;
>  }
>  
> @@ -208,19 +230,6 @@ static void dump_endnode(ib_portid_t * path, char *prompt,
>  	       port->base_lid + (1 << port->lmc) - 1, node->nodedesc);
>  }
>  
> -static ibnd_node_t *find_existing_node(ibnd_fabric_t * fabric,
> -				       ibnd_node_t * new)
> -{
> -	int hash = HASHGUID(new->guid) % HTSZ;
> -	ibnd_node_t *node;
> -
> -	for (node = fabric->nodestbl[hash]; node; node = node->htnext)
> -		if (node->guid == new->guid)
> -			return node;
> -
> -	return NULL;
> -}
> -
>  ibnd_node_t *ibnd_find_node_guid(ibnd_fabric_t * fabric, uint64_t guid)
>  {
>  	int hash = HASHGUID(guid) % HTSZ;
> @@ -459,7 +468,7 @@ static int get_remote_node(struct ibmad_port *ibmad_port,
>  		return 1;	/* positive == non-fatal error */
>  	}
>  
> -	oldnode = find_existing_node(fabric, &node_buf);
> +	oldnode = find_existing_node(fabric, node_buf.guid);
>  	if (oldnode)
>  		remotenode = oldnode;
>  	else if (!(remotenode = create_node(fabric, scan, &node_buf, path,
> -- 
> 1.5.4.5
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
