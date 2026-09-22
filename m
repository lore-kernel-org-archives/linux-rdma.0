Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC735221CE;
	Tue, 22 Sep 2026 22:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790116709; cv=none; b=dtPgDZ3Ehcc+ypsbyE1AdyJIGXP5/lhd4WHh0qNhWPfreQiMmj8Xah7oj1KfVd12E48Cc4M9jJQ70XxwI7Tl5+lGBKoDwQHod55IJjK5QcnfKRVaevQC+buoGcz4BFbMk3g1CZ7LiGBp9E7eWqmPfwdUgTEbwON0Qs10pXgm2PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790116709; c=relaxed/simple;
	bh=7QL8zI6/wDv+GRPyt2EbimkIRRmmiJ1E+yJQG+nwMYs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Li6D/5ptOGG/qM0sVj77QE14u3xLKBnhUeg4uPQ46iTqmJG/purMBQ4H7oM0qdr+7kT8ecYlLmyk9E+pc3yYSSnJe7c2EW+fU9QOjfZVqewIbKdQvWlPN8xb0/CkXXh59xT0CIdeidSdzpnXQJ333kQxFVVgACKsMIlVVIxqX9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fg0M/PeF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fg0M/PeF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E4201F0089F;
	Tue, 22 Sep 2026 22:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790116691;
	bh=bDXrAxR+KD7svLSNhKvedjEx+oYWs46xcK7EYZZGKlk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Fg0M/PeFBIuQd98l7h0j37uHQHEerF2dJy+bUIiaGjEznB9WXojS+/nEuAht1fGPC
	 RKE6y5eWgFCblsZpGOljpCOIttsgQUDREd+5BT5cv9s+SVWxsQMBMxdxFchPnQZaPu
	 3MQHcpcP1vtdAiCSqPeAMhhB7bFliH1xinr/nnIFrer31I3IyY3IPqF/1Ge4l1afzI
	 MOnOyh1BCTd3ibuoRp45a6pWAIpb0vMJpknuAphEYNWujm7A1x57GJDxLU8uKkGAVI
	 CjsL/SDNEAxe7/Mm5VOsElPlI4AnGhi9UUl2YMIMAkebPPJYu99KUNImbynYVXFY8o
	 Q0ctW36fqxTGw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 09/10] vfio: selftests: Add mlx5 driver - data path
 and memcpy ops
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jason Gunthorpe" <jgg@nvidia.com>
Cc: linux-rdma@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <9-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>
References: <9-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 22:38:10 +0000
Message-Id: <20260922223810.9E4201F0089F@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] hw race condition in mlx5st_poll_cq_batch due to premature CQ do=
orbell update
--

commit 6b2a87450d158c064575c07067d4356a0b0950cd
Author: Jason Gunthorpe <jgg@ziepe.ca>

vfio: selftests: Add mlx5 driver - data path and memcpy ops

Complete the mlx5 driver by adding CQ/QP creation, QP state
transitions, WQE posting, CQ polling, and the
memcpy_start/memcpy_wait callbacks.

> diff --git a/tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5.c b/tools=
/testing/selftests/vfio/lib/drivers/mlx5/mlx5.c
> index 5a87d070dc425..fff3babef5e78 100644
> --- a/tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5.c
> +++ b/tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5.c

[ ... ]

> +static int mlx5st_poll_cq_batch(struct mlx5st_device *dev,
> +				unsigned int max_cqe)
> +{
> +	unsigned int polled =3D 0;
> +
> +	while (polled < max_cqe) {
> +		unsigned int idx =3D dev->cq_ci % CQ_CQE_CNT;
> +		struct mlx5st_cqe64 *cqe =3D &dev->cq_buf[idx];
> +		u8 owner, opcode;
> +
> +		owner =3D MLX5_GET_ONCE(cqe64, cqe, owner);
> +		if (owner !=3D ((dev->cq_ci >> LOG_CQ_SIZE) & 1))
> +			break;
> +
> +		dma_rmb();
> +
> +		opcode =3D MLX5_GET(cqe64, cqe, opcode);
> +
> +		dev->cq_ci++;
> +		WRITE_ONCE(dev->cq_dbrec.recv_counter,
> +			   cpu_to_be32(dev->cq_ci & 0xffffff));
> +
> +		if (opcode =3D=3D MLX5_CQE_REQ) {
> +			dev->sq_ci =3D
> +				(u16)(MLX5_GET(cqe64, cqe, wqe_counter) + 1);

[Severity: Medium]
Could this sequence cause a read-after-release hardware race regression?

Looking at mlx5st_poll_cq_batch(), dev->cq_ci is incremented and the CQ
doorbell (recv_counter) is updated before extracting wqe_counter or the err=
or
syndrome from the CQE.

Updating the doorbell record releases the CQE slot back to the device.
If the hardware is actively pushing new completions, could it overwrite
the CQE memory via DMA while the CPU is still extracting the necessary
fields from it?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/0-v7-c6d30e8ce1e4+3=
dfa6-mlx5st_jgg@nvidia.com?part=3D9
