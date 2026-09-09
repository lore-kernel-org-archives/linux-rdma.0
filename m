Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010052.outbound.protection.outlook.com [52.101.201.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823D352FE37;
	Wed,  9 Sep 2026 23:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788998282; cv=fail; b=SmJiKwTkPfk7zxFy8RDjV1LlGhk0jFbFbJV1atSQzVytKgdyWhNEYrk+SHrYBwd6yWaYx8NWW9HzcnltYGRGY8ce70lK7UY0fbN+e0q/60Ovt1p9Ha0h9Cd/zmFekneSt7VESphpZ8UvgkvsTLSmB+7DTJWivAZadWRGqlqPG/c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788998282; c=relaxed/simple;
	bh=Wir46lGZsuw0+oTkV16tEtvQURb0WmW9EzUXyr5MtAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=f50HkIM4QMPZKrPU+1Wi/KBZQFhhuXDl/WBDnxc0oLJMzt8Rt1T3TKY0N1W7LLWnOH1suMQACb3suIX1YxLyHxHNiatK0GlZ6s62bL11AuLVQD5i7Pf5b94jq9pnMvrlK7A8rczExVZuO0Mrl+ULiBrBdXkXNeHfZezbWQn4abQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=b4NgQtYh; arc=fail smtp.client-ip=52.101.201.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="b4NgQtYh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M7eWiwhvYjDZ113Q92pbMG1pLPccYES4DDcQkNqNVfxKbJTHSYii2Tao6kUovpbwC6a86pMdu/8jq4lRU1ewprXaL2aiqQ5pFwxyECdAYsxpzyll2bmxI9V+vhNyKiAYiAHR9gznwq640erKZ69mwQNa7o4YxhfpmaHIAUL8u2NzGbp7Dv+JhZUAKdiQFvOi2s32qQevbRGvDLBd1bURpp4hLMy7g4HnTX8OdcJNgKYQXc6zBx1zjWIuxD4ub2S6yf5qUZey0ypdOTw7D3dWPzRa4UtZE2Lln3H+HBXfgtiAiZzdLuXyI8pUEnlw2LQbpz2HKCJoB7Eyi8RkiQ5zGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kQ3MDMza/3JThWIfviBpbtO01BO4WWIL5tl97y//Tkc=;
 b=qWnfo2O7nJA3AHvKajfn748P/3tLciIoDXESmFJM/mXfWJjkLtADWSYtcQ4TtqGoMiLDlEgq8pdQjuLDpGtgxUsp15xPAwnmi3NhDtIYx/Wfn6DOpV2EzyPvzcvuiAVGrj6bgGRD8CsxgBn6+B4sk4XE272CTNjDr4mMSdpIO/Lqjek7MI+GZ6weoLNC5Cq5gsE0YndnJUjBVWIWABZkwfup++M6Pi0dVIM0ci2B/nb445/NG3+cE5LUMrzwjBGI0alTtXh+17zKBTJbLPUPK4trJxp3HZoelcWhU7EVsEHKye3qrbO3GAx6MRl05UCVWv3Pv17qvEG1Jf6bIICOBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kQ3MDMza/3JThWIfviBpbtO01BO4WWIL5tl97y//Tkc=;
 b=b4NgQtYhj0RUrUwtrgmki9DQJNbBHQ3yvF2xTq3niXcJ/LmEZyVJOEuK0cyuMnZWcnt4xh4fxAb0ljbl+jkvOWGnjaE/dhCPoltizw2biJrIJBFUNYQ/wf4zprROvcihnW6PaQsGPr4SSBM93IJoh0IhgI2hRCtqB7wKLEY1BxJXrxfur4R87qakKljTUq9mgoW+YhkfdRH+wFhP4lNh8hYM5BvSfTmJwH/s9Zji2jAL/h/BUBWZooQ9Krp5Q3qdBVgZucA2n2suJGjObEmT1Bv81RVlEWoLOwbB+h2QPbhJo7JdpwPCPw8sfqrtziahOymSGWCVL9FHKC/OiHD3Rg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by LV3PR12MB9440.namprd12.prod.outlook.com (2603:10b6:408:215::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.14; Wed, 9 Sep
 2026 23:57:50 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0406.007; Wed, 9 Sep 2026
 23:57:49 +0000
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
Subject: [PATCH v5 10/10] vfio: selftests: mlx5 driver - add send_msi support
Date: Wed,  9 Sep 2026 20:57:36 -0300
Message-ID: <10-v5-4cacb99249f6+1b4-mlx5st_jgg@nvidia.com>
In-Reply-To: <0-v5-4cacb99249f6+1b4-mlx5st_jgg@nvidia.com>
References:
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: YT3PR01CA0009.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:86::21) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|LV3PR12MB9440:EE_
X-MS-Office365-Filtering-Correlation-Id: 21d6c3e8-0f8d-4cc0-1415-08df0ece21bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|921020|6133799003|10067099003|11063799006|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	XwITXjgGJTW51AgLMwZU42ehRrNshi6zMNKznZ003u+R5tKN129aRwpXG9BGZ0p6FsfhfS5QNibl/HhQdCr9oFCXgtArrwJWljddJraNUUu4JQR/Pu7zdq1uCUmSy1a86Z3e+ScglhxMoori84jrxE4hI7Y/+29MGiYUHRTJR6KNdV2GvFBpfjGqEE7eAA6Yphq4aFzFHoRS6mzIxyUR+lYWEX7fEVO2bIjB4bz0F4tErrDfqC3hIEAOMZWz17kqJj6jGxZZct7IQxTWLsjx3pfeqoNgio5HbGPLw2aImUc/xXfgG/OIZq4BxP1of9PD7+4vSx+O69ghpHSdPAs7I+1tTQoEbG5PM2LPzosskfiYzBPdAKnGUeY04UpP+FExJAXN/hMAgg1aad+8mmXjh9j9JjYOOT/GwW2/CSILT8lnyX+SgdGrTysCiGdDnlJRLf1G/pGWNo8Vf5KPeDKsJRVn193DUrFtptEvB9zxi3VqAZecB6oVO/hvA69AuZoVaNbzfsgrFCke8nElVydEDon/PDYLbZOB0A98DP8M3Aec+wQdC35P5Ot/6E8vPxq7p6pLEp4Pxx6ZpucqZ+ij/kGA+tKwflWBPrSvEYiMky+saefNY4FMfccY5CL+2/FPzi7tJkvknBjGmRvpXHRJMAsR8bBKmgG6Wxwbwe5fu7aXLgpIwpxN0vS53tB03cKFUcvJzE/JPZk2We6vhx6yMA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(921020)(6133799003)(10067099003)(11063799006)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eGQ5K2V6LzdoVVVjamF5YXdLZHgvc2U5czhIZ0xxdlBaUE1zKzhwWS9NaE1y?=
 =?utf-8?B?Titmc0xiOXMvMlZueEdtN1NQQ3JKZmExYXdadmR5cDFacjdoT1hCWHlLUjll?=
 =?utf-8?B?b00rUm9sRC9yQnVmTkxBYm5reEFtdmFkaWhqVTczeERVZERmTDl4b0Y5SlE3?=
 =?utf-8?B?a1d2QVJwRGlKY1ExeWFHU011ZVF1eERkY2Z5dXh5ZlRWQTVkWUo2VmRjNFQ4?=
 =?utf-8?B?K1lwZWM3TDFvYjRESG1JS1o4dGd1YitkMjF0WVRLTkxvYzV4QWlRbkVFVEsr?=
 =?utf-8?B?N3oyMTAzM1NsTzNML3pmMmxndDc2aFhCUmFxdTBodCtDSDBDSDYwK3lqMFRO?=
 =?utf-8?B?M1dTbXJ2WFlQN2JsdTdJS1J6R3A3YW9NRHBvMStVZEtFVnI4SFNneER4TmNR?=
 =?utf-8?B?a1V0cEZaaC82SXEwZWFPVWx3T2Q2S0k0eTJsbGROM2tWVjREMmJETzBQMVNj?=
 =?utf-8?B?YjJnbVhlb0l3b1R1cHN5UW0vOC94cFRoajg4bmROMzBoZU9BZDhJRGFtbC84?=
 =?utf-8?B?L1BBWUo1WFBmMVkzR3V0MFo4UVNwUk5WRlJhcTlsK2lHNGtPcFV1L1VmbFpW?=
 =?utf-8?B?Vm9INm1CcHBZTGFCSm9vUUY3QlA0YkxsaUhZUUNjNUVhQytGdE1lYWphbmEx?=
 =?utf-8?B?KzB3amQrdGVLbWRUUFkvc2hVa2swZ3VjS0xiSUlrdEZkNyszMUsxYlRLMFM1?=
 =?utf-8?B?ZVN0RGJwVlRUQURwWjdaTHhSdDBSS3VQcEdrODQrMnVXNTVqR0luM2Zna1dS?=
 =?utf-8?B?SEo1aDZEK3lYcGtGSVc0VkFkdnVpeDhQaitlT0dxVTVrNHhRWll2M05WK2tu?=
 =?utf-8?B?V0hnKzFqdWk0Wk52UmErdlNjMTZJU1BrOUk4bW9HdDQreTBpdFIzbTJIOWtI?=
 =?utf-8?B?cWZLT0FiRnoybmJES2c2NWFMdmh0anlaK25NNzVpNERvQmUveWExOVkyNXVp?=
 =?utf-8?B?bGRWRldDTWw2MUU5TmloY1FUZ01Wa2tGSEpLWjU5MlBpTlFwRjc0N2NmYVpK?=
 =?utf-8?B?WTlCblN6b3hpSUVpUXVrcGltWmZ1czZ2eXlGRmVudEVUaFFUK01Qd1p5cGh0?=
 =?utf-8?B?R1RJUVhZNDlyT2VxZkVCSVlLVGJHejNsQXd2Q2MzOWhSbDU0UGhBQzVSTG1P?=
 =?utf-8?B?U3JhWk9QbTkxUUVnZCtsRHVkNUJRVlRLN3hBbEJBT0lIZnRZenRnNXNwSkFs?=
 =?utf-8?B?clFIQ1AzV0FJWVJmQnVYMzFTeng5RXljdDh0eGhEMXBkSnZyUWsxcmo2SThN?=
 =?utf-8?B?eERObjVwK0QxOWZpbDBzcUJERkEwR2ttVDdQdlE5RTVSSzRXS1B6YVhaTzRu?=
 =?utf-8?B?Yi9zZTBtK3dLUlRyNXAzZm5rcXJMQld0ZGpoWFZEbEtIM29yNDdONmVjdzFY?=
 =?utf-8?B?QVF2TGZHc2hqcUIvMlZDMlpiVVZLdGE4N2VDRy9wSWRaVFhFcGh4Vk0zU2VW?=
 =?utf-8?B?c1BtY0JPTlpHTjlLVk9jT0I5c0xzMTB2UFFVcEszeGhtTnpvendHOHJCeU5R?=
 =?utf-8?B?NGxsYStrRFJSU0RzamM2Sm4ycCtad3VZbklQUmdjOVR2TDNNdW8zQUhLa2gv?=
 =?utf-8?B?bmkyYjVpTnNnbjlSQk1iYXE4ZmZwRHFtbTA2V01tOUxWVTNiRUVTTTJIcUZ4?=
 =?utf-8?B?a2JRejdMY2E0RE1iRngxbkhqMldGelF2VFFEcEZXajEvMElhSkIzQngvMitk?=
 =?utf-8?B?ejM0bnJ3ZGE3RTRETFhWdldkY09IVkhZSDRHd2pzcUhkMm96cmZxOURQcFlP?=
 =?utf-8?B?dTBJeGI3YXFJaUlRb3Nyc2JxazNUL281VlpmWlFDSXgrOFJPSHVSK3ZuNVN3?=
 =?utf-8?B?LzJlT0sxblRublRSSWpiUmVJSy8xM09OajhqLzVtWllWVWx0ZnFDTjA5eTlo?=
 =?utf-8?B?K2ViUnF4aGxMQXk5THUySmRTVFcrdmhjM0hPVjcyMFBJU3k1cWNqSFhMNkZS?=
 =?utf-8?B?MXpjeVByNmcwWEsrUm1ncDBrUE85N0hicnRMeDJJSm43eGM1SnJFM3VxRHAr?=
 =?utf-8?B?L3F4alFQdzRtcnpCbEpXVEkwMkNZOG1ER0xBMXF5SGhoRjFyUXc1cUJoSjVI?=
 =?utf-8?B?dFZnUHZvTkhKS1dpT3pQY1NQSnlXVjcrTnBiWE9HZ3duNFAyVW41WFVrZ2ly?=
 =?utf-8?B?b3cvbDlqMExHMG9NUDh2RUpnSThCejhib0wwMjkySWJUVWNHR3lKQWtTaFov?=
 =?utf-8?B?MG50NGp6UHhWLzZGRGlDbmdraWNnYmxDcW5sWlVkTHBpejZQTit1Z3ErNVNp?=
 =?utf-8?B?dUkzYjdiSUd5enA5SVYxY0VwMlBCU2pDanFEaWtycXg5RW1EVHZkd0NoczZW?=
 =?utf-8?Q?oN1Ka9QZR0YhbOV0oi?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21d6c3e8-0f8d-4cc0-1415-08df0ece21bd
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2026 23:57:40.4655
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: INsM+7AHWGxK+SXhsn7fH//13xQ4ALGbO25NMUmwETIPrXk7saY6eiQ5N6QcX00D
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9440

Wire an MSI-X vector to a dedicated EQ so the mlx5 driver supports
send_msi().

Each EQ can be linked to an MSI-X vector, and the CQ can be set up
to deliver an event to the EQ. Thus, when everything is armed, an
RDMA WRITE posted to the QP generates a CQE, which generates an
EQE, which generates an MSI-X.

To keep things simple this just re-uses all the existing QPs and
CQs, so they generate single MSIs during memcpy.

send_msi() drains any accumulated MSI EQ events from prior memcpy
completions, posts a small signaled RDMA Write, then polls the CQ to
consume the resulting CQE (avoiding stale completions on subsequent
test cycles).

Assisted-by: Claude:claude-opus-4.6
Acked-by: David Matlack <dmatlack@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../selftests/vfio/lib/drivers/mlx5/mlx5.c    | 165 +++++++++++++++++-
 .../selftests/vfio/lib/drivers/mlx5/mlx5_hw.h |   6 +
 2 files changed, 168 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5.c b/tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5.c
index e5e75adb253166..c8388aabb8c672 100644
--- a/tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5.c
+++ b/tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5.c
@@ -57,17 +57,23 @@ struct mlx5st_device {
 	/* CQ */
 	u32 cqn;
 	u32 cq_ci;
+	u32 cq_arm_sn;
 
 	/* UAR */
 	u32 uar_page;
 	void __iomem *uar_base;
 	unsigned int uar_bf_offset;
 
-	/* EQ */
+	/* EQ (cmd/pages events — polled, not interrupt-driven) */
 	u32 eqn;
 	u32 eq_cons_index;
 	bool have_eq;
 
+	/* MSI EQ (CQ completion events — fires MSI-X) */
+	u32 msi_eqn;
+	u32 msi_eq_cons_index;
+	bool have_msi_eq;
+
 	/* Async pages slot state */
 	bool pages_slot_in_use;
 	bool pages_slot_is_reclaim;
@@ -91,6 +97,10 @@ struct mlx5st_device {
 	bool fl_supported;
 	u8 log_max_msg;
 
+	/* Buffers used by send_msi() to trigger an interrupt */
+	u64 send_msi_src;
+	u64 send_msi_dst;
+
 	/*
 	 * HW-visible DMA buffers below — device reads/writes via DMA.
 	 */
@@ -113,6 +123,9 @@ struct mlx5st_device {
 	/* EQ does not support page_offset */
 	struct mlx5st_eqe eq_buf[EQ_NENT] __aligned(MLX5_HW_PAGE_SIZE);
 
+	/* MSI EQ buffer — CQ completions generate EQEs here -> MSI-X */
+	struct mlx5st_eqe msi_eq_buf[MSI_EQ_NENT] __aligned(MLX5_HW_PAGE_SIZE);
+
 	u8 fw_pages[MAX_FW_PAGES][MLX5_HW_PAGE_SIZE]
 		__aligned(MLX5_HW_PAGE_SIZE);
 };
@@ -135,6 +148,9 @@ static_assert(offsetof(struct mlx5st_device, qp_dbrec) % 64 == 0,
 static_assert(offsetof(struct mlx5st_device, eq_buf) %
 			      MLX5_HW_PAGE_SIZE == 0,
 	      "eq_buf must be page-aligned");
+static_assert(offsetof(struct mlx5st_device, msi_eq_buf) %
+			      MLX5_HW_PAGE_SIZE == 0,
+	      "msi_eq_buf must be page-aligned");
 static_assert(offsetof(struct mlx5st_device, fw_pages) %
 			      MLX5_HW_PAGE_SIZE == 0,
 	      "fw_pages must be page-aligned");
@@ -1013,6 +1029,85 @@ static void mlx5st_process_events(struct mlx5st_device *dev)
 		mlx5st_eq_update_ci(dev, cc, 0);
 }
 
+/*
+ * MSI EQ — dedicated EQ for CQ completion events that fires MSI-X.
+ * Separate from the cmd/pages EQ so that only CQ completions (from
+ * send_msi or memcpy) trigger the interrupt vector.
+ */
+
+static void mlx5st_msi_eq_drain(struct mlx5st_device *dev)
+{
+	u32 cc = 0;
+	u32 val;
+
+	while (cc < MSI_EQ_NENT) {
+		u32 ci = dev->msi_eq_cons_index + cc;
+		struct mlx5st_eqe *eqe =
+			&dev->msi_eq_buf[ci % MSI_EQ_NENT];
+
+		if (MLX5_GET_ONCE(eqe, eqe, owner) != !!(ci & MSI_EQ_NENT))
+			break;
+		cc++;
+	}
+
+	/* Update consumer index and re-arm for next interrupt */
+	dev->msi_eq_cons_index += cc;
+	val = (dev->msi_eq_cons_index & 0xffffff) | (dev->msi_eqn << 24);
+	iowrite32be(val, (u8 __iomem *)dev->uar_base + MLX5_EQ_DOORBELL_OFFSET);
+}
+
+static void mlx5st_create_msi_eq(struct mlx5st_device *dev)
+{
+	struct vfio_pci_device *device = dev->device;
+	u64 in[MLX5_ST_SZ_QW(create_eq_in) + 1] = {};
+	u32 out[MLX5_ST_SZ_DW(create_eq_out)] = {};
+	struct mlx5_ifc_eqc_bits *eqc;
+	unsigned int i;
+	__be64 *pas;
+
+	/* Initialize EQE owner bits */
+	for (i = 0; i < MSI_EQ_NENT; i++) {
+		struct mlx5st_eqe *eqe = &dev->msi_eq_buf[i];
+
+		MLX5_SET_ONCE(eqe, eqe, owner, 1);
+	}
+
+	MLX5_SET(create_eq_in, in, opcode, MLX5_CMD_OP_CREATE_EQ);
+
+	/*
+	 * No event_bitmask — completion events are routed to this EQ via
+	 * the CQ's c_eqn field, not through CREATE_EQ subscription.
+	 */
+	eqc = MLX5_ADDR_OF(create_eq_in, in, eq_context_entry);
+	MLX5_SET(eqc, eqc, log_eq_size, LOG_MSI_EQ_SIZE);
+	MLX5_SET(eqc, eqc, uar_page, dev->uar_page);
+	MLX5_SET(eqc, eqc, intr, MSI_VECTOR);
+	pas = MLX5_ADDR_OF(create_eq_in, in, pas);
+	VFIO_ASSERT_EQ(mlx5st_fill_pas(device, dev->msi_eq_buf, pas), 0u);
+	MLX5_SET(eqc, eqc, log_page_size, 0);
+
+	mlx5st_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+
+	dev->msi_eqn = MLX5_GET(create_eq_out, out, eq_number);
+	dev->msi_eq_cons_index = 0;
+	dev->have_msi_eq = true;
+	mlx5st_msi_eq_drain(dev);
+
+	dev_dbg(device,
+		 "Created MSI EQ: eqn=%u, %d entries (COMP), vector=%d\n",
+		 dev->msi_eqn, MSI_EQ_NENT, MSI_VECTOR);
+}
+
+static void mlx5st_destroy_msi_eq(struct mlx5st_device *dev)
+{
+	u32 out[MLX5_ST_SZ_DW(destroy_eq_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(destroy_eq_in)] = {};
+
+	MLX5_SET(destroy_eq_in, in, opcode, MLX5_CMD_OP_DESTROY_EQ);
+	MLX5_SET(destroy_eq_in, in, eq_number, dev->msi_eqn);
+	mlx5st_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+}
+
 /*
  * HCA init / teardown
  */
@@ -1369,7 +1464,7 @@ static void mlx5st_create_cq(struct mlx5st_device *dev)
 	cqc = MLX5_ADDR_OF(create_cq_in, in, cq_context);
 	MLX5_SET(cqc, cqc, log_cq_size, LOG_CQ_SIZE);
 	MLX5_SET(cqc, cqc, uar_page, dev->uar_page);
-	MLX5_SET(cqc, cqc, c_eqn_or_apu_element, dev->eqn);
+	MLX5_SET(cqc, cqc, c_eqn_or_apu_element, dev->msi_eqn);
 	MLX5_SET(cqc, cqc, cqe_sz, 0);
 	pas = MLX5_ADDR_OF(create_cq_in, in, pas);
 	MLX5_SET(cqc, cqc, page_offset, mlx5st_fill_pas(device, dev->cq_buf, pas));
@@ -1394,6 +1489,30 @@ static void mlx5st_destroy_cq(struct mlx5st_device *dev)
 	mlx5st_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
 }
 
+/*
+ * Arm CQ for event generation.  The CQ event delivery state machine is
+ * single-shot: after generating one EQE the CQ enters "Fired" state and
+ * won't generate another until re-armed via ARM_NEXT.  Both the CQ doorbell
+ * record and the UAR CQ doorbell register must be written.
+ */
+static void mlx5st_arm_cq(struct mlx5st_device *dev)
+{
+	u32 sn = dev->cq_arm_sn & 3;
+	u32 ci = dev->cq_ci & 0xffffff;
+	u64 doorbell;
+
+	/* Update CQ doorbell record arm word */
+	WRITE_ONCE(dev->cq_dbrec.send_counter,
+		   cpu_to_be32(sn << 28 | ci));
+
+	/* Ring CQ doorbell register, iowrite has an internal dma_wmb() */
+	doorbell = ((u64)(sn << 28 | ci) << 32) | dev->cqn;
+	iowrite64be(doorbell,
+		    (u8 __iomem *)dev->uar_base + MLX5_CQ_DOORBELL_OFFSET);
+
+	dev->cq_arm_sn++;
+}
+
 /*
  * QP create/destroy
  */
@@ -1650,6 +1769,7 @@ static void mlx5st_teardown_datapath(struct mlx5st_device *dev)
 	}
 	dev->sq_pi = 0;
 	dev->sq_ci = 0;
+	dev->cq_arm_sn = 0;
 	memset(&dev->qp_dbrec, 0, sizeof(dev->qp_dbrec));
 	memset(&dev->cq_dbrec, 0, sizeof(dev->cq_dbrec));
 }
@@ -1691,6 +1811,34 @@ static int mlx5st_memcpy_wait(struct vfio_pci_device *device)
 	return ret;
 }
 
+/*
+ * send_msi callback — trigger CQE -> EQE -> MSI-X via a small RDMA Write.
+ *
+ * Both the CQ and MSI EQ use single-shot arming: the CQ must be armed so the
+ * CQE generates an EQE, and the MSI EQ must be armed so the EQE fires MSI-X.
+ */
+static void mlx5st_send_msi(struct vfio_pci_device *device)
+{
+	struct mlx5st_device *dev = to_mlx5st(device);
+
+	/* Drain accumulated MSI EQ events and re-arm for next interrupt */
+	mlx5st_msi_eq_drain(dev);
+
+	/* Arm CQ so the next CQE generates an EQE on the MSI EQ */
+	mlx5st_arm_cq(dev);
+
+	/* Post a signaled RDMA Write to trigger CQE -> EQE -> MSI-X */
+	mlx5st_post_rdma_write(dev,
+			       to_iova(device, &dev->send_msi_src),
+			       dev->global_lkey,
+			       to_iova(device, &dev->send_msi_dst),
+			       dev->global_rkey,
+			       sizeof(dev->send_msi_src), true);
+
+	/* Consume the CQE to avoid stale completions */
+	VFIO_ASSERT_EQ(mlx5st_poll_cq(dev, MLX5ST_MEMCPY_TIMEOUT_MS), 0);
+}
+
 /*
  * Driver ops callbacks
  */
@@ -1721,8 +1869,13 @@ static void mlx5st_init(struct vfio_pci_device *device)
 	mlx5st_alloc_pd(dev);
 	mlx5st_create_mkey(dev);
 
+	/* MSI EQ must be created before CQ so CQ can reference its eqn */
+	mlx5st_create_msi_eq(dev);
 	mlx5st_setup_datapath(dev);
 
+	vfio_pci_msix_enable(device, MSI_VECTOR, 1);
+	device->driver.msi = MSI_VECTOR;
+
 	device->driver.max_memcpy_size = 1ULL << dev->log_max_msg;
 	device->driver.max_memcpy_count = SQ_WQE_CNT - 1;
 
@@ -1733,8 +1886,14 @@ static void mlx5st_remove(struct vfio_pci_device *device)
 {
 	struct mlx5st_device *dev = to_mlx5st(device);
 
+	vfio_pci_msix_disable(device);
 	mlx5st_teardown_datapath(dev);
 
+	if (dev->have_msi_eq) {
+		mlx5st_destroy_msi_eq(dev);
+		dev->have_msi_eq = false;
+	}
+
 	dev_dbg(device, "teardown: destroy_mkey\n");
 	if (dev->mkey_index) {
 		mlx5st_destroy_mkey(dev);
@@ -1765,5 +1924,5 @@ struct vfio_pci_driver_ops mlx5st_ops = {
 	.remove = mlx5st_remove,
 	.memcpy_start = mlx5st_memcpy_start,
 	.memcpy_wait = mlx5st_memcpy_wait,
-	.send_msi = NULL,
+	.send_msi = mlx5st_send_msi,
 };
diff --git a/tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5_hw.h b/tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5_hw.h
index a2506ec8a19523..2c451e411ec13f 100644
--- a/tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5_hw.h
+++ b/tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5_hw.h
@@ -80,6 +80,9 @@ struct mlx5st_dbrec {
 #define MLX5_BF_OFFSET 0x800
 #define MLX5_BF_SIZE 0x100
 
+/* CQ doorbell offset within UAR page */
+#define MLX5_CQ_DOORBELL_OFFSET 0x20
+
 /* EQ doorbell offset within UAR page */
 #define MLX5_EQ_DOORBELL_OFFSET 0x40
 
@@ -94,6 +97,9 @@ struct mlx5st_dbrec {
 #define LOG_CQ_SIZE 4
 #define EQ_NENT 64
 #define LOG_EQ_SIZE 6
+#define MSI_EQ_NENT 16
+#define LOG_MSI_EQ_SIZE 4
+#define MSI_VECTOR 0
 
 #define MAX_FW_PAGES 8192
 #define MAX_FW_PAGES_PER_CMD 512
-- 
2.43.0

