From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH rdma-core 09/10] Move the now private infiniband/arch.h to util/udma_barrier.h
Date: Thu, 9 Feb 2017 16:25:57 -0600
Message-ID: <049e01d28323$7bc1fb10$7345f130$@opengridcomputing.com>
References: <1486677212-3188-1-git-send-email-jgunthorpe@obsidianresearch.com> <1486677212-3188-10-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1486677212-3188-10-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: [PATCH rdma-core 09/10] Move the now private infiniband/arch.h to
> util/udma_barrier.h
> 
> This header now only contains the DMA barrier macros.
> 
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  CMakeLists.txt                 |   2 +-
>  buildlib/travis-build          |   2 +-
>  libibverbs/CMakeLists.txt      |   1 -
>  libibverbs/arch.h              | 135
-----------------------------------------
>  providers/cxgb3/iwch.h         |   2 +-
>  providers/cxgb4/libcxgb4.h     |   2 +-
>  providers/hns/hns_roce_u.h     |   2 +-
>  providers/i40iw/i40iw_osdep.h  |   2 +-
>  providers/i40iw/i40iw_uk.c     |   2 +
>  providers/i40iw/i40iw_umain.h  |   2 +-
>  providers/mlx4/mlx4.h          |   2 +-
>  providers/mlx5/mlx5.h          |   2 +-
>  providers/mthca/mthca.h        |   2 +-
>  providers/nes/nes_umain.h      |   2 +-
>  providers/ocrdma/ocrdma_main.h |   2 +-
>  providers/qedr/qelr.h          |   2 +-
>  providers/qedr/qelr_main.h     |   2 +-
>  providers/qedr/qelr_verbs.h    |   2 +-
>  providers/vmw_pvrdma/cq.c      |   2 +-
>  providers/vmw_pvrdma/qp.c      |   2 +-
>  util/CMakeLists.txt            |   1 +
>  util/udma_barrier.h            | 125 ++++++++++++++++++++++++++++++++++++++
>  22 files changed, 145 insertions(+), 153 deletions(-)
>  delete mode 100644 libibverbs/arch.h
>  create mode 100644 util/udma_barrier.h
> 

cxgb* parts look fine.

Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
