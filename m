Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A276B4C042D;
	Thu, 17 Sep 2026 23:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789689169; cv=none; b=VS4iu2S3OQfA24qCzX76OfR5L+HG6EV7XxUppAjjml6tYuB87XmTbXy4SEozqqfk6q0QedTBOdwnA7zfxkiRFc2PrqDNP9uU2GhmjtOMoweA3iN5p9bUpxNH0S2pAOkKwNIzwGMba6qndjB9UuCKKIE6oMxWS7FF4n340Uq8n2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789689169; c=relaxed/simple;
	bh=cwdvZpoTlN+kWYAuaT9XQ965xYx67kjaEwdMEoi90wQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=b5c4vaQlDbx4VNiIiZa6O7mw8OIqHyQ1fFqPdtuOJSFzw1WRLhl+P3sFCCmcg9hWA1X9Betyvo2H8u2Ws+E7V2BUnRNODeYZYFuLDzwZLh/3LYwePbi33PsxC+O36Ve+GVDj2gZXeQC1Q/8MhbAtMRUgsXhf8F/OdN8SnoiAqbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gWRbhwwU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gWRbhwwU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39A741F000FF;
	Thu, 17 Sep 2026 23:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789689167;
	bh=HZV6emmndWoVHX4mt3zdM0uHQ8No9Dj0S+Ahbd2A1Ag=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gWRbhwwUJ80JDZvAnhpU4xgEYQdo7QWbmJsBk4XWfQ2jhIEeRozX2SExOq4lc4tfl
	 zjwDKUIosZvcGMZv6TaOy8xXrsu0RoDoqqqqwBo/dWhm1JNXcHJ9ZMAsm9e1Ov1FLs
	 l9JfJClnIhO3guZr1g2yOaxBncFWzoWUl3Owrluzdrv/PJwZeX7KSonDcNCxPfidQU
	 mVGUaC4rHvMfs5ZNtY2AzO9ZRmzSLavgak0hs1+drjdV7qxNPuWovbWWEdVcSV6wYk
	 j0bM71kMNXAlslmHjRRBD9tjocLy8fyvIObYQ3L0h1WExqY6U+NPiqvLJBH39854Fi
	 mMAydvM0WDLRg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 09/10] vfio: selftests: Add mlx5 driver - data path
 and memcpy ops
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jason Gunthorpe" <jgg@nvidia.com>
Cc: linux-rdma@vger.kernel.org, kvm@vger.kernel.org
In-Reply-To: <9-v6-8af36cf7b73f+e2-mlx5st_jgg@nvidia.com>
References: <9-v6-8af36cf7b73f+e2-mlx5st_jgg@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 23:52:46 +0000
Message-Id: <20260917235247.39A741F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Medium] vfio/mlx5: HW interface violation in SQ producer index and WQE p=
lacement
- [Medium] vfio/mlx5: strict aliasing violation when ringing doorbell via _=
_be64 *
- [Medium] vfio/mlx5: HW DMA race condition due to early CQ doorbell update
--

commit 406822320648621808cbbbbee7e4d206bcd69e8e
Author: Jason Gunthorpe <jgg@ziepe.ca>

vfio: selftests: Add mlx5 driver - data path and memcpy ops

Complete the mlx5 driver by adding CQ/QP creation, QP state transitions, WQE
posting, CQ polling, and the memcpy_start/memcpy_wait callbacks. The data p=
ath
implements RDMA Write self-loopback via an RC QP.

Acked-by: David Matlack <dmatlack@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

> diff --git a/tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5.c b/tools=
/testing/selftests/vfio/lib/drivers/mlx5/mlx5.c
> index 5a87d070dc425..fff3babef5e78 100644
> --- a/tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5.c
> +++ b/tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5.c

[ ... ]

> @@ -1509,24 +1509,24 @@ static void mlx5st_post_rdma_write(struct mlx5st_=
device *dev, u64 src_addr,
>  				    u32 src_lkey, u64 dst_addr, u32 dst_rkey,
>  				    u32 length, bool signaled)
>  {
>  	struct mlx5st_send_wqe *wqe;
>  	unsigned int idx;
> =20
>  	idx =3D dev->sq_pi % SQ_WQE_CNT;
>  	wqe =3D &dev->sq_buf[idx];

[Severity: Medium]
Are we correctly translating between the hardware WQEBB index and our WQE
array index in mlx5st_post_rdma_write()?=20

The hardware mandates 16-byte WQE Basic Blocks (WQEBBs), but the driver
calculates the WQE placement assuming a 64-byte stride (SQ_WQE_CNT).=20

Could this misalign with what the hardware expects for the send queue?

>  	memset(wqe, 0, sizeof(*wqe));
>  	MLX5_SET(wqe_ctrl_seg, &wqe->ctrl, opcode, MLX5_OPCODE_RDMA_WRITE);
>  	MLX5_SET(wqe_ctrl_seg, &wqe->ctrl, wqe_index, dev->sq_pi);
>  	MLX5_SET(wqe_ctrl_seg, &wqe->ctrl, qp_or_sq, dev->qpn);
>  	MLX5_SET(wqe_ctrl_seg, &wqe->ctrl, ds, MLX5_RDMA_WRITE_DS);

[Severity: Medium]
Here wqe_index is being populated with dev->sq_pi, which seems to be the raw
WQE count, but ds correctly declares the size as 3 WQEBBs.=20

Should wqe_index instead track the actual WQEBB index rather than the number
of submitted WQEs?

>  	if (signaled)
>  		MLX5_SET(wqe_ctrl_seg, &wqe->ctrl, ce, MLX5_WQE_CE_CQE_ALWAYS);
> =20
>  	MLX5_SET64(wqe_raddr_seg, &wqe->raddr, raddr, dst_addr);
>  	MLX5_SET(wqe_raddr_seg, &wqe->raddr, rkey, dst_rkey);
> =20
>  	MLX5_SET(wqe_data_seg, &wqe->data, byte_count, length);
>  	MLX5_SET(wqe_data_seg, &wqe->data, lkey, src_lkey);
>  	MLX5_SET64(wqe_data_seg, &wqe->data, addr, src_addr);
> =20
>  	dev->sq_pi++;
> =20
>  	/* Ensure WQE is visible to device before doorbell record */
>  	dma_wmb();
> =20
>  	WRITE_ONCE(dev->qp_dbrec.send_counter,
>  		   cpu_to_be32(dev->sq_pi & 0xffff));

[Severity: Medium]
By incrementing sq_pi by 1 per WQE instead of advancing it by the length of
the WQE (3 segments), does this desynchronize the producer index from the
hardware's expected WQEBB offset?=20

This looks like it might cause the hardware to read past queue boundaries
or halt.

>  	/*
>  	 * Ring doorbell: write first 8 bytes of ctrl to UAR BF register,
>  	 * iowrite has an internal dma_wmb() so the doorbell record will be
>  	 * visible.
>  	 */
>  	iowrite64be(be64_to_cpu(*(__be64 *)wqe),
>  		    (u8 __iomem *)dev->uar_base + dev->uar_bf_offset);

[Severity: Medium]
Does this cast in mlx5st_post_rdma_write() break strict aliasing rules?=20

wqe is a pointer to struct mlx5st_send_wqe, and reading it via __be64 * is
an incompatible pointer cast. Since this code resides in tools/ where
-fstrict-aliasing applies, could the compiler reorder this read before the
preceding MLX5_SET writes and send uninitialized data to the doorbell?

>  	dev->uar_bf_offset ^=3D MLX5_BF_SIZE;
>  }

[ ... ]

> @@ -1565,24 +1565,24 @@ static int mlx5st_poll_cq_batch(struct mlx5st_dev=
ice *dev,
>  		owner =3D MLX5_GET_ONCE(cqe64, cqe, owner);
>  		if (owner !=3D ((dev->cq_ci >> LOG_CQ_SIZE) & 1))
>  			break;
> =20
>  		dma_rmb();
> =20
>  		opcode =3D MLX5_GET(cqe64, cqe, opcode);
> =20
>  		dev->cq_ci++;
>  		WRITE_ONCE(dev->cq_dbrec.recv_counter,
>  			   cpu_to_be32(dev->cq_ci & 0xffffff));
> =20
>  		if (opcode =3D=3D MLX5_CQE_REQ) {
>  			dev->sq_ci =3D
>  				(u16)(MLX5_GET(cqe64, cqe, wqe_counter) + 1);

[Severity: Medium]
Could updating the doorbell record (recv_counter) in mlx5st_poll_cq_batch()
before fully reading the CQE's payload create a hardware race condition?

If the hardware immediately reuses this slot upon seeing the doorbell updat=
e,
it might overwrite the buffer before we fetch the remaining fields like
wqe_counter on the next line (or error_syndrome below).

>  			polled++;
>  			continue;
>  		}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/0-v6-8af36cf7b73f+e=
2-mlx5st_jgg@nvidia.com?part=3D9
