From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RDMA] Fixup IPv6 support and IPv4 routing corner cases for RDMA CM
Date: Thu, 29 Oct 2009 14:21:06 -0600
Message-ID: <20091029202106.GF1966@obsidianresearch.com>
References: <20091028054253.GA22882@obsidianresearch.com> <1256846162.12957.27.camel@wilder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1256846162.12957.27.camel-XfwDJb4SXxnMbYB6QlFGEg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "David J. Wilder" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 29, 2009 at 12:56:01PM -0700, David J. Wilder wrote:
> 
> On Tue, 2009-10-27 at 23:42 -0600, Jason Gunthorpe wrote:
> 
> > 
> > I left the network namespace stuff alone and kept with the init_net
> > situation..
> 
> Another possible solution ;)
> 
>  if (rt->idev->dev->flags & IFF_LOOPBACK){

Oh! That is probbly much better
 
> 
> > 
> > -static int addr_resolve_remote(struct sockaddr *src_in,
> > -				struct sockaddr *dst_in,
> > -				struct rdma_dev_addr *addr)
> > +static int addr_resolve(struct sockaddr *src_in,
> > +			struct sockaddr *dst_in,
> > +			struct rdma_dev_addr *addr)
> >  {
> 
> A problem here, if a source address has not been specified then this
> test is invalid.  I had to change it to use dst_in->sa_family. But as
> you said, we should have validated sa_family before this point.    

Yes, that should have been dst, dst is not optional, src is at this
point.

The sa_family validation of src should only be to check that if it is
specified it is is the same..

Thanks!
Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
