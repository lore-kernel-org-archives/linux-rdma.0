Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.65
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792478113;
	b=H8JqQ/ELIRJnJlsPbwcmjrUjOkVaX4psRDuDPmkytpJyMgFhfg+RrL8ohnCU/oHL2+5c
	 HsRzrD124A2oVAVIMcUGTaelzi13dKTdiUv2CYIcuMksF/v36Y/MJZtgDuKPpSJWL24m9
	 Kh4B9hpbZ2dIoRh5v3Nv7NhH0LblOdISYdCpmV/ZBPrlvNxsqsy06u/pEeEBlMeBYtEa1
	 ORT0k/dM0eTl25IcJkEl8Yu7ROnbrfeHCaAC0OiMvq0kLjNMey0R1MKOvQwrOENlHrRYk
	 0u2HZz5Wf8TDkLsMGLYOhEa3F3TB1N8jbVRduiEyN+PIdTsPgRwKdOe4WRww1SIWSfQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792478113;
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
	bh=AuQRKovlQQMN0wjdkOq5tJ5j5EGeFsv4vCHPbAr2Ydc=;
	b=AeLgCUD+90U603YWW/AJAF13C3hjSNJV43AxsXcuY0DglcIyugbTnN6NnMuvaRKXIDcI
	 u6E9g8bzAZER/AsR7sXT3p71dzdNPOSIsmk4aRu53sOTdXVHNlEoSTV1pb3Bp49eq4P0R
	 Bm4VtpVrpCdd15AMbuSBfit1PHLFxWjq6saMX0+yKdlQBDE/oYswHSaYpSnsLH8gZ5IyZ
	 ByRZR7qlGcYGVXfjiHqzfdby/gIF7JST7MuZFrM2pMNoAAB51pecpTcols3VOfrVBRakt
	 nbooMNh5lMGYkGYoK1j4bPUc8F/J5aZOChIy47wyL9no0YwKRyfrELbwDy6xq0YhH/w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="e+uj32L/";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.65
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013065.outbound.protection.outlook.com [40.107.201.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E5B606A31D;
	Tue, 20 Oct 2026 06:35:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 86E5B606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=e+uj32L/
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j5QKPLip81LmB2Cd17SVu3nBTm3SRDsruCrxnJOP52F2HBfeC9ln+jGqR55pKdkWuP6gbzb3+6ojY94NZYYazhkZxR1+2gU7CDG2znoZ43IfRwNN732sj6WG0zMWyFA+twZc7/uDbLfqPsb8qrdWlIOWZsD6HqQU43DrTKhp2XESxuxB3kJp084JVG48g6vMr0/G8gyWnMGi70cGEPSwJh02uvxAMQYjhXI56G3/PyeDhVSEFsjVcIgUUK2Et6xZ9eYKkafd38vgCvAh47NDgzEOjuKSrEEf2NOd8OLjhzvbnNnQ2V03n2ZQ4ohc6Tbt0p6Bnqx93iYLiw+DRfiOiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AuQRKovlQQMN0wjdkOq5tJ5j5EGeFsv4vCHPbAr2Ydc=;
 b=LHhICDL0lJMx8sXf0OMCL6LOTItotavULgAamRxH7itY6MN/HM4GwxlqPgp3d24RmKnWr5QCKhYI2w7uTr7eRcfRtGazdG/BtpcaTmmOi3Py4EBr1jzesJ8Op2mgQLv+QWc5BhJ9br8mVqRcoCuou8C4KxK7OPVnHXkAbKGMitTidv6rXSNKWmoJzCOrXGSQqTVKD2ZLLR33PYjzyfnX/Z+NoOd/z9YTV8zYAhR3mEw+lxfCb0G1w1HESXZOSV1vmB+uu43+/oWYqkEpn8BKrbP3mspZz46JToeS9lWiwBcx9cTPGL+qFX+pHp3n1KEVzWQtfHs/0xGF/EDVuOiUVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AuQRKovlQQMN0wjdkOq5tJ5j5EGeFsv4vCHPbAr2Ydc=;
 b=e+uj32L/41h23FRHvMdhcLvsO+fQgbdY4HpBsIJs5hicI+VvTlt8K1Xj2D6McjJ2SW86y4zgKYZ5TChGi5STDlK7vAsn+oY31jWytJ96yFKYZb1zEtbGFDv/HxdfWoDYMwk7xKXxi5X2rKnxSLBph+H5S9er980sVasLdEZ0lDVLbpmW/SIEl67eZs7sIJzUxk5L/cENaViY76XnQ4uXN99KisHW1QWG5iaJqHFg9Tbi+XcA/gy8RThcNtjzXzg4Zyam531aiIqzvVcAoM+Y1hgOcYzATq4IkKP9fia1qiSTS2uh2SJFpNWB179glfo/qKDbflTCXhJniXSYB//K0g==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 (2603:10b6:207:12d::15) by MW4PR12MB7189.namprd12.prod.outlook.com
 (2603:10b6:303:224::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Tue, 20 Oct
 2026 06:35:08 +0000
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f]) by IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f%5]) with mapi id 15.21.0546.012; Tue, 20 Oct 2026
 06:35:08 +0000
Message-ID: <84200f4f-6d39-4941-95fb-675bc8d8ae83@nvidia.com>
Date: Tue, 20 Oct 2026 09:35:03 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v1 0/4] net/mlx5: Don't free CQs whose destroy
 failed
To: Leon Romanovsky <leon@kernel.org>, Yuho Choi <oss.patchbox@gmail.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
 Mark Bloch <mbloch@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Ariel Levkovich <lariel@nvidia.com>, Jianbo Liu <jianbol@nvidia.com>,
 Alex Vesker <valex@nvidia.com>, Yevgeny Kliteynik <kliteyn@nvidia.com>,
 Itamar Gozlan <igozlan@nvidia.com>, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261016045849.813696-6-oss.patchbox@gmail.com>
 <20261018125520.GE64621@unreal>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <20261018125520.GE64621@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TL0P290CA0012.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:5::12) To IA4PR12MB932075.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: IA4PR12MB932075:EE_|MW4PR12MB7189:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d6b0259-6012-4914-bd1c-08df2e7448bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|10067099003|56012099006|22082099003|18002099003|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	282Eybf09eLgYFIAzmKWeaOKlUPo7FHR37phvT5NVYz6J8mn248zBP5v7y+AXytSzn5kSaQqeLk24l43B6JjsH3xVbdItK1OrvBczuOX88mO67wWTfPIR2rIeVFeXz/zW55OzxCt78cJZRg+cCwNYfi3RRMeAqzywOTP8fwQjAzf5HuFeVtGg53a8SvDztsLDn5yTLK4VK/iOxOeT4X1vw9flEuApldWYrif0QomQ2iVjC/nsZUskydVBooNgSGd1ynNF6BoE9s2kDjvIdCNbAgWBDVwuOg7ooX50E/ekJPwvf2VZQp1hOMPpoJIYj7osSAkXXpf21FC+kezg05AaOfxoo460TOfGn0IhHhI2NBCNmnhLjilBvd50UC33irZv8rWdMGLJsxKEg+IIQEqFaFjv6rgQRpFioOswCwyxKdgDZ2kXu5vZkLFtFCgTc5AW3SRhFzwsKdSPVst3iBZiMgIBEV3U4A1mPGR8TKXU4jNiDJUq3HjRwOjdTXI0CI5kOjh/YjgICokW7qK48UzJG+CgY9MO2gT4IYXCjPg+KhWbS5ZmcexoERYSjDk8qliUkvu/vdOnnogqiaA5tt1RJnPm3oNdnkOwviIZRzVrFDk8NGGANTS9YBp+E6n7EdAocagtBZcy7Ba5YfYO8UtuUOUXcZ9TQeu2yoi1JhkrT0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR12MB932075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(10067099003)(56012099006)(22082099003)(18002099003)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M2k3ZnBkMHlmWGJZTEZwZXRyRjZRclNkN2pwUWZ6aFZMSG9YMnJ0UXEwNlB6?=
 =?utf-8?B?TUJkYy9aUktpSVFyYmJSWklwc1ZubHpUa056Q1dsck0xZEJDZ09UWHIxZGNo?=
 =?utf-8?B?NzFyeFRXeWwxaVozQjBMcDNrZ2hnemVVcEE0N1FwUUVucDdBeFlQcGgySCtS?=
 =?utf-8?B?WWVvYUE5QzdKWnRYSUI4MDQxaCtQSHpCcXFqREFtOTMrTU1pUXk0bUFVOUI1?=
 =?utf-8?B?RWl0WVZtdFJaUTJ2OWl2VDZjSXNobGpSWUY1dVhXVjRBWnp3UnVyL20rRnBp?=
 =?utf-8?B?eTBodEsxWXZybFBHZmxWYU42aDdkYXBGdW80djdVU0NTT2xkcE14ZWdGNmJv?=
 =?utf-8?B?VUxCRSt1SjAraW1UeXdQSk5Fb0dGZnVhTXZsdExtcUlQL1VkUHM0dExqY3Iw?=
 =?utf-8?B?TVBDa0oxVi92Tzc1eVkxNktRNGdISTFXd0d5TEtYNXJjb0IwZXlscEFlT2Jy?=
 =?utf-8?B?Sm1KaDhvSkFROVM3eTJnbGF5MEZVZ29NT0V5WHVRZEdWYnRvUUQ2UEd6cU9T?=
 =?utf-8?B?R01tMjNVUmJQTk5uM2g2NHcvTEJmM2Q4Sk9nYkFvL1VXVEo1bVZOc29Qc25q?=
 =?utf-8?B?YzMvU1l5TDJMR2FqcHhKNnRKdHVpMEJqNDBqa3BHOWxHMlRUdEVNSi82SFhW?=
 =?utf-8?B?VVJOTDAxY2pUQjEzekZ2RUplVE5GOGpRb2VIU2hMWE0yYzVaTCs0YVl4Sitz?=
 =?utf-8?B?eVBOQmVMclN2U0Rydi8zYW81MzRrbExxR296TURsTnZiV2tnelNFYzBUM3VM?=
 =?utf-8?B?bzhTYU9nU0hyTmtpcHljazMydlg3YStwN0gwQzZIMEcwVkZhVDNHWDFQVHBQ?=
 =?utf-8?B?TGtsTHRTLzBObFEwb1NYUGdtNUh5RXB2OHMvZldXREp0MGFVRzRRZWhMaWVQ?=
 =?utf-8?B?V2lNOGdzVFZwd3ZLWVRuWFNicE51OC9JN2FSTTNVUDNtZjZNRlkvY0JMNU9r?=
 =?utf-8?B?NHNuUjhsQjNMT080aWNmSy9wdk9KemQzOGdBOXBydVExamp5UnV3NnBPb2V1?=
 =?utf-8?B?NGtrcm82Uml1MFk2dnBKZG1JQ0ZrS09kSVA2cU1LdDFVWUtkbWREMEFVeUZl?=
 =?utf-8?B?emVkUXVwcDU3RitZNFNnd3B3Rng4bjlibVNsYWV4RHgwbkE3b0NJLzY0akta?=
 =?utf-8?B?aDhoSGU0RUZiUVpvZVF5aGZnb0JkMXFlcWIzb1FSY1RNc0dPdWpVaTRtNmRq?=
 =?utf-8?B?Mm5pRTJRYUI1SXRZTHVCMDR5Wkc3M1dDdmg1VGRXYUdmQUdGd0JsVFlkQjhW?=
 =?utf-8?B?MnJKWGRMUFdpTjVmVlB2L3pQYVcxekE2eG9COTJqNUUyMGNjZ2FRS3Q5VnZp?=
 =?utf-8?B?aXl0alo5SG54d2JDNjZlNS9OSzdacFJOTGdGYmp4aWY5SFdhcjlhZ0FnZkN2?=
 =?utf-8?B?UTJsWGRVQStYM0lKUVhlQVNlSjV6WDhrSzdJMU9jb2lDTndrSytBdFFlWDk5?=
 =?utf-8?B?eEFmYTdqUFJVWVZWT2ZoRnR4bE8rOSttM0ZqbUtpVVFzUmpIOUFvVW9nSTlP?=
 =?utf-8?B?RVFpTEw3NDJyQWY0T0FxcFNNd0NLUklUYk01Qnl4NzZwYU15dzllcDFJRXJq?=
 =?utf-8?B?S04xSzBHaHNEWW8xZXZDb25ZSVZzRzhnWWVXT0YvSGxVUThWTlVIdmlJdXdP?=
 =?utf-8?B?VEVTWHBaZ2dBZlA3RWt2b3g4L3VqeG56SE4wUGQ1eVl2MWpPZzdDSnF2Tnd5?=
 =?utf-8?B?R09hRzAxOVBQZG1pZGdMWTJhTitvM1gvVkI2S3ZIY2trZDU2am9UVjdISzZG?=
 =?utf-8?B?NGgvRjB1TlVXc2lEUXd1Ylo3NXlaZWRIYlFlSEhEMzIrd3Zuem9TNE82dm1z?=
 =?utf-8?B?WC9aTGkzTEFVY01JWlJPR3JBRTRPOTQ2bTZWMVM0M25LZEZ5QzJKU01pamRB?=
 =?utf-8?B?S1VnOUJjTVJCdE5HM2djRklQajlJNmtMWHQ3MElPYWFrQkF0bHhVWnVKbkJy?=
 =?utf-8?B?bDNnbXc5d1RsT3hQQmxUSnl1Rk5nZjR6WDhyMzJUUWl5RU9kRHl5WDZoNWE2?=
 =?utf-8?B?MEpYekprNnNlaWw2bndnMDRsQkJiL0xCcDI0VjZGUmpmRE1BNXdkOFBMU3NE?=
 =?utf-8?B?MThIcktIbVNmZ01jWFc2OVpQUXpVamtua1V2RU42aGdwdjBHSGcyR2NXbFAv?=
 =?utf-8?B?bVBCUTBuQWJmYjU2b0tHSUIvL2ZPSHpYZmlxYmVVazhZRUoyWUlsdmNpREZQ?=
 =?utf-8?B?RTFKMTVnRUNPQXk5T3VsL1c3SUhQemtoM0I3bThCV0VPQVhBU2xaRDBzRUdI?=
 =?utf-8?B?WlVKUkE2Z0xDLzJNVmd5cnpwNEgwN0dwZEpNc2JIYUptbjVmK1ZSeDhjN1cr?=
 =?utf-8?B?cnhrRnd6TXVkMjU3THM0UWJZZU11SlBocTFnLytMdUp5ZU9mZDhpQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d6b0259-6012-4914-bd1c-08df2e7448bd
X-MS-Exchange-CrossTenant-AuthSource: IA4PR12MB932075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2026 06:35:08.2299
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SDivNgP0yKjZhbfxyMnc+OMGPufFLCQDHbvkSA9/vItjbPIh0K8/ih542sEgb34YcW9eCB9r70kxt3JDyFE3kg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7189



On 18/10/2026 15:55, Leon Romanovsky wrote:
> On Fri, Oct 16, 2026 at 12:57:45AM -0400, Yuho Choi wrote:
>> mlx5_core_destroy_cq() can fail
> 
> No, it should not fail. If it does, the firmware is completely broken
> or some other catastrophic bug.
> 
>> nd when it does the CQ may still exist in firmware with access to its buffer and doorbell record. It
>> also returns early in that case, without waiting for EQ handlers that
>> may already hold a reference to the CQ. The four helpers in this series
>> ignore that error and free the CQ buffer anyway, while their teardown
>> paths also free the object that embeds the struct mlx5_core_cq.
>>
>> Keep the buffer and the object that embeds the CQ when DESTROY_CQ
>> fails, as the regular mlx5_ib CQ destroy path does. The HWS send ring
>> CQs are polled and never armed, so the HWS patch keeps only their
>> buffer rather than passing the error up through the queue open and
>> close paths.
>>
>> The issues were found with a static analysis tool from ongoing, not yet
>> published research, and confirmed by code inspection. None of them was
>> reproduced, so this targets net-next; I can resend for net if you
>> prefer.
> 
> Please drop this series. The flow is impossible in current HW implementation.
> 
> Thanks

pw-bot: cr

