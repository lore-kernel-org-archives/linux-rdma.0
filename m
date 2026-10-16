Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD87E310779
	for <linux-rdma@vger.kernel.org>; Fri, 16 Oct 2026 20:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792183491; cv=none; b=Q/cv1Fu/ZE8x3C+3TJyKIVag94ZnGTqTQB7kkGzkJ/D5S0B3Fz1dkj0g98pkn19g0nwIzzDrpfOplb+U8JXpai1R86f3QfNoQgwRYsIullBKKvPpar4dZtZDIzS1l1fNC9Krj6qxABa6l/J9JUyWsSe+x6Vf4NS3QcPYRKDm/nY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792183491; c=relaxed/simple;
	bh=pryuswcJbUSyNcmUXAO70h7KiOtZKCy+3mgHn8s50kY=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=KNty5yK73u4IFRMb4RIv4CIPEHjUXo0rniY9oINvKFSbcS+Gu5+osLYOoEnNK9uq6s0k1q2BhKD8ChfXJtvFx1htMvBW1F8PKeG+C9ybbAHcrsEZYxniHPBa1tE73g8hsaaII2geT/FJPBiKxc98Gi1Rcs3O7CB0hPa1YUccY/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GSmcvgeW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GSmcvgeW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F80D1F000C4;
	Fri, 16 Oct 2026 20:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792183490;
	bh=a3jOpEzTfyr2l1s0QXl3myrihcMIPb8XbIVEbuoRv48=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GSmcvgeWvcYIJfBuzL4Od2My7VcrMMEX50JWC6Epfm6NbDBZx94hMB7KfLRiHDlxc
	 WDyexbI3Uz1G7XQOpBbfhK/tq5g41J801nV2kb6wpdz5g06ofBrGhY/k94iQHZfhD1
	 m+V0s2Q3HXw2daz1A9LQ3fOxbjD21LxkFavw9CrKhpChISlFvOZxBRKTl3LJV5pGRq
	 5OnNm/40CDNMTKwgWIb7L/qAwXN9iK8MPFpjI/3FbJeRo/tR9DVnpZqTLtKqaFPe/a
	 6FPDWaQKlOUICHFGVJ9SwOTqT0BYEoXTB88MHAKx21Pm/pqHXOeoG6ZqV8GVDlOHiZ
	 aiUmUoLvqim2g==
Message-ID: <sashiko-outbox-174921@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v3 4/6] RDMA/irdma: Split CQ setup to umode
 and kmode
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Hu" <dhu@x6u.co>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261016202909.1289496-5-dhu@x6u.co>
References: <20261016202909.1289496-1-dhu@x6u.co>
 <20261016202909.1289496-5-dhu@x6u.co>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 16 Oct 2026 20:44:49 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] RDMA/irdma: wrong CQ ID freed in irdma_cq_free_rsrc() on create er=
ror
--

commit eb0afaa9db2faa3b9d9fcbdc4f3146cc0d4e7d19
Author: David Hu <xuehaohu@google.com>

RDMA/irdma: Split CQ setup to umode and kmode

This commit separates user-mode and kernel-mode CQ creation by adding the
irdma_create_user_cq() callback and refactoring common setup logic into
shared helper functions.

> diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/=
irdma/verbs.c
> index ab25445f38282..4b7e9c2d9cff5 100644
> --- a/drivers/infiniband/hw/irdma/verbs.c
> +++ b/drivers/infiniband/hw/irdma/verbs.c
> @@ -2624,41 +2624,198 @@ static inline int cq_validate_flags(u32 flags, u=
8 hw_rev)
>  	return flags & ~IB_UVERBS_CQ_FLAGS_TIMESTAMP_COMPLETION ? -EOPNOTSUPP :=
 0;
>  }
> =20
> -/**
> - * irdma_create_cq - create cq
> - * @ibcq: CQ allocated
> - * @attr: attributes for cq
> - * @attrs: uverbs attribute bundle
> - */
> -static int irdma_create_cq(struct ib_cq *ibcq,
> -			   const struct ib_cq_init_attr *attr,
> -			   struct uverbs_attr_bundle *attrs)
> +static int __irdma_create_cq(struct irdma_device *iwdev,
> +			     struct irdma_cq *iwcq,
> +			     struct irdma_cq_init_info *info,
> +			     struct ib_udata *udata)
>  {
[ ... ]
> +	info->shadow_read_threshold =3D min(info->cq_uk_init_info.cq_size / 2,
> +					  (u32)IRDMA_MAX_CQ_READ_THRESH);
> +
> +	if (irdma_sc_cq_init(cq, info)) {
> +		ibdev_dbg(&iwdev->ibdev, "VERBS: init cq fail\n");
> +		err_code =3D -EPROTO;
> +		goto cq_free_rsrc;
> +	}

[ ... ]

> @@ -2674,169 +2831,99 @@ static int irdma_create_cq(struct ib_cq *ibcq,
>  	iwcq->cq_num =3D cq_num;
>  	iwcq->iwpbl =3D NULL;
>  	iwcq->iwpbl_shadow =3D NULL;
> -	info.dev =3D dev;
> +	info->dev =3D dev;
>  	ukinfo->cq_size =3D max(entries, 4);
>  	ukinfo->cq_id =3D cq_num;
[ ... ]
> +static int irdma_create_user_cq(struct ib_cq *ibcq,
> +				const struct ib_cq_init_attr *attr,
> +				struct uverbs_attr_bundle *attrs)
> +{
[ ... ]
> +	err_code =3D irdma_alloc_cq(iwdev, iwcq, attr, &info);
> +	if (err_code)
> +		return err_code;
> =20
> -		if (entries * cqe_size =3D=3D IRDMA_HW_PAGE_SIZE)
> -			entries +=3D 2;
> +	err_code =3D irdma_setup_umode_cq(iwdev, iwcq, &info, attrs);
> +	if (err_code)
> +		goto cq_free_rsrc;
> =20
> -		ukinfo->cq_size =3D entries;
> +	return __irdma_create_cq(iwdev, iwcq, &info, udata);
> +cq_free_rsrc:
> +	irdma_cq_free_rsrc(rf, iwcq);
> =20
> +	return err_code;
> +}
> =20
> +/**
> + * irdma_create_cq - create kmode cq
> + * @ibcq: CQ allocated
> + * @attr: attributes for cq
> + * @attrs: uverbs attribute bundle
> + */
> +static int irdma_create_cq(struct ib_cq *ibcq,
> +			   const struct ib_cq_init_attr *attr,
> +			   struct uverbs_attr_bundle *attrs)
> +{
[ ... ]
> +	err_code =3D irdma_alloc_cq(iwdev, iwcq, attr, &info);
> +	if (err_code)
> +		return err_code;
> =20
> +	err_code =3D irdma_setup_kmode_cq(iwdev, iwcq, &info, attr);
>  	if (err_code)
>  		goto cq_free_rsrc;
> =20
> +	return __irdma_create_cq(iwdev, iwcq, &info, NULL);
>  cq_free_rsrc:
>  	irdma_cq_free_rsrc(rf, iwcq);

[Severity: High]
This problem wasn't introduced by this patch, but if irdma_setup_umode_cq()
in irdma_create_user_cq(), irdma_setup_kmode_cq() in irdma_create_cq(), or
the early PBLE bounds check in irdma_sc_cq_init() fails, does
irdma_cq_free_rsrc() free the wrong CQ ID from rf->allocated_cqs?

In irdma_alloc_cq(), the allocated cq_num is saved in iwcq->cq_num and
ukinfo->cq_id:

	iwcq->cq_num =3D cq_num;
	...
	ukinfo->cq_id =3D cq_num;

However, cq->cq_uk.cq_id is only populated later inside __irdma_create_cq()
when irdma_sc_cq_init() calls irdma_uk_cq_init(&cq->cq_uk,
&info->cq_uk_init_info).

Before that happens, cq->cq_uk.cq_id is still 0, while irdma_cq_free_rsrc()
frees cq->cq_uk.cq_id:

drivers/infiniband/hw/irdma/verbs.c:irdma_cq_free_rsrc() {
	...
	irdma_free_rsrc(rf, rf->allocated_cqs, cq->cq_uk.cq_id);
}

When one of these pre-init error paths jumps to cq_free_rsrc, wouldn't this
leak iwcq->cq_num and clear reserved bit 0 (IRDMA_RSVD_CQ_ID_CQP) in
rf->allocated_cqs instead?

[ ... ]

>
> --=20
> 2.51.2
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261016202909.1289=
496-1-dhu@x6u.co?part=3D4
