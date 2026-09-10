Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A50D136196E
	for <linux-rdma@vger.kernel.org>; Thu, 10 Sep 2026 10:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789037191; cv=none; b=Er3lxltv14FoijUJ7i1DQq5QYOQEC66844k2ExS3UhoUhDEo8NUHTiy0cr81R4YRYIeIGFd9MLNCqgMfDj+85p0MnyJHXPE/FGZmvFb3ehUwcGBdIRFbWaMSmaPzBRbtczrJyjWGw8ro6IdLzgksuvAfIa+WyKrDlAj5F6HLGtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789037191; c=relaxed/simple;
	bh=vRM28poga4FKKFokN7iAkWbTGLNFoC3BkcmsmJHBMJ4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=A6chGskL64CRVAOCxmKCMsrReYJMAwAXOtWS8fF6X0PaJPEZaaErX7se9RpvXA0a2CLyRZk0Qbw8F36xiX/VLDRlkRqaX5CXd78Y3WjLhq9NKNkokpeBHptIqOmUOkNHF1Q9Nbm29xD1UgUgZFeu0kvAcJ5Gdzy8W/N+CjQLycE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fkb9iuEm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fkb9iuEm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66DEA1F00893;
	Thu, 10 Sep 2026 10:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789037190;
	bh=8KtKypASmn/3njJhuy20loBTUs9fKwq4oR4B1jXu+ek=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Fkb9iuEme5GUsuJcA57EjwCmaEFWC4SsIj7IPxPyyO5S/wuhAu37Sz/1MyCsoJ6n+
	 P9HBEhtozkqfXScDG1KH0XtreUf3cijdVXO0QwewkK7CsDBFxASe87EQlEK7oVpQwp
	 D9nVeLsvRL0/snrScWnfQPbkmcTJx3ADGRDDGvW7GCj2RTEJjs8odB6OFXVliQOSoN
	 el7iNI4bvmLO+LbMvAqTu/z09j+wGu+GnL51eVipE13KD9xfQDwSBGYzwAav4xqBtx
	 pbu/QxhY70IDrg+fRkrFYyBlGW/z/u/GgA4HipflTN4jPZXMYdXkpyuVdmBxWDIB7G
	 3VkDjgbxR4utA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net 1/5] net/mlx5: Lag, split aggregate speed into oper
 and max helpers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260910102432.3845360-2-tariqt@nvidia.com>
References: <20260910102432.3845360-1-tariqt@nvidia.com>
 <20260910102432.3845360-2-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 10 Sep 2026 10:46:30 +0000
Message-Id: <20260910104630.66DEA1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Or Har-Toov <ohartoov@nvidia.com>
>=20
> Split mlx5_lag_sum_devices_speed into mlx5_lag_get_devices_oper_speed
> and mlx5_lag_get_devices_max_speed. The oper function reflects only
> the speed currently available and the max function is state-independent
> and represents the maximum achievable speed, taking the best single
> port for active-backup and summing all ports for XOR, LACP and MPESW.
>=20
> The oper function skips a port for two reasons:
> - the bonding driver set tx_enabled=3Dfalse - LACP converging or
>   active-backup standby slave, where carrier may still be up but the
>   port is intentionally not forwarding traffic.
> - the link is down.
>=20
> Fixes: 50f1d188c580 ("net/mlx5: Propagate LAG effective max_tx_speed to v=
ports")
> Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
> Reviewed-by: Shay Drori <shayd@nvidia.com>
> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260910102432.3845=
360-1-tariqt@nvidia.com?part=3D1

