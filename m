Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.26
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795447851;
	b=DnbbZpV8bvd8eXhf5YY8F+yyRrjzqrFwOworH33TsUA5M8nAsT+p1Ng+5RA1PDB79lYN
	 aY16y4PyhV75+Xo93VLrR4TgElQqWCQ8dc3IYyMfG4os4rfCagaZd827GMvB7YeevXgvG
	 7Pr9pV86GFMqDo95rZD7R7s8iEH0GrMl7Uys0USN+mElaWMYeRDZQ1z9Bn7GjdtZEd5Iy
	 YpFZDWLdbuua0gmA4+4V41FWe7/r8jMIxWNgoSYcwfyrCbVQiZOZA+3xARbAK7pCj+oCh
	 9PnJPHknZVKIqHU1wlLdIE5RhXi9vQyJFv/NxxCTLdaQCHZUEeVj1Kg1cn7EnMhio+Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795447851;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:References:In-Reply-To:
	 Accept-Language:Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:x-ms-exchange-senderadcheck:
	 x-ms-exchange-antispam-relay:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:x-forefront-antispam-report:
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
	bh=IrBwOctcEI10YUqpf7utCoJ+VgHecvJt3qssqaYrgUU=;
	b=hZQLJZ8FbaOYmCDx30D8ZMF9hIEazuzPWNosGCsucbx/khtD4J6jkfhq2oC9uT2fdBd5
	 PFEXuetg8k+2e6yyxXxcJLIkmjvSsXtZTLBpM2Ft5FfWKEV6YddqEpLB8MdDtqI76xFsF
	 Hvba4ISB4bvvkoH/LLrNtFp328odQOt+7KQ9GVHKeMT7eIr8HnYTvs/1Q6L4PITw/7/RB
	 mbL9PWVvxq+HdQaX016Tc+dxNTS2sbmIYXClgAlxp2C+/vcyF7Si1miL/L8aabyiTUSGS
	 GxgOqWZB9+qTZsbZXsixpH65a0xs/cVfc8rqYgYsHvaS/sjmUVDFg38bWAhnQFepJjg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ZmgGYcBQ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.26
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010026.outbound.protection.outlook.com [52.101.193.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6C1606A31E;
	Mon, 23 Nov 2026 15:30:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3A6C1606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ZmgGYcBQ
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=boabOnIwP/5q+KmDUblx6u8kosixrwJsdEqxy4SupnwI0FKOXL21oBwXKUbs4YQtp0u1trBV/gmIV4wVJMYcUXoKwmzV1NPM4YQ/T2XQK4CtGkUNl1jMK8X4Kt5pjEVL+VFqMSQkU2srx8PYat7frOpIeLTdAfVCNYXMbj63AzE7bWhAUmRZz6eCc1LKJBSWvmoz/B2cuF7QcJOPbS6MPbN6TrX78r0bWjhUW1nDOsuVUQ4KC3SYA9QGKpoFWCJm0qYASPYGYztJENKn8HX1fUyT8Tk8ZbvVPmvigxA48VP+JMxNWf3Aul8PJS6lW67STmAzqOoLg0S2Uh+SaTmE0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IrBwOctcEI10YUqpf7utCoJ+VgHecvJt3qssqaYrgUU=;
 b=bKO2RJkN2VUo53YtvmdBHZR90vZ/YZ9BQjgjyF5c6sR3ZmqpJAij1pVQ2PuaxHDOTCk+cRUpGp1K7BjrT19WS0JjxvXVDg2tm1FeiGFuldhS3j9ocRHkh2di7cIMX6ex7tr10KBasATPApWSZVeqg51dfWFLX6gS9HUjCGwKvgVi6SomCtyWGgRzppaf2qgF1QCmSvwrVTMm/w8hlghVLHGElhK8Bko5UckMVYIUKQ5GtrTSwfYiYcohq32Jv1AUaj+RO+fgPOzucKRrAIFFP+x1eJVShuq125keF9dmbB/EbnUlvdKXtwYizkalj3taaj4Rd5Ok5b2wl0SqZk9MMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IrBwOctcEI10YUqpf7utCoJ+VgHecvJt3qssqaYrgUU=;
 b=ZmgGYcBQd1xV8rcIIdwksEdaLrhCfo7z/N7bbCGPOw71jixLIqTvqkjK/7JTTQdHx2smco9bncRsjDeRlEMOrrCgReh8XumUzXhwcTBq2JlaFjKqraZzAP0dhnnYeCFU1WNX09jwi6Qrb1u4SLjrH+VuuAwEgjW6qVHFFA0GQ9uLgmvyxDCBes5LtEkVd7m0PUlbHpJo3a1nyIxKAQHvWU0jJ0jtlF3FFl/w8rXk2VE1gs98XzFzaRmYQU6BeGA50Ats/056h9Rh9xoc+mm25sd11D9dd7mF0d+QZP38h2e4Cc21z9p28vVrIebif41PAP2PPK/EFAUZEmhZCE2z5A==
Received: from PH7PR12MB6956.namprd12.prod.outlook.com (2603:10b6:510:1b9::19)
 by IA1PR12MB8539.namprd12.prod.outlook.com (2603:10b6:208:446::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Mon, 23 Nov
 2026 15:30:46 +0000
Received: from PH7PR12MB6956.namprd12.prod.outlook.com
 ([fe80::dcc7:f4c1:a9e3:dfcf]) by PH7PR12MB6956.namprd12.prod.outlook.com
 ([fe80::dcc7:f4c1:a9e3:dfcf%5]) with mapi id 15.21.0639.012; Mon, 23 Nov 2026
 15:30:46 +0000
From: Uri Dar <udar@nvidia.com>
To: "netdev-bot+sashiko@kernel.org" <netdev-bot+sashiko@kernel.org>, Tariq
 Toukan <tariqt@nvidia.com>
CC: "andrew+netdev@lunn.ch" <andrew+netdev@lunn.ch>, "davem@davemloft.net"
	<davem@davemloft.net>, "edumazet@kernel.org" <edumazet@kernel.org>,
	"kuba@kernel.org" <kuba@kernel.org>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>, Gal
 Pressman <gal@nvidia.com>, "leon@kernel.org" <leon@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Shay Drori <shayd@nvidia.com>
Subject: RE: [PATCH net-next] net/mlx5: E-Switch, Size FDB peer groups for
 asymmetric peers
Thread-Topic: [PATCH net-next] net/mlx5: E-Switch, Size FDB peer groups for
 asymmetric peers
Thread-Index: AQHddg7cJpbQdwXzF0aaR0b1uaj2ibczjagAgAg+45A=
Date: Mon, 23 Nov 2026 15:30:46 +0000
Message-ID:
 <PH7PR12MB69563290678C8270A52C3CF3AA452@PH7PR12MB6956.namprd12.prod.outlook.com>
References: <20261116210917.1297111-1-tariqt@nvidia.com>
 <179499312875.3136.7073415507714082354@kernel.org>
In-Reply-To: <179499312875.3136.7073415507714082354@kernel.org>
Accept-Language: en-IL, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR12MB6956:EE_|IA1PR12MB8539:EE_
x-ms-office365-filtering-correlation-id: 9bb87059-7be7-48ae-d217-08df4976bea4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|261009223027099003|6133799003|18002099003|22082099003|261022105027099003|261022075727099003|261021121427099003|261026121527099003|261026140227099003|261028144727099003|261102123227099003|56012099006|4143699003|10067099003|38070700021|11063799006;
x-microsoft-antispam-message-info:
 SlBM5KwdkuCuPoCpPfpoHERzSNuOxpBUaIxhvGg1XK5a5Gc3wWnLhY2tb50l5YSCR2YlNCjv51PJ1L2l+ZGS4691QlEYNWGFP7yqa5kPKDer51F2rNPl5j+ruqmZ8HsgO4+mnXc+Yd+4aG7pbzbTbmCqMYG+C/o/ceo+SRcFTxm/MpwZ1ZWyHOjAtTsn0YD2UQvIePqLnM939RJxp3BDlEVtXDUf+mr9fd6+BZDpEHHn+6qNNiNq1fVQDAk1fFd0asLRuzvX/rOj9OgkJtzPpe4prUgU3uKotL8UEUvl9SKIxwU2WwPQVhF9M9+xjVQTlws6EZdG/rkcm64t3pQDWKlyXkFWzL+LlPy0GZpxNmZAYo/7xDwmUkB6eeYggGeBmsFyga/3mW8LNdEwX2K8CrvRU8/hT0Us9NyLMCjlx7hdZy3Rh332NLOGZPxOZx/lojVAetCVmwg23H5phCtgmTU2C5INqYybpu2k62oe2FEfrqwlDXMWfP35+OlgRwmsbk2Yj/Ex8TLbbgWdQVjWTfuFkzkFI8tQ1n2O1sTq8bq59hF/ejlJ1YGyqiD9IRnu0tyLoeYXaHvMDB0As0XqlbJ2YVCmGaBi56TqLMqeFK2kjAfl+Rai9/xYo3D3u6Px2+jlOm7WB+gbGlkWqL/7we/RUHTbNeo9f0Zjsyv/YzRCiSXCtvzKFBTclD94hfrAdki/UGB9+8nlMmwLRFfImw==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB6956.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(261009223027099003)(6133799003)(18002099003)(22082099003)(261022105027099003)(261022075727099003)(261021121427099003)(261026121527099003)(261026140227099003)(261028144727099003)(261102123227099003)(56012099006)(4143699003)(10067099003)(38070700021)(11063799006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cGtBSktoSGlEQnpGUDdoV1U3bStJVXZGS3ZjdlBlWU9zV2RBeDVWemMyOERW?=
 =?utf-8?B?V0dmMlcvQ2tUam9YTXJLL3o2RXZvdWExMzZVTVNnLzlVK2dYRE5IRTNvYXp5?=
 =?utf-8?B?a3NIMUc2WVB3UU5MN0xHZkRlZFBYQTBDeTJCaTRRdTQ5QUk3U1k3ZHlsL3BQ?=
 =?utf-8?B?NUt2VGVsMkdJMnIxamNiU1NJaWNsQnVHVmpIWXg0S1A5MEhmaFlhS1NGTTFI?=
 =?utf-8?B?UTFlMFBRSnJvV2hqVE03MkNoN09QR1BhMXNyaHhUOUUvY2txYVVyOUdtZDJM?=
 =?utf-8?B?T1hhQlROc0o1WU1keGhMWVQvakZxUWJEdVpIL3c3M1oySEE0dEFlV2JoRFZZ?=
 =?utf-8?B?L2lWMnVlbXB3Z1J3NzViekN4REprb1UveVpqbWV4aVh2ZWswTXQ0TGIvMzVj?=
 =?utf-8?B?R0loYXJsUHNteUVzZlRCQkJxaDdQNlZhalY5QXRxenRNU2Q1eHI5WERySXRM?=
 =?utf-8?B?UE1WbnBBaGRuWkF1ZWdVR2dUZjMvN1BOTGE5ZGtETFIxS1V6L3VYNUJ1SVpu?=
 =?utf-8?B?YlBlSDZ6blo5N2U2SXk5cnFLcFpON3NlK1BPVllGSzNuc1NiZDVHejVhQWhj?=
 =?utf-8?B?Y2tldFM5akRENzZGT1h0S2N4R0VOQnhPcVBlNGtlMGdwV2RyaFViL1NPVERm?=
 =?utf-8?B?MUFRNGVyT2xkZkQxNHUva0FQWFNkVXAwV0VjTDBGdERBRitBMUhySU5wM2JO?=
 =?utf-8?B?TEhjalJzVTM3eUhTWnExeUtEc09Ja1I2am43T1d1K0FFRUJqZU5vWlBtZGhB?=
 =?utf-8?B?T09xVXNIRjlRQUwzQ0hYNEtGTGw5YndLWmFWR2JBa3lzRksxTVRsd2xWZDZQ?=
 =?utf-8?B?d0duMVQ4eWtQTzdhOTJtdzBMWVdINkFNWXZYclJvd0FnOVJhZSsvcWZkcTg0?=
 =?utf-8?B?cWhZTjMzb2tKaG9YVXdNVWRGNU43VTQ4Mm04bUdVWHJob3prZk01cWp3RXN1?=
 =?utf-8?B?SmtoNVBjdG84bGwzWkh6T1dLbHRucTZmSUkzVGYwWTRLKzBtL1dOd1AvaGlo?=
 =?utf-8?B?cDlVVDBabnlrRmZRMWQ2V0NrM3VsQnBDQ1dCNnFDUEt5Zm5UeHJtNmhhOFBE?=
 =?utf-8?B?MVhRTzdZRnd4UmIxSGNSUjdSWHJYRDJ5eUoxMStJMTd3NGM1dUtySjh4VitG?=
 =?utf-8?B?L3JLME1qa2pRc0QvYUZRZ3QvNjl1eUd6WnplZ3pXcXgyZFlkd2VzaWwvcEdm?=
 =?utf-8?B?OXcvVlZXMlZnRU5peHNKUWdiVi9uaTR0eHExeWZ4OW5xRUhaMVNCaGw5cWlY?=
 =?utf-8?B?MlJPOEMxQmc3Z3BvY3Q1QVhyUWlMTEhtVGNMSFRCb2YvYUkwV1J6S3FzNFAz?=
 =?utf-8?B?MU1mZXl1c1VTampZc3J4UkNCRWVwV1RmL0NmR1JCRDlwY21zNjZHa1IrVVQ1?=
 =?utf-8?B?Y2QwMEl1dWREUUI0MXkrUkpEc0hJS285V2tWdllmT1oyN01MV0RIRTkyNEgw?=
 =?utf-8?B?bEp6T1dzb05URnZJTWkvaDNobzZOS0pTay9CbWVVNGpoMlJPNTF5TnljRFBk?=
 =?utf-8?B?N282bngxWEJwNUtJRTlQWU0rdENMTXIra2M1RHcrU2FuWEkxWnMwK09ZQzNB?=
 =?utf-8?B?VkZySDM5VC8zSUh6QStGYjNwbXpNMWo3SU1PcER3YzQwY0d5ZVFQeDBTOWho?=
 =?utf-8?B?cEhrMWhwTHVwQ0R1QUtqWFlrVVZjTHcwQjdoQ2dKeExza3BQVXdRdjVTUVdt?=
 =?utf-8?B?cHdqd3BMcTJZd25GUldWL1k2eG56UHdDanVGdnJDWmU2TElYaUtpR05kNWtq?=
 =?utf-8?B?L3g5SEIvKzg5R0ZOdkUvVWZucit0c0piUENGMjRsRDNibkJCN0VFekFWaFBs?=
 =?utf-8?B?OVZPakVkR3JOZWUwZjF6Uk1jbXp3MHhPMVdRYUFPcGpSYW01V2E0S3dXSGxz?=
 =?utf-8?B?ZU9jSk93Y2xZNmJKTSs0clYvVnNSdHpoT1U3TmdUT0NBY0Zjd0VUN0RiaHJz?=
 =?utf-8?B?Q2FIKy9KUUZxK09WckwrOXhaaTdWZkVZempxMkRYVTVPMnNWRkdvVVFSU2Y1?=
 =?utf-8?B?ekpCSWVFR3dwbnhSeUplZXJaejlKdjFKWGZvblJwSVlTV1VBa1hKWkY3ZGpY?=
 =?utf-8?B?bkJ4VUFXQ1k3ajh2eDA5a3d2ZVZqZWtQM3FLREVTaFkxbXprdnlSd3BMYnJl?=
 =?utf-8?B?ajVzYjBHNWlXdi9sQWFIczR1dm1YTXdEU2JtTER3Vzd0TE11dG5pejZmbnpT?=
 =?utf-8?B?SjJiSXlJWXM2ek9EVjh3Mk12aW9XRnFQT3NEZFdSN3VlRGRDanZkeVg1Z3c0?=
 =?utf-8?B?b2xWdkF5RlNienZOVEhtNnZaNERnZ2VGYkRKZm5zakM3ZU9kR2plYzZ1YUE4?=
 =?utf-8?Q?Cfsu3JGpxLZxD+9IAg?=
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
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB6956.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bb87059-7be7-48ae-d217-08df4976bea4
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2026 15:30:46.2435
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CTbJmcR9ekUwa6IGaq5HnQfzDUdlkQBFDqr4QbhNCGYRMowBpmp9K7FBtnaP67ay
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8539

PiBbU2V2ZXJpdHk6IE1lZGl1bV0NCj4gSW4gU01GUy9ITUZTIG1vZGUsIGNhbiBlc3dfbWF4X3Zw
b3J0cygpIHJldHVybiBsZXNzIHRoYW4gdGhlIG9sZCBzaXppbmc/DQoNCk5vLCBpbiBzd2l0Y2hk
ZXYgbW9kZSwgdnBvcnQgbWF0Y2ggbWV0YWRhdGEgZW5hYmxlZCBpcyB0aGUgb25seQ0KY29uZmln
dXJhdGlvbiB3ZSBzdXBwb3J0IChpdCBpcyBhbHNvIHRoZSBkZWZhdWx0KS4gV2l0aCBtZXRhZGF0
YQ0KZW5hYmxlZCwgZXN3X29mZmxvYWRzX21ldGFkYXRhX2luaXQoKSBmYWlscyB3aXRoIC1FTk9T
UEMgYmVmb3JlIHRoZSBGREINCmlzIGNyZWF0ZWQgaWYgdGhlcmUgYXJlIG1vcmUgdnBvcnRzIHRo
YW4gTUxYNV9FU1dfTUFYX1ZQT1JUX0lELCBzbyB0aGUNCm5ldyBzaXppbmcgaXMgbmV2ZXIgc21h
bGxlciB0aGFuIHRoZSBvbGQgb25lLiBXZSBpbnRlbnRpb25hbGx5IGRvIG5vdA0Kc3VwcG9ydCBz
d2l0Y2hkZXYgd2l0aCBtZXRhZGF0YSBkaXNhYmxlZC4NCg==
