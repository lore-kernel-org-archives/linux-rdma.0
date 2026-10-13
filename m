Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C4B47208B;
	Tue, 13 Oct 2026 03:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791861086; cv=none; b=NBKzBRXO5wtw9/sfD/eXfVh5l56+U6ac7YvpM/oQIRnV+CC6uMsRM4EptUctLUG3Fc8B9GP2+DK9vm4gJ3pVfQTxXjUWA3wFqqRrc0czAaMuWTuJsXjncBiYghmX+r4eOYEospyCWmrboQGyZY01x9Gunygd5dzGhAw3MPng5Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791861086; c=relaxed/simple;
	bh=ARWsg5OJqiVDTR7iycF3Ayu4dgvlopAwbx13OiMNFUc=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=P9i2b3D1aqPEjn7qKA4UCshm/dA+t16QWm+7zWC3SgKqwF/H5a7XkV2UZ5YLIMyjx9nVQ0mKq/OBcjV21kR9f4ny5ItNR9T+7mhNh4zFVLu5AQxJasACc3ZVRLfakbdrtNDPQgthQgRZsX7MBS5tVyjd6/Z6QdEEpCRD8DiKzOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=113.46.200.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4j3fDm5WyXzRhQs;
	Tue, 13 Oct 2026 10:59:04 +0800 (CST)
Received: from kwepemf100018.china.huawei.com (unknown [7.202.181.17])
	by mail.maildlp.com (Postfix) with ESMTPS id 69E5B40561;
	Tue, 13 Oct 2026 11:11:18 +0800 (CST)
Received: from [10.67.120.168] (10.67.120.168) by
 kwepemf100018.china.huawei.com (7.202.181.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 13 Oct 2026 11:11:17 +0800
Message-ID: <47c82da8-99cd-ec81-f264-d270fef057ee@hisilicon.com>
Date: Tue, 13 Oct 2026 11:11:17 +0800
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 03/15] yunsilicon: add the command queue
Content-Language: en-US
To: Xin Tian <tianx@yunsilicon.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Jason
 Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
CC: <weihg@yunsilicon.com>, <linux-kernel@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>
References: <20261012114352.2471317-1-tianx@yunsilicon.com>
 <20261012114356.2471317-4-tianx@yunsilicon.com>
From: Junxian Huang <huangjunxian6@hisilicon.com>
In-Reply-To: <20261012114356.2471317-4-tianx@yunsilicon.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemf100018.china.huawei.com (7.202.181.17)



On 2026/10/12 19:43, Xin Tian wrote:
> Add the command queue that is shared by the ethernet and RDMA functions:
> the request/response rings, the command work handling and the device
> initialisation sequence that queries the HCA capabilities, the GUID and
> the message opcode table.
> 
> Signed-off-by: Xin Tian <tianx@yunsilicon.com>
> ---
>  .../net/ethernet/yunsilicon/xsc/pci/Makefile  |    2 +-
>  .../net/ethernet/yunsilicon/xsc/pci/cmdq.c    | 1247 +++++++++++++++++
>  drivers/net/ethernet/yunsilicon/xsc/pci/hw.c  |  310 ++++
>  drivers/net/ethernet/yunsilicon/xsc/pci/hw.h  |   18 +
>  .../net/ethernet/yunsilicon/xsc/pci/main.c    |   55 +
>  5 files changed, 1631 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/cmdq.c
>  create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/hw.c
>  create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/hw.h
> 
> diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile b/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile
> index 81b65232e..656cdffa1 100644
> --- a/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile
> +++ b/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile
> @@ -6,4 +6,4 @@ ccflags-y += -I$(srctree)/drivers/net/ethernet/yunsilicon/xsc
>  
>  obj-$(CONFIG_YUNSILICON_XSC_PCI) += xsc_pci.o
>  
> -xsc_pci-y := main.o hal/andes_impl.o
> +xsc_pci-y := main.o cmdq.o hw.o hal/andes_impl.o
> diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/cmdq.c b/drivers/net/ethernet/yunsilicon/xsc/pci/cmdq.c
> new file mode 100644
> index 000000000..48832b26d
> --- /dev/null
> +++ b/drivers/net/ethernet/yunsilicon/xsc/pci/cmdq.c
> @@ -0,0 +1,1247 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
> + * All rights reserved.
> + * Copyright (c) 2013-2016, Mellanox Technologies. All rights reserved.

Why Mellanox?

> + */
> +
> +#include <linux/module.h>
> +#include <linux/errno.h>
> +#include <linux/pci.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/slab.h>
> +#include <linux/delay.h>
> +#include <linux/random.h>
> +#include <linux/kthread.h>
> +#include <linux/io-mapping.h>
> +
> +#include "common/xsc_cmd_api.h"
> +#include "common/xsc_cmd.h"
> +#include "common/xsc_core.h"
> +#include "hal/xsc_hal.h"
> +
> +enum {
> +	CMD_IF_REV = 3,
> +};
> +
> +enum {
> +	NUM_LONG_LISTS	  = 2,
> +	NUM_MED_LISTS	  = 64,
> +	LONG_LIST_SIZE	  = (2ULL * 1024 * 1024 * 1024 / PAGE_SIZE) * 8 + 16 +
> +				XSC_CMD_DATA_BLOCK_SIZE,
> +	MED_LIST_SIZE	  = 16 + XSC_CMD_DATA_BLOCK_SIZE,
> +};
> +
> +enum {
> +	XSC_CMD_DELIVERY_STAT_OK			= 0x0,
> +	XSC_CMD_DELIVERY_STAT_SIGNAT_ERR		= 0x1,
> +	XSC_CMD_DELIVERY_STAT_TOK_ERR			= 0x2,
> +	XSC_CMD_DELIVERY_STAT_BAD_BLK_NUM_ERR		= 0x3,
> +	XSC_CMD_DELIVERY_STAT_OUT_PTR_ALIGN_ERR		= 0x4,
> +	XSC_CMD_DELIVERY_STAT_IN_PTR_ALIGN_ERR		= 0x5,
> +	XSC_CMD_DELIVERY_STAT_FW_ERR			= 0x6,
> +	XSC_CMD_DELIVERY_STAT_IN_LENGTH_ERR		= 0x7,
> +	XSC_CMD_DELIVERY_STAT_OUT_LENGTH_ERR		= 0x8,
> +	XSC_CMD_DELIVERY_STAT_RES_FLD_NOT_CLR_ERR	= 0x9,
> +	XSC_CMD_DELIVERY_STAT_CMD_DESCR_ERR		= 0x10,
> +};
> +
> +static struct xsc_cmd_work_ent *xsc_alloc_cmd(struct xsc_cmd *cmd,
> +					      struct xsc_cmd_msg *in,
> +					      struct xsc_rsp_msg *out)
> +{
> +	struct xsc_cmd_work_ent *ent;
> +
> +	ent = kzalloc_obj(*ent, GFP_KERNEL);
> +	if (!ent)
> +		return ERR_PTR(-ENOMEM);
> +
> +	ent->in		= in;
> +	ent->out	= out;
> +	ent->cmd	= cmd;
> +
> +	return ent;
> +}
> +
> +static void xsc_free_cmd(struct xsc_cmd_work_ent *ent)
> +{
> +	kfree(ent);

One line function is unnecessary.

Junxian

> +}
