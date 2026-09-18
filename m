Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B894E4323
	for <linux-rdma@vger.kernel.org>; Fri, 18 Sep 2026 11:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789730193; cv=none; b=S9ogNNlLKeFPs1P1zgZvJ5hGoeivDZOa6NTIy6qBuWV7uA79eHh/tUEsHJXFPuI7bY+RSO5sQa8TpBZd+ADH+QlgRNNJR7oqpHAqJBXoMmrC8M7XcIP99fdrSYY1t2MH0C4u8sBf0ILYL866U9xi4LBJxjdUbdRpyQIUNtmE3bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789730193; c=relaxed/simple;
	bh=VqmOAfIWVDkM7vHWhOu+PJe769w8KepIpy4BCU/jPQA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=fo4edrNozmSeZi3svd7GkKZhaHQsL8soluq18oznMFbOdc1uSyQWhThaEdrWZNzVXTSyjlRPUoAC4T7axuKuqHZ81p/jLOluw/Ivrijj7UKSauGRYkWUfWPSM1ExVbkkmtOUI6vj1zJ+Hqe1GWaOBg/Dm34h5+QN05CfOgIySvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TrbujkAM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TrbujkAM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 992D01F00893;
	Fri, 18 Sep 2026 11:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789730191;
	bh=VqmOAfIWVDkM7vHWhOu+PJe769w8KepIpy4BCU/jPQA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TrbujkAMopiGUkATRgFgXZZNKFkNw6AskguQ3MX9lVPKZwtZHebKVc2/OfAOeS23A
	 TnlQK1jBH4gwZyZ/lq0G9sQsFGOXUVVS3+S3XLBGq1vH8Hf3ctjXoVHV8zrYeI00s6
	 dOgD7Okx9NFa2wrKFAoWUUrVo1qiBv0CfnLm9OW2cj2rHNVXjO3BC5VxqBBPsqvjPb
	 nsl+bj2ns6g7OT8hF6dulaf5NBpJb/jBeCI8C9gaGm8lSMQtZ8840kSV4m2uYkImEx
	 Tt7TglpEkiAtYvJeDQ5nabpIXrrY2zpQzcLyrxcZX/gNRgAm6VXcQQi2MbwLBj5kJ8
	 6xwYDfBv+SE6g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH mlx5-next 06/10] RDMA/mlx5: Add new registration stage
 for data direct users
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260917111422.4054862-7-tariqt@nvidia.com>
References: <20260917111422.4054862-1-tariqt@nvidia.com>
 <20260917111422.4054862-7-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 11:16:31 +0000
Message-Id: <20260918111631.992D01F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Dragos Tatulea <dtatulea@nvidia.com>
>=20
> For the upcoming move of data direct to mlx5_core driver,
> the API needs to be split into init and register stages.
> That's because only the core will do the init phase but
> both IB and netdev devices will need to register.
>=20
> While data direct still lives in mlx5_ib, do all steps in
> mlx5_ib_data_direct_init().
>=20
> While at it, make mlx5_data_direct_query_vuid() private
> as it is no longer needed.
>=20
> This patch has no functional changes. It is a preparation
> for moving data direct infrastructure to mlx5_core. For
> this reason the new functions are added to the new header.
>=20
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917111422.4054=
862-1-tariqt@nvidia.com?part=3D6

