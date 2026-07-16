Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013037.outbound.protection.outlook.com [40.93.201.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF574398E4;
	Thu, 16 Jul 2026 17:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784221425; cv=fail; b=HPV0p+Nb5cHiA9y+C/kOAQnnmtL3zOsVsa40iYco8wl4is1EpLmcgvlIa30Xs2YLtXh1iwZoJpfhGWK7zgmU1wMknvQlblUZ39L9iRSh7sgTu29duhNtqFJaGLGaRftjLE2jbY6MrtfOdOV25NlzkbofOX6aq0FqACqC0ZF1MhE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784221425; c=relaxed/simple;
	bh=fL7MmYYtDHI50oLl+OTQF5wlNaHX/e5K0SYRBbDMpvw=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=t7AiMp52GrV4068+74Hkeh2A8l3tGgTnvuxo+3CoXgJ7J/5Fa6RahcKpsUgp4wR5UHSDCmcntJsX7RFZfJrlvEi2Rjt6V8sceLRmcgaeInGrtoVFri/3+H2rS5FCmlsVfwSVh1fsiiysHwA5+LEAVm+enLR24ZAEQO6IdXdvBy8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=l7bS4ADf; arc=fail smtp.client-ip=40.93.201.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="l7bS4ADf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FTvx1LtrqsnhdRX05WAXPrUiLy1pqbviLcaZBAUyCoW0ZRvrAYAzb2tCWWa5WT75jasAoWy3yTt+U3M7CLHKbOsQAxczyJOYtp6iLWjOM4Pn5CRTz8ArY4etO0khvD/Ytcbbw9n6cftzmiZlZGxx40BvP3vNOVk1nsavkGsEcJxo+6YuMdjfDMHj8qhJ5bj31tg5/J0zXH+KSdxsykBpgvkmpbUQKF0tLFVW5OuCb49goTMXF39RXi+9UeWdniB1EDtHo5SXcvd2rlNLKoozT1dE6MmfH3UFRGBGnefXx0jl/J7RHOzxaJn7+ZFPen85UI0/XcS6M1tDJJUjKKPx+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+KapgIDlW1l6ynCP61jC7XbJgfyU855l72YavbZnnUc=;
 b=VaChPbBmkxO17+WR/LBGDLr0E0CHMMVm0FtiGNZnh5tGZ47m3udJEAu6eWsiwpnUJRpkJuFd7jVMqMCiq1LTLmAn+7EVycUM/6vsq/deHJskLj9ZtIJE5c1QmVK0ypb3M2G0NJTNp4uXDbpVtNcGI+sGwArFWamIfYJC63JAVLe+387tF30tSrroIqXNlcgqlCqpQw6Uucr4nv5tFA0XQKIhRpanZuIvDGgim52Q8SmfvibVX2qP2A92ZS62gCQJYah+4Od8h7HWrFIkqmkD3qJQ/Sl8/WmYj2K9bnhf4JgfTJoz6mS0sTmVKm4T80ZHhKkN1hwPZsTqCYmFQWDJfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+KapgIDlW1l6ynCP61jC7XbJgfyU855l72YavbZnnUc=;
 b=l7bS4ADffV9oAhzy5Em/Dw9HyAj1LU3Bbxoan4AAvVopYOUivDyRuJILnVlaztstsJ7nPV5Pj690oDGrYbG4BfJVeuUaZE8C03QOmu9bLmMtUck5qHodtZEW3gY0JUkT4Vsm2KBf4FAXvi2r1NxgjFSWDgF1Tqmh1c8cWDwXE4ZKPYephUliJrqlP2PlSKMj96zRy29Qm20Ov46lx9dkDwL/Qe6YQcM96EBTiiWrMnS5+H/iVAnfNbauijffR6xs7rMeXq6YkcxPvC6DpZhgwD47yEfqgD6nwGXsP1J3IUEEjAQayWrwJeYjVivMqhk/ITGVNNlus0i9ki2QuOlNFw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CH3PR12MB9731.namprd12.prod.outlook.com (2603:10b6:610:253::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.18; Thu, 16 Jul
 2026 17:03:29 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0202.014; Thu, 16 Jul 2026
 17:03:29 +0000
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
Subject: [PATCH v3 00/11] mlx5 support for VFIO self test
Date: Thu, 16 Jul 2026 14:03:16 -0300
Message-ID: <0-v3-76f117ad04f1+28a90-mlx5st_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0086.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:84::34) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CH3PR12MB9731:EE_
X-MS-Office365-Filtering-Correlation-Id: acc5162c-4d50-40f4-efbf-08dee35c2856
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|366016|23010399003|921020|18002099003|3023799007|6133799003|10067099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	Pg8PsszWwxwhL3XAY/EUVTQ4BWXQk8PvgT18yL+3Qu/Qt750vkEM0IUROKxk9yZ/IurVhQTD1/Suji8HJ4K1/nBStLVpGRaJUN5xnDjd2QgHmprR/thiUs9bFyGFXfYL2ukpBmsRdElFMqd2NUcW/8+UawIaeI1VVvRHpfDvSIY9EOlG2WswO0HZon2pWNlxTWxG0KvoawJuBDR3qsm2KG8viERS6GyqfTKmiM3ZNxIfp/kucjTcDQgxSOQ7x1iusW7p4pONuXr9L5F6ga0C+wzIsnGS3fLGiBtDkeBlE/HIkJjC2MQnLYfWlN96Ia5oqcXzmLP+CaeZuP7CgbPBqegA93ZgeEqzxEUaVZd3Zv9sEmrDE4KOScoFnxsdB5h5IXZjxZOIv06nNQf1QOdF3loufCO/UKr0vpdloK8F+pX6BY5b+UJbh8PE6KqIM0IRMJjnYNQHxaMGN1Mt1+fhO6F+lakOXgjUcT4sVHAnj9+OK4QyfF5uot6uhd47guaEkvVtfceAv1WP438KiEBS1BJMunGVHDUZUaGodNfeqcAAGEaTBasaNsMLtJn/JpJciIWZRlxBR5BoYDIbdo7QcSd+3c4Fxt7bMSZLPOwQ1XTozs5FsjW9i4Z6897DaPN/78a3YlmYBeVJP2a/tAr31kr5AJaf8f0dHbqVVL9V82gEdwPwgkLFfJyYSs4UFzcWnm01W+ph0G+N11vdJqB7HQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(23010399003)(921020)(18002099003)(3023799007)(6133799003)(10067099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?amZdmTmEvYuJVxxt/KN6+chaLucTDwRFjTvjsmu55BBU3NDQoPU2sFMt8gfI?=
 =?us-ascii?Q?jt6oFTpozjuP+yLvuibLbRwEILF0sq/Wy26NqSEovRk6nhnTlaJ1NYLtdlXe?=
 =?us-ascii?Q?4l8/s5iWinii9gIwE/dQz0ey6sN7GgymXgpdMmnyRlBTmy6+djLzTeZFayeD?=
 =?us-ascii?Q?m3HXhPWVJWMscbIbEyc6UTPF3Kc63CDAU9ScTnvr/Vw9tlWQja9RC8jTzXqW?=
 =?us-ascii?Q?rKa0klheOj51SoTxPJL5JgbwWIVZ3w5S6b56ST5BBvAoq1Retchxf+wszNh4?=
 =?us-ascii?Q?XwyFu0UDPBTmlF4kLpnBmthQzTJHC+EcBwMtv80mmolvWoUxJh55OEaNmZS8?=
 =?us-ascii?Q?Z+JFSOU00N3WWXwrtEhWVaepATF7e78elIj8xGKb/WZk4SU2JQKPJpPrRwkw?=
 =?us-ascii?Q?kVGs3aYQHV3Xgd7CyOCtiV7iOy+WsJ9q2ELnE2hfNkO8CGi1SI6n6XCRIJnn?=
 =?us-ascii?Q?q3+itirD0K1rZHOU0Ul0YR2QCcw3j1QhXlobO2aBiv2GUcbjEQrHJJ2jR18d?=
 =?us-ascii?Q?nqmRHD2XQhDIAUYzuK07Mbq/x9dSpJ4hJb5oxicTBuS/64iYK+8B8EX/QV0W?=
 =?us-ascii?Q?gdPSUIOGG+4kHTvbEez0z8hoXUjoxDqkktkaE01UAWHla0ZwrkgXlCEtKaOe?=
 =?us-ascii?Q?C8gN01CLAxgHnOMvN7w1wXNov13C+uoYxK6HhLx7dKKnHv1lx1u9JtII7lYi?=
 =?us-ascii?Q?K5UYtyRbBZQEi7fPAuHoXwKc3/S8jVBooZQA/ApgZAso0iutOO0Fo3U4y6zV?=
 =?us-ascii?Q?FBa+65rlhrPYO/t+29qxSxvi0w8EwrmTLcuotWAkwRrTiqHnMk5+kO3A2Ncm?=
 =?us-ascii?Q?6q38FLwFzQhPHOVaCw905q1ZOdd+3rDEyPN69vf61FUXgxmjaWuc17IVnpNV?=
 =?us-ascii?Q?6X1lJFGfJOw4KRsccG9eYRRj5Fx2zNnTSleFl2Tk9Sqig6AcYceHuZMLyPNX?=
 =?us-ascii?Q?yOEut18QmdW81xaLkTADzvvYswg/dNx2xEEL/7lJBIEMWXqwVaYR2nMYoLoE?=
 =?us-ascii?Q?bhSg1MTvZrhEf3aWg+aypLtWC17/UL///3Q5h/BZlSZMQpSMAs6ZNEPOWqC2?=
 =?us-ascii?Q?2qiYHw+ibzBUFCo6LMQhRudvWOEjGB/AhmI8KEy42gzfxGPJd4oEvusRsWaN?=
 =?us-ascii?Q?aT/WkLuj4ncD3nQzr4l/sNkrlrwO1hcZf50UsCQLWWp8gyDPy/mbfAUn+peq?=
 =?us-ascii?Q?Cki+mg+3v7HYsWW3bEZzH02eX0xp1j7GOILVJL6jIJf284XsLECiRqAM9+Tq?=
 =?us-ascii?Q?lBaH2Cf6fwNHtQDEHKM0+m24NgR597wqz+b9vWuy3M6BANxbF0W+VRZdvAOI?=
 =?us-ascii?Q?M12axjJd5xhI/Bi20/Xq8agxs9zPOOanwNdaiXkvBUg3+gcsDD9iTttnKqLX?=
 =?us-ascii?Q?GIXpV0ndU0uo+lsro4kgQqknYjbns/43GS8g7eAJXuVMGkZw4WFk/5hpjs09?=
 =?us-ascii?Q?Zn1GIKg7dXKpct12eIV3bZPW/u1z3Bo3NIQWjval4iFjB8LgJhPJ5/Ci2sv+?=
 =?us-ascii?Q?xZ+LpBBvKy3ANWGW9Gl7s5LmLX/ad5VbRLbLxMJcTLVNjpGr5WxIDjN8QU/A?=
 =?us-ascii?Q?p3/j2vqg0iFT85Ew30K34Hb4RTRlSRy9oXFThA+H3yFqnVERYHM2UpI2Lg8D?=
 =?us-ascii?Q?hL2t1Vc+hMT4XyW47vxdcpNPUe2hh2PCmUQ2kyNdcPFiQ9/3yKzBrtN/z7F+?=
 =?us-ascii?Q?veTCbMBSGKv+jt90ZDkaZwF9oVu5neNagcftLRoZdNz41BoI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acc5162c-4d50-40f4-efbf-08dee35c2856
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2026 17:03:28.8873
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dkvc13b/GRPywpSg9BV7Ms2kBO2/gGIzleEihurGkywcHwmDH3u2SqRe/4HYt15t
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9731

Add an mlx5 driver to VFIO self test. This is largely a remix of the
existing VFIO mlx5 driver in rdma-core. It uses an RDMA loopback QP
to issue RDMA WRITE operations which effectively perform memory
copies using DMA. Since mlx5 has a stable programming ABI this
should work on devices from CX5 to current HW. The device FW must
support the QP loopback configuration.

Also support send_msi by arming completion events of the RDMA WRITE
to trigger MSI delivery.

mlx5 device startup is very complex and most of this code is just
booting the device, with a smaller amount for operating the QP.

This entire series was coded by Claude Code in about 4 days. It
used about 4.5M output tokens, 30 individual sessions and 5600 lines
of AI-generated .md files. I spent an annoying amount of time
de-slopping and cleaning its work product to make it presentable.
However, previous VFIO drivers have taken on the order of 1-2
months to write, so getting one in a week is pretty remarkable.

For those interested, the flow I used was broadly a prompt sequence
sort of like:

 - Hey Claude, go look at the falcon series, VFIO self test, the
   mlx5 driver, rdma-core and some PDF documentation and make a
   plan to put mlx5 under the selftest.
 - Write an rdma-core application using the built-in VFIO provider
   that can do the required memcpy operations that vfio selftests
   wants.
   (This resulted in a 1k loc C file that compiled and ran the
    first time but had a few bugs related to device programming
    that the AI resolved.)
 - Replace the rdma-core components with open-coded versions to
   create a fully stand-alone program that does the DMA memcpy.
 - Review and audit the thing.
 [Pause and de-slop it]
 - Make it work on a PF too (this is surprisingly hard!).
 [Move to a kernel tree and copy all the .md files and .c program
  it made]
 - Hey Claude, look at all this stuff and make a broad plan to
   actually build a VFIO self test.
 - Here is my 1 sentence advice on what each patch should look
   like, make a detailed plan to make a patch for every one.
 [Pause and polish the patch plans]
 - Execute plan X then commit it [pause and de-slop each patch,
   repeat].
 [Review and final polish]

v3:
 - Move max into vfio_pci_driver_probe()
 - Rebase on v7.2-rc3
v2: https://patch.msgid.link/r/0-v2-72e9640932fd+2c64-mlx5st_jgg@nvidia.com
 - Rebase on v7.1-rc3, drop falcon patches
 - dev_dbg checks the format string even in non debug builds
 - Sort includes
 - Adjust comments/commit messageas
 - Use linux/pci_ids.h
 - Compute the driver.max_memcpy_size the same as mlx5 kernel driver, it
   should be GBs now on most devices
 - Put region_size into all drivers instead of allowing 0
v1: https://patch.msgid.link/r/0-v1-dc5fa250ca1d+3213-mlx5st_jgg@nvidia.com

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Jason Gunthorpe (11):
  net/mlx5: Add IFC structures for CQE and WQE
  net/mlx5: Move HW constant groups from device.h/cq.h to mlx5_ifc.h
  net/mlx5: Extract MLX5_SET/GET macros into mlx5_ifc_macros.h
  net/mlx5: Add ONCE and MMIO accessor variants to mlx5_ifc_macros.h
  selftests: Add additional kernel functions to tools/include/
  selftests: Fix arm64 IO barriers to match kernel
  vfio: selftests: Allow drivers to specify required region size
  vfio: selftests: Add dev_dbg
  vfio: selftests: Add mlx5 driver - HW init and command interface
  vfio: selftests: Add mlx5 driver - data path and memcpy ops
  vfio: selftests: mlx5 driver - add send_msi support

 include/linux/mlx5/cq.h                       |   10 -
 include/linux/mlx5/device.h                   |  231 +-
 include/linux/mlx5/mlx5_ifc.h                 |  178 ++
 include/linux/mlx5/mlx5_ifc_macros.h          |  185 ++
 tools/arch/arm64/include/asm/barrier.h        |    4 +
 tools/arch/arm64/include/asm/io.h             |   20 +
 tools/arch/x86/include/asm/barrier.h          |    5 +
 tools/include/asm-generic/io.h                |   28 +
 tools/include/asm/barrier.h                   |    8 +
 tools/include/asm/io.h                        |    2 +
 tools/include/linux/stddef.h                  |   10 +
 tools/testing/selftests/lib.mk                |    5 +
 .../selftests/vfio/lib/drivers/dsa/dsa.c      |    1 +
 .../selftests/vfio/lib/drivers/ioat/ioat.c    |    1 +
 .../selftests/vfio/lib/drivers/mlx5/mlx5.c    | 1928 +++++++++++++++++
 .../selftests/vfio/lib/drivers/mlx5/mlx5_hw.h |  114 +
 .../vfio/lib/drivers/mlx5/mlx5_ifc.h          |    1 +
 .../vfio/lib/drivers/mlx5/mlx5_ifc_fpga.h     |    1 +
 .../vfio/lib/drivers/mlx5/mlx5_ifc_macros.h   |    1 +
 .../lib/include/libvfio/vfio_pci_device.h     |   11 +
 .../lib/include/libvfio/vfio_pci_driver.h     |    6 +
 tools/testing/selftests/vfio/lib/libvfio.mk   |    2 +
 .../selftests/vfio/lib/vfio_pci_driver.c      |   10 +
 .../selftests/vfio/vfio_pci_driver_test.c     |    3 +-
 24 files changed, 2525 insertions(+), 240 deletions(-)
 create mode 100644 include/linux/mlx5/mlx5_ifc_macros.h
 create mode 100644 tools/arch/arm64/include/asm/io.h
 create mode 100644 tools/include/linux/stddef.h
 create mode 100644 tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5.c
 create mode 100644 tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5_hw.h
 create mode 120000 tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5_ifc.h
 create mode 120000 tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5_ifc_fpga.h
 create mode 120000 tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5_ifc_macros.h


base-commit: a13c140cc289c0b7b3770bce5b3ad42ab35074aa
-- 
2.43.0

