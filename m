From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH v3 03/13] Attach/detach SoftiWarp to/from network and RDMA subsystem
Date: Tue, 23 Jan 2018 10:33:48 -0600
Message-ID: <00ff01d39467$f1f31b60$d5d95220$@opengridcomputing.com>
References: <20180114223603.19961-1-bmt@zurich.ibm.com> <20180114223603.19961-4-bmt@zurich.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180114223603.19961-4-bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Bernard Metzler' <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Subject: [PATCH v3 03/13] Attach/detach SoftiWarp to/from network and RDMA
> subsystem
> 
> Signed-off-by: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
> ---
>  drivers/infiniband/sw/siw/siw_main.c | 816
> +++++++++++++++++++++++++++++++++++
>  1 file changed, 816 insertions(+)
>  create mode 100644 drivers/infiniband/sw/siw/siw_main.c
> 
> diff --git a/drivers/infiniband/sw/siw/siw_main.c
> b/drivers/infiniband/sw/siw/siw_main.c
> new file mode 100644
> index 000000000000..1b7fc58d4eb9
> --- /dev/null
> +++ b/drivers/infiniband/sw/siw/siw_main.c
> @@ -0,0 +1,816 @@
> +/*
> + * Software iWARP device driver
> + *
> + * Authors: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
> + *
> + * Copyright (c) 2008-2017, IBM Corporation
> + *
> + * This software is available to you under a choice of one of two
> + * licenses. You may choose to be licensed under the terms of the GNU
> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * BSD license below:
> + *
> + *   Redistribution and use in source and binary forms, with or
> + *   without modification, are permitted provided that the following
> + *   conditions are met:
> + *
> + *   - Redistributions of source code must retain the above copyright
notice,
> + *     this list of conditions and the following disclaimer.
> + *
> + *   - Redistributions in binary form must reproduce the above copyright
> + *     notice, this list of conditions and the following disclaimer in
the
> + *     documentation and/or other materials provided with the
distribution.
> + *
> + *   - Neither the name of IBM nor the names of its contributors may be
> + *     used to endorse or promote products derived from this software
without
> + *     specific prior written permission.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
> OF
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
> HOLDERS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
> IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
> THE
> + * SOFTWARE.
> + */
> +
> +#include <linux/init.h>
> +#include <linux/errno.h>
> +#include <linux/netdevice.h>
> +#include <linux/inetdevice.h>
> +#include <net/net_namespace.h>
> +#include <linux/rtnetlink.h>
> +#include <linux/if_arp.h>
> +#include <linux/list.h>
> +#include <linux/kernel.h>
> +#include <linux/dma-mapping.h>
> +
> +#include <rdma/ib_verbs.h>
> +#include <rdma/ib_smi.h>
> +#include <rdma/ib_user_verbs.h>
> +
> +#include "siw.h"
> +#include "siw_obj.h"
> +#include "siw_cm.h"
> +#include "siw_verbs.h"
> +#include <linux/kthread.h>
> +
> +MODULE_AUTHOR("Bernard Metzler");
> +MODULE_DESCRIPTION("Software iWARP Driver");
> +MODULE_LICENSE("Dual BSD/GPL");
> +MODULE_VERSION("0.2");
> +
> +/* transmit from user buffer, if possible */
> +const bool zcopy_tx;
> +
> +/* Restrict usage of GSO, if hardware peer iwarp is unable to process
> + * large packets. gso_seg_limit = 1 lets siw send only packets up to
> + * one real MTU in size, but severly limits maximum bandwidth.
> + * gso_seg_limit = 0 makes use of GSO (and more than doubles throughput
> + * for large transfers).
> + */
> +const int gso_seg_limit;
> +

The GSO configuration needs to default to enable interoperation with all
vendors (and comply with the RFCs).  So make it 1 please.

Jason, would configfs be a reasonable way to allow tweaking these globals?

> +/* Attach siw also with loopback devices */
> +const bool loopback_enabled = true;
> +

I think I asked this before.  Why have a knob to enable/disable loopback?

> +/* We try to negotiate CRC on, if true */
> +const bool mpa_crc_required;
> +
> +/* MPA CRC on/off enforced */
> +const bool mpa_crc_strict;
> +
> +/* Set TCP_NODELAY, and push messages asap */
> +const bool siw_lowdelay = true;
> +/* Set TCP_QUICKACK */
> +const bool tcp_quickack;
> +
> +/* Select MPA version to be used during connection setup */
> +u_char mpa_version = MPA_REVISION_2;
> +
> +/* Selects MPA P2P mode (additional handshake during connection
> + * setup, if true
> + */
> +const bool peer_to_peer;
> +
> +static LIST_HEAD(siw_devlist);
> +
> +struct task_struct *siw_tx_thread[NR_CPUS];
> +struct crypto_shash *siw_crypto_shash;
> +
> +static ssize_t show_sw_version(struct device *dev,
> +			       struct device_attribute *attr, char *buf)
> +{
> +	struct siw_device *sdev = container_of(dev, struct siw_device,
> +					       base_dev.dev);
> +
> +	return sprintf(buf, "%x\n", sdev->attrs.version);
> +}
> +
> +static DEVICE_ATTR(sw_version, 0444, show_sw_version, NULL);
> +
> +static struct device_attribute *siw_dev_attributes[] = {
> +	&dev_attr_sw_version
> +};
> +
> +static int siw_modify_port(struct ib_device *base_dev, u8 port, int mask,
> +			   struct ib_port_modify *props)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
> +static int siw_device_register(struct siw_device *sdev)
> +{
> +	struct ib_device *base_dev = &sdev->base_dev;
> +	int rv, i;
> +	static int dev_id = 1;
> +
> +	rv = ib_register_device(base_dev, NULL);
> +	if (rv) {
> +		pr_warn("siw: %s: registration error %d\n",
> +			base_dev->name, rv);
> +		return rv;
> +	}
> +
> +	for (i = 0; i < ARRAY_SIZE(siw_dev_attributes); ++i) {
> +		rv = device_create_file(&base_dev->dev,
siw_dev_attributes[i]);
> +		if (rv) {
> +			pr_warn("siw: %s: create file error: rv=%d\n",
> +				base_dev->name, rv);
> +			ib_unregister_device(base_dev);
> +			return rv;
> +		}
> +	}
> +	siw_debugfs_add_device(sdev);
> +
> +	sdev->attrs.vendor_part_id = dev_id++;
> +
> +	siw_dbg(sdev, "HWaddr=%02x.%02x.%02x.%02x.%02x.%02x\n",
> +		*(u8 *)sdev->netdev->dev_addr,
> +		*((u8 *)sdev->netdev->dev_addr + 1),
> +		*((u8 *)sdev->netdev->dev_addr + 2),
> +		*((u8 *)sdev->netdev->dev_addr + 3),
> +		*((u8 *)sdev->netdev->dev_addr + 4),
> +		*((u8 *)sdev->netdev->dev_addr + 5));
> +
> +	sdev->is_registered = 1;
> +
> +	return 0;
> +}
> +
> +static void siw_device_deregister(struct siw_device *sdev)
> +{
> +	int i;
> +
> +	siw_debugfs_del_device(sdev);
> +
> +	if (sdev->is_registered) {
> +
> +		siw_dbg(sdev, "deregister\n");
> +
> +		for (i = 0; i < ARRAY_SIZE(siw_dev_attributes); ++i)
> +			device_remove_file(&sdev->base_dev.dev,
> +					   siw_dev_attributes[i]);
> +
> +		ib_unregister_device(&sdev->base_dev);
> +	}
> +	if (atomic_read(&sdev->num_ctx) || atomic_read(&sdev->num_srq) ||
> +	    atomic_read(&sdev->num_mr) || atomic_read(&sdev->num_cep) ||
> +	    atomic_read(&sdev->num_qp) || atomic_read(&sdev->num_cq) ||
> +	    atomic_read(&sdev->num_pd)) {
> +		pr_warn("siw at %s: orphaned resources!\n",
> +			sdev->netdev->name);
> +		pr_warn("           CTX %d, SRQ %d, QP %d, CQ %d, MEM %d,
CEP
> %d, PD %d\n",
> +			atomic_read(&sdev->num_ctx),
> +			atomic_read(&sdev->num_srq),
> +			atomic_read(&sdev->num_qp),
> +			atomic_read(&sdev->num_cq),
> +			atomic_read(&sdev->num_mr),
> +			atomic_read(&sdev->num_cep),
> +			atomic_read(&sdev->num_pd));
> +	}
> +
> +	while (!list_empty(&sdev->cep_list)) {
> +		struct siw_cep *cep = list_entry(sdev->cep_list.next,
> +						 struct siw_cep, devq);
> +		list_del(&cep->devq);
> +		pr_warn("siw: at %s: free orphaned CEP 0x%p, state %d\n",
> +			sdev->base_dev.name, cep, cep->state);
> +		kfree(cep);
> +	}
> +	sdev->is_registered = 0;
> +}
> +
> +static void siw_device_destroy(struct siw_device *sdev)
> +{
> +	siw_dbg(sdev, "destroy device\n");
> +	siw_idr_release(sdev);
> +
> +	kfree(sdev->base_dev.iwcm);
> +	dev_put(sdev->netdev);
> +
> +	ib_dealloc_device(&sdev->base_dev);
> +}
> +
> +static struct siw_device *siw_dev_from_netdev(struct net_device *dev)
> +{
> +	if (!list_empty(&siw_devlist)) {
> +		struct list_head *pos;
> +
> +		list_for_each(pos, &siw_devlist) {
> +			struct siw_device *sdev =
> +				list_entry(pos, struct siw_device, list);
> +			if (sdev->netdev == dev)
> +				return sdev;
> +		}
> +	}
> +	return NULL;
> +}
> +
> +static int siw_create_tx_threads(void)
> +{
> +	int cpu, rv, assigned = 0;
> +
> +	for_each_online_cpu(cpu) {
> +		/* Skip HT cores */
> +		if (cpu % cpumask_weight(topology_sibling_cpumask(cpu))) {
> +			siw_tx_thread[cpu] = NULL;
> +			continue;
> +		}
> +		siw_tx_thread[cpu] = kthread_create(siw_run_sq,
> +						   (unsigned long
*)(long)cpu,
> +						   "siw_tx/%d", cpu);
> +		if (IS_ERR(siw_tx_thread[cpu])) {
> +			rv = PTR_ERR(siw_tx_thread[cpu]);
> +			siw_tx_thread[cpu] = NULL;
> +			pr_info("Creating TX thread for CPU %d failed",
cpu);
> +			continue;
> +		}
> +		kthread_bind(siw_tx_thread[cpu], cpu);
> +
> +		wake_up_process(siw_tx_thread[cpu]);
> +		assigned++;
> +	}
> +	return assigned;
> +}
> +

I know in v2 review, you discussed the TX threads.  And you mentioned you
had tried workq threads [1], but the introduced lots of delay.  Have you
re-looked at the workq implementation?  If your analysis is several years
old, workq threads might provide what you need nowadays...

[1] https://www.spinics.net/lists/linux-rdma/msg55646.html

 
Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
