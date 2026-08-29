Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11020094.outbound.protection.outlook.com [52.101.69.94])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42EB034F48F;
	Sat, 29 Aug 2026 18:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.94
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788028170; cv=fail; b=ZyxymG9RuZuUdPO5FEMwtIVNpUJ8LKy+nUevstq1BEyptr40An5qqcJ3jIC2g6Z3mei/DYv48GjLfG10ZZ2jDvRZmxs4gAIEbFrNFi8UF4QM01esRzNqPMqjM0pBCrboLan9EW2rSQFHtRMUnu6t6Gk3/1LoJ5d+zZmCrifcDOY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788028170; c=relaxed/simple;
	bh=oip9urDVnb6ulZw+xAkPjNKomuDB7p4EvQkJIQ5abzc=;
	h=Message-ID:Date:To:Cc:References:Subject:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jUsjs2XizEXmy9jfXTIi79OiupjrYrbia3QaCVTh5WR3EhfqpRl5V6PQbao2uTonDDIF2YRop5o82mj9YpQptETsGWX5+EVu1YwiVl3aeex6eYyDV9fNYRrDCDpYcFCvCe+eshvZQB92rQHvH38tOn0QXQDYRrw1zf26925nmME=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kuleuven.be; spf=pass smtp.mailfrom=kuleuven.be; dkim=pass (1024-bit key) header.d=kuleuven.be header.i=@kuleuven.be header.b=W4zekFtl; arc=fail smtp.client-ip=52.101.69.94
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kuleuven.be
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kuleuven.be
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=kuleuven.be header.i=@kuleuven.be header.b="W4zekFtl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cBocFXOyYsMy8iJ+PoHswoVzQ+W0SKXzl77aCD5PJkTc7ctOBwyHOXTH5PZzX9CoxWEJt7y1ulNYyh0Xs5VGB93kwOnP6rKiRMLupFSH2OernBW2l8PwswlNzE4TmGoCMDK/Gtor9wAwYwA7/TkPwh2UcHzg95LYm9dxaQ3bTlLOKgXYAEq+k8ZKvjVrXTumGaVQbu2l42iJAOLvdqNen0VR1b241aLL7K63/aZXfGxXZH4EZzs3cnYXlEfzj/tjnytcnjWXWikBgQHV327mndiDdG0s0Ww434xsC6iYjtgNYSMjU4cYuIQgLDVokf2OCkAWQdeWZ2v5ltDlY42c1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oip9urDVnb6ulZw+xAkPjNKomuDB7p4EvQkJIQ5abzc=;
 b=U8x7DCLculIiAqtvgC0hFbIioYn5scEC1ysPK72xBR6UAWJpgpjX9p+0OpCzIAoAhSVuCTdBHlVfSzrgf/cUlJ8ZPHZAk4MQhSod+sPyexfhLYMTLwCTyahq0cj5ZfSeVqOKnlk5yvh639LCWHzEQpMCCx7r6mzQxLsTrfTwP0emH0XhpZy9zBMOVcCEvJ2T6Z5k1zVAudSOeicW88PsMMrChw0VeTKbXrzy+6JeQo9c4p3RIj3EwEsrXRqtOgh966PWVBYdNh9iU+KYRtZxWyFI7NdY9j+ANGQlzaDCaw5ZJr0R2Xf09s6k0SN3s6y2vcV1GzQeYRI+oQGBf9d+RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kuleuven.be; dmarc=pass action=none header.from=kuleuven.be;
 dkim=pass header.d=kuleuven.be; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kuleuven.be;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oip9urDVnb6ulZw+xAkPjNKomuDB7p4EvQkJIQ5abzc=;
 b=W4zekFtlEf14lCeqlXgQCrb2ye4hzVzarJImMEShQAe+gVvMtXOveJoP2LISzaSdkVtdcahLIhXcsWe94oh8KI+n5YC+3qwjb04j0elzBCNvPov38+PGUEEXyta/R6pt5aH6Ni4uUQo8t70QdvF9B9iiGT5tWz20oJvzU+tG3Ew=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=kuleuven.be;
Received: from AS8PR08MB8996.eurprd08.prod.outlook.com (2603:10a6:20b:5b1::13)
 by MI9PR08MB244738.eurprd08.prod.outlook.com (2603:10a6:290:87::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.9; Sat, 29 Aug
 2026 18:29:21 +0000
Received: from AS8PR08MB8996.eurprd08.prod.outlook.com
 ([fe80::ee9d:8228:404b:262c]) by AS8PR08MB8996.eurprd08.prod.outlook.com
 ([fe80::ee9d:8228:404b:262c%6]) with mapi id 15.21.0382.007; Sat, 29 Aug 2026
 18:29:21 +0000
Message-ID: <8a515049-55ac-474d-b343-4bd4e28f1691@kuleuven.be>
Date: Sat, 29 Aug 2026 20:29:20 +0200
User-Agent: Mozilla Thunderbird
To: gang.yan@linux.dev
Cc: jgg@ziepe.ca, leon@kernel.org, linux-rdma@vger.kernel.org,
 stable@vger.kernel.org, yangang@kylinos.cn, yanjun.zhu@linux.dev
References: <20260814093740.292954-1-gang.yan@linux.dev>
Subject: Re: [PATCH net v3] RDMA/rxe: Fix integer overflow in mr_check_range()
 leading to OOB access
Content-Language: en-US
From: Shukai Ni <shukai.ni@kuleuven.be>
In-Reply-To: <20260814093740.292954-1-gang.yan@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P250CA0006.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5df::8) To AS8PR08MB8996.eurprd08.prod.outlook.com
 (2603:10a6:20b:5b1::13)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8PR08MB8996:EE_|MI9PR08MB244738:EE_
X-MS-Office365-Filtering-Correlation-Id: c70cebf9-5405-402f-cba8-08df05fb71c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|786006|6133799003|10067099003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	grACZ2I2JrmtyaC+tHn4HF37nUi9b7DiUG/H6PpgtG/EzYzb80+IpusG2AVs5GaDNFAF5IWIBagX0YEYrSx/8ySlA1A93KhcQI4f8+mR0QTT0Gddisy0ljS2FNkIxMGPOuNMD40iZSqmo/8qK4m5KBDYzzer5NBoB58a/nvRoYAm8wHvEM+OGBW62a1i9kVN3juhsflSTWHWe8yoFf426C/RJyfraRttoVGrrBQOk8zQS/Sr/M13UJdCGhRwBKKvDbyb0ZzrX5xOUU/Lz12wg9YEyVGdeIqMzjswEkHG1hSHG0uJQ3ebpfiSx5zC9s3JlJWuENUvwFGLp1nACkMQQqJa/e2L6aP590V5W8EPUJxw1TAnfju/CcT2EXPZFZuJ/Oazd8xH/9QLX4E0b3tugcX6+KgL6ekVEj2cM+NryqAJ7rKeMXbnQ04Eno12VRlVzSeGBuZy4KjmAjpwt9lhoAzxKEMb+dk2mOEW6+4yHFqFTsQ25YlsjEwk2JgDSkTD0O4SUutwTpXNTV+fHnLGGbSFDqcMIo1wcIBJq0h1zdCxGTGoPFX9lAaV5wpZvHTzSWQZXOlYXiX9IaxrInqDsXZa0WSqHiNkq4cp+lIsOQ44cn4nbEQA5qnrw6hP6McS8EEJZac+B06DsXWfzMi/u3slyYnHGtqO7mcDm0CLgLs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB8996.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(786006)(6133799003)(10067099003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Qk9uakU3QnhZc3JLWmdOMzlOZ0RHQ25ncTI4NUNTSmwvdnFGTDV2dGppZmN2?=
 =?utf-8?B?Z0xIQmNHVmZjZW40ZHN3WnZaMlg5MnZ5bDRnZlN1RTRuejgwZ0VrVWMrV2Q1?=
 =?utf-8?B?OFlTcWVVQmxySEpPbG5DMFpnUVd6ZjF4eEoxK2lBKzdqL2ZQOGo0cE9pWFFr?=
 =?utf-8?B?SHZFY1pta05XRUxHVWNSWDRYaXhSTkdvV05tV1Nrc1lkU2JOY0Z4UTFGYlU1?=
 =?utf-8?B?RmlIV2dPcjYwZFBacWpJUGZHMzc5WDRpcG8rUGpwdmN6OGR5eEV2OUdZdXBq?=
 =?utf-8?B?T3JRMVp0UmlHWkEwRXJhMUdoeHVQeXJ6R3dKVFk4REl2WUtkSGtRUlZMdVpO?=
 =?utf-8?B?dldCcWo0Zm12cXZBNVh6QjdWWXBYSW9hNCt4LzVHdkxsZTcybHVxR0dDMGIr?=
 =?utf-8?B?a1g0Q1dFQTNPeTZBK3gzRHBNdVlFVnZhTElCZkpzK0U0NXNXYlo0Ni9WUmJx?=
 =?utf-8?B?aENaVEprb3NyM1Z2bHNGMC9ob1NUR1lBeTdxUUU0NnBqM1dsZ1Y0VnF3dHlZ?=
 =?utf-8?B?YVZNUkxaUGZqQzFMYTJhajRWbnhxc3FkMnlweEl3Uk4vemVKUlA2Qk1URHFZ?=
 =?utf-8?B?OGFJa2tOTUsrSGcwYWNDVnNhQkZIbjdCTVRaSEFMN0xmbE9BcXNYbC9hckpH?=
 =?utf-8?B?WGxITlVlVmpuRE9Gbkx3a3lyRmw5a1dPRjRIakFXUzBWNmNTM3lYL3l1czhR?=
 =?utf-8?B?NWxDaGcrV2N5YkRtVU9GcnBkRXo1WUNNeWZJZHltTnUvSHd1aDFhTkxJSHdq?=
 =?utf-8?B?Y3NTclFScnJua2s5MHJCOUFUVWsvTXNPcWFocktOZElRRFl6VityTGlmYXF1?=
 =?utf-8?B?eWZuVWFzMGZEQnNpR1U3REdSK1RpQXFyRElDTDUycHR5N0JLS3U4b3A1VlV4?=
 =?utf-8?B?ZUROVnlib1lPUkJpamZTZ0g4VmpQT05zUFFpMUJxWVQ3azdwa2tPV3dQZjd5?=
 =?utf-8?B?VVZYUVhFcHcvMURxcW53ZnJaSjljblNRZkxIc1BmTit1TUdxY3FORmdXbE1n?=
 =?utf-8?B?VEFhYlVmU2tsb3VZb3NKWTJPUVJ3MlREMjl0Uk1lZ29Ob2hOS2FnZk40RkZI?=
 =?utf-8?B?NWxPVjUwbUhhSTNQY0U0cEJtZVdqOWxuZDd5OGJ6aFA5NkROMnM5bzJtSkdH?=
 =?utf-8?B?OWN2OER6TW9YT1BUbStzeFpYekIwdVhHNE9naERXeFZiUWZSRjFDTjhvcTRt?=
 =?utf-8?B?MFFIcjZkZFVQd1Z1SnNJNisrMmNCVGtvcisxRUJSWC9YbExYYXB4UVcrZ2JJ?=
 =?utf-8?B?K3RKTTVTR2NSTWFOMlJKZ2ZhR0cyRDBlcjVMeUhwZjEyZ1drVzUwbHJ4dHZh?=
 =?utf-8?B?amVpemRCeEIxOTZ1ZUpmVlBhcGEySGU4cTY3aVZlblROOVRMeXl1M0VhUnBz?=
 =?utf-8?B?YjgzY1B1QlZ0cUhiemJzWk1tQStnSVE5VGFXRHg1dTluK0QyVGJqakl6eHh3?=
 =?utf-8?B?VWErNzNyZmNCUnVFeVRHTm5JZmVHalBDaEtWVVBON3QwUnNWNWdvUWNkbnQr?=
 =?utf-8?B?UlREcEZOczFvb00wVXdWUlFWN3ZQWDVVR0cvUjJudEQ3dlhrY1loVGo1Qzgv?=
 =?utf-8?B?RGMvOXRWYXFEaHlhaThnODBpZU13aHh5dCtVMjUzdGN4dXVLUktEK0lDL2tV?=
 =?utf-8?B?U3dsZWlkM25NVCt6UHFiZk5zcmhVSTRRV3d5d1ZVY1UyR1pxMlR3dVM1Wmo1?=
 =?utf-8?B?Z2kyd1h5dVZDRGd3UlBkakpSTHA3MDlNUXZLdUE3M05IVWd5QVh0WWcwQ29G?=
 =?utf-8?B?Q2JGbFl5VDlKMDJEMTNzY1ZaSHNmekZCekdPeUl5cFpHd29BYnJKQTBBem9m?=
 =?utf-8?B?amVGbG9LUkFPMVVQSmo2aUNqQzNNT2QxRjYyZUpIK21Ea3BsbG92WHcydnFv?=
 =?utf-8?B?dThpaW5ZNENrem8wbWs0SndnbVBDYm1WODJ3bEFvRllmNGFIdEFvSS90dGVB?=
 =?utf-8?B?dnJodGtXa1hXVzJDNzFhcXNjTzg4VWJsQjR1dFlaS3FoaG5jQ21sSEkzWnBT?=
 =?utf-8?B?cFlNRE9kRlo0UjZFOExUU1h4TzJyQjdKdEQ4MGs0OTRLVS9DcFNpeDNLLzkz?=
 =?utf-8?B?MFhXZURKWThNanNtSG5wNVpsMkVLNUlVaUk3QlAvLzJHTTIwZThBcGQyWWdy?=
 =?utf-8?B?ekNjRWFIdCtaS24xaElqN3ppc3dTdjcvcHZwZCsweGFkRXpUVmhJNTUxRDlN?=
 =?utf-8?B?YTdTVzF3alV6TXVMSUN5Ty9RYVUwekoxbVFPelR1eDQwTTc1N2Y2OWpLV0tD?=
 =?utf-8?B?N2lYbWdmRkdubjhpZ05hU3RnUkc2UDVKMWNBVHlhSy81VkREdUEvSXpzV1lC?=
 =?utf-8?B?cWJnYTJ6ZTdiS0Vpc2hRSVlyT2tuMVNEZDh1Q0N1SXRwRGFvV2xKdz09?=
X-OriginatorOrg: kuleuven.be
X-MS-Exchange-CrossTenant-Network-Message-Id: c70cebf9-5405-402f-cba8-08df05fb71c7
X-MS-Exchange-CrossTenant-AuthSource: AS8PR08MB8996.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2026 18:29:21.4862
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3973589b-9e40-4eb5-800e-b0b6383d1621
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Srj1tRTA1ilP3HEVeqOxzZdfvM7ZWn6zG+uUZi4W73UBRP+1kgHTz92kkJ0Xqq6UhLQFdwnfCdviKkasmIFlDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MI9PR08MB244738

 > With the fix, mr_check_range() returns -EINVAL for the crafted iova
 > and the responder reports REMOTE_ACCESS_ERROR instead of triggering
 > the OOB.

Thank you for the patch. We independently identified the same issue
and have reviewed, and tested this patch using our two-VM PoC for
OOB read/write.

The patch correctly rejects the wrapped requests and prevents the
out-of-bounds read/write and host crash.

Tested-by: Shukai Ni <shukai.ni@kuleuven.be>
Reviewed-by: Jo Van Bulck <jo.vanbulck@cs.kuleuven.be>
Reviewed-by: Shukai Ni <shukai.ni@kuleuven.be>

Kind regards,
Shukai Ni and Jo Van Bulck
DistriNet, KU Leuven

