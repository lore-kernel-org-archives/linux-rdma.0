Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 536A532AAD6
	for <linux-rdma@vger.kernel.org>; Fri,  9 Oct 2026 13:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791552664; cv=none; b=d385jAoQ9hX3vZAUGCtcS60qRPX6nIKBO4z4puiIA2QhL5101Czuq9LUq8Gase08Bg+GJcAxtxfhrcEe4mzm4+OpDrEoymGIreVXc3ikDsEW8432H2K7CpDMJe2l4vwyahZyT/3wW01uaJm4F5yIv0fLmel3vu1ey8rWHZCRoak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791552664; c=relaxed/simple;
	bh=J2sDPDbJ+ljOZ1mQkcNERcHEbdAlTvGifqi8pd3/IYc=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=hd2oNmpoFSFrFAFv46UBaEQvStOXZ5YtD63gMBS/0+nfa5lM1+FiIOSeiydbyDS7Ea0qGd+ZcBnyM8oh62K6rf5BxkYz3jJPFMvg0g4yUQrU8U5p1KkSdb+BEXUjB/EtyhqFU3tRPANxF2O8+950jfQOawsUJA+R2CiyUFlgHPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mxKHWLm5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mxKHWLm5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9A7B1F00893;
	Fri,  9 Oct 2026 13:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791552663;
	bh=J2sDPDbJ+ljOZ1mQkcNERcHEbdAlTvGifqi8pd3/IYc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mxKHWLm5PtMHNJixqDL17+MHNWQ77TCybZUaX3cbOAZPFercUrIyFj0QXhA3STyIB
	 LHjTKPERvmELOm/rAcSfppyJHnRCtImf6CTBtoG9nUSwjFCYZ7GfrtvlUQFYki4zc2
	 LPoqiWzZGEswZiFTpumfiL+YC9fRGNhjeogJAfR5bFQf5wYugBEU0UhVzG7xlWhQXi
	 fkf70UsmEYqyqsyRR//PFfpEaPgEO0jMJUW2bktS9ivAYEP95ixHXyYZ47RzGPBDdQ
	 VpbODJ593mlU3fM7lDkHmI0/z3jRHTiM07lu2M6EkWNeyjgw0trwp2dly8zw/2tN01
	 Hfe5imM2orZ5A==
Message-ID: <sashiko-outbox-165636@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 02/10] net/mlx5e: Register supported netdevs as
 data direct users
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261008132815.654147-3-tariqt@nvidia.com>
References: <20261008132815.654147-1-tariqt@nvidia.com>
 <20261008132815.654147-3-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 13:31:02 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Dragos Tatulea <dtatulea@nvidia.com>
>=20
> Register the netdev as a data direct user so it is notified when the
> affiliated data direct device is unbound.
>=20
> Register during NIC enable and unregister during disable so suspend
> and resume follow the data direct registration lifetime in mlx5_core.
>=20
> The notifier callback only traces the unbind event for now; tearing down
> the data direct datapath is wired up together with that datapath in
> later patches.
>=20
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008132815.6541=
47-1-tariqt@nvidia.com?part=3D2

