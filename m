Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012041.outbound.protection.outlook.com [52.101.43.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45EF421B192;
	Fri, 17 Jul 2026 00:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784248585; cv=fail; b=avxavUx/5vAUfrbL0dhfMTKFeDd3uYkyCa8Z/h4iGjabPWZpz6iI15Pu2QnVqrPGDtMwaJaGBh5VoEuFW/vXJcXyioRuQhQTUlUXv9D2p6PYXP1wFfQl0E46/fz9HhLgY2GqH5waYkD/kkfD8MNtiofIUWJEAdZ/E5Fpi+crp+M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784248585; c=relaxed/simple;
	bh=C+rGI/weQp/X4KgkwJHJEWgIsA2SJz//bQ5JO/loZnc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=VLnjPP5y+mU1mBCu5P1y30EQE4rSGWnD4EtarVnJYwa/UfkGTD6OKg8/qyrG4bIdnyaxYIUD0AbRA8k/YG7Mm6Me7R7rFIaFjtnUz1ZBBqTAzuEik1yoJhLkNEgO4/eHoqnVAXCHEbso78M83XAzWCnzKLoPnlXjrTRdbkA6X/E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Y21zBHHl; arc=fail smtp.client-ip=52.101.43.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Y21zBHHl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T89r6BniilbzH19QPjuEq215yvGNmIxaD9BeAJnowemlcvunsrCMu5jaLKVbArHcnI+lTByRDn9Sr2pxpDBJbcP0evXm9wsXgC9oednbGSmEvVyre/fhi1riZX9HL0BloPRW/834RbP5A5lhdQIv4Vq3TPC6sb3vftFa2MBIBEt25OdGEVTRhYjmB9xtPMDy0zuAncrD3y5EdtHEkKTyoBLmyUAF+cgct+iYNz3ZNmSxvb0sXYeGOenAQYJqNmoBqrhJg7voEdx+wrlGsmeimULuAeyHH+hr6bEna+pGQzlz1undSq0IuBxis7oCs/HnUt2FTWV6YFMfW4KBEQizNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6yz8CL/JmEEOmXLtS5Cg+ETigIBkKag8VP5JxrsSea0=;
 b=WWa5GuUT7lqMQXB0e4nNT0s/vvq9Oi0s2X+UyS6JOkc3catq5whXBDtTZdmxerr6ZYgX5UTgM+KgEfshLB/wsNpWvnx6Z7Cmdl5jMtK1vW3OmVMcOWu/XiGEL2HXqVdF30qILv8iD4S/ACBOZ1uW4lsgfaf80H3yEJqPsmOl6W17L/d4GMShxwmiDLMdALz7oWo2foY8Ct+gp0nMwPlx/AjJL0Ztiln6Gf+Kats9Ew0+XX+kgRjLCKayOPCifToCgO0IBODEsoBQVjetVFzx/EWC/rNvPXb7540zKCKwZzWlyEOFO67Q8IyCB/K5Wxkb/27sx4kI4AM397YbRsVTHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6yz8CL/JmEEOmXLtS5Cg+ETigIBkKag8VP5JxrsSea0=;
 b=Y21zBHHlA1ecVd65NErLKnNAe1Z6rtZogygrCzgblow5ZZP1kcSBVeLF5LCyAor+2HegIKEOVNqa0hzImEmKrAZ7rqLHOjCMn1FlSxu+uPVtsDF4IPwXKwTGSVrMGBn3fmC0Oc/0NJ+jLeoVB6wjXt7egUv+ksFVFQYey8GLwamj73K2USxmjaU+Rr3p63rChtshCjndN7eZyTjV+7sfrQeNt3hwTSloHYtJvIlQV5B7L5L6EkuQm7xc80p52oU/i/ltg40QB5NdRMbqWC6qQr9AXOl0k23FsqIzqnC84WdJzTAIGZJQX+cMJaoO9QE9ksh+jSgcBm7G+ZVwYiODTQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by LV2PR12MB5871.namprd12.prod.outlook.com (2603:10b6:408:174::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.10; Fri, 17 Jul
 2026 00:36:20 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0202.014; Fri, 17 Jul 2026
 00:36:20 +0000
Date: Thu, 16 Jul 2026 21:36:19 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Alex Williamson <alex@shazbot.org>, David Matlack <dmatlack@google.com>,
	Justin Stitt <justinstitt@google.com>, kvm@vger.kernel.org,
	Leon Romanovsky <leon@kernel.org>, linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org, llvm@lists.linux.dev,
	Mark Bloch <mbloch@nvidia.com>, Bill Wendling <morbo@google.com>,
	Nick Desaulniers <ndesaulniers@google.com>, netdev@vger.kernel.org,
	Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan <shuah@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>, patches@lists.linux.dev
Subject: Re: [PATCH v3 06/11] selftests: Fix arm64 IO barriers to match kernel
Message-ID: <20260717003619.GA699082@nvidia.com>
References: <0-v3-76f117ad04f1+28a90-mlx5st_jgg@nvidia.com>
 <6-v3-76f117ad04f1+28a90-mlx5st_jgg@nvidia.com>
 <20260716232210.GA700430@ax162>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260716232210.GA700430@ax162>
X-ClientProxiedBy: YT4PR01CA0169.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:110::20) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|LV2PR12MB5871:EE_
X-MS-Office365-Filtering-Correlation-Id: 97e93adc-0cdd-4de9-e7c8-08dee39b6bea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|23010399003|1800799024|4143699003|6133799003|11063799006|10067099003|3023799007|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	ozMIjMtXj8AsNlF2JOG3532jwX0NEIxFX17HbpLLqfm+85FXphJFwAnJfjhFS1YLujDAibgSa925RhKBmq3sFC3tn+Qz7rmizLnXQpW3cqY9qgiL9Jcfmyqpp/8GNuXe0IZX1t/huG5jlAJrxwamphDiiNpy0v8e+4FSWhizKRPM76j5E2hjvhcLJqcBfd9EN9YtrM39DMj/TQQZH7DxHkxNNBvFw9PUmFtOGvz3afwTnOUQn41lVKrVDxa/z4qqJWIQ2ZHa99QYduZrdyWj21S40cMBFQlKFYse6D6UMD8cER+lXdN6eK66OdR9B+87sJNDhxYDJ73uGjuZiwDAYNxTk+3DweGWpDXLVjCxUX6hQs/4cd8yojvgjZlFjW0CuK9x+YGtWe4kWZ9SEWkKqwTLhvhgexoFR0BAcBCt39KJ+uFXtSqMHZJ5vAHo9ZB5HGHm3LXTnAW4JW6iHDMVZdNOuLg7K956VAt15cDTwR/bfkV4rorKjh4D40xXuLQD5ve8XoiCYhp72CDAJKCpu9yTxStxCIfk+cZc8M+sdR3kE5YXc4wBFrqNMq521G/y5ovquuyMUqBQ8jhIp7E5zIum9gZfvEKCBm8kymCQco07Z8IE+mibReKOGOj9h2+cfxnnalKj53u3v+jMrImIxJZHQZgGVrHEJB0q3ZZ5HqM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(23010399003)(1800799024)(4143699003)(6133799003)(11063799006)(10067099003)(3023799007)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HoK/N/ng8Kp+NqIWeJU1yZjwuoPIb9QwHcznZQR3lqc2HmP1J90fnzIrBq5B?=
 =?us-ascii?Q?kZw0opGvXU4wDbYhYfQ85bPG8BIVqH/14wwQasyn4hYgAGhQd26f3X6b21qV?=
 =?us-ascii?Q?ngkk0vjpScLk50PYX/TWMPzyFyzynEWsSPTcCoVcA5Owz1ITEcOdxFs8j/jt?=
 =?us-ascii?Q?XJArUawtoTmEH97vybecFOPp0Qr7Un3SgbM/+ykVKSVB30G7qfNI2vnVOWSZ?=
 =?us-ascii?Q?/M/5WSYcvfvDXcK4bYXVdvq5nYxJ95zIuy9dgRSjl3XD+ibnrJ6u89YpoWpB?=
 =?us-ascii?Q?mNO/XLzFzRU/ld6jqmCqGDMX8ELIsWZTweCjZyyrL4ZTbzLLuS/TciW//3oR?=
 =?us-ascii?Q?veBfgPUwW/i7Pq1yiXQg4UL4bqKzbMLB0Kc8LbvPNihOhY/Ip3GRRsy+rjcx?=
 =?us-ascii?Q?rOJOYsDiQCiep+vuDMFoAxDFkaq3u/HDpA4D2txNVrcUh4RR4CZXsT4d8GVQ?=
 =?us-ascii?Q?NSqk8l+6ZsNMhWFOinsgsclQ/Ix7fuFefZCM4ds0bVKnoSafTatvShuu7WCv?=
 =?us-ascii?Q?iATUkuPm7iw3/ZRh8jooWxqWF7VfjA4VKK0mU3SxQCW8sH4mTc5m2DIzeOul?=
 =?us-ascii?Q?AdljGhZNnvQBK0HQ+Xn5l4VBuxpkoClyccxNGMVJsa9lI8/9XrybWAJjNm5L?=
 =?us-ascii?Q?cwKvl1rESm9aXFB+dU0ZpQxu9zE63sZM4xlz1bTspDu112i/jWgKzYjsY9kK?=
 =?us-ascii?Q?gDGeiHGg+0pqDB82+Ke4fvAIU0MCeqxmiKEfFTOaCRtrIS9g9EgOHBojIo1X?=
 =?us-ascii?Q?/9LXLGUCF7TDLmZFDj7MgKNDR8nkSQGVBKaHMT/x1jExwgefqEIAaQJ14JKs?=
 =?us-ascii?Q?qObnREheSljjzsbYGu4MjemoZVQpSkJjpNUyBBvKVxtIF1+Aj8g9U+xg6gO3?=
 =?us-ascii?Q?Zug6/rMkxRCmjdu37QyKsnus7c2If+0ajMMqD7cV2ZV2p5/lI02G6K4ceFaL?=
 =?us-ascii?Q?FfsEEU1P+28JWFUBFvWBeeohbnuIWy5UtAJsNTPxFZVJBSbTKhpnHqHx+n9d?=
 =?us-ascii?Q?CeG16mCWNu7dHHKKzKe4iDgQIsvLBTooW85zrFuNeh+ltnGytVYsBMLhZ/r4?=
 =?us-ascii?Q?e+WeDmq3XSdwWJUjRYZARppLLSOvm+OlCm6R8eJsJBtAbfE0mWwj+0uWDWME?=
 =?us-ascii?Q?/I+5c9dExF661DXjqsOLVcM/tMuBJb0mu9DD+3VkEQfaInft/Ff1ElasgNA/?=
 =?us-ascii?Q?xJx9snj3MKypmXBOaOcemdHoLaEtQSJzKuQjFjRlk7fBnQkLUtSIzvc/FCNE?=
 =?us-ascii?Q?kFlh4iaqEhMyimIeXurPC4nAHK2n38qQMslHYqckix1T9XWuqmIuedvC+Q17?=
 =?us-ascii?Q?Aq4kxW1fETbgOifpa3/TiehubwBMi5V3eUeg01gIpw9URFSvBIzQG/fwLJO9?=
 =?us-ascii?Q?pdBP3pIFo45iuplcmVWg3q2o+Xjholt7QVyGmY1hDfLLD3U7fJT0UJ5bxMet?=
 =?us-ascii?Q?UuFZVt1SEWzQSKeRPyYdk8i+3Cf1C9Nrj54qTer8MRb8vwhva5VhMEQttdMG?=
 =?us-ascii?Q?RTbcyW9BP/VvujI9J1Tcz7tTqgwaD6W9EOpNB3kXJD1FtrPd570sM2prPaYx?=
 =?us-ascii?Q?XlwuAFkPkPpIbPiZ58sagmquFMni4IU6lsYpLcKqYcP3L2zfgG4rXMDEX80X?=
 =?us-ascii?Q?c2YQqvptCp60qvhvRZBXYZivyWVoXPPGRh40Gqb8cwRrAG4+EcorcGuQ/AI3?=
 =?us-ascii?Q?98pdqV59PxS2NI/qoXHet30NAc0v20S3yhxG1eilAWXX9Qar?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97e93adc-0cdd-4de9-e7c8-08dee39b6bea
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2026 00:36:20.5162
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MWyS6gTdw5bQGb0yd96u1bI99kfCheFgGAHYzCxq6j7oFEJqgAIb9AyaPta/vKcY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5871

On Thu, Jul 16, 2026 at 04:22:10PM -0700, Nathan Chancellor wrote:
> On Thu, Jul 16, 2026 at 02:03:22PM -0300, Jason Gunthorpe wrote:
> > The tools/include readl/writel MMIO accessors on arm64 use
> > inner-shareable barriers (dmb ish) while the kernel uses
> > outer-shareable (dmb osh).  Fix them to match.
> > 
> > Add __io_bw() and __io_ar() definitions matching the kernel's
> > arch/arm64/include/asm/io.h, including the dummy control dependency
> > in __io_ar() that orders MMIO reads against all subsequent
> > instructions.
> > 
> > Assisted-by: Claude:claude-opus-4.6
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ...
> > diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
> > index f02cc8a2e4ae32..fdd22df9174b88 100644
> > --- a/tools/testing/selftests/lib.mk
> > +++ b/tools/testing/selftests/lib.mk
> > @@ -5,9 +5,14 @@ ifneq ($(filter %/,$(LLVM)),)
> >  LLVM_PREFIX := $(LLVM)
> >  else ifneq ($(filter -%,$(LLVM)),)
> >  LLVM_SUFFIX := $(LLVM)
> > +else ifneq ($(LLVM),1)
> > +$(error Invalid value for LLVM, see Documentation/kbuild/llvm.rst)
> >  endif
> >  
> >  CLANG := $(LLVM_PREFIX)clang$(LLVM_SUFFIX)
> > +LD := $(LLVM_PREFIX)ld.lld$(LLVM_SUFFIX)
> > +# Selftests link through $(CC), so point clang at the LLVM linker.
> > +LDFLAGS += --ld-path=$(LD)
> >  
> >  CLANG_TARGET_FLAGS_arm          := arm-linux-gnueabi
> >  CLANG_TARGET_FLAGS_arm64        := aarch64-linux-gnu
> 
> Was this hunk intended to be included in this change? It is not
> mentioned anywhere. I assume this is the only reason that the LLVM folks
> were CC'd on this series.

Er no, I can no longer remember what that was about, it wasn't in
v2. Actually I also see I forgot to delete this patch as Will
suggested in the first place.

Jason
