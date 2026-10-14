Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8DF556853B
	for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 17:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791999600; cv=none; b=eUQRhwF0pgKQVEikHrTZVTDtS19VDimqQ/R9btQsStYGZnYN1NZ0zV9EqjnqkkP18UiHPXngA3DT6UD5NgOX04lMXH2DKljSup3iDiAR64XfLP/y0y9Yv2FTdNKeUq0XF50KeX83DN0fhXt21Xop48VJef/Wci6u8S8h9tgt85A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791999600; c=relaxed/simple;
	bh=R94b81Il1DPRpiO9yIJavDxrrp2TKzmWXyXkrWre7b4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kijRpfE/N7UCJrnHqb9KynjTBp+nAMxednb3aArSAoKpoCkihCeK5573IqlD//LUoSugdhl42gGFDvqP4ZlVVnyfKkXWsKDi7pK6n7zDwU1iKEat41FPnHmJ6xc+3JAJKY8rTXT2Gc6oN1JqJD700hzjfAYNkEvaaqRASb6hx3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KE1xMEB7; arc=none smtp.client-ip=74.125.82.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KE1xMEB7"
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-3580c07911eso11474053eec.0
        for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 10:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791999592; x=1792604392; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Y1WRn4NyJ2crY+vOKIR9nna7T2nc3BS4Nc6wM3wk19Y=;
        b=KE1xMEB7tu5Pt5RvmHRdnNxiasHtw/7jthf/SdWjoTPib6n0uPMcanHgx6uYI8e1x6
         pBZsO9wkJoAFzO9G1rh0oWNP1lRIDxoWqwEtOR19cX7mzQ+czfS5E8SF4VyuqEroz3bo
         zEwYIR3aJMnvm+dxjWaaBCxBcJEu7AyeBtzykaxSjxtbrs0cnSFNqZ52GD3VKeaxLCD9
         8tp5esazgszRC0wNFbqrhvRtE/Snj6vlEkZXsf3TRWNau27uyq7sBoKKqxypFI0C6EPs
         RkOtcjz2EzP9U+4JQn/N1/I1Ib1/XGxrmDpBbQYGgwjBpQzLs09rbswII2ih7x6vcdLy
         xTdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791999592; x=1792604392;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Y1WRn4NyJ2crY+vOKIR9nna7T2nc3BS4Nc6wM3wk19Y=;
        b=UMqG5tGyXuwoQKoT8wrAFmTSZZr4p6HUtgs5yGQuo7sKa725AADzV4sCZjaq+oJPaQ
         LOeVdVdA4lg9E3WE9heCzI3WTklR0pb3aTLx4eyQvdF4tJjI8a/gkcbx++Gi4ruN5otj
         qZ+ectpJfKhKgpfUAMjW4DbXx59n8ha6g0uLp7pDL9Sg4BapsSI++yyg3IOh+vZVeTBT
         5WHHTWzcVOwZc8tRTL9PzyBPdHSbNT0Rwr+c1pGox8jZ5brxnGidhff8mfSq8VWxhDkv
         26XiP3GEv2KE4Uhnm8OV0fgVdYuPTbjUiraS4AYZlK8FkX2mo7PsKJ2aUY9AVyyGRd3l
         pkMQ==
X-Forwarded-Encrypted: i=1; AKwUvBwO/Lub7vZjOvOwtGsBufky7p1/HZDiLD2oPN2ySWC1MH/StKwgl321GlWEfqB8wwz8YlDz+ya8vxcK@vger.kernel.org
X-Gm-Message-State: AFq9FYIDQSkscjX752IT5Z6r91+pB1FF1a1tQMu03AwYuR+eEoGTj7fA
	C/0fHkTzLWRc0yYPP/mE+wZIwPTUuvBsHZs/+2WM35vmqQ986msarL84npzv/xfJIQr90KFNI6m
	4IaJxVnaJmdYyp58iR/VR7V/OLQ==
X-Received: from dybmd47.prod.google.com ([2002:a05:7301:182f:b0:351:1933:2028])
 (user=almasrymina job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7301:3a84:b0:351:985:e729 with SMTP id 5a478bee46e88-3537e01e8b6mr24400970eec.12.1791999591271;
 Wed, 14 Oct 2026 10:39:51 -0700 (PDT)
Date: Wed, 14 Oct 2026 17:37:19 +0000
In-Reply-To: <20261014173945.373295-1-almasrymina@google.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20261014173945.373295-1-almasrymina@google.com>
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
Message-ID: <20261014173945.373295-6-almasrymina@google.com>
Subject: [PATCH net-next v3 5/6] net: skbuff: use skb_frag_ref() in skb_try_coalesce()
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
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>, Petr Machata <petrm@nvidia.com>, 
	"=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20=28The=20Capable=20Hub=29?=" <u.kleine-koenig@baylibre.com>, Jakub Raczynski <j.raczynski@samsung.com>, 
	Wang Zhan <wang.zhan@smartx.com>, Willem de Bruijn <willemb@google.com>
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
index 96088289c234d..90812e49dc8e1 100644
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
2.56.0.212.g129ede20d9-goog

