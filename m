Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58704A5C54
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 11:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789472876; cv=none; b=cs093ZMoeTFQDExUUAs9PXk9b99ylU0YXUjYdE5RsB9R9+el26q+J6mGuWfOPBWKs3IodvtmT8IOLesyOH5Qa/zjaIAvc+uTRLA4S9VxIoCirEUjI5G9xsv/kf4FxYApCUc/9vnrRNW9nngs9uZ3fPQWR7VGQ95TZJbs1Ikb+Us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789472876; c=relaxed/simple;
	bh=WOZb2BRdSvz3NnW6DmGbJfYQm6Df7Q+/DKAspx2SNjg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=WSet+vjUtxqWMTqBOtt1tNsG/RRayardX6lqsn+JLHBH2mko87RtSqv4Kqe33ACk9scWAJd7Smhal94RCwlHMhRGv1qmxHsXtrvFUsybWs08MH6ZHWeUYYl3+iiGgSDOKOla9bZfSDlNhuBmTDUTLFufhBc5MogmWbci9c5Q5kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M9pHq3Wb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M9pHq3Wb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B1361F00893;
	Tue, 15 Sep 2026 11:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789472875;
	bh=WOZb2BRdSvz3NnW6DmGbJfYQm6Df7Q+/DKAspx2SNjg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=M9pHq3Wbfh1O9QE/pgVeCL/78jPlxAU0wBh0B3Wx1u11FN7Wqr3vanaa5g4KbgYoD
	 +w4bGfkqJBYxzrZugEE2mAH4gjSuBEqvaYYxSYkW+r8QXD/GoD8GcIMhFLX5ZZnmKo
	 7OPDWcxI8FdHCNFDaKzNJG2XHqTymtH9CqjNnbiZ9R5JW/mMkpidjplV8acj3tAcjz
	 4RLj8fuYgRYvsQuF1zULNSPb8fvyLOqHGtBWwX5d8YrogLU8VbCbhHdPkwFNFPUR7v
	 yPOi2/06/LuRxIVoRbf+n28/bD66lrtiQOut8On25fBMDjbrt+8joAfiPTA89OVyjI
	 qzbYFrXU8VE4Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net V3 3/3] net/mlx5: LAG, reload IB reps of LAG master
 before the rest
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260915113459.3934760-4-tariqt@nvidia.com>
References: <20260915113459.3934760-1-tariqt@nvidia.com>
 <20260915113459.3934760-4-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 11:47:55 +0000
Message-Id: <20260915114755.7B1361F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Shay Drory <shayd@nvidia.com>
>=20
> In a shared-FDB LAG the master device creates the bond IB device; the
> other LAG members do not create their own, they populate a port inside
> the master's IB device. mlx5_lag_reload_ib_reps_unlocked() reloaded the
> members' IB reps in iteration order, with no guarantee the master is
> reloaded first. When a non-master member is reloaded before the master,
> it tries to populate its port in an IB device that has not been
> recreated yet.
>=20
> Hence, reload the master's IB reps first, then every other member.
>=20
> Fixes: 2b204cdb1206 ("net/mlx5: LAG, use xa_alloc to manage LAG device in=
dices")
> Signed-off-by: Shay Drory <shayd@nvidia.com>
> Reviewed-by: Akiva Goldberger <agoldberger@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915113459.3934=
760-1-tariqt@nvidia.com?part=3D3

