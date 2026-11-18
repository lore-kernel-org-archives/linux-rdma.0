Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795010657;
	b=OHwAB95YYUwvOBmmN+f/oCiVcf290Tkq076KgcPrpANbKakM+n9tDonc9jTPEn0j8I/j
	 787o1ukWCrxzebjF+xvtvdmQS+aoI/q/kkRBsKgWXwoMUV7ThR0z3mgElTYt93dxNUkSv
	 50Hjk6F/t1K1stOaGx7Bq9FFDcDyIQcYJrJXH/FWmxp93s3qVjm2IdVeIOuGMaSfyQXBp
	 GEI1WFkkgQoGEcGe10Yr9ZxTOHb7MZFDbBfPtzez57OAQo5Nnf99UTp+rH2bfkfI8jOoR
	 GKAkygcEA/djd/7FBfTgaVIkVfsQTQoNgUiO8B+hN62FjFCfrsvbDc2Q9es3xx8BNKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795010657;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=EXO5FBGuL+QzwnmTsSj6hOqoyeNKUOP7Gvpwg4eb29g=;
	b=j3vpsPf2IpMS0GswxKMdSmGaf93yjhqzGmnsIIGYE4miY8pktKPKI6fpy8k5MLY8mqYm
	 cMUXpTuxE5DJKng2YJJ7KQj3bu9ptoBFSvvYbRdUDYyCbRyci5v5F3rxjilsNqNZHxhzv
	 xvFkjkf5Dj8NWRUCs2LeC8TZ0yDk2HhhryyyIZqe5Xg+Q9lyu4xykIhTfGhz3xu5ejo3H
	 hZ6EkvYJ2UIxcwenmk5BSR/2T17NJEyILNLNV7iExH/M1fAdGK1407jEzmyLqoXHjQLCp
	 hsd78ZRD2Kbekh+lbwWKnqirJYNSiBrrBcPgYAJDcpb6Zrb8UJaRZabiHZLE2oZdtUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="MyMjRn/5";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 792B5606A33E
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 14:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MyMjRn/5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D8FD1F000C4;
	Wed, 18 Nov 2026 14:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795010657;
	bh=EXO5FBGuL+QzwnmTsSj6hOqoyeNKUOP7Gvpwg4eb29g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MyMjRn/5dUWm8N3S9+r/rTm93ZEMW2mruy1BAZcMeiC5djtgI8qJezx0Qgt1N6ppv
	 pTwfHIlkNIyTBLTmviDb1O1w7PJKJwM8RTnlFaA/0fpaLE18O54fRpW8TlvsCPYLv5
	 HM3WRm7lufV9mWl/X7JJl9CT3bFJjKJs4ne0jijfwswi+e+sUKjzeAvGB/jyZ1az7D
	 5rxLUhwHY/i/ro4+royOc3c18WuH3osnBGp5q0KD8hwTNmUqxxj/x1vi6+yP7ioZwM
	 +B0I37T99omfESj325Pw7wAxcsto9GJQwzSLB4vocN09ryPi8qwZm/ewWsG8uNBEi5
	 SnPeBRgORXojQ==
Message-ID: <sashiko-outbox-221134@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 05/11] RDMA/mlx5: Cache the MR core device and
 resolve the MW's via its PD
Reply-To: sashiko-reviews@lists.linux.dev
To: "Edward Srouji" <edwards@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117-mlx5-sd-prep-v1-5-8efd124c7895@nvidia.com>
References: <20261117-mlx5-sd-prep-v1-0-8efd124c7895@nvidia.com>
 <20261117-mlx5-sd-prep-v1-5-8efd124c7895@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 14:04:16 +0000
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
- [High] RDMA/mlx5: unlocked state check in mlx5r_umr_post_send() misses
  error flush [1]
--

commit 6252ceba1b31eba36693680458665fa14b71227b
Author: Akiva Goldberger <agoldberger@nvidia.com>

RDMA/mlx5: Cache the MR core device and resolve the MW's via its PD

This commit caches the mlx5_core_dev pointer in struct mlx5_ib_mr and adds
mr_to_mdev() and mw_to_mdev() helpers so MR and MW operations resolve the
core device from the resource instead of dev->mdev.

> diff --git a/drivers/infiniband/hw/mlx5/umr.c b/drivers/infiniband/hw/mlx=
5/umr.c
> index f030885505df5..f9485591130d3 100644
> --- a/drivers/infiniband/hw/mlx5/umr.c
> +++ b/drivers/infiniband/hw/mlx5/umr.c

[ ... ]

> @@ -243,8 +243,7 @@ static int mlx5r_umr_post_send(struct ib_qp *ibqp, u3=
2 mkey, struct ib_cqe *cqe,
>  		with_data ? sizeof(struct mlx5r_umr_wqe) :
>  			    sizeof(struct mlx5r_umr_wqe) -
>  				    sizeof(struct mlx5_wqe_data_seg);
> -	struct mlx5_ib_dev *dev =3D to_dev(ibqp->device);
> -	struct mlx5_core_dev *mdev =3D dev->mdev;
> +	struct mlx5_core_dev *mdev =3D qp_to_mdev(ibqp);
>  	struct mlx5_ib_qp *qp =3D to_mqp(ibqp);
>  	struct mlx5_wqe_ctrl_seg *ctrl;
>  	union {

[Severity: High]
This problem wasn't introduced by this patch, but can checking mdev->state
outside qp->sq.lock in mlx5r_umr_post_send() [1] cause
mlx5r_umr_post_send_wait() to hang forever in wait_for_completion()?

mlx5_ib_handle_internal_error() walks ibdev->qp_list under mqp->sq.lock and
arms send_mcq for software flushing only when mqp->sq.tail !=3D mqp->sq.hea=
d.
Because mlx5r_umr_post_send() checks mdev->state before taking qp->sq.lock,
it can queue a WQE after the error handler has already checked the SQ:

CPU0                                  CPU1
mlx5r_umr_post_send_wait()
  down(&umrc->sem)
  mlx5r_umr_post_send()
    if (mdev->state =3D=3D
        MLX5_DEVICE_STATE_INTERNAL_ERROR)
                                      enter_error_state()
                                        mdev->state =3D
                                          MLX5_DEVICE_STATE_INTERNAL_ERROR
                                        mlx5_ib_handle_internal_error()
                                          spin_lock(&mqp->sq.lock)
                                          if (mqp->sq.tail !=3D mqp->sq.hea=
d)
                                            /* arm send_mcq for SW flush */
                                          spin_unlock(&mqp->sq.lock)
    spin_lock_irqsave(&qp->sq.lock, flags)
    mlx5r_finish_wqe(...)
    mlx5r_ring_db(...)
    spin_unlock_irqrestore(&qp->sq.lock, flags)
  wait_for_completion(&umr_context.done)  <-- hangs forever holding umrc->s=
em

With hardware completions stopped and software flushing already past this Q=
P,
umr_context.done is never completed, blocking subsequent UMR operations and
device teardown on umrc->sem.  Checking mdev->state under qp->sq.lock (as
mlx5_ib_post_send() does) avoids this race.

[1] https://sashiko.dev/#/bug/linux-d43f2378-f2de-4246-8c9d-53b5f5f256a1

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117-mlx5-sd-pr=
ep-v1-0-8efd124c7895@nvidia.com?part=3D5
