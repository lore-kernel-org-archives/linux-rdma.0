Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011051.outbound.protection.outlook.com [52.101.62.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9725951A15C;
	Mon, 21 Sep 2026 22:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790030352; cv=fail; b=a60eszn3anSj/fFewdSCnTcOQFSxqf7oRHXCaiJDnd+hhZQMOZBnF+VUDXajuDfZinsro8GAGVy7gcYMQDlpBLFuunR4UCYew3gCsjki203E1370Z98XvBiP9194/knSv1zzrxnby64Nn5LiXZEpj/jlVUP2gug60e/EvB1lIEU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790030352; c=relaxed/simple;
	bh=Y37Yshz4BXp1jV5uTNhUrhuI8g1wVDeY8rsekLqF4Ac=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=BVim5dmCvPUFbeeWqheD0v8j3iTWvlq5P7DP1yBuTbdD5GT00FcGvgiQ0inqjT6KB2H+h8iqkUwM+iO48OvHubd00ZvRE0h/LA1MGTe6Us5nQzCjossJ+dyGo1vRtG2gBxp4/aV8mLEWmoV+bEvYRUuLkwtkSk4WloH3wfRFZv0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=odUEEHZE; arc=fail smtp.client-ip=52.101.62.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="odUEEHZE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g235keDuN0zPB/+xPK8l75IrJ3n8ZbbkWZqEsXPwPdiA1AbBOZ1mP8lcLKAjholUER1ukHCUXYOlKWvQROWF6j0OUHRKTMK33Q2by4WmDGNyZfrr2egsgW9WGwTcsO69D+Ron19WrNHHCLYYUciC3aJYAEV9/0DkrMEu+6iZCeSGOXWuPv2rCWBsUYxyheu7sUJfVUMlBWVGeKoIGLt6N6cSLDkXbRvydsONfsqVKdoXj/gXFGhkzXohfkqkHbzNSa5khLaGGPklusNtxPuo37Uo00BPFmYqOrcFEzvlvcKU33G/wx8hKirv8gf+TISR3ML5aFooXW80HZ75qusrUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mKcac8M0FBM+kgAZFXKNgM9IXp5KY1gq+HQFHByACKQ=;
 b=vGnoP3xeBw5s1PazlGQ83Z/MrvVz9VvdYkND//LpDyBouS6es77SzAqf7+feEhNrLv6A5ICrP23Qe0MIq7obHrPxMKVCCNKCkMJrtwxfRnVhfnrW9hIJcH7MDU2E3q8OtEnNqZgkNYOpqPaazygMScCWPSvtG2Mvhgo/K9JoYLz2nvZfMXjS+l7GDzRj0n1P7nXWy+gHUu5s0cRiai28n8DdGAzLkQu0SBKgT1F84wnLwzMBsCH5C2x6xNrlQHNGY8K8f76AQGKrZZhPznEasLGfSwikgmIjAiZdj80OhQJQ+LQalAr5oQ252cvjI3h83BS3lywByY5eMakI1nTTtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mKcac8M0FBM+kgAZFXKNgM9IXp5KY1gq+HQFHByACKQ=;
 b=odUEEHZEeCOQaRTgIztT+fLRRIDNLesZrmDy46qB3XsjmlIINw0sllrMvcYJT+xBQB2ps+bqOUPoZ3X+Z+uWOKnUUJtwOEcCY/+msG0d/afgfCPb7SqxiF8a0AH8/KUmh6KmYGMfoe/xYbznWn4+WOx4w4fX9IMMyPd1BNpUC7J0G4t6mDzCo5L48l/L4SfQwkP4KwvsP3jxdBZ/gB2la5dK3sz1jEFWrsvQY3bc1OHLJ1AsQi68LM0/ZzG3QQo1EHDEjw6gMOdHtoNdq0zIXowXI5Iu+dcplXzR+k3PfC+mdOcWIwmmCRJfZZM8uqtQrT4q+s5Ws8McjPdeAsYw/A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by LV3PR12MB9144.namprd12.prod.outlook.com
 (2603:10b6:408:19d::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 22:38:58 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 22:38:57 +0000
Date: Mon, 21 Sep 2026 19:38:56 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: David Matlack <dmatlack@google.com>
Cc: sashiko-reviews@lists.linux.dev, kvm@vger.kernel.org,
	linux-rdma@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v6 06/10] vfio: selftests: Allow drivers to specify
 required region size
Message-ID: <20260921223856.GC1507824@nvidia.com>
References: <6-v6-8af36cf7b73f+e2-mlx5st_jgg@nvidia.com>
 <20260917235245.CAAE41F00898@smtp.kernel.org>
 <20260918115217.GA11142@nvidia.com>
 <CALzav=f4NTb4Csn2BoK5kk=MckFRvbVnOdO9yiCz8MLXdRMPOg@mail.gmail.com>
 <20260918200000.GB11142@nvidia.com>
 <arGYLavnr25ZSyuw@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arGYLavnr25ZSyuw@google.com>
X-ClientProxiedBy: DM6PR08CA0048.namprd08.prod.outlook.com
 (2603:10b6:5:1e0::22) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|LV3PR12MB9144:EE_
X-MS-Office365-Filtering-Correlation-Id: cef58d81-5151-4e37-7d56-08df18311fe7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|56012099006|10067099003|4143699003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	wWW64n3ooi3lmd9vRS86NuzVdgf0x7+OEgJkMGHC8m0XzKzXniJyqhRrvBIQH6rPkr0/t7lgTrBA/DrH6OOBU0Mcp3vemfGnQDCXMkdTW+lK/iFJwx3QWbaXEuGlgfV2Lu6pPbjta480MFE5EPHFpRgswkuw7uI8qqxpQFnCMITGxbv+g3qF6v3HGgWVLlpYX8Nlhh2lvLpPqI4nINgQdY06kMY+IVeNMocrOBLTXkNJwDo4dEff4XVx3Q/5sk/F05F1DNy+iJxiVq3bhBHoMX0donujzyRyjMNM6c8ydvU4fP+Cd7SObTue9Al+P/QkFxaBPv/wrXYPCKIwBVuplN39qrWcbe7FkNk6EhpBDWDy8/HRMkWHlQzGzc4l9l5PDHvjZNVY59Cxzjh7+YAspHE2bru7vsHERkJi55K37OAfIA4PNHAna7Kpd7SMYM3qRhhos/vejYxo7MWpVOWS/6iQ2qP2M/zArtoHsDIDspSz67KRHyi7Xh+1hTUfkZ7tyizV5yzVrf0eVRWCOdO6U1YOISeg5b3XrfMvS3zZMcqRnamMH8EkW9ookC2DuhIHdHb8W1C0ci/K7cOiBTGLpErrfBEn8XPW6Kc/SiUH1UgZ1bHYTFgmLzX7N+I2HXRLcmucV/ctuz/XTUmyYwk1tg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(56012099006)(10067099003)(4143699003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0gkjXKPijW+kaG3h0h9dnLfNCm0br5PD07qVLoMVSN6GWijgC0IiO+sK/Oov?=
 =?us-ascii?Q?bN5pSCkPz1xRlfGPE6KY5OM3rR/I/SYdAtXYh44q6wyl2FZeKi3Lf8vvhdHk?=
 =?us-ascii?Q?1m8iqDyJ9IeG1VjJAcEHUbCJ7dx3tAk3iz8RmqBInF9B5/9tqscxAh/CrqxY?=
 =?us-ascii?Q?50Mqh9mZurUEPw6BBDf3e9jPVgbJoARaYZMSvKQQVxZNt/JXBu2FKiUBijMX?=
 =?us-ascii?Q?8Qn0/ebaRMBYgcfDo5WmpDhnhgF1AtH4nTa3qOcCYopct4+C9wAvtNecidX8?=
 =?us-ascii?Q?dNIQVg0+yMQi+4OZWyi2lrnQxQn701hjP0pu+hTA1TnLJh4a6mdqM+uWeDNG?=
 =?us-ascii?Q?E7ycJ4QOS91DtDqIrMNb7sETVw4Y1n1QOLEVTE8BVMHWpar4hp64aHcX1sTI?=
 =?us-ascii?Q?UYNEbz3nkhfHkl1xwebjCv5r56NBCd7YCJPUCOf3Kz6XAdD7NSPKJc0KRQDk?=
 =?us-ascii?Q?dO2FDFISPYOa5GZQRU9LndUZdDnJuPe8hPciuWfubLAl0Wq/fyXZTY9oukW7?=
 =?us-ascii?Q?Y9XLXoHWQNG7iHEb2NaeTJABLTEDWJ+rq401bbwn8TvwmME72RxYxqjTFTe4?=
 =?us-ascii?Q?8lWxFMHhZVrhI1jIkN2QhViQkkva8Yphx1mEw6Jcrvbx3rv8QzXt2W3MFu6x?=
 =?us-ascii?Q?CPMufLCLH/dTaqpdhv0FQy7JuB4lTQrKi0e8ErJQoPaQ6K4Zz97cyR2q2dr7?=
 =?us-ascii?Q?RiidXSZ+XEsjRUgydVWANjbdqX2hNkX5plbBEYs+FEjcVzZd6LyxqHWKi9jj?=
 =?us-ascii?Q?yVn1y5rt3RseqgDaFefG8cb4a5i1hxxPSPt9K4b83D/O6SImRaZLne0reIVt?=
 =?us-ascii?Q?8P6Oep4qK9vqT16TtHXc37rBK/ffRrl2zZVLGSs6jJHOHbAKjUPuisNAghJd?=
 =?us-ascii?Q?IuTkdFFHNBmqhb7AIxdjkw6n2xS3+S8FHKQ+tHDNii8t8Y+SZrbT176j524J?=
 =?us-ascii?Q?zYHm5yDuNZJzt064rCdVqDrznEkP5lHGCYJhdf63b9Io5FLctB200xH+Q/80?=
 =?us-ascii?Q?es8a9kuinxyfpay04HvsWMxCY4i5wJm46mgBNxw/nFLG2IalRIWAp9BQdVVd?=
 =?us-ascii?Q?fkdZ2Fm3UxCRLYy3AhVxxA+JY+N7LjBjlIxKrx0EU6NNkHQdLlKue0KMCjvl?=
 =?us-ascii?Q?Qbe0oT/ShmbYg975OVS/zkKZadw5iMJYp6C2uLR8GVqhsGDJADoOr8S+y+Rb?=
 =?us-ascii?Q?ff0aAJ32dEiXNOOe+dEIasDhEes85JJYxsNYRoElDGdVEK4K11pF9dMjPp8u?=
 =?us-ascii?Q?V56B3pt7D0gRAnetO+5+F1DGjP7WkNbbYhJlnsjcEApQsVoDbRu9Zc1dlyWm?=
 =?us-ascii?Q?vMiRWBnrPNTWJaIsfg+AVkTr6WFQQg8FlxPK5nROQn68qsKu1o7Xy4raAjfM?=
 =?us-ascii?Q?FUXncpDhx/05nRvykciXhftPOyCqqD7O5GREd1ln0oNjGnvyBN8RMh9LwxWP?=
 =?us-ascii?Q?3Ob/rEohnUHe1XhdyBxACbRx5w/V3/i+RG/9LuI6iqmkMaaNlBX/n/cNycu4?=
 =?us-ascii?Q?ofXgXONYOOuJSYYlWB2bJ0gYMcrs7mMVawxxH1+3YPV9HUpZEYSA+veU6rqw?=
 =?us-ascii?Q?mjmLLbKIh1qeNkFFGXO2mELGWerGiRIF8ZdQ9wbH92JCXcunu3PKtVz8wj2z?=
 =?us-ascii?Q?yU3HQo28IJJWdTtHD75FxJjx62eqkgiXq/Jwt7WpKCJhgNmB64tpyRQpDlWv?=
 =?us-ascii?Q?LNXerm+2MobLDImL0M5q8tbAWu3qUppbjT0jRtYfR91UUo8k?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cef58d81-5151-4e37-7d56-08df18311fe7
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 22:38:57.8357
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YuR7BW6P5aOK7NLixpDeGdwT1OaOjZDCAP/wb/+f8Fwz/p6JBE51dcI+I+tkKFzZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9144

On Mon, Sep 21, 2026 at 08:48:45PM +0000, David Matlack wrote:

> > I don't have an arm system or userspace cross compiler to test it with
> > though..
> 
> Wait, really?

Yeah, I don't really do anything :P

> I can help with building and running the KVM/arm64
> selftests if that's what you need.

I borrowed a system and I think it is OK, but it is such a pita to
make kselftest-all compile clean it is hard to say. 0-day has not
complained and it has been there for the weekend too.
 
> > Are we good on everything else, can Alex pick it up after I fix this?
> 
> Yes all good from my pov after we address this feedback. I am no longer
> seeing failures[1] when using the IGB driver with this series applied.

Great thanks lets be done then

Jason
