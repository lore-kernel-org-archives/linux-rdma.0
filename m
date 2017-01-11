From: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: rdma-core package version schema
Date: Wed, 11 Jan 2017 13:59:16 +0100
Message-ID: <1484139556.2191.48.camel@oracle.com>
References: <1483642867.5227.18.camel@profitbricks.com>
         <20170105230928.GA4262@obsidianresearch.com>
         <1483723704.5227.23.camel@profitbricks.com>
         <20170108084759.GJ15685@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170108084759.GJ15685-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, 2017-01-08 at 10:47 +0200, Leon Romanovsky wrote:
> On Fri, Jan 06, 2017 at 06:28:24PM +0100, Benjamin Drung wrote:
> > 
> > Am Donnerstag, den 05.01.2017, 16:09 -0700 schrieb Jason Gunthorpe:
> > > 
> > > On Thu, Jan 05, 2017 at 08:01:07PM +0100, Benjamin Drung wrote:
> > > 
> > > This is very exciting news! Please feel free to send any patches or
> > > pull requests to improve the packaging, or otherwise!
> > 
> > Expect patches from me. Before starting a bigger review, I will wait
> > for the pull request https://github.com/linux-rdma/rdma-core/pull/50
> 
> Thanks, Talat is working to address your's and Jason's feedback.
> 
> > 
> > 
> > > 
> > > I hope that
> > > significant parts of the the debian/ dir can be maintained upstream
> > > like Redhat is going to do for their packaging.
> > 
> > That is doable as long as the future Debian maintainers will have
> > commit access. Otherwise the debian directory will get out of sync
> > soon.
> 
> I don't think so, we are pretty fast to accept pull requests, and
> especially distro related ones from verified committers. However if it
> stops future Debian maintainer to manage this package upstream, we will
> give write access without doubts.
> 
> > 
> > 
> > PS: How will you create the release tarballs?
> 
> Via github interface.
> https://help.github.com/articles/creating-releases/

It seems that interface is only available for those with write access to the github repo
which does not cover the (for me at least) common use case that I want to built my own
slightly modified test .rpm of something. Then users will end up creating tarballs manually,
or outside the build logic, with potentials for mistakes, not to mention the 
documentation need to tell users this.

Isn't a dist target a well established standard the rdma_core packages should 
support for simplicity and uniformity?

Thanks,
Knut

> 
> > 
> > 
> > --
> > Benjamin Drung
> > System Developer
> > Debian & Ubuntu Developer
> > 
> > ProfitBricks GmbH
> > Greifswalder Str. 207
> > D - 10405 Berlin
> > 
> > Email: benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
> > URL:  http://www.profitbricks.com
> > 
> > Sitz der Gesellschaft: Berlin.
> > Registergericht: Amtsgericht Charlottenburg, HRB 125506B.
> > Geschäftsführer: Andreas Gauger, Achim Weiss.
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
