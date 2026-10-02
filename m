Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8560825B0B7;
	Fri,  2 Oct 2026 21:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790976821; cv=fail; b=lfad9eAa1qGrOKV2le9MGWq8RLYiw15Be2qQJzXduE0lYKxPO+7+I30MQmW7oaGbmT+Dct0nya7XSfFZZiVRXX7IFaIYlFF8lg1xO0zJxp6IXwanLYdegszc6ocNOXl2bi87iLp61sjUJYzb6keusLMzvF7Up9pAEc86/UpBE+4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790976821; c=relaxed/simple;
	bh=hG4bc46i7PaerBZhGnHrf054UdArNMQolBdmRRRiijE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=e9ka+WjfZRFcKixS9WE/Wj+o9G30T1Nsl713daPIFv96FD/vA6qGrY6uKP8PuaDTkCLcCWqLT1jITFstofe29EyAkj+8Vo4tppl82cxiIW2avBT8KOxqJLdEXsRMADqAoa85mXGHwv23xsTiNyA8YDzCwgESzeUyCFi7lw8FK/4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Atz1afOk; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=QZiYkEfP; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Atz1afOk";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="QZiYkEfP"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 692Ec4Nd730657;
	Fri, 2 Oct 2026 21:33:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=8z7sV1zdrfL53k4zB0cGz8l4POzzQazlp+tSYb73EBM=; b=
	Atz1afOkrWf8KGUObeDBFNqw6qwdW92L/ffAV4VHCbUS9LkGx999w0pDNgO1QIoZ
	S4NXETJvldc7Nnm3e+kv7UitcMoJfR3lpFBwco4KoCs6NusYqtg3e8GjVdx7bGBN
	CjdLcyum3I0XtDFK5cmRm5UgvqWfl/diVWfneBYFAAVoZXaSt+/AyXoMT6Ip5VVb
	fVuwoemoQEfhACuIx/agGs1ildnJPwvtpfEjKJc0NW8g7dUwXAgC+vnggZ5slQ6o
	Hac07wSSnyEm800nEwzk76XgtUNnFsKjkwkjkdAlnDAdWUy2kwXwnW4Tf5tqmC3o
	mXIwkPO1ltUcWu8wNFYZmA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gx63c4s0c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 02 Oct 2026 21:33:34 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 692LKNOO014520;
	Fri, 2 Oct 2026 21:33:34 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010015.outbound.protection.outlook.com [52.101.193.15])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gx4gu4pxg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 02 Oct 2026 21:33:34 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ou8HEc/4OsycB7WLCEeeKGhKSwS4ndmcs+w2HUq8Y5aeQKMHKnBGHL3LVydT7auHmgr/rAKBCGLgkT9mumDZAp5o2wGPjdh1ZwWi+E5PynR/tlkgCgwwZiJoH5huONlIrwVrDss4jZsGA7wxOTLpSS7AmcRL2kUj7MRykjGGcE1F/W+B9DFXvRq7Jn5ZbMsjx2D0rRjfcYcCreyZG7B+R0G1tIMzCCokGmzW2aUEqkHtpaRJLTeVGYNgjrB7kj59SBl4shRtY/xlNMK0w4ynHlpuwljntxJXsZOs0Lrq2BjxcDhMuNFmlFAq+ZDKVZy22326GIgspAZniW2Dhwg7wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8z7sV1zdrfL53k4zB0cGz8l4POzzQazlp+tSYb73EBM=;
 b=Nj2AB5xxwv2G4hDi2cdF7L65JViRMVEft4xVCJ+Ybbbnc1iKYdI4QYYgMGv57gx1pEK6iuPZLhGvSk7Xdecu3+yk1HHizqzPg/gVm/+ashKx4HYoSd18JrT7LuQf1n3SEWxrV/zQnQ8UubAcq3fCVqaeLr15kglzHB/XwopprFD7WBIdd/AuoqBU5ES16Y0WZ28XKAFXlZZ6CkKQY7zdttVjphr8ucOQCMmCWYh0JUFa/mxuXpzIPCKzpAB9D2aUE8tcY4jHWDmSf6TBQwD+Bxag+v7cT4wKQv/SdktgRAvAixICaeAsF3X+5FwF+HMLAUudwGnbpx12glYhRQ2tVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8z7sV1zdrfL53k4zB0cGz8l4POzzQazlp+tSYb73EBM=;
 b=QZiYkEfPYMzZL0/eZ6BQV6uIduLRkFZy1ooSVCamt3YuarqlfpiUZ59tLzcbz9iYY4i3KqeozYuKZURxmm2+l/cQLJxiMVzxdmyJRDKbcrDF5urML7opdJhm3w2J3nw6s2n3atUfiJQY0pguGHQewkAEA4Npd5YMDUAsMH9iEhw=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from LV3PR10MB7796.namprd10.prod.outlook.com (2603:10b6:408:1ae::6)
 by IA1PR10MB7213.namprd10.prod.outlook.com (2603:10b6:208:3f2::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.14; Fri, 2 Oct
 2026 21:33:31 +0000
Received: from LV3PR10MB7796.namprd10.prod.outlook.com
 ([fe80::a30e:ee88:c7b4:c0d8]) by LV3PR10MB7796.namprd10.prod.outlook.com
 ([fe80::a30e:ee88:c7b4:c0d8%5]) with mapi id 15.21.0472.012; Fri, 2 Oct 2026
 21:33:31 +0000
Message-ID: <1517a795-a321-48c2-b896-f0f554fa066a@oracle.com>
Date: Fri, 2 Oct 2026 14:33:29 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net/mlx5: retain command mailboxes after timeout
To: netdev-bot+sinfo@kernel.org
Cc: saeedm@nvidia.com, leonro@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20261002205649.2029588-1-manjunath.b.patil@oracle.com>
 <179097470162.1402591.16776600563260914451@kernel.org>
Content-Language: en-US
From: manjunath.b.patil@oracle.com
In-Reply-To: <179097470162.1402591.16776600563260914451@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH0P220CA0013.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:d3::11) To LV3PR10MB7796.namprd10.prod.outlook.com
 (2603:10b6:408:1ae::6)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR10MB7796:EE_|IA1PR10MB7213:EE_
X-MS-Office365-Filtering-Correlation-Id: b7109272-d2d2-40e1-2f9a-08df20cccdd1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|10067099003|56012099006|6133799003|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	IsowneWIr36l2yPxifXLoTqRGIG2dZnR//7HnS70f8L9blezOaC1iytIT3SPxUXhg59rP0styekw/0HZd7ZUTW9RwWhz02zNMir6HOItLBpDaudLyQ+3b/Y9A7wQ/XWp1hwvGI4QrBsCdTgo/uLUiC5EABA/l4N7Tt2nKqjWkONHoMZKn2yFS/6vlO/VSCvFWdR3RbdUU2F5DjOLrr0gE7PEdRv4fJ4KkOKA5SXvksdU4Ia4CCyuPI0AGV2nUN1JuMhpxL+5Ec09J64aeVfYkK3rOdp9ZxvMjH2Tm1Sk6zHn7g44DnMeShonrz9XeExICejXCBpV3LxoK5JWtrUOg776o7Uqdt9IBBY3SlJRtDq1vmoTJmv2mK5tVmmfswgayDWyrT/qL6H3KxbPRHzSO1mftcZivvWxah9ttDR04zNwfJArsaG7wDAFT5oxgCIu1vsEDmQ5Uk2zMHAf7W52lnBSwF9zJUJsw0bmEXpYVLhH+KVW1UVnxPkSJ5emrid59rjEHOgSmGxMevvm263m9hxSanQ32C3BlwGicMx/zl1U/ibiTuoDRfI04crdYz9i+IvFsKeAnqBFZRE7t4OdwjrKwSxPqzZytnFLJCVe7SzRH6eSULOSg/yzJqNAnEAiD9qCkSjfKCJpWAM/dD2VyMvlYScmZ7FRQzOp0o6wdKI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR10MB7796.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(10067099003)(56012099006)(6133799003)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?STFUVXhRNzUwc01pS2VaOXpyY29tdXRMRWhXL2t5ZCtKZVZxSlBwV1dkdnV1?=
 =?utf-8?B?R3RrM1dydnBzY0JFaERpaGJBWE9lY1dDV0hsbmhJWXYrbzA4Q2Q3c1BzTENT?=
 =?utf-8?B?Z0JSNURmNHpTZGIraGJQY2VzWUI5QjZlM2FjbXVXcEI4dGtLdEtMTk02cmty?=
 =?utf-8?B?ZmV1ZWhaczFBSTRDSHVCWEZnRWYrb3JDV0xjYWN5UlNGaUs5OFRaVnVyWFpC?=
 =?utf-8?B?TWtBbmVPYVdmZzJlNTV2NG90bXdBSlRSYXZUdE5OWE03MXhDKzE4bFJXUW9j?=
 =?utf-8?B?ZnZxTWgrUEZxMlVMNjJRdzBzeXRQYm50eFJMQkoxbnFaRlVvTm02bjNzVlhi?=
 =?utf-8?B?TXNkT1JCWEJZQk9pZEVWcllCdWM4Q2tGTFNCM1Q0Y3dyd3NOeDdOaWNQVGRk?=
 =?utf-8?B?NURKS2pyYlp6OWRMdUhnWnJoYUozeUl6Y25BZWdBOE9YeDJxeG91MENZSzIz?=
 =?utf-8?B?R3FSWitoSTdyRjdJZXNZenBzSlF4MGZkQVAvNHcwWkYvQ1BwejdiaE80ZldI?=
 =?utf-8?B?OHJGY1lKczNENUUrM0JUTHlDZzdNem5Ickx2bVE1SXJCRUhOSlhjQlF4QnVK?=
 =?utf-8?B?WWxSakYxYmpkT092YUhnQ2lOWWQ5YklFemp6TGxBZVlKUk84N1lycVovME9G?=
 =?utf-8?B?cGsvcEFLaTB1V2xQSTBBdDNWZGlZaDFPVENRek4wdXErSDVpNUgzSHZOb2NZ?=
 =?utf-8?B?YituV0ZnSTlaQy90ZTk4VUpLRllXa2I5RzJsVVJZbTY3dzBzTkNFYzB1YVBO?=
 =?utf-8?B?YThwYUFaZGdRNkhqcWVQTTRLY2RTaVNnc0RYU0ZzM3N5SVRKcTFPOGN1UEJU?=
 =?utf-8?B?U21aMUhqUE1FaEQ0TWk5RlgvalBBMXNxTnBGSzZTWkxaRDg2M01RUWVBRDlu?=
 =?utf-8?B?UDVaYjdtc1JPTGRTLzFJbFdTV2E4RnVUR3ZzdzBmSHNqaG9aTzJJc004R3ZK?=
 =?utf-8?B?bnMvbE45UTBrNitvQXorTzdxdm54RHcvUllGbHF1ZjdadVdzQURLa0N5RTBB?=
 =?utf-8?B?VC9DcW0wOXlKNytWa0Rjc0tGbmtBcTM5SHJKREpEVmoxM3huaHZIaEw5aG9J?=
 =?utf-8?B?RlgwV0Y4aFZ6M25wUVNqMEx6TnM4MkVqcHpOeXlHcm9PenBIdTkzZTgzSFBV?=
 =?utf-8?B?S050NjkvM2NQSFZLaEdhdUprOUZGdWs4N25TNFZqNFRJSzJxZFhqZEVkL1pJ?=
 =?utf-8?B?cTI5OWIzT0lRQzJwaXllY2thWDlJMjBKRTVPSkxWUUtZblV6KzZBUWdRVjZX?=
 =?utf-8?B?Yml1cW8yZjdHQ3c4WFNlU3hKcHBORGFmVzNHUjUrcFQyZThPT3FRam83alhn?=
 =?utf-8?B?V2FNREJxdWhrMi9RbmtyYkVSMWxpNmNKa2VDVXFBdWl2REIvUDZWQ04rOW5l?=
 =?utf-8?B?QnpNd3lZSFUrK0tpaDFudksxR3NxdmRjTkcvOWV5bEhoWEVFN2JXNmptV0RJ?=
 =?utf-8?B?QWt4ZWdYditSR2dxYlN3VGVGWHBzaktSOTgyREZmdFhyMWxUL3puZ3BqVzlV?=
 =?utf-8?B?YWo4eXVGQVVZaVpnTUdPY2JJRWNKcTZWUTNuSTdCT01LQmxhdlBMRTJJWkJ4?=
 =?utf-8?B?bDQ3Rmo0VWFWMjMyOWZmYkJLMmNlMFpwWGppRFRHWGgvZGZOYWRLWEVEZGpG?=
 =?utf-8?B?YkluWC9GclJuZjR2TjZ3MFpWYTM0TnAyeVJzRkJ0TEdGZ0tpWGZ5bmRzcUE2?=
 =?utf-8?B?MWV3cW5aM2pYTzN3MDBFOWRHVXVpNnB3UEpOMXRNZFp2TjhoYmprcUlOQVhF?=
 =?utf-8?B?aFBKVERjMDJhejhHaUdtTjY2VStNc2w1UzRXQTZBcU13UWpUajZydHlLTG1h?=
 =?utf-8?B?ZTY2TEhpNnI2Ty9WUkhZWTVhNWZvOEdhOFloY081MTg1eWxZWW5GY0hMeHZv?=
 =?utf-8?B?SFpVanZWUUUzcEtxZlNBbVhmVXRvaHAreHFhUnR1QjlxK0JoT3NhcEd2cHF2?=
 =?utf-8?B?Y2d3cFZmVjd0ZUxZK0Nldi90R2VxOFZGOVVEdHpQdHFncTVWbUxKOHQwa2xi?=
 =?utf-8?B?blMwRnN5cmhzK2o2MjV5ZVk2NlRsaHBsbWtyWDR5VWtKS2t2OFhDbWk1U3Jv?=
 =?utf-8?B?VXlobVBURGZYZVkya3BKZDhVSytmZXZKOWVzMG5KSUxwVXdJbndXaUJWQkxt?=
 =?utf-8?B?Z0ljTGZ4ZDlOYlR2L0Q1SDRYcTV1YjRiUDV4aUNoMW1rcmx6Z2FvV2NxYkVC?=
 =?utf-8?B?bWk2c2xWOUtIRHpocU11SE5TR3FNZlVnaWI4K1lVdHVDMmtHd3JxKzNvcmt6?=
 =?utf-8?B?UWFsYTg2YUMrV0s1UG9MaFFFQmZJWXZDbWlMTlA3UVFINkdLcTZDVU0wbUd2?=
 =?utf-8?B?ZmxuZ0hhck9ESyswbjRWb2JCQlV5dzZ3dWh6UDhzMVN2TjdoNHRFaG1ETE1V?=
 =?utf-8?Q?6c52R23IllHi/liw=3D?=
X-Exchange-RoutingPolicyChecked:
	4qDsF4n5g1kT6a1HvqgHSmQzMOdxSsp4pe3QCu1SfCl0i9sHiwbOR9KeM/s/b09EQ4DTR48skyMP3qdhV3o01qSRdFkxJfVnvh2tfW0bNxxbEYVPvJZoS9XNoYm3YndZb+2kafkY0OQqTQAuwfFmG6M+SmF2eqtPCfINou/aI/DSvk6A0RCPgNygN9wuxKAhCpBKmDR83gfYKT9jTR0iaOkZFuk9OVwTrueTIl9VgJgwtly206vtEzNpB8jB0/2DKtRQ0CH+a0oa/ZbmsIodsbV+f31cnhDnTjbGItNAl8+L3cAOpWDowyTUbK6naMvhjkGRD98bJySNloESOFhJAQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	P9GeyvTDgYhmz6B9wqiQGlfbzw1lJeLoIif8G8jkBADPId+/faTdMfsvxXvLPa7imRrn+BF+5Se3yxwq0y9EAd051iaX/RnToQ3Ho/+T79ADsGJkiyHsu6lcKlcXRgHFW+jlRvmuJVNfyXc5KY/REzk2p+sVvUITsZ5L1vanTIOIVD+AXiKf4qGN07+3w5vgHykvhe5QiYf+CeCk5wwXU8n6zMYBQoLEmJAzlCyGzkos9B6iW8AvUwFqGEuZojfJo5M6Cin8ayy+SRYFFSCMPq/UT5WYSpR1UEl/2+ZMQcQ6khqMT/fQFaV0JANgoiFscNFtYY2LB5nuhXfJmHwWHa7RSb/F+zz3SZ9pcHfR6mLkxN98MpT5XFxeGVsmzjJQzbPaINmyIkytwr2z7ktyfs6DBnNMUzfO9eQgcDO+m5KJe/3qxrmSSmHf/3Rc4IbRWf9ImPR/QhYZNKuUNFYtpR0F/WT81BP2A3qru+Wdg5ifR0ld3xEMKdg6ak18e5i00eDuW5Uv//hskrz2I2eC4/eyCaYEKSOmusm6jxSaAnMXXd+YkNT4M0nvXzeLnrUnXJ4rtBLxIv4Aq4xAqS4Bna0lNJ16SrleO1bTjH1MjBk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7109272-d2d2-40e1-2f9a-08df20cccdd1
X-MS-Exchange-CrossTenant-AuthSource: LV3PR10MB7796.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2026 21:33:30.9560
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xCHOWLdM1tvBPasgQWJ8NuzNDXPn2l01ZW1NqLCJXjqYILdiSssFYb21HbgP9Zpa2nNr/90K4h1XOyxGkj3Xm1xKnRsvkbdIXntPkR7IzSQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7213
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-02_06,2026-10-02_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 bulkscore=0 mlxlogscore=999
 mlxscore=0 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2609040000 definitions=main-2610020085
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAyMDA4NSBTYWx0ZWRfXwjJZFq5A2DJe
 ohoqQNPYpzdRdIQtfIQPYK3yyAlv8JHJRQdLmVuCrwH58/n6+2CmMxEG3scPIzqOMBodrF0ANun
 EH7aInmy0I2qtl/LjuMpCFkK3rQISMmxdDbhqO9+A+2FPxkBCbRy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAyMDA4NSBTYWx0ZWRfX05LLjXt6CcGX
 cwk3a5R+2l/ZWMpn5oiR2u15WwYZ2gXyWVrffqGZn97/f/n3/wM6xaoHgf61qBFnVFfodmCPJNF
 Vnxvr2S9tdzNRERkc7bxSgSU4NCQXXrBlAfTl3DUpapFtt4LPfqfTDpkCf+wyGPjhsIJ6yNUV6r
 i0G+k9rpu4lpykIihtntRvvsFRqYV/iIjAjcqElMaRI1X1mgj+m3/vs5QqZv9lafsrrLle1O0Lb
 eci9wVpTHet7NXxFbv00I+xxl5bxGI2gC1RxxzUdncDuaOPBfIVTJMfBQjx2DAnz2kxSP/CaggA
 dm5X3uysPHsjvHec+UGKbDtdvz5Yql2PPF4T8Ksig3IbtlKwt+ipr+tgL5Vt+vyRlBfG0TQF3UC
 4Uyxs4lJLzpJCnFTXsg9bpdsER9n8GLsaaJyc7wKF42fCwRPdz2mJQEvBfHfeKopb+cHhgQZ+Yu
 NDLyx1vWXn8UNwDQTKMT9j7egsoO05vpbdcb7eIs=
X-Proofpoint-ORIG-GUID: Y66Sk1YEYfp6uP0m6g5YaWtIlLv4MW9A
X-Proofpoint-GUID: Y66Sk1YEYfp6uP0m6g5YaWtIlLv4MW9A
X-Authority-Analysis: v=2.4 cv=PPGaavqC c=1 sm=1 tr=0 ts=6ac0232e b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=VwQbUJbxAAAA:8
 a=dB8PHGjO7sGQ_G3cikUA:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12108


On 10/2/26 1:58 PM, netdev-bot+sinfo@kernel.org wrote:
> Hi!
> 
> This is an automated message. This series looks like a fix, but its
> commit messages seem to be missing some information:
> 
>   - How the issue was discovered, e.g. hit in production, hit during
>     development, syzbot report, manual code inspection, LLM or static
>     analysis tool scan.
> 
>   - Whether the issue was actually triggered, or is only theoretical
>     (e.g. found by code inspection). If it was triggered please include
>     the symptoms, like the stack trace or error messages.
> 
>   - What hardware the change was tested on. For driver fixes please
>     mention the device (and if relevant firmware version) used for
>     testing, or say that the change was not tested on real hardware.
> 
> Please do not repost the series just to address the above. Instead,
> reply to this email with the missing information, so that reviewers
> can take it into account. If the series needs another revision for
> other reasons, please include the information in the commit messages
> then.
> 
> The evaluation is done by an LLM so it may be wrong, if you think
> that is the case please reply and explain.

Hi,

Thanks for the reminder. This was prompted by crashes on two production
systems with mlx5 command timeouts and device-health errors. One log
reported "Command completion arrived after timeout (entry idx = 2)"
shortly before an oops:

   BUG: kernel NULL pointer dereference, address: 0000000000000100
   RIP: dma_pool_alloc+0x3b/0x211
   mlx5_alloc_cmd_msg -> cmd_exec -> mlx5e_update_stats_work

The vmcores showed the mlx5_cmd DMA pool's next_block pointer at 0x100.
Manual inspection of the command timeout path then identified the early
mailbox free addressed by this patch. The production failure is real, 
but we have not proved that late firmware access caused that particular 
pool corruption, nor reproduced the original panic.

I tested the fix on an OL9 x86_64 VM with two passthrough ConnectX-7
SR-IOV VFs, both reporting firmware 28.34.4000. Test-only fault 
injection exercised normal, timeout-late, timeout-reset, timeout-lost, 
and timeout/completion-overlap paths on both VFs. In the overlap test, 
the blocking caller returned -ETIMEDOUT while completion was paused 
before its final mailbox access; the mailboxes and slot remained live 
until completion finished, then were released. There were no KASAN 
reports or kmemleak findings. The overlap uses a synthetic sleepable 
completion worker, not a physical firmware EQ interrupt.

Thanks,
Manjunath
