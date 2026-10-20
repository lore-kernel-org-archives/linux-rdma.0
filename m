Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792485620;
	b=Cgm0sikjXeQFnL4v2UxG47q4YBgn6HDnU/m4RgORZL5RtQTGZQfCXvhvzj87gn3UcnHf
	 mMgLiN6CLuQ/PmscvR+0ntSALfbvNexqGA59zDSXDDNPEuhgP+ixvHbCPxG8qSsgCr35Y
	 wnurFgm5vH3aQOCE/3UpkZnTAC8jwtEF3uuMQJ9LH72KOeByNT98Cbvz5e7wUmJj45DLa
	 5M53fXVx9Q0HbXPLHJ1HEdwbtFG4M2MpCRdGOG7P3l6HebDrzNoTAalNMjcXj+CuX4y1T
	 aYFTtRI/G5Jhy239ApwYag1saxgXB28BMN/B6xtpD7PR55ATw3Lf6+YvHziFq4fc15A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792485620;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=CpIZJnvP7ENdbJWxed2W9M8IKGhynm1YU1mcX8s7RGY=;
	b=qlMIcSZ0Wt/5Y+o4FURDnt4MyF6Yb9r0pPpx6oxAD66q1QU5DYuLSVQvWUApc2f9F9+/
	 3Y9pupVzj6Sx0qShzeL610PT5XaBtTq+y8B7GKRf76yYYH0MJ7LDFVJ5Ip/1NsYC3h+c2
	 ZDHDqK13k2KCvTNFDAnRf/DDf2CYJDnUr9+JpNdYOqTYn7qmZevFIg8ESzl8R7pWp4T/s
	 DS5nU6S0LMNBdLpRWDR79Ci3EZZGReE3yZF3d3UjvBoAIr3jWbAjSsFSFVLfHeR6eSoK5
	 zsLDhvvkJxSayeZYicNaNQdK9jLIl/+8AtF8v/zlSbRA6dHs9TJjhh3p3zZMXrAwTGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZYOx3xQM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E27606A31B
	for <linux-rdma@vger.kernel.org>; Tue, 20 Oct 2026 08:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZYOx3xQM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 438B91F000C4;
	Tue, 20 Oct 2026 08:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792485619;
	bh=CpIZJnvP7ENdbJWxed2W9M8IKGhynm1YU1mcX8s7RGY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZYOx3xQMj+4TqOr63Q6HJ1Y99mCpg/DUETjvTPT6xPNPAPYG70OgyA+b7SqMYTK5r
	 7B9re2qoxZG2ii0WBxUK2wVJRNZ+joihnMsPPLsTe7/Lm9+4u9gWbMotv80d9JQXEz
	 LPGqAzz8cSsvm2cvlRg9qyTcsQDg5+JZc9pblEyduIw+ZSW+MznodOk4zP/B4DQKuR
	 xcYOI6VIZRzW4xfD91qG6fIthj5Q+pmkvwe9wGUzf+gA4eCuYOG1OY8G608khdu3JN
	 EpaZnPsbYrP0rdrJe+LepTJdIMdtglSqYEJ+4tKLBsjT0fnQxwmg4U8oREo2BzKIzO
	 LWvkAgYpuKllg==
Message-ID: <sashiko-outbox-178596@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2 05/13] RDMA/core: extended address handle
 attributes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Davis" <eric.davis@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261019-uet-ib-core-v2-5-8bd654f25370@broadcom.com>
References: <20261019-uet-ib-core-v2-0-8bd654f25370@broadcom.com>
 <20261019-uet-ib-core-v2-5-8bd654f25370@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 20 Oct 2026 08:40:18 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] RDMA/uverbs: missing uverbs_finalize_uobj_create() in AH_EX_CREATE=
 handler
--

commit 4cd859f734837412850e0706a926ea891c66f8a6
Author: Eric Davis <eric.davis@broadcom.com>

RDMA/core: extended address handle attributes

This commit introduces struct rdma_ah_attr_ex to carry extended address
handle attributes such as remote_qpn for UET transports, updates
rdma_create_user_ah() to accept struct rdma_ah_init_attr, and adds the
UVERBS_METHOD_AH_EX_CREATE ioctl method.

> diff --git a/drivers/infiniband/core/uverbs_std_types.c b/drivers/infinib=
and/core/uverbs_std_types.c
> index e160786e1df16..27cc1d1622939 100644
> --- a/drivers/infiniband/core/uverbs_std_types.c
> +++ b/drivers/infiniband/core/uverbs_std_types.c
> @@ -184,6 +184,73 @@ DECLARE_UVERBS_NAMED_OBJECT(UVERBS_OBJECT_MW,
>  			    UVERBS_TYPE_ALLOC_IDR(uverbs_free_mw),
>  			    &UVERBS_METHOD(UVERBS_METHOD_MW_DESTROY));
> =20
> +/* Creating an address handle is still a write() command whose request
> + * struct cannot grow. A transport (reliable unconnected) that resolves a
> + * peer using both transport and network addresses requires additional
> + * fields in the address handle. Here the address handle create command =
is
> + * made available as an ioctl method, where additional attributes can be
> + * carried.
> + */
> +static int UVERBS_HANDLER(UVERBS_METHOD_AH_EX_CREATE)(
> +	struct uverbs_attr_bundle *attrs)
> +{
[ ... ]
> +	ah =3D rdma_create_user_ah(pd, &init_attr, &attrs->driver_udata);
> +	if (IS_ERR(ah))
> +		return PTR_ERR(ah);
> +
> +	ah->uobject =3D uobj;
> +	uobj->object =3D ah;
> +
> +	return 0;
> +}

[Severity: High]
Should UVERBS_HANDLER(UVERBS_METHOD_AH_EX_CREATE) call
uverbs_finalize_uobj_create(attrs, UVERBS_ATTR_CREATE_AH_EX_HANDLE) before
returning 0?

Because UVERBS_METHOD_AH_EX_CREATE includes UVERBS_ATTR_UHW(),
ib_uverbs_run_method() can call uverbs_set_output() for UVERBS_ATTR_UHW_OUT
after the handler succeeds:

drivers/infiniband/core/uverbs_ioctl.c:ib_uverbs_run_method() {
	ret =3D handler(bundle);
	if (ret)
		return ret;

	if (!ret && bundle->method_elm->has_udata) {
		const struct uverbs_attr *attr =3D
			uverbs_attr_get(bundle, UVERBS_ATTR_UHW_OUT);

		if (!IS_ERR(attr))
			ret =3D uverbs_set_output(bundle, attr);
	}
}

If uverbs_set_output() fails with -EFAULT, ib_uverbs_cmd_verbs() aborts the
command via bundle_destroy(pbundle, false) -> uverbs_finalize_object() ->
rdma_alloc_abort_uobject():

drivers/infiniband/core/rdma_core.c:rdma_alloc_abort_uobject() {
	if (hw_obj_valid) {
		uverbs_get_cleared_udata(attrs);
		ret =3D uobj->uapi_object->type_class->destroy_hw(
			uobj, RDMA_REMOVE_ABORT, attrs);
		...
	}
}

Without uverbs_finalize_uobj_create() setting the bit in
pbundle->uobj_hw_obj_valid, hw_obj_valid is false on abort, so destroy_hw
(uverbs_free_ah() -> rdma_destroy_ah_user()) is skipped. Does this leak the
newly created struct ib_ah, its ah->sgid_attr reference, and its pd->usecnt
reference?

[ ... ]

> +DECLARE_UVERBS_NAMED_METHOD(
> +	UVERBS_METHOD_AH_EX_CREATE,
> +	UVERBS_ATTR_IDR(UVERBS_ATTR_CREATE_AH_EX_HANDLE,
> +			UVERBS_OBJECT_AH,
> +			UVERBS_ACCESS_NEW,
> +			UA_MANDATORY),
> +	UVERBS_ATTR_IDR(UVERBS_ATTR_CREATE_AH_EX_PD_HANDLE,
> +			UVERBS_OBJECT_PD,
> +			UVERBS_ACCESS_READ,
> +			UA_MANDATORY),
> +	UVERBS_ATTR_PTR_IN(UVERBS_ATTR_CREATE_AH_EX_AH_ATTR_EX,
> +			   UVERBS_ATTR_STRUCT(struct ib_uverbs_ah_attr_ex,
> +					      remote_qpn),
> +			   UA_MANDATORY),
> +	UVERBS_ATTR_UHW());

[ ... ]

> --=20
> 2.51.2
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019-uet-ib-cor=
e-v2-0-8bd654f25370@broadcom.com?part=3D5
