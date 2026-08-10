Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010031.outbound.protection.outlook.com [40.93.198.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 923193AEF4F;
	Mon, 10 Aug 2026 09:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786354059; cv=fail; b=ZYYjG9mzBQ5UZYAn3x+svXNp36AKtbzUShFnincpQZlHv9YZtZnybLGrwrMKGSF6T6FGTt4J3d4vZaEO7hnGjWBoZ9CF579DTxP6Vqm1dKPQWi7lgHFk3IjuBRWuLI3/Fw4Az/5zo66JeGJhmv8bozuaGrejrmXxCiD+k+ttfd4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786354059; c=relaxed/simple;
	bh=0m8mCVS+W6tXKvqCGJc5a6INAggMb6XXEK/0w5v29z8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NWGlzdy2sMSA28cBhK6tTKZSLfEa1dKclNAS+TIqukgxP9a7bppFFYDWoV5Z/pHP6NJKlJsxvzhStaeUSchT4rRYxengNyLWZyxaATXLt+c9ydsRq3Lb3n5GX7gmR7y9bERspdjUvK2Bu5rlEU9JMPOqVXB6+QVTHL38Ps+xVqE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=l3+e8fYo; arc=fail smtp.client-ip=40.93.198.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="l3+e8fYo"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PBhugScsisudpxmiyEeNmPCf0jr2dOKDRm1XQKyu7Xseq6N+DuPUFct33hMZbKnMaU6Vef3dW+S3wdGFPCRzuktfsIhRDzXTkJz1VYfGafxa7nWmisCEDChxkFaBtft+phsZL/gglVrhAI5zYBF0ZTyc9RNwnDWVkOgjYwNeDpAQ7Xxhw8ewcc+YH/D9/45G1UJmwSLQcJMkrwqGKHiLyNq3hQQog8eAoDkVd8r0CX2ds1TP0cJy3DzUgB/8X2HgNhM0tP27aMszlu0NS1tmyMk6xBYMLd/22FNc+Q/gBZp3D8Ydqj/JyXcnY5VA0YBBCgcQ6pdaN2Jxzu2ffRYozQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QMwqRO2GT1S34YUWsQdcgV++iivfvLQglnsQWEcU1Ss=;
 b=TyScU6sFj3O4KZ+pZJNYD4xudbMDwIp/5RgeiMRhhgpXlGtLkSIRzYQRiJNCGd1S4PvVTu5EB7+bi2hdQzKEDEoDBRU56BaTUaLB/fw5P3QeyK7Go7Nf/NKgZCC+Wzpaaf0FoHI5xWK1KiBShwjJ2/lLo0LemyOCuxRBWvw3BXNF+cplueducc8BfopqulB1Q6QDDl1fZmjk6smY9kjEK6R77H/K7Ufa8VtS4evrkTgNKj62Mp45LCdadCLXNi+f2vER/jgJcCkV2OtombtwVGzQ8f35cDMHM1C6qKrI56zn4GULZcYJvUfisyd56F5bvNNfd/PUV9sADj0AzHmBkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QMwqRO2GT1S34YUWsQdcgV++iivfvLQglnsQWEcU1Ss=;
 b=l3+e8fYo9T17pUJ6vMaJKCkOR0/U7+bazJuvoz8IVGMpbA5gsh4mkMKIQwtYVYzll/pAhN4VEyMkOdF2BYUoX7YFHI5skCX77qCf9Uc6Wsc306muP2uNYyLP3xJrc8NBGeR9K+j4aDCL0JFx8xB8gDhvv9StWA4+1lSftr9Vbds5e/fFbOAuOzDD5Z4nuKQPhGujtvy4QD0i3J+LHUJigylAAHGWmxibl1m6qhKVUaa/tXl4u+aOU/Z09/rRab0oDHfQZeBzMIpNiYdLJSWga47BSoiqrvvYu4eyPAsYuxMS1Cjzo+/DhtvP238at4H2hMX0DLZXN2SfqklT9rkn6w==
Received: from BLAPR03CA0061.namprd03.prod.outlook.com (2603:10b6:208:329::6)
 by IA1PR12MB6385.namprd12.prod.outlook.com (2603:10b6:208:38b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Mon, 10 Aug
 2026 09:27:31 +0000
Received: from BL02EPF00029929.namprd02.prod.outlook.com
 (2603:10b6:208:329:cafe::4) by BLAPR03CA0061.outlook.office365.com
 (2603:10b6:208:329::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.25 via Frontend Transport; Mon,
 10 Aug 2026 09:27:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL02EPF00029929.mail.protection.outlook.com (10.167.249.54) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.315.6 via Frontend Transport; Mon, 10 Aug 2026 09:27:29 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 10 Aug
 2026 02:27:11 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Mon, 10 Aug 2026 02:27:09 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Mon, 10 Aug 2026 02:27:01 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Akiva Goldberger <agoldberger@nvidia.com>, Alexei Lazar
	<alazar@nvidia.com>, Alex Vesker <valex@nvidia.com>, Cosmin Ratiu
	<cratiu@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>, Erez Shitrit
	<erezsh@nvidia.com>, Feng Liu <feliu@nvidia.com>, Gal Pressman
	<gal@nvidia.com>, Jacob Keller <jacob.e.keller@intel.com>, Kees Cook
	<kees@kernel.org>, Leon Romanovsky <leon@kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>, Parav Pandit
	<parav@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shay Drory
	<shayd@nvidia.com>, Simon Horman <horms@kernel.org>, Tariq Toukan
	<tariqt@nvidia.com>, Vlad Dogaru <vdogaru@nvidia.com>, Yevgeny Kliteynik
	<kliteyn@nvidia.com>
Subject: [PATCH net-next V2 2/5] net/mlx5: HWS, Log syndrome on STC modify failure
Date: Mon, 10 Aug 2026 12:26:27 +0300
Message-ID: <20260810092630.3137666-3-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260810092630.3137666-1-tariqt@nvidia.com>
References: <20260810092630.3137666-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00029929:EE_|IA1PR12MB6385:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d53d25e-e1c7-4ad2-a307-08def6c19962
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|376014|7416014|1800799024|82310400026|10067099003|56012099006|11063799006|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	HRhkfGQ0W7ER7TdNGGnmx/+4P0pIJkupvZ69hcz8TVZiq72eflKbhIs9qFdJsZBOOngowEhWuD78sZScp9/4geAy5TH9BTdPwAvs+Ft8fft8tDLHCYOCObem8yLoWzCPiu+cIs8SHrAhUbwzXRaHZr9HIwULtpqKggXdjm1+EYk9vrHDeid2vdmK7mN0XYF1IforkFyC+t2Wrs2xYgrJzhKoYgZf851b4ckNjOnkPGLL0Uefymj4Pxjqu9tOPf7QPfMy5BaVZsKw+8vS815llXTRzfnO2q+O/fb4PkX4xSaeFdG0oeJlgCVMOCkUdKyjF7YDG9q18/fYaT2AsWee372U1DuKVKt/iYpOs5BhlFuT9StaZqxarC0ZPW1zTOY/4WKYCEn7RchSrpx8YKF82mc+oAZf0Qv8zhahDkcYYu+zKMEjlm6R3L4/nlpI3ffc5UtOL6ZdAk1uAQjC/M0ukiRuQLGAwfGWopun9SnNsieG7LWn8Gvc3Pu9NMT4EX6Uz9QEb5DPUg+miIBooTgf0+9K3puZJVAljlkt53t6KvmjwtaqpX9sSFUpaVVzv5hu7o5AagzXQa1DKatnh5C9Iay0hZv6AER+zP0CRZWsVIZdW2nfpqZ9FwYdkeWDOtZ7hPHxRGUxY1nMFyjgcI2Tn995zdkVIGwGjYJ6i94117hH00jzkY5P4JWty/Odqvj6h21QSKti0T8SGvFkfYaoXA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(376014)(7416014)(1800799024)(82310400026)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	38J/T+E6rFGuu+zdv6EcwnI1fHH4/pdroMrEr2vgkkF/6SSrWNx8HTfsb5vmCgV63tGlhNm6tyX45e3P7aOU8D2QnQLQuJxopbXwUnyoUReYKbR3J7ADXZghgUfd9+qy4oilDxYezwY8AxkL7s/WTi1mFyA5FBjmcnhSNSaqx7BWgvFgimPVyNQWOh9mrt85M8ukia7bptS9jGYc1a7OaNJdO8ESRbYK1aGXpL1Ir1vPKE8Xdd41RPriwy1ER7PFhVF8WYNw3aATquAH331S//P1+yVFgl5qDTIhjo7z0IrlbcKPkhA3oer2AEt8zZYmApDlWICiNVm0dQZ2OgYxQaiqk9gein0qe1d8u9Nt6ohuFzKgLnczc5mq+q4zjuTnTBofEbl/QBeY5ScXGHsd5dbZ60iRz0J6WlPfXW8kesqYWD4HHZ3EjkBcRsEwmCsv
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2026 09:27:29.3977
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d53d25e-e1c7-4ad2-a307-08def6c19962
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00029929.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6385

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

When mlx5_cmd_exec fails for STC modify, include the command syndrome
from the output buffer in the error message to aid debugging.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Erez Shitrit <erezsh@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/steering/hws/cmd.c    | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/cmd.c
index 8fae90101653..2cdc03421433 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/cmd.c
@@ -611,9 +611,11 @@ int mlx5hws_cmd_stc_modify(struct mlx5_core_dev *mdev,
 
 	ret = mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
 	if (ret)
-		mlx5_core_err(mdev, "Failed to modify STC FW action_type %d\n",
-			      stc_attr->action_type);
-
+		mlx5_core_err(mdev,
+			      "Failed to modify STC action_type %d, err %d, syndrome 0x%x\n",
+			      stc_attr->action_type, ret,
+			      MLX5_GET(general_obj_out_cmd_hdr,
+				       out, syndrome));
 	return ret;
 }
 
-- 
2.44.0

