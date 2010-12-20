From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V3 6/6] RDMA CM: Netlink Client
Date: Mon, 20 Dec 2010 14:52:32 -0700
Message-ID: <20101220215232.GA12090@obsidianresearch.com>
References: <1292257370-24391-1-git-send-email-nirm@voltaire.com>
 <1292257370-24391-7-git-send-email-nirm@voltaire.com>
 <20101214184514.GE2506@obsidianresearch.com>
 <1292770052.2369.2157.camel@nirm-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1292770052.2369.2157.camel@nirm-desktop>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-smomgflXvOZWk0Htik3J/w@public.gmane.org, ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Dec 19, 2010 at 04:47:32PM +0200, Nir Muchtar wrote:
> On Tue, 2010-12-14 at 11:45 -0700, Jason Gunthorpe wrote:
> > On Mon, Dec 13, 2010 at 06:22:50PM +0200, Nir Muchtar wrote:
> > > +			if (ibnl_put_attr(skb, nlh,
> > > +					  sizeof id->route.addr.src_addr,
> > > +					  &id->route.addr.src_addr,
> > > +					  IBNL_RDMA_CM_ATTR_SRC_ADDR)) {
> > > +				goto out;
> > > +			}
> > 
> > The sizeof the attribute should be sizeof(sockaddr_in) or
> > sizeof(sockaddr_in6), not sizeof(sockaddr_storage).
> > 
> > Other rdma_cm code uses this sort of construct:
> > 
> >         memcpy(&resp.src_addr, addr, addr->sa_family == AF_INET ?
> >                                      sizeof(struct sockaddr_in) :
> >                                      sizeof(struct sockaddr_in6));
> > 

> Hmm, I was under the impression that sockaddr_storage was what Sean
> had asked for.  Sean, is sockaddr_in6/sockaddr_in good enough?
>
> Btw, Why do you think this should be changed? Message size
> considerations?

Message size is one thing, but it is not really correct to have a
known-type sockaddr with the wrong size. Ie a sockaddr_in is fixed to
sizeof(sockaddr_in) so anytime it appears filled in it must be with
that size.

In POSIX sockets sockaddrs are always associated with a socklen_t to
specify the length of the sockaddr and generally that length must
match the type of the sockaddr. With this netlink scheme the socklen_t
is the length of the netlink attribute.

> > Rather than pid I think it is better to include enough information to
> > cross reference the RDMA_CM fd aginst /proc/../fd. Ie to get the pid(s)
> > you trundle through proc looking for that signature. Isn't that what
> > ss does?
 
> Do you mean the file descriptor which is associated with the
> rdma_event_channel? The event channel is created using ucma and not
> cma.

Yes.

> I don't think there's access to that information from cma. Even if there
> was such access, ucma doesn't save inode info that can be cross
> referenced as sock does.

Then maybe don't include anything for now. If it is this complex it
should be another attribute. See my prior comments about how threading
all the modules together into a coherent view of the QP space is
very desirable..

> Also, what about kernel threads that own ID's?

They have no inode and often no meaningful PID either.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
