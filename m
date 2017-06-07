From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: rdma-core out-of-tree user library
Date: Wed, 7 Jun 2017 10:00:57 -0600
Message-ID: <20170607160057.GC30124@obsidianresearch.com>
References: <BN3PR07MB25781554943206E577DFC714F8CB0@BN3PR07MB2578.namprd07.prod.outlook.com>
 <20170606162400.GB8671@obsidianresearch.com>
 <BN3PR07MB25781E538767514E0585E7C4F8C80@BN3PR07MB2578.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <BN3PR07MB25781E538767514E0585E7C4F8C80-EldUQEzkDQfpW3VS/XPqkOFPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Rahman, Ameen" <Ameen.Rahman-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 07, 2017 at 07:30:43AM +0000, Amrani, Ram wrote:
> > Two options,
> > 
> > 1) The 'ofed' approach: just use the latest rdma-core. We want
> >    rdma-core to run on any kernel version and any distro release, so
> >    this should not be a major problem
> 
> My major concern was that when it comes to distros we don't have their
> exact code base and/or can't release it. They take rdma-core X and
> apply patches on it so it becomes rdma-core X.Y.

All distros I know of provide full source - GPL requires it for most
packages, and you would have a right to redistibute it, of
course.. This is no different than the kernel.

> Assuming backward-and-forward support, I might as well take rdma-core X+1
> and base upon it my newer patches.

Right, that is what I ment when I said 'latest rdma-core'

The very best thing you can do for your cusomters is to provide your
changes in a way that the distro itself would be willing to backport
and release as a minor update to their users. eg provide clear commit
messages, a fixes tag, content that is appropriate for stable
backporting and inform the distro via your corporate relationship to
take the patch. This is what Leon is talking about.

This is no different than the process for the kernel.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
