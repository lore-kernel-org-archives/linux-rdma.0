Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012049.outbound.protection.outlook.com [52.101.53.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB01850C2BD
	for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 13:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791897376; cv=fail; b=buKwu+cTn450Cwm7V+DwyEZf2I2kLwxGBlhPilKjp8DVsky02ATQY4wtJ6NSjDc+fuF998alk5ACdWLXAa4utjJRdzwmgVLyYncspday/8WUfkeLCprsIhAEzcbpNDxf9tPukxQAC+sX9hJUVV49wj7u5cKr8sdvM37a2tyFsm8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791897376; c=relaxed/simple;
	bh=heSkZQEI3wILkBAjeu3fmggep4UK2ZWpWs2u8W74kFk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=JFj/wKfEN61ZiNSdvaSnmA1XMRX7Z2ew63+IYSrf6f73Y47Zt8ww8V5eEpP+h9VXRBZ2rDsDuQd27CkFjVCQJBVtLLP5LxPme8qLVmPR9o/olUGErty9v+GBbODDtJ88fXlkfVnLZN+39Qk6oupByc+NUBx4IlJ85A133BiME2c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HyqoDWyy; arc=fail smtp.client-ip=52.101.53.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HyqoDWyy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ScGajaN6kWpRid+AgNftZVWXMMbyROxK3wnHZCLWVvMYgONRHZ7bcFoy1nYA0rWyO6l5pG97r0Khp3FMHy8fFSkGjmleqhOtaVgGRXLyQqgi9+aSCurY02O7ynUjuLQvgYY1+IWWyNGELh6E8I84FZI7ahvLVpM1yobPYlXhEWIVS7gJjeUhKGJ4zfQ7xLEdJ0Ps3963G+vtBmD2RNUY9wuDfPVHSIRVufvzXXDSe0XtYuZmi6MqziWaBK6a4kOVHt2xOXIRF6ftX0fbVssplddtlep8ZwP7AzUlvcrsgaCEkjGpRal0xac4Drb6PRbxW8NyEM8m86WbSDx8UbSjVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PXKJmAN5VJAp/qLsar9S1cuEbvvPTuCAK2ww/3MA39M=;
 b=lg8fCLJKKN4HAILqcvivtWNqw2Z5/ZVAXwy1B6ZX+eILBk4k60dHJC5BFJRtdIBbNZ+/bF91+nE/Vu4U3zKeVkNfFL2MXxkY3LexrvOwMKF7/ghJpvf00uMqvlSvwuR/qiYgWI0vXnVGs041V1TLORFn7oNqF44h7r6IS8NO6E7sy0Ma6zZJzkZ0DXuy9PJN5j7Odo/TrDYJ36nXrZSUN//TQtv3LhkormxO5jdGdVmy9C5KbeqESat9XHVKH+b6hZSm4gemQ3L3l6ddqR4Qi4TROYpVyARA2fZmZNOmhqvyjZLXeAkr1Nsvqa5Rkjsgt7slcjA9SP6CfXm4uOAn5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PXKJmAN5VJAp/qLsar9S1cuEbvvPTuCAK2ww/3MA39M=;
 b=HyqoDWyyowZUUCymgGyhhJ6zHRtCKws4lBF8wrgfsX6AQsVsPuP5naRKAgTaDhcMFKWArEO2PQ08NzBEESWl6wJE2WQvlTnW6w4O/WR44OEZekqjOZ3rS/7VU5oZmHqOOLjrhbonWAt5y59xH0GfIQYeb8VX0wbagqxRNW8iTm0+AY2VbQeifS0CucRDyEUj9U0ah6tm+kNwwG2momtjbXeJkjvMm0OS5cSwKJcTPRhSoqYmWBGpku6/bmonwq4iQPAErYFpyYoQPpuz0kkH3GJrWNueTJgWNVLJOwX/fmKDUYO18SpVDzUr4m52Bnp7vzmkI+q3d19lRSn1zwG1Ig==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by CY8PR12MB8195.namprd12.prod.outlook.com
 (2603:10b6:930:77::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.17; Tue, 13 Oct
 2026 13:16:01 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0496.021; Tue, 13 Oct 2026
 13:16:01 +0000
Date: Tue, 13 Oct 2026 10:16:00 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Michael Margolin <mrgolin@amazon.com>
Cc: Leon Romanovsky <leon@kernel.org>, Yonatan Nachum <ynachum@amazon.com>,
	linux-rdma@vger.kernel.org, sleybo@amazon.com, matua@amazon.com,
	gal.pressman@linux.dev, Yehuda Yitschak <yehuday@amazon.com>
Subject: Re: [PATCH for-next] RDMA/efa: Expose device P2P DMA support via
 device query
Message-ID: <20261013131600.GT13920@nvidia.com>
References: <20260923163830.GA6954@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
 <20260923171741.GH2545495@nvidia.com>
 <20260924152913.GB24800@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
 <20260924182201.GB9354@nvidia.com>
 <20260924193026.GA13498@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
 <20260925125512.GM9354@nvidia.com>
 <20260930132613.GA24387@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
 <20261001155333.GP3401365@unreal>
 <20261002145241.GV1616761@nvidia.com>
 <20261007090136.GA35552@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261007090136.GA35552@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
X-ClientProxiedBy: YT4P288CA0022.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d4::20) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|CY8PR12MB8195:EE_
X-MS-Office365-Filtering-Correlation-Id: eee6d032-ef86-4a04-264a-08df292c2082
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|23010399003|10067099003|56012099006|11063799006|6133799003|261009223027099003|18002099003|22082099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	FacSorMn9zysJjASfwODghaIcl89KcX1zSXsBW3d5rF/pkTVeJH76dC3VtzB7jQuN8DZ0HxR00nbgx62LknGlbbBW77McwD4OLj4UVyECcx/Qy3EyckRRDLLqeYwh8jPCkV69tm2ewmfBVZ7K8Xg53Jxq++UAFJcfaYviMrsWs62p09RiLfreITYtAQhCxsUDqmUrl0r1lZXu8u2NvsuRKciLeqfcDumdwHUpnko+/KGbg29QMb7sV7JCTHXDIz39wnZFJFIsjgCL8YwW23aDFJI5ngxF4x9P7Dagxa8sCNB4MBK+jnztqcHe4g7KpTM85OQ9dOrIEjcTj+BWcnnEAE4E/QOFttpCUyFo44SAKpUof3EpA3WEcAmZP46+mEQmrs/eHLQ7WAhUDmN2FQHpqwI2SnxebwrSYK+Ixf953t/msXm5MGlFYt8JbnS31vy3GlOC/YGoa/4aVYydomamCzi8f0F/WdwVZGm7XvYcQ1MXkTU5M+O4X3kdYiNsiVFoRT7cmvkJl2LM3wRb1tGvcF23ghPHWGN/WLyN7ZluMvJlNYrjSRBw/Wrk4ELpjny7LobDtpi+/RGC0DmA0lZSh2vhI09f0JLpvULcKyhadA67wrGe/PzQixcQB0i+JFAf4W8jEs0qFyYo7OYt75Ud6GXcjnWIkbz5I0nKRUv4aU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(23010399003)(10067099003)(56012099006)(11063799006)(6133799003)(261009223027099003)(18002099003)(22082099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d3FMdTJiYWRyNU9NV2I3UFlQWkU5STBhaFVxNFF6dDFIWDBrdC9Gd29NendJ?=
 =?utf-8?B?VEppd2dSNVh1b3hIVHYzVXpFNDEwdFJqTi9KODRVNDI5U05nY050bDlGQ1Mx?=
 =?utf-8?B?d0JtalM1NmhWc3hWaWtYRUZWTm5pNlhyMTg0dGlVd1IvWjJtc3JGSHJvNU1D?=
 =?utf-8?B?bCtCNW45VlpEazF6RWh3aTlibXhFSGwvYmEyMGI0T2RUSEZ4cEcranA4aWdy?=
 =?utf-8?B?aFVYQnNYblhtTmJYT2lVWUxHNzZweWRIVEdEWS9JU1RocENzL3FmeU5acTdu?=
 =?utf-8?B?Tzc5RVhNUzByS1BOcUV4M1JnZjBabW9BUTVlZHJYNnYzTXhHZEc0cVh1L2dr?=
 =?utf-8?B?cjJEalYzMHR0S1MzYit5SDlUbTJIQ2ZrT2FyT0drcUFhTGt0VEE2VjhyN0Rm?=
 =?utf-8?B?WXBMSzlxbUZvY1BTaEJPTjErNUJQeWZIcnFzdTR1RVhVa0kxM0VFb0N4WnVj?=
 =?utf-8?B?VFR0dmNadVBSUHFIdlEyYXp0cmJxRldwNlBQdmZzN1lYaVNCV1NQak5aUGV5?=
 =?utf-8?B?cHJQZk91NG5DVnZsVG1NZVZIOVVyQ1JXWk5yT1dpczRQNldnWENac1NSSUVz?=
 =?utf-8?B?NkhoTG1hNkpCLzh4UzE2NFNDYlFDSEswcGNXaGZodExqbUNVUzA3VjBPS25U?=
 =?utf-8?B?ejVvaUg3NFJhSEdKYitzT0pRUTV6M3NKRDhZdkphYnorZnhyMHl2NXU4YTRw?=
 =?utf-8?B?di9RVGd1VVdsVFAzZW1DbE1GTDRPTGZBQXhyQWF0S2NPeGpwRVp1K2YwL05I?=
 =?utf-8?B?SEcySS8yYkFYRnFaNmVTWGUwVHJpRXU5dmN0Rnhkb3ZnSmxPdGZYZXcxNHA4?=
 =?utf-8?B?aktnZm1ISHhha0N0WnIyZFVpUVQyanhYQmNJelBpK3M0UmgrSmdFSFJMeUhv?=
 =?utf-8?B?NUZtcnlDQlkxRUQ1UXNqVlpBMlNKdmNqeURXUXZlWEJoQzNJakxzNWh1c2pR?=
 =?utf-8?B?OFlYcjJBVjJQc1AxdmhSVk12TmIwQS9OWk93MVBEZlNKZm5uLzczQy8vZU1M?=
 =?utf-8?B?ck42OTBsZ3lvT0pMbm1CL09xMnRNSHZqanlPamNVVWVIcmxsdUNRcnRBcGQ3?=
 =?utf-8?B?VTFwNFBWVWtZRWs1TFhWVldsTGhsVytkMHl5c21wRUFZRTIvVlVBSGZDWEFx?=
 =?utf-8?B?bnFYYklqOWJRYTNwMFlLbENDbWYwVmRoS0c1ZStxTUpSOUdkYmdTWnhrRGk4?=
 =?utf-8?B?cHhqV1JZc0VobkZ6SlZ6cmVXYW5PNXR3VGxyVk1KbFIvay9iNkp0U2dvQVow?=
 =?utf-8?B?UjVGZ3IxM2RoU1lUVjJxbWtrd2hnQjV4am5GY1NwVjl0bDMya0FJT1FoUjZM?=
 =?utf-8?B?cWZORkFaeTRmc0xxMzFOb2FxRDA4Z3RaS0VBT3hrZTNUdWlmSG5RUy9Fa3py?=
 =?utf-8?B?S0pqY2Zqd3c3RDFpNndmK3QwdGJtK2dreHg0MHQwUW04VWNiVWhXbk1FS1VJ?=
 =?utf-8?B?N3ZjRWwvRHB0Zk85UUpxWFE3R2RpUHp0T3g3ZFc1THFRNUxRWkxwbytKWk5L?=
 =?utf-8?B?NUZ4U3FmenNaNTlBK2MxNTA0bVhFZ2RHTGMxTGp6aGZmWDRmY1FRZEU0Wmw3?=
 =?utf-8?B?VmZnU0tRVmtNNVB0SDNVZ3AvZXZIYkRPUUxmcHBCSWkxZWJqTU1uelhDWnlW?=
 =?utf-8?B?M2pCMUhxWmtkc0dVOGVDK1IyYU9UMWtTNy95L1VwMDVVb2FHVTMrT0tibEZn?=
 =?utf-8?B?SGp4V0ZPZkRkYmlOQzhIZHdnSk9wbTRtWjFybW1SbnZFQmVSd29vM29NY1pO?=
 =?utf-8?B?UGFDL1hta1ZoKzFFZ0FXZVEwK0kwSWF2OHNscEFmWDk5YjBEMmMvclczSGxa?=
 =?utf-8?B?b0ZrTUpIdkF0ZFVmSnI5NDVGbzlJdUNCNEtKL2lObWdkZnZFUnRFcWp2NVV6?=
 =?utf-8?B?ekJaVTA2dzlQbE5jY0Rpb1VNbnZiWjFsSGd5WEJKUUY2dzdIdVE2UTVEMXRa?=
 =?utf-8?B?enE4VCtZMWRzalB6b0V3REFDZ3V0SFdiVFRpYzlnZXB0emk1TzZnei9acDZj?=
 =?utf-8?B?c1c0Ukh3amFqZEwzR2ZKa2dQYnNyWGhjclFsUVlxWktnQURjdTNKNXRvclJz?=
 =?utf-8?B?U0ZTTzBOS2Y3OUpWcGVCQUpMNy8vZ3Zma2xadzVaakhnN2lKR29URVVJZUVI?=
 =?utf-8?B?K1RNTUt1eDlVbGJYcVRETFBOQmFxb2l5T3JsQ2xKZjM1cWc3ZjMvVmoyVVU2?=
 =?utf-8?B?UlZ5YldWZUk1MGdMZ0hSbWVuREdnNnVUS1VTMzhlT1A0L25vaTYzSEZVVExO?=
 =?utf-8?B?VE0vUWpPVHpMWm5wWTUxV1YzZkpySmR5MVVkNmxqWFozekU5dTJsUDRJbjdl?=
 =?utf-8?Q?n+huq9Ow4dGv+83Umb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eee6d032-ef86-4a04-264a-08df292c2082
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 13:16:01.1593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OEIIaijjXVBIyuE8tRJKKSaFnUAfA0gePO4fI7qwPV54ICIWgPlQlX3L+XfYd6hI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8195

On Wed, Oct 07, 2026 at 09:01:36AM +0000, Michael Margolin wrote:
> On Fri, Oct 02, 2026 at 11:52:41AM -0300, Jason Gunthorpe wrote:
> > On Thu, Oct 01, 2026 at 06:53:33PM +0300, Leon Romanovsky wrote:
> > 
> > > > Looked at Leon's patches and it does seem like the right place to expose
> > > > such peer relations. Although it wouldn't help with our immediate need,
> > > > maybe we can add a sysfs interface on top of Leon's patches to expose
> > > > the gathered accessiblity (and maybe also performance) information.
> > > > 
> > > > Leon, what is your opinion on this?
> > > 
> > > ACPI tables are available here /sys/firmware/acpi/tables/, this will
> > > include our new p2p HMAT extension.
> 
> I was iterating over Jason's idea and what I imagine is an interface
> that contains already parsed data at PCI level, like:
> 
> /sys/firmware/acpi/p2p/
> ├── 0000:55:00.0/          # RDMA NIC
> │   ├── 0000:59:00.0/      # → GPU (reachable peer)
> │   │   ├── latency_ns     # 200
> │   │   └── bandwidth_mbs  # 32000
> │   └── 0000:5a:00.0/      # → GPU (reachable peer)
> │       ├── latency_ns     # 200
> │       └── bandwidth_mbs  # 32000
> │
> ├── 0000:59:00.0/          # GPU
> │   ├── 0000:55:00.0/      # → RDMA NIC (reachable peer)
> │   │   ├── latency_ns     # 200
> │   │   └── bandwidth_mbs  # 32000
> │   └── 0000:56:00.0/      # → RDMA NIC (reachable peer)
> │       ├── latency_ns     # 200
> │       └── bandwidth_mbs  # 32000
> │
> ├── 0000:9a:00.0/          # NVMe
> │   └── 0000:55:00.0/      # → RDMA NIC (reachable peer)
> │       ├── latency_ns     # 300
> │       └── bandwidth_mbs  # 12000
> 
> > 
> > ACPI is nice and general, but..
> > 
> > Doesn't AWS have something already to convay VM instance type
> > configuration information? That's pretty normal these days isn't it?
> 
> There is but both options doesn't help in the short term and long term I
> think, as you mentioned, that ACPI is a more general solution and it
> doesn't require any additional dependencies.

Perhaps you can disable dmabuf support entirely in your driver based
on this firmware flag. It is weird, but less objectionable than new
ABI points talking about P2P.

Your userspace can probe if dmabuf support is enabled without having
to do cuda.

Jason
