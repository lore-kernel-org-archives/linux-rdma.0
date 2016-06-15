From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH rdma-next 11/29] IB/rxe: Allocation pool for RDMA objects
Date: Wed, 15 Jun 2016 11:17:06 -0500
Message-ID: <011101d1c721$5c22d590$146880b0$@opengridcomputing.com>
References: <1464886657-14258-1-git-send-email-monis@mellanox.com> <1464886657-14258-12-git-send-email-monis@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1464886657-14258-12-git-send-email-monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leon-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, 'Kamal Heib' <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Amir Vadai' <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


 
> Manage and allocate pool of objects with given limit on number of
> elements.  Gets parameters from rxe_type_info. Pool elements are
> allocated out of a slab cache.  Objects that are using this facility
> are: PD, QP, SRQ, CQ, MR, FMR, MW, etc.
> 
> Signed-off-by: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/hw/rxe/rxe_pool.c | 510
> +++++++++++++++++++++++++++++++++++
>  drivers/infiniband/hw/rxe/rxe_pool.h | 164 +++++++++++
>  2 files changed, 674 insertions(+)
>  create mode 100644 drivers/infiniband/hw/rxe/rxe_pool.c
>  create mode 100644 drivers/infiniband/hw/rxe/rxe_pool.h
> 
> diff --git a/drivers/infiniband/hw/rxe/rxe_pool.c
> b/drivers/infiniband/hw/rxe/rxe_pool.c
> new file mode 100644
> index 0000000..5a7da6b
> --- /dev/null
> +++ b/drivers/infiniband/hw/rxe/rxe_pool.c
> @@ -0,0 +1,510 @@
> +/*
> + * Copyright (c) 2016 Mellanox Technologies Ltd. All rights reserved.
> + * Copyright (c) 2015 System Fabric Works, Inc. All rights reserved.
> + *
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU
> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * OpenIB.org BSD license below:
> + *
> + *	   Redistribution and use in source and binary forms, with or
> + *	   without modification, are permitted provided that the following
> + *	   conditions are met:
> + *
> + *		- Redistributions of source code must retain the above
> + *		  copyright notice, this list of conditions and the following
> + *		  disclaimer.
> + *
> + *		- Redistributions in binary form must reproduce the above
> + *		  copyright notice, this list of conditions and the following
> + *		  disclaimer in the documentation and/or other materials
> + *		  provided with the distribution.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
> HOLDERS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + */
> +
> +#include "rxe.h"
> +#include "rxe_loc.h"
> +
> +/* info about object pools
> + * note that mr, fmr and mw share a single index space
> + * so that one can map an lkey to the correct type of object
> + */
> +struct rxe_type_info rxe_type_info[RXE_NUM_TYPES] = {
> +	[RXE_TYPE_UC] = {
> +		.name		= "uc",
> +		.size		= sizeof(struct rxe_ucontext),
> +	},
> +	[RXE_TYPE_PD] = {
> +		.name		= "pd",
> +		.size		= sizeof(struct rxe_pd),
> +	},
> +	[RXE_TYPE_AH] = {
> +		.name		= "ah",
> +		.size		= sizeof(struct rxe_ah),
> +		.flags		= RXE_POOL_ATOMIC,
> +	},
> +	[RXE_TYPE_SRQ] = {
> +		.name		= "srq",
> +		.size		= sizeof(struct rxe_srq),
> +		.flags		= RXE_POOL_INDEX,
> +		.min_index	= RXE_MIN_SRQ_INDEX,
> +		.max_index	= RXE_MAX_SRQ_INDEX,
> +	},
> +	[RXE_TYPE_QP] = {
> +		.name		= "qp",
> +		.size		= sizeof(struct rxe_qp),
> +		.cleanup	= rxe_qp_cleanup,
> +		.flags		= RXE_POOL_INDEX,
> +		.min_index	= RXE_MIN_QP_INDEX,
> +		.max_index	= RXE_MAX_QP_INDEX,
> +	},
> +	[RXE_TYPE_CQ] = {
> +		.name		= "cq",
> +		.size		= sizeof(struct rxe_cq),
> +		.cleanup	= rxe_cq_cleanup,
> +	},
> +	[RXE_TYPE_MR] = {
> +		.name		= "mr",
> +		.size		= sizeof(struct rxe_mem),
> +		.cleanup	= rxe_mem_cleanup,
> +		.flags		= RXE_POOL_INDEX,
> +		.max_index	= RXE_MAX_MR_INDEX,
> +		.min_index	= RXE_MIN_MR_INDEX,
> +	},
> +	[RXE_TYPE_FMR] = {
> +		.name		= "fmr",
> +		.size		= sizeof(struct rxe_mem),
> +		.cleanup	= rxe_mem_cleanup,
> +		.flags		= RXE_POOL_INDEX,
> +		.max_index	= RXE_MAX_FMR_INDEX,
> +		.min_index	= RXE_MIN_FMR_INDEX,
> +	},
> +	[RXE_TYPE_MW] = {
> +		.name		= "mw",
> +		.size		= sizeof(struct rxe_mem),
> +		.flags		= RXE_POOL_INDEX,
> +		.max_index	= RXE_MAX_MW_INDEX,
> +		.min_index	= RXE_MIN_MW_INDEX,
> +	},
> +	[RXE_TYPE_MC_GRP] = {
> +		.name		= "mc_grp",
> +		.size		= sizeof(struct rxe_mc_grp),
> +		.cleanup	= rxe_mc_cleanup,
> +		.flags		= RXE_POOL_KEY,
> +		.key_offset	= offsetof(struct rxe_mc_grp, mgid),
> +		.key_size	= sizeof(union ib_gid),
> +	},
> +	[RXE_TYPE_MC_ELEM] = {
> +		.name		= "mc_elem",
> +		.size		= sizeof(struct rxe_mc_elem),
> +		.flags		= RXE_POOL_ATOMIC,
> +	},
> +};
> +

Perhaps the above slab names should be prefixed with "rxe-"?  EG: "rxe-cq",
"rxe-qp", etc.  They look very non-descriptive when looking at them in slabinfo:

[root@stevo2 linux-2.6]# head /proc/slabinfo
slabinfo - version: 2.1
# name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab>
: tunables <limit> <batchcount> <sharedfactor> : slabdata <active_slabs>
<num_slabs> <sharedavail>
uc                     0      0    352   11    1 : tunables   54   27    8 :
slabdata      0      0      0
cq                     6     34    240   17    1 : tunables  120   60    8 :
slabdata      2      2      0
qp                     4      6   1920    2    1 : tunables   24   12    8 :
slabdata      3      3      0
pd                     4     36    112   36    1 : tunables  120   60    8 :
slabdata      1      1      0


Also when using rxe with nvmf (among other bugs I'm chasing down), when you
unload ib_rxe, there are allocated cq objects left in the the slab cache:

kmem_cache_destroy cq: Slab cache still has objects
CPU: 5 PID: 4147 Comm: rmmod Tainted: G            E   4.7.0-rc2-nvmf-all.3+rxe+
#51
Hardware name: Supermicro X9DR3-F/X9DR3-F, BIOS 3.2a 07/09/2015
 0000000000000000 ffff881007b33d98 ffffffff812d1359 ffff88103bd65098
 ffffea00378983d0 ffff881007b33da8 ffff881078b32240 ffff881007b33df8
 ffffffff8117619c ffff881007b33da8 ffff881007b33da8 ffff88103bec6960
Call Trace:
 [<ffffffff812d1359>] dump_stack+0x51/0x78
 [<ffffffff8117619c>] kmem_cache_destroy+0x12c/0x150
 [<ffffffffa04c62cc>] rxe_cache_exit+0x1c/0x40 [ib_rxe]
 [<ffffffffa04ce4cf>] rxe_module_exit+0x13/0x23 [ib_rxe]
 [<ffffffff810e1d15>] SyS_delete_module+0x185/0x1d0
 [<ffffffff8100278e>] ? syscall_trace_enter_phase2+0x6e/0x190
 [<ffffffff81002915>] ? syscall_trace_enter+0x65/0x70
 [<ffffffff81002d4d>] do_syscall_64+0x6d/0x160
 [<ffffffff8161857c>] entry_SYSCALL64_slow_path+0x25/0x25
rxe: unloaded

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
