Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7709933936F;
	Mon, 12 Oct 2026 13:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791810925; cv=none; b=fUe9gVL4/wKWZmdvuaetgktNDzmZHn07ZVDVVOOueEknC/tB5C7gFrTSUuvTvw/COghYHVVWM3RYFUFIX69OaFmp1ObYsp8xLGbavk61Ek15fgkw6jU5v86jaAYb7j2HYzNZ9aUngqd0wVeYzqIweDmK70Fg/ZUGZG15+cL6/94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791810925; c=relaxed/simple;
	bh=YEFM1zCeU+S3WieHOaSiaNmgbDTa7ojyhqE8Yfkatuo=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=Cr7yphNXXg4LsexOsYHLxko3hVCX3oqswSuNaNPH38Yrj1KqfORwsWva1QgBnosgG3GAu/e5bzAqffkg11xjR/1q2Q87z+hf7h8WT9TacxFtE1r3x28+8pHgO0VxYxpNGKE8At1WZU3dKYbUysGuWZlpximvAn343ZCJmHAl6YM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GgTZ/6BA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GgTZ/6BA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F245C1F0089C;
	Mon, 12 Oct 2026 13:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791810924;
	bh=YEFM1zCeU+S3WieHOaSiaNmgbDTa7ojyhqE8Yfkatuo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GgTZ/6BACJupGnVvkVNPXYQJocRU5Dz/8p9E8w5/lB0vWBKiQH8P6MBgNekZz3Npq
	 tDtRlNs9+uAYusMdtvYzywPv2k3MuHrreLwq0D7PQb30cUMbywWsg8uJhwjCYaDD4W
	 tdKFLT956OikQpqhHXogmKVm8VPZ9VyeMSs+jRBa2HRKZ1yorvKWiE9+4d/KDPQFkE
	 YOkAbLRng2JSKcFxGY27odrXp9/ROotitJBIdSW/vraTPKpSa5cPaB+vVWShRHwBKr
	 RtJxJTK5mxx7Z1a8fIlaVRvHdwf+94Yd5haCM7k1uM7h/D/KuHpUcpkAhtfdDc55ho
	 s8wcdd5nKItsg==
Message-ID: <sashiko-outbox-168154@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v10 10/18] PCI/P2PDMA: Route Translated Requests under
 Direct Translated P2P
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org, kvm@vger.kernel.org, media-ci@linuxtv.org, dri-devel@lists.freedesktop.org
In-Reply-To: <20261012-fix-p2p-acs-v4-0-v10-10-6ffe7b7a4517@nvidia.com>
References: <20261012-fix-p2p-acs-v4-0-v10-0-6ffe7b7a4517@nvidia.com>
 <20261012-fix-p2p-acs-v4-0-v10-10-6ffe7b7a4517@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 13:15:23 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> A Downstream Port with ACS Direct Translated P2P enabled routes a Request
> whose Address Type is Translated "to the peer Egress Port without
> redirection, regardless of ACS P2P Request Redirect and ACS P2P Egress
> Control", per PCIe r7.0 sec 6.12.3. P2PDMA assumes every Request carries =
an
> Untranslated address, so it sends an ATS client through the host bridge
> even where the fabric would route it straight to the peer.
>=20
> Consult Direct Translated P2P for the PCI_P2PDMA_TLP_TRANSLATED classes.
>=20
> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> Tested-by: Tushar Dave <tdave@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012-fix-p2p-ac=
s-v4-0-v10-0-6ffe7b7a4517@nvidia.com?part=3D10

