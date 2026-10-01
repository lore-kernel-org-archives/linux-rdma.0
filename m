Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA35F49BD60;
	Thu,  1 Oct 2026 12:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790856141; cv=none; b=IqPkaIdzEenx3BjDSyk9Dn5kXkjqRDpyjvstdWkc2CwwVjRJ4PnEVBnp8MuRYIoSy0a8TDktQIrLasFHnDCHhcpuIv3dvXJ8LAEtipL7t8M1H6VT+0P6L7WIJk5caKq3PrYxcqUAfUqMwb5bol5gTLm1PfGerMJ0PIRda9Ub060=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790856141; c=relaxed/simple;
	bh=zpy0LRhjqnKx679O4dYdg/EdudqFhuUZwCGO46JumkY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bNVdkSHRst4EBzTSdy9lFJ+qoLMHOu8eDCWtw0huVV8SqB9oeGBBqjYyTZM9BaUJzg2QmJ2Xz1s19dm5T2/QEp7uGZd2nFjqFiZjFqBrxUYSgKb/fS7u0++1D7U6TCZt3XbEbV0y9c29rvldlHwwSbPW9Nuh4bG//O4rBDQHJdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SOAx6eO1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SOAx6eO1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35C231F000FF;
	Thu,  1 Oct 2026 12:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790856140;
	bh=zpy0LRhjqnKx679O4dYdg/EdudqFhuUZwCGO46JumkY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SOAx6eO1/Jm9V2Khk+HeJSx+zwKSFXrrxJ8YC/1W6o3kxDvpSawwllYEqEhHa3OQG
	 GY8MXnwDySGgaayGG55sEw2b8PiRzUr7r5+ctfrQIT4BX0bHJTDqApOgwzXziME1Vc
	 rWdVLCXC8gp7NkwYkpMyEczm3iCa3dO6g9dPTKVfJ+P5stA8RZGXD0dxuUYn7huLgJ
	 YRTg43FTE5IoMqMIimn+Py+XuUi4p1lyw/LvMCpZ7fdcBjGjmOHMD9FwcQ9sVWam0o
	 NOYRoJwOViK/w0UdTKDAIqDoREVxIx8mz4FtJui2xkB3V9Tt/iPVAW6ajtOhwyFFXv
	 E5EcnfMVYAnHA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 14/18] PCI: Add KUnit coverage for ACS isolation
 checks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, kvm@vger.kernel.org, media-ci@linuxtv.org, linux-pci@vger.kernel.org, dri-devel@lists.freedesktop.org
In-Reply-To: <20261001-fix-p2p-acs-v4-0-v9-14-1a8e0f50ddd9@nvidia.com>
References: <20261001-fix-p2p-acs-v4-0-v9-0-1a8e0f50ddd9@nvidia.com>
 <20261001-fix-p2p-acs-v4-0-v9-14-1a8e0f50ddd9@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 12:02:19 +0000
Message-Id: <20261001120220.35C231F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> Direct Translated P2P does not weaken IOMMU isolation because a Translated
> Request carries an address supplied by the IOMMU. Config-space read
> failures, however, leave ACS state unknown and must not report isolation.
>=20
> Exercise both cases with fake config-space operations. Also cover missing
> and unrequested controls and a missing ACS capability.
>=20
> Tested-by: Tushar Dave <tdave@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001-fix-p2p-ac=
s-v4-0-v9-0-1a8e0f50ddd9@nvidia.com?part=3D14

