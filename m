Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011008.outbound.protection.outlook.com [52.101.57.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D7F4AA586
	for <linux-rdma@vger.kernel.org>; Thu, 24 Sep 2026 18:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790274141; cv=fail; b=NARV08aYrILuJ5/RltZv6Hp/8oD+DQEr7t37RC1cPOHvbBf51EAMKJdbagguFxDix1m2FieoSANas2j5XFKsL7cOLZ/EJsyL6SruB+hiYj2mmAwl9H/uOZuWbwcZu14Sb0nK3pLavaYbBFF3NBnDZNNJV6KxRu68nI/ll1qbg1Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790274141; c=relaxed/simple;
	bh=5QO4Rw29TuJV0qJFByoJkGr/+1soFPmECR4vxD7Tvec=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=TQrfLD74YGew9fepUV7oNzWYG1BgO1jmOkA6x5cnDVdm+5jUXqQLlj0/nGKd2LjZwBeDbMarL5Ynp3fxh9iOItoAKv83iTfsUUa9CsnULs4V1jbZZSjU31v/T3Bb/rb9gvXBcktpRjCPDRlXdsgXyW8v4TXvHON7tHocbqNEFvw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=GqK4IGZp; arc=fail smtp.client-ip=52.101.57.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="GqK4IGZp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fzJxfjPQN98jwrfWBX+U+Ze/qPB01Zyz1NWa1+4lqmpvmazMvFVIUS3aZgm6M+bQDxymkyCCPPq6sLzn3W+GML/NQo8YR+S+1KZwzWXVRZHtTs/HvFpsL1JmsgLPPOa6Gx/IDLCq1Bzr/6HSivEmmX1TP3Badz506zQkkXpDv19iejLNTvFe6zDnBzrY1fdWNHNC1zN/yHy04q5eTcY3IUppc1pnm4mI9SRqX1I8gWdaBsMiag1uefzZbF0xELHTaI3Y8yVOszOUfIvPPCuS3p9DOOsEIZErrtqgWgGIDFJdvmfMLw45bgcW3v0o8bl3inrJSwA4sq0Qjs978pbwlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EfOxSgSp7UKxpkFAD56AxV/OZVyOV4ex1T8HiNVDUEM=;
 b=Bs4kvvp931XT73lKUJZCU2RQIUZ8ztAO0yq4TTb63qsqZs356CdHmTvfjtpOyNi3y0+2hnMV76/CTAmF9EarYknPm7zlDtWiytrQBGTjK/EX3g/Hgf7ie8RZ/OPp12YFaI4nhRnMm79URCZN0q4r/Utm7fjfvTJ8zWygClt6ybJ9P3iWLlevp8Xo03GWNBeGCwsQyLBSdtDTUY2yTvgNBy5kj66M+DyVdIgz/DCOqkI4wVuOpMdT8dbz0wnOpGLL9yhogr0HCm9U5Dc8wo8FutcGdTFwknJjtHXc6yv37NJFgSohvyZ6o60cgmwBtfSMeYQAkp/xxGDtUii4A0rOlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EfOxSgSp7UKxpkFAD56AxV/OZVyOV4ex1T8HiNVDUEM=;
 b=GqK4IGZpbFMVEkHTQs/8azFmnwCOWUBpF1lNoqdUqNdEdaoGjabcoHp15CQymPwfc+wdbBPq9Hex1bNE4+7rjpxi//gcueZsFJsdnrlJS7/DX0wqhiphlKBHplLMusVOz4uLCo4FGojDRvbNVzm6DlwWVMlqY60WCk5Khd+l3kangqCokbdMHEmWcYchtaWD15dGuCkT/VzI9xVvvYu2oV/XUkoPoHxMBudmLLAlR739r+2lDXFEkC2nzQLyAQrBfsx3nT20XsT3jr/t3gXHofm2+nm0xuSidSRnGRtnundR6s///pNmwDfc6qWvX2c1wd6Iht2zHFXtWOwuyqgDSA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by PH7PR12MB6539.namprd12.prod.outlook.com
 (2603:10b6:510:1f0::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.14; Thu, 24 Sep
 2026 18:22:03 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 18:22:03 +0000
Date: Thu, 24 Sep 2026 15:22:01 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Michael Margolin <mrgolin@amazon.com>
Cc: Yonatan Nachum <ynachum@amazon.com>, leon@kernel.org,
	linux-rdma@vger.kernel.org, sleybo@amazon.com, matua@amazon.com,
	gal.pressman@linux.dev, Yehuda Yitschak <yehuday@amazon.com>
Subject: Re: [PATCH for-next] RDMA/efa: Expose device P2P DMA support via
 device query
Message-ID: <20260924182201.GB9354@nvidia.com>
References: <20260503150246.2349679-1-ynachum@amazon.com>
 <afhL9DLUVhnVyzZu@nvidia.com>
 <20260505081514.GA19297@dev-dsk-ynachum-1b-aa121316.eu-west-1.amazon.com>
 <afoPWiiEwk5igB/N@nvidia.com>
 <20260923163830.GA6954@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
 <20260923171741.GH2545495@nvidia.com>
 <20260924152913.GB24800@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924152913.GB24800@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
X-ClientProxiedBy: SJ0PR05CA0024.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::29) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|PH7PR12MB6539:EE_
X-MS-Office365-Filtering-Correlation-Id: ffc6f87b-cd3e-4710-d9b8-08df1a68bb70
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|10067099003|56012099006|6133799003|18002099003|22082099003|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
	miPTeNQRA9QxZmmJoiTsfswMzNnIpKu/DDblLNjh+MvRpUtEl1RrSZ4gCKDR68EE58YYnL5npweQ/obxK9x0K+dwxq1jXGlwz9+arjRlAfMBrHQ3b9/xGaJCc2FdYwtAlTRWZUcBiQMw5ndrcxvh1+Fe0rHx+8PJdOo2NQk+L5lnmBEWoMCXTIBnwSjMmdSZ95kt/9tnjnherF9zInWSiheCzPxqzx9UIgd7taGeVasRwQ+f2K6ATPN8R5alHW0bWI9AY1b7jvgSLoDg7bINynlO022h6G6R6ne0kXQduAI9ZSa3ieusBq5HdOAOHoyegt+C+2JYWhUC6hJy1b8NKMUA/XynOOqUqH4Dty+MrnRkhgbhAzt3q9CE+Pm18/Lgl/EpeuRIqdtYbOc8RJ6e+fbdN69D6jiXvPpOx99AIWpQTE2IH+fgv+VLX+xBDzIwdMn/SuXAeo/Zou02aGM0hqNAEbQnO+7GOUEBGJCPWzJkDZp3KtFss3peJG/nE+lcwSBamJXySBdSZP+Rge9+jDsrWDtaDYTICvUqFNSu0wm/Q3YDmc4+T8Rq8LNmfkb/7kl+9mhDcqkLLdyQHmUqoG3ZelvS6y+13TnzbIO3P2xYobVP+l4574NNgqTe8qGExyn+takYdH1K/+llF6YYvcdO+9xp3/naHTwQ7HJGcXY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(10067099003)(56012099006)(6133799003)(18002099003)(22082099003)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YtaFShlThlIdfYBeEfcOpdJfC2K3AGY6wxoAdyapKo2mXumykLWkqZprWWwx?=
 =?us-ascii?Q?FQYTG4PmpukLLWondwkY6hIEDQmAZGssIavAPpEJSvBJkz7CBs79n7vb3+Uu?=
 =?us-ascii?Q?S9Zgi5kBZ3zzuZUlTqXfyLEgwVQGfyChx7e8FbdxfsvanZ5c3LIQwlT36QFA?=
 =?us-ascii?Q?ocD+mRWN0uXp3Y9geTIIJVomVX+IVXcatlrevuEA2vkV0SKC4TH85YCJrodo?=
 =?us-ascii?Q?PK7BtZxxgdQg9L+rSbDJQ8Y+PPd3nkHHiOulPwRGMRep4cBg2r4jx+DXQHaP?=
 =?us-ascii?Q?5CRQ0xn2+KnItttdXHOKok2Fb7KEgI0nn3A+kIVorFUSLtnQzrMHPOX0jNXu?=
 =?us-ascii?Q?uk02MUFC14HmRAsUZalvH8uZMKYNw4bKgKVuuqVU/U4sgZ1ZIYdyNEBV3FM5?=
 =?us-ascii?Q?0sYkinjx1icc0p4+xJCvbR9eVfOnYThmUyQAdDaVn/kA/3Z2+7lCqU3jwQNf?=
 =?us-ascii?Q?xyJrH5ufZOejYhaflm+VQzMI71c1VxdkO1uZkMyg/QBlcS61t8TfRtKt3x8O?=
 =?us-ascii?Q?a6G3oNl0zLop/Ny0mJP/dWdLMr+C6SNF1InOqAP3jRlEPg2XtX8IY2Cpn8yL?=
 =?us-ascii?Q?epDcdaUqDCGK9m5CfQkC8fmUiGRo2xTFv8V3GXlAy3l/WhJdW5iF2g62e35i?=
 =?us-ascii?Q?S7GOpfhkYd2oGtbdaN9wjPl09AEzCwO1uasBpAuTRsaIIXJJUdWZFm0qP8TQ?=
 =?us-ascii?Q?8qEePjojVjetwgBmRdTKmNLAt0HGIHSqha9TgW/5HEPAu3sYfA9bh3lvhS9S?=
 =?us-ascii?Q?zThaGdcZUf6Z33pWMkYXKYw0BmPHCKNKpMCDuVWIySDTL0pjwcG5oJrk2bbt?=
 =?us-ascii?Q?KN9814vhIciq2+wHa2EJPXnNWEUydCfNfgYOc8XNv/EHqi/2k1nEfNkwgvsW?=
 =?us-ascii?Q?AKOY2Q+Fyx0jVE6Uk9Qt/cu7AduUR6TDMG1NHgsO6y7M5+lG9jg4oqMpPOsh?=
 =?us-ascii?Q?wFn0RtqO4dpQOug/sZcidUub7GZuz9x94mK42PRCd+BPdjcx9xxzRnueCwTK?=
 =?us-ascii?Q?dcyftAO9N+FcxpXgodmwkwN+6Utriso3SpHL0S/LLwk9vo4JUzz3yFm6Bh49?=
 =?us-ascii?Q?54FlUuMLaghmrE51GDjg5oQ/T4ewD+Umtmss6JiCb/3LnUY04QGUdgf+Fe7B?=
 =?us-ascii?Q?cN8Pyf4uUAsk9d8YyYISvbeIHD9kVPZOc8XAKvtYaCAZduvmcK71poOzgAoc?=
 =?us-ascii?Q?LxL1nHUK6ut56MxvwRlrL/YNpr8tYx7NzNwExHdwjDg+7wqLZCbN9AYHItYX?=
 =?us-ascii?Q?bI+Pq2tZI4VIohItqihRPNLuK0nkds96PZJo6xTmkzN5koHkOuWwbSB1P8NG?=
 =?us-ascii?Q?fwtXm/yHTQ2KC92ehXE0OPmf8gM2PpV6tCVbOWJwwQZ8H/wymGoZoE49cy94?=
 =?us-ascii?Q?yAE2aAISvnNCxKytqTk/z3AbE2890DxX/6tICN3Yl5t/fItUoFkcTo/dEHFi?=
 =?us-ascii?Q?8nYoI6cfT98flZwiDSpXC2jxSX4eqv8dECyEDDcdEhJPVqLLs5BM2CcklUY6?=
 =?us-ascii?Q?15GYWdDy6EydIQmyMU0YgoZTH3o5Et4xP/Jbx3Di+Z9MzkU0uwpmvroG4s/5?=
 =?us-ascii?Q?t2KgrZHurUBI/AY35cpIuJtrz6yEx8kUwVSCIsluX9gKgq7hSyiSXlN0fm1a?=
 =?us-ascii?Q?MG+v6GxWRQ+W8ydx6FMTjzRD3nXXFLi49k2sHsJ1Adi89dxvxgJ7mp5GmaA9?=
 =?us-ascii?Q?waT+qC1l2rXF44jlGyHFNXHh+OlVUnTZvHWBHKM4J5Nlg6RD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffc6f87b-cd3e-4710-d9b8-08df1a68bb70
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 18:22:03.4582
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sbl0bqFCiYoCX9Lj3tPCJgER6/2F8PGhtrjwgVJt93bb57FhBj/ETkMrcehotdjX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6539

On Thu, Sep 24, 2026 at 03:29:13PM +0000, Michael Margolin wrote:

> > > 2. Expose EFA_DEV_CAP(dev, PCIE_PEER_ACCESS_ENABLED)
> > >    directly to userspace. As you already stated, this is a
> > >    bit awkward as a device isn't expected to be aware of
> > >    system topology, but since EFA lives in the cloud it is
> > >    partially aware of the platform configuration and in
> > >    particular the ability to access peer devices over PCIe.
> > 
> > If you already know your VMs are always safe what is even the issue?
> > What are you probing for?
> > 
> > Lets please not hack around bad userspace with even worse kernel uAPI.
> 
> The EFA device already knows this attribute. The problem is that this
> information is not exposed to userspace today.
> 
> So if I go back to our original proposal - exposing the
> EFA_DEV_CAP(dev, P2P_DMA) bit through query device - this is a firmware
> attribute that says "this device does not block PCIe peer access on its
> end." It's not a topology claim, it's a device property, similar to how
> we already expose RDMA read/write support.

And how does that help you if you actually need reachability? You
haven't said directly what you are even trying to achieve (though I
have a pretty good guess).

If all your VMs can do P2P then what is the issue? If you need
pairwise reachability then you have to use dmabuf.

Precompute it and use a topology file like everyone else?

Inject a topology file into your VMs, like some others?

Jason
