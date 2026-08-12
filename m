Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010034.outbound.protection.outlook.com [52.101.85.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F337D480320;
	Wed, 12 Aug 2026 23:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.34
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786578293; cv=fail; b=Z94km+WAo7oGilLcXZUr9ZMqvr8UwlhWqEepNIEOMRXCxYWoRoDBUynwzPl8GOCMfvbVuRORSo6XDVy/EurmYuTYA7gpXDGAMcSC6+9AGX4U7Vr3ibmkYEoE6sg6ghUk92XMJzD68S1+ZTIPGdtWthYCxCba38z5Dg97gWNiyz8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786578293; c=relaxed/simple;
	bh=BJbYF9QXpwJ/8iFQZ0qeaUJeLK6UGA/GM8oPA5IGnfU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=CFKbvfvKjYY4iBcYbmppvoetDpqqcDKOzuHqcnGAnHkIkle9zSLrPpPr/8lTWIvXX0tZO8kkBEEGJYZkpQnenxHAz3Avtl+OPwZi2m+MATp6wAVZztZiHsMlwt2bObUqGG5fMmjNk7ZAV6HHNFwRSlQaRUntpvkbeEiteoxiGe8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=g7JCkBsr; arc=fail smtp.client-ip=52.101.85.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="g7JCkBsr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bTOSg6cPlRLK8lycY44M1Kort4XAc+xoFYqLPV5Wshd4++NyDE3bLquPhIEwgQn8su0x8Ee2Hay99z/UxEAQISceU8w+PMwpS0cA7JmO19wRKEZcubl0Ue8euzdAmIW2fMaHKOv58THQVah35Ub8/eJhhmzL+IcrDqG+JiFgftZClI8n/DL56EGUUy86YgQeCwuQE3hgM4lGZwy3GDadO9RXageCRz49tdO1Io0gGhxDMeht7xcgxdCJ9DA1ZJ5LRdEPye+ONh7tSWzSSK0prBeHr4faJ4Y3DI0gtSrwtA0UF9/JyAOz9o8gMW41wQDfP5Fbiuyr7GkzlvJWukgA4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sgNibX278PDZSe1ly2Wor/k94zn9eTn775n6iJfapYA=;
 b=SEjkbfrjSEzUuA5Tj6mNYnqulbVb3rv9sn/+sB1FuOMBMj8PYglaLyMxN9OjrJP1p3dRyKUVoY4K1VnCFZeLf6tjwgSJvWwfOgzTP1v5lai+CM3/6PmRG/wczAxYPCThP+eOdxRcGNh54gN6COoMU6Jsjp8uZCK+RL1CFdGE1dcn6uWscDm2XTBM4u91riMJ4Yhx2n/XC7kRF/0GgVk20K2SbDJrOdmfRJTIQSZn+cfCyE0J5RUWv3WUrZuWMZ3hIDy7PHeu2MLsd+G932qlexPT+wlp6AIlF0eU2hVP443m8UjFqTZhn/5SafvYFYQTMG8fcCmCZz+LzKpRdOXcjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sgNibX278PDZSe1ly2Wor/k94zn9eTn775n6iJfapYA=;
 b=g7JCkBsra8uTZFRR+EAxe0VyEOaSfb2VmR7vjUse0XVt6r//5lOd1eAk7ZWFgy9qzVB8upVDQrFR5CtaBrl+6D22ReOZISUS+C7r+x+wkSiZ0DpsasqMEZjGCDZn9mLJ5CmVSIdew1AGxjIUx0DdZmqFXoTeDuNCYHGvGJrFIaF9e3wzNqSc8Lu6l7gMVamCZRLimUAthT3xHKusUoYQun72MVEJgu2R8wbVSwxtqUe99I6AxOeoDDNJQAYJecNELN6RWJ1p9uDmoZ8XDjMSWavSbeTFEcaCLrLGdJQ9QfBIAq3v+35JA8WQS6ySFIzMqlRoniXEntISo9/sgz9Osg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DS0PR12MB6390.namprd12.prod.outlook.com (2603:10b6:8:ce::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.25; Wed, 12 Aug 2026 23:44:43 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0315.011; Wed, 12 Aug 2026
 23:44:43 +0000
Date: Wed, 12 Aug 2026 20:44:41 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex@shazbot.org>, kvm@vger.kernel.org,
	Leon Romanovsky <leon@kernel.org>, linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
	netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
	Shuah Khan <shuah@kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
	patches@lists.linux.dev
Subject: Re: [PATCH v4 06/10] vfio: selftests: Allow drivers to specify
 required region size
Message-ID: <20260812234441.GC730363@nvidia.com>
References: <0-v4-021df3fb5a3f+98e-mlx5st_jgg@nvidia.com>
 <6-v4-021df3fb5a3f+98e-mlx5st_jgg@nvidia.com>
 <anzvkibgzTae9eV9@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anzvkibgzTae9eV9@google.com>
X-ClientProxiedBy: YT4P288CA0030.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d3::12) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DS0PR12MB6390:EE_
X-MS-Office365-Filtering-Correlation-Id: 552983d3-6340-4d58-15df-08def8cbaefc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|56012099006|4143699003|10067099003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	1w2if82qLn8d9pPCfHGx/foUZDouGzOXwDw9+YOfwFMC8UJvMQamjUfBqnRtM2XORr/G1UPWlB7YZftF641iytRid7nZMUmscnNjIjJOiXf13q/IhhDUH+htb/vdNS3igiOwTBRVhVJpvsgbOKmkxcpDhmxrjTN6docMBpKNGnkD6t9kWqqb7AvJ/KZFGqgv8ACHBodDp4QcQKCMxEwwfsv9vAa9vkxLdK3EzSzl3wpuF5Tahm2xtsR/MKeFFm+lqsISEtCFsXl5+vvNsrO2SW9dctiiJWfyCMwc4F0sgnjIk9s11JL+ZRjcHFwYEYCdKVV+wjqh4r59ppucqhlGg1odGq8eZNm/V4aL4a8mBIeZBl++guL7Kr1AcIZ6GmX68N9pmmHhRE6mRDYIt2of+SVdBEBbVulOX5njmAFqiLNBHv9SHzYTEjlToq7UwzrZvveJ2P6mj2Aw8jIKHTet9mXLUUQlI617QkJrxuihAaXuZt7PfAXOBo26MKYqaxDhhdaC0KxK5gp1+60fCtr8OKLOn4QCBtPC8i4ZjFVCw995+z+9vwsRQzWhjMy890VFNizYgHdiZIPjchHlxfAqFRP0v0xe2HwbAuvCA6eDMHftV7n/U0QmN1t3sFz6hzqOFBOf5WWcSFvL9c/FWJDBQA74ZzxT2poGGJLIsluYL5A=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(56012099006)(4143699003)(10067099003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0+LeRsnoB7Xb4ife6VeJBQXcFCMqkyz9rQFsmkVqgVcCHOJi9Z9/qoPdvxm7?=
 =?us-ascii?Q?40Fr58HkslTUF3Fl1ZnvZ6TENaeO0FnKMx5WL5NLSTxBgUnkZnLTeR0l8HMX?=
 =?us-ascii?Q?ghqXATw0HSzBpgsl5eCOOMVoxOenIG4RX4UzoZ/OH7qE/ryMVb2jzMoJhBAj?=
 =?us-ascii?Q?SUIMrwNoAD6ChX8xYeQtK/LOQ+c0Sa42ynsmqSOKYlMiK8YLKknBDH+Z9zJI?=
 =?us-ascii?Q?gy/M/6WWEkeI3NzFtAPx2Cc/mI68WepIXhrk0voEfOShyvBySfjiR8cXwhJU?=
 =?us-ascii?Q?iEvNcAn4SivkadK52cwPHoQd4bOGgws+PPWg6MtmasrvHvA7Zm8OEpKxOLvy?=
 =?us-ascii?Q?+0GvGXSjaYrpbJw54TYkR9avZ6FH3kv+2z5d2gmUyaZJG78kfqjSt6ZX7vsF?=
 =?us-ascii?Q?5tE8FwoToHKavYpykKDsOXz3E0FqAFWE8y67Fwhj2kR8Vbuq8EriCPtOhBtS?=
 =?us-ascii?Q?troKDfwOXkGkhjKWs//TMWDUoAG0SHEN+SNvIWqOMVllt6srFJ4ruY1vUBGC?=
 =?us-ascii?Q?dSHSSo945p/JJjTZFcZU3bnj9L0iH6Mi2huX6+rVAvh5sfeGimtBb/w8Rexr?=
 =?us-ascii?Q?wnDYNoJyGoKh1cnzG27cjJFQwj1aNx/DSfOPk8QlZ/l0vH/UdGwick5mx+1j?=
 =?us-ascii?Q?XKd+JNDdMzAp6wb4QugwVof12Hfs+Ckt9ipJ160Zjx5/Y1NMCcD7ouGHipA+?=
 =?us-ascii?Q?Yk9WAsS5sEidSusVfIgXUgh9R7Mchfa7HozIrdk6AZQWRyhHxrKSiikS02ci?=
 =?us-ascii?Q?U7kXpSwVZQfMNFOyVY4Cb4yNFwTNvxmv+aP7Om+Zrih9B18A8IF95HwMMYF1?=
 =?us-ascii?Q?0aI/v9+qZL9Ua2vh53Sry43faVvjae6dAD3QFrwbmTiLrQyDOZk0zkV2Y0WD?=
 =?us-ascii?Q?NOlMzEaCA7WgcNG32BxQYgebrt8mIGX1z5kb9tJ/t/LfpwfOGGHRTZl7ksSl?=
 =?us-ascii?Q?XAYm+wpShPbWpjLK9W8WG8Obp+dFKW/t71dKMSOAB2xKjeOQm9iLeYyZ5OZV?=
 =?us-ascii?Q?OYlmohjiNpj0+4Ru12zvOjtsaJjGkw+VG2fkjBsILtPAcyAyZ7K1Zn8n4fQ7?=
 =?us-ascii?Q?5rtrBsAn9784O2p+Iih3rcokE3rtSG6aDiPc26DgfxXcnCzwY1kvRWTZopVf?=
 =?us-ascii?Q?Gz/xVs0c4RnWCLnJFKO3eCN5T5iyS+7kRuFu+vit+kZwQLHJOgBwtd6p5wJP?=
 =?us-ascii?Q?JByaH8iPnSn5SEnzQtqP+E9yPXOhiiNh+R73FrFY6IlWfz9MD1hI8JNl5TQo?=
 =?us-ascii?Q?bwQ0yVBm7BDdkEd/A/oHJzN0eecgF82Nq0Wwy/yEr17smxseEEMT5arMCSH8?=
 =?us-ascii?Q?F0sll7v9MJL9IKVtNbi1PXzIKX1cXDzZqyjUvUedJKdRJfkiiE3f1REDLY1k?=
 =?us-ascii?Q?KwSL74H5hneH08pZEZyiSOzk8HOQ/Kkq04dnBg4Oud1kCaZQUGaKrYh/jSxq?=
 =?us-ascii?Q?24SBg3VckE2ju8EkGlIaH2hi4eBX7Rz4Ekrf+0iQL93kXBaZujYziN5tV8IP?=
 =?us-ascii?Q?OuUHSV1SwLKxTsSXg1IGdbXIvlYIXPCQmHeKLVxhjByp/YpE2VdgiyK5hlBz?=
 =?us-ascii?Q?MZAzYk00wjxPC9vgxkwVoToTmYlrxDHASO5WUHjIiQPqmzijl1Upxtv/r9Rj?=
 =?us-ascii?Q?C3vLUVxDCwuLv1Ut6PMb8ZoSunAh1OOS5OeY+CL3whwfUInHcUNXmbysgOFY?=
 =?us-ascii?Q?f8DHJ0KRjsEMQtUrGmEbG9vXnmmzZ1Vg7zpwzlOnbEwX5gccXCVg9rWEh8Op?=
 =?us-ascii?Q?kYmHv7bb+w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 552983d3-6340-4d58-15df-08def8cbaefc
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2026 23:44:43.2060
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xU6ZG6l0SaZdwD+YTFZaVtFlMnYvElVpfkfXP555DCEy0kurOvL3oQoP/qL262Jb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6390

On Wed, Aug 12, 2026 at 10:11:30PM +0000, David Matlack wrote:
> > @@ -32,6 +32,9 @@ void vfio_pci_driver_probe(struct vfio_pci_device *device)
> >  			continue;
> >  
> >  		device->driver.ops = ops;
> > +
> > +		VFIO_ASSERT_NE(ops->region_size, 0);
> > +		device->driver.region.size = ops->region_size;
> 
> I'm seeing failures with the IGB driver with this series. I think it's
> coming from here. The region size needs to be page-aligned so that the
> IOMMU map/unmap calls can work?
> 
> The size of struct igb is 0x20080 bytes which is not page-aligned. The
> size of struct mlx5st_device is 0x200D000, which is page-aligned, so
> that's probably why your Claude did not notice.

Makes sense, I didn't use claude for this, but it explains why my
tests passed. I've adjusted it as you showed

Jason
