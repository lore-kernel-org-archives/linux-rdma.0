Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB7B3B1EE2
	for <linux-rdma@vger.kernel.org>; Sun, 19 Jul 2026 18:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784484010; cv=none; b=SQycPQ9yI5Cckc64Wvrbpi/wW1/oXAKYF4fMSDuJdf/GGLP0CyVqASj09ojA+4DBIcJZ2HfhH/MGMsEF9VmlCVBYc/fzEe6T8OqoOvM0T7b6SPcucgSh8CWVs8En9gf066ge83QahdCyYgvBGVNVmIU18aiXaJGmy1cGF0AYMa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784484010; c=relaxed/simple;
	bh=zKcST3unMT1n6mugJyCc2BBN/+rFXNV5kcDB9rOeHQs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qezzzONyyIBxWm05QM6TWAZ7Xl2S7nFhnP3Y9TV3DvXOsCLKxKd1kJLEa3F1jDqE43lgIMdcvYpIDskdBO3eXuoZeLMl66AksY5Fv2fsDFhf+T89fIqBveTWJ8umBHmLXinBwVwpw3nn3qL8GedaMalj6QeYvl8+FlvNv9z2X3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CEkWZ+lg; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CEkWZ+lg"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2ceae1ed204so70883935ad.0
        for <linux-rdma@vger.kernel.org>; Sun, 19 Jul 2026 11:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784484002; x=1785088802; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=93nCpaEZziHyTudSghuLV0J77ekvur0UGewCgMEBZ+0=;
        b=CEkWZ+lgo++ISB7LSkrV6C0dedvr8ITiVW2vH5afyQovwqomD8i+10NVCQcteixeDy
         tM4dct1qgJoyehVIF0kLafas9HnAt7i6m9mnje952NJsSCaZ29d1qgCGBubP1gCPe2OC
         EUGbcLiwdCWQtykJvS/jlsXdQNq360YRZ9EECpm7RCYhnuVjcisGTP2QlrI745wMe1dG
         /VK6EVW94T73uI07D16ipCObjNL5wvSUlqV8g7d+707yecoAVcC/tIPAhXUMEp0/ejuW
         aHY4tZshinDuPBMcYkgtpprrXDE2bbsfZRpINWVS7bM386T7NisZyoEqPSOrZK1hP4h4
         DzTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784484002; x=1785088802;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=93nCpaEZziHyTudSghuLV0J77ekvur0UGewCgMEBZ+0=;
        b=bWwVTJ5qja+XHFh/TrqRQngfjjcZ/G3hw2kNwZrzvL7nODcxX7Ek8h5HCKZNfvCy99
         00AIm01+qlC8V7kfib/1MhEjn9gxD4amW0hv39XNRfyDW3tBf+zqw0O1lDplkWjR/tud
         E6SxpAn7y1FqVa1TLFez/AKtBBYsGMX/U+X7gh5v75hsXzX44mV2Ez8xxbpG7mgzK3fV
         Z3eXXUWUqc7NxaEGrDhKeoqkyboqIDEp63/dCTi/MGFQeZa7K1mRmat80mm/yK/SM6pg
         VGzKoINHoNGkxHcGkgW31z9ZVcC5mtTyw7kgqIsD/ytxDxzKFjguWOClgyJADfn9qQ4D
         Nz0w==
X-Forwarded-Encrypted: i=1; AHgh+RrMRj6mFkovqlwtQRZSoU9RMn0xwUQiFK2RlI0Idd71AVQIkRiPZMl4+VEJQl4zg3chigpfY0CGH1BX@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3sq49vvb/j71UgpH+XeJ+F5f3EGPTqi+a9/uUXPIpNH5Vikrq
	qMKJobMonykJLrj7pxEeYhxb/MhWnfZrdBuUNSCQu99j9UtbUKT1pK/I
X-Gm-Gg: AfdE7cm+2usi+luGRcaD33bb3I4YlR72prGIF/lzgtxd/qXwOrWyB6W8TjWY44qaMGO
	fXuc3Vtdwuy5uvATivz3a+Fs79rjhCBDx2r97N4mlj4nhi10lOejJdxo8fDdfjDX7SuC1s/siI/
	pXUsYA9HE+ImCwFguRx2RfIUCL/LF4JHApvPFyPsXR2z53lQjPivs5Wu16LWTMFzW5Ohq7ta9IH
	zhqpEad+qkwDbnN0XDi6r+3hf5JY5dCiNxiANa01heCZ8ufNFW29/TlvGY4M6fNNpMmePDXiFWi
	mfPZdCQCsBwMkR0hpYUiYbE3klKycyb7DbZFxMAvTcCSFnXDDWQrB33Nd/79NanQ0a/fMT/teXT
	GGIufWRYs/I3uSB2li7j9BMz2+AUSVxiA3wMeTRh3DhYJSfCJNY6XcOP9mLi4U/Tr2A==
X-Received: by 2002:a17:903:46ce:b0:2ca:b300:43b7 with SMTP id d9443c01a7336-2cf348507f5mr113252025ad.4.1784484001910;
        Sun, 19 Jul 2026 11:00:01 -0700 (PDT)
Received: from ap.. ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf34769bd6sm43511065ad.74.2026.07.19.10.59.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 11:00:01 -0700 (PDT)
From: Taehee Yoo <ap420073@gmail.com>
To: Alex Deucher <alexander.deucher@amd.com>,
	Alexei Starovoitov <ast@kernel.org>,
	amd-gfx@lists.freedesktop.org,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Andrii Nakryiko <andrii@kernel.org>,
	Bill Wendling <morbo@google.com>,
	bpf@vger.kernel.org,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	David Airlie <airlied@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Donald Hunter <donald.hunter@gmail.com>,
	dri-devel@lists.freedesktop.org,
	Eduard Zingerman <eddyz87@gmail.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Eric Dumazet <edumazet@google.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Hoyeon Lee <hoyeon.rhee@gmail.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Justin Stitt <justinstitt@google.com>,
	Kees Cook <kees@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	linaro-mm-sig@lists.linaro.org,
	linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-media@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	llvm@lists.linux.dev,
	Mark Bloch <mbloch@nvidia.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Michael Chan <michael.chan@broadcom.com>,
	Nathan Chancellor <nathan@kernel.org>,
	netdev@vger.kernel.org,
	Nick Desaulniers <ndesaulniers@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Shuah Khan <shuah@kernel.org>,
	Simona Vetter <simona@ffwll.ch>,
	Simon Horman <horms@kernel.org>,
	Song Liu <song@kernel.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Taehee Yoo <ap420073@gmail.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Yonghong Song <yonghong.song@linux.dev>
Subject: [RFC PATCH net-next 02/13] net: devmem: extend memory provider for knod
Date: Sun, 19 Jul 2026 17:58:46 +0000
Message-ID: <20260719175857.4071636-3-ap420073@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260719175857.4071636-1-ap420073@gmail.com>
References: <20260719175857.4071636-1-ap420073@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Extend the devmem memory-provider path so a knod accelerator can back a
NIC page_pool with accelerator-exported memory (dma-buf), letting the
NIC DMA received packets directly into accelerator memory.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
(cherry picked from commit d511a8cb3e229f8f5cf060985880d45bd384db87)
---
 include/net/devmem.h                    |  58 +++++++++++++
 include/net/netmem.h                    |   9 +++
 include/net/page_pool/memory_provider.h |   4 +
 include/net/page_pool/types.h           |  23 +++++-
 net/core/devmem.c                       | 103 +++++++++++++++++++-----
 net/core/devmem.h                       |   7 +-
 net/core/page_pool.c                    |  22 ++++-
 7 files changed, 198 insertions(+), 28 deletions(-)
 create mode 100644 include/net/devmem.h

diff --git a/include/net/devmem.h b/include/net/devmem.h
new file mode 100644
index 000000000000..f1c3895d7833
--- /dev/null
+++ b/include/net/devmem.h
@@ -0,0 +1,58 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Device memory TCP support
+ *
+ * Authors:	Mina Almasry <almasrymina@google.com>
+ *		Willem de Bruijn <willemb@google.com>
+ *		Kaiyuan Zhang <kaiyuanz@google.com>
+ *
+ */
+#ifndef _NET_DEVMEM_H
+#define _NET_DEVMEM_H
+
+#include <linux/dma-direction.h>
+#include <linux/err.h>
+#include <linux/types.h>
+
+struct device;
+struct dma_buf;
+struct dma_buf_attach_ops;
+struct net_device;
+struct net_devmem_dmabuf_binding;
+struct netlink_ext_ack;
+
+#if defined(CONFIG_NET_DEVMEM)
+struct net_devmem_dmabuf_binding *
+__net_devmem_binding_create(struct net_device *dev, struct device *dma_dev,
+			    struct dma_buf *dmabuf,
+			    enum dma_data_direction direction,
+			    const struct dma_buf_attach_ops *importer_ops,
+			    struct netlink_ext_ack *extack);
+int net_devmem_bind_dmabuf_to_queue_direct(struct net_device *dev, u32 rxq_idx,
+					   struct net_devmem_dmabuf_binding *binding);
+void net_devmem_unbind_dmabuf_direct(struct net_devmem_dmabuf_binding *binding);
+#else
+static inline struct net_devmem_dmabuf_binding *
+__net_devmem_binding_create(struct net_device *dev, struct device *dma_dev,
+			    struct dma_buf *dmabuf,
+			    enum dma_data_direction direction,
+			    const struct dma_buf_attach_ops *importer_ops,
+			    struct netlink_ext_ack *extack)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
+static inline int
+net_devmem_bind_dmabuf_to_queue_direct(struct net_device *dev, u32 rxq_idx,
+				       struct net_devmem_dmabuf_binding *binding)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void
+net_devmem_unbind_dmabuf_direct(struct net_devmem_dmabuf_binding *binding)
+{
+}
+#endif
+
+#endif /* _NET_DEVMEM_H */
diff --git a/include/net/netmem.h b/include/net/netmem.h
index bccacd21b6c3..3ddfbd37500f 100644
--- a/include/net/netmem.h
+++ b/include/net/netmem.h
@@ -127,6 +127,15 @@ static inline void net_iov_init(struct net_iov *niov,
 	niov->type = type;
 }
 
+/* Global page index within the dma-buf, accounting for multi-chunk
+ * scatter-gather layouts where each chunk owner's niovs start at 0.
+ */
+static inline unsigned int net_iov_binding_idx(const struct net_iov *niov)
+{
+	return (net_iov_owner(niov)->base_virtual >> PAGE_SHIFT) +
+	       net_iov_idx(niov);
+}
+
 /* netmem */
 
 /**
diff --git a/include/net/page_pool/memory_provider.h b/include/net/page_pool/memory_provider.h
index 255ce4cfd975..4b58a9702fb7 100644
--- a/include/net/page_pool/memory_provider.h
+++ b/include/net/page_pool/memory_provider.h
@@ -23,6 +23,10 @@ bool net_mp_niov_set_dma_addr(struct net_iov *niov, dma_addr_t addr);
 void net_mp_niov_set_page_pool(struct page_pool *pool, struct net_iov *niov);
 void net_mp_niov_clear_page_pool(struct net_iov *niov);
 
+void page_pool_provider_set_netmem(struct page_pool *pool, netmem_ref netmem,
+				   dma_addr_t addr);
+void page_pool_clear_pp_info(netmem_ref netmem);
+
 int netif_mp_open_rxq(struct net_device *dev, unsigned int rxq_idx,
 		      const struct pp_memory_provider_params *p,
 		      struct netlink_ext_ack *extack);
diff --git a/include/net/page_pool/types.h b/include/net/page_pool/types.h
index 03da138722f5..3e866f249768 100644
--- a/include/net/page_pool/types.h
+++ b/include/net/page_pool/types.h
@@ -31,8 +31,16 @@
  */
 #define PP_FLAG_ALLOW_UNREADABLE_NETMEM BIT(3)
 
+/* Driver-managed pool with a directly-supplied memory provider, not bound to a
+ * netdev rx queue. Setting this flag requires page_pool_params.mp_ops and
+ * .mp_priv to both be set.
+ */
+#define PP_FLAG_CUSTOM_MEMORY_PROVIDER	BIT(4)
+
 #define PP_FLAG_ALL		(PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV | \
-				 PP_FLAG_SYSTEM_POOL | PP_FLAG_ALLOW_UNREADABLE_NETMEM)
+				 PP_FLAG_SYSTEM_POOL | \
+				 PP_FLAG_ALLOW_UNREADABLE_NETMEM | \
+				 PP_FLAG_CUSTOM_MEMORY_PROVIDER)
 
 /* Index limit to stay within PP_DMA_INDEX_BITS for DMA indices */
 #define PP_DMA_INDEX_LIMIT XA_LIMIT(1, BIT(PP_DMA_INDEX_BITS) - 1)
@@ -54,11 +62,11 @@
  * would have to take a slower code path.
  */
 #if PAGE_SIZE >= SZ_64K
-#define PP_ALLOC_CACHE_REFILL	4
+#define PP_ALLOC_CACHE_REFILL	256
 #elif PAGE_SIZE >= SZ_16K
-#define PP_ALLOC_CACHE_REFILL	16
+#define PP_ALLOC_CACHE_REFILL	1024
 #else
-#define PP_ALLOC_CACHE_REFILL	64
+#define PP_ALLOC_CACHE_REFILL	4096
 #endif
 
 #define PP_ALLOC_CACHE_SIZE	(PP_ALLOC_CACHE_REFILL * 2)
@@ -67,6 +75,8 @@ struct pp_alloc_cache {
 	netmem_ref cache[PP_ALLOC_CACHE_SIZE];
 };
 
+struct memory_provider_ops;
+
 /**
  * struct page_pool_params - page pool parameters
  * @fast:	params accessed frequently on hotpath
@@ -83,6 +93,9 @@ struct pp_alloc_cache {
  * @queue_idx:	queue idx this page_pool is being created for.
  * @flags:	PP_FLAG_DMA_MAP, PP_FLAG_DMA_SYNC_DEV, PP_FLAG_SYSTEM_POOL,
  *		PP_FLAG_ALLOW_UNREADABLE_NETMEM.
+ * @mp_ops:	driver-supplied memory provider for a pool not bound to a
+ *		netdev rx queue (NULL to use rxq->mp_params instead)
+ * @mp_priv:	context passed to @mp_ops
  */
 struct page_pool_params {
 	struct_group_tagged(page_pool_params_fast, fast,
@@ -99,6 +112,8 @@ struct page_pool_params {
 		struct net_device *netdev;
 		unsigned int queue_idx;
 		unsigned int	flags;
+		const struct memory_provider_ops *mp_ops;
+		void *mp_priv;
 /* private: used by test code only */
 		void (*init_callback)(netmem_ref netmem, void *arg);
 		void *init_arg;
diff --git a/net/core/devmem.c b/net/core/devmem.c
index 957d6b96216b..9e21cffc9643 100644
--- a/net/core/devmem.c
+++ b/net/core/devmem.c
@@ -121,12 +121,9 @@ void net_devmem_free_dmabuf(struct net_iov *niov)
 	gen_pool_free(binding->chunk_pool, dma_addr, PAGE_SIZE);
 }
 
-void net_devmem_unbind_dmabuf(struct net_devmem_dmabuf_binding *binding)
+static void
+net_devmem_binding_unpublish(struct net_devmem_dmabuf_binding *binding)
 {
-	struct netdev_rx_queue *rxq;
-	unsigned long xa_idx;
-	unsigned int rxq_idx;
-
 	xa_erase(&net_devmem_dmabuf_bindings, binding->id);
 
 	/* Ensure no tx net_devmem_lookup_dmabuf() are in flight after the
@@ -136,6 +133,15 @@ void net_devmem_unbind_dmabuf(struct net_devmem_dmabuf_binding *binding)
 
 	if (binding->list.next)
 		list_del(&binding->list);
+}
+
+void net_devmem_unbind_dmabuf(struct net_devmem_dmabuf_binding *binding)
+{
+	struct netdev_rx_queue *rxq;
+	unsigned long xa_idx;
+	unsigned int rxq_idx;
+
+	net_devmem_binding_unpublish(binding);
 
 	xa_for_each(&binding->bound_rxqs, xa_idx, rxq) {
 		const struct pp_memory_provider_params mp_params = {
@@ -151,6 +157,47 @@ void net_devmem_unbind_dmabuf(struct net_devmem_dmabuf_binding *binding)
 	percpu_ref_kill(&binding->ref);
 }
 
+/* Bind/unbind variants for in-kernel offload importers that drive the rx
+ * queue lifecycle themselves. The mp_params are poked directly, without the
+ * tcp-data-split/XDP guards or the queue reconfigure that the netlink control
+ * plane applies through netif_mp_open_rxq()/netif_mp_close_rxq().
+ */
+int net_devmem_bind_dmabuf_to_queue_direct(struct net_device *dev, u32 rxq_idx,
+					   struct net_devmem_dmabuf_binding *binding)
+{
+	struct netdev_rx_queue *rxq;
+	u32 xa_idx;
+	int err;
+
+	rxq = __netif_get_rx_queue(dev, rxq_idx);
+	rxq->mp_params.mp_priv = binding;
+	rxq->mp_params.mp_ops = &dmabuf_devmem_ops;
+
+	err = xa_alloc(&binding->bound_rxqs, &xa_idx, rxq, xa_limit_32b,
+		       GFP_KERNEL);
+	if (err) {
+		rxq->mp_params.mp_priv = NULL;
+		rxq->mp_params.mp_ops = NULL;
+	}
+
+	return err;
+}
+
+void net_devmem_unbind_dmabuf_direct(struct net_devmem_dmabuf_binding *binding)
+{
+	struct netdev_rx_queue *rxq;
+	unsigned long xa_idx;
+
+	net_devmem_binding_unpublish(binding);
+
+	xa_for_each(&binding->bound_rxqs, xa_idx, rxq) {
+		rxq->mp_params.mp_priv = NULL;
+		rxq->mp_params.mp_ops = NULL;
+	}
+
+	percpu_ref_kill(&binding->ref);
+}
+
 int net_devmem_bind_dmabuf_to_queue(struct net_device *dev, u32 rxq_idx,
 				    struct net_devmem_dmabuf_binding *binding,
 				    struct netlink_ext_ack *extack)
@@ -188,12 +235,7 @@ net_devmem_bind_dmabuf(struct net_device *dev, void *vdev,
 		       struct netlink_ext_ack *extack)
 {
 	struct net_devmem_dmabuf_binding *binding;
-	static u32 id_alloc_next;
-	struct scatterlist *sg;
 	struct dma_buf *dmabuf;
-	unsigned int sg_idx, i;
-	unsigned long virtual;
-	int err;
 
 	if (!dma_dev) {
 		NL_SET_ERR_MSG(extack, "Device doesn't support DMA");
@@ -204,15 +246,39 @@ net_devmem_bind_dmabuf(struct net_device *dev, void *vdev,
 	if (IS_ERR(dmabuf))
 		return ERR_CAST(dmabuf);
 
+	binding = __net_devmem_binding_create(dev, dma_dev, dmabuf, direction,
+					      NULL, extack);
+	if (IS_ERR(binding)) {
+		dma_buf_put(dmabuf);
+		return binding;
+	}
+
+	binding->vdev = vdev;
+	list_add(&binding->list, &priv->bindings);
+
+	return binding;
+}
+
+struct net_devmem_dmabuf_binding *
+__net_devmem_binding_create(struct net_device *dev, struct device *dma_dev,
+			    struct dma_buf *dmabuf,
+			    enum dma_data_direction direction,
+			    const struct dma_buf_attach_ops *importer_ops,
+			    struct netlink_ext_ack *extack)
+{
+	struct net_devmem_dmabuf_binding *binding;
+	static u32 id_alloc_next;
+	struct scatterlist *sg;
+	unsigned int sg_idx, i;
+	unsigned long virtual;
+	int err;
+
 	binding = kzalloc_node(sizeof(*binding), GFP_KERNEL,
 			       dev_to_node(&dev->dev));
-	if (!binding) {
-		err = -ENOMEM;
-		goto err_put_dmabuf;
-	}
+	if (!binding)
+		return ERR_PTR(-ENOMEM);
 
 	binding->dev = dev;
-	binding->vdev = vdev;
 	xa_init_flags(&binding->bound_rxqs, XA_FLAGS_ALLOC);
 
 	err = percpu_ref_init(&binding->ref,
@@ -226,7 +292,8 @@ net_devmem_bind_dmabuf(struct net_device *dev, void *vdev,
 	binding->dmabuf = dmabuf;
 	binding->direction = direction;
 
-	binding->attachment = dma_buf_attach(binding->dmabuf, dma_dev);
+	binding->attachment = dma_buf_dynamic_attach(binding->dmabuf, dma_dev,
+						     importer_ops, binding);
 	if (IS_ERR(binding->attachment)) {
 		err = PTR_ERR(binding->attachment);
 		NL_SET_ERR_MSG(extack, "Failed to bind dmabuf to device");
@@ -325,8 +392,6 @@ net_devmem_bind_dmabuf(struct net_device *dev, void *vdev,
 	if (err < 0)
 		goto err_free_chunks;
 
-	list_add(&binding->list, &priv->bindings);
-
 	return binding;
 
 err_free_chunks:
@@ -344,8 +409,6 @@ net_devmem_bind_dmabuf(struct net_device *dev, void *vdev,
 	percpu_ref_exit(&binding->ref);
 err_free_binding:
 	kfree(binding);
-err_put_dmabuf:
-	dma_buf_put(dmabuf);
 	return ERR_PTR(err);
 }
 
diff --git a/net/core/devmem.h b/net/core/devmem.h
index 3852a56036cb..6b57837ab454 100644
--- a/net/core/devmem.h
+++ b/net/core/devmem.h
@@ -7,9 +7,10 @@
  *		Kaiyuan Zhang <kaiyuanz@google.com>
  *
  */
-#ifndef _NET_DEVMEM_H
-#define _NET_DEVMEM_H
+#ifndef _NET_CORE_DEVMEM_H
+#define _NET_CORE_DEVMEM_H
 
+#include <net/devmem.h>
 #include <net/netmem.h>
 #include <net/netdev_netlink.h>
 
@@ -240,4 +241,4 @@ net_devmem_iov_binding(const struct net_iov *niov)
 }
 #endif
 
-#endif /* _NET_DEVMEM_H */
+#endif /* _NET_CORE_DEVMEM_H */
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 21dc4a9c8714..fd7444943b9f 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -272,7 +272,17 @@ static int page_pool_init(struct page_pool *pool,
 
 	xa_init_flags(&pool->dma_mapped, XA_FLAGS_ALLOC1);
 
-	if (pool->slow.flags & PP_FLAG_ALLOW_UNREADABLE_NETMEM) {
+	if (pool->slow.flags & PP_FLAG_CUSTOM_MEMORY_PROVIDER) {
+		/* Driver-managed pool with a directly-supplied memory
+		 * provider, not bound to a netdev rx queue.
+		 */
+		if (WARN_ON(!pool->slow.mp_ops || !pool->slow.mp_priv)) {
+			err = -EINVAL;
+			goto free_ptr_ring;
+		}
+		pool->mp_priv = pool->slow.mp_priv;
+		pool->mp_ops = pool->slow.mp_ops;
+	} else if (pool->slow.flags & PP_FLAG_ALLOW_UNREADABLE_NETMEM) {
 		netdev_assert_locked(pool->slow.netdev);
 		rxq = __netif_get_rx_queue(pool->slow.netdev,
 					   pool->slow.queue_idx);
@@ -725,6 +735,16 @@ void page_pool_clear_pp_info(netmem_ref netmem)
 	netmem_set_pp(netmem, NULL);
 }
 
+void page_pool_provider_set_netmem(struct page_pool *pool, netmem_ref netmem,
+				   dma_addr_t addr)
+{
+	netmem_to_nmdesc(netmem)->pp_magic = 0;
+	netmem_to_nmdesc(netmem)->pp = NULL;
+	atomic_long_set(&netmem_to_nmdesc(netmem)->pp_ref_count, 0);
+	page_pool_set_pp_info(pool, netmem);
+	page_pool_set_dma_addr_netmem(netmem, addr);
+}
+
 static __always_inline void __page_pool_release_netmem_dma(struct page_pool *pool,
 							   netmem_ref netmem)
 {
-- 
2.43.0

