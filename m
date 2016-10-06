From: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] i40iw: Add Quality of Service support
Date: Thu, 6 Oct 2016 16:26:59 -0500
Message-ID: <20161006212659.GB6664@horosco-MOBL2.amr.corp.intel.com>
References: <20161006152128.14940-1-henry.orosco@intel.com>
 <20161006160016.GQ9282@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161006160016.GQ9282-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 06, 2016 at 07:00:16PM +0300, Leon Romanovsky wrote:
> On Thu, Oct 06, 2016 at 10:21:28AM -0500, Henry Orosco wrote:
> > Add support for QoS on QPs. Upon device initialization,
> > a map is created from user priority to queue set
> > handles. On QP creation, use ToS to look up the queue
> > set handle for use with the QP.
> >
> > Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > ---
> >  drivers/infiniband/hw/i40iw/i40iw.h       |   9 ++
> >  drivers/infiniband/hw/i40iw/i40iw_cm.c    |  30 +++++-
> >  drivers/infiniband/hw/i40iw/i40iw_cm.h    |   2 +-
> >  drivers/infiniband/hw/i40iw/i40iw_ctrl.c  | 151 +++++++++++++++++++++++++++++-
> >  drivers/infiniband/hw/i40iw/i40iw_d.h     |   2 +
> >  drivers/infiniband/hw/i40iw/i40iw_hw.c    |  25 ++---
> >  drivers/infiniband/hw/i40iw/i40iw_main.c  |  64 +++++++++++--
> >  drivers/infiniband/hw/i40iw/i40iw_osdep.h |   2 +
> >  drivers/infiniband/hw/i40iw/i40iw_p.h     |   2 +
> >  drivers/infiniband/hw/i40iw/i40iw_puda.c  |   3 +-
> >  drivers/infiniband/hw/i40iw/i40iw_type.h  |  18 +++-
> >  drivers/infiniband/hw/i40iw/i40iw_utils.c |  45 +++++++++
> >  drivers/infiniband/hw/i40iw/i40iw_verbs.c |   6 +-
> >  13 files changed, 323 insertions(+), 36 deletions(-)
> 
> I believe that it can be split to series.

As all this code is a logical unit for QoS support, we thought
it best to submit as a single patch.

Doug, what is your preference?
> 
> >  mode change 100644 => 100755 drivers/infiniband/hw/i40iw/i40iw_cm.c
> >  mode change 100644 => 100755 drivers/infiniband/hw/i40iw/i40iw_ctrl.c
> 
> Why did you change file's mode from 644 to 755?

Nice catch! Will send out another version with this fixed.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
