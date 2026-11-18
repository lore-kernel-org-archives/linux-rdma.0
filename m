Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795010656;
	b=i1ps/JDpJ7LoHj725TO3XogdhVc2RwLJwB+E/cBB87dbVN6+dJQmnYk0lLgrZBghFydS
	 r90yLUpyvrQ8TglKtgz2DbTzre1gHL4M694FdmplkqZ7s2ds0QzDNGwDMpPXDPxRtSG2V
	 WcYjFbJPuKKU4AU4zkKAHT0LWAcQp8Ek5aVsAEco9JA6IR9hS+PKqVwcSHQC2clKl79dL
	 t8yaAs3bUGTdgn0cYpEzqlaqNO5S6DbfXYB139iXsoUc3s6loD0WoAVOwDWtP53sCMBzD
	 cz02dF1eHjLiia06a6BPAxzkV8D2Wxz9yqk/TyNtO0WixBrzYfXpYwhOzc8P9Kld1iQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795010656;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=jLD1R8Sgpu70Uw6pLiBvwiaKLm/oclmkfKXXKIlxoIc=;
	b=1ggHAuW+tes0oIFobfPnfylcBMFc7N3W85yp9kTbod7ZNa0QOinqx4XNbdLLrnneKKj0
	 5nZHgkSrAhxF/ghFiv1ucYEak10rwGvdlKvRDRIfeW2HHRfMmoHLyOQ6z1FVC8wS8d8dw
	 gmZbyxKSF8MbIqviop95w12qMWtiKZttGi/ScA48OPjZoyRuvNFmzsvtgNhhYwxabBiXM
	 trze/WV0PbgeY4fIorxJw/VKEwR2LG9hZJv6QLql5WqtoQfc2pc93yvA+KKq8/wE6iGO+
	 kMTbs4o9wsLcOFiiiDjRoa55tEmCR9Bd+Dd0qE9hdPiEOt3u65TgUGWM59vxKoiRoXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FUCigQcU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC4C606A338
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 14:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FUCigQcU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DE731F000C4;
	Wed, 18 Nov 2026 14:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795010656;
	bh=jLD1R8Sgpu70Uw6pLiBvwiaKLm/oclmkfKXXKIlxoIc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FUCigQcUH9vqg20FZLi0nMgji7QCrIM/qbCUA5I8zUKPEooyZeS5fMifkx4RP4M4g
	 n7Ollva4cy1DWEdfQD5bhuBn8ftk9/kj/ZqDNVSlMGeU0oVQIAreOBLNNdVwlTX9Nw
	 Wsa6p2fjyFT5kZQeeYF5+uqsS+H7ANyM3G6t5twj+wohtj8qvdYmnXfRkBelOqSAbZ
	 y/KbGLf4kAtNnZbuuDKwdklHVXuj8JGFRXGa1CCYPszxqr4K2dMRZr7NQ5tWw6ZdMv
	 j2OKhFDnvtoFm3x9gHjb7sCEut0YC5U7i9BPN3Oidguz0f2UCW3bNwoVFzn3jRuVzv
	 9e4jzcy/LXWiQ==
Message-ID: <sashiko-outbox-221133@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 04/11] RDMA/mlx5: Select the core device
 through PD for QP commands
Reply-To: sashiko-reviews@lists.linux.dev
To: "Edward Srouji" <edwards@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117-mlx5-sd-prep-v1-4-8efd124c7895@nvidia.com>
References: <20261117-mlx5-sd-prep-v1-0-8efd124c7895@nvidia.com>
 <20261117-mlx5-sd-prep-v1-4-8efd124c7895@nvidia.com>
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
in this patch, but noticed 2 related pre-existing issues it does not
introduce:
- [Critical] RDMA/mlx5: unhandled error in destroy_raw_packet_qp_rq()
  causes use-after-free [1]
- [High] RDMA/mlx5: unchecked to_ib_qp_state() return in query_qp_attr()
  [2]
--

commit c8de8977935b4bc94238c72869a744ae61d62546
Author: Akiva Goldberger <agoldberger@nvidia.com>

RDMA/mlx5: Select the core device through PD for QP commands

This commit introduces qp_to_mdev() to resolve the core device from a QP's
associated PD and updates QP, RQ, SQ, and DCT command helpers to obtain the
core device from the PD or caller.

> diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5=
/qp.c
> index da4e9a52d2f9b..2196e06f593e1 100644
> --- a/drivers/infiniband/hw/mlx5/qp.c
> +++ b/drivers/infiniband/hw/mlx5/qp.c

[ ... ]

> @@ -1526,17 +1525,16 @@ static int create_raw_packet_qp_rq(struct mlx5_ib=
_dev *dev,
>  	pas =3D (__be64 *)MLX5_ADDR_OF(wq, wq, pas);
>  	mlx5_ib_populate_pas(umem, page_size, pas, 0);
> =20
> -	err =3D mlx5_core_create_rq_tracked(dev, in, inlen, &rq->base.mqp);
> +	err =3D mlx5_core_create_rq_tracked(pd, in, inlen, &rq->base.mqp);
> =20
>  	kvfree(in);
> =20
>  	return err;
>  }
> =20
> -static void destroy_raw_packet_qp_rq(struct mlx5_ib_dev *dev,
> -				     struct mlx5_ib_rq *rq)
> +static void destroy_raw_packet_qp_rq(struct ib_pd *pd, struct mlx5_ib_rq=
 *rq)
>  {
> -	mlx5_core_destroy_rq_tracked(dev, &rq->base.mqp);
> +	mlx5_core_destroy_rq_tracked(pd, &rq->base.mqp);
>  }

[Severity: Critical]
This problem wasn't introduced by this patch, but can ignoring the return
value of mlx5_core_destroy_rq_tracked() in destroy_raw_packet_qp_rq()
[1] cause a use-after-free?

When the firmware DESTROY_RQ command fails, mlx5_core_destroy_rq_tracked()
re-enables the resource and leaves &rq->base.mqp in dev->qp_table.tree:

drivers/infiniband/hw/mlx5/qpc.c:mlx5_core_destroy_rq_tracked() {
	...
	modify_resource_common_state(dev, rq, true);
	ret =3D destroy_rq_tracked(pd_to_mdev(pd), rq->qpn, rq->uid);
	if (ret) {
		modify_resource_common_state(dev, rq, false);
		return ret;
	}
	destroy_resource_common(dev, rq);
	return 0;
}

Because destroy_raw_packet_qp_rq() drops that error, raw packet QP teardown
completes and frees the enclosing mlx5_ib_qp.  If an asynchronous firmware
event later arrives for the undestroyed RQ, rsc_event_notifier() looks up
the dangling pointer in the radix tree and calls qp->event() on freed
memory.

[ ... ]

> @@ -5122,8 +5123,8 @@ static int query_qp_attr(struct mlx5_ib_dev *dev, s=
truct mlx5_ib_qp *qp,
>  	if (!outb)
>  		return -ENOMEM;
> =20
> -	err =3D mlx5_core_qp_query(dev, &qp->trans_qp.base.mqp, outb, outlen,
> -				 false);
> +	err =3D mlx5_core_qp_query(qp_to_mdev(qp), &qp->trans_qp.base.mqp, outb,
> +				 outlen, false);
>  	if (err)
>  		goto out;

[Severity: High]
This problem wasn't introduced by this patch, but can query_qp_attr() store
an invalid state in qp->state [2] and cause an out-of-bounds read
in ib_modify_qp_is_ok()?

Just below this call, query_qp_attr() assigns to_ib_qp_state() directly to
 the u8 field qp->state:

drivers/infiniband/hw/mlx5/qp.c:query_qp_attr() {
	...
	qpc =3D MLX5_ADDR_OF(query_qp_out, outb, qpc);

	qp->state =3D to_ib_qp_state(MLX5_GET(qpc, qpc, state));
	...
}

For any hardware QPC state not handled in to_ib_qp_state() (such as
MLX5_QP_STATE_SUSPENDED), to_ib_qp_state() returns -1, which truncates to
255 in qp->state.  A subsequent mlx5_ib_modify_qp() call without
IB_QP_CUR_STATE in attr_mask passes cur_state =3D qp->state (255) to
ib_modify_qp_is_ok(), indexing past the 7x7 qp_state_table[] array.

[1] https://sashiko.dev/#/bug/linux-314256a0-4860-4700-943f-7cc6aed26289
[2] https://sashiko.dev/#/bug/linux-05b234dc-14ed-449f-97cf-d7b4682a7a8d

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117-mlx5-sd-pr=
ep-v1-0-8efd124c7895@nvidia.com?part=3D4
