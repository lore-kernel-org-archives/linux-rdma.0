Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7983566C74
	for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 17:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791999597; cv=none; b=TcsTGylK5XgHKeCt7af8nvgDgLclAaajBPI5kdI2OtTmm546T7xWKJWbof1AmEUNifIk3gGTCJEkdECWb4dVYsXUh62mAGbZHiG+OK5HF2JxfVWoBqhtgwVge1iPnMlLd7ZAlVHriEzpQ9P6Lv1O2ojJbQEVkjOAqDc8IOV8E5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791999597; c=relaxed/simple;
	bh=fG7/fP7pi3tm5Pq73QbzOTTMy8STSFMf9ElUBX+08pc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cmXAAOW6ePpvM+Z8fjEn/PnFeB/Z0q+4Jl9FhyTurUdjwcU7f6OMmeAzPZ6PlnrGHmmZNg6JC4s5eyR4O4lmD6ilry3PklbSNmnHoC6auySrlqv/qxKsu5I9gB5fWajM6WJgbW/KMdOtB0sERBSw0p+MJ9CSkkHvGuFQWsFcItc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XWriHRUv; arc=none smtp.client-ip=74.125.82.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XWriHRUv"
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-35c5aef2a74so5199336eec.0
        for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 10:39:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791999591; x=1792604391; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zgeJJ6nz9G6HsKtPd/C98X0YtcYl3yRWAWvu2AIxGIk=;
        b=XWriHRUva/aIiHZvXFgAYF2nDHQbS8r4GvJEOiKEVtxUXyZlNoymDVPspAxJ/XM644
         oylPQqB88IAVDc0F0P5YkgB1MmvoSi6f1Dn7qg/Nt9pOv2AiJcnYNMKxRie7D5rJCMtp
         DRP9MfZ04JNPn6m81o7CehRwphaI6TdmAmJRKkUP+dF3L0Un8mn7x7b1iQMBBKIYDln4
         esGNnbDf4Ak/eRMp1FSCjqdD8IJA4ZmI6ArId04RCGxps8AezBWFP7nWeJfIhGwk1Rl3
         Selm3GrH7PPwXvpb9hiiatY4MFJAFPX83X8Rd5Y3/8FHM7I7KBZVDl/prQv8GO/5Zae3
         G2IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791999591; x=1792604391;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zgeJJ6nz9G6HsKtPd/C98X0YtcYl3yRWAWvu2AIxGIk=;
        b=XskEVPpozy/M9GFOVLkZGlyy/ONXubeKa7385OK0IrkzF6RZYq8W95s4Mibfca7Lto
         l1LyC8PTZJE1sx7obdNA7zB8pOTcn6mLLM9rQ/Bj2oC4vEdGrl+AKGEBIDuhQJxQtsWJ
         0t4ge8wa//GZW5DFEJdWGkBBXlbBCa7mwDHqFntT9Vrm8ibmupTFR5Vm3tT2+e5i5+uw
         pbwsnAuAGYDhAwfGvkQsxwpV3zX4VVrxLNKPThzpvBI+40YFxXVNqihKE8Og48hCd/SN
         IZbXP1Qsyz2ugMUdDuneOtMhfrrpTHUKYWI7NyiN1fBH1flmju+9wqdl5uv9MHEpaQ31
         939A==
X-Forwarded-Encrypted: i=1; AKwUvByb/zQ8TKT24u9/u3ncMECmd7NSIz6Qtl2uZR/TqjPqfTzI1OtFTKxi9o56RpYGGxKNVchWxn5Ndb9u@vger.kernel.org
X-Gm-Message-State: AFq9FYKRWF7l2cmXWJMIrejBbdP+fC6p8lBObBwPT1HQrPW2l9jsIYDV
	Y6lqI818r3NSEwLW4hQO3x1gk8ljgd7eAjJby24OfrG++qEehPFAAo/GUPtA8qD/5cNzpiE9tl/
	AnW7JZ5lf7W/+9aBdyZliwVrfvw==
X-Received: from dyfv5.prod.google.com ([2002:a05:7300:8245:b0:350:9a68:218d])
 (user=almasrymina job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:693c:69c3:b0:358:3426:d606 with SMTP id 5a478bee46e88-3583426df51mr21121341eec.32.1791999590184;
 Wed, 14 Oct 2026 10:39:50 -0700 (PDT)
Date: Wed, 14 Oct 2026 17:37:18 +0000
In-Reply-To: <20261014173945.373295-1-almasrymina@google.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20261014173945.373295-1-almasrymina@google.com>
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
Message-ID: <20261014173945.373295-5-almasrymina@google.com>
Subject: [PATCH net-next v3 4/6] net: skbuff: replace __skb_frag_ref() with
 symmetric skb_netmem_ref()
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
	Wang Zhan <wang.zhan@smartx.com>, Willem de Bruijn <willemb@google.com>, 
	Antony Antony <antony.antony@secunet.com>, Stanislav Fomichev <sdf@fomichev.me>, 
	Daniel Borkmann <daniel@iogearbox.net>, Alexei Starovoitov <ast@kernel.org>, 
	Jesper Dangaard Brouer <hawk@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Previously, __skb_frag_ref() and skb_frag_ref() unconditionally
incremented the non-pp backing refcount via get_netmem(), while
skb_frag_unref() decremented pp_ref_count whenever skb->pp_recycle was
set. Ref-ing a page_pool fragment into a pp_recycle=1 SKB (or clearing
pp_recycle=0 on an uncloned SKB while clones still held pp_recycle=1)
leaked the backing non-pp refcount and underflowed pp_ref_count across
IP-TFS, skb_split(), skb_shift(), and cloned unclone paths.

Replace __skb_frag_ref() with skb_netmem_ref(netmem, recycle) as the
exact counterpart to skb_netmem_unref(netmem, recycle):

- Keep skb->pp_recycle intact in skb_release_data() so uncloning paths
  (pskb_expand_head() and pskb_carve_inside_{header,nonlinear}()) keep
  trading pp_ref_count references symmetrically across clones.
- Propagate pp_recycle and call skb_frag_ref() on the destination SKB in
  __pskb_copy_fclone(), skb_zerocopy(), skb_split(), skb_shift(), and
  skb_segment().
- Linearize an output segment's existing frags in skb_segment() before
  attaching frags from a frag_list SKB with a different pp_recycle bit,
  since each output segment carries a single pp_recycle bit.
- Use skb_frag_ref() in xfrm_iptfs, chcr_ktls, and cassini, and call
  get_netmem() directly in veth and tls_device_fallback where callers
  explicitly take a raw non-pp reference.

Found by code inspection while reviewing the IP-TFS pp_ref_count fix [1]
and confirmed with the KUnit tests added later in this series; not
observed in production. The xfrm_iptfs, chcr_ktls, cassini, veth, and
tls_device_fallback changes are compile-tested only.

Link: https://lore.kernel.org/netdev/xfrm-iptfs-pp_ref_count-underflow-v4-1-912fa72106f0@secunet.com/ [1]
Cc: Antony Antony <antony.antony@secunet.com>
Cc: Stanislav Fomichev <sdf@fomichev.me>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Jesper Dangaard Brouer <hawk@kernel.org>
Cc: bpf@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Mina Almasry <almasrymina@google.com>
---
v3:
- Linearize straddling output segments in skb_segment() when frag_list
  SKBs mix pp_recycle flags instead of clearing NETIF_F_SG (Sashiko).
- Link to v2: https://lore.kernel.org/netdev/20261012082148.1698596-5-almasrymina@google.com/

v2:
- Clear NETIF_F_SG in skb_segment() when frag_list SKBs mix pp_recycle
  flags.
- Note how the issue was found and how the change was tested.
- Link to v1: https://lore.kernel.org/netdev/20261010083935.3274178-5-almasrymina@google.com/
---
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c |  2 +-
 drivers/net/ethernet/sun/cassini.c            |  4 +-
 drivers/net/veth.c                            |  2 +-
 include/linux/skbuff_ref.h                    | 28 +++++++----
 net/core/skbuff.c                             | 48 ++++++++++---------
 net/tls/tls_device_fallback.c                 |  2 +-
 net/xfrm/xfrm_iptfs.c                         |  3 +-
 7 files changed, 51 insertions(+), 38 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
index dbec95b497773..4d645771596a8 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
@@ -1660,7 +1660,7 @@ static void chcr_ktls_copy_record_in_skb(struct sk_buff *nskb,
 	for (i = 0; i < record->num_frags; i++) {
 		skb_shinfo(nskb)->frags[i] = record->frags[i];
 		/* increase the frag ref count */
-		__skb_frag_ref(&skb_shinfo(nskb)->frags[i]);
+		skb_frag_ref(nskb, i);
 	}
 
 	skb_shinfo(nskb)->nr_frags = record->num_frags;
diff --git a/drivers/net/ethernet/sun/cassini.c b/drivers/net/ethernet/sun/cassini.c
index 9a8b5cf2d6485..02158a1bb2f70 100644
--- a/drivers/net/ethernet/sun/cassini.c
+++ b/drivers/net/ethernet/sun/cassini.c
@@ -1998,7 +1998,7 @@ static int cas_rx_process_pkt(struct cas *cp, struct cas_rx_comp *rxc,
 		skb->len      += hlen - swivel;
 
 		skb_frag_fill_page_desc(frag, page->buffer, off, hlen - swivel);
-		__skb_frag_ref(frag);
+		skb_frag_ref(skb, 0);
 
 		/* any more data? */
 		if ((words[0] & RX_COMP1_SPLIT_PKT) && ((dlen -= hlen) > 0)) {
@@ -2022,7 +2022,7 @@ static int cas_rx_process_pkt(struct cas *cp, struct cas_rx_comp *rxc,
 			frag++;
 
 			skb_frag_fill_page_desc(frag, page->buffer, 0, hlen);
-			__skb_frag_ref(frag);
+			skb_frag_ref(skb, 1);
 			RX_USED_ADD(page, hlen + cp->crc_size);
 		}
 
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 643b97dc52456..90a333ebab683 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -746,7 +746,7 @@ static void veth_xdp_get(struct xdp_buff *xdp)
 		return;
 
 	for (i = 0; i < sinfo->nr_frags; i++)
-		__skb_frag_ref(&sinfo->frags[i]);
+		get_netmem(skb_frag_netmem(&sinfo->frags[i]));
 }
 
 static int veth_convert_skb_to_xdp_buff(struct veth_rq *rq,
diff --git a/include/linux/skbuff_ref.h b/include/linux/skbuff_ref.h
index 04114c64dad99..f768a3fa1d606 100644
--- a/include/linux/skbuff_ref.h
+++ b/include/linux/skbuff_ref.h
@@ -12,26 +12,36 @@
 bool napi_pp_get_page(netmem_ref netmem);
 
 /**
- * __skb_frag_ref - take an addition reference on a paged fragment.
- * @frag: the paged fragment
+ * skb_netmem_ref - acquire a fragment reference on a netmem
+ * @netmem: netmem to reference
+ * @recycle: whether page_pool recycling is enabled (e.g. skb->pp_recycle)
  *
- * Takes an additional reference on the paged fragment @frag.
+ * Acquires pp_ref_count via napi_pp_get_page() if @recycle is true and
+ * @netmem belongs to a page_pool; otherwise acquires a non-pp backing
+ * reference via get_netmem(). Counterpart to skb_netmem_unref().
  */
-static __always_inline void __skb_frag_ref(skb_frag_t *frag)
+static __always_inline void skb_netmem_ref(netmem_ref netmem, bool recycle)
 {
-	get_netmem(skb_frag_netmem(frag));
+#ifdef CONFIG_PAGE_POOL
+	if (recycle && napi_pp_get_page(netmem))
+		return;
+#endif
+	get_netmem(netmem);
 }
 
 /**
- * skb_frag_ref - take an addition reference on a paged fragment of an skb.
+ * skb_frag_ref - acquire a reference on a paged fragment of an skb
  * @skb: the buffer
- * @f: the fragment offset.
+ * @f: the fragment offset
  *
- * Takes an additional reference on the @f'th paged fragment of @skb.
+ * Acquires a reference on the @f'th fragment of @skb via skb_netmem_ref()
+ * (pp_ref_count if skb->pp_recycle and page_pool-backed, else non-pp
+ * backing refcount). Counterpart to skb_frag_unref().
  */
 static __always_inline void skb_frag_ref(struct sk_buff *skb, int f)
 {
-	__skb_frag_ref(&skb_shinfo(skb)->frags[f]);
+	skb_netmem_ref(skb_frag_netmem(&skb_shinfo(skb)->frags[f]),
+		       skb->pp_recycle);
 }
 
 bool napi_pp_put_page(netmem_ref netmem);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 980bbe9166393..96088289c234d 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1133,7 +1133,7 @@ static void skb_release_data(struct sk_buff *skb, enum skb_drop_reason reason)
 	int i;
 
 	if (!skb_data_unref(skb, shinfo))
-		goto exit;
+		return;
 
 	if (skb_zcopy(skb)) {
 		bool skip_unref = shinfo->flags & SKBFL_MANAGED_FRAG_REFS;
@@ -1152,17 +1152,6 @@ static void skb_release_data(struct sk_buff *skb, enum skb_drop_reason reason)
 		kfree_skb_list_reason(shinfo->frag_list, reason);
 
 	skb_free_head(skb);
-exit:
-	/* When we clone an SKB we copy the reycling bit. The pp_recycle
-	 * bit is only set on the head though, so in order to avoid races
-	 * while trying to recycle fragments on skb_netmem_unref() we need
-	 * to make one SKB responsible for triggering the recycle path.
-	 * So disable the recycling bit if an SKB is cloned and we have
-	 * additional references to the fragmented part of the SKB.
-	 * Eventually the last SKB will have the recycling bit set and it's
-	 * dataref set to 0, which will trigger the recycling
-	 */
-	skb->pp_recycle = 0;
 }
 
 /*
@@ -2287,9 +2276,10 @@ struct sk_buff *__pskb_copy_fclone(struct sk_buff *skb, int headroom,
 			n = NULL;
 			goto out;
 		}
+		n->pp_recycle = skb->pp_recycle;
 		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
 			skb_shinfo(n)->frags[i] = skb_shinfo(skb)->frags[i];
-			skb_frag_ref(skb, i);
+			skb_frag_ref(n, i);
 		}
 		skb_shinfo(n)->nr_frags = i;
 		skb_shinfo(n)->flags |= skb_shinfo(skb)->flags & SKBFL_SHARED_FRAG;
@@ -3927,6 +3917,7 @@ skb_zerocopy(struct sk_buff *to, struct sk_buff *from, int len, int hlen)
 	if (len <= skb_tailroom(to))
 		return skb_copy_bits(from, 0, skb_put(to, len), len);
 
+	to->pp_recycle = from->pp_recycle;
 	if (hlen) {
 		ret = skb_copy_bits(from, 0, skb_put(to, hlen), hlen);
 		if (unlikely(ret))
@@ -3939,14 +3930,14 @@ skb_zerocopy(struct sk_buff *to, struct sk_buff *from, int len, int hlen)
 			offset = from->data - (unsigned char *)page_address(page);
 			__skb_fill_netmem_desc(to, 0, page_to_netmem(page),
 					       offset, plen);
-			get_page(page);
+			skb_frag_ref(to, 0);
 			j = 1;
 			len -= plen;
 		}
 	}
 
 	if (!skb_frags_readable(from) && j > 0 && len) {
-		put_page(page);
+		skb_frag_unref(to, 0);
 		return -EFAULT;
 	}
 
@@ -3954,7 +3945,7 @@ skb_zerocopy(struct sk_buff *to, struct sk_buff *from, int len, int hlen)
 
 	if (unlikely(skb_orphan_frags(from, GFP_ATOMIC))) {
 		if (j > 0)
-			put_page(page);
+			skb_frag_unref(to, 0);
 		return -ENOMEM;
 	}
 	skb_zerocopy_clone(to, from, GFP_ATOMIC);
@@ -4255,7 +4246,7 @@ static inline void skb_split_no_header(struct sk_buff *skb,
 				 *    where splitting is expensive.
 				 * 2. Split is accurately. We make this.
 				 */
-				skb_frag_ref(skb, i);
+				skb_frag_ref(skb1, k);
 				skb_frag_off_add(&skb_shinfo(skb1)->frags[0], len - pos);
 				skb_frag_size_sub(&skb_shinfo(skb1)->frags[0], len - pos);
 				skb_frag_size_set(&skb_shinfo(skb)->frags[i], len - pos);
@@ -4286,6 +4277,7 @@ void skb_split(struct sk_buff *skb, struct sk_buff *skb1, const u32 len)
 
 	skb_shinfo(skb1)->flags |= skb_shinfo(skb)->flags & zc_flags;
 	skb_zerocopy_clone(skb1, skb, 0);
+	skb1->pp_recycle = skb->pp_recycle;
 	if (len < pos)	/* Split line is inside header. */
 		skb_split_inside_header(skb, skb1, len, pos);
 	else		/* Second chunk has no header, nothing to copy. */
@@ -4343,8 +4335,8 @@ int skb_shift(struct sk_buff *tgt, struct sk_buff *skb, int shiftlen)
 	/* Actual merge is delayed until the point when we know we can
 	 * commit all, so that we don't have to undo partial changes
 	 */
-	if (!skb_can_coalesce(tgt, to, skb_frag_page(fragfrom),
-			      skb_frag_off(fragfrom))) {
+	if (!skb_can_coalesce_netmem(tgt, to, skb_frag_netmem(fragfrom),
+				     skb_frag_off(fragfrom))) {
 		merge = -1;
 	} else {
 		merge = to - 1;
@@ -4391,8 +4383,8 @@ int skb_shift(struct sk_buff *tgt, struct sk_buff *skb, int shiftlen)
 			to++;
 
 		} else {
-			__skb_frag_ref(fragfrom);
 			skb_frag_page_copy(fragto, fragfrom);
+			skb_frag_ref(tgt, to);
 			skb_frag_off_copy(fragto, fragfrom);
 			skb_frag_size_set(fragto, todo);
 
@@ -5057,6 +5049,16 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
 
 		while (pos < offset + len) {
 			if (i >= nfrags) {
+				if (skb_shinfo(nskb)->nr_frags &&
+				    nskb->pp_recycle != list_skb->pp_recycle) {
+					nskb->data_len = pos - offset - hsize;
+					nskb->len += nskb->data_len;
+					nskb->truesize += nskb->data_len;
+					if (__skb_linearize(nskb))
+						goto err;
+					hsize = pos - offset;
+					nskb_frag = skb_shinfo(nskb)->frags;
+				}
 				if (skb_orphan_frags(list_skb, GFP_ATOMIC) ||
 				    skb_zerocopy_clone(nskb, list_skb,
 						       GFP_ATOMIC))
@@ -5091,8 +5093,10 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
 				goto err;
 			}
 
+			if (!skb_shinfo(nskb)->nr_frags)
+				nskb->pp_recycle = frag_skb->pp_recycle;
 			*nskb_frag = (i < 0) ? skb_head_frag_to_page_desc(frag_skb) : *frag;
-			__skb_frag_ref(nskb_frag);
+			skb_frag_ref(nskb, skb_shinfo(nskb)->nr_frags);
 			size = skb_frag_size(nskb_frag);
 
 			if (pos < offset) {
@@ -6307,7 +6311,7 @@ bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
 	 */
 	if (skb_pp_frag_ref(from)) {
 		for (i = 0; i < from_shinfo->nr_frags; i++)
-			__skb_frag_ref(&from_shinfo->frags[i]);
+			get_netmem(skb_frag_netmem(&from_shinfo->frags[i]));
 	}
 
 	to->truesize += delta;
diff --git a/net/tls/tls_device_fallback.c b/net/tls/tls_device_fallback.c
index 3b7d0ab2bcf17..35cc510db4321 100644
--- a/net/tls/tls_device_fallback.c
+++ b/net/tls/tls_device_fallback.c
@@ -256,7 +256,7 @@ static int fill_sg_in(struct scatterlist *sg_in,
 	for (i = 0; remaining > 0; i++) {
 		skb_frag_t *frag = &record->frags[i];
 
-		__skb_frag_ref(frag);
+		get_netmem(skb_frag_netmem(frag));
 		sg_set_page(sg_in + i, skb_frag_page(frag),
 			    skb_frag_size(frag), skb_frag_off(frag));
 
diff --git a/net/xfrm/xfrm_iptfs.c b/net/xfrm/xfrm_iptfs.c
index 6920940a35b49..103cf7c5dbfb9 100644
--- a/net/xfrm/xfrm_iptfs.c
+++ b/net/xfrm/xfrm_iptfs.c
@@ -486,8 +486,7 @@ static int iptfs_skb_add_frags(struct sk_buff *skb,
 			tofrag->len -= offset;
 			offset = 0;
 		}
-		__skb_frag_ref(tofrag);
-		shinfo->nr_frags++;
+		skb_frag_ref(skb, shinfo->nr_frags++);
 		shinfo->flags |= SKBFL_SHARED_FRAG;
 
 		/* see if we are done */
-- 
2.56.0.212.g129ede20d9-goog

