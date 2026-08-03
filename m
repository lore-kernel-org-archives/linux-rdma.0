Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 315AD3033E6;
	Mon,  3 Aug 2026 21:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785793478; cv=none; b=nMnVmQ8/dgfsRkU0oGIKWnllek6rBxWA0RHOdNOloZ2MaeixU1hgVxOkXMnTbSDH3obqIfI8bSWo6cV/nS9nd+h83eJaTpsjMMrVdbbzlmCGgILnNhOdmQ3xurjQAakzelGQlBh/0NsFXYQSeFqjkoGcMFvewDiAM1FaO5X51pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785793478; c=relaxed/simple;
	bh=ULiYtnXvAGjcv1/CLOf2lcGu7spytV1c9ncrzCyxRWQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VZLYK6uGllaAw6gawZZP//Kt/h62wUKCp69mzCbI4LcRkoRq4342Se6xrU6tUdHfYrGmByL0d4HGRFGcI1V3Xb37nLl1264n3TCbwtiWSrAs7YGVrDNrJ9QQa4MHyUESJJkHtGqdJ9KP2TQ8ectQ2T5rPVBgqGrmDRYDgLhd4Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=K1eb8yaA; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="K1eb8yaA"
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 673JksgD1793947;
	Mon, 3 Aug 2026 14:44:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=XMsdDT2bEwVn2FX1qqg12gAlQv2XDbXEGKFOC
	zsvISQ=; b=K1eb8yaAVu+PbJZRKDzyrGhNMeSRtFsAIBqQ4RedCBlikvuz7x+g7
	PmMwmemYwQ2ORjSfJQRXQzcBKUXnnsI8sQIAW9D4jLTQnX1B+GcFZl35sZ/V1rSf
	cpJmyKli/tOP0ixlccw1IkYb6cXImFqMT6bMJ2JaHB3bOXB5odceq53OM0XHg3Fv
	crtL6EEZuZ3sdnKPiS8HjsZU2Yyie/1B2xhNpJth6fSr4fUT2tkcji51EivCgPvm
	tUZj7/SbUcQnrk8Kdl3sH1vQscNg24/mLirDVpRXs5MNxe/QdNicgjPSyiQWRrci
	7esuORatRvik49kS5ITDxZ58c9nu7fuWw==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4fsc41w9sx-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 03 Aug 2026 14:44:24 -0700 (PDT)
Received: from localhost (2620:10d:c085:108::150d) by mail.thefacebook.com
 (2620:10d:c08b:78::c78f) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.45; Mon, 3 Aug
 2026 21:44:21 +0000
From: Glenn Judd <gmj@meta.com>
To: Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
        "Mark Bloch" <mbloch@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
        Khalid
 Manaa <khalidm@nvidia.com>,
        Dragos Tatulea <dtatulea@nvidia.com>, <netdev@vger.kernel.org>
CC: "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn
	<andrew+netdev@lunn.ch>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <linux-rdma@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Glenn Judd
	<gmj@meta.com>
Subject: [PATCH net v2] net/mlx5e: strip runt Ethernet padding in HW-GRO (SHAMPO)
Date: Mon, 3 Aug 2026 14:44:12 -0700
Message-ID: <20260803214412.1714151-1-gmj@meta.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260731185442.2778723-1-gmj@meta.com>
References: <20260731185442.2778723-1-gmj@meta.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: QW9xP2YinD68qpYdOYCibQHbwOECx2L0
X-Proofpoint-ORIG-GUID: QW9xP2YinD68qpYdOYCibQHbwOECx2L0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODAzMDE5MCBTYWx0ZWRfX6812KTZjCGrH
 O9le0VK7EtIUACKVnYvRIDGxumURbO/Q0rXI8pMWtcEpSfSImGOevlN0+LIZkNuEgiBNcw6N8/v
 sS3zU9qPn366JPAYpkntiW6OX22fCD3090GpC6iZO/WTWSeoB6Dh5HChTpr5o5BKC9Nwzj4h4/l
 eegAYPNN7Lubz1hRfv5ELYcYje2STHRi3we9eDSvnN0zkd2YQfZdLBFPLxf60nWPGmcNCSZEWCH
 Xtes79COqtUUREDJoHeKygSU30tvP4F0XGXNsgMrb0djTAcfpOYexIkltB/pLReh1/lhoAAKwx2
 lb2PbpxqQfgk/qdan0HImw/00p5Bh39ZenvS9QAtq1LdCKiGqbRzpHNHUUFDcw9whQY/J0xM4lR
 cuF/0wDwQONBMqxYOl8BRo0BXFDz19PulklWJA9IX9C8YHrEHklrOF9u7CtrulI0X/Rhzbo8mkA
 PlA+5feZqUV59eOBLRw==
X-Authority-Analysis: v=2.4 cv=A7Fc+aWG c=1 sm=1 tr=0 ts=6a710bb8 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=8elwO82fXORLTBIkMd32:22 a=VwQbUJbxAAAA:8 a=VabnemYjAAAA:8
 a=0fCniEUNQRSzQiW46QAA:9 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwODAzMDE5MCBTYWx0ZWRfX8nTxAfWaY1FT
 L2Pkj4G0dHuKmXUB2juCXh/pbIvLfHrJa+xuB5fQZnqK3AGQuLhoI0naaKOUR09SxWse6kFy1D0
 YiJoRUYLN4j0f9ZOeC8DCG1PcaRcOi0=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-03_05,2026-08-03_02,2025-10-01_01

When hardware GRO (SHAMPO) coalesces a small IPv4/TCP segment
that was padded up to the 60-byte minimum Ethernet frame, the trailing
padding is folded into the merged payload.

The selftest tools/testing/selftests/drivers/net/hw/gro.py subtest
hw_ipv4_data_lrg_1byte sends {100, 1} expecting to receive {101}.
In current code, it receives {106} (100 + 1 payload + 5 pad) instead.

Fix is to compute the real (unpadded) frame length from the segment's
IPv4 total (padded) length and drop the padding before it is merged.

Fixes: 92552d3abd32 ("net/mlx5e: HW_GRO cqe handler implementation")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Assisted-by: Codex:gpt-5.6
Assisted-by: Meta:internal-AI-tooling
Signed-off-by: Glenn Judd <gmj@meta.com>
---

Notes:
    v2:
     - No functional change.
     - Address the netdev checkpatch 80-column warning.
     - Add a comment noting the IPv4 header offset intentionally mirrors the
       driver's existing no-IP-options logic (raised in review).
       Changing that logic is outside the scope of this change.
    v1: https://lore.kernel.org/netdev/20260731185442.2778723-1-gmj@meta.com/

 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 78 ++++++++++++++++---
 1 file changed, 69 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 6fbc0441c4b8..77ecc2496009 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1506,12 +1506,43 @@ static inline bool mlx5e_build_rx_skb(struct mlx5_cqe64 *cqe,
 	return false;
 }
 
+/* Real (unpadded) L2 frame length, or 0 when it can't be determined.
+ * Intentionally mirrors the pre-existing no-option logic in the driver.
+ */
+static u32 mlx5e_shampo_frame_len(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
+				  struct sk_buff *skb)
+{
+	u16 head_size = cqe->shampo.header_size;
+	struct iphdr *iph;
+	int thoff, nhoff;
+
+	if (rq->hw_gro_data->fk.basic.n_proto != htons(ETH_P_IP) ||
+	    rq->hw_gro_data->fk.control.flags & FLOW_DIS_ENCAPSULATION)
+		return 0;
+
+	thoff = rq->hw_gro_data->fk.control.thoff;
+	if (head_size < ETH_HLEN + thoff)
+		return 0;
+
+	nhoff = ETH_HLEN + thoff - sizeof(*iph);
+	if (skb) {
+		iph = (struct iphdr *)(skb->data + thoff - sizeof(*iph));
+	} else {
+		void *hdr = mlx5e_shampo_get_hdr(rq, cqe, ETH_HLEN + thoff);
+
+		iph = (struct iphdr *)(hdr + nhoff);
+	}
+
+	return nhoff + ntohs(iph->tot_len);
+}
+
 static bool mlx5e_shampo_complete_rx_cqe(struct mlx5e_rq *rq,
 					 struct mlx5_cqe64 *cqe,
 					 u32 cqe_bcnt,
 					 struct sk_buff *skb)
 {
 	struct mlx5e_rq_stats *stats = rq->stats;
+	u32 frame_len;
 
 	stats->packets++;
 	stats->bytes += cqe_bcnt;
@@ -1525,6 +1556,14 @@ static bool mlx5e_shampo_complete_rx_cqe(struct mlx5e_rq *rq,
 	if (!skb_flow_dissect_flow_keys(skb, &rq->hw_gro_data->fk, 0)) {
 		napi_gro_receive(rq->cq.napi, skb);
 		rq->hw_gro_data->skb = NULL;
+	} else {
+		frame_len = mlx5e_shampo_frame_len(rq, cqe, skb);
+		if (frame_len && frame_len >= cqe->shampo.header_size &&
+		    frame_len < cqe_bcnt) {
+			pskb_trim_rcsum(skb, skb->len - (cqe_bcnt - frame_len));
+			skb_shinfo(skb)->gso_size = frame_len -
+						    cqe->shampo.header_size;
+		}
 	}
 	return false;
 }
@@ -2244,6 +2283,7 @@ static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cq
 	struct mlx5e_rx_wqe_ll *wqe;
 	struct mlx5e_mpw_info *wi;
 	struct mlx5_wq_ll *wq;
+	u32 frame_len = 0;
 	u32 data_offset;
 	u32 page_idx;
 
@@ -2263,11 +2303,22 @@ static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cq
 
 	data_offset = wqe_offset & (page_size - 1);
 	page_idx = wqe_offset >> rq->mpwqe.page_shift;
-	if (*skb &&
-	    !(match && mlx5e_hw_gro_skb_has_enough_space(*skb, data_bcnt,
-							 page_size))) {
-		match = false;
-		mlx5e_shampo_flush_skb(rq, cqe, match);
+
+	if (*skb) {
+		u32 gro_bcnt = data_bcnt;
+
+		if (match) {
+			frame_len = mlx5e_shampo_frame_len(rq, cqe, NULL);
+			if (frame_len && frame_len >= head_size &&
+			    frame_len - head_size < gro_bcnt)
+				gro_bcnt = frame_len - head_size;
+		}
+
+		if (!(match && mlx5e_hw_gro_skb_has_enough_space(*skb, gro_bcnt,
+								 page_size))) {
+			match = false;
+			mlx5e_shampo_flush_skb(rq, cqe, match);
+		}
 	}
 
 	if (!*skb) {
@@ -2311,10 +2362,19 @@ static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cq
 
 	if (likely(head_size)) {
 		if (data_bcnt) {
-			struct mlx5e_frag_page *frag_page;
-
-			frag_page = &wi->alloc_units.frag_pages[page_idx];
-			mlx5e_shampo_fill_skb_data(*skb, rq, frag_page, data_bcnt, data_offset);
+			if (NAPI_GRO_CB(*skb)->count > 1 &&
+			    frame_len >= head_size &&
+			    frame_len - head_size < data_bcnt)
+				data_bcnt = frame_len - head_size;
+
+			if (data_bcnt) {
+				struct mlx5e_frag_page *frag_page =
+					&wi->alloc_units.frag_pages[page_idx];
+
+				mlx5e_shampo_fill_skb_data(*skb, rq, frag_page,
+							   data_bcnt,
+							   data_offset);
+			}
 		} else {
 			stats->hds_nodata_packets++;
 			stats->hds_nodata_bytes += head_size;

base-commit: 8ba098e6b6ff0db8edf28528d1552be261af30d4
-- 
2.53.0-Meta

