From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: [PATCH V5 0/5] iSER support for iWARP
Date: Mon, 06 Jul 2015 17:38:53 -0700
Message-ID: <1436229533.6297.0.camel@haakon3.risingtidesystems.com>
References: <20150705174353.10042.39648.stgit@build2.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150705174353.10042.39648.stgit-PBeJgSbIpn97NCTnQtmixQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Steve & Co,

On Sun, 2015-07-05 at 12:44 -0500, Steve Wise wrote:
> The following series implements support for iWARP transports in the iSER
> initiator and target.  This is based on Doug's k.o/for-4.2 branch.
> 
> I've tested this on cxgb4 and mlx4 hardware.
> 
> Changes since V4:
> 
> iser: fixedcompiler warning
> 
> isert: back to setting REMOTE_WRITE only for iWARP devices
> 
> Changes since V3:
> 
> Fixed commit messages based on feedback.
> 
> iser: adjust max_sectors
> 
> isert: split into 2 patches
> 
> isert: always set REMOTE_WRITE for dma mrs
> 
> Changes since V2:
> 
> The transport independent work is removed from this series and will
> be submitted in a subsequent series.  This V3 series now enables iWARP
> using existing core services.
> 
> Changes since V1:
> 
> Introduce and use transport-independent RDMA core services for allocating
> DMA MRs and computing fast register access flags.
> 
> Correctly set the device max_sge_rd capability in several rdma device
> drivers.
> 
> isert: use device capability max_sge_rd for the read sge depth.
> 
> isert: change max_sge to max_write_sge in struct isert_conn.
> 
> ---
> 
> Sagi Grimberg (1):
>       mlx4, mlx5, mthca: Expose max_sge_rd correctly
> 
> Steve Wise (4):
>       RDMA/isert: Limit read depth based on the device max_sge_rd capability
>       RDMA/isert: Set REMOTE_WRITE on DMA MRs to support iWARP devices
>       RDMA/iser: Limit sg tablesize and max_sectors to device fastreg max depth
>       ipath,qib: Expose max_sge_rd correctly
> 
> 
>  drivers/infiniband/hw/ipath/ipath_verbs.c    |    1 
>  drivers/infiniband/hw/mlx4/main.c            |    1 
>  drivers/infiniband/hw/mlx5/main.c            |    1 
>  drivers/infiniband/hw/mthca/mthca_provider.c |    1 
>  drivers/infiniband/hw/qib/qib_verbs.c        |    1 
>  drivers/infiniband/ulp/iser/iscsi_iser.c     |    9 ++++
>  drivers/infiniband/ulp/isert/ib_isert.c      |   53 ++++++++++++++++++++++----
>  drivers/infiniband/ulp/isert/ib_isert.h      |    3 +
>  8 files changed, 60 insertions(+), 10 deletions(-)
> 

Very excited to see iWARP support for iser-initiator + iser-target.  ;)

No objections to taking the iser-target changes through Doug's
infiniband.git.  For the target pieces:

Acked-by: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>

Also Doug, since this series is sufficiently small enough, and allows a class
of hardware that people are expecting to function with iser to 'just work', I'd
recommend to go ahead and push this series for v4.2-rc code.

Thank you,

--nab


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
