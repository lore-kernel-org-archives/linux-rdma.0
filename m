Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6FD10F1
	for <linux-rdma@vger.kernel.org>; Wed,  9 Sep 2026 08:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788943839; cv=none; b=jjmO5oJxe8dqkBS7t/D7F42xsug5j85KK5GloV01Orlm0CiHYgvagO+zSk6nikKhrNYxAuIfq1eCgokehV9aKSO17eM5I2sR1VIqiG/LycZmV4u+ZcIpKrXsrbth0VKTxpM6+6s5xTxWOvs3es5ul6zb2TXdbPKv3dilbv5SrbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788943839; c=relaxed/simple;
	bh=FfJFove3Km+TbbbpvwmuroGuZk8/9fncya3Z6y0st5c=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=idPJwgOKyhQex/vzezgwmrdqcK1aZF/V7dHrTrugaVEZkGYnQlloI7SMnOZlc8Kl1t4ufoi8dsYjGYiBs7/AjEw0gH6AmNqWE0AqklQKv+Rv1gvs1rMfACIr7nmzyDywGl++Z2K/nqWLfVR4hNSscimWsZQt2bg4nOGlGf6TUkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qxa7ChZq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qxa7ChZq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBB881F00A3D;
	Wed,  9 Sep 2026 08:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788943837;
	bh=mSUk3tKK98xPubnOrf7d9vWBSiyL/bP5Y85cjUrjI7U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Qxa7ChZqj2he951fAmCBCDTKlXib6fU+L2PgznQQnf5J3EQ4+4huOc5O75xKwbHkt
	 +9v4m11NGOclHVVjNuQNeA5+8tWiFfQqbcQ1d2PV/1iGifjzGYihCpYHAZKGcPN7Cj
	 T6ivFKz4qt+HOkLbfjzI7fF2hXhUIETXE/Ok/5es+tEBge5OVK5N7J+RPnOER7LV34
	 ZQgTfq2P2nxRJYiJ8JYedHqyBzsKzc5Tng77+v4sAxpGKz83AG6ENyA7Cw+EokC4IV
	 mnlSdJwqhDRgDNZOc3xs3MuuSKbVqDX6dFkeRDwtKPtZVe7wk2Ju5DNQI6bG0SUoLk
	 8XJ5HG7+36jTQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH for-rc v2 3/8] RDMA/bnxt_re: Validate num_sge in
 bnxt_re_post_srq_recv()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Selvin Xavier" <selvin.xavier@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260909135244.122747-3-selvin.xavier@broadcom.com>
References: <20260909135244.122747-1-selvin.xavier@broadcom.com>
 <20260909135244.122747-3-selvin.xavier@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 08:50:37 +0000
Message-Id: <20260909085037.BBB881F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Medium] Unconditional error logging on fast-path enables unprivileged lo=
g spam (Denial of Service)

Pre-existing issues:
- [High] Uninitialized stack memory in hardware work queue descriptor (wqe.=
flags)
--

commit a50a4d21bcd2c8e40025a33fa29a7f621d05a408
Author: Selvin Xavier <selvin.xavier@broadcom.com>

RDMA/bnxt_re: Validate num_sge in bnxt_re_post_srq_recv()

This commit adds a validation check in bnxt_re_post_srq_recv() to ensure
that the number of scatter/gather elements (SGE) provided for a Shared
Receive Queue (SRQ) does not exceed the device's configured maximum.

> diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniban=
d/hw/bnxt_re/ib_verbs.c
> index e56830a669bf4..ab9d4d6bf5b02 100644
> --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> @@ -2386,9 +2386,16 @@ int bnxt_re_post_srq_recv(struct ib_srq *ib_srq, c=
onst struct ib_recv_wr *wr,
>  			  const struct ib_recv_wr **bad_wr)
>  {
>  	struct bnxt_re_srq *srq =3D container_of(ib_srq, struct bnxt_re_srq,
>  					       ib_srq);
>  	struct bnxt_qplib_swqe wqe;

[Severity: High]
This is a pre-existing issue, but does this allocation leave wqe.flags
uninitialized before the structure is passed to the hardware?

Any legitimate call to bnxt_re_post_srq_recv allocates the wqe structure on
the stack without zeroing it. The function sets specific fields but appears
to leave wqe.flags uninitialized before calling bnxt_qplib_post_srq_recv,
which writes the flags field into the hardware's ring buffer descriptor.

Can this result in unpredictable hardware behavior or dropped work requests
if the garbage stack data is misinterpreted by the hardware datapath?

>  	unsigned long flags;
>  	int rc =3D 0;
> =20
>  	spin_lock_irqsave(&srq->lock, flags);
>  	while (wr) {
>  		/* Transcribe each ib_recv_wr to qplib_swqe */
>  		wqe.num_sge =3D wr->num_sge;
> +		if (wr->num_sge > srq->qplib_srq.max_sge) {
> +			ibdev_err(&srq->rdev->ibdev,
> +				  "Limit exceeded for SRQ Receive SGEs");

[Severity: Medium]
Since this function is on a fast-path datapath reachable from unprivileged
userspace via the RDMA uverbs API, could this unconditional error log lead
to log spam?

An unprivileged userspace application could intentionally flood the kernel
ring buffer by passing a wr->num_sge that is valid for the system call but
exceeds the driver's max_sge limit.=20

Would it be better to rate-limit this ibdev_err call, or remove it entirely
to prevent potential denial of service through disk space exhaustion and
system performance degradation?

> +			rc =3D -EINVAL;
> +			*bad_wr =3D wr;
> +			break;
> +		}
>  		bnxt_re_build_sgl(wr->sg_list, wqe.sg_list, wr->num_sge);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260909135244.1227=
47-1-selvin.xavier@broadcom.com?part=3D3
