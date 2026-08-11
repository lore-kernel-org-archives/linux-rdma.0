Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013034.outbound.protection.outlook.com [40.107.201.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9699135F60E;
	Tue, 11 Aug 2026 14:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.34
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786460373; cv=fail; b=mGsq1S3acn5ykJn8X4Uv4okPCtc3m6Cx4tcTSMSSOGup8s4PwLi/6k3bIuPdMhWwT73/sREmCiaKrEt6TP5XXG/VZZpldVQBMVEpL+cFbKEBbZeg43jCSWeepw8745Znlsi8oidJR+qX9SoRhsGsDUONavHFdsLbNGA8Ndih8Bw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786460373; c=relaxed/simple;
	bh=3CgkCUgP82K2zYt8V9g/mAZpeVWdQHohYflUWuIQqgc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GjCoH1nb2SIrASSqWPC5WuG0N3z4FreH0qxS4a+k6o/wEPYSkUmUyVNicW4tcYDhwGf8s7EVjOTQjSA56mDV+X2V9QC1QP5BtsBVuAhHJMnUjI0mB4ZigQVoDbNykM0gsfgCcQ4FAcIabPYKsMC+6kTqbX2ODDmrWz+9mPm3ctY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ZpBNmDUe; arc=fail smtp.client-ip=40.107.201.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ZpBNmDUe"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y/WvOMOiyhQC6KbE3JQmLpT9xKmR7soWbYpm4GgcqHAOonzW/XqbVeZKL4t5cbKkXTRNW4UZgNj1zTwx2e8jWTMc6ovv1QOLzwZ+j5rtpkTcz2/y3F7p27Jed9AwENhP/aqc3nnSZK4dsEZghgQ3gvy+aqyD2/bQDSNXztt14cmvIPMwbnL1Y/SJrH6NIGBpbWyVJHhIx4fIv0fY2xTFeNQJqkWdrP2qgZmnFAUVJi++WnpHBkwRRv0kO2qW+clmN5ypA3VCPVa/D0YpHoKH6Eo/sdc+7JAyEyLkBBiJfbKJQ0/zqLN5SxuvuHE6n3sgDWPFvwnukVsI6i5G+7mWjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3CgkCUgP82K2zYt8V9g/mAZpeVWdQHohYflUWuIQqgc=;
 b=deyWOPnx9IHrDXGrSTuSkQ077y9zk74s6yuc2trC5VdBAYULp5TwQr9AsbTyBFzFRvRITKVMc2yqpdML/JDDXXcL+UEqJh12pVLW6oNYJ8KGT6vRG45a+DR7+VelnYKYabxJ0jO1QupMCKzfumSMYygWjT66mpStmjxlwL9ZvA52t0qfUC4ZRGYRmMV5xcmmkBfa5mAFKb/Nkx6Esgbc9kCxHktYxgv5law/29druKsGQNZcXXZwEIXdiGs5ZIuRkJv7SvupRshTF5fA3T5+WQrzRN7/8YYY+ho9wR2vwxuuJEoKs+uFNOezjbbnVP2i5bEu8cz/ZqVZDlVYRDM5bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3CgkCUgP82K2zYt8V9g/mAZpeVWdQHohYflUWuIQqgc=;
 b=ZpBNmDUeS/i9ihi2PHw392JsoQ1yXabg1mjNIJ4ma6J8fq5U0H35EY+7fvZtXS61329kurpaSmTAN6do7vXtfqiCFEAYZzVsXSuE3mNka9saCBWJdynmMwE/aPOfvFb6LxCrUEkkD9IGggf9mtFWnYOauiKNge000QHHIfqL8YsHNcp5eeIIC0FuiHX7Xn5CMPO2MFhnapbjoXZ0GEzGscOHf34JokhKvltL4Jv4LynlyKQiUmA9JI4/v8cnX0ykc5Yl9L/SPh4LGpA9iuoLDM76Q1CcXaSxDPPIfysJgtsKJ5zdaU6RNl3UVXpTT+YLdYtuydvv5TklE2aNj6z3XA==
Received: from DS5PPF266051432.namprd12.prod.outlook.com
 (2603:10b6:f:fc00::648) by SJ2PR12MB7824.namprd12.prod.outlook.com
 (2603:10b6:a03:4c4::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.12; Tue, 11 Aug
 2026 14:59:26 +0000
Received: from DS5PPF266051432.namprd12.prod.outlook.com
 ([fe80::25c9:b561:2aea:8e3c]) by DS5PPF266051432.namprd12.prod.outlook.com
 ([fe80::25c9:b561:2aea:8e3c%3]) with mapi id 15.21.0292.022; Tue, 11 Aug 2026
 14:59:26 +0000
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
Thread-Index:
 AQHdI+yn+RnS0tvdH0K/K6KpoNcjc7aTWlYAgAPYewCAAJQ6gIABDnmAgAAkTQCAAAJNAA==
Date: Tue, 11 Aug 2026 14:59:26 +0000
Message-ID: <6378f6171d10af5593be06ca5d0c63f885323ce6.camel@nvidia.com>
References: <20260804083535.2946459-1-tariqt@nvidia.com>
	 <20260804083535.2946459-13-tariqt@nvidia.com>
	 <20260807175858.70a717d6@kernel.org>
	 <51b31f2497f1c42464f803818b0e9b6cc6b9aa56.camel@nvidia.com>
	 <20260810133305.3b7448c8@kernel.org>
	 <73586539333ece6aff68ff29f7e43ceb59e7b581.camel@nvidia.com>
	 <20260811075104.0fabe360@kernel.org>
In-Reply-To: <20260811075104.0fabe360@kernel.org>
Reply-To: Cosmin Ratiu <cratiu@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS5PPF266051432:EE_|SJ2PR12MB7824:EE_
x-ms-office365-filtering-correlation-id: 053229f3-6d1f-41eb-a40b-08def7b92336
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|7416014|376014|23010399003|366016|10067099003|56012099006|4143699003|11063799006|18002099003|22082099003|38070700021;
x-microsoft-antispam-message-info:
 Ur/dFfAGPwNC+xMAKu5uDpf6xH0suRWXa7Clm3LCgIxVEYhm8ylu4sgsT3wd/kzA3ipQ/DX4xRS2LfJV7VFTStoQfW8h41QaYLQuqsWL3ttccHZcB2oM0PkYji8mhuielX778j0cUIcyrcZBk2t1U2lt8REOLsHdYJAuwS5bp/OTiIo1j/9wo/abULoAKiyKllMMALPz9nbHKlzAiA1nlCUn930oFiu2VpE68xyvAKpvSkhAQfny4+5YFw/7Mx68cycYa5HosReu1Lxy13INpYMV1YCCbaNl8LBWJw8YvDEYtWMV18W2u4PUK7mFELFFICTsWFB/5GjMT7R7uHj+MiUnOT2Aot+t1fBhRKWl1PeKfX447IeL4+Q/LSwP8pme4IibFfI+uAEj9gLpeLAIpOsIVZ70Urbr4qsM/iGND0jvttJO1q2Eb4buV/FazrEVGTue/2C7L7Wp2mc4hIpTAHxOqIYvs/OT2WoohQOibIJWMjceUpOdUfJONJ/vfFqprvsPsd5UM3XMwd2F4Nn7llC/SeUKcCIh7db80XJtdEGwmNVGOuzrBBsMeFYS0i0uqjknIRNVujwYTjtSLkyNsh5D7NHrZvBJjl9Eqi8aNqyGzLxBmtsxY8Nn63kNCvqzg27L7olYJArsDcIscudStJr3FvXagBPQwNj57AMtLNyXqQ0OmzLtcVQpi9d/Un6QvrJoh2K6lpH5LndKOP15e3nzRAhgqvoKAfgrydWQNK0=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS5PPF266051432.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(23010399003)(366016)(10067099003)(56012099006)(4143699003)(11063799006)(18002099003)(22082099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?K2xsK0JnRUVhR2diVzNrbVFvZ0JUczNYVTNaN0YzUXBvR1JwM1dxeFo1OVpL?=
 =?utf-8?B?R1VGTEZnREpIbzhick8xSWtjb29oWUJpdm4vZTBQNjFOTmV0U2RGdG5RTlN4?=
 =?utf-8?B?V0ptUVFNWTZkYnB0bzU0WGVpdjZ6dHRScnRJcldkSGVVazNYeGd5QmJNZjM2?=
 =?utf-8?B?cG9nbVFMUVhZUXF2VUNnbUdjSjdud2N5YmNtRllsd0d4QUhHdkF5VGNOYjJm?=
 =?utf-8?B?UzNZMnEveUc4ODA5NWdaYWhoYWxaYWlHTnpXUjhyMC9kOThZTk5Qb0ExZHJa?=
 =?utf-8?B?NjlNdi9Vd3E0dHI0ajk1Y1dmc3E3eVhKVENlNWE4ajBJb1lhckdNWXZBUno4?=
 =?utf-8?B?NXRFVk8rTi83emZXTytLd3c0dHpoUlJ1U1plYTdvd0JoZnpwcVJmUE5kQmtQ?=
 =?utf-8?B?aEtSVEZraTMzZjJJS1cxWmJKOVc3ZCtnNHN1OFVndVNMQVdVQzg2YnROVGdz?=
 =?utf-8?B?cjFCVmlWMFNCYUpqTFR3NzJsVlZneFI4Z21qaXBUUWJEQjcxdFcrUEM3WmJT?=
 =?utf-8?B?c3RtaFd4SjBjLzA1T3lYTmVQVG9ySmh0ZC9NSGFqTEVldDA3MWJiYXMwU0wy?=
 =?utf-8?B?M0JKNGpsTEtRWFNBQVhVUFNsWlJ0TmtldXhCdXQ1SWJ6eHY4c1BvS0Nra1dI?=
 =?utf-8?B?M2FwVnhXQjZUOEtXYm0vcEt2T2ROejdqN3ZhVy9wM2FOWlFnR1VDc2RaaGd3?=
 =?utf-8?B?eVphSld0dzhqeDBYY1lBczVwVHJ1NUwrTmtqc2xnTW5XM05YajZMTmluejFH?=
 =?utf-8?B?MTV0SW9JRmdJL2RTd2kwQnNxZ3ZOWU9QeUlKYjNYK3EyT0tkRlM0TW1udHBT?=
 =?utf-8?B?L2QycW1aUHk1TlFkV25TaDJPeDgyTnRkTkFmQzBrYTQrMGdPNlBMWE9OTjVR?=
 =?utf-8?B?ZGtNQ21UbDVIWnJSamNFbmphZzJrWTZQdEJGU0dzRWhjUzdkZkEyMThYQmpx?=
 =?utf-8?B?YkRlQ0xwc3AwMnU5OWtsOHIzczZNbERLQlorRzlITElvQTVDZVhKOEUzMzhw?=
 =?utf-8?B?SG5UdGdQQzM2dE1tZjV5UTBWRTZOenplMUx4aWpuTWthaWduek5nV2lUclh0?=
 =?utf-8?B?YXV5czZSNWdvNUVDZWd4Q2FwMUk2Vlk1NklTZ2NxdUoyd2tTa1pMalFiaTNZ?=
 =?utf-8?B?WFZxNDlHNE4rcFhzSHViaVhKVitTSDF0ejFYNDFXbExQUklvWUp2MDBUNXVZ?=
 =?utf-8?B?SlJlTHZPV3JNM1lOUUFaQU8xVTVwdUZGandIaWJwYXhEQ21rc3pYdXlEb3hw?=
 =?utf-8?B?TjBvNnZEdEg5NHA0R0tjcjJ2dWNPMWowc3E3bEswYXptNjc3RE5MMmJCWitN?=
 =?utf-8?B?SWN4QXVidk1zdjdIQnZud2s5cVdvdkZTVmNpOUtmSVR1L0hDb2FjeW43M1Bo?=
 =?utf-8?B?VjlDWHVST3JXNCtpWlN0OXYyZ3hLK2pjMFNIUElOZ0ZPUzh6VVBDMXprVzF3?=
 =?utf-8?B?OFU2N0VpaExNRWhBYXEyNGtRRWd5NllPVlJmbDdQOGhBMzJvRlUyQzFjTmhH?=
 =?utf-8?B?ZDMzbWpxV0xWNnpoaCtLblAzc3NvZ2lIUkt6WW9Ia3JwTFEvazV4MmVIZmdh?=
 =?utf-8?B?OGp3MjZRSXBUNHg4QlljKzhlazNXbzJzcFJjVGM0TU5NWHR4M3VDMHdCY1Mr?=
 =?utf-8?B?OG9UVVBKMmdZNVZZc1pVVUtIMU5NZ3VXUExoeEQ5VmFIczNWY0VjS05lYThx?=
 =?utf-8?B?ckN4VDlCVTNxRE1JSTVrTTZHSlhKQXk5eDFnTDhTQ0dTcmdqMWZJRTZxZnd0?=
 =?utf-8?B?WndWZGg4ZERGWHpUTUxkZE9sbVRmWStUNGdLSmYxVENXcHVLVXN1VFVSV1F3?=
 =?utf-8?B?RjVGcjU2SE5hNjBhZE9qN2F3YWQ0N2RYRkowNzVKNXM1RW9qbFNwcElZMHh4?=
 =?utf-8?B?RGRqSzc0QXJzTHl6OHZLUE9LTTJPT3o2K2RKMzIvanlBRjdSQjAxcUxDUmo1?=
 =?utf-8?B?RTlTUStxWlFnZDFSQzJCWllkNTRFS1pwdE9LV2Z4Rm5GK0pXR1FEeHdkVjdM?=
 =?utf-8?B?TzZQSmpmeXprN3Q1c1I0Ni8zNXZxSzVaQUJ4NmlLaVVnbHRYYzJqTWJoSDd4?=
 =?utf-8?B?UGpEcWEzWDVxcGplMFB6MllYYzFhZmg2RGMyZ0tXWS96cEJyVHNyZGFuNVZH?=
 =?utf-8?B?TFNQTjVLSFU1emFXZkEwWnVvOW9jT3BsOTZzczFsQnNja0crMDh0UHkwdmNH?=
 =?utf-8?B?Nk4wVTNpdVB5SVNacGtQb0poSXVqM1lkOXEzY3Y0SzdGMzNtalkzekx3dXlB?=
 =?utf-8?B?cWVJUWUxTGYzbzZlRXNkd0NaUURwNXVXYnNOVVRGbndMNVBMbkJ1N2UzUUJ2?=
 =?utf-8?B?OCtTbGJDUXRuT1dweDd2QS9MdlN3R0pwZlV4dkozd0hDcUJNZGRHQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CD6D315C89EDC447A4DF8059517A54B2@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 053229f3-6d1f-41eb-a40b-08def7b92336
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2026 14:59:26.4873
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l7MRcCBCKyH+zc6n/r0T1+S+Z7gKBLNWkyKqq56nm2TL1lFZmIUhTXVDpNdhIkr7NssIcLVFHGkegsAml4Ph8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7824

T24gVHVlLCAyMDI2LTA4LTExIGF0IDA3OjUxIC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVHVlLCAxMSBBdWcgMjAyNiAxMjo0MToxNCArMDAwMCBDb3NtaW4gUmF0aXUgd3JvdGU6
DQo+ID4gPiA+IEkgYWN0dWFsbHkgcmVwbGFjZWQgbiBieSBvZmYuIERpZCB5b3UgbWVhbiAiZG9u
J3QgcmVwbGFjZSBuIGJ5DQo+ID4gPiA+IG9mZiI/wqAgDQo+ID4gPiANCj4gPiA+IE9mIGNvdXJz
ZSENCj4gPiA+IMKgIA0KPiA+ID4gPiBCZWNhdXNlIHRoZSB0d28gYXJlIGlkZW50aWNhbCBhZnRl
ciB0aGUgcmVjdiBlcnJvciBjaGVja2luZy4gSQ0KPiA+ID4gPiBkb24ndA0KPiA+ID4gPiBzZWUg
dGhlIHBvaW50IG9mIG1haW50YWluaW5nIHR3byB2YXJpYWJsZXMgd2hlbiBvbmUgc3VmZmljZXMu
DQo+ID4gPiA+IEVpdGhlciBuDQo+ID4gPiA+IG9yIG9mZiBjYW4gZGVzY3JpYmUgdGhlIG51bWJl
ciBvZiBieXRlcyBpbiBidWYuIG9mZiBpcyBzdGF0aWMNCj4gPiA+ID4gYW5kDQo+ID4gPiA+IHBl
cnNpc3RzIGFjcm9zcyBjaHVua3MsIHdoaWxlIG4gaXMgdGVtcG9yYXJ5LsKgIA0KPiA+ID4gDQo+
ID4gPiBUaGUgdmFyaWFibGVzIGhhdmUgc2VtYW50aWMgbWVhbmluZywgd2hpY2ggbWFrZXMgaXQg
ZWFzaWVyIHRvDQo+ID4gPiBmb2xsb3cNCj4gPiA+IHRoZSBjb2RlLg0KPiA+ID4gwqAgDQo+ID4g
PiA+IFNvIHRvIGNsYXJpZnksIGRvIHlvdSB3YW50IHRvIGtlZXAgYm90aD/CoCANCj4gPiA+IA0K
PiA+ID4gWWVzLsKgIA0KPiA+IA0KPiA+IEknbSBzb3JyeSwgYnV0IHRoZSBjb2RlIGlzIHdyb25n
Lg0KPiA+IGNtZCgpIG1hdGNoZXMgb24gbiAod2hpY2ggbmV2ZXIgY2hhbmdlcyEpIGJ1dCBfX2Nv
bnN1bWUoKSBvbmx5DQo+ID4gZGVjcmVtZW50cyBvZmYuIFN0cmFwIGEgbG9vcCBvbiB0b3AgYW5k
IHRoZSByZXN1bHQgaXMganVzdA0KPiA+IGNvbmZ1c2lvbg0KPiA+IGFuZCBhIHNvdXJjZSBvZiBi
dWdzIChlLmcuIHRoZSBvbmUgSSdtIHRyeWluZyB0byBmaXggd2l0aCB0aGlzDQo+ID4gcGF0Y2gp
Lg0KPiA+IA0KPiA+IEEgc2luZ2xlIHZhcmlhYmxlIHNob3VsZCBiZSB1c2VkIHRvIGtlZXAgdHJh
Y2sgb2YgdGhlIGxlbmd0aCBvZg0KPiA+IGRhdGENCj4gPiBsZWZ0IHRvIHBhcnNlLg0KPiANCj4g
YW5kIGluIHlvdXIgb3BpbmlvbiB0aGF0IHZhcmlhYmxlLCB3aGljaCByZXByZXNlbnRzIHRoZSBh
bW91bnQgb2YNCj4gZGF0YQ0KPiBsZWZ0IHRvIHBhcnNlIGlzIHN1cHBvc2VkIHRvIGJlIGNhbGxl
ZCAib2ZmIiA/DQoNCiJvZmYiIGlzIGNsZWFybHkgbm90IGEgZ3JlYXQgbmFtZSwgaXQgZm9jdXNl
cyBvbiB0aGUgb2Zmc2V0IGluIHRoZQ0KYnVmZmVyIHdoZXJlIGRhdGEgc2hvdWxkIGJlIHJlY2Vp
dmVkLiBQZXJoYXBzIGl0IGNvdWxkIGJlIHJlbmFtZWQgdG8NCiJsZW4iPyBBbmQgdGhlbiBwZXJo
YXBzIEkgY2FuIHJlcGhyYXNlIHRoaXMgcGF0Y2ggYXMgIkZpeCBwc3BfcmVzcG9uZGVyDQpwYXJz
aW5nIj8NCg0KQ29zbWluLg0K
