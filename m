From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC] rdma/uverbs: Sketch for an ioctl framework
Date: Tue, 24 May 2016 22:38:58 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB0502ED@ORSMSX109.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A82373AB04FB7F@ORSMSX109.amr.corp.intel.com>
 <HE1PR05MB141819B27F9AAA360DCB420FB14F0@HE1PR05MB1418.eurprd05.prod.outlook.com>
 <11b6d9c1-0b20-f929-c896-ca084fe18192@redhat.com>
 <20160524214137.GA6760@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160524214137.GA6760-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > Under that model, each vendor only carries what they need.  It woul=
d
> > then be libibverbs responsibility to take that driver specific data
> > and
>=20
> Either patchset could go in this direction. This is a basic question
> we need to decide on.
>=20
> I'm starting to think the basic thrust of the Mellanox series (provid=
e
> an easy compatability with our userspace) is a sane approach. The
> other options look like far too much work to use as a starting point.

What matters is whether the work needs to be done anyway, and how can w=
e get to the end design.  I don=92t see a time crunch to force switchin=
g to ioctls.

> You are the only person I've heard who wants to restructure the
> libibverbs interface at the same time..
>=20
> When I kicked off this process at the OFA meeting the discussions
> revolved around some very clear goals:
>  1) Comprehensively close the security issue
>  2) Provide 100% support for existing libibverbs users on the current
>     libibverbs API
>  3) Restructure obvious known weaknesses (eg IB specific areas)
>  4) Add additional extension points

I still don't think we even have agreement on what this interface shoul=
d be.  There is not a single user space library that's being targeted h=
ere.  If the only goal is to support libibverbs, then we need another o=
ption for devices that are not verbs based, but expose hardware specifi=
c structures to user space.  This is why you see objections to putting =
this under uverbs.  Non-verbs use cases keep getting completely overloo=
ked in the conversation.




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
