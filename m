Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=52.101.201.32
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1794336044;
	b=vKtY9CjHAwEroqrDzXWg1LVgu1C4eh9Z35fnEIH+jfiicozSUGForQlnWguRvXxaqpt1
	 kcNkJ9shkO8+rIamIMWeHmpCg+B495rgG712mFVWEkSbsZFvYetpuCLiwLKdbyW4v3Vu6
	 Wi7zfEEg+GXwufHz9A+dRFoq8gZJM1yQ6xgZBQerF7CQR2boYRe5S6iFd8TJg1ulAjJTN
	 Gck0dale3YzsfR08SbBVrtDWcWTZTcejMZAc3G3/rpPNq7UyAivJ1x5CxmE4nmynY/dUv
	 3E+etrC10sjDvrBG7hZInXUqG0kq5UUL2DVH9PDJNvQJ5xpH5dcLtXO3M6MmXQ/xCOw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794336044;
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
	bh=9zQK2CgVWJbQ92kZW5Cx6f1gwrq6mlWEVINrAqC9Vxs=;
	b=PRd7CInb5wBBiuYYwBpM3UfmrqrkiaNO+LF+heBSeEJgxGoL5eQqQTED50ulqKJU7WnK
	 s5iaPF+vE5cVcn1lQ1K4/40k6wso8la7FB+mlmqdjm1nuuG9/WeBMiSs2/h14NAiSkB0b
	 S5trwB6KM2H+5rLrDPw+aBii2CbFR4Z461OkDTdKtdGRqYlGfJidrG08GXJi5aT8Qr4x+
	 2pHKmdkU/uRyMWB98Z2m+Iz/ZxssXKCGHhASAl7VKFzWnZZqhxpquUhvSBu1+jjT3bfik
	 6BhlILMwjZjoVWQileEygZlG6ROXLDxyMu7T8EmgIR4Cyz2OcY4JIqPW04/n3An4K4Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ietm8mzO;
	arc=fail smtp.remote-ip=52.101.201.32
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010032.outbound.protection.outlook.com [52.101.201.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 190BF606A333;
	Tue, 10 Nov 2026 18:40:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 190BF606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ietm8mzO
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SldbEn3MQWbIhlBvgf4f48aVkLqqRu3M5Tq6f23xeNJxUV9AsLEy2xxjgnmcVMm+IaXyCuEMkcvnbbIM3AmiToV84iz2gYmDugIUYzQPO1yYEQS/gjSNz84s0fPLM5+BhnFUAF4EZnA6Omt+4NVal7LZy+1KGDV//XyvA0L5gzKA2ZCtcpUFXXz3s3UJeaL4KqYwptyFEXQMwavdOycv0RlenOYIafso1k1+rkgmnz8FtNVYUqwk7vaFwAb6rEjAusb9TfyuZdLP5sfVjSmbaD9gKrLr7jqK3s9/2RfTvUvelF3+y+FRYqnKOHQBcudbK111q92Iy2LqH+Z34/Y9iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9zQK2CgVWJbQ92kZW5Cx6f1gwrq6mlWEVINrAqC9Vxs=;
 b=O3ElVtLGoKPV6tUNOJqXCtJYwB8ZzuQ9I0WchzHFiLlWyJhGJY1r967wqhmnuuiJlcZtcIC2yeeL7l4wP6gd9Gh3BUwAZmQBj+6+DW8SO5VgYrimOk4+AsbGjXQCOmC5Y3Evc0R+2POyptsetUlhxJt7ZZmtFlzfFLDDMQf7L08kRUsGBh9y4PZoktzL2oavPkDj/zaVt6N3pMCgkJfLqnBzzkuRG+bkBMcH68CJKdH3O7aryp6Z77ppPTrrkMIwxdQ/omy5YM7BH3wiIXeGOuNKvuK0bHL5FutMpgH3GYaWxnRCCflsoKmB/4zNwLtp4kjar6b5hstgKJdBiXU8hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9zQK2CgVWJbQ92kZW5Cx6f1gwrq6mlWEVINrAqC9Vxs=;
 b=ietm8mzOLMP+P0BeczDBcjA337v3Amnk/TAY18qMnSIrjIdPHA9muwrJYsU8+zeCTKsrRqZuLqX5J8Xhv4gxrxmUEyLRdYPda11qC46MuVRbF0YjHLnIp3cC5sp0pRl120busytO3AhbV4QsDDio0ckbGu44SkHbiIvsbroj5+H3hRqGMon8YLZBd4c0vPW9w9W31t5/AVtdSqNZAsFgkcpoQ9yhbrmKdduEir5QiH4Ol7i3fV+7tEWaY1o8GdQJwdqTp7c4vXIJuTEgSgSDW6zY7qvQTMPgI2sLFkPN9kKVVEEIQT/noQavHV9nLwbGPPgisus/RpxR31TMihu1vQ==
Received: from CY5PR14CA0013.namprd14.prod.outlook.com (2603:10b6:930:2::23)
 by MW3PR12MB4412.namprd12.prod.outlook.com (2603:10b6:303:58::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Tue, 10 Nov
 2026 18:40:37 +0000
Received: from PH2PEPF00048918.namprd05.prod.outlook.com
 (2603:10b6:930:2:cafe::1) by CY5PR14CA0013.outlook.office365.com
 (2603:10b6:930:2::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Tue, 10
 Nov 2026 18:40:37 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 PH2PEPF00048918.mail.protection.outlook.com (10.167.243.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 10 Nov 2026 18:40:37 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 10:40:14 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 10:40:13 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 10
 Nov 2026 10:40:06 -0800
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
Subject: [PATCH net-next V2 11/13] net: add netdev_unbind_dma_dev() helper
Date: Tue, 10 Nov 2026 20:38:24 +0200
Message-ID: <20261110183826.2927274-12-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: PH2PEPF00048918:EE_|MW3PR12MB4412:EE_
X-MS-Office365-Filtering-Correlation-Id: bb415faf-05e0-4746-509c-08df3f5a1cb6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|82310400026|36860700016|23010399003|261102130727099003|261102123227099003|11063799006|261021121427099003|261026140227099003|261022105027099003|261009223027099003|56012099006|261026121527099003|261022075727099003|261028144727099003|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	NXX3ZzsitPZYv44JtfzZHTNpyo7dvR9bAwZ+rMy2j4zg8DqPINs88R4/AH2zYKBD+NQS3QP8ZQ3zUhWhUz+xxu88vUjkRQ8VGHAGCgYHcmh3miARF51m3yLFtHTvwIdD08bvom1KcSyoKikYfcR3zk+RT4CP5712NZfpz6wWhvorA6d6I8WL6hxMfldyoigq56xrwwwMFbR8EPfTv1rUa1W9FyBXzwiCLeNkQYmXvj2KUhWgdO48cKNAruQ8arooJI9/wR5q1/BPxed+WmqejpegXh2zuxSUy/qDF6gSmIqcidqA/Qw31E3Lk9rimuToDLUeHo259y1EA+BB7/bXPoP3Z0h+nD2m4GLRV4Yc/xhNLqoLndAn+mmsQ45hV6lTwL3dEWYWpzB/iGvQvssTUw97oCs5AKczDEfrjf4bQKnEzh9LLk4CxmqpN0Xtg2u+4ZL0J7+orCD60QqKXQCrqbxZ0gH1D7RQD4rPUWrY/3LI5swPRSfW48k7GfWYAkMI3DzQ9e6gVAuYSuEmO412L8i2Co3OwNtSI0tp9x3DVCizbBl6GsaQwRVF7cu6zlu23eLwbKFe/BYR6nm347E38A3+9Yb9XFlVlIP9u/6p+8HuIzYx/u7quPi1UWFe1TTA61wqUxJ9Dan331gw+QtTkeWBJ5nKcfCBSZj1v4D9QxuJrkagygogp5CNAUfbOkJwsL/7OWWjfTna579S1CJPzA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(82310400026)(36860700016)(23010399003)(261102130727099003)(261102123227099003)(11063799006)(261021121427099003)(261026140227099003)(261022105027099003)(261009223027099003)(56012099006)(261026121527099003)(261022075727099003)(261028144727099003)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	vQ/M7pR+MlMCUueCt0VCJY/mCMkkWJotDYllsjhduSuem6mW/63V6Ydf6gWjhUTwyn2rFkTjbdof1mwOaqOBmrLrTveXONahoPqOrcfNgpajl/oscX2JPooZCN1iCeOAUS3CfprihPc6Lsz84Ui3T8yIZYJIRwxpseBDW0mWJKPDpiDjn/b/l6Qe2sMKI+pU+CBpJUYQEtZfIi00AqqpPN5SoGDsjp5kK/Fg2ILbxDl9vwPBZH4FzJgmerx/uiEqtFA77f5EUku5cYwjCb/k5bcTGlj3Qo73SpflE9+sFcANDmgeIjWI02/plBxqomXXPqC3+05MzIy3dzJS+zzzFzgd15gAYS5yhT6ONW6r23pyql01GxoeDp4peqLA04vPDV6beF6YaMblbasRju/ZYW/XN5hW7nMBBG47QVrTmzEWpna9RRgwwIEhbtJtZYR/
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 18:40:37.0779
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bb415faf-05e0-4746-509c-08df3f5a1cb6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	PH2PEPF00048918.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4412

From: Dragos Tatulea <dtatulea@nvidia.com>

Currently the netdev code that binds dmabufs to a DMA device assumes
that the device is the netdev's own PCI device, and the unbind cleanup
is done under that assumption.

With the introduction of data direct in mlx5, this assumption no longer
holds: the DMA device is not the netdev's PCI device. When the data
direct DMA device is unbound, there is no way to clean up the bindings.

Add a helper that unbinds the dmabufs of a closed or detached netdev
from a DMA device, independent of the memory provider in use:

- RX: uninstall the memory provider of every RX queue whose DMA device
  is the departing one or is gone. The uninstall callback unmaps the
  buffers, for devmem and io_uring zcrx alike. The queues get regular
  page pools on the next open.

- devmem TX: detach and unmap the TX bindings of the netdev mapped
  against the device, as netdev unregister does. New sends fail and
  in-flight skbs are dropped at xmit.

The netdev must be closed or detached so that the hardware no longer
accesses the mappings and the qdiscs hold no validated skbs. A detached
netdev also works because the driver has already torn down the queues
and new bindings can't be added.

For now leased queues owned by virtual netdevs are not supported by this
API. mlx5 refuses zero-copy while RX queues are leased in data direct
mode.

The helper only unmaps. The providers and bindings stay allocated until
their users release them.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 include/net/netdev_queues.h |  1 +
 net/core/devmem.c           | 42 ++++++++++++++++++++++++++++++
 net/core/devmem.h           |  6 +++++
 net/core/netdev_queues.c    | 51 +++++++++++++++++++++++++++++++++++++
 4 files changed, 100 insertions(+)

diff --git a/include/net/netdev_queues.h b/include/net/netdev_queues.h
index c5335e935b7d..f3f174f342b9 100644
--- a/include/net/netdev_queues.h
+++ b/include/net/netdev_queues.h
@@ -235,6 +235,7 @@ void netdev_queue_config(struct net_device *dev, int rxq,
 			 struct netdev_queue_config *qcfg);
 
 bool netif_rxq_has_unreadable_mp(struct net_device *dev, unsigned int rxq_idx);
+int netdev_unbind_dma_dev(struct net_device *dev, struct device *dma_dev);
 
 /**
  * DOC: Lockless queue stopping / waking helpers.
diff --git a/net/core/devmem.c b/net/core/devmem.c
index dd3987bbd9f6..bc8ae12b2318 100644
--- a/net/core/devmem.c
+++ b/net/core/devmem.c
@@ -556,6 +556,48 @@ bool netdev_has_dmabuf_binding(struct net_device *dev, struct device *dma_dev)
 }
 EXPORT_SYMBOL_GPL(netdev_has_dmabuf_binding);
 
+/* Unmap the bindings of a closed @dev that use @dma_dev, the way netdev
+ * unregister does. Senders that raced the detach drop their skbs at xmit.
+ */
+void net_devmem_unbind_dma_dev(struct net_device *dev, struct device *dma_dev)
+{
+	struct net_devmem_dmabuf_binding *binding;
+	unsigned long xa_idx;
+	bool match, live;
+
+	netdev_assert_locked(dev);
+
+	xa_lock(&net_devmem_dmabuf_bindings);
+	xa_for_each(&net_devmem_dmabuf_bindings, xa_idx, binding) {
+		if (READ_ONCE(binding->dev) != dev)
+			continue;
+
+		/* Hide the binding from TX lookups while it is checked. */
+		live = xa_get_mark(&net_devmem_dmabuf_bindings, xa_idx,
+				   NET_DEVMEM_BINDING_LIVE);
+		if (live)
+			__xa_clear_mark(&net_devmem_dmabuf_bindings, xa_idx,
+					NET_DEVMEM_BINDING_LIVE);
+		xa_unlock(&net_devmem_dmabuf_bindings);
+
+		mutex_lock(&binding->lock);
+		match = net_devmem_binding_mapped_to(binding, dma_dev);
+		mutex_unlock(&binding->lock);
+		if (match)
+			net_devmem_dmabuf_binding_unmap(binding);
+
+		xa_lock(&net_devmem_dmabuf_bindings);
+		if (match) {
+			WRITE_ONCE(binding->vdev, NULL);
+			WRITE_ONCE(binding->dev, NULL);
+		} else if (live) {
+			__xa_set_mark(&net_devmem_dmabuf_bindings, xa_idx,
+				      NET_DEVMEM_BINDING_LIVE);
+		}
+	}
+	xa_unlock(&net_devmem_dmabuf_bindings);
+}
+
 void net_devmem_net_iov_inc_ref(struct net_iov *niov)
 {
 	net_devmem_dmabuf_binding_get(net_devmem_iov_binding(niov));
diff --git a/net/core/devmem.h b/net/core/devmem.h
index c4f476947dfa..06a86efc807d 100644
--- a/net/core/devmem.h
+++ b/net/core/devmem.h
@@ -106,6 +106,7 @@ void net_devmem_unlock_dev(struct net_device *dev,
 			   netdevice_tracker *dev_tracker);
 void net_devmem_unbind_dmabuf(struct net_devmem_dmabuf_binding *binding);
 void net_devmem_dev_unregister(struct net_device *dev);
+void net_devmem_unbind_dma_dev(struct net_device *dev, struct device *dma_dev);
 int net_devmem_bind_dmabuf_to_queue(struct net_device *dev, u32 rxq_idx,
 				    struct net_devmem_dmabuf_binding *binding,
 				    struct netlink_ext_ack *extack);
@@ -209,6 +210,11 @@ static inline void net_devmem_dev_unregister(struct net_device *dev)
 {
 }
 
+static inline void net_devmem_unbind_dma_dev(struct net_device *dev,
+					     struct device *dma_dev)
+{
+}
+
 static inline int
 net_devmem_bind_dmabuf_to_queue(struct net_device *dev, u32 rxq_idx,
 				struct net_devmem_dmabuf_binding *binding,
diff --git a/net/core/netdev_queues.c b/net/core/netdev_queues.c
index 27cb6397bdd4..71cc7bfc087d 100644
--- a/net/core/netdev_queues.c
+++ b/net/core/netdev_queues.c
@@ -1,10 +1,12 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 
+#include <net/netdev_lock.h>
 #include <net/netdev_queues.h>
 #include <net/netdev_rx_queue.h>
 #include <net/xdp_sock_drv.h>
 
 #include "dev.h"
+#include "devmem.h"
 
 static struct device *
 __netdev_queue_get_dma_dev(struct net_device *dev, unsigned int idx)
@@ -58,6 +60,55 @@ struct device *netdev_queue_get_dma_dev(struct net_device *dev,
 	return dma_dev;
 }
 
+/**
+ * netdev_unbind_dma_dev() - drop the memory providers of a departing DMA device
+ * @dev:	net_device, closed or detached by the caller
+ * @dma_dev:	DMA device the driver is about to lose
+ *
+ * Uninstalls the memory provider of every RX queue of @dev that maps
+ * against @dma_dev. Unmaps the devmem bindings of @dev that use @dma_dev.
+ * The bindings stay allocated until their users release them.
+ *
+ * The provider of a leased RX queue is owned by the virtual netdev and
+ * can't be torn down here. Drivers must not report a DMA device they can
+ * lose for leased queues; such queues are skipped with a warning.
+ *
+ * Return: 0 on success, -EBUSY if @dev is running and present.
+ */
+int netdev_unbind_dma_dev(struct net_device *dev, struct device *dma_dev)
+{
+	unsigned int i;
+
+	netdev_assert_locked(dev);
+
+	if (netif_running(dev) && netif_device_present(dev))
+		return -EBUSY;
+
+	for (i = 0; i < dev->real_num_rx_queues; i++) {
+		struct netdev_rx_queue *rxq = __netif_get_rx_queue(dev, i);
+		struct pp_memory_provider_params p = rxq->mp_params;
+		struct device *queue_dev;
+
+		if (!p.mp_ops)
+			continue;
+
+		queue_dev = __netdev_queue_get_dma_dev(dev, i);
+		if (queue_dev && queue_dev != dma_dev)
+			continue;
+
+		if (WARN_ON_ONCE(rxq->lease))
+			continue;
+
+		memset(&rxq->mp_params, 0, sizeof(rxq->mp_params));
+		__netif_mp_uninstall_rxq(rxq, &p);
+	}
+
+	net_devmem_unbind_dma_dev(dev, dma_dev);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(netdev_unbind_dma_dev);
+
 bool netdev_can_create_queue(const struct net_device *dev,
 			     struct netlink_ext_ack *extack)
 {
-- 
2.44.0

