Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.143.35
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793421391;
	b=hAxHqYuVmOCVz9apUP5cMk8Cc5Sa2POfPc1N+QaybKUrZP2c6wSSKcLV6yrQxnl3ggOS
	 +wyjU/JtjvXNrUpabE+E6GIga8F3B/73oGotXxMM+CRJ8oISjISQTzCYB4KM589lioMLb
	 KbjtxYgpsi+/LqNgVFciRRVm4fR2j+5eSJf1tAusK9rrqHZAuHnbiQZt+wZvHwAzrxSJ8
	 k9NV37FXJCI/wLxho1BkeTnNlpxxaUrcq9TpXPF8uHxCukoGkTAdjCjb0HbxNwkqPgF1v
	 6YViGkB1N+Hwmf2tICb878A+jNBbNc1dVrNvePoLwL8FchgbCDQmEYpiwLTnfQQnz5g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793421391;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:Date:Subject:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:CC:
	 X-Mailer:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-LD-Processed:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-HPE-SCL:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=2n90FUTx/pahN11MX8Tw9y3GNZsXn4nHz27ogEJ+RRo=;
	b=YJZBageUzVFX1P6fAl/YcOr7ZmCsvx4gVN09usI7XBeXar8NriRF9ZR8q7jIryaODiyN
	 aGh18/LjRAdsn39nWsjYKpvEbVq5mTeZBaU/GIk8n3Wv2f8rdhzMbMaA1LTXxQo7xOxum
	 a6esOvmaD8jXrmnWqvcc5G3hSwMHeeceUTXS25o6DCkGKy3pkbXFQ5UnjPlPkCmFyUln3
	 r+OJczjz4cy2c/2AzP7JmmD/JiRyt2e0tXB1CiVz4ACHxdBFDOG+Hk7YHR/rT4gsKDBMb
	 VUEvO1Wob0Ey3c0V2wpLV7jFPApOY+5YfrDOPECqBr9fb86hVRM8Pxu5J/mrGGTOHOg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=hpe.com;
	spf=pass smtp.mailfrom=hpe.com;
	dkim=pass header.d=hpe.com header.i=@hpe.com header.a=rsa-sha256 header.s=pps0720 header.b=H0HUeCCP;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.143.35
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0CB4606A320;
	Sat, 31 Oct 2026 04:36:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E0CB4606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hpe.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hpe.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=hpe.com header.i=@hpe.com header.a=rsa-sha256 header.s=pps0720 header.b=H0HUeCCP
Received: from pps.filterd (m0134424.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69V2AQ5L2222119;
	Sat, 31 Oct 2026 04:36:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps0720; bh=2n
	90FUTx/pahN11MX8Tw9y3GNZsXn4nHz27ogEJ+RRo=; b=H0HUeCCPDdiK6Lds7i
	O4VSpoxZ0CWW0kJCH+93Ijl7C6S+65kswacpyzAiE6aaseueLo28kdXSPmO6wGse
	OHUD9W/AwG5mjq4iSKKSjPG/gSTSZ3fAPHmZUxrHtFqaHV0lTMgf8hB5SH/YOEyA
	YAZc8OIXMZdvx8uT6z2sMeiOpDBIJwzY74u9bVEQeURWhz49J8/JRfMAJA71U9er
	MZBxbd6UfP+Be00adojOMsqfFQlpGjwg2hrBB6UiOI+Ql0Ks/wDYA/XML8Je8LZ9
	nCiArIEo3diR8y9sALP7zN2OXrQ0lzEQAgFAC5Gl20FSfStORSosVruqqZpPwnSm
	PCdw==
Received: from p1lg14881.it.hpe.com (p1lg14881.it.hpe.com [16.230.97.202])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 4hn7ajh1k3-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 31 Oct 2026 04:36:27 +0000 (GMT)
Received: from p1wg14924.americas.hpqcorp.net (unknown [10.119.18.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by p1lg14881.it.hpe.com (Postfix) with ESMTPS id 6F7FE8047A6;
	Sat, 31 Oct 2026 04:36:26 +0000 (UTC)
Received: from p1wg14925.americas.hpqcorp.net (10.119.18.114) by
 p1wg14924.americas.hpqcorp.net (10.119.18.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 30 Oct 2026 16:36:26 -1200
Received: from P1WG14918.americas.hpqcorp.net (16.230.19.121) by
 p1wg14925.americas.hpqcorp.net (10.119.18.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Fri, 30 Oct 2026 16:36:26 -1200
Received: from BL0PR07CU001.outbound.protection.outlook.com (192.58.206.35) by
 edge.it.hpe.com (16.230.19.121) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Sat, 31 Oct
 2026 04:36:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PwYaxxGAg7gpFjNGqXktb0KbADXqGeFQdk2JxS8c8KkrlzhC/OX/mjAMwNtVgPi8A3uWR6cehCM7r4UTobM76lbYqLZxknbltupt5nkIU6iCazvI+X604Be51V0eO463t03nNtqzip76RCslvPRKhNcEbJTYx/ghGwmXMaXVK8/W8v1Bo+g/6JgjtpPv7JFFSbnz6x6wfYA0unMLkIPVMI1J4g/48HjvbBKFIkMJanQdlkvKdmMB611hn69yXFPY/HsicdKQI143jA1Ljw+TCJgLxl3Y/zXQUnXXzSStE0Nyy9wAFXyNHnPDbMnQEBZpwoytm/0Kvgpa110zG7ufZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2n90FUTx/pahN11MX8Tw9y3GNZsXn4nHz27ogEJ+RRo=;
 b=P3WUbnyINanHfPgrGfMA9z91Mh4zajuqDZqtWIi9CI4hEgDXYHFcWlXZQoU3jliwpVXbuacKobZUcMbk+P41Tpq7ZTvacAKpkhhomOD74RtodjAk+K0rOg/qLVtUHKNplhGNo8c4Nizg7ALB9F0njIgoQEK2fMeCqJZqzXgI9l3BrbDsTh9LiqDbk1NbnNWcfcyNwd5FgoaYA0/+CVZyUij1iOx5/dcFIoFSIv379DAKhWRjt9zgsshGfk1tLArvhJuicgYMh+DaJH3W1XDDRIqhL9SanB0eQi/HHJdZaWJoISHqrY1ulrA9AFj9mtVPyrCRZrzIGfO5S7OcA2OGIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hpe.com;
Received: from DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:8:225::20)
 by MW4PR84MB2091.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1b2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.10; Sat, 31 Oct
 2026 04:36:24 +0000
Received: from DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d136:e75e:53c5:73d8]) by DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d136:e75e:53c5:73d8%6]) with mapi id 15.21.0569.009; Sat, 31 Oct 2026
 04:36:24 +0000
From: Doug Ledford <doug.ledford@hpe.com>
Date: Fri, 30 Oct 2026 21:35:39 -0700
Subject: [PATCH 11/11] RDMA/cxi: wire the driver into the build
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261030-cxi-for-next-v1-11-bc6e49e07037@hpe.com>
References: <20261030-cxi-for-next-v1-0-bc6e49e07037@hpe.com>
In-Reply-To: <20261030-cxi-for-next-v1-0-bc6e49e07037@hpe.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
        Slingshot Open Source Team <slingshot-os-team@groups.ext.hpe.com>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Doug Ledford
	<doug.ledford@hpe.com>
X-Mailer: b4 0.16.0
X-ClientProxiedBy: SA0PR11CA0108.namprd11.prod.outlook.com
 (2603:10b6:806:d1::23) To DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 (2603:10b6:8:225::20)
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
X-MS-TrafficTypeDiagnostic: DM4PR84MB3970:EE_|MW4PR84MB2091:EE_
X-MS-Office365-Filtering-Correlation-Id: 322736e8-ce7b-4a15-a9e3-08df37088519
X-LD-Processed: 105b2061-b669-4b31-92ac-24d304d195dc,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|10067099003|18002099003|22082099003|56012099006|261021121427099003|261021135927099003|261021123027099003|261022105027099003|261026140227099003|261026121527099003|261028144727099003|261009223327099003|261009223027099003|261009221227099003|261009221727099003|261009220027099003;
X-Microsoft-Antispam-Message-Info: qzKMXLOU9BQSkSYaS00TxeKBms7CCW7wzx70IlvD3zVrnt6N5iLmXHhAWRkCocXmor/KqdIaIan+n67Aol9Npb8wCE2MBBtMLKJE4BwzSOfOW71JgV3+ciIvr38s/AyxRo4ySgRg+aeYsDRF/vFS4o3V0aEbzm4/dw7bKNw9xudjmk3N0srtbovQagszh1ZNrF+UUWcBkhuuo50PBGsZqBHhm+OfhQRJt0k4D+rtXUSpvpIGxOYM2C8oUONtzuweWjH8UGyu9tDv0Ut1VajfUw3Dugt5LOqZXDYxxFokp+ojg1r2Atucw+12jhX7aAD8zMQMHAavlCCnL1esXakJYgp5vXJ4rkip58xYXKw4MgaRDnbw8crm3nvKb5AAuNfZII1jA6PTnR6KMOkgIwRnQV+oM5w8bRfZtSUUkXPkt6FfUXkSH7e5K2jR/AkET8Iq1tP4Uxee/sVEa6uthvDbeMldOfwYVTSGfYguGe0jP8cftzo6pvUJt72JhquQ0njxcqAjJXwy82cUUdFV5QppguiVPNMqNCzzlYBIjrxQ7u34/K1l9f1yxIa1/TDN+TzNBvNkUUvcNE5ZM7ionyZJnGMojc8tDCunkp+aVaySWKP9y82mP6PR7PBKhZND+ipzKvA0S+ENF4gLP28pX7tMEbMIx61vftQbnb4MDiufjuo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(10067099003)(18002099003)(22082099003)(56012099006)(261021121427099003)(261021135927099003)(261021123027099003)(261022105027099003)(261026140227099003)(261026121527099003)(261028144727099003)(261009223327099003)(261009223027099003)(261009221227099003)(261009221727099003)(261009220027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bnMrRGxBL3ZsY09XQWZXZkVKZS80OUZsUVdsUkdPb0RRSUFISHp6MkRjYzVp?=
 =?utf-8?B?ditKK3RkUzdEZDNVaHFrbDU0Z3JxTnJtRW8rYUdZRDk2UnJ0ak14Nng0aEVk?=
 =?utf-8?B?ME9VZC94SkFGVGtnWjlwQkhhTU8yRnN4OXdSUm1HczVIbGxwZDZpZmMxdm5z?=
 =?utf-8?B?Z0xQN2FvOStBdldtOVdlRlJyWUlOdi9OZElRYzlaR3pDbkxremtxTUhtdzVr?=
 =?utf-8?B?Yk5aU01lMFdIeWRsbno4NzlnUzRvRUpEZWhMdGxGczdSQXZGbTJuOEhTd20w?=
 =?utf-8?B?NmFtaVlvUzU5aHhTSElnenU1NHZ2T0htaGVUVXdpUzlhQjJjRk5hV1JYQldF?=
 =?utf-8?B?dXdSdFd6WmpKYzRQOFhZMlFQRzhSdnV0c1NmZy9nRDVscXZ2dVJ3L20zSHVh?=
 =?utf-8?B?M0xCTlNVOHhsRTF4Mk1iYTV1b2FPcnVwK0dlMWhKSVBlalpUSlRUR2ZOSHU3?=
 =?utf-8?B?SVlYRUtSVlU2RFdTenRLODIwSzI0aDE3SmtpVTNoQ2dZSU1UWjhkYkpyTEQ4?=
 =?utf-8?B?ZDBkT1JGTDFQM3BKQzVjcnphWm5yQVgzVFhrbUxkeVNCRS9uTnd5Y1NaT1Z3?=
 =?utf-8?B?cDVQQlFiVzZsc1BTeFhCTmREUHNHNUxWYkFnS24wR2lMZmxkRmJPT2xNZm90?=
 =?utf-8?B?amVRZUNZWDhnMHJPSy9Dd3RiRmUrQitJYk5TYkZGWEZ3QW4vWHFoN2FTM21C?=
 =?utf-8?B?Z1BsVnl4c2hSQWFUQjd3c24xSmdpSm95OURIblFDUFBXd3hkVlBXdEVzRmU0?=
 =?utf-8?B?RmJmZ1c0THNZYjBXMnJ0cEc1aDV4MExzWG9jYnJ3QysvVHVRdkVmeEtXTlRW?=
 =?utf-8?B?K21ORTMyZXplQUhVVDZZNmtzR3pPU1J5dGRsOXhSMmJyQWt0Y2NIZlIyL2dz?=
 =?utf-8?B?a0NHdlp6aUg1S2NrZFIrdU1WTUdXK2ZtbDFOajRMRzRCNnNnd2NPYnJyTXd6?=
 =?utf-8?B?ZFozY0pCWkJPOVV0eWpzOUhBeGZ0ZW9yMExqK2tPaXo2S2hmZy9zTTNaQmd4?=
 =?utf-8?B?VFlaTmRzS0ZBR0YxOFk4Q2xTSWE4SCt5c1ZrdWhIU2xPbHdiNFQ5Vi8yQzdh?=
 =?utf-8?B?cnlJWWcxY1RSOUljSEtPUHVDQWlFNGJHRS9VbXdCZ2dOVnU0VjBETDdNZzhW?=
 =?utf-8?B?bXNwbGpJRnpZYTZid0MwNlgzVFdCcUdDQ1dXWWI2TXl0ZzlsZnBnZnlrZXBT?=
 =?utf-8?B?VFNuME92QVhRTGlwMS9Zc1ozV0x5K0xzMHZVU3JvTU9nWGM0K3UrQ1dzdzBD?=
 =?utf-8?B?VGMwWGpsaHFzcHhaNnFtTFZGNEtBanVrZkhsbk5SQi9JOXpEcGNpSVQ4MXRp?=
 =?utf-8?B?czR2VmFXVDMxYlQzR20xM1pvVHYzUVVlVjJDak4rTmtNVER1c1ZFeWNIUEo5?=
 =?utf-8?B?K0MwWDRGblRibkcyTlVockp5SHE5Wm9MTUZicHY1TloyZDMxUVBiSEJQaUlx?=
 =?utf-8?B?TWo1WUo4TDlsZmUxbXhpeTlVU1ltTi9DZGJIaHo5aDBKOHk4aGJrYXZ1eWlV?=
 =?utf-8?B?UVBYL0dId3hIUzk0d1pGTjFtZ1d5TWpNVUxDWnJMZHBmOWZoV3JpWXBXMWJk?=
 =?utf-8?B?Wk9SaW5KcW9ucy85QTNUOVV3TzA4SEMzdUk1MGd2bVFiUWNnMFRyazJGWDZ1?=
 =?utf-8?B?Y1RvVVluWjFHN1RkZE1rZkhqNURUTkc1bDZQNWZzZmgveVd2TzY4WU4yTjZu?=
 =?utf-8?B?Sm84dWViSFIxd1duSnllRnZ1eS9yejZvQUorVTN0VGpoSkh1aDBvcWVhNWRj?=
 =?utf-8?B?TXdXdTd1NFBYRWxaSEpMU21uYVVMSVpzWVlya3FQS3BXZGFlV0haS09LT0dN?=
 =?utf-8?B?RlVxYWpZMCtnWllMOFV4TjhBa3Q4aVI2OXBLQlJDMTcySUJ3WTFEcUJTOVN1?=
 =?utf-8?B?Wis2S2phQ05WZFdtaVVIMjlzdUNiK0lERVVaNDRweVN1akNsWHBxM0o1dXl1?=
 =?utf-8?B?SkFJY2R2S0dtWjVqQ2RYVWcxUGtHZkNtczVMcXdBWWNOaVVONWJPOHIydWJ4?=
 =?utf-8?B?SWdIUkpqSzl0TkFScnFhN3d4S3dtY3VLNmF1L1VjK3BZaWRDVE5tSUxmazhZ?=
 =?utf-8?B?VFFEYlJaRjhnZkhjcXdQSWt3TWhrMGs3Q2RvMWdicnlHMDBHRk4yTGtiUDJJ?=
 =?utf-8?B?NkVlNVd6eXpIV1lQUFlEbDZwajRhVjJGZmxSQkRRek5PZXFYQ25YbEo0RFRh?=
 =?utf-8?B?RkNzdENQN0t3Uzd2OEV2dGpMU2pBTU1YN3hJSGRKV1pHVXJHMzFUWmVFVkhY?=
 =?utf-8?B?TzF2WEJSUUF5c1RrVFI2SG1Ha1BJYWt3dmkrOVZ1RGgyYnhpNldCL2x0NFBa?=
 =?utf-8?B?M0RFbWxTa0lWQ3VCSzNnMFZnOGQvaVRSa1Zjck5kd1FiMWNIWEM4QT09?=
X-Exchange-RoutingPolicyChecked: ySfsqvz2fuTgf+B1TuGWcE3XHVr+eR6XawwhhGGCv987zmi163bKjFV90Ho8W7EAz+SBZZFvboFZ8lbDgN0PcWVSs4sL7Cm5ZkX5jurLlhHsLQJvmTIOooFbsti+pJfm30C/UgHGfWRnJhWTtu+YmJ2ah3tdi1h4kgRTPo/sr+Ow729EtdiH9AANDly2+vFzsQ/OPl4RK5p3c4Rcqgk0ybv1+iB5G838NzPZMN2Q5PCXWSeH9RhDBRe0ARqIyrSR9GcsmqECvnkSKrAGYEZkzrEENXczXjxq+lMrbbWgiJQSW77T9f3jKr9tpOhfrBrIKhmhBy4aG0OkAHZ/wA+F9w==
X-MS-Exchange-CrossTenant-Network-Message-Id: 322736e8-ce7b-4a15-a9e3-08df37088519
X-MS-Exchange-CrossTenant-AuthSource: DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2026 04:36:24.3357
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NeqioxE/P2OT9UYpdfBIPjo28b4Ocaa3LOSUYcV06h+G7yPztaFktpl7NM8P6t3RjzbhXgqqXs7q6MZMUk/TEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR84MB2091
X-OriginatorOrg: hpe.com
X-Proofpoint-ORIG-GUID: kb1ioZ0rmec7ODTIkVAhXa__42j8bl9L
X-Authority-Analysis: v=2.4 cv=O+asLx9W c=1 sm=1 tr=0 ts=6ae5704b cx=c_pps
 a=FAnPgvRYq/vnBSvlTDCQOQ==:117 a=FAnPgvRYq/vnBSvlTDCQOQ==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=gQcMVamqm3wCPoSYhaRC:22
 a=3haJ9R1Aw3gUfsUHDaCR:22 a=MvuuwTCpAAAA:8 a=VwQbUJbxAAAA:8 a=XYAwZIGsAAAA:8
 a=MzwX9RPqQX17VnFf2pEA:9 a=QEXdDO2ut3YA:10 a=E8ToXWR_bxluHZ7gmE-Z:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMxMDAxNyBTYWx0ZWRfX9HjRlQYqr/c7
 h5cH6Oxjs7ZifTrQd2YKBpDWyZGudt6XPG7fqsYHqxjwZyeuP7VOa0U4iN8i5vJgBkuTmKtUreW
 CjgsAIaKUC3lFCcoqLQ1iuo8IWBrLEbvxPmbmbiGrJfqiSYUHtFNx+4yAlFMnDNYXv64xy1/mgm
 CXUaooRt+Kag03so3uNFai2yltFme/NOSyXSxXOx2z79VJ9WHr3LioqxppZufO95YRzdjHenFkZ
 oOQOnqcGuLIm/TAnJ3guhdQxEpYP0ZuqYhdv8q/bZZXeL05aMTxx0wHPw8YPoFfPl2OxXFYJsZi
 DhvOQ7oIpGYl1LQVtQr6YYcDIliMh/NUgu40ATHMMu36miQ4ACBKbQtL5pSqCiYY4qDHLdYsbeT
 UyWsF9Ads/pbn5FT76fbwl46Bz5UZdnHQJb5/AWXNGJI1UGAhJaGD0BXr0doEAvfpThUK3vMsgS
 VDb7t9RKCOQrBeG+ong==
X-Proofpoint-GUID: kb1ioZ0rmec7ODTIkVAhXa__42j8bl9L
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMxMDAxNyBTYWx0ZWRfXzLremYeBt8s9
 tz/XasQmNb9eyQvg/AtWM/eqH0TBdSSRTeLBNrvlI3CWqqJ2CwUMerOPgXLv40ojv7KAlq/+n0V
 5HQC2QacbdlVhEEdJ3LNdzZwisdFpxU=
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-31_01,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 bulkscore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2610310017

Add the Kconfig and Makefile hookup for the CXI RDMA driver and its
MAINTAINERS entry.  INFINIBAND_CXIVERBS depends on HPE_SS1, since it
is an auxiliary client of the core driver.

Signed-off-by: Doug Ledford <doug.ledford@hpe.com>
---
 MAINTAINERS                        |  9 ++++++++-
 drivers/infiniband/Kconfig         |  1 +
 drivers/infiniband/hw/Makefile     |  1 +
 drivers/infiniband/hw/cxi/Kconfig  | 11 +++++++++++
 drivers/infiniband/hw/cxi/Makefile |  5 +++++
 5 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 094263bfe4ad..1f0e3447377c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11546,8 +11546,15 @@ HEWLETT PACKARD ENTERPRISE SLINGSHOT NIC DRIVER
 M:	Slingshot Open Source Team <slingshot-os-team@groups.ext.hpe.com>
 L:	netdev@vger.kernel.org
 S:	Supported
-F:	include/linux/hpe
 F:	drivers/net/ethernet/hpe
+F:	include/linux/hpe
+
+HEWLETT PACKARD ENTERPRISE CXIVERBS DRIVER
+M:	Slingshot Open Source Team <slingshot-os-team@groups.ext.hpe.com>
+L:	linux-rdma@vger.kernel.org
+S:	Supported
+F:	drivers/infiniband/hw/cxi
+F:	include/uapi/rdma/cxiverbs-abi.h
 
 HEWLETT-PACKARD SMART ARRAY RAID DRIVER (hpsa)
 M:	Don Brace <don.brace@microchip.com>
diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index 086195758a8a..d0c8040f44c3 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -86,6 +86,7 @@ if !UML
 source "drivers/infiniband/hw/bnxt_re/Kconfig"
 source "drivers/infiniband/hw/bng_re/Kconfig"
 source "drivers/infiniband/hw/cxgb4/Kconfig"
+source "drivers/infiniband/hw/cxi/Kconfig"
 source "drivers/infiniband/hw/efa/Kconfig"
 source "drivers/infiniband/hw/erdma/Kconfig"
 source "drivers/infiniband/hw/hfi1/Kconfig"
diff --git a/drivers/infiniband/hw/Makefile b/drivers/infiniband/hw/Makefile
index c42b22ac3303..1ccd2c1be330 100644
--- a/drivers/infiniband/hw/Makefile
+++ b/drivers/infiniband/hw/Makefile
@@ -16,3 +16,4 @@ obj-$(CONFIG_INFINIBAND_BNXT_RE)	+= bnxt_re/
 obj-$(CONFIG_INFINIBAND_BNG_RE)		+= bng_re/
 obj-$(CONFIG_INFINIBAND_ERDMA)		+= erdma/
 obj-$(CONFIG_INFINIBAND_IONIC)		+= ionic/
+obj-$(CONFIG_INFINIBAND_CXIVERBS)		+= cxi/
diff --git a/drivers/infiniband/hw/cxi/Kconfig b/drivers/infiniband/hw/cxi/Kconfig
new file mode 100644
index 000000000000..5efa83de744a
--- /dev/null
+++ b/drivers/infiniband/hw/cxi/Kconfig
@@ -0,0 +1,11 @@
+# SPDX-License-Identifier: GPL-2.0-only
+config INFINIBAND_CXIVERBS
+	tristate "Hewlett Packard Network Adapter support"
+	depends on NETDEVICES && ETHERNET && PCI && HPE_SS1
+	depends on INFINIBAND_USER_ACCESS
+	select AUXILIARY_BUS
+	help
+	  This driver provides low-level RDMA support for HPE's Cassini
+	  Network Adapter. CXI supports RDMA features that can be used
+	  for workloads (e.g. DPDK, MPI etc) that uses RDMA verbs to directly
+	  access hardware from user-mode processes.
diff --git a/drivers/infiniband/hw/cxi/Makefile b/drivers/infiniband/hw/cxi/Makefile
new file mode 100644
index 000000000000..b096704947ff
--- /dev/null
+++ b/drivers/infiniband/hw/cxi/Makefile
@@ -0,0 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0-only
+obj-$(CONFIG_INFINIBAND_CXIVERBS) += cxiverbs.o
+
+cxiverbs-y := cxiverbs_drv.o cxiverbs_main.o cxiverbs_mr.o cxiverbs_qp.o \
+	cxiverbs_ct.o cxiverbs_counters.o

-- 
2.56.0

