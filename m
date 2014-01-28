From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] IB: Refactor umem to use linear SG table
Date: Tue, 28 Jan 2014 15:01:22 +0200
Message-ID: <52E7AA22.8020700@mellanox.com>
References: <1390909215-5331-1-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1390909215-5331-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Upinder Malhi (umalhi)" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 28/01/2014 13:40, Or Gerlitz wrote:
> From: Yishai Hadas<yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> This patch does refactoring of the IB core umem code and vendor drivers to use
> linear SG table instead of chunk list. With this change the relevant code becomes
> more clear, no need for nested loops to build and use umem.
>
> The patch includes: umem changes to work with linear SG table and Vendors driver
> changes to use SG instead of chunk list.
>
> Cc: Faisal Latif<faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Mike Marciniszyn<infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Hoang-Nam Nguyen<hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
> Cc: Steve Wise<swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> Signed-off-by: Shachar Raindel<raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Yishai Hadas<yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>   drivers/infiniband/core/umem.c               |  120 ++++++-------
>   drivers/infiniband/hw/amso1100/c2_provider.c |   23 +--
>   drivers/infiniband/hw/cxgb3/iwch_provider.c  |   19 +--
>   drivers/infiniband/hw/cxgb4/mem.c            |   39 ++---
>   drivers/infiniband/hw/ehca/ehca_classes.h    |    2 +-
>   drivers/infiniband/hw/ehca/ehca_mrmw.c       |  245 ++++++++++---------------
>   drivers/infiniband/hw/ipath/ipath_mr.c       |   39 ++---
>   drivers/infiniband/hw/mlx4/doorbell.c        |    4 +-
>   drivers/infiniband/hw/mlx4/mr.c              |   39 ++--
>   drivers/infiniband/hw/mlx5/doorbell.c        |    4 +-
>   drivers/infiniband/hw/mlx5/mem.c             |   80 ++++----
>   drivers/infiniband/hw/mthca/mthca_provider.c |   42 ++---
>   drivers/infiniband/hw/nes/nes_verbs.c        |  253 +++++++++++++-------------
>   drivers/infiniband/hw/ocrdma/ocrdma_verbs.c  |   66 ++++----
>   drivers/infiniband/hw/qib/qib_mr.c           |   14 +-
>   include/rdma/ib_umem.h                       |   11 +-
>   16 files changed, 448 insertions(+), 552 deletions(-)

While looking on this patch I suddenly noticed that unlike the rest of 
the hw drivers, the usnic driver doesn't call ib_umem_get but rather 
implements it -- while duplicating code/functionality which exists in 
the IB core, agree? why?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
