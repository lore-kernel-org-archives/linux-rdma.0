Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012055.outbound.protection.outlook.com [52.101.53.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269F649C4BD
	for <linux-rdma@vger.kernel.org>; Fri, 25 Sep 2026 12:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790340919; cv=fail; b=j95mISW/iLG+2nJeG1rm6SOn1ey6+pFQY4z8B5zUmY6dOEEI92PwBjb333lqLoVBMI6byKzaUSyRkJl8c549F47lOJzwNi/pECooftxiksUulPesONH8Rr+bMJgvWiKGEC7yE24jbYp0ev9qe1F13SXth4uF5EkDCs7CYdq+VXY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790340919; c=relaxed/simple;
	bh=f4D7COdwV55kQDvOiOiybM3SsrhUbMDUWXEMInop1wU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=R5s29V6JaslfFiYTyD0RJFQLej5yszHq/HM7sOLUyvqWzibcSlifmmiiBMEIKLoSVkv/6Wq2GabNx6RoZDARTrxbNMrSl82W57sYmK5BtdG/PaGBWxGFNUPuJ1zh5R/3IAXmCqwxdGw+pBlOwRi60Jc6cpTtnqVRbTwTHWPIGX4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jQsUvCgt; arc=fail smtp.client-ip=52.101.53.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jQsUvCgt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HYuYKQx8Tm9mJDBUasCAee/e/lCP4Z0KZgXxNU/1XX+vZhPmlO1YlvS2V0lrHuOVHjpgxazhlOEdf0SDkkjYfFrWm9sdr+FVnaco90w2YpUi65Vd2lSfoRPXHPcIeD4GAvY2LVBCr3jygT5kcEjbZDRjSj41r0kesol11d+fWdGgRJ78bCyZiRBCqQaw0nmtK/O+R+Dbu8gDn9PTUwbkTD2CnxQCELeXNOEqe/6d6MlFjD339HvX5nrzmJ3TtLoXhkdetQmDhovb4t2fpqQz6WV3HzyZPFKy7YWRK+EiMKFNhJjkEvuSf+F3LJWFqrSd2p3iJ7U5HsdpiGrVUJP8pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EHRR9CR2jGl3f42sRPt0T6PiOjUGYkHBD6hXaKc/OYg=;
 b=A2hi5Io+jWIv/4q0gwZRBVT7GfA+vMjVPtdtRhnRBBSvkpzE/7zGjrefrdaIIBRD5URD7cRoodWQK5KG/dR7lNB7QBTAGLOUpXmU3sXdLhp6U9HMidgWaqGs5Dpuph4AG9aVzuFhlZYQ0wsYZzbZs/2UG6VEfgQRT757QeekBuBl9eGTDtRNX7iuHpc0NrX3DhAqquHLAO3jPTuaHzI52e6teWCv5BRnRRclT2Q6gZMUeqAN1MBo+dYNXRwZtd7hzxOqOnY2dpPt/Q5VhHozweDz5LAzvX1UFk/6gd31unq9XOD6aS2Bl2RrK9Dh/I8VnyQcS93Fp4f1nBmvtdYqAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EHRR9CR2jGl3f42sRPt0T6PiOjUGYkHBD6hXaKc/OYg=;
 b=jQsUvCgtBgHuc2SG3EKRo7qsogy72cKBqE3Vd2fCs8jipnRB417BzNjx0+/SAjwIjsFmkkLrVHiqGwmTzG2gpnS+UhnTyl32mqlxC2o+wJqsT+aa06cNAd4S0PX3az7tjyw2i4bwwjV50Q0os0L3nZNabvJVz8kw0LdeXFsdge6lLWtMHFa8bPotaG53TP72N98Ic1uEOvuCcura7n2fuCTRLWDB19kZ360LOvfREpgmwufJ6/S6y4G5HE/SdUUdVkaOQswrbsbZoWQIrxH7NzmZtal5ugJKFuak4D7SISKcidl71czAQu6ZNivUuNZOotB31DJUhDSlW0ApuCJhow==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LY0PR12MB325698.namprd12.prod.outlook.com
 (2603:10b6:408:3bb::14) by PH0PR12MB7486.namprd12.prod.outlook.com
 (2603:10b6:510:1e9::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.19; Fri, 25 Sep
 2026 12:55:14 +0000
Received: from LY0PR12MB325698.namprd12.prod.outlook.com
 ([fe80::b65f:1548:5b35:e2b5]) by LY0PR12MB325698.namprd12.prod.outlook.com
 ([fe80::b65f:1548:5b35:e2b5%5]) with mapi id 15.21.0451.014; Fri, 25 Sep 2026
 12:55:14 +0000
Date: Fri, 25 Sep 2026 09:55:12 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Michael Margolin <mrgolin@amazon.com>
Cc: Yonatan Nachum <ynachum@amazon.com>, leon@kernel.org,
	linux-rdma@vger.kernel.org, sleybo@amazon.com, matua@amazon.com,
	gal.pressman@linux.dev, Yehuda Yitschak <yehuday@amazon.com>
Subject: Re: [PATCH for-next] RDMA/efa: Expose device P2P DMA support via
 device query
Message-ID: <20260925125512.GM9354@nvidia.com>
References: <20260503150246.2349679-1-ynachum@amazon.com>
 <afhL9DLUVhnVyzZu@nvidia.com>
 <20260505081514.GA19297@dev-dsk-ynachum-1b-aa121316.eu-west-1.amazon.com>
 <afoPWiiEwk5igB/N@nvidia.com>
 <20260923163830.GA6954@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
 <20260923171741.GH2545495@nvidia.com>
 <20260924152913.GB24800@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
 <20260924182201.GB9354@nvidia.com>
 <20260924193026.GA13498@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924193026.GA13498@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
X-ClientProxiedBy: PH0PR07CA0100.namprd07.prod.outlook.com
 (2603:10b6:510:4::15) To LY0PR12MB325698.namprd12.prod.outlook.com
 (2603:10b6:408:3bb::14)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LY0PR12MB325698:EE_|PH0PR12MB7486:EE_
X-MS-Office365-Filtering-Correlation-Id: ecd4d4a0-f839-4eea-4a1f-08df1b043dc0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|56012099006|11063799006|4143699003|6133799003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	R2J8sonZGqZ/5Na2F49surPqq0pSst5V/b1V8P0fBx39+wJzNOXtHGdzR4Tr0eoxdSOOK+9GU5cUZOH+lRhiZA4YSpavjC464hGvIAFy3LbRqfwgFu8sVwREnepJDZjCkvxUBsLlTeg0bDM/TG4yiCs6Zo2NgWGJioPrUZ4+rsGL+ktrUskkucvOyYNpXnh5xSTQUm4umHVwtz/mGgVqPmwfiIPJK2AWMbj75nXyZ45WYnGMYjbrD7w//gSg5hRRjg2zJL7jRt1COM+9Qe7bboeA2+zLEdX2tUgr1f/dYop20izcyRoqAR84p9jpQQNhZ/jzPpU7Pnu9VKdaYgQTaT8Vf7xEvv9OcE3UoYy7QaN8vPjIRXbPmSZE5PkxnUx8usSFcIn80c9/8wTjSHQAMH1jC21MNTPQsOXhBnrfaAWUfc708IzPWenNd74/KbWtVBRKDuE+l8jd4HjXorhtAt5R/W6B3oHvh+GBODNdDOcyaMf8cCyfxC15M5hhCXfP1ir7k0jXRW0/Z/G1O+Eh+MttwVU0lNV2XYLO5EQeeG6D+hHpo5E1QsxvKVHP3k97qr3o4IVPPwAhGFEu4TMrxtd7bF/2k3acb2VzM/x+eBapvEdtsnp9YVCXlF4NGCW2R0sJObol5bMzyNhpfa0zIbbEgvVUJK/r3IV5uEQSzqY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LY0PR12MB325698.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(56012099006)(11063799006)(4143699003)(6133799003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AWh4SCFZoXTNpeinC3TxRSwlw7Y6f8JqrTQTeJdG0NOknVUn3laEgqQbs5m7?=
 =?us-ascii?Q?pqSdrPW2dkmYmSUy0TOXNUSLkK5aptgFNU5X2reC6VIfqA0AcLS9iA0rXNPi?=
 =?us-ascii?Q?kyW3nf13eiND6XvEUUwRniRwkm2rlBPLbt7EUse8gUGAEff6adgSiE2+E09Y?=
 =?us-ascii?Q?YplsiOodOYRnoWYpK3cddFcJIV2rKshbmDoyZIR/5BHbMT+9b1lcTGh1UkWQ?=
 =?us-ascii?Q?jNoJXnZgIwQ7EfAlb2YMTh92a6Z6LDkZ447DTl6sRELS1c8QR72sSEaSKRxN?=
 =?us-ascii?Q?NvR+armmDLszepp4q+mD7oyk59TPtN5OUjGF7BxtdRW9Dh7YkCBp7ce33k0E?=
 =?us-ascii?Q?QijRNBR3gW9ZvIZIR0cf0gENzsEiqFNJtAT7YkuHx62XsPcPTLvYJ/e786GL?=
 =?us-ascii?Q?F40D6H/lU3zn5bXLxnHK5C9Si3FqZOlmaKbPZ1NzzBtbt+WqWs/j0Uf6Qogj?=
 =?us-ascii?Q?vzU2GBLk4e4IC0gMfszTwWP5e3yOhPqt0DGORIaSejhN7XvA9Qk2bxNjfQHG?=
 =?us-ascii?Q?1S+0jtEOAC9cLVDp5ONcjkjTLd1neACzQ+z6P9TWVEaVb2aAmkFLoTxWstuX?=
 =?us-ascii?Q?OrxQMwdZdezbxXoQoqddNYn1P61LUkCPDT3+SIwS69NARsgZI0u1BMwP5Nj4?=
 =?us-ascii?Q?ffrzy9jx0kBT+QzlLdUzZV9v/a7Y9FZrCp95Oc2muHF/Xn+HtUhG+kLpk4OM?=
 =?us-ascii?Q?WAsQX1/SFrJlD5CX8opvDz3g9vb1fJScUiBX9OCEhuMfvQsnYBIwLudMKT5s?=
 =?us-ascii?Q?dPeagRn0uoEV6wni9UH5T9QUv9G0JuoXmAA050iVmitCUy1PRjHy2jxdeReF?=
 =?us-ascii?Q?ds3AKMh/SXahx8G1X4V8OS+zL1yqPp+qNhy192EV2fHCq/pvMHBWCCML++uO?=
 =?us-ascii?Q?PS/qTi8BVOX/riikpZC1q+y9c4MyM61Wq7KPJ83AP9ByfFeivIgt9Oq+zcgw?=
 =?us-ascii?Q?8zcykGgBrngheTKNDBl3u00ECX9EcubOu2a8j6W42ZKf0bMBeBHQkeTgSu9y?=
 =?us-ascii?Q?8fu8sD6Xm8U0+egNE7BuzEv4B/B/NgOJPTh68EcXJXFKb7vVQ9caAPryS2Ev?=
 =?us-ascii?Q?H0zf+toPEz8f7lUWKK0e//+/l/Vrb7KJi3/kYv9QoLVKrmx9T9hNCJpfK9gZ?=
 =?us-ascii?Q?H7Nus0qO3GdBikYrcMjrTInKbeZFmCMAqXw9M3xKl90Z09625L8zf0X/nqb+?=
 =?us-ascii?Q?OwTldVzCllqiaLXEMzP01/wq/B9i/UeMidJOhRzkiLvcqRhK7LGdpyXNsOPK?=
 =?us-ascii?Q?sIbWBd2GEaxrgLHmAjiYyQhMrDDnLGSgNWzA2jfZSm4PSBr3EsxD4YH2AwnE?=
 =?us-ascii?Q?zn8QyLG6Zki5xFli6PunaMih7A5sg3+RdDREXiXruPQq9BwzPbdOWCXXj/ux?=
 =?us-ascii?Q?nYh2lkdNDqjvI0WVo821EpqTWNBzzmWJRpRdoNHSf90/K/Odkfaz8CC+ellG?=
 =?us-ascii?Q?HG60DG+Mfg/UEiMbBEn5VbtmhETGqxExNrjIlAsF4DWOr5PzYt8J9Tc+t/FZ?=
 =?us-ascii?Q?CifZKC7AvBBdoSpm+p/P1dPCrPZOEs6pu29z9z9FZuJsEi4vkYVL6ux9KfcE?=
 =?us-ascii?Q?SzSj9ipMzEmjTbJ0KEENZDycN2U/kH5vChRiUK3gAAGw+B9ecNxmdpjzW3Mu?=
 =?us-ascii?Q?mPM10wrQygIMJrNnEZH/DpqEI1KL9q+2WUQDqRh2mnQn/p1uWZq8fQQu8W8F?=
 =?us-ascii?Q?4Pw9px4Kyup/L+M/fSEbWf9TId9Dph5rDMD/8XJWUlkYoKV5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecd4d4a0-f839-4eea-4a1f-08df1b043dc0
X-MS-Exchange-CrossTenant-AuthSource: LY0PR12MB325698.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2026 12:55:14.0291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VIQk+2pBURlmbOZ1W2caY/4GV02RNo/1qM58GDTVxKq0FlbxG/bo7rW2aFYpbF6n
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7486

On Thu, Sep 24, 2026 at 07:30:26PM +0000, Michael Margolin wrote:
> On Thu, Sep 24, 2026 at 03:22:01PM -0300, Jason Gunthorpe wrote:
> > On Thu, Sep 24, 2026 at 03:29:13PM +0000, Michael Margolin wrote:
> > 
> > > > > 2. Expose EFA_DEV_CAP(dev, PCIE_PEER_ACCESS_ENABLED)
> > > > >    directly to userspace. As you already stated, this is a
> > > > >    bit awkward as a device isn't expected to be aware of
> > > > >    system topology, but since EFA lives in the cloud it is
> > > > >    partially aware of the platform configuration and in
> > > > >    particular the ability to access peer devices over PCIe.
> > > > 
> > > > If you already know your VMs are always safe what is even the issue?
> > > > What are you probing for?
> > > > 
> > > > Lets please not hack around bad userspace with even worse kernel uAPI.
> > > 
> > > The EFA device already knows this attribute. The problem is that this
> > > information is not exposed to userspace today.
> > > 
> > > So if I go back to our original proposal - exposing the
> > > EFA_DEV_CAP(dev, P2P_DMA) bit through query device - this is a firmware
> > > attribute that says "this device does not block PCIe peer access on its
> > > end." It's not a topology claim, it's a device property, similar to how
> > > we already expose RDMA read/write support.
> > 
> > And how does that help you if you actually need reachability? You
> > haven't said directly what you are even trying to achieve (though I
> > have a pretty good guess).
> 
> On some platforms P2P is blocked at the device level despite the fact
> that the peer GPU is reachable over PCIe.

This idea just doesn't exist in Linux.. It is completely inappropriate
for a PCI device to declare it knows something about the
topology. That's not how PCI works, it is the wrong place for your VM
to signal information about the PCI routing through the EFA driver.

That needs to come up to the P2P subsystem.

> This mainly happens in multi-instance setups where there is a need
> to manage PCIe bandwidth or prevent noisy neighbor effects. Today we
> check this attribute on the device during MR registration, so
> libfabric's EFA provider allocates GPU memory and attempts to
> register an MR to get this information.  This process is costly,
> thus we are trying to replace it with a simple capability check.

Which is the right thing to do, again if it is slow go talk to the
people who are making it slow..

> > Precompute it and use a topology file like everyone else?
> 
> This is an option but it seems like a big overkill for the simple
> check that we need.

Maybe there is some other place you can inject into the VM a 'this vm
does not support p2p' flag that userspace can see?

Leon has been working on some ACPI enhancements for this, perhaps that
new table could be distilled down to a single sysfs under an acpi
directory?

Jason
