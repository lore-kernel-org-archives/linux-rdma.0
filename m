Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9D338F25A;
	Fri, 11 Sep 2026 17:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789146667; cv=fail; b=DdAssOcM+kc1/4v2BNkmPHlGxGUEmrLiW6SP7nm1umdAIFIBF/gDqe/aE4JQByNyYE1GkJx7q5QqIk+YN8W6goI2jCizRtuepHsxzxcDMGLoeEdnvvxZjlWD+v77ojv7oiA6OD0fRX4Q+pRUR1F5zvHS95705WLV9u3qCm6zHdg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789146667; c=relaxed/simple;
	bh=qs6OmjRd2uoK7pwru0bJbFBho8oLbLmRUQB9+AEohZs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lWc71yd5AK4DzoR+jaT4jnXnjU6a+KaorgfWm/W2qqtpFOx5xZ+tOJWx1lpRLNmfPTSQjp3KbfPH4n5zKdcEH6xaLD/8hrkIvWaIi6Ds+TK3Zu2THZlMnhho+z2RDVHcYYS0LgoLp7pnz3Vc5Lb7Y6ft/gWWphIMxeKehGJ7rrA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Nb+CIF3x; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=rn3zec6J; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Nb+CIF3x";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="rn3zec6J"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68BDjem92801692;
	Fri, 11 Sep 2026 17:10:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Lpyxb1qteReAK87fKVbPpYwPVGtDR+oH4wGoyF9cftU=; b=
	Nb+CIF3xFjEvx9FUxc4mVJYtvHQGJF9yFvfZ3bwvfYX9kpF9qNH8U2I7vF5qSdtd
	SPQhbfHJpFPcYBr76dlMNToc0QIacWTSq6IU9YMjyIuWsXBb+DFeT6xpLkAPcJE2
	ThaU/A6iRXPllzRnebOGxImV0uH5DnSCa8dA8+oU7RJSjFYh91EzlgWmQVAfqdF/
	v61+8WNuGoi6sktVREMAZX0wqrCOZxFjB96dEzbb8nkgPKQmy79D1LYvMYzcsMBX
	eAl1X2dooeK/C+RHZi7RDpgWQDrTHxvN+TXI97njTmU9s/0T6qdd4Am1OnkOpiyL
	tOZu4VwCduzM0RdUPr+JMQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gkcyqkcf9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Sep 2026 17:10:48 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68BHAMGq024432;
	Fri, 11 Sep 2026 17:10:47 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011031.outbound.protection.outlook.com [52.101.52.31])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gkckmhhtn-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 11 Sep 2026 17:10:47 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fvINdnvvZLRq0VHD7mX6bUGaGs/ONZ54iXqxjlGP3+P/ez3O4oHhWc28iVkD5E3FQtUCdREkNxl9pt9om85rqcIOdB4iLQYpwoK9PnBOaJWzPQN9q2QZXWd2W4tOX8PnMSJC5VeN4Za673ueMxt5FkFH6lnv5rITxN+9UlkwOIVhIX2HdZJcZVYgNVhXrSGyDhSrqTUsMgCiBlwWmlrTmtsj/X5S6haBJPGVzex+lgam8x+GLMoH23jltn0CynG6amNz7/sOnSx8FIiTir6WD4tqFxsIdHiopoT0kXi3HaobtfJrwa03LbMwCUth9p02grOvQcNSMraKIgHGjL4pxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lpyxb1qteReAK87fKVbPpYwPVGtDR+oH4wGoyF9cftU=;
 b=jUBJOfbGd/AsImnIOSEy1oSK6IVfuuuT1+FivjanEjnT5twRI9+8AL66KWSyVPVH/sBwfKkoNy/GldbWswO0vi5u9KW78XXKD83/h2p4jFP3NfUPoH4QVFuoyxdHj73XUFRploGfzjBspURYmbNItGka2Q00oAQYAxkAi3kFTgz97V2liVXnL9KHNpunLy+Q1EUzOdRzE73sXiLzYlA5TXnqIDJkV/nkbZdcyTt4qupMToN40uBY/2LoLWfg6qPF0LssLmu2hLedJHeME3l0qkSc9VXSp+X5V6ulWzGnKKFZTQm8UDUU9cYfOuTkcOnmQxROPEzfAP9my/E3CMMuuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lpyxb1qteReAK87fKVbPpYwPVGtDR+oH4wGoyF9cftU=;
 b=rn3zec6JhpqAGAaVMYxNhsrEOBI2dodC5EVWvB0hgbXp2pqvhxgRsmJQNf6Lm/TdgUSEm1V1Gg+/OzMzQQohscivaRY3UFoPksZi41TWMH0d3C7hS2f5cExHQKlXr96UgyFhkKlIWy+hO7z80kzg2AWJ82nR9C8iggKcyRIzFN4=
Received: from IA1PR10MB6050.namprd10.prod.outlook.com (2603:10b6:208:38a::16)
 by PH0PR10MB4664.namprd10.prod.outlook.com (2603:10b6:510:41::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.7; Fri, 11 Sep
 2026 17:10:43 +0000
Received: from IA1PR10MB6050.namprd10.prod.outlook.com
 ([fe80::645a:f184:3a35:ef9f]) by IA1PR10MB6050.namprd10.prod.outlook.com
 ([fe80::645a:f184:3a35:ef9f%4]) with mapi id 15.21.0428.004; Fri, 11 Sep 2026
 17:10:42 +0000
Message-ID: <c882d09f-a4b9-4a56-9f60-a0e32e165ead@oracle.com>
Date: Fri, 11 Sep 2026 10:10:38 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [rds-devel] [External] : Re: [PATCH net] rds: ib: use
 rds_conn_drop() on protocol version mismatch
Content-Language: en-US
To: Allison Henderson <achender@kernel.org>,
        henrymei <ljp1205831794@gmail.com>, netdev@vger.kernel.org
Cc: linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
        santosh.shilimkar@oracle.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
        Aohan Mei <henrymei@tencent.com>,
        TencentOS Corvus AI <corvus@tencent.com>, stable@vger.kernel.org
References: <20260908123356.1163970-1-henrymei@tencent.com>
 <4fda023c1e7152aee2d5f977f5045dcddcd08d8d.camel@kernel.org>
 <10cf2701-211a-42fe-bb1b-c218d718ed2b@oracle.com>
 <2338b4729960abdf0c753d39cb3b7056421bac18.camel@kernel.org>
 <a4b5d873-4746-4e36-ae15-c45957459fb4@oracle.com>
 <06792614227360acd42d62693d0af78d0f9e947e.camel@kernel.org>
 <22d59d86-91a6-4df5-8502-0885b25c4761@oracle.com>
 <71f12722dde5d7fc8e8507173016fa4f7681995b.camel@kernel.org>
From: Gerd Rausch <gerd.rausch@oracle.com>
In-Reply-To: <71f12722dde5d7fc8e8507173016fa4f7681995b.camel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0133.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::18) To IA1PR10MB6050.namprd10.prod.outlook.com
 (2603:10b6:208:38a::16)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR10MB6050:EE_|PH0PR10MB4664:EE_
X-MS-Office365-Filtering-Correlation-Id: 73536393-69c9-4c6d-2dee-08df10279c67
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|23010399003|1800799024|10067099003|4143699003|6133799003|3023799007|18002099003|22082099003|56012099006|5023799004;
X-Microsoft-Antispam-Message-Info:
	M5xSl1CW9REZ7UhFApxjdpJ32lgsHG0wCIKepPHoyYHn9iQ814DNvqxo3VrHH57nMjEGTLa8b3zQToyICZWayR+siwbBc87TNivr1nZsWeDbeNgWDDCctaWiFX6XxKkhy+tiOycsG2R3ueDyOIj+FAoW4aDoFgVxlvPU32uREZaNkRz91Ank9e/bUmMVB3maStU8uViI9Bf+k7cz39uzm6c3A25l2lq3DU0YRI0wO5Cn5LyUePohnKoArloOjtLwTw/KnC07nfv1u2utzsHD8QGv/MjNkcDnH3NTEaAt5znu/yVj1nCWeRrQoQCsdCpARXfzln3CTm649jCMhsDtCJi2loym0xY9ZYMhItHLlalBH9op2TmEROl98Sbi7id2PC12sUHzO1i4p0oF6cAp7THu6tjiRXamUgO1zKw4uOgcfR5C/UOyegTTjIb2bE/Lnwo+mg2aA1kWcKdfJL31m57oowICQ/cGWa17CYg7ggQ1WtYrpzoXFyokZBg8wJpfuzjQu8NCk9IqwJwAm4AcD+Rf69tZtpvVwTGjnD3uW571fHyWFMn90TbsYfdY3uCuy3UfZDB/KPPLxUzUdTehspfCHC0I5N/9GVniT7sqqdoPhtiBHN/gIyMCkHjXFHnNgNdN/5ErMTrMe8aSvpKMrpXfkYSAtMDhRlU6d0wg4ps=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR10MB6050.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(23010399003)(1800799024)(10067099003)(4143699003)(6133799003)(3023799007)(18002099003)(22082099003)(56012099006)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TGorUDVlZHljQzFhMlAza3FtNmIrNGMrQmg5VVVIZjF0YVdmcThVdWVLYk83?=
 =?utf-8?B?Vmg1RGk5bmR0RHc2eEIwOXBJSU0yRm1MaGw5YnZIOVhkQzhQMWtWOWJydGZS?=
 =?utf-8?B?ZGJyb2laemZ1T3owVHhNOXhScXRCT1RvYTB6ZjZsVHh3L2FvUC85ZWxhSzBX?=
 =?utf-8?B?RE1iTzI4V0Rya0dNdjJWa2tJWitXek9GNGgrSHMxRDcyY3lqekU5MFNYWnJm?=
 =?utf-8?B?dmRJem1qZ0laWmwyR2dKQU5qdjVsN21qVVVEOEs2US9tZ0w4SGRkVDJseWhw?=
 =?utf-8?B?QkZSNUp5UXVtK292SnJjSkRUSit3anpWYjZlbFdyV09aVVpsRHlkRloxbUVN?=
 =?utf-8?B?anRPT1MrTWVXaUpURHJoenlOZ2dBTWluS0ZwektqSGFHeHFPN2Y0YkdwdWxS?=
 =?utf-8?B?U3JIajFJaDM4S05FRmduNDhKNW1EWVpvQWtDL0Y1SzBkYnQ4enZhd0h3RjEr?=
 =?utf-8?B?SFJVcmNaQjJDWFBPUThYTXU3LzdMSjNseGszN1BEZ2pNRldqSksrNmxObmR4?=
 =?utf-8?B?eGtTMG1SNmJLQUkrdHZTeDF0WnV6Ty9rY3RFT2NrMGVzd0MyeGNvWDZRa284?=
 =?utf-8?B?WEtvNmpZNDdZWDl5MElVYThkUld2UCtreTZzdVJJcFVZeFloQktkclVHTG9K?=
 =?utf-8?B?NHlGclR4a0plZ1k3eHpwdTJiTVVaR29kbmNvek9DajY2anlwa3MzVWY5aGdT?=
 =?utf-8?B?OUN2U1dqbXB3R01FRzQyZ3VJTzkreDNXa0lYTGVGZ21TY2xUTWIwVitveXdP?=
 =?utf-8?B?bzBvNUM0MUFhblBSWDY4dmdscGI0M3pMaWxjZEpLT2pPN204UHFtSEx1aDNX?=
 =?utf-8?B?dkt4UCt6VG1Ba2N6bGI3MjNzckFNNENBbS83Yk5nMjEzRjNiNnZ0dkhvVUZ2?=
 =?utf-8?B?RStzZU1Ybjl0TGNmQjZrYWFoQlRvVUQ4cHlxb2hQYTJtbklMc3V5MTgxSjV1?=
 =?utf-8?B?R3VmWmtFbEVHMDloK2N1UUg5RFRmS080aC81R3ZFSGpOcWwyRzZkem5NREdl?=
 =?utf-8?B?dEdFalFSbUt6VjdQK1I3OFh0RFBSb0F2dEVsQndCc2FNZEZmOHFEeGFrODE3?=
 =?utf-8?B?WUFlQzZkYm93YVpwcjNvUVlBcGZLRENHMytONldPREtEOGR4TDBhMlVERkcz?=
 =?utf-8?B?M2l4MFlUYWxNQ0k3dUh4NS83UTdmZTZZdTRYMHlDUldocU9YK21wNVdJMFdz?=
 =?utf-8?B?bFNsaE1uQkF6U2ZYT00ycURtdzVueDMrWFZsVjBGYlJtNmZTWm1OSjk2dWo0?=
 =?utf-8?B?dTJ4UzFGajluQUVRc09KRXRPK0tsNlVwbDU3RjgyRXlKS2l4dWc4NTJkUFAy?=
 =?utf-8?B?WHFuZzFMU1ByNjNId3E3R0l3T2F2WVozaHgrREZtUW9xQXBYNWluSjNqTGtX?=
 =?utf-8?B?RHJZWmliMExLNTNrNDdzSWxFUStwdFh1TnB4SHczTUNkRDAyZldwK3hTTU1M?=
 =?utf-8?B?WGIwZTNKem5CMklGRmZ4SWJPbGxXd3ExMUJsQlY5YmgrZndYeHg0RGtyNlJq?=
 =?utf-8?B?SVRLU2wzY2cvb3RaNkl0YXd3TUpocDlxSU51U3JlQVJHVWdsVzlFTi94eFND?=
 =?utf-8?B?MWZOUDZuZkNkVFVGaUg5YU10MHFoVGlmSFJrendyTW9jZnp2alRhT2lmL1RM?=
 =?utf-8?B?UG5PQXhTdTFZMm5pVW5nSkZldmVsRmtyMnNLY2JlRFE3NkhxRU5pclZxSll6?=
 =?utf-8?B?UmU2eDk2OHY2cFpuQ0xEQllxOVlEd0NRaTJ3NFFoUXMzRDdyNlVjZkwzUkxL?=
 =?utf-8?B?Z3NXVk5BSUV0Q09FTHMzSitHMVdQZ0N1VWdVaXAyWjN0NkdLczJxUkZsdFBl?=
 =?utf-8?B?dGNLWndsWkNFRGtNdlhNNkx5bjVySHJsT2ExeVVmOVEzUkJtZUxCMHNTQ2dY?=
 =?utf-8?B?Qk5Cb0FKL01NRVpzcnN6ekNCN3lZVzgwL3RiSVN0Nzh4TjZBTFJTYWtSZ3JQ?=
 =?utf-8?B?MXNYMDJBNVVGMS80QUIzTENNS3R4bG9oaWJudytqMC9oTzZCcUtxUXY4dUtq?=
 =?utf-8?B?aERQQnUzd1pUUytTRTUxTWRiRlpyQzM3QnJhVEZMdGJ3UmM3NFBMTVVYRHBQ?=
 =?utf-8?B?dTNLazhXeERMV29TQUdCczBCNFVhZlVyeXBhd2pRekxzTkcvY0dFa2pSQ0Jn?=
 =?utf-8?B?cmpUcDBSUzZKVXJQMWYwUi94TVZmVnU0WmR3ZTJpN1dvMXYzZWhWblpVVW84?=
 =?utf-8?B?M0ZyRFAyZmJQdTBieHBSMHZiUnlxS0ZMQkt5ZkI3VVZOUVNEWGZOdlhLUm11?=
 =?utf-8?B?M2JiejZzUUk1YzdjZjFUQjJjWUJzbGF2SDdzUUJ2ekR3cG5jMHBld2lVMEFa?=
 =?utf-8?B?M2lDSStLakZ0M3BUeDFXOW5UVnc1U0hCa0RGUjZhZ2dER29MRERwUT09?=
X-Exchange-RoutingPolicyChecked:
	xdyOtioYshV/3vqmH+HHHXlKsm4noLg4YdSUmBkajYb6oiHHtUAyL+ZQdFDl293Jpjf0ytCuszViF8KrJkS1QLi2/eH0lSC/iarSDM7ULDzcIn1JjoxdwRxvJRmyGcdECvOUGNEUBB0aeb+vLSLfRyEqVpij29M2RhFDjJTZCBgN3UsahNvJqHN+d+JVFmGJoQpG9s20TJ2SKYgp2kqqoVnYWbQX7VyE+hPEYmHfSQyx25aRDBaTKsCa7tf8xnpNp+qqvcorxBq9OOIAfayGDd/UUbiheF15DPp6RLaSsI4NFu/3C6/+8xNz+QX+a8emniJhKsXwWrNVSk6mSUclSw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nshcZgdH+yvVGfomuas2Ji2Y5flIW5M3uwoz0TVrY5kFk57Tj0ViofjD4taFtw5I2mdoaD6ydSBGCfk6HLUN3RZNxUkzDE8soJN+x0vkAQgs/8UWICWnta4oBJ99FLCWuW48FZYkn2qiPfQRHyvbz6qMns/yVUjBOYqahkKKDInmFufuTU64q5fbvhBxFT2jgMqkTf/tghGZaXBrJEuVGBd3kt7Em3uBxcv+ClZur6sWzUm4eU5MOh1QO9OY2q2SL4VEcrCn2ochLWcVQYu+LEF3PCw53mmzsalwFJu4UGQG2SiY+VP1OC+UvmEjVLrGRA6fOMNw8TIMOW5/jAmfXpqqkROdXGgqfQdZ5xPO8y0wmBqi6B4arNGSkvs5SCb8UgEgBlZxBzIDapTkrm1tgXMDogaOLBBPVBI5OLNR0tWg+wL2jTYg1f0MJa7uCyCibrY+EIE0NstEC7IvVih56ahaFoY9S0PRrTWJrYwDYNsgCvjoAs9n5f658a83Cutfrqt7Bs43p2e00ZhynQXApmN64Wdkt3YgQ1nWZFzyWUPXpFlfm0Lxb2Keqsnvj2nFqbrA5Wwmd+GBWYDmp0qO8sYS3HyC8KLCNvyDYAaFGMo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73536393-69c9-4c6d-2dee-08df10279c67
X-MS-Exchange-CrossTenant-AuthSource: IA1PR10MB6050.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2026 17:10:42.5515
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cLQWoXMfM7pPbpBmPl1lsClr9rtShQExqzag5YQZ/RkgtuCC90YuMeYm+2nSPmN7b8dGgVbHJ2ZIPPd33A3CMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4664
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-11_05,2026-09-11_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 lowpriorityscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2609040000 definitions=main-2609110240
X-Proofpoint-GUID: RYKz5kocrdcRZUkEFpojIsdvAE5DP22e
X-Authority-Analysis: v=2.4 cv=CcWdd7rl c=1 sm=1 tr=0 ts=6aa43619 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=b5F0YJyuvLZnYgWSOiYA:9
 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf
 awl=host:13533
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTExMDIzOSBTYWx0ZWRfX5N0HUxWG33Eh
 vJnaBWgwMo0QlHdCqQlGieGOT0+3FX/36hPu0qnERslwL/9eSHdfnXF+yijXwEcTvGyxxE4d4Dl
 nvC0aJmeSfpsh3E/tIqNxqmHHLiHCSGev7ReDWdqDFUa4hKwhz1V
X-Proofpoint-ORIG-GUID: RYKz5kocrdcRZUkEFpojIsdvAE5DP22e
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTExMDIzOSBTYWx0ZWRfXyOsPnR0WBkc+
 W2h3U1bOMEN4qSGHUjCOrIu881neAbryGcCNlY9+7yExdjyBTeDjGyAMEPldE6q2NtFGuavxtDM
 m+D+KKDH/26XE0qoubeYhisQwy4E4IL30ZtvOZsNDkpierxODWu5taMsHtZAFQQOLSBCY4yEkCq
 6j+twjrAwuELrcTjpA6Hilll4Ty3C2g1Wz2/30KJsrfcn4kzBUaaR9jEmVotGMFJHr3TXEiHlz3
 CFJNML5Wz6rE9QdGdSmiSD5XoN0Lk1afL4ChJ5tZWQGEOcDkfpj1HcUYwNDUpD46zcIaa0R58Xt
 8msVkZYTSmX/q9c0VzDA8U5Ff6k+6kJwcR+KtHDweILy5g5ud/U/ep9469VXWgh4NS8Ego8KoSt
 Yj4OcKLJLGU71fjgAKgfuZY3m8fjdQrzH2LkmhIO6tlJzKEyP46GvXqkhWiw0RFcZghAZCvUtr/
 s26i0+M78o0/t6DX8zkuhRbRrzwdq764mjft2NJA=

Hi Allison,

On 2026-09-11 01:19, Allison Henderson wrote:
> On Thu, 2026-09-10 at 16:56 -0700, Gerd Rausch wrote:

>> On 2026-09-10 15:58, Allison Henderson wrote:
>>> On Thu, 2026-09-10 at 10:08 -0700, Gerd Rausch wrote:
>> But rds_ib_cm_handle_connect() issues a rdma_reject(IB_CM_REJ_CONSUMER_DEFINED) with payload
>> err = 1 (aka RDS_RDMA_REJ_INCOMPAT) not only if rds_ib_protocol_compatible()
>> returns zero, but all sorts of other scenarios also.
> 
> Yes, err starts as 1 and the conn-create failure and connect-race exits
> go to the reject without changing it.  So you are correct that the peer can't tell
> "incompatible" from "you raced me".

It definitely can tell that difference.

Also not done well, but there's backoff and counters in
rds_ib_cm_handle_connect() for when a race happens.

> That's a wart, and worth a patch of its
> own to give those exits their own code.  But I still think it's separate from this
> fix, since it doesn't touch the reject side in either direction.
> 

The point I was trying to make is that the party that received the RDS_RDMA_REJ_INCOMPAT
ought to be the one to try the reconnect.
That can only be guaranteed if the other party doesn't attempt to connect.
And that only happens if the other party does a rds_conn_destroy(),
and not a rds_conn_drop(), because the later will keep the connection with the
incompatible version number alive.

A rds_conn_drop() with a valid "i_cm_id" will lead to various CMA rejection
messages to be sent out, depending on state (DREQ, REJ, etc.),
once the RDS code reaches rdma_destroy_id().

The fact this change is in a different function is immaterial.
Keeping a RDS-connection that's considered incompatible alive,
and keep trying, makes the difference.

>> And then the RDS/client (actually the CM layer) sends out an RTU, that makes the RDS/server
>> land inside rds_ib_cm_connect_complete() too, but with "private_data_len==0".
>>
>> So a "major == 0" doesn't imply something being truncated nor it being
>> a fresh conn, but simply is the last step you see on an RDS/server
>> during connection establishment.
> 
> Also right, and I should have specified "on the active side".  On the
> passive side the version was already set from the REQ in
> rds_ib_cm_handle_connect(), and it is always 3.1 or newer there
> because anything else was rejected before the accept.
> So the RTU arriving with no payload leaves a valid c_version in place and the> branch can't fire.  That also means the changed line only runs
> on the active side, and only when the REP says 3.0 or says nothing.
> 

The branch can fire, because the protocol is updated on the client
side via rds_ib_set_protocol().

Both "private_data" payloads from rdma_connect() and rdma_accept()
are seen by RDS.

The one from rdma_connect() is processed by rds_ib_cm_handle_connect()
on the other side (i.e. server).

The one from rdma_accept() is processed by rds_ib_cm_connect_complete()
on the other side (i.e. client).

What version is provided to and seen by the client depends on this
weird function rds_ib_protocol_compatible(), as implemented by the peer,
which apparently has undergone many organic changes over the years.

In the context of this patch submission, we are talking
about the "if (c_version < RDS_PROTOCOL_VERSION)" being true,
because the change is done within that block of code.

And it can be true, because the peer can supply any old version
via rdma_accept().
If it couldn't be true, we could just remove the block.

So we know that the server responded with an incompatible version
that is neither >=RDS_PROTOCOL_VERSION nor ==RDS_PROTOCOL_COMPAT_VERSION,
and thus can't just accept it.

Prior to this suggested patch, that was done via rds_conn_destroy().

This patch suggests to replace that by a rds_conn_drop(),
and thus allow the client to keep trying.

But how can that be correct?

What makes the next connection attempt by this client different
in a way that makes us expect a different response from the server
than it got last time?

What mechanism makes us believe that next time around, we won't
end up in the exact same code-block?

And again. And again.
  >>
>> The important bit that's missing here is that the side that did the
>> "c_proposed_version = RDS_PROTOCOL_COMPAT_VERSION" downgrade
>> is the one that needs to initiate.
>>
>> Or else, we run the risk of running into endless loops of trying the same
>> thing again and again and again.
> 
> Well, there is a downgrade in the REJECTED path, and the downgrading side
> probably should be the one to retry.  But in the branch this
> patch changes, nobody rejected.  The peer accepted, with a version below
> the floor, so there's no downgrade available to either side.
> 

If the version is considered incompatible, there are two options:

1) Downgrade and speak a common version.
2) Just give up. I.e. rds_conn_destroy().

It looks like #2 was the choice in the past.

If we don't want to give up, then there ought to be a downgrade.

How can this patch be accepted while you say
"there's no downgrade available to either side."

How would we expect a different result by just repeatedly proposing
the same incompatible version to the peer?

> So the loop is there either way.  The conn is torn down (via destroy or
> by drop), the peer gets a DISCONNECTED, drops, and reconnects to us on
> its own timer (IB has no smaller-address rule in rds_queue_reconnect()),
> and we reject it in rds_ib_cm_handle_connect() every time.
> 
> Destroy doesn't make the peer back off; it just moves the 1 second loop> to their side of the wire.  The next sendmsg() on our side starts it
> again from ours. The thing that actually stops the loop is "retry only
> when an application sends", which is the follow-up I'd like to see, and
> would need to cover the REJECTED path too.
> 

There's a world of a difference between a sendmsg() triggering a
reconnect, and RDS doing it on its own every second, with no hope
of success, because it is known that both sides are incompatible with eachother.

If RDS is expected to retry, it should do so with a common version,
understood by both sides.

If RDS is not expected to retry, there's no way around rds_conn_destroy().

I don't get the argument that rds_conn_destroy() ought to not
be called except in the rmmod-path.

Is the assumption that there couldn't be two totally incompatible
versions out there in the wild, for which RDS ought to give up,
and thus would have to call rds_conn_destroy() outside
the rmmod-path?

If there are bugs in the rds_conn_destroy() path, they ought to be fixed.

>>
>> But this whole protocol negotation in RDS is rather broken.
>> I guess some would call it "organically grown over the years".
>>
> 
> Agreed, I don't think anyone would dispute that RDS has plenty
> of things to fix.  But to me that's the reason to shepherd small,
> targeted fixes through one at a time rather than gate them on
> each other, or on a rework of the negotiation.
> This one turns a> node-wide hang into the same retry loop the peer already drives today,
> with a one-line change that's easy to revert when we get to larger
> changes.
> 
> So my suggestion would be: take Aohan's fix as is for net, and treat
> the reject-code cleanup, the send-driven retry, and any negotiation
> rework as separate net-next patches.  I'd be glad to review any of
> them, and happy to help with the send-driven one if you'd like to
> take it.
> 

I guess we differ that this is a fix and net improvement.

IMO this change makes things worse.

Thanks,

   Gerd

