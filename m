Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794840430;
	b=a68pnmMEXQkqcW7SgD9rvsKfQL4M0bJmwyek+aJl6zEmyJuvBzeZjiUni7iwmi2PR8oi
	 CqAie956mxtEssnQjj41fKAqng0fReixaBZPvbbCEr2kUx87tDFgl6A0Ze2voIL6WiKsT
	 ne/ztTo2p9JaonSXjhwH6yWGroO03bthrJMFLgQnPByMdhdCmuui42jmTJDmc5qIgWfLE
	 ih7i+P9hl+jtXoqqx16zRCLJpVUsUJKjmBK5zlGZ50XmJe+yBEJ1Jc1F703QTN3W/TGof
	 iJ6GSx45xw9/KvL1KRHHoKDZI5DjXERkOyJ2U2V/gEZGoTzeqQ1Sa9/I8k1IM0xd37Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794840430;
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
	bh=RxP/DehxF1FC4jxAOiPVZ4okncaWb8ujODqp7QKzUHs=;
	b=jo7vj27wTsUt0vM6Wv47SM02b+tTOlIutlxQKi6XGL+e/ObAZ9EB073pdZdl7U+lOF+w
	 iQMjx5RRnK2ytSqJ5drjDj0SknsyAzP+lxVWnGoKAxKp7XawS7PxHVPLtIULmGaBJT9qv
	 E+AO1XLGujD7RazMPbtsXw/EjMuDZAZdR3It2iPo5tRieOyz2AGzh+WD915VeRUfuaKL/
	 NuCWiEcMUHQI3Yy9JRjYG9u1Y/urm/TXovRwhAiAAjDRDz2QXQOjNBIJn8Qe0PClyfV9N
	 ND/S30VcS91iUKZ/YqY6rfx3yRtZXPEMFQx6SWFi/KAzi24g2X2FgMj/OUJ+/dnlEXg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=DOVKozLS;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.45
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012045.outbound.protection.outlook.com [52.101.48.45])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E7A606A887;
	Mon, 16 Nov 2026 14:47:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 07E7A606A887
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=DOVKozLS
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tsnf4q0NUL0Lva+jWrTpdtDaPFf+o9Cc18yqdIRema2JptCzorwkXLdANvdeSShQZpMgNRq9jduPncV0TgE5PuebnLUPVMR2Vb00+AFu6a5Kkt/NXkx9ep/Y3jxxARMKZcgBE69YMz8TMwiTpjGSMv8tsXa+6CgcVSO/q2nQ/73ULUvmcfsA1vGoBnAi5IcBNwfLRnvhj2C0EGG+UCgUgpcMzirTgq/VhfrFxkRlWXf2JSaa/ibSl+kmYVkoW1ZA28sKe0YTFUIdbpsooZ5vWHZ9m3I/rbJ5dM+ZgZ6/qc2ERNVGpIBQojraPwO8CV6mOVmOVvvhMrS0LE0tsVqvpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RxP/DehxF1FC4jxAOiPVZ4okncaWb8ujODqp7QKzUHs=;
 b=KJKC2Qu0DXUKoWtG/zJ0T647hLk8weps7UnkPaMBgyxpN0wy1OqTnM9EosO6xNDWocTj8AU+iHtikh0GXL9PTU6z+gt81b2W4TLB6R4WZpKpCOsxi2qiEaZfcXh31zbayJWXpzTcVIuFwOhlu5BAAJU44ctThaBTvK1ZdVAnpffoVXD7CE4bWlB9KDXWDbjcASXBkKi8L3N9Yv9eOFZtcuzS3S2XLc4hZazQst1YcWWLP2KbjLqgAblM6uiSI1gpWe2S+yytibMGD1vM9gQVa4TJXfXU3l6P83wf40YDaaJcOT0uyXYvfXtzMowHuLPQWkVIoXU1ByEKnS+vU4ZGeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RxP/DehxF1FC4jxAOiPVZ4okncaWb8ujODqp7QKzUHs=;
 b=DOVKozLSb2SHY7Iuv/xBQBDTlOEiOKNMdsHN33C0H5oSXlGGWrNGEvUPv85hyNgBrnFRS34mLjQKiQWo6q8Fpv7i3aaYYm4HAIgpGP7qGHj2/VS2XFzPVVhXgBJzaQ8EL8YszsCvVDzKRoHeVQ78ZZ1T26ykxRfLVBGUf5hId2Rs4+DMewVvFe3fAW4zTFcqtsfH5Bo7GYFjCnYc/jJSeAdT6gKmaS9xkSHDrbIw5SY254azSIw/ysweYaEtbLOd0KXcJ9JWwJvWoTI8xpT3vHi3X+oEDMZlEITHmuOMQsEpI1AdScGq7/XxlDgiu0g0/sxs5TIlml8hMI95ygj7qg==
Received: from CH2PR16CA0010.namprd16.prod.outlook.com (2603:10b6:610:50::20)
 by CH2PR12MB9518.namprd12.prod.outlook.com (2603:10b6:610:27e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Mon, 16 Nov
 2026 14:46:58 +0000
Received: from CH3PEPF0002457F.namprd04.prod.outlook.com
 (2603:10b6:610:50:cafe::34) by CH2PR16CA0010.outlook.office365.com
 (2603:10b6:610:50::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.9 via Frontend Transport; Mon, 16
 Nov 2026 14:46:55 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH3PEPF0002457F.mail.protection.outlook.com (10.167.252.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Mon, 16 Nov 2026 14:46:55 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 16 Nov
 2026 06:46:35 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 16 Nov
 2026 06:46:34 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Mon, 16
 Nov 2026 06:46:30 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>, <linux-rdma@vger.kernel.org>, "Mark
 Bloch" <mbloch@nvidia.com>, <netdev@vger.kernel.org>, Saeed Mahameed
	<saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
CC: Andrew Lunn <andrew+netdev@lunn.ch>, Chris Mi <cmi@nvidia.com>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, "Gal
 Pressman" <gal@nvidia.com>, Jakub Kicinski <kuba@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, Moshe Shemesh <moshe@nvidia.com>, Paolo Abeni
	<pabeni@redhat.com>, Parav Pandit <parav@nvidia.com>, Shay Drori
	<shayd@nvidia.com>
Subject: [PATCH mlx5-next 3/3] net/mlx5: Add MLX5_PCI_PF_TYPE_QUERY_PF to mlx5_ifc
Date: Mon, 16 Nov 2026 16:45:54 +0200
Message-ID: <20261116144554.1194389-4-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261116144554.1194389-1-tariqt@nvidia.com>
References: <20261116144554.1194389-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF0002457F:EE_|CH2PR12MB9518:EE_
X-MS-Office365-Filtering-Correlation-Id: d729464f-0a0a-4efb-2e42-08df43f07570
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700016|1800799024|23010399003|82310400026|10067099003|11063799006|56012099006|261021121427099003|261009223027099003|261102123227099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	wpBxtJndngxbUDutZhi1LvVsYXJFdKC6VdglDJD0jlLwj7BQSo7dYXo7+Fmy9ZY9mA5Vu/MTzD+b25h4fgAjhJFP/4F+PDrtZFw8GbxBBZpBaJXccqHBYGXrFQFg+vL371y6/kUOx1QLJJDDWBr698RqkjnLrse9LdlQTQd7MhNQSVabvfnFtJRluiVW0OeYem1QpaN4R/OQbWS7MMrTHV2twclxPVhP1KRB9Kgnk+hjNVy+cdyb9OEU4sAgzQjnJnCLZx3k1Kbh6gJQ/0kJYcF4MMn+/Qfi5ksryWY/pWJx2eaJVxI1tXD3VjpAzTWicSNyHlfrYm9AeLY58l4y1eGjdsLUByfua+Q2tPl2oIwsB1Y2yiomMJ6Oxqxn8NwYaehACLdpK/z3MJptyqC7qBj4kjAvnJGkFIew8S1elGoPsG323IJI0ObpS+j73JwFLyA2a+RLiezF5ULQ5cd0u4zNs8IxW4NjTXDPO6VzQEbLQ22tS9gOvIQYu+gWavFCyfHzZ1EUkeY4FYaWFJSxXuC34qcYy/Vi9ygILQTPv/ptZu6jrU9RPLRD85YqHm032H/yO1v8SjfZ+4+8aJrH7XTtG1Q0AmwqPZSoqyoUyGVZYF6z1T0dPfjoFJYsbwxdT3yUnyVOnsrpTkQRHgiTlLQySNRYkVzhAdZMhRH7Htsh78IV9C7so+JpF7AVWx6kkEEG90ahw37XsA7/jTbw2g==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700016)(1800799024)(23010399003)(82310400026)(10067099003)(11063799006)(56012099006)(261021121427099003)(261009223027099003)(261102123227099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	2gsxsFcQWnwuvBAQ77vVrUFWbq05fhFJ7dCmgYqZn+A4BZ5EHbdPCIqJOxu/SEZ1jWy9cbWK1BvVqbfL/Rf8T1svTz9sapRBUDY19QwxQJunfVCiNaqKA2vOafAjhpEKhewDcOmuRFjTAdZG016ZGjjjx0NFEx+Ler8N6LiOYbDExXoyPmStA6w5q//mDGjM9hoCYKPtIZ8Io3EOJR/yZ2J1K2H2cWgp5Z71SbFI84BOFwbW9ZzZqxxJ/zWaOY1JkasP96P3Ve34ykfsYQaG9IGNILS3wHo6fblr/Wc0Ptt42QHVJnEj3v0ltMp5GaUrz+qAVqoceGOqwRcgAldh15biuKMjik2itrYBT3NXy+67ick/ws0oLNMlCAD8IWrXM+McRZ8iUQ8sZ8gcGkDCbRGpi3e+ghz0xd+ZjscN5ZnN6Hqlp4+UVmewZbclMN2H
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 14:46:55.0009
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d729464f-0a0a-4efb-2e42-08df43f07570
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0002457F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB9518

From: Chris Mi <cmi@nvidia.com>

FW exposes a new PCI PF type value (0x2) in QUERY_ESW_FUNCTIONS to
identify the querying PF itself, allowing the driver to read its own
host_number from the firmware response.

Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Shay Drori <shayd@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 06e17581fa51..cb9b8a908523 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -12913,6 +12913,7 @@ enum mlx5_ifc_vhca_state {
 enum {
 	MLX5_PCI_PF_TYPE_EXTERNAL_HOST_PF = 0x0,
 	MLX5_PCI_PF_TYPE_SATELLITE_PF = 0x1,
+	MLX5_PCI_PF_TYPE_QUERY_PF = 0x2,
 };
 
 struct mlx5_ifc_network_function_params_bits {
-- 
2.44.0

