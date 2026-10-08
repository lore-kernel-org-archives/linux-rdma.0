Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D05F44EFFB0
	for <linux-rdma@vger.kernel.org>; Thu,  8 Oct 2026 18:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791483417; cv=none; b=gAGUnDuB6vIlWXZz8fzJgiOUMxjpJf0aIFPG8e8iRKrtEjGydyif64Lzow5WHk0dwTNmfTzuONZmjUpA+qUeQ+oZpIMgTrUZN3AhdNEggCKyuU6XEWr4wxeRSq/v2ujczvnz4e5w66FzXdaNHu0a2K9fiQDji+MEVi1JHJGvaCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791483417; c=relaxed/simple;
	bh=VrRFJz/WFoqON9rwVImOo7LtlRQgX/J1p5HWZqXm5Tw=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=KJ3h/mWvR7ktZhu8w0marR85KsppNNtplmFObrjGxs4oiCGEiJYLQgDW71NUrcXIXy7IT3/OwpHfcuqhU8fqLOxB0GjAALBaBkvXEmMDKshyq5hKxZzYRr1rY4Vfth+HqYjt8D/EU6p/6jT21S5r4aso5xf1HTSqBlpcEcuvFLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=StkK/jkM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="StkK/jkM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 703321F000FF;
	Thu,  8 Oct 2026 18:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791483415;
	bh=VzoVMQbcXgYaOLQ53frGvWFhNKe6dxLXGK1tt8CobLw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=StkK/jkMTpyb+AzE/tDrSX2x1t6KudlDL2MRlLUbqwB2EHikAw8/0ZsBOmqKIe4Xx
	 yHkctIIZGrQPznJ9maDo1sfsaSIIPws1qzcdnFTRl5H2rTAgUa+ZbOTr4KwmSyx3P3
	 5SI6C0vgRnL8HTvjNLNuGGp8IWxNeV9b3/48YNghWKIlf4NVQ5Ko9AuCBdOD0r3e7D
	 tFeBCt6YdWBRh1zRx2iOabAZ9UTx0lXiz/OiNqGTZblQP34h98f3bXOjAkWk9Hl45u
	 JXtvyACi+Jv6QdQ0R5WeBStpYJ0Lv+0EdJsfMxLAFaoA3o7kQh+dcDihdfHySg4b/e
	 xyugb6I6716zg==
Message-ID: <sashiko-outbox-164442@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 4/9] xen/netfront: check for failure when
 pulling in xennet_fill_frags()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Josef Bacik" <josef@toxicpanda.com>
Cc: linux-rdma@vger.kernel.org, intel-wired-lan@lists.osuosl.org
In-Reply-To: <20261007-b4-pskb-pull-tail-drivers-v1-4-9512b0fb977b@toxicpanda.com>
References: <20261007-b4-pskb-pull-tail-drivers-v1-0-9512b0fb977b@toxicpanda.com>
 <20261007-b4-pskb-pull-tail-drivers-v1-4-9512b0fb977b@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 18:16:54 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] net: xen-netfront: memory leak of head SKB on xennet_fill_frags() =
error path
--

commit 35a098cdf4bebe9adc4115a04a7fd029b02400ea
Author: Josef Bacik <josef@toxicpanda.com>

xen/netfront: check for failure when pulling in xennet_fill_frags()

When the skb already has MAX_SKB_FRAGS frags, xennet_fill_frags() pulls
the start of the packet into the head to try to free up a frag slot. This
commit explicitly uses pskb_may_pull() and takes the error path if it
fails.

> diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
> index 2ed673649c488..6e01a883cc64a 100644
> --- a/drivers/net/xen-netfront.c
> +++ b/drivers/net/xen-netfront.c
[ ... ]
> @@ -1198,6 +1191,11 @@ static int xennet_fill_frags(struct netfront_queue=
 *queue,
>  	xennet_set_rx_rsp_cons(queue, cons);
> =20
>  	return 0;
> +
> +err:
> +	xennet_set_rx_rsp_cons(queue, ++cons + skb_queue_len(list));
> +	kfree_skb(nskb);
> +	return -ENOENT;
>  }

[Severity: High]
Does this code leak the head skb on the error path?

When xennet_fill_frags() returns -ENOENT on failure, the error path handles
cleanup for the individual fragment (nskb) but does not free or requeue the
main head skb.

Back in xennet_poll(), upon failure, it jumps to the err label without
placing the head skb back into tmpq, unlike the xennet_set_skb_gso() failure
path just above it:

drivers/net/xen-netfront.c:xennet_poll() {
    ...
		skb =3D __skb_dequeue(&tmpq);
    ...
		if (unlikely(xennet_fill_frags(queue, skb, &tmpq)))
			goto err;
    ...
err:
			while ((skb =3D __skb_dequeue(&tmpq)))
				__skb_queue_tail(&errq, skb);
    ...
}

This loop overwrites the skb pointer, causing the head skb to be permanently
lost.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007-b4-pskb-pu=
ll-tail-drivers-v1-0-9512b0fb977b@toxicpanda.com?part=3D4
