Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011035.outbound.protection.outlook.com [52.101.57.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 287E93FF8A2;
	Thu, 30 Jul 2026 09:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785403207; cv=fail; b=P0+JxVOHg1DakWQ6jPF2Ef3gktx/ldzehFZb7eNSWAuU53lWNjGLPoFO0hB4sViv7Ihy6DIpAUthm/ZD5mwQLX3xnOIXSsQ9GOLGMqioijLBc53UuT6rS23rQsRyB1OyHywRWeB6/RwGh/lYj4Mx+h7NKofhTbQJQ5VwUMpRa+A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785403207; c=relaxed/simple;
	bh=bfQNML775xZLqEJn4AMYO8JSu4/oE1+GqAuSjn22hSY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JoeqJKndjY98c+9VNwI1B+j2GtvbbmbQfZKlVGlYW+Zd+hIK+mzJMpfkctJxdM1iS66qu84czNB/XqjDVM95Arq3eTJHR6dThHit0D/5DQJwouY4PcGI4AvF4VnHpyRyYiBcOyQqte/zGvWF26WUQjU/HB1+PyZrSVzlyfSE97s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NZ/CpL5j; arc=fail smtp.client-ip=52.101.57.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NZ/CpL5j"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Jx3sOoYX0Q2USZTIPKJnSJIFk1ou5Dd7OGtNg2c/p6/hTDkesUquacul5um4HWEE0n3m4C58aweGz30uHvV+uRxr/ADjXwS5oNI++vP/YeiIArPVnko7L4l7qo5vkaSKP6CqfidQfAY8w8ZjgIUvGa/CQQPcUXmTHb1nY4x5u5M3yGNzLyG7shMxYdksOaeyUw04V6JMUjTkKxtcED7fBaelk7Tf1/TUnkptGt8wMMaSn4xAQz+ycKaS0p7SjvdXLI1EX9FPU8vuSHnDy5HiUbZcXrWhgl3IeCte9Gztm64tL7LTGDkAmyJrmv1h4ABB70dG1h71Jd9y8/VGKC9E3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7FfU6jR0F/JKdkyoTFATa1lhB9OBmyV3xWJnz4QGDs0=;
 b=VrHkUlAh7rVfEyApqYSTvfE1/xGmqKXMKx2fDfj+RYppdUPf3wWTpRElnDDsZLYAA8L7M9sO8Mdbhlxs38RY5M0Pk6jdaEMCU+SbjZkWPOS1wgCaDurxI47pwSLZYlPgiYyBqOAVmvt7RAu7NWZxhYMZJBaj7ke9O2aIK75z+KgX/aNWBR7pAAuuSKDaiv5/7AhwlO0Hhx9XaiibFEUhW2IXLjSAVK6XdKe8rM8EW2/pp4l2KKN3tGNMDTJkJkmmBboNaNX+k7KQQNFMUDeaS1jOk3ueBAjuBGrqTm90SBqhnI/40MTgIwWlp4lDPyoYn7Y3pCcts7UxMHPvinZFBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7FfU6jR0F/JKdkyoTFATa1lhB9OBmyV3xWJnz4QGDs0=;
 b=NZ/CpL5jawMd/LukXULzUr33xKXjsZctB9gbmSoTY3R087Y/ULbrRb2uftTfaWDja4LZBjYFD76wX5tG8tgKxyRw9L68jFfDBwcdG4rZehvqpiJ2NwqARPzJcOm46SO9nFRvfMwIOplVZEfyBw222+KcCXu0178CmeTEUYJZaPKCiDkMF9q/QvBRZKRGqmp/6fW1oyBTTdubJNX1XIRpyo99KHXEfevclQXBRj7u+hga/WYiieQW4+zU0nuieq4wqGO4iIk1rGJW2O7OtfHEyxNQv2Xg0K60mA8kxx1HmamcK4oDcGYks89DJCe1Dvr93mZ8mBHY+Sdw2bFXJakq+w==
Received: from SJ2PR07CA0021.namprd07.prod.outlook.com (2603:10b6:a03:505::23)
 by DM4PR12MB7550.namprd12.prod.outlook.com (2603:10b6:8:10e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Thu, 30 Jul
 2026 09:19:59 +0000
Received: from SJ5PEPF000001CF.namprd05.prod.outlook.com
 (2603:10b6:a03:505:cafe::7f) by SJ2PR07CA0021.outlook.office365.com
 (2603:10b6:a03:505::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.14 via Frontend Transport; Thu,
 30 Jul 2026 09:19:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ5PEPF000001CF.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.8 via Frontend Transport; Thu, 30 Jul 2026 09:19:58 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 30 Jul
 2026 02:19:44 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 30 Jul
 2026 02:19:44 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Thu, 30
 Jul 2026 02:19:36 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Sabrina Dubroca <sd@queasysnail.net>
CC: Aleksandr Loktionov <aleksandr.loktionov@intel.com>, Alexei Lazar
	<alazar@nvidia.com>, Boris Pismenny <borisp@nvidia.com>, Carolina Jubran
	<cjubran@nvidia.com>, Chris Mi <cmi@nvidia.com>, Cosmin Ratiu
	<cratiu@nvidia.com>, Daniel Zahka <daniel.zahka@gmail.com>, Doruk Tan Ozturk
	<doruk@0sec.ai>, Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman
	<gal@nvidia.com>, Jacob Keller <Jacob.e.keller@intel.com>, Jianbo Liu
	<jianbol@nvidia.com>, Kees Cook <kees@kernel.org>, Lama Kayal
	<lkayal@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, "Patrisious
 Haddad" <phaddad@nvidia.com>, Raed Salem <raeds@nvidia.com>, Rahul Rameshbabu
	<rrameshbabu@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan
	<shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Simon Horman
	<horms@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>, Stanislav Fomichev
	<sdf.kernel@gmail.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next 10/13] net/mlx5e: shampo: Flush session on PSP mismatch
Date: Thu, 30 Jul 2026 12:17:52 +0300
Message-ID: <20260730091756.2543777-11-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260730091756.2543777-1-tariqt@nvidia.com>
References: <20260730091756.2543777-1-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CF:EE_|DM4PR12MB7550:EE_
X-MS-Office365-Filtering-Correlation-Id: 044be725-b81a-43de-b012-08deee1bba35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|82310400026|36860700016|1800799024|3023799007|56012099006|11063799006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	2T7cIV+sz3Y2liEJfY9DWKnS+hrK2s/zeHkXKaY4aoNszpamIyxe1RzWCWEe0ojafw+kL73XYTYRlT5orgAt7d8unJqQGyW+JgZrvZeWo5S/H8shnjDqGRH9uqqXvb6P9KEmq8BwJHs13nZYBavU2EIXRYpknpVlO8Vp+B+HH1GWyHxEc4x7hf1m6Kqp/jegp3Evk8a5up9fJMBMTNzD3R4xi9SSqKKsklFlBwyzoh5LPEDt6hfEjpShZ8mgoJBSo44lWfI+FzfeZF7OJ6RIPmt5EzmB7gOiqdcpzWOMZD0Ky6c2fLw3WOzg5Msuye1kV1IVidOaakz5psaTM/e5vNDOOauDkHF1y/iyfMhIhhia5YF0R79etADs1o0itA9qpjg1GamL3Nq/g9N1gWlgeL2fqN1Lt/vP8au3uYStAK2b/6bkhWz2ZbYeNICPxTyE+4VgAUxQGOukScZFAKSO8JtTduhG7QhvaJ9MoM3+U8EkNjBLX9rTgnrDSjgC5f2KLS0GEkztV8PnEJ0Xm4YeCj7CGdR2R8fGjG4VO29FAtsBT6VTuf4fHgWVrLq049EBhgsgIU8jemHkfYQABs0YoIzboaJCY/oTBoHzDEMiD6S1ysHywmKBEodkoTs5FotKgxMZZBKMKMOx/oL2mdUFZN7jJ4o21EIpgo0gpu+Zq78S2M0N2VY6Li7uNVs7Xg+fTdrvrmHz/X/hcYyRu1Nnfw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(82310400026)(36860700016)(1800799024)(3023799007)(56012099006)(11063799006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	yLezRa7BLzaM9mnb69l5B0xF4mBYMGPUFS9SO2h5l+yA61gTmNHcJ5sd8cVL8Tjm4Fpp0uu5k24EFVBLtyGMG8rGsw0onaU7t65Cpydc4LD6+8ghwU8pnUlxDN1pMV7pYvizMVszqDm/me72GbhUe1DvK/Ded26KH5tRvIw+YJRVnPoX/OGOmmhtnWSrHb4cPFr5cR5haD7uCG95OrM7D/O4CbDiH0ULEYK8DsAHlD6Tsuv3BcNLM3FznSIDPAwbF83C/KNmCT8tQEQEyxP9oOOPiG42WKQGzHTaOFZTRVhW4UX1izbl3sbZ150prgYyrn214qqi6k53wAEcd3atHwJXnJ6wbqddi7VUZNBoGlD14jABGV9hfnk3jBVNRUoMRo1Szju0RbO5AUPcWNscwWkaSyaNO3H2WIOCoo2bQXOW7uKU7Pml2bc3lTr6zTHn
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2026 09:19:58.8414
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 044be725-b81a-43de-b012-08deee1bba35
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7550

From: Cosmin Ratiu <cratiu@nvidia.com>

Flush SHAMPO session on PSP status change (no PSP -> PSP or vice-versa)
or on SPI/version mismatch. HW aggregates by 5-tuple but is unaware of
PSP fields, so sessions must be terminated when security parameters
change to avoid mixing packets from different PSP associations.

The session is also forcefully flushed if non-decapsulated packets are
received. This could happen if, for example, the decap table could not
be created so HW GRO is active but there's no decapsulation.

Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 32 +++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index fb7110b1b683..c7eaab3f7967 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -2221,6 +2221,33 @@ static bool mlx5e_hw_gro_skb_has_enough_space(struct sk_buff *skb,
 		return page_size * nr_frags + data_bcnt <= GRO_LEGACY_MAX_SIZE;
 }
 
+static bool mlx5e_hw_gro_psp_match(struct sk_buff *skb, struct mlx5_cqe64 *cqe)
+{
+#ifdef CONFIG_MLX5_EN_PSP
+	struct psp_skb_ext *pse = skb_ext_find(skb, SKB_EXT_PSP);
+	bool is_psp = mlx5e_psp_is_rx_flow(cqe);
+
+	if (likely(!is_psp && !pse))
+		return true;
+
+	/* No match on PSP status change (no crypto -> crypto or vice-versa). */
+	if (unlikely(is_psp != !!pse))
+		return false;
+
+	/* SPI and version are only available in CQE metadata for decap flows.
+	 * Non-decap PSP cannot be matched here, force a flush.
+	 */
+	if (unlikely(!mlx5e_psp_is_decap(cqe)))
+		return false;
+
+	/* No match on security parameters change. */
+	return pse->spi == mlx5e_psp_get_spi(cqe) &&
+		pse->version == mlx5e_psp_get_version(cqe);
+#else
+	return true;
+#endif
+}
+
 static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 {
 	u16 data_bcnt		= mpwrq_get_cqe_byte_cnt(cqe) - cqe->shampo.header_size;
@@ -2258,8 +2285,9 @@ static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cq
 	data_offset = wqe_offset & (page_size - 1);
 	page_idx = wqe_offset >> rq->mpwqe.page_shift;
 	if (*skb &&
-	    !(match && mlx5e_hw_gro_skb_has_enough_space(*skb, data_bcnt,
-							 page_size))) {
+	    !(match &&
+	      mlx5e_hw_gro_skb_has_enough_space(*skb, data_bcnt, page_size) &&
+	      mlx5e_hw_gro_psp_match(*skb, cqe))) {
 		match = false;
 		mlx5e_shampo_flush_skb(rq, cqe, match);
 	}
-- 
2.44.0

