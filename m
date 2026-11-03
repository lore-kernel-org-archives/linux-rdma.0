Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793750317;
	b=rCGFHJIuztBxIqyjPkhJT+fitv1Job4FXbgl+TbPx9HhH71ORmlZxK/HWp8+pTmABpnS
	 qEN11nBWj75oCVKwOYReqAOO28MWYS2oljMxKv0GGUzQYvNNMHqHvkbU85wGTR1LKlV8j
	 2vIC4qdwtPgk5NZwUR6wIU4KcnwaG/qHEjRDRA54Hl77B8biONYlIfiWvD+2uFg9vyNKu
	 +/ZS4yz2KZoIrcBIGZeq0DaMOZXGxeCqEpfEVR9fRekZ9Fkx9+wMXsVXu2Lv9S1VrQ7vi
	 KcwUIQ87WtY6qDjEhuIFSrvcDABVlCpnspMc62Ps216NFTKs2nGwu8SS0QGbEyOMaRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793750317;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=PX/xDrM0QsmqxurY9bnXyVhX0Z4Wa38RkkCfEUjRRBg=;
	b=Jnh1krfPyg/V/Zt5OhGQEjNJbzXK2gGxCCfN3S3WU6GGzrj49ZoZN8r4pjuDbxkAnum4
	 j4aX1kLGDcwqxGhnfYQUVyyLnGD4aCVofGube+wMVeQZpp4KBUiqgGMbEmOSBbC674ayQ
	 BQpU4oEYT2n7I165ovTPv63ezuJy65q3NujwGF57IpKGUIFPtL++swiUbKiEfRtoN8wEh
	 GL6P9WQ+0yVCbjZoWwSkCXZYnioDm/QbxffRxaZ7x2j0SkvzpZYJ6Yx4wZ69OnbJArVAp
	 moNk/dpXUySoDADPVK6FqSTh/aiY6f+TWFSdhw5ePWthTaqsSSBFC7imWleRjPfM4Gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=openvpn.net;
	spf=pass smtp.mailfrom=openvpn.com;
	dkim=pass header.d=openvpn.net header.i=@openvpn.net header.a=rsa-sha256 header.s=google header.b=WXZgEgHQ;
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFBFF606A330
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 23:58:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EFBFF606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=openvpn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=openvpn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=openvpn.net header.i=@openvpn.net header.a=rsa-sha256 header.s=google header.b=WXZgEgHQ
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a4d7ae1ae9so858335e9.1
        for <linux-rdma@vger.kernel.org>; Tue, 03 Nov 2026 15:58:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvpn.net; s=google; t=1793750315; x=1794355115; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=PX/xDrM0QsmqxurY9bnXyVhX0Z4Wa38RkkCfEUjRRBg=;
        b=WXZgEgHQe5iPhuKqbRtB+gZGMJXvj7i8GJKAA/5bKpTZolV3btL2h1QNfbyr6McuUv
         fuO2gk6Y+ABg+HSWI2vbB3PCR+UdtDgbB7vTdMzvvZvy2qw11JzZhudBDC8dLOQwpXGo
         cWblrmBlRl4l+3rfa7b1ZDKk3mTwK41MoKskTib9QHid1PMa1kPlh8ZQQRWgwV7w29PF
         evoG4rmLsDp7ZXyebDAySdxHObU8rN65OD4Jwo/Cwc/Qn/2EuiRxMSLRw6Epl8DyRwxP
         iaA9PH38UoDpS6LW0emILYizATtHP7A3rtzcBEREWW52EjIaYFVlCxJ+9GDPRLnGERCn
         813A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793750315; x=1794355115;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PX/xDrM0QsmqxurY9bnXyVhX0Z4Wa38RkkCfEUjRRBg=;
        b=UQUcyOJcygnur8KK8iKMx3vxMFR/hfHSIpA0Z7GwTB9M1vbtKCmvk42tqOKXYruZy3
         4xXqM6FORhLPTUujcYqIvNl5KVuQo29kmZ1sOqGtUcVID24v1bwkaI5Gd+d7Q+7RSYHk
         zVRvmwNeKVtK5nER458RU92Wl4lObs/u/vY98cR9UTWoi+UVjhRNxFETzmdzlibZV9rN
         TuKXL6ZWo9nIoAfKdtuFWjtjNxJ+k8e3Tatx4wUrywL+i7P16hd2QmNUycrLKqSciIwm
         MPIk+srtlm2lL3YaN6Wyww7kry2cciVkAfyfm0tz7yYq57hs3BANNYJR0a5dXagjbeMN
         8Vvw==
X-Forwarded-Encrypted: i=1; AKwUvBxzdDmCBwCs9sgEoiMIWggA9+dZmxWZa2mrHQyt7DF6EhfTXRDPrWQMwnfaK+uF5Zf9LX2bOE6SCAHJ@vger.kernel.org
X-Gm-Message-State: APuU4Z8tc4yB41mnhWhrGE05gSSYA7VD+eHSyFSfQax3P9YnZRd9t3su
	j1YGbdLAlxiuPxqBoqO0YsDRV2Ye1Eu0+uYU7PclTY7LpebtXztNRUw7ZtAv6u75jCAITVgqTef
	0bG7CrXDt3RclSAwZmDWInR24AwRYTPCbyMexuO+sWrnNw4m2whMItXLg
X-Gm-Gg: AYBFou0iqzuz39aj/tfl/9GNxVvdQyDPl2C8wWzjX8T1X1y0jjqCZCxtHuvZMe9BUUP
	+yPLtFtbFZXQiMPM2Pxg9URbbRIHP3t+Dw7JaC+BW/xEQWfkndfg+ATophVjJaVgVhNd+f+7lb0
	FcS41ccYuuoYFrf2T5kh1W7FF3s92QRZoSp8SD5EtoCaM7aUP2D8m3MyN0UZx3seaT/cgRupopf
	mweUiGv7t/JSMn6+GUImB5wQ2S2YQl+NnQ9xBljjM2Bn94xdKspQ/srbLzHkfoQE4OQ6wLUssws
	MtdhVxjDDHn5FgfgvXVNzexfwuUB6KWonghktyaVNKrcF5ybnhtnd67ngBNyQmS9KFZ7A1G5+x5
	YKDp2r/jG0AdIh4nbUOZSsfiY+3f5HplQsdOeTyZUSZBT4Xv/aaCcLuVKvTFjTpqk1sNX+87lYr
	vfgTHZq8VTJL4RiHp8Crp5FYabAV7lqvlIbAk8rONY5v6DF+YLARtb7vqS/rHNxhfWv6IGCTwjN
	k3awyCdxASrOEJn6JkIr3YJGd9BEuPPeF/9SXFldA130QTHy8d+hTGUK94a6cqMC/qMdilFkHPx
	WW/ehQa7jOaHcY3n9IVDLPR62IXc8BmDMBQQBjUbu6/Yu3Sb11M=
X-Received: by 2002:a05:600c:34cf:b0:4a1:dbdf:17a8 with SMTP id 5b1f17b1804b1-4ac150b3d01mr352800595e9.2.1793750315231;
        Tue, 03 Nov 2026 15:58:35 -0800 (PST)
Received: from inifinity.homelan.mandelbit.com ([2001:67c:2fbc:1:5298:4b33:93cf:63b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b4104d600fsm16341815e9.0.2026.11.03.15.58.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 15:58:34 -0800 (PST)
From: Antonio Quartulli <antonio@openvpn.net>
To: netdev@vger.kernel.org
Cc: saeedm@nvidia.com,
	leon@kernel.org,
	tariqt@nvidia.com,
	mbloch@nvidia.com,
	dtatulea@nvidia.com,
	cratiu@nvidia.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	hawk@kernel.org,
	john.fastabend@gmail.com,
	sdf@fomichev.me,
	linux-rdma@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Antonio Quartulli <antonio@mandelbit.com>
Subject: [PATCH net-next] net/mlx5e: Prefetch packets of upcoming CQEs in the linear MPWQE path
Date: Wed,  4 Nov 2026 00:58:23 +0100
Message-ID: <20261103235823.536706-1-antonio@openvpn.net>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Antonio Quartulli <antonio@mandelbit.com>

Without cache injection (DDIO/SDCI), the first access to a received
packet's headers and skb_shared_info is a DRAM miss, and the net_prefetch()
in mlx5e_skb_from_cqe_mpwrq_linear() is too late to hide it. This caps the
packet rate of a queue.

While processing a CQE, look at the CQE MLX5E_RX_PREFETCH_DIST (4) entries
ahead and, if it is completed, prefetch its packet headers, skb_shared_info
and page. Also prefetch the CQE twice as far ahead.

Looking ahead requires uncompressed CQEs, so this is enabled only for
linear striding RQs without CQE compression.

AMD Ryzen 9 9950X, ConnectX-5 Ex, one RX queue on a dedicated CPU,
MTU 1500:

                       before       after
  UDP 64B, pktgen    2.77 Mpps    3.60 Mpps   +30%
  UDP 512B, pktgen   2.68 Mpps    3.57 Mpps   +33%
  TCP, 1 stream      45.8 Gb/s    48.1 Gb/s    +5%
  TCP, 4 streams     49.4 Gb/s    67.5 Gb/s   +37%

The NAPI CPU cycles per packet drop by 23-47%.

Signed-off-by: Antonio Quartulli <antonio@mandelbit.com>
---
measured on one system only (Zen 5 desktop, no cache injection,
CX-5 Ex). Numbers from DDIO/SDCI systems and CX-6/CX-7 would be welcome,
to check that the extra CQE read and prefetches cost nothing there.

Notes:
- With CQE compression (default on slow PCIe links) nothing changes.
- With XDP, skb_shared_info is not prefetched. XDP_DROP rate, low-rate
  traffic and multiple queues were not measured.
- The prefetches are issued before the DMA sync; the packet is only read
  after it.
- Distance: 4, 6 and 8 were within 3% of each other; gains flatten above 2.
- Measured with an equivalent build (CQE peek as a local helper, no XDP
  gate); NAPI CPU DRAM demand fills went from ~0.8 to ~0.15 per packet.
- pktgen floods a port without a listener, saturating the queue. Interleaved
  off/on runs (UDP 3, TCP 2; TCP 4 streams "after" is 1 run, the other was
  disturbed). With MTU 9000 (non-linear path, unaffected) runs differ by
  up to 3%.

 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 +
 .../mellanox/mlx5/core/en/reporter_rx.c       |  1 +
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 58 ++++++++++++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/wq.h  | 16 +++--
 4 files changed, 69 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index a3945195f454..4ba61150ea1c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -341,6 +341,7 @@ enum {
 	MLX5E_RQ_STATE_SHAMPO, /* set when SHAMPO cap is used */
 	MLX5E_RQ_STATE_MINI_CQE_ENHANCED,  /* set when enhanced mini_cqe_cap is used */
 	MLX5E_RQ_STATE_XSK, /* set to indicate an xsk rq */
+	MLX5E_RQ_STATE_PREFETCH_NEXT, /* prefetch the packets of next CQEs */
 	MLX5E_NUM_RQ_STATES, /* Must be kept last */
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index 6efb626b5506..137db88da42f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -21,6 +21,7 @@ static const char * const rq_sw_state_type_name[] = {
 	[MLX5E_RQ_STATE_SHAMPO] = "shampo",
 	[MLX5E_RQ_STATE_MINI_CQE_ENHANCED] = "mini_cqe_enhanced",
 	[MLX5E_RQ_STATE_XSK] = "xsk",
+	[MLX5E_RQ_STATE_PREFETCH_NEXT] = "prefetch_next",
 };
 
 static int mlx5e_query_rq_state(struct mlx5_core_dev *dev, u32 rqn, u8 *state)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 22fea4739a2c..b9eacd6bb5be 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -2457,10 +2457,55 @@ static int mlx5e_rx_cq_process_enhanced_cqe_comp(struct mlx5e_rq *rq,
 	return work_done;
 }
 
+/* Prefetch the headers, skb_shared_info and page of the packet
+ * MLX5E_RX_PREFETCH_DIST CQEs ahead, and the CQE twice as far ahead.
+ * Requires uncompressed CQEs.
+ */
+#define MLX5E_RX_PREFETCH_DIST	4
+
+/* called after popping the current CQE */
+static void mlx5e_mpwrq_linear_prefetch(struct mlx5e_rq *rq,
+					struct mlx5_cqwq *cqwq)
+{
+	u32 wqe_offset, head_offset, page_idx;
+	struct mlx5e_frag_page *frag_page;
+	struct mlx5e_mpw_info *wi;
+	struct mlx5_cqe64 *cqe;
+	u16 cqe_bcnt;
+	void *va;
+
+	prefetch(mlx5_cqwq_get_wqe(cqwq,
+				   mlx5_cqwq_ctr2ix(cqwq, cqwq->cc +
+						    2 * MLX5E_RX_PREFETCH_DIST - 1)));
+
+	cqe = mlx5_cqwq_get_cqe_ctr(cqwq, cqwq->cc + MLX5E_RX_PREFETCH_DIST - 1);
+	if (!cqe || MLX5E_RX_ERR_CQE(cqe) || mpwrq_is_filler_cqe(cqe))
+		return;
+
+	/* oversized packets are dropped by the linear path */
+	cqe_bcnt = mpwrq_get_cqe_byte_cnt(cqe);
+	if (unlikely(cqe_bcnt > rq->hw_mtu))
+		return;
+
+	wi = mlx5e_get_mpw_info(rq, be16_to_cpu(cqe->wqe_id));
+	wqe_offset = mpwrq_get_cqe_stride_index(cqe) << rq->mpwqe.log_stride_sz;
+	head_offset = wqe_offset & ((1 << rq->mpwqe.page_shift) - 1);
+	page_idx = wqe_offset >> rq->mpwqe.page_shift;
+	frag_page = &wi->alloc_units.frag_pages[page_idx];
+	va = netmem_address(frag_page->netmem) + head_offset;
+
+	net_prefetch(va + rq->buff.headroom);
+	/* with XDP the packet may not become an skb */
+	if (!rcu_access_pointer(rq->xdp_prog))
+		prefetchw(va + SKB_DATA_ALIGN(rq->buff.headroom + cqe_bcnt));
+	prefetch(netmem_to_page(frag_page->netmem));
+}
+
 static int mlx5e_rx_cq_process_basic_cqe_comp(struct mlx5e_rq *rq,
 					      struct mlx5_cqwq *cqwq,
 					      int budget_rem)
 {
+	bool prefetch_next = test_bit(MLX5E_RQ_STATE_PREFETCH_NEXT, &rq->state);
 	struct mlx5_cqe64 *cqe;
 	int work_done = 0;
 
@@ -2476,6 +2521,8 @@ static int mlx5e_rx_cq_process_basic_cqe_comp(struct mlx5e_rq *rq,
 		}
 
 		mlx5_cqwq_pop(cqwq);
+		if (prefetch_next)
+			mlx5e_mpwrq_linear_prefetch(rq, cqwq);
 		INDIRECT_CALL_3(rq->handle_rx_cqe, mlx5e_handle_rx_cqe_mpwrq,
 				mlx5e_handle_rx_cqe, mlx5e_handle_rx_cqe_mpwrq_shampo,
 				rq, cqe);
@@ -2653,17 +2700,22 @@ int mlx5e_rq_set_handlers(struct mlx5e_rq *rq, struct mlx5e_params *params, bool
 	struct net_device *netdev = rq->netdev;
 	struct mlx5_core_dev *mdev = rq->mdev;
 	struct mlx5e_priv *priv = rq->priv;
+	bool linear;
 
 	switch (rq->wq_type) {
 	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ:
+		linear = !xsk && mlx5e_rx_mpwqe_is_linear_skb(mdev, params, NULL);
 		rq->mpwqe.skb_from_cqe_mpwrq = xsk ?
 			mlx5e_xsk_skb_from_cqe_mpwrq_linear :
-			mlx5e_rx_mpwqe_is_linear_skb(mdev, params, NULL) ?
-				mlx5e_skb_from_cqe_mpwrq_linear :
-				mlx5e_skb_from_cqe_mpwrq_nonlinear;
+			linear ? mlx5e_skb_from_cqe_mpwrq_linear :
+				 mlx5e_skb_from_cqe_mpwrq_nonlinear;
 		rq->post_wqes = mlx5e_post_rx_mpwqes;
 		rq->dealloc_wqe = mlx5e_dealloc_rx_mpwqe;
 
+		/* looking at the CQEs ahead requires plain CQEs */
+		if (linear && !MLX5E_GET_PFLAG(params, MLX5E_PFLAG_RX_CQE_COMPRESS))
+			__set_bit(MLX5E_RQ_STATE_PREFETCH_NEXT, &rq->state);
+
 		if (params->packet_merge.type == MLX5E_PACKET_MERGE_SHAMPO) {
 			rq->handle_rx_cqe = priv->profile->rx_handlers->handle_rx_cqe_mpwqe_shampo;
 			if (!rq->handle_rx_cqe) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/wq.h b/drivers/net/ethernet/mellanox/mlx5/core/wq.h
index 6debb8fd33ff..5e3d4a85c343 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/wq.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/wq.h
@@ -227,12 +227,15 @@ static inline void mlx5_cqwq_update_db_record(struct mlx5_cqwq *wq)
 	*wq->db = cpu_to_be32(wq->cc & 0xffffff);
 }
 
-static inline struct mlx5_cqe64 *mlx5_cqwq_get_cqe(struct mlx5_cqwq *wq)
+/* CQE at @ctr, if owned by SW. @ctr may be ahead of the consumer counter
+ * only without CQE compression.
+ */
+static inline struct mlx5_cqe64 *
+mlx5_cqwq_get_cqe_ctr(struct mlx5_cqwq *wq, u32 ctr)
 {
-	u32 ci = mlx5_cqwq_get_ci(wq);
-	struct mlx5_cqe64 *cqe = mlx5_cqwq_get_wqe(wq, ci);
+	struct mlx5_cqe64 *cqe = mlx5_cqwq_get_wqe(wq, mlx5_cqwq_ctr2ix(wq, ctr));
 	u8 cqe_ownership_bit = cqe->op_own & MLX5_CQE_OWNER_MASK;
-	u8 sw_ownership_val = mlx5_cqwq_get_wrap_cnt(wq) & 1;
+	u8 sw_ownership_val = mlx5_cqwq_get_ctr_wrap_cnt(wq, ctr) & 1;
 
 	if (cqe_ownership_bit != sw_ownership_val)
 		return NULL;
@@ -243,6 +246,11 @@ static inline struct mlx5_cqe64 *mlx5_cqwq_get_cqe(struct mlx5_cqwq *wq)
 	return cqe;
 }
 
+static inline struct mlx5_cqe64 *mlx5_cqwq_get_cqe(struct mlx5_cqwq *wq)
+{
+	return mlx5_cqwq_get_cqe_ctr(wq, wq->cc);
+}
+
 static inline
 struct mlx5_cqe64 *mlx5_cqwq_get_cqe_enhanced_comp(struct mlx5_cqwq *wq)
 {
-- 
2.56.0

