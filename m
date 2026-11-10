Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.49
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794336051;
	b=GcygW5Eh4g1xpeIsotv4vTqIDW80HSU93uCPbdl49QoqzwSwfo3ADi+LTHdasch5LhWk
	 QkImn06v90E1BFTmEn+QSR1+BwuaRD+Bp+iZNHNoF9nQHw14B2jib6i496Mp5wfEuxajP
	 m6JiE8SBv5EpQcT7Kk1eP21M/JgH1R2PxDKqEIcwUKILj22MOoMgbCE1Ga4fKIxn8xwsr
	 La25C7+JkWlswPZrSx/q7DdjYJ/DaTon2nuovOHvTgIOBJ7NH1O44COt/ZaDnwZ3Ct4BM
	 aL92wI49ENeatlI7Z5+dWjCAuaoBER1XOI1dKBwXsad9SEJL+Q96sAdKkRz9jgC7KRA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794336051;
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
	bh=owYz21d+nhziH0yNNc5k/JVxxPDQU7gRwWzW8tCTMF8=;
	b=YuZXI7cgyqc+ula8yqTWm+/Tr6jFI2vCIRjhIIoRv1XLN01zEFRZZ564Qly4UfGJhR5W
	 0UB0R91FIA8z2AQQgnNASiz1+2+e/tX0p1QfvDAEzgy6/O0AcREhMDtWJ0tNyyMQK2Bhw
	 OX5AaHS25ioLZ5j4UZrpsIxxU2V1SWDw/LqMZ6xixxf0ONx2/dWbOnHY7UakuGqm6TaJn
	 Wl7+zzqBDOD9v0jS0MclvCyrrcSwFsk5i0HmgGOmx9N8a79XWiyQi1FeixWGXyKABNov9
	 j5lwelgidbjC8D0Fk24zCMy7iiskPurpUrvgYyt+5NsHRSLbSGW9X7LPeUvABah/qvw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=oJZ8aoFe;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.49
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012049.outbound.protection.outlook.com [40.107.209.49])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB89E606B5B4;
	Tue, 10 Nov 2026 18:40:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EB89E606B5B4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=oJZ8aoFe
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BMQ+8QyXWdjAr3aWa5jXrjHTjzQSAtw8H53bkxeqRvmR8z/mBUQ0mXjAURYRey6DjOcFjDmMBg10bgrvMNbyhx4iXDmS83FCT6ItMGY9+KMPM5mu8XXEUJtlBGomSkuWdTkiVGV0LoMhhwY5sQkQ/s59mrzIBaizzxynX1YvD95IQzW/iNiXmOZKkbp1ihjVmODvfSkANIWDHOMlrAewgExiId5TBpIQ18Af18VJlX3SuqAUbqXPZYShRKs/RrbuyTAWAHu6E5UivVxxpkq7T+aPr5OHq1KE7hjBQ1j+N2pXuZDM0LDNA7uH8HvDDdGxjw/sTjTSF/gAEQvl+CpiVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=owYz21d+nhziH0yNNc5k/JVxxPDQU7gRwWzW8tCTMF8=;
 b=SFnmlKT2DFDqmnal/8knnY1n0Ao0TdKJsoNfZcZ24+EIq4ZyxrThtnhEnVgyFfEgJfz++zgfOLMN/M3TiW0pggcQUvjLiAYf2yCmzdcXhMubDMVH2q9sgk9dGI1slEIaKPXa+cIF2WlQzW9+WlAE7tFtDA2BufLiUhyTuhSWorpqcW8tGer8lSTl57nuhaDDKROnxQ85cG8oBE9YYq8cai9qn0in+bOX9jaCN2Ipvi6YKhPBpNfmmRtgowjKCBfVL1re/Gw03wK2hNPLvq2hGrI/nb/FfOcYwQAjGAmVfzReIc6d5ANLYMtGYPn9b8zPmgnUSWD0EOI2s8eXtHX7Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=owYz21d+nhziH0yNNc5k/JVxxPDQU7gRwWzW8tCTMF8=;
 b=oJZ8aoFeel8DjLwOigZ9lXv9IVjFTWvBXA70JeKLEprSv8sI0QfAZuDfxyRcvHeq2BNQM04Z5eYgeu8+lZ+E6Q2aAl9k7/mXi5oy+S5qAD3ITt6mRPkviOLZqUVxBk7BleCqcTFN3rDCK/4qcaOut9ExbqjEB5NPCax/qm6Dece2pjc5PFNpI4t5vY6NGxc+xBO/Zc9M9IX6OWsYjMUja/Q3Tt/mXVhY3PC7TNki93HFletE6Q5VZO47ol/FxbE1BdiUZ8+iM92o+ek4NJxBzZn/k70vIYJK/oDk20lEXIndwSJsLEsAdsIdfav+wuzJRcJAJm4jcg7u9h1pSuJz4Q==
Received: from CY5PR14CA0019.namprd14.prod.outlook.com (2603:10b6:930:2::26)
 by MN6PR12MB8471.namprd12.prod.outlook.com (2603:10b6:208:473::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Tue, 10 Nov
 2026 18:40:46 +0000
Received: from PH2PEPF00048918.namprd05.prod.outlook.com
 (2603:10b6:930:2:cafe::8c) by CY5PR14CA0019.outlook.office365.com
 (2603:10b6:930:2::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Tue, 10
 Nov 2026 18:40:46 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 PH2PEPF00048918.mail.protection.outlook.com (10.167.243.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 10 Nov 2026 18:40:45 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 10:40:22 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 10:40:21 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 10
 Nov 2026 10:40:14 -0800
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
Subject: [PATCH net-next V2 12/13] net/mlx5e: Disable data direct on data direct device unbind
Date: Tue, 10 Nov 2026 20:38:25 +0200
Message-ID: <20261110183826.2927274-13-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: PH2PEPF00048918:EE_|MN6PR12MB8471:EE_
X-MS-Office365-Filtering-Correlation-Id: b4f39d94-e6cf-4c6d-f2ad-08df3f5a2203
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|1800799024|376014|82310400026|7416014|261009223027099003|10067099003|261028144727099003|261102123227099003|261021123027099003|261022105027099003|261021121427099003|261022075727099003|261021135927099003|261026140227099003|261026121527099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	EXhI70Nq43FwdwhkqNN3UQSiQE+rsS14VktMD04PHx1Ub3ZHC9fH+/vGrOr6wHxh5ZKA3qGlv881K3qmLz2NINtbL2RzIBCerrHwPBLXoH9ottvwDxzBzUQvWxKaBXcjVCezs2ThFlvd3DeX0EVspvM5DZsUcchZ/6Y6hVyMW+u0rz4RtBUivzD29MKSfDWFEItsm+IPI+CqS3WyXgJc0zUQFcuYJcjnKgWD5ao0FmrIVWZM1OxkgGLFQu+ZIft9uLQ6aOVfqMu3A6rXvk/YR/58p+KYW9HWch0o+Rj1WCMzK9XKy/p/nno7MkPSErGwOIJVzFMKb7YkM+v1MvQg7fKl71ehycpzc145/7VpSFpAAe2lEbQGrYiqsffI4Xjsbnc5YyS/C3q4hHpPkWJEwDBlyv68n9NgZsqfKT67ib/CAGkmgy1lyvTs4RC7pwbB2BExrm9aNM8PCZxoE83CInwwDu4nMV/970raEzCEPCzWuoSHtQr1zN5Etq5Tc5N5+PFFu4RNbsk7ajE8Pv/U6YDktUKZrdukuaU6eFD2UTVGu7/8E7NZNCF1j6kUfElxNw24m2jFM3P1Qs5C2ROlHDCmKbv7tK/caAHN4PChn7ovbZa19kbJLJYCDapROaXvYrKYpMTENHARaY3VgCBKConFEUH+Unjd54l2RxZpNRXYEPyYgbidxd+VSnv/k8OhfcYF+JYMnYF5A9Y59+kTXw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(1800799024)(376014)(82310400026)(7416014)(261009223027099003)(10067099003)(261028144727099003)(261102123227099003)(261021123027099003)(261022105027099003)(261021121427099003)(261022075727099003)(261021135927099003)(261026140227099003)(261026121527099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	lDj/Tr/h6BORWEaR6AC3YX6Rep4MGjTKPL0xdjBogRvPYPsrhDDNc3B63hQ1HXSKtFZbCqdJKaNyxc65Nb/+yWMf0GYvWDKdeXY3g6jRywe1RBs6Tk+jKkIsIgR+SyjCXRcIusHAOnkS2oLb5VFMxgtanW6TjBHKxYcC+wnedRAi777ReVPf0psYEwszE2B1C57nIHkp1zDWiyYsG5QfVh8scCCosv69PcaZl+hkphb3f8ESCNBGFKsCQ0rJxJhg/7SQHXo3FuhzkRUo8Pb1G1wd+mr8VmDCyiBNPwp1YpcQUSVVTHKyt6fU7Z58CfXK4bdNwnVdzZsnXkUdmjex0cz4BnR/VUdK/ZB9BXdyotuQedJASvC7iUWq1cjVfer6YKVaiYxOXoZqi0nGS+9k4y3PxTnieb65NWpjZ5F+hEcyKwyybJBr8F7cVtlkvVyp
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 18:40:45.9208
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b4f39d94-e6cf-4c6d-f2ad-08df3f5a2203
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	PH2PEPF00048918.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8471

From: Dragos Tatulea <dtatulea@nvidia.com>

To prevent invalid accesses after the data direct device is unbound,
stop the netdev and drop the providers using the unbound DMA device. To
prevent further use disable the private flag.

Also release the providers during suspend because the notifier
is disabled at that point and a data direct device unbind would
go unnoticed. This would result in dangling references to the
unbound DMA device.

FW reset, devlink reload and health recovery are not affected: they
unregister the netdev, which releases the memory providers and dmabuf
bindings.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/data_direct.c |  4 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 67 ++++++++++++++++++-
 2 files changed, 68 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/data_direct.c b/drivers/net/ethernet/mellanox/mlx5/core/data_direct.c
index 7db94b8a5b79..246a03f44afd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/data_direct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/data_direct.c
@@ -198,9 +198,11 @@ static void mlx5_data_direct_bind(struct mlx5_data_direct_registration *reg,
 static void
 mlx5_data_direct_do_unbind(struct mlx5_data_direct_registration *reg)
 {
+	struct mlx5_data_direct_dev *dev = reg->dd.dev;
+
 	WRITE_ONCE(reg->dd.dev, NULL);
 	blocking_notifier_call_chain(&reg->users, MLX5_DATA_DIRECT_UNBIND,
-				     NULL);
+				     dev);
 }
 
 int mlx5_data_direct_init(struct mlx5_core_dev *mdev)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index ebd41f24330d..63d91ef0dda8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -6170,9 +6170,53 @@ static int mlx5e_data_direct_event(struct notifier_block *nb,
 {
 	struct mlx5e_priv *priv = container_of(nb, struct mlx5e_priv,
 					       data_direct_nb);
+	struct mlx5_data_direct_dev *dd_dev = data;
+	struct net_device *netdev = priv->netdev;
+	struct mlx5e_params new_params;
+	bool enabled, reopen;
+	int err;
+
+	if (action != MLX5_DATA_DIRECT_UNBIND)
+		return NOTIFY_DONE;
+
+	rtnl_lock();
+	netdev_lock(netdev);
+
+	mutex_lock(&priv->state_lock);
+	enabled = MLX5E_GET_PFLAG(&priv->channels.params,
+				  MLX5E_PFLAG_DATA_DIRECT);
+	mutex_unlock(&priv->state_lock);
+	if (!enabled)
+		goto out;
+
+	reopen = netif_running(netdev);
+	netif_close(netdev);
+
+	err = netdev_unbind_dma_dev(netdev, dd_dev->device);
+	if (WARN_ON_ONCE(err)) {
+		netdev_err(netdev, "Failed to unbind dma device, won't reopen netdev, err=%d\n",
+			   err);
+		goto out;
+	}
+
+	mutex_lock(&priv->state_lock);
+	new_params = priv->channels.params;
+	MLX5E_SET_PFLAG(&new_params, MLX5E_PFLAG_DATA_DIRECT, false);
+	mlx5e_safe_switch_params(priv, &new_params, NULL, NULL, false);
+	mutex_unlock(&priv->state_lock);
+
+	netdev_info(netdev, "data_direct device unbound, disabled data_direct\n");
 
-	if (action == MLX5_DATA_DIRECT_UNBIND)
-		mlx5_core_dbg(priv->mdev, "data direct device unbound\n");
+	if (reopen) {
+		err = netif_open(netdev, NULL);
+		if (err)
+			netdev_err(netdev, "Failed to reopen after data_direct unbind, err=%d\n",
+				   err);
+	}
+
+out:
+	netdev_unlock(netdev);
+	rtnl_unlock();
 
 	return NOTIFY_OK;
 }
@@ -6407,6 +6451,24 @@ static int mlx5e_nic_enable(struct mlx5e_priv *priv)
 	return err;
 }
 
+static void mlx5e_data_direct_unbind_dev(struct mlx5e_priv *priv)
+{
+	struct mlx5_data_direct_dev *dd_dev;
+	bool enabled;
+
+	dd_dev = mlx5_data_direct_get_dev(priv->mdev->data_direct);
+	if (!dd_dev)
+		return;
+
+	mutex_lock(&priv->state_lock);
+	enabled = MLX5E_GET_PFLAG(&priv->channels.params,
+				  MLX5E_PFLAG_DATA_DIRECT);
+	mutex_unlock(&priv->state_lock);
+	if (enabled)
+		WARN_ON_ONCE(netdev_unbind_dma_dev(priv->netdev,
+						   dd_dev->device));
+}
+
 static void mlx5e_nic_disable(struct mlx5e_priv *priv)
 {
 	struct mlx5_core_dev *mdev = priv->mdev;
@@ -6424,6 +6486,7 @@ static void mlx5e_nic_disable(struct mlx5e_priv *priv)
 		mlx5e_close_trap(priv->en_trap);
 		priv->en_trap = NULL;
 	}
+	mlx5e_data_direct_unbind_dev(priv);
 	netdev_unlock(priv->netdev);
 	rtnl_unlock();
 
-- 
2.44.0

