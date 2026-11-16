Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.189.114
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794848931;
	b=mL3JDoocMQtgO1DZuG4S+GjIpE+7/XXmERF8yqYoKF417ONkpb9FF6SKvMxQLFpT47KC
	 cakD6nd1CQBr19YU7eWPSSGwBMyP7zERN9fZOcRZkEshy1yWCjQZyfX/tuELzVoLwlQqk
	 rAcXMLCMye65ZJUKj0QLOT9LCGX6goAgkeIvjli0JV8Yp23oZeQe8VijYMTyr+iJ8UeJE
	 Fy5MorsPdHsXIt6ycRCD58rSwDoy1gh4/aqpJTC8EOu2yyJ9aYli8aBg8lGTzWBJ7lod3
	 KDMTNGSV62S9AqDFJAWS+qaKykedpFMM//RQRAIL7WDV+iE5stjeL8pyPMwopVnBEsQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794848931;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:Content-Type:Content-Disposition:
	 In-Reply-To:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=hJJaaTcc44DPdgnvuV7Ns6F7fjGrOgKnJmDfgXLk4+k=;
	b=FReXwc9eFrCuoxf5tZdoDBWQ6MQc9BTma9Ki1fzGAOOM6jTYrPjlOkJf7KzEmsP01s1U
	 xX79gCBAg1ef0t5frjc5P2rH4603nNeTcaJvMf4SQUfM/euIPLBNbbQCGJfRzW06i5IcY
	 SsxNNxmMySjYcC+DfCMDZdp88Y9cN9yyX+WH6J2boxOOsJn2bNrKSe5eYdWSaqnOTlXV2
	 ct1zLtESwGyDceOBOU5RaOMQiP9//mKK4SELprnzCDw+puBKnLuKjUPsmp6zO5B+lZigp
	 LgYwFSxJ4d9Za6KHUE3tz9R/5A6X4zdf8VoNwIeEydRKaGNVFJ2gTZKJud60YyXhUQA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=raithlin.com;
	spf=pass smtp.mailfrom=raithlin.com;
	dkim=pass header.d=raithlin.onmicrosoft.com header.i=@raithlin.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-raithlin-onmicrosoft-com header.b=ZqpHvpKR;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.189.114
Received: from YT3PR01CU008.outbound.protection.outlook.com (mail-canadacentralazon11020114.outbound.protection.outlook.com [52.101.189.114])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141B6606A32C
	for <linux-rdma@vger.kernel.org>; Mon, 16 Nov 2026 17:08:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 141B6606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=raithlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raithlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=raithlin.onmicrosoft.com header.i=@raithlin.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-raithlin-onmicrosoft-com header.b=ZqpHvpKR
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n7yjDSGC0g1BI8UJ10tV3VCFXahE95qik8ReFE0zq6QDkSR0jBZsXpG2Ch40Cq7nFyQtysjok6zWVQP09nHeZcXw3G4nOAhtJXxbGFw242pT//ItU01sSoMgzk4aSJ5ReAJYe3FNmghN8zdyZ2aTi+ikXrruCUelwf03LhgNrOgkAVwKzJrbDU3uv44sRa5LEUcQKMRtdRfBxjk7vkjKzY8rRknZLoRnzZmKA5SRsF6bpxrCPgeWy0ybeeuZfiANaua6s0pdxkfjRMmVey1KoB3BAg8f3NyU0J/Oq+TBDdZrxhp/tsl9e+HlNZuuK06iLQAb6Ni/FrGbprO+zv9Gmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hJJaaTcc44DPdgnvuV7Ns6F7fjGrOgKnJmDfgXLk4+k=;
 b=FHgMBl4URmREfhCi4qU+ABY4hN03ZigqbUSc4pxUOF+7ctPis2y53OOb3L/m/7q0cU6XBiairDxqdym8FMVBdOjOCPN1sEv1V8tOOK4D6+yoxhNB319CtElctb0AKPL+u2JZedbGR7bo7f2Xa2VfstlYDs8Nqe9/DNvgpKBp9KYll8/knSm0wv0bXKA469vpPY++zem0ewsom37yg+PhDORuvi10+x9oMdpQP/j3uFFz4JAw1a7DJI0fu35I/hsG0boJdGHU3SE7IN0n++xFbx40JY0q7hG00nE4OFktyhkS6BebiqCfzJvt0sYXP+ywh6n0Qiv5wjBKnpOcYUgZsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=raithlin.com; dmarc=pass action=none header.from=raithlin.com;
 dkim=pass header.d=raithlin.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=raithlin.onmicrosoft.com; s=selector2-raithlin-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hJJaaTcc44DPdgnvuV7Ns6F7fjGrOgKnJmDfgXLk4+k=;
 b=ZqpHvpKRuE/AWH5+29TS8APyyPaxn1uvY0Ko1qZpCDJfZ1+ZT0rh8ArDdB/ma8Mwbv2Qn6LozHW2LZtOutD62cKnTRfzfjvQEb4QsoK6SDg1CUj65AeepN4QGF5mMH9ke7Q1FnmTJA+UuxNj7rt77pZSQvEOIJiElhmyMHhLsHY=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=raithlin.com;
Received: from YQXPR01MB6671.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:4c::19)
 by YQBPR0101MB6667.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:42::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Mon, 16 Nov
 2026 17:08:47 +0000
Received: from YQXPR01MB6671.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::cb84:4e7b:86e6:f58]) by YQXPR01MB6671.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::cb84:4e7b:86e6:f58%4]) with mapi id 15.21.0615.013; Mon, 16 Nov 2026
 17:08:46 +0000
Date: Mon, 16 Nov 2026 11:08:43 -0600
From: Stephen Bates <sbates@raithlin.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, sshaul@nvidia.com, stephen.bates@amd.com,
	abhijit.gangurde@amd.com, nikhil.agarwal@amd.com,
	Claude <noreply@anthropic.com>
Subject: Re: [PATCH v3] perftest: add a ROCm build to CI
Message-ID: <avs4m6DVtmaPaCNY@APCAN-MQ60818VV.localdomain>
References: <20261106224821.126399-1-sbates@raithlin.com>
 <20261115125133.GA42525@unreal>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261115125133.GA42525@unreal>
X-ClientProxiedBy: MW4PR02CA0019.namprd02.prod.outlook.com
 (2603:10b6:303:16d::23) To YQXPR01MB6671.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:4c::19)
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
X-MS-TrafficTypeDiagnostic: YQXPR01MB6671:EE_|YQBPR0101MB6667:EE_
X-MS-Office365-Filtering-Correlation-Id: 04765c8b-bd64-44d6-4583-08df4404468a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|18002099003|22082099003|6123799006|4143699003|56012099006|10067099003|261026140227099003|261028144727099003|261022105027099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	h1VciF2ifPlt1tW+aOnlpcU91rNABtlG0g7+7mXKgGqzWMXLYL1gBNGXo0XZs1mgT6aOnqqM31p7EoD0+7XSg3FPDv6eDc0mwZ6jJK3iBeRORF08fIDoD+3SG5cVaX5X4FS2IplrXgb5pgG97EDyJzU1fyw6MkpfJjZA1lyv+OauxzvvGlo6sDXBmZNqIaKExqZZnp9zdlYvlPdpvoUXbZ/C4hUVy3FpCGjVefAzlZ6OX6qEHVirqHm02QJwAW0SGDidGeN1NTzP8n9mM+87OUusudRD9JHH6qaDEEYeyL6L5GRYjhLR3qXRrkk7NLONalnZLT5D/ygGhBA87dxsSlaOY4qWY82HCdfmwv8rSnf4cQCUL6IQ5OYcQaUoX13GWvm2YV1ppfWqZBNmi1ugNJNgoBUOob/IiRKI4Dne6tz/dRg4Qu8VosdVSWN6Rqg8vBXLVghLAfVoSvZiK8ONvk41pMupqfXchv4hSKnF5CR0i2Cx4itBXen0laAAECgvuYPIesspR81NAXYUlrqTGSZtMbCcfuPEnrvkvtzuWChSa6b7sB9PxETDwN6BpWlxFfTAelnLYGKQ6PvP+Gs7pJbC9yLU4wvDbSmY5PfjY1wu+OqRGsa+Ojco6T3GVvqkAa+jYTc8fxIayajvxc2byDT+7KbLyzCYrANM8wDO/ZU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YQXPR01MB6671.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(18002099003)(22082099003)(6123799006)(4143699003)(56012099006)(10067099003)(261026140227099003)(261028144727099003)(261022105027099003)(261009223027099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Wm5KeWIrYUthelU3MzNDVTgzNXlBcVdLTHQxWmFzcjRPMjdyVWV0ZEIwNDd5?=
 =?utf-8?B?NE9jMFZLQ3ZCK3B1aUVUZFo1aHJrTkI2d29kMG9BbU5GV2VHVEhvajEwVDAv?=
 =?utf-8?B?TWNOaUY1NHZuWUpOMG50L0lXTDQxL1VWdWhaQ2NQTHFMOXNJempFaXJaS3BX?=
 =?utf-8?B?Tm0zTURoZUgzbnhjZXR5R1YxR281NlpTN3F3RDdDOS9ITzdhQ1c1TUVEUkFx?=
 =?utf-8?B?VHczcFlLL0NqZU9LRGo2MHd2Q2R0M0lPVG5EK3dSZWlIbm16Z3IvVzBIWWw0?=
 =?utf-8?B?Sjh3WitaUitSeUdsaU1zQnhETU9lMXNRTW1sVk1KditXZGlYUGsvOGpiVmh5?=
 =?utf-8?B?bkduVTRIVGJ3am94Q2c4c2Y0MkRqR0szOWhEZEU0c2MvVTRNYytnS0hPSUNV?=
 =?utf-8?B?RmtQNWcyOXVWbWhCU055NzlXUW1PYWNkOFpFOHFkd3lxRndhQVlZTHRiRW1D?=
 =?utf-8?B?ZGpqM2dQeHhJckZtdWZ6NW9rbnhOV1QwRmZKUHNGNHRwWDN0OGRRaStBVjd4?=
 =?utf-8?B?dUdqQUtDTmNHck1SRkxiV0J1L3Y0MktQTlB3QndYSUJ6T2FLNkV5bWRpc3pY?=
 =?utf-8?B?TEZ5MlBUWm1FQ21GUjJKVDd5WmgzcU1EQzcyTC9UbEdpaGkxYy9ZenRZNTIy?=
 =?utf-8?B?NEtodWZZRlVVcnA4THZENjlDS21tZXZHQUZkNEZ1U21PZWE1aGN1eEowRDZy?=
 =?utf-8?B?UjZ2ZzZUZFdSMkRjVXRxRDFHMStYaGlaNit3UkhGSWxNY3ovbVNUdUx3Wk5R?=
 =?utf-8?B?cEdJYWxTYnlYTGI0NTZWSDRvNVNscmtlYmJpL2QyY01uSnNMbDd3azVtWEZO?=
 =?utf-8?B?OTVBaGY5SC83NVM1YlZXeXMxVFhZM1BvNzZGdk4wMTRvQVhLOG9IeC9IazN1?=
 =?utf-8?B?RVhRTmJjYzlEWkVZV0FVM2VKVk44a0Z6aldPcFNDR3F5K2I4Tk9TWmx5cnB4?=
 =?utf-8?B?a2VOWWJGNHhra3BEWDA4UXB0ZnU4d2ZsUXZQcG10b1RtMlhtaWo5bVFrUkt5?=
 =?utf-8?B?dnNCNDl2d1RlbXBFY2ordncrRldEVS8yQkJPdktVZVlaSGNoVzRJNElpcndm?=
 =?utf-8?B?cGR2TzJqVXhBNURPa2JuNE9BYU9tbEJsSlBSSGFleWpsTjRZM1UzenRPT1Ax?=
 =?utf-8?B?WEhsaE5RK3FPWU96cUxGLzBCS284K2VpdnJaVzNuU3pLSzkzZEswalZTbDVv?=
 =?utf-8?B?dW92aXhZT2I4V1BwYWFzWFM2UUVJMFB5WnYydFdURXEyMnJhcnRLZXdFbzZm?=
 =?utf-8?B?Z1p3YktpQ0d2M1dwQUNjMEFPUmlJeXkzY1JsencvalFSRk5mK1oxSE5DempH?=
 =?utf-8?B?RXcrRlRKbHM2MHZPamcxTFVFK3R4cjlFVjhrNGRhQTVlYnZUdTBmQWltZzVt?=
 =?utf-8?B?T0ROS0dpanJJQ3g4QkpnTFRRY2xaa09IYTJLN3Y0b1JaYk9uVFJZTjRpMHVQ?=
 =?utf-8?B?UG9sSEppdVBqdndTQ0dCb0V3NDZZYW5MekZaS2ZSN0FwQWFZNFFxQjZjSGRP?=
 =?utf-8?B?VFUzNjZXSk5xbDFmcE1IQ09QWlVRZThvUmNnZzVLWXdMSVZFa3IyRXdkdmxP?=
 =?utf-8?B?QVNtcVZVN2swN2FwWjJLaS9LVGZ2TnBJQm9kVUY0eUJja3hmN2haSjBTc1Yx?=
 =?utf-8?B?em0xT29vMWJJOUdvZHJ0WHBlQUdPOUwyVlEvMTB0OW5ZWUdKK0ZMNTlsQ0Jq?=
 =?utf-8?B?U0xYUEp6dUZ5RjB1dEFTa2FvbU95eE9XOWl0WFpYbmVGbFBNMk1nTTdiNm51?=
 =?utf-8?B?c2xRMWhwT04yR0w5RFdhelRZdU1GSjFlZnhwSTE3UEkzeERJK1Baa0E2ekpT?=
 =?utf-8?B?dkUweEtMNEtmcDBBSURTYUlRZnpZbUd1bGdjUVM0WnFCUGJsQmFwbXZrNmNt?=
 =?utf-8?B?YlBjbk03Vjh1QmRIMUUwcFhvY2VVOVpUMVNRdnRkdmYzS2dyNVVrWms3MEtF?=
 =?utf-8?B?NzI4QWY0eHkxNDRpZG9pSlJUeDNYYS9jZ2t5ZTlGWFJCaks0T2lHRDVnK1k3?=
 =?utf-8?B?UXQzTVp4WHRleTB4OVB5NzY1NkFHVUNicmN4S0ptR2dPUEpyTlphVm0ybU1z?=
 =?utf-8?B?Y0JJYkNkeCsxdGdSSERNNnJSeTJPQ0tCaE1vM3N2WGYwa3BhQVVDbU9OK0lh?=
 =?utf-8?B?T1VnNTk4RE9FaFhINWFod1ByY2FyVlVPY0h4RnFqZUNKYkdORWVuL2tDY0wz?=
 =?utf-8?B?dU9HckFOUVBMVDIyOCt2QXoxY1lkRlhqeWhKcmp4YnVyd1A2V3JuTmkwOTBO?=
 =?utf-8?B?Z2UzcUpXb3hNTjVNL2NtcWplUVVTYVR6dTQwcTB2eGZrMmpqMGQ2NVVXcDcv?=
 =?utf-8?B?ZEh1eW1XU1RhY2hvQWZvQVg2RXNvbnNiVnN4a0FxSU9oTnlxeG5qZz09?=
X-OriginatorOrg: raithlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04765c8b-bd64-44d6-4583-08df4404468a
X-MS-Exchange-CrossTenant-AuthSource: YQXPR01MB6671.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 17:08:46.5376
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 18519031-7ff4-4cbb-bbcb-c3252d330f4b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: egmc4pHQylC0tdYFp2j3ZGyghurjzXbjs2BOsGtcW5r7EfoKO10gAmkF/tjIQyGhQiEnghrsRGXm4VlAD3Z70w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQBPR0101MB6667

The 11/15/2026 14:51, Leon Romanovsky wrote:
> On Fri, Nov 06, 2026 at 04:48:21PM -0600, Stephen Bates wrote:
> 
> Stephen,
> 
> Thanks for bringing this to the mailing list. It brought to my attention that
> the perftest repository had been neglected.
> 
> Please open a PR against the perftest repository, and I'll start cleaning
> things up there.
> 
> Thanks
> 

Leon

Thanks. The PR can be found here:

https://github.com/linux-rdma/perftest/pull/419

Stephen
