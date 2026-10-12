Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1F983E7BD5;
	Mon, 12 Oct 2026 13:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791810918; cv=none; b=bqboyU2P8rbx6Np5tYyk+yMsHr4tSmKR3jbjZoFPPVYkLXUbibOE+irwB4MUXWavPfC3XVJIaYTcRxdOMl2RlDMLHam/8s0fMREHT4FfxcKOX0JqBAos+zL1JK3SwePdl6cvJ0SaVZfJYbBKeo7MZze6Z8E96183UwbDwi3oKKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791810918; c=relaxed/simple;
	bh=Secd611NVld8zSX1i8AQkJaQNh8sE93RTRF/gDHE/mY=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=JE1CPtrucBxKcdvlv8hCOiagBnzsPXFFH5fSVxYniGInsa+ag9m+YhE5p9Dv6WBVCGzcK0t3swKKihTcjGWiYn2JET+GblgnlaKH0iiE8nLGVOyeAU5XaaY02PNVJLvSuhEFuZsvjAvEFsXL2M+PuLqxz8FDJKplGiTI9OLOCKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=algrs0+y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="algrs0+y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A8EF1F0089B;
	Mon, 12 Oct 2026 13:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791810917;
	bh=pbwolV2gpLlhco6YnOqT4f0AFWu7v8BeH4SkpDuXrms=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=algrs0+yoH1mDGhKhiinVo4Tojv/6YsugbCK8b5gMgSmwb+By68xiMTvfEUg14eas
	 4MrEsFDZntb28NSPVZrl21Q1tcJXZnZCP9ovv71msbBleWC/5vmgmspv00gJ0J8GKu
	 ur5klKTANWlCw61b+3SawqWTY5DKOv9hp/Ms4MogqJd32hqLEvQ1WsQ/SlKK9yP2Wc
	 FMSRFaRYjxWu0OkMeOdWdnVg4kbhNDMCPTjQg4A3wz+5A//xUuK5sRUpKpPT4Ny16G
	 FnDiLDVHfftJqTVIPMToImL+HdHOUy/yc+0YIEK6CfH724feJ2beZWQLAtr7hb4OUz
	 7VU2OBZsRj5RQ==
Message-ID: <sashiko-outbox-168152@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v10 04/18] PCI/P2PDMA: Evaluate ACS controls at the path
 divergence
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, media-ci@linuxtv.org, kvm@vger.kernel.org, linux-pci@vger.kernel.org, dri-devel@lists.freedesktop.org
In-Reply-To: <20261012-fix-p2p-acs-v4-0-v10-4-6ffe7b7a4517@nvidia.com>
References: <20261012-fix-p2p-acs-v4-0-v10-0-6ffe7b7a4517@nvidia.com>
 <20261012-fix-p2p-acs-v4-0-v10-4-6ffe7b7a4517@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 13:15:17 +0000
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
>     Host bridge 1      Host bridge 2
>           |                  |
>     PCIe switch 1      PCIe switch 2
>        |     |               |
>        A     B               C
>=20
> A's and B's paths diverge in switch 1. A and C share no upstream bridge,
> so no direct route exists for ACS to gate.
>=20
> Evaluate Request controls on the Requester-side divergence port and
> Completion Redirect on the Completer-side port and reject an unreadable A=
CS
> Control register.
>=20
> Fixes: 52916982af48 ("PCI/P2PDMA: Support peer-to-peer memory")
> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> Tested-by: Tushar Dave <tdave@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012-fix-p2p-ac=
s-v4-0-v10-0-6ffe7b7a4517@nvidia.com?part=3D4

