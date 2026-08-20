Received: from aer-iport-2.cisco.com (aer-iport-2.cisco.com [173.38.203.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10B6637F8A0;
	Thu, 20 Aug 2026 15:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.38.203.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239035; cv=none; b=eEGoXeZab31NRRG1nxiRAH/8tk8K+pDfqd5UoZBIgvj0EAWrRf0T7zq2ROnc2/fGFLTuC3kErtSLkX4HW521AtHVVnaCrRNmQvSmP70mEQ5iBDFFZZazNWf0nHXXRsuUP5I3O+4l6RwGWHw8zE2NMNCqN9S4IH3++d+7i8D+54w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239035; c=relaxed/simple;
	bh=9tQDRFhd3wdV5FEfnVhIZnx9Ia6FJoaawSaIHD08LwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KvmvOWGeiZRAUNsysslwMsC+EZzwY30QTr/hB1mjtIw0g1EC2RAH/kKd97/dyBE/nul0Wgu0qww7/GdzkMxz2DCyMRI39jKy1CYRCGdtT+tKlOPt9jQM2jMM3qXrTBAy4F9WVMP2M0gWMH/Jlu7Rw/4J/W+/7Xm220lxAjXysMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=jszvXurX; arc=none smtp.client-ip=173.38.203.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="jszvXurX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=2543; q=dns/txt;
  s=iport01; t=1787239033; x=1788448633;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=H3GM0tkrFhtaJZ9C4vxeVGTYG9Srj/tiMnOdb9uhbgY=;
  b=jszvXurXzXgvukwba7qQLxYfTYxOLTr2DfCKTy84j+fDpa1DyFM+W8Zp
   uT7YDvAIiSn2Vebni1OJTycf5xRAg6HvXp3ZHepopVAzi5z587arMPMVp
   WXUDlvaHhjGlUdpziQ1KIy+Vo46ip1VrI9JgpGpDsxFmYMW8kl19cWsaD
   REAgKgT/0aLJWwvZReKO9hjm41YAoI2HXOYMxTJ2IoKDy6lB1AQa8/NII
   lIbepBwUb4j4PEaL24LT402NYZfBY5ACMqWdBe/hHn7IHvY6rxmgFjyHP
   dS6bMfOXjEOy7Mhpi5//GjEwICEItDw9O0DwAyXpIKU+nNYxFVavUnvuc
   Q==;
X-CSE-ConnectionGUID: VL25NchoRuSnO/3b0bF9eg==
X-CSE-MsgGUID: 0lvXl/60RvePSpQCOqLo7w==
X-IPAS-Result: =?us-ascii?q?A0AbAwCFGYdq/9RK/pBaglkCghY/dF5DSQSUJYIhgRadC?=
 =?us-ascii?q?IF+DwEBAQ9EDQQBAYUFjW0CJjQJDgECBAMCAwEBAQEBAQEBAQEBCwEBBQEBA?=
 =?us-ascii?q?QIBBwWBDhOGTw1JAQwBhgYrCwFGgVCDAgGCdAMRwhOBeTOBAd5HgWYBBQYUA?=
 =?us-ascii?q?YE4jWF2hHwnG4FJRIEVgnMHb4UQhXgEgy6TPkiBHgNZLAFVEw0KCwcFgWYDN?=
 =?us-ascii?q?RIqFTI8Mh2BIz4XgQ0bBgWBHVlPhDcjGTZ8gQlegSsqYQESF4EJggoCgl+CB?=
 =?us-ascii?q?QIBSUMOBxULGA1IESw3FBkEPm4HjkUggkMBMSIxChQYgRopAk8Fk0oBgyqwI?=
 =?us-ascii?q?4QojCGVOhozl1+TDZkIjgqWGYUggWg8gVkzGggbFYMiE0AZD44tFoEUAQKHX?=
 =?us-ascii?q?McIRTICAToBAQcCBw4DC4FoiGWJGQEB?=
IronPort-Data: A9a23:4o3gzaJSntzkWHU6FE+RGZUlxSXFcZb7ZxGr2PjKsXjdYENSgWBWz
 DMdWGqAaPnba2Gnf99xat7l/RkDuMDcy9Q1TQod+CA2RRqmiyZq6fd1j6vUF3nPRiEWZBs/t
 63yUvGZcoZsCCSa/kvxWlTYhSEU/bmSQbbhA/LzNCl0RAt1IA8skhsLd9QR2uaEuvDnRVnQ0
 T/Oi5eHYgH9i2Qsajt8B5+r8XuDgtyj4Fv0gXRmDRx7lAe2v2UYCpsZOZawIxPQKqFIHvS3T
 vr017qw+GXU5X8FUrtJRZ6iLyXm6paLVeS/oiI+t5qK23CulQRuukoPD8fwXG8M49m/c3+d/
 /0W3XC4YV9B0qQhA43xWTEAe811FfUuFLMqvRFTvOTLp3AqfUcAzN1QKBtrG4YY/dxqOmdps
 qcScDojPx2M0rfeLLKTEoGAh+wqIdOuOMYUvWttiGiAS/0nWpvEBa7N4Le03h9p2pwIR6uCI
 ZVFL2A2NnwsYDUXUrsTIJAim+Osi2XXeDxDo1XTrq0yi4TW5FEgj+O0YYaPEjCMbZ1RgHac4
 TyexXr0OioCDfe40B6CrW3504cjmgu+Aur+DoaQ+vd0jVi7ymUNBRgSUlWn5/+0liaWQN5RA
 0IT/yslraUsskmmJvH/WB2+5nCNpQIVUddWH8U17QiMzuzf5APxLmUIUztIetE6nMAxQjMu2
 xmCmNaBLTBmtryYTVqc8biZpCm4PjhTK2IeDQcNVhct4NT5pow3yBXVQb5LEKeqjfX2FCv2z
 jTMqzIx750QkMQC/6a251bKh3SrvJehZgcz6h/aQSGj4x91aZCNY5Gu7x7Q7Z5oIJqQUkSFs
 XEsndaf4OEHS5qKkUSlROgKGquuz/CbMTHdiBhkGJxJ3zGn/3mofahW/jByJU4vOcEBERfya
 ULetQZ54oFSMHqjK6RwZuqZF80wzLH8PdL7V/zVZ5xFZZ0ZXBeO9ixoZGaK0mztmVRqmqY6U
 b+RaciEE3kXE+JkwSCwSuNb1qUkrgg6xGXOVdX4wg6h3L62enGYU/EGPUGIY+R/67mLyC3R8
 tBCJ46QxxBWePPxbzOR8oMJK10Oa38hCvjercFLeuOdChRpFXtnCPLLx74lPYt/kMx9jfvB9
 HWwclFXxUC5hnDdLwiOLHd5Z9vSsY1XpH8heChpNlGy1j16OMCk7bwUcN08erxPGPFf8MOYh
 sItI62oasmjgByek9jBRfERdLBfSSk=
IronPort-HdrOrdr: A9a23:kzVhxK5aTdXeIu4EDQPXwPzXdLJyesId70hD6qm+c3Bom6uj5q
 KTdZsguyMc5Ax6ZJhCo6HiBEDjexLhHPdOiOF7AV7IZmbbUQWTQb2KlbGD/xTQXwvj6+Vaya
 BsN4J6CNH2EBxGqPyS2njcLz7lq+P3l5xBQozlvhNQcT0=
X-Talos-CUID: =?us-ascii?q?9a23=3AwAIpEmqm24MblKv/HLkFddLmUf4BKCD7x3fXGVK?=
 =?us-ascii?q?DD0EuE7fNQ3HB9awxxg=3D=3D?=
X-Talos-MUID: =?us-ascii?q?9a23=3AV/sligw6M9IlnjNkvhpxvIsCGU2aqPyqFnAJ1st?=
 =?us-ascii?q?egdeJDRdoAhy6lRCwHZByfw=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.25,233,1779148800"; 
   d="scan'208";a="59731942"
Received: from aer-l-core-11.cisco.com ([144.254.74.212])
  by aer-iport-2.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 20 Aug 2026 15:15:58 +0000
Received: from localhost (unknown [10.190.15.114])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by aer-l-core-11.cisco.com (Postfix) with ESMTPS id AC8A8180001F6;
	Thu, 20 Aug 2026 15:15:58 +0000 (GMT)
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
Subject: [PATCH net v2] net/mlx5e: Prevent stale XSK buffer release on refill retry
Date: Thu, 20 Aug 2026 17:15:58 +0200
Message-ID: <20260820151558.11015-1-jtollet@cisco.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Outbound-Client-TLS: ANONYMOUS;unknown [10.190.15.114];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 10.190.15.114, [10.190.15.114]
X-Outbound-Node: aer-l-core-11.cisco.com

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
Changes in v2:
- Reorder and tighten the problem statement.
- State explicitly that the failure produces no warning or splat.
- Add Dragos' Reviewed-by tag.

v1: https://lore.kernel.org/netdev/20260819151320.64178-1-jtollet@cisco.com/

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
