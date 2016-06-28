From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Upcoming libibverbs release
Date: Tue, 28 Jun 2016 15:18:58 -0600
Message-ID: <20160628211858.GB5786@obsidianresearch.com>
References: <3b89c411-72be-ddc5-5ebf-009eeee29692@redhat.com>
 <4ec1d8e6-a908-bb49-a137-415856ec6faa@dev.mellanox.co.il>
 <20160627181758.GD23540@obsidianresearch.com>
 <20160628050246.GB3584@leon.nu>
 <20160628162028.GA27518@obsidianresearch.com>
 <20160628170549.GE3584@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160628170549.GE3584-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 28, 2016 at 08:05:49PM +0300, Leon Romanovsky wrote:

> > But at the end of the day, the message to users must be to use the
> > new polling API, the old one is deprecated, and apps should never
> > include fallback code because the new API always works.
> 
> Please put aside Yishai's patches, I'm not taking about them.

Well, I am, I don't know what you are talking about.

> We are talking about the total number of other vendors who will
> be ready to implement new features exposed in libibverbs.

Who cares?

Mellanox has been pushing dpdk centric HW features that no other
vendor has an interest in. So it is understandable there is not much
activity.

However this is an all-vendor software only feature that all HW can
support right now today, it is fundamentally different than the prior
HW entangled patches.

Consider the kAPI work to add the new MR stuff that Christoph
did. That would have been a total disaster if they didn't update all
the drivers to work with it at the same time.

Userspace is no different, and the responsibility falls with the patch
author to oversee that process and get it done before merging.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
