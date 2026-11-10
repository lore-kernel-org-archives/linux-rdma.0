Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794288567;
	b=KMjmr3NBhuWTv3agdht8pOIX9fegkReHxj715ms1/1qQZ5JI4SsBnGUFvOj8kG+W5wRb
	 /8NLKsk9cbGhlCVis2rz3U0vGroJllqSqAXeqveucyYD51s7t6OZbGmOF+KlK99UsSiEC
	 T4JxsmvXAXNlPzu/T9xMLTM+HgBhSW2hcSOYlidGfq6Mvxu/dooisEbJ7V4EjgR8qLzzr
	 DT5D8kXK4JIep00mdCKDJ0PZPzUFIKaqXsZIe/UqAv7SE6fRDjRVeQqvjAl6XQbx9e+0I
	 nH2p27ssBD0au2wx2Sr6S5iHNxyyen6xfI927uXAxDIq6/NNI4FwowCfsiwnFDGlxWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794288567;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=JB6kwIhv0MXPbFQBiM8aG+2iGLCzE0jmb6RFJUO1kpw=;
	b=2vULrf53piPmf4gLNlDJL0jxSOCdarOfO0+pSmdBAt6vaRAno48fq11vmYmdBkIF/G12
	 Ux1jBL3B0FJPK19MjZNwvVwvJ3rD+MG7RUFySWw98zh4US24Hgi9+B2ufR1XOiMroBpsC
	 /3oAfBpaf3NH3P0AQoFoVH8mz6XH3rseWIMu9SwZmvbi54RFCWBotH2HlZt/Yj+bl5Wmr
	 oYt6NpA2j+oCUXN6PJ3tafd07BcnkYmrgpI20S4EdYmOm++FH9iSPDjDEDQgkx5AC/v7y
	 qtpbcpcvX+N5MOsZMUt7UWIBBTEEy73jcaaODCLTCshstaXrPHMYE1CWWluJD8nZIHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i1BYOXM+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61477606A31C
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 05:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i1BYOXM+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D33941F0089F;
	Tue, 10 Nov 2026 05:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794288567;
	bh=JB6kwIhv0MXPbFQBiM8aG+2iGLCzE0jmb6RFJUO1kpw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=i1BYOXM+wnipB9sx9O/AQRSYjnVuK5zmYGhkn09visVZaWMBDEy07i/kTEe/lbu0Z
	 giwYFBQHyEdT+xNV7z64wUopPhQfVJEtO1pSPMb7pBkVt4e1/AUdQ/8ZM/a7Zgdzkq
	 xPc/daEU0vkggDE0fS+WdcDZWqyR1YJhxcJtM44BOM9g++nrCqOJaRxLeyCpibmnf6
	 1jvphBrWwv/gfhmFO5VjsLhFue9tA+5cZ+gakeIeo70p4ge0ik372zDXNcmS6uNjse
	 uCBsxkL4Yqsy6sdJtlCy7Sd+lIXWR4bgdwMw+KR3M8BbnguyaXI15SGHRbYliK/i0f
	 4/VKmejAnPtZw==
Message-ID: <sashiko-outbox-206295@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v3 10/13] RDMA/core: queue pair attributes for
 unconnected transports
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Davis" <eric.davis@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261109-uet-ib-core-v3-10-3e7e7ffed2e9@broadcom.com>
References: <20261109-uet-ib-core-v3-0-3e7e7ffed2e9@broadcom.com>
 <20261109-uet-ib-core-v3-10-3e7e7ffed2e9@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 05:29:26 +0000
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
- [Medium] RDMA/core: incomplete zero-size ordering check in
  create_qp_opt_attrs()
--

commit ab78e9acb0c6a04e98901cf4dece43df9ce37611
Author: Eric Davis <eric.davis@broadcom.com>

RDMA/core: queue pair attributes for unconnected transports

This commit adds creation attributes for reliable unconnected (IB_QPT_RU)
queue pairs, including initiator source ID, job key binding, and ordering
semantics validation.

> diff --git a/drivers/infiniband/core/uverbs_std_types_qp.c b/drivers/infi=
niband/core/uverbs_std_types_qp.c
> index 249206d2992f9..a1112083fb73f 100644
> --- a/drivers/infiniband/core/uverbs_std_types_qp.c
> +++ b/drivers/infiniband/core/uverbs_std_types_qp.c

[ ... ]

> +	if (has_semantics) {
> +		ret =3D uverbs_copy_from_or_zero(&usem, attrs,
> +					       UVERBS_ATTR_CREATE_QP_SEMANTICS);
> +		if (ret)
> +			return ret;
> +
> +		m =3D usem.comp_mask;
> +		if ((m & ~QP_SEMANTICS_MASK_ALL) ||
> +		    ((m & IB_UVERBS_QP_SEMANTICS_MASK_MSG_ORDER) &&
> +		     (usem.msg_order & ~QP_ORDER_ALL)) ||
> +		    ((m & IB_UVERBS_QP_SEMANTICS_MASK_USAGE) &&
> +		     (usem.usage_flags & ~QP_USAGE_ALL)) ||
> +		    memchr_inv(usem.reserved, 0, sizeof(usem.reserved)))
> +			return -EINVAL;
> +
> +		/* only the fields comp_mask selects reach the driver */
> +		sem->comp_mask =3D m;
> +		if (m & IB_UVERBS_QP_SEMANTICS_MASK_MSG_ORDER)
> +			sem->msg_order =3D usem.msg_order;
> +		if (m & IB_UVERBS_QP_SEMANTICS_MASK_RAW)
> +			sem->max_rdma_raw_size =3D usem.max_rdma_raw_size;
> +		if (m & IB_UVERBS_QP_SEMANTICS_MASK_WAR)
> +			sem->max_rdma_war_size =3D usem.max_rdma_war_size;
> +		if (m & IB_UVERBS_QP_SEMANTICS_MASK_WAW)
> +			sem->max_rdma_waw_size =3D usem.max_rdma_waw_size;
> +		if (m & IB_UVERBS_QP_SEMANTICS_MASK_PDU)
> +			sem->max_pdu =3D usem.max_pdu;
> +		if (m & IB_UVERBS_QP_SEMANTICS_MASK_USAGE)
> +			sem->usage_flags =3D usem.usage_flags;
> +		if (m & IB_UVERBS_QP_SEMANTICS_MASK_IMM)
> +			sem->imm_data_size =3D usem.imm_data_size;
> +
> +		/* nor an ordering whose data-ordering size it gives as 0 */
> +		if (((m & IB_UVERBS_QP_SEMANTICS_MASK_RAW) &&
> +		     !sem->max_rdma_raw_size &&
> +		     (sem->msg_order & QP_ORDER_RAW_SIZED)) ||
> +		    ((m & IB_UVERBS_QP_SEMANTICS_MASK_WAR) &&
> +		     !sem->max_rdma_war_size &&
> +		     (sem->msg_order & QP_ORDER_WAR_SIZED)) ||
> +		    ((m & IB_UVERBS_QP_SEMANTICS_MASK_WAW) &&
> +		     !sem->max_rdma_waw_size &&
> +		     (sem->msg_order & QP_ORDER_WAW_SIZED)))
> +			return -EINVAL;

[Severity: Medium]
Can userspace bypass this zero-size ordering check by omitting
IB_UVERBS_QP_SEMANTICS_MASK_MSG_ORDER from comp_mask?

sem->msg_order is only populated when IB_UVERBS_QP_SEMANTICS_MASK_MSG_ORDER
is set in m, remaining 0 otherwise.  If a caller sets
IB_UVERBS_QP_SEMANTICS_MASK_RAW with max_rdma_raw_size =3D=3D 0 and leaves
IB_UVERBS_QP_SEMANTICS_MASK_MSG_ORDER clear, sem->msg_order is 0 and this
check passes even though the caller did not relax msg_order and the device
default adv.msg_order still has QP_ORDER_RAW_SIZED set, passing inconsistent
semantics in attr->qp_semantics to the driver.  Should this check test
against the effective msg_order (using adv.msg_order when
IB_UVERBS_QP_SEMANTICS_MASK_MSG_ORDER is not set, and conversely checking
adv.max_rdma_*_size when a sized ordering bit is requested without its size
mask)?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109-uet-ib-cor=
e-v3-0-3e7e7ffed2e9@broadcom.com?part=3D10
