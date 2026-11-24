Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795525108;
	b=F4uKNJw+UbwdVsSZtWms1Oy3jEIDmuZYFOTuXjabOo96O9bj22A5+nQ2DuhjYeIFTDQX
	 z1RJwOta4M7MSz3O+6Bvx4atF0uaD0TCLlOF0nZh9KwZfXXE9FaGmCiVibbLCas2KVcJN
	 rc/eeH6I9EOpoE+DWyrLwc4yWQ32tI5CRNh7e2xsUKdrFQhBwQKVok3HqDr8sox73r89P
	 ngvSMy99aExi+xCfw0G3Dtpqs7+6WTk0LJDdqTP7p6vKB2Oj1SQ5/5xkH0tgDMahF7bLE
	 2Iabd3DZtvG9LZLd3OPz7Tp8KOaWWO0C06KAK6/4jC0MZG023fP/zUY07GHJN8XaTFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795525108;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=6Gdd21OdIrefrCmmbZ2Abnaxfar/ibXJI1PcKHhAWfA=;
	b=f71rLKVg2TsPb1MMriwaABQvXEFSrgFweX0dqCDNw6VVELNf78r2W0fho2XiO7TSerRh
	 RWZBe6W6M4uY6IHtDCukKSggVjNtYxzVfRwU/ncEeI9cyMwPvZKGXwJMs7BS0r6hQBVkd
	 gG6njDxCwHFVSp0Tat8T40psvCC27rKH68/4v+LSB8lEddhcNdOGBTvWQe07hREgMcp8q
	 gDrnpD0XQ7KDowFGfaVafFCKrnna9tnyQ3oNY7PjXcmmKCirO7nSSbH781yYgUlhd3ANh
	 dfUZnvtyh/UwdLVEbaVwpPNwdoxe93dEIziAI3VtdPBtZJdyaU6QZf44Z/MIiDctLLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oKPoxPtm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C036A606A322;
	Tue, 24 Nov 2026 12:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oKPoxPtm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A49C51F000CF;
	Tue, 24 Nov 2026 12:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795525108;
	bh=6Gdd21OdIrefrCmmbZ2Abnaxfar/ibXJI1PcKHhAWfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oKPoxPtmIsbL5KuuXvx/5Ck/OjVeg4R64Nph2f5OrF5CbDt3Jnku7ciRP+VtlB76D
	 vwGgP/wMnUoZyuP8xTOMCB57PtKUG0LLOp/YGSCZiCRy0T5I5s/XUz4CHh3ETBQkKk
	 N8IzlN3Cd4YLbq4GXBojDCCOE0oV3ZAJvmtBngrTbqJDgj6WEUjzmzTVC+4xC1297n
	 QfnJ4oV/ePEtUBfCKHzP271NpMnXl87tVdNZCKohmFeERcwBJ+lV7uYpXRRCBloH3v
	 f1mPNk8St5JhtRnXOeybcQHsK8Uf29PS5EoLymkl7h8RdEOVMD+cfORxk4i5FOQ+xJ
	 3F202XoMXq4bA==
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
Subject: [PATCH net-next 07/15] xsk: Deliver to the socket in the device's buffer layout
Date: Tue, 24 Nov 2026 13:56:42 +0100
Message-ID: <20261124125654.183091-7-bjorn@kernel.org>
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

Currently, the chunks of a UMEM back the page pools of a queue, but
nothing delivers their buffers to the AF_XDP socket, and a chunk that
the kernel took never goes back.

Deliver redirected sink buffers to the receiving socket of the queue,
the first bound socket with an RX ring, and give each chunk back once
the device and the socket are done with it.

Each buffer of a packet becomes one RX descriptor, at the address that
the device chose, chained with XDP_PKT_CONTD. Metadata that the
program wrote in front of the head is already in place. The socket
drops and counts a packet with a buffer outside its UMEM, with more
than one buffer without XDP_USE_SG, with metadata that does not fit in
front of the head within its chunk, or when the RX ring is full.
Buffers of other memory, and copies, never go to such a socket.

The socket drops the reference of each buffer it takes without an
atomic. Sink buffers go nowhere but the socket of their queue, so only
the queue NAPI changes the count of a chunk in flight, or nothing does
while it is stopped.

A chunk goes back to userspace once nothing in the kernel uses it, if
a buffer of it reached the socket. If the socket's drop frees the
chunk, the descriptor of that buffer carries the new
XDP_RX_CHUNK_FREE. If the device lets go of the chunk later, the page
pool hands it to the provider on its last put, and an empty descriptor
at the chunk gives it back at the next flush of the queue NAPI, or at
a refill while no packets come. Chunks that find the RX ring full stay
on the hand-off list for a later poll, and the refill asks the socket
for a kick while any chunk waits, so that a reader that fell behind
gets them once it has drained its ring. A returned chunk stays charged
to its page pool, which takes it straight into its cache when
userspace lends it again. Chunks whose buffers all stayed in the
kernel, as for dropped packets, stay there.

Only the queue NAPI writes to the RX ring and takes from the hand-off
list. A refill gives chunks back only with BH disabled, which is the
queue NAPI, as drivers refill from process context with BH enabled.
Busy polling runs the same NAPI, and a queue restart stops the old
queue before the new one runs, also in mlx5, whose new channels have
their own NAPIs. So the NAPIs of an old and a new page pool never run
at the same time. Unbind and device unregister take the list only
after the queue stopped.

When the provider goes, page pools put back the chunks they hold for
userspace, so that they can be destroyed. Device unregister and unbind
may both do this, and the second skips what the first put back. None
of this is reachable until the next patch lets sockets bind.

Signed-off-by: Björn Töpel <bjorn@kernel.org>
---
 include/net/xdp_sock.h            |   8 +
 include/uapi/linux/if_xdp.h       |  12 +-
 net/core/filter.c                 |   9 +
 net/xdp/xsk.c                     |  28 ++-
 net/xdp/xsk_sink.c                | 362 +++++++++++++++++++++++++++++-
 net/xdp/xsk_sink.h                |   5 +
 tools/include/uapi/linux/if_xdp.h |  12 +-
 7 files changed, 419 insertions(+), 17 deletions(-)

diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index 6e70b320b399..e81724fd624c 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -126,6 +126,8 @@ struct xsk_tx_metadata_ops {
 int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp);
 int __xsk_map_redirect(struct xdp_sock *xs, struct xdp_buff *xdp);
 void __xsk_map_flush(struct list_head *flush_list);
+int xsk_sink_redirect(struct xdp_buff *xdp, enum bpf_map_type map_type,
+		      void *fwd);
 INDIRECT_CALLABLE_DECLARE(void xsk_destruct_skb(struct sk_buff *));
 
 /**
@@ -182,6 +184,12 @@ static inline int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
 	return -ENOTSUPP;
 }
 
+static inline int xsk_sink_redirect(struct xdp_buff *xdp,
+				    enum bpf_map_type map_type, void *fwd)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline int __xsk_map_redirect(struct xdp_sock *xs, struct xdp_buff *xdp)
 {
 	return -EOPNOTSUPP;
diff --git a/include/uapi/linux/if_xdp.h b/include/uapi/linux/if_xdp.h
index 160a437ed540..933b8700281f 100644
--- a/include/uapi/linux/if_xdp.h
+++ b/include/uapi/linux/if_xdp.h
@@ -47,8 +47,9 @@
 
 /* RX buffers follow the device's layout: a page-sized chunk may hold
  * several of them, a packet may span chunks, and the device picks the
- * offsets. A FILL entry lends a chunk to the kernel. Needs aligned
- * page-sized chunks and no headroom.
+ * offsets. A FILL entry lends a chunk to the kernel, and an RX descriptor
+ * with XDP_RX_CHUNK_FREE gives it back. Needs aligned page-sized chunks and
+ * no headroom.
  */
 #define XDP_UMEM_DRV_LAYOUT		(1 << 4)
 
@@ -189,4 +190,11 @@ struct xdp_desc {
 /* TX packet carries valid metadata. */
 #define XDP_TX_METADATA (1 << 1)
 
+/* Flag on an RX descriptor of an XDP_UMEM_DRV_LAYOUT UMEM: the kernel is done
+ * with the UMEM chunk of the descriptor, and puts nothing more in it. The
+ * chunk is userspace's again. An empty descriptor at the chunk carries only
+ * this flag, when the device let go of the chunk after its last buffer.
+ */
+#define XDP_RX_CHUNK_FREE (1 << 2)
+
 #endif /* _UAPI_LINUX_IF_XDP_H */
diff --git a/net/core/filter.c b/net/core/filter.c
index d5774b2577e7..30b35d00e6b2 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4775,6 +4775,15 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
 	struct bpf_redirect_info *ri = bpf_net_ctx_get_ri();
 	enum bpf_map_type map_type = ri->map_type;
 
+	/* A sink buffer goes to an AF_XDP socket of its queue */
+	if (static_branch_unlikely(&xdp_sink_key) && xdp_buff_is_sink(xdp)) {
+		void *fwd = ri->tgt_value;
+
+		ri->map_id = 0;
+		ri->map_type = BPF_MAP_TYPE_UNSPEC;
+		return xsk_sink_redirect(xdp, map_type, fwd);
+	}
+
 	if (map_type == BPF_MAP_TYPE_XSKMAP)
 		return __xdp_do_redirect_xsk(ri, dev, xdp, xdp_prog);
 
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index f22f9a2cdbbe..0753fac8d4a8 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -35,6 +35,7 @@
 #include "../core/dev.h"
 
 #include "xsk_queue.h"
+#include "xsk_sink.h"
 #include "xdp_umem.h"
 #include "xsk.h"
 
@@ -437,6 +438,12 @@ static bool xsk_dev_queue_valid(const struct xdp_sock *xs,
 	return false;
 }
 
+/* The pool receives in the device's buffer layout, or did */
+static bool xsk_drv_layout(const struct xdp_sock *xs)
+{
+	return xs->pool->umem->flags & XDP_UMEM_DRV_LAYOUT;
+}
+
 static int xsk_rcv_check(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len)
 {
 	if (!xsk_is_bound(xs))
@@ -454,8 +461,14 @@ static int xsk_rcv_check(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len)
 
 static void xsk_flush(struct xdp_sock *xs)
 {
+	struct xsk_sink *sink = xs->pool->sink;
+
+	if (sink)
+		xsk_sink_flush(sink);
 	xskq_prod_submit(xs->rx);
-	__xskq_cons_release(xs->pool->fq);
+	/* A sink releases FILL under its lock, see xsk_sink_take_fill() */
+	if (!sink)
+		__xskq_cons_release(xs->pool->fq);
 	sock_def_readable(&xs->sk);
 }
 
@@ -465,6 +478,11 @@ int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
 	int err;
 
 	err = xsk_rcv_check(xs, xdp, len);
+	/* A sink socket takes buffers of its provider only */
+	if (!err && xsk_drv_layout(xs)) {
+		xs->rx_dropped++;
+		err = -EOPNOTSUPP;
+	}
 	if (!err) {
 		spin_lock_bh(&xs->pool->rx_lock);
 		err = __xsk_rcv(xs, xdp, len);
@@ -489,6 +507,14 @@ static int xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
 		return xsk_rcv_zc(xs, xdp, len);
 	}
 
+	/* Sink buffers take xsk_sink_redirect(); others cannot go to a sink
+	 * socket
+	 */
+	if (xsk_drv_layout(xs)) {
+		xs->rx_dropped++;
+		return -EOPNOTSUPP;
+	}
+
 	err = __xsk_rcv(xs, xdp, len);
 	if (!err)
 		xdp_return_buff(xdp);
diff --git a/net/xdp/xsk_sink.c b/net/xdp/xsk_sink.c
index b78116f25e71..9f1f7cf82266 100644
--- a/net/xdp/xsk_sink.c
+++ b/net/xdp/xsk_sink.c
@@ -4,13 +4,29 @@
  * Userspace lends page-sized UMEM chunks through the FILL ring. Each chunk
  * becomes a net_iov of a page pool memory provider, and the device splits it
  * as it splits pages: a chunk may hold several RX buffers, and a packet may
- * span chunks.
+ * span chunks. Each buffer of a packet that XDP redirects to the socket
+ * becomes one RX descriptor, at the address the device chose.
+ *
+ * The socket drops the page pool reference of each buffer it takes. A chunk
+ * goes back to userspace once nothing in the kernel uses it, if a buffer of
+ * it reached the socket: the descriptor of the buffer that freed it carries
+ * XDP_RX_CHUNK_FREE, or, when the device lets go of the chunk later, an
+ * empty descriptor at the chunk does:
+ *
+ *   FILL 0x7000
+ *   RX {0x7100, A}
+ *   RX {0x7900, B, XDP_RX_CHUNK_FREE}  or  RX {0x7000, 0, XDP_RX_CHUNK_FREE}
+ *
+ * Such a chunk stays charged to its page pool, which takes it straight back
+ * when userspace lends it again. Chunks whose buffers all stayed in the
+ * kernel, as for dropped packets, stay in the kernel.
  *
  * The kernel maps the chunks through the UMEM mapping, so XDP programs read
- * and write the packets in place. The kernel stores none of its own data in
- * the chunks: the shared info of a packet lives in the sink, see
- * %XDP_FLAGS_SINFO_EXT, and the core turns every verdict that would build an
- * skb or a frame in the buffers into a drop.
+ * and write the packets in place, and their metadata lands in front of the
+ * first buffer. The kernel stores none of its own data in the chunks: the
+ * shared info of a packet lives in the sink, see %XDP_FLAGS_SINFO_EXT, and
+ * the core turns every verdict that would build an skb or a frame in the
+ * buffers into a drop.
  */
 
 #include <linux/nospec.h>
@@ -49,11 +65,15 @@ struct xsk_sink {
 	spinlock_t lock;
 	struct xsk_queue *fq;
 	refcount_t refs;
-	/* One node per chunk: chunks that page pools released, from any
-	 * context
+	/* The socket that receives, set once */
+	struct xdp_sock *xs;
+	/* One node per chunk, on at most one list. Page pools add chunks
+	 * that they released, and chunks that they handed off to go back to
+	 * userspace, from any context.
 	 */
 	struct llist_node *nodes;
 	struct llist_head released;
+	struct llist_head handed;
 };
 
 static void xsk_sink_free(struct xsk_sink *sink)
@@ -172,12 +192,78 @@ static u32 xsk_sink_take_released(struct xsk_sink *sink, struct page_pool *pp,
 	return n;
 }
 
+/* Posts the chunks that page pools handed off as empty RX descriptors
+ * while the ring has room, and puts the rest back on the list. Their order
+ * does not matter, as userspace tells chunks by their address. Only one
+ * NAPI runs a queue at a time, so this is the only consumer of the list
+ * while the queue runs, and xsk_sink_scrub() the only one after it stopped.
+ *
+ * Context: the queue NAPI
+ */
+static void xsk_sink_give_back(struct xsk_sink *sink, struct xdp_sock *xs)
+{
+	struct llist_node *node, *last;
+	u32 idx;
+
+	if (llist_empty(&sink->handed) || !xskq_prod_nb_free(xs->rx, 1))
+		return;
+
+	node = llist_del_all(&sink->handed);
+	while (node && xskq_prod_nb_free(xs->rx, 1)) {
+		idx = node - sink->nodes;
+		node = node->next;
+		WRITE_ONCE(sink->area.niovs[idx].mp_state, XSK_SINK_USER);
+		__xskq_prod_reserve_desc(xs->rx, (u64)idx << PAGE_SHIFT, 0,
+					 XDP_RX_CHUNK_FREE);
+	}
+	if (!node)
+		return;
+
+	/* The ring is full, so userspace is behind */
+	for (last = node; last->next; last = last->next)
+		;
+	llist_add_batch(node, last, &sink->handed);
+}
+
+/* Drops the reference of the buffer of @niov that the socket took at the
+ * last RX descriptor. Only the queue NAPI changes the count of a chunk that
+ * delivers to the socket, so this needs no atomic.
+ */
+static void xsk_sink_drop_buf(struct xsk_sink *sink, struct xdp_sock *xs,
+			      struct net_iov *niov)
+{
+	struct xdp_rxtx_ring *ring;
+	atomic_long_t *count;
+	long left;
+
+	count = netmem_get_pp_ref_count_ref(net_iov_to_netmem(niov));
+	left = atomic_long_read(count) - 1;
+	if (left > 0) {
+		/* The device still uses it: its last put hands it off */
+		atomic_long_set(count, left);
+		niov->mp_hand_off = true;
+		return;
+	}
+
+	/* Free: back to userspace with this descriptor, still charged to its
+	 * page pool with the count of a free netmem
+	 */
+	WARN_ON_ONCE(left < 0);
+	atomic_long_set(count, 1);
+	niov->mp_hand_off = false;
+	WRITE_ONCE(niov->mp_state, XSK_SINK_USER);
+	ring = (struct xdp_rxtx_ring *)xs->rx->ring;
+	ring->desc[(xs->rx->cached_prod - 1) & xs->rx->ring_mask].options |=
+		XDP_RX_CHUNK_FREE;
+}
+
 static netmem_ref xsk_sink_alloc_netmems(struct page_pool *pp, gfp_t gfp)
 {
 	struct xsk_sink *sink = pp->mp_priv;
 	/* The NAPI owns the need_wakeup flags */
 	bool napi = in_softirq() && !in_hardirq();
 	struct xsk_queue *fq;
+	struct xdp_sock *xs;
 	dma_addr_t dma;
 	u32 i, n;
 
@@ -185,17 +271,34 @@ static netmem_ref xsk_sink_alloc_netmems(struct page_pool *pp, gfp_t gfp)
 	if (WARN_ON_ONCE(pp->alloc.count))
 		return 0;
 
+	/* Userspace may wait for chunks the device let go of after the last
+	 * flush, and with no packets coming, no flush gives them back. A
+	 * refill with BH disabled is the queue NAPI, as process context
+	 * refills with BH enabled. Only one NAPI runs a queue at a time, as
+	 * a queue restart stops the old queue before the new one runs, so
+	 * the refill may produce to the RX ring.
+	 */
+	/* Pairs with xsk_sink_add_sock() */
+	xs = smp_load_acquire(&sink->xs);
+	if (xs && napi && !llist_empty(&sink->handed)) {
+		xsk_sink_give_back(sink, xs);
+		xskq_prod_submit(xs->rx);
+		xs->sk.sk_data_ready(&xs->sk);
+	}
+
 	spin_lock_bh(&sink->lock);
 	n = xsk_sink_take_fill(sink, pp);
 	n = xsk_sink_take_released(sink, pp, n);
 	fq = sink->fq;
-	/* Ask for kicks only while FILL runs dry, as zero copy drivers do: a
-	 * kick schedules the NAPI, which a busy poller would rather run
-	 * itself. Process context refills new queues only and leaves the
-	 * flags to their NAPI and to bind.
+	/* Ask for kicks while FILL runs dry, as zero copy drivers do, and
+	 * while chunks wait for room in the RX ring. A kick schedules the
+	 * NAPI, which a busy poller would rather run itself, but once a
+	 * slow socket has drained its ring, only a NAPI run posts the
+	 * chunks that waited. Process context refills new queues only and
+	 * leaves the flags to their NAPI and to bind.
 	 */
 	if (napi && fq && sink->pool->uses_need_wakeup) {
-		if (n)
+		if (n && llist_empty(&sink->handed))
 			xsk_clear_rx_need_wakeup(sink->pool);
 		else
 			xsk_set_rx_need_wakeup(sink->pool);
@@ -226,12 +329,61 @@ static bool xsk_sink_release_netmem(struct page_pool *pp, netmem_ref netmem)
 	return false;
 }
 
+/* The last put of a chunk with a buffer in userspace: it goes back to
+ * userspace, still charged to @pp. The next flush or refill of the queue
+ * NAPI posts its empty descriptor.
+ */
+static bool xsk_sink_hand_off(struct page_pool *pp, netmem_ref netmem)
+{
+	struct net_iov *niov = netmem_to_net_iov(netmem);
+	struct xsk_sink *sink = pp->mp_priv;
+	struct llist_node *node;
+
+	niov->mp_hand_off = false;
+	node = &sink->nodes[net_iov_idx(niov)];
+	llist_add(node, &sink->handed);
+	return true;
+}
+
 static int xsk_sink_nl_fill(void *mp_priv, struct sk_buff *rsp,
 			    struct netdev_rx_queue *rxq)
 {
 	return 0;
 }
 
+/* Page pools hold the chunks that went back to userspace until it lends
+ * them again. Put them back, so that the page pools can finish their
+ * destruction, and handed-off chunks that never made it to userspace too.
+ * The queue stopped, so no NAPI takes from the handed list any longer.
+ * Device unregister scrubs twice, when it uninstalls the provider and
+ * when the socket unbinds.
+ */
+static void xsk_sink_scrub(struct xsk_sink *sink)
+{
+	struct llist_node *node;
+	struct net_iov *niov;
+	netmem_ref netmem;
+	u32 idx;
+
+	for (node = llist_del_all(&sink->handed); node; node = node->next)
+		sink->area.niovs[node - sink->nodes].mp_state = XSK_SINK_USER;
+
+	for (idx = 0; idx < sink->area.num_niovs; idx++) {
+		niov = &sink->area.niovs[idx];
+		netmem = net_iov_to_netmem(niov);
+		if (niov->mp_state == XSK_SINK_LENT || !netmem_get_pp(netmem))
+			continue;
+
+		niov->mp_hand_off = false;
+		/* A later scrub must skip it: its page pool may not have
+		 * released it yet
+		 */
+		niov->mp_state = XSK_SINK_LENT;
+		page_pool_put_unrefed_netmem(netmem_get_pp(netmem), netmem,
+					     -1, false);
+	}
+}
+
 /* No queue DMAs to the UMEM any longer */
 static void xsk_sink_stop(struct xsk_sink *sink)
 {
@@ -245,6 +397,7 @@ static void xsk_sink_stop(struct xsk_sink *sink)
 
 	/* Wait for wakeups that found the sink or the queue */
 	synchronize_net();
+	xsk_sink_scrub(sink);
 	if (unmap)
 		xp_dma_unmap(sink->pool, XSK_SINK_DMA_ATTR);
 }
@@ -259,6 +412,7 @@ static void xsk_sink_uninstall(void *mp_priv, struct netdev_rx_queue *rxq)
 static const struct memory_provider_ops xsk_sink_ops = {
 	.alloc_netmems	= xsk_sink_alloc_netmems,
 	.release_netmem	= xsk_sink_release_netmem,
+	.hand_off	= xsk_sink_hand_off,
 	.init		= xsk_sink_init,
 	.destroy	= xsk_sink_destroy,
 	.nl_fill	= xsk_sink_nl_fill,
@@ -298,6 +452,7 @@ static struct xsk_sink *xsk_sink_create(struct xsk_buff_pool *pool,
 	sink->fq = pool->fq;
 	spin_lock_init(&sink->lock);
 	init_llist_head(&sink->released);
+	init_llist_head(&sink->handed);
 	refcount_set(&sink->refs, 1);
 
 	/* Chunks are pages, see XDP_UMEM_DRV_LAYOUT */
@@ -397,6 +552,27 @@ int xsk_sink_bind(struct xsk_buff_pool *pool, struct net_device *dev,
 	return 0;
 }
 
+/* The first socket with an RX ring receives; others sharing the pool,
+ * such as TX-only sockets, do not.
+ *
+ * Context: RTNL and the instance lock of the device
+ */
+void xsk_sink_add_sock(struct xsk_sink *sink, struct xdp_sock *xs)
+{
+	if (xs->rx && !sink->xs) {
+		/* The NAPI acquires the socket once it is set up */
+		smp_store_release(&sink->xs, xs);
+	}
+}
+
+/* The receiving socket, if any.
+ * Context: RTNL and the instance lock of the device
+ */
+struct xdp_sock *xsk_sink_sock(struct xsk_sink *sink)
+{
+	return sink->xs;
+}
+
 /* Context: RTNL and the instance lock of the device */
 void xsk_sink_unbind(struct xsk_buff_pool *pool)
 {
@@ -414,3 +590,165 @@ void xsk_sink_unbind(struct xsk_buff_pool *pool)
 		netif_close(pool->netdev);
 	xsk_sink_detach(pool);
 }
+
+/* The net_iov of @netmem if it is one of ours; tells by its address */
+static __always_inline struct net_iov *xsk_sink_niov(struct xsk_sink *sink,
+						     netmem_ref netmem)
+{
+	struct net_iov *niov;
+
+	if (!netmem_is_net_iov(netmem))
+		return NULL;
+	niov = netmem_to_net_iov(netmem);
+	if ((unsigned long)(niov - sink->area.niovs) >= sink->area.num_niovs)
+		return NULL;
+	return niov;
+}
+
+/* Puts the buffers of a packet on the RX ring, one descriptor each, with
+ * the metadata of the program in front of the first. Returns 0 if the socket
+ * took them.
+ */
+static int xsk_sink_rcv(struct xsk_sink *sink, struct xdp_sock *xs,
+			struct xdp_buff *xdp)
+{
+	struct net_iov *niov, *hniov = NULL, *empty = NULL;
+	u32 i, n, len, hlen, nr_frags = 0, headroom;
+	struct skb_shared_info *sinfo;
+	const skb_frag_t *frag;
+	u64 addr, off;
+	u32 metalen = 0;
+	netmem_ref netmem;
+
+	sinfo = xdp_get_shared_info_from_buff(xdp);
+	if (xdp_buff_has_frags(xdp))
+		nr_frags = sinfo->nr_frags;
+
+	/* The head sits in the UMEM mapping */
+	off = (u8 *)xdp->data - (u8 *)sink->area.xdp_vaddr;
+	if (off >= (u64)sink->area.num_niovs << PAGE_SHIFT)
+		goto drop;
+	niov = &sink->area.niovs[off >> PAGE_SHIFT];
+	hlen = xdp->data_end - xdp->data;
+	if (!hlen) {
+		/* An empty linear part, as mlx5 builds for nonlinear RQs */
+		empty = niov;
+		headroom = 0;
+	} else {
+		if ((off & ~PAGE_MASK) + hlen > PAGE_SIZE)
+			goto drop;
+		hniov = niov;
+		headroom = min_t(u64, off & ~PAGE_MASK,
+				 xdp->data - xdp->data_hard_start);
+	}
+
+	for (i = 0; i < nr_frags; i++)
+		if (!xsk_sink_niov(sink, skb_frag_netmem(&sinfo->frags[i])))
+			goto drop;
+
+	n = nr_frags + !!hlen;
+	if (!n || (n > 1 && !xs->sg))
+		goto drop;
+
+	/* The program put metadata in front of the head, which must be the
+	 * first buffer, within its chunk
+	 */
+	if (!xdp_data_meta_unsupported(xdp))
+		metalen = xdp->data - xdp->data_meta;
+	if (metalen > headroom)
+		goto drop;
+
+	if (xskq_prod_nb_free(xs->rx, n) < n) {
+		xs->rx_queue_full++;
+		return -ENOBUFS;
+	}
+
+	for (i = 0; i < n; i++) {
+		if (hlen && !i) {
+			niov = hniov;
+			addr = off;
+			len = hlen;
+		} else {
+			frag = &sinfo->frags[i - !!hlen];
+			niov = netmem_to_net_iov(skb_frag_netmem(frag));
+			addr = ((u64)(niov - sink->area.niovs) << PAGE_SHIFT) +
+			       skb_frag_off(frag);
+			len = skb_frag_size(frag);
+		}
+		__xskq_prod_reserve_desc(xs->rx, addr, len,
+					 i + 1 < n ? XDP_PKT_CONTD : 0);
+		xsk_sink_drop_buf(sink, xs, niov);
+	}
+
+	if (empty) {
+		netmem = net_iov_to_netmem(empty);
+		page_pool_put_netmem(netmem_get_pp(netmem), netmem, -1, false);
+	}
+	return 0;
+
+drop:
+	xs->rx_dropped++;
+	return -EINVAL;
+}
+
+/**
+ * xsk_sink_flush - give back chunks at the end of a NAPI poll
+ * @sink: provider of a socket that received in this poll
+ *
+ * Context: the queue NAPI, from xdp_do_flush(), before the RX ring is
+ * submitted.
+ */
+void xsk_sink_flush(struct xsk_sink *sink)
+{
+	/* Pairs with xsk_sink_add_sock() */
+	struct xdp_sock *xs = smp_load_acquire(&sink->xs);
+
+	if (!xs)
+		return;
+
+	xsk_sink_give_back(sink, xs);
+}
+
+/**
+ * xsk_sink_redirect - deliver a sink buffer to a socket of its queue
+ * @xdp: sink buffer, see xdp_buff_is_sink()
+ * @map_type: map of the redirect
+ * @fwd: target of the redirect
+ *
+ * The target must be the receiving socket of the queue in an XSKMAP. Other
+ * maps cannot take sink buffers.
+ *
+ * Context: the queue NAPI, from xdp_do_redirect().
+ * Return: 0 if the socket took the buffer.
+ */
+int xsk_sink_redirect(struct xdp_buff *xdp, enum bpf_map_type map_type,
+		      void *fwd)
+{
+	struct net_iov_area *area = xdp->rxq->sink_area;
+	struct xsk_sink *sink;
+	struct xdp_sock *xs;
+	int err;
+
+	/* Set for every queue with a sink provider, see
+	 * PP_FLAG_ALLOW_XDP_ONLY_NETMEM
+	 */
+	if (unlikely(!area))
+		return -EINVAL;
+	sink = container_of(area, struct xsk_sink, area);
+
+	if (map_type != BPF_MAP_TYPE_XSKMAP)
+		return -EOPNOTSUPP;
+
+	/* Pairs with xsk_sink_add_sock() */
+	xs = smp_load_acquire(&sink->xs);
+	if (unlikely(!xs || xs != fwd))
+		return -EINVAL;
+
+	err = xsk_sink_rcv(sink, xs, xdp);
+	if (err)
+		return err;
+
+	if (!xs->flush_node.prev)
+		list_add(&xs->flush_node, bpf_net_ctx_get_xskmap_flush_list());
+	return 0;
+}
diff --git a/net/xdp/xsk_sink.h b/net/xdp/xsk_sink.h
index 3f201163c530..fe73b2916608 100644
--- a/net/xdp/xsk_sink.h
+++ b/net/xdp/xsk_sink.h
@@ -5,10 +5,15 @@
 #define XSK_SINK_H_
 
 struct net_device;
+struct xdp_sock;
 struct xsk_buff_pool;
+struct xsk_sink;
 
 int xsk_sink_bind(struct xsk_buff_pool *pool, struct net_device *dev,
 		  u16 queue_id, u16 flags);
 void xsk_sink_unbind(struct xsk_buff_pool *pool);
+void xsk_sink_flush(struct xsk_sink *sink);
+void xsk_sink_add_sock(struct xsk_sink *sink, struct xdp_sock *xs);
+struct xdp_sock *xsk_sink_sock(struct xsk_sink *sink);
 
 #endif /* XSK_SINK_H_ */
diff --git a/tools/include/uapi/linux/if_xdp.h b/tools/include/uapi/linux/if_xdp.h
index 160a437ed540..933b8700281f 100644
--- a/tools/include/uapi/linux/if_xdp.h
+++ b/tools/include/uapi/linux/if_xdp.h
@@ -47,8 +47,9 @@
 
 /* RX buffers follow the device's layout: a page-sized chunk may hold
  * several of them, a packet may span chunks, and the device picks the
- * offsets. A FILL entry lends a chunk to the kernel. Needs aligned
- * page-sized chunks and no headroom.
+ * offsets. A FILL entry lends a chunk to the kernel, and an RX descriptor
+ * with XDP_RX_CHUNK_FREE gives it back. Needs aligned page-sized chunks and
+ * no headroom.
  */
 #define XDP_UMEM_DRV_LAYOUT		(1 << 4)
 
@@ -189,4 +190,11 @@ struct xdp_desc {
 /* TX packet carries valid metadata. */
 #define XDP_TX_METADATA (1 << 1)
 
+/* Flag on an RX descriptor of an XDP_UMEM_DRV_LAYOUT UMEM: the kernel is done
+ * with the UMEM chunk of the descriptor, and puts nothing more in it. The
+ * chunk is userspace's again. An empty descriptor at the chunk carries only
+ * this flag, when the device let go of the chunk after its last buffer.
+ */
+#define XDP_RX_CHUNK_FREE (1 << 2)
+
 #endif /* _UAPI_LINUX_IF_XDP_H */
-- 
2.56.1

