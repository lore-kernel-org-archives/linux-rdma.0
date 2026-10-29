Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.70
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793301540;
	b=NVRAuo8nXGx+Bo/SiEVbYIoQh+unWarB5eVeOuZU7/Ur3Z3M3J/YhBHPSVE+DChl2kg0
	 EouK1atgraNroeASYgLN+hTinZtlxLoDrPUNOsHhHJL/R9mUQRsHvxYOJaruApKDTRbq+
	 8ZClbrNXh+X5SZHeZgd/77E16BeVUrvjrFRVYCR6hRGjpuXxlMMGnKL5lnXfx2iJemLk1
	 pe6nehcAddcQ+Hkm70LBxBO8kY9o5p0k0yYcnCeEgHSNFwbYv3Td42ak5wbseQIIpXkfo
	 TpLd+Z2rif1wBQ+bqcgTeqMlxHpD+yP3HiQToev7EcbOFe3Av9ri87cYcSxx9N+xp9w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793301540;
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
	bh=sydhMz063TTkD0jmONClhzJSbYeRN3rpNiBAuzwSjoA=;
	b=VHq6ssChNqjVSnjaQ7I3sY+KQlyb6tE9wm3yBVaRQGO6VnMamJMxg1jAZD5xSigoS7BM
	 716gmm7cfl/0lRe4PJN0oSKuT6SdkJiM1msG/6VmcyRY2AgD9/nmyckH3vwhwh+Uvooru
	 ECQeUVgOytoBXkKlQoeokz39zov3Yhh34c+kzgIdf25FAwjEbkOOFA4FItMcMsaHmh/35
	 +r5BrxSo7LLBvXuQw+ZQICYDSp4QK6CDxKKfpVPqei4z8czjeUFO5S523NPnr+6fDjI0X
	 unXtfRiAZjUktU47srgVcz2zhxSMGqVikyxgG1QY68xSjofbQyZ6iARmndCIGK3D0Mg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="r417/m6F";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.70
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012070.outbound.protection.outlook.com [52.101.53.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F16E606A31A;
	Thu, 29 Oct 2026 19:18:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6F16E606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=r417/m6F
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g/jrLAA+829qvrqXzxfbfZVP6g3xatvzblcjt1MJ9sN/5y4dEHjCrEjjHpI6Rikh0RNc/WTA1MxrVSqp9Op53c/bxjFm2Uc63zAO+qq6CiWPqPfvGFcS2q5XVbY2SPBQhEc9efhbUpEJsIaxOwjDR52OSrG73hJkKLQ2v6t891HevddGLeZem7i6hsWfPHMdaK3Xq+E7Q6XTFPBc5Pdbb3VeqEtlU/lhts9gUHKMWIToA9t3SzYHGk4YMiAxbOYe1QNoy1prhHI2hkUUrE/WGmjiwnr4MEjiWZ2sDvNGzKj2KnbMHNdfBI1vUUsijs75i5G7dkj2XV29TWZaOspG/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sydhMz063TTkD0jmONClhzJSbYeRN3rpNiBAuzwSjoA=;
 b=jHXNcjQj0Hr0BxQWcUgov4sPzj2TywINKBGcT/Ge1A70RWKLSqp+2PnnTk++h04DdK3wYQAIWTVYNbY9QmryBQBE7ZMerkrJlW+CcZG72LptY9v+O7eEPiedM5IszJVJB31WVMu8rbh+hE3ZqJUvTJB4DdBg+5iLkDLdLEM0gt7I3EpAIDP6lQDEg8H1xH+7y56OyZs5jO8EYCpGkLvvyGJB1jL+eyNtq6boJBDDOAaGW4V4jWBYBJSDYfthtgwX2UXDMzSWaV5JNzyUk6ZwJ7k8A9hCAeU0H4DES2vMgQFqJjyjX3DC2iZT6UUWwOD8W0eeT03MMFuInZSIVzknaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sydhMz063TTkD0jmONClhzJSbYeRN3rpNiBAuzwSjoA=;
 b=r417/m6FHFrSYq/wCgM3O+d7WExv4BTSM72klXVGw9Qy72ocaFo4Tn2coGYvLU4ReELWgNaI4AxHWA9p+t3pTX3Yr+6yy9+2aaSAD57EP46tEcMAPFojs9BACgPyqurdODBTePFls3DWk9oiw0E+O57vea6CC+vYwqFJ1DewLV3ntDzJUmtbkPUMkgIH/yTiQ9Zwkcxc1QDs/55HjAQBHVBX4iDF+2szUHM32lyz/oZtSiI6/WVS+mvK3c9ZNYfuJPAjuMNj/mthEMdTQOspCg5xYLE26BiZd9CpxC5/JYJCdhKj/7N5II18r+sM01CTd/lAroCpnreASRHxslOzng==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB239779.namprd12.prod.outlook.com
 (2603:10b6:806:5a5::7) by MW4PR12MB6683.namprd12.prod.outlook.com
 (2603:10b6:303:1e2::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Thu, 29 Oct
 2026 19:18:54 +0000
Received: from SA3PR12MB239779.namprd12.prod.outlook.com
 ([fe80::2ac4:299a:52e3:5d9c]) by SA3PR12MB239779.namprd12.prod.outlook.com
 ([fe80::2ac4:299a:52e3:5d9c%6]) with mapi id 15.21.0546.021; Thu, 29 Oct 2026
 19:18:54 +0000
Message-ID: <28a237ce-f3db-4081-95bd-cef4b9bde369@nvidia.com>
Date: Thu, 29 Oct 2026 21:18:46 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net V2 4/4] net/mlx5: Lag, save and restore vport
 max_tx_speed across LAG
To: netdev-bot+sashiko@kernel.org, tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 bhelgaas@google.com, cjubran@nvidia.com, cratiu@nvidia.com,
 edwards@nvidia.com, gal@nvidia.com, jgg@ziepe.ca, kees@kernel.org,
 leon@kernel.org, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
 linux-rdma@vger.kernel.org, msanalla@nvidia.com, mbloch@nvidia.com,
 saeedm@nvidia.com, shayd@nvidia.com
References: <20261022193053.3815866-5-tariqt@nvidia.com>
 <179304673356.3134.5707726348290129321@kernel.org>
Content-Language: en-US
From: Or Har-Toov <ohartoov@nvidia.com>
In-Reply-To: <179304673356.3134.5707726348290129321@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MR1P264CA0190.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:57::13) To SA3PR12MB239779.namprd12.prod.outlook.com
 (2603:10b6:806:5a5::7)
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
X-MS-TrafficTypeDiagnostic: SA3PR12MB239779:EE_|MW4PR12MB6683:EE_
X-MS-Office365-Filtering-Correlation-Id: 43fabd35-a26d-4632-fd79-08df35f178d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|366016|376014|1800799024|261022105027099003|261009223027099003|261022113327099003|261022075727099003|261021121427099003|10067099003|56012099006|261026140227099003|261028144727099003|22082099003|18002099003|261026121527099003|11063799006|4143699003|5023799004;
X-Microsoft-Antispam-Message-Info:
	TnY32b/t1JJdK6N74UmbWZHdtFpRFA0x+wQJThEng4dS0ONR2FF+krOD02lBHdms09vc+sqgY45rQBKxKdzQUdGlawRF/fs5NjCY7048mfSpqmTm0tR1qBj+Q8W4D4OLzojXy+qzLaSqRpN+qh1AyL5tXy7CABguOt9drD1dzNOfps8zKFMtyFrmyM9VzGSHe0zAd8vG9QG03kzfCkVud9zqKNFiQxjxVs8uiWo6lXbkBaxxapnAt/ZeqLTGgINZV+HXLZ+pEb/HgzZ8/ARhqUagML98zkLZG+ZbI6R7YKN4GWeWHoWr7Ujf/XdlLc7vB75Oj7IgpON+PmyG7HjNalnH/sfxRElGAdGVWv/ovRdMRcRXgQd2ZZBcdJOsb5/ZiP+NnD1imaLBDAyHmBgusg9wfM1tAowA3GCfgbmwWOoAkJe9zjXncM1YDFYEhok9dkdODyqfmNxjs0QZ0CidFYkqfJczaOJSlT70ZCvsKYCyBOXK4IkJ/uc080RohMSGrQSrawnpsmzCEnlb0iCdpVcAQ0/Z5mFp+A6eZxsZQkh0okYRgqCpdQngpRrQq8TjwEHBL93ad14c4qcM1zbjN5JqaFRwb2kaMCVFq6UQeqUdc2l99BbQJz2K6XeyVhPNoih/7GN6XMIwZv0H08MbSSPSAylFM57D8FDzuaici+E=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB239779.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(366016)(376014)(1800799024)(261022105027099003)(261009223027099003)(261022113327099003)(261022075727099003)(261021121427099003)(10067099003)(56012099006)(261026140227099003)(261028144727099003)(22082099003)(18002099003)(261026121527099003)(11063799006)(4143699003)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UWtBei9zSEZtTmczemRiNW9zVUQrazlvY1d1VlZmMzRlWEdVdHptcnhxM2U3?=
 =?utf-8?B?ZTBiaGpnUHVpSkd3V0twRk1VWnVJU0kraTFxVmlGUEJ4cFAxVVVmU01pMWxw?=
 =?utf-8?B?d1hRVXF6M2s3enpZQlp0Z05FZnFxaGF1aXZGSWpzbnpTRlA2eXlxNVBnRjNL?=
 =?utf-8?B?TXJ2TmxrcFdBZ1NRckxmR3dTZnBQRGxFSDVHRmtvYm5mNENVNDlHeEFXVVpj?=
 =?utf-8?B?TS80eThMeVQ4dkg1L0x4ODJpa3VtWmlXenRvcm9kVW80NGdNSjNieUhKL3Bw?=
 =?utf-8?B?TGMzYjFJOExyeG1EVmpYdnZZbGpyTk1oMVJROGF2SjVZZmcwa3lQL2hKbHFZ?=
 =?utf-8?B?L3RYejlhTmhaVlREVGFwQXR1YndMZlVpbmZzMHFhNmhIYzV4Y1NWM09GblE1?=
 =?utf-8?B?dmQvd0EzYTdDK1lTSTBwd1hTd2RoTWhPRFdUcmo1bUFwNXhRRC9rVVI4all5?=
 =?utf-8?B?aUVrK0VuRG9RVDhnQ0VxV1JSRjN4SkZGSkhYYmhFUjdMT3lxQmRCcnUvbWhZ?=
 =?utf-8?B?a2pHc2dxbnVqaEJxL2F6QnpOMkxFZ1FtOWI1b2o4Qkp6bGhvdXcyWlYyZHFj?=
 =?utf-8?B?OXVUbWxRYmxITDVkUnNucG1TdFRFTkt4U2dBN2JLTmFUdHhkeWhXalA3cElR?=
 =?utf-8?B?dHkrZE5kelo1ajFqVTFMR25seU5wUTdUNi9wMkhvY2xsRnc1OG81SjlQZkhT?=
 =?utf-8?B?akUvV1NmZkFEKzZPREdoNGljbzlMeGd1WHBNSGpUVnY3clVlTE12MDdCMEd0?=
 =?utf-8?B?M1NETXpCU053bW5iYTF5YytlY1NPUEt1MHFxemZWWThrRUVGY1doVGxndWhG?=
 =?utf-8?B?Mk5sUjVWR0xISlhkOThGSTkxTGNBdmVjaS9GVXdVU2EwM2hoZ0V1MHdFanJ6?=
 =?utf-8?B?anVaRDVVeE93QzhJVXF5MC9rQzNmZUxsTUQwVU4rYnYwZndPN0NUQURyc2RP?=
 =?utf-8?B?MDYwTm9wWStwTXVrYjJjNVhnYkFCQmxVTTJ0Wk5RS3A0MExVRkw4d3o3VTRD?=
 =?utf-8?B?aXRnc1g0NEtyVEJRNUsxbmxjcHhjUXEvSSt5aTRlUDRXNDBybE5SQjVIOW0z?=
 =?utf-8?B?L2hreFViUHA5L2cwZFFJQ1R1aDNZck9vM2dtTUtBbStNZUMzYXBEMVI3YmVu?=
 =?utf-8?B?R1JXcTZNUkdqdS9pQUhuWUZtcXhJUGNpSHJVdVYwZ0poS3Z1YWxDV1owRXlP?=
 =?utf-8?B?cEFSdWU1UDVERGx5UFB2dGRwV0ZzcWF2OFRibkVvZjZ2S1NFa1FOazh2V1J0?=
 =?utf-8?B?WHhma0FpTzlJNlRUdVdKQmVJU2hwRWorRUlqSlJnWnNzb1dYSG5OMVpLWTlG?=
 =?utf-8?B?QlNTamdtSVlCanpsUWJHYnFTVjZ6QWVVUk1laXFqNlRJRXBsRWxTNWdVRjJZ?=
 =?utf-8?B?Tk9UeWs4TEdkQTkzdS9iclFBUTVVQzFxNlRxM1BHN2RLVHlEZzJTZE9qY1A0?=
 =?utf-8?B?dTdLSG1waHkvdjRveGtWWHVDK0tCK1BEWFQ4bFpBZll4NDkrZHlBdGJmQk5l?=
 =?utf-8?B?ZHppRFdJTUVPNTdXZkhZM1NnUTNXT0JmVkpHWVVwVC9xQnZ4T2V1MkZuT0VS?=
 =?utf-8?B?TEs4anJSRVo5VFNneVpUcUdnZFZIbWFXOWJyZ25KZGtNcytZeUFleG5mYWVC?=
 =?utf-8?B?WEoyeDVXRHNoZ2VzbFdDbXU2a0JBTHVRbUEwQ3RCYW41SnlvUjhPN0NiN0Yw?=
 =?utf-8?B?MlRyTTdSR3RMRVVhWmhTaU1HenRUbm55eERSUy9JY0xzUmJsUDM0ODlSNUh2?=
 =?utf-8?B?MElQWThlai9ONXlVaFpicmJKa0IzWjBmQW50Z1krVVdBT0ZmbDhiemxKOHpM?=
 =?utf-8?B?cmZSRTVwYkN6ZldTVWZuOTNZcWZOMkpqa2paQ1lvRVpvNDZUNEVhT0NDV2d4?=
 =?utf-8?B?eFpMeVJvVTRhNmVma0JORGMwaElQMmVML3d0Wi9yeEd3MEM2YnUwY1NZSU1L?=
 =?utf-8?B?Nk1UZU5DMWJlN0NaYlErVytqL0RjcGNwQVUxRFRFTGhKd3d5a2ZPUzBTVDZT?=
 =?utf-8?B?YU1Bc1NISTRjZkJhdU8zV2J4Nm9zSERROW1pL1NpZ0hPTlpEUjczcHZhcVpM?=
 =?utf-8?B?ZjNpdW9WbFYxOHY5SWxWL2NLT2NnSG9sOENrVFVrRXA3dGlCd2hnRWM3eWli?=
 =?utf-8?B?OEZibmREY0VDeGpZN1BveVhxWTdBQWxEdTVyR215bHNjWkZHZlJLZ1dGTVV1?=
 =?utf-8?B?bGRWM01TaUxXZE9lcUVZazd1aVpURlV0N09UODBVZitqLzlmaHNNSlZWTDNJ?=
 =?utf-8?B?NG0wMVlsalYwdGxKbVhSMlF3MUVIL2dheXRld1M0RkVVWHpvSURQRm1CZHdF?=
 =?utf-8?B?MmQ2Nm1lakFhQzBkM3ZJcHRlVi9XNjdnaEl0Y1c3bm9TRXBubW0ydz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43fabd35-a26d-4632-fd79-08df35f178d0
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB239779.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2026 19:18:54.2320
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sp3rO7HWyFRnqCos7kTbQkpK/8ztsNYyU+hEF8pcthINjTZgWRFgeVnuK3ED8Vjgzj8+DksTmkS7N7ZB2mt8Yw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6683



On 26/10/2026 22:32, netdev-bot+sashiko@kernel.org wrote:
> External email: Use caution opening links or attachments
> 
> 
> Thank you for your contribution! Sashiko AI review found 7 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 1 · Medium: 5 · Low: 1
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [High] mlx5_esw_vport_save_max_tx_speed() (eswitch.c:948) treats a non-
>    zero agg_max_tx_speed during an active LAG as meaning the aggregate is…
> - [Medium] The new restore logic only runs on one LAG teardown path.
> - [Medium] vport->max_tx_speed is read from FW only once per mlx5_vport
>    object, because of the `|| vport->max_tx_speed) return;` early return…
> - [Medium] In mlx5_lag_reset_vports_speed(), when
>    mlx5_modify_vport_max_tx_speed() fails for an enabled vport, the loop…
> - [Medium] mlx5_lag_reset_vports_speed() records agg_max_tx_speed = 0 in
>    two cases where FW still holds the LAG aggregate.
> - [Medium] The save gate in mlx5_esw_vport_save_max_tx_speed() uses
>    mlx5_lag_is_active(), which reads ldev->mode under lag_lock.
> - [Low] The fallback in mlx5_lag_get_restore_speed() clamps with the raw
>    per-device pcie_bandwidth_mbps(mdev->pdev).
> 
> --
> 
> net/mlx5: Lag, save and restore vport max_tx_speed across LAG
> 
> This commit reads each vport's max_tx_speed from FW when the vport is
> enabled. At LAG teardown it writes that saved value back per vport,
> instead of writing the oper link speed. If nothing was saved, it falls
> back to a link-derived speed clamped by PCIe bandwidth, and disabled
> vports get their saved value as agg_max_tx_speed for the next enable.
> 
> Link: https://lore.kernel.org/all/20260915015118.875210-1-kuba@kernel.org/
> 
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
>> index fc197d1dc9dfe..7cf9c15ec65d2 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
>> @@ -935,6 +935,27 @@ static void esw_vport_cleanup(struct mlx5_eswitch *esw, struct mlx5_vport *vport
>>        esw_vport_cleanup_acl(esw, vport);
>>   }
>>
>> +static void mlx5_esw_vport_save_max_tx_speed(struct mlx5_eswitch *esw,
>> +                                          struct mlx5_vport *vport)
>> +{
>> +     u16 op_mod = MLX5_VPORT_STATE_OP_MOD_ESW_VPORT;
>> +     int ret;
>> +
>> +     if (!MLX5_CAP_ESW(esw->dev, esw_vport_state_max_tx_speed) ||
>> +         vport->vport == MLX5_VPORT_UPLINK || vport->max_tx_speed)
>> +             return;
> 
> [Severity: Medium]
> Once vport->max_tx_speed is non-zero, this returns early. Nothing in the
> patch ever sets it back to 0. Can the saved value go stale?
> 
> The mlx5_vport objects are allocated once, in mlx5_esw_vports_init()
> from mlx5_init_once(). They survive devlink reload, fw_activate, sync
> reset and health recovery, because mlx5_load_one_devl_locked() only
> runs mlx5_function_setup() and mlx5_load().
> 
> After such a reset, FW may recompute its per-vport default (the lower
> of port speed and PCIe bandwidth). If the PCIe link or port speed has
> changed, mlx5_lag_get_restore_speed() still uses the old saved value at
> the next teardown.
> 
> For disabled vports, the old value is copied into agg_max_tx_speed.
> Since that field is never cleared, mlx5_esw_vport_enable() writes it on
> every later enable, even when no LAG is configured.
> 
> Should max_tx_speed be reset on reload/reset, or read again from FW
> when no LAG is active?
> 
>> +
>> +     if (mlx5_lag_is_active(esw->dev) && !vport->agg_max_tx_speed)
>> +             return;
> 
> [Severity: High]
> This check reads a non-zero agg_max_tx_speed during an active LAG as
> "the aggregate is pending and FW still holds the original". Is that
> always the case?
> 
> mlx5_lag_modify_device_vports_speed() sets agg_max_tx_speed for every
> vport. For enabled vports it also writes the aggregate to FW right away:
> 
>      vport->agg_max_tx_speed = speed;
> 
>      if (!vport->enabled)
>          continue;
> 
>      ret = mlx5_modify_vport_max_tx_speed(mdev, op_mod, vport->vport, true, speed);
> 
> Nothing clears agg_max_tx_speed once it has been applied.
> mlx5_esw_vport_disable() doesn't touch agg_max_tx_speed or
> max_tx_speed either.
> 
> So take a vport with max_tx_speed == 0 while FW already holds the
> aggregate. That state is reachable in two ways:
> 
> - An earlier save query failed (only logged at debug level).
> - The vport was enabled while mlx5_lag_is_active() was true and
>    agg_max_tx_speed was 0, so the save was skipped. One example is an
>    SD-only shared FDB: __mlx5_lag_is_sd_active() makes
>    mlx5_lag_is_active() return true, but no aggregate is applied. A
>    later aggregate, for example from MPESW enable, then lands on the
>    enabled vport.
> 
> If that vport is disabled and re-enabled while the LAG is still active,
> this check passes. The query then stores the FW aggregate in
> vport->max_tx_speed.
> 
> At teardown, mlx5_lag_get_restore_speed() returns that value and the
> aggregate is written back. Because max_tx_speed is never reset, every
> later LAG cycle restores the same wrong baseline.
> 
> That seems to contradict the commit message:
> 
>      If the max_tx_speed of a vport could not be saved, it stays zero and
>      mlx5_lag_get_restore_speed() falls back to a link-derived speed at
>      teardown.
> 
> Is a separate marker needed here, one that can tell "aggregate pending"
> apart from "aggregate applied"?
> 
> [Severity: Medium]
> Does mlx5_lag_is_active() stay consistent with agg_max_tx_speed here?
> 
> mlx5_lag_is_active() reads ldev->mode under lag_lock. ldev->mode is
> written under ldev->lock only, in mlx5_activate_lag() and
> mlx5_deactivate_lag(). agg_max_tx_speed and the FW aggregate are
> written in a separate esw->state_lock section.
> 
> On activation, mlx5_do_bond()->mlx5_lag_shared_fdb_create() sets the
> mode and drops ldev->lock for rep rescans and reloads. Only after that
> does it call mlx5_lag_set_vports_agg_speed().
> 
> A vport can be enabled in that window. One way is mlx5_eswitch_enable()
> when the FDB already exists: toggle_lag is false, so
> mlx5_lag_disable_change() doesn't serialize it. SF/ECPF function
> changes are another way. Such a vport sees an active LAG with
> agg_max_tx_speed == 0. It skips the save even though FW still holds the
> original, and then receives the aggregate.
> 
> On teardown, mlx5_do_bond() does:
> 
>      mlx5_lag_reset_vports_speed(ldev);
>      mlx5_disable_lag(ldev);
> 
> The mode is still set after mlx5_lag_reset_vports_speed() drops
> state_lock. A vport enabled in that window also skips the save.
> 
> Either way, the vport ends up with max_tx_speed == 0 while FW holds the
> aggregate. Isn't that the precondition for the saved-baseline problem
> described above?
> 
>> +
>> +     ret = mlx5_query_vport_max_tx_speed(esw->dev, op_mod, vport->vport,
>> +                                         true, &vport->max_tx_speed, NULL);
>> +     if (ret)
>> +             mlx5_core_dbg(esw->dev,
>> +                           "Failed to save vport %d max tx speed, err=%d\n",
>> +                           vport->vport, ret);
>> +}
> 
> [ ... ]
> 
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
>> index afe0b9909f2dc..3e623c96b2a1d 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
>> @@ -1712,11 +1712,37 @@ void mlx5_lag_set_vports_agg_speed(struct mlx5_lag *ldev)
>>        }
>>   }
>>
>> +static int mlx5_lag_get_restore_speed(struct mlx5_core_dev *mdev,
>> +                                   struct mlx5_vport *vport, u32 *speed)
>> +{
>> +     u32 pci_bw;
>> +
>> +     if (vport->max_tx_speed) {
>> +             *speed = vport->max_tx_speed;
>> +             return 0;
>> +     }
>> +
>> +     *speed = 0;
>> +     mlx5_port_oper_linkspeed(mdev, speed);
>> +     if (!*speed && mlx5_port_max_linkspeed(mdev, speed))
>> +             return -ENODATA;
>> +
>> +     pci_bw = pcie_bandwidth_mbps(mdev->pdev);
>> +     if (pci_bw)
>> +             *speed = min(*speed, pci_bw);
> 
> [Severity: Low]
> This might not be an issue, but the fallback clamps with the per-device
> pcie_bandwidth_mbps(mdev->pdev). The aggregate path uses
> mlx5_lag_port_pcie_bw() instead, which sums bandwidth across
> Socket-Direct group members and treats RC_END as unlimited.
> 
> The restore value is per vport, and the FW default is described as
> coming from the endpoint's own link status. So the per-device clamp may
> be intended. For RC_END, pcie_bandwidth_mbps() returns 0 and the
> if (pci_bw) check skips the clamp.
> 
> Could a short comment explain why the per-device value is used here
> rather than the SD-aware helper?
> 
>> +     *speed /= MLX5_MAX_TX_SPEED_UNIT;
>> +     return 0;
>> +}
> 
> [ ... ]
> 
>> @@ -1728,17 +1754,39 @@ void mlx5_lag_reset_vports_speed(struct mlx5_lag *ldev)
>>                mdev = pf->dev;
>>                if (!mdev)
>>                        continue;
>> -
>> -             ret = mlx5_port_oper_linkspeed(mdev, &speed);
>> -             if (ret) {
>> -                     mlx5_core_dbg(mdev,
>> -                                   "Failed to reset vports speed for device %s. Oper speed is not available (err=%d)\n",
>> -                                   dev_name(mdev->device), ret);
>> +             esw = mdev->priv.eswitch;
>> +             if (!esw || !MLX5_CAP_ESW(mdev, esw_vport_state_max_tx_speed))
>>                        continue;
>> -             }
>>
>> -             speed = speed / MLX5_MAX_TX_SPEED_UNIT;
>> -             mlx5_lag_modify_device_vports_speed(mdev, speed);
>> +             mutex_lock(&esw->state_lock);
>> +             mlx5_esw_for_each_vport(esw, i, vport) {
> 
> [Severity: Medium]
> mlx5_lag_reset_vports_speed() is only called from the
> mlx5_lag_should_disable_lag() branch of mlx5_do_bond(). That predicate
> excludes MPESW:
> 
>      return !do_bond && __mlx5_lag_is_active(ldev) &&
>             ldev->mode != MLX5_LAG_MODE_MPESW;
> 
> Should the other teardown paths restore vport speeds as well?
> 
> mlx5_lag_disable_change() goes straight to mlx5_lag_disable_mpesw() or
> mlx5_disable_lag(). It is called from mlx5_eswitch_enable(),
> mlx5_eswitch_disable() and the devlink eswitch mode change.
> 
> Explicit MPESW disable goes through
> mlx5_mpesw_work()->mlx5_lag_disable_mpesw()->mlx5_lag_shared_fdb_destroy(),
> and doesn't restore either.
> 
> The aggregate is still applied when these LAGs come up, through
> mlx5_lag_shared_fdb_create()->mlx5_lag_set_vports_agg_speed() and
> mlx5_mpesw_speed_update_work().
> 
> After those teardowns, FW and agg_max_tx_speed both still hold the
> aggregate. mlx5_esw_vport_enable() writes it again on every later
> enable.
> 
> With the new save step, a vport whose max_tx_speed is still 0 then
> reads the leftover aggregate from FW and keeps it as its saved
> original. Every later mlx5_do_bond() teardown then restores the
> aggregate.
> 
> The missing restore calls on these paths were already there before
> this patch. But the commit message says the saved value is restored
> "at teardown", and the interaction with the new save step is new.

Will be fixed in a different patch that will be added to the V3 of this 
series (calling mlx5_lag_reset_vports_speed in MPESW teardown.

> 
>> +                     if (!vport || vport->vport == MLX5_VPORT_UPLINK)
>> +                             continue;
>> +
>> +                     if (!vport->enabled) {
>> +                             vport->agg_max_tx_speed = vport->max_tx_speed;
>> +                             continue;
>> +                     }
>> +
>> +                     if (mlx5_lag_get_restore_speed(mdev, vport,
>> +                                                    &restore_speed)) {
>> +                             vport->agg_max_tx_speed = 0;
>> +                             continue;
>> +                     }
> 
> [Severity: Medium]
> Both of these branches set agg_max_tx_speed to 0 without writing FW.
> Could FW still hold the aggregate in either case?
> 
> For a disabled vport with max_tx_speed == 0, the pending restore is
> dropped. That vport may have been enabled partway through the LAG
> without a saved value (the mlx5_lag_is_active() check skipped the save,
> or the query failed). It then received the aggregate and was disabled
> before teardown.
> 
> The patch already assumes FW keeps max_tx_speed across a vport disable.
> That is why disabled vports get a replay value.
> 
> For an enabled vport, mlx5_lag_get_restore_speed() returns -ENODATA
> when nothing was saved and the PTYS query fails.
> 
> In both cases, the next mlx5_esw_vport_enable() after the LAG is gone
> sees max_tx_speed == 0 and an inactive LAG. It queries FW and saves the
> leftover aggregate as the original.
> 
> Before this patch, disabled vports got agg_max_tx_speed set to the oper
> speed, so re-enabling them corrected FW.
> 
> The commit message covers "a vport disabled for the entire LAG period".
> Does the same reasoning hold for a vport that was disabled partway
> through the LAG?
> 
>> +
>> +                     ret = mlx5_modify_vport_max_tx_speed(mdev, op_mod,
>> +                                                          vport->vport,
>> +                                                          true,
>> +                                                          restore_speed);
>> +                     if (ret) {
>> +                             mlx5_core_dbg(mdev,
>> +                                           "Failed to restore vport %d max tx speed, err=%d\n",
>> +                                           vport->vport, ret);
>> +                             continue;
>> +                     }
> 
> [Severity: Medium]
> If mlx5_modify_vport_max_tx_speed() fails here, agg_max_tx_speed keeps
> the LAG aggregate. Is that intended?
> 
> Before, mlx5_lag_modify_device_vports_speed() set agg_max_tx_speed to
> the teardown speed before trying the FW write. A later enable would
> then retry with a non-LAG value.
> 
> Now, on a later enable with no LAG active, mlx5_esw_vport_enable()
> runs:
> 
>      if (vport->agg_max_tx_speed)
>          mlx5_esw_vport_set_max_tx_speed(esw, vport);
> 
> which writes the stale aggregate to FW again. If max_tx_speed is still
> 0, the save step runs first and records the aggregate still in FW as
> the baseline.
> 
> That looks like the state the commit message says is fixed:
> 
>      leaving the aggregate in FW and in agg_max_tx_speed
> 
> Would setting vport->agg_max_tx_speed = restore_speed in this failure
> branch let the next enable retry the restore?
> 
>> +                     vport->agg_max_tx_speed = 0;
>> +             }
>> +             mutex_unlock(&esw->state_lock);
> 
> [ ... ]
> 
> --
> Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261022193053.3815866-1-tariqt%40nvidia.com

