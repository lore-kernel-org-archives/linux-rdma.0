Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 510CD46EC70
	for <linux-rdma@vger.kernel.org>; Fri,  2 Oct 2026 09:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790932385; cv=none; b=OvgMshAqZXSqUjjhup3UirPAzlNKD0BHDCCSPE8wSWpDZKROM1jzz24aAELvcRiqVhv70PDwLiCsaoe9A+FrPLKago4MnQFqLg2XBqFYMNaI+Y2Nq0ZeYNlHRhmfX3ZbWK076RQltQplBHabVJKZdexxl0HfGHmZrWozCt+MUGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790932385; c=relaxed/simple;
	bh=lNCBneJqEYK2DKHQmC1XpUlCIdAImFht5DkAC/8FGns=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=SAiNGM5iQrooIedP4I4N/+wO4rIWZEmRxarTHrik1+qydgSKN8sC7VDYQHpTZhph+PAdLXOxxigy9VPFZOrYcE9V8myvR7GL6aMcShXv5UU23NvQHtS9QC2f6R3QTuQCPs7F9eTRnwHK4O4I9hmv6TiP76snX3RGUxVdGrrgqFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TutqPk9B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TutqPk9B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD5FE1F00893;
	Fri,  2 Oct 2026 09:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790932384;
	bh=dtUkEO1jzuFBmisqtmD1hrdCbIRsamexw4P8AFRk5N0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TutqPk9BT0xDA8rcnGjkeHAt7YRcYXErdZjn803PfhnaNreHCmbM6VWykZTolwSSC
	 Oxiv4rBEVrkW8xa01pSo4s2syXtcSmTwYJbC8UFtY69QbEPT7wHGX+N3pXLbkunngP
	 co7IlStdHOkRM8JqiQWe5U3q3niKcyowgVBPsRv/CzMw55FlO5Y9hjxkTSm0WEvygr
	 EmqUCuM1IsPajYuX0LgN/lrUMWazXZJVitPJ8j2uU7Yol41NomHcEV9wgag5v9k/iQ
	 7r7GfIdpU/Yhnqrqee+x+kdI0kw/zPA0gUh+5f0OTTVu82PbXRBcLjKFd1gvLxEDwo
	 ZE/J4T6WviRLg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 02/10] RDMA/mana: Create and destroy kernel RC
 QPs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261001182015.1757203-3-kotaranov@linux.microsoft.com>
References: <20261001182015.1757203-1-kotaranov@linux.microsoft.com>
 <20261001182015.1757203-3-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 02 Oct 2026 09:13:03 +0000
Message-Id: <20261002091303.CD5FE1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] mana: integer underflow when querying device max_send_sge bypass=
es IB core limits
--

commit 38c0e6ff844f0113447371575b0813a46aa399ab
Author: Konstantin Taranov <kotaranov@microsoft.com>

RDMA/mana: Create and destroy kernel RC QPs

This commit implements kernel RC QP creation and destruction in the mana
driver. The feature adds support for extended-WQE and power-of-two-SQ queues
requiring support from the underlying hardware.

> diff --git a/drivers/infiniband/hw/mana/main.c b/drivers/infiniband/hw/ma=
na/main.c
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
Is it possible for dev->adapter_caps.max_send_sge_count to be 0 when queried
from the device firmware?

If the device reports 0 for this capability, this unchecked subtraction cou=
ld
wrap around and expose UINT_MAX as the maximum send SGE limit to the IB core
and userspace.

Could this lead to integer overflows in mana_ib_wqe_size() and under-alloca=
ted
DMA queues if a user requests an overly large SGE count based on this infla=
ted
limit, ultimately causing out-of-bounds hardware memory accesses?

>  	props->max_recv_sge =3D dev->adapter_caps.max_recv_sge_count;
>  	props->max_sge_rd =3D dev->adapter_caps.max_recv_sge_count;
>  	props->max_cq =3D dev->adapter_caps.max_cq_count;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001182015.1757=
203-1-kotaranov@linux.microsoft.com?part=3D2
