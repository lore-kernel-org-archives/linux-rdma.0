From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [RFC v1 15/19] RDMA/irdma: Add miscellaneous utility definitions
Date: Fri, 15 Feb 2019 10:47:14 -0700
Message-ID: <20190215174714.GE30706@ziepe.ca>
References: <20190215171107.6464-1-shiraz.saleem@intel.com>
 <20190215171107.6464-16-shiraz.saleem@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190215171107.6464-16-shiraz.saleem@intel.com>
Sender: netdev-owner@vger.kernel.org
To: Shiraz Saleem <shiraz.saleem@intel.com>
Cc: dledford@redhat.com, davem@davemloft.net, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, mustafa.ismail@intel.com, jeffrey.t.kirsher@intel.com
List-Id: linux-rdma@vger.kernel.org

On Fri, Feb 15, 2019 at 11:11:02AM -0600, Shiraz Saleem wrote:
> From: Mustafa Ismail <mustafa.ismail@intel.com>
> 
> Add miscellaneous utility functions and headers.
> 
> Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
>  drivers/infiniband/hw/irdma/osdep.h  |  153 ++
>  drivers/infiniband/hw/irdma/protos.h |  118 ++
>  drivers/infiniband/hw/irdma/status.h |   70 +
>  drivers/infiniband/hw/irdma/utils.c  | 2565 ++++++++++++++++++++++++++++++++++
>  4 files changed, 2906 insertions(+)
>  create mode 100644 drivers/infiniband/hw/irdma/osdep.h
>  create mode 100644 drivers/infiniband/hw/irdma/protos.h
>  create mode 100644 drivers/infiniband/hw/irdma/status.h
>  create mode 100644 drivers/infiniband/hw/irdma/utils.c
> 
> diff --git a/drivers/infiniband/hw/irdma/osdep.h b/drivers/infiniband/hw/irdma/osdep.h
> new file mode 100644
> index 0000000..ade5536
> +++ b/drivers/infiniband/hw/irdma/osdep.h
> @@ -0,0 +1,153 @@
> +/* SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB */
> +/* Copyright (c) 2019, Intel Corporation. */
> +
> +#ifndef IRDMA_OSDEP_H
> +#define IRDMA_OSDEP_H
> +
> +#include <linux/version.h>
> +#include <linux/kernel.h>
> +#include <linux/vmalloc.h>
> +#include <linux/string.h>
> +#include <linux/bitops.h>
> +#include <linux/pci.h>
> +#include <net/tcp.h>
> +#include <crypto/hash.h>
> +/* get readq/writeq support for 32 bit kernels, use the low-first version */
> +#include <linux/io-64-nonatomic-lo-hi.h>
> +
> +#define STATS_TIMER_DELAY	60000
> +#define MAKEMASK(m, s)		((m) << (s))
> +
> +#define irdma_pr_err(fmt, args ...)				\
> +	pr_err("%s: "fmt, __func__, ## args)
> +
> +#define irdma_pr_info(fmt, args ...)				\
> +	pr_info("%s: " fmt, __func__, ## args)
> +
> +#define irdma_pr_warn(fmt, args ...)				\
> +	pr_warn("%s: " fmt, __func__, ## args)
> +
> +#define irdma_dev_err(dev, fmt, args ...)			\
> +	dev_err(to_device(dev), "%s: "fmt, __func__, ## args)
> +
> +#define irdma_dev_info(dev, fmt, args ...)			\
> +	dev_info(to_device(dev), "%s: "fmt, __func__, ## args)
> +
> +#define irdma_dev_warn(dev, fmt, args ...)			\
> +	dev_warn(to_device(dev), "%s: "fmt, __func__, ## args)

Does every driver really have to define these macros?

> +#define to_device(ptr)						\
> +	(&((struct pci_dev *)((ptr)->hw->dev_context))->dev)

?? Seems like this wants to be container_of??

> +/**
> + * irdma_insert_wqe_hdr - write wqe header
> + * @wqe: cqp wqe for header
> + * @header: header for the cqp wqe
> + */
> +static inline void irdma_insert_wqe_hdr(__le64 *wqe, u64 hdr)
> +{
> +	wmb();   /* make sure WQE is populated before polarity is set */
> +	set_64bit_val(wqe, 24, hdr);

Generally don't like seeing wmbs in drivers.. Are you sure this isn't
supposed to be smp_store_release(), or dma_wmb() perhaps?

> +/**
> + * irdma_inetaddr_event - system notifier for ipv4 addr events
> + * @notfier: not used
> + * @event: event for notifier
> + * @ptr: if address
> + */
> +int irdma_inetaddr_event(struct notifier_block *notifier,
> +			 unsigned long event,
> +			 void *ptr)
> +{
> +	struct in_ifaddr *ifa = ptr;
> +	struct net_device *event_netdev = ifa->ifa_dev->dev;
> +	struct net_device *netdev;
> +	struct net_device *upper_dev;
> +	struct irdma_device *iwdev;
> +	u32 local_ipaddr;
> +
> +	iwdev = irdma_find_netdev(event_netdev);

This is all being changed too (and is probably wrongly locked here)

A new driver must not maintain their own list of devices. 

> +	if (iwdev->init_state < IP_ADDR_REGISTERED || iwdev->closing)
> +		return NOTIFY_DONE;
> +
> +	netdev = iwdev->netdev;
> +	upper_dev = netdev_master_upper_dev_get(netdev);
> +	if (netdev != event_netdev)
> +		return NOTIFY_DONE;

What is all this? Does the driver support bonding?

You have to fix this to work in the new style - and you might need to
add more core code to sanely support bonding.

Look here:
https://patchwork.kernel.org/project/linux-rdma/list/?series=79299

> +/**
> + * irdma_add_devusecount - add dev refcount
> + * @iwdev: dev for refcount
> + */
> +void irdma_add_devusecount(struct irdma_device *iwdev)
> +{
> +	atomic64_inc(&iwdev->use_count);
> +}
> +
> +/**
> + * irdma_rem_devusecount - decrement refcount for dev
> + * @iwdev: device
> + */
> +void irdma_rem_devusecount(struct irdma_device *iwdev)
> +{
> +	if (!atomic64_dec_and_test(&iwdev->use_count))
> +		return;
> +	wake_up(&iwdev->close_wq);
> +}
> +
> +/**
> + * irdma_add_pdusecount - add pd refcount
> + * @iwpd: pd for refcount
> + */
> +void irdma_add_pdusecount(struct irdma_pd *iwpd)
> +{
> +	atomic_inc(&iwpd->usecount);
> +}

Why do we have these wrappers? Don't like wrappers liket his.

Are you sure this should be an atomic, not a kref, refcount, etc? 

Very concerning to refcounting of HW object structures like
this.. Most often when I see this in IB drivers it comes along with
concurrency bugs in the destroy path.

> +/**
> + * irdma_allocate_dma_mem - Memory alloc helper fn
> + * @hw:   pointer to the HW structure
> + * @mem:  ptr to mem struct to fill out
> + * @size: size of memory requested
> + * @alignment: what to align the allocation to
> + */
> +enum irdma_status_code irdma_allocate_dma_mem(struct irdma_hw *hw,
> +					      struct irdma_dma_mem *mem,
> +					      u64 size,
> +					      u32 alignment)
> +{
> +	struct pci_dev *pcidev = (struct pci_dev *)hw->dev_context;
> +
> +	if (!mem)
> +		return IRDMA_ERR_PARAM;
> +
> +	mem->size = ALIGN(size, alignment);
> +	mem->va = dma_alloc_coherent(&pcidev->dev, mem->size,
> +				     (dma_addr_t *)&mem->pa, GFP_KERNEL);
> +	if (!mem->va)
> +		return IRDMA_ERR_NO_MEMORY;
> +
> +	return 0;
> +}

More wrappers? Why?

Jason
