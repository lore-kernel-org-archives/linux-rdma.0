Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013026.outbound.protection.outlook.com [40.93.196.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9123E35DA75;
	Sun, 26 Jul 2026 09:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785058192; cv=fail; b=uZjZ/sNejddvzdFO4hN2WQRVJf1hHC8WR3UWfbW0N0u7AvRPQ7VggALyKRWEOdKTycjm+mlrLRAz/+Zouy30mttMQp1DruvXmF1ba3dmPKffnx0q6Fu79C+enN50BOY5Rwbm9A5M+CCXYLA18IdYY1bPhGuLQsVVLhgbxVQZj+4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785058192; c=relaxed/simple;
	bh=WTUQ0q/tq3y1QxOzv/MHyUDp0sMFkCnidSYBUsX2AKE=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=HDVN6zJQGSGtpqci6vIajFobamxD9hIgMOyVh6o9p1t8Ip6Nqtx8qsUAk7DzO4ZFyD+yOatvr9hoqE01jSwrSyJEmLyHePtYmPJvDSg2RxK+sG6WS2a8HY9OULEeGN8ya7w0wBteqW7ISOao5L00Fq2H361gC/C8udfsxUHzyMc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=P3LxUWGB; arc=fail smtp.client-ip=40.93.196.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="P3LxUWGB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q65cWAjC9DYdCQyu/tizxhAW/S0qXspcDcsQIV7GZ/N8mZ146j9+WLlSSe6DLtMzp/QXnSUpSPGL6vmlpQLU20HOgw70A24n0FR6B2kQIeD6I3hpytptcjaoEWhcUnqvmgYjlZQmPtMmb7p7Gf8KK7o+e7+KJ/8gjGPjKVRVrfu9R/+EiyFG+lIT7vsp26vJcX/kMflhpJsy9CVxaF4E3Ly5edx1sqXTKThPVYLHcsO4qYGw29VFja5TmCDeU6aV3e5Nk180NldzMmHQN9hxkH3s1uTDPJFg2DQ8Rk7Y4/8ZecpxVWCeHUK/Os3ywxFXnYm1ydob80BW90C0/6m6RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oXs8emVZgpjuX5WfO6zuwZzgmtCWI4fARV91aq6vTs8=;
 b=K8BSDT6p+7KsSW26EYnQB7WimMUtx3S3CZr3RyM3qlcCf58zL6FsPvXo3pQMl6GHm+TsDZODb3nKIBYeplZ6hkQ/4e1cK7BqTHOOQljATwcoqwok3668vBz8b0+V4yUynlJt9aUcqBo8AyioQos6G2vs/53VpvcTl+LppYsLonzOoIoNsgur7faDSfYxS89nVhzh0wCnZRzOKpxiS2ZXigmwiNk4T5G23sdsELe0mfu3MfAS2Jxj1iuNXNBbD9+qGDDXdFcpigzpoZQLLOKvgz0gE1mr2D17uR5JPaUKihIw3c0ZOcbfFxHgxht3olm/YKMT3MAiLPX99UPeyv8n+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oXs8emVZgpjuX5WfO6zuwZzgmtCWI4fARV91aq6vTs8=;
 b=P3LxUWGBiUmlJp2JmF6H0Rj1DEVxHrA74N2lGsa3e0PpWnWXwjgUWz9M73yEGcqGkJUqORJe+hqg0QpJswzaXzQx0bNBFMvFtQFBT1/go6bpteBo5U/AVmtlx/EsAKHWp1U6rd8qeAlN1O58PVE//xpITg10vuAigedvwxronLSxRcE4LGwItECs0OAS85YPII7yJ51A1oOd1LnQl2HfIBujX+J7VkSUBK66RjW6m+yKm+KPnuXcIWwLVys/yjfPjed2T/NEYnrRbQFBBiH3QsZSfHjCCttr6+gXfwtATGHELWHfcoxWTBPZEDvRscvyCrFZTSq3zIKs2scpq8a71w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9715.namprd12.prod.outlook.com (2603:10b6:408:2a0::7)
 by CY8PR12MB7611.namprd12.prod.outlook.com (2603:10b6:930:9b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Sun, 26 Jul
 2026 09:29:47 +0000
Received: from LV8PR12MB9715.namprd12.prod.outlook.com
 ([fe80::e74f:2cf8:cf2c:142]) by LV8PR12MB9715.namprd12.prod.outlook.com
 ([fe80::e74f:2cf8:cf2c:142%6]) with mapi id 15.21.0245.012; Sun, 26 Jul 2026
 09:29:47 +0000
From: Michael Gur <michaelgur@nvidia.com>
To: jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org,
	Edward Srouji <edwards@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Michael Gur <michaelgur@nvidia.com>
Subject: [PATCH rdma-next 00/15] RDMA: Support HW requiring relaxed ordering and add Unordered access flag
Date: Sun, 26 Jul 2026 12:29:14 +0300
Message-ID: <20260726092943.2880176-1-michaelgur@nvidia.com>
X-Mailer: git-send-email 2.52.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0376.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f7::19) To LV8PR12MB9715.namprd12.prod.outlook.com
 (2603:10b6:408:2a0::7)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9715:EE_|CY8PR12MB7611:EE_
X-MS-Office365-Filtering-Correlation-Id: c0b4ad02-9b0c-48e4-521a-08deeaf86f4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|10067099003|18002099003|56012099006|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info:
	fYQbqGg+4s24xdecI1bMlifqN132g57SwrT6fH+C12Xe3gwCdH4CWYwYWQla56RgaNflbD5B4mbWT71G8N4E7GN/LUz1wY9tOJM3H9Ei+dkoNeMxNqp73aOb5oI5FejZENzOv8NlwUs/M/tZDucIMN9ntqhS5rxNBnN+YdGYEo8IkuzNoSTclD185QeDyUR9IxyWEvCm8lmm9hB1cakczLw3k4gODFwpeUPuiRgllmN3lRUrRoMsCrd6nfg60rZ6wHm2/CNPxVsA5KF80ciJn9DQawQj/o4WsJkdHh166dmMcsaUK/sy4OeMgi3IV/l17hGP2pDmgKICr7eoM6GwQ7cVl22pOPiCmkaaXTfrFxd7kbEqfX/wXVBtuEkBL8pNuX8L6FE9SKQgXXLFzyehgnyeFQpD5f9tyvFyJddyj70U23TsMevT6GsNFRM+igk+p3sSr+DxnjJiH9im8QukknBQk3syYR1BgvI6qidvjrdaS+uWO6fxRJtuUt5iVvc2kkoCPIkyr6KSa2gyYGtCQwAR09jlTPfM20m6A4CHQ/0VGz/KrFp1HFzjQowm7ZAraRkn0jkzgVC25whFx2wNAFsqSe4HkkDQd2b5KIewhwflwQzu943G5tyCxvW0INPvocqIbSp+IAlPqVKvCuMoW+Nab+pYRi2a8owLrKoF8y0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9715.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(10067099003)(18002099003)(56012099006)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eV9la4DrIbyEZhlBdVcid2AQgvzmLl9e0wdbd+acpnJ0a8ASlL7AOac093Mx?=
 =?us-ascii?Q?wIzyEWDBE3eNil3QGGAfFsXaWseFzEGM4VmliOGr78hdcn/gRXS0d5ChFMSa?=
 =?us-ascii?Q?Za/v1LT6xyGxF9tK0HxtP5NyRYdVdqk30hWEr6y6c9LgaUjE8VqVNlFNcR3J?=
 =?us-ascii?Q?JGlX3ezISm4KLqXlck90ZiLOFnYVKuGjhQ+WV8kqYcP7EXImm+/ayPMCGUhA?=
 =?us-ascii?Q?QY4jgQXKopheOFBBVJNueIC3pwsqSKNe9hlNIzxiHIZD8hnZj6iMHF+hlKvq?=
 =?us-ascii?Q?n61i8tCWm3avrX4f37PXGS0y6G8B5802o96z04ND1QpKcZBEthfxCcqvMXyE?=
 =?us-ascii?Q?swcIhrLxpccc5Mote0RG6IiioSJkGpg8DdEt3/vC1AIJEeUpPGymh7SeR0/U?=
 =?us-ascii?Q?WvreETBo65uFCarj1G0TW068zXVdf0s0ygSo4SXMtYMEu9gg3tAZ0yl6VskB?=
 =?us-ascii?Q?Mv7kJuiJ4mOV2BJh8qRXpODTQ566A6nzyhixrotyBh9MS+7Aqhblk6LjV05o?=
 =?us-ascii?Q?1CGztskeBRURUO7wjf/4eZO8XlckfxOl18c5GmjT6h24XUbu0YO65+46GU2R?=
 =?us-ascii?Q?CWUQWtGJ81vO2PBmfDZFYBA5nTd32Xm2tL62JHzgQf/C4vmPBZtb0KiWeFdY?=
 =?us-ascii?Q?VoK2SgZjoPeFJxEw6IItN5svpM3q3er7tBw7QQh3d9WbqL6ST8ukGfgaJ7jo?=
 =?us-ascii?Q?VoHk9LOxSyjGmV2xKJrlCIBLGNc9eblUHTfqyvneUcCvBLIvto98eg6CtRwr?=
 =?us-ascii?Q?WByrF8HZ69w5sHpyi5D8mqrPxNz96Rl+aQdaEXgsE7lFmge+wsu//WaO8v55?=
 =?us-ascii?Q?RxISN8XI/2LdoJFtfUZMWLUW9xmbGZ7lZpvmEkO2bvSMyCSdQC1nMQhfUl66?=
 =?us-ascii?Q?PVm4Tt5XrBk7lOn1lYC61sCTHhDPFqCC/Ev7B3iyjDbTt3WBDA2vVFyPQio7?=
 =?us-ascii?Q?vFnQznlnInrGhuawquhTP3LtLYllXe81tHU949zeodQjPXXelUDIFNA94OLK?=
 =?us-ascii?Q?h3a8Ch4yxjtiGIrO5lEWrHUJEFfBYv7g48VcXuY4npWZYkSOT2P0PE4WFga+?=
 =?us-ascii?Q?qiFyrXdGwGvm7hjHHsI6VxJMn1n7vjo4MAmNdERCb94THRly0Q+0yHRevX6G?=
 =?us-ascii?Q?Ah860Lviu3DykWH0nXkUsPM3VKTFH0mQO/l5uUVxALS4Cb52sJgVjIVFCu/D?=
 =?us-ascii?Q?dzy4OW1YpOIwDwuH9J/dkcCbgbf6zd9rWFrVrLsuDOD+UfCziaJOLKUircQY?=
 =?us-ascii?Q?NwPXPzKO5pTKP7amhNpW4CILhjg1zFA8l9Rmgkt8vVeWeCjqrJCVfBJ0X3gZ?=
 =?us-ascii?Q?vnKJnkmTMkCTfT9itYaCBh62rqnbj1EklivOKOYgqregHIbIacebgT1bM4t2?=
 =?us-ascii?Q?c48lbp8cLX/OdHs65i1CT0h0mUX8vbvEs1ZPNTcnaBafcS+VTbvTYdhH9evf?=
 =?us-ascii?Q?91yeauaEoBe9NCxxTW0dBj/5zBTb9QkU+JwQImkojSKZTlfi1lBVMfp51fcH?=
 =?us-ascii?Q?5U1YPleqVjw1SCFK0S9ZBtcyUmMT6ZyZoc57pxDH4hRRgL3NoK0lNKg/aJML?=
 =?us-ascii?Q?4Hz6Mq82A0S9qYr3Tgpb1Oe9RFEnreIZifb7R32XlGr3cGSZCn7QS28SO1vo?=
 =?us-ascii?Q?MGf6xY4qOKYgpqJLF5sv/EF+mfRJd825ebgoOesgg72fdBdn8DS7bUfABhWi?=
 =?us-ascii?Q?ae6LjdZEytiLHyF1OcrhXw98dgL5BWTvgvN9/n07PEx8kd/kcU0twc6tWyi+?=
 =?us-ascii?Q?YJH6YnflrQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0b4ad02-9b0c-48e4-521a-08deeaf86f4f
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9715.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2026 09:29:47.4854
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oDrdgmXfBiZsQKSB1beySPsyOcH+t0mndbqKUJUM6mlgHFFZ5jBoiSkECF+5Ml2LOFKVeMCTO6iwYyxYV1jiyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7611

This series prepares the mlx5 stack for hardware that restricts strong-
ordered memory accesses, i.e. HW whose fabric doesn't guarantee memory
operation ordering. The HW may choose to reject creation of an mkey that
doesn't request relaxed ordering, so every mkey the driver creates -
internal and user-facing - has to be handled accordingly.

The previously added 'ConnectX-10 NVLink-C2C' PCI device is such a device,
as will be any future PCIe Gen7 UIO devices. 

The series does four things:

1. Allow optional access flags on all memory registration
   The uverbs ABI defines the optional access flags range as best-effort:
   drivers must accept any flag in this range and treat support as
   opportunistic, never failing registration. Several registration paths
   (DM, DEVX UMEM, dmabuf ioctl, reg_mr ioctl) did not allow this range
   and would reject such requests. These are fixed to allow newly added
   optional access flag added later in the series and any future optional
   access flag.

2. Groundwork and internal mkeys
   Rename the relaxed-ordering IFC fields to the new naming, add the new
   ordering capability and mkey-context bits, and consolidate RO-setting
   to a single helper in mlx5_core so all consumers share one cap-gated
   implementation. Then enable relaxed ordering on the internal mkeys that
   don't require strong ordering (resource dump, vfio live-migration data,
   ODP null mkey, memory window mkey), so they keep working on strict-RO
   HW.

3. New Unordered access flag and enforcement
   Add IB_ACCESS_UNORDERED, an optional access flag that additionally
   allows read-after-write reordering, and wire up mlx5 support for it.

4. Enforce no-strong-ordering in user MR registration on HW that requires
   it.

Michael Gur (15):
  RDMA/mlx5: Allow optional access flags in DM registration
  RDMA/mlx5: Allow optional access flags in DEVX UMEM registration
  RDMA/core: Allow optional access flags in dmabuf reg ioctl
  RDMA/core: Allow optional access flags in reg mr ioctl
  mlx5: Rename IFC bits of relaxed ordering fields
  net/mlx5: Add IFC bits for new ordering caps
  mlx5: Move RO setting helper to core and consolidate mlx5 consumers
  net/mlx5: Enable relaxed ordering on resource dump mkey
  vfio/mlx5: Enable relaxed ordering on the live migration data mkey
  RDMA/mlx5: Enable relaxed ordering on ODP null mkey
  RDMA/mlx5: Enable relaxed ordering on Memory Window mkey on strict-RO
    HW
  RDMA/mlx5: Converge UMR access-flag cap checks
  RDMA/uverbs: Add new Unordered MR access flag
  RDMA/mlx5: Support new Unordered access flag
  RDMA/mlx5: Enforce relaxed ordering when HW requires it

 drivers/infiniband/core/umem.c                |  2 +-
 drivers/infiniband/core/uverbs_std_types_mr.c |  4 +-
 drivers/infiniband/hw/mlx5/devx.c             |  2 +-
 drivers/infiniband/hw/mlx5/main.c             |  8 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |  4 +-
 drivers/infiniband/hw/mlx5/mr.c               | 79 ++++++++++---------
 drivers/infiniband/hw/mlx5/odp.c              |  1 +
 drivers/infiniband/hw/mlx5/umr.c              | 18 ++---
 drivers/infiniband/hw/mlx5/umr.h              | 45 ++++++-----
 .../mellanox/mlx5/core/diag/rsc_dump.c        |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 -
 .../ethernet/mellanox/mlx5/core/en/params.c   |  2 +-
 .../ethernet/mellanox/mlx5/core/en_common.c   | 13 +--
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  4 +-
 drivers/net/ethernet/mellanox/mlx5/core/mr.c  | 21 +++++
 drivers/vfio/pci/mlx5/cmd.c                   |  7 +-
 include/linux/mlx5/driver.h                   |  1 +
 include/linux/mlx5/mlx5_ifc.h                 | 24 ++++--
 include/rdma/ib_verbs.h                       |  1 +
 include/uapi/rdma/ib_user_ioctl_verbs.h       |  1 +
 20 files changed, 134 insertions(+), 105 deletions(-)

-- 
2.52.0

