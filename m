Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010022.outbound.protection.outlook.com [52.101.46.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C0154DAE4;
	Tue,  8 Sep 2026 13:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788874277; cv=fail; b=WV6Vklo1xnLjAwVIkmWH8qJV6fDrI1gRV7WjupZuxZxE02WBC/v4XtRkzGoZm8d1pThnj0rKhIeCZ+3dYztaCq1WEVqp/LRFn7U5MpHSDsgY6QF5t2YS0eILBmmpMzpdcBs7RwU9UwIY+Zsa3PpO2UkoJxS3Li8g97U8Cq+KE6k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788874277; c=relaxed/simple;
	bh=ysJtFLi8JhtSl9G2hGVvAQ7DHyJr0yvt3Z+sUaq1DMw=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B7OEG5Oadip5e76n380Vl9p8KHiJzT50zUb5Z2b4MEfmbTkr4HEM8nvMaPGubfaqy43TFoQTtthpL/yw+EppSOEo/AnESzMxnrq7dstBgOWgZhpp6knp9whixtNmQSXLr6+wdOroXYTEI9hk5Rajk31wokeTiFEVNo2YT7z2chY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Xh5MoyCy; arc=fail smtp.client-ip=52.101.46.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Xh5MoyCy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GpZkDW4rgLJJjcsX/A5KUcqi/cC4GJR8iG6KiOXibLVNH/0NfXqy19lmAMNn3lNk+8E9zhdSVBK4WzN/L20TMdAVkRE5UDKSt8UzmXVdn5ez3voXcntSBIo4Q+hd3CKEq43kf1lfWo+l4w33QoMV+zfOv2AbiMFmyLF/r0vFfX4+Cl5nfe8yy5QfW7iTXEdAUnoxdtuUf8fdev89bDzkwStQKV9CqxhgJdbuPKyf6RMqAr+x8OuQ3q/57tC9cdfAJ7cyDU7LG+ar0mTavoPldHgD/90LrNCL9ogWZ0eR4soVyCqL3uHAXbdZXn6ZCLLiLd4g6ZLFmJmTSoCM4QOazQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZJPK8ZnqKSBuuThFYyjcAEh9hXWCdhLgwQAiKewxkU4=;
 b=LZkWMaxFM6z3hymP3b0IrxD367WTZTO1vFt51JTsTOo8Qr8O3MIGvguyWM0Q/lkFMfPB3LJlBT0fRtmOQHCvE87rGKGFPsuql07AF5P0WR27TkA7EKPuACVSTM63t52F9FyMWSvZmAarwa+TuYNcOpR/7nYXARLi2dWVt4JBhIIq0ZiNbSts3MTgp3ixZEiPtt4vMYf4ng7CV4fDkgC8gLb80B6POnS9/VeTo6PhWdy95CUkJPnWS/OObkwzCx4rqAcgKFLk/sYQpXCZKr3kChsSnonTZUAz2nPKVUQKS/ObmwNgdjDXe5yY3QsHm3+sDvw8vemnvAt3w4k+9YBVHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=broadcom.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZJPK8ZnqKSBuuThFYyjcAEh9hXWCdhLgwQAiKewxkU4=;
 b=Xh5MoyCyOb0+V+9KGlmSHvjqINE+b9V8nFHOo5yY/e+8HvE4uX/nEPfhKNb07m5hWWFz6754kyOw1tt85QmfnXPrfvERpWVDtXL6IrjlukOnJ4IrGCEJ91jHWA2SKRg7T5y6JXysKUGmRRyscGY916O0d6WV9iBygaHDy50Z5P2beqIixVBquBdo3jaPueFbrnQIZvMZlouq94ywoRvMco0vLlft7rRLnbnra/bboqbvUhYobNu2nNOFIV/OXkg7U9VCbcTymr5t+YdsNUrLv3dU40c4JJZ27BAFHrWnCa8VW3kXld6d+tmzyRCKMAKYhuXBI4mebmG8cEqdT3x3ig==
Received: from CH0PR03CA0389.namprd03.prod.outlook.com (2603:10b6:610:119::28)
 by PH7PR12MB5950.namprd12.prod.outlook.com (2603:10b6:510:1d9::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Tue, 8 Sep
 2026 13:30:48 +0000
Received: from BN1PEPF00006000.namprd05.prod.outlook.com
 (2603:10b6:610:119:cafe::6b) by CH0PR03CA0389.outlook.office365.com
 (2603:10b6:610:119::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.7 via Frontend Transport; Tue, 8
 Sep 2026 13:30:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN1PEPF00006000.mail.protection.outlook.com (10.167.243.232) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Tue, 8 Sep 2026 13:30:47 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 8 Sep
 2026 06:30:21 -0700
Received: from localhost (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 8 Sep
 2026 06:30:20 -0700
Date: Tue, 8 Sep 2026 16:30:11 +0300
From: Leon Romanovsky <leonro@nvidia.com>
To: Siva Reddy Kallam <siva.kallam@broadcom.com>
CC: <jgg@nvidia.com>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <andrew+netdev@lunn.ch>,
	<horms@kernel.org>, <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>
Subject: Re: [PATCH 00/15] Add BNG_RE control path verbs
Message-ID: <20260908133011.GN13683@unreal>
References: <20260904104328.763768-1-siva.kallam@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260904104328.763768-1-siva.kallam@broadcom.com>
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00006000:EE_|PH7PR12MB5950:EE_
X-MS-Office365-Filtering-Correlation-Id: 46376aa3-77b1-44a4-ba1d-08df0dad6497
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700016|7416014|376014|23010399003|6133799003|10067099003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	K2GAkPa/DLbGpXZDxzfYl9xu1alkiGkuaG1phiVLNlUE7WMOmFG1+48rURQTiHFL841OK+eiCvI3F4U4gACXse05aiEffAJXHBsNXrbFdUcMdLQDlZuHF4FeEhtbiokfUSupTQqdNwHnl8X4ej+n59axowjQSIm2eC6kW9w8Y7jdEMEtD3QMkOlfNGfIc8XUqaKrFj2Y36yfmG7+wApqlJp3ETvflmWEAGLUoEx3oth4LwUhzP9V7BXK00Az/10hrXOsS59MEH0Cj0nORGGJfxGp6wFS2eVN+oRHk6kjJzoPccsnD9Okuge1slDgdUOumM3iI8JucXrNzwkDhz+mFKaopjyLqYpH5R+E0I/HNtTxcHnZVWSzpqlPYnrm6aSry2MrmcxzyvfLLmhkjaPrlf4BpKirnAODhkuMogmDwjrdAc5E/TNKhgnXQKL4BiBLBoaRSav2q9Q8OvpU4qTQ/fkJI1MHr1RBip4FUJo/QbNaGhe2jE6t/CxRe4ilBFo+oKJeE3siK1u5dsLlsV01VCHO3RPo9CbbxUns9l5I1thdRFMpYZe4LmB9iO+ogD41V2iqmuGeC/kAdS+ikCKCjtC30RcdlNkv7CWCLLkOYFBihk1Evf7m2a7GiJK6zujpUaaemG9NyiJMfDjEkBuG8Rxs4zXAlgc2D9pc0rbJRCSmwc/45qsce9phNCgaHT/Xz1C44wdhkBYfZoRX7f1Pzw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700016)(7416014)(376014)(23010399003)(6133799003)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	TYKW94gfJVtfiMgWLnm/C0TulhHAFPS+1LzO1t0kNT7X/vr6ziZ4Mig6hmhywbvWrTijv8w60/FjIf7+E/mmFLRpMZhwpZ/xdZUBm+WQ7SACwLIkc5eGzJA7l2HMnxjgrLob2jb0WXVcj6thHiQGtZdeTkni2O11XjRoWXSkkvUGb95ZTJCjgcmZDHqeXzyDDiiPsuhbQ9i/izK9QnnzHkPZwXbM/coX3TjNwylL5mU902Xa2ghNJtk7Tvw1NG40v1P1iqo0CpHvS6EZDCSLsnJmbVUurY7ERYTpj4cP7TVADoqNJ0eSY8EIB3n9/WmnA1di4DWHo5o32y65fLErSosgRkFhjLKMTBsUiFUFrP+d8iDbHqdtmOCRRjfcywxNtYV7eW8Q7+2AEbh/rexaBBIPiOoJdx4HP2anRs+P1WSDvfDCoZHHoFZ/DQUlA2ZW
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 13:30:47.6745
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 46376aa3-77b1-44a4-ba1d-08df0dad6497
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00006000.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5950

On Fri, Sep 04, 2026 at 03:43:08AM -0700, Siva Reddy Kallam wrote:
> Hi,
> 
> This patch series adds control path verbs support for the bng_re
> driver, along with the corresponding bnge driver changes it depends
> on.
> 
> Fast path verbs depend on a specific HW resource configuration in the
> bnge driver, and work on that is in progress. We plan to submit fast path
> verbs support in a follow-up series once the dependent changes in bnge
> are pushed and available in the rdma repo.
> 
> The corresponding rdma-core user space library patches will also be
> published shortly.
> 
> 1) bnge: MPC infrastructure change
> 2) bnge: Update New HSI
> 3) bnge: MPC ring reservation change
> 4) bng_re: Add RoCE MPC infrastructure and xid manager 
> 5) bng_re: Add support verbs
> 6) bng_re: Add ucontext/mmap verbs
> 7) bng_re: Add GID verbs
> 8) bng_re: Add PD verbs
> 9) bng_re: Add MR verbs
> 10) bng_re: Add CQ control path verbs
> 11) bng_re: Add SRQ control path verbs
> 12) bng_re: Add statistics verbs
> 13) bng_re: Add AH verbs
> 14) bng_re: Add QP control path verbs
> 15) bng_re: Register device operations with ib-core
> 
> Thanks,
> Siva
> 
> Mohammed Faraaz (1):
>   RDMA/bng_re: Add AH verbs
> 
> Raqib Jones (1):
>   RDMA/bng_re: Add MPC, XID management, doorbell infrastructure
> 
> Sachin Holla (2):
>   bnge: reserve TX/completion rings for the RoCE MPC channel
>   RDMA/bng_re: Add GID verbs
> 
> Saswati Das (2):
>   bnge: Add infrastructure support for RoCE MPC channels
>   bnge: Add HSI definitions for 64-bit doorbell and MPC channels
> 
> Siva Reddy Kallam (3):
>   RDMA/bng_re: Add ucontext/mmap verbs
>   RDMA/bng_re: Add CQ verbs
>   RDMA/bng_re: Register with ib-core
> 
> Suresh Rupanagudi (3):
>   RDMA/bng_re: Add PD verbs
>   RDMA/bng_re: Add MR verbs
>   RDMA/bng_re: Add SRQ verbs
> 
> Usman Ansari (2):
>   RDMA/bng_re: Add support verbs
>   RDMA/bng_re: Add Stats verbs
> 
> Usman S. Ansari (1):
>   RDMA/bng_re: Add QP verbs
> 
>  drivers/infiniband/hw/bng_re/Makefile         |   16 +-
>  drivers/infiniband/hw/bng_re/bng_debugfs.c    |  308 ++
>  drivers/infiniband/hw/bng_re/bng_dev.c        |  269 +-
>  drivers/infiniband/hw/bng_re/bng_fp.c         |   38 +
>  drivers/infiniband/hw/bng_re/bng_fp.h         |    8 +
>  drivers/infiniband/hw/bng_re/bng_fw.c         |    6 +-
>  drivers/infiniband/hw/bng_re/bng_fw.h         |   27 +-
>  .../infiniband/hw/bng_re/bng_hw_counters.c    |  304 ++
>  .../infiniband/hw/bng_re/bng_hw_counters.h    |  118 +
>  drivers/infiniband/hw/bng_re/bng_mpc.c        |  574 +++
>  drivers/infiniband/hw/bng_re/bng_re.h         |  275 ++
>  .../infiniband/hw/bng_re/bng_re_mpc_roce.c    | 1861 ++++++++++
>  .../infiniband/hw/bng_re/bng_re_mpc_roce.h    |  218 ++
>  drivers/infiniband/hw/bng_re/bng_res.c        |  299 +-
>  drivers/infiniband/hw/bng_re/bng_res.h        |  321 +-
>  drivers/infiniband/hw/bng_re/bng_roce_hsi.h   |  317 ++
>  drivers/infiniband/hw/bng_re/bng_sp.c         | 1965 ++++++++++
>  drivers/infiniband/hw/bng_re/bng_sp.h         |  458 +++
>  drivers/infiniband/hw/bng_re/bng_verbs.c      | 3211 +++++++++++++++++
>  drivers/infiniband/hw/bng_re/bng_verbs.h      |  379 ++
>  drivers/infiniband/hw/bng_re/bng_xid.c        |  110 +
>  drivers/infiniband/hw/bng_re/bng_xid.h        |   26 +
>  .../infiniband/hw/bng_re/bng_xid_allocator.c  |  870 +++++
>  drivers/infiniband/hw/bng_re/xid_allocator.h  |  114 +
>  .../net/ethernet/broadcom/bnge/bnge_auxr.c    |    1 +
>  .../net/ethernet/broadcom/bnge/bnge_auxr.h    |    1 +
>  .../net/ethernet/broadcom/bnge/bnge_resc.c    |   32 +-
>  include/linux/bnge/hsi.h                      |  161 +
>  include/uapi/rdma/bng_re-abi.h                |  118 +
>  include/uapi/rdma/ib_user_ioctl_verbs.h       |    1 +
>  30 files changed, 12356 insertions(+), 50 deletions(-)
>  create mode 100644 drivers/infiniband/hw/bng_re/bng_fp.c
>  create mode 100644 drivers/infiniband/hw/bng_re/bng_fp.h
>  create mode 100644 drivers/infiniband/hw/bng_re/bng_hw_counters.c
>  create mode 100644 drivers/infiniband/hw/bng_re/bng_hw_counters.h
>  create mode 100644 drivers/infiniband/hw/bng_re/bng_mpc.c
>  create mode 100644 drivers/infiniband/hw/bng_re/bng_re_mpc_roce.c
>  create mode 100644 drivers/infiniband/hw/bng_re/bng_re_mpc_roce.h
>  create mode 100644 drivers/infiniband/hw/bng_re/bng_verbs.c
>  create mode 100644 drivers/infiniband/hw/bng_re/bng_verbs.h
>  create mode 100644 drivers/infiniband/hw/bng_re/bng_xid.c
>  create mode 100644 drivers/infiniband/hw/bng_re/bng_xid.h
>  create mode 100644 drivers/infiniband/hw/bng_re/bng_xid_allocator.c
>  create mode 100644 drivers/infiniband/hw/bng_re/xid_allocator.h
>  create mode 100644 include/uapi/rdma/bng_re-abi.h

The series has received plenty of comments from Sahiko. Please address
them first:
https://sashiko.dev/#/patchset/20260904104328.763768-1-siva.kallam@broadcom.com

There is little appetite for accepting this series only to be flooded
with AI-generated fixes afterwards.

Thanks

> 
> -- 
> 2.43.5
> 
> 
