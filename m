Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5188F463B7A
	for <linux-rdma@vger.kernel.org>; Mon, 12 Oct 2026 08:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791793315; cv=none; b=LiNpe9OMzXjiVeFew83hzPLSzPyxWn+AnOIJZynEchy38fpVpcLFnt68p9XLpt/ueZ/A1vMw3rF2Xvz8L6SoS+Y6dZu08SFvcUCYNBeA2OlWCyLVRJyJvlvUcRPK4eBqvJHLRfwkivYZTws5Wl0czMy0VJrKOqDD5Id2pEFA9MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791793315; c=relaxed/simple;
	bh=bc79cWL/iIehkTgnl6Tjyj58erMfGdnnWANb1fgE4FA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SGfhpRAE7502489Nvmrdx3wwaHICQgWhqK6DaGE5b2KkH95Ph6zzRPqIqVV7SK7Nbu202bddBnk1LWrqIbzG3SMM9cZAYrjKKHWSeX9+CTYrVD/BVZih2bTh89X7ijFiFETzfUEoEXP/GmPpI2LWK6q3QjrsBLu0PYux4xhTjGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RSnsbabA; arc=none smtp.client-ip=74.125.82.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RSnsbabA"
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-3552883bd19so3344669eec.1
        for <linux-rdma@vger.kernel.org>; Mon, 12 Oct 2026 01:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791793313; x=1792398113; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n6PaoBpF/oU1lyDxuw5ArpSGaAVMPVuclWNjmn/THuY=;
        b=RSnsbabA4dXa++OWLb/H1MQPuIJ2gjDSMEN5qkLmkN7/+wOR80kaChMqD4x+HBxx3v
         QNxCAcD4TbyFBYumD1ieglB2KF3bvdESaVT4eNhB9NLTABACLGh/+d3A0dbos+TEg5ck
         7XBri+5lwUl9LBiipILoDemqF7jSivP5VKVpciZIG4xeg3iShy+UP2/EWFy0zmHc9DK0
         Jx3eZymePoS6bg6Z27cC/7HXtzyIGBUj4x0F1MTsecmA1/HDf+gczk9HBZxZILYrqV6O
         wAomrzEuAFIpNMHegIPqn493bLbarWuI4FeXvIm8YB377bUyYFBt3SR7uO3CJ5ZTsyGV
         dNMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791793313; x=1792398113;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=n6PaoBpF/oU1lyDxuw5ArpSGaAVMPVuclWNjmn/THuY=;
        b=YPai77eqgNk3k6gMVZMyrc+NUgbLiWT28Q253zyb+8vvws4gHFW0tXwQDVZKQxCpQl
         jGM+EqrUWD3ML2OpXIiXgD0bRcMKLWcYzE6xbGrX9U95pp52xwX1Qx/Cdj7NNmYrR2B2
         ukpPMKq+awCRqM2ISK6xnvuoyhQL0ZXev06Rg0+7abYruQOux4RuiI2Ck/1E7fqk2V2b
         GkFN1yVnC2wToojBfmXIne79ec99sW+O2i6/gkwwiEErdLecJ1NyZh3/Tppt/oj3TCGB
         Tk6I9DVOAp9lpOCAkYB1crJnXyFFuDcWf7kc99RmE85UKQrkCDMxL6APLxgebA+RN8M3
         oe3w==
X-Forwarded-Encrypted: i=1; AKwUvBzz2Ybkfw7NobzG1UKQK4HeM72pI7qc6IyrmPLN6kRuHvSpJ1CgNp+UBh/gKI73uZhPv9hwxYn5RRZf@vger.kernel.org
X-Gm-Message-State: AFq9FYIyHVmMwj5s1qZSuOh2k2nSHuZJ0ZmVlkqVNZNMpXkm+SyhnfLD
	x4N6pFu6gC5mIgf5ymQUehJ0wQvh4iml85cwEWZJ1LV7MZ9wOikSPg8wuQ5lK5D0rX+oc0eBMKN
	NXbDBbt/6pLbbJa1eL0IMlBH55A==
X-Received: from dybcl20.prod.google.com ([2002:a05:7300:a994:b0:34e:b472:7322])
 (user=almasrymina job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7301:1929:b0:351:7ec0:daa3 with SMTP id 5a478bee46e88-3537e04eeb2mr12843933eec.31.1791793311570;
 Mon, 12 Oct 2026 01:21:51 -0700 (PDT)
Date: Mon, 12 Oct 2026 08:21:44 +0000
In-Reply-To: <20261012082148.1698596-1-almasrymina@google.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20261012082148.1698596-1-almasrymina@google.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261012082148.1698596-3-almasrymina@google.com>
Subject: [PATCH net-next v2 2/6] net: skbuff: add napi_pp_get_page() and use
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
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>, 
	"=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20=28The=20Capable=20Hub=29?=" <u.kleine-koenig@baylibre.com>, Jijie Shao <shaojijie@huawei.com>, 
	Michael Grzeschik <mgr@kernel.org>, Jakub Raczynski <j.raczynski@samsung.com>
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

