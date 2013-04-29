From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V4 for-next 1/5] IB/core: Add RSS and TSS QP groups -
 suggesting BOF during OFA conf to further discuss that
Date: Mon, 29 Apr 2013 22:49:22 +0300
Message-ID: <CAJZOPZKdrwReS7Pf_Fr-n=LQ_0zP=GRhggRSEO0XgWQBe9NxKA@mail.gmail.com>
References: <CAJZOPZLVyYODJ=z6KDfx0UJtaHpA7nUt2kwadEugpV1LWxhEMw@mail.gmail.com>
	<CAJZOPZKwH66uEukqDSvV+4-z+RhroOB1a0AiWBvdq7D3mso7gQ@mail.gmail.com>
	<CAJZOPZL1eminwg+MVAC+8y4Pg3Nff=aeMN9ic57SB3cRAg8Hnw@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A823736FD1E64F@ORSMSX109.amr.corp.intel.com>
	<20130425201255.GB31863@obsidianresearch.com>
	<1828884A29C6694DAF28B7E6B8A823736FD1EF16@ORSMSX109.amr.corp.intel.com>
	<20130425204357.GD31863@obsidianresearch.com>
	<CAJZOPZK8hcfm2OCnsJkhCiRNxOFXOB0xc9i7tmB4qEnkXrXC0Q@mail.gmail.com>
	<20130425214058.GF31863@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130425214058.GF31863-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org \"Shlomo Pongratz\"" <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Apr 26, 2013 at 12:40 AM, Jason Gunthorpe

> Also, I feel what happens inside the kernel is more flexable API
> wise, so dropping the uverbs component may also be something you want to look at.

We didn't submit any uverbs exporting of these verbs on this series. I
am  OK if the series is accepted for kernel use only (as was
submitted) and later we open a discussion on the user space API where
once converges, we can decide if to port the kernel RSS/TSS bits to
the newly agreed API.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
