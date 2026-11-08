Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=51.159.188.251
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794148023;
	b=S2+BIhsZq7OH1UD/ZNxS9r0hPsq8jnj3fvUKIKffHmKctuLWR3rf0dQF4jpq1NvY5vXX
	 4K57Q92glqQFTbqkVEj0k4PZ3WUc3YLoXYs8yILd2a6QYvJsj4fcaNE4jcFSkg4jXXr82
	 bREe2afxr2h507HXJr5LUDqGEki7SBrwlOHD/1IFMMVu6Xm7U6EOA0JbAJ6mMdun6bGun
	 BwmpCG6Yp/rLGSxJC13yc8bK6xFwJKsIuh6HPvo4JhcbvEadWcDQT0wjN5irs5aJSvvCk
	 0mxJ+G2VhoHYPko0NuDsgrEbyuible+ET6sjjnfyd27arq5XDtVQlhDN89Gp/jvJ6WQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794148023;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-AntiAbuse:X-AntiAbuse:X-AntiAbuse:
	 X-AntiAbuse:X-AntiAbuse:X-Get-Message-Sender-Via:
	 X-Authenticated-Sender:X-Source:X-Source-Args:X-Source-Dir;
	bh=tOHTRsSEaZagNTHT0lNEFJtGwuWPJgb7aelTZKqw7lg=;
	b=MFQ2GOjFhfiCThoHZ+LMQwc1XwF1RbB0vK7SNhG4AjXrE4mRAAftvPfWUmBxBgN/TtDU
	 /OylqV31i6D4y/Z9U6O17Bt5SSxUGFZGjsBW23AYtu4DHkAZ+d/wAr2tVhlMVPiidJ8aq
	 sCWpkvicK+rDssH0on145CUDqClQDc6shahM00+YKC5P7eQDNiuN34R57nME+Y0x4DeAd
	 Pi7Fm0RR6UybXt4Lv34oSJ8+iCG3drMbShgPXw4Op0JSyb498SCnvDLrvO/lSaIU2RJwS
	 /f5lZy8xAlkQO198Hh809GqbKie9y3bYZLIX0GdXtUFR7Yp5gP7CntVAUWa6c8LXhqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.cyber.gouv.fr;
	spf=pass smtp.mailfrom=oss.cyber.gouv.fr;
	dkim=pass header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.a=rsa-sha256 header.s=default header.b=X+E7z5hg;
	arc=none smtp.remote-ip=51.159.188.251
Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B6C606D809;
	Sun,  8 Nov 2026 14:27:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 28B6C606D809
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.a=rsa-sha256 header.s=default header.b=X+E7z5hg
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Sender:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
	bh=tOHTRsSEaZagNTHT0lNEFJtGwuWPJgb7aelTZKqw7lg=; b=X+E7z5hgKvjlRl5FSTULccBbvB
	ZoinZlrGZLGdJgecuu6TP+R5FRH9Yn9kqhKtwJ4QUJzrAUH8ji6w1rnlJ6mp5LVsvaqRrq2Pr+3Yy
	WQkWsOYVsvMjzxGYynM0QJopEiKRcPoGf2UrsZ+aj5JcUmZy7WA5wW0QVCfq2fDW5CRoBRDoa7zKI
	MyAL8A7z6C4C0Qi0WZ59YaXnGu1Cqb5mt9A4KvheI+s0TeZlEYqjnQG4zB8dy6AQ/2awPpxLqIRua
	/63nn9embuqWQnJF7YzUZ3OLHqsOh3GA4liwiSkbla2SmNvM98bSQyA3bCy607oe2qJGekhticGSi
	6oFLt0fw==;
Received: from [151.115.150.205] (port=49652 helo=gepetto..)
	by pf-012.whm.fr-par.scw.cloud with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.100.1)
	(envelope-from <Jeremy.Jean@oss.cyber.gouv.fr>)
	id 1xQ3rJ-00000008IcJ-2uUU;
	Sun, 08 Nov 2026 15:27:01 +0100
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
Subject: [PATCH ipsec v2 7/7] xfrm: leave the sequence counter unchanged on ESN overflow
Date: Sun,  8 Nov 2026 14:26:52 +0000
Message-ID: <20261108142652.1330952-8-Jeremy.Jean@oss.cyber.gouv.fr>
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

When the 64-bit ESN counter overflows, xfrm_replay_overflow_offload_esn()
rejects the packet and rolls back the stored counter. It decrements
replay_esn->oseq even though only the local oseq has advanced, which
can later induce a reuse of the last sequence number and the
corresponding AES-GCM nonce. Both IPv4 and IPv6 are affected, yet,
processing about 2^64 packets under a single key is required to
trigger this bug, which is highly unlikely in regular use cases.

Leave replay_esn->oseq unchanged on overflow. Keep the decrement of
replay_esn->oseq_hi to undo its earlier increment.

Fixes: d7dbefc45cf5 ("xfrm: Add xfrm_replay_overflow functions for offloading")
Cc: stable@vger.kernel.org
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
---
 net/xfrm/xfrm_replay.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/xfrm/xfrm_replay.c b/net/xfrm/xfrm_replay.c
index 9394953247ab9..01504e5b1ad41 100644
--- a/net/xfrm/xfrm_replay.c
+++ b/net/xfrm/xfrm_replay.c
@@ -721,7 +721,6 @@ static int xfrm_replay_overflow_offload_esn(struct xfrm_state *x, struct sk_buff
 				xo->seq.hi = oseq_hi;
 			}
 			if (replay_esn->oseq_hi == 0) {
-				replay_esn->oseq--;
 				replay_esn->oseq_hi--;
 				xfrm_audit_state_replay_overflow(x, skb);
 				err = -EOVERFLOW;
-- 
2.47.3

