Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF86A3AEB49
	for <linux-rdma@vger.kernel.org>; Fri,  9 Oct 2026 21:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791579838; cv=none; b=r/zbxu9OqFW4avQTeguYaTInlyT0nV2QZmLlbGNN4iDr9ea7FZcSyISajOy3Jt2pWTWi6tZYI0x87C7zsm4TZjAqbwJMkI9/lU1JvEDe03clpxOmey5kr+1FfBj58Azemuc8PdhhjOmhAVuC781Mv5aCxEWaK2w2Eqn+2bgu21M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791579838; c=relaxed/simple;
	bh=MRvfrxBdNtfjyXAiKp3vABdolufK3CyjzvdL10Pudiw=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=fzQ85Te+jjwPFLinca18MRNgmrtd5HZ0ADE8Bs5vZ0SL/+snt+cLs5Eiy+Fy/tqAM71hwFxrv8WwitA6HUEMi0PFBCsuYCEetZGI2NAvrlk7RwblS54QN9hYlh2hvT4xGKdStXFnR1lbwURYLgWBWVInQ2h4VCa5Le3m/byO7RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kgOOfxIS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kgOOfxIS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 342C31F00893;
	Fri,  9 Oct 2026 21:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791579837;
	bh=tDkbJya0VOTux8zWzYZ+roaaXeRR1oDgP+NpjT0Rpl0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kgOOfxIS6NX3uvcJdD26yfroyQf+tfOjpaeOENVNuo1NVGCV4cFqu1PHxe9ptipme
	 BuzwJNC+AmxJOlwPraJOK9zr5RP77PjDAgwsf+feoeWkxzYS3+NlayrCn7D9ygreoG
	 qMacb2QHQs/iYM53UrcC5+JR1CrFQlteN9YEdRRW2GKgOfBMJ/rasf1UzUlO+5Y46N
	 TBqroLHRbGfhTLx6wpkwuL/AJPT9E9X/tlr4lVd3fprpiYjcWXeDnG2diRRtDG8Jfp
	 hNCXya3jqfyu/C7AcIdMDbRuYvE/pXJKDI5dKVGmpsEwSFSWpMSVsZnaBzYN21TYZk
	 JUy8vpNFIneAA==
Message-ID: <sashiko-outbox-166069@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 04/10] net: niu: check for failure when
 pulling in the RX header
Reply-To: sashiko-reviews@lists.linux.dev
To: "Josef Bacik" <josef@toxicpanda.com>
Cc: intel-wired-lan@lists.osuosl.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261008-b4-pskb-pull-tail-drivers-v2-4-8f2bd9bee138@toxicpanda.com>
References: <20261008-b4-pskb-pull-tail-drivers-v2-0-8f2bd9bee138@toxicpanda.com>
 <20261008-b4-pskb-pull-tail-drivers-v2-4-8f2bd9bee138@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 21:03:56 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] net: niu: BUG() in eth_type_trans due to insufficient pskb_may_pul=
l length
--

commit 19ab5666684c0028709e6a0efad246e9460b1000
Author: Josef Bacik <josef@toxicpanda.com>

net: niu: check for failure when pulling in the RX header

This commit replaces __pskb_pull_tail() with pskb_may_pull() in
niu_process_rx_pkt() and adds error handling. If pulling the header fails,
the packet is dropped instead of crashing.

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

[Severity: High]
Is it possible for a malformed hardware descriptor to provide a small
RCR_ENTRY_L2_LEN, resulting in a BUG_ON assertion in __skb_pull() later
when eth_type_trans() is called?

If the hardware reports an unusually small RCR_ENTRY_L2_LEN (e.g. 4 bytes),
then len evaluates to 12. pskb_may_pull(skb, 12) would only ensure 12 bytes
in the linear area.

Later in this function, skb_pull(skb, sizeof(*rh)) consumes the 8-byte
hardware header, leaving 4 linear bytes. The packet is then passed to
eth_type_trans(), which attempts to pull ETH_HLEN (14) bytes:

drivers/net/ethernet/sun/niu.c:niu_process_rx_pkt() {
    ...
    skb_pull(skb, sizeof(*rh));
    ...
    skb->protocol =3D eth_type_trans(skb, np->dev);
    ...
}

If the total skb->len is greater than 14 due to fragments, __skb_pull()
will execute and subtract 14 from skb->len. This could drop skb->len below
skb->data_len and trigger a BUG_ON(skb->len < skb->data_len) in __skb_pull(=
).

Should pskb_may_pull() ensure at least sizeof(*rh) + ETH_HLEN bytes to
protect the downstream eth_type_trans() call?

> +		rp->rx_dropped++;
> +		kfree_skb(skb);
> +		return num_rcr;
> +	}
> =20
>  	rh =3D (struct rx_pkt_hdr1 *) skb->data;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008-b4-pskb-pu=
ll-tail-drivers-v2-0-8f2bd9bee138@toxicpanda.com?part=3D4
