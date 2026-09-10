Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA583EC825
	for <linux-rdma@vger.kernel.org>; Thu, 10 Sep 2026 10:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789037189; cv=none; b=JZG+h99i4wwMv0c6+tmADfvdKzZNp5wGoDdQGkUx2LT2xNEz9rhL6mVR6IGxl5RBftAGJ9u1kTk2cOY2h3N6PQGMl3JkNUitpyiD3cOQBbpQGfQtT0DaTRRBva/Q4CUNWKOFgvOtN/OLLgaNFuTyN3LyOn7phXr0GtTrWTq7Jsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789037189; c=relaxed/simple;
	bh=l2ZB0sXwJeZnfGEweIQp7W8QIJtmT4slaSgJ+L4aHuQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tTR6aiJry4aRIYFuzTsVBiSkeegrgvjCywOqf4yIUnqZM8CGlm2DC9851IdUgK2EqKMSKkaKOf3e4T6nLOftCN6EcXJSFjM2Rw6ZQxAHp2dTT+fdAb0NhB/ZCGEdhiDSuRgk1FMjOYWi3zOd726i13acXut5vPheZpvMgPwX3O0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UsgNA4F/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UsgNA4F/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5C251F000FF;
	Thu, 10 Sep 2026 10:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789037187;
	bh=l2ZB0sXwJeZnfGEweIQp7W8QIJtmT4slaSgJ+L4aHuQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UsgNA4F/PtUG+VXG40qS+I6EPGYNj9ubTKUrFyACGVPBe3go893iRvIl6Wy/AjpLZ
	 Z7FfhVQpVM8HStF0AyPTmAsxbbQmpiL4wM8pwJQ5G81UiXp2qpEZr0rvKpC/igv+iM
	 ZyEZocAUfM+TIP55lYjTsBersNqpaup5pH3ZrXd4wjYXJVTSI0kmsVjAhmB36UcyoY
	 7DuWG+dTCFHH4u0rTzbrzNnglWtW2gsAkyi9+Or1A86g5ochhWB7t6tTWNSDbfXfVL
	 nzE8ldD3Zb3+WGxB9vhOGh5tjRWhyrKRImwWmA0eMEVaKUbHQNUQQZDyScHAFE5y3v
	 Rrn48X+azaV6w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net 2/5] net/mlx5: Lag, reset vport speed on teardown
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260910102432.3845360-3-tariqt@nvidia.com>
References: <20260910102432.3845360-1-tariqt@nvidia.com>
 <20260910102432.3845360-3-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 10 Sep 2026 10:46:27 +0000
Message-Id: <20260910104627.A5C251F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Or Har-Toov <ohartoov@nvidia.com>
>=20
> mlx5_lag_disable_mpesw() never resets the cached agg_max_tx_speed on
> the vports, unlike regular LAG teardown. This leaves stale speed values
> cached on struct mlx5_vport, and pushed to FW, after MPESW is torn
> down.
>=20
> Move the mlx5_lag_reset_vports_speed() call from mlx5_do_bond() into
> mlx5_deactivate_lag(), so that every teardown path resets the vport
> speeds.
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
360-1-tariqt@nvidia.com?part=3D2

