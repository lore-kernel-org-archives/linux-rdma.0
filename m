Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11022115.outbound.protection.outlook.com [40.107.200.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30162218AB9;
	Thu, 13 Aug 2026 00:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.115
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786582054; cv=fail; b=jBpLYaSseWtdFz2ByYsV0k/itunsWk4+bwOlrmTemHRylVU2h4fG/3rd4GRChpWKJoUpEy5UCNnIeZAH7DPkN6VztgyVMk4w4KhPUX4dIuQ5haNYRKfxBOHSqdfJFB1f5sWitkYZcBnqdke4Vd2uVhfCXtwof4H0iFjpkw2WCXo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786582054; c=relaxed/simple;
	bh=OwgcJWE8zk9kR8bLDFUgS76cJha+j8IS1OwAzhJu2Rk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UexeA5sOQF9CMONzZlNF6AWKH3Sh0dGcQ61fEbUFClRnW2I78NyrYCCVuXzLw/ZZ0/fHt1Kr9Bct23hkoBtS0MVyCzwyoI1/xM1xZ9EYe4YL0wgg1u88c1bjkguNY2Yz/1K2I++n1TWqguqJe0mAqmvXYKMcI/HnN8DN2c/4Jmo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=eRGXSLRv; arc=fail smtp.client-ip=40.107.200.115
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="eRGXSLRv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kyNQap1ZYHCmHk8Jd8F4DoaM646RwjPsONHHodljba742ie3rMZ1YlAIchRg6Teizv2mM5p5C252O7hySoUzWFaapWR/LpDJeY9TyPmei7sXpgETK54CmUYg++Un9juJtKw9GJ3y1WE8Z31eObVDE2RBOMCL9rwPMudWypKDhUlDi+I+jHMt3iZ/dAXDDFZPe6sE5Kl3XA0FjbjLP14oBOG5QMMTZJExHbJ2FN02cjMPaIVviG7OxfNNh+sdV+IftRL07E030Ahq8zJvhEoo/3BdZRE7325dAk8zu17fTc6r66I9Ywsr3cBZQYUB+rmI95D0aD/NBnzJH5qota7u9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OwgcJWE8zk9kR8bLDFUgS76cJha+j8IS1OwAzhJu2Rk=;
 b=OR+pxauqLGdZCXGKXdGuoD2fhL+FewwzNjLM1A5o6nQsWA2T53Dcw9Mu0qT9LaPfRv4wdNpUAukJfZbAaTz7QyMbSQ8lGZ3GJaz7XGIQPbhPD/U27q+L7Nuu3kLkBcYmxFVHoMQ4wjedPPb0xjscaot75iaGCuEPVUtq2ppComJtHlC8Zoc/bVof4O8mHSLrmWcafxPp4+JSzLAt67F/7j6FWdHCZByZ+lUjbz5lWzbvSQ3ARrnKhKe7nXc3N5O4beVFbLYswFInSCHCzpBtGifvoBl5Y0/SwxB5Y5TwhsWZApWIqcLAjmghLDm+JAW9JJE4gzMnbg/arIU/sOe4Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OwgcJWE8zk9kR8bLDFUgS76cJha+j8IS1OwAzhJu2Rk=;
 b=eRGXSLRv2qbRJ36dpmWoLGjzFjJhPdwllRdPTfaW5pQ8AuvBuqHyR+iypZSTP9/TqaWBWPgi6me4qbCgSZXMxXIVPCZU4TSk8XaxePLeD34l/o5zZ11l30giFW7xXWfhU5xOpqaWapIOc93/6LxAcczGERXtLsuhoyGbqZKHq8g=
Received: from SA1PR21MB6683.namprd21.prod.outlook.com (2603:10b6:806:4a4::6)
 by SA1PR21MB6728.namprd21.prod.outlook.com (2603:10b6:806:4a4::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.9; Thu, 13 Aug
 2026 00:47:29 +0000
Received: from SA1PR21MB6683.namprd21.prod.outlook.com
 ([fe80::8bad:6294:8a07:fe18]) by SA1PR21MB6683.namprd21.prod.outlook.com
 ([fe80::8bad:6294:8a07:fe18%6]) with mapi id 15.21.0315.008; Thu, 13 Aug 2026
 00:47:29 +0000
From: Long Li <longli@microsoft.com>
To: Jakub Kicinski <kuba@kernel.org>
CC: Konstantin Taranov <kotaranov@microsoft.com>, "davem@davemloft.net"
	<davem@davemloft.net>, "pabeni@redhat.com" <pabeni@redhat.com>,
	"edumazet@google.com" <edumazet@google.com>, "andrew+netdev@lunn.ch"
	<andrew+netdev@lunn.ch>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "leon@kernel.org"
	<leon@kernel.org>, Haiyang Zhang <haiyangz@microsoft.com>, KY Srinivasan
	<kys@microsoft.com>, "wei.liu@kernel.org" <wei.liu@kernel.org>, Dexuan Cui
	<DECUI@microsoft.com>, "shradhagupta@linux.microsoft.com"
	<shradhagupta@linux.microsoft.com>, "horms@kernel.org" <horms@kernel.org>,
	"ernis@linux.microsoft.com" <ernis@linux.microsoft.com>,
	"stephen@networkplumber.org" <stephen@networkplumber.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXTERNAL] Re: [PATCH net v6 2/7] net: mana: fix HWC RQ/SQ buffer
 size swap
Thread-Topic: [EXTERNAL] Re: [PATCH net v6 2/7] net: mana: fix HWC RQ/SQ
 buffer size swap
Thread-Index: AQHdKTqOHahuUwgaLU+uobHaOwIYsLabFz0AgAAMFhA=
Date: Thu, 13 Aug 2026 00:47:29 +0000
Message-ID:
 <SA1PR21MB6683A97F47F3E2D73B1D87B9CEDB2@SA1PR21MB6683.namprd21.prod.outlook.com>
References: <20260811023823.2391255-3-longli@microsoft.com>
 <20260812234652.2193454-1-kuba@kernel.org>
In-Reply-To: <20260812234652.2193454-1-kuba@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=466a521f-6886-4abb-bc25-79950f44d72e;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-08-13T00:30:07Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR21MB6683:EE_|SA1PR21MB6728:EE_
x-ms-office365-filtering-correlation-id: 9e630ffb-7277-46e0-1d6e-08def8d473bc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|7416014|23010399003|376014|18002099003|22082099003|4143699003|5023799004|3023799007|11063799006|38070700021|56012099006|6133799003|7146999003|10067099003;
x-microsoft-antispam-message-info:
 wFM1m0gA/p5i0dJkpAKJbC+cCflvwrz+yKPi1rHsHnu37IPtU5Og+02jz6lhDX3M1GhWL9YV32JdKXC77Zc6AstW9+aud/rScGYLQKnoAcpC2PgZh6unAbdqQTej3f1EQ6Vx2uSiF8mXUJ8rPBcQBlLoPnHiJTEOmcJ54YBI6fI3eKdG6RlettzQJrq60HE2xxTpkn91OVdIvl2h+7AEHTn3bHiDfgsH4Itwhiu1giZh31lXHkiVUu7XlqjDPY6GLU72g5tleRzFFwLI1bYytLXeGpbnZvNdqBikWmKi8mQGbzGjyHf9Bl6IgKlVXXQD+86RJPjXd5OkaCf4Do/rhlp7kY1SiSwvGUftesFEAhrt6eRgE2J2/KKja5qz2FTP+xGA4WCnEo94Z3QEYVQU28IwEZM85ASijh61VTbF6tE/vgormrhlHfWsIuCgdd1OaF1m8LRqDgT8rU37037ME+ZbNF1GFCwPU8fS/AdobUaS08B/B3c2v3+bspTBXWBpoZxH0ecyOdY1CmDyqn+ZAGdEVGyDigIVHyPqyO8yXx1UPP9pXgyU6cifK3WDaZ8Z58DSOJf8dWpWqE45vdA+UIrR2SVSHrW3/XzTZweE6bfV69HRZaMi9EDeD0V9drC5zM8qb27u4l2XOVAxtVgoHs50JYisK6i8D2R7z/hcLNk0v6CFlHbaI5vpHonmhUZvomgpUzhMNhEgh5ZdRQcV7w==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB6683.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(23010399003)(376014)(18002099003)(22082099003)(4143699003)(5023799004)(3023799007)(11063799006)(38070700021)(56012099006)(6133799003)(7146999003)(10067099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Y0FkNW9DUUMvT2JxRnhaVmNRQmdOMmZjT1o2eHVKUG0zN1JUQ21LWGtSTFkv?=
 =?utf-8?B?MW9UWHF2UGNkWlVnb0lTaUxvcXJvUld3N3lrc2VWSVFnV3J4S2hHdzVCUWtS?=
 =?utf-8?B?TW5rZDlNNmhKYXRsRGd2eFM1ZDdzUkFWbUdNSVJwRXBPWFNhcEVHUnFWL05M?=
 =?utf-8?B?U1VMMmI4ZkxrZzRqN09wTW03OXJocFpJZjFrOGN1ZGhCUkowS053MHBhVlBM?=
 =?utf-8?B?OHNqcTdNSVlkSldHT0tuTHpWS1VJMUFXWENmejIzNVJpcnpzaDc4ZmQ0Ny9O?=
 =?utf-8?B?Yk1yR1E4SENUYUZSQld6SGU4VThNaXhFMkFFVEdNZU1aZnZNTVczaytCc09o?=
 =?utf-8?B?aVdnWkVhQVIzZXc1QnIxVzF3dS9tb1gxMTM4bStlaXI4UmdQdjVwK3RUZW5a?=
 =?utf-8?B?QmtEcHBGbmNyRkx0QTlaN1d1cmFlZUhRK0l3OURMMVJTdHBIT1VtVjUvRVpo?=
 =?utf-8?B?QUJnVlR1TlIyay9JQmRpeFhSODhGMlZSMTB2Unp5aGgrdEVZcWF1alZ5eFVN?=
 =?utf-8?B?QUs5VzFlQ0MzVGxNNk5WdVBibXJTY1k1dC9vZmhiVHRpWDl2a0tLSjh3TWpG?=
 =?utf-8?B?NGtIcmpkVkdCdm5IOU9LZjErNzd2emZNRjlOWXlSU2syWG80cUV4SHV6TGxP?=
 =?utf-8?B?VkVzL21rZk1maHRlNkMxUGJVc1FzaWlub1NjUDJPYm9Fd0pkd1dKVWRZVG1l?=
 =?utf-8?B?alZkTUtVaGc1cTFhc1NndGM5Y0ltSG9CZ0VFUVQveTRYN280L081QmliSUdH?=
 =?utf-8?B?MDQwQ0lmWG55RERXOWp6cjFoQVRERUo4OHdyTHI3Mk00aFJxU0dwRjZTdlVh?=
 =?utf-8?B?b1JHT2VsMGlaU1JBdEJpUm5KWjB6REhDaHBSTXNYVU92eEZnWHdHQjJzYVFU?=
 =?utf-8?B?MWNHVmwwclEyZERnVi9BU0tDK21IK0VoMTNMQ3NXK0ZtZElPcUdLMld4VUwz?=
 =?utf-8?B?YTVhSVQyaGNGTzZlUWFmQitzc0NGaXVyUVJBcFpWNzlqV0dzMTJXNkJVWHo4?=
 =?utf-8?B?dEYyM3RYMktPMXFFL1ZsUXdUYXF5ZTZsUGdxN2F0SHdIMUM2RW1PbW9Vc2E3?=
 =?utf-8?B?bVBQa0xLTkQydHd0b2ZVZWk4N0k0Zi9RNS9FL25SUUtPQlJjUXhUV3lsbkpJ?=
 =?utf-8?B?R0FiMTBuK1VIY2l1RkUzQWs4RXM1VXpvWDdhYjROUVBKVStDVTF5QkI4T1da?=
 =?utf-8?B?NFZYMmRWa3BmQnBmVTd3Y2FOS3FKUEo3Y1FZZVZkbFE3Q04vdHNHSVIyZlJ6?=
 =?utf-8?B?L0pabnYvMnBCbmNubzNSeGZDQll1eDhkSkczcVljeXR4TDA1YllBdzZnYldy?=
 =?utf-8?B?Rkt5Tm5qUUlWa0EvZGFnQmUzNWpJN092TVJ0MmE5NzlHS2h5clVMZ1hJelcr?=
 =?utf-8?B?a3p3TU9SQVAvdnAvcVRuSzRGSXVPQklKL0tTQzRITU5TRDV5YlJzRVZSVTVP?=
 =?utf-8?B?dklDbTBSUDlPdjNVN2h2VkV3K1oxZlozRFhVYjFFTmZ0ckY5TFRhbTRvUXF2?=
 =?utf-8?B?Y3VlMlpHdXdyeStUU1lSOERwSmMrZ0JGV3N0UUpNM3FKSldKNjMwRFc4RXZC?=
 =?utf-8?B?ZTNLdlJSRUVuZ1kvNEVsbFJZcXlWejRZVHpuWlQxTlNMcElJQjhIYzFnMEc5?=
 =?utf-8?B?OU9kODhETSsvR0pMeU5hVTZ1Q2VXVUNPZkcyOHQ1OXp5ZHVXQng5OEVNWSth?=
 =?utf-8?B?MnBFdEtxRndDZ3V0dlRKQzd5aUllYlJTWkVHWVo2K3A5bWhpZUhHd05za2VD?=
 =?utf-8?B?bTBiWkNuZU1Sb2poSjFURER0bzdqaWFKbnNQcWJFYXFpaXFYT2xiZVMzTFRh?=
 =?utf-8?B?K3MzWEhkeVlWTGk3OVduZFAvalV3ZWs2WXlKYTRvK1hGYUxrRlpWR2wwaVlT?=
 =?utf-8?B?cHBYS2dqZCtSMUF4elpGU2RTaWNFalVtc0gvbGtnTW5zbk8xUlY3VEE1bDFG?=
 =?utf-8?B?QlBqMHNjaDNZKy9idzFxbW51QW9Ea2lkV0NiWDRUZERZRFY5bk5qNU5EUHBE?=
 =?utf-8?B?cDNwemp1dENJdHl0dmFMMERUbFRGODZSckVnTnQ2YWdFcUpRUnZpOGlvcGI0?=
 =?utf-8?B?U3drcTVzakpMR0ttTlh4TGR3eGczb3FNOVdLS1k0TjBkZ1duSHVFajlqeE9l?=
 =?utf-8?B?cFQvOFhNUmVVVENKREI0T2VpbGJkRkpOYm9aQUljSXg3cVVQYzlQbFNEektp?=
 =?utf-8?B?a1ZFV05NZjQxNTh3UW9XQk0zRXcwQUtqOTVkR0R5bG9FYWEvUkNoQ2ZMSGJa?=
 =?utf-8?B?TmxxUjgwamd2Y29zZzR6THpRWFA1cHNPcnNVYVdxWnpzZm1zVVpiWElRT2JN?=
 =?utf-8?Q?EBE6e/2RH6GcvmDnfg?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR21MB6683.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e630ffb-7277-46e0-1d6e-08def8d473bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2026 00:47:29.1251
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZuDDgtHoA6OTznBDa1k7pID5217GMoJpVzQcXBvjj74mIxExuDkxGIASuXHjlbDRGFLNO8PSrqcSEYWLsRtYeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR21MB6728

PiANCj4gVGhpcyBpcyBhbiBBSS1nZW5lcmF0ZWQgcmV2aWV3IG9mIHlvdXIgcGF0Y2guIFRoZSBo
dW1hbiBzZW5kaW5nIHRoaXMgZW1haWwgaGFzDQo+IGNvbnNpZGVyZWQgdGhlIEFJIHJldmlldyB2
YWxpZCwgb3IgYXQgbGVhc3QgcGxhdXNpYmxlLg0KPiAtLS0NCj4gbmV0OiBtYW5hOiBmaXggSFdD
IFJRL1NRIGJ1ZmZlciBzaXplIHN3YXANCj4gDQo+IFRoZSBwYXRjaCBzd2FwcyB0aGUgbWVzc2Fn
ZSBzaXplcyB1c2VkIHRvIGFsbG9jYXRlIHRoZSBIV0MgUlEgYW5kIFNRIHNvIHRoZQ0KPiBSUSAo
d2hpY2ggcmVjZWl2ZXMgcmVzcG9uc2VzKSBpcyBzaXplZCBieSBtYXhfcmVzcF9tc2dfc2l6ZSBh
bmQgdGhlIFNRDQo+ICh3aGljaCBzZW5kcyByZXF1ZXN0cykgYnkgbWF4X3JlcV9tc2dfc2l6ZS4g
IEl0IGFsc28gc3RvcmVzDQo+IG1heF9yZXNwX21zZ19zaXplIGluIHN0cnVjdCBod19jaGFubmVs
X2NvbnRleHQgYW5kIHVzZXMgaXQgYXMgdGhlIFJYIHNsb3QNCj4gc3RyaWRlIGluIG1hbmFfaHdj
X3J4X2V2ZW50X2hhbmRsZXIoKS4gIFRoZSBjb21taXQgbWVzc2FnZSBub3RlcyBib3RoDQo+IHNp
emVzIGFyZSAweDEwMDAgdG9kYXksIHNvIHRoZSBwcmV2aW91cyBzd2FwIGhhZCBubyBvYnNlcnZh
YmxlIGVmZmVjdC4NCj4gDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21p
Y3Jvc29mdC9tYW5hL2h3X2NoYW5uZWwuYw0KPiA+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWlj
cm9zb2Z0L21hbmEvaHdfY2hhbm5lbC5jDQo+ID4gaW5kZXggNDA5ZTIwY2FlY2NkYy4uM2YwMTFl
YmJlN2IzZSAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9taWNyb3NvZnQv
bWFuYS9od19jaGFubmVsLmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9taWNyb3Nv
ZnQvbWFuYS9od19jaGFubmVsLmMNCj4gDQo+IFsgLi4uIF0NCj4gDQo+ID4gQEAgLTczMywxNCAr
NzMzLDE0IEBAIHN0YXRpYyBpbnQgbWFuYV9od2NfaW5pdF9xdWV1ZXMoc3RydWN0DQo+IGh3X2No
YW5uZWxfY29udGV4dCAqaHdjLCB1MTYgcV9kZXB0aCwNCj4gPiAgCQlnb3RvIG91dDsNCj4gPiAg
CX0NCj4gPg0KPiA+IC0JZXJyID0gbWFuYV9od2NfY3JlYXRlX3dxKGh3YywgR0RNQV9SUSwgcV9k
ZXB0aCwNCj4gbWF4X3JlcV9tc2dfc2l6ZSwNCj4gPiArCWVyciA9IG1hbmFfaHdjX2NyZWF0ZV93
cShod2MsIEdETUFfUlEsIHFfZGVwdGgsDQo+IG1heF9yZXNwX21zZ19zaXplLA0KPiA+ICAJCQkJ
IGh3Yy0+Y3EsICZod2MtPnJ4cSk7DQo+ID4gIAlpZiAoZXJyKSB7DQo+ID4gIAkJZGV2X2Vyciho
d2MtPmRldiwgIkZhaWxlZCB0byBjcmVhdGUgSFdDIFJROiAlZFxuIiwgZXJyKTsNCj4gPiAgCQln
b3RvIG91dDsNCj4gPiAgCX0NCj4gPg0KPiA+IC0JZXJyID0gbWFuYV9od2NfY3JlYXRlX3dxKGh3
YywgR0RNQV9TUSwgcV9kZXB0aCwNCj4gbWF4X3Jlc3BfbXNnX3NpemUsDQo+ID4gKwllcnIgPSBt
YW5hX2h3Y19jcmVhdGVfd3EoaHdjLCBHRE1BX1NRLCBxX2RlcHRoLA0KPiBtYXhfcmVxX21zZ19z
aXplLA0KPiA+ICAJCQkJIGh3Yy0+Y3EsICZod2MtPnR4cSk7DQo+ID4gIAlpZiAoZXJyKSB7DQo+
ID4gIAkJZGV2X2Vycihod2MtPmRldiwgIkZhaWxlZCB0byBjcmVhdGUgSFdDIFNROiAlZFxuIiwg
ZXJyKTsgQEANCj4gLTc0OSw2DQo+ID4gKzc0OSw3IEBAIHN0YXRpYyBpbnQgbWFuYV9od2NfaW5p
dF9xdWV1ZXMoc3RydWN0IGh3X2NoYW5uZWxfY29udGV4dA0KPiA+ICpod2MsIHUxNiBxX2RlcHRo
LA0KPiA+DQo+ID4gIAlod2MtPm51bV9pbmZsaWdodF9tc2cgPSBxX2RlcHRoOw0KPiA+ICAJaHdj
LT5tYXhfcmVxX21zZ19zaXplID0gbWF4X3JlcV9tc2dfc2l6ZTsNCj4gPiArCWh3Yy0+bWF4X3Jl
c3BfbXNnX3NpemUgPSBtYXhfcmVzcF9tc2dfc2l6ZTsNCj4gDQo+IFtTZXZlcml0eTogTWVkaXVt
XQ0KPiBUaGlzIGlzbid0IGEgYnVnIGludHJvZHVjZWQgYnkgdGhpcyBwYXRjaCwgYnV0IHdoaWxl
IGxvb2tpbmcgYXQgaG93IHRoZXNlIHR3bw0KPiBmaWVsZHMgYXJlIHByb2R1Y2VkIGFuZCBjb25z
dW1lZCwgdGhlIGhhcmR3YXJlLXJlcG9ydGVkIHNpemVzIGFwcGVhciB0byBiZQ0KPiBkZWFkOiBp
cyB0aGUgbmVnb3RpYXRlZC1zaXplIGhhbGYgb2YgdGhpcyBpbnRlcmZhY2Ugc3RpbGwgZXhwZWN0
ZWQgdG8gZG8NCj4gc29tZXRoaW5nPw0KPiANCj4gbWFuYV9od2NfZXN0YWJsaXNoX2NoYW5uZWwo
KSBoYW5kcyB0aGUgZGV2aWNlLXJlcG9ydGVkIHZhbHVlcyBiYWNrIHRvIGl0cw0KPiBjYWxsZXI6
DQo+IA0KPiAJKnFfZGVwdGggPSBod2MtPmh3Y19pbml0X3FfZGVwdGhfbWF4Ow0KPiAJKm1heF9y
ZXFfbXNnX3NpemUgPSBod2MtPmh3Y19pbml0X21heF9yZXFfbXNnX3NpemU7DQo+IAkqbWF4X3Jl
c3BfbXNnX3NpemUgPSBod2MtPmh3Y19pbml0X21heF9yZXNwX21zZ19zaXplOw0KPiANCj4gYW5k
IG1hbmFfaHdjX2NyZWF0ZV9jaGFubmVsKCkgZm9yd2FyZHMgdGhlbToNCj4gDQo+IAllcnIgPSBt
YW5hX2h3Y190ZXN0X2NoYW5uZWwoZ2MtPmh3Yy5kcml2ZXJfZGF0YSwNCj4gDQo+IEhXX0NIQU5O
RUxfVkZfQk9PVFNUUkFQX1FVRVVFX0RFUFRILA0KPiAJCQkJICAgIG1heF9yZXFfbXNnX3NpemUs
IG1heF9yZXNwX21zZ19zaXplKTsNCj4gDQo+IGJ1dCB0aGUgYm9keSBvZiBtYW5hX2h3Y190ZXN0
X2NoYW5uZWwoKSByZWZlcmVuY2VzIG5laXRoZXINCj4gbWF4X3JlcV9tc2dfc2l6ZSBub3IgbWF4
X3Jlc3BfbXNnX3NpemUsIGFuZCBub3RoaW5nIGVsc2UgYXBwbGllcyB0aGVtIHRvDQo+IHRoZSBh
bHJlYWR5LWNyZWF0ZWQgcXVldWVzIG9yIHRvIGh3X2NoYW5uZWxfY29udGV4dC4gIFNvIHRoZSBm
aWVsZHMgc2V0IGhlcmUgaW4NCj4gbWFuYV9od2NfaW5pdF9xdWV1ZXMoKSBwZXJtYW5lbnRseSBo
b2xkIHRoZSBib290c3RyYXAgY29uc3RhbnRzDQo+IEhXX0NIQU5ORUxfTUFYX1JFUVVFU1RfU0la
RSAvIEhXX0NIQU5ORUxfTUFYX1JFU1BPTlNFX1NJWkUNCj4gKGJvdGggMHgxMDAwKSwgd2hpY2gg
bWF0Y2hlcyB0aGUgY29tbWl0IG1lc3NhZ2UuDQo+IA0KPiBUd28gcGVlciBjb25zdW1lcnMgZG8g
cmVhZCBod2MtPm1heF9yZXFfbXNnX3NpemUgYXMgaWYgaXQgd2VyZSB0aGUNCj4gaGFyZHdhcmUt
bmVnb3RpYXRlZCByZXF1ZXN0IGJvdW5kLiAgbWFuYV9nZF9jcmVhdGVfZG1hX3JlZ2lvbigpIGlu
DQo+IGdkbWFfbWFpbi5jIHVzZXMgaXQgdG8gcmVqZWN0IG92ZXJzaXplZCBjb21tYW5kczoNCj4g
DQo+IAlpZiAocmVxX21zZ19zaXplID4gaHdjLT5tYXhfcmVxX21zZ19zaXplKQ0KPiAJCXJldHVy
biAtRUlOVkFMOw0KPiANCj4gYW5kIG1hbmFfaWJfZ2RfY3JlYXRlX2RtYV9yZWdpb24oKSBpbiBk
cml2ZXJzL2luZmluaWJhbmQvaHcvbWFuYS9tYWluLmMNCj4gc2l6ZXMgYm90aCBpdHMgcmVxdWVz
dCBidWZmZXIgYW5kIGl0cyBwYWdlLWxpc3QgY2FwYWNpdHkgZnJvbSBpdDoNCj4gDQo+IAltYXhf
cGdzX2NyZWF0ZV9jbWQgPQ0KPiAJCShod2MtPm1heF9yZXFfbXNnX3NpemUgLSBzaXplb2YoKmNy
ZWF0ZV9yZXEpKSAvIHNpemVvZih1NjQpOw0KPiAJLi4uDQo+IAlyZXF1ZXN0X2J1ZiA9IGt6YWxs
b2MoaHdjLT5tYXhfcmVxX21zZ19zaXplLCBHRlBfS0VSTkVMKTsNCj4gDQo+IElmIGEgZGV2aWNl
IGV2ZXIgcmVwb3J0ZWQgSFdDX0lOSVRfREFUQV9NQVhfUkVRVUVTVCBzbWFsbGVyIHRoYW4gMHgx
MDAwDQo+IChyZWNvcmRlZCBpbnRvIGh3Yy0+aHdjX2luaXRfbWF4X3JlcV9tc2dfc2l6ZSBieQ0K
PiBtYW5hX2h3Y19pbml0X2V2ZW50X2hhbmRsZXIoKSksIHdvdWxkIHRob3NlIGNhbGxlcnMga2Vl
cCBidWlsZGluZyB1cCB0byA0S0INCj4gY29tbWFuZHMgdGhhdCB0aGUgaGFyZHdhcmUgdGhlbiBy
ZWplY3RzLCBhbmQgd291bGQgYSBsYXJnZXIgcmVwb3J0ZWQgdmFsdWUNCj4gc2ltcGx5IGJlIGln
bm9yZWQ/ICBUaGVyZSBpcyBubyBtZW1vcnktc2FmZXR5IGNvbnNlcXVlbmNlIHRvZGF5IHNpbmNl
IHRoZQ0KPiBTUSBidWZmZXIgYW5kIHRoYXQgYm91bmQgYXJlIHRoZSBzYW1lIDB4MTAwMCB2YWx1
ZSBhZnRlciB0aGlzIHBhdGNoLCBidXQNCj4gd291bGQgaXQgYmUgd29ydGggZWl0aGVyIGFwcGx5
aW5nIHRoZSByZXBvcnRlZCBzaXplcyBvciBkcm9wcGluZyB0aGUgdW51c2VkDQo+IG1hbmFfaHdj
X3Rlc3RfY2hhbm5lbCgpIHBhcmFtZXRlcnM/DQoNClRoYW5rcy4gWW91J3JlIHJpZ2h0LCBhbmQg
aXQncyBwcmUtZXhpc3Rpbmcg4oCUIHRoaXMgcGF0Y2ggb25seSBmaXhlcyB3aGljaCBvZiB0aGUg
dHdvICh0b2RheSBlcXVhbCkgc2l6ZXMgbWFwcyB0byB0aGUgUlEgdnMgU1EgYW5kIHRoZSBSWCBz
bG90IHN0cmlkZS4NCg0KwqBod2MtPm1heF9yZXFfbXNnX3NpemXCoCAvIMKgaHdjLT5tYXhfcmVz
cF9tc2dfc2l6ZcKgIGFyZSBzZXQgZnJvbSB0aGUgYm9vdHN0cmFwIGNvbnN0YW50czogwqBtYW5h
X2h3Y19jcmVhdGVfY2hhbm5lbCgpwqAgY2FsbHMgwqBtYW5hX2h3Y19pbml0X3F1ZXVlcygpwqAg
d2l0aCDCoEhXX0NIQU5ORUxfTUFYX1JFUVVFU1RfU0laRcKgIC8gwqBIV19DSEFOTkVMX01BWF9S
RVNQT05TRV9TSVpFwqAgKGJvdGggMHgxMDAwKS4gVGhlIGRldmljZS1yZXBvcnRlZCB2YWx1ZXMg
ZnJvbSDCoG1hbmFfaHdjX2VzdGFibGlzaF9jaGFubmVsKCnCoCBvbmx5IHJlYWNoIMKgbWFuYV9o
d2NfdGVzdF9jaGFubmVsKCnCoCwgd2hpY2ggaWdub3JlcyB0aGVtLCBzbyB0aGUgY29uc3VtZXJz
IHlvdSBmb3VuZCB1c2UgdGhlIDB4MTAwMCBjb25zdGFudC4gV2l0aCBib3RoIGVxdWFsIHRoZXJl
J3Mgbm8gbWVtb3J5LXNhZmV0eSBjb25zZXF1ZW5jZTsgYSBzbWFsbGVyIHJlcG9ydGVkIHNpemUg
d291bGQgZ2V0IGNvbW1hbmRzIHJlamVjdGVkIGJ5IHRoZSBkZXZpY2UsIGEgbGFyZ2VyIG9uZSB3
b3VsZCBiZSBjYXBwZWQgY29uc2VydmF0aXZlbHkg4oCUIG5laXRoZXIgaXMgcmVhY2hhYmxlIG9u
IGN1cnJlbnQgZmlybXdhcmUuDQoNCkknZCByYXRoZXIgbm90IGZpeCB0aGlzIGluIHRoaXMgc2Vy
aWVzOiBmZWVkaW5nIHRoZSByZXBvcnRlZCBzaXplcyBiYWNrIGlzIGEgcnVudGltZSBiZWhhdmlv
dXIgY2hhbmdlIHRoYXQgbmVlZHMgaXRzIG93biBqdXN0aWZpY2F0aW9uIGFuZCB0ZXN0aW5nLCBh
bmQgdGhpcyBzZXJpZXMgaXMgc2NvcGVkIHRvIHRoZSByZWxpYWJpbGl0eSBmaXhlcy4gSXQncyBh
IGdvb2QgY2FuZGlkYXRlIGZvciBhIHNlcGFyYXRlIHBhdGNoLg0KDQpMb25nDQo=
