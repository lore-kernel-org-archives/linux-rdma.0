Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013018.outbound.protection.outlook.com [40.93.201.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0E9440A3D;
	Tue,  4 Aug 2026 08:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785832689; cv=fail; b=hJNyV7xNgpaQJOx+6eELii+HfzLFuNr9qxho6d1HWMETeqDTl8bGuvFlo5ExPpuxsR9Bzc4mvHphnoTBs1sfnT+g0P7zobXRVxOZP3lvnZcpPEZP2UQpFMVF4vP+7ytwFjtsavmlWwvhSTJfvi/2izWdJMzIKNjllrwK9v9DXfI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785832689; c=relaxed/simple;
	bh=K79ghD/WIanBDVAeeC3TkunkpIzvj/UNEO5YRFhGcmw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AgAJn1WAVn8bxn43rENFW4HPCch5gO5JYRKpO9lLGRvylZR85/6V3JBIim+ckdccqiRfb8Hc8aXpaVQL9Zg+SfV8eWtl7F4l/XjdHL0D3vJFL1aMgXpbwlzaTx9n/FCC2YC7aJEsF3dRritx8rJMZrMnVKQ4OOWj2kj5GnaczIY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Cz9aqwib; arc=fail smtp.client-ip=40.93.201.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Cz9aqwib"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ClluUomfGWy9b+s0kBOpC+KtCGIvufS5PJ4yeDnO3++7QQ9dhFDupvTxfkp5e4+Ui5BErZ9DyxAXhA7qpPmv1OS/fUvbXhcKMhpqXcCckrF1xQDgt9/HnTRLnJI1bOocDdjEHk/wklJxvVdvk/Ngf6bCq0UIE+hZwjXAJ0wy1VPtFKKUTFEC+8buVa2gOcyTzDpX6tEh75F3a4/QCq2RUQC7cP2il2CtBMNIAm3LuzekaTeV/Mz5XaLYEqq+qeMfZLG8lA8AQsdnSTUBMJAYPilRp6kYtgHuDazd2fSp2vHta9GvrJC7dk8UL/JdRWUDaWc1Bgc5OMmnXKu/PCye6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YosucmlZe95ViftRsSyssVpiiEvpUvQqrcmejy+CgiU=;
 b=G4NG0uo2vS3MfQlaVX+gpnmwsnZCQ6UWAx1TtidyfxFDmPIMMwtcj12MeYzkiEW4x0vWNOm6JeBdZQZQX85wmBcPwSeCYa/5tOG9roUmNRiakXOn6ZfUKpZ2Kyay4adQipL8CE648X509dq8vnB+xYAFjDtykiES8Tjc5JPcmcSQba3YFIyypWQF8XW7VceK5CHfsj/mXmvN4iFLph6p9RG8czpEL993JQQiO+709k0yTLeZe9hCF+3T123txx3kkHDULMZXDxg4bfMWVSyQ2hSsPwGfUeKn239U968R5yKQAAmrXS/l0fWajeaJ16w6uZXD67Di/+ryxfc/WK81ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YosucmlZe95ViftRsSyssVpiiEvpUvQqrcmejy+CgiU=;
 b=Cz9aqwibcW/Cf+f2bBHZhXaUv8U75x5tV2zAfqqloKJrll80r7IclpLdUKjCxqZNLUgnCZv20zoor4gxnVdcwMqUWijc7kpbADInOPWizpO/f1wj9E2lNM3grlHQJGa4GiVNXeuUEkrUMy3QcsRocIPcmjjPGFHTbDLtDLQA+ZbFKGbRbHE013zBSCzVr7TsEJWFnPq5AGjjbZ9e8uui9eAnfLhjnUZQT+YTA6v6w1+LR0E1FtZhVvbWFFuSJ5rgEx5baUA3/U5qzr5UPOVnKL4iEG4zT0FqNpXGw7jzMtNgoNb5wpPXlBO0FyIKY/p5QipcNdhIcU32dXMJb2cqGQ==
Received: from SA0PR11CA0171.namprd11.prod.outlook.com (2603:10b6:806:1bb::26)
 by LV2PR12MB5871.namprd12.prod.outlook.com (2603:10b6:408:174::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.15; Tue, 4 Aug
 2026 08:38:00 +0000
Received: from SN1PEPF000252A1.namprd05.prod.outlook.com
 (2603:10b6:806:1bb:cafe::81) by SA0PR11CA0171.outlook.office365.com
 (2603:10b6:806:1bb::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.15 via Frontend Transport; Tue, 4
 Aug 2026 08:38:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SN1PEPF000252A1.mail.protection.outlook.com (10.167.242.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.8 via Frontend Transport; Tue, 4 Aug 2026 08:37:59 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 4 Aug
 2026 01:37:43 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 4 Aug 2026 01:37:42 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Tue, 4 Aug 2026 01:37:35 -0700
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
Subject: [PATCH net-next V2 07/13] net/mlx5e: macsec: Move RX marker from ft_metadata to flow_tag
Date: Tue, 4 Aug 2026 11:35:29 +0300
Message-ID: <20260804083535.2946459-8-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260804083535.2946459-1-tariqt@nvidia.com>
References: <20260804083535.2946459-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A1:EE_|LV2PR12MB5871:EE_
X-MS-Office365-Filtering-Correlation-Id: 1fd16a49-28e4-487e-2669-08def203b07e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|7416014|376014|82310400026|36860700016|10067099003|11063799006|6133799003|56012099006|3023799007|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	oDBXaU0zL7WIWVEb2NeIwNwx4oo8dLEoBB2qDCj1e1ggs62TDiui20XM8QlK2+FoBweBmiXiLjZ5Q7tyq7aObUcgjO7Tou9ixvrRBiqXPFHYxa82moubDu1WeKbwEDMpQY5aYFlq6yGTg9nV3X9lZbk3zFaMIMRuPINmwGKOWUClejd7W7oJ0J90vMV42/wRFvVvfafr24/IIArkDY00zMLCPsPPGY0zpEGCAp9AbOTLkiVB+APOZzzbNsjj4M3/lA1r3Z+Uv81L6AHZ/Bhc5Uph6maB18b8kyMhSz6Ktfr97DyI1esASZ8w2JV2tq7skq86gbacmawgn2kOKJqnBwestMl1mc/SOQbyYenra4q3XJtGWSZ+RC56f18LvfH11ob5CwE3WBAMrb5AFOKnlkblMO1OnNBOMDYGN5wPvRC31joLzRcFAxJiER0MfWKkKprS3jf7mfmRiKTe5Oi0fyPwahHBPVLmZRvkveyi0SycZkoYT8UqUxA+FU1htPJc9a3Q1jmv2hv/J/bLf1KFDhL2liQDtSF7blF/X5NoiDRXtYujwjX/d19Fa9f2M2VD7nlQrFVDY1vi7QMjqT4fZIX/2gye2xSeIeMIDZJcVgI/6T4ZS/ySdE8RmT4jgNA1ohJIo2SgLfNIWJl+spWMtd/3AclylggegnRuGdP4Ku9swcZdqlRnvgZOZHZH+rKsByrAOyhev9nb5qfw+QXQtA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(7416014)(376014)(82310400026)(36860700016)(10067099003)(11063799006)(6133799003)(56012099006)(3023799007)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	9pTEo76NfS4wjwtYOXxFqeF6cn1dQ0Q5pXoXWplG2BNLg31XsSr/iA6a9x3KS/N9hWZDIhpMyHh3uhRyt72CKZqxOnSaK6vgPbxwRIBbbVCjYCGJlELVc9QI0vV/tG/IMoD2nuwLzdzBqTm3mNYOCjXgdL2mR5WOACLqs+Ty4BGElVZCIj3+tHuWPmfQnkG8c4QYY3xJgsG5zvgigv/NpplUhKcdEUP8Rn5hVwIUCTsqe8a7/YJ3HBoPT0nLg/9cSg5RRbOGbFoZk/MxxXlK6NNa25IcYR0Cua6QLU1jGShriOwfAfGet2mQh6sor09lqfU0+xfa2wuK4gLOf/gajZQDG32PfBs9NSMauZZx9lnMSTBzlQd536PAtBcvvSqwghE28hTKU4NCfcerMOs3Pdr+PUllNC9g4NG5dK7oER5PBhBdBq5ExjveNZIhYKcZ
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2026 08:37:59.1776
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fd16a49-28e4-487e-2669-08def203b07e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000252A1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5871

From: Cosmin Ratiu <cratiu@nvidia.com>

MACsec uses BIT(30) in cqe.ft_metadata as a marker to identify
MACsec-decrypted packets. This will conflict with PSP SPI values with
bit 30 set, which would falsely trigger mlx5e_macsec_is_rx_flow().

Define a new marker for MACsec in flow_tag and use it in steering rules.
The fs_id stays in ft_metadata bits[15:0].
Correct typos of MLX5_MACSEC_RX_METADAT_HANDLE and
MLX5_MACEC_RX_FS_ID_MAX while touching this.
Delete the METADATA_MARKER macro.

Set flow_tag on both with-SCI and without-SCI crypto rules.

Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Carolina Jubran <cjubran@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/flow_tag.h      |  4 +++-
 .../mellanox/mlx5/core/en_accel/macsec.c        |  6 +++---
 .../mellanox/mlx5/core/en_accel/macsec.h        |  5 ++++-
 .../ethernet/mellanox/mlx5/core/lib/macsec_fs.c | 17 ++++++++++-------
 .../ethernet/mellanox/mlx5/core/lib/macsec_fs.h |  9 ++++-----
 5 files changed, 24 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/flow_tag.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/flow_tag.h
index 8a02e8e9713d..28b4470bc91f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/flow_tag.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/flow_tag.h
@@ -14,14 +14,16 @@
  *   [23:21] = protocol ID (3 bits):
  *              0 = none (default)
  *              1 = IPsec
+ *              2 = MACsec
  *              3 = PSP (HW decrypted, PSP header present)
- *              2,4-7 = reserved
+ *              4-7 = reserved
  *   [20:16] = reserved
  *   [15:0]  = used by other subsystems (e.g. TC).
  */
 #define MLX5E_ACCEL_FLOW_TAG_PROTO_MASK		GENMASK(23, 21)
 #define MLX5E_ACCEL_FLOW_TAG_PROTO_NONE		(0 << 21)
 #define MLX5E_ACCEL_FLOW_TAG_PROTO_IPSEC	(1 << 21)
+#define MLX5E_ACCEL_FLOW_TAG_PROTO_MACSEC	(2 << 21)
 #define MLX5E_ACCEL_FLOW_TAG_PROTO_PSP		(3 << 21)
 
 static inline u32 mlx5e_accel_flow_tag(struct mlx5_cqe64 *cqe)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index a15a0aff292f..aa7a28954861 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -752,12 +752,12 @@ static int mlx5e_macsec_add_rxsc(struct macsec_context *ctx)
 	 * a non-NULL md_dst with uninitialised contents.
 	 */
 	err = xa_alloc(&macsec->sc_xarray, &sc_xarray_element->fs_id, sc_xarray_element,
-		       XA_LIMIT(1, MLX5_MACEC_RX_FS_ID_MAX), GFP_KERNEL);
+		       XA_LIMIT(1, MLX5_MACSEC_RX_FS_ID_MAX), GFP_KERNEL);
 	if (err) {
 		if (err == -EBUSY)
 			netdev_err(ctx->netdev,
 				   "MACsec offload: unable to create entry for RX SC (%d Rx SCs already allocated)\n",
-				   MLX5_MACEC_RX_FS_ID_MAX);
+				   MLX5_MACSEC_RX_FS_ID_MAX);
 		goto destroy_md_dst;
 	}
 
@@ -1724,7 +1724,7 @@ void mlx5e_macsec_offload_handle_rx_skb(struct net_device *netdev,
 	if (!macsec)
 		return;
 
-	fs_id = MLX5_MACSEC_RX_METADAT_HANDLE(macsec_meta_data);
+	fs_id = MLX5_MACSEC_RX_METADATA_HANDLE(macsec_meta_data);
 
 	rcu_read_lock();
 	sc_xarray_element = xa_load(&macsec->sc_xarray, fs_id);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.h
index 27df72e23106..571624f2db15 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.h
@@ -9,6 +9,7 @@
 #include <linux/mlx5/driver.h>
 #include <net/macsec.h>
 #include <net/dst_metadata.h>
+#include "en_accel/flow_tag.h"
 #include "lib/macsec_fs.h"
 
 struct mlx5e_priv;
@@ -31,7 +32,9 @@ static inline bool mlx5e_macsec_skb_is_offload(struct sk_buff *skb)
 
 static inline bool mlx5e_macsec_is_rx_flow(struct mlx5_cqe64 *cqe)
 {
-	return MLX5_MACSEC_METADATA_MARKER(be32_to_cpu(cqe->ft_metadata));
+	u32 proto = mlx5e_accel_flow_tag_proto(cqe);
+
+	return proto == MLX5E_ACCEL_FLOW_TAG_PROTO_MACSEC;
 }
 
 void mlx5e_macsec_offload_handle_rx_skb(struct net_device *netdev, struct sk_buff *skb,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.c
index efc5167493c1..b8e9021027e9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.c
@@ -8,6 +8,7 @@
 #include <linux/mlx5/macsec.h>
 #include "fs_core.h"
 #include "lib/macsec_fs.h"
+#include "en_accel/flow_tag.h"
 #include "mlx5_core.h"
 
 /* MACsec TX flow steering */
@@ -45,9 +46,6 @@
 #define MLX5_SECTAG_HEADER_SIZE_WITHOUT_SCI 0x8
 #define MLX5_SECTAG_HEADER_SIZE_WITH_SCI (MLX5_SECTAG_HEADER_SIZE_WITHOUT_SCI + MACSEC_SCI_LEN)
 
-/* MACsec fs_id handling for steering */
-#define macsec_fs_set_rx_fs_id(fs_id) ((fs_id) | BIT(30))
-
 struct mlx5_sectag_header {
 	__be16 ethertype;
 	u8 tci_an;
@@ -1757,11 +1755,10 @@ macsec_fs_rx_add_rule(struct mlx5_macsec_fs *macsec_fs,
 	rx_tables = &rx_fs->tables;
 	ft_crypto = &rx_tables->ft_crypto;
 
-	/* Set bit[31 - 30] macsec marker - 0x01 */
 	/* Set bit[15-0] fs id */
 	MLX5_SET(set_action_in, action, action_type, MLX5_ACTION_TYPE_SET);
 	MLX5_SET(set_action_in, action, field, MLX5_ACTION_IN_FIELD_METADATA_REG_B);
-	MLX5_SET(set_action_in, action, data, macsec_fs_set_rx_fs_id(fs_id));
+	MLX5_SET(set_action_in, action, data, fs_id);
 	MLX5_SET(set_action_in, action, offset, 0);
 	MLX5_SET(set_action_in, action, length, 32);
 
@@ -1778,6 +1775,9 @@ macsec_fs_rx_add_rule(struct mlx5_macsec_fs *macsec_fs,
 	/* Rx crypto table with SCI rule */
 	macsec_fs_rx_setup_fte(spec, &flow_act, attrs, true);
 
+	spec->flow_context.flags |= FLOW_CONTEXT_HAS_TAG;
+	spec->flow_context.flow_tag = MLX5E_ACCEL_FLOW_TAG_PROTO_MACSEC;
+
 	flow_act.modify_hdr = modify_hdr;
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
 			  MLX5_FLOW_CONTEXT_ACTION_CRYPTO_DECRYPT |
@@ -1803,6 +1803,9 @@ macsec_fs_rx_add_rule(struct mlx5_macsec_fs *macsec_fs,
 
 		macsec_fs_rx_setup_fte(spec, &flow_act, attrs, false);
 
+		spec->flow_context.flags |= FLOW_CONTEXT_HAS_TAG;
+		spec->flow_context.flow_tag = MLX5E_ACCEL_FLOW_TAG_PROTO_MACSEC;
+
 		flow_act.modify_hdr = modify_hdr;
 		flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
 				  MLX5_FLOW_CONTEXT_ACTION_CRYPTO_DECRYPT |
@@ -2160,8 +2163,8 @@ static int mlx5_macsec_fs_add_roce_rule_rx(struct mlx5_macsec_fs *macsec_fs, u32
 
 	spec->match_criteria_enable |= MLX5_MATCH_MISC_PARAMETERS_2;
 	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, misc_parameters_2.metadata_reg_c_5);
-	MLX5_SET(fte_match_param, spec->match_value, misc_parameters_2.metadata_reg_c_5,
-		 macsec_fs_set_rx_fs_id(fs_id));
+	MLX5_SET(fte_match_param, spec->match_value,
+		 misc_parameters_2.metadata_reg_c_5, fs_id);
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_ALLOW;
 	new_rule = mlx5_add_flow_rules(rx_fs->roce.ft_macsec_op_check, spec, &flow_act,
 				       NULL, 0);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.h
index 15acaff43641..b8b8b412d5c3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.h
@@ -6,11 +6,10 @@
 
 #ifdef CONFIG_MLX5_MACSEC
 
-/* Bit31 - 30: MACsec marker, Bit15-0: MACsec id */
-#define MLX5_MACEC_RX_FS_ID_MAX USHRT_MAX /* Must be power of two */
-#define MLX5_MACSEC_RX_FS_ID_MASK MLX5_MACEC_RX_FS_ID_MAX
-#define MLX5_MACSEC_METADATA_MARKER(metadata)  ((((metadata) >> 30) & 0x3)  == 0x1)
-#define MLX5_MACSEC_RX_METADAT_HANDLE(metadata)  ((metadata) & MLX5_MACSEC_RX_FS_ID_MASK)
+/* MACsec fs_id in ft_metadata bits[15:0] */
+#define MLX5_MACSEC_RX_FS_ID_MAX USHRT_MAX /* Must be power of two */
+#define MLX5_MACSEC_RX_FS_ID_MASK MLX5_MACSEC_RX_FS_ID_MAX
+#define MLX5_MACSEC_RX_METADATA_HANDLE(metadata)  ((metadata) & MLX5_MACSEC_RX_FS_ID_MASK)
 
 /* MACsec TX flow steering */
 #define MLX5_ETH_WQE_FT_META_MACSEC_MASK \
-- 
2.44.0

