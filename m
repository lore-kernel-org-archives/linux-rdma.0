Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010027.outbound.protection.outlook.com [52.101.193.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 518AE35B136
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 18:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792090667; cv=fail; b=tkMVGfHzXWCXJLSRFTCU6LNKj2SLjln9CVro6lBHmb5U/Pbi5yTqqRaoURvxSpvUqL5ZTvhaH0ashV5wCs2rK2acno6SLIU2zkrNWEI4K6ZRdfKoB0vo3p9L5hl92IHK0ZHCheZ1jFheuAmV/WzMOAOZ46xVrL0yclOTo6BRZjE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792090667; c=relaxed/simple;
	bh=Ry7u65ccCG5CIzQYimOJkUTgOM6zrtmBNaHY7jvk0hg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sFvihNs7sOe75GRiWbn+/rHMbObnZMsVtBRBT/uIojMssRugEnzcDARV0IJ5+E/82mfa2oAz4IvjGu4adHpUTGbhudMp4jPbF3R7rWlXbAqUb2y0k84khxFh0yAR4blgMB0/HBV4NL4lCgYDR2mREOgW1fEjDsplyUlyqTlCE/c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BpoPFY9B; arc=fail smtp.client-ip=52.101.193.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BpoPFY9B"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dv1sGg8ahqcQkVWSpUwMfSGfQ2gR+8VcrRlhXA2OU4L8slpCEPaZuiP6o+Hl4Af6QSAf6/uUML9j8Wi40p604srX6fGBca5pi4ycNj3XHC9HUj2XXkLZfyx04BXJJGtJJ2r6Vuc5F+s3uZLDiNafnIpuU0jv9c1z0+JKXwOnVC0bzGSeEjcVPm9HnAAVxczNNdcpNvrw0svGyERS/L32WaMgRkoxLq2nrh3HqrNGhPekaNrrI4FuZSi44vqRd2xT79jLmY4AOrkTWilHZFXBUeEipAAiUk643EuiGPTWyr3A2Fu6VTbJ//D8rEOaexuu1WeYeq4/b6VrRwAaSuVVYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ry7u65ccCG5CIzQYimOJkUTgOM6zrtmBNaHY7jvk0hg=;
 b=BiESdKfohJ7A2IcifF0GTdhYTmOtzeE14GmNTKEDh1ZmwVSy4KStCwsp6PoYdfhusVoTUtgWuO8BeBW1B5qg8s7k1uhu3eGvR5Wgk+ef0gMpVSWqyIuZTPAaVbMn6NZbPMCCiScOqXG6Ysu3RpHz7eq1rJBpWLyBHSsR20H3xrxz9OgQqQ/DsBF3H7eKs/IgWOHz2YT743ruCV2uajvp6qNswVeZKuuQbzzO4tLaGVGyWSNIAV4Rmkd1UdFUd2QzgMEv1ykGdgHEHp1n7JQHY5C7yJuJ2rXg1OBELmNDGrSAckxAK1LES/yOvkn7M+WtYfhcUGlfcnUbZXSXci/bpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ry7u65ccCG5CIzQYimOJkUTgOM6zrtmBNaHY7jvk0hg=;
 b=BpoPFY9BDuKo8CdpecfOcyPP21KpqU3T9MBpafQaIJGnvANaZm6z9Lj5j+QGaJpV1XQxv4adQU3bYkqp40WSeYDjcRlZAH/YESvwV6WwQcX3LgbMZVDLh9X+Mj2SkjpJVKzYprTuMG4xySqSjueKkyE5j03NO23O4UwTGx/aDroi/I59lF4cGpMSdmLIwSNpkLsfrJi1ky3LKS5T/y3oZKqn9nu2dUSa10vwdVzGSMhVLx26Etyc0pHMtIKbj4HbnOS7aUQaBsykUAGdGf1+HJuZx3uNOvjwvvTYUru7KDskexnUFJkb9+OBit9kkSDClBnBhipNlU8rTqVQ5iy+Gg==
Received: from DS6PR12MB534567.namprd12.prod.outlook.com (2603:10b6:8:498::17)
 by SA3PR12MB7975.namprd12.prod.outlook.com (2603:10b6:806:320::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.24; Thu, 15 Oct
 2026 18:57:31 +0000
Received: from DS6PR12MB534567.namprd12.prod.outlook.com
 ([fe80::4b0a:a4e0:694f:c2de]) by DS6PR12MB534567.namprd12.prod.outlook.com
 ([fe80::4b0a:a4e0:694f:c2de%5]) with mapi id 15.21.0522.013; Thu, 15 Oct 2026
 18:57:31 +0000
From: Sean Hefty <shefty@nvidia.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Eric Davis <eric.davis@broadcom.com>
CC: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Leon Romanovsky
	<leon@kernel.org>
Subject: RE: [PATCH rdma-next 02/13] RDMA/core: add the UET GID types
Thread-Topic: [PATCH rdma-next 02/13] RDMA/core: add the UET GID types
Thread-Index: AQHdXCpo3QYvbgzNxkCV986BMmoEJ7b9oFYAgAEjKQCAABq+gIAABevQ
Date: Thu, 15 Oct 2026 18:57:31 +0000
Message-ID:
 <DS6PR12MB53456734E5A7CFFCDD7FBCCC0CBD9C2@DS6PR12MB534567.namprd12.prod.outlook.com>
References: <20261014-uet-ib-core-v1-0-a0e626117113@broadcom.com>
 <20261014-uet-ib-core-v1-2-a0e626117113@broadcom.com>
 <sashiko-outbox-171976@kernel.org>
 <CAMouMY+nCYZ1V_-0La4phKNkvYBke7Njhsr+HRwWkAfahgf3pg@mail.gmail.com>
 <20261015173327.GU14213@ziepe.ca>
In-Reply-To: <20261015173327.GU14213@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS6PR12MB534567:EE_|SA3PR12MB7975:EE_
x-ms-office365-filtering-correlation-id: 51fd4525-73fe-4211-5531-08df2aee2aaa
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|10070799003|6133799003|18002099003|10067099003|22082099003|3023799007|11063799006|4143699003|38070700021|56012099006;
x-microsoft-antispam-message-info:
 fzeMCA8b1P91GYlBa/X/5DjrVbGLlcb/YP8F4QghDQaHxpL8H8kZdF1NdjKsEFRUXB7rqDnjd0V4onRyj4IVql4Lk8bd7eFFnRAxU4/3A70Gjp1jYjXVo7FtMv109DJBfDLLZRdBhQQF10QGdWpIa6jKBE4eHNuyBmyskYwHUwWaAm7D+eAZv1e0cFVdQFOUusbH0maejvWAinocGPZjlP/jfOBqNfoyTK+Lnh0jFehtn4n2Jz13l6Zl8YFX62zeyFWKEoS69Pm+fITf1bUUxcI7NfvC1kp7jAb9YflIZGfPxWuMxNSBUW3Zebvu3wQUQ9FvdzqzLNHltv2rABFQIPz/6GssnZFXmyZwCRN2Lkkbq/f81iN5jR4BC+ZHDdHcE+2PCj1BVZVtsH0bVIXHGOc4m+8aIsuyl9CFR0wRm2dwpmXBVPQCnyLDfXwiMaMDtH0CHW8kOUyYF+FTfh0Jl1K+zrYt4M4ZkICUK+684AOUYIpMbEz3yGxxgNkW21DB+zsf4rYyd21VNSf3VG/dmb+H83gBzI9Bp2hDDfJoPMBfjcanakDQLhDXlL29sXfbH0mAVVk7BV1zF1UvuxUaC9G+6qZO+3TqzltGbOE+inIPUz6OY381mdtyPcMJ3RFYm4Td75S3jFOIGkJZgN9BxuoXjyRAX3Wnp0IBO9bpga/3dWgiarusQ/kK5mhQDyDN/HCtOZHXdNGv/Qt5hC0jTKh+3AwjIrzVROA4F3UnJuE=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS6PR12MB534567.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(10070799003)(6133799003)(18002099003)(10067099003)(22082099003)(3023799007)(11063799006)(4143699003)(38070700021)(56012099006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dVJXa3JvTUhhMFI1Vjd1T3I0MFdTT0t6LzNpTkZhMVBIdjdMTnpYZG84eWJF?=
 =?utf-8?B?L0FVRndXRDQ0WDdLdlpUcFR3SXM1Wm52N00wSmRhUmt0Nm1GNWJta0gzSkhE?=
 =?utf-8?B?RVNRQm1WWkJsZzFIeWkvUHNvc1d3emdGZHFiSEhGSzRGQlRNcUd4MWlpRStm?=
 =?utf-8?B?UkZxcExPaldDcmlNc2dnTXQxcjMrbjJSdXJnN01uRlBuTXoyL3pNY0lPakRP?=
 =?utf-8?B?MG5kcmlsVHNQU1YyUXJNN3VyaEVQL0Q2ODFmMkI2YmI5ZEh2Um8rMjJ0NVNC?=
 =?utf-8?B?VVZtcExtcTQzWGpzYnIzMkgySHdOL3BBTmF2dllaUmFheVhMSXRjcEFnaE1y?=
 =?utf-8?B?TmhPVHorR0s2WWRjUjlDSmpOVVY5YnJkVC9sd3RqMm1LUlQ0NExhNmhmUTg5?=
 =?utf-8?B?dC9JR0h3cGl6Y2tiZUZEdVZLajJORk9nRTJwYjh5Y1pwRU02Q2VPK2ZVOTJ0?=
 =?utf-8?B?M0E5bGdQRkErR203b1plTVhMbU9qVENjTFUrdHhNQ2xTSGorYlFjdFdQRmoy?=
 =?utf-8?B?dEtmSDkzS0lQS3Z0MERWTFRVT2VuNXpxMGJ0by9sRWxYYVZ5aFhRcm5qOUJv?=
 =?utf-8?B?engzS1czTFhmcUtWRm5xL2dud1RaaC9RRFNWMUYrb1BGM2YvR1RiNUlncGdv?=
 =?utf-8?B?TzRXKzdhNXFXaFFPdGtwWmxIQ2hNdFVTZXV0eWo1b1E5WlkzUTVrNWJKN2o3?=
 =?utf-8?B?TktOdXdxK2lNcktGcGVXSXlKNEgrOWMwRHR2VDNyaE9kSU1uZzJNWnpKeFNY?=
 =?utf-8?B?K2NSZnVwY0UzVHN0bWZycFhIRTdKbE8zN0xnRlVWOVVXMzZybVdpVWJnNFQ1?=
 =?utf-8?B?dDk4YjQ1VGJ0dmRlQ1VrY2FEajV0eUgzQ2h2cC9EVmJFS0xoMjhibFVjZk13?=
 =?utf-8?B?aGgyWkhlY2hyMlJjOWRQZUE1VElTcHh5bi8zL2VIdWFMbG1hZjVpVi9MT0FY?=
 =?utf-8?B?cCsyM2lRdHFXWUtHY09QOEp3ci82ZVVtQWljRzFiWGM1ckxkSTlxdEx5YWZ2?=
 =?utf-8?B?dDY0SmZxaHIzS29tYktKcTVxSG9XdmxHVUE4ZHJzNXg0TnhuN2tmNlc5VzUw?=
 =?utf-8?B?UVVPWHZ5TTdReTNaOUpaZDV3Sk5zc3AwejdMclBCQzFFQWlFNDNWWlZneWxF?=
 =?utf-8?B?bXJTYzhOYi9ZSzhTeldCU3JKUDNURUNFMWVkU3B2ZFBFcTlzcS9BZXRZVExX?=
 =?utf-8?B?WElpWHoyQlQrbGNLbnlNNUozUmRGbFFqMFJ1TUpWZzExVGc5MFJuYXluYjBL?=
 =?utf-8?B?Y0xYTDFjeWhZUG9ONTRpL2tHdXZvL3FEQU9zeDNtZXZTaFRUVi9SdUdLTGU5?=
 =?utf-8?B?dlNVVzdMRVFPaWt3SGZKR1dqZU1CZUcwb1RuWklkQUdUeEdkWDNOWTA3QTV6?=
 =?utf-8?B?WkpZMEcxMFYxaFlNZENyNzdjQkl1NHRGTGZTU0FTQWNJT2dqbWFoajFkdHpE?=
 =?utf-8?B?SWZuRWFWUktHMGhrYWZUOGJwNE8ybExyUnFaODZLNWNtOTRVVEgwM1I4cVpL?=
 =?utf-8?B?cmtab1RYcXRkQlVBeHBKVUdxVmpNS29ONzlPMEdjSmR4TmNGODkwZnVGbE5Q?=
 =?utf-8?B?bktnUTIwVTAvdG9OSGkveEViVVNCT3FjY3pkL1FtcWVnTWx0bEVFTXFFOWJk?=
 =?utf-8?B?c001WnQ2R0FqSmd4Wm94Z3libGEyU1g1N091bnpOaWVONGRMaHlCNmxGMklD?=
 =?utf-8?B?ZXpoY2NmVCs3ejZOUXVHOFVXbmM5ZHVubEloQVFDUE9rd1NpbTNYY2JISWsz?=
 =?utf-8?B?ME9zaHR2ajZMRnA5R2kyRHB5QXJhd1F6dDdqTVQxVThoR3ViNUs2cWthRzYz?=
 =?utf-8?B?SFR1SDc2L2JnMEE3dWM3dVFhSFBmZkg5YU9CZE5rR2t3bUd4MUYrQWRRcFhT?=
 =?utf-8?B?bkxTcGpseDhjTjM5ODQ1Q2V3M2llQUVZMVJsaXd4Vkl1c2xUdHRmSitGQWo3?=
 =?utf-8?B?aExKK1pvSDBKM1Z2b2IrTUxlOWliVFo1bUd4ZWIyRkptREJwRU1CZHdBRG1x?=
 =?utf-8?B?OUFaK0lUT1drSWZ5VDFidVg3MXlWdjNWc0oxOVlQOFhlUDZHelZlbU1VL1R6?=
 =?utf-8?B?cG5aZTYyTFY3RE9HOWIxUDRJU0pnWDRZd0ljNTFFRTgzcVhTQzFMV2lMVzZh?=
 =?utf-8?B?RUZ5ZGtCVE9BMWRDNFdoOFVSaHBkd2t0NVpxSTZMdTFjYzJEcXVNamtkZmp6?=
 =?utf-8?B?UkdpT0lIY1ArdUxBRndGMDJ6VHZMVVBXTTR0bVU1Z1NqN2d4V1JYUTVXdlFt?=
 =?utf-8?B?SmYyZ2kreEFSNGYzUDNYWnZNQXd5ekk4STlEQzBvV3g3dmtMeWNGelcxZkVO?=
 =?utf-8?B?OFRUcThHNnI1WHRudExTY1kzeEd3NHdNL1M0c0lMbXNGd2VtY2E0Zz09?=
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
X-MS-Exchange-CrossTenant-AuthSource: DS6PR12MB534567.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51fd4525-73fe-4211-5531-08df2aee2aaa
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2026 18:57:31.5934
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FMi3IbcMUGLG04Xn2vsDuR0VtQU+DMaF/Pg5uUU3iTsDTrtTlQnYWES+gJKd6ceODQAQ0S9URyE1dw0+okRebQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7975

PiBPbiBUaHUsIE9jdCAxNSwgMjAyNiBhdCAwODo1Nzo0NEFNIC0wNzAwLCBFcmljIERhdmlzIHdy
b3RlOg0KPiA+IE9uIFdlZCwgT2N0IDE0LCAyMDI2IGF0IDM6MzXigK9QTSA8c2FzaGlrby1ib3RA
a2VybmVsLm9yZz4gd3JvdGU6DQo+ID4gPiBTYXNoaWtvIEFJIHJldmlldyBmb3VuZCAzIHBvdGVu
dGlhbCBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gPg0KPiA+IERpc2FncmVlIHdpdGggYWxsIHRo
cmVlIGFuZCBubyBjaGFuZ2UgcGxhbm5lZC4gTm9uZSBvZiB0aGVzZSBwYXRocw0KPiA+IHJ1bnMg
b24gYSBVRVQgcG9ydC4NCj4gPg0KPiA+IEEgVUVUIHBvcnQncyBjb3JlX2NhcF9mbGFncyBhcmUg
UkRNQV9DT1JFX0NBUF9QUk9UX1VFVF9bVURQfElQXSBwbHVzDQo+ID4gUkRNQV9DT1JFX0NBUF9F
VEhfQUguIEl0IGhhcyBubyBJQl9NQUQsIElCX0NNLCBJQl9TQSBvciBJQl9NQ0FTVA0KPiBiaXQu
DQo+ID4NCj4gPiA+IERvZXMgdGhpcyBleHBsaWNpdGx5IGZhaWwgQWRkcmVzcyBIYW5kbGUgaW5p
dGlhbGl6YXRpb24gZm9yIFVFVC1vbmx5IHBvcnRzPw0KPiA+DQo+ID4gWWVzLCBkZWxpYmVyYXRl
bHkuIGliX2luaXRfYWhfYXR0cl9mcm9tX3djKCkgaXMgY2FsbGVkIGJ5IHRoZSBNQUQNCj4gPiBh
Z2VudCwgdGhlIENNLCBtYWRfcm1wcCwgYW5kIHVzZXJfbWFkLiBUaGVzZSBhbGwgbmVlZCBJQl9N
QUQsIHNvIG5vbmUNCj4gPiBvZiB0aGVtIHNlZXMgYSBjb21wbGV0aW9uIGZyb20gYSBVRVQtb25s
eSBwb3J0LiBUaGUgY2hlY2sgaXMgYSBndWFyZA0KPiA+IGFzIGFuIHVuY29ubmVjdGVkIHBlZXIg
aXMgbmFtZWQgdGhyb3VnaCBhbiBleHRlbmRlZCBhZGRyZXNzIGhhbmRsZQ0KPiA+IChwYXRjaCA1
KSBvciB0aGUgam9iJ3MgYWRkcmVzcyB0YWJsZSAocGF0Y2ggNyksIG5ldmVyIGZyb20gYSBXQy4N
Cj4gDQo+IEhvdyBtdWNoIG9mIHRoaXMgZm9sbG93cyB0aGUgd29yayBTZWFuIGRpZCBpbiB0aGUg
Y29uc29ydGl1bT8gSSB0aG91Z2h0IGhlDQo+IGhhZCBkZWZpbmVkIEFIcz8NCg0KRXJpYyBhbmQg
SSB3b3JrZWQgY2xvc2VseS4gIE1vc3Qgb2YgdGhlIFVFQyB3b3JrIGZvY3VzZWQgb24gdGhlIHVz
ZXItc3BhY2UgaW50ZXJmYWNlcywgYnV0IHRoZSBvdmVyYWxsIHN0cnVjdHVyZSBzaG91bGQgYmUg
YWxpZ25lZC4NCg0KVUVDIGRlZmluZWQgYW4gZXh0ZW5kZWQgQUguICBpYl9pbml0X2FoX2F0dHJf
ZnJvbV93YygpIGNvdWxkIHByb2JhYmx5IGJlIGV4dGVuZGVkIHRvIHN1cHBvcnQgVUVULCBJIGRv
bid0IHRoaW5rIGl0IHdvdWxkIGJlIHVzZWQsIGhvd2V2ZXIuDQoNCj4gPiA+IENvdWxkIHRoaXMg
Y2F1c2UgaW5jb21pbmcgVUVUIHBhY2tldHMgdG8gYmUgaW5jb3JyZWN0bHkgbWFwcGVkIHRvIGEN
Cj4gPiA+IFJvQ0V2MiBHSUQgaW5kZXgsIGJyZWFraW5nIHRoZSBVRVQgdHJhbnNwb3J0IHJlc3Bv
bnNlPw0KPiA+DQo+ID4gT24gYSBwb3J0IHRoYXQgcnVucyBib3RoIFJvQ0UgYW5kIFVFVCB0aGUg
TUFEIHRyYWZmaWMgaXMgUm9DRSwgc28NCj4gPiBtYXBwaW5nIGl0IHRvIFJvQ0V2MiBpcyBjb3Jy
ZWN0Lg0KPiANCj4gWW91IHdpbGwgbmVlZCBzZXBlcmF0ZSBST0NFIGFuZCBVRVQgaWJfZGV2aWNl
cyB3aXRoIHRoZSBjdXJyZW50IHN0YXRlIG9mDQo+IGFmZmFpcnMsIHdlIGRvbid0IHN1cHBvcnQg
bXVsdGktcHJvdG9jb2wgdG9kYXkuDQoNClVFQyBpbnRlbnRpb25hbGx5IGNvbnNpZGVyZWQgbXVs
dGktcHJvdG9jb2wgZGV2aWNlcywgd2l0aCBhIHZlbmRvciBkZWNpZGluZyB3aGV0aGVyIGl0IHdv
dWxkIG5lZWQgdG8gcHJvdmlkZSBzZXBhcmF0ZSBTVyBkZXZpY2VzLiAgRS5nLiB1c2luZyBVRVQg
Zm9yIE1QSSwgYnV0IFJvQ0UgZm9yIHN0b3JhZ2UuICBQcm90b2NvbCBzZWxlY3Rpb24gaXMgdmlh
IEdJRCwgc2FtZSBhcyBSb0NFdjEgdnMgdjIuDQoNCldoYXQgYmxvY2tzIG11bHRpLXByb3RvY29s
IHN1cHBvcnQ/DQo=
