Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792885702;
	b=PrfpiLCuLB2YhDgbJKbNzGosiRlhmfNm9ECvSZT4wJEMkF67afxBtE0mGNllNlWo9Tp+
	 tRm8bBriDu+Mn0wv5K56eKS1VyRXk1Ut71o2hk2V4vkl6RRXkUZRpTB+zzLOp6aBs6DSt
	 L26XakkVBeIg770iU5RckFH47s2ilSHCskpF/VDAz5IRLCgLDyuRk9PSbOkYDHAdMODxT
	 Oiow2rEwnv3Toaisn0jjJ/ftuyFzP7mfIOBN8o/IbxCBIGjIlWUlIUn6yAmpEfESE+ng1
	 tnILLRMk6wyz/dZ4cvxAC2atJfs7J+InXWaPsTf8h2jSxhTstWvYtEcZmDFb+ImN+WA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792885702;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=N/S5p3ClsDWesXk5Z4KBRIEVgb22vgbzOMvRltxMdN4=;
	b=KJOvRjHvK6S7s/VD8HxnmngYndO51Nwmom0l7FMVdsrQxUiVClxTIWK0GjlDHu7P2wNB
	 /yYPqY2LIYoh5wSAxLkopkfbjUfZvf8TP4WN92XQnY54SieHKQ00MtKFkBh/bkN6STv3B
	 ZIWtAWje8F7ZpOZDQzH4zKxEjLfe3Br6zgfCmem/AI0m7X9KSyLK+INsG2UQs/yDUf+7u
	 K7wmmJeLCmb8UTVAgYAcz+QETuyyOCNcyVWV+AVK2oKcLHd5kbL+6vfGeEjt4QGTa38t2
	 VrVWlMG1fsG9rWKJ9uJztGTbtPyfOv/p4NKGvl8rSJeTwTumHKU2TTNNNHUfeBzSrKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QXfCREPT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC922606A31A;
	Sat, 24 Oct 2026 23:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QXfCREPT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAB3A1F01825;
	Sat, 24 Oct 2026 23:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792885701;
	bh=N/S5p3ClsDWesXk5Z4KBRIEVgb22vgbzOMvRltxMdN4=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=QXfCREPTpDrP3jw+ylhf/HN8fkeyTzPEfNHOwYl/owbbhFHyQDIN8eT+LyNZSs3m6
	 aJJUE2/hkzgf2tVLLulLLDaH0dHJCvXnv72j6cljvW51IHeKj10ZTv5BocMKscNv0z
	 uO7mLONOa6BQH7ig6J3YpBpbLAQE/yOF55MRFEPpOCRqi2xcz8wzmKhZ/cPxITJ9Bt
	 oVvdREkIwqJmiekxSQ61Jcrmy6NuTQ316N28FQKdmURz8z0cCz15nZRrPtYk0O9Iwn
	 gqmQfwxOMwG+kC44HbL/01b6xpzANJ2Xf3lyzbFTANWtR6w9oKkKohg6ohUICv/JWd
	 4xPrIwktozT1g==
Subject: Re: [PATCH net v3 1/4] net/mlx5e: psp: tso: replace only the length
 in checksum seed
From: netdev-bot+sashiko@kernel.org
To: toddfreed@meta.com
Cc: netdev@vger.kernel.org, borisp@nvidia.com, saeedm@nvidia.com,
 leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com, andrew+netdev@lunn.ch,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 daniel.zahka@gmail.com, willemdebruijn.kernel@gmail.com, horms@kernel.org,
 shuah@kernel.org, cratiu@nvidia.com, raeds@nvidia.com, rrameshbabu@nvidia.com,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, bjorn@kernel.org, dtatulea@nvidia.com
Date: Sat, 24 Oct 2026 23:48:19 +0000
Message-ID: <179288569938.3134.7210568419074045775@kernel.org>
In-Reply-To: <20261023234640.1459291-2-toddfreed@meta.com>
References: <20261023234640.1459291-2-toddfreed@meta.com>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] Commit message dependency.

--

net/mlx5e: psp: tso: replace only the length in checksum seed

This patch changes mlx5e_psp_handle_tx_skb() so that, for PSP TSO packets,
it adjusts only the length part of the TCP checksum seed instead of
recomputing the seed from the l3 header addresses. The goal is to avoid
bad checksums when the l3 header daddr is an intermediate hop.

> the length difference is expected by the device. however, the
> difference in addresses is incorrect in cases where the l3 header daddr
> is an intermediate hop (e.g. IPV6_RTHDR). this causes every segment of
> the tso packet to go out with a bad tcp checksum, in this case.

[Severity: Low]
The code change in mlx5e_psp_handle_tx_skb() looks correct. However, is
IPV6_RTHDR the right example for this patch on its own?

At this point in the series, psp_dev_encapsulate() still writes the
nexthdr of the base IPv6 header unconditionally:

net/psp/psp_main.c:psp_dev_encapsulate() {
    ...
	} else {
		ipv6_hdr(skb)->nexthdr = IPPROTO_UDP;
		be16_add_cpu(&ipv6_hdr(skb)->payload_len, PSP_ENCAP_HLEN);
	}
    ...
}

With a routing header present, this overwrites NEXTHDR_ROUTING in the base
header, while the UDP+PSP headers go in after the routing header. That
means the packet is already malformed before the TCP checksum seed
matters. So this patch alone doesn't appear to fix the IPv6 RTHDR case.

The IPv6 case seems to be fixed later in the series by "psp: support ipv6
extension headers in psp_dev_encapsulate()", which has its own Fixes: tag.
The only mention of that dependency here is the testing note:

> tested on connectx-7 with the rest of this series applied, with a psp
> tcp socket whose segment routing header's first hop isn't the final
> destination, and the peer checking tcp checksums in software.

The case this patch fixes by itself looks like IPv4 source routing
(IP_OPTIONS with SRR/LSRR). There, ip_hdr(skb)->daddr is the first hop,
but tcp_v4_send_check() seeded the checksum with inet->inet_daddr.

Could the commit message mention the IPv4 SRR/LSRR case? Could it also
say that the IPv6 RTHDR case depends on the psp_dev_encapsulate() patch?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261023234640.1459291-1-toddfreed%40meta.com
