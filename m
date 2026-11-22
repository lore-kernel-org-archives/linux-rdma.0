Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.62.33
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795369212;
	b=JSpgy0dRNP/770WROFceqsid9qWwe+IWKJgACfS6DPWvmJxKZCkVCBS8XVlBTiysyYCu
	 Y6nm28uYNgkvAYKb76ewLLnCfveNww9gEyNkUxJ74JLE6CaaQbBe0r7ojVB7D7JpEPFJV
	 1SipJoNhEttcXKzTzUl/WOuPDQqOZt+8Ynmnx4mnURzmpdLU7nxRLuAKmIDYQUJsbe+e4
	 v+lHBGtTWDgn7RCRGdfnOAtnyo+YOUvycIlas34BgwwMRqoFhWaOHhJZfgNN8vbzRd72O
	 au6Gzk0xbVieOT7TL85Sw7NDv0Z7P9H/vMhkUiF3QJd0Bv9+WXdI+Vm7Kbi7KILGT2g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795369212;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-ID:References:In-Reply-To:To:CC:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-NV-OnPremToCloud:
	 X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=XQF9iNDVkcv/2mMV52DarQOYEGbKOZVEVCGQmv5YFgM=;
	b=rr8cxcV2ZeDAn8eRsSgxfYeD9FmlVXs27tFxs/FRFhe+O/sQ8rYBWEYfDqjfRUPKKtio
	 5lxAbKNA/smy79iPLPBclM8XCuJmvGIjflUW8MpUXKkeEIzPT2X9F5pYPgMuGpob2kM+u
	 pwpJDIDEMA2s3RaazEc5Ov9kztQiJcAeKedqutF8JxFjdBeC6ctkrhAl59LF8mWTnJftD
	 R5/qf0HTXg7C9w19dj9Dz08o1kF5PJ159AZ5uSuAtr7+W8UjDieQ7b2k10V1QtTGr+mXM
	 I672dRHWLDNHcGz0JiSmVUHFrdNbsm9JJzvXpK+HKVYUTNN8JIU23nfcrG/FjX3mOMA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=N+PfFnID;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.62.33
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011033.outbound.protection.outlook.com [52.101.62.33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D9E606A32A;
	Sun, 22 Nov 2026 17:40:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 67D9E606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=N+PfFnID
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TU+RKZ7o1bDwrWAdhj49AWxRJiPGuETyX0lFQwxUCM1fDAvLteG4vBi9IlQMTt3k8pU7n4MSZUoN2IKJl4h7W2QIcK2zdWfnnGa4BT/ll/wqlQDyYkTXBNPQkUbHH+Y91Xh0QfrTCI7mcib7SuRN2dI8FAeA+wmDMOGcXGsLl678fdG8A3WuuOc5TLsPAHy9hENI/cC2Nrrzf/mKod9Gj7D+HTkC37J09IVxve3aXe3QzpOB0s7ZsCwDFSu7ixkg+KT+DbeXqKTPF46REIJAOQWGLcHktwQHbRyrngnR56cIFJ6Cy39cnNVplBVuso0FtEtQv1DqFHwMlC1jqd8cAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XQF9iNDVkcv/2mMV52DarQOYEGbKOZVEVCGQmv5YFgM=;
 b=Xi6qYPdjL4AoR8D/GS93Y575HQeK9vAEfYYDIAjKLQbNT/25bcahfuDsvpPf7GaD7VSJrmTXVU+TRPJD3UYMsSq11DVQJSxqDPN7Svrr5CYDgfAH8QwuZwDHiaCkLXwzeA3tinFBri/HCLe/Ob39VSylgtG3pLR9FNAJwZouenCv5/QwOgmhcpX/jNhP69251Iq5l17Rk3C3iDRf6/4aNM5P6v2GbhnD4CGlhMCr23YNN+rU/SXljnLUkFcuOa8057H2Lfh0dxIQ7QvKUucOAH72e3V2NWp3KR+/aG8CKtH3n4pmOVQa01kWQkyz9pgRHtE5ZmJjJXB1KdM14ummGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XQF9iNDVkcv/2mMV52DarQOYEGbKOZVEVCGQmv5YFgM=;
 b=N+PfFnID6dp3Sa2picQBu64h4Pj9fw1sfYOw645eikyQbrA7F52WvjUvj1V3/dESDGsOKDP7vcVMkEXtvykQUSifgms5/FKim0eFm/z1BnuCJO5m8DK9svFI+z/eGCM07dM9Pb86tTzthiV8mr2va+c+n0iDpv7YstVIQ0BArq6MWcuxbqj7uTkW0iXOn8rt0wAVTFbX2Nv3JHYodOnGmubzJzDunBobCOmI1m+6gWhElnqBggSEUD/R7b8KSGoVKYBVnjLG1pJNfC2lRa1tvyRnBm3wN13uXtyi1Nuwk28aUwIx03ClFZFPSTysXLhs6mS6jysFt8mvHKrkI72jUw==
Received: from SJ0PR05CA0119.namprd05.prod.outlook.com (2603:10b6:a03:334::34)
 by BY5PR12MB4324.namprd12.prod.outlook.com (2603:10b6:a03:209::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Sun, 22 Nov
 2026 17:39:54 +0000
Received: from MW1PEPF0001888E.namprd03.prod.outlook.com
 (2603:10b6:a03:334:cafe::8f) by SJ0PR05CA0119.outlook.office365.com
 (2603:10b6:a03:334::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.639.0 via Frontend Transport; Sun, 22
 Nov 2026 17:39:54 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 MW1PEPF0001888E.mail.protection.outlook.com (10.167.249.165) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.639.5 via Frontend Transport; Sun, 22 Nov 2026 17:39:54 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Sun, 22 Nov
 2026 09:39:40 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Sun, 22 Nov 2026 09:39:40 -0800
Received: from [192.168.122.1] (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Sun, 22 Nov 2026 09:39:37 -0800
From: Edward Srouji <edwards@nvidia.com>
Date: Sun, 22 Nov 2026 19:39:14 +0200
Subject: [PATCH rdma-next 6/9] RDMA/mlx5: Pass the port and subtype to
 handle_port_change()
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20261122-mlx5-port-events-probe-v1-6-0d54e3d53c61@nvidia.com>
References: <20261122-mlx5-port-events-probe-v1-0-0d54e3d53c61@nvidia.com>
In-Reply-To: <20261122-mlx5-port-events-probe-v1-0-0d54e3d53c61@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, "Maor
 Gottlieb" <maorg@nvidia.com>, Chiara Meiohas <cmeiohas@nvidia.com>, Mark
 Bloch <mbloch@nvidia.com>, Maher Sanalla <msanalla@nvidia.com>, Patrisious
 Haddad <phaddad@nvidia.com>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Edward
 Srouji" <edwards@nvidia.com>, Michael Gur <michaelgur@nvidia.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795369157; l=2928;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=GTXRO9GjX5luhm2xur2JEllrSnYHygTH2XVALeNxRFw=;
 b=DYSoJo+yPGbvvGVW/Huxk/YViXCMdQDkXSR7jsRga6fQl4SO1ItV3hEJWUatbpZFcv7TU3YTn
 vwWHOccaDBtDAXyw87jrPluYSGOeUhz1Qdpa6lTLvOlLgHI3z7X3YHR
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW1PEPF0001888E:EE_|BY5PR12MB4324:EE_
X-MS-Office365-Filtering-Correlation-Id: 4aaf2dd6-427f-427b-d953-08df48bf9e66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|23010399003|36860700016|261009223327099003|261009221727099003|261009223027099003|261009221227099003|261009220027099003|18002099003|22082099003|261022105027099003|261026121527099003|261026140227099003|261028144727099003|261021123027099003|261021121427099003|261102123227099003|56012099006|10067099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	BFD8orJzSAT5bdgEjHxTp4rU1P6YgggCwbk1cmFhfNX4zm9cSTH4VuOP0jXkajkPDz8Ob4jx15bQDE0JHJUJaLTEfRynwNfT83K81PqQddRR07B4Qtz+NFmOPV7SriwAmwzDNUw1JtLNFVyFCoErkEQa5e7OI4qBr8dIi9ILGUlofIzuv4rrO4ktYPtNFr2xvEA9CTYLKoXyamS51MnZ6aJ0wc1lNlXr97I4fycKsXBslQrK7FHu+GU1c5jXRoJcBG2acIpDvNoujSZjXNQpT4dcWz9TwbODGCTotE7D+NycwSD65jzdqy5Xa+thy5WCP0vKbSUHc4qTY7RkukcZCEIPcbyoTsYS35kBzvkNF2A20E/vhDJTOhy6bGRsC4cCOhmHSE1LDrkSe729kzpmnlEqbgjVQ/gu52FLYqfC5adC/1FrHKgFK7FTYczKhL+zrqGEadv+R/Nw9rCBT8LiNxXeJWGeJAHlWK3fpYpD0x8d4xZzykSIFX4b1PyJEvHWC0FK/X/oRLW+7oZNrf6KexXeTiBlY9ODfg2GE0u8auBtp1LweftJHq3mO9RftxzVOeN9WlEV0H0gOBrTe4h6KlU0wafdilgXqzBmhYrpJXe4dL+BY4VFu+KdSqjTjvzQ8ltPX0gEq/YXZvXuEtw2NNKT/NMTBw6gHFMgtYbk3UlHLblBX6/sljNfQggTi38o2/EIQwMIs0DnfIBSxU2G4w==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(23010399003)(36860700016)(261009223327099003)(261009221727099003)(261009223027099003)(261009221227099003)(261009220027099003)(18002099003)(22082099003)(261022105027099003)(261026121527099003)(261026140227099003)(261028144727099003)(261021123027099003)(261021121427099003)(261102123227099003)(56012099006)(10067099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	BxMOysxVHVJw5nqhCZP3ScDuROkenHQcZrItOitdAWjzg01vGuyuCYPlYUwMKI7GbzlXhnCUMiqlliF1+L5e72TZ4co6AaajkdLYM/v7h1PfKbNE8kDej+ZvPYAxUPys7agZP5ShkwzzBtD6kBrP+VfDjmfX9R+r0qp4hrOI1StXruPiWvtAlADkO0iZmCzZCHLFpuZSoH5my/mC1xZ1oc1FfDT3I259O4uRbp+Mq4/aYfKcvarD+vCE8nApjLAOUnUaG9w6m7fqVKTcr3ZkpBeQZWh/zxeAMMxm1K9mA4pj8kJcbpYKuuC9kbidH6lx4MqUhaFWPT6P5E59+yuuzVAKCgvwm5y/MTLIGS37xuvpmxnGgI7qYNp30Sj+vCEuIYcfVLtMbp/73EHcXCzJ8O1iv9ouRdvqy8FIzK4fhsGkcY6lwKdUQe3jPl8Ofe4t
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2026 17:39:54.2284
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4aaf2dd6-427f-427b-d953-08df48bf9e66
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MW1PEPF0001888E.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4324

handle_port_change() decodes the port and the subtype from the EQE.
Take them as arguments instead, so that a later patch can also pass
port events it recorded.

No functional change.

Reviewed-by: Michael Gur <michaelgur@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
 drivers/infiniband/hw/mlx5/main.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 775c3612a427a66ccb597595e149e3eada486add..954b141a9c927d5cf4f20a17cc633de09624b0ef 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3041,10 +3041,15 @@ static void delay_drop_handler(struct work_struct *work)
 	mutex_unlock(&delay_drop->lock);
 }
 
+static u32 mlx5_ib_eqe_port_num(struct mlx5_eqe *eqe)
+{
+	return (eqe->data.port.port >> 4) & 0xf;
+}
+
 static void handle_general_event(struct mlx5_ib_dev *ibdev, struct mlx5_eqe *eqe,
 				 struct ib_event *ibev)
 {
-	u32 port = (eqe->data.port.port >> 4) & 0xf;
+	u32 port = mlx5_ib_eqe_port_num(eqe);
 
 	switch (eqe->sub_type) {
 	case MLX5_GENERAL_SUBTYPE_DELAY_DROP_TIMEOUT:
@@ -3057,11 +3062,9 @@ static void handle_general_event(struct mlx5_ib_dev *ibdev, struct mlx5_eqe *eqe
 	}
 }
 
-static int handle_port_change(struct mlx5_ib_dev *ibdev, struct mlx5_eqe *eqe,
+static int handle_port_change(struct mlx5_ib_dev *ibdev, u32 port, u8 sub_type,
 			      struct ib_event *ibev)
 {
-	u32 port = (eqe->data.port.port >> 4) & 0xf;
-
 	if (!rdma_is_port_valid(&ibdev->ib_dev, port)) {
 		mlx5_ib_warn(ibdev, "warning: event on port %d\n", port);
 		return -EINVAL;
@@ -3069,7 +3072,7 @@ static int handle_port_change(struct mlx5_ib_dev *ibdev, struct mlx5_eqe *eqe,
 
 	ibev->element.port_num = port;
 
-	switch (eqe->sub_type) {
+	switch (sub_type) {
 	case MLX5_PORT_CHANGE_SUBTYPE_ACTIVE:
 	case MLX5_PORT_CHANGE_SUBTYPE_DOWN:
 	case MLX5_PORT_CHANGE_SUBTYPE_INITIALIZED:
@@ -3088,7 +3091,7 @@ static int handle_port_change(struct mlx5_ib_dev *ibdev, struct mlx5_eqe *eqe,
 					    IB_LINK_LAYER_ETHERNET)
 			return -EINVAL;
 
-		ibev->event = (eqe->sub_type == MLX5_PORT_CHANGE_SUBTYPE_ACTIVE) ?
+		ibev->event = (sub_type == MLX5_PORT_CHANGE_SUBTYPE_ACTIVE) ?
 				IB_EVENT_PORT_ACTIVE : IB_EVENT_PORT_ERR;
 		break;
 
@@ -3131,10 +3134,14 @@ static void mlx5_ib_handle_event(struct work_struct *_work)
 	}
 
 	switch (work->event) {
-	case MLX5_EVENT_TYPE_PORT_CHANGE:
-		if (handle_port_change(ibdev, work->param, &ibev))
+	case MLX5_EVENT_TYPE_PORT_CHANGE: {
+		struct mlx5_eqe *eqe = work->param;
+
+		if (handle_port_change(ibdev, mlx5_ib_eqe_port_num(eqe),
+				       eqe->sub_type, &ibev))
 			goto out;
 		break;
+	}
 	case MLX5_EVENT_TYPE_GENERAL_EVENT:
 		handle_general_event(ibdev, work->param, &ibev);
 		fallthrough;

-- 
2.49.0

