Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD123D5221
	for <linux-rdma@vger.kernel.org>; Sat, 17 Oct 2026 04:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792213173; cv=none; b=B9om8iUk3jtRTMAD5Zl/nl6PgV5xfxV0wHbGDMrc0NoJS8D+kncjYzEQnh+N4lgk76OKUe9mipIJDASqbqOzlb9yht6Nrq/GpwtWEK4yFw7uMda/whJRvDlIUX19sFnMO+PP6BGIvwYbNty8l9+LECzIqtDtuTWJbWzN2Yt0zPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792213173; c=relaxed/simple;
	bh=lfIV1qJwl8Vs4VOGoCfN0jKY9/17Oe4lsW6gKHwtls0=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=VRkQZ53E5ZM/Ih/1EZxBYuJcE00p6DiNOMSTC3SrtiotM5T3xAIOfDTTX2uYM+MokiDrHwVUL8tIVTNIIJ3KCpYEecwE77lOcE2VqgCz5DsXgAa6r//WHkjfH5cbc4gIeeF9ykd8PWten7cThUMDNz8RXtjNKjlrqbe6xlVTAzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d5FUX77T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d5FUX77T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C3D41F000C5;
	Sat, 17 Oct 2026 04:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792213172;
	bh=NXNR/SydNliA/5StLY/5UXUpQQ43yTyZrvFH8tZ1f44=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=d5FUX77TfIZBHtleCyRvkbmROLBPaGTe/yVruHwCxcBQzpDEkGOEZXZmC18U/gi3A
	 +OApNzRq9Wyxo3+a3TME9xvf1nOAheEpil4o7E7gkcIhUEULCSICPsTuqhpPhbGJQv
	 uM+BnYsmETb1EMNoFsPmAyeBx4quhNw74cG1JNTrJixrmTWjXfEklJIv/zP4WrIvv2
	 p+EsVVLrj6IP5bWqFbWNfLW+t9uR24rv8rQphTZeL6gXf4xX+4iQoG8eXOQdDMssI5
	 YQ9wngd8uOvdYsnRUzPxUrnlcK6PuCFcmmyPRqWo0BwmlHm2ACKX5bDnTFr5ld22XI
	 XHAU3f+F46x0g==
Message-ID: <sashiko-outbox-175295@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v1 2/4] net/mlx5: Don't free the WC test CQ if
 destroying it fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yuho Choi" <oss.patchbox@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261016045849.813696-8-oss.patchbox@gmail.com>
References: <20261016045849.813696-6-oss.patchbox@gmail.com>
 <20261016045849.813696-8-oss.patchbox@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 17 Oct 2026 04:59:32 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] net/mlx5: SQ DMA use-after-free due to dropped DESTROY_SQ error
--

commit 7355666e6a6920857efdc4ded19eec645c9bd315
Author: Yuho Choi <oss.patchbox@gmail.com>

net/mlx5: Don't free the WC test CQ if destroying it fails

This commit fixes a DMA use-after-free by returning the error from
mlx5_wc_destroy_cq() and keeping the CQ buffer and struct mlx5_wc_sq
if DESTROY_CQ fails. This prevents the hardware from retaining access
to a freed buffer.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/wc.c b/drivers/net/e=
thernet/mellanox/mlx5/core/wc.c
> index 7d3d4d739e2cd..01e9800ff6fd9 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/wc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/wc.c

[ ... ]

> @@ -396,11 +401,13 @@ static void mlx5_core_test_wc(struct mlx5_core_dev =
*mdev)
>  	mlx5_wc_destroy_sq(sq);

[Severity: High]
Does this same vulnerability still exist for the SQ?

If the firmware DESTROY_SQ command fails (e.g., due to a timeout), the
hardware retains access to the SQ DMA buffer. Because
mlx5_core_destroy_sq() drops the error and returns void:

drivers/net/ethernet/mellanox/mlx5/core/transobj.c:mlx5_core_destroy_sq() {
    ...
    mlx5_cmd_exec_in(dev, destroy_sq, in);
}

The caller unconditionally frees the SQ buffer via mlx5_wq_destroy():

drivers/net/ethernet/mellanox/mlx5/core/wc.c:mlx5_wc_destroy_sq() {
    mlx5_core_destroy_sq(sq->cq.mdev, sq->sqn);
    mlx5_wq_destroy(&sq->wq_ctrl);
}

Could the hardware read garbage data from the freed memory as WQEs,
leading to arbitrary hardware DMA operations, similar to the CQ
vulnerability this patch fixes?

> =20
>  err_create_sq:
> -	mlx5_wc_destroy_cq(&sq->cq);
> +	/* An undestroyed CQ may still be in use; keep the SQ that holds it. */
> +	keep_sq =3D mlx5_wc_destroy_cq(&sq->cq);
>  err_create_cq:
>  	mlx5_free_bfreg(mdev, &sq->bfreg);
>  err_alloc_bfreg:
> -	kfree(sq);
> +	if (!keep_sq)
> +		kfree(sq);

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261016045849.8136=
96-6-oss.patchbox@gmail.com?part=3D2
