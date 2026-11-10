Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794336036;
	b=CnQK8LttcfnjE4H8oYT5m2IWvjJor9owUFVLm7jPzy9CUfiTAaVr8+iRqUttpPe3/Sco
	 NKFG4QscsgLk9Y/bIEGIm4c/wKxhxD7JrP1iqjtN414CMFwP5Eg8wzT46Df3HOg9tBHp9
	 25IZtDFtiaKEN7hKrF16EH6UVC+2zJJ5H78oevL62HbOp02anU4fBmyAk1W9FaI2/p0JS
	 jejzoeVpN01C+CbYfwEEmfglBI/1TekpTZnLnz6IIrhw+eZfk+Dc8saB3GlwIKCL8r32K
	 S9KSF9fU9hVTlA5ysx+w3d1F/YqQC4LBOF4nLgMPq8IrrN7aS/ZJ0JRNicIiqJfJCTw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794336036;
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
	bh=iFZMuViaN5NB/q0v96K6OVbOiV4q/zf4PyWZGX4KHfQ=;
	b=kUE9u2QhMRUOmNcsJyilWMD4uDfouxDifCjIHAOmGBwQhD/m5ZexSZEqndEf5qr2QAPK
	 2CQzRZ7x9oFmG5NmCEeJn1jn02V5RkQJncbRua/rt/Ts8tGAGpYX4qTmqQiY7CRTxk6Vr
	 g+3Xqy/PMglYjkYrsqbV/CdfYlk+4grGp3EeEgVnV43BQ9SW3H2q89l0bjzsM8eUBXASX
	 B1Khgt8KDpW27huDAiUFzL8K1+1F7/4AwPRL1ss4v5FIxmWTs3ye4zApUDD5aXbgER5im
	 rpvP+77NKW6w5ieF3Q71K0/PfjmaXgA6OmeFpxlwDfPvX4lc/PBf5ZlkmxtT1iltV6w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=tvv1YOV4;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.42
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012042.outbound.protection.outlook.com [40.107.209.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B43DA606B5A1;
	Tue, 10 Nov 2026 18:40:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B43DA606B5A1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=tvv1YOV4
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GTnwZekdrrPB6EaaDH4ypxNobudsl/xSdEww26PG5/mg+DQVqUajpT5stLAjelrjAEy0/st0biHt15JwOzKPaucWnJTgf+ARcBe6nsNDe5XhU0Q5dvJO11J5/z2afhWsHB0NlfMQXXpo2hvbOndDFOub97u27hMgBrBvh2Cpg8OA6GHTvCt9iiVemNwlXYHwVV8I4c/71JWl7gwW53a+DMDFvfej1QIXxS68OcqaMiT1DWHJmI4UtGp4POfsPU/t0+Q7V+vgsZHAyAFxfqWiAs5nGGhqjtzrwykVwa3fe6rFHhfTqeUliK2x+CQAHxMEIAhDeo4FQ47TYZdSR8sgxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iFZMuViaN5NB/q0v96K6OVbOiV4q/zf4PyWZGX4KHfQ=;
 b=f3LLPuvwe/50uQOjehKuif660/WUOnmmJjSErCFLQr1cBwvwJWTdhwrpjx/i6TGkWzKvCEWmmqKvl0mJ4Eh4DS8FuOHaMq9WFqmtbFKugY+NDn5Evo/s/gubmgvSdFgEzrAEhkWyQQulFv8fFxvu/lwa9+MXVc+iYmB39eeW1JjRKmP+BinnYK5VnV97PNkbhgNwPPBhAHxEzk6/9kIRpMpqqfeqH5lbLUe1mOWrPArXHa05EU5xoaBTYZzLH0HGiqYUXWZ164JoiTO9kC7afd77W7NkN1LI15VJdWrDW1gop0khCkjB1IxYhERf1tH1rgrFDDJ9lS57MAnvDRtFGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iFZMuViaN5NB/q0v96K6OVbOiV4q/zf4PyWZGX4KHfQ=;
 b=tvv1YOV4t3YdPvaY859mInhi/SPNTRbET917cQOMXeii17PNnQAumu0gMks65ix/wLYS6LPhAJb19cSvOrqHI1555Xcq4YuIoiVFbuM3v+fdAxfEvhSrLMQDz2SwC06iYrnX1fvQLu1O2NVmdazmPH9+Izre3Yg7LcMsaRy+qqQOF1icm4LELNaQogURumgugZpCkQ8yXlqmbhVwKp5OpQwsfTQxZfWplu4Ex7MbKC4O17FFUIa6Lf0TYJh8TRlOKviATEOcmLqljoo2sEWIC1nuZb14Hzx28P/TShhEdWidCqV0CifjcTbs7VF+BrWJDP4hCoI9tIyANUHeXRyvyw==
Received: from PH7P221CA0052.NAMP221.PROD.OUTLOOK.COM (2603:10b6:510:33c::23)
 by PH7PR12MB7185.namprd12.prod.outlook.com (2603:10b6:510:201::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Tue, 10 Nov
 2026 18:40:27 +0000
Received: from PH2PEPF00048914.namprd05.prod.outlook.com
 (2603:10b6:510:33c:cafe::ad) by PH7P221CA0052.outlook.office365.com
 (2603:10b6:510:33c::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Tue, 10
 Nov 2026 18:40:27 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 PH2PEPF00048914.mail.protection.outlook.com (10.167.243.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 10 Nov 2026 18:40:27 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 10:40:06 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 10:40:06 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 10
 Nov 2026 10:39:58 -0800
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
	"Tariq Toukan" <tariqt@nvidia.com>, William Tu <witu@nvidia.com>, Bobby
 Eshleman <bobbyeshleman@gmail.com>
Subject: [PATCH net-next V2 10/13] net: devmem: add netdev_has_dmabuf_binding() helper
Date: Tue, 10 Nov 2026 20:38:23 +0200
Message-ID: <20261110183826.2927274-11-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: PH2PEPF00048914:EE_|PH7PR12MB7185:EE_
X-MS-Office365-Filtering-Correlation-Id: e8bfbedb-5ed2-437d-2bff-08df3f5a16d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|23010399003|7416014|376014|1800799024|18002099003|22082099003|10067099003|11063799006|261102123227099003|261102130727099003|261028144727099003|261021121427099003|261026121527099003|56012099006|261026140227099003|261022105027099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	2AcB6S2D8aH0fVNfQjYuuOQf9kZlJhNP0nhN3ycxSM8fUzYnEe1hYPDa0MWqcCrNmx4qDQBrHzuPTfHqx9X5pXJX9hB2+P0ukwvk9YJ4EWJ5artF9DvjWpAAkLPJyRVmLLsCpxSWwmFCEiUGBExL9Hamvho3eyMDENBmA811quE2GgUqFJA2TuQFWpEycVFiZWB2hMMJdPN+aXshyIA3ep+aZIG/VMgpaFW83FvpydZ0wu6dGQZkcAGy26HlbM119h5ZyiCWbCX1CqqRMSsSSM4bdxoECRNRqPzq+Bo6BfJCuE/I9nJgYJFLSN3WKH6Vs86Sb9iqMdQtDULsCLlXPRFLw3R49oxcJwa4bmMkHqG5uiAHJygXrsDAVASZG97nemv/YzZJ84zdEzmiYOFqBGLmnrJ2v6pCSKvQoJXGm8KOIBY5g3Dbq0wNzxVi0HHsUYlpaEyPzYUQEGvfLJVOr/Y2MxKILHSdAZ55DOSz4GSuNIgDCMyoktn/uZgh0Dj56OhdG/HdAXEvWAwMP3LDipnVubk1MK7sUOAfOZ3J1UnSDurATahFwDrlQg8tDJ7z2MdYbF5vycAZKPHzaIbGePM+aAowvHyox0QPmv3xp94Kr0RxVDW9kdFvnC1widNmWU5YCzKgihyWqcAYmYQ23LNOH3uduX71kRRYq8DVfBY81WInQdCPfQEfRPC3/J+3SyA9AhMGcUIYpM040cQ1DA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(23010399003)(7416014)(376014)(1800799024)(18002099003)(22082099003)(10067099003)(11063799006)(261102123227099003)(261102130727099003)(261028144727099003)(261021121427099003)(261026121527099003)(56012099006)(261026140227099003)(261022105027099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	yKLQSiMxCLIpoHlVuiKM1QlsLFBu9RAHQ1BlBz2iyyMR8cpWHQPsadOPnVNEO6yv8Ek1vU7uxyQ6xmuTcKtEi5JSYHZGgSl/zxZkvLBPYitQcxOKRJfzXaXs0u8YSA4qwTMZ5zalnh6f8KHWkHfzZJHR8z5e0jsch7/A1K6wHcG3qVJqOUfKPwmS0AuBrhHb5EqIpzkbFstrMgKJZUN2cZ7Ptk4PyXx42f9W5WTq4KrebksjR+9OhuhmkdXQ46xtwINzZpmZwusxo6UJJfxFMncU1MxLhooJAZoQ2BvJjmRU1gFdgZHmu4CA5bSidFKgVq23gtXP3Uhs+KtdYe9a1ovvIxCR7rsV2yu+ixRARRS98tBBU/Ga2pLG2OH1ycvZ2ISVqNWiNXPSTTVvyx1m69mFSiKRBW3Nw5bwIml9CAtkG8lE2Rkgj552UJuL6KWo
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 18:40:27.1632
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e8bfbedb-5ed2-437d-2bff-08df3f5a16d5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	PH2PEPF00048914.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7185

From: Dragos Tatulea <dtatulea@nvidia.com>

Currently there is no way to check whether a dmabuf is bound on a TX
queue. RX side has netif_rxq_has_unreadable_mp() which gives a hint
of it.

To help with that, add a helper to check whether a devmem dmabuf
binding may still be in use on a given netdev, optionally filtered by
the DMA device the dmabuf was mapped against.

A binding can outlive the user's unbind: it can still be referenced by
in-flight TX skbs, whose DMA mappings are only valid for the device the
dmabuf was attached to. Reporting such a binding as gone would let a
driver swap the DMA device out from under those skbs. Bindings stay in
the bindings xarray until they are freed, so walk it and report every
binding of the netdev that is still mapped. Bindings that were already
unmapped are not reported.

This API is necessary for the upcoming support of data direct in mlx5e.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Cc: Bobby Eshleman <bobbyeshleman@gmail.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 include/net/netmem.h | 24 ++++++++++++++++++++++++
 net/core/devmem.c    | 43 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 67 insertions(+)

diff --git a/include/net/netmem.h b/include/net/netmem.h
index fb693bc1702a..35bb6fa0f719 100644
--- a/include/net/netmem.h
+++ b/include/net/netmem.h
@@ -397,16 +397,40 @@ static inline unsigned long netmem_get_dma_addr(netmem_ref netmem)
 	return netmem_to_nmdesc(netmem)->dma_addr;
 }
 
+struct net_device;
+
 #if defined(CONFIG_NET_DEVMEM)
 static inline bool net_is_devmem_iov(const struct net_iov *niov)
 {
 	return niov->type == NET_IOV_DMABUF;
 }
+
+/**
+ * netdev_has_dmabuf_binding - is there a dmabuf binding for a
+ * given @dev and @dma_dev
+ *
+ * @dev: netdev to check bindings
+ * @dma_dev: dma device to check, when NULL it will not be checked
+ *
+ * A binding is reported for as long as it is mapped, which can be long
+ * after the user unbound it: net_iovs of a TX binding can still be queued
+ * in flight, with DMA mappings that are only valid for the device the dmabuf
+ * was attached to.
+ *
+ * Return: true if a binding is found under @dev and possibly @dma_dev
+ */
+bool netdev_has_dmabuf_binding(struct net_device *dev, struct device *dma_dev);
 #else
 static inline bool net_is_devmem_iov(const struct net_iov *niov)
 {
 	return false;
 }
+
+static inline bool netdev_has_dmabuf_binding(struct net_device *dev,
+					     struct device *dma_dev)
+{
+	return false;
+}
 #endif
 
 void net_iov_inc_ref(struct net_iov *niov);
diff --git a/net/core/devmem.c b/net/core/devmem.c
index 5c7d9640e9d1..dd3987bbd9f6 100644
--- a/net/core/devmem.c
+++ b/net/core/devmem.c
@@ -513,6 +513,49 @@ struct net_devmem_dmabuf_binding *net_devmem_lookup_dmabuf(u32 id)
 	return binding;
 }
 
+/* The attachment is cleared once the binding has been unmapped. */
+static bool
+net_devmem_binding_mapped_to(struct net_devmem_dmabuf_binding *binding,
+			     struct device *dma_dev)
+{
+	lockdep_assert_held(&binding->lock);
+
+	return binding->attachment &&
+	       (!dma_dev || binding->attachment->dev == dma_dev);
+}
+
+bool netdev_has_dmabuf_binding(struct net_device *dev, struct device *dma_dev)
+{
+	struct net_devmem_dmabuf_binding *binding;
+	unsigned long xa_idx;
+	bool found = false;
+
+	netdev_assert_locked(dev);
+
+	/* A binding stays in the xarray until it is freed. binding->dev is
+	 * only cleared under the instance lock of that netdev, and the free
+	 * takes it before erasing the binding, so a binding found under @dev
+	 * stays alive while the xarray lock is dropped.
+	 */
+	xa_lock(&net_devmem_dmabuf_bindings);
+	xa_for_each(&net_devmem_dmabuf_bindings, xa_idx, binding) {
+		if (READ_ONCE(binding->dev) != dev)
+			continue;
+
+		xa_unlock(&net_devmem_dmabuf_bindings);
+		mutex_lock(&binding->lock);
+		found = net_devmem_binding_mapped_to(binding, dma_dev);
+		mutex_unlock(&binding->lock);
+		xa_lock(&net_devmem_dmabuf_bindings);
+		if (found)
+			break;
+	}
+	xa_unlock(&net_devmem_dmabuf_bindings);
+
+	return found;
+}
+EXPORT_SYMBOL_GPL(netdev_has_dmabuf_binding);
+
 void net_devmem_net_iov_inc_ref(struct net_iov *niov)
 {
 	net_devmem_dmabuf_binding_get(net_devmem_iov_binding(niov));
-- 
2.44.0

