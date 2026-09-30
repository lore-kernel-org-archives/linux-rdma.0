Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1374C33E9
	for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 11:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790769365; cv=none; b=u6KjCPAGCf6rskmCsmYrVZEzMBAUymvwxlw57otS1R6tiNhgX/TUP4JK0SVQ5A0ndjnrLjfKGOqJvzkFhJsJNQ74SjoXcKlAbDQR95OfFrjCYKVxxXPcSrXtrmX5DhdJz6LbReL1pWwVEH3UTI4pK9K/weFnOUUl6gyqxri8PPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790769365; c=relaxed/simple;
	bh=rd0Gt0JMGjsxTNZT3aouCdItVmV8jkT2osdJMTdjjqc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=DnyKBtk5lqB/W+qCf3ltIt4UTNj4r/+c2pRdoW6ACSn8TC+K8rqoE5LyTZOArErmy6PyJeTX/SXJTbrT7/wjEbDlW9nPLjzh9nQP46n/tTcoCLscLhHRyvHwi9dXpouThVwSXaG5DG1vdp8+8t+njmMMjtjLCX+O+3lvaquLvz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HWRzslcm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HWRzslcm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF2531F00893;
	Wed, 30 Sep 2026 11:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790769364;
	bh=rd0Gt0JMGjsxTNZT3aouCdItVmV8jkT2osdJMTdjjqc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HWRzslcmMVA7gZshLVJiJ4X84zGZQjGcKZzJbEOaygTv7YmSpDUdHQ+ha6gl4V88T
	 ihog3e65aNuSILyk+8yYxJpvf5cvqPJcztyXFmq/MX7C9kkMtIk3nEKX7m4LV1Ct69
	 n9TEMWN27i4x6PrgAy3gMko44GiWzRKCf5ArEpdbFRytZDudpgAsMH/34RZHnP3Gk+
	 MhhgY90D8l8vsOO5QZVh09k5xL+g086mi2z0SwrnITv5kIhuD9mGOxG0kkl0r0ej2A
	 bYGID5GXjAaxkl0jAGxU8aLBKaYxoHk6SYYETDS3Cbht2dBW/JvEjqnhdsqkbnpXaY
	 4SrNeAewjJlTg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH mlx5-next V2 02/10] RDMA/mlx5: Add
 mlx5_data_direct_supported() helper
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260930114227.139274-3-tariqt@nvidia.com>
References: <20260930114227.139274-1-tariqt@nvidia.com>
 <20260930114227.139274-3-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 30 Sep 2026 11:56:03 +0000
Message-Id: <20260930115603.CF2531F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Dragos Tatulea <dtatulea@nvidia.com>
>=20
> The data direct capability FW checks are duplicated inline in
> mlx5_ib_data_direct_init() and mlx5_ib_data_direct_cleanup().
>=20
> Wrap it in a mlx5_data_direct_supported() helper and use it in both
> places, in preparation for moving the data direct matching code to
> mlx5_core. For the same reason put it in driver.h instead of
> data_direct.h.
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
74-1-tariqt@nvidia.com?part=3D2

