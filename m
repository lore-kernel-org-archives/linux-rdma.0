Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B6223E33D;
	Thu,  6 Aug 2026 06:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785999443; cv=none; b=X64j8Wi/Gf7PTL8wM6Irp+X6lekpP+2QoDmGnxHDYOmBbk3qIJNqW+EE2Fsg0MvXU3khHfZnKaBP+9Mey8QqsFmtuyKkHScLB4+LCIYbHvRXTSF1qlGKalTBBTYXm2iFFuCiuEp9NeO1X2mrLVtQy4jVVPrrsAZUcm5YqEbWvIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785999443; c=relaxed/simple;
	bh=8fov8siOUQ/ZPsb4A+0iemwS7egXU5qk/c4rmCcyuC0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=VBGAiObHeY+Bz4n5mAijZK28R+cf4LPZhMapOYC5ag3t1k+doNC6bZ9pnbeYP7lS5aFZ8yFjP+i+QumG8nY4Txsc9lXbReD9l1mOjzVb6SZLLNUeTYKUdgqFwUOPnkB1YP3x63wHv8hU6dboIP257QY5aSZvOBY6j3MHTs46wJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=QGXxeCAc; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="QGXxeCAc"
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 675NblpQ312197;
	Wed, 5 Aug 2026 23:57:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps82601-s2048-2026-q3; bh=3u37kiuvA
	6RlHfpkPzL13oX2UNzl3sBthf5IzqiiOqk=; b=QGXxeCAcaCEQ1wnuIcElbSnE6
	ddykqo9euLxzQpn15RyBidRE8B6cE13KoAZnFWLM59H3TsVExm2Q+5NhgbWdnUuZ
	oy08R0trY+MtC0i9svdIyFQBe/RnEf1MzeTuxOunS32EORizroNjCHRuN9bjqavN
	2jUZr+j3/2NBLu/oxH3SxOcbfcm/4jnei0XxkJVkjyEz2dGgPCSZxbnPgBhoX2Bq
	Z3eKiDfdyCOMjj7LPQUJJo+pG/QkjlxvvtXbFpJSfHw3C2J51j3kBjPr57lvopa7
	S7Ef1jHEvwuUyAe5SLJKG0/rLV9LzfrKNS3zcA5E4aJmlT+noLNSujoK5ilCw==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4fumgemkha-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 05 Aug 2026 23:57:04 -0700 (PDT)
Received: from localhost (2620:10d:c0a8:1b::8e35) by mail.thefacebook.com
 (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.45; Thu, 6 Aug
 2026 06:57:03 +0000
From: Glenn Judd <gmj@meta.com>
To: Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
        Mark
 Bloch <mbloch@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
        <netdev@vger.kernel.org>
CC: "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn
	<andrew+netdev@lunn.ch>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Khalid Manaa
	<khalidm@nvidia.com>,
        Dragos Tatulea <dtatulea@nvidia.com>, <linux-rdma@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net v3] net/mlx5e: do not HW-GRO coalesce small frames
Date: Wed, 5 Aug 2026 23:56:50 -0700
Message-ID: <20260806065650.2444999-1-gmj@meta.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDA1MiBTYWx0ZWRfX0yLGtkYAmwnl
 2W/22AUkV2MMuz4z2xZa6l63vLnhbSgo+xIc2UNo5m7JeufjjP3sem6fHcEdoyqCYXjBkVKYUIp
 3kTZ8u4xe8cSiwpSmA6/LjXh3CeWzGcX4K8BMqaZsD4Y6K+VtUZWuf/AFJK+Zc9U/9EbknY9qMu
 o60FmQjyKu6PW0Fjy9tWML0NOLVh6+p7bMO+vqkiaGJpw8/QtREfOmYiIYGdtfhCz3bQt3PavYT
 wmtRN0UYbbdbv0yDLwjPfGyDx4QHeeB34GoeadsgUxeK3c53N25pJQUtCVkXcPCfcmij/1u0ZFc
 pXdZjWj953IEHDlBR9CesQy8SEsvNPxtYwS2Pr+AHZgiPYWeA5LdNLX/aiHl9q9Y8F7T3bF/QWZ
 yYdDNCA7bEVCPLW5DgZifYks0TNTHOC9YM/vJGeMyttmPvBKQ9mbhIa9gVdHKWi+4RRn4pTDGUF
 B9+Amnw3IIlmalc2jNQ==
X-Proofpoint-ORIG-GUID: nC811fwNVK99RnNI6SfolPBjcuWLD-yg
X-Authority-Analysis: v=2.4 cv=I4xVgtgg c=1 sm=1 tr=0 ts=6a743040 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=tpM8CJlwf7uhpglF1g9U:22 a=VwQbUJbxAAAA:8 a=VabnemYjAAAA:8
 a=dqT7Y9b5xjMEFiSigBgA:9 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-GUID: nC811fwNVK99RnNI6SfolPBjcuWLD-yg
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDA1MiBTYWx0ZWRfX6hJrlmgUUsz+
 3R/cwtO/Mj6wB8ZPa+R+6eXprE6VDuP322W9fTfcEmH9SsHZgCgXfHAcY+Fq0Mr957KzJD9Nzsn
 1yvpFcs4wThwLLJ/3OkcNOoeGlMkmzE=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_06,2026-08-05_01,2025-10-01_01

When hardware GRO (SHAMPO) coalesces a small IPv4/TCP segment that was
padded up to the 60-byte minimum Ethernet frame, the trailing padding is
folded into the merged payload causing padding to be delivered
to the user as payload.

Detecting and reproducing the issue: the selftest
tools/testing/selftests/drivers/net/gro.py subtest
hw_ipv4_data_lrg_1byte sends {100, 1} expecting to receive {101}.
In current code, it receives {106} (100 + 1 payload + 5 pad) instead.

This patch avoids giving the user padding as payload by simply not
coalescing small packets (which fails the subtest; the same approach
and behavior as sw gro). This gains code simplicity at the cost of
more computation (passing an extra skb up the stack) for small packets
that could be coalesced.

The threshold is chosen as ETH_ZLEN + 2 * VLAN_HLEN. This is the largest
frame that may still contain minimum-frame padding (+ 2 VLAN tags), so
anything larger is safe to consider for coalesce. (We do not include
ETH_FCS_LEN in that threshold computation as netdev_fix_features()
drops NETIF_F_GRO_HW whenever NETIF_F_RXFCS is set, so retained FCS
can't reach this path.)

Fixes: 92552d3abd32 ("net/mlx5e: HW_GRO cqe handler implementation")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Assisted-by: Meta:internal-AI-tooling
Signed-off-by: Glenn Judd <gmj@meta.com>
---
Notes:
    v3: Per reviewer request, redesigned to simply not coalesce
        small packets. Dropping the v2 padding detection/removal.
    v2: https://lore.kernel.org/netdev/20260803214412.1714151-1-gmj@meta.com/
    v1: https://lore.kernel.org/netdev/20260731185442.2778723-1-gmj@meta.com/

 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 04af54b704d8..68b4dc49ccea 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -2263,6 +2263,11 @@ static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cq
 
 	data_offset = wqe_offset & (page_size - 1);
 	page_idx = wqe_offset >> rq->mpwqe.page_shift;
+	if (unlikely(cqe_bcnt <= ETH_ZLEN + 2 * VLAN_HLEN)) {
+		match = false;
+		flush = true;
+	}
+
 	if (*skb &&
 	    !(match && mlx5e_hw_gro_skb_has_enough_space(*skb, data_bcnt,
 							 page_size))) {

-- 
2.53.0-Meta

