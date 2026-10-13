Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81D4C5158A6;
	Tue, 13 Oct 2026 14:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791901921; cv=none; b=QxM6gIu/KNlo3mkHqjpoQ4YpGkouFcwJfp9kV/JiZUjZhJFECOuyLtbrjhRZK7TPk/kdrBpbNatQitnVu8GZmvUjzEqFGxZcjOeUBjLy3yXVqt13NOB7cTSAVCH0rBUByUIG2NJNS52IEhfeHs1KsxiUg0iOz7YZwgCb1ap27xI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791901921; c=relaxed/simple;
	bh=Z+w80xNZmLweUE1mCKOW9ceXGEl+T8ZxQgR0CNAhYno=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OHriPKP/WGqUU3mQXGn+dHxyicJP3CPAPi9uu/vkKwpLn1SCvgiOBMP7U1thAeTKM9V1gzfNXnod1Sbm/qfI45JFtVr7fJpGdlPN3w2F2xY/WsPIsQxf2KOummLhyD+GM6pd/qnKOqpm25VtWKf5VcJpnPpwS71sR8AXJJdCbSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z6Y1TfSa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z6Y1TfSa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81E421F000FF;
	Tue, 13 Oct 2026 14:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791901920;
	bh=Q+c70EsBHf4vh7mah6Nr6xoajlepf/t2t1Z8zj11JV0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Z6Y1TfSap66smzPeQxND2tW6CRg5pLO93rZ/lYtb6HVstiwN+dSOJsQ4ynMaNd7w7
	 crP5zgzaacyCaEoyClDNPvmvO0aS3Ylz8PU6Z7fd0ElpYyf782WH/xLUBlccNjz6Vi
	 S7+yFYqxlQd9mE5MrHlLurzjf82Dt5VSQl3je5hnKRtjvQht56DKf2li9FgWS23+Jl
	 wZ28Eb+witz6c5UnPwC4fUxanPn3Q7JmWSkcibOeqLveZwa3T5lLzt5pa2MNsKIoRj
	 Dt699gPJa8aW5qBfmlgQS2LogFtlHnV+cZF9/pkLWIroUvwE6lQEvkQZ/xZyk+L9be
	 mB3SyFfecqyXw==
Date: Tue, 13 Oct 2026 17:31:56 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Junxian Huang <huangjunxian6@hisilicon.com>
Cc: Xin Tian <tianx@yunsilicon.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, weihg@yunsilicon.com,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH 03/15] yunsilicon: add the command queue
Message-ID: <20261013143156.GP219304@unreal>
References: <20261012114352.2471317-1-tianx@yunsilicon.com>
 <20261012114356.2471317-4-tianx@yunsilicon.com>
 <47c82da8-99cd-ec81-f264-d270fef057ee@hisilicon.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47c82da8-99cd-ec81-f264-d270fef057ee@hisilicon.com>

On Tue, Oct 13, 2026 at 11:11:17AM +0800, Junxian Huang wrote:
> 
> 
> On 2026/10/12 19:43, Xin Tian wrote:
> > Add the command queue that is shared by the ethernet and RDMA functions:
> > the request/response rings, the command work handling and the device
> > initialisation sequence that queries the HCA capabilities, the GUID and
> > the message opcode table.
> > 
> > Signed-off-by: Xin Tian <tianx@yunsilicon.com>
> > ---
> >  .../net/ethernet/yunsilicon/xsc/pci/Makefile  |    2 +-
> >  .../net/ethernet/yunsilicon/xsc/pci/cmdq.c    | 1247 +++++++++++++++++
> >  drivers/net/ethernet/yunsilicon/xsc/pci/hw.c  |  310 ++++
> >  drivers/net/ethernet/yunsilicon/xsc/pci/hw.h  |   18 +
> >  .../net/ethernet/yunsilicon/xsc/pci/main.c    |   55 +
> >  5 files changed, 1631 insertions(+), 1 deletion(-)
> >  create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/cmdq.c
> >  create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/hw.c
> >  create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/hw.h
> > 
> > diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile b/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile
> > index 81b65232e..656cdffa1 100644
> > --- a/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile
> > +++ b/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile
> > @@ -6,4 +6,4 @@ ccflags-y += -I$(srctree)/drivers/net/ethernet/yunsilicon/xsc
> >  
> >  obj-$(CONFIG_YUNSILICON_XSC_PCI) += xsc_pci.o
> >  
> > -xsc_pci-y := main.o hal/andes_impl.o
> > +xsc_pci-y := main.o cmdq.o hw.o hal/andes_impl.o
> > diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/cmdq.c b/drivers/net/ethernet/yunsilicon/xsc/pci/cmdq.c
> > new file mode 100644
> > index 000000000..48832b26d
> > --- /dev/null
> > +++ b/drivers/net/ethernet/yunsilicon/xsc/pci/cmdq.c
> > @@ -0,0 +1,1247 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (c) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
> > + * All rights reserved.
> > + * Copyright (c) 2013-2016, Mellanox Technologies. All rights reserved.
> 
> Why Mellanox?

This is how new RDMA drivers are born :)

Thanks
