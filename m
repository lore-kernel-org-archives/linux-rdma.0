Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795525156;
	b=ZXc+taxytxiibw0VSyI2rAFKX+GNXaB6sQ19FL0ZaZ9MYZHctoWGMvt7vM9ubSfGsGIn
	 wUZIpwrjDEPND+PiCqxUeJst+5ntFKuplaINy33uO8jL79Ye7L6JgoX8nL08ZWXeXfl59
	 5/zqxUDCoDkccWPcf5UziltARioSSRDo3kkrObLOwg+uTPJ94m+fjTJzy2s2DP0j+atWf
	 qr0lWTDdfIExlFoXYIgaYgxXH0KaTRlCKtGisH2PNVXoZyLUHuC6sy8u/8nJzhzEK6rP/
	 Y/bsnOHOslodbL28wkSW5cmH5pGymmU+JkymyQFzU8Hb1H/4XVbqn2ugeO5eXIj3EFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795525156;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=LA1pnI8aeeYlz5Y+3GA+5FCYedjmJ9wlZv/anfHcgGI=;
	b=2bhNGE6532ZTQwDWvBLDMi10dV5rdj9/pDarRe74HXhcUz8Pj6ocO5l8snSFLN6V+B5E
	 u1elXNMNj/zOttpcC3vkUZriJeceufem2EkLjEspGxDKsYCezuQYRJOf6/DiXkGcFUqiy
	 mVeRuHDwBwjQibtz8iZpVrza3YFxtId/vHqPHs5NB+Qd+EUK4OJ+DfW2DEqc/sGk6lR0c
	 U/XjkhMOD3Mro/4ke2QiudxwENvhStAennPG6FiRPI2LlDVfMA0ifsK/bwm/ebjnUllZH
	 QbwVdLyrRy+kiqW5HuVSdLb6MwwzXvevgCfxqQE+zWbV0NFo+uzdqNp4TrpG32G3zgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h03Sjxum;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49889606A31E;
	Tue, 24 Nov 2026 12:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h03Sjxum
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78F431F000C0;
	Tue, 24 Nov 2026 12:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795525155;
	bh=LA1pnI8aeeYlz5Y+3GA+5FCYedjmJ9wlZv/anfHcgGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h03SjxumTxIqMg65F7MX2PyEtjRQ2rVLMzNU5UrAP2yer4y6cqZf5xBPTB/mpq+zo
	 Smp5n7RXcH57JyZkf8jusqDiw3xxgNKUW/YJl+cWgBAVE4IcYLkhwXL+qj+NQQe36U
	 YuSz5dkdHiSt6302VxO2u2O0X47CFEQJnYeFRTOdX99p6em5xIdz56eH8jKZdYAGY2
	 S1C1ulZpOEAKbl0ZHij578yzJU+B16ZWz98UaHD3tIdVfmjEm8ytHDXyGm8R2+8qoQ
	 CmAgPtC4q/AalqgOAoF7hOetzJ3+Q9rMSW/AQzpjmJR0gSZLiy1zEf8r5dnGjSvtDg
	 gdzmDHYkVX+vg==
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
Subject: [PATCH net-next 11/15] net: Add netif_rxq_has_xdp_only_mp()
Date: Tue, 24 Nov 2026 13:56:46 +0100
Message-ID: <20261124125654.183091-11-bjorn@kernel.org>
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

A driver lays out an RX queue before it creates the page pools of that
queue, so it cannot ask a pool whether a memory provider backs it, and
a layout that depends on the provider has nothing to read.

Tell the driver from the queue. Return whether the provider of an RX
queue is XDP-only, which the next patch uses to keep an mlx5 queue
from waiting for buffers that its socket has not lent yet.

Page pools of a queue are created under the instance lock, which the
caller holds as well, so the answer agrees with the pools of that
queue. A queue index past the device's RX queues has no provider.

Signed-off-by: Björn Töpel <bjorn@kernel.org>
---
 include/net/netdev_queues.h |  1 +
 net/core/netdev_rx_queue.c  | 25 +++++++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/include/net/netdev_queues.h b/include/net/netdev_queues.h
index c5335e935b7d..813388778797 100644
--- a/include/net/netdev_queues.h
+++ b/include/net/netdev_queues.h
@@ -235,6 +235,7 @@ void netdev_queue_config(struct net_device *dev, int rxq,
 			 struct netdev_queue_config *qcfg);
 
 bool netif_rxq_has_unreadable_mp(struct net_device *dev, unsigned int rxq_idx);
+bool netif_rxq_has_xdp_only_mp(struct net_device *dev, unsigned int rxq_idx);
 
 /**
  * DOC: Lockless queue stopping / waking helpers.
diff --git a/net/core/netdev_rx_queue.c b/net/core/netdev_rx_queue.c
index 2e10201fc0c0..212f1b9415b3 100644
--- a/net/core/netdev_rx_queue.c
+++ b/net/core/netdev_rx_queue.c
@@ -94,6 +94,31 @@ bool netif_rxq_has_unreadable_mp(struct net_device *dev, unsigned int rxq_idx)
 }
 EXPORT_SYMBOL(netif_rxq_has_unreadable_mp);
 
+/**
+ * netif_rxq_has_xdp_only_mp() - whether an XDP-only provider backs an RX queue
+ * @dev: device of the queue
+ * @rxq_idx: RX queue of @dev itself, not of a lease
+ *
+ * The page pools of the queue that allow it take the provider, see
+ * %PP_FLAG_ALLOW_XDP_ONLY_NETMEM. They are created under the instance lock,
+ * which the caller holds, so they agree with the answer.
+ *
+ * Return: true if the queue has a provider with %MP_XDP_ONLY.
+ */
+bool netif_rxq_has_xdp_only_mp(struct net_device *dev, unsigned int rxq_idx)
+{
+	const struct memory_provider_ops *ops;
+
+	netdev_assert_locked(dev);
+
+	if (rxq_idx >= dev->real_num_rx_queues)
+		return false;
+
+	ops = __netif_get_rx_queue(dev, rxq_idx)->mp_params.mp_ops;
+	return ops && ops->flags & MP_XDP_ONLY;
+}
+EXPORT_SYMBOL(netif_rxq_has_xdp_only_mp);
+
 bool netif_rxq_has_mp(struct net_device *dev, unsigned int rxq_idx)
 {
 	if (rxq_idx < dev->real_num_rx_queues)
-- 
2.56.1

