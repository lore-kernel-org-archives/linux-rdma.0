Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.9
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794335998;
	b=BxKAJ/AzQKahL5cwJmVimXar2g54xHPqSqq99oeWbxFvFcMnt0j3ng8jHTTs9lG2+5Xh
	 lGTS3VlGjp3DWnrUGOSCf2RUJ3tX94NVL5lZjWNhpK7Bq7Lp/vghgai5/XvABHgkCYuZs
	 yczBun1WGDwrxkRQ0+XukL/UY6mDn20sDt/0Q0akYoRMN4ox1QDSW/zpXEtb6x7olZm+R
	 ZHuOmbsZzgpYM4bnUmtI5Bq/4srzCP32lIaP2aOUDLnTvXvsREPlYQRgW8bjK4pYpnUob
	 FZdwat83tKt9BUJvpMXRqCXrIEz/5+ddMvZQ7/UEHy6Nla8+ovBELSBjLqG02i82VQw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794335998;
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
	bh=3wSw7Ur6+AzD0At1+EXDGNu88/Svr9L6RhVfE2oGWSg=;
	b=Y7xqRyimsBClBiP01nkJvry+8fT16ISCmLe+usWqHxX/WubS9nA/BpZxHHRiqixm7b/y
	 bMPyFbmWpcJ456k+gM59Zlt26sMQFVDwHCO0ctTDDvhKPUDIdjaM/C8TOXNH57sIeFDX/
	 TV9M8jyIrlsi/Is+MJzrB5t6U35Ax6ataA3BEj1nK0Clf7t/TVXE9eI8KFHPCFQQm6bIV
	 q0EUrGzCPvUs8cyn1PMYKVVr2web1H6Gg+6Aft8Dk7cuE2V26pr7kG7PmoXgPUsDfQNAB
	 mAUwVJGYCk7PC89JQwcLRs/1jOBVjfVnhaX3tKTSb7tNW3adiKg0JTUmo4HLzyp563w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=qrTxtMwi;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.9
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010009.outbound.protection.outlook.com [52.101.201.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4CBC60A2613;
	Tue, 10 Nov 2026 18:39:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A4CBC60A2613
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=qrTxtMwi
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NZoey4qUF9uiGKB5Hn8CMcl88tOxEiZGd/QM9uP8IQRobRymQHhOLpN2i/ecu4/TZdBaSgco7qXCvFnm3svsWIBwY1B5ul4ddIUFWk3pb0uDMfqFsZwWjNj4cVxic+d6U5hkTabE1/gn4W6StP9cH4+jhpyQXNePAEBnT3cdSin8JOIApYKdWvmJkymAbvzdKTzmvD8ZOeC4CgZXYrWb+N0n+kqzUyX9ZfFDxOTcsPKUPBtqjEUmlUxwmcGOgWFt6+K1UbIneD1lpg+jylHvAniaQHA28BvWNjhORDLByBfKCcv4KEMMZJy+kGzg0S/1LH1fAgboLwgKQI/a1l9Qeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3wSw7Ur6+AzD0At1+EXDGNu88/Svr9L6RhVfE2oGWSg=;
 b=BnMk2wA1/b05R/N4SOtnNKsziuM3xeNxrSZwGW2H4QcuMO7QNH+GDgGkqSY9avbbkJR1pL9WBvWNUy3BRdy/7ShPGMayXdEltpr1uhIMM46anYw3TQCXzvD//9hWGGAPqWtlnZPp1ybGGZf/s7bDxRNd+3JfafcVCvzywys4q3oaVN9sSjIgkJD1O1er9StuhuFSCUr213HIPEGd39pxGcIsywfnaHu5Qrs1R6wc43EnHU6UA6N31GLtm3xVHraKiTO9fVoDhFpX9SIBB9UTstRil1tu52HjSq0g2yH8yTOCPMTNpxL9lzbLKuU83KswOh/01uo86qKBNsLl0hQGmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3wSw7Ur6+AzD0At1+EXDGNu88/Svr9L6RhVfE2oGWSg=;
 b=qrTxtMwi515X+9SkuUNF2S3L80LrQd0OowmP9M+2jTiokGF73WVQ7XT7eagpkgkv4XE3h71CjiyOn2qndyh2Ut7oi8zBipraB1TPGlnNXiMhqs6m+XmHMec3OplaUHux/kc/qcOZxJcbIMw/R43ipUodV/m+YAPZv0hCHlvP+zB4YEInnPKYYn08g7tw2w6OubeI0bwsBtIkfKIebqKUNiFZitTfWF65FGVCmvnDF53aVtuQYt3dEfTMx33twsTvOibGk1lQMqyUCt1NK3HmR7A3I7uK2U8KOziM6gAVZc3G7VLqYJrFWcuOJEkVsCrUFk8hA0dnL6fGuGPBt1SkRA==
Received: from PH5P220CA0006.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:34a::7)
 by CYXPR12MB9338.namprd12.prod.outlook.com (2603:10b6:930:e5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Tue, 10 Nov
 2026 18:39:45 +0000
Received: from CY4PEPF000392D9.namprd03.prod.outlook.com
 (2603:10b6:510:34a:cafe::97) by PH5P220CA0006.outlook.office365.com
 (2603:10b6:510:34a::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Tue, 10
 Nov 2026 18:39:44 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF000392D9.mail.protection.outlook.com (10.167.247.119) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 10 Nov 2026 18:39:44 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 10:39:19 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 10:39:18 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 10
 Nov 2026 10:39:11 -0800
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
Subject: [PATCH net-next V2 04/13] net/mlx5e: Pre-calculate UMR padding and entry size
Date: Tue, 10 Nov 2026 20:38:17 +0200
Message-ID: <20261110183826.2927274-5-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF000392D9:EE_|CYXPR12MB9338:EE_
X-MS-Office365-Filtering-Correlation-Id: 86e731ac-65f4-4392-cb65-08df3f59fd65
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|1800799024|36860700016|23010399003|56012099006|261026121527099003|261028144727099003|11063799006|261021123027099003|261021121427099003|261022105027099003|261022075727099003|261009223027099003|261026140227099003|261102123227099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	6G0I9/9ZgSAwmGyWMIDlK/XI5jFibucU04McTUGXigYIl1nIfFAeqUDoxdH0Yt6sGcaOdUZTt8LGq7rKVwmVVCiZDh2mczXBxS2Oag65ynqgpcurQI47HRb2dQQxtcxXMLShye70xzefQBhXpzSMdL8MzlRmAA0QOsD4r+mDUGsL7KMlTeNrq5ZfY3DJlBhGXRZf4sIh6FmgrRqASgAyn0uLwRYU6pPOsrJf8nRt89PzOjTVFvWdEq1HN+4mfmz6POJE5enGboCD8NCXcwSrp7ChBCQAsJDHcsipplRyYS5c3gMD8yXNNZXLhbSej5IC5wNT5SWkAzJRYLPi+zo+80U6ubWruF2jf5W6VGSOT6Cqo7pRljCsxhQ20EKgDu72e8CF4cWrYgSYxD4wXzRjot6zZGO4DD95O1dquoX3Cp/KwecNYAprG7EkhxxbdRWMgsZE8zFK+GABC8D2MEtOibSsT9OmXouTQfBAo3FRPIkf+GYpVM6aaD5ZM7oKkWq0P/fMZVd4OKoEDvyvj6mV11PCBaKEBj4emvuGLhBhefDG6ow4RR2zWbm7C94Ayb5ZNMvEdGZSw0kDkPt2MTdsTVLJENUW58jrYPQOZxyqXjSkw+t47iEOVj51t+GI0yPDDh00vX+yho2wcEhF2+oLIDApN3CXREGiQFdddp7Q82VcQ99TFuW9lCgzxbNTBVxAtCxIkrSShnFh/BBCeb+zXg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(1800799024)(36860700016)(23010399003)(56012099006)(261026121527099003)(261028144727099003)(11063799006)(261021123027099003)(261021121427099003)(261022105027099003)(261022075727099003)(261009223027099003)(261026140227099003)(261102123227099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	6bVJYHnt/CGantwDoTl/0zlyAeQ9frQqMACAPWSb60w5qpk82aiMhzyZn5uEdlbX3Bg8ZINb1bU3DAEBMbHqK7YnNCy/joAlbKozV1R8vTEy7B78XnOhrXUykdknmLDBjyK/O/ndcUGggbbUAqBJAwtED4q2gGvb0U3ZeNnYIMiniycO5guZjkT4447Dj1sUa0I9gYfxjV4kxzzSdpu0/N2/rZRfeqRYiBeGtuqUPqbpHC841eEeCB5Qq4gL5ogoj4hLiPI0aH7tZBE+q285SptdRS8habyCTkYog4BkO3UR1Vt9sfAPt5iErPiXAoB/LboRWhwdNE0CuABXNptsyPCbqDN+PQRDMr3vcDv5PGRym8qjL68gP0eGILcRhWe0eq4xqSl0vhEwUA2Yaw8AlfQ7p1MQ1h4UEDfnAV6zAHxVJfmnHWs1O78L9cz+CBkE
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 18:39:44.4791
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 86e731ac-65f4-4392-cb65-08df3f59fd65
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF000392D9.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9338

From: Dragos Tatulea <dtatulea@nvidia.com>

A future patch will add KSM UMRs alongside MTT UMRs for data direct. To
avoid additional ifs in the datapath, pre-calculate the UMR padding and
entry size based on the UMR mode of the RQ.

An additional side benefit is that the padding check from
mlx5e_alloc_rx_mpwqe() is no longer needed.

This patch doesn't introduce any functional changes. The mlx5e_rq struct
doesn't grow because the new members were added in a hole.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h     |  3 +++
 .../net/ethernet/mellanox/mlx5/core/en_main.c    | 11 +++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c  | 16 ++++++----------
 3 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 78cf6aedd04d..000493f42912 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -696,6 +696,9 @@ struct mlx5e_rq {
 			u8                     umr_wqebbs;
 			u8                     mtts_per_wqe;
 			u8                     umr_mode;
+			u8                     umr_entry_size;
+			u8                     umr_pad_bytes;
+			u16                    umr_pad_offset;
 			struct mlx5e_mpw_linear_info *linear_info;
 			struct mlx5e_shampo_hd *shampo;
 		} mpwqe;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 1993da0fdb91..96b521d8bed3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -901,6 +901,7 @@ static int mlx5e_alloc_rq(struct mlx5e_params *params,
 	void *rqc_wq = MLX5_ADDR_OF(rqc, rq_param->rqc, wq);
 	struct mlx5_core_dev *mdev = rq->mdev;
 	u32 pool_order = 0;
+	u16 entries_bytes;
 	u32 pool_size;
 	int wq_sz;
 	int err;
@@ -947,6 +948,16 @@ static int mlx5e_alloc_rq(struct mlx5e_params *params,
 			mlx5e_mpwrq_mtts_per_wqe(mdev, rq->mpwqe.page_shift,
 						 rq->mpwqe.umr_mode);
 
+		rq->mpwqe.umr_entry_size =
+			mlx5e_mpwrq_umr_entry_size(rq->mpwqe.umr_mode);
+		entries_bytes = rq->mpwqe.pages_per_wqe *
+				rq->mpwqe.umr_entry_size;
+		rq->mpwqe.umr_pad_offset = entries_bytes;
+		/* padding can be 0 when no padding is needed */
+		rq->mpwqe.umr_pad_bytes =
+			ALIGN(entries_bytes, MLX5_UMR_FLEX_ALIGNMENT) -
+			entries_bytes;
+
 		pool_size = rq->mpwqe.pages_per_wqe <<
 			mlx5e_mpwqe_get_log_rq_size(mdev, params, rqo);
 		pool_order = rq->mpwqe.page_shift - PAGE_SHIFT;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 22fea4739a2c..a9392ee5376e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -675,16 +675,11 @@ static int mlx5e_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 		};
 	}
 
-	/* Pad if needed, in case the value set to ucseg->xlt_octowords
-	 * in mlx5e_build_umr_wqe() needed alignment.
+	/* Pad when the value set to ucseg->xlt_octowords in
+	 * mlx5e_build_umr_wqe() needed alignment.
 	 */
-	if (rq->mpwqe.pages_per_wqe & (MLX5_UMR_MTT_NUM_ENTRIES_ALIGNMENT - 1)) {
-		int pad = ALIGN(rq->mpwqe.pages_per_wqe, MLX5_UMR_MTT_NUM_ENTRIES_ALIGNMENT) -
-			rq->mpwqe.pages_per_wqe;
-
-		memset(&umr_wqe->inline_mtts[rq->mpwqe.pages_per_wqe], 0,
-		       sizeof(*umr_wqe->inline_mtts) * pad);
-	}
+	memset((u8 *)umr_wqe->inline_mtts + rq->mpwqe.umr_pad_offset, 0,
+	       rq->mpwqe.umr_pad_bytes);
 
 	bitmap_zero(wi->skip_release_bitmap, rq->mpwqe.pages_per_wqe);
 	wi->consumed_strides = 0;
@@ -693,7 +688,8 @@ static int mlx5e_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 		cpu_to_be32((sq->pc << MLX5_WQE_CTRL_WQE_INDEX_SHIFT) |
 			    MLX5_OPCODE_UMR);
 
-	offset = (ix * rq->mpwqe.mtts_per_wqe) * sizeof(struct mlx5_mtt) / MLX5_OCTWORD;
+	offset = ix * rq->mpwqe.mtts_per_wqe *
+		 rq->mpwqe.umr_entry_size / MLX5_OCTWORD;
 	umr_wqe->hdr.uctrl.xlt_offset = cpu_to_be16(offset);
 
 	sq->db.wqe_info[pi] = (struct mlx5e_icosq_wqe_info) {
-- 
2.44.0

