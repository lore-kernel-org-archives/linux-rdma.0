From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/3] Add const to various core functions
Date: Fri, 29 May 2015 11:17:36 -0400
Message-ID: <20150529151735.GA5372@phlsvsds.ph.intel.com>
References: <1432240824-3277-1-git-send-email-ira.weiny@intel.com> <20150529041313.GA1603@phlsvsds.ph.intel.com> <1432904099.114391.61.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1432904099.114391.61.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, May 29, 2015 at 08:54:59AM -0400, Doug Ledford wrote:
> On Fri, 2015-05-29 at 00:13 -0400, ira.weiny wrote:
> > On Thu, May 21, 2015 at 04:40:21PM -0400, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> > > From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > 
> > Doug, Jason,
> > 
> > Were there any issues with these clean ups?
> 
> I haven't gotten to them yet.  Your 14 patch OPA addition and this were
> on my queue for getting to relatively soonish.  I *thought* this touched
> stuff that your 14 patch set also touched and so thought it needed to be
> on top of it, so that's part of the reason why I hadn't even looked at
> it yet (these emails are part of the "still new and unread" emails in my
> Inbox that seem to never get to 0 ;-).

I understand.

> 
> > I think they stand on their own but I can add them to the OPA series if you
> > prefer.
> 
> Double check that they stand on their own.  If they do, I'll review them
> separately.

They do stand on their own and they are improvements even without the OPA code.

They became precursors to the next OPA series because I am changing some core
functions.  In order to declare parameters of those core functions const the
entire call chain required updating.  Rather than mix that call chain clean up
with the new OPA code I felt it would be easier to review these as separate
clean up patches.

If this is an unorthodox procedure, is there a better way to handle something
like this?

As more and more clean up becomes necessary in the core I don't want the OPA
changes to become a huge patch series which is unwieldy to review and mostly
cleanup.  (If you count Michaels changes the "clean up" to the core which OPA
now relies on count for more patches then the actual OPA changes.) I'm trying
to reduce the review workload by making clear which patches are clean up vs
actual OPA code.

Apologies,
Ira

> 
> > Ira
> > 
> > > 
> > > In order to support some of Jason's comments to add const to the functions I am
> > > adding for OPA the following patches clean up the call trees of the currently
> > > defined functions.
> > > 
> > > They stand on their own as clean up patches.  Therefore, I am submitting them
> > > separately from the OPA patches.
> > > 
> > > Ira Weiny (3):
> > >   IB/core: Add const to RDMA helpers
> > >   IB/core: Add const to device process_mad
> > >   IB/core: Add const to agent_send_response
> > > 
> > >  drivers/infiniband/core/addr.c                |  4 +--
> > >  drivers/infiniband/core/agent.c               |  8 +++---
> > >  drivers/infiniband/core/agent.h               |  4 +--
> > >  drivers/infiniband/core/cache.c               |  8 +++---
> > >  drivers/infiniband/core/verbs.c               |  9 ++++---
> > >  drivers/infiniband/hw/amso1100/c2_provider.c  |  6 ++---
> > >  drivers/infiniband/hw/cxgb3/iwch_provider.c   |  6 ++---
> > >  drivers/infiniband/hw/cxgb4/provider.c        |  5 ++--
> > >  drivers/infiniband/hw/ehca/ehca_iverbs.h      |  4 +--
> > >  drivers/infiniband/hw/ehca/ehca_sqp.c         |  4 +--
> > >  drivers/infiniband/hw/ipath/ipath_mad.c       |  8 +++---
> > >  drivers/infiniband/hw/ipath/ipath_verbs.h     |  6 ++---
> > >  drivers/infiniband/hw/mlx4/mad.c              | 21 ++++++++-------
> > >  drivers/infiniband/hw/mlx4/mlx4_ib.h          |  8 +++---
> > >  drivers/infiniband/hw/mlx5/mad.c              |  8 +++---
> > >  drivers/infiniband/hw/mlx5/mlx5_ib.h          |  8 +++---
> > >  drivers/infiniband/hw/mthca/mthca_cmd.c       |  4 +--
> > >  drivers/infiniband/hw/mthca/mthca_cmd.h       |  4 +--
> > >  drivers/infiniband/hw/mthca/mthca_dev.h       |  6 ++---
> > >  drivers/infiniband/hw/mthca/mthca_mad.c       | 10 +++----
> > >  drivers/infiniband/hw/nes/nes_verbs.c         |  4 +--
> > >  drivers/infiniband/hw/ocrdma/ocrdma_ah.c      |  6 ++---
> > >  drivers/infiniband/hw/ocrdma/ocrdma_ah.h      |  6 ++---
> > >  drivers/infiniband/hw/qib/qib_mad.c           | 10 +++----
> > >  drivers/infiniband/hw/qib/qib_verbs.h         |  4 +--
> > >  drivers/net/ethernet/mellanox/mlx5/core/mad.c |  2 +-
> > >  include/linux/mlx5/driver.h                   |  2 +-
> > >  include/rdma/ib_addr.h                        |  6 ++---
> > >  include/rdma/ib_cache.h                       |  8 +++---
> > >  include/rdma/ib_verbs.h                       | 39 ++++++++++++++-------------
> > >  30 files changed, 116 insertions(+), 112 deletions(-)
> > > 
> > > -- 
> > > 1.8.2
> > > 
> 
> 
> -- 
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>               GPG KeyID: 0E572FDD
> 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
