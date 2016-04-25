From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Further thoughts on uAPI
Date: Mon, 25 Apr 2016 12:32:43 -0600
Message-ID: <20160425183243.GD7675@obsidianresearch.com>
References: <20160420012526.GA25508@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0453F5@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB0453F5-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: OFVWG <ofvwg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 25, 2016 at 04:29:09PM +0000, Hefty, Sean wrote:
> > Study of objects:
> >  'device','port' - Pre-existing and read-only, query_object returns
> >                    information like we have today
> >  'pd','mr','mw','cq','srq','qp','ah' - Basic objects, not all have a
> > modify/query
> >  'flow','xrc',etc - extra objects
> 
> IMO, we should examine what items are objects.  E.g. and XRC RQ is
> treated as a QP, whereas an SRQ is not.  It may make more sense to
> treat each QP type as separate objects.  It would definitely make
> the data structures more efficient and a lot more understandable.

Yes, I was thinking along those lines as well.

It does make it much more understandable if each of the different QP
types was a different object at the high level and thus had a
different set of allowed attributes and and ops.

Eg should UD/RC/UC/RD/XRC/etc all be different object classes.

> > Additional entry points:
> >  poll_cq/req_notify_cq - These are high speed, so simple ioctls, or
> >                          driver specific
> >  post recv/send - drivers implement these via call_driver_on_object
> >  attach/detach mcast - Could be 'modify' a qp, or could be new ioctls
> >  async_event - Should be an ioctl
> >  get_fd - Convert the object to a fd (eg async_fd, comp_channel, etc)
> 
> We could define a generic event_channel/event_queue object to report
> asynchronous events.  The EQ could then be associated with a device,
> port, CQ, CM objects (e.g. QP), etc.  User space could achieve
> current semantics by limiting which objects are associated with each
> channel.

Yes, that is sort of where I was going with the 'get_fd' method - we
have several places that use these fds on different things for async
event delivery.

API wise, yes it is an event channel, however, there must always be an
FD, so if you want to do something to an event channel, it should be
done via ioctl on that fd, not through the common fd. So 'get_fd' is
another form of 'create_object' except that the returned object_handle
is a fd number not an object id.

Perhaps 'create_fd_object' instead ?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
