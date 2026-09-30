Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7F137E5CB
	for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 11:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790769361; cv=none; b=FF8FmE7chtCZr8qzUZLiWFFR9evhgHqHKEA+2fF+l6vhH5srwgFj/Q9krJNKZr3cOdhyOgStIPYZKrLYLF4fKTb5I8r07ANidPQX3+RwPwLJqsg1H/mAwET94014SvjKAu58JPBUwXyt/HeDcH2Dzvj0U356i9EQrViTSPHXSjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790769361; c=relaxed/simple;
	bh=bPRRg/Eu3rjfssZZEM0GEzYAB/Mq/n4sdL9lBaXpQ14=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=gGAhPljhFizwDzehl0VX7F0nRrvYYkn89J/z3gsc+3VHUMuYfL4En6YzahCfY/11NfoySWHgwrDBnRezfRqZyCsVs0kEt7zZWU6nIS1rrbJR9Wam3iQ8PRm5tsd1YwRPSRbpdQ09r00pfHfjI0o1jBeKZHJhU+XgiitSW1x8zO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QGNYt2f6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QGNYt2f6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9189B1F000FF;
	Wed, 30 Sep 2026 11:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790769359;
	bh=bPRRg/Eu3rjfssZZEM0GEzYAB/Mq/n4sdL9lBaXpQ14=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QGNYt2f6Z+wprKcO1katsQFG47dErcFudY6SliAoCp11gopEIXIzaNAL3znraUStu
	 hw65u83I5N66g6zMYNs+aTbDWVRYEMNnjnoSpZ5uuXZ+ZfI8N0Tf6wLHUiBBIiLiwJ
	 OfE4DX9vS6zxsaae35f2Ok1EbDSC6WBBFc2YV1vH/GgC4wH6eg9eTOtMKGbBQzNp9R
	 k/bWW1mb0N5bOudXOM7B7PhTPPpyLsnUkg/XETYkYApOaVxxL3d4TmrmZZ6acwK4Ru
	 rCnYi5gYG+v3kloNn1tjtek47dvgAQXXV6ap1CMQ4g9PQSJcOSyLUgV2JYVLKbmMco
	 e0beV1V1o9Cag==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH mlx5-next V2 05/10] RDMA/mlx5: Move and rename data
 direct resource functions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260930114227.139274-6-tariqt@nvidia.com>
References: <20260930114227.139274-1-tariqt@nvidia.com>
 <20260930114227.139274-6-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 30 Sep 2026 11:55:59 +0000
Message-Id: <20260930115559.9189B1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Dragos Tatulea <dtatulea@nvidia.com>
>=20
> Move the data direct resource creation/deletion and resource
> struct to be self contained in the data direct file. Rename
> the functions to be consistent with the rest.
>=20
> While at it clear the fields on resource deletion.
>=20
> This is preparation for moving the data direct code to the
> mlx5_core driver. The code has no functional changes.
> Keep the resource struct and function declarations in the IB-local
> data_direct.h header.
>=20
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
> Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260930114227.1392=
74-1-tariqt@nvidia.com?part=3D5

