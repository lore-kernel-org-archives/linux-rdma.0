Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B294718CA
	for <linux-rdma@vger.kernel.org>; Thu,  8 Oct 2026 21:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791493438; cv=none; b=PrZmsWKYHOU13PD3yNNedjfTFcQfK76n0rqnOBssUNDpq17EmG/gFe8tOXeAAXPeqzxNB2vCamXy6Xtgc0ALA/bz634gTywVd+gOCKfQ6liuxpgEzOVDHEUOfugciw52sjVTe72J20RqoydffLpjqsOfaecpjDFFLcJU2//J8xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791493438; c=relaxed/simple;
	bh=G4GQSS/z86H6HrzRjtGCGkhfNcr1ZqkSUEOCEKTi8N4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=AMjlpq1+Ib2MN5BvWy4nFP3KwWb6hqWTxXlHYFCHQ4TzbcGHGUEDf/onOU5dOQvEBvYA67LwhvBZD8BkqdB0hlgOnb1ifQEikMPhShOwKKxkVDBBg+LsjhlyF7SEJ5P/6cO3VXDHtwGH93sjZgYbU5bbiRdQpoa2PNB+lsLcAf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=pass smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.b=eTjSebB5; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.b="eTjSebB5"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-917d595138fso34773896d6.3
        for <linux-rdma@vger.kernel.org>; Thu, 08 Oct 2026 14:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1791493424; x=1792098224; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=D0uSM/A3oRPIUcCVkMNaXKAYlboH4f+zE5JovH6Ln9w=;
        b=eTjSebB5sOc8aErg8cT/L7MyU56/ql9J7O3y8pCm1Kxh5LmxJiwRLpXUH+z14e8g8e
         Z9UHllMXXQ6iH2NX1W5c3e3zSfdcEUIWNaCGgxbLL1phM5cjpcGPGxcj8qRxjRKsFDcH
         Dx3Ns3otH8zlAnfexu/pb3vu5oXZo7ir+HNHrQKqEvIMlN8s8xp7w4LRIQ5VZtg/eZsp
         yESTj6lwB6FyO1L7ktK5JCcF0pXkJmC2c2J6U+Tp6O/rE61gO4FdJ3/louoq6lgpqE1s
         fjfEgRBxJiLcTpVGSYW6OtmB8Jm5+GiK8jnHS0ghpb7xcWQTGeMiPkTcpHrNmUbJy3F7
         kS8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791493424; x=1792098224;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=D0uSM/A3oRPIUcCVkMNaXKAYlboH4f+zE5JovH6Ln9w=;
        b=DGtZVbB4dXPyt0grUKdI3hPr1iccXTxBuAKC50FGus4xyDUdCYt+pnKza4yhVq5Z6A
         y8F3X6LSq0OTbHVtl9U7S+nUKujGUsU1vE770BnuGiL4cKi1xT76MoITCkOAzTpUaAsl
         q/XrS4uMM7F8fRNHvOgK/4+iVahB79uxsYdXZMY0MLDoouOcPy5pl7i9+ZuABu+iok4g
         2U5M0teK5XMo1nVW3mmgk1naG9ODWeytj0JL9IU1T8DGvMCRJy1NcGW4t7fZ8BzY4Bgp
         wl3+QEJHmYgCDx5QqEgN1Ju5v83/F4UWcH+oMNVe4d5cPMumBxJ/tRHHIh1vFQPKU5LV
         Tlcg==
X-Forwarded-Encrypted: i=1; AKwUvBzIESoPh4AuxGqpA/YY1gUCnOkF6VXq4deMAyjs/bbEivgkuyaam53eWDC9BF0W5KkG0oetmiF3mH0q@vger.kernel.org
X-Gm-Message-State: AFq9FYIzE8E9IoOPZqGXmm4Gq8B2Y/AdJc3ipoxLQnrte8ztY/C3AMas
	JJTB8pe3jzSBRDwv+otP1njCAKgfn7TXB8SxC3+ehSNGqhCFWYkNrmIxRXUFrModKrg=
X-Gm-Gg: AYBFou3fC4fuKf9+10Ui9pZgBwiAA4KwlE3RGwH2D/2ThbvNdHns+/WAY1ST8Afwb7k
	h1wqHZSSbQMfCtuUU2Qtv+9EYYhtjjo+b3Cqh9Vk4yQMnSd/2xJz9rxy4XJ6MKmJl+75dt8C2zo
	OCYv6v4oFF5N3yFm1GXONEe5Q7pPVmiviBUCprFch5XFVXYECbnvZS9wYA979VANcFLjbuaIWan
	PmbvlzRzSzxPcCDviCUtXiNEYRpmTnTqLjULybzbDlxU/1hhDI0Tu2oe3KGgY/Q2F1ScZQtWJau
	If55C1TGd+6B1kAuZp4OSHi5/u0iL3euDqV3ZnK2W4qm3u/vUEBe+5FzpXefPTz/mdEgw+yx9NQ
	v1JO22sIolDey1DAYalTU7eXF183q5fXrCtv6VO6cgTDSa9I3cG1TXgdc9w1CLgfXoBy/qmAQT4
	tKMYrTAiui8vO53fB6l0jTGhQGWK0erUkf9wRV4bJEzW0T0AuIVLAqvK0bUrD8sw8JdPLi/NZRZ
	c7iwaPqTb8CSQU=
X-Received: by 2002:a05:6214:ca3:b0:919:952d:7ff9 with SMTP id 6a1803df08f44-919978f7ebamr126853616d6.57.1791493423774;
        Thu, 08 Oct 2026 14:03:43 -0700 (PDT)
Received: from toxicpanda.com ([153.61.196.247])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b550d394bsm79796d6.41.2026.10.08.14.03.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 14:03:43 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
Date: Thu, 08 Oct 2026 21:02:57 +0000
Subject: [PATCH net-next v2 10/10] net: skbuff: don't reset truesize in
 skb_condense() if the pull fails
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261008-b4-pskb-pull-tail-drivers-v2-10-8f2bd9bee138@toxicpanda.com>
References: <20261008-b4-pskb-pull-tail-drivers-v2-0-8f2bd9bee138@toxicpanda.com>
In-Reply-To: <20261008-b4-pskb-pull-tail-drivers-v2-0-8f2bd9bee138@toxicpanda.com>
To: Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Eric Dumazet <edumazet@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
 Andrew Lunn <andrew+netdev@lunn.ch>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, 
 Mark Bloch <mbloch@nvidia.com>, Leon Romanovsky <leon@kernel.org>, 
 Juergen Gross <jgross@suse.com>, 
 Stefano Stabellini <sstabellini@kernel.org>, 
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>, 
 Tony Nguyen <anthony.l.nguyen@intel.com>, 
 Przemek Kitszel <przemyslaw.kitszel@intel.com>, 
 Manish Chopra <manishc@marvell.com>, Rahul Verma <rahulv@marvell.com>, 
 GR-Linux-NIC-Dev@marvell.com, Shahed Shaikh <shshaikh@marvell.com>, 
 Simon Horman <horms@kernel.org>, netdev@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, 
 xen-devel@lists.xenproject.org, intel-wired-lan@lists.osuosl.org, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1791493385; l=1285;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=G4GQSS/z86H6HrzRjtGCGkhfNcr1ZqkSUEOCEKTi8N4=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QD7QXznJXVwY4tvhlA2g/ntlgNB9z4EYJ24pFBre8ehTYCPfcNpsZClmKSf0INhwTvOUpctCjRC
 vzNH0Zo1blA8=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

skb_condense() pulls all of the frag data into the head and then sets
truesize to cover just the head, but it ignores the return value of
__pskb_pull_tail().  If the pull failed, the frags would still be
attached and truesize would undercount them.

It can't fail today.  The caller has checked that the head has room,
that the skb isn't cloned and that the frags are readable, and pulling
all of data_len eats every frag_list skb whole, so nothing is
allocated.  Check the result anyway and leave the skb alone on
failure, so this stays correct if any of that changes.  Use
__skb_linearize(), which is what this pull is.

Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 net/core/skbuff.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index f798118df112..556d37981f0f 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -7158,7 +7158,8 @@ void skb_condense(struct sk_buff *skb)
 			return;
 
 		/* Nice, we can free page frag(s) right now */
-		__pskb_pull_tail(skb, skb->data_len);
+		if (__skb_linearize(skb))
+			return;
 	}
 	/* At this point, skb->truesize might be over estimated,
 	 * because skb had a fragment, and fragments do not tell

-- 
2.55.0

