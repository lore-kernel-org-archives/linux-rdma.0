Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011050.outbound.protection.outlook.com [52.101.52.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C029DFC0A
	for <linux-rdma@vger.kernel.org>; Tue, 11 Aug 2026 17:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786470402; cv=fail; b=TEEAViL8gMc/cwzOZ/DT1++9ATFnPFsTvSViQzuSbgEBXiIxm5PLON9DQ065qDQ64NX+G7MiR0/PfCRsTk9GsSFhfnt/f6rOo72eadnJPkrDUPBOc1i9jrF+PpF2BtiB9Tq6ksz9+E34tJNrxFd/jzmYxQc71nlDT+ioRDCbspc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786470402; c=relaxed/simple;
	bh=2eAEgamq0ehydpBvqMA0kC+7q5y9GJsX4Mo9I8meCb0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=JNv9fzMRZULRmoOI78xafcUi3noSNbWiKx+Fqa28UYRgcyS0+jClMrbTBkOrqqsJM1DFUy2PA4WVzppRQ6Dww3/etZDA8RTd2r4zPNSjkQ8/rZTKQx49wZXE22gU+mEpxaYzy1+RlbpwgSgcjCZ0Ub6nzYBJjAuWyxM2K+NnNTk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kjJOFAGp; arc=fail smtp.client-ip=52.101.52.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kjJOFAGp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ye/5EZxZL57FzraCtXKIumSp6MqAOdONCumD1VJ0YSbdIQxmqOVoWoOISRgp5bTX3ZvGVt14XSYFaufsBRLHC96ZyD2Nt6+V+vzBd68tva7RCVRo/vNUHyQ8I0d6n+7Vd/gX155kTzXjs4orCM6AcGHoza+uhVGQ9oLmI3LtMnvXVO/cAh6broxc6aiyfZ/gkOrApAL5Y99ThYwFEEaZbtYwK2V998RAvr9rQ5N9fZSyKBVeySOwRqzVDyv9yHvy/Cs+UsUk756etdDSVw7dhcoJwxmQRMpFnPv+7o1ZBBtJ5e8chvCeWzEY36Ti9RLHpqt4GthRbS1lXwKwVzNdyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rPIM1wHQo+dYwivGPIQthqEFzEaLUvfYZRm/E/2rRk8=;
 b=NFYW1I3FMkSddn3zlpb+ejhJPwK4y57EZnv0XIFvdF0/bp3d0fQRdj2Hqi3PUmTvQvhQZ/irjQ/x0qYrcv8HFu66cXJivOE/wnYZu8Pt3Kjp+KCwYXIjx5GfVLmC2bCyYCU7En/tHfaQW4F8mdWGeMACm3zvf5kAhqAh5UlR0fi/eQhZ1UKmgO57ZNJWnFXwl9dk7YaxzroE8rJQdzpvd05L+WamU300AIKMGTpLIIepWvlJ4t70P9wviQOskAYS2iddmkIfSa91Z4H/t5VarUTIMMmKmeAbsbEeoeYP28r0PmT6uyQ1c4fKeNTLE0huEuBO/zni2e3sb0T7JbLLAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rPIM1wHQo+dYwivGPIQthqEFzEaLUvfYZRm/E/2rRk8=;
 b=kjJOFAGpFdeRwKE/wZ8Dp1uSFSDKk+tvKdK0jnM5nT92/cIi4s1cSuGHs92vqHvd+WpnBfxaruqsy/pcgLJnQoetCQE3UxcdOTVjI1x12a9xzj8HHPGmTjqDlXT8Szaw7vhX35MI7LozKXfhr/+KZ5FZAHMCFQUMl3vkaHxSHjb4fQC3tiufsfIGWkp+UJui1LY3w3gRBHpknKEOQzR7zGBHNvALfhlRvyVY10xh3UfvW+owvvrvi8T5nuIXs86tOwy0fD4tSpQQvFYyv0IUum/2lsr7vIbtv5qdyZ5eAjpck+PpXPla6XxCEcEqdAJo7Mk6syLXiqstTB9vrfPpiw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by IA0PPF84D37DD5C.namprd12.prod.outlook.com (2603:10b6:20f:fc04::bd6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.12; Tue, 11 Aug
 2026 17:46:37 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0315.011; Tue, 11 Aug 2026
 17:46:35 +0000
Date: Tue, 11 Aug 2026 14:46:34 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Norbert Szetei <norbert@doyensec.com>
Cc: linux-rdma@vger.kernel.org, Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-rc 2/2] RDMA/ucma: Lock the handler in
 ucma_set_ib_path()
Message-ID: <20260811174634.GA640288@nvidia.com>
References: <60544A67-EFD6-4D5D-974C-D983445F1070@doyensec.com>
 <2823D190-92D5-4714-8769-4FB643C64FF3@doyensec.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2823D190-92D5-4714-8769-4FB643C64FF3@doyensec.com>
X-ClientProxiedBy: YT1PR01CA0112.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2c::21) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|IA0PPF84D37DD5C:EE_
X-MS-Office365-Filtering-Correlation-Id: b68c5ad0-9b85-4236-fb14-08def7d07d0a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|10067099003|11063799006|56012099006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	dJ7CI7aeeO+3QESDm4EHb1c4ub+CjIR+WWcj+bmkJLz44pMVZF6G3q2LbPksENswU/TBttT1xWpQvE8/8KK9sMasyXVid8WRJ0dFy4GhYcYENPM0B1PtA+qB7IU9c/7ujy8mJ6iC+Zc6DKQHtlANH8hG4iRCF06nzL4cL7vUyJ9+FaX9DMl580ly7hxyKMnNh6FOHDw5kS24S0xujO+zsBKHkF/sGVkSsL9xJ8AwIfdJutFg1j13SmVV0L0AUNMYPkMX9gtV0P2yfIZtMjjKRJxZJYgnhdx7ugARRZK6ghpYntVZTGXxoDJDoAhj4Z1zPg+Wi5C6ftWs72+VOFJAcULnILTBHxZtFHwKlQyp2U4Dx96I+nOPqfltSx1c7ZcFpmddadkkiPLhgIPxLJ9HibAMMCsoySeDtkCWewAzVN8vuejA/drFkTbnQWWIDpajcs3Z0HsZg3nbdANzI8KBvxd/3waSelcO9WZThrS1lOsQTdq3xvi1bMBvGtQAXPYpGG9DTh43XjaYWMHuxXNcCTvg2C7VqR2o2y7IfORwAz4lqjBaugxXdPZB921cUEMo8748nTJBoNOcwwfmtm1EVbuLIOlKG9XY5SZMdq76cwRY9MGs8xoYfQcFovA+Os/7gwSTSjnfIn/t9duJLe8J3+5fAj9GixkkIqVGC1MHM5o=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(10067099003)(11063799006)(56012099006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KRplxe0VmPbKHVRfaY7vjpGscII4daNto81s5ZBNytTRQT5X7/XblZcFkecS?=
 =?us-ascii?Q?OvIAi2YuPo8v6QEkoDkUmmqnRp5Oeh24aIa8vbTDINEkXGi15f/ph4Zmle+w?=
 =?us-ascii?Q?OH4ULjcup+Z5YuZOdJ337P43TnSmv4IG7nDn+qO2A4+FbdJSuLBmuHpxjSxE?=
 =?us-ascii?Q?Ezo32ReVj8uW4AAbcf0IZg5Nx9lCdcva1k5vJvrWQkdlGfbtW5sC3VLY49OG?=
 =?us-ascii?Q?14NmH1UIwutw8fNhzRNSMPOqxY7U49O/fyq5fGCsMsf1fmQUgsiMgxk80ZPy?=
 =?us-ascii?Q?juIPefJ+bScZw0LHEb+bXgkfkvaNkCvcONaYBQTkIqzXYN/gHcZx38k5gN0e?=
 =?us-ascii?Q?uDW0doR3qQdVeBXet4XHtZA7vp9CpmPn00jlpsw70NdDCpZycKCqJbqvXODy?=
 =?us-ascii?Q?xFC4e6/Ge+LTOdqA70I6YT0fcWZZLRPaYifoGbdqq79GCEOQsJWIl0XAm8tz?=
 =?us-ascii?Q?RuKBzIqFbSw2o6nMENWIADp71PXaqVEH84juidQOPJIMpOiKKXw3auAUEr2/?=
 =?us-ascii?Q?isk/Z0juPuRgU5BLoq6HF7MW+rJ3tZtzeS54uvm7fUDMfAdOSwLy91H3G6q1?=
 =?us-ascii?Q?06w0Luatt7jtIlsq+gftLmSByty6e2e4U1im5zBy1v//Jzd1oUebbmAWs89r?=
 =?us-ascii?Q?obJL9Yk8j4Naiiqpd51kk6h75mGDM5Iw7GAiNDSibjgbQ+LLUYP7DjCoQzT7?=
 =?us-ascii?Q?RzT1fiKFpyPcphUTjrkR5yPhD4/sDhOCLo8acE+uyy69Qh9HAca2+WB9b3yM?=
 =?us-ascii?Q?IufKLYIjy47SY82UxJZCgECTxtUdYGHSDjctOgG6kWh7wLt7QE/dYmqtboX3?=
 =?us-ascii?Q?9DBlNfSMaJrN9RMWQme1QBxlk8dDCkhy8Tyk+x9/asSg6CxrRaKrjFDSoep+?=
 =?us-ascii?Q?+Y3a1CS4/vrulAgLUMZftNDG5OmLf5GZc4kZQd99BIT5tPD5Tf/DxOLsRb8l?=
 =?us-ascii?Q?vgfSbAqK/sqduFIVuftt0o1CYJonCBFpInLIIpdIguetbZhmI2yvCTii7tTF?=
 =?us-ascii?Q?Qbgmqwj55qxGsbiVzYX6NH7hO23NHr5ERdetPLu0x14s/7qvJZ12+sunPMEo?=
 =?us-ascii?Q?nVw5F/Iakr06SnQPIA/VnfVd9iBY3648OS39ocArhXSbXebel3TbP5PlmqM6?=
 =?us-ascii?Q?LflETQS/6ejY1BLIZLul0ePXofNGPsstNI0R3JQeRI+LDmAbDpxLD8zgoiH2?=
 =?us-ascii?Q?68dBGelL3wAssd8R7tiqdJINA1cGzWjfrRIeGh5L+NvwXr7LU95dwRVaOoYn?=
 =?us-ascii?Q?NApH+GCgggm+6UxNiWWRjTMNBmhpyEgyFwO0rBa0xKrhXbhAL7DUUcG6ilZu?=
 =?us-ascii?Q?slBO4B/E+Z0sDew0QL2HbVYEZudqrdFTDYb24jUYvbrDaF/F2B4rTCb9eKW3?=
 =?us-ascii?Q?1lB0K7oV6iIu2SxHqDXO8ZRPUxeJjteNdYVrG9SgV0sR+tJw/k7Lgy+q36bv?=
 =?us-ascii?Q?On1eXN20n9bE2iYSYdihCOc6tzktr5LJ4eMQNwTAZbXO9vEoFyYjMKh4Mk1L?=
 =?us-ascii?Q?DMgFHTR3MImIuCB4qrLNKeD1We+JDItu9fjG+j4PEXHPoGF5OGGbmR6BM0ky?=
 =?us-ascii?Q?rSkq2f+cAxH6cwpV9F8TVYAkd8ElBwOzzXAkoS0apEtccwJbKOTlwojdD6zV?=
 =?us-ascii?Q?DZmTiVQxXij9KOC5FwZI59M4o/qxfonAio8o2zNgcR7MKICAJ+fpluiWyybi?=
 =?us-ascii?Q?nYvG67TLey1m4nLNWDBIeoKZyNEIHBQSk8PZ1GBnqzZbY3j1icL90KrjAnZ/?=
 =?us-ascii?Q?f78JbQo5Yg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b68c5ad0-9b85-4236-fb14-08def7d07d0a
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 17:46:35.8548
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D08tR7/f4yaabJINWDlxKC00W0LVstJhw/8SNRMJaBSEi4JL7jR4K0giBWvy8i8t
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPF84D37DD5C

On Mon, Jul 27, 2026 at 10:08:36AM +0200, Norbert Szetei wrote:

> diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
> index ba4dfa7f12de..2347c0c59b90 100644
> --- a/drivers/infiniband/core/ucma.c
> +++ b/drivers/infiniband/core/ucma.c
> @@ -1404,7 +1404,10 @@ static int ucma_set_ib_path(struct ucma_context *ctx,
>  
>  	memset(&event, 0, sizeof event);
>  	event.event = RDMA_CM_EVENT_ROUTE_RESOLVED;
> -	return ucma_event_handler(ctx->cm_id, &event);
> +	rdma_lock_handler(ctx->cm_id);
> +	ret = ucma_event_handler(ctx->cm_id, &event);
> +	rdma_unlock_handler(ctx->cm_id);
> +	return ret;
>  }

Applied, something went off with patchworks and I didn't notice it

Thanks,
Jason
