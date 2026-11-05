Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793894972;
	b=0rSDqenH3E9Wh1ssSMh00k4l6pd12DTfaW5a7TVsKqgtgF5lB0fYbtvM8e24Bnxfk6/q
	 oqlZCBJb+WdCFLqpV+LeWwuRuCIYIi4H+mzvd6YnwYXl037eiiujvZiquP/FhWlo4YxWy
	 YpwxItjiGvPkHbgzqxt/NgsVClH9OmNwlZkblFhZsHCXnnZlqyEse+L8ycIg+OrYwoO1X
	 CZCIAN7ENRkITSX6CyVSU2mj1L+l15bVeF8gEFZQsmKx8KSmkef4UxIxffdxbSVg2QQ4c
	 AtqbGGObB6tVgQQNlYCLbsv3/NrhQRvrJTxoGZ+ChF4536iPgQY3cC/TcKP/TKhvNxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793894972;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=F0O/mB7LUTINU8mpEE84jH6X2UtymK/XqADkZjftN5o=;
	b=NWugVdViebT2nofIcNkP3lOri8U1ieDIh2SH3T4PemFVSTE12FW49GfTjkTkJFs3DKKH
	 G7Du4MM0Or0bQm1vTWj4yzjD3wdPdPz7we5uTeClhw2cHPumKlGIsB6XaNPd09HN9tyyD
	 MVzOUPn9gkwkeMS0XHW1JjK6SZhPz/kVtMBl6fjONz16h4vGvEB9iXFnP180Ico0hLu9v
	 Anz5Fp7VpqGOCVYyLYvkxqC/JEQmkOPkKeYwjWPBY1Yt7w4Pt1Vhdt9K7nKhEOQiXmBsj
	 F65u42sDEvpSeTOaS30TnPqU1hhsk4oQQTGBDSX17nuDNPa05L5tXjONdIhZ22qHYzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aZN8bmEq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7819C606A33A
	for <linux-rdma@vger.kernel.org>; Thu,  5 Nov 2026 16:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aZN8bmEq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C22DD1F000C1;
	Thu,  5 Nov 2026 16:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793894972;
	bh=F0O/mB7LUTINU8mpEE84jH6X2UtymK/XqADkZjftN5o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aZN8bmEqZll30lQjsMfqljZEnsW6/D+4TaSXNB3ielz9WZebC5iYJD2LWTHQ/OtHS
	 UIfeZ9pg2LyG8kvCDhdbWCHSnhP4zmT4G6IvS8vil513Kh8ZHEoKJ3nWTQhw4OjF21
	 8kNn8qeGH29IDB/Bz74K0pzwbvG0TH8Os5cYcacoYZoXZkj8YVNe/3OyKuSWDt1A47
	 pPrvFkb0Ot+hTtp0HVEhNxpCEqHO8wIMxGN71dFqMR0bgcue+DRBECz1SOCgBABG82
	 riZDPc0He81xCYJKGe03Zx7C2w+ip0f85XGunbG+bEjIp4wj02Uw14wyB9CyDK4hIh
	 Rnqm90EZu3t9w==
Message-ID: <sashiko-outbox-199425@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 03/15] net/xsc: add the register HAL
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xin Tian" <tianx@yunsilicon.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261104155655.37053-4-tianx@yunsilicon.com>
References: <20261104155650.37053-1-tianx@yunsilicon.com>
 <20261104155655.37053-4-tianx@yunsilicon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 16:09:31 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] net/xsc: duplicate declarations, dead definitions, and missing type=
s.h in HAL
--

commit 2bedc4243c5f325b253b8d3867197c1b8085594e
Author: Xin Tian <tianx@yunsilicon.com>

net/xsc: add the register HAL

This commit adds the hardware abstraction layer for translating logical
register accesses into BAR-relative MMIO for the Andes chip generation. It
implements doorbell encodings, command-queue register accessors, and WQE/CQE
and MR helper functions.

> diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/hal/andes_impl.c b/d=
rivers/net/ethernet/yunsilicon/xsc/pci/hal/andes_impl.c
> new file mode 100644
> index 0000000000000..69f0daae5abe6
> --- /dev/null
> +++ b/drivers/net/ethernet/yunsilicon/xsc/pci/hal/andes_impl.c
> @@ -0,0 +1,629 @@

[ ... ]

> +static void andes_ring_tx_doorbell(struct xsc_core_device *xdev,
> +				   struct xsc_hw_reg *regs,
> +				   void __iomem *bar, u32 sqn, u32 next_pid,
> +				   bool mdb)
> +{
> +	u32 db =3D FIELD_PREP(XSC_ANDES_TX_DB_DATA0_NEXT_PID_MASK, next_pid) |
> +		 FIELD_PREP(XSC_ANDES_TX_DB_DATA0_QP_ID_MASK, sqn);
> +	u32 db_reg =3D mdb ? QPM_TX_MDB_BASE_REG_ADDR + (sqn & (XSC_MDB_NUM - 1=
)) * sizeof(u32) :
> +		regs->tx_db;
> +
> +	/* Make sure that descriptors are written before
> +	 * updating doorbell record and ringing the doorbell
> +	 */
> +	wmb();
> +
> +	writel(db, REG_ADDR(bar, db_reg));
> +}

[ ... ]

> +static u8 andes_get_mr_page_mode(u8 page_shift)
> +{
> +enum {
> +	PAGE_SHIFT_4K	=3D 12,
> +	XSC_PAGE_SHIFT_64K	=3D 16,
> +	XSC_PAGE_SHIFT_2M	=3D 21,
> +	XSC_PAGE_SHIFT_1G	=3D 30,
> +};
> +
> +enum {
> +	XSC_PAGE_MODE_4K	=3D 0,
> +	XSC_PAGE_MODE_64K	=3D 1,
> +	XSC_PAGE_MODE_2M	=3D 2,
> +	XSC_PAGE_MODE_1G	=3D 3,
> +};
> +
> +	return (page_shift =3D=3D XSC_PAGE_SHIFT_4K ? XSC_PAGE_MODE_4K :
> +		(page_shift =3D=3D XSC_PAGE_SHIFT_64K ? XSC_PAGE_MODE_64K :
> +		(page_shift =3D=3D XSC_PAGE_SHIFT_2M ? XSC_PAGE_MODE_2M : XSC_PAGE_MOD=
E_1G)));
> +}

[ ... ]

> +struct andes_send_wqe_ctrl_seg {
> +	__le32		data0;
> +	__le32		msg_len;
> +	__le32		data2;
> +	__le32		data3;
> +};
> +
> +static void andes_set_wqe_id(void *cseg, u32 wqe_id)
> +{
> +	struct xsc_send_wqe_ctrl_seg *seg =3D cseg;
> +	u32 val =3D le32_to_cpu(seg->data0);
> +
> +	seg->data0 =3D cpu_to_le32((val & ~XSC_WQE_CTRL_SEG_DATA0_WQE_ID_MASK) |
> +				 FIELD_PREP(XSC_WQE_CTRL_SEG_DATA0_WQE_ID_MASK,
> +					    (u16)wqe_id));
> +}

[ ... ]

> diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/hal/xsc_hal.h b/driv=
ers/net/ethernet/yunsilicon/xsc/pci/hal/xsc_hal.h
> new file mode 100644
> index 0000000000000..f6292a91ba2fb
> --- /dev/null
> +++ b/drivers/net/ethernet/yunsilicon/xsc/pci/hal/xsc_hal.h
> @@ -0,0 +1,60 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright (C) 2024 - 2026, Shanghai Yunsilicon Technology Co., Ltd.
> + * All rights reserved.
> + */
> +
> +#ifndef XSC_HAL_H
> +#define XSC_HAL_H
> +
> +struct xsc_core_device;
> +
> +/* HAL entry points exported to the PCI/RDMA/ETH layers */
> +void xsc_init_hal(struct xsc_core_device *xdev);
> +void xsc_set_mtt_info(struct xsc_core_device *xdev);
> +void xsc_set_pf_db_addr(struct xsc_core_device *xdev,
> +			u64 tx_db, u64 rx_db, u64 cq_db, u64 cq_reg, u64 eq_db);
> +void xsc_get_db_addr(struct xsc_core_device *xdev,
> +		     u64 *tx_db, u64 *rx_db, u64 *cq_db, u64 *cq_reg, u64 *eq_db);
> +
> +void xsc_update_tx_db(struct xsc_core_device *xdev, u32 sqn, u32 next_pi=
d);
> +void xsc_update_rx_db(struct xsc_core_device *xdev, u32 rqn, u32 next_pi=
d);
> +void xsc_arm_cq(struct xsc_core_device *xdev, u32 cqn, u32 next_cid, u8 =
solicited);
> +void xsc_update_cq_ci(struct xsc_core_device *xdev, u32 cqn, u32 next_ci=
d);

[Severity: Low]
This isn't a bug, but there are a few unused definitions and duplicated
declarations across the new HAL files:

In drivers/net/ethernet/yunsilicon/xsc/pci/hal/xsc_hal.h, the prototypes use
u64, u32, u16, u8, and bool without including linux/types.h, and 19 of the
function declarations (such as xsc_init_hal(), xsc_set_mtt_info(),
xsc_set_pf_db_addr(), xsc_get_db_addr(), and the doorbell and WQE/CQE
helpers) duplicate prototypes that are already declared in
drivers/net/ethernet/yunsilicon/xsc/common/xsc_core.h:

drivers/net/ethernet/yunsilicon/xsc/common/xsc_core.h:
    void xsc_init_hal(struct xsc_core_device *xdev);

    u8 xsc_get_mr_page_mode(struct xsc_core_device *xdev, u8 page_shift);
    u64 xsc_get_max_mr_size(struct xsc_core_device *xdev);
    ...

In drivers/net/ethernet/yunsilicon/xsc/pci/hal/andes_impl.c:
- In andes_ring_tx_doorbell(), the xdev parameter is unused.
- In andes_get_mr_page_mode(), the local unindented enum defines
  PAGE_SHIFT_4K and XSC_PAGE_SHIFT_1G, neither of which is used because the
  return expression compares against XSC_PAGE_SHIFT_4K from
  common/xsc_core.h and defaults to XSC_PAGE_MODE_1G.
- struct andes_send_wqe_ctrl_seg is defined right above andes_set_wqe_id()
  but is never referenced because andes_set_wqe_id() casts cseg to
  struct xsc_send_wqe_ctrl_seg from common/xsc_core.h; similarly,
  struct andes_cqe and struct andes_data_seg duplicate struct xsc_cqe and
  struct xsc_wqe_data_seg in common/xsc_core.h.

Could these unused definitions be dropped and the header declarations
consolidated with common/xsc_core.h (and linux/types.h included in
xsc_hal.h)?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104155650.3705=
3-1-tianx@yunsilicon.com?part=3D3
