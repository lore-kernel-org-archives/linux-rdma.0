From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v2 rdma-core 1/6] Common infrastructure for auto loading
 rdma modules
Date: Fri, 28 Jul 2017 17:01:46 -0600
Message-ID: <20170728230146.GA16183@obsidianresearch.com>
References: <1501194685-9447-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1501194685-9447-2-git-send-email-jgunthorpe@obsidianresearch.com>
 <20170728214855.GA13840@ctung-MOBL3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170728214855.GA13840-TZeIlv3TuzOfrEmaQUPKxl95YUYmaKo1UNDiOz3kqAs@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 28, 2017 at 04:48:55PM -0500, Chien Tin Tung wrote:

> Sorry Jason, I can't test this till next week.  On inspection I found a couple of issues
> below.

Sure, thanks!

> > +# Hardware that supports InfiniBand
> > +DRIVERS=="mlx4_core", ENV{ID_RDMA_INFINIBAND}="1"
> > +DRIVERS=="mlx5_core", ENV{ID_RDMA_INFINIBAND}="1"
> > +DRIVERS=="qib", ENV{ID_RDMA_INFINIBAND}="1"
> > +
> > +# Hardware that supports OPA
> > +DRIVERS=="hfi1verbs", ENV{ID_RDMA_OPA}="1"
> > +
> > +# Hardware that supports iWarp
> > +DRIVERS=="cxgb3", ENV{ID_RDMA_IWARP}="1"
> > +DRIVERS=="cxgb4", ENV{ID_RDMA_IWARP}="1"
> 
> Need to add nes and i40e here under iWARP.

Okay, yes.. nes was missed because I was not able to guess the
ethernet driver name, I will add it and move i40e

> This is enough to autoload iwpmd for nes and i40e/i40iw, correct?

Yes, ID_RDMA_IWARP in the udev database does that and whatever else in
future we need.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
