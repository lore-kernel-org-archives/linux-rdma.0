Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28DD2485CEA;
	Thu,  1 Oct 2026 12:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790856164; cv=none; b=KmkT95U8wxaGju6dEEK/xCo9048P5GRTlExOOuJ+uZAaRQrrwlwfpJi8AiINUPhIVTNbthuRfuSQcOmmhUDIVE4lclBFJuQ/K90Eb0Lk3Cj/r+A3UOM3/oHqqNuaPhA0Ft7JadMTwxFZi1hh6GVwIzN3jrOl2Wr2sqaCOGl1ISA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790856164; c=relaxed/simple;
	bh=144qZN6CK5nkadRh+grZbQAx/hsRy8TadxTdBV5k+BY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=r4Fm8n468s0rMHNYdduotxptsDra+I17TJ2qYosYLoTx23B4oUvqLtIry0C76YXIjev3A4H/DEMFtK3fET5iG7mPq3ehp7HQ7HqK02HiqSV9bB+3GirmwtowiG9eCjP6LyO4eFGepSbCj/lZaU6/bYGTAx7So0Ka9PhTsvfnEF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RUPNXfU7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RUPNXfU7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F261F000FF;
	Thu,  1 Oct 2026 12:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790856162;
	bh=144qZN6CK5nkadRh+grZbQAx/hsRy8TadxTdBV5k+BY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RUPNXfU7jxyyd3QWIBwdQcb8vL/qCa2UlwVaxHjtgyu4HrD/mOJdR8vffpmYRcZJd
	 8Kif4rARiqqYlT4A8K07GXCULsQnJkliprMyBXmz9ZTWgbZDbRgccxKMUEVnkyhWoR
	 iXJUe6rLs4unYbvS89r7vUQJo60hCdKCKR4Fbll8s/PF+U35MyxXSh60eM/UoJed/q
	 rdicIIyLdL0Ghvhpuwhu2qzcBTOpj9C3tiSHHM1Pc8A9P8DwCtq86V8FDU5GdVTuZX
	 22KUnN3QwQ5Y0baLavbhlf5MMj/GPQ5KrTRTEoIulEpI4xf+g7/RSVTQ3TKRaUaJrL
	 BdHoSU/6oezJw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 10/18] PCI/P2PDMA: Route Translated Requests under
 Direct Translated P2P
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, kvm@vger.kernel.org, linux-pci@vger.kernel.org, media-ci@linuxtv.org, dri-devel@lists.freedesktop.org
In-Reply-To: <20261001-fix-p2p-acs-v4-0-v9-10-1a8e0f50ddd9@nvidia.com>
References: <20261001-fix-p2p-acs-v4-0-v9-0-1a8e0f50ddd9@nvidia.com>
 <20261001-fix-p2p-acs-v4-0-v9-10-1a8e0f50ddd9@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 12:02:42 +0000
Message-Id: <20261001120242.70F261F000FF@smtp.kernel.org>
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
> Add PCI_P2PDMA_TLP_TRANSLATED and consult Direct Translated P2P for the
> Requests it describes.
>=20
> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> Tested-by: Tushar Dave <tdave@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001-fix-p2p-ac=
s-v4-0-v9-0-1a8e0f50ddd9@nvidia.com?part=3D10

