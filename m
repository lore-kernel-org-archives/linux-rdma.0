From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Need to set if_index in ib_init_ah_from_wc() ?
Date: Mon, 30 Jan 2017 12:54:12 -0700
Message-ID: <20170130195412.GE24466@obsidianresearch.com>
References: <CAL1RGDW6iHo2UYKbcJmcG=wCq63jvZB7nvOD=BJZwASSzc7Zhw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAL1RGDW6iHo2UYKbcJmcG=wCq63jvZB7nvOD=BJZwASSzc7Zhw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jan 29, 2017 at 05:21:43PM -0800, Roland Dreier wrote:
> I recently debugged an issue where an RDMA-CM / RoCE connection to a
> link-local IPv6 address takes 1 second to establish.  The delay comes
> when the passive side cm_req_handler() calls
> cm_init_av_for_response(), which calls ib_init_ah_from_wc().
> 
> That calls into rdma_addr_find_l2_eth_by_grh() with the link-local
> address, but with 0 passed in through the if_index parameter.  So
> 
> The fix seems as simple as adding
> 
>     if_index = idev->ifindex;
> 
> to ib_init_ah_from_wc() before the call to
> rdma_addr_find_l2_eth_by_grh() - this can't fail, since we return an
> error if finding idev fails.

Hum, it is certainly a big conceptual mistake to not anchor a route
lookup in a netdev at this point.

Both roceev1 and v2 need to use the netdev that was used to create the
UD QP to anchor these lookups, that netdev should be a child of some
kind from the get_netdev (eg a vlan, or macvlan, etc)

This is necessary to make namespaces and other subtle things work properly.

So, right idea, wrong netdev.

> However, I'm not sure if it's quite that simple - how does this
> interact with RoCEv2, or other addressing like IPv4 or non-link-local
> IPv6? I'm not sure I understand what the cases where resolved_dev will
> be != idev, or if passing in idev->ifindex will break this.

I think this brokenness fell out of the above confusion, it should be
removed, rdma_addr_find_dmac_by_grh should not be callable without a
proper netdev.

The != case can happen if the gid table resolve differently than the
route table, but it is conceptually wrong to lookup in the gid table
before doing a route lookup, and I think these apis are poorly
designed to enforce that requirement.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
