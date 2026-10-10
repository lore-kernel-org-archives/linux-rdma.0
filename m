Received: from mail-dl1-f72.google.com (mail-dl1-f72.google.com [74.125.82.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD1C83E5EF3
	for <linux-rdma@vger.kernel.org>; Sat, 10 Oct 2026 08:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791621588; cv=none; b=aQtIuEufxS06ZcKGMqYUtQW7xSXKRrQ4Z92qL0JKTBXCO096lc71DMpgRNJpheFexXY5hCElNhVJ4go+qYagU7ELnmiigwmH3ovhr4RnoeKBV02Natou4nA9W17N0jNZUSj+i10gyK7edRP4OLNgjBrFqBOKBEOX8L5ZjSDs7+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791621588; c=relaxed/simple;
	bh=XSN8hnZDdEF8E7qEmVyNQTNlDKZ5mQTQiUCfNpNTAbM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DsaMINnYA44pFYC6BHcE9yyNqJKS0uEaWDZAH8ofGU+ey/0q4GhRcBUw/XQ0eUC14IyGSLeoQfSHKjITlikxrw1NLHpiAe8/F/+NTzBz9NtIKkNmZuyQ7GbAavJeBWKvobHZ3orfBko3c5lFPvw9Z7doflqo5VQuCxBXYnwrhG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bfQsIvD1; arc=none smtp.client-ip=74.125.82.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bfQsIvD1"
Received: by mail-dl1-f72.google.com with SMTP id a92af1059eb24-147be78cd56so2078852c88.1
        for <linux-rdma@vger.kernel.org>; Sat, 10 Oct 2026 01:39:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791621581; x=1792226381; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7wl16BeDJDT/ZGI/NUaqDwRoHBVe8EzXOdli6uHqLZw=;
        b=bfQsIvD1Jqh+qhTce/tP3PH04cKs28Iuui1mKGOm/VP3NLcmsM95JB/vXhGv1oguHl
         mkHDW/UvsRDwl4K1slWHVSQD/PkeDEKiuEqBBG+C/UxzXa5dTqzMUuCI2PsT9yJyNsiD
         wVeVogENzNP3xxJK6prMzOqDegZq/wlm5pOpSkr66OYjLWvufhWC139Ns6NDBPvPnuMW
         htL6dG0EOXNiQ64rhAhmqOMhz3m7On/Z0+OaSXk0RJGeN3Hohn3W8pbjy+Ub0x1ReQQS
         Qlsy2AdkB2ncIXzp0AztmlzX9lZBG8Ci9yEqjfRfiK2eh0Ib+GjUGQMFgLaNKhxQwn6T
         az0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791621581; x=1792226381;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7wl16BeDJDT/ZGI/NUaqDwRoHBVe8EzXOdli6uHqLZw=;
        b=Cpip9L1PMpO7YKnZj2QRYkYmnOV8bZATMlScsNdJzlVpu/YAiMmjdMKbhI5Jp69w/G
         erj9prvJiKlxgzkqRmyovBYrfhR09XcpnsPUP8orF8oMQmJ7G8RG3M0qKE5K/GefYhXq
         OnBaCZiBdOjy5u6D/qVJP0BzxmvrdidaY+zuUZMiP0FMD5rSTYQTgpx0f6zH9k//eXRD
         ePDxclRcB3SZIbJKfTcujiFagOVia3KQLkM4Gzczt/yoDNAJGvSozLS9bbS1yrbkuxv1
         AsvjoqE3VAM/dmKvmX5UQ/KA2l9LSNdxa2wifOBjMfq+v7snND0pJ5OTn2KUTLY3It5k
         Ev6Q==
X-Forwarded-Encrypted: i=1; AKwUvBx/jCmaC/ONP02jl3z1/Daz4QL0qd45IcCXkPPbts1nqdYErAHZATK6tgwx/MqqZr3g6fwdpcfGWpmT@vger.kernel.org
X-Gm-Message-State: AFq9FYI7aZafN79JXQdOFAkigg9O5bMSkUPuaOE2sE27wWKepkyh2yrL
	6Fwi74sBPnIy23w9eE1PmO7xw4SqrbtfW2X2+AkGsbD0dOCbbWHsDoagu4iXT55MlR1i767AHrW
	Vk8g9P0NEhTPzv2dgCyEZp4HGvA==
X-Received: from dleg5.prod.google.com ([2002:a05:701b:4305:b0:164:3999:d7c8])
 (user=almasrymina job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:e805:b0:148:2f17:3e75 with SMTP id a92af1059eb24-16a61695579mr6045623c88.12.1791621581028;
 Sat, 10 Oct 2026 01:39:41 -0700 (PDT)
Date: Sat, 10 Oct 2026 08:38:46 +0000
In-Reply-To: <20261010083935.3274178-1-almasrymina@google.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20261010083935.3274178-1-almasrymina@google.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261010083935.3274178-6-almasrymina@google.com>
Subject: [PATCH net-next v1 5/6] net: skbuff: use skb_frag_ref() in skb_try_coalesce()
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
	Michael Grzeschik <mgr@kernel.org>, 
	"=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20=28The=20Capable=20Hub=29?=" <u.kleine-koenig@baylibre.com>, Petr Machata <petrm@nvidia.com>, 
	Arend van Spriel <arend.vanspriel@broadcom.com>, Jakub Raczynski <j.raczynski@samsung.com>
Content-Type: text/plain; charset="UTF-8"

skb_pp_frag_ref() was introduced solely to work around skb_frag_ref()
ignoring skb->pp_recycle and incrementing the non-pp backing refcount.
Now that skb_frag_ref() handles both pp_recycle=1 and pp_recycle=0
symmetrically, call skb_frag_ref() directly in skb_try_coalesce() and
remove skb_pp_frag_ref().

Signed-off-by: Mina Almasry <almasrymina@google.com>
---
 net/core/skbuff.c | 37 ++-----------------------------------
 1 file changed, 2 insertions(+), 35 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index f03ce8d5ae585..554af794bd7cd 100644
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
@@ -6295,10 +6264,8 @@ bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
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

