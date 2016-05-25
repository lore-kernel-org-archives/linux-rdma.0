From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [RFC] rdma/uverbs: Sketch for an ioctl framework
Date: Wed, 25 May 2016 17:47:29 -0500
Message-ID: <007201d1b6d7$6af5c2d0$40e14870$@opengridcomputing.com>
References: <1828884A29C6694DAF28B7E6B8A82373AB04FB7F@ORSMSX109.amr.corp.intel.com> <HE1PR05MB141819B27F9AAA360DCB420FB14F0@HE1PR05MB1418.eurprd05.prod.outlook.com> <11b6d9c1-0b20-f929-c896-ca084fe18192@redhat.com> <20160524214137.GA6760@obsidianresearch.com> <5745E9AE.6020700@redhat.com> <20160525190039.GA5525@obsidianresearch.com> <1828884A29C6694DAF28B7E6B8A82373AB050907@ORSMSX109.amr.corp.intel.com> <20160525205156.GB5525@obsidianresearch.com> <1828884A29C6694DAF28B7E6B8A82373AB050A07@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB050A07-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "'Hefty, Sean'" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Liran Liss' <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> > > I want the core ioctl framework to do this:
> > >
> > > 1. Map user objects to/from the kernel to validate pointers.
> > > 2. Provide reference counting on such objects, in order to protect against
the
> user attempting to
> > destroy objects that are in use.
> > > 3. Provide protection that the state of an object is not driven in two
different
> directions.
> > > 4. Safely process the removal of the underlying driver or device.
> > > 5. Support driver specific operations to the kernel.
> > > 6. Report events from multiple sources to a single file descriptor.
> > > 7. Minimize the kernel footprint for allocated kernel objects.
> > > 8. Minimize the code path needed to process any ioctl, without greatly
affecting
> maintainability.
> > > 9. Copy ioctl input/output data to/from the kernel.
> >
> > I agree with all of this as a suitable goal for the common
> > dispatch/marshal framework.
> >
> > I like the idea of the generic uobject stuff in your patches.
> >
> > #6 seems 'not like the others' - seems like a reasonable concrete
> > thing to consider as we build the objects on the
> > framework. [understanding that compat operation is still required]
> 
> I agree.  Handling event reporting in general is slightly different from the
other
> objections.  But it ties in with object close processing, so I think the
framework
> needs something here.
> 
> #6 is based on examining the application APIs and driving requirements down.
I.e.
> poll a single fd to get all events: CQ notifications, async events, CM
disconnect
> events, etc.  And while I'm thinking about it, expand events to support user
> specified.  This would allow many apps to rid themselves of socketpairs which
> currently fill that role.
>

Applications I have written that block typically put the CQ, async, rdmacm fds
all into an poll/epoll group and block that way.  But a common mechanism for
events might end up cleaner and simpler...



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
