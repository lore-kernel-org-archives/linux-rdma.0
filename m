Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D27694A99C4;
	Tue, 13 Oct 2026 06:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791872258; cv=none; b=niJkB/bnijfBLuyO55zStFFl3Q+ZC/IahQMZNki2Gi/obO/Pjyn0YIUHTmuww16ujL3y2GZqkRXf2rXdQvVY88ENZtajdFoCpUhapfG8jnI9A87IxDnjxgcmYEyd4UNKYZrYmu5uwFnbANq2U9lZl63hBT/qOxwfFP+3BaYrLLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791872258; c=relaxed/simple;
	bh=I8cLqMGuUKZCOKstXGA+eObh/2b9ETMjBg0YyW8CYVs=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=HGLy1uVsK4BMpH7DYQ4SxRaF4vSFsK7n6BhcEAqvtIVMqw1UwQwVyxAB9WBRzIFOpNcKcykAGEhn4xk/yi7p1c+wrRdzDgTUtWLt/hjkerwEny+DK6sXhviJFnPDqWTij5rgQe+PhasNiHhMArPUfrqsaJUq56IIn9a5ANLstEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=113.46.200.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4j3kMX0YrWzRhXM;
	Tue, 13 Oct 2026 14:05:12 +0800 (CST)
Received: from kwepemf100018.china.huawei.com (unknown [7.202.181.17])
	by mail.maildlp.com (Postfix) with ESMTPS id C5BF040538;
	Tue, 13 Oct 2026 14:17:25 +0800 (CST)
Received: from [10.67.120.168] (10.67.120.168) by
 kwepemf100018.china.huawei.com (7.202.181.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 13 Oct 2026 14:17:24 +0800
Message-ID: <3cb7230e-079d-8d3b-5605-16149d2af01d@hisilicon.com>
Date: Tue, 13 Oct 2026 14:17:24 +0800
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 09/15] yunsilicon: add RDMA device support
Content-Language: en-US
To: Xin Tian <tianx@yunsilicon.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Jason
 Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
CC: <weihg@yunsilicon.com>, <linux-kernel@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>
References: <20261012114352.2471317-1-tianx@yunsilicon.com>
 <20261012114412.2471317-10-tianx@yunsilicon.com>
From: Junxian Huang <huangjunxian6@hisilicon.com>
In-Reply-To: <20261012114412.2471317-10-tianx@yunsilicon.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemf100018.china.huawei.com (7.202.181.17)



On 2026/10/12 19:44, Xin Tian wrote:
> Add the RDMA driver's uverbs ABI header (include/uapi/rdma/xsc-abi.h),
> the ib_device scaffolding and device registration: query_device,
> query_port, query_pkey, ucontext allocation and mmap, port attributes and
> the netdev notifier that tracks the port state.
> 
> The driver reports RDMA_DRIVER_XSC, which is added to the rdma_driver_id
> enum at the end so existing IDs are untouched.
> 
> Signed-off-by: Xin Tian <tianx@yunsilicon.com>
> ---
>  drivers/infiniband/Kconfig                    |   1 +
>  drivers/infiniband/hw/Makefile                |   1 +
>  drivers/infiniband/hw/xsc/Kconfig             |  17 +
>  drivers/infiniband/hw/xsc/Makefile            |   9 +
>  drivers/infiniband/hw/xsc/main.c              | 797 ++++++++++++++++++
>  drivers/infiniband/hw/xsc/xsc_ib.h            | 542 ++++++++++++
>  .../net/ethernet/yunsilicon/xsc/common/cq.h   |  30 +
>  .../ethernet/yunsilicon/xsc/common/driver.h   |  95 +++
>  .../net/ethernet/yunsilicon/xsc/common/qp.h   | 104 +++
>  .../net/ethernet/yunsilicon/xsc/common/srq.h  |  54 ++
>  .../net/ethernet/yunsilicon/xsc/pci/Makefile  |   2 +-
>  .../net/ethernet/yunsilicon/xsc/pci/link.c    |  35 +
>  include/uapi/rdma/ib_user_ioctl_verbs.h       |   1 +
>  include/uapi/rdma/xsc-abi.h                   | 295 +++++++
>  14 files changed, 1982 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/infiniband/hw/xsc/Kconfig
>  create mode 100644 drivers/infiniband/hw/xsc/Makefile
>  create mode 100644 drivers/infiniband/hw/xsc/main.c
>  create mode 100644 drivers/infiniband/hw/xsc/xsc_ib.h
>  create mode 100644 drivers/net/ethernet/yunsilicon/xsc/common/cq.h
>  create mode 100644 drivers/net/ethernet/yunsilicon/xsc/common/driver.h
>  create mode 100644 drivers/net/ethernet/yunsilicon/xsc/common/qp.h
>  create mode 100644 drivers/net/ethernet/yunsilicon/xsc/common/srq.h
>  create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/link.c
>  create mode 100644 include/uapi/rdma/xsc-abi.h
> 
> diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
> index 086195758..b3cc506db 100644
> --- a/drivers/infiniband/Kconfig
> +++ b/drivers/infiniband/Kconfig
> @@ -100,6 +100,7 @@ source "drivers/infiniband/hw/ocrdma/Kconfig"
>  source "drivers/infiniband/hw/qedr/Kconfig"
>  source "drivers/infiniband/hw/usnic/Kconfig"
>  source "drivers/infiniband/hw/vmw_pvrdma/Kconfig"
> +source "drivers/infiniband/hw/xsc/Kconfig"
>  source "drivers/infiniband/sw/rdmavt/Kconfig"
>  endif # !UML
>  source "drivers/infiniband/sw/rxe/Kconfig"
> diff --git a/drivers/infiniband/hw/Makefile b/drivers/infiniband/hw/Makefile
> index c42b22ac3..1bcd2d50a 100644
> --- a/drivers/infiniband/hw/Makefile
> +++ b/drivers/infiniband/hw/Makefile
> @@ -16,3 +16,4 @@ obj-$(CONFIG_INFINIBAND_BNXT_RE)	+= bnxt_re/
>  obj-$(CONFIG_INFINIBAND_BNG_RE)		+= bng_re/
>  obj-$(CONFIG_INFINIBAND_ERDMA)		+= erdma/
>  obj-$(CONFIG_INFINIBAND_IONIC)		+= ionic/
> +obj-$(CONFIG_INFINIBAND_XSC)	+= xsc/
> diff --git a/drivers/infiniband/hw/xsc/Kconfig b/drivers/infiniband/hw/xsc/Kconfig
> new file mode 100644
> index 000000000..5cf46df2d
> --- /dev/null
> +++ b/drivers/infiniband/hw/xsc/Kconfig
> @@ -0,0 +1,17 @@
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2021 - 2026, Shanghai Yunsilicon Technology Co., Ltd.
> +# All rights reserved.
> +
> +config INFINIBAND_XSC
> +	tristate "Yunsilicon XSC RDMA driver"
> +	depends on INFINIBAND && PCI && INET
> +	depends on YUNSILICON_XSC_PCI && YUNSILICON_XSC_ETH
> +	help
> +	  This driver provides RDMA support for Yunsilicon XSC devices.
> +	  It uses the auxiliary device published by the XSC PCI core and,
> +	  for now, the netdev registered by the XSC ethernet driver to
> +	  derive the port state and GID.  Because of that netdev
> +	  dependency it also depends on YUNSILICON_XSC_ETH.
> +
> +	  To compile this driver as a module, choose M here. The module
> +	  will be called xsc_ib.
> diff --git a/drivers/infiniband/hw/xsc/Makefile b/drivers/infiniband/hw/xsc/Makefile
> new file mode 100644
> index 000000000..6c4ec1ca0
> --- /dev/null
> +++ b/drivers/infiniband/hw/xsc/Makefile
> @@ -0,0 +1,9 @@
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2021 - 2026, Shanghai Yunsilicon Technology Co., Ltd.
> +# All rights reserved.
> +
> +ccflags-y := -I$(srctree)/drivers/net/ethernet/yunsilicon/xsc
> +
> +obj-$(CONFIG_INFINIBAND_XSC) += xsc_ib.o
> +
> +xsc_ib-y := main.o
> diff --git a/drivers/infiniband/hw/xsc/main.c b/drivers/infiniband/hw/xsc/main.c
> new file mode 100644
> index 000000000..9d53a89be
> --- /dev/null
> +++ b/drivers/infiniband/hw/xsc/main.c
> @@ -0,0 +1,797 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2021 - 2026, Shanghai Yunsilicon Technology Co., Ltd.
> + * All rights reserved.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/auxiliary_bus.h>
> +#include <linux/init.h>
> +#include <linux/errno.h>
> +#include <linux/pci.h>
> +#include <linux/namei.h>
> +#include <linux/kobject.h>
> +#include <linux/kernfs.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/slab.h>
> +#include <linux/io-mapping.h>
> +#include <linux/sched.h>
> +#include <linux/netdevice.h>
> +#include "common/xsc_core.h"
> +#include "common/xsc_hsi.h"
> +#include "common/xsc_cmd.h"
> +#include "common/driver.h"
> +
> +#include <rdma/ib_user_verbs.h>
> +#include <rdma/ib_smi.h>
> +#include <rdma/ib_umem.h>
> +
> +#include <rdma/xsc-abi.h>
> +#include "xsc_ib.h"
> +
> +#define DRIVER_NAME "xsc_ib"
> +
> +#define XSC_IB_GID_TBL_LEN	256
> +#define XSC_IB_MAX_PKEYS	0x80
> +
> +MODULE_DESCRIPTION("Yunsilicon HCA IB driver");
> +MODULE_LICENSE("GPL");
> +
> +static int xsc_ib_query_device(struct ib_device *ibdev,
> +			       struct ib_device_attr *props,
> +			       struct ib_udata *udata)

Are the comments in this function really needed? I think the codes
are self-explainable enough.

> +{
> +	size_t udata_outlen = (udata) ? udata->outlen : 0;
> +	struct xsc_ib_dev *dev = to_xdev(ibdev);
> +	struct xsc_ib_query_device_resp resp;
> +	union xsc_ib_fw_ver fw_ver;
> +	int err = -ENOMEM;
> +	size_t resp_len;
> +	int max_rq_sg;
> +	u64 max_tso;
> +	u64 flags;
> +
> +	err = ib_is_udata_in_empty(udata);
> +	if (err)
> +		return err;
> +
> +	memset(&resp, 0, sizeof(resp));
> +	memset(props, 0, sizeof(*props));

The core already handles the zeroing, no need to do this in driver.

> +
> +	resp_len = sizeof(resp.comp_mask) + sizeof(resp.response_length);
> +	/*check param*/
> +	if (udata_outlen && udata_outlen < resp_len)
> +		return -EINVAL;
> +
> +	resp.response_length = resp_len;
> +
> +	fw_ver.data = 0;
> +	fw_ver.s.ver_major = dev->xdev->fw_version_major;
> +	fw_ver.s.ver_minor = dev->xdev->fw_version_minor;
> +	fw_ver.s.ver_patch = dev->xdev->fw_version_patch;
> +	fw_ver.s.ver_tweak = dev->xdev->fw_version_tweak;
> +	props->fw_ver = fw_ver.data;
> +
> +	props->device_cap_flags    = IB_DEVICE_CHANGE_PHY_PORT |
> +		IB_DEVICE_PORT_ACTIVE_EVENT		|
> +		IB_DEVICE_SYS_IMAGE_GUID		|
> +		IB_DEVICE_RC_RNR_NAK_GEN;
> +	props->kernel_cap_flags =  IBK_BLOCK_MULTICAST_LOOPBACK;
> +	props->kernel_cap_flags |= IBK_LOCAL_DMA_LKEY;
> +
> +	flags = dev->xdev->caps.flags;
> +	if (flags & XSC_DEV_CAP_FLAG_BAD_PKEY_CNTR)
> +		props->device_cap_flags |= IB_DEVICE_BAD_PKEY_CNTR;
> +	if (flags & XSC_DEV_CAP_FLAG_BAD_QKEY_CNTR)
> +		props->device_cap_flags |= IB_DEVICE_BAD_QKEY_CNTR;
> +	if (flags & XSC_DEV_CAP_FLAG_APM)
> +		props->device_cap_flags |= IB_DEVICE_AUTO_PATH_MIG;
> +	props->page_size_cap	   = dev->xdev->caps.min_page_sz;
> +	props->max_mr_size	   = xsc_get_max_mr_size(dev->xdev);
> +	props->max_qp		   = dev->xdev->caps.max_qp;
> +	props->max_qp_wr	   = xsc_get_max_qp_depth(dev->xdev);
> +	max_rq_sg = dev->xdev->caps.max_rq_desc_sz / sizeof(struct xsc_wqe_data_seg);
> +
> +	props->max_send_sge = dev->xdev->caps.send_ds_num - XSC_CTRL_SEG_NUM -
> +		XSC_RADDR_SEG_NUM;
> +	props->max_recv_sge = dev->xdev->caps.recv_ds_num;
> +	props->max_sge_rd	   = 1;/*max sge per read wqe*/
> +	props->max_cq		   = dev->xdev->caps.max_cq;
> +	props->max_cqe		   = dev->xdev->caps.max_cqes;
> +	props->max_mr		   = (1 << dev->xdev->caps.log_max_mkey) - 1;
> +	props->max_pd		   = dev->xdev->caps.max_pd;
> +	props->max_qp_rd_atom	   = dev->xdev->caps.max_ra_res_qp;
> +	props->max_qp_init_rd_atom = dev->xdev->caps.max_ra_req_qp;
> +	props->max_res_rd_atom	   = props->max_qp_rd_atom * props->max_qp;
> +	props->max_srq		   =
> +		dev->xdev->caps.log_max_srq ? (1 << dev->xdev->caps.log_max_srq) : 0;
> +	props->max_srq_wr	   = dev->xdev->caps.max_srq_wqes - 1;
> +	props->max_srq_sge	   = dev->xdev->caps.log_max_srq ? (max_rq_sg - 1) : 0;
> +	props->local_ca_ack_delay  = dev->xdev->caps.local_ca_ack_delay;
> +	props->atomic_cap	   = is_support_rdma_atomic(dev->xdev) ?
> +		IB_ATOMIC_HCA : IB_ATOMIC_NONE;
> +	props->masked_atomic_cap   = IB_ATOMIC_HCA;
> +	props->max_mcast_grp	   =
> +		dev->xdev->caps.log_max_mcg ? (1 << dev->xdev->caps.log_max_mcg) : 0;
> +	props->max_mcast_qp_attach = dev->xdev->caps.max_qp_mcg;
> +	props->max_total_mcast_qp_attach = props->max_mcast_qp_attach *
> +					   props->max_mcast_grp;
> +
> +	props->sys_image_guid = dev->xdev->board_info->guid;
> +	props->vendor_id = dev->xdev->pdev->vendor;
> +	props->vendor_part_id = dev->xdev->pdev->device;
> +	props->hw_ver = ((dev->xdev->chip_ver_l & 0xffff) << 16) |
> +		(dev->xdev->hotfix_num & 0xffff);
> +	props->max_pkeys = XSC_IB_MAX_PKEYS;
> +	props->max_wq_type_rq = dev->xdev->caps.max_qp;
> +	props->hca_core_clock = dev->xdev->caps.hca_core_clock * 1000; /* KHz */
> +	props->rss_caps.max_rwq_indirection_tables =
> +		dev->xdev->caps.max_rwq_indirection_tables;
> +	props->rss_caps.max_rwq_indirection_table_size =
> +		dev->xdev->caps.max_rwq_indirection_table_size;
> +	props->rss_caps.supported_qpts = 1 << IB_QPT_RAW_PACKET;
> +
> +	/*response tso_caps extend param*/
> +	if (offsetofend(typeof(resp), tso_caps) <= udata_outlen) {
> +		max_tso = dev->xdev->caps.log_max_tso ? (1 << dev->xdev->caps.log_max_tso) : 0;
> +		if (max_tso) {
> +			resp.tso_caps.max_tso = max_tso;
> +			resp.tso_caps.supported_qpts |= 1 << IB_QPT_RAW_PACKET;
> +			resp.response_length += sizeof(resp.tso_caps);
> +		}
> +	}
> +
> +	/*response rss_caps extend param*/
> +	if (offsetofend(typeof(resp), rss_caps) <= udata_outlen) {
> +		resp.rss_caps.rx_hash_function = XSC_RX_HASH_FUNC_TOEPLITZ;
> +		resp.rss_caps.rx_hash_fields_mask =
> +			XSC_RX_HASH_SRC_IPV4 |
> +			XSC_RX_HASH_DST_IPV4 |
> +			XSC_RX_HASH_SRC_IPV6 |
> +			XSC_RX_HASH_DST_IPV6 |
> +			XSC_RX_HASH_SRC_PORT_TCP |
> +			XSC_RX_HASH_DST_PORT_TCP |
> +			XSC_RX_HASH_SRC_PORT_UDP |
> +			XSC_RX_HASH_DST_PORT_UDP |
> +			XSC_RX_HASH_INNER;
> +		resp.response_length += sizeof(resp.rss_caps);
> +	}
> +
> +	/*response packet pacing caps*/
> +	if (offsetofend(typeof(resp), packet_pacing_caps) <= udata_outlen) {
> +		resp.packet_pacing_caps.qp_rate_limit_max =
> +			dev->xdev->caps.qp_rate_limit_max;
> +		resp.packet_pacing_caps.qp_rate_limit_min =
> +			dev->xdev->caps.qp_rate_limit_min;
> +		resp.packet_pacing_caps.supported_qpts |= 1 << IB_QPT_RAW_PACKET;
> +
> +		resp.response_length += sizeof(resp.packet_pacing_caps);
> +	}
> +
> +	/*copy response data to user*/
> +	if (udata_outlen) {
> +		err = ib_copy_to_udata(udata, &resp, resp.response_length);
> +		if (err) {
> +			ibdev_err(&dev->ib_dev, "copy response info to udata fail,err=%d\n", err);
> +			return err;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static void xsc_calc_link_info(struct xsc_core_device *xdev,
> +			       struct ib_port_attr *props)
> +{
> +	switch (xsc_get_link_speed(xdev)) {
> +	case MODULE_SPEED_10G:
> +		props->active_speed = XSC_RDMA_LINK_SPEED_10GB;
> +		props->active_width = 1;
> +		break;
> +	case MODULE_SPEED_25G:
> +		props->active_speed = XSC_RDMA_LINK_SPEED_25GB;
> +		props->active_width = 1;
> +		break;
> +	case MODULE_SPEED_40G_R4:
> +		props->active_speed = XSC_RDMA_LINK_SPEED_10GB;
> +		props->active_width = 2;
> +		break;
> +	case MODULE_SPEED_50G_R:
> +		props->active_speed = XSC_RDMA_LINK_SPEED_50GB;
> +		props->active_width = 1;
> +		break;
> +	case MODULE_SPEED_50G_R2:
> +		props->active_speed = XSC_RDMA_LINK_SPEED_50GB;
> +		props->active_width = 1;
> +		break;
> +	case MODULE_SPEED_100G_R2:
> +		props->active_speed = XSC_RDMA_LINK_SPEED_25GB;
> +		props->active_width = 2;
> +		break;
> +	case MODULE_SPEED_100G_R4:
> +		props->active_speed = XSC_RDMA_LINK_SPEED_25GB;
> +		props->active_width = 2;
> +		break;
> +	case MODULE_SPEED_200G_R4:
> +		props->active_speed = XSC_RDMA_LINK_SPEED_50GB;
> +		props->active_width = 2;
> +		break;
> +	case MODULE_SPEED_200G_R8:
> +		props->active_speed = XSC_RDMA_LINK_SPEED_25GB;
> +		props->active_width = 4;
> +		break;
> +	case MODULE_SPEED_400G_R8:
> +		props->active_speed = XSC_RDMA_LINK_SPEED_50GB;
> +		props->active_width = 4;
> +		break;
> +	case MODULE_SPEED_400G_R4:
> +		props->active_speed = XSC_RDMA_LINK_SPEED_100GB;
> +		props->active_width = 2;
> +		break;
> +	default:
> +		props->active_speed = XSC_RDMA_LINK_SPEED_25GB;
> +		props->active_width = 1;
> +		break;
> +	}
> +}
> +
> +static enum rdma_link_layer xsc_ib_port_link_layer(struct ib_device *ibdev, u32 port)
> +{
> +	return IB_LINK_LAYER_ETHERNET;
> +}
> +
> +int xsc_ib_query_port(struct ib_device *ibdev, u32 port,
> +		      struct ib_port_attr *props)
> +{
> +	struct xsc_ib_dev *dev = to_xdev(ibdev);
> +	struct net_device *ndev = dev->netdev;
> +	struct xsc_core_device *xdev = dev->xdev;
> +
> +	if (port < 1 || port > xdev->caps.num_ports) {
> +		ibdev_warn(&dev->ib_dev, "invalid port number %d\n", port);
> +		return -EINVAL;
> +	}
> +
> +	memset(props, 0, sizeof(*props));
> +
> +	if (netif_running(ndev) && netif_carrier_ok(ndev))
> +		props->state = IB_PORT_ACTIVE;
> +	else
> +		props->state = IB_PORT_DOWN;

You can use ib_get_curr_port_state() instead of open-coding.

> +
> +	props->max_mtu = is_support_8k_mtu(xdev) ? IB_MTU_8192 : IB_MTU_4096;
> +	props->active_mtu = min(props->max_mtu, xsc_net_to_ib_mtu(ndev->mtu));

Similarly, use iboe_get_mtu().

> +	props->gid_tbl_len = XSC_IB_GID_TBL_LEN;
> +	props->port_cap_flags = IB_PORT_CM_SUP | IB_PORT_OTHER_LOCAL_CHANGES_SUP;
> +	props->max_msg_sz = SZ_1G;
> +	props->bad_pkey_cntr = 0;
> +	props->qkey_viol_cntr = 0;
> +	props->pkey_tbl_len = 1;
> +	props->lid = 0;
> +	props->sm_lid = 0;
> +	props->lmc = 0;
> +	props->max_vl_num = 0;
> +	props->sm_sl = 0;
> +	props->subnet_timeout = 0;
> +	props->init_type_reply = 0;
> +	if (!is_support_rdma(xdev)) {
> +		props->active_width = 1;
> +		props->active_speed = XSC_RDMA_LINK_SPEED_25GB;
> +	} else {
> +		xsc_calc_link_info(xdev, props);
> +	}
> +
> +	props->phys_state = netif_carrier_ok(ndev) ? XSC_RDMA_PHY_STATE_LINK_UP :
> +				XSC_RDMA_PHY_STATE_DISABLED;
> +	return 0;
> +}
> +
> +static int xsc_ib_query_pkey(struct ib_device *ibdev, u32 port, u16 index,
> +			     u16 *pkey)
> +{
> +	*pkey = 0xffff;
> +	return 0;
> +}
> +
> +int xsc_ib_alloc_ucontext(struct ib_ucontext *uctx,
> +			  struct ib_udata *udata)
> +{
> +	struct ib_device *ibdev = uctx->device;
> +	struct xsc_ib_dev *dev = to_xdev(ibdev);
> +	struct xsc_ib_alloc_ucontext_req req;
> +	struct xsc_ib_alloc_ucontext_resp resp;
> +	int err;
> +
> +	if (!dev->ib_active)
> +		return -EAGAIN;
> +
> +	err = ib_copy_from_udata(&req, udata, sizeof(req));
> +	if (err)
> +		return err;
> +
> +	memset(&resp, 0, sizeof(resp));
> +	resp.qp_tab_size      = dev->xdev->caps.max_qp;
> +	resp.cache_line_size  = L1_CACHE_BYTES;
> +	resp.max_sq_desc_sz = dev->xdev->caps.max_sq_desc_sz;
> +	resp.max_rq_desc_sz = dev->xdev->caps.max_rq_desc_sz;
> +	resp.max_send_wqebb = dev->xdev->caps.max_wqes;
> +	resp.max_recv_wr = dev->xdev->caps.max_wqes;
> +	xsc_get_db_addr(dev->xdev, &resp.qpm_tx_db, &resp.qpm_rx_db,
> +			&resp.cqm_armdb, &resp.cqm_next_cid_reg, NULL);
> +	resp.send_ds_num = dev->xdev->caps.send_ds_num;
> +	resp.recv_ds_num = dev->xdev->caps.recv_ds_num;
> +	resp.cmds_supp_uhw |= XSC_USER_CMDS_SUPP_UHW_QUERY_DEVICE;
> +	resp.device_id = dev->xdev->pdev->device;
> +
> +	if (req.abi_ver >= ALLOC_UCONTEXT_VER_V1) {
> +		xsc_get_multidb_info(dev->xdev, &resp.multidb_num, &resp.tx_multidb_base);
> +		resp.rdma_proto_mode = dev->xdev->rdma_proto_mode;
> +	}
> +
> +	if (is_support_cqe64(dev->xdev))
> +		resp.hw_feature_flag |= XSC_HW_FEATURE_FLAG_SUPPORT_CQE64;
> +
> +	resp.num_ports = dev->xdev->caps.num_ports;
> +
> +	return ib_copy_to_udata(udata, &resp, min_t(int, udata->outlen, sizeof(resp)));
> +}
> +
> +void xsc_ib_dealloc_ucontext(struct ib_ucontext *ibcontext)
> +{
> +}
> +
> +static int xsc_ib_mmap(struct ib_ucontext *ibcontext, struct vm_area_struct *vma)
> +{
> +	struct xsc_ib_dev *dev = to_xdev(ibcontext->device);
> +	struct xsc_core_device *xdev = dev->xdev;
> +	unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
> +	resource_size_t reg_base;
> +	resource_size_t reg_size = vma->vm_end - vma->vm_start;
> +	u64 tx_db = 0;
> +	u64 rx_db = 0;
> +	u64 cq_db = 0;
> +	u64 cq_reg = 0;
> +
> +	xsc_get_db_addr(xdev, &tx_db, &rx_db, &cq_db, &cq_reg, NULL);
> +	dev_dbg(&xdev->pdev->dev, "offset:0x%lx\n", offset);
> +
> +	if (offset == (tx_db & PAGE_MASK))
> +		reg_base = pci_resource_start(xdev->pdev, xdev->bar_num) + (tx_db & PAGE_MASK);
> +	else if (offset == (rx_db & PAGE_MASK))
> +		reg_base = pci_resource_start(xdev->pdev, xdev->bar_num) + (rx_db & PAGE_MASK);
> +	else if (offset == (cq_reg & PAGE_MASK))
> +		reg_base = pci_resource_start(xdev->pdev, xdev->bar_num) + (cq_reg & PAGE_MASK);
> +	else if (offset == (cq_db & PAGE_MASK))
> +		reg_base = pci_resource_start(xdev->pdev, xdev->bar_num) + (cq_db & PAGE_MASK);
> +	else if (offset == (QPM_TX_MDB_BASE_REG_ADDR & PAGE_MASK))
> +		reg_base = pci_resource_start(xdev->pdev, xdev->bar_num) +
> +			(QPM_TX_MDB_BASE_REG_ADDR & PAGE_MASK);
> +	else if (offset == (xdev->caps.mdb_base & PAGE_MASK))
> +		reg_base = pci_resource_start(xdev->pdev, xdev->bar_num) +
> +			(xdev->caps.mdb_base & PAGE_MASK);
> +	else
> +		return -EINVAL;
> +
> +	dev_dbg(&xdev->pdev->dev, "regbase:0x%llx", reg_base);
> +
> +	reg_base = (xsc_core_is_pf(xdev) && !is_pf_bar_compressed(xdev)) ?
> +		reg_base - 0xA0000000 : reg_base;
> +
> +	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> +	return remap_pfn_range(vma, vma->vm_start, reg_base >> PAGE_SHIFT,
> +			       reg_size, vma->vm_page_prot);
> +}
> +
> +static int xsc_port_immutable(struct ib_device *ibdev, u32 port_num,
> +			      struct ib_port_immutable *immutable)
> +{
> +	struct ib_port_attr attr;
> +	int err;
> +
> +	err = ib_query_port(ibdev, port_num, &attr);
> +	if (err)
> +		return err;
> +
> +	immutable->pkey_tbl_len = attr.pkey_tbl_len;
> +	immutable->gid_tbl_len = attr.gid_tbl_len;
> +	immutable->core_cap_flags = RDMA_CORE_PORT_IBA_ROCE |
> +				    RDMA_CORE_PORT_IBA_ROCE_UDP_ENCAP;
> +	immutable->max_mad_size = IB_MGMT_MAD_SIZE * 2;
> +
> +	return 0;
> +}
> +
> +static struct net_device *xsc_get_netdev(struct ib_device *ibdev, u32 port_num)

You should use ib_device_set_netdev() instead of implementing this op.

> +{
> +	struct xsc_ib_dev *xsc_ib_dev = to_xdev(ibdev);
> +	struct net_device *dev = xsc_ib_dev->netdev;
> +
> +	if (dev)
> +		dev_hold(dev);
> +
> +	return dev;
> +}
> +
> +static void xsc_get_guid(const u8 *dev_addr, u8 *guid)
> +{
> +	u8 mac[ETH_ALEN];
> +
> +	/* MAC-48 to EUI-64 mapping */
> +	memcpy(mac, dev_addr, ETH_ALEN);
> +	guid[0] = mac[0] ^ 2;
> +	guid[1] = mac[1];
> +	guid[2] = mac[2];
> +	guid[3] = 0xff;
> +	guid[4] = 0xfe;
> +	guid[5] = mac[3];
> +	guid[6] = mac[4];
> +	guid[7] = mac[5];
> +}
> +
> +static void init_node_data(struct xsc_ib_dev *dev)
> +{
> +	strscpy(dev->ib_dev.node_desc, "xsc_node_desc",
> +		sizeof(dev->ib_dev.node_desc));
> +	xsc_get_guid(dev->netdev->dev_addr, (u8 *)&dev->ib_dev.node_guid);
> +}
> +
> +static void xsc_ib_event(struct xsc_core_device *dev, void *context,
> +			 enum xsc_dev_event event, unsigned long data)
> +{
> +	struct xsc_ib_dev *ibdev = (struct xsc_ib_dev *)context;
> +	struct ib_event ibev;
> +	u8 port = 0;
> +
> +	switch (event) {
> +	case XSC_DEV_EVENT_SYS_ERROR:
> +		ibdev->ib_active = false;
> +		ibev.event = IB_EVENT_DEVICE_FATAL;
> +		break;
> +
> +	case XSC_DEV_EVENT_PORT_UP:
> +		ibev.event = IB_EVENT_PORT_ACTIVE;
> +		port = *(u8 *)data;
> +		break;
> +
> +	case XSC_DEV_EVENT_PORT_DOWN:
> +		ibev.event = IB_EVENT_PORT_ERR;
> +		port = *(u8 *)data;
> +		break;
> +
> +	case XSC_DEV_EVENT_PORT_INITIALIZED:
> +		/* not used by ULPs */
> +		return;
> +
> +	case XSC_DEV_EVENT_LID_CHANGE:
> +		ibev.event = IB_EVENT_LID_CHANGE;
> +		port = *(u8 *)data;
> +		break;
> +
> +	case XSC_DEV_EVENT_PKEY_CHANGE:
> +		ibev.event = IB_EVENT_PKEY_CHANGE;
> +		port = *(u8 *)data;
> +		break;
> +
> +	case XSC_DEV_EVENT_GUID_CHANGE:
> +		ibev.event = IB_EVENT_GID_CHANGE;
> +		port = *(u8 *)data;
> +		break;
> +
> +	case XSC_DEV_EVENT_CLIENT_REREG:
> +		ibev.event = IB_EVENT_CLIENT_REREGISTER;
> +		port = *(u8 *)data;
> +		break;
> +	}
> +
> +	ibev.device	      = &ibdev->ib_dev;
> +	ibev.element.port_num = port;
> +
> +	if (ibdev->ib_active)
> +		ib_dispatch_event(&ibev);
> +}
> +
> +static void xsc_ib_get_dev_fw_str(struct ib_device *ibdev, char *str)
> +{
> +	struct xsc_core_device *dev = to_xdev(ibdev)->xdev;
> +	u8 ver_major = dev->fw_version_major;
> +	u8 ver_minor = dev->fw_version_minor;
> +	u16 ver_patch = dev->fw_version_patch;
> +	u32 ver_tweak = dev->fw_version_tweak;
> +
> +	if (ver_tweak == 0) {
> +		snprintf(str, IB_FW_VERSION_NAME_MAX, "v%u.%u.%u",
> +			 ver_major,  ver_minor, ver_patch);
> +	} else {
> +		snprintf(str, IB_FW_VERSION_NAME_MAX, "v%u.%u.%u+%u",
> +			 ver_major, ver_minor, ver_patch, ver_tweak);
> +	}
> +}
> +
> +static void xsc_ib_disassociate_ucontext(struct ib_ucontext *ibcontext)
> +{
> +}
> +
> +static void xsc_ib_dev_setting(struct xsc_ib_dev *dev)
> +{
> +	dev->ib_dev.ops.owner		= THIS_MODULE;
> +	dev->ib_dev.ops.uverbs_abi_ver	= XSC_IB_UVERBS_ABI_VERSION;
> +	dev->ib_dev.ops.driver_id = RDMA_DRIVER_XSC;
> +	dev->ib_dev.ops.disassociate_ucontext = xsc_ib_disassociate_ucontext;
> +	dev->ib_dev.ops.query_device	= xsc_ib_query_device;
> +	dev->ib_dev.ops.query_port	= xsc_ib_query_port;
> +	dev->ib_dev.ops.query_pkey	= xsc_ib_query_pkey;
> +
> +	dev->ib_dev.ops.alloc_ucontext	= xsc_ib_alloc_ucontext;
> +	dev->ib_dev.ops.dealloc_ucontext = xsc_ib_dealloc_ucontext;
> +	dev->ib_dev.ops.mmap		= xsc_ib_mmap;
> +
> +
> +	dev->ib_dev.ops.get_link_layer	= xsc_ib_port_link_layer;
> +	dev->ib_dev.ops.get_netdev		= xsc_get_netdev;
> +
> +
> +	dev->ib_dev.ops.get_port_immutable		= xsc_port_immutable;
> +
> +	dev->ib_dev.ops.get_dev_fw_str	= xsc_ib_get_dev_fw_str;
> +
> +	dev->ib_dev.ops INIT_RDMA_OBJ_SIZE(ib_ucontext, xsc_ib_ucontext, ibucontext);
> +}
> +
> +static void xsc_get_port_state(struct net_device *ndev, enum xsc_dev_event *ev)
> +{
> +	*ev = XSC_DEV_EVENT_PORT_DOWN;
> +	if (netif_running(ndev) && netif_carrier_ok(ndev))
> +		*ev = XSC_DEV_EVENT_PORT_UP;
> +}
> +
> +static int xsc_netdev_event(struct notifier_block *this, unsigned long event, void *ptr)
> +{
> +	struct xsc_ib_dev *ibdev = container_of(this, struct xsc_ib_dev, nb);
> +	struct net_device *ndev = netdev_notifier_info_to_dev(ptr);
> +	enum xsc_dev_event ev;
> +	u8 port = 1;
> +
> +	if (ndev != ibdev->netdev)
> +		goto done;
> +
> +	ibdev_dbg(&ibdev->ib_dev, "netdev notfiy event:%ld\n", event);
> +	switch (event) {
> +	case NETDEV_CHANGE:
> +	case NETDEV_UP:
> +	case NETDEV_DOWN:
> +		xsc_get_port_state(ibdev->netdev, &ev);
> +		xsc_ib_event(ibdev->xdev, ibdev, ev, (unsigned long)&port);
> +		break;
> +	default:
> +		break;
> +	}
> +done:
> +	return NOTIFY_DONE;
> +}
> +
> +static int xsc_register_netdev_notifier(struct xsc_ib_dev *ibdev)
> +{
> +	ibdev->nb.notifier_call = xsc_netdev_event;
> +	return register_netdevice_notifier(&ibdev->nb);
ib_netdevice_event() already handles these events. You can also implement
.report_port_event() if needed. Anyhow you probably don't need this
notifier in driver.

> +}
> +
> +static int xsc_unregister_netdev_notifier(struct xsc_ib_dev *ibdev)
> +{
> +	return unregister_netdevice_notifier(&ibdev->nb);
> +}
> +
> +static int init_one(struct xsc_core_device *xdev,
> +		    struct xsc_ib_dev **ibdev)
> +{
> +	struct xsc_ib_dev *dev;
> +	int err;
> +
> +	dev = (struct xsc_ib_dev *)ib_alloc_device(xsc_ib_dev, ib_dev);
> +	if (!dev)
> +		return -ENOMEM;
> +
> +	dev->xdev = xdev;
> +	dev->netdev = xdev->netdev;
> +	strscpy(dev->ib_dev.name, "xscale_%d", IB_DEVICE_NAME_MAX);
> +
> +	memcpy(dev->xdev->priv.ibdev_name, dev->ib_dev.name, IB_DEVICE_NAME_MAX);
> +
> +	if (!xdev->caps.msix_enable)
> +		dev->num_comp_vectors = 1;
> +	else
> +		dev->num_comp_vectors = xdev->dev_res->eq_table.num_comp_vectors;
> +
> +	dev->ib_dev.node_type		= RDMA_NODE_IB_CA;
> +	dev->ib_dev.local_dma_lkey	= 0xFF;
> +	dev->num_ports		= xdev->caps.num_ports;
> +	dev->ib_dev.phys_port_cnt     = dev->num_ports;
> +	dev->ib_dev.num_comp_vectors	= dev->num_comp_vectors;
> +	dev->ib_dev.dev.parent = &xdev->pdev->dev;
> +	xsc_ib_dev_setting(dev);
> +	dev->xdev->priv.cm_dscp = DSCP_PCP_UNSET;
> +	dev->xdev->priv.cm_pcp = DSCP_PCP_UNSET;
> +	dev->xdev->priv.force_pcp = DSCP_PCP_UNSET;
> +	dev->xdev->priv.force_dscp = DSCP_PCP_UNSET;
> +	dev->xdev->rdma_proto_mode = RDMA_PROTO_ROCEV2;
> +	dev->xdev->cm_udp_dst_port = ROCE_V2_UDP_DPORT;
> +	dev->xdev->veroce_udp_dst_port = VEROCE_UDP_DPORT;
> +
> +	dev->ib_dev.uverbs_cmd_mask	=
> +		(1ull << IB_USER_VERBS_CMD_GET_CONTEXT)		|
> +		(1ull << IB_USER_VERBS_CMD_QUERY_DEVICE)	|
> +		(1ull << IB_USER_VERBS_CMD_QUERY_PORT)		|
> +		(1ull << IB_USER_VERBS_CMD_ALLOC_PD)		|
> +		(1ull << IB_USER_VERBS_CMD_DEALLOC_PD)		|
> +		(1ull << IB_USER_VERBS_CMD_CREATE_AH)		|
> +		(1ull << IB_USER_VERBS_CMD_DESTROY_AH)		|
> +		(1ull << IB_USER_VERBS_CMD_REG_MR)		|
> +		(1ull << IB_USER_VERBS_CMD_REREG_MR)		|
> +		(1ull << IB_USER_VERBS_CMD_DEREG_MR)		|
> +		(1ull << IB_USER_VERBS_CMD_CREATE_COMP_CHANNEL)	|
> +		(1ull << IB_USER_VERBS_CMD_CREATE_CQ)		|
> +		(1ull << IB_USER_VERBS_CMD_RESIZE_CQ)		|
> +		(1ull << IB_USER_VERBS_CMD_DESTROY_CQ)		|
> +		(1ull << IB_USER_VERBS_CMD_CREATE_QP)		|
> +		(1ull << IB_USER_VERBS_CMD_MODIFY_QP)		|
> +		(1ull << IB_USER_VERBS_CMD_QUERY_QP)		|
> +		(1ull << IB_USER_VERBS_CMD_DESTROY_QP)		|
> +		(1ull << IB_USER_VERBS_CMD_ATTACH_MCAST)	|
> +		(1ull << IB_USER_VERBS_CMD_DETACH_MCAST)	|
> +		(1ull << IB_USER_VERBS_CMD_CREATE_SRQ)		|
> +		(1ull << IB_USER_VERBS_CMD_MODIFY_SRQ)		|
> +		(1ull << IB_USER_VERBS_CMD_QUERY_SRQ)		|
> +		(1ull << IB_USER_VERBS_CMD_DESTROY_SRQ)		|
> +		(1ull << IB_USER_VERBS_CMD_OPEN_QP);
> +
> +	init_node_data(dev);
> +
> +
> +
> +

Too many blank lines.

> +	err = ib_register_device(&dev->ib_dev, dev->ib_dev.name,
> +				 dev->xdev->device);
> +	if (err)
> +		goto err_free;
> +
> +	rdma_roce_rescan_device(&dev->ib_dev);

This is already called in
ib_register_device → ib_cache_setup_one → gid_table_setup_one

> +	dev->ib_active = true;
> +	*ibdev = dev;
> +
> +	xsc_register_netdev_notifier(dev);
> +
> +
> +

Too many blank lines.

> +	return 0;
> +
> +err_free:
> +	ib_dealloc_device((struct ib_device *)dev);
> +
> +	return err;
> +}
> +
> diff --git a/drivers/infiniband/hw/xsc/xsc_ib.h b/drivers/infiniband/hw/xsc/xsc_ib.h
> new file mode 100644
> index 000000000..a2ae382e2
> --- /dev/null
> +++ b/drivers/infiniband/hw/xsc/xsc_ib.h
> @@ -0,0 +1,542 @@
> +static inline void *xsc_ib_iova_to_virt(struct ib_device *ibdev, dma_addr_t iova)
> +{
> +	phys_addr_t phyaddr;
> +	struct iommu_domain *domain;
> +
> +	domain = iommu_get_domain_for_dev(ibdev->dma_device);
> +	if (likely(domain)) {
> +		phyaddr = iommu_iova_to_phys(domain, iova);
> +		phyaddr |= iova & (PAGE_SIZE - 1);
> +	} else {
> +		phyaddr = dma_to_phys(ibdev->dma_device, iova);
> +	}
> +
> +	return phys_to_virt(phyaddr);
> +}
> +
> +struct ib_mad_list_head {

Why are these ib_mad structures defined again in the driver's header?

Junxian

> +	struct list_head list;
> +	struct ib_cqe cqe;
> +	struct ib_mad_queue *mad_queue;
> +};
> +
> +#define IB_MAD_SEND_REQ_MAX_SG 2
> +struct ib_mad_send_wr_private {
> +	struct ib_mad_list_head mad_list;
> +	struct list_head agent_list;
> +	struct ib_mad_agent_private *mad_agent_priv;
> +	struct ib_mad_send_buf send_buf;
> +	u64 header_mapping;
> +	u64 payload_mapping;
> +	struct ib_ud_wr send_wr;
> +	struct ib_sge sg_list[IB_MAD_SEND_REQ_MAX_SG];
> +	__be64 tid;
> +	unsigned long timeout;
> +	int max_retries;
> +	int retries_left;
> +	int retry;
> +	int refcount;
> +	enum ib_wc_status status;
> +
> +	/* RMPP control */
> +	struct list_head rmpp_list;
> +	struct ib_rmpp_segment *last_ack_seg;
> +	struct ib_rmpp_segment *cur_seg;
> +	int last_ack;
> +	int seg_num;
> +	int newwin;
> +	int pad;
> +};
> +
> +struct ib_mad_private_header {
> +	struct ib_mad_list_head mad_list;
> +	struct ib_mad_recv_wc recv_wc;
> +	struct ib_wc wc;
> +	u64 mapping;
> +} __packed;
> +
> +struct ib_mad_private {
> +	struct ib_mad_private_header header;
> +	size_t mad_size;
> +	struct ib_grh grh;
> +	DECLARE_FLEX_ARRAY(u8, mad);
> +} __packed;
> +
> +static inline void *xsc_ib_send_mad_sg_virt_addr(struct ib_device *ibdev,
> +						 const struct ib_send_wr *wr,
> +						 int sg)
> +{
> +	struct ib_mad_send_wr_private *mad_send_wr;
> +	struct ib_mad_list_head *mad_list;
> +	int iommu_state = xsc_ib_iommu_dma_map(ibdev);
> +
> +	/* direct dma mapping */
> +	if (!iommu_state)
> +		return phys_to_virt(dma_to_phys(ibdev->dma_device, wr->sg_list[sg].addr));
> +
> +	if (iommu_state == XSC_IB_IOMMU_MAP_NORMAL)
> +		return xsc_ib_iova_to_virt(ibdev, wr->sg_list[sg].addr);
> +
> +	mad_list = container_of(wr->wr_cqe, struct ib_mad_list_head, cqe);
> +	mad_send_wr = container_of(mad_list, struct ib_mad_send_wr_private,
> +				   mad_list);
> +
> +	/* sg_list[0] */
> +	if (sg == 0)
> +		return mad_send_wr->send_buf.mad;
> +
> +	/* sg_list[1] */
> +	if (mad_send_wr->send_buf.seg_count)
> +		return ib_get_rmpp_segment(&mad_send_wr->send_buf,
> +					   mad_send_wr->seg_num);
> +	return mad_send_wr->send_buf.mad + mad_send_wr->send_buf.hdr_len;
> +}
> +
> +static inline void *xsc_ib_recv_mad_sg_virt_addr(struct ib_device *ibdev,
> +						 struct ib_wc *wc,
> +						 u64 sg_addr)
> +{
> +	struct ib_mad_private_header *mad_priv_hdr;
> +	struct ib_mad_private *recv;
> +	struct ib_mad_list_head *mad_list;
> +	int iommu_state = xsc_ib_iommu_dma_map(ibdev);
> +
> +	/* direct dma mapping */
> +	if (!iommu_state)
> +		return phys_to_virt(dma_to_phys(ibdev->dma_device, sg_addr));
> +
> +	if (iommu_state == XSC_IB_IOMMU_MAP_NORMAL)
> +		return xsc_ib_iova_to_virt(ibdev, sg_addr);
> +
> +	mad_list = container_of(wc->wr_cqe, struct ib_mad_list_head, cqe);
> +	mad_priv_hdr = container_of(mad_list, struct ib_mad_private_header, mad_list);
> +	recv = container_of(mad_priv_hdr, struct ib_mad_private, header);
> +	return &recv->grh;
> +}
> +
> +struct xsc_ib_burst_info {
> +	__u32       max_burst_sz;
> +	__u16       typical_pkt_sz;
> +	__u16       reserved;
> +};
> +
> +struct xsc_ib_modify_qp {
> +	__u32		reserved;
> +	struct xsc_ib_burst_info  burst_info;
> +	__u32		profile;
> +};
> +
> +#endif /* XSC_IB_H */
