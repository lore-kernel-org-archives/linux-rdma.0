Received: from aer-iport-1.cisco.com (aer-iport-1.cisco.com [173.38.203.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360C7470E83;
	Wed, 19 Aug 2026 15:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.38.203.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787152475; cv=none; b=SRlIslwVOYQxknrVG/eae3jE2LUlFZDaTWanCxr48sKBtOWzQOFz96K7HkiaJ7RgaXJfFKd6JqbwjKo9iaMn90NELNGnX2/lQ5x1QAqp1i/NrJ5MwtjmIPEWoJQbU+RnbYMTw9WSvbbsa8NE3iUJ1bzVB34xojsA+1S8lWjNL3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787152475; c=relaxed/simple;
	bh=zqSv/r76W9l/vCHZOtgIJA3OhfpLFkpe04JwLmL/zQU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BnsxSDRmmRP+dWRzO9JhxQlYBhwcWAx6+vpiImTlJr1AEI7XnxxIhFWIa7TUPTSirDE+DT/67z3joZ3Vzzy75p6kRHuexaeUlWDskPh5pku6YXfPcdN/7D0Yo/yvBKBpUPIZhhPBPoLrh/k2RglyfwgTMFeKPuSBHiyAvCaC/rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=bnjdI5XT; arc=none smtp.client-ip=173.38.203.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="bnjdI5XT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=2113; q=dns/txt;
  s=iport01; t=1787152473; x=1788362073;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=BT/1geWvzbCsOdVjm5QCMwK7eKF2uxxLhDfc7l6NaUU=;
  b=bnjdI5XTX0KNs9glkjFnXEbzdj23nQRGfSjVF1kkycZOPpzU/4zU2G6e
   dRk4UFu9JPPSa8Ql/UIolrhHVkxOG25OlrrgNDef0se7W/4sAOiC+Nv0T
   RsqTbsHSDCmOweQ+4GV8Lb73yn5dZfV5/Yyszt4Dztd8kap0ZCs85tniH
   +umUJVavHhHd1ITiLCHgrPXYSAc5xvUB4c1vmOHuBmz1uxyM3a+8lKXOw
   PEZAF7k0xZLse6FWXb3mol0+S0o5inadRhB4KzyN3nwiZPC3tdP2lXeQu
   N+N0DdoYa7MvEmSbB8EghNVhdlD7yJgRkPVt/iepGtSgP6haOio1vHjPz
   A==;
X-CSE-ConnectionGUID: kn8oH9HrTOaQG2nd3YCRQw==
X-CSE-MsgGUID: wgr1Kk05SxauYwF1FN7Yuw==
X-IPAS-Result: =?us-ascii?q?A0BAAgDaxoVq/8pK/pBaglmCGD+BUkNJlCmCIYEWnQiBf?=
 =?us-ascii?q?g8BAQEPUQQBAYUFjW0CJjQJDgECBAMCAwEBAQEBAQEBAQEBCwEBBQEBAQIBB?=
 =?us-ascii?q?wWBDhOGXIZdKwsBRoFQgwKCdQPEJ4F5M4EB3keBZgELFAGBOI1hdoR8JxuBS?=
 =?us-ascii?q?USBFYJzB2+FEIV4BIMuk0FIgR4DWSwBVRMNCgsHBYFmAzUSKhUyPDIdgSM+F?=
 =?us-ascii?q?4ENGwYFgR1ZT4Q3Ixk2fIEJXoErKmEBEheBCYIKAoJwggYCAUlFDgkLCxgNS?=
 =?us-ascii?q?BEsNxQZBD5uB45JIIJKATFdFIEyKVaTSgGDK7AihCihWxozl1+TDZkIo32FR?=
 =?us-ascii?q?oFoPIFZMxoIGxWDIlMZD44tFoEUAQLOZEUyPQEBBwIHDgMLgWiRfgEB?=
IronPort-Data: A9a23:L+Q1Ra34Ra0PEyQZqfbD5bpxkn2cJEfYwER7XKvMYLTBsI5bp2BVx
 jAcCG/VM66PamegethybN6+pxsFvJ6BydQyTQJt3Hw8FHgiRegpqji6wuYcGwvIc6UvmWo+t
 512huHodZ5yFjmH4E/xbtANlFEkvYmQXL3wFeXYDS54QA5gWU8JhAlq8wIDqtYAbeORXUXX5
 Lsen+WFYAX7g24tYzpNg06+gEoHUMra6WtwUmMWPZinjHeG/1EJAZQWI72GLneQauF8Au6gS
 u/f+6qy92Xf8g1FIovNfmHTKxBirhb6ZGBiu1IOM0SQqkEqSh8ajs7XAMEhhXJ/0F1lqTzeJ
 OJl7vRcQS9xVkHFdX90vxNwS0mSNoUekFPLzOTWXcG7lyX7n3XQL/pGD0dmOq1J2vxLJmh32
 qYeJGs8RSq6mLfjqF67YrEEasULJcTxeYdasXZ6wHSBVLAtQIvIROPB4towMDUY35wSW6yDO
 4xGNXw1NE6ojx5nYj/7DLo8gOCsgnTjWzZZs1mS46Ew5gA/ySQsgeeyaIqKJbRmQ+1KkVzBh
 WGeol/pCwwrK/LG5xzaw2+z07qncSTTHdh6+KeD3vJjnlCW7mAaFhATUVy1vb+/h1LWc99TN
 kkd6Ccyhac180OvQ5/2WBjQiHKNuB8RX/JRFOI34RuHzbqS5QuFbkAHUzRIQN8rrsk7QXotz
 FDht9rvCSZir/6TRG6R+6m8qS60P24eLQcqaTMNURYB7tDLpp8yghPGCN1kFcaditDyHyv36
 zaUrSQ/jvMYistj/6Cx+VfMgxqquJnFTwdz7QLSNkq+5w50aIuNYZKp5VnSq/1HKe6xUlCbv
 WEYs86A7ewPBNeGkynlaP0EFryv5t6fPTHciEIpFJ4knxyp+ni+bcVT7St4KUNBLMkJY3nqb
 VXVtAcX44VcVFOubKlqc8erB8Ej5bbvGM6jVf3OaNdKJJ9re2ev+ixyaUOO937inVJqkqwlP
 5qfN8G2Ah4yErhuxj67b/kS3KVtxS0kw27XA5fhwHyaPaG2bXOPDLNAO1yUY6VhteWPoR7e9
 JBUMM7iJwhjbdASqxL/qeY7RW3m51BibXwqg6S7rtK+Hzc=
IronPort-HdrOrdr: A9a23:7Qp0Ba8bMhM7T6MbZm5uk+DsI+orL9Y04lQ7vn2ZhyY4TiX+rb
 HNoB1173HJYVoqMk3I+urwW5VoI0m8yXcd2+B4VotKNzOIhILHFuxfBPPZowHIKmnZ6vNX07
 tmfuxVDd39CkU/sOPBiTPIdurJBLK8gceVbSC09QYIcT1X
X-Talos-CUID: 9a23:yWHOFG/w0URldbQAeV+Vv00SSscFI13H8FDZGmDiD2oyeZavcEDFrQ==
X-Talos-MUID: 9a23:5agqAwUw1Viasxzq/CDjnmhBN5812LSnFXESv8wonZa1KDMlbg==
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.25,231,1779148800"; 
   d="scan'208";a="59770877"
Received: from aer-l-core-01.cisco.com ([144.254.74.202])
  by aer-iport-1.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 19 Aug 2026 15:13:20 +0000
Received: from localhost (unknown [10.190.15.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by aer-l-core-01.cisco.com (Postfix) with ESMTPS id 01B34126625;
	Wed, 19 Aug 2026 15:13:19 +0000 (GMT)
From: Jerome Tollet <jtollet@cisco.com>
To: netdev@vger.kernel.org
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH net] net/mlx5e: Prevent stale XSK buffer release on refill retry
Date: Wed, 19 Aug 2026 17:13:20 +0200
Message-ID: <20260819151320.64178-1-jtollet@cisco.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Outbound-Client-TLS: ANONYMOUS;unknown [10.190.15.25];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 10.190.15.25, [10.190.15.25]
X-Outbound-Node: aer-l-core-01.cisco.com

When an XDP redirect to an AF_XDP socket fails because the RX ring is
full, the XSK core frees the buffer. mlx5e later visits the cyclic WQE
and frees its XSK buffer before trying to refill the slot.

If a batched refill succeeds only partially, a missing WQE keeps its
old buffer pointer. The buffer may meanwhile be allocated to another
WQE, so a later refill retry can free a live buffer through the stale
pointer and publish the same UMEM frame twice.

Mark the WQE as released immediately after the driver-side free. The
flag is already cleared when a replacement buffer is assigned, so
refill retries no longer release stale pointers.

A standalone legacy cyclic-RQ zero-copy libxsk reproducer, using
64-byte UDP traffic offered at 12 Mpps, stopped on stock after
2,854,914 packets in 4.094 seconds, with 4,542 xdp_rx_ring_full events
and 64 ownership/double-publication errors. With this change it
processed 356,904,225 packets in 30 seconds despite 571,405
xdp_rx_ring_full events, with no ownership or data errors.

Fixes: 3f93f82988bc ("net/mlx5e: RX, Defer page release in legacy rq for better recycling")
Cc: stable@vger.kernel.org
Suggested-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Jerome Tollet <jtollet@cisco.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 6fc6605d2..7967a2737 100644
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

