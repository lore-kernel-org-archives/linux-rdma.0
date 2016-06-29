From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Upcoming libibverbs release
Date: Wed, 29 Jun 2016 12:57:57 -0600
Message-ID: <20160629185757.GA17839@obsidianresearch.com>
References: <3b89c411-72be-ddc5-5ebf-009eeee29692@redhat.com>
 <4ec1d8e6-a908-bb49-a137-415856ec6faa@dev.mellanox.co.il>
 <20160627181758.GD23540@obsidianresearch.com>
 <20160628050246.GB3584@leon.nu>
 <20160628162028.GA27518@obsidianresearch.com>
 <20160628170549.GE3584@leon.nu>
 <20160628211858.GB5786@obsidianresearch.com>
 <20160629120920.GA24151@infradead.org>
 <20160629183414.GD17031@obsidianresearch.com>
 <017301d1d236$8496b030$8dc41090$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <017301d1d236$8496b030$8dc41090$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, 'Yishai Hadas' <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Matan Barak' <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Majd Dibbiny' <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 29, 2016 at 01:46:16PM -0500, Steve Wise wrote:

> I have a concern about the loss of control that might happen.  For example, now
> I can release a new libcxgb4 whenever it works for me.  I wouldn't want to give
> that up and require everyone's blessing/coordination to release bug fixes that
> are completely in libcxgb4.  How can we handle this with a single repo for all
> the provider libs?

I think you start by realizing that nobody uses your git releases
anyhow.

Everyone uses either a distro or OFED release and those are already
co-ordinated outside your control.

Changing the place the distro gets the patches from makes no real
difference to you or your users. However, it does make the distro's
life simpler by having only one place to look for patches.

I'd expect that provider-only patches would have a fast path into the
combined git head, since they don't really need any consensus, and
that is enough to get them into the backport/release cycle for the
above channels.

Presumably Doug would be careful to have stable and devel heads in the
repo where provider fixes vs API changes can land.

Maybe Leon would think more people care if he saw provider commits in
the libibverbs <shrug>

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
