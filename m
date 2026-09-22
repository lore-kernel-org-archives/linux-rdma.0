Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49867352019
	for <linux-rdma@vger.kernel.org>; Tue, 22 Sep 2026 01:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790039222; cv=none; b=m6Si34pIjDvprzsrGA0j3Uj84hDXwoNgvbgs03a/G6veGFnXMFVCCyakGMtooTzjfdSnrThh0ZiYJkzu8VmM+I40YiMKe4+s+ZqbaSVtkZ3V1Qp6PgRWg7VnPqx89nTPHYdzKwJSL3cAMHaInFzBzuGKDDSmG6EuIHzRCAhoYaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790039222; c=relaxed/simple;
	bh=g420ze0VvuOrW17lMgb4pln1lwuVK6SPlAWGjHuzmN0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=e6rHRcIojWt4tN4CqLyGA9JvXJYd1yW7ZMFyZPcVO4AWKruwi4CoMSiVbkY4ZLg6fQ4CKaAu55nzO/pxec0qwA8jjkIn3MOSEh42//x9YSfZz5P+Kl5f58gnk26x1ReMUpCZCGQ5AjPcYh4ly62rNzcDdZYi8AjZOlt10N3lMys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yekkv6g4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yekkv6g4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FD561F000FF;
	Tue, 22 Sep 2026 01:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790039220;
	bh=FEPbviY8Jf+ybYh2ww4gMXCufGTI55Uc+VTNlMJxmSM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Yekkv6g4odOR5Q0y6klVQ3rea0vTq3h7aywOpyJakcj/9JL7ozbnZpYfPyo3q++/M
	 jkuNa+742cGKfovPOb2+0KHg4g6tsRN1kQgPSH4PUgujBjgwHVNoPYm+pMXEp8vNSa
	 +4kEVnkkNm6chx1IfjkXXcwIAfp3msxUKbSMIB5hVSWM5e2IwMmL9NXIdQnpbNWBjn
	 Fx4oKvLpzWRh97fnCB4C97QHTIY9F4ADRlLejWXbdJh3qEnj3quD1uFQN6vDLFr+/u
	 /xxc/uJmEBm3iviCjlclPOFLrW2fc80/WmgVbqVw2QcDVj6On+lAeT6aMCuQqSm6lS
	 aDPJRSJyhZIOQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH for-rc v3 3/8] RDMA/bnxt_re: Validate SRQ max_sge at
 create time
Reply-To: sashiko-reviews@lists.linux.dev
To: "Selvin Xavier" <selvin.xavier@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260922061230.7909-4-selvin.xavier@broadcom.com>
References: <20260922061230.7909-1-selvin.xavier@broadcom.com>
 <20260922061230.7909-4-selvin.xavier@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 01:07:00 +0000
Message-Id: <20260922010700.9FD561F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] bnxt_re: format string mismatch prints u32 as signed
--

commit c1caa6b4fbeb062c8f585d11a5ad5310dce0f434
Author: Selvin Xavier <selvin.xavier@broadcom.com>

RDMA/bnxt_re: Validate SRQ max_sge at create time
   =20
bnxt_re_create_srq() stored attr.max_sge into srq->qplib_srq.max_sge
unvalidated, which defeats the num_sge check in
bnxt_re_post_srq_recv() since that check compares against this same
attacker-chosen value. Reject max_sge > dev_attr->max_srq_sges at
create time, and clamp dev_attr->max_srq_sges to BNXT_STATIC_MAX_SGE
since SRQ WQEs use the fixed-size SGE array.

> diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniban=
d/hw/bnxt_re/ib_verbs.c
> index 081230fcb059e..911ac780c89bb 100644
> --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> @@ -2236,6 +2236,14 @@ int bnxt_re_create_srq(struct ib_srq *ib_srq,
>  		goto exit;
>  	}
> =20
> +	if (srq_init_attr->attr.max_sge > dev_attr->max_srq_sges) {
> +		ibdev_err(&rdev->ibdev,
> +			  "Create SRQ failed - max_sge %d exceeds supported %d",
> +			  srq_init_attr->attr.max_sge, dev_attr->max_srq_sges);

[Severity: Low]
Will this print confusing error logs when an invalid size is passed?

Since both srq_init_attr->attr.max_sge and dev_attr->max_srq_sges are u32,
the %d format specifier will interpret them as signed integers. This means
large invalid values (like those >=3D 0x80000000) will be logged as negative
numbers rather than their actual unsigned magnitude. Should these be printed
with %u instead?

> +		rc =3D -EINVAL;
> +		goto exit;
> +	}
> +
>  	if (srq_init_attr->srq_type !=3D IB_SRQT_BASIC) {
>  		rc =3D -EOPNOTSUPP;
>  		goto exit;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922061230.7909=
-1-selvin.xavier@broadcom.com?part=3D3
