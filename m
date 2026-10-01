Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E8C1493652;
	Thu,  1 Oct 2026 12:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790856498; cv=none; b=fYebuDxzrBPqnu4NEajQe18pw35IknLrbVjbCUOgzzifRfYMAfsiI/sH74laTC2V76XyaZ/XrRZMfRH/qYgtJaHwBFaDgWVE1Ep3yC4860McCTwEFNiG+mnePIOTLXoee9rhNmg2RNYmktZQTb+E4pOd42iqOzblGGQRQjiCsg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790856498; c=relaxed/simple;
	bh=tfrSGJ6kjlSqJpIyu3EsvJKV3e+9SmUIqC1c2oj40WA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=oxqkEU8OU9MmQEEJtf5Q8gz1rhhLq/NLFcSmUl/IqK5Uy7P6e7sNoeTy9JUFMmiBOA5zQ0Qiw5KxGFvDOwuhwd+/wzzMh+a+T8Y7c0H+hxQwaPFY+1fNKIQ7CbC1EZ2528dhWdVCFYXZ6rtTKl0nKXVayZ3HCV9G0Or3IGoLUJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bjgPjIns; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bjgPjIns"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8723F1F000FF;
	Thu,  1 Oct 2026 12:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790856487;
	bh=8XnpDC09BNoRMybmiRSa9+I7xUKWavYhyhSmyNVYC6k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bjgPjInsFyhwmqymJYKpov2q8feT/1Ml+EARJOciCawPTrCW+uoevRG+fQE3km94E
	 DpuEPnAQ3P53F6Vcv3ZP41MuWV8shgEHV6E8Dbicg7M03nIox3+pFEojGKe0kChJYo
	 vTw5iMH60yfra0rEnFuJjsP0gcWLdmw/kTFjA57C5emiBDmq2v0eAVlhIIhZEARjwq
	 +zDWMns7yK7nc9LEhMrAVS4n18e0f767iHOuqsIxQKTZaXvD18fmc5eauGNUzFEfMd
	 z3at4hqivNXJaf1PHn2QewmyPDCXx0X9/GNo3PtJ0LK9cIU3+SzCiXRCsT6LZ6zcj0
	 TtaG7pch3wy2Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 16/18] PCI/P2PDMA: Let a client declare that it
 selects ATS per mapping
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, media-ci@linuxtv.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
In-Reply-To: <20261001-fix-p2p-acs-v4-0-v9-16-1a8e0f50ddd9@nvidia.com>
References: <20261001-fix-p2p-acs-v4-0-v9-0-1a8e0f50ddd9@nvidia.com>
 <20261001-fix-p2p-acs-v4-0-v9-16-1a8e0f50ddd9@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 12:08:07 +0000
Message-Id: <20261001120807.8723F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] pci/p2pdma: pure clients cannot set ats_per_mapping because pdev=
->p2pdma is NULL
--

commit f332086fc4a4273d099c81fafb33298021d47d1a
Author: Leon Romanovsky <leon@kernel.org>

PCI/P2PDMA: Let a client declare that it selects ATS per mapping

The PCIe ATS Enable bit covers the whole device, so P2PDMA cannot tell
from it whether a client will translate a given address. Most devices
translate any address once ATS is enabled, but some choose ATS per DMA
mapping and can still use bus addresses for the rest.

Add pcim_p2pdma_set_ats_per_mapping() so the driver of such a device can
declare that before P2PDMA starts treating clients with ATS enabled as
translating everything.

> diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
> index cf190bd572d4a..6a63901c65fb6 100644
> --- a/drivers/pci/p2pdma.c
> +++ b/drivers/pci/p2pdma.c

[ ... ]

> @@ -1562,6 +1563,32 @@ void pci_p2pmem_publish(struct pci_dev *pdev, bool=
 publish)
>  }
>  EXPORT_SYMBOL_GPL(pci_p2pmem_publish);
> =20
> +/**
> + * pcim_p2pdma_set_ats_per_mapping - Declare per-mapping ATS for a client
> + * @pdev: PCI device that initiates peer-to-peer DMA
> + *
> + * Declare that @pdev issues Translated Requests only for the DMA mappin=
gs its
> + * driver sets up to use ATS, rather than for any address once ATS is en=
abled.
> + * P2PDMA then routes this client's Requests with the Address Type each =
query
> + * asks about, rather than the one its ATS Enable bit implies.
> + */
> +void pcim_p2pdma_set_ats_per_mapping(struct pci_dev *pdev)
> +{
> +	struct pci_p2pdma *p2p;
> +
> +	p2p =3D rcu_dereference_protected(pdev->p2pdma, 1);
> +	if (!p2p)
> +		/*
> +		 * ats_per_mapping is a performance optimization,
> +		 * if pcim_p2pdma_init() didn't set pdev->p2pdma pointer
> +		 * for some reason, let's simply use ATS global settings.
> +		 */
> +		return;

[Severity: Medium]
Will this silently fail for pure P2PDMA clients?

It looks like pdev->p2pdma is only allocated when a device registers as a
P2P memory provider via pcim_p2pdma_init():

drivers/pci/p2pdma.c:pcim_p2pdma_init() {
	...
	p2p =3D devm_kzalloc(&pdev->dev, sizeof(*p2p), GFP_KERNEL);
	...
}

If a driver for a pure P2PDMA client (e.g., an NVMe initiator without CMB)
calls pcim_p2pdma_set_ats_per_mapping() to declare its ATS behavior, won't
pdev->p2pdma be NULL since it never called pcim_p2pdma_init()?

If so, wouldn't this cause the client to silently fall back to suboptimal
global ATS routing, as it can never successfully set the ats_per_mapping fl=
ag?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001-fix-p2p-ac=
s-v4-0-v9-0-1a8e0f50ddd9@nvidia.com?part=3D16
