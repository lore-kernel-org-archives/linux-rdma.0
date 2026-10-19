Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010070.outbound.protection.outlook.com [52.101.46.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38493FB05A;
	Mon, 19 Oct 2026 11:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792409148; cv=fail; b=mCptTV0LxVmXgQArrDz7WY6KsCvGQMBx8nRUaYKY9oDFmuw9V/LmHXHyslQ0DPzhkSdsDy6AlucKprShK58gDDVnJ3FV8kFR8jGH8lk7eZf82qc9VAI8lx2ONPRWMlXj/uR3JXJTcxmlavKQ8YsjGVBYsTAnllSYcilYI/tpfao=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792409148; c=relaxed/simple;
	bh=iHIt8/Yx81GdXFsb0oEvnZdBedJe7cxVc8EKCy6REYI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=m8W2lL4ANqyJ8WtgZehs2v3bCl4T3BCHNByIlMlmHK8n6tmsYa/2JoBbdpgPsILZ5CPKB/JGLJIFbQio+nuURIF3mCgp9BYKAGuEASXZVwa0GS/8ijtykcu7iG1M9v4lF7JcoAjjtH8GuLSFEH/RkMsBCtRNgfgnK++EKbou1gg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=UU3uQ69O; arc=fail smtp.client-ip=52.101.46.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="UU3uQ69O"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sD3W+PLCkv4nXkQXKabg/ySQTKeRzANAfPv033K4d1BB0wUCG9ltFG60Qt78jjAcB1b526O7xFco7ZDoadrglJZBZsfFRNjLf5evllH44rt413nTwcMORZ8Mp5IQjodfiKOSLh9ydrSyNmw2D4IJ/2Sm1TWxYOFsHeywuXJty0i6EnvE2p4xD5dOAA2YcMuKhVhVbY00LDEKgL/4nLDMYWRr16zLQjRw0fFbkq7QcVV8R0es/cwNQu0fIK18ckEbSVX0jAS65tmSESqwEDIn95gtevXWDKf77Z5Eifp3ykKBiK5E0/wm9qUyBbTdj5Bk2RbllkBCQJiUDa6/kkjc4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HLVAvQdMF6HywMBqkujhpN2PLleO/tEZRikOJOeVAYU=;
 b=a0syKHeglnlV1jis0lRjrbUEKkOkuyjUIY1KXPdDRPyTNjKuyIrK3NMI1qUE4qO6p7q+Z0q4JM8U9Bp3zCUAOY560cZAU1dsduGaN1uCZbQtCiBOqWSmwE2PftvACpYQ3hYBur+VJibmgO/D0pWTr9cDDYWnscb2oS7aJ1hDIJIetV0Ex0WY14QBqaGDasA7WKVvS+GgWiqI3wfLi1lP1Cu2idc8jQxKMoMtbV0cpdxaz2mTDaO/Ce4iz5d9ksUe5Alsv3eh7Nua0e8pQTD+CUXsNRzOQh33R7BpJ7dcg70+Z2/hs57+wcE4xEinDdRWpTaC/sMq8sYCaPl7FQQHNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HLVAvQdMF6HywMBqkujhpN2PLleO/tEZRikOJOeVAYU=;
 b=UU3uQ69OH36qfX6gb/WL0GDdaGUpIM6TUFcuLgDIetP2dAmnT49qEMWxj6URKzJuTuSWJN3PprvFFkFx9e1bo0kJfsn4T9rjZ0YTqUXdsLkD2MQHiP3lt4Wh5hxwopK2qDjTlp2FbhZdwbPi73yLH5cr9LA8sQjUTYr4rvyKrS/i96gSPdxk7hlbkmdIBiMlA2LaCjb1iBIzkmbSsyIidX5FEvWITJ7DRM2sSbYF0nEckpqc1T8jKje859MiJ7Whj1j+KrE0k5Thvj+Sem27EyafOoiBZi9geN8pIMI6z/5yi9dNmQHb1ZyQB6xfA6a6xpe4DlbesmfA18oDjxTa/w==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 (2603:10b6:207:12d::15) by SA1PR12MB8141.namprd12.prod.outlook.com
 (2603:10b6:806:339::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Mon, 19 Oct
 2026 11:25:41 +0000
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f]) by IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f%5]) with mapi id 15.21.0522.017; Mon, 19 Oct 2026
 11:25:41 +0000
Message-ID: <09192a25-f141-4a88-bc5e-ffda957da554@nvidia.com>
Date: Mon, 19 Oct 2026 14:25:38 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v2 0/2] net/mlx5: HWS, fix pool creation races
To: Alexandre Cassen <acassen@corp.free.fr>,
 Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Moshe Shemesh <moshe@nvidia.com>, Yevgeny Kliteynik <kliteyn@nvidia.com>,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20261012100555.1317878-1-acassen@corp.free.fr>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <20261012100555.1317878-1-acassen@corp.free.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MR1P264CA0185.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:58::14) To IA4PR12MB932075.namprd12.prod.outlook.com
 (2603:10b6:207:12d::15)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA4PR12MB932075:EE_|SA1PR12MB8141:EE_
X-MS-Office365-Filtering-Correlation-Id: 09957615-625d-4867-02b2-08df2dd3b54e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|56012099006|11063799006|261009223027099003|10067099003|18002099003|22082099003|41080700001|15866825006;
X-Microsoft-Antispam-Message-Info:
	8iqzeGaa6jXWApf//Vvdle9jxUdsRMxLRoU/CWtJhIvVBPwJkV911ZoI7xePHBACMDIx9uG06c+eecvNa2wpcrzYd6b2i6SUlsw0h8sWYOvMelytuVXCVqcYi8+8IRHEGa6iR1UdK8n7EUDmYl05B2J+JinRA3stcwE1xjBeJ59I1uTSwFlNv2qwYe1+uQZWGyj+nwKyOFGAjTwwKZ+8oFafSTZuVVSbZEWiUoDps2FrzOgex6lT09IOi9wLKRjzW4vKUCHUCQYjOhhg+Q5Kd42WF+zrjWQ48005uxnaLLEBDxMhifDk8XikehX0YwYPIW0RiWLxJ/cmhM332CRlgXj0cPD5PiH+PRMvod08BkXgpgEs5EVg5Aaop5PlHoVUWEbvG+cT9HD3ACN7zr5vuq9VwRMIVKXvp4fkHuiT/idECPlH6Zi1NOYsZsQ2u7FJq6+8oKdEZIT2pZghGL00yK1vIxhaqrec99ln8pHy+TbVhxJ8pxoit+aHhJxTZncRJj55YxU5gVgpJc+6A7ZTCfqLE9IUWO0EI6uAqunp59cHMrXK6c4Z2uBzPkd92wy0/iKST7fYVBwsHgI+OxC18XYzkhHFSnrCsM9j1g7eVmpKvRosgcgdlj50AxC9Ad54RxFyS7BLGnH7EaaY5oh1gyLDdEou9px4nda+/41RaqwIBLUxpuNeRR4sI3AUXfo3i+RHJsQzNN1WqyTXT+LpK/2+lOKUJQ4QD1l6Ji7e4ddjXV/hrde7J2eJ3M+LUaz3
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR12MB932075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(56012099006)(11063799006)(261009223027099003)(10067099003)(18002099003)(22082099003)(41080700001)(15866825006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VFVLc0V2WVR2TXhMYkREWmFsZ202U085azgxNWhodklZLzV3Z1N1N29nZ0J0?=
 =?utf-8?B?emxkZURUOGl2RXlDd1dMMklKejJwbXRuaFBDV1RFbjhiOXNRUkpORE1kUlFo?=
 =?utf-8?B?cE5DTkYzSGN1dFBhS1RsQkEwMUwwT21BMk00eWVJZjlvMVZ1NFpnUk9WQXQ3?=
 =?utf-8?B?VGVPN3IvbHBYeXhCMXhpL1g3YUhCdG9aMjl4UnNsWk5yZjJJRkdZU005VEIw?=
 =?utf-8?B?QTB5S3gwT1h5K25zdnZaQnJaaXg1Qk4vSENmRDZjeWkxZXFiWlRycW1paWt0?=
 =?utf-8?B?U0FhZW5uN2RZVVpWNDh1T2l1Yk80VnFaSUtSRUROMjFSUWRBL3RibjlTbzZ1?=
 =?utf-8?B?RU13cHdGNDE0eFVzZ1h2L2xEVXNHRzFEOXd3ZTJaNTdMK3lPQlRoMzRkWExh?=
 =?utf-8?B?aWZCTURlazV1SXNrUTZtYnVGenl5T0psOS9yaUNDM3N5MDRCdnF4aHBUSzJP?=
 =?utf-8?B?eDVLd20yOSs1a3N1dzFJMlZDMzNHRGVGdTFiSHhwdVpGRXhHY2pqdFpxck9h?=
 =?utf-8?B?NmFGU0VDWFJQaWE2U3ZOaldST2x0NGxDN0ZMcGptKzR4bEZQZllFT0dIZDIz?=
 =?utf-8?B?RHc2eVE1aVhaV3loWjNYZ1ZsRWh0WGYyMEdSc2gyM1ZlV3k2T2FuMjV1cjFk?=
 =?utf-8?B?TWEzZkNvY2NidlpuNTZUNGxxdEozN1h0N21iTEVRYXBad3pWSTlEdXQzaGcv?=
 =?utf-8?B?VnJrOU5tUWNpNnRTWEJOZXdIV01lb3VKUjc5RFN0OWJKZHk3Wi9hREtlUWVp?=
 =?utf-8?B?UFlUbURRa0FSQjNHTGtxRU9EN3JGdHk4aWNQb3pDT1h2NGoxa05XSUs5VWhW?=
 =?utf-8?B?ZUlNTjlWM1hTbWprelZpVnQ2dXU5SFJQNVZyN052QjRDTEhOaDFkamlZVnVq?=
 =?utf-8?B?SnNSLzZidnVBOEdQWXlEcW4vaEIxL2p2NUpXampqSHlGaHVSSHBlclZySTJj?=
 =?utf-8?B?WG52MWFSYUdGaEVKb1IxY240aVhES2pyK3UwYTBjV3VDMmpKRWZwMDhJMlpr?=
 =?utf-8?B?U1RYdDFJUWdzZDBhVjZmZEZVdXBjWGJqYkd6RzN2dHdjWUU3TUZhMGM5OGVD?=
 =?utf-8?B?TlVNY25kZm55QitvNklPeHZINUZ2YUJjSUk3S3kwS1k2UUNUd2JCQlV3OEMz?=
 =?utf-8?B?ajQyczYxaDJkbEw5b1hxRmxlSGJoQTA1a2dVNHZITHYrMGFpb3dreXdrSUpF?=
 =?utf-8?B?WkxhUVNiTk9BVWlNYUpyUDk0d1FtUHozVEZmZUtwQldHNmRlaWNEdVY4TWph?=
 =?utf-8?B?NGJ5T3JVQTdBOTU4NDk4MWZFaVhFOXBsNzFPa1lnRGdvc2VJanp0cFVTbWR0?=
 =?utf-8?B?UjBtS0N3M2VLM2ZRa1kxbTFYMDUyTHV3SWhDN25CbEI3OGwvbnZOS2hjZW1I?=
 =?utf-8?B?ZlZpbkFtUVJLeFExb2FUUHJoalRVSDBUZEFMQWt4ak41QWRSYUZzNWg4OThW?=
 =?utf-8?B?Y3lwUm04UHJIOHdFTUlSb3NqSjFyTDV1bGpoYk12ak9YNDZZMUIyTXlmc2xo?=
 =?utf-8?B?eDVkTjRPRGN2dnQ4ZHk1TTFZRGYvZFBTZFVMS1RhK2g2ZnRMbitXNTdxSTJn?=
 =?utf-8?B?U3NINGFuQXR4TW5TQmZsK2V6SmIrMWpoclA0TXkwSEx6T2FoM3NhRitDUzQ3?=
 =?utf-8?B?L1Nyd1ZxZUwzM3RDZXhlTFdDbk5kUkZkbTY5ZitidThzQTRmRkUzQlVFWXVL?=
 =?utf-8?B?dXZGQnBscWlIWm9oWlNRK1NZTndLNnNSQ2tMQmtnaklka0xMMWpJZU11akI0?=
 =?utf-8?B?NGIzWmpXdEFrS2JOZmVQODE1NFR2ZGVMcE1pN0s2QWh0SlZYbUJCTUdSZ1RG?=
 =?utf-8?B?a1BjcldBZ1hFTGNEbGVtOWlqN3RBMG5lSUVBWnNuUmplc2xSSmIzN0RuSVJj?=
 =?utf-8?B?QjdHYXlMeUxiUmJmblp2VE90d1YwaDRuRlVkeW5lVkp6OWdoTHhnbTVmRE9n?=
 =?utf-8?B?dDVpK29VaUFrVWlJRU1DeDBKZzE2U3dpclM0MmFaaWJ6UW4waGxnVityOUhG?=
 =?utf-8?B?SEVXYkZqL3BXbTRVMG5MWmxTaEVyUGVNUUtFd0R3cFp4c01jbWhtaldZd2Ri?=
 =?utf-8?B?bXc0d1BPNmZ3KzQ4WVdsWElRbmZtaTZMK0FHSTB4bVJhYXVXM0R2anltanEw?=
 =?utf-8?B?VHRUYjgxaElTWXhtZUNRTWZYV05kZnE3ZmpXeG5UWDhhbWNpc0VzSU9nMFdE?=
 =?utf-8?B?bGZ2MUNPTzBoQ0lHOFZLekdTYXFPZVcraWhTeWRRQTdIaWNkVTQxVmNudkJX?=
 =?utf-8?B?OFFKVkV1azh5YlJUT3hwbU96L2U3Z1A1emViazUrVGFzNlRDZGZQRCtacVBp?=
 =?utf-8?Q?ht8kQUkgbGVM9lSmo0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09957615-625d-4867-02b2-08df2dd3b54e
X-MS-Exchange-CrossTenant-AuthSource: IA4PR12MB932075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2026 11:25:41.4486
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n0zPcFkiKLxlv9cgQs3pAZfcLHQGtyOIXsStH5Z7gICa6IfVDIuHc0U5CL1PbwcUS6sXsUmwZcKUVfVH/aCFXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8141



On 12/10/2026 13:05, Alexandre Cassen wrote:
> This series fixes two pool creation races in fs_hws hit when two
> callers create the first pool for a reformat size or a modify header
> pattern at once:
> 
> - Reformat pools keep the pool inserted first.
> - Modify header pools serialize the pool creation while keeping a new
>    pool on error.
> 
> v2:
> - Keep the pattern lookup out of the mutex and look again under it on
>    a miss (Moshe).
> - Add Moshe's Reviewed-by to patch 1.
> 
> v1: https://lore.kernel.org/netdev/20261008204230.3222198-1-acassen@corp.free.fr/
> 
> Alexandre Cassen (2):
>    net/mlx5: HWS, fix reformat pool creation race
>    net/mlx5: HWS, fix modify header pool creation race
> 
>   .../mellanox/mlx5/core/steering/hws/fs_hws.c  | 66 +++++++++++--------
>   .../mellanox/mlx5/core/steering/hws/fs_hws.h  |  1 +
>   2 files changed, 40 insertions(+), 27 deletions(-)
> 

Acked-by: Tariq Toukan <tariqt@nvidia.com>

