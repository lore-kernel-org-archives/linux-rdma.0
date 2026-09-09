Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F8A347BD7;
	Wed,  9 Sep 2026 03:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788925973; cv=none; b=ERoFiaT9Gn3+dcz8+aIczo064Uz83WIqLl8J3MWD0y7ysXAoMLF0GPJC11wODIhkQf4bhxtZpJE5+DDlC7BznMx56kJcFeQNyJou8X0BTIpqy+MlupKICDEBkXOKk0+AWTpQqvua+QaUa5riwA8Y6ccURkjHQNfMsf81aiJSKTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788925973; c=relaxed/simple;
	bh=byhC4sg4MHFJMripgUFdlONRJbi/MIECz5cJ2sN1vG8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=gJHUP561bsQ1ScfSieNqUenzSYzv7zrcXYQxVcWTtGPDY7v7ve3gGImKEEShRfv4x9GiHMybnYg6nezuvIse+kGeMkGa+C5UV5MuoIr4zXgNM2GgmOJWcBC8Em/L4Q4ofCfm02xRn2QkcTs9oWPu54Mx+7OdB8E7iILZ0obWi3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JZA0Qd1w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JZA0Qd1w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 364341F00A3A;
	Wed,  9 Sep 2026 03:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788925970;
	bh=1Jo61QNxye4Er9/ZDQxIZV0O+zdhLitbgj7CvKDtDi0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JZA0Qd1wzXdyse4Rc4Hy5dc5uxyTGEVe89QjjaM8rXiFyn3bN0aJoaeJpIJfvMmf1
	 xgLc84ZVzjOUQg5FCgkf/gLWQsFrHQ10MLUfw5gHayQi/A8eW7XtZFFOI9kzz9IEsz
	 nmcgHdhc/QHM3D31Gt4O3f/8I7jjFIjQDfz2+uGAi521KCN/1YdoYDS6DNFcUiLR/p
	 htANSMsbQVsFYcbLGtj5TTsa6NKEC3c9TWGPwwk0W2WThZviU8lfWqO9jpueccI1A5
	 tpvDx/gvrTCxGufe3MvAtD4KklJ5NH72iDMN8GrBuIIp4zQ8/mabmZ9P7lrAWv3U3o
	 tDLiGX3T8jvgA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v5 3/4] net: mana: support concurrent HWC
 requests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Long Li" <longli@microsoft.com>
Cc: linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org
In-Reply-To: <20260908035201.402424-4-longli@microsoft.com>
References: <20260908035201.402424-1-longli@microsoft.com>
 <20260908035201.402424-4-longli@microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 03:52:49 +0000
Message-Id: <20260909035250.364341F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Preexisting use-after-free of `hwc_cq->comp_buf` during HWC CQ des=
truction due to a race with the interrupt handler.
--

commit a87caaea6f635bdcf7c331ad2a7a65f2ff025635
Author: Long Li <longli@microsoft.com>
Subject: net: mana: support concurrent HWC requests

This commit serializes SQ posting and protects HWC lookup and sender accoun=
ting
with hwc_lock. Teardown now stops admission, force-completes requests, and
drains senders before destroying the CQ, TXQ, and RXQ.

> diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/n=
et/ethernet/microsoft/mana/hw_channel.c
> index 6605e7a9c481b..a4f7346d285f7 100644
> --- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> +++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
[ ... ]
> @@ -864,14 +974,28 @@ void mana_hwc_destroy_channel(struct gdma_context *=
gc)
>  	}
>  	gc->max_num_cqs =3D 0;
> =20
> +	/* Deregister the HWC EQ before freeing the work queues. */
> +	if (hwc->cq)
> +		mana_hwc_destroy_cq(hwc->gdma_dev->gdma_context, hwc->cq);
> +

[Severity: High]
This is a pre-existing issue, but since this patch moves the call to
mana_hwc_destroy_cq(), is it worth fixing a use-after-free bug in that
function's teardown path?

In mana_hwc_destroy_cq(), hwc_cq->comp_buf is freed before the EQ is
destroyed:

mana_hwc_destroy_cq() {
	kfree(hwc_cq->comp_buf);

	if (hwc_cq->gdma_cq)
		mana_gd_destroy_queue(gc, hwc_cq->gdma_cq);

	if (hwc_cq->gdma_eq)
		mana_gd_destroy_queue(gc, hwc_cq->gdma_eq);
	...
}

Because mana_gd_destroy_queue() on the EQ is what performs synchronize_rcu()
to wait for concurrent interrupt handlers to finish, a racing interrupt
handler on another CPU could still execute mana_hwc_comp_event() after the
buffer is freed:

mana_hwc_comp_event() {
	...
	completions =3D hwc_cq->comp_buf;
	comp_read =3D mana_gd_poll_cq(q_self, completions, hwc_cq->queue_depth);
	...
}

Could this lead to a use-after-free and memory corruption when
mana_gd_poll_cq() writes hardware completion events into the freed
completions buffer?

>  	if (hwc->txq)
>  		mana_hwc_destroy_wq(hwc, hwc->txq);
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908035201.4024=
24-1-longli@microsoft.com?part=3D3
