Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C28F3DD520
	for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 22:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792018247; cv=none; b=vGu+qsnUoOHynYo/UCbH9GEgDyKf3hjmxDXeKivnpjrP4X4mlDdiZ3GA/m8fJ9CLASv5dzrls5uu/aWqbcFs3ddjFZ8DEj47B8PeqW9zOgkKFFj9VH+hoWET0ilFN3d3GO+Hvj0nxUOBkAuPbQvemrGrrEkaqff65KFxLYsm5Ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792018247; c=relaxed/simple;
	bh=NqD3E4w4DuL0zgXruPSAN7H224T1ClQcWL2GoXqBC1Y=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=gTsYTh4iEJMNPu0qXjGv6MDMF8BhYLP6xhC1R1DF6XASjtIfsF2+lFPmY6aqCnuBHkxXelTvXpWHYui5nAvg4oP4PjiBoJeqrGIAIXB+JZMPS32XxhNhG1XbE1gZ1VIbrf6b708zyc1vUzbZP1JQ08Vik3/FhTUQULqH/v/dtAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JxkwSufI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JxkwSufI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 969961F000C4;
	Wed, 14 Oct 2026 22:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792018245;
	bh=HujKxsZisv2sctBq2thaAqAMtXaurcSaZJwXqrPx0Uc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JxkwSufIo6A10k1hw1x8ht7+ZSDwXvbJgBYb8Xlwq9CwDNT1aWJ0JvYHq3Em8D2sS
	 D2AYvzuvP4M4pvQuKGy6LIxYqUlDroHCpnSIlzwoM7fsWHyeXilQg36Thi6Np2urIJ
	 aClE4elZfxURDCmB81IPWJbopy/KI7J+KVbRrhhbL6lTE9yBzojWP7DoxB8czUJm6I
	 nz9d1ZcaODjXTy4PyoPEQOFrxxwsH2ifUhXjbDB2OH+fji2iWvCKqRmgMOId8OZByi
	 Hxx2xaScmURmoa2H7Rah3PNrPi9BCQR+h0+OMaapH8EbdJYnmSLq0WP0ZPJSEsv1TT
	 eJxAx3mFNrcjw==
Message-ID: <sashiko-outbox-172008@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 05/13] RDMA/core: extended address handle
 attributes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Davis" <eric.davis@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261014-uet-ib-core-v1-5-a0e626117113@broadcom.com>
References: <20261014-uet-ib-core-v1-0-a0e626117113@broadcom.com>
 <20261014-uet-ib-core-v1-5-a0e626117113@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 22:50:45 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] rdma: uverbs_copy_from() breaks forward ABI compat for zero-padd=
ed structs
--

commit 580d7ef2fa7c4af573e68362c952e7b8886ec21b
Author: Eric Davis <eric.davis@broadcom.com>

    RDMA/core: extended address handle attributes

This commit adds rdma_ah_attr_ex to carry new attributes and implements
an ioctl method to support extended address handles. It also updates
rdma_create_user_ah() to accept the initialized attributes.

> diff --git a/drivers/infiniband/core/uverbs_std_types.c b/drivers/infinib=
and/core/uverbs_std_types.c
> index e160786e1df16..c72c9e5a22863 100644
> --- a/drivers/infiniband/core/uverbs_std_types.c
> +++ b/drivers/infiniband/core/uverbs_std_types.c
> @@ -184,6 +184,76 @@ DECLARE_UVERBS_NAMED_OBJECT(UVERBS_OBJECT_MW,
[ ... ]
> +static int UVERBS_HANDLER(UVERBS_METHOD_AH_EX_CREATE)(
> +	struct uverbs_attr_bundle *attrs)
> +{
[ ... ]
> +	if (!(ib_dev->attrs.device_cap_flags & IB_DEVICE_RU))
> +		return -EOPNOTSUPP;
> +
> +	ret =3D uverbs_copy_from(&uah, attrs,
> +			       UVERBS_ATTR_CREATE_AH_EX_AH_ATTR_EX);

[Severity: Medium]
Does using uverbs_copy_from() here break forward ABI compatibility?

UVERBS_ATTR_STRUCT sets .zero_trailing =3D 1, which should permit a newer
userspace to pass a larger zero-padded payload to an older kernel. However,
_uverbs_copy_from() explicitly rejects larger sizes:

include/rdma/uverbs_ioctl.h:_uverbs_copy_from() {
    ...
	if (unlikely(size < attr->ptr_attr.len))
		return -EINVAL;
    ...
}

If a newer userspace application passes a zero-padded payload of 40 bytes to
this kernel (where the structure size is 36), the size check in
_uverbs_copy_from() will evaluate to 36 < 40 and return -EINVAL.

Should this use uverbs_copy_from_or_zero() instead, to properly support
trailing zeros and allow future structure extensions?

> +	if (ret)
> +		return ret;
> +
> +	ret =3D copy_ah_attr_from_uverbs_ah(ib_dev, &attr.ah_attr, &uah.ah_attr=
);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014-uet-ib-cor=
e-v1-0-a0e626117113@broadcom.com?part=3D5
