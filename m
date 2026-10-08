Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90FAA4EFFCB
	for <linux-rdma@vger.kernel.org>; Thu,  8 Oct 2026 18:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791483422; cv=none; b=qjhv8aSkqVPoRLFSupJmkX7aLmRINnhsw9ry/NkZSJOt/WOdxBa9M0LaxozpqKbPMlRN3MXCHEt28FJCIUKNCNqst6he/KjdFhFyXfZIzsXUloE9aLX62w7jNaIt3pkBUr1BEA6YPsR1C7sY+71n0tFANkoGfjHsEAiwTk2dMoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791483422; c=relaxed/simple;
	bh=Uf3OPM5UrIF+Fnb66JVHdzxg5i44mq/8ixlHeHME670=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=aeiHIaC/1rSDn9xto5aOrrkY0BP1r1BvrQ+zljwmFzcArJ8EbSCzWopPORNrWmtsTudExajHIeNzaGIBqdPoX2xg6yUcgnWGYZGOKOmd9lklbNkqBc0Z/CH2pQj5cVryc/vadVNQaEIxvd3NMGrauS7iPd3l9DvkanhAcYZznHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ukvs7Slp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ukvs7Slp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FE991F000FF;
	Thu,  8 Oct 2026 18:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791483421;
	bh=CHwS+u36SNW7geX74e8e6wix0qei4qt+RPnUFFfW2PY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ukvs7Slpruk5T3whfx6wyBuVRNsutjfcxktg56Ixcp9XFECad9pL2C0O11tiLZjea
	 t9LsiUnes/JQa+M+ozqsiuPR9k00tEoVdhJMSqaAMFJJX+ZZmZeeUJEQ5mLV5Zdh6o
	 BGDoP2kiiYey0WgylIkWKlW5yGn1otEiAd02M7tZmS47rMeyycvqMf6MhUbenGDSGP
	 aaMvKc8kkQJLkkNjatvLKu8IMLm9ZtiaQnODqzwBQhfuXaF53qLzTkf8JXlTuUfBfZ
	 +39vMhRyPB1qqVgeHZOJgodIFoH02qJeqlgKUM8GJZ4eg1aMRXhvR/7AUIxMFkEDje
	 p03ku7iTH1g4Q==
Message-ID: <sashiko-outbox-164450@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 3/9] net: niu: check for failure when pulling
 in the RX header
Reply-To: sashiko-reviews@lists.linux.dev
To: "Josef Bacik" <josef@toxicpanda.com>
Cc: linux-rdma@vger.kernel.org, intel-wired-lan@lists.osuosl.org
In-Reply-To: <20261007-b4-pskb-pull-tail-drivers-v1-3-9512b0fb977b@toxicpanda.com>
References: <20261007-b4-pskb-pull-tail-drivers-v1-0-9512b0fb977b@toxicpanda.com>
 <20261007-b4-pskb-pull-tail-drivers-v1-3-9512b0fb977b@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 18:17:00 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] net: torn read on 64-bit statistic rp->rx_dropped without u64_st=
ats_sync
--

commit c489740632704e1a68308e50d5ffe53ae3415f3f
Author: Josef Bacik <josef@toxicpanda.com>

net: niu: check for failure when pulling in the RX header

This patch updates niu_process_rx_pkt() to use pskb_may_pull() to ensure
there is enough room in the SKB head for the hardware RX and Ethernet
headers. If the pull fails, the packet is now dropped instead of relying
on the buffer's initial state.

> diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/ni=
u.c
> index c74a97fe54641..d1c0e868004d1 100644
> --- a/drivers/net/ethernet/sun/niu.c
> +++ b/drivers/net/ethernet/sun/niu.c
> @@ -3488,7 +3488,11 @@ static int niu_process_rx_pkt(struct napi_struct *=
napi, struct niu *np,
> =20
>  	len +=3D sizeof(*rh);
>  	len =3D min_t(int, len, sizeof(*rh) + VLAN_ETH_HLEN);
> -	__pskb_pull_tail(skb, len);
> +	if (unlikely(!pskb_may_pull(skb, len))) {
> +		rp->rx_dropped++;

[Severity: Medium]
Could this 64-bit counter update cause a torn read on 32-bit architectures?

Looking at struct rx_ring_info, rx_dropped is declared as a u64. Without
wrapping the increment in u64_stats_update_begin() and=20
u64_stats_update_end(), a concurrent reader might fetch half of an old value
and half of a new value during ndo_get_stats64.

> +		kfree_skb(skb);
> +		return num_rcr;
> +	}
> =20
>  	rh =3D (struct rx_pkt_hdr1 *) skb->data;
>  	if (np->dev->features & NETIF_F_RXHASH)

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007-b4-pskb-pu=
ll-tail-drivers-v1-0-9512b0fb977b@toxicpanda.com?part=3D3
