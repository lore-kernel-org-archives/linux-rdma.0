Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11022118.outbound.protection.outlook.com [40.93.195.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F157374A06
	for <linux-rdma@vger.kernel.org>; Fri, 17 Jul 2026 03:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.118
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784258456; cv=fail; b=oXVKetdl4FX2PYdFc6ttpIJkpJnPTR+5wq1tXT2XGPDjhMME/31ilg/1EhITtJnVz4Q35E7Pz7pfwx+ExmpTIOrAzlrZ1JkUDCEF0xlM/d3mf3Q64ns+UHb9Ss/k/6Bf5AZnAUV6ABB7EVoE0ilJnLDghOppnHOQj36CMP0pf0c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784258456; c=relaxed/simple;
	bh=g8sOV5B/CXA1qnhuRlKLHszsn25kklK3y1tp7+67iFI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ejChJ25Y2TzarCMz2sMSk5Xi+Svx4TYIQhmQuz53QxWUueUlJlf8CYm30TFoECJ1TrbdbQpZg+/gxOHaCFyoD+wusski0zW7xMs6DKisutVLfiLEXrXorrBXFNcae12D1FMVfdGRkkIS0yTyrzURKsnNdaZVlHGVslV6Qd/fyI0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com; spf=pass smtp.mailfrom=thelustrecollective.com; dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b=mLKWOb0T; arc=fail smtp.client-ip=40.93.195.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b="mLKWOb0T"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p4BOBkJ+27IzBxzBzPtymCf4gPhe5nn0ZsuWDRlcT7ucErgoGuf1xsICbqYphopPCWxSjJBp3LI1EHTMvVuY4s/f/6moswdMnLpSQTm5/eYr04WzGoAA5poSp6nKyOLIwUKENqxb3IIMISwhAUXwjVZm5kzCFZAi32Fiwhu+Fy/EOKrnTH4Dpd7N/B+XoJZmxmQT1NhOj0t728SVY3zOQx4RLRJV9ktrXExqPzQFvi2nVvvb7/OEg3mWy2LOlbqd/eoOO3G4HsXREkfr32nxe8t4L+x+mx0NNSA5OnAyKjtBBGtiFup3iLE8e0uvoFw8jtIpNHTa1lGkPggWZ9Jyrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sXqLm7oVe+pBO1aXs/zrf+rgEyEsdx5R1l7mxCebEAE=;
 b=GuOPBWY0avmJ7+4/svocyVPdBMQ3SH4gkkDnURjwLOPYsfZnXiIOsKCAKJCMQq2fI3DFx1dkR/Labvec+eNu0ZdAmHUaXw4ZOaHNNKIFXuAkIu3aWQ9aNod3f5F9LP2gjUF6qQDXSvvP2xdXOGY41Gqy/ZO2a5KUJf/MtVC9T/PLQv1pwfPt7IX6ZRAs8KwzZRpaQ/M3fCqbQ09DT9pt3VVYPzrNbXCt1WDwSZXesSKMhVrvVXwFPPn/bgrjObBIzLstSpZ6wWLM2iWKObbiWN3QvjrMi1hI9DjAQDNh0aonYGsm7Zh7diJ5moL+m9d7uaVi2MX7RT5zl0ZoMVIKIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=thelustrecollective.com; dmarc=pass action=none
 header.from=thelustrecollective.com; dkim=pass
 header.d=thelustrecollective.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=thelustrecollective.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sXqLm7oVe+pBO1aXs/zrf+rgEyEsdx5R1l7mxCebEAE=;
 b=mLKWOb0TS0++0NwpHLjj2T5ifB5vfSrbDUBiwMka9WdGrzIIl8L4hTa5vqz55DUnWeEFgzjb3sEbtyRkfzniYT4OIdS1umjKz1MJbQL0j9kYkJmHC9ELf5ySRtIjhMLmW1vPWxTX+a8qaQZMyO3s5uozIyLcvbVAcOBt7bBGv7fabc0o6cuD/yRLzHf/aK31nVKyK06+lt5wlKDD8LwLyOaPGd6o037LSORD9SP09c4XefdXJ9TKtOqzF3VNZJ03MHt4SLo8UF8OZcIv8xSh8z7te4m9i2LNyArI86Mq4xLCkZzsHXS/UBuk0vf2saO+aCHtAQj0W+t36pudHx+Dxg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=thelustrecollective.com;
Received: from DM6PR04MB4682.namprd04.prod.outlook.com (2603:10b6:5:24::20) by
 DM8PR04MB7992.namprd04.prod.outlook.com (2603:10b6:8:7::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.223.12; Fri, 17 Jul 2026 03:20:50 +0000
Received: from DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee]) by DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee%3]) with mapi id 15.21.0223.008; Fri, 17 Jul 2026
 03:20:50 +0000
From: Timothy Day <timday@thelustrecollective.com>
To: Michael Margolin <mrgolin@amazon.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org
Cc: Gal Pressman <gal.pressman@linux.dev>,
	Yossi Leybovich <sleybo@amazon.com>,
	Marco Elver <elver@google.com>,
	Timothy Day <timday@thelustrecollective.com>
Subject: [PATCH v1 5/5] RDMA/efa: enable context analysis support for efa driver
Date: Thu, 16 Jul 2026 23:16:58 -0400
Message-Id: <20260717031658.477397-6-timday@thelustrecollective.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260717031658.477397-1-timday@thelustrecollective.com>
References: <20260717031658.477397-1-timday@thelustrecollective.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR08CA0010.namprd08.prod.outlook.com
 (2603:10b6:208:239::15) To DM6PR04MB4682.namprd04.prod.outlook.com
 (2603:10b6:5:24::20)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR04MB4682:EE_|DM8PR04MB7992:EE_
X-MS-Office365-Filtering-Correlation-Id: b27e4b27-ddf3-4fe1-6414-08dee3b26690
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|18002099003|22082099003|56012099006|10067099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	kOruuNTnwXH8BjJJmp72YTnyDOh2EV9efRJeSL4fYDuiedmx98WVVD8gGm7z4QodzKmNaPS/IAZ5a9HKc7F8kcuByfd3fOqNTc/yjZFkoWGFnI752EcoW6S6I24lcss+c+PznAR7u+m7xIjTEFgUxaYj/xWZduvLVaAxx5uCfY6eVB3R8ImH6hHOSKOFx1iGmiKViq8PpgHX2ZAOCTSfG1nepOnF0hnpc+FRetZulBJBZtJ9mzC8oKSOg+Oxh66nn11oz13HTMg0CIqoWCb4w51IDo/mB2DlkLpHes4Hvr6QY8bWlQj+o5jSU70XydfRadRYmhXVj5AWc2Bsiki6fTwLWMvB3gInXNaQtKptHFshpkytuGkMsAalm3o4O/xHoSRtTIyyLzpaHmjTeN3ZADe5nYbFgtL08i6ptu9hqg/q/yRkQETcyDQEMM6HWYL36AmHH7XDxGwYFG5ULDC8kAo63EG7jNBj1GYmzwGWvd+aKXQaZNIIxrWtGbgs4DC6Ajrq5SOKTGIcsPklvt9ib/KqrGuzvKS5XCQVRr0Ed9S88wsp7IZY7CiucDga54EHfVLCXQCGJ1FclaOMbEmAC/nEYTp8yPTVXMqXsWTK4ilunPMw9MHWXXTdcQuspcRwxiRpgxMLz7rvxcWYzwOv8Ysy63chBrMShq5fWlkKJmo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB4682.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(18002099003)(22082099003)(56012099006)(10067099003)(6133799003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cFD00Ad8E/8HNxIMxZE/pzbPaxLIfbj/wl+3F58pIuC/JmpkuC3qzMgA4A4Q?=
 =?us-ascii?Q?mfBC4N6iZ+8v46YvGoA9aNiKTuszv3y95geHlR9eEJZVl0o1NAee7zRfxB8p?=
 =?us-ascii?Q?dH06EmbQZItnkP8jNmTPq1ywC8GLshymA7euO43NiuYES4hpgGsXDgOBaB0w?=
 =?us-ascii?Q?ApR7Jt2e6l9caXwBdyJiCxAjcwLsonk8rVJvN8ImeQuOTwfiq/SjuQFo0zeD?=
 =?us-ascii?Q?GraISoGt/khJL7wQODeNaFY0lD+8guRKYnQfJMHhXgl6PhkF/is5gnBfLQi/?=
 =?us-ascii?Q?10j07KTNMZm0PARVDBMatXjycJJMVTPF/XHMr+d1eI+uOPTpZKMtoPDa7fxN?=
 =?us-ascii?Q?fTpfzjAGrmA8nuGkoLfZsH9nniFqoWSxi8g8TyIg7/BtxYRVExVGV9IUfecf?=
 =?us-ascii?Q?UHNsmqZgm9c8/3fT8XG+JXjmpKqhiD9TBvTdyVWqZPcpa8B5IhcVakzmFCAH?=
 =?us-ascii?Q?WPhrL4LCQYOuLgvAivaEX2ntpo6qzmps+8Ax4jv/VzjQOBO0/gEvB8yt4rCm?=
 =?us-ascii?Q?Av8kcXInwzPn3yJEIfD4jjBY6U7u0b40+VmL/TMpurKrBIyZqAbHcbefEne4?=
 =?us-ascii?Q?4c3zHpwgUkihWoRiUurQBGMRzzhhwhw4w9RjBPIkrNsXnV8mnfsNyTNdzTkj?=
 =?us-ascii?Q?LkUXkN+6AYadsrZQWscaX98ViwAh2K7dBcCwVp7Kak0veA3VT/msU5ZQldBg?=
 =?us-ascii?Q?XjAnqCx+v43d1VSnd1fweJn3WSxcwmVPrye0vwFm9XICEaLNesSteBjvIDys?=
 =?us-ascii?Q?MTmh1+H8pbr93BcAV1qINsJ4BtVRr/xlJ7u/ix2q/UGEZWh5pErlpwVDGufX?=
 =?us-ascii?Q?vQJoRREU1ORfFuL/QRyLJSqTF0IzNuDUMrhLWZgjH0llaAikgwF2OcoFawpd?=
 =?us-ascii?Q?cL0AX6BhMicMSZi83bByvymAZUjbhA2JUi6fiiqfzL6R1Ow5thnDC3zsN7Xn?=
 =?us-ascii?Q?BoxDsPid0YQcHlZD7HDW7ZuclH9RttIgfffd+GdPLRWQCqyRNO8AhKnRI4dY?=
 =?us-ascii?Q?Vj5z5J0P3o78vLq/YCkoFnrPVQi57QMQjFeectD3hZV9x995Iy2e1LxGQ/9V?=
 =?us-ascii?Q?dhGrOzgApbqNyJTJ7RXKbql5IlUOeF1GaWW16iftID4MQqmW6zhrUPQ6yYGv?=
 =?us-ascii?Q?IS7za2oXWRHLWvcULR7gUfnJ3ZHj70Vepwyz0YyP68GuB6CAm/LZ75ExCwYo?=
 =?us-ascii?Q?jVXMWIPJ7D2VFRh+rmZkm/q/DMc8LUWx+fTKNmxRkyz+x2TMiEohijQLd3o9?=
 =?us-ascii?Q?v7emrxzEcZVcdzrOrGf5+YB2fdfLPO/IpuqLlwyWyJmGsdvuYMnLiLs63Who?=
 =?us-ascii?Q?2P2DCH/WYyg/4OAEZMeWDftJFwEqHzKMbUE/YYMhDOsSiTz752GILmhHAiht?=
 =?us-ascii?Q?j6ngThrD6+E0zYwIub6WHJZ73lYsQOYn6/E5ni4cvGkOJ1dLCpc0GP74GX2H?=
 =?us-ascii?Q?9kGhatIpFQYyk2YbjmxOAAcVcpzFdeIqauxrnG0TGOLWh3OuODaDucLXgNUW?=
 =?us-ascii?Q?94ObXh6KQozf+RoVr3u+Ei9sgvz40N2DSCnqRcwifJJdTbM/99KGDhTSoVCh?=
 =?us-ascii?Q?9GLwYR0iDUcri5u+BsZ5eQxS8J+lyPlnEUfcIKzV3DvldN0FKEI7FCY6KdKQ?=
 =?us-ascii?Q?r8lnvaZPLwikjYMJQm/E7ZcIU0Mu2JJBya7u5/ZafGy0U1aZeCsEkZjzPuqZ?=
 =?us-ascii?Q?0t2TYIDqDOPNLJj2YwNe3UVO5G31m2mCPUs8+6n8BZQI98q5gbAS5wzF4CnR?=
 =?us-ascii?Q?lDMvXXJ9XMU81YOBzFgUZgX0dxxHSpo=3D?=
X-OriginatorOrg: thelustrecollective.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b27e4b27-ddf3-4fe1-6414-08dee3b26690
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB4682.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2026 03:20:49.9686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4c9dec06-8f2c-4233-98d5-ca3cb36218fc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eBjeP0IgYIL1F9J3N2sAedq8DuqSXgfE7Fytv8WANezVdn8y/yQBe5BMdg8XGKqXWXWGnR9Q04UiUcUw46jEzHfNxrws5LqcjZ/hs6peDLo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR04MB7992

Update efa Makefile to support context analysis [1].

[1] https://docs.kernel.org/dev-tools/context-analysis.html

Signed-off-by: Timothy Day <timday@thelustrecollective.com>
---
 drivers/infiniband/hw/efa/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/efa/Makefile b/drivers/infiniband/hw/efa/Makefile
index a6a433b0ba2f1..0a6843f3c5e1d 100644
--- a/drivers/infiniband/hw/efa/Makefile
+++ b/drivers/infiniband/hw/efa/Makefile
@@ -4,6 +4,8 @@
 # Makefile for Amazon Elastic Fabric Adapter (EFA) device driver.
 #
 
+CONTEXT_ANALYSIS := y
+
 obj-$(CONFIG_INFINIBAND_EFA) += efa.o
 
 efa-y := efa_com_cmd.o efa_ah_cache.o efa_com.o efa_main.o efa_verbs.o
-- 
2.39.5

