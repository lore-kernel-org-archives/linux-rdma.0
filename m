From: "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V2 08/10] i40iw: Control debug error prints using env
 variable
Date: Thu, 15 Dec 2016 19:55:18 +0000
Message-ID: <13AA599688F47243B14FCFCCC2C803BB10AC7E53@fmsmsx104.amr.corp.intel.com>
References: <1481306104-19352-1-git-send-email-tatyana.e.nikolova@intel.com>
 <1481306104-19352-9-git-send-email-tatyana.e.nikolova@intel.com>
 <20161210143421.GC2521@mtr-leonro.local>
 <13AA599688F47243B14FCFCCC2C803BB10AC7081@fmsmsx104.amr.corp.intel.com>
 <20161214171111.GA4521@mtr-leonro.local>
 <20161214212103.GA6947@obsidianresearch.com>
 <20161215064807.GB811@mtr-leonro.local>
 <20161215165420.GA3264@obsidianresearch.com>
 <20161215183537.GH811@mtr-leonro.local>
 <20161215185034.GB16552@obsidianresearch.com>
 <20161215191751.GJ811@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161215191751.GJ811-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Leon,

Please see inline.

> -----Original Message-----
> From: Leon Romanovsky [mailto:leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org]
> Sent: Thursday, December 15, 2016 1:18 PM
> To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> Cc: Nikolova, Tatyana E <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>;
> dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; e1000-
> rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> Subject: Re: [PATCH V2 08/10] i40iw: Control debug error prints using env
> variable
> 
> On Thu, Dec 15, 2016 at 11:50:34AM -0700, Jason Gunthorpe wrote:
> > On Thu, Dec 15, 2016 at 08:35:37PM +0200, Leon Romanovsky wrote:
> >
> > > I had in mind much simplier infrastucture, just add pr_debug(..)
> > > call and allow every provider to place in any place in their code.
> >
> > I think the bitmask thing has to be hoisted too.
> >
> > > My main point is that I want to see all ENV variables in one place.
> >
> > Why?
> 
> There are two reasons:
> 1. Easy to document and for curious users to spot all possible variables.

[Tatyana Nikolova] Thank you for providing an example for the environment variables. IMO the malloc implementation brings unnecessary overhead in terms of memory and code.

A text file containing all environment variables and updated every time a new environment variable is added sounds like a good idea to keep them in one place.

> 2. It helps to potential authors to reuse variables instead of inventing their
> own.

[Tatyana Nikolova] 
 
Jason gave an example with " VERBS_PROVIDER_DEBUG=qp,ah,blah". Should all of the environment variables, enabling other features in rdma-core use a similar approach?

Current environment variables are provider specific. How are they going to be reused without renaming? Renaming may create issues with applications and scripts already using the existing ones.

> >
> > I really don't want to see util/ files include provider headers, for
> > instance, so I don't like your SET() macro idea..
> >
> > At this point I'd settle for having all ENV vars *documented* in one
> > place :(
> 
> See, reason #1 :)
> 
> >
> > Jason
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma"
> > in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More
> majordomo
> > info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
