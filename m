Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.9
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794336013;
	b=FZJDIv5H24M9ZUgDFY6YBXUAOnF1Re0HtMHlRwQEa5MTWE3cIH/ksU+++Pj0eqFoc4uv
	 9beB9T3lXFRjDJ49obs5XnPzSVVwFdyRLOYjWijj5WgeXnvXPZZkyuYunVJWp1FAl1Nxg
	 SC+1icTN+S+dBKAMBPKeSR1Hmjp+W9huIEoSOg/ZPMpuflCle8d4bNswS9FlBx4XkJZaR
	 io0w0htxE2eJLsWnGevw++LzVUqibzSYSAvaLvvOdI3XYx9lvyD7hxaG9uFzFsm60kXSA
	 Z7a+eUyLpg6cvH+7H3P6Wxtd87DDYbCyKNPlgZkbVSeIHdZHEX2BjTUGb3hZgjarO6w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794336013;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 Content-Type:X-NV-OnPremToCloud:X-EOPAttributedMessage:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=Xnr2mMAj85NUIoHpSYz1f3MJWmaA5vKBUIcf9vEa5WM=;
	b=mI/vBpzsFpq6eGZrIpZ8aVAk+tL53w0k+VMUmYwH3XmqqzMiQzewL27lhov79/iQg/Dk
	 J3UKawKj8UWHUESkYiGzKw63LQBdn6jx+SFeDVPRCKkDBr/4YcVXRUOvQoWPls1zNS6qQ
	 tWAiuRtEed09gzsMtLlMHxiE3GmCbo/SjRVb0GrleA/OBr9ncxfQs7wb9py1MWbJ6qHPr
	 SwatlfM9TlintG8gA2I2Ej3KpAeZv4Q0RWVfFpfP+WawJkDFlz+Ow5K9R2uWCyylLLdn1
	 wkgioeHnd6vkveqsNr6X8o0LQT8w7mhoAif7TTGvI7BGiRcBfcz/W4rtzqYdJQ7OCdA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=oBdTeD5g;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.9
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012009.outbound.protection.outlook.com [40.93.195.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3DD460A6F5E;
	Tue, 10 Nov 2026 18:40:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B3DD460A6F5E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=oBdTeD5g
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nOM/QOVCoiIxENfmg1MMwy3gwl4XYM1jbjY935Z6LfsjUHUSz/kLCE+CMKqxLHbQN6HsoIdPYcDO2fw9v0ohIcN2h8frqYSOzmnGyKPp4RmsZWKVy/ubGF56Rl2BiNfIgi8I4fjaZFI8tPREGuPCpt2os/21GqVonZnseat5gM/RmSIJkPzsYcJ6QQxAHxGj0fl5sxbWJTgemoRdhSK33Mj7HDh42z5M2Mz3SgDkDPfDmsKXOJY1b8UEltCd1KUv3pLlnM7TYxD8gSJnGO4UKz6aRBaiZhVO8IvPTdFeFOg0J4/dn+06ED4ylF5K4kcEkJgrCj3kLewJfexe3oTvXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xnr2mMAj85NUIoHpSYz1f3MJWmaA5vKBUIcf9vEa5WM=;
 b=Ji3tPdmkVyxIod/sjeHJPfCBUYw+RDPfVHAUz1cVO/dS4p8qQZce6nbjKHTF4ZMZXRLz1q2JWgNZGdp6yCdD+/U/775ww/ikocayM3zUxBBVw0+oTSo75P2I/igShZM3nifPk3h7ngU+kmeAuZttaI/F6UYG/hLzBB1Wh8RDA2LhYNjLX0d3zZa15aSudhEhq72KKoJ5/2Ta7nX1MAn0ZDiogP0/1YQHHT4/dKguzi7JSM6QVKsB53mpyp8omQ9hP/ifaWWNtLEqyPViE4zJNn1WbIiC6cwUpdUuAO/0jfP1dSVyzs8/Fu5oUDSpIKmw7oD8glrzOVeQ001swZIl8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xnr2mMAj85NUIoHpSYz1f3MJWmaA5vKBUIcf9vEa5WM=;
 b=oBdTeD5gSRK2RcHRNtDwkZgQGZluFZSAABTqEHAAB4XsmqoBpV4Uopkmci40NonMxW3si4NJE6qaXt8wxrm7AKUH+b82bxN5+NIeQpH35hwItdb5Iylidpk/6w+vcIW39NZXED9OE4NwIVUGWokUI/3h1MKyjsYv9HnJ+oHMDR9p3+JN/AVS9a3z528RO4qr+8bM8YY/lpGk9SaudUrlbmhCKkNTczkx7wl5sPNclSO2pGKzdUgwMi1NXuOlhx+8ZKMoqWn1J6X+jvbL0JdT6Hv99JizDz/JxmsIzA06VscvTb5V/+KZWFxZPCrBP9DWDFw/eZ5a+2MemMWt6SoE8g==
Received: from CY8PR22CA0012.namprd22.prod.outlook.com (2603:10b6:930:45::13)
 by IA1PR12MB6307.namprd12.prod.outlook.com (2603:10b6:208:3e5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Tue, 10 Nov
 2026 18:40:03 +0000
Received: from PH2PEPF00048919.namprd05.prod.outlook.com
 (2603:10b6:930:45:cafe::62) by CY8PR22CA0012.outlook.office365.com
 (2603:10b6:930:45::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Tue, 10
 Nov 2026 18:40:03 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 PH2PEPF00048919.mail.protection.outlook.com (10.167.243.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 10 Nov 2026 18:40:03 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 10:39:42 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 10:39:42 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 10
 Nov 2026 10:39:35 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Bobby Eshleman <bobbyeshleman@meta.com>, Carolina Jubran
	<cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>, Daniel Borkmann
	<daniel@iogearbox.net>, David Wei <dw@davidwei.uk>, Dragos Tatulea
	<dtatulea@nvidia.com>, Erfan Sharafzadeh <erfansh@meta.com>, Gal Pressman
	<gal@nvidia.com>, Jacob Keller <Jacob.e.keller@intel.com>, Kaifeng Wang
	<kaifengw@google.com>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Matt Fleming <mfleming@cloudflare.com>, Mina Almasry
	<almasrymina@google.com>, Nikolay Aleksandrov <razor@blackwall.org>, "Saeed
 Mahameed" <saeedm@nvidia.com>, Simon Horman <horms@kernel.org>, "Stanislav
 Fomichev" <sdf@fomichev.me>, Stanislav Fomichev <sdf.kernel@gmail.com>,
	"Tariq Toukan" <tariqt@nvidia.com>, William Tu <witu@nvidia.com>
Subject: [PATCH net-next V2 07/13] net/mlx5e: SHAMPO, Use page_pool DMA sync helper for SKB frags
Date: Tue, 10 Nov 2026 20:38:20 +0200
Message-ID: <20261110183826.2927274-8-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261110183826.2927274-1-tariqt@nvidia.com>
References: <20261110183826.2927274-1-tariqt@nvidia.com>
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
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH2PEPF00048919:EE_|IA1PR12MB6307:EE_
X-MS-Office365-Filtering-Correlation-Id: 83fae15c-d199-4dc6-5f3c-08df3f5a08b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|23010399003|36860700016|261009223027099003|10067099003|261026121527099003|261026140227099003|261022105027099003|261022075727099003|261028144727099003|261021123027099003|261021121427099003|261102123227099003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	xRkFAlYMDvEp24hLMywfJ+1ePBAmb9zqtzXiYg/t1NJYleZnGIZruUOxQNLoxHx0GtJ5bsb52q2NEbNTWffan80EZIdn8a1NkF+v8ufjiP9fDDNMa7R4sa2PQ2AZ0DbwSJgSv6AA8NbL12DtxjbF/GVby9+bIJ8+b/hxh2GbjEPvImUUWgh1Qw7I/LnLxaTts6wc0X8ZriRt1aKqCy+O0JQLT/SdjjJRroiyARW98kAA9doWEvXmxPSCn7blWqGP1xOWBki8hBEUK0w7uxRwuGaxuxs9QpSLtPw2DzovBqWPIGVsHE06im3UwhiTK6aCstzeD0GVT13y+yeL+/DNdePUdvOffoVGMV16bTrLqmLOtY2EoEHoKPITo/uAA2GkUqwpp0wMR5wXn4We6ZuDj5XGrC7wOb7ab53mXzH4EgXm5W/smCUfv+2CsArQaPh9rLMOyPqI4sA4hIGMwBPet1od9ssdKaCBxUw6RiKCjHDjaBtjSb0jVbmT5rkzSV3U3JMyhCfo8lWCQm4QeIjVSaK4KEGSl583eTS63mqzLGhVCtnWEGBaRB0kBqxc50tQXK3+/8Yf3doquFWPUkIJnXacbpoLAAFzcWBmyKbo/vmI0y3DdDg0jmWGXeqlvn0RpGXpYgfFRxQYGBTSa24WgtSglR7DlPYwxkP/ZboiCO0/5ttbdJoh/Amc1jKkgBqi
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(23010399003)(36860700016)(261009223027099003)(10067099003)(261026121527099003)(261026140227099003)(261022105027099003)(261022075727099003)(261028144727099003)(261021123027099003)(261021121427099003)(261102123227099003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	XXVDMshAXFYdRKAS4tk0rbf8nuzOvoQ9/JNNBsCfpeJTVRDbFO1hZuX8kiFZQ0lOgdL4zfTqA60CHwi83kf9ic/QZXQLkVcMLj6tzoOKMNRjldIrKpoPBHbNrLL5W9ciLHqj1/Mfw0ktomOI7u9ALfkH5YgibgYLe1TriHbxxgJYxwRmxlm/RtdTmGUsWBjBnmXovblDyTNOaiJ1Ilq5oHDioCtCQQAGzryDbANVCNMrerctdxN8fII1Ve+lqLejnsvP8i9QkKGPgwh12Ks4TkjHBZyLoA7XMVy3Sn5+LhadYBQOseUOb79LjlO64FJsSPK9LoptIvnCXZ0yF+oly3X8GAxzR/V8UnlkHPn12aZYlQMThkNM/iYsDtK8BUi/u5jv61tzziZdjRbXSBZOJT1JBA3qIgLzm2G95qGrae9ZJGWm/Yh+3hTWXkIY+g+U
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 18:40:03.4879
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 83fae15c-d199-4dc6-5f3c-08df3f5a08b3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	PH2PEPF00048919.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6307

From: Dragos Tatulea <dtatulea@nvidia.com>

Switch to the page_pool DMA API which takes care of not calling
dma_sync_* for unreadable netmem. Do it only for the place where it
makes sense: SHAMPO payloads, the only RX buffers that can be
unreadable.

Until now it was ok to call the dma_sync_* API directly. But with the
introduction of data direct it will no longer be correct: the payload
netmem of a data direct RQ is mapped against the data direct device,
not rq->pdev.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 0f9a946aef41..9db3db5246ab 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -560,12 +560,11 @@ mlx5e_add_skb_frag(struct mlx5e_rq *rq, struct sk_buff *skb,
 		   u32 frag_offset, u32 len,
 		   unsigned int truesize)
 {
-	dma_addr_t addr = page_pool_get_dma_addr_netmem(frag_page->netmem);
 	u8 next_frag = skb_shinfo(skb)->nr_frags;
 	netmem_ref netmem = frag_page->netmem;
 
-	dma_sync_single_for_cpu(rq->pdev, addr + frag_offset, len,
-				rq->buff.map_dir);
+	page_pool_dma_sync_netmem_for_cpu(rq->page_pool, netmem, frag_offset,
+					  len);
 
 	if (skb_can_coalesce_netmem(skb, next_frag, netmem, frag_offset)) {
 		skb_coalesce_rx_frag(skb, next_frag - 1, len, truesize);
-- 
2.44.0

