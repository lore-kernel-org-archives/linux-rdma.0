Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB6648F85E
	for <linux-rdma@vger.kernel.org>; Thu, 24 Sep 2026 10:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790246510; cv=none; b=tDDpvKbo9RUhBgySL+toQOoUJJbS5OoSLFIobgvqlVSfldpnrJoIA9ZgxWGLXPNLstTsrEUbnOrKGOq8h1HKDKrIQCeQU+67coqLOPUa1nOzSC9jP9Af4MZry9T6tpbU7UZC4VQmwwsSYJWaWFkGdvrnPBt1rVdpvueJR9qGMmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790246510; c=relaxed/simple;
	bh=VVl8GdtJDcNbpG4KSXNh1zXalJZ+m2iJFShWbeUdup4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=OG7BLWwdaFqkoz6xUipuhHD/ZYtp16RYvkZJJMo//m7HgEYw6zXK4nn8Bd4BmgZmdo9M8drHCPf3jbznDaahviSJABN449ztvo4/dWbNZnrhtILb6nsAF+XC9ePpvc3IB1g8pueB/fBqlVjwoklDoIGXNvG7M5ErDcSX08MIDsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SIU1nZHf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SIU1nZHf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 526DB1F0089E;
	Thu, 24 Sep 2026 10:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790246508;
	bh=VVl8GdtJDcNbpG4KSXNh1zXalJZ+m2iJFShWbeUdup4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SIU1nZHf7SC8GafvFQUG9uLEcIHwcHXrLeqGW+tYEddyFwREu9M+Ts+f6aEiNf53I
	 0VUcxkXh1o1J21pHJpyNb6t1Lqqhj6izyPSdrt/Iyd9XLnnu59/92EUH2JCggQgZIS
	 szQgz8Ei2k53QuJl+6Q3M9yw7hAFOYddgqLK5Vy6yINdreA8BwP2Ea6RdlUmz6ewUg
	 /f0X0RrBtnW+NtjXiGrxhNYEnFdSeY1a1Otw4lYRWooL6oj1Db2WjEDL7EhfKhphww
	 bANDqUFPxxrWxGzPBfpUWH5pIhlI4Gfp7+2CuLIy2VZeErjIGuvekJBylk4B0zAvRq
	 rDbVdHvR3au7Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 11/13] net/mlx5: LAG, drop stale
 esw_shared_ingress_acl gate from shared FDB
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260923103830.1183-12-tariqt@nvidia.com>
References: <20260923103830.1183-1-tariqt@nvidia.com>
 <20260923103830.1183-12-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 10:41:47 +0000
Message-Id: <20260924104148.526DB1F0089E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Shay Drory <shayd@nvidia.com>
>=20
> The shared-FDB support check still requires the esw_shared_ingress_acl
> capability. That capability backed the merged uplink ingress ACL, where
> the slave uplink's ingress-ACL root was pointed at the master's
> (esw_set_uplink_slave_ingress_root()). That handling was removed in
> commit 82e86a6c7109 ("net/mlx5: E-switch, remove special uplink ingress
> ACL handling") once both uplinks were tagged with the same reserved
> metadata (MLX5_ESW_METADATA_RSVD_UPLINK) - a single FDB rule then
> matches traffic from either uplink, with no shared ingress ACL involved.
>=20
> The capability check was left behind and has been dead since: the driver
> programs no shared ingress ACL, yet the check still keeps otherwise
> shared-FDB-capable devices out of shared FDB. Drop it.
>=20
> Signed-off-by: Shay Drory <shayd@nvidia.com>
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> Reviewed-by: Akiva Goldberger <agoldberger@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260923103830.1183=
-1-tariqt@nvidia.com?part=3D11

