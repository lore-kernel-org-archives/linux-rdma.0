Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=51.159.188.251
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794148033;
	b=sgM2IrLxyxDgQcbN3TMkpMGtFqTD6ifbeT2tWGUDFNWBu8ZqzIVhL3aJBvls64SVqcDb
	 /To2dhoc7qmLHVAJEjJ2cab6XLRisC7N7KGLEcfPPYuLTMy2ATx0HfyWJOhYLH89Ft6/0
	 G9CaU+FjKkZl0ZSRs45z+/fTLh54iothP6wOuNmAdlwzWZvydexeT6oGiy9d1BQCtTeFw
	 5skpUEi/iyiCZZViMKXh+ovNAjrSTD19kqxTXXmRhJ04A1l2tr8/kWGZxorz+2GfW1dum
	 tqrOsdyD3NO/wRIgkWonbIl0g2wgIDRl54C30fugR8vXrusZwUY1vqml914VFcicurg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794148033;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-AntiAbuse:X-AntiAbuse:X-AntiAbuse:
	 X-AntiAbuse:X-AntiAbuse:X-Get-Message-Sender-Via:
	 X-Authenticated-Sender:X-Source:X-Source-Args:X-Source-Dir;
	bh=rkYS/CEtmuPr5G4354NxU68uWYFEiDlmwZzOtfMp6Z4=;
	b=ZBtfHFPDzLT2exbE7L7zmPQMx+kqEP0y3LgOlWyYVe1GuW+BYoAhDzDQaJ3+KUKX0DM4
	 Rt53G0mToSNQ3iZoCvRSTqX1QZl3k/Li0JpmHaJx87Y02N0AZ8qIaGDvdtUpp/Qspgu0q
	 iLyldLyQ+rWSBWjUEv8NR0FwRBs2pbD0ghmsXKEJsuycHgVzCu+aA0scbjt+JAyeEArN3
	 QeJ/HzCdVM/SvsO/JYlQycMksy4Phuj7WDAUAJhiGxp7cvavYTvBW+YONfRX5wtMHTZjh
	 l1mQLA8y7fBUUC/3b0FE8VqmqnrYLaMkAffxsPGkYj/GRAmx671MkfG7IsNaEJo7EEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.cyber.gouv.fr;
	spf=pass smtp.mailfrom=oss.cyber.gouv.fr;
	dkim=pass header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.a=rsa-sha256 header.s=default header.b=MwWpvquV;
	arc=none smtp.remote-ip=51.159.188.251
Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A66606D832;
	Sun,  8 Nov 2026 14:27:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 69A66606D832
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.a=rsa-sha256 header.s=default header.b=MwWpvquV
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Sender:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
	bh=rkYS/CEtmuPr5G4354NxU68uWYFEiDlmwZzOtfMp6Z4=; b=MwWpvquV6KKbx8ACObdGBsJZ/I
	+vu/W6RO7//F3daN+lYbq3q6uJE6DsjBsqYq/+6F75u3Avuogrvx1SNDdU7obCvV/Yqidr0V5Hexe
	0yUeYIEsWuqllIBFxSLaB0MmKZ/DI9K14m8/nb6WVZnkaCReXqP4ysE/zJR0zDVL1QN+llP2Yk483
	0eAnTVxkNkmRfwbKuG6W0UjIwAtJIqa1Ix8NBWRu/k3lnaGlsvQNL6Fz4sXgcKi8LV7OFTtWAi6qy
	7ElmxWgCtrIjMrBF2xtK/V98fmvfLVpvZU1If9ywXveJGTyuWs4ygOdtyxU5AMXUPr99Yg3EqmFIF
	CyHHtTnw==;
Received: from [151.115.150.205] (port=49652 helo=gepetto..)
	by pf-012.whm.fr-par.scw.cloud with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.100.1)
	(envelope-from <Jeremy.Jean@oss.cyber.gouv.fr>)
	id 1xQ3rI-00000008IcJ-37Ao;
	Sun, 08 Nov 2026 15:27:00 +0100
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
Subject: [PATCH ipsec v2 6/7] xfrm: segment untrusted GSO packets before sequence allocation
Date: Sun,  8 Nov 2026 14:26:51 +0000
Message-ID: <20261108142652.1330952-7-Jeremy.Jean@oss.cyber.gouv.fr>
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

Packets received through TUN or virtio-net can have gso_segs == 0,
with SKB_GSO_DODGY set until the segmentation metadata is checked.
When ESP defers segmentation, gso_segs is still zero, so the SA
sequence counter is not advanced. The segments receive sequence
numbers starting at oseq + 1, which subsequent packets can reuse,
causing AES-GCM nonce reuse.

This affects IPv4 and IPv6, with or without ESN, when the ESP offload
type is registered. Hardware encryption is not required.

Segment SKB_GSO_DODGY packets in xfrm_output() before allocating
sequence numbers, so each segment gets its own number. Set the ESP
encapsulation flag in xfrm_output_one(), after early segmentation, so
UFO fragment offsets and flags are filled in correctly.

Fixes: d7dbefc45cf5 ("xfrm: Add xfrm_replay_overflow functions for offloading")
Cc: stable@vger.kernel.org
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
---
 net/xfrm/xfrm_output.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index 99d1b33db52a6..a1fb60971c6bc 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -505,6 +505,9 @@ static int xfrm_output_one(struct sk_buff *skb, int err)
 	if (err <= 0 || x->xso.type == XFRM_DEV_OFFLOAD_PACKET)
 		goto resume;
 
+	if (xfrm_offload(skb))
+		skb->encapsulation = 1;
+
 	do {
 		err = xfrm_skb_check_space(skb);
 		if (err) {
@@ -814,10 +817,10 @@ int xfrm_output(struct sock *sk, struct sk_buff *skb)
 		xfrm_state_hold(x);
 
 		xfrm_get_inner_ipproto(skb, x);
-		skb->encapsulation = 1;
 
 		if (skb_is_gso(skb)) {
-			if (skb->inner_protocol && x->props.mode == XFRM_MODE_TUNNEL)
+			if ((skb_shinfo(skb)->gso_type & SKB_GSO_DODGY) ||
+			    (skb->inner_protocol && x->props.mode == XFRM_MODE_TUNNEL))
 				return xfrm_output_gso(net, sk, skb);
 
 			skb_shinfo(skb)->gso_type |= SKB_GSO_ESP;
-- 
2.47.3

