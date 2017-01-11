From: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: rdma-core package version schema
Date: Wed, 11 Jan 2017 23:17:02 +0100
Message-ID: <1484173022.4567.101.camel@oracle.com>
References: <1483642867.5227.18.camel@profitbricks.com>
         <20170105230928.GA4262@obsidianresearch.com>
         <1483723704.5227.23.camel@profitbricks.com>
         <20170108084759.GJ15685@mtr-leonro.local>
         <1484139556.2191.48.camel@oracle.com>
         <20170111221004.GA31081@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170111221004.GA31081-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-01-11 at 15:10 -0700, Jason Gunthorpe wrote:
> On Wed, Jan 11, 2017 at 01:59:16PM +0100, Knut Omang wrote:
> 
> > It seems that interface is only available for those with write
> > access to the github repo which does not cover the (for me at least)
> > common use case that I want to built my own slightly modified test
> > .rpm of something. Then users will end up creating tarballs
> > manually, or outside the build logic, with potentials for mistakes,
> > not to mention the??  documentation need to tell users this.
> 
> Any user can run git archive and it will always create the correct
> result.
> 
> $ git archive --prefix rdma-core/ --output rdma-core-12.tgz HEAD
> 
> No other steps are required.

Wonderful, I'll add it to my git vocabulary,

Thanks,
Knut

> > Isn't a dist target a well established standard the rdma_core packages should??
> > support for simplicity and uniformity?
> 
> 'make dist' is kinda a GNUism where packages that use auto* require
> building pre-build auto* stuff into their tar files. We do not require
> that and our dist tar file is identical to what git archive produces.
> 
> For developers we have the buildlib/cbuild script. Install docker and
> it will automate building packages for you:
> 
> $ buildlib/cbuild build-images centos7  # One time
> $ buildlib/cbuild pkg centos7
> 
> It takes care of all the details and guarantees the build is done with
> the correct set of build time packages.
> 
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
