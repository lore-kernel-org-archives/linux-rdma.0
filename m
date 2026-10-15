Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D453B6C1C
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 12:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792066275; cv=none; b=cdRhJPZ9H5O7XFw2oxcR9SnXLRbRfdgtalXf9VJPvRYECX+3oknj/hV/McgfBCJ2XDuDKunLAxSOcjzmc9XVj7/QMWT5sMF6e43KAh/YuLzt1S+GWn/fTZS/+8+LeEmwDZ5D8RrZDZZGj+dIKHh4ORlMMx22V/8LgIHWOyUxaIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792066275; c=relaxed/simple;
	bh=lQ2HIl8WY3yXxgr8zvUCKR9bdhHYp7SwqeFcN4CKHPg=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=PfmFgSOrpcBB8pLOKLu00P2BuGVqjs9dc1ElwJqVvF5RVNsZbzjL15S2om1aj6PAA9nPiCNgm2xfJh9mb+3DAg0Txowz1lKXFxFdUfJHtZrHlKtd5AwRtD7a7JEa01AjuCiC2RahRHw4t2Spo3Lzw9WtVVIPHht2vHn5X7nZ9Uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k0BPrS3D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k0BPrS3D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 737391F000C4;
	Thu, 15 Oct 2026 12:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792066274;
	bh=X+DuTQFWKJf9o/KUGPZqM9i48NLaTVOwFzWQU7kh+rM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=k0BPrS3DPLgP2rNgEb5IcLqpfkm1hPqMJzdWV/p30SmB6oLmMKYs80SZBPDarUNs1
	 o6yZ+2b+DIL/YPkNCBdejievIT0qzL6wmf+Kozz74Iu6xHcy/xVTsqaYESx+Yh7Z9Z
	 4pEQraZhMX2IjMbqopEnuObcFU81B/JpkJAOQsRNlPBHS0QKROQtVW0SBrNou2CUeY
	 v8lNV/W68+7+lt0rPIhrR79MlUmpoklM7+3GByLrChA2LukbzCQn/AltHmyY0QLFj/
	 xo7xng4XHL5osnMNLZZ6sxJB3Zt/JjtbILjwVwmMcC262ESq5JKHV9ghv0w2+a9rCk
	 tUOMRAWLj+NTg==
Message-ID: <sashiko-outbox-172785@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 1/3] RDMA/core: Preserve the selected source
 GID on failed AH modification
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261015-ib-core-fixes-v1-1-60f6da3ddec3@nvidia.com>
References: <20261015-ib-core-fixes-v1-0-60f6da3ddec3@nvidia.com>
 <20261015-ib-core-fixes-v1-1-60f6da3ddec3@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 12:11:13 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] rdma: memory leak and UAF due to missing sgid_attr refcount in rvt=
_modify_ah()
--

commit cfb0c41a87200fc5df90876398650807044c23ad
Author: Leon Romanovsky <leon@kernel.org>

RDMA/core: Preserve the selected source GID on failed AH modification

When an address-handle modification fails, the core replaces its source-GID
reference. This commit ensures the selected source GID is preserved by only
updating ah->sgid_attr when the modification is successful.

> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/ve=
rbs.c
> index edf62652f9d3e..7d52d30362087 100644
> --- a/drivers/infiniband/core/verbs.c
> +++ b/drivers/infiniband/core/verbs.c
> @@ -1011,7 +1011,8 @@ int rdma_modify_ah(struct ib_ah *ah, struct rdma_ah=
_attr *ah_attr)
>  		ah->device->ops.modify_ah(ah, ah_attr) :
>  		-EOPNOTSUPP;
> =20
> -	ah->sgid_attr =3D rdma_update_sgid_attr(ah_attr, ah->sgid_attr);
> +	if (!ret)
> +		ah->sgid_attr =3D rdma_update_sgid_attr(ah_attr, ah->sgid_attr);
>  	rdma_unfill_sgid_attr(ah_attr, old_sgid_attr);

[Severity: High]
Does this sequence expose a memory leak and use-after-free in providers
that do a shallow copy of ah_attr?

For example, in drivers/infiniband/sw/rdmavt/ah.c:rvt_modify_ah(), the
structure is shallowly copied:

	ah->attr =3D *ah_attr;

This causes a memory leak of the old sgid_attr reference because
rdma_put_gid_attr() is not called on the old pointer, and it adopts the
new sgid_attr without incrementing its refcount.

When rdma_modify_ah() finishes, it calls rdma_unfill_sgid_attr() which
drops the temporary refcount that rvt_modify_ah() copied but didn't pin.
This leaves the driver's ah->attr exposed to a dangling pointer.

Later, rvt_destroy_ah() will unconditionally call:

	rdma_destroy_ah_attr(&ah->attr);

This calls rdma_put_gid_attr() on the unheld pointer, resulting in a
refcount underflow and use-after-free.

This path is concretely reachable via the hfi1 provider (for instance,
hfi1_modify_qp0_ah() uses rdma_modify_ah() with IB_AH_GRH enabled).=20

Should providers like rdmavt be updated to use rdma_replace_ah_attr()
to properly manage these refcounts?

>  	return ret;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015-ib-core-fi=
xes-v1-0-60f6da3ddec3@nvidia.com?part=3D1
