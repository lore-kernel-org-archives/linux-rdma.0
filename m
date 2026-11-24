Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795525072;
	b=2ELrbTgmNITLFp8hBgw2UbC9k7+eVTuCjMASYFMkaLd6G5xYL3y1WP3Oi9eZ9eINtZi4
	 2vUPe4uS082wqFeIIF4nkYG5rVVeX9hbHotzhtiWE7KYUSS01rIAvzoFagD5Vfz15Ic0r
	 F0v6wj7glAVWjExBzPdBTDIWjZYJAg8ghl9BJ1HukGra866Kti0AiDfuzW6tftpPlO5HE
	 zE188c8TPhg2aKheUDHqBR7f5CP6Kt+VTFX/4tOxzySuMk/22d0D7xtOlfquAOMeuJmbs
	 slZAv0/sZVKEh7K5yEoky7okvT9eospTOexYRXf/FzAVlHFySPUmbqEa9aYAyhGj04w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795525072;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=D1yRI2yItmD+irGFKYrlKRL9eZ4pOJtSvhWJj7f6yqk=;
	b=PU+Fd+vvwS8DfpZajmjE5BsLkNy9Feop6FboUU3KY536DBncr+3mH9uSj1qt0ptn6T9g
	 EhCb93RQemTc6QMIM3ajOncBbUCUs4oONGfE5ceAOKZZVwRZsbOw8smAuhtUBhjRRSrJg
	 2SwYTCNRbdMYvTEFhrnm/x3ZKn64iaip0OCyJKAcJvf48u0i4pwggL4ou1TcOI8j6DtIO
	 cjXqQT5KGyQnG3yRfnbGIuQ3i0yU6QDgqBW8Ab1JN61TK82TCFinRCVgri/39NpQnnIhV
	 a7MzMGaMezEsalkuemLNKliqJhldVPE9nkoMek5lUAo27RaJK6r0CjCuL0WwFsS8ihw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PCjZ+DFd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA80606A31E;
	Tue, 24 Nov 2026 12:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PCjZ+DFd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23DEF1F000D1;
	Tue, 24 Nov 2026 12:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795525071;
	bh=D1yRI2yItmD+irGFKYrlKRL9eZ4pOJtSvhWJj7f6yqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PCjZ+DFdac0b8hSXOatNivr3xZhSoAAzyg1PcEvtZf6tvB0KuFQ+W+6FhunjfSNj5
	 dmkdTFFof5w5PklZ9d2S/pP32loY5K5wJfEGOOcwp/YRcyngSGJezZ1VwSJpBKLnVG
	 eOT6RogktDgQgSD8zHsHE8HA5BeQUpcvXIfgU4snii+IYx7I6R/Q2Kq0hVQ+3rEyeK
	 lr39PQiMSUf7qlieqXMhh6w/aoB0nRw0rbUWNo0a8NhU4oUoHIqXCXkfFdW1LW3YGD
	 48TqiMt+pwYxCEO2m9eDwDlm0PNIokQdOSlciXxbqExFGuRBqkDA1JOhacobICUiPc
	 Bg3ErF6zYKjRg==
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
Subject: [PATCH net-next 04/15] page_pool: Let memory providers take back net_iovs
Date: Tue, 24 Nov 2026 13:56:39 +0100
Message-ID: <20261124125654.183091-4-bjorn@kernel.org>
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

Currently, the only provider hook on the last put of a net_iov is
release_netmem(), which takes it out of its page pool. The AF_XDP
sink, later in this series, gives a chunk back to userspace only once
the device is done with it too, so it must see that last put. With
release_netmem(), the pool would take the chunk in again each time
userspace lends it back.

Let a provider mark a net_iov so that its last put goes to the
provider's hand_off() instead of the page pool cache, still charged to
the pool, for the provider to put back later.

The hand-off also covers the fragment allocator draining a marked
net_iov. Providers that mark net_iovs must implement hand_off(), and
nothing changes for others, as the mark is clear by default. Also give
providers a byte of their own in the net_iov, in the cache line they
touch anyway.

Signed-off-by: Björn Töpel <bjorn@kernel.org>
---
 include/net/netmem.h                    |  8 ++++++++
 include/net/page_pool/memory_provider.h |  6 ++++++
 net/core/page_pool.c                    | 20 +++++++++++++++++++-
 3 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/include/net/netmem.h b/include/net/netmem.h
index 4cf4ee1cd55d..1be7298ac6d9 100644
--- a/include/net/netmem.h
+++ b/include/net/netmem.h
@@ -97,6 +97,12 @@ enum net_iov_type {
 struct net_iov {
 	struct netmem_desc desc;
 	enum net_iov_type type;
+	/* The last put hands it to its memory provider instead of the page
+	 * pool cache, see &memory_provider_ops.hand_off
+	 */
+	bool mp_hand_off;
+	/* Owned by the memory provider */
+	u8 mp_state;
 	struct net_iov_area *owner;
 };
 
@@ -132,6 +138,8 @@ static inline void net_iov_init(struct net_iov *niov,
 {
 	niov->owner = owner;
 	niov->type = type;
+	niov->mp_hand_off = false;
+	niov->mp_state = 0;
 }
 
 /* netmem */
diff --git a/include/net/page_pool/memory_provider.h b/include/net/page_pool/memory_provider.h
index d52c7a450c68..bfc284158222 100644
--- a/include/net/page_pool/memory_provider.h
+++ b/include/net/page_pool/memory_provider.h
@@ -36,6 +36,12 @@ enum mp_flags {
 struct memory_provider_ops {
 	netmem_ref (*alloc_netmems)(struct page_pool *pool, gfp_t gfp);
 	bool (*release_netmem)(struct page_pool *pool, netmem_ref netmem);
+	/* Takes a free net_iov marked mp_hand_off that stays charged to the
+	 * pool; the provider puts it back later. Returns false to have the
+	 * pool recycle it instead. Called where the pool puts netmem, outside
+	 * hard IRQ context. Needed by providers that mark net_iovs.
+	 */
+	bool (*hand_off)(struct page_pool *pool, netmem_ref netmem);
 	int (*init)(struct page_pool *pool);
 	void (*destroy)(struct page_pool *pool);
 	int (*nl_fill)(void *mp_priv, struct sk_buff *rsp,
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 8a1ea21ccdcd..200b0569b9fe 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -840,6 +840,16 @@ static bool __page_pool_page_can_be_recycled(netmem_ref netmem)
 		!page_is_pfmemalloc(netmem_to_page(netmem)));
 }
 
+/* A memory provider takes back a free net_iov it marked, see
+ * &memory_provider_ops.hand_off
+ */
+static bool page_pool_hand_off(struct page_pool *pool, netmem_ref netmem)
+{
+	return netmem_is_net_iov(netmem) &&
+	       unlikely(netmem_to_net_iov(netmem)->mp_hand_off) &&
+	       pool->mp_ops->hand_off(pool, netmem);
+}
+
 /* If the page refcnt == 1, this will try to recycle the page.
  * If pool->dma_sync is set, we'll try to sync the DMA area for
  * the configured size min(dma_sync_size, pool->max_len).
@@ -852,6 +862,10 @@ __page_pool_put_page(struct page_pool *pool, netmem_ref netmem,
 {
 	lockdep_assert_no_hardirq();
 
+	/* The provider takes the net_iovs it marked */
+	if (page_pool_hand_off(pool, netmem))
+		return 0;
+
 	/* This allocator is optimized for the XDP mode that uses
 	 * one-frame-per-page, but have fallbacks that act like the
 	 * regular page allocator APIs.
@@ -1051,6 +1065,9 @@ static netmem_ref page_pool_drain_frag(struct page_pool *pool,
 	if (likely(page_pool_unref_netmem(netmem, drain_count)))
 		return 0;
 
+	if (page_pool_hand_off(pool, netmem))
+		return 0;
+
 	if (__page_pool_page_can_be_recycled(netmem)) {
 		page_pool_dma_sync_for_device(pool, netmem, -1);
 		return netmem;
@@ -1067,7 +1084,8 @@ static void page_pool_free_frag(struct page_pool *pool)
 
 	pool->frag_page = 0;
 
-	if (!netmem || page_pool_unref_netmem(netmem, drain_count))
+	if (!netmem || page_pool_unref_netmem(netmem, drain_count) ||
+	    page_pool_hand_off(pool, netmem))
 		return;
 
 	page_pool_return_netmem(pool, netmem);
-- 
2.56.1

