Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=51.159.188.251
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794148020;
	b=JgO0471EZIu9ghy2L/BU1sUgHKU5ePZ67ci1dKza+JO1aRabXSaekQAz/wMOdXa/qeEA
	 RBJkkNiFZRcDiZFY8lU9SUlPkiDlIepbgGidvHw0mytIdlww44CTkaygnEH50/rATXKmk
	 ooUdPDLlTX6qP9gNc0NvvL3Nw1ef04bGfu09fCpBdpm89XEqYHqoQSbqRmXyCEJZ/39yH
	 vNQ8GUaBYBORL98YBxOiDiJl9TbZl17vPXb+wLljSzJ965DShCjbrNFgD6HRq+BwqOkY6
	 CEDiZ6xzNMKSGQpcjTDg5phgptHjEoOzETHdL8oVbr3ktRYFYcRbTpE+uBGvOC499IQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794148020;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-AntiAbuse:X-AntiAbuse:X-AntiAbuse:
	 X-AntiAbuse:X-AntiAbuse:X-Get-Message-Sender-Via:
	 X-Authenticated-Sender:X-Source:X-Source-Args:X-Source-Dir;
	bh=N39oyQMHGyGdEichvRyD3SNv75D0ZUdk3sb/6jLok9E=;
	b=00NtL5zow2RAvrbcDjZy8ciSZr6OxeQitwZJ45pj+htYUE58ZopeYtPfcADr1yJPJOcg
	 tTwmeLtn0794TciVEEVN6sxQFgJjNE72G8ayxaj60Oq2prw52EYPRJuV0fYJNUKlSFmbU
	 CQLu2k0aP0xCnd8/KnSs/MRDwdp7OHjPvqWmv86d1p68NrCr6PW14lbqrbtY1WYLh5tQh
	 izOwBmABvt3dP5wQ/eaVJZifCY3hVo0BBy/PEaUMsjRUAwq8j9sYWTZRm3yOsCAPrgnmq
	 uY3UFvbwMd1MumqMJoxq4AdeKZGXTTpfQzysRlSZMbzNHDGWTw5kzv/d0ZBQ/B3Kukg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.cyber.gouv.fr;
	spf=pass smtp.mailfrom=oss.cyber.gouv.fr;
	dkim=pass header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.a=rsa-sha256 header.s=default header.b="W3ApI/hA";
	arc=none smtp.remote-ip=51.159.188.251
Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFAA6606A322;
	Sun,  8 Nov 2026 14:26:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BFAA6606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.a=rsa-sha256 header.s=default header.b=W3ApI/hA
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Sender:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
	bh=N39oyQMHGyGdEichvRyD3SNv75D0ZUdk3sb/6jLok9E=; b=W3ApI/hAmvI/dWRQL2vZZDqKw2
	ZBK2HBDBVPKZKgj/CKJ+zqJp9oNaSiDqixvSGw1znscu5EuSyxA3C81RAw9ESOfHEiEQUCz+VtBok
	MJPBejwEzDBZrxpwVYndl0dmrzddL8ifWwGNuCXGu73secFqeLRheOj4vxu0krOTB1PQfCnEzazJV
	yt2C1gBGzn/ZCLts9xbE7aVW/DwBQaiZrdn2kuUnSePelPhdfCzWpUqd6NkBO6HcZ3+G8fLCyKTkp
	QEd07r2cJUwbUs1ed8rKHal4Og9ZUcK0ateoagL0VsDxZ0HoFrg1ra4IzO/KKxY3tGSrlaC4z3X//
	Nr1VPtqA==;
Received: from [151.115.150.205] (port=49652 helo=gepetto..)
	by pf-012.whm.fr-par.scw.cloud with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.100.1)
	(envelope-from <Jeremy.Jean@oss.cyber.gouv.fr>)
	id 1xQ3rG-00000008IcJ-1H6t;
	Sun, 08 Nov 2026 15:26:58 +0100
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
Subject: [PATCH ipsec v2 2/7] xfrm: esp4: use the current sequence number for the IV
Date: Sun,  8 Nov 2026 14:26:47 +0000
Message-ID: <20261108142652.1330952-3-Jeremy.Jean@oss.cyber.gouv.fr>
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

When a GSO packet is split in software for IPv4 ESP,
validate_xmit_xfrm() calls esp_xmit() for each segment. These
segments have XFRM_GSO_SEGMENT set, but after the split, skb_is_gso()
returns false for each skb, so each call increments xo->seq.low by one
after writing the ESP sequence number.

The low bits are saved in seq before the increment, but esp.seqno is
set afterwards, using the saved low bits and the high bits from
xo->seq.hi.

When encryption is done in software with ESN enabled, the segment at
(H, 0xffffffff) uses (H+1, 0xffffffff) to generate the AES-GCM IV
because xo->seq.hi has already been incremented when the low bits
wrapped. One full 32-bit cycle later, if the packet at
(H+1, 0xffffffff) on the same SA is non-GSO, it generates the same IV.

Move the assignment to esp.seqno before xo->seq is advanced. This
saves H before the wrap increments xo->seq.hi to H+1, so the segment
at (H, 0xffffffff) generates its IV from (H, 0xffffffff).

Fixes: 4b549ccce941 ("xfrm: replay: Fix ESN wrap around for GSO")
Cc: stable@vger.kernel.org
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
---
 net/ipv4/esp4_offload.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index abd77162f5e75..3a0aafe991f47 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -316,6 +316,7 @@ static int esp_xmit(struct xfrm_state *x, struct sk_buff *skb,  netdev_features_
 	}
 
 	seq = xo->seq.low;
+	esp.seqno = cpu_to_be64(seq + ((u64)xo->seq.hi << 32));
 
 	esph = esp.esph;
 	esph->spi = x->id.spi;
@@ -334,8 +335,6 @@ static int esp_xmit(struct xfrm_state *x, struct sk_buff *skb,  netdev_features_
 	if (xo->seq.low < seq)
 		xo->seq.hi++;
 
-	esp.seqno = cpu_to_be64(seq + ((u64)xo->seq.hi << 32));
-
 	if (hw_offload && encap_type == UDP_ENCAP_ESPINUDP) {
 		/* In the XFRM stack, the encapsulation protocol is set to iphdr->protocol by
 		 * setting *skb_mac_header(skb) (see esp_output_udp_encap()) where skb->mac_header
-- 
2.47.3

