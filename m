Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D45D4C33E9
	for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 11:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790769363; cv=none; b=nEXzkpxY/XPNTe8JNIm5dnT8detkmwMNl82gzEBaM/PJKgzAQgMgD8LQm6oCYbt3hTZuPez6YoJPhRLdtO/7O5+sRJCfdur9PIjqV/hcT2VlSsV4joljl+iPjRZFVrDN5LTejUhCBjTs7lAuFWWuL29uUM46aVuD9Eao3ZpPvvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790769363; c=relaxed/simple;
	bh=sXM5hmNODvv4Q4/Z+GA2aLyl3JbV/ZCwXR39wWNLNSo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=fOAJoNFPMFRJ9Xwd3Hhv46iCnPhB38SmdxIyajUkUCx542NKiv+JZcbzG5lGv4x2X8EI/dL+5jTuxQJaK9+G6V5Qk3pNFV7eNG4MFUAd+2+Vwn+6kgzjmhNXsqYRyOaLujWJC6R0fHYCHAh4Py5ATCBXGNuM6ysuz1YqfTYyzRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IQna3DLh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IQna3DLh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA7CF1F000FF;
	Wed, 30 Sep 2026 11:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790769361;
	bh=sXM5hmNODvv4Q4/Z+GA2aLyl3JbV/ZCwXR39wWNLNSo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IQna3DLhkzu6N9Z6FLiHiEVkR9/yryfEwVI7p+PLyM6KiHGFqjNVs9IDKBYsotcax
	 J13PHCwC4uiWUix8lT94NE37pyG/4znEyeQ+fKw+1sajfH72fjwljtfk+fEFjQvvmH
	 D7H9UyqHn9fXX6bAOZOKTF3Z9r8HKmClgzNLv1seBUtroguy0N+nC5vJaja4StrbtS
	 NjYXfmE4gMyZp9biYCWq81fcKBdrpwocGleZKnQJKnLy9U171UpckGehdfBcm85s0r
	 Rg6UU0RO5Ch1djmXsR8NQcDWvT81Yvi0iiapyeC3CoDiJIG1WSj34g6y89QKZKTUNh
	 qds5uGvd2pVnA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH mlx5-next V2 03/10] RDMA/mlx5: Make the data direct VUID
 query self-contained
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260930114227.139274-4-tariqt@nvidia.com>
References: <20260930114227.139274-1-tariqt@nvidia.com>
 <20260930114227.139274-4-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 30 Sep 2026 11:56:01 +0000
Message-Id: <20260930115601.AA7CF1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Dragos Tatulea <dtatulea@nvidia.com>
>=20
> mlx5_cmd_query_vuid() in cmd.c is generic over the data_direct flag but
> its only caller is the data direct init path, which always passes
> data_direct=3Dtrue.
>=20
> Move it into data_direct.c as mlx5_data_direct_query_vuid(), dropping
> the always-true parameter and hardcoding data_direct=3D1. This groups the
> query with the rest of the data direct code so that it travels together
> when the data direct matching code is relocated to mlx5_core, and lets
> it become static there once the query is folded into the core bind path.
>=20
> This function will become private in a subsequent patch.
>=20
> No functional change.
>=20
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
> Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260930114227.1392=
74-1-tariqt@nvidia.com?part=3D3

