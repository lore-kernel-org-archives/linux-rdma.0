Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010061.outbound.protection.outlook.com [52.101.193.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C5D313E31
	for <linux-rdma@vger.kernel.org>; Tue, 11 Aug 2026 19:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786477582; cv=fail; b=c9j1VI97Gw80lkCP3lLQ4V8Ncn+juPu4tJVX/1iseTIPdYzdqcFerpcoeV8IbJOk7tjSX2o3Yb/+d4eqWtJkYfILBBG101lipqoeQHgJuq6ONigYteHbbThn1pB5lVgAM0IJ4/BAIEtC3fao+XzrnB2LZrdrmUGUEu3DpBfcm1k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786477582; c=relaxed/simple;
	bh=LEmZ3HI4kW6QOhYpto3XrkYlE0nGEMD70ZU8I1YBB4o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=EP2aSPaFHM7FKz4BaxbN0fk/Tu5UxUhQw+Ey24ueuSWHxoSpWQlrIF0nfgsgGtDZZrFFKdKNU0pW2oAA5K76e0/i0ymnDtnQCdu2mqW3/+zspq7x0VNjyMzQWAcb0g9ZqQUNM782zTIVQvQjqQkqqrxRpZMJypIoWL/UslC6Kck=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WK8wLHCb; arc=fail smtp.client-ip=52.101.193.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WK8wLHCb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HoB+VMGZT8Gp5L5ctxfaS2dWb5Y+daxh8VoIN5MwW6+aEplXUda/FFrvkI7I3wtVRuO14eLSj7foTt8Efenv1RGqD7gIiK6Eisegw9eWFjv502enZLjMsuMIBKJEMo677tbBG6/QMVBGASmvturHAlYobjNrF220NfODziTDgC46FBEvog2FkBCCj7BGKXZ0U3Kw653KA4GyueAf+22cqTz7IIX3Z/rKbIh/3pU0qjcRP97WPEPuIg/Ji1um9bfZhG5VG178jAn+9HxOwJpL5H/X6nTUTo8Mc6cwDfzlGMNeXdXYQvjBW1lyIey+MwnCjBRo95o7AbZvzCQcbA5p7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/UIX5obG1M/0nj4+od+uUdVM7gsPXC96J2NpGr/fMOI=;
 b=JskU+MGCHag2WD/S79tq8mRIEVu3vyEgxjbRscQyPRwRHpy4nU0atm5qug0uwW1+Z8NTO+qxEJUADG5WkI/GC5ZBaBEBnSSv/bgF2egOcxvI6qdvYUqOB2TIeTiFxlFhFgglwcMXW/720/3tuWeTKx+DcB7TGKEpd1d4OL8zjt/aVPkcJONjJk4Ics/M7DKm5Pyd9FaR8wRnjb8QGZn7+38ANPKx2Ttu/HK5CMCAmlwX12ymBhAJwVS8UggUa6ihTdsGWW1ImCBgCf/8qPMhwKF20DNQcDo+UtTZ1b8jJ7xZnEk+WTweaSb7PYx8AHbu6hsffgGCDSQzc/xi5ydPuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/UIX5obG1M/0nj4+od+uUdVM7gsPXC96J2NpGr/fMOI=;
 b=WK8wLHCbqbI4SY7JAqdaSscbV4pGCrrulpaUMUJd0DCIP7SswZa6If6i2Q+G79wktfGlpWgpVBUAJh3wAE8yfLk+8Q+PfikVvSSWCiJT3aMIam3feuSmx8ATJHzhb4BlLoZQ3xzrQJiophG3Y+E1BSRsF2ZhjUP4f4kzhM51hSVSXpeC42/f1lN4LA0xT6MUsYfnvNFU4vXW9p7pMmMq6GpVpTXlxvlj7XCmFeeIcBK/htOgva69d+vQJF3Z8De8YZo25MhcGxK8DYAjBqn74HMRNYBgp5kkn2DMX8omWzM71YUDDuUoI7FhbjPtWbQjZXMBw/BqTQU1VVCp6kDI8A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SN7PR12MB7345.namprd12.prod.outlook.com (2603:10b6:806:298::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Tue, 11 Aug
 2026 19:46:16 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0315.011; Tue, 11 Aug 2026
 19:46:16 +0000
Date: Tue, 11 Aug 2026 16:46:15 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yonatan Nachum <ynachum@amazon.com>
Cc: leon@kernel.org, linux-rdma@vger.kernel.org, mrgolin@amazon.com,
	sleybo@amazon.com, matua@amazon.com, gal.pressman@linux.dev,
	danamala@amazon.com, Chen Brasch <cbrasch@amazon.com>
Subject: Re: [PATCH for-next 2/2] RDMA/efa: Pass relaxed ordering flag to
 device
Message-ID: <20260811194615.GA661754@nvidia.com>
References: <20260806075758.3476667-1-ynachum@amazon.com>
 <20260806075758.3476667-3-ynachum@amazon.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806075758.3476667-3-ynachum@amazon.com>
X-ClientProxiedBy: LV3P220CA0004.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:408:234::16) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SN7PR12MB7345:EE_
X-MS-Office365-Filtering-Correlation-Id: ebb26b80-866b-48dc-d26e-08def7e13501
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|18002099003|22082099003|11063799006|4143699003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	8YCgBC6U77VpWqG97vf4IZMM5VXfocULpj9rto5XDORR2dVLkZ4EosxCWMiG+iOtSR5BCmIucKjw5odtOiKs1eUGZO7VTwklHsdAzBZ8dk28aRVFCKUe+zq5YjYQALWJSrfYhKGd2YpKEp1w33J8R3BoFHkcF00f5br0OiIwN7pFnpiish9vt39hj5k4kLyzF8ZgzKnhzNQsswUufZxt6l0VoogqiOR5xuNcrhjQS5M1l3B6tBgAIL2G3/Pgip+pCUusefMLuNrzUgtSBaNuHU7pfITW+DWootI2DNu8CFJM44a93hpR6kOxijSCKUIylsSq7hDED8plHofjNPRWbCUVarSG9S5N97521JObFTMLvuCki7Dpfoi42gvBO0sxAvnLHJU7QveE/k5t9R7zIFgjmczg9DUvE/WZXoVNqijx2F62uenP+lQUHRLPIIYd5gXi0Aj/xAS7UHMf1a1DQSKAdkqEBTwRtUxsDBC3Df89KMmrH0LZ0eT5eXU0K0k3NMukqz6IbYuy8ej5cXpoOL6Zp54ZaDl5ElrodJs1ggJOxZg5y20KS0Q9cJryQeskJHf+nZv2GzwXngY0Ly0wExKSpiXZsWCUl3x8vC06FPzaYHGm8Bl6bcTzIsgwDsAQpMIk37ppSxrXlCFaN2w18mUG4rfAfdZbjTj5xFiIDnk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(18002099003)(22082099003)(11063799006)(4143699003)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QnuuKicvNmippcRnf44F6vAB8rGGwvRe2T/9+JmgYXzK2xzp00UjpaW40ISz?=
 =?us-ascii?Q?JwcdeOxMIF/EOxDeHBjUFmw3tHZJU8urI8jlc5T7O1BOWCsCR7dXVHpzaXBy?=
 =?us-ascii?Q?hPymMhzU+0k3b7vcvJNPwvA+Dy0mpNII5659E/zFluVW1SmxiLIW23OBFXO6?=
 =?us-ascii?Q?iWiQOHJGukay0YppMgVdaERMOdEQAHBqWyi3ub7kTFQ4zk6VsXKEAR5/UIEX?=
 =?us-ascii?Q?N93DfVX/fs7AjpOEoWYSn+t4H4KDobYvEGGaOf3Wo5qTFzwcGloNqEygL0NB?=
 =?us-ascii?Q?mIjqHUrn6bFJu1PXeSB+Q7WhQKbhZyloKaqBSULhJGYTN9Mi8MwNx8MYzl2H?=
 =?us-ascii?Q?Lw1pba2athr7w7/Hqs7+WqWTcytHo7KWLeD+gxWRF5DKlF+rcG5HuZyVr05R?=
 =?us-ascii?Q?V0/LckTsZWNTCpaLy+bSeo9l+mOqEyj8OlZ5tbDtvPG9gfl3c6dBxP0014U4?=
 =?us-ascii?Q?4n9l7z7reUDsHT7apBrpbWf/6A8NXZ4GqJ5l6wofPsBSvi+7DgE+0AtL0AlE?=
 =?us-ascii?Q?yj+NJF5tSTDKDP6J7lH/K5QCUc4Y7XDXjuNQ8juv8hxdh/Ij+v7fGIRvZCGa?=
 =?us-ascii?Q?gE0H/BiA/zVkaZB9n65qIhf+XAFT8GItExjfyBm8F5xvu3Pe5dnnt7tzUYZg?=
 =?us-ascii?Q?goo3SCl86h22ZrZRb4hrq8eG3OnKSYxBF4BYEsq/B8HlQMaCbHrJukoBpAqO?=
 =?us-ascii?Q?A3srJ998NcwZ42Thz6zm9re0J/Z09Rtpcd52cp2xefjKinLgUMvMSeKv7bgT?=
 =?us-ascii?Q?iAbpu341Oe/PtUYTPsBq3bll7U6N9nBwSkFe/FUPp7YCsyfNv+4Pr+VDOVjm?=
 =?us-ascii?Q?CpghKmPo/dCJ6yGIlsQezIG1kK8jcJ0UHuiR8ra5B/LF6s638YJ7CazcPru2?=
 =?us-ascii?Q?t2AyKj3gVvhOyWkYHsCmCDmc7Z8zrJ4vlYxtQMPXinhW3gPrj32/OvVwZiHm?=
 =?us-ascii?Q?eo+pz8rm9dxLxa1Gi87fz+wkjt2zQbN0spZcrvuEuKT5aFHopsIPJWQWrU57?=
 =?us-ascii?Q?fHNdlb40DuPMUUfnbdktdNn6inpVx8kZ+FDiCVtOFeURhYeGAwAaxUEoU666?=
 =?us-ascii?Q?rrMlMxYM8Pn032pIuc/F9oCNgMx45Dm+tzdZJi0Q9Uou4XNJg2oHJ4G1ecfd?=
 =?us-ascii?Q?1/Uh3XT97K3nEVfQ6c6w7jWh5Eo8Oo8qP0ytkMXUrH+/zn3K5/Xs5Ke8c2yS?=
 =?us-ascii?Q?24N7k4PXJRuJHLRKh7b6XFnLueMwNCkZ0yCLNc5T1lDk3MfLkPUyuajCGZqT?=
 =?us-ascii?Q?9hOa2NElcq1nSFH8IOJLryKYVedOlYKElvH0IPWbRPeqd83kK+2IHkBacuOt?=
 =?us-ascii?Q?RS2PSM0ld20Yke6x92Ie0bEMrzA7o3Qa7yh/t0MKv6Qk1KE3bt1Sk2XEfDZs?=
 =?us-ascii?Q?GDzvhw2N7+bN4ifTp3PsR9OgToPWrl/j0Ko25hayK2k75uUEZTmujoJj4ir+?=
 =?us-ascii?Q?GBWqfAtm9tCSh9TCOrY5ZmAsMXlnlJZrbbN/rrG+VFX5or/Gnj4zJZsiSjq6?=
 =?us-ascii?Q?qaAR4yFsWbxc0/iZnvPAsfy3jd6+l07R8EFBuZkPJCbCEV4gY4Bj21r1z7fn?=
 =?us-ascii?Q?NrDTBgEA3QEKRZE9cs2/TFRoYTMd/QUG2dQwXVnEMz2XYCcVNh3GTczU3BID?=
 =?us-ascii?Q?ptw6d8tzqy4x4N/qQ9Q1UMv2Q8DrF5eT+/D7j783Zubap6iE2SgYIC1nBbU6?=
 =?us-ascii?Q?jVQ8NmQgsvCeb53LMCU6Uw6STD/DhbRy+CuYN5qJpo8HBm7Anlpwdfot5HWc?=
 =?us-ascii?Q?zJdfAMKbrg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebb26b80-866b-48dc-d26e-08def7e13501
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 19:46:16.4068
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9GBY/7xa6egFYEga7ev7I5II7gzMFN4MotNmhjKBlMqtxlkJ5VJgLbYsY8xDhzBz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7345

On Thu, Aug 06, 2026 at 07:57:58AM +0000, Yonatan Nachum wrote:

> @@ -1647,6 +1650,9 @@ static struct efa_mr *efa_alloc_mr(struct ib_pd *ibpd, int access_flags,
>  		(EFA_DEV_CAP(dev, RDMA_READ) ? IB_ACCESS_REMOTE_READ : 0) |
>  		(EFA_DEV_CAP(dev, RDMA_WRITE) ? IB_ACCESS_REMOTE_WRITE : 0);
>  
> +	if (EFA_DEV_CAP(dev, MR_RELAXED_ORDERING))
> +		supp_access_flags |= IB_ACCESS_RELAXED_ORDERING;
> +
>  	access_flags &= ~IB_ACCESS_OPTIONAL;

Since:

	IB_UVERBS_ACCESS_RELAXED_ORDERING = IB_UVERBS_ACCESS_OPTIONAL_FIRST,

This is confusing / dead code

The rest of the series looked Ok, but why are you reporting a new CAP
back to userspace? Did you have a use in mind?

As above existing kernels will accept IB_ACCESS_RELAXED_ORDERING just
fine, and it is really just a performance hint anyhow so it is fine if
old kernels ignore it.

Jason
