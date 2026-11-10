Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794290143;
	b=kuc6Y79NMTsanwTMB9sN+qYJVifQ1XxfUp4XvlviHQW/yg8ZCD9KkpI0tZ7DKptva1iE
	 Tg0/zafKQt3M1bSemDaY21LbkHxY1zIZYBKfj37kctLPv65N3mVjhkvEmAyMZlXv+SVOy
	 Q/Y5MJA1KTG7bSw3y2F2ZwsrTRMSylJX2tkOYkXuTj81aiv8pEVkLJxoF0gD0jBQ/a01l
	 rQqvN2LvMDd9UJqMtSOnKXYRqaN/aC/F0/5lODpFIeokEYEdALTzJnThqMYPNGn2jrPi2
	 wdQZsKZYyUHTIyjfQ2m+VdDQkFNMZ6YZ7I9WiLjpejGP1JaGbgrsFoMTvQkWMqTw48w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794290143;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=VOd2RT9pHQLlb2rkHy6m81a6J6LWNy+oN6yyQeo2DNc=;
	b=VG3gPS1rWuUMk8Dd40i6PtnL3i5r6lQ9y7/C0aYqqKIiPb6tsFrwlA5h8fKLD/xG54U3
	 FDq3j/e5fua7SAjd5yUvjKM0d2TAZf6JFSanUXccTANESlafhq2duGt2wAE6ze5ZLhlx9
	 jyiP7IKFjVJWDG44G4gUxL/Phs0bxA03MZU4+70NUSivbBOwEzd4zFTiFehtC+v/XfQb0
	 dzR+ZtcA93dRlk837JYHLK1fPIdJ3/SY+tJHvGDtM5s1kO0+ASiYLKCLR1N8NCIM4ZJqX
	 0Gwqk0bDI2V8Vf5k9ZxiVAEYT76+v48KSdh74eZNR7EOkzCEdXQVvCPhVGGSfzArnaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y5AmIVbc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97417606A321
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 05:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y5AmIVbc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 231D41F0089F;
	Tue, 10 Nov 2026 05:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794290143;
	bh=VOd2RT9pHQLlb2rkHy6m81a6J6LWNy+oN6yyQeo2DNc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Y5AmIVbcGLSHC47j8xTlmluByftsFRBqnK1ivERtD4O/biqlWG+ju94nMavsdcY3x
	 FptVNxRhRQLRMA9nTn/P7MLvVUsRrHzmc715MysTg9amUYzq1v/uaOnvcKf9UbHqsw
	 D70o94VLgCtPJxdfQSe8GGeGpXtfrqflyQFLkkU9VlwBBH+uc9SM65aC8m0pISXJFQ
	 0dYoM9URrsfwuW+0qQqm2BKoKAGHn4rhvwm6WPHE3ke4CSXUl/X/EM4JzjpoeEXJ+E
	 Wc5IsyMJN5GBRw6CMoPVyVYWADiO9KY+Tw31meQE/YqsAT25If369AeZpfjmst6Pyf
	 3Fyw1Mk8Jr4jw==
Message-ID: <sashiko-outbox-206354@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v3 11/13] RDMA/core: extended memory
 registration
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Davis" <eric.davis@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261109-uet-ib-core-v3-11-3e7e7ffed2e9@broadcom.com>
References: <20261109-uet-ib-core-v3-0-3e7e7ffed2e9@broadcom.com>
 <20261109-uet-ib-core-v3-11-3e7e7ffed2e9@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 05:55:42 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] RDMA/core: incomplete MR field initialization in
  ib_mr_init_core_refs()
--

commit 4855334c45cbf4ca7471642a328bba73a433c013
Author: Eric Davis <eric.davis@broadcom.com>

RDMA/core: extended memory registration

This commit adds the reg_user_mr_ex device operation and extended UVERBS_ME=
THOD_REG_MR ioctl attributes to support registering memory regions bound to=
 a job, derived from a parent MR, or using caller-chosen 64-bit keys.

> diff --git a/drivers/infiniband/core/uverbs_std_types_mr.c b/drivers/infi=
niband/core/uverbs_std_types_mr.c
> index 0c72f801e0d32..8d281d13d2105 100644
> --- a/drivers/infiniband/core/uverbs_std_types_mr.c
> +++ b/drivers/infiniband/core/uverbs_std_types_mr.c
[ ... ]
> @@ -373,12 +521,26 @@ static int UVERBS_HANDLER(UVERBS_METHOD_REG_MR)(
>  	mr->device =3D pd->device;
>  	mr->pd =3D pd;
>  	mr->type =3D IB_MR_TYPE_USER;
> +	mr->iova =3D iova;
> +	mr->length =3D length;
> +	ib_mr_init_core_refs(mr);
>  	mr->uobject =3D uobj;
>  	atomic_inc(&pd->usecnt);
>  	if (dmah) {
>  		mr->dmah =3D dmah;
>  		atomic_inc(&dmah->usecnt);
>  	}
[ ... ]
> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/ve=
rbs.c
> index 9359318141b79..a80d750777f43 100644
> --- a/drivers/infiniband/core/verbs.c
> +++ b/drivers/infiniband/core/verbs.c
> @@ -2405,6 +2406,8 @@ int ib_dereg_mr_user(struct ib_mr *mr, struct ib_ud=
ata *udata)
>  	struct ib_pd *pd =3D mr->pd;
>  	struct ib_dm *dm =3D mr->dm;
>  	struct ib_dmah *dmah =3D mr->dmah;
> +	struct ib_jkey *jkey =3D mr->jkey;
> +	struct ib_mr *parent =3D mr->parent;
>  	struct ib_sig_attrs *sig_attrs =3D mr->sig_attrs;
>  	int ret;
> =20
> @@ -2417,6 +2420,10 @@ int ib_dereg_mr_user(struct ib_mr *mr, struct ib_u=
data *udata)
>  			atomic_dec(&dm->usecnt);
>  		if (dmah)
>  			atomic_dec(&dmah->usecnt);
> +		if (jkey)
> +			atomic_dec(&jkey->usecnt);
> +		if (parent)
> +			atomic_dec(&parent->usecnt);
>  		kfree(sig_attrs);
>  	}
[ ... ]
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 8be766b80ce08..07fd5731d4587 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
[ ... ]
> @@ -4818,6 +4850,20 @@ static inline u32 ib_inc_rkey(u32 rkey)
>  	return ((rkey + 1) & mask) | (rkey & ~mask);
>  }
> =20
> +/**
> + * ib_mr_init_core_refs - clears what core reads back when an MR is
> + *   deregistered.
> + * @mr: struct ib_mr pointer to initialize.
> + *
> + * A driver's MR need not be zeroed, so every path that makes an MR call=
s this.
> + */
> +static inline void ib_mr_init_core_refs(struct ib_mr *mr)
> +{
> +	mr->jkey =3D NULL;
> +	mr->parent =3D NULL;
> +	atomic_set(&mr->usecnt, 0);
> +}

[Severity: Medium]
Does ib_mr_init_core_refs() leave mr->dm, mr->dmah, and mr->sig_attrs
uninitialized when a driver returns a non-zeroed struct ib_mr?

The comment states that a driver's MR need not be zeroed and that
ib_mr_init_core_refs() clears what the core reads back on deregistration.
However, ib_dereg_mr_user() also reads mr->dm, mr->dmah, and mr->sig_attrs,
while UVERBS_HANDLER(UVERBS_METHOD_REG_MR),
UVERBS_HANDLER(UVERBS_METHOD_REG_DMABUF_MR), and ib_uverbs_rereg_mr() do not
clear them (and UVERBS_METHOD_REG_MR only sets mr->dmah when dmah is
non-NULL).  If a driver implementing reg_user_mr_ex or reg_user_mr does not
zero-initialize struct ib_mr, deregistering the MR will pass uninitialized
pointers to atomic_dec(&dm->usecnt), atomic_dec(&dmah->usecnt), and
kfree(sig_attrs), corrupting memory or crashing.

If ib_mr_init_core_refs() is updated to also clear mr->dm, mr->dmah, and
mr->sig_attrs, note that UVERBS_HANDLER(UVERBS_METHOD_DM_MR_REG) and
ib_alloc_mr_integrity() must call it before assigning mr->dm and
mr->sig_attrs.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109-uet-ib-cor=
e-v3-0-3e7e7ffed2e9@broadcom.com?part=3D11
