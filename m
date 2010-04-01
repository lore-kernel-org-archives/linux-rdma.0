From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 26/26] rdma/ucm: allow user space to specify AF_IB when
	joining multicast
Date: Thu, 1 Apr 2010 11:38:09 -0600
Message-ID: <20100401173809.GA15629@obsidianresearch.com>
References: <9D903E76C4EA4CF48BF2548F2BC8D2EA@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <9D903E76C4EA4CF48BF2548F2BC8D2EA-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 01, 2010 at 10:08:41AM -0700, Sean Hefty wrote:

>  	} else if ((addr->sa_family == AF_INET6)) {
>  		ipv6_ib_mc_map(&sin6->sin6_addr, dev_addr->broadcast, mc_map);
> -		if (id_priv->id.ps == RDMA_PS_UDP)
> +		if (id_priv->id.ps == RDMA_PS_UDP || id_priv->id.ps == RDMA_PS_IB)
>  			mc_map[7] = 0x01;	/* Use RDMA CM signature */
>  		*mgid = *(union ib_gid *) (mc_map + 4);

What does the combination of AF_INET/INET6 and RDMA_PS_IB mean?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
