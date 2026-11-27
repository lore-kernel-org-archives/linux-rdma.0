Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795795072;
	b=qMsufbrqxGXcif4bMBgbXAVMHpHH0s4WwUAVSU0bD4fU86ZFFpeReZt6oa371aco46pa
	 PR9KUgO0sdUyl+39kcSVeXpTt8JYQMAXr2rDVutdlyY2KbZFeAkRnSJUEq8cBWqueaU0/
	 HAyiDuAxnIgepTHrti3KPsVAcWFQ/QnKUzWhlUSsYtntY4zQ5h3I5yi8Wqjqtwv/D1Li+
	 iTvMZ/Tt4rrdN3AOMgzirtBk9NGtaQaONvUnyHfCrXCvE8HhpSqRlhex1mHbLyy7nNaBW
	 oUpNmWzzQuj6KS2Vazt6qqUHAxkK6pqWlaXecxT1zTkXyFRqMlD98kw7VbsLqe0xxAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795795072;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=K6q75vYgcwJtpJbOOJpD4SrFC6bX8iiseg0lw4gxjSo=;
	b=ArqAeUYd/QVOmAwGaHQvKoJly+1/WRXpikWpk8HX6yUMNYGmXhbizy/vTcjS+vtwHVEj
	 WNgHyr3ax/qYFB6/3B6yxUxxZ1qjB95a4QIAiRXqIlUVUOIwUIHrvPQPwjncq/P7JIQwW
	 kuslubhZpa/Jk/RaT3H5htuhdqyUvOvHDp/DuJPUZmEEBbw0dXMwExSS7pYx4Imp1Vm4S
	 uDu4167dWV4O+Eb5RAwwSe3QQcdEHNzDOxfxGUVIxuhsZcrHoFe26jPxBpVPW24jiNCSt
	 F9/AhLVm/tRqcYdYbLXRMDjj8mpIS1GHFFlpPlbpnp/C7Hlc3AkpVHDE8c5j7RbI7ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LoIqQRyB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A56F606A31E;
	Fri, 27 Nov 2026 15:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LoIqQRyB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F20B71F0089A;
	Fri, 27 Nov 2026 15:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795795071;
	bh=K6q75vYgcwJtpJbOOJpD4SrFC6bX8iiseg0lw4gxjSo=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=LoIqQRyBfa698WOSTCA+56eK/O9LUgmZXzI5folrOq/M+JWs/mhjeaXFbjuP/JfwS
	 1Is3upfc9XGM70v5EIiGKpAyj5sCAy4eWnr2GKNHD7ytabwKYyrkEsv+xvae/+9pVl
	 BM4HEHkXiwd/T6R4K4aXceegIKYJ/4drcJfU04GvZzedNrai6zxzzi/XjvCO2r6fO1
	 nLUzeZFMaNLxOM/aFao8DqR/0gzmmvVOwAcy53e08SCWfQTtnk68wQjhFwhbrzktKs
	 tZV/vb15VruO7xtpHhoL8ZkPQI6d+REb8LOrCotvRS1qESY8wza2S9eDKNsGNv5Nh0
	 eoRjbjbGRO/UA==
Subject: Re: [PATCH v2 02/11] net/xsc: add doorbell and cmdq MMIO accessors
From: netdev-bot+sashiko@kernel.org
To: tianx@yunsilicon.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, jgg@ziepe.ca, leon@kernel.org,
 huangjunxian6@hisilicon.com, weihg@yunsilicon.com,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, kerneljasonxing@gmail.com
Date: Fri, 27 Nov 2026 15:57:50 +0000
Message-ID: <179579507051.3135.14726043842081189942@kernel.org>
In-Reply-To: <20261126145715.70868-3-tianx@yunsilicon.com>
References: <20261126145715.70868-3-tianx@yunsilicon.com>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 2

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] xsc_arm_cq(xdev, cqn, next_cid, u8 solicited) in
  drivers/net/ethernet/yunsilicon/xsc/pci/doorbell.c (lines 62-74) puts…
- [Low] All five doorbell writers in
  drivers/net/ethernet/yunsilicon/xsc/pci/doorbell.c call a full wmb()…
- [Low] The new file drivers/net/ethernet/yunsilicon/xsc/pci/doorbell.c
  calls EXPORT_SYMBOL_GPL() four times (xsc_update_tx_db,…

--

net/xsc: add doorbell and cmdq MMIO accessors

This commit adds doorbell writers for TX/RX queues, CQs and EQs, along
with cmdq register accessors. They all operate on fixed offsets in the
device BAR. The helpers are declared in xsc_core.h, and the TX, RX and
CQ helpers are exported for use by other modules.

> diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/doorbell.c b/drivers/net/ethernet/yunsilicon/xsc/pci/doorbell.c
> new file mode 100644
> index 0000000000000..5bd64be671646
> --- /dev/null
> +++ b/drivers/net/ethernet/yunsilicon/xsc/pci/doorbell.c
> @@ -0,0 +1,148 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (C) 2024 - 2026, Shanghai Yunsilicon Technology Co., Ltd.
> + * All rights reserved.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/pci.h>
> +
> +#include "common/xsc_core.h"
> +#include "common/xsc_reg.h"

[Severity: Low]
This isn't a bug, but should this file include <linux/export.h> directly?

It uses EXPORT_SYMBOL_GPL() for xsc_update_tx_db(), xsc_update_rx_db(),
xsc_arm_cq() and xsc_update_cq_ci(). With W=2, the
check_missing_include_linux_export_h check in scripts/misc-check reports
this for the file:

  EXPORT_SYMBOL() is used, but #include <linux/export.h> is missing

The file builds today only because export.h is pulled in indirectly.

[ ... ]

> +void xsc_update_tx_db(struct xsc_core_device *xdev, u32 sqn, u32 next_pid)
> +{
> +	u32 db = FIELD_PREP(XSC_TX_DB_DATA0_NEXT_PID_MASK, next_pid) |
> +		 FIELD_PREP(XSC_TX_DB_DATA0_QP_ID_MASK, sqn);
> +
> +	/* Make sure that descriptors are written before
> +	 * updating doorbell record and ringing the doorbell
> +	 */
> +	wmb();
> +
> +	writel(db, xdev->bar + TX_DB_FUNC_MEM_ADDR);
> +}

[Severity: Low]
Is the explicit wmb() needed before writel() here? writel() already
orders earlier stores to normal and coherent DMA memory before the MMIO
store:

include/asm-generic/io.h:writel() {
	...
	__io_bw();
	__raw_writel((u32 __force)__cpu_to_le32(value), addr);
	__io_aw();
	...
}

On arm64, __io_bw() is dma_wmb(), so the extra wmb() adds a dsb st to
every TX doorbell.

xsc_update_rx_db(), xsc_arm_cq(), xsc_update_cq_ci() and
xsc_update_eq_ci() use the same wmb() plus writel() pattern. Once the
later "net/xsc: add the transmit path" and "net/xsc: add the receive
path" patches call these helpers, they are on the hot path.
xsc_update_cmdq_req_pid() uses a plain writel(), so the barrier usage in
this file is also inconsistent. The code is unchanged at the end of the
series.

The comments don't seem to match the code either:

- The TX/RX comments mention "updating doorbell record".
- xsc_arm_cq() mentions "the doorbell record in host memory".
- Only a single MMIO word is written, and there is no doorbell record
  in host memory.
- xsc_update_cq_ci() and xsc_update_eq_ci() say "make sure val write to
  memory done", but there is no val variable.

For the CQ/EQ consumer index updates, the intent may be that the
CQE/EQE loads finish before the device can reuse the entry. wmb() only
orders stores, so would a different barrier be needed there?

[ ... ]

> +void xsc_arm_cq(struct xsc_core_device *xdev, u32 cqn, u32 next_cid,
> +		u8 solicited)
> +{
> +	u32 db = FIELD_PREP(XSC_CQ_DB_DATA0_NEXT_CID_MASK, next_cid) |
> +		 FIELD_PREP(XSC_CQ_DB_DATA0_CQ_ID_MASK, cqn) |
> +		 FIELD_PREP(XSC_CQ_DB_DATA0_ARM, !!solicited);

[Severity: Medium]
Is the solicited argument meant to set the bit named
XSC_CQ_DB_DATA0_ARM?

The peer helper xsc_update_eq_ci() sets XSC_EQ_DB_DATA0_ARM from an arm
argument. Its callers in eq.c pass 1 to arm the EQ at the end of
xsc_eq_int() and at EQ creation, and 0 for intermediate CI updates.

Later in the series, every caller of xsc_arm_cq() passes 0. The re-arm
after NAPI completion does this:

xsc_cq_notify_hw_rearm()
    xsc_arm_cq(cq->xdev, cq->xcq.cqn, cq->wq.cc, 0);

So does the initial arm at CQ creation in net/main.c:

    xsc_arm_cq(pcq->xdev, pcq->xcq.cqn, pcq->wq.cc, 0);

If BIT(31) is the arm enable bit, as the macro name suggests, do the
CQs ever get armed? Completion interrupts would then stop after the
first napi_complete_done(), and the RX/TX datapath would stall.

Another reading is that any write to DB_CQ_FUNC_MEM_ADDR arms the CQ,
and BIT(31) only selects solicited-only notification. In that case,
should the macro be renamed so the exported prototype, the
implementation and the EQ helper agree on what this bit means?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261126145711.70868-1-tianx%40yunsilicon.com
