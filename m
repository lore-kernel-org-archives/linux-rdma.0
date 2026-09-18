Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A1744611C2
	for <linux-rdma@vger.kernel.org>; Fri, 18 Sep 2026 18:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789755156; cv=none; b=Gp5HVXhYKf8fmx/MkTWjt5Cxs87Zsx9suTWQ0TSRD4Wwo45NAXBVscgQDbLBKFd/dX7gXHkRU7hMMCtVOtFQ1Iw17xtXWeRZCbm8WxaMvCVAt0D0Os+bR5w0+P4LnuQSHCxfqrNVWmFbdXzuyYqQ724mFZ/hfG/bGh/3gDR/c+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789755156; c=relaxed/simple;
	bh=rG+Kmh9lKoWjawTEBZu8Po6I2SnzLIvcVkP7ypapJBo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=GzyzUZ0r5/FvOCQeBQT7nv61cOaXFqWeC+V5mhGsNHROds4nAPdSM0wdRREYBHSspiVmtXiVjDHg7L0zSTemer1w6aiW8Kvbs7VJyK2VtvhUGhMY6OHih1vp3NpJk2Cg1q9CzjVhFGi5qJJYFj+3SUv3k3Flvpzy3HApKW9PnZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jZT5EWNW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jZT5EWNW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E52971F000FF;
	Fri, 18 Sep 2026 18:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789755154;
	bh=rG+Kmh9lKoWjawTEBZu8Po6I2SnzLIvcVkP7ypapJBo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jZT5EWNWK7uh+faoGrDX7PCgcFX34P1X1MWpEWYuFVB0L/R1I2iMRVkqL+Tr0Z3O6
	 qyngizt9ijgXKVdTK6nIGblq3xGWGLhR8Sw93WD67mHU5y13cuGwJHIQxrBp8QE3CW
	 EWRc0NKMpnaOqOl35ReoBQ3WJZ+rNT+UEYE40rIW9a9LPI6wg83+bSkUjsNXlJ0IBk
	 MXxQaf5QTbndyLY5v2STMdiIWbxERj0hDoW553wJA3gkQ06KaBpiSgmnHctNzAn1bf
	 UGc7/Gov6dhUHvNR4NXjYOEASc3qi2zRYxfv/aUCI7/N6BKlJCFcuVIDlEcX12CwtZ
	 hrZNx1bqhmAGg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net 4/7] net/mlx5e: macsec: Track hardware object
 ownership for SA teardown
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260917175433.4090878-5-tariqt@nvidia.com>
References: <20260917175433.4090878-1-tariqt@nvidia.com>
 <20260917175433.4090878-5-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 18:12:33 +0000
Message-Id: <20260918181233.E52971F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Cosmin Ratiu <cratiu@nvidia.com>
>=20
> A driver MACsec SA can exist without a hardware MACsec object. Adding
> an inactive RX SA or a TX SA while the SecY is non-operational creates
> the encryption key but skips MACsec object creation. RX SA deactivation
> also destroys the hardware object while retaining the driver SA and
> its object ID.
>=20
> TX SA deletion and the SA teardown performed by RX SC and SecY deletion
> unconditionally destroy the hardware object. This can issue a destroy
> command with an unallocated zero ID or an ID that has already been
> destroyed and potentially reused. Failed RX SA activation can leave
> the same stale-ID state after steering creation unwinds.
>=20
> Track hardware object creation separately from SA activity. Set the
> ownership flag after successful creation, clear it on destruction and
> creation unwind, and check it before destroying the object during SA
> cleanup. This preserves destruction of objects retained by inactive
> TX SAs while avoiding destruction of unowned objects.
>=20
> Fixes: 8ff0ac5be144 ("net/mlx5: Add MACsec offload Tx command support")
> Fixes: aae3454e4d4c ("net/mlx5e: Add MACsec offload Rx command support")
> Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
> Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917175433.4090=
878-1-tariqt@nvidia.com?part=3D4

