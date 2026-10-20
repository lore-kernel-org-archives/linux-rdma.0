Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792490037;
	b=YKk8Q10H8yHOAm/Jr7LL+p1ni00jZo9ULBnb2cz4pZCrZ2SyWjYSBcLjVhxPNnzQ0Gt8
	 FN7ndSuqdtklI7JMqTq25MVD7e6KwO80LKL7edCWHnoqiVTTMYQHLR+aCm33QSac7FP5+
	 OzeMnGafNYR0gKA50Z6saxg+a8WsM3Oxg/YtbPHRDJjlhJymfkt8H5qvoNvlYJ/LwBwHY
	 WmU2N50vbgh/QZ4Y0Qx5W6vQLwMiXnzhG6e87X408wffI+Vpn8ZmM6VbUYtb+cqj3cq2L
	 AsRUBxH6Ya6hhuBSu9XBg1X1tz5G2K/35Zxh+9pYpua86m96dRYiPKwNda39mRgeqrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792490037;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=UF0Um5PgNn3CgeJn3hU7nQXkLat8knpTE8PG2BrYANM=;
	b=3D3cWcIUuCsixVFbgLNyjanC6hqXajivHolBp6PGFq8s4eIhzBPx5t5785TgCzcLTjwO
	 GEY6vA9UquThJqSCUEq0vVT3QuLn8Wol8Mz8P2i20vx1040/EhpdsqAblkwfeO3jrOySO
	 Ur1IWrPiPqQdZklk14XJ/C6R0evq7gb7zru7c8g0ygdAithvaT6cI220mX/0ynThOZ+uw
	 iVfDut2sTX0YgZqXHOIrrJmUHooBgsmblH/3SU4fIpjuwF4l8hBzZQrVmKu1W8U9vBMUB
	 AUTNrSi9BUZk7MFyngUQ/8PzT3XBSkTd0yELrXanes2jz1d0VC3YDtRt5QNJccRRybA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J39a0U0K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA805606A31B
	for <linux-rdma@vger.kernel.org>; Tue, 20 Oct 2026 09:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J39a0U0K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CAAA1F000C4;
	Tue, 20 Oct 2026 09:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792490036;
	bh=UF0Um5PgNn3CgeJn3hU7nQXkLat8knpTE8PG2BrYANM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=J39a0U0KRaLNaEwt7pm9efougydnX59BxA91s3QIaiFqf2uksnTyDZz5/LFiQm1gx
	 W3z02nJUKtOi/KPXRXpTiz2BgeMMFKUYQS/gT4tno2mprX2A5EUQX/LEy52TR7oQZZ
	 SpxWuLkbR7133/VB55xdyBZ6V4aTIJfQ/DcmeOioM4IGUk9DnIDEZsFwmsvi8ZPO0e
	 QiJxZXTUzcuVGUOOQi2qsygBBaIhYVnN61RTnk8kZMwKaYSkU82E3enRikDfxX9hdB
	 ovxqLPWShU3hopet43CtRtkX63AMYT//ye04fVqWpWBvHctCW4mSvztd13hozjeXsM
	 O53TrD65ynLOg==
Message-ID: <sashiko-outbox-178770@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2 10/13] RDMA/core: queue pair attributes for
 unconnected transports
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Davis" <eric.davis@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261019-uet-ib-core-v2-10-8bd654f25370@broadcom.com>
References: <20261019-uet-ib-core-v2-0-8bd654f25370@broadcom.com>
 <20261019-uet-ib-core-v2-10-8bd654f25370@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 20 Oct 2026 09:53:55 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] RDMA/core: unmasked semantics fields used and copied in create_q=
p_opt_attrs()
- [Medium] RDMA/core: missing IB_DEVICE_RU check for IB_QPT_RU in create_qp=
_opt_attrs()
--

commit 814ed695a9e745ffe7fb729da61fd57b0d746109
Author: Eric Davis <eric.davis@broadcom.com>

RDMA/core: queue pair attributes for unconnected transports

This commit adds support for reliable unconnected (IB_QPT_RU) queue pair
creation attributes in uverbs and ib_verbs, including source ID, job key
(jkey), and ordering/usage semantics. It also tracks the jkey use count
over the lifetime of the QP.

> diff --git a/drivers/infiniband/core/uverbs_std_types_qp.c b/drivers/infi=
niband/core/uverbs_std_types_qp.c
> index c6225156fe30e..47ca994f9ac96 100644
> --- a/drivers/infiniband/core/uverbs_std_types_qp.c
> +++ b/drivers/infiniband/core/uverbs_std_types_qp.c
> @@ -79,6 +79,139 @@ static void set_caps(struct ib_qp_init_attr *attr,
>  	}
>  }
> =20
> +/* the semantics fields, ordering bits and usage flags uverbs knows of */
> +#define QP_SEMANTICS_MASK_ALL	((IB_UVERBS_QP_SEMANTICS_MASK_USAGE << 1) =
- 1)
> +#define QP_ORDER_ALL		((IB_UVERBS_QP_ORDER_WAW << 1) - 1)
> +#define QP_USAGE_ALL		IB_UVERBS_QP_USAGE_IMM_DATA_RQ
> +
> +/* A QP may relax what its type guarantees on this device, but not ask f=
or
> + * more than the device advertises for it.
> + */
> +static int create_qp_semantics_check(struct ib_device *device,
> +				     const struct ib_qp_semantics *req)
> +{
> +	struct ib_qp_semantics adv =3D {};
> +	u32 m =3D req->comp_mask;
> +	int ret;
> +
> +	if (!device->ops.query_qp_semantics)
> +		return -EOPNOTSUPP;
> +
> +	ret =3D device->ops.query_qp_semantics(device, IB_QPT_RU, &adv);
> +	if (ret)
> +		return ret;
> +
> +	if (m & ~adv.comp_mask)
> +		return -EINVAL;
> +
> +	if (((m & IB_UVERBS_QP_SEMANTICS_MASK_MSG_ORDER) &&
> +	     (req->msg_order & ~adv.msg_order)) ||
> +	    ((m & IB_UVERBS_QP_SEMANTICS_MASK_RAW) &&
> +	     req->max_rdma_raw_size > adv.max_rdma_raw_size) ||
> +	    ((m & IB_UVERBS_QP_SEMANTICS_MASK_WAR) &&
> +	     req->max_rdma_war_size > adv.max_rdma_war_size) ||
> +	    ((m & IB_UVERBS_QP_SEMANTICS_MASK_WAW) &&
> +	     req->max_rdma_waw_size > adv.max_rdma_waw_size) ||
> +	    ((m & IB_UVERBS_QP_SEMANTICS_MASK_PDU) &&
> +	     req->max_pdu > adv.max_pdu) ||
> +	    ((m & IB_UVERBS_QP_SEMANTICS_MASK_IMM) &&
> +	     req->imm_data_size > adv.imm_data_size) ||
> +	    ((m & IB_UVERBS_QP_SEMANTICS_MASK_USAGE) &&
> +	     (req->usage_flags & ~adv.usage_flags)))
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +/* Process the optional creation attributes. A job to act within, a sour=
ce
> + * identity, a set of ordering guarantees to ask for. They and the check=
s on
> + * a requested QP number belong to a reliable unconnected QP.
> + */
> +static int create_qp_opt_attrs(struct uverbs_attr_bundle *attrs,
> +			       struct ib_device *device, struct ib_pd *pd,
> +			       struct ib_qp_init_attr *attr,
> +			       struct ib_qp_semantics *sem)
> +{
> +	struct ib_uverbs_qp_semantics usem =3D {};
> +	struct ib_jkey *jkey;
> +	bool has_semantics;
> +	int ret;
> +
> +	has_semantics =3D uverbs_attr_is_valid(attrs,
> +					     UVERBS_ATTR_CREATE_QP_SEMANTICS);
> +
> +	if (attr->qp_type !=3D IB_QPT_RU ||
> +	    !(device->attrs.device_cap_flags & IB_DEVICE_RU)) {
> +		if (has_semantics ||
> +		    uverbs_attr_is_valid(attrs, UVERBS_ATTR_CREATE_QP_SRC_ID) ||
> +		    uverbs_attr_is_valid(attrs, UVERBS_ATTR_CREATE_QP_JOB_KEY))
> +			return -EOPNOTSUPP;
> +
> +		return 0;
> +	}

[Severity: Medium]
What happens in UVERBS_HANDLER(UVERBS_METHOD_QP_CREATE) ->
create_qp_opt_attrs() when userspace requests attr.qp_type =3D=3D IB_QPT_RU=
 on
a device that does not advertise IB_DEVICE_RU, and omits the optional
UVERBS_ATTR_CREATE_QP_SEMANTICS, UVERBS_ATTR_CREATE_QP_SRC_ID, and
UVERBS_ATTR_CREATE_QP_JOB_KEY attributes?

Because UVERBS_HANDLER(UVERBS_METHOD_QP_CREATE) adds IB_UVERBS_QPT_RU to
the switch statement without checking IB_DEVICE_RU, and this check combines
attr->qp_type !=3D IB_QPT_RU with !(device->attrs.device_cap_flags &
IB_DEVICE_RU), create_qp_opt_attrs() returns 0 instead of -EOPNOTSUPP.

Returning 0 early here also skips the IB_QP_CREATE_SOURCE_QPN validation
below (checking attr->source_qpn against IB_UVERBS_QPN_UET_RESERVED_MASK
and requiring attr->jkey for relative QPNs) and allows QP creation to
proceed to ib_create_qp_user() on a device without IB_DEVICE_RU.

Should create_qp_opt_attrs() return -EOPNOTSUPP whenever attr->qp_type =3D=
=3D
IB_QPT_RU and !(device->attrs.device_cap_flags & IB_DEVICE_RU)?

> +
> +	if (uverbs_attr_is_valid(attrs, UVERBS_ATTR_CREATE_QP_SRC_ID)) {
> +		ret =3D uverbs_copy_from(&attr->src_id, attrs,
> +				       UVERBS_ATTR_CREATE_QP_SRC_ID);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	if (uverbs_attr_is_valid(attrs, UVERBS_ATTR_CREATE_QP_JOB_KEY)) {
> +		jkey =3D uverbs_attr_get_obj(attrs,
> +					   UVERBS_ATTR_CREATE_QP_JOB_KEY);
> +		if (IS_ERR(jkey))
> +			return PTR_ERR(jkey);
> +
> +		/* a key acts within the PD it was made on */
> +		if (jkey->pd !=3D pd)
> +			return -EINVAL;
> +
> +		attr->jkey =3D jkey;
> +	}
> +
> +	if (attr->create_flags & IB_QP_CREATE_SOURCE_QPN) {
> +		if (attr->source_qpn & IB_UVERBS_QPN_UET_RESERVED_MASK)
> +			return -EINVAL;
> +
> +		/* a relative QP is named within a job, so it needs a key */
> +		if (!(attr->source_qpn &
> +		      IB_UVERBS_QPN_UET_ABSOLUTE_ADDR_BIT) &&
> +		    !attr->jkey)
> +			return -EINVAL;
> +	}
> +
> +	if (has_semantics) {
> +		ret =3D uverbs_copy_from_or_zero(&usem, attrs,
> +					       UVERBS_ATTR_CREATE_QP_SEMANTICS);
> +		if (ret)
> +			return ret;
> +
> +		if ((usem.comp_mask & ~QP_SEMANTICS_MASK_ALL) ||
> +		    (usem.msg_order & ~QP_ORDER_ALL) ||
> +		    (usem.usage_flags & ~QP_USAGE_ALL) ||
> +		    memchr_inv(usem.reserved, 0, sizeof(usem.reserved)))
> +			return -EINVAL;
> +
> +		sem->comp_mask =3D usem.comp_mask;
> +		sem->msg_order =3D usem.msg_order;
> +		sem->max_rdma_raw_size =3D usem.max_rdma_raw_size;
> +		sem->max_rdma_war_size =3D usem.max_rdma_war_size;
> +		sem->max_rdma_waw_size =3D usem.max_rdma_waw_size;
> +		sem->max_pdu =3D usem.max_pdu;
> +		sem->usage_flags =3D usem.usage_flags;
> +		sem->imm_data_size =3D usem.imm_data_size;
> +
> +		ret =3D create_qp_semantics_check(device, sem);
> +		if (ret)
> +			return ret;
> +
> +		attr->qp_semantics =3D sem;
> +	}

[Severity: Medium]
Should the checks and assignments on the fields of usem in
create_qp_opt_attrs() be gated by their corresponding bits in
usem.comp_mask?

When UVERBS_ATTR_CREATE_QP_SEMANTICS is provided, individual fields in
struct ib_uverbs_qp_semantics are gated by IB_UVERBS_QP_SEMANTICS_MASK_*
bits in usem.comp_mask.

However, create_qp_opt_attrs() checks (usem.msg_order & ~QP_ORDER_ALL) and
(usem.usage_flags & ~QP_USAGE_ALL) unconditionally even when
IB_UVERBS_QP_SEMANTICS_MASK_MSG_ORDER or IB_UVERBS_QP_SEMANTICS_MASK_USAGE
is not set in usem.comp_mask, which can reject valid requests with -EINVAL
if unused fields in the user structure were not zeroed.

In addition, create_qp_opt_attrs() copies all fields from usem into sem
regardless of usem.comp_mask, whereas create_qp_semantics_check() only
validates the fields in sem whose bits are set in req->comp_mask. As a
result, any field whose bit is clear in usem.comp_mask bypasses
create_qp_semantics_check() and is passed with unvalidated user values in
attr->qp_semantics to dev->ops.create_qp().

[ ... ]

> @@ -197,6 +331,7 @@ static int UVERBS_HANDLER(UVERBS_METHOD_QP_CREATE)(
>  	case IB_UVERBS_QPT_UC:
>  	case IB_UVERBS_QPT_UD:
>  	case IB_UVERBS_QPT_XRC_INI:
> +	case IB_UVERBS_QPT_RU:
>  	case IB_UVERBS_QPT_DRIVER:
>  		if (uverbs_attr_is_valid(attrs,
>  					 UVERBS_ATTR_CREATE_QP_XRCD_HANDLE) ||
> @@ -271,6 +406,10 @@ static int UVERBS_HANDLER(UVERBS_METHOD_QP_CREATE)(
>  		attr.create_flags |=3D IB_QP_CREATE_SOURCE_QPN;
>  	}
> =20
> +	ret =3D create_qp_opt_attrs(attrs, device, pd, &attr, &qp_semantics);
> +	if (ret)
> +		return ret;
> +
>  	ret =3D create_qp_attr_set(attrs, device, &attr, &qp_attr,
>  				 &qp_attr_mask);
>  	if (ret)

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019-uet-ib-cor=
e-v2-0-8bd654f25370@broadcom.com?part=3D10
