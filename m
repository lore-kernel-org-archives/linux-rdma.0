Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.39
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793792771;
	b=hFrjmUfW95Ytjad3Y+16PffBG1sLgHsvjV9dM3ScaiZSNZUk2KtmfnKvOaT+BVNXgTkE
	 jPw9jN4zUitlMjyi+PXoZe55DYUFbs7+Hcu7gp5HyQaP8Vmfyq+GcpHTcXEelqa7YDHfS
	 P/LPAh4FFNyGQwbxU8iO0gC5/sOYivsKkl4wxKJvkP2G5PPSA27fUcVcAc+1O2U/Kviui
	 bU0HdnEeNEXPfBcGzJBiVlF7itB7RZ/xA57sGMBcNq3XVkfl49XwzRcInblgBdw5bXN1w
	 7mvTla9bRUVKsGAqDMMizzs84SwNFbia1nSjYSGMvlf0sv6KxpcR6PuVd4fBD3537MQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793792771;
	h=DMARC-Filter:DKIM-Signature:Cc:Date:Message-Id:Subject:Mime-Version:
	 References:Content-Transfer-Encoding:In-Reply-To:Content-Type:To:From:
	 User-Agent:Received:X-Lms-Return-Path:X-Original-From;
	bh=daDUEGUETFFW0liwjnEoSCCpT52aMpV1OQ/HbO84zr4=;
	b=4ybnGsUBp2rC4lU6OxPUYsL+6XbBos0hkfFYsuC3mx0N8Uv+Uyj3kOk2wYXxcIWUkYtF
	 fKgya0wo6Mo3RbG8tDKjdUuqav9ogubFAtZrzcl2bIGl33lIAkBz5/pCmKGroxFiXnNSY
	 tnah54csLXzQgRUc3Ltm9ejf0MGSxJtKvIRa11qXH9CjIW4/z4oQI4uq3HxNlo1uWKB9O
	 RRiViIccaZG9PfnrM7IVjl/5FZCVioSQvXcpLVrxaE2Yyg+W3gU921mtA8M33oc8GBd0E
	 UTFi+c38eFvLpgHlYV5ZT9Qgp/4wUkF2UvQA9+OQcoYA1rxKCyYOOkRUijfDrgf3GLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=yunsilicon.com;
	spf=pass smtp.mailfrom=yunsilicon.com;
	dkim=pass header.d=yunsilicon.com header.i=@yunsilicon.com header.a=rsa-sha256 header.s=feishu2403070942 header.b=TqP0p3qh;
	arc=none smtp.remote-ip=209.127.231.39
Received: from va-2-39.ptr.blmpb.com (va-2-39.ptr.blmpb.com [209.127.231.39])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D223F606A31B
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 11:46:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D223F606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=yunsilicon.com header.i=@yunsilicon.com header.a=rsa-sha256 header.s=feishu2403070942 header.b=TqP0p3qh
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=feishu2403070942; d=yunsilicon.com; t=1793792764; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=daDUEGUETFFW0liwjnEoSCCpT52aMpV1OQ/HbO84zr4=;
 b=TqP0p3qh6rGY7g/sK8EXL3OSM1M8SBLvgWijTMSN/4AGLZlJ3ovNolBDKVelJx9wGLGH/7
 cO6GiwZqJE6dfd599sdLkWUchdpCIpZRS0/1pGrp7m7eBNNFni3txjXvg5yDO6LIDMEvLf
 zubdVDn3yyitjMfXYZCBwDwHze0U/XCTCTAMR+vNqbAz6rc9moNQt7CTGmsTjy/01WTgbR
 smsa39rLBDum5x/6LSLaHiqAaiYxFzfJLFEQ0/MfdPF9QnbKp1CloDejyjS2t9GojP54uc
 mkXziKgVUAse/ShJm2QMYtE+PKNLTe7I4zUrUpx/oa5P8zT6dzBmAyvxeFLgow==
Cc: <weihg@yunsilicon.com>, <linux-kernel@vger.kernel.org>, 
	<netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>
Date: Wed, 4 Nov 2026 19:46:00 +0800
Message-Id: <3e3f61cd-1430-4ece-96f6-5beca185202f@yunsilicon.com>
Subject: Re: [PATCH 09/15] yunsilicon: add RDMA device support
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261012114352.2471317-1-tianx@yunsilicon.com> <20261012114412.2471317-10-tianx@yunsilicon.com> <3cb7230e-079d-8d3b-5605-16149d2af01d@hisilicon.com>
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <3cb7230e-079d-8d3b-5605-16149d2af01d@hisilicon.com>
Content-Type: text/plain; charset=UTF-8
To: "Junxian Huang" <huangjunxian6@hisilicon.com>, 
	"Andrew Lunn" <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, 
	"Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>, 
	"Paolo Abeni" <pabeni@redhat.com>, "Jason Gunthorpe" <jgg@ziepe.ca>, 
	"Leon Romanovsky" <leon@kernel.org>
From: "Xin Tian" <tianx@yunsilicon.com>
User-Agent: Mozilla Thunderbird
Received: from [127.0.0.1] ([180.152.18.210]) by smtp.feishu.cn with ESMTPS; Wed, 04 Nov 2026 19:46:02 +0800
X-Lms-Return-Path: <lba+26aeb1afb+aba8d3+vger.kernel.org+tianx@yunsilicon.com>
X-Original-From: Xin Tian <tianx@yunsilicon.com>

On 10/13/2026 2:17 PM, Junxian Huang wrote:
>
> On 2026/10/12 19:44, Xin Tian wrote:
>> Add the RDMA driver's uverbs ABI header (include/uapi/rdma/xsc-abi.h),
>> the ib_device scaffolding and device registration: query_device,
>> query_port, query_pkey, ucontext allocation and mmap, port attributes an=
d
>> the netdev notifier that tracks the port state.
>>
>> The driver reports RDMA_DRIVER_XSC, which is added to the rdma_driver_id
>> enum at the end so existing IDs are untouched.
>>
>> Signed-off-by: Xin Tian <tianx@yunsilicon.com>
>> ---
>>   drivers/infiniband/Kconfig                    |   1 +
>>   drivers/infiniband/hw/Makefile                |   1 +
>>   drivers/infiniband/hw/xsc/Kconfig             |  17 +
>>   drivers/infiniband/hw/xsc/Makefile            |   9 +
>>   drivers/infiniband/hw/xsc/main.c              | 797 ++++++++++++++++++
>>   drivers/infiniband/hw/xsc/xsc_ib.h            | 542 ++++++++++++
>>   .../net/ethernet/yunsilicon/xsc/common/cq.h   |  30 +
>>   .../ethernet/yunsilicon/xsc/common/driver.h   |  95 +++
>>   .../net/ethernet/yunsilicon/xsc/common/qp.h   | 104 +++
>>   .../net/ethernet/yunsilicon/xsc/common/srq.h  |  54 ++
>>   .../net/ethernet/yunsilicon/xsc/pci/Makefile  |   2 +-
>>   .../net/ethernet/yunsilicon/xsc/pci/link.c    |  35 +
>>   include/uapi/rdma/ib_user_ioctl_verbs.h       |   1 +
>>   include/uapi/rdma/xsc-abi.h                   | 295 +++++++
>>   14 files changed, 1982 insertions(+), 1 deletion(-)
>>   create mode 100644 drivers/infiniband/hw/xsc/Kconfig
>>   create mode 100644 drivers/infiniband/hw/xsc/Makefile
>>   create mode 100644 drivers/infiniband/hw/xsc/main.c
>>   create mode 100644 drivers/infiniband/hw/xsc/xsc_ib.h
>>   create mode 100644 drivers/net/ethernet/yunsilicon/xsc/common/cq.h
>>   create mode 100644 drivers/net/ethernet/yunsilicon/xsc/common/driver.h
>>   create mode 100644 drivers/net/ethernet/yunsilicon/xsc/common/qp.h
>>   create mode 100644 drivers/net/ethernet/yunsilicon/xsc/common/srq.h
>>   create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/link.c
>>   create mode 100644 include/uapi/rdma/xsc-abi.h
>>
>> diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
>> index 086195758..b3cc506db 100644
>> --- a/drivers/infiniband/Kconfig
>> +++ b/drivers/infiniband/Kconfig
>> @@ -100,6 +100,7 @@ source "drivers/infiniband/hw/ocrdma/Kconfig"
>>   source "drivers/infiniband/hw/qedr/Kconfig"
>>   source "drivers/infiniband/hw/usnic/Kconfig"
>>   source "drivers/infiniband/hw/vmw_pvrdma/Kconfig"
>> +source "drivers/infiniband/hw/xsc/Kconfig"
>>   source "drivers/infiniband/sw/rdmavt/Kconfig"
>>   endif # !UML
>>   source "drivers/infiniband/sw/rxe/Kconfig"
>> diff --git a/drivers/infiniband/hw/Makefile b/drivers/infiniband/hw/Make=
file
>> index c42b22ac3..1bcd2d50a 100644
>> --- a/drivers/infiniband/hw/Makefile
>> +++ b/drivers/infiniband/hw/Makefile
>> @@ -16,3 +16,4 @@ obj-$(CONFIG_INFINIBAND_BNXT_RE)	+=3D bnxt_re/
>>   obj-$(CONFIG_INFINIBAND_BNG_RE)		+=3D bng_re/
>>   obj-$(CONFIG_INFINIBAND_ERDMA)		+=3D erdma/
>>   obj-$(CONFIG_INFINIBAND_IONIC)		+=3D ionic/
>> +obj-$(CONFIG_INFINIBAND_XSC)	+=3D xsc/
>> diff --git a/drivers/infiniband/hw/xsc/Kconfig b/drivers/infiniband/hw/x=
sc/Kconfig
>> new file mode 100644
>> index 000000000..5cf46df2d
>> --- /dev/null
>> +++ b/drivers/infiniband/hw/xsc/Kconfig
>> @@ -0,0 +1,17 @@
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (C) 2021 - 2026, Shanghai Yunsilicon Technology Co., Ltd.
>> +# All rights reserved.
>> +
>> +config INFINIBAND_XSC
>> +	tristate "Yunsilicon XSC RDMA driver"
>> +	depends on INFINIBAND && PCI && INET
>> +	depends on YUNSILICON_XSC_PCI && YUNSILICON_XSC_ETH
>> +	help
>> +	  This driver provides RDMA support for Yunsilicon XSC devices.
>> +	  It uses the auxiliary device published by the XSC PCI core and,
>> +	  for now, the netdev registered by the XSC ethernet driver to
>> +	  derive the port state and GID.  Because of that netdev
>> +	  dependency it also depends on YUNSILICON_XSC_ETH.
>> +
>> +	  To compile this driver as a module, choose M here. The module
>> +	  will be called xsc_ib.
>> diff --git a/drivers/infiniband/hw/xsc/Makefile b/drivers/infiniband/hw/=
xsc/Makefile
>> new file mode 100644
>> index 000000000..6c4ec1ca0
>> --- /dev/null
>> +++ b/drivers/infiniband/hw/xsc/Makefile
>> @@ -0,0 +1,9 @@
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (C) 2021 - 2026, Shanghai Yunsilicon Technology Co., Ltd.
>> +# All rights reserved.
>> +
>> +ccflags-y :=3D -I$(srctree)/drivers/net/ethernet/yunsilicon/xsc
>> +
>> +obj-$(CONFIG_INFINIBAND_XSC) +=3D xsc_ib.o
>> +
>> +xsc_ib-y :=3D main.o
>> diff --git a/drivers/infiniband/hw/xsc/main.c b/drivers/infiniband/hw/xs=
c/main.c
>> new file mode 100644
>> index 000000000..9d53a89be
>> --- /dev/null
>> +++ b/drivers/infiniband/hw/xsc/main.c
>> @@ -0,0 +1,797 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Copyright (C) 2021 - 2026, Shanghai Yunsilicon Technology Co., Ltd.
>> + * All rights reserved.
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/auxiliary_bus.h>
>> +#include <linux/init.h>
>> +#include <linux/errno.h>
>> +#include <linux/pci.h>
>> +#include <linux/namei.h>
>> +#include <linux/kobject.h>
>> +#include <linux/kernfs.h>
>> +#include <linux/dma-mapping.h>
>> +#include <linux/slab.h>
>> +#include <linux/io-mapping.h>
>> +#include <linux/sched.h>
>> +#include <linux/netdevice.h>
>> +#include "common/xsc_core.h"
>> +#include "common/xsc_hsi.h"
>> +#include "common/xsc_cmd.h"
>> +#include "common/driver.h"
>> +
>> +#include <rdma/ib_user_verbs.h>
>> +#include <rdma/ib_smi.h>
>> +#include <rdma/ib_umem.h>
>> +
>> +#include <rdma/xsc-abi.h>
>> +#include "xsc_ib.h"
>> +
>> +#define DRIVER_NAME "xsc_ib"
>> +
>> +#define XSC_IB_GID_TBL_LEN	256
>> +#define XSC_IB_MAX_PKEYS	0x80
>> +
>> +MODULE_DESCRIPTION("Yunsilicon HCA IB driver");
>> +MODULE_LICENSE("GPL");
>> +
>> +static int xsc_ib_query_device(struct ib_device *ibdev,
>> +			       struct ib_device_attr *props,
>> +			       struct ib_udata *udata)
> Are the comments in this function really needed? I think the codes
> are self-explainable enough.
Hi Junxian,

All ten are fixed in v1, which I'll post shortly.
>> +{
>> +	size_t udata_outlen =3D (udata) ? udata->outlen : 0;
>> +	struct xsc_ib_dev *dev =3D to_xdev(ibdev);
>> +	struct xsc_ib_query_device_resp resp;
>> +	union xsc_ib_fw_ver fw_ver;
>> +	int err =3D -ENOMEM;
>> +	size_t resp_len;
>> +	int max_rq_sg;
>> +	u64 max_tso;
>> +	u64 flags;
>> +
>> +	err =3D ib_is_udata_in_empty(udata);
>> +	if (err)
>> +		return err;
>> +
>> +	memset(&resp, 0, sizeof(resp));
>> +	memset(props, 0, sizeof(*props));
> The core already handles the zeroing, no need to do this in driver.
Fixed.
>
>> +
>> +	resp_len =3D sizeof(resp.comp_mask) + sizeof(resp.response_length);
>> +	/*check param*/
>> +	if (udata_outlen && udata_outlen < resp_len)
>> +		return -EINVAL;
>> +
>> +	resp.response_length =3D resp_len;
>> +
>> +	fw_ver.data =3D 0;
>> +	fw_ver.s.ver_major =3D dev->xdev->fw_version_major;
>> +	fw_ver.s.ver_minor =3D dev->xdev->fw_version_minor;
>> +	fw_ver.s.ver_patch =3D dev->xdev->fw_version_patch;
>> +	fw_ver.s.ver_tweak =3D dev->xdev->fw_version_tweak;
>> +	props->fw_ver =3D fw_ver.data;
>> +
>> +	props->device_cap_flags    =3D IB_DEVICE_CHANGE_PHY_PORT |
>> +		IB_DEVICE_PORT_ACTIVE_EVENT		|
>> +		IB_DEVICE_SYS_IMAGE_GUID		|
>> +		IB_DEVICE_RC_RNR_NAK_GEN;
>> +	props->kernel_cap_flags =3D  IBK_BLOCK_MULTICAST_LOOPBACK;
>> +	props->kernel_cap_flags |=3D IBK_LOCAL_DMA_LKEY;
>> +
>> +	flags =3D dev->xdev->caps.flags;
>> +	if (flags & XSC_DEV_CAP_FLAG_BAD_PKEY_CNTR)
>> +		props->device_cap_flags |=3D IB_DEVICE_BAD_PKEY_CNTR;
>> +	if (flags & XSC_DEV_CAP_FLAG_BAD_QKEY_CNTR)
>> +		props->device_cap_flags |=3D IB_DEVICE_BAD_QKEY_CNTR;
>> +	if (flags & XSC_DEV_CAP_FLAG_APM)
>> +		props->device_cap_flags |=3D IB_DEVICE_AUTO_PATH_MIG;
>> +	props->page_size_cap	   =3D dev->xdev->caps.min_page_sz;
>> +	props->max_mr_size	   =3D xsc_get_max_mr_size(dev->xdev);
>> +	props->max_qp		   =3D dev->xdev->caps.max_qp;
>> +	props->max_qp_wr	   =3D xsc_get_max_qp_depth(dev->xdev);
>> +	max_rq_sg =3D dev->xdev->caps.max_rq_desc_sz / sizeof(struct xsc_wqe_d=
ata_seg);
>> +
>> +	props->max_send_sge =3D dev->xdev->caps.send_ds_num - XSC_CTRL_SEG_NUM=
 -
>> +		XSC_RADDR_SEG_NUM;
>> +	props->max_recv_sge =3D dev->xdev->caps.recv_ds_num;
>> +	props->max_sge_rd	   =3D 1;/*max sge per read wqe*/
>> +	props->max_cq		   =3D dev->xdev->caps.max_cq;
>> +	props->max_cqe		   =3D dev->xdev->caps.max_cqes;
>> +	props->max_mr		   =3D (1 << dev->xdev->caps.log_max_mkey) - 1;
>> +	props->max_pd		   =3D dev->xdev->caps.max_pd;
>> +	props->max_qp_rd_atom	   =3D dev->xdev->caps.max_ra_res_qp;
>> +	props->max_qp_init_rd_atom =3D dev->xdev->caps.max_ra_req_qp;
>> +	props->max_res_rd_atom	   =3D props->max_qp_rd_atom * props->max_qp;
>> +	props->max_srq		   =3D
>> +		dev->xdev->caps.log_max_srq ? (1 << dev->xdev->caps.log_max_srq) : 0;
>> +	props->max_srq_wr	   =3D dev->xdev->caps.max_srq_wqes - 1;
>> +	props->max_srq_sge	   =3D dev->xdev->caps.log_max_srq ? (max_rq_sg - 1=
) : 0;
>> +	props->local_ca_ack_delay  =3D dev->xdev->caps.local_ca_ack_delay;
>> +	props->atomic_cap	   =3D is_support_rdma_atomic(dev->xdev) ?
>> +		IB_ATOMIC_HCA : IB_ATOMIC_NONE;
>> +	props->masked_atomic_cap   =3D IB_ATOMIC_HCA;
>> +	props->max_mcast_grp	   =3D
>> +		dev->xdev->caps.log_max_mcg ? (1 << dev->xdev->caps.log_max_mcg) : 0;
>> +	props->max_mcast_qp_attach =3D dev->xdev->caps.max_qp_mcg;
>> +	props->max_total_mcast_qp_attach =3D props->max_mcast_qp_attach *
>> +					   props->max_mcast_grp;
>> +
>> +	props->sys_image_guid =3D dev->xdev->board_info->guid;
>> +	props->vendor_id =3D dev->xdev->pdev->vendor;
>> +	props->vendor_part_id =3D dev->xdev->pdev->device;
>> +	props->hw_ver =3D ((dev->xdev->chip_ver_l & 0xffff) << 16) |
>> +		(dev->xdev->hotfix_num & 0xffff);
>> +	props->max_pkeys =3D XSC_IB_MAX_PKEYS;
>> +	props->max_wq_type_rq =3D dev->xdev->caps.max_qp;
>> +	props->hca_core_clock =3D dev->xdev->caps.hca_core_clock * 1000; /* KH=
z */
>> +	props->rss_caps.max_rwq_indirection_tables =3D
>> +		dev->xdev->caps.max_rwq_indirection_tables;
>> +	props->rss_caps.max_rwq_indirection_table_size =3D
>> +		dev->xdev->caps.max_rwq_indirection_table_size;
>> +	props->rss_caps.supported_qpts =3D 1 << IB_QPT_RAW_PACKET;
>> +
>> +	/*response tso_caps extend param*/
>> +	if (offsetofend(typeof(resp), tso_caps) <=3D udata_outlen) {
>> +		max_tso =3D dev->xdev->caps.log_max_tso ? (1 << dev->xdev->caps.log_m=
ax_tso) : 0;
>> +		if (max_tso) {
>> +			resp.tso_caps.max_tso =3D max_tso;
>> +			resp.tso_caps.supported_qpts |=3D 1 << IB_QPT_RAW_PACKET;
>> +			resp.response_length +=3D sizeof(resp.tso_caps);
>> +		}
>> +	}
>> +
>> +	/*response rss_caps extend param*/
>> +	if (offsetofend(typeof(resp), rss_caps) <=3D udata_outlen) {
>> +		resp.rss_caps.rx_hash_function =3D XSC_RX_HASH_FUNC_TOEPLITZ;
>> +		resp.rss_caps.rx_hash_fields_mask =3D
>> +			XSC_RX_HASH_SRC_IPV4 |
>> +			XSC_RX_HASH_DST_IPV4 |
>> +			XSC_RX_HASH_SRC_IPV6 |
>> +			XSC_RX_HASH_DST_IPV6 |
>> +			XSC_RX_HASH_SRC_PORT_TCP |
>> +			XSC_RX_HASH_DST_PORT_TCP |
>> +			XSC_RX_HASH_SRC_PORT_UDP |
>> +			XSC_RX_HASH_DST_PORT_UDP |
>> +			XSC_RX_HASH_INNER;
>> +		resp.response_length +=3D sizeof(resp.rss_caps);
>> +	}
>> +
>> +	/*response packet pacing caps*/
>> +	if (offsetofend(typeof(resp), packet_pacing_caps) <=3D udata_outlen) {
>> +		resp.packet_pacing_caps.qp_rate_limit_max =3D
>> +			dev->xdev->caps.qp_rate_limit_max;
>> +		resp.packet_pacing_caps.qp_rate_limit_min =3D
>> +			dev->xdev->caps.qp_rate_limit_min;
>> +		resp.packet_pacing_caps.supported_qpts |=3D 1 << IB_QPT_RAW_PACKET;
>> +
>> +		resp.response_length +=3D sizeof(resp.packet_pacing_caps);
>> +	}
>> +
>> +	/*copy response data to user*/
>> +	if (udata_outlen) {
>> +		err =3D ib_copy_to_udata(udata, &resp, resp.response_length);
>> +		if (err) {
>> +			ibdev_err(&dev->ib_dev, "copy response info to udata fail,err=3D%d\n=
", err);
>> +			return err;
>> +		}
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static void xsc_calc_link_info(struct xsc_core_device *xdev,
>> +			       struct ib_port_attr *props)
>> +{
>> +	switch (xsc_get_link_speed(xdev)) {
>> +	case MODULE_SPEED_10G:
>> +		props->active_speed =3D XSC_RDMA_LINK_SPEED_10GB;
>> +		props->active_width =3D 1;
>> +		break;
>> +	case MODULE_SPEED_25G:
>> +		props->active_speed =3D XSC_RDMA_LINK_SPEED_25GB;
>> +		props->active_width =3D 1;
>> +		break;
>> +	case MODULE_SPEED_40G_R4:
>> +		props->active_speed =3D XSC_RDMA_LINK_SPEED_10GB;
>> +		props->active_width =3D 2;
>> +		break;
>> +	case MODULE_SPEED_50G_R:
>> +		props->active_speed =3D XSC_RDMA_LINK_SPEED_50GB;
>> +		props->active_width =3D 1;
>> +		break;
>> +	case MODULE_SPEED_50G_R2:
>> +		props->active_speed =3D XSC_RDMA_LINK_SPEED_50GB;
>> +		props->active_width =3D 1;
>> +		break;
>> +	case MODULE_SPEED_100G_R2:
>> +		props->active_speed =3D XSC_RDMA_LINK_SPEED_25GB;
>> +		props->active_width =3D 2;
>> +		break;
>> +	case MODULE_SPEED_100G_R4:
>> +		props->active_speed =3D XSC_RDMA_LINK_SPEED_25GB;
>> +		props->active_width =3D 2;
>> +		break;
>> +	case MODULE_SPEED_200G_R4:
>> +		props->active_speed =3D XSC_RDMA_LINK_SPEED_50GB;
>> +		props->active_width =3D 2;
>> +		break;
>> +	case MODULE_SPEED_200G_R8:
>> +		props->active_speed =3D XSC_RDMA_LINK_SPEED_25GB;
>> +		props->active_width =3D 4;
>> +		break;
>> +	case MODULE_SPEED_400G_R8:
>> +		props->active_speed =3D XSC_RDMA_LINK_SPEED_50GB;
>> +		props->active_width =3D 4;
>> +		break;
>> +	case MODULE_SPEED_400G_R4:
>> +		props->active_speed =3D XSC_RDMA_LINK_SPEED_100GB;
>> +		props->active_width =3D 2;
>> +		break;
>> +	default:
>> +		props->active_speed =3D XSC_RDMA_LINK_SPEED_25GB;
>> +		props->active_width =3D 1;
>> +		break;
>> +	}
>> +}
>> +
>> +static enum rdma_link_layer xsc_ib_port_link_layer(struct ib_device *ib=
dev, u32 port)
>> +{
>> +	return IB_LINK_LAYER_ETHERNET;
>> +}
>> +
>> +int xsc_ib_query_port(struct ib_device *ibdev, u32 port,
>> +		      struct ib_port_attr *props)
>> +{
>> +	struct xsc_ib_dev *dev =3D to_xdev(ibdev);
>> +	struct net_device *ndev =3D dev->netdev;
>> +	struct xsc_core_device *xdev =3D dev->xdev;
>> +
>> +	if (port < 1 || port > xdev->caps.num_ports) {
>> +		ibdev_warn(&dev->ib_dev, "invalid port number %d\n", port);
>> +		return -EINVAL;
>> +	}
>> +
>> +	memset(props, 0, sizeof(*props));
>> +
>> +	if (netif_running(ndev) && netif_carrier_ok(ndev))
>> +		props->state =3D IB_PORT_ACTIVE;
>> +	else
>> +		props->state =3D IB_PORT_DOWN;
> You can use ib_get_curr_port_state() instead of open-coding.
Fixed.
>> +
>> +	props->max_mtu =3D is_support_8k_mtu(xdev) ? IB_MTU_8192 : IB_MTU_4096=
;
>> +	props->active_mtu =3D min(props->max_mtu, xsc_net_to_ib_mtu(ndev->mtu)=
);
> Similarly, use iboe_get_mtu().
Fixed.
>> +	props->gid_tbl_len =3D XSC_IB_GID_TBL_LEN;
>> +	props->port_cap_flags =3D IB_PORT_CM_SUP | IB_PORT_OTHER_LOCAL_CHANGES=
_SUP;
>> +	props->max_msg_sz =3D SZ_1G;
>> +	props->bad_pkey_cntr =3D 0;
>> +	props->qkey_viol_cntr =3D 0;
>> +	props->pkey_tbl_len =3D 1;
>> +	props->lid =3D 0;
>> +	props->sm_lid =3D 0;
>> +	props->lmc =3D 0;
>> +	props->max_vl_num =3D 0;
>> +	props->sm_sl =3D 0;
>> +	props->subnet_timeout =3D 0;
>> +	props->init_type_reply =3D 0;
>> +	if (!is_support_rdma(xdev)) {
>> +		props->active_width =3D 1;
>> +		props->active_speed =3D XSC_RDMA_LINK_SPEED_25GB;
>> +	} else {
>> +		xsc_calc_link_info(xdev, props);
>> +	}
>> +
>> +	props->phys_state =3D netif_carrier_ok(ndev) ? XSC_RDMA_PHY_STATE_LINK=
_UP :
>> +				XSC_RDMA_PHY_STATE_DISABLED;
>> +	return 0;
>> +}
>> +
>> +static int xsc_ib_query_pkey(struct ib_device *ibdev, u32 port, u16 ind=
ex,
>> +			     u16 *pkey)
>> +{
>> +	*pkey =3D 0xffff;
>> +	return 0;
>> +}
>> +
>> +int xsc_ib_alloc_ucontext(struct ib_ucontext *uctx,
>> +			  struct ib_udata *udata)
>> +{
>> +	struct ib_device *ibdev =3D uctx->device;
>> +	struct xsc_ib_dev *dev =3D to_xdev(ibdev);
>> +	struct xsc_ib_alloc_ucontext_req req;
>> +	struct xsc_ib_alloc_ucontext_resp resp;
>> +	int err;
>> +
>> +	if (!dev->ib_active)
>> +		return -EAGAIN;
>> +
>> +	err =3D ib_copy_from_udata(&req, udata, sizeof(req));
>> +	if (err)
>> +		return err;
>> +
>> +	memset(&resp, 0, sizeof(resp));
>> +	resp.qp_tab_size      =3D dev->xdev->caps.max_qp;
>> +	resp.cache_line_size  =3D L1_CACHE_BYTES;
>> +	resp.max_sq_desc_sz =3D dev->xdev->caps.max_sq_desc_sz;
>> +	resp.max_rq_desc_sz =3D dev->xdev->caps.max_rq_desc_sz;
>> +	resp.max_send_wqebb =3D dev->xdev->caps.max_wqes;
>> +	resp.max_recv_wr =3D dev->xdev->caps.max_wqes;
>> +	xsc_get_db_addr(dev->xdev, &resp.qpm_tx_db, &resp.qpm_rx_db,
>> +			&resp.cqm_armdb, &resp.cqm_next_cid_reg, NULL);
>> +	resp.send_ds_num =3D dev->xdev->caps.send_ds_num;
>> +	resp.recv_ds_num =3D dev->xdev->caps.recv_ds_num;
>> +	resp.cmds_supp_uhw |=3D XSC_USER_CMDS_SUPP_UHW_QUERY_DEVICE;
>> +	resp.device_id =3D dev->xdev->pdev->device;
>> +
>> +	if (req.abi_ver >=3D ALLOC_UCONTEXT_VER_V1) {
>> +		xsc_get_multidb_info(dev->xdev, &resp.multidb_num, &resp.tx_multidb_b=
ase);
>> +		resp.rdma_proto_mode =3D dev->xdev->rdma_proto_mode;
>> +	}
>> +
>> +	if (is_support_cqe64(dev->xdev))
>> +		resp.hw_feature_flag |=3D XSC_HW_FEATURE_FLAG_SUPPORT_CQE64;
>> +
>> +	resp.num_ports =3D dev->xdev->caps.num_ports;
>> +
>> +	return ib_copy_to_udata(udata, &resp, min_t(int, udata->outlen, sizeof=
(resp)));
>> +}
>> +
>> +void xsc_ib_dealloc_ucontext(struct ib_ucontext *ibcontext)
>> +{
>> +}
>> +
>> +static int xsc_ib_mmap(struct ib_ucontext *ibcontext, struct vm_area_st=
ruct *vma)
>> +{
>> +	struct xsc_ib_dev *dev =3D to_xdev(ibcontext->device);
>> +	struct xsc_core_device *xdev =3D dev->xdev;
>> +	unsigned long offset =3D vma->vm_pgoff << PAGE_SHIFT;
>> +	resource_size_t reg_base;
>> +	resource_size_t reg_size =3D vma->vm_end - vma->vm_start;
>> +	u64 tx_db =3D 0;
>> +	u64 rx_db =3D 0;
>> +	u64 cq_db =3D 0;
>> +	u64 cq_reg =3D 0;
>> +
>> +	xsc_get_db_addr(xdev, &tx_db, &rx_db, &cq_db, &cq_reg, NULL);
>> +	dev_dbg(&xdev->pdev->dev, "offset:0x%lx\n", offset);
>> +
>> +	if (offset =3D=3D (tx_db & PAGE_MASK))
>> +		reg_base =3D pci_resource_start(xdev->pdev, xdev->bar_num) + (tx_db &=
 PAGE_MASK);
>> +	else if (offset =3D=3D (rx_db & PAGE_MASK))
>> +		reg_base =3D pci_resource_start(xdev->pdev, xdev->bar_num) + (rx_db &=
 PAGE_MASK);
>> +	else if (offset =3D=3D (cq_reg & PAGE_MASK))
>> +		reg_base =3D pci_resource_start(xdev->pdev, xdev->bar_num) + (cq_reg =
& PAGE_MASK);
>> +	else if (offset =3D=3D (cq_db & PAGE_MASK))
>> +		reg_base =3D pci_resource_start(xdev->pdev, xdev->bar_num) + (cq_db &=
 PAGE_MASK);
>> +	else if (offset =3D=3D (QPM_TX_MDB_BASE_REG_ADDR & PAGE_MASK))
>> +		reg_base =3D pci_resource_start(xdev->pdev, xdev->bar_num) +
>> +			(QPM_TX_MDB_BASE_REG_ADDR & PAGE_MASK);
>> +	else if (offset =3D=3D (xdev->caps.mdb_base & PAGE_MASK))
>> +		reg_base =3D pci_resource_start(xdev->pdev, xdev->bar_num) +
>> +			(xdev->caps.mdb_base & PAGE_MASK);
>> +	else
>> +		return -EINVAL;
>> +
>> +	dev_dbg(&xdev->pdev->dev, "regbase:0x%llx", reg_base);
>> +
>> +	reg_base =3D (xsc_core_is_pf(xdev) && !is_pf_bar_compressed(xdev)) ?
>> +		reg_base - 0xA0000000 : reg_base;
>> +
>> +	vma->vm_page_prot =3D pgprot_noncached(vma->vm_page_prot);
>> +	return remap_pfn_range(vma, vma->vm_start, reg_base >> PAGE_SHIFT,
>> +			       reg_size, vma->vm_page_prot);
>> +}
>> +
>> +static int xsc_port_immutable(struct ib_device *ibdev, u32 port_num,
>> +			      struct ib_port_immutable *immutable)
>> +{
>> +	struct ib_port_attr attr;
>> +	int err;
>> +
>> +	err =3D ib_query_port(ibdev, port_num, &attr);
>> +	if (err)
>> +		return err;
>> +
>> +	immutable->pkey_tbl_len =3D attr.pkey_tbl_len;
>> +	immutable->gid_tbl_len =3D attr.gid_tbl_len;
>> +	immutable->core_cap_flags =3D RDMA_CORE_PORT_IBA_ROCE |
>> +				    RDMA_CORE_PORT_IBA_ROCE_UDP_ENCAP;
>> +	immutable->max_mad_size =3D IB_MGMT_MAD_SIZE * 2;
>> +
>> +	return 0;
>> +}
>> +
>> +static struct net_device *xsc_get_netdev(struct ib_device *ibdev, u32 p=
ort_num)
> You should use ib_device_set_netdev() instead of implementing this op.
Fixed.
>> +{
>> +	struct xsc_ib_dev *xsc_ib_dev =3D to_xdev(ibdev);
>> +	struct net_device *dev =3D xsc_ib_dev->netdev;
>> +
>> +	if (dev)
>> +		dev_hold(dev);
>> +
>> +	return dev;
>> +}
>> +
>> +static void xsc_get_guid(const u8 *dev_addr, u8 *guid)
>> +{
>> +	u8 mac[ETH_ALEN];
>> +
>> +	/* MAC-48 to EUI-64 mapping */
>> +	memcpy(mac, dev_addr, ETH_ALEN);
>> +	guid[0] =3D mac[0] ^ 2;
>> +	guid[1] =3D mac[1];
>> +	guid[2] =3D mac[2];
>> +	guid[3] =3D 0xff;
>> +	guid[4] =3D 0xfe;
>> +	guid[5] =3D mac[3];
>> +	guid[6] =3D mac[4];
>> +	guid[7] =3D mac[5];
>> +}
>> +
>> +static void init_node_data(struct xsc_ib_dev *dev)
>> +{
>> +	strscpy(dev->ib_dev.node_desc, "xsc_node_desc",
>> +		sizeof(dev->ib_dev.node_desc));
>> +	xsc_get_guid(dev->netdev->dev_addr, (u8 *)&dev->ib_dev.node_guid);
>> +}
>> +
>> +static void xsc_ib_event(struct xsc_core_device *dev, void *context,
>> +			 enum xsc_dev_event event, unsigned long data)
>> +{
>> +	struct xsc_ib_dev *ibdev =3D (struct xsc_ib_dev *)context;
>> +	struct ib_event ibev;
>> +	u8 port =3D 0;
>> +
>> +	switch (event) {
>> +	case XSC_DEV_EVENT_SYS_ERROR:
>> +		ibdev->ib_active =3D false;
>> +		ibev.event =3D IB_EVENT_DEVICE_FATAL;
>> +		break;
>> +
>> +	case XSC_DEV_EVENT_PORT_UP:
>> +		ibev.event =3D IB_EVENT_PORT_ACTIVE;
>> +		port =3D *(u8 *)data;
>> +		break;
>> +
>> +	case XSC_DEV_EVENT_PORT_DOWN:
>> +		ibev.event =3D IB_EVENT_PORT_ERR;
>> +		port =3D *(u8 *)data;
>> +		break;
>> +
>> +	case XSC_DEV_EVENT_PORT_INITIALIZED:
>> +		/* not used by ULPs */
>> +		return;
>> +
>> +	case XSC_DEV_EVENT_LID_CHANGE:
>> +		ibev.event =3D IB_EVENT_LID_CHANGE;
>> +		port =3D *(u8 *)data;
>> +		break;
>> +
>> +	case XSC_DEV_EVENT_PKEY_CHANGE:
>> +		ibev.event =3D IB_EVENT_PKEY_CHANGE;
>> +		port =3D *(u8 *)data;
>> +		break;
>> +
>> +	case XSC_DEV_EVENT_GUID_CHANGE:
>> +		ibev.event =3D IB_EVENT_GID_CHANGE;
>> +		port =3D *(u8 *)data;
>> +		break;
>> +
>> +	case XSC_DEV_EVENT_CLIENT_REREG:
>> +		ibev.event =3D IB_EVENT_CLIENT_REREGISTER;
>> +		port =3D *(u8 *)data;
>> +		break;
>> +	}
>> +
>> +	ibev.device	      =3D &ibdev->ib_dev;
>> +	ibev.element.port_num =3D port;
>> +
>> +	if (ibdev->ib_active)
>> +		ib_dispatch_event(&ibev);
>> +}
>> +
>> +static void xsc_ib_get_dev_fw_str(struct ib_device *ibdev, char *str)
>> +{
>> +	struct xsc_core_device *dev =3D to_xdev(ibdev)->xdev;
>> +	u8 ver_major =3D dev->fw_version_major;
>> +	u8 ver_minor =3D dev->fw_version_minor;
>> +	u16 ver_patch =3D dev->fw_version_patch;
>> +	u32 ver_tweak =3D dev->fw_version_tweak;
>> +
>> +	if (ver_tweak =3D=3D 0) {
>> +		snprintf(str, IB_FW_VERSION_NAME_MAX, "v%u.%u.%u",
>> +			 ver_major,  ver_minor, ver_patch);
>> +	} else {
>> +		snprintf(str, IB_FW_VERSION_NAME_MAX, "v%u.%u.%u+%u",
>> +			 ver_major, ver_minor, ver_patch, ver_tweak);
>> +	}
>> +}
>> +
>> +static void xsc_ib_disassociate_ucontext(struct ib_ucontext *ibcontext)
>> +{
>> +}
>> +
>> +static void xsc_ib_dev_setting(struct xsc_ib_dev *dev)
>> +{
>> +	dev->ib_dev.ops.owner		=3D THIS_MODULE;
>> +	dev->ib_dev.ops.uverbs_abi_ver	=3D XSC_IB_UVERBS_ABI_VERSION;
>> +	dev->ib_dev.ops.driver_id =3D RDMA_DRIVER_XSC;
>> +	dev->ib_dev.ops.disassociate_ucontext =3D xsc_ib_disassociate_ucontext=
;
>> +	dev->ib_dev.ops.query_device	=3D xsc_ib_query_device;
>> +	dev->ib_dev.ops.query_port	=3D xsc_ib_query_port;
>> +	dev->ib_dev.ops.query_pkey	=3D xsc_ib_query_pkey;
>> +
>> +	dev->ib_dev.ops.alloc_ucontext	=3D xsc_ib_alloc_ucontext;
>> +	dev->ib_dev.ops.dealloc_ucontext =3D xsc_ib_dealloc_ucontext;
>> +	dev->ib_dev.ops.mmap		=3D xsc_ib_mmap;
>> +
>> +
>> +	dev->ib_dev.ops.get_link_layer	=3D xsc_ib_port_link_layer;
>> +	dev->ib_dev.ops.get_netdev		=3D xsc_get_netdev;
>> +
>> +
>> +	dev->ib_dev.ops.get_port_immutable		=3D xsc_port_immutable;
>> +
>> +	dev->ib_dev.ops.get_dev_fw_str	=3D xsc_ib_get_dev_fw_str;
>> +
>> +	dev->ib_dev.ops INIT_RDMA_OBJ_SIZE(ib_ucontext, xsc_ib_ucontext, ibuco=
ntext);
>> +}
>> +
>> +static void xsc_get_port_state(struct net_device *ndev, enum xsc_dev_ev=
ent *ev)
>> +{
>> +	*ev =3D XSC_DEV_EVENT_PORT_DOWN;
>> +	if (netif_running(ndev) && netif_carrier_ok(ndev))
>> +		*ev =3D XSC_DEV_EVENT_PORT_UP;
>> +}
>> +
>> +static int xsc_netdev_event(struct notifier_block *this, unsigned long =
event, void *ptr)
>> +{
>> +	struct xsc_ib_dev *ibdev =3D container_of(this, struct xsc_ib_dev, nb)=
;
>> +	struct net_device *ndev =3D netdev_notifier_info_to_dev(ptr);
>> +	enum xsc_dev_event ev;
>> +	u8 port =3D 1;
>> +
>> +	if (ndev !=3D ibdev->netdev)
>> +		goto done;
>> +
>> +	ibdev_dbg(&ibdev->ib_dev, "netdev notfiy event:%ld\n", event);
>> +	switch (event) {
>> +	case NETDEV_CHANGE:
>> +	case NETDEV_UP:
>> +	case NETDEV_DOWN:
>> +		xsc_get_port_state(ibdev->netdev, &ev);
>> +		xsc_ib_event(ibdev->xdev, ibdev, ev, (unsigned long)&port);
>> +		break;
>> +	default:
>> +		break;
>> +	}
>> +done:
>> +	return NOTIFY_DONE;
>> +}
>> +
>> +static int xsc_register_netdev_notifier(struct xsc_ib_dev *ibdev)
>> +{
>> +	ibdev->nb.notifier_call =3D xsc_netdev_event;
>> +	return register_netdevice_notifier(&ibdev->nb);
> ib_netdevice_event() already handles these events. You can also implement
> .report_port_event() if needed. Anyhow you probably don't need this
> notifier in driver.
>
>> +}
>> +
>> +static int xsc_unregister_netdev_notifier(struct xsc_ib_dev *ibdev)
>> +{
>> +	return unregister_netdevice_notifier(&ibdev->nb);
>> +}
>> +
>> +static int init_one(struct xsc_core_device *xdev,
>> +		    struct xsc_ib_dev **ibdev)
>> +{
>> +	struct xsc_ib_dev *dev;
>> +	int err;
>> +
>> +	dev =3D (struct xsc_ib_dev *)ib_alloc_device(xsc_ib_dev, ib_dev);
>> +	if (!dev)
>> +		return -ENOMEM;
>> +
>> +	dev->xdev =3D xdev;
>> +	dev->netdev =3D xdev->netdev;
>> +	strscpy(dev->ib_dev.name, "xscale_%d", IB_DEVICE_NAME_MAX);
>> +
>> +	memcpy(dev->xdev->priv.ibdev_name, dev->ib_dev.name, IB_DEVICE_NAME_MA=
X);
>> +
>> +	if (!xdev->caps.msix_enable)
>> +		dev->num_comp_vectors =3D 1;
>> +	else
>> +		dev->num_comp_vectors =3D xdev->dev_res->eq_table.num_comp_vectors;
>> +
>> +	dev->ib_dev.node_type		=3D RDMA_NODE_IB_CA;
>> +	dev->ib_dev.local_dma_lkey	=3D 0xFF;
>> +	dev->num_ports		=3D xdev->caps.num_ports;
>> +	dev->ib_dev.phys_port_cnt     =3D dev->num_ports;
>> +	dev->ib_dev.num_comp_vectors	=3D dev->num_comp_vectors;
>> +	dev->ib_dev.dev.parent =3D &xdev->pdev->dev;
>> +	xsc_ib_dev_setting(dev);
>> +	dev->xdev->priv.cm_dscp =3D DSCP_PCP_UNSET;
>> +	dev->xdev->priv.cm_pcp =3D DSCP_PCP_UNSET;
>> +	dev->xdev->priv.force_pcp =3D DSCP_PCP_UNSET;
>> +	dev->xdev->priv.force_dscp =3D DSCP_PCP_UNSET;
>> +	dev->xdev->rdma_proto_mode =3D RDMA_PROTO_ROCEV2;
>> +	dev->xdev->cm_udp_dst_port =3D ROCE_V2_UDP_DPORT;
>> +	dev->xdev->veroce_udp_dst_port =3D VEROCE_UDP_DPORT;
>> +
>> +	dev->ib_dev.uverbs_cmd_mask	=3D
>> +		(1ull << IB_USER_VERBS_CMD_GET_CONTEXT)		|
>> +		(1ull << IB_USER_VERBS_CMD_QUERY_DEVICE)	|
>> +		(1ull << IB_USER_VERBS_CMD_QUERY_PORT)		|
>> +		(1ull << IB_USER_VERBS_CMD_ALLOC_PD)		|
>> +		(1ull << IB_USER_VERBS_CMD_DEALLOC_PD)		|
>> +		(1ull << IB_USER_VERBS_CMD_CREATE_AH)		|
>> +		(1ull << IB_USER_VERBS_CMD_DESTROY_AH)		|
>> +		(1ull << IB_USER_VERBS_CMD_REG_MR)		|
>> +		(1ull << IB_USER_VERBS_CMD_REREG_MR)		|
>> +		(1ull << IB_USER_VERBS_CMD_DEREG_MR)		|
>> +		(1ull << IB_USER_VERBS_CMD_CREATE_COMP_CHANNEL)	|
>> +		(1ull << IB_USER_VERBS_CMD_CREATE_CQ)		|
>> +		(1ull << IB_USER_VERBS_CMD_RESIZE_CQ)		|
>> +		(1ull << IB_USER_VERBS_CMD_DESTROY_CQ)		|
>> +		(1ull << IB_USER_VERBS_CMD_CREATE_QP)		|
>> +		(1ull << IB_USER_VERBS_CMD_MODIFY_QP)		|
>> +		(1ull << IB_USER_VERBS_CMD_QUERY_QP)		|
>> +		(1ull << IB_USER_VERBS_CMD_DESTROY_QP)		|
>> +		(1ull << IB_USER_VERBS_CMD_ATTACH_MCAST)	|
>> +		(1ull << IB_USER_VERBS_CMD_DETACH_MCAST)	|
>> +		(1ull << IB_USER_VERBS_CMD_CREATE_SRQ)		|
>> +		(1ull << IB_USER_VERBS_CMD_MODIFY_SRQ)		|
>> +		(1ull << IB_USER_VERBS_CMD_QUERY_SRQ)		|
>> +		(1ull << IB_USER_VERBS_CMD_DESTROY_SRQ)		|
>> +		(1ull << IB_USER_VERBS_CMD_OPEN_QP);
>> +
>> +	init_node_data(dev);
>> +
>> +
>> +
>> +
> Too many blank lines.
Fixed.
>> +	err =3D ib_register_device(&dev->ib_dev, dev->ib_dev.name,
>> +				 dev->xdev->device);
>> +	if (err)
>> +		goto err_free;
>> +
>> +	rdma_roce_rescan_device(&dev->ib_dev);
> This is already called in
> ib_register_device =E2=86=92 ib_cache_setup_one =E2=86=92 gid_table_setup=
_one
Fixed.
>> +	dev->ib_active =3D true;
>> +	*ibdev =3D dev;
>> +
>> +	xsc_register_netdev_notifier(dev);
>> +
>> +
>> +
> Too many blank lines.
>
>> +	return 0;
>> +
>> +err_free:
>> +	ib_dealloc_device((struct ib_device *)dev);
>> +
>> +	return err;
>> +}
>> +
>> diff --git a/drivers/infiniband/hw/xsc/xsc_ib.h b/drivers/infiniband/hw/=
xsc/xsc_ib.h
>> new file mode 100644
>> index 000000000..a2ae382e2
>> --- /dev/null
>> +++ b/drivers/infiniband/hw/xsc/xsc_ib.h
>> @@ -0,0 +1,542 @@
>> +static inline void *xsc_ib_iova_to_virt(struct ib_device *ibdev, dma_ad=
dr_t iova)
>> +{
>> +	phys_addr_t phyaddr;
>> +	struct iommu_domain *domain;
>> +
>> +	domain =3D iommu_get_domain_for_dev(ibdev->dma_device);
>> +	if (likely(domain)) {
>> +		phyaddr =3D iommu_iova_to_phys(domain, iova);
>> +		phyaddr |=3D iova & (PAGE_SIZE - 1);
>> +	} else {
>> +		phyaddr =3D dma_to_phys(ibdev->dma_device, iova);
>> +	}
>> +
>> +	return phys_to_virt(phyaddr);
>> +}
>> +
>> +struct ib_mad_list_head {
> Why are these ib_mad structures defined again in the driver's header?
>
> Junxian
They were a workaround for historical hardware issues and are no longer

needed. They have been removed in v1.

Thanks,
Xin Tian

>
>> +	struct list_head list;
>> +	struct ib_cqe cqe;
>> +	struct ib_mad_queue *mad_queue;
>> +};
>> +
>> +#define IB_MAD_SEND_REQ_MAX_SG 2
>> +struct ib_mad_send_wr_private {
>> +	struct ib_mad_list_head mad_list;
>> +	struct list_head agent_list;
>> +	struct ib_mad_agent_private *mad_agent_priv;
>> +	struct ib_mad_send_buf send_buf;
>> +	u64 header_mapping;
>> +	u64 payload_mapping;
>> +	struct ib_ud_wr send_wr;
>> +	struct ib_sge sg_list[IB_MAD_SEND_REQ_MAX_SG];
>> +	__be64 tid;
>> +	unsigned long timeout;
>> +	int max_retries;
>> +	int retries_left;
>> +	int retry;
>> +	int refcount;
>> +	enum ib_wc_status status;
>> +
>> +	/* RMPP control */
>> +	struct list_head rmpp_list;
>> +	struct ib_rmpp_segment *last_ack_seg;
>> +	struct ib_rmpp_segment *cur_seg;
>> +	int last_ack;
>> +	int seg_num;
>> +	int newwin;
>> +	int pad;
>> +};
>> +
>> +struct ib_mad_private_header {
>> +	struct ib_mad_list_head mad_list;
>> +	struct ib_mad_recv_wc recv_wc;
>> +	struct ib_wc wc;
>> +	u64 mapping;
>> +} __packed;
>> +
>> +struct ib_mad_private {
>> +	struct ib_mad_private_header header;
>> +	size_t mad_size;
>> +	struct ib_grh grh;
>> +	DECLARE_FLEX_ARRAY(u8, mad);
>> +} __packed;
>> +
>> +static inline void *xsc_ib_send_mad_sg_virt_addr(struct ib_device *ibde=
v,
>> +						 const struct ib_send_wr *wr,
>> +						 int sg)
>> +{
>> +	struct ib_mad_send_wr_private *mad_send_wr;
>> +	struct ib_mad_list_head *mad_list;
>> +	int iommu_state =3D xsc_ib_iommu_dma_map(ibdev);
>> +
>> +	/* direct dma mapping */
>> +	if (!iommu_state)
>> +		return phys_to_virt(dma_to_phys(ibdev->dma_device, wr->sg_list[sg].ad=
dr));
>> +
>> +	if (iommu_state =3D=3D XSC_IB_IOMMU_MAP_NORMAL)
>> +		return xsc_ib_iova_to_virt(ibdev, wr->sg_list[sg].addr);
>> +
>> +	mad_list =3D container_of(wr->wr_cqe, struct ib_mad_list_head, cqe);
>> +	mad_send_wr =3D container_of(mad_list, struct ib_mad_send_wr_private,
>> +				   mad_list);
>> +
>> +	/* sg_list[0] */
>> +	if (sg =3D=3D 0)
>> +		return mad_send_wr->send_buf.mad;
>> +
>> +	/* sg_list[1] */
>> +	if (mad_send_wr->send_buf.seg_count)
>> +		return ib_get_rmpp_segment(&mad_send_wr->send_buf,
>> +					   mad_send_wr->seg_num);
>> +	return mad_send_wr->send_buf.mad + mad_send_wr->send_buf.hdr_len;
>> +}
>> +
>> +static inline void *xsc_ib_recv_mad_sg_virt_addr(struct ib_device *ibde=
v,
>> +						 struct ib_wc *wc,
>> +						 u64 sg_addr)
>> +{
>> +	struct ib_mad_private_header *mad_priv_hdr;
>> +	struct ib_mad_private *recv;
>> +	struct ib_mad_list_head *mad_list;
>> +	int iommu_state =3D xsc_ib_iommu_dma_map(ibdev);
>> +
>> +	/* direct dma mapping */
>> +	if (!iommu_state)
>> +		return phys_to_virt(dma_to_phys(ibdev->dma_device, sg_addr));
>> +
>> +	if (iommu_state =3D=3D XSC_IB_IOMMU_MAP_NORMAL)
>> +		return xsc_ib_iova_to_virt(ibdev, sg_addr);
>> +
>> +	mad_list =3D container_of(wc->wr_cqe, struct ib_mad_list_head, cqe);
>> +	mad_priv_hdr =3D container_of(mad_list, struct ib_mad_private_header, =
mad_list);
>> +	recv =3D container_of(mad_priv_hdr, struct ib_mad_private, header);
>> +	return &recv->grh;
>> +}
>> +
>> +struct xsc_ib_burst_info {
>> +	__u32       max_burst_sz;
>> +	__u16       typical_pkt_sz;
>> +	__u16       reserved;
>> +};
>> +
>> +struct xsc_ib_modify_qp {
>> +	__u32		reserved;
>> +	struct xsc_ib_burst_info  burst_info;
>> +	__u32		profile;
>> +};
>> +
>> +#endif /* XSC_IB_H */
