Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB88356747
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 12:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792066510; cv=none; b=HPG0E5S2JEueVap3WCF6tMfQmiPb8peLnyKQuur4ZlvozoN8e4CtMQDw6S5bptkh3AXmH7NOJld9x5P7jeg9f6QU6cF39EvaBG5Hb85zfoC1FOD/H7JyVwGjv6mMqEefr2jO0QFpUgxOwKaAHf+EKQ/ReTAU33tjmCjMN4+/DLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792066510; c=relaxed/simple;
	bh=5lCmTcpL9YpQMCvVz8XyNe9afrFp2zrbtcV2zWTLM5w=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=ZBf3V4JKvNK9EsSf/x0fXfFkFEGYb1L4kDV0bRqWRtEVHEi1lLNcgIFCbOtr1CZHi5mQNzQZse+mBQiIwB3Ni/s8APSXDJilEPHhEDJlBGQVsrl5fFRtwmkJeP1koIUhH4iVFYvlU56Z+TOsSx3pUm0nmI8y2NUVQel0RG/ZTew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AKb6D4Zs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AKb6D4Zs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D61721F000C4;
	Thu, 15 Oct 2026 12:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792066509;
	bh=3ScARtzTJKXSFFm+H4VR+qAWtg7Eq+1avkK2z3NGS9Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AKb6D4ZsJYqM0za1OdwVQb1Hh5jTfn8zIgEXeG3bP+C/d6iwhWx3EbZPYRf6ArN7o
	 6MkyvBNAsbIQ6yi5c4nPyrnDuIWOT6YFdkvkR5piQsYbT6EsDlPTQmH5ZxIhQ6zRtk
	 60R+SSJk62WXFyEIP7lb+oAACDZVBHyRlTRft4Bbc99UOgLryIiggoKQMDUThRLN39
	 hIpb0Gqdn5oiOauB7cSnaZRtHYDXBrtlBh5RZQftgvEqclRVY6Iy7tSDvPuEltBHDm
	 Fz+gYi32M2NSAyZpkFbdy+3pQOWH6msCQsi41vdeDyLvK5FAQR/pWpiPFthqpO9wqN
	 QuMwQAeS7c3TQ==
Message-ID: <sashiko-outbox-172788@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 3/3] RDMA/core: Reject LAG selection when
 source MAC lookup fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261015-ib-core-fixes-v1-3-60f6da3ddec3@nvidia.com>
References: <20261015-ib-core-fixes-v1-0-60f6da3ddec3@nvidia.com>
 <20261015-ib-core-fixes-v1-3-60f6da3ddec3@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 12:15:08 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] rdma: KMSAN uninit-value in rdma_build_skb due to partial header=
 init
--

commit fe2a587fde347fe9ebd760de282337658857e55d
Author: Leon Romanovsky <leon@kernel.org>

RDMA/core: Reject LAG selection when source MAC lookup fails

GID deletion can clear the source device association after LAG lookup
retains the bonding master. Ignoring the resulting L2 lookup failure
copies uninitialized source MAC bytes into the synthetic hash packet.
This commit reads the source MAC before allocating the packet and
propagates lookup errors to the caller.

> diff --git a/drivers/infiniband/core/lag.c b/drivers/infiniband/core/lag.c
> index 88aac911e8ee1..651c868aa04e5 100644
> --- a/drivers/infiniband/core/lag.c
> +++ b/drivers/infiniband/core/lag.c
[ ... ]
> @@ -26,7 +31,7 @@ static struct sk_buff *rdma_build_skb(struct net_device=
 *netdev,
> =20
>  	skb =3D alloc_skb(hdr_len, flags);
>  	if (!skb)
> -		return NULL;
> +		return ERR_PTR(-ENOMEM);

[Severity: Medium]
Does this code expose uninitialized kernel memory to flow dissectors?

Since alloc_skb() leaves the data buffer uninitialized, bitfield assignments
performed later in rdma_build_skb():

	if (is_ipv4) {
		skb_push(skb, sizeof(struct iphdr));
		skb_reset_network_header(skb);
		iph =3D ip_hdr(skb);
		iph->frag_off =3D 0;
		iph->version =3D 4;
		iph->protocol =3D IPPROTO_UDP;
		iph->ihl =3D 0x5;

compile down to read-modify-write instructions. These instructions will read
uninitialized adjacent bits (such as the IPv6 priority field in the
corresponding ipv6 branch) which immediately triggers KMSAN uninit-value
warnings.

Furthermore, fields like iph->tos, iph->ttl, and the UDP checksum remain
completely uninitialized. When this SKB is passed to netdev_get_xmit_slave()
and into __skb_flow_dissect(), a BPF flow dissector attached in the network
namespace could read these uninitialized fields, potentially leaking kernel
memory.

> =20
>  	skb->dev =3D netdev;
>  	skb_reserve(skb, hdr_len);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015-ib-core-fi=
xes-v1-0-60f6da3ddec3@nvidia.com?part=3D3
