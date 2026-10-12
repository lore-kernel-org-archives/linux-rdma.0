Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F7B46EF60
	for <linux-rdma@vger.kernel.org>; Mon, 12 Oct 2026 08:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791793321; cv=none; b=dFEExsxcFnvzr7PaXxOXzEVAeWHMRdYIO7N0VhwLFxRx0LFV+c8KBsqeI5B07tLSzpFNAm2d585E/6UhkvMDbRbmY0aBXWcblbkOxHnZnoMGeRW3RD3qTAytJs33nHIn3qbrNXa/Aa48PuTMrFhxpZrReP42Ew6kaJCqjGtq188=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791793321; c=relaxed/simple;
	bh=qoz8LpgRAoPQvj+FQgv/0vlXFiQOEJ4GUw0ImCKUHT0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lmsjtgMKE0ECnUVrvvjjP/4ymZfAVP9CvbcaBQQUiDMagNYnm4xAJKGidv24uN7qbGo1QXno1C8A3K0Lyh3erk99+N4R/vmu8+XFUIfmcV8RVm1mfHCV6zPd4MX5j9Kx7x9LKNxUklaHEI0eTMQ/Sk8qGM1XRrxvKQv5tE+6Ps0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lrPk5BTt; arc=none smtp.client-ip=74.125.82.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lrPk5BTt"
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-35a0c25def6so1808524eec.0
        for <linux-rdma@vger.kernel.org>; Mon, 12 Oct 2026 01:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791793317; x=1792398117; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tdSvGzmRaA8u3OJ1xSaFDeGze8JHwHmxfSrNIBUcBsA=;
        b=lrPk5BTt/WnXwaQBkbQIcZKWhnqlYz8xqRVxlOvP8EiOrA+jhEMkJSPnQLbhmOI4Zi
         1malFhfXrprIiFAOXFInhDo1HqeJTLxghclEVdkR7MksEGJooOWD7ap4ZmMPKl1jgMzF
         k8D0vlWvIOCSpqoP/Cckc38W4R5gHuMzeFo3ZKTuWEdlnf6JD4zivBN/3dXfmiiusoCi
         O5EMHl+bgN/dp0vjHhwp/jD9gsfvk20zhS5ch2pxbSgOtPq4D94BANF5NGJxZFsOab0H
         vvxvu/EPWgfN4UKDxt/zTBPBx+TSw3zRUOhXJKbnhtt4YVjghZ4ByFtRtK4LpZ/Oh7j8
         xqpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791793317; x=1792398117;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tdSvGzmRaA8u3OJ1xSaFDeGze8JHwHmxfSrNIBUcBsA=;
        b=fDXXFgNRUcgon1lCNj/otRqigi7gXG8mFrcoHBaWFZ0svunrSnhcXNi6zQAGmSHZ7Z
         7LR5BUj0cDfEC9XRoRt9y3D/44yI6tjaN4TRfof4Yvkxb4BdLbdrZMCoK2WnmvArvkK7
         gNGbUVUHiugV2PjPIUgDH4FC8ASINSnEdsjILxsAJVcimh29xzSNDsYkgubIGwqkssWh
         lZhwfG4jLcrun9ypXumaR68TCQwd+e0w5abEZaGkuenZULm4zsE+l3DUqNf44ljnbx9T
         k4QKhjWXppBSADaVil2uxMak4ihKWmBpl9/utg5EiHSM47+97oRXAwM4hlHQW+qPK5WP
         X+Vw==
X-Forwarded-Encrypted: i=1; AKwUvBwbI/ZOc3qvCLmyaG6YWka+nh1366ADsr9PG8rwEVpGu5OhSl+l9R7JtNM3SkS9PfkkcpzkFQl7/F8p@vger.kernel.org
X-Gm-Message-State: AFq9FYLa+grVnARKwS/VNmd7P28hzDIwl/iVfg86ezjw1nQTcbVR/guP
	Qvz05f/CoKZYdjb8efF/zaCZufWT5BQiHf6dFizRghlS+XGfhDKV1uYuKLQ8DpODBzuH44TWijN
	eMcshs1OjkZY9CaYLPKzqRZJWvw==
X-Received: from dlec7-n2.prod.google.com ([2002:a05:701b:4287:20b0:162:60dc:8d82])
 (user=almasrymina job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7023:882:b0:15a:4155:3d9d with SMTP id a92af1059eb24-16a6034685dmr15371461c88.31.1791793316346;
 Mon, 12 Oct 2026 01:21:56 -0700 (PDT)
Date: Mon, 12 Oct 2026 08:21:48 +0000
In-Reply-To: <20261012082148.1698596-1-almasrymina@google.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20261012082148.1698596-1-almasrymina@google.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261012082148.1698596-7-almasrymina@google.com>
Subject: [PATCH net-next v2 6/6] net: kunit: test netmem, page_pool, and skb
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
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>, 
	"=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20=28The=20Capable=20Hub=29?=" <u.kleine-koenig@baylibre.com>, Jijie Shao <shaojijie@huawei.com>, 
	Michael Grzeschik <mgr@kernel.org>, Jakub Raczynski <j.raczynski@samsung.com>
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
---
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
 net/core/net_test.c | 1204 +++++++++++++++++++++++++++++++++++++++++++
 net/core/skbuff.c   |    2 +
 2 files changed, 1206 insertions(+)

diff --git a/net/core/net_test.c b/net/core/net_test.c
index 9c3a590865d26..6f21e6baf7fb3 100644
--- a/net/core/net_test.c
+++ b/net/core/net_test.c
@@ -370,10 +370,1213 @@ static void ip_tunnel_flags_test_run(struct kunit *test)
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
+	 * skb_segment disables SG page sharing so no nskb mixes incompatible
+	 * fragment refcount types; all counters stay balanced.
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
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&pp_page->pp_ref_count),
+			base_pp_ref + 1);
+	KUNIT_EXPECT_EQ(test, page_ref_count(pp_page), base_pp_page_ref);
+	KUNIT_EXPECT_EQ(test, page_ref_count(reg_page), base_reg_ref + 1);
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
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&pp_page->pp_ref_count),
+			base_pp_ref + 1);
+	KUNIT_EXPECT_EQ(test, page_ref_count(pp_page), base_pp_page_ref);
+	KUNIT_EXPECT_EQ(test, page_ref_count(reg_page), base_reg_ref + 1);
+	kfree_skb_list(segs);
+	consume_skb(head);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&pp_page->pp_ref_count),
+			base_pp_ref);
+	KUNIT_EXPECT_EQ(test, page_ref_count(pp_page), base_pp_page_ref);
+	KUNIT_EXPECT_EQ(test, page_ref_count(reg_page), base_reg_ref);
+
+	/* 5. Linear head_skb (nr_frags=0, pp_recycle=0) + homogeneous
+	 * pp_recycle=1 frag_list keeps zero-copy SG enabled.
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
+	skb_fill_netmem_desc(list, 0, pp_nm, 0, 32);
+	page_pool_ref_netmem(pp_nm);
+	list->len = 32;
+	list->data_len = 32;
+	skb_shinfo(head)->frag_list = list;
+	head->len = 32;
+	head->data_len = 32;
+	skb_shinfo(head)->gso_size = 16;
+
+	segs = skb_segment(head, NETIF_F_SG | NETIF_F_HW_CSUM);
+	KUNIT_ASSERT_FALSE(test, IS_ERR_OR_NULL(segs));
+	KUNIT_EXPECT_TRUE(test, segs->pp_recycle);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&pp_page->pp_ref_count),
+			base_pp_ref + 3);
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
 
@@ -384,4 +1587,5 @@ static struct kunit_suite net_test_suite = {
 kunit_test_suite(net_test_suite);
 
 MODULE_DESCRIPTION("KUnit tests for networking core");
+MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");
 MODULE_LICENSE("GPL");
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 20fca895d7090..ebd1af82c0e22 100644
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
2.56.0.385.gd3acb90ef8-goog

