Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C00C7331ED7;
	Thu, 10 Sep 2026 23:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789084641; cv=fail; b=h7WNM8lRumuVHgAVqR//qzvDiLfnlqfMhYaLIVu/TV21zMpCJxHdrjyeOU0jdxWqudI/5wyYY9oY39RjG5SdQpRq7XlsHVr63dy29I7rlMBXBrXQ2IL8jHFfD+BRVhQ8tcU3JxEk3+VdUdwHvsIuQSmhFeBrsnulLi1SnZQoAzw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789084641; c=relaxed/simple;
	bh=8rervb+8X+DJIADGzJhB6scNE3XIX/lgXTrh9gAe+DI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lFw8/kIQd2jGfWidQIwAahgfPiwrgfGVFQ0pYA44lAiN4bNddNLwLXB8alkz9+3fomPKC12Xcg3lqg4viG+066UNqRPBwhj7pfAtQreR+anIVtEjlLefGm9hwykDs8YMxYjSZWgVNKnlXdEGUAR+9gmUVCSXZnjJUUPp4tfCbAQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZaqCob8o; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=x3r2m+Wn; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZaqCob8o";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="x3r2m+Wn"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68ANNThr1446589;
	Thu, 10 Sep 2026 23:56:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=WZCVfE28xn+ovAfwJ9/65C7dDTXkS/GomeILG4Ia6vQ=; b=
	ZaqCob8oqHfN/BEhiAx1RH+kRenMscu4ea98CQTZ1LqwC2fLih/D1eBVVaNTU+cg
	XnoFhxusnkbosNVhwY3Qc+BYf22iWMTE1/VmVvWAx0vlKJI4rmulMBXxTDFYWNjo
	3ktrO6COTHdRSfi5kM5IsGoOO7qVKhwnJSrCBOdaEXzN2KZYbgS1pehSgARG4f+g
	aEqeIphRWMhXpXQKx74BgMiMSHXm3ZCgIPz+MzCU7ea/uN9++3nQvE43BTE+G+Kh
	sr+AmlKEndL9Zre/D+cLOchKrk5MIIGkumQeZHkaxOXo4GPYlxZOtnxNMywYWDmV
	rY6P7Oqh9SE/kut8f6hwbQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gkcyua6wd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Sep 2026 23:56:57 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68ANtKnN015738;
	Thu, 10 Sep 2026 23:56:56 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011047.outbound.protection.outlook.com [52.101.62.47])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gkckkwkrf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 10 Sep 2026 23:56:56 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IOVBVBg/rPbupM/pxr6K+CVmTPghmzY/U7+hHD+mjItSQqOKZxTSM7OGalSHWkAuBs835ixSJAggLOUpmXLfYaG/T+qs1ch0QgYKZUcSwVCGz280XpT+789RXKoBx1qAC+HQ+esdsVY/R9UnO8uwDSdNTPTtJtNmxZSJqMoA48Sh/b7hi9BoGCR1PgTMuFmRtIS62LCvKs4hZJFTxPe2ANya064uR7V28cgGLQZM50rIJDvPbr9TX65OzZIDPu1XwEQtppL9hF8IJsPw+G//Bb1MjIAaw0WNTmTJ9Hw5BASUESCilg6AcpK49+6Ny2y6tMsWAbEZF5lwbpqALAKDcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WZCVfE28xn+ovAfwJ9/65C7dDTXkS/GomeILG4Ia6vQ=;
 b=brmGYDYBGIZBHp/MOlZUKXIOO37Tb3E3oJZhqqQDEjed1uptwg1+6Tk4MAQRSqb73cAOmU80feFVhKGiprlqvjpiFVzwrmnKKQQCtNoYTcZ0kaHO6MIxcO+dpWiqiYc1xCXd3COvJ8Fa6uDbmlGybJcscl/akFpCXjBnbNfi2zZP4kmLodDumB+iK4PB4Udjb5AGdub81peLPBqyX3hOuu+QjvAFOpkek6HnJ4btwB6+vMWQCoSwdZIX+8lWynTSMPVjuBlIptIi7JiY55m70Gbus5jFEXHeCdnxsnaJL2kZKUbRJQkAPL18aC5qdlM/lWBPk9H1NibYsV9vLo/VWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WZCVfE28xn+ovAfwJ9/65C7dDTXkS/GomeILG4Ia6vQ=;
 b=x3r2m+WnjFO7QYn0bG/MSqSDGJBYpQbpGgLRPfY9+6LECVshcnU7oTezaoAjN5z/Gj4iCbpRmIIDbpx/kNbFYGTEVjYbckWODrnw9wFuUugKOEGbBcxEiWov6ewB1uc+G+s+YtlMIClXlaBWaMfewqZ/Y1FczlJPnATtSgEgmoA=
Received: from IA1PR10MB6050.namprd10.prod.outlook.com (2603:10b6:208:38a::16)
 by SAWPR10MB997789.namprd10.prod.outlook.com (2603:10b6:806:4e4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Thu, 10 Sep
 2026 23:56:51 +0000
Received: from IA1PR10MB6050.namprd10.prod.outlook.com
 ([fe80::645a:f184:3a35:ef9f]) by IA1PR10MB6050.namprd10.prod.outlook.com
 ([fe80::645a:f184:3a35:ef9f%4]) with mapi id 15.21.0428.004; Thu, 10 Sep 2026
 23:56:51 +0000
Message-ID: <22d59d86-91a6-4df5-8502-0885b25c4761@oracle.com>
Date: Thu, 10 Sep 2026 16:56:47 -0700
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
From: Gerd Rausch <gerd.rausch@oracle.com>
In-Reply-To: <06792614227360acd42d62693d0af78d0f9e947e.camel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0091.namprd05.prod.outlook.com
 (2603:10b6:a03:334::6) To IA1PR10MB6050.namprd10.prod.outlook.com
 (2603:10b6:208:38a::16)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR10MB6050:EE_|SAWPR10MB997789:EE_
X-MS-Office365-Filtering-Correlation-Id: eac7cffd-13f3-45b1-8b1f-08df0f972eff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|1800799024|366016|3023799007|10067099003|4143699003|5023799004|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	0lTCARCF5iiM/0hRmXQZC5kC9/gdjzPLx/Kdku5n9r0cpqtUEkIeZeKWG95LTaDqLu22G7Crc3aoaeU3BrxKitrmoFWOQ7iLHXNX27Y76lK+3Fupob/1xyKB19br+5rXrE0fR76oF7nvbxsFbKIS7CfG88gvapn9dKo9j8eSllAIUyoVyhVofvAMK3+Y2VuuadXLteL7V6kirOSGeIAPG03IPVkfzCnJHf4gXfuJQ6Vp/xHvC25Aq77UQDrh9J3vQlJRbPeOA0GnGRmkwi4gW3OQLZvlu431L/Mi67pZHKt7scPrGu3sd9KlXMYqOH7CAH0SjVISazOw5ETV6Qg3Q5/Jcb85VXjjr1g5YIjogb88ZAs3/oNkDp58pMlP5f6B9LjNA73LPbLovEq5kVOonorcSodqGCKlnavQakccqGdQSzXb9hBESDOysG8HTFzBRwIVpazr7d2HqpygUgmdfkJM4Y7T42Ob4HoyOhzZWQfv6RqvTlo0gX4S4tB8lJplU27x7h9Yc0koZUBIT5XUatitHCTF0FEzOZh3yJh+3yH9MDQTgmJXTYJxOrG9lKTdkzu+nOJef0o2NheKS6F6wKm0dFqQto79B1E9ClxUNfKuvgp7GcFeiHLHwHs9D//4SEu5MCzkRxPJEU22HPeR99oNPiy1Wfgc4Ehm14b0NTw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR10MB6050.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(1800799024)(366016)(3023799007)(10067099003)(4143699003)(5023799004)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UUsxWkw5R2F6dWk3T1YyMllONkRPTzIxVTY3QWFpUVo5U3FBSGQ0QmRnS28y?=
 =?utf-8?B?VTM2QTl0eEZhd1pIL3FqWkExYmxCcytlSWpBWVU3YUVNeStjbWRIUmE4Wmcz?=
 =?utf-8?B?YWUxQUQxVmR6R1FmZDRNSG9XQnlyT1llNHJ4ZkZmVG5xOUtZeTNPbkNhSnc0?=
 =?utf-8?B?WUFIYnFYVU1vTnVtZEVTU29Cd2hGdUtXVXI1SkJWZ1ljYnpJYitmTHF2RXJ5?=
 =?utf-8?B?bjNEV3MwNk44V08rSFNXNFNLMzVzbjVBMG1VeXRickFidVB3SmgyR0x1NUI0?=
 =?utf-8?B?cUVxRjkxT3NVTTZYaklrU2ZWK2l3ZjB1ZW5GMnZEblhRbWNIY0V0alppWGNN?=
 =?utf-8?B?QXQ1TjZ5K0JpVkIyYkRsNjQ4RCtSZ2wrWi9jOGJUTXhZMVdHb1l5d1d4aTFh?=
 =?utf-8?B?YWVqWmFZQlBWUEc1NXFQN0tCeEpjMW1iM0pYVjU3OGNXRDdoVXoxa292LzEz?=
 =?utf-8?B?ZUVJSXdydU4wZHl1NWpNeDR0TnJYaFZRMkRaNUxNSHZUSFdqSWVmcFR1cVZx?=
 =?utf-8?B?YVJpQzhKQy9ySGFmWnp5TFcvcTdtK0EwNEFHOWpKWU9JaS9rbG5tN0xvTnVQ?=
 =?utf-8?B?cm00ZnoxKzhETXA1V2Q3a1pxRDlHUE5hTGJLNHlDZFd2eFI5dExFMGc4cXZh?=
 =?utf-8?B?ZmhEZHdhTHpFSVdibHVXYkJhTXhaYUp2VGxWY0xOTW1vcWI3VTBWOXRoMFM2?=
 =?utf-8?B?TDRjK0lTa2FvMUxiQ2FRQlMwdUVKbkpHSHJUV1F6dU9OT0UrYm1KN3k1VDNp?=
 =?utf-8?B?RjhpQlVIdW4rQy9ReUppeXMyN1lEbzNwYURUcVJDZy9XQmVmRk5vZVp0NG9W?=
 =?utf-8?B?c0ZQSGhuVDU4RGEyblZMRTlRNUpBQlFFUGFBQklHdmt1Z2lmMnkxTU1iejhN?=
 =?utf-8?B?UTY4ZHk5WDFvTlp3R24wZ3IxVnJxY20vbUNGZm5WNDBQcDBiVU4yeXlDdlFI?=
 =?utf-8?B?N3c5ZmJxQldSeXpjNVBvM2djZDFUdWg3bTJyTzc2V0hqZ0s5dnc5Yk5DTnht?=
 =?utf-8?B?SGRQY1dCUnVwV3VvQ2lNWGJMZVQ5N2FDRHhjSXdnUWdsMWEwVytkYVNUME1P?=
 =?utf-8?B?ekxZRWMzdzljY2J3UlltelpaTGNQd0VScVl2UXFmRXZ4NUNEcmtxTDlkbTBs?=
 =?utf-8?B?RDJZV1dlUXovY1R3QWZMc3BmdFdiYVBybWx4RWtnUzNtUVR1aDFXZEFsTG5a?=
 =?utf-8?B?UlJFNm9nMjJFcS9sclRXK2dXdDdYeVVPM05PSVNEcllZY1NiaXB6Um96ZjJV?=
 =?utf-8?B?K3BkTlFvSTlpTVV3MTZHQkhlZnVvS1J0ZXc3bjVuTmhsYlpwaTB4VkdoTy9J?=
 =?utf-8?B?dEFWMXdxakVjYVlIOFAzNHNuMmk4T0tZanhOSDE0bHhoWWpwdWhRV0JZYncv?=
 =?utf-8?B?dVAxL2pPMGNrQXUvNlpMbUFEYzNEUGlrbHAyNHRLYTdzVGRmMEprSnVGRjNj?=
 =?utf-8?B?bmREY2t1SzFQVHptQ09ydmFWT2VIVVN4d3JhUTRyU2l3Vkx5TEFyK09wOWY2?=
 =?utf-8?B?WDlubndKd09UMm5QbUt2RkRKVkxoemZuMUEzYmdJc0VJNHdTNE4xanE4dm41?=
 =?utf-8?B?eTNoc1hsN1UybTFFb2tVS0huaEFyQ0VnbWk1Q0JRZHJIZDg0cEt1eldCTkRH?=
 =?utf-8?B?Y0lYMU5taGdDQ1JDa1MxeUx1a3NWTEQ3Y2Nrdllvd3FkOU9hbm1ocjY2T1Jx?=
 =?utf-8?B?eFN2NFBsODFXVjlnMEk5OXZiSGYxcGJKWktpRGtGakRZZFRCZVN2czNEOG1I?=
 =?utf-8?B?L2d6ZEpZVTNGNE9YV1gwY21FdEVFRlk5QTU0eHVZSGlWdzdyVk1Qb2NSOEda?=
 =?utf-8?B?M0ZHVTd5Tm9uR2Flb2VPZTBpQkRweHordkk4NTlvb211RXdUY0xpUGFZRnFr?=
 =?utf-8?B?T3pXd3JRYmpuZFRBYlROYzhtK3lUb0VDc1FmL3VBVGVyamRmK2lqYmRFSGV2?=
 =?utf-8?B?M2FiYWsrTS81U29aMUIvR2RiZHUxb3pLajhQZVA5RHE4Z1o3RU1TZmlDOXA3?=
 =?utf-8?B?aXBuK0FPMmVyTHlYakdjQW1Pb2NhUm93bit4bFgyeGMyY2FyR2Nlc3MyQllU?=
 =?utf-8?B?OWc0cUQ0dWxHYVNtZUp1ck5SeU0yaDVkWXd6c2hQeU9WMVlGSnRLdGhJOHJS?=
 =?utf-8?B?VDE2UWt2MFNtMkRkbm9WRkJjeGtFejd5TXd4MmlJOVpSNEJqN01JV2xhT0Nt?=
 =?utf-8?B?MCtMZStxSmJYQm9HMzhKQkJWN1hZbEp0MzR4UXBkWVM4c1ZCcEY4SnUvTU9v?=
 =?utf-8?B?SHJWS3pwcFNXMWp0ZkUxSnE1aXgyWnpuVHJYN1pSYVNsZDgrcTAvOGVYOTNr?=
 =?utf-8?B?a0pwT0t5aElmYTl5SHBjdUUxRG1mSi9KWFYvY1JXUzcwQVlTYXlvQT09?=
X-Exchange-RoutingPolicyChecked:
	N/yxCiAK/vQUNqqKbpb1tC2G7qauXk2wx/jkUDy87oBlDysLK2v64YB/MXPi0H09LZTjPn9kGbtCOIpUiqT8Ad/GejFZxSX3Sgcxz8vgnvRQ1s2fkeTw3P3VuFYfMWM9mrw3EdYG/zi6d827B2aEddZpFBY1aNJDL0r8jkaMhsKDjrhpfj8ILfgI9pU4MQNzGo4PKSgGuP59tEx4GPtf7M5CYPN9DTRU/XhGvrnl9zXqcMG0shmhAkB96NJdbATugRVheYsNUgvDayayzoTUs/1jz+ENaduqgRmLVEr4zs0pWoygy+Ek/Uc/g8gNRFhVCNCW7w5qccRAPXzW9rHK3A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vC7ziErBpKS67P/IizAJIUflS5MNLa3jdELrAEPjbQ1OZU5hr2FDwxdA/e92VdOON5w8yHpz6u1Fy4dlSryUA1I4AoYBElM71hbtg3+oFXp3LouGBIwLPWCstjlBPREJvK6cx3ZHLLAhMuRsbPNA8XB4flTbLWhKwE1jgmrC63AExZUGEKIqAnprSujAExu43kzx3Vmpw/R3YbvwTM+1GxrL7sUXOMPTatJdEN39yzUpF2A9o1WqviFzTrh9jr8OaPxo3G7qHOLoAZJseq9TswBWkvTNfCkle9gTyQGDJzb5jbpwGyed/AiyRPPJYEwzayhCAr7oTqcxU0/UgYWaeig17roZpK3u2Hyl2LG9FROEjztAUWW0RYCYXf71zpJBzxFDCbdPamVGgQyrdttOs+mNQZHiVKKw3atRDsA6BZIsJ9Vp9HKf2JSViGoNtmW+ZrR59dZ92E7pxDHUp6zL86U6SDZJXM6g6l6PLuV3M9jjXz4ZiRm81LXUVr9o3TAILfu7LVI2rJloVSR2y3MHFR24/dJgArJ1gButiK2ez5PJXpiMqR5Qiay/n392C5ZCHD6xZPJg6XczljrrwiVxpSxM31VQVen2z7W/dKQuQpI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eac7cffd-13f3-45b1-8b1f-08df0f972eff
X-MS-Exchange-CrossTenant-AuthSource: IA1PR10MB6050.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 23:56:51.4910
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0rsnygcQcy+eYhDm0Da5oItMKTLnqy1wWZ9/xaYwCjLS6rtPYLGmdLS7g6a4qq7fB/FjoX+57W9Jdq1/SLKh4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SAWPR10MB997789
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_07,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 adultscore=0 spamscore=0 suspectscore=0 malwarescore=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2609040000 definitions=main-2609100302
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDMwMSBTYWx0ZWRfX1HlRS0Vls/72
 lu2fJuZsSawJKxQ+7JWZQ9bMnNpGrPqdaVokwLqvirM7oMQ15fqb5SHY7pPaG9tIqyBzN+dsLIl
 IHJIVdEh8JoMuiUrmjBe1SNWwLeazO3L2RygJZD2fcYXVh3tk+xxi7GIilPXLhhmmC72vPbsGpV
 2kTSTQ/kw0AdsJEvoP/B6Kt9IV/HnaA4bFQ0T5JSZWgwdHt5GQmdqFQr8z2rkm5xPqrxtZVeuSb
 CIgaS9VvZDQkJFuIGzqt+jjav1KK7zYjowix7YU/VZ7uaSMbtgVIpopRP1x2y89JZSLtYdGf1pa
 3/IPGYcuNKdRQmw60lA7I0haZa5UY/udIKg3g9nbJqfopgIqPU0XYjJdLuIVVSuqlhMIhXZ+AQc
 VFqXpn8FRPtJ9lJbm9tuCgnQCOGrsoEkeYA0rX7remPQcD0oJzBZNi4KHdrJSQ40SRFVichhNbp
 BTnkE8Zyo5t/ZnmnnlU7I6KC+ZvFdOV3e6KFW7k8=
X-Proofpoint-GUID: l4XcvvQWfLVONJzTQgTMCCWvcj0c6dVA
X-Proofpoint-ORIG-GUID: l4XcvvQWfLVONJzTQgTMCCWvcj0c6dVA
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDMwMSBTYWx0ZWRfX/H7SzR+HbrR3
 BxNj1u0c4NpoxAtCwlnkqW4BteYSOGXdqNMLXGQnsH6q3Puvq6Me5Y5/vz5oVpzmQaLr45f3nXD
 X8mJ5Oe3rBw6QPeNuwBKhDHMhPQ7kQbLk7TJgbZNWmoi3p5Sfudj
X-Authority-Analysis: v=2.4 cv=GPSdgeNK c=1 sm=1 tr=0 ts=6aa343c9 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=FidGB890Tes7t0oktuMA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12105

Hi Allison,

On 2026-09-10 15:58, Allison Henderson wrote:
> On Thu, 2026-09-10 at 10:08 -0700, Gerd Rausch wrote:
>> Before this patch, a version 3.1 connection is expected to be established.
>> After this patch, there's an infinite connection retry attempt every second,
>> that'll never succeed.
> 
> I think we might be talking about different branches of code?  It
> looks like the downgrade you're describing is in the REJECTED case of
> rds_rdma_cm_event_handler_cmn().  But this patch doesn't touch that.

Of course, it doesn't.

But rds_ib_cm_handle_connect() issues a rdma_reject(IB_CM_REJ_CONSUMER_DEFINED) with payload
err = 1 (aka RDS_RDMA_REJ_INCOMPAT) not only if rds_ib_protocol_compatible()
returns zero, but all sorts of other scenarios also.

And when that rdma_reject(IB_CM_REJ_CONSUMER_DEFINED, 1) is issued,
then received by the peer, it lands in rds_rdma_cm_event_handler_cmn(), where this:
--------%<--------%<--------%<--------%<--------%<--------
     conn->c_proposed_version = RDS_PROTOCOL_COMPAT_VERSION;
--------%<--------%<--------%<--------%<--------%<--------
version downgrade is expected to happen.

Subsequently it should be the node that did the downgrade to COMPAT_VERSION
that tries again.

Not the peer. The peer should back off, as it didn't go to COMPAT_VERSION.

Looking at rds_ib_protocol_compatible(), it seems terribly broken,
and AFAICT, none of this stuff works intuitively or even correctly.

But one thing is very clear to me:
We should never let the side that has an incompatible / wrong
"conn->c_version" value continue to attempt to connect.

That side never downgraded the "c_proposed_version" and will
just keep on repeating what didn't work before.

And yet, that is exactly what this patch proposed:
Don't destroy the connection, but keep on trying with
the wrong "conn->c_version" / "conn->c_proposed_version".

> The 3.1 exemption in rds_ib_cm_connect_complete() is a few lines above
> the one being changed, and it isn't touched either.  So a 3.1 connection
> should proceed exactly as before.
>

I don't understand.

Why would the connection proceed exactly as before,
when "before" only one side retried with a downgraded 3.1 version,
but "after" both sides retry with a mix of 3.1 and and whatever incompatible
version the other node had?
It'll be a game of "who's fastest".

> The changes here are only reached in the RDMA_CM_EVENT_ESTABLISHED case,
> after the peer has already accepted, and only when the version it accepted
> with is below 3.1. IOW: that is specifically a peer that answered our
> 3.1 proposal with 3.0.  Or an accept that carried no (or truncated)
> private data, which leaves c_version at 0 on a fresh conn.
> 

What you described as "carried no (or truncated) private data"
is the normal case for IB_CM_RTU_RECEIVED:

The RDS/client issues an rdma_connect() (REQ) with user specified payload.
That arrives at RDS/server inside rds_ib_cm_handle_connect(),
which inspects protocol-version etc.

Then the RDS/server issues an rdma_accept() (REP) again with user specified payload.
That arrives at the RDS/client as RDMA_CM_EVENT_ESTABLISHED *with* payload
and inside RDS' function rds_ib_cm_connect_complete().

And then the RDS/client (actually the CM layer) sends out an RTU, that makes the RDS/server
land inside rds_ib_cm_connect_complete() too, but with "private_data_len==0".

So a "major == 0" doesn't imply something being truncated nor it being
a fresh conn, but simply is the last step you see on an RDS/server
during connection establishment.

It is rather curious that RDS performs a compatibility check inside
rds_ib_cm_connect_complete(), i.e. after a RDMA_CM_EVENT_ESTABLISHED
was received.

IMHO the compatibility ought to be checked prior to issuing an "rdma_accept()",
proposing common denominator version(s) that are appropriate for both sides.

Not after the connection had already been established.

The question if an incompatible connection ought to be destroyed or not
wouldn't come up, if we didn't allow incompatible connections to be created
in the first place.

> There is no fallback for that case before or after the patch. 3.1 is the
> compat floor, so there's nothing lower to fall back to.  Before
> the patch, that branch calls rds_conn_destroy() under c_cm_lock and
> deadlocks against rds_conn_shutdown().  Which then stalls every RDS
> connection on the node.  After the patch it drops the conn and
> retries with backoff.  Neither case establishes a connection, and neither
> was ever going to.
> 

The important bit that's missing here is that the side that did the
"c_proposed_version = RDS_PROTOCOL_COMPAT_VERSION" downgrade
is the one that needs to initiate.

Or else, we run the risk of running into endless loops of trying the same
thing again and again and again.

But this whole protocol negotation in RDS is rather broken.
I guess some would call it "organically grown over the years".

Thanks,

   Gerd

