Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021722;
	b=1gCDmpjSeLd3/PVnfq6uMnJ8hC3w70rLfKdb17LGDOU464XbWN3W2rtPuHwPa1QpXoKj
	 ocEqftVw8PFnoMeaOy/bz4CMPnClQHb7uoOKUXyJEaQwqOcpvYukmOTFmrevju7ZvO08i
	 HugI6jhzy9eiHWlCgOfrmMZdGWovMuqdPn54ypNcTqphnSl9Mmhi9bLkjrDVI28wq5H0Y
	 beHo4zmnJaXpBEzl1f6RpyCWJ0YbwBpFvXfJLf1+zd4IL2ich4qitUOBLSizvIfoDtnna
	 9yGSMRhApYEEPEHPAv3Jl9rDuV8Z5WW6OcNl+KTtlO/o9k5zDmDTsfv/9T4VIPgyu0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021722;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=/RW/njpI+htGdaqpCVDDE6GIV7XG6VGHCFohpKQiI64=;
	b=1KmlOpYOSohc7H+Ox/1fuA6BVSImYojNJDZysubvx6/F4zDZrBuGIAw90glNP1GmWYyZ
	 XxZkNnFF7P4cuj9mlMUVDNhZJ8/wEh8r4hOywU5pllysGCDLaWSp7UxlgUrUT3F/tsHPD
	 8ReNiGSPLLZkq7Vty9HuOtPzHH0H8HJKnm1a9JFEjYnBQFpQPEJiMAlGVxPVdRwu9uaW6
	 WjlKTUsCEECS7aeylpHueidI+8BAhd24GBYabmlzn5w4hdGJEunW+T+Ze9Koc+7LwI+O2
	 xvihBaaW0sypYPUgzbLO4GGjpVC/ejVhNsCbujTcMWts/aqdiTyGEwGqXRMVcclxQHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WAfbLfUD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C0D5606A335
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 17:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WAfbLfUD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50D2B1F000C9;
	Wed, 18 Nov 2026 17:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795021722;
	bh=/RW/njpI+htGdaqpCVDDE6GIV7XG6VGHCFohpKQiI64=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WAfbLfUDir+BvPIFCp94Wv3R3+2iw6lRhj2n6vSc6w4mdJECVFcF0wGb2oFTjKpt9
	 cuQ9JTCaIGzn1aGSpQzZ/D35a6shPZRfv1Yt6ABxBqrRGd4FL6bYbXpJT0IalycAJX
	 MbjCZ5YEz5ixRRL6f4ba+yfXJyQ0BiDhTBDmU8aNCFfAkYplAq2Q+3nR1gjrtvt334
	 StXs/PzbiFjlR+X81J7wTjA9kKhOifnLNP20o5AF9sxOykhHC0erm/LZ7MfS8GH1pN
	 bHwwo7TQRzS6BhE2YGG7D9YhhpsEo2EPW76ZxxMZibOu5Y7zFfv82hUEgkt4xgCAOu
	 Ehqxg/3xY6RrA==
Message-ID: <sashiko-outbox-221579@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/mlx5: E-Switch, skip vport change work for
 disabled vports
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261118165155.1946097-1-tariqt@nvidia.com>
References: <20261118165155.1946097-1-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 17:08:41 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Uri Dar <udar@nvidia.com>
>=20
> A vport change work can still be pending when its vport is disabled.
> For an SF, the vport is then freed in FW and the work's query fails
> with syndrome 0x29d722. A disabled vport has nothing to sync, so skip
> the work.
>=20
> Fixes: d970812b91d0 ("net/mlx5: E-switch, Add eswitch helpers for SF vpor=
t")
> Signed-off-by: Uri Dar <udar@nvidia.com>
> Reviewed-by: Shay Drory <shayd@nvidia.com>
> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118165155.1946=
097-1-tariqt@nvidia.com?part=3D1

