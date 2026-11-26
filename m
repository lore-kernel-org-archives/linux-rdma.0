Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.71
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795664485;
	b=q18nt+13zcKwNObxUU0IXgfQtTU4IzbvpHOkWFkzIFCmXQrx3lAq39PwhX/Y4SBGGI0B
	 baeEv6o6XO1osuEWxk7t3P47Np5aExDgnYpUHSZgspoJEKRCkd5BWP1yGhPqldtggE2cC
	 LrfCZF/9FVEUK86mcnsSFI5sR6YBgfhdk5/k9Gd6yvta6w0A+hAgAO94zUYz6PSQx61dr
	 pWHafDT5uWrFWYyXpIbr0a/3dRie7Om3Dxcn52VI0pQ/ShzT0+ibplbdHJf9b1IfM/o2y
	 FT6ERLGRZw1+7I0Wpo/04los5OvxRTYy3q1c8J1yKDkANRidJLqTuQjLcYHCFz2VLQg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795664485;
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
	bh=NX49c+RsfDmzzDi6BsCJc72BXdQGAuH+1TStIPaaQ90=;
	b=3dYO76G+Tr2oCg9ftSZUkqfUT3rUOaHQk1fMzvi9qoCynqIazgA2PMV3YquO7aOCZRFY
	 cTPFH8iE+uuaxQT40iOWmAORhl0RBITlDp7Q8IZZPSx41UgvcMoC411tT8876at0C/Mt+
	 sRIp+viO8uyru0MxK3y/jyp+vDYMwfE7PFos73LSrbqfVHvSsjYHaUPsbApprjF1Jtkuk
	 PmTsREL0DhHIqxNgQRDVjLEDCI8C6cIHsVFRTQZslWtJ8uCLHGsYLesXqXlJ2wBlS+lZP
	 CE/Og8ure20/G6bcI8qbec6lZGFJ0AgC28zj4MU25ewpRzy7SmhNh0xSLBrZPkb4AxA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=JW4y6y9w;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.71
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012071.outbound.protection.outlook.com [52.101.48.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6FB606A321;
	Thu, 26 Nov 2026 03:41:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DC6FB606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=JW4y6y9w
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bfjV2bgcr+DzPc8rkV3P6RFNXXbjm/9PWmHqvDFSf1ebxKPRJoi+QE7grb5xhEWH+ig8+i26CCwruuejLTQ7kka0JA9TZOoA0tZ1EeC53PLU6TiHhfGtM86erBNxBFyHtzBYKEsdiwsaDtw2x3aZq0vvOKdaNkyavIGVp9CjwzSrlXzshjDzcYeIg+HB5N9TQSsXwewAx1Ruceg03F3O+0GjiKqZsFbGCTwarz/emauq2YLWdR8/kRFctjLCrgLU9aQowyRDAW7CrOpuNVbcecSP9P6F/8Kjl+jrNy4P8czZbqc8UYI+B8vmcH9dDjBPP1nYI458XIpLf7ON42477A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NX49c+RsfDmzzDi6BsCJc72BXdQGAuH+1TStIPaaQ90=;
 b=Rk7SSJyP7aXlInldzFK+luDAI+JjYygc+PquDp/5JeWh0kK96YzapFnco6V8flvGWEd5b/CZe16AHaOsrmdrPbxFNaWY7xFxbJ63pwuX+HR7SQc8AnFCZU8rWeBjmpTDyiWdG3/0FVt6XVNJ9q6fhm8aKMx5r9dM4bH8k1CCk4mfYJ2eLw5FMOZInn/wdM8NxqODhb/s/j02ysxIRjNhiQDzzToC3/wzw6hFKRolEanR6Xp7BpUpuFJ4IzPKqGoVE6RyhMhPZ2x5FQr6r8K9WtiF1u0LDGqCL1oDhvvpvNwHmfRPohS7R7pvb36nNUg4+bSv1MZcplm/pcpPTshiag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NX49c+RsfDmzzDi6BsCJc72BXdQGAuH+1TStIPaaQ90=;
 b=JW4y6y9wF/oqycoUwZEn3FgqRHHAJV3HW4bzpnPKVNa8wdqPzQ7YcgMSi16f/FVj5D4eAjs0kD+jgFKWrFF8X5SfM+y0YfeVJYx/ikvY5Omgnx0wzmS3WT4yDsKcUQYEOGhTpTgMdGU5re5kTF8w0M5MbVQjA0TDv9CrJu5GbB0dEHIVeYVke9zzPc5sdImBDlc+9kF74acgFqI1NQLyiAvi9mdfuS+7TFZUeSFHqHshF2LUzuKb/ALlUWodzIJvYg17HNK1Jbl5sAfwg42hrZcpVdPo+0F/Uo72MCJK7Jj348QxIrb3IPVrYb2YkzYpeHSeKqFqBvPT18e6CFGb6Q==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4354.namprd12.prod.outlook.com (2603:10b6:5:28f::22)
 by SA1PR12MB7126.namprd12.prod.outlook.com (2603:10b6:806:2b0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.6; Thu, 26 Nov
 2026 03:41:21 +0000
Received: from DM6PR12MB4354.namprd12.prod.outlook.com
 ([fe80::7106:c186:62e:bc0d]) by DM6PR12MB4354.namprd12.prod.outlook.com
 ([fe80::7106:c186:62e:bc0d%5]) with mapi id 15.21.0662.004; Thu, 26 Nov 2026
 03:41:21 +0000
Message-ID: <2b503e0e-8987-4e50-a968-09130e26d011@nvidia.com>
Date: Thu, 26 Nov 2026 05:41:14 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v3 5/5] net/mlx4: flush pending doorbell when
 dropping a TX skb
To: Joe Damato <joe@dama.to>, netdev@vger.kernel.org,
 Tariq Toukan <tariqt@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: edumazet@google.com, horms@kernel.org, linux-kernel@vger.kernel.org,
 daniel.machon@microchip.com, linux-rdma@vger.kernel.org
References: <20261125180021.1804204-1-joe@dama.to>
 <20261125180021.1804204-6-joe@dama.to>
Content-Language: en-US
From: Mark Bloch <mbloch@nvidia.com>
In-Reply-To: <20261125180021.1804204-6-joe@dama.to>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TLZP290CA0003.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:9::17) To SA0PR12MB4367.namprd12.prod.outlook.com
 (2603:10b6:806:94::13)
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
X-MS-TrafficTypeDiagnostic: DM6PR12MB4354:EE_|SA1PR12MB7126:EE_
X-MS-Office365-Filtering-Correlation-Id: 0067f108-115b-4abb-f6b3-08df4b6f22e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|7416014|376014|10067099003|11063799006|56012099006|4143699003|261021121427099003|261009223027099003|261102123227099003|261028144727099003|261022105027099003|261022075727099003|261026140227099003|261026121527099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	B0xPSVJOVXq3L/8hYjL6w6YHOPe9JONwFFQWWkwrnNG3T1Wtk3JS4EWMmabwC4Wdr56Bv9wSDM7j4A2O7SrA0QPK0VNxZQrUAlBNuCtlcACBaut9XCWS4S+lTuuJfvgUnuvE5VG40cgr9Gjr7u5nhdqwKO68XXalAB+Sr1k/kCGugSGuP6mmhfpt2WVZ4tGnlsBJteQrHtjdrZIUeqJCiSOPM6LuqiWdH3b0+XWFok7fILqox9csOa1jnBPMbip0fbJFJzlkHHf7JJjcc+NoCXD0TBDpnamhC4s7ZqpQyK8anzKbYWm2dFQxTO4ZzelrG3XLwfAllHrcskbDU3brJW7Ds4RqSi42Z9zRzaDqo0WXi1P40UGuhKYG9yrjE5+MWd8qebZcvH/s/EH3ALBFPm+YUTyzQhshJfsOdEnZ8qBYOGcFqMq3DpVILwwXXbGfOSMtWXH6+R2lwBXk7JwZnWT0lVIDSKzvljr9M0sVL66sTWc1fYkUB0DhLPrI4MdnGIoei+KsdGVWkZuHkuls4c6RVds9OCg29xsQx5Yjkw1j0h2HG8jKYJPtwNNYUklZxPS0E0VNhxRrqmsB26/330zJAOgX3sYOtervCgERrVa9uxLl50q9C0EBP7L1651gba8KPrqnv1Ryb9XIKQSlKi+iukVysh0FGxJI9gtyiSA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4354.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(7416014)(376014)(10067099003)(11063799006)(56012099006)(4143699003)(261021121427099003)(261009223027099003)(261102123227099003)(261028144727099003)(261022105027099003)(261022075727099003)(261026140227099003)(261026121527099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZERCTFhhZm1FT1ZRYlRXRUpBK2tObFpoYndQYURJZDFyMnJXaTU2RVI0VTR4?=
 =?utf-8?B?TEdoUDJBNk9EaGw0MUNsd1BtZEIreHhvQXNQYmNuZ1NZb0h5ZkQyY21xcmxV?=
 =?utf-8?B?ZEhxUGxacE82QjlLM1NteWdUdFNPR0VNdUwwNXFJQ28vbE9yMUxMckNBQ25C?=
 =?utf-8?B?QUdGZ1VGU1VsbTFUWU1IQUNrN1IwZWdYdFEyeXJLTFVMcXE3UEFGOUJmVWR5?=
 =?utf-8?B?NExXWktYdUMvLzdjeDREVDV0Z05vaUk1OGhSd1VkSXdwWFF1YysxWHFKZ1hM?=
 =?utf-8?B?b3d3RGM5bng3SUpZZlhVWW44ZE9hSWs4ZzJwRzNLQmRvQWJnQ3plWmJvV01X?=
 =?utf-8?B?VHpySFVZZFhQL01pS25mOGlLQ2FGK29QNTJHR0hkdlpEZ050bW9tbnIrZnlK?=
 =?utf-8?B?RE93blFzcDJxMkIzblRZRXZwbm8zNXpIZHpPT2l3TEhYWVlRU1ozdEd3M0ha?=
 =?utf-8?B?T1FXNjF2emduMTQ0eTlaaXIzUnJQVEh4QmQ0V1BPQW44T2hpblhDT0NZWWpo?=
 =?utf-8?B?VlpsWDN2NjNObnp6MjJDRW1uZXJWRjNWWkh4MDU0a2Fjdk5uVHpMK0EyaFpu?=
 =?utf-8?B?eXZIbUpGVjdGWkhTc2d3Y21hL1VWdFNqYWFNMUxLWGU1aWNtNmU1Q3c4NnZp?=
 =?utf-8?B?NGJ0L3VJVy9JWXNlb05UcFhwWXpqRFQxT2E1M2ErSzVtR0g2NC9nQ0xINnBS?=
 =?utf-8?B?VTdVWnp1V0hza1E4TDV4Z2FzZDJkOHd5MWUxeU1CVDNLNTl2NExEclpSeTdH?=
 =?utf-8?B?SzYrN21MTDA4MUNCSDBtSDhmL0NFT2xwWnE5L0JUQTlqeW9XWkhBVWJtMjh5?=
 =?utf-8?B?UVRScStQV0tpOVRyRFR2OTBhUmxjVy8xa2E5RlFHT2pRbVg0T0JZbFVEeDNr?=
 =?utf-8?B?bXRGbDBLUmU1OGlkNnJGeU92MTRqWTNQbGd5cmRDKytZL0VlN3dsL2RVMEc3?=
 =?utf-8?B?QURFWFZVNENWNnZzM05henlvVmZvb2d1Q2J1S21MWXRHQTJGbStLOEdLZjcx?=
 =?utf-8?B?cXVCV2RKNkRidTlyZW14RjBOeUQzMkI3OGFEc2NUdVcvbUhJL3BkZkRjZHJp?=
 =?utf-8?B?a2FUSENydERXTGtJa3dzN2pvUGk2SEdweDV1Mm5hT2JmQnU2S2lnWEcwSE1s?=
 =?utf-8?B?bGJ3YTVvakV1aThEdmowWXp4b2xVUG5aTWp5Q3RwSjhQWDVWb2pFb2xycnBu?=
 =?utf-8?B?eXJSQngyQkFheDFTbHJZN2tIdnVBMnRaMmZrWVFCNzFwMktMMmo2MzdTZFFG?=
 =?utf-8?B?c0RDK29PaytvQVg0WU9QZituSGJCU09yM2FxYVA3R2d0UjQveXlYak9qSjlB?=
 =?utf-8?B?WDY5VE5sVmJNTWpnS2xkYjhDTjg3YzJLYkFsMTM5WFlPb2dtOGhXUUNrT0Nx?=
 =?utf-8?B?eXA0UUthZmZmU3dpYzI1TVU4RXYzMXlUQUJYSEJOTVgrc2ZYV1ZsWU9iVTBq?=
 =?utf-8?B?MU5wVW45b1dJdXZZNTJITGMzenNKMmVDYXJ4MWJIdWEvM2kzUUUraFNRTXo3?=
 =?utf-8?B?YlkvbVFiNDk2dytOTkZrODZPblJ2NWxDUURjOHJWTFU2QXFqSWp1UE43MUNR?=
 =?utf-8?B?V1gvZDVmSnA5aGlwbEkwU1ByTjZwSk5DczdXWDh5VkVmZmNxVXdUbTloOHRE?=
 =?utf-8?B?UlZZNHhlTU5SdVEzTU5xU3ZvcFlMRlFVZTJqL2VxY2RHOU8zRHVhdnFzbDNL?=
 =?utf-8?B?TnYzSEVyT1R5cGkrb0NxMXNzVnc0QVZOMi8yblNRMTJZcktnb1pDTXdVTzNU?=
 =?utf-8?B?WHV6eVFGQUxUaDdCek5Idjc4U1NSTmIxSkxlbS9rcE5WT3BBaGg1TWhWYktU?=
 =?utf-8?B?Ym9mRE9jMGNPMnJGc2ZWdVRUM0NoYW1WNmR0WmI2OWYwVmxVTEhCS3gvNjB1?=
 =?utf-8?B?ZXgvcnRzVkhDVU02OXpnbnlHWHZLaWxnTDlOZjl6a1hiQml2UVdBcHZDRUdE?=
 =?utf-8?B?RGhUM2xsQUlUWHJDRWVraWVPa3RybU1iWHp0OE5tcFhZRHY4MUl0TW9aZ2FC?=
 =?utf-8?B?VXFvWnpDK0JZZEJBWmxla0ZMZHhab0pJN3F0QXFNMEF4MkVlbjJNWXduUkpQ?=
 =?utf-8?B?a2pSVlFXRnZaM2p4YWI5NHdqMFU0N2Q4K3U4VjBPbXp5QWVkSk1zZC90dHRS?=
 =?utf-8?B?OXZwaERwbWZ0SDN0S2xXaHB5Q2RTZkg3Y2ZDelFmM0cxZEhXUURIK1E3K3NB?=
 =?utf-8?B?R1V6MVM2YjV4Ym9KdmNpeFF2dHJzdlB4alAwVTRhSUhUZ2h5QkFjV3BrbXU1?=
 =?utf-8?B?WGtIanh6YkdqN0lEVDdKL3FnWVZGZ0ZmNlpHZXpQR0l0aHRxUDJXRHhFMGFw?=
 =?utf-8?B?NHU2c0kvdklwUlBRN3NvTDY5VDk1RnZ5Q1o2d1dXK0JmTkpsOFY1QT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0067f108-115b-4abb-f6b3-08df4b6f22e2
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4367.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 03:41:21.3046
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZRvONoVZdaOGSOV+x30U/kOfwCCGdL7pk5xEkyWLPmU/QK/uTX2uswBsbhPW0unXjG7Bp8m2VLqP48s/YqUu2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7126



On 25/11/2026 20:00, Joe Damato wrote:
> If mlx4_en_xmit drops an skb (for example because DMA mapping fails) and
> that skb happens to be the last one in the batch, the doorbell for the
> WQEs posted earlier in the batch isn't written.
> 
> The queue stays awake, though, so those WQEs are eventually announced to
> the HW after the next TX, but that depends on traffic and could induce
> latency.
> 
> Avoid all of that by writing the pending doorbell in the drop path and
> clearing the flag.
> 
> Suggested-by: Mark Bloch <mbloch@nvidia.com>
> Signed-off-by: Joe Damato <joe@dama.to>

Thanks for the patch,

Reviewed-by: Mark Bloch <mbloch@nvidia.com>

> ---
> v3:
>   - Add mlx4_en_flush_pending_doorbell which clears the flag.
>   - Call it from mlx4_en_xmit (Mark).
>   - Dropped Daniel's Reviewed-by
> 
>  drivers/net/ethernet/mellanox/mlx4/en_tx.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
> index 8a43c86f815c..8fd1850ba756 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
> @@ -759,6 +759,14 @@ void mlx4_en_xmit_doorbell(struct mlx4_en_tx_ring *ring)
>  		  (__force u32)ring->doorbell_qpn, ring->doorbell_address);
>  }
>  
> +static void mlx4_en_flush_pending_doorbell(struct mlx4_en_tx_ring *ring)
> +{
> +	if (ring->doorbell_pending) {
> +		mlx4_en_xmit_doorbell(ring);
> +		ring->doorbell_pending = false;
> +	}
> +}
> +
>  static void mlx4_en_tx_write_desc(struct mlx4_en_tx_ring *ring,
>  				  struct mlx4_en_tx_desc *tx_desc,
>  				  union mlx4_wqe_qpn_vlan qpn_vlan,
> @@ -1131,6 +1139,8 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
>  
>  tx_drop_count:
>  	ring->tx_dropped++;
> +	/* an earlier skb in this batch may have deferred the doorbell */
> +	mlx4_en_flush_pending_doorbell(ring);
>  tx_drop:
>  	dev_kfree_skb_any(skb);
>  	return NETDEV_TX_OK;

