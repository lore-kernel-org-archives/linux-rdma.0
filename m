Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795525084;
	b=tNAy+6NPjzCGp65MsQtVDLOrKnqXAPlwLyC4rYoN8FhRWSC8YrdPegIvbSPoNTrX2RJL
	 2FxuAA+Xglvt+GBrUiBVbaTpWW5FJG+ijdc4odN5/kYpjRtYtJ/nZW2UjdHepXjv9VU1w
	 Zu9lhkAZN+hjaNNgWLmTGPhVebEkuX4wlGiZaCixZcmGjsqyqMjOV+jR9UmvFgx0Nr4s4
	 lpYsBpWj2cipzEzg5wrHotZaTnLzp3AD9D7lveu8+uWNeqIRhLW2YYImOmZGvRle7GC9N
	 CbBTITWN0bAypsGFtIEU8y7F5OjtCmxw9nJ1x4uCrpoEp+PxKhWF6dM3MyAebP05E1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795525084;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=30u9uyHWEQkkhYEnv4CR+vpY+wZPioS6NouB3Hcke60=;
	b=17jAkzTaBbrs2gTwd0Lcz3gmI7XM52xXg3D9CmYJgyxSkxT3grZ/7j1dFHy9gXq2rAiS
	 najd0NHJkaQjhCTVi13/1OWYaVuGaaYU+Mi3C1CJe+lLf37zoumLd09659IEN0v0gt/u4
	 uamxg5RTcgZcBgm3vAFq+gAGuxvbDbldhm/Vmtg9j67A2WqqxTTVXz+E7ecnJ710RrzRe
	 nKury9o4cSDq90PBp1xbzqIlMZF48OhSdObs6Hibxq5col/XxtzaR/gM4OUM0SKRi3ncR
	 0oZdLNsqRdy5Z9IDwES14sjNSXnupNakWQMdWbhLDMYRhRsN7zPc+LKqzb8Mnph5WpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cdmBNWx+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EAA8606A682;
	Tue, 24 Nov 2026 12:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cdmBNWx+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 678961F000CA;
	Tue, 24 Nov 2026 12:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795525083;
	bh=30u9uyHWEQkkhYEnv4CR+vpY+wZPioS6NouB3Hcke60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cdmBNWx+ZVBXZuJnp9GgmfNXoO3aMKr5AKzwehKkJxkSoWlFiCNGH8HhM98V1eaSs
	 wKU5KzOVlOZ+LcCLq1q8vkD6Awi8ULpXMcnPK+uKZi1WgWBEFCk27CuTzoniatpwY2
	 Qx0h0AQFjUAK+9UtKEFOvHD35Ao7JV0cVJurzYEZ6MOGuR3cuiRZqwASlbhzpY6wmz
	 xA4aNKtw7jws9gPeGz6x+tWA4KTT9cbI3Uj/NI7xhsqHlbxM0DleXjGX/FecCOLldv
	 0KEaAG/8WlGkpeMUdIwWavm/iC4J726REaii6gzyfbrQuaFj4IuCDvZGF9mPI0CnUa
	 lW/G4dsA3KXAg==
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
Subject: [PATCH net-next 05/15] xdp: Run programs on buffers that must not hold kernel structures
Date: Tue, 24 Nov 2026 13:56:40 +0100
Message-ID: <20261124125654.183091-5-bjorn@kernel.org>
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

Currently, the core refuses native XDP programs next to a memory
provider. An AF_XDP sink needs XDP to steer its packets and to use the
RX metadata kfuncs. Its buffers are UMEM chunks that XDP may read
through the kernel mapping, but that userspace may write at any time,
also while the kernel reads them. If drivers build XDP buffers on them
as on pages, the core puts kernel structures into them, such as the
shared info of a multi-buffer packet, the xdp_frame of XDP_TX and
redirects, and the skb of XDP_PASS.

Let programs run on sink buffers as on pages, and keep every kernel
structure out of them.

A sink offers an XDP view of its UMEM, so drivers build the buffer as
for a page, while netmem_address() and skb_frag_address() still give
NULL for sink net_iovs. Programs and helpers read and write the packet
in place, fragments included. xdp_prepare_buff() tells a sink head by
its address, with one range check under a static key, and marks the
buffer before the driver adds fragments. Other buffers pay nothing
while no sink is bound.

A marked buffer keeps its shared info in the queue, with
XDP_FLAGS_SINFO_EXT, set up when the driver registers a sink page pool
as its memory model.

A sink buffer may only go to the AF_XDP socket of its queue. The core
turns XDP_TX and XDP_PASS into XDP_DROP, so drivers need no checks of
their own. XDP_ABORTED and invalid verdicts reach the driver, which
traces them and drops the packet. Frame conversion and skb
construction refuse sink buffers too, so devmap and cpumap drop them,
and sink net_iovs never become skb frags, so every net_iov frag stays
unreadable.

As userspace may change the bytes meanwhile, the kernel takes bounds
only from its own fields, and only the program and its helpers read
the bytes. A helper that reads bytes twice must check a copy.

Signed-off-by: Björn Töpel <bjorn@kernel.org>
---
 include/net/netmem.h          |  5 ++-
 include/net/page_pool/types.h |  7 ++--
 include/net/xdp.h             | 60 +++++++++++++++++++++++++++++++++--
 net/core/xdp.c                | 46 +++++++++++++++++++++++++--
 4 files changed, 108 insertions(+), 10 deletions(-)

diff --git a/include/net/netmem.h b/include/net/netmem.h
index 1be7298ac6d9..834a735e33a7 100644
--- a/include/net/netmem.h
+++ b/include/net/netmem.h
@@ -68,6 +68,7 @@ DECLARE_STATIC_KEY_FALSE(page_pool_mem_providers);
 enum net_iov_type {
 	NET_IOV_DMABUF,
 	NET_IOV_IOURING,
+	NET_IOV_XSK,
 };
 
 /* A memory descriptor representing abstract networking I/O vectors.
@@ -81,7 +82,9 @@ enum net_iov_type {
  * CPU-readable or unreadable. New code must not assume net_iov implies
  * unreadable memory (check readability via netmem_address() or
  * skb_frags_readable() instead) and should, as much as possible, generalize
- * existing limitations to match the design principles.
+ * existing limitations to match the design principles. AF_XDP sink
+ * net_iovs (%NET_IOV_XSK) are unreadable for the core and the stack as well:
+ * only XDP reads them, through their XDP view (&net_iov_area.xdp_vaddr).
  *
  * @pp_magic:	pp field, similar to the one in struct page/struct
  *		netmem_desc.
diff --git a/include/net/page_pool/types.h b/include/net/page_pool/types.h
index 35d4dc45db6a..e932d836316f 100644
--- a/include/net/page_pool/types.h
+++ b/include/net/page_pool/types.h
@@ -33,9 +33,10 @@
 
 /*
  * Allow an XDP-only memory provider of the queue (%MP_XDP_ONLY) to back the
- * pool. The driver registers the pool as the memory model of the RX queue,
- * sets up XDP buffers with xdp_prepare_buff() at xdp_netmem_address() of
- * their head, and puts heads back by netmem, not by address.
+ * pool. The driver registers the pool as the memory model of the RX queue
+ * with xdp_rxq_info_reg_mem_model(), sets up XDP buffers with
+ * xdp_prepare_buff() at xdp_netmem_address() of their head, and puts heads
+ * back by netmem, not by address.
  */
 #define PP_FLAG_ALLOW_XDP_ONLY_NETMEM BIT(4)
 
diff --git a/include/net/xdp.h b/include/net/xdp.h
index 944418111a86..c7cb0ba4e16f 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -65,6 +65,10 @@ struct xdp_rxq_info {
 	u32 reg_state;
 	struct xdp_mem_info mem;
 	u32 frag_size;
+	/* Area of the MP_XDP_ONLY provider of the page pool, see
+	 * xdp_sink_mark()
+	 */
+	struct net_iov_area *sink_area;
 	/* Shared info of buffers with %XDP_FLAGS_SINFO_EXT, in kernel
 	 * memory, see xdp_rxq_info_reg_ext_sinfo(). The queue builds one
 	 * such buffer at a time.
@@ -95,6 +99,15 @@ enum xdp_buff_flags {
 	 * frame, see xdp_data_hard_end(): the frame must hold nothing else.
 	 */
 	XDP_FLAGS_SINFO_EXT		= BIT(3),
+	/* AF_XDP sink memory, see %MP_XDP_ONLY: the buffer may only go to the
+	 * AF_XDP socket of its queue. Userspace may write it at any time,
+	 * also while the kernel reads it. So the kernel takes bounds only
+	 * from its own fields, and only the XDP program and its helpers read
+	 * the bytes. A helper that checks bytes and reads them again later
+	 * must check a copy, see bpf_syncookie_th(). Nothing builds a frame
+	 * or an skb in the buffer.
+	 */
+	XDP_FLAGS_SINK			= BIT(4),
 };
 
 struct xdp_buff {
@@ -150,6 +163,14 @@ static __always_inline void xdp_buff_set_frag_unreadable(struct xdp_buff *xdp)
 	xdp->flags |= XDP_FLAGS_FRAGS_UNREADABLE;
 }
 
+static __always_inline bool xdp_buff_is_sink(const struct xdp_buff *xdp)
+{
+	return !!(xdp->flags & XDP_FLAGS_SINK);
+}
+
+/* Enabled while an AF_XDP socket receives in the device's buffer layout */
+DECLARE_STATIC_KEY_FALSE(xdp_sink_key);
+
 static __always_inline u32 xdp_buff_get_skb_flags(const struct xdp_buff *xdp)
 {
 	return xdp->flags;
@@ -178,6 +199,21 @@ xdp_init_buff(struct xdp_buff *xdp, u32 frame_sz, struct xdp_rxq_info *rxq)
 #endif
 }
 
+/* Drivers take the address of a head buffer with xdp_netmem_address(),
+ * which for an AF_XDP sink lies in its XDP view, the UMEM, see
+ * &net_iov_area.xdp_vaddr. Mark such buffers before the driver adds
+ * fragments: their shared info lives in the queue, and they may only go to
+ * the AF_XDP socket of the queue.
+ */
+static __always_inline void xdp_sink_mark(struct xdp_buff *xdp)
+{
+	struct net_iov_area *area = xdp->rxq->sink_area;
+	unsigned long off = (u8 *)xdp->data_hard_start - (u8 *)area->xdp_vaddr;
+
+	if (off < area->xdp_vsize)
+		xdp->flags |= XDP_FLAGS_SINK | XDP_FLAGS_SINFO_EXT;
+}
+
 /* XDP view of net_iovs: a memory provider may give XDP an address for its
  * net_iovs, see &net_iov_area.xdp_vaddr. XDP code may read and write a
  * net_iov only through these helpers, and only if its provider offers a
@@ -212,6 +248,9 @@ static __always_inline void *xdp_frag_address(const skb_frag_t *frag)
 	return addr ? addr + skb_frag_off(frag) : NULL;
 }
 
+/* Marks sink buffers in @xdp->flags too: call it after xdp_init_buff(), which
+ * clears the flags
+ */
 static __always_inline void
 xdp_prepare_buff(struct xdp_buff *xdp, unsigned char *hard_start,
 		 int headroom, int data_len, const bool meta_valid)
@@ -222,6 +261,10 @@ xdp_prepare_buff(struct xdp_buff *xdp, unsigned char *hard_start,
 	xdp->data = data;
 	xdp->data_end = data + data_len;
 	xdp->data_meta = meta_valid ? data : data + 1;
+
+	if (static_branch_unlikely(&xdp_sink_key) && xdp->rxq &&
+	    unlikely(xdp->rxq->sink_area))
+		xdp_sink_mark(xdp);
 }
 
 /* Reserve memory area at end-of data area.
@@ -348,8 +391,12 @@ static inline bool xdp_buff_add_frag(struct xdp_buff *xdp, netmem_ref netmem,
 
 	if (unlikely(netmem_is_pfmemalloc(netmem)))
 		xdp_buff_set_frag_pfmemalloc(xdp);
-	if (unlikely(netmem_is_net_iov(netmem)))
+	if (unlikely(netmem_is_net_iov(netmem))) {
 		xdp_buff_set_frag_unreadable(xdp);
+		/* AF_XDP sink memory may only go to the socket of its queue */
+		if (netmem_to_net_iov(netmem)->type == NET_IOV_XSK)
+			xdp->flags |= XDP_FLAGS_SINK;
+	}
 
 	return true;
 }
@@ -478,8 +525,10 @@ int xdp_update_frame_from_buff(const struct xdp_buff *xdp,
 		return -ENOSPC;
 	}
 
-	/* A frame keeps its shared info in the buffer */
-	if (unlikely(xdp->flags & XDP_FLAGS_SINFO_EXT))
+	/* Sink buffers go to their AF_XDP socket, or nowhere. A frame keeps
+	 * its shared info in the buffer.
+	 */
+	if (unlikely(xdp->flags & (XDP_FLAGS_SINK | XDP_FLAGS_SINFO_EXT)))
 		return -EFAULT;
 
 	xdp_frame->data = xdp->data;
@@ -763,6 +812,11 @@ static __always_inline u32 bpf_prog_run_xdp(const struct bpf_prog *prog,
 	 */
 	u32 act = __bpf_prog_run(prog, xdp, BPF_DISPATCHER_FUNC(xdp));
 
+	/* Sink buffers go to the AF_XDP socket of their queue, or nowhere */
+	if (static_branch_unlikely(&xdp_sink_key) && xdp_buff_is_sink(xdp) &&
+	    (act == XDP_PASS || act == XDP_TX))
+		act = XDP_DROP;
+
 	if (static_branch_unlikely(&bpf_master_redirect_enabled_key)) {
 		if (act == XDP_TX && netif_is_bond_slave(xdp->rxq->dev))
 			act = xdp_master_redirect(xdp);
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 3472b03ee661..b22944f84d93 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -15,6 +15,7 @@
 #include <linux/rhashtable.h>
 #include <linux/bug.h>
 #include <net/page_pool/helpers.h>
+#include <net/page_pool/memory_provider.h>
 
 #include <net/hotdata.h>
 #include <net/netdev_lock.h>
@@ -142,6 +143,7 @@ void xdp_rxq_info_unreg_mem_model(struct xdp_rxq_info *xdp_rxq)
 	}
 
 	xdp_unreg_mem_model(&xdp_rxq->mem);
+	xdp_rxq->sink_area = NULL;
 	kfree(xdp_rxq->ext_sinfo);
 	xdp_rxq->ext_sinfo = NULL;
 }
@@ -334,11 +336,26 @@ static struct xdp_mem_allocator *__xdp_reg_mem_model(struct xdp_mem_info *mem,
 	return ERR_PTR(errno);
 }
 
+/* The page pool has an MP_XDP_ONLY provider */
+static bool xdp_mem_is_sink(enum xdp_mem_type type, void *allocator)
+{
+	struct page_pool *pp = allocator;
+
+	return type == MEM_TYPE_PAGE_POOL && pp && pp->mp_ops &&
+	       pp->mp_ops->flags & MP_XDP_ONLY;
+}
+
 int xdp_reg_mem_model(struct xdp_mem_info *mem,
 		      enum xdp_mem_type type, void *allocator)
 {
 	struct xdp_mem_allocator *xdp_alloc;
 
+	/* Sink buffers need the area and shared info that only
+	 * xdp_rxq_info_reg_mem_model() sets up
+	 */
+	if (xdp_mem_is_sink(type, allocator))
+		return -EOPNOTSUPP;
+
 	xdp_alloc = __xdp_reg_mem_model(mem, type, allocator);
 	if (IS_ERR(xdp_alloc))
 		return PTR_ERR(xdp_alloc);
@@ -346,23 +363,44 @@ int xdp_reg_mem_model(struct xdp_mem_info *mem,
 }
 EXPORT_SYMBOL_GPL(xdp_reg_mem_model);
 
+DEFINE_STATIC_KEY_FALSE(xdp_sink_key);
+EXPORT_SYMBOL_GPL(xdp_sink_key);
+
 int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
 			       enum xdp_mem_type type, void *allocator)
 {
+	bool had_sinfo = xdp_rxq->ext_sinfo;
 	struct xdp_mem_allocator *xdp_alloc;
+	int err;
 
 	if (xdp_rxq->reg_state != REG_STATE_REGISTERED) {
 		WARN(1, "Missing register, driver bug");
 		return -EFAULT;
 	}
 
+	/* Userspace may write sink buffers: their shared info lives here */
+	if (xdp_mem_is_sink(type, allocator)) {
+		err = xdp_rxq_info_reg_ext_sinfo(xdp_rxq);
+		if (err)
+			return err;
+	}
+
 	xdp_alloc = __xdp_reg_mem_model(&xdp_rxq->mem, type, allocator);
-	if (IS_ERR(xdp_alloc))
+	if (IS_ERR(xdp_alloc)) {
+		if (!had_sinfo) {
+			kfree(xdp_rxq->ext_sinfo);
+			xdp_rxq->ext_sinfo = NULL;
+		}
 		return PTR_ERR(xdp_alloc);
+	}
 
 	if (type == MEM_TYPE_XSK_BUFF_POOL && allocator)
 		xsk_pool_set_rxq_info(allocator, xdp_rxq);
 
+	/* MP_XDP_ONLY providers put their net_iov_area first in mp_priv */
+	xdp_rxq->sink_area = xdp_mem_is_sink(type, allocator) ?
+			     ((struct page_pool *)allocator)->mp_priv : NULL;
+
 	if (trace_mem_connect_enabled() && xdp_alloc)
 		trace_mem_connect(xdp_alloc, xdp_rxq);
 	return 0;
@@ -664,8 +702,10 @@ struct sk_buff *xdp_build_skb_from_buff(const struct xdp_buff *xdp)
 	u32 nr_frags = 0;
 	int metalen;
 
-	/* An skb keeps its shared info in the buffer */
-	if (unlikely(xdp->flags & XDP_FLAGS_SINFO_EXT))
+	/* Sink buffers go to their AF_XDP socket, or nowhere. An skb keeps
+	 * its shared info in the buffer.
+	 */
+	if (unlikely(xdp->flags & (XDP_FLAGS_SINK | XDP_FLAGS_SINFO_EXT)))
 		return NULL;
 
 	if (unlikely(xdp_buff_has_frags(xdp))) {
-- 
2.56.1

