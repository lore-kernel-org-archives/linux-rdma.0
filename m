From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next 1/3] RDMA/core: Remove RoCE support from
 rdma_addr_get_sgid()
Date: Mon, 15 Jan 2018 15:47:42 -0700
Message-ID: <20180115224742.GD2206@ziepe.ca>
References: <20180109111058.29534-1-leon@kernel.org>
 <20180109111058.29534-2-leon@kernel.org>
 <20180115220741.GA18489@ziepe.ca>
 <VI1PR0502MB300827C3710085B7D3C3A924D1EB0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <VI1PR0502MB300827C3710085B7D3C3A924D1EB0-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 15, 2018 at 10:34:13PM +0000, Parav Pandit wrote:

> > Can you define what the SGID/DGID should be in the rdma CM uapi when
> > working with rocee?
> > 
> It is the GIDs derived from the IP address using ip2gid() conversion.

So then why is it OK for this patch to start returning
dev_addr->src_dev_addr ?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
