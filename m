Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794935410;
	b=oC0iitm3Uvsu1uDMbQ6ZHMP9KcSQkr7t/HdNvaDQ4lRGJluF/hdDCaDarKc5lazdggJv
	 cyOEyOL/rA8g+Wj5+fTWzlZ43pItTeT3+/I3XbtlDbQVPXpX3e8A43Nj5pFTM8xI9aCeE
	 u4eLZuIRyRl/IGCwxudJXgiCfKTPkFqeUWrl4i4vCpQ/kbxy8RjRWwcd1sHrntowKvxoa
	 LxyVWQ7ID6/hlhdSOhjpnpNagxeRKonJ23u5D7BkVWEe/0TW8E5mU9HVQ31u1fVyexcdj
	 dyTyivXqWRy8lT6DKvcCvDR3zL0AkCGAFH3szncN6JEj5hpwDSuvCipuhZnYQHS39SA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794935410;
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
	bh=lcBLKOBMcb4V5oZ8x9/X8tg3uE3zc/6YyAP0jSw2AXE=;
	b=1z/AB1a4Ys0y7+2s3RQhTTtGPX/pGV34LuifAkBW45JGIvzHEc6R2cGQZ1lRfBlMpuwy
	 /Jbj/kQMOCQQUHdmokqyIXIDwQIn2fGJmKGmolJW9k4NczFRMQN+udZS7g4D6Wme6TqgA
	 +EAImLXaAIuWUqLuGNqoX2jPtyQiHX2eM/d504++mrDJ5xelQ9qJv89Z08pt5e8sGUGdP
	 vAPA2JAWLZJQZE4nN+NhRSuVBcughwMQyHAtDrn0GPXduR2R4DAv4pb3VT5GXFd3TsA2t
	 cx+7Q32pj6jY+0/LF1sQuTxZNscLJvyyuj1NZDz+MG7oMD9Aegi0H46hPHvOZta70Wg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="CAAxqA7/";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.41
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010041.outbound.protection.outlook.com [52.101.56.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A52F606A8B6;
	Tue, 17 Nov 2026 17:10:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1A52F606A8B6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=CAAxqA7/
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fUvaYydAB67VozCM+BYimJm8Xvb8y/e2AYMPnXFZ50P+SrQiEGnZUTZFElXDEeknuqsc0wz5GApaFo5ZrcvO+l/nDg3vWOihu053/Q34lQan9JXUBxmbbgwFZwnI6j35imXZK7bFjOaYZXooT8TYySe0Y9tnykz2OyxI+YYU+qLPhTgPHVS1BSY1VBuRZoNdmrrvow3Mp9Fr5i5YdQSlUpx8yWB9+WebiD+17onbtbYi5U3qk6EVruFNIcLDhGg9Sp8C9SBKO1zd+GFmiT8Rvc7SsllzDzIY1vIFzxT2u4esUxWV9fJ5Z4Gv8GN/iueC25sJKXDGJ07kOBJDqXYnYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lcBLKOBMcb4V5oZ8x9/X8tg3uE3zc/6YyAP0jSw2AXE=;
 b=ESmOOBmyQpibkGivOmU4HIB1SOCJhzSAUi3qqva2fcALV6VYuABxfyJiB9Z649gxxVeLRopqCD9JhsEzR/03YBcHQsOh/SM3EeGGgoTBBd/tuPf66S7hPyVvPkPmR40Tc6HFickRBCiHK9vjQkSQGk2eVasuD2kwlkSUraAlFR/IBJxtPnwjf5TAPjgloAP8K3E9CW92vfWRsIfX1vqgvOQ2AGcYwRo345xz1qpzJci+xc8prZTtKHQrKt129AzFn+NvGMfh97Dc9SCZ8hwpW03w7Sh3qVCsigxe0hVJHuIfskNLgX1cKmK4bdrPkUD8CKe1lw5Y8Hbh4QnDwUQ2Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lcBLKOBMcb4V5oZ8x9/X8tg3uE3zc/6YyAP0jSw2AXE=;
 b=CAAxqA7/FtcMJcS09dtXoTbWNfhkiFGSjrQmfQOFYad52ro2iaQh4kOqREeSiubCDJ/nFqTl3gj54e5MoVX4+OjEoJZWNoiw63XRLAk0qUkcgpBhRPdgQHeXiIVKTQ3qDq7L9a22bctZAJQIeXv/luYaaLp5hlhTv5Cv1lTxAE7pdSedn5ikFyDkMrajKn8c3Gcy9Y54scGHk34X36xT+azMcDpmpsJ/E3dvTk4ToTUia8NSZ4qxpq3QCesJZeiZib1/KTmOHIoDaH1Xb2B5W05oX0Qku4MkUMk8kCLHQ//xLadZW4tL7+ybUAuszB1zi2phibnDUjdondSYjZxJzQ==
Received: from SJ0PR05CA0010.namprd05.prod.outlook.com (2603:10b6:a03:33b::15)
 by MN2PR12MB4357.namprd12.prod.outlook.com (2603:10b6:208:262::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 17:10:02 +0000
Received: from SJ1PEPF00002327.namprd03.prod.outlook.com
 (2603:10b6:a03:33b:cafe::41) by SJ0PR05CA0010.outlook.office365.com
 (2603:10b6:a03:33b::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.6 via Frontend Transport; Tue, 17
 Nov 2026 17:10:01 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ1PEPF00002327.mail.protection.outlook.com (10.167.242.90) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 17 Nov 2026 17:10:01 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Tue, 17 Nov
 2026 09:09:43 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Tue, 17 Nov 2026 09:09:43 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Tue, 17 Nov 2026 09:09:39 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V2 rdma-next 00/21] mlx5: Adversarial mode for confidential computing guests
Date: Tue, 17 Nov 2026 19:08:53 +0200
Message-ID: <20261117170914.27410-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002327:EE_|MN2PR12MB4357:EE_
X-MS-Office365-Filtering-Correlation-Id: 07b64572-9fcb-4163-6917-08df44cd9daa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|1800799024|376014|23010399003|18002099003|6133799003|261009221227099003|261009223027099003|3023799007|13003099007|5023799004|11063799006|56012099006|10067099003|261102123227099003|261028144727099003|261026121527099003|261026140227099003|261021121427099003|261021123027099003|261021135927099003|261022105027099003|261022075727099003;
X-Microsoft-Antispam-Message-Info:
	2kSznD/06rC+b9aQmFM0UfRbHZ7Eq5QpQzuYE0m2tU3tFG1csqVuYAKOEuK9imlVUfW2oO4KkT70VB8SxDJzkEXqfJylbah7oL5q/G6SjeksGIXKbfVm1g+v5Sk4Brg0TM4j//EbkOPoh+0HJziX9tcZxEyZJgmjW8aem1JlT3wPCEl8ff6uI2S7rbDbsUEs2A9/D82FXkL533Wx4Uv+qn/Zwdf1+SBG3AeoVaVNzmov+VJ4vJR+sfzEblrGQKL2nJb77vvFLFHHcwJABqJvgHW4rV2xbQrhGqLDUQPCWSulcOu7/+7dpq1Z7bIawr+YgQGLM3lXh7a2rZt+bwK2Uq/alOzSzaASJI4yubzuTf+GL5FT5gzoexgUZgzQShycGpJX1AziPdfnbGoWKB+uUxLHdzauyfizkh9CA+9zvqPbkueDOSQbjmevkUOd1U2AVdxBYbrUBjLfbq67XSszSFQ2/nd2oKn9adDnQuDmpvFxgqwKn3qWLp4MlIB3ojFtWThy0CjkNMQp1W7USEp7HitDuGEJktL89w9+VHOdvnqy1Slq7++un+Bgt9qsIR9B3YEQfe4qPASWyNuolRZ11A8AEBgfoGngM8VlTwyXhRyaTFTbYn4aVgGfCslHREZmqLSbg9uSEwOD56A3CG3PWTycppXgritaHIWTB0wiGT+hqHFi9xZjB99q6okZ9vZtlaYbWyEl5nyM6cs+zsDBzQ==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(1800799024)(376014)(23010399003)(18002099003)(6133799003)(261009221227099003)(261009223027099003)(3023799007)(13003099007)(5023799004)(11063799006)(56012099006)(10067099003)(261102123227099003)(261028144727099003)(261026121527099003)(261026140227099003)(261021121427099003)(261021123027099003)(261021135927099003)(261022105027099003)(261022075727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	b3eKInAmibx8skN1dlfw5uh5/N2hfJddn+MbhHTVje5cM7uAhsZ9+NnruT2I97r3mcu2kStv6ksWuyrF1b1P7uvgFHC4QYpuV3jiJEnr0GUXyu74udNion4jmLAW2/u2grDx7HZRT7XRDNakn07G7yaS4Fy6e2LvLAHK+BxKt8valvNe3TPUXBzpuVtl+NAZaNX818rLf4TJXe8OWmaSSkEQydVllOK4kyZQ0vZOPyUeEK3aEHr7k4J0MZR7+wHD6FpDgEev/BPzgmcp7VpGayc473l3TUfaNQbdAxv87rkyKSacsBSNybEwrPSHE2Idnfk4RoTyvE+SWxwWC5WHm4az4E5dSLwvQQ7NxQx0Jr61sMVLXCqq/jJ7Ob9ehEuBmDE16y3B1DmMOqsivxLqvPmvRPbIqJ4lyvbpFTExzrdyiJCz0/fLXzGGQkGLRA2k
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 17:10:01.3809
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 07b64572-9fcb-4163-6917-08df44cd9daa
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002327.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4357

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
- Derive adversarial mode from CC guest memory encryption, and keep it
  per device.
- Filter the FW capabilities: start from none, pass through an allow
  list, and validate or clamp the numeric ones, failing the load on
  unexpected values.
- Fail the load when the FW reports fewer EQs than the async EQs need.
- Add helpers to read log-encoded capabilities without an undefined
  shift.
- Add a forced health recovery, for faults the health sensors can't see,
  such as a NIC that keeps answering while forging completions.

Attack surface reduction (patches 6-9)
- Check the FW capability for every QP transport type, and accept the DC
  vendor flags only on IB_QPT_DRIVER.
- Add ib_device::adversarial_mode, set by mlx5_ib from mlx5_core, and
  keep kernel ULPs off such a device by clearing kverbs_provider, so only
  uverbs binds.

UMR completion verification (patches 10-13)
- Verify each UMR CQE against a shadow FIFO of the posted requests,
  instead of trusting its wqe_counter. The UMR CQ is the only CQ the
  kernel polls, so the generic CQ poll path, which trusts the CQE, is not
  used in adversarial mode.
- On a forged CQE, keep the UMR path failed and force the health
  recovery.

Validation of FW reported values (patches 14-20)
- Set the CQ completion handler only once its poll context is set up,
  and ignore completion events for a kernel CQ that is not ready yet.
- Bound port numbers from EQEs and caps.
- Bound RQ/SQ states from QUERY_RQ and QUERY_SQ.
- Clamp the log_max_* shifts used for the CQ, QP and device limits.

Userspace interface (patch 21)
The GET_CONTEXT handshake: the new
UVERBS_ATTR_GET_CONTEXT_FLAG_ADVERSARIAL_SUPPORTED input flag and the
IB_UVERBS_CORE_SUPPORT_ADVERSARIAL core_support bit, also reported by
QUERY_CONTEXT.

The matching rdma-core series [1] declares the support and validates
what it reads from the NIC.

[1] https://github.com/linux-rdma/rdma-core/pull/1844

Changes in V2:
V1: https://lore.kernel.org/r/20261110134320.34408-1-yishaih@nvidia.com
- Patch #2: Keep the mode per device in mlx5_core_dev, set when the PCI
  function is probed. An SF inherits it from its parent function.
  mlx5_is_adversarial() takes the device.
- Patch #4: Reject only a negative count, as 0 completion EQs is valid,
  e.g. for an SF whose max_io_eqs is 0.
- Patch #9: Set ib_device::adversarial_mode from mlx5_core during
  capability init, instead of a mlx5_ib global, and read it in the
  mlx5_ib checks. It replaces V1 patches #8 and #24, and comes after the
  RDMA/core kverbs_provider patch.
- Drop V1 patches #11 and #15. mlx5_ib_poll_cq() checks adversarial mode
  once per call, and then polls only the UMR CQ, by its verifying poller.
  The generic poll path is unchanged, with no indirect call. Patch #12
  carries the rationale.
- Patch #20: Saturate max_res_rd_atom and max_total_mcast_qp_attach with
  check_mul_overflow() instead of min_t(), and cap max_cqe with min().
  Make srq->msrq.max a u32, so the rounded up SRQ size always fits, and
  drop the check after rounding.

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

Yishai Hadas (18):
  net/mlx5: Add mlx5_trigger_health_work_force()
  net/mlx5: Derive adversarial mode from CC guest memory encryption
  RDMA/mlx5: Reject QP transport types not enabled by FW capability
  RDMA/mlx5: Require IB_QPT_DRIVER for the DC vendor QP types
  RDMA/core: Suppress kverbs_provider for adversarial_mode devices
  RDMA/mlx5: Set ib_device::adversarial_mode from mlx5_core
  RDMA/mlx5: Remove duplicate mlx5_ib_umr_context struct
  RDMA/mlx5: Add shadow FIFO infrastructure for UMR completions
  RDMA/mlx5: Verify UMR CQ polling against a hostile NIC
  RDMA/mlx5: Keep the UMR QP failed once a forged CQE is detected
  RDMA/core: Set the CQ comp_handler after its poll context is set up
  RDMA/mlx5: Ignore completion events for a kernel CQ that is not ready
  RDMA/mlx5: Validate EQE port and GSI port before indexing devr.ports[]
  RDMA/mlx5: Validate firmware RQ/SQ state before sqrq_trans[] lookup
  RDMA/mlx5: Clamp log_max_cq_sz shift in CQ size checks
  RDMA/mlx5: Clamp log_max_* shifts in QP and WQ limit checks
  RDMA/mlx5: Clamp log_max_* shifts in query_device and ucontext paths
  RDMA/core: Report and enforce adversarial mode via GET_CONTEXT

 drivers/infiniband/core/cq.c                  |  19 +-
 drivers/infiniband/core/device.c              |   8 +
 drivers/infiniband/core/uverbs_cmd.c          |   5 +
 .../infiniband/core/uverbs_std_types_device.c |  16 +
 drivers/infiniband/hw/mlx5/cq.c               | 275 ++++++++++++-
 drivers/infiniband/hw/mlx5/gsi.c              |   4 +
 drivers/infiniband/hw/mlx5/mad.c              |   2 +-
 drivers/infiniband/hw/mlx5/main.c             |  78 ++--
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |  23 +-
 drivers/infiniband/hw/mlx5/qp.c               |  68 ++--
 drivers/infiniband/hw/mlx5/srq.c              |   7 +-
 drivers/infiniband/hw/mlx5/srq.h              |   2 +-
 drivers/infiniband/hw/mlx5/umr.c              | 113 +++++-
 drivers/infiniband/hw/mlx5/umr.h              |   6 +
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 .../ethernet/mellanox/mlx5/core/caps_filter.c | 381 ++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  |   8 +-
 .../net/ethernet/mellanox/mlx5/core/health.c  |  95 ++++-
 .../net/ethernet/mellanox/mlx5/core/main.c    |  17 +-
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   2 +
 .../mellanox/mlx5/core/sf/dev/driver.c        |   1 +
 include/linux/mlx5/device.h                   |  20 +
 include/linux/mlx5/driver.h                   |   4 +
 include/rdma/ib_verbs.h                       |   2 +
 include/uapi/rdma/ib_user_ioctl_cmds.h        |   5 +
 include/uapi/rdma/ib_user_ioctl_verbs.h       |   1 +
 26 files changed, 1041 insertions(+), 123 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/caps_filter.c

-- 
2.18.1

