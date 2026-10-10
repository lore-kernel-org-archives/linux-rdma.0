Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F58C3C13E5
	for <linux-rdma@vger.kernel.org>; Sat, 10 Oct 2026 08:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791621583; cv=none; b=qRDeizJCaMzdWU+XLZCGncYLVCiz97M0CfmNYxuh9Bmu+SdSgArDXJbsG70KfjzeyHqtbu0AOBi7WSMkWYr2pSjupLUrKH+NeitN3AU5V1UW62gdLiJYgWweKulADpNoCWmI65l+qiOMKYatKulgQzijMbLotUgTmO6xFK5FjmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791621583; c=relaxed/simple;
	bh=/LLvU+5AnYzTjy57lN2tpyIzvmdHROTfxW0jkjFEfuA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=S9Stmm/1wAPISZ+SAdwjQU1Iwqx6lYx43jWwKoQtqqiYqLB7aVaTORPoqDzdsQZE2rhpIEvQNSm3j5+bzE9NWSXWxh7qwnRKn9FAAOKZ8u4lJM7NqYRgLT8hOrBfbf+ifEomxKvs7EG/DT+U+XjNSHzfWq0eT573SJ2t1rz7kJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WkpQltvA; arc=none smtp.client-ip=74.125.82.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WkpQltvA"
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-358856e5105so1349662eec.0
        for <linux-rdma@vger.kernel.org>; Sat, 10 Oct 2026 01:39:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791621578; x=1792226378; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oMs6zujZVOhihfnpjH1h+iJn7PnD9P9Ohm7NiW91TsM=;
        b=WkpQltvAgvFBjLXXQ3NHIPW4Zu+RAvQLs+DwHiJKJ8x8GcBLq1RM6smhbmDSm3vYvM
         MW3pIj2Wa17I1BYTkgkSOPXLrkxIC40pcu4WCe1fQMNa72VWjUgtzs6lkt5Gg/DK/63x
         pyThSbGXj+KxGnb9Ai1LtUK8lZXtcrT6KLCUb7pQxGuUWdUh09nNXhtLVXq0UAdxo4ze
         stLUcKzueAjLOOq7LeV1O4D1SFj48bWlmX/nx9O5caRYVtH3upzM5doICrxfYq+T6g9A
         SmKl06t3myjyImFDmso/sFA1v8H5ZXqCTu0u6lPhjOdh7I/A9a2bQI9ZIY29e9PGTq+z
         gBeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791621578; x=1792226378;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oMs6zujZVOhihfnpjH1h+iJn7PnD9P9Ohm7NiW91TsM=;
        b=nWEdj2DClNEJtReeFeoLB/WgIQHUB76Z5FqvUsMFBW3bZFwLv9vtLZZquNY7KXV27K
         vyChYcDheBBZ7Mjj6UtpnhY2x/MaDPk7zW8NA2K/3uv6AEUjV/UDALk7AzTWSRIHP1Mw
         GqmPk2hViJ/AjKFQfhHf0sbKYOq7p6fPRtIBa3tWBRnfxhE66nIMDIu+5jNQC9NuyejW
         wuny5zh/dB0dMwV1VygRx6J4vTsiDORk/85CrZO4ShdI68NCaOrKAh5r8cRVdLMvwATf
         qZ8W7BgPP4rX/f5NSURiEGmYUEOPUshvxSab15XNB2x2qTcdLMTNtGEpCJKx5dYgyfl4
         1nWQ==
X-Forwarded-Encrypted: i=1; AKwUvByahi4xiO/DZKO8zNVNEfvlQNL/R9s9ommjKsuejmAJm4zHFYx9AZxuOkimW5Dm6TliSkKvfpF30khr@vger.kernel.org
X-Gm-Message-State: AFq9FYLmBJJtqHQ/NHlTYwQFSuBR2FSwANyLHdDQVn0AzkAW/iyCdhY4
	1VNNVxe6biWgzPdquGN5Qi3emp5i4gcNqsucVrsMCeyqH1yUrSD6jFRzKUOOATmTgyo2uVT2dA1
	60NazlGMq4FLhHV1tSe21BUEgpg==
X-Received: from dycc9.prod.google.com ([2002:a05:693c:60c9:b0:351:4a84:2505])
 (user=almasrymina job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7301:1a05:b0:358:eccb:af7c with SMTP id 5a478bee46e88-358eccbc89dmr38890eec.33.1791621577801;
 Sat, 10 Oct 2026 01:39:37 -0700 (PDT)
Date: Sat, 10 Oct 2026 08:38:43 +0000
In-Reply-To: <20261010083935.3274178-1-almasrymina@google.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20261010083935.3274178-1-almasrymina@google.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261010083935.3274178-3-almasrymina@google.com>
Subject: [PATCH net-next v1 2/6] net: skbuff: add napi_pp_get_page() and use
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
	Michael Grzeschik <mgr@kernel.org>, 
	"=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20=28The=20Capable=20Hub=29?=" <u.kleine-koenig@baylibre.com>, Petr Machata <petrm@nvidia.com>, 
	Arend van Spriel <arend.vanspriel@broadcom.com>, Jakub Raczynski <j.raczynski@samsung.com>
Content-Type: text/plain; charset="UTF-8"

While napi_pp_put_page() releases a page_pool pp_ref_count reference on
a netmem, no symmetric helper existed to acquire one, forcing callers
like tcp_recvmsg_dmabuf() to open-code atomic_long_inc() on
niov->desc.pp_ref_count.

Add napi_pp_get_page() to pair symmetrically with napi_pp_put_page(),
and use WARN_ON_ONCE(!napi_pp_get_page(netmem)) in tcp_recvmsg_dmabuf()
to match WARN_ON_ONCE(!napi_pp_put_page(netmem)) in
tcp_release_user_frags().

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
index b459264ba5180..8a8be746828db 100644
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
2.56.0.385.gd3acb90ef8-goog

