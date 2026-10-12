Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC80B49B1FF;
	Mon, 12 Oct 2026 15:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.67.10.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791818478; cv=none; b=PRNE+TQl4as+x7ZyGfuhtdqEsOXmZ3RdgmR/4CIJTUzX7pCCP5+tZP9mrto/cMrRLjzww5gpZizRVfPvE0V8hGfkHKj8NX3Vjhnm0qqlduikdGOa9DozaUKUwkQpKpZee7sKYIx/mzn5RSe/H9PfdFv4lQRsU2ap0/6gCRri97w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791818478; c=relaxed/simple;
	bh=ycpCiI1Kso8pgVV7aTQnjkF2GotpSaIp+0Wlek1u+pM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UWLsiFWIFN7EeK9+63uc+WaS9OV637DRPSqp9apX3jtndSNjoL9EbEENd3M4L+X5yR7TgAFg2LxIi10poNJiuUvXfvXkyhsoYmfSrh1Yjp3vJBnwm/KtEGMhAeJmED/tLZ3xsz636Sr0bEACewbMC4Axrx6MHGXoktldPuGu/G4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch; spf=pass smtp.mailfrom=lunn.ch; dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b=xEy7UmDi; arc=none smtp.client-ip=156.67.10.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunn.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b="xEy7UmDi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=Y30aZcmhfSW3cW3UZF1TKGwOZx6lNawDnr5gaKUlFb8=; b=xEy7UmDiK/3QlHWmawceDe/2Vv
	6S8oMDVWiQ9TivuWl8SZFgRT61BPRUbQ1LR+gBZMI6MnHljzXOXKd+1r/9y9rBKgmntXhgnjCQUwe
	e00S0PIkP8tn577CtBxNVB7ftVXT48xD2idN+8BbPStHlKY30QqfvFd9t04tMExcsOss=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1xGHpl-00ALtQ-R4; Mon, 12 Oct 2026 17:21:01 +0200
Date: Mon, 12 Oct 2026 17:21:01 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Xin Tian <tianx@yunsilicon.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	weihg@yunsilicon.com, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH 02/15] yunsilicon: add the register HAL
Message-ID: <d9d02f67-558f-426f-b3a4-b13bd0a95c0e@lunn.ch>
References: <20261012114352.2471317-1-tianx@yunsilicon.com>
 <20261012114354.2471317-3-tianx@yunsilicon.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261012114354.2471317-3-tianx@yunsilicon.com>

On Mon, Oct 12, 2026 at 07:43:55PM +0800, Xin Tian wrote:
> Add the register access layer and the per-device register map: doorbell
> and interrupt registers, the command queue pointers and the device
> capability queries that the upper layers call.  The register map is
> described by xsc_hal.h and implemented for the Andes device.
> 
> Signed-off-by: Xin Tian <tianx@yunsilicon.com>
> ---
>  .../net/ethernet/yunsilicon/xsc/pci/Makefile  |   2 +-
>  .../yunsilicon/xsc/pci/hal/andes_impl.c       | 708 ++++++++++++++++++
>  .../yunsilicon/xsc/pci/hal/andes_reg.h        |  43 ++
>  .../ethernet/yunsilicon/xsc/pci/hal/xsc_hal.h |  85 +++
>  .../net/ethernet/yunsilicon/xsc/pci/main.c    |   3 +
>  5 files changed, 840 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/hal/andes_impl.c
>  create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/hal/andes_reg.h
>  create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/hal/xsc_hal.h
> 
> diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile b/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile
> index c163aa950..81b65232e 100644
> --- a/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile
> +++ b/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile
> @@ -6,4 +6,4 @@ ccflags-y += -I$(srctree)/drivers/net/ethernet/yunsilicon/xsc
>  
>  obj-$(CONFIG_YUNSILICON_XSC_PCI) += xsc_pci.o
>  
> -xsc_pci-y := main.o
> +xsc_pci-y := main.o hal/andes_impl.o
> diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/hal/andes_impl.c b/drivers/net/ethernet/yunsilicon/xsc/pci/hal/andes_impl.c
> new file mode 100644
> index 000000000..46fc045f9
> --- /dev/null
> +++ b/drivers/net/ethernet/yunsilicon/xsc/pci/hal/andes_impl.c
> @@ -0,0 +1,708 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (C) 2024 - 2026, Shanghai Yunsilicon Technology Co., Ltd.
> + * All rights reserved.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/pci.h>
> +#include "andes_reg.h"
> +#include "common/xsc_core.h"
> +#include "common/xsc_cmd.h"
> +#include "common/xsc_hsi.h"
> +#include "common/xsc_reg.h"
> +#include "xsc_hal.h"
> +
> +/* message opcode */
> +enum {
> +	XSC_MSG_OPCODE_SEND		= 0,
> +	XSC_MSG_OPCODE_RDMA_WRITE	= 1,
> +	XSC_MSG_OPCODE_RDMA_READ	= 2,
> +	XSC_MSG_OPCODE_MAD		= 3,
> +	XSC_MSG_OPCODE_RDMA_ACK		= 4,
> +	XSC_MSG_OPCODE_RDMA_ACK_READ	= 5,
> +	XSC_MSG_OPCODE_RDMA_CNP		= 6,
> +	XSC_MSG_OPCODE_RAW		= 7,
> +	XSC_MSG_OPCODE_VIRTIO_NET	= 8,
> +	XSC_MSG_OPCODE_VIRTIO_BLK	= 9,
> +	XSC_MSG_OPCODE_RAW_TPE		= 10,
> +	XSC_MSG_OPCODE_INIT_QP_REQ	= 11,
> +	XSC_MSG_OPCODE_INIT_QP_RSP	= 12,
> +	XSC_MSG_OPCODE_INIT_PATH_REQ	= 13,
> +	XSC_MSG_OPCODE_INIT_PATH_RSP	= 14,
> +
> +	XSC_MSG_OPCODE_UNSUPPORT	= -1,
> +};
> +
> +#define REG_ADDR(bp, offset)	((bp) + (offset))
> +
> +static void xsc_read32(void __iomem *bar, u32 off, void *data, int len)
> +{
> +	u32 val = readl(REG_ADDR(bar, off));
> +
> +	memcpy(data, &val, len);

Why memcpy. Probably because the types are messed up.

> +}
> +
> +static void xsc_write32(void __iomem *bar, u32 off, void *data)
> +{
> +	writel(*(u32 *)data, REG_ADDR(bar, off));
> +}

Please sort out your types. You should not be passing a void *. Pass
u32 *. Casts are a red flag, they are generally not needed and
normally indicate bad design.

	Andrew
