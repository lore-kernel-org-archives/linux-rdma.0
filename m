From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V4 for-next 1/5] IB/core: Add RSS and TSS QP groups -
 suggesting BOF during OFA conf to further discuss that
Date: Tue, 30 Apr 2013 23:14:38 +0300
Message-ID: <CAJZOPZJRuFc=Q4emSSh-8iWAJvh_tgLNCkQS09B66cGLk3KNjQ@mail.gmail.com>
References: <CAJZOPZLVyYODJ=z6KDfx0UJtaHpA7nUt2kwadEugpV1LWxhEMw@mail.gmail.com>
	<CAJZOPZKwH66uEukqDSvV+4-z+RhroOB1a0AiWBvdq7D3mso7gQ@mail.gmail.com>
	<CAJZOPZL1eminwg+MVAC+8y4Pg3Nff=aeMN9ic57SB3cRAg8Hnw@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A823736FD1E64F@ORSMSX109.amr.corp.intel.com>
	<20130425201255.GB31863@obsidianresearch.com>
	<1828884A29C6694DAF28B7E6B8A823736FD1EF16@ORSMSX109.amr.corp.intel.com>
	<20130425204357.GD31863@obsidianresearch.com>
	<CAJZOPZK8hcfm2OCnsJkhCiRNxOFXOB0xc9i7tmB4qEnkXrXC0Q@mail.gmail.com>
	<20130425214058.GF31863@obsidianresearch.com>
	<CAJZOPZLMtoxYyQO24F5_2Gr7ye0AFPQ5aZHp4dZFu1LQFK_cYg@mail.gmail.com>
	<20130429203653.GA25804@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130429203653.GA25804-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org \"Shlomo Pongratz\"" <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> I think you should have split this patch up, there is lots going on here.
> - Add proper TSS that doesn't change the wire protocol
> - Add fake TSS that does change the wire protocol, and
>   properly document those changes so other people can follow/implement them
> - Add RSS
[...]
> Specifically it means the requirements for alignment and
> contiguous-ness are gone. This means you can implement it without
> using the QP groups API and it will work immediately with every HCA
> out there. I think if we are going to actually mess with the wire
> protocol this sort of broad applicability is important.

We can break the TSS patches to be two staged, sure. As for "you can
implement it without using the QP groups API" do we agree that for the
RSS use case the QP groups API for kernel verbs consumers (== IPoIB)
does make sense?

> As for the other two questions: seems reasonable to me. Without a
> consensus among HW vendors how to do this it makes sense to move ahead
> *in the kernel* with a minimal API. Userspace is a different question of course..

Sean, are you OK with that approach, of sticking to the current
concepts but expose them only at kernel space for the time being?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
