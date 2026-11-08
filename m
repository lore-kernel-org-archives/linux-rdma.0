Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=51.159.188.251
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794148021;
	b=pYztqccnujgrb226NBYPMSnCWM77CSfpq7a4DIEFyyrsRGGqkZdNdiM/AgQq2fei73yI
	 jR6I9d4ppl9oCuLuXIVdTHWbwkmCjGbX9Be+woU+jNzCGBlSnipUwG8Wk5LxXGsj55GvF
	 Q7/QBH0EYgod80TqD7RS5TFK3459/zR+FhrszeHXvwBo5lV5PF76gF5L8DxHwoCMfsIei
	 gYFxKBlS00pVIVw7A7USogDrU8YcFjl5fikQyfDCNFlGeqjIbWqVw+NVzt+u48XSPishS
	 mYEMGSjd1A1uyHIBjIqSFJU2VB2LFDLtQ1c34+2BpGUz4OJAXkdjCTVToTc10CWPZ3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794148021;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-AntiAbuse:X-AntiAbuse:X-AntiAbuse:
	 X-AntiAbuse:X-AntiAbuse:X-Get-Message-Sender-Via:
	 X-Authenticated-Sender:X-Source:X-Source-Args:X-Source-Dir;
	bh=3wUqO+seTF1eo5qfGWwpAfyX8WoqptNLIiqIBPEK0rM=;
	b=RiQbcsYj2lsRrBDbLvUYWucbYafpXf9uh44StV7Y4jchAf5kQT/gA1tVMtnXNOeNQlj7
	 nJbnPs8JP1+RgB0Glewr3+Ps5xfWxBgAWeMrPwle7mMR6j0MGFj/xfP/hR01bstZQ6UlR
	 2j2wnkMuncoZWMgvlRybktEJYESySs82uFVaVfHMks9YqD5etIPBsA/Ce7UqFOpKdZS0m
	 I1ueV/ez+1lw4mcBfMWttDje1RttyASovaAUMJhRKh9+2o9JU80A1h5YGr9W4pvIr4HC5
	 XMWYLqNsNxYOfL6r4FcvvDq4n77S+9vO5+1fWzRbk6H7S9QYA/Y34OkSrlVOZYObWjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.cyber.gouv.fr;
	spf=pass smtp.mailfrom=oss.cyber.gouv.fr;
	dkim=pass header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.a=rsa-sha256 header.s=default header.b=Ew2JI7ZC;
	arc=none smtp.remote-ip=51.159.188.251
Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A86606A335;
	Sun,  8 Nov 2026 14:27:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 80A86606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.a=rsa-sha256 header.s=default header.b=Ew2JI7ZC
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Sender:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
	bh=3wUqO+seTF1eo5qfGWwpAfyX8WoqptNLIiqIBPEK0rM=; b=Ew2JI7ZC0FdeIFKVj7ZqmJQgNO
	oJyy4ovx+0VesTBf+Q7cMONJR0OUs1wtW4kwP8daFnvMhvjOHX+Zx42Az7rHWp4CKHcXoW/gFMswQ
	JP4FGBnn5XfRxsQ0SrW1ei+Sc/Pko9gYeVYfX/EajDVKdpmGaUTZ3nyYnb+GlVrhf894qqRrFFUtY
	MwKoTzxlSOusUE2COjKYhDL8/bYOuY704pwEGejZeUm+KHVhd8CIf2brBjlsaXARZs8b1aWe2/oOr
	r+3AMoIOq9x39nGUAHy8DDPyxu3A1gsagOL954RbLjodz4lXzGODyGuGsugNST5gtpM72Ee0kYLTJ
	SdBDLnyQ==;
Received: from [151.115.150.205] (port=49652 helo=gepetto..)
	by pf-012.whm.fr-par.scw.cloud with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.100.1)
	(envelope-from <Jeremy.Jean@oss.cyber.gouv.fr>)
	id 1xQ3rG-00000008IcJ-3amL;
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
Subject: [PATCH ipsec v2 3/7] xfrm: esp: use the current sequence number for AAD and offload
Date: Sun,  8 Nov 2026 14:26:48 +0000
Message-ID: <20261108142652.1330952-4-Jeremy.Jean@oss.cyber.gouv.fr>
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

When a GSO packet is split in software, esp_xmit() and esp6_xmit()
advance xo->seq before software encryption or the handoff to the NIC.
If the 64-bit sequence number of the segment is (H, 0xffffffff), the
counter becomes (H+1, 0). Both the software ESN helpers and drivers
such as Chelsio then use H+1 instead of H as part of the associated
data that is authenticated.

However, the ESN 32 high bits are not present in the ESP header: the
receiver reconstructs the 64-bit value from the received 32 low bits
and its own replay state, and uses it to check cryptographic
integrity. It uses H for this packet at the boundary, so the GCM tag
computed by the sender with H+1 fails verification, as it is different
from the one obtained by the receiver using H.

Use the high bits saved in esp->seqno for the software AAD. For
hardware encryption, restore the current sequence after skb_ext_add()
makes the secpath private, leaving the shared counter advanced for
the remaining segments. Restore both halves because drivers can also
use xo->seq to generate the IV.

Fixes: 3dca3f38cfb8 ("xfrm: Separate ESP handling from segmentation for GRO packets.")
Fixes: 4b549ccce941 ("xfrm: replay: Fix ESN wrap around for GSO")
Cc: stable@vger.kernel.org
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
---
 net/ipv4/esp4.c         | 13 ++++---------
 net/ipv4/esp4_offload.c |  4 ++++
 net/ipv6/esp6.c         | 13 ++++---------
 net/ipv6/esp6_offload.c |  4 ++++
 4 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index 111bea0bd2601..df4857beca02c 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -271,20 +271,15 @@ static void esp_output_restore_header(struct sk_buff *skb)
 static struct ip_esp_hdr *esp_output_set_extra(struct sk_buff *skb,
 					       struct xfrm_state *x,
 					       struct ip_esp_hdr *esph,
-					       struct esp_output_extra *extra)
+					       struct esp_output_extra *extra,
+					       __be64 seqno)
 {
 	/* For ESN we move the header forward by 4 bytes to
 	 * accommodate the high bits.  We will move it back after
 	 * encryption.
 	 */
 	if ((x->props.flags & XFRM_STATE_ESN)) {
-		__u32 seqhi;
-		struct xfrm_offload *xo = xfrm_offload(skb);
-
-		if (xo)
-			seqhi = xo->seq.hi;
-		else
-			seqhi = XFRM_SKB_CB(skb)->seq.output.hi;
+		__u32 seqhi = upper_32_bits(be64_to_cpu(seqno));
 
 		extra->esphoff = (unsigned char *)esph -
 				 skb_transport_header(skb);
@@ -543,7 +538,7 @@ int esp_output_tail(struct xfrm_state *x, struct sk_buff *skb, struct esp_info *
 	else
 		dsg = &sg[esp->nfrags];
 
-	esph = esp_output_set_extra(skb, x, esp->esph, extra);
+	esph = esp_output_set_extra(skb, x, esp->esph, extra, esp->seqno);
 	esp->esph = esph;
 
 	sg_init_table(sg, esp->nfrags);
diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index 3a0aafe991f47..6f6ce9ea5c491 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -358,6 +358,10 @@ static int esp_xmit(struct xfrm_state *x, struct sk_buff *skb,  netdev_features_
 		if (!xo)
 			return -EINVAL;
 
+		/* Keep the current sequence number in the private copy. */
+		xo->seq.low = seq;
+		xo->seq.hi = upper_32_bits(be64_to_cpu(esp.seqno));
+
 		xo->flags |= XFRM_XMIT;
 		return 0;
 	}
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index b287c807b0186..7509fff7f6682 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -308,20 +308,15 @@ static void esp_output_restore_header(struct sk_buff *skb)
 static struct ip_esp_hdr *esp_output_set_esn(struct sk_buff *skb,
 					     struct xfrm_state *x,
 					     struct ip_esp_hdr *esph,
-					     struct esp_output_extra *extra)
+					     struct esp_output_extra *extra,
+					     __be64 seqno)
 {
 	/* For ESN we move the header forward by 4 bytes to
 	 * accommodate the high bits.  We will move it back after
 	 * encryption.
 	 */
 	if ((x->props.flags & XFRM_STATE_ESN)) {
-		__u32 seqhi;
-		struct xfrm_offload *xo = xfrm_offload(skb);
-
-		if (xo)
-			seqhi = xo->seq.hi;
-		else
-			seqhi = XFRM_SKB_CB(skb)->seq.output.hi;
+		__u32 seqhi = upper_32_bits(be64_to_cpu(seqno));
 
 		extra->esphoff = (unsigned char *)esph -
 				 skb_transport_header(skb);
@@ -575,7 +570,7 @@ int esp6_output_tail(struct xfrm_state *x, struct sk_buff *skb, struct esp_info
 	else
 		dsg = &sg[esp->nfrags];
 
-	esph = esp_output_set_esn(skb, x, esp->esph, extra);
+	esph = esp_output_set_esn(skb, x, esp->esph, extra, esp->seqno);
 	esp->esph = esph;
 
 	sg_init_table(sg, esp->nfrags);
diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index 05d13cce22e47..682063bfe685f 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -379,6 +379,10 @@ static int esp6_xmit(struct xfrm_state *x, struct sk_buff *skb,  netdev_features
 		if (!xo)
 			return -EINVAL;
 
+		/* Keep the current sequence number in the private copy. */
+		xo->seq.low = seq;
+		xo->seq.hi = upper_32_bits(be64_to_cpu(esp.seqno));
+
 		xo->flags |= XFRM_XMIT;
 		return 0;
 	}
-- 
2.47.3

