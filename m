From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next 14/31] RDMA/cma: Simplify netdev check
Date: Fri, 19 Jan 2018 12:38:11 -0700
Message-ID: <20180119193811.GB3437@ziepe.ca>
References: <20171114125218.20477-1-leon@kernel.org>
 <20171114125218.20477-15-leon@kernel.org>
 <1516350659.4593.6.camel@ifi.uio.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1516350659.4593.6.camel-6miFZF/5cTBuMpJDpNschA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Knut Omang <knuto-6miFZF/5cTBuMpJDpNschA@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 19, 2018 at 09:30:59AM +0100, Knut Omang wrote:

> >  	rdma_ip2gid((struct sockaddr *)&id_priv->id.route.addr.src_addr,
> 
> Reviewed-by: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Hey Knut,

You are a bit lat here, these patches were all applied in Novemeber :)

I welcome your reviews, and recommend you check patchworks for what is
current?

https://patchwork.kernel.org/project/linux-rdma/list/

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
