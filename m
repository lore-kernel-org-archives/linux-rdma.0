Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71BDF4FDA4E;
	Thu,  1 Oct 2026 12:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790856142; cv=none; b=pIIBpIF5k2docHM794dKOgFhb2yBzO3jLNeQRt5EIDSIphmEJi9eBZaKRcCu/tRFGQ93hNMtpQTaoEti2DCfWIIpgJb0RaRqdDcdq8QxmaLTTwgHt2Pf5ysSUz0DDUWeVC9YTKpHhsBzTMt+oJligCr9SuLxkqxiKT2jbM1+X3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790856142; c=relaxed/simple;
	bh=J7Fz2fGdas5nxrosVdDGPjVhOboZiCIyF6h6TA5VWQg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=cPIii2E+bd/IfayjXTO1rXd2VkKWw1Y7QyyvN7AKEiNP54l36z9vhywcG6aijsXrOHSEwOFG6g3fFWAqVmvL8CAwTuusybY3tVIYhJfC9mr8RPWTOzTLVM6XJ6FxgPXbG0R/E6PoHw+xjlxFw5BSWezTHt9+HSHQfLQkj0QJHsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FDyw4QA6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FDyw4QA6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B2F81F00898;
	Thu,  1 Oct 2026 12:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790856141;
	bh=J7Fz2fGdas5nxrosVdDGPjVhOboZiCIyF6h6TA5VWQg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FDyw4QA6zHe1gLo+paZPiy4GOkYwGI8cjysK+I1ZvtKGxLf4xIVSswWH9uaWHxxeX
	 P7kG48C9DNacdZEzaqhc8nY/tnAO0aIfX0xHH4JTr4WjitnChcZZgzEUT4GlAg8jQ+
	 EnFYNqaVLVdOpMKAj1jpR5HJpvUul/dArhQqQz2qKOrHHjyRKd5isTtwV7jFe49s0H
	 rx7O9l6nZqLW5ctriMbSQMk61I8d68bYiq9tsTp7lUIqbYPHGHxXIOQ8XcwqV/9xYi
	 Afn4j9EpPvbABjgSJURsx2Q3+XMLOWZyQZsy8WNlyFX1dzyMIKOtONjLlDTwZ+LmpS
	 JtVinbG1S/D3g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 04/18] PCI/P2PDMA: Evaluate ACS controls at the path
 divergence
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, media-ci@linuxtv.org, kvm@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-pci@vger.kernel.org
In-Reply-To: <20261001-fix-p2p-acs-v4-0-v9-4-1a8e0f50ddd9@nvidia.com>
References: <20261001-fix-p2p-acs-v4-0-v9-0-1a8e0f50ddd9@nvidia.com>
 <20261001-fix-p2p-acs-v4-0-v9-4-1a8e0f50ddd9@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 12:02:20 +0000
Message-Id: <20261001120221.0B2F81F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> ACS redirect controls choose between peer and upstream routes only at the
> path divergence. Applying them below that point rejects valid nested
> topologies because traffic already has only an upstream route.
>=20
> Evaluate Request controls on the client-side divergence port and Completi=
on
> Redirect on the provider-side port and reject an unreadable ACS Control
> register.
>=20
> Fixes: 52916982af48 ("PCI/P2PDMA: Support peer-to-peer memory")
> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> Tested-by: Tushar Dave <tdave@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001-fix-p2p-ac=
s-v4-0-v9-0-1a8e0f50ddd9@nvidia.com?part=3D4

