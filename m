Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012045.outbound.protection.outlook.com [52.101.48.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E5CF470128;
	Wed, 12 Aug 2026 14:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786546804; cv=fail; b=uIXBuHXiAqJj7yU2Z/ji0HDKIMJQ8g8mgJ2xCn3ShqqBx1rsHuf2x0vDWPffe+RI9nB5eYp9oiz7aoI2zkS13DFkHSxebPnvLDuuR5h8hm1P+Z2JsoeMw5pdUD9mFgWmIJWFj6Owj9PY4DYvUoHXYgGg5+YYJ94hl3sMkr3GE6k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786546804; c=relaxed/simple;
	bh=Wir46lGZsuw0+oTkV16tEtvQURb0WmW9EzUXyr5MtAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EBwzq4S/mo6yTueKbnYaEyQcFiyrWDj+gQsX1GZxNpK044VQ7kBlmI9gHUyXy3tTkBVPXmcA7yoS05tfVKkd/5w61t/17B/09tXk6Fonxh008QQD1FjgpQ96WmtFfC6fxOqQXCZr/rWmelTKzQpNelbEdVKkYX86m2iUIbjYwgM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rT2ri+Qj; arc=fail smtp.client-ip=52.101.48.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rT2ri+Qj"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pGd+5+S6ACS0zPvt7YrN9d+0/3UDjjExrnAiL7WvosGlZtwdxwz/uZDSeAuP6K7p4/wMMnoklp4p59HqdqRhaMwEuhjmzTYFPOmvJujxOfgddBWuPGv6SHAV2pLqHCEtrrVHGyB+8xJqj5FJf3kckqgfpb++aTy57oCu5Chv414g9KsL3wYyFmPP9Kkb0hCkBeIhdr1cWJSd59jFPg+NsWBAfBe8XWiv6wObhWcveuGZKfxMYAztWcV9QnOtR/EKgWMWZFas1OW8P49JbUlGvd9pfyIA9OR0rMpc/xt3Ynv2G3yr+oGhsPV+DbsNwh3CQ2rCXUGnvIFvPZxUzUN8Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kQ3MDMza/3JThWIfviBpbtO01BO4WWIL5tl97y//Tkc=;
 b=aZcER+ExroNJRYUo7ICo42T2lethkg9sJfV2lU34vpe6Z4WEm5GctBU0XYGTDN//UMptVSnSBbeAY/EEmONqZIi3MMz82RXDqAPiKsVaLHKE/yGPVyIIYqi93v0hdhUoz/yxduNRPwYHjr34NoEGto8grJLVIEmc5BJs0k8iGj+X6T+doS3c9pa2jlJZqPqKsUoK0eA3nnwXol5AAh8mDAhtAE5M8/m+dk1A70MNo5NBXywSyv0S6Jqw163MizF4LEyuO0ZnT0mKGLouRNcofnmNBqTBeAHTimcAKSdn1vcpyZRhTzwVWoXqs/cmt5STiQxXuxJm5VUfTLc1mthrSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kQ3MDMza/3JThWIfviBpbtO01BO4WWIL5tl97y//Tkc=;
 b=rT2ri+QjUhs/wR9LUIQApYEpt2AnuYtFZcBZacZLf151kwoqzxjNd3U3tm/P7JDi5CyfRCgqbbniN1vm8dp5biE6S7NLb27/1BxLgG/qRAp+p/5/dy8j5nxpB3RMM5MSI7n7aukTryfhj+Sy9GocIkYMGqxHxyj7E4blcwiSRmhowQ+F9qhuiTNvjGe2PtHHOmJyCgDEyJjg6htVGjEEe/8s93lyKvYRSj3RjdxwKX70UtPZVcrJ9sOJS5VFmVjI9iGnLuO5IxgE+uWMnUNY7loBa/xQwC3kMx4++QV3KQ/LdisroO9Edqnex/wryMJkNfUxZdWx+JHi4jLfDQdosQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CY3PR12MB9654.namprd12.prod.outlook.com (2603:10b6:930:ff::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.11; Wed, 12 Aug
 2026 14:59:17 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0315.011; Wed, 12 Aug 2026
 14:59:17 +0000
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
Subject: [PATCH v4 10/10] vfio: selftests: mlx5 driver - add send_msi support
Date: Wed, 12 Aug 2026 11:59:08 -0300
Message-ID: <10-v4-021df3fb5a3f+98e-mlx5st_jgg@nvidia.com>
In-Reply-To: <0-v4-021df3fb5a3f+98e-mlx5st_jgg@nvidia.com>
References:
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BN9PR03CA0705.namprd03.prod.outlook.com
 (2603:10b6:408:ef::20) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CY3PR12MB9654:EE_
X-MS-Office365-Filtering-Correlation-Id: 42eda1b8-d40e-4097-0e00-08def882446a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|56012099006|11063799006|10067099003|6133799003|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
	BbxJY/+lziO9Ibs7HPFOapV6Kz0ptV5i3eJQ24jK0uiErM6fcQTR+82BQJuwrWzzQc5jCHAZ9u7HreZ8Urtm5zkcI8Ml/eCqaEvyx4dugPa2I33bx0WApf8NPnGEV22z6KmXIgzbfA0jPZUorQj5zsX4WKHqaaaH6cycnZ7i78H16LDB+jJ0JgZb6xLrj8b1TNCnpVX2zLbyi2x0Ezg8rqmkeLlcPktpNAxud3f15JmBHNFoxPCmE8DVsfzSX/uZqUvZEsoSR0JNBSVGwuT1yQ/E1d4VannP2UKv4wN/SoL1HGQmfTKcFy9gsGA9E5ERfxU+/wAjLxQhDObIVkQtAYKZAbSv3Wbnuu+YdTriTUwDdiUSXnILTJn+Z9FtW00rxBKWBXaUUea39ttvtJLm5clAQx/BPP7b76ccjb6n9YwTA0U2ikjdfruDILlPXwLdSNQsu06m/eVthPcV4QPnw3WMcEc8OjoIeKPhg3Jw3bftP/tlE3Vt6sDI383BbmOHLdLw7rINO2X/3rijJ0HPfWKP2NiztOSViG76xRDHmw0NHR0IFvUXPvqE+J6iVbtRIUXuGDrGpNhdlI+tVQ6a/xbGn4QFqF6TWtKWSlg1xuehhhT6wpmzHlaAFn+2aW2UP/7KuaLqUHOAnbwBT9qLj4VwEmb4V+7ixd/1AhAsDf6M3Y6jJ5iWyE5517JF9LyFrwOSm4W/+TYSXSHm3ozXeQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(56012099006)(11063799006)(10067099003)(6133799003)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SHhkWXpoWlBvU3JYWldsVG1QMXVRbGRDcU05SEt1QmVYVnlxZUcrS21DdUsz?=
 =?utf-8?B?UHhxSk1vaWNzcFBscmtVSi9tdEQ2U0pFT0UyTnVVMi9paEt1ZjF0amgxSHRG?=
 =?utf-8?B?dFZOWWhyMVhUaXpvUkhveWhZbUs4VWZaU3lLcE9NNlZxV3Y3aUY5MzlVamI1?=
 =?utf-8?B?ZkdCam9tN0Q2SFdZWFpTOWI0SHQ5RFFCT1laMnR6RlkzZUttLytERFBNU3dh?=
 =?utf-8?B?L0l0NlJxV2NaS1NlYkd2UkxxVHhZK29xcGhxWjM1WW9EUzZOZWsxblJwdnVt?=
 =?utf-8?B?S1lLbTEzbjJ1Z1ozc0FmOWpjYmpLaTh1VmlEVm9wWlJJMGJ6ZEV0K2JiWkFS?=
 =?utf-8?B?bzloTTFmUWF5Q3VqQXlMZjM1cUw5ZFpOay9QcG0zcGg1Wm9UVDNvRU1paHBN?=
 =?utf-8?B?T1d2OGVrUURCNDNheDdpN2lCMm9OOEl2cUIvOEdZc1hTMjJWamkybVhGZFpN?=
 =?utf-8?B?d2VSQ2tONFBaK3hOa3B0R2hoOUNCTmU3ZWo0VkpONGtZdG9IcktXT0xiWThD?=
 =?utf-8?B?Rk5SQlUzN2c3alRXdXliTzROMzhOL1dETEpmUEducjdaMVE1c3VzdzBhSW0w?=
 =?utf-8?B?ZjJubjJzYnZGYndURFMwNGdXL0tkN2d4THpLNzNDL2MrbFdobGxpN09Ba1Iv?=
 =?utf-8?B?TmNZSUtyY1hzcFJTaWRSUGc3T2ZxZVpHK1NucnVncVdmL0g0dmlNTW14QkFU?=
 =?utf-8?B?L1NseXJ4SFFpTGpENEhsTkZQeG9PbUJCem03NG5pR0ttQTlHUGVvVG5nelVl?=
 =?utf-8?B?VzNMWnN5RkJla2FNWEZQYmhhYVBiUnRWcHhGS0VJWUNycE05S2cxVDR2T0Fp?=
 =?utf-8?B?Tk5CN0FHSGhCMTM5bWhxb2xFY3NpWHl1Y0ErdFl2bG9HOXozaE1naU9YUGtU?=
 =?utf-8?B?TkdEVFp2eEJuaEpVNWlQV2dKRk16Nm1zakVQRUJnWDE2c3lXOS81VlQwSm1m?=
 =?utf-8?B?K0srdFRNRVExK2lBQktzMkduQkRnRjJOMEh4YitZRWhHN0VUUHVjWTZRUVMy?=
 =?utf-8?B?TmhNaXZPNEluV3pVUmtMVWtWNDRjbktEODJhdlcyci9LL3J1eGNFL05jWnlv?=
 =?utf-8?B?WnN4QmtDVFJWYU1iL25yK1paNnJoaUhWRnlwbzgrSHFxb3hxcWZCTkVpLzhE?=
 =?utf-8?B?czVIS21ZMHhoSjhyYi9PN09DNTlwUGY1M3lnWUkrVFZCb21pbDFBbFhxZFdt?=
 =?utf-8?B?NnJmU2R3L3hsVUUzNk00dExuMlo4QkdSWHJaOGU0SzAvR2c2cmk0VVNQdFR5?=
 =?utf-8?B?eGJxZG1tU1BBTnFYenlzclR5dklyTTFZMlpTRldhc05Ycm9ST2lDTWVLWWJw?=
 =?utf-8?B?ekhVVWt0cXRIalVMZmVJNUlnaDZvVjJkTjdWQ0lUMFVMWDNia1VKczRnRTk1?=
 =?utf-8?B?Tjd0ZFV2YTNENzl6NXFWR3BPRUtnSzRHaU1rWFdzczNuM0MyMHpuMUJkb09C?=
 =?utf-8?B?ZGpCTlllaldaa2hER0d0R0ZmSElkcFBTK2o2OFBxZEhpRU9paVY4VVdVMTJJ?=
 =?utf-8?B?S2hCSXFqZTFsWG1zT29kVklrYnVLYytBbG9Wd1o2TUo5eFpKcUFDeDJVemFr?=
 =?utf-8?B?RmgzK1lpVUVOeHZqNzF3VzlVZ3Vmb1BRZmQxbjdWTG14QVJ2Ym5Dd1Q1MUhi?=
 =?utf-8?B?VUZOSk1jZXpVNEMyMjMvc0hBNnpIUTlYNTFtUGxLTlVlcCtVaU5TTEZrVjNV?=
 =?utf-8?B?WnpCU05MelhKZG9BOFdScUczbDROMENPRkVTZVhKWlJYenphU0twZ0FaNnVU?=
 =?utf-8?B?cUw4NWNoRnV3Sm1FZFU2RG1QaFozT3B5MGJnREV2Y1dWelJRTi9sU1RsWGpq?=
 =?utf-8?B?enJRNFRMOUFRazZyMUVDNkUzckIwK3NtRmYwaXJ5WDNjcno3QU40YWVLMTE1?=
 =?utf-8?B?bGdFaEJOZHZXbXB3Q3cxR1gxZDdiYnZEbDViT3EwektFaGRDaG0yaHk4OVBT?=
 =?utf-8?B?TkszMlQ1enJBeUVNQmJ3YVAwYTk5RjNENE1obDdLaFUvQVU1VmdURUhhQlhy?=
 =?utf-8?B?ZWx4T0tZRElKeVYzdjVwR3JNZ0d4aDNkVnRvMllzdnZMYThoc0k4VkxTZlJ6?=
 =?utf-8?B?dmQ5SGVhUU1XczhPU2V5eC9nOEZhK1UybitPRmpNeG5IcXdaenAydXBXYVpj?=
 =?utf-8?B?NGtlK2RoR2QzcG9rdUR0Yit4WGYzV3pTT20zazBQZEJWY3ZqMDd1N2E0NDV2?=
 =?utf-8?B?QWduaER4NVFad1Y0c3hBNFpWRFNMUGpPWVRLTktJVUVvVDlwU29MQk11UEJs?=
 =?utf-8?B?YlFIWThWT1R6NUxXRy9rSFNKVVBYYjd6SldWL3psaWs2SXNPaHBoU0J2bldH?=
 =?utf-8?B?UkFWZ0ZRM050Y3g2SzJvclRjVWZRVFcyQ0g0QXc3NlRhVkJvTm1DQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42eda1b8-d40e-4097-0e00-08def882446a
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2026 14:59:11.4861
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j/4eiidOnZTSe7rGuQjsFGOzX/nWdBzGkg+UbOLIMqpX6JruMFV/TCs8ve5PZUrR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9654

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

