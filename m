From: "David J. Wilder" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RDMA] Fixup IPv6 support and IPv4 routing corner cases
	for RDMA CM
Date: Thu, 29 Oct 2009 12:56:01 -0700
Message-ID: <1256846162.12957.27.camel@wilder.ibm.com>
References: <20091028054253.GA22882@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091028054253.GA22882-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: leo.tominna-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Tue, 2009-10-27 at 23:42 -0600, Jason Gunthorpe wrote:

> 
> I left the network namespace stuff alone and kept with the init_net
> situation..

Another possible solution ;)

 if (rt->idev->dev->flags & IFF_LOOPBACK){


> 
> -static int addr_resolve_remote(struct sockaddr *src_in,
> -				struct sockaddr *dst_in,
> -				struct rdma_dev_addr *addr)
> +static int addr_resolve(struct sockaddr *src_in,
> +			struct sockaddr *dst_in,
> +			struct rdma_dev_addr *addr)
>  {

A problem here, if a source address has not been specified then this
test is invalid.  I had to change it to use dst_in->sa_family. But as
you said, we should have validated sa_family before this point.    

>  	if (src_in->sa_family == AF_INET) {
> -		return addr4_resolve_remote((struct sockaddr_in *) src_in,
> +		return addr4_resolve((struct sockaddr_in *) src_in,
>  			(struct sockaddr_in *) dst_in, addr);
>  	} else
> -		return addr6_resolve_remote((struct sockaddr_in6 *) src_in,
> +		return addr6_resolve((struct sockaddr_in6 *) src_in,
>  			(struct sockaddr_in6 *) dst_in, addr);
>  }


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
