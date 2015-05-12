From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 3/5] IB/core: Convert management helpers to core
 capability bits
Date: Tue, 12 May 2015 13:25:17 -0600
Message-ID: <20150512192517.GD3503@obsidianresearch.com>
References: <1431395218-27693-1-git-send-email-ira.weiny@intel.com>
 <1431395218-27693-4-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1431395218-27693-4-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, May 11, 2015 at 09:46:56PM -0400, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> Remove query_protocol callback
> 
> Use the new Core Capability bits for:

Looks broadly reasonable to me, I see why you'd want to keep the
driver functions added in the last patch, so disregard my comment on
null..

>  static inline bool rdma_protocol_ib(struct ib_device *device, u8 port_num)
>  {
> -	return device->query_protocol(device, port_num) == RDMA_PROTOCOL_IB;
> +	return (device->port_immutable[port_num].core_cap_flags & RDMA_CORE_CAP_PROT_IB)
> +		== RDMA_CORE_CAP_PROT_IB;
>  }

This pattern can just be

 return device->port_immutable[port_num].core_cap_flags &
 RDMA_CORE_CAP_PROT_IB;

Cast to bool will cannonize it automatically

> -	return (pt == RDMA_PROTOCOL_IB || pt == RDMA_PROTOCOL_IBOE);
> +	return ((flags & RDMA_CORE_CAP_PROT_IB) == RDMA_CORE_CAP_PROT_IB ||
> +		(flags & RDMA_CORE_CAP_PROT_IBOE) ==
> RDMA_CORE_CAP_PROT_IBOE);

 return device->port_immutable[port_num].core_cap_flags & (RDMA_CORE_CAP_PROT_IB | RDMA_CORE_CAP_PROT_IBOE);

etc.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
