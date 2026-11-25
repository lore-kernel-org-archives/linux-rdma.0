Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.1
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795641852;
	b=ClFGtKiyhcF0bJXO8lHBTHyvBWYVz61MeIbjoTzW8xbRRQaWwX30EtwtkVtl/DDFQFgM
	 EtwjgRUfkb9D2XPvgyLH1xYFpYyfvDswKzqSd153+j4BLJRoI74YNYjb0ZdMjECmwTCRB
	 qMeLbrfglISpZSrm8q1fGnnATA3Wo3HdlRINLPg9JrpDjkpSR5rg98S+L2IB3oFzYxqQG
	 tP2Z8VRUrum2BL2HOFBXXCBy3GIo/47z4JP+/+8GUCABsUbAIEJLFyRlTF+mtWn5G4sQk
	 dBNuknZ1ykSbZGNqBzrPJ2fF5AsTVNkiT9f6xyb/hlwvAQ5RTc4S9JjZ+Fw1U4RCC3w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795641852;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:Content-Type:
	 X-NV-OnPremToCloud:X-EOPAttributedMessage:X-MS-PublicTrafficType:
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
	bh=YHeH2C+9Ej3p1rzMh0fdu85DlNpQSD2vUNK/yDfb6z4=;
	b=tWf8CrdM3X4aF73RbUzt/wo7WYVDq0FZsZ8gwpPfurk4Jyw6C31YOaGMov6P58yAk1ou
	 UD2nELkPlEyb78MdR6WEDytUDr89QsJ2D9HOwoqkwDnhUgWK6gUNKIjOHffWmZGJqGO+T
	 b1DFs5DMgHzQd+qRGHcEp4vgqqXKI7dawq58Ccy+u0SMO4XjBLa7u3q82amiBqMprXtQ/
	 lmUry+QlTCXdmWt01wrSDFw3gg1FTODo7KOMWUtfJKOo7TGh7qZ4T5qH5UPb9YzCbJXH/
	 ks1g2t5MjpcwYy4nVXe/hkBo5k7M3Sz14d9E8BMRX3MWN65P0NBUgPbeCyM31/xHE4Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=utMvSJ3k;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.1
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012001.outbound.protection.outlook.com [52.101.43.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A58D606A31E;
	Wed, 25 Nov 2026 21:24:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0A58D606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=utMvSJ3k
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mPTjKmARYF/4Wkb12XMtjkfNN3XQky+C3tcIsA47OuL094b+4b3f53EBaBhA0khh9SqQyi6NQ0myujixHc/1ZuIe2fuckFGhKfzn+zaMlbWNR8CiD/7ViaKRi0MpAFBZmQWUf43Ijgwfat7iO9arNgUPeCfmP6IPg5stu7VsuxiJJDLbb2UGBrJp8JTLATnjFgIpYr8g4OVxJGEiMmk6RCzcLGd8/iU65iXN9NmvRdTuNxS1oXuZJRJXLBJXHuA5lbOnwaPHwgd5pRPBgZh2vib6QCv4M26/IX1vReGuVPpUfin9WD+nSehGLcZc2kESUjx7qBpTtNPoFA8irUT2jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YHeH2C+9Ej3p1rzMh0fdu85DlNpQSD2vUNK/yDfb6z4=;
 b=VdZAoCo51PRLOvq/gCILQ1C49TBlexdTzLOjpSToxiRucd4y7wHH7S7S3qSZIK3u4uM98gegGmpZ0TEzu+HUzL12sVoufKVoRw2+atCH2BhKsQrMin3g1X2M3GFMxN1FJc3uv7N+F2pmVdqJ7dXg454Seqsfi59Sz5hKG3vvcCNblJ8XSH3YNeRxT7bXeL2T13+ycqfM/Mfh8lvIFyyznspcKSF2fDE3mReOa9UAi3wRlk92L7R2Y3PEcZn9Pt5pbbZ9qGJ1TnH+w03Fj0Ad6zv3+5OPf92LbOObwg64OyUkUdN3ZciJmMn59jmMKrcfi4DJ0j9SuWANT4t8Memn8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YHeH2C+9Ej3p1rzMh0fdu85DlNpQSD2vUNK/yDfb6z4=;
 b=utMvSJ3k+zrOwle0/gSMDYNJBwRoZWjT5DkTKHEpqVzXepjSiy8W15k8PwS6GUWtu6QwCVrAhfzUhlkBNR/Rodzle/ytvYaYSuMckQLemJ2WLONPLGnKAKCXwDwHgdplrH1K4TkibbsxrgVZlkLa0LydIqJ6XD3Qm+Jj7oOto1zsoo2Rw7fUTNE4OdwJ3/6RCXaB4spKGz+hKbZiMZNn1aDBU10GBSEvgW9I3TFZ9LhUB/qACYScss65WTTZqJfv/dJyqlPT/ODlWeg/fN02tnP/70Q6KsnJ/BYsJ1BFNB133xzAytzKS0AE7HJA62r+RfvGxlVfsUXPSWPizxaH1g==
Received: from BN9PR03CA0203.namprd03.prod.outlook.com (2603:10b6:408:f9::28)
 by SA1PR12MB999229.namprd12.prod.outlook.com (2603:10b6:806:4db::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.6; Wed, 25 Nov
 2026 21:24:08 +0000
Received: from BL2PEPF000352D0.namprd02.prod.outlook.com
 (2603:10b6:408:f9:cafe::5a) by BN9PR03CA0203.outlook.office365.com
 (2603:10b6:408:f9::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.7 via Frontend Transport; Wed, 25
 Nov 2026 21:24:07 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BL2PEPF000352D0.mail.protection.outlook.com (10.167.249.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.3 via Frontend Transport; Wed, 25 Nov 2026 21:24:07 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Wed, 25 Nov
 2026 13:23:54 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Wed, 25 Nov 2026 13:23:54 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Wed, 25 Nov 2026 13:23:49 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Gal Pressman <gal@nvidia.com>, Jiri Pirko <jiri@resnulli.us>, "Jonathan
 Corbet" <corbet@lwn.net>, Leon Romanovsky <leon@kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>, Randy Dunlap
	<rdunlap@infradead.org>, Saeed Mahameed <saeedm@nvidia.com>, Shay Drori
	<shayd@nvidia.com>, Shuah Khan <skhan@linuxfoundation.org>, Simon Horman
	<horms@kernel.org>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next] net/mlx5: Expose SW RoCE monitor matched packets counter
Date: Wed, 25 Nov 2026 23:23:43 +0200
Message-ID: <20261125212344.243989-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
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
X-MS-TrafficTypeDiagnostic: BL2PEPF000352D0:EE_|SA1PR12MB999229:EE_
X-MS-Office365-Filtering-Correlation-Id: e64dce76-f18a-4687-b5fe-08df4b3a7048
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700016|1800799024|82310400026|23010399003|10067099003|11063799006|56012099006|261022075727099003|261022105027099003|261021123027099003|261026140227099003|261028144727099003|261021135927099003|261021121427099003|261026121527099003|261102123227099003|261009223027099003|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	fWusLXftg5u38DOchqc/0JIqeLARuqMv/YbWA2Jyma3B+iN+/AykcBrFR6ryyfv9jA6JBiDU7StJ434WhHCECJu0X+Ez4PCcGCfH/tmKrIYoAT+cphy0ywxKVrJDKzITRLOztoIlNmd4cvCaHqRNf3dc10Kz0Y8gYNg75pdK/DyEQTmoLY2LT8tJlk6zHKCUPSH0VCboAE8OP6IpzqXgrJ59VphI1mIp4jp74nwYU3wbkRkjrDSN38bzMtGmlY7vwX+5VukLGUZTaggrh2o32lqrMkdmf/bEsjRZGfk8hwSLEpbwa55SZdhwvubUH+2ug+jkfZoX8zYdu2N28SVcCznyOfXb7xiZuXHvSDEmp3SVN50rMNVRkuHHnKw5wwhsmHXCJDFwt2vMY1rRW0ARG3Vt1IhhWefNOjbwFGXAwbbFD2SYR4Y4prBw/cAauvSU90Jy/zaZBaKXJ7hIqpptRxT7dKbekdqwfSObDDbFg/ssOkcb2iFB9TUg/F71KvCjaAdMyEFt9I0sGms+D6xmybKWVUq89jW8q/Lom57kRgXq3qaUQnhFONuEHOiSkyEUEK4V/XEjuoYR62Rzlb9/iJap8mHYrcRZmpTn1voNjIKY6RgUTE6O4bSoNKNLQ3c8HMDByVtqfFmnGTUFomBUAEro6+bLMIzBqBDSFbkSs+vSQaqndL5jXOfJ/vJX88IXYG37FHs/nyW9qCd3DuEzDw==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700016)(1800799024)(82310400026)(23010399003)(10067099003)(11063799006)(56012099006)(261022075727099003)(261022105027099003)(261021123027099003)(261026140227099003)(261028144727099003)(261021135927099003)(261021121427099003)(261026121527099003)(261102123227099003)(261009223027099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	KZgbdnuCkGSl349xvTNficKZtpQviEYd/WiIsJ/Kjzm+E1xLdgt0EHK53wufER87fp+igH6OlIT2vvbcB9UVS+nIivzdV/0iNiwc/y4331kJS7F1Q0P84ZlyoBa2v+EU+sZvJuYtm//Albw6FH8hFnAfglyFszQ0HzmfGmAYXHfYzbN9tNrZgPbzRRQRakmfz4ZiqqjCyuAkVAxlq7SSgQyz6rJDdV0TQ2VMXWv8QvcNpd/4nGtG9oMEXamQjeRFc2Wki8suonap0Cv5IlKJT9G21MRG4PDa+TuU9dpEC0E4vtVfJPv9CXMu5t36/ORIQ8Cd/LGBCL5mbUAdWivYjZTxFHxQHMzCuHd8+lmOoN4BVmtxGYCMYTZUgSFfpHw4jn0PPPBltDqKzMgTk9KbxQ5LiJznMyDeaXNYyzVLG8gedgB4JG332K+jdSyhOcio
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 21:24:07.2081
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e64dce76-f18a-4687-b5fe-08df4b3a7048
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL2PEPF000352D0.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB999229

From: Moshe Shemesh <moshe@nvidia.com>

Add the sw_roce_monitor_matched_packets counter to the vnic health
reporter diagnose.

- sw_roce_monitor_matched_packets
    number of packets generated by the Ethernet SQs of the vNIC that
    matched the configured SW RoCE monitor classifier. The classifier
    is currently set to RoCEv2 only, so the counter collects statistics
    of software-generated RoCEv2 packets transmitted from the Ethernet
    SQs of the selected managed vHCA.

The counter is exposed only when the device reports support through
NIC_CAP_REG.sw_roce_monitor_classifier. As NIC_CAP_REG is now needed by
more than one counter, move its read to
mlx5_reporter_vnic_diagnose_counters() so that a single read serves all
of its users.

Example access:
    $ devlink health diagnose pci/0000:08:00.0 reporter vnic
	vNIC env counters:
	total_error_queues: 0 send_queue_priority_update_flow: 0
	comp_eq_overrun: 0 async_eq_overrun: 0 cq_overrun: 0
	invalid_command: 0 quota_exceeded_command: 0
	nic_receive_steering_discard: 0 icm_consumption: 1032
	bar_uar_access: 1279 odp_local_triggered_page_fault: 20
	odp_remote_triggered_page_fault: 34
	sw_roce_monitor_matched_packets: 17

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Shay Drori <shayd@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 Documentation/networking/devlink/mlx5.rst     |  6 +++
 .../mellanox/mlx5/core/diag/reporter_vnic.c   | 39 ++++++++++++-------
 2 files changed, 31 insertions(+), 14 deletions(-)

diff --git a/Documentation/networking/devlink/mlx5.rst b/Documentation/networking/devlink/mlx5.rst
index 9421c89951a0..eedb6d1379b2 100644
--- a/Documentation/networking/devlink/mlx5.rst
+++ b/Documentation/networking/devlink/mlx5.rst
@@ -410,6 +410,12 @@ Description of the vnic counters:
         number of locally-triggered page-faults due to ODP.
 - odp_remote_triggered_page_fault
         number of remotly-triggered page-faults due to ODP.
+- sw_roce_monitor_matched_packets
+        number of packets generated by the Ethernet SQs of the vNIC that
+        matched the configured SW RoCE monitor classifier. When the
+        classifier is set to RoCEv2, the counter collects statistics of
+        software-generated RoCEv2 packets transmitted from the Ethernet SQs
+        of the selected managed vHCA.
 
 User commands examples:
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/reporter_vnic.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/reporter_vnic.c
index 7cae0c6e5e8a..b15ce5fdb576 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/reporter_vnic.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/reporter_vnic.c
@@ -15,29 +15,31 @@ struct mlx5_vnic_diag_stats {
 	__be64 query_vnic_env_out[MLX5_ST_SZ_QW(query_vnic_env_out)];
 };
 
+static int mlx5_reporter_vnic_query_nic_cap(struct mlx5_core_dev *dev, u32 *out)
+{
+	u32 in[MLX5_ST_SZ_DW(nic_cap_reg)] = {};
+	int err;
+
+	err = mlx5_core_access_reg(dev, in, sizeof(in), out,
+				   MLX5_ST_SZ_BYTES(nic_cap_reg),
+				   MLX5_REG_NIC_CAP, 0, 0);
+	if (err)
+		mlx5_core_warn(dev, "Reading nic_cap_reg failed. err = %d\n",
+			       err);
+
+	return err;
+}
+
 static void mlx5_reporter_vnic_diagnose_counter_icm(struct mlx5_core_dev *dev,
 						    struct devlink_fmsg *fmsg,
 						    u16 vport_num, bool other_vport)
 {
 	u32 out_icm_reg[MLX5_ST_SZ_DW(vhca_icm_ctrl_reg)] = {};
 	u32 in_icm_reg[MLX5_ST_SZ_DW(vhca_icm_ctrl_reg)] = {};
-	u32 out_reg[MLX5_ST_SZ_DW(nic_cap_reg)] = {};
-	u32 in_reg[MLX5_ST_SZ_DW(nic_cap_reg)] = {};
 	u32 cur_alloc_icm;
-	int vhca_icm_ctrl;
 	u16 vhca_id;
 	int err;
 
-	err = mlx5_core_access_reg(dev, in_reg, sizeof(in_reg), out_reg,
-				   sizeof(out_reg), MLX5_REG_NIC_CAP, 0, 0);
-	if (err) {
-		mlx5_core_warn(dev, "Reading nic_cap_reg failed. err = %d\n", err);
-		return;
-	}
-	vhca_icm_ctrl = MLX5_GET(nic_cap_reg, out_reg, vhca_icm_ctrl);
-	if (!vhca_icm_ctrl)
-		return;
-
 	MLX5_SET(vhca_icm_ctrl_reg, in_icm_reg, vhca_id_valid, other_vport);
 	if (other_vport) {
 		err = mlx5_vport_get_vhca_id(dev, vport_num, &vhca_id);
@@ -64,7 +66,9 @@ void mlx5_reporter_vnic_diagnose_counters(struct mlx5_core_dev *dev,
 					  u16 vport_num, bool other_vport)
 {
 	u32 in[MLX5_ST_SZ_DW(query_vnic_env_in)] = {};
+	u32 cap_reg[MLX5_ST_SZ_DW(nic_cap_reg)] = {};
 	struct mlx5_vnic_diag_stats vnic;
+	bool cap_reg_valid = false;
 
 	MLX5_SET(query_vnic_env_in, in, opcode, MLX5_CMD_OP_QUERY_VNIC_ENV);
 	MLX5_SET(query_vnic_env_in, in, vport_number, vport_num);
@@ -72,6 +76,9 @@ void mlx5_reporter_vnic_diagnose_counters(struct mlx5_core_dev *dev,
 
 	mlx5_cmd_exec_inout(dev, query_vnic_env, in, &vnic.query_vnic_env_out);
 
+	if (MLX5_CAP_GEN(dev, nic_cap_reg))
+		cap_reg_valid = !mlx5_reporter_vnic_query_nic_cap(dev, cap_reg);
+
 	devlink_fmsg_pair_nest_start(fmsg, "vNIC env counters");
 	devlink_fmsg_obj_nest_start(fmsg);
 
@@ -105,7 +112,7 @@ void mlx5_reporter_vnic_diagnose_counters(struct mlx5_core_dev *dev,
 		devlink_fmsg_u64_pair_put(fmsg, "handled_pkt_steering_fail",
 					  VNIC_ENV_GET64(&vnic, handled_pkt_steering_fail));
 	}
-	if (MLX5_CAP_GEN(dev, nic_cap_reg))
+	if (cap_reg_valid && MLX5_GET(nic_cap_reg, cap_reg, vhca_icm_ctrl))
 		mlx5_reporter_vnic_diagnose_counter_icm(dev, fmsg, vport_num, other_vport);
 	if (MLX5_CAP_GEN(dev, vnic_env_cnt_bar_uar_access))
 		devlink_fmsg_u32_pair_put(fmsg, "bar_uar_access",
@@ -116,6 +123,10 @@ void mlx5_reporter_vnic_diagnose_counters(struct mlx5_core_dev *dev,
 		devlink_fmsg_u32_pair_put(fmsg, "odp_remote_triggered_page_fault",
 					  VNIC_ENV_GET(&vnic, odp_remote_triggered_page_fault));
 	}
+	if (cap_reg_valid &&
+	    MLX5_GET(nic_cap_reg, cap_reg, sw_roce_monitor_classifier))
+		devlink_fmsg_u32_pair_put(fmsg, "sw_roce_monitor_matched_packets",
+					  VNIC_ENV_GET(&vnic, sw_roce_monitor_matched_packets));
 
 	devlink_fmsg_obj_nest_end(fmsg);
 	devlink_fmsg_pair_nest_end(fmsg);

base-commit: 612848d37e68b858e15815175f1c5e609e09d719
-- 
2.44.0

