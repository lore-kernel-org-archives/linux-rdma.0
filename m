Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795629635;
	b=FZzLxq0AITQqfYfhsLNgSQwBqlmQ4Qsnj8DjdiUs0FtGlAQKeVlOtHt8WUGy45AFkxzh
	 geOsdYMkt7OyTw90S/Dniik0EpxnQChu0YAe67YZzHwM44vpdZXYETaBUJ4yxt00+F3HA
	 6QdS4BPC4jkZJiPL1e9QIELMmAnqLCBdx5F3nx5wAadCQEKDeH6R5KSxTA++/orjKZJvm
	 0P/pZEv9t2XUQJ9uwMfERsmbhY15pnn4ImVI23SmuRm+BoiY0wL7f6XzyPRz1BDwey/xk
	 jocX6Mw+M45QywFhkBy6+o0Y6/Aaqgr14Zkzv4xP0zA526y4EBZmPdiUZWS+hpYIluw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795629635;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cRmLynzK4ejOioysRL27Skg0kFnrLFhNOhmGT0Ouyxc=;
	b=A9Q/uHQM6I+6eYb6Ni0+VNj43+yKq0V16JOh7pydi4BvvDWcAXwBep46y0ux3dD3kpFH
	 ZbBHHyrBDl/xI4yA4Qmf3Zo0c+6L0A6uf29gspMKfQ4aUyx37NG1iYUEhJRbueSRHQzje
	 cGUFlFAJF5pVWYIF5MOycwgDhnZl8nCi3TLFEUnLq+jchGjRt2Dq8Ih7aCz7cde72VRJS
	 /ZDXOUtvTP5m+OlS6jY57/KAqkYcinYfXjX9ZG1MknoFFV+xpqvgCrUJZYVARlnnMW3De
	 +LCsqmOZ2sHa0x6THcmsPyCR4hz1/m9aTqtvdDfsfAxy+6hEp5Q8d7fmdGfU0VbqDtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=dama.to;
	spf=none smtp.mailfrom=dama.to;
	dkim=pass header.d=dama-to.20260707.gappssmtp.com header.i=@dama-to.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=SfVmCV9F;
	arc=none smtp.remote-ip=209.85.214.178
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB7A3606A33B
	for <linux-rdma@vger.kernel.org>; Wed, 25 Nov 2026 18:00:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CB7A3606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dama.to
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=dama.to
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dama-to.20260707.gappssmtp.com header.i=@dama-to.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=SfVmCV9F
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2f0634667aaso22383805ad.0
        for <linux-rdma@vger.kernel.org>; Wed, 25 Nov 2026 10:00:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dama-to.20260707.gappssmtp.com; s=20260707; t=1795629634; x=1796234434; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cRmLynzK4ejOioysRL27Skg0kFnrLFhNOhmGT0Ouyxc=;
        b=SfVmCV9F0rl7r2j3HbGnH7/OjiYUzQJOKc+XKB/n6k3FykPthLZncNln1T3OY6xoyd
         ff9PyEj6Fu3UOntn16gDjK8SVAgP/fD7WQHr7wSRdFjDj8VvkW2BRcvOX8c56MiCD5N8
         9P9+TwqS/+qmttPFLq0Vh9EHELG1iiH3EIdgKauYbuIAGdp/RoxwWJshzFm2xynNKJS9
         hXvW43gcWQLAKIfWYb/b2beSRPJwr0GHfPs9rKFXRWTVPZdidmA8ygqRJxxTZdVMXpDp
         G1RDJDxHHtWPMiOZS5q3BxaFYyVke05aB3Vtk5z5Uiar5rHt+/0js66z0NbCSH0HCrjN
         zmVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795629634; x=1796234434;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cRmLynzK4ejOioysRL27Skg0kFnrLFhNOhmGT0Ouyxc=;
        b=iAeheS0iTBiIzbNIQmb+L4TSPrHOJY8Yknwlf792LzxIEe+MuUkTWP1JfGZR5mb7By
         6jYl/efScqhYO8Z4cZXPOkHxpVSsfbF9QYik9jmqIiunTCQKqHklna7WExktvJB1//bb
         cX9SaVT9S/V5ZBUqbycNy+8+94CVxxhqTbgdVl1XF8a6JjB8M9rdFYXNAGUhzQiUR0B2
         XpStNs96q8l4q0s92wNgXcbkMxVt12BE2ZK0rfoETFFD6D3fm9m+EGGeDe/WSsdbRWRQ
         iEJ7ZTm1TuGKJ4WqKjzw7Yw/tregbI+42Qzrp0mA/00g7CkKhecNTz7y7M8JKiJubhOq
         fjJg==
X-Forwarded-Encrypted: i=1; AL+hErEjWYAnL1/kb97fAG+LMbof3/yNRYlEQn0Mkn4wRAEzVX2AsGt7hg2mSb3QPUz+uYMLdvYJ9DuVNGPw@vger.kernel.org
X-Gm-Message-State: APuU4Z+0+JoMlXowfaoriQzuYFTfcPrRdv3fPfs0EPwQHHnAq813pCY2
	JKlV37CubCnCYg+R7t5d6dAPQ+tr3A9zV4JGanOzcVEoiDJJz0kzOjM5gQqMJgj+2Y4=
X-Gm-Gg: AZFdTZefTyAsoFhV+tnW8NIGP1Cf878bzhO4JRelbVlSauQxZcp9HXk08KGy3EL14Xx
	qn7EqXcn7V0E0KjuDqIC2/+4XyeQrFxAXVKGN+3Ad44fY1uJFcddeSTfsQ7W2jdqGoGch7CIG0V
	Kpv64rAmRT2y4iY/q/0MSWTzQ7nbf5rDMei3T2WyVvpmFKtKOt94tiFIJG3gsenz1iX205TBTQm
	xlDgc1kprybzkj8vmhI/DLTjJWSGR3A17ziVDqLAXcRYH60gxdXXpAYsj+AWgir2Xw7Un+tCyT0
	xhfyeZxU2QDPvXJY5dLAayfZZkx/tarAwqd5XkfpOu+DbgMmO6BmFkZ9E7YS8gjHff1kM9E+1HQ
	WeDr4h4thmwTt0qhDRCc6Yc4LAQT0o+PJlnVFj+kP/CCcVeiZlWoa5x8cFt3NIwLfCZoVcT3Nvh
	2075BQyYFQNfnuesl4yLtJpsQSiEZi+676r/nop1eARLwZjxPJZpOYA6ncW13/RimiISvStZdsl
	zbiEHC8LpoC1+3/zgQNAoasHomrhXYTc4meKzMBsryd0pZRJUm0L/teYRlyKiRut0vb14E+wNi8
	lf3hy6DBbZ21o2gdDb04MRgywTw2klOzqDsiLjaarPc=
X-Received: by 2002:a17:902:e948:b0:2df:b510:cebb with SMTP id d9443c01a7336-2f03efa4028mr134937665ad.6.1795629633923;
        Wed, 25 Nov 2026 10:00:33 -0800 (PST)
Received: from localhost ([2a03:2880:2ff:47::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f0b7be3347sm35552975ad.15.2026.11.25.10.00.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 10:00:33 -0800 (PST)
From: Joe Damato <joe@dama.to>
To: netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: edumazet@google.com,
	horms@kernel.org,
	linux-kernel@vger.kernel.org,
	daniel.machon@microchip.com,
	mbloch@nvidia.com,
	Joe Damato <joe@dama.to>,
	linux-rdma@vger.kernel.org
Subject: [PATCH net-next v3 4/5] net/mlx4: track whether a TX doorbell is pending
Date: Wed, 25 Nov 2026 10:00:17 -0800
Message-ID: <20261125180021.1804204-5-joe@dama.to>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261125180021.1804204-1-joe@dama.to>
References: <20261125180021.1804204-1-joe@dama.to>
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

When the stack sets xmit_more, mlx4_en_xmit() skips the doorbell and
relies on a later call in the same batch to write it. Nothing records
that a doorbell is owed, so a path that ends the batch without writing
the doorbell leaves the WQEs posted before it unannounced to HW.

Add ring->doorbell_pending, set in mlx4_en_xmit() when the doorbell is
deferred, so such a path can flush the deferred doorbell.

Place the flag in the cache line dirtied by mlx4_en_xmit(), next to
prod. That line has no room left, so move tx_dropped, which is only
written when an skb is dropped, to the end of the struct among the
fields not used in the fast path.

Suggested-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Joe Damato <joe@dama.to>
---
v3:
  - Set doorbell_pending once in mlx4_en_xmit from !send_doorbell so XDP_TX
    doesn't write it (Mark).
  - Dropped Daniel's Reviewed-by

v2:
  - doorbell_pending moved to the area of the struct marked as cache line
    used and dirtied in mlx4_en_xmit. In exchange, tx_dropped is moved
    among fields not written in the fast path. It is only written for
    drops and is read for stats.
  - Update the commit message.

 drivers/net/ethernet/mellanox/mlx4/en_tx.c   | 2 ++
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
index 40dc4f6a7329..8a43c86f815c 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
@@ -193,6 +193,7 @@ int mlx4_en_activate_tx_ring(struct mlx4_en_priv *priv,
 	ring->prod = 0;
 	ring->cons = 0xffffffff;
 	ring->last_nr_txbb = 1;
+	ring->doorbell_pending = false;
 	memset(ring->tx_info, 0, ring->size * sizeof(struct mlx4_en_tx_info));
 	memset(ring->buf, 0, ring->buf_size);
 	ring->free_tx_desc = mlx4_en_free_tx_desc;
@@ -1098,6 +1099,7 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
 	send_doorbell = __netdev_tx_sent_queue(ring->tx_queue,
 					       tx_info->nr_bytes,
 					       netdev_xmit_more());
+	ring->doorbell_pending = !send_doorbell;
 
 	real_size = (real_size / 16) & 0x3f;
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
index aab97694f86b..c28d5213cccd 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
@@ -274,7 +274,7 @@ struct mlx4_en_tx_ring {
 
 	/* cache line used and dirtied in mlx4_en_xmit() */
 	u32			prod ____cacheline_aligned_in_smp;
-	unsigned int		tx_dropped;
+	bool			doorbell_pending;
 	unsigned long		bytes;
 	unsigned long		packets;
 	unsigned long		tx_csum;
@@ -311,6 +311,7 @@ struct mlx4_en_tx_ring {
 	enum mlx4_qp_state	sp_qp_state;
 	u16			sp_stride;
 	u16			sp_cqn;	/* index of port CQ associated with this ring */
+	unsigned int		tx_dropped;
 } ____cacheline_aligned_in_smp;
 
 struct mlx4_en_rx_desc {
-- 
2.53.1-Meta

