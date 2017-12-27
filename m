From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/9] i40iw updates for 4.16
Date: Wed, 27 Dec 2017 10:21:25 -0700
Message-ID: <20171227172125.GD25436@ziepe.ca>
References: <20171222154702.12632-1-shiraz.saleem@intel.com>
 <20171222233650.GA17198@ziepe.ca>
 <20171223162708.GA13848@ssaleem-MOBL4.amr.corp.intel.com>
 <20171227145801.GA25436@ziepe.ca>
 <748B799B6A00724488C603FD7E5E7EB977BADFAC@FMSMSX114.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <748B799B6A00724488C603FD7E5E7EB977BADFAC-XfjTATA9Em864kNsxIetb7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Saleem, Shiraz" <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 27, 2017 at 04:11:01PM +0000, Tung, Chien Tin wrote:
> > From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> > owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Jason Gunthorpe
> > Sent: Wednesday, December 27, 2017 8:58 AM
> > To: Saleem, Shiraz <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; e1000-
> > rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> > Subject: Re: [PATCH rdma-next 0/9] i40iw updates for 4.16
> > 
> > On Sat, Dec 23, 2017 at 10:27:08AM -0600, Shiraz Saleem wrote:
> > > On Fri, Dec 22, 2017 at 04:36:50PM -0700, Jason Gunthorpe wrote:
> > > > On Fri, Dec 22, 2017 at 09:46:53AM -0600, Shiraz Saleem wrote:
> > > > > Hi Doug/Jason,
> > > > >
> > > > > This patch set includes bug fixes, code refactoring, a new netdev
> > > > > event notifier and misc. improvements. Please consider it for 4.16.
> > > >
> > > > I took this from the v0 series and manually fixed the const myself.
> > > >
> > > > I also fixed the checkpatch long line warnings, so please watch out
> > > > for things like that.
> > > >
> > > We try to keep our line length < 100 in general.
> > > Are we enforcing the 80 char line length limit?
> > 
> > It is the kernel style, and the goal is to have all code follow the major tenants
> > of it.
> > 
> > Linus has come out in the past against > 80 lines as a metric of too much
> > complexity.
> > 
> > Jason
> 
> Many years ago when someone made a stink about nes driver having long lines,
> Linus got involved in that discussion.  He was not in the camp of strictly
> adhering to the 80 column rule.  May be he changed his stance since then.
> Jason, can you reference an email from Linus so I can update my mental
> notes on proper kernel development process?

AFAIK the guideline is not a hard guideline, but one of readability.

eg I rewrapped your function declarations because there is no
readability win for them to be > 80.

Which is what Documentation/coding-style.rst says.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
