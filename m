Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3DEC52F287;
	Tue, 22 Sep 2026 22:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790116706; cv=none; b=tCCNyW3GjFctOYJ7igHzuQ9f/zBSqKDijNUED65OzrF0gJuYoOhNO83oS00kOMBVNdWyb1ddJjuCERCW5ElAz4XA6b3LELG2lkqu4Gqw/X86rodaI4BLYTOxSEIpjlvWNQqX+xMd7u18cqX43T3FTd6eiOPaRur2h6cpVLsYVb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790116706; c=relaxed/simple;
	bh=RSA9LuIXrZNAfhNmpBCsRp6G+zxjaFaxz/nhD+sJ0Zk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=YO7CwaEXkc9l1jGamkAg1hfUaFogk7IsZQ+AE35m6yWZTsIw2RSj0Npvbl6g0D47FXd0IdRja4fpcs2SPwkLdW45GzxoPGjeayvUTy0fbmfZrznj4hHTJve5du2NbJUxBPu1vCqBYS3PBzQILrvwGCbfJsbRMVIPLsI5atSWf5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JCSR59U6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JCSR59U6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 651431F0089D;
	Tue, 22 Sep 2026 22:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790116687;
	bh=RSA9LuIXrZNAfhNmpBCsRp6G+zxjaFaxz/nhD+sJ0Zk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JCSR59U6cxl6kdrdYgiAW1e3keoYYf1uQj+mWkdpMKEOk7f4EylWg+MoO0abImAls
	 bGIKplL2qspKxDRipMHCO2FeH/cdqerZ2GJxx4xH8ARbS2l4de9F1AW2c2RA4J4A8j
	 y3Hh9LY+A7RzlpFOg2s1OPfh7zZJzEa/8CB78684zJcM7QK8S5bUp/JXjn3r+CwTK2
	 wdkPiI77h0rThyAwDVW+CcUc6zQ6+wtBXVm8bPRXISB7EzIFUvC+neQ0cWrhwGVOiw
	 yrU0prUK8vTGbs38pR+dI6Hq5bdoeUUXoaLdwdsrmFhNhgsS/XHnfelEVZ3kkSoyl3
	 czwKl4oNv7D/g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 06/10] vfio: selftests: Allow drivers to specify
 required region size
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jason Gunthorpe" <jgg@nvidia.com>
Cc: kvm@vger.kernel.org, linux-rdma@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, "Oliver
 Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <6-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>
References: <6-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 22:38:07 +0000
Message-Id: <20260922223807.651431F0089D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Add a region_size field to struct vfio_pci_driver_ops so drivers can
> declare how much DMA-mapped region they need. The mlx5 driver will need
> ~18MB for firmware pages. Existing drivers pass in the sizeof their state
> struct. Since drivers all use only their declared state we can use the
> value directly and remove the SZ_2M hard coding.
>=20
> Assisted-by: Claude:claude-opus-4.6
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/0-v7-c6d30e8ce1e4+3=
dfa6-mlx5st_jgg@nvidia.com?part=3D6

