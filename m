Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.71
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795787921;
	b=b+vU232hMl7YlcrrPUI09RHm3vkk3nxBgKsZvfC1BJgozxPhZtV5cppguXb/9/aKPAun
	 Zf7/9rJudBq72oJtHCQ/CRCFSfFyrrsDM/e38QLed7/3SjXyVFW7pGDOXk15FEv1kjdu8
	 tQr9pmn2J8j8t7nDgI8SwUQp3lXeIWktb5tXs8smGlgjLB82METZ8lbpJMVeDCFZjV+9K
	 as6Ulk5wV3W2tekBtiCfWU4I6M8SUv+urnmsqYNQjqzJirI0Uj2HyLgpiLZ9kc4MSSoX4
	 O4neTf766otbl5XjDPLIu9W9PBKScEDqZXUnFExJTPI2BYk7R5ZftUsZyjuNyhkw+Tw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795787921;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=xGBlzl5KELnPK5unfpiUZ+E6LzsXnqtxXnwL+nOYYqc=;
	b=1jRyDqrM5mxmr/lI6Mk9Mhrz5ANhy2vZmkEBiMWovelRrxJo0wxFohgErJo3HnYk0gF7
	 qRJPjujXnsl79AQBpxIxprJ3XPdw6PEQODB445nweTfozS+i3sbBdhaIYOevn+zz1trxC
	 bfUlz0DFacDALkW4t6TMvFAFFfEKII6M8i9wyFQC47/B55Af48r/Rf420+7azGnIMfkFv
	 mr1a9Igr4Rbf9kxh5ivS/Vu9zY+UoSAz/RXOONigv40sSknWfA/pC8vJEdpYLsbmMCtVe
	 HsAEeIBZ7AD6ZZEnXpV6dMS8zc3nexw5KhP6YP8vyzxNjgKOpcIZr/5HTV0BfYyZACA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=YfsT059h;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.71
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010071.outbound.protection.outlook.com [52.101.61.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B25F606A31E;
	Fri, 27 Nov 2026 13:58:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9B25F606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=YfsT059h
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MrP29Q+CaODwChZVw22st8BCZQB3aqtb59kAqkIuEIUBn2Rp7mp4MSpzBvadwQ0yoDX6nH43bpx7Eg3nhOAnn/EkxPrFbq13DL1YIuKVBLUHHkHPpVD7dq/XICQjzKpAhXUcm2gUDUyxH1YsjRD5KRmfgxRi2WuWVihXMQr30vBJjG2mipWKnxe5LOrGRd4a6/x90sgwq71q8aGipdNtRXiRGTTuZt2Ylnhl9ftMDcZPouQltfPsvVDcGRDkDaNKHHOL0VwqkFwkG2rdFCWBH4jRsgWeNRunFPDO6FhEsSNW35ycRzFP7NLUprk6qVmcm0tDUl9zQGwScoyb49Xvig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xGBlzl5KELnPK5unfpiUZ+E6LzsXnqtxXnwL+nOYYqc=;
 b=njxIyv8mue8nQ/xz/47S7WOSkEbFgMadQ8OqmpZLD9JthKrJj1Yaoe0Rd4XYfy7dtpR3xxw7YNLzlPtzUiaXA0mpGuxl7feTeN6FTVOrSJ/SDms6OWe7XM4O0YMxBF5A7gQyAxxVBwiiz+9WnCPFsAECLuPSOphprjPeNIZZT2R+jZP8SbUsLRR1fSyHouno6odPXawryD8XNucjDM7ebB40v/MmONnG/mbEOmE4sauWpzCR81kCGMMbid11+ZP7h1jeyq+6eh4Rc+uNQpbu26U+oTKOiKyeUQQ0JHIMKUsTJoG+XlIslJh/Tz6n2oTbnvnrsiIqk6z+lPvXG9rCRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xGBlzl5KELnPK5unfpiUZ+E6LzsXnqtxXnwL+nOYYqc=;
 b=YfsT059h7cZmYcdGXs8UkICPyWBm8r2G3oZFqGb4tbBbgtyGOF5nm+1YPSaAMuHFEy8WkRdl9gq1c7JXWGwgo7VWKwS6wqlpRyUdtR+gKjBeqFZD6TD8oCUhdYK+IGMkBxVQi0hsB2Osfog9j6I+qM44CBm6Oexw5DVrxwaxrSsmJF0+9JIyS4wTQNeKFuOrEjegHriQkwXsLFv9RPkxziH4Pb+s/sXPAOIufYpycqQf/ebKjTMV4XgouQnj83VoB5xuNsiAxMTHLHCZZEluI0SvnqjnnbvOaaNI+5bHkuRFMYM3ELUfzu7HQLoyKgnw8NC6SjNS/Wm5s7n7/F42RA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHAPR12MB999248.namprd12.prod.outlook.com
 (2603:10b6:610:2ff::22) by BL3PR12MB6426.namprd12.prod.outlook.com
 (2603:10b6:208:3b5::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Fri, 27 Nov
 2026 13:56:36 +0000
Received: from CHAPR12MB999248.namprd12.prod.outlook.com
 ([fe80::4972:8062:d74e:b205]) by CHAPR12MB999248.namprd12.prod.outlook.com
 ([fe80::4972:8062:d74e:b205%6]) with mapi id 15.21.0662.007; Fri, 27 Nov 2026
 13:56:36 +0000
Message-ID: <5e95879a-0b9f-41b9-be6d-c91a1c5c0666@nvidia.com>
Date: Fri, 27 Nov 2026 14:56:31 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net/mlx5e: guard child PKEY channel stats lookup in
 rx path
To: Etienne AUJAMES <eaujames@ddn.com>
Cc: Tariq Toukan <tariqt@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, Mark Bloch <mbloch@nvidia.com>,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 Feng Liu <feliu@nvidia.com>, "David S. Miller" <davem@davemloft.net>,
 COURRIER Guillaume <guillaume.courrier@cea.fr>
References: <awcn1-LpcFgzRKgq@eaujamesFR0130>
 <20261126144122.3886594-1-dtatulea@nvidia.com>
 <awljlARPJweYKIZb@eaujamesFR0130>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <awljlARPJweYKIZb@eaujamesFR0130>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0050.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cc::11) To CHAPR12MB999248.namprd12.prod.outlook.com
 (2603:10b6:610:2ff::22)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHAPR12MB999248:EE_|BL3PR12MB6426:EE_
X-MS-Office365-Filtering-Correlation-Id: 59ebeafb-fd6c-4d6d-5c8c-08df4c8e4089
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|261022105027099003|10067099003|261026140227099003|56012099006|261021121427099003|261028144727099003|261022075727099003|261026121527099003|261102123227099003|22082099003|18002099003|11063799006|4143699003|6133799003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	h0K81/fz9rANk4raO/VXQzRz8KKHJDqa0kxHQM24biJ13Wdfl8KuRq7MKP0jUXtClX32dfvei+XDCoRwfUnMFYH9ekMR0in71x+7dzgGwKEstT0CmaZrOxAvQ6l3GIJWQaFGk6O3GEOwEkl/z3J5wB7Jr4HQLAWvlIguTALuTP0aeAHe2yB9D85aBLpk2omj7VWFpjDz2CFS3eJpbvtc+eDViTmYB0fzv73EAd+ZbXvnU0yJwsu5uXMLbe+JUOwABPOg876FuGgs38xiZ6hQQVbU8us1i7oLWnXKdLA5wHQMs+N7v1AwOvcHCcIMqDjMpyhWSqYVBzaZEkXYErynF2iLvysGqdBDI2brDo8YRr/Yz8F3OkRkxtqFeSYfHqaLh9OHjkyWSVVArIEonKYhTBTG1IRxD99JOOf3WKuiYz5c2ZCfd4NkDDJaySXGH3dcV8SmFAkI+EQLfXlLh/skx3bEKbdFj2B/z2nWp8vPyyEfT+N7hDAfduITP4455rTAS8p+xrsFqxdkmZtluw4cGGKxlVP467vAeUh6aVtUqTK8mtCqElIv3mvXDlY9TBGgKMmqJgsCRn717Y3TkWHxNN90H4rJKQw1w945ANMSSSK7P+6c4l2AOgfy/kGAbZ5yvL9aAjgs0QH8Uhp6Y1u0eVmSy9IZ9kx/krsji8+J1tA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHAPR12MB999248.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(261022105027099003)(10067099003)(261026140227099003)(56012099006)(261021121427099003)(261028144727099003)(261022075727099003)(261026121527099003)(261102123227099003)(22082099003)(18002099003)(11063799006)(4143699003)(6133799003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S3EyWllxK3FDcFRFd2l3Mi9ibnN4bXFLZW5UVnUreHpDNzRXa2Q0bXdBT1oy?=
 =?utf-8?B?bURic1BxK1hxdnVZdlpNbFRlcXRIMW5EYkZRYWorQ0FHR3V0TjM4UHB4WGNW?=
 =?utf-8?B?aDhLR2ZOZk94VnY5N0MxTG9LNEVlZFNtVERGOGp5dmhDODl3YlVQQXFPYXdi?=
 =?utf-8?B?dWFhNWpGUzdTeHg2VkZIUm5PR2E2ZGlFNGFFc0MyR01ma1pvaElwQzJOYmJl?=
 =?utf-8?B?M0VkVkxrNU53K0FaOVFGbHJNUGJ3d1YvQzliOE1XVDRGRGR0VFYvK080czZE?=
 =?utf-8?B?MVVHL2xLZlIwM2wwTDZlQVFKWFdHOWtaY2R1bHoyRTgwT29Zc09XTUhSU25r?=
 =?utf-8?B?YnJCRUdGZitLd24xMlhRNDNaNjVpaHZwYXNJS3UyZ1pjcVgwNjBwVnBZZjNo?=
 =?utf-8?B?U2hBT0ovL0VmM1o0eVhZV1VXQkVjZElxdXQ2N1ZxdmYvaWN2VjZEcGpXdTRH?=
 =?utf-8?B?TXZ0NDAwQzlMYTNpekdldjVtWlExb0w5Mld0bzVDcHh0c0dSTCtnazVWdGIx?=
 =?utf-8?B?dWpvRENGMHhoT05OMktCYkdTYURWcCt1bFkzaktwNjd1eDh2SGMzcjZINVZQ?=
 =?utf-8?B?NUEwaGl4RXN1bTNUUVozdytJUW5CWmdualVVRE45NVBnc25tcUZxRkhMRVdL?=
 =?utf-8?B?TlVOcGs3MVNnTjlsR1hsRTdJMG9nOFJtNXZOS2lieDM4NVIzN1NJNFp4REhE?=
 =?utf-8?B?NVZoYnc4NkFsaXNDLytjMmx1VHU2eUVsSHRja0tucmR4U0pmRVlJS2Q2NVpz?=
 =?utf-8?B?MHlHVXdLbnZham1oMnNRVVhuZ2hSRVczYXJsclpEUmlrb3NxYk9GNThTU1hU?=
 =?utf-8?B?a3hIZldCVHVtK3FrdTNscVVWU1Y0OU9sOEVBdGhvU2dXbU1zcGtja2RFRUxp?=
 =?utf-8?B?b1Y4cTZEZjZCRGZWUkFOei9kZGhFS1I5TlRHdzI0ZFNacVpPU2x2UGVublhX?=
 =?utf-8?B?bEFMb2VSTFFqelYxY0NEbVR2MUt2Yk9wT0ZJY2gxN2dSN1dGZGJmRnptU3NN?=
 =?utf-8?B?RkhwQzgxbEJsM0pxK3BjY1BWUFVPL0NNbS9KWURBY2hyL3FJVHhUWWFQMUV2?=
 =?utf-8?B?L0tJR3hvZGRXVGZTLytZSVBweGhsQmZkNStCNms5REFnTlJIVG1DV3ZKdXpz?=
 =?utf-8?B?Uk9keVRnNjlHc2RLV0phY1g3ZjNpU0dkczNwTWdkdUdhR3J5NFozTVViRzMv?=
 =?utf-8?B?N2NmRzZFQlI2b3NIQ1dBVFF2ZXh6UjBhOGFyMXJ0dGpJaThEenRmcXNNYmY0?=
 =?utf-8?B?bnVrbkQvUG5ZQ2NoblFTbmo3REJrdWJpTVl6b2RZN1dsdmMvTVZPVjk1ZFhB?=
 =?utf-8?B?Y0t1TzRicTlIMXVLVzJXanlSUFBqeWtlTkYzQWhON0pmVHBidGFQZmZucExY?=
 =?utf-8?B?TGN4a2llcXlWMGNvYUw2TVFqYVpmMi9vZ3JUN3dJMlVXdVNpQ1p5RmtWbE9J?=
 =?utf-8?B?dTdtUWlibVhoSTZRYkRYYlBiZk1pSmRRaUFrZDg3L1lUMkp4TWdDV0dvcmd0?=
 =?utf-8?B?eERVbVhCL3ZiUExFckY4NGY0TXdYS2FRWU1XenhXZzF0M0tQZFhlUVRFSTV4?=
 =?utf-8?B?K1hMZ3NhdEtxZkZ2VlM5SmZzeHZXZVhWaXlsbklhWWt2VWs5SUI3bHV6VnlD?=
 =?utf-8?B?Ky96aWJ0SUVDRFlhUkUwV002NTRqR0krWTRDdDlRRG1aMStaN1YvbWsxclZx?=
 =?utf-8?B?aUEzNkFKV2JIem1OV1RpKzZlR3FGYzg2Y1JiWFVSa1BDc2t6Sk9pUzlheWxY?=
 =?utf-8?B?RUtnOHptWHdESzRCd3R1czhCNTlYYzlrKzdlNWRveWdPYTFhY1duWGtxYTVw?=
 =?utf-8?B?cmpWRFpTSFFxWk53dU14eGZNQ2xWdU9GcWY1NmZmTnN4UUFSZjdLQ0s2RjJR?=
 =?utf-8?B?QWlYZXV1ajFvVlU4dUo4UTRQWWdoLzJINGtLaUlCQjZ4eDgrNjBRUUtkNGlP?=
 =?utf-8?B?Y2lQeFJVMEZtalpxNVRRN2tmd05PaGlTVHJKZjFUVlQxWlBYcXFFUWhkeEY5?=
 =?utf-8?B?QUIrUGQ1ZUUvd0FIT2MzaVhEUmZpbmlEQWd2Q0NNWHdTa3VWMWpCN1pKekkr?=
 =?utf-8?B?STc0K2lXYjFhYVZ3czQyelZMY1RTMk16enYvZ2h3R3lCNDlLNFhSZUw2dmhx?=
 =?utf-8?B?RlozZXU1T1ErSTN2REJaYmI2UWdMMzNFWE0xblUwUVZsSHNoTE5rN1YwMjl5?=
 =?utf-8?B?K0JFYXBVNnIxR2tSZzVGKzlVcENJZVJTMTNKRUtNSmdGd2M3RGliZS9UeElY?=
 =?utf-8?B?Wms5TXNKc01CQzhRMld1MVpETGdicEErNEFnMHBadExNWVhVaEc4UFdWOHRJ?=
 =?utf-8?B?NEF3NWlNalNzNDBQMnRiMTJuRUNGZWhhMXJGc1RUY2VmRzNjMkJ4dz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59ebeafb-fd6c-4d6d-5c8c-08df4c8e4089
X-MS-Exchange-CrossTenant-AuthSource: CHAPR12MB999248.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2026 13:56:36.3917
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YUzB1X1vOo8WuGbQ7N5XKOiFSurxngBrNaPyynZpucH/JN9jGvVMr4RIoj099arCPSJK0oL4LIbNVEgrRtOSQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6426

On 27.11.26 12:03, Etienne AUJAMES wrote:
> Hi Dragos,
> 
> Thanks for your reply.
> 
> On 26/11/26, Dragos Tatulea wrote:
>> There are 2 issues here, each needs its own fix:
>>
>> a) Packets shouldn't be steered to the parent RQ before the pkey netdev
>> channel stats are allocated. Fix by moving the flow steering setup
>> (mlx5_fs_add_rx_underlay_qpn()) after the channel open in
>> mlx5i_pkey_open().
> Ok, I will try to make this change.
> 
Thanks!

>> b) The thing with the resizing of the parent channels. Can be fixed
>> by allocating the max number of channels for the pkey netdev. AFAIU,
>> `priv->channels.params.num_channels = priv->max_nch` in
>> mlx5i_pkey_init() should do the trick.
> I don't believe that's possible. The following commit prevents
> changing the parent channel count once child interfaces are initialized:
> 
> commit 806a8df7126a8c05d60411eeb81057c2a8bbe7a7
> Author: Dragos Tatulea <dtatulea@nvidia.com>
> Date:   Thu Dec 15 13:02:38 2022 +0200
> 
>     net/mlx5e: IPoIB, Block queue count configuration when sub interfaces are present
> 
>     PKEY sub interfaces share the receive queues with the parent interface.
>     While setting the sub interface queue count is not supported, it is
>     currently possible to change the number of queues of the parent interface.
>     Thus we can end up with inconsistent queue sizes between the parent and its
>     sub interfaces.
> 
>     This change disallows setting the queue count on the parent interface when
>     sub interfaces are present.
> 
> +       if (ipriv->num_sub_interfaces > 0) {
> +               mlx5_core_warn(epriv->mdev,
> +                              "can't change number of channels for interfaces with sub interfaces (%u)\n",
> +                              ipriv->num_sub_interfaces);
> +               return -EINVAL;
> 
> Can you confirm that the parent channel count cannot be resized while
> a sub-interface is present (whether UP or DOWN)?"
>
True. I had forgotten about this change. However, it is still possible to have
a parent created with > 128 channels and the pkeys created afterwards. And then
you can run into the issue again...

Thanks,
Dragos
