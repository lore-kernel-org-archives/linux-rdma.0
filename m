Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7872847C0F7
	for <linux-rdma@vger.kernel.org>; Thu, 24 Sep 2026 10:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790246512; cv=none; b=csU7wuMC0f7XluJ9voigjaaJAsflRtllLKsp6TZUalWvdwDsIB2cW9r2/TC5y4TehCbEttMS29j4xBrt4E7/+z6XNBRyR5CiAJDQ3Ht7qIKUreN99qKOm2VX1BM1hI5H64c17eu5qVxxqidWneCnLZMkhFzbydGdP7cqgvP35Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790246512; c=relaxed/simple;
	bh=9Q+kGvXtq2/I7x8EiaFwv5p1/ScVejrYTnuLQdzYXSc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ElF4ywlEJVrJsWzdaM+/+86g+TpifWd/jHVFDKV73p85zaYLnkT7DCpPsE/0R+uFPr5K7T3iWMgOKNe26rdH91rWx0/3A46xNTbKUxzKZuJtXq6jy90UvjR3XfwVzlg4rgdDHI6sqnMY6R7BcKuk0FSdpA1Q2XFByzWYKMoMJvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ncpI2IFN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ncpI2IFN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10F771F00898;
	Thu, 24 Sep 2026 10:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790246509;
	bh=9Q+kGvXtq2/I7x8EiaFwv5p1/ScVejrYTnuLQdzYXSc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ncpI2IFNjhL+nPZKFGoV0OQeCeycXT9Na6IeeWsnbRo4Xp687irp7pkSZOgLYITnQ
	 ogPD1c4dVATdTLKtmhN+VZhGRb5Qq+Kofk+a5maxCBfram3EKh72DW4VsqQhxpN8gC
	 cgZaZOXKpdEwbCMGnO7P/Aia3ubcwr3b5NlZ+I7uPyEbEY/h82VlEJPsJacX6rpC8d
	 JOXG7RhMCr21T5ppdyX5gv/uBjUTr/ZIueJdNmG/q7fs9d+D6D7oVlPbxkSandxMiq
	 CwyBFWPucUO/4dXtjfzkE7eGeJk8JipB4WKjEJuq7JHkg2M3lai1d0c/1r/10zkvFA
	 vl4f9u4rjV09Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 12/13] net/mlx5: E-switch, correct stale VF/PF
 wording in esw-allowed comments
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260923103830.1183-13-tariqt@nvidia.com>
References: <20260923103830.1183-1-tariqt@nvidia.com>
 <20260923103830.1183-13-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 10:41:48 +0000
Message-Id: <20260924104149.10F771F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Shay Drory <shayd@nvidia.com>
>=20
> mlx5_esw_hold() and mlx5_eswitch_unblock_ipsec() bail out on
> !mlx5_esw_allowed(), and their comments explained that as "a VF has no
> eswitch" / "core dev is not a PF". New FW will let a VF act as a nested
> e-switch manager - such a VF has an eswitch and passes
> mlx5_esw_allowed() - so that equivalence no longer holds. Reword the
> comments to describe the actual condition, the device is not an e-switch
> manager, with no functional change.
>=20
> Signed-off-by: Shay Drory <shayd@nvidia.com>
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> Reviewed-by: Akiva Goldberger <agoldberger@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260923103830.1183=
-1-tariqt@nvidia.com?part=3D12

