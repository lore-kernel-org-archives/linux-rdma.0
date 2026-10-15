Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31318518143;
	Thu, 15 Oct 2026 11:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792065557; cv=none; b=s2ijUB+WmTLV2B3ZYHswR/yMvhoKWbmJsdTgYnF5al1iYKMnGucAmHqoRZwfkgsJd6d+P2zfeut5nt5Ef9TG7ke1hCj3u2HUwT5loN8M4H3viu1PcVus7R5NTCKiN/ZIrRRsI9lG22cuOzx9ZNG3uOskZudI64f3JyIqamdNRHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792065557; c=relaxed/simple;
	bh=aol5ZbSv1D74lfXg742+T7Gf4SeaNYzgue/Whlmyb2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D1ediv+FIBCjYGTQr2dvgKqERQY19mSfFdxsJZGfQpP2rV56807t/rUN43fFi/wLgiUNPfWrBVjHLwZ1k58IspDFJWDYfsPjEc5bV/NuvhiCxKjBfErZv8DfoixHGN085+TynftTTFs+qbAsDOFnkm38oH52m8x67yRwFvgYaeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RJJUI5Ot; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RJJUI5Ot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3915C1F000C4;
	Thu, 15 Oct 2026 11:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792065555;
	bh=X+2TnBkHXEnhEtnSRl5t9hwQB5sORH7JscPpFWBGoeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RJJUI5Ot8QM+g9fuIvdaro7hLchztW2c3rKz8keMINiIBLkY5roBhD4xtHPdo3NMM
	 tiq4vTAtFIQnZZrrD5xe09xEoeVjY3WTHxRxwkOqG4/FUcabRpPCwZ1/id5B1W5s3I
	 ufGmJC5iEPIcsyuQ4f0oI0pvsLq+5XARVZhKAQelJ8hWT4fwTq5sQtgTh6lFAJ/t3D
	 o0IBk2pI4FJbQOQH81VzP3oiWcCh+12exKoRpd9ylh/fr/JfBsGkIRKQC/3/ducxJE
	 LM3Tc5f0NUAnBs0+iYk1y2mWvuutP0QnMG38K64Uy325z7jdspke2MwQX2sAeWmyqd
	 IXMk6S2YuHAzA==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Maor Gottlieb <maorg@mellanox.com>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next 3/3] RDMA/core: Reject LAG selection when source MAC lookup fails
Date: Thu, 15 Oct 2026 14:59:02 +0300
Message-ID: <20261015-ib-core-fixes-v1-3-60f6da3ddec3@nvidia.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261015-ib-core-fixes-v1-0-60f6da3ddec3@nvidia.com>
References: <20261015-ib-core-fixes-v1-0-60f6da3ddec3@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

GID deletion can clear the source device association after LAG lookup
retains the bonding master. Ignoring the resulting L2 lookup failure
copies uninitialized source MAC bytes into the synthetic hash packet.

Read the source MAC before allocating the packet and propagate lookup
errors to the caller, so failed lookups cannot influence slave selection.

Fixes: bd3920eac133 ("RDMA/core: Add LAG functionality")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/core/lag.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/lag.c b/drivers/infiniband/core/lag.c
index 88aac911e8ee..651c868aa04e 100644
--- a/drivers/infiniband/core/lag.c
+++ b/drivers/infiniband/core/lag.c
@@ -19,6 +19,11 @@ static struct sk_buff *rdma_build_skb(struct net_device *netdev,
 	u8 smac[ETH_ALEN];
 	bool is_ipv4;
 	int hdr_len;
+	int ret;
+
+	ret = rdma_read_gid_l2_fields(ah_attr->grh.sgid_attr, NULL, smac);
+	if (ret)
+		return ERR_PTR(ret);
 
 	is_ipv4 = ipv6_addr_v4mapped((struct in6_addr *)ah_attr->grh.dgid.raw);
 	hdr_len = ETH_HLEN + sizeof(struct udphdr) + LL_RESERVED_SPACE(netdev);
@@ -26,7 +31,7 @@ static struct sk_buff *rdma_build_skb(struct net_device *netdev,
 
 	skb = alloc_skb(hdr_len, flags);
 	if (!skb)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	skb->dev = netdev;
 	skb_reserve(skb, hdr_len);
@@ -70,7 +75,6 @@ static struct sk_buff *rdma_build_skb(struct net_device *netdev,
 	skb_reset_mac_header(skb);
 	eth = eth_hdr(skb);
 	skb->protocol = eth->h_proto = htons(is_ipv4 ? ETH_P_IP : ETH_P_IPV6);
-	rdma_read_gid_l2_fields(ah_attr->grh.sgid_attr, NULL, smac);
 	memcpy(eth->h_source, smac, ETH_ALEN);
 	memcpy(eth->h_dest, ah_attr->roce.dmac, ETH_ALEN);
 
@@ -86,8 +90,8 @@ static struct net_device *rdma_get_xmit_slave_udp(struct ib_device *device,
 	struct sk_buff *skb;
 
 	skb = rdma_build_skb(master, ah_attr, flags);
-	if (!skb)
-		return ERR_PTR(-ENOMEM);
+	if (IS_ERR(skb))
+		return ERR_CAST(skb);
 
 	rcu_read_lock();
 	slave = netdev_get_xmit_slave(master, skb,

-- 
2.55.0

