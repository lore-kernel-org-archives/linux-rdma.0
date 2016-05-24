From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC] rdma/uverbs: Sketch for an ioctl framework
Date: Tue, 24 May 2016 17:13:59 -0600
Message-ID: <20160524231359.GA10664@obsidianresearch.com>
References: <1828884A29C6694DAF28B7E6B8A82373AB04FB7F@ORSMSX109.amr.corp.intel.com>
 <HE1PR05MB141819B27F9AAA360DCB420FB14F0@HE1PR05MB1418.eurprd05.prod.outlook.com>
 <11b6d9c1-0b20-f929-c896-ca084fe18192@redhat.com>
 <20160524214137.GA6760@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0502ED@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB0502ED-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 24, 2016 at 10:38:58PM +0000, Hefty, Sean wrote:

> > I'm starting to think the basic thrust of the Mellanox series (provide
> > an easy compatability with our userspace) is a sane approach. The
> > other options look like far too much work to use as a starting point.
> 
> What matters is whether the work needs to be done anyway, and how
> can we get to the end design.  I don?t see a time crunch to force
> switching to ioctls.

Well, it doesn't need to be done, the verbs calls we've already coded
do not *need* to be recoded - except due to the security problem.

> > You are the only person I've heard who wants to restructure the
> > libibverbs interface at the same time..
> > 
> > When I kicked off this process at the OFA meeting the discussions
> > revolved around some very clear goals:
> >  1) Comprehensively close the security issue
> >  2) Provide 100% support for existing libibverbs users on the current
> >     libibverbs API
> >  3) Restructure obvious known weaknesses (eg IB specific areas)
> >  4) Add additional extension points
> 
> I still don't think we even have agreement on what this interface
> should be.  There is not a single user space library that's being
> targeted here.

As I outlined, the genesis to do this was to migrate libibverbs to an
ioctl interface and in the process set a better stage for all the
other things people want to do. That includes better supporting
non-libibverbs libraries (dpdk, libfabric, whatever)

The purpose of the object/method style framework was to better set the
stage for the core code to provide that kind of wider interface for
the drivers.

A major family of objects/methods is going to be the libibverbs 1.0
support layer which is mandatory to port libibverbs to this interface.

The driver specific and any future 'non-verbs' common objects/methods
have little concrete to bring to the table right now. The cdev stuff
in hfi1/qib is very small and easilly handled by the bypass-to-driver
path that both patches include.

> hardware specific structures to user space.  This is why you see
> objections to putting this under uverbs.  Non-verbs use cases keep
> getting completely overlooked in the conversation.

I disagree, non-verbs is not a central topic of conversation because
nothing beyond needing a bypass-to-driver channel has been brought up
by that community. That need has clearly been met in both patch series.

Further, the basic things presented by both series so far are still
general enough to allow for new common uAPIs that are unrelated to the
verbs family.

I'm not sure what else can be done until the non-verbs universe makes
a consensus on what common kernel support it needs???

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
