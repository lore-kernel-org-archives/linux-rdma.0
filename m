Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAFB448C3EF
	for <linux-rdma@vger.kernel.org>; Wed,  9 Sep 2026 09:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788944440; cv=none; b=IHYlHmKry/nRDqjs/rBC0c7NgBX0DP11CeUy0/Pcms8V5SpVGDeedi1Pg7NdOzeTrYQBkycOlp1TleRCDZBfh06mqeqwIWNjuRUh99k3VgOLr1pwD4E6XKrHPdrbqthear9u5Pz1AUge20mDF55Q+lzzJJX632W3ff41xORa8+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788944440; c=relaxed/simple;
	bh=eUswNYcL8C+XxdBR3Tw1P/ofM96DiWoBzg9Dn2QuIvA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=n76bSYVp2vtjfGuoheupIB/crEwIx//RI37qxpfDmb38/U0Z7UHQ7NfArxty6QaGxcTJTGZ3GguaOfyaNvjKzFj671HfCKZc9uJ6kNqZdI/pFrZLWYBS1pVGe8A7Aw/poWJAg3Sx4eTZcO566gGEBuMWSEPwSSr1SXzZCF3CETw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZrWKUGPh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZrWKUGPh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFDCD1F00A3D;
	Wed,  9 Sep 2026 09:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788944438;
	bh=jj0Xvli1pYmm+e4ufzw2ng7nO0tA1r1Q/Xn9eOnyluM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZrWKUGPhRKL6ilQcQcGcXxBct84mq+bS3QElp5tr7obDJBltC8sKLwTiG3VaMLSOH
	 Alt40pw7P4ugQ845ozcSgV6xIyfktEZUB8LTYqt6/rboPO/RTyMqk6ieQd8/eOiaDk
	 edjMdSK1VTkr8rQLfE2cLrBUd9+6VWodK0M4Ibqry/mU/X1a1p8+M9a9RRiVrOJIYZ
	 CbDmDQ/JzKumjzvRq7pYaXhoCwjfe0gpw+GdPvDND7juRNkrM3HKKyD6pkgEYGDf9V
	 6u7iEbjBbGMQ/WmEQg/pfF4gMcmqpJfwgxTLZWoszlBOYn7cmRWY+2R7y7it7hYNaK
	 kUZ6GPWrCmizQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH for-rc v2 4/8] RDMA/bnxt_re: Validate SRQ max_sge at
 create time
Reply-To: sashiko-reviews@lists.linux.dev
To: "Selvin Xavier" <selvin.xavier@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260909135244.122747-4-selvin.xavier@broadcom.com>
References: <20260909135244.122747-1-selvin.xavier@broadcom.com>
 <20260909135244.122747-4-selvin.xavier@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 09:00:37 +0000
Message-Id: <20260909090037.CFDCD1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Silent 16-bit truncation of SRQ size when submitting SRQ creation =
command to firmware.
--

commit 0a4f291b3aa3f286f901471db25ab33de33a632f
Author: Selvin Xavier <selvin.xavier@broadcom.com>

RDMA/bnxt_re: Validate SRQ max_sge at create time

bnxt_re_create_srq() validates attr.max_wr but copies attr.max_sge
into srq->qplib_srq.max_sge unvalidated. This lets an unprivileged
user request an arbitrarily large max_sge, defeating the num_sge
check added in bnxt_re_post_srq_recv() and overflowing the fixed
13-entry (BNXT_VAR_MAX_SGE) sg_list[] array in bnxt_re_build_sgl().

> diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniban=
d/hw/bnxt_re/ib_verbs.c
> index ab9d4d6bf5b02..72c098b488263 100644
> --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> @@ -2235,6 +2235,14 @@ int bnxt_re_create_srq(struct ib_srq *ib_srq,
>  		goto exit;
>  	}
> =20
> +	if (srq_init_attr->attr.max_sge > dev_attr->max_srq_sges) {
> +		ibdev_err(&rdev->ibdev,
> +			  "Create SRQ failed - max_sge %d exceeds supported %d",
> +			  srq_init_attr->attr.max_sge, dev_attr->max_srq_sges);
> +		rc =3D -EINVAL;
> +		goto exit;
> +	}
> +

[Severity: High]
This is a pre-existing issue, but while looking at SRQ size validation,
could large max_wr values cause a truncation issue when passed to
the firmware?

If unprivileged userspace calls ibv_create_srq() with a large max_wr value
permitted by the 32-bit max_srq_wr hardware capability, the driver rounds
up the requested queue depth to a power of two and stores it in the 32-bit
srq->hwq.max_elements.

In bnxt_qplib_create_srq(), this value is blindly cast to a 16-bit integer
for the firmware command:

drivers/infiniband/hw/bnxt_re/qplib_fp.c:bnxt_qplib_create_srq() {
    ...
    req.srq_size =3D cpu_to_le16((u16)srq->hwq.max_elements);
    ...
}

An exact multiple of 65536 will truncate to 0. The firmware is instructed
to create a 0-sized SRQ, while the kernel and userspace map a large queue.
Ringing the doorbell after writing to this queue will cause the firmware to
access unallocated memory or crash.

Does this hardware capability or queue depth need to be capped at 16-bits
during SRQ creation to avoid this mismatch?

>  	if (srq_init_attr->srq_type !=3D IB_SRQT_BASIC) {
>  		rc =3D -EOPNOTSUPP;
>  		goto exit;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260909135244.1227=
47-1-selvin.xavier@broadcom.com?part=3D4
