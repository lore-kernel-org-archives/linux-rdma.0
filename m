Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56FC93E4C95
	for <linux-rdma@vger.kernel.org>; Thu, 10 Sep 2026 10:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789037191; cv=none; b=XY5hk0CWtJv+hEJro+4Xye91u+BJ4hCb1bwcEN4INBBVRmkH8dZFGqVy5ZTr6ebOWssRPp9YXJQ5P8r/xnKFK+LLSdY7LwNhTCGEGoj5TIh/kJg2PVQQWVTKFCpJgDpSw77twaKhu3TdVeegrjLbK+Y9igCqSE6nHwjdqW9thA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789037191; c=relaxed/simple;
	bh=9EZb85cL2FA6MRDyU2EyM9ivmwTih+kzrfWcCBBmz/s=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=VWACahTq/2vP5mlDkeAX02PGcZaPvHbP7ZFWDmUULKoIEckdT91nAg38XHJrnUQZDX8et/Bdg20z6zNn7ZARWUcPRU+2S3OsWUhIxX5yHjVu63MRYLXATWPswyz3RTvnKkuZrFZlqGJT7kVjkkok0Pd9QvyElDj0QEVtsGb3zlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e72GrD5u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e72GrD5u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B72301F000FF;
	Thu, 10 Sep 2026 10:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789037189;
	bh=9EZb85cL2FA6MRDyU2EyM9ivmwTih+kzrfWcCBBmz/s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=e72GrD5uzwxdp1QDPpN8dj4p1G3aocfKwMII0flYC+V5yx4AHg+GGIjoqz1xKhXD2
	 tl7TVl983gZP4f50BpMtPe428fUbDR+Z8h02anGW2EDyx4K3oKyYIpTycqkaSJCgqk
	 zIY3dl+eUPslANPmxL9FvJ7bfYm/IaOC/7o7pZEhgAWdPEELg9v8H3vp5+klsqA/Yi
	 crOsndYVfvJTblyjZRd6GCoXHeZIi8o6Nu5ecTs8UClwdtu3L27U6tL/sojXZXDRCR
	 oZWubIiqW6npUSeQYeX2znhpUv0sFV+KPW3lTGXwTvXvhYqA+z8ABWXmJDOEXb6bVW
	 oTv2AL6Yd0NKA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net 5/5] {RDMA,net}/mlx5: notify RoCE LAG speed change
 via driver event
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260910102432.3845360-6-tariqt@nvidia.com>
References: <20260910102432.3845360-1-tariqt@nvidia.com>
 <20260910102432.3845360-6-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 10 Sep 2026 10:46:29 +0000
Message-Id: <20260910104629.B72301F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Or Har-Toov <ohartoov@nvidia.com>
>=20
> In RoCE LAG we don't modify any max_tx_speed, so no
> IB_EVENT_DEVICE_SPEED_CHANGE is ever fired.
>=20
> Raise IB_EVENT_DEVICE_SPEED_CHANGE from the LAG layer, in
> mlx5_lag_update_agg_speed(), right after the cached aggregate is
> updated. That cache is where the IB layer now takes the effective speed
> from, so a consumer that queries after receiving the event is
> guaranteed to read the new value.
>=20
> Fixes: c6df9a65cbb0 ("net/mlx5: Skip disabled vports when setting max TX =
speed")
> Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
> Reviewed-by: Shay Drori <shayd@nvidia.com>
> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260910102432.3845=
360-1-tariqt@nvidia.com?part=3D5

