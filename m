Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012012.outbound.protection.outlook.com [40.93.195.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201631F5821;
	Fri, 21 Aug 2026 00:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787273717; cv=fail; b=G1/bNtOL8aNibUblcZvRIaHdsZq+55VSTUFzpe3XkKgvO6aXHX5oszzu/8hBNUnWaZpC/LYyjXRXzBZdgzr8rpYpVZdyXjXnrfl2gTkX3QN00590KqqktBIqB9BWxHEdx932p/YhQBCxI5zWUWv0c4NMBaPMtfG4du/oDMJkQ4Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787273717; c=relaxed/simple;
	bh=LIy2FrioYGOVyYJUycpBQuxxFHZcGBvoZMtn29bMFS4=;
	h=Date:From:To:Cc:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=drWQIoHi+Niq8mgG6SFVulAfir59N2LwKkLPDk+Xk98fDsfRsTfAa9nSJ76XXEHTtmdVaBgjK8wo0Scck1Y3WtdEBDQaYrk2osgy/ntqMUCgFoqHNQ6dfTgwqzujiP6GKp+0ikJbhIQo8dhbHrSiFl39D6xrmnbxoBxlrzyobcc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YGwablWa; arc=fail smtp.client-ip=40.93.195.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YGwablWa"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gnf2S/JXhqrnHlDuWoZzhuGCihvGGY1sOzH+DLDoIXX74GzuykhOEiZv0RHKjRwq+wkwJTkBTCfpi8CTC7f12vPjeMzpgU2bw+3087Ec9JxwNCWDPjMRW/SdXALjfM0WGqjy8nRx2o7yieW9pFdFVxdc9KZFpeKaYkLZenNPmR78/KJbmfDu9DGKl9EfHKTBO5D8C08SuTiM0cbTDeAo4kWLxP7KQLhXCAouZ/bY78+J8+5c5Ta+FdiUTHSZledrJrL5ts3e3Nn8w3NtE8T6jMCj+nxbRrN4eoPD8UJJPOmGR/8+CY5GeOs7jsnyETEkvVsG67k3Xu038Q7ecm43ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pICcT0aLOTdGUqZ2DduBFHu62Py/NeRkiRtZgbm9szU=;
 b=Xz9zdlGHCT+V4ocS7bgOelfCfMGnjcMU5l3w6z1rfEbOgIyVWjCNaW5Ex5xl4ArtQhp7NPmL/Ol0peIehEF10LVPqXI2D+DeSj/TdbYAterwKNwXMgGqxAQqw9OLcGuAG+4kxDT9wf+3dOewp0rnGYyFh+8wVcqDG+SRbN6jS37biLE79Rv/UOBc3eXjZtxz25t43RfaCvhtfa6mrRGuL2pBTAAHFEo5BGy7Rflqb9neahEVaBDXxh4fg+NTWjFLzYCrg8/qN3BZ6AespABLR14bMRwSEszjyuiC6Nzj8jdSxqEgB4O58QdEDAKWJFN9jlOABR3Me6/YppgdAwmdGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pICcT0aLOTdGUqZ2DduBFHu62Py/NeRkiRtZgbm9szU=;
 b=YGwablWaso/Hr2b0krtFsiZ9ebp+bVwt2U1JLwe6M3plTr5SJUz9MfM66XTevEOsfVzLEQ3bAr5e/Zmv4FQkabXzmVcY6aY8oURAmD1zSHIlzyYwLyHoG+8EubyrB+IrOYW3McVDs131vNnNJieS8s8ewUcCwrN/JV+taw7KQxZTxRZg4FaDR+kTYLfE66vrl5hTgmlRITgT0hV4/bx5PKMpsb4pYZOPwBrgg8pjxAGJ7Dnn8dI9S3i0dWTOACckbA4Bzpp5dUmTh8K+6I/bMU5xkiWYkCqabyx1LU8aFo/6s04JuL9VpZwuMgiS/yeO0fnXJZHcO5TIQdw1mDLVtg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DM6PR12MB4076.namprd12.prod.outlook.com (2603:10b6:5:213::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.8; Fri, 21 Aug
 2026 00:55:08 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0339.008; Fri, 21 Aug 2026
 00:55:08 +0000
Date: Thu, 20 Aug 2026 21:55:07 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
	Leon Romanovsky <leonro@nvidia.com>
Subject: [GIT PULL] Please pull RDMA subsystem changes
Message-ID: <20260821005507.GA1172051@nvidia.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="rviEvjDxO5JFrj6g"
Content-Disposition: inline
X-ClientProxiedBy: YT1PR01CA0123.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2c::32) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DM6PR12MB4076:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e6f7e49-4191-4914-eab0-08deff1ed886
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|56012099006|10067099003|6133799003|3023799007|11063799006|18002099003;
X-Microsoft-Antispam-Message-Info:
	Sd16YN37XFKwcpRjRY4ZmJj/FQHoc6mLrQcnOqAq+IRR+nMzzeCMPJwKB7caqdU9tI1akeCtKx0jYRfSm3SqrmH2Uyv85wFAWPNrniPENjswnT1TGkb1WYJHhJo2uTfj6J8qNCUHlw7UKShoPDGi50X47c3LLCx8NgRIvBXkFQ0WvmZO8Ip+/Rjg1X387PcgXSovYwOee1F7ybv/Oz1vUXgahTm2Zm8EJNLhRFmU+vF4gpvbK8lxINuWOgFbDkbHZ2Jy4jCpCITe0bVTwHJ+y5RgyJQoGXbrLOOAWJgMC+HDqQKKvZkrdCuPkrYUC917nMNPf415l+UbFHcsWB2LbzRDlVGbyMVsAJdBHbl0Xc9HpqfTxN96RAu+XU3kHg/T/DLaeApVWk0q211o5k6Y/Zu5/xu7SheXKRzztEvqsDXAH80n/BomrQj2ugl2L+9aWuzGj08iixelh2BZek9/QaTAiPqTrDDtQ77kkIVs7iFsIV+EAmqR+K+FaU6lS+VyZ6nawurq2gH46xOjNjlyxVyM0g1cecCsC+Bvmugw24xJap2/A43+Z5IySQoJSUL5pXB0Uxp0X6NaAtPnD1yhxw+pDvPU/ZEoUURwQzfJ1X+/yMQXmMTw4WmpfDUYOA5ItZK1cc5SFSipLOvHQjopT+trUMw1Bkxj+k33M0Cs4y8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(56012099006)(10067099003)(6133799003)(3023799007)(11063799006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CVqCw7IHTtEJV3HasMdO5OiQYKrCrS9J0WkUo5rlJq1o6UnKS0Re5Mx3l1gy?=
 =?us-ascii?Q?8uBXEBr9mAzpkGogsgb58e0gclt3lb1RSQ/qngmzv2YZgM1ZkQN24nUJXFMW?=
 =?us-ascii?Q?jzDQ92AOFgATcVeXQZzNCFMGmasujp1e1p3UzlScdao5ZMLqumVCym9cnI+7?=
 =?us-ascii?Q?7Vv8pX3vj5rLEj9Jbxk7a+Orsau5yM6clDtW0Suoj1DLBui0DIICEObbkYvv?=
 =?us-ascii?Q?8al9bZbA3m8ZT6qdFBrZbXNBJPm3kI/Zo9C473ZxRLEh3E86wQ7VLoh3IiY2?=
 =?us-ascii?Q?W0NDmMHmQ+7qe9xVu+yRb8xqN7zvtXOPBMrZG0oGIbsVGptNxa0vXT8hTWWB?=
 =?us-ascii?Q?URomWLK8h5V8TSM8LuA9HCYcdU033JrMoQ68/jBCWsgFsnKlSUf8V7qkDArF?=
 =?us-ascii?Q?YHGqU8oMDLWbrXWMRnNb2GSatffxIFu8pxk9Ie0pzYX2ly9KG6z67yV2/r/T?=
 =?us-ascii?Q?Ja6yc2TbUTNTECBZ6Mux/83N4rC6HAHR//q8p72POt92LONtx/9u23tNgK5R?=
 =?us-ascii?Q?XXfhdaioVs/n7t72CCzD8FM1jN+VE+wL7gDZgnDSBd83r2Mj3hDRFbhk8O29?=
 =?us-ascii?Q?GrXFlJhM/HFjKcqoe1pHx5PWbDe4d6VEEo6AoSjkH8CRrXNU8LG0h9wh9Ems?=
 =?us-ascii?Q?9rH3NqOtc5lo0TjANtPpSckImmsyMKm+vgRKlyc5c4PMGsjyNSGwOeP98GuZ?=
 =?us-ascii?Q?ttPp3g0iYuBdJfcfge8+8meeyS8OYx1uBVrbMNeMvBUbkKD7u13pg1o6L+qv?=
 =?us-ascii?Q?4dTf287wR/dXL1Y0YxJOSeHCtUTIVLedGncPuI3GNF2xPZmFbeD4CCmiwWzb?=
 =?us-ascii?Q?v8C+IpYHH3r7TzKMFqhX16UbLyOpBIvFA/cdKjGyiLxsVApKW7WKInOnlPLu?=
 =?us-ascii?Q?20/7ZZTR2DOFY8MirAQym/cxAyIMARkVnid+rmUKdbWZocUu5+sVOrtAIaUv?=
 =?us-ascii?Q?kl5Qke15RqJXmsfMRgyGz/8SF0DTL9E7S+mPdV81MhMAChWBIGGlWtQhCmLk?=
 =?us-ascii?Q?ekHtfJ5lTVpI9w4fsejtyvEXyIXYcFnBpZ4Zc0oBlYqFrTXrSt1lz4fUxKxV?=
 =?us-ascii?Q?nDZYsCpZDuT86cb2j+X6TRxgRAlw3rBuxJDUBqrqEClWiVF7u0xmBML/VWFx?=
 =?us-ascii?Q?x+lhVzuIbnVrzPU+NMOQBXr0RPPAeUHrm1nZ+ZACDaNfJrajaOlwgko+dzFy?=
 =?us-ascii?Q?JELf/XmWRZfcCNYQWHfhYOq1+gOZF1JDDtfW/Q50293qekwBGLg7ZAG0hcCQ?=
 =?us-ascii?Q?p1voSkFYGHiQ2BEEffHGHB97PFkllkoL1m9gjBTauWaRLuPlIJkbViJwIEFL?=
 =?us-ascii?Q?EZBZjF6wFTPQf5bNZJ8/kH4ujD2XBPi94ukMendbAW/HzBkFzspgFA16v1Zw?=
 =?us-ascii?Q?Ku6hA9bWKxIVzSUqFQAY8Ep8TrupYrJtFAaTMAAQhrtrtTdi/oqC53yFF5fZ?=
 =?us-ascii?Q?V66RIl2CtvgMut1Fosv80FgFuEsDTWGkNXda6OViYSKrkFFlQ89tz/yBfbjU?=
 =?us-ascii?Q?W6ryI0N3Qdv9XdYBjGO9RB4S1w56DHfnacB6WNNZSyjRywZ+Txqm7e6Ymaj6?=
 =?us-ascii?Q?NIlMpSOC5VwJoNQSBEIA3QE21iJ0z9RUgLz8ia52M+AKAx+udG2dsE3BRCV9?=
 =?us-ascii?Q?PMYIEmQ7QptvqANZ+HYvLctDDqbegIEYpwi6+IlEJNTU+ghFByzRtz0iDyRs?=
 =?us-ascii?Q?MA035q55JF1beUbed34B34d9Y2LJmjASOUHVdp0/g3rSnHh9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e6f7e49-4191-4914-eab0-08deff1ed886
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2026 00:55:08.3443
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iktA/yQDy1ZXFxCfURCcFHOQbWD+LvKqNYV8Quuk1We8eFZ63H114bMu3Yimyy2f
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4076

--rviEvjDxO5JFrj6g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

About the normal sized pull request, still alot of AI bug fixes and so
on, but some interesting new functionality too.

Thanks,
Jason

The following changes since commit bee40a7d0bd1263934f99054db037cdd4a33fd86:

  net/mlx5: Add PSP related fields to the mlx5_ifc (2026-07-16 04:24:02 -04=
00)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

for you to fetch changes up to 8049741ac93acd3a590dac070e12571fddf0e294:

  RDMA/ucma: Allow path records to exactly fit the output buffer (2026-08-2=
0 08:46:15 -0300)

----------------------------------------------------------------
RDMA v7.3 merge window pull

Quite alot of buf fixes again:

- Assorted locking, bounds-checking, cleanup, and error-path fixes across
  UCMA/CMA, bng_re, bnxt_re, cxgb4, EFA, ERDMA, HFI1, HNS, ionic, iRDMA,
  mlx4/mlx5, RXE, SIW, SRP/SRPT, and iSER target.

- netlink report for max # of supported resources

- get_zeroed_page()/etc removal

- Robust udata for ionic

- Allow unique RDMA device names per network namespace

- Completion counters and v2 admit queue support for EFA

- UC QP support for MANA

- Completion timestamps for ionic

- Harden uverbs data validation and resource lifetime handling, fixing seve=
ral core use-after-free conditions.

- bnxt_re toggle-page ownership and lifetime bug fixes

- dmabuf SRQ support for mlx5

----------------------------------------------------------------
Abhijit Gangurde (7):
      RDMA/ionic: Add robust udata compatibility checks to all uapi verbs
      net: ionic: register PHC for rdma timestamping
      net: ionic: Add PHC state page for user space access
      RDMA/ionic: map PHC state into user space
      RDMA/ionic: add completion timestamp to CQE format
      RDMA/mlx5: move mlx5 clock info to common struct ib_uverbs_clock_info
      RDMA/ionic: Embed counter driver data in rdma_counter allocation

Alexander Chesnokov (1):
      RDMA/hns: Compute HEM index in 64-bit in hns_roce_v2_set_hem()

Allison Henderson (1):
      RDMA/rxe: Avoid reprocessing the current packet after the QP enters t=
he error state

Anas Mousa (1):
      RDMA/efa: Add EFA 0xefa4 PCI ID

Brett Creeley (1):
      RDMA/ionic: Cap eq_count to the eth driver's interrupt vector budget

Cheng Xu (2):
      RDMA/erdma: Hold CQ references when processing EQ events
      RDMA/erdma: Hold QP references for AE and CM processing

Christophe JAILLET (2):
      RDMA/mlx5: Constify struct ib_frmr_pool_ops and dma_buf_attach_ops
      RDMA/umem: Constify struct dma_buf_attach_ops

Danila Chernetsov (1):
      RDMA/hfi1: Propagate sdma_txinit_ahg() errors

Dmitry Antipov (3):
      IB/mlx5: simplify set_param()
      RDMA/bnxt_re: simplify bnxt_re_cc_config_set() and cq_coal_cfg_write()
      RDMA/ocrdma: accept boolean value in ocrdma_dbgfs_ops_write()

Erni Sri Satya Vennela (1):
      RDMA: Change capability fields in ib_device_attr from int to u32

Fan Wu (2):
      RDMA/cxgb4: Cancel reg_work before freeing device on remove
      RDMA/cxgb4: Free debugfs on registration failure

Gou Hao (1):
      RDMA/cxgb4: remove dead NULL checks after GFP_NOFAIL allocations

Ibrahim Hashimov (2):
      RDMA/rxe: Fix responder UAF on IB_QP_MAX_DEST_RD_ATOMIC modify_qp
      RDMA/rxe: Validate num_sge/cur_sge before indexing wqe->dma.sge[]

Jacob Moroni (14):
      RDMA/irdma: Deduplicate the irdma_del_memlist logic
      RDMA/irdma: Add a refcount to track user ring MR associations
      RDMA/irdma: Add irdma_cq fields to track pbl allocations
      RDMA/irdma: Add refcounting to user ring MRs
      RDMA/core: Add ib_no_udata_io() helper
      RDMA/irdma: Prevent user-triggered null deref on QP create
      RDMA/irdma: Add checks for no udata
      RDMA/irdma: Clear udata response buffers where necessary
      RDMA/irdma: Use robust input copy helpers
      RDMA/irdma: Use robust udata helper for QP creation
      RDMA/irdma: Fix legacy i40iw compat check in create_qp
      RDMA/irdma: Enable uverbs_robust_udata compliance flag
      RDMA/core: Prevent rereg_mr for dmabuf umems
      RDMA/irdma: Remove dmabuf checks in rereg_mr

Jason Gunthorpe (2):
      RDMA/uverbs: Add UVERBS_ATTR_UHW to UVERBS_METHOD_REG_MR
      Merge rdma branch 'for-rc' into 'for-next'

Jiri Pirko (17):
      RDMA/uverbs: Add SRQ buffer UMEM attribute
      RDMA/mlx5: Use UMEM attribute for SRQ buffer in create_srq
      RDMA/mlx5: Use UMEM attribute for SRQ doorbell record
      RDMA/core: Pass the net namespace to the device name lookups
      RDMA/core: Handle device name conflicts when changing net namespace
      RDMA/core: Support renaming a device when changing its net namespace
      RDMA/nldev: Report net namespace move errors through extack
      RDMA/nldev: Allow setting the device name while changing net namespace
      net/smc: Look up the pnetid ib device within the net namespace
      RDMA/srp: Make the SRP sysfs class net namespace aware
      RDMA/cgroup: Disambiguate devices across net namespaces
      RDMA/cma: Document that CM configfs cannot be net namespace scoped
      RDMA/core: Document the SELinux ibendport net namespace limitation
      RDMA/core: Make device names unique per net namespace
      RDMA/rxe: Allow queue VMAs to outlive ucontexts
      RDMA/rxe: Implement disassociate_ucontext callback
      RDMA/selftests: Add rxe_netns_names test

Kamal Heib (1):
      RDMA/ionic: Remove duplicate IONIC_SPEC_HIGH definition

Konstantin Taranov (4):
      RDMA/mana_ib: Adopt robust udata
      RDMA/mana_ib: return PD number to the user
      RDMA/mana_ib: unify QP lookup table
      RDMA/mana_ib: UC QP support for UAPI

Leon Romanovsky (34):
      RDMA/mlx5: Remove kernel-doc warning in umr.c
      RDMA/core: Wait for RCU callbacks before unloading ib_core
      RDMA/mlx5: Drain RCU callbacks during module teardown
      RDMA/ipoib: Drain RCU callbacks during module teardown
      RDMA/rvt: Return NULL after port allocation failure
      RDMA/hfi1: Preserve unit 0 on allocation failure
      RDMA/hfi1: Remove redundant PCI device ID validation
      RDMA/hfi1: Pass PCI device to hfi1_pcie_init()
      RDMA/hfi1: Drop device data from hfi1_validate_rcvhdrcnt()
      RDMA/hfi1: Create workqueues before device initialization
      RDMA/hfi1: Free RX data on late probe failure
      RDMA/hfi1: Allocate device data after PCI initialization
      RDMA/hfi1: Remove redundant NULL checks in create_workqueues()
      RDMA/hfi1: Stop flushing the global IB workqueue
      RDMA/hfi1: Defer device creation until probe succeeds
      RDMA/hfi1: Initialize debugfs after probe completes
      RDMA/hfi1: Align probe error unwinding with device removal
      RDMA: Remove redundant memset() from query_device callbacks
      RDMA: Use ib_no_udata_io() in query_device callbacks
      RDMA/bnxt_re: Validate udata before executing commands
      RDMA/cxgb4: use kmalloc() for the PBL address array
      RDMA/mlx4: use kzalloc() for the fast registration page list
      RDMA/usnic: use kmalloc() for the page pointer array
      RDMA/mlx5: use kmalloc() for UMR translation buffers
      RDMA/srpt: Pass the mapped task attribute to target_init_cmd()
      RDMA/mana_ib: drain QP references after partial table insertion
      RDMA/erdma: complete object teardown when the destroy command fails
      RDMA/mlx5: Make sure that UMR page is aligned to PAGE_SIZE
      mlx5: Deprecate latency-sensitive QPs feature
      RDMA/cxgb4: Fix dereg_skb leak and double free in write_tpt_entry()
      RDMA/mlx5: Fix stack out-of-bounds read in cc_params debugfs
      RDMA/mlx5: Send cong param changes to the resolved port mdev
      RDMA/cxgb4: free STAG index when TPT entry write fails
      RDMA/erdma: restrict the driver to little-endian systems

Maher Sanalla (1):
      RDMA/mlx5: Fix integer overflow of user QP buffer size

Manuel Ebner (1):
      docs: infiniband: fix bracket

Michael Gur (1):
      RDMA/mlx5: Expose RoCE acceleration counters on all functions

Michael Guralnik (2):
      net/mlx5: Add qp_latency_sensitive_disable cap bit
      RDMA/mlx5: Deprecate latency-sensitive QPs feature

Michael Margolin (7):
      RDMA/efa: Extend page-shift field in MR registration
      RDMA/core: Add Completion Counters support
      RDMA/core: Prevent destroying in-use completion counters
      RDMA/core: Expose Completion Counter capabilities to userspace
      RDMA/core: Add Completion Counters to resource tracking
      RDMA/efa: Update device interface
      RDMA/efa: Add Completion Counters support

Michal Schmidt (1):
      RDMA/hfi1: Remove unused non-user-accessible device class

Mike Rapoport (Microsoft) (5):
      RDMA/umem: ib_umem_get(): use kmalloc() to allocate page array
      RDMA/mlx5: replace __get_free_page() with kmalloc()
      IB/mthca: mthca_reg_user_mr(): use kmalloc() to allocate addresses ar=
ray
      IB/mthca: allocate mthca_array memory with kzalloc()
      IB/rdmavt: use kzalloc() to allocate QPN-map pages

Myeonghun Pak (1):
      RDMA/erdma: Fix CEQ tasklet use-after-free on removal

Norbert Szetei (2):
      RDMA/ucma: Lock the handler in ucma_write_cm_event()
      RDMA/ucma: Lock the handler in ucma_set_ib_path()

Patrisious Haddad (8):
      RDMA/core: Add rdma_restrack_begin/abort/commit_del() operations
      RDMA/core: Fix use after free in ib_query_qp()
      RDMA/core: Fix potential use after free in ib_destroy_cq_user()
      RDMA/core: Fix potential use after free in ib_destroy_srq_user()
      RDMA/core: Fix potential use after free in counter_release()
      RDMA/core: Fix potential use after free in ib_free_cq()
      RDMA/core: Fix potential use after free in uverbs_free_dmah()
      RDMA/core: Fix potential use after free in ib_dealloc_pd_user()

Peiyang He (2):
      RDMA/rxe: Fix UAF in ODP init error-handling path
      RDMA/rxe: Fix OOB in free_rd_atomic_resources()

Pengpeng Hou (2):
      RDMA/bng_re: return a timeout when firmware responses stall
      RDMA/nldev: validate dynamic counter attribute length

Praveen Kumar Kannoju (2):
      IB/mlx4: delete allocated id_map_entry while sending REJ
      IB/mlx4: Fix stale CM id_map entries when RTU is never received

Randy Dunlap (1):
      IB/mad: cleanup all kernel-doc comments

Selvin Xavier (4):
      RDMA/bnxt_re: Clear VM_MAYWRITE on DBR/toggle page mmap
      RDMA/bnxt_re: Replace per-device hash tables with per-context XArrays
      RDMA/bnxt_re: Defer toggle page free to rdma_user_mmap_entry teardown
      RDMA/bnxt_re: Add uverbs object handle path for CQ/SRQ toggle page

Serhat Kumral (1):
      RDMA/ucma: Allow path records to exactly fit the output buffer

Seyeong Kim (1):
      RDMA/irdma: Suppress PF reset on HMC error

Shuangpeng Bai (1):
      RDMA/siw: Fix use-after-free in siw_accept()

TanZheng (1):
      RDMA/srpt: Fix srpt_alloc_rw_ctxs() unwind counters

Tao Cui (1):
      RDMA/nldev: Add resource summary max values for usage display

Yehyeong Lee (5):
      IB/isert: reject PDUs declaring more data than was received
      IB/isert: reject login PDUs declaring more data than was received
      RDMA/srp: fix heap information leak on a truncated SRP_CRED_REQ
      IB/isert: delay the final Login Response until the session is registe=
red
      IB/isert: post the full-feature receive buffers after session registr=
ation

Yonatan Nachum (8):
      RDMA/efa: Add initialization of AH cache rhashtable
      RDMA/efa: Add AH cache handling on create and destroy AH
      RDMA/efa: Add CQ/QP creation with 64-bit SQ req ID support
      RDMA/efa: Expose 64-bit send WR ID support to userspace
      RDMA/efa: Fix PBL chunk length computation
      RDMA/efa: Decouple admin command payload from admin header
      RDMA/efa: Generalize the admin SQ
      RDMA/efa: Add support for 128B admin v2 SQ entry

Yuhang Pan (1):
      RDMA/uverbs: Guard legacy bundles without method_elm

Zhiwei Zhang (1):
      RDMA/rxe: Check PDs for memory window binds

Zhu Yanjun (1):
      RDMA/cma: Fix WARNING in res_to_rt

luoqing (1):
      IB/iwpm: Fix spelling errors in comments

xiongweimin (3):
      RDMA/cma: fix spelling of guarantees in comment
      RDMA/addr: fix spelling of guarantees in comment
      RDMA/rxe: Reject unimplemented implicit ODP cleanly

 Documentation/ABI/testing/configfs-rdma_cm         |   4 +
 Documentation/admin-guide/cgroup-v1/rdma.rst       |   8 +
 Documentation/admin-guide/cgroup-v2.rst            |  15 +-
 Documentation/infiniband/user_mad.rst              |   2 +-
 drivers/infiniband/core/Makefile                   |   1 +
 drivers/infiniband/core/addr.c                     |   2 +-
 drivers/infiniband/core/cgroup.c                   |   1 +
 drivers/infiniband/core/cma.c                      |  10 +-
 drivers/infiniband/core/cma_configfs.c             |   4 +
 drivers/infiniband/core/core_priv.h                |   3 +-
 drivers/infiniband/core/counters.c                 |   5 +-
 drivers/infiniband/core/cq.c                       |   5 +-
 drivers/infiniband/core/device.c                   | 253 +++++++++++--
 drivers/infiniband/core/ib_core_uverbs.c           |   3 +
 drivers/infiniband/core/iwpm_msg.c                 |   2 +-
 drivers/infiniband/core/mad.c                      |  30 ++
 drivers/infiniband/core/nldev.c                    |  69 +++-
 drivers/infiniband/core/rdma_core.h                |   1 +
 drivers/infiniband/core/restrack.c                 | 169 +++++++--
 drivers/infiniband/core/restrack.h                 |   3 +
 drivers/infiniband/core/security.c                 |   6 +
 drivers/infiniband/core/ucma.c                     |  16 +-
 drivers/infiniband/core/umem.c                     |   8 +-
 drivers/infiniband/core/umem_dmabuf.c              |   4 +-
 drivers/infiniband/core/uverbs_main.c              |   1 +
 .../infiniband/core/uverbs_std_types_comp_cntr.c   | 172 +++++++++
 drivers/infiniband/core/uverbs_std_types_device.c  |  51 ++-
 drivers/infiniband/core/uverbs_std_types_dmah.c    |   7 +-
 drivers/infiniband/core/uverbs_std_types_mr.c      |   6 +-
 drivers/infiniband/core/uverbs_std_types_qp.c      |  67 +++-
 drivers/infiniband/core/uverbs_std_types_srq.c     |   2 +
 drivers/infiniband/core/uverbs_uapi.c              |   1 +
 drivers/infiniband/core/verbs.c                    |  42 ++-
 drivers/infiniband/hw/bng_re/bng_fw.c              |  10 +-
 drivers/infiniband/hw/bnxt_re/bnxt_re.h            |   6 -
 drivers/infiniband/hw/bnxt_re/debugfs.c            |  31 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           | 191 +++++++---
 drivers/infiniband/hw/bnxt_re/ib_verbs.h           |   8 +-
 drivers/infiniband/hw/bnxt_re/main.c               |   4 -
 drivers/infiniband/hw/bnxt_re/uapi.c               | 183 ++++++----
 drivers/infiniband/hw/cxgb4/device.c               |   8 +-
 drivers/infiniband/hw/cxgb4/mem.c                  |  64 ++--
 drivers/infiniband/hw/cxgb4/provider.c             |   4 +-
 drivers/infiniband/hw/efa/Makefile                 |   4 +-
 drivers/infiniband/hw/efa/efa.h                    |  20 +-
 drivers/infiniband/hw/efa/efa_admin_cmds_defs.h    | 296 +++++++++++-----
 drivers/infiniband/hw/efa/efa_admin_defs.h         |  33 +-
 drivers/infiniband/hw/efa/efa_ah_cache.c           | 135 +++++++
 drivers/infiniband/hw/efa/efa_ah_cache.h           |  39 ++
 drivers/infiniband/hw/efa/efa_com.c                | 206 +++++++----
 drivers/infiniband/hw/efa/efa_com.h                |  19 +-
 drivers/infiniband/hw/efa/efa_com_cmd.c            | 329 +++++++++++------
 drivers/infiniband/hw/efa/efa_com_cmd.h            |  48 +++
 drivers/infiniband/hw/efa/efa_io_defs.h            |  32 +-
 drivers/infiniband/hw/efa/efa_main.c               |  10 +-
 drivers/infiniband/hw/efa/efa_verbs.c              | 270 +++++++++++++-
 drivers/infiniband/hw/erdma/Kconfig                |   2 +-
 drivers/infiniband/hw/erdma/erdma_cm.c             |   6 +-
 drivers/infiniband/hw/erdma/erdma_eq.c             |  10 +-
 drivers/infiniband/hw/erdma/erdma_qp.c             |   2 +-
 drivers/infiniband/hw/erdma/erdma_verbs.c          |  45 ++-
 drivers/infiniband/hw/erdma/erdma_verbs.h          |  40 ++-
 drivers/infiniband/hw/hfi1/chip.c                  |  21 +-
 drivers/infiniband/hw/hfi1/chip.h                  |   2 +-
 drivers/infiniband/hw/hfi1/device.c                |  32 +-
 drivers/infiniband/hw/hfi1/device.h                |   1 -
 drivers/infiniband/hw/hfi1/file_ops.c              |   2 +-
 drivers/infiniband/hw/hfi1/hfi.h                   |   4 +-
 drivers/infiniband/hw/hfi1/init.c                  | 194 ++++------
 drivers/infiniband/hw/hfi1/pcie.c                  |  32 +-
 drivers/infiniband/hw/hfi1/user_sdma.c             |  13 +-
 drivers/infiniband/hw/hns/hns_roce_hem.c           |   2 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |   2 +-
 drivers/infiniband/hw/hns/hns_roce_main.c          |   6 +-
 drivers/infiniband/hw/ionic/ionic_controlpath.c    |  72 ++++
 drivers/infiniband/hw/ionic/ionic_datapath.c       |  43 +--
 drivers/infiniband/hw/ionic/ionic_fw.h             |  12 +-
 drivers/infiniband/hw/ionic/ionic_hw_stats.c       |  95 +++--
 drivers/infiniband/hw/ionic/ionic_ibdev.c          |   5 +-
 drivers/infiniband/hw/ionic/ionic_ibdev.h          |  14 +-
 drivers/infiniband/hw/ionic/ionic_lif_cfg.c        |   4 +-
 drivers/infiniband/hw/ionic/ionic_lif_cfg.h        |   1 +
 drivers/infiniband/hw/irdma/i40iw_hw.c             |   4 +-
 drivers/infiniband/hw/irdma/icrdma_hw.c            |   2 +
 drivers/infiniband/hw/irdma/icrdma_hw.h            |   2 +
 drivers/infiniband/hw/irdma/icrdma_if.c            |   8 +-
 drivers/infiniband/hw/irdma/irdma.h                |   2 +
 drivers/infiniband/hw/irdma/utils.c                |   6 +
 drivers/infiniband/hw/irdma/verbs.c                | 394 +++++++++++++----=
----
 drivers/infiniband/hw/irdma/verbs.h                |   3 +
 drivers/infiniband/hw/mana/cq.c                    |   8 +-
 drivers/infiniband/hw/mana/device.c                |   1 +
 drivers/infiniband/hw/mana/main.c                  | 129 +++++--
 drivers/infiniband/hw/mana/mana_ib.h               |  83 ++++-
 drivers/infiniband/hw/mana/mr.c                    |  13 +
 drivers/infiniband/hw/mana/qp.c                    | 223 ++++++++----
 drivers/infiniband/hw/mana/wq.c                    |  12 +
 drivers/infiniband/hw/mana/wr.c                    |   2 +-
 drivers/infiniband/hw/mlx4/cm.c                    | 120 +++++--
 drivers/infiniband/hw/mlx4/main.c                  |   2 -
 drivers/infiniband/hw/mlx4/mr.c                    |   6 +-
 drivers/infiniband/hw/mlx5/cong.c                  |  24 +-
 drivers/infiniband/hw/mlx5/counters.c              |  11 +-
 drivers/infiniband/hw/mlx5/main.c                  |  18 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |   1 +
 drivers/infiniband/hw/mlx5/mr.c                    |   6 +-
 drivers/infiniband/hw/mlx5/odp.c                   |   6 +-
 drivers/infiniband/hw/mlx5/qp.c                    |  37 +-
 drivers/infiniband/hw/mlx5/srq.c                   |  25 +-
 drivers/infiniband/hw/mlx5/umr.c                   |  13 +-
 drivers/infiniband/hw/mlx5/wr.c                    |  16 +-
 drivers/infiniband/hw/mthca/mthca_allocator.c      |   6 +-
 drivers/infiniband/hw/mthca/mthca_provider.c       |  10 +-
 drivers/infiniband/hw/ocrdma/ocrdma_stats.c        |  26 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c        |   5 +-
 drivers/infiniband/hw/qedr/verbs.c                 |   8 +-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c       |   5 +-
 drivers/infiniband/hw/usnic/usnic_uiom.c           |   4 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c    |   4 +-
 drivers/infiniband/sw/rdmavt/qp.c                  |   8 +-
 drivers/infiniband/sw/rdmavt/vt.c                  |   8 +-
 drivers/infiniband/sw/rxe/rxe_mmap.c               |  35 +-
 drivers/infiniband/sw/rxe/rxe_mw.c                 |  20 +-
 drivers/infiniband/sw/rxe/rxe_odp.c                |  12 +-
 drivers/infiniband/sw/rxe/rxe_qp.c                 |  40 ++-
 drivers/infiniband/sw/rxe/rxe_req.c                |  15 +
 drivers/infiniband/sw/rxe/rxe_resp.c               |   9 +-
 drivers/infiniband/sw/rxe/rxe_srq.c                |  16 +-
 drivers/infiniband/sw/rxe/rxe_verbs.c              |   9 +-
 drivers/infiniband/sw/siw/siw_cm.c                 |   2 +-
 drivers/infiniband/sw/siw/siw_verbs.c              |  50 +--
 drivers/infiniband/ulp/ipoib/ipoib_cm.c            |  10 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |   2 +
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c         |   3 +-
 drivers/infiniband/ulp/iser/iser_verbs.c           |   5 +-
 drivers/infiniband/ulp/isert/ib_isert.c            |  92 +++--
 drivers/infiniband/ulp/isert/ib_isert.h            |   1 +
 drivers/infiniband/ulp/rtrs/rtrs-clt.c             |  11 +-
 drivers/infiniband/ulp/rtrs/rtrs-srv.c             |  11 +-
 drivers/infiniband/ulp/srp/ib_srp.c                |  63 +++-
 drivers/infiniband/ulp/srpt/ib_srpt.c              |  30 +-
 .../net/ethernet/pensando/ionic/ionic_ethtool.c    |  12 +-
 drivers/net/ethernet/pensando/ionic/ionic_if.h     |   1 +
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    |   5 +-
 drivers/net/ethernet/pensando/ionic/ionic_lif.h    |   3 +-
 drivers/net/ethernet/pensando/ionic/ionic_phc.c    |  63 +++-
 drivers/nvme/host/rdma.c                           |   8 +-
 drivers/nvme/target/rdma.c                         |  26 +-
 fs/smb/smbdirect/accept.c                          |   5 +-
 fs/smb/smbdirect/connect.c                         |   5 +-
 fs/smb/smbdirect/connection.c                      |   8 +-
 include/linux/cgroup_rdma.h                        |   1 +
 include/linux/mlx5/mlx5_ifc.h                      |   3 +-
 include/linux/sunrpc/svc_rdma.h                    |   4 +-
 include/net/mana/gdma.h                            |   6 +-
 include/rdma/ib_umem.h                             |   2 +-
 include/rdma/ib_verbs.h                            | 102 ++++--
 include/rdma/restrack.h                            |   6 +-
 include/rdma/uverbs_ioctl.h                        |  20 ++
 include/uapi/rdma/bnxt_re-abi.h                    |   3 +
 include/uapi/rdma/efa-abi.h                        |  11 +-
 include/uapi/rdma/ib_user_ioctl_cmds.h             |  44 +++
 include/uapi/rdma/ib_user_ioctl_verbs.h            |  19 +
 include/uapi/rdma/ib_user_mad.h                    |  95 ++---
 include/uapi/rdma/ib_user_verbs.h                  |  33 ++
 include/uapi/rdma/ionic-abi.h                      |   1 +
 include/uapi/rdma/irdma-abi.h                      |   1 +
 include/uapi/rdma/mana-abi.h                       |  35 +-
 include/uapi/rdma/mlx5-abi.h                       |  15 +-
 include/uapi/rdma/mlx5_user_ioctl_cmds.h           |   4 +
 include/uapi/rdma/rdma_netlink.h                   |  10 +-
 kernel/cgroup/rdma.c                               |  71 +++-
 net/rds/ib.c                                       |  10 +-
 net/rds/ib_cm.c                                    |  10 +-
 net/smc/smc_pnet.c                                 |  20 +-
 net/sunrpc/xprtrdma/frwr_ops.c                     |   7 +-
 net/sunrpc/xprtrdma/svc_rdma_transport.c           |   5 +-
 net/sunrpc/xprtrdma/verbs.c                        |   2 +-
 tools/testing/selftests/rdma/Makefile              |   3 +-
 tools/testing/selftests/rdma/config                |   2 +
 tools/testing/selftests/rdma/rxe_netns_names.sh    | 334 +++++++++++++++++
 181 files changed, 4664 insertions(+), 1633 deletions(-)
 create mode 100644 drivers/infiniband/core/uverbs_std_types_comp_cntr.c
 create mode 100644 drivers/infiniband/hw/efa/efa_ah_cache.c
 create mode 100644 drivers/infiniband/hw/efa/efa_ah_cache.h
 create mode 100755 tools/testing/selftests/rdma/rxe_netns_names.sh

--=20
Jason

--rviEvjDxO5JFrj6g
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRRRCHOFoQz/8F5bUaFwuHvBreFYQUCaoeh6QAKCRCFwuHvBreF
YdTqAP9m5YXsxy31RQQeMu9Oq2hQtuRPOfPHwqWAP2BwHEHXAQEA/NSLZqkfNz6v
lGborYhJAi3XiQVpf4kqXXW1jjSHmwk=
=d5Jk
-----END PGP SIGNATURE-----

--rviEvjDxO5JFrj6g--
