Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.36
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793792427;
	b=MZ1HeBXKpPfCRTRwdaU0bDCRvhS/RO+7DCEWsP0LFVqeR6+HgfI4r5OMMQVNSmK1JRpk
	 sVYIWdGBpGv9lXSSB1sXG4mPwOZ822E4n/B2+wuYiRtX6+Gh/KHqFTa/oT7J/7FjWz39D
	 ZXk9C50vxt9MmKL8NhOgQD6eaWsyXp7g5LjGlw6wwWS7xl4C5Jjd1GGx45jRT1vVu0Ly+
	 ykh39UfdfRhSoZcz1cjWh2G0aHTfJtgUxZynAD6XsxtJayjREjpxMSQX94e5N0+3HkqPk
	 r3Tqr6hhagQS7mralHbeIlyZH8ocGEvK2HaaiaHMS6jVHJE1pLLWHWz5IoxMIrOyhSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793792427;
	h=DMARC-Filter:DKIM-Signature:Message-Id:Received:References:
	 X-Lms-Return-Path:From:Subject:Date:User-Agent:
	 Content-Transfer-Encoding:In-Reply-To:Content-Type:X-Original-From:To:
	 Cc:Mime-Version;
	bh=pPsOd91eue55DvpTTpIkJaM1e+sIzdW80J0vYdNAO4k=;
	b=u0SCqakagawiEH4M75jEEuhpn+7ZdKp+7B1MU5Z1+7kcFDE5oABPHCDAw2S2O6yqvck8
	 sL97Bp3Fa0FlH1EBpez+P9IUQVHTtVfKvlvk+/RaYV0HXzVs6V2RtLxJb+PEzCFJEK412
	 aYutpN8XGPJs5EXxInjTsoF7gXKaYHTBp+EpJUYpDLjxEU3O5JKXs07l43Pm7RlMKr0Li
	 sWrn9E8PM4PL9nO502Io6SQ9tJFzHGT4ih36CjQlLXd21Cyyz9xmis3BH4/g9HnEDWOV2
	 RAh41HZk81vLy+exdtKFAEG/nrrQAX7xeSRh1QdjJRJ+OGpNULdtaV6HDE4VljTMIag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=yunsilicon.com;
	spf=pass smtp.mailfrom=yunsilicon.com;
	dkim=pass header.d=yunsilicon.com header.i=@yunsilicon.com header.a=rsa-sha256 header.s=feishu2403070942 header.b=HDzLbzH1;
	arc=none smtp.remote-ip=209.127.231.36
Received: from va-2-36.ptr.blmpb.com (va-2-36.ptr.blmpb.com [209.127.231.36])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 657E8606A326
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 11:40:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 657E8606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=yunsilicon.com header.i=@yunsilicon.com header.a=rsa-sha256 header.s=feishu2403070942 header.b=HDzLbzH1
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=feishu2403070942; d=yunsilicon.com; t=1793792421; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=pPsOd91eue55DvpTTpIkJaM1e+sIzdW80J0vYdNAO4k=;
 b=HDzLbzH1CGbklSWoIPIQCsDnnq06UZAZKuSmKt3YDJH38gLB5kVOCf9QDEPl9IsiLA1F6K
 taPOduA/EpHBt35OgL0LEx9N3fBzvyFW0LWclogLaRRhceiXENVI3LEHrTvh57Tm5NIEP/
 vtZHR6eA1Vr42mn9sFBpDR93YZ6QwxuB9aRqpifxhY4GxmDRHtV1iM24fY0HgKiW2RLWIn
 C9FbcBdjmPJgYf40y3NzKiQ6aDWHqsUoGlz3zGrhgrxLcaKDSH+6A/oxg7nJmSvhkdACif
 uJeys8fao+axh+3rulPua3yDvkG9/dif6gmf2E4+8PeWre9rnjEF6tmxoVPuEw==
Message-Id: <e3354620-abb4-4584-80d2-0251a0d49d10@yunsilicon.com>
Received: from [127.0.0.1] ([180.152.18.210]) by smtp.feishu.cn with ESMTPS; Wed, 04 Nov 2026 19:40:18 +0800
References: <20261012114352.2471317-1-tianx@yunsilicon.com> <20261012114356.2471317-4-tianx@yunsilicon.com> <47c82da8-99cd-ec81-f264-d270fef057ee@hisilicon.com>
X-Lms-Return-Path: <lba+26aeb19a3+759116+vger.kernel.org+tianx@yunsilicon.com>
From: "Xin Tian" <tianx@yunsilicon.com>
Subject: Re: [PATCH 03/15] yunsilicon: add the command queue
Date: Wed, 4 Nov 2026 19:40:17 +0800
User-Agent: Mozilla Thunderbird
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <47c82da8-99cd-ec81-f264-d270fef057ee@hisilicon.com>
Content-Type: text/plain; charset=UTF-8
X-Original-From: Xin Tian <tianx@yunsilicon.com>
To: "Junxian Huang" <huangjunxian6@hisilicon.com>, 
	"Andrew Lunn" <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, 
	"Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>, 
	"Paolo Abeni" <pabeni@redhat.com>, "Jason Gunthorpe" <jgg@ziepe.ca>, 
	"Leon Romanovsky" <leon@kernel.org>
Cc: <weihg@yunsilicon.com>, <linux-kernel@vger.kernel.org>, 
	<netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0

On 10/13/2026 11:11 AM, Junxian Huang wrote:
>
> On 2026/10/12 19:43, Xin Tian wrote:
>> Add the command queue that is shared by the ethernet and RDMA functions:
>> the request/response rings, the command work handling and the device
>> initialisation sequence that queries the HCA capabilities, the GUID and
>> the message opcode table.
>>
>> Signed-off-by: Xin Tian <tianx@yunsilicon.com>
>> ---
>>   .../net/ethernet/yunsilicon/xsc/pci/Makefile  |    2 +-
>>   .../net/ethernet/yunsilicon/xsc/pci/cmdq.c    | 1247 +++++++++++++++++
>>   drivers/net/ethernet/yunsilicon/xsc/pci/hw.c  |  310 ++++
>>   drivers/net/ethernet/yunsilicon/xsc/pci/hw.h  |   18 +
>>   .../net/ethernet/yunsilicon/xsc/pci/main.c    |   55 +
>>   5 files changed, 1631 insertions(+), 1 deletion(-)
>>   create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/cmdq.c
>>   create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/hw.c
>>   create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/hw.h
>>
>> diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile b/drivers/=
net/ethernet/yunsilicon/xsc/pci/Makefile
>> index 81b65232e..656cdffa1 100644
>> --- a/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile
>> +++ b/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile
>> @@ -6,4 +6,4 @@ ccflags-y +=3D -I$(srctree)/drivers/net/ethernet/yunsili=
con/xsc
>>  =20
>>   obj-$(CONFIG_YUNSILICON_XSC_PCI) +=3D xsc_pci.o
>>  =20
>> -xsc_pci-y :=3D main.o hal/andes_impl.o
>> +xsc_pci-y :=3D main.o cmdq.o hw.o hal/andes_impl.o
>> diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/cmdq.c b/drivers/ne=
t/ethernet/yunsilicon/xsc/pci/cmdq.c
>> new file mode 100644
>> index 000000000..48832b26d
>> --- /dev/null
>> +++ b/drivers/net/ethernet/yunsilicon/xsc/pci/cmdq.c
>> @@ -0,0 +1,1247 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Copyright (c) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
>> + * All rights reserved.
>> + * Copyright (c) 2013-2016, Mellanox Technologies. All rights reserved.
Hi Junxian,

All ten are fixed in v1, which I'll post shortly.
> Why Mellanox?
This is intentional=E2=80=94the code is derived from the Mellanox driver, a=
s Leon
noted. I'll keep it as is.
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/errno.h>
>> +#include <linux/pci.h>
>> +#include <linux/dma-mapping.h>
>> +#include <linux/slab.h>
>> +#include <linux/delay.h>
>> +#include <linux/random.h>
>> +#include <linux/kthread.h>
>> +#include <linux/io-mapping.h>
>> +
>> +#include "common/xsc_cmd_api.h"
>> +#include "common/xsc_cmd.h"
>> +#include "common/xsc_core.h"
>> +#include "hal/xsc_hal.h"
>> +
>> +enum {
>> +	CMD_IF_REV =3D 3,
>> +};
>> +
>> +enum {
>> +	NUM_LONG_LISTS	  =3D 2,
>> +	NUM_MED_LISTS	  =3D 64,
>> +	LONG_LIST_SIZE	  =3D (2ULL * 1024 * 1024 * 1024 / PAGE_SIZE) * 8 + 16 =
+
>> +				XSC_CMD_DATA_BLOCK_SIZE,
>> +	MED_LIST_SIZE	  =3D 16 + XSC_CMD_DATA_BLOCK_SIZE,
>> +};
>> +
>> +enum {
>> +	XSC_CMD_DELIVERY_STAT_OK			=3D 0x0,
>> +	XSC_CMD_DELIVERY_STAT_SIGNAT_ERR		=3D 0x1,
>> +	XSC_CMD_DELIVERY_STAT_TOK_ERR			=3D 0x2,
>> +	XSC_CMD_DELIVERY_STAT_BAD_BLK_NUM_ERR		=3D 0x3,
>> +	XSC_CMD_DELIVERY_STAT_OUT_PTR_ALIGN_ERR		=3D 0x4,
>> +	XSC_CMD_DELIVERY_STAT_IN_PTR_ALIGN_ERR		=3D 0x5,
>> +	XSC_CMD_DELIVERY_STAT_FW_ERR			=3D 0x6,
>> +	XSC_CMD_DELIVERY_STAT_IN_LENGTH_ERR		=3D 0x7,
>> +	XSC_CMD_DELIVERY_STAT_OUT_LENGTH_ERR		=3D 0x8,
>> +	XSC_CMD_DELIVERY_STAT_RES_FLD_NOT_CLR_ERR	=3D 0x9,
>> +	XSC_CMD_DELIVERY_STAT_CMD_DESCR_ERR		=3D 0x10,
>> +};
>> +
>> +static struct xsc_cmd_work_ent *xsc_alloc_cmd(struct xsc_cmd *cmd,
>> +					      struct xsc_cmd_msg *in,
>> +					      struct xsc_rsp_msg *out)
>> +{
>> +	struct xsc_cmd_work_ent *ent;
>> +
>> +	ent =3D kzalloc_obj(*ent, GFP_KERNEL);
>> +	if (!ent)
>> +		return ERR_PTR(-ENOMEM);
>> +
>> +	ent->in		=3D in;
>> +	ent->out	=3D out;
>> +	ent->cmd	=3D cmd;
>> +
>> +	return ent;
>> +}
>> +
>> +static void xsc_free_cmd(struct xsc_cmd_work_ent *ent)
>> +{
>> +	kfree(ent);
> One line function is unnecessary.
>
> Junxian
Fixed in v1.

Thanks,
Xin Tian
>> +}
