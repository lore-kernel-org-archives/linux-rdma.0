From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [for-next V2 0/5] Enable features in Broadcom's RoCE driver
Date: Sun, 14 Jan 2018 21:18:06 +0530
Message-ID: <CANjDDBiJ7ERUCxfJ=ZU5FNznKvO7prRF5_i1ZT0sgXoczFB=6Q@mail.gmail.com>
References: <1515689531-25770-1-git-send-email-devesh.sharma@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1515689531-25770-1-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Doug/Jason

if there are no further review comments on V2 series, could you please
pull this in...

On Thu, Jan 11, 2018 at 10:22 PM, Devesh Sharma
<devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org> wrote:
> This patch series adds support for RoCE virtual functions (patch 1),
> firmware version string (patch 2), Hugepage MRs (patch 3), detailed
> RoCE statistics (patch 4) and shared receive queue (patch 5).
>
> v1->v2:
> Addressed comment from Leon for Patch 2
>
> Devesh Sharma (1):
>   RDMA/bnxt_re: Add SRQ support for Broadcom adapters
>
> Selvin Xavier (3):
>   RDMA/bnxt_re: Enable RoCE on virtual functions
>   RDMA/bnxt_re: Add support for query firmware version
>   RDMA/bnxt_re: expose detailed stats retrieved from HW
>
> Somnath Kotur (1):
>   RDMA/bnxt_re: Add support for MRs with Huge pages
>
>  drivers/infiniband/hw/bnxt_re/bnxt_re.h     |  43 ++-
>  drivers/infiniband/hw/bnxt_re/hw_counters.c | 145 ++++++++-
>  drivers/infiniband/hw/bnxt_re/hw_counters.h |  39 +++
>  drivers/infiniband/hw/bnxt_re/ib_verbs.c    | 395 +++++++++++++++++++++---
>  drivers/infiniband/hw/bnxt_re/ib_verbs.h    |  20 ++
>  drivers/infiniband/hw/bnxt_re/main.c        | 249 ++++++++++++---
>  drivers/infiniband/hw/bnxt_re/qplib_fp.c    | 462 ++++++++++++++++++++++++----
>  drivers/infiniband/hw/bnxt_re/qplib_fp.h    |  78 +++--
>  drivers/infiniband/hw/bnxt_re/qplib_rcfw.c  |   5 +-
>  drivers/infiniband/hw/bnxt_re/qplib_rcfw.h  |   7 +-
>  drivers/infiniband/hw/bnxt_re/qplib_sp.c    | 141 ++++++++-
>  drivers/infiniband/hw/bnxt_re/qplib_sp.h    |  91 +++++-
>  drivers/infiniband/hw/bnxt_re/roce_hsi.h    | 127 +++++++-
>  include/uapi/rdma/bnxt_re-abi.h             |   9 +
>  14 files changed, 1600 insertions(+), 211 deletions(-)
>
> --
> 1.8.3.1
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
