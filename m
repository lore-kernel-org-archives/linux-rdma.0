Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795525048;
	b=ZFmqVCI5hyQd1LY6mM9rYdJKEtmLq20urIBVAraSI7qB1mebDXWqD2LVjYFkZfGPRSB+
	 ngWLyy7WZW0ZvimahwG6JUbHHHWLIAqMIUGQV2XW2PH0ZpkqFwqpvwy5DGE4fMsRd+Tgy
	 jdA8y91HoT34Vp5O+pJSt+WOSg1rVHUb9LpCa9iknUbsXyhvDAXrSCLuOQ5ZzzHcOpQEh
	 t6T7eor+JzUnukL7LKF4/OJ8CSLWHoX+RTnVK65fK2nppJddU+Js1cmbhuCPcApxAMmq+
	 lGMB6KKJTjycCIqj5F5933Y4rHN/Ba/zTxYB8Rwrv71B2GcMaKsOkILicczS0uuvp8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795525048;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=dNNwywQJbTsZXg/w5rJJ/5JqisBmDi3sRrbjcHK3wFI=;
	b=d5cFrg/rmRCEIE7UtKOda7XXXK07l9QzFAhzZEepxJhfIKK9TrehRj3zXlXBDTTbMgwL
	 K4qLxUzx7U0nbMttpGiAmqdyQXhHUVPAgSR7RpYvg4RotdVAwOJPWoec/xc88PLyUfAsY
	 Tmg8zWfnyzXi/vE6tJFn3NPypLQ0ALTXoRB4njqpLyVYZC7sv2w4XDEHf2wZXkwng6O2O
	 82oYDHOolqDRjL+cMjrPKYs0SKKnwZOtfCZ/tWfJSHX1stkk3mBI6yqfu2vxzBUs/lXLP
	 1iwhlxnw1xgDPwOrsEOsZw1hXzsbf5ft0mSwE/ptroOj/Z+pXmDk1RjkNEUQG/vPauQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RITCRP94;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3CF606A31E;
	Tue, 24 Nov 2026 12:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RITCRP94
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FEA51F000D8;
	Tue, 24 Nov 2026 12:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795525047;
	bh=dNNwywQJbTsZXg/w5rJJ/5JqisBmDi3sRrbjcHK3wFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RITCRP94VvGO4yKZt0Mc2EcdoIJbRPKkygZKiYEXUC62oX65zzxJGW+g0nf5HePbL
	 PGeUarp0OhFoqURnm96f7IledVu7c4FlRPUkYORRD3SQ9yS9k0dq3kwFensDxqQr3f
	 SDlANCSzwy5mB+SKo/8YPyNKTUtsO81jpD5EqhVUuVyGfqywVmwdhwneN2iSUmEepp
	 mOuwN82PRrFLy96Hcb7HvR3fUB9ZOdQljO5g44VyYiqdvxEPIIX8AEbOOdgKmSQoh0
	 ludlwWiniWUwo8QmedTZYseZiYZkp2QXqOmg7JT0xCm7YqXvoFpPzEFF+uKlK+Hh+T
	 Rc/m9v+KjiV7Q==
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
Subject: [PATCH net-next 02/15] xdp: Keep the shared info of a buffer in kernel memory
Date: Tue, 24 Nov 2026 13:56:37 +0100
Message-ID: <20261124125654.183091-2-bjorn@kernel.org>
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

Currently, the shared info of an XDP buffer, with the fragment list of
a multi-buffer packet, lives at the end of the buffer's frame, in
memory that the device writes. Helpers follow its fragments, drivers
free them through it, and frame and skb conversion copy it, so memory
that others may write while the kernel uses it must not hold it.
Classic AF_XDP zero copy keeps it in the tail of a UMEM chunk, where
userspace can rewrite it.

Let an RX queue keep the shared info of its buffers in kernel memory.
The queue gets one from xdp_rxq_info_reg_ext_sinfo(), and
xdp_rxq_info_unreg_mem_model() frees it. A buffer with the new
XDP_FLAGS_SINFO_EXT finds its shared info there.

Whoever prepares a buffer sets the flag before adding fragments. The
queue NAPI builds one buffer at a time, so one shared info per queue
is enough. It is valid until the buffer is redirected, dropped or
copied. Frame conversion and skb construction refuse buffers with the
flag, as a frame or an skb would keep its shared info in the buffer.
Nothing sets the flag until later in this series.

xdp_data_hard_end() reserves no shared-info tailroom for such a
buffer, so its data may reach the end of the frame. frame_sz then
bounds every write past the data, such as tail growth and
bpf_xdp_pull_data(), so the frame must not cover memory of other
buffers. Drivers may then pack such buffers tighter.

Signed-off-by: Björn Töpel <bjorn@kernel.org>
---
 include/net/xdp.h | 41 +++++++++++++++++++++++++++++++++++------
 net/core/xdp.c    | 30 ++++++++++++++++++++++++++++++
 2 files changed, 65 insertions(+), 6 deletions(-)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index 1629e347b71f..944418111a86 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -65,6 +65,11 @@ struct xdp_rxq_info {
 	u32 reg_state;
 	struct xdp_mem_info mem;
 	u32 frag_size;
+	/* Shared info of buffers with %XDP_FLAGS_SINFO_EXT, in kernel
+	 * memory, see xdp_rxq_info_reg_ext_sinfo(). The queue builds one
+	 * such buffer at a time.
+	 */
+	struct skb_shared_info *ext_sinfo;
 } ____cacheline_aligned; /* perf critical, avoid false-sharing */
 
 struct xdp_txq_info {
@@ -81,6 +86,15 @@ enum xdp_buff_flags {
 	 * XDP program is not attached.
 	 */
 	XDP_FLAGS_FRAGS_UNREADABLE	= BIT(2),
+	/* The shared info lives in &xdp_rxq_info.ext_sinfo, in kernel memory,
+	 * not at the end of the frame. For memory that someone outside the
+	 * kernel may write. Whoever prepares the buffer sets it before adding
+	 * fragments, on a queue that has ext_sinfo. The queue NAPI builds one
+	 * such buffer at a time: its shared info is valid until the buffer
+	 * is redirected, dropped or copied. The data may reach the end of the
+	 * frame, see xdp_data_hard_end(): the frame must hold nothing else.
+	 */
+	XDP_FLAGS_SINFO_EXT		= BIT(3),
 };
 
 struct xdp_buff {
@@ -212,17 +226,27 @@ xdp_prepare_buff(struct xdp_buff *xdp, unsigned char *hard_start,
 
 /* Reserve memory area at end-of data area.
  *
- * This macro reserves tailroom in the XDP buffer by limiting the
- * XDP/BPF data access to data_hard_end.  Notice same area (and size)
- * is used for XDP_PASS, when constructing the SKB via build_skb().
+ * This reserves tailroom in the XDP buffer by limiting the XDP/BPF data
+ * access to data_hard_end.  Notice same area (and size) is used for
+ * XDP_PASS, when constructing the SKB via build_skb(). Buffers with
+ * %XDP_FLAGS_SINFO_EXT keep the shared info elsewhere and reserve none.
  */
-#define xdp_data_hard_end(xdp)				\
-	((xdp)->data_hard_start + (xdp)->frame_sz -	\
-	 SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))
+static __always_inline void *xdp_data_hard_end(const struct xdp_buff *xdp)
+{
+	u32 tailroom = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+
+	if (xdp->flags & XDP_FLAGS_SINFO_EXT)
+		tailroom = 0;
+	return xdp->data_hard_start + xdp->frame_sz - tailroom;
+}
 
 static inline struct skb_shared_info *
 xdp_get_shared_info_from_buff(const struct xdp_buff *xdp)
 {
+	/* Kernel structures stay out of memory that userspace may write */
+	if (unlikely(xdp->flags & XDP_FLAGS_SINFO_EXT))
+		return xdp->rxq->ext_sinfo;
+
 	return (struct skb_shared_info *)xdp_data_hard_end(xdp);
 }
 
@@ -454,6 +478,10 @@ int xdp_update_frame_from_buff(const struct xdp_buff *xdp,
 		return -ENOSPC;
 	}
 
+	/* A frame keeps its shared info in the buffer */
+	if (unlikely(xdp->flags & XDP_FLAGS_SINFO_EXT))
+		return -EFAULT;
+
 	xdp_frame->data = xdp->data;
 	xdp_frame->len  = xdp->data_end - xdp->data;
 	xdp_frame->headroom = headroom - sizeof(*xdp_frame);
@@ -533,6 +561,7 @@ bool xdp_rxq_info_is_reg(struct xdp_rxq_info *xdp_rxq);
 int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
 			       enum xdp_mem_type type, void *allocator);
 void xdp_rxq_info_unreg_mem_model(struct xdp_rxq_info *xdp_rxq);
+int xdp_rxq_info_reg_ext_sinfo(struct xdp_rxq_info *xdp_rxq);
 int xdp_reg_mem_model(struct xdp_mem_info *mem,
 		      enum xdp_mem_type type, void *allocator);
 void xdp_unreg_mem_model(struct xdp_mem_info *mem);
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 1d679e8fd649..3472b03ee661 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -142,6 +142,8 @@ void xdp_rxq_info_unreg_mem_model(struct xdp_rxq_info *xdp_rxq)
 	}
 
 	xdp_unreg_mem_model(&xdp_rxq->mem);
+	kfree(xdp_rxq->ext_sinfo);
+	xdp_rxq->ext_sinfo = NULL;
 }
 EXPORT_SYMBOL_GPL(xdp_rxq_info_unreg_mem_model);
 
@@ -368,6 +370,30 @@ int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
 
 EXPORT_SYMBOL_GPL(xdp_rxq_info_reg_mem_model);
 
+/**
+ * xdp_rxq_info_reg_ext_sinfo - keep the shared info of buffers in the queue
+ * @xdp_rxq: registered RX queue
+ *
+ * For buffers in memory that someone outside the kernel may write: those
+ * with %XDP_FLAGS_SINFO_EXT keep their shared info in kernel memory of
+ * @xdp_rxq instead of at the end of their frame.
+ * xdp_rxq_info_unreg_mem_model() frees it.
+ *
+ * Return: 0 on success, or a negative errno.
+ */
+int xdp_rxq_info_reg_ext_sinfo(struct xdp_rxq_info *xdp_rxq)
+{
+	if (xdp_rxq->reg_state != REG_STATE_REGISTERED) {
+		WARN(1, "Missing register, driver bug");
+		return -EFAULT;
+	}
+
+	if (!xdp_rxq->ext_sinfo)
+		xdp_rxq->ext_sinfo = kzalloc_obj(*xdp_rxq->ext_sinfo);
+	return xdp_rxq->ext_sinfo ? 0 : -ENOMEM;
+}
+EXPORT_SYMBOL_GPL(xdp_rxq_info_reg_ext_sinfo);
+
 /**
  * xdp_reg_page_pool - register &page_pool as a memory provider for XDP
  * @pool: &page_pool to register
@@ -638,6 +664,10 @@ struct sk_buff *xdp_build_skb_from_buff(const struct xdp_buff *xdp)
 	u32 nr_frags = 0;
 	int metalen;
 
+	/* An skb keeps its shared info in the buffer */
+	if (unlikely(xdp->flags & XDP_FLAGS_SINFO_EXT))
+		return NULL;
+
 	if (unlikely(xdp_buff_has_frags(xdp))) {
 		sinfo = xdp_get_shared_info_from_buff(xdp);
 		nr_frags = sinfo->nr_frags;
-- 
2.56.1

