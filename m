Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022022;
	b=P1VwGGSavgbp3EOgSjQaZYLVVrstFMq7CY4guUr+Udg8yZoMQvwXZJM3KEBuLZUVPTj+
	 LMHYtRYNXp26UL40QxMb1muwpe7BHaXgg0uxusMrjG55JpzgeemTp82KZ1FkDB2CExZpp
	 qm96a+GuNVnZffnBI83UofyoGTaMi2Pcq9V2YuAOkXEcqhkQ+9LtgrW35VynWrp6R6Duw
	 /hmR2j/mRajo8tWPL/0kFS4SNTURoTQK4hmiz+kap5bnkcsW9ozmETbdsf0Fbm2Nb2zMh
	 SNPsvB73ZdpFruY8DWrePGSibQ74vE8zDjljkjQo/USw3bkPh+9r6yVElflKUMaWazw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022022;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=fCS3fEufdLQzeES/9QpB3/BfJ17vaBSgUrR+D9QO/jE=;
	b=gak57hn7a6j0SLBGr8PyUgNiPc6ukrIKrbiQC42tM+7uvkTCwEZ2d3zYEbSxvpFTtLba
	 UhViujeekG5Wacyo0GqLquYHvqrrKAQ+GkIr1agozyQX3KljrDzndsOrVLzlKd3/xHYPU
	 24JnBtPDeNVkBJA4wk6MEctkNlF7r6J34XznDkvCZhYlvEWkYxMkihe4EbrnjrHFNs+pm
	 H9Ixf0rUjQyrcrS/GmNq+eJEF9XZuDiIDiixFVPIIPQQ70fLwE+zlBB60fqtskJEClNDj
	 qYDuX+QRGbSSX2ZinwN/+Xpjpj0IB2Ed4fAy6GZTrEeMeOK7+nzYvO2B677ZFFJvBaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A3f3JIHB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0477E606A339
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 17:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A3f3JIHB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B81FF1F000C6;
	Wed, 18 Nov 2026 17:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795022021;
	bh=fCS3fEufdLQzeES/9QpB3/BfJ17vaBSgUrR+D9QO/jE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=A3f3JIHBeI7zAPCY80GGI4np8dwdCZTar4P90S4W1msZ/e0BljWzZHMJgApSpewVj
	 tsjql2dDhnT34s7ELtLUGgS6FN7oLDKTqN84TtW+83ZTwiuoQx78XXjxZtVfKVmQ++
	 1mVSiKJTvL81cDFu//HIXxNj1joErxgD+a/uxTSLmeWN6UAuWUZ02O5CiWrud0rFQs
	 BzF4Dq/3UkcHMuZqu8nOn+Z9pYaoSkIVlErO9EHDffwSAKfb+bCOvfWDJWCsXgN4KT
	 MpiYiDl1EF4OaWgu3HlSDolvs03vsInb0kALdPuEIDHsR6Ky6y3c9wq2yNivMmdsoF
	 ZeJdEIi+xid0Q==
Message-ID: <sashiko-outbox-221604@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V2 rdma-next 03/21] net/mlx5: Add capability filtering
 in adversarial mode
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117170914.27410-4-yishaih@nvidia.com>
References: <20261117170914.27410-1-yishaih@nvidia.com>
 <20261117170914.27410-4-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 17:13:41 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Dragos Tatulea <dtatulea@nvidia.com>
>=20
> When in adversarial mode, trust only a subset of capabilities
> and do some additional validations.
>=20
> Start off by clearing all firmware capabilities and enabling
> them one by one. Some numeric capabilities are validated.
> Unexpected values will trigger a driver load failure flow.
>=20
> Where it applies, the filtering is done on both current and max caps.
> Allowed capabilities are simply passed through. Clamped and checked
> capabilities also apply to max values.
>=20
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117170914.2741=
0-1-yishaih@nvidia.com?part=3D3

