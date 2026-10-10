Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C8D3C1D61
	for <linux-rdma@vger.kernel.org>; Sat, 10 Oct 2026 08:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791621587; cv=none; b=El/b8iRhZE/PTT6Gm2FRRBjFK9jA07jKKP3ZQGbSml5LcT5ck6EOAsoM8TN+AaIQzg0UzmVhDMF97oJ8UOEFiMMocPo1iEyiXfJhCQD11RTqOVGaX0NAfZn9odLYubp9vTP9boaKdKmcdSC5L6ohDo+HIEHRLgRfvMykGhkwYVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791621587; c=relaxed/simple;
	bh=XZfRRA8njc8T7eXhDgBy9fXoUa1txTmMPFGwEFLzZfU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fGFbxKBkVG+TINJj43n2hxuQ35i2Qi6WytfZM1Ooe5IdNei8KP7H8xCKhN7B5Rz0n1oiAbe2PY8QA18Qwc2VDbJysI+FC0+8SJTu/s3i8tG/BuIM3I3DjFENPSqnGBkaHe9SEsePiBoRhZOkpReV0s8gbvxD5mqlylzrBgwyqFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fyCzn7Fc; arc=none smtp.client-ip=74.125.82.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fyCzn7Fc"
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-3580c07911eso188081eec.0
        for <linux-rdma@vger.kernel.org>; Sat, 10 Oct 2026 01:39:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791621580; x=1792226380; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Rbq3RYnRWFUfDwDIbFHMIn2Lp3q6/sI3XnYOQmlC5S8=;
        b=fyCzn7FcjxA5UVLKtlYaCRseqMOGb6oUIjUiCITo4EqSjYqKQ1epsYoTytYSza75N4
         hdRax85v4/0bBG118FbmkxpYyZ1aMOq7mNi1JeMtIbLvd0H5On1I6UzZmtiup20DmcIA
         xkA8k/K68vjL8Yn4CWeAyF4OFN2DMDMP7vP1oAwwg84+Mo75NEX9Fc8YdOLDERwuJZ+f
         ZPpmwMKXVr0LdyeIV/fBA7b06kFH8vYJfHbgXgwNZOyGYK6EG/IYBAqbglpfB2N69mKc
         z1zlJyW4BbmQI0C3scgNUpU3MM2vZZ5RrUufuqKNKZqFaSn5zyTOcJQVnWoBJjL2v5ex
         zRlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791621581; x=1792226381;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Rbq3RYnRWFUfDwDIbFHMIn2Lp3q6/sI3XnYOQmlC5S8=;
        b=LfQbC6UQPK61drqQqQZWSz+p+HK3aFrz/wuxMom0ZjrIHLd2MBw47BfhsjaWqaAaGT
         Tm0vV0BelfxE5wrTaJWPWIcND3qYMBr21848yuaAaEXS2v/LCCuFGQi+FeutPFOqmcP9
         7T7oAybae85xrfdL5E0nBkMJbmMkL8TY8U7t9siAnykSELUFvkQXJGN3aMvDThNBpb1f
         mvE2g6Q43GGmCsK0GSre4EBw4YVvbTcGEK/W9Z3ljOHNjzwyt0Kh7vs2ZerqKS60aDHM
         ZCG6RE5eykv0VJoQX9QrBwTfg4upDkm+xt+idFuOoIzYz/a5YTjqw7kAMcrYzqWeYD+H
         9z+w==
X-Forwarded-Encrypted: i=1; AKwUvBzXZh+HaEyp4T2SldeRnfEaIuPc+Ap23XvUPXc5Wncqp+h47DjHMb0wB2fvh69O0V3MxNJePTq7Ot9r@vger.kernel.org
X-Gm-Message-State: AFq9FYKTe2GiVGvkIpsCdI8GVtswDjAb/cqANpBZm3lAPPoXNX/ThQ1s
	FLZrqi+S+NkUOcOKK4Z9cr8ogtZnSwEgmrEuSnerF3lptushwv+s+oukrM5TcNStUp7uZ0at4kp
	mhNeHCwinG7zj7dJVrtMc70oTVw==
X-Received: from dyjg26.prod.google.com ([2002:a05:7300:559a:b0:351:1776:5155])
 (user=almasrymina job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7300:d117:b0:33e:84c3:a05b with SMTP id 5a478bee46e88-3537e0e65f4mr5233251eec.30.1791621579847;
 Sat, 10 Oct 2026 01:39:39 -0700 (PDT)
Date: Sat, 10 Oct 2026 08:38:45 +0000
In-Reply-To: <20261010083935.3274178-1-almasrymina@google.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20261010083935.3274178-1-almasrymina@google.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261010083935.3274178-5-almasrymina@google.com>
Subject: [PATCH net-next v1 4/6] net: skbuff: replace __skb_frag_ref() with
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
	Michael Grzeschik <mgr@kernel.org>, 
	"=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20=28The=20Capable=20Hub=29?=" <u.kleine-koenig@baylibre.com>, Petr Machata <petrm@nvidia.com>, 
	Arend van Spriel <arend.vanspriel@broadcom.com>, Jakub Raczynski <j.raczynski@samsung.com>, 
	Stanislav Fomichev <sdf@fomichev.me>, Daniel Borkmann <daniel@iogearbox.net>, 
	Alexei Starovoitov <ast@kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>
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
- Use skb_frag_ref() in xfrm_iptfs, chcr_ktls, and cassini, and call
  get_netmem() directly in veth and tls_device_fallback where callers
  explicitly take a raw non-pp reference.

Cc: Stanislav Fomichev <sdf@fomichev.me>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Jesper Dangaard Brouer <hawk@kernel.org>
Cc: bpf@vger.kernel.org
Signed-off-by: Mina Almasry <almasrymina@google.com>
---
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c |  2 +-
 drivers/net/ethernet/sun/cassini.c            |  4 +-
 drivers/net/veth.c                            |  2 +-
 include/linux/skbuff_ref.h                    | 28 +++++++++-----
 net/core/skbuff.c                             | 38 ++++++++-----------
 net/tls/tls_device_fallback.c                 |  2 +-
 net/xfrm/xfrm_iptfs.c                         |  3 +-
 7 files changed, 41 insertions(+), 38 deletions(-)

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
index 46da61ad1f9eb..f03ce8d5ae585 100644
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
 
@@ -5087,8 +5079,10 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
 				goto err;
 			}
 
+			if (!skb_shinfo(nskb)->nr_frags)
+				nskb->pp_recycle = frag_skb->pp_recycle;
 			*nskb_frag = (i < 0) ? skb_head_frag_to_page_desc(frag_skb) : *frag;
-			__skb_frag_ref(nskb_frag);
+			skb_frag_ref(nskb, skb_shinfo(nskb)->nr_frags);
 			size = skb_frag_size(nskb_frag);
 
 			if (pos < offset) {
@@ -6303,7 +6297,7 @@ bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
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
2.56.0.385.gd3acb90ef8-goog

