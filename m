Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B7D23B83FE
	for <linux-rdma@vger.kernel.org>; Sat, 10 Oct 2026 08:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791621581; cv=none; b=Vk33xiVeSsKwlgcQ/rvaXIZD0NE9P+ta6XtKISlRoeNMgCiUgUejvonQTCwYF4Hw2KNM34ubeAzaONUDpShBMZ7QX/rKMJRDN94AgtIKlNyUH0Za73qeQQjzarC0lYlL9S1kiF7DsQEJPN4HsNORwCOPIyxKk833MTNA+VwcKjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791621581; c=relaxed/simple;
	bh=c4i6mi3hlpud4ggYzlYd71WHusW0w0pU98zmW2ROBu8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XsFWfZhDchhwxruiZgwD9Y4MuFTtA7pj+BeYoH8s0yVPvMbWwgfQczWtwE6ixcGjvkvZp9A5z/4B+sUH80b6TgLY3Kuh2FrWRBIqjd6z/fGoQ4ZO0rkvwGHlpXwlF9YdLSM56BfNvjH9X7Eth/2dozSUaVU+yTeWG50kk9EFc/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ok+GrNS8; arc=none smtp.client-ip=74.125.82.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ok+GrNS8"
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-3548cdfd2fbso664753eec.1
        for <linux-rdma@vger.kernel.org>; Sat, 10 Oct 2026 01:39:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791621577; x=1792226377; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lHcZnhc3QYZQ2/oBZUUaxlLCVCxGa2In7CH7r+34iGA=;
        b=Ok+GrNS8Y6mqZFXOGu2tI+Ipn9Oaw1NOXxHv/R3bCRjwf2VIYL4wXuH2ukDmQ7cqcy
         zVIxQu3xLZ0khGcsrw5Q290xOqiFL8Wov3uS0uej/yHDq0SAnyZNAwWaFI/09FRrQiqf
         IrPSCkNPc8dQDMv93KmdkOfUoZ0ky8tmocTO4dez2wwxbn5JeyQK1HI6L7BrvIzcAYUZ
         6cNKsTPaSZtao6qmBqSMIHpD+HN+8VOu1gfX5oqrV2VwASzB6r9xmKAwdCfeOdpm71FL
         o7Xa1NosM3mQYqMNXRzSTLd62pIH6p/rxzryZ+V3CnfthZGjc2ONY1QrQ49cc2RV1XYB
         NFtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791621577; x=1792226377;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lHcZnhc3QYZQ2/oBZUUaxlLCVCxGa2In7CH7r+34iGA=;
        b=qeCnu8l4LP+TIUBA84rsjb2TORRhAlmdoaDLAOC1Kpd/ZY7IeW6dELp8oXOzy2BqMc
         bFioTCo6RjnMXmh6Kx2NOjXTucItvGP7ecc9SIQ+LWSxMLALPYUWLTz5ge+bhNLq+aZ7
         T70M3uRbdSkCh7svopJ0HyYMPn0e81mEyBnjYtWypnhl6f1PTvAeHoJ4VYZL13ME8/rU
         qJ4fZ66cnTtRbkRdSVysPfyZlACNopULItOX8lg9tKXGu3k97PS7gOC6+43CRh+nfV1C
         pEldcNNIpRtletRyywMW7Npbj2ZRcFp9n5L4X6oKeorF0uqH7u8u30WLLJmJkg1Fbpvp
         FNDg==
X-Forwarded-Encrypted: i=1; AKwUvBx0gb3krZ5GpkMr3/BOarLfYKKYxOzo6+7JlzJFBVG90BgiZ4fhzNdwUw/DnpVKrqB/vHkTJq9VW2vO@vger.kernel.org
X-Gm-Message-State: AFq9FYKoF8EyLSfnKsLbAbFL+rvemB8utx2KwElXA20uWUNA9F6GYTO2
	7RbkHov/C9YR2TVZmBvTbJQ1q+gM3/zJXvqTZd2Oe930l033W6VEthooxyIvM4hVW+FPon9f9f0
	tqK7w0AgquH/Lyx0KRUm5I2RNdg==
X-Received: from dybqm7.prod.google.com ([2002:a05:7301:6707:b0:351:5787:a37a])
 (user=almasrymina job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:693c:6394:10b0:34a:48ce:b687 with SMTP id 5a478bee46e88-3537e010c56mr5272905eec.32.1791621576769;
 Sat, 10 Oct 2026 01:39:36 -0700 (PDT)
Date: Sat, 10 Oct 2026 08:38:42 +0000
In-Reply-To: <20261010083935.3274178-1-almasrymina@google.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20261010083935.3274178-1-almasrymina@google.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261010083935.3274178-2-almasrymina@google.com>
Subject: [PATCH net-next v1 1/6] netmem: rename __get/__put_netmem() to get/put_net_iov()
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

netmems carry both a non-pp backing refcount and a page_pool
pp_ref_count. Make the non-pp layer explicit and symmetric across both
netmem types: get/put_netmem() dispatches to get/put_page() for pages
and get/put_net_iov() for net_iovs, always acquiring or releasing a
non-pp reference regardless of page_pool membership.

Warn via DEBUG_NET_WARN_ON_ONCE() for net_iov types that do not support
non-pp references.

Signed-off-by: Mina Almasry <almasrymina@google.com>
---
 include/net/netmem.h | 24 ++++++++++++++++++++----
 net/core/skbuff.c    | 36 ++++++++++++++++++++++++++----------
 2 files changed, 46 insertions(+), 14 deletions(-)

diff --git a/include/net/netmem.h b/include/net/netmem.h
index 0cc8572f62caf..697d50c51a5ee 100644
--- a/include/net/netmem.h
+++ b/include/net/netmem.h
@@ -399,21 +399,37 @@ static inline bool net_is_devmem_iov(const struct net_iov *niov)
 }
 #endif
 
-void __get_netmem(netmem_ref netmem);
-void __put_netmem(netmem_ref netmem);
+void get_net_iov(struct net_iov *niov);
+void put_net_iov(struct net_iov *niov);
 
+/**
+ * get_netmem - acquire a non-page_pool reference on a netmem
+ * @netmem: netmem to reference
+ *
+ * Acquires a non-pp backing reference (page._refcount via get_page() or
+ * binding->ref via get_net_iov()) regardless of page_pool membership.
+ * Counterpart to put_netmem().
+ */
 static __always_inline void get_netmem(netmem_ref netmem)
 {
 	if (netmem_is_net_iov(netmem))
-		__get_netmem(netmem);
+		get_net_iov(netmem_to_net_iov(netmem));
 	else
 		get_page(netmem_to_page(netmem));
 }
 
+/**
+ * put_netmem - release a non-page_pool reference on a netmem
+ * @netmem: netmem to unreference
+ *
+ * Drops a non-pp backing reference (page._refcount via put_page() or
+ * binding->ref via put_net_iov()) regardless of page_pool membership.
+ * Counterpart to get_netmem().
+ */
 static __always_inline void put_netmem(netmem_ref netmem)
 {
 	if (netmem_is_net_iov(netmem))
-		__put_netmem(netmem);
+		put_net_iov(netmem_to_net_iov(netmem));
 	else
 		put_page(netmem_to_page(netmem));
 }
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index d56f4f0102f75..b459264ba5180 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -7551,23 +7551,39 @@ bool csum_and_copy_from_iter_full(void *addr, size_t bytes,
 }
 EXPORT_SYMBOL(csum_and_copy_from_iter_full);
 
-void __get_netmem(netmem_ref netmem)
+/**
+ * get_net_iov - acquire a non-page_pool reference on a net_iov
+ * @niov: net_iov to reference
+ *
+ * Acquires a non-pp backing reference (binding->ref) on @niov regardless of
+ * page_pool membership, warning if @niov does not support non-pp references.
+ * Counterpart to put_net_iov().
+ */
+void get_net_iov(struct net_iov *niov)
 {
-	struct net_iov *niov = netmem_to_net_iov(netmem);
-
 	if (net_is_devmem_iov(niov))
-		net_devmem_get_net_iov(netmem_to_net_iov(netmem));
+		net_devmem_get_net_iov(niov);
+	else
+		DEBUG_NET_WARN_ON_ONCE(true);
 }
-EXPORT_SYMBOL(__get_netmem);
+EXPORT_SYMBOL(get_net_iov);
 
-void __put_netmem(netmem_ref netmem)
+/**
+ * put_net_iov - release a non-page_pool reference on a net_iov
+ * @niov: net_iov to unreference
+ *
+ * Drops a non-pp backing reference (binding->ref) on @niov regardless of
+ * page_pool membership, warning if @niov does not support non-pp references.
+ * Counterpart to get_net_iov().
+ */
+void put_net_iov(struct net_iov *niov)
 {
-	struct net_iov *niov = netmem_to_net_iov(netmem);
-
 	if (net_is_devmem_iov(niov))
-		net_devmem_put_net_iov(netmem_to_net_iov(netmem));
+		net_devmem_put_net_iov(niov);
+	else
+		DEBUG_NET_WARN_ON_ONCE(true);
 }
-EXPORT_SYMBOL(__put_netmem);
+EXPORT_SYMBOL(put_net_iov);
 
 struct vlan_type_depth __vlan_get_protocol_offset(const struct sk_buff *skb,
 						  __be16 type,
-- 
2.56.0.385.gd3acb90ef8-goog

