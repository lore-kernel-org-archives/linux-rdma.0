From: Gal Pressman <galpress@amazon.com>
Subject: Re: [RFC v1 04/19] RDMA/irdma: Add driver framework definitions
Date: Sun, 24 Feb 2019 17:02:10 +0200
Message-ID: <5215c158-2935-ef45-db49-44caa84e07d3@amazon.com>
References: <20190215171107.6464-1-shiraz.saleem@intel.com>
 <20190215171107.6464-5-shiraz.saleem@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190215171107.6464-5-shiraz.saleem@intel.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Shiraz Saleem <shiraz.saleem@intel.com>, dledford@redhat.com, jgg@ziepe.ca, davem@davemloft.net
Cc: linux-rdma@vger.kernel.org, netdev@vger.kernel.org, mustafa.ismail@intel.com, jeffrey.t.kirsher@intel.com
List-Id: linux-rdma@vger.kernel.org

On 15-Feb-19 19:10, Shiraz Saleem wrote:
> +/* client interface functions */
> +static const struct i40e_client_ops i40e_ops = {
> +	.open = i40iw_open,
> +	.close = i40iw_close,
> +	.l2_param_change = i40iw_l2param_change,
> +	.virtchnl_receive = NULL,
> +	.vf_reset = NULL,
> +	.vf_enable = NULL,
> +	.vf_capable = NULL

NULL assignments are redundant.

> +};
> +
> diff --git a/drivers/infiniband/hw/irdma/irdma_if.c b/drivers/infiniband/hw/irdma/irdma_if.c
> new file mode 100644
> index 0000000..f7b89e9
> --- /dev/null
> +++ b/drivers/infiniband/hw/irdma/irdma_if.c
> @@ -0,0 +1,430 @@
> +// SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB
> +/* Copyright (c) 2019, Intel Corporation. */
> +
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>
> +#include <ice_idc.h>
> +#include "main.h"
> +#include "ws.h"
> +#include "icrdma_hw.h"
> +
> +void irdma_add_dev_ref(struct irdma_sc_dev *dev)
> +{
> +	try_module_get(THIS_MODULE);
> +}
> +
> +void irdma_put_dev_ref(struct irdma_sc_dev *dev)
> +{
> +	module_put(THIS_MODULE);
> +}

What are these used for?

> +
> +/**
> + * irdma_find_iwdev - find a vsi device given a name
> + * @name: name of iwdev
> + */

Can't find uses of this function as well.

> +struct irdma_device *irdma_find_iwdev(const char *name)
> +{
> +	struct irdma_handler *hdl;
> +	struct list_head *pos;
> +	struct list_head *tmp;
> +	struct irdma_device *iwdev;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&irdma_handler_lock, flags);
> +	list_for_each_entry(hdl, &irdma_handlers, list) {
> +		list_for_each_safe(pos, tmp, &hdl->rf.vsi_dev_list) {
> +			iwdev = container_of(pos, struct irdma_device, list);
> +			if (!strcmp(name, iwdev->iwibdev->ibdev.name)) {
> +				spin_unlock_irqrestore(&irdma_handler_lock,
> +						       flags);
> +				return iwdev;
> +			}
> +		}
> +	}
> +	spin_unlock_irqrestore(&irdma_handler_lock, flags);
> +
> +	return NULL;
> +}
> +
