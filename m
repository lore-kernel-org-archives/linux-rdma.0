Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012048.outbound.protection.outlook.com [52.101.53.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 828D23CDBD3;
	Thu, 16 Jul 2026 08:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784192211; cv=fail; b=qrGiqtO+/GHBM0tE6l/3wf6OSiV8n4PmQ/Sxp/I+ddXJceqcQpt4QpRVMt9C/U5X6AVcx0dVE8pWRoMaeFewpGCkPk0fqKUF01Lom7PeD/MCkKTCR9jDbtSvd8pLY+q30D6I1t0+jvBxp+GhYuVzaggEXyw/R2btLwCsadPj71s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784192211; c=relaxed/simple;
	bh=a202Fs5RfhnBEhhwQrdaV2o61UDRzzRhWZXm67WzM7w=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eMCCkvmP2lDpSEJZQQjx4C3fYXF2uTkyWVI74EUdgsyS0SGVaAwZRHaxoZom0s1H+NndDkcBHi/h1G3IoWopA1i3uSeO1kO2UjQHWjPpZvFGnGk1LuIGBZV6SJUBLi+Oh7b6r6aytJ3wKfgW85PikOsD4J/FgdL8Ut2zYo0ZdhE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Ks020uBj; arc=fail smtp.client-ip=52.101.53.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Ks020uBj"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZZzB+HYadeaK0xr4O1b1NGRzQgxeb3yL7EC/jAPW9NReeEksg9t3vGjX0MZckkzNLQA5AgZFwsauDRlX7rQbAYxgvOPQ831tM1VBFqLNBUd0i/Pm+sk5DwFc+Xz5WpZGw8jOGAREZAY8E3eMtlfCarVAzR8VLWxMO9SwKIsBNZPJunxuTqp7R19aB/6Kz6KIj3uy9UhDChEEmuShyzJkuAd7tD5mZ8rGuJINRvQxcdPTOS7AI+KGzvRaMHIZCtS+YgiPuHB/kaXQzLCGIFe/HlRGa9Viws8WskLLvN+VtpsuVvkhkCwISdyiaHqCFdWLAtTHOyiNi5HH/7s1ByMJAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Y2FVFxACszev4o7hfoWzvxnM1s42Dm/gLpVgGy5Vic=;
 b=t5txNm6Q4tcH8wtB/pMYCZIh7R6TjniYAZsrFkAm/jF03Ygc5K6NuFpq/8tSHA8dyqd2pKGuyf527XPlDYBqOitJQhK/MOmfjanDowd/F+CbxbogNi7v68z/BVstkeI6T3exj/OubX8m3uCzTe6EK9TQJpJSC0ZPuVbDBdYSMzdSYVUVMMGUF1PEaJ2DOtPSo460V8TDZtlOffAUyNWtud/rzOSDmKge8aoOwynUeOVdPWt7xSa3xkUyCYJ1t6V0OGe+YzIY780LFMz+1VZJfDhZjoxS6bX35WqEoDwXNJCczfwNCWU5B2XxeBdNLzP0/0+Vz3WAUe+QWis8JyvDHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Y2FVFxACszev4o7hfoWzvxnM1s42Dm/gLpVgGy5Vic=;
 b=Ks020uBjbCafD6s8IaAeEM+3k7/FLlgpzryfcX9iTkziv9aJ9IFWEXB2DvwC4xZQZl2vzQZHHpQW3uyl7q3/Vh6PAe5Euvwi4y7vmEikWDN/GuFXQfyuaZqkYMYHob5Ak0qD7cHQwMn1oFAt6FMBekk+hT/wmEgfn2/1nenfn6A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB7777.namprd12.prod.outlook.com (2603:10b6:8:153::22)
 by LV2PR12MB5846.namprd12.prod.outlook.com (2603:10b6:408:175::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Thu, 16 Jul
 2026 08:56:32 +0000
Received: from DS0PR12MB7777.namprd12.prod.outlook.com
 ([fe80::826:25fa:4fd6:2d74]) by DS0PR12MB7777.namprd12.prod.outlook.com
 ([fe80::826:25fa:4fd6:2d74%4]) with mapi id 15.21.0223.008; Thu, 16 Jul 2026
 08:56:32 +0000
Message-ID: <7b5f02bb-26db-175e-34cc-40318b0752b2@amd.com>
Date: Thu, 16 Jul 2026 14:26:22 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [for-next v4 0/5] ionic: RDMA completion timestamping support
Content-Language: en-US
To: Leon Romanovsky <leon@kernel.org>
Cc: jgg@ziepe.ca, kuba@kernel.org, davem@davemloft.net, allen.hubbe@amd.com,
 andrew+netdev@lunn.ch, brett.creeley@amd.com, edumazet@google.com,
 pabeni@redhat.com, nikhil.agarwal@amd.com, linux-rdma@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, dwmw2@infradead.org
References: <20260610154216.712374-1-abhijit.gangurde@amd.com>
 <7c9dea7d-a551-6f6a-3c3a-e0b55497c645@amd.com>
 <20260716080110.GA70906@unreal>
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
In-Reply-To: <20260716080110.GA70906@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA5P287CA0253.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:1f1::7) To DS0PR12MB7777.namprd12.prod.outlook.com
 (2603:10b6:8:153::22)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7777:EE_|LV2PR12MB5846:EE_
X-MS-Office365-Filtering-Correlation-Id: ac559b41-1a44-4626-e66a-08dee31821e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|10067099003|11063799006|6133799003|18002099003|22082099003|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	Ey4jXnOC0bf9LWlEUBbm9cTV5+DOyxPY75IlVez/IEnNitHOLj7lcK0QEVLY6Xau9plXoSFSpyf/PmpPFZ56VVqR/F7TNnrEmuG9WheexsM0bUP5As/evaZnTb9ad/eBvFH3nn2WJUneGuLbi9q+pc5ekB5l6auGalok21/hXKQ35TTqlkn0ADhoA/5ahcApUTNh42Ty3qoyfZBXh4XkAUy677PDeERSJsZ9A1MsUas13URlymSeIj1ntO7RtU0tQUdMTww/Ym38jqLR9TzdKCzW2T9X8Zwl3zMC5SAVM1mNcvHt5FmEcdCc2yROud2XCQcTPZJoGbL8jK5z1Ai6M8hbvQHPp6aV74Qw/OWNtaZ2/84MZ9W/gDxnB8hZnAjP52TulceBH+dLHxEfO4GzUmFi5I3I3PRXfq4xfWNRxcTyfGGHK5v4aEONlOaYw6ISJD8ufQO41ZE8FLxI+B3Ga9XCXphpxt73UGwj9chcvp+dt6oevFurM9xkmx9zAvjeF+mkYTC7YGJmkgXLtK+Cy15TIyeqmobk9bIlMrAd2vmx6udO+zlmYzaCvdGO5Ie1GpKAHVoE0blOvww8t0Uht8FZuF/fKDn36uBsVKMDeSha3cfe9svIdillVD06obbFcXXhZQEuuzpdrovOp1/HImsOZz2tDpAq9zpuYlHm4gg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7777.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(10067099003)(11063799006)(6133799003)(18002099003)(22082099003)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dzU1NjY3M1QzL2VIejBFNmdjZU5QRVhCNmJ3MUMxMWMrYW5hZVdyR1o3N0Np?=
 =?utf-8?B?aWhVSno4M3lRaXRDVytQeFRCcHIrZS9ENXRwaTZ3blA0QzFVcVhGU1hySEhH?=
 =?utf-8?B?dzdMcUpvU2tPZkxlZFJha3d5UzlZTkt5YVpvT1BLU3dFbG5OdjNMQVROYzZE?=
 =?utf-8?B?a3V0NHRaQ0VibnBoaEIyQUY4NDRjV3FxNERkc1VJVUdETy9nM25kL3ladlUw?=
 =?utf-8?B?RnlZNmxGclFhNkk0YWdDZEtRSkFtZWszaU84UzBrWFRwN0ovRzhJakgyayt1?=
 =?utf-8?B?ZzJURFJUeFYwR042N2tsN1BkUERRQ0c0OFVxb2w1NU5rZklWQlZDZWJFcDFR?=
 =?utf-8?B?NkYwcGdIdDNTSitiSDBvaHJKWkRPMWVaTGFuUko2N2orUVVuMlJHZE91VzVQ?=
 =?utf-8?B?QXNrQmFPQm9qelhBMnFPN3JhYysxM08zU1dPZ2ZHNkNjNGFCb3c0SzBjdGF5?=
 =?utf-8?B?cmQrVVpZZUpnYUJMOHg4TUVLdGlxMnlkNldrN2dZTDFpTGVvRk1KS0w5ZHNs?=
 =?utf-8?B?aHNqTUJoVDFqTGc5cTNpSnNPNDd0Tlc4OHVHUUFJWVlKWkFzM2dMQno1N3BB?=
 =?utf-8?B?RVk4VXdGOFlxUE5JQ1o3WGV3YnVTSk1hZlBhSzA4SUtydGxGR0czMzlnRVdK?=
 =?utf-8?B?WWVhOTdWUktXb0hsOXRhQm1VeUd3cW53V29iU3Rxa3o4c20vRzJnS3Rwb01k?=
 =?utf-8?B?QVhtNUxSbjk5V2t4ZmQ2UUpQMWZrOGJSek14RDJzaVUva1ltbFZ1WWVUTGlr?=
 =?utf-8?B?VWF5c2NLeEEyakpla1pOZXcwZXR2SkozSS9LK29HVkVTLy83WTdnZFk4VFlT?=
 =?utf-8?B?MkxIbDEvQzdsOS9Wd3h4UWZORG1WaGxRdGwrWlVhNnA4dWE0UzVGdm5FUVVn?=
 =?utf-8?B?Z1h0Qm1LaEU3UVRsaEpCTnF3NDUxdUtqZUdMWExUVFp2WTgwSUhFM1hpQ3ZP?=
 =?utf-8?B?TWZSS2NFRUNWT0FtRnBEemxIViszNXZjRzU4ZlhEQkFVVGplVzdjUHJPQUxk?=
 =?utf-8?B?NXJGY2IrRENtWG5ENFBpbmZyVjIzK20vZlltckFnQ21paURmMkp0TzlnOHlC?=
 =?utf-8?B?NUloc0ZwRGg1ZHM0TE50dG8xaFU0aUszWG9UZmNGbmZNWEhnSGlTQkNvblNM?=
 =?utf-8?B?RUUveWsrUDF0TE9SSGtPZGYzTmFqL2tseFBkc0hLQUw0WXd3NkxUc05Nbm9V?=
 =?utf-8?B?VVZRdG5wVkFxUHRCMGNJaUNicW9BUjJSdFJZaERYby9GUy9NbkZ0UTBFT0Ns?=
 =?utf-8?B?M3lmMWZwb0J0QnB6QTNwQmQvS0ZzQzJ5NzdiUGIxbzJFLzgyY3gwdGd0c2pY?=
 =?utf-8?B?Smd5TzAxOFNkY3IxZXoxQVlqSjRvQ0dyVkxGMVNWZzRlRGlQNG1WMUlYaFNP?=
 =?utf-8?B?YnpCZWZUakd2L3hTa2pJTWNML0Vqa0o0VWdDa0FmdllvYWF1WlhFYnlERW5q?=
 =?utf-8?B?MHpuZGpDaUcvS01WclpQK1puaEZMNnl1c3BFc2RIemhGM29jR2JDd2pQeEVX?=
 =?utf-8?B?a0VzZlhCK0NLdzZaSG16MzlicThLcDc1eHVadFB5QjdJQi9JZnlXSEt4UG5M?=
 =?utf-8?B?Z25wZ3R4M1RmY2o2dU1EUzJiOSthSThCUzNmWGxOMVE1SzdIa21JL2x4ZG9m?=
 =?utf-8?B?ZTdjNmhQdE5aS2NTVENRTHB5N0EwNFZRZHdjV1lLWUlCL3hQQ3JxOVlMV21R?=
 =?utf-8?B?MG5KMkVDQkIrdkRGaE1xNE1OUkU1WEQrdWFrc2RmdHBDTTdkQUFtK01hZitS?=
 =?utf-8?B?QVdnTDBPRFJkNXVYbkxzWVlORzMrMEM5RGlkSTdDa1k3TTA5RlIxU1RmdXlN?=
 =?utf-8?B?SW9hOFlYR2dOTlRIWW43d0dWY1FGS2lzUnhvYWVLamczSUdCMXJkc0JiRVRu?=
 =?utf-8?B?aGhZWldKaHZ1SEtlV1VPbGVsRzFWTVIxMU4yV282ZmRZTE8zRGdzUzFUSi8w?=
 =?utf-8?B?L29Ha01SUEFxOVBVbzAvaDR3aWdNZU51UjhQbUJ6bXlyVlRjcHVjemFwaEFP?=
 =?utf-8?B?d1VzNUg1OG1uVi9yL0w2NnI4L3loZjRMcklpSUE4c1djSVNvTHRPc1R3WndS?=
 =?utf-8?B?eWZmQXlYMkF4cEN2VnNzeGo0UDNKcWVhenNEY1AwQ0lsbUdseXBjS1dpS2Rm?=
 =?utf-8?B?UktnNnhYeEpsN29zU3p2bk81cHoxZGtkTHJ0NEttUnRzcWs0eDVwZXpoV0ZS?=
 =?utf-8?B?dHR5UEkvKzIxZlZGZ0xzZmRCWStyWDZOMVc3S1lWc09XZHZLKzdHRkF2YUNp?=
 =?utf-8?B?ZEVnSmtubTluS3k3NGV6R0RSSUhCdWVCRHRZdmJOWDdxWERaZ01SbElxTmNR?=
 =?utf-8?B?cEV1K2YrVWQvTHc2N25xaGVCUGJqQUpnWU10T0R0ci9Sa2dyR3hoQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac559b41-1a44-4626-e66a-08dee31821e7
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7777.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2026 08:56:32.4140
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9ZMvt/tnFM/n0QZ7+kUOv/YdZgUwdy7Tz+5pRSpGxDtWBQVyMvRjgVWUULDbImejJHec43ZWMwjzZElWcGzYjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5846

Thanks Leon. This is already addressed in 
https://patchwork.kernel.org/project/linux-rdma/patch/20260617132605.1888205-3-abhijit.gangurde@amd.com/ 
which was sent after this series. Happy to rebase if needed.


On 7/16/26 13:31, Leon Romanovsky wrote:
> On Wed, Jul 15, 2026 at 06:38:06PM +0530, Abhijit Gangurde wrote:
>> Hi Jason, Jakub,
>>
>> Gentle ping — if there are no further concerns, could this series be merged
>> through the rdma tree?
> Jason requested converting any driver that extends udata to
> use uverbs_robust_udata.
>
> https://lore.kernel.org/linux-rdma/13-v3-bd56dd443069+49-bnxt_re_uapi_jgg@nvidia.com/
>
> Thanks
>
>> Thanks,
>> Abhijit
>>
>> On 6/10/26 21:12, Abhijit Gangurde wrote:
>>> Hi,
>>>
>>> This series adds RDMA completion timestamp support for ionic.
>>>
>>> It enables PHC registration for RDMA timestamp capability, exposes a PHC
>>> state page for safe user-space reads, maps that PHC state through RDMA
>>> ucontext mmap, and extends the RDMA CQE format to carry completion
>>> timestamps.
>>>
>>> With this, user space can read completion timestamps and convert them to
>>> wall time with low overhead.
>>>
>>> Provider's PR: https://github.com/linux-rdma/rdma-core/pull/1724
>>>
>>> v4:
>>>     - Added alias mapping of mlx5_ib_clock_info to ib_uverbs_clock_info
>>> v3:
>>>     - Renamed ib_uverbs_phc_state to ib_uverbs_clock_info
>>>     - Moved mlx5 to use the common clock info structure
>>>     - Addressed review feedback from Sashiko
>>>     - https://lore.kernel.org/linux-rdma/20260606050003.3648306-1-abhijit.gangurde@amd.com/
>>> v2:
>>>     - changed ionic_phc_state to ib_uverbs_phc_state and moved it under
>>>       ib_user_verbs.h
>>>     - https://lore.kernel.org/linux-rdma/20260512092623.1157199-1-abhijit.gangurde@amd.com/
>>> v1:
>>>     - https://lore.kernel.org/all/20260401102501.3395305-1-abhijit.gangurde@amd.com/
>>>
>>> Abhijit Gangurde (5):
>>>     net: ionic: register PHC for rdma timestamping
>>>     net: ionic: Add PHC state page for user space access
>>>     RDMA/ionic: map PHC state into user space
>>>     RDMA/ionic: add completion timestamp to CQE format
>>>     RDMA/mlx5: move mlx5 clock info to common struct ib_uverbs_clock_info
>>>
>>>    .../infiniband/hw/ionic/ionic_controlpath.c   | 34 ++++++++++
>>>    drivers/infiniband/hw/ionic/ionic_datapath.c  | 43 ++++++-------
>>>    drivers/infiniband/hw/ionic/ionic_fw.h        | 12 +++-
>>>    drivers/infiniband/hw/ionic/ionic_ibdev.h     |  2 +
>>>    drivers/infiniband/hw/ionic/ionic_lif_cfg.c   |  2 +
>>>    drivers/infiniband/hw/ionic/ionic_lif_cfg.h   |  1 +
>>>    .../ethernet/pensando/ionic/ionic_ethtool.c   | 12 ++--
>>>    .../net/ethernet/pensando/ionic/ionic_if.h    |  1 +
>>>    .../net/ethernet/pensando/ionic/ionic_lif.c   |  5 +-
>>>    .../net/ethernet/pensando/ionic/ionic_lif.h   |  3 +-
>>>    .../net/ethernet/pensando/ionic/ionic_phc.c   | 63 ++++++++++++++++---
>>>    include/uapi/rdma/ib_user_verbs.h             | 33 ++++++++++
>>>    include/uapi/rdma/ionic-abi.h                 |  1 +
>>>    include/uapi/rdma/mlx5-abi.h                  | 15 ++---
>>>    14 files changed, 179 insertions(+), 48 deletions(-)
>>>
