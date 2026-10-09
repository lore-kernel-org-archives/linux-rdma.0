Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D57A3C584F
	for <linux-rdma@vger.kernel.org>; Fri,  9 Oct 2026 21:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791579839; cv=none; b=q0GO4sOzH3/qQcaeDzMAle0YXCspIKzuIRck1zNUG+dzBrCSNn+Uoio9caE3YUi4JmJJvOhLbqJEyN3TMrsyBLQkRS90Y4kvTQUh/kV+Gj0PGCrhjzuYZ1nl2n4QyVcxmB0E5eQM+/2xrQK1AHR195BC5PteXdhviv3qLb4AWG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791579839; c=relaxed/simple;
	bh=mQoN+H5XAiO/EahzTHKHuONMVrtu8+lX49CwMpH9b0s=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=EO2AMxR9mr2oujrO222hZzh5uLcb++zFMEocdrs2bB8al3cazno6Te2MIHFqETYhoodalOAIZtWFR+8E3BEKbcNdC+bHXVKBJjoc92Y8lfkfke+jlnhStjS9vV9SjGaN1efDF8Hb2tEZvpt81ZBhnr8fTUROnfjikHYeSf9up/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oWeRs6ig; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oWeRs6ig"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 118C31F000FF;
	Fri,  9 Oct 2026 21:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791579838;
	bh=HbOV/Z5pLiDjPPUOUEyFt80mPqyKA2kHXAVR/LIjCD0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oWeRs6igzYXkAciQ7GoVth6K6wPG3OmdhT95lyZBvlyrO7kKjMB8L54+JmvtJw7gL
	 nTcXE2fpRqu9/lF306F+gA7hF4i3l6xAPydumT52Iu7Mc6iq4e1giGLEJpkcUsqsWU
	 tVETzmnMCgzNehF/g/4HoGIEbjGWbMZ89b5IpAIyfFIXM2FuFUXzeQFGg7FDhzw+DN
	 u8rTvjMrwUi1Hfc9uXeS4mORX1sQSifHvh0O7loLoZ4MiyYD+2eweJdhsNCr812b3K
	 x0RDXWk5RIAn+qII49bg+DkgIjutCKMTDZ0nDgygRre0shNqIaiuYdtxdem041ia0k
	 /Oe+eqH+iJ0UA==
Message-ID: <sashiko-outbox-166070@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 05/10] xen/netfront: check for failure when
 pulling in xennet_fill_frags()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Josef Bacik" <josef@toxicpanda.com>
Cc: linux-rdma@vger.kernel.org, intel-wired-lan@lists.osuosl.org
In-Reply-To: <20261008-b4-pskb-pull-tail-drivers-v2-5-8f2bd9bee138@toxicpanda.com>
References: <20261008-b4-pskb-pull-tail-drivers-v2-0-8f2bd9bee138@toxicpanda.com>
 <20261008-b4-pskb-pull-tail-drivers-v2-5-8f2bd9bee138@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 21:03:57 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] netfront: memory leak of head skb in xennet_poll() when xennet_f=
ill_frags() fails
--

commit f1df1b5218b129f50d5ffc52995e379ca9e3fc59
Author: Josef Bacik <josef@toxicpanda.com>

xen/netfront: check for failure when pulling in xennet_fill_frags()

When the skb already has MAX_SKB_FRAGS frags, xennet_fill_frags() calls
__pskb_pull_tail() to free up a frag slot.  That frees slots in two
ways: it pulls the start of the packet into the head, and it releases
empty frags, even when there's nothing left to pull.

Use pskb_may_pull() followed by skb_drop_empty_frags(), and take the
error path explicitly if either fails.  pskb_may_pull() does nothing if
the head already holds pull_to bytes, so the BUG_ON() for pull_to <
skb_headlen(skb), which protected the subtraction, can go.

> diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
> index 2ed673649c488..007fa3bbc9e66 100644
> --- a/drivers/net/xen-netfront.c
> +++ b/drivers/net/xen-netfront.c
> @@ -1174,18 +1174,15 @@ static int xennet_fill_frags(struct netfront_queu=
e *queue,
> =20
>  		RING_COPY_RESPONSE(&queue->rx, ++cons, &rx);
> =20
> -		if (skb_shinfo(skb)->nr_frags =3D=3D MAX_SKB_FRAGS) {
> -			unsigned int pull_to =3D NETFRONT_SKB_CB(skb)->pull_to;
> -
> -			BUG_ON(pull_to < skb_headlen(skb));
> -			__pskb_pull_tail(skb, pull_to - skb_headlen(skb));
> -		}
> -		if (unlikely(skb_shinfo(skb)->nr_frags >=3D MAX_SKB_FRAGS)) {
> -			xennet_set_rx_rsp_cons(queue,
> -					       ++cons + skb_queue_len(list));
> -			kfree_skb(nskb);
> -			return -ENOENT;
> -		}
> +		/* Out of frag slots: pull the start of the packet into the
> +		 * head and drop empty frags to make room.
> +		 */
> +		if (skb_shinfo(skb)->nr_frags =3D=3D MAX_SKB_FRAGS &&
> +		    unlikely(!pskb_may_pull(skb, NETFRONT_SKB_CB(skb)->pull_to) ||
> +			     skb_drop_empty_frags(skb, GFP_ATOMIC)))
> +			goto err;
> +		if (unlikely(skb_shinfo(skb)->nr_frags >=3D MAX_SKB_FRAGS))
> +			goto err;

[Severity: Medium]
When xennet_fill_frags() returns an error here, the execution jumps to the =
err
label in xennet_poll() where it leaks the head skb:

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

Because the while loop unconditionally overwrites the head skb variable wit=
hout
freeing it or queuing it to errq, does this code permanently leak the head
packet?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008-b4-pskb-pu=
ll-tail-drivers-v2-0-8f2bd9bee138@toxicpanda.com?part=3D5
