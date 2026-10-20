Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.40
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792478006;
	b=PXO6U+kkxbRxyC1zz/zjBgEgiSLiemayq7ARilU3vU0szr+E9j2K7ox0bosIruyjWCEz
	 htN67MB2WdATUJQw4htEQicHzMsSUq3V1m4Uqixm+mbHhPomAwwS6CFcGGOWlunjo36pG
	 qF6YT9/2+K+lfZD9W5zHxostbuuVwhQWe09eMq965kf/QKoObdul4YN5n3chJTFbnS6j4
	 nkwXC3Jgfo8P9/L/Z+6aK2LirNZm0wR+3aw1iGeNDl9DFfCZJQbbtrgRC8fd9jE8Yzfyc
	 B4iK6OAzQkbT9b3L/Qx47/w0hvzG8MlTO4Gs9J9vtKU2k4qsPMdTOtE3rbOEccvD6WQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792478006;
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
	bh=XGEnG6SK7p+aoZFFS5/l/2WDyW89SuHgKkeTRJz7IF8=;
	b=OsNX+5FRoHQjERycj3jJ+PVs2Fj9XGl+BtoasB+xai2yTdttyKxkOGUiuHLo4V18AR/9
	 nuqVNGiJT7+BVhCVWBjaLCuiwYU3TIFHNLZ/4LIIsVCPqIkV/IeqDSmVpjHHa/EB/To9r
	 RLpH/6EgrAJN9XvwnTeTLe/8vIgBweFJH3QR+8mI7QU9ygkoIw0gi51YIuBOQSWLtcNNR
	 06HsYmzh9qP89mceVmwBE1hKFB6O9aJRYR9CFnaFYHLBgLF6MTBr0tjiGDqeJDB7HbjHA
	 waA+pUKuoErB0hUdtwXez48q5HARZqSIVr3e0X6pYsxKzwlHgp5444BuWIrXT8WB+Kg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Iv6ZsOMu;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.40
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013040.outbound.protection.outlook.com [40.107.201.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04303606A31B;
	Tue, 20 Oct 2026 06:33:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 04303606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Iv6ZsOMu
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TKsMaQ2ppTeJyBdAIb/NXItspdGfttusJwUElmbykS7/XdAeg+m0/qgmegIOiQdsE09afcVvxzLCZJLD643qS3VjQfk7ckcsoXrLYm3hEvfbbb4WiFc83GZG5yiGicaH3d4XAXAljV4ej0cFoH1x13LVXHipU/iqaAkdsMinWy0rNLYKPNUORF2MIel98nN+kfnuKOj6w9KFeY8FVmb2mByUzn59OY7TXv6cYEdlNykDRHkjYcGD+6QUMRFehlcgLo29rKmxZ6USTmCT42nC8RJQB4lcmuI7PolIBfe6R1vpd6YDFRpH/O3rj2S6EhrWNkQheeVlow/v8+F08hoduQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XGEnG6SK7p+aoZFFS5/l/2WDyW89SuHgKkeTRJz7IF8=;
 b=oCM7PtTyavQp6UqwCRJyJwSBH78n15YfO0vwxZwXK0I3ZSTl1q/RWMxQL3QKZPtH7iAiUWd0fZB0Ym2lcMm5RINhhmTF8tQeMlrEjVAanLr6vaWURnBsFY63iUGKdoYhQ+2N71HuYDngeGUPUdb2IVhP5BBJ75uHxQF8pJ8cNDUC7GpiQUb9pisPVKPHRyAPNNxM1cUqyZaz8tyJrDLaqjXNSQtl3bwbhs1qBmRNF2lo+Qj8w8wr+R7kdQLY7lpb3mBLT8/j8/2ysvGypq3GlawIiHuZUL8fApVEcV6sDEa7ofXboFQvlF9aC5meVlfPF3i9HbBHYycN4PKQ7xeVpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XGEnG6SK7p+aoZFFS5/l/2WDyW89SuHgKkeTRJz7IF8=;
 b=Iv6ZsOMu2K4+kP3KWuBCXrnqnE2j00q1sb1YQFnTkWrsJOebuNo5g5vbqehHO6qafPuvvYpabu4w/OChsPWb6njErv3A4aTlfgtSUT62Bn+0Z966w2f696yPdlKe5mo8gmvzPAW84RxNNOx2pCoe/HHEm05P1/JQPBM+i4V2bhrzuG8mqTgxOtluFHQpc4CtXrlGHRGPwpYlw0o8NTex3H/89krG4ATRZ564ozaYRoQcVGVtqRGw6sTDsQS3wg6+vwalQVB+Hn4p/U+agvKS/joAl22smWxWAXoFjekZpb5o/3f42RkMtynHgf3DU9fR6DUtX5jE5ZuJZyP+hUo7vA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 (2603:10b6:207:12d::15) by MW4PR12MB7189.namprd12.prod.outlook.com
 (2603:10b6:303:224::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Tue, 20 Oct
 2026 06:33:22 +0000
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f]) by IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f%5]) with mapi id 15.21.0546.012; Tue, 20 Oct 2026
 06:33:22 +0000
Message-ID: <12f872fe-abeb-433e-8221-ceba1427f371@nvidia.com>
Date: Tue, 20 Oct 2026 09:33:16 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 0/3] net/mlx5e: Fix CQE moderation mode reporting and
 control
To: Tariq Toukan <tariqt@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>
Cc: Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman <gal@nvidia.com>,
 Joe Damato <joe@dama.to>, Leon Romanovsky <leon@kernel.org>,
 open list <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org,
 Mark Bloch <mbloch@nvidia.com>, "Nabil S. Alramli" <dev@nalramli.com>,
 Rahul Rameshbabu <rrameshbabu@nvidia.com>, Saeed Mahameed
 <saeedm@nvidia.com>, Yael Chemla <ychemla@nvidia.com>
References: <20261014124704.1017782-1-tariqt@nvidia.com>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <20261014124704.1017782-1-tariqt@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TL0P290CA0011.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:5::13) To IA4PR12MB932075.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: dd24c330-9114-4de2-bf8a-08df2e740970
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|261009223027099003|10067099003|56012099006|6133799003|22082099003|18002099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	8PuIP+h7vusrmkCTYxoYk3HDhMJ62Vtgd11Cn/WoXG9iwa590eY93xzqOTcXUYI0+PCMhOFR5zgUoJoUkpuKq7UCHM9yR0e+q+KgQci2ewnTUGBLaT5FBH7fRwvku4qvBkAYB7t4s7Zy40D66E5zkNlCS5lEicpwhJbpjJvT1FW9PJkDoACIPGMFWybDCnYuLws3gttCkPUQyXOxMeqaNhzH/Qi1tLFq+aYhwGXn1XumzTv/0Yv8WGMAkqVXgm9AamJlnThwsHBZcbofAd7zeLNeSLngMDZ9qUhhRNnGN3+PQH8GeIf4mnLtw/2nWz7Vtb7qXRDEFSe3bWV4NZ5gKsSuhqLUxEqt+N5/noJBNedtMsg23L6R5mpSRebuaSCed/L3w2VqywJfOSgW2DslIgStEiDFCLXF8qkTx+yutxpqPaq7G4/5jySyzlG2AWXsAkw4IpPVUU3oNlJrP7Abm1QCFsQ1iwZKfbcH2A1ltVjOMP7uzE/O7FFeZG6KmGoUxoC/r3H/LML7atLkDbnb+6dwXG0hnRAn9UNZ7YKqYaay4nVU7eAg+g/+MTI7XW7bNpyTz2lnCOzKgJtjHneVcxHYhB2ALsV+Eig7JS8a0NCX3DWVNiZsNlM4CkGVnfahzmVBBg7GKGkCBZ93MU593VfY6OpvFJDqzR+44LUEyH8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR12MB932075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(261009223027099003)(10067099003)(56012099006)(6133799003)(22082099003)(18002099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?czV3WUcyWjZsZlhGZXVDdVd6WkllY2FuTUdOYU9xZ2UvU29vZ1J4Zk12eTlL?=
 =?utf-8?B?K0laRjliTWZCRXRwaXg1LzFYbEVIZEpuTDQ5Q2hLWno4MU1kVzZnUFQva1Nr?=
 =?utf-8?B?WFhUS3FYV256TXMyWW83SW9kV01nY0NQdjRTclp3YTJaSndiYlY5Mkc1SEJN?=
 =?utf-8?B?VThzMk0zQmcxVmdCMTM1Z0NGUXR3TENsSU9ZSFNuTm9PWExKSjFSRksyN0o5?=
 =?utf-8?B?V2s2M3BrZ3VubHVDZlV0SDVacE5zMHRVdWtRRkxXTk9TTC8wMHZLTmpxQ3M1?=
 =?utf-8?B?WitRQTdlSGptb1hqOU9PSjNUV3FLbmFXY2ZoM2hJNC9ja0NvNXhqcGxDQmRv?=
 =?utf-8?B?cHI4d2huSGpuOThRTlBpZkVUbTV0UnFCTlNHeFQvOEtmbnhld0NmVW5JWkcx?=
 =?utf-8?B?Rmh2Y2xtVGkreFhDN2VNUnJMN2ZYWjk2bm1FNXlmS2Q2d0FDK1Z5NlRzKzhY?=
 =?utf-8?B?ZVAwYkVyalRRcTA5V2gwb0IyUW5HYWl0WjduMkNxVTVKNnRndlZXZThnYVRj?=
 =?utf-8?B?bmc2SEZaNlpJUEdOT3N3T2dDOFhyWVhSaGYxcWVlOGJ2N2VoVFNJNDV4WDIv?=
 =?utf-8?B?Qzd5SGVNeFJOVlBMUjcvY0lWa1FEUVBNUmRpdUpnKzNiek5hQkwwM3c4MUpu?=
 =?utf-8?B?dmZmdytXS3RFdDEvMGtDMDhmbWd2R3Z0WkJLdmpnbW5PSTRsb3VxLzRtTDJW?=
 =?utf-8?B?bmdiUkV3ZTE0MU9LYnhyVHE3RXM4NFQyMXlVaVpSaC8xZVZiQWhUQmRGZ3Ji?=
 =?utf-8?B?R3pkMGJNdXBISTR5Q21aODA4SHRNZGxCSFZOVjZUdjRVVCtIVXVIeHBTM1Zz?=
 =?utf-8?B?MEdhODBDVmFWZHFKOGxQMUZqMFcyb013dFZoSElhdDVHU08yNWtWWlhFTmZs?=
 =?utf-8?B?eGgxcmlNSzBBUUVrVG5PTU9OS2JVbUp0eUZqMjNuY1hqVklaNFZFdFZLSHo4?=
 =?utf-8?B?V3dXUk9jb25ZdGRNTzJaM3hGUmVWMzRUSDFwdGhxWGFueGZvTHFyY0k1cm56?=
 =?utf-8?B?dGI4TzRReUdsTWZOWUorL21Xdm1WYll3NHlBYVFTc3J6cW9mamVudlhqRDc3?=
 =?utf-8?B?L0dPRGVXQVpPZDBWamF6ZFdKNEVJcUVaL2wwM2ZoanRHS2FYQnozU21yVkJW?=
 =?utf-8?B?Nk53WkZDMG5ZaE1pWld3UWJ4ZFdnNDk0S29Ka0hjbzZvTHFxVUVUaW4yWXdN?=
 =?utf-8?B?dWNXc3dDSDgxbGFnZzhqYkp1ZHJSMDBqZ05SSHBHQ2xQZDd5aC9naldWZUE3?=
 =?utf-8?B?NjZPNk93MDQ3UTh3cUJiT25kTWlMWVhWRDRQNENKdmM1cnNOSG0wK1RRZWJB?=
 =?utf-8?B?QmRaVnd0TFloSlI1S0FibzhLdVB3NTI0Yno2aEdaNytMVElHVjJFWDVYMFF3?=
 =?utf-8?B?VGN2Vm9ERjJ6K3R0L1JNV3NuMzdkT1F6OWJySWZ1UzJHcVJjcnNuQkZLaU8r?=
 =?utf-8?B?aVV6eUQrN0xVcEVkclBreXlXSmNyaU9pUTBUVXZBRDR5NEp6ME0yN0NianlV?=
 =?utf-8?B?dmcwQjdPaTZnVXlZcmJFN25DS24wTzhab3QzNWFmU1pDSnZBaGhpOWM0c0ZZ?=
 =?utf-8?B?WmM4ZW1hZGo0V1lRckhUVkdwRFR2a2IwYnJyd3UyVTluL3l1L2xLQmQrS3lt?=
 =?utf-8?B?Wm1IUmxpWGhWU0hzZGVrNHVhWHI0V3RvM05USXQvK0ZJZ3l1ZXUxa1BTZzQx?=
 =?utf-8?B?TStNRDJCS2gwOU9iSWVvbmxUakJaMTZSUG9IVTNZeU5yZXhWQmo0MmZhWWlx?=
 =?utf-8?B?Tmc4a1Q1YWVxeHFGOFNmc01kbmtkRXFIeXRORTZadmlxVkFSaENtalVvNk43?=
 =?utf-8?B?cFl3R2RZeWM5STNOaUNMTEp5R0JiV3VXMGExaEhPb1lUeS9EemdSR212SUpU?=
 =?utf-8?B?VkpXY0RGNUEyaTJhV0I3VXVQOENVTGhjTXRCN05TRG9Va0NrOCtVNmRrMTlC?=
 =?utf-8?B?ekp0cE41S0dGRGxNUlpLRzY1V01GN0FJRWJLenp0Mm8wZlBpcU9qY1lUSENK?=
 =?utf-8?B?dm5uTEJ6MW1oeWdpUnYwcGpnM2xsc2s3WnZheXd5MDlQdWZrQkQxSXlRZFZK?=
 =?utf-8?B?a1dFZGN1MFJkRTVPcnNHU2U2UjBFUjZXN0pSSE5FdHo4NFpLUHZ6U0JhdGV4?=
 =?utf-8?B?b2U4N2JiY2gwL08weVptVWFVYko0QUdGWEk5amw0bUdCa1RNOUJxNk5RQ2Fr?=
 =?utf-8?B?MjRlelRKZFVwRUMxYjJBQ3EzNDAxQlNlaDZTL1BtT2lZcjVCQ251LzJmY2Fk?=
 =?utf-8?B?dTMvNmZyMEN6cDMzOE1iRjhWOWNHNzM4L2dXclBxWTREemNOcmRYS25OTnhv?=
 =?utf-8?B?NzVtTDdWNzhkdWRDUGJYR09Ja0toK0x3MzNta2dHamFnTzRaQ2M1QT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd24c330-9114-4de2-bf8a-08df2e740970
X-MS-Exchange-CrossTenant-AuthSource: IA4PR12MB932075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2026 06:33:22.1001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l+tcG755N56ODYA2bsGMiYZlr+iu3hy7JpM/rI6LVD95MHujxmpMN2GXZhtEszpkNT0veMFXceMnxw1u82MqQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7189



On 14/10/2026 15:47, Tariq Toukan wrote:
> Hi,
> 
> This series by Yael fixes inconsistencies in how mlx5e reports and
> configures the CQE moderation mode through ethtool.
> 
> mlx5e_params keeps two representations of CQE moderation: the private
> flags (MLX5E_PFLAG_RX_CQE_BASED_MODER, MLX5E_PFLAG_TX_CQE_BASED_MODER)
> and the fields rx_moder_use_cqe_mode / tx_moder_use_cqe_mode. Ethtool
> get/set coalesce uses the fields, while the priv-flags path uses the
> pflags. When the two disagree, the reported CQE moderation state is
> wrong. In addition, commit bc541621f8ba ("net/mlx5e: Support ethtool cq
> mode") added ETHTOOL_COALESCE_USE_CQE to the NIC ethtool ops but not to
> the representor ones.
> 
> Patch 1 syncs the pflags with the capability-derived fields in
> mlx5e_build_nic_params(), so that after channel attach or reopen the
> private flags no longer remain zero while the fields reflect the
> hardware configuration.
> 
> Patch 2 fixes the opposite direction. set_pflag_cqe_based_moder() now
> also updates rx_moder_use_cqe_mode / tx_moder_use_cqe_mode, and resets
> the RX/TX CQ moderation to the defaults of the new period mode, so that
> ethtool -c no longer reports a stale CQE mode or stale rx-usecs after
> toggling the priv flag.
> 
> Patch 3 adds ETHTOOL_COALESCE_USE_CQE to mlx5e_rep_ethtool_ops, so that
> setting cqe-mode-rx/tx on a representor is no longer rejected with
> EINVAL.
> 
> Regards,
> Tariq
> 
> Yael Chemla (3):
>    net/mlx5e: Sync CQE moderation pflags with coalesce params
>    net/mlx5e: Sync CQE moderation params with pflags in
>      set_pflag_cqe_based_moder
>    net/mlx5e: Expose CQE moderation mode on representors
> 
>   drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 8 ++++++++
>   drivers/net/ethernet/mellanox/mlx5/core/en_main.c    | 4 ++++
>   drivers/net/ethernet/mellanox/mlx5/core/en_rep.c     | 3 ++-
>   3 files changed, 14 insertions(+), 1 deletion(-)
> 
> 
> base-commit: af32da41b0327b9c6a37856ba82b6760d6c8d10e

pw-bot: cr
