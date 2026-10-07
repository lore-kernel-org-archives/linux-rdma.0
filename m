Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F164BF926
	for <linux-rdma@vger.kernel.org>; Wed,  7 Oct 2026 15:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791388230; cv=none; b=pB65TZc5MQtn/sZuco/oNCtQt+O7Umpw3tYkhzWEgV2m8gCy6cvkTAz460RX548w8QQ+muCN3y0tjQAa8NO8O+L6yFwxQtdcZf3htY9HC37+ri1Cv1bWLkd2rye4Td7GnfBBCOU7RWBYRM70Qfpd9K54YkHxguO3XWaUXLB+Fqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791388230; c=relaxed/simple;
	bh=pvLRFW8X7+JDmC5RQtjtUXX9S03J5a/2DrlcTBCV7uI=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=APQXHQGSvciI+c7dO3fvOD+/Sv8CP9Kivb6pKLQgKW3/PAlbv7FGGnQF2UuyE0j+Jh+ONrRnKdvG3zfo0VIZ/9XDSIU924bzOiPSChJdtdwqBxckofwQyRKRqBUpGStLaXGVe8BfNYTFtz8zarrHAWPDrn9a8dkXMwkIqXbFwq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uc3j68Ip; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uc3j68Ip"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B8E71F000FF;
	Wed,  7 Oct 2026 15:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791388224;
	bh=pFdFHhjGEwXmglS/UrCyXPoNL/oamw+U+4UcHVo4gmk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Uc3j68Ip453yNWMo5ppNLcokXTTqnYQ7M8pyTC0mQJJntjcuB4E4kY9k8ephcjQat
	 9gp/bIxK9/Sxw6nzP9jDlnDd0RKR893Ujt6aWEZ7D1t4kmU8K3q3Wf2dHtHUXB78zK
	 4dXDvhJUictJ2Du3XOu3lJ414j7coOvsvPIKsLuiKte1EgxV7J2cE3cxPpthpgpIIS
	 UeHrT9fHGDeLd5V6frT0G9LjyslGaY84COyi7aNqVtrByv5c31kXQgXvvlLXVp6vvf
	 bZoRrc/nsQzNreNXGTYvkWynGZWK1c5HNN+qu+K7HcEr31fnPBBtEvL3SzNSAyrS9e
	 JVeSNq88Lu82A==
Message-ID: <sashiko-outbox-163165@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v3 02/10] RDMA/mana: Create and destroy kernel
 RC QPs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261007153330.2979799-3-kotaranov@linux.microsoft.com>
References: <20261007153330.2979799-1-kotaranov@linux.microsoft.com>
 <20261007153330.2979799-3-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 15:50:24 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] mana: Missing bounds checks on QP capacities cause integer overflo=
w and undefined behavior
- [Medium] mana: Integer underflow in mana_ib_query_device when SGE count i=
s 0
--

commit 5b497775948fa714374d6418c365f7b62d67deb5
Author: Konstantin Taranov <kotaranov@microsoft.com>

RDMA/mana: Create and destroy kernel RC QPs

Implement kernel RC QP creation and destruction. This feature requires
extended-WQE and power-of-two-SQ support from the HW.

> diff --git a/drivers/infiniband/hw/mana/main.c b/drivers/infiniband/hw/ma=
na/main.c
> index fa47c988a2747..329bc9f30aa10 100644
> --- a/drivers/infiniband/hw/mana/main.c
> +++ b/drivers/infiniband/hw/mana/main.c
> @@ -637,7 +637,8 @@ int mana_ib_query_device(struct ib_device *ibdev, str=
uct ib_device_attr *props,
>  	props->max_qp =3D dev->adapter_caps.max_qp_count;
>  	props->max_qp_wr =3D dev->adapter_caps.max_qp_wr;
>  	props->device_cap_flags =3D IB_DEVICE_RC_RNR_NAK_GEN;
> -	props->max_send_sge =3D dev->adapter_caps.max_send_sge_count;
> +	/* Subtract 1 from max_send_sge to account for the reserved SGE */
> +	props->max_send_sge =3D dev->adapter_caps.max_send_sge_count - 1;

[Severity: Medium]
Could this subtraction underflow if the firmware reports max_send_sge_count
as 0?

If it underflows to 0xffffffff, this massively inflated value would be
reported to the RDMA core, which relies on it to bound user QP requests.
Could this allow malicious userspace to bypass sizing limits and induce
integer overflows during queue allocations?

>  	props->max_recv_sge =3D dev->adapter_caps.max_recv_sge_count;
>  	props->max_sge_rd =3D dev->adapter_caps.max_recv_sge_count;
>  	props->max_cq =3D dev->adapter_caps.max_cq_count;

[ ... ]

> diff --git a/drivers/infiniband/hw/mana/qp.c b/drivers/infiniband/hw/mana=
/qp.c
> index 15c5d6cefd628..edaf03372cd81 100644
> --- a/drivers/infiniband/hw/mana/qp.c
> +++ b/drivers/infiniband/hw/mana/qp.c
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

[Severity: High]
Does this missing bounds check on attr->cap allow for integer overflow or
undefined behavior here?

In mana_ib_create_rc_qp_kernel() and mana_ib_create_ud_qp(), attr->cap is
passed to mana_ib_queue_size() without bounds-checking against the adapter's
capabilities, unlike mana_ib_create_qp_raw() which validates the queue
capacities.

If max_send_wr and max_send_sge are abnormally large, could this 32-bit u32
multiplication overflow and wrap around to a small queue_size?=20

This would lead to an undersized GDMA queue allocation while the massive
size is sent to the RNIC, potentially resulting in out-of-bounds DMA access.

Additionally, if QPs are legitimately created with max_send_wr =3D 0 or
max_recv_wr =3D 0 (e.g., receive-only), queue_size becomes 0. The subsequent
call to roundup_pow_of_two(0) at the end of mana_ib_queue_size() evaluates
to fls_long(-1), which is undefined behavior in the kernel.

> +			break;
> +		case MANA_RC_SEND_QUEUE_MMQ:
> +			queue_size =3D attr->cap.max_send_wr *
> +				mana_ib_wqe_size(1U, INLINE_OOB_EXTRA_LARGE_SIZE);
> +			break;
> +		case MANA_RC_SEND_QUEUE_RESPONDER:
> +			queue_size =3D MANA_PAGE_SIZE;
> +			break;

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007153330.2979=
799-1-kotaranov@linux.microsoft.com?part=3D2
