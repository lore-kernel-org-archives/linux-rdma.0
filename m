Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D612E361964
	for <linux-rdma@vger.kernel.org>; Thu,  8 Oct 2026 18:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791483418; cv=none; b=gWv3WR849YwacbEYlHQ3tK8z2nZAW7lZlPvfC+po9XIG1mAZ0kX0R4AKVnwEDTxxYW2i7kpoKT75BrDuHsfVDclU4gSV/bmjFrHIDPBSb4DzD5vLvkWDh6xPcdr2SxfWTPRiwe/QWcN95m+chqfonH6kcsXVAMbKDaNTmCxdhlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791483418; c=relaxed/simple;
	bh=Eq4Q01dA8a0SKRXagWMXddB6LUYMehntWh85LciiI3I=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=Q/UWYqPTLwV2BPmYCpiXEczXdrLIMunvnzPmb+mhL0VpJ+88xN3yL9U8I2GvQfToEt40CiMqzLd/kGRgeBtbiObllgo0u8+e0jxWpbn1Ozzvd0HU8xK/5XAbiTpFaZZ/hy3N9M+nieqao5swcM7zdvd2Ykawu4gKXNslZDj4xkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mPVbWuYm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mPVbWuYm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 248511F00893;
	Thu,  8 Oct 2026 18:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791483416;
	bh=Tb6aJ+vupNKr/sFx3R6aEtET96erhvok1PfFx51DYxU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mPVbWuYmJRL2K+slUBiKduTOv5I5iVNLmIjVBNJXo4U0emYCguEfYhwhkicxTDva5
	 YaDUxk3XJ4lS8SYt/hRlABkL9bywYj7br4tB9jr6UU9SjQ2kXiWuWmu3gCHO/ZJbjx
	 XLrfD6bVmRPxgxvKs2It4LtNi0TohspIT/+gNJYLtegWa0JEy3933LjXZqVi5b7Tnr
	 00RuCLn0n143KOyuROpAzr0upG4WryW1M4QFRCW03s67cCkP59hKTxzPn+5w4STG0C
	 RvsgLf2PPTEDecVI+G0fzMmk/WMYYlQSlZ9AD4nvmAE6eW5hZqCtQY5vRa/cjLNM/f
	 vaGaQ4O6iEHPQ==
Message-ID: <sashiko-outbox-164443@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 1/9] net: ftmac100: check for failure when
 pulling in the RX header
Reply-To: sashiko-reviews@lists.linux.dev
To: "Josef Bacik" <josef@toxicpanda.com>
Cc: linux-rdma@vger.kernel.org, intel-wired-lan@lists.osuosl.org
In-Reply-To: <20261007-b4-pskb-pull-tail-drivers-v1-1-9512b0fb977b@toxicpanda.com>
References: <20261007-b4-pskb-pull-tail-drivers-v1-0-9512b0fb977b@toxicpanda.com>
 <20261007-b4-pskb-pull-tail-drivers-v1-1-9512b0fb977b@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 18:16:55 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] net: ftmac100: UAF and infinite NAPI loop on rx page allocation fa=
ilure
--

commit 64e4a607347eed7af02ba45920da8e098d9fbc07
Author: Josef Bacik <josef@toxicpanda.com>

net: ftmac100: check for failure when pulling in the RX header

This patch updates ftmac100_rx_packet() to check for failures when pulling
the Ethernet header or linearizing small frames. It drops the frame if
either pskb_may_pull() or __skb_linearize() fails to prevent panics in
__skb_pull().

> diff --git a/drivers/net/ethernet/faraday/ftmac100.c b/drivers/net/ethern=
et/faraday/ftmac100.c
> index 40ba001d4b3fc..a1eb04ead2d8a 100644
> --- a/drivers/net/ethernet/faraday/ftmac100.c
> +++ b/drivers/net/ethernet/faraday/ftmac100.c
> @@ -469,15 +469,21 @@ static bool ftmac100_rx_packet(struct ftmac100 *pri=
v, int *processed)
>  	if (length > 128) {
>  		skb->truesize +=3D PAGE_SIZE;
>  		/* We pull the minimum amount into linear part */
> -		__pskb_pull_tail(skb, ETH_HLEN);
> +		ret =3D pskb_may_pull(skb, ETH_HLEN);
>  	} else {
>  		/* Small frames are copied into linear part to free one page */
> -		__pskb_pull_tail(skb, length);
> +		ret =3D !__skb_linearize(skb);
>  	}
>  	ftmac100_alloc_rx_page(priv, rxdes, GFP_ATOMIC);

[Severity: High]
What happens if ftmac100_alloc_rx_page() fails due to memory pressure?

If alloc_page() fails inside ftmac100_alloc_rx_page(), the function returns
early without calling ftmac100_rxdes_set_dma_own(). Because the error
is ignored here, the descriptor is left owned by the CPU.

When the NAPI loop wraps around, wouldn't ftmac100_rx_locate_first_segment()
return this exact same descriptor, leading to a second dma_unmap_page() and
attaching the already-assigned page to a new skb?

> =20
>  	ftmac100_rx_pointer_advance(priv);
> =20
> +	if (unlikely(!ret)) {
> +		netdev->stats.rx_dropped++;
> +		kfree_skb(skb);
> +		return true;
> +	}

[Severity: High]
Could this early return cause an infinite NAPI polling loop?

If __skb_linearize() fails, this block returns true but skips the
(*processed)++ increment at the end of the function.

If ftmac100_alloc_rx_page() also failed, leaving the descriptor CPU-owned,
wouldn't the NAPI poll loop repeatedly process this same descriptor without
advancing the processed count, completely locking up the CPU?

> +
>  	skb->protocol =3D eth_type_trans(skb, netdev);
> =20
>  	netdev->stats.rx_packets++;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007-b4-pskb-pu=
ll-tail-drivers-v1-0-9512b0fb977b@toxicpanda.com?part=3D1
