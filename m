Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.56
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793210934;
	b=H5UdYXejkWyyJyfs6LlVTQ4ebDnrgoukWBfCB/wsb4FRZTvjiNvAShXEjDF8jIYqz47u
	 pIFY+BkKvL3aSRLRMv2Fz1ptJRXeQdNEsGaH3bt/HLvKADgtXJx6+14yn5+qhX5HDymtI
	 t03thsolTbTEaNvUIfrHUjvSnh2bhTYzXxP+PwTnxJghTTpF1cqb1Ii7Y6jgv6yBEpqQB
	 Bn6heZ5Wz9ola48AW5gCGNpVdmHlGdvsyvA7aAeHt4gAwMC7383u5vsos4ElD9VF8537i
	 TIdovAhKbgs9Pns1P4H+NUs4fEtQGbzxa1Byt5aBth3YoAwbEvWczBKPQZtlab5BW1Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210934;
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
	bh=XthHZOnYy7tKb488Iscxc3eqKHZ8M7r30M7khI/+Dk4=;
	b=XGF15U/2rTKheH7HAquPeu2j1Mzv2QqGqn7cRgyLz9d3h3iVVn+CJDghciQbEUqKxbyk
	 0Rx6fFGissgVpNu2gGh+fUc26Cvede3pMCTnpNepArLO/dlLZ6l22UYHFPjIm99zJYn8h
	 FgOHucEQe8WyGu9NBUVYArxU6lJggaK5wjIsK2jOeAqpGxp4TnhVBGsN1o8C3feFnVlwP
	 aMzVtGznibxYyR9aUi6kC2kd1PCKH4Iwd1uUKyzB9rgGlePwVeybfCBDDvL0m5DeTBT0F
	 FWSVZPraq4XSG1MtYTI0K7n6OCEuUoHpZlJtyXLjPZODJkbUnTuLmJdQIg2WRvmTKRg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=iL3AhQFm;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.56
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013056.outbound.protection.outlook.com [40.93.196.56])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E901606A333;
	Wed, 28 Oct 2026 18:08:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5E901606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=iL3AhQFm
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AFi81G09UEFKdtaDv85Uq9OUV4X6wzp0yRKXuFhKddU3pLowTkYcriXCBXNXUjVMX8Gllnwx9xa8x9TcMc8Of6OHuunDwos30l9U1x9DJcIpDmEX7CRINRpj7h7rejdlz/TRG6IXTdnOxMzwLvFt5QgwJ5Vq4xfVE6ZI27QqGlsFQLSOFCnphGvQEC4SA1CJ09//59Cr6PyuX6BDvGe6/9QaXV54ugFRME7h4LdmxT03GwBGXjWv3531RTOvMBitu1FUgFgWfMqTrcFPhLnmkfYhJOW1QZe1h4O6AfRtdCNKy29Tj0xuqyTu2sAao28YTn4rvy+XxrA7bMUFEqLruA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XthHZOnYy7tKb488Iscxc3eqKHZ8M7r30M7khI/+Dk4=;
 b=JNdpXXxsYsxtJYMQtocD0pDB+UcDFFa6OPSCdwyTFU/MWcjdF7idGUJKE7oRSYddwqr7CKGYstvOTccQROJj7EDQ+T590mBs7qoiTAnCTa8ybxgFr6+r3OmwYImVmPC3d8WQ/bhsLO6JY+A0//zk6uUTd4m8DnJ2RR0um8HmUSfYPRZYtni9qS3chGVATayXbCpm80mskAkhJHNQXBHOfW0BCZWAgz2jUn+3NdLXmSXidYQXiH1ZD08V5U4dYIerQrJDKiIut4ftL0K0q47DxF9f0zBquCO2el2Bd60/7gOjXkgp2jhH75jOKgNozuiNDYzuu4gfsNrFee7p8hSXiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XthHZOnYy7tKb488Iscxc3eqKHZ8M7r30M7khI/+Dk4=;
 b=iL3AhQFmZnTmwPoHa94FsmCyZlB5AJidL7GrsZkEskG2uFbfmN8VU3lZAuzPQzEO1oOFoh5d98wPyWI8GLWI/XJxp7YKen2YKE0gl/jCop3a7kbw4Yqw4a6SBO0QqvgJL5dSWE+2SX8F1WZMopvY+fJbxIYD/HNg6tFUy+CRetKggUIs2FdqnfLziGoBH/97zvY8conTEum4j5Pjs6SattcE+GPTOd9nJ8EVPDZsV4sxaeAMUAUNwbqvRJESM2snkOI1UUMgsWPjXsJ7R2eFijBv0GjcrWWyPAZlMzxNG0+ARlserUoXP8tsdfa8vgl+d4csK+BJJqdZ3HPVD6rSQg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB239779.namprd12.prod.outlook.com
 (2603:10b6:806:5a5::7) by LV0PR12MB725154.namprd12.prod.outlook.com
 (2603:10b6:408:60a::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Wed, 28 Oct
 2026 18:08:50 +0000
Received: from SA3PR12MB239779.namprd12.prod.outlook.com
 ([fe80::2ac4:299a:52e3:5d9c]) by SA3PR12MB239779.namprd12.prod.outlook.com
 ([fe80::2ac4:299a:52e3:5d9c%6]) with mapi id 15.21.0546.021; Wed, 28 Oct 2026
 18:08:50 +0000
Message-ID: <6f1c2317-d750-48a9-94c2-a6017183add9@nvidia.com>
Date: Wed, 28 Oct 2026 20:08:42 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net V2 2/4] net/mlx5: Lag, limit aggregated TX speed by
 PCIe bandwidth
To: Bjorn Helgaas <helgaas@kernel.org>, Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>,
 Carolina Jubran <cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>,
 Edward Srouji <edwards@nvidia.com>, Gal Pressman <gal@nvidia.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Kees Cook <kees@kernel.org>,
 Leon Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
 linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org,
 Maher Sanalla <msanalla@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
 Saeed Mahameed <saeedm@nvidia.com>, Shay Drori <shayd@nvidia.com>
References: <20261023200603.GA2734761@bhelgaas>
Content-Language: en-US
From: Or Har-Toov <ohartoov@nvidia.com>
In-Reply-To: <20261023200603.GA2734761@bhelgaas>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TL0P290CA0015.ISRP290.PROD.OUTLOOK.COM (2603:1096:950:5::7)
 To SA3PR12MB239779.namprd12.prod.outlook.com (2603:10b6:806:5a5::7)
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
X-MS-TrafficTypeDiagnostic: SA3PR12MB239779:EE_|LV0PR12MB725154:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e6b9d62-0b14-4dd6-d40e-08df351e84c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|7416014|6133799003|18002099003|22082099003|261028144727099003|261026140227099003|261021121427099003|56012099006|11063799006|261009223027099003|261022105027099003|10067099003|261026121527099003;
X-Microsoft-Antispam-Message-Info:
	TJxrIZHdYANx1EpONDGmN0AROchD+M+KgPdw/NzZ9zGvaVlg7PTEl4Nytydi/axc7+TUuqa9Yfsjk3z1B0o/LgfWaDAL7f1YpL6uRe+iw00WtboQH2uYjDgbtAlXhovtDw2vScBiE1EA9Nwh5EVs432xg1YQOL4mkbxZmdsapB8BZJAx/tq1V3aXcuwaD+Kf/1IW3ZQJlahNOg20N2QnSX/6qyBsxq1tob61tJv/oBZDZprOHmN9qhsqQAspbwD6GrlAwgR7f0121ieoLndjozoOxm0jF0M9DGCEfSppFac+KcbSWQUJzTz52QbJ/viEtnHzRxMgGzuMguQDNb9ta9Llp7Hb7dCx1WQWC3yrg42LxxlTmPNglkN1y3uMnT9hIHmZ8RZJibPPa8FDJ7eTQgaiElBqTs65X4jVXc9KBgMCleFUZIU6MM/00bcyyDYyNvpXhR1WWWnyLDapheESy5mfltNGImbI7fbR6hYOaiGWvrMfMQtB41RkYWumD0t2xoINAuwzNldrwYApfF5SkoXKi8Fs1yFIQvVYtVVnCMmoRlUspWxjxwKbN7aNJHfI/ymZ+5zqzqKnUF+IqC0rU/0xSA3uGXxTq5epCoHd6PhRGw88Abg+pptbve2C0zuVMA1wLM9VZFortf1RgAnky86QbdYHBCYvaRRftt9uN+s=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB239779.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(7416014)(6133799003)(18002099003)(22082099003)(261028144727099003)(261026140227099003)(261021121427099003)(56012099006)(11063799006)(261009223027099003)(261022105027099003)(10067099003)(261026121527099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aUQ0R1BKRElDVHMxWHduR0dRVTN5MU5NTldPUXhVVnBxczNaZVUyMHA4YTla?=
 =?utf-8?B?RE5OcmZEZDFmNTZ5RCtnL25JeVlHZDBkdTJYMXBrV1N5K0lKaHZORnBpa05t?=
 =?utf-8?B?ZUFFMjNxMGdOcFVzVTM5TTlodjBBNC9rZUxUYUhrV3V5T1RtNnZJTG51YmFI?=
 =?utf-8?B?SmJrMW9lM1ZwbWZ3TWRqVUdJNzdzNTdNNmJHZnFiNFp0dnRvRmxLNy9sSzJV?=
 =?utf-8?B?SUVUNHByT1ltSkJvbXZ0UWEzZzMwekxocG5uUWdFQWtsT1VlVzRWM1lhSFRt?=
 =?utf-8?B?aS9uMEtqMmV1L3JpWlN6NU0xN3p3NjBIaXFoZGJkUlc5WWdKVjhBOGNveXR3?=
 =?utf-8?B?S0lKd1d1WmlCRE51aXhOWnVJUnE1aGJycGMvZWhYd1ZGSERkOFJ6d0hPc1Vn?=
 =?utf-8?B?bkRCcUZZd3JwaTJ4cnhaU0NNNW5Td2NsRGRUckFGdnlJOGtXSVFHalFQK2Mr?=
 =?utf-8?B?czQ5dk8zZkgzS09GcnpPMXFWUFBrZmFiWlQwT2V6czArTW9Yc25QZm01QXJZ?=
 =?utf-8?B?R0EvR0dJQjVyd3RSOGtOU3pxT3RGWnRXNzMrcVJVV1VJRGhFNEN5d2ZDVjVC?=
 =?utf-8?B?NWlGQnBvRlgyc1JqZG95YXJWellUNWcxMUpXaGk5a3QzQjFBVFRtRjlzdm8x?=
 =?utf-8?B?RjJ4KzFsei9qLzhiaG5TM29Bc0tvN0VCdVFHbDJJVFZQRWxJTHgrNXhhcXdS?=
 =?utf-8?B?aXk0amF2bWtwRzFVWmEwWXZjODZHMStFdFhHRUgrMnhuempSY1cxUXQ5dnRE?=
 =?utf-8?B?aHNGTzRPNTR5UHRBcnhxK2t4bDlRRUVEczVxcFl4TUN1TnZ4MW1CRHd0bXdh?=
 =?utf-8?B?SWhwV08xY0d3dVZCSHJzdDFWTityQlp6dDlhQTI4cGIveFpSQkltSUZqbUQ3?=
 =?utf-8?B?Y1lJVTV4VWYrcXNsRkZJL0loK1ZIa1dXRVRiNFo2dWtwRTJIQVpMRWJzMGx6?=
 =?utf-8?B?UlVUUFRpdGhsQ1VRNkpwejFFOHJwbkJLMGNxQlNoQW50RTQwTDJCRko3NVEy?=
 =?utf-8?B?RUpnS0xiTmtWMHZ5Qmszb1R1Zm9GK1JadG9sVy9obmdvVEZQMkJjeitYNE1R?=
 =?utf-8?B?Nit4blZSdjBYdnFobnB0Ykx2V05Qc3FFOW54KzdqWmx6alNwb1lVd21JMkhU?=
 =?utf-8?B?RWttZElNcWFtdVlCUFJrSk1oYkF6TUdEUUEwOG43M2NLMWhYcGNhOUlaUVRp?=
 =?utf-8?B?MEQxZ0hWbnhlTFJJSElDd2JpenV6VG9kak4zRk1KSFMwaURSYmtSQlQzRjRB?=
 =?utf-8?B?dkRoTnNkYloyeFY3TjhZVFRpYldkMjltK2pBSlJLQzFWRzFVNUhIL2ZnWnRz?=
 =?utf-8?B?dGxoYURBS1hhTFhQTGxiUGJxTWJFWElpYk1NMThWZFoxZFJNWlU3Yy8rWEtM?=
 =?utf-8?B?RUFvdk03NXA5SE41T2ZnbzBOQkRmRkI0TjNZZld1TXQ2c0RZZ0cvd0NTeHpN?=
 =?utf-8?B?WmFkT01Yb1ArNm94WFpUaW9GOUZpbERGT0cvd0RMRHFpSm1tbXo5dUJrYk9B?=
 =?utf-8?B?RVNlS1I0TmU3M25tMFJsU1dENmZCQjkwelZMZFJJbm81bW1aS1dkT2dqY0tP?=
 =?utf-8?B?RkwyT1FYNElxUGZwd01rWGVxczk1NmRkSzRXemJHVkd0Z0pPNllMYS82RnBp?=
 =?utf-8?B?dTNQUFVxdHBvQ0l5UStPNHJFM3JNOEJZT1N4YmJiUVBoTEhmQ29Mc0Ywb1M3?=
 =?utf-8?B?VmpBRzNzaU1SOEcxQkt1NnlGVTVlblIweWk3b21rVXkzdjBQMlc1ZHBkTTYr?=
 =?utf-8?B?d2J3R1FkYVF6QlcyN2VPemNxZktyRWMzSHFNVUdWeC80VFdGQTFRMk5vS2pP?=
 =?utf-8?B?OUhRSjJFM1M3ZEUrVXB1SHZrek4rWk9OTi9KVEZCdng3dTRuVE5Wcm1tcnJl?=
 =?utf-8?B?MDlIb1llU1doWlJDYTFJa2VVRWNXb0c1azRtNG56dytNZmpXQVRaallvcU1j?=
 =?utf-8?B?VDNlLzArZ1JmUWFqRENBREFXZmhrV1hpUEFaVlI3ckh3WEdsalJ0L2I1dWtp?=
 =?utf-8?B?OXBnM2JqL25HWXhrS25OTURJdGg2d3R0OU55WGFrMkx0aEs5b2Z1eWN5MEtE?=
 =?utf-8?B?VzRwUWU3aTB6TU1BRjBEZWFvcFV4VGgrUjc2NG8rSHg2bUpQVFJsN3cwRGJ3?=
 =?utf-8?B?bDMwZjEwTzV3bTcvczcrNHpWZ3dyQi9MN0lOUXV6TVR1VDVzM0ZlaHBvWk1R?=
 =?utf-8?B?QTZGdis2aURHZ1dNYXoweUh4WkZCSzNZNHM3Q2xLZFVkRys0dDJNeEhpR1BC?=
 =?utf-8?B?UHFXSGpTbVpPaG51WlF5dUFjZmVvR3pPZFM5MlZBTHRLbFd5Szc2dkhJQVdL?=
 =?utf-8?B?VHJmWnhSMm9Vc1JPdzFOSml6ZDBCUVlzNkdJMVNGY2tScTRFYnhtQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e6b9d62-0b14-4dd6-d40e-08df351e84c1
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB239779.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2026 18:08:50.3435
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gjMqAXNnkloQ5pOBhcRqDlP4j4eyR7qPpqzwle7WhowIzhdGvUPz3hH1pRoWl+UevWyIiFVmvD9d3y5gkxAFhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV0PR12MB725154



On 23/10/2026 23:06, Bjorn Helgaas wrote:
> External email: Use caution opening links or attachments
> 
> 
> On Thu, Oct 22, 2026 at 10:30:51PM +0300, Tariq Toukan wrote:
>> From: Or Har-Toov <ohartoov@nvidia.com>
>>
>> FW initializes max_tx_speed to the minimum of the port speed and the
>> PCI bandwidth. Modifying it with a value computed by different rules
>> changes the meaning of the field rather than updating it.
>>
>> Limit the aggregated LAG TX speed by the PCIe bandwidth. Clamping each
>> uplink separately and then summing could let the aggregate reach a
>> multiple of the link's real bandwidth, so clamp the sum once instead,
>> counting only the ports that contribute to it.
>>
>> This assumes the bonded PFs share a single PCIe link, which holds when
>> they are functions of the same device. In Socket Direct, each port spans
>> multiple mdevs on separate PCIe links, so the PCIe budget for that port
>> is the sum of its mdevs' PCIe bandwidths. Where Socket Direct ports do
>> not have equal PCIe budgets, the aggregate is clamped to the narrowest
>> port, which under-reports rather than over-reports the available
>> bandwidth.
>>
>> pcie_bandwidth_mbps() reads the endpoint link only, without traversing
>> upstream bridges, and uses the nominal per-lane transfer rate times the
>> link width, without encoding overhead. FW initializes max_tx_speed from
>> the same endpoint-only link status, so using the same calculation keeps
>> the clamp consistent with the value FW programs before LAG. Ethernet
>> speeds and max_tx_speed are likewise nominal rates, so the comparison is
>> like for like. A more accurate bandwidth estimate would make the
>> aggregate differ from the per-vport value FW sets up for the same link.
>>
>> If the PCIe bandwidth of a contributing port cannot be read, the speed
>> calculation fails instead of returning an unclamped or partial result.
>> A device that has no Link Status register, an RC integrated endpoint,
>> has no PCIe budget to apply and is not clamped.
>>
>> Fixes: 50f1d188c580 ("net/mlx5: Propagate LAG effective max_tx_speed to vports")
>> Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
>> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
>> Reviewed-by: Shay Drori <shayd@nvidia.com>
>> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
>> ...
> 
>> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
>> index 8cc6a89130b5..064eef237d6f 100644
>> --- a/drivers/pci/pci.c
>> +++ b/drivers/pci/pci.c
>> @@ -6006,6 +6006,22 @@ int pcie_link_speed_mbps(struct pci_dev *pdev)
>>   }
>>   EXPORT_SYMBOL(pcie_link_speed_mbps);
>>
>> +u32 pcie_bandwidth_mbps(struct pci_dev *pdev)
>> +{
>> +     u16 lnksta;
>> +     u32 width;
>> +     int speed;
>> +
>> +     if (pcie_capability_read_word(pdev, PCI_EXP_LNKSTA, &lnksta))
>> +             return 0;
>> +     speed = pcie_dev_speed_mbps(to_pcie_link_speed(lnksta));
>> +     if (speed <= 0)
>> +             return 0;
>> +     width = FIELD_GET(PCI_EXP_LNKSTA_NLW, lnksta);
>> +     return speed * width;
>> +}
>> +EXPORT_SYMBOL_GPL(pcie_bandwidth_mbps);
> 
> Can you split this into its own patch?
> 
> It looks like cxl_pci_get_bandwidth() and maybe even
> pcie_bandwidth_available() could be refactored to use this.
> 

will do

>>   /**
>>    * pcie_bandwidth_available - determine minimum link settings of a PCIe
>>    *                         device and its bandwidth limitation
>> diff --git a/include/linux/pci.h b/include/linux/pci.h
>> index 5ffcf5ce8c96..202bc8680601 100644
>> --- a/include/linux/pci.h
>> +++ b/include/linux/pci.h
>> @@ -1479,6 +1479,8 @@ u32 pcie_bandwidth_available(struct pci_dev *dev, struct pci_dev **limiting_dev,
>>                             enum pci_bus_speed *speed,
>>                             enum pcie_link_width *width);
>>   int pcie_link_speed_mbps(struct pci_dev *pdev);
>> +u32 pcie_bandwidth_mbps(struct pci_dev *pdev);
>> +
>>   void pcie_print_link_status(struct pci_dev *dev);
>>   int pcie_reset_flr(struct pci_dev *dev, bool probe);
>>   int pcie_flr(struct pci_dev *dev);
>> --
>> 2.44.0
>>

