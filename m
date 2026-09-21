Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012033.outbound.protection.outlook.com [40.107.209.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030935218A2;
	Mon, 21 Sep 2026 22:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790030171; cv=fail; b=Dwu58Bb3Y+istH9FTMy1A6W8qcqu1kp7MH6NUYsuQWjyuhR4rm5JihyS9fZCxFwY2n99lM0UVybRWqj3f1KnL+EMgNuuM5MNbz3NEPHMo9tyNBGFphv6zpfv+w2bcPc/uurhmZuaowtIdNxDEBJNQaEfpQX3/x+rp2MmODbvAdk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790030171; c=relaxed/simple;
	bh=74sOWeUaw7ehUPFiRkQvcE1lEp0KOhk1wvLzzZVSxts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=i9gveab1v8cvHCoopHuJSPyqqUpaBhsiNmxrJ18cMA1EMRenu1Buodak/q8Z67TesICxIkoSWhYYsbQWj5np9J/Ql3i23O1BBq3f/u63pDmRyO6BQg0iTZ7B/fBkjpLpgFqlYeCNAg2G7b23t/rW7w7BLa76QI1KYHjk0PLMM2I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=am5RNY3u; arc=fail smtp.client-ip=40.107.209.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="am5RNY3u"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RLV0Q/8ITNE6Ep+8mdUOr+Y4vsaJC3NyHddJ/lIG3eO7qVqHEHn+NL57oeukp5LB4JF+ytru0raJvFO9j+cf7dsZ5qsR84AokVXyOwQev8wfnhW+SI1oswna6VltfHaDgyRUvV5JiLRkZFiaKOQppT7iKoNePpfn0hjq8v6yhKAJzb+vqg7EJNvpwY8oRpCm6pXX/IkMwde2Tr7s6R+f3T68okJlb5JijKrUA61JyWved/2AnUA8GDI35f38pvcelBONp2ROVW23nPRFvV2J21Q3PIxYgFLyygWkXioZRC7+I4A8WGFHI04ripK0l6vrw+7OwZgdPYPsXjWOsPwL2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JUk4PA7QPkITtDR+knlLvdwXut01rfBprnsZdO+P5YY=;
 b=c4VdqWmT7Y33eBjJl5jjjQUslCY4X8d38z+HQ/L3YHV6obueetojYsbwgsGbGP913ilAqfZfcF5M+dPqXKiZ2zNvdKzI5UlRDwiuMOvs2yUy+mHbCTumW2zEisytaUcIkwJvP7/dykrQ0hP8mUES8S3ETRqhuJJKqkoNThTRWxKOVlV6DCXuJsVGCG6RWxPscPLSnlSneOvGjCkiKPgB+hEzs3+eGHQzFaaJsxbLJOWMpxZ5Whzn3O1a+7UShqG7kFPBnpa901X9u1BbwNbRoEsByYErnNrlq3BnEXl4BOXco9JQnNbaHu7FuBjTLkeJ5JvTozTUxmjORW54CD7Uxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JUk4PA7QPkITtDR+knlLvdwXut01rfBprnsZdO+P5YY=;
 b=am5RNY3uOgew6+iaLv9Rg+dY+G4opDbYBmJSUyWpdGZt1rxcbM+fKTNNXsE4SV8CaMRjEdiLMPWgeS6EoY+F4GbB2lDEBFdy6ymqNE1jbKEhIO7rn1pb+g8d9GcKXB4xapmhkq+GQNVciAqVa0KAvFs7rrqK5bwMTugllVvWpWaYHowbXFH2k+bwnHmhRtEiR46/VjVYrpykz6ByUlWOvY58ntHUF109I6GdIoL7jISW9jCJzMKvpisikNOTfWJR79hESWzqhBFlFI0iWN6EY9LUfEM9x0VM9mGNlHULlMVQ9N06VThH18dleyFH3ivY9mYE1XDVE7zRp/9xeN/SWQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by LV3PR12MB9144.namprd12.prod.outlook.com
 (2603:10b6:408:19d::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 22:35:57 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 22:35:57 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex@shazbot.org>,
	David Matlack <dmatlack@google.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Leon Romanovsky <leon@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	Mark Bloch <mbloch@nvidia.com>,
	netdev@vger.kernel.org,
	Oliver Upton <oupton@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sean Christopherson <seanjc@google.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Cc: patches@lists.linux.dev
Subject: [PATCH v7 10/10] vfio: selftests: mlx5 driver - add send_msi support
Date: Mon, 21 Sep 2026 19:35:50 -0300
Message-ID: <10-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>
In-Reply-To: <0-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>
References:
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR08CA0053.namprd08.prod.outlook.com
 (2603:10b6:5:1e0::27) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|LV3PR12MB9144:EE_
X-MS-Office365-Filtering-Correlation-Id: 55851453-347c-4300-2cfa-08df1830b15d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|7416014|921020|56012099006|6133799003|10067099003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	HOQuDqw05oPUOzE1ibpFvuhl1ljm5HlRVuI0x5w6GdRN0Gov6AkOJHY3U/kXle6fgGQYtC9tzLogj3Tn53KEluI43YmTNIDeFKgBdxQe6rBSviDMgIm8oUkn8gpfwAwfkSjw+n23vm45tWDwLgknBmHY+1i2jcG1xRWZJvIlFUOvdwyGdaTcQZAiIgRL4AZWPmin8BE7zQGKcb3b9o2epa9fkvn/Cm+O4fYaNhr3fgQLJK0uKtJj4vUp6svR/yBnI1qT04BYk7MnFDH1KnnFETVCHX9i2ll+TGr3IE/+vjUux0cECULj19+o71lMO9vGqWVg6mS3fyMxxdKOewXEUGz0fJIjF8IZ6iqHhhzWhK10GLHN8lbHb0PNTOpRelxOntN8qpcDfjjleme9xeHlH0DHNPMsZqI2td4u8vW9YTP4wbwGDKWfPyDbB5+VNHCHtHl/Osa7OPuLUdTC3cOZ+YyQSZ1+CMjJLsOA3TjVm0JGR3yksg4KOHbBcwElflBHSqTMO8xm/Q57mxuNO250phUFtobMbO92kiYWtJ7OXuKhMJUfXBjAVkVXoI4cJQbLYg+JVY+hFO0J6jMIl899gISY1IwG5tl424lyrA4ld4P0ke2QlmvW9p7mC0UwgA/pAyfBzpQ/q5GOJIn/fdjgK+a1DqXxEKUrvkxZ7cMXkmUvTgKe1ZqX/lsNxoxvyawWSPK4g84D1bAl2xRjpKiLKQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(7416014)(921020)(56012099006)(6133799003)(10067099003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YlNOU1JsL2ZLUEEzWGVpbzlNVW1SLzRpbFE2dEs0ek10WGVVd1ZwUlEySStU?=
 =?utf-8?B?ME4wYk5VNFBaVk1oUlRxNHpoeUNjRzVsanY1MGJONUlURnVjMVA0RHNkaEdR?=
 =?utf-8?B?YlhWcHJPcXFoUlN1elFyWiszTjN3MXRwTkhXVXBaY3dCVWpzN3REb3JuR0w5?=
 =?utf-8?B?bzBDOWpjUTczSi9Ja2ZPTC9hMSs5ckIzREZUUVQzMWxKRWp4VnpVT29OVlZh?=
 =?utf-8?B?Q0pSQ3ZvVUJwczRRenE4azI1cnpUR0FacjlmYXRNUFl1aDRCSUhhR3R4Rm4r?=
 =?utf-8?B?N2hacndFR0tWM1pTdTZqcXZmNlhKMm5VNXBHVUlISThKK3hjRlBuV1VoKzNX?=
 =?utf-8?B?SU83VEtuWWFuUndMUytQQ0ttaTBmWFJCM2pEenRqNDJuVHBlZVhwWldOZ1pl?=
 =?utf-8?B?V2lDS0dDdVVEMzMrYkhaSUtEdWs3RDE3aEtlbTFzbWpEQUs2QURMYURMaEpp?=
 =?utf-8?B?RUpUbkw1bDBTSnlmNklxR1NZZTBqSW9BZHRhNGdneFhrM1ViNjdTNmVWNy9W?=
 =?utf-8?B?clJrOUhPVXowTmg3ZGVXOVlLL0szZk5NQzVRR3RSNytvVzRHU0RSRUV2RC9M?=
 =?utf-8?B?K3pac1IwaVZzVnFBK3o2cTZkVGNOazBaUUJ0d2xIb3pHVHFUQnF5OHMyRlFK?=
 =?utf-8?B?cVhoWW5iRUxKVFB0c2hXejY5QmlBcEVCSEN6N0tWL0ZNYzJsbHZwendOOVpT?=
 =?utf-8?B?aEZWTzhzeHY3SDRGNDlkVFB2VUEvK2tZZy9iQ0tHR283QmpDWlBtOXFUcEcw?=
 =?utf-8?B?Z3diOWIyNTF1UUVKcUdINTNkTEVzZmtkczBicnRwUU1lZGFDRmU5VnU4ZXZq?=
 =?utf-8?B?SzRZQXNwYVhlSXpWbmlySkJiSGY5TENEVGU0U1VJMnhMbmtkT1lkYXE0RVlV?=
 =?utf-8?B?VVlIRXk5RWFBUlFTL0dJWHl3VTlYYlE3NWVTZnc0SlN0aDA0c3hjRlNXWHN3?=
 =?utf-8?B?eElYTXJSR25BMnNSWG5QOXNvYnQ0TTFNUHNycVR2MGxueWp2K3d4Znhiak55?=
 =?utf-8?B?WXJEZXVxclVRMU5mTmNvQkNhc05lSXZCRTQ4a3IzZm5zSEJjWTJUYjVoa09z?=
 =?utf-8?B?ZGlwZ3lOdWVoSUN2ZHRjUFBKekpXT3BiVUNiQStKdHozZ2JsS1drZFh6U1Jo?=
 =?utf-8?B?cDlHRy9UQ2ZFaXVRZzRLNENBTmRQeVZRSWRWWFRFS0E2bjI1KzBhQkdMRzNy?=
 =?utf-8?B?Sm9CSFZJQnBZNkFLSzZ5c3p4cnZQMmdxeXRuZU9wQ1VJSnVIS2hLRGtUWEVJ?=
 =?utf-8?B?VmRTdTA4L1l3SEN0eDVYZGE4OTQxeURrNVpkeTFTVStUMmNaSEMya2Vmb0Rj?=
 =?utf-8?B?VDJIcmp4WnBaMDF6aFdaNVdSVVg2dThjb1RrN3dYQzV4VnBDTkxJSlVDaFEy?=
 =?utf-8?B?T3JmVit2OXI3bWxFZkpycmxLTjBab245RVY4bGFVOGtWZzNYdFB6bWlYeU0v?=
 =?utf-8?B?cVhzblV0OCt0NEY0ckJ2LzhHTWtvMmlGbHY4b2UwNklYcnpsaWtLWHFpYjFt?=
 =?utf-8?B?VGhSV1cvQTlKaXZUKzFaVkdmbWR2cjNyZ2QxSWVJb1BIbGRMUktGSitBdDNF?=
 =?utf-8?B?cVZha1JFZjd2ekRPQ2lPNENQSmk4MTFDQm02NDhRRllQM0dhVWZWQndYcHZ2?=
 =?utf-8?B?eE5rWFpDSnVsOFZSNFU3cFUzdGVjbGRETitMdlJ3Ui9KckN4Q0VUNUw1elF0?=
 =?utf-8?B?VzlOOXVhMWNtajZLVDZDVVk2UFNFbHdVRSthbEdGWnpoVnF3TGdHeDI3alNo?=
 =?utf-8?B?TTArYTdLOXZXcWhVeVhUZ2wrWWVwT0JFQTVXZk52RzBJUTRqNVR0RlB3emdW?=
 =?utf-8?B?dUE3eVVTRWUxbXo1VXlRMjhhSVFuaHc5YWo4Ris0ODVFLzF1UHcycW9LbEZo?=
 =?utf-8?B?cllFZWRKU1BvUWkvd2lEdjVVakhQWXpxNC9JSDg0YUhadTFBdVlWQVJZdHg2?=
 =?utf-8?B?ZDRwUUFTZUduZXU2MHpMVHNjbi9FUnY1NW11ZEkrMDdFeUg5TmR6cjk3VmNx?=
 =?utf-8?B?Y0hWTlhtNnlhZlVjVHJyRFZDNmNaRzF4cjhjWnlIN3hGdm5UNTFUVWUvcmlw?=
 =?utf-8?B?cXZxMllSS2MvRHN5QUI5eXVIOE9obVhLdkUvSFY1L1p6TVpHeCt2V2JMcFc5?=
 =?utf-8?B?L1ZTTi80bU9FWnpxUHhsbXhrOE92aDAxaVlHTXFLandxTzdWdXQ0aFlKOG1N?=
 =?utf-8?B?TmtReGY4M0tQOEdqU0owdXp5SVU1STFPUlpwb2J5VWZrdzJCL3FDTGRac0cr?=
 =?utf-8?B?YldmcUxSc2pJS21pMDFQcUkyWnRpR2pqbE9VL1dWZmNXcXdKM3FvcVByK1RC?=
 =?utf-8?Q?A9JN5dtyyezaBWgMBt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55851453-347c-4300-2cfa-08df1830b15d
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 22:35:52.4383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1qlbY/xP68mRkN5VK6zzSiJIQf0uVNRzA4x4bYu2sQCjmUTowGeeMo2FncxhNba7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9144

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
index fff3babef5e787..a65b52e183bc6c 100644
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

