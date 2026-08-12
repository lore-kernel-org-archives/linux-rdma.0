Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012002.outbound.protection.outlook.com [52.101.48.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C4C33B6CB
	for <linux-rdma@vger.kernel.org>; Wed, 12 Aug 2026 23:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.2
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786578963; cv=fail; b=UppNf51URGS7LXLfH6mNAPbaPr4+EtF/wZOozol8W0NcX9KsxDsrOLzwQVzJ8x7t0CJZ4JydiPyNvmd15CCPjQBU1Rc9xk1xyVMuEmc0wmHV44d6VK/1LJR+NlBVxdzD2IJkFb4Y75AGCtbomXA499Om/8zVjztgLdbSp1+7qrk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786578963; c=relaxed/simple;
	bh=hjgc9cgc0Ln5yoYsFKy6rTPEYiHQS6//WDZJoIDeo+Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Gr2FufDd8W58QEeI3+PwjBUJ54cq6u7yFGQBMVM0WfQo0e7tuxSTxNPhj0EcD+YPOQwE7j8fU7NLXPDVTc8HFwqaYW39VVosjik3yIRoT7DkvQptVlYTFcVIgjbEYf5q0HCDkUWHaraapHDiiiDJam2hIztnXbg15aVemhUz10w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=t/dk96DO; arc=fail smtp.client-ip=52.101.48.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="t/dk96DO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cM8O0e2KTCLErvUBHjOea5FbegundXf4v3HokllHvc8Iu/7/kJtyqaERAbYAm5l0ffzdeMXsn4G3bCi8iXYaE/98qySOpHKc+1WmAH+0MHExHgsINtBXTyBUcDmTMKdesiqDZRgzv6BYVgi+xhRiEkj1iy/2JiPu2huJUtGhX4VELqUCneZDv0OWLy60vShe1tQ1oBpnj3/ujZvgHAeaYwGtYlFz1cX0C2yRXVY6pksnnYgFbOgG+em87VKtEtxb8BhpCDaf2i0FkgSDOgMNO6JjdjY27NaD5S4BqSLyxMTOCR5fX7jujByj+Kik/BUU20c+KAuVm8fSODKHKv3Uzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dexp9dzcF6qi/FtFs5Ffip8QIn1HDTEPBHMQvTn9CQs=;
 b=Ayz31l/KS1eCQrRoii5lqZJx3IrxBSvBUG835uukkdwWzVL1MT9YXi7QcKutA5Vi4AMEFapBu0VvP2edxWMc68WVqMFP3s2ZC7+ZE+cn1+qKnMoU0DpMfgEhm6YiIQ0B8aeizZQkMoPRLoMUe2WyhSJKaJHT3n3hN7y+kZJkOeQ3RlS47Aqccsz6flWeeyrY6n9lZqcBrrQi0LYrhQPZjJ/rH85TVCkvk66dca8pbnSBRIG9/uh8QSRbYahlP4dV+KdSlrQOtkL0ZDMKHJFpQjDNUnZ/AuMnaSK81Qwm1599ZixFhZ0f5+7unH6EZHJvd3bR8QXNyMV19s5wyndztg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dexp9dzcF6qi/FtFs5Ffip8QIn1HDTEPBHMQvTn9CQs=;
 b=t/dk96DOaMB385DQCtg8K+AkT/nbwJ2QJk1iLrNFgbcLgab/Wa2E9szuUkqJc8/DfYH/rMZxffjSesyWhsXJeFTM7c0snypTI/4hW4as3u61NFNZkWHv1ywEOVHBdkARRytUzyKbBKJlJTQv07Wd66Wsu5ZAtTYX3xZvPaClWjZjj0Q7mBxwXo6el9SIVGxl0WbZYYm5nrBJlEyE1ehLcRjs3BUG4C8l5DVjW4O0S3cA8DyWYXBAVDbU7uuBL8nwsPotg6KoP9OkTiiWOZPrKZSBewqT717kirZqWgt9YQ9J8yEEA12INGwdSQHy+oaPMBslJbYFJIx40gBd/cXEXg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY1PR12MB9601.namprd12.prod.outlook.com (2603:10b6:930:107::16)
 by CH2PR12MB4200.namprd12.prod.outlook.com (2603:10b6:610:ac::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Wed, 12 Aug
 2026 23:55:58 +0000
Received: from CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3]) by CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3%4]) with mapi id 15.21.0315.008; Wed, 12 Aug 2026
 23:55:58 +0000
Date: Wed, 12 Aug 2026 20:55:56 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yonatan Nachum <ynachum@amazon.com>
Cc: leon@kernel.org, linux-rdma@vger.kernel.org, mrgolin@amazon.com,
	sleybo@amazon.com, matua@amazon.com, gal.pressman@linux.dev
Subject: Re: [PATCH for-next v3 0/3] RDMA/efa: Add support for 128B admin v2
 SQ entry
Message-ID: <20260812235556.GA860843@nvidia.com>
References: <20260812121718.2904349-1-ynachum@amazon.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260812121718.2904349-1-ynachum@amazon.com>
X-ClientProxiedBy: YT4P288CA0019.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d4::21) To CY1PR12MB9601.namprd12.prod.outlook.com
 (2603:10b6:930:107::16)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY1PR12MB9601:EE_|CH2PR12MB4200:EE_
X-MS-Office365-Filtering-Correlation-Id: e0d7adba-417d-4ec3-abdd-08def8cd4117
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|18002099003|22082099003|11063799006|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	9iNSdTc2RbEC1rzeh35/jA0tg0JDrmo+gnWifrCMbOEYwWHyVkyMCtwHMN+Ww3z6fdl/sU7JrxVozrJPYrgG4qQqnvyxMsdxz15FVLT0A/N3S+G0+Ss0gYMoc8u8CSOAQVZhagyljSaH81fueJzgHxmHPbM017UaCpBqgzETB7ofWkyXObHldqEcOvIJEiWFC4WXEOpiGdxmh0M0iL4N/9fbjUxszzgzOo4kKLCw4KAtahlB9cT9V2/XHf6oGri43Ax5udXtoo6wsd/eMVJEIls4wl5IT9jkriNSbHP4aO6Sif7Cb6s9UwtKvF7J0Fzp7LLLowj0JEOOfewfEGxOo+C2N/PKLYD543wKDgg0ufp4qrMU6c9bwCthf1jLWyEI14oD1V4WR+A6B06FTUgEO2lhfesRMK7wWAKUqtLUcSpNn84USvL5lYs4WIPs2AHbQZNlxZfP+P4o2bJOI7EujToY/vXJ/Jp5+bcFU9kRTJpyAaIVFf9KMPDrem3XsiMc6Vn0qqChcsfnJVTH93HehHyYyLhs5fsAm4ZdnJyWlqiiIepozHLqASlk3YKwkzWQXe1Iidt3ltfqk+E0XpXiVgtzXHm+hD1m5yE3UmSIrBsik4tRgfIFDEzN5wAnTFesdlakWPrnIKqTkIJchMTu5yIi2RgISJDdSI3c2sr+dmA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY1PR12MB9601.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(18002099003)(22082099003)(11063799006)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eqlGjII3yrqxW5waXRLtKbICiZudnOU+cEUFAm1T2eSR8v12RlEkUhANacPr?=
 =?us-ascii?Q?26Car8PvBTDL8TO14ApK8zR3cDmJq4aU59ortwsNMC4NivrxRC/KZd13O654?=
 =?us-ascii?Q?YHzjVpnaBUZyFSm+Jgb5B/ERImCWtrE1EjACVusO/Y2b/xUZ54X5gm2cXiue?=
 =?us-ascii?Q?iEFlz7qhP0pp0ssNEXE+EfVTHhurcrOcLdDbNekWQEvA3vY/cpBGq6A2FkF0?=
 =?us-ascii?Q?3FCPQADUBGgZDlvKGjl8uwQEFlzgvNSPtM00i1JhECwZ/pHIMaCZR6Yccacg?=
 =?us-ascii?Q?AO3CYw0gpdFoN5XmHOpnYU5nZAcL518Llx9T+1hg8PE9sVlHxXr63jSr+0qC?=
 =?us-ascii?Q?9+bhD39xVZIQR3LBBqAJNRo/YG3k5geBsVtKOjA2XzUJGWMQpD5y9dN3k81b?=
 =?us-ascii?Q?qjbHiZIbNPhEFaXAoKtwWH5UkoHGVrk1yohwPByPGrVZRbNtFa6bTRgv3q83?=
 =?us-ascii?Q?hE87e1RJ2kJ5y/SPdi6eKKILzEFlS0QNnODfCoOeKxw8FsnKNZ+AQO8MdFX1?=
 =?us-ascii?Q?7uCFEPwWNwpJ9YpJ5Js9T8jMEGiKcrutFmlQWKwgc9Ylz1A0iU/xrm7avawz?=
 =?us-ascii?Q?AxMC2LNG3I1GRxmSEx/E96qEz3yDmQ98crPgqXQYEBxPsr541j3Em4WpBI39?=
 =?us-ascii?Q?h1A8qnwl2+Ew0h9rdl1dLqBgNZ5piOTajd+9bHARAZEKvceL7gS/ZtQCwgUB?=
 =?us-ascii?Q?0eXdUv961lwD4SEICdfH+n38WEeJ6IAnhk8mwZzyAeTyCVoW0ItYRCC5ewxw?=
 =?us-ascii?Q?37BASE62++EDlU5f+0YSjFN0/EO/wiuh9CVFvLJublf2qEFy6H0tbZKl9FEr?=
 =?us-ascii?Q?uFfq+WgAGoSMIdIzUEtyKe28KjsFb2XUaTlbVZn/VQOBddA+N3mQMQPv47Gm?=
 =?us-ascii?Q?YsarBUIhF4iSOHZR6PmGdGsS3hCVIC9RwDvwSbFIyW7haNgJx5i1Rk81ycmo?=
 =?us-ascii?Q?+PFLSAeV0/++4GO25bWeXJ2Z0Yz3Dyx3hjPPLfDzJw+DJ6M/2x6Gvwz0CY7L?=
 =?us-ascii?Q?x2JKhe/yJVVjiK7Ba2sbta0we00uzuvxsRAuTc7K6Z2W9DA+IliqRC86k5EV?=
 =?us-ascii?Q?sBYA95U4QInbeVFVKkZMXdbZnzBup0IevXRpOSaoR3d4yjWjIQ7sTLezTfqT?=
 =?us-ascii?Q?MYa9gv+0IMT6BvkMvCnznCX12TBOVA0ziNWkQAZpQoY0G3ds8IhkuUt0mw6/?=
 =?us-ascii?Q?dqvU6wi525BYdKiST/3rkgoSg7mnZpgqRF2sJu41YA8/jQfo3jyxK7EpYzf3?=
 =?us-ascii?Q?/mJzlISmKR84Yo/4FHuOiHUJcMCFaUqR5Ku/dQns25PNXsZ41qgbkBKY5KRm?=
 =?us-ascii?Q?METHKF+UWsVy+7XMulNnkajcsOTIAxwz62qWYboHYvmP3xv9ZXKHrbmILGaT?=
 =?us-ascii?Q?DnbTS2RfESr7aMEG/Pm7jvMKXFsD4okfLl1ty70wYGZn98MdHsd7JTV0hOKJ?=
 =?us-ascii?Q?qrJFp1Y4nyM+u+jshKV3F5oXePDLdI3kmWUD0zLvubxEkAgay9BsUhifY4vp?=
 =?us-ascii?Q?fKlsAYcoAlhUsFbY8KwN2Dx6jmU//yzPx58QDqY7FPoGSSnIea2YBPNfKPsp?=
 =?us-ascii?Q?mwc2s2c60XhZq0Bg/oZgviDQtQb/N739+EwXURjaPr6aeacd2f9opiSNllF4?=
 =?us-ascii?Q?3ev1J7SyWJcUqfySL5HsP9o0vZyCr4DBxcyqhgZiieJUnXn7ZLVgk55MfgA6?=
 =?us-ascii?Q?QgeLeskD6NWtTi+n0fAavUGR62onP0pv5qtDxCNF+qbUtQMAfT/4QmaTyWU6?=
 =?us-ascii?Q?oanH+c5GCg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0d7adba-417d-4ec3-abdd-08def8cd4117
X-MS-Exchange-CrossTenant-AuthSource: CY1PR12MB9601.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2026 23:55:58.4598
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: afBJDuZZhpKt7euNvSGPcEuyvxFPkZZeoocfvx64w7KncOrQY7uBl7LVfVX9RKNX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4200

On Wed, Aug 12, 2026 at 12:17:15PM +0000, Yonatan Nachum wrote:
> Changelog:
> v3:
>  * Ensure proper alignment of stack admin buffer to prevent unaligned memory
>    accesses.
> v2: https://lore.kernel.org/all/20260731075007.3878376-1-ynachum@amazon.com/
>  * Rebase on for-next branch instead of wip/leon-for-next.
> v1: https://lore.kernel.org/all/20260726123854.638687-1-ynachum@amazon.com/
> 
> -------------------------------------------------------------------------
> Add support for the new 128-byte admin v2 SQ entry format. The v2 entry
> extends the v1 header with checksum and payload version fields, and
> carries a larger inline payload.
> 
> The series first decouples admin command payloads from admin headers,
> then generalizes the SQ ring to use a configurable entry size, and
> finally adds the v2 entry format selection based on device API version.
> 
> Yonatan Nachum (3):
>   RDMA/efa: Decouple admin command payload from admin header
>   RDMA/efa: Generalize the admin SQ
>   RDMA/efa: Add support for 128B admin v2 SQ entry

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
