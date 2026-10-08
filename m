Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010045.outbound.protection.outlook.com [52.101.61.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C9F54F5E0;
	Thu,  8 Oct 2026 13:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791466254; cv=fail; b=VlEUunM6ZR+wuRoTCI19hqrSLEHufRqknv7E9mqbDDzPRjPKUc8OJYondiYJv96eqUKLXfe7fX/nRz0G6az5yeXi8C6PZkKCbuJFla/Qqr6jy5bRiGF927BtTak3XpLb5oHJrMCbMuQqumG0k3wvxcPhuItfzBBv3/F7uDql3fo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791466254; c=relaxed/simple;
	bh=ErseU2Hs9f4zFRiJs0Lz1hU/ZYWnjBZMqHuunNE1YpQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qyHcV1IYmrdT5wR+YLDhU8vnuFXMr78Bd79IUUGT1OCWOX/DCYZP4F8PvqvpcLaupgzqbV5PfjJWYbBVmQ17+7QeCFam6ot/5rkuXramX2X2PJAEpyXSz2VJWCX4FI0eeWhLAb71cGalxj1jH27eKWZVqpfQyiUMWzkSLG1vsG8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Mi9XxZ2c; arc=fail smtp.client-ip=52.101.61.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Mi9XxZ2c"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oB6T+94GkmYRs8oVvF+ESWPqXedHUeV0MX5RV9g69shrlmQpp5fsIqcgQk++btpQCbV/TdqUhZknNQT6nyOI10T16a0bzNlblv3esRW5WQCLnUfUSA7JdKiqXZrhNNLtwGwDdChka7UThrteTn2zPMpv53ik62xDcrOhuO7OXzLZJMBdWExbExF52sczn/jTuME3fs4WY1RXM1gHkenIuAkqg8aFhtKZgJkF04AbOGpUy2tQC1L7TPY2izaSy/eeTTbVddPYo4YDpi/u53wIeopk4nINegvA7PvtUYiuDSlEaoKG0uy6FNhnskReCYNwiT0Nik2pSMIpKoYKw9bFBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oi/Kp6hjYuJeTB0O3SPuc62eW3ZNWRcWKND5hNdJ33k=;
 b=keVFtH46fkPTEzIWrnL4nbJFk+vQBhiF+EduURLSijf0uApoAikY/H5qQB8OLLYtzhMJWNakiLAT3W4cvLca2Cp1wFn3jiyqiDHEB3oFhAQrQwwulc4NuTQwZtvZvVg4Os+1fDsaFWlSJ2dkzCCbQRJKS69e8X96StnfhywowRZ5oiya11Bi9RQFk5wPCSptOGK20R3MH5830g4Pdgh4NVD2o0gApKRLaGU7rzRxwTJsn7Zy6bZrRcjnsSXA6P3EV+NXAas+F5Aw4am+ndQ8HRntIeBG5cxIBJx8Zotb0o3605wgu3AXeyEarQCFPB7g0lp/pZheVG/6zlu5ppn8Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oi/Kp6hjYuJeTB0O3SPuc62eW3ZNWRcWKND5hNdJ33k=;
 b=Mi9XxZ2cuvaBxlL74hwWl08V9gUCqisVabe4pMKWoyZqiRnbwWqexaANKICiYWswW7peEgmFQnXywd6q5OUv3Imo/IAABCZesGjEVtdbsraMW5ir/MM5K/xpAx5c8GR3FRfHk011xZaWRQ43jNTvNCjOtzZTSjz19bVs3u3GqpNj+I0dORaIX3g26X72FxRfSikvl4p+Is4+uccYdZ/dl4cBehqVm/oyRJHnRVxor1PHvBxkpNbvfwbloJXi7qKvW48b5OAQPkg8M7ey/9ktyGb8s2+4tDnUDHA1O54aATwxmKMXD/SSvlq+zIKwFwQ+5FWemiB2T/NoX/WlvQuKIQ==
Received: from PH1PEPF0001330A.namprd07.prod.outlook.com (2603:10b6:518:1::19)
 by SJ1PR12MB6099.namprd12.prod.outlook.com (2603:10b6:a03:45e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.19; Thu, 8 Oct
 2026 13:29:54 +0000
Received: from SJ5PEPF000001D1.namprd05.prod.outlook.com
 (2a01:111:f403:c902::f) by PH1PEPF0001330A.outlook.office365.com
 (2603:1036:903:47::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.9 via Frontend Transport; Thu, 8
 Oct 2026 13:29:53 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ5PEPF000001D1.mail.protection.outlook.com (10.167.242.53) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.496.14 via Frontend Transport; Thu, 8 Oct 2026 13:29:53 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 8 Oct
 2026 06:29:33 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 8 Oct
 2026 06:29:33 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Thu, 8 Oct
 2026 06:29:26 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Bobby Eshleman <bobbyeshleman@meta.com>, Byungchul Park
	<byungchul@sk.com>, Carolina Jubran <cjubran@nvidia.com>, Cosmin Ratiu
	<cratiu@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman
	<gal@nvidia.com>, Jacob Keller <Jacob.e.keller@intel.com>, Kees Cook
	<kees@kernel.org>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Matt Fleming <mfleming@cloudflare.com>, Mina Almasry
	<almasrymina@google.com>, Nikolay Aleksandrov <razor@blackwall.org>, "Saeed
 Mahameed" <saeedm@nvidia.com>, Shivaji Kant <shivajikant@google.com>, "Simon
 Horman" <horms@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>, "Stanislav
 Fomichev" <sdf.kernel@gmail.com>, Tariq Toukan <tariqt@nvidia.com>, William
 Tu <witu@nvidia.com>, Yue Haibing <yuehaibing@huawei.com>, Bobby Eshleman
	<bobbyeshleman@gmail.com>
Subject: [PATCH net-next 09/10] net: devmem: add netdev_has_dmabuf_binding() helper
Date: Thu, 8 Oct 2026 16:28:14 +0300
Message-ID: <20261008132815.654147-10-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261008132815.654147-1-tariqt@nvidia.com>
References: <20261008132815.654147-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D1:EE_|SJ1PR12MB6099:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ddd5f25-39b4-4b14-dc3b-08df25403cdf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|7416014|36860700016|23010399003|10067099003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	IlxiH1rxDM/bNKaO0XqxqSxFDWQZXPT5zRyaa4tb5/8lCATtpfy236vUVMBsOP6Zzh7Fe6Y0+uFoNtdoPCQKYE4L2jRycP+Bxx0TRBIx/SCkw4AD7iV1lMmpM5C+3TL/d4BsI8wLIhy9n0RKX7wZ3CtMMfY2JyT0pvPfv2UQ/BItU+Ltrn/cA7b0CF6KiF6jOhHYjza9BGmgynG2o8PHluvwTj1Lzr0O3FWIUlLmtKuWYutLBrhzSwSxVsQH7uIyrn41R4DQfBoxW6AEgDCXXabA6/I8FjoGwVyLf8olIxoFFXgPXFTK87EdzZQ9pH0/56YhuVlNX4/vX3Xw4/zvkcFnqgBFzaxHeLpdvvyXYxsgvl7rSWYmRmuP2dGkiMGwIx608SjLFstIN03JRN6Pi9yZfCFY12SJPsY04vcaz7kEKyUI+rDNyN8I4UhJ71ydwe+gY0XFaeHHRwNR0pUTAsn2V0HW4K2WcLjt1SM7GTCve4iznqIIS1rIrIb/E04qCYId/oNq1stgfU+XjCD/DlhB98J1uCrHyTTaWglfasa/qJr2a5nqPcBVwQDX1HnRp17Ow3a9Y4gHKrq5+bc9alaSDEOXZQUY1WQD3lgH09CBuVki9D2gW+l3GsW2MumZni98dk2VWZ3erexMjSq444Tpa6Bk5FIDwY1YWMVrZp7yU/3ac/RuOJYteN4fQjbgiq10PXOF9pGpK95nHbnCew==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(7416014)(36860700016)(23010399003)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	UFHVEUrhk72Y7wBOUlls3Fdcwe9bgTxJnlx/trJkADE3mazqcikL74IOgxzPWQ8CTkcFFO1ExkeOPPfQV7/YwdyG9ZqzhJug59Lw7CUOuVPuA59IQsAZqiKPRE6O8gzddEHwZ1BFrJmKjWI9cgktsQnblF9OQiln9DjcxGE26bgAhrm9ukgNFzl/7s9OxIXfXgdE7CSjtwbi7eJMZoLxHD6dTnzLV6Xhw1mkZfX8KJ12LjTjByJ+JNkenSHc2pZZiTwAFcDy0paU6a5aC8Rtt428QbtKOmHe7QxE0y2HyOJj18VPTuZlPZKS0VjfCYuKRVd5E4qEH7n6LWU6cdZGQ9heZnjBsDjv5ffNEb14MQNJqrjbAQcrD8/eyfmgYNdqpHxZg0EFMrOT3b5yMS51VY2bUxYQBrmjHTxBaNkEwCGdIonTNcuevyDfsBhQjKb6
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2026 13:29:53.9037
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ddd5f25-39b4-4b14-dc3b-08df25403cdf
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6099

From: Dragos Tatulea <dtatulea@nvidia.com>

Currently there is no way to check whether a dmabuf is bound on a TX
queue. RX side has netif_rxq_has_unreadable_mp() which gives a hint
of it.

To help with that, add a helper to check whether a devmem dmabuf
binding may still be in use on a given netdev, optionally filtered by
the DMA device the dmabuf was mapped against.

A binding can outlive its xarray slot: it can still be referenced by
in-flight TX skbs, whose DMA mappings are only valid for the device the
dmabuf was attached to. Reporting such a binding as gone would let a
driver swap the DMA device out from under those skbs. For this reason,
track bindings for their whole lifetime on a new list.

This API is necessary for the upcoming support of data direct in mlx5e.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Cc: Bobby Eshleman <bobbyeshleman@gmail.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 include/net/netmem.h | 23 +++++++++++++++++++++++
 net/core/devmem.c    | 30 ++++++++++++++++++++++++++++++
 net/core/devmem.h    |  2 ++
 3 files changed, 55 insertions(+)

diff --git a/include/net/netmem.h b/include/net/netmem.h
index 0cc8572f62ca..8bcf44f43d17 100644
--- a/include/net/netmem.h
+++ b/include/net/netmem.h
@@ -387,16 +387,39 @@ static inline unsigned long netmem_get_dma_addr(netmem_ref netmem)
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
+ * A binding is reported until its last reference is dropped, which can be
+ * long after the user unbound it: net_iovs of a TX binding can still be
+ * queued in flight, with DMA mappings that are only valid for @dma_dev.
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
 
 void __get_netmem(netmem_ref netmem);
diff --git a/net/core/devmem.c b/net/core/devmem.c
index 07c62e2e3088..173d66d1cb6e 100644
--- a/net/core/devmem.c
+++ b/net/core/devmem.c
@@ -25,6 +25,9 @@
 
 static DEFINE_XARRAY_FLAGS(net_devmem_dmabuf_bindings, XA_FLAGS_ALLOC1);
 
+static DEFINE_SPINLOCK(net_devmem_live_bindings_lock);
+static LIST_HEAD(net_devmem_live_bindings);
+
 static const struct memory_provider_ops dmabuf_devmem_ops;
 
 static struct net_iov *net_iov_free_pop(struct net_iov_area *area,
@@ -63,6 +66,10 @@ void __net_devmem_dmabuf_binding_free(struct work_struct *wq)
 {
 	struct net_devmem_dmabuf_binding *binding = container_of(wq, typeof(*binding), unbind_w);
 
+	spin_lock(&net_devmem_live_bindings_lock);
+	list_del(&binding->live_list);
+	spin_unlock(&net_devmem_live_bindings_lock);
+
 	if (binding->freelist)
 		WARN(binding->free_count != binding->area.num_niovs,
 		     "destroying dmabuf binding with outstanding net_iovs: total=%zu, free=%u",
@@ -321,6 +328,10 @@ net_devmem_bind_dmabuf(struct net_device *dev, void *vdev,
 
 	list_add(&binding->list, &priv->bindings);
 
+	spin_lock(&net_devmem_live_bindings_lock);
+	list_add(&binding->live_list, &net_devmem_live_bindings);
+	spin_unlock(&net_devmem_live_bindings_lock);
+
 	return binding;
 
 err_free_niovs:
@@ -357,6 +368,25 @@ struct net_devmem_dmabuf_binding *net_devmem_lookup_dmabuf(u32 id)
 	return binding;
 }
 
+bool netdev_has_dmabuf_binding(struct net_device *dev, struct device *dma_dev)
+{
+	struct net_devmem_dmabuf_binding *binding;
+	bool found = false;
+
+	spin_lock(&net_devmem_live_bindings_lock);
+	list_for_each_entry(binding, &net_devmem_live_bindings, live_list) {
+		if (dev == READ_ONCE(binding->dev) &&
+		    (!dma_dev || binding->attachment->dev == dma_dev)) {
+			found = true;
+			break;
+		}
+	}
+	spin_unlock(&net_devmem_live_bindings_lock);
+
+	return found;
+}
+EXPORT_SYMBOL_GPL(netdev_has_dmabuf_binding);
+
 void net_devmem_get_net_iov(struct net_iov *niov)
 {
 	net_devmem_dmabuf_binding_get(net_devmem_iov_binding(niov));
diff --git a/net/core/devmem.h b/net/core/devmem.h
index 1cec10f0257c..eadf6df38687 100644
--- a/net/core/devmem.h
+++ b/net/core/devmem.h
@@ -54,6 +54,8 @@ struct net_devmem_dmabuf_binding {
 	 */
 	struct list_head list;
 
+	struct list_head live_list;
+
 	/* rxq's this binding is active on. */
 	struct xarray bound_rxqs;
 
-- 
2.44.0

