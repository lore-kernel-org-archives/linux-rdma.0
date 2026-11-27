Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795791490;
	b=EzIoVkjypmLDQ/LyrkVQ38oC+B4myzIGm3EIVsjFp/n2tTGsy2NOryHY0lA1QlOq6M/K
	 VC9q5JCI50qFC0RLeDlsphVd18prLwJstqDR+zgozx5zs87Of0thMNAkO4xatQbFIEzW5
	 Umq9EW7pyTSHBsiRug1k4GvyWVEZbaifhQsSfaSt16qlxB8FDJgLyP2NWNJiYgDRe8+mp
	 bJu6BFHhz4rsynLfzK8I4kBPqT4D9pHBIwtmW5Cy6q2gIk7rfLPMF9BcnCDpkmKoBj+Im
	 xlY5pGe5YPbPuXDKfi8e7LnWwPsRJB7/2JA5ZaxVKh+ehkKYEDLZBTOJfsrtcXwdsYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795791490;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=tgCuLsxMlddT1YWu5grEVyY8SetjUaMPfmoiTTGh6Kk=;
	b=VnX17yJ6fqwNBCSxjfwviGO7mGQEDnefroRvOSZaiXAodo+D0mK1w9XCbyZHAI5PGLlZ
	 vxKSBzSpq0sHq8JGI30WbEjYOM3yDCB50bnWZFrYxzBzhoIB3RXOXAHwUlBU4y5oxOns1
	 UxOIs+y0hxRmwyC3uJIuAKt0A8aZ7hDWhNfK0LJPRpmc44PNKU0gMLEPJKcNVSziC1wGb
	 o5+rfEAQqeSF10Ui2QeG3gfY+A+Oh1KzM1gU0V5H9Ec9OZA19E5b5xOuEz7hTKALhimQl
	 b8t2yCtBy99J6AVTytvB0c1QgYh2YgGe2XbtBu47bQa6f6N3u3fFXOq6RJ9+J0TqaRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a9JVhBPs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A5B606A31F
	for <linux-rdma@vger.kernel.org>; Fri, 27 Nov 2026 14:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a9JVhBPs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98E1B1F00899;
	Fri, 27 Nov 2026 14:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795791490;
	bh=tgCuLsxMlddT1YWu5grEVyY8SetjUaMPfmoiTTGh6Kk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=a9JVhBPsUDguuun7Q0wg4gXRSf3OC/FEtPR9eJ62pFV/fqdMO/wUH14apw3IK4BBA
	 JalujV4VatCHGt/GhDTlyTDafrRWBP3bHZnKcexMfPIxfC38z3vjuQOj312mdKe0bV
	 or5thq+kta06tW2jKBBd6hhugFvontUZMCdpxYzmq9gwCAbRob+Gxj2pMpJyGq27d+
	 tC2lxd0ti/0/uGgA6BJ/L57wJOex/QJmNblaPAAuQXdVh0Wlnf/4tVMI50qEScdAQw
	 wu4n/9ybnlf7fLwoXWHDOqZHNQ5Zh/BY2gjs63oSFgRZJin166Hvnq23IH7JMgDjeP
	 QI/jrsvb2ZqXQ==
Message-ID: <sashiko-outbox-237640@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 07/11] net/xsc: add the ethernet netdev
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xin Tian" <tianx@yunsilicon.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261126145730.70868-8-tianx@yunsilicon.com>
References: <20261126145711.70868-1-tianx@yunsilicon.com>
 <20261126145730.70868-8-tianx@yunsilicon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 14:58:10 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] net/xsc: missing select AUXILIARY_BUS in Kconfig for XSC PCI
  and ETH
--

commit a8648ed654545f6dce03a1a5471a356b495435e2
Author: Xin Tian <tianx@yunsilicon.com>

net/xsc: add the ethernet netdev

This commit registers the Yunsilicon XSC ethernet auxiliary device and
driver, sets up the netdev, and programs its MAC address, MTU, and
open/close callbacks.

> diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/Kconfig b/drivers/ne=
t/ethernet/yunsilicon/xsc/net/Kconfig
> new file mode 100644
> index 0000000000000..7428b26295b66
> --- /dev/null
> +++ b/drivers/net/ethernet/yunsilicon/xsc/net/Kconfig
> @@ -0,0 +1,17 @@
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
> +# All rights reserved.
> +# Yunsilicon driver configuration
> +#
> +
> +config YUNSILICON_XSC_ETH
> +	tristate "Yunsilicon XSC ethernet driver"
> +	depends on YUNSILICON_XSC_PCI
> +	depends on NET
> +	select PAGE_POOL

[Severity: Medium]
Should YUNSILICON_XSC_PCI (and YUNSILICON_XSC_ETH) select AUXILIARY_BUS?

This commit adds auxiliary device registration in xsc_pci (xsc_adev_add()
calling auxiliary_device_init() and auxiliary_device_add()) and auxiliary
driver registration in xsc_eth (module_auxiliary_driver()).  Because
AUXILIARY_BUS is a hidden Kconfig symbol without stubs when disabled,
configs enabling YUNSILICON_XSC_PCI or YUNSILICON_XSC_ETH without another
driver selecting AUXILIARY_BUS will fail to link with undefined references
to auxiliary_device_init(), __auxiliary_device_add(),
__auxiliary_driver_register(), and auxiliary_driver_unregister().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126145711.7086=
8-1-tianx@yunsilicon.com?part=3D7
