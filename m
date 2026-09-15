Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013026.outbound.protection.outlook.com [40.93.196.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD6F4A204F;
	Tue, 15 Sep 2026 11:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789471216; cv=fail; b=a4Wi+6AXSF9ou7cDBfbzUo37PFVGHjOjx65hYfRMq61wpDHi1FpNltYJ9H9gaH0jOj7ovsnuNWX1GiPX99t4AzVqooLX4IMyTcWzLqZDnEAjLYyk0k5tcmRRjwN+N9jIV+qNU6CgqI97mZUjdFvOOKq4kU8FjKcoUbCswRvipc0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789471216; c=relaxed/simple;
	bh=jfi+zfQfXZsDy7xj41tIlv601FdM4cUyVR0ihfCwE4M=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c9AaTrtjyfFDmj3F72tAlo/hlHtScedCo6pZNOhIngu9c8aF4/ePXXlGNYAvT/gyCUDJp0AkfVwTKYycIlqDREmirLALXoCJuUTBz0MUruQBa+q0JNCWKAqFIYg+CZ7O8W5KjJuYA+7cQ2D2oQvz2aV92Zgq/JK1JIQQ/0NAC5g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=d1OAnp7z; arc=fail smtp.client-ip=40.93.196.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="d1OAnp7z"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pPP7I8YmXWXJXf+K0MiZgESiJLkHUfp3v8FQAvxOJ3e3cYLgiANsVTFcqbmGkzYAkfUKJzA0XU8ZLuklSZNSnAX4v4syvXDa2XPhxTtq0RDPiKswS2vm4s0VuwCJIcZh4oERx+sFhHq++J7oEUAViwhSB6w5ppMESD+2URbAiMOlpyDO6NUuy9/Y5e2sENSlPQ9QJ0Byvcl52FCeWDNtrBFisxMpDTVhF5I0ZG1Ai2GCyzyjsOwn+5UCwXI2ZWHknSRdypNFBwVPtVlgVdcKnzg10M3Xcuc6YX9Ey+RshI4fZGPTBqHW0ouMBKzL1cUehITm67MsxTY7wcaAIUeygg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tcrWdU4yZbBCPInaHyX/pqgGA79fcTjdJFPINGseoAw=;
 b=mTPjdx45XQv2/CZkf1EKdStyhGmMI1DmS2uDCYJ4/EMpTc3qpsT6B9N8G5kL1LC9wZ7FapDMPiYQnOhfObpnL1X8xVzgeECfjPsgB2Wt8OP6NxjkKLyEVGlxnbsjvQNAaP5cr2DccQ/Hq2j+BdTzvr9/RTa8el8jqmZgp1qJFt/FSKn82NC3AT/GxXZ6ksuuaF+Q+t9R8mpGTfqz2Y0BFD/RpY+nGJisX3DfqxOFfc5jpyXxsI0QH8i5vfffkKYkigVLlB/9qtxUqUYyqVQ3ntoP+O/KqzYuukR3objknmnukPtDXcHnqu0Ma6n5XD3b6qq88vpSiP1C7dNWKwf7CA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tcrWdU4yZbBCPInaHyX/pqgGA79fcTjdJFPINGseoAw=;
 b=d1OAnp7zqJupPr3clbjsLnbouDAD3sci/dZeaoPuoRIeTVe5xjY/L6JEzWux9OxbURa/BUsaJtYL27j+P3PNuc0H7EL83lDSuZrT9qoGNW3th46mk6d3orTlKVCAwI5fVaEk86oraBS5lJtV1AccAVpwia75nx0dER7/VK+2IOl8K1pwTlYdPwrZqPBpmjDBv27e4Jzu40DGjXwJuViKgjdu9v3J3O4jkowqVeMTZ9tSvstY1786t4610pz0MttnDW5Ldzs9hKKVTfVbFut/rvOKIo2GtesVu+SXNNKPBosTfGKQWNOKVkuLqAJRTabyAvO49xUQObC7w+9CJbiZTw==
Received: from CH5PR02CA0014.namprd02.prod.outlook.com (2603:10b6:610:1ed::18)
 by DS7PR12MB9551.namprd12.prod.outlook.com (2603:10b6:8:24f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Tue, 15 Sep
 2026 11:20:06 +0000
Received: from DS2PEPF000061C3.namprd02.prod.outlook.com
 (2603:10b6:610:1ed:cafe::4) by CH5PR02CA0014.outlook.office365.com
 (2603:10b6:610:1ed::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.9 via Frontend Transport; Tue, 15
 Sep 2026 11:20:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DS2PEPF000061C3.mail.protection.outlook.com (10.167.23.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 11:20:06 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 15 Sep
 2026 04:19:53 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 15 Sep 2026 04:19:53 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.46 via Frontend
 Transport; Tue, 15 Sep 2026 04:19:49 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Erez Shitrit <erezsh@nvidia.com>, Gal Pressman <gal@nvidia.com>, "Leon
 Romanovsky" <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, Yevgeny Kliteynik
	<kliteyn@nvidia.com>
Subject: [PATCH net-next 6/6] net/mlx5: HWS, Remove unneeded WRITE_ONCE in post send
Date: Tue, 15 Sep 2026 14:19:12 +0300
Message-ID: <20260915111912.3926585-7-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260915111912.3926585-1-tariqt@nvidia.com>
References: <20260915111912.3926585-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF000061C3:EE_|DS7PR12MB9551:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b5a4671-d902-4423-bb4e-08df131b4b9b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|23010399003|1800799024|82310400026|56012099006|11063799006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Mrp4Z6hGqqHEYLymKZI16KnWJRaLgu9ia8nmxdce4wfRyWq5bsYNtp8DuC1ai129t1e+qw3rRovWfFVPqt7Drc8fNEseTvoXPC0tpfH6HTNHsoO9lL/7RNLYeTrgIF8RCcvrIhFT02e9Z0B0eTEUoRq2YTWgjsIVFZ9xnvBJdSikVl0RvWw8NbU8YJiuxC+mOf1QGWlvnYcFbz9X20ODus0ttTwiebXlT6asC3s9VNk1UeI58VklB44Gx5h4iGvKUUWgzjfsqbfRT4tapejeZA5gHC1gmsWcVSGGN2rRA4vPsjIQ7TFLAgZ5xtvgB5t1OLOPhvzHxH06UnJ2KnUQ/o9mneTPmANGd/J9ZxKIhIEXO5rS2e5qKwOZvETcXmD8NH3wJXxfQrTmS9yIvFJ1iXfnw7viucA/x0Wntm5igFODOwBp3PisgSNZTJSsPjrHpLiuyV1h1N9qEc8X0+g/NU0HcDuHyrgB4dIjeSWb5/qPjKXfBl00Wv5za7dBzYHlgSsRipZ1QsdMhprFjH2HX6Ao+slMQFjLAjj3IJZWTBEkSRKLAkBxqCTaK4FhTB8ZuXxquWvF9LX9KGhmjPA8shZfMJTd9UfyWCeFtBWKIyg+3uuGMBtPzXJsk3ni/+KuYMwqle+y7RkBIgHkKyELUFJMq4Q5wjwclnb3pmP70S8OhTeOZ0sJa8n8nZJC9bCCEA7oQY+F2481dTUxoqPlKg==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(376014)(23010399003)(1800799024)(82310400026)(56012099006)(11063799006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	CXSMrf/FLD1OrqS/XryyaAJZWLZ0dFof81Kdp1JQokAfXB/UhpzkhJ5ijA6NKFjAlxi1y6Dn/6j78BzlHrCmUQ2zKdGJ4U49dZy1I8EvMXc5xGzdzytEtfEi2hPAiAqmG+UPbHbx9FKX5jo8vPIdMh+nUjDis9agrPC9WAkFkizNYFBk/Mx93V9YPeoQYcgrzCZw+PFYJDPJDirz70FguMAGN9I1Eo7o9jHzCYQQE1HZpe5j4aJ/6lX05hSi0my6Qyb6gIPvChx0mqaEgcEhwA+OE5UiewoNaKVVK62iG6UnYDYjCktZsiSN1gLfniWQjRrfHcS3Hn8cPLREZ6Ya+wDE9jNZ7TCURoQXTpSU+fuygXV0FaXKG672sSlA6GtUZrMkEs/n9krwLAW/fi8P83UlAbcEXcF3BNf/Z1avF5Z0aKq1hiTC6oFonP/gz182
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 11:20:06.2004
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b5a4671-d902-4423-bb4e-08df131b4b9b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF000061C3.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB9551

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Remove the unneeded WRITE_ONCE, for two reasons:
a) This write is erroneous - it just writes to a local variable
and doesn't have any effect.
b) This code originated from another place (copy-paste bug),
where there was actually a CQ polling right after this line,
and the WRITE_ONCE was writing to another place.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Erez Shitrit <erezsh@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c
index bddac018b44b..8b70040eaca0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c
@@ -111,9 +111,6 @@ static void hws_send_engine_post_ring(struct mlx5hws_send_ring_sq *sq,
 	wmb();
 
 	mlx5_write64((__be32 *)doorbell_cseg, sq->uar_map);
-
-	/* Ensure doorbell is written on uar_page before poll_cq */
-	WRITE_ONCE(doorbell_cseg, NULL);
 }
 
 static void
-- 
2.44.0

