Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A053FE652
	for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 19:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792006443; cv=none; b=sBs5OBQGTk+6ugJtLuy3uasyfmY+rWVl/G6r0JrWQvI/LgJvn0rIa7Shs+rbq2eE9QeuyMEhlzbhADjCEqlg00DQAtc9IuMMx1p8bod/ZUOTedc6VugbKWxvodGtep0afSr23aJT6UXLb/SbCpYcSmutiYDGoIp59Qu/gmj+fic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792006443; c=relaxed/simple;
	bh=p3Tv1GZl/1Apf3jK/e6AN8+azKF5CvJLj4FClmFgTr8=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=YaRm+sMWBaHJ+Lc4RP5H6yLK4YI07tprZXZj7yaEPRvi7ghOUFTQWCGm0fxDBAzvuvkeZM1dq9gZSCiX8lCUS+h8c0S9dGgPaMIgCanE6Fm8UqYREoBY0Y58I1ESAbP/NioFk5jOE1ZnXpPCwDLKzZBZ8YnpIz/9l0h5ZqFYdDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f0tTW66j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f0tTW66j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E1801F000C5;
	Wed, 14 Oct 2026 19:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792006442;
	bh=p3Tv1GZl/1Apf3jK/e6AN8+azKF5CvJLj4FClmFgTr8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=f0tTW66j7DT0wFVC9ffxLXCNONAXHyPDbFL/CSHvemAgy1EQ33U0ySxOQGoMYvmnM
	 NlvkxEVeXPbwAHZMIpRFwPqIf4mKpcNVr3qBVMbP6o88bcCvQ903Cw7TBGPGfU/nvj
	 myJOGofPgg7XOLqpg+VROshLkCxLfscyc9FJPbNBP4GMuzbLJGXj/eIPayAhC4Fmxm
	 CvyQiLzWBMYjbYb0D5Mv+swDvVWKpfORZ6/t7owxF7g6uV0crUqrFENYNu1Ph0uRBB
	 nsBBSdjGuT4s+/jUWAHfBb+oeo6u6GQx7cowAfvj0oGvWsVJWlt3NY8lDyqKAYpAdd
	 l3sifGFpeys7w==
Message-ID: <sashiko-outbox-171794@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6.6.y 2/2] net/mlx5e: Pass netdev to
 mlx5e_destroy_netdev instead of priv
Reply-To: sashiko-reviews@lists.linux.dev
To: "Artem Dinaburg" <artem@trailofbits.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261014191738.24034-3-artem@trailofbits.com>
References: <20261014191738.24034-1-artem@trailofbits.com>
 <20261014191738.24034-3-artem@trailofbits.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 19:34:01 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Saeed Mahameed <saeedm@nvidia.com>
>=20
> [ Upstream commit 4ef8512e1427111f7ba92b4a847d181ff0aeec42 ]
>=20
> mlx5e_priv is an unstable structure that can be memset(0) if profile
> attaching fails.
>=20
> Pass netdev to mlx5e_destroy_netdev() to guarantee it will work on a
> valid netdev.
>=20
> On mlx5e_remove: Check validity of priv->profile, before attempting
> to cleanup any resources that might be not there.
>=20
> This fixes a kernel oops in mlx5e_remove when switchdev mode fails due
> to change profile failure.
> [ ... ]
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> Link: https://patch.msgid.link/20260108212657.25090-4-saeed@kernel.org
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Assisted-by: LLM
> Signed-off-by: Artem Dinaburg <artem@trailofbits.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014191738.2403=
4-1-artem@trailofbits.com?part=3D2

