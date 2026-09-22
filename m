Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51AE847F794
	for <linux-rdma@vger.kernel.org>; Tue, 22 Sep 2026 13:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790085531; cv=none; b=Xq4c7ynQgI1UX1iVloF1uCcP1E36TntOWxkHWrFSgb+QundPg6R+3BHTbgJBpMq9pOCdKHm0AvEvp1XweVErM/3x/7FrhEJj4Txast+iFQwuBap+Sd8n8jEAzfmSKFoyfPgB59ZYclZh1ngWZMlcNrx9BnxMffz2g3X6G1qJJJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790085531; c=relaxed/simple;
	bh=V1lBLb1yyziLYCVJq7ylnVSycqRGNFiEsNZMP8ojuZQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hpEZlAL9i6EqjoSaI6lg6LN5y3JXhzBYXxy/+BO+VBqwaZ3/FDni7HWaNjRPTuPFrhEk3xxEtODOXB+IXdeEGtwmRS7NeFR38dIfgPIqVP4aQMaSFteYvLfeNqE6Fwo1SSMrMzn9mHQEWYNP1EpMWEAR/oEmReGC0VcxqO49USA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jHpwz97z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jHpwz97z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D848C1F000FF;
	Tue, 22 Sep 2026 13:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790085530;
	bh=V1lBLb1yyziLYCVJq7ylnVSycqRGNFiEsNZMP8ojuZQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jHpwz97zp8FAuTVBkLZoa66y28e7n/BwDgNRrX7xOjZkDwiQpK+dsPzs2+k/e6pXF
	 nSNYWnk08CoNnASrkg/JDA/igF0ttZWpqE/Vm+Jy0Yj9rWSSCYVSAzGtDNQnmKXR9d
	 IRTUmnWt9bvwcyA3XsK9QHDswhY8cxdfNV6HkewGxwq4bRtMFvBWVEEVZ1hkVwPsWu
	 k248UX86rlyeRfW5uMTRWz7m3iTlITo85o+cDuMfkL3+nrS2p5J0PdDsBKXNQZSdcT
	 9hChuDbYRrI+L3JrH/T2UKzRpBvIuG+V4XdPFd4HCbIfB2lAZfr2cAOxtYMrH4Hm5f
	 q5Z6DHNvs9o3Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/mlx5: Fix slab-out-of-bounds when handling team
 device events
Reply-To: sashiko-reviews@lists.linux.dev
To: "Anirudh Virdi" <avirdi@redhat.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260922135123.46205-1-avirdi@redhat.com>
References: <20260922135123.46205-1-avirdi@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 13:58:49 +0000
Message-Id: <20260922135849.D848C1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> The mlx5_handle_changeupper_event() and mlx5_handle_changeinfodata_event()
> functions assume the upper device is a bonding device and call bonding-
> specific
> APIs like bond_slave_get_rcu() and bond_is_slave_inactive().
>=20
> When a device is enslaved to a team master instead of bonding, the code
> attempts to access the team_port structure as if it were a bond slave
> structure. Since team_port is smaller than slave, this causes KASAN to
> detect an out-of-bounds memory access.
>=20
> Fix this by checking explicitly for bonding devices using
> netif_is_bond_master() instead of the generic netif_is_lag_master() which
> includes both bonding and team devices. This ensures mlx5 only processes
> bonding events, not team events, preventing the invalid memory access.
>=20
> Tested with Mellanox ConnectX-5 on Linux 7.2.0-rc6:
> - Bonding: PASS (no regressions)
> - Team device: PASS (no KASAN errors)
>=20
> Fixes: 54493a08e21f ("net/mlx5: Lag, record inactive state of bond device=
")
> Signed-off-by: Anirudh Virdi <avirdi@redhat.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922135123.4620=
5-1-avirdi@redhat.com?part=3D1

