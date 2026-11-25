Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.44.121
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795576437;
	b=zZL0Qzr61GDcKegBsk44IgGWS6NnUVwRaa6RH9i5XVXIgfyNborhhbuFRkI+x8grUheO
	 DeerFDXSl6yKbOlhTzIjFboPAgCBbPLbKWh+BEAdyHxhCYeSw6BdZy1Gla1I7Ov00Rrr8
	 3tsmgd2G+7AYBQvNbC+48JG2arCddTa0DPUBojLPpYMZ71Swgsmfd3RW0YS93KHU9C6mU
	 nMT9+4COGNBlR4YohifKyLnb2yGlDT32BgskdDERxYWouxEQFSH9PiTfoY1A0MqSGJ9+x
	 X6Eyzdt5zBa5zNrrvOczdshgSObbdE7PmLqq9VmE2GGFAZ83nOOX4NSCpNCfLHwyrUQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795576437;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:References:In-Reply-To:
	 Accept-Language:Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 msip_labels:x-ms-traffictypediagnostic:x-ms-publictraffictype:
	 client-request-id:request-id:x-ms-office365-filtering-correlation-id:
	 x-ms-exchange-senderadcheck:x-ms-exchange-antispam-relay:
	 x-microsoft-antispam:x-microsoft-antispam-message-info:
	 x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=76BanF3rZS6YRISo7RGLGE7q5LIRKHH9lEoedDUykH0=;
	b=CLRjZHVxt8twPpyItVwp4v9H1SMg1lqDMq8ecavmx8VQG3UXmpdkL8r7fUhjYhoccNKX
	 1YTarR2bYTE9sRfuCIaix3J9jmL6nAXPs/6P8WG94323Q0gVHeAHDj82uKAyf+8JzYmUq
	 9WdKA97OTchSDOgGKwEVcKNCNgMnj6PSLqLPOKEox+dDBDV2UP1FKcUhrBg76jO3N4J/k
	 p1LBMwFSgVZ4H1yNKMP3nTNk7z7pgEzQjsINyZRX2vsuKavEMJenyvz5rDMM6FJVFP2Sn
	 cPmoUxzTL2TQOq+ZlagnuUbAFoGCJ7Y8YBkKAIGwB173oFaquZPm9/hkg6EET1UNXHg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=microsoft.com;
	spf=pass smtp.mailfrom=microsoft.com;
	dkim=pass header.d=microsoft.com header.i=@microsoft.com header.a=rsa-sha256 header.s=selector2 header.b=OdFa8zhH;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.44.121
Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11023121.outbound.protection.outlook.com [40.107.44.121])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06324606A31E;
	Wed, 25 Nov 2026 03:13:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 06324606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=microsoft.com header.i=@microsoft.com header.a=rsa-sha256 header.s=selector2 header.b=OdFa8zhH
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HRC51w9KL/OuHGlsYIgI82AmofQMC3l9tgPXKevFq+ChdaItVaXBAaSZSijMmtUs1BGSjKelNbwUng3hJ+nvTQrneO34eINWuHAKClHf7mzXsL8zw//RTWk5uw+6ELVVkvOaCBPhMmotfLOXJvrsvjv5LAzE2VeImPJHpOG9p/GjBtGswaKHOU4LUhoV5w6xMBZIVq82HN9n8AHkva+L+8LS3k9wA43J7WvxSj1o+fLa0p7AXOYhZXobAb+w7M+MCzoO9RIL7An6fWuyK4KQQ8XAHbFCsrI6wXI2PWVwh+3KqY5t5wTJLJcaO2moJvENanfvrPmT5AQgs/m1q10TCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=76BanF3rZS6YRISo7RGLGE7q5LIRKHH9lEoedDUykH0=;
 b=kwqG/uw9SLP2KzI6luRoKHGCYUH8YM5kALZRdBCIpf0WQ76UPWQYhAHl1vwZCivYQzJ41ZXXKOqHHgN3lLjq/1amsvv8zbzr6YjqCR1tvejB6AUdM1uW3TmKgRYzh1LYUANfua9pf/B9EnZyFUr/S3WHex3stjy1glOIAHREK+CvwvXJovOzp2HvRMLfE21/z7/b7B5AcIBeKgDrGA/P/2VyciUGaQ1L/8wCc5R0KP3hzMBirzCfCBR6bbeGxTNQoh8pRP7Q0tW4cFT/YmZ267PjPzX9ZlQKKSxu7HKgsgL57TV3QsAiWIeDPQ3SNI7YKLby/u9Vfk1EUAPVV9UxdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=76BanF3rZS6YRISo7RGLGE7q5LIRKHH9lEoedDUykH0=;
 b=OdFa8zhHaq4leMdNUGYwUU9+goB0NxQgJwWCp2OEBq+AlVAlNIl/ElSXmghkhk4kpdD5PPscTqMpRNi8B2wqRxR1QhEwnE2Djjn3XAloT8OviG33p0WFR2lpvuf/9QjB1IWSuN4DHEwld5bq36ADI62v2OKSvOFu8YQ1SvkTaKw=
Received: from SE3P153MB1848.APCP153.PROD.OUTLOOK.COM (2603:1096:101:340::5)
 by KUXP153MB2211.APCP153.PROD.OUTLOOK.COM with HTTP via P2P; Wed, 25 Nov 2026
 03:13:46 +0000
Received: from SE3P153MB1848.APCP153.PROD.OUTLOOK.COM
 ([fe80::8f4e:575a:4706:a56e]) by SE3P153MB1848.APCP153.PROD.OUTLOOK.COM
 ([fe80::8f4e:575a:4706:a56e%4]) with mapi id 15.21.0688.000; Wed, 25 Nov 2026
 03:13:46 +0000
From: Wei Hu <weh@microsoft.com>
To: "netdev-bot+sinfo@kernel.org" <netdev-bot+sinfo@kernel.org>, Wei Hu
	<weh@linux.microsoft.com>
CC: "longli@kernel.org" <longli@kernel.org>, Konstantin Taranov
	<kotaranov@microsoft.com>, "kuba@kernel.org" <kuba@kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>, "pabeni@redhat.com"
	<pabeni@redhat.com>, "edumazet@google.com" <edumazet@google.com>,
	"andrew+netdev@lunn.ch" <andrew+netdev@lunn.ch>, "jgg@ziepe.ca"
	<jgg@ziepe.ca>, "leon@kernel.org" <leon@kernel.org>, Haiyang Zhang
	<haiyangz@microsoft.com>, "wei.liu@kernel.org" <wei.liu@kernel.org>, Dexuan
 Cui <DECUI@microsoft.com>, "shradhagupta@linux.microsoft.com"
	<shradhagupta@linux.microsoft.com>, "horms@kernel.org" <horms@kernel.org>,
	"ernis@linux.microsoft.com" <ernis@linux.microsoft.com>,
	"stephen@networkplumber.org" <stephen@networkplumber.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"gargaditya@linux.microsoft.com" <gargaditya@linux.microsoft.com>,
	"kees+treewide@kernel.org" <kees+treewide@kernel.org>, "kees@kernel.org"
	<kees@kernel.org>, "mawasthi@linux.microsoft.com"
	<mawasthi@linux.microsoft.com>, "edumazet@kernel.org" <edumazet@kernel.org>,
	"shacharr@microsoft.com" <shacharr@microsoft.com>
Subject: RE: [EXTERNAL] Re: [PATCH net-next v12 0/5] net: mana: concurrent HWC
 requests
Thread-Topic: [EXTERNAL] Re: [PATCH net-next v12 0/5] net: mana: concurrent
 HWC requests
Thread-Index: AQHdfCo8TuwZz0qhSk+2ulMIpBBYo7c9XQ4AgADAAsA=
Date: Wed, 25 Nov 2026 03:13:46 +0000
Message-ID:
 <SE3P153MB1848F6034ECF3753EF7F2FA9BB432@SE3P153MB1848.APCP153.PROD.OUTLOOK.COM>
References: <hwc-v12.91ec3eff9cb647d5bc5cc932b3c6f60c.0@linux.microsoft.com>
 <179553507044.3294.2548266527967853234@kernel.org>
In-Reply-To: <179553507044.3294.2548266527967853234@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=0e4dd440-75e4-4140-93dd-11a180d9a49a;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-11-25T03:11:43Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-traffictypediagnostic: SE3P153MB1848:EE_|KUXP153MB2211:EE_
x-ms-publictraffictype: Email
client-request-id: 0b5bf08d-28fe-4ac1-9e6e-e1da235ac5c6
request-id: 80644a6b-4355-4200-29a4-08df4aa21e4c
x-ms-office365-filtering-correlation-id: 80644a6b-4355-4200-29a4-08df4aa21e4c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|7416014|23010399003|42112799006|1800799024|6133799003|18002099003|22082099003|7053199004|261026140227099003|261021121427099003|261022113327099003|261022105027099003|261022075727099003|261026121527099003|261028144727099003|56012099006|10067099003|7146999003|261102123227099003|4143699003|11063799006|38070700021;
x-microsoft-antispam-message-info:
 +ZedZHV3/k6DFPvsLJrXMXDMVja+57FIukHhuZvaCnthicpPYZA+HxcmcWmVZ76EphYRHwrw3h3gG1IaUby97pJ3jbjr4djRqqTntq2gpNvCjxHqagRiDAext80ti26ElhA6fBoJ0XKnA/IYS3SSz9krEVQSvzLcFes9VXw2a62ODspZeOtppzpqXaPjmHjpoptgasKpEW7xFZnbZZ80UMsqgpknY0hBDrTOSkLhlvZm5GNnOjqQLvK08ayHTMfPNavzu7vpyYCTNC4DZa21K/vd4HdkuNwDoHQ1Qitn/miBfN8g837Z8TGXQXKqu3MqdIMelwIzi/eLIDeRgJBlCM1fgEy3QmpHwCa2StPYTMed1rlTSZf0vPt8LP7uWBDvMynj+mpE4QRrVDiZzZaaoaymjhQzjQxW4dOI8lVpCIbPgrKyI8b/E6OfZLmTvScXeVO9kqZCaujqxx+1k9bsAOQPEdRT/xszEuW/f7566KMO/H1rcn3Qw4LAHIlbIMOVIjKIBamoN7P9LYWp3u7JIYO9cw4C/4iY6JnX5LtEF7vw9m37s6QO5hm5CgZh9b7v411cVkY3hs+5Cc/74jCOU0HQIbLIgZPmKY3NRrxSrI+4gTnC7+rPMa16ML8coDRh4GEwT7uAmT5pkLIasM9H+GIfL4qlvU2as9lwAlvZl4XYb/t7sTLXdrL1YuvrVzTfTQTp9JZStBKtWVFzfOCa4g==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(23010399003)(42112799006)(1800799024)(6133799003)(18002099003)(22082099003)(7053199004)(261026140227099003)(261021121427099003)(261022113327099003)(261022105027099003)(261022075727099003)(261026121527099003)(261028144727099003)(56012099006)(10067099003)(7146999003)(261102123227099003)(4143699003)(11063799006)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?b3UzaVpXOUZXWW12NUtWNkV2YzhGTzNoKzI4UXNRWFQ0SjI5c0dBOWJCRzN1?=
 =?utf-8?B?cHR4TUh6RlBCcGYyL0VqazdmZU5ETEpFWTZjSk4wd3ZWN3Zxc25waGRwWHBa?=
 =?utf-8?B?ejViNUw5TmxGclJRUENtaG5Gc1IrQ2hkdk5YQWRGeFV3eUQxWERNQjdaRTdX?=
 =?utf-8?B?WCs4RWhEMXFSSTNwTHdPakJRa0NYOUg4dmhWRDY2LzIxZlF2NW1KeForRjhs?=
 =?utf-8?B?MnQ0eFVheURndlZxbFdjMmtmSmpGTG9VbVlqV3FsblpTcm4yTHZXWHpORDZh?=
 =?utf-8?B?bDV2Wnhib1BiT3QrSHNqN2Zwc0ZuMEExUGVYTEljd1JCamRvS0hTRnM0L2h4?=
 =?utf-8?B?bHFCbm12QVNXMkdha2FxK3FmRDNCWnk2YnJTdWZuazVLN2ZjSWZwZVl0V3ky?=
 =?utf-8?B?aWNFSnFyejErY09NZDgvWkRhTHFUdjdYdzR4MTBNbVM0WXlCdVFpeG5jd0lj?=
 =?utf-8?B?SlEyQnZHblFHWnR5SUhiSFpTV2tOM3dOdkVkKy8rbVkwS1hzdkkyd0wxRllm?=
 =?utf-8?B?RFVzQXJsZFZVbm53UStubjVZL0pTbDgxalNUMkN4S2p2U1JlcUZrbVovMENy?=
 =?utf-8?B?dStvVnVaUEVoUThsSE9FQThpZyt4M1I2Y2hVY1MxZ21iQ2VLYzhDcHc5QVNO?=
 =?utf-8?B?dlVUMG1mbEI2VlJOd2VMcS9oMENGT2RDNjRhLzVUeVg5YzZpZVRWaE55ZDAz?=
 =?utf-8?B?Zm1FWUpjOHZ4Ti9zUWRoTytNNlJNaUhZWkpLNDl4bHV5dU44R1ljUlo1NzZV?=
 =?utf-8?B?KzJxZG9NcDNjb0x6c2hWeEdrQUVYSlA5U2dET1NIaGxnVGNBQWU4UVFmZHIr?=
 =?utf-8?B?RVJ5dTNtODdRODVTV1ZTbU1iUjQxd2xVNHgvdTZWK1hWSnF5SU1tVjFxcHEx?=
 =?utf-8?B?R0dpVUoxYlZyaUJNNEx5a21xQzgrOVV2anNhVDdISklobE5hMkloU2tYTkJ1?=
 =?utf-8?B?b25XY3RJYStndnNTeHVtN1c5YnM1cjd3dkZ3aUZOd0xHQmVOVjV3cVg2azc2?=
 =?utf-8?B?WHdFbW1OWFg1ZG83NGcxdEljTmM3c0ZOZVpmSDNvWmVRc1FOTmp6bHBGWnlB?=
 =?utf-8?B?YjkzWjd4WjNpU0doM21kbXNpcG0wTVN4Nzh2RGQxc1lrODNKb3BNN2RoeGly?=
 =?utf-8?B?czJCK3c2ck5UWEpIVHdobXpkNHZpc1VLd0JOVWRTbUxZeWMzQWtrdGZ3N1U4?=
 =?utf-8?B?MmNmRURCajZEVUhJVlQwRFdwcGphMmhmQ05xWEdOc1JrOFhRNExjSEVwMEdI?=
 =?utf-8?B?ZVJLWFhCOVNFZU5idDZRSENic01Bb2lQVDVyRnFQK0JoUkgwMzhEUE9ldG1Y?=
 =?utf-8?B?QncyN09qbUNKUmFScXFZSmVjM2xlTGpKWXI3VnZ2bVhCYjkwR3FBUVRrWlVK?=
 =?utf-8?B?cWE3dzZNamJVYkFrc3ZYc04vNEFtVWczZlpIWTI3US9CZ0FnMlpOS0tFYjVT?=
 =?utf-8?B?YWw0Q05QUkVkc0hieVk0OFd2c0crUEs3SGtBbVo3clk2bUVYUWNsYTFhbmM2?=
 =?utf-8?B?aWJaNkYvSU4yQ0gybDRTbjVXWUwvWEtZMTI3VTV0WlBXK3pXOC9renZEZG5J?=
 =?utf-8?B?M0c2VUZsTWZZQzNKRVBBZ3gzdjQ1MkJQamtXYkJKWDVMNlllVXNWdlZGMEdh?=
 =?utf-8?B?ejJTRys3bTBQdE9sQ0NOaTJQdmNodGdMb05QSERCRE1rbDNwMWFRSm5Qd3VX?=
 =?utf-8?B?ZFFhd0wyQ3c1RjdKbmh4OWJoZm43OUQrR29mQXFZajZyN1pXYkszTDJkL0Uz?=
 =?utf-8?B?a0pNT2dhRXhJYmpLYjBFYzVOcEw2V0pTRUFxSlU3ZjVaeUM2SUV0aHN0d0pq?=
 =?utf-8?B?WG1UVUtZZTZPaDNaZjNPRXd4T1lwczlMYjN1VkR4VmlwQzQvaXZRZWdNZnBF?=
 =?utf-8?B?dk5LQTJLOTduNVpNSSt4RGRYblpLOFk4Z0sxMFF0bWgvTUhqYnA1U081YXVr?=
 =?utf-8?B?bUZGUVdnQnhRMkZtQWV5N1NzUU1FaWIvZFI0dmgzTXpEVlBoWU1LbDdZUi9x?=
 =?utf-8?B?d29VWlNBL28yNjZRK21EdmRTc2xGV2FUUXByVWhjVXJobWRGQzhEY2xJWUty?=
 =?utf-8?B?TzY4TERLUDlYWUhScm9IMFBLRERFNkpnZllJRE5aUG1WV3poWWJzcVgyWDNM?=
 =?utf-8?B?UW9MVExMalJPYlBwQU5LZmt3cS8rck1aSkFESkFrdmg2YnZhMENyZkRlWWk0?=
 =?utf-8?B?akV2cjdHZW16SVQyZmNYSTI4cFg2aHZRcUxhTUhRekxQNlpVNXR3dHZlQWdw?=
 =?utf-8?B?QzFBWnR1bXdOSlZoaWhyZ3V0bTR5amMyZFRSc2FJcFZyUDlQVDhjazZ5emt6?=
 =?utf-8?Q?K1B2fpckVP4Wtj7dXO?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SE3P153MB1848.APCP153.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 80644a6b-4355-4200-29a4-08df4aa21e4c
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2026 03:13:46.2938
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rGTTzbppMNSulZPfZwBxDbZjY+fkNZBosB7xg+qM+Qp5CkkNEzXPHYvIJq+O9bGNIMHwyWthJ/ddHSPK87KNtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KUXP153MB2211

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBuZXRkZXYtYm90K3NpbmZvQGtl
cm5lbC5vcmcgPG5ldGRldi1ib3Qrc2luZm9Aa2VybmVsLm9yZz4NCj4gU2VudDogVHVlc2RheSwg
Tm92ZW1iZXIgMjQsIDIwMjYgMTE6NDUgUE0NCj4gVG86IFdlaSBIdSA8d2VoQGxpbnV4Lm1pY3Jv
c29mdC5jb20+DQo+IEhpIQ0KPiANCj4gVGhpcyBpcyBhbiBhdXRvbWF0ZWQgbWVzc2FnZS4gVGhp
cyBzZXJpZXMgbG9va3MgbGlrZSBhIGZpeCwgYnV0IGl0cyBjb21taXQNCj4gbWVzc2FnZXMgc2Vl
bSB0byBiZSBtaXNzaW5nIHNvbWUgaW5mb3JtYXRpb246DQo+IA0KPiAgLSBIb3cgdGhlIGlzc3Vl
IHdhcyBkaXNjb3ZlcmVkLCBlLmcuIGhpdCBpbiBwcm9kdWN0aW9uLCBoaXQgZHVyaW5nDQo+ICAg
IGRldmVsb3BtZW50LCBzeXpib3QgcmVwb3J0LCBtYW51YWwgY29kZSBpbnNwZWN0aW9uLCBMTE0g
b3Igc3RhdGljDQo+ICAgIGFuYWx5c2lzIHRvb2wgc2Nhbi4NCj4gDQo+ICAtIFdoZXRoZXIgdGhl
IGlzc3VlIHdhcyBhY3R1YWxseSB0cmlnZ2VyZWQsIG9yIGlzIG9ubHkgdGhlb3JldGljYWwNCj4g
ICAgKGUuZy4gZm91bmQgYnkgTExNIGFuZCBub3QgcHJvdmVuIGF0IHJ1bnRpbWUpLiBJZiBpdCB3
YXMgdHJpZ2dlcmVkDQo+ICAgIHBsZWFzZSBpbmNsdWRlIHRoZSBzeW1wdG9tcywgbGlrZSB0aGUg
c3RhY2sgdHJhY2Ugb3Iga2VybmVsIG1lc3NhZ2VzLg0KPiANClBhdGNoIDEvNSBpcyB0aGUgc3Rh
bmRhbG9uZSBmaXguIFdlIGZvdW5kIGl0IGR1cmluZyBBSS1hc3Npc3RlZCByZXZpZXcgb2YgDQpI
V0MgaW5pdGlhbGl6YXRpb246IHRoZSBkcml2ZXIgdXNlZCB0aGUgZG9vcmJlbGwgcGFnZSBpbmRl
eCBmcm9tIHRoZSBkZXZpY2UgDQp3aXRob3V0IGNoZWNraW5nIHRoYXQgdGhlIHBhZ2Ugd2FzIGlu
c2lkZSBCQVIwLiBUaGUgcmVzdCBvZiB0aGUgc2VyaWVzIA0Kc3VwcG9ydHMgY29uY3VycmVudCBI
V0MgcmVxdWVzdHMuDQogDQogV2UgZGlkbid0IHJlcHJvZHVjZSBhbiBvdXQtb2YtcmFuZ2UgTU1J
TyB3cml0ZSBvbiBoYXJkd2FyZSBhbmQgaGF2ZSANCm5vIHByb2R1Y3Rpb24gcmVwb3J0IG9yIGtl
cm5lbCB0cmFjZS4gSW4gYSB1c2Vyc3BhY2UgdGVzdCwgd2UgcGFzc2VkIGFuIA0KaW52YWxpZCBk
b29yYmVsbCBpbmRleCB0byB0aGUgZHJpdmVyJ3MgaW5pdGlhbGl6YXRpb24gY29kZSBhbmQgY29u
ZmlybWVkIHRoYXQgDQp0aGUgZml4IHJlamVjdHMgaXQgd2l0aCAtRVBST1RPLiBUaGUgdGVzdCBk
aWQgbm90IHBlcmZvcm0gYW4gTU1JTyB3cml0ZS4NCg0KV2VpDQo=
