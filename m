Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=51.159.188.251
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794148021;
	b=PD4qzLRp3UTEIMIvi3cgQzCE10xDTb9jdpNxGm2ak66PdfpEON8R5Dlyf79sWC5pEWwU
	 zZhHg9nBO2mcqG+9NKsumgZzXkbSsujRR+OBucZbyc4xSPwdLyNTEr5lVAlZ/qdJHMK7L
	 /SyHxSo3rU8qq+GsqcCqg6ZdVCIZm3ArtGQKJBIpwTaBLT9w3WW5tGbsj1qlk4BuQpobv
	 PWmzjzgCUEqNs8a9/6xPX42iZL4GJTkN0gf94mu/TMnBuS0So0prIK4UOJXqOQb9GTgEQ
	 0MPPifEZZ1KTqgP/ZmpQ7ELSq0qg49imkE41n8Of5fk0g8HOeyBPklDJp64TTEhxN9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794148021;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-AntiAbuse:X-AntiAbuse:X-AntiAbuse:
	 X-AntiAbuse:X-AntiAbuse:X-Get-Message-Sender-Via:
	 X-Authenticated-Sender:X-Source:X-Source-Args:X-Source-Dir;
	bh=gNojsi3GAmLLmeRMDSKN6Y0E5VJAy6rWp8R/Pes+NNs=;
	b=wn01GzYMT/UVhdPwLtWXekQ70H8BfcJTfJvhMyaUHCXSkwO4GwsvYIENlafzsTifejnA
	 8ddVA/490HFAdIJ7H/c4Whh1QwpjKIor45e15OrXZuEZL8zwiBIJhkn6IRdTJmDGLFuqZ
	 yQcxgqq6Zvxrtz0E0nsfb2Yed/M5vUk82oosRsq6J1cg22oZVjhHraOCBHFeMhDeRsGtd
	 Q+hni1ea/zGsh31JKoYd9diynALiA/GzU7dMEdhWreIc5GP80Qi6lt6HTEFsP+ZnYNLJh
	 k1mvhJXj2jwDax33qQlHn9rx65INEiHs5Mjml1T2SH0f/c9i86MvTrxZHJQ8sQZfwXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.cyber.gouv.fr;
	spf=pass smtp.mailfrom=oss.cyber.gouv.fr;
	dkim=pass header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.a=rsa-sha256 header.s=default header.b=p8d33lI6;
	arc=none smtp.remote-ip=51.159.188.251
Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF02606A33E;
	Sun,  8 Nov 2026 14:27:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DEF02606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.a=rsa-sha256 header.s=default header.b=p8d33lI6
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Sender:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
	bh=gNojsi3GAmLLmeRMDSKN6Y0E5VJAy6rWp8R/Pes+NNs=; b=p8d33lI6LolQ3Y6dbmV8jQgASx
	QGWK9iEBGZtPl4++V0utfKE2+MdjvWud4dkG9QsduicckpvN/B8DyP8fHUcUd6LssJOUj4l7K5AgE
	Tuop8/roCdMjbSUHAfynaCVILOKyKEFwvgg4OdhqBTM2QdG30mcCAk5MB5fyO+7thAmQDsQ4L8CY1
	sFaLFa5XyG9GbSFrl4rffJ7xYl/Rbcrwduk7S4SnXaoLJYW/vTasDwH88cXgnE1yx6kx2xX5Mi+eC
	PVMB6ADVOdPRGEXavmchzwB4yKpqJKP5UB8bvphOY+0xTxpXEnxaKUpGOIm9NZUA+XLA+y2QpEHtk
	EIVKIjKA==;
Received: from [151.115.150.205] (port=49652 helo=gepetto..)
	by pf-012.whm.fr-par.scw.cloud with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.100.1)
	(envelope-from <Jeremy.Jean@oss.cyber.gouv.fr>)
	id 1xQ3rH-00000008IcJ-1n7q;
	Sun, 08 Nov 2026 15:26:59 +0100
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
Subject: [PATCH ipsec v2 4/7] xfrm: prevent AES-GCM nonce reuse after early GSO
Date: Sun,  8 Nov 2026 14:26:49 +0000
Message-ID: <20261108142652.1330952-5-Jeremy.Jean@oss.cyber.gouv.fr>
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

With software ESP offload, xfrm_output() attaches a secpath before
calling xfrm_output_gso() for an encapsulated GSO packet, but
skb_gso_segment() leaves the splitted skbs sharing the same secpath,
including xo->seq.

For the i-th splitted segment, xfrm_output_gso() reaches
xfrm_replay_overflow() through xfrm_output_one(), which allocates
sequence number N+i to that segment, and then incorrectly overwrites
the shared xo->seq with N+i. If encryption is delayed until all t
segments have been processed, xo->seq ends up with value N+t-1 for all
segments. When validate_xmit_xfrm() calls esp*_xmit() for each
segment, the IV is constructed from the same value N+t-1, causing
nonce reuse in AES-GCM. Yet, each ESP header correctly keeps using
value N+i from its private XFRM_SKB_CB.

Call secpath_set() for each offloaded segment before xfrm_output2(),
so sequence allocation writes to private metadata that cannot be
overwritten by later segments.

Fixes: a204aef9fd77 ("xfrm: call xfrm_output_gso when inner_protocol is set in xfrm_output")
Cc: stable@vger.kernel.org
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
---
 net/xfrm/xfrm_output.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index f1f612cd7b438..99d1b33db52a6 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -672,6 +672,15 @@ static int xfrm_output_gso(struct net *net, struct sock *sk, struct sk_buff *skb
 	skb_list_walk_safe(segs, segs, nskb) {
 		int err;
 
+		/* Each segment reserves its own sequence number and stores
+		 * it in the secpath.
+		 */
+		if (xfrm_offload(segs) && !secpath_set(segs)) {
+			XFRM_INC_STATS(net, LINUX_MIB_XFRMOUTERROR);
+			kfree_skb_list(segs);
+			return -ENOMEM;
+		}
+
 		skb_mark_not_on_list(segs);
 		err = xfrm_output2(net, sk, segs);
 
-- 
2.47.3

