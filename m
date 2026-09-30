Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21D03AF664
	for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 11:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790769361; cv=none; b=jJgZ0V8kdI29YReJ75DM4Hdo8G1mx/ZxLHGnp1b2ZYmXMYPFZWQ7FfSG+xzh0dnGpbgbkvcY80N/Q0a6JtWF5/gCQBzCdTQQKBvAQFUGBQAljahzOM16+RylmQ2dlRcsu79X5R5HzUp2tKO4iKMXhgzLMsI9b01j3KLGcAe0Wh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790769361; c=relaxed/simple;
	bh=ye6yVHFStF35s17NDJyCZcO2vW65lGOb0cnlkXFxrGU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=LUQMuQm9keoeGIKD+coChukZ0vtynBR7CiGsG2PKciZB0lIEmCcNcS70NyhXSCmdrwOs4Zuog46zJpHn602UlyMBwybW5VV1+xxHeaGD7h8KRv6HdTPHucfUOu3mxN7ClM2Au8r0syc+C8zMfNadz3S5UKRc1CEDsJjdHhN4gmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oJ3l0gue; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oJ3l0gue"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 589971F00893;
	Wed, 30 Sep 2026 11:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790769360;
	bh=ye6yVHFStF35s17NDJyCZcO2vW65lGOb0cnlkXFxrGU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oJ3l0guec4sJabxvC3Bl+v/ueaqgMevMTz2U5UXv/gRDpXypHrmXtymuwrXq5PXJF
	 NRaQwy4RJjDsTHT6fRwok2r+g9B0rRGz17weEEo7YQLT/tp7+GBejiftfyqxnOOvGs
	 kIkLi52B5RnX1CY5cpQkZXEXUQG5H6e0ydan/uIuzL11oYQicfc+2MCX2zpoWGL3Mt
	 9xxwi//etBrryzsKAOas1sKCC8V3io76vlDeVcWFB81hvf2scJC6GaCUqKff8jgDU1
	 XInpoG2U4GQyF2YMejIQ1jSu43gtU7f5DAY+xQGqRhu7iDnUEdGLBoURHCJGzLclX3
	 1oWiFoTtAhwzg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH mlx5-next V2 04/10] RDMA/mlx5: Give the data direct PCI
 driver a proper name
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260930114227.139274-5-tariqt@nvidia.com>
References: <20260930114227.139274-1-tariqt@nvidia.com>
 <20260930114227.139274-5-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 30 Sep 2026 11:55:59 +0000
Message-Id: <20260930115600.589971F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Dragos Tatulea <dtatulea@nvidia.com>
>=20
> The data direct PCI driver uses KBUILD_MODNAME as its driver name,
> which resolves to "mlx5_ib". This is misleading (the driver binds
> the data direct PCIe function, not an IB device) and would silently
> change to "mlx5_core" when the driver is relocated there.
>=20
> Name the driver explicitly "mlx5_dd".
>=20
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
> Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260930114227.1392=
74-1-tariqt@nvidia.com?part=3D4

