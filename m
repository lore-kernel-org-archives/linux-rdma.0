Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.147.86
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793474833;
	b=ChaMl2sNU9DGxXxf4mJZ9HzT+qjUQV99PipZyTY79Of3Xq/YoV4UXX5E6ggiAt637H0I
	 XqITMdheJVEM3Q9iAGKinT4kgzcx8c4YL1X6Hfkc8yrWbLNlF11vRAdJBC5SFuLgkIcuX
	 QUmi+Y/YqbILGpfCYLRcoU/2Di6W0Jsps5KbCDwXM0nGYcaGxx4NQWuT+X1kLAW5AoqvE
	 ZobMDrImegRgoUmEArK7mFCJlKPtnhAeAPMpw4Th663tdUqtgbjijFUtlCdE0e29veS5e
	 G3XTFD2zCqWNx83A5Mo/vWx1PgMwr6LXAga4zI+KM/2Gj04VVSSswxTf0Kyp6WZJXpw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793474833;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Received:From:Date:Subject:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:CC:X-Mailer:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-LD-Processed:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:X-HPE-SCL:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=sRMoa+5l+X5HxuQUR7QTmUx75fz6Jsrv7Lx4tM8N+3M=;
	b=0zOmZyzNnGXjOZAF5gfbwLPTSL5e/2hgdW1K6mIVqTRwFWD8ktk2kxvXrqwLLbua5rub
	 wlwqz6ZRT4oOJjbHdV632khPCsCBmTKD0o3/ZbDGa3ewz3W5AbqukNGiApolBDCsq7q2h
	 ulo6kg71ZrQ0J5OI52s2Jlv+pQcIKllxjplf6yq8DBguZTyT9fqC+RIb/TF/4Wh9b1rXE
	 uEo503EPIxqKK56it2hJowXi04CpXX09eZXuYrd8EHlGHO6RD+hF2/WCZxmtWsgiMsnEH
	 iFda7g6GMyrW1wW/NXQtEX6tmZshzRpmbK5T1l+tTi6Hm5uREsFWAnwZX4SF5UrjZXg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=hpe.com;
	spf=pass smtp.mailfrom=hpe.com;
	dkim=pass header.d=hpe.com header.i=@hpe.com header.a=rsa-sha256 header.s=pps0720 header.b=SUYwWN13;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.147.86
Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com [148.163.147.86])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE29606A325;
	Sat, 31 Oct 2026 19:27:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0CE29606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hpe.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hpe.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=hpe.com header.i=@hpe.com header.a=rsa-sha256 header.s=pps0720 header.b=SUYwWN13
Received: from pps.filterd (m0134420.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69VJE8MD2439988;
	Sat, 31 Oct 2026 19:27:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps0720; bh=sR
	Moa+5l+X5HxuQUR7QTmUx75fz6Jsrv7Lx4tM8N+3M=; b=SUYwWN13xmcqnBy3er
	dbwqgwAgWdRMkrvOLv2IncUHGDRAoBKalJ3i5jLQzeR6kqf2i4tu5QuvcxPOfpzZ
	bUK/pYS5Ku7rNFM6WpV0P5zxCy/KObmyXw1X4A7azNlYOWzMJ+8k5pKYYLK0733y
	HrcjJJt/GAoMj/dp1XOjGA2sHxOjrio4CSDjpHvX1OlJmqRTNCy4yUU4zdEhGUU2
	VnxGBodu5fTBMMfuitZP0KcRn6k+aNg/z3SC+apr4aM6t7uu9pCtJTGBu/W+IOod
	0BctUuLQyOBnJTuC09MADtkYpgNDdZw4HBOLuVDtkzXPX7p15SNohnw6IST6uiS4
	v59g==
Received: from p1lg14880.it.hpe.com (p1lg14880.it.hpe.com [16.230.97.201])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 4hnnuk8amy-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 31 Oct 2026 19:27:09 +0000 (GMT)
Received: from p1wg14924.americas.hpqcorp.net (unknown [10.119.18.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by p1lg14880.it.hpe.com (Postfix) with ESMTPS id BA423800EF1;
	Sat, 31 Oct 2026 19:27:08 +0000 (UTC)
Received: from p1wg14927.americas.hpqcorp.net (10.119.18.117) by
 p1wg14924.americas.hpqcorp.net (10.119.18.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Sat, 31 Oct 2026 07:26:55 -1200
Received: from p1wg14924.americas.hpqcorp.net (10.119.18.113) by
 p1wg14927.americas.hpqcorp.net (10.119.18.117) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Sat, 31 Oct 2026 07:26:54 -1200
Received: from p1wg14919.americas.hpqcorp.net (16.230.19.122) by
 p1wg14924.americas.hpqcorp.net (10.119.18.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Sat, 31 Oct 2026 07:26:54 -1200
Received: from BYAPR08CU003.outbound.protection.outlook.com (192.58.206.38) by
 edge.it.hpe.com (16.230.19.122) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Sat, 31 Oct
 2026 07:26:54 -1200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aJmbIGZ7KqUbrdgwjRYRoayORM5O5Gx/WgSMJCJZ6YxFpkrzVmhnSTMzWGamUnPA6CMYbwCmUckaFeiPYMmgtjxNcJd0aqPXWoPcLSXOfH39lBp3hdLJfcuCx+wgyVA6cIxubLwnUYe3wV19MuC4ZOEKRGEIqwyTzcoT8Ssl461hUrPRGo8u6WkpJ1m7OiHBGx7cNFc3nW2D8gET6G2v3kChPBrfUvHdjrpmqPMGlyr/Vej11n1/uZcpuYLC/RlfItNEhj02khe6yRt5WFOSRuTRx/+SdpSwXyXNW+AauS3uC3ESDFKDgbqfX3/0fQPElZ1L/yHZS0aeTNw2wjLcIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sRMoa+5l+X5HxuQUR7QTmUx75fz6Jsrv7Lx4tM8N+3M=;
 b=GAyqW2nsht6tYjjljPyaIF8x2Jwg61rVcKTWBT+TH7SUiaMQbTQTpcesL3JRvh6ZNnFnytt1Yh680amIWLywYNxi3SpaqbRKs4vfD9aLbNqBQEk+yg0fOpTW28fU3mhhdWKJ4Rm+ZZ736nXMvw8Fz8EVppCQYz659kBgVyImIw1/rejORs/aSPcnpbJAJU/oXdJs6+D8Xl+VWsonDB817yyRD1swHDiKEtcA/tvmFuNFC7yJHsBQZBg6n1oNX9qiI40otV9Hxjv/RCV9y77OahJkpDkM7gqMj0ocyeJi/q7pJ31m3lb4SknuBOv0acbrBkpYekL87nOzntobHSm1Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hpe.com;
Received: from DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:8:225::20)
 by CYXPR84MB3613.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:930:e6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.11; Sat, 31 Oct
 2026 19:26:45 +0000
Received: from DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d136:e75e:53c5:73d8]) by DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d136:e75e:53c5:73d8%6]) with mapi id 15.21.0569.010; Sat, 31 Oct 2026
 19:26:45 +0000
From: Doug Ledford <doug.ledford@hpe.com>
Date: Sat, 31 Oct 2026 12:25:57 -0700
Subject: [PATCH 04/12] cxiverbs: add the synchronized native hardware and
 verbs headers
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261031-cxi-for-next-v1-4-93ce01907ce2@hpe.com>
References: <20261031-cxi-for-next-v1-0-93ce01907ce2@hpe.com>
In-Reply-To: <20261031-cxi-for-next-v1-0-93ce01907ce2@hpe.com>
To: <linux-rdma@vger.kernel.org>, <slingshot-os-team@groups.ext.hpe.com>
CC: <linux-kernel@vger.kernel.org>, Doug Ledford <doug.ledford@hpe.com>,
        Iraimani P <iraimani.pavadai@hpe.com>
X-Mailer: b4 0.16.0
X-ClientProxiedBy: SA0PR11CA0167.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::22) To DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
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
X-MS-TrafficTypeDiagnostic: DM4PR84MB3970:EE_|CYXPR84MB3613:EE_
X-MS-Office365-Filtering-Correlation-Id: ac11b5f8-0540-4658-1790-08df3784e5a4
X-LD-Processed: 105b2061-b669-4b31-92ac-24d304d195dc,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|5023799004|56012099006|261009223027099003|261009221227099003|261028144727099003|261021130227099003|261026135527099003|261021121427099003|261021123027099003|261026121527099003|261021135927099003|261021133027099003|261022115727099003|261026130827099003|261022075727099003|261022113327099003|261022105027099003|261026140227099003|10067099003|18002099003|22082099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info: eu1nTmx4DRBYHnnoffb0BlT7eZA8ZUlQ7xbXroTrCQMeXlQtCQaj9e+rkMnG/f8NKQLO64PWvFYK4GbTFDPFXxbkjlO1A8opnYQyPydAl1sTN98kuv53+rwWgt5toOIlMxqT17B0igcL+9dReOuwO1YkGbrOFaGfGzSQrwPHjkbquiNrMfnvilbxCTvNHuLS8GpY3rSdXA8b6zLC7UtcxJpaDTwVYCit0PHHLCBq33hKDNnKloQfc99N3A3rU8phSYZj4afoGyJRJSolqqY9LCZhYYvM6r56UNCavDujmUR/3LgfgC1IBGt+6uZJrIpC1pvqNnAbtqsFkvh6dWaITluRQC5vNb5uNgMjPjViia7mtxYXhjVcBZQkdpWBrvWTP1ehZnYeRwYh8BHoTRR4+CA6M6PjFhf/oe/71LnxK+RtXw+MhnT6mGlTTU24iAJb82YuUYeRznF90l0xCOFAByuvBw5Qgh+xFIQKd5oqjeeFahVgIjZnt4A/Ti2645JY5i6msPU+6pksv/Y3g49CK26JmE/T2hgQZfBphkhKd/xJAfOrWvRyKmF5pLoR5vZj62uUKnxO4BPH7of5ZEN50V5Gd49MMN0b+3nRwlt9gd9RdfaV4yiRSiKyXqiSqigX0ZsGEIHCUJq2r0qZr/T9C/kPXulnr0MwYyD37HVT6uk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(5023799004)(56012099006)(261009223027099003)(261009221227099003)(261028144727099003)(261021130227099003)(261026135527099003)(261021121427099003)(261021123027099003)(261026121527099003)(261021135927099003)(261021133027099003)(261022115727099003)(261026130827099003)(261022075727099003)(261022113327099003)(261022105027099003)(261026140227099003)(10067099003)(18002099003)(22082099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YVBqYUpZS2xxaVNrMS9ORmVmOCtMWk1OVVBRbmpvRTJVVUFIM2haZ1p1bVZs?=
 =?utf-8?B?bGNrMGNjdHN5OFBINElYQmg2Y0VPcFNzQWM1Sjk4bUVNOVFzZEs3eVpVRDls?=
 =?utf-8?B?T25tRDFSVDdKMGJFR0ZaQ1p4U21XSWJZY2ZBZ0RoeHVsa3ZVNklsK2tGblY3?=
 =?utf-8?B?cXowMFk1aS9JWXJRa1FlRUhLenQrTVdGMldDYjNqczFXRGdMbXh5ZVRFcVdZ?=
 =?utf-8?B?VDlwK1cxbnJyT3ZDeUNMZGdXcEh6dnJxUFNqWm0rVFBvODhJT3poUjdVVWpV?=
 =?utf-8?B?eThnbW82OGxRTlNBdUMrdE0wTVd1ZFo0TGF3NUZIdE1VOEx5ZHhkalV2eHBr?=
 =?utf-8?B?dlgzRUx0VW5acms3UGpBUWo0Y285OTBQdWs2QVgwR2FEVGVzQUUrbEJwT2Nh?=
 =?utf-8?B?ZXFqcWNqZlJmbHIrd0U0aFJabmFWN1cwLzE4VVUyRy9jTDJnRldTWWIzOFJ4?=
 =?utf-8?B?cVNTQ0hka0gwdWpudEtCWGpHUzgwWGFsbkdCSXNxTklkZVN4T0x0Q3pPU3c5?=
 =?utf-8?B?eTVYNzIxeHR2eURHRW1tZ2JqSld5NmI5TVhsclR5eDVBcVozQTVpdkhEL0tn?=
 =?utf-8?B?TUUyY3Z1UGxuQTRJelNCVUZNc2Rra1Ftb0Mva1VJdkNrL3Bwc0x2UnJ2R3c1?=
 =?utf-8?B?S2dhYjlZb2ZvS2Vvb0xRckpBeFplY3g5TUZkemlVZWJxM2IyaG9DRVFBaXFH?=
 =?utf-8?B?SEJaZnR6cXVldjB3N1VKdmpSL1FxSUIwQUFDVlV3dCt6Y3FHT2F5UzZnWDlP?=
 =?utf-8?B?N2FWUHVYME54UnVQdWlCWnBRcDc0d0w0cnV5ekJXL3UzNDU5YzRrcVJqbzRx?=
 =?utf-8?B?b1FIOXNqOG51VHBKZDh6U0hic3oxMmVpY3kvNlFyVkR5TVQvZVF3UW5xeS8w?=
 =?utf-8?B?a25teWlOTlVOZUJXQ2hkM2x2d2N4SWtqRmtiNXdhcUsyZjVjRjVVQm5vWndE?=
 =?utf-8?B?S0F5MTMxNjh2NHhzVk9BVTRCd3Eyb09iVEdkSi9xVkFUejVNa3dRNEpCMVZJ?=
 =?utf-8?B?WkhIb3cwT3Q1eGZvOHFyTm9oRHZXYit0WDBjNWNPOVgzUG93SktqVyt0clow?=
 =?utf-8?B?SWw0L0JTdUY1Qk85YXUrOWxKRS9NdEErYTlLbU9IYWd4ZzJwVE4zc3FVODhU?=
 =?utf-8?B?ZFdXVHNsUXdDclBJK0hSYk94WjU5SVJOc0tBNlhEa2tKcTZTQW9ITit3L2Yr?=
 =?utf-8?B?c0RjTDRQMkc2NHIzU3ZqVWRFdTI2TUh1VlY4RE1VUUtjam9pbXp3TjFacllD?=
 =?utf-8?B?OGNiY0JUaFd4Wk95bEtyMStPZllTZnM1T2x0YXlFck1xNFYzSXg3cFU1WEZ1?=
 =?utf-8?B?amRtdWJSQ2plcHBjMkJ2UlRQTmNqYjBOdS9odG5jbGE3MWF6a05oaExjSEl1?=
 =?utf-8?B?c3h5WE02UU5pUWZOUHNRR3JzVGExL0pPM1o5R0IxcHM2TTlEa3dYL1ZLL2Fw?=
 =?utf-8?B?U3BtTVZ5VFdzdVNjazB1OGFDQWdTMjNrVUdYUHVnZ2NhZ21vOTJFNldlY0NI?=
 =?utf-8?B?SGptVUJlZVEzU1BWdHFYMDJMcDhUditCL3VwNytFbDNMano0QXlOU01IeENP?=
 =?utf-8?B?RkJnVHA2MWFuUDgyNE5lWWY0bFRlS3ZJWnE2RkFsQzVXRmE5dnNrVHA5dG5l?=
 =?utf-8?B?Rk00bFVBRGd3WjR1M2l1NG55LzlpVnZDS0lRQ0NFUlZjSzFQemtXM2V3NlVH?=
 =?utf-8?B?ejM1ZmwrVTA2ZnVoS1I3cE51U2ZqWERMVHNTZVRlWmhBdGZmWGtlWVhpeVRM?=
 =?utf-8?B?b1gycnUzRjVkTGNEOEM2WDRpNHpheUN1aUFXWEJ1WUcxdC96dFE1TmEybldJ?=
 =?utf-8?B?ZGNETm54VU83TDFlVGhaZWdCVlV2T3hFMjJhMFVtZGRtbHBEa2pJaklXcmhj?=
 =?utf-8?B?ZHBFZkNpWndPUUNDbWgwK25kWWlVeVdZam5JVm5WL0NVRDUvQUV4UGRkUWFs?=
 =?utf-8?B?bjlrRERoRHRRa1pxT1hiMk01dlRxN0tOTHlLdkZDQSs5cHp3Qi9LRndZd1RR?=
 =?utf-8?B?amZWZWUxL2RLUndEMklxYXJsalAwYmx4dUJkZUF2b0hRcjkycm51eVdrb01Q?=
 =?utf-8?B?ZWVkc0huMlNKUXJCZGtuRlBsd0xScERMQjhVV1V5V0YzRGhHNlgvT1dvbzU5?=
 =?utf-8?B?TzJiY2Qva2RaS1EvU053VFBMR0hXRnAranQwb1VjV1V6ZGxMU1JrWTZ5eTd2?=
 =?utf-8?B?dXVMbUdtNWVwcUM4bldBajdVMGVkYTNKY0J5VFd2Qkg2WXdSK3RQcjlXOSt1?=
 =?utf-8?B?SlZNa1hIaUxON05rQXdlMDNJUS9EQ0pGQytUaFBXTHhRUm1FdHhub2RJa0R3?=
 =?utf-8?B?Nkx1eUtjS05WanZ3S0Zjbmd4SVNnR0VETnJEYWd6djY2YXJKOXpEZz09?=
X-Exchange-RoutingPolicyChecked: psIG6zwDCeWIqJ4JNfcRLUk1bfzJiNbeyCpF/2+RVlQoyl3dDEq2NiImW409W2abMaHYfPybWUDY7mt9ImkNKPvs1O8lX1iTlILJBeFg2hu61+MemiHBaqXv1DWte5gF+FYrxl+viXhcW0n8A+Uxw8VUuclIDrNIowQULwz2f3oi+5bRbR2zSHIQ+WUBi0yMvz9pJrbXRmm9uKkjMlp5fOVDPmKU85fbzloG5BIQIjOxfM5weiXPRGZHzMU8ZUvHJtdnLCZ3hXykfa5sIkuHxfp04RmprbzbdkVfAt5TAEQtq05wgA54biZ0GIe6QayaxBzGxUY2w4efZELUPszqmg==
X-MS-Exchange-CrossTenant-Network-Message-Id: ac11b5f8-0540-4658-1790-08df3784e5a4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2026 19:26:45.5483
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fkrRRmhUIW7mk0IZQ5JjJpn/EIKd4dNDOc4PcaRFasnHKoirhwW/Ii2sR7Ak+Sj0FEqiC0B4M5Hl82p8xbYB8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR84MB3613
X-OriginatorOrg: hpe.com
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMxMDA3NyBTYWx0ZWRfX+L2D09xQLYNt
 lZrvrm1C9QUWdK8McGY9sWNYDbW0bX1U1BqbJCY9xhrejvJVwG+MwkIqtn5JtKrr5BrZSOeq2oC
 NZSONQbim0pX+oCRe/96TBn5Lfz6kr61JcBnT00nL465FFWRxBJOmrKWvG7QcsHy8iobJ3eWPDx
 41mViUXZlsCPtr4ugaWnu3TTCRwcte8i/VGZy9uHYG5qyS/WyU2S1kGjbn4frYQysyYMUEinoL3
 vnVWee1ZKjNgXIbgjs+JNjG+QoSZb2PkPdeHpfpThNPaM5mjw7tKVrA1NbyzRR5SCrCR0VrwWYI
 arc6FCG75R4sooPEFfmFoKCZcNfPiLmvQEjH7sgDjeCzQGn4xTwnV4TKHcBT6G3ydhKnQD/fY+i
 k7egWN01NIVjZDNIrpRcj34+7BQ1dQ7x/UyRFQWMk7iz0HVzIKy99XvHsytwFk1BGIGE16X8+kN
 SyWYnYst4LI61zrCz1w==
X-Proofpoint-GUID: jVPMEWR4d9j_Ovd7dfQHEtR6PkPewhKB
X-Authority-Analysis: v=2.4 cv=Z+55j3RA c=1 sm=1 tr=0 ts=6ae6410d cx=c_pps
 a=A+SOMQ4XYIH4HgQ50p3F5Q==:117 a=A+SOMQ4XYIH4HgQ50p3F5Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=gQcMVamqm3wCPoSYhaRC:22
 a=RtSn8ETxjE2H05FtM2s8:22 a=MvuuwTCpAAAA:8 a=Ty15GE0K8MHnUIQt_1kA:9
 a=-11b_dtvHWg0nVEp:21 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMxMDA3NyBTYWx0ZWRfX9KiHV3A8c3Xq
 63BbY5oRCXgOIQYDO8dOOw0LklnwkwEVekQPqgCwPeAZbU6LZFQNPdPYtpD4EEJ086cg/aGE8kY
 0HuGoMXsxuOfWl8t5NoHgDa5tWV0nGk=
X-Proofpoint-ORIG-GUID: jVPMEWR4d9j_Ovd7dfQHEtR6PkPewhKB
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-31_05,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 phishscore=0 clxscore=1015 impostorscore=0 spamscore=0 bulkscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2610310077

Add the headers the cxiverbs provider is built on.

kernel-headers/rdma/cxiverbs-abi.h and
kernel-headers/ethernet/cassini_user_defs.h are copies of the kernel's
UAPI headers and must be updated together with them.  providers/cxi/
cxiverbs-abi.h is a thin wrapper that exposes the ABI under the name
the provider includes.

providers/cxi/cxi_prov_hw.h is a copy of the kernel's
include/linux/hpe/cxi/cxi_prov_hw.h.  It differs from it in two
places only: a prologue that supplies the kernel integer types and
errno/string headers for user space, and the include path of
cassini_user_defs.h.

cxi.h holds the provider's private structures and the QPN encoding
and cxi_verbs.h the provider-visible verbs extensions.  The provider
is named cxiverbs, not cxi, so that it does not collide with libcxi.so,
which is built from a separate project and links against this
provider's direct verbs API.

checkpatch (rdma-core CI settings) still reports
PREFER_DEFINED_ATTRIBUTE_MACRO (27) and VOLATILE (2) in this patch.
They are intentional, documented in providers/cxi/utils/README.md: the
imported UAPI and hardware headers use portable
__attribute__((packed)) because kernel-private __packed is not
available to userspace, and the command-queue status and event
write-back fields keep volatile because the device updates them. If
reviewers prefer a different form, it needs coordination with the
internal repositories these headers are synchronized from and will be
changed in V2.

Co-developed-by: Iraimani P <iraimani.pavadai@hpe.com>
Signed-off-by: Iraimani P <iraimani.pavadai@hpe.com>
Signed-off-by: Doug Ledford <doug.ledford@hpe.com>
---
 kernel-headers/ethernet/cassini_user_defs.h | 15004 ++++++++++++++++++++++++++
 kernel-headers/rdma/cxiverbs-abi.h          |   658 ++
 providers/cxi/cxi.h                         |   265 +
 providers/cxi/cxi_prov_hw.h                 |  1838 ++++
 providers/cxi/cxi_verbs.h                   |    56 +
 providers/cxi/cxiverbs-abi.h                |    29 +
 6 files changed, 17850 insertions(+)

diff --git a/kernel-headers/ethernet/cassini_user_defs.h b/kernel-headers/ethernet/cassini_user_defs.h
new file mode 100644
index 000000000000..995359850bfd
--- /dev/null
+++ b/kernel-headers/ethernet/cassini_user_defs.h
@@ -0,0 +1,15004 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * Cassini hardware definitions
+ * Copyright 2018-2021 Hewlett Packard Enterprise Development LP
+ *
+ * This file is generated. Do not modify.
+ */
+
+#ifndef __CASSINI_USER_DEFS_H
+#define __CASSINI_USER_DEFS_H
+
+#include <asm/byteorder.h>
+
+#ifndef __LITTLE_ENDIAN
+#error "Non-little endian builds not supported"
+#endif
+
+#ifndef __KERNEL__
+#include <endian.h>
+
+/* Provide fallback implementations if endian.h functions aren't available */
+#ifndef be64toh
+#define be64toh(x) __builtin_bswap64(x)
+#endif
+#ifndef htobe64
+#define htobe64(x) __builtin_bswap64(x)
+#endif
+#ifndef be32toh
+#define be32toh(x) __builtin_bswap32(x)
+#endif
+#ifndef htobe32
+#define htobe32(x) __builtin_bswap32(x)
+#endif
+#ifndef be16toh
+#define be16toh(x) __builtin_bswap16(x)
+#endif
+#ifndef htobe16
+#define htobe16(x) __builtin_bswap16(x)
+#endif
+
+#define be64_to_cpu be64toh
+#define be32_to_cpu be32toh
+#define be16_to_cpu be16toh
+#define cpu_to_be64 htobe64
+#define cpu_to_be32 htobe32
+#define cpu_to_be16 htobe16
+#endif
+
+#define C_CQ_BASE 0x00000000
+#define C_PCT_BASE 0x00800000
+#define C_HNI_BASE 0x01000000
+#define C_HNI_PML_BASE 0x01800000
+#define C_RMU_BASE 0x02000000
+#define C_IXE_BASE 0x02800000
+#define C_ATU_BASE 0x08000000
+#define C_EE_BASE 0x08800000
+#define C_PARBS_BASE 0x09000000
+#define C_LPE_BASE 0x09800000
+#define C_MST_BASE 0x0a000000
+#define C_OXE_BASE 0x0a800000
+#define C_MB_BASE 0x10000000
+#define C_PI_BASE 0x10800000
+#define C_PI_IPD_BASE 0x11000000
+#define C_MEMORG_CSR 0x40000000u
+#define C_MEMORG_CSR_SIZE 0x28000000u
+#define C_MEMORG_CQ_LAUNCH 0x00000000u
+#define C_MEMORG_CQ_LAUNCH_SIZE 0x08000000u
+#define C_MEMORG_CQ_TOU 0x08000000u
+#define C_MEMORG_EE 0x10000000u
+#define C_CQ_LAUNCH_TXQ_BASE (C_MEMORG_CQ_LAUNCH + 0x00000000)
+#define C_CQ_LAUNCH_TGT_BASE (C_MEMORG_CQ_LAUNCH + 0x04000000)
+#define C_CQ_LAUNCH_PAGE_SIZE 0x10000
+#define C_TOU_LAUNCH_PAGE_SIZE 0x10000
+#define C_EE_SW_STATE_PAGE_SIZE 0x10000
+#define C_NUM_CTS 2048
+#define C_CT_NONE 0
+#define C_AC_NONE 0
+#define C_CID_NONE 0
+#define C_NUM_EQS 2048
+#define C_EQ_NONE 0
+#define C_NUM_ACS 1024
+#define C_NUM_PTLTES 2048
+#define C_NUM_TRANSMIT_CQS 1024
+#define C_NUM_TARGET_CQS 512
+#define C_NID_ANY 1048575
+#define NICSIM_CONFIG_DUMP 0x27fff008
+#define NICSIM_CONFIG_LOG 0x27fff010
+#define NICSIM_CONFIG_STATE 0x27fff018
+#define NICSIM_NIC_ID 0x27fff060
+#define C_PLATFORM_ASIC 0
+#define C_PLATFORM_NETSIM 1
+#define C_PLATFORM_Z1 2
+#define C_PLATFORM_FPGA 3
+#define C_MST_TABLE_SIMPLE_OFFSET 16
+#define C_PE_COUNT 4
+#define C_COMM_PROF_PER_CQ 16
+#define C_DFA_PID_BITS_MIN 6
+#define C_DFA_PID_BITS_MAX 9
+#define C_PID_ANY ((1 << C_DFA_PID_BITS_MAX) - 1)
+#define C_RANK_ANY ((1 << (32 - C_DFA_PID_BITS_MAX)) - 1)
+#define C_DFA_NIC_BITS 20
+#define C_DFA_MULTICAST_ID_BITS 13
+#define C_DFA_INDEX_EXT_BITS 5
+#define C_CT_SUCCESS_BITS 48
+#define C_CT_FAILURE_BITS 7
+#define C_DFA_ENDPOINT_DEFINED_BITS 12
+#define C_DFA_ENDPOINT_BITS (C_DFA_ENDPOINT_DEFINED_BITS + C_DFA_INDEX_EXT_BITS)
+#define C_NUM_RGIDS 256
+#define C_RESERVED_RGID 0
+#define C_OXE_CQ_MCU_START 0
+#define C_OXE_CQ_MCU_COUNT 48
+#define C_OXE_LPE_MCU_START (C_OXE_CQ_MCU_START + C_OXE_CQ_MCU_COUNT)
+#define C_OXE_LPE_MCU_COUNT 16
+#define C_OXE_IXE_MCU_START (C_OXE_LPE_MCU_START + C_OXE_LPE_MCU_COUNT)
+#define C_OXE_IXE_MCU_COUNT 24
+#define C_OXE_TOU_MCU_START (C_OXE_IXE_MCU_START + C_OXE_IXE_MCU_COUNT)
+#define C_OXE_TOU_MCU_COUNT 8
+#define C_OXE_MCU_COUNT                                                                            \
+	(C_OXE_CQ_MCU_COUNT + C_OXE_IXE_MCU_COUNT + C_OXE_LPE_MCU_COUNT + C_OXE_TOU_MCU_COUNT)
+#define C_NUM_LACS 8
+#define C_NUM_TLES 2048
+#define C_NUM_VFS 64
+#define C_MAX_IDC_PAYLOAD_RES 224
+#define C_MAX_IDC_PAYLOAD_UNR 192
+#define C_ATU_PRB_ENTRIES 512
+
+enum c_rsp_status {
+	C_RSP_PEND = 0,
+	C_RSP_NACK_RCVD = 1,
+	C_RSP_GET_ACK_RCVD = 2,
+	C_RSP_OP_COMP = 3,
+};
+
+enum c_sct_status {
+	C_SCT_NOT_USED = 0,
+	C_SCT_NORMAL = 1,
+	C_SCT_STALL = 2,
+	C_SCT_CLEAR_PEND = 3,
+	C_SCT_CLOSE_PEND = 4,
+	C_SCT_CLOSE_TIMEOUT = 5,
+	C_SCT_CLOSE_COMP = 6,
+	C_SCT_RETRY = 7,
+};
+
+enum c_port_v4_pkt_type {
+	C_V4_PKT_UNRESTRICTED = 0,
+	C_V4_PKT_SMALLMSG = 1,
+	C_V4_PKT_CONTINUATION = 2,
+	C_V4_PKT_CONN_MGMT = 3,
+	C_V4_PKT_RESTRICTED = 4,
+	C_RESERVED5 = 5,
+	C_RESERVED6 = 6,
+	C_V4_PKT_HRP_ACK = 7,
+};
+
+enum c_port_vs_pkt_type {
+	C_VS_PKT_PUT64 = 0,
+	C_VS_PKT_GET64 = 1,
+	C_VS_PKT_PUT32 = 2,
+	C_VS_PKT_GET32 = 3,
+	C_VS_PKT_AMO64 = 4,
+	C_VS_PKT_FAMO64 = 5,
+	C_VS_PKT_AMO32 = 6,
+	C_VS_PKT_FAMO32 = 7,
+};
+
+enum c_port_rsp_pkt_type {
+	C_RSP_PKT_ANY = 0,
+	C_RSP_PKT_32B = 1,
+};
+
+enum c_format {
+	C_PKT_FORMAT_OPT = 0,
+	C_PKT_FORMAT_STD = 1,
+};
+
+enum c_checksum_ctrl {
+	C_CHECKSUM_CTRL_NONE = 0,
+	C_CHECKSUM_CTRL_ROCE = 1,
+	C_CHECKSUM_CTRL_UDP = 2,
+	C_CHECKSUM_CTRL_TCP = 3,
+};
+
+enum c_cmd_size {
+	C_CMD_SIZE_32B = 0,
+	C_CMD_SIZE_64B = 1,
+	C_CMD_SIZE_128B = 2,
+	C_CMD_SIZE_256B = 3,
+};
+
+enum c_ptl_list {
+	C_PTL_LIST_PRIORITY = 0,
+	C_PTL_LIST_OVERFLOW = 1,
+	C_PTL_LIST_REQUEST = 2,
+	C_PTL_LIST_UNEXPECTED = 3,
+};
+
+enum c_atomic_op {
+	C_AMO_OP_MIN = 0,
+	C_AMO_OP_MAX = 1,
+	C_AMO_OP_SUM = 2,
+	C_AMO_OP_LOR = 4,
+	C_AMO_OP_LAND = 5,
+	C_AMO_OP_BOR = 6,
+	C_AMO_OP_BAND = 7,
+	C_AMO_OP_LXOR = 8,
+	C_AMO_OP_BXOR = 9,
+	C_AMO_OP_SWAP = 10,
+	C_AMO_OP_CSWAP = 11,
+	C_AMO_OP_AXOR = 12,
+};
+
+enum c_cswap_op {
+	C_AMO_OP_CSWAP_EQ = 0,
+	C_AMO_OP_CSWAP_NE = 1,
+	C_AMO_OP_CSWAP_LE = 2,
+	C_AMO_OP_CSWAP_LT = 3,
+	C_AMO_OP_CSWAP_GE = 4,
+	C_AMO_OP_CSWAP_GT = 5,
+};
+
+enum c_atomic_type {
+	C_AMO_TYPE_INT8_T = 0,
+	C_AMO_TYPE_UINT8_T = 1,
+	C_AMO_TYPE_INT16_T = 2,
+	C_AMO_TYPE_UINT16_T = 3,
+	C_AMO_TYPE_INT32_T = 4,
+	C_AMO_TYPE_UINT32_T = 5,
+	C_AMO_TYPE_INT64_T = 6,
+	C_AMO_TYPE_UINT64_T = 7,
+	C_AMO_TYPE_FLOAT_T = 8,
+	C_AMO_TYPE_FLOAT_COMPLEX_T = 9,
+	C_AMO_TYPE_DOUBLE_T = 10,
+	C_AMO_TYPE_DOUBLE_COMPLEX_T = 11,
+	C_AMO_TYPE_UINT128_T = 12,
+};
+
+enum c_ptlte_state {
+	C_PTLTE_RESET = 0,
+	C_PTLTE_DISABLED = 1,
+	C_PTLTE_ENABLED = 2,
+	C_PTLTE_SOFTWARE_MANAGED = 3,
+	C_PTLTE_ETHERNET = 4,
+};
+
+enum c_cmd_type {
+	C_CMD_TYPE_IDC = 0,
+	C_CMD_TYPE_DMA = 1,
+	C_CMD_TYPE_CT = 2,
+	C_CMD_TYPE_CQ = 3,
+};
+
+enum c_dma_op {
+	C_CMD_NOOP = 0,
+	C_CMD_PUT = 1,
+	C_CMD_GET = 2,
+	C_CMD_RENDEZVOUS_PUT = 3,
+	C_CMD_ATOMIC = 4,
+	C_CMD_FETCHING_ATOMIC = 5,
+	C_CMD_ETHERNET_TX = 6,
+	C_CMD_SMALL_MESSAGE = 7,
+	C_CMD_NOMATCH_PUT = 8,
+	C_CMD_NOMATCH_GET = 9,
+	C_CMD_CSTATE = 10,
+	C_CMD_CLOSE = 11,
+	C_CMD_CLEAR = 12,
+	C_CMD_REDUCTION = 13,
+};
+
+enum c_ct_op {
+	C_CMD_CT_NOOP = 0,
+	C_CMD_CT_SET = 1,
+	C_CMD_CT_GET = 2,
+	C_CMD_CT_INC = 3,
+	C_CMD_CT_CANCEL = 4,
+	C_CMD_CT_TRIG_DMA = 5,
+	C_CMD_CT_TRIG_SET = 6,
+	C_CMD_CT_TRIG_INC = 7,
+	C_CMD_CT_TRIG_EVENT = 8,
+};
+
+enum c_cq_op {
+	C_CMD_CQ_NOOP = 0,
+	C_CMD_CQ_FENCE = 1,
+	C_CMD_CQ_LCID = 2,
+};
+
+enum c_tgt_op {
+	C_CMD_TGT_APPEND = 8,
+	C_CMD_TGT_SEARCH = 9,
+	C_CMD_TGT_SEARCH_AND_DELETE = 10,
+	C_CMD_TGT_UNLINK = 11,
+	C_CMD_TGT_SETSTATE = 12,
+};
+
+enum c_event_size {
+	C_EVENT_SIZE_NO_EVENT = 0,
+	C_EVENT_SIZE_16_BYTE = 1,
+	C_EVENT_SIZE_32_BYTE = 2,
+	C_EVENT_SIZE_64_BYTE = 3,
+};
+
+enum c_event_type {
+	C_EVENT_PUT = 0,
+	C_EVENT_GET = 1,
+	C_EVENT_ATOMIC = 2,
+	C_EVENT_FETCH_ATOMIC = 3,
+	C_EVENT_PUT_OVERFLOW = 4,
+	C_EVENT_GET_OVERFLOW = 5,
+	C_EVENT_ATOMIC_OVERFLOW = 6,
+	C_EVENT_FETCH_ATOMIC_OVERFLOW = 7,
+	C_EVENT_SEND = 8,
+	C_EVENT_ACK = 9,
+	C_EVENT_REPLY = 10,
+	C_EVENT_LINK = 11,
+	C_EVENT_SEARCH = 12,
+	C_EVENT_STATE_CHANGE = 13,
+	C_EVENT_UNLINK = 14,
+	C_EVENT_RENDEZVOUS = 15,
+	C_EVENT_ETHERNET = 16,
+	C_EVENT_COMMAND_FAILURE = 17,
+	C_EVENT_TRIGGERED_OP = 18,
+	C_EVENT_ETHERNET_FGFC = 19,
+	C_EVENT_PCT = 20,
+	C_EVENT_MATCH = 21,
+	C_EVENT_ERROR = 28,
+	C_EVENT_TIMESTAMP = 29,
+	C_EVENT_EQ_SWITCH = 30,
+	C_EVENT_NULL_EVENT = 31,
+};
+
+enum c_return_code {
+	C_RC_NO_EVENT = 0,
+	C_RC_OK = 1,
+	C_RC_UNDELIVERABLE = 2,
+	C_RC_PT_DISABLED = 3,
+	C_RC_DROPPED = 4,
+	C_RC_PERM_VIOLATION = 5,
+	C_RC_OP_VIOLATION = 6,
+	C_RC_NO_MATCH = 8,
+	C_RC_UNCOR = 9,
+	C_RC_UNCOR_TRNSNT = 10,
+	C_RC_NO_SPACE = 16,
+	C_RC_ENTRY_NOT_FOUND = 18,
+	C_RC_NO_TARGET_CONN = 19,
+	C_RC_NO_TARGET_MST = 20,
+	C_RC_NO_TARGET_TRS = 21,
+	C_RC_SEQUENCE_ERROR = 22,
+	C_RC_NO_MATCHING_CONN = 23,
+	C_RC_INVALID_DFA_FORMAT = 24,
+	C_RC_VNI_NOT_FOUND = 25,
+	C_RC_PTLTE_NOT_FOUND = 26,
+	C_RC_PTLTE_SW_MANAGED = 27,
+	C_RC_SRC_ERROR = 28,
+	C_RC_MST_CANCELLED = 29,
+	C_RC_HRP_CONFIG_ERROR = 30,
+	C_RC_HRP_RSP_ERROR = 31,
+	C_RC_HRP_RSP_DISCARD = 32,
+	C_RC_INVALID_AC = 33,
+	C_RC_PAGE_PERM_ERROR = 34,
+	C_RC_ATS_ERROR = 35,
+	C_RC_NO_TRANSLATION = 36,
+	C_RC_PAGE_REQ_ERROR = 37,
+	C_RC_PCIE_ERROR_POISONED = 38,
+	C_RC_PCIE_UNSUCCESS_CMPL = 39,
+	C_RC_AMO_INVAL_OP_ERROR = 40,
+	C_RC_AMO_ALIGN_ERROR = 41,
+	C_RC_AMO_FP_INVALID = 42,
+	C_RC_AMO_FP_UNDERFLOW = 43,
+	C_RC_AMO_FP_OVERFLOW = 44,
+	C_RC_AMO_FP_INEXACT = 45,
+	C_RC_ILLEGAL_OP = 46,
+	C_RC_INVALID_ENDPOINT = 47,
+	C_RC_RESTRICTED_UNICAST = 48,
+	C_RC_CMD_ALIGN_ERROR = 49,
+	C_RC_CMD_INVALID_ARG = 50,
+	C_RC_INVALID_EVENT = 51,
+	C_RC_ADDR_OUT_OF_RANGE = 52,
+	C_RC_CONN_CLOSED = 53,
+	C_RC_CANCELED = 54,
+	C_RC_NO_MATCHING_TRS = 55,
+	C_RC_NO_MATCHING_MST = 56,
+	C_RC_DELAYED = 57,
+	C_RC_AMO_LENGTH_ERROR = 58,
+	C_RC_PKTBUF_ERROR = 59,
+	C_RC_RESOURCE_BUSY = 60,
+	C_RC_FLUSH_TRANSLATION = 61,
+	C_RC_TRS_PEND_RSP = 62,
+};
+
+enum c_rss_hash_type {
+	C_RSS_HASH_NONE = 0,
+	C_RSS_HASH_IPV4 = 1,
+	C_RSS_HASH_IPV4_TCP = 2,
+	C_RSS_HASH_IPV4_UDP = 3,
+	C_RSS_HASH_IPV4_PROTOCOL = 4,
+	C_RSS_HASH_IPV4_PROTOCOL_TCP = 5,
+	C_RSS_HASH_IPV4_PROTOCOL_UDP = 6,
+	C_RSS_HASH_IPV4_PROTOCOL_UDP_ROCE = 7,
+	C_RSS_HASH_IPV4_FLOW_LABEL = 8,
+	C_RSS_HASH_IPV6 = 9,
+	C_RSS_HASH_IPV6_TCP = 10,
+	C_RSS_HASH_IPV6_UDP = 11,
+	C_RSS_HASH_IPV6_PROTOCOL = 12,
+	C_RSS_HASH_IPV6_PROTOCOL_TCP = 13,
+	C_RSS_HASH_IPV6_PROTOCOL_UDP = 14,
+	C_RSS_HASH_IPV6_PROTOCOL_UDP_ROCE = 15,
+	C_RSS_HASH_IPV6_FLOW_LABEL = 16,
+};
+
+enum c_sc_reason {
+	C_SC_FC_EQ_FULL = 0,
+	C_SC_FC_NO_MATCH = 1,
+	C_SC_FC_UNEXPECTED_FAIL = 2,
+	C_SC_FC_REQUEST_FULL = 3,
+	C_SC_SM_UNEXPECTED_FAIL = 4,
+	C_SC_SM_APPEND_FAIL = 5,
+	C_SC_DIS_UNCOR = 6,
+};
+
+enum c_pct_event_type {
+	C_PCT_REQUEST_NACK = 0,
+	C_PCT_REQUEST_TIMEOUT = 1,
+	C_PCT_SCT_TIMEOUT = 2,
+	C_PCT_TCT_TIMEOUT = 3,
+	C_PCT_ACCEL_CLOSE_COMPLETE = 4,
+	C_PCT_RETRY_COMPLETE = 5,
+};
+
+enum c_error_class {
+	C_EC_SFTWR = 0,
+	C_EC_INFO = 1,
+	C_EC_TRS_NS = 2,
+	C_EC_TRS_S = 3,
+	C_EC_TRNSNT_NS = 4,
+	C_EC_TRNSNT_S = 5,
+	C_EC_BADCON_NS = 6,
+	C_EC_BADCON_S = 7,
+	C_EC_DEGRD_NS = 8,
+	C_EC_COR = 9,
+	C_EC_UNCOR_NS = 10,
+	C_EC_UNCOR_S = 11,
+	C_EC_CRIT = 12,
+};
+
+enum c_odp_status {
+	C_ATU_ODP_SUCCESS = 0,
+	C_ATU_ODP_FAILURE = 1,
+};
+
+enum c_ta_mode {
+	C_ATU_ATS_MODE = 0,
+	C_ATU_NTA_MODE = 1,
+	C_ATU_ATS_DYNAMIC_MODE = 2,
+	C_ATU_PASSTHROUGH_MODE = 3,
+};
+
+enum c_ptg_mode {
+	C_ATU_PTG_MODE_SGL = 0,
+	C_ATU_PTG_MODE_DBL_A = 1,
+	C_ATU_PTG_MODE_DBL_B = 2,
+	C_ATU_PTG_MODE_DBL_C = 3,
+	C_ATU_PTG_MODE_TPL_A = 4,
+	C_ATU_PTG_MODE_TPL_B = 5,
+};
+
+enum c_odp_mode {
+	C_ATU_ODP_MODE_ATS_PRS = 0,
+	C_ATU_ODP_MODE_NIC_PRI = 1,
+};
+
+enum c_atucq_cmd {
+	C_ATU_NOP = 0,
+	C_ATU_INVALIDATE_PAGES = 1,
+	C_ATU_COMPLETION_WAIT = 2,
+	C_ATU_RESERVED = 3,
+};
+
+enum c_enet_frame_type {
+	C_RMU_ENET_802_3 = 1,
+	C_RMU_ENET_OPT_IPV4 = 2,
+	C_RMU_ENET_OPT_IPV6 = 3,
+};
+
+enum c_msix_ints {
+	C_PF_TO_VF_MSIX_INT = 0,
+	C_PI_IPD_IRQA_MSIX_INT = 0,
+	C_PI_IRQA_MSIX_INT = 1,
+	C_MB_IRQA_MSIX_INT = 2,
+	C_CQ_IRQA_MSIX_INT = 3,
+	C_PCT_IRQA_MSIX_INT = 4,
+	C_HNI_IRQA_MSIX_INT = 5,
+	C_HNI_PML_IRQA_MSIX_INT = 6,
+	C_RMU_IRQA_MSIX_INT = 7,
+	C_IXE_IRQA_MSIX_INT = 8,
+	C_ATU_IRQA_MSIX_INT = 9,
+	C_EE_IRQA_MSIX_INT = 10,
+	C_PARBS_IRQA_MSIX_INT = 11,
+	C_LPE_IRQA_MSIX_INT = 12,
+	C_MST_IRQA_MSIX_INT = 13,
+	C_OXE_IRQA_MSIX_INT = 14,
+	C_PI_IPD_IRQB_MSIX_INT = 15,
+	C_PI_IRQB_MSIX_INT = 16,
+	C_MB_IRQB_MSIX_INT = 17,
+	C_CQ_IRQB_MSIX_INT = 18,
+	C_PCT_IRQB_MSIX_INT = 19,
+	C_HNI_IRQB_MSIX_INT = 20,
+	C_HNI_PML_IRQB_MSIX_INT = 21,
+	C_RMU_IRQB_MSIX_INT = 22,
+	C_IXE_IRQB_MSIX_INT = 23,
+	C_ATU_IRQB_MSIX_INT = 24,
+	C_EE_IRQB_MSIX_INT = 25,
+	C_PARBS_IRQB_MSIX_INT = 26,
+	C_LPE_IRQB_MSIX_INT = 27,
+	C_MST_IRQB_MSIX_INT = 28,
+	C_OXE_IRQB_MSIX_INT = 29,
+	C_PI_DMAC_MSIX_INT = 30,
+	C_PI_IPD_VF_PF_MSIX_INT = 31,
+	C_FIRST_AVAIL_MSIX_INT = 32,
+};
+
+enum c_pi_err_flg_bit {
+	C_PI_ERR_FLG__UC_ATTENTION_0 = 62,
+	C_PI_ERR_FLG__UC_ATTENTION_1 = 63,
+};
+
+enum c_pct_bitmask {
+	C_PCT_CFG_SRB_RETRY_GRP_CTRL__GRP_LOADED_MSK = 0x1,
+	C_PCT_CFG_SRB_RETRY_GRP_CTRL__GRP_ACTIVE_MSK = 0x2,
+	C_PCT_CFG_SW_SIM_SRC_RSP__LOADED_MSK = 0x1000000000000,
+	C_PCT_CFG_SW_RETRY_SRC_CLS_REQ__LOADED_MSK = 0x10000,
+	C_PCT_CFG_SW_SIM_TGT_CLS_REQ__LOADED_MSK = 0x10000,
+};
+
+enum c2_link_dn_behavior {
+	C2_HNI_PML_LD_DISCARD = 0,
+	C2_HNI_PML_LD_BLOCK = 1,
+	C2_HNI_PML_LD_BEST_EFFORT = 2,
+};
+
+enum c2_llr_state {
+	C2_HNI_PML_OFF_LLR = 0,
+	C2_HNI_PML_INIT = 1,
+	C2_HNI_PML_ADVANCE = 2,
+	C2_HNI_PML_HALT = 3,
+	C2_HNI_PML_REPLAY = 4,
+	C2_HNI_PML_DISCARD = 5,
+	C2_HNI_PML_MONITOR = 6,
+};
+
+enum c2_link_function {
+	C2_LF_ETH_ACC = 0,
+	C2_LF_ETH_TRUNK = 1,
+	C2_LF_C3_R2 = 2,
+	C2_LF_C2_R2 = 3,
+	C2_LF_C1_R2 = 4,
+	C2_LF_C3_R1 = 5,
+	C2_LF_R1_R2 = 6,
+	C2_LF_R2_R2_FAB_NRML = 7,
+	C2_LF_R2_R2_FAB_TRANS = 8,
+	C2_LF_R2_R2_FAB_TO_FAB = 9,
+	C2_LF_R2_R2_FAB_RTR = 10,
+	C2_LF_C2_R1 = 11,
+};
+
+struct c_fa_anon {
+	__u8 action : 3;
+	__u32: 20;
+	__u16 fa_format : 9;
+};
+
+struct c_fa_unicast {
+	__u16 endpoint_defined : 12;
+	__u32 nid : 20;
+};
+
+struct c_fa_multicast {
+	__u8 action : 3;
+	__u16 multicast_id : 13;
+	__u8: 2;
+	__u8 reduction_id : 3;
+	__u8: 2;
+	__u16 format : 9;
+};
+
+union c_fab_addr {
+	struct c_fa_multicast multicast;
+	struct c_fa_unicast unicast;
+	struct c_fa_anon anon;
+};
+
+struct c_process {
+	__u32 process;
+};
+
+struct c_hdr_data {
+	__u64 hdr_data;
+};
+
+struct c_padded_ct_success {
+	__u64 value : 48;
+	__u16 unused_0;
+};
+
+struct c_padded_ct_failure {
+	__u8 value : 7;
+	__u64: 57;
+};
+
+struct c_tct_idx {
+	__u16 tct_idx : 13;
+	__u8: 3;
+};
+
+#ifdef __LITTLE_ENDIAN
+struct c_pkt_type {
+	__u8 opcode : 4;
+	__u8 ver_pkt_type : 3;
+	__u8 req_not_rsp : 1;
+};
+
+#else
+struct c_pkt_type {
+	__u8 req_not_rsp : 1;
+	__u8 ver_pkt_type : 3;
+	__u8 opcode : 4;
+};
+
+#endif
+
+struct c_ts {
+	__u32 ns : 30;
+	__u8 rsvd : 2;
+	__u64 sec : 48;
+} __attribute__((packed));
+
+struct c_padded_sct_idx {
+	__u16 sct_idx : 12;
+	__u8: 1;
+	__u8: 3;
+};
+
+union c_conn_idx {
+	struct c_tct_idx tct_idx;
+	struct c_padded_sct_idx padded_sct_idx;
+};
+
+struct c_ule_entry {
+	__u32: 17;
+	__u8 restricted : 1;
+	__u8 tc : 3;
+	__u8 use_offset_for_get : 1;
+	__u16 rendezvous_id : 8;
+	__u16 vni : 16;
+	__u16 dscp : 6;
+	__u32 sfa_nid : 20;
+	__u64 hdr_data : 64;
+	__u64 match_bits : 64;
+	__u32 initiator : 32;
+	__u64 start_or_offset : 57;
+	__u32 mlength : 32;
+	__u32 request_len : 32;
+	__u8 opcode : 4;
+	__u8 src_error : 1;
+	__u16 addr : 14;
+	__u8 vld : 1;
+	__u16: 11;
+} __attribute__((packed));
+
+struct c_amo_payload {
+	__u8 amo_op : 4;
+	__u8: 4;
+	__u8 amo_type : 4;
+	__u8: 4;
+	__u8 cswap_op : 3;
+	__u8: 5;
+	__u64: 40;
+	__u64 op1_word1;
+	__u64 op1_word2;
+	__u64 op2_word1;
+	__u64 op2_word2;
+};
+
+struct c_small_amo_payload {
+	__u8 amo_op : 4;
+	__u8: 4;
+	__u8 amo_type : 4;
+	__u8: 4;
+	__u64: 48;
+	__u64 op1_word1;
+};
+
+struct c_page_table_entry {
+	__u8: 6;
+	__u64 ptr : 51;
+	__u8 r : 1;
+	__u8 w : 1;
+	__u8 leaf : 1;
+	__u8 p : 1;
+	__u8: 3;
+};
+
+struct c_page_request_entry {
+	__u64 addr : 45;
+	__u16 index : 9;
+	__u16 acid : 10;
+} __attribute__((packed));
+
+struct c_cmd {
+	__u8 cmd_type : 2;
+	__u8 cmd_size : 2;
+	__u8 opcode : 4;
+};
+
+struct c_cmdq {
+	__u16 wr_ptr;
+	__u16 unused_0[511];
+	__u64 ll_wr64a0123[128];
+	__u64 ll_wr128a02[128];
+	__u64 ll_wr128a13[128];
+};
+
+struct c_cq_status {
+	__u16 rd_ptr;
+	__u16 num_write_cmds_rejected;
+	__u8 fail_command;
+	__u8 unused_0;
+	__u8 return_code : 6;
+	__u16: 7;
+	__u8 fail_loc_32 : 1;
+	__u8 fail_ll : 1;
+	__u8 ll_disabled : 1;
+};
+
+struct c_idc_hdr {
+	struct c_cmd command;
+	__u8 length;
+	__u16 unused_0;
+	union c_fab_addr dfa;
+	__u64 remote_offset : 56;
+	__u8 unused_1;
+};
+
+struct c_idc_amo_cmd {
+	struct c_idc_hdr idc_header;
+	__u64 local_addr : 57;
+	__u8: 7;
+	__u8 atomic_op : 4;
+	__u8: 4;
+	__u8 atomic_type : 4;
+	__u8: 4;
+	__u8 cswap_op : 3;
+	__u8: 5;
+	__u64: 40;
+	__u64 op1_word1;
+	__u64 op1_word2;
+	__u64 op2_word1;
+	__u64 op2_word2;
+};
+
+struct c_idc_msg_hdr {
+	struct c_cmd command;
+	__u8 length;
+	__u16 unused_0;
+	union c_fab_addr dfa;
+	__u64 match_bits;
+	__u64 header_data;
+	__u64 user_ptr;
+	__u8 data[];
+};
+
+struct c_cstate_cmd {
+	struct c_cmd command;
+	__u8 length;
+	__u8 write_lac : 3;
+	__u8 event_send_disable : 1;
+	__u8 event_success_disable : 1;
+	__u8 event_ct_send : 1;
+	__u8 event_ct_reply : 1;
+	__u8 event_ct_ack : 1;
+	__u8 event_ct_bytes : 1;
+	__u8 get_with_local_flag : 1;
+	__u8 restricted : 1;
+	__u8 reduction : 1;
+	__u8 flush : 1;
+	__u8 use_offset_for_get : 1;
+	__u8: 1;
+	__u8: 1;
+	__u32 initiator;
+	__u8 index_ext : 5;
+	__u8: 3;
+	__u64: 56;
+	__u64 user_ptr;
+	__u32 unused_0;
+	__u16 ct : 11;
+	__u8: 5;
+	__u16 eq : 11;
+	__u8: 5;
+};
+
+struct c_idc_eth_cmd {
+	struct c_cmd command;
+	__u8 length;
+	__u8 flow_hash;
+	__u8 checksum_ctrl : 2;
+	__u8: 2;
+	__u8 fmt : 1;
+	__u8: 3;
+	__u16 checksum_start : 10;
+	__u8: 2;
+	__u16 checksum_offset : 6;
+	__u16: 14;
+	__u64 unused_0;
+	__u8 data[];
+} __attribute__((packed));
+
+struct c_dma_eth_cmd {
+	struct c_cmd command;
+	__u8 read_lac : 3;
+	__u8: 4;
+	__u8 fmt : 1;
+	__u8 flow_hash;
+	__u8 checksum_ctrl : 2;
+	__u8: 3;
+	__u8 num_segments : 3;
+	__u16 checksum_start : 10;
+	__u8: 2;
+	__u16 checksum_offset : 6;
+	__u16: 14;
+	__u64 user_ptr;
+	__u16 len[7];
+	__u16 unused_0;
+	__u64 addr[7];
+	__u16 total_len;
+	__u8 event_send_disable : 1;
+	__u8 event_success_disable : 1;
+	__u8 event_ct_send : 1;
+	__u8 event_ct_reply : 1;
+	__u8 event_ct_ack : 1;
+	__u8 event_ct_bytes : 1;
+	__u8 get_with_local_flag : 1;
+	__u8 restricted : 1;
+	__u8 reduction : 1;
+	__u8 flush : 1;
+	__u8 use_offset_for_get : 1;
+	__u8: 1;
+	__u8: 1;
+	__u8: 3;
+	__u16 ct : 11;
+	__u8: 5;
+	__u16 eq : 11;
+	__u8: 5;
+} __attribute__((packed));
+
+struct c_nomatch_dma_cmd {
+	struct c_cmd command;
+	__u8 index_ext : 5;
+	__u8: 3;
+	__u8 lac : 3;
+	__u8 event_send_disable : 1;
+	__u8 event_success_disable : 1;
+	__u8 event_ct_send : 1;
+	__u8 event_ct_reply : 1;
+	__u8 event_ct_ack : 1;
+	__u8 event_ct_bytes : 1;
+	__u8 get_with_local_flag : 1;
+	__u8 restricted : 1;
+	__u8 reduction : 1;
+	__u8 flush : 1;
+	__u8 use_offset_for_get : 1;
+	__u8: 1;
+	__u8: 1;
+	union c_fab_addr dfa;
+	__u64 remote_offset : 56;
+	__u8 unused_0;
+	__u64 local_addr : 57;
+	__u8: 7;
+	__u32 request_len;
+	__u16 ct : 11;
+	__u8: 5;
+	__u16 eq : 11;
+	__u8: 5;
+};
+
+struct c_full_dma_cmd {
+	struct c_cmd command;
+	__u8 index_ext : 5;
+	__u8: 3;
+	__u8 lac : 3;
+	__u8 event_send_disable : 1;
+	__u8 event_success_disable : 1;
+	__u8 event_ct_send : 1;
+	__u8 event_ct_reply : 1;
+	__u8 event_ct_ack : 1;
+	__u8 event_ct_bytes : 1;
+	__u8 get_with_local_flag : 1;
+	__u8 restricted : 1;
+	__u8 reduction : 1;
+	__u8 flush : 1;
+	__u8 use_offset_for_get : 1;
+	__u8: 1;
+	__u8: 1;
+	union c_fab_addr dfa;
+	__u64 remote_offset : 56;
+	__u8 unused_0;
+	__u64 local_addr : 57;
+	__u8: 7;
+	__u32 request_len;
+	__u16 ct : 11;
+	__u8: 5;
+	__u16 eq : 11;
+	__u8: 5;
+	__u32 eager_length : 20;
+	__u8: 4;
+	__u8 rendezvous_id;
+	__u32 initiator;
+	__u64 match_bits;
+	__u64 header_data;
+	__u64 user_ptr;
+};
+
+struct c_dma_amo_cmd {
+	struct c_cmd command;
+	__u8 index_ext : 5;
+	__u8: 3;
+	__u8 lac : 3;
+	__u8 event_send_disable : 1;
+	__u8 event_success_disable : 1;
+	__u8 event_ct_send : 1;
+	__u8 event_ct_reply : 1;
+	__u8 event_ct_ack : 1;
+	__u8 event_ct_bytes : 1;
+	__u8 get_with_local_flag : 1;
+	__u8 restricted : 1;
+	__u8 reduction : 1;
+	__u8 flush : 1;
+	__u8 use_offset_for_get : 1;
+	__u8: 1;
+	__u8: 1;
+	union c_fab_addr dfa;
+	__u64 remote_offset : 56;
+	__u8 unused_0;
+	__u64 local_read_addr : 57;
+	__u8: 7;
+	__u32 request_len;
+	__u16 ct : 11;
+	__u8: 5;
+	__u16 eq : 11;
+	__u8: 5;
+	__u32 unused_1;
+	__u32 initiator;
+	__u64 match_bits;
+	__u64 header_data;
+	__u64 user_ptr;
+	__u64 local_write_addr : 57;
+	__u8: 7;
+	__u8 atomic_op : 4;
+	__u8: 4;
+	__u8 atomic_type : 4;
+	__u8: 4;
+	__u8 cswap_op : 3;
+	__u8: 5;
+	__u8 unused_2;
+	__u8 write_lac : 3;
+	__u32: 29;
+	__u64 op2_word1;
+	__u64 op2_word2;
+};
+
+struct c_ct_cmd {
+	struct c_cmd command;
+	__u8 unused_0;
+	__u16 ct : 11;
+	__u8: 5;
+	__u16 trig_ct : 11;
+	__u8: 5;
+	__u16 eq : 11;
+	__u8: 5;
+	__u64 ct_success : 48;
+	__u8 ct_failure : 7;
+	__u16: 7;
+	__u8 set_ct_success : 1;
+	__u8 set_ct_failure : 1;
+	__u64 threshold : 48;
+	__u16 unused_1;
+	__u8 embedded_dma[];
+} __attribute__((packed));
+
+struct c_cq_cmd {
+	struct c_cmd command;
+	__u32: 24;
+	__u8 lcid : 4;
+	__u8: 4;
+	__u32: 24;
+	__u64 unused_0;
+	__u64 unused_1;
+	__u64 unused_2;
+	__u64 unused_3;
+	__u64 unused_4;
+	__u64 unused_5;
+	__u64 unused_6;
+};
+
+struct c_target_cmd {
+	struct c_cmd command;
+	__u8 ptl_list : 2;
+	__u8: 6;
+	__u16 ptlte_index : 11;
+	__u8: 5;
+	__u8 event_ct_bytes : 1;
+	__u8 event_ct_overflow : 1;
+	__u8 event_ct_comm : 1;
+	__u8 event_unlink_disable : 1;
+	__u8 event_success_disable : 1;
+	__u8 event_comm_disable : 1;
+	__u8 event_link_disable : 1;
+	__u8 unrestricted_end_ro : 1;
+	__u8 unrestricted_body_ro : 1;
+	__u8 unexpected_hdr_disable : 1;
+	__u8 use_once : 1;
+	__u8 no_truncate : 1;
+	__u8 manage_local : 1;
+	__u8 op_get : 1;
+	__u8 op_put : 1;
+	__u8: 1;
+	__u16 ct : 11;
+	__u8: 5;
+	__u16 buffer_id;
+	__u8 lac : 3;
+	__u8: 5;
+	__u8 restart_seq : 1;
+	__u8: 7;
+	__u32 unused_0;
+	__u64 start : 57;
+	__u8: 7;
+	__u64 length : 56;
+	__u8 unused_1;
+	__u32 min_free : 24;
+	__u8 unused_2;
+	__u32 match_id;
+	__u64 match_bits;
+	__u64 ignore_bits;
+	__u64 unused_3;
+};
+
+struct c_set_state_cmd {
+	struct c_cmd command;
+	__u8 ptlte_state : 3;
+	__u8: 5;
+	__u16 ptlte_index : 11;
+	__u8: 5;
+	__u32 unused_0;
+	__u64 current_addr : 57;
+	__u8: 7;
+	__u32 drop_count : 24;
+	__u8 unused_1;
+	__u32 unused_2;
+	__u64 unused_3;
+	__u64 unused_4;
+	__u64 unused_5;
+	__u64 unused_6;
+	__u64 unused_7;
+};
+
+struct c_eq_status {
+	__u32 timestamp_ns_cpy : 30;
+	__u64: 34;
+	__u64 timestamp_sec_cpy : 48;
+	__u8 thld_sts : 1;
+	__u8: 3;
+	__u8 thld_id : 2;
+	__u8: 2;
+	__u8 unackd_dropped_event : 1;
+	__u8: 3;
+	__u8 event_drop_seq_no : 1;
+	__u8: 3;
+	__u32 event_slots_free : 26;
+	__u8: 6;
+	__u32 event_slots_rsrvd : 26;
+	__u8: 6;
+	__u32 wr_ptr : 26;
+	__u8: 6;
+	__u8 using_buffer_b : 1;
+	__u32: 31;
+	__u64 unused_0;
+	__u64 unused_1;
+	__u32 unused_2;
+	__u32 timestamp_ns : 30;
+	__u8: 2;
+	__u64 timestamp_sec : 48;
+	__u16 unused_3;
+};
+
+struct c_event_initiator_short {
+	__u64 user_ptr;
+	__u32 mlength;
+	__u8 ptl_list : 2;
+	__u8: 2;
+	__u8 rendezvous : 1;
+	__u8 retry : 1;
+	__u8 tgt_error : 1;
+	__u16: 9;
+	__u8 event_size : 2;
+	__u8 event_type : 5;
+	__u8: 1;
+	__u8 return_code : 6;
+	__u8: 2;
+};
+
+struct c_event_initiator_long {
+	__u64 user_ptr;
+	__u32 mlength;
+	__u8 ptl_list : 2;
+	__u8: 2;
+	__u8 rendezvous : 1;
+	__u8 retry : 1;
+	__u8 tgt_error : 1;
+	__u16: 9;
+	__u8 event_size : 2;
+	__u8 event_type : 5;
+	__u8: 1;
+	__u8 unused_0;
+	__u32 timestamp_ns : 30;
+	__u64: 34;
+	__u64 timestamp_sec : 48;
+	__u8 unused_1;
+	__u8 return_code : 6;
+	__u8: 2;
+};
+
+struct c_event_trig_op_short {
+	__u64 threshold : 48;
+	__u16 unused_0;
+	__u16 ct_handle : 11;
+	__u64: 37;
+	__u8 event_size : 2;
+	__u8 event_type : 5;
+	__u8: 1;
+	__u8 return_code : 6;
+	__u8: 2;
+};
+
+struct c_event_trig_op_long {
+	__u64 threshold : 48;
+	__u16 unused_0;
+	__u16 ct_handle : 11;
+	__u64: 37;
+	__u8 event_size : 2;
+	__u8 event_type : 5;
+	__u8: 1;
+	__u8 unused_1;
+	__u32 timestamp_ns : 30;
+	__u64: 34;
+	__u64 timestamp_sec : 48;
+	__u8 unused_2;
+	__u8 return_code : 6;
+	__u8: 2;
+};
+
+struct c_event_cmd_fail {
+	__u16 cq_id : 10;
+	__u8 is_target : 1;
+	__u8: 5;
+	__u16 fail_loc;
+	struct c_cmd fail_command;
+	__u32: 24;
+	__u64: 48;
+	__u8 event_size : 2;
+	__u8 event_type : 5;
+	__u8: 1;
+	__u8 return_code : 6;
+	__u8: 2;
+};
+
+struct c_state_chg_fields {
+	__u8 ptlte_state : 3;
+	__u8: 5;
+	__u8 sc_reason : 4;
+	__u8: 4;
+	__u8 sc_nic_auto : 1;
+	__u16: 15;
+};
+
+union c_tgt_ol_initiator {
+	struct c_process initiator;
+	struct c_state_chg_fields state_change;
+};
+
+struct c_event_target_long {
+	__u64 header_data;
+	union c_tgt_ol_initiator initiator;
+	__u16 ptlte_index : 11;
+	__u8: 5;
+	__u8 event_size : 2;
+	__u8 event_type : 5;
+	__u8: 1;
+	__u8 ptl_list : 2;
+	__u8 rendezvous : 1;
+	__u8 get_issued : 1;
+	__u8 auto_unlinked : 1;
+	__u8: 3;
+	__u64 match_bits;
+	__u16 buffer_id;
+	__u16 vni;
+	__u32 timestamp_ns : 30;
+	__u8 timestamp_sec_low : 2;
+	__u32 mlength;
+	__u32 rlength;
+	__u64 remote_offset : 56;
+	__u8 unused_0;
+	__u64 start : 57;
+	__u8: 7;
+	__u16 lpe_stat_1;
+	__u16 lpe_stat_2;
+	__u8 atomic_type : 4;
+	__u8 atomic_op : 4;
+	__u8 cswap_op : 3;
+	__u8: 5;
+	__u8 rendezvous_id;
+	__u8 return_code : 6;
+	__u8: 2;
+};
+
+struct c_event_target_short {
+	__u64 header_data;
+	__u32 initiator;
+	__u16 ptlte_index : 11;
+	__u8: 5;
+	__u8 event_size : 2;
+	__u8 event_type : 5;
+	__u8: 1;
+	__u8 ptl_list : 2;
+	__u8: 2;
+	__u8 auto_unlinked : 1;
+	__u8: 3;
+	__u64 match_bits;
+	__u16 buffer_id;
+	__u16 vni;
+	__u32 length : 20;
+	__u8: 4;
+	__u8 return_code : 6;
+	__u8: 2;
+};
+
+struct c_event_target_enet {
+	__u16 checksum;
+	__u64 pkt_cnt : 46;
+	__u8 seg_cnt : 2;
+	__u32 rss_hash_value;
+	__u16 ptlte_index : 11;
+	__u8: 5;
+	__u8 event_size : 2;
+	__u8 event_type : 5;
+	__u8: 1;
+	__u8 ptl_list : 2;
+	__u8: 2;
+	__u8 auto_unlinked : 1;
+	__u8: 3;
+	__u64 start : 57;
+	__u8: 7;
+	__u16 buffer_id;
+	__u8 rss_hash_type : 5;
+	__u8: 3;
+	__u8 more_frags : 1;
+	__u8: 1;
+	__u8 is_roce : 1;
+	__u8 roce_icrc_ok : 1;
+	__u8 timestamp : 1;
+	__u8 fmt : 1;
+	__u8 parser_err : 1;
+	__u8: 1;
+	__u16 length;
+	__u8 unused_0;
+	__u8 return_code : 6;
+	__u8: 2;
+};
+
+struct c_event_enet_fgfc {
+	__u32 identifier;
+	__u32 unused_0;
+	__u8 fgfc_type : 2;
+	__u8: 6;
+	__u8 xoff : 1;
+	__u8: 7;
+	__u8 srcip_tag : 2;
+	__u8: 6;
+	__u8 unused_1;
+	__u16 credits;
+	__u8 event_size : 2;
+	__u8 event_type : 5;
+	__u8: 1;
+	__u8 return_code : 6;
+	__u8: 2;
+};
+
+struct c_event_pct {
+	union c_fab_addr dfa;
+	__u16 seq_num : 12;
+	__u8: 4;
+	__u16 unused_0;
+	__u8 pct_event_type : 3;
+	__u8: 5;
+	__u8 unused_1;
+	__u16 spt_idx : 11;
+	__u8: 5;
+	union c_conn_idx conn_idx;
+	__u8 event_size : 2;
+	__u8 event_type : 5;
+	__u8: 1;
+	__u8 return_code : 6;
+	__u8: 2;
+};
+
+struct c_event_timestamp {
+	__u32 timestamp_ns : 30;
+	__u64: 34;
+	__u64 timestamp_sec : 48;
+	__u8 event_size : 2;
+	__u8 event_type : 5;
+	__u8: 1;
+	__u8 return_code : 6;
+	__u8: 2;
+};
+
+struct c_event_eq_switch {
+	__u64 unused_0;
+	__u64: 48;
+	__u8 event_size : 2;
+	__u8 event_type : 5;
+	__u8: 1;
+	__u8 return_code : 6;
+	__u8: 2;
+};
+
+struct c_cq_cntrs {
+	__u64 success_tx_cntr;
+	__u64 success_tgt_cntr;
+	__u64 fail_tx_cntr;
+	__u64 fail_tgt_cntr;
+	__u64 mem_cor_err_cntr;
+	__u64 mem_ucor_err_cntr;
+	__u64 rarb_ll_err_cntr;
+	__u64 rarb_err_cntr;
+	__u64 wr_ptr_updt_err_cntr;
+	__u64 cntr0[3];
+	__u64 num_txq_cmd_reads[4];
+	__u64 num_tgq_cmd_reads[4];
+	__u64 num_tou_cmd_reads[4];
+	__u64 tx_waiting_on_read[4];
+	__u64 tgt_waiting_on_read[4];
+	__u64 num_tx_cmd_align_errors;
+	__u64 num_tx_cmd_op_errors;
+	__u64 num_tx_cmd_arg_errors;
+	__u64 num_tx_cmd_perm_errors;
+	__u64 num_tgt_cmd_arg_errors;
+	__u64 num_tgt_cmd_perm_errors;
+	__u64 cq_oxe_num_flits;
+	__u64 cq_oxe_num_stalls;
+	__u64 cq_oxe_num_idles;
+	__u64 cq_tou_num_flits;
+	__u64 cq_tou_num_stalls;
+	__u64 cq_tou_num_idles;
+	__u64 num_idc_cmds[4];
+	__u64 num_dma_cmds[4];
+	__u64 num_cq_cmds[4];
+	__u64 num_ll_cmds[4];
+	__u64 num_tgt_cmds[4];
+	__u64 dma_cmd_counts[16];
+	__u64 cq_cmd_counts[16];
+	__u64 cycles_blocked[4];
+	__u64 cntr2[12];
+	__u64 num_ll_ops_successful[4];
+	__u64 num_ll_ops_rejected[4];
+	__u64 num_ll_ops_split[4];
+	__u64 num_ll_ops_received[4];
+};
+
+struct c_tou_cntrs {
+	__u64 success_cntr;
+	__u64 fail_cntr;
+	__u64 cntr0[2];
+	__u64 cq_tou_num_cmds;
+	__u64 cq_tou_num_stalls;
+	__u64 tou_oxe_num_flits;
+	__u64 tou_oxe_num_stalls;
+	__u64 tou_oxe_num_idles;
+	__u64 list_rebuild_cycles;
+	__u64 cmd_fifo_full_cycles;
+	__u64 cntr1[7];
+	__u64 num_doorbell_writes;
+	__u64 num_ct_updates;
+	__u64 num_trig_cmds[4];
+	__u64 num_list_rebuilds[4];
+	__u64 ct_cmd_counts[16];
+	__u64 cntr2[20];
+};
+
+struct c1_oxe_cntrs {
+	__u64 mem_cor_err_cntr;
+	__u64 mem_ucor_err_cntr;
+	__u64 err_no_translation;
+	__u64 err_invalid_ac;
+	__u64 err_page_perm;
+	__u64 err_ta_error;
+	__u64 err_page_req;
+	__u64 err_pci_ep;
+	__u64 err_pci_cmpl;
+	__u64 rsvd0;
+	__u64 stall_pct_bc[10];
+	__u64 stall_pbuf_bc[10];
+	__u64 stall_ts_no_out_crd_tsc[10];
+	__u64 stall_ts_no_in_crd_tsc[10];
+	__u64 stall_with_no_pci_tag;
+	__u64 stall_with_no_atu_tag;
+	__u64 stall_stfwd_eop;
+	__u64 stall_pcie_scoreboard;
+	__u64 stall_wr_conflict_pkt_buff_bnk[4];
+	__u64 stall_idc_no_buff_bc[10];
+	__u64 stall_idc_cmd_no_deq;
+	__u64 stall_non_idc_cmd_no_deq;
+	__u64 stall_fgfc_blk[4];
+	__u64 stall_fgfc_cntrl[4];
+	__u64 stall_fgfc_start[4];
+	__u64 stall_fgfc_end[4];
+	__u64 stall_hdr_arb;
+	__u64 stall_ioi_last_ordered;
+	__u64 rsvd1[3];
+	__u64 ignore_errs;
+	__u64 ioi_dma;
+	__u64 ioi_pkts_ordered;
+	__u64 ioi_pkts_unordered;
+	__u64 ptl_tx_put_msgs_tsc[10];
+	__u64 ptl_tx_get_msgs_tsc[10];
+	__u64 ptl_tx_put_pkts_tsc[10];
+	__u64 ptl_tx_mr_msgs;
+	__u64 num_hrp_cmds;
+	__u64 channel_idle;
+	__u64 mcu_meas[96];
+	__u64 prf_set0_st_ready;
+	__u64 prf_set0_st_pct_idx_wait;
+	__u64 prf_set0_st_pktbuf_req;
+	__u64 prf_set0_st_pktbuf_gnt;
+	__u64 prf_set0_st_header;
+	__u64 prf_set0_st_dma_mdr;
+	__u64 prf_set0_st_dma_upd;
+	__u64 prf_set0_pktbuf_na;
+	__u64 prf_set0_spt_na;
+	__u64 prf_set0_smt_na;
+	__u64 prf_set0_srb_na;
+	__u64 prf_set0_ts_select;
+	__u64 prf_set0_occ_hist_bin0;
+	__u64 prf_set0_occ_hist_bin1;
+	__u64 prf_set0_occ_hist_bin2;
+	__u64 prf_set0_occ_hist_bin3;
+	__u64 prf_set1_st_ready;
+	__u64 prf_set1_st_pct_idx_wait;
+	__u64 prf_set1_st_pktbuf_req;
+	__u64 prf_set1_st_pktbuf_gnt;
+	__u64 prf_set1_st_header;
+	__u64 prf_set1_st_dma_mdr;
+	__u64 prf_set1_st_dma_upd;
+	__u64 prf_set1_pktbuf_na;
+	__u64 prf_set1_spt_na;
+	__u64 prf_set1_smt_na;
+	__u64 prf_set1_srb_na;
+	__u64 prf_set1_ts_select;
+	__u64 prf_set1_occ_hist_bin0;
+	__u64 prf_set1_occ_hist_bin1;
+	__u64 prf_set1_occ_hist_bin2;
+	__u64 prf_set1_occ_hist_bin3;
+};
+
+struct c2_oxe_cntrs {
+	__u64 mem_cor_err_cntr;
+	__u64 mem_ucor_err_cntr;
+	__u64 err_no_translation;
+	__u64 err_invalid_ac;
+	__u64 err_page_perm;
+	__u64 err_ta_error;
+	__u64 err_page_req;
+	__u64 err_pci_ep;
+	__u64 err_pci_cmpl;
+	__u64 rsvd0;
+	__u64 stall_pct_bc[10];
+	__u64 stall_pbuf_bc[10];
+	__u64 stall_ts_no_out_crd_tsc[10];
+	__u64 stall_ts_no_in_crd_tsc[10];
+	__u64 stall_with_no_pci_tag;
+	__u64 stall_with_no_atu_tag;
+	__u64 stall_stfwd_eop;
+	__u64 stall_pcie_scoreboard;
+	__u64 stall_wr_conflict_pkt_buff_bnk[4];
+	__u64 stall_idc_no_buff_bc[10];
+	__u64 stall_idc_cmd_no_deq;
+	__u64 stall_non_idc_cmd_no_deq;
+	__u64 stall_fgfc_blk[4];
+	__u64 stall_fgfc_cntrl[4];
+	__u64 stall_fgfc_start[4];
+	__u64 stall_fgfc_end[4];
+	__u64 stall_hdr_arb;
+	__u64 stall_ioi_last_ordered;
+	__u64 spt_cdt_errs;
+	__u64 smt_cdt_errs;
+	__u64 rsvd1;
+	__u64 ignore_errs;
+	__u64 ioi_dma;
+	__u64 ioi_pkts_ordered;
+	__u64 ioi_pkts_unordered;
+	__u64 ptl_tx_put_msgs_tsc[10];
+	__u64 ptl_tx_get_msgs_tsc[10];
+	__u64 ptl_tx_put_pkts_tsc[10];
+	__u64 ptl_tx_mr_msgs;
+	__u64 num_hrp_cmds;
+	__u64 channel_idle;
+	__u64 mcu_meas[96];
+	__u64 prf_set0_st_ready;
+	__u64 prf_set0_st_pct_idx_wait;
+	__u64 prf_set0_st_pktbuf_req;
+	__u64 prf_set0_st_pktbuf_gnt;
+	__u64 prf_set0_st_header;
+	__u64 prf_set0_st_dma_mdr;
+	__u64 prf_set0_st_dma_upd;
+	__u64 prf_set0_pktbuf_na;
+	__u64 prf_set0_spt_na;
+	__u64 prf_set0_smt_na;
+	__u64 prf_set0_srb_na;
+	__u64 prf_set0_ts_select;
+	__u64 prf_set0_occ_hist_bin0;
+	__u64 prf_set0_occ_hist_bin1;
+	__u64 prf_set0_occ_hist_bin2;
+	__u64 prf_set0_occ_hist_bin3;
+	__u64 prf_set1_st_ready;
+	__u64 prf_set1_st_pct_idx_wait;
+	__u64 prf_set1_st_pktbuf_req;
+	__u64 prf_set1_st_pktbuf_gnt;
+	__u64 prf_set1_st_header;
+	__u64 prf_set1_st_dma_mdr;
+	__u64 prf_set1_st_dma_upd;
+	__u64 prf_set1_pktbuf_na;
+	__u64 prf_set1_spt_na;
+	__u64 prf_set1_smt_na;
+	__u64 prf_set1_srb_na;
+	__u64 prf_set1_ts_select;
+	__u64 prf_set1_occ_hist_bin0;
+	__u64 prf_set1_occ_hist_bin1;
+	__u64 prf_set1_occ_hist_bin2;
+	__u64 prf_set1_occ_hist_bin3;
+};
+
+struct c_ixe_cntrs {
+	__u64 mem_cor_err_cntr;
+	__u64 mem_ucor_err_cntr;
+	__u64 cntr1[2];
+	__u64 port_dfa_mismatch;
+	__u64 hdr_checksum_errors;
+	__u64 ipv4_checksum_errors;
+	__u64 hrp_req_errors;
+	__u64 ip_options_errors;
+	__u64 get_len_errors;
+	__u64 roce_icrc_error;
+	__u64 parser_par_errors;
+	__u64 pbuf_rd_errors;
+	__u64 hdr_ecc_errors;
+	__u64 cntr2[2];
+	__u64 rx_udp_pkt;
+	__u64 rx_tcp_pkt;
+	__u64 rx_ipv4_pkt;
+	__u64 rx_ipv6_pkt;
+	__u64 rx_roce_pkt;
+	__u64 rx_ptl_gen_pkt;
+	__u64 rx_ptl_sml_pkt;
+	__u64 rx_ptl_unrestricted_pkt;
+	__u64 rx_ptl_smallmsg_pkt;
+	__u64 rx_ptl_continuation_pkt;
+	__u64 rx_ptl_restricted_pkt;
+	__u64 rx_ptl_connmgmt_pkt;
+	__u64 rx_ptl_response_pkt;
+	__u64 rx_unrecognized_pkt;
+	__u64 rx_ptl_sml_amo_pkt;
+	__u64 rx_ptl_msgs;
+	__u64 rx_ptl_multi_msgs;
+	__u64 rx_ptl_mr_msgs;
+	__u64 rx_pkt_drop_pct;
+	__u64 rx_pkt_drop_rmu_norsp;
+	__u64 rx_pkt_drop_rmu_wrsp;
+	__u64 rx_pkt_drop_ixe_parser;
+	__u64 rx_pkt_ipv4_options;
+	__u64 rx_pkt_ipv6_options;
+	__u64 rx_eth_seg;
+	__u64 rx_roce_seg;
+	__u64 rx_roce_spseg;
+	__u64 cntr3[21];
+	__u64 pool_ecn_pkts[4];
+	__u64 pool_no_ecn_pkts[4];
+	__u64 tc_req_ecn_pkts[8];
+	__u64 tc_req_no_ecn_pkts[8];
+	__u64 tc_rsp_ecn_pkts[8];
+	__u64 tc_rsp_no_ecn_pkts[8];
+	__u64 disp_lpe_puts;
+	__u64 disp_lpe_puts_ok;
+	__u64 disp_lpe_amos;
+	__u64 disp_lpe_amos_ok;
+	__u64 disp_mst_puts;
+	__u64 disp_mst_puts_ok;
+	__u64 disp_lpe_gets;
+	__u64 disp_lpe_gets_ok;
+	__u64 disp_mst_gets;
+	__u64 disp_mst_gets_ok;
+	__u64 disp_rpu_resps;
+	__u64 disp_rpu_err_reqs;
+	__u64 disp_dmawr_reqs;
+	__u64 disp_dmawr_resps;
+	__u64 disp_dmawr_resps_ok;
+	__u64 disp_oxe_resps;
+	__u64 disp_pct_getcomp;
+	__u64 disp_atu_reqs;
+	__u64 disp_atu_resps;
+	__u64 disp_atu_resps_ok;
+	__u64 disp_eth_events;
+	__u64 disp_put_events;
+	__u64 disp_amo_events;
+	__u64 disp_wr_conflicts;
+	__u64 disp_amo_conflicts;
+	__u64 disp_stall_conflict;
+	__u64 disp_stall_resp_fifo;
+	__u64 disp_stall_err_fifo;
+	__u64 disp_stall_atu_cdt;
+	__u64 disp_stall_atu_fifo;
+	__u64 disp_stall_gcomp_fifo;
+	__u64 disp_stall_mdid_cdts;
+	__u64 disp_stall_mst_match_fifo;
+	__u64 disp_stall_grr_id;
+	__u64 disp_stall_put_resp;
+	__u64 disp_atu_flush_reqs;
+	__u64 cntr4[4];
+	__u64 dmawr_stall_p_cdt;
+	__u64 dmawr_stall_np_cdt;
+	__u64 dmawr_stall_np_req_cnt;
+	__u64 dmawr_stall_ftch_amo_cnt;
+	__u64 dmawr_p_pass_np_cnt;
+	__u64 dmawr_write_reqs;
+	__u64 dmawr_nic_amo_reqs;
+	__u64 dmawr_cpu_amo_reqs;
+	__u64 dmawr_cpu_ftch_amo_reqs;
+	__u64 dmawr_flush_reqs;
+	__u64 dmawr_req_no_write_reqs;
+	__u64 dmawr_amo_ex_invalid;
+	__u64 dmawr_amo_ex_overflow;
+	__u64 dmawr_amo_ex_underflow;
+	__u64 dmawr_amo_ex_inexact;
+	__u64 dmawr_amo_misaligned;
+	__u64 dmawr_amo_invalid_op;
+	__u64 dmawr_amo_len_err;
+	__u64 dmawr_pcie_unsuccess_cmpl;
+	__u64 dmawr_pcie_err_poisoned;
+	__u64 cntr5[4];
+};
+
+struct c_pct_cntrs {
+	__u64 mem_cor_err_cntr;
+	__u64 mem_ucor_err_cntr;
+	__u64 req_ordered;
+	__u64 req_unordered;
+	__u64 req_no_response;
+	__u64 eth_packets;
+	__u64 optip_packets;
+	__u64 ptls_response;
+	__u64 responses_received;
+	__u64 hrp_responses_received;
+	__u64 hrp_rsp_discard_received;
+	__u64 hrp_rsp_err_received;
+	__u64 conn_sct_open;
+	__u64 conn_tct_open;
+	__u64 mst_hit_on_som;
+	__u64 trs_hit_on_req;
+	__u64 cls_req_miss_tct;
+	__u64 clear_sent;
+	__u64 close_sent;
+	__u64 accel_close;
+	__u64 clear_close_drop;
+	__u64 req_src_error;
+	__u64 bad_seq_nacks;
+	__u64 no_tct_nacks;
+	__u64 no_mst_nacks;
+	__u64 no_trs_nacks;
+	__u64 no_matching_tct;
+	__u64 resource_busy;
+	__u64 err_no_matching_trs;
+	__u64 err_no_matching_mst;
+	__u64 spt_timeouts;
+	__u64 sct_timeouts;
+	__u64 tct_timeouts;
+	__u64 retry_srb_requests;
+	__u64 retry_trs_put;
+	__u64 retry_mst_get;
+	__u64 clr_cls_stalls;
+	__u64 close_rsp_drops;
+	__u64 trs_rsp_nack_drops;
+	__u64 req_blocked_closing;
+	__u64 req_blocked_clearing;
+	__u64 req_blocked_retry;
+	__u64 rsp_err_rcvd;
+	__u64 rsp_dropped_timeout;
+	__u64 rsp_dropped_try;
+	__u64 rsp_dropped_cls_try;
+	__u64 rsp_dropped_inactive;
+	__u64 pct_hni_flits;
+	__u64 pct_hni_stalls;
+	__u64 pct_ee_events;
+	__u64 pct_ee_stalls;
+	__u64 pct_cq_notifications;
+	__u64 pct_cq_stalls;
+	__u64 pct_mst_cmd0;
+	__u64 pct_mst_stalls0;
+	__u64 pct_mst_cmd1;
+	__u64 pct_mst_stalls1;
+	__u64 sct_stall_state;
+	__u64 tgt_cls_abort;
+	__u64 cls_req_bad_seqno_drops;
+	__u64 req_tct_tmout_drops;
+	__u64 trs_replay_pend_drops;
+	__u64 cntr_rsvd_1[2];
+	__u64 req_rsp_latency[32];
+	__u64 host_access_latency[16];
+	__u64 cntr_rsvd_2[16];
+};
+
+struct c_rmu_cntrs {
+	__u64 ptl_success_cntr;
+	__u64 enet_success_cntr;
+	__u64 mem_cor_err_cntr;
+	__u64 mem_ucor_err_cntr;
+	__u64 ptl_invld_dfa_cntr;
+	__u64 ptl_invld_vni_cntr;
+	__u64 ptl_no_ptlte_cntr;
+	__u64 enet_frame_rejected_cntr;
+	__u64 enet_ptlte_set_ctrl_err_cntr;
+	__u64 cntr_rsvd[7];
+};
+
+struct c_lpe_cntrs {
+	__u64 success_cntr;
+	__u64 fail_cntr;
+	__u64 mem_cor_err_cntr;
+	__u64 mem_ucor_err_cntr;
+	__u64 cntr0;
+	__u64 put_cmds;
+	__u64 rendezvous_put_cmds;
+	__u64 get_cmds;
+	__u64 amo_cmds;
+	__u64 famo_cmds;
+	__u64 cntr1[5];
+	__u64 err_entry_not_found_ethernet;
+	__u64 err_pt_disabled_eq_full;
+	__u64 err_pt_disabled_req_empty;
+	__u64 err_pt_disabled_cant_alloc_unexpected;
+	__u64 err_pt_disabled_no_match_in_overflow;
+	__u64 err_eq_disabled;
+	__u64 err_op_violation;
+	__u64 err_entry_not_found_unlink_failed;
+	__u64 err_entry_not_found_eq_full;
+	__u64 err_entry_not_found_req_empty;
+	__u64 err_entry_not_found_no_match_in_overflow;
+	__u64 err_entry_not_found_cant_alloc_unexpected;
+	__u64 err_invalid_endpoint;
+	__u64 err_no_space_append;
+	__u64 err_no_space_net;
+	__u64 err_search_no_match;
+	__u64 err_setstate_no_match;
+	__u64 err_src_error;
+	__u64 err_ptlte_sw_managed;
+	__u64 err_illegal_op;
+	__u64 err_restricted_unicast;
+	__u64 cntr2[5];
+	__u64 event_put_overflow;
+	__u64 cntr3;
+	__u64 event_get_overflow;
+	__u64 cntr4;
+	__u64 event_atomic_overflow;
+	__u64 plec_frees_csr;
+	__u64 event_fetch_atomic_overflow;
+	__u64 event_search;
+	__u64 event_rendezvous;
+	__u64 event_link;
+	__u64 event_unlink;
+	__u64 event_statechange;
+	__u64 plec_allocs;
+	__u64 plec_frees;
+	__u64 plec_hits;
+	__u64 cyc_no_rdy_cdts;
+	__u64 cyc_rrq_blocked[4];
+	__u64 cyc_blocked_lossless;
+	__u64 cyc_blocked_ixe_put;
+	__u64 cyc_blocked_ixe_get;
+	__u64 search_cmds;
+	__u64 search_success;
+	__u64 search_fail;
+	__u64 search_delete_cmds;
+	__u64 search_delete_success;
+	__u64 search_delete_fail;
+	__u64 unlink_cmds;
+	__u64 unlink_success;
+	__u64 net_match_requests[4];
+	__u64 net_match_success[4];
+	__u64 net_match_useonce[4];
+	__u64 net_match_local[4];
+	__u64 net_match_priority[4];
+	__u64 net_match_overflow[4];
+	__u64 net_match_request[4];
+	__u64 append_cmds[4];
+	__u64 append_success[4];
+	__u64 setstate_cmds[4];
+	__u64 setstate_success[4];
+	__u64 search_nid_any[4];
+	__u64 search_pid_any[4];
+	__u64 search_rank_any[4];
+	__u64 rndzv_puts[4];
+	__u64 rndzv_puts_offloaded[4];
+	__u64 num_truncated[4];
+	__u64 unexpected_get_amo[4];
+	__u64 cntr_rsvd[16];
+};
+
+struct c_mst_cntrs {
+	__u64 mem_cor_err_cntr;
+	__u64 mem_ucor_err_cntr;
+	__u64 allocations;
+	__u64 requests;
+	__u64 stalled_waiting_for_lpe;
+	__u64 stalled_waiting_get_crdts;
+	__u64 stalled_waiting_put_crdts;
+	__u64 stalled_waiting_ee_crdts;
+	__u64 cntr1[8];
+	__u64 err_cancelled;
+	__u64 cntr2[15];
+};
+
+struct c_ee_cntrs {
+	__u64 events_enqueued_cntr[4];
+	__u64 events_dropped_rsrvn_cntr[4];
+	__u64 events_dropped_fc_sc_cntr[4];
+	__u64 events_dropped_ordinary_cntr[4];
+	__u64 eq_status_update_cntr[4];
+	__u64 cbs_written_cntr[4];
+	__u64 partial_cbs_written_cntr[4];
+	__u64 expired_cbs_written_cntr[4];
+	__u64 eq_buffer_switch_cntr[4];
+	__u64 deferred_eq_switch_cntr[4];
+	__u64 addr_trans_prefetch_cntr[4];
+	__u64 eq_sw_state_wr_cntr[4];
+	__u64 lpe_event_req_cntr;
+	__u64 lpe_fe_cntr;
+	__u64 lpe_dd_cntr;
+	__u64 lpe_ce_cntr;
+	__u64 lpe_fe_stall_cntr;
+	__u64 lpe_ce_stall_cntr;
+	__u64 ixe_event_req_cntr;
+	__u64 ixe_fe_cntr;
+	__u64 ixe_dd_cntr;
+	__u64 ixe_ce_cntr;
+	__u64 ixe_fe_stall_cntr;
+	__u64 ixe_ce_stall_cntr;
+	__u64 mst_event_req_cntr;
+	__u64 mst_fe_cntr;
+	__u64 mst_dd_cntr;
+	__u64 mst_ce_cntr;
+	__u64 mst_fe_stall_cntr;
+	__u64 mst_ce_stall_cntr;
+	__u64 pct_event_req_cntr;
+	__u64 pct_fe_cntr;
+	__u64 pct_dd_cntr;
+	__u64 pct_ce_cntr;
+	__u64 pct_fe_stall_cntr;
+	__u64 pct_ce_stall_cntr;
+	__u64 hni_event_req_cntr;
+	__u64 hni_fe_cntr;
+	__u64 hni_fe_stall_cntr;
+	__u64 cq_event_req_cntr;
+	__u64 cq_fe_cntr;
+	__u64 cq_fe_stall_cntr;
+	__u64 ts_fe_cntr;
+	__u64 ts_fe_stall_cntr;
+	__u64 fe_arb_out_event_cntr;
+	__u64 fe_arb_out_stall_cntr;
+	__u64 ce_arb_out_event_cntr;
+	__u64 ce_arb_out_stall_cntr;
+	__u64 lpe_query_eq_none_cntr;
+	__u64 eqs_lpe_query_req_cntr;
+	__u64 eqs_csr_req_cntr;
+	__u64 eqs_csr_stall_cntr;
+	__u64 eqs_hws_init_req_cntr;
+	__u64 eqs_hws_init_stall_cntr;
+	__u64 eqs_expired_cb_req_cntr;
+	__u64 eqs_expired_cb_stall_cntr;
+	__u64 eqs_sts_updt_req_cntr;
+	__u64 eqs_sts_updt_stall_cntr;
+	__u64 eqs_sws_wr_req_cntr;
+	__u64 eqs_sws_wr_stall_cntr;
+	__u64 eqs_event_req_cntr;
+	__u64 eqs_event_stall_cntr;
+	__u64 eqs_arb_out_req_cntr;
+	__u64 eqs_free_cb_stall_cntr;
+	__u64 addr_trans_req_cntr;
+	__u64 tarb_wr_req_cntr;
+	__u64 tarb_irq_req_cntr;
+	__u64 tarb_stall_cntr;
+	__u64 event_type_cntr[32];
+	__u64 mem_cor_err_cntr;
+	__u64 mem_ucor_err_cntr;
+	__u64 eq_dsabld_event_err_cntr;
+	__u64 eq_dsabld_sws_err_cntr;
+	__u64 eq_dsabld_lpeq_err_cntr;
+	__u64 eq_rsrvn_uflw_err_cntr;
+	__u64 unxpctd_trnsltn_rsp_err_cntr;
+	__u64 rarb_hw_err_cntr;
+	__u64 rarb_sw_err_cntr;
+	__u64 tarb_err_cntr;
+	__u64 eq_state_ucor_err_cntr;
+	__u64 cntr_rsvd[13];
+};
+
+struct c_atu_cntrs {
+	__u64 mem_cor_err_cntr;
+	__u64 mem_ucor_err_cntr;
+	__u64 cache_miss[4];
+	__u64 cache_hit_base_page_size[4];
+	__u64 cache_hit_derivative1_page_size[4];
+	__u64 cache_hit_derivative2_page_size[4];
+	__u64 cache_miss_oxe;
+	__u64 cache_miss_ixe;
+	__u64 cache_miss_ee;
+	__u64 ats_trans_latency[4];
+	__u64 nta_trans_latency[4];
+	__u64 client_req_oxe;
+	__u64 client_req_ixe;
+	__u64 client_req_ee;
+	__u64 filtered_requests;
+	__u64 ats_prs_odp_latency[4];
+	__u64 nic_pri_odp_latency[4];
+	__u64 odp_requests[4];
+	__u64 client_rsp_not_ok[4];
+	__u64 cache_evictions;
+	__u64 ats_inval_cntr;
+	__u64 implicit_flr_inval_cntr;
+	__u64 implicit_ats_en_inval_cntr;
+	__u64 atucq_inval_cntr;
+	__u64 pcie_unsuccess_cmpl;
+	__u64 ats_trans_err;
+	__u64 pcie_err_poisoned;
+	__u64 ats_dynamic_state_change_cntr;
+	__u64 at_stall_ccp;
+	__u64 at_stall_no_ptid;
+	__u64 at_stall_np_cdts;
+	__u64 at_stall_tarb_arb;
+	__u64 inval_stall_arb;
+	__u64 inval_stall_cmpl_wait;
+};
+
+struct c_parbs_cntrs {
+	__u64 tarb_cq_posted_pkts;
+	__u64 tarb_cq_non_posted_pkts;
+	__u64 tarb_cq_sbe_cnt;
+	__u64 tarb_cq_mbe_cnt;
+	__u64 tarb_ee_posted_pkts;
+	__u64 tarb_ee_sbe_cnt;
+	__u64 tarb_ee_mbe_cnt;
+	__u64 tarb_ixe_posted_pkts;
+	__u64 tarb_ixe_non_posted_pkts;
+	__u64 tarb_ixe_sbe_cnt;
+	__u64 tarb_ixe_mbe_cnt;
+	__u64 tarb_oxe_non_posted_pkts;
+	__u64 tarb_oxe_sbe_cnt;
+	__u64 tarb_oxe_mbe_cnt;
+	__u64 tarb_atu_posted_pkts;
+	__u64 tarb_atu_non_posted_pkts;
+	__u64 tarb_atu_sbe_cnt;
+	__u64 tarb_atu_mbe_cnt;
+	__u64 tarb_pi_posted_pkts;
+	__u64 tarb_pi_non_posted_pkts;
+	__u64 tarb_pi_posted_blocked_cnt;
+	__u64 tarb_pi_non_posted_blocked_cnt;
+	__u64 tarb_cq_posted_fifo_sbe;
+	__u64 tarb_cq_non_posted_fifo_sbe;
+	__u64 tarb_ee_posted_fifo_sbe;
+	__u64 tarb_ixe_posted_fifo_sbe;
+	__u64 tarb_ixe_non_posted_fifo_sbe;
+	__u64 tarb_oxe_non_posted_fifo_sbe;
+	__u64 tarb_atu_posted_fifo_sbe;
+	__u64 tarb_atu_non_posted_fifo_sbe;
+	__u64 tarb_cq_posted_fifo_mbe;
+	__u64 tarb_cq_non_posted_fifo_mbe;
+	__u64 tarb_ee_posted_fifo_mbe;
+	__u64 tarb_ixe_posted_fifo_mbe;
+	__u64 tarb_ixe_non_posted_fifo_mbe;
+	__u64 tarb_oxe_non_posted_fifo_mbe;
+	__u64 tarb_atu_posted_fifo_mbe;
+	__u64 tarb_atu_non_posted_fifo_mbe;
+	__u64 tarb_reserved_cnts[10];
+	__u64 rarb_pi_posted_pkts;
+	__u64 rarb_pi_completion_pkts;
+	__u64 rarb_pi_sbe_cnt;
+	__u64 rarb_pi_mbe_cnt;
+	__u64 rarb_cq_posted_pkts;
+	__u64 rarb_cq_completion_pkts;
+	__u64 rarb_ee_posted_pkts;
+	__u64 rarb_ixe_posted_pkts;
+	__u64 rarb_ixe_completion_pkts;
+	__u64 rarb_oxe_completion_pkts;
+	__u64 rarb_atu_posted_pkts;
+	__u64 rarb_atu_completion_pkts;
+	__u64 rarb_reserved_cnts[4];
+};
+
+struct c_pi_cntrs {
+	__u64 pri_mb_rtrgt_tlps;
+	__u64 pri_mb_rtrgt_mwr_tlps;
+	__u64 pri_mb_rtrgt_mrd_tlps;
+	__u64 pri_mb_rtrgt_tlp_discards;
+	__u64 pri_mb_rtrgt_posted_tlp_discards;
+	__u64 pri_mb_rtrgt_non_posted_tlp_discards;
+	__u64 pri_mb_rtrgt_posted_tlp_partial_discards;
+	__u64 pri_mb_rtrgt_fifo_cor_errors;
+	__u64 pri_mb_rtrgt_fifo_ucor_errors;
+	__u64 pri_mb_xali_cmpl_tlps;
+	__u64 pri_mb_xali_cmpl_ca_tlps;
+	__u64 pri_mb_xali_cmpl_ur_tlps;
+	__u64 pri_mb_axi_wr_requests;
+	__u64 pri_mb_axi_rd_requests;
+	__u64 pri_mb_axi_wr_rsp_decerrs;
+	__u64 pri_mb_axi_wr_rsp_slverrs;
+	__u64 pri_mb_axi_rd_rsp_decerrs;
+	__u64 pri_mb_axi_rd_rsp_slverrs;
+	__u64 pri_mb_axi_rd_rsp_parerrs;
+	__u64 pri_rarb_rtrgt_tlps;
+	__u64 pri_rarb_rtrgt_mwr_tlps;
+	__u64 pri_rarb_rtrgt_msg_tlps;
+	__u64 pri_rarb_rtrgt_msgd_tlps;
+	__u64 pri_rarb_rtrgt_tlp_discards;
+	__u64 pri_rarb_rtrgt_fifo_cor_errors;
+	__u64 pri_rarb_rtrgt_fifo_ucor_errors;
+	__u64 pri_rarb_rbyp_tlps;
+	__u64 pri_rarb_rbyp_tlp_discards;
+	__u64 pri_rarb_rbyp_fifo_cor_errors;
+	__u64 pri_rarb_rbyp_fifo_ucor_errors;
+	__u64 pri_rarb_sriovt_cor_errors;
+	__u64 pri_rarb_sriovt_ucor_errors;
+	__u64 pti_tarb_pkts;
+	__u64 pti_tarb_pkt_discards;
+	__u64 pti_tarb_rarb_ca_pkts;
+	__u64 pti_tarb_mwr_pkts;
+	__u64 pti_tarb_mrd_pkts;
+	__u64 pti_tarb_flush_pkts;
+	__u64 pti_tarb_irq_pkts;
+	__u64 pti_tarb_translation_pkts;
+	__u64 pti_tarb_inv_rsp_pkts;
+	__u64 pti_tarb_pg_req_pkts;
+	__u64 pti_tarb_amo_pkts;
+	__u64 pti_tarb_fetching_amo_pkts;
+	__u64 pti_tarb_hdr_cor_errors;
+	__u64 pti_tarb_hdr_ucor_errors;
+	__u64 pti_tarb_data_cor_errors;
+	__u64 pti_tarb_data_ucor_error;
+	__u64 pti_tarb_acxt_cor_errors;
+	__u64 pti_tarb_acxt_ucor_errors;
+	__u64 pti_tarb_reserved[5];
+	__u64 dmac_axi_rd_requests;
+	__u64 dmac_axi_rd_rsp_decerrs;
+	__u64 dmac_axi_rd_rsp_slverrs;
+	__u64 dmac_axi_rd_rsp_parerrs;
+	__u64 dmac_payload_mwr_tlps;
+	__u64 dmac_ce_mwr_tlps;
+	__u64 dmac_irqs;
+	__u64 dmac_desc_cor_errors;
+	__u64 dmac_desc_ucor_errors;
+};
+
+struct c_pi_ipd_cntrs {
+	__u64 pri_rtrgt_tlps;
+	__u64 pri_rtrgt_mwr_tlps;
+	__u64 pri_rtrgt_mrd_tlps;
+	__u64 pri_rtrgt_msg_tlps;
+	__u64 pri_rtrgt_msgd_tlps;
+	__u64 pri_rtrgt_tlps_aborted;
+	__u64 pri_rtrgt_blocked_on_mb;
+	__u64 pri_rtrgt_blocked_on_rarb;
+	__u64 pri_rtrgt_hdr_parity_errors;
+	__u64 pri_rtrgt_data_parity_errors;
+	__u64 pri_rbyp_tlps;
+	__u64 pri_rbyp_tlps_aborted;
+	__u64 pri_rbyp_hdr_parity_errors;
+	__u64 pri_rbyp_data_parity_errors;
+	__u64 pti_tarb_xali_posted_tlps;
+	__u64 pti_tarb_xali_non_posted_tlps;
+	__u64 pti_msixc_xali_posted_tlps;
+	__u64 pti_dbg_xali_posted_tlps;
+	__u64 pti_dbg_xali_non_posted_tlps;
+	__u64 pti_dmac_xali_posted_tlps;
+	__u64 pti_tarb_p_fifo_cor_errors;
+	__u64 pti_tarb_p_fifo_ucor_errors;
+	__u64 pti_tarb_np_fifo_cor_errors;
+	__u64 pti_tarb_np_fifo_ucor_errors;
+	__u64 pti_tarb_blocked_on_ph_crd;
+	__u64 pti_tarb_blocked_on_pd_crd;
+	__u64 pti_tarb_blocked_on_nph_crd;
+	__u64 pti_tarb_blocked_on_npd_crd;
+	__u64 pti_tarb_blocked_on_tag;
+	__u64 pti_dmac_blocked_on_ph_crd;
+	__u64 pti_dmac_blocked_on_pd_crd;
+	__u64 pti_msixc_blocked_on_ph_crd;
+	__u64 pti_msixc_blocked_on_pd_crd;
+	__u64 pti_dbg_blocked_on_ph_crd;
+	__u64 pti_dbg_blocked_on_pd_crd;
+	__u64 pti_dbg_blocked_on_nph_crd;
+	__u64 pti_dbg_blocked_on_tag;
+	__u64 pti_tarb_cmpl_to;
+	__u64 pti_tarb_cmpl_to_fifo_cor_errors;
+	__u64 pti_tarb_cmpl_to_fifo_ucor_errors;
+	__u64 msixc_oob_irqs_sent;
+	__u64 msixc_oob_legacy_irqs_sent;
+	__u64 msixc_oob_irqs_discarded;
+	__u64 msixc_oob_irq_pbas;
+	__u64 msixc_ib_irqs_sent;
+	__u64 msixc_ib_legacy_irqs_sent;
+	__u64 msixc_ib_irqs_discarded;
+	__u64 msixc_ib_irq_pbas;
+	__u64 msixc_pba_cor_errors;
+	__u64 msixc_pba_ucor_errors;
+	__u64 msixc_table_cor_errors;
+	__u64 msixc_table_ucor_errors;
+	__u64 pti_msixc_fifo_cor_errors;
+	__u64 pti_msixc_fifo_ucor_errors;
+	__u64 msixc_pti_fifo_cor_errors;
+	__u64 msixc_pti_fifo_ucor_errors;
+	__u64 dmac_p_fifo_cor_errors;
+	__u64 dmac_p_fifo_ucor_errors;
+	__u64 dbic_dbi_requests;
+	__u64 dbic_dbi_acks;
+	__u64 ipd_trigger_events[2];
+	__u64 ipd_cnts_reserved[66];
+};
+
+struct c_mb_cntrs {
+	__u64 crmc_ring_sbe[3];
+	__u64 crmc_ring_mbe[3];
+	__u64 crmc_wr_error[3];
+	__u64 crmc_axi_wr_requests[3];
+	__u64 crmc_ring_wr_requests[3];
+	__u64 crmc_rd_error[3];
+	__u64 crmc_axi_rd_requests[3];
+	__u64 crmc_ring_rd_requests[3];
+	__u64 jai_axi_wr_requests;
+	__u64 jai_axi_rd_requests;
+	__u64 mb_lsa0_trigger_events[2];
+	__u64 ixe_lsa0_trigger_events[2];
+	__u64 cq_lsa0_trigger_events[2];
+	__u64 ee_lsa0_trigger_events[2];
+	__u64 mb_lsa1_trigger_events[2];
+	__u64 ixe_lsa1_trigger_events[2];
+	__u64 cq_lsa1_trigger_events[2];
+	__u64 ee_lsa1_trigger_events[2];
+	__u64 cmc_axi_wr_requests[4];
+	__u64 cmc_axi_rd_requests[4];
+	__u64 mb_todo_cntrs[14];
+};
+
+#ifdef __LITTLE_ENDIAN
+struct c_port_fab_hdr {
+	__u8 ihl : 4;
+	__u8 ver : 4;
+	__u8 ecn : 2;
+	__u8 dscp : 6;
+	__u16 tl;
+	__u16 vni;
+	__u8 spt_idx_hi : 6;
+	__u8: 2;
+	__u8 try_ : 3;
+	__u8 spt_idx_low : 5;
+	__u8 ttl;
+	__u8 protocol;
+	__u16 hdr_chksum;
+	union c_fab_addr sfa;
+	union c_fab_addr dfa;
+} __attribute__((packed));
+#else
+struct c_port_fab_hdr {
+	__u8 ver : 4;
+	__u8 ihl : 4;
+	__u8 dscp : 6;
+	__u8 ecn : 2;
+	__u16 tl;
+	__u16 vni;
+	__u8: 2;
+	__u16 spt_idx : 11;
+	__u8 try_ : 3;
+	__u8 ttl;
+	__u8 protocol;
+	__u16 hdr_chksum;
+	union c_fab_addr sfa;
+	union c_fab_addr dfa;
+} __attribute__((packed));
+#endif
+
+static inline void c_port_fab_hdr_set_tl(struct c_port_fab_hdr *p, __u16 tl)
+{
+	p->tl = cpu_to_be16(tl);
+}
+
+static inline __u16 c_port_fab_hdr_get_tl(const struct c_port_fab_hdr *p)
+{
+	return be16_to_cpu(p->tl);
+}
+
+static inline void c_port_fab_hdr_set_vni(struct c_port_fab_hdr *p, __u16 vni)
+{
+	p->vni = cpu_to_be16(vni);
+}
+
+static inline __u16 c_port_fab_hdr_get_vni(const struct c_port_fab_hdr *p)
+{
+	return be16_to_cpu(p->vni);
+}
+
+static inline void c_port_fab_hdr_set_spt_idx(struct c_port_fab_hdr *p, __u16 spt_idx)
+{
+#ifdef __LITTLE_ENDIAN
+	p->spt_idx_low = spt_idx;
+	p->spt_idx_hi = spt_idx >> 5;
+#else
+	p->spt_idx = spt_idx;
+#endif
+}
+
+static inline __u16 c_port_fab_hdr_get_spt_idx(const struct c_port_fab_hdr *p)
+{
+#ifdef __LITTLE_ENDIAN
+	return (__u16)p->spt_idx_low | (__u16)p->spt_idx_hi << 5;
+#else
+	return p->spt_idx;
+#endif
+}
+
+static inline void c_port_fab_hdr_set_hdr_chksum(struct c_port_fab_hdr *p, __u16 hdr_chksum)
+{
+	p->hdr_chksum = cpu_to_be16(hdr_chksum);
+}
+
+static inline __u16 c_port_fab_hdr_get_hdr_chksum(const struct c_port_fab_hdr *p)
+{
+	return be16_to_cpu(p->hdr_chksum);
+}
+
+#ifdef __LITTLE_ENDIAN
+struct c_port_fab_vs_hdr {
+	__u8 dscp_hi : 4;
+	__u8 ver : 4;
+	__u8: 2;
+	__u8: 4;
+	__u8 dscp_low : 2;
+	__u8 spt_idx_hi;
+	__u8: 2;
+	__u8 try_ : 3;
+	__u8 spt_idx_low : 3;
+	__u16 vni;
+	union c_fab_addr sfa;
+	union c_fab_addr dfa;
+} __attribute__((packed));
+#else
+struct c_port_fab_vs_hdr {
+	__u8 ver : 4;
+	__u16 dscp : 6;
+	__u8: 4;
+	__u8: 2;
+	__u16 spt_idx : 11;
+	__u8 try_ : 3;
+	__u8: 2;
+	__u16 vni;
+	union c_fab_addr sfa;
+	union c_fab_addr dfa;
+} __attribute__((packed));
+#endif
+
+static inline void c_port_fab_vs_hdr_set_dscp(struct c_port_fab_vs_hdr *p, __u8 dscp)
+{
+#ifdef __LITTLE_ENDIAN
+	p->dscp_low = dscp;
+	p->dscp_hi = dscp >> 2;
+#else
+	p->dscp = dscp;
+#endif
+}
+
+static inline __u8 c_port_fab_vs_hdr_get_dscp(const struct c_port_fab_vs_hdr *p)
+{
+#ifdef __LITTLE_ENDIAN
+	return (__u8)p->dscp_low | (__u8)p->dscp_hi << 2;
+#else
+	return p->dscp;
+#endif
+}
+
+static inline void c_port_fab_vs_hdr_set_spt_idx(struct c_port_fab_vs_hdr *p, __u16 spt_idx)
+{
+#ifdef __LITTLE_ENDIAN
+	p->spt_idx_low = spt_idx;
+	p->spt_idx_hi = spt_idx >> 3;
+#else
+	p->spt_idx = spt_idx;
+#endif
+}
+
+static inline __u16 c_port_fab_vs_hdr_get_spt_idx(const struct c_port_fab_vs_hdr *p)
+{
+#ifdef __LITTLE_ENDIAN
+	return (__u16)p->spt_idx_low | (__u16)p->spt_idx_hi << 3;
+#else
+	return p->spt_idx;
+#endif
+}
+
+static inline void c_port_fab_vs_hdr_set_vni(struct c_port_fab_vs_hdr *p, __u16 vni)
+{
+	p->vni = cpu_to_be16(vni);
+}
+
+static inline __u16 c_port_fab_vs_hdr_get_vni(const struct c_port_fab_vs_hdr *p)
+{
+	return be16_to_cpu(p->vni);
+}
+
+#ifdef __LITTLE_ENDIAN
+struct c_port_unrestricted_hdr {
+	__u8 opcode : 4;
+	__u8 ver_pkt_type : 3;
+	__u8 req_not_rsp : 1;
+	__u8 index_ext : 5;
+	__u8 pktid_ext : 2;
+	__u8 flush : 1;
+	__u64 remote_offset : 56;
+	__u8 msg_id;
+	__u8 seq_num_hi;
+	__u8 clr_seq_num_hi : 4;
+	__u8 seq_num_low : 4;
+	__u8 clr_seq_num_low;
+	__u8 sct_idx_hi;
+	__u8 rendezvous_id_hi : 4;
+	__u8 sct_idx_low : 4;
+	__u8: 2;
+	__u8 use_offset_for_get : 1;
+	__u8 src_error : 1;
+	__u8 rendezvous_id_low : 4;
+	__u32 request_len;
+	__u32 initiator;
+	__u64 match_bits;
+	__u64 header_data;
+	__u8 eg_len_hi;
+	__u8 eg_len_mid;
+	__u8: 4;
+	__u8 eg_len_low : 4;
+} __attribute__((packed));
+#else
+struct c_port_unrestricted_hdr {
+	__u8 req_not_rsp : 1;
+	__u8 ver_pkt_type : 3;
+	__u8 opcode : 4;
+	__u8 flush : 1;
+	__u8 pktid_ext : 2;
+	__u8 index_ext : 5;
+	__u64 remote_offset : 56;
+	__u8 msg_id;
+	__u16 seq_num : 12;
+	__u16 clr_seq_num : 12;
+	__u16 sct_idx : 12;
+	__u16 rendezvous_id : 8;
+	__u8 src_error : 1;
+	__u8 use_offset_for_get : 1;
+	__u8: 2;
+	__u32 request_len;
+	__u32 initiator;
+	__u64 match_bits;
+	__u64 header_data;
+	__u32 eg_len : 20;
+	__u8: 4;
+} __attribute__((packed));
+#endif
+
+static inline void c_port_unrestricted_hdr_set_remote_offset(struct c_port_unrestricted_hdr *p,
+							     __u64 remote_offset)
+{
+	p->remote_offset = cpu_to_be64(remote_offset << 8);
+}
+
+static inline __u64
+c_port_unrestricted_hdr_get_remote_offset(const struct c_port_unrestricted_hdr *p)
+{
+	return be64_to_cpu(p->remote_offset) >> 8;
+}
+
+static inline void c_port_unrestricted_hdr_set_seq_num(struct c_port_unrestricted_hdr *p,
+						       __u16 seq_num)
+{
+#ifdef __LITTLE_ENDIAN
+	p->seq_num_low = seq_num;
+	p->seq_num_hi = seq_num >> 4;
+#else
+	p->seq_num = seq_num;
+#endif
+}
+
+static inline __u16 c_port_unrestricted_hdr_get_seq_num(const struct c_port_unrestricted_hdr *p)
+{
+#ifdef __LITTLE_ENDIAN
+	return (__u16)p->seq_num_low | (__u16)p->seq_num_hi << 4;
+#else
+	return p->seq_num;
+#endif
+}
+
+static inline void c_port_unrestricted_hdr_set_clr_seq_num(struct c_port_unrestricted_hdr *p,
+							   __u16 clr_seq_num)
+{
+#ifdef __LITTLE_ENDIAN
+	p->clr_seq_num_low = clr_seq_num;
+	p->clr_seq_num_hi = clr_seq_num >> 8;
+#else
+	p->clr_seq_num = clr_seq_num;
+#endif
+}
+
+static inline __u16 c_port_unrestricted_hdr_get_clr_seq_num(const struct c_port_unrestricted_hdr *p)
+{
+#ifdef __LITTLE_ENDIAN
+	return (__u16)p->clr_seq_num_low | (__u16)p->clr_seq_num_hi << 8;
+#else
+	return p->clr_seq_num;
+#endif
+}
+
+static inline void c_port_unrestricted_hdr_set_sct_idx(struct c_port_unrestricted_hdr *p,
+						       __u16 sct_idx)
+{
+#ifdef __LITTLE_ENDIAN
+	p->sct_idx_low = sct_idx;
+	p->sct_idx_hi = sct_idx >> 4;
+#else
+	p->sct_idx = sct_idx;
+#endif
+}
+
+static inline __u16 c_port_unrestricted_hdr_get_sct_idx(const struct c_port_unrestricted_hdr *p)
+{
+#ifdef __LITTLE_ENDIAN
+	return (__u16)p->sct_idx_low | (__u16)p->sct_idx_hi << 4;
+#else
+	return p->sct_idx;
+#endif
+}
+
+static inline void c_port_unrestricted_hdr_set_rendezvous_id(struct c_port_unrestricted_hdr *p,
+							     __u8 rendezvous_id)
+{
+#ifdef __LITTLE_ENDIAN
+	p->rendezvous_id_low = rendezvous_id;
+	p->rendezvous_id_hi = rendezvous_id >> 4;
+#else
+	p->rendezvous_id = rendezvous_id;
+#endif
+}
+
+static inline __u8
+c_port_unrestricted_hdr_get_rendezvous_id(const struct c_port_unrestricted_hdr *p)
+{
+#ifdef __LITTLE_ENDIAN
+	return (__u8)p->rendezvous_id_low | (__u8)p->rendezvous_id_hi << 4;
+#else
+	return p->rendezvous_id;
+#endif
+}
+
+static inline void c_port_unrestricted_hdr_set_request_len(struct c_port_unrestricted_hdr *p,
+							   __u32 request_len)
+{
+	p->request_len = cpu_to_be32(request_len);
+}
+
+static inline __u32 c_port_unrestricted_hdr_get_request_len(const struct c_port_unrestricted_hdr *p)
+{
+	return be32_to_cpu(p->request_len);
+}
+
+static inline void c_port_unrestricted_hdr_set_initiator(struct c_port_unrestricted_hdr *p,
+							 __u32 initiator)
+{
+	p->initiator = cpu_to_be32(initiator);
+}
+
+static inline __u32 c_port_unrestricted_hdr_get_initiator(const struct c_port_unrestricted_hdr *p)
+{
+	return be32_to_cpu(p->initiator);
+}
+
+static inline void c_port_unrestricted_hdr_set_match_bits(struct c_port_unrestricted_hdr *p,
+							  __u64 match_bits)
+{
+	p->match_bits = cpu_to_be64(match_bits);
+}
+
+static inline __u64 c_port_unrestricted_hdr_get_match_bits(const struct c_port_unrestricted_hdr *p)
+{
+	return be64_to_cpu(p->match_bits);
+}
+
+static inline void c_port_unrestricted_hdr_set_header_data(struct c_port_unrestricted_hdr *p,
+							   __u64 header_data)
+{
+	p->header_data = cpu_to_be64(header_data);
+}
+
+static inline __u64 c_port_unrestricted_hdr_get_header_data(const struct c_port_unrestricted_hdr *p)
+{
+	return be64_to_cpu(p->header_data);
+}
+
+static inline void c_port_unrestricted_hdr_set_eg_len(struct c_port_unrestricted_hdr *p,
+						      __u32 eg_len)
+{
+#ifdef __LITTLE_ENDIAN
+	p->eg_len_low = eg_len;
+	p->eg_len_mid = eg_len >> 4;
+	p->eg_len_hi = eg_len >> 12;
+#else
+	p->eg_len = eg_len;
+#endif
+}
+
+static inline __u32 c_port_unrestricted_hdr_get_eg_len(const struct c_port_unrestricted_hdr *p)
+{
+#ifdef __LITTLE_ENDIAN
+	return (__u32)p->eg_len_low | (__u32)p->eg_len_mid << 4 | (__u32)p->eg_len_hi << 12;
+#else
+	return p->eg_len;
+#endif
+}
+
+#ifdef __LITTLE_ENDIAN
+struct c_port_small_msg_hdr {
+	__u8 opcode : 4;
+	__u8 ver_pkt_type : 3;
+	__u8 req_not_rsp : 1;
+	__u8 index_ext : 5;
+	__u8 pktid_ext : 2;
+	__u8 flush : 1;
+	__u64 header_data : 64;
+	__u8 seq_num_hi;
+	__u8 clr_seq_num_hi : 4;
+	__u8 seq_num_low : 4;
+	__u8 clr_seq_num_low;
+	__u8 sct_idx_hi;
+	__u8 request_len_hi : 4;
+	__u8 sct_idx_low : 4;
+	__u8 request_len_low;
+	__u32 initiator;
+	__u64 match_bits : 64;
+	__u8: 7;
+	__u8 src_error : 1;
+} __attribute__((packed));
+#else
+struct c_port_small_msg_hdr {
+	__u8 req_not_rsp : 1;
+	__u8 ver_pkt_type : 3;
+	__u8 opcode : 4;
+	__u8 flush : 1;
+	__u8 pktid_ext : 2;
+	__u8 index_ext : 5;
+	__u64 header_data : 64;
+	__u16 seq_num : 12;
+	__u16 clr_seq_num : 12;
+	__u16 sct_idx : 12;
+	__u16 request_len : 12;
+	__u32 initiator;
+	__u64 match_bits : 64;
+	__u8 src_error : 1;
+	__u8: 7;
+} __attribute__((packed));
+#endif
+
+static inline void c_port_small_msg_hdr_set_header_data(struct c_port_small_msg_hdr *p,
+							__u64 header_data)
+{
+	p->header_data = cpu_to_be64(header_data);
+}
+
+static inline __u64 c_port_small_msg_hdr_get_header_data(const struct c_port_small_msg_hdr *p)
+{
+	return be64_to_cpu(p->header_data);
+}
+
+static inline void c_port_small_msg_hdr_set_seq_num(struct c_port_small_msg_hdr *p, __u16 seq_num)
+{
+#ifdef __LITTLE_ENDIAN
+	p->seq_num_low = seq_num;
+	p->seq_num_hi = seq_num >> 4;
+#else
+	p->seq_num = seq_num;
+#endif
+}
+
+static inline __u16 c_port_small_msg_hdr_get_seq_num(const struct c_port_small_msg_hdr *p)
+{
+#ifdef __LITTLE_ENDIAN
+	return (__u16)p->seq_num_low | (__u16)p->seq_num_hi << 4;
+#else
+	return p->seq_num;
+#endif
+}
+
+static inline void c_port_small_msg_hdr_set_clr_seq_num(struct c_port_small_msg_hdr *p,
+							__u16 clr_seq_num)
+{
+#ifdef __LITTLE_ENDIAN
+	p->clr_seq_num_low = clr_seq_num;
+	p->clr_seq_num_hi = clr_seq_num >> 8;
+#else
+	p->clr_seq_num = clr_seq_num;
+#endif
+}
+
+static inline __u16 c_port_small_msg_hdr_get_clr_seq_num(const struct c_port_small_msg_hdr *p)
+{
+#ifdef __LITTLE_ENDIAN
+	return (__u16)p->clr_seq_num_low | (__u16)p->clr_seq_num_hi << 8;
+#else
+	return p->clr_seq_num;
+#endif
+}
+
+static inline void c_port_small_msg_hdr_set_sct_idx(struct c_port_small_msg_hdr *p, __u16 sct_idx)
+{
+#ifdef __LITTLE_ENDIAN
+	p->sct_idx_low = sct_idx;
+	p->sct_idx_hi = sct_idx >> 4;
+#else
+	p->sct_idx = sct_idx;
+#endif
+}
+
+static inline __u16 c_port_small_msg_hdr_get_sct_idx(const struct c_port_small_msg_hdr *p)
+{
+#ifdef __LITTLE_ENDIAN
+	return (__u16)p->sct_idx_low | (__u16)p->sct_idx_hi << 4;
+#else
+	return p->sct_idx;
+#endif
+}
+
+static inline void c_port_small_msg_hdr_set_request_len(struct c_port_small_msg_hdr *p,
+							__u16 request_len)
+{
+#ifdef __LITTLE_ENDIAN
+	p->request_len_low = request_len;
+	p->request_len_hi = request_len >> 8;
+#else
+	p->request_len = request_len;
+#endif
+}
+
+static inline __u16 c_port_small_msg_hdr_get_request_len(const struct c_port_small_msg_hdr *p)
+{
+#ifdef __LITTLE_ENDIAN
+	return (__u16)p->request_len_low | (__u16)p->request_len_hi << 8;
+#else
+	return p->request_len;
+#endif
+}
+
+static inline void c_port_small_msg_hdr_set_initiator(struct c_port_small_msg_hdr *p,
+						      __u32 initiator)
+{
+	p->initiator = cpu_to_be32(initiator);
+}
+
+static inline __u32 c_port_small_msg_hdr_get_initiator(const struct c_port_small_msg_hdr *p)
+{
+	return be32_to_cpu(p->initiator);
+}
+
+static inline void c_port_small_msg_hdr_set_match_bits(struct c_port_small_msg_hdr *p,
+						       __u64 match_bits)
+{
+	p->match_bits = cpu_to_be64(match_bits);
+}
+
+static inline __u64 c_port_small_msg_hdr_get_match_bits(const struct c_port_small_msg_hdr *p)
+{
+	return be64_to_cpu(p->match_bits);
+}
+
+#ifdef __LITTLE_ENDIAN
+struct c_port_continuation_hdr {
+	__u8 opcode : 4;
+	__u8 ver_pkt_type : 3;
+	__u8 req_not_rsp : 1;
+	__u8: 2;
+	__u8 src_error : 1;
+	__u8 pkt_ordered : 1;
+	__u8 eom : 1;
+	__u8 pktid_ext : 2;
+	__u8 flush : 1;
+	__u32 offset : 32;
+	__u8 msg_id;
+	__u8 seq_num_hi;
+	__u8 clr_seq_num_hi : 4;
+	__u8 seq_num_low : 4;
+	__u8 clr_seq_num_low;
+	__u8 sct_idx_hi;
+	__u8 pkt_xfer_len_hi : 4;
+	__u8 sct_idx_low : 4;
+	__u8 pkt_xfer_len_low;
+} __attribute__((packed));
+#else
+struct c_port_continuation_hdr {
+	__u8 req_not_rsp : 1;
+	__u8 ver_pkt_type : 3;
+	__u8 opcode : 4;
+	__u8 flush : 1;
+	__u8 pktid_ext : 2;
+	__u8 eom : 1;
+	__u8 pkt_ordered : 1;
+	__u8 src_error : 1;
+	__u8: 2;
+	__u32 offset : 32;
+	__u8 msg_id;
+	__u16 seq_num : 12;
+	__u16 clr_seq_num : 12;
+	__u16 sct_idx : 12;
+	__u16 pkt_xfer_len : 12;
+} __attribute__((packed));
+#endif
+
+static inline void c_port_continuation_hdr_set_offset(struct c_port_continuation_hdr *p,
+						      __u32 offset)
+{
+	p->offset = cpu_to_be32(offset);
+}
+
+static inline __u32 c_port_continuation_hdr_get_offset(const struct c_port_continuation_hdr *p)
+{
+	return be32_to_cpu(p->offset);
+}
+
+static inline void c_port_continuation_hdr_set_seq_num(struct c_port_continuation_hdr *p,
+						       __u16 seq_num)
+{
+#ifdef __LITTLE_ENDIAN
+	p->seq_num_low = seq_num;
+	p->seq_num_hi = seq_num >> 4;
+#else
+	p->seq_num = seq_num;
+#endif
+}
+
+static inline __u16 c_port_continuation_hdr_get_seq_num(const struct c_port_continuation_hdr *p)
+{
+#ifdef __LITTLE_ENDIAN
+	return (__u16)p->seq_num_low | (__u16)p->seq_num_hi << 4;
+#else
+	return p->seq_num;
+#endif
+}
+
+static inline void c_port_continuation_hdr_set_clr_seq_num(struct c_port_continuation_hdr *p,
+							   __u16 clr_seq_num)
+{
+#ifdef __LITTLE_ENDIAN
+	p->clr_seq_num_low = clr_seq_num;
+	p->clr_seq_num_hi = clr_seq_num >> 8;
+#else
+	p->clr_seq_num = clr_seq_num;
+#endif
+}
+
+static inline __u16 c_port_continuation_hdr_get_clr_seq_num(const struct c_port_continuation_hdr *p)
+{
+#ifdef __LITTLE_ENDIAN
+	return (__u16)p->clr_seq_num_low | (__u16)p->clr_seq_num_hi << 8;
+#else
+	return p->clr_seq_num;
+#endif
+}
+
+static inline void c_port_continuation_hdr_set_sct_idx(struct c_port_continuation_hdr *p,
+						       __u16 sct_idx)
+{
+#ifdef __LITTLE_ENDIAN
+	p->sct_idx_low = sct_idx;
+	p->sct_idx_hi = sct_idx >> 4;
+#else
+	p->sct_idx = sct_idx;
+#endif
+}
+
+static inline __u16 c_port_continuation_hdr_get_sct_idx(const struct c_port_continuation_hdr *p)
+{
+#ifdef __LITTLE_ENDIAN
+	return (__u16)p->sct_idx_low | (__u16)p->sct_idx_hi << 4;
+#else
+	return p->sct_idx;
+#endif
+}
+
+static inline void c_port_continuation_hdr_set_pkt_xfer_len(struct c_port_continuation_hdr *p,
+							    __u16 pkt_xfer_len)
+{
+#ifdef __LITTLE_ENDIAN
+	p->pkt_xfer_len_low = pkt_xfer_len;
+	p->pkt_xfer_len_hi = pkt_xfer_len >> 8;
+#else
+	p->pkt_xfer_len = pkt_xfer_len;
+#endif
+}
+
+static inline __u16
+c_port_continuation_hdr_get_pkt_xfer_len(const struct c_port_continuation_hdr *p)
+{
+#ifdef __LITTLE_ENDIAN
+	return (__u16)p->pkt_xfer_len_low | (__u16)p->pkt_xfer_len_hi << 8;
+#else
+	return p->pkt_xfer_len;
+#endif
+}
+
+#ifdef __LITTLE_ENDIAN
+struct c_port_restricted_hdr {
+	__u8 opcode : 4;
+	__u8 ver_pkt_type : 3;
+	__u8 req_not_rsp : 1;
+	__u8 index_ext : 5;
+	__u8 pktid_ext : 2;
+	__u8 flush : 1;
+	__u64 remote_offset : 56;
+	__u8 request_len_hi : 4;
+	__u8 src_error : 1;
+	__u8: 3;
+	__u8 request_len_low;
+} __attribute__((packed));
+#else
+struct c_port_restricted_hdr {
+	__u8 req_not_rsp : 1;
+	__u8 ver_pkt_type : 3;
+	__u8 opcode : 4;
+	__u8 flush : 1;
+	__u8 pktid_ext : 2;
+	__u8 index_ext : 5;
+	__u64 remote_offset : 56;
+	__u8: 3;
+	__u8 src_error : 1;
+	__u16 request_len : 12;
+} __attribute__((packed));
+#endif
+
+static inline void c_port_restricted_hdr_set_remote_offset(struct c_port_restricted_hdr *p,
+							   __u64 remote_offset)
+{
+	p->remote_offset = cpu_to_be64(remote_offset << 8);
+}
+
+static inline __u64 c_port_restricted_hdr_get_remote_offset(const struct c_port_restricted_hdr *p)
+{
+	return be64_to_cpu(p->remote_offset) >> 8;
+}
+
+static inline void c_port_restricted_hdr_set_request_len(struct c_port_restricted_hdr *p,
+							 __u16 request_len)
+{
+#ifdef __LITTLE_ENDIAN
+	p->request_len_low = request_len;
+	p->request_len_hi = request_len >> 8;
+#else
+	p->request_len = request_len;
+#endif
+}
+
+static inline __u16 c_port_restricted_hdr_get_request_len(const struct c_port_restricted_hdr *p)
+{
+#ifdef __LITTLE_ENDIAN
+	return (__u16)p->request_len_low | (__u16)p->request_len_hi << 8;
+#else
+	return p->request_len;
+#endif
+}
+
+#ifdef __LITTLE_ENDIAN
+struct c_port_amo_payload {
+	__u8 amo_op : 4;
+	__u8: 4;
+	__u8 amo_type : 4;
+	__u8: 4;
+	__u8 cswap_op : 3;
+	__u8: 5;
+	__u64: 40;
+	__u64 op1_word1_le;
+	__u64 op1_word2_le;
+	__u64 op2_word1_le;
+	__u64 op2_word2_le;
+} __attribute__((packed));
+#else
+struct c_port_amo_payload {
+	__u8: 4;
+	__u8 amo_op : 4;
+	__u8: 4;
+	__u8 amo_type : 4;
+	__u8: 5;
+	__u8 cswap_op : 3;
+	__u64: 40;
+	__u64 op1_word1_le;
+	__u64 op1_word2_le;
+	__u64 op2_word1_le;
+	__u64 op2_word2_le;
+} __attribute__((packed));
+#endif
+
+static inline void c_port_amo_payload_set_op1_word1_le(struct c_port_amo_payload *p,
+						       __u64 op1_word1_le)
+{
+	p->op1_word1_le = cpu_to_be64(op1_word1_le);
+}
+
+static inline __u64 c_port_amo_payload_get_op1_word1_le(const struct c_port_amo_payload *p)
+{
+	return be64_to_cpu(p->op1_word1_le);
+}
+
+static inline void c_port_amo_payload_set_op1_word2_le(struct c_port_amo_payload *p,
+						       __u64 op1_word2_le)
+{
+	p->op1_word2_le = cpu_to_be64(op1_word2_le);
+}
+
+static inline __u64 c_port_amo_payload_get_op1_word2_le(const struct c_port_amo_payload *p)
+{
+	return be64_to_cpu(p->op1_word2_le);
+}
+
+static inline void c_port_amo_payload_set_op2_word1_le(struct c_port_amo_payload *p,
+						       __u64 op2_word1_le)
+{
+	p->op2_word1_le = cpu_to_be64(op2_word1_le);
+}
+
+static inline __u64 c_port_amo_payload_get_op2_word1_le(const struct c_port_amo_payload *p)
+{
+	return be64_to_cpu(p->op2_word1_le);
+}
+
+static inline void c_port_amo_payload_set_op2_word2_le(struct c_port_amo_payload *p,
+						       __u64 op2_word2_le)
+{
+	p->op2_word2_le = cpu_to_be64(op2_word2_le);
+}
+
+static inline __u64 c_port_amo_payload_get_op2_word2_le(const struct c_port_amo_payload *p)
+{
+	return be64_to_cpu(p->op2_word2_le);
+}
+
+struct c_hni_cntrs {
+	__u64 cor_ecc_err_cntr;
+	__u64 ucor_ecc_err_cntr;
+	__u64 tx_stall_llr;
+	__u64 cntr0;
+	__u64 rx_stall_ixe_fifo;
+	__u64 cntr1[3];
+	__u64 rx_stall_ixe_pktbuf[8];
+	__u64 pfc_fifo_oflw_cntr[8];
+	__u64 discard_cntr[8];
+	__u64 tx_ok_ieee;
+	__u64 tx_ok_opt;
+	__u64 tx_poisoned_ieee;
+	__u64 tx_poisoned_opt;
+	__u64 tx_ok_broadcast;
+	__u64 tx_ok_multicast;
+	__u64 tx_ok_tagged;
+	__u64 tx_ok_27;
+	__u64 tx_ok_35;
+	__u64 tx_ok_36_to_63;
+	__u64 tx_ok_64;
+	__u64 tx_ok_65_to_127;
+	__u64 tx_ok_128_to_255;
+	__u64 tx_ok_256_to_511;
+	__u64 tx_ok_512_to_1023;
+	__u64 tx_ok_1024_to_2047;
+	__u64 tx_ok_2048_to_4095;
+	__u64 tx_ok_4096_to_8191;
+	__u64 tx_ok_8192_to_max;
+	__u64 rx_ok_ieee;
+	__u64 rx_ok_opt;
+	__u64 rx_bad_ieee;
+	__u64 rx_bad_opt;
+	__u64 rx_ok_broadcast;
+	__u64 rx_ok_multicast;
+	__u64 rx_ok_mac_control;
+	__u64 rx_ok_bad_op_code;
+	__u64 rx_ok_flow_control;
+	__u64 rx_ok_tagged;
+	__u64 rx_ok_len_type_error;
+	__u64 rx_ok_too_long;
+	__u64 rx_ok_undersize;
+	__u64 rx_fragment;
+	__u64 rx_jabber;
+	__u64 rx_ok_27;
+	__u64 rx_ok_35;
+	__u64 rx_ok_36_to_63;
+	__u64 rx_ok_64;
+	__u64 rx_ok_65_to_127;
+	__u64 rx_ok_128_to_255;
+	__u64 rx_ok_256_to_511;
+	__u64 rx_ok_512_to_1023;
+	__u64 rx_ok_1024_to_2047;
+	__u64 rx_ok_2048_to_4095;
+	__u64 rx_ok_4096_to_8191;
+	__u64 rx_ok_8192_to_max;
+	__u64 hrp_ack;
+	__u64 hrp_resp;
+	__u64 fgfc_port;
+	__u64 fgfc_l2;
+	__u64 fgfc_ipv4;
+	__u64 fgfc_ipv6;
+	__u64 fgfc_match;
+	__u64 fgfc_event_xon;
+	__u64 fgfc_event_xoff;
+	__u64 fgfc_discard;
+	__u64 pause_recv[8];
+	__u64 pause_xoff_sent[8];
+	__u64 rx_paused[8];
+	__u64 tx_paused[8];
+	__u64 rx_paused_std;
+	__u64 pause_sent;
+	__u64 pause_refresh;
+	__u64 cntr2;
+	__u64 tx_std_padded;
+	__u64 tx_opt_padded;
+	__u64 tx_std_size_err;
+	__u64 tx_opt_size_err;
+	__u64 pkts_sent_by_tc[8];
+	__u64 pkts_recv_by_tc[8];
+	__u64 multicast_pkts_sent_by_tc[8];
+	__u64 multicast_pkts_recv_by_tc[8];
+};
+
+struct c1_hni_pcs_cntrs {
+	__u64 pml_mbe_error_cnt;
+	__u64 pml_sbe_error_cnt;
+	__u64 corrected_cw;
+	__u64 uncorrected_cw;
+	__u64 good_cw;
+	__u64 fecl_errors[8];
+};
+
+struct c2_hni_pcs_cntrs {
+	__u64 pml_mbe_error_cnt;
+	__u64 pml_sbe_error_cnt;
+	__u64 corrected_cw;
+	__u64 uncorrected_cw;
+	__u64 good_cw;
+	__u64 fecl_errors[16];
+	__u64 corrected_cw_bin[15];
+};
+
+struct c1_hni_mac_cntrs {
+	__u64 rx_illegal_size;
+	__u64 rx_fragment;
+	__u64 rx_preamble_error;
+};
+
+struct c2_hni_mac_cntrs {
+	__u64 rx_illegal_size;
+	__u64 rx_fragment;
+	__u64 rx_preamble_error;
+	__u64 tx_ifg_adjustment_sync;
+};
+
+struct c1_hni_llr_cntrs {
+	__u64 tx_loop_time_req_ctl_fr;
+	__u64 tx_loop_time_rsp_ctl_fr;
+	__u64 tx_init_ctl_os;
+	__u64 tx_init_echo_ctl_os;
+	__u64 tx_ack_ctl_os;
+	__u64 tx_nack_ctl_os;
+	__u64 tx_discard;
+	__u64 tx_ok_lossy;
+	__u64 tx_ok_lossless;
+	__u64 tx_ok_lossless_rpt;
+	__u64 tx_poisoned_lossy;
+	__u64 tx_poisoned_lossless;
+	__u64 tx_poisoned_lossless_rpt;
+	__u64 tx_ok_bypass;
+	__u64 tx_replay_event;
+	__u64 rx_loop_time_req_ctl_fr;
+	__u64 rx_loop_time_rsp_ctl_fr;
+	__u64 rx_bad_ctl_fr;
+	__u64 rx_init_ctl_os;
+	__u64 rx_init_echo_ctl_os;
+	__u64 rx_ack_ctl_os;
+	__u64 rx_nack_ctl_os;
+	__u64 rx_ack_nack_seq_err;
+	__u64 rx_ok_lossy;
+	__u64 rx_poisoned_lossy;
+	__u64 rx_bad_lossy;
+	__u64 rx_ok_lossless;
+	__u64 rx_poisoned_lossless;
+	__u64 rx_bad_lossless;
+	__u64 rx_expected_seq_good;
+	__u64 rx_expected_seq_poisoned;
+	__u64 rx_expected_seq_bad;
+	__u64 rx_unexpected_seq;
+	__u64 rx_duplicate_seq;
+	__u64 rx_replay_event;
+};
+
+struct c2_hni_llr_cntrs {
+	__u64 tx_loop_time_req_ctl_fr;
+	__u64 tx_loop_time_rsp_ctl_fr;
+	__u64 tx_init_ctl_os;
+	__u64 tx_init_echo_ctl_os;
+	__u64 tx_ack_ctl_os;
+	__u64 tx_nack_ctl_os;
+	__u64 tx_discard;
+	__u64 tx_ok_lossy;
+	__u64 tx_ok_lossless;
+	__u64 tx_ok_lossless_rpt;
+	__u64 tx_poisoned_lossy;
+	__u64 tx_poisoned_lossless;
+	__u64 tx_poisoned_lossless_rpt;
+	__u64 tx_bad_lossy;
+	__u64 tx_bad_lossless;
+	__u64 tx_bad_lossless_rpt;
+	__u64 tx_ok_bypass;
+	__u64 tx_replay_event;
+	__u64 tx_llr_blocked;
+	__u64 tx_llr_unblocked;
+	__u64 rx_loop_time_req_ctl_fr;
+	__u64 rx_loop_time_rsp_ctl_fr;
+	__u64 rx_bad_ctl_fr;
+	__u64 rx_init_ctl_os;
+	__u64 rx_init_echo_ctl_os;
+	__u64 rx_ack_ctl_os;
+	__u64 rx_nack_ctl_os;
+	__u64 rx_ack_nack_seq_err;
+	__u64 rx_ok_lossy;
+	__u64 rx_poisoned_lossy;
+	__u64 rx_bad_lossy;
+	__u64 rx_ok_lossless;
+	__u64 rx_poisoned_lossless;
+	__u64 rx_bad_lossless;
+	__u64 rx_expected_seq_good;
+	__u64 rx_expected_seq_poisoned;
+	__u64 rx_expected_seq_bad;
+	__u64 rx_unexpected_seq;
+	__u64 rx_duplicate_seq;
+	__u64 rx_replay_event;
+	__u64 rx_ack_nack_error;
+};
+
+struct c_pi_dmac_cdesc {
+	__u8 done : 1;
+	__u8 status : 2;
+	__u64: 61;
+};
+
+struct c_idc_put_cmd {
+	struct c_idc_hdr idc_header;
+	__u8 data[];
+};
+
+struct c_list_entry_simple {
+	__u64: 38;
+	__u16 addr : 14;
+	__u8 vld : 1;
+	__u16: 11;
+} __attribute__((packed));
+
+struct c_mst_table_simple {
+	__u16 portal_index : 11;
+	__u8: 1;
+	__u8 ptl_list : 2;
+	__u8: 2;
+	__u16 buffer_id;
+	__u32 initiator;
+};
+
+struct c_ct_writeback {
+	__u64 ct_success : 48;
+	__u8 ct_failure : 7;
+	__u16 unused : 8;
+	__u8 ct_writeback : 1;
+};
+
+#define C_ATU_CFG_CRNC_OFFSET 0x00000000
+#define C_ATU_CFG_CRNC (C_ATU_BASE + C_ATU_CFG_CRNC_OFFSET)
+#define C_ATU_CFG_CRNC_SIZE 0x00000008
+
+union c_atu_cfg_crnc {
+	__u64 qw;
+	struct {
+		__u64 csr_timeout : 8;
+		__u64 mcast_id : 10;
+		__u64: 1;
+		__u64 mcast_enable : 1;
+		__u64 mcast_mask : 10;
+		__u64: 34;
+	};
+};
+
+#define C_ATU_MSC_SHADOW_ACTION_OFFSET 0x00000038
+#define C_ATU_MSC_SHADOW_ACTION (C_ATU_BASE + C_ATU_MSC_SHADOW_ACTION_OFFSET)
+#define C_ATU_MSC_SHADOW_ACTION_SIZE 0x00000008
+
+union c_msc_shadow_action {
+	__u64 qw;
+	struct {
+		__u64 addr_offset : 23;
+		__u64: 8;
+		__u64 write : 1;
+		__u64: 32;
+	};
+};
+
+#define C_ATU_MSC_SHADOW_OFFSET 0x00000040
+#define C_ATU_MSC_SHADOW (C_ATU_BASE + C_ATU_MSC_SHADOW_OFFSET)
+#define C_ATU_MSC_SHADOW_SIZE 0x00000020
+
+union c_atu_msc_shadow {
+	__u64 qw[4];
+};
+
+#define C_ATU_ERR_ELAPSED_TIME_OFFSET 0x00000100
+#define C_ATU_ERR_ELAPSED_TIME (C_ATU_BASE + C_ATU_ERR_ELAPSED_TIME_OFFSET)
+#define C_ATU_ERR_ELAPSED_TIME_SIZE 0x00000008
+
+union c_atu_err_elapsed_time {
+	__u64 qw;
+	struct {
+		__u64 nanoseconds : 30;
+		__u64 seconds : 34;
+	};
+};
+
+#define C_ATU_ERR_FLG_OFFSET 0x00000108
+#define C_ATU_ERR_FLG (C_ATU_BASE + C_ATU_ERR_FLG_OFFSET)
+#define C_ATU_ERR_FLG_SIZE 0x00000008
+
+union c_atu_err_flg {
+	__u64 qw;
+	struct {
+		__u64 sw_diag : 1;
+		__u64 crnc_ring_sync_error : 1;
+		__u64 crnc_ring_ecc_sbe : 1;
+		__u64 crnc_ring_ecc_mbe : 1;
+		__u64 crnc_ring_cmd_unknown : 1;
+		__u64 crnc_csr_cmd_unknown : 1;
+		__u64 crnc_csr_cmd_incomplete : 1;
+		__u64 crnc_buf_ecc_sbe : 1;
+		__u64 crnc_buf_ecc_mbe : 1;
+		__u64: 23;
+		__u64 fifo_err : 1;
+		__u64 page_perm_err : 1;
+		__u64 ats_trans_err : 1;
+		__u64 pcie_unsuccess_cmpl : 1;
+		__u64 pcie_error_poisoned : 1;
+		__u64 ats_page_req_err : 1;
+		__u64 no_translation : 1;
+		__u64 invalid_ac : 1;
+		__u64 prb_expired : 1;
+		__u64 nta_pte_align_err : 1;
+		__u64 ats_odp_config_err : 1;
+		__u64 addr_out_of_range : 1;
+		__u64 ats_page_size_config_err : 1;
+		__u64 ats_page_size_err : 1;
+		__u64 p_tarb_cdt_uflow : 1;
+		__u64 np_tarb_cdt_uflow : 1;
+		__u64 ee_odp_req_err : 1;
+		__u64 ats_fn_disabled_err : 1;
+		__u64 rarb_hw_err : 1;
+		__u64 epoch_cnt_err : 1;
+		__u64 rspq_cmpl_err : 1;
+		__u64 odp_unexp_idx_err : 1;
+		__u64 in_progress_cnt_err : 1;
+		__u64: 9;
+	};
+};
+
+#define C_ATU_ERR_FIRST_FLG_OFFSET 0x00000110
+#define C_ATU_ERR_FIRST_FLG (C_ATU_BASE + C_ATU_ERR_FIRST_FLG_OFFSET)
+#define C_ATU_ERR_FIRST_FLG_SIZE 0x00000008
+#define C_ATU_ERR_FIRST_FLG_TS_OFFSET 0x00000118
+#define C_ATU_ERR_FIRST_FLG_TS (C_ATU_BASE + C_ATU_ERR_FIRST_FLG_TS_OFFSET)
+#define C_ATU_ERR_FIRST_FLG_TS_SIZE 0x00000008
+#define C_ATU_ERR_CLR_OFFSET 0x00000120
+#define C_ATU_ERR_CLR (C_ATU_BASE + C_ATU_ERR_CLR_OFFSET)
+#define C_ATU_ERR_CLR_SIZE 0x00000008
+#define C_ATU_ERR_IRQA_MSK_OFFSET 0x00000128
+#define C_ATU_ERR_IRQA_MSK (C_ATU_BASE + C_ATU_ERR_IRQA_MSK_OFFSET)
+#define C_ATU_ERR_IRQA_MSK_SIZE 0x00000008
+#define C_ATU_ERR_IRQB_MSK_OFFSET 0x00000130
+#define C_ATU_ERR_IRQB_MSK (C_ATU_BASE + C_ATU_ERR_IRQB_MSK_OFFSET)
+#define C_ATU_ERR_IRQB_MSK_SIZE 0x00000008
+#define C_ATU_ERR_INFO_MSK_OFFSET 0x00000140
+#define C_ATU_ERR_INFO_MSK (C_ATU_BASE + C_ATU_ERR_INFO_MSK_OFFSET)
+#define C_ATU_ERR_INFO_MSK_SIZE 0x00000008
+#define C_ATU_EXT_ERR_FLG_OFFSET 0x00000148
+#define C_ATU_EXT_ERR_FLG (C_ATU_BASE + C_ATU_EXT_ERR_FLG_OFFSET)
+#define C_ATU_EXT_ERR_FLG_SIZE 0x00000008
+
+union c_atu_ext_err_flg {
+	__u64 qw;
+	struct {
+		__u64 sw_diag : 1;
+		__u64 ac_mem_cor : 1;
+		__u64 otb_mem_cor : 1;
+		__u64 tag_mem_cor : 1;
+		__u64 ingress_bus_cor : 1;
+		__u64 data_mem_cor : 1;
+		__u64 chain_tail_mem_cor : 1;
+		__u64 chain_next_mem_cor : 1;
+		__u64 missq_mem_cor : 1;
+		__u64 uniqq_mem_cor : 1;
+		__u64 chain_mem_cor : 1;
+		__u64 pointer_mem_cor : 1;
+		__u64 replayq_mem_cor : 1;
+		__u64 retryq_mem_cor : 1;
+		__u64 prb_mem_cor : 1;
+		__u64 invalq_mem_cor : 1;
+		__u64 rspinfoq_mem_cor : 1;
+		__u64 cmpldata_mem_cor : 1;
+		__u64 atucq_mem_cor : 1;
+		__u64 ats_prq_mem_cor : 1;
+		__u64 rarb_hdr_bus_cor : 1;
+		__u64 rarb_data_bus_cor : 1;
+		__u64 odpq_mem_cor : 1;
+		__u64: 9;
+		__u64: 1;
+		__u64 ac_mem_ucor : 1;
+		__u64 otb_mem_ucor : 1;
+		__u64 tag_mem_ucor : 1;
+		__u64 ingress_bus_ucor : 1;
+		__u64 data_mem_ucor : 1;
+		__u64 chain_tail_mem_ucor : 1;
+		__u64 chain_next_mem_ucor : 1;
+		__u64 missq_mem_ucor : 1;
+		__u64 uniqq_mem_ucor : 1;
+		__u64 chain_mem_ucor : 1;
+		__u64 pointer_mem_ucor : 1;
+		__u64 replayq_mem_ucor : 1;
+		__u64 retryq_mem_ucor : 1;
+		__u64 prb_mem_ucor : 1;
+		__u64 invalq_mem_ucor : 1;
+		__u64 rspinfoq_mem_ucor : 1;
+		__u64 cmpldata_mem_ucor : 1;
+		__u64 atucq_mem_ucor : 1;
+		__u64 ats_prq_mem_ucor : 1;
+		__u64 rarb_hdr_bus_ucor : 1;
+		__u64 rarb_data_bus_ucor : 1;
+		__u64 odpq_mem_ucor : 1;
+		__u64: 1;
+		__u64 anchor_vld_mem_ucor : 1;
+		__u64 anchor_mem_ucor : 1;
+		__u64: 2;
+		__u64: 4;
+	};
+};
+
+#define C_ATU_EXT_ERR_FIRST_FLG_OFFSET 0x00000150
+#define C_ATU_EXT_ERR_FIRST_FLG (C_ATU_BASE + C_ATU_EXT_ERR_FIRST_FLG_OFFSET)
+#define C_ATU_EXT_ERR_FIRST_FLG_SIZE 0x00000008
+#define C_ATU_EXT_ERR_FIRST_FLG_TS_OFFSET 0x00000158
+#define C_ATU_EXT_ERR_FIRST_FLG_TS (C_ATU_BASE + C_ATU_EXT_ERR_FIRST_FLG_TS_OFFSET)
+#define C_ATU_EXT_ERR_FIRST_FLG_TS_SIZE 0x00000008
+#define C_ATU_EXT_ERR_CLR_OFFSET 0x00000160
+#define C_ATU_EXT_ERR_CLR (C_ATU_BASE + C_ATU_EXT_ERR_CLR_OFFSET)
+#define C_ATU_EXT_ERR_CLR_SIZE 0x00000008
+#define C_ATU_EXT_ERR_IRQA_MSK_OFFSET 0x00000168
+#define C_ATU_EXT_ERR_IRQA_MSK (C_ATU_BASE + C_ATU_EXT_ERR_IRQA_MSK_OFFSET)
+#define C_ATU_EXT_ERR_IRQA_MSK_SIZE 0x00000008
+#define C_ATU_EXT_ERR_IRQB_MSK_OFFSET 0x00000170
+#define C_ATU_EXT_ERR_IRQB_MSK (C_ATU_BASE + C_ATU_EXT_ERR_IRQB_MSK_OFFSET)
+#define C_ATU_EXT_ERR_IRQB_MSK_SIZE 0x00000008
+#define C_ATU_EXT_ERR_INFO_MSK_OFFSET 0x00000180
+#define C_ATU_EXT_ERR_INFO_MSK (C_ATU_BASE + C_ATU_EXT_ERR_INFO_MSK_OFFSET)
+#define C_ATU_EXT_ERR_INFO_MSK_SIZE 0x00000008
+#define C_ATU_ERR_INFO_MEM_OFFSET 0x00000200
+#define C_ATU_ERR_INFO_MEM (C_ATU_BASE + C_ATU_ERR_INFO_MEM_OFFSET)
+#define C_ATU_ERR_INFO_MEM_SIZE 0x00000008
+
+union c_atu_err_info_mem {
+	__u64 qw;
+	struct {
+		__u64 cor_syndrome : 11;
+		__u64: 1;
+		__u64 cor_address : 12;
+		__u64 cor_mem_id : 6;
+		__u64: 1;
+		__u64 cor_csr_detected : 1;
+		__u64 ucor_syndrome : 11;
+		__u64: 1;
+		__u64 ucor_address : 12;
+		__u64 ucor_mem_id : 6;
+		__u64: 1;
+		__u64 ucor_csr_detected : 1;
+	};
+};
+
+#define C_ATU_ERR_INFO_AC_OFFSET 0x00000208
+#define C_ATU_ERR_INFO_AC (C_ATU_BASE + C_ATU_ERR_INFO_AC_OFFSET)
+#define C_ATU_ERR_INFO_AC_SIZE 0x00000008
+
+union c_atu_err_info_ac {
+	__u64 qw;
+	struct {
+		__u64 acid : 10;
+		__u64: 2;
+		__u64 client : 2;
+		__u64: 2;
+		__u64 error_type : 3;
+		__u64: 45;
+	};
+};
+
+#define C_ATU_ERR_INFO_TRANSLATION_OFFSET 0x00000210
+#define C_ATU_ERR_INFO_TRANSLATION (C_ATU_BASE + C_ATU_ERR_INFO_TRANSLATION_OFFSET)
+#define C_ATU_ERR_INFO_TRANSLATION_SIZE 0x00000008
+
+union c_atu_err_info_translation {
+	__u64 qw;
+	struct {
+		__u64 acid : 10;
+		__u64 client : 2;
+		__u64 addr : 45;
+		__u64: 7;
+	};
+};
+
+#define C_ATU_ERR_INFO_ATS_PAGE_REQ_OFFSET 0x00000218
+#define C_ATU_ERR_INFO_ATS_PAGE_REQ (C_ATU_BASE + C_ATU_ERR_INFO_ATS_PAGE_REQ_OFFSET)
+#define C_ATU_ERR_INFO_ATS_PAGE_REQ_SIZE 0x00000008
+
+union c_atu_err_info_ats_page_req {
+	__u64 qw;
+	struct {
+		__u64 acid : 10;
+		__u64 client : 2;
+		__u64 prg_rsp_code : 4;
+		__u64 prb_ucor : 1;
+		__u64: 47;
+	};
+};
+
+#define C_ATU_ERR_INFO_PCIE_EP_OFFSET 0x00000220
+#define C_ATU_ERR_INFO_PCIE_EP (C_ATU_BASE + C_ATU_ERR_INFO_PCIE_EP_OFFSET)
+#define C_ATU_ERR_INFO_PCIE_EP_SIZE 0x00000008
+
+union c_atu_err_info_pcie_ep {
+	__u64 qw;
+	struct {
+		__u64 acid : 10;
+		__u64: 2;
+		__u64 client : 2;
+		__u64: 50;
+	};
+};
+
+#define C_ATU_ERR_INFO_PCIE_UC_OFFSET 0x00000228
+#define C_ATU_ERR_INFO_PCIE_UC (C_ATU_BASE + C_ATU_ERR_INFO_PCIE_UC_OFFSET)
+#define C_ATU_ERR_INFO_PCIE_UC_SIZE 0x00000008
+
+union c_atu_err_info_pcie_uc {
+	__u64 qw;
+	struct {
+		__u64 acid : 10;
+		__u64: 2;
+		__u64 client : 2;
+		__u64: 2;
+		__u64 cmpl_status : 3;
+		__u64: 45;
+	};
+};
+
+#define C_ATU_ERR_INFO_ATS_TRANS_OFFSET 0x00000230
+#define C_ATU_ERR_INFO_ATS_TRANS (C_ATU_BASE + C_ATU_ERR_INFO_ATS_TRANS_OFFSET)
+#define C_ATU_ERR_INFO_ATS_TRANS_SIZE 0x00000008
+
+union c_atu_err_info_ats_trans {
+	__u64 qw;
+	struct {
+		__u64 acid : 10;
+		__u64 client : 2;
+		__u64 addr : 45;
+		__u64 cmpl_status : 3;
+		__u64: 4;
+	};
+};
+
+#define C_ATU_ERR_INFO_PAGE_PERM_OFFSET 0x00000238
+#define C_ATU_ERR_INFO_PAGE_PERM (C_ATU_BASE + C_ATU_ERR_INFO_PAGE_PERM_OFFSET)
+#define C_ATU_ERR_INFO_PAGE_PERM_SIZE 0x00000008
+
+union c_atu_err_info_page_perm {
+	__u64 qw;
+	struct {
+		__u64 acid : 10;
+		__u64: 2;
+		__u64 client : 2;
+		__u64: 2;
+		__u64 perm_ats_priv : 1;
+		__u64 perm_ats_exec : 1;
+		__u64 perm_w : 1;
+		__u64 perm_r : 1;
+		__u64 perm_req_ats_priv : 1;
+		__u64 perm_req_ats_exec : 1;
+		__u64 perm_req_w : 1;
+		__u64 perm_req_r : 1;
+		__u64: 40;
+	};
+};
+
+#define C_ATU_ERR_INFO_NTA_PTE_ALIGN_OFFSET 0x00000240
+#define C_ATU_ERR_INFO_NTA_PTE_ALIGN (C_ATU_BASE + C_ATU_ERR_INFO_NTA_PTE_ALIGN_OFFSET)
+#define C_ATU_ERR_INFO_NTA_PTE_ALIGN_SIZE 0x00000008
+
+union c_atu_err_info_nta_pte_align {
+	__u64 qw;
+	struct {
+		__u64 acid : 10;
+		__u64 client : 2;
+		__u64 addr : 45;
+		__u64 page_size : 5;
+		__u64: 2;
+	};
+};
+
+#define C_ATU_ERR_INFO_FIFO_OFFSET 0x00000248
+#define C_ATU_ERR_INFO_FIFO (C_ATU_BASE + C_ATU_ERR_INFO_FIFO_OFFSET)
+#define C_ATU_ERR_INFO_FIFO_SIZE 0x00000008
+
+union c_atu_err_info_fifo {
+	__u64 qw;
+	struct {
+		__u64 overrun : 1;
+		__u64 underrun : 1;
+		__u64: 14;
+		__u64 fifo_id : 4;
+		__u64: 44;
+	};
+};
+
+#define C_ATU_ERR_INFO_ADDR_OUT_OF_RANGE_OFFSET 0x00000250
+#define C_ATU_ERR_INFO_ADDR_OUT_OF_RANGE (C_ATU_BASE + C_ATU_ERR_INFO_ADDR_OUT_OF_RANGE_OFFSET)
+#define C_ATU_ERR_INFO_ADDR_OUT_OF_RANGE_SIZE 0x00000008
+
+union c_atu_err_info_addr_out_of_range {
+	__u64 qw;
+	struct {
+		__u64 acid : 10;
+		__u64 client : 2;
+		__u64 addr : 45;
+		__u64: 7;
+	};
+};
+
+#define C_ATU_ERR_INFO_ATS_PAGE_SIZE_CONFIG_OFFSET 0x00000258
+#define C_ATU_ERR_INFO_ATS_PAGE_SIZE_CONFIG                                                        \
+	(C_ATU_BASE + C_ATU_ERR_INFO_ATS_PAGE_SIZE_CONFIG_OFFSET)
+#define C_ATU_ERR_INFO_ATS_PAGE_SIZE_CONFIG_SIZE 0x00000008
+
+union c_atu_err_info_ats_page_size_config {
+	__u64 qw;
+	struct {
+		__u64 acid : 10;
+		__u64: 2;
+		__u64 client : 2;
+		__u64: 2;
+		__u64 pg_size : 5;
+		__u64: 43;
+	};
+};
+
+#define C_ATU_ERR_INFO_ATS_PAGE_SIZE_OFFSET 0x00000260
+#define C_ATU_ERR_INFO_ATS_PAGE_SIZE (C_ATU_BASE + C_ATU_ERR_INFO_ATS_PAGE_SIZE_OFFSET)
+#define C_ATU_ERR_INFO_ATS_PAGE_SIZE_SIZE 0x00000008
+
+union c_atu_err_info_ats_page_size {
+	__u64 qw;
+	struct {
+		__u64 acid : 10;
+		__u64: 2;
+		__u64 client : 2;
+		__u64: 2;
+		__u64 pg_size : 6;
+		__u64: 42;
+	};
+};
+
+#define C_ATU_ERR_INFO_EE_ODP_REQ_OFFSET 0x00000268
+#define C_ATU_ERR_INFO_EE_ODP_REQ (C_ATU_BASE + C_ATU_ERR_INFO_EE_ODP_REQ_OFFSET)
+#define C_ATU_ERR_INFO_EE_ODP_REQ_SIZE 0x00000008
+
+union c_atu_err_info_ee_odp_req {
+	__u64 qw;
+	struct {
+		__u64 acid : 10;
+		__u64: 2;
+		__u64 addr : 45;
+		__u64: 7;
+	};
+};
+
+#define C_ATU_ERR_INFO_ATS_ODP_CONFIG_OFFSET 0x00000270
+#define C_ATU_ERR_INFO_ATS_ODP_CONFIG (C_ATU_BASE + C_ATU_ERR_INFO_ATS_ODP_CONFIG_OFFSET)
+#define C_ATU_ERR_INFO_ATS_ODP_CONFIG_SIZE 0x00000008
+
+union c_atu_err_info_ats_odp_config {
+	__u64 qw;
+	struct {
+		__u64 acid : 10;
+		__u64: 2;
+		__u64 client : 2;
+		__u64: 50;
+	};
+};
+
+#define C_ATU_ERR_INFO_PRB_EXPIRED_OFFSET 0x00000278
+#define C_ATU_ERR_INFO_PRB_EXPIRED (C_ATU_BASE + C_ATU_ERR_INFO_PRB_EXPIRED_OFFSET)
+#define C_ATU_ERR_INFO_PRB_EXPIRED_SIZE 0x00000008
+
+union c_atu_err_info_prb_expired {
+	__u64 qw;
+	struct {
+		__u64 index : 9;
+		__u64: 55;
+	};
+};
+
+#define C_ATU_ERR_INFO_ATS_FN_DISABLED_OFFSET 0x00000280
+#define C_ATU_ERR_INFO_ATS_FN_DISABLED (C_ATU_BASE + C_ATU_ERR_INFO_ATS_FN_DISABLED_OFFSET)
+#define C_ATU_ERR_INFO_ATS_FN_DISABLED_SIZE 0x00000008
+
+union c_atu_err_info_ats_fn_disabled {
+	__u64 qw;
+	struct {
+		__u64 acid : 10;
+		__u64: 2;
+		__u64 client : 2;
+		__u64: 50;
+	};
+};
+
+#define C_ATU_ERR_INFO_RARB_OFFSET 0x00000288
+#define C_ATU_ERR_INFO_RARB (C_ATU_BASE + C_ATU_ERR_INFO_RARB_OFFSET)
+#define C_ATU_ERR_INFO_RARB_SIZE 0x00000008
+
+union c_atu_err_info_rarb {
+	__u64 qw;
+	struct {
+		__u64 hdr_ucor : 1;
+		__u64 data_ucor : 1;
+		__u64 bad_vld : 1;
+		__u64 bad_eop : 1;
+		__u64 bad_cmd : 1;
+		__u64 unexpected_cmpl_ptid : 1;
+		__u64 cmpl_tag_out_of_range : 1;
+		__u64: 57;
+	};
+};
+
+#define C_ATU_ERR_INFO_EPOCH_CNT_OFFSET 0x00000290
+#define C_ATU_ERR_INFO_EPOCH_CNT (C_ATU_BASE + C_ATU_ERR_INFO_EPOCH_CNT_OFFSET)
+#define C_ATU_ERR_INFO_EPOCH_CNT_SIZE 0x00000008
+
+union c_atu_err_info_epoch_cnt {
+	__u64 qw;
+	struct {
+		__u64 oxe_at_epoch0_cnt_underrun : 1;
+		__u64 oxe_at_epoch0_cnt_overrun : 1;
+		__u64 oxe_at_epoch1_cnt_underrun : 1;
+		__u64 oxe_at_epoch1_cnt_overrun : 1;
+		__u64 ixe_at_epoch0_cnt_underrun : 1;
+		__u64 ixe_at_epoch0_cnt_overrun : 1;
+		__u64 ixe_at_epoch1_cnt_underrun : 1;
+		__u64 ixe_at_epoch1_cnt_overrun : 1;
+		__u64 ee_at_epoch0_cnt_underrun : 1;
+		__u64 ee_at_epoch0_cnt_overrun : 1;
+		__u64 ee_at_epoch1_cnt_underrun : 1;
+		__u64 ee_at_epoch1_cnt_overrun : 1;
+		__u64 ib_epoch0_cnt_underrun : 1;
+		__u64 ib_epoch0_cnt_overrun : 1;
+		__u64 ib_epoch1_cnt_underrun : 1;
+		__u64 ib_epoch1_cnt_overrun : 1;
+		__u64: 48;
+	};
+};
+
+#define C_ATU_ERR_INFO_RSPQ_CMPL_OFFSET 0x00000298
+#define C_ATU_ERR_INFO_RSPQ_CMPL (C_ATU_BASE + C_ATU_ERR_INFO_RSPQ_CMPL_OFFSET)
+#define C_ATU_ERR_INFO_RSPQ_CMPL_SIZE 0x00000008
+
+union c_atu_err_info_rspq_cmpl {
+	__u64 qw;
+	struct {
+		__u64 cmpl_last_surplus : 1;
+		__u64 cmpl_last_deficit : 1;
+		__u64 cmpl_missing : 1;
+		__u64: 61;
+	};
+};
+
+#define C_ATU_ERR_INFO_ODP_UNEXP_IDX_OFFSET 0x000002a0
+#define C_ATU_ERR_INFO_ODP_UNEXP_IDX (C_ATU_BASE + C_ATU_ERR_INFO_ODP_UNEXP_IDX_OFFSET)
+#define C_ATU_ERR_INFO_ODP_UNEXP_IDX_SIZE 0x00000008
+
+union c_atu_err_info_odp_unexp_idx {
+	__u64 qw;
+	struct {
+		__u64 prb_index : 9;
+		__u64 ats_pg_rsp : 1;
+		__u64: 54;
+	};
+};
+
+#define C_ATU_ERR_INFO_IN_PROGRESS_CNT_OFFSET 0x000002a8
+#define C_ATU_ERR_INFO_IN_PROGRESS_CNT (C_ATU_BASE + C_ATU_ERR_INFO_IN_PROGRESS_CNT_OFFSET)
+#define C_ATU_ERR_INFO_IN_PROGRESS_CNT_SIZE 0x00000008
+
+union c_atu_err_info_in_progress_cnt {
+	__u64 qw;
+	struct {
+		__u64 oxe_epoch0_cnt_underrun : 1;
+		__u64 oxe_epoch0_cnt_overrun : 1;
+		__u64 oxe_epoch1_cnt_underrun : 1;
+		__u64 oxe_epoch1_cnt_overrun : 1;
+		__u64 ixe_epoch0_cnt_underrun : 1;
+		__u64 ixe_epoch0_cnt_overrun : 1;
+		__u64 ixe_epoch1_cnt_underrun : 1;
+		__u64 ixe_epoch1_cnt_overrun : 1;
+		__u64 ee_epoch0_cnt_underrun : 1;
+		__u64 ee_epoch0_cnt_overrun : 1;
+		__u64 ee_epoch1_cnt_underrun : 1;
+		__u64 ee_epoch1_cnt_overrun : 1;
+		__u64: 52;
+	};
+};
+
+#define C_ATU_CFG_NTA_OFFSET 0x00000400
+#define C_ATU_CFG_NTA (C_ATU_BASE + C_ATU_CFG_NTA_OFFSET)
+#define C_ATU_CFG_NTA_SIZE 0x00000008
+
+union c_atu_cfg_nta {
+	__u64 qw;
+	struct {
+		__u64 acid : 10;
+		__u64: 54;
+	};
+};
+
+#define C_ATU_CFG_ATS_OFFSET 0x00000408
+#define C_ATU_CFG_ATS (C_ATU_BASE + C_ATU_CFG_ATS_OFFSET)
+#define C_ATU_CFG_ATS_SIZE 0x00000008
+
+union c_atu_cfg_ats {
+	__u64 qw;
+	struct {
+		__u64 inval_batch_mode : 1;
+		__u64: 3;
+		__u64 num_xlations_req : 2;
+		__u64: 2;
+		__u64 inval_process_interval : 5;
+		__u64: 3;
+		__u64 truncate_gt_stu_rsp : 1;
+		__u64: 47;
+	};
+};
+
+#define C_ATU_CFG_CMDPROC_OFFSET 0x00000410
+#define C_ATU_CFG_CMDPROC (C_ATU_BASE + C_ATU_CFG_CMDPROC_OFFSET)
+#define C_ATU_CFG_CMDPROC_SIZE 0x00000008
+
+union c_atu_cfg_cmdproc {
+	__u64 qw;
+	struct {
+		__u64: 4;
+		__u64 rd_ptr : 5;
+		__u64: 7;
+		__u64: 4;
+		__u64 wr_ptr : 5;
+		__u64: 39;
+	};
+};
+
+#define C_ATU_CFG_WB_DATA_OFFSET 0x00000418
+#define C_ATU_CFG_WB_DATA (C_ATU_BASE + C_ATU_CFG_WB_DATA_OFFSET)
+#define C_ATU_CFG_WB_DATA_SIZE 0x00000008
+
+union c_atu_cfg_wb_data {
+	__u64 qw;
+	struct {
+		__u64 data;
+	};
+};
+
+#define C_ATU_CFG_CMDS_OFFSET 0x00000430
+#define C_ATU_CFG_CMDS (C_ATU_BASE + C_ATU_CFG_CMDS_OFFSET)
+#define C_ATU_CFG_CMDS_SIZE 0x00000008
+
+union c_atu_cfg_cmds {
+	__u64 qw;
+	struct {
+		__u64 writeback_acid : 10;
+		__u64: 6;
+		__u64 ib_wait_int_idx : 11;
+		__u64: 1;
+		__u64 ib_wait_int_enable : 1;
+		__u64: 3;
+		__u64 cmpl_wait_int_idx : 11;
+		__u64: 1;
+		__u64 cmpl_wait_int_enable : 1;
+		__u64: 19;
+	};
+};
+
+#define C_ATU_CFG_ODPQ_OFFSET 0x00000438
+#define C_ATU_CFG_ODPQ (C_ATU_BASE + C_ATU_CFG_ODPQ_OFFSET)
+#define C_ATU_CFG_ODPQ_SIZE 0x00000008
+
+union c_atu_cfg_odpq {
+	__u64 qw;
+	struct {
+		__u64 prb_index : 9;
+		__u64: 7;
+		__u64 status : 1;
+		__u64: 47;
+	};
+};
+
+#define C_ATU_CFG_ODP_OFFSET 0x00000440
+#define C_ATU_CFG_ODP (C_ATU_BASE + C_ATU_CFG_ODP_OFFSET)
+#define C_ATU_CFG_ODP_SIZE 0x00000008
+
+union c_atu_cfg_odp {
+	__u64 qw;
+	struct {
+		__u64 acid : 10;
+		__u64: 6;
+		__u64 int_idx : 11;
+		__u64: 1;
+		__u64 int_enable : 1;
+		__u64: 31;
+		__u64 odp_en : 1;
+		__u64: 3;
+	};
+};
+
+#define C_ATU_CFG_PRI_OFFSET 0x00000448
+#define C_ATU_CFG_PRI (C_ATU_BASE + C_ATU_CFG_PRI_OFFSET)
+#define C_ATU_CFG_PRI_SIZE 0x00000008
+
+union c_atu_cfg_pri {
+	__u64 qw;
+	struct {
+		__u64: 12;
+		__u64 base_addr : 45;
+		__u64: 3;
+		__u64 relaxed_ordering_en : 1;
+		__u64: 3;
+	};
+};
+
+#define C_ATU_CFG_PRB_OFFSET 0x00000450
+#define C_ATU_CFG_PRB (C_ATU_BASE + C_ATU_CFG_PRB_OFFSET)
+#define C_ATU_CFG_PRB_SIZE 0x00000008
+
+union c_atu_cfg_prb {
+	__u64 qw;
+	struct {
+		__u64 timeout : 4;
+		__u64: 60;
+	};
+};
+
+#define C1_ATU_CFG_ODP_DECOUPLE_OFFSET 0x00000478
+#define C1_ATU_CFG_ODP_DECOUPLE (C_ATU_BASE + C1_ATU_CFG_ODP_DECOUPLE_OFFSET)
+#define C1_ATU_CFG_ODP_DECOUPLE_SIZE 0x00000008
+
+union c1_atu_cfg_odp_decouple {
+	__u64 qw;
+	struct {
+		__u64 flush_req_delay : 10;
+		__u64: 2;
+		__u64 enable : 1;
+		__u64: 51;
+	};
+};
+
+#define C2_ATU_CFG_ODP_DECOUPLE_OFFSET 0x00000478
+#define C2_ATU_CFG_ODP_DECOUPLE (C_ATU_BASE + C2_ATU_CFG_ODP_DECOUPLE_OFFSET)
+#define C2_ATU_CFG_ODP_DECOUPLE_SIZE 0x00000008
+
+union c2_atu_cfg_odp_decouple {
+	__u64 qw;
+	struct {
+		__u64 flush_req_delay : 32;
+		__u64 enable : 1;
+		__u64 wait_no_trigger : 1;
+		__u64 ip_all_client : 1;
+		__u64 tcam_mask : 2;
+		__u64 flush_to_trigger : 1;
+		__u64 trigger_wo_odp : 1;
+		__u64: 25;
+	};
+};
+
+#define C_ATU_CFG_INBOUND_WAIT_OFFSET 0x00000480
+#define C_ATU_CFG_INBOUND_WAIT (C_ATU_BASE + C_ATU_CFG_INBOUND_WAIT_OFFSET)
+#define C_ATU_CFG_INBOUND_WAIT_SIZE 0x00000008
+
+union c_atu_cfg_inbound_wait {
+	__u64 qw;
+	struct {
+		__u64: 3;
+		__u64 rsp_addr : 54;
+		__u64 rsp_en : 1;
+		__u64: 6;
+	};
+};
+
+#define C_ATU_CFG_AC_TABLE_OFFSET(idx) (0x00010000 + ((idx) * 32))
+#define C_ATU_CFG_AC_TABLE_ENTRIES 1024
+#define C_ATU_CFG_AC_TABLE(idx) (C_ATU_BASE + C_ATU_CFG_AC_TABLE_OFFSET(idx))
+#define C_ATU_CFG_AC_TABLE_SIZE 0x00008000
+
+union c_atu_cfg_ac_table {
+	__u64 qw[4];
+	struct {
+		union {
+			struct {
+				__u64: 12;
+				__u64 nta_root_ptr : 45;
+				__u64 nta_use_req_acid : 1;
+				__u64: 6;
+			};
+			struct {
+				__u64: 12;
+				__u64 ats_vf_num : 6;
+				__u64 ats_vf_en : 1;
+				__u64 ats_no_write : 1;
+				__u64 ats_pasid : 20;
+				__u64 ats_pasid_er : 1;
+				__u64 ats_pasid_pmr : 1;
+				__u64 ats_pasid_en : 1;
+				__u64 ats_filter_optimistic : 1;
+				__u64: 20;
+			};
+			struct {
+				__u64: 12;
+				__u64 ta_mode_opts : 46;
+				__u64: 6;
+			};
+		};
+		__u64: 12;
+		__u64 mem_size : 45;
+		__u64: 7;
+		__u64: 15;
+		__u64 mem_base : 42;
+		__u64: 7;
+		__u64: 32;
+		__u64 idx_salt : 8;
+		__u64 ptn_salt : 2;
+		__u64 cntr_pool_id : 2;
+		__u64 odp_mode : 1;
+		__u64 odp_en : 1;
+		__u64 do_not_filter : 1;
+		__u64: 1;
+		__u64 ptg_mode : 3;
+		__u64: 1;
+		__u64 pg_table_size : 4;
+		__u64 base_pg_size : 4;
+		__u64 do_not_cache : 1;
+		__u64 ta_mode : 2;
+		__u64 context_en : 1;
+	};
+};
+
+#define C_ATU_CFG_CQ_TABLE_OFFSET(idx) (0x0001a000 + ((idx) * 8))
+#define C_ATU_CFG_CQ_TABLE_ENTRIES 32
+#define C_ATU_CFG_CQ_TABLE(idx) (C_ATU_BASE + C_ATU_CFG_CQ_TABLE_OFFSET(idx))
+#define C_ATU_CFG_CQ_TABLE_SIZE 0x00000100
+
+union c_atu_cfg_cq_table {
+	__u64 qw;
+	union {
+		struct {
+			__u64 cmd_args : 62;
+			__u64 cmd : 2;
+		};
+		struct {
+			__u64: 3;
+			__u64 comp_wait_rsp_addr : 54;
+			__u64 comp_wait_rsp_en : 1;
+			__u64: 4;
+			__u64 comp_wait_cmd : 2;
+		};
+		struct {
+			__u64 inval_acid : 10;
+			__u64: 1;
+			__u64 inval_size : 1;
+			__u64 inval_addr : 45;
+			__u64: 5;
+			__u64 inval_addr_cmd : 2;
+		};
+	};
+};
+
+#define C_ATU_STS_INIT_DONE_OFFSET 0x00000800
+#define C_ATU_STS_INIT_DONE (C_ATU_BASE + C_ATU_STS_INIT_DONE_OFFSET)
+#define C_ATU_STS_INIT_DONE_SIZE 0x00000008
+
+union c_atu_sts_init_done {
+	__u64 qw;
+	struct {
+		__u64 tag_init_done : 1;
+		__u64 anchor_init_done : 1;
+		__u64 prb_init_done : 1;
+		__u64: 61;
+	};
+};
+
+#define C_ATU_STS_CMDPROC_OFFSET 0x00000808
+#define C_ATU_STS_CMDPROC (C_ATU_BASE + C_ATU_STS_CMDPROC_OFFSET)
+#define C_ATU_STS_CMDPROC_SIZE 0x00000008
+
+union c_atu_sts_cmdproc {
+	__u64 qw;
+	struct {
+		__u64 atucq_cmd_count : 16;
+		__u64: 8;
+		__u64 atucq_cmd : 2;
+		__u64: 2;
+		__u64 atucq_running : 1;
+		__u64 atucq_idle : 1;
+		__u64 atucq_waiting_arb : 1;
+		__u64 inbound_wait_idle : 1;
+		__u64 unused : 32;
+	};
+};
+
+#define C_ATU_STS_AT_EPOCH_OFFSET 0x00000810
+#define C_ATU_STS_AT_EPOCH (C_ATU_BASE + C_ATU_STS_AT_EPOCH_OFFSET)
+#define C_ATU_STS_AT_EPOCH_SIZE 0x00000008
+
+union c_atu_sts_at_epoch {
+	__u64 qw;
+	struct {
+		__u64 current_epoch : 1;
+		__u64: 7;
+		__u64 ee_epoch0_cntr_ne0 : 1;
+		__u64 ee_epoch1_cntr_ne0 : 1;
+		__u64: 2;
+		__u64 oxe_epoch0_cntr_ne0 : 1;
+		__u64 oxe_epoch1_cntr_ne0 : 1;
+		__u64: 2;
+		__u64 ixe_epoch0_cntr_ne0 : 1;
+		__u64 ixe_epoch1_cntr_ne0 : 1;
+		__u64: 46;
+	};
+};
+
+#define C_ATU_STS_IXE_AT_EPOCH_CNTR_OFFSET 0x00000818
+#define C_ATU_STS_IXE_AT_EPOCH_CNTR (C_ATU_BASE + C_ATU_STS_IXE_AT_EPOCH_CNTR_OFFSET)
+#define C_ATU_STS_IXE_AT_EPOCH_CNTR_SIZE 0x00000008
+
+union c_atu_sts_ixe_at_epoch_cntr {
+	__u64 qw;
+	struct {
+		__u64 epoch0 : 16;
+		__u64 epoch1 : 16;
+		__u64 unused : 32;
+	};
+};
+
+#define C_ATU_STS_OXE_AT_EPOCH_CNTR_OFFSET 0x00000820
+#define C_ATU_STS_OXE_AT_EPOCH_CNTR (C_ATU_BASE + C_ATU_STS_OXE_AT_EPOCH_CNTR_OFFSET)
+#define C_ATU_STS_OXE_AT_EPOCH_CNTR_SIZE 0x00000008
+
+union c_atu_sts_oxe_at_epoch_cntr {
+	__u64 qw;
+	struct {
+		__u64 epoch0 : 16;
+		__u64 epoch1 : 16;
+		__u64 unused : 32;
+	};
+};
+
+#define C_ATU_STS_EE_AT_EPOCH_CNTR_OFFSET 0x00000828
+#define C_ATU_STS_EE_AT_EPOCH_CNTR (C_ATU_BASE + C_ATU_STS_EE_AT_EPOCH_CNTR_OFFSET)
+#define C_ATU_STS_EE_AT_EPOCH_CNTR_SIZE 0x00000008
+
+union c_atu_sts_ee_at_epoch_cntr {
+	__u64 qw;
+	struct {
+		__u64 epoch0 : 16;
+		__u64 epoch1 : 16;
+		__u64 unused : 32;
+	};
+};
+
+#define C_ATU_STS_IB_EPOCH_OFFSET 0x00000830
+#define C_ATU_STS_IB_EPOCH (C_ATU_BASE + C_ATU_STS_IB_EPOCH_OFFSET)
+#define C_ATU_STS_IB_EPOCH_SIZE 0x00000008
+
+union c_atu_sts_ib_epoch {
+	__u64 qw;
+	struct {
+		__u64 current_epoch : 1;
+		__u64 mirrored_epoch : 1;
+		__u64: 6;
+		__u64 epoch0_cntr_ne0 : 1;
+		__u64 epoch1_cntr_ne0 : 1;
+		__u64: 54;
+	};
+};
+
+#define C_ATU_STS_IB_EPOCH_CNTR_OFFSET 0x00000838
+#define C_ATU_STS_IB_EPOCH_CNTR (C_ATU_BASE + C_ATU_STS_IB_EPOCH_CNTR_OFFSET)
+#define C_ATU_STS_IB_EPOCH_CNTR_SIZE 0x00000008
+
+union c_atu_sts_ib_epoch_cntr {
+	__u64 qw;
+	struct {
+		__u64 epoch0 : 16;
+		__u64 epoch1 : 16;
+		__u64 unused : 32;
+	};
+};
+
+#define C_ATU_STS_ODPQ_OFFSET 0x00000848
+#define C_ATU_STS_ODPQ (C_ATU_BASE + C_ATU_STS_ODPQ_OFFSET)
+#define C_ATU_STS_ODPQ_SIZE 0x00000008
+
+union c_atu_sts_odpq {
+	__u64 qw;
+	struct {
+		__u64 odpq_space : 4;
+		__u64: 60;
+	};
+};
+
+#define C_ATU_STS_ATS_VF_DISABLED_OFFSET 0x00000858
+#define C_ATU_STS_ATS_VF_DISABLED (C_ATU_BASE + C_ATU_STS_ATS_VF_DISABLED_OFFSET)
+#define C_ATU_STS_ATS_VF_DISABLED_SIZE 0x00000008
+
+union c_atu_sts_ats_vf_disabled {
+	__u64 qw;
+	struct {
+		__u64 vf_disabled;
+	};
+};
+
+#define C_ATU_STS_ATS_PF_DISABLED_OFFSET 0x00000860
+#define C_ATU_STS_ATS_PF_DISABLED (C_ATU_BASE + C_ATU_STS_ATS_PF_DISABLED_OFFSET)
+#define C_ATU_STS_ATS_PF_DISABLED_SIZE 0x00000008
+
+union c_atu_sts_ats_pf_disabled {
+	__u64 qw;
+	struct {
+		__u64 pf_disabled : 1;
+		__u64: 63;
+	};
+};
+
+#define C_ATU_STS_ATS_INVALQ_OFFSET 0x00000918
+#define C_ATU_STS_ATS_INVALQ (C_ATU_BASE + C_ATU_STS_ATS_INVALQ_OFFSET)
+#define C_ATU_STS_ATS_INVALQ_SIZE 0x00000008
+
+union c_atu_sts_ats_invalq {
+	__u64 qw;
+	struct {
+		__u64 requester_id : 16;
+		__u64 vf_num : 6;
+		__u64: 2;
+		__u64 vf_en : 1;
+		__u64: 3;
+		__u64 invals_to_process : 6;
+		__u64: 2;
+		__u64 invalq_count : 6;
+		__u64 invalq_full : 1;
+		__u64 invalq_vld : 1;
+		__u64 state_drive_rsp : 1;
+		__u64 state_cmpl_wait : 1;
+		__u64 state_invalidating : 1;
+		__u64 state_wait_arb : 1;
+		__u64 state_wait_trig : 1;
+		__u64: 15;
+	};
+};
+
+#define C_ATU_STS_IXE_IN_PROGRESS_CNTR_OFFSET 0x00000920
+#define C_ATU_STS_IXE_IN_PROGRESS_CNTR (C_ATU_BASE + C_ATU_STS_IXE_IN_PROGRESS_CNTR_OFFSET)
+#define C_ATU_STS_IXE_IN_PROGRESS_CNTR_SIZE 0x00000008
+
+union c_atu_sts_ixe_in_progress_cntr {
+	__u64 qw;
+	struct {
+		__u64 epoch0 : 9;
+		__u64: 7;
+		__u64 epoch1 : 9;
+		__u64: 39;
+	};
+};
+
+#define C_ATU_STS_OXE_IN_PROGRESS_CNTR_OFFSET 0x00000928
+#define C_ATU_STS_OXE_IN_PROGRESS_CNTR (C_ATU_BASE + C_ATU_STS_OXE_IN_PROGRESS_CNTR_OFFSET)
+#define C_ATU_STS_OXE_IN_PROGRESS_CNTR_SIZE 0x00000008
+
+union c_atu_sts_oxe_in_progress_cntr {
+	__u64 qw;
+	struct {
+		__u64 epoch0 : 9;
+		__u64: 7;
+		__u64 epoch1 : 9;
+		__u64: 39;
+	};
+};
+
+#define C_ATU_STS_EE_IN_PROGRESS_CNTR_OFFSET 0x00000930
+#define C_ATU_STS_EE_IN_PROGRESS_CNTR (C_ATU_BASE + C_ATU_STS_EE_IN_PROGRESS_CNTR_OFFSET)
+#define C_ATU_STS_EE_IN_PROGRESS_CNTR_SIZE 0x00000008
+
+union c_atu_sts_ee_in_progress_cntr {
+	__u64 qw;
+	struct {
+		__u64 epoch0 : 9;
+		__u64: 7;
+		__u64 epoch1 : 9;
+		__u64: 39;
+	};
+};
+
+#define C_ATU_STS_ODP_DECOUPLE_OFFSET 0x00000938
+#define C_ATU_STS_ODP_DECOUPLE (C_ATU_BASE + C_ATU_STS_ODP_DECOUPLE_OFFSET)
+#define C_ATU_STS_ODP_DECOUPLE_SIZE 0x00000008
+
+union c_atu_sts_odp_decouple {
+	__u64 qw;
+	struct {
+		__u64 previous_epoch : 1;
+		__u64 cmpl_wait_active : 1;
+		__u64 ixe_at_prev_epoch_cnt_ne0 : 1;
+		__u64 ixe_at_prev_epoch_ip_cnt_eq0 : 1;
+		__u64 ixe_prb_vld : 1;
+		__u64 state : 2;
+		__u64: 57;
+	};
+};
+
+#define C_ATU_STS_PRB_TABLE_OFFSET(idx) (0x00020000 + ((idx) * 8))
+#define C_ATU_STS_PRB_TABLE_ENTRIES 512
+#define C_ATU_STS_PRB_TABLE(idx) (C_ATU_BASE + C_ATU_STS_PRB_TABLE_OFFSET(idx))
+#define C_ATU_STS_PRB_TABLE_SIZE 0x00001000
+
+union c_atu_sts_prb_table {
+	__u64 qw;
+	struct {
+		__u64 acid : 10;
+		__u64 client : 2;
+		__u64 addr : 45;
+		__u64 w : 1;
+		__u64 r : 1;
+		__u64 ta_mode : 2;
+		__u64 odp_mode : 1;
+		__u64 expired : 1;
+		__u64 valid : 1;
+	};
+};
+
+#define C_CQ_CFG_CRNC_OFFSET 0x00000000
+#define C_CQ_CFG_CRNC (C_CQ_BASE + C_CQ_CFG_CRNC_OFFSET)
+#define C_CQ_CFG_CRNC_SIZE 0x00000008
+
+union c_cq_cfg_crnc {
+	__u64 qw;
+	struct {
+		__u64 csr_timeout : 8;
+		__u64 mcast_id : 10;
+		__u64: 1;
+		__u64 mcast_enable : 1;
+		__u64 mcast_mask : 10;
+		__u64: 34;
+	};
+};
+
+#define C_CQ_MSC_SHADOW_ACTION_OFFSET 0x00000038
+#define C_CQ_MSC_SHADOW_ACTION (C_CQ_BASE + C_CQ_MSC_SHADOW_ACTION_OFFSET)
+#define C_CQ_MSC_SHADOW_ACTION_SIZE 0x00000008
+#define C_CQ_MSC_SHADOW_OFFSET 0x00000040
+#define C_CQ_MSC_SHADOW (C_CQ_BASE + C_CQ_MSC_SHADOW_OFFSET)
+#define C_CQ_MSC_SHADOW_SIZE 0x00000088
+
+union c_cq_msc_shadow {
+	__u64 qw[17];
+};
+
+#define C_CQ_ERR_ELAPSED_TIME_OFFSET 0x00000100
+#define C_CQ_ERR_ELAPSED_TIME (C_CQ_BASE + C_CQ_ERR_ELAPSED_TIME_OFFSET)
+#define C_CQ_ERR_ELAPSED_TIME_SIZE 0x00000008
+
+union c_cq_err_elapsed_time {
+	__u64 qw;
+	struct {
+		__u64 nanoseconds : 30;
+		__u64 seconds : 34;
+	};
+};
+
+#define C_CQ_ERR_FLG_OFFSET 0x00000108
+#define C_CQ_ERR_FLG (C_CQ_BASE + C_CQ_ERR_FLG_OFFSET)
+#define C_CQ_ERR_FLG_SIZE 0x00000008
+
+union c_cq_err_flg {
+	__u64 qw;
+	struct {
+		__u64 sw_diag : 1;
+		__u64 crnc_ring_sync_error : 1;
+		__u64 crnc_ring_ecc_sbe : 1;
+		__u64 crnc_ring_ecc_mbe : 1;
+		__u64 crnc_ring_cmd_unknown : 1;
+		__u64 crnc_csr_cmd_unknown : 1;
+		__u64 crnc_csr_cmd_incomplete : 1;
+		__u64 crnc_buf_ecc_sbe : 1;
+		__u64 crnc_buf_ecc_mbe : 1;
+		__u64: 7;
+		__u64 fifo_err : 1;
+		__u64 credit_uflw : 1;
+		__u64 c_state_cor : 1;
+		__u64 rarb_hdr_cor : 1;
+		__u64 rarb_data_cor : 1;
+		__u64 event_ram_cor : 1;
+		__u64 ll_state_mem_cor : 1;
+		__u64 ll_status_mem_cor : 1;
+		__u64 c_state_ucor : 1;
+		__u64 rarb_hdr_ucor : 1;
+		__u64 rarb_data_ucor : 1;
+		__u64 event_ram_ucor : 1;
+		__u64 ll_state_mem_ucor : 1;
+		__u64 ll_status_mem_ucor : 1;
+		__u64 ll_nempty_vectr_ucor : 1;
+		__u64 ll_full_vectr_ucor : 1;
+		__u64 event_cnt_ovf : 1;
+		__u64 tle_oversubscribed : 1;
+		__u64 rarb_bad_xactn_err : 1;
+		__u64 rarb_cmpltn_err : 1;
+		__u64 rarb_tou_wr_hw_err : 1;
+		__u64 rarb_ll_wr_hw_err : 1;
+		__u64 rarb_invld_wr_sw_err : 1;
+		__u64 rarb_tou_wr_sw_err : 1;
+		__u64 rarb_ll_wr_sw_err : 1;
+		__u64 msg_cnt_uflw : 1;
+		__u64 fq_load_uflw : 1;
+		__u64 wr_ptr_updt_err : 1;
+		__u64 ard_ptr_update_ucor : 1;
+		__u64 tx_fqu_free_list_ovf : 1;
+		__u64 tou_fqu_free_list_ovf : 1;
+		__u64: 17;
+	};
+};
+
+#define C_CQ_ERR_FIRST_FLG_OFFSET 0x00000110
+#define C_CQ_ERR_FIRST_FLG (C_CQ_BASE + C_CQ_ERR_FIRST_FLG_OFFSET)
+#define C_CQ_ERR_FIRST_FLG_SIZE 0x00000008
+#define C_CQ_ERR_FIRST_FLG_TS_OFFSET 0x00000118
+#define C_CQ_ERR_FIRST_FLG_TS (C_CQ_BASE + C_CQ_ERR_FIRST_FLG_TS_OFFSET)
+#define C_CQ_ERR_FIRST_FLG_TS_SIZE 0x00000008
+#define C_CQ_ERR_CLR_OFFSET 0x00000120
+#define C_CQ_ERR_CLR (C_CQ_BASE + C_CQ_ERR_CLR_OFFSET)
+#define C_CQ_ERR_CLR_SIZE 0x00000008
+#define C_CQ_ERR_IRQA_MSK_OFFSET 0x00000128
+#define C_CQ_ERR_IRQA_MSK (C_CQ_BASE + C_CQ_ERR_IRQA_MSK_OFFSET)
+#define C_CQ_ERR_IRQA_MSK_SIZE 0x00000008
+#define C_CQ_ERR_IRQB_MSK_OFFSET 0x00000130
+#define C_CQ_ERR_IRQB_MSK (C_CQ_BASE + C_CQ_ERR_IRQB_MSK_OFFSET)
+#define C_CQ_ERR_IRQB_MSK_SIZE 0x00000008
+#define C_CQ_ERR_INFO_MSK_OFFSET 0x00000140
+#define C_CQ_ERR_INFO_MSK (C_CQ_BASE + C_CQ_ERR_INFO_MSK_OFFSET)
+#define C_CQ_ERR_INFO_MSK_SIZE 0x00000008
+#define C_CQ_EXT_ERR_FLG_OFFSET 0x00000148
+#define C_CQ_EXT_ERR_FLG (C_CQ_BASE + C_CQ_EXT_ERR_FLG_OFFSET)
+#define C_CQ_EXT_ERR_FLG_SIZE 0x00000008
+
+union c_cq_ext_err_flg {
+	__u64 qw;
+	struct {
+		__u64 sw_diag : 1;
+		__u64 remap_array_cor : 1;
+		__u64 cprof_table_cor : 1;
+		__u64 ac_remap_array_cor : 1;
+		__u64 tou_fq_cmd_cor : 1;
+		__u64 cq_fq_cmd_cor : 1;
+		__u64 tou_fid_list_ptrs_cor : 1;
+		__u64 cq_fid_list_ptrs_cor : 1;
+		__u64 ll_buf_cor : 1;
+		__u64 tx_ptr_cor : 1;
+		__u64 tx_base_cor : 1;
+		__u64 tx_ocuset_cor : 1;
+		__u64 tg_ptr_cor : 1;
+		__u64 tg_base_cor : 1;
+		__u64 pfq_bufs_cor : 1;
+		__u64 pfq_bufs_info_cor : 1;
+		__u64 pfq_ptrs_cor : 1;
+		__u64 target_pfq_cor : 1;
+		__u64 tu_pfq_bufs_cor : 1;
+		__u64 tu_pfq_info_cor : 1;
+		__u64 tu_pfq_list_ptrs_cor : 1;
+		__u64 ct_table_cor : 1;
+		__u64 ee_table_cor : 1;
+		__u64 ptlte_table_cor : 1;
+		__u64 ct_events_cor : 1;
+		__u64 thresh_table_cor : 1;
+		__u64 trig_ct_field_cor : 1;
+		__u64 trig_list_nodes_cor : 1;
+		__u64 tou_ll_reorder_cor : 1;
+		__u64 tou_cmd_ptrs_cor : 1;
+		__u64 in_fifo_cor : 1;
+		__u64 wb_addr_cor : 1;
+		__u64: 1;
+		__u64 remap_array_ucor : 1;
+		__u64 cprof_table_ucor : 1;
+		__u64 ac_remap_array_ucor : 1;
+		__u64 tou_fq_cmd_ucor : 1;
+		__u64 cq_fq_cmd_ucor : 1;
+		__u64 tou_fid_list_ptrs_ucor : 1;
+		__u64 cq_fid_list_ptrs_ucor : 1;
+		__u64 ll_buf_ucor : 1;
+		__u64 tx_ptr_ucor : 1;
+		__u64 tx_base_ucor : 1;
+		__u64 tx_ocuset_ucor : 1;
+		__u64 tg_ptr_ucor : 1;
+		__u64 tg_base_ucor : 1;
+		__u64 pfq_bufs_ucor : 1;
+		__u64 pfq_bufs_info_ucor : 1;
+		__u64 pfq_ptrs_ucor : 1;
+		__u64 target_pfq_ucor : 1;
+		__u64 tu_pfq_bufs_ucor : 1;
+		__u64 tu_pfq_info_ucor : 1;
+		__u64 tu_pfq_list_ptrs_ucor : 1;
+		__u64 ct_table_ucor : 1;
+		__u64 ee_table_ucor : 1;
+		__u64 ptlte_table_ucor : 1;
+		__u64 ct_events_ucor : 1;
+		__u64 thresh_table_ucor : 1;
+		__u64 trig_ct_field_ucor : 1;
+		__u64 trig_list_nodes_ucor : 1;
+		__u64 tou_ll_reorder_ucor : 1;
+		__u64 tou_cmd_ptrs_ucor : 1;
+		__u64 in_fifo_ucor : 1;
+		__u64 wb_addr_ucor : 1;
+	};
+};
+
+#define C_CQ_EXT_ERR_FIRST_FLG_OFFSET 0x00000150
+#define C_CQ_EXT_ERR_FIRST_FLG (C_CQ_BASE + C_CQ_EXT_ERR_FIRST_FLG_OFFSET)
+#define C_CQ_EXT_ERR_FIRST_FLG_SIZE 0x00000008
+#define C_CQ_EXT_ERR_FIRST_FLG_TS_OFFSET 0x00000158
+#define C_CQ_EXT_ERR_FIRST_FLG_TS (C_CQ_BASE + C_CQ_EXT_ERR_FIRST_FLG_TS_OFFSET)
+#define C_CQ_EXT_ERR_FIRST_FLG_TS_SIZE 0x00000008
+#define C_CQ_EXT_ERR_CLR_OFFSET 0x00000160
+#define C_CQ_EXT_ERR_CLR (C_CQ_BASE + C_CQ_EXT_ERR_CLR_OFFSET)
+#define C_CQ_EXT_ERR_CLR_SIZE 0x00000008
+#define C_CQ_EXT_ERR_IRQA_MSK_OFFSET 0x00000168
+#define C_CQ_EXT_ERR_IRQA_MSK (C_CQ_BASE + C_CQ_EXT_ERR_IRQA_MSK_OFFSET)
+#define C_CQ_EXT_ERR_IRQA_MSK_SIZE 0x00000008
+#define C_CQ_EXT_ERR_IRQB_MSK_OFFSET 0x00000170
+#define C_CQ_EXT_ERR_IRQB_MSK (C_CQ_BASE + C_CQ_EXT_ERR_IRQB_MSK_OFFSET)
+#define C_CQ_EXT_ERR_IRQB_MSK_SIZE 0x00000008
+#define C_CQ_EXT_ERR_INFO_MSK_OFFSET 0x00000180
+#define C_CQ_EXT_ERR_INFO_MSK (C_CQ_BASE + C_CQ_EXT_ERR_INFO_MSK_OFFSET)
+#define C_CQ_EXT_ERR_INFO_MSK_SIZE 0x00000008
+#define C_CQ_ERR_INFO_MEM_OFFSET 0x00000190
+#define C_CQ_ERR_INFO_MEM (C_CQ_BASE + C_CQ_ERR_INFO_MEM_OFFSET)
+#define C_CQ_ERR_INFO_MEM_SIZE 0x00000008
+
+union c_cq_err_info_mem {
+	__u64 qw;
+	struct {
+		__u64 cor_syndrome : 11;
+		__u64: 1;
+		__u64 cor_address : 12;
+		__u64 cor_mem_id : 7;
+		__u64 cor_csr_detected : 1;
+		__u64 ucor_syndrome : 11;
+		__u64: 1;
+		__u64 ucor_address : 12;
+		__u64 ucor_mem_id : 7;
+		__u64 ucor_csr_detected : 1;
+	};
+};
+
+#define C_CQ_ERR_INFO_FIFO_ERR_OFFSET 0x00000198
+#define C_CQ_ERR_INFO_FIFO_ERR (C_CQ_BASE + C_CQ_ERR_INFO_FIFO_ERR_OFFSET)
+#define C_CQ_ERR_INFO_FIFO_ERR_SIZE 0x00000008
+
+union c_cq_err_info_fifo_err {
+	__u64 qw;
+	struct {
+		__u64 overrun : 1;
+		__u64 underrun : 1;
+		__u64: 6;
+		__u64 fifo_id : 6;
+		__u64: 50;
+	};
+};
+
+#define C_CQ_ERR_INFO_CC_OFFSET 0x000001a0
+#define C_CQ_ERR_INFO_CC (C_CQ_BASE + C_CQ_ERR_INFO_CC_OFFSET)
+#define C_CQ_ERR_INFO_CC_SIZE 0x00000008
+
+union c_cq_err_info_cc {
+	__u64 qw;
+	struct {
+		__u64 cc_id : 5;
+		__u64: 3;
+		__u64 sub_id : 3;
+		__u64: 53;
+	};
+};
+
+#define C_CQ_ERR_INFO_RARB_OFFSET 0x000001b0
+#define C_CQ_ERR_INFO_RARB (C_CQ_BASE + C_CQ_ERR_INFO_RARB_OFFSET)
+#define C_CQ_ERR_INFO_RARB_SIZE 0x00000010
+
+union c_cq_err_info_rarb {
+	__u64 qw[2];
+	struct {
+		__u64 bad_xactn_err : 1;
+		__u64 cmpltn_sts_err : 1;
+		__u64 cmpltn_ep_err : 1;
+		__u64 cmpltn_len_err : 1;
+		__u64 cmpltn_addr_err : 1;
+		__u64 cmpltn_dv_err : 1;
+		__u64 cmpltn_eop_err : 1;
+		__u64 cmpltn_data_mbe_err : 1;
+		__u64 tou_wr_hw_err : 1;
+		__u64 invld_wr_sw_err : 1;
+		__u64 tou_wr_sw_err : 1;
+		__u64: 5;
+		__u64 msg_type : 3;
+		__u64: 1;
+		__u64 cmpl_status : 3;
+		__u64: 1;
+		__u64 ep : 1;
+		__u64 dv : 1;
+		__u64 eop : 1;
+		__u64 data_mbe : 1;
+		__u64: 4;
+		__u64 tag : 9;
+		__u64: 7;
+		__u64 lower_address : 7;
+		__u64: 9;
+		__u64 first_dw_be : 4;
+		__u64 last_dw_be : 4;
+		__u64: 8;
+		__u64 length : 11;
+		__u64: 7;
+		__u64 addr_29_2 : 28;
+		__u64: 2;
+	};
+};
+
+#define C_CQ_ERR_INFO_RARB_LL_OFFSET 0x000001c0
+#define C_CQ_ERR_INFO_RARB_LL (C_CQ_BASE + C_CQ_ERR_INFO_RARB_LL_OFFSET)
+#define C_CQ_ERR_INFO_RARB_LL_SIZE 0x00000010
+
+union c_cq_err_info_rarb_ll {
+	__u64 qw[2];
+	struct {
+		__u64 hw_data_uncorr_err : 1;
+		__u64 hw_early_eop_err : 1;
+		__u64 hw_missing_eop_err : 1;
+		__u64 hw_data_valid_err : 1;
+		__u64 sw_addr_err : 1;
+		__u64 sw_align_err : 1;
+		__u64 sw_op_chgd_err : 1;
+		__u64 sw_offset_err : 1;
+		__u64 sw_offset_chgd_err : 1;
+		__u64 sw_overlap_err : 1;
+		__u64: 6;
+		__u64 ll_op : 3;
+		__u64: 13;
+		__u64 cq_id : 10;
+		__u64: 6;
+		__u64 is_tgq : 1;
+		__u64: 15;
+		__u64 first_dw_be : 4;
+		__u64 last_dw_be : 4;
+		__u64: 8;
+		__u64 length : 11;
+		__u64: 7;
+		__u64 addr_in_pg_15_2 : 14;
+		__u64: 16;
+	};
+};
+
+#define C_CQ_ERR_INFO_OCU_MAP_OFFSET 0x000001d0
+#define C_CQ_ERR_INFO_OCU_MAP (C_CQ_BASE + C_CQ_ERR_INFO_OCU_MAP_OFFSET)
+#define C_CQ_ERR_INFO_OCU_MAP_SIZE 0x00000008
+
+union c_cq_err_info_ocu_map {
+	__u64 qw;
+	struct {
+		__u64 ocu_id : 8;
+		__u64 fq_id : 6;
+		__u64: 50;
+	};
+};
+
+#define C_CQ_ERR_INFO_WR_PTR_UPDT_OFFSET 0x000001d8
+#define C_CQ_ERR_INFO_WR_PTR_UPDT (C_CQ_BASE + C_CQ_ERR_INFO_WR_PTR_UPDT_OFFSET)
+#define C_CQ_ERR_INFO_WR_PTR_UPDT_SIZE 0x00000008
+
+union c_cq_err_info_wr_ptr_updt {
+	__u64 qw;
+	struct {
+		__u64 invalid_wr_ptr : 16;
+		__u64 max_ptr : 16;
+		__u64 cq_id : 10;
+		__u64: 6;
+		__u64 is_tgq : 1;
+		__u64: 15;
+	};
+};
+
+#define C_CQ_CFG_INIT_TXQ_HW_STATE_OFFSET 0x00000400
+#define C_CQ_CFG_INIT_TXQ_HW_STATE (C_CQ_BASE + C_CQ_CFG_INIT_TXQ_HW_STATE_OFFSET)
+#define C_CQ_CFG_INIT_TXQ_HW_STATE_SIZE 0x00000008
+
+union c_cq_cfg_init_txq_hw_state {
+	__u64 qw;
+	struct {
+		__u64 cq_handle : 10;
+		__u64: 6;
+		__u64 pending : 1;
+		__u64: 47;
+	};
+};
+
+#define C_CQ_CFG_INIT_TGQ_HW_STATE_OFFSET 0x00000440
+#define C_CQ_CFG_INIT_TGQ_HW_STATE (C_CQ_BASE + C_CQ_CFG_INIT_TGQ_HW_STATE_OFFSET)
+#define C_CQ_CFG_INIT_TGQ_HW_STATE_SIZE 0x00000008
+
+union c_cq_cfg_init_tgq_hw_state {
+	__u64 qw;
+	struct {
+		__u64 cq_handle : 9;
+		__u64: 7;
+		__u64 pending : 1;
+		__u64: 47;
+	};
+};
+
+#define C_CQ_CFG_INIT_CT_HW_STATE_OFFSET 0x00000480
+#define C_CQ_CFG_INIT_CT_HW_STATE (C_CQ_BASE + C_CQ_CFG_INIT_CT_HW_STATE_OFFSET)
+#define C_CQ_CFG_INIT_CT_HW_STATE_SIZE 0x00000008
+
+union c_cq_cfg_init_ct_hw_state {
+	__u64 qw;
+	struct {
+		__u64 ct_handle : 11;
+		__u64 init : 1;
+		__u64 cancel : 1;
+		__u64: 3;
+		__u64 pending : 1;
+		__u64: 47;
+	};
+};
+
+#define C_CQ_CFG_TLE_POOL_OFFSET(idx) (0x00000500 + ((idx) * 8))
+#define C_CQ_CFG_TLE_POOL_ENTRIES 4
+#define C_CQ_CFG_TLE_POOL(idx) (C_CQ_BASE + C_CQ_CFG_TLE_POOL_OFFSET(idx))
+#define C_CQ_CFG_TLE_POOL_SIZE 0x00000020
+
+union c_cq_cfg_tle_pool {
+	__u64 qw;
+	struct {
+		__u64 num_reserved : 12;
+		__u64: 4;
+		__u64 in_use : 8;
+		__u64: 8;
+		__u64 max_alloc : 12;
+		__u64: 20;
+	};
+};
+
+#define C_CQ_CFG_STS_TLE_SHARED_OFFSET 0x00000520
+#define C_CQ_CFG_STS_TLE_SHARED (C_CQ_BASE + C_CQ_CFG_STS_TLE_SHARED_OFFSET)
+#define C_CQ_CFG_STS_TLE_SHARED_SIZE 0x00000008
+
+union c_cq_cfg_sts_tle_shared {
+	__u64 qw;
+	struct {
+		__u64 num_shared : 12;
+		__u64: 20;
+		__u64 num_shared_allocated : 12;
+		__u64: 4;
+		__u64 num_total_allocated : 12;
+		__u64: 4;
+	};
+};
+
+#define C_CQ_CFG_CREDIT_LIMITS_OFFSET 0x00000530
+#define C_CQ_CFG_CREDIT_LIMITS (C_CQ_BASE + C_CQ_CFG_CREDIT_LIMITS_OFFSET)
+#define C_CQ_CFG_CREDIT_LIMITS_SIZE 0x00000010
+
+union c_cq_cfg_credit_limits {
+	__u64 qw[2];
+	struct {
+		__u64 lpe_cmd_credits : 10;
+		__u64: 6;
+		__u64 lpe_rcv_fifo_credits : 4;
+		__u64: 4;
+		__u64 ee_event_credits : 5;
+		__u64: 11;
+		__u64 tou_fq_credits : 7;
+		__u64: 1;
+		__u64 tarb_p_credits : 5;
+		__u64: 3;
+		__u64 tarb_np_credits : 5;
+		__u64: 3;
+		__u64 prefetch_tou_credits : 5;
+		__u64: 3;
+		__u64 tou_wb_credits : 5;
+		__u64: 3;
+		__u64 tou_event_credits : 3;
+		__u64: 5;
+		__u64 tgq_cmd_fail_event_credits : 3;
+		__u64: 5;
+		__u64 txq_cmd_fail_event_credits : 4;
+		__u64: 4;
+		__u64 tou_cmd_fail_event_credits : 3;
+		__u64: 5;
+		__u64 fq_tot_credits : 9;
+		__u64: 7;
+	};
+};
+
+#define C_CQ_CFG_EVENT_CNTS_OFFSET 0x00000540
+#define C_CQ_CFG_EVENT_CNTS (C_CQ_BASE + C_CQ_CFG_EVENT_CNTS_OFFSET)
+#define C_CQ_CFG_EVENT_CNTS_SIZE 0x00000008
+
+union c_cq_cfg_event_cnts {
+	__u64 qw;
+	struct {
+		__u64 enable : 1;
+		__u64 init : 1;
+		__u64 init_done : 1;
+		__u64: 1;
+		__u64 ovf_cnt : 16;
+		__u64: 44;
+	};
+};
+
+#define C_CQ_TXQ_BASE_TABLE_OFFSET(idx) (0x00010000 + ((idx) * 16))
+#define C_CQ_TXQ_BASE_TABLE_ENTRIES 1024
+#define C_CQ_TXQ_BASE_TABLE(idx) (C_CQ_BASE + C_CQ_TXQ_BASE_TABLE_OFFSET(idx))
+#define C_CQ_TXQ_BASE_TABLE_SIZE 0x00004000
+
+union c_cq_txq_base_table {
+	__u64 qw[2];
+	struct {
+		__u64 mem_q_eq : 11;
+		__u64: 1;
+		__u64 mem_q_base : 45;
+		__u64: 7;
+		__u64 mem_q_max_ptr : 16;
+		__u64 mem_q_rgid : 8;
+		__u64: 1;
+		__u64: 1;
+		__u64 mem_q_stat_cnt_pool : 2;
+		__u64: 8;
+		__u64 mem_q_pfq : 6;
+		__u64: 2;
+		__u64 mem_q_lcid : 4;
+		__u64 mem_q_acid : 10;
+		__u64 mem_q_policy : 2;
+		__u64: 4;
+	};
+};
+
+#define C_CQ_TXQ_ENABLE_OFFSET(idx) (0x00002000 + ((idx) * 8))
+#define C_CQ_TXQ_ENABLE_ENTRIES 1024
+#define C_CQ_TXQ_ENABLE(idx) (C_CQ_BASE + C_CQ_TXQ_ENABLE_OFFSET(idx))
+#define C_CQ_TXQ_ENABLE_SIZE 0x00002000
+
+union c_cq_txq_enable {
+	__u64 qw;
+	struct {
+		__u64 txq_enable : 1;
+		__u64 drain : 1;
+		__u64 fence : 1;
+		__u64: 61;
+	};
+};
+
+#define C_CQ_TXQ_TC_TABLE_OFFSET(idx) (0x00016000 + ((idx) * 8))
+#define C_CQ_TXQ_TC_TABLE_ENTRIES 1024
+#define C_CQ_TXQ_TC_TABLE(idx) (C_CQ_BASE + C_CQ_TXQ_TC_TABLE_OFFSET(idx))
+#define C_CQ_TXQ_TC_TABLE_SIZE 0x00002000
+
+union c_cq_txq_tc_table {
+	__u64 qw;
+	struct {
+		__u64 mem_q_tc : 3;
+		__u64 mem_q_trig : 1;
+		__u64 mem_q_eth : 1;
+		__u64: 59;
+	};
+};
+
+#define C_CQ_TXQ_WRPTR_TABLE_OFFSET(idx) (0x00018000 + ((idx) * 8))
+#define C_CQ_TXQ_WRPTR_TABLE_ENTRIES 1024
+#define C_CQ_TXQ_WRPTR_TABLE(idx) (C_CQ_BASE + C_CQ_TXQ_WRPTR_TABLE_OFFSET(idx))
+#define C_CQ_TXQ_WRPTR_TABLE_SIZE 0x00002000
+
+union c_cq_txq_wrptr_table {
+	__u64 qw;
+	struct {
+		__u64 mem_q_wr_ptr : 16;
+		__u64: 48;
+	};
+};
+
+#define C_CQ_TXQ_RDPTR_TABLE_OFFSET(idx) (0x00090000 + ((idx) * 8))
+#define C_CQ_TXQ_RDPTR_TABLE_ENTRIES 1024
+#define C_CQ_TXQ_RDPTR_TABLE(idx) (C_CQ_BASE + C_CQ_TXQ_RDPTR_TABLE_OFFSET(idx))
+#define C_CQ_TXQ_RDPTR_TABLE_SIZE 0x00002000
+
+union c_cq_txq_rdptr_table {
+	__u64 qw;
+	struct {
+		__u64 mem_q_rd_ptr : 16;
+		__u64: 48;
+	};
+};
+
+#define C_CQ_TXQ_PREPTR_TABLE_OFFSET(idx) (0x00070000 + ((idx) * 8))
+#define C_CQ_TXQ_PREPTR_TABLE_ENTRIES 1024
+#define C_CQ_TXQ_PREPTR_TABLE(idx) (C_CQ_BASE + C_CQ_TXQ_PREPTR_TABLE_OFFSET(idx))
+#define C_CQ_TXQ_PREPTR_TABLE_SIZE 0x00002000
+
+union c_cq_txq_preptr_table {
+	__u64 qw;
+	struct {
+		__u64 mem_q_pre_ptr : 16;
+		__u64 mem_q_pre_ptr_par : 1;
+		__u64: 47;
+	};
+};
+
+#define C_CQ_TXQ_ACK_CTR_OFFSET(idx) (0x00094000 + ((idx) * 8))
+#define C_CQ_TXQ_ACK_CTR_ENTRIES 1024
+#define C_CQ_TXQ_ACK_CTR(idx) (C_CQ_BASE + C_CQ_TXQ_ACK_CTR_OFFSET(idx))
+#define C_CQ_TXQ_ACK_CTR_SIZE 0x00002000
+
+union c_cq_txq_ack_ctr {
+	__u64 qw;
+	struct {
+		__u64 mem_q_ack_ctr : 12;
+		__u64: 52;
+	};
+};
+
+#define C_CQ_TGQ_TABLE_OFFSET(idx) (0x0001a000 + ((idx) * 16))
+#define C_CQ_TGQ_TABLE_ENTRIES 512
+#define C_CQ_TGQ_TABLE(idx) (C_CQ_BASE + C_CQ_TGQ_TABLE_OFFSET(idx))
+#define C_CQ_TGQ_TABLE_SIZE 0x00002000
+
+union c_cq_tgq_table {
+	__u64 qw[2];
+	struct {
+		__u64 mem_q_eq : 11;
+		__u64: 1;
+		__u64 mem_q_base : 45;
+		__u64: 7;
+		__u64 mem_q_max_ptr : 16;
+		__u64 mem_q_rgid : 8;
+		__u64: 1;
+		__u64: 1;
+		__u64 mem_q_stat_cnt_pool : 2;
+		__u64 mem_q_tc_reg : 3;
+		__u64: 17;
+		__u64 mem_q_acid : 10;
+		__u64 mem_q_policy : 2;
+		__u64: 4;
+	};
+};
+
+#define C_CQ_TGQ_ENABLE_OFFSET(idx) (0x00004000 + ((idx) * 8))
+#define C_CQ_TGQ_ENABLE_ENTRIES 512
+#define C_CQ_TGQ_ENABLE(idx) (C_CQ_BASE + C_CQ_TGQ_ENABLE_OFFSET(idx))
+#define C_CQ_TGQ_ENABLE_SIZE 0x00001000
+
+union c_cq_tgq_enable {
+	__u64 qw;
+	struct {
+		__u64 tgq_enable : 1;
+		__u64 drain : 1;
+		__u64: 62;
+	};
+};
+
+#define C_CQ_TGQ_WRPTR_TABLE_OFFSET(idx) (0x0001c000 + ((idx) * 8))
+#define C_CQ_TGQ_WRPTR_TABLE_ENTRIES 512
+#define C_CQ_TGQ_WRPTR_TABLE(idx) (C_CQ_BASE + C_CQ_TGQ_WRPTR_TABLE_OFFSET(idx))
+#define C_CQ_TGQ_WRPTR_TABLE_SIZE 0x00001000
+
+union c_cq_tgq_wrptr_table {
+	__u64 qw;
+	struct {
+		__u64 mem_q_wr_ptr : 16;
+		__u64: 48;
+	};
+};
+
+#define C_CQ_TGQ_RDPTR_TABLE_OFFSET(idx) (0x00092000 + ((idx) * 8))
+#define C_CQ_TGQ_RDPTR_TABLE_ENTRIES 512
+#define C_CQ_TGQ_RDPTR_TABLE(idx) (C_CQ_BASE + C_CQ_TGQ_RDPTR_TABLE_OFFSET(idx))
+#define C_CQ_TGQ_RDPTR_TABLE_SIZE 0x00001000
+
+union c_cq_tgq_rdptr_table {
+	__u64 qw;
+	struct {
+		__u64 mem_q_rd_ptr : 16;
+		__u64: 48;
+	};
+};
+
+#define C_CQ_TGQ_PREPTR_TABLE_OFFSET(idx) (0x00072000 + ((idx) * 8))
+#define C_CQ_TGQ_PREPTR_TABLE_ENTRIES 512
+#define C_CQ_TGQ_PREPTR_TABLE(idx) (C_CQ_BASE + C_CQ_TGQ_PREPTR_TABLE_OFFSET(idx))
+#define C_CQ_TGQ_PREPTR_TABLE_SIZE 0x00001000
+
+union c_cq_tgq_preptr_table {
+	__u64 qw;
+	struct {
+		__u64 mem_q_pre_ptr : 16;
+		__u64 mem_q_pre_ptr_par : 1;
+		__u64: 47;
+	};
+};
+
+#define C_CQ_TGQ_ACK_CTR_OFFSET(idx) (0x00096000 + ((idx) * 8))
+#define C_CQ_TGQ_ACK_CTR_ENTRIES 512
+#define C_CQ_TGQ_ACK_CTR(idx) (C_CQ_BASE + C_CQ_TGQ_ACK_CTR_OFFSET(idx))
+#define C_CQ_TGQ_ACK_CTR_SIZE 0x00001000
+
+union c_cq_tgq_ack_ctr {
+	__u64 qw;
+	struct {
+		__u64 mem_q_ack_ctr : 12;
+		__u64: 4;
+		__u64 append_ctr : 14;
+		__u64: 34;
+	};
+};
+
+#define C_CQ_CFG_CQ_POLICY_OFFSET 0x00000640
+#define C_CQ_CFG_CQ_POLICY (C_CQ_BASE + C_CQ_CFG_CQ_POLICY_OFFSET)
+#define C_CQ_CFG_CQ_POLICY_SIZE 0x00000008
+
+union c_cq_cfg_cq_policy {
+	__u64 qw;
+	struct {
+		struct {
+			__u8 shift : 4;
+			__u8 empty : 1;
+			__u8: 3;
+		} policy[4];
+		__u32 unused;
+	};
+};
+
+#define C_CQ_CFG_CP_TABLE_OFFSET(idx) (0x0001d000 + ((idx) * 8))
+#define C_CQ_CFG_CP_TABLE_ENTRIES 256
+#define C_CQ_CFG_CP_TABLE(idx) (C_CQ_BASE + C_CQ_CFG_CP_TABLE_OFFSET(idx))
+#define C_CQ_CFG_CP_TABLE_SIZE 0x00000800
+
+union c_cq_cfg_cp_table {
+	__u64 qw;
+	struct {
+		__u64 vni : 16;
+		__u64 dscp_unrsto : 6;
+		__u64: 2;
+		__u64 dscp_rstuno : 6;
+		__u64: 2;
+		__u64 hrp_vld : 1;
+		__u64 smt_disabled : 1;
+		__u64 sct_disabled : 1;
+		__u64 srb_disabled : 1;
+		__u64 valid : 1;
+		__u64: 27;
+	};
+};
+
+#define C_CQ_CFG_CP_FL_TABLE_OFFSET(idx) (0x0001d800 + ((idx) * 8))
+#define C_CQ_CFG_CP_FL_TABLE_ENTRIES 256
+#define C_CQ_CFG_CP_FL_TABLE(idx) (C_CQ_BASE + C_CQ_CFG_CP_FL_TABLE_OFFSET(idx))
+#define C_CQ_CFG_CP_FL_TABLE_SIZE 0x00000800
+
+union c_cq_cfg_cp_fl_table {
+	__u64 qw;
+	struct {
+		__u64 pfq : 6;
+		__u64: 2;
+		__u64 tc : 3;
+		__u64: 53;
+	};
+};
+
+#define C_CQ_CFG_CT_WB_MEM_ADDR_OFFSET(idx) (0x00080000 + ((idx) * 8))
+#define C_CQ_CFG_CT_WB_MEM_ADDR_ENTRIES 2048
+#define C_CQ_CFG_CT_WB_MEM_ADDR(idx) (C_CQ_BASE + C_CQ_CFG_CT_WB_MEM_ADDR_OFFSET(idx))
+#define C_CQ_CFG_CT_WB_MEM_ADDR_SIZE 0x00004000
+
+union c_cq_cfg_ct_wb_mem_addr {
+	__u64 qw;
+	struct {
+		__u64 wb_mem_context : 10;
+		__u64 wb_mem_addr : 54;
+	};
+};
+
+#define C_CQ_CFG_CT_ENABLE_OFFSET(idx) (0x00088000 + ((idx) * 8))
+#define C_CQ_CFG_CT_ENABLE_ENTRIES 2048
+#define C_CQ_CFG_CT_ENABLE(idx) (C_CQ_BASE + C_CQ_CFG_CT_ENABLE_OFFSET(idx))
+#define C_CQ_CFG_CT_ENABLE_SIZE 0x00004000
+
+union c_cq_cfg_ct_enable {
+	__u64 qw;
+	struct {
+		__u64 ct_enable : 1;
+		__u64: 63;
+	};
+};
+
+#define C_CQ_CFG_CID_ARRAY_OFFSET(idx) (0x00050000 + ((idx) * 8))
+#define C_CQ_CFG_CID_ARRAY_ENTRIES 4096
+#define C_CQ_CFG_CID_ARRAY(idx) (C_CQ_BASE + C_CQ_CFG_CID_ARRAY_OFFSET(idx))
+#define C_CQ_CFG_CID_ARRAY_SIZE 0x00008000
+
+union c_cq_cfg_cid_array {
+	__u64 qw;
+	struct {
+		__u64 cid : 8;
+		__u64: 56;
+	};
+};
+
+#define C_CQ_CFG_AC_ARRAY_OFFSET(idx) (0x00060000 + ((idx) * 8))
+#define C_CQ_CFG_AC_ARRAY_ENTRIES 2048
+#define C_CQ_CFG_AC_ARRAY(idx) (C_CQ_BASE + C_CQ_CFG_AC_ARRAY_OFFSET(idx))
+#define C_CQ_CFG_AC_ARRAY_SIZE 0x00004000
+
+union c_cq_cfg_ac_array {
+	__u64 qw;
+	struct {
+		__u64 ac : 10;
+		__u64: 54;
+	};
+};
+
+#define C_CQ_CFG_PFQ_THRESH_TABLE_OFFSET(idx) (0x0001e000 + ((idx) * 8))
+#define C_CQ_CFG_PFQ_THRESH_TABLE_ENTRIES 48
+#define C_CQ_CFG_PFQ_THRESH_TABLE(idx) (C_CQ_BASE + C_CQ_CFG_PFQ_THRESH_TABLE_OFFSET(idx))
+#define C_CQ_CFG_PFQ_THRESH_TABLE_SIZE 0x00000180
+
+union c_cq_cfg_pfq_thresh_table {
+	__u64 qw;
+	struct {
+		__u64 high_thresh : 9;
+		__u64: 7;
+		__u64 buf_cnt : 10;
+		__u64: 38;
+	};
+};
+
+#define C_CQ_CFG_FQ_THRESH_TABLE_OFFSET(idx) (0x0001e200 + ((idx) * 8))
+#define C_CQ_CFG_FQ_THRESH_TABLE_ENTRIES 48
+#define C_CQ_CFG_FQ_THRESH_TABLE(idx) (C_CQ_BASE + C_CQ_CFG_FQ_THRESH_TABLE_OFFSET(idx))
+#define C_CQ_CFG_FQ_THRESH_TABLE_SIZE 0x00000180
+
+union c_cq_cfg_fq_thresh_table {
+	__u64 qw;
+	struct {
+		__u64 thresh : 41;
+		__u64: 23;
+	};
+};
+
+#define C_CQ_CFG_PFQ_TC_MAP_OFFSET(idx) (0x0001e400 + ((idx) * 8))
+#define C_CQ_CFG_PFQ_TC_MAP_ENTRIES 48
+#define C_CQ_CFG_PFQ_TC_MAP(idx) (C_CQ_BASE + C_CQ_CFG_PFQ_TC_MAP_OFFSET(idx))
+#define C_CQ_CFG_PFQ_TC_MAP_SIZE 0x00000180
+
+union c_cq_cfg_pfq_tc_map {
+	__u64 qw;
+	struct {
+		__u64 pfq_tc : 3;
+		__u64: 61;
+	};
+};
+
+#define C_CQ_CFG_OCUSET_OCU_TABLE_OFFSET(idx) (0x0001e800 + ((idx) * 8))
+#define C_CQ_CFG_OCUSET_OCU_TABLE_ENTRIES 48
+#define C_CQ_CFG_OCUSET_OCU_TABLE(idx) (C_CQ_BASE + C_CQ_CFG_OCUSET_OCU_TABLE_OFFSET(idx))
+#define C_CQ_CFG_OCUSET_OCU_TABLE_SIZE 0x00000180
+
+union c_cq_cfg_ocuset_ocu_table {
+	__u64 qw;
+	struct {
+		__u64 ocu_base : 8;
+		__u64 ocu_count : 4;
+		__u64 ocu_static : 1;
+		__u64: 51;
+	};
+};
+
+#define C_CQ_CFG_OCU_HASH_MASK_OFFSET 0x00039050
+#define C_CQ_CFG_OCU_HASH_MASK (C_CQ_BASE + C_CQ_CFG_OCU_HASH_MASK_OFFSET)
+#define C_CQ_CFG_OCU_HASH_MASK_SIZE 0x00000008
+
+union c_cq_cfg_ocu_hash_mask {
+	__u64 qw;
+	struct {
+		__u64 dfa : 32;
+		__u64 vni : 16;
+		__u64 dscp : 6;
+		__u64: 10;
+	};
+};
+
+#define C_CQ_CFG_OCUSET_FQ_TABLE_OFFSET(idx) (0x0001f000 + ((idx) * 8))
+#define C_CQ_CFG_OCUSET_FQ_TABLE_ENTRIES 48
+#define C_CQ_CFG_OCUSET_FQ_TABLE(idx) (C_CQ_BASE + C_CQ_CFG_OCUSET_FQ_TABLE_OFFSET(idx))
+#define C_CQ_CFG_OCUSET_FQ_TABLE_SIZE 0x00000180
+
+union c_cq_cfg_ocuset_fq_table {
+	__u64 qw;
+	struct {
+		__u64 fq_count : 4;
+		__u64: 60;
+	};
+};
+
+#define C_CQ_CFG_OCU_TABLE_OFFSET(idx) (0x0001f800 + ((idx) * 8))
+#define C_CQ_CFG_OCU_TABLE_ENTRIES 256
+#define C_CQ_CFG_OCU_TABLE(idx) (C_CQ_BASE + C_CQ_CFG_OCU_TABLE_OFFSET(idx))
+#define C_CQ_CFG_OCU_TABLE_SIZE 0x00000800
+
+union c_cq_cfg_ocu_table {
+	__u64 qw;
+	struct {
+		__u64 msg_count : 11;
+		__u64: 1;
+		__u64 fq_saved : 6;
+		__u64: 2;
+		__u64 fq : 6;
+		__u64: 38;
+	};
+};
+
+#define C_CQ_CFG_CT_RGID_TABLE_OFFSET(idx) (0x00020000 + ((idx) * 8))
+#define C_CQ_CFG_CT_RGID_TABLE_ENTRIES 2048
+#define C_CQ_CFG_CT_RGID_TABLE(idx) (C_CQ_BASE + C_CQ_CFG_CT_RGID_TABLE_OFFSET(idx))
+#define C_CQ_CFG_CT_RGID_TABLE_SIZE 0x00004000
+
+union c_cq_cfg_ct_rgid_table {
+	__u64 qw;
+	struct {
+		__u64 rgid : 8;
+		__u64: 56;
+	};
+};
+
+#define C_CQ_CFG_PTLTE_RGID_TABLE_OFFSET(idx) (0x00028000 + ((idx) * 8))
+#define C_CQ_CFG_PTLTE_RGID_TABLE_ENTRIES 2048
+#define C_CQ_CFG_PTLTE_RGID_TABLE(idx) (C_CQ_BASE + C_CQ_CFG_PTLTE_RGID_TABLE_OFFSET(idx))
+#define C_CQ_CFG_PTLTE_RGID_TABLE_SIZE 0x00004000
+
+union c_cq_cfg_ptlte_rgid_table {
+	__u64 qw;
+	struct {
+		__u64 rgid : 8;
+		__u64: 56;
+	};
+};
+
+#define C_CQ_CFG_EQ_RGID_TABLE_OFFSET(idx) (0x00030000 + ((idx) * 8))
+#define C_CQ_CFG_EQ_RGID_TABLE_ENTRIES 2048
+#define C_CQ_CFG_EQ_RGID_TABLE(idx) (C_CQ_BASE + C_CQ_CFG_EQ_RGID_TABLE_OFFSET(idx))
+#define C_CQ_CFG_EQ_RGID_TABLE_SIZE 0x00004000
+
+union c_cq_cfg_eq_rgid_table {
+	__u64 qw;
+	struct {
+		__u64 rgid : 8;
+		__u64: 56;
+	};
+};
+
+#define C_CQ_CFG_TG_THRESH_OFFSET 0x00038000
+#define C_CQ_CFG_TG_THRESH (C_CQ_BASE + C_CQ_CFG_TG_THRESH_OFFSET)
+#define C_CQ_CFG_TG_THRESH_SIZE 0x00000008
+
+union c_cq_cfg_tg_thresh {
+	__u64 qw;
+	struct {
+		struct {
+			__u16 thresh : 14;
+			__u16: 2;
+		} tg[4];
+	};
+};
+
+#define C_CQ_CFG_FQ_RESRV_OFFSET(idx) (0x00039000 + ((idx) * 8))
+#define C_CQ_CFG_FQ_RESRV_ENTRIES 8
+#define C_CQ_CFG_FQ_RESRV(idx) (C_CQ_BASE + C_CQ_CFG_FQ_RESRV_OFFSET(idx))
+#define C_CQ_CFG_FQ_RESRV_SIZE 0x00000040
+
+union c_cq_cfg_fq_resrv {
+	__u64 qw;
+	struct {
+		__u64 num_reserved : 8;
+		__u64 max_alloc : 9;
+		__u64: 3;
+		__u64 num_alloc : 9;
+		__u64: 35;
+	};
+};
+
+#define C_CQ_CFG_THRESH_MAP_OFFSET(idx) (0x00040000 + ((idx) * 8))
+#define C_CQ_CFG_THRESH_MAP_ENTRIES 512
+#define C_CQ_CFG_THRESH_MAP(idx) (C_CQ_BASE + C_CQ_CFG_THRESH_MAP_OFFSET(idx))
+#define C_CQ_CFG_THRESH_MAP_SIZE 0x00001000
+
+union c_cq_cfg_thresh_map {
+	__u64 qw;
+	struct {
+		__u64 thresh_id : 2;
+		__u64: 62;
+	};
+};
+
+#define C_CQ_STS_INIT_DONE_OFFSET 0x00049ff8
+#define C_CQ_STS_INIT_DONE (C_CQ_BASE + C_CQ_STS_INIT_DONE_OFFSET)
+#define C_CQ_STS_INIT_DONE_SIZE 0x00000008
+
+union c_cq_sts_init_done {
+	__u64 qw;
+	struct {
+		__u64 cq_init_done : 1;
+		__u64 tou_init_done : 1;
+		__u64: 62;
+	};
+};
+
+#define C_CQ_STS_TLE_IN_USE_OFFSET(idx) (0x00000850 + ((idx) * 8))
+#define C_CQ_STS_TLE_IN_USE_ENTRIES 4
+#define C_CQ_STS_TLE_IN_USE(idx) (C_CQ_BASE + C_CQ_STS_TLE_IN_USE_OFFSET(idx))
+#define C_CQ_STS_TLE_IN_USE_SIZE 0x00000020
+
+union c_cq_sts_tle_in_use {
+	__u64 qw;
+	struct {
+		__u64 count : 12;
+		__u64: 52;
+	};
+};
+
+#define C_CQ_STS_MAX_TLE_IN_USE_OFFSET(idx) (0x00000870 + ((idx) * 8))
+#define C_CQ_STS_MAX_TLE_IN_USE_ENTRIES 4
+#define C_CQ_STS_MAX_TLE_IN_USE(idx) (C_CQ_BASE + C_CQ_STS_MAX_TLE_IN_USE_OFFSET(idx))
+#define C_CQ_STS_MAX_TLE_IN_USE_SIZE 0x00000020
+
+union c_cq_sts_max_tle_in_use {
+	__u64 qw;
+	struct {
+		__u64 max : 12;
+		__u64: 52;
+	};
+};
+
+#define C_CQ_STS_CREDITS_IN_USE_OFFSET 0x000008b0
+#define C_CQ_STS_CREDITS_IN_USE (C_CQ_BASE + C_CQ_STS_CREDITS_IN_USE_OFFSET)
+#define C_CQ_STS_CREDITS_IN_USE_SIZE 0x00000010
+
+union c_cq_sts_credits_in_use {
+	__u64 qw[2];
+	struct {
+		__u64 lpe_cmd_credits : 10;
+		__u64: 6;
+		__u64 lpe_rcv_fifo_credits : 4;
+		__u64: 4;
+		__u64 ee_event_credits : 5;
+		__u64: 11;
+		__u64 tou_fq_credits : 7;
+		__u64: 1;
+		__u64 tarb_p_credits : 5;
+		__u64: 3;
+		__u64 tarb_np_credits : 5;
+		__u64: 3;
+		__u64 prefetch_tou_credits : 5;
+		__u64: 3;
+		__u64 tou_wb_credits : 5;
+		__u64: 3;
+		__u64 tou_event_credits : 3;
+		__u64: 5;
+		__u64 tgq_cmd_fail_event_credits : 3;
+		__u64: 5;
+		__u64 txq_cmd_fail_event_credits : 4;
+		__u64 tou_cmd_fail_event_credits : 3;
+		__u64: 1;
+		__u64 fq_tot_credits : 9;
+		__u64: 3;
+		__u64 fq_sh_credits : 9;
+		__u64: 3;
+	};
+};
+
+#define C_CQ_STS_EVENT_CNTS_OFFSET(idx) (0x00100000 + ((idx) * 8))
+#ifndef C_CQ_STS_EVENT_CNTS_ENTRIES
+#define C_CQ_STS_EVENT_CNTS_ENTRIES 512
+#endif
+#define C_CQ_STS_EVENT_CNTS(idx) (C_CQ_BASE + C_CQ_STS_EVENT_CNTS_OFFSET(idx))
+#define C_CQ_STS_EVENT_CNTS_SIZE 0x00001000
+
+union c_cq_sts_event_cnts {
+	__u64 qw;
+	struct {
+		__u64 cnt : 56;
+		__u64: 8;
+	};
+};
+
+#define C_EE_CFG_CRNC_OFFSET 0x00000000
+#define C_EE_CFG_CRNC (C_EE_BASE + C_EE_CFG_CRNC_OFFSET)
+#define C_EE_CFG_CRNC_SIZE 0x00000008
+
+union c_ee_cfg_crnc {
+	__u64 qw;
+	struct {
+		__u64 csr_timeout : 8;
+		__u64 mcast_id : 10;
+		__u64: 1;
+		__u64 mcast_enable : 1;
+		__u64 mcast_mask : 10;
+		__u64: 34;
+	};
+};
+
+#define C_EE_CFG_RT_OFFSET_OFFSET 0x00000020
+#define C_EE_CFG_RT_OFFSET (C_EE_BASE + C_EE_CFG_RT_OFFSET_OFFSET)
+#define C_EE_CFG_RT_OFFSET_SIZE 0x00000008
+
+union c_ee_cfg_rt_offset {
+	__u64 qw;
+	struct {
+		__u64 seconds : 48;
+		__u64: 16;
+	};
+};
+
+#define C_EE_MSC_SHADOW_ACTION_OFFSET 0x00000038
+#define C_EE_MSC_SHADOW_ACTION (C_EE_BASE + C_EE_MSC_SHADOW_ACTION_OFFSET)
+#define C_EE_MSC_SHADOW_ACTION_SIZE 0x00000008
+#define C_EE_MSC_SHADOW_OFFSET 0x00000040
+#define C_EE_MSC_SHADOW (C_EE_BASE + C_EE_MSC_SHADOW_OFFSET)
+#define C_EE_MSC_SHADOW_SIZE 0x00000040
+
+union c_ee_msc_shadow {
+	__u64 qw[8];
+};
+
+#define C_EE_ERR_ELAPSED_TIME_OFFSET 0x00000100
+#define C_EE_ERR_ELAPSED_TIME (C_EE_BASE + C_EE_ERR_ELAPSED_TIME_OFFSET)
+#define C_EE_ERR_ELAPSED_TIME_SIZE 0x00000008
+
+union c_ee_err_elapsed_time {
+	__u64 qw;
+	struct {
+		__u64 nanoseconds : 30;
+		__u64 seconds : 34;
+	};
+};
+
+#define C_EE_ERR_FLG_OFFSET 0x00000108
+#define C_EE_ERR_FLG (C_EE_BASE + C_EE_ERR_FLG_OFFSET)
+#define C_EE_ERR_FLG_SIZE 0x00000008
+
+union c_ee_err_flg {
+	__u64 qw;
+	struct {
+		__u64 sw_diag : 1;
+		__u64 crnc_ring_sync_error : 1;
+		__u64 crnc_ring_ecc_sbe : 1;
+		__u64 crnc_ring_ecc_mbe : 1;
+		__u64 crnc_ring_cmd_unknown : 1;
+		__u64 crnc_csr_cmd_unknown : 1;
+		__u64 crnc_csr_cmd_incomplete : 1;
+		__u64 crnc_buf_ecc_sbe : 1;
+		__u64 crnc_buf_ecc_mbe : 1;
+		__u64: 23;
+		__u64 eq_ovflw_rsrvn : 1;
+		__u64 eq_ovflw_fc_sc : 1;
+		__u64 eq_ovflw_ordinary : 1;
+		__u64 eq_dsabld_event : 1;
+		__u64 eq_dsabld_sw_state_wr : 1;
+		__u64 eq_dsabld_lpe_query : 1;
+		__u64 eq_rsrvn_uflw : 1;
+		__u64 unxpctd_trnsltn_rsp : 1;
+		__u64 rarb_hw_err : 1;
+		__u64 rarb_sw_err : 1;
+		__u64 tarb_err : 1;
+		__u64 eq_state_ucor : 1;
+		__u64: 4;
+		__u64 unxpctd_cq_cdt : 1;
+		__u64 unxpctd_tarb_cdt : 1;
+		__u64 eq_state_updt_urun : 1;
+		__u64 eq_state_updt_orun : 1;
+		__u64: 12;
+	};
+};
+
+#define C_EE_ERR_FIRST_FLG_OFFSET 0x00000110
+#define C_EE_ERR_FIRST_FLG (C_EE_BASE + C_EE_ERR_FIRST_FLG_OFFSET)
+#define C_EE_ERR_FIRST_FLG_SIZE 0x00000008
+#define C_EE_ERR_FIRST_FLG_TS_OFFSET 0x00000118
+#define C_EE_ERR_FIRST_FLG_TS (C_EE_BASE + C_EE_ERR_FIRST_FLG_TS_OFFSET)
+#define C_EE_ERR_FIRST_FLG_TS_SIZE 0x00000008
+#define C_EE_ERR_CLR_OFFSET 0x00000120
+#define C_EE_ERR_CLR (C_EE_BASE + C_EE_ERR_CLR_OFFSET)
+#define C_EE_ERR_CLR_SIZE 0x00000008
+#define C_EE_ERR_IRQA_MSK_OFFSET 0x00000128
+#define C_EE_ERR_IRQA_MSK (C_EE_BASE + C_EE_ERR_IRQA_MSK_OFFSET)
+#define C_EE_ERR_IRQA_MSK_SIZE 0x00000008
+#define C_EE_ERR_IRQB_MSK_OFFSET 0x00000130
+#define C_EE_ERR_IRQB_MSK (C_EE_BASE + C_EE_ERR_IRQB_MSK_OFFSET)
+#define C_EE_ERR_IRQB_MSK_SIZE 0x00000008
+#define C_EE_ERR_INFO_MSK_OFFSET 0x00000140
+#define C_EE_ERR_INFO_MSK (C_EE_BASE + C_EE_ERR_INFO_MSK_OFFSET)
+#define C_EE_ERR_INFO_MSK_SIZE 0x00000008
+#define C_EE_EXT_ERR_FLG_OFFSET 0x00000148
+#define C_EE_EXT_ERR_FLG (C_EE_BASE + C_EE_EXT_ERR_FLG_OFFSET)
+#define C_EE_EXT_ERR_FLG_SIZE 0x00000008
+
+union c_ee_ext_err_flg {
+	__u64 qw;
+	struct {
+		__u64 sw_diag : 1;
+		__u64 leo_mem_cor : 1;
+		__u64 pts_mem_cor : 1;
+		__u64 ixe_bus_cor : 1;
+		__u64 lpe_bus_cor : 1;
+		__u64 mst_bus_cor : 1;
+		__u64 pct_bus_cor : 1;
+		__u64 hni_bus_cor : 1;
+		__u64 cq_bus_cor : 1;
+		__u64 eqd_mem_cor : 1;
+		__u64 eqsws_mem_cor : 1;
+		__u64 eqhws_mem_cor : 1;
+		__u64 ecbsb_mem_cor : 1;
+		__u64 ecb_mem_cor : 1;
+		__u64 rarb_hdr_bus_cor : 1;
+		__u64 rarb_data_bus_cor : 1;
+		__u64 acb_vect_cor : 1;
+		__u64 eqswupd_vect_cor : 1;
+		__u64 lm_cbeq_mem_cor : 1;
+		__u64 lm_state_vect_cor : 1;
+		__u64 trnrsp_mem_cor : 1;
+		__u64 trnrsp_bus_cor : 1;
+		__u64 rlscb_vect_cor : 1;
+		__u64 trncb_vect_cor : 1;
+		__u64: 2;
+		__u64 leo_mem_ucor : 1;
+		__u64 pts_mem_ucor : 1;
+		__u64 ixe_bus_ucor : 1;
+		__u64 lpe_bus_ucor : 1;
+		__u64 mst_bus_ucor : 1;
+		__u64 pct_bus_ucor : 1;
+		__u64 hni_bus_ucor : 1;
+		__u64 cq_bus_ucor : 1;
+		__u64 eqd_mem_ucor : 1;
+		__u64 eqsws_mem_ucor : 1;
+		__u64 eqhws_mem_ucor : 1;
+		__u64 ecbsb_mem_ucor : 1;
+		__u64 ecb_mem_ucor : 1;
+		__u64 rarb_hdr_bus_ucor : 1;
+		__u64 rarb_data_bus_ucor : 1;
+		__u64 acb_vect_ucor : 1;
+		__u64 lm_cbeq_mem_ucor : 1;
+		__u64 trnrsp_mem_ucor : 1;
+		__u64 trnrsp_bus_ucor : 1;
+		__u64 rlscb_vect_ucor : 1;
+		__u64 trncb_vect_ucor : 1;
+		__u64: 2;
+		__u64 ixe_to_ee_urun : 1;
+		__u64 ixe_to_ee_orun : 1;
+		__u64 lpe_to_ee_urun : 1;
+		__u64 lpe_to_ee_orun : 1;
+		__u64 mst_to_ee_urun : 1;
+		__u64 mst_to_ee_orun : 1;
+		__u64 pct_to_ee_urun : 1;
+		__u64 pct_to_ee_orun : 1;
+		__u64 hni_to_ee_urun : 1;
+		__u64 hni_to_ee_orun : 1;
+		__u64 cq_to_ee_urun : 1;
+		__u64 cq_to_ee_orun : 1;
+		__u64: 3;
+	};
+};
+
+#define C_EE_EXT_ERR_FIRST_FLG_OFFSET 0x00000150
+#define C_EE_EXT_ERR_FIRST_FLG (C_EE_BASE + C_EE_EXT_ERR_FIRST_FLG_OFFSET)
+#define C_EE_EXT_ERR_FIRST_FLG_SIZE 0x00000008
+#define C_EE_EXT_ERR_FIRST_FLG_TS_OFFSET 0x00000158
+#define C_EE_EXT_ERR_FIRST_FLG_TS (C_EE_BASE + C_EE_EXT_ERR_FIRST_FLG_TS_OFFSET)
+#define C_EE_EXT_ERR_FIRST_FLG_TS_SIZE 0x00000008
+#define C_EE_EXT_ERR_CLR_OFFSET 0x00000160
+#define C_EE_EXT_ERR_CLR (C_EE_BASE + C_EE_EXT_ERR_CLR_OFFSET)
+#define C_EE_EXT_ERR_CLR_SIZE 0x00000008
+#define C_EE_EXT_ERR_IRQA_MSK_OFFSET 0x00000168
+#define C_EE_EXT_ERR_IRQA_MSK (C_EE_BASE + C_EE_EXT_ERR_IRQA_MSK_OFFSET)
+#define C_EE_EXT_ERR_IRQA_MSK_SIZE 0x00000008
+#define C_EE_EXT_ERR_IRQB_MSK_OFFSET 0x00000170
+#define C_EE_EXT_ERR_IRQB_MSK (C_EE_BASE + C_EE_EXT_ERR_IRQB_MSK_OFFSET)
+#define C_EE_EXT_ERR_IRQB_MSK_SIZE 0x00000008
+#define C_EE_EXT_ERR_INFO_MSK_OFFSET 0x00000180
+#define C_EE_EXT_ERR_INFO_MSK (C_EE_BASE + C_EE_EXT_ERR_INFO_MSK_OFFSET)
+#define C_EE_EXT_ERR_INFO_MSK_SIZE 0x00000008
+#define C_EE_ERR_INFO_MEM_OFFSET 0x00000190
+#define C_EE_ERR_INFO_MEM (C_EE_BASE + C_EE_ERR_INFO_MEM_OFFSET)
+#define C_EE_ERR_INFO_MEM_SIZE 0x00000008
+
+union c_ee_err_info_mem {
+	__u64 qw;
+	struct {
+		__u64 cor_syndrome : 12;
+		__u64 cor_address : 11;
+		__u64: 1;
+		__u64 cor_mem_id : 5;
+		__u64: 2;
+		__u64 cor_csr_detected : 1;
+		__u64 ucor_syndrome : 12;
+		__u64 ucor_address : 11;
+		__u64: 1;
+		__u64 ucor_mem_id : 5;
+		__u64: 2;
+		__u64 ucor_csr_detected : 1;
+	};
+};
+
+#define C_EE_ERR_INFO_EQ_CFG_OFFSET 0x00000198
+#define C_EE_ERR_INFO_EQ_CFG (C_EE_BASE + C_EE_ERR_INFO_EQ_CFG_OFFSET)
+#define C_EE_ERR_INFO_EQ_CFG_SIZE 0x00000008
+
+union c_ee_err_info_eq_cfg {
+	__u64 qw;
+	struct {
+		__u64 eq_ovflw_rsrvn : 1;
+		__u64 eq_ovflw_fc_sc : 1;
+		__u64 eq_ovflw_ordinary : 1;
+		__u64 eq_dsabld_event : 1;
+		__u64 eq_dsabld_sw_state_wr : 1;
+		__u64 eq_dsabld_lpe_query : 1;
+		__u64: 2;
+		__u64 event_type : 5;
+		__u64: 3;
+		__u64 eq_handle : 11;
+		__u64: 37;
+	};
+};
+
+#define C_EE_ERR_INFO_RSRVN_UFLW_OFFSET 0x000001a0
+#define C_EE_ERR_INFO_RSRVN_UFLW (C_EE_BASE + C_EE_ERR_INFO_RSRVN_UFLW_OFFSET)
+#define C_EE_ERR_INFO_RSRVN_UFLW_SIZE 0x00000008
+
+union c_ee_err_info_rsrvn_uflw {
+	__u64 qw;
+	struct {
+		__u64: 8;
+		__u64 event_type : 5;
+		__u64: 3;
+		__u64 eq_handle : 11;
+		__u64: 5;
+		__u64 pending_events : 26;
+		__u64: 2;
+		__u64 required_evnt_slots : 3;
+		__u64: 1;
+	};
+};
+
+#define C_EE_ERR_INFO_TRNSLTN_OFFSET 0x000001a8
+#define C_EE_ERR_INFO_TRNSLTN (C_EE_BASE + C_EE_ERR_INFO_TRNSLTN_OFFSET)
+#define C_EE_ERR_INFO_TRNSLTN_SIZE 0x00000008
+
+union c_ee_err_info_trnsltn {
+	__u64 qw;
+	struct {
+		__u64 cb_id : 8;
+		__u64 free : 1;
+		__u64 already_trnsltd : 1;
+		__u64 eq_wr_pending : 1;
+		__u64: 53;
+	};
+};
+
+#define C_EE_ERR_INFO_RARB_OFFSET 0x000001b0
+#define C_EE_ERR_INFO_RARB (C_EE_BASE + C_EE_ERR_INFO_RARB_OFFSET)
+#define C_EE_ERR_INFO_RARB_SIZE 0x00000008
+
+union c_ee_err_info_rarb {
+	__u64 qw;
+	struct {
+		__u64 hdr_ucor : 1;
+		__u64 data_ucor : 1;
+		__u64 bad_vld : 1;
+		__u64 bad_eop : 1;
+		__u64 bad_cmd : 1;
+		__u64 invalid_access : 1;
+		__u64 eq_none : 1;
+		__u64: 1;
+		__u64 first_dw_be : 4;
+		__u64 last_dw_be : 4;
+		__u64 length : 11;
+		__u64: 5;
+		__u64: 2;
+		__u64 addr_29_2 : 28;
+		__u64: 2;
+	};
+};
+
+#define C_EE_ERR_INFO_TARB_OFFSET 0x000001b8
+#define C_EE_ERR_INFO_TARB (C_EE_BASE + C_EE_ERR_INFO_TARB_OFFSET)
+#define C_EE_ERR_INFO_TARB_SIZE 0x00000008
+
+union c_ee_err_info_tarb {
+	__u64 qw;
+	struct {
+		__u64 ecb_mem_ucor : 1;
+		__u64 ecbsb_mem_ucor : 1;
+		__u64 trnrsp_mem_ucor : 1;
+		__u64 trnsltn_err : 1;
+		__u64 evnt_dropped : 1;
+		__u64 irq_dropped : 1;
+		__u64 trnsltn_performed : 1;
+		__u64: 1;
+		__u64 trnsltn_rc : 6;
+		__u64: 2;
+		__u64 acid : 10;
+		__u64: 6;
+		__u64 eq_handle : 11;
+		__u64: 21;
+	};
+};
+
+#define C_EE_ERR_INFO_EQ_UCOR_OFFSET 0x000001c0
+#define C_EE_ERR_INFO_EQ_UCOR (C_EE_BASE + C_EE_ERR_INFO_EQ_UCOR_OFFSET)
+#define C_EE_ERR_INFO_EQ_UCOR_SIZE 0x00000008
+
+union c_ee_err_info_eq_ucor {
+	__u64 qw;
+	struct {
+		__u64 eqd_mem_ucor : 1;
+		__u64 eqsws_mem_ucor : 1;
+		__u64 eqhws_mem_ucor : 1;
+		__u64: 5;
+		__u64 aes_rsn : 4;
+		__u64: 20;
+		__u64 eq_handle : 11;
+		__u64: 21;
+	};
+};
+
+#define C_EE_CFG_TIMESTAMP_FREQ_OFFSET 0x00000410
+#define C_EE_CFG_TIMESTAMP_FREQ (C_EE_BASE + C_EE_CFG_TIMESTAMP_FREQ_OFFSET)
+#define C_EE_CFG_TIMESTAMP_FREQ_SIZE 0x00000008
+
+union c_ee_cfg_timestamp_freq {
+	__u64 qw;
+	struct {
+		__u64 clk_divider : 32;
+		__u64: 32;
+	};
+};
+
+#define C_EE_CFG_INIT_EQ_HW_STATE_OFFSET 0x00000418
+#define C_EE_CFG_INIT_EQ_HW_STATE (C_EE_BASE + C_EE_CFG_INIT_EQ_HW_STATE_OFFSET)
+#define C_EE_CFG_INIT_EQ_HW_STATE_SIZE 0x00000008
+
+union c_ee_cfg_init_eq_hw_state {
+	__u64 qw;
+	struct {
+		__u64 eq_handle : 11;
+		__u64: 5;
+		__u64 pending : 1;
+		__u64: 47;
+	};
+};
+
+#define C_EE_CFG_LATENCY_MONITOR_OFFSET 0x00000420
+#define C_EE_CFG_LATENCY_MONITOR (C_EE_BASE + C_EE_CFG_LATENCY_MONITOR_OFFSET)
+#define C_EE_CFG_LATENCY_MONITOR_SIZE 0x00000020
+
+union c_ee_cfg_latency_monitor {
+	__u64 qw[4];
+	struct {
+		__u64 granularity : 16;
+		__u64: 16;
+		__u64 lt_limit : 9;
+		__u64: 23;
+		__u64 granularity_a : 16;
+		__u64 lt_reduction_a : 9;
+		__u64: 7;
+		__u64 lt_limit_a : 9;
+		__u64: 23;
+		__u64 granularity_b : 16;
+		__u64 lt_reduction_b : 9;
+		__u64: 7;
+		__u64 lt_limit_b : 9;
+		__u64: 23;
+		__u64 thresh_a : 9;
+		__u64: 7;
+		__u64 hysteresis_a : 9;
+		__u64: 7;
+		__u64 thresh_b : 9;
+		__u64: 7;
+		__u64 hysteresis_b : 9;
+		__u64: 7;
+	};
+};
+
+#define C_EE_CFG_EQ_DESCRIPTOR_OFFSET(idx) (0x00020000 + ((idx) * 64))
+#define C_EE_CFG_EQ_DESCRIPTOR_ENTRIES 2048
+#define C_EE_CFG_EQ_DESCRIPTOR(idx) (C_EE_BASE + C_EE_CFG_EQ_DESCRIPTOR_OFFSET(idx))
+#define C_EE_CFG_EQ_DESCRIPTOR_SIZE 0x00020000
+
+union c_ee_cfg_eq_descriptor {
+	__u64 qw[7];
+	struct {
+		__u64 eq_enable : 1;
+		__u64: 7;
+		__u64 cntr_pool_id : 2;
+		__u64: 6;
+		__u64 reserved_fc : 14;
+		__u64: 2;
+		__u64 event_int_idx : 11;
+		__u64: 4;
+		__u64 event_int_en : 1;
+		__u64 latency_tolerance : 9;
+		__u64: 7;
+		__u64 eq_sts_num_thld : 2;
+		__u64: 6;
+		__u64 eq_sts_thld_base : 6;
+		__u64: 2;
+		__u64 eq_sts_thld_offst : 6;
+		__u64: 2;
+		__u64 eq_sts_thld_shift : 5;
+		__u64: 1;
+		__u64 eq_sts_dropped_en : 1;
+		__u64 use_buffer_b : 1;
+		__u64 eq_sts_int_idx : 11;
+		__u64: 4;
+		__u64 eq_sts_int_en : 1;
+		__u64: 16;
+		__u64 buffer_a_size : 20;
+		__u64: 11;
+		__u64 buffer_a_en : 1;
+		__u64 buffer_b_size : 20;
+		__u64: 11;
+		__u64 buffer_b_en : 1;
+		__u64: 12;
+		__u64 buffer_a_addr : 45;
+		__u64: 7;
+		__u64: 12;
+		__u64 buffer_b_addr : 45;
+		__u64: 7;
+		__u64 acid : 10;
+		__u64: 6;
+		__u64 pf_match : 8;
+		__u64 pf_match_shift : 6;
+		__u64: 2;
+		__u64 pf_mask_shift : 6;
+		__u64: 26;
+		__u64: 3;
+		__u64: 61;
+	};
+};
+
+#define C_EE_CFG_EQ_SW_STATE_OFFSET(idx) (0x00004000 + ((idx) * 8))
+#define C_EE_CFG_EQ_SW_STATE_ENTRIES 2048
+#define C_EE_CFG_EQ_SW_STATE(idx) (C_EE_BASE + C_EE_CFG_EQ_SW_STATE_OFFSET(idx))
+#define C_EE_CFG_EQ_SW_STATE_SIZE 0x00004000
+
+union c_ee_cfg_eq_sw_state {
+	__u64 qw;
+	struct {
+		__u64 rd_ptr : 26;
+		__u64: 5;
+		__u64 reading_buffer_b : 1;
+		__u64 event_int_disable : 1;
+		__u64 eq_sts_int_disable : 1;
+		__u64: 6;
+		__u64 event_drop_seq_no : 1;
+		__u64: 3;
+		__u64: 4;
+		__u64: 16;
+	};
+};
+
+#define C_EE_CFG_STS_EQ_HW_STATE_OFFSET(idx) (0x00008000 + ((idx) * 16))
+#define C_EE_CFG_STS_EQ_HW_STATE_ENTRIES 2048
+#define C_EE_CFG_STS_EQ_HW_STATE(idx) (C_EE_BASE + C_EE_CFG_STS_EQ_HW_STATE_OFFSET(idx))
+#define C_EE_CFG_STS_EQ_HW_STATE_SIZE 0x00008000
+
+union c_ee_cfg_sts_eq_hw_state {
+	__u64 qw[2];
+	struct {
+		__u64 wr_ptr : 26;
+		__u64: 5;
+		__u64 writing_buffer_b : 1;
+		__u64 pending_events : 26;
+		__u64: 6;
+		__u64 ecb_idx : 8;
+		__u64 ecb_state : 3;
+		__u64: 5;
+		__u64 eq_switch_dfrd : 1;
+		__u64 eq_switch_pending : 1;
+		__u64 prefetch_pending : 1;
+		__u64 event_int_blkd : 1;
+		__u64 event_dropped : 1;
+		__u64 event_drop_seq_no : 1;
+		__u64: 10;
+		__u64: 2;
+		__u64: 30;
+	};
+};
+
+#define C_EE_CFG_LONG_EVNT_OVR_TABLE_OFFSET(idx) (0x00001000 + ((idx) * 8))
+#define C_EE_CFG_LONG_EVNT_OVR_TABLE_ENTRIES 64
+#define C_EE_CFG_LONG_EVNT_OVR_TABLE(idx) (C_EE_BASE + C_EE_CFG_LONG_EVNT_OVR_TABLE_OFFSET(idx))
+#define C_EE_CFG_LONG_EVNT_OVR_TABLE_SIZE 0x00000200
+
+union c_ee_cfg_long_evnt_ovr_table {
+	__u64 qw;
+};
+
+#define C_EE_CFG_PERIODIC_TSTAMP_TABLE_OFFSET(idx) (0x00001200 + ((idx) * 8))
+#define C_EE_CFG_PERIODIC_TSTAMP_TABLE_ENTRIES 32
+#define C_EE_CFG_PERIODIC_TSTAMP_TABLE(idx) (C_EE_BASE + C_EE_CFG_PERIODIC_TSTAMP_TABLE_OFFSET(idx))
+#define C_EE_CFG_PERIODIC_TSTAMP_TABLE_SIZE 0x00000100
+
+union c_ee_cfg_periodic_tstamp_table {
+	__u64 qw;
+	struct {
+		__u64 n63_n0_enable_periodic_tstamp;
+	};
+};
+
+#define C_EE_STS_INIT_DONE_OFFSET 0x00000828
+#define C_EE_STS_INIT_DONE (C_EE_BASE + C_EE_STS_INIT_DONE_OFFSET)
+#define C_EE_STS_INIT_DONE_SIZE 0x00000008
+
+union c_ee_sts_init_done {
+	__u64 qw;
+	struct {
+		__u64 init_done : 1;
+		__u64 warm_reset : 1;
+		__u64: 62;
+	};
+};
+
+#define C_EE_DBG_ECB_SIDEBAND_OFFSET(idx) (0x00001800 + ((idx) * 8))
+#define C_EE_DBG_ECB_SIDEBAND_ENTRIES 256
+#define C_EE_DBG_ECB_SIDEBAND(idx) (C_EE_BASE + C_EE_DBG_ECB_SIDEBAND_OFFSET(idx))
+#define C_EE_DBG_ECB_SIDEBAND_SIZE 0x00000800
+
+union c_ee_dbg_ecb_sideband {
+	__u64 qw;
+	struct {
+		__u64: 6;
+		__u64 addr_11_6 : 6;
+		__u64: 4;
+		__u64 acid : 10;
+		__u64: 4;
+		__u64 trnsltn : 1;
+		__u64 data_present : 1;
+		__u64 eq_handle : 11;
+		__u64: 5;
+		__u64 int_idx : 11;
+		__u64: 2;
+		__u64 int_present : 1;
+		__u64 block_tarb : 1;
+		__u64: 1;
+	};
+};
+
+#define C_EE_DBG_ECB_OFFSET(idx) (0x00010000 + ((idx) * 64))
+#define C_EE_DBG_ECB_ENTRIES 256
+#define C_EE_DBG_ECB(idx) (C_EE_BASE + C_EE_DBG_ECB_OFFSET(idx))
+#define C_EE_DBG_ECB_SIZE 0x00004000
+
+union c_ee_dbg_ecb {
+	__u64 qw[8];
+};
+
+#define C_EE_DBG_TRNSLTN_RSP_OFFSET(idx) (0x00002000 + ((idx) * 8))
+#define C_EE_DBG_TRNSLTN_RSP_ENTRIES 256
+#define C_EE_DBG_TRNSLTN_RSP(idx) (C_EE_BASE + C_EE_DBG_TRNSLTN_RSP_OFFSET(idx))
+#define C_EE_DBG_TRNSLTN_RSP_SIZE 0x00000800
+
+union c_ee_dbg_trnsltn_rsp {
+	__u64 qw;
+	struct {
+		__u64 return_code : 6;
+		__u64: 2;
+		__u64 at_type : 1;
+		__u64 nsa : 1;
+		__u64 at_epoch : 1;
+		__u64: 1;
+		__u64 addr_pg : 45;
+		__u64: 4;
+		__u64: 3;
+	};
+};
+
+#define C_EE_DBG_LM_CB_TO_EQ_MAP_OFFSET(idx) (0x00002800 + ((idx) * 8))
+#define C_EE_DBG_LM_CB_TO_EQ_MAP_ENTRIES 256
+#define C_EE_DBG_LM_CB_TO_EQ_MAP(idx) (C_EE_BASE + C_EE_DBG_LM_CB_TO_EQ_MAP_OFFSET(idx))
+#define C_EE_DBG_LM_CB_TO_EQ_MAP_SIZE 0x00000800
+
+union c_ee_dbg_lm_cb_to_eq_map {
+	__u64 qw;
+	struct {
+		__u64 eq_handle : 11;
+		__u64: 53;
+	};
+};
+
+#define C_HNI_CFG_CRNC_OFFSET 0x00000000
+#define C_HNI_CFG_CRNC (C_HNI_BASE + C_HNI_CFG_CRNC_OFFSET)
+#define C_HNI_CFG_CRNC_SIZE 0x00000008
+
+union c_hni_cfg_crnc {
+	__u64 qw;
+	struct {
+		__u64 csr_timeout : 8;
+		__u64 mcast_id : 10;
+		__u64: 1;
+		__u64 mcast_enable : 1;
+		__u64 mcast_mask : 10;
+		__u64: 34;
+	};
+};
+
+#define C_HNI_CFG_RT_OFFSET_OFFSET 0x00000020
+#define C_HNI_CFG_RT_OFFSET (C_HNI_BASE + C_HNI_CFG_RT_OFFSET_OFFSET)
+#define C_HNI_CFG_RT_OFFSET_SIZE 0x00000008
+
+union c_hni_cfg_rt_offset {
+	__u64 qw;
+	struct {
+		__u64 seconds : 48;
+		__u64: 16;
+	};
+};
+
+#define C_HNI_MSC_SHADOW_ACTION_OFFSET 0x00000038
+#define C_HNI_MSC_SHADOW_ACTION (C_HNI_BASE + C_HNI_MSC_SHADOW_ACTION_OFFSET)
+#define C_HNI_MSC_SHADOW_ACTION_SIZE 0x00000008
+#define C_HNI_MSC_SHADOW_OFFSET 0x00000040
+#define C_HNI_MSC_SHADOW (C_HNI_BASE + C_HNI_MSC_SHADOW_OFFSET)
+#define C_HNI_MSC_SHADOW_SIZE 0x00000008
+
+union c_hni_msc_shadow {
+	__u64 qw[C_HNI_MSC_SHADOW_SIZE / sizeof(__u64)];
+};
+
+#define C_HNI_ERR_ELAPSED_TIME_OFFSET 0x00000100
+#define C_HNI_ERR_ELAPSED_TIME (C_HNI_BASE + C_HNI_ERR_ELAPSED_TIME_OFFSET)
+#define C_HNI_ERR_ELAPSED_TIME_SIZE 0x00000008
+
+union c_hni_err_elapsed_time {
+	__u64 qw;
+	struct {
+		__u64 nanoseconds : 30;
+		__u64 seconds : 34;
+	};
+};
+
+#define C1_HNI_ERR_FLG_OFFSET 0x00000108
+#define C1_HNI_ERR_FLG (C_HNI_BASE + C1_HNI_ERR_FLG_OFFSET)
+#define C1_HNI_ERR_FLG_SIZE 0x00000008
+
+union c1_hni_err_flg {
+	__u64 qw;
+	struct {
+		__u64 sw_diag : 1;
+		__u64 crnc_ring_sync_error : 1;
+		__u64 crnc_ring_ecc_sbe : 1;
+		__u64 crnc_ring_ecc_mbe : 1;
+		__u64 crnc_ring_cmd_unknown : 1;
+		__u64 crnc_csr_cmd_unknown : 1;
+		__u64 crnc_csr_cmd_incomplete : 1;
+		__u64 crnc_buf_ecc_sbe : 1;
+		__u64 crnc_buf_ecc_mbe : 1;
+		__u64: 1;
+		__u64 event_cnt_ovf : 1;
+		__u64 llr_flit_cor : 1;
+		__u64 rx_stat_fifo_cor : 1;
+		__u64 rx_pkt_fifo_cor : 1;
+		__u64 timestamp_cor : 1;
+		__u64 hrp_fifo_cor : 1;
+		__u64 fgfc_fifo_cor : 1;
+		__u64 tx_flit_cor : 1;
+		__u64 event_ram_cor : 1;
+		__u64 llr_flit_ucor : 1;
+		__u64 rx_stat_fifo_ucor : 1;
+		__u64 rx_pkt_fifo_ucor : 1;
+		__u64 timestamp_ucor : 1;
+		__u64 hrp_fifo_ucor : 1;
+		__u64 fgfc_fifo_ucor : 1;
+		__u64 tx_flit_ucor : 1;
+		__u64 event_ram_ucor : 1;
+		__u64 fifo_err : 1;
+		__u64 llr_chksum_bad : 1;
+		__u64 llr_fcs_bad : 1;
+		__u64 llr_ctrl_perr : 1;
+		__u64 llr_exceed_mfs : 1;
+		__u64 llr_eopb : 1;
+		__u64 rx_ctrl_perr : 1;
+		__u64 pause_timeout : 1;
+		__u64 fgfc_err : 1;
+		__u64 credit_uflw : 1;
+		__u64 tx_ctrl_perr : 1;
+		__u64 tx_size_err : 1;
+		__u64 rx_pause_err : 1;
+		__u64 pfc_fifo_oflw : 8;
+		__u64 discard_err : 8;
+		__u64 disable_err : 8;
+	};
+};
+
+#define C2_HNI_ERR_FLG_OFFSET 0x00000108
+#define C2_HNI_ERR_FLG (C_HNI_BASE + C2_HNI_ERR_FLG_OFFSET)
+#define C2_HNI_ERR_FLG_SIZE 0x00000008
+
+union c2_hni_err_flg {
+	__u64 qw;
+	struct {
+		__u64 sw_diag : 1;
+		__u64 crnc_ring_sync_error : 1;
+		__u64 crnc_ring_ecc_sbe : 1;
+		__u64 crnc_ring_ecc_mbe : 1;
+		__u64 crnc_ring_cmd_unknown : 1;
+		__u64 crnc_csr_cmd_unknown : 1;
+		__u64 crnc_csr_cmd_incomplete : 1;
+		__u64 crnc_buf_ecc_sbe : 1;
+		__u64 crnc_buf_ecc_mbe : 1;
+		__u64: 1;
+		__u64 event_cnt_ovf : 1;
+		__u64 llr_flit_cor : 1;
+		__u64 rx_stat_fifo_cor : 1;
+		__u64 rx_pkt_fifo_cor : 1;
+		__u64 timestamp_cor : 1;
+		__u64 hrp_fifo_cor : 1;
+		__u64 fgfc_fifo_cor : 1;
+		__u64 tx_flit_cor : 1;
+		__u64 event_ram_cor : 1;
+		__u64 ixe_flit_cor : 1;
+		__u64 llr_flit_ucor : 1;
+		__u64 rx_stat_fifo_ucor : 1;
+		__u64 rx_pkt_fifo_ucor : 1;
+		__u64 timestamp_ucor : 1;
+		__u64 hrp_fifo_ucor : 1;
+		__u64 fgfc_fifo_ucor : 1;
+		__u64 tx_flit_ucor : 1;
+		__u64 event_ram_ucor : 1;
+		__u64 ixe_flit_ucor : 1;
+		__u64 fifo_err : 1;
+		__u64 llr_chksum_bad : 1;
+		__u64 llr_fcs_bad : 1;
+		__u64 llr_ctrl_perr : 1;
+		__u64 llr_exceed_mfs : 1;
+		__u64 llr_eopb : 1;
+		__u64 pause_timeout : 1;
+		__u64 fgfc_err : 1;
+		__u64 credit_uflw : 1;
+		__u64 tx_size_err : 1;
+		__u64 rx_pause_err : 1;
+		__u64 pfc_fifo_oflw : 8;
+		__u64 discard_err : 8;
+		__u64 disable_err : 8;
+	};
+};
+
+#define C_HNI_ERR_FIRST_FLG_OFFSET 0x00000110
+#define C_HNI_ERR_FIRST_FLG (C_HNI_BASE + C_HNI_ERR_FIRST_FLG_OFFSET)
+#define C_HNI_ERR_FIRST_FLG_SIZE 0x00000008
+#define C_HNI_ERR_FIRST_FLG_TS_OFFSET 0x00000118
+#define C_HNI_ERR_FIRST_FLG_TS (C_HNI_BASE + C_HNI_ERR_FIRST_FLG_TS_OFFSET)
+#define C_HNI_ERR_FIRST_FLG_TS_SIZE 0x00000008
+#define C_HNI_ERR_CLR_OFFSET 0x00000120
+#define C_HNI_ERR_CLR (C_HNI_BASE + C_HNI_ERR_CLR_OFFSET)
+#define C_HNI_ERR_CLR_SIZE 0x00000008
+#define C_HNI_ERR_IRQA_MSK_OFFSET 0x00000128
+#define C_HNI_ERR_IRQA_MSK (C_HNI_BASE + C_HNI_ERR_IRQA_MSK_OFFSET)
+#define C_HNI_ERR_IRQA_MSK_SIZE 0x00000008
+#define C_HNI_ERR_IRQB_MSK_OFFSET 0x00000130
+#define C_HNI_ERR_IRQB_MSK (C_HNI_BASE + C_HNI_ERR_IRQB_MSK_OFFSET)
+#define C_HNI_ERR_IRQB_MSK_SIZE 0x00000008
+#define C_HNI_ERR_INFO_MSK_OFFSET 0x00000140
+#define C_HNI_ERR_INFO_MSK (C_HNI_BASE + C_HNI_ERR_INFO_MSK_OFFSET)
+#define C_HNI_ERR_INFO_MSK_SIZE 0x00000008
+#define C1_HNI_ERR_INFO_ECC_OFFSET 0x00000180
+#define C1_HNI_ERR_INFO_ECC (C_HNI_BASE + C1_HNI_ERR_INFO_ECC_OFFSET)
+#define C1_HNI_ERR_INFO_ECC_SIZE 0x00000008
+
+union c1_hni_err_info_ecc {
+	__u64 qw;
+	struct {
+		__u64 cor_syndrome : 11;
+		__u64: 1;
+		__u64 cor_address : 9;
+		__u64: 3;
+		__u64 cor_id : 3;
+		__u64: 4;
+		__u64 cor_csr_detected : 1;
+		__u64 ucor_syndrome : 11;
+		__u64: 1;
+		__u64 ucor_address : 9;
+		__u64: 3;
+		__u64 ucor_id : 3;
+		__u64: 4;
+		__u64 ucor_csr_detected : 1;
+	};
+};
+
+#define C2_HNI_ERR_INFO_ECC_OFFSET 0x00000188
+#define C2_HNI_ERR_INFO_ECC (C_HNI_BASE + C2_HNI_ERR_INFO_ECC_OFFSET)
+#define C2_HNI_ERR_INFO_ECC_SIZE 0x00000008
+
+union c2_hni_err_info_ecc {
+	__u64 qw;
+	struct {
+		__u64 cor_syndrome : 11;
+		__u64: 1;
+		__u64 cor_address : 9;
+		__u64: 3;
+		__u64 cor_id : 4;
+		__u64: 3;
+		__u64 cor_csr_detected : 1;
+		__u64 ucor_syndrome : 11;
+		__u64: 1;
+		__u64 ucor_address : 9;
+		__u64: 3;
+		__u64 ucor_id : 4;
+		__u64: 3;
+		__u64 ucor_csr_detected : 1;
+	};
+};
+
+#define C1_HNI_ERR_INFO_FIFO_OFFSET 0x00000188
+#define C1_HNI_ERR_INFO_FIFO (C_HNI_BASE + C1_HNI_ERR_INFO_FIFO_OFFSET)
+#define C_HNI_ERR_INFO_FIFO_SIZE 0x00000008
+#define C1_HNI_ERR_INFO_FIFO_SIZE C_HNI_ERR_INFO_FIFO_SIZE
+
+union c_hni_err_info_fifo {
+	__u64 qw;
+	struct {
+		__u64 overrun : 1;
+		__u64 underrun : 1;
+		__u64: 2;
+		__u64 fifo_id : 3;
+		__u64: 57;
+	};
+};
+
+#define C2_HNI_ERR_INFO_FIFO_OFFSET 0x00000190
+#define C2_HNI_ERR_INFO_FIFO (C_HNI_BASE + C2_HNI_ERR_INFO_FIFO_OFFSET)
+#define C2_HNI_ERR_INFO_FIFO_SIZE C_HNI_ERR_INFO_FIFO_SIZE
+
+#define C1_HNI_ERR_INFO_CC_OFFSET 0x00000190
+#define C1_HNI_ERR_INFO_CC (C_HNI_BASE + C1_HNI_ERR_INFO_CC_OFFSET)
+#define C_HNI_ERR_INFO_CC_SIZE 0x00000008
+#define C1_HNI_ERR_INFO_CC_SIZE C_HNI_ERR_INFO_CC_SIZE
+
+union c_hni_err_info_cc {
+	__u64 qw;
+	struct {
+		__u64 cc_id : 3;
+		__u64: 1;
+		__u64 cc_tc : 3;
+		__u64: 57;
+	};
+};
+
+#define C2_HNI_ERR_INFO_CC_OFFSET 0x00000198
+#define C2_HNI_ERR_INFO_CC (C_HNI_BASE + C2_HNI_ERR_INFO_CC_OFFSET)
+#define C2_HNI_ERR_INFO_CC_SIZE C_HNI_ERR_INFO_CC_SIZE
+
+#define C1_HNI_ERR_INFO_FGFC_OFFSET 0x00000198
+#define C1_HNI_ERR_INFO_FGFC (C_HNI_BASE + C1_HNI_ERR_INFO_FGFC_OFFSET)
+#define C_HNI_ERR_INFO_FGFC_SIZE 0x00000008
+#define C1_HNI_ERR_INFO_FGFC_SIZE C_HNI_ERR_INFO_FGFC_SIZE
+
+union c_hni_err_info_fgfc {
+	__u64 qw;
+	struct {
+		__u64 invalid_type : 1;
+		__u64 no_match : 1;
+		__u64 cache_full : 1;
+		__u64 fifo_full : 1;
+		__u64: 60;
+	};
+};
+
+#define C2_HNI_ERR_INFO_FGFC_OFFSET 0x000001a0
+#define C2_HNI_ERR_INFO_FGFC (C_HNI_BASE + C2_HNI_ERR_INFO_FGFC_OFFSET)
+#define C2_HNI_ERR_INFO_FGFC_SIZE C_HNI_ERR_INFO_FGFC_SIZE
+
+#define C1_HNI_ERR_INFO_SIZE_ERR_OFFSET 0x000001a0
+#define C1_HNI_ERR_INFO_SIZE_ERR (C_HNI_BASE + C1_HNI_ERR_INFO_SIZE_ERR_OFFSET)
+#define C_HNI_ERR_INFO_SIZE_ERR_SIZE 0x00000008
+#define C1_HNI_ERR_INFO_SIZE_ERR_SIZE C_HNI_ERR_INFO_SIZE_ERR_SIZE
+
+union c_hni_err_info_size_err {
+	__u64 qw;
+	struct {
+		__u64 opt_too_small : 1;
+		__u64 std_too_small : 1;
+		__u64 opt_too_big : 1;
+		__u64 std_too_big : 1;
+		__u64: 60;
+	};
+};
+
+#define C2_HNI_ERR_INFO_SIZE_ERR_OFFSET 0x000001a8
+#define C2_HNI_ERR_INFO_SIZE_ERR (C_HNI_BASE + C2_HNI_ERR_INFO_SIZE_ERR_OFFSET)
+#define C2_HNI_ERR_INFO_SIZE_ERR_SIZE C_HNI_ERR_INFO_SIZE_ERR_SIZE
+
+#define C1_HNI_ERR_INFO_DISCARD_OFFSET 0x00000200
+#define C1_HNI_ERR_INFO_DISCARD (C_HNI_BASE + C1_HNI_ERR_INFO_DISCARD_OFFSET)
+#define C_HNI_ERR_INFO_DISCARD_SIZE 0x00000018
+#define C1_HNI_ERR_INFO_DISCARD_SIZE C_HNI_ERR_INFO_DISCARD_SIZE
+
+union c_hni_err_info_discard {
+	__u64 qw[3];
+	struct {
+		__u64 addr_low;
+		__u64 addr_high;
+		__u64 tc : 3;
+		__u64: 1;
+		__u64 pkt_type : 2;
+		__u64: 58;
+	};
+};
+
+#define C2_HNI_ERR_INFO_DISCARD_OFFSET 0x000001b0
+#define C2_HNI_ERR_INFO_DISCARD (C_HNI_BASE + C2_HNI_ERR_INFO_DISCARD_OFFSET)
+#define C2_HNI_ERR_INFO_DISCARD_SIZE C_HNI_ERR_INFO_DISCARD_SIZE
+
+#define C_HNI_CFG_GEN_OFFSET 0x00000400
+#define C_HNI_CFG_GEN (C_HNI_BASE + C_HNI_CFG_GEN_OFFSET)
+#define C_HNI_CFG_GEN_SIZE 0x00000008
+
+union c_hni_cfg_gen {
+	__u64 qw;
+	struct {
+		__u64 tx_timestamp_en : 1;
+		__u64 rx_timestamp_en : 1;
+		__u64 timestamp_fmt : 2;
+		__u64 default_pcp : 3;
+		__u64 ip_enable_dscp : 1;
+		__u64 default_dscp : 6;
+		__u64: 50;
+	};
+};
+
+#define C_HNI_CFG_CDT_OFFSET 0x00000408
+#define C_HNI_CFG_CDT (C_HNI_BASE + C_HNI_CFG_CDT_OFFSET)
+#define C_HNI_CFG_CDT_SIZE 0x00000008
+
+union c_hni_cfg_cdt {
+	__u64 qw;
+	struct {
+		__u64 ixe_cdts : 6;
+		__u64: 2;
+		__u64 hrp_cdts : 5;
+		__u64: 3;
+		__u64 llr_cdts : 4;
+		__u64: 4;
+		__u64 ee_cdts : 5;
+		__u64: 3;
+		__u64 ixe_pbuf_size : 13;
+		__u64: 19;
+	};
+};
+
+#define C_HNI_CFG_TXTS_L2_MASK_OFFSET 0x00000430
+#define C_HNI_CFG_TXTS_L2_MASK (C_HNI_BASE + C_HNI_CFG_TXTS_L2_MASK_OFFSET)
+#define C_HNI_CFG_TXTS_L2_MASK_SIZE 0x00000008
+
+union c_hni_cfg_txts_l2_mask {
+	__u64 qw;
+	struct {
+		__u64 dmac : 48;
+		__u64 ethertype : 16;
+	};
+};
+
+#define C_HNI_CFG_TXTS_L2_MATCH_OFFSET 0x00000438
+#define C_HNI_CFG_TXTS_L2_MATCH (C_HNI_BASE + C_HNI_CFG_TXTS_L2_MATCH_OFFSET)
+#define C_HNI_CFG_TXTS_L2_MATCH_SIZE 0x00000008
+
+union c_hni_cfg_txts_l2_match {
+	__u64 qw;
+	struct {
+		__u64 dmac : 48;
+		__u64 ethertype : 16;
+	};
+};
+
+#define C_HNI_CFG_TXTS_L3_MASK_OFFSET 0x00000440
+#define C_HNI_CFG_TXTS_L3_MASK (C_HNI_BASE + C_HNI_CFG_TXTS_L3_MASK_OFFSET)
+#define C_HNI_CFG_TXTS_L3_MASK_SIZE 0x00000008
+
+union c_hni_cfg_txts_l3_mask {
+	__u64 qw;
+	struct {
+		__u64 hdr;
+	};
+};
+
+#define C_HNI_CFG_TXTS_L3_MATCH_OFFSET 0x00000448
+#define C_HNI_CFG_TXTS_L3_MATCH (C_HNI_BASE + C_HNI_CFG_TXTS_L3_MATCH_OFFSET)
+#define C_HNI_CFG_TXTS_L3_MATCH_SIZE 0x00000008
+
+union c_hni_cfg_txts_l3_match {
+	__u64 qw;
+	struct {
+		__u64 hdr;
+	};
+};
+
+#define C_HNI_CFG_RXTS_L2_MASK_OFFSET 0x00000450
+#define C_HNI_CFG_RXTS_L2_MASK (C_HNI_BASE + C_HNI_CFG_RXTS_L2_MASK_OFFSET)
+#define C_HNI_CFG_RXTS_L2_MASK_SIZE 0x00000008
+
+union c_hni_cfg_rxts_l2_mask {
+	__u64 qw;
+	struct {
+		__u64 dmac : 48;
+		__u64 ethertype : 16;
+	};
+};
+
+#define C_HNI_CFG_RXTS_L2_MATCH_OFFSET 0x00000458
+#define C_HNI_CFG_RXTS_L2_MATCH (C_HNI_BASE + C_HNI_CFG_RXTS_L2_MATCH_OFFSET)
+#define C_HNI_CFG_RXTS_L2_MATCH_SIZE 0x00000008
+
+union c_hni_cfg_rxts_l2_match {
+	__u64 qw;
+	struct {
+		__u64 dmac : 48;
+		__u64 ethertype : 16;
+	};
+};
+
+#define C_HNI_CFG_RXTS_L3_MASK_OFFSET 0x00000460
+#define C_HNI_CFG_RXTS_L3_MASK (C_HNI_BASE + C_HNI_CFG_RXTS_L3_MASK_OFFSET)
+#define C_HNI_CFG_RXTS_L3_MASK_SIZE 0x00000008
+
+union c_hni_cfg_rxts_l3_mask {
+	__u64 qw;
+	struct {
+		__u64 hdr;
+	};
+};
+
+#define C_HNI_CFG_RXTS_L3_MATCH_OFFSET 0x00000468
+#define C_HNI_CFG_RXTS_L3_MATCH (C_HNI_BASE + C_HNI_CFG_RXTS_L3_MATCH_OFFSET)
+#define C_HNI_CFG_RXTS_L3_MATCH_SIZE 0x00000008
+
+union c_hni_cfg_rxts_l3_match {
+	__u64 qw;
+	struct {
+		__u64 hdr;
+	};
+};
+
+#define C_HNI_CFG_PAUSE_QUANTA_OFFSET 0x00000470
+#define C_HNI_CFG_PAUSE_QUANTA (C_HNI_BASE + C_HNI_CFG_PAUSE_QUANTA_OFFSET)
+#define C_HNI_CFG_PAUSE_QUANTA_SIZE 0x00000008
+
+union c_hni_cfg_pause_quanta {
+	__u64 qw;
+	struct {
+		__u64 sub_value : 24;
+		__u64 sub_period : 8;
+		__u64: 32;
+	};
+};
+
+#define C_HNI_CFG_PAUSE_TIMING_OFFSET 0x00000478
+#define C_HNI_CFG_PAUSE_TIMING (C_HNI_BASE + C_HNI_CFG_PAUSE_TIMING_OFFSET)
+#define C_HNI_CFG_PAUSE_TIMING_SIZE 0x00000008
+
+union c_hni_cfg_pause_timing {
+	__u64 qw;
+	struct {
+		__u64 pause_period : 16;
+		__u64 pause_repeat_period : 16;
+		__u64: 32;
+	};
+};
+
+#define C_HNI_CFG_PAUSE_TX_CTRL_OFFSET 0x00000490
+#define C_HNI_CFG_PAUSE_TX_CTRL (C_HNI_BASE + C_HNI_CFG_PAUSE_TX_CTRL_OFFSET)
+#define C_HNI_CFG_PAUSE_TX_CTRL_SIZE 0x00000008
+
+union c_hni_cfg_pause_tx_ctrl {
+	__u64 qw;
+	struct {
+		__u64 mac_cntl_opcode : 16;
+		__u64 mac_cntl_type : 16;
+		__u64 enable_send_pause : 8;
+		__u64 pev : 8;
+		__u64 enable_pause : 1;
+		__u64 enable_pfc_pause : 1;
+		__u64: 14;
+	};
+};
+
+#define C_HNI_CFG_PAUSE_RX_CTRL_OFFSET 0x00000498
+#define C_HNI_CFG_PAUSE_RX_CTRL (C_HNI_BASE + C_HNI_CFG_PAUSE_RX_CTRL_OFFSET)
+#define C_HNI_CFG_PAUSE_RX_CTRL_SIZE 0x00000008
+
+union c_hni_cfg_pause_rx_ctrl {
+	__u64 qw;
+	struct {
+		__u64 enable_rec_pause : 8;
+		__u64 pause_rec_enable : 1;
+		__u64 pfc_rec_enable : 1;
+		__u64: 2;
+		__u64 timer_bit : 5;
+		__u64: 47;
+	};
+};
+
+#define C_HNI_CFG_MAX_SIZES_OFFSET 0x000004a8
+#define C_HNI_CFG_MAX_SIZES (C_HNI_BASE + C_HNI_CFG_MAX_SIZES_OFFSET)
+#define C_HNI_CFG_MAX_SIZES_SIZE 0x00000008
+
+union c_hni_cfg_max_sizes {
+	__u64 qw;
+	struct {
+		__u64 max_std_size : 14;
+		__u64: 2;
+		__u64 max_opt_size : 14;
+		__u64: 2;
+		__u64 max_portals_size : 14;
+		__u64: 18;
+	};
+};
+
+#define C_HNI_CFG_EVENT_CNTS_OFFSET 0x000004b8
+#define C_HNI_CFG_EVENT_CNTS (C_HNI_BASE + C_HNI_CFG_EVENT_CNTS_OFFSET)
+#define C_HNI_CFG_EVENT_CNTS_SIZE 0x00000008
+
+union c_hni_cfg_event_cnts {
+	__u64 qw;
+	struct {
+		__u64 enable : 1;
+		__u64 init : 1;
+		__u64 init_done : 1;
+		__u64: 1;
+		__u64 ovf_cnt : 16;
+		__u64: 44;
+	};
+};
+
+#define C_HNI_CFG_PBUF_OFFSET(idx) (0x00000500 + ((idx) * 8))
+#define C_HNI_CFG_PBUF_ENTRIES 8
+#define C_HNI_CFG_PBUF(idx) (C_HNI_BASE + C_HNI_CFG_PBUF_OFFSET(idx))
+#define C_HNI_CFG_PBUF_SIZE 0x00000040
+
+union c_hni_cfg_pbuf {
+	__u64 qw;
+	struct {
+		__u64 static_rsvd : 12;
+		__u64: 4;
+		__u64 mtu : 7;
+		__u64: 41;
+	};
+};
+
+#define C1_HNI_CFG_PFC_BUF_OFFSET(idx) (0x00000580 + ((idx) * 8))
+#define C1_HNI_CFG_PFC_BUF_ENTRIES 8
+#define C1_HNI_CFG_PFC_BUF(idx) (C_HNI_BASE + C1_HNI_CFG_PFC_BUF_OFFSET(idx))
+#define C1_HNI_CFG_PFC_BUF_SIZE 0x00000040
+
+union c1_hni_cfg_pfc_buf {
+	__u64 qw;
+	struct {
+		__u64 low_water : 11;
+		__u64: 1;
+		__u64 high_water : 11;
+		__u64: 1;
+		__u64 timer_bit : 5;
+		__u64: 3;
+		__u64 discard_max : 3;
+		__u64: 1;
+		__u64 resume : 1;
+		__u64: 27;
+	};
+};
+
+#define C2_HNI_CFG_PFC_BUF_OFFSET(idx) (0x00000580 + ((idx) * 8))
+#define C2_HNI_CFG_PFC_BUF_ENTRIES 8
+#define C2_HNI_CFG_PFC_BUF(idx) (C_HNI_BASE + C2_HNI_CFG_PFC_BUF_OFFSET(idx))
+#define C2_HNI_CFG_PFC_BUF_SIZE 0x00000040
+
+union c2_hni_cfg_pfc_buf {
+	__u64 qw;
+	struct {
+		__u64 low_water : 12;
+		__u64 high_water : 12;
+		__u64 timer_bit : 5;
+		__u64: 3;
+		__u64 discard_max : 3;
+		__u64: 1;
+		__u64 resume : 1;
+		__u64: 27;
+	};
+};
+
+#define C_HNI_CFG_DSCP_PCP_OFFSET(idx) (0x00000800 + ((idx) * 8))
+#define C_HNI_CFG_DSCP_PCP_ENTRIES 64
+#define C_HNI_CFG_DSCP_PCP(idx) (C_HNI_BASE + C_HNI_CFG_DSCP_PCP_OFFSET(idx))
+#define C_HNI_CFG_DSCP_PCP_SIZE 0x00000200
+
+union c_hni_cfg_dscp_pcp {
+	__u64 qw;
+	struct {
+		__u64 pcp : 3;
+		__u64: 61;
+	};
+};
+
+#define C_HNI_STS_CDT_OFFSET 0x00001000
+#define C_HNI_STS_CDT (C_HNI_BASE + C_HNI_STS_CDT_OFFSET)
+#define C_HNI_STS_CDT_SIZE 0x00000008
+
+union c_hni_sts_cdt {
+	__u64 qw;
+	struct {
+		__u64 ixe_cdts : 6;
+		__u64: 2;
+		__u64 hrp_cdts : 5;
+		__u64: 3;
+		__u64 llr_cdts : 4;
+		__u64: 4;
+		__u64 ee_cdts : 5;
+		__u64: 3;
+		__u64 buf_cdts : 13;
+		__u64: 19;
+	};
+};
+
+#define C_HNI_STS_PAUSE_TIMEOUT_OFFSET 0x00001008
+#define C_HNI_STS_PAUSE_TIMEOUT (C_HNI_BASE + C_HNI_STS_PAUSE_TIMEOUT_OFFSET)
+#define C_HNI_STS_PAUSE_TIMEOUT_SIZE 0x00000008
+
+union c_hni_sts_pause_timeout {
+	__u64 qw;
+	struct {
+		__u64 pfc_0 : 4;
+		__u64 pfc_1 : 4;
+		__u64 pfc_2 : 4;
+		__u64 pfc_3 : 4;
+		__u64 pfc_4 : 4;
+		__u64 pfc_5 : 4;
+		__u64 pfc_6 : 4;
+		__u64 pfc_7 : 4;
+		__u64: 32;
+	};
+};
+
+#define C_HNI_STS_EVENT_CNTS_OFFSET(idx) (0x00002000 + ((idx) * 8))
+#ifndef C_HNI_STS_EVENT_CNTS_ENTRIES
+#define C_HNI_STS_EVENT_CNTS_ENTRIES 512
+#endif
+#define C_HNI_STS_EVENT_CNTS(idx) (C_HNI_BASE + C_HNI_STS_EVENT_CNTS_OFFSET(idx))
+#define C_HNI_STS_EVENT_CNTS_SIZE 0x00001000
+
+union c_hni_sts_event_cnts {
+	__u64 qw;
+	struct {
+		__u64 cnt : 56;
+		__u64: 8;
+	};
+};
+
+#define C_HNI_UC_SBR_INTR_OFFSET 0x00004310
+#define C_HNI_UC_SBR_INTR (C_HNI_BASE + C_HNI_UC_SBR_INTR_OFFSET)
+#define C_HNI_UC_SBR_INTR_SIZE 0x00000008
+
+union c_hni_uc_sbr_intr {
+	__u64 qw;
+	struct {
+		__u64 intr : 8;
+		__u64 send_sbr : 1;
+		__u64 send_sbr_dis : 1;
+		__u64: 54;
+	};
+};
+
+#define C_HNI_PML_CFG_CRNC_OFFSET 0x00000000
+#define C_HNI_PML_CFG_CRNC (C_HNI_PML_BASE + C_HNI_PML_CFG_CRNC_OFFSET)
+#define C_HNI_PML_CFG_CRNC_SIZE 0x00000008
+
+union c_hni_pml_cfg_crnc {
+	__u64 qw;
+	struct {
+		__u64 csr_timeout : 8;
+		__u64 mcast_id : 10;
+		__u64: 1;
+		__u64 mcast_enable : 1;
+		__u64 mcast_mask : 10;
+		__u64: 34;
+	};
+};
+
+#define C_HNI_PML_ERR_ELAPSED_TIME_OFFSET 0x00000100
+#define C_HNI_PML_ERR_ELAPSED_TIME (C_HNI_PML_BASE + C_HNI_PML_ERR_ELAPSED_TIME_OFFSET)
+#define C_HNI_PML_ERR_ELAPSED_TIME_SIZE 0x00000008
+
+union c_hni_pml_err_elapsed_time {
+	__u64 qw;
+	struct {
+		__u64 nanoseconds : 30;
+		__u64 seconds : 34;
+	};
+};
+
+#define C1_HNI_PML_ERR_FLG_OFFSET 0x00000108
+#define C1_HNI_PML_ERR_FLG (C_HNI_PML_BASE + C1_HNI_PML_ERR_FLG_OFFSET)
+#define C1_HNI_PML_ERR_FLG_SIZE 0x00000008
+
+union c1_hni_pml_err_flg {
+	__u64 qw;
+	struct {
+		__u64 sw_diag : 1;
+		__u64 crnc_ring_sync_error : 1;
+		__u64 crnc_ring_ecc_sbe : 1;
+		__u64 crnc_ring_ecc_mbe : 1;
+		__u64 crnc_ring_cmd_unknown : 1;
+		__u64 crnc_csr_cmd_unknown : 1;
+		__u64 crnc_csr_cmd_incomplete : 1;
+		__u64 crnc_buf_ecc_sbe : 1;
+		__u64 crnc_buf_ecc_mbe : 1;
+		__u64: 22;
+		__u64 mac_rx_frame_err : 1;
+		__u64 autoneg_page_received : 1;
+		__u64 autoneg_complete : 1;
+		__u64 autoneg_failed : 1;
+		__u64 pcs_tx_dp_err : 1;
+		__u64 pcs_rx_dp_err : 1;
+		__u64 pcs_rx_deskew_overflow : 1;
+		__u64 pcs_rx_deskew_pe : 1;
+		__u64 pcs_fec_mem0_sbe : 1;
+		__u64 pcs_fec_mem0_mbe : 1;
+		__u64 pcs_fec_mem1_sbe : 1;
+		__u64 pcs_fec_mem1_mbe : 1;
+		__u64 pcs_tx_degrade : 1;
+		__u64 pcs_rx_degrade : 1;
+		__u64 pcs_rx_degrade_failure : 1;
+		__u64 pcs_tx_degrade_failure : 1;
+		__u64 pcs_hi_ser : 1;
+		__u64 pcs_link_down : 1;
+		__u64 mac_tx_dp_err : 1;
+		__u64 mac_rx_dp_err : 1;
+		__u64 llr_tx_dp_sbe : 1;
+		__u64 llr_tx_dp_mbe : 1;
+		__u64 llr_tx_dp_err : 1;
+		__u64 llr_seq_mem_sbe : 1;
+		__u64 llr_seq_mem_mbe : 1;
+		__u64 llr_replay_mem_sbe : 1;
+		__u64 llr_replay_mem_mbe : 1;
+		__u64 llr_ack_nack_error : 1;
+		__u64 llr_ack_nack_seq_err : 1;
+		__u64 llr_replay_at_max : 1;
+		__u64 pcs_lanes_locked : 1;
+		__u64 pcs_aligned : 1;
+		__u64 pcs_ready : 1;
+	};
+};
+
+#define SS2_PORT_PML_ERR_FLG_OFFSET 0x00000120
+#define SS2_PORT_PML_ERR_FLG (C_HNI_PML_BASE + SS2_PORT_PML_ERR_FLG_OFFSET)
+#define SS2_PORT_PML_ERR_FLG_SIZE 0x00000020
+
+union ss2_port_pml_err_flg {
+	__u64 qw[4];
+	struct {
+		__u64 sw_diag : 1;
+		__u64 crnc_ring_sync_error : 1;
+		__u64 crnc_ring_ecc_sbe : 1;
+		__u64 crnc_ring_ecc_mbe : 1;
+		__u64 crnc_ring_cmd_unknown : 1;
+		__u64 crnc_csr_cmd_unknown : 1;
+		__u64 crnc_csr_cmd_incomplete : 1;
+		__u64 crnc_buf_ecc_sbe : 1;
+		__u64 crnc_buf_ecc_mbe : 1;
+		__u64 csrc_ring_sync_error : 1;
+		__u64 csrc_ring_ecc_sbe : 1;
+		__u64 csrc_ring_ecc_mbe : 1;
+		__u64 csrc_ring_cmd_unknown : 1;
+		__u64 csrc_sring_sync_error : 1;
+		__u64 csrc_sring_ecc_sbe : 1;
+		__u64 csrc_sring_ecc_mbe : 1;
+		__u64 csrc_sring_cmd_unknown : 1;
+		__u64 csrc_buf_ecc_sbe : 1;
+		__u64 csrc_buf_ecc_mbe : 1;
+		__u64: 13;
+		__u64 pcs_tx_dp_err : 1;
+		__u64 pcs_rx_dp_err : 1;
+		__u64 pcs_rx_deskew_overflow : 1;
+		__u64 pcs_rx_deskew_pe : 1;
+		__u64 pcs_fec0_mem_sbe : 1;
+		__u64 pcs_fec0_mem_mbe : 1;
+		__u64 pcs_fec1_mem_sbe : 1;
+		__u64 pcs_fec1_mem_mbe : 1;
+		__u64 mac_tx_dp_err : 1;
+		__u64 mac_rx_dp_err : 1;
+		__u64 llr_tx_dp_sbe : 1;
+		__u64 llr_tx_dp_mbe : 1;
+		__u64 llr_tx_dp_err : 1;
+		__u64 llr_rx_dp_err : 1;
+		__u64 llr_seq_mem_sbe : 1;
+		__u64 llr_seq_mem_mbe : 1;
+		__u64 llr_replay_mem_sbe : 1;
+		__u64 llr_replay_mem_mbe : 1;
+		__u64 event_mem_sbe : 1;
+		__u64 event_mem_mbe : 1;
+		__u64 mac_rx_fcs32_err_0 : 1;
+		__u64 mac_rx_fcs32_err_1 : 1;
+		__u64 mac_rx_fcs32_err_2 : 1;
+		__u64 mac_rx_fcs32_err_3 : 1;
+		__u64 mac_rx_framing_err_0 : 1;
+		__u64 mac_rx_framing_err_1 : 1;
+		__u64 mac_rx_framing_err_2 : 1;
+		__u64 mac_rx_framing_err_3 : 1;
+		__u64 mac_rx_preamble_err_0 : 1;
+		__u64 mac_rx_preamble_err_1 : 1;
+		__u64 mac_rx_preamble_err_2 : 1;
+		__u64 mac_rx_preamble_err_3 : 1;
+		__u64 pcs_link_down_0 : 1;
+		__u64 pcs_link_down_1 : 1;
+		__u64 pcs_link_down_2 : 1;
+		__u64 pcs_link_down_3 : 1;
+		__u64 pcs_link_down_lf_0 : 1;
+		__u64 pcs_link_down_lf_1 : 1;
+		__u64 pcs_link_down_lf_2 : 1;
+		__u64 pcs_link_down_lf_3 : 1;
+		__u64 pcs_link_down_rf_0 : 1;
+		__u64 pcs_link_down_rf_1 : 1;
+		__u64 pcs_link_down_rf_2 : 1;
+		__u64 pcs_link_down_rf_3 : 1;
+		__u64 pcs_hi_ser_0 : 1;
+		__u64 pcs_hi_ser_1 : 1;
+		__u64 pcs_hi_ser_2 : 1;
+		__u64 pcs_hi_ser_3 : 1;
+		__u64 pcs_tx_degrade : 1;
+		__u64 pcs_rx_degrade : 1;
+		__u64 pcs_rx_degrade_failure : 1;
+		__u64 pcs_tx_degrade_failure : 1;
+		__u64: 8;
+		__u64 autoneg_failed_0 : 1;
+		__u64 autoneg_failed_1 : 1;
+		__u64 autoneg_failed_2 : 1;
+		__u64 autoneg_failed_3 : 1;
+		__u64 llr_ack_nack_error_0 : 1;
+		__u64 llr_ack_nack_error_1 : 1;
+		__u64 llr_ack_nack_error_2 : 1;
+		__u64 llr_ack_nack_error_3 : 1;
+		__u64 llr_ack_nack_seq_err_0 : 1;
+		__u64 llr_ack_nack_seq_err_1 : 1;
+		__u64 llr_ack_nack_seq_err_2 : 1;
+		__u64 llr_ack_nack_seq_err_3 : 1;
+		__u64 llr_replay_at_max_0 : 1;
+		__u64 llr_replay_at_max_1 : 1;
+		__u64 llr_replay_at_max_2 : 1;
+		__u64 llr_replay_at_max_3 : 1;
+		__u64 llr_expected_frame_bad_0 : 1;
+		__u64 llr_expected_frame_bad_1 : 1;
+		__u64 llr_expected_frame_bad_2 : 1;
+		__u64 llr_expected_frame_bad_3 : 1;
+		__u64 llr_duplicate_frame_0 : 1;
+		__u64 llr_duplicate_frame_1 : 1;
+		__u64 llr_duplicate_frame_2 : 1;
+		__u64 llr_duplicate_frame_3 : 1;
+		__u64 llr_unexpected_frame_0 : 1;
+		__u64 llr_unexpected_frame_1 : 1;
+		__u64 llr_unexpected_frame_2 : 1;
+		__u64 llr_unexpected_frame_3 : 1;
+		__u64 llr_loop_time_fail_0 : 1;
+		__u64 llr_loop_time_fail_1 : 1;
+		__u64 llr_loop_time_fail_2 : 1;
+		__u64 llr_loop_time_fail_3 : 1;
+		__u64 llr_init_fail_0 : 1;
+		__u64 llr_init_fail_1 : 1;
+		__u64 llr_init_fail_2 : 1;
+		__u64 llr_init_fail_3 : 1;
+		__u64 llr_starved_0 : 1;
+		__u64 llr_starved_1 : 1;
+		__u64 llr_starved_2 : 1;
+		__u64 llr_starved_3 : 1;
+		__u64 llr_max_starvation_limit_0 : 1;
+		__u64 llr_max_starvation_limit_1 : 1;
+		__u64 llr_max_starvation_limit_2 : 1;
+		__u64 llr_max_starvation_limit_3 : 1;
+		__u64: 56;
+		__u64 pcs_lanes_locked_0 : 1;
+		__u64 pcs_lanes_locked_1 : 1;
+		__u64 pcs_lanes_locked_2 : 1;
+		__u64 pcs_lanes_locked_3 : 1;
+		__u64 pcs_aligned_0 : 1;
+		__u64 pcs_aligned_1 : 1;
+		__u64 pcs_aligned_2 : 1;
+		__u64 pcs_aligned_3 : 1;
+		__u64 pcs_link_up_0 : 1;
+		__u64 pcs_link_up_1 : 1;
+		__u64 pcs_link_up_2 : 1;
+		__u64 pcs_link_up_3 : 1;
+		__u64 pcs_rx_degrade_rdy : 1;
+		__u64 pcs_lp_degrade_rdy : 1;
+		__u64: 2;
+		__u64 autoneg_page_received_0 : 1;
+		__u64 autoneg_page_received_1 : 1;
+		__u64 autoneg_page_received_2 : 1;
+		__u64 autoneg_page_received_3 : 1;
+		__u64 autoneg_complete_0 : 1;
+		__u64 autoneg_complete_1 : 1;
+		__u64 autoneg_complete_2 : 1;
+		__u64 autoneg_complete_3 : 1;
+		__u64 llr_loop_time_0 : 1;
+		__u64 llr_loop_time_1 : 1;
+		__u64 llr_loop_time_2 : 1;
+		__u64 llr_loop_time_3 : 1;
+		__u64 time_stamp_valid_0 : 1;
+		__u64 time_stamp_valid_1 : 1;
+		__u64 time_stamp_valid_2 : 1;
+		__u64 time_stamp_valid_3 : 1;
+		__u64 fec_err_vector_valid : 1;
+		__u64 llr_init_complete_0 : 1;
+		__u64 llr_init_complete_1 : 1;
+		__u64 llr_init_complete_2 : 1;
+		__u64 llr_init_complete_3 : 1;
+		__u64 event_cnt_ovf : 1;
+		__u64 rx_signal_ok_0 : 1;
+		__u64 rx_signal_ok_1 : 1;
+		__u64 rx_signal_ok_2 : 1;
+		__u64 rx_signal_ok_3 : 1;
+		__u64: 22;
+	};
+};
+
+#define C1_HNI_PML_ERR_FIRST_FLG_OFFSET 0x00000110
+#define C1_HNI_PML_ERR_FIRST_FLG (C_HNI_PML_BASE + C1_HNI_PML_ERR_FIRST_FLG_OFFSET)
+#define C1_HNI_PML_ERR_FIRST_FLG_SIZE 0x00000008
+#define SS2_PORT_PML_ERR_FIRST_FLG_OFFSET 0x00000140
+#define SS2_PORT_PML_ERR_FIRST_FLG (C_HNI_PML_BASE + SS2_PORT_PML_ERR_FIRST_FLG_OFFSET)
+#define SS2_PORT_PML_ERR_FIRST_FLG_SIZE 0x00000020
+#define C1_HNI_PML_ERR_FIRST_FLG_TS_OFFSET 0x00000118
+#define C1_HNI_PML_ERR_FIRST_FLG_TS (C_HNI_PML_BASE + C1_HNI_PML_ERR_FIRST_FLG_TS_OFFSET)
+#define C_HNI_PML_ERR_FIRST_FLG_TS_SIZE 0x00000008
+#define C1_HNI_PML_ERR_FIRST_FLG_TS_SIZE C_HNI_PML_ERR_FIRST_FLG_TS_SIZE
+#define SS2_PORT_PML_ERR_FIRST_FLG_TS_OFFSET 0x00000160
+#define SS2_PORT_PML_ERR_FIRST_FLG_TS (C_HNI_PML_BASE + SS2_PORT_PML_ERR_FIRST_FLG_TS_OFFSET)
+#define SS2_PORT_PML_ERR_FIRST_FLG_TS_SIZE 0x00000008
+#define C1_HNI_PML_ERR_CLR_OFFSET 0x00000120
+#define C1_HNI_PML_ERR_CLR (C_HNI_PML_BASE + C1_HNI_PML_ERR_CLR_OFFSET)
+#define C1_HNI_PML_ERR_CLR_SIZE 0x00000008
+#define SS2_PORT_PML_ERR_CLR_OFFSET 0x00000180
+#define SS2_PORT_PML_ERR_CLR (C_HNI_PML_BASE + SS2_PORT_PML_ERR_CLR_OFFSET)
+#define SS2_PORT_PML_ERR_CLR_SIZE 0x00000020
+#define C1_HNI_PML_ERR_IRQA_MSK_OFFSET 0x00000128
+#define C1_HNI_PML_ERR_IRQA_MSK (C_HNI_PML_BASE + C1_HNI_PML_ERR_IRQA_MSK_OFFSET)
+#define C1_HNI_PML_ERR_IRQA_MSK_SIZE 0x00000008
+#define SS2_PORT_PML_ERR_IRQA_MSK_OFFSET 0x000001a0
+#define SS2_PORT_PML_ERR_IRQA_MSK (C_HNI_PML_BASE + SS2_PORT_PML_ERR_IRQA_MSK_OFFSET)
+#define SS2_PORT_PML_ERR_IRQA_MSK_SIZE 0x00000020
+#define C1_HNI_PML_ERR_IRQB_MSK_OFFSET 0x00000130
+#define C1_HNI_PML_ERR_IRQB_MSK (C_HNI_PML_BASE + C1_HNI_PML_ERR_IRQB_MSK_OFFSET)
+#define C1_HNI_PML_ERR_IRQB_MSK_SIZE 0x00000008
+#define SS2_PORT_PML_ERR_IRQB_MSK_OFFSET 0x000001c0
+#define SS2_PORT_PML_ERR_IRQB_MSK (C_HNI_PML_BASE + SS2_PORT_PML_ERR_IRQB_MSK_OFFSET)
+#define SS2_PORT_PML_ERR_IRQB_MSK_SIZE 0x00000020
+#define C1_HNI_PML_ERR_INFO_MSK_OFFSET 0x00000140
+#define C1_HNI_PML_ERR_INFO_MSK (C_HNI_PML_BASE + C1_HNI_PML_ERR_INFO_MSK_OFFSET)
+#define C1_HNI_PML_ERR_INFO_MSK_SIZE 0x00000008
+#define SS2_PORT_PML_ERR_INFO_MSK_OFFSET 0x00000200
+#define SS2_PORT_PML_ERR_INFO_MSK (C_HNI_PML_BASE + SS2_PORT_PML_ERR_INFO_MSK_OFFSET)
+#define SS2_PORT_PML_ERR_INFO_MSK_SIZE 0x00000020
+#define C1_HNI_PML_ERR_INFO_MEM_OFFSET 0x00000180
+#define C1_HNI_PML_ERR_INFO_MEM (C_HNI_PML_BASE + C1_HNI_PML_ERR_INFO_MEM_OFFSET)
+#define C1_HNI_PML_ERR_INFO_MEM_SIZE 0x00000008
+
+union c1_hni_pml_err_info_mem {
+	__u64 qw;
+	struct {
+		__u64 csr_detected_sbe : 1;
+		__u64 csr_detected_mbe : 1;
+		__u64: 2;
+		__u64 sbe_syndrome : 10;
+		__u64: 2;
+		__u64 sbe_address : 11;
+		__u64: 1;
+		__u64 sbe_mem_id : 2;
+		__u64: 6;
+		__u64 mbe_syndrome : 10;
+		__u64: 2;
+		__u64 mbe_address : 11;
+		__u64: 1;
+		__u64 mbe_mem_id : 2;
+		__u64: 2;
+	};
+};
+
+#define C1_HNI_PML_ERR_INFO_MBE_CNTS_OFFSET 0x00000188
+#define C1_HNI_PML_ERR_INFO_MBE_CNTS (C_HNI_PML_BASE + C1_HNI_PML_ERR_INFO_MBE_CNTS_OFFSET)
+#define C1_HNI_PML_ERR_INFO_MBE_CNTS_SIZE 0x00000008
+
+union c1_hni_pml_err_info_mbe_cnts {
+	__u64 qw;
+	struct {
+		__u64 pcs_fec0_mbe_cnt : 4;
+		__u64: 4;
+		__u64 pcs_fec1_mbe_cnt : 4;
+		__u64: 4;
+		__u64 llr_seq_mbe_cnt : 4;
+		__u64: 4;
+		__u64 llr_replay_mbe_cnt : 4;
+		__u64: 36;
+	};
+};
+
+#define C1_HNI_PML_ERR_INFO_SBE_CNTS_OFFSET 0x00000190
+#define C1_HNI_PML_ERR_INFO_SBE_CNTS (C_HNI_PML_BASE + C1_HNI_PML_ERR_INFO_SBE_CNTS_OFFSET)
+#define C1_HNI_PML_ERR_INFO_SBE_CNTS_SIZE 0x00000008
+
+union c1_hni_pml_err_info_sbe_cnts {
+	__u64 qw;
+	struct {
+		__u64 pcs_fec0_sbe_cnt : 8;
+		__u64 pcs_fec1_sbe_cnt : 8;
+		__u64 llr_seq_sbe_cnt : 8;
+		__u64 llr_replay_sbe_cnt : 8;
+		__u64: 32;
+	};
+};
+
+#define C1_HNI_PML_ERR_INFO_PCS_TX_DP_OFFSET 0x000001a0
+#define C1_HNI_PML_ERR_INFO_PCS_TX_DP (C_HNI_PML_BASE + C1_HNI_PML_ERR_INFO_PCS_TX_DP_OFFSET)
+#define C1_HNI_PML_ERR_INFO_PCS_TX_DP_SIZE 0x00000008
+
+union c1_hni_pml_err_info_pcs_tx_dp {
+	__u64 qw;
+	struct {
+		__u64 tx_cdc_underrun : 4;
+		__u64 tx_cdc_overflow : 4;
+		__u64 tx_mac_if_fifo_overflow : 1;
+		__u64 tx_mac_if_fifo_starved : 1;
+		__u64 tx_serdes_if_fifo_overflow : 1;
+		__u64: 53;
+	};
+};
+
+#define SS2_PORT_PML_ERR_INFO_PCS_TX_DP_OFFSET 0x00000320
+#define SS2_PORT_PML_ERR_INFO_PCS_TX_DP (C_HNI_PML_BASE + SS2_PORT_PML_ERR_INFO_PCS_TX_DP_OFFSET)
+#define SS2_PORT_PML_ERR_INFO_PCS_TX_DP_SIZE 0x00000008
+
+union ss2_port_pml_err_info_pcs_tx_dp {
+	__u64 qw;
+	struct {
+		__u64 tx_cdc_underrun : 4;
+		__u64 tx_cdc_overflow : 4;
+		__u64 tx_mac_if_fifo_overflow : 1;
+		__u64 tx_mac_if_fifo_starved : 1;
+		__u64 tx_serdes_if_fifo_overflow : 1;
+		__u64: 5;
+		__u64 subport : 2;
+		__u64: 46;
+	};
+};
+
+#define C1_HNI_PML_ERR_INFO_PCS_RX_DP_OFFSET 0x000001a8
+#define C1_HNI_PML_ERR_INFO_PCS_RX_DP (C_HNI_PML_BASE + C1_HNI_PML_ERR_INFO_PCS_RX_DP_OFFSET)
+#define C1_HNI_PML_ERR_INFO_PCS_RX_DP_SIZE 0x00000008
+
+union c1_hni_pml_err_info_pcs_rx_dp {
+	__u64 qw;
+	struct {
+		__u64 rx_cdc_overflow : 4;
+		__u64 rx_rs_buffer_overflow : 1;
+		__u64: 59;
+	};
+};
+
+#define SS2_PORT_PML_ERR_INFO_PCS_RX_DP_OFFSET 0x00000328
+#define SS2_PORT_PML_ERR_INFO_PCS_RX_DP (C_HNI_PML_BASE + SS2_PORT_PML_ERR_INFO_PCS_RX_DP_OFFSET)
+#define SS2_PORT_PML_ERR_INFO_PCS_RX_DP_SIZE 0x00000008
+
+union ss2_port_pml_err_info_pcs_rx_dp {
+	__u64 qw;
+	struct {
+		__u64 rx_cdc_overflow : 4;
+		__u64 rx_rs_buffer_overflow : 1;
+		__u64: 3;
+		__u64 subport : 2;
+		__u64: 54;
+	};
+};
+
+#define C1_HNI_PML_ERR_INFO_PCS_RX_DESKEW_OFFSET 0x000001b0
+#define C1_HNI_PML_ERR_INFO_PCS_RX_DESKEW                                                          \
+	(C_HNI_PML_BASE + C1_HNI_PML_ERR_INFO_PCS_RX_DESKEW_OFFSET)
+#define C1_HNI_PML_ERR_INFO_PCS_RX_DESKEW_SIZE 0x00000008
+
+union c1_hni_pml_err_info_pcs_rx_deskew {
+	__u64 qw;
+	struct {
+		__u64 rx_deskew_overflow : 8;
+		__u64: 56;
+	};
+};
+
+#define SS2_PORT_PML_ERR_INFO_PCS_RX_DESKEW_OFFSET 0x00000330
+#define SS2_PORT_PML_ERR_INFO_PCS_RX_DESKEW                                                        \
+	(C_HNI_PML_BASE + SS2_PORT_PML_ERR_INFO_PCS_RX_DESKEW_OFFSET)
+#define SS2_PORT_PML_ERR_INFO_PCS_RX_DESKEW_SIZE 0x00000008
+
+union ss2_port_pml_err_info_pcs_rx_deskew {
+	__u64 qw;
+	struct {
+		__u64 rx_deskew_overflow : 16;
+		__u64: 48;
+	};
+};
+
+#define C1_HNI_PML_ERR_INFO_PCS_RX_DESKEW_PES_OFFSET 0x000001b8
+#define C1_HNI_PML_ERR_INFO_PCS_RX_DESKEW_PES                                                      \
+	(C_HNI_PML_BASE + C1_HNI_PML_ERR_INFO_PCS_RX_DESKEW_PES_OFFSET)
+#define C1_HNI_PML_ERR_INFO_PCS_RX_DESKEW_PES_SIZE 0x00000008
+
+union c1_hni_pml_err_info_pcs_rx_deskew_pes {
+	__u64 qw;
+	struct {
+		__u64 deskew_0_pe_cnt : 8;
+		__u64 deskew_1_pe_cnt : 8;
+		__u64 deskew_2_pe_cnt : 8;
+		__u64 deskew_3_pe_cnt : 8;
+		__u64 deskew_4_pe_cnt : 8;
+		__u64 deskew_5_pe_cnt : 8;
+		__u64 deskew_6_pe_cnt : 8;
+		__u64 deskew_7_pe_cnt : 8;
+	};
+};
+
+#define SS2_PORT_PML_ERR_INFO_PCS_RX_DESKEW_PES_OFFSET 0x00000338
+#define SS2_PORT_PML_ERR_INFO_PCS_RX_DESKEW_PES                                                    \
+	(C_HNI_PML_BASE + SS2_PORT_PML_ERR_INFO_PCS_RX_DESKEW_PES_OFFSET)
+#define SS2_PORT_PML_ERR_INFO_PCS_RX_DESKEW_PES_SIZE 0x00000008
+
+union ss2_port_pml_err_info_pcs_rx_deskew_pes {
+	__u64 qw;
+	struct {
+		__u64 rx_deskew_parity_err : 16;
+		__u64: 48;
+	};
+};
+
+#define C1_HNI_PML_ERR_INFO_MAC_TX_DP_OFFSET 0x000001c0
+#define C1_HNI_PML_ERR_INFO_MAC_TX_DP (C_HNI_PML_BASE + C1_HNI_PML_ERR_INFO_MAC_TX_DP_OFFSET)
+#define C1_HNI_PML_ERR_INFO_MAC_TX_DP_SIZE 0x00000008
+
+union c1_hni_pml_err_info_mac_tx_dp {
+	__u64 qw;
+	struct {
+		__u64 tx_llr_if_credit_error : 1;
+		__u64 tx_llr_if_ctl_par_err : 1;
+		__u64 tx_llr_if_llr_par_err : 1;
+		__u64 tx_llr_if_bytes_vld_err : 1;
+		__u64 tx_llr_if_framing_err : 1;
+		__u64 tx_llr_if_fcs_16_err : 1;
+		__u64 tx_mac_gb_underrun : 1;
+		__u64: 57;
+	};
+};
+
+#define SS2_PORT_PML_ERR_INFO_MAC_TX_DP_OFFSET 0x00000348
+#define SS2_PORT_PML_ERR_INFO_MAC_TX_DP (C_HNI_PML_BASE + SS2_PORT_PML_ERR_INFO_MAC_TX_DP_OFFSET)
+#define SS2_PORT_PML_ERR_INFO_MAC_TX_DP_SIZE 0x00000008
+
+union ss2_port_pml_err_info_mac_tx_dp {
+	__u64 qw;
+	struct {
+		__u64 tx_llr_if_credit_error : 1;
+		__u64 tx_llr_if_ctl_par_err : 1;
+		__u64 tx_llr_if_llr_par_err : 1;
+		__u64 tx_llr_if_llr_seg_par_err : 4;
+		__u64 tx_llr_if_bytes_vld_err : 4;
+		__u64 tx_llr_if_framing_err : 1;
+		__u64 tx_llr_if_fcs_16_err : 1;
+		__u64 tx_mac_gb_underrun : 1;
+		__u64 tx_mac_gb_overflow : 1;
+		__u64 tx_mac_fifo_overflow : 1;
+		__u64 subport : 2;
+		__u64: 46;
+	};
+};
+
+#define C1_HNI_PML_ERR_INFO_MAC_RX_DP_OFFSET 0x000001c8
+#define C1_HNI_PML_ERR_INFO_MAC_RX_DP (C_HNI_PML_BASE + C1_HNI_PML_ERR_INFO_MAC_RX_DP_OFFSET)
+#define C1_HNI_PML_ERR_INFO_MAC_RX_DP_SIZE 0x00000008
+
+union c1_hni_pml_err_info_mac_rx_dp {
+	__u64 qw;
+	struct {
+		__u64 rx_mac_gb_err : 1;
+		__u64 rx_mac_illegal_size : 1;
+		__u64 rx_mac_fragment : 1;
+		__u64 rx_mac_preamble_error : 1;
+		__u64 rx_mac_framing_error : 1;
+		__u64 rx_mac_fcs32_error : 1;
+		__u64: 58;
+	};
+};
+
+#define SS2_PORT_PML_ERR_INFO_MAC_RX_DP_OFFSET 0x00000350
+#define SS2_PORT_PML_ERR_INFO_MAC_RX_DP (C_HNI_PML_BASE + SS2_PORT_PML_ERR_INFO_MAC_RX_DP_OFFSET)
+#define SS2_PORT_PML_ERR_INFO_MAC_RX_DP_SIZE 0x00000008
+
+union ss2_port_pml_err_info_mac_rx_dp {
+	__u64 qw;
+	struct {
+		__u64 rx_mac_illegal_size : 1;
+		__u64 rx_mac_fragment : 1;
+		__u64 rx_mac_fifo_overflow : 1;
+		__u64 rx_mac_short_pkt_buf_ovfw : 1;
+		__u64: 4;
+		__u64 subport : 2;
+		__u64: 54;
+	};
+};
+
+#define C1_HNI_PML_ERR_INFO_LLR_TX_DP_OFFSET 0x000001d0
+#define C1_HNI_PML_ERR_INFO_LLR_TX_DP (C_HNI_PML_BASE + C1_HNI_PML_ERR_INFO_LLR_TX_DP_OFFSET)
+#define C1_HNI_PML_ERR_INFO_LLR_TX_DP_SIZE 0x00000008
+
+union c1_hni_pml_err_info_llr_tx_dp {
+	__u64 qw;
+	struct {
+		__u64 tx_llr_sbe_syndrome : 10;
+		__u64 tx_llr_bypass_sbe : 1;
+		__u64 tx_llr_if_fifo_sbe : 1;
+		__u64: 4;
+		__u64 tx_llr_mbe_syndrome : 10;
+		__u64 tx_llr_bypass_mbe : 1;
+		__u64 tx_llr_if_fifo_mbe : 1;
+		__u64: 4;
+		__u64 tx_llr_bypass_par_err : 1;
+		__u64 tx_llr_bypass_overflow_err : 1;
+		__u64 tx_llr_bypass_illegal_len_err : 1;
+		__u64 tx_llr_if_fifo_par_err : 1;
+		__u64 tx_llr_if_fifo_overrun_err : 1;
+		__u64 tx_llr_if_fifo_len_err : 1;
+		__u64: 26;
+	};
+};
+
+#define SS2_PORT_PML_ERR_INFO_LLR_TX_DP_OFFSET 0x00000358
+#define SS2_PORT_PML_ERR_INFO_LLR_TX_DP (C_HNI_PML_BASE + SS2_PORT_PML_ERR_INFO_LLR_TX_DP_OFFSET)
+#define SS2_PORT_PML_ERR_INFO_LLR_TX_DP_SIZE 0x00000008
+
+union ss2_port_pml_err_info_llr_tx_dp {
+	__u64 qw;
+	struct {
+		__u64 tx_llr_bypass_par_err : 1;
+		__u64 tx_llr_bypass_overflow_err : 1;
+		__u64 tx_llr_bypass_illegal_len_err : 1;
+		__u64 tx_llr_if_fifo_seg0_par_err : 1;
+		__u64 tx_llr_if_fifo_seg1_par_err : 1;
+		__u64 tx_llr_if_fifo_seg2_par_err : 1;
+		__u64 tx_llr_if_fifo_seg3_par_err : 1;
+		__u64 tx_llr_if_fifo_par_err : 1;
+		__u64 tx_llr_if_fifo_overrun_err : 1;
+		__u64 tx_llr_if_fifo_len_err : 1;
+		__u64 tx_llr_bypass_illegal_frame_type : 1;
+		__u64 tx_llr_input_bus_err : 1;
+		__u64: 12;
+		__u64 subport : 2;
+		__u64: 38;
+	};
+};
+
+#define C_HNI_PML_CFG_GENERAL_OFFSET 0x00000400
+#define C_HNI_PML_CFG_GENERAL (C_HNI_PML_BASE + C_HNI_PML_CFG_GENERAL_OFFSET)
+#define C_HNI_PML_CFG_GENERAL_SIZE 0x00000008
+
+union c_hni_pml_cfg_general {
+	__u64 qw;
+	struct {
+		__u64 clock_period_ps : 11;
+		__u64: 53;
+	};
+};
+
+#define C1_HNI_PML_CFG_SERDES_CORE_INTERRUPT_OFFSET 0x00000408
+#define C1_HNI_PML_CFG_SERDES_CORE_INTERRUPT                                                       \
+	(C_HNI_PML_BASE + C1_HNI_PML_CFG_SERDES_CORE_INTERRUPT_OFFSET)
+#define C1_HNI_PML_CFG_SERDES_CORE_INTERRUPT_SIZE 0x00000008
+
+union c1_hni_pml_cfg_serdes_core_interrupt {
+	__u64 qw;
+	struct {
+		__u64 set_interrupt_delay : 8;
+		__u64 clear_interrupt_delay : 8;
+		__u64 capture_interrupt_data_delay : 8;
+		__u64: 40;
+	};
+};
+
+#define C1_HNI_PML_SERDES_CORE_INTERRUPT_OFFSET 0x00000410
+#define C1_HNI_PML_SERDES_CORE_INTERRUPT (C_HNI_PML_BASE + C1_HNI_PML_SERDES_CORE_INTERRUPT_OFFSET)
+#define C1_HNI_PML_SERDES_CORE_INTERRUPT_SIZE 0x00000008
+
+union c1_hni_pml_serdes_core_interrupt {
+	__u64 qw;
+	struct {
+		__u64 core_interrupt_data : 16;
+		__u64 core_interrupt_code : 16;
+		__u64 do_core_interrupt : 1;
+		__u64 serdes_sel : 2;
+		__u64: 29;
+	};
+};
+
+#define C1_HNI_PML_CFG_PCS_OFFSET 0x00000500
+#define C1_HNI_PML_CFG_PCS (C_HNI_PML_BASE + C1_HNI_PML_CFG_PCS_OFFSET)
+#define C1_HNI_PML_CFG_PCS_SIZE 0x00000008
+
+union c1_hni_pml_cfg_pcs {
+	__u64 qw;
+	struct {
+		__u64 pcs_enable : 1;
+		__u64 enable_auto_neg : 1;
+		__u64: 6;
+		__u64 pcs_mode : 2;
+		__u64 enable_auto_lane_degrade : 1;
+		__u64: 5;
+		__u64 ll_fec : 1;
+		__u64: 7;
+		__u64 timestamp_shift : 2;
+		__u64: 38;
+	};
+};
+
+#define SS2_PORT_PML_CFG_PCS_OFFSET 0x00000500
+#define SS2_PORT_PML_CFG_PCS (C_HNI_PML_BASE + SS2_PORT_PML_CFG_PCS_OFFSET)
+#define SS2_PORT_PML_CFG_PCS_SIZE 0x00000008
+
+union ss2_port_pml_cfg_pcs {
+	__u64 qw;
+	struct {
+		__u64 pcs_mode : 3;
+		__u64 enable_auto_lane_degrade : 1;
+		__u64 by_25g_fec_mode : 2;
+		__u64: 10;
+		__u64 timestamp_shift : 2;
+		__u64: 46;
+	};
+};
+
+#define C1_HNI_PML_CFG_PCS_AUTONEG_OFFSET 0x00000508
+#define C1_HNI_PML_CFG_PCS_AUTONEG (C_HNI_PML_BASE + C1_HNI_PML_CFG_PCS_AUTONEG_OFFSET)
+#define C1_HNI_PML_CFG_PCS_AUTONEG_SIZE 0x00000008
+
+union c_hni_pml_cfg_pcs_autoneg {
+	__u64 qw;
+	struct {
+		__u64 next_page_loaded : 1;
+		__u64: 7;
+		__u64 restart : 1;
+		__u64: 7;
+		__u64 reset : 1;
+		__u64: 7;
+		__u64 tx_lane : 2;
+		__u64 rx_lane : 2;
+		__u64: 36;
+	};
+};
+
+#define SS2_PORT_PML_CFG_PCS_AUTONEG_OFFSET(idx) (0x00000540 + ((idx) * 8))
+#define SS2_PORT_PML_CFG_PCS_AUTONEG_ENTRIES 4
+#define SS2_PORT_PML_CFG_PCS_AUTONEG(idx)                                                          \
+	(C_HNI_PML_BASE + SS2_PORT_PML_CFG_PCS_AUTONEG_OFFSET(idx))
+#define SS2_PORT_PML_CFG_PCS_AUTONEG_SIZE 0x00000020
+
+union ss2_port_pml_cfg_pcs_autoneg {
+	__u64 qw;
+	struct {
+		__u64 next_page_loaded : 1;
+		__u64: 7;
+		__u64 restart : 1;
+		__u64: 7;
+		__u64 reset : 1;
+		__u64: 7;
+		__u64 tx_lane : 2;
+		__u64 rx_lane : 2;
+		__u64: 36;
+	};
+};
+
+#define C1_HNI_PML_CFG_PCS_AUTONEG_TIMERS_OFFSET 0x00000510
+#define C1_HNI_PML_CFG_PCS_AUTONEG_TIMERS                                                          \
+	(C_HNI_PML_BASE + C1_HNI_PML_CFG_PCS_AUTONEG_TIMERS_OFFSET)
+#define C1_HNI_PML_CFG_PCS_AUTONEG_TIMERS_SIZE 0x00000008
+
+union c1_hni_pml_cfg_pcs_autoneg_timers {
+	__u64 qw;
+	struct {
+		__u64 break_link_timer_max : 32;
+		__u64 link_fail_inhibit_timer_max : 32;
+	};
+};
+
+#define SS2_PORT_PML_CFG_PCS_AUTONEG_TIMERS_OFFSET 0x00000560
+#define SS2_PORT_PML_CFG_PCS_AUTONEG_TIMERS                                                        \
+	(C_HNI_PML_BASE + SS2_PORT_PML_CFG_PCS_AUTONEG_TIMERS_OFFSET)
+#define SS2_PORT_PML_CFG_PCS_AUTONEG_TIMERS_SIZE 0x00000010
+
+union ss2_port_pml_cfg_pcs_autoneg_timers {
+	__u64 qw[2];
+	struct {
+		__u64 break_link_timer_max : 32;
+		__u64: 32;
+		__u64 link_fail_inhibit_timer_max : 34;
+		__u64: 30;
+	};
+};
+
+#define C1_HNI_PML_CFG_PCS_AUTONEG_BASE_PAGE_OFFSET 0x00000518
+#define C1_HNI_PML_CFG_PCS_AUTONEG_BASE_PAGE                                                       \
+	(C_HNI_PML_BASE + C1_HNI_PML_CFG_PCS_AUTONEG_BASE_PAGE_OFFSET)
+#define C1_HNI_PML_CFG_PCS_AUTONEG_BASE_PAGE_SIZE 0x00000008
+
+union c_hni_pml_cfg_pcs_autoneg_base_page {
+	__u64 qw;
+	struct {
+		__u64 base_page : 48;
+		__u64: 16;
+	};
+};
+
+#define SS2_PORT_PML_CFG_PCS_AUTONEG_BASE_PAGE_OFFSET(idx) (0x00000580 + ((idx) * 8))
+#define SS2_PORT_PML_CFG_PCS_AUTONEG_BASE_PAGE_ENTRIES 4
+#define SS2_PORT_PML_CFG_PCS_AUTONEG_BASE_PAGE(idx)                                                \
+	(C_HNI_PML_BASE + SS2_PORT_PML_CFG_PCS_AUTONEG_BASE_PAGE_OFFSET(idx))
+#define SS2_PORT_PML_CFG_PCS_AUTONEG_BASE_PAGE_SIZE 0x00000020
+
+union ss2_port_pml_cfg_pcs_autoneg_base_page {
+	__u64 qw;
+	struct {
+		__u64 base_page : 48;
+		__u64: 16;
+	};
+};
+
+#define C1_HNI_PML_CFG_PCS_AUTONEG_NEXT_PAGE_OFFSET 0x00000520
+#define C1_HNI_PML_CFG_PCS_AUTONEG_NEXT_PAGE                                                       \
+	(C_HNI_PML_BASE + C1_HNI_PML_CFG_PCS_AUTONEG_NEXT_PAGE_OFFSET)
+#define C1_HNI_PML_CFG_PCS_AUTONEG_NEXT_PAGE_SIZE 0x00000008
+
+union c_hni_pml_cfg_pcs_autoneg_next_page {
+	__u64 qw;
+	struct {
+		__u64 next_page : 48;
+		__u64: 16;
+	};
+};
+
+#define SS2_PORT_PML_CFG_PCS_AUTONEG_NEXT_PAGE_OFFSET(idx) (0x000005a0 + ((idx) * 8))
+#define SS2_PORT_PML_CFG_PCS_AUTONEG_NEXT_PAGE_ENTRIES 4
+#define SS2_PORT_PML_CFG_PCS_AUTONEG_NEXT_PAGE(idx)                                                \
+	(C_HNI_PML_BASE + SS2_PORT_PML_CFG_PCS_AUTONEG_NEXT_PAGE_OFFSET(idx))
+#define SS2_PORT_PML_CFG_PCS_AUTONEG_NEXT_PAGE_SIZE 0x00000020
+
+union ss2_port_pml_cfg_pcs_autoneg_next_page {
+	__u64 qw;
+	struct {
+		__u64 next_page : 48;
+		__u64: 16;
+	};
+};
+
+#define C1_HNI_PML_CFG_PCS_AMS_OFFSET 0x00000528
+#define C1_HNI_PML_CFG_PCS_AMS (C_HNI_PML_BASE + C1_HNI_PML_CFG_PCS_AMS_OFFSET)
+#define C_HNI_PML_CFG_PCS_AMS_SIZE 0x00000008
+#define C1_HNI_PML_CFG_PCS_AMS_SIZE C_HNI_PML_CFG_PCS_AMS_SIZE
+
+union c_hni_pml_cfg_pcs_ams {
+	__u64 qw;
+	struct {
+		__u64 am_spacing : 4;
+		__u64: 4;
+		__u64 ram_spacing : 4;
+		__u64: 12;
+		__u64 use_programmable_am_spacing : 1;
+		__u64 use_programmable_ams : 1;
+		__u64: 38;
+	};
+};
+
+#define SS2_PORT_PML_CFG_PCS_AMS_OFFSET 0x000005c0
+#define SS2_PORT_PML_CFG_PCS_AMS (C_HNI_PML_BASE + SS2_PORT_PML_CFG_PCS_AMS_OFFSET)
+#define SS2_PORT_PML_CFG_PCS_AMS_SIZE 0x00000008
+
+union ss2_port_pml_cfg_pcs_ams {
+	__u64 qw;
+	struct {
+		__u64 am_spacing : 4;
+		__u64: 4;
+		__u64 ram_spacing : 4;
+		__u64: 12;
+		__u64 use_programmable_am_spacing : 1;
+		__u64 use_programmable_ams : 1;
+		__u64: 38;
+	};
+};
+
+#define C1_HNI_PML_CFG_PCS_UM_OFFSET(idx) (0x00000530 + ((idx) * 8))
+#define C1_HNI_PML_CFG_PCS_UM_ENTRIES 8
+#define C1_HNI_PML_CFG_PCS_UM(idx) (C_HNI_PML_BASE + C1_HNI_PML_CFG_PCS_UM_OFFSET(idx))
+#define C1_HNI_PML_CFG_PCS_UM_SIZE 0x00000040
+
+union c_hni_pml_cfg_pcs_um {
+	__u64 qw;
+	struct {
+		__u64 um : 56;
+		__u64: 8;
+	};
+};
+
+#define SS2_PORT_PML_CFG_PCS_UM_OFFSET(idx) (0x00000600 + ((idx) * 8))
+#define SS2_PORT_PML_CFG_PCS_UM_ENTRIES 16
+#define SS2_PORT_PML_CFG_PCS_UM(idx) (C_HNI_PML_BASE + SS2_PORT_PML_CFG_PCS_UM_OFFSET(idx))
+#define SS2_PORT_PML_CFG_PCS_UM_SIZE 0x00000080
+
+union ss2_port_pml_cfg_pcs_um {
+	__u64 qw;
+	struct {
+		__u64 um : 56;
+		__u64: 8;
+	};
+};
+
+#define C1_HNI_PML_CFG_PCS_CM_OFFSET 0x00000570
+#define C1_HNI_PML_CFG_PCS_CM (C_HNI_PML_BASE + C1_HNI_PML_CFG_PCS_CM_OFFSET)
+#define C_HNI_PML_CFG_PCS_CM_SIZE 0x00000008
+#define C1_HNI_PML_CFG_PCS_CM_SIZE C_HNI_PML_CFG_PCS_CM_SIZE
+
+union c_hni_pml_cfg_pcs_cm {
+	__u64 qw;
+	struct {
+		__u64 cm;
+	};
+};
+
+#define SS2_PORT_PML_CFG_PCS_CM_OFFSET 0x00000680
+#define SS2_PORT_PML_CFG_PCS_CM (C_HNI_PML_BASE + SS2_PORT_PML_CFG_PCS_CM_OFFSET)
+#define SS2_PORT_PML_CFG_PCS_CM_SIZE 0x00000008
+
+union ss2_port_pml_cfg_pcs_cm {
+	__u64 qw;
+	struct {
+		__u64 cm;
+	};
+};
+
+#define C1_HNI_PML_CFG_TX_PCS_OFFSET 0x00000578
+#define C1_HNI_PML_CFG_TX_PCS (C_HNI_PML_BASE + C1_HNI_PML_CFG_TX_PCS_OFFSET)
+#define C1_HNI_PML_CFG_TX_PCS_SIZE 0x00000008
+
+union c1_hni_pml_cfg_tx_pcs {
+	__u64 qw;
+	struct {
+		__u64 lane_0_source : 2;
+		__u64: 6;
+		__u64 lane_1_source : 2;
+		__u64: 6;
+		__u64 lane_2_source : 2;
+		__u64: 6;
+		__u64 lane_3_source : 2;
+		__u64: 6;
+		__u64 enable_ctl_os : 1;
+		__u64 allow_auto_degrade : 1;
+		__u64: 6;
+		__u64 gearbox_credits : 4;
+		__u64: 4;
+		__u64 cdc_ready_level : 4;
+		__u64: 12;
+	};
+};
+
+#define SS2_PORT_PML_CFG_TX_PCS_OFFSET 0x00000688
+#define SS2_PORT_PML_CFG_TX_PCS (C_HNI_PML_BASE + SS2_PORT_PML_CFG_TX_PCS_OFFSET)
+#define SS2_PORT_PML_CFG_TX_PCS_SIZE 0x00000008
+
+union ss2_port_pml_cfg_tx_pcs {
+	__u64 qw;
+	struct {
+		__u64 lane_0_source : 2;
+		__u64: 6;
+		__u64 lane_1_source : 2;
+		__u64: 6;
+		__u64 lane_2_source : 2;
+		__u64: 6;
+		__u64 lane_3_source : 2;
+		__u64: 6;
+		__u64 allow_auto_degrade : 1;
+		__u64: 7;
+		__u64 cdc_ready_level : 4;
+		__u64 en_pk_bw_limiter : 1;
+		__u64: 19;
+	};
+};
+
+#define C1_HNI_PML_CFG_RX_PCS_OFFSET 0x00000580
+#define C1_HNI_PML_CFG_RX_PCS (C_HNI_PML_BASE + C1_HNI_PML_CFG_RX_PCS_OFFSET)
+#define C1_HNI_PML_CFG_RX_PCS_SIZE 0x00000008
+
+union c1_hni_pml_cfg_rx_pcs {
+	__u64 qw;
+	struct {
+		__u64 active_lanes : 4;
+		__u64: 4;
+		__u64 rs_mode : 3;
+		__u64: 5;
+		__u64 enable_lock : 1;
+		__u64 restart_lock_on_bad_ams : 1;
+		__u64 restart_lock_on_bad_cws : 1;
+		__u64: 5;
+		__u64 enable_ctl_os : 1;
+		__u64: 7;
+		__u64 health_bad_sensitivity : 4;
+		__u64 lp_health_bad_sensitivity : 1;
+		__u64: 3;
+		__u64 allow_auto_degrade : 1;
+		__u64: 7;
+		__u64 enable_rx_sm : 1;
+		__u64: 15;
+	};
+};
+
+#define SS2_PORT_PML_CFG_RX_PCS_OFFSET 0x000006c0
+#define SS2_PORT_PML_CFG_RX_PCS (C_HNI_PML_BASE + SS2_PORT_PML_CFG_RX_PCS_OFFSET)
+#define SS2_PORT_PML_CFG_RX_PCS_SIZE 0x00000008
+
+union ss2_port_pml_cfg_rx_pcs {
+	__u64 qw;
+	struct {
+		__u64 active_lanes : 4;
+		__u64 cw_gap_544 : 5;
+		__u64 cw_gap_ll : 5;
+		__u64 cw_gap_one_fec : 5;
+		__u64 restart_lock_on_bad_ams : 1;
+		__u64 restart_lock_on_bad_cws : 1;
+		__u64 health_bad_sensitivity : 4;
+		__u64 lp_health_bad_sensitivity : 1;
+		__u64 allow_auto_degrade : 1;
+		__u64 lane_0_source : 2;
+		__u64 lane_1_source : 2;
+		__u64 lane_2_source : 2;
+		__u64 lane_3_source : 2;
+		__u64 signal_detect_enn : 4;
+		__u64 rx_lock_enn : 4;
+		__u64 rx_clk_vld_enn : 4;
+		__u64: 17;
+	};
+};
+
+#define C1_HNI_PML_CFG_RX_PCS_AMS_OFFSET 0x00000588
+#define C1_HNI_PML_CFG_RX_PCS_AMS (C_HNI_PML_BASE + C1_HNI_PML_CFG_RX_PCS_AMS_OFFSET)
+#define C_HNI_PML_CFG_RX_PCS_AMS_SIZE 0x00000008
+#define C1_HNI_PML_CFG_RX_PCS_AMS_SIZE C_HNI_PML_CFG_RX_PCS_AMS_SIZE
+
+union c_hni_pml_cfg_rx_pcs_ams {
+	__u64 qw;
+	struct {
+		__u64 cm_match_mask : 16;
+		__u64 um_match_mask : 14;
+		__u64: 34;
+	};
+};
+
+#define SS2_PORT_PML_CFG_RX_PCS_AMS_OFFSET 0x00000700
+#define SS2_PORT_PML_CFG_RX_PCS_AMS (C_HNI_PML_BASE + SS2_PORT_PML_CFG_RX_PCS_AMS_OFFSET)
+#define SS2_PORT_PML_CFG_RX_PCS_AMS_SIZE 0x00000008
+
+union ss2_port_pml_cfg_rx_pcs_ams {
+	__u64 qw;
+	struct {
+		__u64 cm_match_mask : 16;
+		__u64 um_match_mask : 14;
+		__u64: 34;
+	};
+};
+
+#define C1_HNI_PML_CFG_TX_MAC_OFFSET 0x00000600
+#define C1_HNI_PML_CFG_TX_MAC (C_HNI_PML_BASE + C1_HNI_PML_CFG_TX_MAC_OFFSET)
+#define C1_HNI_PML_CFG_TX_MAC_SIZE 0x00000008
+
+union c1_hni_pml_cfg_tx_mac {
+	__u64 qw;
+	struct {
+		__u64 mac_operational : 1;
+		__u64 short_preamble : 1;
+		__u64: 6;
+		__u64 pcs_credits : 4;
+		__u64: 4;
+		__u64 ifg_mode : 1;
+		__u64: 3;
+		__u64 vs_version : 4;
+		__u64 ieee_ifg_adjustment : 2;
+		__u64 non_portals_sof_window : 5;
+		__u64 non_portals_max_sof : 4;
+		__u64 any_frame_sof_window_0 : 5;
+		__u64 any_frame_max_sof_0 : 4;
+		__u64 any_frame_sof_window_1 : 5;
+		__u64 any_frame_max_sof_1 : 4;
+		__u64 portals_protocol : 8;
+		__u64: 3;
+	};
+};
+
+#define SS2_PORT_PML_CFG_TX_MAC_OFFSET 0x00000800
+#define SS2_PORT_PML_CFG_TX_MAC (C_HNI_PML_BASE + SS2_PORT_PML_CFG_TX_MAC_OFFSET)
+#define SS2_PORT_PML_CFG_TX_MAC_SIZE 0x00000008
+
+union ss2_port_pml_cfg_tx_mac {
+	__u64 qw;
+	struct {
+		__u64 ifg_mode : 1;
+		__u64 min_ifg : 3;
+		__u64 mac_pad_idle_thresh : 8;
+		__u64: 1;
+		__u64 ieee_ifg_adjustment : 3;
+		__u64 vs_version : 4;
+		__u64: 6;
+		__u64 non_st_sof_window : 6;
+		__u64 non_st_max_sof : 3;
+		__u64 any_frame_sof_window_0 : 6;
+		__u64 any_frame_max_sof_0 : 3;
+		__u64: 10;
+		__u64 st_protocol : 8;
+		__u64: 2;
+	};
+};
+
+#define C1_HNI_PML_CFG_RX_MAC_OFFSET 0x00000608
+#define C1_HNI_PML_CFG_RX_MAC (C_HNI_PML_BASE + C1_HNI_PML_CFG_RX_MAC_OFFSET)
+#define C1_HNI_PML_CFG_RX_MAC_SIZE 0x00000008
+
+union c1_hni_pml_cfg_rx_mac {
+	__u64 qw;
+	struct {
+		__u64 mac_operational : 1;
+		__u64 short_preamble : 1;
+		__u64: 6;
+		__u64 filter_illegal_size : 1;
+		__u64: 55;
+	};
+};
+
+#define SS2_PORT_PML_CFG_RX_MAC_OFFSET 0x00000840
+#define SS2_PORT_PML_CFG_RX_MAC (C_HNI_PML_BASE + SS2_PORT_PML_CFG_RX_MAC_OFFSET)
+#define SS2_PORT_PML_CFG_RX_MAC_SIZE 0x00000008
+
+union ss2_port_pml_cfg_rx_mac {
+	__u64 qw;
+	struct {
+		__u64 flit_packing_cnt : 4;
+		__u64 stop_packing : 1;
+		__u64: 59;
+	};
+};
+
+#define C1_HNI_PML_CFG_LLR_OFFSET 0x00000700
+#define C1_HNI_PML_CFG_LLR (C_HNI_PML_BASE + C1_HNI_PML_CFG_LLR_OFFSET)
+#define C1_HNI_PML_CFG_LLR_SIZE 0x00000008
+
+union c1_hni_pml_cfg_llr {
+	__u64 qw;
+	struct {
+		__u64 llr_mode : 2;
+		__u64: 6;
+		__u64 mac_if_credits : 4;
+		__u64: 4;
+		__u64 link_down_behavior : 2;
+		__u64: 6;
+		__u64 enable_loop_timing : 1;
+		__u64: 7;
+		__u64 size : 2;
+		__u64: 6;
+		__u64 filter_ctl_frames : 1;
+		__u64 filter_lossless_when_off : 1;
+		__u64 ack_nack_err_check : 1;
+		__u64 preamble_seq_check : 1;
+		__u64: 20;
+	};
+};
+
+#define SS2_PORT_PML_CFG_LLR_OFFSET 0x00000900
+#define SS2_PORT_PML_CFG_LLR (C_HNI_PML_BASE + SS2_PORT_PML_CFG_LLR_OFFSET)
+#define SS2_PORT_PML_CFG_LLR_SIZE 0x00000008
+
+union ss2_port_pml_cfg_llr {
+	__u64 qw;
+	struct {
+		__u64 size : 1;
+		__u64: 7;
+		__u64 ack_nack_err_check : 1;
+		__u64 preamble_seq_check : 1;
+		__u64: 6;
+		__u64 stop_packing : 1;
+		__u64: 47;
+	};
+};
+
+#define C1_HNI_PML_CFG_LLR_CF_SMAC_OFFSET 0x00000710
+#define C1_HNI_PML_CFG_LLR_CF_SMAC (C_HNI_PML_BASE + C1_HNI_PML_CFG_LLR_CF_SMAC_OFFSET)
+#define C_HNI_PML_CFG_LLR_CF_SMAC_SIZE 0x00000008
+#define C1_HNI_PML_CFG_LLR_CF_SMAC_SIZE C_HNI_PML_CFG_LLR_CF_SMAC_SIZE
+
+union c_hni_pml_cfg_llr_cf_smac {
+	__u64 qw;
+	struct {
+		__u64 ctl_frame_smac : 48;
+		__u64: 16;
+	};
+};
+
+#define SS2_PORT_PML_CFG_LLR_CF_SMAC_OFFSET 0x00000948
+#define SS2_PORT_PML_CFG_LLR_CF_SMAC (C_HNI_PML_BASE + SS2_PORT_PML_CFG_LLR_CF_SMAC_OFFSET)
+#define SS2_PORT_PML_CFG_LLR_CF_SMAC_SIZE 0x00000008
+
+union ss2_port_pml_cfg_llr_cf_smac {
+	__u64 qw;
+	struct {
+		__u64 ctl_frame_smac : 48;
+		__u64: 16;
+	};
+};
+
+#define C1_HNI_PML_CFG_LLR_CF_ETYPE_OFFSET 0x00000718
+#define C1_HNI_PML_CFG_LLR_CF_ETYPE (C_HNI_PML_BASE + C1_HNI_PML_CFG_LLR_CF_ETYPE_OFFSET)
+#define C_HNI_PML_CFG_LLR_CF_ETYPE_SIZE 0x00000008
+#define C1_HNI_PML_CFG_LLR_CF_ETYPE_SIZE C_HNI_PML_CFG_LLR_CF_ETYPE_SIZE
+
+union c_hni_pml_cfg_llr_cf_etype {
+	__u64 qw;
+	struct {
+		__u64 ctl_frame_ethertype : 16;
+		__u64: 48;
+	};
+};
+
+#define SS2_PORT_PML_CFG_LLR_CF_ETYPE_OFFSET 0x00000950
+#define SS2_PORT_PML_CFG_LLR_CF_ETYPE (C_HNI_PML_BASE + SS2_PORT_PML_CFG_LLR_CF_ETYPE_OFFSET)
+#define SS2_PORT_PML_CFG_LLR_CF_ETYPE_SIZE 0x00000008
+
+union ss2_port_pml_cfg_llr_cf_etype {
+	__u64 qw;
+	struct {
+		__u64 ctl_frame_ethertype : 16;
+		__u64: 48;
+	};
+};
+
+#define C1_HNI_PML_CFG_LLR_CF_RATES_OFFSET 0x00000720
+#define C1_HNI_PML_CFG_LLR_CF_RATES (C_HNI_PML_BASE + C1_HNI_PML_CFG_LLR_CF_RATES_OFFSET)
+#define C1_HNI_PML_CFG_LLR_CF_RATES_SIZE 0x00000008
+
+union c_hni_pml_cfg_llr_cf_rates {
+	__u64 qw;
+	struct {
+		__u64 loop_timing_period : 16;
+		__u64 init_ctl_os_period : 4;
+		__u64: 44;
+	};
+};
+
+#define SS2_PORT_PML_CFG_LLR_CF_RATES_OFFSET(idx) (0x00000960 + ((idx) * 8))
+#define SS2_PORT_PML_CFG_LLR_CF_RATES_ENTRIES 4
+#define SS2_PORT_PML_CFG_LLR_CF_RATES(idx)                                                         \
+	(C_HNI_PML_BASE + SS2_PORT_PML_CFG_LLR_CF_RATES_OFFSET(idx))
+#define SS2_PORT_PML_CFG_LLR_CF_RATES_SIZE 0x00000020
+
+union ss2_port_pml_cfg_llr_cf_rates {
+	__u64 qw;
+	struct {
+		__u64 loop_timing_period : 16;
+		__u64 init_ctl_os_period : 4;
+		__u64: 44;
+	};
+};
+
+#define C1_HNI_PML_CFG_LLR_SM_OFFSET 0x00000728
+#define C1_HNI_PML_CFG_LLR_SM (C_HNI_PML_BASE + C1_HNI_PML_CFG_LLR_SM_OFFSET)
+#define C1_HNI_PML_CFG_LLR_SM_SIZE 0x00000008
+
+union c_hni_pml_cfg_llr_sm {
+	__u64 qw;
+	struct {
+		__u64 replay_timer_max : 16;
+		__u64 replay_ct_max : 8;
+		__u64 allow_re_init : 1;
+		__u64: 7;
+		__u64 retry_threshold : 8;
+		__u64: 24;
+	};
+};
+
+#define SS2_PORT_PML_CFG_LLR_SM_OFFSET(idx) (0x00000980 + ((idx) * 8))
+#define SS2_PORT_PML_CFG_LLR_SM_ENTRIES 4
+#define SS2_PORT_PML_CFG_LLR_SM(idx) (C_HNI_PML_BASE + SS2_PORT_PML_CFG_LLR_SM_OFFSET(idx))
+#define SS2_PORT_PML_CFG_LLR_SM_SIZE 0x00000020
+
+union ss2_port_pml_cfg_llr_sm {
+	__u64 qw;
+	struct {
+		__u64 replay_timer_max : 16;
+		__u64 replay_ct_max : 8;
+		__u64 allow_re_init : 1;
+		__u64: 7;
+		__u64 retry_threshold : 8;
+		__u64: 24;
+	};
+};
+
+#define C1_HNI_PML_CFG_LLR_CAPACITY_OFFSET 0x00000730
+#define C1_HNI_PML_CFG_LLR_CAPACITY (C_HNI_PML_BASE + C1_HNI_PML_CFG_LLR_CAPACITY_OFFSET)
+#define C1_HNI_PML_CFG_LLR_CAPACITY_SIZE 0x00000008
+
+union c1_hni_pml_cfg_llr_capacity {
+	__u64 qw;
+	struct {
+		__u64 max_seq : 12;
+		__u64: 4;
+		__u64 max_data : 12;
+		__u64: 36;
+	};
+};
+
+#define SS2_PORT_PML_CFG_LLR_CAPACITY_OFFSET(idx) (0x000009a0 + ((idx) * 8))
+#define SS2_PORT_PML_CFG_LLR_CAPACITY_ENTRIES 4
+#define SS2_PORT_PML_CFG_LLR_CAPACITY(idx)                                                         \
+	(C_HNI_PML_BASE + SS2_PORT_PML_CFG_LLR_CAPACITY_OFFSET(idx))
+#define SS2_PORT_PML_CFG_LLR_CAPACITY_SIZE 0x00000020
+
+union ss2_port_pml_cfg_llr_capacity {
+	__u64 qw;
+	struct {
+		__u64 max_seq : 12;
+		__u64: 4;
+		__u64 max_data : 12;
+		__u64: 4;
+		__u64: 32;
+	};
+};
+
+#define C1_HNI_PML_CFG_LLR_TIMEOUTS_OFFSET 0x00000738
+#define C1_HNI_PML_CFG_LLR_TIMEOUTS (C_HNI_PML_BASE + C1_HNI_PML_CFG_LLR_TIMEOUTS_OFFSET)
+#define C1_HNI_PML_CFG_LLR_TIMEOUTS_SIZE 0x00000008
+
+union c_hni_pml_cfg_llr_timeouts {
+	__u64 qw;
+	struct {
+		__u64 pcs_link_dn_timer_max : 32;
+		__u64 data_age_timer_max : 32;
+	};
+};
+
+#define SS2_PORT_PML_CFG_LLR_TIMEOUTS_OFFSET(idx) (0x000009c0 + ((idx) * 8))
+#define SS2_PORT_PML_CFG_LLR_TIMEOUTS_ENTRIES 4
+#define SS2_PORT_PML_CFG_LLR_TIMEOUTS(idx)                                                         \
+	(C_HNI_PML_BASE + SS2_PORT_PML_CFG_LLR_TIMEOUTS_OFFSET(idx))
+#define SS2_PORT_PML_CFG_LLR_TIMEOUTS_SIZE 0x00000020
+
+union ss2_port_pml_cfg_llr_timeouts {
+	__u64 qw;
+	struct {
+		__u64 pcs_link_dn_timer_max : 32;
+		__u64 data_age_timer_max : 32;
+	};
+};
+
+#define C1_HNI_PML_SERDES_CORE_STATUS_OFFSET(idx) (0x00000800 + ((idx) * 8))
+#define C1_HNI_PML_SERDES_CORE_STATUS_ENTRIES 4
+#define C1_HNI_PML_SERDES_CORE_STATUS(idx)                                                         \
+	(C_HNI_PML_BASE + C1_HNI_PML_SERDES_CORE_STATUS_OFFSET(idx))
+#define C1_HNI_PML_SERDES_CORE_STATUS_SIZE 0x00000020
+
+union c1_hni_pml_serdes_core_status {
+	__u64 qw;
+	struct {
+		__u64 core_status : 32;
+		__u64 rx_idle_detect : 1;
+		__u64 rx_rdy : 1;
+		__u64 tx_rdy : 1;
+		__u64: 29;
+	};
+};
+
+#define C1_HNI_PML_STS_PCS_AUTONEG_BASE_PAGE_OFFSET 0x00000820
+#define C1_HNI_PML_STS_PCS_AUTONEG_BASE_PAGE                                                       \
+	(C_HNI_PML_BASE + C1_HNI_PML_STS_PCS_AUTONEG_BASE_PAGE_OFFSET)
+#define C1_HNI_PML_STS_PCS_AUTONEG_BASE_PAGE_SIZE 0x00000008
+
+union c_hni_pml_sts_pcs_autoneg_base_page {
+	__u64 qw;
+	struct {
+		__u64 lp_base_page : 48;
+		__u64 lp_ability : 1;
+		__u64 page_received : 1;
+		__u64 base_page : 1;
+		__u64 state : 4;
+		__u64 complete : 1;
+		__u64 remaining_ack_ct : 3;
+		__u64 ack_match_ct : 2;
+		__u64 ability_match_ct : 2;
+		__u64: 1;
+	};
+};
+
+#define SS2_PORT_PML_STS_PCS_AUTONEG_BASE_PAGE_OFFSET(idx) (0x00001300 + ((idx) * 8))
+#define SS2_PORT_PML_STS_PCS_AUTONEG_BASE_PAGE_ENTRIES 4
+#define SS2_PORT_PML_STS_PCS_AUTONEG_BASE_PAGE(idx)                                                \
+	(C_HNI_PML_BASE + SS2_PORT_PML_STS_PCS_AUTONEG_BASE_PAGE_OFFSET(idx))
+#define SS2_PORT_PML_STS_PCS_AUTONEG_BASE_PAGE_SIZE 0x00000020
+
+union ss2_port_pml_sts_pcs_autoneg_base_page {
+	__u64 qw;
+	struct {
+		__u64 lp_base_page : 48;
+		__u64 lp_ability : 1;
+		__u64 page_received : 1;
+		__u64 base_page : 1;
+		__u64 state : 4;
+		__u64 complete : 1;
+		__u64 remaining_ack_ct : 3;
+		__u64 ack_match_ct : 2;
+		__u64 ability_match_ct : 2;
+		__u64: 1;
+	};
+};
+
+#define C1_HNI_PML_STS_PCS_AUTONEG_NEXT_PAGE_OFFSET 0x00000828
+#define C1_HNI_PML_STS_PCS_AUTONEG_NEXT_PAGE                                                       \
+	(C_HNI_PML_BASE + C1_HNI_PML_STS_PCS_AUTONEG_NEXT_PAGE_OFFSET)
+#define C1_HNI_PML_STS_PCS_AUTONEG_NEXT_PAGE_SIZE 0x00000008
+
+union c_hni_pml_sts_pcs_autoneg_next_page {
+	__u64 qw;
+	struct {
+		__u64 lp_next_page : 48;
+		__u64 lp_ability : 1;
+		__u64 page_received : 1;
+		__u64 base_page : 1;
+		__u64 state : 4;
+		__u64 complete : 1;
+		__u64 remaining_ack_ct : 3;
+		__u64 ack_match_ct : 2;
+		__u64 ability_match_ct : 2;
+		__u64: 1;
+	};
+};
+
+#define SS2_PORT_PML_STS_PCS_AUTONEG_NEXT_PAGE_OFFSET(idx) (0x00001320 + ((idx) * 8))
+#define SS2_PORT_PML_STS_PCS_AUTONEG_NEXT_PAGE_ENTRIES 4
+#define SS2_PORT_PML_STS_PCS_AUTONEG_NEXT_PAGE(idx)                                                \
+	(C_HNI_PML_BASE + SS2_PORT_PML_STS_PCS_AUTONEG_NEXT_PAGE_OFFSET(idx))
+#define SS2_PORT_PML_STS_PCS_AUTONEG_NEXT_PAGE_SIZE 0x00000020
+
+union ss2_port_pml_sts_pcs_autoneg_next_page {
+	__u64 qw;
+	struct {
+		__u64 lp_next_page : 48;
+		__u64 lp_ability : 1;
+		__u64 page_received : 1;
+		__u64 base_page : 1;
+		__u64 state : 4;
+		__u64 complete : 1;
+		__u64 remaining_ack_ct : 3;
+		__u64 ack_match_ct : 2;
+		__u64 ability_match_ct : 2;
+		__u64: 1;
+	};
+};
+
+#define C1_HNI_PML_STS_TX_PCS_OFFSET 0x00000830
+#define C1_HNI_PML_STS_TX_PCS (C_HNI_PML_BASE + C1_HNI_PML_STS_TX_PCS_OFFSET)
+#define C1_HNI_PML_STS_TX_PCS_SIZE 0x00000008
+
+union c_hni_pml_sts_tx_pcs {
+	__u64 qw;
+	struct {
+		__u64 timestamp : 32;
+		__u64 timestamp_valid : 1;
+		__u64: 31;
+	};
+};
+
+#define SS2_PORT_PML_STS_TX_PCS_OFFSET(idx) (0x00001340 + ((idx) * 8))
+#define SS2_PORT_PML_STS_TX_PCS_ENTRIES 4
+#define SS2_PORT_PML_STS_TX_PCS(idx) (C_HNI_PML_BASE + SS2_PORT_PML_STS_TX_PCS_OFFSET(idx))
+#define SS2_PORT_PML_STS_TX_PCS_SIZE 0x00000020
+
+union ss2_port_pml_sts_tx_pcs {
+	__u64 qw;
+	struct {
+		__u64 timestamp : 32;
+		__u64 timestamp_valid : 1;
+		__u64: 31;
+	};
+};
+
+#define C1_HNI_PML_STS_RX_PCS_OFFSET 0x00000838
+#define C1_HNI_PML_STS_RX_PCS (C_HNI_PML_BASE + C1_HNI_PML_STS_RX_PCS_OFFSET)
+#define C1_HNI_PML_STS_RX_PCS_SIZE 0x00000008
+
+union c1_hni_pml_sts_rx_pcs {
+	__u64 qw;
+	struct {
+		__u64 am_identity_0 : 3;
+		__u64: 1;
+		__u64 am_identity_1 : 3;
+		__u64: 1;
+		__u64 am_identity_2 : 3;
+		__u64: 1;
+		__u64 am_identity_3 : 3;
+		__u64: 1;
+		__u64 am_identity_4 : 3;
+		__u64: 1;
+		__u64 am_identity_5 : 3;
+		__u64: 1;
+		__u64 am_identity_6 : 3;
+		__u64: 1;
+		__u64 am_identity_7 : 3;
+		__u64: 1;
+		__u64 am_lock : 8;
+		__u64 align_status : 1;
+		__u64: 7;
+		__u64 fault : 1;
+		__u64 local_fault : 1;
+		__u64 hi_ser : 1;
+		__u64: 13;
+	};
+};
+
+#define C1_HNI_PML_STS_RX_PCS_AM_MATCH_OFFSET 0x00000840
+#define C1_HNI_PML_STS_RX_PCS_AM_MATCH (C_HNI_PML_BASE + C1_HNI_PML_STS_RX_PCS_AM_MATCH_OFFSET)
+#define C1_HNI_PML_STS_RX_PCS_AM_MATCH_SIZE 0x00000008
+
+union c1_hni_pml_sts_rx_pcs_am_match {
+	__u64 qw;
+	struct {
+		__u64 am_match_state_0 : 2;
+		__u64 am_match_pos_0 : 6;
+		__u64 am_match_state_1 : 2;
+		__u64 am_match_pos_1 : 6;
+		__u64 am_match_state_2 : 2;
+		__u64 am_match_pos_2 : 6;
+		__u64 am_match_state_3 : 2;
+		__u64 am_match_pos_3 : 6;
+		__u64 am_match_state_4 : 2;
+		__u64 am_match_pos_4 : 6;
+		__u64 am_match_state_5 : 2;
+		__u64 am_match_pos_5 : 6;
+		__u64 am_match_state_6 : 2;
+		__u64 am_match_pos_6 : 6;
+		__u64 am_match_state_7 : 2;
+		__u64 am_match_pos_7 : 6;
+	};
+};
+
+#define C1_HNI_PML_STS_RX_PCS_FECL_SOURCES_OFFSET 0x00000848
+#define C1_HNI_PML_STS_RX_PCS_FECL_SOURCES                                                         \
+	(C_HNI_PML_BASE + C1_HNI_PML_STS_RX_PCS_FECL_SOURCES_OFFSET)
+#define C1_HNI_PML_STS_RX_PCS_FECL_SOURCES_SIZE 0x00000008
+
+union c1_hni_pml_sts_rx_pcs_fecl_sources {
+	__u64 qw;
+	struct {
+		__u64 fecl_source_0 : 3;
+		__u64 fecl_source_vld_0 : 1;
+		__u64: 4;
+		__u64 fecl_source_1 : 3;
+		__u64 fecl_source_vld_1 : 1;
+		__u64: 4;
+		__u64 fecl_source_2 : 3;
+		__u64 fecl_source_vld_2 : 1;
+		__u64: 4;
+		__u64 fecl_source_3 : 3;
+		__u64 fecl_source_vld_3 : 1;
+		__u64: 4;
+		__u64 fecl_source_4 : 3;
+		__u64 fecl_source_vld_4 : 1;
+		__u64: 4;
+		__u64 fecl_source_5 : 3;
+		__u64 fecl_source_vld_5 : 1;
+		__u64: 4;
+		__u64 fecl_source_6 : 3;
+		__u64 fecl_source_vld_6 : 1;
+		__u64: 4;
+		__u64 fecl_source_7 : 3;
+		__u64 fecl_source_vld_7 : 1;
+		__u64: 4;
+	};
+};
+
+#define C1_HNI_PML_STS_RX_PCS_DESKEW_DEPTHS_OFFSET 0x00000850
+#define C1_HNI_PML_STS_RX_PCS_DESKEW_DEPTHS                                                        \
+	(C_HNI_PML_BASE + C1_HNI_PML_STS_RX_PCS_DESKEW_DEPTHS_OFFSET)
+#define C1_HNI_PML_STS_RX_PCS_DESKEW_DEPTHS_SIZE 0x00000008
+
+union c1_hni_pml_sts_rx_pcs_deskew_depths {
+	__u64 qw;
+	struct {
+		__u64 df_depth_0 : 8;
+		__u64 df_depth_1 : 8;
+		__u64 df_depth_2 : 8;
+		__u64 df_depth_3 : 8;
+		__u64 df_depth_4 : 8;
+		__u64 df_depth_5 : 8;
+		__u64 df_depth_6 : 8;
+		__u64 df_depth_7 : 8;
+	};
+};
+
+#define C1_HNI_PML_STS_PCS_LANE_DEGRADE_OFFSET 0x00000868
+#define C1_HNI_PML_STS_PCS_LANE_DEGRADE (C_HNI_PML_BASE + C1_HNI_PML_STS_PCS_LANE_DEGRADE_OFFSET)
+#define C1_HNI_PML_STS_PCS_LANE_DEGRADE_SIZE 0x00000008
+
+union c1_hni_pml_sts_pcs_lane_degrade {
+	__u64 qw;
+	struct {
+		__u64 rx_fecl_health_good : 8;
+		__u64 lp_pls_available : 4;
+		__u64: 4;
+		__u64 rx_state : 2;
+		__u64: 2;
+		__u64 rx_pls_available : 4;
+		__u64 tx_state : 2;
+		__u64: 2;
+		__u64 tx_lane : 2;
+		__u64: 2;
+		__u64 lp_health_bad_0 : 4;
+		__u64 lp_health_bad_1 : 4;
+		__u64 lp_health_bad_2 : 4;
+		__u64 lp_health_bad_3 : 4;
+		__u64 lp_health_good_0 : 4;
+		__u64 lp_health_good_1 : 4;
+		__u64 lp_health_good_2 : 4;
+		__u64 lp_health_good_3 : 4;
+	};
+};
+
+#define SS2_PORT_PML_STS_PCS_LANE_DEGRADE_OFFSET 0x00001460
+#define SS2_PORT_PML_STS_PCS_LANE_DEGRADE                                                          \
+	(C_HNI_PML_BASE + SS2_PORT_PML_STS_PCS_LANE_DEGRADE_OFFSET)
+#define SS2_PORT_PML_STS_PCS_LANE_DEGRADE_SIZE 0x00000010
+
+union ss2_port_pml_sts_pcs_lane_degrade {
+	__u64 qw[2];
+	struct {
+		__u64 rx_fecl_health_good : 16;
+		__u64 lp_pls_available : 4;
+		__u64 rx_state : 3;
+		__u64: 1;
+		__u64 rx_pls_available : 4;
+		__u64 tx_state : 3;
+		__u64: 1;
+		__u64 tx_lane : 2;
+		__u64: 2;
+		__u64 degrade_failure : 1;
+		__u64 degrading : 1;
+		__u64: 26;
+		__u64 lp_health_bad_0 : 5;
+		__u64: 3;
+		__u64 lp_health_bad_1 : 5;
+		__u64: 3;
+		__u64 lp_health_bad_2 : 5;
+		__u64: 3;
+		__u64 lp_health_bad_3 : 5;
+		__u64: 3;
+		__u64 lp_health_good_0 : 5;
+		__u64: 3;
+		__u64 lp_health_good_1 : 5;
+		__u64: 3;
+		__u64 lp_health_good_2 : 5;
+		__u64: 3;
+		__u64 lp_health_good_3 : 5;
+		__u64: 3;
+	};
+};
+
+#define C1_HNI_PML_STS_LLR_OFFSET 0x00000a00
+#define C1_HNI_PML_STS_LLR (C_HNI_PML_BASE + C1_HNI_PML_STS_LLR_OFFSET)
+#define C1_HNI_PML_STS_LLR_SIZE 0x00000008
+
+union c_hni_pml_sts_llr {
+	__u64 qw;
+	struct {
+		__u64 llr_state : 3;
+		__u64: 1;
+		__u64 tx_seq : 20;
+		__u64 timestamp_frame_in_buffer : 1;
+		__u64 timestamp_frame_ackd : 1;
+		__u64: 6;
+		__u64 ack_state : 2;
+		__u64: 2;
+		__u64 ackd_seq : 20;
+		__u64: 8;
+	};
+};
+
+#define SS2_PORT_PML_STS_LLR_OFFSET(idx) (0x00001500 + ((idx) * 8))
+#define SS2_PORT_PML_STS_LLR_ENTRIES 4
+#define SS2_PORT_PML_STS_LLR(idx) (C_HNI_PML_BASE + SS2_PORT_PML_STS_LLR_OFFSET(idx))
+#define SS2_PORT_PML_STS_LLR_SIZE 0x00000020
+
+union ss2_port_pml_sts_llr {
+	__u64 qw;
+	struct {
+		__u64 llr_state : 3;
+		__u64: 1;
+		__u64 tx_seq : 20;
+		__u64 timestamp_frame_in_buffer : 1;
+		__u64 timestamp_frame_ackd : 1;
+		__u64: 6;
+		__u64 ack_state : 2;
+		__u64: 2;
+		__u64 ackd_seq : 20;
+		__u64: 8;
+	};
+};
+
+#define C1_HNI_PML_STS_LLR_LOOP_TIME_OFFSET 0x00000a08
+#define C1_HNI_PML_STS_LLR_LOOP_TIME (C_HNI_PML_BASE + C1_HNI_PML_STS_LLR_LOOP_TIME_OFFSET)
+#define C1_HNI_PML_STS_LLR_LOOP_TIME_SIZE 0x00000008
+
+union c_hni_pml_sts_llr_loop_time {
+	__u64 qw;
+	struct {
+		__u64 loop_time : 16;
+		__u64: 48;
+	};
+};
+
+#define SS2_PORT_PML_STS_LLR_LOOP_TIME_OFFSET(idx) (0x00001520 + ((idx) * 8))
+#define SS2_PORT_PML_STS_LLR_LOOP_TIME_ENTRIES 4
+#define SS2_PORT_PML_STS_LLR_LOOP_TIME(idx)                                                        \
+	(C_HNI_PML_BASE + SS2_PORT_PML_STS_LLR_LOOP_TIME_OFFSET(idx))
+#define SS2_PORT_PML_STS_LLR_LOOP_TIME_SIZE 0x00000020
+
+union ss2_port_pml_sts_llr_loop_time {
+	__u64 qw;
+	struct {
+		__u64 loop_time : 16;
+		__u64: 48;
+	};
+};
+
+#define C1_HNI_PML_STS_LLR_USAGE_OFFSET 0x00000a18
+#define C1_HNI_PML_STS_LLR_USAGE (C_HNI_PML_BASE + C1_HNI_PML_STS_LLR_USAGE_OFFSET)
+#define C1_HNI_PML_STS_LLR_USAGE_SIZE 0x00000008
+
+union c_hni_pml_sts_llr_usage {
+	__u64 qw;
+	struct {
+		__u64 buffer_space_used : 12;
+		__u64: 4;
+		__u64 outstanding_seq : 20;
+		__u64: 28;
+	};
+};
+
+#define SS2_PORT_PML_STS_LLR_USAGE_OFFSET(idx) (0x00001560 + ((idx) * 8))
+#define SS2_PORT_PML_STS_LLR_USAGE_ENTRIES 4
+#define SS2_PORT_PML_STS_LLR_USAGE(idx) (C_HNI_PML_BASE + SS2_PORT_PML_STS_LLR_USAGE_OFFSET(idx))
+#define SS2_PORT_PML_STS_LLR_USAGE_SIZE 0x00000020
+
+union ss2_port_pml_sts_llr_usage {
+	__u64 qw;
+	struct {
+		__u64 buffer_space_used : 12;
+		__u64: 4;
+		__u64 outstanding_seq : 20;
+		__u64: 28;
+	};
+};
+
+#define C1_HNI_PML_STS_LLR_MAX_USAGE_OFFSET 0x00000a20
+#define C1_HNI_PML_STS_LLR_MAX_USAGE (C_HNI_PML_BASE + C1_HNI_PML_STS_LLR_MAX_USAGE_OFFSET)
+#define C1_HNI_PML_STS_LLR_MAX_USAGE_SIZE 0x00000008
+
+union c_hni_pml_sts_llr_max_usage {
+	__u64 qw;
+	struct {
+		__u64 max_buffer_space_used : 12;
+		__u64 max_outstanding_seq : 20;
+		__u64 max_starvation_time : 16;
+		__u64 seq_starved : 1;
+		__u64 buffer_space_starved : 1;
+		__u64: 14;
+	};
+};
+
+#define SS2_PORT_PML_STS_LLR_MAX_USAGE_OFFSET(idx) (0x00001580 + ((idx) * 8))
+#define SS2_PORT_PML_STS_LLR_MAX_USAGE_ENTRIES 4
+#define SS2_PORT_PML_STS_LLR_MAX_USAGE(idx)                                                        \
+	(C_HNI_PML_BASE + SS2_PORT_PML_STS_LLR_MAX_USAGE_OFFSET(idx))
+#define SS2_PORT_PML_STS_LLR_MAX_USAGE_SIZE 0x00000020
+
+union ss2_port_pml_sts_llr_max_usage {
+	__u64 qw;
+	struct {
+		__u64 max_buffer_space_used : 12;
+		__u64 max_outstanding_seq : 20;
+		__u64 max_starvation_time : 16;
+		__u64 seq_starved : 1;
+		__u64 buffer_space_starved : 1;
+		__u64: 14;
+	};
+};
+
+#define C1_HNI_PML_DBG_PCS_OFFSET 0x00000c10
+#define C1_HNI_PML_DBG_PCS (C_HNI_PML_BASE + C1_HNI_PML_DBG_PCS_OFFSET)
+#define C1_HNI_PML_DBG_PCS_SIZE 0x00000008
+
+union c1_hni_pml_dbg_pcs {
+	__u64 qw;
+	struct {
+		__u64 tx_scrambler_en : 1;
+		__u64 rx_descrambler_en : 1;
+		__u64: 6;
+		__u64 enable_rapid_alignment : 1;
+		__u64: 7;
+		__u64 force_bad_bip : 5;
+		__u64: 3;
+		__u64 enable_idle_check : 1;
+		__u64: 7;
+		__u64 force_tx_data : 1;
+		__u64 force_tx_data_rf : 1;
+		__u64: 6;
+		__u64 ppm_test_mode : 1;
+		__u64: 23;
+	};
+};
+
+#define SS2_PORT_PML_DBG_PCS_OFFSET(idx) (0x00001740 + ((idx) * 8))
+#define SS2_PORT_PML_DBG_PCS_ENTRIES 4
+#define SS2_PORT_PML_DBG_PCS(idx) (C_HNI_PML_BASE + SS2_PORT_PML_DBG_PCS_OFFSET(idx))
+#define SS2_PORT_PML_DBG_PCS_SIZE 0x00000020
+
+union ss2_port_pml_dbg_pcs {
+	__u64 qw;
+	struct {
+		__u64 tx_scrambler_en : 1;
+		__u64 rx_descrambler_en : 1;
+		__u64: 6;
+		__u64 enable_rapid_alignment : 1;
+		__u64: 7;
+		__u64 force_bad_bip : 5;
+		__u64: 3;
+		__u64 enable_idle_check : 1;
+		__u64: 7;
+		__u64 force_tx_data : 1;
+		__u64 force_tx_data_rf : 1;
+		__u64: 6;
+		__u64 ppm_test_mode : 1;
+		__u64 tx_clk_select : 2;
+		__u64: 21;
+	};
+};
+
+#define C_IXE_CFG_CRNC_OFFSET 0x00000000
+#define C_IXE_CFG_CRNC (C_IXE_BASE + C_IXE_CFG_CRNC_OFFSET)
+#define C_IXE_CFG_CRNC_SIZE 0x00000008
+
+union c_ixe_cfg_crnc {
+	__u64 qw;
+	struct {
+		__u64 csr_timeout : 8;
+		__u64 mcast_id : 10;
+		__u64: 1;
+		__u64 mcast_enable : 1;
+		__u64 mcast_mask : 10;
+		__u64: 34;
+	};
+};
+
+#define C_IXE_MSC_SHADOW_ACTION_OFFSET 0x00000038
+#define C_IXE_MSC_SHADOW_ACTION (C_IXE_BASE + C_IXE_MSC_SHADOW_ACTION_OFFSET)
+#define C_IXE_MSC_SHADOW_ACTION_SIZE 0x00000008
+#define C_IXE_MSC_SHADOW_OFFSET 0x00000080
+#define C_IXE_MSC_SHADOW (C_IXE_BASE + C_IXE_MSC_SHADOW_OFFSET)
+#define C_IXE_MSC_SHADOW_SIZE 0x00000048
+
+union c_ixe_msc_shadow {
+	__u64 qw[9];
+};
+
+#define C_IXE_ERR_ELAPSED_TIME_OFFSET 0x00000100
+#define C_IXE_ERR_ELAPSED_TIME (C_IXE_BASE + C_IXE_ERR_ELAPSED_TIME_OFFSET)
+#define C_IXE_ERR_ELAPSED_TIME_SIZE 0x00000008
+
+union c_ixe_err_elapsed_time {
+	__u64 qw;
+	struct {
+		__u64 nanoseconds : 30;
+		__u64 seconds : 34;
+	};
+};
+
+#define C_IXE_ERR_FLG_OFFSET 0x00000108
+#define C_IXE_ERR_FLG (C_IXE_BASE + C_IXE_ERR_FLG_OFFSET)
+#define C_IXE_ERR_FLG_SIZE 0x00000008
+
+union c_ixe_err_flg {
+	__u64 qw;
+	struct {
+		__u64 sw_diag : 1;
+		__u64 crnc_ring_sync_error : 1;
+		__u64 crnc_ring_ecc_sbe : 1;
+		__u64 crnc_ring_ecc_mbe : 1;
+		__u64 crnc_ring_cmd_unknown : 1;
+		__u64 crnc_csr_cmd_unknown : 1;
+		__u64 crnc_csr_cmd_incomplete : 1;
+		__u64 crnc_buf_ecc_sbe : 1;
+		__u64 crnc_buf_ecc_mbe : 1;
+		__u64: 23;
+		__u64 pafa_perr : 1;
+		__u64 fifo_err : 1;
+		__u64 credit_uflw : 1;
+		__u64 pcie_unsuccess_cmpl : 1;
+		__u64 pcie_error_poisoned : 1;
+		__u64 port_dfa_mismatch : 1;
+		__u64 port_discard_trig : 1;
+		__u64 hdr_checksum_err : 1;
+		__u64 hdr_ecc_err : 1;
+		__u64 get_len_err : 1;
+		__u64 ipv4_checksum_err : 1;
+		__u64 ipv4_options_err : 1;
+		__u64 ipv6_options_err : 1;
+		__u64 hrp_req_err : 1;
+		__u64 parser_disable : 1;
+		__u64 pbuf_pkt_perr : 1;
+		__u64 pbuf_rd_err : 1;
+		__u64 pkt_flit_fifo_perr : 1;
+		__u64 amo_align_err : 1;
+		__u64 amo_op_err : 1;
+		__u64 amo_fp_inexact : 1;
+		__u64 amo_fp_overflow : 1;
+		__u64 amo_fp_underflow : 1;
+		__u64 amo_fp_invalid : 1;
+		__u64 rarb_hw_err : 1;
+		__u64 amo_length_err : 1;
+		__u64 pbuf_overflow : 1;
+		__u64: 5;
+	};
+};
+
+#define C_IXE_ERR_FIRST_FLG_OFFSET 0x00000110
+#define C_IXE_ERR_FIRST_FLG (C_IXE_BASE + C_IXE_ERR_FIRST_FLG_OFFSET)
+#define C_IXE_ERR_FIRST_FLG_SIZE 0x00000008
+#define C_IXE_ERR_FIRST_FLG_TS_OFFSET 0x00000118
+#define C_IXE_ERR_FIRST_FLG_TS (C_IXE_BASE + C_IXE_ERR_FIRST_FLG_TS_OFFSET)
+#define C_IXE_ERR_FIRST_FLG_TS_SIZE 0x00000008
+#define C_IXE_ERR_CLR_OFFSET 0x00000120
+#define C_IXE_ERR_CLR (C_IXE_BASE + C_IXE_ERR_CLR_OFFSET)
+#define C_IXE_ERR_CLR_SIZE 0x00000008
+#define C_IXE_ERR_IRQA_MSK_OFFSET 0x00000128
+#define C_IXE_ERR_IRQA_MSK (C_IXE_BASE + C_IXE_ERR_IRQA_MSK_OFFSET)
+#define C_IXE_ERR_IRQA_MSK_SIZE 0x00000008
+#define C_IXE_ERR_IRQB_MSK_OFFSET 0x00000130
+#define C_IXE_ERR_IRQB_MSK (C_IXE_BASE + C_IXE_ERR_IRQB_MSK_OFFSET)
+#define C_IXE_ERR_IRQB_MSK_SIZE 0x00000008
+#define C_IXE_ERR_INFO_MSK_OFFSET 0x00000140
+#define C_IXE_ERR_INFO_MSK (C_IXE_BASE + C_IXE_ERR_INFO_MSK_OFFSET)
+#define C_IXE_ERR_INFO_MSK_SIZE 0x00000008
+#define C_IXE_EXT_ERR_FLG_OFFSET 0x00000148
+#define C_IXE_EXT_ERR_FLG (C_IXE_BASE + C_IXE_EXT_ERR_FLG_OFFSET)
+#define C_IXE_EXT_ERR_FLG_SIZE 0x00000008
+
+union c_ixe_ext_err_flg {
+	__u64 qw;
+	struct {
+		__u64 sw_diag : 1;
+		__u64 flop_fifo_cor : 1;
+		__u64 put_resp_mem_cor : 1;
+		__u64 get_req_mem_cor : 1;
+		__u64 rdfq_list_mem_cor : 1;
+		__u64 wr_md_mem_cor : 1;
+		__u64 event_fifo_cor : 1;
+		__u64 wr_ev_mem_cor : 1;
+		__u64 pkt_flit_fifo_cor : 1;
+		__u64 pbuf_list_mem_cor : 1;
+		__u64 pbuf_sb_mem_cor : 1;
+		__u64 atu_resp_cor : 1;
+		__u64 rdoq_cor : 1;
+		__u64 ingressq_cor : 1;
+		__u64 info_cor : 1;
+		__u64 cmd_info_cor : 1;
+		__u64 sideband_cor : 1;
+		__u64 p_cmd_cor : 1;
+		__u64 np_cmd_cor : 1;
+		__u64 amo_info_cor : 1;
+		__u64 addr_cor : 1;
+		__u64 rd_buf_cor : 1;
+		__u64 ack_rd_buf_cor : 1;
+		__u64 hni_flit_cor : 1;
+		__u64 rpu_list_mem_cor : 1;
+		__u64 rpu_st_mem_cor : 1;
+		__u64 rarb_hdr_bus_cor : 1;
+		__u64 rarb_data_bus_cor : 1;
+		__u64 pbuf_flit_mem_cor : 1;
+		__u64: 3;
+		__u64: 1;
+		__u64 flop_fifo_ucor : 1;
+		__u64 put_resp_mem_ucor : 1;
+		__u64 get_req_mem_ucor : 1;
+		__u64 rdfq_list_mem_ucor : 1;
+		__u64 wr_md_mem_ucor : 1;
+		__u64 event_fifo_ucor : 1;
+		__u64 wr_ev_mem_ucor : 1;
+		__u64 pkt_flit_fifo_ucor : 1;
+		__u64 pbuf_list_mem_ucor : 1;
+		__u64 pbuf_sb_mem_ucor : 1;
+		__u64 atu_resp_ucor : 1;
+		__u64 rdoq_ucor : 1;
+		__u64 ingressq_ucor : 1;
+		__u64 info_ucor : 1;
+		__u64 cmd_info_ucor : 1;
+		__u64 sideband_ucor : 1;
+		__u64 p_cmd_ucor : 1;
+		__u64 np_cmd_ucor : 1;
+		__u64 amo_info_ucor : 1;
+		__u64 addr_ucor : 1;
+		__u64 rd_buf_ucor : 1;
+		__u64 ack_rd_buf_ucor : 1;
+		__u64 hni_flit_ucor : 1;
+		__u64 rpu_list_mem_ucor : 1;
+		__u64 rpu_st_mem_ucor : 1;
+		__u64 rarb_hdr_bus_ucor : 1;
+		__u64 rarb_data_bus_ucor : 1;
+		__u64 pbuf_flit_mem_ucor : 1;
+		__u64: 3;
+	};
+};
+
+#define C_IXE_EXT_ERR_FIRST_FLG_OFFSET 0x00000150
+#define C_IXE_EXT_ERR_FIRST_FLG (C_IXE_BASE + C_IXE_EXT_ERR_FIRST_FLG_OFFSET)
+#define C_IXE_EXT_ERR_FIRST_FLG_SIZE 0x00000008
+#define C_IXE_EXT_ERR_FIRST_FLG_TS_OFFSET 0x00000158
+#define C_IXE_EXT_ERR_FIRST_FLG_TS (C_IXE_BASE + C_IXE_EXT_ERR_FIRST_FLG_TS_OFFSET)
+#define C_IXE_EXT_ERR_FIRST_FLG_TS_SIZE 0x00000008
+#define C_IXE_EXT_ERR_CLR_OFFSET 0x00000160
+#define C_IXE_EXT_ERR_CLR (C_IXE_BASE + C_IXE_EXT_ERR_CLR_OFFSET)
+#define C_IXE_EXT_ERR_CLR_SIZE 0x00000008
+#define C_IXE_EXT_ERR_IRQA_MSK_OFFSET 0x00000168
+#define C_IXE_EXT_ERR_IRQA_MSK (C_IXE_BASE + C_IXE_EXT_ERR_IRQA_MSK_OFFSET)
+#define C_IXE_EXT_ERR_IRQA_MSK_SIZE 0x00000008
+#define C_IXE_EXT_ERR_IRQB_MSK_OFFSET 0x00000170
+#define C_IXE_EXT_ERR_IRQB_MSK (C_IXE_BASE + C_IXE_EXT_ERR_IRQB_MSK_OFFSET)
+#define C_IXE_EXT_ERR_IRQB_MSK_SIZE 0x00000008
+#define C_IXE_EXT_ERR_INFO_MSK_OFFSET 0x00000180
+#define C_IXE_EXT_ERR_INFO_MSK (C_IXE_BASE + C_IXE_EXT_ERR_INFO_MSK_OFFSET)
+#define C_IXE_EXT_ERR_INFO_MSK_SIZE 0x00000008
+#define C_IXE_ERR_INFO_MEM_OFFSET 0x00000190
+#define C_IXE_ERR_INFO_MEM (C_IXE_BASE + C_IXE_ERR_INFO_MEM_OFFSET)
+#define C_IXE_ERR_INFO_MEM_SIZE 0x00000008
+
+union c_ixe_err_info_mem {
+	__u64 qw;
+	struct {
+		__u64 cor_syndrome : 11;
+		__u64: 1;
+		__u64 cor_address : 11;
+		__u64: 1;
+		__u64 cor_mem_id : 6;
+		__u64: 1;
+		__u64 cor_csr_detected : 1;
+		__u64 ucor_syndrome : 11;
+		__u64: 1;
+		__u64 ucor_address : 11;
+		__u64: 1;
+		__u64 ucor_mem_id : 6;
+		__u64: 1;
+		__u64 ucor_csr_detected : 1;
+	};
+};
+
+#define C_IXE_ERR_INFO_FIFO_ERR_OFFSET 0x00000198
+#define C_IXE_ERR_INFO_FIFO_ERR (C_IXE_BASE + C_IXE_ERR_INFO_FIFO_ERR_OFFSET)
+#define C_IXE_ERR_INFO_FIFO_ERR_SIZE 0x00000008
+
+union c_ixe_err_info_fifo_err {
+	__u64 qw;
+	struct {
+		__u64 overrun : 1;
+		__u64 underrun : 1;
+		__u64: 6;
+		__u64 fifo_id : 5;
+		__u64: 51;
+	};
+};
+
+#define C_IXE_ERR_INFO_CC_OFFSET 0x000001a0
+#define C_IXE_ERR_INFO_CC (C_IXE_BASE + C_IXE_ERR_INFO_CC_OFFSET)
+#define C_IXE_ERR_INFO_CC_SIZE 0x00000008
+
+union c_ixe_err_info_cc {
+	__u64 qw;
+	struct {
+		__u64 cc_id : 4;
+		__u64: 4;
+		__u64 sub_id : 5;
+		__u64: 51;
+	};
+};
+
+#define C_IXE_ERR_INFO_PCIE_EP_OFFSET 0x00000200
+#define C_IXE_ERR_INFO_PCIE_EP (C_IXE_BASE + C_IXE_ERR_INFO_PCIE_EP_OFFSET)
+#define C_IXE_ERR_INFO_PCIE_EP_SIZE 0x00000008
+
+union c_ixe_err_info_pcie_ep {
+	__u64 qw;
+	struct {
+		__u64 pcie_tag : 9;
+		__u64: 55;
+	};
+};
+
+#define C_IXE_ERR_INFO_PCIE_UC_OFFSET 0x00000208
+#define C_IXE_ERR_INFO_PCIE_UC (C_IXE_BASE + C_IXE_ERR_INFO_PCIE_UC_OFFSET)
+#define C_IXE_ERR_INFO_PCIE_UC_SIZE 0x00000008
+
+union c_ixe_err_info_pcie_uc {
+	__u64 qw;
+	struct {
+		__u64 pcie_tag : 9;
+		__u64: 3;
+		__u64 cmpl_status : 3;
+		__u64: 49;
+	};
+};
+
+#define C_IXE_ERR_INFO_ETH_PARSE_OFFSET 0x00000210
+#define C_IXE_ERR_INFO_ETH_PARSE (C_IXE_BASE + C_IXE_ERR_INFO_ETH_PARSE_OFFSET)
+#define C_IXE_ERR_INFO_ETH_PARSE_SIZE 0x00000008
+
+union c_ixe_err_info_eth_parse {
+	__u64 qw;
+	struct {
+		__u64 ptlte_index : 11;
+		__u64: 1;
+		__u64 ipv4_checksum_err : 1;
+		__u64 ipv4_options_err : 1;
+		__u64 ipv6_options_err : 1;
+		__u64: 49;
+	};
+};
+
+#define C_IXE_ERR_INFO_RARB_OFFSET 0x00000218
+#define C_IXE_ERR_INFO_RARB (C_IXE_BASE + C_IXE_ERR_INFO_RARB_OFFSET)
+#define C_IXE_ERR_INFO_RARB_SIZE 0x00000008
+
+union c_ixe_err_info_rarb {
+	__u64 qw;
+	struct {
+		__u64 hdr_ucor : 1;
+		__u64 data_ucor : 1;
+		__u64 bad_cmpl_last : 1;
+		__u64 bad_vld : 1;
+		__u64 bad_eop : 1;
+		__u64 bad_cmd : 1;
+		__u64 unexpected_cmpl_tag : 1;
+		__u64 cmpl_tag_out_of_range : 1;
+		__u64: 56;
+	};
+};
+
+#define C_IXE_ERR_INFO_FP_INVALID_OFFSET 0x00000220
+#define C_IXE_ERR_INFO_FP_INVALID (C_IXE_BASE + C_IXE_ERR_INFO_FP_INVALID_OFFSET)
+#define C_IXE_ERR_INFO_FP_INVALID_SIZE 0x00000010
+
+union c_ixe_err_info_fp_invalid {
+	__u64 qw[2];
+	struct {
+		__u64: 2;
+		__u64 addr_56_2 : 55;
+		__u64: 7;
+		__u64 acid : 10;
+		__u64: 2;
+		__u64 atomic_type : 4;
+		__u64: 48;
+	};
+};
+
+#define C_IXE_ERR_INFO_FP_UNDERFLOW_OFFSET 0x00000230
+#define C_IXE_ERR_INFO_FP_UNDERFLOW (C_IXE_BASE + C_IXE_ERR_INFO_FP_UNDERFLOW_OFFSET)
+#define C_IXE_ERR_INFO_FP_UNDERFLOW_SIZE 0x00000010
+
+union c_ixe_err_info_fp_underflow {
+	__u64 qw[2];
+	struct {
+		__u64: 2;
+		__u64 addr_56_2 : 55;
+		__u64: 7;
+		__u64 acid : 10;
+		__u64: 2;
+		__u64 atomic_type : 4;
+		__u64: 48;
+	};
+};
+
+#define C_IXE_ERR_INFO_FP_OVERFLOW_OFFSET 0x00000240
+#define C_IXE_ERR_INFO_FP_OVERFLOW (C_IXE_BASE + C_IXE_ERR_INFO_FP_OVERFLOW_OFFSET)
+#define C_IXE_ERR_INFO_FP_OVERFLOW_SIZE 0x00000010
+
+union c_ixe_err_info_fp_overflow {
+	__u64 qw[2];
+	struct {
+		__u64: 2;
+		__u64 addr_56_2 : 55;
+		__u64: 7;
+		__u64 acid : 10;
+		__u64: 2;
+		__u64 atomic_type : 4;
+		__u64: 48;
+	};
+};
+
+#define C_IXE_ERR_INFO_FP_INEXACT_OFFSET 0x00000250
+#define C_IXE_ERR_INFO_FP_INEXACT (C_IXE_BASE + C_IXE_ERR_INFO_FP_INEXACT_OFFSET)
+#define C_IXE_ERR_INFO_FP_INEXACT_SIZE 0x00000010
+
+union c_ixe_err_info_fp_inexact {
+	__u64 qw[2];
+	struct {
+		__u64: 2;
+		__u64 addr_56_2 : 55;
+		__u64: 7;
+		__u64 acid : 10;
+		__u64: 2;
+		__u64 atomic_type : 4;
+		__u64: 48;
+	};
+};
+
+#define C_IXE_ERR_INFO_AMO_ALIGN_OFFSET 0x00000260
+#define C_IXE_ERR_INFO_AMO_ALIGN (C_IXE_BASE + C_IXE_ERR_INFO_AMO_ALIGN_OFFSET)
+#define C_IXE_ERR_INFO_AMO_ALIGN_SIZE 0x00000010
+
+union c_ixe_err_info_amo_align {
+	__u64 qw[2];
+	struct {
+		__u64 addr_56_0 : 57;
+		__u64: 7;
+		__u64 acid : 10;
+		__u64: 2;
+		__u64 atomic_type : 4;
+		__u64: 48;
+	};
+};
+
+#define C_IXE_ERR_INFO_AMO_OP_OFFSET 0x00000270
+#define C_IXE_ERR_INFO_AMO_OP (C_IXE_BASE + C_IXE_ERR_INFO_AMO_OP_OFFSET)
+#define C_IXE_ERR_INFO_AMO_OP_SIZE 0x00000010
+
+union c_ixe_err_info_amo_op {
+	__u64 qw[2];
+	struct {
+		__u64 addr_56_0 : 57;
+		__u64: 7;
+		__u64 acid : 10;
+		__u64: 2;
+		__u64 atomic_type : 4;
+		__u64 cswap_op : 3;
+		__u64: 1;
+		__u64 atomic_op : 4;
+		__u64: 40;
+	};
+};
+
+#define C_IXE_ERR_INFO_AMO_LENGTH_OFFSET 0x00000280
+#define C_IXE_ERR_INFO_AMO_LENGTH (C_IXE_BASE + C_IXE_ERR_INFO_AMO_LENGTH_OFFSET)
+#define C_IXE_ERR_INFO_AMO_LENGTH_SIZE 0x00000010
+
+union c_ixe_err_info_amo_length {
+	__u64 qw[2];
+	struct {
+		__u64 addr_56_0 : 57;
+		__u64: 7;
+		__u64 acid : 10;
+		__u64: 2;
+		__u64 atomic_type : 4;
+		__u64 cmd_length : 13;
+		__u64: 35;
+	};
+};
+
+#define C_IXE_CFG_DSCP_WRQ_MAP_OFFSET(idx) (0x00000400 + ((idx) * 8))
+#define C_IXE_CFG_DSCP_WRQ_MAP_ENTRIES 64
+#define C_IXE_CFG_DSCP_WRQ_MAP(idx) (C_IXE_BASE + C_IXE_CFG_DSCP_WRQ_MAP_OFFSET(idx))
+#define C_IXE_CFG_DSCP_WRQ_MAP_SIZE 0x00000200
+
+union c_ixe_cfg_dscp_wrq_map {
+	__u64 qw;
+	struct {
+		__u64 mask0 : 22;
+		__u64: 2;
+		__u64 mask1 : 22;
+		__u64: 2;
+		__u64 hash_mask : 2;
+		__u64: 6;
+		__u64 base : 5;
+		__u64: 3;
+	};
+};
+
+#define C_IXE_CFG_DSCP_DSCP_TC_MAP_OFFSET(idx) (0x00000600 + ((idx) * 8))
+#define C_IXE_CFG_DSCP_DSCP_TC_MAP_ENTRIES 16
+#define C_IXE_CFG_DSCP_DSCP_TC_MAP(idx) (C_IXE_BASE + C_IXE_CFG_DSCP_DSCP_TC_MAP_OFFSET(idx))
+#define C_IXE_CFG_DSCP_DSCP_TC_MAP_SIZE 0x00000080
+
+struct c_dscp_map {
+	__u8 dscp : 6;
+	__u8: 2;
+	__u8 tc : 3;
+	__u8: 5;
+};
+
+#define C_IXE_CFG_DSCP_DSCP_TC_MAP_ARRAY_SIZE 4
+union c_ixe_cfg_dscp_dscp_tc_map {
+	__u64 qw;
+	struct c_dscp_map map[C_IXE_CFG_DSCP_DSCP_TC_MAP_ARRAY_SIZE];
+};
+
+#define C_IXE_CFG_TC_FQ_MAP_OFFSET(idx) (0x00000700 + ((idx) * 8))
+#define C_IXE_CFG_TC_FQ_MAP_ENTRIES 8
+#define C_IXE_CFG_TC_FQ_MAP(idx) (C_IXE_BASE + C_IXE_CFG_TC_FQ_MAP_OFFSET(idx))
+#define C_IXE_CFG_TC_FQ_MAP_SIZE 0x00000040
+
+union c_ixe_cfg_tc_fq_map {
+	__u64 qw;
+	struct {
+		__u64 put_resp_mask : 24;
+		__u64: 8;
+		__u64 get_req_mask : 24;
+		__u64: 8;
+	};
+};
+
+#define C_IXE_CFG_MP_TC_FQ_MAP_OFFSET(idx) (0x00000740 + ((idx) * 8))
+#define C_IXE_CFG_MP_TC_FQ_MAP_ENTRIES 8
+#define C_IXE_CFG_MP_TC_FQ_MAP(idx) (C_IXE_BASE + C_IXE_CFG_MP_TC_FQ_MAP_OFFSET(idx))
+#define C_IXE_CFG_MP_TC_FQ_MAP_SIZE 0x00000040
+
+union c_ixe_cfg_mp_tc_fq_map {
+	__u64 qw;
+	struct {
+		__u64 num_fqs_mask : 2;
+		__u64: 14;
+		__u64 base : 5;
+		__u64: 43;
+	};
+};
+
+#define C_IXE_CFG_DISP_CDT_LIM_OFFSET 0x00000788
+#define C_IXE_CFG_DISP_CDT_LIM (C_IXE_BASE + C_IXE_CFG_DISP_CDT_LIM_OFFSET)
+#define C_IXE_CFG_DISP_CDT_LIM_SIZE 0x00000008
+
+union c_ixe_cfg_disp_cdt_lim {
+	__u64 qw;
+	struct {
+		__u64 mst_match_cdts : 6;
+		__u64: 2;
+		__u64 wrq_ff_cdts : 2;
+		__u64: 2;
+		__u64 atu_req_cdts : 3;
+		__u64: 1;
+		__u64 rpu_err_cdts : 3;
+		__u64: 1;
+		__u64 rpu_resp_cdts : 3;
+		__u64: 1;
+		__u64 pct_gcomp_cdts : 6;
+		__u64: 2;
+		__u64 put_resp_cdts : 10;
+		__u64: 6;
+		__u64 put_atu_cdts : 9;
+		__u64 ee_cdts : 5;
+		__u64: 2;
+	};
+};
+
+#define C_IXE_CFG_AMO_OFFLOAD_EN_OFFSET 0x00000800
+#define C_IXE_CFG_AMO_OFFLOAD_EN (C_IXE_BASE + C_IXE_CFG_AMO_OFFLOAD_EN_OFFSET)
+#define C_IXE_CFG_AMO_OFFLOAD_EN_SIZE 0x00000008
+
+union c_ixe_cfg_amo_offload_en {
+	__u64 qw;
+	struct {
+		__u64 op_min : 4;
+		__u64 op_max : 4;
+		__u64 op_sum : 4;
+		__u64 op_lor : 4;
+		__u64 op_land : 4;
+		__u64 op_bor : 4;
+		__u64 op_band : 4;
+		__u64 op_lxor : 4;
+		__u64 op_bxor : 4;
+		__u64 op_swap : 4;
+		__u64 op_cswap_eq : 3;
+		__u64: 1;
+		__u64 op_cswap_ne : 2;
+		__u64 op_cswap_le : 2;
+		__u64 op_cswap_lt : 2;
+		__u64 op_cswap_ge : 2;
+		__u64 op_cswap_gt : 2;
+		__u64 op_axor : 2;
+		__u64: 8;
+	};
+};
+
+#define C_IXE_CFG_AMO_OFFLOAD_CODE_1OP_OFFSET 0x00000808
+#define C_IXE_CFG_AMO_OFFLOAD_CODE_1OP (C_IXE_BASE + C_IXE_CFG_AMO_OFFLOAD_CODE_1OP_OFFSET)
+#define C_IXE_CFG_AMO_OFFLOAD_CODE_1OP_SIZE 0x00000008
+
+union c_ixe_cfg_amo_offload_code_1op {
+	__u64 qw;
+	struct {
+		__u64 op_min_code : 4;
+		__u64 op_max_code : 4;
+		__u64 op_sum_code : 4;
+		__u64 op_lor_code : 4;
+		__u64 op_land_code : 4;
+		__u64 op_bor_code : 4;
+		__u64 op_band_code : 4;
+		__u64 op_lxor_code : 4;
+		__u64 op_bxor_code : 4;
+		__u64 op_swap_code : 4;
+		__u64: 24;
+	};
+};
+
+#define C_IXE_CFG_AMO_OFFLOAD_OFFSET 0x00000818
+#define C_IXE_CFG_AMO_OFFLOAD (C_IXE_BASE + C_IXE_CFG_AMO_OFFLOAD_OFFSET)
+#define C_IXE_CFG_AMO_OFFLOAD_SIZE 0x00000008
+
+union c_ixe_cfg_amo_offload {
+	__u64 qw;
+	struct {
+		__u64 base_amo_req : 1;
+		__u64 force_native_swap : 1;
+		__u64 force_native_fetchadd : 1;
+		__u64: 13;
+		__u64 first_dw_be_32bit : 4;
+		__u64 last_dw_be_32bit : 4;
+		__u64 first_dw_be_64bit : 4;
+		__u64 last_dw_be_64bit : 4;
+		__u64: 32;
+	};
+};
+
+#define C_IXE_CFG_PARSER_OFFSET 0x00000908
+#define C_IXE_CFG_PARSER (C_IXE_BASE + C_IXE_CFG_PARSER_OFFSET)
+#define C_IXE_CFG_PARSER_SIZE 0x00000008
+
+union c_ixe_cfg_parser {
+	__u64 qw;
+	struct {
+		__u64 ipv4_flowlab_type : 8;
+		__u64 ipv6_frag_type : 8;
+		__u64 udp_type : 8;
+		__u64 tcp_type : 8;
+		__u64 eth_segment : 5;
+		__u64: 3;
+		__u64 rpu_wrdisp_cdt : 4;
+		__u64: 20;
+	};
+};
+
+#define C_IXE_CFG_ROCE_OFFSET 0x00000910
+#define C_IXE_CFG_ROCE (C_IXE_BASE + C_IXE_CFG_ROCE_OFFSET)
+#define C_IXE_CFG_ROCE_SIZE 0x00000008
+
+union c_ixe_cfg_roce {
+	__u64 qw;
+	struct {
+		__u64 udp_dstport_bth : 16;
+		__u64 enable_1k : 1;
+		__u64 enable_2k : 1;
+		__u64 enable_4k : 1;
+		__u64: 45;
+	};
+};
+
+#define C_IXE_CFG_HRP_OFFSET 0x00000918
+#define C_IXE_CFG_HRP (C_IXE_BASE + C_IXE_CFG_HRP_OFFSET)
+#define C_IXE_CFG_HRP_SIZE 0x00000008
+
+union c_ixe_cfg_hrp {
+	__u64 qw;
+	struct {
+		__u64 hrp_enable;
+	};
+};
+
+#define C_IXE_CFG_DFA_OFFSET 0x00000920
+#define C_IXE_CFG_DFA (C_IXE_BASE + C_IXE_CFG_DFA_OFFSET)
+#define C_IXE_CFG_DFA_SIZE 0x00000008
+
+union c_ixe_cfg_dfa {
+	__u64 qw;
+	struct {
+		__u64: 12;
+		__u64 dfa_nid : 20;
+		__u64 dfa_chk_en : 8;
+		__u64: 24;
+	};
+};
+
+#define C_IXE_CFG_DISCARD_OFFSET 0x00000928
+#define C_IXE_CFG_DISCARD (C_IXE_BASE + C_IXE_CFG_DISCARD_OFFSET)
+#define C_IXE_CFG_DISCARD_SIZE 0x00000008
+
+union c_ixe_cfg_discard {
+	__u64 qw;
+	struct {
+		__u64 v4_pkt_type_mask : 8;
+		__u64 v4_pkt_type_match : 8;
+		__u64 vs_pkt_type_mask : 8;
+		__u64 vs_pkt_type_match : 8;
+		__u64 armed : 8;
+		__u64: 24;
+	};
+};
+
+#define C_IXE_CFG_IPV6_OPT_ABORT_OFFSET(idx) (0x00000960 + ((idx) * 8))
+#define C_IXE_CFG_IPV6_OPT_ABORT_ENTRIES 4
+#define C_IXE_CFG_IPV6_OPT_ABORT(idx) (C_IXE_BASE + C_IXE_CFG_IPV6_OPT_ABORT_OFFSET(idx))
+#define C_IXE_CFG_IPV6_OPT_ABORT_SIZE 0x00000020
+
+union c_ixe_cfg_ipv6_opt_abort {
+	__u64 qw;
+	struct {
+		__u64 abort;
+	};
+};
+
+#define C_IXE_CFG_BTH_OPCODE_OFFSET(idx) (0x00000980 + ((idx) * 8))
+#define C_IXE_CFG_BTH_OPCODE_ENTRIES 16
+#define C_IXE_CFG_BTH_OPCODE(idx) (C_IXE_BASE + C_IXE_CFG_BTH_OPCODE_OFFSET(idx))
+#define C_IXE_CFG_BTH_OPCODE_SIZE 0x00000080
+
+union c_ixe_cfg_bth_opcode {
+	__u64 qw;
+	struct {
+		__u64 len_0 : 4;
+		__u64 len_1 : 4;
+		__u64 len_2 : 4;
+		__u64 len_3 : 4;
+		__u64 len_4 : 4;
+		__u64 len_5 : 4;
+		__u64 len_6 : 4;
+		__u64 len_7 : 4;
+		__u64 len_8 : 4;
+		__u64 len_9 : 4;
+		__u64 len_10 : 4;
+		__u64 len_11 : 4;
+		__u64 len_12 : 4;
+		__u64 len_13 : 4;
+		__u64 len_14 : 4;
+		__u64 len_15 : 4;
+	};
+};
+
+#define C_IXE_STS_PARSER_DECODE_OFFSET 0x00000c40
+#define C_IXE_STS_PARSER_DECODE (C_IXE_BASE + C_IXE_STS_PARSER_DECODE_OFFSET)
+#define C_IXE_STS_PARSER_DECODE_SIZE 0x00000008
+
+union c_ixe_sts_parser_decode {
+	__u64 qw;
+	struct {
+		__u64 flit_fifo_depth : 6;
+		__u64: 2;
+		__u64 pkt_fifo_depth : 6;
+		__u64: 2;
+		__u64 pct_req_fifo_depth : 6;
+		__u64: 2;
+		__u64 pct_rsp_fifo_depth : 6;
+		__u64: 2;
+		__u64 rmu_fifo_depth : 6;
+		__u64: 26;
+	};
+};
+
+#define C_LPE_CFG_CRNC_OFFSET 0x00000000
+#define C_LPE_CFG_CRNC (C_LPE_BASE + C_LPE_CFG_CRNC_OFFSET)
+#define C_LPE_CFG_CRNC_SIZE 0x00000008
+
+union c_lpe_cfg_crnc {
+	__u64 qw;
+	struct {
+		__u64 csr_timeout : 8;
+		__u64 mcast_id : 10;
+		__u64: 1;
+		__u64 mcast_enable : 1;
+		__u64 mcast_mask : 10;
+		__u64: 34;
+	};
+};
+
+#define C_LPE_MSC_SHADOW_ACTION_OFFSET 0x00000038
+#define C_LPE_MSC_SHADOW_ACTION (C_LPE_BASE + C_LPE_MSC_SHADOW_ACTION_OFFSET)
+#define C_LPE_MSC_SHADOW_ACTION_SIZE 0x00000008
+#define C_LPE_MSC_SHADOW_OFFSET 0x00000040
+#define C_LPE_MSC_SHADOW (C_LPE_BASE + C_LPE_MSC_SHADOW_OFFSET)
+#define C_LPE_MSC_SHADOW_SIZE 0x00000040
+
+union c_lpe_msc_shadow {
+	__u64 qw[8];
+};
+
+#define C_LPE_ERR_ELAPSED_TIME_OFFSET 0x00000100
+#define C_LPE_ERR_ELAPSED_TIME (C_LPE_BASE + C_LPE_ERR_ELAPSED_TIME_OFFSET)
+#define C_LPE_ERR_ELAPSED_TIME_SIZE 0x00000008
+
+union c_lpe_err_elapsed_time {
+	__u64 qw;
+	struct {
+		__u64 nanoseconds : 30;
+		__u64 seconds : 34;
+	};
+};
+
+#define C_LPE_ERR_FLG_OFFSET 0x00000108
+#define C_LPE_ERR_FLG (C_LPE_BASE + C_LPE_ERR_FLG_OFFSET)
+#define C_LPE_ERR_FLG_SIZE 0x00000008
+
+union c_lpe_err_flg {
+	__u64 qw;
+	struct {
+		__u64 sw_diag : 1;
+		__u64 crnc_ring_sync_error : 1;
+		__u64 crnc_ring_ecc_sbe : 1;
+		__u64 crnc_ring_ecc_mbe : 1;
+		__u64 crnc_ring_cmd_unknown : 1;
+		__u64 crnc_csr_cmd_unknown : 1;
+		__u64 crnc_csr_cmd_incomplete : 1;
+		__u64 crnc_buf_ecc_sbe : 1;
+		__u64 crnc_buf_ecc_mbe : 1;
+		__u64 event_cnt_ovf : 1;
+		__u64 le_oversubscribed : 1;
+		__u64: 1;
+		__u64 illegal_op : 1;
+		__u64 src_error : 1;
+		__u64 delayed : 1;
+		__u64 restricted_unicast : 1;
+		__u64 no_space : 1;
+		__u64 invalid_endpoint : 1;
+		__u64 entry_not_found : 1;
+		__u64 op_violation : 1;
+		__u64 eq_disabled : 1;
+		__u64 pt_disabled_fc : 1;
+		__u64 pt_disabled_dis : 1;
+		__u64 pt_disabled_rst : 1;
+		__u64 illegal_cq_op : 1;
+		__u64 fifo_err : 1;
+		__u64 cq_fifo_overrun : 1;
+		__u64 cdt_cnt_uflow : 1;
+		__u64 mrr_mem_cor : 1;
+		__u64 free_list_mem_cor : 1;
+		__u64 event_ram_cor : 1;
+		__u64 plec_mem_cor : 1;
+		__u64 ptlte_mem_cor : 1;
+		__u64 ixemrq_front_mem_cor : 1;
+		__u64 ixemrq_back_mem_cor : 1;
+		__u64 ixemrq_list_mem_cor : 1;
+		__u64 petcq_list_mem_cor : 1;
+		__u64 list_entry_mem_cor : 1;
+		__u64 cqmrq_front_mem_cor : 1;
+		__u64 cqmrq_back_mem_cor : 1;
+		__u64 cqmrq_list_mem_cor : 1;
+		__u64 rget_ram_mem_cor : 1;
+		__u64 rrq_fifo_cor : 1;
+		__u64 cq_fifo_cor : 1;
+		__u64: 1;
+		__u64 rdy_pleq_cor : 1;
+		__u64 mrr_mem_ucor : 1;
+		__u64 free_list_mem_ucor : 1;
+		__u64 event_ram_ucor : 1;
+		__u64 plec_mem_ucor : 1;
+		__u64 ptlte_mem_ucor : 1;
+		__u64 ixemrq_front_mem_ucor : 1;
+		__u64 ixemrq_back_mem_ucor : 1;
+		__u64 ixemrq_list_mem_ucor : 1;
+		__u64 petcq_list_mem_ucor : 1;
+		__u64 list_entry_mem_ucor : 1;
+		__u64 cqmrq_front_mem_ucor : 1;
+		__u64 cqmrq_back_mem_ucor : 1;
+		__u64 cqmrq_list_mem_ucor : 1;
+		__u64 rget_ram_mem_ucor : 1;
+		__u64 rrq_fifo_ucor : 1;
+		__u64 cq_fifo_ucor : 1;
+		__u64: 1;
+		__u64 rdy_pleq_ucor : 1;
+	};
+};
+
+#define C_LPE_ERR_FIRST_FLG_OFFSET 0x00000110
+#define C_LPE_ERR_FIRST_FLG (C_LPE_BASE + C_LPE_ERR_FIRST_FLG_OFFSET)
+#define C_LPE_ERR_FIRST_FLG_SIZE 0x00000008
+#define C_LPE_ERR_FIRST_FLG_TS_OFFSET 0x00000118
+#define C_LPE_ERR_FIRST_FLG_TS (C_LPE_BASE + C_LPE_ERR_FIRST_FLG_TS_OFFSET)
+#define C_LPE_ERR_FIRST_FLG_TS_SIZE 0x00000008
+#define C_LPE_ERR_CLR_OFFSET 0x00000120
+#define C_LPE_ERR_CLR (C_LPE_BASE + C_LPE_ERR_CLR_OFFSET)
+#define C_LPE_ERR_CLR_SIZE 0x00000008
+#define C_LPE_ERR_IRQA_MSK_OFFSET 0x00000128
+#define C_LPE_ERR_IRQA_MSK (C_LPE_BASE + C_LPE_ERR_IRQA_MSK_OFFSET)
+#define C_LPE_ERR_IRQA_MSK_SIZE 0x00000008
+#define C_LPE_ERR_IRQB_MSK_OFFSET 0x00000130
+#define C_LPE_ERR_IRQB_MSK (C_LPE_BASE + C_LPE_ERR_IRQB_MSK_OFFSET)
+#define C_LPE_ERR_IRQB_MSK_SIZE 0x00000008
+#define C_LPE_ERR_INFO_MSK_OFFSET 0x00000140
+#define C_LPE_ERR_INFO_MSK (C_LPE_BASE + C_LPE_ERR_INFO_MSK_OFFSET)
+#define C_LPE_ERR_INFO_MSK_SIZE 0x00000008
+#define C_LPE_ERR_INFO_MEM_OFFSET 0x00000180
+#define C_LPE_ERR_INFO_MEM (C_LPE_BASE + C_LPE_ERR_INFO_MEM_OFFSET)
+#define C_LPE_ERR_INFO_MEM_SIZE 0x00000008
+
+union c_lpe_err_info_mem {
+	__u64 qw;
+	struct {
+		__u64 cor_syndrome : 11;
+		__u64 cor_address : 14;
+		__u64 cor_mem_id : 5;
+		__u64: 1;
+		__u64 cor_csr_detected : 1;
+		__u64 ucor_syndrome : 11;
+		__u64 ucor_address : 14;
+		__u64 ucor_mem_id : 5;
+		__u64: 1;
+		__u64 ucor_csr_detected : 1;
+	};
+};
+
+#define C_LPE_ERR_INFO_CDT_CNT_UFLOW_OFFSET 0x00000188
+#define C_LPE_ERR_INFO_CDT_CNT_UFLOW (C_LPE_BASE + C_LPE_ERR_INFO_CDT_CNT_UFLOW_OFFSET)
+#define C_LPE_ERR_INFO_CDT_CNT_UFLOW_SIZE 0x00000008
+
+union c_lpe_err_info_cdt_cnt_uflow {
+	__u64 qw;
+	struct {
+		__u64 cdt_cnt_id : 4;
+		__u64: 60;
+	};
+};
+
+#define C_LPE_ERR_INFO_NET_HDR_OFFSET 0x00000190
+#define C_LPE_ERR_INFO_NET_HDR (C_LPE_BASE + C_LPE_ERR_INFO_NET_HDR_OFFSET)
+#define C_LPE_ERR_INFO_NET_HDR_SIZE 0x00000008
+
+union c_lpe_err_info_net_hdr {
+	__u64 qw;
+	struct {
+		__u64 initiator : 32;
+		__u64 ptlte_index : 11;
+		__u64 src_error : 1;
+		__u64 tc : 3;
+		__u64: 1;
+		__u64 opcode : 4;
+		__u64 net_hdr_err_id : 4;
+		__u64: 8;
+	};
+};
+
+#define C_LPE_CFG_FQ_TC_MAP_OFFSET 0x00000410
+#define C_LPE_CFG_FQ_TC_MAP (C_LPE_BASE + C_LPE_CFG_FQ_TC_MAP_OFFSET)
+#define C_LPE_CFG_FQ_TC_MAP_SIZE 0x00000008
+
+struct c_lpe_cfg_tc_fqs {
+	__u8 fq_base : 4;
+	__u8 fq_mask : 3;
+	__u8: 1;
+};
+
+union c_lpe_cfg_fq_tc_map {
+	__u64 qw;
+	struct c_lpe_cfg_tc_fqs tc[8];
+};
+
+#define C_LPE_CFG_CDT_LIMITS_OFFSET 0x00000418
+#define C_LPE_CFG_CDT_LIMITS (C_LPE_BASE + C_LPE_CFG_CDT_LIMITS_OFFSET)
+#define C_LPE_CFG_CDT_LIMITS_SIZE 0x00000008
+
+union c_lpe_cfg_cdt_limits {
+	__u64 qw;
+	struct {
+		__u64 ixemrq_wc_cdts : 4;
+		__u64 cqmrq_wc_cdts : 4;
+		__u64 rdy_ple_cdts : 4;
+		__u64 event_cdts : 5;
+		__u64: 3;
+		__u64 ixe_put_cdts : 4;
+		__u64 ixe_get_cdts : 4;
+		__u64 ixe_mst_cdts : 4;
+		__u64 rrq_cdts : 3;
+		__u64: 29;
+	};
+};
+
+#define C_LPE_CFG_GET_CTRL_OFFSET 0x00000428
+#define C_LPE_CFG_GET_CTRL (C_LPE_BASE + C_LPE_CFG_GET_CTRL_OFFSET)
+#define C_LPE_CFG_GET_CTRL_SIZE 0x00000008
+
+union c_lpe_cfg_get_ctrl {
+	__u64 qw;
+	struct {
+		__u64 get_index : 12;
+		__u64: 4;
+		__u64 get_index_ext : 5;
+		__u64 get_pid_shift : 3;
+		__u64 transaction_type : 4;
+		__u64: 3;
+		__u64 get_en : 1;
+		__u64 dfa_nid : 20;
+		__u64: 12;
+	};
+};
+
+#define C_LPE_CFG_INITIATOR_CTRL_OFFSET 0x00000430
+#define C_LPE_CFG_INITIATOR_CTRL (C_LPE_BASE + C_LPE_CFG_INITIATOR_CTRL_OFFSET)
+#define C_LPE_CFG_INITIATOR_CTRL_SIZE 0x00000008
+
+union c_lpe_cfg_initiator_ctrl {
+	__u64 qw;
+	struct {
+		__u64 pid_bits : 4;
+		__u64: 60;
+	};
+};
+
+#define C_LPE_CFG_ETHERNET_THRESHOLD_OFFSET 0x00000438
+#define C_LPE_CFG_ETHERNET_THRESHOLD (C_LPE_BASE + C_LPE_CFG_ETHERNET_THRESHOLD_OFFSET)
+#define C_LPE_CFG_ETHERNET_THRESHOLD_SIZE 0x00000008
+
+union c_lpe_cfg_ethernet_threshold {
+	__u64 qw;
+	struct {
+		__u64 threshold : 14;
+		__u64: 50;
+	};
+};
+
+#define C_LPE_CFG_MIN_FREE_SHFT_OFFSET 0x00000440
+#define C_LPE_CFG_MIN_FREE_SHFT (C_LPE_BASE + C_LPE_CFG_MIN_FREE_SHFT_OFFSET)
+#define C_LPE_CFG_MIN_FREE_SHFT_SIZE 0x00000008
+
+union c_lpe_cfg_min_free_shft {
+	__u64 qw;
+	struct {
+		__u64 min_free_shft : 4;
+		__u64: 60;
+	};
+};
+
+#define C_LPE_CFG_EVENT_CNTS_OFFSET 0x00000448
+#define C_LPE_CFG_EVENT_CNTS (C_LPE_BASE + C_LPE_CFG_EVENT_CNTS_OFFSET)
+#define C_LPE_CFG_EVENT_CNTS_SIZE 0x00000008
+
+union c_lpe_cfg_event_cnts {
+	__u64 qw;
+	struct {
+		__u64 enable : 1;
+		__u64 init : 1;
+		__u64 init_done : 1;
+		__u64: 1;
+		__u64 ovf_cnt : 16;
+		__u64: 44;
+	};
+};
+
+#define C_LPE_CFG_PE_LE_POOLS_OFFSET(idx) (0x00000480 + ((idx) * 8))
+#define C_LPE_CFG_PE_LE_POOLS_ENTRIES 64
+#define C_LPE_CFG_PE_LE_POOLS(idx) (C_LPE_BASE + C_LPE_CFG_PE_LE_POOLS_OFFSET(idx))
+#define C_LPE_CFG_PE_LE_POOLS_SIZE 0x00000200
+
+union c_lpe_cfg_pe_le_pools {
+	__u64 qw;
+	struct {
+		__u64 num_reserved : 15;
+		__u64: 17;
+		__u64 max_alloc : 15;
+		__u64: 17;
+	};
+};
+
+#define C_LPE_STS_PE_LE_ALLOC_OFFSET(idx) (0x00000800 + ((idx) * 8))
+#define C_LPE_STS_PE_LE_ALLOC_ENTRIES 64
+#define C_LPE_STS_PE_LE_ALLOC(idx) (C_LPE_BASE + C_LPE_STS_PE_LE_ALLOC_OFFSET(idx))
+#define C_LPE_STS_PE_LE_ALLOC_SIZE 0x00000200
+
+union c_lpe_sts_pe_le_alloc {
+	__u64 qw;
+	struct {
+		__u64 num_allocated : 15;
+		__u64: 49;
+	};
+};
+
+#define C_LPE_CFG_PE_LE_SHARED_OFFSET(idx) (0x00000a00 + ((idx) * 8))
+#define C_LPE_CFG_PE_LE_SHARED_ENTRIES 4
+#define C_LPE_CFG_PE_LE_SHARED(idx) (C_LPE_BASE + C_LPE_CFG_PE_LE_SHARED_OFFSET(idx))
+#define C_LPE_CFG_PE_LE_SHARED_SIZE 0x00000020
+
+union c_lpe_cfg_pe_le_shared {
+	__u64 qw;
+	struct {
+		__u64 num_shared_allocated : 15;
+		__u64: 1;
+		__u64 num_total_allocated : 15;
+		__u64: 1;
+		__u64 num_shared : 15;
+		__u64: 1;
+		__u64 num_total : 15;
+		__u64: 1;
+	};
+};
+
+#define C_LPE_STS_INIT_DONE_OFFSET 0x00000a28
+#define C_LPE_STS_INIT_DONE (C_LPE_BASE + C_LPE_STS_INIT_DONE_OFFSET)
+#define C_LPE_STS_INIT_DONE_SIZE 0x00000008
+
+union c_lpe_sts_init_done {
+	__u64 qw;
+	struct {
+		__u64 ptlte_init_done : 1;
+		__u64 free_mask_init_done : 4;
+		__u64: 59;
+	};
+};
+
+#define C_LPE_STS_CDTS_IN_USE_OFFSET 0x00000a30
+#define C_LPE_STS_CDTS_IN_USE (C_LPE_BASE + C_LPE_STS_CDTS_IN_USE_OFFSET)
+#define C_LPE_STS_CDTS_IN_USE_SIZE 0x00000008
+
+union c_lpe_sts_cdts_in_use {
+	__u64 qw;
+	struct {
+		__u64 ixemrq_wc_cdts_in_use : 4;
+		__u64 cqmrq_wc_cdts_in_use : 4;
+		__u64 rdy_ple_cdts_in_use : 4;
+		__u64 event_cdts_in_use : 5;
+		__u64: 3;
+		__u64 ixe_put_cdts_in_use : 4;
+		__u64 ixe_get_cdts_in_use : 4;
+		__u64 ixe_mst_cdts_in_use : 4;
+		__u64 pe0_rrq_cdts_in_use : 3;
+		__u64: 1;
+		__u64 pe1_rrq_cdts_in_use : 3;
+		__u64: 1;
+		__u64 pe2_rrq_cdts_in_use : 3;
+		__u64: 1;
+		__u64 pe3_rrq_cdts_in_use : 3;
+		__u64: 17;
+	};
+};
+
+#define C_LPE_MSC_LE_POOL_FREE_OFFSET(idx) (0x00000a40 + ((idx) * 8))
+#define C_LPE_MSC_LE_POOL_FREE_ENTRIES 4
+#define C_LPE_MSC_LE_POOL_FREE(idx) (C_LPE_BASE + C_LPE_MSC_LE_POOL_FREE_OFFSET(idx))
+#define C_LPE_MSC_LE_POOL_FREE_SIZE 0x00000020
+
+union c_lpe_msc_le_pool_free {
+	__u64 qw;
+	struct {
+		__u64 le_pool : 4;
+		__u64 free_en : 1;
+		__u64: 59;
+	};
+};
+
+#define C_LPE_MSC_LOAD_STATS_DOORBELL_OFFSET 0x00000a60
+#define C_LPE_MSC_LOAD_STATS_DOORBELL (C_LPE_BASE + C_LPE_MSC_LOAD_STATS_DOORBELL_OFFSET)
+#define C_LPE_MSC_LOAD_STATS_DOORBELL_SIZE 0x00000008
+
+union c_lpe_msc_load_stats_doorbell {
+	__u64 qw;
+	struct {
+		__u64 doorbell : 1;
+		__u64: 63;
+	};
+};
+
+#define C_LPE_STS_PE_FREE_MASK_OFFSET(idx) (0x00001000 + ((idx) * 8))
+#define C_LPE_STS_PE_FREE_MASK_ENTRIES 1024
+#define C_LPE_STS_PE_FREE_MASK(idx) (C_LPE_BASE + C_LPE_STS_PE_FREE_MASK_OFFSET(idx))
+#define C_LPE_STS_PE_FREE_MASK_SIZE 0x00002000
+
+union c_lpe_sts_pe_free_mask {
+	__u64 qw;
+	struct {
+		__u64 free_mask;
+	};
+};
+
+#define C_LPE_STS_LOAD_STATS_OFFSET(idx) (0x00003000 + ((idx) * 8))
+#define C_LPE_STS_LOAD_STATS_ENTRIES 4
+#define C_LPE_STS_LOAD_STATS(idx) (C_LPE_BASE + C_LPE_STS_LOAD_STATS_OFFSET(idx))
+#define C_LPE_STS_LOAD_STATS_SIZE 0x00000020
+
+union c_lpe_sts_load_stats {
+	__u64 qw;
+	struct {
+		__u64 load : 48;
+		__u64: 12;
+		__u64 max : 4;
+	};
+};
+
+#define C_LPE_CFG_PTL_TABLE_OFFSET(idx) (0x00010000 + ((idx) * 32))
+#define C_LPE_CFG_PTL_TABLE_ENTRIES 2048
+#define C_LPE_CFG_PTL_TABLE(idx) (C_LPE_BASE + C_LPE_CFG_PTL_TABLE_OFFSET(idx))
+#define C_LPE_CFG_PTL_TABLE_SIZE 0x00010000
+
+struct c_lpe_cfg_ptl_table_ptrs {
+	__u32 tail : 14;
+	__u32: 2;
+	__u32 head : 14;
+	__u32 append_disabled : 1; /* not for unexpected */
+	__u32 list_vld : 1;
+};
+
+union c_lpe_cfg_ptl_table {
+	__u64 qw[4];
+	struct {
+		__u64 clr_remote_offset : 1;
+		__u64 en_flowctrl : 1;
+		__u64 use_long_event : 1;
+		__u64 lossless : 1;
+		__u64 en_event_match : 1;
+		__u64: 11;
+		__u64 eq_handle : 11;
+		__u64: 5;
+		__u64 eq_handle_no_rget : 11;
+		__u64: 5;
+		__u64 le_pool : 4;
+		__u64 en_restricted_unicast_lm : 1;
+		__u64 use_logical : 1;
+		__u64 is_matching : 1;
+		__u64 do_space_check : 1;
+		__u64 cntr_pool : 2;
+		__u64 pe_num : 2;
+		__u64 en_align_lm : 1;
+		__u64 en_match_on_vni : 1; /* Cassini 2 only */
+		__u64: 1;
+		__u64 en_sw_hw_st_chng : 1;
+		struct c_lpe_cfg_ptl_table_ptrs l[4];
+		__u64 ptl_state : 3;
+		__u64: 29;
+		__u64 drop_count : 24;
+		__u64 signal_invalid : 1;
+		__u64 signal_underflow : 1;
+		__u64 signal_overflow : 1;
+		__u64 signal_inexact : 1;
+		__u64: 4;
+	};
+};
+
+#define C_LPE_DBG_MRR_OFFSET(idx) (0x00040000 + ((idx) * 64))
+#define C_LPE_DBG_MRR_ENTRIES 2560
+#define C_LPE_DBG_MRR(idx) (C_LPE_BASE + C_LPE_DBG_MRR_OFFSET(idx))
+#define C_LPE_DBG_MRR_SIZE 0x00028000
+
+union c_lpe_dbg_mrr {
+	__u64 qw[7];
+};
+
+#define C_LPE_DBG_RGET_RAM_OFFSET(idx) (0x00068000 + ((idx) * 64))
+#define C_LPE_DBG_RGET_RAM_ENTRIES 256
+#define C_LPE_DBG_RGET_RAM(idx) (C_LPE_BASE + C_LPE_DBG_RGET_RAM_OFFSET(idx))
+#define C_LPE_DBG_RGET_RAM_SIZE 0x00004000
+
+union c_lpe_dbg_rget_ram {
+	__u64 qw[7];
+	struct {
+		__u64 vni : 16;
+		__u64 buffer_id : 16;
+		__u64 eq : 11;
+		__u64 ct : 11;
+		__u64 ac : 10;
+		__u64 ptlte_index : 11;
+		__u64: 1;
+		__u64 sfa_nid : 20;
+		__u64 eager_len : 20;
+		__u64: 4;
+		__u64 rendezvous_id : 8;
+		__u64 hdr_data;
+		__u64 addr : 57;
+		__u64: 7;
+		__u64 remote_offset : 56;
+		__u64 event_ct_reply : 1;
+		__u64 event_ct_bytes : 1;
+		__u64 dscp : 6;
+		__u64 request_len : 32;
+		__u64: 23;
+		__u64 initiator_pid : 9;
+		__u64 cmdq_id : 9;
+		__u64: 39;
+		__u64 match_bits_up : 16;
+	};
+};
+
+#define C_LPE_STS_EVENT_CNTS_OFFSET(idx) (0x00070000 + ((idx) * 8))
+#ifndef C_LPE_STS_EVENT_CNTS_ENTRIES
+#define C_LPE_STS_EVENT_CNTS_ENTRIES 512
+#endif
+#define C_LPE_STS_EVENT_CNTS(idx) (C_LPE_BASE + C_LPE_STS_EVENT_CNTS_OFFSET(idx))
+#define C_LPE_STS_EVENT_CNTS_SIZE 0x00001000
+
+union c_lpe_sts_event_cnts {
+	__u64 qw;
+	struct {
+		__u64 cnt : 56;
+		__u64: 8;
+	};
+};
+
+#define C_LPE_STS_LIST_ENTRIES_OFFSET(idx) (0x00400000 + ((idx) * 64))
+#define C_LPE_STS_LIST_ENTRIES_ENTRIES 65536
+#define C_LPE_STS_LIST_ENTRIES(idx) (C_LPE_BASE + C_LPE_STS_LIST_ENTRIES_OFFSET(idx))
+#define C_LPE_STS_LIST_ENTRIES_SIZE 0x00400000
+
+union c_lpe_sts_list_entries {
+	__u64 qw[6];
+};
+
+#define C_MB_CFG_CRNC_OFFSET 0x00000000
+#define C_MB_CFG_CRNC (C_MB_BASE + C_MB_CFG_CRNC_OFFSET)
+#define C_MB_CFG_CRNC_SIZE 0x00000008
+
+union c_mb_cfg_crnc {
+	__u64 qw;
+	struct {
+		__u64 csr_timeout : 8;
+		__u64 mcast_id : 10;
+		__u64: 1;
+		__u64 mcast_enable : 1;
+		__u64 mcast_mask : 10;
+		__u64: 34;
+	};
+};
+
+#define C_MB_CFG_RT_OFFSET_OFFSET 0x00000020
+#define C_MB_CFG_RT_OFFSET (C_MB_BASE + C_MB_CFG_RT_OFFSET_OFFSET)
+#define C_MB_CFG_RT_OFFSET_SIZE 0x00000008
+
+union c_mb_cfg_rt_offset {
+	__u64 qw;
+	struct {
+		__u64 seconds : 48;
+		__u64: 16;
+	};
+};
+
+#define C_MB_MSC_SHADOW_ACTION_OFFSET 0x00000038
+#define C_MB_MSC_SHADOW_ACTION (C_MB_BASE + C_MB_MSC_SHADOW_ACTION_OFFSET)
+#define C_MB_MSC_SHADOW_ACTION_SIZE 0x00000008
+
+union c_any_msc_shadow_action {
+	__u64 qw;
+	struct {
+		__u64 addr_offset : 23;
+		__u64: 8;
+		__u64 write : 1;
+		__u64: 32;
+	};
+};
+
+#define C_MB_MSC_SHADOW_OFFSET 0x00000040
+#define C_MB_MSC_SHADOW (C_MB_BASE + C_MB_MSC_SHADOW_OFFSET)
+#define C_MB_MSC_SHADOW_SIZE 0x00000028
+
+union c_mb_msc_shadow {
+	__u64 qw[5];
+};
+
+#define C_MB_ERR_ELAPSED_TIME_OFFSET 0x00000100
+#define C_MB_ERR_ELAPSED_TIME (C_MB_BASE + C_MB_ERR_ELAPSED_TIME_OFFSET)
+#define C_MB_ERR_ELAPSED_TIME_SIZE 0x00000008
+
+union c_mb_err_elapsed_time {
+	__u64 qw;
+	struct {
+		__u64 nanoseconds : 30;
+		__u64 seconds : 34;
+	};
+};
+
+#define C_MB_ERR_FLG_OFFSET 0x00000108
+#define C_MB_ERR_FLG (C_MB_BASE + C_MB_ERR_FLG_OFFSET)
+#define C_MB_ERR_FLG_SIZE 0x00000008
+
+union c_mb_err_flg {
+	__u64 qw;
+	struct {
+		__u64 sw_diag : 1;
+		__u64 crnc_ring_sync_error : 1;
+		__u64 crnc_ring_ecc_sbe : 1;
+		__u64 crnc_ring_ecc_mbe : 1;
+		__u64 crnc_ring_cmd_unknown : 1;
+		__u64 crnc_csr_cmd_unknown : 1;
+		__u64 crnc_csr_cmd_incomplete : 1;
+		__u64 crnc_buf_ecc_sbe : 1;
+		__u64 crnc_buf_ecc_mbe : 1;
+		__u64: 7;
+		__u64 crmc_ring_sync_error : 1;
+		__u64 crmc_ring_ecc_sbe : 1;
+		__u64 crmc_ring_ecc_mbe : 1;
+		__u64 crmc_ring_cmd_unknown : 1;
+		__u64 crmc_wr_error : 1;
+		__u64 crmc_wr_addr_invalid : 1;
+		__u64 crmc_wr_cmd_invalid : 1;
+		__u64 crmc_wr_be_invalid : 1;
+		__u64 crmc_wr_cor_error : 1;
+		__u64 crmc_wr_uncor_error : 1;
+		__u64 crmc_wr_burst_error : 1;
+		__u64 crmc_wr_mcast_nack : 1;
+		__u64 crmc_wr_rsvd_error : 1;
+		__u64 crmc_wr_wrapped : 1;
+		__u64 crmc_wr_timeout : 1;
+		__u64 crmc_wr_axi_req_error : 1;
+		__u64 crmc_wr_axi_ring_error : 1;
+		__u64 crmc_wr_axi_wstrb_error : 1;
+		__u64 crmc_wr_axi_parity_error : 1;
+		__u64 crmc_rd_error : 1;
+		__u64 crmc_rd_addr_invalid : 1;
+		__u64 crmc_rd_cmd_invalid : 1;
+		__u64 crmc_rd_be_invalid : 1;
+		__u64 crmc_rd_cor_error : 1;
+		__u64 crmc_rd_uncor_error : 1;
+		__u64 crmc_rd_burst_error : 1;
+		__u64 crmc_rd_mcast_nack : 1;
+		__u64 crmc_rd_rsvd_error : 1;
+		__u64 crmc_rd_wrapped : 1;
+		__u64 crmc_rd_timeout : 1;
+		__u64 crmc_rd_axi_req_error : 1;
+		__u64 crmc_rd_axi_ring_error : 1;
+		__u64 cmc_wr_error : 4;
+		__u64 cmc_rd_error : 4;
+		__u64 event_cnt_ovf : 1;
+		__u64 event_ram_cor : 1;
+		__u64 event_ram_ucor : 1;
+		__u64 flash_cache0_cor : 1;
+		__u64 flash_cache0_ucor : 1;
+		__u64 flash_cache1_cor : 1;
+		__u64 flash_cache1_ucor : 1;
+		__u64 spi_ecc_error : 1;
+	};
+};
+
+#define C_MB_ERR_FIRST_FLG_OFFSET 0x00000110
+#define C_MB_ERR_FIRST_FLG (C_MB_BASE + C_MB_ERR_FIRST_FLG_OFFSET)
+#define C_MB_ERR_FIRST_FLG_SIZE 0x00000008
+
+union c_any_err_first_flg {
+	__u64 qw;
+	struct {
+		__u64 err_first_flg;
+	};
+};
+
+#define C_MB_ERR_FIRST_FLG_TS_OFFSET 0x00000118
+#define C_MB_ERR_FIRST_FLG_TS (C_MB_BASE + C_MB_ERR_FIRST_FLG_TS_OFFSET)
+#define C_MB_ERR_FIRST_FLG_TS_SIZE 0x00000008
+
+union c_any_err_first_flg_ts {
+	__u64 qw;
+	struct {
+		__u64 nanoseconds : 30;
+		__u64 seconds : 34;
+	};
+};
+
+#define C_MB_ERR_CLR_OFFSET 0x00000120
+#define C_MB_ERR_CLR (C_MB_BASE + C_MB_ERR_CLR_OFFSET)
+#define C_MB_ERR_CLR_SIZE 0x00000008
+
+union c_any_err_clr {
+	__u64 qw;
+	struct {
+		__u64 err_clr;
+	};
+};
+
+#define C_MB_ERR_IRQA_MSK_OFFSET 0x00000128
+#define C_MB_ERR_IRQA_MSK (C_MB_BASE + C_MB_ERR_IRQA_MSK_OFFSET)
+#define C_MB_ERR_IRQA_MSK_SIZE 0x00000008
+
+union c_any_err_irqa_msk {
+	__u64 qw;
+	struct {
+		__u64 err_irq_msk;
+	};
+};
+
+#define C_MB_ERR_IRQB_MSK_OFFSET 0x00000130
+#define C_MB_ERR_IRQB_MSK (C_MB_BASE + C_MB_ERR_IRQB_MSK_OFFSET)
+#define C_MB_ERR_IRQB_MSK_SIZE 0x00000008
+
+union c_any_err_irqb_msk {
+	__u64 qw;
+	struct {
+		__u64 err_irq_msk;
+	};
+};
+
+#define C_MB_ERR_INFO_MSK_OFFSET 0x00000140
+#define C_MB_ERR_INFO_MSK (C_MB_BASE + C_MB_ERR_INFO_MSK_OFFSET)
+#define C_MB_ERR_INFO_MSK_SIZE 0x00000008
+
+union c_any_err_info_msk {
+	__u64 qw;
+	struct {
+		__u64 err_info_msk;
+	};
+};
+
+#define C_MB_ERR_INFO_MEM_OFFSET 0x00000150
+#define C_MB_ERR_INFO_MEM (C_MB_BASE + C_MB_ERR_INFO_MEM_OFFSET)
+#define C_MB_ERR_INFO_MEM_SIZE 0x00000008
+
+union c_mb_err_info_mem {
+	__u64 qw;
+	struct {
+		__u64 cor_syndrome : 9;
+		__u64: 3;
+		__u64 cor_address : 13;
+		__u64: 3;
+		__u64 cor_mem_id : 2;
+		__u64: 1;
+		__u64 cor_csr_detected : 1;
+		__u64 ucor_syndrome : 9;
+		__u64: 3;
+		__u64 ucor_address : 13;
+		__u64: 3;
+		__u64 ucor_mem_id : 2;
+		__u64: 1;
+		__u64 ucor_csr_detected : 1;
+	};
+};
+
+#define C_MB_ERR_INFO_CRMC_OFFSET 0x00000158
+#define C_MB_ERR_INFO_CRMC (C_MB_BASE + C_MB_ERR_INFO_CRMC_OFFSET)
+#define C_MB_ERR_INFO_CRMC_SIZE 0x00000008
+
+union c_mb_err_info_crmc {
+	__u64 qw;
+	struct {
+		__u64 ring_id : 10;
+		__u64: 2;
+		__u64 ring : 3;
+		__u64: 1;
+		__u64 crnc_ring_sts : 4;
+		__u64 crmc_ring_sts : 1;
+		__u64: 43;
+	};
+};
+
+#define C_MB_ERR_INFO_CMC_WR_OFFSET 0x00000160
+#define C_MB_ERR_INFO_CMC_WR (C_MB_BASE + C_MB_ERR_INFO_CMC_WR_OFFSET)
+#define C_MB_ERR_INFO_CMC_WR_SIZE 0x00000018
+
+union c_mb_err_info_cmc_wr {
+	__u64 qw[3];
+	struct {
+		__u64 mst_awaddr : 32;
+		__u64 mst_awuser : 32;
+		__u64 mst_wdata;
+		__u64 mst_wderr : 8;
+		__u64 mst_wstrb : 8;
+		__u64 mst_awid : 4;
+		__u64 mst_awregion : 4;
+		__u64 mst_awlen : 8;
+		__u64 mst_awsize : 3;
+		__u64 mst_awburst : 2;
+		__u64 mst_awmid : 4;
+		__u64 mst_awlock : 1;
+		__u64 mst_awqos : 4;
+		__u64 mst_awprot : 3;
+		__u64 mst_awcache : 4;
+		__u64 slv_bresp : 2;
+		__u64 slv_bid : 4;
+		__u64 cmc_port : 2;
+		__u64 ring : 3;
+	};
+};
+
+#define C_MB_ERR_INFO_CMC_RD_OFFSET 0x00000180
+#define C_MB_ERR_INFO_CMC_RD (C_MB_BASE + C_MB_ERR_INFO_CMC_RD_OFFSET)
+#define C_MB_ERR_INFO_CMC_RD_SIZE 0x00000018
+
+union c_mb_err_info_cmc_rd {
+	__u64 qw[3];
+	struct {
+		__u64 mst_araddr : 32;
+		__u64 mst_aruser : 32;
+		__u64 slv_rdata;
+		__u64 slv_rderr : 8;
+		__u64 slv_ruser : 8;
+		__u64 mst_arid : 4;
+		__u64 mst_arregion : 4;
+		__u64 mst_arlen : 8;
+		__u64 mst_arsize : 3;
+		__u64 mst_arburst : 2;
+		__u64 mst_armid : 4;
+		__u64 mst_arlock : 1;
+		__u64 mst_arqos : 4;
+		__u64 mst_arprot : 3;
+		__u64 mst_arcache : 4;
+		__u64 slv_rresp : 2;
+		__u64 slv_rid : 4;
+		__u64 cmc_port : 2;
+		__u64 ring : 3;
+	};
+};
+
+#define C_MB_ERR_INFO_SPI_OFFSET 0x000001a0
+#define C_MB_ERR_INFO_SPI (C_MB_BASE + C_MB_ERR_INFO_SPI_OFFSET)
+#define C_MB_ERR_INFO_SPI_SIZE 0x00000008
+
+union c_mb_err_info_spi {
+	__u64 qw;
+	struct {
+		__u64: 3;
+		__u64 address : 29;
+		__u64 status : 8;
+		__u64: 24;
+	};
+};
+
+#define C_MB_EXT_ERR_FLG_OFFSET 0x00000208
+#define C_MB_EXT_ERR_FLG (C_MB_BASE + C_MB_EXT_ERR_FLG_OFFSET)
+#define C_MB_EXT_ERR_FLG_SIZE 0x00000008
+
+union c_mb_ext_err_flg {
+	__u64 qw;
+	struct {
+		__u64 sw_diag : 1;
+		__u64 jai_axi_cadr_unexpected_cmd : 1;
+		__u64 jai_axi_cadr_unknown_cmd : 1;
+		__u64 jai_axi_wr_decerr : 1;
+		__u64 jai_axi_wr_slverr : 1;
+		__u64 jai_axi_rd_decerr : 1;
+		__u64 jai_axi_rd_slverr : 1;
+		__u64 jai_axi_rd_parity_error : 1;
+		__u64 flm_csr_init_p1_spi_err : 1;
+		__u64 flm_csr_init_p2_spi_err : 1;
+		__u64 flm_csr_init_p1_fail : 1;
+		__u64 flm_csr_init_p2_fail : 1;
+		__u64 flm_csr_init_p1_abort : 1;
+		__u64 flm_csr_init_p2_abort : 1;
+		__u64 flm_csr_init_p1_len_err : 1;
+		__u64 flm_csr_init_p2_len_err : 1;
+		__u64 flm_csr_init_p1_cont_err : 1;
+		__u64 flm_csr_init_p2_cont_err : 1;
+		__u64 flm_csr_init_p1_axi_decerr : 1;
+		__u64 flm_csr_init_p2_axi_decerr : 1;
+		__u64 flm_csr_init_p1_axi_slverr : 1;
+		__u64 flm_csr_init_p2_axi_slverr : 1;
+		__u64 flm_serdes_rom_load_spi_err : 1;
+		__u64 flm_serdes_rom_load_error : 1;
+		__u64 flm_serdes_rom_load_abort : 1;
+		__u64 flm_serdes_rom_load_fail : 1;
+		__u64 flm_hg_spi_error : 1;
+		__u64 flm_hg_addr_error : 1;
+		__u64 flm_sbus_wr_error : 1;
+		__u64 flm_sbus_rd_error : 1;
+		__u64: 34;
+	};
+};
+
+#define C_MB_EXT_ERR_FIRST_FLG_OFFSET 0x00000210
+#define C_MB_EXT_ERR_FIRST_FLG (C_MB_BASE + C_MB_EXT_ERR_FIRST_FLG_OFFSET)
+#define C_MB_EXT_ERR_FIRST_FLG_SIZE 0x00000008
+#define C_MB_EXT_ERR_FIRST_FLG_TS_OFFSET 0x00000218
+#define C_MB_EXT_ERR_FIRST_FLG_TS (C_MB_BASE + C_MB_EXT_ERR_FIRST_FLG_TS_OFFSET)
+#define C_MB_EXT_ERR_FIRST_FLG_TS_SIZE 0x00000008
+#define C_MB_EXT_ERR_CLR_OFFSET 0x00000220
+#define C_MB_EXT_ERR_CLR (C_MB_BASE + C_MB_EXT_ERR_CLR_OFFSET)
+#define C_MB_EXT_ERR_CLR_SIZE 0x00000008
+#define C_MB_EXT_ERR_IRQA_MSK_OFFSET 0x00000228
+#define C_MB_EXT_ERR_IRQA_MSK (C_MB_BASE + C_MB_EXT_ERR_IRQA_MSK_OFFSET)
+#define C_MB_EXT_ERR_IRQA_MSK_SIZE 0x00000008
+#define C_MB_EXT_ERR_IRQB_MSK_OFFSET 0x00000230
+#define C_MB_EXT_ERR_IRQB_MSK (C_MB_BASE + C_MB_EXT_ERR_IRQB_MSK_OFFSET)
+#define C_MB_EXT_ERR_IRQB_MSK_SIZE 0x00000008
+#define C_MB_EXT_ERR_INFO_MSK_OFFSET 0x00000240
+#define C_MB_EXT_ERR_INFO_MSK (C_MB_BASE + C_MB_EXT_ERR_INFO_MSK_OFFSET)
+#define C_MB_EXT_ERR_INFO_MSK_SIZE 0x00000008
+#define C_MB_CFG_MISC_OFFSET 0x00004000
+#define C_MB_CFG_MISC (C_MB_BASE + C_MB_CFG_MISC_OFFSET)
+#define C_MB_CFG_MISC_SIZE 0x00000008
+
+union c_mb_cfg_misc {
+	__u64 qw;
+	struct {
+		__u64 nic_warm_rst0 : 1;
+		__u64 nic_warm_rst1 : 1;
+		__u64 nic_warm_rst2 : 1;
+		__u64 nic_warm_rst3 : 1;
+		__u64 nic_warm_rst4 : 1;
+		__u64 nic_warm_rst5 : 1;
+		__u64 nic_warm_rst6 : 1;
+		__u64 nic_warm_rst7 : 1;
+		__u64 nic_warm_rst8 : 1;
+		__u64 nic_warm_rst9 : 1;
+		__u64: 6;
+		__u64 nic_warm_rst_mask : 10;
+		__u64 mb_warm_rst_mask : 1;
+		__u64 pi_warm_rst_mask : 1;
+		__u64: 3;
+		__u64 halt_clock_en : 1;
+		__u64 cold_rst_enable : 16;
+		__u64 cold_rst : 1;
+		__u64 mb_cold_rst_enable : 1;
+		__u64 cold_rst_on_perst : 1;
+		__u64 cold_rst_on_hot_rst : 1;
+		__u64 skip_rom_load_on_forced_cold_rst : 1;
+		__u64 ignore_link_req_rst : 1;
+		__u64 ignore_gpout_all_done : 1;
+		__u64 ignore_gpout_efuse_done : 1;
+		__u64 ignore_gpout_temp_pushed : 1;
+		__u64 ignore_ancil_osc_clk_rdy : 1;
+		__u64: 6;
+	};
+};
+
+#define C_MB_STS_REV_OFFSET 0x00004008
+#define C_MB_STS_REV (C_MB_BASE + C_MB_STS_REV_OFFSET)
+#define C_MB_STS_REV_SIZE 0x00000008
+
+union c_mb_sts_rev {
+	__u64 qw;
+	struct {
+		__u64 rev : 16;
+		__u64 device_id : 16;
+		__u64 vendor_id : 16;
+		__u64 proto : 12;
+		__u64 platform : 4;
+	};
+};
+
+#define C_MB_CFG_EVENT_CNTS_OFFSET 0x00004010
+#define C_MB_CFG_EVENT_CNTS (C_MB_BASE + C_MB_CFG_EVENT_CNTS_OFFSET)
+#define C_MB_CFG_EVENT_CNTS_SIZE 0x00000008
+
+union c_mb_cfg_event_cnts {
+	__u64 qw;
+	struct {
+		__u64 enable : 1;
+		__u64 init : 1;
+		__u64 init_done : 1;
+		__u64 warm_rst_disable : 1;
+		__u64 ovf_cnt : 16;
+		__u64: 44;
+	};
+};
+
+#define C_MB_DBG_SCRATCH_OFFSET(idx) (0x00004020 + ((idx) * 8))
+#define C_MB_DBG_SCRATCH_ENTRIES 8
+#define C_MB_DBG_SCRATCH(idx) (C_MB_BASE + C_MB_DBG_SCRATCH_OFFSET(idx))
+#define C_MB_DBG_SCRATCH_SIZE 0x00000040
+
+union c_mb_dbg_scratch {
+	__u64 qw;
+	struct {
+		__u64 scratch;
+	};
+};
+
+#define C_MB_CFG_CRMC_OFFSET(idx) (0x0000d000 + ((idx) * 8))
+#define C_MB_CFG_CRMC_ENTRIES 3
+#define C_MB_CFG_CRMC(idx) (C_MB_BASE + C_MB_CFG_CRMC_OFFSET(idx))
+#define C_MB_CFG_CRMC_SIZE 0x00000018
+
+union c_mb_cfg_crmc {
+	__u64 qw;
+	struct {
+		__u64 ring_timeout : 8;
+		__u64 rready_timeout_disable : 1;
+		__u64 bready_timeout_disable : 1;
+		__u64 rd_addr_invalid_decerr_disable : 1;
+		__u64: 53;
+	};
+};
+
+#define C_MB_DBG_CFG_SBUS_MASTER_OFFSET 0x0000e000
+#define C_MB_DBG_CFG_SBUS_MASTER (C_MB_BASE + C_MB_DBG_CFG_SBUS_MASTER_OFFSET)
+#define C_MB_DBG_CFG_SBUS_MASTER_SIZE 0x00000008
+
+union c_mb_dbg_cfg_sbus_master {
+	__u64 qw;
+	struct {
+		__u64 execute : 1;
+		__u64 rcv_data_valid_sel : 1;
+		__u64 mode : 1;
+		__u64 stop_on_overrun : 1;
+		__u64 stop_on_write_error : 1;
+		__u64: 3;
+		__u64 command : 8;
+		__u64 receiver_address : 8;
+		__u64 data_address : 8;
+		__u64 data : 32;
+	};
+};
+
+#define C_MB_DBG_STS_SBUS_MASTER_OFFSET 0x0000e010
+#define C_MB_DBG_STS_SBUS_MASTER (C_MB_BASE + C_MB_DBG_STS_SBUS_MASTER_OFFSET)
+#define C_MB_DBG_STS_SBUS_MASTER_SIZE 0x00000008
+
+union c_mb_dbg_sts_sbus_master {
+	__u64 qw;
+	struct {
+		__u64 done : 1;
+		__u64 rcv_data_valid : 1;
+		__u64 overrun : 1;
+		__u64 write_error : 1;
+		__u64 result_code : 3;
+		__u64: 1;
+		__u64 command : 8;
+		__u64 receiver_address : 8;
+		__u64 data_address : 8;
+		__u64 data : 32;
+	};
+};
+
+#define C_MB_CFG_RTC_OFFSET 0x0000f000
+#define C_MB_CFG_RTC (C_MB_BASE + C_MB_CFG_RTC_OFFSET)
+#define C_MB_CFG_RTC_SIZE 0x00000008
+
+union c_mb_cfg_rtc {
+	__u64 qw;
+	struct {
+		__u64 rtc_enable : 1;
+		__u64 rtc_load : 1;
+		__u64 rtc_update : 1;
+		__u64: 1;
+		__u64 rtc_etc_sec_change_mask : 3;
+		__u64: 9;
+		__u64 etc_enable : 1;
+		__u64 etc_load : 1;
+		__u64: 2;
+		__u64 etc_ns_lock_resolution : 3;
+		__u64: 41;
+	};
+};
+
+#define C_MB_STS_RTC_OFFSET 0x0000f008
+#define C_MB_STS_RTC (C_MB_BASE + C_MB_STS_RTC_OFFSET)
+#define C_MB_STS_RTC_SIZE 0x00000008
+
+union c_mb_sts_rtc {
+	__u64 qw;
+	struct {
+		__u64 rtc_minus_etc_sec : 48;
+		__u64 rtc_lt_etc_sec : 1;
+		__u64 rtc_minus_etc_sec_change : 1;
+		__u64 etc_ns_locked : 1;
+		__u64 etc_ns_lost_lock : 1;
+		__u64: 12;
+	};
+};
+
+#define C_MB_CFG_RTC_TIME_OFFSET 0x0000f010
+#define C_MB_CFG_RTC_TIME (C_MB_BASE + C_MB_CFG_RTC_TIME_OFFSET)
+#define C_MB_CFG_RTC_TIME_SIZE 0x00000010
+
+union c_mb_cfg_rtc_time {
+	__u64 qw[2];
+	struct {
+		__u64 nanoseconds : 30;
+		__u64 seconds_33_0 : 34;
+		__u64 seconds_47_34 : 14;
+		__u64: 50;
+	};
+};
+
+#define C_MB_CFG_RTC_INC_OFFSET 0x0000f020
+#define C_MB_CFG_RTC_INC (C_MB_BASE + C_MB_CFG_RTC_INC_OFFSET)
+#define C_MB_CFG_RTC_INC_SIZE 0x00000008
+
+union c_mb_cfg_rtc_inc {
+	__u64 qw;
+	struct {
+		__u64 fractional_ns : 32;
+		__u64 nanoseconds : 10;
+		__u64: 22;
+	};
+};
+
+#define C_MB_STS_RTC_CURRENT_TIME_OFFSET 0x0000f030
+#define C_MB_STS_RTC_CURRENT_TIME (C_MB_BASE + C_MB_STS_RTC_CURRENT_TIME_OFFSET)
+#define C_MB_STS_RTC_CURRENT_TIME_SIZE 0x00000010
+
+union c_mb_sts_rtc_current_time {
+	__u64 qw[2];
+	struct {
+		__u64 nanoseconds : 30;
+		__u64 seconds_33_0 : 34;
+		__u64 seconds_47_34 : 14;
+		__u64: 50;
+	};
+};
+
+#define C_MB_STS_RTC_LAST_TIME_OFFSET 0x0000f040
+#define C_MB_STS_RTC_LAST_TIME (C_MB_BASE + C_MB_STS_RTC_LAST_TIME_OFFSET)
+#define C_MB_STS_RTC_LAST_TIME_SIZE 0x00000010
+
+union c_mb_sts_rtc_last_time {
+	__u64 qw[2];
+	struct {
+		__u64 nanoseconds : 30;
+		__u64 seconds_33_0 : 34;
+		__u64 seconds_47_34 : 14;
+		__u64: 50;
+	};
+};
+
+#define C_MB_STS_RTC_ETC_CUR_TIME_OFFSET 0x0000f050
+#define C_MB_STS_RTC_ETC_CUR_TIME (C_MB_BASE + C_MB_STS_RTC_ETC_CUR_TIME_OFFSET)
+#define C_MB_STS_RTC_ETC_CUR_TIME_SIZE 0x00000008
+
+union c_mb_sts_rtc_etc_cur_time {
+	__u64 qw;
+	struct {
+		__u64 nanoseconds : 30;
+		__u64 seconds : 34;
+	};
+};
+
+#define C_MB_STS_RTC_ETC_LAST_TIME_OFFSET 0x0000f058
+#define C_MB_STS_RTC_ETC_LAST_TIME (C_MB_BASE + C_MB_STS_RTC_ETC_LAST_TIME_OFFSET)
+#define C_MB_STS_RTC_ETC_LAST_TIME_SIZE 0x00000008
+
+union c_mb_sts_rtc_etc_last_time {
+	__u64 qw;
+	struct {
+		__u64 nanoseconds : 30;
+		__u64 seconds : 34;
+	};
+};
+
+#define C_MB_STS_EVENT_CNTS_OFFSET(idx) (0x00020000 + ((idx) * 8))
+#ifndef C_MB_STS_EVENT_CNTS_ENTRIES
+#define C_MB_STS_EVENT_CNTS_ENTRIES 256
+#endif
+#define C_MB_STS_EVENT_CNTS(idx) (C_MB_BASE + C_MB_STS_EVENT_CNTS_OFFSET(idx))
+#define C_MB_STS_EVENT_CNTS_SIZE 0x00000800
+
+union c_mb_sts_event_cnts {
+	__u64 qw;
+	struct {
+		__u64 cnt : 56;
+		__u64: 8;
+	};
+};
+
+#define C_MST_CFG_CRNC_OFFSET 0x00000000
+#define C_MST_CFG_CRNC (C_MST_BASE + C_MST_CFG_CRNC_OFFSET)
+#define C_MST_CFG_CRNC_SIZE 0x00000008
+
+union c_mst_cfg_crnc {
+	__u64 qw;
+	struct {
+		__u64 csr_timeout : 8;
+		__u64 mcast_id : 10;
+		__u64: 1;
+		__u64 mcast_enable : 1;
+		__u64 mcast_mask : 10;
+		__u64: 34;
+	};
+};
+
+#define C_MST_CFG_RT_OFFSET_OFFSET 0x00000020
+#define C_MST_CFG_RT_OFFSET (C_MST_BASE + C_MST_CFG_RT_OFFSET_OFFSET)
+#define C_MST_CFG_RT_OFFSET_SIZE 0x00000008
+
+union c_mst_cfg_rt_offset {
+	__u64 qw;
+	struct {
+		__u64 seconds : 48;
+		__u64: 16;
+	};
+};
+
+#define C_MST_MSC_SHADOW_ACTION_OFFSET 0x00000038
+#define C_MST_MSC_SHADOW_ACTION (C_MST_BASE + C_MST_MSC_SHADOW_ACTION_OFFSET)
+#define C_MST_MSC_SHADOW_ACTION_SIZE 0x00000008
+#define C_MST_MSC_SHADOW_OFFSET 0x00000040
+#define C_MST_MSC_SHADOW (C_MST_BASE + C_MST_MSC_SHADOW_OFFSET)
+#define C_MST_MSC_SHADOW_SIZE 0x00000040
+
+union c_mst_msc_shadow {
+	__u64 qw[8];
+};
+
+#define C_MST_ERR_ELAPSED_TIME_OFFSET 0x00000100
+#define C_MST_ERR_ELAPSED_TIME (C_MST_BASE + C_MST_ERR_ELAPSED_TIME_OFFSET)
+#define C_MST_ERR_ELAPSED_TIME_SIZE 0x00000008
+
+union c_mst_err_elapsed_time {
+	__u64 qw;
+	struct {
+		__u64 nanoseconds : 30;
+		__u64 seconds : 34;
+	};
+};
+
+#define C_MST_ERR_FLG_OFFSET 0x00000108
+#define C_MST_ERR_FLG (C_MST_BASE + C_MST_ERR_FLG_OFFSET)
+#define C_MST_ERR_FLG_SIZE 0x00000008
+
+union c_mst_err_flg {
+	__u64 qw;
+	struct {
+		__u64 sw_diag : 1;
+		__u64 crnc_ring_sync_error : 1;
+		__u64 crnc_ring_ecc_sbe : 1;
+		__u64 crnc_ring_ecc_mbe : 1;
+		__u64 crnc_ring_cmd_unknown : 1;
+		__u64 crnc_csr_cmd_unknown : 1;
+		__u64 crnc_csr_cmd_incomplete : 1;
+		__u64 crnc_buf_ecc_sbe : 1;
+		__u64 crnc_buf_ecc_mbe : 1;
+		__u64: 23;
+		__u64 lnk_list_ptrs_cor : 1;
+		__u64 lnk_list_ptrs_ucor : 1;
+		__u64: 2;
+		__u64 req_fifo_unrun : 1;
+		__u64 req_fifo_ovrun : 1;
+		__u64 req_fifo_crdt_unflw : 1;
+		__u64: 5;
+		__u64 match_crdt_unflw_get : 1;
+		__u64 match_crdt_unflw_put : 1;
+		__u64 evnt_fifo_cor : 1;
+		__u64 evnt_fifo_ucor : 1;
+		__u64 evnt_fifo_unrun : 1;
+		__u64 evnt_fifo_ovrun : 1;
+		__u64 ee_crdt_unflw : 1;
+		__u64 req_fifo_cor : 1;
+		__u64 req_fifo_ucor : 1;
+		__u64 mst_table_cor : 1;
+		__u64 mst_table_ucor : 1;
+		__u64 ll_data_ram_cor : 1;
+		__u64 ll_data_ram_ucor : 1;
+		__u64: 7;
+	};
+};
+
+#define C_MST_ERR_FIRST_FLG_OFFSET 0x00000110
+#define C_MST_ERR_FIRST_FLG (C_MST_BASE + C_MST_ERR_FIRST_FLG_OFFSET)
+#define C_MST_ERR_FIRST_FLG_SIZE 0x00000008
+#define C_MST_ERR_FIRST_FLG_TS_OFFSET 0x00000118
+#define C_MST_ERR_FIRST_FLG_TS (C_MST_BASE + C_MST_ERR_FIRST_FLG_TS_OFFSET)
+#define C_MST_ERR_FIRST_FLG_TS_SIZE 0x00000008
+#define C_MST_ERR_CLR_OFFSET 0x00000120
+#define C_MST_ERR_CLR (C_MST_BASE + C_MST_ERR_CLR_OFFSET)
+#define C_MST_ERR_CLR_SIZE 0x00000008
+#define C_MST_ERR_IRQA_MSK_OFFSET 0x00000128
+#define C_MST_ERR_IRQA_MSK (C_MST_BASE + C_MST_ERR_IRQA_MSK_OFFSET)
+#define C_MST_ERR_IRQA_MSK_SIZE 0x00000008
+#define C_MST_ERR_IRQB_MSK_OFFSET 0x00000130
+#define C_MST_ERR_IRQB_MSK (C_MST_BASE + C_MST_ERR_IRQB_MSK_OFFSET)
+#define C_MST_ERR_IRQB_MSK_SIZE 0x00000008
+#define C_MST_ERR_INFO_MSK_OFFSET 0x00000140
+#define C_MST_ERR_INFO_MSK (C_MST_BASE + C_MST_ERR_INFO_MSK_OFFSET)
+#define C_MST_ERR_INFO_MSK_SIZE 0x00000008
+#define C_MST_ERR_INFO_MEM_OFFSET 0x00000180
+#define C_MST_ERR_INFO_MEM (C_MST_BASE + C_MST_ERR_INFO_MEM_OFFSET)
+#define C_MST_ERR_INFO_MEM_SIZE 0x00000008
+
+union c_mst_err_info_mem {
+	__u64 qw;
+	struct {
+		__u64 cor_syndrome : 11;
+		__u64: 1;
+		__u64 cor_address : 12;
+		__u64 cor_mem_id : 6;
+		__u64: 1;
+		__u64 cor_csr_detected : 1;
+		__u64 ucor_syndrome : 11;
+		__u64: 1;
+		__u64 ucor_address : 12;
+		__u64 ucor_mem_id : 6;
+		__u64: 1;
+		__u64 ucor_csr_detected : 1;
+	};
+};
+
+#define C_MST_CFG_RC_UPDATE_OFFSET 0x00000400
+#define C_MST_CFG_RC_UPDATE (C_MST_BASE + C_MST_CFG_RC_UPDATE_OFFSET)
+#define C_MST_CFG_RC_UPDATE_SIZE 0x00000008
+
+union c_mst_cfg_rc_update {
+	__u64 qw;
+	struct {
+		__u64 return_code : 6;
+		__u64: 2;
+		__u64 mst_idx : 11;
+		__u64: 5;
+		__u64 buffer_idx : 16;
+		__u64 portal_idx : 11;
+		__u64: 1;
+		__u64 ptl_list : 2;
+		__u64: 2;
+		__u64 ptl_vld : 1;
+		__u64 portal_vld : 1;
+		__u64 buffer_vld : 1;
+		__u64: 5;
+	};
+};
+
+#define C_MST_STS_RC_STS_OFFSET 0x00010000
+#define C_MST_STS_RC_STS (C_MST_BASE + C_MST_STS_RC_STS_OFFSET)
+#define C_MST_STS_RC_STS_SIZE 0x00000008
+
+union c_mst_sts_rc_sts {
+	__u64 qw;
+	struct {
+		__u64 done : 1;
+		__u64 match : 1;
+		__u64: 62;
+	};
+};
+
+#define C_MST_STS_NUM_REQ_OFFSET 0x00010018
+#define C_MST_STS_NUM_REQ (C_MST_BASE + C_MST_STS_NUM_REQ_OFFSET)
+#define C_MST_STS_NUM_REQ_SIZE 0x00000008
+
+union c_mst_sts_num_req {
+	__u64 qw;
+	struct {
+		__u64 cnt : 12;
+		__u64: 52;
+	};
+};
+
+#define C_MST_DBG_MST_TABLE_OFFSET(idx) (0x00020000 + ((idx) * 64))
+#define C_MST_DBG_MST_TABLE_ENTRIES 2048
+#define C_MST_DBG_MST_TABLE(idx) (C_MST_BASE + C_MST_DBG_MST_TABLE_OFFSET(idx))
+#define C_MST_DBG_MST_TABLE_SIZE 0x00020000
+
+union c_mst_dbg_mst_table {
+	__u64 qw[8];
+	struct {
+		__u64 cntr_pool_id : 2;
+		__u64: 2;
+		__u64 rendezvous : 1;
+		__u64: 3;
+		__u64 rendezvous_id : 8;
+		__u64 vni : 16;
+		__u64 lpe_stat_1 : 16;
+		__u64 lpe_stat_2 : 16;
+		__u64 auto_unlinked : 1;
+		__u64: 7;
+		__u64 dma_hdr_len : 6;
+		__u64: 2;
+		__u64 event_ct_bytes : 1;
+		__u64 event_ct_comm : 1;
+		__u64 event_success_disable : 1;
+		__u64 event_comm_disable : 1;
+		__u64 use_once : 1;
+		__u64 event_use_long_fmt : 1;
+		__u64 event_start_at_base : 1;
+		__u64 unrestricted_end_ro : 1;
+		__u64 unrestricted_body_ro : 1;
+		__u64 acid : 10;
+		__u64: 5;
+		__u64 ct_handle : 11;
+		__u64: 1;
+		__u64 eq_handle : 11;
+		__u64: 1;
+		__u64 portal_index : 11;
+		__u64: 1;
+		__u64 ptl_list : 2;
+		__u64: 2;
+		__u64 buffer_id : 16;
+		__u64 initiator : 32;
+		__u64 hdr_data;
+		__u64 match_bits;
+		__u64 mlength : 32;
+		__u64 rlength : 32;
+		__u64 remote_offset : 56;
+		__u64 return_code : 6;
+		__u64: 2;
+		__u64 start_addr : 57;
+		__u64: 7;
+	};
+};
+
+#define C_MST_DBG_MATCH_DONE_OFFSET 0x00064100
+#define C_MST_DBG_MATCH_DONE (C_MST_BASE + C_MST_DBG_MATCH_DONE_OFFSET)
+#define C_MST_DBG_MATCH_DONE_SIZE 0x00000008
+
+union c_mst_dbg_match_done {
+	__u64 qw;
+	struct {
+		__u64 mst_idx : 11;
+		__u64: 5;
+		__u64 wr_en : 1;
+		__u64: 3;
+		__u64 mst_idx_st : 1;
+		__u64: 43;
+	};
+};
+
+#define C_OXE_CFG_CRNC_OFFSET 0x00000000
+#define C_OXE_CFG_CRNC (C_OXE_BASE + C_OXE_CFG_CRNC_OFFSET)
+#define C_OXE_CFG_CRNC_SIZE 0x00000008
+
+union c_oxe_cfg_crnc {
+	__u64 qw;
+	struct {
+		__u64 csr_timeout : 8;
+		__u64 mcast_id : 10;
+		__u64: 1;
+		__u64 mcast_enable : 1;
+		__u64 mcast_mask : 10;
+		__u64: 34;
+	};
+};
+
+#define C_OXE_CFG_RT_OFFSET_OFFSET 0x00000020
+#define C_OXE_CFG_RT_OFFSET (C_OXE_BASE + C_OXE_CFG_RT_OFFSET_OFFSET)
+#define C_OXE_CFG_RT_OFFSET_SIZE 0x00000008
+
+union c_oxe_cfg_rt_offset {
+	__u64 qw;
+	struct {
+		__u64 seconds : 48;
+		__u64: 16;
+	};
+};
+
+#define C_OXE_MSC_SHADOW_ACTION_OFFSET 0x00000038
+#define C_OXE_MSC_SHADOW_ACTION (C_OXE_BASE + C_OXE_MSC_SHADOW_ACTION_OFFSET)
+#define C_OXE_MSC_SHADOW_ACTION_SIZE 0x00000008
+#define C_OXE_MSC_SHADOW_OFFSET 0x00000040
+#define C_OXE_MSC_SHADOW (C_OXE_BASE + C_OXE_MSC_SHADOW_OFFSET)
+#define C_OXE_MSC_SHADOW_SIZE 0x00000040
+
+union c_oxe_msc_shadow {
+	__u64 qw[8];
+};
+
+#define C_OXE_ERR_ELAPSED_TIME_OFFSET 0x00000100
+#define C_OXE_ERR_ELAPSED_TIME (C_OXE_BASE + C_OXE_ERR_ELAPSED_TIME_OFFSET)
+#define C_OXE_ERR_ELAPSED_TIME_SIZE 0x00000008
+
+union c_oxe_err_elapsed_time {
+	__u64 qw;
+	struct {
+		__u64 nanoseconds : 30;
+		__u64 seconds : 34;
+	};
+};
+
+#define C_OXE_ERR_FLG_OFFSET 0x00000108
+#define C_OXE_ERR_FLG (C_OXE_BASE + C_OXE_ERR_FLG_OFFSET)
+#define C_OXE_ERR_FLG_SIZE 0x00000008
+
+union c_oxe_err_flg {
+	__u64 qw;
+	struct {
+		__u64 sw_diag : 1;
+		__u64 crnc_ring_sync_error : 1;
+		__u64 crnc_ring_ecc_sbe : 1;
+		__u64 crnc_ring_ecc_mbe : 1;
+		__u64 crnc_ring_cmd_unknown : 1;
+		__u64 crnc_csr_cmd_unknown : 1;
+		__u64 crnc_csr_cmd_incomplete : 1;
+		__u64 crnc_buf_ecc_sbe : 1;
+		__u64 crnc_buf_ecc_mbe : 1;
+		__u64: 5;
+		__u64 spt_cdt_err : 1;
+		__u64 smt_cdt_err : 1;
+		__u64 cells_mem_cor : 1;
+		__u64 pkl_mem_cor : 1;
+		__u64 pct_sb_mcu_mem_cor : 1;
+		__u64 pct_sb_sct_mem_cor : 1;
+		__u64 dmu_mem_cor : 1;
+		__u64 rec_mem_cor : 1;
+		__u64 atreq_mem_cor : 1;
+		__u64 atrsp_mem_cor : 1;
+		__u64 tso_flit_cor : 1;
+		__u64 sb_fifo_cor : 1;
+		__u64 rarb_hdr_cor : 1;
+		__u64 rarb_data_cor : 1;
+		__u64 at_resp_bus_cor : 1;
+		__u64 ixe_cmd_cor : 1;
+		__u64 lpe_cmd_cor : 1;
+		__u64 tou_cmd_cor : 1;
+		__u64 cq_cmd_cor : 1;
+		__u64 cells_mem_ucor : 1;
+		__u64 pkl_mem_ucor : 1;
+		__u64 pct_sb_mcu_mem_ucor : 1;
+		__u64 pct_sb_sct_mem_ucor : 1;
+		__u64 dmu_mem_ucor : 1;
+		__u64 rec_mem_ucor : 1;
+		__u64 atreq_mem_ucor : 1;
+		__u64 atrsp_mem_ucor : 1;
+		__u64 tso_flit_ucor : 1;
+		__u64 sb_fifo_ucor : 1;
+		__u64 rarb_hdr_ucor : 1;
+		__u64 rarb_data_ucor : 1;
+		__u64 at_resp_bus_ucor : 1;
+		__u64 ixe_cmd_ucor : 1;
+		__u64 lpe_cmd_ucor : 1;
+		__u64 tou_cmd_ucor : 1;
+		__u64 cq_cmd_ucor : 1;
+		__u64 fifo_err : 1;
+		__u64 credit_uflw : 1;
+		__u64 spt_ignore_err : 1;
+		__u64 smt_ignore_err : 1;
+		__u64 sct_ignore_err : 1;
+		__u64 srb_ignore_err : 1;
+		__u64 cmd_unexpected : 1;
+		__u64 rarb_hw_err : 1;
+		__u64 pcie_unsuccess_cmpl : 1;
+		__u64 pcie_error_poisoned : 1;
+		__u64 at_overrun_err : 1;
+		__u64 mdr_pipe_ucor : 1;
+		__u64 cell_xlate_parity_err : 1;
+		__u64: 1;
+	};
+};
+
+#define C_OXE_ERR_FIRST_FLG_OFFSET 0x00000110
+#define C_OXE_ERR_FIRST_FLG (C_OXE_BASE + C_OXE_ERR_FIRST_FLG_OFFSET)
+#define C_OXE_ERR_FIRST_FLG_SIZE 0x00000008
+#define C_OXE_ERR_FIRST_FLG_TS_OFFSET 0x00000118
+#define C_OXE_ERR_FIRST_FLG_TS (C_OXE_BASE + C_OXE_ERR_FIRST_FLG_TS_OFFSET)
+#define C_OXE_ERR_FIRST_FLG_TS_SIZE 0x00000008
+#define C_OXE_ERR_CLR_OFFSET 0x00000120
+#define C_OXE_ERR_CLR (C_OXE_BASE + C_OXE_ERR_CLR_OFFSET)
+#define C_OXE_ERR_CLR_SIZE 0x00000008
+#define C_OXE_ERR_IRQA_MSK_OFFSET 0x00000128
+#define C_OXE_ERR_IRQA_MSK (C_OXE_BASE + C_OXE_ERR_IRQA_MSK_OFFSET)
+#define C_OXE_ERR_IRQA_MSK_SIZE 0x00000008
+#define C_OXE_ERR_IRQB_MSK_OFFSET 0x00000130
+#define C_OXE_ERR_IRQB_MSK (C_OXE_BASE + C_OXE_ERR_IRQB_MSK_OFFSET)
+#define C_OXE_ERR_IRQB_MSK_SIZE 0x00000008
+#define C_OXE_ERR_INFO_MSK_OFFSET 0x00000140
+#define C_OXE_ERR_INFO_MSK (C_OXE_BASE + C_OXE_ERR_INFO_MSK_OFFSET)
+#define C_OXE_ERR_INFO_MSK_SIZE 0x00000008
+#define C_OXE_ERR_INFO_MEM_OFFSET 0x00000180
+#define C_OXE_ERR_INFO_MEM (C_OXE_BASE + C_OXE_ERR_INFO_MEM_OFFSET)
+#define C_OXE_ERR_INFO_MEM_SIZE 0x00000008
+
+union c_oxe_err_info_mem {
+	__u64 qw;
+	struct {
+		__u64 cor_syndrome : 11;
+		__u64: 1;
+		__u64 cor_address : 12;
+		__u64 cor_mem_id : 5;
+		__u64: 2;
+		__u64 cor_csr_detected : 1;
+		__u64 ucor_syndrome : 11;
+		__u64: 1;
+		__u64 ucor_address : 12;
+		__u64 ucor_mem_id : 5;
+		__u64: 2;
+		__u64 ucor_csr_detected : 1;
+	};
+};
+
+#define C_OXE_ERR_INFO_FIFO_ERR_OFFSET 0x00000188
+#define C_OXE_ERR_INFO_FIFO_ERR (C_OXE_BASE + C_OXE_ERR_INFO_FIFO_ERR_OFFSET)
+#define C_OXE_ERR_INFO_FIFO_ERR_SIZE 0x00000008
+
+union c_oxe_err_info_fifo_err {
+	__u64 qw;
+	struct {
+		__u64 overrun : 1;
+		__u64 underrun : 1;
+		__u64: 6;
+		__u64 fifo_id : 4;
+		__u64: 52;
+	};
+};
+
+#define C_OXE_ERR_INFO_CC_OFFSET 0x00000190
+#define C_OXE_ERR_INFO_CC (C_OXE_BASE + C_OXE_ERR_INFO_CC_OFFSET)
+#define C_OXE_ERR_INFO_CC_SIZE 0x00000008
+
+union c_oxe_err_info_cc {
+	__u64 qw;
+	struct {
+		__u64 cc_id : 5;
+		__u64: 3;
+		__u64 sub_id : 4;
+		__u64: 52;
+	};
+};
+
+#define C_OXE_ERR_INFO_PCIE_UC_OFFSET 0x00000198
+#define C_OXE_ERR_INFO_PCIE_UC (C_OXE_BASE + C_OXE_ERR_INFO_PCIE_UC_OFFSET)
+#define C_OXE_ERR_INFO_PCIE_UC_SIZE 0x00000008
+
+union c_oxe_err_info_pcie_uc {
+	__u64 qw;
+	struct {
+		__u64 pcie_tag : 9;
+		__u64: 3;
+		__u64 cmpl_status : 3;
+		__u64: 49;
+	};
+};
+
+#define C_OXE_ERR_INFO_PCIE_EP_OFFSET 0x000001a0
+#define C_OXE_ERR_INFO_PCIE_EP (C_OXE_BASE + C_OXE_ERR_INFO_PCIE_EP_OFFSET)
+#define C_OXE_ERR_INFO_PCIE_EP_SIZE 0x00000008
+
+union c_oxe_err_info_pcie_ep {
+	__u64 qw;
+	struct {
+		__u64 pcie_tag : 9;
+		__u64: 55;
+	};
+};
+
+#define C_OXE_ERR_INFO_RARB_OFFSET 0x000001a8
+#define C_OXE_ERR_INFO_RARB (C_OXE_BASE + C_OXE_ERR_INFO_RARB_OFFSET)
+#define C_OXE_ERR_INFO_RARB_SIZE 0x00000008
+
+union c_oxe_err_info_rarb {
+	__u64 qw;
+	struct {
+		__u64 hdr_ucor : 1;
+		__u64 data_ucor : 1;
+		__u64 bad_vld : 1;
+		__u64 bad_size : 1;
+		__u64 bad_cmd : 1;
+		__u64 unexpected_cmpl_tag : 1;
+		__u64 cmpl_tag_out_of_range : 1;
+		__u64 pcie_tag : 9;
+		__u64: 48;
+	};
+};
+
+#define C_OXE_ERR_INFO_UNEXPCTD_OFFSET 0x000001b0
+#define C_OXE_ERR_INFO_UNEXPCTD (C_OXE_BASE + C_OXE_ERR_INFO_UNEXPCTD_OFFSET)
+#define C_OXE_ERR_INFO_UNEXPCTD_SIZE 0x00000008
+
+union c_oxe_err_info_unexpctd {
+	__u64 qw;
+	struct {
+		__u64 mcu_unexpc_cmd : 7;
+		__u64: 1;
+		__u64 ixe_unexp_cmd : 1;
+		__u64 lpe_unexp_cmd : 1;
+		__u64 tou_unexp_cmd : 1;
+		__u64 cq_unexp_cmd : 1;
+		__u64: 52;
+	};
+};
+
+#define C_OXE_ERR_INFO_CELL_XLATE_OFFSET 0x000001b8
+#define C_OXE_ERR_INFO_CELL_XLATE (C_OXE_BASE + C_OXE_ERR_INFO_CELL_XLATE_OFFSET)
+#define C_OXE_ERR_INFO_CELL_XLATE_SIZE 0x00000008
+
+union c_oxe_err_info_cell_xlate {
+	__u64 qw;
+	struct {
+		__u64 free_list_perr : 1;
+		__u64 vptr_table_perr : 1;
+		__u64 tt1_perr : 1;
+		__u64 tt2_perr : 1;
+		__u64 tt3_perr : 1;
+		__u64: 59;
+	};
+};
+
+#define C_OXE_ERR_INFO_IGNORE_ERR_OFFSET 0x000001e0
+#define C_OXE_ERR_INFO_IGNORE_ERR (C_OXE_BASE + C_OXE_ERR_INFO_IGNORE_ERR_OFFSET)
+#define C_OXE_ERR_INFO_IGNORE_ERR_SIZE 0x00000008
+
+union c_oxe_err_info_ignore_err {
+	__u64 qw;
+	struct {
+		__u64 spt_err : 1;
+		__u64 smt_err : 1;
+		__u64 sct_err : 1;
+		__u64 srb_err : 1;
+		__u64 bc : 4;
+		__u64 mcu_num : 7;
+		__u64: 49;
+	};
+};
+
+#define C_OXE_CFG_COMMON_OFFSET 0x00000400
+#define C_OXE_CFG_COMMON (C_OXE_BASE + C_OXE_CFG_COMMON_OFFSET)
+#define C_OXE_CFG_COMMON_SIZE 0x00000008
+
+union c_oxe_cfg_common {
+	__u64 qw;
+	struct {
+		__u64 occ_bin0_sz : 10;
+		__u64 occ_bin1_sz : 10;
+		__u64 occ_bin2_sz : 10;
+		__u64 occ_bin3_sz : 10;
+		__u64 ioi_enable : 1;
+		__u64 mcu_meas_unit : 2;
+		__u64: 21;
+	};
+};
+
+#define C_OXE_CFG_FAB_PARAM_OFFSET 0x00000410
+#define C_OXE_CFG_FAB_PARAM (C_OXE_BASE + C_OXE_CFG_FAB_PARAM_OFFSET)
+#define C_OXE_CFG_FAB_PARAM_SIZE 0x00000008
+
+union c_oxe_cfg_fab_param {
+	__u64 qw;
+	struct {
+		__u64 ver : 4;
+		__u64 req_32b_enabled : 1;
+		__u64 rsp_32b_enabled : 1;
+		__u64 req_40b_enabled : 1;
+		__u64 rsp_40b_enabled : 1;
+		__u64 ttl : 8;
+		__u64 protocol : 8;
+		__u64 ecn_enable : 8;
+		__u64 min_req_size : 6;
+		__u64: 2;
+		__u64 min_rsp_size : 6;
+		__u64: 18;
+	};
+};
+
+#define C_OXE_CFG_FAB_SFA_OFFSET 0x00000418
+#define C_OXE_CFG_FAB_SFA (C_OXE_BASE + C_OXE_CFG_FAB_SFA_OFFSET)
+#define C_OXE_CFG_FAB_SFA_SIZE 0x00000008
+
+union c_oxe_cfg_fab_sfa {
+	__u64 qw;
+	struct {
+		__u64 nid : 20;
+		__u64: 44;
+	};
+};
+
+#define C_OXE_CFG_DUMMY_ADDR_OFFSET 0x00000420
+#define C_OXE_CFG_DUMMY_ADDR (C_OXE_BASE + C_OXE_CFG_DUMMY_ADDR_OFFSET)
+#define C_OXE_CFG_DUMMY_ADDR_SIZE 0x00000008
+
+union c_oxe_cfg_dummy_addr {
+	__u64 qw;
+	struct {
+		__u64 ac : 10;
+		__u64: 2;
+		__u64 subaddr : 45;
+		__u64: 7;
+	};
+};
+
+#define C_OXE_CFG_PAUSE_QUANTA_OFFSET 0x00000438
+#define C_OXE_CFG_PAUSE_QUANTA (C_OXE_BASE + C_OXE_CFG_PAUSE_QUANTA_OFFSET)
+#define C_OXE_CFG_PAUSE_QUANTA_SIZE 0x00000008
+
+union c_oxe_cfg_pause_quanta {
+	__u64 qw;
+	struct {
+		__u64 sub_value : 24;
+		__u64 sub_period : 8;
+		__u64: 32;
+	};
+};
+
+#define C_OXE_CFG_FGFC_OFFSET 0x00000440
+#define C_OXE_CFG_FGFC (C_OXE_BASE + C_OXE_CFG_FGFC_OFFSET)
+#define C_OXE_CFG_FGFC_SIZE 0x00000008
+
+union c_oxe_cfg_fgfc {
+	__u64 qw;
+	struct {
+		__u64 extra_bytes : 4;
+		__u64 round_pos : 4;
+		__u64 enable : 1;
+		__u64: 7;
+		__u64 cdt_adj : 14;
+		__u64: 2;
+		__u64 cdt_limit : 24;
+		__u64: 8;
+	};
+};
+
+#define C_OXE_CFG_PCT_CDT_OFFSET 0x00000448
+#define C_OXE_CFG_PCT_CDT (C_OXE_BASE + C_OXE_CFG_PCT_CDT_OFFSET)
+#define C_OXE_CFG_PCT_CDT_SIZE 0x00000008
+
+union c_oxe_cfg_pct_cdt {
+	__u64 qw;
+	struct {
+		__u64 spt_cdt_limit : 11;
+		__u64: 5;
+		__u64 smt_cdt_limit : 9;
+		__u64: 7;
+		__u64 sct_cdt_limit : 13;
+		__u64: 3;
+		__u64 srb_cdt_limit : 12;
+		__u64: 4;
+	};
+};
+
+#define C_OXE_CFG_BUF_BC_PARAM_OFFSET(idx) (0x00000500 + ((idx) * 8))
+#define C_OXE_CFG_BUF_BC_PARAM_ENTRIES 10
+#define C_OXE_CFG_BUF_BC_PARAM(idx) (C_OXE_BASE + C_OXE_CFG_BUF_BC_PARAM_OFFSET(idx))
+#define C_OXE_CFG_BUF_BC_PARAM_SIZE 0x00000050
+
+union c_oxe_cfg_buf_bc_param {
+	__u64 qw;
+	struct {
+		__u64 bc_reserv_buf_cdt : 11;
+		__u64: 5;
+		__u64 bc_max_mtu : 8;
+		__u64: 40;
+	};
+};
+
+#define C_OXE_CFG_PCT_BC_CDT_OFFSET(idx) (0x00000600 + ((idx) * 8))
+#define C_OXE_CFG_PCT_BC_CDT_ENTRIES 10
+#define C_OXE_CFG_PCT_BC_CDT(idx) (C_OXE_BASE + C_OXE_CFG_PCT_BC_CDT_OFFSET(idx))
+#define C_OXE_CFG_PCT_BC_CDT_SIZE 0x00000050
+
+union c_oxe_cfg_pct_bc_cdt {
+	__u64 qw;
+	struct {
+		__u64 spt_cdt_rsvd : 11;
+		__u64: 5;
+		__u64 smt_cdt_rsvd : 9;
+		__u64: 7;
+		__u64 sct_cdt_rsvd : 13;
+		__u64: 3;
+		__u64 srb_cdt_rsvd : 12;
+		__u64 ignore_spt : 1;
+		__u64 ignore_smt : 1;
+		__u64 ignore_sct : 1;
+		__u64 ignore_srb : 1;
+	};
+};
+
+#define C_OXE_CFG_BUF_SH_CDT_OFFSET(idx) (0x00000700 + ((idx) * 8))
+#define C_OXE_CFG_BUF_SH_CDT_ENTRIES 10
+#define C_OXE_CFG_BUF_SH_CDT(idx) (C_OXE_BASE + C_OXE_CFG_BUF_SH_CDT_OFFSET(idx))
+#define C_OXE_CFG_BUF_SH_CDT_SIZE 0x00000050
+
+union c_oxe_cfg_buf_sh_cdt {
+	__u64 qw;
+	struct {
+		__u64 buf_sh_cdt : 11;
+		__u64: 5;
+		__u64 buf_sh_bc_cdt : 11;
+		__u64: 5;
+		__u64 buf_sh_bc_idc_cdt : 11;
+		__u64: 21;
+	};
+};
+
+#define C_OXE_CFG_MCU_PARAM_OFFSET(idx) (0x00001000 + ((idx) * 8))
+#define C_OXE_CFG_MCU_PARAM_ENTRIES 96
+#define C_OXE_CFG_MCU_PARAM(idx) (C_OXE_BASE + C_OXE_CFG_MCU_PARAM_OFFSET(idx))
+#define C_OXE_CFG_MCU_PARAM_SIZE 0x00000300
+
+union c_oxe_cfg_mcu_param {
+	__u64 qw;
+	struct {
+		__u64 bc_map : 4;
+		__u64 tsc_map : 4;
+		__u64 wdrr_out_sel : 2;
+		__u64 wdrr_in_sel : 2;
+		__u64 stall_cnt_en0 : 1;
+		__u64 stall_cnt_en1 : 1;
+		__u64 pcp_map : 3;
+		__u64 limit_sel : 2;
+		__u64: 45;
+	};
+};
+
+#define C_OXE_CFG_MCU_PRIORITY_LIMIT_OFFSET(idx) (0x00001400 + ((idx) * 8))
+#define C_OXE_CFG_MCU_PRIORITY_LIMIT_ENTRIES 96
+#define C_OXE_CFG_MCU_PRIORITY_LIMIT(idx) (C_OXE_BASE + C_OXE_CFG_MCU_PRIORITY_LIMIT_OFFSET(idx))
+#define C_OXE_CFG_MCU_PRIORITY_LIMIT_SIZE 0x00000300
+
+union c_oxe_cfg_mcu_priority_limit {
+	__u64 qw;
+	struct {
+		__u64 occ_blimit : 11;
+		__u64: 5;
+		__u64 occ_climit : 11;
+		__u64: 37;
+	};
+};
+
+#define C_OXE_CFG_ARB_CONFIG_OFFSET 0x00001808
+#define C_OXE_CFG_ARB_CONFIG (C_OXE_BASE + C_OXE_CFG_ARB_CONFIG_OFFSET)
+#define C_OXE_CFG_ARB_CONFIG_SIZE 0x00000008
+
+union c_oxe_cfg_arb_config {
+	__u64 qw;
+	struct {
+		__u64 fill_rate : 10;
+		__u64: 2;
+		__u64 mfs_out_sel : 2;
+		__u64 mfs_in_sel : 2;
+		__u64: 48;
+	};
+};
+
+#define C_OXE_CFG_ARB_MFS_OUT_OFFSET 0x00001810
+#define C_OXE_CFG_ARB_MFS_OUT (C_OXE_BASE + C_OXE_CFG_ARB_MFS_OUT_OFFSET)
+#define C_OXE_CFG_ARB_MFS_OUT_SIZE 0x00000008
+
+union c_oxe_cfg_arb_mfs_out {
+	__u64 qw;
+	struct {
+		__u64 mfs0 : 9;
+		__u64: 3;
+		__u64 mfs1 : 9;
+		__u64: 3;
+		__u64 mfs2 : 9;
+		__u64: 3;
+		__u64 mfs3 : 9;
+		__u64: 19;
+	};
+};
+
+#define C_OXE_CFG_ARB_MFS_IN_OFFSET 0x00001818
+#define C_OXE_CFG_ARB_MFS_IN (C_OXE_BASE + C_OXE_CFG_ARB_MFS_IN_OFFSET)
+#define C_OXE_CFG_ARB_MFS_IN_SIZE 0x00000008
+
+union c_oxe_cfg_arb_mfs_in {
+	__u64 qw;
+	struct {
+		__u64 mfs0 : 9;
+		__u64: 3;
+		__u64 mfs1 : 9;
+		__u64: 3;
+		__u64 mfs2 : 9;
+		__u64: 3;
+		__u64 mfs3 : 9;
+		__u64: 19;
+	};
+};
+
+#define C_OXE_CFG_ARB_DRR_OUT_OFFSET 0x00001820
+#define C_OXE_CFG_ARB_DRR_OUT (C_OXE_BASE + C_OXE_CFG_ARB_DRR_OUT_OFFSET)
+#define C_OXE_CFG_ARB_DRR_OUT_SIZE 0x00000008
+
+union c_oxe_cfg_arb_drr_out {
+	__u64 qw;
+	struct {
+		__u64 quanta_val0 : 12;
+		__u64 quanta_val1 : 12;
+		__u64 quanta_val2 : 12;
+		__u64 quanta_val3 : 12;
+		__u64: 16;
+	};
+};
+
+#define C_OXE_CFG_ARB_DRR_IN_OFFSET 0x00001828
+#define C_OXE_CFG_ARB_DRR_IN (C_OXE_BASE + C_OXE_CFG_ARB_DRR_IN_OFFSET)
+#define C_OXE_CFG_ARB_DRR_IN_SIZE 0x00000008
+
+union c_oxe_cfg_arb_drr_in {
+	__u64 qw;
+	struct {
+		__u64 quanta_val0 : 12;
+		__u64 quanta_val1 : 12;
+		__u64 quanta_val2 : 12;
+		__u64 quanta_val3 : 12;
+		__u64: 16;
+	};
+};
+
+#define C_OXE_CFG_ARB_HEAD_OUT_C_OFFSET 0x00001830
+#define C_OXE_CFG_ARB_HEAD_OUT_C (C_OXE_BASE + C_OXE_CFG_ARB_HEAD_OUT_C_OFFSET)
+#define C_OXE_CFG_ARB_HEAD_OUT_C_SIZE 0x00000008
+
+union c_oxe_cfg_arb_head_out_c {
+	__u64 qw;
+	struct {
+		__u64 fill_qty : 11;
+		__u64: 1;
+		__u64 limit : 18;
+		__u64 enable : 1;
+		__u64: 33;
+	};
+};
+
+#define C_OXE_CFG_ARB_HEAD_IN_C_OFFSET 0x00001838
+#define C_OXE_CFG_ARB_HEAD_IN_C (C_OXE_BASE + C_OXE_CFG_ARB_HEAD_IN_C_OFFSET)
+#define C_OXE_CFG_ARB_HEAD_IN_C_SIZE 0x00000008
+
+union c_oxe_cfg_arb_head_in_c {
+	__u64 qw;
+	struct {
+		__u64 fill_qty : 11;
+		__u64: 1;
+		__u64 limit : 18;
+		__u64 enable : 1;
+		__u64: 33;
+	};
+};
+
+#define C_OXE_CFG_ARB_PCP_MASK_OFFSET(idx) (0x00001840 + ((idx) * 8))
+#define C_OXE_CFG_ARB_PCP_MASK_ENTRIES 8
+#define C_OXE_CFG_ARB_PCP_MASK(idx) (C_OXE_BASE + C_OXE_CFG_ARB_PCP_MASK_OFFSET(idx))
+#define C_OXE_CFG_ARB_PCP_MASK_SIZE 0x00000040
+
+union c_oxe_cfg_arb_pcp_mask {
+	__u64 qw;
+	struct {
+		__u64 tsc_mask : 10;
+		__u64: 54;
+	};
+};
+
+#define C_OXE_CFG_OUTSTANDING_LIMIT_OFFSET(idx) (0x00001880 + ((idx) * 8))
+#define C_OXE_CFG_OUTSTANDING_LIMIT_ENTRIES 4
+#define C_OXE_CFG_OUTSTANDING_LIMIT(idx) (C_OXE_BASE + C_OXE_CFG_OUTSTANDING_LIMIT_OFFSET(idx))
+#define C_OXE_CFG_OUTSTANDING_LIMIT_SIZE 0x00000020
+
+union c_oxe_cfg_outstanding_limit {
+	__u64 qw;
+	struct {
+		__u64 put_limit : 11;
+		__u64 get_limit : 11;
+		__u64 ioi_ord_limit : 11;
+		__u64 ioi_unord_limit : 13;
+		__u64: 18;
+	};
+};
+
+#define C_OXE_CFG_ARB_LEAF_OFFSET(idx) (0x000018a0 + ((idx) * 8))
+#define C_OXE_CFG_ARB_LEAF_ENTRIES 10
+#define C_OXE_CFG_ARB_LEAF(idx) (C_OXE_BASE + C_OXE_CFG_ARB_LEAF_OFFSET(idx))
+#define C_OXE_CFG_ARB_LEAF_SIZE 0x00000050
+
+union c_oxe_cfg_arb_leaf {
+	__u64 qw;
+	struct {
+		__u64 pri : 3;
+		__u64: 1;
+		__u64 parent : 3;
+		__u64: 1;
+		__u64 mfs_out_sel : 2;
+		__u64 mfs_in_sel : 2;
+		__u64 enable_in : 1;
+		__u64: 51;
+	};
+};
+
+#define C_OXE_CFG_ARB_LEAF_OUT_A_OFFSET(idx) (0x00001900 + ((idx) * 8))
+#define C_OXE_CFG_ARB_LEAF_OUT_A_ENTRIES 10
+#define C_OXE_CFG_ARB_LEAF_OUT_A(idx) (C_OXE_BASE + C_OXE_CFG_ARB_LEAF_OUT_A_OFFSET(idx))
+#define C_OXE_CFG_ARB_LEAF_OUT_A_SIZE 0x00000050
+
+union c_oxe_cfg_arb_leaf_out_a {
+	__u64 qw;
+	struct {
+		__u64 fill_qty : 11;
+		__u64: 1;
+		__u64 limit : 18;
+		__u64: 34;
+	};
+};
+
+#define C_OXE_CFG_ARB_LEAF_OUT_C_OFFSET(idx) (0x00001980 + ((idx) * 8))
+#define C_OXE_CFG_ARB_LEAF_OUT_C_ENTRIES 10
+#define C_OXE_CFG_ARB_LEAF_OUT_C(idx) (C_OXE_BASE + C_OXE_CFG_ARB_LEAF_OUT_C_OFFSET(idx))
+#define C_OXE_CFG_ARB_LEAF_OUT_C_SIZE 0x00000050
+
+union c_oxe_cfg_arb_leaf_out_c {
+	__u64 qw;
+	struct {
+		__u64 fill_qty : 11;
+		__u64: 1;
+		__u64 limit : 18;
+		__u64 enable : 1;
+		__u64: 33;
+	};
+};
+
+#define C_OXE_CFG_ARB_LEAF_IN_A_OFFSET(idx) (0x00001a00 + ((idx) * 8))
+#define C_OXE_CFG_ARB_LEAF_IN_A_ENTRIES 10
+#define C_OXE_CFG_ARB_LEAF_IN_A(idx) (C_OXE_BASE + C_OXE_CFG_ARB_LEAF_IN_A_OFFSET(idx))
+#define C_OXE_CFG_ARB_LEAF_IN_A_SIZE 0x00000050
+
+union c_oxe_cfg_arb_leaf_in_a {
+	__u64 qw;
+	struct {
+		__u64 fill_qty : 11;
+		__u64: 1;
+		__u64 limit : 18;
+		__u64: 34;
+	};
+};
+
+#define C_OXE_CFG_ARB_LEAF_IN_C_OFFSET(idx) (0x00001a80 + ((idx) * 8))
+#define C_OXE_CFG_ARB_LEAF_IN_C_ENTRIES 10
+#define C_OXE_CFG_ARB_LEAF_IN_C(idx) (C_OXE_BASE + C_OXE_CFG_ARB_LEAF_IN_C_OFFSET(idx))
+#define C_OXE_CFG_ARB_LEAF_IN_C_SIZE 0x00000050
+
+union c_oxe_cfg_arb_leaf_in_c {
+	__u64 qw;
+	struct {
+		__u64 fill_qty : 11;
+		__u64: 1;
+		__u64 limit : 18;
+		__u64 enable : 1;
+		__u64: 33;
+	};
+};
+
+#define C_OXE_CFG_ARB_BRANCH_OFFSET(idx) (0x00001b00 + ((idx) * 8))
+#define C_OXE_CFG_ARB_BRANCH_ENTRIES 5
+#define C_OXE_CFG_ARB_BRANCH(idx) (C_OXE_BASE + C_OXE_CFG_ARB_BRANCH_OFFSET(idx))
+#define C_OXE_CFG_ARB_BRANCH_SIZE 0x00000028
+
+union c_oxe_cfg_arb_branch {
+	__u64 qw;
+	struct {
+		__u64 pri : 3;
+		__u64: 1;
+		__u64 mfs_out_sel : 2;
+		__u64 mfs_in_sel : 2;
+		__u64: 56;
+	};
+};
+
+#define C_OXE_CFG_ARB_BRANCH_OUT_A_OFFSET(idx) (0x00001b40 + ((idx) * 8))
+#define C_OXE_CFG_ARB_BRANCH_OUT_A_ENTRIES 5
+#define C_OXE_CFG_ARB_BRANCH_OUT_A(idx) (C_OXE_BASE + C_OXE_CFG_ARB_BRANCH_OUT_A_OFFSET(idx))
+#define C_OXE_CFG_ARB_BRANCH_OUT_A_SIZE 0x00000028
+
+union c_oxe_cfg_arb_branch_out_a {
+	__u64 qw;
+	struct {
+		__u64 fill_qty : 11;
+		__u64: 1;
+		__u64 limit : 18;
+		__u64: 34;
+	};
+};
+
+#define C_OXE_CFG_ARB_BRANCH_OUT_C_OFFSET(idx) (0x00001b80 + ((idx) * 8))
+#define C_OXE_CFG_ARB_BRANCH_OUT_C_ENTRIES 5
+#define C_OXE_CFG_ARB_BRANCH_OUT_C(idx) (C_OXE_BASE + C_OXE_CFG_ARB_BRANCH_OUT_C_OFFSET(idx))
+#define C_OXE_CFG_ARB_BRANCH_OUT_C_SIZE 0x00000028
+
+union c_oxe_cfg_arb_branch_out_c {
+	__u64 qw;
+	struct {
+		__u64 fill_qty : 11;
+		__u64: 1;
+		__u64 limit : 18;
+		__u64 enable : 1;
+		__u64: 33;
+	};
+};
+
+#define C_OXE_CFG_ARB_BRANCH_IN_A_OFFSET(idx) (0x00001bc0 + ((idx) * 8))
+#define C_OXE_CFG_ARB_BRANCH_IN_A_ENTRIES 5
+#define C_OXE_CFG_ARB_BRANCH_IN_A(idx) (C_OXE_BASE + C_OXE_CFG_ARB_BRANCH_IN_A_OFFSET(idx))
+#define C_OXE_CFG_ARB_BRANCH_IN_A_SIZE 0x00000028
+
+union c_oxe_cfg_arb_branch_in_a {
+	__u64 qw;
+	struct {
+		__u64 fill_qty : 11;
+		__u64: 1;
+		__u64 limit : 18;
+		__u64: 34;
+	};
+};
+
+#define C_OXE_CFG_ARB_BRANCH_IN_C_OFFSET(idx) (0x00001c00 + ((idx) * 8))
+#define C_OXE_CFG_ARB_BRANCH_IN_C_ENTRIES 5
+#define C_OXE_CFG_ARB_BRANCH_IN_C(idx) (C_OXE_BASE + C_OXE_CFG_ARB_BRANCH_IN_C_OFFSET(idx))
+#define C_OXE_CFG_ARB_BRANCH_IN_C_SIZE 0x00000028
+
+union c_oxe_cfg_arb_branch_in_c {
+	__u64 qw;
+	struct {
+		__u64 fill_qty : 11;
+		__u64: 1;
+		__u64 limit : 18;
+		__u64 enable : 1;
+		__u64: 33;
+	};
+};
+
+#define C_OXE_CFG_FGFC_CNT_OFFSET(idx) (0x00001c40 + ((idx) * 8))
+#define C_OXE_CFG_FGFC_CNT_ENTRIES 4
+#define C_OXE_CFG_FGFC_CNT(idx) (C_OXE_BASE + C_OXE_CFG_FGFC_CNT_OFFSET(idx))
+#define C_OXE_CFG_FGFC_CNT_SIZE 0x00000020
+
+union c_oxe_cfg_fgfc_cnt {
+	__u64 qw;
+	struct {
+		__u64 vni_match : 16;
+		__u64 vni_mask : 16;
+		__u64: 32;
+	};
+};
+
+#define C_OXE_STS_COMMON_OFFSET 0x00002000
+#define C_OXE_STS_COMMON (C_OXE_BASE + C_OXE_STS_COMMON_OFFSET)
+#define C_OXE_STS_COMMON_SIZE 0x00000008
+
+union c_oxe_sts_common {
+	__u64 qw;
+	struct {
+		__u64 init_done : 1;
+		__u64: 63;
+	};
+};
+
+#define C_PARBS_CFG_CRNC_OFFSET 0x00000000
+#define C_PARBS_CFG_CRNC (C_PARBS_BASE + C_PARBS_CFG_CRNC_OFFSET)
+#define C_PARBS_CFG_CRNC_SIZE 0x00000008
+
+union c_parbs_cfg_crnc {
+	__u64 qw;
+	struct {
+		__u64 csr_timeout : 8;
+		__u64 mcast_id : 10;
+		__u64: 1;
+		__u64 mcast_enable : 1;
+		__u64 mcast_mask : 10;
+		__u64: 34;
+	};
+};
+
+#define C_PARBS_CFG_RT_OFFSET_OFFSET 0x00000020
+#define C_PARBS_CFG_RT_OFFSET (C_PARBS_BASE + C_PARBS_CFG_RT_OFFSET_OFFSET)
+#define C_PARBS_CFG_RT_OFFSET_SIZE 0x00000008
+
+union c_parbs_cfg_rt_offset {
+	__u64 qw;
+	struct {
+		__u64 seconds : 48;
+		__u64: 16;
+	};
+};
+
+#define C_PARBS_ERR_ELAPSED_TIME_OFFSET 0x00000100
+#define C_PARBS_ERR_ELAPSED_TIME (C_PARBS_BASE + C_PARBS_ERR_ELAPSED_TIME_OFFSET)
+#define C_PARBS_ERR_ELAPSED_TIME_SIZE 0x00000008
+
+union c_parbs_err_elapsed_time {
+	__u64 qw;
+	struct {
+		__u64 nanoseconds : 30;
+		__u64 seconds : 34;
+	};
+};
+
+#define C_PARBS_ERR_FLG_OFFSET 0x00000108
+#define C_PARBS_ERR_FLG (C_PARBS_BASE + C_PARBS_ERR_FLG_OFFSET)
+#define C_PARBS_ERR_FLG_SIZE 0x00000008
+
+union c_parbs_err_flg {
+	__u64 qw;
+	struct {
+		__u64 sw_diag : 1;
+		__u64 crnc_ring_sync_error : 1;
+		__u64 crnc_ring_ecc_sbe : 1;
+		__u64 crnc_ring_ecc_mbe : 1;
+		__u64 crnc_ring_cmd_unknown : 1;
+		__u64 crnc_csr_cmd_unknown : 1;
+		__u64 crnc_csr_cmd_incomplete : 1;
+		__u64 crnc_buf_ecc_sbe : 1;
+		__u64 crnc_buf_ecc_mbe : 1;
+		__u64: 7;
+		__u64 cq_tarb_hdr_cor : 1;
+		__u64 cq_tarb_hdr_ucor : 1;
+		__u64 cq_tarb_data_cor : 1;
+		__u64 cq_tarb_data_ucor : 1;
+		__u64 ee_tarb_hdr_cor : 1;
+		__u64 ee_tarb_hdr_ucor : 1;
+		__u64 ee_tarb_data_cor : 1;
+		__u64 ee_tarb_data_ucor : 1;
+		__u64 ixe_tarb_hdr_cor : 1;
+		__u64 ixe_tarb_hdr_ucor : 1;
+		__u64 ixe_tarb_data_cor : 1;
+		__u64 ixe_tarb_data_ucor : 1;
+		__u64 oxe_tarb_hdr_cor : 1;
+		__u64 oxe_tarb_hdr_ucor : 1;
+		__u64 atu_tarb_hdr_cor : 1;
+		__u64 atu_tarb_hdr_ucor : 1;
+		__u64 atu_tarb_data_cor : 1;
+		__u64 atu_tarb_data_ucor : 1;
+		__u64 tarb_pi_hdr_cor : 1;
+		__u64 tarb_pi_hdr_ucor : 1;
+		__u64 tarb_pi_data_cor : 1;
+		__u64 tarb_pi_data_ucor : 1;
+		__u64 cq_p_fifo_overrun : 1;
+		__u64 cq_p_fifo_underrun : 1;
+		__u64 cq_np_fifo_overrun : 1;
+		__u64 cq_np_fifo_underrun : 1;
+		__u64 ee_p_fifo_overrun : 1;
+		__u64 ee_p_fifo_underrun : 1;
+		__u64 ixe_p_fifo_overrun : 1;
+		__u64 ixe_p_fifo_underrun : 1;
+		__u64 ixe_np_fifo_overrun : 1;
+		__u64 ixe_np_fifo_underrun : 1;
+		__u64 oxe_np_fifo_overrun : 1;
+		__u64 oxe_np_fifo_underrun : 1;
+		__u64 atu_p_fifo_overrun : 1;
+		__u64 atu_p_fifo_underrun : 1;
+		__u64 atu_np_fifo_overrun : 1;
+		__u64 atu_np_fifo_underrun : 1;
+		__u64 ord_p_fifo_overrun : 1;
+		__u64 ord_p_fifo_underrun : 1;
+		__u64 ord_np_fifo_overrun : 1;
+		__u64 ord_np_fifo_underrun : 1;
+		__u64 ord_np_cnt_overrun : 1;
+		__u64 ord_np_cnt_underrun : 1;
+		__u64 tarb_pi_p_cdt_underflow : 1;
+		__u64 tarb_pi_np_cdt_underflow : 1;
+		__u64: 2;
+	};
+};
+
+#define C_PARBS_ERR_FIRST_FLG_OFFSET 0x00000110
+#define C_PARBS_ERR_FIRST_FLG (C_PARBS_BASE + C_PARBS_ERR_FIRST_FLG_OFFSET)
+#define C_PARBS_ERR_FIRST_FLG_SIZE 0x00000008
+#define C_PARBS_ERR_FIRST_FLG_TS_OFFSET 0x00000118
+#define C_PARBS_ERR_FIRST_FLG_TS (C_PARBS_BASE + C_PARBS_ERR_FIRST_FLG_TS_OFFSET)
+#define C_PARBS_ERR_FIRST_FLG_TS_SIZE 0x00000008
+#define C_PARBS_ERR_CLR_OFFSET 0x00000120
+#define C_PARBS_ERR_CLR (C_PARBS_BASE + C_PARBS_ERR_CLR_OFFSET)
+#define C_PARBS_ERR_CLR_SIZE 0x00000008
+#define C_PARBS_ERR_IRQA_MSK_OFFSET 0x00000128
+#define C_PARBS_ERR_IRQA_MSK (C_PARBS_BASE + C_PARBS_ERR_IRQA_MSK_OFFSET)
+#define C_PARBS_ERR_IRQA_MSK_SIZE 0x00000008
+#define C_PARBS_ERR_IRQB_MSK_OFFSET 0x00000130
+#define C_PARBS_ERR_IRQB_MSK (C_PARBS_BASE + C_PARBS_ERR_IRQB_MSK_OFFSET)
+#define C_PARBS_ERR_IRQB_MSK_SIZE 0x00000008
+#define C_PARBS_ERR_INFO_MSK_OFFSET 0x00000140
+#define C_PARBS_ERR_INFO_MSK (C_PARBS_BASE + C_PARBS_ERR_INFO_MSK_OFFSET)
+#define C_PARBS_ERR_INFO_MSK_SIZE 0x00000008
+#define C_PARBS_ERR_INFO_MEM_OFFSET 0x00000180
+#define C_PARBS_ERR_INFO_MEM (C_PARBS_BASE + C_PARBS_ERR_INFO_MEM_OFFSET)
+#define C_PARBS_ERR_INFO_MEM_SIZE 0x00000008
+
+union c_parbs_err_info_mem {
+	__u64 qw;
+	struct {
+		__u64 cor_syndrome : 11;
+		__u64: 1;
+		__u64 cor_address : 11;
+		__u64: 1;
+		__u64 cor_mem_id : 4;
+		__u64: 3;
+		__u64 cor_csr_detected : 1;
+		__u64 ucor_syndrome : 11;
+		__u64: 1;
+		__u64 ucor_address : 11;
+		__u64: 1;
+		__u64 ucor_mem_id : 4;
+		__u64: 3;
+		__u64 ucor_csr_detected : 1;
+	};
+};
+
+#define C_PARBS_EXT_ERR_FLG_OFFSET 0x00000208
+#define C_PARBS_EXT_ERR_FLG (C_PARBS_BASE + C_PARBS_EXT_ERR_FLG_OFFSET)
+#define C_PARBS_EXT_ERR_FLG_SIZE 0x00000008
+
+union c_parbs_ext_err_flg {
+	__u64 qw;
+	struct {
+		__u64 sw_diag : 1;
+		__u64 pi_rarb_hdr_cor : 1;
+		__u64 pi_rarb_hdr_ucor : 1;
+		__u64 pi_rarb_data_cor : 1;
+		__u64 pi_rarb_data_ucor : 1;
+		__u64: 59;
+	};
+};
+
+#define C_PARBS_EXT_ERR_FIRST_FLG_OFFSET 0x00000210
+#define C_PARBS_EXT_ERR_FIRST_FLG (C_PARBS_BASE + C_PARBS_EXT_ERR_FIRST_FLG_OFFSET)
+#define C_PARBS_EXT_ERR_FIRST_FLG_SIZE 0x00000008
+#define C_PARBS_EXT_ERR_FIRST_FLG_TS_OFFSET 0x00000218
+#define C_PARBS_EXT_ERR_FIRST_FLG_TS (C_PARBS_BASE + C_PARBS_EXT_ERR_FIRST_FLG_TS_OFFSET)
+#define C_PARBS_EXT_ERR_FIRST_FLG_TS_SIZE 0x00000008
+#define C_PARBS_EXT_ERR_CLR_OFFSET 0x00000220
+#define C_PARBS_EXT_ERR_CLR (C_PARBS_BASE + C_PARBS_EXT_ERR_CLR_OFFSET)
+#define C_PARBS_EXT_ERR_CLR_SIZE 0x00000008
+#define C_PARBS_EXT_ERR_IRQA_MSK_OFFSET 0x00000228
+#define C_PARBS_EXT_ERR_IRQA_MSK (C_PARBS_BASE + C_PARBS_EXT_ERR_IRQA_MSK_OFFSET)
+#define C_PARBS_EXT_ERR_IRQA_MSK_SIZE 0x00000008
+#define C_PARBS_EXT_ERR_IRQB_MSK_OFFSET 0x00000230
+#define C_PARBS_EXT_ERR_IRQB_MSK (C_PARBS_BASE + C_PARBS_EXT_ERR_IRQB_MSK_OFFSET)
+#define C_PARBS_EXT_ERR_IRQB_MSK_SIZE 0x00000008
+#define C_PARBS_EXT_ERR_INFO_MSK_OFFSET 0x00000240
+#define C_PARBS_EXT_ERR_INFO_MSK (C_PARBS_BASE + C_PARBS_EXT_ERR_INFO_MSK_OFFSET)
+#define C_PARBS_EXT_ERR_INFO_MSK_SIZE 0x00000008
+#define C_PCT_CFG_CRNC_OFFSET 0x00000000
+#define C_PCT_CFG_CRNC (C_PCT_BASE + C_PCT_CFG_CRNC_OFFSET)
+#define C_PCT_CFG_CRNC_SIZE 0x00000008
+
+union c_pct_cfg_crnc {
+	__u64 qw;
+	struct {
+		__u64 csr_timeout : 8;
+		__u64 mcast_id : 10;
+		__u64: 1;
+		__u64 mcast_enable : 1;
+		__u64 mcast_mask : 10;
+		__u64: 34;
+	};
+};
+
+#define C_PCT_MSC_SHADOW_ACTION_OFFSET 0x00000038
+#define C_PCT_MSC_SHADOW_ACTION (C_PCT_BASE + C_PCT_MSC_SHADOW_ACTION_OFFSET)
+#define C_PCT_MSC_SHADOW_ACTION_SIZE 0x00000008
+#define C_PCT_MSC_SHADOW_OFFSET 0x00000040
+#define C_PCT_MSC_SHADOW (C_PCT_BASE + C_PCT_MSC_SHADOW_OFFSET)
+#define C_PCT_MSC_SHADOW_SIZE 0x00000080
+
+union c_pct_msc_shadow {
+	__u64 qw[16];
+};
+
+#define C_PCT_ERR_ELAPSED_TIME_OFFSET 0x00000100
+#define C_PCT_ERR_ELAPSED_TIME (C_PCT_BASE + C_PCT_ERR_ELAPSED_TIME_OFFSET)
+#define C_PCT_ERR_ELAPSED_TIME_SIZE 0x00000008
+
+union c_pct_err_elapsed_time {
+	__u64 qw;
+	struct {
+		__u64 nanoseconds : 30;
+		__u64 seconds : 34;
+	};
+};
+
+#define C1_PCT_ERR_FLG_OFFSET 0x00000108
+#define C1_PCT_ERR_FLG (C_PCT_BASE + C1_PCT_ERR_FLG_OFFSET)
+#define C1_PCT_ERR_FLG_SIZE 0x00000008
+
+union c1_pct_err_flg {
+	__u64 qw;
+	struct {
+		__u64 sw_diag : 1;
+		__u64 crnc_ring_sync_error : 1;
+		__u64 crnc_ring_ecc_sbe : 1;
+		__u64 crnc_ring_ecc_mbe : 1;
+		__u64 crnc_ring_cmd_unknown : 1;
+		__u64 crnc_csr_cmd_unknown : 1;
+		__u64 crnc_csr_cmd_incomplete : 1;
+		__u64 crnc_buf_ecc_sbe : 1;
+		__u64 crnc_buf_ecc_mbe : 1;
+		__u64 srb_alloc_dup : 1;
+		__u64 srb_dealloc_dup : 1;
+		__u64: 1;
+		__u64 flop_fifo_cor : 1;
+		__u64 mst_cam_free_cor : 1;
+		__u64 sct_cam_free_cor : 1;
+		__u64 tct_cam_free_cor : 1;
+		__u64 trs_cam_free_cor : 1;
+		__u64 sct_tbl_cor : 1;
+		__u64 smt_tbl_cor : 1;
+		__u64 spt_tbl_cor : 1;
+		__u64 tct_tbl_cor : 1;
+		__u64 trs_tbl_cor : 1;
+		__u64 req_redo_cor : 1;
+		__u64 cls_clr_req_gen_cor : 1;
+		__u64 srb_nlist_ram_cor : 1;
+		__u64 srb_data_ram_cor : 1;
+		__u64 flop_fifo_ucor : 1;
+		__u64 mst_cam_free_ucor : 1;
+		__u64 sct_cam_free_ucor : 1;
+		__u64 tct_cam_free_ucor : 1;
+		__u64 trs_cam_free_ucor : 1;
+		__u64 sct_tbl_ucor : 1;
+		__u64 smt_tbl_ucor : 1;
+		__u64 spt_tbl_ucor : 1;
+		__u64 tct_tbl_ucor : 1;
+		__u64 trs_tbl_ucor : 1;
+		__u64 req_redo_ucor : 1;
+		__u64 cls_clr_req_gen_ucor : 1;
+		__u64 srb_nlist_ram_ucor : 1;
+		__u64 srb_data_ram_ucor : 1;
+		__u64 mst_cam_ucor : 1;
+		__u64 sct_cam_ucor : 1;
+		__u64 tct_cam_ucor : 1;
+		__u64 trs_cam_ucor : 1;
+		__u64 fifo_err : 1;
+		__u64 credit_uflw : 1;
+		__u64: 18;
+	};
+};
+
+#define C2_PCT_ERR_FLG_OFFSET 0x00000108
+#define C2_PCT_ERR_FLG (C_PCT_BASE + C2_PCT_ERR_FLG_OFFSET)
+#define C2_PCT_ERR_FLG_SIZE 0x00000008
+
+union c2_pct_err_flg {
+	__u64 qw;
+	struct {
+		__u64 sw_diag : 1;
+		__u64 crnc_ring_sync_error : 1;
+		__u64 crnc_ring_ecc_sbe : 1;
+		__u64 crnc_ring_ecc_mbe : 1;
+		__u64 crnc_ring_cmd_unknown : 1;
+		__u64 crnc_csr_cmd_unknown : 1;
+		__u64 crnc_csr_cmd_incomplete : 1;
+		__u64 crnc_buf_ecc_sbe : 1;
+		__u64 crnc_buf_ecc_mbe : 1;
+		__u64 srb_alloc_dup : 1;
+		__u64 srb_dealloc_dup : 1;
+		__u64: 1;
+		__u64 flop_fifo_cor : 1;
+		__u64 mst_cam_free_cor : 1;
+		__u64 sct_cam_free_cor : 1;
+		__u64 tct_cam_free_cor : 1;
+		__u64 trs_cam_free_cor : 1;
+		__u64 sct_tbl_cor : 1;
+		__u64 smt_tbl_cor : 1;
+		__u64 spt_tbl_cor : 1;
+		__u64 tct_tbl_cor : 1;
+		__u64 trs_tbl_cor : 1;
+		__u64 req_redo_cor : 1;
+		__u64 cls_clr_req_gen_cor : 1;
+		__u64 srb_nlist_ram_cor : 1;
+		__u64 srb_data_ram_cor : 1;
+		__u64 cls_rsp_gen_cor : 1;
+		__u64 nack_trs_rsp_gen_cor : 1;
+		__u64 flop_fifo_ucor : 1;
+		__u64 mst_cam_free_ucor : 1;
+		__u64 sct_cam_free_ucor : 1;
+		__u64 tct_cam_free_ucor : 1;
+		__u64 trs_cam_free_ucor : 1;
+		__u64 sct_tbl_ucor : 1;
+		__u64 smt_tbl_ucor : 1;
+		__u64 spt_tbl_ucor : 1;
+		__u64 tct_tbl_ucor : 1;
+		__u64 trs_tbl_ucor : 1;
+		__u64 req_redo_ucor : 1;
+		__u64 cls_clr_req_gen_ucor : 1;
+		__u64 srb_nlist_ram_ucor : 1;
+		__u64 srb_data_ram_ucor : 1;
+		__u64 mst_cam_ucor : 1;
+		__u64 sct_cam_ucor : 1;
+		__u64 tct_cam_ucor : 1;
+		__u64 trs_cam_ucor : 1;
+		__u64 nack_trs_rsp_gen_ucor : 1;
+		__u64 cls_rsp_gen_ucor : 1;
+		__u64 fifo_err : 1;
+		__u64 credit_uflw : 1;
+		__u64: 14;
+	};
+};
+
+#define C_PCT_ERR_FIRST_FLG_OFFSET 0x00000110
+#define C_PCT_ERR_FIRST_FLG (C_PCT_BASE + C_PCT_ERR_FIRST_FLG_OFFSET)
+#define C_PCT_ERR_FIRST_FLG_SIZE 0x00000008
+#define C_PCT_ERR_FIRST_FLG_TS_OFFSET 0x00000118
+#define C_PCT_ERR_FIRST_FLG_TS (C_PCT_BASE + C_PCT_ERR_FIRST_FLG_TS_OFFSET)
+#define C_PCT_ERR_FIRST_FLG_TS_SIZE 0x00000008
+#define C_PCT_ERR_CLR_OFFSET 0x00000120
+#define C_PCT_ERR_CLR (C_PCT_BASE + C_PCT_ERR_CLR_OFFSET)
+#define C_PCT_ERR_CLR_SIZE 0x00000008
+#define C_PCT_ERR_IRQA_MSK_OFFSET 0x00000128
+#define C_PCT_ERR_IRQA_MSK (C_PCT_BASE + C_PCT_ERR_IRQA_MSK_OFFSET)
+#define C_PCT_ERR_IRQA_MSK_SIZE 0x00000008
+#define C_PCT_ERR_IRQB_MSK_OFFSET 0x00000130
+#define C_PCT_ERR_IRQB_MSK (C_PCT_BASE + C_PCT_ERR_IRQB_MSK_OFFSET)
+#define C_PCT_ERR_IRQB_MSK_SIZE 0x00000008
+#define C_PCT_ERR_INFO_MSK_OFFSET 0x00000140
+#define C_PCT_ERR_INFO_MSK (C_PCT_BASE + C_PCT_ERR_INFO_MSK_OFFSET)
+#define C_PCT_ERR_INFO_MSK_SIZE 0x00000008
+#define C_PCT_EXT_ERR_FLG_OFFSET 0x00000148
+#define C_PCT_EXT_ERR_FLG (C_PCT_BASE + C_PCT_EXT_ERR_FLG_OFFSET)
+#define C_PCT_EXT_ERR_FLG_SIZE 0x00000008
+
+union c_pct_ext_err_flg {
+	__u64 qw;
+	struct {
+		__u64 sw_diag : 1;
+		__u64 sct_tbl_dealloc : 1;
+		__u64 sct_tbl_alloc : 1;
+		__u64 sct_tbl_rd_misc_unused : 1;
+		__u64 sct_tbl_wr_misc_unused : 1;
+		__u64 sct_tbl_rd_ram_unused : 1;
+		__u64 sct_tbl_wr_ram_unused : 1;
+		__u64 smt_tbl_dealloc : 1;
+		__u64 smt_tbl_alloc : 1;
+		__u64 smt_tbl_rd_ram_unused : 1;
+		__u64 smt_tbl_wr_ram_unused : 1;
+		__u64 spt_tbl_dealloc : 1;
+		__u64 spt_tbl_alloc : 1;
+		__u64 spt_tbl_rd_misc_unused : 1;
+		__u64 spt_tbl_wr_misc_unused : 1;
+		__u64 spt_tbl_rd_ram_unused : 1;
+		__u64 spt_tbl_wr_ram_unused : 1;
+		__u64 spt_tbl_set_wrong_status : 1;
+		__u64 tct_tbl_dealloc : 1;
+		__u64 tct_tbl_alloc : 1;
+		__u64 tct_tbl_rd_misc_unused : 1;
+		__u64 tct_tbl_rd_ram_unused : 1;
+		__u64 tct_tbl_wr_ram_unused : 1;
+		__u64 trs_tbl_dealloc : 1;
+		__u64 trs_tbl_alloc : 1;
+		__u64 trs_tbl_rd_ram_unused : 1;
+		__u64 trs_tbl_wr_ram_unused : 1;
+		__u64 oxe_sct_miss_on_mid : 1;
+		__u64 oxe_failed_sct_alloc : 1;
+		__u64 oxe_illegal_req : 1;
+		__u64 oxe_new_conn_not_som : 1;
+		__u64 oxe_invalid_smt_not_som : 1;
+		__u64 oxe_illegal_access2_fsm : 1;
+		__u64 oxe_smt_req_cnt_exceed : 1;
+		__u64 oxe_sct_req_cnt_exceed : 1;
+		__u64 ixe_req_tct_not_in_use : 1;
+		__u64 ixe_req_tct_miss_unordered_mid : 1;
+		__u64 ixe_req_mst_missing : 1;
+		__u64 ixe_req_clr_out_of_range : 1;
+		__u64 ixe_rsp_spt_not_in_use : 1;
+		__u64 ixe_rsp_spt_status_not_pend : 1;
+		__u64 ixe_rsp_smt_pend_cnt_exceed : 1;
+		__u64 ixe_rsp_sct_pend_cnt_exceed : 1;
+		__u64 ixe_rsp_smt_invalid : 1;
+		__u64 ixe_rsp_spt_not_get_vld : 1;
+		__u64 ixe_rsp_cls_not_pend : 1;
+		__u64 ixe_gcomp_spt_not_in_use : 1;
+		__u64 ixe_gcomp_not_get_ack_rcvd : 1;
+		__u64 ixe_gcomp_smt_pend_cnt_exceed : 1;
+		__u64 ixe_gcomp_sct_pend_cnt_exceed : 1;
+		__u64 ixe_gcomp_smt_invalid : 1;
+		__u64 ixe_gcomp_spt_not_get_vld : 1;
+		__u64 src_cls_spt_wrong_sct : 1;
+		__u64 src_cls_spt_not_used : 1;
+		__u64 src_cls_spt_not_opcomp : 1;
+		__u64 src_cls_bad_close : 1;
+		__u64 pkto_illegal_req : 1;
+		__u64 pkto_illegal_pkttype : 1;
+		__u64 pkto_head_fsm : 1;
+		__u64 srb_wr_rd_same_cycle : 1;
+		__u64 sct_miss_unrestricted_mid : 1;
+		__u64 mbe_in_ctrls : 1;
+		__u64 sct_cam_err : 1;
+		__u64 mst_cam_err : 1;
+	};
+};
+
+#define C_PCT_EXT_ERR_FIRST_FLG_OFFSET 0x00000150
+#define C_PCT_EXT_ERR_FIRST_FLG (C_PCT_BASE + C_PCT_EXT_ERR_FIRST_FLG_OFFSET)
+#define C_PCT_EXT_ERR_FIRST_FLG_SIZE 0x00000008
+#define C_PCT_EXT_ERR_FIRST_FLG_TS_OFFSET 0x00000158
+#define C_PCT_EXT_ERR_FIRST_FLG_TS (C_PCT_BASE + C_PCT_EXT_ERR_FIRST_FLG_TS_OFFSET)
+#define C_PCT_EXT_ERR_FIRST_FLG_TS_SIZE 0x00000008
+#define C_PCT_EXT_ERR_CLR_OFFSET 0x00000160
+#define C_PCT_EXT_ERR_CLR (C_PCT_BASE + C_PCT_EXT_ERR_CLR_OFFSET)
+#define C_PCT_EXT_ERR_CLR_SIZE 0x00000008
+#define C_PCT_EXT_ERR_IRQA_MSK_OFFSET 0x00000168
+#define C_PCT_EXT_ERR_IRQA_MSK (C_PCT_BASE + C_PCT_EXT_ERR_IRQA_MSK_OFFSET)
+#define C_PCT_EXT_ERR_IRQA_MSK_SIZE 0x00000008
+#define C_PCT_EXT_ERR_IRQB_MSK_OFFSET 0x00000170
+#define C_PCT_EXT_ERR_IRQB_MSK (C_PCT_BASE + C_PCT_EXT_ERR_IRQB_MSK_OFFSET)
+#define C_PCT_EXT_ERR_IRQB_MSK_SIZE 0x00000008
+#define C_PCT_EXT_ERR_INFO_MSK_OFFSET 0x00000180
+#define C_PCT_EXT_ERR_INFO_MSK (C_PCT_BASE + C_PCT_EXT_ERR_INFO_MSK_OFFSET)
+#define C_PCT_EXT_ERR_INFO_MSK_SIZE 0x00000008
+#define C_PCT_ERR_INFO_MEM_OFFSET 0x00000188
+#define C_PCT_ERR_INFO_MEM (C_PCT_BASE + C_PCT_ERR_INFO_MEM_OFFSET)
+#define C_PCT_ERR_INFO_MEM_SIZE 0x00000008
+
+union c_pct_err_info_mem {
+	__u64 qw;
+	struct {
+		__u64 cor_syndrome : 11;
+		__u64 cor_address : 13;
+		__u64 cor_mem_id : 7;
+		__u64 cor_csr_detected : 1;
+		__u64 ucor_syndrome : 11;
+		__u64 ucor_address : 13;
+		__u64 ucor_mem_id : 7;
+		__u64 ucor_csr_detected : 1;
+	};
+};
+
+#define C_PCT_ERR_INFO_FIFO_OFFSET 0x00000190
+#define C_PCT_ERR_INFO_FIFO (C_PCT_BASE + C_PCT_ERR_INFO_FIFO_OFFSET)
+#define C_PCT_ERR_INFO_FIFO_SIZE 0x00000008
+
+union c_pct_err_info_fifo {
+	__u64 qw;
+	struct {
+		__u64 overrun : 1;
+		__u64 underrun : 1;
+		__u64: 6;
+		__u64 fifo_id : 6;
+		__u64: 50;
+	};
+};
+
+#define C_PCT_ERR_INFO_CC_OFFSET 0x00000198
+#define C_PCT_ERR_INFO_CC (C_PCT_BASE + C_PCT_ERR_INFO_CC_OFFSET)
+#define C_PCT_ERR_INFO_CC_SIZE 0x00000008
+
+union c_pct_err_info_cc {
+	__u64 qw;
+	struct {
+		__u64 cc_id : 6;
+		__u64: 2;
+		__u64 sub_id : 3;
+		__u64: 53;
+	};
+};
+
+#define C_PCT_ERR_INFO_EXT_OFFSET 0x000001a0
+#define C_PCT_ERR_INFO_EXT (C_PCT_BASE + C_PCT_ERR_INFO_EXT_OFFSET)
+#define C_PCT_ERR_INFO_EXT_SIZE 0x00000008
+
+union c_pct_err_info_ext {
+	__u64 qw;
+	struct {
+		__u64 sct_wr_err_id : 5;
+		__u64 sct_rd_err_id : 5;
+		__u64: 2;
+		__u64 smt_wr_err_id : 4;
+		__u64 smt_rd_err_id : 4;
+		__u64 spt_wr_err_id : 5;
+		__u64 spt_rd_err_id : 5;
+		__u64: 2;
+		__u64 tct_wr_err_id : 3;
+		__u64 tct_rd_err_id : 3;
+		__u64: 2;
+		__u64 trs_wr_err_id : 3;
+		__u64 trs_rd_err_id : 3;
+		__u64: 2;
+		__u64 mbe_err_id : 5;
+		__u64: 11;
+	};
+};
+
+#define C_PCT_CFG_EQ_RETRY_Q_HANDLE_OFFSET 0x00000300
+#define C_PCT_CFG_EQ_RETRY_Q_HANDLE (C_PCT_BASE + C_PCT_CFG_EQ_RETRY_Q_HANDLE_OFFSET)
+#define C_PCT_CFG_EQ_RETRY_Q_HANDLE_SIZE 0x00000008
+
+union c_pct_cfg_eq_retry_q_handle {
+	__u64 qw;
+	struct {
+		__u64 eq_handle : 11;
+		__u64: 53;
+	};
+};
+
+#define C_PCT_CFG_EQ_TGT_Q_HANDLE_OFFSET 0x00000308
+#define C_PCT_CFG_EQ_TGT_Q_HANDLE (C_PCT_BASE + C_PCT_CFG_EQ_TGT_Q_HANDLE_OFFSET)
+#define C_PCT_CFG_EQ_TGT_Q_HANDLE_SIZE 0x00000008
+
+union c_pct_cfg_eq_tgt_q_handle {
+	__u64 qw;
+	struct {
+		__u64 eq_handle : 11;
+		__u64: 53;
+	};
+};
+
+#define C_PCT_CFG_EQ_CONN_LD_Q_HANDLE_OFFSET 0x00000310
+#define C_PCT_CFG_EQ_CONN_LD_Q_HANDLE (C_PCT_BASE + C_PCT_CFG_EQ_CONN_LD_Q_HANDLE_OFFSET)
+#define C_PCT_CFG_EQ_CONN_LD_Q_HANDLE_SIZE 0x00000008
+
+union c_pct_cfg_eq_conn_ld_q_handle {
+	__u64 qw;
+	struct {
+		__u64 eq_handle : 11;
+		__u64: 53;
+	};
+};
+
+#define C_PCT_CFG_SRB_RETRY_PTRS_OFFSET(idx) (0x000003e0 + ((idx) * 8))
+#define C_PCT_CFG_SRB_RETRY_PTRS_ENTRIES 4
+#define C_PCT_CFG_SRB_RETRY_PTRS(idx) (C_PCT_BASE + C_PCT_CFG_SRB_RETRY_PTRS_OFFSET(idx))
+#define C_PCT_CFG_SRB_RETRY_PTRS_SIZE 0x00000020
+
+struct c_pct_cfg_srb_retry_ptrs_entry {
+	__u32 ptr : 11;
+	__u32: 1;
+	__u32 vld : 1;
+	__u32: 3;
+	__u32 spt_idx : 11;
+	__u32: 1;
+	__u32 try_num : 3;
+	__u32: 1;
+};
+
+union c_pct_cfg_srb_retry_ptrs {
+	__u64 qw;
+	struct c_pct_cfg_srb_retry_ptrs_entry e[2];
+};
+
+#define C_PCT_CFG_SRB_RETRY_CTRL_OFFSET 0x00000400
+#define C_PCT_CFG_SRB_RETRY_CTRL (C_PCT_BASE + C_PCT_CFG_SRB_RETRY_CTRL_OFFSET)
+#define C_PCT_CFG_SRB_RETRY_CTRL_SIZE 0x00000008
+
+union c_pct_cfg_srb_retry_ctrl {
+	__u64 qw;
+	struct {
+		__u64 pcp_pause_st : 8;
+		__u64 current_ptr : 3;
+		__u64: 5;
+		__u64 grp_nxt : 1;
+		__u64: 7;
+		__u64 error : 1;
+		__u64: 3;
+		__u64 sw_abort : 1;
+		__u64: 3;
+		__u64 hw_sw_sync : 1;
+		__u64: 3;
+		__u64 pause_mode : 1;
+		__u64: 27;
+	};
+};
+
+#define C1_PCT_CFG_SRB_RETRY_GRP_CTRL_OFFSET(idx) (0x00000408 + ((idx) * 8))
+#define C1_PCT_CFG_SRB_RETRY_GRP_CTRL_ENTRIES 2
+#define C1_PCT_CFG_SRB_RETRY_GRP_CTRL(idx) (C_PCT_BASE + C1_PCT_CFG_SRB_RETRY_GRP_CTRL_OFFSET(idx))
+#define C1_PCT_CFG_SRB_RETRY_GRP_CTRL_SIZE 0x00000010
+
+union c1_pct_cfg_srb_retry_grp_ctrl {
+	__u64 qw;
+	struct {
+		__u64 grp_loaded : 1;
+		__u64 grp_active : 1;
+		__u64 grp_paused : 1;
+		__u64 grp_sct_idx_vld : 1;
+		__u64 grp_sct_idx : 12;
+		__u64 grp_pcp : 3;
+		__u64: 5;
+		__u64 grp_unset_clr_seqnum : 1;
+		__u64: 39;
+	};
+};
+
+#define C2_PCT_CFG_SRB_RETRY_GRP_CTRL_OFFSET(idx) (0x00000408 + ((idx) * 8))
+#define C2_PCT_CFG_SRB_RETRY_GRP_CTRL_ENTRIES 2
+#define C2_PCT_CFG_SRB_RETRY_GRP_CTRL(idx) (C_PCT_BASE + C2_PCT_CFG_SRB_RETRY_GRP_CTRL_OFFSET(idx))
+#define C2_PCT_CFG_SRB_RETRY_GRP_CTRL_SIZE 0x00000010
+
+union c2_pct_cfg_srb_retry_grp_ctrl {
+	__u64 qw;
+	struct {
+		__u64 grp_loaded : 1;
+		__u64 grp_active : 1;
+		__u64 grp_paused : 1;
+		__u64 grp_sct_idx_vld : 1;
+		__u64 grp_sct_idx : 12;
+		__u64 grp_pcp : 3;
+		__u64: 5;
+		__u64 grp_update_clr_seqnum_en : 1;
+		__u64 grp_update_clr_seqnum : 12;
+		__u64: 27;
+	};
+};
+
+#define C_PCT_CFG_PKT_MISC_OFFSET 0x00000430
+#define C_PCT_CFG_PKT_MISC (C_PCT_BASE + C_PCT_CFG_PKT_MISC_OFFSET)
+#define C_PCT_CFG_PKT_MISC_SIZE 0x00000008
+
+union c_pct_cfg_pkt_misc {
+	__u64 qw;
+	struct {
+		__u64 sm_fab_hdr : 4;
+		__u64: 4;
+		__u64 ptl_proto : 8;
+		__u64 pktid_4000 : 1;
+		__u64: 7;
+		__u64 simple_mode : 1;
+		__u64: 3;
+		__u64 trs_pend_rsp_nack_disable : 1;
+		__u64: 15;
+		__u64 sfa_nid : 20;
+	};
+};
+
+#define C_PCT_CFG_TIMING_OFFSET 0x00000440
+#define C_PCT_CFG_TIMING (C_PCT_BASE + C_PCT_CFG_TIMING_OFFSET)
+#define C_PCT_CFG_TIMING_SIZE 0x00000008
+
+union c_pct_cfg_timing {
+	__u64 qw;
+	struct {
+		__u64 stall_ctr : 5;
+		__u64: 3;
+		__u64 spt_timeout_epoch_sel : 6;
+		__u64: 2;
+		__u64 sct_idle_epoch_sel : 6;
+		__u64: 2;
+		__u64 sct_close_epoch_sel : 6;
+		__u64: 2;
+		__u64 tct_timeout_epoch_sel : 6;
+		__u64: 2;
+		__u64 put_get_same_sct_en : 1;
+		__u64: 7;
+		__u64 accept_late_spt_rsp : 1;
+		__u64: 15;
+	};
+};
+
+#define C1_PCT_CFG_IXE_REQ_FIFO_LIMITS_OFFSET 0x00000508
+#define C1_PCT_CFG_IXE_REQ_FIFO_LIMITS (C_PCT_BASE + C1_PCT_CFG_IXE_REQ_FIFO_LIMITS_OFFSET)
+#define C1_PCT_CFG_IXE_REQ_FIFO_LIMITS_SIZE 0x00000008
+
+union c1_pct_cfg_ixe_req_fifo_limits {
+	__u64 qw;
+	struct {
+		__u64 ixe_req_clr_limit : 6;
+		__u64: 2;
+		__u64 ixe_req_clr1_limit : 3;
+		__u64: 5;
+		__u64 ixe_req_clr2_limit : 3;
+		__u64: 5;
+		__u64 ixe_req_rsp_limit : 5;
+		__u64: 35;
+	};
+};
+
+#define C2_PCT_CFG_IXE_REQ_FIFO_LIMITS_OFFSET 0x00000508
+#define C2_PCT_CFG_IXE_REQ_FIFO_LIMITS (C_PCT_BASE + C2_PCT_CFG_IXE_REQ_FIFO_LIMITS_OFFSET)
+#define C2_PCT_CFG_IXE_REQ_FIFO_LIMITS_SIZE 0x00000008
+
+union c2_pct_cfg_ixe_req_fifo_limits {
+	__u64 qw;
+	struct {
+		__u64 ixe_req_clr_limit : 6;
+		__u64: 2;
+		__u64 ixe_req_clr1_limit : 3;
+		__u64: 5;
+		__u64 ixe_req_clr2_limit : 3;
+		__u64: 5;
+		__u64 nack_trs_rsp_limit : 4;
+		__u64: 36;
+	};
+};
+
+#define C_PCT_CFG_IXE_RSP_FIFO_LIMITS_OFFSET 0x00000528
+#define C_PCT_CFG_IXE_RSP_FIFO_LIMITS (C_PCT_BASE + C_PCT_CFG_IXE_RSP_FIFO_LIMITS_OFFSET)
+#define C_PCT_CFG_IXE_RSP_FIFO_LIMITS_SIZE 0x00000008
+
+union c_pct_cfg_ixe_rsp_fifo_limits {
+	__u64 qw;
+	struct {
+		__u64 clr_limit : 4;
+		__u64 ee_limit : 5;
+		__u64: 3;
+		__u64 cq_limit : 5;
+		__u64: 3;
+		__u64 srb_dealloc_limit : 5;
+		__u64: 3;
+		__u64 smt_cdt_ack_limit : 4;
+		__u64 spt_cdt_ack_limit : 4;
+		__u64 sct_cdt_ack_limit : 4;
+		__u64: 24;
+	};
+};
+
+#define C_PCT_CFG_TGT_CLR_REQ_FIFO_LIMIT_OFFSET 0x00000538
+#define C_PCT_CFG_TGT_CLR_REQ_FIFO_LIMIT (C_PCT_BASE + C_PCT_CFG_TGT_CLR_REQ_FIFO_LIMIT_OFFSET)
+#define C_PCT_CFG_TGT_CLR_REQ_FIFO_LIMIT_SIZE 0x00000008
+
+union c_pct_cfg_tgt_clr_req_fifo_limit {
+	__u64 qw;
+	struct {
+		__u64 tgt_clr_req_limit : 6;
+		__u64: 2;
+		__u64 mst_dealloc_fifo_limit : 4;
+		__u64: 52;
+	};
+};
+
+#define C1_PCT_CFG_TRS_TC_DED_LIMIT_OFFSET(idx) (0x00000600 + ((idx) * 8))
+#define C1_PCT_CFG_TRS_TC_DED_LIMIT_ENTRIES 8
+#define C1_PCT_CFG_TRS_TC_DED_LIMIT(idx) (C_PCT_BASE + C1_PCT_CFG_TRS_TC_DED_LIMIT_OFFSET(idx))
+#define C1_PCT_CFG_TRS_TC_DED_LIMIT_SIZE 0x00000040
+
+union c1_pct_cfg_trs_tc_ded_limit {
+	__u64 qw;
+	struct {
+		__u64 ded_limit : 12;
+		__u64: 52;
+	};
+};
+
+#define C2_PCT_CFG_TRS_TC_DED_LIMIT_OFFSET(idx) (0x00000600 + ((idx) * 8))
+#define C2_PCT_CFG_TRS_TC_DED_LIMIT_ENTRIES 8
+#define C2_PCT_CFG_TRS_TC_DED_LIMIT(idx) (C_PCT_BASE + C2_PCT_CFG_TRS_TC_DED_LIMIT_OFFSET(idx))
+#define C2_PCT_CFG_TRS_TC_DED_LIMIT_SIZE 0x00000040
+
+union c2_pct_cfg_trs_tc_ded_limit {
+	__u64 qw;
+	struct {
+		__u64 ded_limit : 14;
+		__u64: 50;
+	};
+};
+
+#define C1_PCT_CFG_TRS_TC_MAX_LIMIT_OFFSET(idx) (0x00000640 + ((idx) * 8))
+#define C1_PCT_CFG_TRS_TC_MAX_LIMIT_ENTRIES 8
+#define C1_PCT_CFG_TRS_TC_MAX_LIMIT(idx) (C_PCT_BASE + C1_PCT_CFG_TRS_TC_MAX_LIMIT_OFFSET(idx))
+#define C1_PCT_CFG_TRS_TC_MAX_LIMIT_SIZE 0x00000040
+
+union c1_pct_cfg_trs_tc_max_limit {
+	__u64 qw;
+	struct {
+		__u64 max_limit : 12;
+		__u64: 52;
+	};
+};
+
+#define C2_PCT_CFG_TRS_TC_MAX_LIMIT_OFFSET(idx) (0x00000640 + ((idx) * 8))
+#define C2_PCT_CFG_TRS_TC_MAX_LIMIT_ENTRIES 8
+#define C2_PCT_CFG_TRS_TC_MAX_LIMIT(idx) (C_PCT_BASE + C2_PCT_CFG_TRS_TC_MAX_LIMIT_OFFSET(idx))
+#define C2_PCT_CFG_TRS_TC_MAX_LIMIT_SIZE 0x00000040
+
+union c2_pct_cfg_trs_tc_max_limit {
+	__u64 qw;
+	struct {
+		__u64 max_limit : 14;
+		__u64: 50;
+	};
+};
+
+#define C1_PCT_CFG_TRS_CRDT_LIMITS_OFFSET 0x00000680
+#define C1_PCT_CFG_TRS_CRDT_LIMITS (C_PCT_BASE + C1_PCT_CFG_TRS_CRDT_LIMITS_OFFSET)
+#define C1_PCT_CFG_TRS_CRDT_LIMITS_SIZE 0x00000008
+
+union c1_pct_cfg_trs_crdt_limits {
+	__u64 qw;
+	struct {
+		__u64 total_limit : 12;
+		__u64: 4;
+		__u64 shared_limit : 12;
+		__u64: 36;
+	};
+};
+
+#define C2_PCT_CFG_TRS_CRDT_LIMITS_OFFSET 0x00000680
+#define C2_PCT_CFG_TRS_CRDT_LIMITS (C_PCT_BASE + C2_PCT_CFG_TRS_CRDT_LIMITS_OFFSET)
+#define C2_PCT_CFG_TRS_CRDT_LIMITS_SIZE 0x00000008
+
+union c2_pct_cfg_trs_crdt_limits {
+	__u64 qw;
+	struct {
+		__u64 total_limit : 14;
+		__u64: 2;
+		__u64 shared_limit : 14;
+		__u64: 34;
+	};
+};
+
+#define C_PCT_CFG_MST_TC_DED_LIMIT_OFFSET(idx) (0x00000690 + ((idx) * 8))
+#define C_PCT_CFG_MST_TC_DED_LIMIT_ENTRIES 8
+#define C_PCT_CFG_MST_TC_DED_LIMIT(idx) (C_PCT_BASE + C_PCT_CFG_MST_TC_DED_LIMIT_OFFSET(idx))
+#define C_PCT_CFG_MST_TC_DED_LIMIT_SIZE 0x00000040
+
+union c_pct_cfg_mst_tc_ded_limit {
+	__u64 qw;
+	struct {
+		__u64 ded_limit : 12;
+		__u64: 52;
+	};
+};
+
+#define C_PCT_CFG_MST_TC_MAX_LIMIT_OFFSET(idx) (0x000006d0 + ((idx) * 8))
+#define C_PCT_CFG_MST_TC_MAX_LIMIT_ENTRIES 8
+#define C_PCT_CFG_MST_TC_MAX_LIMIT(idx) (C_PCT_BASE + C_PCT_CFG_MST_TC_MAX_LIMIT_OFFSET(idx))
+#define C_PCT_CFG_MST_TC_MAX_LIMIT_SIZE 0x00000040
+
+union c_pct_cfg_mst_tc_max_limit {
+	__u64 qw;
+	struct {
+		__u64 max_limit : 12;
+		__u64: 52;
+	};
+};
+
+#define C_PCT_CFG_MST_CRDT_LIMITS_OFFSET 0x00000710
+#define C_PCT_CFG_MST_CRDT_LIMITS (C_PCT_BASE + C_PCT_CFG_MST_CRDT_LIMITS_OFFSET)
+#define C_PCT_CFG_MST_CRDT_LIMITS_SIZE 0x00000008
+
+union c_pct_cfg_mst_crdt_limits {
+	__u64 qw;
+	struct {
+		__u64 total_limit : 12;
+		__u64: 4;
+		__u64 shared_limit : 12;
+		__u64: 36;
+	};
+};
+
+#define C_PCT_CFG_TCT_TC_DED_LIMIT_OFFSET(idx) (0x00000720 + ((idx) * 8))
+#define C_PCT_CFG_TCT_TC_DED_LIMIT_ENTRIES 8
+#define C_PCT_CFG_TCT_TC_DED_LIMIT(idx) (C_PCT_BASE + C_PCT_CFG_TCT_TC_DED_LIMIT_OFFSET(idx))
+#define C_PCT_CFG_TCT_TC_DED_LIMIT_SIZE 0x00000040
+
+union c_pct_cfg_tct_tc_ded_limit {
+	__u64 qw;
+	struct {
+		__u64 ded_limit : 14;
+		__u64: 50;
+	};
+};
+
+#define C_PCT_CFG_TCT_TC_MAX_LIMIT_OFFSET(idx) (0x00000760 + ((idx) * 8))
+#define C_PCT_CFG_TCT_TC_MAX_LIMIT_ENTRIES 8
+#define C_PCT_CFG_TCT_TC_MAX_LIMIT(idx) (C_PCT_BASE + C_PCT_CFG_TCT_TC_MAX_LIMIT_OFFSET(idx))
+#define C_PCT_CFG_TCT_TC_MAX_LIMIT_SIZE 0x00000040
+
+union c_pct_cfg_tct_tc_max_limit {
+	__u64 qw;
+	struct {
+		__u64 max_limit : 14;
+		__u64: 50;
+	};
+};
+
+#define C_PCT_CFG_TCT_CRDT_LIMITS_OFFSET 0x000007a0
+#define C_PCT_CFG_TCT_CRDT_LIMITS (C_PCT_BASE + C_PCT_CFG_TCT_CRDT_LIMITS_OFFSET)
+#define C_PCT_CFG_TCT_CRDT_LIMITS_SIZE 0x00000008
+
+union c_pct_cfg_tct_crdt_limits {
+	__u64 qw;
+	struct {
+		__u64 total_limit : 14;
+		__u64: 2;
+		__u64 shared_limit : 14;
+		__u64: 34;
+	};
+};
+
+#define C_PCT_CFG_RSP_DSCP_REQ_TC_MAP_OFFSET(idx) (0x00000800 + ((idx) * 8))
+#define C_PCT_CFG_RSP_DSCP_REQ_TC_MAP_ENTRIES 4
+#define C_PCT_CFG_RSP_DSCP_REQ_TC_MAP(idx) (C_PCT_BASE + C_PCT_CFG_RSP_DSCP_REQ_TC_MAP_OFFSET(idx))
+#define C_PCT_CFG_RSP_DSCP_REQ_TC_MAP_SIZE 0x00000020
+
+union c_pct_cfg_rsp_dscp_req_tc_map {
+	__u64 qw;
+	struct {
+		__u64 dscp0_tc : 3;
+		__u64: 1;
+		__u64 dscp1_tc : 3;
+		__u64: 1;
+		__u64 dscp2_tc : 3;
+		__u64: 1;
+		__u64 dscp3_tc : 3;
+		__u64: 1;
+		__u64 dscp4_tc : 3;
+		__u64: 1;
+		__u64 dscp5_tc : 3;
+		__u64: 1;
+		__u64 dscp6_tc : 3;
+		__u64: 1;
+		__u64 dscp7_tc : 3;
+		__u64: 1;
+		__u64 dscp8_tc : 3;
+		__u64: 1;
+		__u64 dscp9_tc : 3;
+		__u64: 1;
+		__u64 dscp10_tc : 3;
+		__u64: 1;
+		__u64 dscp11_tc : 3;
+		__u64: 1;
+		__u64 dscp12_tc : 3;
+		__u64: 1;
+		__u64 dscp13_tc : 3;
+		__u64: 1;
+		__u64 dscp14_tc : 3;
+		__u64: 1;
+		__u64 dscp15_tc : 3;
+		__u64: 1;
+	};
+};
+
+#define C_PCT_CFG_REQ_DSCP_RSP_DSCP_MAP_OFFSET(idx) (0x00000820 + ((idx) * 8))
+#define C_PCT_CFG_REQ_DSCP_RSP_DSCP_MAP_ENTRIES 8
+#define C_PCT_CFG_REQ_DSCP_RSP_DSCP_MAP(idx)                                                       \
+	(C_PCT_BASE + C_PCT_CFG_REQ_DSCP_RSP_DSCP_MAP_OFFSET(idx))
+#define C_PCT_CFG_REQ_DSCP_RSP_DSCP_MAP_SIZE 0x00000040
+
+struct c_rsp_dscp {
+	__u8 rsp_dscp : 6;
+	__u8: 2;
+};
+
+#define C_PCT_CFG_REQ_DSCP_RSP_DSCP_MAP_ARRAY_SIZE 8
+union c_pct_cfg_req_dscp_rsp_dscp_map {
+	__u64 qw;
+	struct c_rsp_dscp map[C_PCT_CFG_REQ_DSCP_RSP_DSCP_MAP_ARRAY_SIZE];
+};
+
+#define C_PCT_CFG_REQ_TC_RSP_TC_MAP_OFFSET 0x00000860
+#define C_PCT_CFG_REQ_TC_RSP_TC_MAP (C_PCT_BASE + C_PCT_CFG_REQ_TC_RSP_TC_MAP_OFFSET)
+#define C_PCT_CFG_REQ_TC_RSP_TC_MAP_SIZE 0x00000008
+
+union c_pct_cfg_req_tc_rsp_tc_map {
+	__u64 qw;
+	struct {
+		__u64 req_tc0 : 3;
+		__u64: 1;
+		__u64 req_tc1 : 3;
+		__u64: 1;
+		__u64 req_tc2 : 3;
+		__u64: 1;
+		__u64 req_tc3 : 3;
+		__u64: 1;
+		__u64 req_tc4 : 3;
+		__u64: 1;
+		__u64 req_tc5 : 3;
+		__u64: 1;
+		__u64 req_tc6 : 3;
+		__u64: 1;
+		__u64 req_tc7 : 3;
+		__u64: 33;
+	};
+};
+
+#define C_PCT_CFG_SCT_TAG_DFA_MASK_OFFSET(idx) (0x00000878 + ((idx) * 8))
+#define C_PCT_CFG_SCT_TAG_DFA_MASK_ENTRIES 16
+#define C_PCT_CFG_SCT_TAG_DFA_MASK(idx) (C_PCT_BASE + C_PCT_CFG_SCT_TAG_DFA_MASK_OFFSET(idx))
+#define C_PCT_CFG_SCT_TAG_DFA_MASK_SIZE 0x00000080
+
+union c_pct_cfg_sct_tag_dfa_mask {
+	__u64 qw;
+	struct {
+		__u16 dfa_mask : 12;
+		__u16: 4;
+	} dscp[4];
+};
+
+#define C_PCT_CFG_SW_RECYCLE_SPT_OFFSET 0x00000908
+#define C_PCT_CFG_SW_RECYCLE_SPT (C_PCT_BASE + C_PCT_CFG_SW_RECYCLE_SPT_OFFSET)
+#define C_PCT_CFG_SW_RECYCLE_SPT_SIZE 0x00000008
+
+union c_pct_cfg_sw_recycle_spt {
+	__u64 qw;
+	struct {
+		__u64 spt_idx : 11;
+		__u64: 5;
+		__u64 bc : 4;
+		__u64: 44;
+	};
+};
+
+#define C_PCT_CFG_SW_RECYCLE_SCT_OFFSET 0x00000910
+#define C_PCT_CFG_SW_RECYCLE_SCT (C_PCT_BASE + C_PCT_CFG_SW_RECYCLE_SCT_OFFSET)
+#define C_PCT_CFG_SW_RECYCLE_SCT_SIZE 0x00000008
+
+union c_pct_cfg_sw_recycle_sct {
+	__u64 qw;
+	struct {
+		__u64 sct_idx : 12;
+		__u64: 4;
+		__u64 bc : 4;
+		__u64: 44;
+	};
+};
+
+#define C_PCT_CFG_SW_SIM_SRC_RSP_OFFSET 0x00000918
+#define C_PCT_CFG_SW_SIM_SRC_RSP (C_PCT_BASE + C_PCT_CFG_SW_SIM_SRC_RSP_OFFSET)
+#define C_PCT_CFG_SW_SIM_SRC_RSP_SIZE 0x00000008
+
+union c_pct_cfg_sw_sim_src_rsp {
+	__u64 qw;
+	struct {
+		__u64 spt_sct_idx : 12;
+		__u64: 12;
+		__u64 return_code : 6;
+		__u64: 2;
+		__u64 opcode : 4;
+		__u64: 4;
+		__u64 rsp_not_gcomp : 1;
+		__u64: 7;
+		__u64 loaded : 1;
+		__u64: 15;
+	};
+};
+
+#define C_PCT_CFG_SW_RETRY_SRC_CLS_REQ_OFFSET 0x00000920
+#define C_PCT_CFG_SW_RETRY_SRC_CLS_REQ (C_PCT_BASE + C_PCT_CFG_SW_RETRY_SRC_CLS_REQ_OFFSET)
+#define C_PCT_CFG_SW_RETRY_SRC_CLS_REQ_SIZE 0x00000008
+
+union c_pct_cfg_sw_retry_src_cls_req {
+	__u64 qw;
+	struct {
+		__u64 sct_idx : 12;
+		__u64: 3;
+		__u64 close_not_clear : 1;
+		__u64 loaded : 1;
+		__u64: 47;
+	};
+};
+
+#define C_PCT_CFG_SW_SIM_TGT_CLS_REQ_OFFSET 0x00000928
+#define C_PCT_CFG_SW_SIM_TGT_CLS_REQ (C_PCT_BASE + C_PCT_CFG_SW_SIM_TGT_CLS_REQ_OFFSET)
+#define C_PCT_CFG_SW_SIM_TGT_CLS_REQ_SIZE 0x00000008
+
+union c_pct_cfg_sw_sim_tgt_cls_req {
+	__u64 qw;
+	struct {
+		__u64 tct_idx : 13;
+		__u64: 3;
+		__u64 loaded : 1;
+		__u64: 47;
+	};
+};
+
+#define C_PCT_CFG_SCT_RAM0_OFFSET(idx) (0x00028000 + ((idx) * 8))
+#define C_PCT_CFG_SCT_RAM0_ENTRIES 4096
+#define C_PCT_CFG_SCT_RAM0(idx) (C_PCT_BASE + C_PCT_CFG_SCT_RAM0_OFFSET(idx))
+#define C_PCT_CFG_SCT_RAM0_SIZE 0x00008000
+
+union c_pct_cfg_sct_ram0 {
+	__u64 qw;
+	struct {
+		__u64 clr_tail : 11;
+		__u64: 5;
+		__u64 req_pend_cnt : 11;
+		__u64: 37;
+	};
+};
+
+#define C_PCT_CFG_SCT_RAM1_OFFSET(idx) (0x00030000 + ((idx) * 8))
+#define C_PCT_CFG_SCT_RAM1_ENTRIES 4096
+#define C_PCT_CFG_SCT_RAM1(idx) (C_PCT_BASE + C_PCT_CFG_SCT_RAM1_OFFSET(idx))
+#define C_PCT_CFG_SCT_RAM1_SIZE 0x00008000
+
+union c_pct_cfg_sct_ram1 {
+	__u64 qw;
+	struct {
+		__u64 put_comp_cnt : 11;
+		__u64: 5;
+		__u64 mcu : 7;
+		__u64: 1;
+		__u64 pcp : 3;
+		__u64: 1;
+		__u64 bc : 4;
+		__u64: 8;
+		__u64 sw_recycle : 1;
+		__u64: 23;
+	};
+};
+
+#define C_PCT_CFG_SCT_RAM2_OFFSET(idx) (0x00040000 + ((idx) * 8))
+#define C_PCT_CFG_SCT_RAM2_ENTRIES 4096
+#define C_PCT_CFG_SCT_RAM2(idx) (C_PCT_BASE + C_PCT_CFG_SCT_RAM2_OFFSET(idx))
+#define C_PCT_CFG_SCT_RAM2_SIZE 0x00008000
+
+union c_pct_cfg_sct_ram2 {
+	__u64 qw;
+	struct {
+		__u64: 16;
+		__u64 clr_head : 11;
+		__u64: 5;
+		__u64 req_seqno : 12;
+		__u64: 20;
+	};
+};
+
+#define C_PCT_CFG_SCT_RAM3_OFFSET(idx) (0x00050000 + ((idx) * 8))
+#define C_PCT_CFG_SCT_RAM3_ENTRIES 4096
+#define C_PCT_CFG_SCT_RAM3(idx) (C_PCT_BASE + C_PCT_CFG_SCT_RAM3_OFFSET(idx))
+#define C_PCT_CFG_SCT_RAM3_SIZE 0x00008000
+
+union c_pct_cfg_sct_ram3 {
+	__u64 qw;
+	struct {
+		__u64 close_try : 3;
+		__u64 hw_clr_cls_dis : 1;
+		__u64: 60;
+	};
+};
+
+#define C_PCT_CFG_SCT_RAM4_OFFSET(idx) (0x00060000 + ((idx) * 8))
+#define C_PCT_CFG_SCT_RAM4_ENTRIES 4096
+#define C_PCT_CFG_SCT_RAM4(idx) (C_PCT_BASE + C_PCT_CFG_SCT_RAM4_OFFSET(idx))
+#define C_PCT_CFG_SCT_RAM4_SIZE 0x00008000
+
+union c_pct_cfg_sct_ram4 {
+	__u64 qw;
+	struct {
+		__u64 get_comp_cnt : 11;
+		__u64: 53;
+	};
+};
+
+#define C_PCT_CFG_SCT_CAM_OFFSET(idx) (0x00070000 + ((idx) * 8))
+#define C_PCT_CFG_SCT_CAM_ENTRIES 4096
+#define C_PCT_CFG_SCT_CAM(idx) (C_PCT_BASE + C_PCT_CFG_SCT_CAM_OFFSET(idx))
+#define C_PCT_CFG_SCT_CAM_SIZE 0x00008000
+
+union c_pct_cfg_sct_cam {
+	__u64 qw;
+	struct {
+		__u64 dfa : 32;
+		__u64 vni : 16;
+		__u64 mcu_group : 2;
+		__u64: 2;
+		__u64 dscp : 6;
+		__u64: 2;
+		__u64 vld : 1;
+		__u64: 3;
+	};
+};
+
+#define C_PCT_CFG_SMT_RAM0_OFFSET(idx) (0x00080000 + ((idx) * 8))
+#define C_PCT_CFG_SMT_RAM0_ENTRIES 256
+#define C_PCT_CFG_SMT_RAM0(idx) (C_PCT_BASE + C_PCT_CFG_SMT_RAM0_OFFSET(idx))
+#define C_PCT_CFG_SMT_RAM0_SIZE 0x00000800
+
+union c_pct_cfg_smt_ram0 {
+	__u64 qw;
+	struct {
+		__u64 sw_retry : 1;
+		__u64 return_code : 6;
+		__u64 tgt_error : 1;
+		__u64 req_comp_cnt : 11;
+		__u64: 5;
+		__u64 mcu : 7;
+		__u64: 1;
+		__u64 bc : 4;
+		__u64: 4;
+		__u64 unrestricted : 1;
+		__u64: 23;
+	};
+};
+
+#define C_PCT_CFG_SMT_RAM1_OFFSET(idx) (0x00088000 + ((idx) * 8))
+#define C_PCT_CFG_SMT_RAM1_ENTRIES 256
+#define C_PCT_CFG_SMT_RAM1(idx) (C_PCT_BASE + C_PCT_CFG_SMT_RAM1_OFFSET(idx))
+#define C_PCT_CFG_SMT_RAM1_SIZE 0x00000800
+
+union c_pct_cfg_smt_ram1 {
+	__u64 qw;
+	struct {
+		__u64 last_req : 1;
+		__u64 req_pend_cnt : 11;
+		__u64: 52;
+	};
+};
+
+#define C_PCT_CFG_SPT_RAM0_OFFSET(idx) (0x000a0000 + ((idx) * 64))
+#define C_PCT_CFG_SPT_RAM0_ENTRIES 2048
+#define C_PCT_CFG_SPT_RAM0(idx) (C_PCT_BASE + C_PCT_CFG_SPT_RAM0_OFFSET(idx))
+#define C_PCT_CFG_SPT_RAM0_SIZE 0x00020000
+
+union c_pct_cfg_spt_ram0 {
+	__u64 qw[6];
+	struct {
+		__u64 sw_recycle : 1;
+		__u64 hrp : 1;
+		__u64 req_mp : 1;
+		__u64 req_order : 1;
+		__u64 eom : 1;
+		__u64: 3;
+		__u64 event_send_disable : 1;
+		__u64 event_success_disable : 1;
+		__u64 event_ct_send : 1;
+		__u64 event_ct_reply : 1;
+		__u64 event_ct_ack : 1;
+		__u64 event_ct_bytes : 1;
+		__u64 lpe_gen_rndzvs_get : 1;
+		__u64: 1;
+		__u64 mlength : 32;
+		__u64 ptl_list : 2;
+		__u64: 14;
+		__u64 comp_data;
+		__u64 comp_cq : 11;
+		__u64: 5;
+		__u64 comp_ct : 11;
+		__u64: 5;
+		__u64 comp_eq : 11;
+		__u64: 21;
+		__u64 smt_idx : 8;
+		__u64: 56;
+		__u64 get_addr : 57;
+		__u64: 6;
+		__u64 get_with_local_flag : 1;
+		__u64 get_atc : 10;
+		__u64: 2;
+		__u64 get_vld : 1;
+		__u64: 3;
+		__u64 pcp : 3;
+		__u64: 1;
+		__u64 bc : 4;
+		__u64 mcu : 7;
+		__u64: 1;
+		__u64 timestamp : 20;
+		__u64: 12;
+	};
+};
+
+#define C_PCT_CFG_SPT_RAM1_OFFSET(idx) (0x000c0000 + ((idx) * 8))
+#define C_PCT_CFG_SPT_RAM1_ENTRIES 2048
+#define C_PCT_CFG_SPT_RAM1(idx) (C_PCT_BASE + C_PCT_CFG_SPT_RAM1_OFFSET(idx))
+#define C_PCT_CFG_SPT_RAM1_SIZE 0x00004000
+
+union c_pct_cfg_spt_ram1 {
+	__u64 qw;
+	struct {
+		__u64 clr_nxt : 11;
+		__u64: 5;
+		__u64 sct_idx : 12;
+		__u64: 36;
+	};
+};
+
+#define C_PCT_CFG_SPT_RAM2_OFFSET(idx) (0x000c8000 + ((idx) * 8))
+#define C_PCT_CFG_SPT_RAM2_ENTRIES 2048
+#define C_PCT_CFG_SPT_RAM2(idx) (C_PCT_BASE + C_PCT_CFG_SPT_RAM2_OFFSET(idx))
+#define C_PCT_CFG_SPT_RAM2_SIZE 0x00004000
+
+union c_pct_cfg_spt_ram2 {
+	__u64 qw;
+	struct {
+		__u64 srb_ptr : 11;
+		__u64: 5;
+		__u64 sct_seqno : 12;
+		__u64: 4;
+		__u64 return_code : 6;
+		__u64: 26;
+	};
+};
+
+#define C_PCT_CFG_TCT_RAM_OFFSET(idx) (0x000d0000 + ((idx) * 8))
+#define C_PCT_CFG_TCT_RAM_ENTRIES 8192
+#define C_PCT_CFG_TCT_RAM(idx) (C_PCT_BASE + C_PCT_CFG_TCT_RAM_OFFSET(idx))
+#define C_PCT_CFG_TCT_RAM_SIZE 0x00010000
+
+union c_pct_cfg_tct_ram {
+	__u64 qw;
+	struct {
+		__u64 last_active_mst : 11;
+		__u64: 3;
+		__u64 last_active_mst_is_put : 1;
+		__u64 last_active_mst_vld : 1;
+		__u64 clr_seqno : 12;
+		__u64: 4;
+		__u64 exp_seqno : 12;
+		__u64: 4;
+		__u64 tc : 3;
+		__u64: 13;
+	};
+};
+
+#define C_PCT_CFG_TCT_CAM_OFFSET(idx) (0x000e0000 + ((idx) * 8))
+#define C_PCT_CFG_TCT_CAM_ENTRIES 8192
+#define C_PCT_CFG_TCT_CAM(idx) (C_PCT_BASE + C_PCT_CFG_TCT_CAM_OFFSET(idx))
+#define C_PCT_CFG_TCT_CAM_SIZE 0x00010000
+
+union c_pct_cfg_tct_cam {
+	__u64 qw;
+	struct {
+		__u64 sfa_nid : 20;
+		__u64: 4;
+		__u64 sct_idx : 12;
+		__u64: 24;
+		__u64 vld : 1;
+		__u64: 3;
+	};
+};
+
+#define C1_PCT_CFG_TRS_RAM0_OFFSET(idx) (0x000f0000 + ((idx) * 8))
+#define C1_PCT_CFG_TRS_RAM0_ENTRIES 2048
+#define C1_PCT_CFG_TRS_RAM0(idx) (C_PCT_BASE + C1_PCT_CFG_TRS_RAM0_OFFSET(idx))
+#define C1_PCT_CFG_TRS_RAM0_SIZE 0x00004000
+
+union c_pct_cfg_trs_ram0 {
+	__u64 qw;
+	struct {
+		__u64 mst_idx : 11;
+		__u64: 5;
+		__u64 put_not_get : 1;
+		__u64: 7;
+		__u64 mst_idx_dealloc_vld : 1;
+		__u64: 39;
+	};
+};
+
+#define C2_PCT_CFG_TRS_RAM0_OFFSET(idx) (0x000f0000 + ((idx) * 8))
+#define C2_PCT_CFG_TRS_RAM0_ENTRIES 8192
+#define C2_PCT_CFG_TRS_RAM0(idx) (C_PCT_BASE + C2_PCT_CFG_TRS_RAM0_OFFSET(idx))
+#define C2_PCT_CFG_TRS_RAM0_SIZE 0x00010000
+
+#define C1_PCT_CFG_TRS_RAM1_OFFSET(idx) (0x00100000 + ((idx) * 32))
+#define C1_PCT_CFG_TRS_RAM1_ENTRIES 2048
+#define C1_PCT_CFG_TRS_RAM1(idx) (C_PCT_BASE + C1_PCT_CFG_TRS_RAM1_OFFSET(idx))
+#define C1_PCT_CFG_TRS_RAM1_SIZE 0x00010000
+
+union c_pct_cfg_trs_ram1 {
+	__u64 qw[3];
+	struct {
+		__u64 data_lower;
+		__u64 data_upper;
+		__u64 famo_data_vld : 1;
+		__u64: 7;
+		__u64 return_code : 6;
+		__u64: 2;
+		__u64 ptl_list : 2;
+		__u64: 6;
+		__u64 rsp_len : 5;
+		__u64: 3;
+		__u64 pend_rsp : 1;
+		__u64: 31;
+	};
+};
+
+#define C2_PCT_CFG_TRS_RAM1_OFFSET(idx) (0x00100000 + ((idx) * 32))
+#define C2_PCT_CFG_TRS_RAM1_ENTRIES 8192
+#define C2_PCT_CFG_TRS_RAM1(idx) (C_PCT_BASE + C2_PCT_CFG_TRS_RAM1_OFFSET(idx))
+#define C2_PCT_CFG_TRS_RAM1_SIZE 0x00040000
+
+#define C1_PCT_CFG_TRS_CAM_OFFSET(idx) (0x00110000 + ((idx) * 8))
+#define C1_PCT_CFG_TRS_CAM_ENTRIES 2048
+#define C1_PCT_CFG_TRS_CAM(idx) (C_PCT_BASE + C1_PCT_CFG_TRS_CAM_OFFSET(idx))
+#define C1_PCT_CFG_TRS_CAM_SIZE 0x00004000
+
+union c_pct_cfg_trs_cam {
+	__u64 qw;
+	struct {
+		__u64 req_seqno : 12;
+		__u64: 4;
+		__u64 tct_idx : 13;
+		__u64: 3;
+		__u64 vld : 1;
+		__u64: 31;
+	};
+};
+
+#define C2_PCT_CFG_TRS_CAM_OFFSET(idx) (0x00180000 + ((idx) * 8))
+#define C2_PCT_CFG_TRS_CAM_ENTRIES 8192
+#define C2_PCT_CFG_TRS_CAM(idx) (C_PCT_BASE + C2_PCT_CFG_TRS_CAM_OFFSET(idx))
+#define C2_PCT_CFG_TRS_CAM_SIZE 0x00010000
+
+#define C1_PCT_CFG_MST_CAM_OFFSET(idx) (0x00114000 + ((idx) * 8))
+#define C_PCT_CFG_MST_CAM_ENTRIES 2048
+#define C1_PCT_CFG_MST_CAM_ENTRIES C_PCT_CFG_MST_CAM_ENTRIES
+#define C1_PCT_CFG_MST_CAM(idx) (C_PCT_BASE + C1_PCT_CFG_MST_CAM_OFFSET(idx))
+#define C_PCT_CFG_MST_CAM_SIZE 0x00004000
+#define C1_PCT_CFG_MST_CAM_SIZE C_PCT_CFG_MST_CAM_SIZE
+
+union c_pct_cfg_mst_cam {
+	__u64 qw;
+	struct {
+		__u64 msg_id : 11;
+		__u64: 5;
+		__u64 multi_pkt : 1;
+		__u64: 7;
+		__u64 sfa_nid : 20;
+		__u64 vld : 1;
+		__u64: 19;
+	};
+};
+
+#define C2_PCT_CFG_MST_CAM_OFFSET(idx) (0x00190000 + ((idx) * 8))
+#define C2_PCT_CFG_MST_CAM_ENTRIES C_PCT_CFG_MST_CAM_ENTRIES
+#define C2_PCT_CFG_MST_CAM(idx) (C_PCT_BASE + C2_PCT_CFG_MST_CAM_OFFSET(idx))
+#define C2_PCT_CFG_MST_CAM_SIZE C_PCT_CFG_MST_CAM_SIZE
+
+#define C1_PCT_CFG_SPT_MISC_INFO_OFFSET(idx) (0x00118000 + ((idx) * 8))
+#define C_PCT_CFG_SPT_MISC_INFO_ENTRIES 2048
+#define C1_PCT_CFG_SPT_MISC_INFO_ENTRIES C_PCT_CFG_SPT_MISC_INFO_ENTRIES
+#define C1_PCT_CFG_SPT_MISC_INFO(idx) (C_PCT_BASE + C1_PCT_CFG_SPT_MISC_INFO_OFFSET(idx))
+#define C_PCT_CFG_SPT_MISC_INFO_SIZE 0x00004000
+#define C1_PCT_CFG_SPT_MISC_INFO_SIZE C_PCT_CFG_SPT_MISC_INFO_SIZE
+
+union c_pct_cfg_spt_misc_info {
+	__u64 qw;
+	struct {
+		__u64 start_epoch : 2;
+		__u64: 6;
+		__u64 to_flag : 1;
+		__u64: 7;
+		__u64 req_try : 3;
+		__u64: 5;
+		__u64 rsp_status : 2;
+		__u64: 6;
+		__u64 sw_retry : 1;
+		__u64: 7;
+		__u64 pkt_sent : 1;
+		__u64: 7;
+		__u64 vld : 1;
+		__u64: 15;
+	};
+};
+
+#define C2_PCT_CFG_SPT_MISC_INFO_OFFSET(idx) (0x00194000 + ((idx) * 8))
+#define C2_PCT_CFG_SPT_MISC_INFO_ENTRIES C_PCT_CFG_SPT_MISC_INFO_ENTRIES
+#define C2_PCT_CFG_SPT_MISC_INFO(idx) (C_PCT_BASE + C2_PCT_CFG_SPT_MISC_INFO_OFFSET(idx))
+#define C2_PCT_CFG_SPT_MISC_INFO_SIZE C_PCT_CFG_SPT_MISC_INFO_SIZE
+
+#define C1_PCT_CFG_SCT_MISC_INFO_OFFSET(idx) (0x00120000 + ((idx) * 8))
+#define C_PCT_CFG_SCT_MISC_INFO_ENTRIES 4096
+#define C1_PCT_CFG_SCT_MISC_INFO_ENTRIES C_PCT_CFG_SCT_MISC_INFO_ENTRIES
+#define C1_PCT_CFG_SCT_MISC_INFO(idx) (C_PCT_BASE + C1_PCT_CFG_SCT_MISC_INFO_OFFSET(idx))
+#define C_PCT_CFG_SCT_MISC_INFO_SIZE 0x00008000
+#define C1_PCT_CFG_SCT_MISC_INFO_SIZE C_PCT_CFG_SCT_MISC_INFO_SIZE
+
+union c_pct_cfg_sct_misc_info {
+	__u64 qw;
+	struct {
+		__u64 req_redo_vld : 1;
+		__u64: 7;
+		__u64 deny_new_msg : 1;
+		__u64: 7;
+		__u64 at_msg_boundary : 1;
+		__u64: 7;
+		__u64 clr_empty : 1;
+		__u64: 7;
+		__u64 last_active_epoch : 2;
+		__u64: 6;
+		__u64 sct_status : 3;
+		__u64: 21;
+	};
+};
+
+#define C2_PCT_CFG_SCT_MISC_INFO_OFFSET(idx) (0x00198000 + ((idx) * 8))
+#define C2_PCT_CFG_SCT_MISC_INFO_ENTRIES C_PCT_CFG_SCT_MISC_INFO_ENTRIES
+#define C2_PCT_CFG_SCT_MISC_INFO(idx) (C_PCT_BASE + C2_PCT_CFG_SCT_MISC_INFO_OFFSET(idx))
+#define C2_PCT_CFG_SCT_MISC_INFO_SIZE C_PCT_CFG_SCT_MISC_INFO_SIZE
+
+#define C1_PCT_CFG_TCT_MISC_INFO_OFFSET(idx) (0x00130000 + ((idx) * 8))
+#define C1_PCT_CFG_TCT_MISC_INFO_ENTRIES 8192
+#define C1_PCT_CFG_TCT_MISC_INFO(idx) (C_PCT_BASE + C1_PCT_CFG_TCT_MISC_INFO_OFFSET(idx))
+#define C1_PCT_CFG_TCT_MISC_INFO_SIZE 0x00010000
+
+union c1_pct_cfg_tct_misc_info {
+	__u64 qw;
+	struct {
+		__u64 last_active_epoch : 2;
+		__u64: 6;
+		__u64 to_flag : 1;
+		__u64: 7;
+		__u64 vld : 1;
+		__u64: 47;
+	};
+};
+
+#define C2_PCT_CFG_TCT_MISC_INFO_OFFSET(idx) (0x001a0000 + ((idx) * 8))
+#define C2_PCT_CFG_TCT_MISC_INFO_ENTRIES 8192
+#define C2_PCT_CFG_TCT_MISC_INFO(idx) (C_PCT_BASE + C2_PCT_CFG_TCT_MISC_INFO_OFFSET(idx))
+#define C2_PCT_CFG_TCT_MISC_INFO_SIZE 0x00010000
+
+union c2_pct_cfg_tct_misc_info {
+	__u64 qw;
+	struct {
+		__u64 last_active_epoch : 2;
+		__u64: 6;
+		__u64 to_flag : 1;
+		__u64: 3;
+		__u64 closing : 1;
+		__u64: 3;
+		__u64 vld : 1;
+		__u64: 47;
+	};
+};
+
+#define C1_PCT_CFG_SCT_INVALIDATE_OFFSET(idx) (0x00140000 + ((idx) * 8))
+#define C_PCT_CFG_SCT_INVALIDATE_ENTRIES 4096
+#define C1_PCT_CFG_SCT_INVALIDATE_ENTRIES C_PCT_CFG_SCT_INVALIDATE_ENTRIES
+#define C1_PCT_CFG_SCT_INVALIDATE(idx) (C_PCT_BASE + C1_PCT_CFG_SCT_INVALIDATE_OFFSET(idx))
+#define C_PCT_CFG_SCT_INVALIDATE_SIZE 0x00008000
+#define C1_PCT_CFG_SCT_INVALIDATE_SIZE C_PCT_CFG_SCT_INVALIDATE_SIZE
+
+union c_pct_cfg_sct_invalidate {
+	__u64 qw;
+	struct {
+		__u64 invalidate : 1;
+		__u64: 63;
+	};
+};
+
+#define C2_PCT_CFG_SCT_INVALIDATE_OFFSET(idx) (0x001d0000 + ((idx) * 8))
+#define C2_PCT_CFG_SCT_INVALIDATE_ENTRIES C_PCT_CFG_SCT_INVALIDATE_ENTRIES
+#define C2_PCT_CFG_SCT_INVALIDATE(idx) (C_PCT_BASE + C2_PCT_CFG_SCT_INVALIDATE_OFFSET(idx))
+#define C2_PCT_CFG_SCT_INVALIDATE_SIZE C_PCT_CFG_SCT_INVALIDATE_SIZE
+
+#define C1_PCT_CFG_TCT_INVALIDATE_OFFSET(idx) (0x00150000 + ((idx) * 8))
+#define C_PCT_CFG_TCT_INVALIDATE_ENTRIES 8192
+#define C1_PCT_CFG_TCT_INVALIDATE_ENTRIES C_PCT_CFG_TCT_INVALIDATE_ENTRIES
+#define C1_PCT_CFG_TCT_INVALIDATE(idx) (C_PCT_BASE + C1_PCT_CFG_TCT_INVALIDATE_OFFSET(idx))
+#define C_PCT_CFG_TCT_INVALIDATE_SIZE 0x00010000
+#define C1_PCT_CFG_TCT_INVALIDATE_SIZE C_PCT_CFG_TCT_INVALIDATE_SIZE
+
+union c_pct_cfg_tct_invalidate {
+	__u64 qw;
+	struct {
+		__u64 invalidate : 1;
+		__u64: 63;
+	};
+};
+
+#define C2_PCT_CFG_TCT_INVALIDATE_OFFSET(idx) (0x001b0000 + ((idx) * 8))
+#define C2_PCT_CFG_TCT_INVALIDATE_ENTRIES C_PCT_CFG_TCT_INVALIDATE_ENTRIES
+#define C2_PCT_CFG_TCT_INVALIDATE(idx) (C_PCT_BASE + C2_PCT_CFG_TCT_INVALIDATE_OFFSET(idx))
+#define C2_PCT_CFG_TCT_INVALIDATE_SIZE C_PCT_CFG_TCT_INVALIDATE_SIZE
+
+#define C1_PCT_CFG_TRS_INVALIDATE_OFFSET(idx) (0x00168000 + ((idx) * 8))
+#define C1_PCT_CFG_TRS_INVALIDATE_ENTRIES 2048
+#define C1_PCT_CFG_TRS_INVALIDATE(idx) (C_PCT_BASE + C1_PCT_CFG_TRS_INVALIDATE_OFFSET(idx))
+#define C1_PCT_CFG_TRS_INVALIDATE_SIZE 0x00004000
+
+union c_pct_cfg_trs_invalidate {
+	__u64 qw;
+	struct {
+		__u64 invalidate : 1;
+		__u64: 63;
+	};
+};
+
+#define C2_PCT_CFG_TRS_INVALIDATE_OFFSET(idx) (0x001c0000 + ((idx) * 8))
+#define C2_PCT_CFG_TRS_INVALIDATE_ENTRIES 8192
+#define C2_PCT_CFG_TRS_INVALIDATE(idx) (C_PCT_BASE + C2_PCT_CFG_TRS_INVALIDATE_OFFSET(idx))
+#define C2_PCT_CFG_TRS_INVALIDATE_SIZE 0x00010000
+
+#define C1_PCT_CFG_MST_INVALIDATE_OFFSET(idx) (0x00170000 + ((idx) * 8))
+#define C_PCT_CFG_MST_INVALIDATE_ENTRIES 2048
+#define C1_PCT_CFG_MST_INVALIDATE_ENTRIES C_PCT_CFG_MST_INVALIDATE_ENTRIES
+#define C1_PCT_CFG_MST_INVALIDATE(idx) (C_PCT_BASE + C1_PCT_CFG_MST_INVALIDATE_OFFSET(idx))
+#define C_PCT_CFG_MST_INVALIDATE_SIZE 0x00004000
+#define C1_PCT_CFG_MST_INVALIDATE_SIZE C_PCT_CFG_MST_INVALIDATE_SIZE
+
+union c_pct_cfg_mst_invalidate {
+	__u64 qw;
+	struct {
+		__u64 invalidate : 1;
+		__u64: 63;
+	};
+};
+
+#define C2_PCT_CFG_MST_INVALIDATE_OFFSET(idx) (0x001d8000 + ((idx) * 8))
+#define C2_PCT_CFG_MST_INVALIDATE_ENTRIES C_PCT_CFG_MST_INVALIDATE_ENTRIES
+#define C2_PCT_CFG_MST_INVALIDATE(idx) (C_PCT_BASE + C2_PCT_CFG_MST_INVALIDATE_OFFSET(idx))
+#define C2_PCT_CFG_MST_INVALIDATE_SIZE C_PCT_CFG_MST_INVALIDATE_SIZE
+
+#define C1_PCT_CFG_SRB_LINK_LIST_OFFSET(idx) (0x00178000 + ((idx) * 8))
+#define C_PCT_CFG_SRB_LINK_LIST_ENTRIES 2048
+#define C1_PCT_CFG_SRB_LINK_LIST_ENTRIES C_PCT_CFG_SRB_LINK_LIST_ENTRIES
+#define C1_PCT_CFG_SRB_LINK_LIST(idx) (C_PCT_BASE + C1_PCT_CFG_SRB_LINK_LIST_OFFSET(idx))
+#define C_PCT_CFG_SRB_LINK_LIST_SIZE 0x00004000
+#define C1_PCT_CFG_SRB_LINK_LIST_SIZE C_PCT_CFG_SRB_LINK_LIST_SIZE
+
+union c_pct_cfg_srb_link_list {
+	__u64 qw;
+	struct {
+		__u64 tail : 1;
+		__u64: 7;
+		__u64 next_ptr : 11;
+		__u64: 45;
+	};
+};
+
+#define C2_PCT_CFG_SRB_LINK_LIST_OFFSET(idx) (0x001e0000 + ((idx) * 8))
+#define C2_PCT_CFG_SRB_LINK_LIST_ENTRIES C_PCT_CFG_SRB_LINK_LIST_ENTRIES
+#define C2_PCT_CFG_SRB_LINK_LIST(idx) (C_PCT_BASE + C2_PCT_CFG_SRB_LINK_LIST_OFFSET(idx))
+#define C2_PCT_CFG_SRB_LINK_LIST_SIZE C_PCT_CFG_SRB_LINK_LIST_SIZE
+
+#define C_PCT_CFG_SRB_CELL_DATA_OFFSET(idx) (0x00200000 + ((idx) * 128))
+#define C_PCT_CFG_SRB_CELL_DATA_ENTRIES 8192
+#define C_PCT_CFG_SRB_CELL_DATA(idx) (C_PCT_BASE + C_PCT_CFG_SRB_CELL_DATA_OFFSET(idx))
+#define C_PCT_CFG_SRB_CELL_DATA_SIZE 0x00100000
+
+union c_pct_cfg_srb_cell_data {
+	__u64 qw[9];
+	struct {
+		__u64 byte_len : 14;
+		__u64: 2;
+		__u64 fmt : 1;
+		__u64 eopb : 1;
+		__u64 eop : 1;
+		__u64 sop : 1;
+		__u64: 44;
+		__u64 word0;
+		__u64 word1;
+		__u64 word2;
+		__u64 word3;
+		__u64 word4;
+		__u64 word5;
+		__u64 word6;
+		__u64 word7;
+	};
+};
+
+#define C_PCT_PRF_SCT_STATUS_OFFSET 0x00300100
+#define C_PCT_PRF_SCT_STATUS (C_PCT_BASE + C_PCT_PRF_SCT_STATUS_OFFSET)
+#define C_PCT_PRF_SCT_STATUS_SIZE 0x00000008
+
+union c_pct_prf_sct_status {
+	__u64 qw;
+	struct {
+		__u64 sct_in_use : 13;
+		__u64: 19;
+		__u64 max_sct_in_use : 13;
+		__u64: 19;
+	};
+};
+
+#define C_PCT_PRF_TCT_STATUS_OFFSET 0x00300108
+#define C_PCT_PRF_TCT_STATUS (C_PCT_BASE + C_PCT_PRF_TCT_STATUS_OFFSET)
+#define C_PCT_PRF_TCT_STATUS_SIZE 0x00000008
+
+union c_pct_prf_tct_status {
+	__u64 qw;
+	struct {
+		__u64 tct_in_use : 14;
+		__u64: 18;
+		__u64 max_tct_in_use : 14;
+		__u64: 18;
+	};
+};
+
+#define C_PCT_PRF_SPT_STATUS_OFFSET 0x00300110
+#define C_PCT_PRF_SPT_STATUS (C_PCT_BASE + C_PCT_PRF_SPT_STATUS_OFFSET)
+#define C_PCT_PRF_SPT_STATUS_SIZE 0x00000008
+
+union c_pct_prf_spt_status {
+	__u64 qw;
+	struct {
+		__u64 spt_in_use : 12;
+		__u64: 20;
+		__u64 max_spt_in_use : 12;
+		__u64: 20;
+	};
+};
+
+#define C_PCT_PRF_SMT_STATUS_OFFSET 0x00300118
+#define C_PCT_PRF_SMT_STATUS (C_PCT_BASE + C_PCT_PRF_SMT_STATUS_OFFSET)
+#define C_PCT_PRF_SMT_STATUS_SIZE 0x00000008
+
+union c_pct_prf_smt_status {
+	__u64 qw;
+	struct {
+		__u64 smt_in_use : 9;
+		__u64: 23;
+		__u64 max_smt_in_use : 9;
+		__u64: 23;
+	};
+};
+
+#define C1_PCT_PRF_TRS_STATUS_OFFSET 0x00300120
+#define C1_PCT_PRF_TRS_STATUS (C_PCT_BASE + C1_PCT_PRF_TRS_STATUS_OFFSET)
+#define C1_PCT_PRF_TRS_STATUS_SIZE 0x00000008
+
+union c1_pct_prf_trs_status {
+	__u64 qw;
+	struct {
+		__u64 trs_in_use : 12;
+		__u64: 20;
+		__u64 max_trs_in_use : 12;
+		__u64: 20;
+	};
+};
+
+#define C2_PCT_PRF_TRS_STATUS_OFFSET 0x00300120
+#define C2_PCT_PRF_TRS_STATUS (C_PCT_BASE + C2_PCT_PRF_TRS_STATUS_OFFSET)
+#define C2_PCT_PRF_TRS_STATUS_SIZE 0x00000008
+
+union c2_pct_prf_trs_status {
+	__u64 qw;
+	struct {
+		__u64 trs_in_use : 14;
+		__u64: 18;
+		__u64 max_trs_in_use : 14;
+		__u64: 18;
+	};
+};
+
+#define C_PCT_PRF_SRB_STATUS_OFFSET 0x00300128
+#define C_PCT_PRF_SRB_STATUS (C_PCT_BASE + C_PCT_PRF_SRB_STATUS_OFFSET)
+#define C_PCT_PRF_SRB_STATUS_SIZE 0x00000008
+
+union c_pct_prf_srb_status {
+	__u64 qw;
+	struct {
+		__u64 srb_in_use : 12;
+		__u64: 20;
+		__u64 max_srb_in_use : 12;
+		__u64: 20;
+	};
+};
+
+#define C_PCT_PRF_MST_STATUS_OFFSET 0x00300130
+#define C_PCT_PRF_MST_STATUS (C_PCT_BASE + C_PCT_PRF_MST_STATUS_OFFSET)
+#define C_PCT_PRF_MST_STATUS_SIZE 0x00000008
+
+union c_pct_prf_mst_status {
+	__u64 qw;
+	struct {
+		__u64 mst_in_use : 12;
+		__u64: 20;
+		__u64 max_mst_in_use : 12;
+		__u64: 20;
+	};
+};
+
+#define C_PI_CFG_CRNC_OFFSET 0x00000000
+#define C_PI_CFG_CRNC (C_PI_BASE + C_PI_CFG_CRNC_OFFSET)
+#define C_PI_CFG_CRNC_SIZE 0x00000008
+
+union c_pi_cfg_crnc {
+	__u64 qw;
+	struct {
+		__u64 csr_timeout : 8;
+		__u64 mcast_id : 10;
+		__u64: 1;
+		__u64 mcast_enable : 1;
+		__u64 mcast_mask : 10;
+		__u64: 34;
+	};
+};
+
+#define C_PI_CFG_RT_OFFSET_OFFSET 0x00000020
+#define C_PI_CFG_RT_OFFSET (C_PI_BASE + C_PI_CFG_RT_OFFSET_OFFSET)
+#define C_PI_CFG_RT_OFFSET_SIZE 0x00000008
+
+union c_pi_cfg_rt_offset {
+	__u64 qw;
+	struct {
+		__u64 seconds : 48;
+		__u64: 16;
+	};
+};
+
+#define C_PI_MSC_SHADOW_ACTION_OFFSET 0x00000038
+#define C_PI_MSC_SHADOW_ACTION (C_PI_BASE + C_PI_MSC_SHADOW_ACTION_OFFSET)
+#define C_PI_MSC_SHADOW_ACTION_SIZE 0x00000008
+#define C_PI_MSC_SHADOW_OFFSET 0x00000040
+#define C_PI_MSC_SHADOW (C_PI_BASE + C_PI_MSC_SHADOW_OFFSET)
+#define C_PI_MSC_SHADOW_SIZE 0x00000010
+
+union c_pi_msc_shadow {
+	__u64 qw[2];
+};
+
+#define C_PI_ERR_ELAPSED_TIME_OFFSET 0x00000100
+#define C_PI_ERR_ELAPSED_TIME (C_PI_BASE + C_PI_ERR_ELAPSED_TIME_OFFSET)
+#define C_PI_ERR_ELAPSED_TIME_SIZE 0x00000008
+
+union c_pi_err_elapsed_time {
+	__u64 qw;
+	struct {
+		__u64 nanoseconds : 30;
+		__u64 seconds : 34;
+	};
+};
+
+#define C_PI_ERR_FLG_OFFSET 0x00000108
+#define C_PI_ERR_FLG (C_PI_BASE + C_PI_ERR_FLG_OFFSET)
+#define C_PI_ERR_FLG_SIZE 0x00000008
+
+union c_pi_err_flg {
+	__u64 qw;
+	struct {
+		__u64 sw_diag : 1;
+		__u64 crnc_ring_sync_error : 1;
+		__u64 crnc_ring_ecc_sbe : 1;
+		__u64 crnc_ring_ecc_mbe : 1;
+		__u64 crnc_ring_cmd_unknown : 1;
+		__u64 crnc_csr_cmd_unknown : 1;
+		__u64 crnc_csr_cmd_incomplete : 1;
+		__u64 crnc_buf_ecc_sbe : 1;
+		__u64 crnc_buf_ecc_mbe : 1;
+		__u64: 7;
+		__u64 acxt_cor : 1;
+		__u64 acxt_ucor : 1;
+		__u64 sriovt_cor : 1;
+		__u64 sriovt_ucor : 1;
+		__u64 dmac_desc_cor : 1;
+		__u64 dmac_desc_ucor : 1;
+		__u64 pri_mb_xlat_rtrgt_fifo_cor : 4;
+		__u64 pri_mb_xlat_rtrgt_fifo_ucor : 4;
+		__u64 pri_rarb_xlat_rtrgt_fifo_cor : 4;
+		__u64 pri_rarb_xlat_rtrgt_fifo_ucor : 4;
+		__u64 pri_rarb_xlat_rbyp_fifo_cor : 4;
+		__u64 pri_rarb_xlat_rbyp_fifo_ucor : 4;
+		__u64 pti_tarb_xlat_pipe0_hdr_cor : 1;
+		__u64 pti_tarb_xlat_pipe0_hdr_ucor : 1;
+		__u64 pti_tarb_xlat_pipe3_hdr_cor : 1;
+		__u64 pti_tarb_xlat_pipe3_hdr_ucor : 1;
+		__u64 pti_tarb_xlat_pipe3_data_cor : 1;
+		__u64 pti_tarb_xlat_pipe3_data_ucor : 1;
+		__u64 pti_tarb_xlat_unexpected_dv : 1;
+		__u64 pti_tarb_xlat_ac_en_error : 1;
+		__u64 pti_tarb_xlat_cfg_vf_en_error : 1;
+		__u64 pti_tarb_xlat_cfg_vf_num_error : 1;
+		__u64 pti_tarb_xlat_cfg_vf_bme_error : 1;
+		__u64 pti_tarb_xlat_cfg_bme_error : 1;
+		__u64 pti_tarb_xlat_cfg_amo_error : 1;
+		__u64: 3;
+		__u64 uc_attention : 2;
+	};
+};
+
+#define C_PI_ERR_FIRST_FLG_OFFSET 0x00000110
+#define C_PI_ERR_FIRST_FLG (C_PI_BASE + C_PI_ERR_FIRST_FLG_OFFSET)
+#define C_PI_ERR_FIRST_FLG_SIZE 0x00000008
+#define C_PI_ERR_FIRST_FLG_TS_OFFSET 0x00000118
+#define C_PI_ERR_FIRST_FLG_TS (C_PI_BASE + C_PI_ERR_FIRST_FLG_TS_OFFSET)
+#define C_PI_ERR_FIRST_FLG_TS_SIZE 0x00000008
+#define C_PI_ERR_CLR_OFFSET 0x00000120
+#define C_PI_ERR_CLR (C_PI_BASE + C_PI_ERR_CLR_OFFSET)
+#define C_PI_ERR_CLR_SIZE 0x00000008
+#define C_PI_ERR_IRQA_MSK_OFFSET 0x00000128
+#define C_PI_ERR_IRQA_MSK (C_PI_BASE + C_PI_ERR_IRQA_MSK_OFFSET)
+#define C_PI_ERR_IRQA_MSK_SIZE 0x00000008
+#define C_PI_ERR_IRQB_MSK_OFFSET 0x00000130
+#define C_PI_ERR_IRQB_MSK (C_PI_BASE + C_PI_ERR_IRQB_MSK_OFFSET)
+#define C_PI_ERR_IRQB_MSK_SIZE 0x00000008
+#define C_PI_ERR_INFO_MSK_OFFSET 0x00000140
+#define C_PI_ERR_INFO_MSK (C_PI_BASE + C_PI_ERR_INFO_MSK_OFFSET)
+#define C_PI_ERR_INFO_MSK_SIZE 0x00000008
+#define C_PI_ERR_INFO_MEM_OFFSET 0x00000180
+#define C_PI_ERR_INFO_MEM (C_PI_BASE + C_PI_ERR_INFO_MEM_OFFSET)
+#define C_PI_ERR_INFO_MEM_SIZE 0x00000008
+
+union c_pi_err_info_mem {
+	__u64 qw;
+	struct {
+		__u64 cor_syndrome : 11;
+		__u64: 1;
+		__u64 cor_address : 13;
+		__u64: 1;
+		__u64 cor_mem_id : 5;
+		__u64 cor_csr_detected : 1;
+		__u64 ucor_syndrome : 11;
+		__u64: 1;
+		__u64 ucor_address : 13;
+		__u64: 1;
+		__u64 ucor_mem_id : 5;
+		__u64 ucor_csr_detected : 1;
+	};
+};
+
+#define C_PI_ERR_INFO_TARB_OFFSET 0x00000190
+#define C_PI_ERR_INFO_TARB (C_PI_BASE + C_PI_ERR_INFO_TARB_OFFSET)
+#define C_PI_ERR_INFO_TARB_SIZE 0x00000010
+
+union c_pi_err_info_tarb {
+	__u64 qw[2];
+	struct {
+		__u64 msg_type : 4;
+		__u64 acid : 10;
+		__u64 msg_49_0 : 50;
+		__u64 msg_84_50 : 35;
+		__u64 source : 3;
+		__u64: 26;
+	};
+};
+
+#define C_PI_EXT_ERR_FLG_OFFSET 0x00000208
+#define C_PI_EXT_ERR_FLG (C_PI_BASE + C_PI_EXT_ERR_FLG_OFFSET)
+#define C_PI_EXT_ERR_FLG_SIZE 0x00000008
+
+union c_pi_ext_err_flg {
+	__u64 qw;
+	struct {
+		__u64 sw_diag : 1;
+		__u64 pri_mb_xlat_rtrgt_abort_error : 1;
+		__u64 pri_mb_xlat_rtrgt_hdr_parity_error : 1;
+		__u64 pri_mb_xlat_rtrgt_data_parity_error : 1;
+		__u64 pri_mb_xlat_axi_wr_decerr : 1;
+		__u64 pri_mb_xlat_axi_wr_slverr : 1;
+		__u64 pri_mb_xlat_axi_rd_decerr : 1;
+		__u64 pri_mb_xlat_axi_rd_slverr : 1;
+		__u64 pri_mb_xlat_axi_rd_parity_error : 1;
+		__u64 pri_mb_xlat_msg_tlp_discard : 1;
+		__u64 pri_mb_xlat_unexpected_np_tlp : 1;
+		__u64 pri_mb_xlat_unexpected_tlp : 1;
+		__u64 pri_mb_xlat_pf_addr_error : 1;
+		__u64 pri_mb_xlat_vf_addr_error : 1;
+		__u64 pri_mb_xlat_rom_wr_error : 1;
+		__u64 pri_mb_xlat_partial_discard : 1;
+		__u64 pri_mb_xlat_rtrgt_fifo_underrun : 1;
+		__u64 pri_mb_xlat_rtrgt_rdy_fifo_underrun : 1;
+		__u64 pri_mb_xlat_comp_fifo_overrun : 1;
+		__u64 pri_mb_xlat_comp_ca : 1;
+		__u64 pri_mb_xlat_comp_ur : 1;
+		__u64 pri_rarb_xlat_rtrgt_abort_error : 1;
+		__u64 pri_rarb_xlat_rtrgt_hdr_parity_error : 1;
+		__u64 pri_rarb_xlat_rtrgt_data_parity_error : 1;
+		__u64 pri_rarb_xlat_rtrgt_unexpected_tlp : 1;
+		__u64 pri_rarb_xlat_rtrgt_unexpected_msg : 1;
+		__u64 pri_rarb_xlat_rtrgt_vf_addr_error : 1;
+		__u64 pri_rarb_xlat_rtrgt_vf_en_num_error : 1;
+		__u64 pri_rarb_xlat_rtrgt_vf_en_error : 1;
+		__u64 pri_rarb_xlat_rtrgt_inv_req_vf_error : 1;
+		__u64 pri_rarb_xlat_rtrgt_inv_req_dev_id_error : 1;
+		__u64 pri_rarb_xlat_rtrgt_prgr_vf_error : 1;
+		__u64 pri_rarb_xlat_rtrgt_prgr_dev_id_error : 1;
+		__u64 pri_rarb_xlat_rtrgt_fifo_underrun : 1;
+		__u64 pri_rarb_xlat_rtrgt_rdy_fifo_underrun : 1;
+		__u64 pri_rarb_xlat_rbyp_abort_error : 1;
+		__u64 pri_rarb_xlat_rbyp_hdr_parity_error : 1;
+		__u64 pri_rarb_xlat_rbyp_data_parity_error : 1;
+		__u64 pri_rarb_xlat_rbyp_tag_error : 1;
+		__u64 pri_rarb_xlat_rbyp_unexpected_tlp_error : 1;
+		__u64 pri_rarb_xlat_rbyp_fifo_underrun : 1;
+		__u64 pri_rarb_xlat_rbyp_rdy_fifo_underrun : 1;
+		__u64 pti_tarb_xlat_p_fifo_overrun : 1;
+		__u64 pti_tarb_xlat_np_fifo_overrun : 1;
+		__u64 pti_tarb_xlat_ord_fifo_overrun : 1;
+		__u64 pti_tarb_xlat_np_err_fifo_overrun : 1;
+		__u64 pti_tarb_xlat_np_err_fifo_underrun : 1;
+		__u64 pti_tarb_xlat_pti_pri_cpl_to_fifo_underrun : 1;
+		__u64 dmac_axi_rd_decerr : 1;
+		__u64 dmac_axi_rd_slverr : 1;
+		__u64 dmac_axi_rd_parity_error : 1;
+		__u64 ahb_overwrite : 1;
+		__u64 ahb_resp_err : 1;
+		__u64: 11;
+	};
+};
+
+#define C_PI_EXT_ERR_FIRST_FLG_OFFSET 0x00000210
+#define C_PI_EXT_ERR_FIRST_FLG (C_PI_BASE + C_PI_EXT_ERR_FIRST_FLG_OFFSET)
+#define C_PI_EXT_ERR_FIRST_FLG_SIZE 0x00000008
+#define C_PI_EXT_ERR_FIRST_FLG_TS_OFFSET 0x00000218
+#define C_PI_EXT_ERR_FIRST_FLG_TS (C_PI_BASE + C_PI_EXT_ERR_FIRST_FLG_TS_OFFSET)
+#define C_PI_EXT_ERR_FIRST_FLG_TS_SIZE 0x00000008
+#define C_PI_EXT_ERR_CLR_OFFSET 0x00000220
+#define C_PI_EXT_ERR_CLR (C_PI_BASE + C_PI_EXT_ERR_CLR_OFFSET)
+#define C_PI_EXT_ERR_CLR_SIZE 0x00000008
+#define C_PI_EXT_ERR_IRQA_MSK_OFFSET 0x00000228
+#define C_PI_EXT_ERR_IRQA_MSK (C_PI_BASE + C_PI_EXT_ERR_IRQA_MSK_OFFSET)
+#define C_PI_EXT_ERR_IRQA_MSK_SIZE 0x00000008
+#define C_PI_EXT_ERR_IRQB_MSK_OFFSET 0x00000230
+#define C_PI_EXT_ERR_IRQB_MSK (C_PI_BASE + C_PI_EXT_ERR_IRQB_MSK_OFFSET)
+#define C_PI_EXT_ERR_IRQB_MSK_SIZE 0x00000008
+#define C_PI_EXT_ERR_INFO_MSK_OFFSET 0x00000240
+#define C_PI_EXT_ERR_INFO_MSK (C_PI_BASE + C_PI_EXT_ERR_INFO_MSK_OFFSET)
+#define C_PI_EXT_ERR_INFO_MSK_SIZE 0x00000008
+#define C_PI_ERR_INFO_RTRGT_OFFSET 0x00000250
+#define C_PI_ERR_INFO_RTRGT (C_PI_BASE + C_PI_ERR_INFO_RTRGT_OFFSET)
+#define C_PI_ERR_INFO_RTRGT_SIZE 0x00000018
+
+union c_pi_err_info_rtrgt {
+	__u64 qw[3];
+	struct {
+		__u64 addr;
+		__u64 tlp_type : 5;
+		__u64 fmt : 2;
+		__u64 tc : 3;
+		__u64 attr : 3;
+		__u64 td : 1;
+		__u64 th : 1;
+		__u64 poisoned : 1;
+		__u64 reqid : 16;
+		__u64 tag : 10;
+		__u64 dw_len : 10;
+		__u64 first_be : 4;
+		__u64 last_be : 4;
+		__u64 ats : 2;
+		__u64 ph : 2;
+		__u64 st : 8;
+		__u64 vfunc_num : 6;
+		__u64 vfunc_active : 1;
+		__u64 nw : 1;
+		__u64 ecrc_err : 1;
+		__u64 dllp_abort : 1;
+		__u64 tlp_abort : 1;
+		__u64: 13;
+		__u64 tlp_prfx : 32;
+	};
+};
+
+#define C_PI_ERR_INFO_RBYP_OFFSET 0x00000280
+#define C_PI_ERR_INFO_RBYP (C_PI_BASE + C_PI_ERR_INFO_RBYP_OFFSET)
+#define C_PI_ERR_INFO_RBYP_SIZE 0x00000018
+
+union c_pi_err_info_rbyp {
+	__u64 qw[3];
+	struct {
+		__u64 addr : 7;
+		__u64: 9;
+		__u64 ats : 2;
+		__u64 ph : 2;
+		__u64: 12;
+		__u64 byte_cnt : 12;
+		__u64: 4;
+		__u64 completer_id : 16;
+		__u64 tlp_type : 5;
+		__u64 fmt : 2;
+		__u64 tc : 3;
+		__u64 attr : 3;
+		__u64 td : 1;
+		__u64 th : 1;
+		__u64 poisoned : 1;
+		__u64 reqid : 16;
+		__u64 tag : 10;
+		__u64 dw_len : 10;
+		__u64 cpl_status : 3;
+		__u64 cpl_last : 1;
+		__u64 bcm : 1;
+		__u64 ecrc_err : 1;
+		__u64 dllp_abort : 1;
+		__u64 tlp_abort : 1;
+		__u64: 4;
+		__u64 tlp_prfx : 32;
+		__u64: 32;
+	};
+};
+
+#define C_PI_ERR_INFO_DMAC_OFFSET 0x000002a0
+#define C_PI_ERR_INFO_DMAC (C_PI_BASE + C_PI_ERR_INFO_DMAC_OFFSET)
+#define C_PI_ERR_INFO_DMAC_SIZE 0x00000008
+
+union c_pi_err_info_dmac {
+	__u64 qw;
+	struct {
+		__u64 desc_addr : 10;
+		__u64: 54;
+	};
+};
+
+#define C_PI_CFG_PRI_SRIOV_OFFSET 0x00001100
+#define C_PI_CFG_PRI_SRIOV (C_PI_BASE + C_PI_CFG_PRI_SRIOV_OFFSET)
+#define C_PI_CFG_PRI_SRIOV_SIZE 0x00000008
+
+union c_pi_cfg_pri_sriov {
+	__u64 qw;
+	struct {
+		__u64 vf_offset : 16;
+		__u64 vf_stride : 16;
+		__u64: 32;
+	};
+};
+
+#define C_PI_CFG_DMAC_CPL_ADDR_OFFSET 0x00002000
+#define C_PI_CFG_DMAC_CPL_ADDR (C_PI_BASE + C_PI_CFG_DMAC_CPL_ADDR_OFFSET)
+#define C_PI_CFG_DMAC_CPL_ADDR_SIZE 0x00000008
+
+union c_pi_cfg_dmac_cpl_addr {
+	__u64 qw;
+	struct {
+		__u64: 3;
+		__u64 address : 61;
+	};
+};
+
+#define C_PI_CFG_DMAC_OFFSET 0x00002008
+#define C_PI_CFG_DMAC (C_PI_BASE + C_PI_CFG_DMAC_OFFSET)
+#define C_PI_CFG_DMAC_SIZE 0x00000008
+
+union c_pi_cfg_dmac {
+	__u64 qw;
+	struct {
+		__u64 desc_index : 10;
+		__u64: 2;
+		__u64 enable : 1;
+		__u64 start : 1;
+		__u64 done : 1;
+		__u64 cpl_event_enable : 1;
+		__u64 status : 2;
+		__u64 irq_on_done : 1;
+		__u64 irq_on_error : 1;
+		__u64: 44;
+	};
+};
+
+#define C_PI_CFG_SRIOVT_OFFSET(idx) (0x00010000 + ((idx) * 8))
+#define C_PI_CFG_SRIOVT_ENTRIES 6144
+#define C_PI_CFG_SRIOVT(idx) (C_PI_BASE + C_PI_CFG_SRIOVT_OFFSET(idx))
+#define C_PI_CFG_SRIOVT_SIZE 0x0000c000
+
+union c_pi_cfg_sriovt {
+	__u64 qw;
+	struct {
+		__u64 vf_num : 6;
+		__u64 vf_en : 1;
+		__u64: 57;
+	};
+};
+
+#define C_PI_CFG_ACXT_OFFSET(idx) (0x00020000 + ((idx) * 8))
+#define C_PI_CFG_ACXT_ENTRIES 1024
+#define C_PI_CFG_ACXT(idx) (C_PI_BASE + C_PI_CFG_ACXT_OFFSET(idx))
+#define C_PI_CFG_ACXT_SIZE 0x00002000
+
+union c_pi_cfg_acxt {
+	__u64 qw;
+	struct {
+		__u64 ac_en : 1;
+		__u64 vf_en : 1;
+		__u64 vf_num : 6;
+		__u64 steering_tag : 8;
+		__u64 ph_en : 1;
+		__u64 phints : 2;
+		__u64 no_snoop : 1;
+		__u64 mem_rd_ro : 1;
+		__u64 flush_req_ro : 1;
+		__u64 translation_req_ro : 1;
+		__u64 fetching_amo_ro : 1;
+		__u64 ido : 1;
+		__u64 at1 : 1;
+		__u64 pasid_en : 1;
+		__u64 pasid : 20;
+		__u64 pasid_rsvd : 2;
+		__u64 pasid_er : 1;
+		__u64 pasid_pmr : 1;
+		__u64 reserved : 13;
+	};
+};
+
+#define C_PI_CFG_DMAC_DESC_OFFSET(idx) (0x00030000 + ((idx) * 16))
+#define C_PI_CFG_DMAC_DESC_ENTRIES 1024
+/*
+ * Since there are an 'abundance' of DMAC descriptors, some of them have
+ * been repurposed & reserved as 'scratch registers' for other purposes.
+ *
+ * Such as for communication between UC & HOST (see cass_uc.c).
+ *
+ * The rule is a contiguous block of descriptors from
+ *
+ *	I ... (C_PI_CFG_DMAC_DESC_ENTRIES - 1)
+ *
+ * will be the reserved pool not to be used by the DMAC for DMAing.
+ */
+#define C_PI_CFG_DMAC_DESC_NUM_RSVD_ENTRIES 32
+#define C_PI_CFG_DMAC_DESC_NUM_AVAILABLE_ENTRIES                                                   \
+	(C_PI_CFG_DMAC_DESC_ENTRIES - C_PI_CFG_DMAC_DESC_NUM_RSVD_ENTRIES)
+
+#define C_PI_CFG_DMAC_DESC(idx) (C_PI_BASE + C_PI_CFG_DMAC_DESC_OFFSET(idx))
+#define C_PI_CFG_DMAC_DESC_SIZE 0x00004000
+
+union c_pi_cfg_dmac_desc {
+	__u64 qw[2];
+	struct {
+		__u64 reserved0 : 3;
+		__u64 dst_addr : 61;
+		__u64 reserved1 : 3;
+		__u64 src_addr : 27;
+		__u64 reserved2 : 2;
+		__u64 length : 20;
+		__u64 cont : 1;
+		__u64 reserved3 : 11;
+	};
+};
+
+#define C_PI_IPD_CFG_CRNC_OFFSET 0x00000000
+#define C_PI_IPD_CFG_CRNC (C_PI_IPD_BASE + C_PI_IPD_CFG_CRNC_OFFSET)
+#define C_PI_IPD_CFG_CRNC_SIZE 0x00000008
+
+union c_pi_ipd_cfg_crnc {
+	__u64 qw;
+	struct {
+		__u64 csr_timeout : 8;
+		__u64 mcast_id : 10;
+		__u64: 1;
+		__u64 mcast_enable : 1;
+		__u64 mcast_mask : 10;
+		__u64: 34;
+	};
+};
+
+#define C_PI_IPD_CFG_RT_OFFSET_OFFSET 0x00000020
+#define C_PI_IPD_CFG_RT_OFFSET (C_PI_IPD_BASE + C_PI_IPD_CFG_RT_OFFSET_OFFSET)
+#define C_PI_IPD_CFG_RT_OFFSET_SIZE 0x00000008
+
+union c_pi_ipd_cfg_rt_offset {
+	__u64 qw;
+	struct {
+		__u64 seconds : 48;
+		__u64: 16;
+	};
+};
+
+#define C_PI_IPD_MSC_SHADOW_ACTION_OFFSET 0x00000038
+#define C_PI_IPD_MSC_SHADOW_ACTION (C_PI_IPD_BASE + C_PI_IPD_MSC_SHADOW_ACTION_OFFSET)
+#define C_PI_IPD_MSC_SHADOW_ACTION_SIZE 0x00000008
+#define C_PI_IPD_MSC_SHADOW_OFFSET 0x00000040
+#define C_PI_IPD_MSC_SHADOW (C_PI_IPD_BASE + C_PI_IPD_MSC_SHADOW_OFFSET)
+#define C_PI_IPD_MSC_SHADOW_SIZE 0x00000028
+
+union c_pi_ipd_msc_shadow {
+	__u64 qw[5];
+};
+
+#define C_PI_IPD_ERR_ELAPSED_TIME_OFFSET 0x00000100
+#define C_PI_IPD_ERR_ELAPSED_TIME (C_PI_IPD_BASE + C_PI_IPD_ERR_ELAPSED_TIME_OFFSET)
+#define C_PI_IPD_ERR_ELAPSED_TIME_SIZE 0x00000008
+
+union c_pi_ipd_err_elapsed_time {
+	__u64 qw;
+	struct {
+		__u64 nanoseconds : 30;
+		__u64 seconds : 34;
+	};
+};
+
+#define C_PI_IPD_ERR_FLG_OFFSET 0x00000108
+#define C_PI_IPD_ERR_FLG (C_PI_IPD_BASE + C_PI_IPD_ERR_FLG_OFFSET)
+#define C_PI_IPD_ERR_FLG_SIZE 0x00000008
+
+union c_pi_ipd_err_flg {
+	__u64 qw;
+	struct {
+		__u64 sw_diag : 1;
+		__u64 crnc_ring_sync_error : 1;
+		__u64 crnc_ring_ecc_sbe : 1;
+		__u64 crnc_ring_ecc_mbe : 1;
+		__u64 crnc_ring_cmd_unknown : 1;
+		__u64 crnc_csr_cmd_unknown : 1;
+		__u64 crnc_csr_cmd_incomplete : 1;
+		__u64 crnc_buf_ecc_sbe : 1;
+		__u64 crnc_buf_ecc_mbe : 1;
+		__u64: 7;
+		__u64 event_cnt_ovf : 1;
+		__u64 event_ram_cor : 1;
+		__u64 event_ram_ucor : 1;
+		__u64 msix_table_cor : 1;
+		__u64 msix_table_ucor : 1;
+		__u64 msix_pba_cor : 1;
+		__u64 msix_pba_ucor : 1;
+		__u64 pti_tarb_xlat_p_fifo_cor : 4;
+		__u64 pti_tarb_xlat_p_fifo_ucor : 4;
+		__u64 pti_tarb_xlat_np_fifo_cor : 3;
+		__u64 pti_tarb_xlat_np_fifo_ucor : 3;
+		__u64 pti_tarb_xlat_tbuf_cor : 1;
+		__u64 pti_tarb_xlat_tbuf_ucor : 1;
+		__u64 pti_tarb_xlat_cpl_to_fifo_cor : 1;
+		__u64 pti_tarb_xlat_cpl_to_fifo_ucor : 1;
+		__u64 pri_mb_xlat_comp_fifo_cor : 4;
+		__u64 pri_mb_xlat_comp_fifo_ucor : 4;
+		__u64 pti_msixc_fifo_cor : 1;
+		__u64 pti_msixc_fifo_ucor : 1;
+		__u64 msixc_pti_fifo_cor : 1;
+		__u64 msixc_pti_fifo_ucor : 1;
+		__u64 dmac_p_fifo_cor : 4;
+		__u64 dmac_p_fifo_ucor : 4;
+		__u64: 3;
+	};
+};
+
+#define C_PI_IPD_ERR_FIRST_FLG_OFFSET 0x00000110
+#define C_PI_IPD_ERR_FIRST_FLG (C_PI_IPD_BASE + C_PI_IPD_ERR_FIRST_FLG_OFFSET)
+#define C_PI_IPD_ERR_FIRST_FLG_SIZE 0x00000008
+#define C_PI_IPD_ERR_FIRST_FLG_TS_OFFSET 0x00000118
+#define C_PI_IPD_ERR_FIRST_FLG_TS (C_PI_IPD_BASE + C_PI_IPD_ERR_FIRST_FLG_TS_OFFSET)
+#define C_PI_IPD_ERR_FIRST_FLG_TS_SIZE 0x00000008
+#define C_PI_IPD_ERR_CLR_OFFSET 0x00000120
+#define C_PI_IPD_ERR_CLR (C_PI_IPD_BASE + C_PI_IPD_ERR_CLR_OFFSET)
+#define C_PI_IPD_ERR_CLR_SIZE 0x00000008
+#define C_PI_IPD_ERR_IRQA_MSK_OFFSET 0x00000128
+#define C_PI_IPD_ERR_IRQA_MSK (C_PI_IPD_BASE + C_PI_IPD_ERR_IRQA_MSK_OFFSET)
+#define C_PI_IPD_ERR_IRQA_MSK_SIZE 0x00000008
+#define C_PI_IPD_ERR_IRQB_MSK_OFFSET 0x00000130
+#define C_PI_IPD_ERR_IRQB_MSK (C_PI_IPD_BASE + C_PI_IPD_ERR_IRQB_MSK_OFFSET)
+#define C_PI_IPD_ERR_IRQB_MSK_SIZE 0x00000008
+#define C_PI_IPD_ERR_INFO_MSK_OFFSET 0x00000140
+#define C_PI_IPD_ERR_INFO_MSK (C_PI_IPD_BASE + C_PI_IPD_ERR_INFO_MSK_OFFSET)
+#define C_PI_IPD_ERR_INFO_MSK_SIZE 0x00000008
+#define C_PI_IPD_ERR_INFO_MEM_OFFSET 0x00000180
+#define C_PI_IPD_ERR_INFO_MEM (C_PI_IPD_BASE + C_PI_IPD_ERR_INFO_MEM_OFFSET)
+#define C_PI_IPD_ERR_INFO_MEM_SIZE 0x00000008
+
+union c_pi_ipd_err_info_mem {
+	__u64 qw;
+	struct {
+		__u64 cor_syndrome : 10;
+		__u64: 2;
+		__u64 cor_address : 12;
+		__u64: 2;
+		__u64 cor_mem_id : 5;
+		__u64 cor_csr_detected : 1;
+		__u64 ucor_syndrome : 10;
+		__u64: 2;
+		__u64 ucor_address : 12;
+		__u64: 2;
+		__u64 ucor_mem_id : 5;
+		__u64 ucor_csr_detected : 1;
+	};
+};
+
+#define C_PI_IPD_EXT_ERR_FLG_OFFSET 0x00000208
+#define C_PI_IPD_EXT_ERR_FLG (C_PI_IPD_BASE + C_PI_IPD_EXT_ERR_FLG_OFFSET)
+#define C_PI_IPD_EXT_ERR_FLG_SIZE 0x00000008
+
+union c_pi_ipd_ext_err_flg {
+	__u64 qw;
+	struct {
+		__u64 sw_diag : 1;
+		__u64 ip_app_parity_errs : 3;
+		__u64 ip_radm_qoverflow : 1;
+		__u64 ip_radm_msg_unlock : 1;
+		__u64 ip_radm_pm_turnoff : 1;
+		__u64 ip_wake : 1;
+		__u64 ip_cfg_uncor_internal_err_sts : 1;
+		__u64 ip_cfg_corrected_internal_err_sts : 1;
+		__u64 ip_cfg_rcvr_overflow_err_sts : 1;
+		__u64 ip_cfg_fc_protocol_err_sts : 1;
+		__u64 ip_cfg_mlf_tlp_err_sts : 1;
+		__u64 ip_cfg_surprise_down_er_sts : 1;
+		__u64 ip_cfg_dl_protocol_err_sts : 1;
+		__u64 ip_cfg_ecrc_err_sts : 1;
+		__u64 ip_cfg_replay_number_rollover_err_sts : 1;
+		__u64 ip_cfg_replay_timer_timeout_err_sts : 1;
+		__u64 ip_cfg_bad_dllp_err_sts : 1;
+		__u64 ip_cfg_bad_tlp_err_sts : 1;
+		__u64 ip_cfg_rcvr_err_sts : 1;
+		__u64: 5;
+		__u64 pti_tarb_xlat_xali_ph_crd_warn : 1;
+		__u64 pti_tarb_xlat_xali_pd_crd_warn : 1;
+		__u64 pti_tarb_xlat_xali_nph_crd_warn : 1;
+		__u64 pti_tarb_xlat_xali_npd_crd_warn : 1;
+		__u64 pti_tarb_xlat_ten_bit_tag_msb_error : 1;
+		__u64 pti_tarb_xlat_p_fifo_underrun : 1;
+		__u64 pti_tarb_xlat_np_fifo_underrun : 1;
+		__u64 pti_tarb_xlat_ord_fifo_underrun : 1;
+		__u64 pti_tarb_xlat_cpl_to_fifo_overrun : 1;
+		__u64 pti_tarb_xlat_cpl_to_fifo_underrun : 1;
+		__u64 pti_tarb_xlat_pti_pri_cpl_to_fifo_overrun : 1;
+		__u64 pti_tarb_xlat_ord_np_cnt_overrun : 1;
+		__u64 pti_tarb_xlat_ord_np_cnt_underrun : 1;
+		__u64 pri_rtrgt_hdr_parity_error : 1;
+		__u64 pri_rtrgt_data_parity_error : 1;
+		__u64 pri_rtrgt_abort : 1;
+		__u64 pri_rbyp_hdr_parity_error : 1;
+		__u64 pri_rbyp_data_parity_error : 1;
+		__u64 pri_rbyp_abort : 1;
+		__u64 pri_rarb_xlat_rtrgt_fifo_overrun : 1;
+		__u64 pri_rarb_xlat_rtrgt_rdy_fifo_overrun : 1;
+		__u64 pri_rarb_xlat_rbyp_fifo_overrun : 1;
+		__u64 pri_rarb_xlat_rbyp_rdy_fifo_overrun : 1;
+		__u64 pri_mb_xlat_rtrgt_fifo_overrun : 1;
+		__u64 pri_mb_xlat_rtrgt_rdy_fifo_overrun : 1;
+		__u64 pri_mb_xlat_comp_fifo_underrun : 1;
+		__u64 msixc_pti_fifo_overrun : 1;
+		__u64 msixc_pti_fifo_underrun : 1;
+		__u64 pti_msixc_fifo_overrun : 1;
+		__u64 pti_msixc_fifo_underrun : 1;
+		__u64 msix_disabled_error : 1;
+		__u64 msix_hg_vf_size_error : 1;
+		__u64 msix_pti_idx_error : 1;
+		__u64 dmac_bme_error : 1;
+		__u64: 4;
+	};
+};
+
+#define C_PI_IPD_EXT_ERR_FIRST_FLG_OFFSET 0x00000210
+#define C_PI_IPD_EXT_ERR_FIRST_FLG (C_PI_IPD_BASE + C_PI_IPD_EXT_ERR_FIRST_FLG_OFFSET)
+#define C_PI_IPD_EXT_ERR_FIRST_FLG_SIZE 0x00000008
+#define C_PI_IPD_EXT_ERR_FIRST_FLG_TS_OFFSET 0x00000218
+#define C_PI_IPD_EXT_ERR_FIRST_FLG_TS (C_PI_IPD_BASE + C_PI_IPD_EXT_ERR_FIRST_FLG_TS_OFFSET)
+#define C_PI_IPD_EXT_ERR_FIRST_FLG_TS_SIZE 0x00000008
+#define C_PI_IPD_EXT_ERR_CLR_OFFSET 0x00000220
+#define C_PI_IPD_EXT_ERR_CLR (C_PI_IPD_BASE + C_PI_IPD_EXT_ERR_CLR_OFFSET)
+#define C_PI_IPD_EXT_ERR_CLR_SIZE 0x00000008
+#define C_PI_IPD_EXT_ERR_IRQA_MSK_OFFSET 0x00000228
+#define C_PI_IPD_EXT_ERR_IRQA_MSK (C_PI_IPD_BASE + C_PI_IPD_EXT_ERR_IRQA_MSK_OFFSET)
+#define C_PI_IPD_EXT_ERR_IRQA_MSK_SIZE 0x00000008
+#define C_PI_IPD_EXT_ERR_IRQB_MSK_OFFSET 0x00000230
+#define C_PI_IPD_EXT_ERR_IRQB_MSK (C_PI_IPD_BASE + C_PI_IPD_EXT_ERR_IRQB_MSK_OFFSET)
+#define C_PI_IPD_EXT_ERR_IRQB_MSK_SIZE 0x00000008
+#define C_PI_IPD_EXT_ERR_INFO_MSK_OFFSET 0x00000240
+#define C_PI_IPD_EXT_ERR_INFO_MSK (C_PI_IPD_BASE + C_PI_IPD_EXT_ERR_INFO_MSK_OFFSET)
+#define C_PI_IPD_EXT_ERR_INFO_MSK_SIZE 0x00000008
+#define C_PI_IPD_CFG_MSIXC_OFFSET 0x00004000
+#define C_PI_IPD_CFG_MSIXC (C_PI_IPD_BASE + C_PI_IPD_CFG_MSIXC_OFFSET)
+#define C_PI_IPD_CFG_MSIXC_SIZE 0x00000008
+
+union c_pi_ipd_cfg_msixc {
+	__u64 qw;
+	struct {
+		__u64 legacy_irq_enable : 1;
+		__u64 legacy_irq_mask : 1;
+		__u64 legacy_irq_asserted : 1;
+		__u64: 5;
+		__u64 vf_pf_irq_enable : 1;
+		__u64: 55;
+	};
+};
+
+#define C_PI_IPD_CFG_VF_PF_IRQ_MASK_OFFSET 0x00004010
+#define C_PI_IPD_CFG_VF_PF_IRQ_MASK (C_PI_IPD_BASE + C_PI_IPD_CFG_VF_PF_IRQ_MASK_OFFSET)
+#define C_PI_IPD_CFG_VF_PF_IRQ_MASK_SIZE 0x00000008
+
+union c_pi_ipd_cfg_vf_pf_irq_mask {
+	__u64 qw;
+	struct {
+		__u64 mask;
+	};
+};
+
+#define C_PI_IPD_STS_VF_PF_IRQ_OFFSET 0x00004018
+#define C_PI_IPD_STS_VF_PF_IRQ (C_PI_IPD_BASE + C_PI_IPD_STS_VF_PF_IRQ_OFFSET)
+#define C_PI_IPD_STS_VF_PF_IRQ_SIZE 0x00000008
+
+union c_pi_ipd_sts_vf_pf_irq {
+	__u64 qw;
+	struct {
+		__u64 irq;
+	};
+};
+
+#define C_PI_IPD_CFG_VF_PF_IRQ_CLR_OFFSET 0x00004020
+#define C_PI_IPD_CFG_VF_PF_IRQ_CLR (C_PI_IPD_BASE + C_PI_IPD_CFG_VF_PF_IRQ_CLR_OFFSET)
+#define C_PI_IPD_CFG_VF_PF_IRQ_CLR_SIZE 0x00000008
+
+union c_pi_ipd_cfg_vf_pf_irq_clr {
+	__u64 qw;
+	struct {
+		__u64 clr;
+	};
+};
+
+#define C_PI_IPD_CFG_PF_VF_IRQ_OFFSET 0x00004028
+#define C_PI_IPD_CFG_PF_VF_IRQ (C_PI_IPD_BASE + C_PI_IPD_CFG_PF_VF_IRQ_OFFSET)
+#define C_PI_IPD_CFG_PF_VF_IRQ_SIZE 0x00000008
+
+union c_pi_ipd_cfg_pf_vf_irq {
+	__u64 qw;
+	struct {
+		__u64 irq;
+	};
+};
+
+#define C_PI_IPD_CFG_EVENT_CNTS_OFFSET 0x00005000
+#define C_PI_IPD_CFG_EVENT_CNTS (C_PI_IPD_BASE + C_PI_IPD_CFG_EVENT_CNTS_OFFSET)
+#define C_PI_IPD_CFG_EVENT_CNTS_SIZE 0x00000008
+
+union c_pi_ipd_cfg_event_cnts {
+	__u64 qw;
+	struct {
+		__u64 enable : 1;
+		__u64 init : 1;
+		__u64 init_done : 1;
+		__u64 warm_rst_disable : 1;
+		__u64 ovf_cnt : 16;
+		__u64: 44;
+	};
+};
+
+#define C_PI_IPD_STS_EVENT_CNTS_OFFSET(idx) (0x00006000 + ((idx) * 8))
+#ifndef C_PI_IPD_STS_EVENT_CNTS_ENTRIES
+#define C_PI_IPD_STS_EVENT_CNTS_ENTRIES 128
+#endif
+#define C_PI_IPD_STS_EVENT_CNTS(idx) (C_PI_IPD_BASE + C_PI_IPD_STS_EVENT_CNTS_OFFSET(idx))
+#define C_PI_IPD_STS_EVENT_CNTS_SIZE 0x00000400
+
+union c_pi_ipd_sts_event_cnts {
+	__u64 qw;
+	struct {
+		__u64 cnt : 56;
+		__u64: 8;
+	};
+};
+
+#define C_PI_IPD_CFG_MSIX_TABLE_OFFSET(idx) (0x00010000 + ((idx) * 16))
+#define C_PI_IPD_CFG_MSIX_TABLE_ENTRIES 4096
+#define C_PI_IPD_CFG_MSIX_TABLE(idx) (C_PI_IPD_BASE + C_PI_IPD_CFG_MSIX_TABLE_OFFSET(idx))
+#define C_PI_IPD_CFG_MSIX_TABLE_SIZE 0x00010000
+
+union c_pi_ipd_cfg_msix_table {
+	__u64 qw[2];
+	struct {
+		__u64 msg_addr;
+		__u64 msg_data : 32;
+		__u64 vector_ctl_mask : 1;
+		__u64 vector_ctl_rsvd : 31;
+	};
+};
+
+#define C_PI_IPD_CFG_VF_MSIX_TABLE_OFFSET(idx) (0x00400000 + ((idx) * 16))
+#define C_PI_IPD_CFG_VF_MSIX_TABLE_ENTRIES 131072
+#define C_PI_IPD_CFG_VF_MSIX_TABLE(idx) (C_PI_IPD_BASE + C_PI_IPD_CFG_VF_MSIX_TABLE_OFFSET(idx))
+#define C_PI_IPD_CFG_VF_MSIX_TABLE_SIZE 0x00200000
+
+union c_pi_ipd_cfg_vf_msix_table {
+	__u64 qw[2];
+	struct {
+		__u64 msg_addr;
+		__u64 msg_data : 32;
+		__u64 vector_ctl_mask : 1;
+		__u64 vector_ctl_rsvd : 31;
+	};
+};
+
+#define C_RMU_CFG_CRNC_OFFSET 0x00000000
+#define C_RMU_CFG_CRNC (C_RMU_BASE + C_RMU_CFG_CRNC_OFFSET)
+#define C_RMU_CFG_CRNC_SIZE 0x00000008
+
+union c_rmu_cfg_crnc {
+	__u64 qw;
+	struct {
+		__u64 csr_timeout : 8;
+		__u64 mcast_id : 10;
+		__u64: 1;
+		__u64 mcast_enable : 1;
+		__u64 mcast_mask : 10;
+		__u64: 34;
+	};
+};
+
+#define C_RMU_MSC_SHADOW_ACTION_OFFSET 0x00000038
+#define C_RMU_MSC_SHADOW_ACTION (C_RMU_BASE + C_RMU_MSC_SHADOW_ACTION_OFFSET)
+#define C_RMU_MSC_SHADOW_ACTION_SIZE 0x00000008
+#define C_RMU_MSC_SHADOW_OFFSET 0x00000040
+#define C_RMU_MSC_SHADOW (C_RMU_BASE + C_RMU_MSC_SHADOW_OFFSET)
+#define C_RMU_MSC_SHADOW_SIZE 0x00000020
+
+union c_rmu_msc_shadow {
+	__u64 qw[4];
+};
+
+#define C_RMU_ERR_ELAPSED_TIME_OFFSET 0x00000100
+#define C_RMU_ERR_ELAPSED_TIME (C_RMU_BASE + C_RMU_ERR_ELAPSED_TIME_OFFSET)
+#define C_RMU_ERR_ELAPSED_TIME_SIZE 0x00000008
+
+union c_rmu_err_elapsed_time {
+	__u64 qw;
+	struct {
+		__u64 nanoseconds : 30;
+		__u64 seconds : 34;
+	};
+};
+
+#define C_RMU_ERR_FLG_OFFSET 0x00000108
+#define C_RMU_ERR_FLG (C_RMU_BASE + C_RMU_ERR_FLG_OFFSET)
+#define C_RMU_ERR_FLG_SIZE 0x00000008
+
+union c_rmu_err_flg {
+	__u64 qw;
+	struct {
+		__u64 sw_diag : 1;
+		__u64 crnc_ring_sync_error : 1;
+		__u64 crnc_ring_ecc_sbe : 1;
+		__u64 crnc_ring_ecc_mbe : 1;
+		__u64 crnc_ring_cmd_unknown : 1;
+		__u64 crnc_csr_cmd_unknown : 1;
+		__u64 crnc_csr_cmd_incomplete : 1;
+		__u64 crnc_buf_ecc_sbe : 1;
+		__u64 crnc_buf_ecc_mbe : 1;
+		__u64: 23;
+		__u64 ptl_idx_mem_cor : 1;
+		__u64 ptlte_set_ctrl_mem_cor : 1;
+		__u64 ptl_idx_indir_mem_cor : 1;
+		__u64: 1;
+		__u64 vni_list_mem_ucor : 1;
+		__u64 vni_list_vld_mem_ucor : 1;
+		__u64 ptl_list_mem_ucor : 1;
+		__u64 ptl_list_vld_mem_ucor : 1;
+		__u64 ptl_idx_mem_ucor : 1;
+		__u64 ptlte_set_list_mem_ucor : 1;
+		__u64 ptlte_set_list_vld_mem_ucor : 1;
+		__u64 ptlte_set_ctrl_mem_ucor : 1;
+		__u64 ptl_idx_indir_mem_ucor : 1;
+		__u64: 3;
+		__u64 ptl_invld_dfa : 1;
+		__u64 ptl_invld_vni : 1;
+		__u64 ptl_no_ptlte : 1;
+		__u64 enet_frame_rejected : 1;
+		__u64 enet_ptlte_set_ctrl_err : 1;
+		__u64: 11;
+	};
+};
+
+#define C_RMU_ERR_FIRST_FLG_OFFSET 0x00000110
+#define C_RMU_ERR_FIRST_FLG (C_RMU_BASE + C_RMU_ERR_FIRST_FLG_OFFSET)
+#define C_RMU_ERR_FIRST_FLG_SIZE 0x00000008
+#define C_RMU_ERR_FIRST_FLG_TS_OFFSET 0x00000118
+#define C_RMU_ERR_FIRST_FLG_TS (C_RMU_BASE + C_RMU_ERR_FIRST_FLG_TS_OFFSET)
+#define C_RMU_ERR_FIRST_FLG_TS_SIZE 0x00000008
+#define C_RMU_ERR_CLR_OFFSET 0x00000120
+#define C_RMU_ERR_CLR (C_RMU_BASE + C_RMU_ERR_CLR_OFFSET)
+#define C_RMU_ERR_CLR_SIZE 0x00000008
+#define C_RMU_ERR_IRQA_MSK_OFFSET 0x00000128
+#define C_RMU_ERR_IRQA_MSK (C_RMU_BASE + C_RMU_ERR_IRQA_MSK_OFFSET)
+#define C_RMU_ERR_IRQA_MSK_SIZE 0x00000008
+#define C_RMU_ERR_IRQB_MSK_OFFSET 0x00000130
+#define C_RMU_ERR_IRQB_MSK (C_RMU_BASE + C_RMU_ERR_IRQB_MSK_OFFSET)
+#define C_RMU_ERR_IRQB_MSK_SIZE 0x00000008
+#define C_RMU_ERR_INFO_MSK_OFFSET 0x00000140
+#define C_RMU_ERR_INFO_MSK (C_RMU_BASE + C_RMU_ERR_INFO_MSK_OFFSET)
+#define C_RMU_ERR_INFO_MSK_SIZE 0x00000008
+#define C_RMU_ERR_INFO_MEM_OFFSET 0x00000180
+#define C_RMU_ERR_INFO_MEM (C_RMU_BASE + C_RMU_ERR_INFO_MEM_OFFSET)
+#define C_RMU_ERR_INFO_MEM_SIZE 0x00000008
+
+union c_rmu_err_info_mem {
+	__u64 qw;
+	struct {
+		__u64 cor_syndrome : 12;
+		__u64 cor_address : 13;
+		__u64: 1;
+		__u64 cor_mem_id : 4;
+		__u64: 1;
+		__u64 cor_csr_detected : 1;
+		__u64 ucor_syndrome : 12;
+		__u64 ucor_address : 13;
+		__u64: 1;
+		__u64 ucor_mem_id : 4;
+		__u64: 1;
+		__u64 ucor_csr_detected : 1;
+	};
+};
+
+#define C_RMU_ERR_INFO_PTL_INVLD_DFA_OFFSET 0x00000188
+#define C_RMU_ERR_INFO_PTL_INVLD_DFA (C_RMU_BASE + C_RMU_ERR_INFO_PTL_INVLD_DFA_OFFSET)
+#define C_RMU_ERR_INFO_PTL_INVLD_DFA_SIZE 0x00000008
+
+union c_rmu_err_info_ptl_invld_dfa {
+	__u64 qw;
+	struct {
+		__u64 dfa : 32;
+		__u64 sfa : 32;
+	};
+};
+
+#define C_RMU_ERR_INFO_PTL_INVLD_VNI_OFFSET 0x00000190
+#define C_RMU_ERR_INFO_PTL_INVLD_VNI (C_RMU_BASE + C_RMU_ERR_INFO_PTL_INVLD_VNI_OFFSET)
+#define C_RMU_ERR_INFO_PTL_INVLD_VNI_SIZE 0x00000008
+
+union c_rmu_err_info_ptl_invld_vni {
+	__u64 qw;
+	struct {
+		__u64 vni : 16;
+		__u64: 16;
+		__u64 sfa : 32;
+	};
+};
+
+#define C_RMU_ERR_INFO_PTL_NO_PTLTE_OFFSET 0x00000198
+#define C_RMU_ERR_INFO_PTL_NO_PTLTE (C_RMU_BASE + C_RMU_ERR_INFO_PTL_NO_PTLTE_OFFSET)
+#define C_RMU_ERR_INFO_PTL_NO_PTLTE_SIZE 0x00000008
+
+union c_rmu_err_info_ptl_no_ptlte {
+	__u64 qw;
+	struct {
+		__u64 index_ext : 5;
+		__u64 multicast_id : 13;
+		__u64: 2;
+		__u64 is_multicast : 1;
+		__u64: 3;
+		__u64 vni_list_idx : 8;
+		__u64 sfa : 32;
+	};
+};
+
+#define C_RMU_ERR_INFO_ENET_NO_PTLTE_SET_OFFSET 0x000001c0
+#define C_RMU_ERR_INFO_ENET_NO_PTLTE_SET (C_RMU_BASE + C_RMU_ERR_INFO_ENET_NO_PTLTE_SET_OFFSET)
+#define C_RMU_ERR_INFO_ENET_NO_PTLTE_SET_SIZE 0x00000028
+
+union c_rmu_err_info_enet_no_ptlte_set {
+	__u64 qw[5];
+	struct {
+		union {
+			struct {
+				__u64 dipv6_lower;
+				__u64 dipv6_upper;
+				__u64 sipv6_lower;
+				__u64 sipv6_upper;
+			};
+			struct {
+				__u32 dipv4;
+				__u32 unused_opt_ipv4_0;
+				__u64 unused_opt_ipv4_1;
+				__u32 sipv4;
+				__u32 unused_opt_ipv4_2;
+				__u64 unused_opt_ipv4_3;
+			};
+			struct {
+				__u64 dmac : 48;
+				__u64 vid : 12;
+				__u64 dei : 1;
+				__u64 pcp : 3;
+				__u64 vlan_present : 1;
+				__u64 unused_ieee_802_3_0 : 63;
+			};
+		};
+		__u64 smac : 48;
+		__u64 tc : 3;
+		__u64: 1;
+		__u64 lossless : 1;
+		__u64: 3;
+		__u64 frame_type : 2;
+		__u64 ip_v4_present : 1;
+		__u64 ip_v6_present : 1;
+		__u64: 4;
+	};
+};
+
+#define C_RMU_ERR_INFO_ENET_BAD_PTLTE_SET_CTRL_OFFSET 0x000001e8
+#define C_RMU_ERR_INFO_ENET_BAD_PTLTE_SET_CTRL                                                     \
+	(C_RMU_BASE + C_RMU_ERR_INFO_ENET_BAD_PTLTE_SET_CTRL_OFFSET)
+#define C_RMU_ERR_INFO_ENET_BAD_PTLTE_SET_CTRL_SIZE 0x00000008
+
+union c_rmu_err_info_enet_bad_ptlte_set_ctrl {
+	__u64 qw;
+	struct {
+		__u64 ptlte_set_ctrl_entry : 7;
+		__u64: 1;
+		__u64 hash_type : 5;
+		__u64: 3;
+		__u64 portal_index_indir_base : 11;
+		__u64: 1;
+		__u64 hash_bits : 4;
+		__u64 hash_value : 32;
+	};
+};
+
+#define C_RMU_CFG_VNI_LIST_X_OFFSET(idx) (0x00001000 + ((idx) * 8))
+#define C_RMU_CFG_VNI_LIST_X(idx) (C_RMU_BASE + C_RMU_CFG_VNI_LIST_X_OFFSET(idx))
+#define C_RMU_CFG_VNI_LIST_X_SIZE 0x00000800
+#define C_RMU_CFG_VNI_LIST_Y_OFFSET(idx) (0x00001800 + ((idx) * 8))
+#define C_RMU_CFG_VNI_LIST_ENTRIES 256
+#define C_RMU_CFG_VNI_LIST_Y(idx) (C_RMU_BASE + C_RMU_CFG_VNI_LIST_Y_OFFSET(idx))
+#define C_RMU_CFG_VNI_LIST_Y_SIZE 0x00000800
+
+union c_rmu_cfg_vni_list {
+	__u64 qw;
+	struct {
+		__u64 vni : 16;
+		__u64 valid : 1;
+		__u64: 47;
+	};
+};
+
+#define C_RMU_CFG_VNI_LIST_INVALIDATE_OFFSET(idx) (0x00002000 + ((idx) * 8))
+#define C_RMU_CFG_VNI_LIST_INVALIDATE(idx) (C_RMU_BASE + C_RMU_CFG_VNI_LIST_INVALIDATE_OFFSET(idx))
+#define C_RMU_CFG_VNI_LIST_INVALIDATE_SIZE 0x00000800
+
+union c_rmu_cfg_vni_list_invalidate {
+	__u64 qw;
+	struct {
+		__u64 invalidate : 1;
+		__u64: 63;
+	};
+};
+
+#define C_RMU_CFG_VNI_LIST_CHK_OFFSET 0x00000400
+#define C_RMU_CFG_VNI_LIST_CHK (C_RMU_BASE + C_RMU_CFG_VNI_LIST_CHK_OFFSET)
+#define C_RMU_CFG_VNI_LIST_CHK_SIZE 0x00000008
+
+union c_rmu_cfg_vni_list_chk {
+	__u64 qw;
+	struct {
+		__u64 intrvl : 32;
+		__u64: 32;
+	};
+};
+
+#define C_RMU_CFG_PORTAL_LIST_X_OFFSET(idx) (0x00010000 + ((idx) * 8))
+#define C_RMU_CFG_PORTAL_LIST_X(idx) (C_RMU_BASE + C_RMU_CFG_PORTAL_LIST_X_OFFSET(idx))
+#define C_RMU_CFG_PORTAL_LIST_X_SIZE 0x00005000
+#define C_RMU_CFG_PORTAL_LIST_Y_OFFSET(idx) (0x00018000 + ((idx) * 8))
+#define C_RMU_CFG_PORTAL_LIST_ENTRIES 2560
+#define C_RMU_CFG_PORTAL_LIST_Y(idx) (C_RMU_BASE + C_RMU_CFG_PORTAL_LIST_Y_OFFSET(idx))
+#define C_RMU_CFG_PORTAL_LIST_Y_SIZE 0x00005000
+
+union c_rmu_cfg_portal_list {
+	__u64 qw;
+	struct {
+		union {
+			struct {
+				__u64 index_ext : 5;
+				__u64 multicast_id : 13;
+				__u64: 2;
+				__u64 is_multicast : 1;
+				__u64: 3;
+				__u64 vni_list_idx : 8;
+				__u64 valid : 1;
+				__u64: 31;
+			};
+			struct {
+				__u64: 5;
+				__u64 endpoint_defined : 12;
+				__u64: 7;
+			};
+		};
+	};
+};
+
+#define C_RMU_CFG_PORTAL_LIST_INVALIDATE_OFFSET(idx) (0x00020000 + ((idx) * 8))
+#define C_RMU_CFG_PORTAL_LIST_INVALIDATE(idx)                                                      \
+	(C_RMU_BASE + C_RMU_CFG_PORTAL_LIST_INVALIDATE_OFFSET(idx))
+#define C_RMU_CFG_PORTAL_LIST_INVALIDATE_SIZE 0x00005000
+
+union c_rmu_cfg_portal_list_invalidate {
+	__u64 qw;
+	struct {
+		__u64 invalidate : 1;
+		__u64: 63;
+	};
+};
+
+#define C_RMU_CFG_PORTAL_LIST_CHK_OFFSET 0x00000408
+#define C_RMU_CFG_PORTAL_LIST_CHK (C_RMU_BASE + C_RMU_CFG_PORTAL_LIST_CHK_OFFSET)
+#define C_RMU_CFG_PORTAL_LIST_CHK_SIZE 0x00000008
+
+union c_rmu_cfg_portal_list_chk {
+	__u64 qw;
+	struct {
+		__u64 intrvl : 32;
+		__u64: 32;
+	};
+};
+
+#define C_RMU_CFG_PORTAL_INDEX_TABLE_OFFSET(idx) (0x00004000 + ((idx) * 8))
+#define C_RMU_CFG_PORTAL_INDEX_TABLE_ENTRIES 640
+#define C_RMU_CFG_PORTAL_INDEX_TABLE(idx) (C_RMU_BASE + C_RMU_CFG_PORTAL_INDEX_TABLE_OFFSET(idx))
+#define C_RMU_CFG_PORTAL_INDEX_TABLE_SIZE 0x00001400
+
+#define C_RMU_CFG_PORTAL_INDEX_TABLE_ARRAY_SIZE 4
+union c_rmu_cfg_portal_index_table {
+	__u64 qw;
+	struct {
+		__u16 phys_portal_table_idx : 11;
+		__u16: 5;
+	} e[C_RMU_CFG_PORTAL_INDEX_TABLE_ARRAY_SIZE];
+};
+
+#define C_RMU_CFG_PTLTE_SET_LIST_X_OFFSET(idx) (0x00006000 + ((idx) * 32))
+#define C_RMU_CFG_PTLTE_SET_LIST_X(idx) (C_RMU_BASE + C_RMU_CFG_PTLTE_SET_LIST_X_OFFSET(idx))
+#define C_RMU_CFG_PTLTE_SET_LIST_X_SIZE 0x00001000
+#define C_RMU_CFG_PTLTE_SET_LIST_Y_OFFSET(idx) (0x00007000 + ((idx) * 32))
+#define C_RMU_CFG_PTLTE_SET_LIST_ENTRIES 128
+#define C_RMU_CFG_PTLTE_SET_LIST_Y(idx) (C_RMU_BASE + C_RMU_CFG_PTLTE_SET_LIST_Y_OFFSET(idx))
+#define C_RMU_CFG_PTLTE_SET_LIST_Y_SIZE 0x00001000
+
+union c_rmu_cfg_ptlte_set_list {
+	__u64 qw[4];
+	struct {
+		union {
+			struct {
+				__u64 dmac : 48;
+				__u64 vid : 12;
+				__u64 dei : 1;
+				__u64 pcp : 3;
+			};
+			__u64 dipv6[2];
+			struct {
+				__u32 dipv4;
+				__u32 opt_ipv4_unused_0;
+				union {
+					struct {
+						__u64 vlan_present : 1;
+						__u64 ieee_802_3_unused : 63;
+					};
+					__u64 opt_ipv4_unused_1;
+				};
+			};
+		};
+		__u64 lossless : 1;
+		__u64: 7;
+		__u64 frame_type : 2;
+		__u64: 54;
+		__u64 valid : 1;
+		__u64: 63;
+	};
+};
+
+#define C_RMU_CFG_PTLTE_SET_LIST_INVALIDATE_OFFSET(idx) (0x00008000 + ((idx) * 32))
+#define C_RMU_CFG_PTLTE_SET_LIST_INVALIDATE(idx)                                                   \
+	(C_RMU_BASE + C_RMU_CFG_PTLTE_SET_LIST_INVALIDATE_OFFSET(idx))
+#define C_RMU_CFG_PTLTE_SET_LIST_INVALIDATE_SIZE 0x00001000
+
+union c_rmu_cfg_ptlte_set_list_invalidate {
+	__u64 qw;
+	struct {
+		__u64 invalidate : 1;
+		__u64: 63;
+	};
+};
+
+#define C_RMU_CFG_PTLTE_SET_LIST_CHK_OFFSET 0x00000418
+#define C_RMU_CFG_PTLTE_SET_LIST_CHK (C_RMU_BASE + C_RMU_CFG_PTLTE_SET_LIST_CHK_OFFSET)
+#define C_RMU_CFG_PTLTE_SET_LIST_CHK_SIZE 0x00000008
+
+union c_rmu_cfg_ptlte_set_list_chk {
+	__u64 qw;
+	struct {
+		__u64 intrvl : 32;
+		__u64: 32;
+	};
+};
+
+#define C_RMU_CFG_PTLTE_SET_CTRL_TABLE_OFFSET(idx) (0x00009000 + ((idx) * 8))
+#define C_RMU_CFG_PTLTE_SET_CTRL_TABLE_ENTRIES 64
+#define C_RMU_CFG_PTLTE_SET_CTRL_TABLE(idx)                                                        \
+	(C_RMU_BASE + C_RMU_CFG_PTLTE_SET_CTRL_TABLE_OFFSET(idx))
+#define C_RMU_CFG_PTLTE_SET_CTRL_TABLE_SIZE 0x00000200
+
+struct c_rmu_cfg_ptlte_set_ctrl_table_entry {
+	__u32 portal_index_indir_base : 11;
+	__u32: 1;
+	__u32 hash_bits : 4;
+	__u32 hash_types_enabled : 16;
+};
+
+#define C_RMU_CFG_PTLTE_SET_CTRL_TABLE_ARRAY_SIZE 2
+union c_rmu_cfg_ptlte_set_ctrl_table {
+	__u64 qw;
+	struct c_rmu_cfg_ptlte_set_ctrl_table_entry e[C_RMU_CFG_PTLTE_SET_CTRL_TABLE_ARRAY_SIZE];
+};
+
+#define C_RMU_CFG_PORTAL_INDEX_INDIR_TABLE_OFFSET(idx) (0x0000a000 + ((idx) * 8))
+#define C_RMU_CFG_PORTAL_INDEX_INDIR_TABLE_ENTRIES 544
+#define C_RMU_CFG_PORTAL_INDEX_INDIR_TABLE(idx)                                                    \
+	(C_RMU_BASE + C_RMU_CFG_PORTAL_INDEX_INDIR_TABLE_OFFSET(idx))
+#define C_RMU_CFG_PORTAL_INDEX_INDIR_TABLE_SIZE 0x00001100
+
+#define C_RMU_CFG_PORTAL_INDEX_INDIR_TABLE_ARRAY_SIZE 4
+union c_rmu_cfg_portal_index_indir_table {
+	__u64 qw;
+	struct {
+		__u16 phys_portal_table_idx : 11;
+		__u16: 5;
+	} e[C_RMU_CFG_PORTAL_INDEX_INDIR_TABLE_ARRAY_SIZE];
+};
+
+#define C_RMU_CFG_HASH_KEY_OFFSET 0x00000440
+#define C_RMU_CFG_HASH_KEY (C_RMU_BASE + C_RMU_CFG_HASH_KEY_OFFSET)
+#define C_RMU_CFG_HASH_KEY_SIZE 0x00000030
+
+union c_rmu_cfg_hash_key {
+	__u64 qw[6];
+	struct {
+		__u64 key_wd_0;
+		__u64 key_wd_1;
+		__u64 key_wd_2;
+		__u64 key_wd_3;
+		__u64 key_wd_4;
+		__u64 key_wd_5 : 31;
+		__u64: 33;
+	};
+};
+
+#define C_RMU_STS_INIT_DONE_OFFSET 0x00000818
+#define C_RMU_STS_INIT_DONE (C_RMU_BASE + C_RMU_STS_INIT_DONE_OFFSET)
+#define C_RMU_STS_INIT_DONE_SIZE 0x00000008
+
+union c_rmu_sts_init_done {
+	__u64 qw;
+	struct {
+		__u64 init_done : 1;
+		__u64 warm_reset : 1;
+		__u64: 62;
+	};
+};
+
+#define C2_HNI_EXT_ERR_FLG_OFFSET 0x00000148
+#define C2_HNI_EXT_ERR_FLG (C_HNI_BASE + C2_HNI_EXT_ERR_FLG_OFFSET)
+#define C2_HNI_EXT_ERR_FLG_SIZE 0x00000008
+
+union c2_hni_ext_err_flg {
+	__u64 qw;
+	struct {
+		__u64 sw_diag : 1;
+		__u64 pmi_err : 1;
+		__u64 fsm_err : 1;
+		__u64 pmi_ack : 1;
+		__u64 rx_ctrl_perr : 1;
+		__u64 tx_ctrl_perr : 1;
+		__u64: 58;
+	};
+};
+
+#define C2_HNI_EXT_ERR_FIRST_FLG_OFFSET 0x00000150
+#define C2_HNI_EXT_ERR_FIRST_FLG (C_HNI_BASE + C2_HNI_EXT_ERR_FIRST_FLG_OFFSET)
+#define C2_HNI_EXT_ERR_FIRST_FLG_SIZE 0x00000008
+#define C2_HNI_EXT_ERR_FIRST_FLG_TS_OFFSET 0x00000158
+#define C2_HNI_EXT_ERR_FIRST_FLG_TS (C_HNI_BASE + C2_HNI_EXT_ERR_FIRST_FLG_TS_OFFSET)
+#define C2_HNI_EXT_ERR_FIRST_FLG_TS_SIZE 0x00000008
+#define C2_HNI_EXT_ERR_CLR_OFFSET 0x00000160
+#define C2_HNI_EXT_ERR_CLR (C_HNI_BASE + C2_HNI_EXT_ERR_CLR_OFFSET)
+#define C2_HNI_EXT_ERR_CLR_SIZE 0x00000008
+#define C2_HNI_EXT_ERR_IRQA_MSK_OFFSET 0x00000168
+#define C2_HNI_EXT_ERR_IRQA_MSK (C_HNI_BASE + C2_HNI_EXT_ERR_IRQA_MSK_OFFSET)
+#define C2_HNI_EXT_ERR_IRQA_MSK_SIZE 0x00000008
+#define C2_HNI_EXT_ERR_IRQB_MSK_OFFSET 0x00000170
+#define C2_HNI_EXT_ERR_IRQB_MSK (C_HNI_BASE + C2_HNI_EXT_ERR_IRQB_MSK_OFFSET)
+#define C2_HNI_EXT_ERR_IRQB_MSK_SIZE 0x00000008
+#define C2_HNI_EXT_ERR_INFO_MSK_OFFSET 0x00000180
+#define C2_HNI_EXT_ERR_INFO_MSK (C_HNI_BASE + C2_HNI_EXT_ERR_INFO_MSK_OFFSET)
+#define C2_HNI_EXT_ERR_INFO_MSK_SIZE 0x00000008
+#define C2_HNI_EXT_ERR_INFO_PMI_OFFSET 0x000001c8
+#define C2_HNI_EXT_ERR_INFO_PMI (C_HNI_BASE + C2_HNI_EXT_ERR_INFO_PMI_OFFSET)
+#define C2_HNI_EXT_ERR_INFO_PMI_SIZE 0x00000008
+
+union c2_hni_ext_err_info_pmi {
+	__u64 qw;
+	struct {
+		__u64 pmi_lp_error : 1;
+		__u64: 63;
+	};
+};
+
+#define C2_HNI_EXT_ERR_INFO_FSM_OFFSET 0x000001d0
+#define C2_HNI_EXT_ERR_INFO_FSM (C_HNI_BASE + C2_HNI_EXT_ERR_INFO_FSM_OFFSET)
+#define C2_HNI_EXT_ERR_INFO_FSM_SIZE 0x00000008
+
+union c2_hni_ext_err_info_fsm {
+	__u64 qw;
+	struct {
+		__u64 fsm_timeout : 1;
+		__u64 fsm_illegal_access : 1;
+		__u64: 62;
+	};
+};
+
+#define C2_HNI_SERDES_PMI_DATA_OFFSET 0x00000a08
+#define C2_HNI_SERDES_PMI_DATA (C_HNI_BASE + C2_HNI_SERDES_PMI_DATA_OFFSET)
+#define C2_HNI_SERDES_PMI_DATA_SIZE 0x00000008
+
+union c2_hni_serdes_pmi_data {
+	__u64 qw;
+	struct {
+		__u64 pmi_lp_rddata : 16;
+		__u64 pmi_lp_wrdata : 16;
+		__u64 pmi_lp_maskdata : 16;
+		__u64: 16;
+	};
+};
+
+#define C2_HNI_SERDES_PMI_CTL_OFFSET 0x00000a10
+#define C2_HNI_SERDES_PMI_CTL (C_HNI_BASE + C2_HNI_SERDES_PMI_CTL_OFFSET)
+#define C2_HNI_SERDES_PMI_CTL_SIZE 0x00000008
+
+union c2_hni_serdes_pmi_ctl {
+	__u64 qw;
+	struct {
+		__u64 pmi_lp_addr : 32;
+		__u64 pmi_lp_write : 1;
+		__u64 pmi_lp_read_vld : 1;
+		__u64 pmi_lp_ack : 1;
+		__u64 pmi_lp_error : 1;
+		__u64 pmi_lp_en : 1;
+		__u64: 27;
+	};
+};
+
+#define SS2_PORT_PML_CFG_CRNC_OFFSET 0x00000000
+#define SS2_PORT_PML_CFG_CRNC (C_HNI_PML_BASE + SS2_PORT_PML_CFG_CRNC_OFFSET)
+#define SS2_PORT_PML_CFG_CRNC_SIZE 0x00000008
+
+union ss2_port_pml_cfg_crnc {
+	__u64 qw;
+	struct {
+		__u64 csr_timeout : 8;
+		__u64 mcast_id : 10;
+		__u64: 1;
+		__u64 mcast_enable : 1;
+		__u64 mcast_mask : 10;
+		__u64: 34;
+	};
+};
+
+#define SS2_PORT_PML_MSC_SHADOW_ACTION_OFFSET 0x00000028
+#define SS2_PORT_PML_MSC_SHADOW_ACTION (C_HNI_PML_BASE + SS2_PORT_PML_MSC_SHADOW_ACTION_OFFSET)
+#define SS2_PORT_PML_MSC_SHADOW_ACTION_SIZE 0x00000008
+#define SS2_PORT_PML_MSC_SHADOW_OFFSET 0x00000030
+#define SS2_PORT_PML_MSC_SHADOW (C_HNI_PML_BASE + SS2_PORT_PML_MSC_SHADOW_OFFSET)
+#define SS2_PORT_PML_MSC_SHADOW_SIZE 0x00000040
+
+union ss2_port_pml_msc_shadow {
+	__u64 qw[5];
+};
+
+#define SS2_PORT_PML_ERR_ELAPSED_TIME_OFFSET 0x00000100
+#define SS2_PORT_PML_ERR_ELAPSED_TIME (C_HNI_PML_BASE + SS2_PORT_PML_ERR_ELAPSED_TIME_OFFSET)
+#define SS2_PORT_PML_ERR_ELAPSED_TIME_SIZE 0x00000008
+
+union ss2_port_pml_err_elapsed_time {
+	__u64 qw;
+	struct {
+		__u64 nanoseconds : 30;
+		__u64 seconds : 34;
+	};
+};
+
+#define SS2_PORT_PML_ERR_INFO_EDC_COR_OFFSET 0x00000300
+#define SS2_PORT_PML_ERR_INFO_EDC_COR (C_HNI_PML_BASE + SS2_PORT_PML_ERR_INFO_EDC_COR_OFFSET)
+#define SS2_PORT_PML_ERR_INFO_EDC_COR_SIZE 0x00000008
+
+union ss2_port_pml_err_info_edc_cor {
+	__u64 qw;
+	struct {
+		__u64 syndrome : 12;
+		__u64 address : 14;
+		__u64: 1;
+		__u64 csr_detected : 1;
+		__u64 mem_id : 5;
+		__u64: 31;
+	};
+};
+
+#define SS2_PORT_PML_ERR_INFO_EDC_UCOR_OFFSET 0x00000308
+#define SS2_PORT_PML_ERR_INFO_EDC_UCOR (C_HNI_PML_BASE + SS2_PORT_PML_ERR_INFO_EDC_UCOR_OFFSET)
+#define SS2_PORT_PML_ERR_INFO_EDC_UCOR_SIZE 0x00000008
+
+union ss2_port_pml_err_info_edc_ucor {
+	__u64 qw;
+	struct {
+		__u64 syndrome : 12;
+		__u64 address : 14;
+		__u64: 1;
+		__u64 csr_detected : 1;
+		__u64 mem_id : 5;
+		__u64: 31;
+	};
+};
+
+#define SS2_PORT_PML_ERR_INFO_LLR_TX_DP_SBE_OFFSET 0x00000360
+#define SS2_PORT_PML_ERR_INFO_LLR_TX_DP_SBE                                                        \
+	(C_HNI_PML_BASE + SS2_PORT_PML_ERR_INFO_LLR_TX_DP_SBE_OFFSET)
+#define SS2_PORT_PML_ERR_INFO_LLR_TX_DP_SBE_SIZE 0x00000008
+
+union ss2_port_pml_err_info_llr_tx_dp_sbe {
+	__u64 qw;
+	struct {
+		__u64 syndrome : 11;
+		__u64: 5;
+		__u64 subport : 2;
+		__u64: 6;
+		__u64 dp_id : 3;
+		__u64: 37;
+	};
+};
+
+#define SS2_PORT_PML_ERR_INFO_LLR_TX_DP_MBE_OFFSET 0x00000368
+#define SS2_PORT_PML_ERR_INFO_LLR_TX_DP_MBE                                                        \
+	(C_HNI_PML_BASE + SS2_PORT_PML_ERR_INFO_LLR_TX_DP_MBE_OFFSET)
+#define SS2_PORT_PML_ERR_INFO_LLR_TX_DP_MBE_SIZE 0x00000008
+
+union ss2_port_pml_err_info_llr_tx_dp_mbe {
+	__u64 qw;
+	struct {
+		__u64 syndrome : 11;
+		__u64: 5;
+		__u64 subport : 2;
+		__u64: 6;
+		__u64 dp_id : 3;
+		__u64: 37;
+	};
+};
+
+#define SS2_PORT_PML_CFG_GENERAL_OFFSET 0x00000400
+#define SS2_PORT_PML_CFG_GENERAL (C_HNI_PML_BASE + SS2_PORT_PML_CFG_GENERAL_OFFSET)
+#define SS2_PORT_PML_CFG_GENERAL_SIZE 0x00000008
+
+union ss2_port_pml_cfg_general {
+	__u64 qw;
+	struct {
+		__u64 clock_period_ps : 11;
+		__u64: 53;
+	};
+};
+
+#define SS2_PORT_PML_CFG_PORT_GROUP_OFFSET 0x00000408
+#define SS2_PORT_PML_CFG_PORT_GROUP (C_HNI_PML_BASE + SS2_PORT_PML_CFG_PORT_GROUP_OFFSET)
+#define SS2_PORT_PML_CFG_PORT_GROUP_SIZE 0x00000008
+
+union ss2_port_pml_cfg_port_group {
+	__u64 qw;
+	struct {
+		__u64 pg_cfg : 2;
+		__u64: 6;
+		__u64 link_function : 4;
+		__u64: 52;
+	};
+};
+
+#define SS2_PORT_PML_CFG_SUBPORT_RESET_OFFSET(idx) (0x00000420 + ((idx) * 8))
+#define SS2_PORT_PML_CFG_SUBPORT_RESET_ENTRIES 4
+#define SS2_PORT_PML_CFG_SUBPORT_RESET(idx)                                                        \
+	(C_HNI_PML_BASE + SS2_PORT_PML_CFG_SUBPORT_RESET_OFFSET(idx))
+#define SS2_PORT_PML_CFG_SUBPORT_RESET_SIZE 0x00000020
+
+union ss2_port_pml_cfg_subport_reset {
+	__u64 qw;
+	struct {
+		__u64 warm_rst_from_csr : 1;
+		__u64: 63;
+	};
+};
+
+#define SS2_PORT_PML_CFG_PCS_SUBPORT_OFFSET(idx) (0x00000520 + ((idx) * 8))
+#define SS2_PORT_PML_CFG_PCS_SUBPORT_ENTRIES 4
+#define SS2_PORT_PML_CFG_PCS_SUBPORT(idx)                                                          \
+	(C_HNI_PML_BASE + SS2_PORT_PML_CFG_PCS_SUBPORT_OFFSET(idx))
+#define SS2_PORT_PML_CFG_PCS_SUBPORT_SIZE 0x00000020
+
+union ss2_port_pml_cfg_pcs_subport {
+	__u64 qw;
+	struct {
+		__u64 pcs_enable : 1;
+		__u64 enable_auto_neg : 1;
+		__u64: 14;
+		__u64 ll_fec : 1;
+		__u64: 47;
+	};
+};
+
+#define SS2_PORT_PML_CFG_TX_PCS_SUBPORT_OFFSET(idx) (0x000006a0 + ((idx) * 8))
+#define SS2_PORT_PML_CFG_TX_PCS_SUBPORT_ENTRIES 4
+#define SS2_PORT_PML_CFG_TX_PCS_SUBPORT(idx)                                                       \
+	(C_HNI_PML_BASE + SS2_PORT_PML_CFG_TX_PCS_SUBPORT_OFFSET(idx))
+#define SS2_PORT_PML_CFG_TX_PCS_SUBPORT_SIZE 0x00000020
+
+union ss2_port_pml_cfg_tx_pcs_subport {
+	__u64 qw;
+	struct {
+		__u64 enable_ctl_os : 1;
+		__u64 ctl_os_rate : 1;
+		__u64: 2;
+		__u64 gearbox_credits : 5;
+		__u64: 55;
+	};
+};
+
+#define SS2_PORT_PML_CFG_RX_PCS_SUBPORT_OFFSET(idx) (0x000006e0 + ((idx) * 8))
+#define SS2_PORT_PML_CFG_RX_PCS_SUBPORT_ENTRIES 4
+#define SS2_PORT_PML_CFG_RX_PCS_SUBPORT(idx)                                                       \
+	(C_HNI_PML_BASE + SS2_PORT_PML_CFG_RX_PCS_SUBPORT_OFFSET(idx))
+#define SS2_PORT_PML_CFG_RX_PCS_SUBPORT_SIZE 0x00000020
+
+union ss2_port_pml_cfg_rx_pcs_subport {
+	__u64 qw;
+	struct {
+		__u64 enable_rx_sm : 1;
+		__u64 enable_ctl_os : 1;
+		__u64 enable_lock : 1;
+		__u64: 5;
+		__u64 rs_mode : 3;
+		__u64: 53;
+	};
+};
+
+#define SS2_PORT_PML_CFG_TX_MAC_SUBPORT_OFFSET(idx) (0x00000820 + ((idx) * 8))
+#define SS2_PORT_PML_CFG_TX_MAC_SUBPORT_ENTRIES 4
+#define SS2_PORT_PML_CFG_TX_MAC_SUBPORT(idx)                                                       \
+	(C_HNI_PML_BASE + SS2_PORT_PML_CFG_TX_MAC_SUBPORT_OFFSET(idx))
+#define SS2_PORT_PML_CFG_TX_MAC_SUBPORT_SIZE 0x00000020
+
+union ss2_port_pml_cfg_tx_mac_subport {
+	__u64 qw;
+	struct {
+		__u64 mac_operational : 1;
+		__u64 short_preamble : 1;
+		__u64: 6;
+		__u64 pcs_credits : 4;
+		__u64: 4;
+		__u64 mac_cdt_init_val : 8;
+		__u64 mac_cdt_thresh : 8;
+		__u64: 32;
+	};
+};
+
+#define SS2_PORT_PML_CFG_RX_MAC_SUBPORT_OFFSET(idx) (0x00000860 + ((idx) * 8))
+#define SS2_PORT_PML_CFG_RX_MAC_SUBPORT_ENTRIES 4
+#define SS2_PORT_PML_CFG_RX_MAC_SUBPORT(idx)                                                       \
+	(C_HNI_PML_BASE + SS2_PORT_PML_CFG_RX_MAC_SUBPORT_OFFSET(idx))
+#define SS2_PORT_PML_CFG_RX_MAC_SUBPORT_SIZE 0x00000020
+
+union ss2_port_pml_cfg_rx_mac_subport {
+	__u64 qw;
+	struct {
+		__u64 mac_operational : 1;
+		__u64 short_preamble : 1;
+		__u64: 62;
+	};
+};
+
+#define SS2_PORT_PML_CFG_LLR_SUBPORT_OFFSET(idx) (0x00000920 + ((idx) * 8))
+#define SS2_PORT_PML_CFG_LLR_SUBPORT_ENTRIES 4
+#define SS2_PORT_PML_CFG_LLR_SUBPORT(idx)                                                          \
+	(C_HNI_PML_BASE + SS2_PORT_PML_CFG_LLR_SUBPORT_OFFSET(idx))
+#define SS2_PORT_PML_CFG_LLR_SUBPORT_SIZE 0x00000020
+
+union ss2_port_pml_cfg_llr_subport {
+	__u64 qw;
+	struct {
+		__u64 llr_mode : 2;
+		__u64: 6;
+		__u64 enable_loop_timing : 1;
+		__u64: 7;
+		__u64 filter_ctl_frames : 1;
+		__u64: 3;
+		__u64 filter_lossless_when_off : 1;
+		__u64: 3;
+		__u64 mac_if_credits : 4;
+		__u64: 4;
+		__u64 link_down_behavior : 2;
+		__u64: 6;
+		__u64 max_starvation_limit : 16;
+		__u64: 8;
+	};
+};
+
+#define SS2_PORT_PML_CFG_SERDES_RX_OFFSET(idx) (0x00001000 + ((idx) * 8))
+#define SS2_PORT_PML_CFG_SERDES_RX_ENTRIES 4
+#define SS2_PORT_PML_CFG_SERDES_RX(idx) (C_HNI_PML_BASE + SS2_PORT_PML_CFG_SERDES_RX_OFFSET(idx))
+#define SS2_PORT_PML_CFG_SERDES_RX_SIZE 0x00000020
+
+union ss2_port_pml_cfg_serdes_rx {
+	__u64 qw;
+	struct {
+		__u64 pmd_rx_lane_mode : 16;
+		__u64 pmd_rx_osr_mode : 9;
+		__u64: 3;
+		__u64 pmd_ext_los : 1;
+		__u64: 3;
+		__u64 pmd_ln_rx_h_pwrdn : 1;
+		__u64: 3;
+		__u64 pmd_ln_rx_dp_h_rstb : 1;
+		__u64: 3;
+		__u64 pmd_ln_rx_h_rstb : 1;
+		__u64: 23;
+	};
+};
+
+#define SS2_PORT_PML_CFG_SERDES_TX_OFFSET(idx) (0x00001020 + ((idx) * 8))
+#define SS2_PORT_PML_CFG_SERDES_TX_ENTRIES 4
+#define SS2_PORT_PML_CFG_SERDES_TX(idx) (C_HNI_PML_BASE + SS2_PORT_PML_CFG_SERDES_TX_OFFSET(idx))
+#define SS2_PORT_PML_CFG_SERDES_TX_SIZE 0x00000020
+
+union ss2_port_pml_cfg_serdes_tx {
+	__u64 qw;
+	struct {
+		__u64 pmd_tx_lane_mode : 16;
+		__u64 pmd_tx_osr_mode : 9;
+		__u64: 3;
+		__u64 pmd_tx_disable : 1;
+		__u64: 3;
+		__u64 pmd_ln_tx_h_pwrdn : 1;
+		__u64: 3;
+		__u64 pmd_ln_tx_dp_h_rstb : 1;
+		__u64: 3;
+		__u64 pmd_ln_tx_h_rstb : 1;
+		__u64: 23;
+	};
+};
+
+#define SS2_PORT_PML_STS_SERDES_OFFSET(idx) (0x00001200 + ((idx) * 8))
+#define SS2_PORT_PML_STS_SERDES_ENTRIES 4
+#define SS2_PORT_PML_STS_SERDES(idx) (C_HNI_PML_BASE + SS2_PORT_PML_STS_SERDES_OFFSET(idx))
+#define SS2_PORT_PML_STS_SERDES_SIZE 0x00000020
+
+union ss2_port_pml_sts_serdes {
+	__u64 qw;
+	struct {
+		__u64 pmd_signal_detect : 1;
+		__u64: 3;
+		__u64 pmd_rx_lock : 1;
+		__u64: 3;
+		__u64 pmd_rx_clk_vld : 1;
+		__u64: 3;
+		__u64 pmd_rx_data_vld : 1;
+		__u64: 3;
+		__u64 pmd_tx_clk_vld : 1;
+		__u64: 3;
+		__u64 pmd_tx_data_vld : 1;
+		__u64: 3;
+		__u64 rx_signal_ok : 1;
+		__u64: 39;
+	};
+};
+
+#define SS2_PORT_PML_STS_RX_PCS_AM_LOCK_OFFSET 0x00001380
+#define SS2_PORT_PML_STS_RX_PCS_AM_LOCK (C_HNI_PML_BASE + SS2_PORT_PML_STS_RX_PCS_AM_LOCK_OFFSET)
+#define SS2_PORT_PML_STS_RX_PCS_AM_LOCK_SIZE 0x00000008
+
+union ss2_port_pml_sts_rx_pcs_am_lock {
+	__u64 qw;
+	struct {
+		__u64 am_lock : 16;
+		__u64: 48;
+	};
+};
+
+#define SS2_PORT_PML_STS_RX_PCS_SUBPORT_OFFSET(idx) (0x000013a0 + ((idx) * 8))
+#define SS2_PORT_PML_STS_RX_PCS_SUBPORT_ENTRIES 4
+#define SS2_PORT_PML_STS_RX_PCS_SUBPORT(idx)                                                       \
+	(C_HNI_PML_BASE + SS2_PORT_PML_STS_RX_PCS_SUBPORT_OFFSET(idx))
+#define SS2_PORT_PML_STS_RX_PCS_SUBPORT_SIZE 0x00000020
+
+union ss2_port_pml_sts_rx_pcs_subport {
+	__u64 qw;
+	struct {
+		__u64: 4;
+		__u64 align_status : 1;
+		__u64: 3;
+		__u64 fault : 1;
+		__u64: 3;
+		__u64 local_fault : 1;
+		__u64: 3;
+		__u64 hi_ser : 1;
+		__u64: 47;
+	};
+};
+
+#define C2_IXE_CFG_DISP_ORD_OFFSET 0x000007a8
+#define C2_IXE_CFG_DISP_ORD (C_IXE_BASE + C2_IXE_CFG_DISP_ORD_OFFSET)
+#define C2_IXE_CFG_DISP_ORD_SIZE 0x00000008
+
+union c2_ixe_cfg_disp_ord {
+	__u64 qw;
+	struct {
+		__u64 wr_atomic_op : 1;
+		__u64 get_ro_last : 1;
+		__u64 get_ro_body : 1;
+		__u64: 61;
+	};
+};
+
+#define C2_LPE_CFG_MATCH_SEL_OFFSET 0x00000a20
+#define C2_LPE_CFG_MATCH_SEL (C_LPE_BASE + C2_LPE_CFG_MATCH_SEL_OFFSET)
+#define C2_LPE_CFG_MATCH_SEL_SIZE 0x00000008
+
+union c2_lpe_cfg_match_sel {
+	__u64 qw;
+	struct {
+		__u64 vni_cfg : 2;
+		__u64: 62;
+	};
+};
+
+#define C2_LPE_CFG_GET_FQ_DFA_MASK_OFFSET(idx) (0x00000b00 + ((idx) * 8))
+#define C2_LPE_CFG_GET_FQ_DFA_MASK_ENTRIES 16
+#define C2_LPE_CFG_GET_FQ_DFA_MASK(idx) (C_LPE_BASE + C2_LPE_CFG_GET_FQ_DFA_MASK_OFFSET(idx))
+#define C2_LPE_CFG_GET_FQ_DFA_MASK_SIZE 0x00000080
+
+union c2_lpe_cfg_get_fq_dfa_mask {
+	__u64 qw;
+	struct {
+		__u64 dscp0_dfa_mask : 12;
+		__u64: 4;
+		__u64 dscp1_dfa_mask : 12;
+		__u64: 4;
+		__u64 dscp2_dfa_mask : 12;
+		__u64: 4;
+		__u64 dscp3_dfa_mask : 12;
+		__u64: 4;
+	};
+};
+
+#define C2_OXE_ERR_INFO_SPT_CDT_ERR_OFFSET 0x000001e8
+#define C2_OXE_ERR_INFO_SPT_CDT_ERR (C_OXE_BASE + C2_OXE_ERR_INFO_SPT_CDT_ERR_OFFSET)
+#define C2_OXE_ERR_INFO_SPT_CDT_ERR_SIZE 0x00000008
+
+union c2_oxe_err_info_spt_cdt_err {
+	__u64 qw;
+	struct {
+		__u64 index : 11;
+		__u64: 5;
+		__u64 bc : 4;
+		__u64: 44;
+	};
+};
+
+#define C2_OXE_ERR_INFO_SMT_CDT_ERR_OFFSET 0x000001f0
+#define C2_OXE_ERR_INFO_SMT_CDT_ERR (C_OXE_BASE + C2_OXE_ERR_INFO_SMT_CDT_ERR_OFFSET)
+#define C2_OXE_ERR_INFO_SMT_CDT_ERR_SIZE 0x00000008
+
+union c2_oxe_err_info_smt_cdt_err {
+	__u64 qw;
+	struct {
+		__u64 index : 8;
+		__u64: 8;
+		__u64 bc : 4;
+		__u64: 44;
+	};
+};
+
+#define C2_OXE_CFG_SPT_BC_LIMIT_OFFSET(idx) (0x00000680 + ((idx) * 8))
+#define C2_OXE_CFG_SPT_BC_LIMIT_ENTRIES 10
+#define C2_OXE_CFG_SPT_BC_LIMIT(idx) (C_OXE_BASE + C2_OXE_CFG_SPT_BC_LIMIT_OFFSET(idx))
+#define C2_OXE_CFG_SPT_BC_LIMIT_SIZE 0x00000050
+
+union c2_oxe_cfg_spt_bc_limit {
+	__u64 qw;
+	struct {
+		__u64 limit : 11;
+		__u64: 53;
+	};
+};
+
+#define C2_PI_ERR_INFO_AHB_OFFSET 0x00000300
+#define C2_PI_ERR_INFO_AHB (C_PI_BASE + C2_PI_ERR_INFO_AHB_OFFSET)
+#define C2_PI_ERR_INFO_AHB_SIZE 0x00000018
+
+union c2_pi_err_info_ahb {
+	__u64 qw[3];
+	struct {
+		__u64 hwrite : 1;
+		__u64 htrans : 2;
+		__u64 hsize : 3;
+		__u64 hrdata_sel : 4;
+		__u64: 5;
+		__u64 ahb_err_id : 1;
+		__u64 haddr : 14;
+		__u64: 2;
+		__u64 hsel : 16;
+		__u64: 16;
+		__u64 req : 1;
+		__u64: 31;
+		__u64 hwdata : 32;
+		__u64 done : 16;
+		__u64 hresp : 16;
+		__u64 hrdata : 32;
+	};
+};
+
+struct c_cq_cntrs_group {
+	struct c_cq_cntrs cq;
+	struct c_tou_cntrs tou;
+	struct c_pct_cntrs pct;
+	struct c_ee_cntrs ee;
+};
+
+struct c_lpe_cntrs_group {
+	struct c_lpe_cntrs lpe;
+	struct c_ixe_cntrs ixe;
+	struct c_rmu_cntrs rmu;
+	struct c_parbs_cntrs parbs;
+	struct c_mst_cntrs mst;
+};
+
+struct c_hni_cntrs_group {
+	struct c_hni_cntrs hni;
+	struct c1_hni_pcs_cntrs pcs;
+	struct c1_hni_mac_cntrs mac;
+	struct c1_hni_llr_cntrs llr;
+	struct c1_oxe_cntrs oxe;
+};
+
+struct c_mb_cntrs_group {
+	struct c_mb_cntrs mb;
+	struct c_pi_cntrs pi;
+	struct c_atu_cntrs atu;
+};
+
+struct c_pi_ipd_cntrs_group {
+	struct c_pi_ipd_cntrs pi_ipd;
+};
+
+#define C_PI_CFG_DMAC_STATUS_AXI_RESP_OKAY (0)
+#define C_PI_CFG_DMAC_STATUS_AXI_RESP_EXOKAY (1)
+#define C_PI_CFG_DMAC_STATUS_AXI_RESP_SLVERR (2)
+#define C_PI_CFG_DMAC_STATUS_AXI_RESP_DECERR (3)
+
+#define C_PI_DMAC_CDESC_STATUS_AXI_RESP_OKAY C_PI_CFG_DMAC_STATUS_AXI_RESP_OKAY
+#define C_PI_DMAC_CDESC_STATUS_AXI_RESP_EXOKAY C_PI_CFG_DMAC_STATUS_AXI_RESP_EXOKAY
+#define C_PI_DMAC_CDESC_STATUS_AXI_RESP_SLVERR C_PI_CFG_DMAC_STATUS_AXI_RESP_SLVERR
+#define C_PI_DMAC_CDESC_STATUS_AXI_RESP_DECERR C_PI_CFG_DMAC_STATUS_AXI_RESP_DECERR
+
+#endif
diff --git a/kernel-headers/rdma/cxiverbs-abi.h b/kernel-headers/rdma/cxiverbs-abi.h
new file mode 100644
index 000000000000..69a3c39a3f9b
--- /dev/null
+++ b/kernel-headers/rdma/cxiverbs-abi.h
@@ -0,0 +1,658 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * Copyright 2025 Hewlett Packard Enterprise Development LP
+ *
+ * User-space ABI for the CXI InfiniBand RDMA driver.
+ * This header is shared between the kernel driver and the libcxi_verbs
+ * user-space provider in rdma-core.
+ *
+ * QPN encoding (UEC-aligned):
+ *   bit  31     : addr_mode (1 = absolute, 0 = job-relative)
+ *   bits [23:12]: Resource Index (PID-slice receive selector, not service ID)
+ *   bits [11:0] : PIDonFEP (process-endpoint address bits)
+ */
+
+#ifndef __UAPI_RDMA_CXI_ABI_H__
+#define __UAPI_RDMA_CXI_ABI_H__
+
+#include <linux/types.h>
+
+#define CXI_IB_UVERBS_ABI_VERSION 1
+#define CXI_IBV_LNI_ANY 0xffffffffU
+
+/*
+ * alloc_ucontext / GET_CONTEXT
+ *
+ * GET_CONTEXT opens the uverbs device and returns static CXI geometry.
+ * Privileged ibv_alloc_job() creates a device-scoped job; it does not allocate
+ * an LNI or bind the ucontext. LNIs are allocated explicitly and selected by
+ * PDs. QPs require a job key belonging to their PD. PIDonFEP may be supplied
+ * as an optional default for later QP creation.
+ */
+enum cxi_ibv_alloc_ucontext_mask {
+	CXI_IBV_ALLOC_UCONTEXT_PIDONFEP = 1U << 0,
+};
+
+#define CXI_IBV_SERVICE_ID_MAX 0xfffU
+#define CXI_IBV_JOB_ID_MAX 0xffffU
+#define CXI_IBV_PIDONFEP_MAX 0xfffU
+
+/*
+ * A Slingshot GID is just the 20-bit NID: subnet_prefix is zero and the NID
+ * sits in the low bits of interface_id. Userspace never needs to know that -
+ * it exchanges GIDs like any other transport - but a GID handed back to this
+ * device must fit, or it names something we cannot reach.
+ */
+#define CXI_IBV_NID_MASK 0xfffffULL
+
+struct cxi_ibv_alloc_ucontext_cmd {
+	__u32 comp_mask; /* enum cxi_ibv_alloc_ucontext_mask */
+	__u32 pidonfep; /* UET PIDonFEP (optional default) */
+};
+
+/*
+ * TC capacity limits (one per traffic class, 0-7).
+ * Used to report per-JobID resource allocation.
+ */
+struct cxi_ibv_tc_limit {
+	__u32 tc; /* traffic class 0-7 */
+	__u32 max_ptes; /* max portal table entries for this TC */
+	__u32 max_cps; /* max communication profiles for this TC */
+	__u32 max_qps; /* max queue pairs for this TC */
+	__u32 reserved; /* for future use */
+};
+
+#define CXI_IBV_TC_MAX 8 /* 0-7 traffic classes */
+
+struct cxi_ibv_alloc_ucontext_resp {
+	__u32 nid; /* 20-bit NIC address (NID) of this port */
+	__u32 pid_bits; /* width of the PID field (6–9 bits) */
+	__u32 pid_count; /* number of PIDs per VNI */
+	__u32 pid_granule; /* PID space granularity */
+	__u32 lni_id; /* Zero; LNIs are allocated explicitly */
+	__u32 num_tc_limits; /* number of valid tc_limits[] entries */
+	/* variable-length tc_limits[] follows if num_tc_limits > 0 */
+};
+
+/*
+ * alloc_pd / ALLOC_PD
+ *
+ * The protection domain selects an explicitly allocated LNI. A nonzero
+ * preferred_svc_id must match that LNI's service; zero means no preference.
+ */
+enum cxi_ibv_alloc_pd_mask {
+	CXI_IBV_ALLOC_PD_SVC_ID_PREFERRED = 1U << 0,
+	CXI_IBV_ALLOC_PD_LNI = 1U << 1,
+};
+
+struct cxi_ibv_alloc_pd_cmd {
+	__u32 comp_mask; /* enum cxi_ibv_alloc_pd_mask */
+	__u32 preferred_svc_id; /* optional preferred service for QPs (0 = any) */
+	__u32 lni_handle;
+	__u32 reserved;
+};
+
+struct cxi_ibv_alloc_pd_resp {
+	__u32 pd_id; /* RGID-based PD identifier (informational) */
+	__u32 pad;
+};
+
+/*
+ * create_cq / CREATE_CQ
+ *
+ * The driver allocates a CXI Event Queue (EQ) of the requested size and
+ * maps the ring buffer and doorbell CSR into user space.
+ *
+ * After create_cq succeeds:
+ *   - eq_buf_offset / eq_buf_size : mmap offset+size for the event-ring buffer
+ *     (user polls this for completions)
+ *   - eq_db_offset / eq_db_size   : mmap offset+size for the EQ doorbell/CSR
+ *     (user writes here to arm notifications)
+ *   - eqn                         : hardware EQ index
+ */
+struct cxi_ibv_create_cq_cmd {
+	__u32 n_entries; /* requested event-ring depth in entries */
+	__u32 cpu_affinity; /* NUMA / CPU affinity hint for IRQ steering */
+	__u32 lni_handle;
+	__u32 reserved;
+};
+
+struct cxi_ibv_create_cq_resp {
+	__u64 eq_buf_offset; /* mmap offset for event-ring buffer */
+	__u64 eq_buf_size; /* event-ring buffer size in bytes */
+	__u64 eq_db_offset; /* mmap offset for EQ doorbell (CSR) */
+	__u64 eq_db_size; /* doorbell region size in bytes */
+	__u32 eqn; /* hardware EQ index */
+	__u32 pad;
+};
+
+/*
+ * create_qp / CREATE_QP
+ *
+ * On creation the driver allocates:
+ *   - a CXI Domain (VNI + PID)
+ *   - a Communication Profile (CP → LCID)
+ *   - a transmit CQ (TXQ)
+ *   - a target CQ (TGQ)
+ *   - a Portal Table Entry (PTE) for receive matching
+ *
+ * The QP uses its required PD job key's JobID. svc_id selects the CXI
+ * service/resource pool for this QP,
+ * independently of its Resource Index, and must match the PD's LNI service.
+ * If omitted, the driver uses that service. TC
+ * defaults to CXI_TC_BEST_EFFORT unless overridden. match_bits / match_mask
+ * control the portal-level receive filter (0 / 0 = accept all).
+ *
+ * After create_qp succeeds:
+ *   - txq_cmds_offset / txq_cmds_size : mmap offset+size for the TXQ command
+ *     ring (user writes commands here)
+ *   - txq_db_offset / txq_db_size     : mmap offset+size for the TXQ doorbell
+ *   - txq_idx                         : TXQ hardware CQ index (0–1023)
+ *   - lcid                            : LCID assigned to this QP (from CP)
+ *   - tgq_cmds_offset / tgq_cmds_size : mmap offset+size for the TGQ command
+ *     ring (user appends receive buffers here)
+ *   - tgq_db_offset / tgq_db_size     : mmap offset+size for the TGQ doorbell
+ *   - tgq_idx                         : TGQ hardware CQ index (1024–1535)
+ *
+ * The PTE hardware index needed to post receives is not known until the QP
+ * reaches RTR (see cxi_ibv_modify_qp_resp below).
+ */
+enum cxi_ibv_create_qp_mask {
+	CXI_IBV_CREATE_QP_SVC_ID = 1U << 0,
+	CXI_IBV_CREATE_QP_TC = 1U << 1,
+};
+
+struct cxi_ibv_create_qp_cmd {
+	__u32 comp_mask; /* enum cxi_ibv_create_qp_mask */
+	__u32 svc_id; /* optional CXI service (resource-limit pool) */
+	__u32 tc; /* enum cxi_traffic_class */
+	__u32 uec_qp_type; /* UEC QP type (reserved; use 0 until spec final) */
+	__u32 pad;
+	__u64 match_bits; /* portal match bits (0 = match all) */
+	__u64 match_mask; /* matching mask (0 = match all) */
+};
+
+struct cxi_ibv_create_qp_resp {
+	__u64 txq_cmds_offset; /* mmap offset for TXQ command ring */
+	__u64 txq_cmds_size; /* TXQ command ring size in bytes */
+	__u64 txq_db_offset; /* mmap offset for TXQ doorbell */
+	__u64 txq_db_size; /* TXQ doorbell size in bytes */
+	__u32 txq_idx; /* TXQ hardware index (0–1023) */
+	__u32 lcid; /* LCID assigned to this QP */
+	__u64 tgq_cmds_offset; /* mmap offset for TGQ command ring */
+	__u64 tgq_cmds_size; /* TGQ command ring size in bytes */
+	__u64 tgq_db_offset; /* mmap offset for TGQ doorbell */
+	__u64 tgq_db_size; /* TGQ doorbell size in bytes */
+	__u32 tgq_idx; /* TGQ hardware index (1024–1535, see cxi_cq_get_cqn()) */
+	__u32 job_id; /* JobID (VNI) the QP was created under */
+	__u32 pte_index;
+	__u32 reserved;
+};
+
+/*
+ * modify_qp / MODIFY_QP (extended)
+ *
+ * The PTE is mapped into the domain during the INIT->RTR transition, so its
+ * hardware index is not known at create_qp time. Returned here instead.
+ */
+struct cxi_ibv_modify_qp_resp {
+	__u32 pte_index; /* hardware PTLTE index, valid once QP reaches RTR */
+	__u32 pad;
+};
+
+/*
+ * query_device / QUERY_DEVICE  (driver-specific extended response)
+ *
+ * When the user-space provider calls ibv_query_device_ex(), the kernel
+ * returns this struct as driver-specific data (via udata->out).
+ * The caller must pass at least sizeof(cxi_ibv_query_device_resp) bytes
+ * in the output buffer; unused bytes are zeroed.
+ *
+ * features:
+ *   CXI_DEVICE_CAP_UEC_QPN        - QPN uses UEC bit-31 addr_mode encoding
+ *   CXI_DEVICE_CAP_TRIGGERED_OPS  - counting triggers / triggered operations
+ *   CXI_DEVICE_CAP_ODP            - on-demand paging MRs
+ *
+ * max_ctn: highest counting-trigger number (inclusive) this device supports.
+ */
+#define CXI_DEVICE_CAP_UEC_QPN (1U << 0)
+#define CXI_DEVICE_CAP_TRIGGERED_OPS (1U << 1)
+#define CXI_DEVICE_CAP_ODP (1U << 2)
+
+/*
+ * Device-wide HW properties that the native ABI exposes via the
+ * DEV_INFO_GET ioctl (struct cxi_dev_info_use in uapi/ethernet/cxi-abi.h).
+ * The RDMA path has no ioctl/sysfs control channel, so it must return the
+ * same information here instead. Field-for-field mirror of that struct,
+ * kept separate (rather than #include'd) so this ABI header doesn't pull
+ * in the native ioctl definitions it has no use for; keep the two in sync.
+ */
+struct cxi_ibv_devinfo {
+	__u32 nid;
+	__u32 pid_bits;
+	__u32 pid_count;
+	__u32 pid_granule;
+	__u32 min_free_shift;
+	__u32 rdzv_get_idx;
+	__u32 vendor_id;
+	__u32 device_id;
+	__u32 device_rev;
+	__u32 device_proto;
+	__u32 device_platform;
+	__u32 pct_eq;
+	__s32 uc_nic;
+	__u64 link_mtu;
+	__u64 link_speed;
+	__u8 link_state;
+	__u16 num_ptes;
+	__u16 num_txqs;
+	__u16 num_tgqs;
+	__u16 num_eqs;
+	__u16 num_cts;
+	__u16 num_acs;
+	__u16 num_tles;
+	__u16 num_les;
+	__u32 cassini_version; /* enum cassini_version */
+	__u32 system_type_identifier; /* enum system_type_identifier */
+	char fru_description[16];
+	__u32 vni_matching;
+};
+
+struct cxi_ibv_query_device_resp {
+	__u32 features; /* CXI_DEVICE_CAP_* bitmask */
+	__u32 max_ctn; /* max counting trigger number */
+	struct cxi_ibv_devinfo devinfo;
+};
+
+/*
+ *
+ * The driver registers user memory with the CXI ATU (Address Translation
+ * Unit).  The lkey encodes the LAC (Local Address Context) slot and the
+ * hardware MD identifier.  The rkey is a random token used as the portal
+ * match-bits for remote RDMA WRITE/READ operations targeting this MR.
+ */
+/*
+ * 64-bit memory keys.
+ *
+ *   lkey64  bits [2:0]   LAC, the hardware address context
+ *           bits [34:3]  ATU memory descriptor index
+ *   rkey64  an opaque token the initiator presents as the portal match bits
+ *
+ * The 32-bit lkey and rkey keep the older narrow encoding, which packs the
+ * LAC into bits [31:24] and truncates the descriptor index to 24 bits, for
+ * callers that cannot carry a wide key.
+ */
+#define CXI_LKEY64_LAC_MASK 0x7ULL
+#define CXI_LKEY64_MD_SHIFT 3
+#define CXI_LKEY64_MD_MASK 0xffffffffULL
+
+/*
+ * A caller may choose the remote key rather than take a generated one. The
+ * value is used exactly as given, so one that fits in 32 bits produces a
+ * region a 32-bit peer can reach without anything having to truncate.
+ */
+#define CXI_REG_MR_USER_RKEY (1 << 0)
+#define CXI_REG_MR_NATIVE_MAP (1 << 1)
+
+#define CXI_RKEY_MAX 0xffffffffffffULL
+
+struct cxi_ibv_reg_mr {
+	__aligned_u64 rkey64;
+	__u32 flags;
+	__u32 native_flags;
+};
+
+struct cxi_ibv_mr_info {
+	__u64 va __attribute__((packed));
+	__u64 iova __attribute__((packed));
+	__u64 length __attribute__((packed));
+	__s32 page_shift;
+	__s32 huge_shift;
+	__u32 id;
+	__u32 lac;
+};
+
+struct cxi_ibv_reg_mr_resp {
+	/*
+	 * The narrow keys alias the low word of the wide ones. REG_MR is a
+	 * legacy write command whose response declares __u32 driver_data[], so
+	 * this payload begins at offset 12 and nothing here can be eight-byte
+	 * aligned; packed drops the requirement without moving anything.
+	 */
+	union {
+		__u64 lkey64 __attribute__((packed));
+		struct {
+			__u32 lkey;
+			__u32 lkey_hi;
+		};
+	};
+	union {
+		__u64 rkey64 __attribute__((packed));
+		struct {
+			__u32 rkey;
+			__u32 rkey_hi;
+		};
+	};
+	/* ATU address for @start; commands must use this, not the VA. */
+	__u64 iova __attribute__((packed));
+	struct cxi_ibv_mr_info info;
+};
+
+/*
+ * Custom uverbs for Counting Triggers (CT).
+ *
+ * The driver allocates a CXI Completion Table (CT) of the requested size and
+ * maps the ring buffer (writeback page) and doorbell CSR into user space.
+ *
+ * After create_ct succeeds:
+ *   - ctn               : hardware CT number (u32); used in triggered commands
+ *   - wb_mmap_offset    : mmap() offset for the writeback page
+ *   - wb_mmap_length    : size of the writeback page in bytes
+ *   - db_mmap_offset    : mmap() offset for the CT doorbell CSR
+ *   - db_mmap_length    : size of the doorbell region in bytes
+ *
+ * Object/method/attribute IDs are driver-namespace values
+ * (UVERBS_ID_DRIVER_NS = 1 << UVERBS_ID_NS_SHIFT).
+ */
+#include <rdma/ib_user_ioctl_cmds.h>
+
+enum cxi_ib_object_ids {
+	CXI_IB_OBJECT_CT = (1U << UVERBS_ID_NS_SHIFT),
+	CXI_IB_OBJECT_JOB_TC,
+	CXI_IB_OBJECT_LNI,
+	CXI_IB_OBJECT_SVC,
+	CXI_IB_OBJECT_CP,
+	CXI_IB_OBJECT_EQ,
+	CXI_IB_OBJECT_CSR,
+	CXI_IB_OBJECT_WAIT,
+	CXI_IB_OBJECT_CMDQ,
+};
+
+enum cxi_ib_methods_cmdq {
+	CXI_IB_METHOD_CMDQ_ALLOC = (1U << UVERBS_ID_NS_SHIFT),
+	CXI_IB_METHOD_CMDQ_DESTROY,
+};
+
+enum cxi_ib_attrs_cmdq {
+	CXI_IB_ATTR_CMDQ_HANDLE = (1U << UVERBS_ID_NS_SHIFT),
+	CXI_IB_ATTR_CMDQ_LNI,
+	CXI_IB_ATTR_CMDQ_COUNT,
+	CXI_IB_ATTR_CMDQ_INFO,
+	CXI_IB_ATTR_CMDQ_FLAGS,
+};
+
+enum cxi_ib_cmdq_flags {
+	CXI_IB_CMDQ_TRIGGER = 1U << 0,
+};
+
+struct cxi_ibv_cmdq_info {
+	__aligned_u64 commands_offset;
+	__aligned_u64 commands_length;
+	__aligned_u64 doorbell_offset;
+	__aligned_u64 doorbell_length;
+	__u32 count;
+	__u32 index;
+};
+
+enum cxi_ib_methods_wait {
+	CXI_IB_METHOD_WAIT_ALLOC = (1U << UVERBS_ID_NS_SHIFT),
+};
+
+enum cxi_ib_attrs_wait {
+	CXI_IB_ATTR_WAIT_FD = (1U << UVERBS_ID_NS_SHIFT),
+	CXI_IB_ATTR_WAIT_LNI,
+};
+
+enum cxi_ib_methods_csr {
+	CXI_IB_METHOD_CSR_MAP = (1U << UVERBS_ID_NS_SHIFT),
+	CXI_IB_METHOD_CSR_UNMAP,
+	CXI_IB_METHOD_CSR_INBOUND_WAIT,
+};
+
+enum cxi_ib_attrs_csr {
+	CXI_IB_ATTR_CSR_HANDLE = (1U << UVERBS_ID_NS_SHIFT),
+	CXI_IB_ATTR_CSR_INFO,
+};
+
+struct cxi_ibv_csr_info {
+	__aligned_u64 offset;
+	__aligned_u64 length;
+};
+
+enum cxi_ib_methods_eq {
+	CXI_IB_METHOD_EQ_ALLOC = (1U << UVERBS_ID_NS_SHIFT),
+	CXI_IB_METHOD_EQ_DESTROY,
+};
+
+enum cxi_ib_attrs_eq {
+	CXI_IB_ATTR_EQ_HANDLE = (1U << UVERBS_ID_NS_SHIFT),
+	CXI_IB_ATTR_EQ_LNI,
+	CXI_IB_ATTR_EQ_MR,
+	CXI_IB_ATTR_EQ_CONFIG,
+	CXI_IB_ATTR_EQ_INFO,
+	CXI_IB_ATTR_EQ_FLAGS,
+	CXI_IB_ATTR_EQ_EVENT_WAIT,
+	CXI_IB_ATTR_EQ_STATUS_WAIT,
+};
+
+enum cxi_ib_eq_flags {
+	CXI_IB_EQ_REGISTER_PCT = 1U << 0,
+	CXI_IB_EQ_PASSTHROUGH = 1U << 1,
+};
+
+struct cxi_ibv_eq_config {
+	__aligned_u64 address;
+	__aligned_u64 length;
+	__u32 threshold_base;
+	__u32 threshold_delta;
+	__u32 threshold_count;
+	__u32 ec_delay;
+	__u32 cpu;
+	__u32 reserved_slots;
+};
+
+struct cxi_ibv_eq_info {
+	__aligned_u64 doorbell_offset;
+	__aligned_u64 doorbell_size;
+	__u32 eqn;
+	__u32 reserved;
+};
+
+enum cxi_ib_methods_cp {
+	CXI_IB_METHOD_CP_ALLOC = (1U << UVERBS_ID_NS_SHIFT),
+	CXI_IB_METHOD_CP_DESTROY,
+};
+
+enum cxi_ib_attrs_cp {
+	CXI_IB_ATTR_CP_HANDLE = (1U << UVERBS_ID_NS_SHIFT),
+	CXI_IB_ATTR_CP_LNI,
+	CXI_IB_ATTR_CP_VNI,
+	CXI_IB_ATTR_CP_TC,
+	CXI_IB_ATTR_CP_TYPE,
+	CXI_IB_ATTR_CP_INFO,
+};
+
+struct cxi_ibv_cp_info {
+	__u32 vni;
+	__u32 tc;
+	__u32 type;
+	__u32 lcid;
+};
+
+enum cxi_ib_methods_svc {
+	CXI_IB_METHOD_SVC_ALLOC = (1U << UVERBS_ID_NS_SHIFT),
+	CXI_IB_METHOD_SVC_DESTROY,
+	CXI_IB_METHOD_SVC_QUERY,
+	CXI_IB_METHOD_SVC_ENABLE,
+};
+
+enum cxi_ib_attrs_svc {
+	CXI_IB_ATTR_SVC_ID = (1U << UVERBS_ID_NS_SHIFT),
+	CXI_IB_ATTR_SVC_CONFIG,
+	CXI_IB_ATTR_SVC_FLAGS,
+	CXI_IB_ATTR_SVC_USAGE,
+	CXI_IB_ATTR_SVC_LPR,
+};
+
+enum cxi_ib_svc_flags {
+	CXI_IB_SVC_LIMITS = 1U << 0,
+	CXI_IB_SVC_CREATE_TC = 1U << 1,
+	CXI_IB_SVC_ENABLED = 1U << 2,
+};
+
+enum cxi_ib_svc_resource {
+	CXI_IB_SVC_PTES,
+	CXI_IB_SVC_TXQS,
+	CXI_IB_SVC_TGQS,
+	CXI_IB_SVC_EQS,
+	CXI_IB_SVC_CTS,
+	CXI_IB_SVC_ACS,
+	CXI_IB_SVC_TLES,
+	CXI_IB_SVC_LES,
+	CXI_IB_SVC_RSRC_COUNT,
+};
+
+#define CXI_IB_SVC_MAX_VNIS 4
+
+struct cxi_ibv_svc_config {
+	__u32 svc_id;
+	/* Reserved; must be zero. */
+	__u16 vni_min;
+	__u16 vni_max;
+	/* Exact-list length; zero means system-empty or is_range. */
+	__u32 vni_count;
+	/* System service requires CAP_SYS_ADMIN and svc_id zero on allocation. */
+	__u32 is_system_svc;
+	/* Inclusive range endpoints are carried in vnis[0] and vnis[1]. */
+	__u32 is_range;
+	__u16 vnis[CXI_IB_SVC_MAX_VNIS];
+	__u32 tc_mask;
+	__u32 uid;
+	__u32 flags;
+	__u16 maximum[CXI_IB_SVC_RSRC_COUNT];
+	__u16 reserved[CXI_IB_SVC_RSRC_COUNT];
+};
+
+struct cxi_ibv_svc_rsrc_use {
+	__u32 svc_id;
+	__u32 tle_pool_id;
+	__u16 in_use[CXI_IB_SVC_RSRC_COUNT];
+};
+
+enum cxi_ib_methods_lni {
+	CXI_IB_METHOD_LNI_ALLOC = (1U << UVERBS_ID_NS_SHIFT),
+	CXI_IB_METHOD_LNI_DESTROY,
+};
+
+enum cxi_ib_attrs_lni_alloc {
+	CXI_IB_ATTR_LNI_ALLOC_HANDLE = (1U << UVERBS_ID_NS_SHIFT),
+	CXI_IB_ATTR_LNI_ALLOC_SVC_ID,
+	CXI_IB_ATTR_LNI_ALLOC_ID,
+};
+
+enum cxi_ib_attrs_lni_destroy {
+	CXI_IB_ATTR_LNI_DESTROY_HANDLE = (1U << UVERBS_ID_NS_SHIFT),
+};
+
+enum cxi_ib_methods_pd {
+	CXI_IB_METHOD_PD_PID_ALLOC = (1U << UVERBS_ID_NS_SHIFT),
+	CXI_IB_METHOD_PD_PID_QUERY,
+};
+
+enum cxi_ib_attrs_pd_pid {
+	CXI_IB_ATTR_PD_PID_HANDLE = (1U << UVERBS_ID_NS_SHIFT),
+	CXI_IB_ATTR_PD_PID_FLAGS,
+	CXI_IB_ATTR_PD_PID_VALUE,
+};
+
+#define CXI_IB_PD_PID_ABSOLUTE (1U << 0)
+
+struct cxi_ibv_create_jkey_cmd {
+	__u32 tc;
+	__u32 reserved;
+};
+
+enum cxi_ib_methods_ct {
+	CXI_IB_METHOD_CT_ALLOC = (1U << UVERBS_ID_NS_SHIFT),
+	CXI_IB_METHOD_CT_DESTROY = (1U << UVERBS_ID_NS_SHIFT) + 1,
+};
+
+enum cxi_ib_attrs_ct_alloc {
+	CXI_IB_ATTR_CT_ALLOC_HANDLE = (1U << UVERBS_ID_NS_SHIFT),
+	CXI_IB_ATTR_CT_ALLOC_CTN,
+	CXI_IB_ATTR_CT_ALLOC_WB_MMAP_OFFSET,
+	CXI_IB_ATTR_CT_ALLOC_WB_MMAP_LENGTH,
+	CXI_IB_ATTR_CT_ALLOC_DB_MMAP_OFFSET,
+	CXI_IB_ATTR_CT_ALLOC_DB_MMAP_LENGTH,
+	CXI_IB_ATTR_CT_ALLOC_LNI_HANDLE,
+	CXI_IB_ATTR_CT_ALLOC_WB_ADDRESS,
+};
+
+enum cxi_ib_attrs_ct_destroy {
+	CXI_IB_ATTR_CT_DESTROY_HANDLE = (1U << UVERBS_ID_NS_SHIFT),
+};
+
+enum cxi_ib_job_tc_flags {
+	CXI_IB_JOB_TC_F_CREATE = 1U << 0,
+};
+
+enum cxi_ib_methods_job_tc {
+	CXI_IB_METHOD_JOB_TC_BIND = (1U << UVERBS_ID_NS_SHIFT),
+	CXI_IB_METHOD_JOB_TC_CLEAR,
+	CXI_IB_METHOD_JOB_TC_QUERY,
+};
+
+struct cxi_ibv_tc_entry {
+	__u32 tc;
+	__u32 tc_type;
+	__u32 res_req_dscp;
+	__u32 unres_req_dscp;
+	__u32 res_rsp_dscp;
+	__u32 unres_rsp_dscp;
+	__u32 req_pcp;
+	__u32 rsp_pcp;
+	__u32 ocuset;
+	__u32 cq_tc;
+	__u32 req_bc;
+	__u32 flags;
+};
+
+#define CXI_IBV_TC_ENTRY_F_CREATED_BY_RDMA (1U << 0)
+
+enum cxi_ib_attrs_job_tc_bind {
+	CXI_IB_ATTR_JOB_TC_BIND_FLAGS = (1U << UVERBS_ID_NS_SHIFT),
+	CXI_IB_ATTR_JOB_TC_BIND_JOB_ID,
+	CXI_IB_ATTR_JOB_TC_BIND_TC,
+	CXI_IB_ATTR_JOB_TC_BIND_TC_TYPE,
+	CXI_IB_ATTR_JOB_TC_BIND_SVC_ID,
+	CXI_IB_ATTR_JOB_TC_BIND_PTES_MAX,
+	CXI_IB_ATTR_JOB_TC_BIND_PTES_RES,
+	CXI_IB_ATTR_JOB_TC_BIND_TXQS_MAX,
+	CXI_IB_ATTR_JOB_TC_BIND_TXQS_RES,
+	CXI_IB_ATTR_JOB_TC_BIND_TGQS_MAX,
+	CXI_IB_ATTR_JOB_TC_BIND_TGQS_RES,
+	CXI_IB_ATTR_JOB_TC_BIND_EQS_MAX,
+	CXI_IB_ATTR_JOB_TC_BIND_EQS_RES,
+	CXI_IB_ATTR_JOB_TC_BIND_CTS_MAX,
+	CXI_IB_ATTR_JOB_TC_BIND_CTS_RES,
+	CXI_IB_ATTR_JOB_TC_BIND_LES_MAX,
+	CXI_IB_ATTR_JOB_TC_BIND_LES_RES,
+	CXI_IB_ATTR_JOB_TC_BIND_TLES_MAX,
+	CXI_IB_ATTR_JOB_TC_BIND_TLES_RES,
+	CXI_IB_ATTR_JOB_TC_BIND_ACS_MAX,
+	CXI_IB_ATTR_JOB_TC_BIND_ACS_RES,
+	CXI_IB_ATTR_JOB_TC_BIND_RESP_SVC_ID,
+};
+
+enum cxi_ib_attrs_job_tc_clear {
+	CXI_IB_ATTR_JOB_TC_CLEAR_TC = (1U << UVERBS_ID_NS_SHIFT),
+	CXI_IB_ATTR_JOB_TC_CLEAR_TC_TYPE,
+};
+
+enum cxi_ib_attrs_job_tc_query {
+	CXI_IB_ATTR_JOB_TC_QUERY_MAX_ENTRIES = (1U << UVERBS_ID_NS_SHIFT),
+	CXI_IB_ATTR_JOB_TC_QUERY_RESP_COUNT,
+	CXI_IB_ATTR_JOB_TC_QUERY_RESP_ENTRIES,
+};
+
+#endif /* __UAPI_RDMA_CXI_ABI_H__ */
diff --git a/providers/cxi/cxi.h b/providers/cxi/cxi.h
new file mode 100644
index 000000000000..0f98854851a5
--- /dev/null
+++ b/providers/cxi/cxi.h
@@ -0,0 +1,265 @@
+/* SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause */
+/*
+ * Copyright 2025 HPE. All rights reserved.
+ */
+
+#ifndef CXI_H
+#define CXI_H
+
+#include <util/util.h>
+#include <stdbool.h>
+#include <pthread.h>
+#include <stdatomic.h>
+#include <infiniband/driver.h>
+
+enum cxi_builder_opcode {
+	CXI_WR_RDMA_WRITE_WITH_IMM64 = 16,
+	CXI_WR_RDMA_WRITE64_WITH_IMM,
+	CXI_WR_RDMA_WRITE64_WITH_IMM64,
+	CXI_WR_SEND_WITH_IMM64,
+};
+
+#include <rdma/cxiverbs-abi.h>
+
+/*
+ * Hardware ring/EQ definitions (struct cxi_cq, struct cxi_eq, cxi_cq_init(),
+ * cxi_eq_init(), cxi_cq_emit_*(), cxi_build_dfa(), ...). The kernel keeps its
+ * copy in include/linux/hpe/cxi/ rather than uapi, so the provider carries a
+ * userspace copy that must be kept in step with it.
+ */
+#include "cxi_prov_hw.h"
+
+/* PCI device IDs */
+#define PCI_VENDOR_ID_CRAY 0x17db
+#define PCI_DEVICE_ID_CASSINI_1 0x0501
+#define PCI_VENDOR_ID_HPE 0x1590
+#define PCI_DEVICE_ID_CASSINI_2 0x0371
+
+/*
+ * QPN encoding, mirrors the kernel's include/uapi/rdma/cxiverbs-abi.h:
+ * bit 31 = addr_mode, bits[23:12] = Resource Index, bits[11:0] = PIDonFEP.
+ * The Resource Index is the peer's PTE pid_offset, not a CXI service ID.
+ */
+#define CXI_QPN_PID_MASK 0xfffU
+#define CXI_QPN_RI_SHIFT 12U
+#define CXI_QPN_RI_MASK 0xfff000U
+
+#define CXI_QPN_RI(qpn) (((qpn) & CXI_QPN_RI_MASK) >> CXI_QPN_RI_SHIFT)
+
+#define CXI_MAX_QPS 1024U
+#define CXI_QP_SLOT_BITS 10U
+#define CXI_SEND_COOKIE_SLOT_BITS 11U
+#define CXI_SEND_COOKIE_INDEX_BITS (CXI_QP_SLOT_BITS + CXI_SEND_COOKIE_SLOT_BITS)
+#define CXI_QP_SLOT_MASK ((1U << CXI_QP_SLOT_BITS) - 1)
+#define CXI_SEND_COOKIE_SLOT_MASK ((1U << CXI_SEND_COOKIE_SLOT_BITS) - 1)
+#define CXI_SEND_COOKIE_GENERATION_MAX (UINT64_MAX >> CXI_SEND_COOKIE_INDEX_BITS)
+
+struct cxi_device {
+	struct verbs_device verbs_dev;
+	int page_size;
+};
+
+struct cxi_context {
+	struct verbs_context verbs_ctx;
+	uint32_t nid; /* this port's NIC address */
+	uint32_t pid_bits; /* width of the PID field in match/DFA encoding */
+	uint32_t preferred_svc_id;
+	uint32_t tc;
+	bool tc_valid;
+	pthread_mutex_t tc_lock;
+	/*
+	 * Device-wide HW properties fetched once via query_device's
+	 * driver-specific response (see cxi_ibv_devinfo, kernel-headers/
+	 * rdma/cxiverbs-abi.h). Exposed to callers outside this provider through
+	 * cxidv_query_device() (cxidv.h), since a plain libibverbs consumer
+	 * has no other way to reach this data.
+	 */
+	struct cxi_ibv_devinfo devinfo;
+	pthread_spinlock_t qp_table_lock;
+	atomic_uint_fast64_t send_cookie_seq;
+	struct cxi_qp *qp_slots[CXI_MAX_QPS];
+	struct cxi_qp *qp_by_pte[CXI_MAX_QPS];
+	uint32_t qp_count;
+	pthread_spinlock_t mr_list_lock;
+	struct cxi_mr *mr_list;
+};
+
+struct cxi_job_key {
+	struct ibv_job_key key;
+	struct ibv_job *job;
+	uint32_t job_id;
+	struct cxi_job_key *next;
+};
+
+struct cxi_pd {
+	struct ibv_pd ibv_pd;
+	uint32_t pd_id;
+	uint32_t pidonfep;
+	bool pid_valid;
+	pthread_spinlock_t jkey_lock;
+	struct cxi_job_key *jkeys;
+};
+
+struct cxi_mr {
+	struct verbs_mr vmr;
+	struct cxi_ibv_mr_info info;
+	uint64_t rkey64;
+	uint64_t lkey64;
+	uint64_t va;
+	uint64_t iova;
+	size_t len;
+	struct cxi_mr *next;
+};
+
+/*
+ * ibv_cq wrapper. Named cxi_ibv_cq (rather than cxi_cq) because cxi_prov_hw.h
+ * already defines "struct cxi_cq" for the hardware TXQ/TGQ ring state, which
+ * this struct embeds as hw_eq below (an EQ, not a CQ, but same ring machinery).
+ */
+struct cxi_ibv_cq {
+	struct verbs_cq verbs_cq;
+	struct cxi_eq hw_eq; /* ring state for polling; see cxi_eq_init() */
+	void *eq_buf; /* mmap'd event-ring buffer */
+	size_t eq_buf_size;
+	void *eq_db; /* mmap'd EQ doorbell/CSR */
+	size_t eq_db_size;
+	uint32_t eqn;
+	uint32_t cqe;
+	struct ibv_wc cur_wc; /* completion the ibv_cq_ex cursor is on */
+	__be64 cur_imm64; /* wide immediate for cur_wc, if any */
+	uint32_t cur_job_id; /* sender's JobID for cur_wc (== VNI) */
+	uint32_t cur_src_id; /* sender-chosen src_id for cur_wc */
+	pthread_spinlock_t lock;
+};
+
+struct cxi_qp {
+	struct verbs_qp vqp;
+	struct cxi_cq hw_txq; /* ring state for posting; see cxi_cq_init() */
+	void *txq_cmds; /* mmap'd TXQ command ring */
+	size_t txq_cmds_size;
+	void *txq_db; /* mmap'd TXQ doorbell */
+	size_t txq_db_size;
+	uint32_t txq_idx;
+	uint32_t lcid;
+	uint32_t src_id; /* reported to peers; see IBV_RU_ATTR_SRC_ID */
+	struct ibv_job *job;
+	uint32_t job_id; /* JobID (VNI) the QP was created under */
+	struct cxi_cq hw_tgq; /* ring state for posting receives */
+	void *tgq_cmds; /* mmap'd TGQ command ring */
+	size_t tgq_cmds_size;
+	void *tgq_db; /* mmap'd TGQ doorbell */
+	size_t tgq_db_size;
+	uint32_t tgq_idx;
+	int pte_index; /* set once modify_qp reaches RTR, else -1 */
+	uint32_t sq_size;
+	uint32_t rq_size;
+	struct cxi_ibv_cq *send_cq;
+	uint32_t qp_slot;
+	uint64_t *send_wrids;
+	/* An ACK does not say what was sent, so remember it. */
+	uint8_t *send_opcodes;
+	uint32_t *send_job_ids;
+	uint64_t *send_cookies;
+	bool *send_slot_valid;
+	uint32_t send_tail;
+	uint32_t send_count;
+	uint64_t *recv_wrids;
+	uint32_t recv_head;
+	uint32_t recv_tail;
+	uint32_t recv_count;
+	pthread_spinlock_t sq_lock;
+	pthread_spinlock_t rq_lock;
+	pthread_mutex_t builder_lock;
+
+	/* ibv_qp_ex work-request builder state; see cxi_wr_start() in verbs.c. */
+	struct cxi_wr_build {
+		int err;
+
+		/* Fields for the work request currently being built, if any. */
+		bool have_wr;
+		uint64_t wr_id;
+		unsigned int opcode;
+		struct cxi_ah *ah;
+		uint32_t remote_qpn;
+		uint32_t remote_nid;
+		uint32_t jkey;
+		uint32_t job_id;
+		uint32_t send_slot;
+		uint64_t remote_addr;
+		uint64_t rkey64;
+		uint64_t local_addr;
+		uint64_t lkey;
+		bool sge64;
+		uint32_t length;
+		bool has_sge;
+		bool has_addr;
+		bool has_imm;
+		bool imm_is64;
+		__be32 imm32;
+		__be64 imm64;
+	} wr_build;
+	struct cxi_wr_build *pending_wrs;
+	size_t pending_count;
+	size_t pending_capacity;
+};
+
+struct cxi_ah {
+	struct ibv_ah_ex ah_ex;
+	uint32_t ah_id;
+	/*
+	 * Extracted from the GID the same way as the kernel's
+	 * cxi_gid_to_nid(). ah_ex.remote_qpn (0 unless created via
+	 * cxi_create_ah_ex()/ibv_insert_addr()) carries the peer's
+	 * PIDonFEP/RI, per Phase 3 of cxi-rdma-path-audit.md.
+	 */
+	uint32_t nid;
+};
+
+static inline struct cxi_device *to_cxi_dev(struct ibv_device *ibv_dev)
+{
+	return container_of(ibv_dev, struct cxi_device, verbs_dev.device);
+}
+
+static inline struct cxi_context *to_cxi_ctx(struct ibv_context *ibv_ctx)
+{
+	return container_of(ibv_ctx, struct cxi_context, verbs_ctx.context);
+}
+
+static inline struct cxi_pd *to_cxi_pd(struct ibv_pd *ibv_pd)
+{
+	return container_of(ibv_pd, struct cxi_pd, ibv_pd);
+}
+
+static inline struct cxi_mr *to_cxi_mr(struct ibv_mr *ibv_mr)
+{
+	return container_of(ibv_mr, struct cxi_mr, vmr.ibv_mr);
+}
+
+static inline struct cxi_ibv_cq *to_cxi_ibv_cq(struct ibv_cq *ibv_cq)
+{
+	return container_of(ibv_cq, struct cxi_ibv_cq, verbs_cq.cq);
+}
+
+static inline struct cxi_ibv_cq *to_cxi_ibv_cq_ex(struct ibv_cq_ex *cq_ex)
+{
+	return container_of(cq_ex, struct cxi_ibv_cq, verbs_cq.cq_ex);
+}
+
+static inline struct cxi_qp *to_cxi_qp(struct ibv_qp *ibv_qp)
+{
+	return container_of(ibv_qp, struct cxi_qp, vqp.qp);
+}
+
+static inline struct cxi_ah *to_cxi_ah(struct ibv_ah *ibv_ah)
+{
+	struct ibv_ah_ex *ah_ex = container_of(ibv_ah, struct ibv_ah_ex, ah_base);
+
+	return container_of(ah_ex, struct cxi_ah, ah_ex);
+}
+
+static inline struct cxi_ah *to_cxi_ah_ex(struct ibv_ah_ex *ah_ex)
+{
+	return container_of(ah_ex, struct cxi_ah, ah_ex);
+}
+
+#endif /* CXI_H */
diff --git a/providers/cxi/cxi_prov_hw.h b/providers/cxi/cxi_prov_hw.h
new file mode 100644
index 000000000000..f50499472d5a
--- /dev/null
+++ b/providers/cxi/cxi_prov_hw.h
@@ -0,0 +1,1838 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * Copyright 2018-2020 Cray Inc. All rights reserved
+ *
+ * CXI event queue and command queue definitions and accessors.
+ */
+
+#ifndef __CXI_PROV_HW
+#define __CXI_PROV_HW
+
+/* Userspace copy: stand in for the kernel types and headers. */
+#include <stdbool.h>
+#include <stdint.h>
+#include <errno.h>
+#include <string.h>
+#include <ccan/array_size.h>
+#include <util/util.h>
+
+typedef uint8_t u8;
+typedef uint32_t u32;
+typedef uint64_t u64;
+typedef int32_t s32;
+
+/*
+ * wp_fence() - Fence operation used before advancing the command queue write
+ * pointer. This ensures that all commands are write visible before hardware
+ * processing the write pointer update.
+ *
+ * wc_fence() - Fence operation used to ensuring ordering between writes to
+ * write combining buffers.
+ */
+
+#if defined(__aarch64__)
+
+#define aarch64_dmb(opt) ({ asm volatile("dmb " #opt::: "memory"); })
+
+#define sfence() aarch64_dmb(oshst)
+
+/* Data memory barrier with outer shareability is enough to ensure write
+ * ordering between host memory command writes and write pointer doorbell
+ * writes.
+ */
+#define wp_fence() aarch64_dmb(oshst)
+
+/* Data memory barrier with outer shareability is enough writes to device memory
+ * gather regions (i.e. write combined regions) are ordered with respect to
+ * subsequent device memory gather region writes.
+ */
+#define wc_fence() aarch64_dmb(oshst)
+
+#elif defined(__x86_64__)
+
+static inline void sfence(void)
+{
+	__asm__ __volatile__("sfence" ::: "memory");
+}
+
+#define wp_fence() sfence()
+#define wc_fence() sfence()
+
+#else
+#error "Unsupported CPU architecture"
+#endif
+
+#include <ethernet/cassini_user_defs.h>
+
+static const u8 amo_size[16] = { 1, 1, 2, 2, 4, 4, 8, 8, 4, 8, 8, 16, 16 };
+
+/*
+ * Padding needed for a command given the command size and
+ * position. eg. a command of size 3 (256 bytes), with a wr_ptr at
+ * pos % 8 = 2 needs pad_slots[2][3] = 6 32-bytes block.
+ */
+static const u32 __cxi_pad_slots[8][4] = { { 0, 0, 0, 0 }, { 0, 1, 3, 7 }, { 0, 0, 2, 6 },
+					   { 0, 1, 1, 5 }, { 0, 0, 0, 4 }, { 0, 1, 3, 3 },
+					   { 0, 0, 2, 2 }, { 0, 1, 1, 1 } };
+
+/*
+ * Number of 32-bytes slots needed for a command
+ */
+static const u32 __cxi_cmd_slots[4] = { 1, 2, 4, 8 };
+
+/*
+ * Return the command size to fit a certain payload. 32 bytes or less
+ * return 0 (C_CMD_SIZE_32B), 33 to 64 returns 1 (C_CMD_SIZE_64B), ...
+ */
+static inline enum c_cmd_size __cxi_cmd_size(u32 size)
+{
+	if (size <= 16)
+		return C_CMD_SIZE_32B;
+	else
+		return (enum c_cmd_size)(8 * sizeof(u64) - __builtin_clzll((size - 1)) - 5);
+}
+
+/*
+ * Note.
+ *
+ * The hardware command granularity is 64 bytes (a slot). However the
+ * hardware also support 32 bytes commands. If a command is 32 bytes,
+ * there will always be a second 32 bytes command in that 64 bytes
+ * slot, and may be a NoOp.
+ */
+
+struct cxi_cmd32 {
+	u8 pad[32];
+};
+
+#define C_CQ_CMD_SIZE 64
+#define C_CQ_FIRST_WR_PTR 4
+#define C_CQ_FIRST_WR_PTR_32 (2 * C_CQ_FIRST_WR_PTR)
+
+#define LL_OFFSET(wp32) ((((wp32) / 2) & 0x0f) * 64)
+
+struct cxi_cmd64 {
+	u8 pad[C_CQ_CMD_SIZE];
+};
+
+union c_cmdu {
+	u8 u8;
+	struct c_cmd command;
+	struct c_cstate_cmd c_state;
+	struct c_idc_hdr idc_hdr;
+	struct c_idc_eth_cmd idc_eth;
+	struct c_idc_put_cmd idc_put;
+	struct c_idc_amo_cmd idc_amo;
+	struct c_idc_msg_hdr idc_msg;
+	struct c_nomatch_dma_cmd nomatch_dma;
+	struct c_full_dma_cmd full_dma;
+	struct c_dma_amo_cmd dma_amo;
+	struct c_dma_eth_cmd dma_eth;
+	struct c_ct_cmd ct;
+	struct c_cq_cmd cq;
+	struct c_target_cmd target;
+	struct c_set_state_cmd set_state;
+};
+
+/* User command queue */
+struct cxi_cq {
+	/* Command queue size */
+	u32 size;
+
+	/* Memory mapped write pointer location */
+	u64 *wp_addr;
+
+	/* Low-latency write regions. */
+	u8 *ll_64;
+	u8 *ll_128a;
+	u8 *ll_128u;
+
+	/* CQ status and commands buffer. CQ status occupies the first 8 32-byte
+	 * slots. Commands start after.
+	 */
+	union {
+		struct cxi_cmd32 *cmds32;
+		volatile struct c_cq_status *status;
+	};
+	u64 rp32;
+
+	/* CQ index. Transmit CQs use 0 to 1023, and target CQs use
+	 * 1024 to 1535. Use cxi_cq_get_cqn() to retrieve the CQ
+	 * number, going from 0 to 1023, or 0 to 512 respectively.
+	 */
+	u32 idx;
+
+	/* 32-bytes internal write pointer */
+	u32 size32;
+	u64 wp32;
+	u64 hw_wp32;
+};
+
+#define C_EE_CFG_ECB_SIZE 64
+union c_event {
+	/* Use as event header, to access event_size and event_type
+	 * only
+	 */
+	struct c_event_cmd_fail hdr;
+
+	struct c_event_initiator_short init_short;
+	struct c_event_initiator_long init_long;
+	struct c_event_trig_op_short trig_short;
+	struct c_event_trig_op_long trig_long;
+	struct c_event_cmd_fail cmd_fail;
+	struct c_event_target_long tgt_long;
+	struct c_event_target_short tgt_short;
+	struct c_event_target_enet enet;
+	struct c_event_enet_fgfc enet_fgfc;
+	struct c_event_timestamp timestamp;
+	struct c_event_eq_switch eq_switch;
+	struct c_event_pct pct;
+};
+
+#define C_LE_EVENT_CT_BYTES BIT(0)
+#define C_LE_EVENT_CT_OVERFLOW BIT(1)
+#define C_LE_EVENT_CT_COMM BIT(2)
+#define C_LE_EVENT_UNLINK_DISABLE BIT(3)
+#define C_LE_EVENT_SUCCESS_DISABLE BIT(4)
+#define C_LE_EVENT_COMM_DISABLE BIT(5)
+#define C_LE_EVENT_LINK_DISABLE BIT(6)
+#define C_LE_UNRESTRICTED_END_RO BIT(7)
+#define C_LE_UNRESTRICTED_BODY_RO BIT(8)
+#define C_LE_UNEXPECTED_HDR_DISABLE BIT(9)
+#define C_LE_USE_ONCE BIT(10)
+#define C_LE_NO_TRUNCATE BIT(11)
+#define C_LE_MANAGE_LOCAL BIT(12)
+#define C_LE_OP_GET BIT(13)
+#define C_LE_OP_PUT BIT(14)
+#define C_LE_RESTART_SEQ BIT(15)
+
+static inline void cxi_target_cmd_setopts(struct c_target_cmd *cmd, u32 flags)
+{
+	if (flags & C_LE_EVENT_CT_BYTES)
+		cmd->event_ct_bytes = 1;
+	if (flags & C_LE_EVENT_CT_OVERFLOW)
+		cmd->event_ct_overflow = 1;
+	if (flags & C_LE_EVENT_CT_COMM)
+		cmd->event_ct_comm = 1;
+	if (flags & C_LE_EVENT_UNLINK_DISABLE)
+		cmd->event_unlink_disable = 1;
+	if (flags & C_LE_EVENT_SUCCESS_DISABLE)
+		cmd->event_success_disable = 1;
+	if (flags & C_LE_EVENT_COMM_DISABLE)
+		cmd->event_comm_disable = 1;
+	if (flags & C_LE_EVENT_LINK_DISABLE)
+		cmd->event_link_disable = 1;
+	if (flags & C_LE_UNRESTRICTED_END_RO)
+		cmd->unrestricted_end_ro = 1;
+	if (flags & C_LE_UNRESTRICTED_BODY_RO)
+		cmd->unrestricted_body_ro = 1;
+	if (flags & C_LE_USE_ONCE)
+		cmd->use_once = 1;
+	if (flags & C_LE_NO_TRUNCATE)
+		cmd->no_truncate = 1;
+	if (flags & C_LE_MANAGE_LOCAL)
+		cmd->manage_local = 1;
+	if (flags & C_LE_OP_GET)
+		cmd->op_get = 1;
+	if (flags & C_LE_OP_PUT)
+		cmd->op_put = 1;
+	if (flags & C_LE_RESTART_SEQ)
+		cmd->restart_seq = 1;
+}
+
+static inline s32 cxi_init_event_rc(const union c_event *event)
+{
+	if (event->hdr.event_size == C_EVENT_SIZE_16_BYTE)
+		return event->init_short.return_code;
+	return event->init_long.return_code;
+}
+
+static inline s32 cxi_tgt_event_rc(const union c_event *event)
+{
+	if (event->hdr.event_size == C_EVENT_SIZE_32_BYTE)
+		return event->tgt_short.return_code;
+	return event->tgt_long.return_code;
+}
+
+static inline s32 cxi_event_rc(const union c_event *event)
+{
+	switch (event->hdr.event_type) {
+	case C_EVENT_PUT:
+	case C_EVENT_GET:
+	case C_EVENT_ATOMIC:
+	case C_EVENT_FETCH_ATOMIC:
+	case C_EVENT_PUT_OVERFLOW:
+	case C_EVENT_GET_OVERFLOW:
+	case C_EVENT_ATOMIC_OVERFLOW:
+	case C_EVENT_FETCH_ATOMIC_OVERFLOW:
+	case C_EVENT_LINK:
+	case C_EVENT_SEARCH:
+	case C_EVENT_STATE_CHANGE:
+	case C_EVENT_UNLINK:
+	case C_EVENT_RENDEZVOUS:
+	case C_EVENT_MATCH:
+		return cxi_tgt_event_rc(event);
+
+	case C_EVENT_SEND:
+	case C_EVENT_ACK:
+	case C_EVENT_REPLY:
+		return cxi_init_event_rc(event);
+
+	case C_EVENT_ETHERNET:
+		return event->enet.return_code;
+	case C_EVENT_COMMAND_FAILURE:
+		return event->cmd_fail.return_code;
+	case C_EVENT_TRIGGERED_OP:
+		if (event->hdr.event_size == C_EVENT_SIZE_16_BYTE)
+			return event->trig_short.return_code;
+		else
+			return event->trig_long.return_code;
+	case C_EVENT_ETHERNET_FGFC:
+		return event->enet_fgfc.return_code;
+	case C_EVENT_PCT:
+		return event->pct.return_code;
+	case C_EVENT_ERROR:
+		return C_RC_NO_EVENT;
+	case C_EVENT_TIMESTAMP:
+		return event->timestamp.return_code;
+	case C_EVENT_EQ_SWITCH:
+		return event->eq_switch.return_code;
+	case C_EVENT_NULL_EVENT:
+		return C_RC_NO_EVENT;
+	}
+
+	return C_RC_NO_EVENT;
+}
+
+/* Generate match_id. match_id is present in LEs, DMA commands and EQ events.
+ * The highest 'pid_bits' bits are used to hold a PID value. The remaining,
+ * low-order 32-'pid_bits' bits are used to store an Endpoint ID. When using a
+ * PtlTE configured for logical matching, the Endpoint ID represents a logical
+ * rank ID. Otherwise, the Endpoint ID contains a 20 bit physical NIC ID.
+ */
+#define CXI_MATCH_ID(pid_bits, pid, ep)                                                            \
+	((((pid) & ((1U << (pid_bits)) - 1)) << (32U - (pid_bits))) |                              \
+	 ((ep) & ((1U << (32 - (pid_bits))) - 1)))
+#define CXI_MATCH_ID_ANY CXI_MATCH_ID(C_DFA_PID_BITS_MAX, C_PID_ANY, C_RANK_ANY)
+
+#define CXI_MATCH_ID_PID(pid_bits, match_id) ((match_id) >> (32 - (pid_bits)))
+#define CXI_MATCH_ID_EP(pid_bits, match_id) ((match_id) & ((1U << (32 - (pid_bits))) - 1))
+
+/**
+ * struct cxi_rdzv_match_bits - Match bits used for Rendezvous Get.
+ * @match_bits: Match bits mirrored from the Rendezvous Put operation
+ * @transaction_type: Rendezvous transaction type, must match device
+ * configuration
+ * @rendezvous_id: Rendezvous ID used for Rendezvous Put operation
+ *
+ * The 64-bit rendezvous match bits value has two uses.
+ * 1. Rendezvous Put Initiator: Match bits used in a source buffer LE linked to
+ *    the rendezvous source PtlTE.
+ * 2. Rendezvous Put Target: Match bits used in a SW issued Get.
+ */
+struct cxi_rdzv_match_bits {
+	union {
+		struct {
+			u64 rendezvous_id : 8;
+			u64 transaction_type : 4;
+			u64 unused : 36;
+			u64 match_bits : 16;
+		};
+		u64 raw;
+	};
+};
+
+/**
+ * struct cxi_rdzv_user_ptr - User pointer format for Rendezvous Get events.
+ * @src_nid: Source fabric address NID of the Rendezvous Put
+ * @src_pid: Source fabric address PID of the Rendezvous Put
+ * @ptlte_index: PltTE index the target LE was appended on
+ * @rendezvous_id: Rendezvous ID from the Rendezvous Put
+ * @buffer_id: Buffer ID of the target LE from the Rendezvous Put
+ *
+ * The user_ptr field in a Reply event for a Hardware issued Rendezvous Get is
+ * formatted using this structure.
+ */
+struct cxi_rdzv_user_ptr {
+	union {
+		struct {
+			u64 src_nid : 20;
+			u64 src_pid : 9;
+			u64 ptlte_index : 11;
+			u64 rendezvous_id : 8;
+			u64 buffer_id : 16;
+		};
+		u64 raw;
+	};
+};
+
+#define CT_INC_SUCCESS_OFFSET 0
+#define CT_INC_FAILURE_OFFSET 64
+#define CT_RESET_SUCCESS_OFFSET 128
+#define CT_RESET_FAILURE_OFFSET 192
+#define CT_SUCCESS_MASK ((1ULL << C_CT_SUCCESS_BITS) - 1)
+#define CT_FAILURE_MASK ((1ULL << C_CT_FAILURE_BITS) - 1)
+
+/* User counter */
+struct cxi_ct {
+	/* Memory mapped doorbell. */
+	u64 *doorbell;
+
+	/* The allocated CT number, which will be used in commands. */
+	u32 ctn;
+
+	/* Writeback buffer backpoint for CT owner. */
+	struct c_ct_writeback *wb;
+};
+
+/* Hardware reserves two event slots: one for detecting EQ overrun and the first
+ * slot for providing EQ status writeback.
+ */
+#define C_EQ_RESERVED_EVENT_SLOTS 2U
+
+/* User event queue */
+struct cxi_eq {
+	/* Event queue byte size */
+	u32 byte_size;
+
+	/* EQ software state, which includes the read pointer. Keep a
+	 * local copy and update the fields as needed before copying
+	 * it to the adapter.
+	 */
+	union c_ee_cfg_eq_sw_state sw_state;
+	u64 *sw_state_addr;
+
+	/* Cached status write-back timestamp. */
+	u64 last_ts_sec;
+	u64 last_ts_ns;
+
+	/* Current read offset */
+	u32 rd_offset;
+
+	/* Previous read offset - before last call to
+	 * cxi_eq_ack_events()
+	 */
+	u32 prev_rd_offset;
+
+	/* The allocated EQ number, which will be used in commands. */
+	u32 eqn;
+
+	/* Backpointer for the owner of the EQ. */
+	void *context;
+
+	union {
+		/* Ring buffer for events */
+		u8 *events;
+
+		/* EQ status write-back pointer. Updated when the number of free
+		 * events crosses a configurable threshold, or when events are
+		 * dropped.
+		 */
+		struct c_eq_status *status;
+	};
+};
+
+/* Check to see if command queue is empty. */
+static inline bool cxi_cq_empty(struct cxi_cq *cq)
+{
+	u64 wp = cq->wp32 / 2;
+
+	return wp == cq->status->rd_ptr;
+}
+
+/*
+ * Advance the internal write pointer for the given command
+ * size. cmd_size is 0, 1, 2 or 3 (C_CMD_SIZE_XXX).
+ * If the write pointer wraps, set wp32 to the first valid offset for a command.
+ * The start of the queue is used by Cassini to return status.
+ */
+static inline void __cxi_cq_advance_wp(struct cxi_cq *cq, enum c_cmd_size cmd_size)
+{
+	cq->wp32 = (cq->wp32 + (1 << cmd_size));
+	if (cq->wp32 >= cq->size32)
+		cq->wp32 = C_CQ_FIRST_WR_PTR_32;
+}
+
+/*
+ * Return the number of usable slots in the queue using the cached read
+ * pointer. Remove 1 full 64-bytes slot to prevent queue overrun (wr_ptr ==
+ * rd_ptr). Remove 4 full slots because the start of the queue is used by
+ * Cassini to return rd_ptr and status.
+ */
+static inline s32 __cxi_cq_free_slots_check(const struct cxi_cq *cq)
+{
+	if (cq->wp32 >= cq->rp32)
+		return cq->size32 - cq->wp32 + cq->rp32 - 2 - C_CQ_FIRST_WR_PTR_32;
+	else
+		return cq->rp32 - cq->wp32 - 2;
+}
+
+/*
+ * Return the number of usable slots in the queue.
+ *
+ * Cassini regularly writes the read pointer to host memory. Avoid accessing
+ * the read pointer to reduce expensive loads from memory.
+ */
+static inline s32 __cxi_cq_free_slots(struct cxi_cq *cq)
+{
+	s32 slots = __cxi_cq_free_slots_check(cq);
+
+	if (slots < 16) {
+		cq->rp32 = cq->status->rd_ptr * 2;
+		slots = __cxi_cq_free_slots_check(cq);
+	}
+
+	return slots;
+}
+
+/**
+ * cxi_cq_update_wp() - Update the real write pointer.
+ *
+ * This lets the rest of the software manage the ring buffer as
+ * 64-bytes slots, while internally it's managed as 32 bytes slots.
+ *
+ * If the internal write pointer is odd, add a NoOp to pad to a 64
+ * bytes block.
+ *
+ * Users should not call this function. Instead, they should use
+ * cxi_cq_ll_ring() or cxi_cq_ring().
+ */
+static inline void cxi_cq_update_wp(struct cxi_cq *cq)
+{
+	if (cq->wp32 & 1) {
+		struct cxi_cmd32 *cmd = &cq->cmds32[cq->wp32];
+
+		/* Command opcode and DFA must be cleared */
+		memset(cmd->pad, 0, sizeof(u64));
+		__cxi_cq_advance_wp(cq, C_CMD_SIZE_32B);
+	}
+
+	/* Ensure commands are in memory. */
+	wp_fence();
+}
+
+/**
+ * cxi_memcpy_aligned() - Copy to 64-bit aligned buffer.
+ *
+ * dest and n must be 64-bit aligned.
+ */
+static inline void cxi_memcpy_aligned(void *dest, const void *src, size_t n)
+{
+	size_t i;
+
+	for (i = 0; i < n / 8; i++)
+		((u64 *)dest)[i] = ((u64 *)src)[i];
+}
+
+/**
+ * __cxi_cq_inc_hw_wp32() - Increment software's mirror of the hardware write
+ * pointer by count amount of 32-byte chunks. Count must not exceed CQ size.
+ */
+static inline void __cxi_cq_inc_hw_wp32(struct cxi_cq *cq, u32 count)
+{
+	cq->hw_wp32 += count;
+	if (cq->hw_wp32 == cq->size32)
+		cq->hw_wp32 = C_CQ_FIRST_WR_PTR_32;
+}
+
+/**
+ * cxi_cq_ll_write64() - Write commands to 64-byte low-latency region.
+ *
+ * Note: Users should not call this function.
+ */
+static inline void cxi_cq_ll_write64(struct cxi_cq *cq)
+{
+	struct cxi_cmd64 *ll = (struct cxi_cmd64 *)(cq->ll_64 + LL_OFFSET(cq->hw_wp32));
+
+	cxi_memcpy_aligned(ll, &cq->cmds32[cq->hw_wp32], sizeof(struct cxi_cmd64));
+
+	__cxi_cq_inc_hw_wp32(cq, 2);
+}
+
+/**
+ * cxi_cq_ll_write128_aligned() - Write commands to 128-byte aligned
+ * low-latency region. The CQ hardware write pointer must be aligned to a
+ * 128-byte boundary (i.e. hw_wp32 % 8 == 0, 4).
+ *
+ * Note: Users should not call this function.
+ */
+static inline void cxi_cq_ll_write128_aligned(struct cxi_cq *cq)
+{
+	struct cxi_cmd64 *ll = (struct cxi_cmd64 *)(cq->ll_128a + LL_OFFSET(cq->hw_wp32));
+
+	cxi_memcpy_aligned(ll, &cq->cmds32[cq->hw_wp32], sizeof(struct cxi_cmd64) * 2);
+
+	__cxi_cq_inc_hw_wp32(cq, 4);
+}
+
+/**
+ * cxi_cq_ll_write128_unaligned() - Write commands to 128-byte unaligned
+ * low-latency region. The CQ hardware write pointer must be unaligned to a
+ * 128-byte boundary (i.e. hw_wp32 % 8 == 2, 6).
+ *
+ * Note: Users should not call this function.
+ */
+static inline void cxi_cq_ll_write128_unaligned(struct cxi_cq *cq)
+{
+	struct cxi_cmd64 *ll;
+
+	/*
+	 * These two 32-byte slots MUST be NOOPs. Thus, skip over them in the
+	 * command queue since hardware will skip the corresponding 64-byte
+	 * slot.
+	 */
+	__cxi_cq_inc_hw_wp32(cq, 2);
+
+	ll = (struct cxi_cmd64 *)(cq->ll_128u + LL_OFFSET(cq->hw_wp32));
+
+	cxi_memcpy_aligned(ll, &cq->cmds32[cq->hw_wp32], sizeof(struct cxi_cmd64) * 2);
+
+	__cxi_cq_inc_hw_wp32(cq, 4);
+}
+
+/**
+ * cxi_cq_ring() - Update the CQ write pointer and ring the CQ to
+ * execute the new posted commands.
+ *
+ * After posting one or more commands, the user would call this
+ * function to let the new work start.
+ *
+ * @cq: the command queue
+ */
+static inline void cxi_cq_ring(struct cxi_cq *cq)
+{
+	u64 wr_ptr;
+
+	if (cq->wp32 == cq->hw_wp32)
+		return;
+
+	cxi_cq_update_wp(cq);
+
+	cq->hw_wp32 = cq->wp32;
+	wr_ptr = cq->wp32 / 2;
+	*cq->wp_addr = wr_ptr;
+	wc_fence();
+}
+
+/**
+ * cxi_cq_ll_ring() - Commit outstanding commands to hardware using the
+ * low-latency write mechanism. This function will account for the alignment of
+ * the CQ hardware write pointer to ensure that the proper low-latency region
+ * is written to. This function guarantees that all commands are committed to
+ * HW. A standard doorbell ring may be used to accomplish that.
+ *
+ * Note: 256-byte commands cannot use the low-latency region. A standard
+ * doorbell ring is used to commit incompatible commands.
+ */
+static inline void cxi_cq_ll_ring(struct cxi_cq *cq)
+{
+	const struct c_cmd *cmd;
+	s32 cmd32_count;
+
+	if (cq->wp32 == cq->hw_wp32)
+		return;
+
+	cmd = (struct c_cmd *)&cq->cmds32[cq->hw_wp32];
+	if (cmd->cmd_size == C_CMD_SIZE_256B) {
+		cxi_cq_ring(cq);
+		return;
+	}
+
+	/* Align CQ to 64-byte boundary. */
+	cxi_cq_update_wp(cq);
+
+	cmd32_count = cq->wp32 - cq->hw_wp32;
+	if (cmd32_count < 0)
+		cmd32_count = cq->size32 - cq->hw_wp32;
+
+	/*
+	 * Identify the low-latency region to be written based on the CQ
+	 * hardware write pointer alignment.
+	 */
+	if (cmd32_count == 2) {
+		cxi_cq_ll_write64(cq);
+	} else if (cq->hw_wp32 % 4) {
+		cmd = (struct c_cmd *)&cq->cmds32[cq->hw_wp32];
+
+		if (cmd->opcode == C_CMD_NOOP) {
+			cmd = (struct c_cmd *)&cq->cmds32[cq->hw_wp32 + 2];
+
+			if (cmd->cmd_size == C_CMD_SIZE_256B) {
+				cxi_cq_ring(cq);
+				return;
+			}
+
+			cxi_cq_ll_write128_unaligned(cq);
+		} else {
+			cxi_cq_ll_write64(cq);
+		}
+	} else {
+		cxi_cq_ll_write128_aligned(cq);
+	}
+
+	/* Flush WC buffers. */
+	wc_fence();
+
+	/* Perform a doorbell ring if there are more commands ready. */
+	if (cq->wp32 != cq->hw_wp32)
+		cxi_cq_ring(cq);
+}
+
+/**
+ * cxi_cq_align_for_cmd() - Prepare command queue for new command
+ *
+ * Check whether the command queue has enough space for cmd_size
+ * 32-bytes blocks. For the current implementation we must ensure that
+ * 1 64-bytes block (ie. 2 32 bytes blocks) is always free to avoid
+ * queue wrap around. If the command doesn't align with the current
+ * block, prepend one or more NoOp for padding.
+ */
+static inline s32 cxi_cq_align_for_cmd(struct cxi_cq *cq, enum c_cmd_size cmd_size)
+{
+	u32 pad_slots;
+	u32 cmd_slots;
+
+	if ((unsigned int)cmd_size >= ARRAY_SIZE(__cxi_cmd_slots) || !cq->status ||
+	    cq->size32 < C_CQ_FIRST_WR_PTR_32 + 8 || cq->size32 % 8 ||
+	    cq->wp32 < C_CQ_FIRST_WR_PTR_32 || cq->wp32 >= cq->size32)
+		return -EINVAL;
+	pad_slots = __cxi_pad_slots[cq->wp32 % 8][cmd_size];
+	cmd_slots = __cxi_cmd_slots[cmd_size];
+
+	/* Space available in the queue */
+	if (__cxi_cq_free_slots(cq) < (s32)(cmd_slots + pad_slots))
+		return -ENOSPC;
+
+	if (pad_slots) {
+		struct cxi_cmd32 *cmd = &cq->cmds32[cq->wp32];
+		u32 i;
+
+		for (i = 0; i < pad_slots; i++, cmd++) {
+			/* Command opcode and DFA must be cleared */
+			memset(cmd->pad, 0, 8);
+		}
+
+		cq->wp32 += pad_slots;
+		if (cq->wp32 >= cq->size32)
+			cq->wp32 = C_CQ_FIRST_WR_PTR_32;
+	}
+
+	return 0;
+}
+
+/**
+ * cxi_cq_get_cqn() - Return the CQ number
+ *
+ * From the allocated CQ index, return its number, which ranges from 0
+ * to 1023 for transmit CQs, and 0 to 511 for target CQs.
+ *
+ * @cq: the command queue
+ */
+static inline u32 cxi_cq_get_cqn(const struct cxi_cq *cq)
+{
+	if (cq->idx >= C_NUM_TRANSMIT_CQS)
+		return cq->idx - C_NUM_TRANSMIT_CQS;
+	else
+		return cq->idx;
+}
+
+/**
+ * cxi_cq_align_for_ct128_cmd() - Prepare command queue for new CT command
+ *
+ * For CT commands, the NoOp must be of type C_CMD_TYPE_CT. Commands
+ * on these queues are also only 64 or 128 bytes. Only called for 128
+ * bytes commands, as 64 bytes commands will never need padding.
+ */
+static inline s32 cxi_cq_align_for_ct128_cmd(struct cxi_cq *cq)
+{
+	const enum c_cmd_size cmd_size = C_CMD_SIZE_128B;
+	const u32 pad_slots = __cxi_pad_slots[cq->wp32 % 8][cmd_size];
+	const s32 cmd_slots = __cxi_cmd_slots[cmd_size];
+
+	/* Space available in the queue */
+	if (__cxi_cq_free_slots(cq) < (s32)(cmd_slots + pad_slots))
+		return -ENOSPC;
+
+	/* A triggger TXQ only accepts 64-byte or 128-byte commands. If padding
+	 * is required for a 128-byte command, it only needs to be padded with a
+	 * single 64-byte command.
+	 */
+	if (pad_slots) {
+		struct c_cmd *cmd = (struct c_cmd *)&cq->cmds32[cq->wp32];
+
+		/* Command opcode and DFA must be cleared */
+		memset(cmd, 0, 8);
+		cmd->cmd_type = C_CMD_TYPE_CT;
+		cmd->cmd_size = C_CMD_SIZE_64B;
+		cmd->opcode = C_CMD_CT_NOOP;
+
+		cq->wp32 += pad_slots;
+		if (cq->wp32 >= cq->size32)
+			cq->wp32 = C_CQ_FIRST_WR_PTR_32;
+	}
+
+	return 0;
+}
+
+/**
+ * cxi_cq_emit_cq_cmd() - Emit a NOOP or FENCE CQ command
+ *
+ * opcode is either C_CMD_CQ_NOOP or C_CMD_CQ_FENCE.
+ */
+static inline s32 __attribute__((warn_unused_result)) cxi_cq_emit_cq_cmd(struct cxi_cq *cq,
+									 u32 opcode)
+{
+	struct c_cq_cmd *cmd;
+	s32 rc;
+	const enum c_cmd_size cmd_size = C_CMD_SIZE_64B;
+
+	rc = cxi_cq_align_for_cmd(cq, cmd_size);
+	if (rc)
+		return rc;
+
+	cmd = (struct c_cq_cmd *)&cq->cmds32[cq->wp32];
+
+	/* Command opcode and DFA must be cleared */
+	memset(cmd, 0, 8);
+	cmd->command.cmd_type = C_CMD_TYPE_CQ;
+	cmd->command.cmd_size = cmd_size;
+	cmd->command.opcode = opcode;
+
+	__cxi_cq_advance_wp(cq, cmd_size);
+
+	return 0;
+}
+
+/**
+ * cxi_cq_emit_cq_lcid() - Emit an LCID CQ command
+ *
+ * The LCID command must be prepared differently than the NOOP and
+ * FENCE commands; it must be 128-bytes aligned, and padded with a NOP
+ * command after it.
+ */
+static inline s32 __attribute__((warn_unused_result)) cxi_cq_emit_cq_lcid(struct cxi_cq *cq,
+									  u8 lcid)
+{
+	struct c_cq_cmd *cmd;
+	s32 rc;
+	const enum c_cmd_size cmd_size = C_CMD_SIZE_64B;
+
+	rc = cxi_cq_align_for_cmd(cq, C_CMD_SIZE_128B);
+	if (rc)
+		return rc;
+
+	cmd = (struct c_cq_cmd *)&cq->cmds32[cq->wp32];
+
+	/* Command opcode and DFA must be cleared */
+	memset(cmd, 0, 8);
+	cmd->command.cmd_type = C_CMD_TYPE_CQ;
+	cmd->command.cmd_size = cmd_size;
+	cmd->command.opcode = C_CMD_CQ_LCID;
+	cmd->lcid = lcid;
+
+	__cxi_cq_advance_wp(cq, cmd_size);
+
+	rc = cxi_cq_emit_cq_cmd(cq, C_CMD_CQ_NOOP);
+	if (rc)
+		return -ENOSPC; /* not possible */
+
+	return 0;
+}
+
+/**
+ * cxi_cq_emit_cmd() - Emit the given command.
+ *
+ * The command may use 1 to 4 slots. Padding will be added if needed.
+ */
+static inline s32 cxi_cq_emit_cmd(struct cxi_cq *cq, const union c_cmdu *cmd_in, size_t cmd_length)
+{
+	struct c_cmd *cmd;
+	const enum c_cmd_size cmd_size = __cxi_cmd_size(cmd_length);
+	s32 rc;
+
+	rc = cxi_cq_align_for_cmd(cq, cmd_size);
+	if (rc)
+		return rc;
+
+	cmd = (struct c_cmd *)&cq->cmds32[cq->wp32];
+	memcpy(cmd, cmd_in, cmd_length);
+	cmd->cmd_size = cmd_size;
+
+	__cxi_cq_advance_wp(cq, cmd_size);
+
+	return 0;
+}
+
+/**
+ * cxi_cq_emit_c_state() - Emit an IDC C_STATE command.
+ *
+ * the command uses 1 slot. Padding will be added if needed.
+ */
+static inline s32 cxi_cq_emit_c_state(struct cxi_cq *cq, const struct c_cstate_cmd *cmd_in)
+{
+	struct c_cstate_cmd *cmd;
+	s32 rc;
+
+	rc = cxi_cq_align_for_cmd(cq, C_CMD_SIZE_32B);
+	if (rc)
+		return -ENOSPC;
+
+	cmd = (struct c_cstate_cmd *)&cq->cmds32[cq->wp32];
+
+	*cmd = *cmd_in;
+
+	cmd->command.cmd_type = C_CMD_TYPE_IDC;
+	cmd->command.cmd_size = C_CMD_SIZE_32B; /* Always 32 bytes */
+	cmd->command.opcode = C_CMD_CSTATE;
+	cmd->length = sizeof(struct c_cstate_cmd);
+
+	__cxi_cq_advance_wp(cq, C_CMD_SIZE_32B);
+
+	return 0;
+}
+
+/**
+ * cxi_cq_emit_idc_put() - Emit an IDC PUT command.
+ *
+ * May use 1 to 4 slots. Padding will be added if needed.
+ */
+static inline s32 cxi_cq_emit_idc_put(struct cxi_cq *cq, const struct c_idc_put_cmd *cmd_in,
+				      const void *payload, size_t payload_length)
+{
+	struct c_idc_put_cmd *cmd;
+	const enum c_cmd_size cmd_size = __cxi_cmd_size(16 + payload_length);
+	s32 rc;
+
+	rc = cxi_cq_align_for_cmd(cq, cmd_size);
+	if (rc)
+		return rc;
+
+	cmd = (struct c_idc_put_cmd *)&cq->cmds32[cq->wp32];
+
+	*cmd = *cmd_in;
+
+	cmd->idc_header.command.cmd_size = cmd_size;
+	cmd->idc_header.command.cmd_type = C_CMD_TYPE_IDC;
+	cmd->idc_header.command.opcode = C_CMD_PUT;
+
+	memcpy(cmd->data, payload, payload_length);
+
+	/* account for header */
+	cmd->idc_header.length = sizeof(cmd->idc_header) + payload_length;
+
+	__cxi_cq_advance_wp(cq, cmd_size);
+
+	return 0;
+}
+
+/**
+ * cxi_cq_emit_idc_msg() - Emit an IDC small message command.
+ *
+ * May use 1 to 4 slots. Padding will be added if needed.
+ *
+ * May return -EINVAL if payload_length is greater than
+ * C_MAX_IDC_PAYLOAD_UNR
+ */
+static inline s32 cxi_cq_emit_idc_msg(struct cxi_cq *cq, const struct c_idc_msg_hdr *cmd_in,
+				      const void *payload, size_t payload_length)
+{
+	struct c_idc_msg_hdr *cmd;
+	enum c_cmd_size cmd_size = __cxi_cmd_size(sizeof(struct c_idc_msg_hdr) + payload_length);
+	s32 rc;
+
+	if (payload_length > C_MAX_IDC_PAYLOAD_UNR)
+		return -EINVAL;
+	if (cmd_size == C_CMD_SIZE_32B)
+		cmd_size = C_CMD_SIZE_64B; /* Minimum size is 64B */
+
+	rc = cxi_cq_align_for_cmd(cq, cmd_size);
+	if (rc)
+		return rc;
+
+	cmd = (struct c_idc_msg_hdr *)&cq->cmds32[cq->wp32];
+
+	*cmd = *cmd_in;
+
+	cmd->command.cmd_size = cmd_size;
+	cmd->command.cmd_type = C_CMD_TYPE_IDC;
+	cmd->command.opcode = C_CMD_SMALL_MESSAGE;
+
+	memcpy(cmd->data, payload, payload_length);
+
+	/* account for header */
+	cmd->length = sizeof(struct c_idc_msg_hdr) + payload_length;
+
+	__cxi_cq_advance_wp(cq, cmd_size);
+
+	return 0;
+}
+
+/**
+ * cxi_cq_emit_idc_eth() - Emit an IDC Ethernet command.
+ *
+ * May use 1 to 4 slots. Padding will be added if needed.
+ */
+static inline s32 cxi_cq_emit_idc_eth(struct cxi_cq *cq, const struct c_idc_eth_cmd *cmd_in,
+				      const void *payload, size_t payload_length)
+{
+	struct c_idc_eth_cmd *cmd;
+	const u64 len = sizeof(struct c_idc_eth_cmd) + payload_length;
+	const enum c_cmd_size cmd_size = __cxi_cmd_size(len);
+	s32 rc;
+
+	rc = cxi_cq_align_for_cmd(cq, cmd_size);
+	if (rc)
+		return rc;
+
+	cmd = (struct c_idc_eth_cmd *)&cq->cmds32[cq->wp32];
+
+	*cmd = *cmd_in;
+
+	cmd->command.cmd_size = cmd_size;
+	cmd->command.cmd_type = C_CMD_TYPE_IDC;
+	cmd->command.opcode = C_CMD_ETHERNET_TX;
+
+	memcpy(cmd->data, payload, payload_length);
+
+	cmd->length = len;
+
+	__cxi_cq_advance_wp(cq, cmd_size);
+
+	return 0;
+}
+
+/**
+ * cxi_cq_emit_idc_amo() - Emit an IDC AMO command.
+ *
+ * If possible, emit the AMO with a small_amo request.
+ */
+static inline s32 cxi_cq_emit_idc_amo(struct cxi_cq *cq, const struct c_idc_amo_cmd *cmd_in,
+				      bool fetching)
+{
+	s32 rc;
+	enum c_cmd_size cmd_size;
+
+	if (cmd_in->atomic_type == C_AMO_TYPE_DOUBLE_COMPLEX_T ||
+	    cmd_in->atomic_op == C_AMO_OP_CSWAP || cmd_in->atomic_op == C_AMO_OP_AXOR || fetching) {
+		struct c_idc_amo_cmd *cmd;
+
+		cmd_size = C_CMD_SIZE_64B;
+
+		rc = cxi_cq_align_for_cmd(cq, cmd_size);
+		if (rc)
+			return rc;
+
+		cmd = (struct c_idc_amo_cmd *)&cq->cmds32[cq->wp32];
+
+		*cmd = *cmd_in;
+
+		cmd->idc_header.command.cmd_size = cmd_size;
+		cmd->idc_header.command.cmd_type = C_CMD_TYPE_IDC;
+		cmd->idc_header.command.opcode = fetching ? C_CMD_FETCHING_ATOMIC : C_CMD_ATOMIC;
+
+		/* Large AMOs always have a length of 64 bytes. */
+		cmd->idc_header.length = sizeof(*cmd);
+	} else {
+		struct c_idc_put_cmd *cmd;
+		struct c_small_amo_payload *payload;
+
+		cmd_size = C_CMD_SIZE_32B;
+
+		rc = cxi_cq_align_for_cmd(cq, cmd_size);
+		if (rc)
+			return rc;
+
+		cmd = (struct c_idc_put_cmd *)&cq->cmds32[cq->wp32];
+		payload = (struct c_small_amo_payload *)cmd->data;
+
+		cmd->idc_header = cmd_in->idc_header;
+
+		cmd->idc_header.command.cmd_size = cmd_size;
+		cmd->idc_header.command.cmd_type = C_CMD_TYPE_IDC;
+		cmd->idc_header.command.opcode = C_CMD_ATOMIC;
+
+		/* Small AMOs always have a length of 32 bytes. */
+		cmd->idc_header.length = 32;
+
+		payload->amo_op = cmd_in->atomic_op;
+		payload->amo_type = cmd_in->atomic_type;
+		payload->op1_word1 = cmd_in->op1_word1;
+	}
+
+	__cxi_cq_advance_wp(cq, cmd_size);
+
+	return 0;
+}
+
+/**
+ * cxi_cq_emit_dma_amo() - Emit a DMA AMO command.
+ *
+ * Uses 2 slots. Padding will be added if needed.
+ */
+static inline s32 cxi_cq_emit_dma_amo(struct cxi_cq *cq, struct c_dma_amo_cmd *cmd_in,
+				      bool fetching)
+{
+	struct c_dma_amo_cmd *cmd;
+	const enum c_cmd_size cmd_size = C_CMD_SIZE_128B;
+	s32 rc;
+
+	rc = cxi_cq_align_for_cmd(cq, cmd_size);
+	if (rc)
+		return rc;
+
+	cmd = (struct c_dma_amo_cmd *)&cq->cmds32[cq->wp32];
+
+	*cmd = *cmd_in;
+
+	cmd->command.cmd_size = cmd_size;
+	cmd->command.cmd_type = C_CMD_TYPE_DMA;
+	cmd->command.opcode = fetching ? C_CMD_FETCHING_ATOMIC : C_CMD_ATOMIC;
+	cmd->request_len = amo_size[cmd->atomic_type];
+
+	__cxi_cq_advance_wp(cq, cmd_size);
+
+	return 0;
+}
+
+/**
+ * cxi_cq_emit_dma_eth() - Emit a DMA ethernet command.
+ */
+static inline s32 cxi_cq_emit_dma_eth(struct cxi_cq *cq, const struct c_dma_eth_cmd *cmd_in)
+{
+	const enum c_cmd_size cmd_size = C_CMD_SIZE_128B;
+	struct c_dma_eth_cmd *cmd;
+	u32 total_len = 0;
+	s32 rc;
+	s32 i;
+
+	rc = cxi_cq_align_for_cmd(cq, cmd_size);
+	if (rc)
+		return rc;
+
+	cmd = (struct c_dma_eth_cmd *)&cq->cmds32[cq->wp32];
+
+	*cmd = *cmd_in;
+
+	cmd->command.cmd_type = C_CMD_TYPE_DMA;
+	cmd->command.cmd_size = cmd_size;
+	cmd->command.opcode = C_CMD_ETHERNET_TX;
+
+	for (i = 0; i < cmd_in->num_segments; i++)
+		total_len += cmd_in->len[i];
+	cmd->total_len = total_len;
+
+	__cxi_cq_advance_wp(cq, cmd_size);
+
+	return 0;
+}
+
+/**
+ * cxi_cq_emit_dma() - Emit a non restricted DMA command.
+ */
+static inline s32 cxi_cq_emit_dma(struct cxi_cq *cq, struct c_full_dma_cmd *cmd_in)
+{
+	struct c_full_dma_cmd *cmd;
+	s32 rc;
+	const enum c_cmd_size cmd_size = C_CMD_SIZE_64B;
+
+	rc = cxi_cq_align_for_cmd(cq, cmd_size);
+	if (rc)
+		return rc;
+
+	cmd = (struct c_full_dma_cmd *)&cq->cmds32[cq->wp32];
+
+	*cmd = *cmd_in;
+
+	cmd->command.cmd_type = C_CMD_TYPE_DMA;
+	cmd->command.cmd_size = cmd_size;
+
+	__cxi_cq_advance_wp(cq, cmd_size);
+
+	return 0;
+}
+
+/**
+ * cxi_cq_emit_nomatch_dma() - Emit a non-matching DMA command.
+ *
+ * This command is used to target a non-matching PtlTE where remote target
+ * events are not needed (restricted send option bit is always set). Valid
+ * command operations are CMD_NOMATCH_GET and CMD_NOMATCH_PUT.
+ *
+ * Note: With this command, only errors will be generated on the EQ. Use
+ * cxi_cq_emit_dma() with the restricted bit set if per transaction success
+ * events are needed.
+ */
+static inline s32 cxi_cq_emit_nomatch_dma(struct cxi_cq *cq, struct c_nomatch_dma_cmd *cmd_in)
+{
+	struct c_nomatch_dma_cmd *cmd;
+	s32 rc;
+	const enum c_cmd_size cmd_size = C_CMD_SIZE_32B;
+
+	rc = cxi_cq_align_for_cmd(cq, cmd_size);
+	if (rc)
+		return rc;
+
+	cmd = (struct c_nomatch_dma_cmd *)&cq->cmds32[cq->wp32];
+
+	*cmd = *cmd_in;
+
+	cmd->command.cmd_type = C_CMD_TYPE_DMA;
+	cmd->command.cmd_size = cmd_size;
+	cmd->restricted = 1;
+
+	__cxi_cq_advance_wp(cq, cmd_size);
+
+	return 0;
+}
+
+/**
+ * cxi_cq_emit_target() - Emit a target command.
+ *
+ * All the target commands (c_target_cmd and c_set_state) are 64
+ * bytes.
+ */
+static inline s32 cxi_cq_emit_target(struct cxi_cq *cq, const void *cmd_in)
+{
+	const enum c_cmd_size cmd_size = C_CMD_SIZE_64B;
+	struct c_target_cmd *cmd;
+
+	/* Space available in the queue */
+	if (__cxi_cq_free_slots(cq) < (int)__cxi_cmd_slots[cmd_size])
+		return -ENOSPC;
+
+	cmd = (struct c_target_cmd *)&cq->cmds32[cq->wp32];
+
+	memcpy(cmd, cmd_in, sizeof(*cmd));
+
+	cmd->command.cmd_type = C_CMD_TYPE_CQ;
+	cmd->command.cmd_size = cmd_size;
+
+	__cxi_cq_advance_wp(cq, cmd_size);
+
+	return 0;
+}
+
+/**
+ * cxi_cq_emit_ct() - Emit a counting event (CT) command without embedded data.
+ *
+ * This function can also be used for trigger event, trigger inc, and trigger
+ * set.
+ */
+static inline s32 cxi_cq_emit_ct(struct cxi_cq *cq, u32 opcode, const struct c_ct_cmd *cmd_in)
+{
+	const enum c_cmd_size cmd_size = C_CMD_SIZE_64B;
+	struct c_ct_cmd *cmd;
+
+	/* Space available in the queue */
+	if (__cxi_cq_free_slots(cq) < (int)__cxi_cmd_slots[cmd_size])
+		return -ENOSPC;
+
+	cmd = (struct c_ct_cmd *)&cq->cmds32[cq->wp32];
+
+	*cmd = *cmd_in;
+
+	cmd->command.cmd_type = C_CMD_TYPE_CT;
+	cmd->command.cmd_size = cmd_size;
+	cmd->command.opcode = opcode;
+
+	__cxi_cq_advance_wp(cq, cmd_size);
+
+	return 0;
+}
+
+/**
+ * cxi_cq_emit_trig_full_dma() - Emit a triggered full DMA command.
+ *
+ * Trigger command with embedded data is always 128 bytes.
+ */
+static inline s32 cxi_cq_emit_trig_full_dma(struct cxi_cq *cq, const struct c_ct_cmd *cmd_in,
+					    const struct c_full_dma_cmd *dma_in)
+{
+	const enum c_cmd_size cmd_size = C_CMD_SIZE_128B;
+	struct c_ct_cmd *cmd;
+	struct c_full_dma_cmd *dma;
+	s32 rc;
+
+	rc = cxi_cq_align_for_ct128_cmd(cq);
+	if (rc)
+		return rc;
+
+	cmd = (struct c_ct_cmd *)&cq->cmds32[cq->wp32];
+	dma = (struct c_full_dma_cmd *)cmd->embedded_dma;
+
+	*cmd = *cmd_in;
+	*dma = *dma_in;
+
+	cmd->command.cmd_type = C_CMD_TYPE_CT;
+	cmd->command.cmd_size = cmd_size;
+	cmd->command.opcode = C_CMD_CT_TRIG_DMA;
+
+	dma->command.cmd_type = C_CMD_TYPE_DMA;
+	dma->command.cmd_size = C_CMD_SIZE_64B;
+
+	__cxi_cq_advance_wp(cq, cmd_size);
+
+	return 0;
+}
+
+/**
+ * cxi_cq_emit_trig_nomatch_dma() - Emit a triggered nomatch DMA command.
+ *
+ * Trigger command with embedded data is always 128 bytes.
+ */
+static inline s32 cxi_cq_emit_trig_nomatch_dma(struct cxi_cq *cq, const struct c_ct_cmd *cmd_in,
+					       const struct c_nomatch_dma_cmd *dma_in)
+{
+	const enum c_cmd_size cmd_size = C_CMD_SIZE_128B;
+	struct c_ct_cmd *cmd;
+	struct c_nomatch_dma_cmd *dma;
+	s32 rc;
+
+	rc = cxi_cq_align_for_ct128_cmd(cq);
+	if (rc)
+		return rc;
+
+	cmd = (struct c_ct_cmd *)&cq->cmds32[cq->wp32];
+	dma = (struct c_nomatch_dma_cmd *)cmd->embedded_dma;
+
+	*cmd = *cmd_in;
+	*dma = *dma_in;
+
+	cmd->command.cmd_type = C_CMD_TYPE_CT;
+	cmd->command.cmd_size = cmd_size;
+	cmd->command.opcode = C_CMD_CT_TRIG_DMA;
+
+	dma->command.cmd_type = C_CMD_TYPE_DMA;
+	dma->command.cmd_size = C_CMD_SIZE_32B;
+	dma->restricted = 1;
+
+	__cxi_cq_advance_wp(cq, cmd_size);
+
+	return 0;
+}
+
+/**
+ * cxi_cq_emit_trig_dma_amo() Emit a triggered DMA AMO command.
+ *
+ * Trigger command with embedded data is always 128 bytes.
+ */
+static inline s32 cxi_cq_emit_trig_dma_amo(struct cxi_cq *cq, const struct c_ct_cmd *cmd_in,
+					   const struct c_dma_amo_cmd *amo_in, bool fetching)
+{
+	const enum c_cmd_size cmd_size = C_CMD_SIZE_128B;
+	struct c_ct_cmd *cmd;
+	struct c_dma_amo_cmd *amo;
+	s32 rc;
+
+	rc = cxi_cq_align_for_ct128_cmd(cq);
+	if (rc)
+		return rc;
+
+	cmd = (struct c_ct_cmd *)&cq->cmds32[cq->wp32];
+	amo = (struct c_dma_amo_cmd *)cmd->embedded_dma;
+
+	*cmd = *cmd_in;
+	*amo = *amo_in;
+
+	cmd->command.cmd_type = C_CMD_TYPE_CT;
+	cmd->command.cmd_size = cmd_size;
+	cmd->command.opcode = C_CMD_CT_TRIG_DMA;
+
+	amo->command.cmd_type = C_CMD_TYPE_DMA;
+	amo->command.cmd_size = C_CMD_SIZE_128B;
+	amo->command.opcode = fetching ? C_CMD_FETCHING_ATOMIC : C_CMD_ATOMIC;
+	amo->request_len = amo_size[amo->atomic_type];
+
+	__cxi_cq_advance_wp(cq, cmd_size);
+
+	return 0;
+}
+
+/**
+ * cxi_cq_init() - Initialize a command queue
+ * @cq: The command queue
+ * @cmds: The commands memory
+ * @count: Count (size) of command queue
+ * @launch_addr: The CQ launch address
+ * @cqn: Command queue number
+ */
+static inline void cxi_cq_init(struct cxi_cq *cq, struct cxi_cmd64 *cmds, u32 count,
+			       void *launch_addr, u32 idx)
+{
+	struct c_cmdq *la = (struct c_cmdq *)launch_addr;
+
+	cq->size = count;
+	cq->size32 = 2 * count;
+	cq->wp32 = C_CQ_FIRST_WR_PTR_32;
+	cq->hw_wp32 = cq->wp32;
+	cq->rp32 = cq->wp32;
+
+	/* Setting status pointer sets the commands pointer. */
+	if (cmds) {
+		cq->status = (struct c_cq_status *)&cmds[0];
+		cq->status->rd_ptr = C_CQ_FIRST_WR_PTR;
+		cq->status->return_code = C_RC_OK;
+	}
+
+	if (launch_addr) {
+		cq->wp_addr = (u64 *)launch_addr;
+		cq->ll_64 = (u8 *)la->ll_wr64a0123;
+		cq->ll_128a = (u8 *)la->ll_wr128a02;
+		cq->ll_128u = (u8 *)la->ll_wr128a13;
+	}
+	cq->idx = idx;
+}
+
+/**
+ * cxi_eq_empty() - Check if event queue is empty
+ */
+static inline bool cxi_eq_empty(struct cxi_eq *eq)
+{
+	u32 rd_offset = eq->rd_offset;
+	const union c_event *event = (union c_event *)(eq->events + rd_offset);
+
+	if (event->hdr.event_size == C_EVENT_SIZE_NO_EVENT)
+		return true;
+	else
+		return false;
+}
+
+/**
+ * cxi_eq_peek_event() - Get the next event on an event queue without advancing
+ *                       the software read pointer.
+ *
+ * Returns a pointer in the event queue.
+ */
+static inline const union c_event *cxi_eq_peek_event(struct cxi_eq *eq)
+{
+	u32 rd_offset = eq->rd_offset;
+	const volatile union c_event *event;
+	s32 rc_offset;
+
+again:
+	event = (union c_event *)(eq->events + rd_offset);
+
+	/* No event */
+	if (event->hdr.event_size == C_EVENT_SIZE_NO_EVENT)
+		return NULL;
+
+	/* Ensure the event has fully arrived by checking the return
+	 * code is not C_RC_NO_EVENT (0). The return_code is 6 bits in
+	 * the last byte of the event (so either offset 15, 31 or
+	 * 63).
+	 */
+	rc_offset = (8 << event->hdr.event_size) - 1;
+	if (((((u8 *)event)[rc_offset]) & 0x3f) == C_RC_NO_EVENT)
+		return NULL;
+
+	if (event->hdr.event_type == C_EVENT_NULL_EVENT) {
+		/* Consume the event and move to the next one */
+		rd_offset += (8 << event->hdr.event_size);
+		if (rd_offset >= eq->byte_size)
+			rd_offset = C_EE_CFG_ECB_SIZE;
+		eq->rd_offset = rd_offset;
+
+		goto again;
+	}
+
+	return (const union c_event *)event;
+}
+
+/**
+ * cxi_eq_next_event() - Advance the event queue to the next event.
+ */
+static inline void cxi_eq_next_event(struct cxi_eq *eq)
+{
+	const union c_event *event;
+	u32 rd_offset = eq->rd_offset;
+
+	event = (union c_event *)(eq->events + rd_offset);
+	rd_offset = eq->rd_offset + (8 << event->hdr.event_size);
+	if (rd_offset >= eq->byte_size)
+		rd_offset = C_EE_CFG_ECB_SIZE;
+	eq->rd_offset = rd_offset;
+}
+
+/**
+ * cxi_eq_get_event() - Get the next event on an event queue.
+ *
+ * Returns a pointer in the event queue. The event must be processed
+ * before calling cxi_eq_ack_events().
+ */
+static inline const union c_event *cxi_eq_get_event(struct cxi_eq *eq)
+{
+	const union c_event *event;
+
+	event = cxi_eq_peek_event(eq);
+	if (!event)
+		return NULL;
+
+	cxi_eq_next_event(eq);
+
+	return event;
+}
+
+/**
+ * cxi_eq_move_rp() - Move the EQ read pointer
+ * @eq: The EQ to have read pointer moved.
+ *
+ * There should be no need to call this function. Use cxi_eq_ack_events().
+ *
+ * Return: Updated read pointer
+ */
+static inline u64 cxi_eq_move_rp(struct cxi_eq *eq)
+{
+	u32 rd_offset = eq->rd_offset;
+	u32 prev_rd_offset = eq->prev_rd_offset;
+	u64 rd_ptr = rd_offset / C_EE_CFG_ECB_SIZE;
+	u8 *p = &eq->events[prev_rd_offset];
+
+	if (prev_rd_offset < rd_offset) {
+		memset(p, 0, rd_offset - prev_rd_offset);
+	} else if (prev_rd_offset > rd_offset) {
+		memset(p, 0, eq->byte_size - prev_rd_offset);
+		memset(eq->events + C_EE_CFG_ECB_SIZE, 0, rd_offset - C_EE_CFG_ECB_SIZE);
+	}
+	eq->prev_rd_offset = rd_offset;
+
+	return rd_ptr;
+}
+
+/**
+ * cxi_eq_ack_events() - Acknowledge consumed events in the event queue
+ *
+ * All events returned through cxi_eq_get_event() are cleared and the
+ * producer read pointer is advanced. These events must therefore be
+ * processed before calling this function.
+ *
+ * An application doesn't need to call this function after each event;
+ * it may process several events before.
+ */
+static inline void cxi_eq_ack_events(struct cxi_eq *eq)
+{
+	eq->sw_state.rd_ptr = cxi_eq_move_rp(eq);
+
+	*eq->sw_state_addr = eq->sw_state.qw;
+}
+
+/**
+ * cxi_eq_get_status() - Query for an event queue status update.
+ *
+ * Cassini updates event queue status when:
+ *
+ * -The number of free 64-byte events slots remaining in the queue crosses a
+ *  software configured threshold.
+ * -An event is dropped due to the event queue being full.
+ *
+ * Status fields of interest to providers are:
+ * -thld_sts: Asserted if the update was due to a fill threshold being crossed.
+ * -thld_id: Indicates the ID of the fill level threshold crossed (if thld_sts
+ *           is asserted).
+ * -unackd_dropped_event: Indicates that one or more events have been dropped
+ *                        since the last status update.
+ * -event_slots_free: The number of 64-byte event slots that were unused in the
+ *                    event queue buffer when the event queue status was updated.
+ * -timestamp_ns: The nanoseconds field of the real-time when the event queue
+ *                status was last updated.
+ * -timestamp_sec: The seconds field of the real-time when the event queue
+ *                 status was last updated.
+ *
+ * @eq: The event queue to query.
+ * @status: On success, contains a copy of the status update.
+ *
+ * Returns non-zero if a new event queue status update is available.
+ */
+static inline s32 cxi_eq_get_status(struct cxi_eq *eq, struct c_eq_status *status)
+{
+	struct c_eq_status status_cpy;
+	s32 tries = 100;
+
+	/* Fast path: return 0 if the last status looks old. */
+	if (eq->last_ts_ns == eq->status->timestamp_ns_cpy &&
+	    eq->last_ts_sec == eq->status->timestamp_sec_cpy)
+		return 0;
+
+	/* Read the entire status update. A status update may not be written
+	 * atomically on all architectures.  Re-read the full status until a
+	 * valid update is read.
+	 */
+	do {
+		memcpy(&status_cpy, eq->status, sizeof(status_cpy));
+
+		if (status_cpy.timestamp_ns == status_cpy.timestamp_ns_cpy &&
+		    status_cpy.timestamp_sec == status_cpy.timestamp_sec_cpy)
+			break;
+	} while (--tries);
+
+	/* Return 0 if a full status update was unavailable. */
+	if (!tries)
+		return 0;
+
+	/* Keep a record that we read this status update in software and return
+	 * the update.
+	 */
+	eq->last_ts_sec = status_cpy.timestamp_sec;
+	eq->last_ts_ns = status_cpy.timestamp_ns;
+
+	*status = status_cpy;
+	return 1;
+}
+
+/**
+ * cxi_eq_status_fill_level() - Return status update fill level.
+ *
+ * @eq: The EQ which generated the status update.
+ * @status: Pointer to a status update.
+ *
+ * Returns the fill level (as a percentage) reported by the provided status
+ * update. Valid only if status->thld_sts is set.
+ */
+static inline u32 cxi_eq_status_fill_level(struct cxi_eq *eq, struct c_eq_status *status)
+{
+	return 100 - status->event_slots_free * 100 / (eq->byte_size / C_EE_CFG_ECB_SIZE);
+}
+
+/**
+ * cxi_eq_get_drops() - Return non-zero if new events have been dropped.
+ *
+ * When there is insufficient space in the EQ for events to be delivered, new
+ * events are dropped. In this case the NIC performs an EQ status write-back
+ * indicating events were dropped. All subsequent status write-backs will
+ * indicate that events were dropped until drops are acknowledged.
+ *
+ * After observing that events were dropped, a user should recover space in the
+ * EQ and then acknowledge the dropped events using cxi_eq_ack_drops(). After
+ * this call, subsequent EQ status write-backs will not indicate that events
+ * were dropped until new events are dropped.
+ */
+static inline s32 cxi_eq_get_drops(struct cxi_eq *eq)
+{
+	return eq->status->unackd_dropped_event;
+}
+
+/**
+ * cxi_eq_ack_drops() - Acknowledge dropped events in the event queue
+ */
+static inline void cxi_eq_ack_drops(struct cxi_eq *eq)
+{
+	eq->status->unackd_dropped_event = 0;
+	eq->sw_state.event_drop_seq_no = eq->status->event_drop_seq_no;
+	cxi_eq_ack_events(eq);
+}
+
+/**
+ * cxi_eq_int_enable() - Unmask EQ event interrupts
+ */
+static inline void cxi_eq_int_enable(struct cxi_eq *eq)
+{
+	eq->sw_state.event_int_disable = 0;
+	cxi_eq_ack_events(eq);
+}
+
+/**
+ * cxi_eq_int_disable() - Mask EQ event interrupts
+ */
+static inline void cxi_eq_int_disable(struct cxi_eq *eq)
+{
+	eq->sw_state.event_int_disable = 1;
+	cxi_eq_ack_events(eq);
+}
+
+/**
+ * cxi_eq_sts_int_enable() - Unmask EQ status update interrupts
+ */
+static inline void cxi_eq_sts_int_enable(struct cxi_eq *eq)
+{
+	eq->sw_state.eq_sts_int_disable = 0;
+	cxi_eq_ack_events(eq);
+}
+
+/**
+ * cxi_eq_sts_int_disable() - Mask EQ status update interrupts
+ */
+static inline void cxi_eq_sts_int_disable(struct cxi_eq *eq)
+{
+	eq->sw_state.eq_sts_int_disable = 1;
+	cxi_eq_ack_events(eq);
+}
+
+/**
+ * cxi_eq_init() - Initialize an event queue
+ * @eq: The event queue to initialize
+ * @events: The events buffer
+ * @size: Size in bytes of the events buffer
+ * @eqn: The EQ number to use in commands
+ * @sw_state_addr: Software state CSR address
+ */
+static inline void cxi_eq_init(struct cxi_eq *eq, u8 *events, u32 size, u32 eqn, u64 *sw_state_addr)
+{
+	eq->events = events;
+	eq->rd_offset = C_EE_CFG_ECB_SIZE;
+	eq->prev_rd_offset = C_EE_CFG_ECB_SIZE;
+	eq->byte_size = size;
+	eq->sw_state_addr = sw_state_addr;
+	eq->eqn = eqn;
+}
+
+#define CXI_MASK(n) ((1 << (n)) - 1)
+
+#define CXI_MCAST_FA_FORMAT 0x1ff
+#define CXI_MCAST_FA_ACTION 0x7
+#define CXI_DFA_EP_WIDTH 12
+#define CXI_DFA_EXT_WIDTH 5
+#define CXI_EP_WIDTH (CXI_DFA_EP_WIDTH + CXI_DFA_EXT_WIDTH)
+#define CXI_DFA_EP_MASK CXI_MASK(CXI_DFA_EP_WIDTH)
+#define CXI_DFA_EXT_MASK CXI_MASK(CXI_DFA_EXT_WIDTH)
+
+/**
+ * cxi_build_dfa_ep() - Build 12 bit DFA EP Index.
+ * @pid: The DFA PID value.
+ * @pid_width: The DFA PID width.
+ * @idx: The DFA PTE index.
+ */
+static inline u32 cxi_build_dfa_ep(u32 pid, u32 pid_width, u32 idx)
+{
+	return ((idx >> CXI_DFA_EXT_WIDTH) << pid_width) + pid;
+}
+
+/**
+ * cxi_build_dfa_ext() - Return 5 bit DFA extension.
+ * @idx: The DFA PTE index.
+ */
+static inline u32 cxi_build_dfa_ext(u32 idx)
+{
+	return idx & CXI_DFA_EXT_MASK;
+}
+
+/**
+ * cxi_dfa_ep() - Return 12 bit DFA EP.
+ * @dfa: The DFA to parse.
+ */
+static inline u32 cxi_dfa_ep(u32 dfa)
+{
+	return dfa & CXI_DFA_EP_MASK;
+}
+
+/**
+ * cxi_dfa_pid() - Return variable width DFA PID.
+ * @dfa: The DFA to parse.
+ */
+static inline u32 cxi_dfa_pid(u32 dfa, u32 pid_width)
+{
+	return dfa & CXI_MASK(pid_width);
+}
+
+/**
+ * cxi_dfa_nid() - Return 20 bit DFA NID.
+ * @dfa: The DFA to parse.
+ */
+static inline u32 cxi_dfa_nid(u32 dfa)
+{
+	return dfa >> CXI_DFA_EP_WIDTH;
+}
+
+/**
+ * cxi_dfa_to_init() - Convert 32 bit DFA to initiator ID.
+ * @dfa: The DFA to convert.
+ * @pid_width: The DFA PID width.
+ */
+static inline u32 cxi_dfa_to_init(u32 dfa, u32 pid_width)
+{
+	return CXI_MATCH_ID(pid_width, cxi_dfa_pid(dfa, pid_width), cxi_dfa_nid(dfa));
+}
+
+/**
+ * cxi_build_dfa() - Build a destination fabric address
+ * @nic_addr: Destination NIC address
+ * @pid: VNI partition
+ * @pid_granule: VNI partition granule
+ * @idx: Index into the VNI partition
+ * @dfa: Destination fabric address to be set
+ * @dfa_ext: DFA extension to be set
+ */
+static inline void cxi_build_dfa(u32 nic_addr, u32 pid, u32 pid_width, u32 idx,
+				 union c_fab_addr *dfa, u8 *dfa_ext)
+{
+	dfa->unicast.nid = nic_addr;
+	dfa->unicast.endpoint_defined = cxi_build_dfa_ep(pid, pid_width, idx);
+	*dfa_ext = cxi_build_dfa_ext(idx);
+}
+
+/**
+ * cxi_build_mcast_dfa() - Build a destination multicast fabric address
+ *
+ * @mcast_id: Destination multicast address
+ * @red_id: Reduction ID value
+ * @idx_ext: Multicast index extension
+ * @dfa: Destination fabric address to be set
+ * @dfa_ext: DFA extension to be set
+ */
+static inline void cxi_build_mcast_dfa(u32 mcast_id, u32 red_id, u32 idx_ext, union c_fab_addr *dfa,
+				       u8 *dfa_ext)
+{
+	memset(dfa, 0, sizeof(*dfa));
+	dfa->multicast.format = CXI_MCAST_FA_FORMAT;
+	dfa->multicast.reduction_id = red_id;
+	dfa->multicast.multicast_id = mcast_id;
+	dfa->multicast.action = CXI_MCAST_FA_ACTION;
+
+	*dfa_ext = cxi_build_dfa_ext(idx_ext);
+}
+
+/**
+ * cxi_ct_init() - Initialize a counter
+ * @ct: Counter to initialize
+ * @wb: Writeback buffer
+ * @doorbell_addr: Doorbell address
+ */
+static inline void cxi_ct_init(struct cxi_ct *ct, struct c_ct_writeback *wb, u32 ctn,
+			       u64 *doorbell_addr)
+{
+	ct->wb = wb;
+	ct->ctn = ctn;
+	ct->doorbell = doorbell_addr;
+}
+
+/**
+ * cxi_ct_inc_success() - Increment counter success value
+ * @ct: Counter
+ * @value: Value
+ *
+ * Note: Value is constrained to 48 bits.
+ */
+static inline void cxi_ct_inc_success(struct cxi_ct *ct, u64 value)
+{
+	ct->doorbell[CT_INC_SUCCESS_OFFSET / sizeof(u64)] = value & CT_SUCCESS_MASK;
+}
+
+/**
+ * cxi_ct_inc_failure() - Increment counter failure value
+ * @ct: Counter
+ * @value: Value
+ *
+ * Note: Value is constrained to 7 bits.
+ */
+static inline void cxi_ct_inc_failure(struct cxi_ct *ct, u8 value)
+{
+	ct->doorbell[CT_INC_FAILURE_OFFSET / sizeof(u64)] = value & CT_FAILURE_MASK;
+}
+
+/**
+ * cxi_ct_reset_success() - Reset success counter to zero.
+ * @ct: Counting event to be reset.
+ */
+static inline void cxi_ct_reset_success(struct cxi_ct *ct)
+{
+	ct->doorbell[CT_RESET_SUCCESS_OFFSET / sizeof(u64)] = 0;
+}
+
+/**
+ * cxi_ct_reset_failure() - Reset failure counter to zero.
+ * @ct: Counting event to be reset.
+ */
+static inline void cxi_ct_reset_failure(struct cxi_ct *ct)
+{
+	ct->doorbell[CT_RESET_FAILURE_OFFSET / sizeof(u64)] = 0;
+}
+
+#endif /* __CXI_PROV_HW */
diff --git a/providers/cxi/cxi_verbs.h b/providers/cxi/cxi_verbs.h
new file mode 100644
index 000000000000..e180ab88bab7
--- /dev/null
+++ b/providers/cxi/cxi_verbs.h
@@ -0,0 +1,56 @@
+/* SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause */
+#ifndef __CXI_VERBS_H__
+#define __CXI_VERBS_H__
+#include <infiniband/driver.h>
+#include <infiniband/verbs.h>
+
+/* Function prototypes from verbs.c */
+int cxi_query_device(struct ibv_context *context, const struct ibv_query_device_ex_input *input,
+		     struct ibv_device_attr_ex *attr, size_t attr_size);
+int cxi_query_port(struct ibv_context *context, uint8_t port, struct ibv_port_attr *attr);
+struct ibv_pd *cxi_alloc_pd(struct ibv_context *context);
+int cxi_dealloc_pd(struct ibv_pd *pd);
+struct ibv_job *cxi_alloc_job(struct ibv_context *context, struct ibv_job_attr *attr,
+			      void *user_context);
+int cxi_dealloc_job(struct ibv_job *job);
+int cxi_query_job(struct ibv_job *job, struct ibv_job_attr *attr);
+int cxi_insert_addr(struct ibv_job *job, struct ibv_ah_attr_ex *ah_attr, unsigned int addr_idx);
+int cxi_remove_addr(struct ibv_job *job, unsigned int addr_idx);
+int cxi_query_addr(struct ibv_job *job, unsigned int addr_idx, struct ibv_ah_attr_ex *ah_attr);
+int cxi_export_job(struct ibv_job *job, int *fd);
+int cxi_import_job(struct ibv_context *context, int fd, struct ibv_job **job_out);
+struct ibv_job_key *cxi_create_jkey(struct ibv_pd *pd, struct ibv_job *job);
+int cxi_destroy_jkey(struct ibv_job_key *job_key);
+struct ibv_mr *cxi_reg_mr(struct ibv_pd *pd, void *addr, size_t size, uint64_t hca_va,
+			  int access);
+struct ibv_mr *cxi_reg_mr_ex(struct ibv_pd *pd, struct ibv_mr_init_attr *attr);
+int cxi_dereg_mr(struct verbs_mr *vmr);
+struct ibv_cq *cxi_create_cq(struct ibv_context *context, int cqe, struct ibv_comp_channel *channel,
+			     int comp_vector);
+struct ibv_cq_ex *cxi_create_cq_ex(struct ibv_context *context, struct ibv_cq_init_attr_ex *attr);
+int cxi_destroy_cq(struct ibv_cq *cq);
+struct ibv_counters *cxi_create_counters(struct ibv_context *context,
+					 struct ibv_counters_init_attr *init_attr);
+int cxi_destroy_counters(struct ibv_counters *counters);
+int cxi_read_counters_ex(struct ibv_counters *counters, const uint64_t *items,
+			 uint64_t *counters_value, uint64_t *timestamps, uint32_t ncounters,
+			 uint32_t flags);
+int cxi_poll_cq(struct ibv_cq *cq, int ne, struct ibv_wc *wc);
+int cxi_arm_cq(struct ibv_cq *cq, int solicited);
+struct ibv_qp *cxi_create_qp(struct ibv_pd *pd, struct ibv_qp_init_attr *attr);
+struct ibv_qp *cxi_create_qp_ex(struct ibv_context *context, struct ibv_qp_init_attr_ex *attr);
+int cxi_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr, int attr_mask);
+int cxi_query_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr, int attr_mask,
+		 struct ibv_qp_init_attr *init_attr);
+int cxi_destroy_qp(struct ibv_qp *qp);
+int cxi_post_send(struct ibv_qp *qp, struct ibv_send_wr *wr, struct ibv_send_wr **bad_wr);
+int cxi_post_recv(struct ibv_qp *qp, struct ibv_recv_wr *wr, struct ibv_recv_wr **bad_wr);
+int cxi_post_recv64(struct ibv_qp *qp, struct ibv_recv_wr64 *wr, struct ibv_recv_wr64 **bad_wr);
+int cxi_attach_mr(struct ibv_qp *qp, struct ibv_mr *ibmr);
+int cxi_detach_mr(struct ibv_qp *qp, struct ibv_mr *ibmr);
+struct ibv_ah *cxi_create_ah(struct ibv_pd *pd, struct ibv_ah_attr *attr);
+struct ibv_ah *cxi_create_ah_ex(struct ibv_pd *pd, struct ibv_ah_attr_ex *attr);
+int cxi_destroy_ah(struct ibv_ah *ah);
+bool is_cxi_dev(struct ibv_device *device);
+void cxi_free_context(struct ibv_context *ibvctx);
+#endif
diff --git a/providers/cxi/cxiverbs-abi.h b/providers/cxi/cxiverbs-abi.h
new file mode 100644
index 000000000000..a85db49261dc
--- /dev/null
+++ b/providers/cxi/cxiverbs-abi.h
@@ -0,0 +1,29 @@
+/* SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause */
+/*
+ * Copyright 2025 HPE. All rights reserved.
+ */
+
+#ifndef __CXI_ABI_H__
+#define __CXI_ABI_H__
+
+#include <infiniband/kern-abi.h>
+#include <kernel-abi/cxiverbs-abi.h>
+#include <rdma/cxiverbs-abi.h>
+
+DECLARE_DRV_CMD(cxi_alloc_ucontext, IB_USER_VERBS_CMD_GET_CONTEXT, cxi_ibv_alloc_ucontext_cmd,
+		cxi_ibv_alloc_ucontext_resp);
+DECLARE_DRV_CMD(cxi_alloc_pd, IB_USER_VERBS_CMD_ALLOC_PD, cxi_ibv_alloc_pd_cmd,
+		cxi_ibv_alloc_pd_resp);
+DECLARE_DRV_CMD(cxi_create_cq, IB_USER_VERBS_CMD_CREATE_CQ, cxi_ibv_create_cq_cmd,
+		cxi_ibv_create_cq_resp);
+DECLARE_DRV_CMD(cxi_create_cq_ex, IB_USER_VERBS_EX_CMD_CREATE_CQ, cxi_ibv_create_cq_cmd,
+		cxi_ibv_create_cq_resp);
+DECLARE_DRV_CMD(cxi_create_qp, IB_USER_VERBS_CMD_CREATE_QP, cxi_ibv_create_qp_cmd,
+		cxi_ibv_create_qp_resp);
+DECLARE_DRV_CMD(cxi_create_qp_ex, IB_USER_VERBS_EX_CMD_CREATE_QP, cxi_ibv_create_qp_cmd,
+		cxi_ibv_create_qp_resp);
+DECLARE_DRV_CMD(cxi_modify_qp_ex, IB_USER_VERBS_EX_CMD_MODIFY_QP, empty, cxi_ibv_modify_qp_resp);
+DECLARE_DRV_CMD(cxi_reg_mr, IB_USER_VERBS_CMD_REG_MR, cxi_ibv_reg_mr, cxi_ibv_reg_mr_resp);
+DECLARE_DRV_CMD(cxi_query_device_ex, IB_USER_VERBS_EX_CMD_QUERY_DEVICE, empty,
+		cxi_ibv_query_device_resp);
+#endif /* __CXI_ABI_H__ */

-- 
2.56.0

