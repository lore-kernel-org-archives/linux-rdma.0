Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012059.outbound.protection.outlook.com [52.101.53.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692E13ACEF2;
	Tue, 11 Aug 2026 19:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786476722; cv=fail; b=q///qdGdOCC3/Plx4jDmOKMwN6t5UZj2E30VASxqNSKr7IMC2ccBdMTBAG8POpBL1wdi1aTOc/AA2mncnrNNk9dIIlUkgstTmR+T4PktEd/hX5FnmTFPT/wQ4YNdtrp4EKH+5P9ps2gst+dnnAXEuGdpieZLGfkk7QrYfrM2nUk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786476722; c=relaxed/simple;
	bh=jTyWI8Tw152R4wfecZpCBKymMlon03wxqKy4696LgHM=;
	h=Content-Type:Subject:From:To:Cc:In-Reply-To:References:Date:
	 Message-Id:MIME-Version; b=C7lw9Bon7RbY4xoo54Tktimt3a+F2sdkmzB7hvXm9BSGtL4vE+3zD/AZ51kaOBenXHjf35KHJ8g3Zi1hO0M/yATljpes1cakUFE6rJInGSsGl8pN8FRA54+rZ9q+M5gHPgMqTLfAnTARvJljMOQMB0t75XtH9kv1jlRq3sXbwm8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=T2Q7G1nU; arc=fail smtp.client-ip=52.101.53.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="T2Q7G1nU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rb83ExVoD2D2jG3WgAAVI38YjjgX4ftv5K2hC12T+Zpjm4N2vqhW2LawXN8DbklxVHkrX8eUwaiMwsKNrD40dN7xsC4PqyTovDNb5T7/oftqzx5H06UVESk+5n9igg+hXhkC97NlQRHqDAmqTJGyAP8zwKO3HFWrZO8SsjNspNZqVBeBx/PGZGUkxFdtnWhKH9EPEnBod/UUhJgZS9TZm0R04kCuG/VEC6pdben+swILFyczLAryStcN4XUYy5T3Gynbx/KYgPnaBkIR2j0/kI9NtB7ty/Dfg0QB4lS3edbpbe+Nh2vRRk5yLJ7SeaLm8OH/ibfyhfHWwShLCPq6Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WfaPr7bjH4OwqYImQy3YNu/tLd+nYUJ98/z6CX57HSw=;
 b=jeKAUTsrpK/PK98v+3/hgWHrGIpAg0Hv1OljYWf7UEQH7MQgvrz8R+ub1hg3c3WeuR5SMR2SMjhYSrDIuryKIqMiQB72IzlOgU5r/f+ApjhgEE7rR6/em33RH74NMDJRTaAH1kB3Uq0vA8rJgcydjTmbB+le2hoezK78fL2iHHpLVEb01YN5pdwP2JBkUzMXqX9LtJc6UINuLxgMwwucrUDQs32H2sqh0fcG13t5JmXZONyiibkOoXdcGNWyArFWQFGAWDyvpyBTX+CPfx8441v8uqFrspKGTGTCfU3k2c6sVgBg7bV/ePPopovl44bEgeSSdLmfrcrxxGDNp9prOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WfaPr7bjH4OwqYImQy3YNu/tLd+nYUJ98/z6CX57HSw=;
 b=T2Q7G1nUPF2qcaxNiEM2JitKOJsjreSVfDZlENBJ7Om+yNcD+HLIb3N5s79fsT/krOHgt1IyWZc4PmQys0DOOKbqOrMPFzNNRQ49z3T14XzZvGMeeD7ezRmPau/W/8J2YU2nl+prxY1747nuG5moGZrl5VUEKJaZ/mqmyAW7Bz23bYD0beyC/m2uc/9yUR6FX5x9ilKEm26c3EF2eseRh7YpU2nxd4gEqiSG6nQRTXyZv6YBTzQ/XeW0ReAEiyiv+dO8O+Qcz9WBqCsa0zvZln/4kd/8oxvHi9gbHCiMY3WfEE+KcU3f6QksaQvVlwM0ja/ogdmpORY+BiDUV7jlzA==
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
Subject: Re: [PATCH rdma-next 12/15] RDMA/mlx5: Converge UMR access-flag
 cap checks
From: Jason Gunthorpe <jgg@nvidia.com>
To: Michael Gur <michaelgur@nvidia.com>
Cc: jgg@ziepe.ca, leon@kernel.org, linux-rdma@vger.kernel.org, 
 netdev@vger.kernel.org, Edward Srouji <edwards@nvidia.com>, 
 Yishai Hadas <yishaih@nvidia.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20260726092943.2880176-13-michaelgur@nvidia.com>
References: <20260726092943.2880176-1-michaelgur@nvidia.com>
 <20260726092943.2880176-13-michaelgur@nvidia.com>
Date: Tue, 11 Aug 2026 16:31:35 -0300
Message-Id: <178647669517.282103.4464513408245233032.b4-review@b4>
X-Mailer: b4 0.17-dev
X-ClientProxiedBy: CH0PR03CA0071.namprd03.prod.outlook.com
 (2603:10b6:610:cc::16) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|IA5PR12MB999277:EE_
X-MS-Office365-Filtering-Correlation-Id: 74c5f198-f56c-4e50-aa0f-08def7df307e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|56012099006|11063799006|10067099003|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	BmQqEXUlI2SDstorrrV/tjdW4XqiPp27vB68CoBvq98eOyisGBRRdhvt8tSf8q0LQGAUGOmXS2+HvBINWqAj1QvvEjL1IbMfTjk5gK2Z3dYeRSQNydGJ1LwZCtkqYqIAhKsR68mXF80J8E4evstaJ6gmko7uKsl/sqaCGxwNp73/pGt+FUkVwBgZxaiKyWixMz8N3oF+VPTgQcv1DSYTx+X679MMVnbLOqq1+PNn57W/ARv8W7xGfxPzNteKb5ESAICB07iHSks4PasHlLahn9J0BlQi8aAJd23UZbXe04u1QzUyBcU7YhN4gE6R0rJ90xx6vB5hg0ceSCNv+Ff3e4xcbBaSe54G/tkweDjGT19OjbI7itXWh5UQuJTbdUSfWlT5kmfMT+u+WolNBGisrYmf+JZlKcmrQEvgKX1qMcF543TrT1Bi9BSyHVhh+UtcWAy5Zx0mMmkfLwl2qlajPjI7EwzX/xrKCU4fV96scQ+xBBHeris/byjEVbk6MzfKbuohbEZhxV35kXMOiD2EkBXfp2Ado+/C+cRsoCY7njaR4j62+08mgaSvqkN/JIyLUnDHBqPljE0RgDVpw1NhjAlhR13+ifgZj6NcSrIPpMEQyEJ/zToyOQBeZpfiRutstaofBRWZsxUNDZVhlVS9DhG2R0uHioEUjOxE8ELwOww=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(56012099006)(11063799006)(10067099003)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SU9ScDFZK0xxMXhyVHhmZmo3ZWQvSHFXTGE3dHRRZTUyZlIyYm5BN2wreGZU?=
 =?utf-8?B?NkUrRHh6V3ZtZ2dxOU8wQWg1MDU3QndMVmo3bDRVbmRJZjRrU1hidWhKOHF0?=
 =?utf-8?B?TmxmT3AwWDcwU0tvbW4zeXNwdHJOeG0wbXJvdHZuYjVoMWpwU1Y5c2xLT1N4?=
 =?utf-8?B?QjAraEhSRWJlZ3R6azhTU29TNlpJWVRIbFRVb2NXOUJBaEI1K2kzd0k3V05G?=
 =?utf-8?B?Uys1dXpPaTdROXdleGJuTlBEdFNqSkRKbzdYc1pMS08xNzI5Tno2YlRNeWho?=
 =?utf-8?B?VjRCNWNCYWdUelhNZ1phaEszNEZqMnhES2VqS1dFMmpkVU55WWhnUmRWYm1k?=
 =?utf-8?B?TGdnYlVxV0puWkFvVXpia0w1ZENJUURkNy9TVytsMHBGWndZL3hLRHlPSFVP?=
 =?utf-8?B?dVhUSG11c0ZKWjNlR2dxZGcyUVpNcG9udkpMWE9QcWpkdWhLcEV5TDdUUGls?=
 =?utf-8?B?R0VRKzZVWityc2NHUm1zUzljQ1Q2WjJ3YzA2N3pMZHY1N0Q5bVdzNFBnYjg2?=
 =?utf-8?B?aXdlekJRNmZFb3c3MnlJWmQvWlVTSHN3b3VLR3gvbndMOG94MXFoSllzOEJG?=
 =?utf-8?B?THQyblN5VzZIWStxMzZteTk1aERPOXJTVHRJMmRnU05UVVhTYnlhcHpYazNJ?=
 =?utf-8?B?cythcW4xMlNmTEhXOHQ4MnlaOGJuN1pRWEhYNEF1Y3dnVkEyd0FlTEZuY1Ay?=
 =?utf-8?B?WU9VNnR4dXAxUHFuQmV3VVM2OGE2YUw2Q1NrRTZWZ3Y5aUN2TjNuMDNuazZk?=
 =?utf-8?B?Zm0xTGE3N0RCRjRmSktuUFd6SlgwWWdSVk5QZXZ5TDU4ZWhNbXpNa1F6YzJp?=
 =?utf-8?B?MURJVTNlc2J2QVZuVDhBbjNETlBRTkRabzZiYzF1TnlvNDRCVWhwVkw2WHZu?=
 =?utf-8?B?MmxTcXRXM0JueE8vWlJuTkIzQmdzTmIwVitwU2MvajR6WGZ5Vis4ekN5TTBq?=
 =?utf-8?B?eGJUTXlRdHlWVUFVb3M0aDZRV09kNVdIeEZ0dWhFTjFoUkxRRyttSzJaYUk2?=
 =?utf-8?B?bmRoUitZemQxWUhPcDVqdk5mRjJLS2N1UUJ5SlB6Q3JENWo2N0IvaGNxaThC?=
 =?utf-8?B?SCtGdURmR3laRUpiYXpseGRFcEMxZWs0c09oeDUwV3RyenppWFh6S2JqYWRw?=
 =?utf-8?B?bWhvaWVHcGVQMWxIRWFKbVBDZTcvdXpuWW9VL2RmSklzWTZBMHFJWXp0VHo4?=
 =?utf-8?B?ckZucDlUWFN6WFRiVGNyTW9TYUNPaTJkNVlHQkNjYkg0NnFsRFZWNFhkVTZJ?=
 =?utf-8?B?RGcxa3ovdHFNT2lKVnZmODFBY1NMVnc0ZW5hTjZJaVZ5NVE2aVJ2bEszblZp?=
 =?utf-8?B?alpwZTdsaktEaEdrRVNZMEZ5MVlxY1hGV3k2Qk5mR0NPRzdNeEN1NVc1QnFR?=
 =?utf-8?B?anVoQ3lTRDUxNlZHZTcyOVJRcWVhYnlZQmlZcWpyOVN6eldLenNjSXozR0c4?=
 =?utf-8?B?bnl6RnR2L2VxOThhSUtLY2t6VmQ2WFh6a2xyV3FNMXZMTy94RXZQUWkxZWVh?=
 =?utf-8?B?bThOb0tGSUw4Nmhrb25JUVhDcDBmVlZ2ckUvcXN5dlpQejRNVkw5eURXbzdv?=
 =?utf-8?B?V2FHYzNJOXZwOWQrV0hWcmIrZForbXVFdWlnVnRXSThLWExEZTJob3FETURz?=
 =?utf-8?B?OU9mQ1NhQlVGNm42bFc4blNXQ054Y3orWlgrNkxyMmZ0TGlma0I1cHlFTUFm?=
 =?utf-8?B?L201c0NHT3VqSUZ6TUx5Y0t0K0M3WVMvMG1GaGxsUE95cGFqWFBhcFNiNUNk?=
 =?utf-8?B?VjU2bStTTnNIK3MwTEMySnFrZ0tIZm9MWmI5UkZoZFFRK3BRVVBrNEdrSXhq?=
 =?utf-8?B?RmdCbWlLUUlqbDRIZ1JpbmJ4MTExY21pN0J6RjBzd1FKbklBZHlxQllxWEVw?=
 =?utf-8?B?aGN4RmtoYTAxd0tnVlZtTmtZNittQW1aMk1iN3JnQ2JrdnV6NU1PNmpPUWNM?=
 =?utf-8?B?K1lVRERSZDVPc1kycGRCbUthTjVsa01zMHpqZWJ0blBaaWVoWG5oMU83dVVs?=
 =?utf-8?B?UUxZMGhLV2NkKzMvQjQ3b01ENHBneS95bHg0Nk9PQitvdnA5eDkwOEdiQjBz?=
 =?utf-8?B?czZneEZMa0RhbGVZdjNxRXdmVlp0cENyTXluMWdFbWFCTU15d0NZR3NMT2E0?=
 =?utf-8?B?aDVzSnduMjJyeE1DOWxQQmF1YUIrb2o2MDJ5aE83Tjc3YTk2ZE1ZY1pTVTNW?=
 =?utf-8?B?LzEwbDRNc1dhNGNDc2dDKzVtZXJQQWMyWlRtaGdrcjFhSWJEbk80K3B5UDlj?=
 =?utf-8?B?Yng0QldPVjcrRXcvOVMvNnp0cFNqOXpibmJtSFdhRnozcHdCemwrdDBLaVhG?=
 =?utf-8?B?d3BkM0ZUMzRkODVzYXh5TzRMKzhoT25zZ3ZZaUpVa0VwbG04VkJJZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74c5f198-f56c-4e50-aa0f-08def7df307e
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 19:31:49.9417
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vr84ePo8g7MIYZ8yeUobRPWKmKp9Kw/+KtEKeRxbLW0UL78JuXRo0DCfOBkvqE6s
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA5PR12MB999277

On Sun, 26 Jul 2026 12:29:26 +0300, Michael Gur <michaelgur@nvidia.com> wrote:
> Move the UMR cap check from both MR registration and UMR paths to a
> single helper checking the access flags non-modifiable by UMR.
> 
> No behavior change for the current flag set.
> Converge to prevent code duplication when adding support to new access
> flags that are not modifiable by UMR, like the new Unordered access flag
> added in following patches.
> 
> [...]

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

-- 
Jason
