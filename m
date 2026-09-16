Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011005.outbound.protection.outlook.com [52.101.62.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7E15013C2;
	Wed, 16 Sep 2026 23:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789602638; cv=fail; b=Ce/sOxYfSzuBxWZutIZ6kAPo7P+CCea6CtC2pEIomf4BdizGUqV1nlRDNx9R4jAhLvOWDVLbHcxJPzec+RDcPRmxqJ5n5Fu2Wi4BSl4X7d/Gf/RgMA+ouYQ7h0En26S5VlM1VBrbDJlAdu8a1L0ufPgkGBKXhn0fdphJ4rIycOc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789602638; c=relaxed/simple;
	bh=VfsO4hcdLx7ZK2t4VSlVcUHQVuzYaoZv92tXND63qzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YijMX8MzfzmdTDFWwIlfY/Lpah59pBRmJWiReVGrMtQTLgrDdq3bK02JR44FZSn8NkHF9ff11jWLtZ1SfQmVrfMal2u6NJrVUHqxHIUxAf/Qn1PCSk3IgkBbeaZx/8gOeKEDbPkoR/D9csfpVKr4IkbTPsoyJX8taEUF0lmFj50=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CV66vWAD; arc=fail smtp.client-ip=52.101.62.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CV66vWAD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q6P9nBiBJJqFLNGHW4nTVnkSrsqVh1DBgqOn8iO96jjEMSE7l7tq8KAxrRwbApk+ZNsnIBDy8h9IdVkiM/G/KlSUhcgDuPfis7842NBmkwA08dSZZ0xB1ivGyKv/LK9WDQMMRslAGLTvr+T46h3yHkX5ICHkYscC0chrYD6WrnzU1O4OZnc/eHTr2y127pDj4XBEt1PLSCLIJDp4N7WmiVrOJb3C63WDrF14zoVcvjK2nfB5ebx9a/TsGFLbYmab6P3pVMCpsQqIZolfeKGErY9Se0Hy7QIzsMzqz++50Ri946Ogzj2axFx27e3Gcnzp6+SHCDNlWavY0YB7BhI9Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0I4ILH2uM4pfxmoBtm2U0QuqZwP1ujxiG/2/wu+rSws=;
 b=eCW46zvIsQ2lzBIUVHKqrpGYhJi26hFKQTcMhDUESiEqbcuxnhyPZYS4nKOeerLM8EmqLGlFXR4VjoP9BZoZkFn5AHjGSa5WI0RlcpwQTC5d3t/V4BY59YmpTLJfWHQzj387bOLKJpqJiFssXuutFlrYTwugz3dqePxosMAhlXHhs2vAk3fwkAEIOAhPh4wqNEsY0F8OfkN6rUmwK5+RlhPxYAVksxyYA08FXKwTIbJ4h8XrM1zpG+1M+nqPzkGzdS67LEFwJObSwXGNQw6EqaMIVQVwAegchy7PfvqOtFC3zcL1tCrs6UiQfhVchKn5yrgOeI+qv5dVbgQsRFpy3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0I4ILH2uM4pfxmoBtm2U0QuqZwP1ujxiG/2/wu+rSws=;
 b=CV66vWADp2esWTFeUOnfztpdMwS+8GxMy30iuF61zLxt7SUnsC5KXP4mwYWC6KoImNP/VxqGY9HC/bDzic5UpZDnMGvJLvb0DrMZ/Zo4mwj0Op7461RyRl9TlNhOWWz0hSqpZBotv7KemmDBTHO/XHIN0O8PyZqI+v439H/MT/B4M5la7InGHPufDvaDH79FLHpHQRr2zMFwhzGhDjRJ6NuTRKhWA6npEWh1mexnpxUp9cN6pXSBUoxnVE4FjHEDX6yGOSpQUIwWK6/LLk1rtEwweVGow+3jEsFb3NNR5ec1yszbVyPKutC1ouUC1am3cwofRLk1cJasIegI2S3Ejw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by IA4PR12MB9787.namprd12.prod.outlook.com
 (2603:10b6:208:54d::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Wed, 16 Sep
 2026 23:50:00 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0428.011; Wed, 16 Sep 2026
 23:50:00 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex@shazbot.org>,
	David Matlack <dmatlack@google.com>,
	kvm@vger.kernel.org,
	Leon Romanovsky <leon@kernel.org>,
	linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	Mark Bloch <mbloch@nvidia.com>,
	netdev@vger.kernel.org,
	Saeed Mahameed <saeedm@nvidia.com>,
	Shuah Khan <shuah@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>
Cc: patches@lists.linux.dev
Subject: [PATCH v6 04/10] net/mlx5: Add ONCE and MMIO accessor variants to mlx5_ifc_macros.h
Date: Wed, 16 Sep 2026 20:49:52 -0300
Message-ID: <4-v6-8af36cf7b73f+e2-mlx5st_jgg@nvidia.com>
In-Reply-To: <0-v6-8af36cf7b73f+e2-mlx5st_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN0PR04CA0006.namprd04.prod.outlook.com
 (2603:10b6:208:52d::23) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|IA4PR12MB9787:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e7c0581-63aa-45e9-f64f-08df144d3829
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|921020|10067099003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	e/CEjykKRohHzzmZssYle+ugeLFueu6+mhTmZnkzWaiGyEmqvwYCuZnQ6b4iig7TrUibnTLkPnYJF1VWLjnhzQqi0JC0J2ImhytRvWJ8qKKdmeCoR98knxmsnhlmmPGjmu6gu1VNt+UolZo7Y8cXvAJJ/839SMQ0odE8aEGNh3OR0VCDO3iTD7/TaRgh262JZh8kXY+f2E5rqR7FnDQG/xe4Mq1KIpT2YZDX11VdaEt+9aztoejOINfN0f5BS/xn3mfIfY5VVLeLlE9WGs4ck7/CuBGTgD3X07YuxWn0lQdaCb/OSzI0wgGMx8LO/PqsAUPNhDJcCOKAaP4pAH+U7owhN1wbYMGzOH3olscu3oEpE84jkuQIwbhAA04ir5y+mT0DQC/mtMPBlzdF7K33Bx8kNvT05vXA0FHKLitFFa9oQwqd2ZuW/qHIRIOnVpKNm6OdlOau7gQH4ICng/OWd4RfA4hhQWj3NIInzTCU5Ueoy3Voog+n/cF6gzBnB9qqNRI0BWyqtGqMSYCUuQwG68G1AGHoZlsz6vkFMbUR/BnXISLz+agWb0KIriHvKTA/AzPfuxLSBM/sCP86hyReigkI4Z7y645oLrCetP1sfgGGtnUT2k/waIqrhv3H/OOistdl0hEj5LQf+zB/KIRDQ97rb+Y/GfWZF+9WfRw1rVpefanHmMqM/54eL97+kKNbDVE7nBXdtiuNPELfdHREHw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(921020)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CYDaalIAMOStcfaF6x1paKg2Wjx4vqzE7AMWPT0krV0vyK8GfPFyaRi5bkWm?=
 =?us-ascii?Q?ff0Ewyrg4+GUu5XWAf2Fe0yIplIE1GdlIjZUa7aQepx9/PIedj7RjCU+6gpD?=
 =?us-ascii?Q?ZYm8TZWyamggy40a4DQRaxCTpnpG52U1m342/H6w4RW3a3e+DVx/93+wODTn?=
 =?us-ascii?Q?AtzjDZ/RS6ywv0XIuF+jjxiHkxeTOtHgtxFZs4OqUNpfw+/QHQ5CSXvvrMh+?=
 =?us-ascii?Q?UX+7Fo8VxyveiLSwfr6iLG1qDAbIX13QoYcwBBpEzK/a86bXpS6lkAn1Q87z?=
 =?us-ascii?Q?hD0jeqloAy7DDwxJHs+tgTzHheyGrmgApoQr/cD3kO+HemlIfb9NbXHJWxqk?=
 =?us-ascii?Q?3Ipc0CGUTswIuXQ2/2x6emRTCH/nkx3jU1cZtI1xVy/i5BFY0mSp1MEMa40j?=
 =?us-ascii?Q?UXmFVVK+gqcXxOl8BZ2vKEOa9PfbUULyWJCjwDV2j99RJoCrQYm7r5Nhp8vr?=
 =?us-ascii?Q?up/xHrBcXuzJoZmo62XpI74P/9EGIuWasWIS8DiawvcLHiYK1qS6UMVCHMIZ?=
 =?us-ascii?Q?F4sfDwCFOZWdFZiekMN7WrN1PpoChFOLXNYT0La/sXI1VK/RRrDGllHirFUD?=
 =?us-ascii?Q?+JdncWNR6Sp8hhRyRmytwj3FmZFE1upXQUPvz8MtQ9lZZUYsphaEeC8t+4Fv?=
 =?us-ascii?Q?04XLqYrNd6l7H7A5JnF3s7mSBIp/wMmXDmxRC/2dZjHmep+5k8sh3h7akBym?=
 =?us-ascii?Q?QYGiaAhBpl3yvHS5A1A6G/+Vm4TvJUaPtLSBzA6bjr79BvsWTdZz1MHCIYdX?=
 =?us-ascii?Q?RE4Q867jYA0E1nXG6eZ6zP6v0jLotQGFThf/gV0cNFoN8RvuYmMfK6MPhYTg?=
 =?us-ascii?Q?kUaju3Ss8vtsYZGSMiPm8O691XHkVRaOZ+uQkcsvioXmvAtmN/kX4j9jjsP8?=
 =?us-ascii?Q?lkTYZeoQL0ZMH9qhQ4d8Dc637wP60Di1imam8a59h4q7zPlAr3Oij1lc1EbM?=
 =?us-ascii?Q?NqdFxfmbbuTtC9DVVWaMLvnBhGxhbj8Ym8MyhWbhT6CJ/MgbTGRcDoCc8bCR?=
 =?us-ascii?Q?7XaQuQVraMHF4ACGdp9IMQPJqCAg0mO5IKJllANJyGe6u3Sr0ymukKJn3358?=
 =?us-ascii?Q?oMef50G9Z5Tru/Kk5kr9y90jwMWlcmL/C3jFud45mUKkBxCtoQLFYJUwFSGL?=
 =?us-ascii?Q?xOBeJ9+FeZJDK07qnGpqeM4jnOROLfFGKQe7vUWAr4yrmBZTbYYcdahNWhcd?=
 =?us-ascii?Q?5pgPK6EV/xMIVUKHw+fZbKxcD519hNZiWmHwVLnvB20VmZJdK9YcIK9Iqr0i?=
 =?us-ascii?Q?a49t6UyCVHBfpTnlHF7itscjgqmKfK+499FmNGjiv9fDd6Phssu+kwFfNI1t?=
 =?us-ascii?Q?P5ymeQp12FRRyRzPaCx9TuGfB6YIMm791ZsLEfMj0IDBe2POxoKehvPP6Nvh?=
 =?us-ascii?Q?tBf5fu0j+MCNTWdsbdlr+BPcRj9MwoAsTCe3VsDGkjWeahTGDGLU3zs91uiD?=
 =?us-ascii?Q?l7rqfLdLyG5MzV9h5Bhs8QQGBGoZoQgONrIy7RXK1wmtQD6O7H6CWiRus9xW?=
 =?us-ascii?Q?vJzYfDamN71D+E2Nkb0i8SfyJe0vCcdrQqT3K7NoIS/2KZvVpFU+Hn9yRNxr?=
 =?us-ascii?Q?Y0xnHdo979A57c+FPQiZAoh/RklXja1uqbAz0lY/7eo0ZJK5C3EvfQFTdaaB?=
 =?us-ascii?Q?UqfzKXMc2gWP+pe5JCgboDwDyLQMDaJe+F+35AcTF5j6n3ouacMriHX/uacu?=
 =?us-ascii?Q?VczXzxar4GUn/YfkM8b08xlD5XwLKg6QHgZP7Cw8w+DBrv1Q?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e7c0581-63aa-45e9-f64f-08df144d3829
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 23:49:59.7910
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PhBFX72OXUMDNRBURPGVvaSruNkRnB6eWzzgp2B96pJMz3I4SbGMQO4mODdHEtaZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR12MB9787

Add MLX5_GET_ONCE / MLX5_SET_ONCE which include READ_ONCE/WRITE_ONCE
semantics for touching ownership bits that hardware may read or write
at any time. The kernel driver doesn't use the IFC struct for these
ownership bits, but the VFIO driver will and needs these helpers.

Add MLX5_GET_MMIO / MLX5_SET_MMIO for accessing the init seg using
the IFC offsets. They embed a readl/writel using the IFC struct to
generate the addressing.

Add MLX5_ARRAY_GET64(), the missing counterpart to
MLX5_ARRAY_SET64().

Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc_macros.h | 52 ++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/include/linux/mlx5/mlx5_ifc_macros.h b/include/linux/mlx5/mlx5_ifc_macros.h
index d357acfd351de2..1b9e39a509495a 100644
--- a/include/linux/mlx5/mlx5_ifc_macros.h
+++ b/include/linux/mlx5/mlx5_ifc_macros.h
@@ -85,6 +85,13 @@ __mlx5_mask(typ, fld))
 	__MLX5_SET64(typ, p, fld[idx], v); \
 } while (0)
 
+#define MLX5_ARRAY_GET64(typ, p, fld, idx)                                   \
+	({                                                                   \
+		BUILD_BUG_ON(__mlx5_bit_off(typ, fld) % 64);                 \
+		be64_to_cpu(                                                 \
+			*((__be64 *)(p) + __mlx5_64_off(typ, fld) + (idx))); \
+	})
+
 #define MLX5_GET64(typ, p, fld) be64_to_cpu(*((__be64 *)(p) + __mlx5_64_off(typ, fld)))
 
 #define MLX5_GET64_PR(typ, p, fld) ({ \
@@ -130,4 +137,49 @@ __mlx5_mask16(typ, fld))
 		tmp;							  \
 		})
 
+/*
+ * Use READ_ONCE/WRITE_ONCE for a single field that hardware may read/write
+ * unpredictably, mostly owner bits. All other bits in the DW must be stable.
+ * Usually a dma_wmb() will be required before a write and a dma_rmb() after a
+ * read.
+ */
+#define MLX5_GET_ONCE(typ, p, fld)                                              \
+	((be32_to_cpu(READ_ONCE(*((__be32 *)(p) + __mlx5_dw_off(typ, fld)))) >> \
+	  __mlx5_dw_bit_off(typ, fld)) &                                        \
+	 __mlx5_mask(typ, fld))
+
+#define MLX5_SET_ONCE(typ, p, fld, v)                                      \
+	do {                                                               \
+		u32 _v = v;                                                \
+		__be32 *_dw = (__be32 *)(p) + __mlx5_dw_off(typ, fld);     \
+		BUILD_BUG_ON(__mlx5_st_sz_bits(typ) % 32);                 \
+		WRITE_ONCE(*_dw,                                           \
+			   cpu_to_be32((be32_to_cpu(READ_ONCE(*_dw)) &     \
+					(~__mlx5_dw_mask(typ, fld))) |     \
+				       (((_v) & __mlx5_mask(typ, fld))     \
+					<< __mlx5_dw_bit_off(typ, fld)))); \
+	} while (0)
+
+/* Access MMIO registers, usually the init segment, using IFC structs. */
+#define MLX5_GET_MMIO(typ, p, fld)                                         \
+	((ioread32be(((__be32 __iomem *)(p) + __mlx5_dw_off(typ, fld))) >> \
+	  __mlx5_dw_bit_off(typ, fld)) &                                   \
+	 __mlx5_mask(typ, fld))
+
+/* The set is not relaxed so there is an integrated dma_wmb(). */
+#define MLX5_SET_MMIO(typ, p, fld, v)                                         \
+	do {                                                                  \
+		u32 _v = v;                                                   \
+		void __iomem *_dw =                                           \
+			((__be32 __iomem *)(p) + __mlx5_dw_off(typ, fld));    \
+		if (__mlx5_bit_sz(typ, fld) == 32)                            \
+			iowrite32be(_v, _dw);                                 \
+		else                                                          \
+			iowrite32be((ioread32be(_dw) &                        \
+				     (~__mlx5_dw_mask(typ, fld))) |           \
+					    ((_v & __mlx5_mask(typ, fld))     \
+					     << __mlx5_dw_bit_off(typ, fld)), \
+				    _dw);                                     \
+	} while (0)
+
 #endif /* MLX5_IFC_MACROS_H */
-- 
2.43.0

