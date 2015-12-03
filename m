From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next V2 05/11] IB/core: Add rdma_network_type to wc
Date: Thu, 3 Dec 2015 09:36:00 -0700
Message-ID: <20151203163600.GA27565@obsidianresearch.com>
References: <1449150450-13679-1-git-send-email-matanb@mellanox.com>
 <1449150450-13679-6-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1449150450-13679-6-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-idTK6quXuVSLFuii7jzJGg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 03, 2015 at 03:47:12PM +0200, Matan Barak wrote:
> From: Somnath Kotur <Somnath.Kotur-idTK6quXuVSLFuii7jzJGg@public.gmane.org>
> 
> Providers should tell IB core the wc's network type.
> This is used in order to search for the proper GID in the
> GID table. When using HCAs that can't provide this info,
> IB core tries to deep examine the packet and extract
> the GID type by itself.

Eh? A wc has a sgid_index, and in this brave new world a gid has the
network type. Why do we need to specify it again?

>  	memset(ah_attr, 0, sizeof *ah_attr);
>  	if (rdma_cap_eth_ah(device, port_num)) {
> +		if (wc->wc_flags & IB_WC_WITH_NETWORK_HDR_TYPE)
> +			net_type = wc->network_hdr_type;
> +		else
> +			net_type = ib_get_net_type_by_grh(device, port_num, grh);
> +		gid_type = ib_network_to_gid_type(net_type);

Like here for instance.

... and I keep saying this is all wrong, once you get into IP land
this entire process needs a route/neighbour lookup.


> -			ret = rdma_addr_find_dmac_by_grh(&grh->dgid, &grh->sgid,
> +			ret = rdma_addr_find_dmac_by_grh(&dgid, &sgid,
>  							 ah_attr->dmac,
>  							 wc->wc_flags & IB_WC_WITH_VLAN ?
>  							 NULL : &vlan_id,

ie no to this.

> +			if (sgid_attr.gid_type == IB_GID_TYPE_ROCE_UDP_ENCAP)
> +				/* TODO: get the hoplimit from the inet/inet6
> +				 * device
> +				 */

And no again, please fix this and all other missing route lookups
before sending another version.

> +	struct {
> +		/* The IB spec states that if it's IPv4, the header

roceev2 spec, surely

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
