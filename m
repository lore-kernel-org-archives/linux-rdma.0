Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012068.outbound.protection.outlook.com [40.107.209.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F13F46C85B;
	Wed,  9 Sep 2026 23:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788998265; cv=fail; b=Zq7kSXt4/nGR18bl47MPw6MLeBZ17Eo+vABrTSprGpBKmfEgN5xBrblLjfZ5ZwiZ471RU1F0P4/d8uje6aSi5QgkSRIwFQ9pmQyPYjaR+ZvA5D9VYeyLRgLFJd5Gzov9nNxlo8XboChOVDgPRO2zzlelShfIvTFBdQ0lZe8cWxw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788998265; c=relaxed/simple;
	bh=K5P+ejhqrGICImPswlMSA5RajCWrFSHdNcjG63fN990=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=N53JMvTwJ1envb/p8NDQsMU8S4ZxGxViBvTbx2xcgI/UXuyFb0UzzBLAf1qn5SEvktQ7ZWXKms8yhMfn/u1Rveog/xVumndtPi8mSsVuu47xu88YzvzEtoqzQfdzjWfVW6MngoPlXuZhHsUdjoRtRjPVLlvePC/tNmrMG+v2UG8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=p5LYB2IR; arc=fail smtp.client-ip=40.107.209.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="p5LYB2IR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=maT+jsqfez7U+4jdKMeSlR2MqP0FbLeiKr6Hmja+euoNeYKtQNGhVXcyCguLtg2GrqRLxJzPHl+khKjUWgbljTrqalA1EmCpA0C1Q47CJUpVkpX91iPoJgLm6uLRmjn4T7bM6dmfyOmUIoDToBQ0buB6GYIgdsq5B51S8d/UhkwH/VM4W0QyXi6CKMx/AEdKyXxmgr3TVAF/9MMLAemicCj3mEdMezMSwaJscZXUbBmk/Mwpmxh2mi6I+aQo10rrbqXhoy2PcU+0R39MGyV4irObPNZkPlAzOm04VUZ6R/JhS8B9BUt7jD8uPRztSI/kSBWmy4wuM7w8cZKellhvhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MdNin1YUUYUdK4yP7rRfarX/3Gb9v2b8chCdJTTniZs=;
 b=GMQs0zvm9s6+/yLBiEqOsCa5xJLcDqqp9tBhc6sgAZT2oY4ALeCt9Ai7fvUoyHjKHoE9roEK3jkQC5u++cSGbLcEMPCGvxa+YRVD6N6XenatPRjEqkFg3DhLPcB0oj/vpdW6yUvVz2ZIdssXFj8ElGxdTtolXBmHJSIOz13+6LiaYSEeBFyVlRJVlsRRF123guBQvHcOLep0ATKH53NX9MxDNTWhAJOc5/O5sYnauCSwH6RHdlwI1mXpUixOCSPudr/O8qZ2T7VULxmfv7cYF0F51nzb4p5bn+oLl2mTqqnbb4L+Zxt5eP1hbUeScu0glxXWBUoFk9PyZg9vKaQuew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MdNin1YUUYUdK4yP7rRfarX/3Gb9v2b8chCdJTTniZs=;
 b=p5LYB2IR7i8rATcOJnkPLC5MHXX0cZYsWw30UJe+GjNWwHSCswJ8HJFFMfaEK9ZfjinkG8KxQK8OP7QIqHg4yRWWmRLQgUkB9Gsl4fe4bZaAvhy4WUS/Bz+4QGpRyJ5m3SdoLEKd+I0bCsQw5s0Cbm1lCz5IPnehaiJSY2GrAGLSUrP8b0bF9ue47+3AkB6n76U9eONYl9zWDlhzJVq/C1L2dBK58GI8YUyu8rweVFiuumiRkCMXudatK1WmdvnjXiEENL/Nw8RampPMCtOogy7bogWTvFIE4UbkUS/QlfKAF12IvxLngygpMuVwhHxVQx83Hjoz1SwviHQ7etXb/Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DS7PR12MB8418.namprd12.prod.outlook.com (2603:10b6:8:e9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.8; Wed, 9 Sep 2026
 23:57:38 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0406.007; Wed, 9 Sep 2026
 23:57:38 +0000
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
Subject: [PATCH v5 00/10] mlx5 support for VFIO self test
Date: Wed,  9 Sep 2026 20:57:26 -0300
Message-ID: <0-v5-4cacb99249f6+1b4-mlx5st_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0436.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10d::8) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DS7PR12MB8418:EE_
X-MS-Office365-Filtering-Correlation-Id: a08d7312-9daa-4dc6-2d24-08df0ece2050
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|23010399003|1800799024|921020|6133799003|3023799007|10067099003|56012099006|11063799006|18002099003;
X-Microsoft-Antispam-Message-Info:
	hGQA4e6vhTXlpssSWpMcaFxuU+7FF1iGs8j4iz1QRNzL9yX53eT20z1VmUuxvnlfTh1malYJoqsT2CUrcNEIDCDQSCo8jAITYzqs+1t6Ppsh4MbauZt1oHe2FPqjnZgHYyHBWAKxeI2mc193QZ8MNdb4ugubFdQQZfXzV3GHNa3yzsdQeee1Gsaw7j16wL4obULF2QA+8JQxmI0+bSo/Go0h4pnzBEHkk7w8jXHjpWC3v90s6m93NJxhkrhgteJbvosHz1+KOSWQtA+mkDn/Gz0+xTFGzzc9qtPdHYImFDhPlWaiEYeak8jrtalmVGDzpgMfyvZiffW/FnrO5cq7iBT/gZ1yVHZiTeNt5w+Bh739rtQOZDxKgi7tbvImpEiwtBFfeqH1lPGMXDKS56MuRRK+z+uNJV9TxhXxKWjNEUKTKhbMTkOcoegmxVmf174hvbVMdgU3tKgK3GHm9aK0WpjUvyyG6StE25frn7CeGurjpmJYv+Oa06TZjbRHopLr86sv9EpIZ2jJ5HEBuhprEMRQC12830xznIPHO/q1YmkyZXAJSVIDULWaqE3kOGYGxlGpsfno30CcJrk4oY9GvGWOe0p4JqYzDkRf9gE2bZLTkL7NguwDSJGXas2tnDlUTU5vozYv+bV6wRtiru4TjX9n1chPnrPFpKumGuFIVEUYyQWfhrvoIsoc58eSwxm1Pau76adukeU5VySEkCs7fw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(23010399003)(1800799024)(921020)(6133799003)(3023799007)(10067099003)(56012099006)(11063799006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?s+PgWkU7pui8wDB4cbxmmp/CIbtozkGLakH/tzA6+2nH/52gVUqEZ9KrcTr8?=
 =?us-ascii?Q?XzC/Z9l5qf1FUTCPY+ozlESAVJYSc/82FpXJi8bwFbsxABWrdvi4o8PhqVc0?=
 =?us-ascii?Q?zB43iVuMi+I2DN+WWxs2JfNaMy5HYVqyoHq9mPdi/UWj0XhS3iGwZ7bQggft?=
 =?us-ascii?Q?NjtDDf1Kgs2BfPBxjbDFewwHg+fLnjf0fcspgoUUb/gYwoEnz9yNNY0nySdz?=
 =?us-ascii?Q?tKFUiWDg//mkcsj8f9JvImOOdHzjhdYzbKmJTHKf3xPPVVXBNLPdzG81nQJB?=
 =?us-ascii?Q?BXGJXKfxDSTS80c/2WfPDTEBt8nPTDH4ex+8JyU616GSeVLVEgbldVhf12u5?=
 =?us-ascii?Q?I7+MbDOjzE5bspT83A1/Z4HRXAUqYYX0/+Wrt+sydXr4DTDLh82toT3oGSl4?=
 =?us-ascii?Q?RZCYKrQBvmB2OspLvfmsgtvQdVR+7IEkz4fCEfBjL/Gj2E5QEvHvHzigoUEL?=
 =?us-ascii?Q?8qG00u5QBtOFd6ko5GiZNovkt1Tt4u8Bc1TSZ4kMwZ0nmuCcKpk3/tYqlFbj?=
 =?us-ascii?Q?vK/DMLpEy1FYV2lP5SXDvJhwAsD3rL7KzjLrIoCURxhI7ggZQwpoHDA+Tk5h?=
 =?us-ascii?Q?9LNPA4uyBWNCqpk5gE36xrWPfjQnHTR5uN+6vF10xE7CJffzBQZpglp3xe8a?=
 =?us-ascii?Q?S1hYAC961lIv8i18u/2XVsA78Z9Q/mqaxD9bv7rX9XSZ6JzBe0LO9+RQ4y8U?=
 =?us-ascii?Q?GRnpp2da9j1A0uMiHpOVuorUikuGp8FNOHFRZMlBlsxw5rJlBAjbsKksWEKZ?=
 =?us-ascii?Q?VPEALPLI4dlcXBAHUQzGWppmwS+3yq/Et1tL9lsiEZAp6GJc/6ZAS9d8oCI2?=
 =?us-ascii?Q?D9Laoe984edo46nIG5uNfi1p7FIkT7XB042Uv/lBli2WCDLe5GkZr0iJ93RL?=
 =?us-ascii?Q?XF83Rv4GdVUpP2Z/mWSvJOmysu3uDWwVvG+IiNxydUi7c9CJXBjnC+nCH9wb?=
 =?us-ascii?Q?qO9+LwwdJsg3KKWlcWk5MZSl376qbeyT3B+0Rt5xoK50sFPhTl1064hmKjfv?=
 =?us-ascii?Q?t1oEJvti4tmJ6aDPaCtMOYj3xiX8EjSp/Q9Bhma10yws34lyKra/IqqzndVW?=
 =?us-ascii?Q?QsIfdEm5maiq1AOoxs4QrcLfIVOUU4ql0UX4XI0jPpSnarEgnS8baoKqNaLh?=
 =?us-ascii?Q?vdhoq0ZRBAqcmFYvTDNfKEt94vnSQfo3ZrOhgpOTGcE/pcTAf7yyOVzLi3jZ?=
 =?us-ascii?Q?AWEpSVFFZ7Nt3SCZO2I5DJAMa3wa9HFSFb4zkasOBHpa/ctcrWV0qyy0IKxz?=
 =?us-ascii?Q?29ZCeojlAWQljVFQ0cQdpPkTexx6qclHnRGQxEuOYGoc1nPMbppDfxCwzUaS?=
 =?us-ascii?Q?fXZ1TBRGNTNAA2eI2jroBAB0XdTFML4iedIYtRD935OcLe/JY6dNhUmlMimn?=
 =?us-ascii?Q?Pat5eU11oNvhpVJ/DD6YLbQHoimSYVxNjlpal8nqIPX+iDsqNSroxSaEztb/?=
 =?us-ascii?Q?vqmASe/9LysBxFSCuxNL6vF9G3qorazWP95IoWXXx/jhKwY5qqXmOIEAhXg9?=
 =?us-ascii?Q?klhsC6WhYvFM01RgMz9cpYn9JfPRtgctta0VDjRcmRG39F1BYZiifF+K6LHQ?=
 =?us-ascii?Q?KOi/ZyFNdZF+blg8uIemJ5J8rP9SAI7C5OUF0G0fWfIiIAfcDrQdN0qCNnYk?=
 =?us-ascii?Q?7PB4j3OZLH1FLofHmrKgD3g51vtQpl316mqAwZvNVEMWPq22ziHVfjV2Di/+?=
 =?us-ascii?Q?nwYpaIjH3UB6+e26UmsiZ8pYm8PCwD6tWBXFZMIvNxiczQLD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a08d7312-9daa-4dc6-2d24-08df0ece2050
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2026 23:57:38.0160
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TfV84ynBnCK2zDe+2lKfuRNRfG6n6umCDPfolZKM5nuN57iCpl9hU7Q3TIyDbZ23
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8418

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

v5:
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


base-commit: df2908090cda368b01ff43709f51890076c56157
-- 
2.43.0

