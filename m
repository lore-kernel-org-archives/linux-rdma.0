Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C29003C1D5F
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 13:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789478670; cv=none; b=BBVvm/HLN259gCQ2dNzgN1cMyRW7rjyj6e3WNbQDYUwsOC8zQiDmDitzhuy550NFgE5smCvQ+Od22I1B6aYhLVFsVU/CVeSVOwPJSOnYXa63KXRq4FgRqm/BIOubmmvYxdR0l1+Z1V+3/JP6hj5fPbUmqRP5+dFUwhuA9gaZeJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789478670; c=relaxed/simple;
	bh=78UhYf5Z1anogbpEfJxfCHKZJKdE7rCB/xhk00FzvoY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=UyvPcWw4ylGIQirL2Vf0yn2VZJpJqbJzngssFe7Jp6GlZrc/5jFv2YGpAd/Wn53HFwfrvnizwsw5QVAVR6ILhfFPJZbdx1jKmNRrDpGhcc744bqiHheSk5T4ZgChK1M4EPljU9g0gJX6pWbSj8igPwUMfL2ZfTXt8drs7K9NlgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XC5Lx4pg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XC5Lx4pg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C67B1F0089B;
	Tue, 15 Sep 2026 13:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789478668;
	bh=FxEGMXXLMpBQqJfGCKgaelOTiIbzOIWYB7hV0DzZfig=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XC5Lx4pg547DMeVgN+/jOfuO+0dRPzkbi7FKmbEbJAT9gVluyb4VGMh0tU7CNSsg/
	 sF2IJPLF71nSlUXgXJ/I/+8L0PoGmSqJTLVJEvll4JemXRC8nJFocPD7ch3kcei/WK
	 vRHDxUxDR1SDlaXW3RzRB8nZDwuaJgVq/As9rFKKusmV5goWJAKrj6+0doabdPwZu7
	 iFCaZeuOODkcAFwpxc4SLCVndR9GCxuIz27aZIGikzcC0DZWMIMvrirMC7yjFkf3dL
	 jUS1wyQdRhHzqZ8Tl+ePN2xhrYGDpYqMAMqeB7iHZHh4RpjmsE/GGikZ5U86jqFekf
	 F1wJNlCQjZIfQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next] RDMA/bnxt_re: Limit SRQ depth to the firmware
 command field
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260915-silent-16-bit-truncation-of-srq-size-v1-1-3199f8fe94bc@nvidia.com>
References: <20260915-silent-16-bit-truncation-of-srq-size-v1-1-3199f8fe94bc@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 13:24:27 +0000
Message-Id: <20260915132428.2C67B1F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] RDMA/bnxt_re: silent SRQ desync for legacy userspace due to non-po=
wer-of-two cap
--

commit a0fff360dfd527e4f635aa0d8696bce687733ce9
Author: Leon Romanovsky <leon@kernel.org>

RDMA/bnxt_re: Limit SRQ depth to the firmware command field

Firmware can report an SRQ depth above 16 bits, but CREATE_SRQ carries the
allocated depth in a 16-bit field. Requests near the advertised limit can
therefore truncate the command value and make firmware use a different
depth than the allocated queue.

> diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniban=
d/hw/bnxt_re/ib_verbs.c
> index ef08d42f377e6..43ff3e7a459fa 100644
> --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> @@ -2229,8 +2229,8 @@ int bnxt_re_create_srq(struct ib_srq *ib_srq,
>  	dev_attr =3D rdev->dev_attr;
>  	srq =3D container_of(ib_srq, struct bnxt_re_srq, ib_srq);
> =20
> -	if (srq_init_attr->attr.max_wr >=3D dev_attr->max_srq_wqes) {
> -		ibdev_err(&rdev->ibdev, "Create CQ failed - max exceeded");
> +	if (srq_init_attr->attr.max_wr > dev_attr->max_srq_wqes) {
> +		ibdev_err(&rdev->ibdev, "Create SRQ failed - max exceeded");
>  		rc =3D -EINVAL;
>  		goto exit;
>  	}
> diff --git a/drivers/infiniband/hw/bnxt_re/qplib_sp.c b/drivers/infiniban=
d/hw/bnxt_re/qplib_sp.c
> index ec9eb52a8ebf7..63dcbb9d80f4b 100644
> --- a/drivers/infiniband/hw/bnxt_re/qplib_sp.c
> +++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
> @@ -159,7 +159,8 @@ int bnxt_qplib_get_dev_attr(struct bnxt_qplib_rcfw *r=
cfw)
>  	attr->max_ah =3D le32_to_cpu(sb->max_ah);
> =20
>  	attr->max_srq =3D le16_to_cpu(sb->max_srq);
> -	attr->max_srq_wqes =3D le32_to_cpu(sb->max_srq_wr) - 1;
> +	attr->max_srq_wqes =3D min_t(u32, le32_to_cpu(sb->max_srq_wr),
> +				   U16_MAX) - 1;

[Severity: High]
Does capping max_srq_wqes to 65534 break legacy userspace applications that
rely on power-of-two queue sizes?

If a legacy application requests an SRQ size that rounds up to 65536
(e.g. 32768), bnxt_re_create_srq() will pass dev_attr->max_srq_wqes + 1
(65535) as the maximum to bnxt_re_init_depth():

drivers/infiniband/hw/bnxt_re/ib_verbs.c:bnxt_re_create_srq() {
    ...
	srq->qplib_srq.max_wqe =3D
		bnxt_re_init_depth(srq_init_attr->attr.max_wr + 1,
				   dev_attr->max_srq_wqes + 1, uctx);
    ...
}

In bnxt_re_init_depth(), this results in min(65536, 65535) and returns 6553=
5:

drivers/infiniband/hw/bnxt_re/ib_verbs.h:bnxt_re_init_depth() {
    ...
	if (uctx && !(uctx->cmask & BNXT_RE_UCNTX_CAP_POW2_DISABLED))
		return min(roundup_pow_of_two(ent), max);
    ...
}

Because 65535 is not a power of two, legacy userspace masking (e.g., idx &
0xFFFE) becomes mathematically incorrect, immediately corrupting ring state
and causing producer/consumer desynchronization without throwing an error.

>  	attr->max_srq_sges =3D sb->max_srq_sge;
>  	attr->max_pkey =3D 1;
>  	attr->max_inline_data =3D attr->max_qp_sges * sizeof(struct sq_sge);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915-silent-16-=
bit-truncation-of-srq-size-v1-1-3199f8fe94bc@nvidia.com?part=3D1
