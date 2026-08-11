Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011021.outbound.protection.outlook.com [40.93.194.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496FA4772BD;
	Tue, 11 Aug 2026 19:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786476741; cv=fail; b=Y2xId9ulsvVc1CRecWAKR6I3WTKQ/8jWRIyBuOvzSOHOXiG1KGL6YafXQCuQovioKooAuDToWUIJH08fbp61ib5TxatCF3oTcQi396JtBPtIS4jSRfY5aBYKDGJGCA36wE2r5IDFueURGMq8HS/pcZZt/ZIJlf9MXdOZ1/XP6sY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786476741; c=relaxed/simple;
	bh=dyfybXXIqhbwwnjo4XOjCKM72Ee2CDGWlgnvTbjs4OY=;
	h=Content-Type:Subject:From:To:Cc:In-Reply-To:References:Date:
	 Message-Id:MIME-Version; b=bTIcvr0SlZxfx7DHQ5TtRIyjPUFO3Gmgcmg7UqMQgelWu3LkGPLQzUOJolFtXadY6hjvdhP1n/UFt20uyYbwYk/Pnr6AaowP8F9ZJPucwiHwVAF8U1hhC7TLlHTOR3FE67/gn32PJOEzA86AUPyWw+g1+5ZFLnfwbDVBhC3cBIs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YD8k3hDq; arc=fail smtp.client-ip=40.93.194.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YD8k3hDq"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FiTCjMKNC/7i9aiRdk1heOPJhODg2xmLpGL/eqNrccxjgkajkdsL2D0atrB2bgSlJhepTe6MO4MRWVXLWkLhNdx1p5Nw2MKfIKHkvIVsc7axNUEAsqsjWjXrbnjxFc+UZ9swjAC7yWTz4NMlT8p5AEnREnyB/F2udzcsV1HL01qdvAzHO131svfHhBocLIzZQWMk1TnYGk9T/M1y3MIHI9nDDv/Y6O/N6uUltvlehs+wOg5McmTKWvTk2gpcS3VR3tXEE7GPd2iw6g6m5Ej6bi1qd2754leJvD5idGBrYQ43IcW1kx7j6kr+kUt5hlvAOjl39ClUx+oToF1OAn4iaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N0hVGneZNz9dP8J5N7mi0nLExZ+76Qug6je0MhQLtd4=;
 b=hZi/lqm0L4hxwFyzT5aqB3OHTBppppPgBAsQYDNauZ3CgJ4Iicdyom5kCdBZhJhIlLF/Wfv9Ta/NasdtCVZkVZZjwMdM8/D7c1Q6MV8cUwuv4M4Rxf4zQF2cy311Uzi8Bevhb4/xxZor8eiycMdWrugBC6lUlyEtuGO/s2hzPr9B4NEXxo226+crg94MMBKZ9mjkK1cL2kF55ksoPqEQt1RF2GD7GUrapazIak72jlbYBcJbxGiKqpqXNQ+bUaftU+vxmxrmn55EZ3XOkxf1eTvLGaxNjIZJ7kRsBSTJERC3aOLSRH4MN1XAsQSw8rXOvjEz+brl9ouBvpACUVZwlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N0hVGneZNz9dP8J5N7mi0nLExZ+76Qug6je0MhQLtd4=;
 b=YD8k3hDqsuiA3SbCQub/G/NB4Af/yar6svMOr8bD+zqHW2K0VszbbvdtDWUTEI33XYy3bjB8JV07WGYyk1iE1mBvcXwD7TG3GZKFhdmJtKNk1M+cyp0RLKJyXpf47XmfQng4VnneJ2vVXavFAztJOiWVIsMcpAhq+ou+UmC12ZnyoppqtyRVTGW436BbybMY1+XvnYe2HDLYhBt2GAgu/xNaP3tF+k0n4BlJmFW8gzKSgDwH98dCjzfjPPZi+3lZL923n7YHjLOcWETp/AUH1yA8GwMoExciLZl3CCEpHYjJ8a7cAvFx9oWHWRxSrudPEGSb7dPp/mJEFOuXDjQ9Qw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by MW4PR12MB7238.namprd12.prod.outlook.com (2603:10b6:303:229::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Tue, 11 Aug
 2026 19:31:51 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0315.011; Tue, 11 Aug 2026
 19:31:51 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH rdma-next 02/15] RDMA/mlx5: Allow optional access flags
 in DEVX UMEM registration
From: Jason Gunthorpe <jgg@nvidia.com>
To: Michael Gur <michaelgur@nvidia.com>
Cc: jgg@ziepe.ca, leon@kernel.org, linux-rdma@vger.kernel.org, 
 netdev@vger.kernel.org, Edward Srouji <edwards@nvidia.com>, 
 Yishai Hadas <yishaih@nvidia.com>, stable@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260726092943.2880176-3-michaelgur@nvidia.com>
References: <20260726092943.2880176-1-michaelgur@nvidia.com>
 <20260726092943.2880176-3-michaelgur@nvidia.com>
Date: Tue, 11 Aug 2026 16:31:35 -0300
Message-Id: <178647669508.282103.12699636348409047133.b4-review@b4>
X-Mailer: b4 0.17-dev
X-ClientProxiedBy: MN0P220CA0016.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:52e::26) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|MW4PR12MB7238:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c467437-2489-4ea1-a314-08def7df2faa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|11063799006|56012099006|10067099003|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Vu4XlTU6ah9B7Ac5Me0fXPM8tXbdYC5srZNJCDgSjPYrBUjw8Ys4txE5ac4KXQWUj83C8PU1oAu/0eCEIxzkBD2ehbmyTSKtKf0SZdU8aF/2F0aIOT4lEaybLLLvAJJLbXS8R2KSoy8QLpwlWqyLxH+qmp0m0VhkWaWUy9glB0BcS7SnRB+MYwNooVjKLJTESWq41ZkIfebH0ZSECsYbVQlcovYWhmqKGlVHneYHoX1Nry6At2L6bSAEYNvsGZNJWMW4tnJ4IoIoPZ7114gUK1MVtMiTALEmQo6HoX4WOmkUAp8uyQk3QK3Ya4LslS28uyuQJcNhcRDZMJO3eXphJOmzK1blBXAso2WGG8typ1Etd8tbSeVuMOslXeTax/ADU2Q6aftEjlBkTciHrhCIK32SFsoHkbnAj1t6URyHMEJ0eCYuelcbgB0DTubeHWMm9YQEJ+Ku3CxD2k3RUigtjQ2vxt792J5UAXkTX4M5+3DZSHiirDFDKW6LyedThINk5qSYyOEhbJNN3Nd2NuNkPuTZ8+JPfajRwqcAUFeUozF3/piYHnCBgppzHbQE/DPpv6/L1ULUTX71JRrlBYG1EcAzVOxrHombJ34TMPnyXpcSWfoa4AQqiHnWlpNG/2nqMG6RoT3dTsi+eXPRuTYTvuuK44nxIh+eqJN8z/cWzYo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(11063799006)(56012099006)(10067099003)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WnowUC9lMldZS29uVTc1bW83R3U4dXFYd2djUkpaMlFWbTV2MktZVzBPNW0x?=
 =?utf-8?B?VlFUcC8wditUeldFOHE5a0tWeWxJclJzeHBodTJWcE9oRFJValZ3aXZUTHlm?=
 =?utf-8?B?OU4waW9IdXViYnhBeStCMDBnSEdxenQ2SjZUQ2dJMWdmbTd5MTFDczlEdW1a?=
 =?utf-8?B?aUwzVGtyTE1zRU9wcmJkQXF0aThOY050ZVluN1dXOVdmVmZpY2hlS0xqUGdN?=
 =?utf-8?B?aUJla0g3OENuSjlsTS9LWTcwQ0ZyZUUwV0tjeTNHL2hMaGI3NjBUTzk4SGlx?=
 =?utf-8?B?TWVxK1kxL2RndUszK1dNN3FSZHRiYmxjTDBoSXJraTBHWUVoalI3cWhjZ2xC?=
 =?utf-8?B?YVFXbk5nVEpzN1Z5d2s5S1VWb3Z3MGFHY0lJeXRtNjBselB0RWx5ZjBuUHN4?=
 =?utf-8?B?TzRuK1JDVmtXcDM1SG9INklvMHlhREg3STFtZjQvV244WEdWUVRJZ3RsQ21k?=
 =?utf-8?B?bXArV0dzLzlvTnhVekpHZkZKRjAva3NNUkFVdzhTbU9UMUJlNVBxZFRXWWVR?=
 =?utf-8?B?TWdtdnZVSVJuQ3hrVVhEYlZBWWFEVHV3TWtUbjBiVy9sYkxEelJyM0g0TUp2?=
 =?utf-8?B?UWNRYlkvVDVoWjRpeDZuWk1WK0lRbHg1RFgxSDhkcmpqYlA5ZWxlc0FKNGhU?=
 =?utf-8?B?WTNsdjdyZmdmVko1ck5BdnloZnF5TDlUcVN6NkRCOGc2TmZuajFIQlJYZUhD?=
 =?utf-8?B?YTM0Mk5xbEgyeXJpak1GSTNTQWY0SFJRMVFEMWF5WnhtR3paNndSaUFyK25t?=
 =?utf-8?B?eitVbXJoQzIwZ2UrV2dGL1JIdXg2VTVSRk8vdFpEcGVOZWtYUEhjdC9SZ3hI?=
 =?utf-8?B?Y3UxK2xOaGFiQ0pZWnZZd3NreHNXS3laeS9pK3VDcUI5a2tDUzVOYlMrcS9h?=
 =?utf-8?B?UFp0d0l1YmtGTlNtYWI4dUQrMHZhZzF3NU5Pek5iRTZJcXFlRDhucXYrN1BR?=
 =?utf-8?B?UlgvNHloc0RteExNcGtvempMRWROUFByNlVpRXoxeU1lV2NjWGNTUDJDWm5u?=
 =?utf-8?B?SGEwYndHK0ZXeHN3ZlVnQ0hMNGhQMEk4bUsxOXBmTTROUFp4NFJFTE13cGtX?=
 =?utf-8?B?TTRWa3hFcWxtM0h1R2l5MERVZUg3aFpib21MTFlVbXA1a3hLcGdkcWJRVXBS?=
 =?utf-8?B?Tk82V0liZlNqT3NCL3djYVllakxQVUEweTlkOW9vQ2JOVExFU0FGaE5WUzVV?=
 =?utf-8?B?aC9YeUl6aHJtck1XbjFzd0xoYWlnUTE2bEVjY2huVXpMYUVVVGVFZmpMRnJ4?=
 =?utf-8?B?UG02NWNMOHRqbUZQMlI3TWRVL2ZUN1o2M2tYelRoNXlmZGtPclVYb1hBRG01?=
 =?utf-8?B?TndaNzMyUFh6eXJoSlh3YXFNaktEb3kvcExWWU5GQU85K2FHSWZaZzBQQ3Nx?=
 =?utf-8?B?Z09vbkNpVTUzcUtHbkNScVJpMGU5RjZQeC9qNWFLQVd3M0lmMmZ1d1FNS25V?=
 =?utf-8?B?RGplRmhjMGVyNytBTExrdzR0MjZwOUpwVjZJRGhhVFBCeFM1cG5HTUREVmRN?=
 =?utf-8?B?T3dzYXZaSFJ4MzhINXlOSXU4Tis5RjVYdXVWVEZIamlXbEllK21VKzd4dk9M?=
 =?utf-8?B?cFJHMkhYamJVRWs3QllHMjZ4QjAvcVVaak8vdFkxWEYvM3dFWWZNTDRhQk9p?=
 =?utf-8?B?NFRYSXR6NVV3aThwTVJtTlYxMUJ3RldlOExWaVh4amxGckV1Z3g5ZjJndkZq?=
 =?utf-8?B?dmNuQzRzcEVzbGZsNWZPdGNKNGVFRmNRR1R1b2NKTmV6MUZBWkZvQnNoQ1hs?=
 =?utf-8?B?MTBQTTFNRHd2ZGVQOS9Ic1VtV3JFeFdZRU5BU1RNaks4VmZ6TGZ6eDdCOVd2?=
 =?utf-8?B?SGxXSEcyZmRucnRPMksrTWR1clJRdlIremJIRUlnV04vRVppRzliRS9IblJi?=
 =?utf-8?B?ZDFwQXl1N1dGSzlyOHpFVFRlU0h0OVFla2RXbExqdURWMDd2MEYyZDFNNW1P?=
 =?utf-8?B?blo2RlQ1Q2ZSWHpWRm9KUkNxcWp1VHpqalFnMXl5aFRjODh2MkNmMHhTOS9h?=
 =?utf-8?B?ZTNoYkpLbzBxcjNoTDhsODd4R2ZlNGl4d0FhN0FjMytIWThFZm42em9BeGhK?=
 =?utf-8?B?WHBqT1EyUWZEVzJxa2hic3BzK2RpYm1mbW1oVmVnVHRjT3RPNnhVZHdtOWJO?=
 =?utf-8?B?QW1QU0lwNE44SEl4L2d6bGlIMUlGSTZhLzZxeU1KYzJWY2wremJBY2tacTRz?=
 =?utf-8?B?ZGJiTVZQMW96QWZzOVQ0WFVBV3lWRFdFdk9qSUtVOTgvZkg2Zy9YdHNRWkcx?=
 =?utf-8?B?b005dlJuTGtab1czZDVHRi8zL0FpcGhsbVpQTzNHVkhoM2lqeW9hSXU1WXhL?=
 =?utf-8?B?S2U2Z0FmR3c0ZGVtWk5ta0JDY282TFEwREM1UkV0Q3NoSXpiYnY5UT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c467437-2489-4ea1-a314-08def7df2faa
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 19:31:48.5242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p1Vg5g8arp9jRXs/YDrrUFHEFfZ8o+77ZK/eu4p+47xLZB8gU+xwgmvc44qLGbey
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7238

On Sun, 26 Jul 2026 12:29:16 +0300, Michael Gur <michaelgur@nvidia.com> wrote:
> The uverbs ABI reserves the optional access flags range as best-effort:
> drivers should accept any flag in this range and treat the actual support
> as opportunistic, never failing registration when an optional flag is
> requested.
> 
> Add the optional access flag to the allow-list of DEVX UMEM registration.
> Uverbs users can now request any optional access flag on these
> registrations and mlx5 will apply the flag's effect on a best-effort
> basis when supported.
> 
> [...]

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

-- 
Jason
