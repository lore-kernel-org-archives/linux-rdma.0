Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E75641611D
	for <linux-rdma@vger.kernel.org>; Sun,  4 Oct 2026 08:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791103373; cv=none; b=BmTTRXVnXj+c0mRahvy6++wG9QrLvR5zaNSvkYikEdFbLOjyFfrhqFwYx7FcHarixapGQIoCugG8Ex9RcQgCGVusLapkgLKXcvLPJQyZZflXHKOzqRfsSminmJjUd49ftA8isBkleotPl3l6i68qobqHDS6+wt75X1LydqBhYXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791103373; c=relaxed/simple;
	bh=nkX0ocxb/sjYXnywS1bn4b3imUkozGiuNez38lFI4UA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=GlgDj0zQClpSMsv8wbKOPznu7dfRiDP5bpIcVq8N6Tt1lMWHRJ1HpIi5AYmvtwC1sL2MHh+XN/ZiSvRyx6SQX8NXEHFdp/uMZQlANrT2vWM9/tP3JrC6fxx9AT+gAwe/tZzsqwZIOD2TgXAnHD7OM2MprpUE/5pYVl5R5jt5WJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WWGnYGuH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WWGnYGuH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CCB31F000FF;
	Sun,  4 Oct 2026 08:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791103370;
	bh=nkX0ocxb/sjYXnywS1bn4b3imUkozGiuNez38lFI4UA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WWGnYGuHeHuvPelJt9rJH6zXTR+DSGKOLwzkzmG8AkBeZsl/xmZx/1+QYkQxiUQx5
	 Bm2LD9EujWARBMJ7K+3u5BKBNtU6UvVRDBybu3tlM/g1Q7xJK2gFNfU4neu4ApQk/Q
	 llEstlzCMIwhvidAJnaY+Q1zIfXRtbBrA+m2lx+UJo2xcA+nQWEfJhMeyn6YTSHCUx
	 Xq5HUHzhQBzhuC1fCmMUgrotqDUPpIt2QSv4tjIv+TyramoBqr37tV5/+1ZddZKHJZ
	 frFd/QNh0JvBT7eVIrw+5sm32BevdmU+X0jOPeaHVV73OwvgxgINJuiRwmAJLoZHZo
	 QcNlVjPr+4rJw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] Revert "net/mlx5: E-Switch, preserve max tx speed
 on vport state modification"
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261004083531.216988-1-tariqt@nvidia.com>
References: <20261004083531.216988-1-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 04 Oct 2026 08:42:49 +0000
Message-Id: <20261004084250.0CCB31F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Or Har-Toov <ohartoov@nvidia.com>
>=20
> This reverts commit ad0ae7aefa7a ("net/mlx5: E-Switch, preserve max tx
> speed on vport state modification").
>=20
> mlx5_modify_vport_admin_state() and mlx5_esw_adj_vport_modify() query
> the vport's current max_tx_speed before modifying its state, and
> write that value back, to avoid resetting it to 0 as a side effect
> of an unrelated admin-state change.
>=20
> That's unnecessary: max_tx_speed is optional in MODIFY_VPORT_STATE -
> FW skips writing it whenever it's 0, treating that as "not provided"
> rather than "reset to zero". Leaving it unset already preserves FW's
> current value, with no query needed.
>=20
> Fixes: ad0ae7aefa7a ("net/mlx5: E-Switch, preserve max tx speed on vport =
state modification")
> Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261004083531.2169=
88-1-tariqt@nvidia.com?part=3D1

