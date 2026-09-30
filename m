Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB5F343D85
	for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 01:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790731045; cv=none; b=s7Iezu6cjbR1qCG3kzSnxWGe83PIWXNgA7K+rNQoqz/TSziVgG+dxsjhWgwL2J89Y32tInSwzpJ87pB+P2BkwSpnqcwIQuazUt7nBVPA1kcDI/c8k4THayMHP9IzRirXiLIs5raOms4ywxAmvChuV21zv1bx8nKl4Cp2NYttLPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790731045; c=relaxed/simple;
	bh=s6JaG+djvBXlSwoOAw+Kn9NIjuuFxxkhL6fKp4dRON0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=G6NUrDKxV0pdJzOYWm6VcDkt+NT4+P+LSTT253bSStkL2Qoh1H4Q6GqXnCEGcqTY363F1IHMu1sgI7qhkVsyS6Xc+vjBKIR7S7yjYH3U5Xta2Q/xns3QSyAMuapcxa5CJVa/EQnqoUDVN1TsFmNpuLnnlAe8Ds8GlcFqZlzpLZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O2AsoAWm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O2AsoAWm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D89A41F000FF;
	Wed, 30 Sep 2026 01:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790731044;
	bh=PvBaFd9LoNJ6uuu2ruamSLkDUnIUEFiXdiJDcBbk3UU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=O2AsoAWmq7xV8MUNM5CNZGLLG0kPuN4sAx/hB2VWfOz+r2MEwi1bhyDXKtRr+EVz8
	 powqqg5AjKK6ApeJKNqKa5QmN393jrGMxR7V/7odp0p4FVDcHcY5z7BG0WHG/xFfEz
	 7Uls/P1xSOghy6k/jWhkOoYZ6UQjCwa6d3ipe+pyEU977Z3M7dNn1sAJkx+87F3eK9
	 WN8A7bacztswb3DDmF6Gd57wQZmMsPP6ezPo24heuVYpMb9c/gAXWeKxdTnyeOAUeQ
	 LPykoRUl5SMPdhWnOpJ6EcHInlBUj5i7+9UqsxS1OCoWMXX1wB+jLEzgm59VcYhtCm
	 vsgdSYYTjVlrQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] RDMA/mlx5: Fix destination index when resizing a CQ
Reply-To: sashiko-reviews@lists.linux.dev
To: lirongqing <lirongqing@baidu.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260930010630.2797-1-lirongqing@baidu.com>
References: <20260930010630.2797-1-lirongqing@baidu.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 30 Sep 2026 01:17:23 +0000
Message-Id: <20260930011723.D89A41F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] rdma: mlx5: OOB write in copy_resize_cqes() via negative signe=
d modulo
--

commit 0306cc5acf75dd86ce62818b27d260ae4841d2e6
Author: Li RongQing <lirongqing@baidu.com>

RDMA/mlx5: Fix destination index when resizing a CQ

This commit fixes the destination index calculation when resizing a CQ in t=
he
mlx5 driver. It replaces a bitwise AND with a modulo operation to ensure the
destination slot remains within the resized CQ buffer.

> diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5=
/cq.c
> index 072b77a2c8a6c..928330f8a6dab 100644
> --- a/drivers/infiniband/hw/mlx5/cq.c
> +++ b/drivers/infiniband/hw/mlx5/cq.c
> @@ -1313,7 +1313,7 @@ static int copy_resize_cqes(struct mlx5_ib_cq *cq)
> =20
>  	while (get_cqe_opcode(scqe64) !=3D MLX5_CQE_RESIZE_CQ) {
>  		dcqe =3D mlx5_frag_buf_get_wqe(&cq->resize_buf->fbc,
> -					     (i + 1) & cq->resize_buf->nent);
> +					     (i + 1) % cq->resize_buf->nent);
                                             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

[Severity: Critical]
Could this result in an out-of-bounds write?

In copy_resize_cqes(), i is an int assigned from the u32 counter
cq->mcq.cons_index. On high-throughput networks, cons_index can exceed
INT_MAX, causing i to become negative.

When i + 1 is negative, the signed modulo operation yields a negative
remainder. This negative value is passed to mlx5_frag_buf_get_wqe(), where =
it
is implicitly cast to u32 ix:

include/linux/mlx5/driver.h:mlx5_frag_buf_get_wqe() {
    ...
    frag =3D ix >> fbc->log_frag_strides;

    return fbc->frags[frag].buf + ((fbc->frag_sz_m1 & ix) << fbc->log_strid=
e);
}

This cast results in a massive unsigned value, leading to an out-of-bounds
pointer for dcqe. The subsequent memcpy(dcqe, scqe, dsize) would then
corrupt kernel memory.

>  		dcqe64 =3D dsize =3D=3D 64 ? dcqe : dcqe + 64;
>  		sw_own =3D sw_ownership_bit(i + 1, cq->resize_buf->nent);
>  		memcpy(dcqe, scqe, dsize);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260930010630.2797=
-1-lirongqing@baidu.com?part=3D1
