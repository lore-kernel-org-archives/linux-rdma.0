Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B4630F95C;
	Fri, 31 Jul 2026 18:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785524136; cv=none; b=P8v+koF60KX1bRgMwZKpB1xJBP/tYJFg4wMFAxrGp/pgLU4O0K/sFP7+yEtWzSl+nmAz8rsDVZ/8jLoQgnGHRoDdgL0ADGX/VS1cIUr4yHgSKE8B8QBmPO0N/wLk0+zeIDoyDNFk6AgUZiSt10Dwk7SZadg2hOR0CcgU0jnQKss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785524136; c=relaxed/simple;
	bh=aHPNGOna+Ur0Y3imTtG0r3LmSmd2dAjy2aH4h4liSGU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=IqFJM0xY/dIVsbyQggXOL7RcfbVLwaYNBOWmjijPMt8zIC1W3L60yCoeaI7FgWP4enbBVE7ImHYpTsPfTHA1Himl31ml87KeUC+h0xR6DxRnVpbTE34rquIQvJVNriYnNVKxBovB8uAggTziZBV8izAG6a4ZYcpsMvSvZ5FZTDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=Q5KmDO5H; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="Q5KmDO5H"
Received: from pps.filterd (m0528004.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66VIhmb21946352;
	Fri, 31 Jul 2026 11:55:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps82601-s2048-2026-q3; bh=PL2StkL0B
	74vie52VIhYkIwSiz/TtLj9D3k1myIfQFs=; b=Q5KmDO5HORRwSkCGEnCsP3wmq
	oCOpxNifB+EqmyU3k9Z37bn318pmcJSovJUYUCztvm7x2OxwsWdzbNUn4qWz/yVa
	PVWHvKgf6+GmoEujVmvNRoBoiY18eit7vjkzoZvCpcTsbH7KrcWgACqnaa2ZB9w4
	1SLZCED5u7jZDybrKcE8ILVDJgwcyPEw9TCWFqc0/FfwbbSo6wo1AH8lQRMwMcY5
	NqSxWwmCrpNyBP1qdkom03c3LnmTZPvhEHqgwGNd8cdbV9dWIBBJ0i2rhPLsPChE
	EgM6WNV3SsOjWczzypKFa+1qP6+gRnK1za/DvocWd9OJe3x0dYYC4hT5WQbIw==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4fs0dsgd4h-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Fri, 31 Jul 2026 11:55:24 -0700 (PDT)
Received: from localhost (2620:10d:c085:108::150d) by mail.thefacebook.com
 (2620:10d:c08b:78::c78f) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.45; Fri, 31 Jul
 2026 18:54:51 +0000
From: Glenn Judd <gmj@meta.com>
To: Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
        "Mark Bloch" <mbloch@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
        <netdev@vger.kernel.org>
CC: "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn
	<andrew+netdev@lunn.ch>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Khalid Manaa
	<khalidm@nvidia.com>,
        Ben Ben-Ishay <benishay@nvidia.com>, <linux-rdma@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Glenn Judd
	<gmj@meta.com>
Subject: [PATCH net] net/mlx5e: strip runt Ethernet padding in HW-GRO (SHAMPO)
Date: Fri, 31 Jul 2026 11:54:42 -0700
Message-ID: <20260731185442.2778723-1-gmj@meta.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDE0NCBTYWx0ZWRfX7ayE+5QuhamI
 1KVWAWq88qMDZVMYm1rr68ww/QE94EXw8Uv3rRc8XdG/L91JZiVk7oB3uXRP8ohtT7H25AjlYVl
 WwbxOnVQWW933iZOOsnj8Cmd/uKzqug8LePrbe/jMx4NGd19y4Xpxv+eC80m6+0ZhXtN8LI/YN7
 pT/rDHCVbDWYktHod25YqXg1NJ5csQUh5UP68v7JtonIkBXI7kGMsYShOT5DUS28jQYntHXizYa
 XJWMrZbBu4vjDe0BPlXyMzcU9c8JbkX4WD3P3yaFT4JrWWA1aTN63jmewb2XTZxT105e760lVi7
 KfKhtamSu8CK/aDgOkmBP++3FnsPxsHSjFoc7aQNVbXjue9nclYHfnNLY5/AlyEBapYF6Q/vXMD
 iBu5NNCh9Uw5eBsXrDPFQo3C8xzzraeiQFOAKdIAXmJ82QJDRgfC9qNU44d49xz6WaXUMOsY22N
 V00T2B7fEiXBIiIpQKg==
X-Authority-Analysis: v=2.4 cv=Du9mPm/+ c=1 sm=1 tr=0 ts=6a6cef9c cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=GbPsI2Ihf5RTnMjR_gZv:22 a=VwQbUJbxAAAA:8 a=VabnemYjAAAA:8
 a=62cyLJc1qmirCwmxprMA:9 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDE0NCBTYWx0ZWRfX4BGKaUMUUe4W
 oRbRnPOw2PFIhzE6kWSCPJ9/DEgq/jVTZBnon9lEH6Xa3ol7ULpZ+3kIjvbp7c1xPCuUHJgLV/u
 rGD7ycgS4+2zfZ2N/prEAJGhwY/KKvc=
X-Proofpoint-ORIG-GUID: F8Xjo9kK4tWvpiGHdn3gwEe5EEZe0sno
X-Proofpoint-GUID: F8Xjo9kK4tWvpiGHdn3gwEe5EEZe0sno
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_06,2026-07-30_01,2025-10-01_01

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
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 72 ++++++++++++++++---
 1 file changed, 64 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 6fbc0441c4b8..0b40db3d50aa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1506,12 +1506,41 @@ static inline bool mlx5e_build_rx_skb(struct mlx5_cqe64 *cqe,
 	return false;
 }
 
+/* Real (unpadded) L2 frame length, or 0 when it can't be determined. */
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
+	nhoff = ETH_HLEN + thoff - sizeof(struct iphdr);
+	if (skb) {
+		iph = (struct iphdr *)(skb->data + thoff - sizeof(struct iphdr));
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
@@ -1525,6 +1554,13 @@ static bool mlx5e_shampo_complete_rx_cqe(struct mlx5e_rq *rq,
 	if (!skb_flow_dissect_flow_keys(skb, &rq->hw_gro_data->fk, 0)) {
 		napi_gro_receive(rq->cq.napi, skb);
 		rq->hw_gro_data->skb = NULL;
+	} else {
+		frame_len = mlx5e_shampo_frame_len(rq, cqe, skb);
+		if (frame_len && frame_len >= cqe->shampo.header_size &&
+		    frame_len < cqe_bcnt) {
+			pskb_trim_rcsum(skb, skb->len - (cqe_bcnt - frame_len));
+			skb_shinfo(skb)->gso_size = frame_len - cqe->shampo.header_size;
+		}
 	}
 	return false;
 }
@@ -2244,6 +2280,7 @@ static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cq
 	struct mlx5e_rx_wqe_ll *wqe;
 	struct mlx5e_mpw_info *wi;
 	struct mlx5_wq_ll *wq;
+	u32 frame_len = 0;
 	u32 data_offset;
 	u32 page_idx;
 
@@ -2263,11 +2300,22 @@ static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cq
 
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
@@ -2311,10 +2359,18 @@ static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cq
 
 	if (likely(head_size)) {
 		if (data_bcnt) {
-			struct mlx5e_frag_page *frag_page;
+			if (NAPI_GRO_CB(*skb)->count > 1 &&
+			    frame_len >= head_size &&
+			    frame_len - head_size < data_bcnt)
+				data_bcnt = frame_len - head_size;
 
-			frag_page = &wi->alloc_units.frag_pages[page_idx];
-			mlx5e_shampo_fill_skb_data(*skb, rq, frag_page, data_bcnt, data_offset);
+			if (data_bcnt) {
+				struct mlx5e_frag_page *frag_page =
+					&wi->alloc_units.frag_pages[page_idx];
+
+				mlx5e_shampo_fill_skb_data(*skb, rq, frag_page,
+							   data_bcnt, data_offset);
+			}
 		} else {
 			stats->hds_nodata_packets++;
 			stats->hds_nodata_bytes += head_size;

base-commit: 8ba098e6b6ff0db8edf28528d1552be261af30d4
-- 
2.53.0-Meta

