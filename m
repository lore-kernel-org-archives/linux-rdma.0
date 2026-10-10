Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E85523BD06
	for <linux-rdma@vger.kernel.org>; Sat, 10 Oct 2026 07:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791616315; cv=none; b=Otrh6iN1EOmLsNgJoI9i0/vKSBPcYtHDvuB8Nll0oIdpEc+Cs/WKJl94vSkRD8lo91s5CoUIhUuWt9DkkmRotREX2Ffheu0JMphHGo3FWBM31mimvexfUdZ7QpXDMXv6uAmSKDYLgu/LccdJLWxqJ6p95YLEEYVXTeVc52TOkWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791616315; c=relaxed/simple;
	bh=Uod0+Qow+m2+TtTO+Sn1viedFSKTGgcW811661tfxCw=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=LLINQLBpC6TRDWiHBCJEvrKQpcbgS+0GDqHpekcFoOyK6lzcao8F0XVGP4EbdbDunpejGu35dHBPKFx3eciD5o6OMoZteOBLJY2GXbjxQO+Aoc8n2LjNyhM8x5phvsLAl9gPDotPkk9CczrPDo14IEelyLzdiMi7BbBfR4W6nwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zd0KXWlk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zd0KXWlk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5F901F000FF;
	Sat, 10 Oct 2026 07:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791616314;
	bh=S1PJ5mPwukS/FBlNZ90TE4lHWROhrMMGa8GLMe0mMJw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Zd0KXWlkcFxHlPxrq9C/QBKMsw72YkdWqgAwU+ZqV3rhZ8z+NOPezLG2Z/C41KvHY
	 bw7CxCXB4d80pH11ElWiyzIxyX384raIH47rpcHdsEUFfyKm58axcjG4TGBhhKlotp
	 88yei6Jtk4rHejzv/AudljN1vCVovQ2hs6lpzxvGxNBJAF86gT02tIIjmnkLQLANlu
	 oMVC9VkToXoJetMUMj5ndxoGBmdDtjOwxdlEhjHlT3kp2iw0XQzyuv4+VtS1rTQDkR
	 G2sZlAE87wZTDmb/GzQkf1EhcxrTN8fEXXr43Bmo7OL3BtLIjw6bN8jW8cBdTrf25J
	 8MpoO7BolYjpw==
Message-ID: <sashiko-outbox-166302@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v4 02/10] RDMA/mana: Create and destroy kernel
 RC QPs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261010065443.3554193-3-kotaranov@linux.microsoft.com>
References: <20261010065443.3554193-1-kotaranov@linux.microsoft.com>
 <20261010065443.3554193-3-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 10 Oct 2026 07:11:53 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] rdma/mana: integer overflow and undefined behavior in QP queue siz=
e allocation
--

commit 235f9b2c1102f8c3daad00640633a128077a03a8
Author: Konstantin Taranov <kotaranov@microsoft.com>

    RDMA/mana: Create and destroy kernel RC QPs
   =20
    Implement kernel RC QP creation and destruction. This feature requires
    extended-WQE and power-of-two-SQ support from the HW.

> diff --git a/drivers/infiniband/hw/mana/qp.c b/drivers/infiniband/hw/mana=
/qp.c
> index 15c5d6cefd628..edaf03372cd81 100644
> --- a/drivers/infiniband/hw/mana/qp.c
> +++ b/drivers/infiniband/hw/mana/qp.c

[ ... ]

> @@ -442,6 +442,32 @@ static u32 mana_ib_queue_size(struct ib_qp_init_attr=
 *attr, u32 queue_type)
>  			queue_size =3D attr->cap.max_recv_wr *
>  				mana_ib_wqe_size(attr->cap.max_recv_sge, INLINE_OOB_SMALL_SIZE);
>  		break;
> +	case IB_QPT_RC:
> +		switch (queue_type) {
> +		case MANA_RC_SEND_QUEUE_REQUESTER:
> +			queue_size =3D attr->cap.max_send_wr *
> +				mana_ib_fixed_wqe_size(attr->cap.max_send_sge,
> +						       INLINE_OOB_EXTRA_LARGE_SIZE);
> +			break;

[Severity: High]
Can this 32-bit multiplication overflow if max_send_wr and max_send_sge are
unvalidated? The kernel ULP can provide an arbitrarily large max_send_wr and
max_recv_wr via attr->cap.

If attr->cap.max_send_wr is 0, queue_size will evaluate to 0. Since
mana_ib_queue_size() later returns
MANA_PAGE_ALIGN(roundup_pow_of_two(queue_size)), doesn't
roundup_pow_of_two(0) result in undefined behavior?

[ ... ]

> +static int mana_ib_create_rc_qp_kernel(struct ib_qp *ibqp, struct ib_pd =
*ibpd,
> +				       struct ib_qp_init_attr *attr)
> +{
> +	struct mana_ib_dev *mdev =3D container_of(ibpd->device, struct mana_ib_=
dev, ib_dev);
> +	struct mana_ib_qp *qp =3D container_of(ibqp, struct mana_ib_qp, ibqp);
> +	u32 doorbell =3D mdev->gdma_dev->doorbell;
> +	u32 queue_size;
> +	u64 flags =3D 0;
> +	int i, err;
> +
> +	if (!(mdev->adapter_caps.feature_flags & MANA_IB_FEATURE_EXTENDED_WQE_F=
ORMAT))
> +		return -EOPNOTSUPP;
> +	if (!(mdev->adapter_caps.feature_flags & MANA_IB_FEATURE_RC_QP_SQ_POW2_=
SUPPORT))
> +		return -EOPNOTSUPP;
> +
> +	for (i =3D 0; i < MANA_RC_QUEUE_TYPE_MAX; ++i) {
> +		queue_size =3D mana_ib_queue_size(attr, i);
> +		err =3D mana_ib_create_kernel_queue(mdev, queue_size,

[Severity: High]
Does this code blindly pass the potentially overflowed queue_size to hardwa=
re
queue allocation without prior validation of attr->cap limits against
mdev->adapter_caps.max_qp_wr? The hardware could overrun an undersized DMA
queue, leading to memory corruption.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261010065443.3554=
193-1-kotaranov@linux.microsoft.com?part=3D2
