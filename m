Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B043CD8CA
	for <linux-rdma@vger.kernel.org>; Sat, 10 Oct 2026 08:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791621593; cv=none; b=HzMRRPQ3GPwObPaJsgJQnEWAw+R7JVZZmN3nUg0TxdSMGEJcB1hHEcrTRNUybRCWhwnyL90QPSHoaGTiRK3MTTdPIvAcViOKTMeUPYw+FTTIz99VXxFvhP6TB43UWTQZVEJ6TcjjdTphKps8zJq8gfORvpqHWvkn51CLASo1sYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791621593; c=relaxed/simple;
	bh=qFNEKp34lKsVrt8CzD/Bp8sYPaKmOL2RZgVzpoCQllE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=G3ZpEclGlwd83J+z1nQ8pJkh/1Tq1a22Yv4+rVGDK5X6jUkDc9u4WVx7NdiIGICM+fOwcEFumZj0BG8dyR3AX4kmP/2fvf7QI/jLg29GVMQjgYg/JffW2DPABt/YE/aKohYcB0OwAuAU2TpPL78X9LiWxS7y9Vu/DIHoRw5Zcd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ftuCcnto; arc=none smtp.client-ip=74.125.82.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ftuCcnto"
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-3548cdfd2fbso664971eec.1
        for <linux-rdma@vger.kernel.org>; Sat, 10 Oct 2026 01:39:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791621583; x=1792226383; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3loHobRbvfkA1yU59pzJt/W5AzsqBPJt2rE4wK97BbQ=;
        b=ftuCcntooKGU1tRC+recAbdzXEGhpxij4dMZfmcODcghG3D9WuiYMVUZM1AoXnKXlH
         kjqAcyD1pewCQuTVVePSkLLh8AsSfsiampxjxSDhZ+ulh1ECeNh+qeoY44TiOs4typD6
         DfSTbUcrAW3WKzl/4uPzD0uXRdoHwF+RBT+oIr/S+l3QPXAgytqe99rtj2VdAzNxuP9k
         FCmRCES9MNqjNmTqrF3eT6Hd9NAQjwcHvAwYP83JaEp3OnmNgzYiNGvAhKDWOqo0juqP
         +hZauTukq3z51UV9YooVfI52M2oUTr8/NN2+mZp6FPOebtIVY5K93lnPNLqBjmNFmLGZ
         yn2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791621583; x=1792226383;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3loHobRbvfkA1yU59pzJt/W5AzsqBPJt2rE4wK97BbQ=;
        b=Om4KagvsW4E9yWh2K/nDPKMBJmN1vsBGRE98RRec84/8/cb5jD0OfCqztX0EBvegN/
         s8BafrLAHLPnlwf056qbmV8Fw1z8ifM1y81eSb/Md6AlolKZiwnUtaP7aXQkJIsD+lsL
         2PB63Eo4YFa5JddoTxLpcYvoHeqc8E5Oij7H7wuMze6g7sZbq3qyuUQ7zUgLr95FZEKP
         MfUrwVIfmMS3VXBTBYJFq8r76V58LKaQhRoRMzlvl+DNop4qABQlnKB/mn1sWxo9ru8l
         6MjXA0PEOm4JuKOVdjgs4WWJteFbXR4SipPSwaOlFib15cPYVHcAIiuFR1cqqLtbFJ+I
         7hig==
X-Forwarded-Encrypted: i=1; AKwUvBzw4nWF4A2cQ32t12gMMSyCHTHgxT5ekszBH0VLL19fhSA0QE0Bea+UKLpOmIApqrRBq5d16QPhpO5o@vger.kernel.org
X-Gm-Message-State: AFq9FYJGPa9OHC8/ffdp/qNO1H8JZ+kgJp9xia3BeVNg2QVryzMoxJuG
	Q1hs7gJMwdkobQCBc9YL7P2dOPTS6hT8UoU/pwQY08DNVaUDm7dUj1Y64Bz0rZewM+DpsejVVIc
	TpA2dZQSB5+4hZ5x7LklvJG6I7Q==
X-Received: from dycc24.prod.google.com ([2002:a05:693c:60d8:b0:33e:8d5d:6f5b])
 (user=almasrymina job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:693c:8212:b0:351:b65:63e5 with SMTP id 5a478bee46e88-3537e0587c5mr4987763eec.41.1791621582175;
 Sat, 10 Oct 2026 01:39:42 -0700 (PDT)
Date: Sat, 10 Oct 2026 08:38:47 +0000
In-Reply-To: <20261010083935.3274178-1-almasrymina@google.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20261010083935.3274178-1-almasrymina@google.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261010083935.3274178-7-almasrymina@google.com>
Subject: [PATCH net-next v1 6/6] net: kunit: test netmem, page_pool, and skb
 frag refcounting
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

Verify that non-pp (page._refcount / binding->ref) and page_pool
(pp_ref_count) references stay balanced without cross-counter leaks or
underflows across regular pages, page_pool pages, non-pp net_iovs, and
page_pool net_iovs with both pp_recycle=0 and pp_recycle=1.

Cover get/put_net_iov(), get/put_netmem(), napi_pp_get/put_page(),
skb_netmem_ref/unref(), skb_frag_ref/unref(), pskb_copy(),
skb_zerocopy(), skb_shift(), skb_split(), skb_release_data() (clones,
unclone ordering, pskb_extract(), and skb_morph()), and skb_segment().

Signed-off-by: Mina Almasry <almasrymina@google.com>
---
 net/core/net_test.c | 747 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 747 insertions(+)

diff --git a/net/core/net_test.c b/net/core/net_test.c
index 9c3a590865d26..f9f50f9159902 100644
--- a/net/core/net_test.c
+++ b/net/core/net_test.c
@@ -370,10 +370,757 @@ static void ip_tunnel_flags_test_run(struct kunit *test)
 	KUNIT_ASSERT_TRUE(test, __ipt_flag_op(bitmap_equal, exp, out));
 }
 
+/* Netmem & SKB fragment refcounting */
+
+#include <linux/skbuff_ref.h>
+#include <net/netmem.h>
+#include <net/netdev_rx_queue.h>
+#include <net/page_pool/helpers.h>
+#include <net/page_pool/memory_provider.h>
+#include "devmem.h"
+#include "netmem_priv.h"
+
+static void netmem_ref_test_page(struct kunit *test)
+{
+	struct sk_buff *skb;
+	netmem_ref netmem;
+	struct page *page;
+	int base_ref;
+
+	page = alloc_page(GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, page);
+	netmem = page_to_netmem(page);
+	base_ref = page_ref_count(page);
+
+	/* Layer 1: get_netmem / put_netmem use page non-pp refcount */
+	get_netmem(netmem);
+	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref + 1);
+	put_netmem(netmem);
+	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
+
+#ifdef CONFIG_PAGE_POOL
+	/* Layer 2: napi_pp_get/put_page return false on non-PP page */
+	KUNIT_EXPECT_FALSE(test, napi_pp_get_page(netmem));
+	KUNIT_EXPECT_FALSE(test, napi_pp_put_page(netmem));
+	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
+#endif
+
+	/* Layer 3: skb_netmem_ref / unref fall back to non-pp on non-PP page */
+	skb_netmem_ref(netmem, false);
+	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref + 1);
+	skb_netmem_unref(netmem, false);
+	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
+
+	skb_netmem_ref(netmem, true);
+	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref + 1);
+	skb_netmem_unref(netmem, true);
+	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
+
+	/* Layer 4: skb_frag_ref / skb_frag_unref on non-PP page */
+	skb = alloc_skb(64, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, skb);
+	skb_fill_netmem_desc(skb, 0, netmem, 0, 64);
+
+	skb->pp_recycle = 1;
+	skb_frag_ref(skb, 0);
+	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref + 1);
+	skb_frag_unref(skb, 0);
+	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
+
+	skb_shinfo(skb)->nr_frags = 0;
+	consume_skb(skb);
+	__free_page(page);
+}
+
+#ifdef CONFIG_PAGE_POOL
+static void netmem_ref_test_pp_page(struct kunit *test)
+{
+	struct page_pool_params pp_params = {
+		.order = 0,
+		.pool_size = 4,
+		.nid = NUMA_NO_NODE,
+	};
+	struct page_pool *pool;
+	struct sk_buff *skb, *copy, *clone, *split;
+	netmem_ref netmem;
+	struct page *page;
+	long base_pp_ref;
+	int base_ref;
+
+	pool = page_pool_create(&pp_params);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, pool);
+
+	page = page_pool_dev_alloc_pages(pool);
+	KUNIT_ASSERT_NOT_NULL(test, page);
+	netmem = page_to_netmem(page);
+	base_ref = page_ref_count(page);
+	base_pp_ref = atomic_long_read(&page->pp_ref_count);
+
+	/* Layer 1: get_netmem / put_netmem always use non-pp refcount */
+	get_netmem(netmem);
+	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref + 1);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
+			base_pp_ref);
+	put_netmem(netmem);
+	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
+
+	/* Layer 2: napi_pp_get/put_page use pp_ref_count */
+	KUNIT_EXPECT_TRUE(test, napi_pp_get_page(netmem));
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
+			base_pp_ref + 1);
+	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
+	KUNIT_EXPECT_TRUE(test, napi_pp_put_page(netmem));
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
+			base_pp_ref);
+
+	/* Layer 3: skb_netmem_ref / unref obey recycle flag */
+	skb_netmem_ref(netmem, false);
+	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref + 1);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
+			base_pp_ref);
+	skb_netmem_unref(netmem, false);
+	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
+
+	skb_netmem_ref(netmem, true);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
+			base_pp_ref + 1);
+	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
+	skb_netmem_unref(netmem, true);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
+			base_pp_ref);
+
+	/* Layer 4: skb_frag_ref / skb_frag_unref match on pp_recycle=1 & 0 */
+	skb = alloc_skb(64, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, skb);
+	skb_fill_netmem_desc(skb, 0, netmem, 0, 64);
+	skb->len = 64;
+	skb->data_len = 64;
+
+	skb->pp_recycle = 1;
+	skb_frag_ref(skb, 0);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
+			base_pp_ref + 1);
+	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
+	skb_frag_unref(skb, 0);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
+			base_pp_ref);
+
+	/* pskb_copy on pp_recycle=1 skb propagates pp_recycle & pp_ref_count */
+	copy = pskb_copy(skb, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, copy);
+	KUNIT_EXPECT_TRUE(test, copy->pp_recycle);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
+			base_pp_ref + 1);
+	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
+	consume_skb(copy);
+	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
+			base_pp_ref);
+
+	/* skb_zerocopy on pp_recycle=1 skb propagates pp_ref_count */
+	copy = alloc_skb(0, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, copy);
+	skb_put(copy, skb_tailroom(copy));
+	skb->head_frag = 1;
+	KUNIT_ASSERT_EQ(test, skb_zerocopy(copy, skb, skb->len, 0), 0);
+	skb->head_frag = 0;
+	KUNIT_EXPECT_TRUE(test, copy->pp_recycle);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
+			base_pp_ref + 1);
+	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
+	consume_skb(copy);
+	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
+			base_pp_ref);
+
+	/* skb_clone + pskb_expand_head preserves pp_recycle and pp_ref_count */
+	clone = skb_clone(skb, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, clone);
+	KUNIT_ASSERT_EQ(test, pskb_expand_head(clone, 32, 0, GFP_KERNEL), 0);
+	KUNIT_EXPECT_TRUE(test, clone->pp_recycle);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
+			base_pp_ref + 1);
+	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
+	consume_skb(clone);
+	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
+			base_pp_ref);
+
+	/* skb_split on page_pool frag propagates pp_recycle & balances refs */
+	split = alloc_skb(0, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, split);
+	skb_split(skb, split, 32);
+	KUNIT_EXPECT_TRUE(test, split->pp_recycle);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
+			base_pp_ref + 1);
+	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
+	consume_skb(split);
+	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
+			base_pp_ref);
+
+	/* skb_segment on pp_recycle=1 skb propagates pp_recycle to segments */
+	skb->protocol = htons(ETH_P_IP);
+	skb_reset_network_header(skb);
+	skb_shinfo(skb)->gso_size = 16;
+	split = skb_segment(skb, NETIF_F_SG | NETIF_F_HW_CSUM);
+	KUNIT_ASSERT_FALSE(test, IS_ERR_OR_NULL(split));
+	KUNIT_EXPECT_TRUE(test, split->pp_recycle);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
+			base_pp_ref + 2);
+	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
+	kfree_skb_list(split);
+	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
+			base_pp_ref);
+
+	/* skb_shift balances pp_ref_count on split and merge */
+	skb_fill_netmem_desc(skb, 0, netmem, 0, 64);
+	skb->len = 64;
+	skb->data_len = 64;
+	split = alloc_skb(0, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, split);
+	split->pp_recycle = 1;
+	KUNIT_EXPECT_EQ(test, skb_shift(split, skb, 16), 16);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
+			base_pp_ref + 1);
+	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
+	KUNIT_EXPECT_EQ(test, skb_shift(split, skb, 48), 48);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
+			base_pp_ref);
+	skb_shinfo(split)->nr_frags = 0;
+	consume_skb(split);
+	skb_fill_netmem_desc(skb, 0, netmem, 0, 64);
+	skb->len = 64;
+	skb->data_len = 64;
+
+	skb->pp_recycle = 0;
+	skb_frag_ref(skb, 0);
+	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref + 1);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
+			base_pp_ref);
+	skb_frag_unref(skb, 0);
+	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
+
+	skb_shinfo(skb)->nr_frags = 0;
+	consume_skb(skb);
+	page_pool_put_full_page(pool, page, false);
+	page_pool_destroy(pool);
+}
+#endif
+
+#if defined(CONFIG_PAGE_POOL) && defined(CONFIG_NET_DEVMEM)
+static void dummy_percpu_ref_release(struct percpu_ref *ref)
+{
+}
+
+static void netmem_ref_test_net_iov(struct kunit *test)
+{
+	struct net_devmem_dmabuf_binding binding = {};
+	struct page_pool_params pp_params = {
+		.order = 0,
+		.pool_size = 4,
+		.nid = NUMA_NO_NODE,
+	};
+	struct sk_buff *skb, *clone, *copy;
+	struct page_pool *pool;
+	struct net_iov niov = {};
+	netmem_ref netmem;
+	long base_ref;
+	int err;
+
+	err = percpu_ref_init(&binding.ref, dummy_percpu_ref_release,
+			      PERCPU_REF_INIT_ATOMIC, GFP_KERNEL);
+	KUNIT_ASSERT_EQ(test, err, 0);
+
+	net_iov_init(&niov, &binding.area, NET_IOV_DMABUF);
+	netmem = net_iov_to_netmem(&niov);
+	base_ref = atomic_long_read(&binding.ref.data->count);
+
+	/* Non-PP net_iov: get/put_net_iov & get/put_netmem */
+	get_net_iov(&niov);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&binding.ref.data->count),
+			base_ref + 1);
+	put_net_iov(&niov);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&binding.ref.data->count),
+			base_ref);
+
+	KUNIT_EXPECT_FALSE(test, napi_pp_get_page(netmem));
+	KUNIT_EXPECT_FALSE(test, napi_pp_put_page(netmem));
+
+	skb_netmem_ref(netmem, true);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&binding.ref.data->count),
+			base_ref + 1);
+	skb_netmem_unref(netmem, true);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&binding.ref.data->count),
+			base_ref);
+
+	/* Attach net_iov to a page_pool to test PP net_iov behavior */
+	pool = page_pool_create(&pp_params);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, pool);
+	netmem_set_pp(netmem, pool);
+	netmem_or_pp_magic(netmem, PP_SIGNATURE);
+	atomic_long_set(&niov.desc.pp_ref_count, 2);
+
+	/* Layer 0 & 1: get_net_iov / get_netmem grab non-pp ref even on PP */
+	get_net_iov(&niov);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&binding.ref.data->count),
+			base_ref + 1);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&niov.desc.pp_ref_count), 2L);
+	put_net_iov(&niov);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&binding.ref.data->count),
+			base_ref);
+
+	/* Layer 2: napi_pp_get/put_page use pp_ref_count */
+	KUNIT_EXPECT_TRUE(test, napi_pp_get_page(netmem));
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&niov.desc.pp_ref_count), 3L);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&binding.ref.data->count),
+			base_ref);
+	KUNIT_EXPECT_TRUE(test, napi_pp_put_page(netmem));
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&niov.desc.pp_ref_count), 2L);
+
+	/* Layer 4: skb_frag_ref / skb_frag_unref on PP net_iov */
+	skb = alloc_skb(64, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, skb);
+	skb_fill_netmem_desc(skb, 0, netmem, 0, 64);
+	skb->len = 64;
+	skb->data_len = 64;
+
+	skb->pp_recycle = 1;
+	skb_frag_ref(skb, 0);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&niov.desc.pp_ref_count), 3L);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&binding.ref.data->count),
+			base_ref);
+	skb_frag_unref(skb, 0);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&niov.desc.pp_ref_count), 2L);
+
+	/* pskb_copy on pp_recycle=1 net_iov skb keeps pp_ref_count */
+	copy = pskb_copy(skb, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, copy);
+	KUNIT_EXPECT_TRUE(test, copy->pp_recycle);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&niov.desc.pp_ref_count), 3L);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&binding.ref.data->count),
+			base_ref);
+	consume_skb(copy);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&niov.desc.pp_ref_count), 2L);
+
+	/* skb_zerocopy on pp_recycle=1 net_iov skb keeps pp_ref_count */
+	copy = alloc_skb(0, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, copy);
+	skb_put(copy, skb_tailroom(copy));
+	skb->head_frag = 1;
+	skb->unreadable = 1;
+	KUNIT_ASSERT_EQ(test, skb_zerocopy(copy, skb, skb->len, 0), 0);
+	skb->head_frag = 0;
+	KUNIT_EXPECT_TRUE(test, copy->pp_recycle);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&niov.desc.pp_ref_count), 3L);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&binding.ref.data->count),
+			base_ref);
+	consume_skb(copy);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&niov.desc.pp_ref_count), 2L);
+
+	/* skb_shift balances pp_ref_count on split and merge */
+	copy = alloc_skb(0, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, copy);
+	copy->pp_recycle = 1;
+	KUNIT_EXPECT_EQ(test, skb_shift(copy, skb, 16), 16);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&niov.desc.pp_ref_count), 3L);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&binding.ref.data->count),
+			base_ref);
+	KUNIT_EXPECT_EQ(test, skb_shift(copy, skb, 48), 48);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&niov.desc.pp_ref_count), 2L);
+	skb_shinfo(copy)->nr_frags = 0;
+	consume_skb(copy);
+	skb_fill_netmem_desc(skb, 0, netmem, 0, 64);
+	skb->len = 64;
+	skb->data_len = 64;
+
+	/* Uncloning a cloned pp_recycle=1 net_iov skb keeps pp_ref_count */
+	clone = skb_clone(skb, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, clone);
+	KUNIT_ASSERT_EQ(test, pskb_expand_head(skb, 32, 0, GFP_KERNEL), 0);
+	KUNIT_EXPECT_TRUE(test, skb->pp_recycle);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&niov.desc.pp_ref_count), 3L);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&binding.ref.data->count),
+			base_ref);
+	consume_skb(clone);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&niov.desc.pp_ref_count), 2L);
+
+	skb->pp_recycle = 0;
+	skb_frag_ref(skb, 0);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&binding.ref.data->count),
+			base_ref + 1);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&niov.desc.pp_ref_count), 2L);
+	skb_frag_unref(skb, 0);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&binding.ref.data->count),
+			base_ref);
+
+	skb_shinfo(skb)->nr_frags = 0;
+	consume_skb(skb);
+	netmem_clear_pp_magic(netmem);
+	netmem_set_pp(netmem, NULL);
+	page_pool_destroy(pool);
+	percpu_ref_exit(&binding.ref);
+}
+
+static void netmem_ref_test_release_data(struct kunit *test)
+{
+	struct page_pool_params pp_params = {
+		.order = 0,
+		.pool_size = 4,
+		.nid = NUMA_NO_NODE,
+	};
+	struct sk_buff *skb, *clone1, *clone2, *ext;
+	struct net_devmem_dmabuf_binding binding = {};
+	struct net_iov niov = {};
+	struct page_pool *pool;
+	struct page *page;
+	netmem_ref netmem;
+	long base_pp_ref;
+	int base_ref;
+	int i;
+
+	pool = page_pool_create(&pp_params);
+	KUNIT_ASSERT_FALSE(test, IS_ERR(pool));
+	page = page_pool_dev_alloc_pages(pool);
+	KUNIT_ASSERT_NOT_NULL(test, page);
+	netmem = page_to_netmem(page);
+	page_pool_ref_netmem(netmem);
+
+	/* 3-way clone chain: only last clone drops pp_ref_count */
+	skb = alloc_skb(64, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, skb);
+	skb_put(skb, 32);
+	skb->pp_recycle = 1;
+	skb_fill_netmem_desc(skb, 0, netmem, 0, 64);
+	skb->len += 64;
+	skb->data_len = 64;
+	base_ref = page_ref_count(page);
+	base_pp_ref = atomic_long_read(&page->pp_ref_count);
+
+	page_pool_ref_netmem(netmem);
+	clone1 = skb_clone(skb, GFP_KERNEL);
+	clone2 = skb_clone(clone1, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, clone1);
+	KUNIT_ASSERT_NOT_NULL(test, clone2);
+
+	/* Freeing head skb first leaves clone1/clone2 pp_recycle=1 intact */
+	consume_skb(skb);
+	KUNIT_EXPECT_TRUE(test, clone1->pp_recycle);
+	KUNIT_EXPECT_TRUE(test, clone2->pp_recycle);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
+			base_pp_ref + 1);
+	consume_skb(clone2);
+	KUNIT_EXPECT_TRUE(test, clone1->pp_recycle);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
+			base_pp_ref + 1);
+	consume_skb(clone1);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
+			base_pp_ref);
+
+	/* All 4 combinations of (unclone skb vs clone) x (free order) */
+	for (i = 0; i < 4; i++) {
+		skb = alloc_skb(64, GFP_KERNEL);
+		KUNIT_ASSERT_NOT_NULL(test, skb);
+		skb_put(skb, 32);
+		skb->pp_recycle = 1;
+		skb_fill_netmem_desc(skb, 0, netmem, 0, 64);
+		skb->len += 64;
+		skb->data_len = 64;
+		page_pool_ref_netmem(netmem);
+
+		clone1 = skb_clone(skb, GFP_KERNEL);
+		KUNIT_ASSERT_NOT_NULL(test, clone1);
+		KUNIT_ASSERT_EQ(test,
+				pskb_expand_head((i & 1) ? clone1 : skb,
+						 32, 0, GFP_KERNEL), 0);
+		KUNIT_EXPECT_TRUE(test, skb->pp_recycle);
+		KUNIT_EXPECT_TRUE(test, clone1->pp_recycle);
+		KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
+				base_pp_ref + 2);
+		KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
+
+		if (i & 2) {
+			consume_skb(clone1);
+			KUNIT_EXPECT_EQ(test,
+					atomic_long_read(&page->pp_ref_count),
+					base_pp_ref + 1);
+			consume_skb(skb);
+		} else {
+			consume_skb(skb);
+			KUNIT_EXPECT_EQ(test,
+					atomic_long_read(&page->pp_ref_count),
+					base_pp_ref + 1);
+			consume_skb(clone1);
+		}
+		KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
+				base_pp_ref);
+		KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
+	}
+
+	/* pskb_extract carving inside header & inside nonlinear frags */
+	skb = alloc_skb(64, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, skb);
+	skb_put(skb, 32);
+	skb->pp_recycle = 1;
+	skb_fill_netmem_desc(skb, 0, netmem, 0, 64);
+	skb->len += 64;
+	skb->data_len = 64;
+	page_pool_ref_netmem(netmem);
+
+	/* Carve inside header keeping frag -> pp_ref_count +1 until free */
+	ext = pskb_extract(skb, 16, skb->len - 16, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, ext);
+	KUNIT_EXPECT_TRUE(test, ext->pp_recycle);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
+			base_pp_ref + 2);
+	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
+	consume_skb(ext);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
+			base_pp_ref + 1);
+
+	/* Carve + trim + skb_condense ref/unrefs pp_ref_count cleanly */
+	ext = pskb_extract(skb, 16, 48, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, ext);
+	KUNIT_EXPECT_TRUE(test, ext->pp_recycle);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
+			base_pp_ref + 1);
+	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
+	consume_skb(ext);
+
+	/* Carve inside nonlinear keeping frag -> pp_ref_count +1 until free */
+	ext = pskb_extract(skb, 48, skb->len - 48, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, ext);
+	KUNIT_EXPECT_TRUE(test, ext->pp_recycle);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
+			base_pp_ref + 2);
+	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
+	consume_skb(ext);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
+			base_pp_ref + 1);
+
+	/* skb_morph drops old skb data via skb_release_data */
+	page_pool_ref_netmem(netmem);
+	clone1 = alloc_skb(64, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, clone1);
+	clone1->pp_recycle = 1;
+	skb_fill_netmem_desc(clone1, 0, netmem, 0, 64);
+	clone1->len = 64;
+	clone1->data_len = 64;
+	skb_morph(clone1, skb);
+	KUNIT_EXPECT_TRUE(test, clone1->pp_recycle);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
+			base_pp_ref + 1);
+	consume_skb(clone1);
+	kfree_skb(skb);
+	page_pool_put_full_page(pool, page, false);
+	page_pool_put_full_page(pool, page, false);
+
+	/* Also verify pskb_extract on page_pool net_iov */
+	KUNIT_ASSERT_EQ(test,
+			percpu_ref_init(&binding.ref, dummy_percpu_ref_release,
+					PERCPU_REF_INIT_ATOMIC, GFP_KERNEL),
+			0);
+	net_iov_init(&niov, &binding.area, NET_IOV_DMABUF);
+	netmem = net_iov_to_netmem(&niov);
+	netmem_set_pp(netmem, pool);
+	netmem_or_pp_magic(netmem, PP_SIGNATURE);
+	atomic_long_set(&niov.desc.pp_ref_count, 2);
+
+	skb = alloc_skb(64, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, skb);
+	skb_put(skb, 32);
+	skb->pp_recycle = 1;
+	skb_fill_netmem_desc(skb, 0, netmem, 0, 64);
+	skb->len += 64;
+	skb->data_len = 64;
+
+	ext = pskb_extract(skb, 48, skb->len - 48, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, ext);
+	KUNIT_EXPECT_TRUE(test, ext->pp_recycle);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&niov.desc.pp_ref_count), 3L);
+	consume_skb(ext);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&niov.desc.pp_ref_count), 2L);
+
+	skb_shinfo(skb)->nr_frags = 0;
+	consume_skb(skb);
+	netmem_clear_pp_magic(netmem);
+	netmem_set_pp(netmem, NULL);
+	page_pool_destroy(pool);
+	percpu_ref_exit(&binding.ref);
+}
+
+static void netmem_ref_test_skb_segment(struct kunit *test)
+{
+	struct page_pool_params pp_params = {
+		.order = 0,
+		.pool_size = 4,
+		.nid = NUMA_NO_NODE,
+	};
+	struct sk_buff *head, *list, *segs, *seg;
+	struct net_devmem_dmabuf_binding binding = {};
+	struct net_iov niov = {};
+	struct page *pp_page, *reg_page;
+	netmem_ref pp_nm, niov_nm;
+	struct page_pool *pool;
+	long base_pp_ref, base_iov_ref;
+	int base_pp_page_ref, base_reg_ref;
+
+	pool = page_pool_create(&pp_params);
+	KUNIT_ASSERT_FALSE(test, IS_ERR(pool));
+	pp_page = page_pool_dev_alloc_pages(pool);
+	KUNIT_ASSERT_NOT_NULL(test, pp_page);
+	pp_nm = page_to_netmem(pp_page);
+	page_pool_ref_netmem(pp_nm);
+	reg_page = alloc_page(GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, reg_page);
+
+	KUNIT_ASSERT_EQ(test,
+			percpu_ref_init(&binding.ref, dummy_percpu_ref_release,
+					PERCPU_REF_INIT_ATOMIC, GFP_KERNEL),
+			0);
+	net_iov_init(&niov, &binding.area, NET_IOV_DMABUF);
+	niov_nm = net_iov_to_netmem(&niov);
+	netmem_set_pp(niov_nm, pool);
+	netmem_or_pp_magic(niov_nm, PP_SIGNATURE);
+	atomic_long_set(&niov.desc.pp_ref_count, 2);
+
+	base_pp_ref = atomic_long_read(&pp_page->pp_ref_count);
+	base_pp_page_ref = page_ref_count(pp_page);
+	base_reg_ref = page_ref_count(reg_page);
+	base_iov_ref = atomic_long_read(&binding.ref.data->count);
+
+	/* 1. Single GSO skb with page_pool net_iov frags */
+	head = alloc_skb(64, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, head);
+	head->pp_recycle = 1;
+	head->protocol = htons(ETH_P_IP);
+	skb_reset_mac_header(head);
+	skb_reset_network_header(head);
+	skb_fill_netmem_desc(head, 0, niov_nm, 0, 64);
+	head->len = 64;
+	head->data_len = 64;
+	skb_shinfo(head)->gso_size = 16;
+
+	segs = skb_segment(head, NETIF_F_SG | NETIF_F_HW_CSUM);
+	KUNIT_ASSERT_FALSE(test, IS_ERR_OR_NULL(segs));
+	for (seg = segs; seg; seg = seg->next)
+		KUNIT_EXPECT_TRUE(test, seg->pp_recycle);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&niov.desc.pp_ref_count), 6L);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&binding.ref.data->count),
+			base_iov_ref);
+	kfree_skb_list(segs);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&niov.desc.pp_ref_count), 2L);
+	skb_shinfo(head)->nr_frags = 0;
+	consume_skb(head);
+
+	/* 2. GRO frag_list fast path (skb_clone of pp_recycle=1 list_skb) */
+	head = alloc_skb(64, GFP_KERNEL);
+	list = alloc_skb(64, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, head);
+	KUNIT_ASSERT_NOT_NULL(test, list);
+	head->pp_recycle = 1;
+	list->pp_recycle = 1;
+	head->protocol = htons(ETH_P_IP);
+	skb_reset_mac_header(head);
+	skb_reset_network_header(head);
+	skb_put(head, 16);
+	skb_fill_netmem_desc(head, 0, pp_nm, 0, 16);
+	head->len += 16;
+	head->data_len = 16;
+	page_pool_ref_netmem(pp_nm);
+
+	skb_put(list, 16);
+	skb_fill_netmem_desc(list, 0, pp_nm, 16, 16);
+	list->len += 16;
+	list->data_len = 16;
+	page_pool_ref_netmem(pp_nm);
+
+	skb_shinfo(head)->frag_list = list;
+	head->len += list->len;
+	head->data_len += list->len;
+	skb_shinfo(head)->gso_size = 32;
+
+	segs = skb_segment(head, NETIF_F_SG | NETIF_F_HW_CSUM);
+	KUNIT_ASSERT_FALSE(test, IS_ERR_OR_NULL(segs));
+	for (seg = segs; seg; seg = seg->next)
+		KUNIT_EXPECT_TRUE(test, seg->pp_recycle);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&pp_page->pp_ref_count),
+			base_pp_ref + 4);
+	KUNIT_EXPECT_EQ(test, page_ref_count(pp_page), base_pp_page_ref);
+	kfree_skb_list(segs);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&pp_page->pp_ref_count),
+			base_pp_ref + 2);
+	consume_skb(head);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&pp_page->pp_ref_count),
+			base_pp_ref);
+
+	/* 3. Mixed GRO frag_list: head pp_page + list reg_page */
+	head = alloc_skb(64, GFP_KERNEL);
+	list = alloc_skb(0, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, head);
+	KUNIT_ASSERT_NOT_NULL(test, list);
+	head->pp_recycle = 1;
+	list->pp_recycle = 0;
+	head->protocol = htons(ETH_P_IP);
+	skb_reset_mac_header(head);
+	skb_reset_network_header(head);
+	skb_fill_netmem_desc(head, 0, pp_nm, 0, 24);
+	head->len = 24;
+	head->data_len = 24;
+	page_pool_ref_netmem(pp_nm);
+
+	skb_fill_page_desc(list, 0, reg_page, 0, 24);
+	get_page(reg_page);
+	list->len = 24;
+	list->data_len = 24;
+
+	skb_shinfo(head)->frag_list = list;
+	head->len += list->len;
+	head->data_len += list->len;
+	skb_shinfo(head)->gso_size = 16;
+
+	/* Segment 0: [pp_page:16], Segment 1: [pp_page:8 + reg_page:8],
+	 * Segment 2: [reg_page:16]. Freeing all segments restores exact refs!
+	 */
+	segs = skb_segment(head, NETIF_F_SG | NETIF_F_HW_CSUM);
+	KUNIT_ASSERT_FALSE(test, IS_ERR_OR_NULL(segs));
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&pp_page->pp_ref_count),
+			base_pp_ref + 3);
+	KUNIT_EXPECT_EQ(test, page_ref_count(pp_page), base_pp_page_ref);
+	KUNIT_EXPECT_EQ(test, page_ref_count(reg_page), base_reg_ref + 3);
+	kfree_skb_list(segs);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&pp_page->pp_ref_count),
+			base_pp_ref + 1);
+	KUNIT_EXPECT_EQ(test, page_ref_count(pp_page), base_pp_page_ref);
+	KUNIT_EXPECT_EQ(test, page_ref_count(reg_page), base_reg_ref + 1);
+
+	consume_skb(head);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&pp_page->pp_ref_count),
+			base_pp_ref);
+	page_pool_put_full_page(pool, pp_page, false);
+	page_pool_put_full_page(pool, pp_page, false);
+	__free_page(reg_page);
+	netmem_clear_pp_magic(niov_nm);
+	netmem_set_pp(niov_nm, NULL);
+	page_pool_destroy(pool);
+	percpu_ref_exit(&binding.ref);
+}
+#endif
+
 static struct kunit_case net_test_cases[] = {
 	KUNIT_CASE_PARAM(gso_test_func, gso_test_gen_params),
 	KUNIT_CASE_PARAM(ip_tunnel_flags_test_run,
 			 ip_tunnel_flags_test_gen_params),
+	KUNIT_CASE(netmem_ref_test_page),
+#ifdef CONFIG_PAGE_POOL
+	KUNIT_CASE(netmem_ref_test_pp_page),
+#endif
+#if defined(CONFIG_PAGE_POOL) && defined(CONFIG_NET_DEVMEM)
+	KUNIT_CASE(netmem_ref_test_net_iov),
+	KUNIT_CASE(netmem_ref_test_release_data),
+	KUNIT_CASE(netmem_ref_test_skb_segment),
+#endif
 	{ },
 };
 
-- 
2.56.0.385.gd3acb90ef8-goog

