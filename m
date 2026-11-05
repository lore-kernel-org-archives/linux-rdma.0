Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793894977;
	b=c3YH4t0FRmEBNbBIL5eCBdjAWv3sXfJt0HgoxB6mbQiHA/FSuSr5kYFsguAT8q15PCgK
	 u7CxHglj9T4f18/yW5pVY0Pi4ZpbuBYPOHFH7QpXeup5isyhlrIvuQO1BvajR83YpVtJ0
	 +I3rYcRsUhIP4P4B9uqMkhuqLMW7CfIE0bc+ObeAxif98+2bt2+jev+r9fxtyKT55mP6E
	 3bNiGsCC1oAo7vpDFf75OojKbcHhW4wM3VbMEnAH4LyUl2zz8mfyekyLaFb2RqFL0X2YO
	 XWLeM5pOrBUMXr9pSJd6Ku4W8EVgvL7bEhdP9yqOi6WdgFU23gB3Wf6KtoodMvEM16g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793894977;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=p0p/kMQtxWHIdobTfXqaIG/NreTEzmyv1HqE3/Zcd5c=;
	b=1cG107iVG/tkuRu9lTQx1+htZv8Bc0VQC1ClNs02Ffc+f767YHa0fPh9NMZVL6IXpWQ0
	 8X6WSOmxjjEyTS+qRds8y5MhX/G1mXkC4nq708R+AanjDeqBY/8RhZ3d8tY5ueHPYTx4P
	 aKvipVON9ktqSQtE22W07hvismV7jro60H1qZFAwa+0Tb3LQ1i+oL0Lb7k8MQLGX/XoQ4
	 IMzEXiHgVSkgnQyyxhxssBFRaCnYzeORLMEluLZIVZR/l1FdstdsrWlNIUX+R9bEHE/w7
	 xVNOYOEX0Tsmy+VlNm/yntMf6zorBRNOVctjxs7b7pcB8JWXmu0D5wXnZDWo5xr0v2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YTMCiFQO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8609D606BE9A
	for <linux-rdma@vger.kernel.org>; Thu,  5 Nov 2026 16:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YTMCiFQO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 208E51F00919;
	Thu,  5 Nov 2026 16:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793894976;
	bh=p0p/kMQtxWHIdobTfXqaIG/NreTEzmyv1HqE3/Zcd5c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YTMCiFQOEcFOB02kjHak4r5nZHtfRTWvphOa6SR56fRGbdrjPtbi9OycAZaCAx2K5
	 t8LXFoWBvt1EcM10ebZX0ROMjlO2GYUOhK/qZ94HpM1Knbw4AOdUpgCjfL2dLLvOlI
	 hNseUWlO5tto5P6cjhMqKFGDqPLw2oBMjzOXGMsNAFwwuvLcV6CzZUX8zp7Js5R5rV
	 X+SjT+ZDYR9RXap2NfsqnOk6cEV3B1kiZ7FptUlOG3bWCXTJqPzRhnquyu/yR7mto/
	 38HCqTYRr/OCsJpZgNyJYzhBuis+HkfZF711K533WvThVRy8sAUpHn8xnlUBjJTsD+
	 qnvecGvbRoGBw==
Message-ID: <sashiko-outbox-199432@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 10/15] RDMA/xsc: add RDMA device support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xin Tian" <tianx@yunsilicon.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261104155712.37053-11-tianx@yunsilicon.com>
References: <20261104155650.37053-1-tianx@yunsilicon.com>
 <20261104155712.37053-11-tianx@yunsilicon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 16:09:35 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 10 potential issue=
(s) to consider:
- [Critical] RDMA/xsc: xsc_ib_mmap() exposes privileged BAR0 command queue =
registers
- [High] RDMA/xsc: unsynchronized netdev attachment and missing NETDEV_UNRE=
GISTER
- [High] RDMA/xsc: xsc_ib_query_device() miscalculates resp.response_length
- [High] RDMA/xsc: IOVA page offset corruption and identity domain misclass=
ification
- [Medium] RDMA/xsc: xsc_ib_query_port() leaves max_mtu as 0 and misencodes=
 link info
- [Medium] RDMA/xsc: init_one() sets ib_active after ib_register_device() a=
nd copies unexpanded name
- [Medium] RDMA/xsc: wrong masked_atomic_cap and 32-bit shifts in xsc_ib_qu=
ery_device()
- [Medium] RDMA/xsc: implicit padding, raw int types, and unvalidated udata=
 in UAPI
- [Low] RDMA/xsc: missing select AUXILIARY_BUS in Kconfig
- [Low] RDMA/xsc: endianness warning in xsc_get_link_speed() and helper dup=
lication
--

commit 78a9c302585dd86ed70444386c757ac8476b121c
Author: Xin Tian <tianx@yunsilicon.com>

RDMA/xsc: add RDMA device support

This commit introduces the xsc_ib auxiliary RDMA driver, registering an
ib_device backed by the shared xsc core device and netdev, and exposes the
userspace ABI in include/uapi/rdma/xsc-abi.h.

> diff --git a/drivers/infiniband/hw/xsc/Kconfig b/drivers/infiniband/hw/xs=
c/Kconfig
> new file mode 100644
> index 0000000000000..5cf46df2d4f12
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

[Severity: Low]
Since xsc_ib_init() and xsc_ib_cleanup() call auxiliary_driver_register()
and auxiliary_driver_unregister(), and neither YUNSILICON_XSC_PCI nor
YUNSILICON_XSC_ETH selects AUXILIARY_BUS, can building with
CONFIG_INFINIBAND_XSC fail at link/modpost time with undefined references
to __auxiliary_driver_register and auxiliary_driver_unregister when no
other enabled driver selects CONFIG_AUXILIARY_BUS? Should INFINIBAND_XSC
(or YUNSILICON_XSC_PCI) select AUXILIARY_BUS?

> diff --git a/drivers/infiniband/hw/xsc/main.c b/drivers/infiniband/hw/xsc=
/main.c
> new file mode 100644
> index 0000000000000..322fad38b5df2
> --- /dev/null
> +++ b/drivers/infiniband/hw/xsc/main.c

[ ... ]

> +static int xsc_ib_query_device(struct ib_device *ibdev,
> +			       struct ib_device_attr *props,
> +			       struct ib_udata *udata)
> +{

[ ... ]

> +	props->max_cq		   =3D dev->xdev->caps.max_cq;
> +	props->max_cqe		   =3D dev->xdev->caps.max_cqes;
> +	props->max_mr		   =3D (1 << dev->xdev->caps.log_max_mkey) - 1;
> +	props->max_pd		   =3D dev->xdev->caps.max_pd;
> +	props->max_qp_rd_atom	   =3D dev->xdev->caps.max_ra_res_qp;
> +	props->max_qp_init_rd_atom =3D dev->xdev->caps.max_ra_req_qp;
> +	props->max_res_rd_atom	   =3D props->max_qp_rd_atom * props->max_qp;
> +	props->max_srq		   =3D
> +		dev->xdev->caps.log_max_srq ? (1 << dev->xdev->caps.log_max_srq) : 0;
> +	props->max_srq_wr	   =3D dev->xdev->caps.max_srq_wqes - 1;
> +	props->max_srq_sge	   =3D dev->xdev->caps.log_max_srq ? (max_rq_sg - 1)=
 : 0;
> +	props->local_ca_ack_delay  =3D dev->xdev->caps.local_ca_ack_delay;
> +	props->atomic_cap	   =3D is_support_rdma_atomic(dev->xdev) ?
> +		IB_ATOMIC_HCA : IB_ATOMIC_NONE;
> +	props->masked_atomic_cap   =3D IB_ATOMIC_HCA;

[Severity: Medium]
In xsc_ib_query_device(), props->atomic_cap is gated on
is_support_rdma_atomic(dev->xdev), but props->masked_atomic_cap is
unconditionally set to IB_ATOMIC_HCA. Does this advertise masked atomic
support on hardware where RDMA atomics are not supported?

Also, in the shifts for props->max_mr =3D (1 << dev->xdev->caps.log_max_mke=
y) - 1
and max_tso =3D dev->xdev->caps.log_max_tso ? (1 << dev->xdev->caps.log_max=
_tso) : 0
below, can the 32-bit signed literal 1 overflow if log_max_mkey or
log_max_tso is >=3D 31, instead of using BIT_ULL()?

[ ... ]

> +	if (offsetofend(typeof(resp), tso_caps) <=3D udata_outlen) {
> +		max_tso =3D dev->xdev->caps.log_max_tso ? (1 << dev->xdev->caps.log_ma=
x_tso) : 0;
> +		if (max_tso) {
> +			resp.tso_caps.max_tso =3D max_tso;
> +			resp.tso_caps.supported_qpts |=3D 1 << IB_QPT_RAW_PACKET;
> +			resp.response_length +=3D sizeof(resp.tso_caps);
> +		}
> +	}
> +
> +	if (offsetofend(typeof(resp), rss_caps) <=3D udata_outlen) {
> +		resp.rss_caps.rx_hash_function =3D XSC_RX_HASH_FUNC_TOEPLITZ;
> +		resp.rss_caps.rx_hash_fields_mask =3D
> +			XSC_RX_HASH_SRC_IPV4 |
> +			XSC_RX_HASH_DST_IPV4 |
> +			XSC_RX_HASH_SRC_IPV6 |
> +			XSC_RX_HASH_DST_IPV6 |
> +			XSC_RX_HASH_SRC_PORT_TCP |
> +			XSC_RX_HASH_DST_PORT_TCP |
> +			XSC_RX_HASH_SRC_PORT_UDP |
> +			XSC_RX_HASH_DST_PORT_UDP |
> +			XSC_RX_HASH_INNER;
> +		resp.response_length +=3D sizeof(resp.rss_caps);
> +	}
> +
> +	if (offsetofend(typeof(resp), packet_pacing_caps) <=3D udata_outlen) {
> +		resp.packet_pacing_caps.qp_rate_limit_max =3D
> +			dev->xdev->caps.qp_rate_limit_max;
> +		resp.packet_pacing_caps.qp_rate_limit_min =3D
> +			dev->xdev->caps.qp_rate_limit_min;
> +		resp.packet_pacing_caps.supported_qpts |=3D 1 << IB_QPT_RAW_PACKET;
> +
> +		resp.response_length +=3D sizeof(resp.packet_pacing_caps);
> +	}
> +
> +	if (udata_outlen) {
> +		err =3D ib_copy_to_udata(udata, &resp, resp.response_length);

[Severity: High]
Does xsc_ib_query_device() miscalculate resp.response_length and truncate
the response copied to userspace?

In struct xsc_ib_query_device_resp:

include/uapi/rdma/xsc-abi.h:
    struct xsc_ib_query_device_resp {
        __u32   comp_mask;
        __u32   response_length;
        struct  xsc_ib_tso_caps tso_caps;
        struct  xsc_ib_rss_caps rss_caps;
        struct  xsc_ib_cqe_comp_caps cqe_comp_caps;
        struct  xsc_packet_pacing_caps packet_pacing_caps;
        ...
    };

First, when dev->xdev->caps.log_max_tso is 0, sizeof(resp.tso_caps) is not
added to resp.response_length, even though rss_caps and packet_pacing_caps
sit at fixed offsets after tso_caps.

Second, cqe_comp_caps sits between rss_caps and packet_pacing_caps, but
sizeof(resp.cqe_comp_caps) is never added to resp.response_length.

When udata_outlen is large enough to include packet_pacing_caps (56 bytes),
resp.response_length only reaches 48 (or 40 when max_tso is 0), so
ib_copy_to_udata(udata, &resp, resp.response_length) fails to copy the full
packet_pacing_caps (and truncates rss_caps when max_tso is 0). Should each
block set resp.response_length =3D offsetofend(typeof(resp), <field>) inste=
ad
of incrementing it by sizeof()?

[ ... ]

> +static void xsc_calc_link_info(struct xsc_core_device *xdev,
> +			       struct ib_port_attr *props)
> +{
> +	switch (xsc_get_link_speed(xdev)) {
> +	case XSC_MODULE_SPEED_10G:
> +		props->active_speed =3D XSC_RDMA_LINK_SPEED_10GB;
> +		props->active_width =3D 1;
> +		break;
> +	case XSC_MODULE_SPEED_25G:
> +		props->active_speed =3D XSC_RDMA_LINK_SPEED_25GB;
> +		props->active_width =3D 1;
> +		break;
> +	case XSC_MODULE_SPEED_40G_R4:
> +		props->active_speed =3D XSC_RDMA_LINK_SPEED_10GB;
> +		props->active_width =3D 2;
> +		break;
> +	case XSC_MODULE_SPEED_50G_R:
> +		props->active_speed =3D XSC_RDMA_LINK_SPEED_50GB;
> +		props->active_width =3D 1;
> +		break;
> +	case XSC_MODULE_SPEED_50G_R2:
> +		props->active_speed =3D XSC_RDMA_LINK_SPEED_50GB;
> +		props->active_width =3D 1;
> +		break;
> +	case XSC_MODULE_SPEED_100G_R2:
> +		props->active_speed =3D XSC_RDMA_LINK_SPEED_25GB;
> +		props->active_width =3D 2;
> +		break;

[ ... ]

> +int xsc_ib_query_port(struct ib_device *ibdev, u32 port,
> +		      struct ib_port_attr *props)
> +{
> +	struct xsc_ib_dev *dev =3D to_xdev(ibdev);
> +	struct xsc_core_device *xdev =3D dev->xdev;
> +	struct net_device *ndev;
> +
> +	if (port < 1 || port > xdev->caps.num_ports) {
> +		ibdev_warn(&dev->ib_dev, "invalid port number %d\n", port);
> +		return -EINVAL;
> +	}
> +
> +	ndev =3D ib_device_get_netdev(ibdev, port);
> +	if (!ndev)
> +		return -ENODEV;
> +
> +	memset(props, 0, sizeof(*props));
> +
> +	props->state =3D ib_get_curr_port_state(ndev);
> +
> +	props->active_mtu =3D iboe_get_mtu(ndev->mtu);
> +	props->gid_tbl_len =3D XSC_IB_GID_TBL_LEN;

[Severity: Medium]
In xsc_ib_query_port(), props is zeroed with memset() and props->active_mtu
is populated, but props->max_mtu is never set. Doesn't leaving
props->max_mtu as 0 cause ib_mtu_enum_to_int(props->max_mtu) to return -1
and break callers and ULPs that validate path_mtu <=3D max_mtu?

Additionally, in xsc_calc_link_info() and xsc_ib_query_port(), why are
driver-private UAPI enums (XSC_RDMA_LINK_SPEED_*, XSC_RDMA_PHY_STATE_*) and
raw width numbers used instead of the standard enum ib_port_speed, enum
ib_port_width, and enum ib_port_phys_state constants? In particular, for
XSC_MODULE_SPEED_50G_R2 (2x25G) it sets speed 50G with width 1 (1x50G), and
for XSC_MODULE_SPEED_100G_R2 (2x50G) it sets speed 25G with width 2
(IB_WIDTH_4X, i.e., 4x25G instead of IB_WIDTH_2X =3D 16 with 50G).

[ ... ]

> +int xsc_ib_alloc_ucontext(struct ib_ucontext *uctx,
> +			  struct ib_udata *udata)
> +{
> +	struct ib_device *ibdev =3D uctx->device;
> +	struct xsc_ib_dev *dev =3D to_xdev(ibdev);
> +	struct xsc_ib_alloc_ucontext_req req =3D {};
> +	struct xsc_ib_alloc_ucontext_resp resp;
> +	int err;
> +
> +	if (!dev->ib_active)
> +		return -EAGAIN;
> +
> +	err =3D ib_copy_from_udata(&req, udata, min(udata->inlen, sizeof(req)));
> +	if (err)
> +		return err;

[ ... ]

> +static int xsc_ib_mmap(struct ib_ucontext *ibcontext, struct vm_area_str=
uct *vma)
> +{
> +	struct xsc_ib_dev *dev =3D to_xdev(ibcontext->device);
> +	struct xsc_core_device *xdev =3D dev->xdev;
> +	unsigned long offset =3D vma->vm_pgoff << PAGE_SHIFT;
> +	resource_size_t reg_base;
> +	resource_size_t reg_size =3D PAGE_SIZE;
> +	resource_size_t bar_end;
> +	bool db_arm =3D false;
> +	u64 addr;
> +	u64 tx_db =3D 0;
> +	u64 rx_db =3D 0;
> +	u64 cq_db =3D 0;
> +	u64 cq_reg =3D 0;
> +
> +	xsc_get_db_addr(xdev, &tx_db, &rx_db, &cq_db, &cq_reg, NULL);
> +	dev_dbg(&xdev->pdev->dev, "offset:0x%lx\n", offset);
> +
> +	if (offset =3D=3D (tx_db & PAGE_MASK)) {
> +		addr =3D tx_db;
> +		db_arm =3D true;
> +	} else if (offset =3D=3D (rx_db & PAGE_MASK)) {
> +		addr =3D rx_db;
> +		db_arm =3D true;
> +	} else if (offset =3D=3D (cq_reg & PAGE_MASK)) {
> +		addr =3D cq_reg;
> +		db_arm =3D true;
> +	} else if (offset =3D=3D (cq_db & PAGE_MASK)) {
> +		addr =3D cq_db;
> +		db_arm =3D true;
> +	} else if (offset =3D=3D (QPM_TX_MDB_BASE_REG_ADDR & PAGE_MASK)) {
> +		addr =3D QPM_TX_MDB_BASE_REG_ADDR;
> +	} else {
> +		return -EINVAL;
> +	}
> +
> +	/*
> +	 * On an uncompressed PF the doorbell addresses are hardware
> +	 * addresses (BAR offset + 0xa0000000 window base); the mdb values
> +	 * are BAR offsets already.
> +	 */
> +	if (db_arm && xsc_core_is_pf(xdev) && !is_pf_bar_compressed(xdev))
> +		addr -=3D 0xA0000000;
> +
> +	reg_base =3D pci_resource_start(xdev->pdev, xdev->bar_num) + (addr & PA=
GE_MASK);
> +	bar_end =3D pci_resource_start(xdev->pdev, xdev->bar_num) +
> +		  pci_resource_len(xdev->pdev, xdev->bar_num);
> +	dev_dbg(&xdev->pdev->dev, "regbase:0x%llx", reg_base);
> +
> +	if (vma->vm_end - vma->vm_start !=3D reg_size)
> +		return -EINVAL;
> +
> +	if (reg_base + reg_size > bar_end)
> +		return -EINVAL;
> +
> +	return rdma_user_mmap_io(ibcontext, vma, reg_base >> PAGE_SHIFT,
> +				 reg_size, pgprot_noncached(vma->vm_page_prot),
> +				 NULL);
> +}

[Severity: Critical]
Does xsc_ib_mmap() expose the privileged BAR0 firmware command queue
registers to unprivileged userspace?

In drivers/net/ethernet/yunsilicon/xsc/common/xsc_reg.h, the firmware
command queue registers and EQ doorbell sit in the first 4KB page of the
BAR alongside the compressed doorbells and QPM_TX_MDB_BASE_REG_ADDR:

    #define CMDQM_HOST_REQ_BUF_BASE_H_ADDR_MEM_ADDR 0x0
    #define CMDQM_HOST_REQ_BUF_BASE_L_ADDR_MEM_ADDR 0x4
    #define CMDQM_HOST_REQ_PID_MEM_ADDR 0x8
    #define CMDQM_HOST_REQ_CID_MEM_ADDR 0xc
    #define CMDQM_HOST_RSP_BUF_BASE_H_ADDR_MEM_ADDR 0x10
    #define CMDQM_HOST_RSP_BUF_BASE_L_ADDR_MEM_ADDR 0x14
    #define CMDQM_HOST_RSP_PID_MEM_ADDR 0x18
    #define CMDQM_HOST_RSP_CID_MEM_ADDR 0x1c
    #define CMDQM_HOST_VF_ERR_STS_MEM_ADDR 0x20
    #define CMDQM_VECTOR_ID_MEM_ADDR 0x24
    ...
    #define DB_CQ_FUNC_MEM_ADDR 0x8c4
    #define DB_EQ_FUNC_MEM_ADDR 0x8c8
    #define DB_CQ_CID_DIRECT_MEM_ADDR 0x8cc
    #define TX_DB_FUNC_MEM_ADDR 0x8d0
    #define RX_DB_FUNC_MEM_ADDR 0x8d4
    ...
    #define QPM_TX_MDB_BASE_REG_ADDR 0xd00

Because xsc_ib_mmap() accepts offset =3D=3D (QPM_TX_MDB_BASE_REG_ADDR & PAG=
E_MASK)
(which is 0x0 on all functions, without even checking
is_support_multi_doorbell(xdev)), and on compressed-BAR PFs and VFs tx_db,
rx_db, cq_db, and cq_reg are also at 0x8c4..0x8d4, any unprivileged user
with access to /dev/infiniband/uverbsX can mmap BAR offset 0 writable via
rdma_user_mmap_io() and overwrite the command queue DMA ring base physical
addresses and producer/consumer indices.

Also, in xsc_ib_mmap(), computing offset =3D vma->vm_pgoff << PAGE_SHIFT
truncates the upper PAGE_SHIFT bits of vma->vm_pgoff.

[ ... ]

> +static void init_iommu_state(struct xsc_ib_dev *dev, struct device *dma_=
dev)
> +{
> +	struct iommu_domain *domain;
> +
> +	dev->iommu_state =3D XSC_IB_IOMMU_MAP_DISABLE;
> +	domain =3D iommu_get_domain_for_dev(dma_dev);
> +	if (domain) {
> +		if (domain->type & __IOMMU_DOMAIN_DMA_API)
> +			dev->iommu_state =3D XSC_IB_IOMMU_MAP_NORMAL;
> +		else
> +			dev->iommu_state =3D XSC_IB_IOMMU_MAP_UNKNOWN_DOMAIN;
> +	} else {

[Severity: High]
In init_iommu_state(), when the system runs with IOMMU passthrough enabled
(such as iommu.passthrough=3D1 or iommu=3Dpt), iommu_get_domain_for_dev()
returns an identity domain whose type is IOMMU_DOMAIN_IDENTITY
(__IOMMU_DOMAIN_PT), which does not have __IOMMU_DOMAIN_DMA_API set. Doesn't
this misclassify identity-mapped devices as XSC_IB_IOMMU_MAP_UNKNOWN_DOMAIN
instead of treating them as direct-mapped?

[ ... ]

> +static int init_one(struct xsc_core_device *xdev,
> +		    struct xsc_ib_dev **ibdev)
> +{
> +	struct xsc_ib_dev *dev;
> +	int err;
> +
> +	dev =3D (struct xsc_ib_dev *)ib_alloc_device(xsc_ib_dev, ib_dev);
> +	if (!dev)
> +		return -ENOMEM;
> +
> +	dev->xdev =3D xdev;
> +	strscpy(dev->ib_dev.name, "xscale_%d", IB_DEVICE_NAME_MAX);
> +
> +	memcpy(dev->xdev->priv.ibdev_name, dev->ib_dev.name, IB_DEVICE_NAME_MAX=
);
> +
> +	dev->num_comp_vectors =3D xdev->dev_res->eq_table.num_comp_vectors;
> +
> +	dev->ib_dev.node_type		=3D RDMA_NODE_IB_CA;
> +	dev->ib_dev.local_dma_lkey	=3D 0xFF;
> +	dev->num_ports		=3D xdev->caps.num_ports;
> +	dev->ib_dev.phys_port_cnt     =3D dev->num_ports;
> +	dev->ib_dev.num_comp_vectors	=3D dev->num_comp_vectors;
> +	dev->ib_dev.dev.parent =3D &xdev->pdev->dev;
> +	err =3D ib_device_set_netdev(&dev->ib_dev, xdev->netdev, 1);
> +	if (err)
> +		goto err_free;

[Severity: High]
How is the lifetime of xdev->netdev synchronized between the ethernet driver
and xsc_ib?

First, in init_one(), ib_device_set_netdev(&dev->ib_dev, xdev->netdev, 1)
is called before init_node_data(dev) checks whether dev->xdev->netdev is
NULL to return -EPROBE_DEFER. If xdev->netdev is NULL when
ib_device_set_netdev() runs and xsc_eth_probe() assigns xdev->netdev before
init_node_data() runs, ib_device_set_netdev() binds NULL while
init_node_data() succeeds, causing ib_register_device() ->
xsc_port_immutable() -> ib_query_port() -> xsc_ib_query_port() to fail probe
with -ENODEV instead of deferring.

Second, in xsc_eth_remove():

drivers/net/ethernet/yunsilicon/xsc/net/main.c:xsc_eth_remove() {
    ...
    unregister_netdev(adapter->netdev);
    ...
    free_netdev(adapter->netdev);

    xdev->netdev =3D NULL;
    ...
}

Because ib_device_set_netdev() takes a netdev_hold() reference on
xdev->netdev and xsc_ib never registers a netdevice notifier to clear the
netdev on NETDEV_UNREGISTER, won't unbinding xsc_pci.eth or unloading
xsc_eth while xsc_ib is loaded hang indefinitely in unregister_netdev()
waiting for xsc_ib's reference to be released? And if xsc_ib_probe() runs
concurrently with xsc_eth_remove(), can init_one() and init_node_data()
access an unregistering or already-freed net_device before xdev->netdev is
set to NULL?

> +
> +	xsc_ib_dev_setting(dev);

[ ... ]

> +	err =3D init_node_data(dev);
> +	if (err)
> +		goto err_free;
> +
> +	init_iommu_state(dev, xdev->device);
> +	err =3D ib_register_device(&dev->ib_dev, dev->ib_dev.name,
> +				 dev->xdev->device);
> +	if (err)
> +		goto err_free;
> +
> +	rdma_roce_rescan_device(&dev->ib_dev);
> +	dev->ib_active =3D true;
> +	*ibdev =3D dev;

[Severity: Medium]
In init_one(), dev->ib_active =3D true is set only after ib_register_device=
()
and a redundant rdma_roce_rescan_device() have already completed. Since
ib_register_device() exposes the uverbs device to userspace and sends device
addition events before returning, can a userspace process open the device
immediately and hit:

drivers/infiniband/hw/xsc/main.c:xsc_ib_alloc_ucontext() {
    if (!dev->ib_active)
        return -EAGAIN;
}

Also, earlier in init_one(), memcpy(dev->xdev->priv.ibdev_name,
dev->ib_dev.name, IB_DEVICE_NAME_MAX) runs before ib_register_device()
expands the format string, leaving the literal "xscale_%d" in
dev->xdev->priv.ibdev_name instead of the assigned device name.

> diff --git a/drivers/infiniband/hw/xsc/xsc_ib.h b/drivers/infiniband/hw/x=
sc/xsc_ib.h
> new file mode 100644
> index 0000000000000..b91d4aa371bcf
> --- /dev/null
> +++ b/drivers/infiniband/hw/xsc/xsc_ib.h

[ ... ]

> +#define IB_MTU_8192	6
> +
> +static inline enum ib_mtu xsc_net_to_ib_mtu(unsigned int mtu)
> +{
> +	mtu =3D mtu - (IB_GRH_BYTES + IB_UDP_BYTES + IB_BTH_BYTES +
> +		     IB_EXT_XRC_BYTES + IB_EXT_ATOMICETH_BYTES +
> +		     IB_ICRC_BYTES);
> +	if (mtu >=3D 8192)
> +		return IB_MTU_8192;
> +	else if (mtu >=3D ib_mtu_enum_to_int(IB_MTU_4096))
> +		return IB_MTU_4096;
> +	else if (mtu >=3D ib_mtu_enum_to_int(IB_MTU_1024))
> +		return IB_MTU_1024;
> +	else
> +		return 0;
> +}

[Severity: Medium]
In xsc_net_to_ib_mtu(), mtu is an unsigned int, so if mtu is less than the
96-byte header overhead, won't the subtraction underflow to a huge unsigned
value and return IB_MTU_8192 (which is also outside enum ib_mtu)?

> +
> +#define XSC_IB_IOMMU_MAP_DISABLE 0
> +#define XSC_IB_IOMMU_MAP_UNKNOWN_DOMAIN 1
> +#define XSC_IB_IOMMU_MAP_NORMAL 2
> +
> +static inline int xsc_ib_iommu_dma_map(struct ib_device *ibdev)
> +{
> +	return to_xdev(ibdev)->iommu_state;
> +}
> +
> +static inline void *xsc_ib_iova_to_virt(struct ib_device *ibdev, dma_add=
r_t iova)
> +{
> +	phys_addr_t phyaddr;
> +	struct iommu_domain *domain;
> +
> +	domain =3D iommu_get_domain_for_dev(ibdev->dma_device);
> +	if (likely(domain)) {
> +		phyaddr =3D iommu_iova_to_phys(domain, iova);
> +		phyaddr |=3D iova & (PAGE_SIZE - 1);
> +	} else {
> +		phyaddr =3D dma_to_phys(ibdev->dma_device, iova);
> +	}
> +
> +	return phys_to_virt(phyaddr);
> +}

[Severity: High]
In xsc_ib_iova_to_virt(), iommu_iova_to_phys(domain, iova) already preserves
the sub-granule offset in the returned physical address. On architectures
where the CPU PAGE_SIZE is larger than the IOMMU page granule (for example,
64KB CPU pages with a 4KB IOMMU granule), IOVA bits between the IOMMU page
shift and CPU PAGE_SHIFT do not match the physical page offset. Doesn't
ORing iova & (PAGE_SIZE - 1) into phyaddr corrupt those physical address
bits before calling phys_to_virt()? Also, what happens if
iommu_iova_to_phys() returns 0 on an unmapped IOVA?

> diff --git a/drivers/net/ethernet/yunsilicon/xsc/common/driver.h b/driver=
s/net/ethernet/yunsilicon/xsc/common/driver.h
> new file mode 100644
> index 0000000000000..362099a7c0918
> --- /dev/null
> +++ b/drivers/net/ethernet/yunsilicon/xsc/common/driver.h

[ ... ]

> +static inline void *xsc_vzalloc(unsigned long size)
> +{
> +	void *rtn;
> +
> +	rtn =3D kzalloc(size, GFP_KERNEL | __GFP_NOWARN);
> +	if (!rtn)
> +		rtn =3D vzalloc(size);
> +	return rtn;
> +}
> +
> +static inline void xsc_vfree(const void *addr)
> +{
> +	if (addr && is_vmalloc_addr(addr))
> +		vfree(addr);
> +	else
> +		kfree(addr);
> +}

[Severity: Low]
This isn't a bug, but xsc_vzalloc() and xsc_vfree() duplicate the standard
kvzalloc() and kvfree() helpers. Similarly, in drivers/infiniband/hw/xsc/ma=
in.c,
xsc_get_guid() duplicates addrconf_addr_eui48(), xsc_ib_dev_setting() sets
dev->ib_dev.ops fields individually instead of using a static const struct
ib_device_ops with ib_set_device_ops(), xsc_ib_init()/xsc_ib_cleanup() can
use module_auxiliary_driver(), and dev_dbg() in xsc_ib_mmap() prints
resource_size_t reg_base with 0x%llx instead of %pa.

> diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/link.c b/drivers/net=
/ethernet/yunsilicon/xsc/pci/link.c
> new file mode 100644
> index 0000000000000..272ddc3a29b10
> --- /dev/null
> +++ b/drivers/net/ethernet/yunsilicon/xsc/pci/link.c
> @@ -0,0 +1,34 @@

[ ... ]

> +int xsc_get_link_speed(struct xsc_core_device *xdev)
> +{
> +	struct xsc_event_query_linkinfo_mbox_out out;
> +	struct xsc_event_linkinfo linkinfo;
> +	struct xsc_inbox_hdr in;
> +	int err;
> +
> +	memset(&in, 0, sizeof(in));
> +	memset(&out, 0, sizeof(out));
> +	in.opcode =3D cpu_to_be16(XSC_CMD_OP_QUERY_LINK_INFO);
> +
> +	err =3D xsc_cmd_exec(xdev, &in, sizeof(in), &out, sizeof(out));
> +	if (err) {
> +		pci_err(xdev->pdev, "failed to get link info, err=3D%d\n", err);
> +		return XSC_MODULE_SPEED_25G;
> +	}
> +
> +	linkinfo =3D out.ctx;
> +	linkinfo.linkspeed =3D be32_to_cpu(linkinfo.linkspeed);
> +
> +	return linkinfo.linkspeed;
> +}

[Severity: Low]
In struct xsc_event_linkinfo, linkspeed is declared as __be32. Doesn't
assigning be32_to_cpu(linkinfo.linkspeed) back to linkinfo.linkspeed trigger
a sparse endianness warning instead of returning
be32_to_cpu(out.ctx.linkspeed) directly?

> diff --git a/include/uapi/rdma/xsc-abi.h b/include/uapi/rdma/xsc-abi.h
> new file mode 100644
> index 0000000000000..7e19b23a3842b
> --- /dev/null
> +++ b/include/uapi/rdma/xsc-abi.h

[ ... ]

> +struct xsc_ib_alloc_ucontext_req {
> +	__u32	abi_ver;
> +	__u32	rsvd1;
> +};

[ ... ]

> +struct xsc_ib_create_qp {
> +	__u64	buf_addr;
> +	__u64	db_addr;
> +	__u32	sq_wqe_count;
> +	__u32	rq_wqe_count;
> +	__u32	rq_wqe_shift;
> +	__u32	flags;
> +
> +	int	dmabuf_fd;
> +	__aligned_u64	dmabuf_sz;
> +};

[ ... ]

> +struct xsc_ib_create_cq {
> +	__u64 buf_addr;
> +	__u64 db_addr;
> +	__u32	cqe_size;
> +
> +	int	dmabuf_fd;
> +	__aligned_u64	dmabuf_sz;
> +};

[ ... ]

> +struct xsc_ib_alloc_pd_resp {
> +	__u32	pdn;
> +};

[Severity: Medium]
In include/uapi/rdma/xsc-abi.h, struct xsc_ib_create_qp has an unnamed
4-byte compiler padding hole between int dmabuf_fd and __aligned_u64
dmabuf_sz, both struct xsc_ib_create_qp and struct xsc_ib_create_cq use raw
int instead of __s32 for dmabuf_fd and __u64 instead of __aligned_u64 for
the 64-bit fields, and struct xsc_ib_alloc_pd_resp is not padded to an
8-byte boundary with a trailing __u32 reserved field.

Also, in xsc_ib_alloc_ucontext(), should req.rsvd1 and any trailing bytes
beyond sizeof(req) in udata be checked for zero (e.g., via
ib_is_udata_cleared()) so future ABI extensions can rely on them?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104155650.3705=
3-1-tianx@yunsilicon.com?part=3D10
