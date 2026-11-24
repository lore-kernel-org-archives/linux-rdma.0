Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795525096;
	b=Bcog0B/3nBISj8o/5OzeGCF4JRr4V3/znw8Fc/2k3S3iYHs6XhTVfv+zrIujOXfr4dtm
	 k/mptzlHKoNOF8MXbd583YdN62+AZBgDHownqHhk2+1tDjmyNlhqhRz1e/zUL7BWzFyCK
	 FWYiDDrsbyh7YigHOMOXzMipoCI5hqD1o2/rvy/gcZNVK52JqLr7OIWqh6P9CmyKyMcXl
	 h012xM+VpTMIMzzy8jI3UdBpQ+jvtgVFxWMxLktu51PxWtLXBnGZj69CVXniQ/5sWT5R5
	 SGokvUFKxRclFC43+1sN01YA8BCnCFu40ciVpaq7juRbOqj6lrszIL4I8OhZNg3Pv5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795525096;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=XQq5tLPOmPVafd3xu2rMpJx4/ZuIBpKF/py13mFzisA=;
	b=SE2LBRb7GKTdTvB2ErN9lOa5RnUFftZpgCP9Qj2FhmC/3ORw21EMSLcCahNImwA5LLJV
	 rwJe+kNjTAhgFZlJeHPgFGeUCvyCiwnTDAyX71fMxm7u829m+Y7wboy4W6pXhia5+203O
	 n2qD+oRiPQoXJQdOfizXzWAztXGNgSGdaR3SzNeY6InOvc2JfI70BCS1M9m2QrPp+N/Xn
	 58aLVG5+NiXNC6/JxKjW7i6gSiv7tKbYT7yTXenIfTS/I3EkUmmNZgzg9JgDX9n+BTYxZ
	 radkkNJkwTYRuPCZJ2dfiRhb0Mg8n2UgyWvh/CAJukW+9UQtvjpv8VH0YsaME1b/a2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SJycLsmn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797BA606A31E;
	Tue, 24 Nov 2026 12:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SJycLsmn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E52A1F01562;
	Tue, 24 Nov 2026 12:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795525095;
	bh=XQq5tLPOmPVafd3xu2rMpJx4/ZuIBpKF/py13mFzisA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SJycLsmngMgiiWt98LSbIVCX16Igdmy5KQFrGfaQw4pMtc5kVHrCW8VhZnM6Ig5B4
	 fKDk3yxc9eonwRih82O5qP1N4wfQchsab9my3Ef64l44WHSL/qsrgr2B5+/lBULyfw
	 2PjQGZfZ1rMZISwyDLcx7I1IgNm+a5Fbs7A2FIto98F0YhS1qLQmRPUfNJ97Vy7o3l
	 gp1GCI3cBXxq2aHsquITVRL4Flc+v8+0qq+xptwYUiVfzmgnXUbQRlINei10QnjwYn
	 QaUztE8aQrjowCev7sXEOmKQNRjEc9iZi82nHHho/cQqPUzBPtvZnB29rlhQsFONmP
	 PrHLM/AOto0hg==
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
Subject: [PATCH net-next 06/15] xsk: Lend UMEM chunks to the page pools of a queue
Date: Tue, 24 Nov 2026 13:56:41 +0100
Message-ID: <20261124125654.183091-6-bjorn@kernel.org>
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

Currently, AF_XDP zero copy makes the device fill one UMEM chunk per
buffer, at the UMEM headroom. Drivers bend their RX geometry to that
and carry a second RX path for it, and packets that the stack would
build from several buffers, or pack into one page, cannot be received
without a copy.

Let the device lay out buffers in UMEM chunks as it does in pages, for
a UMEM registered with the new flag XDP_UMEM_DRV_LAYOUT. First, let
the chunks of such a UMEM back the RX page pools of the bound queue,
through a sink memory provider that the socket installs with the queue
management API, so drivers need no AF_XDP code.

The chunk is the unit of ownership. A FILL entry lends a chunk to the
kernel until the kernel gives it back, see the next patch. A chunk
that is lent twice, or lies outside the UMEM, counts as an invalid
FILL entry, so userspace cannot make the device use a chunk twice. A
refill takes at most a page pool cache worth of FILL entries, bounding
the NAPI work. Chunks that a page pool released when it went away, as
at a queue restart, stay on a list that refills take from only when
FILL gives too few, so every chunk taken from it stays in circulation.
The pool allocates no xdp_buff_xsk per chunk, which saves 128 bytes
per 4 KiB chunk. The kernel mapping of the UMEM is the XDP view of its
net_iovs, so XDP reads the chunks in place.

The provider refuses page pools with pages larger than a chunk, with
another DMA device, or so large that the device could hold every
chunk. Binding needs a native XDP program, which cannot be detached
while the provider is installed, as drivers would otherwise build skbs
around the buffers. Unbind restarts the queue without the provider, or
closes the device if that fails, as the old queue may go on receiving
into the UMEM. Device unregister may uninstall the provider before the
socket unbinds, and unbind then only frees what is left.

Bind sets the RX need_wakeup flag before the queue starts, as the
queue may need FILL entries to start. After that only the queue NAPI
changes the flag, asking for a kick only while FILL is empty.
Process-context refills, as when bnxt fills a new queue, leave it
alone.

DMA syncs work as with page pools. The UMEM is mapped once, at bind,
the provider syncs a chunk for the device when it lends it, page pools
sync the chunks they recycle, and drivers sync each buffer for the CPU
before XDP runs.

None of this is reachable until UMEM registration accepts
XDP_UMEM_DRV_LAYOUT, two patches later.

Signed-off-by: Björn Töpel <bjorn@kernel.org>
---
 include/linux/netdevice.h         |   2 +
 include/net/xsk_buff_pool.h       |   3 +
 include/uapi/linux/if_xdp.h       |   7 +
 net/core/dev.c                    |  30 +++
 net/xdp/Kconfig                   |   1 +
 net/xdp/Makefile                  |   2 +-
 net/xdp/xsk_buff_pool.c           |  30 ++-
 net/xdp/xsk_sink.c                | 416 ++++++++++++++++++++++++++++++
 net/xdp/xsk_sink.h                |  14 +
 tools/include/uapi/linux/if_xdp.h |   7 +
 10 files changed, 505 insertions(+), 7 deletions(-)
 create mode 100644 net/xdp/xsk_sink.c
 create mode 100644 net/xdp/xsk_sink.h

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 5fd2bec1178a..5a7247873ce8 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4459,6 +4459,8 @@ u32 dev_xdp_prog_id(struct net_device *dev, enum bpf_xdp_mode mode);
 
 u32 dev_get_min_mp_channel_count(const struct net_device *dev);
 bool dev_mp_blocks_xdp(const struct net_device *dev);
+bool dev_has_xdp_only_mp(const struct net_device *dev);
+bool dev_xdp_drv_prog_held(struct net_device *dev);
 
 int __dev_forward_skb(struct net_device *dev, struct sk_buff *skb);
 int dev_forward_skb(struct net_device *dev, struct sk_buff *skb);
diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index 02e89350faf9..376408994a33 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -11,6 +11,7 @@
 #include <net/xdp.h>
 
 struct xsk_buff_pool;
+struct xsk_sink;
 struct xdp_rxq_info;
 struct xsk_cb_desc;
 struct xsk_queue;
@@ -54,6 +55,8 @@ struct xsk_buff_pool {
 	spinlock_t xsk_tx_list_lock;
 	refcount_t users;
 	struct xdp_umem *umem;
+	/* RX in the device's buffer layout, see net/xdp/xsk_sink.c */
+	struct xsk_sink *sink;
 	struct work_struct work;
 	/* Protects generic receive in shared and non-shared umem mode. */
 	spinlock_t rx_lock;
diff --git a/include/uapi/linux/if_xdp.h b/include/uapi/linux/if_xdp.h
index 50d67df78911..160a437ed540 100644
--- a/include/uapi/linux/if_xdp.h
+++ b/include/uapi/linux/if_xdp.h
@@ -45,6 +45,13 @@
  */
 #define XDP_UMEM_TX_METADATA_LEN	(1 << 2)
 
+/* RX buffers follow the device's layout: a page-sized chunk may hold
+ * several of them, a packet may span chunks, and the device picks the
+ * offsets. A FILL entry lends a chunk to the kernel. Needs aligned
+ * page-sized chunks and no headroom.
+ */
+#define XDP_UMEM_DRV_LAYOUT		(1 << 4)
+
 struct sockaddr_xdp {
 	__u16 sxdp_family;
 	__u16 sxdp_flags;
diff --git a/net/core/dev.c b/net/core/dev.c
index 8a1d5a284e53..3bc20c7e409f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10860,6 +10860,11 @@ static int dev_xdp_attach(struct net_device *dev, struct netlink_ext_ack *extack
 		NL_SET_ERR_MSG(extack, "Active program does not match expected");
 		return -EEXIST;
 	}
+	if (cur_prog && !new_prog && !link && mode == XDP_MODE_DRV &&
+	    dev_has_xdp_only_mp(dev)) {
+		NL_SET_ERR_MSG(extack, "An XDP-only memory provider needs the program");
+		return -EBUSY;
+	}
 
 	/* put effective new program into new_prog */
 	if (link)
@@ -11163,6 +11168,31 @@ bool dev_mp_blocks_xdp(const struct net_device *dev)
 	return false;
 }
 
+/* A native program is attached, and dev_xdp_attach() keeps it while an
+ * AF_XDP socket receives in the buffer layout of @dev. A BPF link could go
+ * without asking, and so could a program that an upper device propagated.
+ */
+bool dev_xdp_drv_prog_held(struct net_device *dev)
+{
+	return dev_xdp_prog_id(dev, XDP_MODE_DRV) &&
+	       !dev_xdp_link(dev, XDP_MODE_DRV) && !dev->xdp_from_upper;
+}
+
+/* A queue of @dev has an XDP-only memory provider */
+bool dev_has_xdp_only_mp(const struct net_device *dev)
+{
+	const struct memory_provider_ops *ops;
+	unsigned int i;
+
+	for (i = 0; i < dev->real_num_rx_queues; i++) {
+		ops = dev->_rx[i].mp_params.mp_ops;
+		if (ops && ops->flags & MP_XDP_ONLY)
+			return true;
+	}
+
+	return false;
+}
+
 u32 dev_get_min_mp_channel_count(const struct net_device *dev)
 {
 	int i;
diff --git a/net/xdp/Kconfig b/net/xdp/Kconfig
index 71af2febe72a..c9c68d3b3712 100644
--- a/net/xdp/Kconfig
+++ b/net/xdp/Kconfig
@@ -2,6 +2,7 @@
 config XDP_SOCKETS
 	bool "XDP sockets"
 	depends on BPF_SYSCALL
+	select PAGE_POOL
 	default n
 	help
 	  XDP sockets allows a channel between XDP programs and
diff --git a/net/xdp/Makefile b/net/xdp/Makefile
index 30cdc4315f42..73a638f12843 100644
--- a/net/xdp/Makefile
+++ b/net/xdp/Makefile
@@ -1,4 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-$(CONFIG_XDP_SOCKETS) += xsk.o xdp_umem.o xsk_queue.o xskmap.o
-obj-$(CONFIG_XDP_SOCKETS) += xsk_buff_pool.o
+obj-$(CONFIG_XDP_SOCKETS) += xsk_buff_pool.o xsk_sink.o
 obj-$(CONFIG_XDP_SOCKETS_DIAG) += xsk_diag.o
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 5ec092f7cb6f..7ece7d9e3937 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -7,6 +7,7 @@
 #include <net/xdp_sock_drv.h>
 
 #include "xsk_queue.h"
+#include "xsk_sink.h"
 #include "xdp_umem.h"
 #include "xsk.h"
 
@@ -69,9 +70,14 @@ struct xsk_buff_pool *xp_create_and_assign_umem(struct xdp_sock *xs,
 	if (!pool)
 		goto out;
 
-	pool->heads = kvzalloc_objs(*pool->heads, umem->chunks);
-	if (!pool->heads)
-		goto out;
+	/* Receiving in the device's buffer layout and copy TX take none */
+	if (!(umem->flags & XDP_UMEM_DRV_LAYOUT)) {
+		pool->heads = kvzalloc_objs(*pool->heads, umem->chunks);
+		if (!pool->heads)
+			goto out;
+		pool->heads_cnt = umem->chunks;
+		pool->free_heads_cnt = umem->chunks;
+	}
 
 	if (xs->tx)
 		if (xp_alloc_tx_descs(pool, xs, max_segs))
@@ -79,8 +85,6 @@ struct xsk_buff_pool *xp_create_and_assign_umem(struct xdp_sock *xs,
 
 	pool->chunk_mask = ~((u64)umem->chunk_size - 1);
 	pool->addrs_cnt = umem->size;
-	pool->heads_cnt = umem->chunks;
-	pool->free_heads_cnt = umem->chunks;
 	pool->headroom = umem->headroom;
 	pool->chunk_size = umem->chunk_size;
 	pool->chunk_shift = ffs(umem->chunk_size) - 1;
@@ -211,6 +215,13 @@ int xp_assign_dev(struct xsk_buff_pool *pool,
 	 */
 	hlist_add_head(&pool->dev_node, &netdev->xsk_pools);
 
+	if (pool->umem->flags & XDP_UMEM_DRV_LAYOUT) {
+		err = xsk_sink_bind(pool, netdev, queue_id, flags);
+		if (err)
+			goto err_unbind;
+		return 0;
+	}
+
 	if (force_copy)
 		/* For copy-mode, we are done. */
 		return 0;
@@ -268,6 +279,7 @@ int xp_assign_dev(struct xsk_buff_pool *pool,
 err_unreg_pool:
 	if (!force_zc)
 		err = 0; /* fallback to copy mode */
+err_unbind:
 	if (err) {
 		pool->umem->flags = umem_flags;
 		xsk_clear_pool_at_qid(netdev, queue_id);
@@ -285,6 +297,9 @@ int xp_assign_dev_shared(struct xsk_buff_pool *pool, struct xdp_sock *umem_xs,
 	struct xdp_umem *umem = umem_xs->umem;
 
 	flags = umem->zc ? XDP_ZEROCOPY : XDP_COPY;
+	/* The device layout has no copy mode */
+	if (umem->flags & XDP_UMEM_DRV_LAYOUT)
+		flags = 0;
 
 	if (umem->flags & XDP_UMEM_SG_FLAG)
 		flags |= XDP_USE_SG;
@@ -300,7 +315,10 @@ static void __xp_clear_dev(struct xsk_buff_pool *pool)
 	struct net_device *netdev = pool->netdev;
 
 	netdev_assert_locked_ops_compat(netdev);
-	xp_disable_drv_zc(pool);
+	if (pool->sink)
+		xsk_sink_unbind(pool);
+	else
+		xp_disable_drv_zc(pool);
 	xsk_clear_pool_at_qid(netdev, pool->queue_id);
 	hlist_del(&pool->dev_node);
 	pool->netdev = NULL;
diff --git a/net/xdp/xsk_sink.c b/net/xdp/xsk_sink.c
new file mode 100644
index 000000000000..b78116f25e71
--- /dev/null
+++ b/net/xdp/xsk_sink.c
@@ -0,0 +1,416 @@
+// SPDX-License-Identifier: GPL-2.0
+/* AF_XDP RX in the device's buffer layout
+ *
+ * Userspace lends page-sized UMEM chunks through the FILL ring. Each chunk
+ * becomes a net_iov of a page pool memory provider, and the device splits it
+ * as it splits pages: a chunk may hold several RX buffers, and a packet may
+ * span chunks.
+ *
+ * The kernel maps the chunks through the UMEM mapping, so XDP programs read
+ * and write the packets in place. The kernel stores none of its own data in
+ * the chunks: the shared info of a packet lives in the sink, see
+ * %XDP_FLAGS_SINFO_EXT, and the core turns every verdict that would build an
+ * skb or a frame in the buffers into a drop.
+ */
+
+#include <linux/nospec.h>
+#include <net/netdev_queues.h>
+#include <net/netdev_rx_queue.h>
+#include <net/page_pool/helpers.h>
+#include <net/page_pool/memory_provider.h>
+#include <net/xdp_sock_drv.h>
+
+#include "../core/dev.h"
+#include "xsk_queue.h"
+#include "xsk_sink.h"
+
+#define XSK_SINK_DMA_ATTR (DMA_ATTR_WEAK_ORDERING | DMA_ATTR_SKIP_CPU_SYNC)
+/* Chunks a refill tops up to with released ones */
+#define XSK_SINK_RESERVE	32
+
+/* &net_iov.mp_state: whether userspace has the chunk or lent it */
+enum {
+	XSK_SINK_USER,
+	XSK_SINK_LENT,
+};
+
+struct xsk_sink {
+	struct net_iov_area area;
+	struct device *dev;
+	/* Valid until the socket unbinds */
+	struct xsk_buff_pool *pool;
+	/* NULL once no queue uses the provider */
+	struct netdev_rx_queue *rxq;
+	/* Protects fq, which stays set while the UMEM is mapped, and keeps
+	 * refills the only taker of released chunks. Besides the queue NAPI,
+	 * drivers refill from process context, as bnxt fills the rings of a
+	 * new queue while the old one still runs.
+	 */
+	spinlock_t lock;
+	struct xsk_queue *fq;
+	refcount_t refs;
+	/* One node per chunk: chunks that page pools released, from any
+	 * context
+	 */
+	struct llist_node *nodes;
+	struct llist_head released;
+};
+
+static void xsk_sink_free(struct xsk_sink *sink)
+{
+	kvfree(sink->nodes);
+	kvfree(sink->area.niovs);
+	kfree(sink);
+}
+
+static void xsk_sink_put(struct xsk_sink *sink)
+{
+	if (refcount_dec_and_test(&sink->refs))
+		xsk_sink_free(sink);
+}
+
+static int xsk_sink_init(struct page_pool *pp)
+{
+	struct xsk_sink *sink = pp->mp_priv;
+
+	/* Each net_iov is one chunk, mapped for one device */
+	if (pp->p.order)
+		return -E2BIG;
+	if (pp->p.dev != sink->dev || pp->p.offset + pp->p.max_len > PAGE_SIZE)
+		return -EINVAL;
+	/* Rings that keep every chunk posted leave none to replace the ones
+	 * the device filled: mlx5 posts about 16K pages per queue at MTU
+	 * 9000.
+	 */
+	if (pp->p.pool_size + PP_ALLOC_CACHE_SIZE >= sink->area.num_niovs)
+		return -ENOSPC;
+
+	refcount_inc(&sink->refs);
+	return 0;
+}
+
+static void xsk_sink_destroy(struct page_pool *pp)
+{
+	xsk_sink_put(pp->mp_priv);
+}
+
+/* Takes the chunks that FILL entries lend into the cache of @pp, which still
+ * holds those it gave back before. A chunk that an earlier page pool still
+ * holds goes back to it. Returns the number of chunks taken.
+ */
+static u32 xsk_sink_take_fill(struct xsk_sink *sink, struct page_pool *pp)
+{
+	struct net_iov *niov, *niovs = sink->area.niovs;
+	u32 i, entries, cons, mask, nr, n = 0;
+	struct xsk_queue *fq = sink->fq;
+	struct xdp_umem_ring *ring;
+	struct page_pool *owner;
+	netmem_ref netmem;
+	u64 addr;
+
+	lockdep_assert_held(&sink->lock);
+
+	/* One cache worth, bounding NAPI work */
+	entries = fq ? xskq_cons_nb_entries(fq, PP_ALLOC_CACHE_SIZE) : 0;
+	if (!entries)
+		return 0;
+
+	nr = sink->area.num_niovs;
+	ring = (struct xdp_umem_ring *)fq->ring;
+	mask = fq->ring_mask;
+	cons = fq->cached_cons;
+	for (i = 0; i < entries; i++) {
+		addr = ring->desc[(cons + i) & mask];
+		niov = &niovs[array_index_nospec((u32)(addr >> PAGE_SHIFT),
+						 nr)];
+		/* A chunk lent twice would be in two places at once */
+		if (unlikely(addr >= (u64)nr << PAGE_SHIFT ||
+			     READ_ONCE(niov->mp_state) == XSK_SINK_LENT)) {
+			fq->invalid_descs++;
+			continue;
+		}
+
+		WRITE_ONCE(niov->mp_state, XSK_SINK_LENT);
+		netmem = net_iov_to_netmem(niov);
+		owner = netmem_get_pp(netmem);
+		if (owner && owner != pp) {
+			page_pool_put_unrefed_netmem(owner, netmem, -1, false);
+			continue;
+		}
+		if (!owner)
+			net_mp_niov_set_page_pool(pp, niov);
+		pp->alloc.cache[n++] = netmem;
+	}
+
+	xskq_cons_release_n(fq, entries);
+	__xskq_cons_release(fq);
+	return n;
+}
+
+/* Tops up the cache of @pp, which holds @n chunks, with chunks that page
+ * pools released. A reserve, not a source. Each chunk it adds stays in
+ * circulation, so take only what FILL could not give. The lock keeps this
+ * the only consumer of the list, as llist_del_first() needs.
+ */
+static u32 xsk_sink_take_released(struct xsk_sink *sink, struct page_pool *pp,
+				  u32 n)
+{
+	struct llist_node *node;
+	struct net_iov *niov;
+
+	lockdep_assert_held(&sink->lock);
+
+	/* The page pool cache has 8 entries with 64K pages */
+	while (n < min(XSK_SINK_RESERVE, PP_ALLOC_CACHE_SIZE)) {
+		node = llist_del_first(&sink->released);
+		if (!node)
+			break;
+		niov = &sink->area.niovs[node - sink->nodes];
+		net_mp_niov_set_page_pool(pp, niov);
+		pp->alloc.cache[n++] = net_iov_to_netmem(niov);
+	}
+	return n;
+}
+
+static netmem_ref xsk_sink_alloc_netmems(struct page_pool *pp, gfp_t gfp)
+{
+	struct xsk_sink *sink = pp->mp_priv;
+	/* The NAPI owns the need_wakeup flags */
+	bool napi = in_softirq() && !in_hardirq();
+	struct xsk_queue *fq;
+	dma_addr_t dma;
+	u32 i, n;
+
+	/* The page pool refills only an empty cache */
+	if (WARN_ON_ONCE(pp->alloc.count))
+		return 0;
+
+	spin_lock_bh(&sink->lock);
+	n = xsk_sink_take_fill(sink, pp);
+	n = xsk_sink_take_released(sink, pp, n);
+	fq = sink->fq;
+	/* Ask for kicks only while FILL runs dry, as zero copy drivers do: a
+	 * kick schedules the NAPI, which a busy poller would rather run
+	 * itself. Process context refills new queues only and leaves the
+	 * flags to their NAPI and to bind.
+	 */
+	if (napi && fq && sink->pool->uses_need_wakeup) {
+		if (n)
+			xsk_clear_rx_need_wakeup(sink->pool);
+		else
+			xsk_set_rx_need_wakeup(sink->pool);
+	}
+	if (fq && !n)
+		fq->queue_empty_descs++;
+	spin_unlock_bh(&sink->lock);
+	if (!n)
+		return 0;
+
+	for (i = 0; i < n; i++) {
+		dma = page_pool_get_dma_addr_netmem(pp->alloc.cache[i]);
+		dma_sync_single_range_for_device(pp->p.dev, dma, pp->p.offset,
+						 pp->p.max_len, pp->p.dma_dir);
+	}
+
+	pp->alloc.count = n - 1;
+	return pp->alloc.cache[n - 1];
+}
+
+static bool xsk_sink_release_netmem(struct page_pool *pp, netmem_ref netmem)
+{
+	struct net_iov *niov = netmem_to_net_iov(netmem);
+	struct xsk_sink *sink = pp->mp_priv;
+
+	net_mp_niov_clear_page_pool(niov);
+	llist_add(&sink->nodes[net_iov_idx(niov)], &sink->released);
+	return false;
+}
+
+static int xsk_sink_nl_fill(void *mp_priv, struct sk_buff *rsp,
+			    struct netdev_rx_queue *rxq)
+{
+	return 0;
+}
+
+/* No queue DMAs to the UMEM any longer */
+static void xsk_sink_stop(struct xsk_sink *sink)
+{
+	bool unmap;
+
+	spin_lock_bh(&sink->lock);
+	WRITE_ONCE(sink->rxq, NULL);
+	unmap = sink->fq;
+	sink->fq = NULL;
+	spin_unlock_bh(&sink->lock);
+
+	/* Wait for wakeups that found the sink or the queue */
+	synchronize_net();
+	if (unmap)
+		xp_dma_unmap(sink->pool, XSK_SINK_DMA_ATTR);
+}
+
+/* Device unregister, after the queue stopped */
+static void xsk_sink_uninstall(void *mp_priv, struct netdev_rx_queue *rxq)
+{
+	memset(&rxq->mp_params, 0, sizeof(rxq->mp_params));
+	xsk_sink_stop(mp_priv);
+}
+
+static const struct memory_provider_ops xsk_sink_ops = {
+	.alloc_netmems	= xsk_sink_alloc_netmems,
+	.release_netmem	= xsk_sink_release_netmem,
+	.init		= xsk_sink_init,
+	.destroy	= xsk_sink_destroy,
+	.nl_fill	= xsk_sink_nl_fill,
+	.uninstall	= xsk_sink_uninstall,
+	.flags		= MP_XDP_ONLY,
+};
+
+static struct xsk_sink *xsk_sink_create(struct xsk_buff_pool *pool,
+					struct device *dev)
+{
+	u32 i, nr = pool->umem->chunks;
+	struct xsk_sink *sink;
+	struct net_iov *niov;
+	dma_addr_t dma;
+
+	sink = kzalloc_obj(*sink, GFP_KERNEL_ACCOUNT);
+	if (!sink)
+		return ERR_PTR(-ENOMEM);
+
+	/* See &xdp_rxq_info.sink_area */
+	BUILD_BUG_ON(offsetof(struct xsk_sink, area));
+
+	sink->area.niovs = kvcalloc(nr, sizeof(*niov), GFP_KERNEL_ACCOUNT);
+	sink->nodes = kvcalloc(nr, sizeof(*sink->nodes), GFP_KERNEL_ACCOUNT);
+	if (!sink->area.niovs || !sink->nodes) {
+		xsk_sink_free(sink);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	sink->area.num_niovs = nr;
+	/* Chunks are pages, see XDP_UMEM_DRV_LAYOUT */
+	sink->area.xdp_vaddr = pool->addrs;
+	sink->area.xdp_vsize = (size_t)nr << PAGE_SHIFT;
+	sink->area.xdp_shift = PAGE_SHIFT;
+	sink->dev = dev;
+	sink->pool = pool;
+	sink->fq = pool->fq;
+	spin_lock_init(&sink->lock);
+	init_llist_head(&sink->released);
+	refcount_set(&sink->refs, 1);
+
+	/* Chunks are pages, see XDP_UMEM_DRV_LAYOUT */
+	for (i = 0; i < nr; i++) {
+		niov = &sink->area.niovs[i];
+		dma = pool->dma_pages[i] & ~XSK_NEXT_PG_CONTIG_MASK;
+		net_iov_init(niov, &sink->area, NET_IOV_XSK);
+		if (net_mp_niov_set_dma_addr(niov, dma)) {
+			xsk_sink_free(sink);
+			return ERR_PTR(-ERANGE);
+		}
+	}
+
+	return sink;
+}
+
+/* Sockets sharing the pool find no sink after the grace period of
+ * xsk_sink_stop(), see xsk_wakeup()
+ */
+static void xsk_sink_detach(struct xsk_buff_pool *pool)
+{
+	struct xsk_sink *sink = pool->sink;
+
+	WRITE_ONCE(pool->sink, NULL);
+	xsk_sink_stop(sink);
+	xsk_sink_put(sink);
+	static_branch_dec(&xdp_sink_key);
+}
+
+/**
+ * xsk_sink_bind - install the UMEM of @pool as the provider of an RX queue
+ * @pool: buffer pool with an XDP_UMEM_DRV_LAYOUT UMEM
+ * @dev: device of the queue
+ * @queue_id: RX queue
+ * @flags: bind flags
+ *
+ * Context: RTNL and the instance lock of @dev.
+ * Return: 0 on success. No copy mode takes over on error.
+ */
+int xsk_sink_bind(struct xsk_buff_pool *pool, struct net_device *dev,
+		  u16 queue_id, u16 flags)
+{
+	u32 needed = NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT;
+	struct pp_memory_provider_params p = { .mp_ops = &xsk_sink_ops };
+	struct device *dma_dev;
+	struct xsk_sink *sink;
+	int err;
+
+	if (flags & XDP_USE_SG)
+		needed |= NETDEV_XDP_ACT_RX_SG;
+	if (flags & XDP_COPY || !dev->queue_mgmt_ops ||
+	    (dev->xdp_features & needed) != needed ||
+	    queue_id >= dev->real_num_rx_queues)
+		return -EOPNOTSUPP;
+
+	/* The program of another device would see a leased queue's packets */
+	if (netif_rxq_is_leased(dev, queue_id))
+		return -EOPNOTSUPP;
+
+	/* The device of the queue's page pools, which may differ per queue */
+	dma_dev = netdev_queue_get_dma_dev(dev, queue_id, NETDEV_QUEUE_TYPE_RX);
+	if (!dma_dev)
+		return -EOPNOTSUPP;
+
+	/* Without a program, drivers would build skbs from the buffers */
+	if (!dev_xdp_drv_prog_held(dev))
+		return -ENOENT;
+
+	err = xp_dma_map(pool, dma_dev, XSK_SINK_DMA_ATTR, pool->umem->pgs,
+			 pool->umem->npgs);
+	if (err)
+		return err;
+
+	sink = xsk_sink_create(pool, dma_dev);
+	if (IS_ERR(sink)) {
+		xp_dma_unmap(pool, XSK_SINK_DMA_ATTR);
+		return PTR_ERR(sink);
+	}
+
+	/* Until the first refill of the NAPI: the queue may need FILL to
+	 * start. Set before the NAPI runs, which owns the flags after that.
+	 */
+	if (pool->uses_need_wakeup)
+		xsk_set_rx_need_wakeup(pool);
+
+	/* The core keeps sink buffers to the socket once the queue runs */
+	static_branch_inc(&xdp_sink_key);
+	sink->rxq = __netif_get_rx_queue(dev, queue_id);
+	pool->sink = sink;
+	p.mp_priv = sink;
+	err = netif_mp_open_rxq(dev, queue_id, &p, NULL);
+	if (err) {
+		xsk_sink_detach(pool);
+		return err;
+	}
+
+	return 0;
+}
+
+/* Context: RTNL and the instance lock of the device */
+void xsk_sink_unbind(struct xsk_buff_pool *pool)
+{
+	struct xsk_sink *sink = pool->sink;
+	struct pp_memory_provider_params p = {
+		.mp_ops = &xsk_sink_ops,
+		.mp_priv = sink,
+	};
+
+	/* Unregister may have uninstalled the provider already. A queue that
+	 * cannot restart without it may still use the UMEM: stop the device.
+	 */
+	if (READ_ONCE(sink->rxq) &&
+	    netif_mp_close_rxq(pool->netdev, pool->queue_id, &p))
+		netif_close(pool->netdev);
+	xsk_sink_detach(pool);
+}
diff --git a/net/xdp/xsk_sink.h b/net/xdp/xsk_sink.h
new file mode 100644
index 000000000000..3f201163c530
--- /dev/null
+++ b/net/xdp/xsk_sink.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* AF_XDP RX in the device's buffer layout, see xsk_sink.c */
+
+#ifndef XSK_SINK_H_
+#define XSK_SINK_H_
+
+struct net_device;
+struct xsk_buff_pool;
+
+int xsk_sink_bind(struct xsk_buff_pool *pool, struct net_device *dev,
+		  u16 queue_id, u16 flags);
+void xsk_sink_unbind(struct xsk_buff_pool *pool);
+
+#endif /* XSK_SINK_H_ */
diff --git a/tools/include/uapi/linux/if_xdp.h b/tools/include/uapi/linux/if_xdp.h
index 50d67df78911..160a437ed540 100644
--- a/tools/include/uapi/linux/if_xdp.h
+++ b/tools/include/uapi/linux/if_xdp.h
@@ -45,6 +45,13 @@
  */
 #define XDP_UMEM_TX_METADATA_LEN	(1 << 2)
 
+/* RX buffers follow the device's layout: a page-sized chunk may hold
+ * several of them, a packet may span chunks, and the device picks the
+ * offsets. A FILL entry lends a chunk to the kernel. Needs aligned
+ * page-sized chunks and no headroom.
+ */
+#define XDP_UMEM_DRV_LAYOUT		(1 << 4)
+
 struct sockaddr_xdp {
 	__u16 sxdp_family;
 	__u16 sxdp_flags;
-- 
2.56.1

