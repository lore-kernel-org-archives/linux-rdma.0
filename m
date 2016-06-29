From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: Upcoming libibverbs release
Date: Wed, 29 Jun 2016 13:46:16 -0500
Message-ID: <017301d1d236$8496b030$8dc41090$@opengridcomputing.com>
References: <3b89c411-72be-ddc5-5ebf-009eeee29692@redhat.com> <4ec1d8e6-a908-bb49-a137-415856ec6faa@dev.mellanox.co.il> <20160627181758.GD23540@obsidianresearch.com> <20160628050246.GB3584@leon.nu> <20160628162028.GA27518@obsidianresearch.com> <20160628170549.GE3584@leon.nu> <20160628211858.GB5786@obsidianresearch.com> <20160629120920.GA24151@infradead.org> <20160629183414.GD17031@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160629183414.GD17031-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, 'Yishai Hadas' <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Matan Barak' <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Majd Dibbiny' <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> On Wed, Jun 29, 2016 at 05:09:20AM -0700, Christoph Hellwig wrote:
> > On Tue, Jun 28, 2016 at 03:18:58PM -0600, Jason Gunthorpe wrote:
> > > Consider the kAPI work to add the new MR stuff that Christoph
> > > did. That would have been a total disaster if they didn't update all
> > > the drivers to work with it at the same time.
> > >
> > > Userspace is no different, and the responsibility falls with the patch
> > > author to oversee that process and get it done before merging.
> >
> > Yes.  I think we need to a) put all userspace providers into the
> > libibverbs repository, and b) require patches to update all of them.
> > That's the only way to have coherent releases and avoid bitrot.
> 
> Yep, that would be great.
> 
> Jason

I have a concern about the loss of control that might happen.  For example, now
I can release a new libcxgb4 whenever it works for me.  I wouldn't want to give
that up and require everyone's blessing/coordination to release bug fixes that
are completely in libcxgb4.  How can we handle this with a single repo for all
the provider libs?

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
