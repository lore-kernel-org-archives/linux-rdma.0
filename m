Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795010660;
	b=Wa+XJMAE0hScwdi0gnfHM9hHTjnH9p4oNniPa+4l4LUPMVLTXCDEGhJ2UkE61GvN760A
	 nc+/yxgbaRIN2Tpg/JjCPAEvLKU/b9tpFC7qK/DSrO18XIXgF+1VC3xSDys+CvD3rJXSk
	 Uu3jGUTc2biW6XkQFAknsQfP6CUsIneZ8/GL5lUq9Lokd/JCqzfGHWz1vIICJq32iMHjy
	 wSUsJ60M+iTOsGvVErfl76Cw6s40cgDd0ilTbyEe+QANdL16AOfJZyT8MnD6IAkzlhYsr
	 c0Li2H6N2eATPcLVwNgVrNYPQFpywkAm7PNNFIZrhLTSz7jLGr1RBHSZHJlgV3dv4TA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795010660;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=wkcauF0EHSR/vv0Xq5OKyHa8Ec9HyG7IUnRKFvRcF1o=;
	b=o5ZplGWBzYGjVdnCuPgQhpuOtXzBSMZeWU17OiHsstIojCFCP1MBLel7e5jeYY8Op0Wb
	 A5icmhT+5JmWM1Q9nCZkP+ZW5MmnZ4E3+y2LW0ardnMrr9avwS3753zwxuZKr8oqkghMt
	 zR3zzPC3DFicHSF35fk3dpjZnvU4OOpd/nAMNkKMFVHDTX23ry5QJEfxLamT+B028voZb
	 dT6a1xTP3LME680GzLpsDMy+nLJID/IptRr48uhR+lw9morL+JraZ6G0gzU3swaQNq3A3
	 RdTAhh7sfaTTyX+Zl6VoLT7Qwf47itc16V09mlBcyh9EIvcZ4a6hAvKzec7LFwAgIcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UnMH8QEz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EBEF606A325
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 14:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UnMH8QEz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B85331F000C4;
	Wed, 18 Nov 2026 14:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795010659;
	bh=wkcauF0EHSR/vv0Xq5OKyHa8Ec9HyG7IUnRKFvRcF1o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UnMH8QEzd5LqHaceg8Jg1uWuC22cN4Fvj8ZM11alE8oMwNk1Bro7XohYr3P5uDG03
	 n5zrvw5YVqTMIMZwHjbVNmTDNWVT+32IQ6ul7ir0cY6xpQBJRVNhgFycEW7BThuBrq
	 yCmUXG3WOYyK9E9xfWkBfy2HL6RO/nge9ZV95d3Wd9kETs1gs6jtobJGmSuMYgf6da
	 3r7zQ3T81PNGt2YM+agTDfB8pIDGBeMyPDoGGTKPZ93ejMKmmGIu6mnxFmqEGuobjp
	 6U/93af0cNUJzoFlGPhF9NaCNU/BGLA9svnU5eSMlkH2wO080pFMDnNfaHLw2ZoGAr
	 nOk6XCJAw3j2w==
Message-ID: <sashiko-outbox-221138@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 09/11] RDMA/mlx5: Cache the CQ core device and
 resolve it via cq_to_mdev()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Edward Srouji" <edwards@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117-mlx5-sd-prep-v1-9-8efd124c7895@nvidia.com>
References: <20261117-mlx5-sd-prep-v1-0-8efd124c7895@nvidia.com>
 <20261117-mlx5-sd-prep-v1-9-8efd124c7895@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 14:04:19 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [Critical] RDMA/mlx5: hardcoded CQE size breaks kernel CQ resize in
  mlx5_ib_resize_cq() [1]
--

commit f7f9b358d0115bb8244e5cdf7d781d650dc
Author: Akiva Goldberger <agoldberger@nvidia.com>

RDMA/mlx5: Cache the CQ core device and resolve it via cq_to_mdev()

This commit caches the mlx5_core_dev pointer in struct mlx5_ib_cq at CQ
creation time and introduces the cq_to_mdev() helper to resolve it instead
of going through dev->mdev.

> diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5=
/cq.c
> index b28ce05fab8f3..5eaf50fe7f540 100644
> --- a/drivers/infiniband/hw/mlx5/cq.c
> +++ b/drivers/infiniband/hw/mlx5/cq.c

[ ... ]

> @@ -1394,7 +1398,7 @@ int mlx5_ib_resize_cq(struct ib_cq *ibcq, unsigned =
int entries,
>  		struct mlx5_frag_buf *frag_buf;
> =20
>  		cqe_size =3D 64;
> -		err =3D resize_kernel(dev, cq, entries, cqe_size);
> +		err =3D resize_kernel(cq, entries, cqe_size);
>  		if (err)
>  			goto ex;
>  		frag_buf =3D &cq->resize_buf->frag_buf;

[Severity: Critical]
This problem wasn't introduced by this patch, but does hardcoding
cqe_size =3D 64 here break kernel CQ resize on systems with a 128-byte
cache line size [1]?

mlx5_ib_create_cq() initializes kernel CQs with a 128-byte CQE size when
cache_line_size() =3D=3D 128.  Allocating the resize buffer with cqe_size =
=3D 64
causes copy_resize_cqes() to reject the mismatch with -EINVAL after
mlx5_core_modify_cq() has already modified the CQ in hardware, leaving the
software and hardware CQ state out of sync:

drivers/infiniband/hw/mlx5/cq.c:copy_resize_cqes() {
    ...
	ssize =3D cq->buf.cqe_size;
	dsize =3D cq->resize_buf->cqe_size;
	if (ssize !=3D dsize) {
		mlx5_ib_warn(dev, "resize from different cqe size is not supported\n");
		return -EINVAL;
	}
    ...
}

[1] https://sashiko.dev/#/bug/linux-a14c4506-9ca5-444f-8be1-7990d9e001b0

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117-mlx5-sd-pr=
ep-v1-0-8efd124c7895@nvidia.com?part=3D9
