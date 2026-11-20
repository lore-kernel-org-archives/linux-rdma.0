Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795138319;
	b=smJdwXu0UD0Ou1dgMEnpmSt2W9/vD1O4PEHpHbOc0kP7od9+flpvUJ4KuLQv00KvM3KC
	 Cljj7zaTJiBcDWaszKcFiP7CAUSB79lja9b+EhdmdRpVqNJOYc6uEFG3G3Y/XR5fGDDg1
	 FtYHzJLKL7oSWZx7E46yz2hNuuuMTpUIgrTfUaASQiNj9vVoJ47wnrEMeinO+Dq7Qdarw
	 tHq2NgWHJbF80MQAf91RAQ5nuEb6nB1IboqrPwZ3eS/mfACsVvyjhTR1V0zFX3vWY49tf
	 xi3agk0jvFzP5XeSvvGAtkofCueViMfYNttb6Yy/rcjuhPs+wNRTIEWwUZ9NejQnSSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795138319;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=i6WG9AgGsDGn6KOADWN7whbFIh0z0XbsT6tl0WOlgDQ=;
	b=JMDa4hYPzFhwowJdWSBPdNivB6Sy8UqZ09fmTjC6l1i+2Jv/J+qbGb8FZTty0PocMEKB
	 BLrCxEBrk9n847M32Ml/wcRKKvV3//NJhhMLlZM9xnuyINwOQWY0a+vy0RiazHWjfLurF
	 jyJPmZzdKtl0KCpprmxdi0hd4eNXob4M2J2bV4VxA1b3OHSJXfFMnnRCXTvh7PDsifZzL
	 AyaWsQIb3AcLZIfujl3Rqp5pKLbUPHApvloMlEWQl/YL4IqgwiRLfjagRb5l2UbkoWWr0
	 ErEJ8Rw5bnLcjyOOPSzFUpgzZgQLFhhxjllTnoQvq+VUCT7MtqdycIwVuBZMS4w4fqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hnRHT84I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF42606A320
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 01:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hnRHT84I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 777771F000C6;
	Fri, 20 Nov 2026 01:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795138318;
	bh=i6WG9AgGsDGn6KOADWN7whbFIh0z0XbsT6tl0WOlgDQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hnRHT84IDoRwiNLV4+tSzir2O12573I8NYYyo8QI5jbN0UeEx2izQShom3cNGDAEu
	 0ZObCdHUCwGB71qXdsCYCoBYLHzDji1yn++SP6qCUIHGg/IBCgaTWJptiG3wAXw2+q
	 QZWA3u49IX6McRFL8uOO4OBfGpKPuIetbM5KJQFvqF1WuFlYo5dDH/XhqUMqt7i8lf
	 2Bmh2CuN/sJyGz5msD2/BrqVTfrsgA4sjLD2MQjWcjfMkyeWRPxpez++LrtGp6asGE
	 TOZUJ0++VoNP8GiNn1eYle70oV4f63Q3IUFDJTlu+/9SBjjyJ8RsoCY8VX78OCSTrw
	 /cRU0JlxEFTtg==
Message-ID: <sashiko-outbox-224312@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 05/12] net: add METADATA_PSP dst to carry a
 psp association on an skb
Reply-To: sashiko-reviews@lists.linux.dev
To: "Todd Freed" <toddfreed@meta.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261119013103.1092559-6-toddfreed@meta.com>
References: <20261119013103.1092559-1-toddfreed@meta.com>
 <20261119013103.1092559-6-toddfreed@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 01:31:58 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] net: sk_validate_xmit_skb() misclassifies non-PSP TCP_TIME_WAIT
  sockets
--

commit 85525961a778a4b7452034bd0372d77e36801869
Author: Todd Freed <toddfreed@meta.com>

net: add METADATA_PSP dst to carry a psp association on an skb

This commit adds a METADATA_PSP metadata_dst type to attach a PSP
association to socket-less skbs and validates it in the transmit path.

> diff --git a/net/core/dev.c b/net/core/dev.c
> index d88af07aea290..920604ab9c02c 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
[ ... ]
> @@ -4155,13 +4161,32 @@ static struct sk_buff *sk_validate_xmit_skb(struc=
t sk_buff *skb,
>  	sk_validate =3D NULL;
>  	if (sk) {
>  		if (sk_fullsock(sk))
> -			sk_validate =3D sk->sk_validate_xmit_skb;
> +			sk_validate =3D READ_ONCE(sk->sk_validate_xmit_skb);
>  		else if (sk_is_inet(sk) && sk->sk_state =3D=3D TCP_TIME_WAIT)
>  			sk_validate =3D inet_twsk(sk)->tw_validate_xmit_skb;
>  	}
> =20
>  	if (sk_validate) {
> -		skb =3D sk_validate(sk, dev, skb);
> +		/* the socket's validator would apply instead of checking the
> +		 * association. A METADATA_PSP dst isn't given to the packets
> +		 * of a socket with its own offload, but the socket can gain
> +		 * one while such a packet is queued.
> +		 */
> +		if (unlikely(skb_psp_md(skb))) {
> +			kfree_skb_reason(skb, SKB_DROP_REASON_PSP_OUTPUT);
> +			skb =3D NULL;
> +		} else {
> +			skb =3D sk_validate(sk, dev, skb);
> +		}
> +	} else if (unlikely(skb_psp_md(skb))) {
> +		int psp =3D psp_xmit_md(skb, dev);
> +
> +		if (psp <=3D 0) {
> +			kfree_skb_reason(skb, psp =3D=3D -EMSGSIZE ?
> +					 SKB_DROP_REASON_PKT_TOO_BIG :
> +					 SKB_DROP_REASON_PSP_OUTPUT);
> +			skb =3D NULL;
> +		}
>  	} else if (unlikely(skb_is_decrypted(skb))) {

[Severity: High]
Does sk_validate_xmit_skb() drop all METADATA_PSP packets sent by a
TCP_TIME_WAIT socket when CONFIG_INET_PSP is enabled?

When any TCP socket enters TCP_TIME_WAIT, inet_twsk_alloc() calls
psp_twsk_init(), which unconditionally sets tw->tw_validate_xmit_skb even
when the socket has no PSP association:

net/psp/psp_sock.c:psp_twsk_init() {
	struct psp_assoc *pas =3D psp_sk_assoc(sk);

	if (pas)
		refcount_inc(&pas->refcnt);
	rcu_assign_pointer(tw->psp_assoc, pas);
	tw->tw_validate_xmit_skb =3D psp_validate_xmit;
}

Timewait ACKs and RSTs attach the inet_timewait_sock to skb->sk via
skb_set_owner_edemux().  Because tw->tw_validate_xmit_skb is non-NULL on
every TCP_TIME_WAIT socket, sk_validate_xmit_skb() takes the if
(sk_validate) branch and drops any timewait packet carrying a METADATA_PSP
dst.

Conversely, if such a timewait packet was marked skb->decrypted =3D 1 and
then lost its METADATA_PSP dst to routing, sk_validate_xmit_skb() calls
psp_validate_xmit() instead of hitting the skb_is_decrypted(skb) drop
branch; since tw->psp_assoc is NULL, psp_skb_get_assoc_rcu() returns NULL
and psp_validate_xmit() lets the packet through in clear text.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119013103.1092=
559-1-toddfreed@meta.com?part=3D5
