From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [RFC v1 17/19] RDMA/irdma: Add ABI definitions
Date: Fri, 15 Feb 2019 10:16:38 -0700
Message-ID: <20190215171638.GA30706@ziepe.ca>
References: <20190215171107.6464-1-shiraz.saleem@intel.com>
 <20190215171107.6464-18-shiraz.saleem@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190215171107.6464-18-shiraz.saleem@intel.com>
Sender: netdev-owner@vger.kernel.org
To: Shiraz Saleem <shiraz.saleem@intel.com>
Cc: dledford@redhat.com, davem@davemloft.net, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, mustafa.ismail@intel.com, jeffrey.t.kirsher@intel.com
List-Id: linux-rdma@vger.kernel.org

On Fri, Feb 15, 2019 at 11:11:04AM -0600, Shiraz Saleem wrote:
> From: Mustafa Ismail <mustafa.ismail@intel.com>
> 
> Add ABI definitions for irdma.
> 
> Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
>  include/uapi/rdma/irdma-abi.h | 140 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 140 insertions(+)
>  create mode 100644 include/uapi/rdma/irdma-abi.h
> 
> diff --git a/include/uapi/rdma/irdma-abi.h b/include/uapi/rdma/irdma-abi.h
> new file mode 100644
> index 0000000..5b0e2d5
> +++ b/include/uapi/rdma/irdma-abi.h
> @@ -0,0 +1,140 @@
> +/*
> + * Copyright (c) 2006 - 2019 Intel Corporation.  All rights reserved.
> + * Copyright (c) 2005 Topspin Communications.  All rights reserved.
> + * Copyright (c) 2005 Cisco Systems.  All rights reserved.
> + * Copyright (c) 2005 Open Grid Computing, Inc. All rights reserved.
> + *
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU
> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * OpenIB.org BSD license below:
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the following
> + *     conditions are met:
> + *
> + *      - Redistributions of source code must retain the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer.
> + *
> + *      - Redistributions in binary form must reproduce the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer in the documentation and/or other materials
> + *        provided with the distribution.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + *
> + */
> +
> +#ifndef IRDMA_ABI_H
> +#define IRDMA_ABI_H
> +
> +#include <linux/types.h>
> +
> +#define IRDMA_ABI_VER	6

Starting with high numbers?

> +enum irdma_memreg_type {
> +	IW_MEMREG_TYPE_MEM  = 0,
> +	IW_MEMREG_TYPE_QP   = 1,
> +	IW_MEMREG_TYPE_CQ   = 2,
> +	IW_MEMREG_TYPE_RSVD = 3,
> +	IW_MEMREG_TYPE_MW   = 4,
> +};
> +
> +struct irdma_alloc_ucontext_req {
> +	__u32 rsvd32;
> +	__u8 userspace_ver;
> +	__u8 rsvd8[3];
> +};
> +
> +struct irdma_alloc_ucontext_resp {
> +	__u8 kernel_ver;
> +	__u8 rsvd[7];
> +	struct irdma_hw_attrs hw_attrs;

This won't even compile like this - don't forget you have to send the
rdma-core PR along with the kernel patches. You should already be
running the travis checks yourself. rdma-core should detect malformed
user space headers..

> +struct irdma_mem_reg_req {
> +	__u16 reg_type;	 /* Memory, QP or CQ */
> +	__u16 cq_pages;
> +	__u16 rq_pages;
> +	__u16 sq_pages;
> +};

New structs should be aligned to 8 bytes.

> +struct i40iw_create_qp_resp {
> +	__u32 qp_id;
> +	__u32 actual_sq_size;
> +	__u32 actual_rq_size;
> +	__u32 i40iw_drv_opt;
> +	__u16 push_idx;
> +	__u8  lsmm;
> +	__u8  rsvd2;
> +};

ditto

> +struct irdma_create_ah_resp {
> +	__u32 ah_id;
> +	__u32 rsvd[4];

typo? __u8?

Jason
