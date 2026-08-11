Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013061.outbound.protection.outlook.com [40.93.201.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 524E01A3160;
	Tue, 11 Aug 2026 12:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786452084; cv=fail; b=WfDSiW+CvIFlbwJb0/qPFdV9rns/HrpO+FuV0EzZRJIikFx1FNe3akFCzlmjus8ToaLMjIv5TGENyo1Uzgn3cg93HMkLQxzpkkz+VTWEnR0OpdCbuMXcxZmFPgKnPqBG1LGUprzU6YdCWJKVg9vJy9/TFckNZIxm5gLsKoKrKp4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786452084; c=relaxed/simple;
	bh=UZweyicjhyUNSsyqvDDFzZymi1Pz9UEBdrl8GYTpaVo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rT/MefuIREYTyE4XkhWY/h2+VdDaUe0TvAxyiGImhQjQ2okeseR1J9bg7OrpQK8JjuGp010edR2psxAtob9gGJS2hxoyX9FRCfyx8sQJoTBP61Z8fiCgdmSY6iY6R9WamM5/kr1QkKjB4UtMwxv4kQiK47wbQ5j/k3Ud+p3pVRE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=i9+XMSOq; arc=fail smtp.client-ip=40.93.201.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="i9+XMSOq"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H1xPOhI9MHWslciZaCRLcbQInWXx5bc0RaS3FCC+sXMDgFwpWzhlhMFnXcLHTOLazdn+CG4SYc+D4ys7M0/7NIuNe/BbzCUImam2KhjP82UkVuB3gAiJ7s77F4hlOOxbly3ZOyyzf7ZHh6MFg8kxYWeTySfOEDSFotvJFQvpncIuTMEsUziiucAfiwkzUv7MKMfKIHn4hg/FSBOLsH99djO94ENkuurtBmBY6OLNjtf0sVWxPJ0NPwrZrfkTDq8uFkxF/4PHpvTRqbtgh+4FBTA5uS8YSFG3uyn9KcgmxS0xinbMoO1EKSJy6sFFNKvc8IIJ1mk7Q31gExsg2Z6PlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UZweyicjhyUNSsyqvDDFzZymi1Pz9UEBdrl8GYTpaVo=;
 b=uDX0A2lyRJPLVvd4LiMyhyx7jf9LSaAG6QxWQgZKFoMYBvaaSuQkS8q3gJx1jtKxs3Aa/i55RjezHk1bFZ5Ur1CbksrfmUT4xLOsDNwQJ+v/vnYVtAiXxF+MmgmOMoQ6KXp+ivudipSQn0Mb9qIYh2KoXPk9pZdg5vqjF2mF5U3DqVPpNMT8oYiUEAP0h/7Gm+EkQkQvvYyFCg0OwOxmc/wFoG6fW9ZVXqzfLOJ+LGFaS+IdPfXvJQMWnUdK/FvrmXV4v/Tgikw7FvTrtTBgwQNL/2W5SArArRKjRRYnqgst6VVJgg9mMl3MjS2lSgKpZfjCFEKSOrduyKiC4k8j9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UZweyicjhyUNSsyqvDDFzZymi1Pz9UEBdrl8GYTpaVo=;
 b=i9+XMSOqWdCSAR7fw55wUyfG8dbggmi0hLzp8kkKyFxyJdOY87tesqZs4tH79xySTU+kfVM2ciIB055pE6G9PAVj6oO02kNnpd/uw/Z0Mk+vQkLSy6WXYNyE8EoEVRU7uYN5CQws67caOpyZJiuXm1ThuHwXmeHhkyxeLASnVb3/niSbR05gPT31bCbgvEP5fjENFrz2cY69gh5ezqpQa4Di54+ElnKCymKh9y+U+ZgV89tyLN1PuVzBgE5iW8lO1ktikynhOFqTnVNLdVMiQ0fSO0ZvTV5XOP0jxNKV+fS4aG9h815qrvXbzBpaH2sDu+HkUTkzLHHfGwC59r1MTQ==
Received: from DS5PPF266051432.namprd12.prod.outlook.com
 (2603:10b6:f:fc00::648) by DS7PR12MB5885.namprd12.prod.outlook.com
 (2603:10b6:8:78::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Tue, 11 Aug
 2026 12:41:14 +0000
Received: from DS5PPF266051432.namprd12.prod.outlook.com
 ([fe80::25c9:b561:2aea:8e3c]) by DS5PPF266051432.namprd12.prod.outlook.com
 ([fe80::25c9:b561:2aea:8e3c%3]) with mapi id 15.21.0292.022; Tue, 11 Aug 2026
 12:41:14 +0000
From: Cosmin Ratiu <cratiu@nvidia.com>
To: "kuba@kernel.org" <kuba@kernel.org>
CC: Patrisious Haddad <phaddad@nvidia.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "daniel.zahka@gmail.com" <daniel.zahka@gmail.com>,
	Chris Mi <cmi@nvidia.com>, "davem@davemloft.net" <davem@davemloft.net>,
	"pabeni@redhat.com" <pabeni@redhat.com>, "horms@kernel.org"
	<horms@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kees@kernel.org" <kees@kernel.org>, Dragos
 Tatulea <dtatulea@nvidia.com>, Boris Pismenny <borisp@nvidia.com>, Rahul
 Rameshbabu <rrameshbabu@nvidia.com>, Jianbo Liu <jianbol@nvidia.com>,
	"leon@kernel.org" <leon@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
	"shuah@kernel.org" <shuah@kernel.org>, "sd@queasysnail.net"
	<sd@queasysnail.net>, Mark Bloch <mbloch@nvidia.com>, Alex Lazar
	<alazar@nvidia.com>, "andrew+netdev@lunn.ch" <andrew+netdev@lunn.ch>, Gal
 Pressman <gal@nvidia.com>, Carolina Jubran <cjubran@nvidia.com>, Raed Salem
	<raeds@nvidia.com>, "Jacob.e.keller@intel.com" <Jacob.e.keller@intel.com>,
	"skhan@linuxfoundation.org" <skhan@linuxfoundation.org>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"edumazet@google.com" <edumazet@google.com>, Lama Kayal <lkayal@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>, "linux-kselftest@vger.kernel.org"
	<linux-kselftest@vger.kernel.org>, "sdf.kernel@gmail.com"
	<sdf.kernel@gmail.com>, "doruk@0sec.ai" <doruk@0sec.ai>, "sdf@fomichev.me"
	<sdf@fomichev.me>, "aleksandr.loktionov@intel.com"
	<aleksandr.loktionov@intel.com>
Subject: Re: [PATCH net-next V2 12/13] selftests: drv-net: psp: Fix responder
 parsing
Thread-Topic: [PATCH net-next V2 12/13] selftests: drv-net: psp: Fix responder
 parsing
Thread-Index: AQHdI+yn+RnS0tvdH0K/K6KpoNcjc7aTWlYAgAPYewCAAJQ6gIABDnmA
Date: Tue, 11 Aug 2026 12:41:14 +0000
Message-ID: <73586539333ece6aff68ff29f7e43ceb59e7b581.camel@nvidia.com>
References: <20260804083535.2946459-1-tariqt@nvidia.com>
	 <20260804083535.2946459-13-tariqt@nvidia.com>
	 <20260807175858.70a717d6@kernel.org>
	 <51b31f2497f1c42464f803818b0e9b6cc6b9aa56.camel@nvidia.com>
	 <20260810133305.3b7448c8@kernel.org>
In-Reply-To: <20260810133305.3b7448c8@kernel.org>
Reply-To: Cosmin Ratiu <cratiu@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS5PPF266051432:EE_|DS7PR12MB5885:EE_
x-ms-office365-filtering-correlation-id: bef78f77-38e9-44c0-d040-08def7a5d4de
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|22082099003|18002099003|10067099003|11063799006|56012099006|4143699003|38070700021;
x-microsoft-antispam-message-info:
 i6W1UQWpmr7YnGK0Nxc6AOegi/P2N1JyVmnL2DaPi0FH8zxBThYB4MQAdpTOx6m0CF9WEhgB8Y+2JsFIH58vdvhsQYgX1QJCqwrhDvUN47lUyZaKCCsGZ7Ws2ZXH5KazhNAAJE8effYf/Lv7fSxFKQ1IgBUXA9oD6StqeHoe+zxV0Uzb23hkLvAoGMjul5r0/TdhhlykKCzWVscYO7yKxb3/+oS8C/5pzOPg/Xe6JPfCXWbZYkZef4KMHWCIxsEv8KyCw1qGQZ3fxhmdaaGP6JsuN3GAIAmIi2sxoM+W78EvPJahSnw7qGVZJVd+aKIk3VEZ+Tx3MlSAD2wSuhk5NGXxPswLbxcSCDcF3z82S95hEx4Bs6mKWMdb6y1AUEpGqEiO8BGUevha2oytyg3yvbmSwBiZPqhZd+NsvOO0HZojufKorwQmyWtbj+l65n7ZyoKHHOslXS4bB5XpHGsiHMtfoCVbR1Q73dDaehAau67OovDsLmizYhkrT+wEg/7nhCWx6jvJNGTzNqIxt5csLAtlVT9nJeuUtpHL+UvR6oI7jISfcqVVl5mObAfncLnvjrqGa8ZSVoD/zeZA/JbdUlp329hjYm7UWl8aTeCrQjJcQDkgS9Uj4icOcvyWYGBKBd3hm1bXFsLxV6NvhNoOku1LdF/taaaaQ3SUh5UBAvK2wyPBubAymplXNjvaha+nKUn22PkfcLNx8j2ltFu2mDHCS8UM8L0HQYe3uphvri4=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS5PPF266051432.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(22082099003)(18002099003)(10067099003)(11063799006)(56012099006)(4143699003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ajZZdXdJWmlGWGN3VDdoRE12bzZNNlIyZFBZckhkNlM1cVg2SzFPaWt6MjVD?=
 =?utf-8?B?ZlhLUGRtYTM4SDZTZjMvUzIvZFdlYkFVS2xLazk0ejRrc0FkMWZKNWNvUjlR?=
 =?utf-8?B?c0czSlRtWmhldE55eklLNmFwdmlpMGFtWEtldStLVjY2d3kxUm5mSHo3cXhv?=
 =?utf-8?B?clpXdnZFY3NOVkV2ODZwMk1sS01FSFlhMGtmYWY4M0Y5QWVQN2hxU3VUQmh0?=
 =?utf-8?B?eG1PRFVQR1hWVG5VVnNsZy8vQ2ZsL1kzM0VEaWNmK1I1NjNQdDdiVHVYR0tK?=
 =?utf-8?B?bVB3WXk3TTJXUFBYTmNPTCtvY3RKckYzR0VtbXA1a2NpVmVQellMWnVKaWYv?=
 =?utf-8?B?eVVFdXVVQnk3K2JTWlMvdzBtMUM5L2x3c0hJSmNGNjlGRk0yK2p2MmhwQVlY?=
 =?utf-8?B?SVVzR0lNZ0FPeitjZ01PZHEzbDZLMXF3WDAvQ0pSTURia2QwVjYvU1cvNVN0?=
 =?utf-8?B?TGFIUDRBdENvUlYyWWRVTm9kK3BoanJ6OE00dVE4ME83ZVJzd2tyaFZLZHJv?=
 =?utf-8?B?UTdyWGY4L2N6YllkdEFJd09ZbEN5NnpxdWpyL1dqRjR6MnNLR3ZhWnNKdHRQ?=
 =?utf-8?B?MTZ0TEJpWHlhSUNnT3FuVDh5YzBtVUxEQ1dIa2hFUlJNNzhMMHFFVlpnMHlU?=
 =?utf-8?B?bkpaSm1PeWhrRWw1S3c1dE8wV1M0ZElDNksvSWlzNmFmWEw1a2U1N2JjZlAv?=
 =?utf-8?B?cndJNm5ISndaM3NTYmlsNnUzU0Z1Z2JPd2VJNmRnT0tHOWl1dTkrV1NkTW55?=
 =?utf-8?B?aWh3cDNtWmZQRWoyTXlqOEpIeTE2OVJ5QktPQmxpSFUzeHNaVjU2a0d1YTJj?=
 =?utf-8?B?d0c4eVpQSXhVMnU4TUYxblRoV2hzSUoyYnRVaXAzU3FLNkF0Y0RiNTFCWkhB?=
 =?utf-8?B?V0dNVnQxK2VKcnpGUWc2WlRPSFB5TDNFUjE1Rng5NXVkWStrUjNjYTBremZF?=
 =?utf-8?B?MEJSMERpODJQS1QyQ3phekhVZDZjWFhISW85L2NlZGJMaFdORFY3cVpDb0hu?=
 =?utf-8?B?NTcwYlVDZWRmVVNiUFFGKzdmaVpEZm1FRjlaazI0L2poT2JjeG9tdVE0ZlBk?=
 =?utf-8?B?eUszaStRbFlQK2MrZTRnc1VSd1lVNkVzVjB5Tm9HVGdYUkRsRUFMNklJVTV3?=
 =?utf-8?B?d2pnYW9kcXdqVlNGMEU0eHJKSlhNYkgrR0grdENaTjJlNkIwRlJqQVVYYkhE?=
 =?utf-8?B?aVdlc2I3QjE4RjJDUlVPbUNzMkJKTTlLcVNxRHZhT2VPOXRwRW1wbW52S29U?=
 =?utf-8?B?blpWYkk1M0ZJVGduYlpzL1k3YktWZ2oxSkVUMGlZL3dES3p1bkVOT1VibDkr?=
 =?utf-8?B?MU4vWkJyeW9kWk9DeGpjQm9UQitSZzI3bkZEZDV6TG9mL0VCcU5JWHdIWWdR?=
 =?utf-8?B?S1BWbm95ajhQRUJKV2dQR290bzgrYWRlb0hMSHpBbktGSzhSUStqTFFtT1lD?=
 =?utf-8?B?K1hsemREOUlwNGhVQkVMaStVUDB4YTh2M2NLM2Mzb1dnc1U0ajhuSHg1bXNI?=
 =?utf-8?B?YzBhMm4wM201WEhDS2s2SlJzdGJqTndCR2pNWWp6eTM5RHRWSGE3K01nNFFm?=
 =?utf-8?B?TDR2d1JITjRqVWZmYy9mcnQxQmFVKzJhNDRHZHdKUzJJNWN6amtxZlNZM2F1?=
 =?utf-8?B?blNkL0FORjRNd3hsUWNpWVNDbDY4UnZyc3J0ckVRMlhDS2RqcDZaeWE3MWlR?=
 =?utf-8?B?WThrbEJWRHRhTkNZTjRiTDRmbWgrQjlVM0dOYkoxTmhqcmpQTzY2OUt5MGMy?=
 =?utf-8?B?LzR4a2NRVXBDS3RPelU5cklQUmlXNmoybUw4L0RPbklBWGVKb1pHV0tvRzRY?=
 =?utf-8?B?VnRjVVRoRzR3WkFia0thaWNmTkhVYmNFTjVvd2R0QUI0MDl1Q3FZMXZiVE9O?=
 =?utf-8?B?UkVMNExEQXEyVjRySFRaV1BmZzEwdFZCZVMraU9xeUJkRm5uWGJEZXVLMGFa?=
 =?utf-8?B?L3NWWUFObzZNZVZ5aURBcUtxcXQvV01Lb3RVbUdRWjFLUHN1dHd3SHpJWHEv?=
 =?utf-8?B?Y1RhSnZyeEJzMjNVY1NlcU9zQ1E5N2ZjaGdFVzhvZ2h4WWVyUXEwZHlBM0JM?=
 =?utf-8?B?TzB3Qi9rTE9wR1c0WHBlNE4reEMvR040VmVkQTZZL3RGbUM1TXJMZDZZZTlF?=
 =?utf-8?B?aW1zeEczQzlhcTRMa203ZVVRMjdDOUlzTndYVmR2ck1FQkd0TWhCTEFlcVdp?=
 =?utf-8?B?S01ld3V6cmdlWG0relFlaGZ2UlJoNUtsTlNoT2F3UkUrcVpmSHc1Mms5OEhY?=
 =?utf-8?B?VngrQWNHVDVoV2dOaVAyNW8yQ1hzSDRqaWIwZ1U1aGw1aVRRTnlxcWpIa0t5?=
 =?utf-8?B?K2g0RnliTmg2d09GOUpFeWt0am5hd1hURnFrYmpPV1dHQU13U1o5Zz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3979528F5FE26B4385524A1687CE1FD2@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: bef78f77-38e9-44c0-d040-08def7a5d4de
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2026 12:41:14.6043
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y0am8zOVIBWKLoj91pzniySE9EelFxsOxr7DVtFh0FYADFaCsDAsxC4ITltYiRl5fyMzRvIe/RN6wtTZEERB3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5885

T24gTW9uLCAyMDI2LTA4LTEwIGF0IDEzOjMzIC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gTW9uLCAxMCBBdWcgMjAyNiAxMTo0MjozNiArMDAwMCBDb3NtaW4gUmF0aXUgd3JvdGU6
DQo+ID4gPiA+ICsjZGVmaW5lIGNtZChfbmFtZSwNCj4gPiA+ID4gX2V4dHJhX3N6KQkJCQkJCVwN
Cj4gPiA+ID4gwqAJCSh7CQkJCQkNCj4gPiA+ID4gCQ0KPiA+ID4gPiAJXA0KPiA+ID4gPiDCoAkJ
CXNzaXplX3Qgc3ogPQ0KPiA+ID4gPiBzaXplb2YoX25hbWUpOwkJCVwNCj4gPiA+ID4gLQkJCWJv
b2wgbWF0Y2ggPSBuID49IHN6DQo+ID4gPiA+ICYmCSFtZW1jbXAoYnVmLCBfbmFtZSwgc3opOyBc
DQo+ID4gPiA+ICsJCQlib29sIG1hdGNoID0gb2ZmID49IHN6ICsgKF9leHRyYV9zeikNCj4gPiA+
ID4gJiYJCVwNCj4gPiA+ID4gKwkJCQkhbWVtY21wKGJ1ZiwgX25hbWUsDQo+ID4gPiA+IHN6KTsJ
CVzCoCANCj4gPiA+IA0KPiA+ID4gUGxlYXNlIGRvbid0IHJlcGxhY2Ugb2ZmIGJ5IG4uwqAgDQo+
ID4gDQo+ID4gSSBhY3R1YWxseSByZXBsYWNlZCBuIGJ5IG9mZi4gRGlkIHlvdSBtZWFuICJkb24n
dCByZXBsYWNlIG4gYnkNCj4gPiBvZmYiPw0KPiANCj4gT2YgY291cnNlIQ0KPiANCj4gPiBCZWNh
dXNlIHRoZSB0d28gYXJlIGlkZW50aWNhbCBhZnRlciB0aGUgcmVjdiBlcnJvciBjaGVja2luZy4g
SQ0KPiA+IGRvbid0DQo+ID4gc2VlIHRoZSBwb2ludCBvZiBtYWludGFpbmluZyB0d28gdmFyaWFi
bGVzIHdoZW4gb25lIHN1ZmZpY2VzLg0KPiA+IEVpdGhlciBuDQo+ID4gb3Igb2ZmIGNhbiBkZXNj
cmliZSB0aGUgbnVtYmVyIG9mIGJ5dGVzIGluIGJ1Zi4gb2ZmIGlzIHN0YXRpYyBhbmQNCj4gPiBw
ZXJzaXN0cyBhY3Jvc3MgY2h1bmtzLCB3aGlsZSBuIGlzIHRlbXBvcmFyeS4NCj4gDQo+IFRoZSB2
YXJpYWJsZXMgaGF2ZSBzZW1hbnRpYyBtZWFuaW5nLCB3aGljaCBtYWtlcyBpdCBlYXNpZXIgdG8g
Zm9sbG93DQo+IHRoZSBjb2RlLg0KPiANCj4gPiBTbyB0byBjbGFyaWZ5LCBkbyB5b3Ugd2FudCB0
byBrZWVwIGJvdGg/DQo+IA0KPiBZZXMuDQoNCkknbSBzb3JyeSwgYnV0IHRoZSBjb2RlIGlzIHdy
b25nLg0KY21kKCkgbWF0Y2hlcyBvbiBuICh3aGljaCBuZXZlciBjaGFuZ2VzISkgYnV0IF9fY29u
c3VtZSgpIG9ubHkNCmRlY3JlbWVudHMgb2ZmLiBTdHJhcCBhIGxvb3Agb24gdG9wIGFuZCB0aGUg
cmVzdWx0IGlzIGp1c3QgY29uZnVzaW9uDQphbmQgYSBzb3VyY2Ugb2YgYnVncyAoZS5nLiB0aGUg
b25lIEknbSB0cnlpbmcgdG8gZml4IHdpdGggdGhpcyBwYXRjaCkuDQoNCkEgc2luZ2xlIHZhcmlh
YmxlIHNob3VsZCBiZSB1c2VkIHRvIGtlZXAgdHJhY2sgb2YgdGhlIGxlbmd0aCBvZiBkYXRhDQps
ZWZ0IHRvIHBhcnNlLg0KDQpDb3NtaW4uDQo=
