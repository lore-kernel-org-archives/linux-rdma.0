Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795645181;
	b=vEedjHGbBkewno9oIkxtCinV8GavAoa8aTGa0Rg32DDWfocTANvWMDN4xbjzxh40rcOG
	 4ufKvLMXWv1aSE+c0yj3NS4sLwdLdjoH30bIEmBwSfdkNHYYudojr3QMC7cuFMlLxOhXu
	 U+RrF0R2brvFz0DnXm78ozk4M4TgINfecZlbdegq4JCqZvac0y+MDcrNTZG/v7ahzDBI0
	 ZMZRsq2dG1lU5DkLU4RUR2fylI+gWzeOi7V19uCvHW5Glo5PvpzPQfWRCY3ANN2a927Xn
	 grZHrbenTudeziLaVY8noFfmRA2zrMcGdTD+tydL40u+bJEV0qUx85YxzqSPJs4QM8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795645181;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=sZp4LycKK/CTCz9//GVr/ley7FRAUQuSGC++d0eGt8g=;
	b=XHAkkbSixX/PDlYVWHv+AGt8F8Rh9irvmIAevclyXMUCqhhoaIGv3tLOE+kJFdgo3ZWu
	 93RM8shyZgRIXdJDF2D/wkBIJWE23uQ+fjVD+BSASTMTS/aKnrmqXfx6wjUxFkL7oJTwe
	 eJpWG5SgDHuppqf5zrsI7/kaN4O+pNXMMJldr24E/ofp4QD95wEpwsBncljXefxeNFzH+
	 WAwo/v9vqrDXzY3ogb7gm2dRoW6wjym7iaOMUGq1ds5P05n5gRTtWfqojAOw6iyx9dEYf
	 P0GGKD7paQLkrBeqbfJqhWpiTETYBWtRu89bqruT58b3ulncrsdSr1s+LX3Zd6TxlJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V5Ujo6Jp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C6F606A31E;
	Wed, 25 Nov 2026 22:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V5Ujo6Jp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E74CC1F000C6;
	Wed, 25 Nov 2026 22:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795645181;
	bh=sZp4LycKK/CTCz9//GVr/ley7FRAUQuSGC++d0eGt8g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=V5Ujo6JpCwf1rziWgyimiRNaXvBGlRzare9YyhCaRo3oNzjGNLrIBseTyAarZbvkP
	 GswbsrYhbEbBJCYe/cBNbiWDQrQJxN+wcdd+v/QgeDPGuY4eWi3Ke2H9EzB0h76jOK
	 4lFwcFkaGDX4JpNyGUJ4ckW8MatIVs3luJ5JA6/Pk506TGSfuOT28D3h5x0smRBj+H
	 EJW+V7vIotOvUhBPloHKxV+Q9+eqeTC2NMcSrrhJM/IHBev/XdRVQ3EF91HeXvz7b/
	 LnoH8NIUoWKykVaSsOd0ZAd7O77gS0w35E5LFRRxxEClsyfrXO5vraPipmwFqSHuvY
	 dYKWf+oJG85Kg==
Message-ID: <sashiko-outbox-234240@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v3 05/12] net: add METADATA_PSP dst to carry a
 psp association on an skb
Reply-To: sashiko-reviews@lists.linux.dev
To: "Todd Freed" <toddfreed@meta.com>
Cc: linux-rdma@vger.kernel.org, bpf@vger.kernel.org
In-Reply-To: <20261124221758.3230929-6-toddfreed@meta.com>
References: <20261124221758.3230929-1-toddfreed@meta.com>
 <20261124221758.3230929-6-toddfreed@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 22:19:40 +0000
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
- [Medium] net: skipped sk_validate_xmit_skb() on gso_skb requeue in
  dequeue_skb()
--

commit 8a561ec981f5fecca95918e822dec6211fad4e8e
Author: Todd Freed <toddfreed@meta.com>

net: add METADATA_PSP dst to carry a psp association on an skb

This commit adds a METADATA_PSP metadata_dst type to carry a PSP
association on socket-less skbs and validates it in __dev_queue_xmit()
and sk_validate_xmit_skb().

> diff --git a/net/core/dev.c b/net/core/dev.c
> index a44b314f387bb..2b1a2736ab3f9 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
[ ... ]
> @@ -4156,13 +4162,32 @@ static struct sk_buff *sk_validate_xmit_skb(struc=
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
> +		if (psp_md_needed_on() && skb_psp_md(skb)) {
> +			kfree_skb_reason(skb, SKB_DROP_REASON_PSP_OUTPUT);
> +			skb =3D NULL;
> +		} else {
> +			skb =3D sk_validate(sk, dev, skb);
> +		}
> +	} else if (psp_md_needed_on() && skb_psp_md(skb)) {
> +		int psp =3D psp_xmit_md(skb, dev);
> +
> +		if (psp <=3D 0) {
> +			kfree_skb_reason(skb, psp =3D=3D -EMSGSIZE ?
> +					 SKB_DROP_REASON_PKT_TOO_BIG :
> +					 SKB_DROP_REASON_PSP_OUTPUT);
> +			skb =3D NULL;
> +		}

[Severity: Medium]
Can a packet carrying a METADATA_PSP dst bypass sk_validate_xmit_skb() if
it is requeued onto q->gso_skb after initial validation?

When sch_direct_xmit() validates an skb via validate_xmit_skb_list() and
then finds the TX queue stopped or busy, dev_requeue_skb() parks the skb
on q->gso_skb.  When dequeue_skb() later pops it from q->gso_skb, it
skips re-validation unless xfrm_offload(skb) is set:

net/sched/sch_generic.c:dequeue_skb() {
    ...
		/* skb in gso_skb were already validated */
		*validate =3D false;
		if (xfrm_offload(skb))
			*validate =3D true;
    ...
}

If psp_dev_unregister() runs while the skb is parked in q->gso_skb (or
skb->sk gains its own encryption offload), the subsequent
sch_direct_xmit() call skips validate_xmit_skb_list() and hands the skb
directly to ndo_start_xmit(), where the driver (such as
mlx5e_psp_set_state()) retrieves pas via psp_skb_get_assoc_rcu() and reads
a destroyed hardware encryption key ID from pas->drv_data.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124221758.3230=
929-1-toddfreed@meta.com?part=3D5
