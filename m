Received: from aer-iport-4.cisco.com (aer-iport-4.cisco.com [173.38.203.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA786379C4A;
	Fri, 21 Aug 2026 21:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.38.203.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787348330; cv=none; b=jHXEo3XyzzxTbts69ZOLZwmZB0GSthXMv+N+0tgOs+ySo7c7SNJFerllSEH7fAmnizNzC5tBvRxdt1pI/mUtxJ7kytBc43R6JbW2Jvl4A3ifVRNU61USblCm4+bp/Pwbxz/cOPdKUsfxZXM6MEXsWCSiAVZurk2Stjp6bMejyF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787348330; c=relaxed/simple;
	bh=hojht42JMT+PGkSMDEWuPCKapKpcOBYvf1/BjTYzvRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jEUwuyZPzmw42iTkVmHvowCOVjLSjfiJbSed+8JFpRhaCNP9xHSv8h9OGOKzXbANfY6d9kx6ROVkJIHm68Sy3rMMn22vlqrM8PKKHn10lk5/HU+l0/qSMIKmNRCaZftytEXgFOMIxn808+I9JYAE59lK68H69AVVUzKRmvibRys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=e3UcctRR; arc=none smtp.client-ip=173.38.203.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="e3UcctRR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=2300; q=dns/txt;
  s=iport01; t=1787348328; x=1788557928;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oo4Ghg49LSL5eqjdbN4ni4qah3Rkl5L/1LDW+1nZDxU=;
  b=e3UcctRRZV6PGhQtZR+50z+RfpTKvDkcqkHSJ1PcXBzqjrUbMUVgsdoo
   cVXKlLMyfbgYQg2OGLpFJpVTgtT/xeon8f51jPgNJdkdPt6Nb0h8DmeCQ
   OGWQPEfzKTx77gzbqXLNOh4u6NR39yBHu2nrSQAF5pWnutL4tu3w8erKn
   SnZRm/AUzZCha1H+yz4dTNsRjc1tK9JMHEW8royFNGVVYcZTsfSgnOv4+
   eAdBNW6d1d5CFfuVAgjRZkIZqHcH64Jm5/xDWMisIVvDq8TN+MZfmT0bq
   tk6wbmb411xGkUiu1C1KqJy3ZtGzNg07K9BX4ybCxqXkB58SyJn+TGnKb
   w==;
X-CSE-ConnectionGUID: uoYTs9TlTOWU2SyZjJFnIg==
X-CSE-MsgGUID: ho+xN08KQmCayyBAnWcGzw==
X-IPAS-Result: =?us-ascii?q?A0AdAwCGw4hq/9VK/pBaglkCghY/gVJDSZQpgiGBFp0Ig?=
 =?us-ascii?q?X4PAQEBD1EEAQGFBQKNbAImNAkOAQIEAwIDAQEBAQEBAQEBAQELAQEFAQEBA?=
 =?us-ascii?q?gEHBYEOE4ZcSQEMAYYEAgEDJwsBRhBRVhmDAoJ1A8FWgXkzgQHeR4FmAQsUA?=
 =?us-ascii?q?YE4jWF2hHwnG4FJRIEVMoJBB2+FEIV4BIMuk1dIgR4DWSwBVRMNCgsHBYFmA?=
 =?us-ascii?q?zUSKhUyPDIdgSM+F4ENGwYFgR1ZT4QQIxk2eoEJXoErKWABEheBCYIHAoJag?=
 =?us-ascii?q?gUCAUlDDgdIIgsYDUgRLDcUGQQ+bgeOXh+CTAExIjEKFIEyKVEFk0oBgyqwI?=
 =?us-ascii?q?4QooXYzl1+TDZkIpCOFIIFoPIFZMxoIGxWDIlMZD44tFoEUAQLOZEUyPQEBB?=
 =?us-ascii?q?wIHDgMLgWiIZYkZAQE?=
IronPort-Data: A9a23:lRaxR62Q2/hxarLE2/bD5Rtxkn2cJEfYwER7XKvMYLTBsI5bpzBSm
 2pJDWqGa/+MYDf9eot1OYXn9k4HsZ/Sn9ZjT1Rl3Hw8FHgiRegpqji6wuYcGwvIc6UvmWo+t
 512huHodZ5yFjmH4E/xbtANlFEkvYmQXL3wFeXYDS54QA5gWU8JhAlq8wIDqtYAbeORXUXX5
 Lsen+WFYAX7g24uazpNg06+gEoHUMra6WtwUmMWPZinjHeG/1EJAZQWI72GLneQauF8Au6gS
 u/f+6qy92Xf8g1FIovNfmHTKxBirhb6ZGBiu1IOM0SQqkEqSh8ajs7XAMEhhXJ/0F1lqTzeJ
 OJl7vRcQS9xVkHFdX90vxNwS0mSNoUekFPLzOTWXcG7lyX7n3XQL/pGEUYHAZZJxuJLJl5zr
 8cJGjIvQBaiiLfjqF67YrEEasULJcTxeYdasXZ6wHSAV7AtQIvIROPB4towMDUY35wSW6yDO
 4xGNXw1NU+ojx5nYj/7DLo8gOCsgnTjWzZZs1mS46Ew5gA/ySQsgee0b4GOKrRmQ+1VmQWIg
 DqW3F38KRgLJfa2zwWO3WCz07qncSTTHdh6+KeD3vJjnlCW7mAaFhATUVy1vb+/h1LWc8lTJ
 WQa/S8vpqg/6gquQ7HVXRq4pjiKtwUAUtBdFeES5wSEy66S6AGcbkAJQiNEYc4rqOc5Qjsl0
 lLPlNTsbRRjubuURHa197CboDqoMy8Fa2kPeUcsRBAZy9ruuoc+ilTIVNkLOK68kd7dGjzqx
 T2O6i8kiN07jtMB3o248ErBjjbqoYLGJiY84AnNU33m6A5laIO7T4i1716d5vYoBIqFR0Wcu
 HUNs86A7ewPBNeGkynlaOEAG7ez4N6DLjzQgFcpFJ4knxyo8XqkdoB45i9/KEZgdM0DfFfBe
 0betA9UzJlNPXerZOl8ZIfZI9gj16n5CfzjSPHYb9MIaZ90HCef9StjY0+4xW3hkEEw16o4P
 P+ze96iJWgVBL4hzzesQeoZl7gxyUgWwWLVWIC+zBm917eaTGCaRK1DM1aUaO09qqSer2399
 9dZKtvP0RlaWcXgbSTNt40eN1YHKT48H5+eg8paauKOPCJ4F2w7Tfzc27Usf8pihas9vvzU9
 3u5V2dGx1flw37KMwOHbjZkcryHYHpkhXs2J2koeF2vwXVmONzp56YEfJxxdr4inAB+8cNJo
 zA+U53oKpxypv7volzxsbGVQFReSSmW
IronPort-HdrOrdr: A9a23:ML7EMqEvGMsk3OCdpLqEyMeALOsnbusQ8zAXPo5KJSC9Ffbo8/
 xG88506faZslwssTQb6LO90cq7MBbhHPxOgLX5VI3KNGLbUSmTXeNfBODZrAEIdReSygck78
 ddWpk7LsHsBl5nisu/ygy5H9E8hOSjysmT9IDjJ7MHd3ASV0mmhD0JbDqmLg==
X-Talos-CUID: =?us-ascii?q?9a23=3AwZN4UWh0tGDX7SpGMS8CiVsGjzJub3rs8GyBH0u?=
 =?us-ascii?q?ELllUEoaEe12y1qVFnJ87?=
X-Talos-MUID: 9a23:0ehjEAqix/tCM1QUbycezzFld9dOu/SNMUUmmIQXkeCCCidfKSjI2Q==
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.25,235,1779148800"; 
   d="scan'208";a="59717338"
Received: from aer-l-core-12.cisco.com ([144.254.74.213])
  by aer-iport-4.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 21 Aug 2026 21:37:34 +0000
Received: from localhost (unknown [10.189.108.235])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by aer-l-core-12.cisco.com (Postfix) with ESMTPS id 4C7FB18000227;
	Fri, 21 Aug 2026 21:37:34 +0000 (GMT)
From: Jerome Tollet <jtollet@cisco.com>
To: netdev@vger.kernel.org
Cc: saeedm@nvidia.com,
	tariqt@nvidia.com,
	mbloch@nvidia.com,
	leonro@nvidia.com,
	dtatulea@nvidia.com,
	daniel@iogearbox.net,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	ast@kernel.org,
	hawk@kernel.org,
	john.fastabend@gmail.com,
	sdf@fomichev.me,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH net v3 1/2] net/mlx5e: Prevent stale XSK buffer release on refill retry
Date: Fri, 21 Aug 2026 23:37:31 +0200
Message-ID: <797fe2396b60f69e2bc79575ba43a29a45b26218.1787347981.git.jtollet@cisco.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1787347981.git.jtollet@cisco.com>
References: <20260820151558.11015-1-jtollet@cisco.com> <cover.1787347981.git.jtollet@cisco.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Outbound-Client-TLS: ANONYMOUS;unknown [10.189.108.235];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 10.189.108.235, [10.189.108.235]
X-Outbound-Node: aer-l-core-12.cisco.com

When an XDP redirect to an AF_XDP socket fails because its RX ring is
full, the XSK core frees the buffer. During the subsequent batched refill
of a legacy cyclic RQ, mlx5e also releases the WQE's XSK buffer before
allocating a replacement. If that refill succeeds only partially, a WQE
left without a replacement retains its old buffer pointer.

The buffer can meanwhile be allocated to another WQE. A later refill
retry can then free the live buffer through the stale pointer and publish
the same UMEM frame twice.

Mark the WQE as released immediately after the driver-side free. The flag
is already cleared when a replacement buffer is assigned, so refill
retries no longer release stale pointers.

The failure is silent and produces no kernel warning or splat. A
standalone legacy cyclic-RQ zero-copy libxsk reproducer, using 64-byte UDP
traffic offered at 12 Mpps, detected it: stock stopped after 2,854,914
packets in 4.094 seconds, with 4,542 xdp_rx_ring_full events and 64
ownership/double-publication errors. With this change it processed
356,904,225 packets in 30 seconds despite 571,405 xdp_rx_ring_full events,
with no ownership or data errors.

Fixes: 3f93f82988bc ("net/mlx5e: RX, Defer page release in legacy rq for better recycling")
Cc: stable@vger.kernel.org
Suggested-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Jerome Tollet <jtollet@cisco.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 206cf9db3..7bd0606a5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -410,8 +410,11 @@ static inline void mlx5e_free_rx_wqe(struct mlx5e_rq *rq,
 
 static void mlx5e_xsk_free_rx_wqe(struct mlx5e_wqe_frag_info *wi)
 {
-	if (!(wi->flags & BIT(MLX5E_WQE_FRAG_SKIP_RELEASE)))
-		xsk_buff_free(*wi->xskp);
+	if (wi->flags & BIT(MLX5E_WQE_FRAG_SKIP_RELEASE))
+		return;
+
+	xsk_buff_free(*wi->xskp);
+	wi->flags |= BIT(MLX5E_WQE_FRAG_SKIP_RELEASE);
 }
 
 static void mlx5e_dealloc_rx_wqe(struct mlx5e_rq *rq, u16 ix)
-- 
2.55.0

