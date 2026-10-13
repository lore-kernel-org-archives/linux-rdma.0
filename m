Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3585511E9F;
	Tue, 13 Oct 2026 14:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791902409; cv=none; b=KtnrI4l0Z2tPEYaCFugEGubVhJEIU8rsigod/WRnVniehs0RrfGVKkN1wHepSbxgNPVaplb0JGGyLh1FbXj1VzhcU1tdKaNiqdZzTAYoDO/xfODP0rc8MJpB/+vyZXl2+Rf0xCpW3s7WPnwPBlZEiBMytLsdZSMGrnPXAaQCQNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791902409; c=relaxed/simple;
	bh=lwaHNQ3/lRUyFTUXqAp1xPdqMZqv7HbXC4Bz+FVwTAE=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=cqoxY94Mp9vbfZ2thIOb/8cxIo0MJ6Wu4yhR99WU6g/h0F6BdXkJVNeTnvh8HG3L4zpmuOIlydZfGlpBVlO5NVAQOZHLBKBb+K2yNaoIAo9TSlg0XuoVKlfWf8Y2yTRB3GWt6+Qu1JZDdoP7qVMCdN9Gs7f4gkGWBZ1RjVzJkb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XmvQHvDf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XmvQHvDf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4D371F00893;
	Tue, 13 Oct 2026 14:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791902407;
	bh=lwaHNQ3/lRUyFTUXqAp1xPdqMZqv7HbXC4Bz+FVwTAE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XmvQHvDfltDF1iSeOOKqU0vytgQl717QC+FdQNvZP1jYKwTTCZYFNt1ZEv+J9S5pY
	 iWBHaQvygTtFJvsXKSWSbx5GVMTwkSpBeZ3SbGiw/qJ3APgmEaVUlnS5mKwVldhSR+
	 PTGNJ89wkrYy6PeXVH0k5YG0VDKEst9HZPIW+GnOeU3wEcV2hXnDawGLRtvuNqnh4x
	 BCqzXCFKuLqjn5ESidxg/nRBuItqvo+MQ29Dh11DvICnoIPTyDyJl11TnZ5cBa5hQp
	 VlEF3fnrPI9SpkK/nnQGiI2QI/1Qusbsc/KatNBu3321Y6gCvC3q7mmpHBFLKJd5T6
	 BtfK+mxzou+VA==
Message-ID: <sashiko-outbox-169926@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 12/19] PCI/P2PDMA: Log detailed ACS routing
 diagnostics
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261013-fix-p2p-acs-v4-0-v11-12-72cf8c96e617@nvidia.com>
References: <20261013-fix-p2p-acs-v4-0-v11-0-72cf8c96e617@nvidia.com>
 <20261013-fix-p2p-acs-v4-0-v11-12-72cf8c96e617@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 14:40:07 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> When P2PDMA rejects a mapping, existing warnings identify only the final
> ACS or host-bridge result. They omit topology, live controls, divergence
> ports, cache state, and intermediate routing decisions.
>=20
> Emit debug-level messages for verbose calculations and cache lookups.
> Report both paths, decoded ACS controls, directional decisions, host
> fallback, and the final mapping. The messages stay silent until enabled,
> and the existing warnings are unchanged.
>=20
> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> Tested-by: Tushar Dave <tdave@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-fix-p2p-ac=
s-v4-0-v11-0-72cf8c96e617@nvidia.com?part=3D12

