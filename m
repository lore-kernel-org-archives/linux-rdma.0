Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B354E325D
	for <linux-rdma@vger.kernel.org>; Fri, 18 Sep 2026 11:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789730197; cv=none; b=K5s1HD4qINpWLhYcqe5IwGlSzLTroUDxEQOp6ZhfRHqQ9OMtAF2Z+BMhjWcain/PHmjakXvzretLoLogf12Udf2VJn783BDsUa+BXQupDmqU7SvkanIxGXGXjRQ3dZDuYS4Ar1CaMX3g5FE7DiD2MRWddv9mB4cSDLvF5MGSzfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789730197; c=relaxed/simple;
	bh=1nXw67mWhOUVVDH0mOnkodE9snhGppe1z6/tKmg200Y=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=noojTxngIUIViefDDr+daY6qnjsRN957j55yl73b4DosRP8lX1R8nAf+K6o72iLUq+bVb4ika1J0ELZikpGU4OMlKU+0PrVzk9iQHNgxedPVdReL5jo413pWgbUo/0DdkW5xjOIFMIOjTjXijjuQrowtUAOs0izRx2LB+Xovd4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R7BuPF9X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R7BuPF9X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F531F0089B;
	Fri, 18 Sep 2026 11:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789730193;
	bh=1nXw67mWhOUVVDH0mOnkodE9snhGppe1z6/tKmg200Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=R7BuPF9XaxGhP5AdOHUi0RHNINZPMv/SjGeFG2SaOMhRF4vtQkzKVLmHCPOA6sKOo
	 bGv/2pFjHJ/mA3LAfaDQ07CJu/MMfh/bRxM+JPpK6g6qBMDL+68WV+TwzgbfhUUaca
	 QLU+3mfGzh8JbbXaQaCtefv8hqFmPo5bBLL+U8rC2Nw/wpv71sqktI/cvfvB3XM5P4
	 fZq9CAkXaZRSwPrWKEDqYAq2p/szB8WzUeCDZ19E4DtQq6BD3uTIpJDPy8Xp6tgkFp
	 gBLa9DHXEi//+9Ah7Lrd2QEE0y+Z7Twz3o6453fh78+S8ew94Z/+aQ23PIFrDnZtdB
	 dpDl5HSSShKTQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH mlx5-next 09/10] RDMA/mlx5: Pull data_direct resource
 creation in init phase
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260917111422.4054862-10-tariqt@nvidia.com>
References: <20260917111422.4054862-1-tariqt@nvidia.com>
 <20260917111422.4054862-10-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 11:16:33 +0000
Message-Id: <20260918111633.95F531F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Dragos Tatulea <dtatulea@nvidia.com>
>=20
> Since data_direct resource creation happens directly after init,
> there's no need to separate them.
>=20
> This patch moves data direct resource creation in the init phase,
> thus simplifying the data direct API. The cleanup path gets the same
> treatment.
>=20
> This keeps the existing IB device lifetime and prepares for moving the
> combined initialization and cleanup to mlx5_core load and unload.
>=20
> The patch has no functional changes.
>=20
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917111422.4054=
862-1-tariqt@nvidia.com?part=3D9

