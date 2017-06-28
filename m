From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next 3/4] RDMA/netink: Export lids and sm_lids
Date: Wed, 28 Jun 2017 10:19:03 -0600
Message-ID: <20170628161903.GA28996@obsidianresearch.com>
References: <20170628133445.16550-1-leon@kernel.org>
 <20170628133445.16550-4-leon@kernel.org>
 <20170628160513.GC14375@obsidianresearch.com>
 <20170628161616.GK1248@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170628161616.GK1248-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 28, 2017 at 07:16:16PM +0300, Leon Romanovsky wrote:
> On Wed, Jun 28, 2017 at 10:05:13AM -0600, Jason Gunthorpe wrote:
> > On Wed, Jun 28, 2017 at 04:34:44PM +0300, Leon Romanovsky wrote:
> > > +	if (nla_put_u32(msg, RDMA_NLDEV_ATTR_LID, attr.lid))
> > > +		return -EMSGSIZE;
> > > +	if (nla_put_u32(msg, RDMA_NLDEV_ATTR_SM_LID, attr.sm_lid))
> > > +		return -EMSGSIZE;
> >
> > Is this careful to only stuff attributes if they actuall exists? Eg
> > these should not be present for iwarp/roce/etc
> >
> > Same comment for all attributes. Only present if they are valid.
> 
> It will be zero if it is not exist, but you are right it is better to
> avoid to fill unneeded fields.

Not existing is the netlink way. Same comment for everything
attributes. Many of the guids do not apply to iwarp, IIRC..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
