Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA6D49B45A
	for <linux-rdma@vger.kernel.org>; Fri,  9 Oct 2026 13:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791552664; cv=none; b=R8WCkIrh6UpVj8UBhgtbj5wJ0y9tWJwE9d5ABAEX9r2+0OUgS+u3RRXCHFV4Y1oCq7dmUid5j4Y9joh8Al+Fa5gELp/LMVHFNThSkfQ52U1rum77OJuN09I5WLnKI13dSNtj2J0XAvkZjoJ78Oga2N6VNTTV9Cqmv7LL/sqDBVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791552664; c=relaxed/simple;
	bh=CXgsEI027wW9SePZ0eZc1dviVT82kxyASnOJ7+WHmv0=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=Jb7ihqYVyYfCxd8EsZu3XNDv3hBIrTwAwzq+rXZagrjLPyQPFz57Ljh/RMpbxT+J7N76Lx/6bmT71ZwWmP1Nwa757Mf2atJFb4prb45Vun4j/BY8b7KDTBG7NGCjxUxXOTy5e7mO1bryFFGzQ1ssQ/FhZ7iwW5DTpk2d9pO4q8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZpfyBJcw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZpfyBJcw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FFAA1F00898;
	Fri,  9 Oct 2026 13:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791552663;
	bh=CXgsEI027wW9SePZ0eZc1dviVT82kxyASnOJ7+WHmv0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZpfyBJcwoJuG5LSdgNDJcYllbuIOGwItiWosTdEjlc5LfrOMFp4Ff1p9QHtFx1xtk
	 NlWrvfUCIvq/tUqgh24vW+CPMxfBPEiKb+JO4xDCNSY0SXLx18PykK9ObyQdB3PBE4
	 I2UWZ92fGPdGsYxn3M5jvJyYd6gTqnOzxBkBuKP0GI8FLp60rvF/UY/efcmLmQ+Tk/
	 AZPaxblYs+/rIoK3/8cH11MkWxZA+AtvmBJ4Lmr+5usMIjffcBXhFgnIMLqHmZN5P6
	 UjbC7kcLTUsffoj8Ej6cFpyUxNtgCiL+GzpbLRsuFTKa+ZbvOI7eLkiulLZkOY63To
	 cRRnZzI7YsEkg==
Message-ID: <sashiko-outbox-165637@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 03/10] net/mlx5e: Pre-calculate UMR padding and
 entry size
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261008132815.654147-4-tariqt@nvidia.com>
References: <20261008132815.654147-1-tariqt@nvidia.com>
 <20261008132815.654147-4-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 13:31:03 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Dragos Tatulea <dtatulea@nvidia.com>
>=20
> A future patch will add KSM UMRs alongside MTT UMRs for data direct. To
> avoid having additional ifs in the datapath, pre-calculate the UMR
> padding and entry size based on the type of mkey used for UMR type used.
>=20
> An additional side benefit is that the padding check from
> mlx5e_alloc_rx_mpwqe() is no longer needed.
>=20
> This patch doesn't introduce any functional changes. The mlx5e_rq struct
> doesn't grow because the new members were added in a hole.
>=20
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008132815.6541=
47-1-tariqt@nvidia.com?part=3D3

