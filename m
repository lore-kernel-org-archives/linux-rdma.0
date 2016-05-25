From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC] rdma/uverbs: Sketch for an ioctl framework
Date: Wed, 25 May 2016 16:13:40 -0600
Message-ID: <20160525221340.GB6207@obsidianresearch.com>
References: <1828884A29C6694DAF28B7E6B8A82373AB04FB7F@ORSMSX109.amr.corp.intel.com>
 <HE1PR05MB141819B27F9AAA360DCB420FB14F0@HE1PR05MB1418.eurprd05.prod.outlook.com>
 <11b6d9c1-0b20-f929-c896-ca084fe18192@redhat.com>
 <20160524214137.GA6760@obsidianresearch.com>
 <5745E9AE.6020700@redhat.com>
 <20160525190039.GA5525@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB050907@ORSMSX109.amr.corp.intel.com>
 <20160525205156.GB5525@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB050A07@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB050A07-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 25, 2016 at 09:46:16PM +0000, Hefty, Sean wrote:
> > #6 seems 'not like the others' - seems like a reasonable concrete
> > thing to consider as we build the objects on the
> > framework. [understanding that compat operation is still required]
> 
> I agree.  Handling event reporting in general is slightly different
> from the other objections.  But it ties in with object close
> processing, so I think the framework needs something here.

Yes, some kind of core framework seem essential here, and funneling
all events seems reasonable if we can figure out how.

> #6 is based on examining the application APIs and driving
> requirements down.  I.e. poll a single fd to get all events: CQ
> notifications, async events, CM disconnect events, etc.  And while
> I'm thinking about it, expand events to support user specified.
> This would allow many apps to rid themselves of socketpairs which
> currently fill that role.

socketpairs? I always use eventfds for that kind of stuff..

Are you hearing people object to number of fds? I've never thought of
it as such a big deal, epoll makes it very painless to deal with.. Do
people have scaling issues?

What would be nice is having strong synchronization in the event
stream, eg between cm (dis)connection and related cq events so those
unexpected races go away...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
