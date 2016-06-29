From: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: Upcoming libibverbs release
Date: Wed, 29 Jun 2016 19:07:52 +0200
Message-ID: <1467220072.8638.166.camel@oracle.com>
References: <3b89c411-72be-ddc5-5ebf-009eeee29692@redhat.com>
	 <4ec1d8e6-a908-bb49-a137-415856ec6faa@dev.mellanox.co.il>
	 <20160627181758.GD23540@obsidianresearch.com>
	 <20160628050246.GB3584@leon.nu>
	 <20160628162028.GA27518@obsidianresearch.com>
	 <20160628170549.GE3584@leon.nu>
	 <20160628211858.GB5786@obsidianresearch.com>
	 <20160629051507.GF3584@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160629051507.GF3584-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2016-06-29 at 08:15 +0300, Leon Romanovsky wrote:
> On Tue, Jun 28, 2016 at 03:18:58PM -0600, Jason Gunthorpe wrote:
> > On Tue, Jun 28, 2016 at 08:05:49PM +0300, Leon Romanovsky wrote:
> > 
> > > > But at the end of the day, the message to users must be to use the
> > > > new polling API, the old one is deprecated, and apps should never
> > > > include fallback code because the new API always works.
> > > 
> > > Please put aside Yishai's patches, I'm not taking about them.
> > 
> > Well, I am, I don't know what you are talking about.
> > 
> > > We are talking about the total number of other vendors who will
> > > be ready to implement new features exposed in libibverbs.
> > 
> > Who cares?
> > 
> > Mellanox has been pushing dpdk centric HW features that no other
> > vendor has an interest in. So it is understandable there is not much
> > activity.
> 
> I see it differently, I don't see any activity from other vendors,
> because there are no vendors who interest in developing new features in
> libibverbs.

A fundamental property of good APIs is that they provide a certain
degree of stability and backward/forward compatibility. This means (in
my view) that for an API which have reached a certain maturity and user
base, "default" action should be not to change, and that changes must
have compelling arguments. That said, good additions and necessary
refactoring is fine, as long as enough care is taken to maintain
backward compatibility or a well understood, viable upgrade path for
the existing user base.

> Currently all vendors can be categorized into three groups:
> * Interested in legacy code - a couple of vendors
> * Struggling from identity problem (verbs/non-verbs architecture) and
>   has proprietary library - one vendor
> * Interested in developing new features in libibverbs - one vendor

I would think that we would want to eventually implement new libibverbs
features that makes sense from an application point of view, with
priority on those that we believe are most important to our users.

My point is just that making changes to libibverbs should be motivated
by use cases that cannot be covered by the existing API, or that is
clumsy or inefficient or not generic enough, and not be accepted until
they have been subject to enough scrutiny to ensure that quality.

Through the course of my work with the Infiniband stack so far, I have
seen a few cases of changes that were not of that sort, so I appreciate
that the community strives to make sure that the "burden of proof" is
on the side of those who want changes.

Thanks,
Knut

> > 
> > However this is an all-vendor software only feature that all HW can
> > support right now today, it is fundamentally different than the prior
> > HW entangled patches.
> > 
> > Consider the kAPI work to add the new MR stuff that Christoph
> > did. That would have been a total disaster if they didn't update all
> > the drivers to work with it at the same time.
> > 
> > Userspace is no different, and the responsibility falls with the patch
> > author to oversee that process and get it done before merging.
> 
> Again, my response is related to your expectations to see "other
> vendors". Please don't drag me to the discussion of Yishai's patches.
> 
> Thanks.
> 
> > 
> > Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
