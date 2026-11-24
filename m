Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795525168;
	b=qrwnM8h1szCUlqeo8AAwJSUIomkhxM7woOWyi1+AThQ3bXunBrssmRjdRZMTvjDLDR1Z
	 SxwLyhM0IQHiNYJtJPzU95GchPXq5sE7HMdU6V/+p+13chJ8rLCffc8vtEofNXERBID/d
	 idWbJZZ0GeEGfgLRIrtntp8tO6mlsH3ex2gvIVSPZk69SYFKFpkmaZZOkcFA9rjDGFSM6
	 V08W8ctn1PKuvTsKfUFKy8rYYy9JxJzSKg4+eLI7ICaaJrDempSFoxOenC1Xu9PHs4qKm
	 I2Wr7xqNP/OX1pexbedCjnOXRQb1CgbxZxqp8G+P9Qz6blQ0nq01HgPa+SYkaxe4fbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795525168;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=mpEaL2qtctLQ1VscKjboptsoE3gRjQ4GB/qmT7wVR18=;
	b=I2X5yxKMUkuIZWYgLDegSDTJahmHFF4F9Yy2aozolCek1bPnCtz8ylaMJVr8UWIXvKUr
	 gQ1ujiNKVlEqxwkLDRz/a//Bh0S1CXmhO4F8el7491gWp0hrQxVqjQmktJf1fxUHNNpgp
	 r6yuH68jur8mxuzXUyYGlnixnCbzDh2nyVkcUhmjoDKzmA2jwlDHRL5t0kH/y50ghTlEM
	 84S9dVDndJwpipaXGhXvCxKYv/7l3GvWB2Q1jHTGAj2lsWKz/m26wA576hM+ZcfLLIyyV
	 xlb/3CxgsNp7STWjrmMXj38ylTxAYUIlxuVxxdgkry4K8zAwykyH9aqlQCfu+rt0XYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=boDJpr1s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75BAE606A331;
	Tue, 24 Nov 2026 12:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=boDJpr1s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 620861F000C4;
	Tue, 24 Nov 2026 12:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795525167;
	bh=mpEaL2qtctLQ1VscKjboptsoE3gRjQ4GB/qmT7wVR18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=boDJpr1s8gQQIv2ACIz2/xS4KIqQVjNSwFwM5GXYvWPNVLwil+FOPJN6kvovFNDAb
	 Di8JRnBz/+L81sIr2fEwF+o4l0KzYFrdvr9kTnljGiJ78/jXXusxg4zmVVWz3Q40Ug
	 BBouil9jx3cy4WC+BLkQSjGseUPzAIQ5lkHoI1vRkwDHKgRy5vSeNGxMUwi+cJQ35h
	 dAmUcTurIl+4mBmKiKLaTV5ixp/iTCfnqI3AlkVVpDcLBRZKaCc7PSKH//bWWeNeds
	 9d9IPS4URtZBjev2yTUsGuBw0Ug558s/l+PntD+sMm9AzsyiNy9UEP7tzyGiN7NYDV
	 xZhGYcz2ZwCpQ==
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
Subject: [PATCH net-next 12/15] eth: mlx5e: Receive into XDP-only memory providers
Date: Tue, 24 Nov 2026 13:56:47 +0100
Message-ID: <20261124125654.183091-12-bjorn@kernel.org>
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

Currently, mlx5 refuses queue restarts while an XDP program is
attached, and its page pools take no memory provider next to XDP. An
XDP-only memory provider, such as the AF_XDP sink, needs both, as
installing it restarts the queue with the program that steers its
packets attached.

Let the page pools of RQs that run an XDP program take XDP-only
providers, and accept queue restarts with a program attached.

mlx5 already builds and frees XDP buffers by netmem. Take their
addresses with xdp_netmem_address(), which covers XDP-only net_iovs
and is netmem_address() for pages, so the skb paths do not change. The
core handles the rest of the XDP path. The trap RQ and the PTP RQ use
queue index 0 as well, but run no program and build skbs around their
buffers, so they keep system pages. A restart clones the channel with
its program. Each RQ takes its own reference to the program, and the
restart deactivates all channels, XDP SQs included, so the clone needs
nothing more.

The RQ keeps its layout. A stride of the linear striding RQ still
holds the shared info of the skb that XDP_PASS builds, so at MTU 1500
an AF_XDP sink gets one packet per 4 KiB UMEM chunk. With ConnectX-7
and 66-byte frames on one core, it receives 16.42 Mpps (179 cycles per
packet).

An RQ that the provider backs fills from the FILL ring of its socket,
which stays empty while the socket waits for chunks that only the
queue can give back. Activation no longer waits for such an RQ to
reach its minimum of posted buffers, as it already skips the XSK RQ
for the same reason. Otherwise a queue that restarts under a slow
reader times out, the health reporter turns off its ICOSQ, and nothing
fills the RQ again. The check takes netif_rxq_has_xdp_only_mp().

Any user of the queue management API may then restart an mlx5 queue
with a program attached. In the tree, only memory providers restart
queues, and all but XDP-only ones refuse XDP.

Signed-off-by: Björn Töpel <bjorn@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 14 ++++++++++++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c   | 10 +++++-----
 2 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 06a8a4be4be7..a8d46508b6fc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1012,6 +1012,9 @@ static int mlx5e_alloc_rq(struct mlx5e_params *params,
 
 		pp_params.order     = pool_order;
 		pp_params.flags     = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV;
+		/* Trap and PTP RQs use queue 0 too, without a program */
+		if (params->xdp_prog)
+			pp_params.flags |= PP_FLAG_ALLOW_XDP_ONLY_NETMEM;
 		pp_params.pool_size = pool_size;
 		pp_params.nid       = node;
 		pp_params.dev       = rq->pdev;
@@ -3050,6 +3053,14 @@ static int mlx5e_wait_channels_min_rx_wqes(struct mlx5e_channels *chs)
 		if (test_bit(MLX5E_CHANNEL_STATE_XSK, c->state))
 			continue;
 
+		/* An RQ that an XDP-only provider backs fills from the FILL
+		 * ring of its socket, which stays empty until the socket
+		 * gets its chunks back, so a queue that restarts under a
+		 * slow reader would never meet the bound.
+		 */
+		if (netif_rxq_has_xdp_only_mp(c->netdev, c->ix))
+			continue;
+
 		err |= mlx5e_wait_for_min_rx_wqes(&c->rq, timeout);
 
 		/* Don't wait on the XSK RQ, because the newer xdpsock sample
@@ -5754,10 +5765,9 @@ static int mlx5e_queue_mem_alloc(struct net_device *dev,
 
 	if (MLX5E_GET_PFLAG(&chs->params, MLX5E_PFLAG_TX_PORT_TS) ||
 	    chs->params.ptp_rx   ||
-	    chs->params.xdp_prog ||
 	    priv->htb) {
 		netdev_err(priv->netdev,
-			   "Cloning channels with Port/rx PTP, XDP or HTB is not supported\n");
+			   "Cloning channels with Port/rx PTP or HTB is not supported\n");
 		err = -EOPNOTSUPP;
 		goto unlock;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 22fea4739a2c..130e54f81293 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -327,7 +327,7 @@ static void *mlx5e_mpwqe_get_linear_page_frag(struct mlx5e_rq *rq)
 	frag_offset = li->frag_page.frags << MLX5E_XDP_LOG_MAX_LINEAR_SZ;
 	WARN_ON(frag_offset >= BIT(rq->mpwqe.page_shift));
 
-	return netmem_address(li->frag_page.netmem) + frag_offset;
+	return xdp_netmem_address(li->frag_page.netmem) + frag_offset;
 }
 
 static inline int mlx5e_get_rx_frag(struct mlx5e_rq *rq,
@@ -1585,7 +1585,7 @@ mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi,
 	dma_addr_t addr;
 	u32 frag_size;
 
-	va             = netmem_address(frag_page->netmem) + wi->offset;
+	va             = xdp_netmem_address(frag_page->netmem) + wi->offset;
 	data           = va + rx_headroom;
 	frag_size      = MLX5_SKB_FRAG_SZ(rx_headroom + cqe_bcnt);
 
@@ -1640,7 +1640,7 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi
 
 	frag_page = wi->frag_page;
 
-	va = netmem_address(frag_page->netmem) + wi->offset;
+	va = xdp_netmem_address(frag_page->netmem) + wi->offset;
 	frag_consumed_bytes = min_t(u32, frag_info->frag_size, cqe_bcnt);
 
 	addr = page_pool_get_dma_addr_netmem(frag_page->netmem);
@@ -1940,7 +1940,7 @@ mlx5e_skb_from_cqe_mpwrq_nonlinear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *w
 
 	prog = rcu_dereference(rq->xdp_prog);
 
-	head_addr = netmem_address(head_page->netmem) + head_offset;
+	head_addr = xdp_netmem_address(head_page->netmem) + head_offset;
 
 	if (prog) {
 		/* area for bpf_xdp_[store|load]_bytes */
@@ -2114,7 +2114,7 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 		return NULL;
 	}
 
-	va             = netmem_address(frag_page->netmem) + head_offset;
+	va             = xdp_netmem_address(frag_page->netmem) + head_offset;
 	data           = va + rx_headroom;
 	frag_size      = MLX5_SKB_FRAG_SZ(rx_headroom + cqe_bcnt);
 
-- 
2.56.1

