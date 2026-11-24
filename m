Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795525120;
	b=g2iJkhuGcgiv05mbysmEhlZkevTr/Dcr7n7u/Iu23Wa5B9Mc2yVhhqtbSwV6XJfGNm33
	 8EkcSUbFO1eBc6XpgBRkgLJ7BOH1UlmNDtTPqNuh8eagzSX/fBuU0r7Q0N7RhSVC3WqCu
	 HYAPjC+cdlHAjKn2XLw10YY7Z5kOGUK2KhAHhtX+Iq1T08H3/e0wyysBUm0gegsy8VbF3
	 BtZN4QzICMPKql9SMgKaklihO1s0NlOnA9PxLUPCvaOG80pdpzSADOm+t23NDqr+6qYls
	 kUIch4hQgkcEyssZAetjFKUVXLTL/XeE6he89qEGjBPyk4m1gyxTrWzYtjOw8VbWC/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795525120;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=yQOnOkITHSdFbXefqjjircbS72nRZDYQ3gijJDi6lok=;
	b=wpzJcKuGwISiCwyy2553lozUPbOB5cUXTkthVyDN7SNCTYmVXAJdszNHTzQWI1mlPRhq
	 ZY6FACuHM7z19vTKrOAQJY35THhamgcCMmueoV80oH9uTDTyqTS61Zlrl0pvD1BMDL6gn
	 x4vOQbW/kMoWZkhjmZGNu0O4535uR8sDFZRhf9BjYYdYpdJt4lliFsSBvHlm6jm+OxfDO
	 tjGcF2SEaj0fVvof19IOlgsaoGeDKgAqbXAbHbqCodD15V8mydnueuzlBBGr1c6P2ySSS
	 uBco+smTQbXlnfGHSIgWm5k1DRyr6ZohSZFMvdCFdFkN4w1S/9b7BVtTXKRFuPptfMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jdt5pZF3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531C6606A332;
	Tue, 24 Nov 2026 12:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jdt5pZF3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01F711F000C4;
	Tue, 24 Nov 2026 12:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795525120;
	bh=yQOnOkITHSdFbXefqjjircbS72nRZDYQ3gijJDi6lok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jdt5pZF3AfUCly01B7rEvKNtGQFjAxF8jqjxlkIm96bfDpKjhl7WEraGPX5S3OMYn
	 L1BRRCHtBa6yYr9rJTSpoYwL46oXvYu737kz0+FrdIjjYqp4BOYoiHkLZVr2eeh77R
	 bX4/5UgZfV+svCkmw3XIpf+su2EQ9wPoZZKdxajCwv7kx1KtpaS9oESNqxy3tl1mX3
	 N4RHL2KYqAYBnCUY3MsX8DmUlMuPT5ArupggPVu/OXtkae0u9kqgGpdCDhYKER+4Vn
	 IOnonA3RGv7ZB3sfyCV3sb25/LElL6fcs941l/Yxqjrtre0XDVRHzsbrYjk60BO3/S
	 7jcoy1E7QqSxA==
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
Subject: [PATCH net-next 08/15] xsk: Receive in the device's buffer layout
Date: Tue, 24 Nov 2026 13:56:43 +0100
Message-ID: <20261124125654.183091-8-bjorn@kernel.org>
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

Currently, userspace cannot use the device's buffer layout of the
previous two patches.

Accept XDP_UMEM_DRV_LAYOUT at UMEM registration, with aligned
page-sized chunks and no headroom, and install the provider when a
socket with such a UMEM binds to a queue.

A queue in the device's buffer layout has one receiving socket, the
first that binds with an RX ring. Another socket with an RX ring gets
-EBUSY, also after the receiving socket went, as nothing would fill
its RX ring. Sockets that share the UMEM may transmit in copy mode.
The provider goes when the receiving socket closes, not with the last
socket of the pool, so that the program can be detached right after.
The UMEM has no copy mode, so a bind with XDP_COPY fails, and a bind
that cannot install the provider fails instead of falling back.

recvmsg() and poll() wake the queue NAPI when the RX need_wakeup flag
asks for it, as they wake the driver for zero copy. A wakeup that
races with unbind finds no queue, and recvmsg() returns -ENETDOWN. The
queue NAPI changes the need_wakeup flags while sendmsg(), recvmsg()
and poll() read them without a lock, so mark those accesses, and let
poll() read the flags once.

Signed-off-by: Björn Töpel <bjorn@kernel.org>
---
 net/xdp/xdp_umem.c |  5 +++
 net/xdp/xsk.c      | 82 +++++++++++++++++++++++++++++++++++++++-------
 net/xdp/xsk_sink.c | 25 ++++++++++++--
 net/xdp/xsk_sink.h |  1 +
 4 files changed, 98 insertions(+), 15 deletions(-)

diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index cd8643360eb3..5989e5e0e17e 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -153,6 +153,7 @@ static int xdp_umem_account_pages(struct xdp_umem *umem)
 		XDP_UMEM_UNALIGNED_CHUNK_FLAG | \
 		XDP_UMEM_TX_SW_CSUM | \
 		XDP_UMEM_TX_METADATA_LEN | \
+		XDP_UMEM_DRV_LAYOUT | \
 	0)
 
 static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
@@ -207,6 +208,10 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 		       SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) - 128)
 		return -EINVAL;
 
+	if (mr->flags & XDP_UMEM_DRV_LAYOUT &&
+	    (unaligned_chunks || chunk_size != PAGE_SIZE || headroom))
+		return -EINVAL;
+
 	if (mr->flags & XDP_UMEM_TX_METADATA_LEN) {
 		if (mr->tx_metadata_len >= 256 || mr->tx_metadata_len % 8)
 			return -EINVAL;
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 0753fac8d4a8..c015894a6ccb 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -55,7 +55,8 @@ void xsk_set_rx_need_wakeup(struct xsk_buff_pool *pool)
 		return;
 
 	pool->fq->ring->flags |= XDP_RING_NEED_WAKEUP;
-	pool->cached_need_wakeup |= XDP_WAKEUP_RX;
+	WRITE_ONCE(pool->cached_need_wakeup,
+		   pool->cached_need_wakeup | XDP_WAKEUP_RX);
 }
 EXPORT_SYMBOL(xsk_set_rx_need_wakeup);
 
@@ -72,7 +73,8 @@ void xsk_set_tx_need_wakeup(struct xsk_buff_pool *pool)
 	}
 	rcu_read_unlock();
 
-	pool->cached_need_wakeup |= XDP_WAKEUP_TX;
+	WRITE_ONCE(pool->cached_need_wakeup,
+		   pool->cached_need_wakeup | XDP_WAKEUP_TX);
 }
 EXPORT_SYMBOL(xsk_set_tx_need_wakeup);
 
@@ -82,7 +84,8 @@ void xsk_clear_rx_need_wakeup(struct xsk_buff_pool *pool)
 		return;
 
 	pool->fq->ring->flags &= ~XDP_RING_NEED_WAKEUP;
-	pool->cached_need_wakeup &= ~XDP_WAKEUP_RX;
+	WRITE_ONCE(pool->cached_need_wakeup,
+		   pool->cached_need_wakeup & ~XDP_WAKEUP_RX);
 }
 EXPORT_SYMBOL(xsk_clear_rx_need_wakeup);
 
@@ -99,7 +102,8 @@ void xsk_clear_tx_need_wakeup(struct xsk_buff_pool *pool)
 	}
 	rcu_read_unlock();
 
-	pool->cached_need_wakeup &= ~XDP_WAKEUP_TX;
+	WRITE_ONCE(pool->cached_need_wakeup,
+		   pool->cached_need_wakeup & ~XDP_WAKEUP_TX);
 }
 EXPORT_SYMBOL(xsk_clear_tx_need_wakeup);
 
@@ -817,9 +821,16 @@ u32 xsk_tx_peek_release_desc_batch(struct xsk_buff_pool *pool, u32 nb_pkts)
 }
 EXPORT_SYMBOL(xsk_tx_peek_release_desc_batch);
 
+/* Context: RCU read side, see xsk_sink_unbind() for a sink */
 static int xsk_wakeup(struct xdp_sock *xs, u8 flags)
 {
 	struct net_device *dev = xs->dev;
+	struct xsk_sink *sink;
+
+	if (xsk_drv_layout(xs)) {
+		sink = READ_ONCE(xs->pool->sink);
+		return sink ? xsk_sink_wakeup(sink) : -ENETDOWN;
+	}
 
 	return dev->netdev_ops->ndo_xsk_wakeup(dev, xs->queue_id, flags);
 }
@@ -1418,7 +1429,7 @@ static int __xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len
 		return 0;
 
 	pool = xs->pool;
-	if (pool->cached_need_wakeup & XDP_WAKEUP_TX) {
+	if (READ_ONCE(pool->cached_need_wakeup) & XDP_WAKEUP_TX) {
 		if (xs->zc)
 			return xsk_wakeup(xs, XDP_WAKEUP_TX);
 		return xsk_generic_xmit(sk);
@@ -1458,7 +1469,9 @@ static int __xsk_recvmsg(struct socket *sock, struct msghdr *m, size_t len, int
 	if (xsk_no_wakeup(sk))
 		return 0;
 
-	if (xs->pool->cached_need_wakeup & XDP_WAKEUP_RX && xs->zc)
+	/* A sink socket receives without driver zero copy */
+	if (READ_ONCE(xs->pool->cached_need_wakeup) & XDP_WAKEUP_RX &&
+	    (xs->zc || xsk_drv_layout(xs)))
 		return xsk_wakeup(xs, XDP_WAKEUP_RX);
 	return 0;
 }
@@ -1481,6 +1494,7 @@ static __poll_t xsk_poll(struct file *file, struct socket *sock,
 	struct sock *sk = sock->sk;
 	struct xdp_sock *xs = xdp_sk(sk);
 	struct xsk_buff_pool *pool;
+	u8 need_wakeup;
 
 	sock_poll_wait(file, sock, wait);
 
@@ -1489,13 +1503,19 @@ static __poll_t xsk_poll(struct file *file, struct socket *sock,
 		goto out;
 
 	pool = xs->pool;
+	/* Drivers change it from their NAPI */
+	need_wakeup = READ_ONCE(pool->cached_need_wakeup);
 
-	if (pool->cached_need_wakeup) {
-		if (xs->zc)
-			xsk_wakeup(xs, pool->cached_need_wakeup);
-		else if (xs->tx)
-			/* Poll needs to drive Tx also in copy mode */
-			xsk_generic_xmit(sk);
+	if (need_wakeup) {
+		if (xs->zc) {
+			xsk_wakeup(xs, need_wakeup);
+		} else {
+			if (xsk_drv_layout(xs) && need_wakeup & XDP_WAKEUP_RX)
+				xsk_wakeup(xs, XDP_WAKEUP_RX);
+			if (xs->tx)
+				/* Poll needs to drive Tx also in copy mode */
+				xsk_generic_xmit(sk);
+		}
 	}
 
 	if (xs->rx && !xskq_prod_is_empty(xs->rx))
@@ -1585,6 +1605,29 @@ static void xsk_delete_from_maps(struct xdp_sock *xs)
 	}
 }
 
+/* The pool may outlive the socket, see xp_put_pool(). A queue in the
+ * device's buffer layout stops receiving when its receiving socket goes,
+ * so that its program can go right after.
+ */
+static void xsk_sink_release(struct xdp_sock *xs)
+{
+	struct xsk_buff_pool *pool = READ_ONCE(xs->pool);
+	struct net_device *dev;
+
+	if (!pool || !READ_ONCE(pool->sink))
+		return;
+
+	rtnl_lock();
+	dev = pool->netdev;
+	if (dev) {
+		netdev_lock_ops(dev);
+		if (pool->sink && xsk_sink_sock(pool->sink) == xs)
+			xsk_sink_unbind(pool);
+		netdev_unlock_ops(dev);
+	}
+	rtnl_unlock();
+}
+
 static int xsk_release(struct socket *sock)
 {
 	struct sock *sk = sock->sk;
@@ -1606,6 +1649,7 @@ static int xsk_release(struct socket *sock)
 	sock_prot_inuse_add(net, sk->sk_prot, -1);
 
 	xsk_delete_from_maps(xs);
+	xsk_sink_release(xs);
 	mutex_lock(&xs->mutex);
 	xsk_unbind_dev(xs);
 	mutex_unlock(&xs->mutex);
@@ -1758,6 +1802,18 @@ static int xsk_bind(struct socket *sock, struct sockaddr_unsized *addr, int addr
 				goto out_unlock;
 			}
 
+			/* A queue in the device's buffer layout has one
+			 * receiving socket, and none once that one went
+			 */
+			if (xs->rx &&
+			    umem_xs->umem->flags & XDP_UMEM_DRV_LAYOUT &&
+			    (!umem_xs->pool->sink ||
+			     xsk_sink_sock(umem_xs->pool->sink))) {
+				err = -EBUSY;
+				sockfd_put(sock);
+				goto out_unlock;
+			}
+
 			xp_get_pool(umem_xs->pool);
 			xs->pool = umem_xs->pool;
 
@@ -1810,6 +1866,8 @@ static int xsk_bind(struct socket *sock, struct sockaddr_unsized *addr, int addr
 	xs->sg = !!(xs->umem->flags & XDP_UMEM_SG_FLAG);
 	xs->queue_id = qid;
 	xp_add_xsk(xs->pool, xs);
+	if (xs->pool->sink)
+		xsk_sink_add_sock(xs->pool->sink, xs);
 
 	if (qid < dev->real_num_rx_queues) {
 		struct netdev_rx_queue *rxq;
diff --git a/net/xdp/xsk_sink.c b/net/xdp/xsk_sink.c
index 9f1f7cf82266..2c23fecb59d4 100644
--- a/net/xdp/xsk_sink.c
+++ b/net/xdp/xsk_sink.c
@@ -297,7 +297,7 @@ static netmem_ref xsk_sink_alloc_netmems(struct page_pool *pp, gfp_t gfp)
 	 * chunks that waited. Process context refills new queues only and
 	 * leaves the flags to their NAPI and to bind.
 	 */
-	if (napi && fq && sink->pool->uses_need_wakeup) {
+	if (napi && fq) {
 		if (n && llist_empty(&sink->handed))
 			xsk_clear_rx_need_wakeup(sink->pool);
 		else
@@ -501,6 +501,10 @@ int xsk_sink_bind(struct xsk_buff_pool *pool, struct net_device *dev,
 	struct xsk_sink *sink;
 	int err;
 
+	/* Without a wakeup, a queue that used up the FILL ring stays dry */
+	if (!(flags & XDP_USE_NEED_WAKEUP))
+		return -EINVAL;
+
 	if (flags & XDP_USE_SG)
 		needed |= NETDEV_XDP_ACT_RX_SG;
 	if (flags & XDP_COPY || !dev->queue_mgmt_ops ||
@@ -535,8 +539,7 @@ int xsk_sink_bind(struct xsk_buff_pool *pool, struct net_device *dev,
 	/* Until the first refill of the NAPI: the queue may need FILL to
 	 * start. Set before the NAPI runs, which owns the flags after that.
 	 */
-	if (pool->uses_need_wakeup)
-		xsk_set_rx_need_wakeup(pool);
+	xsk_set_rx_need_wakeup(pool);
 
 	/* The core keeps sink buffers to the socket once the queue runs */
 	static_branch_inc(&xdp_sink_key);
@@ -591,6 +594,22 @@ void xsk_sink_unbind(struct xsk_buff_pool *pool)
 	xsk_sink_detach(pool);
 }
 
+int xsk_sink_wakeup(struct xsk_sink *sink)
+{
+	struct netdev_rx_queue *rxq;
+	struct napi_struct *napi;
+
+	rxq = READ_ONCE(sink->rxq);
+	napi = rxq ? READ_ONCE(rxq->napi) : NULL;
+	if (!napi)
+		return -ENETDOWN;
+
+	local_bh_disable();
+	napi_schedule(napi);
+	local_bh_enable();
+	return 0;
+}
+
 /* The net_iov of @netmem if it is one of ours; tells by its address */
 static __always_inline struct net_iov *xsk_sink_niov(struct xsk_sink *sink,
 						     netmem_ref netmem)
diff --git a/net/xdp/xsk_sink.h b/net/xdp/xsk_sink.h
index fe73b2916608..ac6913207ca0 100644
--- a/net/xdp/xsk_sink.h
+++ b/net/xdp/xsk_sink.h
@@ -12,6 +12,7 @@ struct xsk_sink;
 int xsk_sink_bind(struct xsk_buff_pool *pool, struct net_device *dev,
 		  u16 queue_id, u16 flags);
 void xsk_sink_unbind(struct xsk_buff_pool *pool);
+int xsk_sink_wakeup(struct xsk_sink *sink);
 void xsk_sink_flush(struct xsk_sink *sink);
 void xsk_sink_add_sock(struct xsk_sink *sink, struct xdp_sock *xs);
 struct xdp_sock *xsk_sink_sock(struct xsk_sink *sink);
-- 
2.56.1

