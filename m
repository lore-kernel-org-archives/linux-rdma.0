Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010022.outbound.protection.outlook.com [52.101.56.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB1503043DE;
	Tue, 11 Aug 2026 20:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786478742; cv=fail; b=pI2Vw1clzRTUDI3/labsWgsjeOxr4QpS5gvojHT5QKZ5W028RiJjTfW8eX9xDn781oEuvppqnhZL08hgnd57It+3WHQERH34cBhzc6uLNoZyJVvObbvaVULEx6xXP9C+0kWXbUOuPIZdvxXj2HPmJRyllCKPKREIrPC9pPqPlUE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786478742; c=relaxed/simple;
	bh=3vPa00k8Xv0dT2RaY3ss3jpz8dv9UGWe2NTh2n8IKVU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=M6wmxSqAtvEzF4eiStP72ipfLgEWN8t4h+rmpIg5Li6ttZ0Ore/McSNYBGd/1cVsMt23UGgTc7ZVhAoAG/ayT7NNFIe4CbwYHZ+Dks/hgwmP/zIuk2LmCVp2swG2mUJEqsuSe9xOeQL4VGqWAz/TIL24FW/yF761jFSHhQvrUwY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PCIwjR6H; arc=fail smtp.client-ip=52.101.56.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PCIwjR6H"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OZrwxDbnigLFE7+/GdHNmFCSg8Z0O1xMRKT8yQRgUGdH0zMUvRXQRBir8M4V1okbj9vO64fx+7uesNsABAYQR5rTW6uAnMSnClupPFaQweidNv0EIE5mmi6Nzl1sYGHTnECVdcp+NzlcGTQg6fDJ4HRbF27To0gbg8LW/rk7bdPwqBx930+gqX/a4NqZG2pFZZonQcR3JoBeumhLFX7fipoi2CMIlvl7XFcoyzyHLnmJVxkq12U6skJ6dNAByGtQxFlFf/jnitGrZVb4Ph+N1Z3oyBmZ6b8QZpvxTt++ptfYDenyNYlqfqvumX6UEUbwMKsLcx7IfmxqLOCCs7TTkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+qPe0qu06R3xqyDc+sXvmNsevuD9HvPWY40EGGytKTU=;
 b=RYFKGw7+obgi5A4iSIrtVzi81L1aZfAEUmnbRfe7e4mAgM7XUZt4RFCCFrsZ+0G7Wqu7dltUpnhMXNnWqv/l+sD1DWmwfkmB91dB3a95xlLxY+jzfd/ZLBxttTKpTpCG80rdiEPdDdM0f9P4xznMFl9+jXALGaixVTftdQSG3SFrI+MFaGMr74HdWhKhUuC1afThIB7GsubWb/ZKD7kK9/b7iAFq7RvebNnG+Am9n4A6YpGfYLeTRB54j5vP+bKAx2vCRDHr8mGmRWjD1X8tUN8NguW9ySzmfiPZIvT2q/t+Nb6PNed1/zUR4XTW6CQgW9c3dBNmLSJnGlyHIU0ctA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+qPe0qu06R3xqyDc+sXvmNsevuD9HvPWY40EGGytKTU=;
 b=PCIwjR6HGnAAkoX/tnjTS1oRUQdJiGyV33dT+bp1HQV0Hzb36x1SIqeNm0VZg3KJVrRboLwuHbKu5tZleVoZ4/WWWzMhkQAEXanNNw9e4l+rmgOatvxGoZb2J52WFlSZEQpguUDX/p84IagvdfuKQvJAKosi+LwcBDVplY/Pcr30ub6doShXWaYTvCqfj7iScjnDPoL4vKGljPK5tFS6g1P2DlT79HSi/wwqZl6ZCpwbX8i9wu9eRRhW4PnN6952Nc2lF1kmAOxw7kMANXl5Uj09D13frcMIUmw4mpRHPFiLtDgly0HSS6UW7WGS+OOfgzgezdFi6smjkE3yuIEm4Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CH2PR12MB4261.namprd12.prod.outlook.com (2603:10b6:610:a9::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.11; Tue, 11 Aug
 2026 20:05:37 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0315.011; Tue, 11 Aug 2026
 20:05:36 +0000
Date: Tue, 11 Aug 2026 17:05:35 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Konstantin Taranov <kotaranov@linux.microsoft.com>
Cc: kotaranov@microsoft.com, snsanghvi@microsoft.com, longli@microsoft.com,
	leon@kernel.org, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH rdma-next] RDMA/mana_ib: Enable multi-port GSI QP support
 for mana_ib
Message-ID: <20260811200535.GA665282@nvidia.com>
References: <20260810092352.2216082-1-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810092352.2216082-1-kotaranov@linux.microsoft.com>
X-ClientProxiedBy: BL1PR13CA0290.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::25) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CH2PR12MB4261:EE_
X-MS-Office365-Filtering-Correlation-Id: deaf440d-b1db-450c-8d78-08def7e3e8b0
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|10067099003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	+Z+A0qwG23IyYwclyRaSkK6TZAWVhfuIwTcNmK52etxFS9OrY/d/mU1FEtWrkAIq+RsI3BWGg8sVwegrhHxWR6PiXxJjLB2c9A3qKyfwHOWYbdldbOOgGABeCcACVDD4d7ZA+OsF7aU4gRRLmKYXS8Yzggr0lboACKLRoOiu2pN4LA/m3hs9qS3b3w//4nP5ByCVMAXji80REnfQ4sx+HBk2Jmq1y6xueOR8xKNU3D+Cv8DIff+1rDxe4YOfIF1epTmDNDRM4y3mES6+x2vZBeTj9yg4HNyhbWxGKFSN4g4LoO8VZZVP43emb8qs1xnkjbbjGly5Xb5yPQcyeQQEfgtHsR+PzfpbfvAx8m/73gPXPb9erEtvid8OpH8R1VFzV5P199Abxk8ncDFd8pqbj0YGfqisdTgE3nObynMAwLL0V0bPiK0+AapprBMLpdqXaqCWXFjGy/p2c6LbqG1XBAySlBlGwyEvuvXg8zD9CLI/Og8mijxoQdCbwz/Dp0Gzudbu5q0+1pZAnONWHPClQWMg1xiXChftBUSfXJoVy1r3syOr+swGf0PXd2ZA310L+cBKw2M2gq3JXaf5KpwNo1IG3mvEtgQw0PYEWFiKf/MK+P2T4hcGeLhWtU95idM8ppq13znKyQwbYwCCZ/FKTCNS7Qw4X1ASnZCzIMLV/fk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(10067099003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?M2ZyXMFV6co+p/opLPsCqEmtAhQKbDNA8/2QxsfUAVgasEG9c47W8autRbIe?=
 =?us-ascii?Q?QbpTGLw2We2fngo1WwWWKiQblIul6oqh5JKN37hWMLFpohevvBtpE9fl/gmd?=
 =?us-ascii?Q?LVyVO6l/E42mXwqpDuHfg41knYl27ULIj7xRW8PDeR5orjQErLNwfZOLGAi/?=
 =?us-ascii?Q?6oB9keNVR1FXZARCU2GPBxcCKWltHSAo1CubyecUXON+xgfapMZzf1TC4wqH?=
 =?us-ascii?Q?B8xpn5xyQEUqFRXKUFDWn+M0IXqyYQUdAZ1KzbjzyQD7JnMeJ22FQ2gfnRCc?=
 =?us-ascii?Q?S+9hwLOQjih5sm1Wu8hPGEZ+h8tEd0Egyt2sOaNi0G631mOt3g4KyOO46nqM?=
 =?us-ascii?Q?iyJ+eETtzHOLqbWaDeMgaC2M52t2cCgtsjhIuOMLhZqbShzpegaDt4aKz1kH?=
 =?us-ascii?Q?14yxbIm8gwuw9HYf4ioETuVWOEsclQovysomuCQemWEf8FByDblQsCEVZmJM?=
 =?us-ascii?Q?g1r+OkrYDuqY4GJMLjlJjQPUP+7O+cd50dcjYaN67zqWstCcDoANnxbiAbo9?=
 =?us-ascii?Q?6/QlOegSN2KCT0Prwo2mwukjbTXhCSNJK37HTuXI0W0neWVCyvo9pUWAAP0n?=
 =?us-ascii?Q?mgX8j3GtFIdO8SR9T2x/2ycK1rR1ru9ovygEC8kk5Xm1epMZrtUFhTy6s9Pk?=
 =?us-ascii?Q?FdwEGU1ezgXgkOqp65XMC/7BMBtRW0jKNzaS7/0VdgXHQBbS44GE1+XOyG9V?=
 =?us-ascii?Q?pS8wvjWg7ojf1ZjUcSHLdb+rl3OLiFH/3ic/rYOiACX3GXIGBU55QzPsjNh5?=
 =?us-ascii?Q?uq7AR6L72LA6z8K2D2gTD1UbRdAzInk2tKUSm4Ik0LHckztoZyfV3OHLXT6Q?=
 =?us-ascii?Q?4/uuEicQgbxugaDcONIk1r6ReQerdukIjW+ZaFe0pkfBN8kaz3H6FX17xG4c?=
 =?us-ascii?Q?BQSp+RIY8zeZk4RIzyJLbItxwWwDQmiPFTVFg76Q67M+hGOxb6iVg/nj7ni5?=
 =?us-ascii?Q?jIWJlWIo7m+cHtOSjJXj6xG/EjAxEZipx4GFNpVOsCo7N4nCZ02ZkRVV4FlB?=
 =?us-ascii?Q?KT7pamIFHfxKCMinBHXFGJ/ajjMs1QvU/IZULOpc+QWpAE80hlDTUJhwFJ/P?=
 =?us-ascii?Q?TSWeHPKD5ncR+a4rmTcC7zPTmXP/hyM2/J/Wkm1+FysML6CGgydD0q2Pm1ru?=
 =?us-ascii?Q?RA6xHCH+J6QDh4QW/19+yASG4qOfFaVe07KfwD9qZBC609kKJ9o+hHnIaanh?=
 =?us-ascii?Q?xyeCWrw9YBnyHZVoB+t9XJHSt4lbom3RCkMtpJ9Q6oFRXgM1AaWKmmSJRfDL?=
 =?us-ascii?Q?R1FDNe7kyuiWpTgAxBJkeAGpPcMMYNN0JcfKGKXC+RPsajtcaArz8BWjsf41?=
 =?us-ascii?Q?uLOfP4aqYuHhTzMV2rphKmkdsPdhcSFR+lpURRtMZpOCLy0nmM6kK1iiSKqg?=
 =?us-ascii?Q?Q2OMtttCCU2kfqCqPmiVJx9oPurxAzQbC4YirivgmC6H1qu9IA47t4zc54zP?=
 =?us-ascii?Q?FidbmOufcl7gf2gpFSrUyKY+fS1buaVntC3hHTf668P1gK4w48R6TVk6HuqC?=
 =?us-ascii?Q?nvdPAE3sSWOFZg6ZZnjl691rSrQmL/mmUtZSyB974vnz2KEp1pqt7xkkP599?=
 =?us-ascii?Q?ogCFauAtQ/lnMtKsegDo2SFP9fb9UleM9Y9eQbdD9Kwd0d2L83LDEMkWC5ds?=
 =?us-ascii?Q?i6uBwMRKQ6acgEJzWP14fLSJUnHMAf6f1OdWJH/LBEIfq81AP2zdi1lCTS84?=
 =?us-ascii?Q?BbX8cREgREe5HIFp22yONQbuiBqM9bsMXPb1FyUHUAs9K5HkzKuhkrHygh1I?=
 =?us-ascii?Q?9B0sjBsJbw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: deaf440d-b1db-450c-8d78-08def7e3e8b0
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 20:05:36.8458
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ijvCk0yLWeFAiQToV3UFivpm2cCEZyqIjJnivAjSeiTdX8ZwIaAddy0eZ8jbrCAt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4261

On Mon, Aug 10, 2026 at 02:23:52AM -0700, Konstantin Taranov wrote:
> From: Snehal Sanghvi <snsanghvi@microsoft.com>
> 
> Add MANA_IB_FEATURE_MULTI_PORT_GSI_SUPPORT so mana_ib can create a GSI QP
> per IB port instead of just one. When the feature is negotiated, the port's
> vNIC MAC is passed on GSI QP creation and each GSI QP is indexed in the QP
> table by port so the GSI SQ drain can reach every port.
> 
> Also move MANA_SENDQ_MASK to BIT(0), freeing the top byte of the queue-id
> key to index GSI QPs by port and scaling the feature to the full 8-bit port
> range.
> 
> Signed-off-by: Snehal Sanghvi <snsanghvi@microsoft.com>
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
> ---
> It is rebased on the series "RDMA/mana_ib: Extend MANA RC QP support for UAPI".
> It can be also applied to the next, but there will be a trivial conflict on
> adding a new bit to the enum mana_ib_adapter_features.
>  drivers/infiniband/hw/mana/cq.c      | 26 +++++++++++++++++---------
>  drivers/infiniband/hw/mana/main.c    | 28 ++++++++++++++++++++++++++--
>  drivers/infiniband/hw/mana/mana_ib.h | 15 +++++++++++++--
>  drivers/infiniband/hw/mana/qp.c      | 17 ++++++++++++++++-
>  4 files changed, 72 insertions(+), 14 deletions(-)

Does not apply, resend it.

Don't send patches that are not based on a public commit, I won't try
to fix things that don't at least get a 3 way merge.

Jason
