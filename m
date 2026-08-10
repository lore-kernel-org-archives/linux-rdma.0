Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010068.outbound.protection.outlook.com [40.93.198.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0193B3839B7;
	Mon, 10 Aug 2026 11:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786362346; cv=fail; b=CQy0PcXja4NVLiktvem835Gknf/abuTF/rYjVOja/4ZZshGWjHiFbpPQk4GnXB54bfnxz8nrG9+Q9F5KAMQQReKejKHfCVOK1ZNNreM3QUi086mIsgpnZqZVh4NNs8YJWzFt2GCWOiVPS4/y5f9Xz0fhtTJ+ldizYtaLbYN6YjU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786362346; c=relaxed/simple;
	bh=WXxJVLAPggHzV4iM1xlE3bYxoTqJpFAcTp2AZ6W5sRI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XFfHvMWZqK6r30AGc5kvnPM8grKBS5BYwLYNUT1dW2/5bwe9VFWJcEwnVLwoGBqzxTLEYr2NSaD5Lj3cz91MTJoWAtmjvYzAEncbp29yEh7Gu0/UTeh9l0RsQ0vH4DQh5X+6/wcs1xCD8UDzGjYqbo6M3QsdUEXKYEzEwbzyz4k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LiPQY0M7; arc=fail smtp.client-ip=40.93.198.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LiPQY0M7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wF2fvmpCxUZx5sqKylh/icumaTAAOhlLMWwLP+PSEoNidVB3Tbu1NUv7p2XX09BNcNg/RC0BUruXiG7qj5A8TdgoMp8dAcTLkwGjn/2x5oqst1BxZIQTH2hZF6wCUFatExpXcQFpvTAI27GEnC7V/JrnAZEZqlDDikdEKzHpAX0rbmSbleHVf9slE/7/JV3FJ1w2bFv56hlOcApI+A00apxSCwZfXkUM7Dcy8Y0gBxyuPz70+fup4g0RVuTFET+/+FS4I1jDZ4aHsR7DFyA+uuvC7b3u4NKQVC8XSRxfM00IsJePvIu497pJUW2Oz7Nk2QZ2F8ggY2NI85fxXReRJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WXxJVLAPggHzV4iM1xlE3bYxoTqJpFAcTp2AZ6W5sRI=;
 b=KwM1tgjhsqLjBOeMdP16PN20T7i684cldKze//2r543oEmqIoxKLP1W4wZzSB4uuR2QjRedMkWG5WfbH04sEk9NBdV+Tu9PlwQ7AxfF1EkGw9KW1mVZwdCGWoZvnuA1FaBvGffmqOt1TgvJzxNbgHTEbzi4YpzVu59IKukMGW6do4uCkto9Qec3pVQMdWT+JgOPU7o5Iny6N2CbhKCvyeNF03ulkdJSPsHpTnqBf0zIvLh5oX5+e4ZkwbMlkCM6J6SdjFH8F3bOgJFTEDjgttoH3mi44qkRZOKkN3E+3Nnq3PoYIs0EeMpyjY8Dqj+BDa2qnreuykiBeOHDrvENqdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WXxJVLAPggHzV4iM1xlE3bYxoTqJpFAcTp2AZ6W5sRI=;
 b=LiPQY0M7CkOQb09wAriH4MkRySNpDYAMzLFI6mejrlj4vY7teHzDlfB1lBhbQrp23BTYLpUmbehqFPFX4wPQzLiN/ueRmPZ4XdwQ4jouG8bnaAnCVC36gaeLBQ4brwdoq9eVBzppPTM7nMJnTzKXwPy5v/j0/J1LTxhYpshSesdXNnRzRkDo2VeJiNy8Yiq28Y2tJIiF7j3KmfkfSGL8aDx9Cu31ccc9tuVNfUE+KPsUxTzi1OVg1M5Jyyl0Jt8O6BjL2R2y7ovVQrtlZzeYUp3U11zumBlAIdeXj2YOV2KcOS4GcBwHTovKw4MPd/EvYAi7Oh490sd2vdH/AF17Zg==
Received: from DS5PPF266051432.namprd12.prod.outlook.com
 (2603:10b6:f:fc00::648) by IA1PR12MB6209.namprd12.prod.outlook.com
 (2603:10b6:208:3e7::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Mon, 10 Aug
 2026 11:45:38 +0000
Received: from DS5PPF266051432.namprd12.prod.outlook.com
 ([fe80::25c9:b561:2aea:8e3c]) by DS5PPF266051432.namprd12.prod.outlook.com
 ([fe80::25c9:b561:2aea:8e3c%3]) with mapi id 15.21.0292.022; Mon, 10 Aug 2026
 11:45:38 +0000
From: Cosmin Ratiu <cratiu@nvidia.com>
To: "andrew+netdev@lunn.ch" <andrew+netdev@lunn.ch>, "davem@davemloft.net"
	<davem@davemloft.net>, Tariq Toukan <tariqt@nvidia.com>, "sd@queasysnail.net"
	<sd@queasysnail.net>, "pabeni@redhat.com" <pabeni@redhat.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, "edumazet@google.com"
	<edumazet@google.com>, "daniel.zahka@gmail.com" <daniel.zahka@gmail.com>,
	"kuba@kernel.org" <kuba@kernel.org>
CC: "sdf.kernel@gmail.com" <sdf.kernel@gmail.com>, "doruk@0sec.ai"
	<doruk@0sec.ai>, Boris Pismenny <borisp@nvidia.com>, "shuah@kernel.org"
	<shuah@kernel.org>, "linux-kselftest@vger.kernel.org"
	<linux-kselftest@vger.kernel.org>, Jianbo Liu <jianbol@nvidia.com>,
	"leon@kernel.org" <leon@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Raed Salem
	<raeds@nvidia.com>, "skhan@linuxfoundation.org" <skhan@linuxfoundation.org>,
	Chris Mi <cmi@nvidia.com>, Carolina Jubran <cjubran@nvidia.com>,
	"kees@kernel.org" <kees@kernel.org>, Alex Lazar <alazar@nvidia.com>, Dragos
 Tatulea <dtatulea@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
	"sdf@fomichev.me" <sdf@fomichev.me>, Saeed Mahameed <saeedm@nvidia.com>,
	"horms@kernel.org" <horms@kernel.org>, "aleksandr.loktionov@intel.com"
	<aleksandr.loktionov@intel.com>, Gal Pressman <gal@nvidia.com>, Lama Kayal
	<lkayal@nvidia.com>, "Jacob.e.keller@intel.com" <Jacob.e.keller@intel.com>,
	Patrisious Haddad <phaddad@nvidia.com>
Subject: Re: [PATCH net-next 09/13] net/mlx5e: psp: Add an rx_decap steering
 table
Thread-Topic: [PATCH net-next 09/13] net/mlx5e: psp: Add an rx_decap steering
 table
Thread-Index: AQHdIASWmNuZTz8N+EGuBksfx4ChEraHk8QAgA+ntgA=
Date: Mon, 10 Aug 2026 11:45:38 +0000
Message-ID: <b36593b50a56f6d8ef918bf4dc45453d84bcf6bc.camel@nvidia.com>
References: <20260730091756.2543777-1-tariqt@nvidia.com>
	 <20260730091756.2543777-10-tariqt@nvidia.com>
	 <0d72c5b2-6d4c-40d4-8cbe-8cd95d61a230@gmail.com>
In-Reply-To: <0d72c5b2-6d4c-40d4-8cbe-8cd95d61a230@gmail.com>
Reply-To: Cosmin Ratiu <cratiu@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS5PPF266051432:EE_|IA1PR12MB6209:EE_
x-ms-office365-filtering-correlation-id: 0efcad98-a7b9-4868-34b6-08def6d4e5f8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|7416014|376014|1800799024|23010399003|22082099003|18002099003|4143699003|10067099003|56012099006|11063799006|38070700021;
x-microsoft-antispam-message-info:
 TYrpoiDC6Tmm1Q97lSSD+GMZMTugdWfjdFTnK13sp0ppBSJJGgQqQLEXsqlDzHKHrpP2/AwnmO7Fx6ynYo/12o937tcLLSjFJFk9ousm7b14hiHRDJwNel9i2yFPIMlSyDyBCBze0pAueU5HUoMUap2zhJcbdz7qSuoctWRhxWl1MaVE/F2sjYxSBfwYfafMoFKs81axbSjqoUja++ys0Dq8eGxaDQQMaV/sIaSoYEvkCHRpzy01BVVFigyl1nCUchq3T87cD+pA6HKRVLQFNgpl9B8l+y7SsQYihiJWNyNm9rPYqvfj+DIw5FCNVv+9wf9YypghMcPOiGDtGGHQyx0ICic0oylPt2odf0oaToI57bs60ZUz1+UctD0jGqZL0oBrWqhJuTNxZy9NHAZpdKSisjanyQZNRRzk6hZVf48P/5ZpRDpMIUx3Kuzcls0xkFkjE/bQkoDtszIeaWx7gtXmNPKzYzo8dBwJWjA3X2N0BNgp3ajLiWlRHXwqIVMRJJMDxdbzwHcOPFHHCRC+H3DFWP7+352RjO2QKOa/CvPdXmvoZaWtHYSURAjtlloEMBkoxT+cyf4AD6vFzeSQArB9UGQ1k5xXskampk26+GW2CF2yghZ/K6dDDlAkGqw9e0qJELOdxc6nP50jMRsnmeJPf9NdIsYnpUSd/FHxVXkMDnIRsFgzDMCEjjKOfQiC6p7Q4OX3IKZm32kfW9AZ7s6To1IX5LCVGD0UaBCakI8=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS5PPF266051432.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(23010399003)(22082099003)(18002099003)(4143699003)(10067099003)(56012099006)(11063799006)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?NUt0V1ZzdjRQNmY3dUFFN3NtS25jdHp6b0lZdDV5ZkdLWnBrbGtEeWhCTDRv?=
 =?utf-8?B?VWI1anYrU3JlekR2Zkx4anR3UVFaK0xiYUE0OEVxK0pyNjZjcStFQUUxY2xR?=
 =?utf-8?B?ZENIUUIxc2lHN1ZET1NmVmhWeVRmSXhiVmZLbVk2cFJRZGV0NCtybldWMDBi?=
 =?utf-8?B?dGFUSkFaKythTXRxcGFhOFBhNk9mWk90a3ZJdXRRRzdndTA5TVcwRUQzK2Za?=
 =?utf-8?B?Z2VkNnNuSUVzN3lERkRMRFdIOEhDLzJ0WUFmVkJFUXVIenY1aGtIREE1ajA4?=
 =?utf-8?B?ODVmUjhhcWRDZGIxeFBnRi9RUGhURkd2V0xOMzZEck54ZWhBZXNDMFlJRnov?=
 =?utf-8?B?dyt1LzhoK3dxK1ZmalExRnNSbHJVNU5RRDlLdnV1SW1ZSDROTTVKc3pubnNY?=
 =?utf-8?B?T2VrUCs5K3VrSm5IQ2FHZFZyNThUZVNaTUVsZEdNMm8rdFlqMFNHRFZ3bkxq?=
 =?utf-8?B?RWFOOWx2TXVOY0pnczBGelNxZ3pKMUhoSVRpQWFGSldWUWVxUFAzWDBOTGFy?=
 =?utf-8?B?dkYxa0RvUTY5bmVzVjRYRm5VRlBQZVBCZFJwOWxGeTcrVWxCQkFkOWpSdll0?=
 =?utf-8?B?bXhBdDlhUGtxWU9nam9kMVVOWGxUUkxLRVFyZ3ZNVmNtSzkxSllNQ3VpdXpS?=
 =?utf-8?B?MlJtYWpLbXFDY0NLNTVRZGtmTXJwK25QdEdXV25HTUgzS0NKaUZneXh4VzRI?=
 =?utf-8?B?MU1QaU10M05iOGNXeTNrZlkvWHlHd2RiTzlvZklaV1dqN0F6VnNyb0pvQ2RD?=
 =?utf-8?B?TjhzanVTTkhObjNmSi9yd1U0cnp4MEoyc01UeGRmL2lkdHJxZXdmK2l5Q0hE?=
 =?utf-8?B?NWw5U05XWVVQQmNIek1YV2lXNGhQODhJejRPVDRJUWQyaGNWbGIvS0EzOEJY?=
 =?utf-8?B?Nlg3c1dXb3VpczNmZkptODNzaENqdHVYdEhQdHFaWFZZR2t1THR3QjlkTU40?=
 =?utf-8?B?emZwSzFXMTNFT0hHRE1iNzJXYmx5R2NvMVFGUHZnTHAvb1Eybkpzc3MyWFlk?=
 =?utf-8?B?d2Z4dnY5TGdrcmdZT3l3VnpSMmFiUjRXK3BOR3V1MDA4TDJYZlhJNWJwdEgr?=
 =?utf-8?B?eDE0V21ibUZaOFBibXBXN3BQTHJTTE5iNjBndEhRQm5DSlEvTXNMSnZrQ1pD?=
 =?utf-8?B?bS8wVkhJT0pxRmcrRjV0VFQ5M0FtMU1YZ01heUo0ZVlvb0MzRXpveDdlcWZj?=
 =?utf-8?B?dkI5SGlBME44c1NDUVR2ck9uYUl5aytxcjJ5ckJ4K3dzM1RET1hEWTA0N1ZJ?=
 =?utf-8?B?dDd6cFJTQmZrLzlOcEhSUXhWWG05dlgyNWtXdWlEWFBic0RyN3liYlFja3Nt?=
 =?utf-8?B?MFByYXZJZmFZMzZ1bk1OTUpKcC90TW1GUVFDRmV4OFVvaERBcTdmQjl2cGZF?=
 =?utf-8?B?WFEvSytwV1VTcmZPRmRWYmthaklrSTFncWJxTWVFZHBBTlRGZVBpay9BNGVN?=
 =?utf-8?B?eEtjbkhhWCt4bk1pelF4M2lZNnl1bUhPMENzMmRUM3VUMHRBS0RQck9aN0tF?=
 =?utf-8?B?aDJ5ai9LVWQ1VUQ5VnJNZlQyREVacWV2eGlrSTZ5bVNTRjJGKzY5VjFrakRR?=
 =?utf-8?B?UDYvYWtVTTBmL0dvQnowc2wyTU9JdWp4Nzl0aXNOMmVYbXNBRkVFalpXSkY5?=
 =?utf-8?B?bU1DZkE1azBna0NoalF2ZDZxcWNSanU5T1FKNlhpQVhOa3JqdGZDTFMwUStz?=
 =?utf-8?B?MWNIa2dsWTFQeE9KRnJUbnpTYmhiaVVzVGtUQTFTMmlXYUg3SzhXajNmajZB?=
 =?utf-8?B?K3F3NnczR2xQMHdkQWtuTkJiTVpRRjR3NkNUN2lIVlFUUjlLbkYxTHpZVG1K?=
 =?utf-8?B?eWZsUi9RZ1ExNU1TeGk4MkJyRWZDUUl2R2FheGVyQmQ2WEhPOG1PUW9qQlNY?=
 =?utf-8?B?bHlMM0MwNWRNNDMxY0xoQVhLZWpHR0tjTUEzaDA1aVpqUW90Q3V6UjlvTlAv?=
 =?utf-8?B?QWlLc1FDc2pNbTUwZWtLVmdPcUVhZG9GTFlnd1E0dU9tdzRNckg3SDV2UU9U?=
 =?utf-8?B?bFhCYXZQOVBPbVluWDM3M0plZWJhYjlvOSsvZ1crS3I4djVHWlRLdHhEbHlD?=
 =?utf-8?B?Y0taeFB4bjU1cU9ZeUNlQWF4WFJUeXdOV1dSbnhVVVUzdFNVbHBQbnZUTDAz?=
 =?utf-8?B?N2pGcEREbTRRbEwyeHVOUlJ3MUV4Y1FlYjVPbW1CYnpQTURhOUJmVWN5TGxG?=
 =?utf-8?B?YkluMXFRZkJzUW5Id0Fpb3BSVWZmS21XdlRHQmlRRzQ5ZDg3bm15aEJMaUZR?=
 =?utf-8?B?K2tzWDFmMlVreW5FQjlhaE9sOUkyak1NYUxoM1ArdUY3OTVyOExlWFdVOTlq?=
 =?utf-8?B?SVdNWkE3MUFiZ2lmQnl6QU1EbXZ3dzNlc3JXdFE1RFNNUTNCWmQ4QT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7290FAFF45D06444931ECF0C0A436138@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS5PPF266051432.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0efcad98-a7b9-4868-34b6-08def6d4e5f8
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2026 11:45:38.4634
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BX/jeNIKBkvYODoP31Iv+x5BlL+v2SD38uSBwXmvqnQv+kmrSihCFFTxEUAR4bSLMMMK/HJxru1uTHmtZoMkwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6209

T24gRnJpLCAyMDI2LTA3LTMxIGF0IDA4OjQxIC0wNDAwLCBEYW5pZWwgWmFoa2Egd3JvdGU6DQo+
IA0KPiANCj4gT24gNy8zMC8yNiA1OjE3IEFNLCBUYXJpcSBUb3VrYW4gd3JvdGU6DQo+ID4gK3N0
YXRpYw0KPiA+ICt2b2lkIGFjY2VsX3BzcF9mc19yeF9kZWNhcF9mdF9kZXN0cm95KHN0cnVjdCBt
bHg1ZV9wc3BfZnMgKmZzLA0KPiA+ICsJCQkJwqDCoMKgwqDCoCBzdHJ1Y3QNCj4gPiBtbHg1ZV9w
c3BfcnhfZGVjYXBfdGFibGUgKmRlY2FwKQ0KPiA+ICt7DQo+ID4gKwlpbnQgaTsNCj4gPiArDQo+
ID4gKwlhY2NlbF9wc3BfZnNfZGVsX2Zsb3dfcnVsZSgmZGVjYXAtPnVuc3VwcG9ydGVkX3J1bGUp
Ow0KPiA+ICsJZm9yIChpID0gMDsgaSA8IE1MWDVFX1BTUF9OVU1fU1VQUE9SVEVEX1ZFUlNJT05T
OyBpKyspDQo+ID4gKwkJYWNjZWxfcHNwX2ZzX2RlbF9mbG93X3J1bGUoJmRlY2FwLT5ydWxlW2ld
KTsNCj4gPiArCWlmIChkZWNhcC0+cmVmb3JtYXQpIHsNCj4gPiArCQltbHg1X3BhY2tldF9yZWZv
cm1hdF9kZWFsbG9jKGZzLT5tZGV2LCBkZWNhcC0NCj4gPiA+cmVmb3JtYXQpOw0KPiA+ICsJCWRl
Y2FwLT5yZWZvcm1hdCA9IE5VTEw7DQo+ID4gKwl9DQo+ID4gKwlhY2NlbF9wc3BfZnNfZGVhbGxv
Y19tb2RpZnlfaGRyKGZzLT5tZGV2LCAmZGVjYXAtDQo+ID4gPm1vZGlmeV9oZHIpOw0KPiA+ICsJ
YWNjZWxfcHNwX2ZzX2Rlc3Ryb3lfZmxvd19ncm91cCgmZGVjYXAtPmRyb3BfZ3JvdXApOw0KPiA+
ICsJYWNjZWxfcHNwX2ZzX2Rlc3Ryb3lfZnQoJmRlY2FwLT5mdCk7DQo+ID4gK30NCj4gPiArDQo+
IA0KPiBbLi4uXQ0KPiA+ICtzdGF0aWMgaW50IGFjY2VsX3BzcF9mc19yeF9yZWNvbmZpZ3VyZShz
dHJ1Y3QgbWx4NWVfcHNwX2ZzICpmcywNCj4gPiArCQkJCcKgwqDCoMKgwqDCoCBib29sIGRlY2Fw
X3dhbnRlZCkNCj4gPiArew0KPiA+ICsJYm9vbCBkZWNhcF9zdXBwb3J0ZWQgPQ0KPiA+ICsJCU1M
WDVfQ0FQX0ZMT1dUQUJMRShmcy0+bWRldiwNCj4gPiArCQkJCcKgwqANCj4gPiBmbG93X3RhYmxl
X3Byb3BlcnRpZXNfbmljX3JlY2VpdmUucmVmb3JtYXRfZGVsX3BzcF90cmFuc3BvcnQpOw0KPiA+
ICsJYm9vbCBkZWNhcF9lbmFibGUgPSBkZWNhcF93YW50ZWQgJiYgZGVjYXBfc3VwcG9ydGVkOw0K
PiA+ICsJc3RydWN0IG1seDVfZmxvd19kZXN0aW5hdGlvbiBkZXN0ID0ge307DQo+ID4gKwlpbnQg
ZXJyOw0KPiA+ICsNCj4gPiArCS8qIENyZWF0ZSB0aGUgZGVjYXAgdGFibGUgaWYgbmVlZGVkLiAq
Lw0KPiA+ICsJaWYgKGRlY2FwX2VuYWJsZSAmJiAhZnMtPmRlY2FwLmZ0KSB7DQo+ID4gKwkJZXJy
ID0gYWNjZWxfcHNwX2ZzX3J4X2RlY2FwX2Z0X2NyZWF0ZShmcywgJmZzLQ0KPiA+ID5kZWNhcCk7
DQo+ID4gKwkJaWYgKGVycikgew0KPiA+ICsJCQltbHg1X2NvcmVfd2Fybihmcy0+bWRldiwNCj4g
PiArCQkJCcKgwqDCoMKgwqDCoCAiRmFpbGVkIHRvIGNyZWF0ZSBQU1ANCj4gPiBkZWNhcHN1bGF0
aW9uIHJ1bGVzIChlcnIgJWQpLCBIVyBHUk8gZm9yIFBTUCB1bmF2YWlsYWJsZSIsDQo+ID4gKwkJ
CQnCoMKgwqDCoMKgwqAgZXJyKTsNCj4gPiArCQkJZGVjYXBfZW5hYmxlID0gZmFsc2U7DQo+ID4g
KwkJfQ0KPiA+ICsJfQ0KPiA+ICsJaWYgKGRlY2FwX2VuYWJsZSA9PSBmcy0+ZGVjYXBfZW5hYmxl
ZCkNCj4gPiArCQlyZXR1cm4gMDsNCj4gDQo+IEFuIGxsbSBpcyBjb21wbGFpbmluZyB0aGF0IGZz
LT5kZWNhcF9lbmFibGVkIGlzIG5vdCBzZXQgdG8gZmFsc2Ugd2hlbg0KPiB0aGUgZGVjYXAgdGFi
bGUgaXMgZGVzdHJveWVkIHdpdGggYWNjZWxfcHNwX2ZzX3J4X2RlY2FwX2Z0X2Rlc3Ryb3koKSwN
Cj4gd2hpY2ggd291bGQgY2F1c2UgcHJvYmxlbXMgYWZ0ZXIgZG9pbmcgYSBwc3BfZGV2X29wczo6
c2V0X2NvbmZpZygpDQo+IGRvd24gDQo+IGFuZCB1cC4NCj4gDQo+IEknbSBub3Qgc3VyZSBpZiB0
aGlzIGlzIGxlZ2l0LCBidXQgZmlndXJlZCBJIHdvdWxkIGZsYWcgaXQgYXMgaXQNCj4gc2VlbXMg
DQo+IHBsYXVzaWJsZSBhbmQgd291bGQgYmUgZWFzaWx5IHJlYWNoYWJsZSBieSBhIHVzZXIuDQoN
ClRoaXMgaXMgYSBsZWdpdCBpc3N1ZSwgb25lIHRoYXQgbWUgYW5kIG91ciBsbG1zIG1pc3NlZC4N
ClRoYW5rcyBmb3Igc3BvdHRpbmcgYW5kIHJlcG9ydGluZyBpdC4NCg0KV2lsbCBiZSBmaXhlZCBp
biB0aGUgbmV4dCB2ZXJzaW9uLg0KDQpDb3NtaW4uDQoNCg==
