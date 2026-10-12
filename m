Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D2E45519D
	for <linux-rdma@vger.kernel.org>; Mon, 12 Oct 2026 08:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791793319; cv=none; b=d8DV18sYlPvCKqXpuK7El2Rj97+6q37pdcpPBQeGmlk+NDzN0PRGnLFMw5r5TjCk/Xy0iPKNBwQ+yTK+pjWM4b1ilgciafPTaTGNPAQyE0Y/JBi9sPHsW6JUOJB69vQf9Sk8pPzovpxbCHXZ/C8ThPDoboBNHXk5GHsykzLtWBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791793319; c=relaxed/simple;
	bh=57Zei123p9xWRFdldkMP4W3UF50+eUNVP3R3eVd94K0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EBSYr8JBx/b9ZcLsORh/HF+xO5w6w03WXKJoOhU23oqqHlm5VUdxAhSLQr9YiI1xTtti31qoooSHrOTJ/R5yufdEnuoKQbirLxlj9bQzIGFCKn6/J24GOf2zob6i9p8vScezZv//qk8beslIdY3e68UYzu3qVS/rO1WiR40cKhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NZMqYmTV; arc=none smtp.client-ip=74.125.82.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NZMqYmTV"
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-3510d0baf63so4630639eec.1
        for <linux-rdma@vger.kernel.org>; Mon, 12 Oct 2026 01:21:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791793316; x=1792398116; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XSfzsz0eu9DYJ9q7ruuuzGdJdAhI+2e1gpy8B2gxhXU=;
        b=NZMqYmTV7H1a6TlVGHC8JlbaTaE78cBuG3sGCaImWNIqEMfa06aYMvNK8CPiUhOfrA
         K+TKqQfO+JYHAbrhv8ZsqixAxVEsdRBIndS5YNYwrZ1sx6dMHCJubS3YYa4T18PMYaCS
         8Kgt+V4Q0ZUFsRgEtQw7sMovWzuOR+g4lZ0TnbNlzyIcoIq42tPmARoLiXPbqJuLyVx3
         S0ULBsBY2G0SBdDfjBLu04knsB3YLWbXWEsCAccJqN71CTxD2l49e1+Tq6TH3YqCXkGv
         6z1s/RB6Hb5muy8DOWmcWCdAKjLxisleqowYxPnYVg4Ws+R8SzS4wmXqX5+X1jX2VII/
         bCNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791793316; x=1792398116;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XSfzsz0eu9DYJ9q7ruuuzGdJdAhI+2e1gpy8B2gxhXU=;
        b=eNfsLIPLsFMkL1I0S1kXUxUEhjRhmz6cpcy9hR7Rj/BEeZ/OpqfHa8Stc67vJp7bKl
         W0GiJjZPYHAzs/CTQgBg50snfA7S0jXxTlNyc+EBwy0hX3i/sbbIwad1KgahqNi9eWA1
         dZdkmRAteWlF/jOvmWycNpp2fWmkCvUIbKvTvYYATlYb0o1AsFbAvM4k6eH4J/K5UsQ0
         /7rGgt44pNgHgjmpXLjRzHXYI6QrXWXOaM40O1XNtlQR+QTpM1jVqWYyjM4Rz5VdXXvu
         lomoSOg9nWVPGbjLFENsBJup1QK9jdi5UPmsH8lcELT+fi5gb2uTRmS+zg+2e14tilyx
         1v1A==
X-Forwarded-Encrypted: i=1; AKwUvByrDL8nnTV36B4AMv1W6wcuJsH7fxRMMyJ+nM6Jm9lqQ3/Ae7liYp4gyi8qDAF+t3X8p6dRVuZ4SIgY@vger.kernel.org
X-Gm-Message-State: AFq9FYLDeO0uUjjVitpQ/mA7jyFID6Kx7QhhWUG6d5lPQdx+CCQJlMCY
	AdY3QPkp4wFXJUuOQGCrehhtBrhYtd7lCzQ8LsqkwSaV1RAzqCc0C5go/y3kRq6LjB+GBqc3mDQ
	MZykrKzjoE1PTH3HLMunnV/ISZA==
X-Received: from dyay4.prod.google.com ([2002:a05:693c:62c4:b0:342:cdb2:3e44])
 (user=almasrymina job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7301:152f:b0:351:7dc1:7aba with SMTP id 5a478bee46e88-3537e12becbmr10861813eec.32.1791793315255;
 Mon, 12 Oct 2026 01:21:55 -0700 (PDT)
Date: Mon, 12 Oct 2026 08:21:47 +0000
In-Reply-To: <20261012082148.1698596-1-almasrymina@google.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20261012082148.1698596-1-almasrymina@google.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261012082148.1698596-6-almasrymina@google.com>
Subject: [PATCH net-next v2 5/6] net: skbuff: use skb_frag_ref() in skb_try_coalesce()
From: Mina Almasry <almasrymina@google.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-rdma@vger.kernel.org, bpf@vger.kernel.org
Cc: Mina Almasry <almasrymina@google.com>, Ayush Sawal <ayush.sawal@chelsio.com>, 
	Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Tariq Toukan <tariqt@nvidia.com>, Simon Horman <horms@kernel.org>, 
	Steffen Klassert <steffen.klassert@secunet.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Neal Cardwell <ncardwell@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	John Fastabend <john.fastabend@gmail.com>, Sabrina Dubroca <sd@queasysnail.net>, 
	Eric Biggers <ebiggers@kernel.org>, Kees Cook <kees@kernel.org>, 
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>, 
	"=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20=28The=20Capable=20Hub=29?=" <u.kleine-koenig@baylibre.com>, Jijie Shao <shaojijie@huawei.com>, 
	Michael Grzeschik <mgr@kernel.org>, Jakub Raczynski <j.raczynski@samsung.com>
Content-Type: text/plain; charset="UTF-8"

skb_pp_frag_ref() was introduced solely to work around skb_frag_ref()
ignoring skb->pp_recycle and incrementing the non-pp backing refcount.
Now that skb_frag_ref() handles both pp_recycle=1 and pp_recycle=0
symmetrically, call skb_frag_ref() directly in skb_try_coalesce() and
remove skb_pp_frag_ref().

Assisted-by: LLM
Signed-off-by: Mina Almasry <almasrymina@google.com>
---
 net/core/skbuff.c | 37 ++-----------------------------------
 1 file changed, 2 insertions(+), 35 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index fe73f6e8d2b3e..20fca895d7090 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1078,37 +1078,6 @@ static bool skb_pp_recycle(struct sk_buff *skb, void *data)
 	return napi_pp_put_page(page_to_netmem(virt_to_page(data)));
 }
 
-/**
- * skb_pp_frag_ref() - Increase fragment references of a page pool aware skb
- * @skb:	page pool aware skb
- *
- * Increase the fragment reference count (pp_ref_count) of a skb. This is
- * intended to gain fragment references only for page pool aware skbs,
- * i.e. when skb->pp_recycle is true, and not for fragments in a
- * non-pp-recycling skb. It has a fallback to increase references on normal
- * pages, as page pool aware skbs may also have normal page fragments.
- */
-static int skb_pp_frag_ref(struct sk_buff *skb)
-{
-	struct skb_shared_info *shinfo;
-	netmem_ref head_netmem;
-	int i;
-
-	if (!skb->pp_recycle)
-		return -EINVAL;
-
-	shinfo = skb_shinfo(skb);
-
-	for (i = 0; i < shinfo->nr_frags; i++) {
-		head_netmem = netmem_compound_head(shinfo->frags[i].netmem);
-		if (likely(netmem_is_pp(head_netmem)))
-			page_pool_ref_netmem(head_netmem);
-		else
-			page_ref_inc(netmem_to_page(head_netmem));
-	}
-	return 0;
-}
-
 static void skb_kfree_head(void *head)
 {
 	kfree(head);
@@ -6309,10 +6278,8 @@ bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
 	/* if the skb is not cloned this does nothing
 	 * since we set nr_frags to 0.
 	 */
-	if (skb_pp_frag_ref(from)) {
-		for (i = 0; i < from_shinfo->nr_frags; i++)
-			get_netmem(skb_frag_netmem(&from_shinfo->frags[i]));
-	}
+	for (i = 0; i < from_shinfo->nr_frags; i++)
+		skb_frag_ref(from, i);
 
 	to->truesize += delta;
 	to->len += len;
-- 
2.56.0.385.gd3acb90ef8-goog

