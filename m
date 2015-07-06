From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v7 1/4] IB/netlink: Add defines for local service
 requests through netlink
Date: Mon, 6 Jul 2015 14:58:37 -0600
Message-ID: <20150706205837.GA26164@obsidianresearch.com>
References: <1435671955-9744-1-git-send-email-kaike.wan@intel.com>
 <1435671955-9744-2-git-send-email-kaike.wan@intel.com>
 <20150703211605.GA5595@obsidianresearch.com>
 <3F128C9216C9B84BB6ED23EF16290AFB0CAC2F01@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3F128C9216C9B84BB6ED23EF16290AFB0CAC2F01-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Fleck, John" <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > > +/* Local service status attribute */
> > > +enum {
> > > +	LS_NLA_STATUS_SUCCESS = 0,
> > > +	LS_NLA_STATUS_EINVAL,
> > > +	LS_NLA_STATUS_ENODATA,
> > > +	LS_NLA_STATUS_MAX
> > > +};
> > 
> > So, this is never used, there seems to be a bunch of never used stuff
> > - please audit everything and get rid of the cruft before re-sending anything.
> 
> Well, EINVAL and ENODATA are not used by the kernel, but used by the
> application (ibacm). Should this file
> (include/uapi/rdma/rdma_netlink.h) contain only defines used by both
> kernel and application? In that case, the kernel may see
> unrecognized status value if it ever decides to check the status
> code when the response status is ERR.

Get rid of the status value completely, it serves no current
purpose. If in future we need something we can always add a new
attribute.

Don't pollute the kernel headers with ibacm implementation details.

> > We need a way to encode three reply types, I suggest:
> >  RDMA_NL_LS_F_ERR
> >    For some reason the listener could not respond. The kernel should
> >    issue the request on its own. Identical to a timeout.
> >  Good flags, but an empty reply with no LS_NLA_TYPE_PATH_RECORDs
> >    The listener responded and there are no paths. Return no paths
> >    failure to requestor.
> >  Good flags, and up to 6 LS_NLA_TYPE_PATH_RECORDs
> >    Success
> 
> Current implementation can be easily modified to handle these three cases.

Are you going to use this scheme or do you have a different idea?

> > There are only two remaining problems I see with the actual netlink
> > schema:
> >  1) There is no easy indication what port the request is coming
> >     from. User space absolutely needs that to be able to forward a
> >     request on to the proper SA. Yes, we could look at the SGID, but
> >     with gid aliases that seems like alot of work for a performant
> >     API. Ideas? Include the hardware port GUID? Port Number? Device
> >     Name?
> >     Not sure, but does need to be addressed.
> 
> We can pass the device name and port number to the user
> application. The device and port_num are two of the parameters to
> ib_sa_path_rec_get().

That might be best, a ifindex would be even better, but we don't have
one...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
