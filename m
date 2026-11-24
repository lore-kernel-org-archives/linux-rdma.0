Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795525144;
	b=pmbRBNI1+tbCiM172D+j/oDxgMzf2Lks1Jp10L+8vE04IcAxTU6TALRTgnz4XhTgClTm
	 /teYpgBkHNpEgVq0A9lWWkHyKBcsWuKUU1u1mcbL37bkvVTfiX+JhFBI7h0ydujxjo3cf
	 EElhLgonVFZwjYKp2k+DBPsrBVvVDKcbz87sAx61bUeTNjcLepR6kmVYlN2Gx02ccHaOz
	 kCn+BSWa/YsGqFJPxly3gjk5k/TvbCh5bs3/L+7i6bd73NH+2zK6P50jk+DJpo/itBEX+
	 QPsAQ0nQsBakZAfnKREFOEP937gJwNSVBu4IZLVmsCBkqG30WmoJJ/As+so29Gd2pDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795525144;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=sOrW8WAVqGhN7ypdWI21rgk1hDNeJGcR+x3MXFy7pYg=;
	b=p3fq83YHj2f/UJ2q9xxEW4cJz0H6sVI+I2jY7h5D658N/UlMJCk/CQPuDfc8r4Rr4xyZ
	 bCt99/QQ2VWJZ9UngNn6HrGC0BdWrhMrvM9fVxPQXqs4RgdwO1H+kR/7bvAMXhzStUQ3y
	 bEG3RX0nA8IGPbeQeT//9B5h+9AQpF8MRcf0uxj5cJaN0qRbMOwHjWVkinruaQ1z2myuj
	 jouMCYdj0LLRp2U8IUtfe7zHBKdXgtuch5kwG4hIcCMrWRkgshSJRXj3eSczoASI9jCPV
	 rTwUHh2oi9H4dH1Baq9baeOqpK0XpprwuJBNOC/L0/tNWK3D6K3zvYnkjOONbSCHUjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mUCPjvQ2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF48606A31E;
	Tue, 24 Nov 2026 12:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mUCPjvQ2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEC471F000C4;
	Tue, 24 Nov 2026 12:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795525144;
	bh=sOrW8WAVqGhN7ypdWI21rgk1hDNeJGcR+x3MXFy7pYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mUCPjvQ2S2oh7rzDoY6gQPx11eJ5wnU5A2r54ewy3KJ9dXjXyj2Y8H3gF2OS0ZiBS
	 SjXimE94snAAQZy8BkI+IWSA7kij7KzsTQlXd99w4ABEWPJyHdmoa5GC4BgxxeupAj
	 saKQB+bUWTx64cqNuo0fWZIen0vqlNvRlr97fwHWUU36udESPI5+QXomUkcCfMMzG4
	 YU4uwPFMhVIp5rdiUU9HjWuyrvBV97mHqrM0MElRNSokVAbFxRrPcEpS5V0mMlxKdU
	 WueckzN5RExN/b93jGWBpH2SldXscHzKbTqBmZGyv8UH/vF+tOxO7+GjIGCLZ5F9wr
	 cldmqg+lQSvag==
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
Subject: [PATCH net-next 10/15] eth: fbnic: Receive into XDP-only memory providers
Date: Tue, 24 Nov 2026 13:56:45 +0100
Message-ID: <20261124125654.183091-10-bjorn@kernel.org>
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

Currently, fbnic takes the address of an RX head as a page address and
puts the head back by that address, so an XDP-only memory provider,
such as the AF_XDP sink, cannot back its RX pool. Otherwise fbnic
builds XDP buffers from page pool netmem and splits pages with page
pool fragments, all that such a provider needs.

Let the header page pool, which the payload ring shares without header
split, take an XDP-only provider, and handle heads by their netmem,
taking their address with xdp_netmem_address().

The core turns XDP_TX and XDP_PASS on XDP-only buffers into drops, so
fbnic needs no checks of its own. fbnic skips the prefetch of an
XDP-only head, as the kernel reads it only if the program does, and
the prefetch may cost a page walk. Redirects are flushed after the
poll has freed its buffers, so the provider takes them back in the
same poll. The frame of an XDP buffer ends at the headroom of the next
one, so a program may grow the tail of an XDP-only buffer into the
room that fbnic leaves for a shared info.

Signed-off-by: Björn Töpel <bjorn@kernel.org>
---
 drivers/net/ethernet/meta/fbnic/fbnic_txrx.c | 33 ++++++++++----------
 drivers/net/ethernet/meta/fbnic/fbnic_txrx.h |  2 ++
 2 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
index 2c8276d23a15..c2e20a7b36a8 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
@@ -765,15 +765,14 @@ static void fbnic_page_pool_init(struct fbnic_ring *ring, unsigned int idx,
 	rx_buf->netmem = netmem;
 }
 
-static struct page *
+static netmem_ref
 fbnic_page_pool_get_head(struct fbnic_q_triad *qt, unsigned int idx)
 {
 	struct fbnic_rx_buf *rx_buf = &qt->sub0.rx_buf[idx];
 
 	rx_buf->pagecnt_bias--;
 
-	/* sub0 is always fed system pages, from the NAPI-level page_pool */
-	return netmem_to_page(rx_buf->netmem);
+	return rx_buf->netmem;
 }
 
 static netmem_ref
@@ -1001,13 +1000,12 @@ static void fbnic_pkt_prepare(struct fbnic_napi_vector *nv, u64 rcd,
 	unsigned int len = FIELD_GET(FBNIC_RCD_AL_BUFF_LEN_MASK, rcd);
 	unsigned int hdr_pg_idx = fbnic_rcd_bd_idx(&qt->sub0, rcd);
 	unsigned int frame_sz, hdr_pg_start, hdr_pg_end, headroom;
-	unsigned char *hdr_start;
-	struct page *page;
+	netmem_ref netmem;
 
 	/* data_hard_start should always be NULL when this is called */
 	WARN_ON_ONCE(pkt->buff.data_hard_start);
 
-	page = fbnic_page_pool_get_head(qt, hdr_pg_idx);
+	netmem = fbnic_page_pool_get_head(qt, hdr_pg_idx);
 
 	/* Short-cut the end calculation if we know page is fully consumed */
 	hdr_pg_end = FIELD_GET(FBNIC_RCD_AL_PAGE_FIN, rcd) ?
@@ -1020,15 +1018,20 @@ static void fbnic_pkt_prepare(struct fbnic_napi_vector *nv, u64 rcd,
 	hdr_pg_start += fbnic_rcd_bd_page_offset(&qt->sub0, rcd);
 
 	/* Sync DMA buffer */
-	dma_sync_single_range_for_cpu(nv->dev, page_pool_get_dma_addr(page),
+	dma_sync_single_range_for_cpu(nv->dev,
+				      page_pool_get_dma_addr_netmem(netmem),
 				      hdr_pg_start, frame_sz,
 				      DMA_BIDIRECTIONAL);
 
 	/* Build frame around buffer */
-	hdr_start = page_address(page) + hdr_pg_start;
-	net_prefetch(hdr_start + headroom);
-	xdp_prepare_buff(&pkt->buff, hdr_start, headroom,
-			 len - FBNIC_RX_PAD, true);
+	xdp_prepare_buff(&pkt->buff, xdp_netmem_address(netmem) + hdr_pg_start,
+			 headroom, len - FBNIC_RX_PAD, true);
+	pkt->head = netmem;
+	/* The kernel reads an XDP-only head only if the program does, and a
+	 * prefetch may cost a page walk
+	 */
+	if (!netmem_is_net_iov(netmem))
+		net_prefetch(pkt->buff.data);
 
 	pkt->hwtstamp = 0;
 	pkt->add_frag_failed = false;
@@ -1072,8 +1075,6 @@ static void fbnic_add_rx_frag(struct fbnic_napi_vector *nv, u64 rcd,
 static void fbnic_put_pkt_buff(struct fbnic_q_triad *qt,
 			       struct fbnic_pkt_buff *pkt, int budget)
 {
-	struct page *page;
-
 	if (!pkt->buff.data_hard_start)
 		return;
 
@@ -1092,8 +1093,7 @@ static void fbnic_put_pkt_buff(struct fbnic_q_triad *qt,
 		}
 	}
 
-	page = virt_to_page(pkt->buff.data_hard_start);
-	page_pool_put_full_page(qt->sub0.page_pool, page, !!budget);
+	page_pool_put_full_netmem(qt->sub0.page_pool, pkt->head, !!budget);
 }
 
 static struct sk_buff *fbnic_build_skb(struct fbnic_napi_vector *nv,
@@ -1611,7 +1611,8 @@ fbnic_alloc_qt_page_pools(struct fbnic_net *fbn, struct fbnic_q_triad *qt,
 	struct page_pool_params pp_params = {
 		.order = 0,
 		.flags = PP_FLAG_DMA_MAP |
-			 PP_FLAG_DMA_SYNC_DEV,
+			 PP_FLAG_DMA_SYNC_DEV |
+			 PP_FLAG_ALLOW_XDP_ONLY_NETMEM,
 		.pool_size = fbn->hpq_size + fbn->ppq_size,
 		.nid = NUMA_NO_NODE,
 		.dev = fbn->netdev->dev.parent,
diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.h b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.h
index 7bc0c25ac50b..ea5f70462aa6 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.h
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.h
@@ -81,6 +81,8 @@ struct fbnic_net;
 
 struct fbnic_pkt_buff {
 	struct xdp_buff buff;
+	/* Head buffer, from the HPQ */
+	netmem_ref head;
 	ktime_t hwtstamp;
 	bool add_frag_failed;
 };
-- 
2.56.1

