Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011030.outbound.protection.outlook.com [52.101.62.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7CEA4E36C8
	for <linux-rdma@vger.kernel.org>; Fri, 18 Sep 2026 11:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789732344; cv=fail; b=LiHE/8gZBLyxVJ3boAcRJiHVdERY59QlSEM+e+xzrGKg1JR1FoNLVF043Aj/saOc5My0+jrx7Tyw/8CB6y0v8WKSoALWeVL/4itDiw1quWNWJla5vekCtgz25kJjfnsX0ocT58QvQ2b3UKJvZdCySkA663POdWcJO7HqV0u7aLc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789732344; c=relaxed/simple;
	bh=zeg5iFxF2J4bFl0GACcGOgq3L05e8Okq5JKyTkqkU28=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=pnXqUsXVkePAmTHMLAmBotG00owGxZb8yE5aF8eiYaKUyy9KNndahpAsfC/YFTyhrIMr94gkTibBXJ4w6XVOWUCRSd0YkkTvZ4xeqbqFT0ck1u94eDBxEmnJH4c2F8xOwZ9Y3TxSYhfn7EvAbpH22X0rMTQlnGH7YKAR2AzWWj8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gyZ0DBOz; arc=fail smtp.client-ip=52.101.62.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gyZ0DBOz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WXDaivNLaUawVGXmbrwn5TU7t4Xdghw3OCi6QTTI+VxxLD8e7g2aYnsZVcn1/865rDTWq3l/jKPgi3unSPpVIeZ8lfX5J4tcSHKQvteWwAeihS92+2l2/WVXbmiW3u9cjZCmL8SgleD2XhMAoDtiw5OLLmAjHkyMYM1DcCHgrvQOqswuyjYKUCaDq6fj+phzWeKjVhoEp2frdphdAWPr+BZahJbpxa5gRcH65qxuvRoaCPrI3A2DiOkMR5ZXuU/O5wsnBpaGil+sltEcUHjfm7jgtva2zoOFJtdcuQfIh+vyT72rIKrp8g6fPRlDbvN0YxdHNBxJYrS+BHAnwMRw7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EJSIR/zQLt9Nq13Y1WYv0j4W6EStOQQnb/Ojycs+5Uk=;
 b=jNdQICCxZAPqGvtCzEYTsMS/it0UsGHOJcya7IGbtt6j2fNMKyyNUdK+jRpM46TWsDywki0yIKY9UKL0TWoWmsBmHCCbZDQDl6AC3Fhj26PVf3eXuFShUoHCxn3O47WPDtajx7Enw6YlxPvLQ6qfY0ipERCTxXOxLerMBZrN53n+nmn0TyyWSid3e3HahtaSmOiVFb9mzeOEs6MwYwmueyvw/v0UFUBiex1Sp412A6iKDnYCit5KRlH4/LnyMlTKaS7mB8GA3GWbIIZ8tk0zz3fbflIWcQHowHF0A9Gc18LGgfWzUNkm7LfV1smwVzRy8uChNJ9utDyprAJyY8Mr2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EJSIR/zQLt9Nq13Y1WYv0j4W6EStOQQnb/Ojycs+5Uk=;
 b=gyZ0DBOz/CNVvKepe5xKbWqVi5pIB3d63jtUIor7cCSo6VwE/Tzwa6Swqxnaa/1eHABtOHbMyDNbTqWfoDpgzfULY8HQp/Ncuuq3hPpBaikKnPLnOoYFRbc5U9jwufLDmRxQeFyflEMaSezL1sG+VhYm6S3zTFZmF4niId2TYCBO5t9J+LGAvxaclihwBdBRypQW56rclJidsyTwp8PqwGyDCFzRQXwHyTFuMAQMN85oWN7X8KYM0SXIavrdgROu/5WdSQXoXK2dhd+hnqPL9IOPtPZUbAPgUrHpECTtRD8dUZpXaB7Yg4Fv0BXvAPxi9FUpDxOmCC//8Isb/V4Eww==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by CH2PR12MB4101.namprd12.prod.outlook.com
 (2603:10b6:610:a8::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Fri, 18 Sep
 2026 11:52:20 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0428.011; Fri, 18 Sep 2026
 11:52:19 +0000
Date: Fri, 18 Sep 2026 08:52:17 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: sashiko-reviews@lists.linux.dev, David Matlack <dmatlack@google.com>
Cc: kvm@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH v6 06/10] vfio: selftests: Allow drivers to specify
 required region size
Message-ID: <20260918115217.GA11142@nvidia.com>
References: <6-v6-8af36cf7b73f+e2-mlx5st_jgg@nvidia.com>
 <20260917235245.CAAE41F00898@smtp.kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917235245.CAAE41F00898@smtp.kernel.org>
X-ClientProxiedBy: PH8P222CA0002.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:510:2d7::31) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|CH2PR12MB4101:EE_
X-MS-Office365-Filtering-Correlation-Id: 74ccb495-1fc8-43d6-cd32-08df157b4b15
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|10067099003|11063799006|6133799003|18002099003|22082099003|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	BIZZRkk3YhfQfyFLrPNOblfrCxkwdHtBNjQfYf+FbENQ22ETzeCA1diUGS9Wirn2SJjRfU2gmbhEVv4N0+bMXzMqtbCD2r961v26r2+la1L7xoMe0DKRwo16zoIypskmyc/bF20Sz8rJGxv6dsrYvkeiwAUY48FXodLHXM7/1h7CGBm1ORXBjddvKtqQu5r+cGdBZF3y+gI7DeAvWZne/2asTYKKga/+ZYHtAw+2CX+fLI+TjiwrQ+0c0HsQN2XmayaKq3GVoVqor+vgeqt1TEw/uTKza3bKcf0tHz7yrL6LP5/+7hq+fS1xp+wk/fIJhVN89kwZMXhRHXK3I6ewA5UNE4urg6onKs2mjS0Ehg4aXTrF5Axb+lV7yHsvmrQouXRQApR/M+01YH9Hxlf7eE6hkcyQjuJhB5G/qL0ghynAMEbLRWE5wPrqsWXZqGYrhyE+3dWo9d4TqB11Vko6WRefhoYRwwL9EbG0nf2YzcQJY3QDNU7IspT9QmRnJi+q1E26dPD887vbjqvPfTop8RQtPiR1iWrXKnNGLKXwWxB76EaNlg2r7qdw+YCrQCbztuAGB684AiWktt9s48e9bcgP/M55FooCCAP8QNIHHh32BFa8wVic2LuZSQRFNLjpxdOZNB/fX0u+TsrfHEOUMVN82tg4zCHzsJGbHb1LNAk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(10067099003)(11063799006)(6133799003)(18002099003)(22082099003)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AbheKcJsrW4KH+2pN+6KyOFJtwcRBpTsejtP+WmuoyShxf6frz7fuPVxPQMZ?=
 =?us-ascii?Q?Dj0KjnXjkMvoNFPUcneLDY9jHX4Fj53d1Xk5b/BHSf2G9uyL93N7/CD4pwUt?=
 =?us-ascii?Q?KQJSq6WhSA5ozagpJCLPvsrgXPPTAEcXw2NwR3vL6AO/w5TYjMlABSeg6E57?=
 =?us-ascii?Q?9z7Zbg7CQCSkssG506bNaIcmogp9IgjAhJGOvAdd4pQTBl1xpOqyldtn1Gwh?=
 =?us-ascii?Q?jvVgVR+oO+zLVEczSww/JKbpcqfGYtr60pNLYUSgidhvoZar/NmTw3euEPBR?=
 =?us-ascii?Q?yLP8UfaaCfvZeMJuiYcwrzcDaIKysUayXcUIaGMJT4ue1hqZmeynfD4SuRTv?=
 =?us-ascii?Q?ODz+xsk4gMiC3rkMwZnrWJH3di0j8XBs8PjB9zNvknIFJGBkXjAUydLZtJJP?=
 =?us-ascii?Q?y7s9KivHx+3UxLnrbdUYfjuL2phVtZud8bWE1bah5gzttdKtc8BFwW7IoXB3?=
 =?us-ascii?Q?TjSx1Klh+BgsXDwwxnz19XuUU2TOsp0awU/p3tix0mmaq0Q/X/5tlxmH44//?=
 =?us-ascii?Q?CQjnup+hdg6cDMEK6ryrZ6K9wMCRiGDyW/VGhXt8BkK8/pcmQ/Y7mKNUcQJ8?=
 =?us-ascii?Q?+R1/FoCWtQmnCcsu4PWymQK1FFnsllGpG36xNkbzccbpCEBuzYD4ktsdcJlK?=
 =?us-ascii?Q?Iznxf807Tnh38R/mmOiU2SfJdNyv7VQtM16wAAFOXXzy2o0OC7TeqyGTYe3z?=
 =?us-ascii?Q?B5nsfBBVxVFlzOU91bnSaMJ+35pQD2fQmNqI+jRhOzooYd0Pamoe8MaB1lmk?=
 =?us-ascii?Q?QUMsiTdYwCCbDG5FQpWYySbF2mrHRzhlpE09F7IAAROtJFbEE0u46hTCIi5G?=
 =?us-ascii?Q?YyItr+isIOMgOYNo4Vv+OnUT4ceg2d8vWWjxO9CppxHa2SXm1RkM34xhePyH?=
 =?us-ascii?Q?OlE2p9Tcw1LQHsUds1rPoXft6eQjPs45gNdhJtmVVbGxfO6KZWdvwT+01Ffk?=
 =?us-ascii?Q?uvmRjIJOJhoTQEGSEpaDfozA/bAz7M+NwYs99sMdB+aDVgmbLPzRofQ/wCsy?=
 =?us-ascii?Q?A+nS6m2Eexl2j/xcaEqeKT0x4mBAnFpvmxvq7WdqkNlkvlj+P7fZEUnessEC?=
 =?us-ascii?Q?S7227qnMtyK95oh22YTLkRgxsAvz2oryGuUSLBJQUki7LqQpCZMcjOcatblM?=
 =?us-ascii?Q?7yURWx4kv7BSapu7QiCC6meEDgHjhxP69hOoFtZv7Ts0EBzGP5tKAY0FMFiL?=
 =?us-ascii?Q?z9p3pJHjO8Wr5f8ytnFH5+BRWrIv1jA2g6jNMUEjMUKJiEUAcl66cTTBE/2L?=
 =?us-ascii?Q?GDcLo2chavsjIJLBaG6GA871Xk24sxWy0X3++Vu/l+KERGgt8/Z0/t7P4Apy?=
 =?us-ascii?Q?8JUaqeFtKkFsdzLggfzXOkxwajgfaxhbqrg1LhNFJRAHpM8zxL2ZxBYgozEU?=
 =?us-ascii?Q?7WnNs8kJDUTYY9s/y9DOekgAIdDogWZcT2JFoGyWAo9F6VKLH5A0JmetGPw7?=
 =?us-ascii?Q?mdO0KOeAnwl15hcc4AheQnJCxqAnEAPOXJ7JITy5HZQtLQP2FC28Q+gfA5rt?=
 =?us-ascii?Q?veYBfk5yLUWH/tpprgguDkPFOQDQ6HILafNMd7TEWrSveekQ9MnTjkb6dKxr?=
 =?us-ascii?Q?/xj79bp+sSGC7WKBfs2EbPGG2HPFDkVRExlZRNlT9vFYTYEEznihiRz/DYBq?=
 =?us-ascii?Q?UmLeEpdS57r6OLYi+jbx/8S0t6xIYKx6hbBmhmbshHJ1imIzniz67ngbPats?=
 =?us-ascii?Q?1fA8M8sfPZB8iH1/rbNNS3uX6BKDftj/550ogVd5aTd/hUqu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74ccb495-1fc8-43d6-cd32-08df157b4b15
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2026 11:52:19.5417
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eDmBo9F4b4VaZKHr2326DJBWfohGOtf3rBtM+34ceNMO/wNKRizd4PVpKSksV3fT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4101

On Thu, Sep 17, 2026 at 11:52:45PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] selftests: kvm/irq_test overwrites dynamic driver region size
> --
> 
> commit 97ad8ed7fec97be65848236fd1c8afab2ff66a54
> Author: Jason Gunthorpe <jgg@ziepe.ca>
> 
> vfio: selftests: Allow drivers to specify required region size
> 
> This commit adds a region_size field to struct vfio_pci_driver_ops to let
> drivers declare their required DMA-mapped region size. It updates the core
> driver probe and the vfio_pci_driver_test to use this dynamically probed
> size instead of hardcoding 2MB.
> 
> > diff --git a/tools/testing/selftests/vfio/vfio_pci_driver_test.c b/tools/testing/selftests/vfio/vfio_pci_driver_test.c
> > index 761bf117d624f..2bd949aafd731 100644
> > --- a/tools/testing/selftests/vfio/vfio_pci_driver_test.c
> > +++ b/tools/testing/selftests/vfio/vfio_pci_driver_test.c
> > @@ -87,7 +87,8 @@ FIXTURE_SETUP(vfio_pci_driver_test)
> >  	driver = &self->device->driver;
> >  
> >  	region_setup(self->iommu, self->iova_allocator, &self->memcpy_region, SZ_1G);
> > -	region_setup(self->iommu, self->iova_allocator, &driver->region, SZ_2M);
> > +	region_setup(self->iommu, self->iova_allocator, &driver->region,
> > +		     driver->region.size);
> 
> [Severity: Medium]
> Since this changes the vfio test to use the dynamic driver->region.size
> instead of SZ_2M, should tools/testing/selftests/kvm/irq_test.c be updated
> as well?
> 
> It looks like vfio_setup_msi() in kvm/irq_test.c still forcefully overwrites
> the dynamically probed size back to 2MB:
> 
> tools/testing/selftests/kvm/irq_test.c:vfio_setup_msi() {
> 	...
> 	region = &device->driver.region;
> 	region->size = SZ_2M;
> 	region->iova = iova_allocator_alloc(allocator, region->size);
> 	...
> }
> 
> Will this cause the KVM irq_test to fail with a VFIO_ASSERT_GE during driver
> initialization via vfio_pci_driver_init() when tested with a driver that
> requires a larger region, such as the mlx5 driver mentioned in the commit
> message?

I have no idea, Dave? Did kvm start using this stuff?

Jason
