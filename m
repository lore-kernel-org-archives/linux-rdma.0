From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-next 4/9] IB/mlx5: Introduce flow steering matcher
 object
Date: Tue, 10 Jul 2018 11:34:50 -0600
Message-ID: <20180710173450.GB8266@ziepe.ca>
References: <20180708102445.25496-1-leon@kernel.org>
 <20180708102445.25496-5-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180708102445.25496-5-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jul 08, 2018 at 01:24:40PM +0300, Leon Romanovsky wrote:
> From: Yishai Hadas <yishaih@mellanox.com>
> 
> Introduce flow steering matcher object and its create and destroy
> methods.
> 
> This matcher object holds some mlx5 specific driver properties that
> matches the underlay device specification when an mlx5 flow steering
> group is created.
> 
> It will be used in downstream patches to be part of mlx5 specific create
> flow method.
> 
> Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
>  drivers/infiniband/hw/mlx5/Makefile      |   1 +
>  drivers/infiniband/hw/mlx5/flow.c        | 132 +++++++++++++++++++++++++++++++
>  drivers/infiniband/hw/mlx5/mlx5_ib.h     |  11 +++
>  include/uapi/rdma/mlx5_user_ioctl_cmds.h |  33 +++++++-
>  4 files changed, 176 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/infiniband/hw/mlx5/flow.c
> 
> diff --git a/drivers/infiniband/hw/mlx5/Makefile b/drivers/infiniband/hw/mlx5/Makefile
> index 577e4c418bae..b8e4b15e2674 100644
> +++ b/drivers/infiniband/hw/mlx5/Makefile
> @@ -4,3 +4,4 @@ mlx5_ib-y :=	main.o cq.o doorbell.o qp.o mem.o srq.o mr.o ah.o mad.o gsi.o ib_vi
>  mlx5_ib-$(CONFIG_INFINIBAND_ON_DEMAND_PAGING) += odp.o
>  mlx5_ib-$(CONFIG_MLX5_ESWITCH) += ib_rep.o
>  mlx5_ib-$(CONFIG_INFINIBAND_USER_ACCESS) += devx.o
> +mlx5_ib-$(CONFIG_INFINIBAND_USER_ACCESS) += flow.o
> diff --git a/drivers/infiniband/hw/mlx5/flow.c b/drivers/infiniband/hw/mlx5/flow.c
> new file mode 100644
> index 000000000000..99409e516c7f
> +++ b/drivers/infiniband/hw/mlx5/flow.c
> @@ -0,0 +1,132 @@
> +// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
> +/*
> + * Copyright (c) 2018, Mellanox Technologies inc.  All rights reserved.
> + */
> +
> +#include <rdma/ib_user_verbs.h>
> +#include <rdma/ib_verbs.h>
> +#include <rdma/uverbs_types.h>
> +#include <rdma/uverbs_ioctl.h>
> +#include <rdma/mlx5_user_ioctl_cmds.h>
> +#include <rdma/ib_umem.h>
> +#include <linux/mlx5/driver.h>
> +#include <linux/mlx5/fs.h>
> +#include "mlx5_ib.h"
> +
> +#define UVERBS_MODULE_NAME mlx5_ib
> +#include <rdma/uverbs_named_ioctl.h>
> +
> +static const struct uverbs_attr_spec mlx5_ib_flow_type[] = {
> +	[MLX5_IB_FLOW_TYPE_NORMAL] = {
> +		.type = UVERBS_ATTR_TYPE_PTR_IN,
> +		UVERBS_ATTR_TYPE(u16),
> +	},
> +	[MLX5_IB_FLOW_TYPE_SNIFFER] = {
> +		/* No need to specify any data */
> +		.type = UVERBS_ATTR_TYPE_PTR_IN,

I think this deserves a macro rather than a repeated
comment.. Especially since we now have have a different version in
uverbs_flow_action_esp_replay:

                .type = UVERBS_ATTR_TYPE_PTR_IN,
                /* No need to specify any data */
                UVERBS_ATTR_SIZE(0, 0),

Something simple like:

#define UVERBS_ATTR_NO_DATA() UVERBS_ATTR_SIZE(0, 0)

> +static int flow_matcher_cleanup(struct ib_uobject *uobject,
> +				enum rdma_remove_reason why)
> +{
> +	struct mlx5_ib_flow_matcher *obj = uobject->object;
> +	int ret = atomic_read(&obj->usecnt) ? -EBUSY : 0;
> +
> +	if (ib_is_destroy_retryable(ret, why, uobject))
> +		return ret;

This is ib_destroy_usecnt() now

> +static int UVERBS_HANDLER(MLX5_IB_METHOD_FLOW_MATCHER_CREATE)(struct ib_device *ib_dev,
> +				   struct ib_uverbs_file *file,
> +				   struct uverbs_attr_bundle *attrs)
> +{
> +	struct mlx5_ib_dev *dev = to_mdev(ib_dev);

I have a patch changing these - when working with uobj's the ib_dev
argument should not be used, the ib_dev must come from the ucontext
instead.

> +	void *cmd_in = uverbs_attr_get_alloced_ptr(attrs,
> +						   MLX5_IB_ATTR_FLOW_MATCHER_MATCH_MASK);
> +	struct ib_uobject *uobj;
> +	struct mlx5_ib_flow_matcher *obj;
> +	int mask_len;
> +	int err;

So this is to be written as
	struct ib_uobject *uobj = uverbs_attr_get_uobject(attrs,
                         MLX5_IB_ATTR_FLOW_MATCHER_CREATE_HANDLE);
	struct mlx5_ib_dev *dev = to_mdev(uobj->context->device);

> +
> +	obj = kzalloc(sizeof(struct mlx5_ib_flow_matcher), GFP_KERNEL);
> +	if (!obj)
> +		return -ENOMEM;
> +
> +	obj->mask_len = uverbs_attr_get_len(attrs,
> +					    MLX5_IB_ATTR_FLOW_MATCHER_MATCH_MASK);
> +	memcpy(obj->matcher_mask.match_params, cmd_in, obj->mask_len);

As noted before, memcpying an alloced_ptr doesn't make sense, use the
copy from user version instead.

Jason
