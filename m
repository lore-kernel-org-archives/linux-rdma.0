Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011005.outbound.protection.outlook.com [52.101.62.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB36F511228;
	Wed, 16 Sep 2026 23:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789602663; cv=fail; b=ZaAKdO9s/VUs6iwckx/VWIgUfkmyXGV/eBcOEVs1SDNAJVOlDO9WBok0e5UQBh/5cFkt+lHilLVSGDze36MPsFgt53G8MEPgADtMgYTBH8RSqEAc8lXKmWte1gIjDh6lrqvXleq2C3DCi4f/Tr6OydgJ1NRjwyd6g3LdxZHyoXw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789602663; c=relaxed/simple;
	bh=74sOWeUaw7ehUPFiRkQvcE1lEp0KOhk1wvLzzZVSxts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OkhaHm857ON9Qu2EL5mKpEEszH9HapuQj3Lbm9BzlH6czWW3uf4XNWRSBeCzya70u1DQVIGYzDzBdRDFL3fDXlvBj7sCIDxKvVBpCqJRB8uYQoko1Oxx80G1msaq4eFsQSvBvjtLfcEs0+Kxe/TxNthoL4rMGAcLX9oMqi7cKwo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=l8c5CfsE; arc=fail smtp.client-ip=52.101.62.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="l8c5CfsE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Tg9TLOwNXs27BkUTnMXZ7sm24CsuXwRDQBilTDvBAf1obT52k4aB+fDoL3cOLVYdFOvwINeh5a76DJSKK4vr9+PfS9/q938ZRubJI+dRCRwhYUeNfc/ka1Au9Kc10tM1YxYmcfL/LkvL4QfEVhWOh1sQP+iN/PwT5PrgN7IEvG12vHjKXi1xG5yVcAYHJXnn6KK9NGVDiCScbfYEDDraNwuEa+Hcg5GP4aDfkxLHxSeC3llnvks6OfyySECp1IYY8vZ7SC9a9VW8f+gri4dSEu9tnIyE3P3XqRYli32meiHqCv6x/diX9AC+PWdRnEJ4erOBBz8P4R2BsW2QbOjBfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JUk4PA7QPkITtDR+knlLvdwXut01rfBprnsZdO+P5YY=;
 b=OimzTSVLHcLDHun1CoIAUv2hiCWpu0E7MdCB3SRC6776Q+WCRTa7VF3vNM1tllggKA/nDzUFsKt758CG9HdeySfiHeGS1giYPf0g6R74zO6605Siru42YqQXbJZ+4PhJ2Q0G4qpiv/UEEspb5beuZKqUvOHoXiJC6yDp0nGdM19F9GnC6674YjMSLy6mp0mS2ItZaRkkyGGrJ9O/KrWxFkYdD8xCIx55LlE2SkCEfTEp8f/cbsjlpaNeLSIOi4LNeUy5qgopHCROZl/d3xXSvr8W1WWu4UtJy8FTxXAiL/S6l5jSSxSc6D0XTqFdH/lXdMNan20SZhnHcVkGYoolYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JUk4PA7QPkITtDR+knlLvdwXut01rfBprnsZdO+P5YY=;
 b=l8c5CfsE5whiySIurHMIjNa4G2rpdPtUmNTHvo60cWk+aAkPNoLYsd1rVSQsduaYpuXCZ5nSjIM2zHir2qB79B9n2i19FhhR0WYrv3JBGDVaQkFV/3T8r/gKgwXFAawEr2yPoLiNZ1z1tSUttoH1nmH+1lrORyIUL4kzzhybKIvq6HiM44Wg3Lw1C+p3zXrqj6xngt7HnLsvKLEgekwB35/FZ7g8q5Bv96jCJ7DqlYfq9hohhNevCFIKXK+3S5ECpZFcQbA9Zn/iZQlg61CMKS1cxU/3U9VRBFjOCq9vQ43Inpx3RTrosjCZ8KBuasielaEr5aqWirN65WPnKsOA/w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by IA4PR12MB9787.namprd12.prod.outlook.com
 (2603:10b6:208:54d::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Wed, 16 Sep
 2026 23:50:03 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0428.011; Wed, 16 Sep 2026
 23:50:03 +0000
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
Subject: [PATCH v6 10/10] vfio: selftests: mlx5 driver - add send_msi support
Date: Wed, 16 Sep 2026 20:49:58 -0300
Message-ID: <10-v6-8af36cf7b73f+e2-mlx5st_jgg@nvidia.com>
In-Reply-To: <0-v6-8af36cf7b73f+e2-mlx5st_jgg@nvidia.com>
References:
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1P221CA0027.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::8) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|IA4PR12MB9787:EE_
X-MS-Office365-Filtering-Correlation-Id: f976a27f-2a05-4eb9-fba7-08df144d3907
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|921020|6133799003|10067099003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	XEKOZLuWd1LCKlEP3DD3yJHNvB/cY90J2RImN238Yl/qy6Joq0ZJn80zQn2uS96GxpvbJwt8XYlgTMmx7FdAe0HsmI8kKlJrin2hjBO6Zv8Bfqm1xw9gASSe6RdD00ZVcpjtSg4ZpMLa5N2MLwqk91FvFnLMakZd3A9Vf81ussFaX4PRTut4fdekiLGNNfvB0JOxibTxIrTQVcIrKO0zx6lkA7LPsQ2ST0ug4fSIlfaB2UHmCfvt041BMdD3yQjtg8W9HrqRwteL6OXtxwH3DZiE+ZudOt8N+AtFs9yG2RsfY1ZguGN9vY/RWivmsRCc6Cm+KPLJBpemm0D0rfWBjW0VMre/CRj+KnPT3GrdtMRgT52e0iUgj64KImR0S74KzGTGpQTgytWP1mcBuF0FoJ9gBsGVI670p4HZ2FUgfOnG/YTgwgPjlUKtnUQqyJU5/pXdYm/CsLmPuDufksrLxVsTlxqUQdd1S6xkenY3I2DXZav4kB8J54BCiPIVt2eJQRMmvF4aK1XVtM7DPgQAXvyIgF/fZ82m+OLlAEvcj9PlcVQ2vg3Aky6VjL19xPELyvEltmjBLJ/Dge4klle+1KOX/0v5iZYS2kTdEi38mAy3YqkznIx1NLrhKcu0kd5n6MOEES7ir0NB+fHKj/AcwmvnBEWy+ann59oyjAZbAkrX2hf2C9ldnErI33VER6F6DbSL9+Bgd5Z/Z40mUsZX1g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(921020)(6133799003)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cTFpMkZId044MEU5WmpZcEFLUGwycThoMnlZeTVMTnNxSU5ldUFIWGs0ajRh?=
 =?utf-8?B?NWM5cEJtRWFubkNnN0c0Q1MvVmJQTnJ6TEIzbDBMTWNWQXJZVlVIR1FQT3Bk?=
 =?utf-8?B?MFloUmF0Tmpaam1Mc3lnVC9QaDcrKy8zNEprRHd3WUJESnhIaUhhS0VQMVVS?=
 =?utf-8?B?SHpsU0lZV0JDOExqOVZ0WjhHS3N5Q3pGVHg2dGtNS1l2SFBpTDY3S1B3c2xT?=
 =?utf-8?B?bDVoSHBoN2ZZZ1ZTdTFNZHY1OEhqZFlZWlF6K1hJS1g5dmVuYzdEdG41bEZp?=
 =?utf-8?B?UGdNL2J0d29BdHVyNHBvMUlvUlZqMDQ2eHAvNm9oQURDL1VZdS8xRThadGVB?=
 =?utf-8?B?YVVBQUQ4N250VkJ2ejJMZ1FwSWltQUtKWG1xU3V3WEE4U09ranUzYy85dllz?=
 =?utf-8?B?NzhZa0d6Y0lUNWpsQkhEVUs1S1BEbEJ5T3lxOEdWUUJGcHAycEhPOTRoZ1hI?=
 =?utf-8?B?UU1TRzNBeCtQc2R6Z0pXZXAyWEROVG9LZFIvYmdhMUNLRG5FcnRKRnlSUUtW?=
 =?utf-8?B?TXdoTWdmbnBDNndQUTEyc2dJZFQxS1J2YW0reG5wdER6WUVabU9oMnpZWklq?=
 =?utf-8?B?SlIzeUpIaTQxUkNmeERzUEJYWXdkVXNKRGhvY3RHSEoyRDVHSi9MZDdxWHRi?=
 =?utf-8?B?UElNYXRSUHRuYjVxZFhEV0FzMTYrNzF1R2FRNGFVYmRMSTZ1d2psQjQ3UjNm?=
 =?utf-8?B?bTRkTzNzaWM4Qkl1MFpFYWh1WUxUd0xRSHEwczNOWUMrWUw3OFl4YW02VW45?=
 =?utf-8?B?WkJQK1orb0NTUXB2RTdUaDhzR01tb2FWdCtTbFc2S0FPTlFSeWJhUThNd0ZF?=
 =?utf-8?B?U1RwWVR5SjgzenJoclV4SmVLWExDRjFOMXJvUUptY1c4TzhpNVcyeVZKOFgr?=
 =?utf-8?B?aVRMK1VPSXpKUkZjbXRGU2JmdVB6c3ZiaDRTNllmL29kdmxDR3NqQ08rZFgv?=
 =?utf-8?B?RnVHNHJKdXVVRXJWdVVjRzFwRkdYOGJtTitoblEzeWJMT1dEL3RQZEpualM5?=
 =?utf-8?B?MThKYTY3N3RuMnNySjcyNlJXOUh1RTdhVHNNRUEyaHcveFJ0NnBXVStmck5G?=
 =?utf-8?B?Q2pFbFc4QldCblB3TmhHOU9CNXhsV2czSXNWSkdPZ1ZUZWxLT05WWWRocmVs?=
 =?utf-8?B?M3g4dXhobmttUFh6MkF1VE1EUENsN3Y2TFNhTmJVNktrRXF4K050c1FZY25w?=
 =?utf-8?B?YWRVeTMzYUJYWkZmemhNcGwxNXV5dVQvQ0tMTlo0UHA1MWFYOE85ZjBDZFlj?=
 =?utf-8?B?d2hNbzdhOWtpaUIrTitRVExHbDBuOG9mbG5MdG54ZVF4UHM1UnFjWjVlZjll?=
 =?utf-8?B?aThmaFpEVmJxNy9abzRNb1YxaHFvTlJLdEhHOGJKTUNxSS9NWjdWSDJIdUJQ?=
 =?utf-8?B?ME0vQjFKaTRMbjJ0YmpZWlhPMlhMV2RYSmN5Ylg1UVo0UldrRG92Ylp6am5a?=
 =?utf-8?B?aGJrd2YxbloxMmZYRkVpWGYxakhEamlTaVBvRmdUQUUvTjZsYksxWWYxRkR1?=
 =?utf-8?B?RU4wREhiYWZvckI4VDhoZEcxcEZtQjRwdkZlNnhLQUQ4ZFBsY2VNMEJ1Yzc5?=
 =?utf-8?B?blM1ZHNlVDJRQUZ4WWswc2FrYTk4ektFdWQxdmlBbTNoaWpPa0U3YzdRRlB0?=
 =?utf-8?B?TFkxeW1NUE1WZS95VVB2Z0k5SVMvQXdVblNFSUZzRXVvNXMzYXJLd3gvU01i?=
 =?utf-8?B?UXM4Z2RoRVJCaGhGdzRzNWRscTJSMUpBMFFuODg4RDd3R1R3QVRjSysybUZn?=
 =?utf-8?B?QXdIcGNQdGlzR2JKLzh6dFRFYVl5eDV2VGlVWVo3TVhwQWhnWHloVGtjQzcw?=
 =?utf-8?B?aGptT3JmSmp6K1ZzRzR2VmlqZ0VYRE0welRtT3ArdnVjdGNWOHU2UTQvSW5G?=
 =?utf-8?B?NnRONzk2YnRGbkh6NExiSjJoNlIvcjUrd0c0aFlnelNDR0RmM2VFelF1YXlO?=
 =?utf-8?B?RUlUcmc5MVBtZzB4cWxxYlFvdm9jNGUxVUs0dU84NlhLQ2h0cURzdDRyVlFk?=
 =?utf-8?B?NG0rbVlIb25qeE4wVnZ5OU5WTDFUYWd1RkRDRXhIUmV0YlpRb2dFNTdjcG95?=
 =?utf-8?B?cXJQUDNBRFViZFJQV2lyMGZORy83ajRURVRHcWRCVHI0TE4zOGhzczJadmhq?=
 =?utf-8?B?czFLOFJZMm9qKzZqdTRtRy9PMWE4TTArbE5DV0FtSlpGUHBzQVAxRTMyVXFJ?=
 =?utf-8?B?VVpUcm5QeFBjZTRhaS9PczdFTC9vRmtWUElRV2FoRkx6YzhtNW5CYTBoVGcz?=
 =?utf-8?B?b2ljNVh2WFBkUFovSHpXS1pvM1F2TXRFQS9WaC9ZS1huK25Rd25MdTdWQ3lH?=
 =?utf-8?Q?bvM1/8vlBgbkYIwoi6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f976a27f-2a05-4eb9-fba7-08df144d3907
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 23:50:01.3114
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kkoikwYYCE4insfWNwwu74ao0WaKsGNlv/WAQxZq/L8LUAuuXv9m1QtKuyKCvcW8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR12MB9787

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

