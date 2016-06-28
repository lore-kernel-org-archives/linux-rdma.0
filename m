From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: Upcoming libibverbs release
Date: Tue, 28 Jun 2016 14:12:19 -0500
Message-ID: <022001d1d170$fda2c3e0$f8e84ba0$@opengridcomputing.com>
References: <3b89c411-72be-ddc5-5ebf-009eeee29692@redhat.com> <4ec1d8e6-a908-bb49-a137-415856ec6faa@dev.mellanox.co.il> <20160627181758.GD23540@obsidianresearch.com> <20160628050246.GB3584@leon.nu> <20160628162028.GA27518@obsidianresearch.com> <20160628170549.GE3584@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160628170549.GE3584-2ukJVAZIZ/Y@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: 'Yishai Hadas' <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Matan Barak' <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Majd Dibbiny' <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> On Tue, Jun 28, 2016 at 10:20:28AM -0600, Jason Gunthorpe wrote:
> > On Tue, Jun 28, 2016 at 08:02:46AM +0300, Leon Romanovsky wrote:
> > > On Mon, Jun 27, 2016 at 12:17:58PM -0600, Jason Gunthorpe wrote:
> > > > Doug and I have both stated we don't want to see so many
> > > > single-provider APIs and churn in libibverbs. This was designed to be
> > > > a generic API that all providers can implement.
> > > >
> > > > The responsibility falls on you to make sure that it works
> > > > universally. Compat is one option.
> > > >
> > > > This is also why it is necessary to get the other provider authors to
> > > > say this works on their hardware, because they *all* ultimately have
> > > > to implement it.
> > > >
> > > > I don't think many people realize this yet.
> > > >
> > >
> > > Jason,
> > > You are over-estimating the number of other providers who are
> > > interesting in libibverbs in 2014-2016.
> >
> > I don't think that is a reasonable metric, verbs is stable, I don't
> > expect companies to be constantly churning it.
> >
> > And that certainly doesn't mean we should abandon their providers when
> > building new APIs.
> >
> > However, if that is your position then propose a patch so libibverbs
> > with the new polling API will not load old providers that do not
> > support it, and they can be deprecated. If their authors don't object,
> > like you predict, then great.
> >
> > But at the end of the day, the message to users must be to use the
> > new polling API, the old one is deprecated, and apps should never
> > include fallback code because the new API always works.
> 
> Please put aside Yishai's patches, I'm not taking about them.
> 
> We are talking about the total number of other vendors who will
> be ready to implement new features exposed in libibverbs.
> 
> Git log perfectly supports my claim that this number is extremely low.
> 

I haven't been following this (long) thread closely enough, but I hope any new
functionality is not _breaking_ existing applications from using _currently
supported_ providers?  I thought all this CQ accessor cruft was backwards
compatible.  Perhaps I'm wrong?





--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
