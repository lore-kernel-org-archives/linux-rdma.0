Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1BA4EB870
	for <linux-rdma@vger.kernel.org>; Fri,  9 Oct 2026 16:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791564181; cv=pass; b=KnnP4Sb+MfIf/np+2a/7PCuQJs2de1Pix5bd6Wgu7EKeloMYm49n4m1S0K5jqhNwfEAE4j4GmEhet4UYT0Ol9n1qaxwHkng0w0mbUgrgBYtu06N9ja1d84vArI2i+W9+Pa2muLNxgEg4WXdkMF3X3T3HBFqKFlp/ctXrIVzsnkE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791564181; c=relaxed/simple;
	bh=8yVafqw/tymMZHiBDDTV1POQxrFPmsVlSQFwXIA6JgY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Dgghro1UCeq07mECLq73Raj1ejBlgbklh6oBQgFA1gVx3zb5XaVsJ6VOuMByCGeT6Vvgh/Wl/UMN9mnuwpkKLKDwWfebmidy4uA/uMYyNH9dLNx5bggjYS00K+gRPPZnlZJy+vtx4AXq4DbpUSYwxT0JbxoTzlJtkLPXVwyUj+I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CYy98r9I; arc=pass smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CYy98r9I"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6ae14cdc63aso12972a12.1
        for <linux-rdma@vger.kernel.org>; Fri, 09 Oct 2026 09:42:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791564178; cv=none;
        d=google.com; s=arc-20260327;
        b=dUTtL1mK7kp6AwKfNFdzxAAur661cUARkjinBaYI81do+Shkr28qmrQCERvaMdaxqm
         yOsUDQNF4htYE7zvsaVVVeZzYJkxGE+VMfB/sDTNlZfCJAInVKbJU+BoxDZa0EJXt3Aq
         7YqVwZwx5iLyxEyeUo7HQzCR5VAVz8j1hCQvKPuQE9roamwzk9UVUuSin1+M2Pg4UFaK
         wR/5cEaypfcPqEYZJ17trP/VWiNDfgag19mcBM3btKeFSXDPJv6A33VYNdpYXC1DCyaT
         z/8vkZ6pyKGpNUhQkfJayI9RD4CWVEq4NwTgLIXg0xjIHlkpJRyTzc7j33MHp3o8+7c9
         ok3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8yVafqw/tymMZHiBDDTV1POQxrFPmsVlSQFwXIA6JgY=;
        fh=ZPkFGIysKxLOrvV+UD/4XJ8UR4d7RWP8dzFd1ngR8MU=;
        b=KIsyjQ6UCVNx47rG8UaKLSW9OW6TdFUIpqYPYGx44p/vHt2XVHQnhc4YkRfMdL8BQq
         jZ0CuZOkbm+974BpAofVta9ds+XmLec5yGyt+qv5e0S3wyE1V5nL+tweeRg8IsnJx8RU
         qsN1ufPK7qpb7afpECdLNlg2Hkr0Ilr2aCsF+wl23inv48TfXBBhKRpvgdp54bpXeL7I
         gsFZtbk8LSfEayddQI4v9I0Xt0tH1Dry495u10WEVYWPRLrC+fF8aXmIwAAWiYFlZLFp
         Iqi53PDICuRfHaPr5+WJbrKHHYz+k9bIBMcQrHe1k438TKt5Sitf7xwGNIAQJKd/AO7W
         siIg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791564178; x=1792168978; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8yVafqw/tymMZHiBDDTV1POQxrFPmsVlSQFwXIA6JgY=;
        b=CYy98r9IJfEnurNzNStEF1xcp4Z2bhfU5tIS/5Qkj1YvCO5RwuY3PzCnEkisRbTpsw
         P9qoUg8wkhoUkSi3ugQHHUvIsgiurnNAIueYz/HwXLM4EBd2sthNhi7p9Ro7tFAVIu35
         57WdtKULZkCZDP0ZtlX4p3rGTIgudWfh/VeS423w84ibFdLCRbQgX5s+YzDxD6k4rgSL
         Mj8g68bRZNysAUn8vQNr+qF2WbNAC8PVsvRYm5PoTD/kwXFDd9QPFY5vb17ksWm7z7m8
         DIJH6+bSPKp9YXu6k/J4z7aSQjD70oFJl3fLHjlRUxNvOwqwQiv/neliemiVzJYOO1GI
         +uPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791564178; x=1792168978;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8yVafqw/tymMZHiBDDTV1POQxrFPmsVlSQFwXIA6JgY=;
        b=SLpomPr4bRGYuuLTkDXSpVrsBBmNE41Bs6HZ7mVZbZ41u3KaqAl8OphQ43kFyrPgzg
         gOJa0F37VGeBqlIrLdceJeL2w6OtC7dvoXqeAkNCAP2DEQA6GH3RvTSLjh/hWPv/HXEd
         DFhlNP7CAFmwfGH3QgBVnxsy0Ik2/QyHftGKVdHj0+JQqSG1G4dmY7nANPDrO5U05BdR
         iVkKxu/fSJZZ0MQ1RER9e/csI7VnNMzoXKIbLWYJW9zgb/n/OTZnbex5xJXaxZXE5L3S
         qWcPIHsH/CDw4eL27SWxB574OSY4zX628S7n8a+oHzUFq1kvFAo2TirFNZTRKGsWM373
         7z8Q==
X-Forwarded-Encrypted: i=1; AKwUvBwymKt2aRW0VtZ/pDDMMbMTMdMEH8/KZKq4ygqbXKx1UPG0cgnNL3kfB3S2S+jLxlKLrWPgnGZGGpsk@vger.kernel.org
X-Gm-Message-State: AFq9FYJtu9+koEWqyEKt47ugZW6WbTO0HqIBQDLaMj9DkOSw/hrTnfWD
	D0v002lgsOAOmdSLxmt/h+Mus91qOYk+tizdIe4j397d29Zmbh7hL9xZggrcqr569VVFfMpUs/o
	P0IkKpoAUFccQneuc/+FOBU8O1sHs4+WNHLBiFZVLfRlXzlWwX57pPXxC
X-Gm-Gg: AYBFou07dG0/MJjHIHfFiyN/wnTBj8XRc0oGM2qHp5H7pFt+OvGqd3ZlS2BzXDI75B8
	tnSYGBvB2YZij9itjhVkQ5AgEYnVV3fUd2SJhsymit8FbS6O0ehOtJrUjoYQ+6FyZ95vSFAw2Qo
	KX478qEqy+BUzd9+Yy1FEGsQ1txtVxd3PqjygMJRYymeqU9hZCuQ9YbmbHDwSyinBD76LVoobc4
	2Bt/OK7DfMHBGnbvGmvpWa0kR+Odn1ALxT3vhbeNfxCIr8GLKORu3NKuhnkpuubHxlMpLH9NmlF
	n0zA4+qBjMnDm8jJbSoF1Zz8DQ/xOEs8F6KnOZNReaurnPOoiVu4JQ==
X-Received: by 2002:a05:6402:c553:20b0:6aa:b72b:d762 with SMTP id
 4fb4d7f45d1cf-6b1776e1bf1mr53790a12.1.1791564177860; Fri, 09 Oct 2026
 09:42:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261008132815.654147-1-tariqt@nvidia.com>
In-Reply-To: <20261008132815.654147-1-tariqt@nvidia.com>
From: Mina Almasry <almasrymina@google.com>
Date: Fri, 9 Oct 2026 09:42:46 -0700
X-Gm-Features: AclHuK9YIcoqyRx7ZdV1TYGtJevv7ew5G8vshJKEoIcRV7Km280vcnLyswG0lkU
Message-ID: <CAHS8izNSo4YzXxD3C6c2HohdOfH2GK1M=51biuevLUk3vz5k4g@mail.gmail.com>
Subject: Re: [PATCH net-next 00/10] net/mlx5e: Add netdev support for data direct
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, 
	Paolo Abeni <pabeni@redhat.com>, Bobby Eshleman <bobbyeshleman@meta.com>, 
	Byungchul Park <byungchul@sk.com>, Carolina Jubran <cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>, 
	Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman <gal@nvidia.com>, 
	Jacob Keller <Jacob.e.keller@intel.com>, Kees Cook <kees@kernel.org>, 
	Leon Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>, 
	linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>, 
	Matt Fleming <mfleming@cloudflare.com>, Nikolay Aleksandrov <razor@blackwall.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Shivaji Kant <shivajikant@google.com>, 
	Simon Horman <horms@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>, 
	Stanislav Fomichev <sdf.kernel@gmail.com>, William Tu <witu@nvidia.com>, 
	Yue Haibing <yuehaibing@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 8, 2026 at 6:28=E2=80=AFAM Tariq Toukan <tariqt@nvidia.com> wro=
te:
>
> Hi,
>
> This patch series by Dragos adds data direct support for netdev devices,
> allowing a mlx5 netdev to issue DMA commands through multiple paths.
> This feature is critical for improving performance and reaching line
> rate in certain environments where issuing PCI transactions over one
> path may be significantly faster than over another. These differences
> can arise from various PCI generations in the system or the specific
> system topology.
>
> Data direct for netdev will work with devmem by returning the data
> direct DMA device instead of the DMA device of the NIC. Each PF netdev
> registers its own data direct device and support for RX and TX datapath
> is added. The feature is selected through a new data direct priv flag.
>
> The feature is enabled though a ethtool private flag. When this flag
> is enabled, the driver will return the data direct device in the
> ndo_queue_get_dma_dev op.
>
> During data_direct device unbind, a re-creation of the channels is
> triggered.
>
> A note about the unbind: it does not does not tear down dmabuf bindings
> attached to the data direct device; the recreated channels will still
> pick up the binding via rxq->mp_params and post DMA addresses from the
> data direct IOMMU domain to the PF, causing IOMMU faults. A devmem
> revoke hook is needed to close those bindings before the switch. This is
> out of scope for this series.
>

Elaborate on this please. Are you referring to the fact that on
page_pool_scrub we unmap the netmems dma-mapped by the page-pool, but
we don't unmap the netmems dma-mapped by the memory provider?

What's the impact of leaving this unfixed? Is the machine going to
crash if the device goes away but we don't unmap the dmabuf?
--=20
Thanks,
Mina
