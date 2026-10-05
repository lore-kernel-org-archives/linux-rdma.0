Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B3C34EBAC6
	for <linux-rdma@vger.kernel.org>; Mon,  5 Oct 2026 17:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791220609; cv=none; b=CyQZBJfUjFzLjVeMEzKpCK2NRTyooWHhBImYS9FI8F9nyhFBy2WDWd46pwANOuZ1vIJkK6ZBwTlXoH5ltv1aI3QyWKMulRL7noRWolpCEnAALT87d3IlOHwPTDMbTv6o0hw7NaZqISAN55kw3qIQLKgNZLf2iAZ3TEcr98t13NU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791220609; c=relaxed/simple;
	bh=VUU/bSSjTG47veC1JMYR0VGb8e5Oy2gfnyZ4WyjCzYc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=EV19FF0S1lPgyRe+71+NZqcPonvHQvhsgMLs03lI27iBvqerQ8nxpeLMPv5r9R3DK6zYnGCBhVwAgVV1fSur8Ffz7kzVW7Ucd+zHnGnADvXJI48lX/XDpy/hX2l5pueslcChAeiGPqhI7lZjpiR61uurczrVDuJw2dPoOh6pRF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OtLbn3Wk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OtLbn3Wk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCCB51F0089B;
	Mon,  5 Oct 2026 17:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791220608;
	bh=9+6NBLzcGqvv+zICMeMZtFZk6N3GHU3RK0SG4cnj8Xw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OtLbn3WkAFZi+Xdc+SraEJ676G4Ep6uG/u5sNiFIbkRaZ91s1DvdkQoPYGkZOGeR2
	 xfzk5foLAvceGD9ThcM//5Ep4SmBFv3MUFDPnVTrCOx7o+QlfGKH2zpOs+d/u5gibL
	 K+jw5TSQ/fnqCzX1plnL8Zrh8qW5jZf1mnxHvf/3ArFUYhkLZiHx7YycJluM4DdUF/
	 kUBeedsWxwYKzAcsWF7x5TXO94ib5KtFUlkPQihyetClEfvj48gik0pT8qYkTKu7cg
	 gKh2owWXvjM2EDMirJ3IsqFhfmfOmj6+wdMz52K56jKy0Gw7picrkvsBBhkOla0ey5
	 sPr3HHDczuzAA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH nf-next v3 2/3] netfilter: flowtable: carry a priority
 into the offload
Reply-To: sashiko-reviews@lists.linux.dev
To: "Julius Bairaktaris" <julius@bairaktaris.de>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261004171636.3545085-3-julius@bairaktaris.de>
References: <20261004171636.3545085-1-julius@bairaktaris.de>
 <20261004171636.3545085-3-julius@bairaktaris.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 05 Oct 2026 17:16:47 +0000
Message-Id: <20261005171647.CCCB51F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] tc: mtk_ppe: silently ignores FLOW_ACTION_PRIORITY for TC flower=
 offload
--

commit a587674714a18a7d90f4418de25fb5ffa3691fa3
Author: Julius Bairaktaris <julius@bairaktaris.de>

netfilter: flowtable: carry a priority into the offload

This commit updates the flowtable to store the skb->priority of the packet
that creates the flow, and emit it as FLOW_ACTION_PRIORITY during offload.
It also updates the airoha and mtk drivers to parse this action in their
shared flowtable and TC flower offload functions.

> diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/ne=
t/ethernet/mediatek/mtk_ppe_offload.c
> index 99b28aaa7cc47..4ee99e8e4a34b 100644
> --- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
> +++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c

[ ... ]

> @@ -378,6 +378,7 @@ mtk_flow_offload_replace(struct mtk_eth *eth, struct =
flow_cls_offload *f,
>  		case FLOW_ACTION_REDIRECT:
>  			odev =3D act->dev;
>  			break;
> +		case FLOW_ACTION_PRIORITY:
>  		case FLOW_ACTION_CSUM:
>  			break;

[Severity: Medium]
Does this silently ignore explicit QoS queuing requests from TC flower?

Because mtk_flow_offload_replace() is shared for both netfilter flowtable
and TC flower offloads, accommodating flowtable packets by returning success
here causes the driver to also accept and silently discard "skbedit priorit=
y"
actions from TC rules.=20

Hardware will silently drop the explicit QoS queuing request instead of
returning -EOPNOTSUPP, causing traffic to use default queues instead of
the requested priority queue without warning the user.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261004171636.3545=
085-1-julius@bairaktaris.de?part=3D2
