Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 719CF463B8D
	for <linux-rdma@vger.kernel.org>; Mon, 12 Oct 2026 08:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791793316; cv=none; b=tbEO5MRpVuObp8nO+hB2tOnEzFzZkI+UmgwGRqm8EV7JK+TUeV822LaY1XXLADIjF+OkKiyVW6l3wUYf9S/mMryDpdAchW8zO3fY/d8fd14IMr+LuJ6qGvvQGqtQB8IRZ31jcZqqih4N5omHbqyPi0ED1juNTaRqgplBowrUZrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791793316; c=relaxed/simple;
	bh=ADcRZSQ9sezaDhIWlb5yrENxxK9oN8l6EXNGgklN8KY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JZjoSQXcRCT5C7A4JnQ1+Br629+4agkRJebSJSrlr0Zu+tF42VAmyzmUbUH7sHvca2FYtbkZ32wbx16IpzXQR8BjReduP/jP4hLJQYficdhWf4ba8D7v/jxq9JObWQJSwSBpAIV885g2HdwaH6Vd5kC8tjmea8yrYyXdYEntpTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=k8HQh07m; arc=none smtp.client-ip=74.125.82.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="k8HQh07m"
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-341eff9e381so5147659eec.1
        for <linux-rdma@vger.kernel.org>; Mon, 12 Oct 2026 01:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791793313; x=1792398113; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jZ12mqedieH6QrImbBdvjsSC6QhBu16Yz5V3Azmnxh8=;
        b=k8HQh07mu2PPo+IFjjv1VbGmBJKso4Ilfx8/WlBIZSWU14gIGwfC9/JDnx9L7lGhm9
         6Xz4jCclYHJeg6UTd7dc65pedylnW/14H6V44SXlacHBEVOT9GTmqiYC9736GmecGSRB
         +wKh1wPSurZ5PFe5EewUtklaA0CwTcMh2AYISvREYkJdmTIaKtQga2oSse3fZd8Oadyv
         uqWjP+GIq1jCwEuXl4lsOlVRCGWCsPLrn34dN//yxJzFCDDpRg4X3p0chmeokyuJ7FFD
         VLMiuBVUoS8uvvXNJh8YcRL7Q/uFkp243zb0Q4WktXo3rb1n2E5f+JHR97f+Au0u/gq4
         jeLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791793314; x=1792398114;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jZ12mqedieH6QrImbBdvjsSC6QhBu16Yz5V3Azmnxh8=;
        b=wVhs/qbDm+FNhtY7hdlFnMap+ZUOQkZhty0+8wfMPEKJblZ7HGCoFnPh8iruIJiI9x
         bim7D3ZapwB+AWSyBHeffEWcx05VRpp7SP12k/IyWFmIsJ/QGzr+khCdPPMWRFEqksEc
         7U27jULFFgxREEIN++YlP4192XH0bLx0Zyt/vvxsVqae7HSKw9i84a94DQ3Xs/DR02rW
         OQJ0iAdoM4tTp0EC8ELvdzm+sBjUIoUNHWUYST6bnDj5ofZtfyzK+v4JzGIS6w9KYXs3
         IHPU2JydqirkSu7ChzpL8KUlirHNG2l8P3ZFg8KfAI1EU0M5/FtSZZ5bV2BfSLRX32Kf
         8WcQ==
X-Forwarded-Encrypted: i=1; AKwUvByjtVyTj2oOO4TkXRsQKjB+9Wi971+S/4hj7bjSTiTpx/jn831PVj5v0h5/ly+wO2dV4/b0zkQXV/e/@vger.kernel.org
X-Gm-Message-State: AFq9FYKpTUQiiAXUvcwz+/5TYgejy0dCwPBT3jplOy5QKo7ewn5/fma4
	1qi2gUpAAxmHeAdTuh7+qwwn1a8YonFEwKXFqKz+PTPM7HACSOEa5bmi1SV54AZF+F/nJwwGoPa
	hRajYBezWAQthgUAJBx66Uruguw==
X-Received: from dyay2.prod.google.com ([2002:a05:693c:62c2:b0:34c:9660:9612])
 (user=almasrymina job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7300:dd41:b0:34d:756:9b2a with SMTP id 5a478bee46e88-3537e059987mr12694107eec.23.1791793312604;
 Mon, 12 Oct 2026 01:21:52 -0700 (PDT)
Date: Mon, 12 Oct 2026 08:21:45 +0000
In-Reply-To: <20261012082148.1698596-1-almasrymina@google.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20261012082148.1698596-1-almasrymina@google.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261012082148.1698596-4-almasrymina@google.com>
Subject: [PATCH net-next v2 3/6] net: skbuff: replace skb_page_unref() and
 __skb_frag_unref() with skb_netmem_unref()
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

Unreferencing a page_pool fragment with recycle=false decrements the
non-pp backing refcount instead of pp_ref_count, underflowing the page
refcount when the fragment was owned via page_pool (as on mlx4's RX
error path). Having both skb_page_unref() and __skb_frag_unref(frag,
recycle) made it easy for callers to pass hardcoded recycle=false on
SKB-owned fragments.

Replace skb_page_unref() and __skb_frag_unref() with
skb_netmem_unref(netmem, recycle), which dispatches to
napi_pp_put_page() when recycle is true and put_netmem() otherwise:

- Use skb_frag_unref(skb, ...) on SKB-owned fragments in mlx4, sky2,
  tls_strp, and skb_shift() so unrefs always match skb->pp_recycle.
- Use put_netmem() directly in tls_device's destroy_record(), which
  releases raw non-pp page references outside an SKB.

Found by code inspection and confirmed with the KUnit tests added later
in this series; not observed in production. The mlx4, sky2, and TLS
call-site changes are compile-tested only.

Assisted-by: LLM
Signed-off-by: Mina Almasry <almasrymina@google.com>
---
v2:
- Note how the issue was found and how the change was tested.
- Link to v1: https://lore.kernel.org/netdev/20261010083935.3274178-4-almasrymina@google.com/
---
 drivers/net/ethernet/marvell/sky2.c        |  2 +-
 drivers/net/ethernet/mellanox/mlx4/en_rx.c |  2 +-
 include/linux/skbuff_ref.h                 | 34 +++++++++++-----------
 net/core/skbuff.c                          |  7 +++--
 net/ipv4/esp4.c                            |  4 +--
 net/ipv6/esp6.c                            |  4 +--
 net/tls/tls_device.c                       |  2 +-
 net/tls/tls_strp.c                         |  2 +-
 8 files changed, 29 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index 30facdece3e29..1d42a82db8f2b 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -2501,7 +2501,7 @@ static void skb_put_frags(struct sk_buff *skb, unsigned int hdr_space,
 
 		if (length == 0) {
 			/* don't need this page */
-			__skb_frag_unref(frag, false);
+			skb_frag_unref(skb, i);
 			--skb_shinfo(skb)->nr_frags;
 		} else {
 			size = min(length, (unsigned) PAGE_SIZE);
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
index 96f97fa0f5489..fe18606c2ab55 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -497,7 +497,7 @@ static int mlx4_en_complete_rx_desc(struct mlx4_en_priv *priv,
 fail:
 	while (nr > 0) {
 		nr--;
-		__skb_frag_unref(skb_shinfo(skb)->frags + nr, false);
+		skb_frag_unref(skb, nr);
 	}
 	return 0;
 }
diff --git a/include/linux/skbuff_ref.h b/include/linux/skbuff_ref.h
index 0441c220fdbdf..04114c64dad99 100644
--- a/include/linux/skbuff_ref.h
+++ b/include/linux/skbuff_ref.h
@@ -36,7 +36,16 @@ static __always_inline void skb_frag_ref(struct sk_buff *skb, int f)
 
 bool napi_pp_put_page(netmem_ref netmem);
 
-static __always_inline void skb_page_unref(netmem_ref netmem, bool recycle)
+/**
+ * skb_netmem_unref - release a fragment reference on a netmem
+ * @netmem: netmem to unreference
+ * @recycle: whether page_pool recycling is enabled (e.g. skb->pp_recycle)
+ *
+ * Drops pp_ref_count via napi_pp_put_page() if @recycle is true and @netmem
+ * belongs to a page_pool; otherwise drops a non-pp backing reference via
+ * put_netmem(). Counterpart to skb_netmem_ref().
+ */
+static __always_inline void skb_netmem_unref(netmem_ref netmem, bool recycle)
 {
 #ifdef CONFIG_PAGE_POOL
 	if (recycle && napi_pp_put_page(netmem))
@@ -46,31 +55,22 @@ static __always_inline void skb_page_unref(netmem_ref netmem, bool recycle)
 }
 
 /**
- * __skb_frag_unref - release a reference on a paged fragment.
- * @frag: the paged fragment
- * @recycle: recycle the page if allocated via page_pool
- *
- * Releases a reference on the paged fragment @frag
- * or recycles the page via the page_pool API.
- */
-static __always_inline void __skb_frag_unref(skb_frag_t *frag, bool recycle)
-{
-	skb_page_unref(skb_frag_netmem(frag), recycle);
-}
-
-/**
- * skb_frag_unref - release a reference on a paged fragment of an skb.
+ * skb_frag_unref - release a reference on a paged fragment of an skb
  * @skb: the buffer
  * @f: the fragment offset
  *
- * Releases a reference on the @f'th paged fragment of @skb.
+ * Drops a reference on the @f'th fragment of @skb via skb_netmem_unref()
+ * (pp_ref_count if skb->pp_recycle and page_pool-backed, else non-pp
+ * backing refcount), skipping managed zerocopy fragments. Counterpart to
+ * skb_frag_ref().
  */
 static __always_inline void skb_frag_unref(struct sk_buff *skb, int f)
 {
 	struct skb_shared_info *shinfo = skb_shinfo(skb);
 
 	if (!skb_zcopy_managed(skb))
-		__skb_frag_unref(&shinfo->frags[f], skb->pp_recycle);
+		skb_netmem_unref(skb_frag_netmem(&shinfo->frags[f]),
+				 skb->pp_recycle);
 }
 
 #endif	/* _LINUX_SKBUFF_REF_H */
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 8a8be746828db..46da61ad1f9eb 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1144,7 +1144,8 @@ static void skb_release_data(struct sk_buff *skb, enum skb_drop_reason reason)
 	}
 
 	for (i = 0; i < shinfo->nr_frags; i++)
-		__skb_frag_unref(&shinfo->frags[i], skb->pp_recycle);
+		skb_netmem_unref(skb_frag_netmem(&shinfo->frags[i]),
+				 skb->pp_recycle);
 
 free_head:
 	if (shinfo->frag_list)
@@ -1154,7 +1155,7 @@ static void skb_release_data(struct sk_buff *skb, enum skb_drop_reason reason)
 exit:
 	/* When we clone an SKB we copy the reycling bit. The pp_recycle
 	 * bit is only set on the head though, so in order to avoid races
-	 * while trying to recycle fragments on __skb_frag_unref() we need
+	 * while trying to recycle fragments on skb_netmem_unref() we need
 	 * to make one SKB responsible for triggering the recycle path.
 	 * So disable the recycling bit if an SKB is cloned and we have
 	 * additional references to the fragmented part of the SKB.
@@ -4412,7 +4413,7 @@ int skb_shift(struct sk_buff *tgt, struct sk_buff *skb, int shiftlen)
 		fragto = &skb_shinfo(tgt)->frags[merge];
 
 		skb_frag_size_add(fragto, skb_frag_size(fragfrom));
-		__skb_frag_unref(fragfrom, skb->pp_recycle);
+		skb_frag_unref(skb, 0);
 	}
 
 	/* Reposition in the original skb */
diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index e76db5817e78e..ae701561d9f12 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -117,8 +117,8 @@ static void esp_ssg_unref(struct xfrm_state *x, void *tmp, struct sk_buff *skb,
 		struct scatterlist *src = already_unref ? esp_req_sg(aead, req) : req->src;
 
 		for (sg = sg_next(src); sg; sg = sg_next(sg))
-			skb_page_unref(page_to_netmem(sg_page(sg)),
-				       skb->pp_recycle);
+			skb_netmem_unref(page_to_netmem(sg_page(sg)),
+					 skb->pp_recycle);
 	}
 }
 
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index b1c9b36f76dc4..d654f0f442388 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -134,8 +134,8 @@ static void esp_ssg_unref(struct xfrm_state *x, void *tmp, struct sk_buff *skb,
 		struct scatterlist *src = already_unref ? esp_req_sg(aead, req) : req->src;
 
 		for (sg = sg_next(src); sg; sg = sg_next(sg))
-			skb_page_unref(page_to_netmem(sg_page(sg)),
-				       skb->pp_recycle);
+			skb_netmem_unref(page_to_netmem(sg_page(sg)),
+					 skb->pp_recycle);
 	}
 }
 
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index f11d0528fc431..b333a9a72cdae 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -143,7 +143,7 @@ static void destroy_record(struct tls_record_info *record)
 	int i;
 
 	for (i = 0; i < record->num_frags; i++)
-		__skb_frag_unref(&record->frags[i], false);
+		put_netmem(skb_frag_netmem(&record->frags[i]));
 	kfree(record);
 }
 
diff --git a/net/tls/tls_strp.c b/net/tls/tls_strp.c
index 6cc222008d95c..53d3256d0114a 100644
--- a/net/tls/tls_strp.c
+++ b/net/tls/tls_strp.c
@@ -197,7 +197,7 @@ static void tls_strp_flush_anchor_copy(struct tls_strparser *strp)
 	DEBUG_NET_WARN_ON_ONCE(atomic_read(&shinfo->dataref) != 1);
 
 	for (i = 0; i < shinfo->nr_frags; i++)
-		__skb_frag_unref(&shinfo->frags[i], false);
+		skb_frag_unref(strp->anchor, i);
 	shinfo->nr_frags = 0;
 	if (strp->copy_mode) {
 		kfree_skb_list(shinfo->frag_list);
-- 
2.56.0.385.gd3acb90ef8-goog

