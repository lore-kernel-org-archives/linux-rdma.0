Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2C03B634C
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 14:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789482286; cv=none; b=P3Wg+Lg4fkAkHAglHirEZPf8QPTQYUbElO5nWBfFRVuzJUam+sbJtmwxDVDBkChEn/fPtdndOHrPq1PlqAfmdjRg8JvVB5tdqAH6fJrnuWQKyO75bryWkuunb2om5unNhhQTVvl6CXcBB/RjDv6wwOSgPQgJJOFNV6fjItdm604=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789482286; c=relaxed/simple;
	bh=MpMOIruBpNFCPD8CFPBV9FOJ/xhn73hnckZ5fSVF5ZI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=pGixU3x/1umKm9xggR7DG4Ai3S0ejMpdAdl9Y+ELjFCt1XB9j610DW2jN52DQtgquclGVHb8ERw7QVtdPgfyB6K69+M3vaB7GkfRhNN7ip4XE/OAbXfujW3ov7E5hys5/RFIgWQXQp4lrKkWVklWHO7hce5fgX4vwZv60giDWwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=di7VABNN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="di7VABNN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D99A31F000FF;
	Tue, 15 Sep 2026 14:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789482285;
	bh=IZY6G2Hyh1TqC6W5QKLx3+ysqMokCdk0+hn2LAlBQK4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=di7VABNNMRHrYClK819PODrEsVca13SCcUEfUL3BcSEIvXCy4XeC7Uxv3reih6xz/
	 A/09D2nqtF5vCc5wd3I3z1nIfLbwwRnOL0HQ6d4YjcAokwXHlv/MnlEOF7UZ0ET4qf
	 JL0ufGBM5DVxtdLTDCUbXCHkX5m98InIheQQzXEvbBpaRc5Y7OtgNVU5XXNC7/GXqN
	 9tbucSFS/4KYnssUu9FZ95QQfDXOiW2DaXUGx13gHH1ai6SBSSOVAiCAs0sE2sDTtc
	 GpNNWd52yoPFhMLULT5tqFKXi5jPYeIFXXGYV30gDjV55mcss18nTaizz0SmP3Ba2u
	 DnK3FrNZYp42g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V1 rdma-next 08/15] RDMA/mlx5: Fix
 mlx5_ib_dev_res_init() failure when XRC cap is absent
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260915140933.40580-9-yishaih@nvidia.com>
References: <20260915140933.40580-1-yishaih@nvidia.com>
 <20260915140933.40580-9-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 14:24:44 +0000
Message-Id: <20260915142444.D99A31F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] rdma/mlx5: missing mutex_destroy() on error path in mlx5_ib_dev_res=
_init()
--

commit c4290e2ba9444b4168574311394c1c28313c0387
Author: Yishai Hadas <yishaih@nvidia.com>
Subject: RDMA/mlx5: Fix mlx5_ib_dev_res_init() failure when XRC cap is abse=
nt

This commit makes XRC capabilities optional in the driver probe path. It
initializes the cq_lock and srq_lock unconditionally at the start of device
resource initialization and skips the xrcd allocation and placeholder SRQ
when XRC is absent.

> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/ml=
x5/main.c
> index 373ee1f42d4ad..8b8a0f26cf19f 100644
> --- a/drivers/infiniband/hw/mlx5/main.c
> +++ b/drivers/infiniband/hw/mlx5/main.c
[ ... ]
> @@ -3434,8 +3443,11 @@ static int mlx5_ib_dev_res_init(struct mlx5_ib_dev=
 *dev)
>  	struct mlx5_ib_resources *devr =3D &dev->devr;
>  	int ret;
> =20
> +	mutex_init(&devr->cq_lock);
> +	mutex_init(&devr->srq_lock);
> +
>  	if (!MLX5_CAP_GEN(dev->mdev, xrc))
> -		return -EOPNOTSUPP;
> +		return 0;
> =20
>  	ret =3D mlx5_cmd_xrcd_alloc(dev->mdev, &devr->xrcdn0, 0);
>  	if (ret)
> @@ -3447,9 +3459,6 @@ static int mlx5_ib_dev_res_init(struct mlx5_ib_dev =
*dev)
>  		return ret;
>  	}
> =20
> -	mutex_init(&devr->cq_lock);
> -	mutex_init(&devr->srq_lock);
> -
>  	return 0;
>  }

[Severity: Low]
Since cq_lock and srq_lock are now unconditionally initialized at the start
of mlx5_ib_dev_res_init(), do we need to call mutex_destroy() on the error
paths if mlx5_cmd_xrcd_alloc() fails?

If either xrcd allocation fails, the function returns directly without
cleaning up the initialized mutexes. Could this missing cleanup break API
symmetry and trigger warnings in debug builds when the device memory is
subsequently freed?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915140933.4058=
0-1-yishaih@nvidia.com?part=3D8
