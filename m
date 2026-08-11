Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011030.outbound.protection.outlook.com [52.101.52.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F144766AA;
	Tue, 11 Aug 2026 19:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786476730; cv=fail; b=sQsolF+vZanzz/ubPnHvIb3gQ7UxnID3uae6ropQF7BWxq/JJlwFFZveygyc2mJpMlgqxz8jHXlMA0A1rjP6Pbu8Q7dg1OUdXBjKZ0NFp3lOZjXaYUzhCOnaTSXlYRsH4lwx7zlaTOfLzybr/jbQ0+RD4bEdRszFZHBXnLah2lk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786476730; c=relaxed/simple;
	bh=TMDGCBd7EIhEaIaUf1ET3iSw30asB5FSKWHqIBrubc8=;
	h=Content-Type:Subject:From:To:Cc:In-Reply-To:References:Date:
	 Message-Id:MIME-Version; b=p/bPIxdor0PY06g+ilaKTwUrqIY/8Po3PlCRQuiyelZp3MP4xMB6IYWkwbH568ABUh3wgIPMW6kvj1Ud8aLWdhSWHe32wdlMMGD3VbEIByecS+hyLFxtOxOhD3J5iyqzmvgK5Q4g97fZ71dr4Hg80cjKrsM54B12ZTGyKlPk2QA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cbhE3RCh; arc=fail smtp.client-ip=52.101.52.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cbhE3RCh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AUwwZWUKsSDrfZcO2uKKrBLnv3zmmYt+4TEIFY2mKAWzOqOGAgI1xGRu/Q0eIVPpdMp0PM4gZ2PkGmHpo3VFMU4QBYgSc+EhjkMSL+hk2gxeR6ZL6zPqixURw4x/XTzqGUg/DS3BsGwyrCFFf0x6HMe6EhgkTOxdx1MEJqd7MTIsBUc1C+dvlS7EbBSu6UHqUOwHBXjUUGz7a58nc8/CpzMdMdonvoDGKktvEKFQgAsHzXPtyMjI/9K0DEci5iH2hHBm85UbwWFySsDYYPTUA7J8XCmw14ctbs8C6kLhjjEGvFXcddY2QhhoFlRqQtRq+WBc8D7bcnfpYm3bx7zZ/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x9nCYvdjudz4UQv7EprB/C4UshRjw8uzYaSdgAgvf8w=;
 b=OJPRIvcsBm9TKJm/6mOlaMjxXPIFaPflyph/v6j2i4i3kVD5zJ5EtB5rBesysMjZ7NjCHLvem+zLaGBohgG2gdYkZcnv56uy+sMuc1UvQCawtRq+j8OXLZRudVxkbhxLorBI9Yegb4swPcLBXxGtJvQBBUVJL/TZdVhNxKzVE7EqTRyXqXzPc2XTRbbk/xl8+9mTxyVdfD5ChWuqv7aB0VGxvaydGRNMaRfTs5eU/yQbC6+tXmCZpYuHLbMI+99FGtN725DVUvDtaIkHcz1o7k8NW/QbJitI9/r5Xro0wy6722n23a8HUOrmucZDHjHGoUziE1y6BiUj1SFyzzdKlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x9nCYvdjudz4UQv7EprB/C4UshRjw8uzYaSdgAgvf8w=;
 b=cbhE3RCh6oim3Ywt0BVxzfxR2TpVVKNXU0OuMN0FdHT/YktpIDK6uiGvVeqIN3ZISpjoK74+WMU3w6CiwG5bh+eYpagF5pflQVnGtz+joUrnstL/vUH1athfZnl8CygMLiaBLPAw31mtPT8Y9/uWXBP+vF9z3c9A3bVf9RCuMe4P72asnYvyQDXagncZ00+jrHqRjfSEQC0IdIvt00lUJNLhGYleG+xEeXDtKIt88cK2UW7Ik109+V8ptfM+ONpImPIEs0Go+BIv6lfSY9tkIN97nKBkqsRYTXz6dV8wJAEFyZvusHPMpe9cvnPYjwd49u9r8Air72XoPFjN597RVw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by IA5PR12MB999277.namprd12.prod.outlook.com (2603:10b6:208:608::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Tue, 11 Aug
 2026 19:31:54 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0315.011; Tue, 11 Aug 2026
 19:31:54 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH rdma-next 01/15] RDMA/mlx5: Allow optional access flags
 in DM registration
From: Jason Gunthorpe <jgg@nvidia.com>
To: Michael Gur <michaelgur@nvidia.com>
Cc: jgg@ziepe.ca, leon@kernel.org, linux-rdma@vger.kernel.org, 
 netdev@vger.kernel.org, Edward Srouji <edwards@nvidia.com>, 
 Yishai Hadas <yishaih@nvidia.com>, stable@vger.kernel.org, 
 Michael Guralnik <michaelgur@mellanox.com>, 
 Yishai Hadas <yishaih@mellanox.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20260726092943.2880176-2-michaelgur@nvidia.com>
References: <20260726092943.2880176-1-michaelgur@nvidia.com>
 <20260726092943.2880176-2-michaelgur@nvidia.com>
Date: Tue, 11 Aug 2026 16:31:35 -0300
Message-Id: <178647669507.282103.6826631525130998180.b4-review@b4>
X-Mailer: b4 0.17-dev
X-ClientProxiedBy: MN0P220CA0003.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:52e::32) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|IA5PR12MB999277:EE_
X-MS-Office365-Filtering-Correlation-Id: afacd75f-7027-4092-9275-08def7df3087
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|56012099006|11063799006|10067099003|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	9Vzg7gd17z/yuf48CY6hnfsP7dGdKRahoZy1LqsaE2LtAH7KciqF4fsnKR24NDgkE6wWtCBVZop7V+MzsTSjdZMgfgub4F3M8TtyVKDBJDn0MXCF1i2YjMupK6fwURP5sD4k0AMw1OFWQqUewEb9WsvatsfUMcRpnCEqUjfTCtLmOV4ZaTbaHCOucE+Q4QqfkriC6jfHAfQ1cwAnw+42cS/16L4Id1PcK0c4LDvMvu8iyckO+YApcXrE/fFzn3OkGnarv/FZuOJwZ3TaRUq2ujG+61/WRus529MUhA8k5vCVoIm9bQqHh2zOFFFGjr6e1s3Bj/A+FMX6pN7D5dJGQlHuHq3q2IEH+otywhB6OtxdkVDUyMYSd2BvELYx+zSTObyZceDIE2HYTkPGDMU6BXBjbMBHUm4NCdxiQTtb49XwnCFmUKYKyxOPHUNBbMIHUobSC/xonf36cO9OQAe/ChoNDhv0XuydkI4ISgCGz5Cz+VJagv06E+FVD6XJ/49uTKeckhfqhogJbTK033hN4dU8uzHP5EH5+o9cZNX6EmBmIC353GhKEzEssJcZd8yXfy4nPFuCxOaqtYgbHVWBc8adHl4hkEGZtMwywCc47aKrWsulRT4tCXfzBNRWvs3/lJ83sAgFP5NEkI+TgKgMy5RKJNUh3DFt1+d8tqX3Gxw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(56012099006)(11063799006)(10067099003)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YzU1QXAyTDYzTkF5eDVMWncza01yZ0szb0N2V1V6Q2JHaHRuSzZLSkM0VG1N?=
 =?utf-8?B?VUx1dTlSTEJ0dkRxS0ttc1Z6UUdJdFlCeXB3bVNsOU52clVkMGZ0T1lKc3pa?=
 =?utf-8?B?S1pibm1UVzc3Y2xYR1VvbXR1UXBuRDMyN3VpL1E5NFBXZEFtWkhRWU41Wldq?=
 =?utf-8?B?eWJOQWNkUlJvckJKMmc4QWMwQmFKa0cvSFdmU1RkMllhaWNwOVZwVlhJVEJq?=
 =?utf-8?B?SEhGQ0gxdmNScklLYnBHZERuUUM0L01pYXJEc3BVMDdJSTQwV1BNUWZWNnkr?=
 =?utf-8?B?SUxrbzlBL1MwSWxkc0VmL2xOcCtjVFQxdFU5c0ludEpmanZlYXliWjgvME1a?=
 =?utf-8?B?bEJkRTcrVHdpeHQ5WVR2MFVDdHJtbXlyVFhqcldFRGs1VDVWb1BMQnJSSzRx?=
 =?utf-8?B?eDRDakJKbG5zazlLRTZLZ0dVaXp1b0h3ZmlXanFZYTh4c2E5M0VhQVd6Mk1S?=
 =?utf-8?B?TUg3QWFUanhFMWU5dWtzMjJUc2R4RG42M2NiMG52bWZTMzcyVzBuT0NaaXRS?=
 =?utf-8?B?OW9yUmc3RU0rUXI1eFo0Z2JmOUd6ZzJHMGtvTEtBTFBTb3U0Y2RTUmZqV3hI?=
 =?utf-8?B?aHNCUk9IUGNGaDZyVG9pWm9Wa2lRd2xTaTNSMk81QmM1cHhFczhVc0VsaHAz?=
 =?utf-8?B?aTA1WHlWZ001cHlLd1ZlUW1aT3ZsVkZrK1RsWGdLTTN5aDdnbjVNYVhyWm0r?=
 =?utf-8?B?eXF6ZE5pOGdBdzREeWVTdDdXQ2NSQ2hSbksrdi9jcXNFNWV2MWh4V1h5WXhC?=
 =?utf-8?B?NEYrajJJMVpuaWVJLys0SGczNWhNeEpyTkxEUnNqRnJibTZOSldCRVkxeHJm?=
 =?utf-8?B?Y0xRV1FBV2t1M21yVGh4Q2hqSU4xQVJPV3B2QWs2cm0vYVNVQlJlTWEvUU5I?=
 =?utf-8?B?TVJ2NDFuREgrOE5xL1pYV25rNTZ0Rm1wWnZMUDNqUUsvK1o5aG1LcERBejFK?=
 =?utf-8?B?aDh3S2ZNOWVKYW51cU5mZ2h6K2lRSEFvT2lGZ3BGdHNsWXh4ZE1OT1g0R1py?=
 =?utf-8?B?STh5T2dGQ0FXUjM4QVdtK254NDdwem0zUVZQSDVpQ2hZN2FKU3BoSFVWVERx?=
 =?utf-8?B?amZpSlNacEVqY3ZLeEVDZlVubnVxeExNWmxtN0xhMjQ3QzRjbGJQY0NWQ3du?=
 =?utf-8?B?MWR2Q2llOS9VZis0RkpUSHdWWjRzUDNmaUIzQW0wNVEwMXFYdlNGOEt5Wm5P?=
 =?utf-8?B?VFkzcTJabWoyRjdFV3lhN0wvL1NwalBiSUxnemhUWlZka0ViWmN6VS9sWDdv?=
 =?utf-8?B?NU5LcHo1N05yTXFIMlR1eElLZnJ2akRqWWlyZ2Vla1hQcTdVMWhIeXRFNmE0?=
 =?utf-8?B?Q0pHZUdOTnEvVVk3bUlQT04zS25EUStYeE50ZkN6cTJQQXVBUk9abVhmRmpS?=
 =?utf-8?B?T1QvSFh5UzlUN0txc0xwZzhPajRObkFjdWM4bUNZWkR1cjRIK01xSzNPWkN1?=
 =?utf-8?B?NDY4Nk1jZ2dNSFZTdjF5dVlRNFdmM3diZDN4UUpNT3YvMEdxQTBMUzZNb3hu?=
 =?utf-8?B?NndRMWJRN0pjQ1l0WnlPK3FvRW16Wk1KOEZrdnU4SWV1cTNzakNuaDVQc1JY?=
 =?utf-8?B?UzZaMlZ0bUU2WnRmU2lvZTVHd25XNlFvaHBXR2hBbGxKKzIwVnRhaVBISlZa?=
 =?utf-8?B?N05CUGUzMUtrcVd5aHg2b1Z6VkxsMXpIU083VHkrVHY3WlA1d1N5OHBnY1pY?=
 =?utf-8?B?RlV3VHpDRmNFcXNMSGZTYnorSUJzc0VuUndzcllZeTZ5eCtGUXVkYitFSmhM?=
 =?utf-8?B?QmFQL1UxRGREbW5EYXBvU0JKRHVmWmN0WkpjbU9lNzZIYlNiSDlxOFBNTDF4?=
 =?utf-8?B?dkVWS2xBTTExYnlQZ01KWi9MUTZsUVVKekZWNk5LUU40SUZIMFhEUnBQcWdQ?=
 =?utf-8?B?SDNTeStBMWxnMHlUa0JLZkpUM3FhV05uNXh1ZHp2WXFtN1ByalA4N2RCNUJp?=
 =?utf-8?B?alBJV0FrWHM2SUFmY3VGMWdVU2pqNlJKb2lUck5MYzNONXgxQWZBUlFBN0ps?=
 =?utf-8?B?T0xKdFNLa3dRYUZOcW8wSkRrWDJJRWxsT3pxTmhCUVhrallmNFBJTEZuMHRU?=
 =?utf-8?B?N3pORGNwdC9uZGxLSHVOYVUvam5Qam5QY2dTaGRONGh0NU5wcWYxaVEzem1i?=
 =?utf-8?B?R3UzK1lEeGVvMzRoMi9GbWJ1MFJRUkR0VUJhbHJwM3Q5KytOdDNnRnZwa1l6?=
 =?utf-8?B?djE2ZXAxNkRQUnIyQWlQNnU5UU0yUzlmdU5aSWhXUmtzSndnRDBsOWh5aG9U?=
 =?utf-8?B?MC9KNHljQVN5TVBHT2ZaU3NFSjhDRFVSODhNdElpKzI4cVUvMVQ3NDg2VHNm?=
 =?utf-8?B?T0JxZzJiK0ZSWWh2Q2NYOXdPRjNEajNsOUpTSjFHZkpJWWxkZDAvQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afacd75f-7027-4092-9275-08def7df3087
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 19:31:50.1319
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a2/bLZLhKvgASkPP407haCW0ItTUblVsdjDm+D8Mp/tcvZVuQ1MSWebpHZtq6RT6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA5PR12MB999277

On Sun, 26 Jul 2026 12:29:15 +0300, Michael Gur <michaelgur@nvidia.com> wrote:
> The uverbs ABI reserves the optional access flags range as best-effort:
> drivers should accept any flag in this range and treat the actual support
> as opportunistic, never failing registration when an optional flag is
> requested.
> 
> Add the optional access flag to the allow-lists of DM registrations.
> Uverbs users can now request any optional access flag on DM registrations
> and mlx5 will apply the flag's effect on a best-effort basis when
> supported.
> 
> [...]

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

-- 
Jason
