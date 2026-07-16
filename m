Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012004.outbound.protection.outlook.com [40.107.200.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17CFC43786E;
	Thu, 16 Jul 2026 17:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.4
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784221430; cv=fail; b=tPjR1GzknuojeCUhTdGodg+KBLPgYYaa2GvMf12MNsa212d6W4iATT7R9FhtsMcRUu41ehjMXUwzKgY5Bfv9Y+5R+RTRmxUAmkuChY8MBjSRoO3VyQZBltEsIBbJGeKi0uznBkJOIN5He+851dEN0erf/h/25uTvJHaYuTr79Nk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784221430; c=relaxed/simple;
	bh=QmjCSfVoUk5hRRdqnNZzgJrxcv5n7biQvllZNKDoEDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=s15AQa5vViSy10fjvw52LkDGP3b7jsu/gK9JGoRGcc7qR2Yz4mag6rIU3kjOviH3gTr58S0rXyywSnjdTOR8p4KttjfkUwc/Fw54vlxgBEaJmveK3syW5rTgG1x0sbesMBXHvZPeYEsYCYVi3hnrf/13Ov8WJOH5mUR0bL8zASI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Ke3IHqdQ; arc=fail smtp.client-ip=40.107.200.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Ke3IHqdQ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fMuSBZ6D4PaaSfY7ugle22bM98PVog65xyIb1AiqHNc4Gl9HBl+NqYx6KD5BocwgiktGKJYQm46qjjnOcsbkk0I1f/Z1kFJozc3VbzpQzpBFZGMROikjitEZaWBaEYAkI8ihx5f8HK5Bi5ScM+fv3o+HA+oLtp0sa+y1eI+7jSo/eRZWRlHbCMo8KTTjalGaFhHTCreStiJDe66zNXD8NHh353WKdJIN299Ee3ujXiSUeq4Lgk8zLhmJYc/0QYqZkmd4qQiNq0GXRCfV/xUGq4M7YNBiwGD8KmT4AXG+ktubBe/GGUGF3M7YQNLNSMafjdtXVZSs19pP3gFJ4APS5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6dC2puCbvKkFO8ET+NT3Jc/ENzg9D2JD9+hdhdsg1Gg=;
 b=F4GzgviVxZeG+2NQCT9Eo7L3z2JGR5Y6nd4VEyM7EqIoYljH6nr7yJFIc6xlBm538hGcKmKH6B/wcyPdPYgZ4pSfbY4VoWgEcqJ5kVVK9Zs+SpwGrqIIvYYFrlt8pySYLFmLFKQPMlluzPPbS32nNvAfGgDmpzKLG8Es4uS4Sne6dZZo1IAPmVgLgGysNI/Qn3QfEWkcczamqqFKDHZ4qkKugk3MWCiBVxamD1mwlLExwXLuXZ4gYzrCn7eI3YmzOj6Vxez44sNXfm6cCZldRo4bNXWVJLq4Wm9GweFxKDHXVdWbZoaTRwxiuzkXzGd6ysapmpM539hN8hAcKmfNmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6dC2puCbvKkFO8ET+NT3Jc/ENzg9D2JD9+hdhdsg1Gg=;
 b=Ke3IHqdQKd9bNk9c3HIhGRT5z8wk9VlqvjH13LPUcwtMIrBLGUssVeF9k+KMUU41k0Thu8fL0wW9TU0eUSK0rOtpuqyGGj2N3BNJcdCaMtknoz1hT2+QIc7+MVrfj0uYPrg4xpzPJijgIuXB4x98z66Q80bcn/40Xu1zlLFvqW/PitLVuvXW4sCy/B3bx0nXkEQvZHAiLnUPKnY1XwV97QlxjSM2LQ+RGZqqH3b+6Bnyxm9tIuTcj/Hzmfih6NA9XaqNzlhQ0+hETjQSd9q2lkaB1TSDiwq7NxVDU2iBEiJwHb8Vby6XThngr5/G6MCuJ2TX8Pnx0sdcIQhe8FpdhQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DS7PR12MB6216.namprd12.prod.outlook.com (2603:10b6:8:94::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.223.12; Thu, 16 Jul 2026 17:03:34 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0202.014; Thu, 16 Jul 2026
 17:03:34 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex@shazbot.org>,
	David Matlack <dmatlack@google.com>,
	Justin Stitt <justinstitt@google.com>,
	kvm@vger.kernel.org,
	Leon Romanovsky <leon@kernel.org>,
	linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	llvm@lists.linux.dev,
	Mark Bloch <mbloch@nvidia.com>,
	Bill Wendling <morbo@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	netdev@vger.kernel.org,
	Saeed Mahameed <saeedm@nvidia.com>,
	Shuah Khan <shuah@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>
Cc: patches@lists.linux.dev
Subject: [PATCH v3 11/11] vfio: selftests: mlx5 driver - add send_msi support
Date: Thu, 16 Jul 2026 14:03:27 -0300
Message-ID: <11-v3-76f117ad04f1+28a90-mlx5st_jgg@nvidia.com>
In-Reply-To: <0-v3-76f117ad04f1+28a90-mlx5st_jgg@nvidia.com>
References:
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: YT4PR01CA0265.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:109::29) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DS7PR12MB6216:EE_
X-MS-Office365-Filtering-Correlation-Id: 84086587-6823-4b80-7264-08dee35c29e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|366016|1800799024|921020|11063799006|10067099003|56012099006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	1PRF4kzrCMT1hk1ljKGX0bB00G35dCTteQiie1DSR2INunIebn+PR33lrakfrSshIyoGSwuxVcbsIpCMFwZV14g1lekXFC9xY39gM68RkIntYeumahQxADO/y2CSwlHvOzczf4w4gTlRcxsCAGvHqkcQRGb95ieKS8zyfvxKyZV8FLJrLF67ZcZFlav8h2PvCyAoAqkxzAl+57G9VMgd2PwvGO08c+jxol5lolsZpbrVKtIe6YDXDc374fiFeDeepQa8mqNP0G/d4J8NjxUqx/fIh20jeEaaygZqjASzC2lC6hHDNwfsXd/CSiRFmRzDphAQpFhW0j6Hr6cImkkwnvw2vh3qxBPYIvtgN8y0dMbn02YtXXvK0P35kq6ZSHMlNh9C8SdcAgxRySV2izP3BBHpghEUT1dfsTVWCFOekJUDRe7z9mFmgXa1HpjrqdrgHHiaOaeHaMcjwRHX16vk3nfp9KTDXNoXjwX4RWvnh106mN2UfV0yh7KourhcW4LZKv2Xn4E89Pr5e+HMkBrcHtZzu23A+wszR0pKik4jw8ech9b7Otqekvi5H4hYUppAJXLDaS0CNj44P30zDbYCSMqRJNGIBVTuYw8ypxp0q/ZTymikHKRFM73lzVwLFjtAvzLO9i1ZCd7oYREFV0moH40piOiwo4BHd5hcQRoyjjwEunhEm9j/OK2PQfv0b13z3ENZ5Rig2fztbFqMzxRJew==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(366016)(1800799024)(921020)(11063799006)(10067099003)(56012099006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eXhhNnlYMEFobitScEIzYlZoT1N2R3JHbUxnaERtOG4zZ1J4K2lKWWIwNWJQ?=
 =?utf-8?B?am9ySzZIY3FWZVo1WU9FS2IyNjd5RWFzU1pPOEZJaklxVmczVFNkeWdScmJj?=
 =?utf-8?B?ckgycFFXcWJhdjNaUVJuOEZjMGk4eFVCbU5tNzlwOVNIVGNCMnZoTTlJbmc1?=
 =?utf-8?B?MGs4VFNTSXVvRkREZlhQaExjdDZVek9IL3BzNjVjMERqcVg4S2Jmak8zVnpH?=
 =?utf-8?B?Sllja3dUampCVnlWbGV6NisvbUQxY2ZUMGZiRCtkOTBuS29HK1RMUW1ORFha?=
 =?utf-8?B?TTFDUUpNMmg5YUJ0NzNvWURTZDBLd3hOQWFIMndVSmoxS01pcUwwV0dTYWEx?=
 =?utf-8?B?VHNhYlh1Vlh2ZDlaZEVBcVZJcWZRc01lUzJCVS9xQUdqWmZLeW9nNE9QdFEy?=
 =?utf-8?B?U1E5YzJkQkpUMzBTNFVZQ3VROXhnRkdWK2JVVzFRdmpNWDVESXVvRXBCOWpw?=
 =?utf-8?B?ejVOSWEvdUhFdGx3bERmeEFTU3pJQ1BQQkYxTE1URXllL0NkWFFPOWw5K21n?=
 =?utf-8?B?cTltdVlWQm1XVFJvVWpGY3UrTlJuT1Z0RGxjeDhIb2luc1FXTG5Vc0VRZ25q?=
 =?utf-8?B?aUhaWkhxZC9pWnBSbmRUaTA2aVI3MnEweEdOcmZreTdmQ0NQcndpUDRhTUk1?=
 =?utf-8?B?QS9FYmE0NkdkWE5jSHdwK1FRZndRZHlxTk91MTJlZm14dENEeUVVc2Vudjdx?=
 =?utf-8?B?ODR3c2wrT2QrSXNrbHQvQm1helhkSHNLenRXSUc3QnQ3NlhVNTFsUUJZSlNC?=
 =?utf-8?B?UDAxTExIOXpkY0JSdWdLT0h1MmFyQkRXdmlpQkJOM2NnaDFLNTZqQVBwQUc4?=
 =?utf-8?B?K0lsa1hTYzNYNEpZajFISTJiWW4vSmRYK3llRHRwenFyMGVOOUJ1Nm1RTzhY?=
 =?utf-8?B?aG5wZGRqSHlVYStubWF4ZXZla0hOaFNHbkdETUlaZVdkU2Q0M2l1MStEaDB4?=
 =?utf-8?B?SW80S2xZYys2b0VXUjVZemVxbFc0RUlDbE5IejNYd3hhVTdGeXlLSStackM2?=
 =?utf-8?B?aG5mMy8zSjdvQXVNWXdVRGhFUkpITXVVZEpicjhzSElGdTNmUVNpaUZyZ3p5?=
 =?utf-8?B?dlBpZm1aY054Yjg1Z2kyZ01URW1hTzB2eGhFNTBWUythYW5rdG0raHJMK1VJ?=
 =?utf-8?B?ckxyMW5mWkNlQnNzWW41NHdBZVBsUDUvNkswZEk5NjRQT1p1ZlQyUzEwMGxP?=
 =?utf-8?B?eXZydExKRllWaHIvNUdsNWszL0FBTHp5N3dkaWhFU1lpa2U0RlBmOVRwQVFD?=
 =?utf-8?B?UTRmNEhSWDRMNlZKdll1RlljbDZuQ2JoYlFZUFZPamR2VytuVURFSDNMR3dk?=
 =?utf-8?B?Y09IanR0K1A1MXZNT09nMnZIbDFpQm9jT0w1bXR2MGtSWEkyTWRtT1h1SElp?=
 =?utf-8?B?eXJVV3cwQlV6cUVpK0JoNFdMNDRuZnNnL1BZd1dqV1l2dmVlZ1djdzJOMEFx?=
 =?utf-8?B?bzlnOFRndHhSMURNUkJvWEt2NVZvS1krdDFrby9TekcwRi9QY0w4c2RFVXJr?=
 =?utf-8?B?VXhiSzYrb051a0s5TFR0Z1pBMkJYeTU1TWt5NlhlT3R1SzZOOVlJdzllLzIv?=
 =?utf-8?B?Q2lvSTdxYjZpRFB2NnNJdUJrYU0wc05jVHpmbDBvU1NLdlRNL2FuV3ZBd2Nj?=
 =?utf-8?B?TFY3NFZ0S1ozaGFDdEZHZ1gzdDEzN0Y3S2MxTVhtendxOVl2c1FEMFhJd1lM?=
 =?utf-8?B?ZjNNdlROTHFDdm9rQUxzYUhWeittUDFWUloyVStBYjliNUtsV21FdGlXMDdp?=
 =?utf-8?B?WnZ0STJML2tLS3NNSS84SldxVnEvWHN3Qk5SQmZYL3dLcFRDOWxsYWptWGFL?=
 =?utf-8?B?UTV4K1JxRnFtZ3RLOVp6WmVRUXlyYjFYRER6ZGQ0UGxUd3Z0TEVyclZUc25K?=
 =?utf-8?B?OHJGSGcxRU5WaWRVMUxDM2ZIa3NicFZJbk13djVSNTQ0UTloUzc5cE1nd2ZM?=
 =?utf-8?B?ZlR1amZzTG9WWldmdGlvUDMvUXhOTVhYYkZiTVk2NGtZVERNTVBWeTBxOTh3?=
 =?utf-8?B?QjlkUWZlZG5zakFSbWxoZGhMRmI2NUFjRDV1WXpVdklUUE5TaURyTDVSOFNx?=
 =?utf-8?B?OEROVjA5NTV5VnR6ZlFOaWttT0gxSHROTkZ0ZC9qam5YQk1BZEJxd3QyRmpa?=
 =?utf-8?B?VmNSd3crb0FHVkhZSGN6NlhPYkszbDBVTzRKUHNocEllYStDelE0M3VkaVBE?=
 =?utf-8?B?d2tCSmFkSW9KWm9SSWVxaFFtMW9ETEZnaElXNzRXN0JkTTZibkFpRU1kUXZz?=
 =?utf-8?B?RVZnOGMvVkw4ZFNhQ2VaUzM5NWVkSGkrcVdVMVJJU3NkakkyTUViUGRrZy9q?=
 =?utf-8?Q?7oG25Qv/H30ScAepmt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84086587-6823-4b80-7264-08dee35c29e9
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2026 17:03:31.6073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ds8j5GOF6cidIFIIjALEWH5Rv0EFJXtj60OywQNpXyfNo4TR7Q13MEY33dYGoYiD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6216

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

