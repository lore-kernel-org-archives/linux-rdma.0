From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next V2 5/9] IB/ocrdma: Move user vendor structures
Date: Thu, 22 Sep 2016 20:13:54 +0530
Message-ID: <CANjDDBi1mYG+B4a3zxbHX3aGqNhKY67xTFwFnTdYq28dNhqgKQ@mail.gmail.com>
References: <1474554679-21953-1-git-send-email-leon@kernel.org> <1474554679-21953-6-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474554679-21953-6-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Acked-By: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>

On Thu, Sep 22, 2016 at 8:01 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> This patch moves ocrdma vendor's specific structures to
> common UAPI folder which will be visible to all consumers.
>
> These structures are used by user-space library driver
> (libmlx4) and currently manually copied to that library.
>
> This move will allow cross-compile against these files and
> simplify introduction of vendor specific data.
>
> In addition, it changes types to be __uXX instead of uXX.
>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  drivers/infiniband/hw/ocrdma/ocrdma_abi.h   | 149 ---------------------------
>  drivers/infiniband/hw/ocrdma/ocrdma_main.c  |   2 +-
>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |   2 +-
>  include/uapi/rdma/ocrdma-abi.h              | 151 ++++++++++++++++++++++++++++
>  4 files changed, 153 insertions(+), 151 deletions(-)
>  delete mode 100644 drivers/infiniband/hw/ocrdma/ocrdma_abi.h
>  create mode 100644 include/uapi/rdma/ocrdma-abi.h
>
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_abi.h b/drivers/infiniband/hw/ocrdma/ocrdma_abi.h
> deleted file mode 100644
> index 430b135..0000000
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_abi.h
> +++ /dev/null
> @@ -1,149 +0,0 @@
> -/* This file is part of the Emulex RoCE Device Driver for
> - * RoCE (RDMA over Converged Ethernet) adapters.
> - * Copyright (C) 2012-2015 Emulex. All rights reserved.
> - * EMULEX and SLI are trademarks of Emulex.
> - * www.emulex.com
> - *
> - * This software is available to you under a choice of one of two licenses.
> - * You may choose to be licensed under the terms of the GNU General Public
> - * License (GPL) Version 2, available from the file COPYING in the main
> - * directory of this source tree, or the BSD license below:
> - *
> - * Redistribution and use in source and binary forms, with or without
> - * modification, are permitted provided that the following conditions
> - * are met:
> - *
> - * - Redistributions of source code must retain the above copyright notice,
> - *   this list of conditions and the following disclaimer.
> - *
> - * - Redistributions in binary form must reproduce the above copyright
> - *   notice, this list of conditions and the following disclaimer in
> - *   the documentation and/or other materials provided with the distribution.
> - *
> - * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
> - * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,THE
> - * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
> - * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
> - * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
> - * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
> - * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
> - * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
> - * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
> - * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
> - * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
> - *
> - * Contact Information:
> - * linux-drivers-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org
> - *
> - * Emulex
> - * 3333 Susan Street
> - * Costa Mesa, CA 92626
> - */
> -
> -#ifndef __OCRDMA_ABI_H__
> -#define __OCRDMA_ABI_H__
> -
> -#define OCRDMA_ABI_VERSION 2
> -#define OCRDMA_BE_ROCE_ABI_VERSION 1
> -/* user kernel communication data structures. */
> -
> -struct ocrdma_alloc_ucontext_resp {
> -       u32 dev_id;
> -       u32 wqe_size;
> -       u32 max_inline_data;
> -       u32 dpp_wqe_size;
> -       u64 ah_tbl_page;
> -       u32 ah_tbl_len;
> -       u32 rqe_size;
> -       u8 fw_ver[32];
> -       /* for future use/new features in progress */
> -       u64 rsvd1;
> -       u64 rsvd2;
> -};
> -
> -struct ocrdma_alloc_pd_ureq {
> -       u64 rsvd1;
> -};
> -
> -struct ocrdma_alloc_pd_uresp {
> -       u32 id;
> -       u32 dpp_enabled;
> -       u32 dpp_page_addr_hi;
> -       u32 dpp_page_addr_lo;
> -       u64 rsvd1;
> -};
> -
> -struct ocrdma_create_cq_ureq {
> -       u32 dpp_cq;
> -       u32 rsvd; /* pad */
> -};
> -
> -#define MAX_CQ_PAGES 8
> -struct ocrdma_create_cq_uresp {
> -       u32 cq_id;
> -       u32 page_size;
> -       u32 num_pages;
> -       u32 max_hw_cqe;
> -       u64 page_addr[MAX_CQ_PAGES];
> -       u64 db_page_addr;
> -       u32 db_page_size;
> -       u32 phase_change;
> -       /* for future use/new features in progress */
> -       u64 rsvd1;
> -       u64 rsvd2;
> -};
> -
> -#define MAX_QP_PAGES 8
> -#define MAX_UD_AV_PAGES 8
> -
> -struct ocrdma_create_qp_ureq {
> -       u8 enable_dpp_cq;
> -       u8 rsvd;
> -       u16 dpp_cq_id;
> -       u32 rsvd1;      /* pad */
> -};
> -
> -struct ocrdma_create_qp_uresp {
> -       u16 qp_id;
> -       u16 sq_dbid;
> -       u16 rq_dbid;
> -       u16 resv0;      /* pad */
> -       u32 sq_page_size;
> -       u32 rq_page_size;
> -       u32 num_sq_pages;
> -       u32 num_rq_pages;
> -       u64 sq_page_addr[MAX_QP_PAGES];
> -       u64 rq_page_addr[MAX_QP_PAGES];
> -       u64 db_page_addr;
> -       u32 db_page_size;
> -       u32 dpp_credit;
> -       u32 dpp_offset;
> -       u32 num_wqe_allocated;
> -       u32 num_rqe_allocated;
> -       u32 db_sq_offset;
> -       u32 db_rq_offset;
> -       u32 db_shift;
> -       u64 rsvd[11];
> -} __packed;
> -
> -struct ocrdma_create_srq_uresp {
> -       u16 rq_dbid;
> -       u16 resv0;      /* pad */
> -       u32 resv1;
> -
> -       u32 rq_page_size;
> -       u32 num_rq_pages;
> -
> -       u64 rq_page_addr[MAX_QP_PAGES];
> -       u64 db_page_addr;
> -
> -       u32 db_page_size;
> -       u32 num_rqe_allocated;
> -       u32 db_rq_offset;
> -       u32 db_shift;
> -
> -       u64 rsvd2;
> -       u64 rsvd3;
> -};
> -
> -#endif                         /* __OCRDMA_ABI_H__ */
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
> index 07d0c6c..6393038 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
> @@ -56,7 +56,7 @@
>  #include "be_roce.h"
>  #include "ocrdma_hw.h"
>  #include "ocrdma_stats.h"
> -#include "ocrdma_abi.h"
> +#include <rdma/ocrdma-abi.h>
>
>  MODULE_VERSION(OCRDMA_ROCE_DRV_VERSION);
>  MODULE_DESCRIPTION(OCRDMA_ROCE_DRV_DESC " " OCRDMA_ROCE_DRV_VERSION);
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> index 0aa8547..6af44f8 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> @@ -51,7 +51,7 @@
>  #include "ocrdma.h"
>  #include "ocrdma_hw.h"
>  #include "ocrdma_verbs.h"
> -#include "ocrdma_abi.h"
> +#include <rdma/ocrdma-abi.h>
>
>  int ocrdma_query_pkey(struct ib_device *ibdev, u8 port, u16 index, u16 *pkey)
>  {
> diff --git a/include/uapi/rdma/ocrdma-abi.h b/include/uapi/rdma/ocrdma-abi.h
> new file mode 100644
> index 0000000..9f28191
> --- /dev/null
> +++ b/include/uapi/rdma/ocrdma-abi.h
> @@ -0,0 +1,151 @@
> +/* This file is part of the Emulex RoCE Device Driver for
> + * RoCE (RDMA over Converged Ethernet) adapters.
> + * Copyright (C) 2012-2015 Emulex. All rights reserved.
> + * EMULEX and SLI are trademarks of Emulex.
> + * www.emulex.com
> + *
> + * This software is available to you under a choice of one of two licenses.
> + * You may choose to be licensed under the terms of the GNU General Public
> + * License (GPL) Version 2, available from the file COPYING in the main
> + * directory of this source tree, or the BSD license below:
> + *
> + * Redistribution and use in source and binary forms, with or without
> + * modification, are permitted provided that the following conditions
> + * are met:
> + *
> + * - Redistributions of source code must retain the above copyright notice,
> + *   this list of conditions and the following disclaimer.
> + *
> + * - Redistributions in binary form must reproduce the above copyright
> + *   notice, this list of conditions and the following disclaimer in
> + *   the documentation and/or other materials provided with the distribution.
> + *
> + * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
> + * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,THE
> + * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
> + * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
> + * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
> + * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
> + * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
> + * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
> + * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
> + * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
> + * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
> + *
> + * Contact Information:
> + * linux-drivers-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org
> + *
> + * Emulex
> + * 3333 Susan Street
> + * Costa Mesa, CA 92626
> + */
> +
> +#ifndef OCRDMA_ABI_USER_H
> +#define OCRDMA_ABI_USER_H
> +
> +#include <linux/types.h>
> +
> +#define OCRDMA_ABI_VERSION 2
> +#define OCRDMA_BE_ROCE_ABI_VERSION 1
> +/* user kernel communication data structures. */
> +
> +struct ocrdma_alloc_ucontext_resp {
> +       __u32 dev_id;
> +       __u32 wqe_size;
> +       __u32 max_inline_data;
> +       __u32 dpp_wqe_size;
> +       __u64 ah_tbl_page;
> +       __u32 ah_tbl_len;
> +       __u32 rqe_size;
> +       __u8 fw_ver[32];
> +       /* for future use/new features in progress */
> +       __u64 rsvd1;
> +       __u64 rsvd2;
> +};
> +
> +struct ocrdma_alloc_pd_ureq {
> +       __u64 rsvd1;
> +};
> +
> +struct ocrdma_alloc_pd_uresp {
> +       __u32 id;
> +       __u32 dpp_enabled;
> +       __u32 dpp_page_addr_hi;
> +       __u32 dpp_page_addr_lo;
> +       __u64 rsvd1;
> +};
> +
> +struct ocrdma_create_cq_ureq {
> +       __u32 dpp_cq;
> +       __u32 rsvd; /* pad */
> +};
> +
> +#define MAX_CQ_PAGES 8
> +struct ocrdma_create_cq_uresp {
> +       __u32 cq_id;
> +       __u32 page_size;
> +       __u32 num_pages;
> +       __u32 max_hw_cqe;
> +       __u64 page_addr[MAX_CQ_PAGES];
> +       __u64 db_page_addr;
> +       __u32 db_page_size;
> +       __u32 phase_change;
> +       /* for future use/new features in progress */
> +       __u64 rsvd1;
> +       __u64 rsvd2;
> +};
> +
> +#define MAX_QP_PAGES 8
> +#define MAX_UD_AV_PAGES 8
> +
> +struct ocrdma_create_qp_ureq {
> +       __u8 enable_dpp_cq;
> +       __u8 rsvd;
> +       __u16 dpp_cq_id;
> +       __u32 rsvd1;    /* pad */
> +};
> +
> +struct ocrdma_create_qp_uresp {
> +       __u16 qp_id;
> +       __u16 sq_dbid;
> +       __u16 rq_dbid;
> +       __u16 resv0;    /* pad */
> +       __u32 sq_page_size;
> +       __u32 rq_page_size;
> +       __u32 num_sq_pages;
> +       __u32 num_rq_pages;
> +       __u64 sq_page_addr[MAX_QP_PAGES];
> +       __u64 rq_page_addr[MAX_QP_PAGES];
> +       __u64 db_page_addr;
> +       __u32 db_page_size;
> +       __u32 dpp_credit;
> +       __u32 dpp_offset;
> +       __u32 num_wqe_allocated;
> +       __u32 num_rqe_allocated;
> +       __u32 db_sq_offset;
> +       __u32 db_rq_offset;
> +       __u32 db_shift;
> +       __u64 rsvd[11];
> +} __packed;
> +
> +struct ocrdma_create_srq_uresp {
> +       __u16 rq_dbid;
> +       __u16 resv0;    /* pad */
> +       __u32 resv1;
> +
> +       __u32 rq_page_size;
> +       __u32 num_rq_pages;
> +
> +       __u64 rq_page_addr[MAX_QP_PAGES];
> +       __u64 db_page_addr;
> +
> +       __u32 db_page_size;
> +       __u32 num_rqe_allocated;
> +       __u32 db_rq_offset;
> +       __u32 db_shift;
> +
> +       __u64 rsvd2;
> +       __u64 rsvd3;
> +};
> +
> +#endif /* OCRDMA_ABI_USER_H */
> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
