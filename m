From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC 2/2] mlx5: Sample code to exercise new device statistics
Date: Fri, 4 Mar 2016 13:15:45 -0600 (CST)
Message-ID: <alpine.DEB.2.20.1603041315100.27663@east.gentwo.org>
References: <20160304183854.551339866@linux.com> <20160304183909.703201393@linux.com> <00cb01d17649$c0deeba0$429cc2e0$@opengridcomputing.com>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <00cb01d17649$c0deeba0$429cc2e0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Mark Bloch' <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, 'Steve Wise' <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 4 Mar 2016, Steve Wise wrote:

> > Signed-off-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > ---
> >  drivers/infiniband/core/sysfs.c             | 298 ++++++++++++++++------------
> >  drivers/infiniband/hw/cxgb3/iwch_provider.c | 136 +++++++++----
> >  drivers/infiniband/hw/cxgb4/provider.c      |  26 ++-
> >  drivers/infiniband/hw/mlx5/main.c           |  35 ++++
> >  include/rdma/ib_verbs.h                     |  60 +-----
> >  5 files changed, 335 insertions(+), 220 deletions(-)
> >
>
> The diffstat shows changes to cxgb3/4 yet there are no changes in the patch.

Sorry yes this should not be here. My tool did not update that.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
