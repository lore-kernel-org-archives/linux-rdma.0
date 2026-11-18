Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795010655;
	b=iR6p+agEAA591PHK1LliSDdnCg0YvqAUpT7YVgGPR5r/Ejh5zrWgnlpTrpOuIg/UEV3Y
	 zGso37VA3K487+oAS2Qc1+1ziqroQq0wYRugPpsAta4kz/wNpeTVq0srKLRKN3/QutX+q
	 j0y5g5jI83GU49n1WJUHFHstQGaA+JwBH/zJy/SoN7pbtFrZIenJ/29PJyEV+Gbh6NvMY
	 xH176aKza8i4N6JHXMb6o3r2x1N2A5D27B5cnHcIw61e14e2MRHp3fdbqC5Iinv5ETN+A
	 RE87CI+uq1SQ3k968sWU8sMsIuO7YQyIedJTV8H47g/qg7f3o7XvDN1w9X29mchUWyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795010655;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=qPVgI8ZVMDlAfUPQiN1oWgOkHQvlDlwSn0I9jyPSlGA=;
	b=M52w8WnHUyoKCYjHnm81s1UUszcd/+wGEDmSlREC8vste8HAzdEbHxWMrNGpbFmQ1tbT
	 qFJsPNYmfP1+yS2za79xQ7CZH/OwYcyGJq4ajVO46mreeIDfsjaTUpPm57X9N4Oyp1VM9
	 F6hc6uVigcVyl7YPmvJYcS3IViSCdUPYOWsfjw8gc9IWjdUsd44U3jRX3dmOZtjY94T52
	 3E5DpmySOCztVfqjoCUdj4fNgLhpiTm46xGheQkStW40bAVPISFmTf0r2uANvkaf90yGQ
	 39WrSmUbXJJJLhOS85lIM6d4XaHsuGdY0+mcvRiM30r8C04jyr2geuIHbg6m3sUq6nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eVTW6trL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98580606A325
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 14:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eVTW6trL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49D861F000C5;
	Wed, 18 Nov 2026 14:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795010655;
	bh=qPVgI8ZVMDlAfUPQiN1oWgOkHQvlDlwSn0I9jyPSlGA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eVTW6trLsrRyFrDvLCgmiqOAxYKUxb48ZLSVCtThnFs/YNtNW8+ADqo8cOPRybWsD
	 F1+o7yKaIEVxoDsZIU/K0wNVrOpd9ViJo8TlfWzcukv9od8ey30d0v9P5ZDjNQ0AOW
	 nTFSp+UeEHYvDxHqtgvUTblu2ULpx1xFUqUsXkeUHbRzV98oKKIkSQelk44ugjLyOT
	 foakh/o2YTr9XR6QAwOCqda2mh+FW80WtZJ74YFqUYXi9DMYtN9Aj9nPtZiC8A9Do0
	 /Ya3GbFv4aKVPpAHBsDsMzfCHnSEy6Y9bBz3sZHzWMSs4UmkGJj0Nj5/Qt4ud6Mp9I
	 q2TNxQEujr2Lw==
Message-ID: <sashiko-outbox-221131@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 02/11] RDMA/mlx5: Rename to_mdev() helpers
 that return an IB device
Reply-To: sashiko-reviews@lists.linux.dev
To: "Edward Srouji" <edwards@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117-mlx5-sd-prep-v1-2-8efd124c7895@nvidia.com>
References: <20261117-mlx5-sd-prep-v1-0-8efd124c7895@nvidia.com>
 <20261117-mlx5-sd-prep-v1-2-8efd124c7895@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 14:04:14 +0000
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
- [High] RDMA/mlx5: memory leak of implicit child MRs in
  mlx5_ib_free_odp_mr() [1]
- [High] RDMA/mlx5: NULL pointer dereference in mlx5_ib_wq_event() [2]
--

commit 19b81e90add2578f27e3e1241ff81dd5b9fdd061
Author: Akiva Goldberger <agoldberger@nvidia.com>

RDMA/mlx5: Rename to_mdev() helpers that return an IB device

This commit renames to_mdev(), mr_to_mdev(), and mlx5_udata_to_mdev() to
to_dev(), mr_to_dev(), and udata_to_dev() across the mlx5_ib driver to match
their struct mlx5_ib_dev return type.

> diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx=
5/odp.c
> index 0b1b63d36e4bc..a4318b11cd81b 100644
> --- a/drivers/infiniband/hw/mlx5/odp.c
> +++ b/drivers/infiniband/hw/mlx5/odp.c

[ ... ]

> @@ -680,10 +680,10 @@ void mlx5_ib_free_odp_mr(struct mlx5_ib_mr *mr)
>  	}
> =20
>  	if (mr->null_mmkey.key) {
> -		xa_erase(&mr_to_mdev(mr)->odp_mkeys,
> +		xa_erase(&mr_to_dev(mr)->odp_mkeys,
>  			 mlx5_base_mkey(mr->null_mmkey.key));
> =20
> -		mlx5_core_destroy_mkey(mr_to_mdev(mr)->mdev,
> +		mlx5_core_destroy_mkey(mr_to_dev(mr)->mdev,
>  				       mr->null_mmkey.key);
>  	}
>  }

[Severity: High]
This problem wasn't introduced by this patch, but can mlx5_ib_free_odp_mr()
leak implicit child MRs [1] when a page fault races with teardown?

mlx5_ib_free_odp_mr() drains mr->implicit_children before removing
mr->null_mmkey.key from dev->odp_mkeys:

drivers/infiniband/hw/mlx5/odp.c:mlx5_ib_free_odp_mr() {
	...
	xa_for_each(&mr->implicit_children, idx, mtt) {
		xa_erase(&mr->implicit_children, idx);
		mlx5_ib_dereg_mr(&mtt->ibmr, NULL);
	}

	if (mr->null_mmkey.key) {
		xa_erase(&mr_to_dev(mr)->odp_mkeys,
			 mlx5_base_mkey(mr->null_mmkey.key));
	...
}

Because null_mmkey remains in odp_mkeys while the loop runs, a concurrent
page fault can still look it up and insert a new child MR after the loop
finishes:

CPU0                              CPU1
mlx5_ib_free_odp_mr()
  xa_for_each(&mr->implicit_children, ...)
    xa_erase(...)
                                  pagefault_single_data_segment()
                                    find_odp_mkey() -> null_mmkey
                                    pagefault_implicit_mr()
                                      implicit_get_child_mr()
                                        __xa_cmpxchg(&imr->implicit_childre=
n, ...)
  xa_erase(&dev->odp_mkeys, ...)

The newly inserted child MR and its xarray nodes are then leaked when the
parent MR is freed.  Erasing null_mmkey from odp_mkeys and waiting for
in-flight faults to complete before draining implicit_children would avoid
this.

[ ... ]

> diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5=
/qp.c
> index e4f18f7567d67..da4e9a52d2f9b 100644
> --- a/drivers/infiniband/hw/mlx5/qp.c
> +++ b/drivers/infiniband/hw/mlx5/qp.c

[ ... ]

> @@ -5331,7 +5331,7 @@ static void mlx5_ib_wq_event(struct mlx5_core_qp *c=
ore_qp, int type)
>  {
>  	struct mlx5_ib_rwq *rwq =3D to_mibrwq(core_qp);
> -	struct mlx5_ib_dev *dev =3D to_mdev(rwq->ibwq.device);
> +	struct mlx5_ib_dev *dev =3D to_dev(rwq->ibwq.device);
>  	struct ib_event event;
> =20
>  	if (rwq->ibwq.event_handler) {

[Severity: High]
This problem wasn't introduced by this patch, but can an asynchronous WQ
event trigger a NULL pointer dereference [2] in mlx5_ib_wq_event()
before the RDMA core finishes initializing rwq->ibwq?

In UVERBS_HANDLER(UVERBS_METHOD_WQ_CREATE), the core sets wq->device and
wq->uobject only after ops.create_wq() returns, whereas mlx5_ib_create_wq()
sets rwq->ibwq.event_handler and activates the hardware RQ before returning:

CPU0                              CPU1
UVERBS_HANDLER(UVERBS_METHOD_WQ_CREATE)
  mlx5_ib_create_wq()
    create_rq()
      mlx5_core_create_rq_tracked()
    rwq->ibwq.event_handler =3D ...
    return &rwq->ibwq;
                                  mlx5_ib_wq_event()
                                    dev =3D to_dev(rwq->ibwq.device);
                                    ib_uverbs_wq_event_handler()
                                      wq->uobject->uevent  <-- NULL deref
  wq->device =3D pd->device;
  wq->uobject =3D obj;

If an event fires in this window, rwq->ibwq.device is still NULL (crashing
in mlx5_ib_warn() on unexpected events) and ib_uverbs_wq_event_handler()
dereferences a NULL wq->uobject.

[1] https://sashiko.dev/#/bug/linux-f9cb6026-426e-45f3-b251-f749672898fb
[2] https://sashiko.dev/#/bug/linux-63691fc3-b762-467d-89ea-1bf281490cc3

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117-mlx5-sd-pr=
ep-v1-0-8efd124c7895@nvidia.com?part=3D2
