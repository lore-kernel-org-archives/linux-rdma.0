Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012033.outbound.protection.outlook.com [40.107.209.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6F440D578;
	Mon, 21 Sep 2026 22:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790030163; cv=fail; b=EnTedC0pBiRTqE0+Wb/ZXYTYQlZ2i9EUyPN7UOtfs3bO1j/SELCeJOQsi0smS7tueH2NyJleRrvNoT7XPpTQnvu6/SHfOWuPmwmI3L+YxnSx93aF87FYOng5z+HxZW87XMA3LyJKcpnwl2V7SpIE6FzqP7Iz6P72jrejBd+LGjY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790030163; c=relaxed/simple;
	bh=ChiS5sOdK5MNRHjnvPcxFkemrcY51tVOARvrL2LWdcc=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=UM1Wfht1NAchChm1cyDvB7G5UhBZd2fvHbTsk5/2mZjg/UepbonIV24TtpSDq48D9RT4rlO5xhqT52xCuDdL5tMaACbZRn/+l0wzajmyS5MNC/oFqKNOR70s7tue2i0OKQRaxBj9V/SagESwdnYQabGU9tCstdMWldBRLPpI0XQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=h83xlHfv; arc=fail smtp.client-ip=40.107.209.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="h83xlHfv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pdiNFjTZEFPwrAwnDmqTUUQ+FlAiXPG6JGxy/Id3li5JST1Ivd2/Agfab4EroKgRDCO40AuvVGB3/Eaov35xHDhttMR5QhEN8fbn8d+4Sg+W+KVQyNkc8kfyF6D2I5nh5IRiUIVjAcw233uJwoQYDe6LV9VRxZPu6g2Ejo3lST2IK9Rt+QU9JAAWV5TVNCb4rRe6BEq7obP4hzwE6dySUiq23OChSqyK8IGqb/Az5oK1L0fiA48zaXFvzida6yfkU9VnOfeibmRg3MphQpFPq1PYrSjbYd2YAdEJTrVZrvVUSCfA/BLR4YdOqpMiswzB1L8UIiyUrv/iYlXaJPmaBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tTxYTgRIEirrtrMzaAvRXWdCOAiO9V0DpEQkMUGOnwQ=;
 b=XzpJy+2ERclZ8am0lTVS3RByAi5ge3IglCuda9Y4P61395h8fnvMQ53muK0zZQewCuk/YnL8LHgW1j4A3SHCSgeDQyYiDXHGPFycx6zhHah0cOZ3jGphmKD4H8XTjIJaH0Q0SFX4WIvwtsEZitfXr+jJi++w0kTpGWrJJ92A1IINoADpO30dW65w6LL32XGlIgk+cvlyr0LCxIy1aQQp4WMHA/6Wl98rY24EbklOMb9FA4bkFwguMPMvyrMkHGm9nQP7JMTdov0tI04o5SsFGjgElQOsNaNXBgpGdPBEs2xqHFJZQot66BJY3jeeFgqBadHAShPevEjvx6c+oqGtQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tTxYTgRIEirrtrMzaAvRXWdCOAiO9V0DpEQkMUGOnwQ=;
 b=h83xlHfv9niTGGFvFSXnF2npzn86QGRYw+JcJbPw85kXcDfMyauSQlkHj/NnQvORmkwfOHTMc2BnLmdVHc4xWkYLdzCzr0dP2GmA0wzFNNotSOvu95jWEQFFk992wru4eBvw6uxGp9p9Mp93/iC+5EJJDW1rGq/nTwSCqS5lFw0x82GZU1MIrvog0jtVVTlCQwqyrPEXR1h8WEZmuiCfbOvU4NTz1F1EmjaWIcxdfWvdfx7hkYk3Oe+5F9Ofg06dbl/PdsGMIr1TVCLAujwYG2F6YgmgZ+4k+6ToEtLvFvQXF41zzJx9kz+fEMY0azCo3rYgUjvf5NhI9bNKOfzBdw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by LV3PR12MB9144.namprd12.prod.outlook.com
 (2603:10b6:408:19d::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 22:35:55 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 22:35:55 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex@shazbot.org>,
	David Matlack <dmatlack@google.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Leon Romanovsky <leon@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	Mark Bloch <mbloch@nvidia.com>,
	netdev@vger.kernel.org,
	Oliver Upton <oupton@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sean Christopherson <seanjc@google.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Cc: patches@lists.linux.dev
Subject: [PATCH v7 00/10] mlx5 support for VFIO self test
Date: Mon, 21 Sep 2026 19:35:40 -0300
Message-ID: <0-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DSSP220CA0008.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:8:3d3::19) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|LV3PR12MB9144:EE_
X-MS-Office365-Filtering-Correlation-Id: b917fb64-a24e-4e10-8260-08df1830b13f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|7416014|921020|56012099006|3023799007|6133799003|10067099003|11063799006|18002099003;
X-Microsoft-Antispam-Message-Info:
	UXj8FxMiVzdzHimmSCD3KwR32DVlcCh9/qGwPeml0od0D5mTG1nz6Izhe6LPC/BEwS7oydemVkczntME31Cr836lUNxTA6lRJDQd9CcT7lU/h4rgquwXH24tIuQCg+QhHvZS0fRsJenyPQVcMhYf1GrXPoEDtMus4hEaiM5IesTfHsN6qnL3Xs5X8zQxN7YiBR8rLahUHMev/eGTod9JqtHDn7bFueWNkg5Etg54ySwMbMQeXqeNOlBV/mp9DWK0SR83FbVj70EoKKNbLomxTFrHZlv4R9kB7WM8oEdaH2iVZez5957fWku+PElhSwLIqjeyHLOs80CPEB15MMY6op+YuAc+DxQveVqAn1bWxKOJL3YgTfaZTOBEZH9d4R9ObCGIFuC4I9AVYS8meGbnb/m1QgRMe/S+Y6mIe20mivk14HS9RteYD8kQtwr42l768ApK6vn2/1Sqe0diRCZsSOLKAgD6uXT17yjr1ebvfP3v2BxhY7s59sQUW3r9cBon5N6vkj8pk9XD7zXfvn4NshoxMofzYgv4tWzEh32e25CTFFfolaMS0/+FkQoxgGqj0/MWOFS4VVYEpHDJxzLqpoUW3Q/snvEs/nIZdfZSSc0MB5cFf6WV1kHrgh2kp4Ejngm4IDXjUcqR/OXbO1aYUXs9CosSsQE/aLTwUBycY4shuvz+yqQmsVc/B83A0pRCLwhRJ48XRC36UhWTaelcKA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(7416014)(921020)(56012099006)(3023799007)(6133799003)(10067099003)(11063799006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sUBgzvnsUNQN6BJXJo1F/1mPMp8kxrKs7Mn7Fk9GQXE7du/T6ksS2EF/rfIm?=
 =?us-ascii?Q?wqYbe7YysVECtDBIDweMFmiLoKzlW3/fmBBrrbXVlYmFdgtRATrEfvwnVEZA?=
 =?us-ascii?Q?C0gsgNW19+BDuWIzfKnZG4AIhXfxaKZbMhPvwCfWlRzbCyYkitgldUUTlMuc?=
 =?us-ascii?Q?+QJYniIsaKKISQn4s/WflmUOWXsAt2I/hz5n9Cfg9EJfQEVPBjwwiBNFcwGj?=
 =?us-ascii?Q?CiXH1kUuwRe743aMcL88H7cBms70m8oXEvsDlRvhN3V8W8HpdR8Z0YGItjSR?=
 =?us-ascii?Q?ts7q9rjUHkQ76OlKKEfh+HiS9L/RLP8vCAoAVLay4973S4EcH5cV58nwxbxM?=
 =?us-ascii?Q?n0vIbsKhZ8R7CvxvdXzpdmsiE6B4FGnTARfSXfDTOFFt/zrBhDZkv0GOI1RD?=
 =?us-ascii?Q?c6/2jEUE9/2sUGH/Tg4tE25Zj9YH6LHSAqMFYOWeYMawvubixJ4dAGh+6DG+?=
 =?us-ascii?Q?EryXaMaP1hYg3CtCMnPn+oVq21dCGT7CjZv0yk6IB0g7UPMXMheEv4j0rOOy?=
 =?us-ascii?Q?Egq8IiNfd87LIJJpBDKJpWgJB4L50T56xz5Bni2ivqoY4KlwbErsKlHV3MRI?=
 =?us-ascii?Q?RO57xYY8Ddw+JjH7QDC3VXRDqI8HLP7niTN1mJlmJYgTocAEMZdv1MI8IgUL?=
 =?us-ascii?Q?Jwxyh/9Rl2FAkeJuUxZUprG/eMLngg+6KvPgkWXU7a5nXUfzKIcMlrZ4A3Te?=
 =?us-ascii?Q?lbahbXa802aGPdD+jOmJzWKc0Q7NadADk6gctnZ7928ZoGxVzAMmSbuTPG6a?=
 =?us-ascii?Q?MN3bscqOTJxeAncTc6ojSY9G8Dz5H1CSOdg8ARRIIWRG0eztDgNEbbgQIjOp?=
 =?us-ascii?Q?gvHcYB/YNy4ScV06WTGbIgTLds9Qa/JkrSVMmLH0Y0w808IEuBpoDavEbU1V?=
 =?us-ascii?Q?URvNoeJTix5/SHdQopLuTBLBU5Tccj+uticpkroXtDU0vqeA60CcCyuIs3MO?=
 =?us-ascii?Q?/FGlxIku+wB7BHpTYkZV+bVp240wwNuIwb1TSS30ahcLHgn34UF+ieiByYA1?=
 =?us-ascii?Q?fNZMeyESqiY2O8CutxhLTPrJ4rwMCh3pyhSIVoSgHWYNpXXHswS5583bYLV7?=
 =?us-ascii?Q?SRz4HTMsJRG7TUsUZgCcETlXcqJM2C6Sd2nhYsgKRA2+dnf9fuye52Ta7xHl?=
 =?us-ascii?Q?xOErPiwNcz48oG2U/K3YaQ9ESGBsbJM/UpeUgAs6X3ynodqbX4/KTbZl4msS?=
 =?us-ascii?Q?23Ox0KCqtrnp2IRgpmAt5w7LQ2BWuGIhpIBSCz7Q+KX3lIImRGP4SwWV8spl?=
 =?us-ascii?Q?xPsCjPkqXJ7GIWtBKWYaakC+TqoJoUiOeZAH1RXda7SFOO14NJG2S9mHLqen?=
 =?us-ascii?Q?wG5THDf3jrHOznJDppYATyB7JT6onltCbHOQ1xP1LUkvFnAYHvjRU/kDwvLC?=
 =?us-ascii?Q?alaiNflXPHcJUnJnPB5fZtx11OGSNRxdCpCHpVnt7JVthyW8TTIGffHXSZFs?=
 =?us-ascii?Q?ASsQ1WsiYT+MgMm8KT5goTQmtF4GBYVtmqHq+5iAH5RTp87tDMnlvHVUPVRk?=
 =?us-ascii?Q?szsLhLVJJA9ktoI86vQYXVqTlFpI6OCwUPYIgnVFqlTEH1bffteQeS/lZFx1?=
 =?us-ascii?Q?d2tjYF/oWxUvTbB0DpibMOtadDVxGbCY9mcTBy1U4Ksf8qaGIoMOF9a2SBVA?=
 =?us-ascii?Q?cN+YPlXWpEF1S7xnsNXkT/AJ0hboF8YrEhrsEk3kcprFprwr6I/ejZt6ssRA?=
 =?us-ascii?Q?6UsGsRpIMSDbpd0cJ5B++CMFVHvP+LuJKmsGYPArtruTfZ+z?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b917fb64-a24e-4e10-8260-08df1830b13f
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 22:35:52.1807
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GRKEtwq8DkwNFBpcBsg1BhJrFdnIT6YWz/fkJe4fCH/RteK1M0urmNPsuFVX5fdX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9144

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

v7:
 - Fix some compilation problems, kvm and the igb
v6: https://patch.msgid.link/r/0-v6-8af36cf7b73f+e2-mlx5st_jgg@nvidia.com
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
 .../selftests/kvm/include/arm64/processor.h   |    4 +-
 tools/testing/selftests/kvm/irq_test.c        |    2 -
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
 26 files changed, 2502 insertions(+), 246 deletions(-)
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

