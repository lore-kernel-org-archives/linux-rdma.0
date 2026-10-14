Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B68F65452B7
	for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 17:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791999598; cv=none; b=NGEll/tjabHlKnaSRLSDgLgf+dwh5ZrVjeOBU6g5sndZ5beQ4YI7SrAlBhYkdXWFySUvu22qcLEW3LtTz6Bep5+CKDSGyrz72QGBmnb49LXlDPS1UBwvO0AsjZsN9gUjv+bAPkQy+OznPipf002AjoAp0p9PjLsmi5U07pmuGSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791999598; c=relaxed/simple;
	bh=fFD8oZtSK/knMuPdZN4DP0R67wo/lLsvLuNNvU+AmOQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cU0vOzm6beu9e6oItTYmg+4fSeGN1VfrXP4cdU6ApQL1dezkHKRSmH4dNoDe71OopaxNncjb+gnzyWAYnYN5uWABLvPDNPQWTK/nzs1e7X3aDLdU30DYEO0+Ne8gXTcJdye3ifrvoAhNE9Y0FrBb+rCA5AppRsiTHN7ma1opfB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OB748H7d; arc=none smtp.client-ip=74.125.82.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OB748H7d"
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-357e2bc3b1bso7109790eec.0
        for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 10:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791999588; x=1792604388; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zX5Z3hRL45oldLQst4d/39m7wB0Hus3plFvx715Aac8=;
        b=OB748H7d1PLBFq5zWSFtSdih0Y349Jxc52WViRdixelZWUdD535VlVNTdifv0uivq+
         oOJ9lcnuuSzEGxgJRoOFqJ4iygeXGKSu8AK2aW0ZVV55Cc3om0mAmi88HxA7KKYlgNkL
         ahi7FuImECjEI1eRd+QAYXdmfs6K7gRhz7hsDM6r7iB4cFBtOC3B2jkNsJzdjkq5ygzt
         Ejz77cd4IeiLHHpKCTuI5YUE8z5jz9WrzIrHsf3IMN644l+O6TA6SmEPjfLoIhr5nYvr
         ZAjy/htm3Gt3j8I4D6ZUkfYM4u38166w/yNWoDgsmcXyrwv/8zCpVkPXWNXHFWcXfmcj
         R4QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791999588; x=1792604388;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zX5Z3hRL45oldLQst4d/39m7wB0Hus3plFvx715Aac8=;
        b=JUmG52T9+URHyn91KFzNiN3R+7pZSGfFIkuDvsRlaef/uKVr69h2Giiu3itJRK1ypa
         M4yMYGRXBVOMm/SHyo1A/Shh/nWGPDO7x0nsqQpaMweG9mc37aNwMtFqmEkE2YEN99lu
         TJRFFvxBren/X+slWNWt/c1hvi4yoaSeYlUD55k5FYiLy2LniIuIlPI92Z6uX8+u0Naz
         fmEna5vp7ocGdKORo2kwZ+hkbvzBabV6KAf+5U7AvOL8hndWweDDYUcUGG8PNmlLQkUc
         808hsRWkT2o1rI2zVjWVnSTVO8An4Lq4p3luBw8TLRc4a+YJr6Ltt7zeXSEP2KisvtVs
         3TMg==
X-Forwarded-Encrypted: i=1; AKwUvBwuumfchbv9AmjxGlA30+GKIGXpas+3UNHMFc//MAtk7OR7j3MGsEZ7CYOcZev8qZ19Ukn1z80NHLSU@vger.kernel.org
X-Gm-Message-State: AFq9FYK8SS4E9CjfmvxxPaBL/6wjaJ4h6mCHaVHRKuZg20U1TiN7jno9
	2HlGChGp/lpOQsLOG6NoqGVRoj20BxCBQk34HpRwPV5I839CA3EFqnyBRkZkplle6YXu4yqDzID
	JrjehThLAvKTu+hOWqTcqd3SsFQ==
X-Received: from dygg27.prod.google.com ([2002:a05:693c:80db:b0:353:82df:8a9])
 (user=almasrymina job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7301:fc08:b0:351:4d2d:af26 with SMTP id 5a478bee46e88-3537ddd6633mr21037508eec.2.1791999587876;
 Wed, 14 Oct 2026 10:39:47 -0700 (PDT)
Date: Wed, 14 Oct 2026 17:37:16 +0000
In-Reply-To: <20261014173945.373295-1-almasrymina@google.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20261014173945.373295-1-almasrymina@google.com>
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
Message-ID: <20261014173945.373295-3-almasrymina@google.com>
Subject: [PATCH net-next v3 2/6] net: skbuff: add napi_pp_get_page() and use
 it in tcp_recvmsg_dmabuf()
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

While napi_pp_put_page() releases a page_pool pp_ref_count reference on
a netmem, no symmetric helper existed to acquire one, forcing callers
like tcp_recvmsg_dmabuf() to open-code atomic_long_inc() on
niov->desc.pp_ref_count.

Add napi_pp_get_page() to pair symmetrically with napi_pp_put_page(),
and use WARN_ON_ONCE(!napi_pp_get_page(netmem)) in tcp_recvmsg_dmabuf()
to match WARN_ON_ONCE(!napi_pp_put_page(netmem)) in
tcp_release_user_frags().

Assisted-by: LLM
Signed-off-by: Mina Almasry <almasrymina@google.com>
---
 include/linux/skbuff_ref.h |  2 ++
 net/core/skbuff.c          | 31 +++++++++++++++++++++++++++++++
 net/ipv4/tcp.c             |  6 ++++--
 3 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/include/linux/skbuff_ref.h b/include/linux/skbuff_ref.h
index 05c8486bafac8..0441c220fdbdf 100644
--- a/include/linux/skbuff_ref.h
+++ b/include/linux/skbuff_ref.h
@@ -9,6 +9,8 @@
 
 #include <linux/skbuff.h>
 
+bool napi_pp_get_page(netmem_ref netmem);
+
 /**
  * __skb_frag_ref - take an addition reference on a paged fragment.
  * @frag: the paged fragment
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 23a40e1ec2b15..76a42c60508d9 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1026,6 +1026,15 @@ int skb_cow_data_for_xdp(struct page_pool *pool, struct sk_buff **pskb,
 EXPORT_SYMBOL(skb_cow_data_for_xdp);
 
 #if IS_ENABLED(CONFIG_PAGE_POOL)
+/**
+ * napi_pp_put_page - release a page_pool reference on a netmem
+ * @netmem: netmem to unreference
+ *
+ * Drops a page_pool reference (pp_ref_count) on @netmem if it belongs to a
+ * page_pool. Counterpart to napi_pp_get_page().
+ *
+ * Return: true if @netmem belongs to a page_pool, false otherwise.
+ */
 bool napi_pp_put_page(netmem_ref netmem)
 {
 	netmem = netmem_compound_head(netmem);
@@ -1038,6 +1047,28 @@ bool napi_pp_put_page(netmem_ref netmem)
 	return true;
 }
 EXPORT_SYMBOL(napi_pp_put_page);
+
+/**
+ * napi_pp_get_page - acquire a page_pool reference on a netmem
+ * @netmem: netmem to reference
+ *
+ * Acquires a page_pool reference (pp_ref_count) on @netmem if it belongs to a
+ * page_pool. Counterpart to napi_pp_put_page().
+ *
+ * Return: true if @netmem belongs to a page_pool, false otherwise.
+ */
+bool napi_pp_get_page(netmem_ref netmem)
+{
+	netmem = netmem_compound_head(netmem);
+
+	if (unlikely(!netmem_is_pp(netmem)))
+		return false;
+
+	page_pool_ref_netmem(netmem);
+
+	return true;
+}
+EXPORT_SYMBOL(napi_pp_get_page);
 #endif
 
 static bool skb_pp_recycle(struct sk_buff *skb, void *data)
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index f4c9101e5996a..99d7237a623d8 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -254,6 +254,7 @@
 #include <linux/init.h>
 #include <linux/fs.h>
 #include <linux/skbuff.h>
+#include <linux/skbuff_ref.h>
 #include <linux/splice.h>
 #include <linux/net.h>
 #include <linux/socket.h>
@@ -2559,6 +2560,7 @@ static int tcp_recvmsg_dmabuf(struct sock *sk, const struct sk_buff *skb,
 		 */
 		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
 			skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
+			netmem_ref netmem = skb_frag_netmem(frag);
 			struct net_iov *niov;
 			u64 frag_offset;
 			int end;
@@ -2612,8 +2614,8 @@ static int tcp_recvmsg_dmabuf(struct sock *sk, const struct sk_buff *skb,
 				if (err)
 					goto out;
 
-				atomic_long_inc(&niov->desc.pp_ref_count);
-				tcp_xa_pool.netmems[tcp_xa_pool.idx++] = skb_frag_netmem(frag);
+				WARN_ON_ONCE(!napi_pp_get_page(netmem));
+				tcp_xa_pool.netmems[tcp_xa_pool.idx++] = netmem;
 
 				sent += copy;
 
-- 
2.56.0.212.g129ede20d9-goog

