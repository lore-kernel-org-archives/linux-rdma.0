Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795525060;
	b=1tGcnqGPRGfWEJmal7R53NUXN5eb9rXDmwmu/vXjRQ33K1j2v7ShcllCrUUr7QfQMptF
	 8lKvWZeeeYWX2bTbHkY7SugVByt/gbDXblCaTuLtUTb/u10AbGyVRly5x/tKIWFh/FuNx
	 EjlxprJE3p0PwYETtgWd8k+3tu2ab/NtRsu18HJ3Eb0IrKBhklOFj8x1bA7zMMxj2HiNc
	 0ei0LLxj4a8Z7Cxmm9lxbz53maTMEflRIDNzwH0f8F4k6W3oMh7cdPFCwA8RToHiO+sao
	 Fv9UdkG/Nbe0CF1PkCv9OBEEJmwasl5MDQKHvyB2FMPdpf6IBAnLdPN6uudmWHSYAFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795525060;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=0GkGumznK8zhV0Gw0dp3yzsRLkfuWDaqwwEMireqoHU=;
	b=aXGGyEZHjI1pciSElWW+UHhJJxjbnS4kdyjgA3XIExe0Sj6yqewL+2ZIh6o4hcxr2RjK
	 Nh+D4usMUeRR/99u79Gbnf7WdA2Z0iK6EWfjWvy2aYxjuZ4M1ZXtZCT+aPTvXZ5vhNVNi
	 Gu7YZKIa30aLwxDC41OoBRDEkCJFZmESKetQ8j77a6t8AWNkm7Yoj+/csm1a2MUtT8eCB
	 +l2h5vzrm4VM4OPmvxJAccwW/FEuWC4h/Fgi3YwrMw5ojlZzWwl2APTmrgAM2KuO9WYKS
	 YBxQBiwzmrEkCFZhLS4qG8DFPqV269E+IS4ch8M9BEjfi76QgqF2y5OgZM7orwQGM/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m1tVWb1Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BDF9606A32D;
	Tue, 24 Nov 2026 12:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m1tVWb1Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79DB01F000C6;
	Tue, 24 Nov 2026 12:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795525059;
	bh=0GkGumznK8zhV0Gw0dp3yzsRLkfuWDaqwwEMireqoHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m1tVWb1YlZPAg9vs/5tWLbU52TsmcsgTwZKGmKlHIhohsJo4cT2fhBVARxIueoiHy
	 oHtJ8ip8i46BMF7FOEjdKdIRBV8NmXXzRZETMzrsYJhzKawvs1NxHAFest09dajz0o
	 ZSsl4bJbUDcY19R3Etz+rpk9UK4VWrDNIIkwxnfIBO47rWPiPMfSaiBpLKPK5nvHUm
	 q+LDRpjJ/txT8798hH5MDxRISZzjyW/QHen/tZcbyMxTj1cXTFfJOUjFZnp1D+vf92
	 M5L3Ah6T5zhp8jVOQb+tgBcU0C4Rxerv5CiOKzSuXNxpQMENVNK1pyqabUxPI8odzC
	 bOyLvSXbN2nvA==
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
Subject: [PATCH net-next 03/15] net: Add memory providers that only feed XDP
Date: Tue, 24 Nov 2026 13:56:38 +0100
Message-ID: <20261124125654.183091-3-bjorn@kernel.org>
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

Currently, memory providers serve the payload of a header-split queue
to the stack. The core requires tcp-data-split with a zero threshold
for them, and refuses native XDP next to them. An AF_XDP socket that
receives in the device's buffer layout, later in this series, needs a
provider whose buffers go only to XDP, never to the stack. It backs
every RX page pool of the queue, so that the device places packets as
it does in pages, and native XDP must run to steer the packets.

Let a provider declare itself XDP-only with MP_XDP_ONLY, and spare it
the checks that only make sense for payload providers.

An XDP-only provider needs no header split and does not block native
XDP. A page pool takes an XDP-only provider only if the driver opts in
with PP_FLAG_ALLOW_XDP_ONLY_NETMEM. Otherwise installing the provider
fails, as for other providers, so neither a driver that did not opt in
nor a pool that takes unreadable memory gets XDP-only memory by
accident.

Like any provider, an XDP-only one is unreadable to
page_pool_is_unreadable(), as the core and the stack never read its
memory. netif_rxq_has_unreadable_mp(), which drivers use to turn on
header split, leaves XDP-only providers out, as they back the headers
too and header split would only spread packets over more buffers.
Userspace may write the buffers at any time, so the kernel must keep
its own data out of them, which the next patches do.

Signed-off-by: Björn Töpel <bjorn@kernel.org>
---
 include/linux/netdevice.h               |  1 +
 include/net/page_pool/memory_provider.h | 15 ++++++++++++++
 include/net/page_pool/types.h           | 14 +++++++++++--
 net/core/dev.c                          | 21 ++++++++++++++++++--
 net/core/netdev_rx_queue.c              | 26 +++++++++++++++++--------
 net/core/page_pool.c                    | 16 ++++++++++++---
 net/ethtool/rings.c                     |  5 ++++-
 7 files changed, 82 insertions(+), 16 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 0325c6f2a7d1..5fd2bec1178a 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4458,6 +4458,7 @@ u8 dev_xdp_sb_prog_count(struct net_device *dev);
 u32 dev_xdp_prog_id(struct net_device *dev, enum bpf_xdp_mode mode);
 
 u32 dev_get_min_mp_channel_count(const struct net_device *dev);
+bool dev_mp_blocks_xdp(const struct net_device *dev);
 
 int __dev_forward_skb(struct net_device *dev, struct sk_buff *skb);
 int dev_forward_skb(struct net_device *dev, struct sk_buff *skb);
diff --git a/include/net/page_pool/memory_provider.h b/include/net/page_pool/memory_provider.h
index bceb5f7740e2..d52c7a450c68 100644
--- a/include/net/page_pool/memory_provider.h
+++ b/include/net/page_pool/memory_provider.h
@@ -19,6 +19,20 @@ struct sk_buff;
  * Per-provider custom logic must be delegated to memory_provider_ops rather
  * than handled directly in page_pool core code.
  */
+
+/**
+ * enum mp_flags - how a memory provider differs from the default
+ * @MP_XDP_ONLY: Only XDP consumes the buffers: they never reach the stack.
+ *	They back the RX page pools of the queue that set
+ *	%PP_FLAG_ALLOW_XDP_ONLY_NETMEM, so header split is not needed, and
+ *	native XDP may run next to them.
+ *	XDP may read them, but userspace may write them at any time,
+ *	so the kernel must keep its own data out of them.
+ */
+enum mp_flags {
+	MP_XDP_ONLY		= BIT(0),
+};
+
 struct memory_provider_ops {
 	netmem_ref (*alloc_netmems)(struct page_pool *pool, gfp_t gfp);
 	bool (*release_netmem)(struct page_pool *pool, netmem_ref netmem);
@@ -27,6 +41,7 @@ struct memory_provider_ops {
 	int (*nl_fill)(void *mp_priv, struct sk_buff *rsp,
 		       struct netdev_rx_queue *rxq);
 	void (*uninstall)(void *mp_priv, struct netdev_rx_queue *rxq);
+	u32 flags;
 };
 
 bool net_mp_niov_set_dma_addr(struct net_iov *niov, dma_addr_t addr);
diff --git a/include/net/page_pool/types.h b/include/net/page_pool/types.h
index 6d543076a0c0..35d4dc45db6a 100644
--- a/include/net/page_pool/types.h
+++ b/include/net/page_pool/types.h
@@ -31,8 +31,18 @@
  */
 #define PP_FLAG_ALLOW_UNREADABLE_NETMEM BIT(3)
 
+/*
+ * Allow an XDP-only memory provider of the queue (%MP_XDP_ONLY) to back the
+ * pool. The driver registers the pool as the memory model of the RX queue,
+ * sets up XDP buffers with xdp_prepare_buff() at xdp_netmem_address() of
+ * their head, and puts heads back by netmem, not by address.
+ */
+#define PP_FLAG_ALLOW_XDP_ONLY_NETMEM BIT(4)
+
 #define PP_FLAG_ALL		(PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV | \
-				 PP_FLAG_SYSTEM_POOL | PP_FLAG_ALLOW_UNREADABLE_NETMEM)
+				 PP_FLAG_SYSTEM_POOL | \
+				 PP_FLAG_ALLOW_UNREADABLE_NETMEM | \
+				 PP_FLAG_ALLOW_XDP_ONLY_NETMEM)
 
 /* Index limit to stay within PP_DMA_INDEX_BITS for DMA indices */
 #define PP_DMA_INDEX_LIMIT XA_LIMIT(1, BIT(PP_DMA_INDEX_BITS) - 1)
@@ -82,7 +92,7 @@ struct pp_alloc_cache {
  * @netdev:	netdev this pool will serve (leave as NULL if none or multiple)
  * @queue_idx:	queue idx this page_pool is being created for.
  * @flags:	PP_FLAG_DMA_MAP, PP_FLAG_DMA_SYNC_DEV, PP_FLAG_SYSTEM_POOL,
- *		PP_FLAG_ALLOW_UNREADABLE_NETMEM.
+ *		PP_FLAG_ALLOW_UNREADABLE_NETMEM, PP_FLAG_ALLOW_XDP_ONLY_NETMEM.
  */
 struct page_pool_params {
 	struct_group_tagged(page_pool_params_fast, fast,
diff --git a/net/core/dev.c b/net/core/dev.c
index 4ca8a9f5a7a5..8a1d5a284e53 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10645,7 +10645,7 @@ int netif_xdp_propagate(struct net_device *dev, struct netdev_bpf *bpf)
 			return -EBUSY;
 		}
 
-		if (dev_get_min_mp_channel_count(dev)) {
+		if (dev_mp_blocks_xdp(dev)) {
 			NL_SET_ERR_MSG(bpf->extack,
 				       "unable to propagate XDP to device using memory provider");
 			return -EBUSY;
@@ -10726,7 +10726,7 @@ static int dev_xdp_install(struct net_device *dev, enum bpf_xdp_mode mode,
 				       "unable to install XDP to device using tcp-data-split");
 			return -EBUSY;
 		}
-		if (dev_get_min_mp_channel_count(dev)) {
+		if (dev_mp_blocks_xdp(dev)) {
 			NL_SET_ERR_MSG(extack,
 				       "unable to install XDP to device using memory provider");
 			return -EBUSY;
@@ -11146,6 +11146,23 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
 	return err;
 }
 
+/* Native XDP runs next to XDP-only providers only, see %MP_XDP_ONLY */
+bool dev_mp_blocks_xdp(const struct net_device *dev)
+{
+	const struct memory_provider_ops *ops;
+	unsigned int i;
+
+	netdev_assert_locked_ops_compat(dev);
+
+	for (i = 0; i < dev->real_num_rx_queues; i++) {
+		ops = dev->_rx[i].mp_params.mp_ops;
+		if (ops && !(ops->flags & MP_XDP_ONLY))
+			return true;
+	}
+
+	return false;
+}
+
 u32 dev_get_min_mp_channel_count(const struct net_device *dev)
 {
 	int i;
diff --git a/net/core/netdev_rx_queue.c b/net/core/netdev_rx_queue.c
index a7261fedd5e7..2e10201fc0c0 100644
--- a/net/core/netdev_rx_queue.c
+++ b/net/core/netdev_rx_queue.c
@@ -79,12 +79,18 @@ __netif_get_rx_queue_lease(struct net_device **dev, unsigned int *rxq_idx,
 	return rxq;
 }
 
-/* See also page_pool_is_unreadable() */
+/* See also page_pool_is_unreadable(). An XDP-only provider backs the headers
+ * too, so its queue needs no header split, see %MP_XDP_ONLY.
+ */
 bool netif_rxq_has_unreadable_mp(struct net_device *dev, unsigned int rxq_idx)
 {
-	if (rxq_idx < dev->real_num_rx_queues)
-		return __netif_get_rx_queue(dev, rxq_idx)->mp_params.mp_ops;
-	return false;
+	const struct memory_provider_ops *ops;
+
+	if (rxq_idx >= dev->real_num_rx_queues)
+		return false;
+
+	ops = __netif_get_rx_queue(dev, rxq_idx)->mp_params.mp_ops;
+	return ops && !(ops->flags & MP_XDP_ONLY);
 }
 EXPORT_SYMBOL(netif_rxq_has_unreadable_mp);
 
@@ -189,6 +195,7 @@ static int __netif_mp_open_rxq(struct net_device *dev, unsigned int rxq_idx,
 			       struct netlink_ext_ack *extack)
 {
 	const struct netdev_queue_mgmt_ops *qops = dev->queue_mgmt_ops;
+	bool xdp_only = p->mp_ops->flags & MP_XDP_ONLY;
 	struct netdev_queue_config qcfg[2];
 	struct netdev_rx_queue *rxq;
 	int ret;
@@ -196,15 +203,17 @@ static int __netif_mp_open_rxq(struct net_device *dev, unsigned int rxq_idx,
 	if (!qops)
 		return -EOPNOTSUPP;
 
-	if (dev->cfg->hds_config != ETHTOOL_TCP_DATA_SPLIT_ENABLED) {
+	/* An XDP-only provider backs headers too, and runs next to XDP */
+	if (!xdp_only &&
+	    dev->cfg->hds_config != ETHTOOL_TCP_DATA_SPLIT_ENABLED) {
 		NL_SET_ERR_MSG(extack, "tcp-data-split is disabled");
 		return -EINVAL;
 	}
-	if (dev->cfg->hds_thresh) {
+	if (!xdp_only && dev->cfg->hds_thresh) {
 		NL_SET_ERR_MSG(extack, "hds-thresh is not zero");
 		return -EINVAL;
 	}
-	if (dev_xdp_prog_count(dev)) {
+	if (!xdp_only && dev_xdp_prog_count(dev)) {
 		NL_SET_ERR_MSG(extack, "unable to custom memory provider to device with XDP program attached");
 		return -EEXIST;
 	}
@@ -219,7 +228,8 @@ static int __netif_mp_open_rxq(struct net_device *dev, unsigned int rxq_idx,
 		return -EEXIST;
 	}
 #ifdef CONFIG_XDP_SOCKETS
-	if (rxq->pool) {
+	/* Only the AF_XDP socket of the queue installs an XDP-only provider */
+	if (rxq->pool && !xdp_only) {
 		NL_SET_ERR_MSG(extack, "designated queue already in use by AF_XDP");
 		return -EBUSY;
 	}
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index d7c88c0b67e5..8a1ea21ccdcd 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -272,12 +272,22 @@ static int page_pool_init(struct page_pool *pool,
 
 	xa_init_flags(&pool->dma_mapped, XA_FLAGS_ALLOC1);
 
-	if (pool->slow.flags & PP_FLAG_ALLOW_UNREADABLE_NETMEM) {
+	if (pool->slow.flags & (PP_FLAG_ALLOW_UNREADABLE_NETMEM |
+				PP_FLAG_ALLOW_XDP_ONLY_NETMEM)) {
+		const struct memory_provider_ops *ops;
+		u32 allow;
+
 		netdev_assert_locked(pool->slow.netdev);
 		rxq = __netif_get_rx_queue(pool->slow.netdev,
 					   pool->slow.queue_idx);
-		pool->mp_priv = rxq->mp_params.mp_priv;
-		pool->mp_ops = rxq->mp_params.mp_ops;
+		ops = rxq->mp_params.mp_ops;
+		allow = ops && ops->flags & MP_XDP_ONLY ?
+			PP_FLAG_ALLOW_XDP_ONLY_NETMEM :
+			PP_FLAG_ALLOW_UNREADABLE_NETMEM;
+		if (pool->slow.flags & allow) {
+			pool->mp_priv = rxq->mp_params.mp_priv;
+			pool->mp_ops = ops;
+		}
 	}
 
 	if (pool->mp_ops) {
diff --git a/net/ethtool/rings.c b/net/ethtool/rings.c
index e3810c0320e3..84ba17412a40 100644
--- a/net/ethtool/rings.c
+++ b/net/ethtool/rings.c
@@ -258,7 +258,10 @@ ethnl_set_rings(struct ethnl_req_info *req_info, struct genl_info *info)
 		return -EINVAL;
 	}
 
-	if (dev_get_min_mp_channel_count(dev)) {
+	/* Providers that take the payload need header split. XDP-only
+	 * providers back whole packets: they neither need it nor block XDP.
+	 */
+	if (dev_mp_blocks_xdp(dev)) {
 		if (kernel_ringparam.tcp_data_split !=
 		    ETHTOOL_TCP_DATA_SPLIT_ENABLED) {
 			NL_SET_ERR_MSG(info->extack,
-- 
2.56.1

