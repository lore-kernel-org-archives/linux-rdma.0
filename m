Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11021099.outbound.protection.outlook.com [40.107.208.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856C634FF78
	for <linux-rdma@vger.kernel.org>; Mon,  3 Aug 2026 16:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.99
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785773465; cv=fail; b=YU5uEM7Od8RSGLyQyBbI3fYxdEe8IsEuLsnQ7nsc3/N7HRZJZiwxYJZ/qQoyqCZNCAC8CD82OKM1hGiX8PSs3eOmcXxoNj8iXAVDZD4L59VTOV3GEt0EQZFY95eHi81EB2tf2dLYhw+gIO5oT5he6TgRv1lMU8vlMzlxxZVMusE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785773465; c=relaxed/simple;
	bh=xyWvNk5Kb7jmiBQzJqy6purbpjsPHfYJLb6kDgWczeU=;
	h=Subject:From:To:Cc:Date:Message-ID:MIME-Version:Content-Type; b=BxNlFb4N23vkw9v4rurhfr4TqAU6VXXeklVLaz9bW81/2Nzsqn0K+xWJ17xKXLAklmDJ+B1f0utUFIn6/EP9dfUU3mV3zQSm8xVqIuNjbzqx+ZB2Mf5Bo9IVqwRlR+4v5sJXgqmjLpHyhscUD8ksWxHW/vVnaj1XhzHocFPsB4E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cornelisnetworks.com; spf=pass smtp.mailfrom=cornelisnetworks.com; dkim=pass (2048-bit key) header.d=cornelisnetworks.com header.i=@cornelisnetworks.com header.b=fESMMido; arc=fail smtp.client-ip=40.107.208.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cornelisnetworks.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cornelisnetworks.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cornelisnetworks.com header.i=@cornelisnetworks.com header.b="fESMMido"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VfvXcjX1bobLz4a8+PfQA6C3j5Q8BibT7jbIy81Ia4qpr1jlFa2di405SPB+Hv5RIutxKlZPD01KrtEfnxEHzYJ4f588oRiDhMnfI9i03rEuZ1ETpy54CCTfLr+H/HeEdDoi37m+gkXVfMpJzhT199yo+n5hZnY2SY07Befu3sYC2nJZ1cInU4X9+fSgy5esG8KINaZzvCigq01NPY/9ADyl/GDQomNvKzgAMRhz6fymG3SBdYL9nOlYxU3hqXHcKfN5yETB0OBDCqii++KwYEezEXJjsycLl9nc0i+6I5WXGaZ1vSvY2HrOdDKTLTz/ut0h4LBBd9B1BB/bUKADlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n1ncHjH31xbZ0Sm5h6yNUYEo/ZHXZAqWDy4DfKubDg0=;
 b=XYaKOvr6l6jtKITPtIBE2+SwStwpJ59aZDPiAe+kNj3UMwIhZVruO1E+JBFMCdYK+/K6MzDNiYAtQULgN1NwG98oJNvK2gShYK1btNTTusBz6sjaLo7b7RGP8HBHAsPpS77HQ0n5X26GId0v1iRp7bZQ+57PbNAVq5KUFWcRsuUGxiaze0YJ9fKDW5DmSv5jRas9IvnV8ciYHKfN21CuzPTKGc3BjSXyVTUfuMtrEt647XQNKT4ofM+u/1iMYoHE8w722Hol5NQMxkDWo8JNnFlV24CZNPeDW5+9zFcGo7pmXxekNdzhBptjPzsci+DaaO+hWkbWSfdInWSK0bqIiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 208.255.156.42) smtp.rcpttodomain=kernel.org
 smtp.mailfrom=cornelisnetworks.com; dmarc=pass (p=none sp=none pct=100)
 action=none header.from=cornelisnetworks.com; dkim=none (message not signed);
 arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n1ncHjH31xbZ0Sm5h6yNUYEo/ZHXZAqWDy4DfKubDg0=;
 b=fESMMidoD0mXbe8iTg8Pz/RBMM3vV6OweLUwUv/po9hTuKEvGwHVr4prGI+ADsDQ4zmvx7KcOR1AXDlwKLBwadTxUyH3Iheye6TwJ1fXVxX+sKqaJybDMg8z0Q8Nwk3ajOEmkV+3rha+uXH1vcNTyUZ6UONT2UE4l6goQMgfEJ8upQnLqtXtfv8r/s1JmVrat1WE1vdHh84uDIDZ6lGubBXygP4S6rfNjsBi/yitAkOuDQcFwQVWVFSkbJH/uB9dSm0iufyBYVdXH4O/BKpzs5p6JXdyIa45nZhqKA0AEippVH0jjI1vpiUDNO7U0F5p5Mm3lpPTqBZLLBZE3olcpw==
Received: from DSSP220CA0014.NAMP220.PROD.OUTLOOK.COM (2603:10b6:8:3d3::7) by
 CO1PR01MB6664.prod.exchangelabs.com (2603:10b6:303:d5::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.18; Mon, 3 Aug 2026 16:10:53 +0000
Received: from DS2PEPF00003447.namprd04.prod.outlook.com
 (2603:10b6:8:3d3:cafe::7a) by DSSP220CA0014.outlook.office365.com
 (2603:10b6:8:3d3::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.18 via Frontend Transport; Mon, 3
 Aug 2026 16:10:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 208.255.156.42)
 smtp.mailfrom=cornelisnetworks.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=cornelisnetworks.com;
Received-SPF: Pass (protection.outlook.com: domain of cornelisnetworks.com
 designates 208.255.156.42 as permitted sender)
 receiver=protection.outlook.com; client-ip=208.255.156.42;
 helo=cn-mailer-00.localdomain; pr=C
Received: from cn-mailer-00.localdomain (208.255.156.42) by
 DS2PEPF00003447.mail.protection.outlook.com (10.167.17.74) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8
 via Frontend Transport; Mon, 3 Aug 2026 16:10:52 +0000
Received: from awdrv-04.localdomain (unknown [10.228.212.218])
	by cn-mailer-00.localdomain (Postfix) with ESMTPS id 2155B1D6F7F;
	Mon,  3 Aug 2026 12:10:52 -0400 (EDT)
Received: from [10.228.212.218] (localhost [IPv6:::1])
	by awdrv-04.localdomain (Postfix) with ESMTP id 0FA991810DF01;
	Mon,  3 Aug 2026 12:10:52 -0400 (EDT)
Subject: [PATCH 0/9] RDMA/hfi2: Sync with upstream hfi1 fixes and cleanups
From: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
To: jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org
Date: Mon, 03 Aug 2026 12:10:52 -0400
Message-ID: <178577337105.1793053.12662894969464495064.stgit@awdrv-04>
User-Agent: StGit/1.5
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF00003447:EE_|CO1PR01MB6664:EE_
X-MS-Office365-Filtering-Correlation-Id: d6d141fa-48b1-45c2-8ad2-08def179cab8
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|23010399003|36860700016|56012099006|10067099003|6133799003|55112099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Tx6krxhtXJ1WSLDrZVzhGCfjAwN6OJ90HoMDEz5pB4qS7oPmbWmKFmD2CzvWbfWjxtWpKyXD3LOuMj2LcNYp4BXXmyhro4Zf73aaUUf8/gKOhnqj+Sdce8Fg+kM2QzicjaLSnPzyw81mzrtlgVtdOw2urlajkgpwceFzq8+cXCgb3AhkyopZFXOQAqgj6U9QfaB9xKWgQN8adImPsc4SAZezcyrykvT9Yqr9ENLld6bJiwzCttVxf3w4/n2vDXZQshaczDoBRWRWfaSIzkIAEqbkG2d4fYejM3aIlAnVnaR0SfL2uKUqrmJ6eiB2zKB8i++R0ub+zqnSqnCT/dXkarJHeyou+v0oTNpRqFlxxRA80zk7A6GtXSt0xxXfXWXv8FcxGUnzBE13bIUE4WyFaUOLjXpzpaK/rBFWqd2OLUo5uKidb/GbTiM2uzI3i8CXKTi0FJYNXJMgjc69vhx9yxgZbxjt/zwd0biqy92FjXgtJP1AW9EvrWrUVJt4eSKQ8myOTwb5bqAKpT2JvYxa2P8yp/DbEOzRAdhRK+cXurOzMGYrtcWrphh+xWxgo5wtQZ9aN4IafiMEWTd3OXqaxpPkEHmwnRJPXNsG/G96nbOdKGz7NG9odDrhSUQ4qqRj+YawQeBvz3xgmDpdJKed0rf7Acc7hr377wMjvi1FyPfex6sLBLeVwPjQAB25eaJKEKVtaqfcsZCe66Pr2C/xVA==
X-Forefront-Antispam-Report:
	CIP:208.255.156.42;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:cn-mailer-00.localdomain;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(23010399003)(36860700016)(56012099006)(10067099003)(6133799003)(55112099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	4M4oOES0tU15aYCpPOyePH/psH2DFlkif/w1l1hJAqi5A+ssi7gm3RVDG5yC2bM3O6UnroU9waDV1bhGM4p0vnIW9R6EL0GzKG2dbBe5QaKffJmLnVDm0H/gc+OnIShS75X4M63JYzr6tYom4VhSX/p5uvjLm60po1Wix4uHfvI5nTDhME0bWLrQKV4ECLkDoV9iV1sK0SyfnOnWE6gNULEQeM49VEyc4POarczs/kiWubUqJe0kgGM+OnB+pJ8bQuTlfgpXhAXe6rj4It90aPloYrptVyIGq/umxIon4KGe6E0Ggjs7ciPsWKVINYrEol8K2+zdatIZtPg7n1oV8S2mS5daWqVSvgZmI7w8EwWbdQ2Uhq5WMJ4da5glewJP6O3WnU2QsDTE912YP44eMy4I+eIRtc5U+qFhK9mDbpFBWwNrcHnZFOZcc9zy4pkP
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2026 16:10:52.6395
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d6d141fa-48b1-45c2-8ad2-08def179cab8
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a;Ip=[208.255.156.42];Helo=[cn-mailer-00.localdomain]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR01MB6664

This series ports relevant upstream fixes from hfi1 to the new hfi2 driver.
Since the original hfi2 submission, several fixes and cleanups have landed
upstream for hfi1, primarily focused on PCI probe error unwinding and
resource management.

This patch series adapts the applicable fixes for the hfi2 architecture.
The modifications in this series are based on the following upstream hfi1
commits:

1. 091c6162c022 ("RDMA/hfi1: Propagate sdma_txinit_ahg() errors")
2. 2e3809ad8911 ("RDMA/hfi1: Preserve unit 0 on allocation failure")
3. d43b1c17f9e1 ("RDMA/hfi1: Stop flushing the global IB workqueue")
4. 22113f3f55a1 ("RDMA/hfi1: Remove redundant NULL checks in create_workqueues()")
5. 76b48a70b16b ("IB/hfi1: Fix potential use-after-free in PIO and SDMA map teardown")
6. b9cb5e81f7d9 ("RDMA/hfi1: Pass PCI device to hfi1_pcie_init()")
7. 4ebd241071af ("RDMA/hfi1: Drop device data from hfi1_validate_rcvhdrcnt()")
8. 9f674ba674a0 ("RDMA/hfi1: Allocate device data after PCI initialization")
9. bb18740b302f ("RDMA/hfi1: Initialize debugfs after probe completes")
10. e26c48cf23a4 ("RDMA/hfi1: Align probe error unwinding with device removal")
11. adc09d7fbbb9 ("RDMA: Remove outdated comments referencing hfi1_destroy_qp()")

We performed a deep-dive analysis of Leon Romanovsky's 12-commit "clean
init one hfi1" series to determine applicability to hfi2. Commits 6-10
above are the members of that series that apply to hfi2's
probe/error-unwind path; because they interlock (each depends on the
pdev-based signatures and reordering introduced by the others), they are
folded into a single "Align probe error unwinding with device removal"
patch in this series rather than being split 1:1.

The following upstream hfi1 commits from that same series were analyzed and
deemed NOT APPLICABLE for hfi2:
- af9117d02f50 ("RDMA/hfi1: Remove redundant PCI device ID validation"):
  Not applicable. The check is not redundant in hfi2 as it does chip_params
  dispatch mapping between wfr_params/jkr_params.
  - 0d5618c1b2fc ("RDMA/hfi1: Create workqueues before device
  initialization"): Moot. hfi2 already implements this correct ordering.
- 8e17e101e04a ("RDMA/hfi1: Free RX data on late probe failure"): Moot.
  hfi2 already frees RX data transitively via cleanup_device_data().
- 9bab31776ae6 ("RDMA/hfi1: Defer device creation until probe succeeds"):
  Not applicable. hfi2 has no legacy char-device creation to defer; it uses
  standard IB core device registration only.
- 297b5b747a0a ("RDMA/hfi1: Remove unused non-user-accessible device
  class"): Not applicable. hfi2 does not contain the device.c/device.h
  files or any class/cdev registration of this kind.

We also evaluated 56521f587704 ("IB/hfi1: kzalloc to kzalloc_flex") for
applicability. In hfi1 this combines a struct's separate psets kcalloc
allocation into a single kzalloc_flex() call using a trailing flexible
array member. In hfi2, struct tid_user_buf is embedded as a non-trailing
member of larger per-backend wrapper structs (e.g. struct
system_tid_user_buf in tid_system.c), so a trailing flexible array member
cannot be added to tid_user_buf itself without a broader multi-backend
restructuring. We are treating this as not applicable to hfi2's current
architecture rather than porting it as-is.

---

Dennis Dalessandro (9):
      RDMA/hfi2: Propagate sdma_txinit_ahg() errors in user_sdma.c
      RDMA/hfi2: Preserve unit 0 on allocation failure
      RDMA/hfi2: Stop flushing global IB workqueue
      RDMA/hfi2: Remove redundant NULL checks in create_workqueues()
      RDMA/hfi2: Fix use-after-free in PIO and SDMA map teardown
      RDMA/hfi2: Pass PCI device to hfi2_pcie_init()
      RDMA/hfi2: Drop device data from hfi2_validate_rcvhdrcnt()
      RDMA/hfi2: Align probe error unwinding with device removal
      RDMA/hfi2: Remove stale hfi2_destroy_qp() comment


 drivers/infiniband/hw/hfi2/chip.c      |  14 +-
 drivers/infiniband/hw/hfi2/chip.h      |   2 +-
 drivers/infiniband/hw/hfi2/hfi2.h      |   3 +-
 drivers/infiniband/hw/hfi2/init.c      | 183 +++++++++++--------------
 drivers/infiniband/hw/hfi2/pcie.c      |  22 +--
 drivers/infiniband/hw/hfi2/pio.c       |   4 +-
 drivers/infiniband/hw/hfi2/qp.c        |   1 -
 drivers/infiniband/hw/hfi2/sdma.c      |   4 +-
 drivers/infiniband/hw/hfi2/user_sdma.c |   8 +-
 9 files changed, 114 insertions(+), 127 deletions(-)

--
-Denny

