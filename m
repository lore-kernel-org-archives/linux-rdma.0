Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.27
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793962533;
	b=HyFqNkocFpP6rOXdNcI2K0mkT4WqEgKogQBFMrKYfVBC9uExTvfGfg1TuIjRty4rlkwG
	 RMJ4dAuYx0KnPfvzg4Tk+bJnunjdA8Bv/tSQlar7sdwUtbB8HXUelOSLuhtittyqiZh0m
	 SkUk7bR6jgnVlKoxfU+EZ7J+aOuh9JRKBH1PBvSGSQAMnXCJmUNsvaxsiglFeBMZLSUHo
	 I9j7US80BgX5zBkbh/K/sVyF/LF7XCvfqjxOpLie77XTNQzbyPrMblthww9Bsp4EZ3Qn2
	 mDqyl9aqesjrNbMv3PlH0dVtCAsDr4iNiMWDX132WESmkwY2p9puaGhOWT7UXhEIvfg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793962533;
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
	bh=uGZytvjQ2LGCTIdaD0reQddOhj/oAgoRA7PvgWIRKXI=;
	b=rhJHor7bjC+3jTAB2AhfDlKNjr73hFDoqU+Jxnbz6tEC3ia+v8wr0yyZOqJsbruncGQ7
	 pELyF4PBkvT6r3FCOnkewCAkyXjz0vOS814tcm0ezLJvmpVGL2HGQ7yvqNGmxRbMnXzZT
	 TBfzqlDYgtMeFFrrp6ezaUVKAEykUeb/E3HjHUUfKFkqGcj5TvYUwvaVuMS9+kJswvDjJ
	 XD8438/xc6yAv3vCg9H7hP64Hy9vAMEyGwUEokgDyh4eJ98Bl/7anEhT4AgMAg94DIjo6
	 ZifBFZxF2i11Ix37WcOZjSWWvxK9rlt2gAgb/4LRsMreHmYOpW/G+w2c+A7J10Z3mCA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=SJlsyueq;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.27
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013027.outbound.protection.outlook.com [40.107.201.27])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D814F606A326;
	Fri,  6 Nov 2026 10:55:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D814F606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=SJlsyueq
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TPJTgUMfgzbIp6Z7i1+yRB3GeRWMP2V9pg0R556liCcNQhaAjSMzbPeg0GfTiK6Hjm2I2KOBsgs9bBAgOu3EkS28/cVxW2ttCM39dbtKGRpzme61e1Up1+J4aYKNprr2IY4tToa3e7zvW20p3oVrJgDoviXIognqgganm6ZqiadodWzHXaTzTspEQ9OHbrLhF5+FfSwdk8+yjYyRhW3qdX6TP8mRRyZy6CgPupExjJl/Qh0xktzScLf8oXjHcH5leQPesej5d4/Cr2YZT04dl/2gfYytmQW/NixF3ignN6ToPcGXPHIMZx8IHTmTcA5EpL3Bqnz1Q0XZNsvCV6TBNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uGZytvjQ2LGCTIdaD0reQddOhj/oAgoRA7PvgWIRKXI=;
 b=EuP7ZGE7x3SSGiN2R1HpYKFdZvG0IlsX3Oip+puoDe+lNc7nJreU5VVVytAzqTFRhMl0QyFaeEKhnN+cKKPXxmG+R9mZCSWqrZWr/cKdqa+J554xYEPPtTkbuGQnpzfL8H82tdx6d703D2A4S11SlLgA9MozuIOUBxKlMdpPvyAYwdVJRhGKa+u7X1rZisdekRUKyyLt9fSkJuu2Y9314zPkfFzNBEjwu4TKrn6dVXWLhgZIPsR5Li1gZzHtX/JiDVodvERNJhLG5WfWL6popzfukjLg34w1SVv25jBjFNdCK5uLF8y9+lLJdP9bsAFVONiYw4M7x8VuoQnooNxBWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uGZytvjQ2LGCTIdaD0reQddOhj/oAgoRA7PvgWIRKXI=;
 b=SJlsyueqYaEjOM2Dr/MrMn33ZkOHSee+3ppHDv8uXNb8iCSqEgozK3+x2HjWoER3QYGPevcsF5/UUS9dCzIITjCgDsQ8R+I7yk2Dh63v2MWrZ1cs3cSXk5HCJGB1aV2wPkoiqVcO87MPdCz1O+jcErkSq0M1TLTwTQZb1xXz9Gryn4qx0zO7Hht6jP8hiQevIh8YyIWpFhCLV8vfgv1fwCW70/rV+ABpdNY9nM1zdS/t95fBEB6bFdQh7gJHONtImirWAB0Au6UWDWo2wHiDhIJd7nHW1cQu90l2nSrTzJyZs4i8iQJtTADYa7ScmkUI3AdJ0kAiZk8slIjsjrfvEw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHAPR12MB999248.namprd12.prod.outlook.com
 (2603:10b6:610:2ff::22) by CH8PR12MB999204.namprd12.prod.outlook.com
 (2603:10b6:610:35a::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Fri, 6 Nov
 2026 10:55:29 +0000
Received: from CHAPR12MB999248.namprd12.prod.outlook.com
 ([fe80::4972:8062:d74e:b205]) by CHAPR12MB999248.namprd12.prod.outlook.com
 ([fe80::4972:8062:d74e:b205%6]) with mapi id 15.21.0592.009; Fri, 6 Nov 2026
 10:55:29 +0000
Message-ID: <a31e1e60-7e31-4a14-a087-428d1e3627f2@nvidia.com>
Date: Fri, 6 Nov 2026 11:55:23 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v2] net/mlx5e: Prefetch the packet a few strides
 ahead in the linear MPWQE path
To: Antonio Quartulli <antonio@mandelbit.com>, netdev@vger.kernel.org
Cc: saeedm@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com, leon@kernel.org,
 cratiu@nvidia.com, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
 daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
 sdf@fomichev.me, linux-rdma@vger.kernel.org, bpf@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261104195241.1883539-1-antonio@mandelbit.com>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <20261104195241.1883539-1-antonio@mandelbit.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0137.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b8::17) To CHAPR12MB999248.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHAPR12MB999248:EE_|CH8PR12MB999204:EE_
X-MS-Office365-Filtering-Correlation-Id: c2fdbacb-5eea-4100-6315-08df3bf4787f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|23010399003|7416014|1800799024|22082099003|18002099003|10067099003|11063799006|261026140227099003|261028144727099003|261026121527099003|261022113327099003|261021135927099003|261022075727099003|261022105027099003|56012099006|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	u8KFR/D3ZdPlkG640a7VXPYRoSMuraiF/cpMYlJNdSvaBXRl0l9R687rzHSAVfp8GQ0fdoiiG3/wevmzAqLI5AQ5d326xGssCFxVAcmXHfDl5xOR2hnJQ0+++jamEJRJh2itMxoSuXYYAACCRsLyvc6DtKHYFMgAZrHYPxfftDkNVgQONtYZRmr5dLWd0bUoVMKjQVQb9P4HesCIN7m0zK9P3gay8Jyav0w/i4x0xyAfu346nY8bbcjxV2JqlT4p4bLHd05X09+9Vz4n/D3x7KS3VVn6h5z/VugiGcBbWDx1Ml3KziMTPb2vLjkUaqij83PbqsRBbA9tSsIVQIdrMzudvE2Tms8b6mqz9iTIBUUfgoSY4hH06TFxYFz90SaNi2DNY9FDrWSCJRE8coaCsJtgoOpqYH2bdFLNpmoF9jePhSFHhw31WG2LdqqxVbM2hbuuE7v4zspbrpSIMF0QBEypEQFNt7n3+44ZlUCiRMtKA74fcmtcFMyymKu0APpdkh34+c6yWbu60YZ24EZWsBf1+LBo3FL7CyKz33gptjfZWMsSPY0mgaSlaOlpMdSZB9mF8esseS9EilF8k/rOt0DI72E0dGDjQKg5/1EFXLfOjC8XyI87a7abvCEB6zLDoTgK5NYCvOHlduWeyM1+FlpV0t1yY2q/PZekpVgexsI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHAPR12MB999248.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(23010399003)(7416014)(1800799024)(22082099003)(18002099003)(10067099003)(11063799006)(261026140227099003)(261028144727099003)(261026121527099003)(261022113327099003)(261021135927099003)(261022075727099003)(261022105027099003)(56012099006)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RVZLem5sdXV0TDNaWlpwSStibktGMmQ0OUZXcEpWTlNoSEthZ3RnV3FtK3c0?=
 =?utf-8?B?TVhSWjFLazM1LzZJQy9xbVdwTnBpWlQwRGQ1T1E4K3BVV3ZzeHA4TFM0aE5L?=
 =?utf-8?B?LzhlSXkxVXVNSm1tUzd3ZFhobGFubXA5ZVlmb09KZVVVYThKdTlWVEhxRGtS?=
 =?utf-8?B?UnR0VFA5b0VyZWcxMFhkSHA2dER4VTVtOG9KOFB0eCtUTXhxOHl2cG1KeW5L?=
 =?utf-8?B?ZExXdDFITTVJZm9HcmR2OW9UUDIxRjNFRnZjYkhGd0d4TmpaVTE4Tk9ZNHkw?=
 =?utf-8?B?S1JZL01WUGREYXlxWEszbC84eWg2Z0NRN3hTRExkWEJjdDZORUdka3pRc3Ro?=
 =?utf-8?B?ZXBVRE5Td09xRWRNK2ZQZFplaEMrZDJKOUlHelNheTUySWFNT01DdXpDb1dX?=
 =?utf-8?B?Tk1hMGIrL3JRR2c3WWlmZ2l0UlgwV0hRbHphN0laSTlTdFNvSStOelk5V2Rl?=
 =?utf-8?B?aTUzVGlqdVUzaitSYmVtN0VmUHBRTnUzYmdtc0VGazJMVlQwcFJHQlBya0Vz?=
 =?utf-8?B?amgvbkgzRjJtYW4yOGVrcGlabS9xRzBKcHlwU1NlV1NuMlpCVXZUNVh5b3pk?=
 =?utf-8?B?L1RHaWUvZEdiUFFJaGxTN1pUWG1PNjBmYmZUM0UwL0dtZ1NqbFN5UE94RVZB?=
 =?utf-8?B?NnBYcEhsZncvRkpiV0tjSGRnSlJJQ3czOVIycHI3cDVwRGc3dHNFZ0pqZzlt?=
 =?utf-8?B?RDVIaWM2ODFNZlQrUys4bmUyK0VaNlQ1TGp4N24rVDdZZHZ6NG5Gb0sxMm9q?=
 =?utf-8?B?a2dmWUQxYmN6MmF2ZzJKZ0pMdTJEMVNsdktrd3gwQmR1VlkwUzNNbjNENTZ4?=
 =?utf-8?B?UWRGUXE4UHlrTmVURkJWLzJVeHQxcStPNTNOWWxrZy8wUGlEeFc2UEcyd3ZS?=
 =?utf-8?B?R0tXeEVHeExhTDBKc2pwUlZTNnB5Q1FIL1Qrc2Z6Qzc4ZnNIVmorQy9PeWQz?=
 =?utf-8?B?WnFNRXY1RCtFRmRrSXJEdklZKy9XWk1DOGlWU1UyMzhvQy83Z2xKTEpTUlJY?=
 =?utf-8?B?V0lqc05LRC84dUFTVW5lcjJBN3lIUGpoWDhjR2lqTUh5cHN3V25uc0dJUWk3?=
 =?utf-8?B?Z0hLNHpqRGNCSTVkZXpaZHJPaXdyQWZUMU5KcXRxWXh0N1Q4RkRZbEJyc0V5?=
 =?utf-8?B?VmZ5YVRacDhFK0h5b3BpZ25Fdm9mNjgrTHFURXZjOHBFTnF5MjZqZ0I1YW1o?=
 =?utf-8?B?L2VMWTJUeGczOWNaNEdseDFiSUpXa1BHM2ZRdXJYMDJEemduaUZKT0tmNVlz?=
 =?utf-8?B?cmtSVnNyMTE1TEpFd0lUV2pXOTlVT0FFTnNUUlduLzFqTC9JVnZWVUNUT3Vx?=
 =?utf-8?B?NE1sV0t0UHhkLysxdGk2NDhMVjBsRUlVZURabmVDV05YNk9lVnJsVzVRYTRx?=
 =?utf-8?B?QlE4dUloanVMdk0vaHhrNk92ZHF2L1dpQklpOUF5YUVTY0V1NVAzUHp3RjZH?=
 =?utf-8?B?VTNHMmxaVU5OR1FUVklQY1N0dUxBU0g0UG9Ya3lYc094bHpLczJqbk9qcWZi?=
 =?utf-8?B?VS9ROUp6Y2w5YWJOdzN3amdiekpJSFE3d0lldDJnODMrL3FISWJuaDBDY0R1?=
 =?utf-8?B?Y0FBSG50WEdVd2V4a3puUUsxRlJlWDFGUnd2UEtEYnpUTHFJTnZwSlVVMm5l?=
 =?utf-8?B?ZHhtUzViRW43ZzVMUFRsRGNTRk9GNk9lMThOQXZtOTJwSEE5MlhqSnFTYUha?=
 =?utf-8?B?MDg3Y2E1RUFZeEc1TDZzOE9NZVphVGZ1VC9BMTRQNWxpQkVCbk5sMHlkb0lx?=
 =?utf-8?B?S3BEM3hlOXRzbnhYMnJwSjJvbGhxVWZad25RQVBpbVBOSWFnNVE1UUdFU2Rq?=
 =?utf-8?B?VWc0YXRQaTE1Vi9EdmVnSk5lanZhZjhJMDUxZWhnSW9mR1ZMU1h6aDZXZnRF?=
 =?utf-8?B?K3NEbkNZK09TQ0VjSzFtNUNXQnExdy9zM2ZkTSszN3pZZXFtaENPV3FzbHpi?=
 =?utf-8?B?MlRiNWoySTJFRGhQQ0t3dGxQMXorQ29zelRZYVhKMzlxVEZmeUVBaktrd245?=
 =?utf-8?B?RW1ROU5GWTJpYnRseXdSL3o3ZGhTSWNRNFhPZTcwRDV3dDFSSGcvK0E0NWkv?=
 =?utf-8?B?RmM3QnpBRWZ2U0J0djBUaXV3YU9ZenNVekdSZ3JWZlNxcEs4NWZXZDBWU0k2?=
 =?utf-8?B?bGgxWVVncnVZeUtDZmcwemdvdFlNeTl3THJjaHM2cUV5NVdBdVE2WTl0c011?=
 =?utf-8?B?TkxYTU5xV0cxeFdTbFdFMGJRbUdsYVpFTm11NmtLSlN2ZmNabWhhM0V3TkNO?=
 =?utf-8?B?a0laMytYNVhldEtqMUM1c3loUEYzRmhvb0QxQVRtYUNRRWFtUXpZa1ZXT1JB?=
 =?utf-8?B?RDhQZlZHMmE5OTFEQk8xOFhycE44TklTK0RFSnQ0VzBrbTVhZkpLUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2fdbacb-5eea-4100-6315-08df3bf4787f
X-MS-Exchange-CrossTenant-AuthSource: CHAPR12MB999248.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2026 10:55:29.1380
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q5Lcbgk5/1BNItBc+5niAnPPrNTUCY0ZNQTZVcBZmSu1L9rkmZpbDkkYXuReK71Xr13YPQ83M2cSVkCXHqEIew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH8PR12MB999204

Hi,

On 04.11.26 20:52, Antonio Quartulli wrote:
> Without cache injection (DDIO/SDCI), the first accesses to a received
> packet's headers and skb_shared_info are DRAM misses, and the
> net_prefetch() in mlx5e_skb_from_cqe_mpwrq_linear() is too late to hide
> them. This caps the packet rate of a queue.
> 
> In the linear striding RQ path a packet takes one stride and the device
> fills the strides in order, so the packet MLX5E_RX_PREFETCH_DIST (4)
> strides ahead is known without its CQE: prefetch its headers and page,
> and the line its skb_shared_info will use if it has the length of the
> current packet, as in bulk flows. That line matters when every packet
> becomes its own skb: TCP inside an ovpn UDP tunnel gains 34% with it and
> 4% without.
> 
> AMD Ryzen 9 9950X, ConnectX-5 Ex, one RX queue on a dedicated CPU,
> MTU 1500, mean of 3 runs:
> 
>                                    before       after
>   UDP 512B flood, pktgen         2.52 Mpps    3.44 Mpps   +36%
>   TCP, 1 stream                  44.6 Gb/s    48.0 Gb/s    +8%
>     NAPI CPU cycles/packet            1334          715   -46%
>   XDP_DROP reading the packet,
>     NAPI CPU cycles/packet             409          280   -32%
>   XDP_TX, NAPI CPU cycles/packet       829          554   -33%
> 
> With the change, the XDP packet rates were limited by the sender, so
> cycles per packet are compared.
> 
Thanks for your patch! These look indeed like enticing numbers. I'd
like to take some time to try this at scale and on other NICs (CX8)
and CPUs (Grace) and also check latency.

Thanks,
Dragos
