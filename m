Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793724053;
	b=2zbgaFEX2owRdDkplmXuDM+EMnao337Sto11uvUuVyJgOPuvQHhwxZ9tIW8VXmhaQ9yn
	 Nr28bYsQaMudBmpni41fs7MonqnRw9KyovSMhmRhwAjdKp9jNz+DMUW7Cl+Gf9VchDHi+
	 diSJRrm6OVfR/4ojhtQH6n6ORkgyuWsZIKUwDarF4BmH5CyENu7L4Hs/TdOUMvLmwVbMI
	 JLu7a7GEr4r3KaF2uyCnMcz8w+61fK8ccEgzZafXc2WRCsnnLz+IQXE8YfUd71SD+JNcv
	 xTRvoNg7Owh0wTOMzg6SquIGXS+ESI34wGc8BVxAPtZ8y5rV6wuToeaevBZjcji6fPQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793724053;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Type:X-NV-OnPremToCloud:X-EOPAttributedMessage:
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
	bh=iZQFQryjCs1qIYRAsOfD9/dHEXSzObW9A2bm3klURwQ=;
	b=adk3KPVtjF4Ng5OY97d8Hp5n7FR+9Znnt7bw/ZmQvrEbdSWMDmDkFR7lZoh1e8+BUWQo
	 sADEhbS9MvxlwwBLbwof3mrepdytoGWTNGQqgmF/1ealUjGMVpfnjKSnyNZ4vEdYmXP13
	 520PHDN1KgmtUQJU/lRK+m5dUym9tH7B2K2ZpfnBFvMCBfIsw6+u7ZH5x/xYQHj5192MW
	 n3DfwsfH1HQXtC6tgxzmDMkqiDwVgV12cTCjTC/l1tQPiVlIP0SvWoP1QJ2XATeGW3qT2
	 yFaGdmiUrT6LHVB0bq8eVXy6xCUe5ukiOBRVxDn12DWHIEx+y/UxN7Iwlk0nIYz1Rxg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ZPasoUkS;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.52
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010052.outbound.protection.outlook.com [52.101.46.52])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEAC7606EE97;
	Tue,  3 Nov 2026 16:40:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AEAC7606EE97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ZPasoUkS
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OW8bp2u9pQu5bgJMOqTH5B7wBV2eB926CtKHw9QRlM1Kc3EGHEhI9GU+wkz+rNYQnTr52eXgbZb1Itw5//WwzWL33BC8l2yaCWCMeBR3FwLDhj2YwB1q2aGBc18IXBjv3psAknzjRzWaCwmcJy73rjB2jLYNGxUUV6n3P5VMco9fSs77Vmnn7aby2OA/JnSvUBkCekCWuK7xUkDWDxytZCpFdUuiSVQwngHVU1pOinLHkdxXciDiggV0+B94z03rAXDThnZ8ogw8FIgcjKBvrEGiiupFebm64z3TSoqHwuWAMiuMyQruf4RvedcF9wJQHBjUnkJMokZa/jUg8Yvn5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iZQFQryjCs1qIYRAsOfD9/dHEXSzObW9A2bm3klURwQ=;
 b=a1dt57qeeprRmORicVUiItVRz16Ji+sIIuE0mgEwYwg8t+FiurQ+NK3K71rXitpjiD+po2nnGb5NKcsS1bCtZNTyg6IlEiT9mzfJGMMOn6MI6bu7GtZTnfn/9jCQccYijx9SoI4YB48RWt+vaeCwu5FHRMTomOHC0hmy8THuTWMtmkUV3Ua2iucKx8b0DRb2o5IpfJ+qwFVfe/mXM6GPZ6Z8brA6MULIcYLRJEybPCfOFpsGk0Q7itsYtge/fO6kKC0r8WAtDo11849ZDhOG9CKGFupTKmeQ0FUw6fyBI75l/bCoCEZ79ySDhT80TC3phegu/8uyZqzI3o3eYE/MoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iZQFQryjCs1qIYRAsOfD9/dHEXSzObW9A2bm3klURwQ=;
 b=ZPasoUkS99jPKWAv87D2kcyHnAflOx3AcXD3UO3Rb2VNalYHXicD49QU3fU27+PE+6Ua/yGTqr1np2bo2FULsKuk/fAQy4kx8KHwdAx+zyTWWrtt0u7kWRhRAwk/nHh3dVP8O4b09DF1eJt3IHex6thFmWKqUUcQs7iU9MwszQUW9RugEGw8zO+IdfXB/6xEEIsBePYFc66nI3BlWhSXIgTPjpOmj0cL+LLPKyYXwZ/d+0NtOtpKI2KEXcVN2HEEEUc+grr+YsaXYFYdtb/ZmOmw5opdgf9zuTi3UbmUh3JRzhVz0MpufPujvHJ9vWEQNGJytUxj2Qt9MGYJdbjAgQ==
Received: from SJ0PR03CA0359.namprd03.prod.outlook.com (2603:10b6:a03:39c::34)
 by SA3PR12MB9108.namprd12.prod.outlook.com (2603:10b6:806:37d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 16:40:48 +0000
Received: from SJ1PEPF000037AB.namprd03.prod.outlook.com
 (2603:10b6:a03:39c:cafe::32) by SJ0PR03CA0359.outlook.office365.com
 (2603:10b6:a03:39c::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.8 via Frontend Transport; Tue, 3
 Nov 2026 16:40:48 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ1PEPF000037AB.mail.protection.outlook.com (10.167.244.185) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Tue, 3 Nov 2026 16:40:48 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 08:40:24 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 08:40:22 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 3 Nov
 2026 08:40:18 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH rdma-next 00/23] mlx5: Adversarial mode for confidential computing guests
Date: Tue, 3 Nov 2026 18:39:26 +0200
Message-ID: <20261103163949.1554-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.18.1
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000037AB:EE_|SA3PR12MB9108:EE_
X-MS-Office365-Filtering-Correlation-Id: c9bf6f39-99f5-4b48-2c78-08df39c936d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|376014|23010399003|1800799024|6133799003|10067099003|18002099003|3023799007|56012099006|11063799006|261022075727099003|261021123027099003|261021135927099003|261021121427099003|261022105027099003|261009223027099003|261026140227099003|261102123227099003|261028144727099003|261026121527099003|261009221227099003;
X-Microsoft-Antispam-Message-Info:
	jnHSZTb6xfKaM+En1gVAcerF+U8kXRMdCYM6ca8Qk0OA9FZALL3jbasqayaKnSzOrfnbhn7UER7e/GtHYWJeNc4SLfz10ehNYyu600RnWtv45Yx7gtjBpUruiHg5hG5TL+Dmd4J4zgRerM6IlgNW8KYQKmLMwK5bBTHaY0u1/GBfmxyvyNSpc9Q0ZyT56z0l/KUjw1TNH3+d9zZPstvPIGWYybEEbMh1Tpkk3fsf3gN8gSBVQBxzz2GSQTXnoDS1FzyTQkabfTZ/TT1VfVnm+zi6y3lMUGZ777pEDsNpzJA0zwNSgiv9gRmtxSOW55xi9IRTLYGZXp3ayaRucrE1c9V5qe8Tj6OFdOyXTh3EAdzJDG5pZVHFANNVGOzuYRSUUNiBnzxWTyf+/JdesnYwVJ3//uYQ3HaVM1DgRVRfIuD0I47RnuY9GREXont3cpDBluQ1NNrz3Oi4XqrmuocJFyAnAHSlCgF3NEJClXGmVvcP1VcZtr65rgV/RKQA7wBG8sM+fmWqM1KMWfhzr0hSIKVgRq1jZ9p2Q34oaufYhbzQCJZuAgqsg9qhG9G+uWQTW06V08C+YJ6ffjpiE6OwC84kbezVK8KrwV5C85lmzBvN7hvd5ax2SnSnzfeNnJKlKItA679Z1kfxA8DPy5DYPpJDgWoW6UWINb262fOyg1QCmZ4z30XjnzYnFssHEp2Oqwg3C4AXIrlYso7R/RSs4Q==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(376014)(23010399003)(1800799024)(6133799003)(10067099003)(18002099003)(3023799007)(56012099006)(11063799006)(261022075727099003)(261021123027099003)(261021135927099003)(261021121427099003)(261022105027099003)(261009223027099003)(261026140227099003)(261102123227099003)(261028144727099003)(261026121527099003)(261009221227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	k8BYhdYROZ9bkeRorNuULnV8+JsAiujO8TNtPJuedfJSqjcVq+vX9HRgwWhm3aa9ntmQe7bLgqZL9Y7T4nMcNska7oCzIux9jsl2X1a/IzWZR6iyNCarfEOElXULDOQTdnBJ/Hj8ZZKGP1yOXFxzIyTEowQ5BbhS6G1lAsMi5Z7VmeTw/s//yRbp7Hi6WRIugONMGDmm3G5eV9rpFAvCkLpNpGNwjYmXKzehodUEy5d/FqFBJ9ictguADeyAmzh7wh9MJjq3BVoTBuTKfwTPguKnA9dOcGU5v3vuLry3IpvYf4M+mhb/fzsJoUVSXWYkaOORWHMpEHWdCtEoWbx4G4CGIr2OBti67HgcnOsYRplYg0npDXX1+swnXGlOKCo42pzGdriTTQNy1O/mS3wekgRlsC4gIOLASRmJya8cfHiJmFAFT89jqqEBJq05NPfV
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 16:40:48.0384
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c9bf6f39-99f5-4b48-2c78-08df39c936d1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000037AB.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9108

In a confidential computing (CC) guest, the hypervisor and any device
assigned to the guest are outside its trust boundary. The mlx5 drivers,
like most drivers, trust the NIC: they use the capabilities, events and
completions it reports to size buffers, index arrays and pick the memory
they work on. A malicious or compromised NIC can turn that trust into
memory corruption or information leaks inside the guest.

This series adds an adversarial mode, in which the mlx5 drivers treat
the NIC as untrusted. It is enabled automatically in CC guests, based on
cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT), with no administrator
configuration. Outside a CC guest the behaviour is unchanged.

The approach is to keep the attack surface small rather than harden
every path. In adversarial mode only the uverbs path is exposed: kernel
ULPs don't bind to the device and unneeded features are not offered.
The data path is owned by rdma-core, which must be aware of the mode.
When it opens a context, rdma-core declares that it supports adversarial
mode, and the kernel reports back that the device is in it, so rdma-core
validates what the NIC writes to the user queues. An rdma-core that
doesn't declare support is refused a context, so it can't use the device
while trusting the NIC. What remains in the kernel validates what it
gets from the NIC. A NIC can always stop working, so denial of service
is out of scope.

We believe that this series provides comprehensive security against an
adversarial device within rdma. Many teams at NVIDIA have been involved
in evaluating the various attack vectors and developing a comprehensive
mitigation, including AI analysis of the driver, fuzzing, and first
principles architecture review. It chooses to block and disable
functions that may open risk, and results in a reduction in driver
functionality rather than leave open potential security holes.

The series is organized as follows:

mlx5_core (patches 1-4)
- Derive adversarial mode from CC guest memory encryption.
- Filter the FW capabilities: start from none, pass through an allow
  list, and validate or clamp the numeric ones, failing the load on
  unexpected values.
- Add helpers to read log-encoded capabilities without an undefined
  shift.
- Add a forced health recovery, for faults the health sensors can't see,
  such as a NIC that keeps answering while forging completions.

Attack surface reduction (patches 5-8)
- Check the FW capability for every QP transport type, and accept the DC
  vendor flags only on IB_QPT_DRIVER.
- Keep kernel ULPs off the device by clearing kverbs_provider, so only
  uverbs binds.

UMR completion verification (patches 9-14)
- Verify each UMR CQE against a shadow FIFO of the posted requests,
  instead of trusting its wqe_counter. The UMR CQ is the only CQ the
  kernel polls.
- On a forged CQE, keep the UMR path failed and force the health
  recovery.
- Refuse the generic CQ poll path, which trusts the CQE.

Validation of FW reported values (patches 15-21)
- Set the CQ completion handler only once its poll context is set up,
  and ignore completion events for a CQ without one.
- Bound port numbers from EQEs and caps.
- Bound RQ/SQ states from QUERY_RQ and QUERY_SQ.
- Clamp the log_max_* shifts used for the CQ, QP and device limits.

Userspace interface (patches 22-23)
The GET_CONTEXT handshake: the new
UVERBS_ATTR_GET_CONTEXT_FLAG_ADVERSARIAL_SUPPORTED input flag and the
IB_UVERBS_CORE_SUPPORT_ADVERSARIAL core_support bit, also reported by
QUERY_CONTEXT.

The matching rdma-core series [1] declares the support and validates
what it reads from the NIC.

[1] https://github.com/linux-rdma/rdma-core/pull/1844

Yishai

Dragos Tatulea (2):
  net/mlx5: Add capability filtering in adversarial mode
  net/mlx5: Add macros for reading log-based caps

Yishai Hadas (21):
  net/mlx5: Add mlx5_trigger_health_work_force()
  net/mlx5: Derive adversarial mode from CC guest memory encryption
  RDMA/mlx5: Reject QP transport types not enabled by FW capability
  RDMA/mlx5: Require IB_QPT_DRIVER for the DC vendor QP types
  RDMA/mlx5: Derive mlx5_ib_adversarial_mode global from mlx5_core
    adversarial API
  RDMA/core: Suppress kverbs_provider for adversarial_mode devices
  RDMA/mlx5: Remove duplicate mlx5_ib_umr_context struct
  RDMA/mlx5: Introduce per-CQ poll_one hook in mlx5_ib_cq
  RDMA/mlx5: Add shadow FIFO infrastructure for UMR completions
  RDMA/mlx5: Verify UMR CQ polling against a hostile NIC
  RDMA/mlx5: Keep the UMR QP failed once a forged CQE is detected
  RDMA/mlx5: Block generic CQ poll path in adversarial mode
  RDMA/core: Set the CQ comp_handler after its poll context is set up
  RDMA/mlx5: Ignore completion events for a CQ without a handler
  RDMA/mlx5: Validate EQE port and GSI port before indexing devr.ports[]
  RDMA/mlx5: Validate firmware RQ/SQ state before sqrq_trans[] lookup
  RDMA/mlx5: Clamp log_max_cq_sz shift in CQ size checks
  RDMA/mlx5: Clamp log_max_* shifts in QP and WQ limit checks
  RDMA/mlx5: Clamp log_max_* shifts in query_device and ucontext paths
  RDMA/core: Report and enforce adversarial mode via GET_CONTEXT
  RDMA/mlx5: Advertise adversarial mode via ib_device::adversarial_mode

 drivers/infiniband/core/cq.c                  |  19 +-
 drivers/infiniband/core/device.c              |   8 +
 drivers/infiniband/core/uverbs_cmd.c          |   5 +
 .../infiniband/core/uverbs_std_types_device.c |  16 +
 drivers/infiniband/hw/mlx5/cq.c               | 220 +++++++++-
 drivers/infiniband/hw/mlx5/gsi.c              |   4 +
 drivers/infiniband/hw/mlx5/mad.c              |   2 +-
 drivers/infiniband/hw/mlx5/main.c             |  71 ++--
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |  24 +-
 drivers/infiniband/hw/mlx5/qp.c               |  68 ++--
 drivers/infiniband/hw/mlx5/srq.c              |   2 +-
 drivers/infiniband/hw/mlx5/umr.c              | 111 ++++-
 drivers/infiniband/hw/mlx5/umr.h              |   6 +
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 .../ethernet/mellanox/mlx5/core/caps_filter.c | 381 ++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/health.c  |  82 +++-
 .../net/ethernet/mellanox/mlx5/core/main.c    |  15 +-
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   2 +
 include/linux/mlx5/device.h                   |  20 +
 include/linux/mlx5/driver.h                   |   3 +
 include/rdma/ib_verbs.h                       |   2 +
 include/uapi/rdma/ib_user_ioctl_cmds.h        |   5 +
 include/uapi/rdma/ib_user_ioctl_verbs.h       |   1 +
 23 files changed, 957 insertions(+), 112 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/caps_filter.c

-- 
2.18.1

