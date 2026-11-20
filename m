Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.34
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795209252;
	b=xZ4dZG9ou9juxA2SjXMIevxRPSE3XPgm9HXxhD69OPB2/xaJTAAM/aBEfEFwg5G6Rh21
	 WwPcRxffHBg2PKjHYv6Ft0lxl10piwaoXdTWKvF4lHiF8Vmi+IJdQfaGBJLCcDrFEY8/N
	 2biRLL37sFyDJjd8bcU127TETJKCdhVQ7ikCER/mzHZ/gcBmQhCeoFjyG/QlNjHJyiMAZ
	 P2UUgt1VGYbgVt86rj20cpIIsovcQtv4mNnLkfovIVtVfw03IR4dxlllMVsJVmWHaE7xE
	 HZeRV4n3leW/Zde0rvwgkBQJpfEVim9zFhDF4euqu/xBQV2n1I5F1ceslJJXYYNcgHg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795209252;
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
	bh=ovnCD//jt5yqaSbUwNWhASasYIAECmJE1xwFf4NokwY=;
	b=CrpUdAEFlfofzO0+HLvRk5gl/Izue5/Mxdb5F1UvaURqUnePKH1lom+yWyi5MH0vf4i8
	 VQsqkzn5rQz24RfZV/nKXNCfDN43l6dweKXyUkbVh2DcbDIk+7dYM1iQGcZTNmXk7neYL
	 yVKtkuDx/K7+7rR8/Gez01kNQZk8M086QH54IEdho7zAtnqdhT1AUZkFCdrr3whtBSDSx
	 vlZV0Qm0iKU2hgnQab1g5FjVr1qUdLJjTc/LCtNweyH90hBHz5fCPmqfiIn9fyNlMYZyY
	 eXZhDsxBaysh/YboDoI6Vtb08z1mxIQPpbeSNZCqg2ihI5pwihnjBkFDjshh2HpbJ/Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="HNQ6feO/";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.34
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010034.outbound.protection.outlook.com [52.101.201.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19ED0606A338;
	Fri, 20 Nov 2026 21:14:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 19ED0606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=HNQ6feO/
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k5lOhVRBxswfXnaZidCP/8q7zYtLPFJOfj6lbenYfNNuDHcE4sBrbDjchQruTAbDxuJ/t5D43eHl0v5Oa7HfDGC7SpvWpCBbnlO09Crs7ukONm0s2TlDPgvqmBs4LgNEZmGEdwVo1WvC0KZDMUbVpDuIKuCxdKjT508GijkIRNbPyjHzvAudvKjlptmBssJHRzCWxEgtRKbZNGmoCdEfocr11UpnTkZhALyPQkNMEx12OJK3SacpYAUbl+aCtK5mEJ7bZ328tewQpkIY2oa4DvKUV5YpgZ0xwHK7jq0Kp8nRC5VYD/jgZNMMj7xvf67YMRkLxolOwe/6jdtqdjt7MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ovnCD//jt5yqaSbUwNWhASasYIAECmJE1xwFf4NokwY=;
 b=A2HC0tXkf8mvkFgr+O7RYP7/slXnciq4s1iuT5yQBv1xT1Ybp2XWQg4D+DuQKRN6BGM3vCc5Yd9CWVbMuQitYuTUWW2Aw7rqhn2L118LjoxMqlKr98LmngAiX8jmmO8MUQZPIQVYyGeIu7/IBdNtgjGtqzKURRlUvEppGSMfDtb3Nxfvixjr+GNYxY4AF5OpgeQ59BLeuAeYVG5Bd51gjOODWUCy+QmSluaL1xZ9qmXqfu3GiEgg+0chpHMt7bzr/RT/cdCfGXO3zDPeym2v/DYVo7ZYMOG5JGHJujXTJiWPz0MX+dZJh3J/6uWwLFOcnIvTyJpB1eUrNFJBAtsPHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ovnCD//jt5yqaSbUwNWhASasYIAECmJE1xwFf4NokwY=;
 b=HNQ6feO/9eOpfBi1SK9NSFT88nP+N5bzWt9/EH+pKZSh4rfpVORX0qb0VLpuVdBt0fRaqfxAhF7dmkh+BjcgV4FPFBDFzlVTST3Eql0xlKVgRm3cUeeYrlGy5DONrfL0jTXioK8rkqqy+nBs/TlewZZMIz9XkNDLxm/VyWWHmJozplKFXtz26q+c4ReQF5cv+mcH/1ZCrNzL4MbyNNw/aOA3R6ahFN3mvGJk0cu5OFqfDHfOjRCMAwA/R0jqoDiMdU/rwBu2Am4LksXF8V5JIPDi/3caI7GSrSM0zQZl9FMuI7HGfo3N1EmTmuRHMxBafWnHfNw/aW5P5Xa4d0o2cw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA0PR12MB4367.namprd12.prod.outlook.com (2603:10b6:806:94::13)
 by SA5PPF7D510B798.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8d0) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Fri, 20 Nov
 2026 21:14:03 +0000
Received: from SA0PR12MB4367.namprd12.prod.outlook.com
 ([fe80::2815:8a95:1a44:be1c]) by SA0PR12MB4367.namprd12.prod.outlook.com
 ([fe80::2815:8a95:1a44:be1c%6]) with mapi id 15.21.0639.011; Fri, 20 Nov 2026
 21:14:03 +0000
Message-ID: <5c493bd0-31f5-430a-844a-ad011a5f0ba8@nvidia.com>
Date: Fri, 20 Nov 2026 23:14:00 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v2] net: mlx5: Allow police as the last action of
 a TC rule
To: Mohsin Bashir <mohsin.bashr@gmail.com>, netdev@vger.kernel.org
Cc: saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com,
 cjubran@nvidia.com, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261119040010.1405900-1-mohsin.bashr@gmail.com>
Content-Language: en-US
From: Mark Bloch <mbloch@nvidia.com>
In-Reply-To: <20261119040010.1405900-1-mohsin.bashr@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TL0P290CA0008.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:5::19) To SA0PR12MB4367.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA0PR12MB4367:EE_|SA5PPF7D510B798:EE_
X-MS-Office365-Filtering-Correlation-Id: 51a2e947-3410-4634-9fd3-08df474b3443
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|7416014|376014|261102123227099003|261026140227099003|11063799006|261028144727099003|261026121527099003|261022075727099003|261021121427099003|261022105027099003|261021123027099003|56012099006|10067099003|18002099003|261009223027099003|6133799003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	EjIxCuD+NfAxX34Pzps9YaLEw2cbZAt2VTaN6mKfxdSB0aUI2a5XsgNvgQjovBYsNHZxpUlXScPYmNzN/wUl/fjOACSA0VFoeacdqz6lzQABUDTV55/oDRjGsqnVSVHg02Bk+zifaoYoToujC+EAtW/ijaWKoy3GaOMHCVPt4q/0t/+GPaNLWr+wBSiMX5UEblHMKWws6XRjpk8ZwR6oEebEFFSf16PVWKofM1dMXWw94qH0Z1Tuu1P8Ih3Lhwh9HKnlThI6qSrz1RetglPMetcKn4FGC4XgJ07S6/UxZME6fdUOaTC7KNWA9s6Sb+8X0NoAXpdSwy8gaRN79J1kghK3uTU3bJvGk5yALURVojT5tYM+4joRb4CHvSpxt67DNxTBFNnIjnkx8WTXLOHhPghkcejtKVzTmRym5h4INiKJAHbACHatCmgsb7lyNvK8r2Q2cZ5864NY7JY/BuUxtPSTJDZ/fAaGdT4aljmGDSr/65mB8Z5TXqgo6NRNCvUR0CIKtAEblpjGmZcUrgsHVknOYKs5Tg/b/VscMLHecJm67v8gqqBU7c3wMMlVDhS9nIyKH4ZPmwjEQLjFLOn7rMXm2BKU36piPAP13luV6ilIzKmgi0OQCCaFS8a9P6eNPjgjiQXI6nABrRxx7Z9yiA6LlNbLIbJwr+7ts26q1Ng=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4367.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(7416014)(376014)(261102123227099003)(261026140227099003)(11063799006)(261028144727099003)(261026121527099003)(261022075727099003)(261021121427099003)(261022105027099003)(261021123027099003)(56012099006)(10067099003)(18002099003)(261009223027099003)(6133799003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZkFiZEZ1Zm11b3FQM1lIQWRzVndTMXJoejBSRmIrcnF0NWxmT0FwemFLbVla?=
 =?utf-8?B?TllpNUpka3VKMjYzVytOOUxtYVVPM282Nlo4YURNeWhsQVdOejRnbm1SSjl5?=
 =?utf-8?B?OW9mZm1jcmZzQkJiRTdwaEFwTlR2N3B4SndBckdFQUtLWlhrRTJ3UzRKbGs4?=
 =?utf-8?B?eDZZa3lneXlMRDFYUnRvd0xscmo0L1NyMmlnd24ycXVmaXRDQ1FDVnNnSjNX?=
 =?utf-8?B?TG5LL2VYMnJYWU5UeUhOQ1RtNUlEVGFvTkMyNkgvaVk0anhzYUJDK0tkbWtp?=
 =?utf-8?B?T2lCZnBKQlE1MW9yT0dQWnNKSkpMbkxPVGdCTFpzVEI0R21VK0kzckM4anBD?=
 =?utf-8?B?RVZmY1NEbTFBVVdGWTNtb2dpSi9NcFliNEpjVTlPZjhkZEZvWFdqb0ZMdFNj?=
 =?utf-8?B?bTVnMzZybmxNWjZ0UjdZdzdlbUVFK2h1ckZpakdhcWVuclZjR1NoOXN4U3lS?=
 =?utf-8?B?cTQ0TFFSMXZDTXNDT0VENXhqa0FJeGVHK0FDeFViOTNMYVl1V0RGL1dXMWc5?=
 =?utf-8?B?ZmJQMlh3QXdIMExsZ3lzS0dMLzh2cWdIS2tTMnRKaWtsUDBrMmdNbjNYVDVC?=
 =?utf-8?B?d1MzOFVaRVU1NzVtNVJHa1R6UTBJaVRYVENISmJhMjBuY3pCTUltTmRxNDFz?=
 =?utf-8?B?RzhISExOWVRhcmROb25LOThyUVA3SDBvOTZiZGRWam0rRWwzN0paRHhMa0ZJ?=
 =?utf-8?B?SU9uMk03OXhVNzFnenNUSlNSSEF3eVg4MVNCQ01KZDIwYStKYjM0MmZLMXVn?=
 =?utf-8?B?cU1OR05Za0VHNTRzRDMxcXN4VldSbzBocmowSkpQU2U4MlhoMDlBdFRMTFBs?=
 =?utf-8?B?dktXclRKQ2J2UjFVZ2M2Q0dEdmNTWUs4RnJ6K2R3MHJ0S1htcUtEY3VuSTRP?=
 =?utf-8?B?THZQK3duQWRybXAxWjlmMXZjUzdJTUNITXBhb04vZlJtSDVMZkVVTGVlSUl2?=
 =?utf-8?B?OWxGMTY1a2E4cHgrVk9lcHlpQ1laejRsYUIzcUtWNHVqbW9HK0g5bE54SW5O?=
 =?utf-8?B?dXJDR3FIODUrUGhqUmV3czNlZk4yRzNYK3U5YVJ1RFRHQXd2Mkg3RVVPakZk?=
 =?utf-8?B?bzFYQkV4L01zVjhTQnhHdkc2SmljYnRBRndYR0UzS2VSZGtEZ1FVdXVDYXFR?=
 =?utf-8?B?YXEwUEMrWlRKbm9PaXZtdHNKVFFINzVBWDlDMUVCdmZqaC9ZUlR0MjQ0SWRH?=
 =?utf-8?B?VDVvTkhSTnMrZGlkT1NHS1pnYzZ0NE9mbTRDOUQ5L0FhVVhOekt6dHp5YkxG?=
 =?utf-8?B?UitiL3NKSHc3VEVTY2FVV1F0MHRnaloxMHNzL1p4TUtreDVBK1pPaVZoVVVB?=
 =?utf-8?B?LzZ2VWtENTRqS2ZYTXFVNFNwaXJ4aVhCM1Flb2VwRlRXa0hSMVU2RitxcWNu?=
 =?utf-8?B?VWdaTWJoRHNFU0tLYjlPamp1dXBPc3BacE92eTNmcE1vNGxPOW1sTGQ0UkFX?=
 =?utf-8?B?enlxZkFIK0xRNU4yQWhYdE5lNHVlQzlvRUR4Z2lRdmdaYk0vZmkwZ2pZcDNy?=
 =?utf-8?B?U1dmcXBETnZRUml2TE5oR1U5eWU3Vlc4V0Rtd253MGFSUkxVN3Y2OU8rK296?=
 =?utf-8?B?aVhJdytPSWdwOWtuclpqUTRKTzl3aGIydUZHT1JDTWxQZG1rWlVFem5DRXoz?=
 =?utf-8?B?MEZVb2kvU2pLL1E1V2d2YlNCdWxsczdmbFRBcmNFSkltRUJQSXVKYXN2OHJP?=
 =?utf-8?B?cngwOXR1S3RIcDlQYnVPZjJNSjNFVkVwWGZLc2Y1ZDl5aDI5OFh5YzJpYnZ2?=
 =?utf-8?B?Nk9GK0l1a3ZoTW1XTmxXUFo1eHBJeTB2c0ZzYzZsT2xwREVJc0h6NGpNRnFC?=
 =?utf-8?B?UTUxdlJwZVVNcDNWNHhjQURPQ1pJNXJPNWpnaEZSNmlKeGlJc1d3SEh6WVNs?=
 =?utf-8?B?ajlmM1lQYjlCOFhpRTJQQXdGNDkrK2dyTlNGcTZlcW90SHh1SVUyQVIwT1FF?=
 =?utf-8?B?THBpTHR4QmZnYWhUSDRyRmR4RlNBRGdWR0R3UUFIVXlyUElnMjZicFJNY0Fu?=
 =?utf-8?B?KzNKNWhsdE9LRDBLZ0M3bFBXczhYSVU4S09yZjR4RDRkRDdPOEtBMDEweXQv?=
 =?utf-8?B?bmxzZlFvVXpmYmU1cXhLc2ZjTWw2eWcrdWxMdjBCVUp0YzFjWVJ1eFlWbUI3?=
 =?utf-8?B?MWROenZIdHpyRjBjZk9qQk8vVlI0cGMxbU9rWWxBc0F4eDRIeFdjUHl4Z0Ix?=
 =?utf-8?B?azBWTXNRYXlFbWtkL3dSanlqSW5reU0zUzVPbkJDV1N5SVpkZ0xxZkNzbk8r?=
 =?utf-8?B?TGREOTFkK0dLNVhGZWRxYXhTYXZuT09NYXJXV0hTOVg5ckdJaHJoSzhod01G?=
 =?utf-8?B?SDFyZXNNdzdWUnFWQzVzZmdxUUNkUFJ5bjgzcTZ3dVBsQnJUUDFHUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51a2e947-3410-4634-9fd3-08df474b3443
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4367.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 21:14:03.6333
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VQNut7tcRh1yCtJiGOqKm4DX3uS3hzmvvvnMKlvnNwD8nHQ8hy6VdlU/pwUYUHH2JQ3ML0fQD0HkUQOZAEzr0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPF7D510B798



On 19/11/2026 6:00, Mohsin Bashir wrote:
> From: Mohsin Bashir <hmohsin@meta.com>
> 
> In switchdev mode, mlx5 offloads police only when other actions follow
> it. TC needs no extra action for a police-only rule to work. The mlx5
> driver makes every police rule forward to the post meter table, but for
> a rate police it adds that forward only after verify_attr_actions() has
> checked the rule, so the check rejects it. The ok result of police is
> also handled as pipe. In TC, ok accepts the packet and ends the action
> list, whereas mlx5 goes on with the actions after police.
> 
> Support police as the only action of a rule. Set the forward while
> parsing police, as is already done for police with mtu, and forward
> an ok result to the end of the TC chains, as the driver does when it
> offloads the gact ok action. This also changes existing offloaded rules
> where police is followed by other actions. Before, an ok result ran the
> actions after police. Now it accepts the packet, as TC does. The
> upcoming selftest series also relies on such rules for TC offload
> validation.
> 
> When police is the last action, a pipe result also ends the action
> list, so forward it to the end of the TC chains too. Otherwise it is
> sent back to the post action table, and with two police actions the
> packet loops through the second police. A jump counts from the start
> of the action list, so its target may be an earlier action or police
> itself. Reject jump when police is the last action.
> 
> The patch was tested on a ConnectX-7 in switchdev mode with the
> commands below. It was verified, using the hardware drop counter, that
> the rules are offloaded and limit the matching traffic to the
> configured rate, that the second police of the two police rule only
> sees the packets conforming to the first, and that jump on the last
> police is rejected.
> 
>   tc filter add dev eth0 ingress pref 100 protocol ipv6 flower skip_sw \
>     ip_proto udp dst_port 5201 \
>     action police rate 100mbit burst 1m conform-exceed drop/ok
> 
>   tc filter add dev eth0 ingress pref 100 protocol ipv6 flower skip_sw \
>     ip_proto udp dst_port 5201 \
>     action police rate 200mbit burst 1m conform-exceed drop/pipe \
>     action police rate 100mbit burst 1m conform-exceed drop/pipe
> 
>   tc filter add dev eth0 ingress pref 100 protocol ipv6 flower skip_sw \
>     ip_proto udp dst_port 5201 \
>     action police rate 100mbit burst 1m conform-exceed drop / jump 1
> 
> Cc: Carolina Jubran <cjubran@nvidia.com>
> Signed-off-by: Mohsin Bashir <hmohsin@meta.com>
> ---
> Changelog:
> v2:
>   - Treat pipe on the last police as ok and forward it to the end of the
>     TC chains.
>   - Reject jump when police is the last action, since the jump target is
>     counted from the start of the action list.
>   - Update commit message
> 
> v1: https://lore.kernel.org/netdev/20261117031337.4126403-1-mohsin.bashr@gmail.com

I think we can keep this patch small and tighten the JUMP checks:

for each police branch using JUMP:
    reject unless police is the first action
    reject unless the target is a later, existing action
    reject if skipped actions include anything other than DROP/OK
    reject if the countdown would count two separate actions as one
           (e.g. repeated uses of a shared action)

That keeps the simple forward jumps working and leaves the new OK/PIPE
support intact. It rejects some valid configurations, but that seems
better than offloading them with different behavior.

Broader JUMP support would need more work on the action parser to make
sure hardware behaves the same as software. I'd handle that separately.

Unless there's a concrete use case, I'd keep backward jumps unsupported.
We don't want to offload steering loops, intentionally or by mistake.

I'm not sure which JUMP cases you need. Would this be enough for your
use case?

Mark

> ---
>  .../mellanox/mlx5/core/en/tc/act/police.c     | 11 +++++++-
>  .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 26 ++++++++++++-------
>  2 files changed, 27 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
> index 1bd1c94fb977..faa0822b1136 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
> @@ -49,6 +49,14 @@ tc_act_can_offload_police(struct mlx5e_tc_act_parse_state *parse_state,
>  	if (err)
>  		return false;
>  
> +	if (flow_action_is_last_entry(parse_state->flow_action, act) &&
> +	    (act->police.exceed.act_id == FLOW_ACTION_JUMP ||
> +	     act->police.notexceed.act_id == FLOW_ACTION_JUMP)) {
> +		NL_SET_ERR_MSG_MOD(parse_state->extack,
> +				   "Jump on last police action is not supported");
> +		return false;
> +	}
> +
>  	return !!mlx5e_get_flow_meters(parse_state->flow->priv->mdev);
>  }
>  
> @@ -94,13 +102,14 @@ tc_act_parse_police(struct mlx5e_tc_act_parse_state *parse_state,
>  		      MLX5_FLOW_STEERING_CAP_MATCH_RANGES))
>  			return -EOPNOTSUPP;
>  
> -		attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
>  		attr->flags |= MLX5_ATTR_FLAG_MTU;
>  	} else {
>  		attr->action |= MLX5_FLOW_CONTEXT_ACTION_EXECUTE_ASO;
>  		attr->exe_aso_type = MLX5_EXE_ASO_FLOW_METER;
>  	}
>  
> +	attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
> +
>  	return 0;
>  }
>  
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> index 1d35c97aea0b..7e7111e6d058 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> @@ -3874,7 +3874,7 @@ static int
>  alloc_branch_attr(struct mlx5e_tc_flow *flow,
>  		  struct mlx5e_tc_act_branch_ctrl *cond,
>  		  struct mlx5_flow_attr **cond_attr,
> -		  u32 *jump_count,
> +		  u32 *jump_count, bool last,
>  		  struct netlink_ext_ack *extack)
>  {
>  	struct mlx5_flow_attr *attr;
> @@ -3891,11 +3891,17 @@ alloc_branch_attr(struct mlx5e_tc_flow *flow,
>  	case FLOW_ACTION_DROP:
>  		attr->action |= MLX5_FLOW_CONTEXT_ACTION_DROP;
>  		break;
> -	case FLOW_ACTION_ACCEPT:
>  	case FLOW_ACTION_PIPE:
> -		err = set_branch_dest_ft(flow->priv, attr);
> -		if (err)
> -			goto out_err;
> +		if (!last) {
> +			err = set_branch_dest_ft(flow->priv, attr);
> +			if (err)
> +				goto out_err;
> +			break;
> +		}
> +		fallthrough;
> +	case FLOW_ACTION_ACCEPT:
> +		attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
> +		attr->flags |= MLX5_ATTR_FLAG_ACCEPT;
>  		break;
>  	case FLOW_ACTION_JUMP:
>  		if (*jump_count) {
> @@ -3967,7 +3973,7 @@ dec_jump_count(struct flow_action_entry *act, struct mlx5e_tc_act *tc_act,
>  static int
>  parse_branch_ctrl(struct flow_action_entry *act, struct mlx5e_tc_act *tc_act,
>  		  struct mlx5e_tc_flow *flow, struct mlx5_flow_attr *attr,
> -		  struct mlx5e_tc_jump_state *jump_state,
> +		  struct mlx5e_tc_jump_state *jump_state, bool last,
>  		  struct netlink_ext_ack *extack)
>  {
>  	struct mlx5e_tc_act_branch_ctrl cond_true, cond_false;
> @@ -3980,7 +3986,7 @@ parse_branch_ctrl(struct flow_action_entry *act, struct mlx5e_tc_act *tc_act,
>  	tc_act->get_branch_ctrl(act, &cond_true, &cond_false);
>  
>  	err = alloc_branch_attr(flow, &cond_true,
> -				&attr->branch_true, &jump_count, extack);
> +				&attr->branch_true, &jump_count, last, extack);
>  	if (err)
>  		goto out_err;
>  
> @@ -3988,7 +3994,7 @@ parse_branch_ctrl(struct flow_action_entry *act, struct mlx5e_tc_act *tc_act,
>  		jump_state->jumping_attr = attr->branch_true;
>  
>  	err = alloc_branch_attr(flow, &cond_false,
> -				&attr->branch_false, &jump_count, extack);
> +				&attr->branch_false, &jump_count, last, extack);
>  	if (err)
>  		goto err_branch_false;
>  
> @@ -4052,7 +4058,9 @@ parse_tc_actions(struct mlx5e_tc_act_parse_state *parse_state,
>  
>  		dec_jump_count(act, tc_act, attr, priv, &jump_state);
>  
> -		err = parse_branch_ctrl(act, tc_act, flow, attr, &jump_state, extack);
> +		err = parse_branch_ctrl(act, tc_act, flow, attr, &jump_state,
> +					flow_action_is_last_entry(flow_action, act),
> +					extack);
>  		if (err)
>  			goto out_free_post_acts;
>  

