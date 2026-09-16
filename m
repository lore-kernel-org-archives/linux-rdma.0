Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011005.outbound.protection.outlook.com [52.101.62.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 198555013B9;
	Wed, 16 Sep 2026 23:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789602643; cv=fail; b=Egkv7IpLWPey7wfeQOyBz/7UlQuUyOUjy2V34JU9XiUffH1fwpJJmvzJBy3EpWRla48EuiKNbvMG9yRGKLMTIG65w5pCjImf/AP6sIvsmbYq0u1WzPEL8loyDFtf6/m4X9vCp5B+VKcnZX5uNMy8OR+a64ZD0S2jhWm1uzPIXR4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789602643; c=relaxed/simple;
	bh=UfcYrdEEjTPjgAV0jp+B5djlFBDLYq88639IPHoM4gA=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=jOOfmulPfKImWXnilaOFkTYStpM60lUVTBb10LjWbJdEQoU+M5Y2pwUknm2Ez/wvYw4nrWabVQqwBsUgSgI21vtwYw5z5sPGeDy1SansZ5JRZmBu7uNS6w5c2iCePxycT3ZErlwcrd7H2akGseIgO1W3X2wAOTiVP5XxY4NZCYk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=k+epJGbN; arc=fail smtp.client-ip=52.101.62.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="k+epJGbN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wDkseqEk7Mee9eeyEdYhl0b87KNtq1tDs3MPp86jDAfRh+9B12rud9A1czXBRTwOdhhx45cZZo2rlJzbIg4wo/99v+U2wjZ6CjS+Z+P8qCOIFiHGRF2CbQUhqaLLuYZ10iuBcoyKhe9zuYvVZYMCnMODt81Z+J2FrdjGHWo6W7/UnBx89QIUJL5yM18Pmau49tgl2KA/Vj79/+fW2p75ogIRT7qEBNXQoJa+bqKrE5HSibcI0CcnOyK48CA4dwxZOQQ4MeCO3bg8s5fxyTJap37ab0nQ5ylubYOUK6/tqZi216ouSsgy140cLU4m2D6eIg4TIVNJLCDMbsWLHNSKvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N4ELZApdgCYwKoE9nuLd68Yv2tEHsnuFqFQ/QV/1sV4=;
 b=vBx+y6cHsogcMU5gMDKeNrYbJP8r4UXjEDL7LmgIlPo9kbsqsbHa4txrOv1H+e18XPzcgq2QxZW0L1r8dnh/wgNjkU+sY+l7WryP9QBVSpc9lzVMRwxPpbg7BzSnLI0tSB97uMBj2DSCMbOcWVr2qJNwlIwMnj3CU2ELtS4rkxEGcN1OWNcazsLjtwkOTBqybutfYk3lQNHqB7GG9Km4vCM7tsFuzDYjvOiFC4Ik9Dx2+oo1h7OlQg5MxVVJPIWl57b3UeImharYe+k2ZjG7G962qSg7ManfPmpyRYfUpNMtA0GP0KV7uHx1ZmzviVZncabW52egmmBG2RdwYxCTGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N4ELZApdgCYwKoE9nuLd68Yv2tEHsnuFqFQ/QV/1sV4=;
 b=k+epJGbNZLUwmeEE/XGGtVIfuje+0JfcASsioJ0gLPnddy9mXEQJiAkCeFjlyCGd/XnZpNZTaHEQiJr9sj2x1hX/Hlsmx2c/DaVwTAxvvSzZnj5b63dvxcx89buCLMyFqm4GbgubYFNxsFcy5FBB+bj1oLnHlo28Yy1IZAh2EUO2tDq2cET8T/55fFTegPsggIU+BR3pteHE1bQ0a9qREU2QFamZfQ+enz/uuoYmsJ9OBAKoLKRN7S7jS3ddH01jO/BHoSrDx6RFW5NYhW/akFVvUQL+aGba78QXsEbFe9TJoxngEFrVKaiznOUivrJHTu60io2JsGux0CIjNlX3zw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by IA4PR12MB9787.namprd12.prod.outlook.com
 (2603:10b6:208:54d::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Wed, 16 Sep
 2026 23:50:01 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0428.011; Wed, 16 Sep 2026
 23:50:01 +0000
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
Subject: [PATCH v6 00/10] mlx5 support for VFIO self test
Date: Wed, 16 Sep 2026 20:49:48 -0300
Message-ID: <0-v6-8af36cf7b73f+e2-mlx5st_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN0PR04CA0007.namprd04.prod.outlook.com
 (2603:10b6:208:52d::12) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|IA4PR12MB9787:EE_
X-MS-Office365-Filtering-Correlation-Id: f364323d-8ec0-4662-8074-08df144d383f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|921020|6133799003|3023799007|10067099003|11063799006|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	FulYhCJPGrTtSNmOoysgx0lVuj448brslYiWzqPzQq+zjB9A0VrkP5Hu7ytOy8gm08Fq5GIo7vWyJ9KRvi6freZJY1fETENgqfnmnQuxTPPk2G3ybUoBXFNOnKl1wnRAciGUYuYf34pBjeFghPVlJQCPInE5hU1DjcqsVNItx6F53Diw0Qsgt82VFwHL9cshMMrvsiJilr5dHaq28q1OAo082NjCF4sZNHfCRtRjB0gkl0z8xaj8v44fIt3HAnqsXai3H8SrSGY8/dIyxmoVTqscqY0XPiqA53doqzdTFnyOm+0A521RfWuyYQtLWdXOP7kotNCispWmv1Zh5EcdnJvyc1ZH1WrSD1YMS8PhRM/SbOOXr8l9Xob6xfUv9JDe0C/FaktUyBp6N8i1ouQg8QwP9c2XM3qu7u77ghPKg/f8DQkFt0sFOmva03YJim6updP5vilIiz0rdRSsfLGo+2LiAlJhmc6ApnnfSg32QeTEtY+TVYRIvNJH7JH9QQJs8VdLNpcuCoDsXWLdvLS0iuDv0VW0bcolJdBOLmn/OB5v4A7BrtwWsJyeAodjP8pdXcTxBU10gTx3rDzfM9y/gMeuB9VSGYaHCL8XRsoKPB+N3FGGE1bq9huDCLzCEY6FgA9WWw02TfgOVhS9klg+gA8cy1SuyE6LuVZAB/0ZaFP32Th1OCjn2KekXFRRJoCSF5i5/0CscTVcRSOHGJyxKg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(921020)(6133799003)(3023799007)(10067099003)(11063799006)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?B7F5O38nHhaberKs6NhUIznZTXF0MmAsPdY3oHfwP/7XC6Bdj6y2kTMzdtTD?=
 =?us-ascii?Q?41FzVjuzmLWY0DK4zKZ5hQVuXBD15ACEq0lICxLhpU2/oH8L7a91mZkDp3dn?=
 =?us-ascii?Q?kwyfCPT5eIRqUm4FdOoJdIhRGuxQxkEt0nYgXVXxpQBPHEuUnSammr5QPDnj?=
 =?us-ascii?Q?Cz/SHmnOj2w+CzdrVOQhiarY5mEsFc0T5sREDPv1eRje9gvhNCDHgZM70v54?=
 =?us-ascii?Q?qDod3IkUXBXEpymTpZJaweE36H7TME+hF+bOxnLYFqUasYEWc+Spg6WHjygh?=
 =?us-ascii?Q?0IDl4nxWZQGSkAcLndbZSvPSeti4DeTjUBN3AnltJshjeGcMxsW/kYHLGqH2?=
 =?us-ascii?Q?iBaO4si+u+aXcbbHRyMH0TjFZshFVUNn4XAB8y0HPZkzY5q2z0uJtEFUP7vl?=
 =?us-ascii?Q?pAGz9qxWN0Yw/kNjVcN7wsXLqQDOThj3iRzITkn/f98FaoDuHCHeBmxEeLhm?=
 =?us-ascii?Q?K2i33sgy7pbJX3VBaYHY94k/L12TmftBsetG77XXMnQd5OoJ/EbnK8UoH+Sz?=
 =?us-ascii?Q?mgxdJCdLoAC5RSyaB0U5uCGXjuCvixctEmQlfdsG+f7h5oWe1Nxl8Pz82hVe?=
 =?us-ascii?Q?psppBiqiPhgZ+EsdkqS9szxG7rb2rDDFBVHok1XqKzriKSLnoESmqTlUY8OF?=
 =?us-ascii?Q?MOTndpifObYZG7oAu5gvsJvZgDIJdf+yDBaXZJ5SoZzLi+fuJpci2vjVAVV+?=
 =?us-ascii?Q?9dwVcl8/IpapitZ/bhHLrd4CPcwmSLFOun88tlUmYLnIQ+Ys1F9Q8s75kMSz?=
 =?us-ascii?Q?TKZeNkJMgFpJhDFHvLktNf2F/seu8/wU6fQYGKioO+sqkX9fdV793LXfMMQq?=
 =?us-ascii?Q?ti8k3fRaAxnr86krgbwFMSTf7l2VUp0L8bCfkl/+vuANg0+3DVm2Lw14RPBE?=
 =?us-ascii?Q?uiqQcsrmgS/vlxMHSRcHRAG8bhfuJ2MfPnbnS8F4+RwDb+Yfbir6boBRqScV?=
 =?us-ascii?Q?2pnk+nFORDUp60heNoK4oRjuRGeSlSrWyHCxm4z2X+Mw7kIHrl8Yg6zPc9xC?=
 =?us-ascii?Q?IHDXesB2vosnL3mpLJAYOfCidt7qc/sWLLPdZjGCH7+v90esjM1tpRKT1GOo?=
 =?us-ascii?Q?d0IQARKI/GIsl1XrT/Erkbgqvx6sXrcDXURDO11DKe37qMTNNDZ414QaZvzB?=
 =?us-ascii?Q?nCzUd8VsTTIaCHWGWNfBiWHYZen+/iYNZGRo3lxzjj1h1POfvoIEtIRYcVzE?=
 =?us-ascii?Q?tRejLXJEt6ha8DnHe9gt/viq28Bd2gZ+q+TqNkpl+ODd+AlTS3CmCIL1Nyzb?=
 =?us-ascii?Q?K5hKdGC8asZ9r0zdUM6qn0EOxjUm1hSdc2oLoDw9fdkJLNjaCyBhQxJPJu+c?=
 =?us-ascii?Q?AtRbg3WGIziM0Z+XFiCHpGPuR+fN8HaZA/ejjcnYe5OnU2MVGKA60DJAuTqC?=
 =?us-ascii?Q?nITowD3PFC0moNwDWZNCVDWaOImHVMEockU7LJeQChhu32gPB4+PAxq3G8Cl?=
 =?us-ascii?Q?mem6JKB9ZhbZDAoGg9NJlnJXKXnhXTt3+m+h6RPF+24occF5tqSULBksc/0h?=
 =?us-ascii?Q?ON4uen5+CwBdrc05Fw0bWMadsnwu+fSMnZWFfnEex3pulXWMQGVsZDe5JzaN?=
 =?us-ascii?Q?7zLlN6sw/j/klbDZMlJMU90K/krEESaRgHKrnB+wGEoa5zF91mDOfGCMZJC4?=
 =?us-ascii?Q?jY5uer3FgFnCPKYRT+RHTIf0MxcjekQLH91G6mamJPieHXhP3GDR1UpT27G4?=
 =?us-ascii?Q?T2fUWhT9OXu5M8VuXfzlpr5AsSZtHRKxFGgpH8tOXVAAC6wC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f364323d-8ec0-4662-8074-08df144d383f
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 23:49:59.9191
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4kOxHnZhMyrm+3dbFqE5Q/IxBaAmAdfVi1pLYxMbUVhawVyvHHlenMnBipSoUMEm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR12MB9787

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

v6:
 - Rebase on v7.3-rc3
 - Correct some minor sashiko remarks
v5: https://patch.msgid.link/r/0-v5-4cacb99249f6+1b4-mlx5st_jgg@nvidia.com
 - Rebase on v7.3-rc1
 - Adjust how region_size is computed to min it to getpagesize()
v4: https://patch.msgid.link/r/0-v4-021df3fb5a3f+98e-mlx5st_jgg@nvidia.com
 - Rebase on vfio next, update igb and falcon
 - Move rounding to iova_allocator_alloc()
 - Remove arm barrier changes
v3: https://patch.msgid.link/r/0-v3-76f117ad04f1+28a90-mlx5st_jgg@nvidia.com
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
-
Jason Gunthorpe (10):
  net/mlx5: Add IFC structures for CQE and WQE
  net/mlx5: Move HW constant groups from device.h/cq.h to mlx5_ifc.h
  net/mlx5: Extract MLX5_SET/GET macros into mlx5_ifc_macros.h
  net/mlx5: Add ONCE and MMIO accessor variants to mlx5_ifc_macros.h
  selftests: Add additional kernel functions to tools/include/
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
 tools/arch/x86/include/asm/barrier.h          |    5 +
 tools/include/asm-generic/io.h                |   28 +
 tools/include/asm/barrier.h                   |    8 +
 tools/include/linux/stddef.h                  |   10 +
 .../selftests/vfio/lib/drivers/dsa/dsa.c      |    1 +
 .../selftests/vfio/lib/drivers/igb/igb.c      |    1 +
 .../selftests/vfio/lib/drivers/ioat/ioat.c    |    1 +
 .../selftests/vfio/lib/drivers/mlx5/mlx5.c    | 1928 +++++++++++++++++
 .../selftests/vfio/lib/drivers/mlx5/mlx5_hw.h |  114 +
 .../vfio/lib/drivers/mlx5/mlx5_ifc.h          |    1 +
 .../vfio/lib/drivers/mlx5/mlx5_ifc_fpga.h     |    1 +
 .../vfio/lib/drivers/mlx5/mlx5_ifc_macros.h   |    1 +
 .../vfio/lib/drivers/nv_falcon/nv_falcon.c    |    1 +
 .../lib/include/libvfio/vfio_pci_device.h     |   11 +
 .../lib/include/libvfio/vfio_pci_driver.h     |    6 +
 .../selftests/vfio/lib/iova_allocator.c       |    7 +-
 tools/testing/selftests/vfio/lib/libvfio.mk   |    1 +
 .../selftests/vfio/lib/vfio_pci_driver.c      |    6 +
 .../selftests/vfio/vfio_pci_driver_test.c     |    3 +-
 24 files changed, 2501 insertions(+), 241 deletions(-)
 create mode 100644 include/linux/mlx5/mlx5_ifc_macros.h
 create mode 100644 tools/include/linux/stddef.h
 create mode 100644 tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5.c
 create mode 100644 tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5_hw.h
 create mode 120000 tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5_ifc.h
 create mode 120000 tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5_ifc_fpga.h
 create mode 120000 tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5_ifc_macros.h


base-commit: fd73f4a6659897191fa0d40695fe370925dd3780
-- 
2.43.0

