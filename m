From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next 03/31] IB/core: Depend on IPv6 stack to resolve
 link local address
Date: Tue, 14 Nov 2017 17:32:38 -0700
Message-ID: <20171115003238.GI25894@ziepe.ca>
References: <20171114125218.20477-1-leon@kernel.org>
 <20171114125218.20477-4-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171114125218.20477-4-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 14, 2017 at 02:51:50PM +0200, Leon Romanovsky wrote:
> From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Currently ib_resolve_eth_dmac() bypasses IPv6 stack for resolving link
> local destination mac address and translates the IPv6 link local GID
> to MAC address, which is not always correct.
> Static link local neighbour entry can be setup using
> ip -6 neigh add <link_local_addr> lladdr <mac_addr> dev eth0
> Current code bypasses such administratively set entries and IPV6 stack.

At the very least this description makes little sense.

The code is inspecting a DGID, and when in rocev1 mode, the DGID is
*NOT* an IPv6 address and the correct thing to do is what it is doing
now.

In rocev2 mode the DGID becomes and IPv6 address and you should do ND.

Has this distinction been captured in the patch?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
