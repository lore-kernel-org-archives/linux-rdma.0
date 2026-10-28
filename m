Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.67
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793172043;
	b=RLukwPXSxsNEQbPz98wPEMEzYftFUBW6rh1F8fOF/g6agK2yM5YRAe2vtn2b1OXarLR9
	 mgL8KUWLaN+7n0nuBRaHK3138Wf6SE9iL5gIZmfMSoBbs3Psg3IgmG5ROEkdLzi8IA384
	 vpkpTQj2P4guGA8AO5ow6Li5RhrewN5nzzrSyJHuGEfMd0/qYxYCqeaIZWQDcOnY53Dfs
	 fVjvOTk/uYlSPXBWmFfqEzvCn5XNZEYLyniwpGw7w4vhyYaTFLkUwUGDT7yrjWXX28rjT
	 J/dW4WHNKoFlHoKtByBoFm3fx//7N/58/ndYzDkXglsOZOk6s8qF366/hJ2TclQ8CDg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793172043;
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
	bh=dd039E+fcyjQa0y4NMdYTJD5JLIHFu5O0cyXbp7CSks=;
	b=CxpK5BiYbBm68BlrEkU9IgCdO3gsOqYgb6jxN6+yMUE3NtS3A0Cn3i25rVVYOo7FwNhX
	 ysJWQZSPvmYMXRErAIIsR/yIKfAFTeaY/O3f7WwCXUK4NOzwiiU7iO9GcY1I4qwEdEBXu
	 TRM0xG5EquRIp/dtfW8BiX+lzDpuk28KG58Ta5zE8ZYbNSpJBrNSDFMJCKQNMhFEb5nq0
	 o03Ewyg5ZJbdQ1HktEgAbADKCMR4wZ9iRi5wq92zsZ/O1LnlBIeU1rNoTHbNQ7Ne9rkxa
	 u1pFhVHqiCMjTOWcIPMfdKtB+hqz/nDVasBnJ1Se4aTuMyQSL8R7taubrgQ1T6E5fkw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="mJrYg/EO";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.67
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011067.outbound.protection.outlook.com [52.101.57.67])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DECBC606A31D;
	Wed, 28 Oct 2026 07:20:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DECBC606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=mJrYg/EO
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fdGa/tnoIiiVJLR/AX//1n18vDkLtS4Y4XG+vv92f+UBHVpVWviaJ/MbKpthrfB16eDwR9Hib7fV8zaC+x8MyUyjrso8vs+JE3Oeo8kdZifnsg5sCuWtdlne5BNb0/dAY2hCfkp75v9AiwF7uOiWi82Tz0pUKwKBZo93PVr/06Uwz8HBcwTbke3oPWYoJ77UYggcpFSe+KQgCfs80w6c5q/iLtyTquB+H8a+JH2i4l0FH1KwVmtOk39XZOm5gj73aBVLRSI9WZovkpJHn0SS5Ltv5ELKnwlUu3X/sx74J/gDlzoOuSlPglm1HRuO2gbUV1QDcg2U+14EhcqqO7XoDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dd039E+fcyjQa0y4NMdYTJD5JLIHFu5O0cyXbp7CSks=;
 b=lJ4m5T8foSkxZZ5eIObcmbdssf4Mh4hvFS2G/7qHRlLM1Ss1OUDZBxYu+IE6Z6Gd6JeczfGYdijSXeLa5kSVmkrLjSNKmGaqevJ3PnOO5uDWojVnxqJ1D7TvQfGtaqozEqt+tXhE03q+cOnV/JkSV4HrWPhVGkd2/hzNE11cVSdeSTUEo3UtV2+toU22nYcQ81nERqzPqiw3oh8SWKqqFbapmy3eMXIxr5y79j91dXRR20c3/nN/rw0L0KuLonvCKmcYzyfzgHTp7XCIaIp1bXlZMr2+gnTV0U3rRqXlnDNzti+kAHAueKTrF2vmz0UP36LD26VcPdqwlfJ7ioVD0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dd039E+fcyjQa0y4NMdYTJD5JLIHFu5O0cyXbp7CSks=;
 b=mJrYg/EOKfH42zyfi5xhXRkpnFoQdqFtgkzDSEmmog2SrBBl/qBrf+WB3I6/RrNNlcMf1n8de792/tsUHsDUxEaWek5A5mtK8P8PUIc943XQXX5L3wsxtOXZpJR1DxQ9MOIMK1XcoOh08y3FJ9ERytEQFqU8157IW+LXIxzs927EJImksRIQ5D1ujiidLGsEeFihQwidrBn0vWGlCAzKH24QxGxsfHdRj/1MhoQt+FC0sM6gRapHmya9XvYSJraVTbWhc3PYvh7ToDprIOVMyY9/HnBJMN2VH8YUAe16N13+vGaif6yiIFqaQGGERPBgzTsfZHVPnvg/3aACC0NNjg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 (2603:10b6:207:12d::15) by SA5PPF530AE3851.namprd12.prod.outlook.com
 (2603:10b6:80f:fc04::8c9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Wed, 28 Oct
 2026 07:20:39 +0000
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f]) by IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f%5]) with mapi id 15.21.0569.007; Wed, 28 Oct 2026
 07:20:39 +0000
Message-ID: <90b2aec6-a473-4de1-9334-947e1a02c090@nvidia.com>
Date: Wed, 28 Oct 2026 09:20:36 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net/mlx4: always create the eth and ib auxiliary
 devices
To: Peter Morrow <pdmorrow@gmail.com>, Tariq Toukan <tariqt@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>,
 Yishai Hadas <yishaih@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S . Miller"
 <davem@davemloft.net>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 regressions@lists.linux.dev
References: <20261020164239.3808903-1-pdmorrow@gmail.com>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <20261020164239.3808903-1-pdmorrow@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0135.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9e::19) To IA4PR12MB932075.namprd12.prod.outlook.com
 (2603:10b6:207:12d::15)
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
X-MS-TrafficTypeDiagnostic: IA4PR12MB932075:EE_|SA5PPF530AE3851:EE_
X-MS-Office365-Filtering-Correlation-Id: cae80015-dafa-4dba-cab4-08df34c3f7a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|23010399003|366016|10067099003|22082099003|18002099003|261026140227099003|11063799006|56012099006|261021121427099003|261009223027099003|261021123027099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	/CbhKnNn1TkzvukRKKs2z8lhaymbE5Hp7bY5ujN4lSk8+yWucM8gg+TJ/Yu0iqt8yc86dKlZ125gqB+0HtlVZK2QNI5neovdhOZ4tvSHtnlQwByk1VVgLovnuIfpM5QZJI4b4GT9mqvtsIqTgE7/5cB1gNWScVXRoXoxOmKTmY9V9GT100d+mpKbay6+sjlxZsJ8rRm2zTJPCGSM1uAwfaNYHYISsd1dzqL3bJ8uExtlkhpPuRqrPxCbLvMbzp+/RHezpqjH1UFhZF4ETW8aJLRWqlNpnjP1eFEGGBpPLBcVPhA28+tj10/riG1enENsh/fXnvLSVMFnaRQITR3K6kP2PGDTfM9Rq4wfmn2MVsGDwq6W60o70uY+YFBnZ4jehbfDtgZguMcRU9Lr4b2YTEvtW24GITtaNmSyIlrT4bIgNK3L5EfnFz/DjDFIR9ENOqyZuCxJH9DIZcoR55I9cfZUYD/rgyhcCOrJBfdgeuQljp90uPWdXjogKYZ0u/FY8AqAk+Xit7e4sov5k5nQl280C0ei4RdnEpznGTfKCLBGCrB8DsGTSO2rSYVe71l1zoRZVxSR2dSIGbxmTbgFx+r905APfcnYod2hocNzSXdoS+Q5kESbAcLZqaBVsSZGxsoSxQu00CwtRYPvbnbzUXK97U9jCei4m10Q0mvBvL4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR12MB932075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(23010399003)(366016)(10067099003)(22082099003)(18002099003)(261026140227099003)(11063799006)(56012099006)(261021121427099003)(261009223027099003)(261021123027099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bGJLcy93bXFBT3JxdXd2ZDNOek12dDZGV3crWldJWkh4Q3dkZ2JtYnltM3Qx?=
 =?utf-8?B?R1kvdHN4emJmUlA3ZlhJMFZDVnNlTzNlQndwbEwrZ21mUEZKdzdVVjRLQTZD?=
 =?utf-8?B?WThCaytMSnM3U3RSTGJHck93WWd3QXQ1ZUNVVkdoRXhkbjVPTGVnd3JWVUJC?=
 =?utf-8?B?RHV6dWI0YjQ1cUZjNEowMzRObVUxYkQxa1EyaDRyWTVnWlVNRWMxZk1Rbk1J?=
 =?utf-8?B?VkVzbGt6djdtY2hGQmlvYlkyRHRWdE5EeWswRnFNbFZTaUIzc2NmRDZPbjBv?=
 =?utf-8?B?RWoxcEtBRFRnME9MRDdkZkJpSk1GSHJQdU9xR2l4TkMwV0NJSlJrMDVuS3Bz?=
 =?utf-8?B?RW5ZL3U1ZVZ5ZVFscWdqZEFlNHR0cW5hMDl5TXplN2lGeEFrMzVZcHMwaDI5?=
 =?utf-8?B?dzlaWkU2QldTSmQxRjAwQ1FBYmVJYzFNRW5BM1ZhQmNQNmR4c2IzeVdXWXph?=
 =?utf-8?B?dVBzVFZSekVKUnM5WVFnNm40YkhaL2UwV3pKamw4UFBiUCs3UlVVTW0rQ3pj?=
 =?utf-8?B?MzZhNlpyQUlDNkRncE9laVV4QVVoZHNFUmN4UVNaeHQyZDBCVklNUHlnUHdH?=
 =?utf-8?B?N1hUT1dQZmJaZEpZY1c2clRuZU1nVWNsQTA1VjFiMVhlVWF0NEhwS3ZkNVBY?=
 =?utf-8?B?ekVsSHJsZHBYMW1xcSsrckN6ZVJSblpXSGxFckZoUUNzQW1wUUhEOEN3Rm5G?=
 =?utf-8?B?Nmo1Z0pic1N1K24vRFhWeVQrcW05MlQvMFlRWHR5L0NETXplV3JLZlg3UHQr?=
 =?utf-8?B?dW9JUndXeGRhTXlSLzBSV2Y1N1Jwa3F3YmRQQVRwNnBpNTFjaEdpRURUR3Zn?=
 =?utf-8?B?V1NaWjlNZDFJSGltWUtJdzZxRGs2RnYzRWZaaU4xZ1pPTnMrcm02Z2hjTTRv?=
 =?utf-8?B?cGg1a2FDbll3R0tyUVN0Y3pKNmdlanM2VER3Unkya2NsZ25INUx5U0FiekxB?=
 =?utf-8?B?azZ5SGRpWFdlRjdrY1BqNHZYNDFsTzl1MDdBQTAvcGdUdUhWR21Lc2J6aG5x?=
 =?utf-8?B?REd0RFdWYk5RU1g4Mm5ib1BlN3JrR0RjTjQzTnFsdDlrdWZyK05IOXo3RHZG?=
 =?utf-8?B?MDVYTjc3bURzbFFsTk5ydUFYUVUvb05EVmRiUTdvdzg0L0tkQytRVUR6N2JI?=
 =?utf-8?B?Y2JxbmdTWlBRWkRvdGNETzFkemxnMUhtdVVhL1VXWDZQaGx2QWZaNzdjUWs0?=
 =?utf-8?B?MnRzNk9IcC91MFowZ2dHb0RGNEJnQ25YTWR4SytNdGlNanR3MVV6VVp5T3gy?=
 =?utf-8?B?L2I0dzZTb3ZTaGtrclpVMUJrWlF2QjUwVzd5dTFiK095aUdMSVFEbG0wS3BM?=
 =?utf-8?B?cTQzWDJzT3ZmQU9aSGNHYm50KzNQckFrQTlKcWJBQWo1aTZzY3VGWE9ybnpZ?=
 =?utf-8?B?RDNSazZSODMxUEF4UEppdGxMSElpeGNHc2VidFpxSWEvVTUrdUZueU12Nk9i?=
 =?utf-8?B?TEVpNzZrVDdKSGtXSDZKSE95VUJWazdwMVZ3R0dYYjNrekRVY0FsZ2dHWkk0?=
 =?utf-8?B?Wll4b1RJWWVNL1o4T09mQnRKOGFFL09lYWJzQVVaRkxqSkw0Y01SQ1JqWE9m?=
 =?utf-8?B?VXRyMFJoSWxvb2FEd1doMUErU2toQklubEs5eUFaSHlUbFFONE1sYXBrQXVh?=
 =?utf-8?B?Z253YVNsZDJtdkVmUkhkTklXVDQxVHVVcGt3UjNwMmpyRUpFQW1HYmRKdFpi?=
 =?utf-8?B?UW5iRW5TSGxqblJuUEoyNjdNOEtDSWM2WFZib3pYdGRaVU1jUlEzWm13Smlw?=
 =?utf-8?B?OFFubllqRmhZMG5pa2Jmeno1UHBzRzl2TXNYWnNYYWIwUC9oZWJHVXZPcXE2?=
 =?utf-8?B?Y3hCUlJ2ejN6Nk41VXMva2grekk3a0JhZDk3ZlUrbTBHQmg1ZzV1c24randr?=
 =?utf-8?B?K0ZFK0pHd2w5elNBZDNRdGlRSDgxZmRQd0dNbnZyR1p2bGUwSVpFWUE2ajB0?=
 =?utf-8?B?OXpmN0Q2RTR6eXJJT0c3NGlmSENOMEU2NTFOLzdaVldEYm1jaWhCQzduRVNX?=
 =?utf-8?B?aFduQ05SQzdsYThWaEE3ejlsWlJudndDSmF2RHVrZUMrUnZ2YWltbHltNXhW?=
 =?utf-8?B?OHJIa2hkcE1WVkRIdXRJblZxOHVLSllIOWtSOXl5MklOTDJ6VTJCWEtiSndm?=
 =?utf-8?B?cW1YZlQrVklXYkltUDQzNHdQa3JCYUs1LzIwU05EVmowemt4VTFTVER5cFRn?=
 =?utf-8?B?RUhmNC9sSHMrdzN3QkhWS1JUeFNHRGNPZklaRXdzd3RDd0srQno0MWRoTHpW?=
 =?utf-8?B?UmplVDZHUXNZblhzdWtsUzZFbHZoT3pKbEFTTk5VTnJjS2VlNjlDNHpsaXNx?=
 =?utf-8?Q?3zCJ7HZq0Lr4Dpr6zn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cae80015-dafa-4dba-cab4-08df34c3f7a2
X-MS-Exchange-CrossTenant-AuthSource: IA4PR12MB932075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2026 07:20:38.9512
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gW9xNjnqzOHKxalkNpwRoF/UIMUXH3NFjkjun+F3FlvsWmEi7w149fZ8BwA3qSSQ1UpU4W1OZ4ckMhMGvnWrYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPF530AE3851



On 20/10/2026 19:42, Peter Morrow wrote:
> Since commit 7d22b1cb9d84 ("mlx4: Connect the infiniband part to the
> auxiliary bus"), mlx4_core creates the "ib" auxiliary device only for
> an IB port or a device that advertises IBoE. Before it, each mlx4
> interface was offered every device and decided in its own add callback.
> mlx4_ib_add() accepted Ethernet ports without IBoE and registered them
> for raw packet QPs only.
> 
> ConnectX-3 VFs on Azure have an Ethernet port and no IBoE, so since
> v6.6 they get no RDMA device. DPDK's mlx4 PMD, which needs only raw
> packet QPs, then cannot open them:
> 
>    net_mlx4: cannot access device, is mlx4_ib loaded?
> 
> Restore the old behaviour by creating both auxiliary devices for every
> device and letting mlx4_en and mlx4_ib decide in probe, as their add
> callbacks did. mlx4_ib_probe() returns -ENODEV when there are no usable
> ports, and mlx4_en_probe() binds a device without Ethernet ports but
> creates no netdevs, as mlx4_en_add() did.
> 
> Tested on 6.12.111 on an Azure VM with two ConnectX-3 VFs: each gets an
> eth and an ib auxiliary device, and DPDK attaches both VFs and passes
> traffic through them.
> 
> Fixes: 7d22b1cb9d84 ("mlx4: Connect the infiniband part to the auxiliary bus")
> Closes: https://lore.kernel.org/r/20261014133951.3219055-1-pdmorrow@gmail.com
> Suggested-by: Leon Romanovsky <leon@kernel.org>
> Assisted-by: LLM
> Signed-off-by: Peter Morrow <pdmorrow@gmail.com>
> ---
>   drivers/net/ethernet/mellanox/mlx4/intf.c | 15 ++-------------
>   1 file changed, 2 insertions(+), 13 deletions(-)
> 


Acked-by: Tariq Toukan <tariqt@nvidia.com>


> diff --git a/drivers/net/ethernet/mellanox/mlx4/intf.c b/drivers/net/ethernet/mellanox/mlx4/intf.c
> index 82e467c..31860b4 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/intf.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/intf.c
> @@ -43,23 +43,12 @@ static DEFINE_IDA(mlx4_adev_ida);
>   
>   static bool is_eth_supported(struct mlx4_dev *dev)
>   {
> -	for (int port = 1; port <= dev->caps.num_ports; port++)
> -		if (dev->caps.port_type[port] == MLX4_PORT_TYPE_ETH)
> -			return true;
> -
> -	return false;
> +	return true;
>   }
>   
>   static bool is_ib_supported(struct mlx4_dev *dev)
>   {
> -	for (int port = 1; port <= dev->caps.num_ports; port++)
> -		if (dev->caps.port_type[port] == MLX4_PORT_TYPE_IB)
> -			return true;
> -
> -	if (dev->caps.flags & MLX4_DEV_CAP_FLAG_IBOE)
> -		return true;
> -
> -	return false;
> +	return true;
>   }
>   
>   static const struct mlx4_adev_device {

