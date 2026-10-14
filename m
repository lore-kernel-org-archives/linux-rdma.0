Received: from mail-dl1-f71.google.com (mail-dl1-f71.google.com [74.125.82.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C41F568FB1
	for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 17:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791999605; cv=none; b=PzKA3Tm9A+M7wM4UNRWKLO83RNnbp3/NkILlTLnFApUcET0jG4keBsK4q1tiEYFatnuYI5mEz+JMMPtgTJFIxRcxVjV4/CuN8OSpnrEr20Amhnp75/ILwTH8A5U6gJ/k/RShWafIfF2ZeCDhI9kDFkm4SoHGiHnFLnWa50vg3J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791999605; c=relaxed/simple;
	bh=sZYeIwka7I/9u9LERwfuX5ZCRZfbsawrdzICLzM7Aro=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ddOHi48gh2HlJJIG5Rt5AohQLNhf+kTYVdYcrZ9M8eaY+COrc7Lqjt5XKBKD61SyjhPVKzh6vBUNQolLt7yP5rXteMlmqrd+agAu3ucHrDc6A/tMefU8Kp7pcqHrEqI94fkl0OzL3D6vtfNxTv6iuO99IO2tsURQGtN36wXIKoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WiyeZott; arc=none smtp.client-ip=74.125.82.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WiyeZott"
Received: by mail-dl1-f71.google.com with SMTP id a92af1059eb24-1665200f4c2so6090999c88.0
        for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 10:39:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791999593; x=1792604393; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9IjxLeer/7HJJ8ZbaRpxiUpKymmzQrk4Ri7IZBUCx1g=;
        b=WiyeZottaBmgBYom5ibocXPVauZ9X9VUzTrZuPpsYg+I3wa6w+YLpFinyPwWPVuFGB
         Xc9AOJwhVR+VX9US6Z5N0/dgft89Rl48RNxmggwYh/aIWOAyGZnxZR+gREOkTOZXqFVm
         7/MUD04QaGGw8B1Yrb6gZpEAsPML5ZSKW/ve02Wpb8n2Bc/qOi6KeHwmMUkyPY1qA2gC
         nutqZkZujhVyo6xYBV88sgvOsET3TXzkAQqgE/gS4/0CQ/w+5SMt2GaBkeJCkzi2zmLD
         hZLoIFXPUDQB6Ot9FTZqD/hTHiWZCQuK7d+iisoY0XvXfv8kFEvdxGTgP4qWNkvSaD9c
         Ub3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791999593; x=1792604393;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9IjxLeer/7HJJ8ZbaRpxiUpKymmzQrk4Ri7IZBUCx1g=;
        b=hg1Ju4UHZciNZIASgHmb9kNzpPty+Q1MQI3FXsWTRX9ZL5uFGAEIcWj6uloa2KthBe
         spGP1TS22nyaaU3+mhqCI+n7v1fb2b6ZCE/WJT6vnp0bVflC7Kg4Vsuwv1W55Q3f/Yrj
         B9KlJdJDtNoCBxG/rSDQxjHCxSFnLhF1B/k3OI589t8uI0ZlTwDwlDakPx1qER1cAvVA
         HOptwVLujlzmWYDsPA+m//lZwa37cgrDLr/23bEzMMCXnc/8X2qPwxm8edyUzUC2d4Hq
         AzjTLMKZm40FTC6YE5etlvDCcUA17F6jmbQo1WUTFU9JSMfTgoogmDmHbdlWoP4ZbfQx
         WL4w==
X-Forwarded-Encrypted: i=1; AKwUvBxplOdlLCCV7lYnDty+0yOApMycbnaQ8+g7c9fAqCBGGQJr9dCB9bFaHmPGPh0oHA72ivHUpnJ2te6x@vger.kernel.org
X-Gm-Message-State: AFq9FYJNya1hu/JPPW10F1SI9eDKJHvMn/PJ9pHCwz8IRyiATwN3xpMq
	/vl0Uv+6QvIOhOauxLn8/0VPXk7tmdcG06Jv3oCoC3UFXggzQML4pnBPLW0OHxE4CHsqZ2FfBJO
	mTsi+qDWeLrLhE5HCDsSjR4uFWA==
X-Received: from dlbro12.prod.google.com ([2002:a05:7022:158c:b0:161:df69:3983])
 (user=almasrymina job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:296:20b0:159:aa67:2893 with SMTP id a92af1059eb24-16a5d642d08mr20424818c88.30.1791999592415;
 Wed, 14 Oct 2026 10:39:52 -0700 (PDT)
Date: Wed, 14 Oct 2026 17:37:20 +0000
In-Reply-To: <20261014173945.373295-1-almasrymina@google.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20261014173945.373295-1-almasrymina@google.com>
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
Message-ID: <20261014173945.373295-7-almasrymina@google.com>
Subject: [PATCH net-next v3 6/6] net: kunit: test netmem, page_pool, and skb
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
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>, Petr Machata <petrm@nvidia.com>, 
	"=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20=28The=20Capable=20Hub=29?=" <u.kleine-koenig@baylibre.com>, Jakub Raczynski <j.raczynski@samsung.com>, 
	Wang Zhan <wang.zhan@smartx.com>, Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"

Verify that non-pp (page._refcount / binding->ref) and page_pool
(pp_ref_count) references stay balanced without cross-counter leaks or
underflows across regular pages, page_pool pages, non-pp net_iovs, and
page_pool net_iovs with both pp_recycle=0 and pp_recycle=1.

Cover get/put_net_iov(), get/put_netmem(), napi_pp_get/put_page(),
skb_netmem_ref/unref(), skb_frag_ref/unref(), pskb_copy(),
skb_zerocopy(), skb_shift(), skb_split(), skb_try_coalesce(),
skb_release_data() (clones, unclone ordering, pskb_extract(), and
skb_morph()), skb_segment(), and devmem tcp_recvmsg_dmabuf() /
SO_DEVMEM_DONTNEED.

Export skb_shift() via EXPORT_SYMBOL_IF_KUNIT() so the test links when
built as a module (CONFIG_NET_TEST=m).

Assisted-by: LLM
Signed-off-by: Mina Almasry <almasrymina@google.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
---
v3:
- Update mixed pp_recycle frag_list GSO KUnit cases for per-segment
  linearization and add a regression case for non-straddling mixed
  frag_list SKBs with linear data + frags (Sashiko).
- Link to v2: https://lore.kernel.org/netdev/20261012082148.1698596-7-almasrymina@google.com/

v2:
- Export skb_shift() via EXPORT_SYMBOL_IF_KUNIT() to fix the
  CONFIG_NET_TEST=m modpost error reported by NIPA.
- Reset mac_header before skb_segment() and check skb_clone() results
  before reuse (Sashiko).
- Cover compound tail pages, skb_try_coalesce(), TCP devmem recvmsg and
  SO_DEVMEM_DONTNEED, skb_zerocopy() rollbacks, skb_split()/skb_shift()
  edge cases, and mixed pp_recycle frag_list GSO.
- Link to v1: https://lore.kernel.org/netdev/20261010083935.3274178-7-almasrymina@google.com/
---
 net/core/net_test.c | 1222 +++++++++++++++++++++++++++++++++++++++++++
 net/core/skbuff.c   |    2 +
 2 files changed, 1224 insertions(+)

diff --git a/net/core/net_test.c b/net/core/net_test.c
index bc2ef7612e7df..2bb01430a89f7 100644
--- a/net/core/net_test.c
+++ b/net/core/net_test.c
@@ -457,10 +457,1231 @@ static void ip_tunnel_flags_test_run(struct kunit *test)
 	KUNIT_ASSERT_TRUE(test, __ipt_flag_op(bitmap_equal, exp, out));
 }
 
+/* Netmem & SKB fragment refcounting */
+
+#include <linux/skbuff_ref.h>
+#include <net/netmem.h>
+#include <net/netdev_rx_queue.h>
+#include <net/page_pool/helpers.h>
+#include <net/page_pool/memory_provider.h>
+#include <net/tcp.h>
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
+	/* skb_split inside linear header & inside nonlinear page_pool frags */
+	skb_shinfo(skb)->nr_frags = 0;
+	skb->len = 0;
+	skb->data_len = 0;
+	skb_reset_tail_pointer(skb);
+	skb_put(skb, 32);
+	skb_fill_netmem_desc(skb, 0, netmem, 0, 64);
+	skb->len += 64;
+	skb->data_len = 64;
+	split = alloc_skb(32, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, split);
+	skb_split(skb, split, 16);
+	KUNIT_EXPECT_TRUE(test, split->pp_recycle);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
+			base_pp_ref);
+	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
+	skb_shinfo(split)->nr_frags = 0;
+	consume_skb(split);
+	skb->len = 0;
+	skb->data_len = 0;
+	skb_reset_tail_pointer(skb);
+	skb_fill_netmem_desc(skb, 0, netmem, 0, 64);
+	skb->len = 64;
+	skb->data_len = 64;
+
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
+	skb_reset_mac_header(skb);
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
+	/* skb_shift balances pp_ref_count across split, partial coalesce,
+	 * multi-frag coalesce + partial next-frag shift, and full merge.
+	 */
+	skb_fill_netmem_desc(skb, 0, netmem, 0, 32);
+	skb_fill_netmem_desc(skb, 1, netmem, 64, 32);
+	page_pool_ref_page(page);
+	skb->len = 64;
+	skb->data_len = 64;
+	split = alloc_skb(0, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, split);
+	split->pp_recycle = 1;
+	KUNIT_EXPECT_EQ(test, skb_shift(split, skb, 16), 16);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
+			base_pp_ref + 2);
+	KUNIT_EXPECT_EQ(test, skb_shift(split, skb, 8), 8);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
+			base_pp_ref + 2);
+	KUNIT_EXPECT_EQ(test, skb_shift(split, skb, 24), 24);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
+			base_pp_ref + 2);
+	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
+	KUNIT_EXPECT_EQ(test, skb_shift(split, skb, 16), 16);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
+			base_pp_ref + 1);
+	skb_shinfo(split)->nr_frags = 0;
+	consume_skb(split);
+	page_pool_put_full_page(pool, page, false);
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
+
+	/* Order-1 compound page_pool page: tail netmem resolves to head &
+	 * build_skb(head_frag=1, pp_recycle=1) skb_zerocopy uses pp_ref_count.
+	 */
+	pp_params.order = 1;
+	pool = page_pool_create(&pp_params);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, pool);
+	page = page_pool_dev_alloc_pages(pool);
+	KUNIT_ASSERT_NOT_NULL(test, page);
+	base_ref = page_ref_count(page);
+	base_pp_ref = atomic_long_read(&page->pp_ref_count);
+
+	netmem = page_to_netmem(page + 1);
+	KUNIT_EXPECT_TRUE(test, napi_pp_get_page(netmem));
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
+			base_pp_ref + 1);
+	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
+	KUNIT_EXPECT_TRUE(test, napi_pp_put_page(netmem));
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
+			base_pp_ref);
+
+	skb = build_skb(page_address(page), PAGE_SIZE);
+	KUNIT_ASSERT_NOT_NULL(test, skb);
+	skb->pp_recycle = 1;
+	skb_put(skb, 64);
+	page_pool_ref_page(page);
+
+	copy = alloc_skb(0, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, copy);
+	skb_put(copy, skb_tailroom(copy));
+	KUNIT_ASSERT_EQ(test, skb_zerocopy(copy, skb, skb->len, 0), 0);
+	KUNIT_EXPECT_TRUE(test, copy->pp_recycle);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
+			base_pp_ref + 2);
+	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
+	consume_skb(copy);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
+			base_pp_ref + 1);
+	consume_skb(skb);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
+			base_pp_ref);
+
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
+	KUNIT_ASSERT_NOT_NULL(test, clone1);
+	clone2 = skb_clone(clone1, GFP_KERNEL);
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
+	struct ubuf_info uarg = {
+		.flags = SKBFL_ZEROCOPY_ENABLE,
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
+	/* 3. Mixed GRO frag_list (head pp_recycle=1 + list pp_recycle=0):
+	 * straddling segment linearizes its pp_recycle=1 prefix before
+	 * attaching the pp_recycle=0 frag so no nskb mixes incompatible
+	 * fragment refcount types; non-straddling segments stay zero-copy SG.
+	 */
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
+	segs = skb_segment(head, NETIF_F_SG | NETIF_F_HW_CSUM);
+	KUNIT_ASSERT_FALSE(test, IS_ERR_OR_NULL(segs));
+	KUNIT_EXPECT_TRUE(test, segs->pp_recycle);
+	KUNIT_EXPECT_FALSE(test, segs->next->pp_recycle);
+	KUNIT_EXPECT_FALSE(test, segs->next->next->pp_recycle);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&pp_page->pp_ref_count),
+			base_pp_ref + 2);
+	KUNIT_EXPECT_EQ(test, page_ref_count(pp_page), base_pp_page_ref);
+	KUNIT_EXPECT_EQ(test, page_ref_count(reg_page), base_reg_ref + 3);
+	kfree_skb_list(segs);
+	consume_skb(head);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&pp_page->pp_ref_count),
+			base_pp_ref);
+	KUNIT_EXPECT_EQ(test, page_ref_count(pp_page), base_pp_page_ref);
+	KUNIT_EXPECT_EQ(test, page_ref_count(reg_page), base_reg_ref);
+
+	/* 4. Reverse mixed frag_list (head pp_recycle=0 + list pp_recycle=1):
+	 * Crossing from pp_recycle=0 head into pp_recycle=1 list_skb must not
+	 * elevate page_ref_count(pp_page) instead of pp_ref_count.
+	 */
+	head = alloc_skb(64, GFP_KERNEL);
+	list = alloc_skb(0, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, head);
+	KUNIT_ASSERT_NOT_NULL(test, list);
+	head->pp_recycle = 0;
+	list->pp_recycle = 1;
+	head->protocol = htons(ETH_P_IP);
+	skb_reset_mac_header(head);
+	skb_reset_network_header(head);
+	skb_fill_page_desc(head, 0, reg_page, 0, 24);
+	get_page(reg_page);
+	head->len = 24;
+	head->data_len = 24;
+
+	skb_fill_netmem_desc(list, 0, pp_nm, 0, 24);
+	page_pool_ref_netmem(pp_nm);
+	list->len = 24;
+	list->data_len = 24;
+
+	skb_shinfo(head)->frag_list = list;
+	head->len += list->len;
+	head->data_len += list->len;
+	skb_shinfo(head)->gso_size = 16;
+
+	segs = skb_segment(head, NETIF_F_SG | NETIF_F_HW_CSUM);
+	KUNIT_ASSERT_FALSE(test, IS_ERR_OR_NULL(segs));
+	KUNIT_EXPECT_FALSE(test, segs->pp_recycle);
+	KUNIT_EXPECT_TRUE(test, segs->next->pp_recycle);
+	KUNIT_EXPECT_TRUE(test, segs->next->next->pp_recycle);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&pp_page->pp_ref_count),
+			base_pp_ref + 3);
+	KUNIT_EXPECT_EQ(test, page_ref_count(pp_page), base_pp_page_ref);
+	KUNIT_EXPECT_EQ(test, page_ref_count(reg_page), base_reg_ref + 2);
+	kfree_skb_list(segs);
+	consume_skb(head);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&pp_page->pp_ref_count),
+			base_pp_ref);
+	KUNIT_EXPECT_EQ(test, page_ref_count(pp_page), base_pp_page_ref);
+	KUNIT_EXPECT_EQ(test, page_ref_count(reg_page), base_reg_ref);
+
+	/* 5. Linear head_skb (nr_frags=0) + mixed pp_recycle frag_list where
+	 * member A has linear + frag (pp_recycle=1) and tail member B has
+	 * linear len == skb_headlen(A) (pp_recycle=0): keeps SG clone path
+	 * synchronized without hitting BUG_ON(i >= nfrags).
+	 */
+	head = alloc_skb(64, GFP_KERNEL);
+	list = alloc_skb(64, GFP_KERNEL);
+	seg = alloc_skb(64, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, head);
+	KUNIT_ASSERT_NOT_NULL(test, list);
+	KUNIT_ASSERT_NOT_NULL(test, seg);
+	head->pp_recycle = 0;
+	list->pp_recycle = 1;
+	seg->pp_recycle = 0;
+	head->protocol = htons(ETH_P_IP);
+	skb_reset_mac_header(head);
+	skb_reset_network_header(head);
+	skb_put(head, 32);
+	skb_put(list, 8);
+	skb_fill_netmem_desc(list, 0, pp_nm, 0, 24);
+	page_pool_ref_netmem(pp_nm);
+	list->len += 24;
+	list->data_len = 24;
+	skb_put(seg, 8);
+	list->next = seg;
+	skb_shinfo(head)->frag_list = list;
+	head->len += list->len + seg->len;
+	head->data_len = list->len + seg->len;
+	skb_shinfo(head)->gso_size = 32;
+
+	segs = skb_segment(head, NETIF_F_SG | NETIF_F_HW_CSUM);
+	KUNIT_ASSERT_FALSE(test, IS_ERR_OR_NULL(segs));
+	KUNIT_EXPECT_FALSE(test, segs->pp_recycle);
+	KUNIT_EXPECT_TRUE(test, segs->next->pp_recycle);
+	KUNIT_EXPECT_FALSE(test, segs->next->next->pp_recycle);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&pp_page->pp_ref_count),
+			base_pp_ref + 2);
+	KUNIT_EXPECT_EQ(test, page_ref_count(pp_page), base_pp_page_ref);
+	kfree_skb_list(segs);
+	consume_skb(head);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&pp_page->pp_ref_count),
+			base_pp_ref);
+
+	/* 6. skb_zerocopy -EFAULT rollback when from->head_frag (pp_page) is
+	 * followed by unreadable net_iov frag drops pp_ref_count via
+	 * skb_frag_unref(to, 0).
+	 */
+	head = build_skb(page_address(pp_page), PAGE_SIZE);
+	KUNIT_ASSERT_NOT_NULL(test, head);
+	head->pp_recycle = 1;
+	skb_put(head, 32);
+	page_pool_ref_netmem(pp_nm);
+	skb_fill_netmem_desc(head, 0, niov_nm, 0, 32);
+	napi_pp_get_page(niov_nm);
+	head->len += 32;
+	head->data_len += 32;
+
+	seg = alloc_skb(0, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, seg);
+	skb_put(seg, skb_tailroom(seg));
+	KUNIT_EXPECT_EQ(test, skb_zerocopy(seg, head, head->len, 0), -EFAULT);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&pp_page->pp_ref_count),
+			base_pp_ref + 1);
+	skb_shinfo(seg)->nr_frags = 0;
+	consume_skb(seg);
+	consume_skb(head);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&pp_page->pp_ref_count),
+			base_pp_ref);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&niov.desc.pp_ref_count), 2L);
+
+	/* 7. skb_zerocopy -ENOMEM rollback when skb_orphan_frags() fails on
+	 * shared zerocopy skb drops pp_ref_count via skb_frag_unref(to, 0).
+	 */
+	head = build_skb(page_address(pp_page), PAGE_SIZE);
+	KUNIT_ASSERT_NOT_NULL(test, head);
+	head->pp_recycle = 1;
+	skb_put(head, 32);
+	page_pool_ref_netmem(pp_nm);
+	skb_zcopy_init(head, &uarg);
+	skb_get(head);
+
+	seg = alloc_skb(0, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, seg);
+	skb_put(seg, skb_tailroom(seg));
+	KUNIT_EXPECT_EQ(test, skb_zerocopy(seg, head, head->len, 0), -ENOMEM);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&pp_page->pp_ref_count),
+			base_pp_ref + 1);
+	KUNIT_EXPECT_EQ(test, page_ref_count(pp_page), base_pp_page_ref);
+	skb_shinfo(seg)->nr_frags = 0;
+	consume_skb(seg);
+	consume_skb(head);
+	skb_shinfo(head)->flags &= ~SKBFL_ZEROCOPY_ENABLE;
+	consume_skb(head);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&pp_page->pp_ref_count),
+			base_pp_ref);
+
+	page_pool_put_full_page(pool, pp_page, false);
+	page_pool_put_full_page(pool, pp_page, false);
+	__free_page(reg_page);
+	netmem_clear_pp_magic(niov_nm);
+	netmem_set_pp(niov_nm, NULL);
+	page_pool_destroy(pool);
+	percpu_ref_exit(&binding.ref);
+}
+
+static void netmem_ref_test_try_coalesce(struct kunit *test)
+{
+	struct page_pool_params pp_params = {
+		.order = 0,
+		.pool_size = 4,
+		.nid = NUMA_NO_NODE,
+	};
+	struct sk_buff *to, *from, *clone;
+	struct net_devmem_dmabuf_binding binding = {};
+	struct net_iov niov = {};
+	struct page *pp_page, *reg_page;
+	netmem_ref pp_nm, niov_nm;
+	struct page_pool *pool;
+	long base_pp_ref, base_iov_ref;
+	int base_pp_page_ref, base_reg_ref;
+	bool fragstolen;
+	int delta;
+
+	pool = page_pool_create(&pp_params);
+	KUNIT_ASSERT_FALSE(test, IS_ERR(pool));
+	pp_page = page_pool_dev_alloc_pages(pool);
+	KUNIT_ASSERT_NOT_NULL(test, pp_page);
+	pp_nm = page_to_netmem(pp_page);
+	page_pool_ref_netmem(pp_nm);
+
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
+	/* 1. Uncloned pp_recycle=1 from: frags stolen without extra ref */
+	to = alloc_skb(0, GFP_KERNEL);
+	from = alloc_skb(0, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, to);
+	KUNIT_ASSERT_NOT_NULL(test, from);
+	skb_put(to, skb_tailroom(to));
+	to->pp_recycle = 1;
+	from->pp_recycle = 1;
+	skb_add_rx_frag(from, 0, pp_page, 0, 64, PAGE_SIZE);
+	page_pool_ref_netmem(pp_nm);
+	KUNIT_EXPECT_TRUE(test, skb_try_coalesce(to, from, &fragstolen,
+						 &delta));
+	KUNIT_EXPECT_EQ(test, skb_shinfo(from)->nr_frags, 0);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&pp_page->pp_ref_count),
+			base_pp_ref + 1);
+	consume_skb(from);
+	consume_skb(to);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&pp_page->pp_ref_count),
+			base_pp_ref);
+
+	/* 2. Cloned pp_recycle=1 from (pp_page + non-PP reg_page fallback):
+	 * skb_frag_ref(from, i) increments pp_ref_count for pp_page and
+	 * page_ref_count for reg_page.
+	 */
+	to = alloc_skb(0, GFP_KERNEL);
+	from = alloc_skb(0, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, to);
+	KUNIT_ASSERT_NOT_NULL(test, from);
+	skb_put(to, skb_tailroom(to));
+	to->pp_recycle = 1;
+	from->pp_recycle = 1;
+	skb_add_rx_frag(from, 0, pp_page, 0, 32, PAGE_SIZE);
+	page_pool_ref_netmem(pp_nm);
+	skb_add_rx_frag(from, 1, reg_page, 0, 32, PAGE_SIZE);
+	get_page(reg_page);
+
+	clone = skb_clone(from, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, clone);
+	KUNIT_EXPECT_TRUE(test, skb_try_coalesce(to, from, &fragstolen,
+						 &delta));
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&pp_page->pp_ref_count),
+			base_pp_ref + 2);
+	KUNIT_EXPECT_EQ(test, page_ref_count(pp_page), base_pp_page_ref);
+	KUNIT_EXPECT_EQ(test, page_ref_count(reg_page), base_reg_ref + 2);
+	consume_skb(from);
+	consume_skb(clone);
+	consume_skb(to);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&pp_page->pp_ref_count),
+			base_pp_ref);
+	KUNIT_EXPECT_EQ(test, page_ref_count(pp_page), base_pp_page_ref);
+	KUNIT_EXPECT_EQ(test, page_ref_count(reg_page), base_reg_ref);
+
+	/* 3. Cloned unreadable pp_recycle=1 net_iov skb: skb_try_coalesce
+	 * increments niov.desc.pp_ref_count via skb_frag_ref(from, i).
+	 */
+	to = alloc_skb(0, GFP_KERNEL);
+	from = alloc_skb(0, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, to);
+	KUNIT_ASSERT_NOT_NULL(test, from);
+	skb_put(to, skb_tailroom(to));
+	to->pp_recycle = 1;
+	to->unreadable = 1;
+	from->pp_recycle = 1;
+	skb_add_rx_frag_netmem(from, 0, niov_nm, 0, 64, PAGE_SIZE);
+	napi_pp_get_page(niov_nm);
+
+	clone = skb_clone(from, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, clone);
+	KUNIT_EXPECT_TRUE(test, skb_try_coalesce(to, from, &fragstolen,
+						 &delta));
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&niov.desc.pp_ref_count), 4L);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&binding.ref.data->count),
+			base_iov_ref);
+	consume_skb(from);
+	consume_skb(clone);
+	consume_skb(to);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&niov.desc.pp_ref_count), 2L);
+
+	page_pool_put_full_page(pool, pp_page, false);
+	page_pool_put_full_page(pool, pp_page, false);
+	__free_page(reg_page);
+	netmem_clear_pp_magic(niov_nm);
+	netmem_set_pp(niov_nm, NULL);
+	page_pool_destroy(pool);
+	percpu_ref_exit(&binding.ref);
+}
+
+#ifdef CONFIG_INET
+static void netmem_ref_test_tcp_devmem_recv(struct kunit *test)
+{
+	char cmsg_buf[CMSG_SPACE(sizeof(struct dmabuf_cmsg))]
+		__aligned(__alignof__(struct cmsghdr)) = {};
+	struct page_pool_params pp_params = {
+		.order = 0,
+		.pool_size = 4,
+		.nid = NUMA_NO_NODE,
+	};
+	struct net_devmem_dmabuf_binding binding = {};
+	struct msghdr msg = {};
+	struct dmabuf_token token;
+	struct dmabuf_cmsg *cmsg;
+	struct net_iov niov = {};
+	struct page_pool *pool;
+	struct cmsghdr *cm;
+	struct socket *sock;
+	struct sk_buff *skb;
+	struct kvec iov = {};
+	netmem_ref niov_nm;
+	long base_iov_ref;
+	int ret;
+
+	KUNIT_ASSERT_EQ(test,
+			sock_create_kern(&init_net, AF_INET, SOCK_STREAM,
+					 IPPROTO_TCP, &sock),
+			0);
+	sock->sk->sk_state = TCP_ESTABLISHED;
+	inet_csk(sock->sk)->icsk_ack.rcv_mss = 64;
+	tcp_sk(sock->sk)->copied_seq = 0;
+
+	pool = page_pool_create(&pp_params);
+	if (IS_ERR(pool)) {
+		sock->sk->sk_state = TCP_CLOSE;
+		sock_release(sock);
+		KUNIT_ASSERT_FALSE(test, IS_ERR(pool));
+	}
+
+	ret = percpu_ref_init(&binding.ref, dummy_percpu_ref_release,
+			      PERCPU_REF_INIT_ATOMIC, GFP_KERNEL);
+	if (ret) {
+		page_pool_destroy(pool);
+		sock->sk->sk_state = TCP_CLOSE;
+		sock_release(sock);
+		KUNIT_ASSERT_EQ(test, ret, 0);
+	}
+	binding.area.niovs = &niov;
+	net_iov_init(&niov, &binding.area, NET_IOV_DMABUF);
+	niov_nm = net_iov_to_netmem(&niov);
+	netmem_set_pp(niov_nm, pool);
+	netmem_or_pp_magic(niov_nm, PP_SIGNATURE);
+	atomic_long_set(&niov.desc.pp_ref_count, 2);
+	base_iov_ref = atomic_long_read(&binding.ref.data->count);
+
+	/* 1. Receive via tcp_recvmsg_dmabuf -> SO_DEVMEM_DONTNEED release */
+	skb = alloc_skb(0, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, skb);
+	skb->pp_recycle = 1;
+	skb_add_rx_frag_netmem(skb, 0, niov_nm, 0, 64, PAGE_SIZE);
+	napi_pp_get_page(niov_nm);
+	TCP_SKB_CB(skb)->seq = 0;
+	TCP_SKB_CB(skb)->end_seq = 64;
+	skb_queue_tail(&sock->sk->sk_receive_queue, skb);
+
+	msg.msg_control = cmsg_buf;
+	msg.msg_controllen = sizeof(cmsg_buf);
+	ret = kernel_recvmsg(sock, &msg, &iov, 0, 64,
+			     MSG_SOCK_DEVMEM | MSG_DONTWAIT);
+	KUNIT_ASSERT_EQ(test, ret, 64);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&niov.desc.pp_ref_count), 3L);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&binding.ref.data->count),
+			base_iov_ref);
+
+	cm = (struct cmsghdr *)cmsg_buf;
+	cmsg = CMSG_DATA(cm);
+	token.token_start = cmsg->frag_token;
+	token.token_count = 1;
+	KUNIT_EXPECT_EQ(test,
+			sock_setsockopt(sock, SOL_SOCKET, SO_DEVMEM_DONTNEED,
+					KERNEL_SOCKPTR(&token), sizeof(token)),
+			1);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&niov.desc.pp_ref_count), 2L);
+
+	/* 2. Receive second packet & destroy socket to test
+	 * tcp_release_user_frags() -> napi_pp_put_page().
+	 */
+	skb = alloc_skb(0, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, skb);
+	skb->pp_recycle = 1;
+	skb_add_rx_frag_netmem(skb, 0, niov_nm, 0, 64, PAGE_SIZE);
+	napi_pp_get_page(niov_nm);
+	TCP_SKB_CB(skb)->seq = 64;
+	TCP_SKB_CB(skb)->end_seq = 128;
+	skb_queue_tail(&sock->sk->sk_receive_queue, skb);
+
+	msg.msg_control = cmsg_buf;
+	msg.msg_controllen = sizeof(cmsg_buf);
+	ret = kernel_recvmsg(sock, &msg, &iov, 0, 64,
+			     MSG_SOCK_DEVMEM | MSG_DONTWAIT);
+	KUNIT_ASSERT_EQ(test, ret, 64);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&niov.desc.pp_ref_count), 3L);
+
+	sock->sk->sk_state = TCP_CLOSE;
+	sock_release(sock);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&niov.desc.pp_ref_count), 2L);
+
+	netmem_clear_pp_magic(niov_nm);
+	netmem_set_pp(niov_nm, NULL);
+	page_pool_destroy(pool);
+	percpu_ref_exit(&binding.ref);
+}
+#endif
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
+	KUNIT_CASE(netmem_ref_test_try_coalesce),
+#ifdef CONFIG_INET
+	KUNIT_CASE(netmem_ref_test_tcp_devmem_recv),
+#endif
+#endif
 	{ },
 };
 
@@ -471,4 +1692,5 @@ static struct kunit_suite net_test_suite = {
 kunit_test_suite(net_test_suite);
 
 MODULE_DESCRIPTION("KUnit tests for networking core");
+MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");
 MODULE_LICENSE("GPL");
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 90812e49dc8e1..252b835b5bdfd 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -65,6 +65,7 @@
 #include <linux/kcov.h>
 #include <linux/iov_iter.h>
 #include <linux/crc32.h>
+#include <kunit/visibility.h>
 
 #include <net/protocol.h>
 #include <net/dst.h>
@@ -4399,6 +4400,7 @@ int skb_shift(struct sk_buff *tgt, struct sk_buff *skb, int shiftlen)
 
 	return shiftlen;
 }
+EXPORT_SYMBOL_IF_KUNIT(skb_shift);
 
 /**
  * skb_prepare_seq_read - Prepare a sequential read of skb data
-- 
2.56.0.212.g129ede20d9-goog

