Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=51.159.188.251
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794148020;
	b=oLtjiEQRTrkS4x+j0fDQUHJQ8OFlaDRDuIbEeTw7ooiwHpXLzHAKITsNGrnPJBMxQP4v
	 Z/IkP5U+bYtm2dHaHluNylzIhzeaVTvzXgTcarsr3Hlg2T0RHg2cNQq5uTBku7vHaTp//
	 c+sXX2yLrt61fa3G1jrihgnWW5X+yb9LU6bEm7+b1LyqRDP7RL2KdqqKPPcwgG1LEsWgX
	 FQHO7MIzUgGFymYTO4yYxkyp236SRJVxvQcKe08VTQQN/mqVRWmCUqRlhEsa30Dh4xOaR
	 /yaOZOgy4l9K2pGaONiJuqHc6MSZmXFUQcdMpevMXWOiGRkHKarw0qQjNJhdHR/69JQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794148020;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-AntiAbuse:X-AntiAbuse:X-AntiAbuse:
	 X-AntiAbuse:X-AntiAbuse:X-Get-Message-Sender-Via:
	 X-Authenticated-Sender:X-Source:X-Source-Args:X-Source-Dir;
	bh=kjJYkaCTSkj+Q9j29XrgaqO0snlZlTe+53ruZ6OzUM8=;
	b=aj3cRcbYU3eq+HThcURcdZqh72KdTtkALxua7tBk5Kgj3m+Sfq6LK64QVYCloo9xiRrS
	 J3mWZT1Hq55aoOzFzSG3t7cLk1VW5fsAdrDHC+6alhsypXmAOQspE8LBHmETZBWnhetJr
	 nFISPhqqnu7+GYU5kZp3Q6NTn4QBZyeJe6wcvPpdB15doQw8YZEyJtY86r99uvlovLeRT
	 ezgeMppyz1XlE08OqSnHZV8uZK6ngUpHOfKnXaeluWA5YmGc8WmgEViKhUAz299SoD3nd
	 iVV+gblNXI6efBzOSN+tcg0xGz+Mk/FPSZHFgYlS7x71Z0A3d8jX4Helt4gkZ/gRfhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.cyber.gouv.fr;
	spf=pass smtp.mailfrom=oss.cyber.gouv.fr;
	dkim=pass header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.a=rsa-sha256 header.s=default header.b="Z6FlUQQ/";
	arc=none smtp.remote-ip=51.159.188.251
Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 394A3606A320;
	Sun,  8 Nov 2026 14:26:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 394A3606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.a=rsa-sha256 header.s=default header.b=Z6FlUQQ/
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Sender:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
	bh=kjJYkaCTSkj+Q9j29XrgaqO0snlZlTe+53ruZ6OzUM8=; b=Z6FlUQQ/+pORntqkaH3qI8P2O0
	6SND5R6hgEG7pxR+Imqs0sJSaWaPekuQTOAYhyztPn4Q1aMxAJimKsFDq9KwtXXjWr1hV2lo0ac5c
	CjUfKzENFrL5gYb3f/WpTW+X9HFHX7srKKaMEDU7tG7HXKLRd8Wx0L/+eo6eZLb/Ky4+TcRl8wkAK
	1RLFO/pX7pq2Es4zV/tdGDsOQUNlLwWSyYk9k6nUr4jH/WUO1N6/qY/iy7msyDgQqtasckMafSkdE
	FD671AKu/2Xsn71MGmjhdl9kGVijJ4/E5kPhY+zQjiTA3DAIa+PI7pgWOA8Yc8sueA7g9XPyTA5Kl
	TAZrIUTA==;
Received: from [151.115.150.205] (port=49652 helo=gepetto..)
	by pf-012.whm.fr-par.scw.cloud with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.100.1)
	(envelope-from <Jeremy.Jean@oss.cyber.gouv.fr>)
	id 1xQ3rF-00000008IcJ-2sdE;
	Sun, 08 Nov 2026 15:26:57 +0100
From: =?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
To: Steffen Klassert <steffen.klassert@secunet.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sabrina Dubroca <sd@queasysnail.net>
Cc: "David S. Miller" <davem@davemloft.net>,
	Boris Pismenny <borisp@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	stable@vger.kernel.org
Subject: [PATCH ipsec v2 1/7] xfrm: esp6: use the current sequence number for the IV
Date: Sun,  8 Nov 2026 14:26:46 +0000
Message-ID: <20261108142652.1330952-2-Jeremy.Jean@oss.cyber.gouv.fr>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261108142652.1330952-1-Jeremy.Jean@oss.cyber.gouv.fr>
References: <20261108142652.1330952-1-Jeremy.Jean@oss.cyber.gouv.fr>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - pf-012.whm.fr-par.scw.cloud
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - oss.cyber.gouv.fr
X-Get-Message-Sender-Via: pf-012.whm.fr-par.scw.cloud: authenticated_id: jeremy.jean@oss.cyber.gouv.fr
X-Authenticated-Sender: pf-012.whm.fr-par.scw.cloud: jeremy.jean@oss.cyber.gouv.fr
X-Source: 
X-Source-Args: 
X-Source-Dir: 

When a GSO packet is split in software for IPv6 ESP,
validate_xmit_xfrm() calls esp6_xmit() for each segment. These
segments have XFRM_GSO_SEGMENT set, but after the split, skb_is_gso()
returns false for each skb, so each call increments xo->seq.low by one
after writing the ESP sequence number.

When encryption is done in software, the AES-GCM IV is generated from
the incremented value: if the last segment has sequence number 100, it
uses 101 to generate its IV. A bug arises when the next ordinary
packet is processed: it also goes through esp6_xmit() with sequence
number 101, but since it does not have XFRM_GSO_SEGMENT, no increment
happens and the same IV is reused.

Save the full sequence number before incrementing xo->seq, and use
that value to generate the IV.

Fixes: 3dca3f38cfb8 ("xfrm: Separate ESP handling from segmentation for GRO packets.")
Cc: stable@vger.kernel.org
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
---
 net/ipv6/esp6_offload.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index 22895521a57d0..05d13cce22e47 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -346,6 +346,7 @@ static int esp6_xmit(struct xfrm_state *x, struct sk_buff *skb,  netdev_features
 	}
 
 	seq = xo->seq.low;
+	esp.seqno = cpu_to_be64(seq + ((u64)xo->seq.hi << 32));
 
 	esp.esph = ip_esp_hdr(skb);
 	esp.esph->spi = x->id.spi;
@@ -364,8 +365,6 @@ static int esp6_xmit(struct xfrm_state *x, struct sk_buff *skb,  netdev_features
 	if (xo->seq.low < seq)
 		xo->seq.hi++;
 
-	esp.seqno = cpu_to_be64(xo->seq.low + ((u64)xo->seq.hi << 32));
-
 	len = skb->len - sizeof(struct ipv6hdr);
 	if (len > IPV6_MAXPLEN)
 		len = 0;
-- 
2.47.3

