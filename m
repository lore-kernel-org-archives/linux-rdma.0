From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH RFC 2/2] RDMA/nldev: provide detailed CM_ID information
Date: Thu, 1 Feb 2018 15:01:10 -0700
Message-ID: <20180201220110.GZ17053@ziepe.ca>
References: <cover.1517418595.git.swise@opengridcomputing.com>
 <531889e6a24f7919dec71734c91298d266aa9721.1517418595.git.swise@opengridcomputing.com>
 <20180201084944.GH2055@mtr-leonro.local>
 <20180201175353.GU17053@ziepe.ca>
 <013501d39b89$01371bd0$03a55370$@opengridcomputing.com>
 <20180201183232.GV17053@ziepe.ca>
 <014601d39b8b$b83448b0$289cda10$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <014601d39b8b$b83448b0$289cda10$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 01, 2018 at 12:37:31PM -0600, Steve Wise wrote:
> > > > On Thu, Feb 01, 2018 at 10:49:44AM +0200, Leon Romanovsky wrote:
> > > >
> > > > > > +	RDMA_NLDEV_ATTR_RES_IPV4_SADDR,		/* u8[4] */
> > > > > > +	RDMA_NLDEV_ATTR_RES_IPV4_DADDR,		/* u8[4] */
> > > > > > +	RDMA_NLDEV_ATTR_RES_IPV6_SADDR,		/* u8[16] */
> > > > > > +	RDMA_NLDEV_ATTR_RES_IPV6_DADDR,		/* u8[16] */
> > > > > > +	RDMA_NLDEV_ATTR_RES_IP_SPORT,		/* BE u16 */
> > > > > > +	RDMA_NLDEV_ATTR_RES_IP_DPORT,		/* BE u16 */
> > > > >
> > > > > Can you please document the meaning of S (source) and D
> (destination)
> > > > > in regards of this netlink output? It is needed to remove ambiguity.
> > > >
> > > > And no on BE's in netlink, I think.
> > >
> > >
> > > Sure there are, see nla_put_be32() for example. I'm using
> nla_put_net16() to
> > > store the ports.  Perhaps I need to change the above comment to ne16
> instead
> > > of BE u16?
> > 
> > There is no reason thes ports should be be, so don't make it be.
> 
> Well, they're BE on the wire.  That's the reason.  And other APIs return
> them to user space in their NBO, like getsockname().  
> 
> You would rather the nldev code puts it in HBO before sending it up?  

Yes, we have far too much 'guess the endian' in our uapi, it doesn't
make sense in modern HW, the swap costs nothing.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
