Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013026.outbound.protection.outlook.com [40.93.196.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BCC63D810F
	for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 17:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790183869; cv=fail; b=ilpCuOU5jo1RXGscUEIL4nIX3/rjBP8geJsjq0uSCorBkbdpFbJPIHYlRLFEoopOklksW9kQlEIejUQd2hHc9dXVsovs3+P+vwA87VeHmCYcG5MAE03IKd0a61dQkfVGs+ryWb1QUiAPfI1fLmhSMmwp+frIN2r4/lIToXVSFqk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790183869; c=relaxed/simple;
	bh=ifF/TtjaBGaoTeqp+OzyiSouKaHUxvm2AkIxpMJEviE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=K7gV92aCh9RdLV1hCRREn2fGyEaz4Od0rWkYHIbSZUVjHqFax8nyW0KIVU66iSkei0C6Inr00sXYzabTeQD6md1XHMyVWOd3akhyXk0/KDBeDwIo59wUMsaIHMengNCnv1+PJLXLOBVZsgHaSnVbpmHgn5m2cnSucjescUVY8yk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TRirGwEb; arc=fail smtp.client-ip=40.93.196.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TRirGwEb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FsvQkkcHalQuJBf0hxc7bwcVXoO7GP3U8gWS2BNT5wnx/wUdGUEvPRL8Kqw12EoV+QWlT7Shrkp9RpcoMaHHq+NK1iwgNJeDf/NNiiCvr30eGOb2Ev9EX2LfKyGn9P6NIMy1Zl/44MRz7CH4wjhCAqBdfdvmaq8h6xQvTm5iIxQbkWjU/gbNGj3nWKbATaPVCtgKnKFSEK3X7xnWVFNLmZQWYLeGgWEM3ohNmnLFleT+iUVJH2qMCxO/PZsHleSms8wv2exjv/yizlC55z+lRhvdycxqgxGrH3IRbXatZjmqo7Uvjt3TKnVoy0awqAs2LsXEwo/XR8cjcG8QqUgcFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=COfK18fvSeqFS6vUvQeGrXBnmi7Yik0YnHRKrCwtBu0=;
 b=xOwDNZ8d5531XcRMo4iMssoWvJTaXnh/dgNLSSI1G61Ein4pA5ZZjm1sG0TEgzAs09+65ro/0P4mKxUozd7rmNZA2devqZFvCRdhYeEQ02NIg3kUEeAeY5xXYJqQhoWVPhakok8P58PXhnTKU+94C2RQpDXiP5Zti6mRv24RV/msxBhtu0L78X1PWPhoJSdFpGZ0GsQX4tYhm5ZsH85JWmzdEG458SxbqJe/8VEBS3dmkt3/Yk8MkY9W1UcHcIkuYKv5fyMjk7MgYXFDDRJ4R2ejWVdDQxpwIf24A+1VZmwjOZDLKXvIZNWTbGd652A2Mdy0e0iviwh0uxC7C4IO0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=COfK18fvSeqFS6vUvQeGrXBnmi7Yik0YnHRKrCwtBu0=;
 b=TRirGwEb0tYHGjdxfwYZroSFfJWg2Mu4hFytMJmGGbtRsE9qgyy1kRw0+1RhCT68xxOlb/2eGIfYdpH2vUBoHIiT2PmnUpuSo+uNk8lmMJn0huXqn1HQn5JbUvwdSKhDmYiVa8jXjJmInMh1MBeT/AJAqCF5xFHX+pBbuYMEAgaxugaEAz3Dpld94j1kDIPKTfLLfzqpmy1pAHdQkeyBethIWJqKOR5AIFsU2fXEWrFigzDwTD5REt2yuUXIp1XIZy8qShs71HnvsOY8O18C+9BpQH68O98R8j6co+bNOAPGwH3vBDCljTUnDc6h4RzvQ9N6qNdPRljx6M4WStTqlA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LY0PR12MB325698.namprd12.prod.outlook.com
 (2603:10b6:408:3bb::14) by CH3PR12MB9079.namprd12.prod.outlook.com
 (2603:10b6:610:1a1::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.17; Wed, 23 Sep
 2026 17:17:42 +0000
Received: from LY0PR12MB325698.namprd12.prod.outlook.com
 ([fe80::b65f:1548:5b35:e2b5]) by LY0PR12MB325698.namprd12.prod.outlook.com
 ([fe80::b65f:1548:5b35:e2b5%5]) with mapi id 15.21.0451.014; Wed, 23 Sep 2026
 17:17:42 +0000
Date: Wed, 23 Sep 2026 14:17:41 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Michael Margolin <mrgolin@amazon.com>
Cc: Yonatan Nachum <ynachum@amazon.com>, leon@kernel.org,
	linux-rdma@vger.kernel.org, sleybo@amazon.com, matua@amazon.com,
	gal.pressman@linux.dev, Yehuda Yitschak <yehuday@amazon.com>
Subject: Re: [PATCH for-next] RDMA/efa: Expose device P2P DMA support via
 device query
Message-ID: <20260923171741.GH2545495@nvidia.com>
References: <20260503150246.2349679-1-ynachum@amazon.com>
 <afhL9DLUVhnVyzZu@nvidia.com>
 <20260505081514.GA19297@dev-dsk-ynachum-1b-aa121316.eu-west-1.amazon.com>
 <afoPWiiEwk5igB/N@nvidia.com>
 <20260923163830.GA6954@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923163830.GA6954@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
X-ClientProxiedBy: BN9PR03CA0581.namprd03.prod.outlook.com
 (2603:10b6:408:10d::16) To LY0PR12MB325698.namprd12.prod.outlook.com
 (2603:10b6:408:3bb::14)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LY0PR12MB325698:EE_|CH3PR12MB9079:EE_
X-MS-Office365-Filtering-Correlation-Id: d4bdb7fd-93da-4c48-08bd-08df19969396
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|23010399003|6133799003|18002099003|22082099003|56012099006|11063799006|10067099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	52ERgUGqQZTv71xcGNAxJvGwYMlMlAqP1Q896pA6A/8tQHvmDuIJpQkzyXj79Tr8HIRb5nZE6LYO8HmFHQN146FuYobRCkaAf0mxJHYHjnKkZb4C9jvI3fj1nzhs9tYAdkddLdgYWHzEtqu7GmtTTOBIJ09lysgJxYST/mVOGUffzfgb5oidYBlayAYOG3mTUmW6yoBSuJTAiMVl1PdSBSTKqS46j1xgsKDKSAJbhtqg3E3vS3Wfe34bTbqQn/sHZjH3YvXR6Cq10JE5pIbPXcTMikXMmMPZOfF5EtwpktPcZA5U6S0ODhnpG4w8LUkDCGKXEKiCev4xfG8DZRvz08oq6c7bCB2TE/OHyIKJwhzIBkM9+kCR4DWvywnCjE0uunDVbn568tIsKZklpSZuktlM9e17nZlRbwThu1VsURycxYLW7hh65JrqPRmJHn2Aln3iVPMfbBP6wL30JuRxzvo1VCR4BBd/tziOdH475TFDimJdJILXscW5f9dSgui7WKMpxZWgLjoUFHBfPrgVOt7sd68zquOh8eXYpLgL4BMLHuZEpB8A5fn1Tey9wZJDNdnfVencHJEu7vRZW6H0rggqOH3r8uMJDx3+5wbZtM5oIaYQOqCCe7yxo8VqZAQCoSh6xNFpc7u1LbyKMqqgZBXjji/dw0uySaQO1bbIPC4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LY0PR12MB325698.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(23010399003)(6133799003)(18002099003)(22082099003)(56012099006)(11063799006)(10067099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uAFxdGogKXx7NPSusT/bwiDlsdParm3qZ4XG73fZ7dBK4kc+9dBcPkGJKkHj?=
 =?us-ascii?Q?na43p1HBd9ITvr5MIQgy10sAwZ1rfn/kysfTX8MDCtaA3UCs1Zaam/L6BO+2?=
 =?us-ascii?Q?1Ym/FvaG//oc15ZnvPVi94L/1npEFH/sB3lYTwopjkO7taJQnS48Bo7etY6m?=
 =?us-ascii?Q?Cf+LQaNHAXEnywe3UahgYJmstfmzI4x6BmYEcJiFjs0FFkST32s23l1pgQbT?=
 =?us-ascii?Q?na39xgxGK0kRGvP/w/+mI2RN69xo7kRrZ1ggAemI3fJ61EicR56u2h/krRcj?=
 =?us-ascii?Q?wXBDqRhGmUh6LN+2wEmfJP/lUtod7shfrLFppZaZ1qRvEMo7tulIXkPdmEQX?=
 =?us-ascii?Q?MzpEq74s2G5WPG0YrqYIhWYtyOLoUSxAwd5txAmdjvvd3kAZaxWDwGp13xcH?=
 =?us-ascii?Q?V8HzgdQOMAioQ6DzSdDycIuMXvhjhF9UowsESh7solxnqB+g8PQV1zsHjmTn?=
 =?us-ascii?Q?B9AeWQ5uRsKBH154A1WHAT0vwDnqIThEfiq2rBVX8n2CPzpWpfHn82fe+R4R?=
 =?us-ascii?Q?YvokoOijrOnVkF3Qx6lUnW/UKkaqCOblqyJ/gjOaiUC1P93rxEEG2hfdVEaT?=
 =?us-ascii?Q?rDJSHJ+kphZlT2otwa8HWqlkZIPHZENyXxn6bEXLwhCmQ1PuWGvwFy4v5pw5?=
 =?us-ascii?Q?L311YMJ8ixaiMfDppotwcr85pMTHgplBbamzA91SLbSg86D+BT9UWtcvw9sA?=
 =?us-ascii?Q?PZEdu0lj6XU7R6c5YReLEMyczk9jJasjdUse3wBtBJUSOAZuEJA2YToaf1fZ?=
 =?us-ascii?Q?QZ7KgFcXyO8O7A6yojrEDqQ82RqNJPzp3zCx6qz95Xy1Ptm+yDIibhoG8Vl5?=
 =?us-ascii?Q?yGjPbOFUseeCqID1cItMhqs5YXMJ7YosuS7TztgRgSpaAt28OGpWEW+A24kc?=
 =?us-ascii?Q?XETA5oLwgU5GJbtGuA2Zi58pWm/eCSBmk/fJTa75HtmlFrI4RE6G28zkBZH+?=
 =?us-ascii?Q?jXiwagaTh81u9mPVv7MbnAg6aZ9kuZFqvyYfNSi0LB4w80vasrDhVCX6MBHS?=
 =?us-ascii?Q?smGGPGZbqGy/W7La9hwm47PJkP0vfpmXbiWMhJkhfCQwnfMH74cx+Q2nn+M6?=
 =?us-ascii?Q?/zrFK6O3MrV8xxzh1Tw4avq0pZrZe7bmUkrlPkJcJddE9kFybJHbZC/2Yw0D?=
 =?us-ascii?Q?WqrB1NTKihpAQCwRtq/xoTOnjL31qm2hls4Cluqc3MycGp6+8ziNtyai/gyA?=
 =?us-ascii?Q?EZ0duRVGth/zt5AZS93JxzKiNp4npxQCSpHspQpyuiDM0QWgWlWZkveRxJbP?=
 =?us-ascii?Q?2G8pDL+of/k4W9nwnThehQ7u+N2tGEoyA0dhwnKxBUxUkYKGB5IKLDFE+kyD?=
 =?us-ascii?Q?ILV4UkNyD+FEPLYhBfB5mfjKdPjXQ585GQsT8OPgyFvK0rJO89eO0WD+oQIu?=
 =?us-ascii?Q?Efzf/AKlJFzZDWHrqrkCUU34114f/L4G1zdKWuW1F86LFWSbOkN8DCkMgW9D?=
 =?us-ascii?Q?QiOH4RMoUevmkPOybVtCAQb8EgaFRdkhy3Pwn9py2OnN7wMDY4M4Nbhewk2O?=
 =?us-ascii?Q?DDb4pdx3BYgzvVwXa+UxTsqT+lNMoQ81kDo6TkLEH2LH90DdTFrL7ihs74eQ?=
 =?us-ascii?Q?796QT2fPADrLc+CtUOYKqQ9s1/qW7Ht9lfLHr34yv5BCkQj+gCuft2QX4dSo?=
 =?us-ascii?Q?4gf3N5l6JGgBJxBjbyHX/DhcyzAZPh1yny6PUqLHaZBN7y+M4gHnxqbJiXVH?=
 =?us-ascii?Q?SkwmDa2rC6k5cvvPt9CYpMGiLv8SiH0ABZfxIjwXpXVnSOpX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4bdb7fd-93da-4c48-08bd-08df19969396
X-MS-Exchange-CrossTenant-AuthSource: LY0PR12MB325698.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2026 17:17:42.2323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ndI9n7ZG01laSsNXFp4BUtrWZRjPq+/69oBBzh8K/eLsGEudQWMwH8DAMuP9iYRa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9079

On Wed, Sep 23, 2026 at 04:38:30PM +0000, Michael Margolin wrote:

> I'm reviving this conversation since it is becoming an
> increasing need to reduce the long startup times. The major
> part of this time is related to CUDA device initialization
> needed only to allocate GPU memory, export a dmabuf, and
> test accessibility via MR registration. Since obtaining a
> dmabuf fd requires CUDA initialization, which is exactly
> the cost we are trying to avoid, we are looking for a
> solution that doesn't require dmabuf.

You have to use dmabuf. Go complain to the cuda people their stuff is
too slow if that is the actual problem.

Precompute it and put it in a topology file like everyone else does :\

> I have two options in mind:
> 
> 1. Introduce a new (common or EFA-specific) verb that takes
>    a peer device BDF and queries the p2p subsystem,
>    returning something like:

No way. No BDFs in uapis.

> 2. Expose EFA_DEV_CAP(dev, PCIE_PEER_ACCESS_ENABLED)
>    directly to userspace. As you already stated, this is a
>    bit awkward as a device isn't expected to be aware of
>    system topology, but since EFA lives in the cloud it is
>    partially aware of the platform configuration and in
>    particular the ability to access peer devices over PCIe.

If you already know your VMs are always safe what is even the issue?
What are you probing for?

Lets please not hack around bad userspace with even worse kernel uAPI.

Jason
