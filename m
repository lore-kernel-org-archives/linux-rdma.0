Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012017.outbound.protection.outlook.com [40.107.209.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185B3446C00;
	Tue, 18 Aug 2026 11:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787050929; cv=fail; b=s/+6DbbZstgx7A+jWtpsv2nj9azu57UTL7wIyLIJgGd1UVeGMeRF5GDPwEBrhMAW6Za+FNfcjoCAQLfvsAmOFb1wUZUT35Ul0kqB89CjIi7SUFVWZ0+sT0ES2depMUeokelou/tA9eJKT79SpgaRiMUIw2vHNuP6YoxTS6tDjhU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787050929; c=relaxed/simple;
	bh=oMlT0O7EhHrr8Yj+NWyOYQzqIf+mKdqH/1z9bp7hJbs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VT1UJAfA5JZiSaZ3ZUkXpvszgOSzAKYKfDtCQOU2S6JN3k9KFuyGcp97lYwS8vPdkkP90hjEmAYcNM9fAmIZCJH/TR4VAbgVDF+K/WtKlhQuEYm6wJ9xh64tf7LO3zxI60lEaQVtJcIKvC54XOQBRya7TLi/H2M/kUt/6yCV3r0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Ztho8op9; arc=fail smtp.client-ip=40.107.209.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Ztho8op9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tIpPFVJZ6pwTCYLSfHvx1fWny6eaFctNUAU1Pn6o2D8EKdYcLQlc8vaTarFkjiI7STeGqy5om6kgJt+zMcq8lhoVMeeNognj44xlzgFly+9ZtN6lSEmzjAbBIzkayBXZap34VBt0OwarX55H2pAD/OLr4ZD4Je5ukqn0YnK7+E+IfPtiEknRwq9VDPizYlGEcNdswarS4dEIL+c11NEJKttZTawlGbiWD1Y+OaMDRGBcDuTzUag5cjWMNRYZz5OW/L1lL2UjAiUAoTG1QIJYBTaRCZu6QjlucSIghyY7q0nvcHqC3Yl2eMdDzccN3dC+2vvGokyCEJtCr9q10oP5dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oMlT0O7EhHrr8Yj+NWyOYQzqIf+mKdqH/1z9bp7hJbs=;
 b=w3tJfBJWFn6EGKfmaJ3vKM3zSiQ2G56b//kJhtru8nSMC/zLW9fUlqOsRf41p3oC79CDleTlG5u6QC96nHrfFFlID5WRYmUFklh43tHTC5Gv6Q0lU84633/nhQclfw8JaxqRrl8NZSkGETsW38J9ALyt0r47nPw00BviPtiBkpvPa4AMZ1WcaOea4mWeP08Re+kjMp1Vg5v1m+A5vYgz4rwBpve5lwPpVKA2GPtc/IAbhAgbbU7Dfh6Mx5dAZR1+k3fvFNu0R4V3NbbChFpSPmCwQFbHWB2ARWzqXpphkxcdS7u+HPt0tlq+boJQZajJDxvFPEpSVGp602u2AU8RPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oMlT0O7EhHrr8Yj+NWyOYQzqIf+mKdqH/1z9bp7hJbs=;
 b=Ztho8op9piOgCdDHLxdRvHFFX7OxRhgYCexYX8EWEwnfJuNcueeyFZ5esgW8Vd/xKl1k7+OfcUWkKm5TNJTtz/2GerZrnVIPeHHuR7PGCZgj/d8cZhqCpA/KvkLZ4oYQ4Hb9eW3bM3RJJMFaKP1klFMUN8fMgapOmAJwccp+qrbKkr+ybw1iRifntgphTpaoWjqbV/XQmOZN8Ys1A9WkNiYUhrhaQAkDOL0un9ZS2ohwImjxioyK0cql5hzFzlnACD0fzjXTDzWMrj1ZMLgswLjZlLudlrBwt9DG6tRkv8QMGmb+N4+qIqWnPB82AgJ3s303o07jCBKeLLsD3qmGYg==
Received: from DS0PR12MB7558.namprd12.prod.outlook.com (2603:10b6:8:133::21)
 by PH8PR12MB7110.namprd12.prod.outlook.com (2603:10b6:510:22e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Tue, 18 Aug
 2026 11:02:04 +0000
Received: from DS0PR12MB7558.namprd12.prod.outlook.com
 ([fe80::96ea:b67a:4a5b:85e0]) by DS0PR12MB7558.namprd12.prod.outlook.com
 ([fe80::96ea:b67a:4a5b:85e0%4]) with mapi id 15.21.0315.016; Tue, 18 Aug 2026
 11:02:04 +0000
From: Max Gurtovoy <mgurtovoy@nvidia.com>
To: Yehyeong Lee <yhlee@isslab.korea.ac.kr>, "sagi@grimberg.me"
	<sagi@grimberg.me>
CC: "jgg@ziepe.ca" <jgg@ziepe.ca>, "leon@kernel.org" <leon@kernel.org>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"dledford@redhat.com" <dledford@redhat.com>
Subject: RE: [PATCH] IB/iser: skip an unregistered direction on remote
 invalidation
Thread-Topic: [PATCH] IB/iser: skip an unregistered direction on remote
 invalidation
Thread-Index: AQHdK7BpZNblVtYgjEKy235l96l/WrajXQ2AgABNUUA=
Date: Tue, 18 Aug 2026 11:02:03 +0000
Message-ID:
 <DS0PR12MB7558FE82AD2039A8A4B00E57DEA62@DS0PR12MB7558.namprd12.prod.outlook.com>
References: <20260814054712.260495-1-yhlee@isslab.korea.ac.kr>
 <20260818062425.568046-1-yhlee@isslab.korea.ac.kr>
In-Reply-To: <20260818062425.568046-1-yhlee@isslab.korea.ac.kr>
Accept-Language: en-US, he-IL
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR12MB7558:EE_|PH8PR12MB7110:EE_
x-ms-office365-filtering-correlation-id: b0dc5b91-e4e7-4fbd-7eb0-08defd1822e9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|10067099003|56012099006|18002099003|22082099003|5023799004|4143699003|11063799006|38070700021;
x-microsoft-antispam-message-info:
 MsEd87Q9gQemidA2rXSLKq8IbC/M2aYPubGvokeiBUQwXNLaW+gztrIxUXdOly0gwLTXrfnZjrClekTTOklsz7PyIZpQeEzChTiYZbhHDUzm5k7uW15cwztmOchOEougRYldh5BoBLs3qkUKVKsHFMYpUBuGT5pwWajZ8a3/tm1sNhmJjv2aVyD/VHBeBSaHk31HhacbgBpG2iA3huqQQsznPDLXjITCvcFHXQELpTNQhDZVS2lHEpUYc0mzDOzSHhWFDUKph3U7A31+ebqmrn3XM6/jHWBaetr0u5CKkDRT29pp7tCOu1xENc/gCPsEYiFKXGQxrMj0HbRUWaPmvzBRN0dv3LTHlfvTi+XA2WltecnW57z3S13stztTw5MC7NXT1/uJQu3F+oi1dPJho/s3nfR8m9EEWNfzBFIAAHEhURg4bqEqO0NgBdct5lLdSuHDSMp1K0VWLa21AzksynoU31Y6PFeSbjdyRiR0dNT5F8eOHqho8G/T/IO30XZ4nzYJKWjEYt6LS1fh46h0N5OO1AttR91wQI9VObX5oOcb/ogUcE18HKWJNsfOLSL2E6kwyq6oB9XQOJCv848pxANAJXJZP8hb2D19pmRt8iapfUX/2VEY72ABDZXhur3C1MB8SApTS4NJVvBhf6lPqMZmVjWmtRrgjfhqa5jMgG2D0JXyKiyCADwQ2zJrC9HiqBqos0IqGAIIY2zP+NjdyO4caxkItkwWnSqAcU6r3uo=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7558.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(10067099003)(56012099006)(18002099003)(22082099003)(5023799004)(4143699003)(11063799006)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ek5BVmJLRnpoOEI2YUdVQjZ5ZzFkWmYxcXhha3lXeUNUSE9iYm55K0I2MWdv?=
 =?utf-8?B?Q2I3Rkc1OW43MDkybWlRd21ocURsNlRQWFNtbEllRUlLZG11aUFvOHUvdEk2?=
 =?utf-8?B?R1dJNERBTGJaQUVteTJFMkxqSm0ydDVqZUxWSndYbGY0bHFWM3l3am5HaDhC?=
 =?utf-8?B?QVVGTkVsS3I5a3ovWmhqcHREdXRXY3BEd2VXby9NbEZ0aTN5Mmc4akNmYy9Z?=
 =?utf-8?B?Y081a2M1dm1ybkkwVGwvMHdwaXVqMjhRdS9iNE14NXRrZ3RWZFJVUk5VbEpQ?=
 =?utf-8?B?TDc4STVpWGoyMG9obTVxcC8yWW1UUWZzRThZQVY5WTVOSVZYcURsRUQ3MTJP?=
 =?utf-8?B?dmpUcjJGWDFVQ2tUcW4rbllUUmR1S1BGeEp6aUliTXVDU2pBM0ptZmN1bXBw?=
 =?utf-8?B?Ylg4elc4Q3NsMkQ1amdwRFVoSWN0RU80NkFvdHU5UDdIb0JqYjFaOUhpWmQ0?=
 =?utf-8?B?czhvWjgyV2QyUEt4QitVYVZqRWlRM3NPblROamxLZlJWdE8xdHEydFJ0OFBN?=
 =?utf-8?B?MU9uK21zbGRMcEY1ZEszaTNHajFrYVJVazNnb3VLMlFQVWhhVU5tWElBYmdj?=
 =?utf-8?B?aHB6RWpNai9xbWQxMVVBRVRTLytJMXpzQ28wcVRDL3lrWGJidXFUY2RydWNv?=
 =?utf-8?B?SFN3V2o4K05HT0VoNWRNZWdKTjd6K0hZZEJOUU9TdkpmZnAxcmZGV2tLRjdH?=
 =?utf-8?B?RzJsSXc4bXVSNXJpRGh2WXdiU3h1SjVURGVxQnorbFlFZUdIb3V6M1VvdE9k?=
 =?utf-8?B?dzlqOTErMWdSUDZ6WkRleE5JK2tMSHBNZjRJcjlEUVRmaGhzYkhuVy8wSHBz?=
 =?utf-8?B?VTRKQTM1elk1MW5HaVF3UHZtM3NoUnUvZDJZd0JiTDNXd05kcitDUnV5aXNW?=
 =?utf-8?B?Wk4vVGJnTFM1aUFKMXVvMEZrQmk0Ym9tVndBeUVZbzRlYlBrMXg4akNaOHBF?=
 =?utf-8?B?ZTFvSERMTVpYQTh2Q251bG1zcGlTdWc4OHBBdlVxM0FranUybmY2Kys5c3dY?=
 =?utf-8?B?SzZuR2l5cjdwMUFOZE5ITkszeGx1cEhuRFdnbUEwZUxqRGtYV04yNW0vUUJC?=
 =?utf-8?B?VzRQNFlSZTJjMWRwckZjeXVTOHVNVEhBTmh5bElkaUYzSkZOWHpnTjlEUHRN?=
 =?utf-8?B?V1JsV3k5cnFOekRvdHRVRFIzSHJLR1YxVHdZcUNyTEpsNXEvMHIybUV1S3A4?=
 =?utf-8?B?Sk1aK3ZkUDVSaGhHU2lZUWtoVC96SG9wNVZKd21pdnF0UmRNQTJSZjM3NWRW?=
 =?utf-8?B?K3F0bkpKekhjU1Y5b0lQaTNXbDB2STNoZVhCWnVlTCs4a3U4VENXdGIySGp1?=
 =?utf-8?B?Rkd0OVJXWS9pNEJZMyt6SUxVbmNjM3pPZ2w3MjJ2SGJjS25sMGhVMGU5Wmp0?=
 =?utf-8?B?dm1wcWFGRHNVa3puMXkwTk5YRy9GTS9ITVJ3V0tVN0tmbW5aMHFrUVJpN0hU?=
 =?utf-8?B?YzVhVXUwb0JyZ2p4THpBRWJHZDJMZWZyZklZRWxoRGxjcVpXc29QNVpJOUVZ?=
 =?utf-8?B?cVp5WlVXOVl1N1Fxcjl6aDh4MThIaWc2c3p3MFVCdEFqVng4akJKcjVuMzUx?=
 =?utf-8?B?aHRQa0lXME9FZGtIbGZ5eFRtWjdZZFA4UHFNM0N2cTlibExEczhncVZtajdC?=
 =?utf-8?B?VTNZbEpBbGIyczE4Y0wrN0c0WTV2bExuem1iUXFwbC9aTDBaV2xxcVpmQlpY?=
 =?utf-8?B?SXdIcTNxYTU4cE1oTTVMYk9yZEpRS0JTUUxvMnAycFU3dGROOEN5S0tjMXcy?=
 =?utf-8?B?NHlibHcySnBQbE9QelV6Q1J5RnpwSXRnalFCYlpVemVmNHNQVEg5MUFhUG90?=
 =?utf-8?B?bzRhQjhqUzBkS3FXV1pPaU5adWRHTjdLL1RBaUd1WGNzQ0tNTnI4eXkzOGxI?=
 =?utf-8?B?ZHYrQ2M1ZHMzL2hGajZhN09MOFZwcGlidUYreVFPRG5MYVFYNnVJeG8yWjEw?=
 =?utf-8?B?RHNpS3pLd1B5Yzc4U1Q2cUYxWnVVWGlLU21yM3BnKzlrWnlLTDVhTUF2L3h0?=
 =?utf-8?B?a1hEQzNmMHJNekRkKzc5SXJkeGpqVFpCakc0NGVaLzRiaDl0bG50Sm10LzA5?=
 =?utf-8?B?RksyUGFKOXhOM245enlDVXhNcFZqNnNvVzBka0NnOE1neTRhU1BNajU3MVBt?=
 =?utf-8?B?SGxZMnBkZVJtakxvdExnVzhEcENGWmtIbEtJMFdJV2I4aXVIM1N2YlU2MldD?=
 =?utf-8?B?NmdVMmU0UFZNVWtHNUc1T0orb1kwdmVEQ3lKVFhuNkdiemQ1cEdsSHI3RCtX?=
 =?utf-8?B?WmRYWk50Uk1ONFJjTnRQREZNVkVzbXhsVTdzZmF1UUxxTkZSQWhGZ05LT2FP?=
 =?utf-8?Q?UrRPvSiXoN4kwA9mfS?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7558.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0dc5b91-e4e7-4fbd-7eb0-08defd1822e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2026 11:02:03.9438
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EiPFbQlfIWWXdCCBDlNn1dGtN+RozU+1gIOTRlf28OLEHol+s/HUbPMCVnN4mro17NuqB6LeQ71MHLJIHaBUdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7110

SU1PIGFueSBub24tY29uZm9ybWluZyB0YXJnZXQgdGhhdCBzZW5kcyBhbiB1bm5lY2Vzc2FyeSBy
ZW1vdGUgaW52YWxpZGF0aW9uIGRlc2VydmVzIGEgZHJvcHBlZCBjb25uZWN0aW9uLg0KDQpTb21l
dGhpbmcgbGlrZToNCg0Kc3RhdGljIGludCBpc2VyX2NoZWNrX3JlbW90ZV9pbnYoc3RydWN0IGlz
ZXJfY29ubiAqaXNlcl9jb25uLCBzdHJ1Y3QgaWJfd2MgKndjLA0KICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgc3RydWN0IGlzY3NpX2hkciAqaGRyKQ0KICB7DQogICAgICAgIGlmICh3
Yy0+d2NfZmxhZ3MgJiBJQl9XQ19XSVRIX0lOVkFMSURBVEUpIHsNCiAgICAgICAgICAgICAgICBz
dHJ1Y3QgaXNjc2lfdGFzayAqdGFzazsNCiAgICAgICAgICAgICAgICB1MzIgcmtleSA9IHdjLT5l
eC5pbnZhbGlkYXRlX3JrZXk7DQogIA0KICAgICAgICAgICAgICAgIGlzZXJfZGJnKCJjb25uICVw
OiByZW1vdGUgaW52YWxpZGF0aW9uIGZvciBya2V5ICUjeFxuIiwNCiAgICAgICAgICAgICAgICAg
ICAgICAgICBpc2VyX2Nvbm4sIHJrZXkpOw0KICANCiAgICAgICAgICAgICAgICBpZiAodW5saWtl
bHkoIWlzZXJfY29ubi0+c25kX3dfaW52KSkNCiAgICAgICAgICAgICAgICAgICAgICAgIGdvdG8g
YmFkX2ludjsNCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIA0KICAgICAgICAgICAg
ICAgIHRhc2sgPSBpc2NzaV9pdHRfdG9fY3Rhc2soaXNlcl9jb25uLT5pc2NzaV9jb25uLCBoZHIt
Pml0dCk7DQogICAgICAgICAgICAgICAgaWYgKGxpa2VseSh0YXNrKSkgew0KICAgICAgICAgICAg
ICAgICAgICAgICAgc3RydWN0IGlzY3NpX2lzZXJfdGFzayAqaXNlcl90YXNrID0gdGFzay0+ZGRf
ZGF0YTsNCiAgICAgICAgICAgICAgICAgICAgICAgIHN0cnVjdCBpc2VyX2ZyX2Rlc2MgKmRlc2M7
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIA0K
DQogICAgICAgICAgICAgICAgICAgICAgICBpZiAoaXNlcl90YXNrLT5kaXJbSVNFUl9ESVJfSU5d
KSB7DQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGRlc2MgPSBpc2VyX3Rhc2stPnJk
bWFfcmVnW0lTRVJfRElSX0lOXS5kZXNjOw0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICBpZiAodW5saWtlbHkoIWRlc2MpKQ0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIGdvdG8gYmFkX2ludjsNCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgaWYg
KHVubGlrZWx5KGlzZXJfaW52X2Rlc2MoZGVzYywgcmtleSkpKQ0KICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIHJldHVybiAtRUlOVkFMOw0KICAgICAgICAgICAgICAgICAg
ICAgICAgfQ0KICAgICAgICAgICAgICAgIA0KICAgICAgICAgICAgICAgICAgICAgICAgaWYgKGlz
ZXJfdGFzay0+ZGlyW0lTRVJfRElSX09VVF0pIHsgDQogICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIGRlc2MgPSBpc2VyX3Rhc2stPnJkbWFfcmVnW0lTRVJfRElSX09VVF0uZGVzYzsNCiAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgaWYgKHVubGlrZWx5KCFkZXNjKSkNCiAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBnb3RvIGJhZF9pbnY7DQogICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIGlmICh1bmxpa2VseShpc2VyX2ludl9kZXNjKGRlc2Ms
IHJrZXkpKSkNCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICByZXR1cm4g
LUVJTlZBTDsNCiAgICAgICAgICAgICAgICAgICAgICAgIH0gICAgICAgICAgICAgICANCiAgICAg
ICAgICAgICAgICB9IGVsc2UgeyAgICAgICAgDQogICAgICAgICAgICAgICAgICAgICAgICBpc2Vy
X2VycigiZmFpbGVkIHRvIGdldCB0YXNrIGZvciBpdHQ9JWRcbiIsIGhkci0+aXR0KTsNCiAgICAg
ICAgICAgICAgICAgICAgICAgIHJldHVybiAtRUlOVkFMOw0KICAgICAgICAgICAgICAgIH0gICAg
ICAgDQogICAgICAgIH0gICAgICAgICAgICAgICANCiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgDQogICAgICAgIHJldHVybiAwOyAgICAgICAgICAgICAgIA0KICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIA0KICBiYWRfaW52OiAgICAgICAgICAgICAgICAgICAg
ICANCiAgICAgICAgaXNlcl9lcnIoImNvbm4gJXA6IHVuZXhwZWN0ZWQgcmVtb3RlIGludmFsaWRh
dGlvbiwgdGVybWluYXRpbmcgY29ubmVjdGlvblxuIiwNCiAgICAgICAgICAgICAgICAgaXNlcl9j
b25uKTsgICAgDQogICAgICAgIHJldHVybiAtRVBST1RPOw0KICB9DQoNCi0tLS0tT3JpZ2luYWwg
TWVzc2FnZS0tLS0tDQpGcm9tOiBZZWh5ZW9uZyBMZWUgPHlobGVlQGlzc2xhYi5rb3JlYS5hYy5r
cj4gDQpTZW50OiBUdWVzZGF5LCAxOCBBdWd1c3QgMjAyNiA5OjI0DQpUbzogc2FnaUBncmltYmVy
Zy5tZQ0KQ2M6IFllaHllb25nIExlZSA8eWhsZWVAaXNzbGFiLmtvcmVhLmFjLmtyPjsgTWF4IEd1
cnRvdm95IDxtZ3VydG92b3lAbnZpZGlhLmNvbT47IGpnZ0B6aWVwZS5jYTsgbGVvbkBrZXJuZWwu
b3JnOyBsaW51eC1yZG1hQHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVs
Lm9yZzsgZGxlZGZvcmRAcmVkaGF0LmNvbQ0KU3ViamVjdDogUmU6IFtQQVRDSF0gSUIvaXNlcjog
c2tpcCBhbiB1bnJlZ2lzdGVyZWQgZGlyZWN0aW9uIG9uIHJlbW90ZSBpbnZhbGlkYXRpb24NCg0K
VGhlIEFJIHJldmlldyBvbiB0aGlzIHBhdGNoIGFza3MgdHdvIHRoaW5nczogd2hldGhlciBhIGJv
Z3VzIHJlbW90ZSBpbnZhbGlkYXRpb24gaXMgbm93IHNpbGVudGx5IGFjY2VwdGVkLCBhbmQgd2hl
dGhlciB0aGF0IGRlc3luY2hyb25pc2VzIHRoZSBNUiBzdGF0ZS4gIFRoZSBmaXJzdCBpcyB0cnVl
IGJ5IGRlc2lnbjsgdGhlIHNlY29uZCBkb2VzIG5vdCBoYXBwZW4uDQoNCm5lZWRfaW52YWwgbGl2
ZXMgaW4gdGhlIGliX21yIGluc2lkZSBzdHJ1Y3QgaXNlcl9mcl9kZXNjDQooaXNjc2lfaXNlci5o
OjMyMCBhbmQgOjMzMykuICBXaXRoIG5vIGRlc2NyaXB0b3IgdGhlcmUgaXMgbm8gZmxhZyB0byBj
bGVhciwgYW5kIHRoZSBjbGVhbnVwIHBhdGggYWxyZWFkeSByZXR1cm5zIGVhcmx5IG9uIHRoZSBz
YW1lIGNvbmRpdGlvbiB0aGlzIHBhdGNoIGFkZHMgLSBpc2VyX3VucmVnX21lbV9mYXN0cmVnKCkg
YXQgaXNlcl9tZW1vcnkuYzoxNTYuICBBIG5lZWRfaW52YWwgbGVmdCB0cnVlIGlzIGNsZWFyZWQg
YnkgdGhlIG5leHQgcmVnaXN0cmF0aW9uLCB3aGljaCBwb3N0cyBMT0NBTF9JTlYgYWhlYWQgb2Yg
dGhlIHJlZ2lzdHJhdGlvbiB3b3JrIHJlcXVlc3QgKGlzZXJfbWVtb3J5LmM6MzE2KS4NClRoZSBz
dGF0ZSB0aGF0IHdvdWxkIGJlIHdyb25nIGlzIG5lZWRfaW52YWwgZmFsc2Ugd2l0aCBhIGxpdmUg
TVIsIGFuZCBza2lwcGluZyBuZXZlciBjbGVhcnMgaXQuDQoNCldpdGggdGhlIGRlZmF1bHQgYWx3
YXlzX3JlZ2lzdGVyLCBkZXNjIGlzIE5VTEwgb25seSBmb3IgYSB3cml0ZSBzZW50IGVudGlyZWx5
IGFzIGltbWVkaWF0ZSBkYXRhIChpc2VyX21lbW9yeS5jOjM2NCwgaXNlcl9pbml0aWF0b3IuYzox
MDUpLCBhbmQgdGhhdCBwYXRoIGFkdmVydGlzZXMgbm8gc3RhZyAoaXNlcl9pbml0aWF0b3IuYzox
MTYpLCBzbyBhIGNvbmZvcm1pbmcgdGFyZ2V0IGhhcyBub3RoaW5nIHRvIGludmFsaWRhdGUgZm9y
IHN1Y2ggYSB0YXNrLiAgUmV0dXJuaW5nIGFuIGVycm9yIHdvdWxkIGZhaWwgdGhlIHdob2xlIGNv
bm5lY3Rpb24gKGlzZXJfaW5pdGlhdG9yLmM6NjU3KS4NCg0KVHdvIGNvcnJlY3Rpb25zIHRvIHdo
YXQgSSB3cm90ZSBlYXJsaWVyLiAgVGhlIGNsYWltIHRoYXQgcmV0dXJuaW5nIGFuIGVycm9yIHdv
dWxkIGJyZWFrIGEgYmlkaXJlY3Rpb25hbCBjb21tYW5kLCB3aGljaCBJIG1hZGUgdW5kZXIgdGhl
IC0tLSBhbmQgYWdhaW4gaW4gYSBmb2xsb3ctdXAgbm90ZSwgaXMgd3Jvbmc6IElTQ1NJX0ZMQUdf
Q01EX1JFQUQgYW5kIElTQ1NJX0ZMQUdfQ01EX1dSSVRFIGFyZSBzZXQgaW4gb25lIGlmL2Vsc2Ug
aW4gbGliaXNjc2kuYzozNjgtNDE3LCBzbyB0aGV5IGNhbm5vdCBib3RoIGJlIHNldC4gIEFuZCB0
aGUgZWlnaHQtdmVyc3VzLTEzMiBhbmQgdGVuLXZlcnN1cy10aHJlZSBjb3VudHMgaW4gdGhhdCBu
b3RlIHdlcmUgZWFjaCBmcm9tIGEgc2luZ2xlIHJ1bjsgdHdvIG90aGVyIHJ1bnMgb2YgdGhlIGVy
cm9yLXJldHVybmluZyBidWlsZCBzYXcgdGhyZWUgaW52YWxpZGF0aW9ucyBhbmQgbm8gcmVqZWN0
aW9ucy4NCg0KQmVzdCByZWdhcmRzLA0KDQpZZWh5ZW9uZyBMZWUNCg==
