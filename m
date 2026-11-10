Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.65
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794318255;
	b=es1b8FmF+/ZidtRtWaOt54qjksV+U/exQcJtuUEBSmIyZgKgGoL/r7IUI2agZPeJgU8D
	 s0Ny5QK9UZAbchWsgOX16xKXkDkkpt/Ts4UzJJEOtNq9IwZGZEMTSUgHQYCVDQ/cjBCbw
	 FLiBMyhjqGQtKf0qoNI7V0SOCpgbbkxd+RtL4FTQHTuYDyzu9LeP/KjsV9tRiJfwENorE
	 OEEuhLowDofTkgSQ3y5AeFhYvp5OY5ON/mdMvzU8i4GeW8eSzytBoNiOexA5fapR9b76x
	 GuloTWRruubwzMYl/l5mWSsrCMvypWtYG9GVXWUg+IMaXa2UOM+QW+LiK65DPvzYvtw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794318255;
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
	bh=lR5zC5zk+n4JiXN1N+45v6kzbRQtFKgNaOrNkjdxqSE=;
	b=JSt6MdPKp4XdqUCr+2QPs74Ov//+PsIc+unwnpqIMGDb7Tbchh7yz962akzuXkYxIOcw
	 gGVLxqFXyBHICi0T+fn65sRKp/9SmqotLUcVzv3rrYdY4Ex3iFqhye9KUk2XRrO+aqbvg
	 eDixaLNKanWr3+Yb5BFiDsrnhKwhsDlEOuJGIMX0hGW0Yewt5SFSmcN9H5l5Op9ATv2ti
	 iXR27sofq42mF1LNAzMwFBNmru/Oe1kwifODwCygsrbET9qSseqjqjEf2vD/BnTRggaWF
	 fsnOBlB9CFhmuhi3sIC04eCOwztK8AmB8MyEa94x3BpWaFjFK0U/YwG0m9/S/mATtGA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ace6X4YY;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.65
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011065.outbound.protection.outlook.com [52.101.52.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42C11606A330;
	Tue, 10 Nov 2026 13:44:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 42C11606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ace6X4YY
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yeQxbXv+O9HBU3Tg40Pjs2nVKi618FuTSPOl4t4GUBmXPO5HuFe9scwIN7dhWxqlMHh9ZKHlp2LYZjC+dlxrWhmJsFfDiJRBWGcZSM2b10WFmZSo/tj9TvnsjQxui415kbs1BvGjxefZhm2v8rQnX0mODL8MsjkpCO4jtQvnOKEVYMfsoK+IfqE0mt6yOUNeDn+V+RlS+ncwwTk5KQ02zvO6jI1QgsxY1ZE5cpQ6kR9hxbhYz/zMmN6n1IFtQOOrg30YmK211WLBloV0b9ihxHpvcHMvwV+PeW2zk66Md00lbSuFJZsa+DDbzHA9TXwFdNKT9fZ9KOjjRHYbKyNUVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lR5zC5zk+n4JiXN1N+45v6kzbRQtFKgNaOrNkjdxqSE=;
 b=rAAxIzUYu1YpU2g4VkR6W49JIToXehg1KWLX6estBXTKf+9eoQavxAnrNfgGcdTdSzmdSMQOd4fnzewKHRuzK9XyPjDKGxoZEmukpy2mzkl8eRA5iTKCn3ki9ThglXaJc3FWON9Dv9iM5dc3zqahykApQIbESQmdVLk+HcYkH2TokIcA/S0hOuhpp/iBuh/nZ8CW5DsCNew3O6rblejPgnZqe1kgX5m59CJ77QSvMBmyps7lqeJhIvKpW7Ec06wajA2Ox0C3VBnFZtfvlvuZoBFm0x3DNrtPi3vpHYUQL8SwZfu/Ra35H6telPvMUEgq9nT7pNWpk7ipl7rwBxPBCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lR5zC5zk+n4JiXN1N+45v6kzbRQtFKgNaOrNkjdxqSE=;
 b=ace6X4YYT2WzsXprED3xwc3ahq9J/vJyG+y64Vqrs+2j26H2q+PRRTMBLLq7Ruu0Tdr2tIb4twRzqJUnZAPfm4PGpUfoRo/SGc2gEswmSIEeqVcPPrB8jQzznF3Z8TOfM4/x2/G+qKjvJRaw4N4n53XAWNY/nmlvncjiqZZ6g1JYumg5g+0466EGXS2CjUUtx0GQizGmwscMCnfjvG4zDFsHHA+JQQQSD5QXpXA+Z0rUJ6MeW9RgceE0lxPozArLoHC2aNPxZpG/xPjVTiDE/tWOcmQqy9XqS0dFZT4IqC4uhSWpwe2pv2Ba9M/cUUrF6GX0tftpsWg/MgTN+Xs32w==
Received: from PH7P220CA0030.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:326::6)
 by LV2PR12MB812143.namprd12.prod.outlook.com (2603:10b6:404:300::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Tue, 10 Nov
 2026 13:44:09 +0000
Received: from CY4PEPF000392D6.namprd03.prod.outlook.com
 (2603:10b6:510:326:cafe::42) by PH7P220CA0030.outlook.office365.com
 (2603:10b6:510:326::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Tue, 10
 Nov 2026 13:44:09 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF000392D6.mail.protection.outlook.com (10.167.247.116) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 10 Nov 2026 13:44:08 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 05:43:49 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 05:43:49 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 10
 Nov 2026 05:43:45 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V1 rdma-next 00/24] mlx5: Adversarial mode for confidential computing guests
Date: Tue, 10 Nov 2026 15:42:56 +0200
Message-ID: <20261110134320.34408-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF000392D6:EE_|LV2PR12MB812143:EE_
X-MS-Office365-Filtering-Correlation-Id: 4690e7bf-b654-4bfd-404d-08df3f30b22f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700016|23010399003|376014|18002099003|6133799003|10067099003|3023799007|13003099007|5023799004|11063799006|56012099006|261102123227099003|261022105027099003|261009223027099003|261022075727099003|261021123027099003|261021121427099003|261021135927099003|261009221227099003|261026140227099003|261028144727099003|261026121527099003;
X-Microsoft-Antispam-Message-Info:
	VCK3IgK/yiD9VjKW1w3EcAvFoD0kxwsWyZg6nsDieBu0nOwu2sXlc/ZZlWzMYcATqtkrp4G0lCXxHJKJEismJVCIxV1GkI1mj4Vy5YowJ9xmxo1fXS79jVYkHcGLTP1TKoOF2tofrn/swBta6Afk0G/04gPh/xgfZ0uliwk8AEzEPIOiOTkPSWnnn/QVYHT6SeeUyCF5j4AUfEik5jF2okAsWdZzMYevs/CB0awzq58e6MS1PkVn7LUTqSljTnSBF07S7by0/kiTPYwmRcp/vbADPhBYW3Z0ZoYLRXwwqv3FQTa3niNh7HO528nWqjQVsVQ16Tie9sk+qkPOUsC1fvXNGMByhCewVV5UbH+2gWeU3UYNbHG3Iry4SFso6H+QX1daX/dbj2n24y0ThGJqNOAJyWxSiepR6xWV+gI7YVzassbyYuQVefzWZx8yylTn+qXnCRMtd6JGOb6L4pRP0aIZqUyB7pJZgcDZaAxiYrWgvTJ0TWz8p9rb/TVo4ZDvC1ywAnQ+nxqb0HwKfIOhLFyO9KMZ6M0ree/NmxjyUuqS/eOptU/COLANbeShVXIPBmDJrm76f3UEsfwAx1Rdngrxo5ExsrfmrVBEkQ/xkN4TXhSBeeZpnMNOpG74RLW+z7/nS1K8umomTdLnr2PQzTPIVOX+N20/Rg3xYexjUPkBOvEwBKCgW2H9vg3FHb6pzd4++gSmrIRLA5A0+PFvfg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700016)(23010399003)(376014)(18002099003)(6133799003)(10067099003)(3023799007)(13003099007)(5023799004)(11063799006)(56012099006)(261102123227099003)(261022105027099003)(261009223027099003)(261022075727099003)(261021123027099003)(261021121427099003)(261021135927099003)(261009221227099003)(261026140227099003)(261028144727099003)(261026121527099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	uBhX0rKH+qJ+ZFaZTwqIbmpjSibUuZII5JVPZSJvYD8HvZFWEhQaJ8k6syNv6DpMYXGfTctgAwxFtY0TW4CS+XGhxKQlWLAJ4tFUV7y1fZDhaPN0ET/lwPK/uJsutZCt9mvR1NOpkhpejyq7Rf+eDPdku31nfscDGF4uYPrOqzOjt808qZfQcY85gDsdAwyxY5yhkQwzeWOrDalygdddnRbe3o7yfym+SjEnpzOO8DnQPxPqytoNMphXsQ9R0AbnDbZR1+8FwaO3l3NngZff10XZ8DI9fV7GpD2KVgdBCQdFQDG6l9iUdkTpAIbKfQPsjI/BVwPgp5Vu68ldAeOnrlh+b5+GlDXe2riYgsxTejplQzgfcSJ7j7hEO1d0C1g/KEkpwoOgbiyrDMqpRY7FCZnndhH378ypAIOyNuMN7vu1W16SOaFh2ecPGKVZFokP
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 13:44:08.9337
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4690e7bf-b654-4bfd-404d-08df3f30b22f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF000392D6.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB812143

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

mlx5_core (patches 1-5)
- Derive adversarial mode from CC guest memory encryption.
- Filter the FW capabilities: start from none, pass through an allow
  list, and validate or clamp the numeric ones, failing the load on
  unexpected values.
- Fail the load when the FW reports too few EQs to leave a completion
  EQ.
- Add helpers to read log-encoded capabilities without an undefined
  shift.
- Add a forced health recovery, for faults the health sensors can't see,
  such as a NIC that keeps answering while forging completions.

Attack surface reduction (patches 6-9)
- Check the FW capability for every QP transport type, and accept the DC
  vendor flags only on IB_QPT_DRIVER.
- Keep kernel ULPs off the device by clearing kverbs_provider, so only
  uverbs binds.

UMR completion verification (patches 10-15)
- Verify each UMR CQE against a shadow FIFO of the posted requests,
  instead of trusting its wqe_counter. The UMR CQ is the only CQ the
  kernel polls.
- On a forged CQE, keep the UMR path failed and force the health
  recovery.
- Refuse the generic CQ poll path, which trusts the CQE.

Validation of FW reported values (patches 16-22)
- Set the CQ completion handler only once its poll context is set up,
  and ignore completion events for a kernel CQ that is not ready yet.
- Bound port numbers from EQEs and caps.
- Bound RQ/SQ states from QUERY_RQ and QUERY_SQ.
- Clamp the log_max_* shifts used for the CQ, QP and device limits.

Userspace interface (patches 23-24)
The GET_CONTEXT handshake: the new
UVERBS_ATTR_GET_CONTEXT_FLAG_ADVERSARIAL_SUPPORTED input flag and the
IB_UVERBS_CORE_SUPPORT_ADVERSARIAL core_support bit, also reported by
QUERY_CONTEXT.

The matching rdma-core series [1] declares the support and validates
what it reads from the NIC.

[1] https://github.com/linux-rdma/rdma-core/pull/1844

Changes in V1:
V0: https://lore.kernel.org/r/20261103163949.1554-1-yishaih@nvidia.com
- Patch #1: Do nothing in the forced work when the command interface is
  down, as the path that brought it down owns the flush and the
  recovery. Fall back to force teardown when fast teardown fails, as
  mlx5_try_fast_unload() does.
- Patch #3: Bound log_min_mkey_entity_size by PAGE_SHIFT, and the max
  mkey entity size caps by BITS_PER_LONG - 1.
- Patch #4: New patch from Dragos, fail the load when the FW reports too
  few EQs to leave a completion EQ.
- Patch #7: Add a Fixes tag.
- Patches #8, #12, #15, #21, #24: Commit message improvements.
- Patch #13: Accept a non-flush UMR error CQE only by moving the UMR
  state from ACTIVE to RECOVER with cmpxchg, and treat it as forged
  otherwise, so a single recovery runs at a time. Narrow the
  mlx5_ib_cq_stop_polling() kernel-doc.
- Patch #15: Fix the comment, the uverbs POLL_CQ command doesn't reach
  this path.
- Patch #17: Cover kernel CQs that are not set up yet. In adversarial
  mode, kernel CQ events are ignored until the first arm, published with
  release/acquire, so a weakly ordered CPU can't see the handler without
  the poll context. Renamed from "Ignore completion events for a CQ
  without a handler".
- Patch #18: Move the port check into handle_port_change(), before
  devr.ports[] is indexed, and drop the now dead check in
  mlx5_ib_handle_event().
- Patch #20: Use check_mul_overflow() for the kernel and user CQ buffer
  sizes.
- Patch #22: Cap max_cqe to the largest CQ size the create path accepts,
  and reject SRQ sizes and buffer sizes that don't fit in an int.

Yishai

Dragos Tatulea (3):
  net/mlx5: Add capability filtering in adversarial mode
  net/mlx5: Catch too low max number of EQs
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
  RDMA/mlx5: Ignore completion events for a kernel CQ that is not ready
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
 drivers/infiniband/hw/mlx5/cq.c               | 266 +++++++++++-
 drivers/infiniband/hw/mlx5/gsi.c              |   4 +
 drivers/infiniband/hw/mlx5/mad.c              |   2 +-
 drivers/infiniband/hw/mlx5/main.c             |  80 ++--
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |  26 +-
 drivers/infiniband/hw/mlx5/qp.c               |  68 ++--
 drivers/infiniband/hw/mlx5/srq.c              |  14 +-
 drivers/infiniband/hw/mlx5/umr.c              | 111 ++++-
 drivers/infiniband/hw/mlx5/umr.h              |   6 +
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 .../ethernet/mellanox/mlx5/core/caps_filter.c | 381 ++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  |   8 +-
 .../net/ethernet/mellanox/mlx5/core/health.c  |  95 ++++-
 .../net/ethernet/mellanox/mlx5/core/main.c    |  15 +-
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   2 +
 include/linux/mlx5/device.h                   |  20 +
 include/linux/mlx5/driver.h                   |   3 +
 include/rdma/ib_verbs.h                       |   2 +
 include/uapi/rdma/ib_user_ioctl_cmds.h        |   5 +
 include/uapi/rdma/ib_user_ioctl_verbs.h       |   1 +
 24 files changed, 1035 insertions(+), 124 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/caps_filter.c

-- 
2.18.1

