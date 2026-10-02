Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013068.outbound.protection.outlook.com [40.93.201.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA1110F2
	for <linux-rdma@vger.kernel.org>; Fri,  2 Oct 2026 14:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790952767; cv=fail; b=gC8oaGdEhJHQbx352+wVu6MwdH2fScIaccWNvtKbkn+a2Xp6Er8idgeIVYMvB2KKqLewwfvcChBXbkJICvb+fsmz5WymPx89KqE/naYMcE1hBQsBFbSNcrR5GkbSBVYUg84i8z81RiSU+4yYh++qzTy62AUTD0pzGtXMLA4rZws=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790952767; c=relaxed/simple;
	bh=AJ5k5qNSYI+jag/7m2ejnULIEZrutgfbVLA7uRg2Fw4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=m1jqQYQO0I+z2H7kM9Zoxs6jqfKmd7gglevnXg84Cg0LgSeK01rvcENISsN7aOJxZ8oO5Txi4avVrMUxVxOT/+becRwGp3bAfhqu9oUEg0fHLZdBLoWt//w4jgShyiDZ6hYgogsyhlrk+QNpsUIGNKCiGCpJ/fPjIZFkiP3sc5o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=R3hkMmHE; arc=fail smtp.client-ip=40.93.201.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="R3hkMmHE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ut2pAZ0xaRcWOQ/zbAQf3oHO5bdP4++VPlKxOm2RuIeskt+F+jC5tNHLrdwyCzrswH/V+MHss1/MWDgrQwIA86PAIU4Kn9Dky9lHhJp04+yBkJ709N2aYNvf0B++fSbsHRS3CrwU+zEpGoIJHjgtoIBKRXa7dgVyZihgaGhMyoAHQRb9lnKLtnLSWn6c6AB9hNi3lD+oELlFGQopDaz+hGAkrSy1zcZN/xFVPTn/OFlWsbCZMDdgYPXn2Fv2txkRUdkg8AZZhFyZJ/2SmsQ5d7P4VhpWQGp2sz8XFUgCHp9cV+bpfgLz1GCyPGrarxEMkkk1YLUeWrs8M3JNo4LhBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=21avAiQv93jo9leCrjRDiuHRT104igPCRvGNwm5PkC4=;
 b=LJwO5x+MQFzSqtKb+TCXfRdNpFsKCs1m09+uh9ien6cljcpIDpyUgtTMPddTkLEY2pbS0+sT3wxy2wR+yxes9d8uTjrTQ2pwGsLKdt/O5wR/Jmq8OTn+KQCKVfdI5xIKT63xHmOWZkz2FWDEorPBWh73W5lDKhyq/S/M8QclI9AYZigqvh3LXRq2rNCEPuX38g3JzP9mnIL5rj2pEOANsBbB+dwi1rBA/wF2HAYQPJNIY2qw5/R/BDSAQhQPsLclEOxdpbtiCxo3syWDWoLUaBb5skjVlYLdJWpWKbJSBgeoKI7zOGhbuC6AJkWeYIYfl63DmTlO5gkAKjkKfScMKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=21avAiQv93jo9leCrjRDiuHRT104igPCRvGNwm5PkC4=;
 b=R3hkMmHEFKK43NGv9zG1JATTEvhLLv7y1/mTzmHVdmWlLngZph7jPa2zc1hHzMt9grS4EzfBQqVka0yaAbDJQh81xC7DCELZ8j/3RY9Kd6SsMCLUDkM8j/KFNt4KD5Fi2G+fiwKgTjX34FbMUmTZiMQi59A3cf3S3xP1wOhOicoEJ3Q02KEVddh/UKKi/R5/8fEYDveOS1pqNA3tSFkGJV7NaUBFHgPm6jgdB2PW++vI9bBs1HyMHHBxOfnOgrx/ek10rjHNxxZ8HorQTZ++lc/bLNhrQbmtADehYOallBCqmsjZhb7SJY8ni/6fI/Z0oBeEDrWduPSEmGC8TGSP/g==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by CH3PR12MB8458.namprd12.prod.outlook.com
 (2603:10b6:610:155::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.26; Fri, 2 Oct
 2026 14:52:42 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0472.016; Fri, 2 Oct 2026
 14:52:42 +0000
Date: Fri, 2 Oct 2026 11:52:41 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Michael Margolin <mrgolin@amazon.com>,
	Yonatan Nachum <ynachum@amazon.com>, linux-rdma@vger.kernel.org,
	sleybo@amazon.com, matua@amazon.com, gal.pressman@linux.dev,
	Yehuda Yitschak <yehuday@amazon.com>
Subject: Re: [PATCH for-next] RDMA/efa: Expose device P2P DMA support via
 device query
Message-ID: <20261002145241.GV1616761@nvidia.com>
References: <20260505081514.GA19297@dev-dsk-ynachum-1b-aa121316.eu-west-1.amazon.com>
 <afoPWiiEwk5igB/N@nvidia.com>
 <20260923163830.GA6954@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
 <20260923171741.GH2545495@nvidia.com>
 <20260924152913.GB24800@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
 <20260924182201.GB9354@nvidia.com>
 <20260924193026.GA13498@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
 <20260925125512.GM9354@nvidia.com>
 <20260930132613.GA24387@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
 <20261001155333.GP3401365@unreal>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261001155333.GP3401365@unreal>
X-ClientProxiedBy: DS7PR03CA0247.namprd03.prod.outlook.com
 (2603:10b6:5:3b3::12) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|CH3PR12MB8458:EE_
X-MS-Office365-Filtering-Correlation-Id: 9352c58f-99c9-43c5-2ce8-08df2094cfc4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|10067099003|4143699003|11063799006|56012099006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	HkVgwQQ6QWPj3ep0H7TljZxJJ+HBVgJZsg2Fa4+/+86rXrD43wUVg/iWn8+Q7zI9EPrEMRG61ea0fv+lppDlOMwXumTW/0/r2GKpt7D59Ytnk7ts9m2DCHB/3oV/wbHBZF2ZuYoZ8v4qKOXj2+4+cejh0I0kOz/pIxm7+N0zuSX10uHwoQwHB1bXA9CJPf/sFzeszllzgmy+uQ4HTO8BeReIljGYVsOhr2LdSsi3/ulbkyz6YkAuRbPFSBhUjhURmt20QLDthQl1X56sJRnDSGDBaQz8fanw9L6PhD9uyvJpkCdb+WqPjA117wGV2hXs4OfJELNL9gD1g0U9U9PgszvjCpOyoaFD/xu2o0G5LW+ZP5qa1GQslNQnhxM7I+1Sc24dCOlX64Q9UChKvBgnL3yOlBvVld8qV+4sXE+u9IweRqSHci3KQL0sRPOPEsc/sitidqyrc9eC5uANvv/LRiizHOH33VyJz+1psJ/bbEBPJxKrnwB+wMir6OMtWVJWfWfyoYpUsl/PSS2/6LB4VpCxb7L70HcWXGi2vRZIr9VSaD341j8FnkY+8jM36T57LjZVV5G/MW7aSsjYMxUjVZXPsseY438y30LS1j/AkSf8Pei71rypH9swUHkvjYu8oLOsQZWFfjIYCx/E13u8kbprOLKeisLzsXRj5i2V19I=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(10067099003)(4143699003)(11063799006)(56012099006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?I6MXz8G/tWd8/dlNGLK/o0zA7KReemEb/MWEWLJrXE0TyMnFYUDXo50TPaed?=
 =?us-ascii?Q?bWoLTbZftsQsQx6kOAVVjt9Rn2s0+SY1z9a59vfrMbZo7fOkgzlryUOy80AE?=
 =?us-ascii?Q?GO8Gh/+/kt0UyhhUl3JaVL04ynGmcm+8QUbbV4VSWV1InlQ+qX6jrji80AaH?=
 =?us-ascii?Q?Xfpv7XyvpWz7gPtSuFU0tLKkUesbRZ6cxvgumvRRS4ETDNfFje8VMbZfQJ/r?=
 =?us-ascii?Q?bYdjP9oagnYEquxTeoU765mow/ndOkplqYxgSemcCle4FAykkKB1rOLNuGlv?=
 =?us-ascii?Q?RUN1mVhf3W9LKvmJ65DExYlUtP+91L2zufkjHqiFpGk6wiXLK39ZEbI6gIi2?=
 =?us-ascii?Q?V4z04SYb6NRUH985DR3Il+cKv9EiGIsiAlQVCQrY4iKQox9r2ZOXNCt10MBt?=
 =?us-ascii?Q?2LFnW+NE/7FAFDZ1+RvhEjDM7xbvChIpT3s4N3zvBAbUYp5mca0DhRfNuxMX?=
 =?us-ascii?Q?p/iz3L5boyA0N8tGPNwqF6idO0t9AdtReO73/o2Mbb1CrMg4EphsluFvlyEA?=
 =?us-ascii?Q?GAoRZPemFYHs8N3mUc4vSt2zjgzpLhocQTs6YZvE+ufGEKc5xtqxQePkXdxh?=
 =?us-ascii?Q?iDLKIyhofIbc9S7pH8ucrar47jJqolLslhkeRcmG7pzoz+CfU1UsQOvBSkJX?=
 =?us-ascii?Q?COkhCanGuTPeOkKusiABB1voiWel9mOJta46KqS5xuKSc1BklSRLpZIcX4qB?=
 =?us-ascii?Q?Du1QdOIOoseAzfXX5Id8s+sDbB6Z07rDPWSe4aulV6IMz0uy/K5MrGR5iMph?=
 =?us-ascii?Q?tXJzIMvr64s1+HojvuxkT/JA8e5aizMYg4ET0faf2mb2PxTDSPV9aclnj1+1?=
 =?us-ascii?Q?/HU2QlqWKn+/pM4yO0rjpatRh4HiayUYJTZKVNWIPXUhVMahnm1Pxy0fHDsv?=
 =?us-ascii?Q?3tdas68IDU5EtYFLOu01+yi/pga/4HjVYC4IslShiZImMq8Lcd0cr3lBP69v?=
 =?us-ascii?Q?/P42yicKM4eirBoyLoUZ/IMHdMnJcRBCD5/2PWuYyyiwVqcP0nAvkHtJVQRX?=
 =?us-ascii?Q?a5zvkZFkmj9yGV72snZM0/i4k6kL5Ie1PZ5/6I1276++Kh4BpR84GeLFt5TY?=
 =?us-ascii?Q?+gp7GsUa04wZ62bsOFjR7fL53FjALIFTZu5ErftQFuV9TaOztR6Sbck/+PYD?=
 =?us-ascii?Q?a1P0zGBICY6HvSlHCEZKgemO9SnIwyU4pvZRf1FW/24WD5FsU3jTlN1qh/qG?=
 =?us-ascii?Q?tPpTb7jfpuLqriMKtr7Nbae3zbuJFNiJGP0eGrfOJ93acgFOpPrjAPVqOxFU?=
 =?us-ascii?Q?eZ1FJ0Va21yEMOKkO0BSezyHZAqumB9YgO8Bw/tbmh/LgRlG2PkeHmadUjmL?=
 =?us-ascii?Q?VTagr1P1jskRiOuEWwtSjQjUcYNgei663t/V1IjFWOjU9EnKBSDc+T+M3siZ?=
 =?us-ascii?Q?E6iOW4vmAvr7frBI+VjU2Iuhqz3rQ3+qG2QUpxdhhKw5Y+gM/CLDb7/dE46I?=
 =?us-ascii?Q?dZlu+3hy/vfgeAqM4u8iNg5KO4mUMeUpV4E8fA5qaGiT2r6Wq+3nXB+xELLP?=
 =?us-ascii?Q?Crcy1V5NSoeZElcIeQNxCUEOnFf9TrV18zWntK2/oxUfNC7ammmjsiAb/jm3?=
 =?us-ascii?Q?H1AvxoNSDcL5M6CmZrMJ+A4l4h6ROG92vPz4o6Mdohc1fsLKuGxF1K4uCyLu?=
 =?us-ascii?Q?+oR29fByT5kbZPfHaVrycXx0Q7DEmdHg7e66ml6CVwxx+tUgxcmX2lSwFtT/?=
 =?us-ascii?Q?b+3y6Lc0GnQV2xXJb48Y7b02RqTiXdpZBoqpVU44ZyQojK4h?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9352c58f-99c9-43c5-2ce8-08df2094cfc4
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2026 14:52:42.4046
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a5713Lo0JwXpboyZBHxYaKgKa3XCQ2DQjbdQpGgGSuzLJcxOE5qPXImERkJGmeV4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8458

On Thu, Oct 01, 2026 at 06:53:33PM +0300, Leon Romanovsky wrote:

> > Looked at Leon's patches and it does seem like the right place to expose
> > such peer relations. Although it wouldn't help with our immediate need,
> > maybe we can add a sysfs interface on top of Leon's patches to expose
> > the gathered accessiblity (and maybe also performance) information.
> > 
> > Leon, what is your opinion on this?
> 
> ACPI tables are available here /sys/firmware/acpi/tables/, this will
> include our new p2p HMAT extension.

ACPI is nice and general, but..

Doesn't AWS have something already to convay VM instance type
configuration information? That's pretty normal these days isn't it?

Jason
