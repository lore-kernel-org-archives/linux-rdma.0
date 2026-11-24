Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795525180;
	b=ie/pbKEvZNv0ocgiHKKjYLTtYRcYxu1cbcqf0S7MXLqhm70fAb4qQ5l0mY1sTf0Zcref
	 dTcNDywptTltjBC6wD1v/dxRMVgEA0vDuSceGh3aaaUjf4XBBTPzbbeVynm5/LQe3+yJv
	 GXw9CBNbQX8U4umEUtMcLPjB3VI8NsxNVHZQ0HPtO1VPA9C835SDLyVjabRz57/D61XY/
	 a00vsEzJIa/7f2IsXVxBlkcTc0ASBj7c5TiNxlTSUOy5/dso+yvpisL3fQNKYXHhn6K2f
	 qO1ZWG1vLWUlf+Rk8+dKGAX33oi3V8MR5v7x22ZcQe/9KGVU/wPpEImW/6UIu7632xQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795525180;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=kXz5aQB+js+kjiVFJryv2jRTzwBXlByubiGnf5jZWbY=;
	b=27X+0kF1hrokpgqS38oj9eKynkFivnV3gQJ3TpVkbHMTAbyYrxvJ/1hjWDWEoYlJD9OQ
	 j1uXl7/dTAyX2h+nIzC9OZclsV/olb4iO/2zxWa4frooxdk/PB9TGC/zrD7muA1VD0lYz
	 4dQc/W37i9f5fVO36kdxh1hB6JdmheV8JYogFnHvoimogpdTfLHX4NnpqRdkSRaTMxrGm
	 mRpIuM++NxlQB6qxBFn0kCF+nTQ+eY3jYT2FcIOrxdDMTzl+AlATHLlqkTN+CeGaFaHR8
	 J+c2wUTFOWrkznnxk5nyYRK1V3wkmEpRUoeyqq6ihzNpvMq4gjkmSt6/GltQH1h30xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OtksboiA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E593C606A31E;
	Tue, 24 Nov 2026 12:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OtksboiA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 945491F000C6;
	Tue, 24 Nov 2026 12:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795525179;
	bh=kXz5aQB+js+kjiVFJryv2jRTzwBXlByubiGnf5jZWbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OtksboiADFh0t1EPBTUcJxlQxAU24i17zh185Nv11/t3ao2Dck89gMc7B0DrAL7qH
	 IorAWC1ZA7CQER0i6sdkcbWYIhHEAJ/xl6n/tXDtP2RusIJ2XNconwHBlu4KMoa8lK
	 Wp63mpqSYuvv8SnEGzcCHEAFybTX/b/GB8RTtsy9EZNGNTQgm7NxxZ9pL8mIRh4nWW
	 sEf8gvPKGIyhGbKCovBJMNsLXPZVJEDDHEBErswXtuMmvNDvQ3iDUdGvtclPOV8Ge3
	 TB1/PPF/6MoqvhE7NEz/jiMd+bGHsigTUOFPBFBNlsvP9Aa3Pqo9zNoOp+KgNyfzEF
	 wQRJWsLfbmQfg==
From: =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>
To: Magnus Karlsson <magnus.karlsson@intel.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Alexander Duyck <alexanderduyck@fb.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Michael Chan <michael.chan@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <shuah@kernel.org>,
	bpf@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Stuart Clark <stuclar@meta.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Simon Horman <horms@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Mina Almasry <almasrymina@google.com>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Randy Dunlap <rdunlap@infradead.org>,
	kernel-team@meta.com,
	Dimitri Daskalakis <dimitri.daskalakis1@gmail.com>,
	Bobby Eshleman <bobbyeshleman@meta.com>,
	Mohsin Bashir <mohsin.bashr@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Breno Leitao <leitao@debian.org>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Tao Cui <cuitao@kylinos.cn>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	"Mike Marciniszyn (Meta)" <mike.marciniszyn@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Martin Karsten <mkarsten@uwaterloo.ca>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	David Wei <dw@davidwei.uk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-rdma@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next 13/15] eth: bnxt: Receive into XDP-only memory providers
Date: Tue, 24 Nov 2026 13:56:48 +0100
Message-ID: <20261124125654.183091-13-bjorn@kernel.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261124112707.118678-1-bjorn@kernel.org>
References: <20261124112707.118678-1-bjorn@kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Currently, bnxt takes RX heads as pages in page mode, which XDP needs,
and frees XDP fragments with page APIs, so an XDP-only memory
provider, such as the AF_XDP sink, cannot back its page pool.

Handle heads and fragments as netmem in page mode, and let the page
pool take XDP-only providers.

Page-mode heads take their address with xdp_netmem_address(), which is
the page address for system pages, and system pages keep their bits in
the netmem, so the skb paths do not change. As for any provider,
page_pool_is_unreadable() is true for an XDP-only one, so bnxt also
sets up its separate head pool, which page mode leaves empty. The core
turns XDP_TX and XDP_PASS on XDP-only buffers into drops, so bnxt
needs no checks of its own. The frame of an XDP buffer ends with its
head buffer, so a program may grow the tail of an XDP-only buffer into
the room that bnxt leaves for a shared info.

Signed-off-by: Björn Töpel <bjorn@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 39 ++++++-------------
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c | 19 +++++----
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h |  2 +-
 3 files changed, 23 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 5c6c2219a481..465465db53ba 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -962,27 +962,6 @@ static bool bnxt_separate_head_pool(struct bnxt_rx_ring_info *rxr)
 	return rxr->need_head_pool || rxr->rx_page_size < PAGE_SIZE;
 }
 
-static struct page *__bnxt_alloc_rx_page(struct bnxt *bp, dma_addr_t *mapping,
-					 struct bnxt_rx_ring_info *rxr,
-					 unsigned int *offset,
-					 gfp_t gfp)
-{
-	struct page *page;
-
-	if (rxr->rx_page_size < PAGE_SIZE) {
-		page = page_pool_dev_alloc_frag(rxr->page_pool, offset,
-						rxr->rx_page_size);
-	} else {
-		page = page_pool_dev_alloc_pages(rxr->page_pool);
-		*offset = 0;
-	}
-	if (!page)
-		return NULL;
-
-	*mapping = page_pool_get_dma_addr(page) + *offset;
-	return page;
-}
-
 static netmem_ref __bnxt_alloc_rx_netmem(struct bnxt *bp, dma_addr_t *mapping,
 					 struct bnxt_rx_ring_info *rxr,
 					 unsigned int *offset,
@@ -1029,15 +1008,17 @@ int bnxt_alloc_rx_data(struct bnxt *bp, struct bnxt_rx_ring_info *rxr,
 
 	if (BNXT_RX_PAGE_MODE(bp)) {
 		unsigned int offset;
-		struct page *page =
-			__bnxt_alloc_rx_page(bp, &mapping, rxr, &offset, gfp);
+		netmem_ref netmem =
+			__bnxt_alloc_rx_netmem(bp, &mapping, rxr, &offset, gfp);
 
-		if (!page)
+		if (!netmem)
 			return -ENOMEM;
 
+		/* Same bits as the struct page for system pages */
 		mapping += bp->rx_dma_offset;
-		rx_buf->data = page;
-		rx_buf->data_ptr = page_address(page) + offset + bp->rx_offset;
+		rx_buf->data = (__force void *)netmem;
+		rx_buf->data_ptr = xdp_netmem_address(netmem) + offset +
+				   bp->rx_offset;
 		rx_buf->offset = offset;
 	} else {
 		u8 *data = __bnxt_alloc_rx_frag(bp, &mapping, rxr, gfp);
@@ -3593,13 +3574,14 @@ static void bnxt_free_one_rx_ring(struct bnxt *bp, struct bnxt_rx_ring_info *rxr
 	for (i = 0; i < max_idx; i++) {
 		struct bnxt_sw_rx_bd *rx_buf = &rxr->rx_buf_ring[i];
 		void *data = rx_buf->data;
+		netmem_ref netmem = (__force netmem_ref)data;
 
 		if (!data)
 			continue;
 
 		rx_buf->data = NULL;
 		if (BNXT_RX_PAGE_MODE(bp))
-			page_pool_recycle_direct(rxr->page_pool, data);
+			page_pool_recycle_direct_netmem(rxr->page_pool, netmem);
 		else
 			page_pool_free_va(rxr->head_pool, data, true);
 	}
@@ -3969,7 +3951,8 @@ static int bnxt_alloc_rx_page_pool(struct bnxt *bp,
 	pp.dma_dir = bp->rx_dir;
 	pp.max_len = PAGE_SIZE << pp.order;
 	pp.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV |
-		   PP_FLAG_ALLOW_UNREADABLE_NETMEM;
+		   PP_FLAG_ALLOW_UNREADABLE_NETMEM |
+		   PP_FLAG_ALLOW_XDP_ONLY_NETMEM;
 	pp.queue_idx = rxr->bnapi->index;
 
 	pool = page_pool_create(&pp);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index 161e0dd62be6..8ad04b36d4f0 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -210,9 +210,9 @@ void bnxt_xdp_buff_frags_free(struct bnxt_rx_ring_info *rxr,
 		return;
 	shinfo = xdp_get_shared_info_from_buff(xdp);
 	for (i = 0; i < shinfo->nr_frags; i++) {
-		struct page *page = skb_frag_page(&shinfo->frags[i]);
+		netmem_ref netmem = skb_frag_netmem(&shinfo->frags[i]);
 
-		page_pool_recycle_direct(rxr->page_pool, page);
+		page_pool_recycle_direct_netmem(rxr->page_pool, netmem);
 	}
 	shinfo->nr_frags = 0;
 }
@@ -222,7 +222,7 @@ void bnxt_xdp_buff_frags_free(struct bnxt_rx_ring_info *rxr,
  * false   - packet should be passed to the stack.
  */
 bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
-		 struct xdp_buff *xdp, struct page *page, u8 **data_ptr,
+		 struct xdp_buff *xdp, void *data, u8 **data_ptr,
 		 unsigned int *len, u8 *event)
 {
 	struct bpf_prog *xdp_prog = READ_ONCE(rxr->xdp_prog);
@@ -278,7 +278,7 @@ bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
 		if (tx_avail < tx_needed) {
 			trace_xdp_exception(bp->dev, xdp_prog, act);
 			bnxt_xdp_buff_frags_free(rxr, xdp);
-			bnxt_reuse_rx_data(rxr, cons, page);
+			bnxt_reuse_rx_data(rxr, cons, data);
 			return true;
 		}
 
@@ -289,7 +289,7 @@ bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
 		*event |= BNXT_TX_EVENT;
 		__bnxt_xmit_xdp(bp, txr, mapping + offset, *len,
 				NEXT_RX(rxr->rx_prod), xdp);
-		bnxt_reuse_rx_data(rxr, cons, page);
+		bnxt_reuse_rx_data(rxr, cons, data);
 		return true;
 	case XDP_REDIRECT:
 		/* if we are calling this here then we know that the
@@ -301,14 +301,17 @@ bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
 		if (bnxt_alloc_rx_data(bp, rxr, rxr->rx_prod, GFP_ATOMIC)) {
 			trace_xdp_exception(bp->dev, xdp_prog, act);
 			bnxt_xdp_buff_frags_free(rxr, xdp);
-			bnxt_reuse_rx_data(rxr, cons, page);
+			bnxt_reuse_rx_data(rxr, cons, data);
 			return true;
 		}
 
 		if (xdp_do_redirect(bp->dev, xdp, xdp_prog)) {
+			/* data holds the netmem of the head */
+			netmem_ref head = (__force netmem_ref)data;
+
 			trace_xdp_exception(bp->dev, xdp_prog, act);
 			bnxt_xdp_buff_frags_free(rxr, xdp);
-			page_pool_recycle_direct(rxr->page_pool, page);
+			page_pool_recycle_direct_netmem(rxr->page_pool, head);
 			return true;
 		}
 
@@ -322,7 +325,7 @@ bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
 		fallthrough;
 	case XDP_DROP:
 		bnxt_xdp_buff_frags_free(rxr, xdp);
-		bnxt_reuse_rx_data(rxr, cons, page);
+		bnxt_reuse_rx_data(rxr, cons, data);
 		break;
 	}
 	return true;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h
index fb4f9143929f..f9ec204ceb9e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h
@@ -25,7 +25,7 @@ struct bnxt_sw_tx_bd *bnxt_xmit_bd(struct bnxt *bp,
 				   struct xdp_buff *xdp);
 void bnxt_tx_int_xdp(struct bnxt *bp, struct bnxt_napi *bnapi, int budget);
 bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
-		 struct xdp_buff *xdp, struct page *page, u8 **data_ptr,
+		 struct xdp_buff *xdp, void *data, u8 **data_ptr,
 		 unsigned int *len, u8 *event);
 int bnxt_xdp(struct net_device *dev, struct netdev_bpf *xdp);
 int bnxt_xdp_xmit(struct net_device *dev, int num_frames,
-- 
2.56.1

