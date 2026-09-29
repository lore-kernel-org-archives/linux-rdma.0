Received: from outbound.baidu.com (mx22.baidu.com [220.181.50.185])
	by smtp.subspace.kernel.org (Postfix) with SMTP id E15E81799F
	for <linux-rdma@vger.kernel.org>; Tue, 29 Sep 2026 01:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.181.50.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790643998; cv=none; b=clbNTmbnVwn1k+VChaSa0t/khBau7wLA3X4uVDNB/9uX8wmK9U5ktnG4RVtNVRB2lgvsWFwPIAAfzdpbukRlUX9UBokiFkvZNkm0cjaQzwfT3DdJitawxJhU3VpXCCRgih6Bt2zgpHleQKiGrV1ulJcllZq18OlogohKH7q+QaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790643998; c=relaxed/simple;
	bh=tUCDKv2BQTmZQgAMrwuxHnus6xUxhcamdH7ABNl1EMI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rHyuTERKs2+VnFBSkpPgwuj0pIvALL9q2TrF7HRJSNAfE7TbA3P+DOX4CNXLfvBOQKENeGQcVSRywOXkB8b+c4f1oPZJadJ5xrlThjASl+K+mcErZgNiv++5Cw/OJDSjPoFJzyQqcIHGDD5kiZq2Q+va0cvRKiUPVd5mi2cqmao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b=LQTL2gN6; arc=none smtp.client-ip=220.181.50.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b="LQTL2gN6"
X-MD-Sfrom: lirongqing@baidu.com
X-MD-SrcIP: 172.31.3.12
From: "Li,Rongqing" <lirongqing@baidu.com>
To: Leon Romanovsky <leon@kernel.org>
CC: Jason Gunthorpe <jgg@ziepe.ca>, "linux-rdma@vger.kernel.org"
	<linux-rdma@vger.kernel.org>
Subject: =?gb2312?B?tPC4tDogWz8/Pz9dIFJlOiBbUEFUQ0hdIFJETUEvbWx4NTogRml4IENRIHJl?=
 =?gb2312?Q?size_destination_index_mask?=
Thread-Topic: [????] Re: [PATCH] RDMA/mlx5: Fix CQ resize destination index
 mask
Thread-Index: AQHdSB6qV6bfqHwCpEiG4Yjxsd/3Dbbj2YWAgADxLGA=
Date: Tue, 29 Sep 2026 01:06:18 +0000
Message-ID: <d1f012cd1d03428e9e104d77ddaabdc4@baidu.com>
References: <20260919100716.2221-1-lirongqing@baidu.com>
 <20260928183403.GY563127@unreal>
In-Reply-To: <20260928183403.GY563127@unreal>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1790643989;
	bh=tUCDKv2BQTmZQgAMrwuxHnus6xUxhcamdH7ABNl1EMI=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type;
	b=LQTL2gN6Uw9c652BpGGTOiTlgyV2fr6ykbSSnJfV5wsqTY52exhsSAAed1eY5NMaX
	 CPpMe+iNbLcGc9Bws6u4rVU9geOHczIfkaGxgqmLTMRfsCKmYSn7e4wE3wQTbmMZ3n
	 tMvLKKvYHgXSwSS9xlxc1MZQ4a7q4TV9DvI2ZYmqoDhjBt4lPPDFIkOVjcOAkN8b0R
	 tlRoUQ6aNQCxptZZCNcJ3LUaTn23m7Ti7L9SP3usLvV7E5TF01Q5yzX2Y4okchZT3z
	 /Pxr0rvZTfxPR7tSgvOnTMmbL1tQYxI8OF/DBCX9zR381IqB7MHsLcebvDjQNcvY1m
	 PLB80MCCFlguA==

PiBPbiBTYXQsIFNlcCAxOSwgMjAyNiBhdCAwNjowNzoxNlBNICswODAwLCBsaXJvbmdxaW5nIHdy
b3RlOg0KPiA+IEZyb206IExpIFJvbmdRaW5nIDxsaXJvbmdxaW5nQGJhaWR1LmNvbT4NCj4gPg0K
PiA+IEluIGNvcHlfcmVzaXplX2NxZXMsIHRoZSBkZXN0aW5hdGlvbiBDUUUgaW5kZXggaXMgY29t
cHV0ZWQgYXMgKGkgKyAxKQ0KPiA+ICYgY3EtPnJlc2l6ZV9idWYtPm5lbnQsIGJ1dCByZXNpemVf
YnVmLT5uZW50IGlzIHRoZSBwb3dlci1vZi10d28gZW50cnkNCj4gPiBjb3VudCwgc28gdGhlIG1h
c2sgb25seSB5aWVsZHMgMCBvciBuZW50IC0tIGFuZCBuZW50IGlzIG9uZSBwYXN0IHRoZQ0KPiA+
IGxhc3QgdmFsaWQgc2xvdC4gVGhlIGZvbGxvd2luZyBtZW1jcHkgdGhlbiB3cml0ZXMgb3V0IG9m
IGJvdW5kcy4NCj4gPg0KPiA+IFVzZSAobmVudCAtIDEpIGFzIHRoZSB3cmFwIG1hc2ssIGNvbnNp
c3RlbnQgd2l0aCBnZXRfc3dfY3FlIHdoaWNoDQo+ID4gbWFza3MgYWdhaW5zdCBjcS0+aWJjcS5j
cWUgKHRoZSBuZW50IC0gMSB2YWx1ZSkuDQo+ID4NCj4gPiBGaXhlczogYmRlNTE1ODNmNDliICgi
SUIvbWx4NTogQWRkIHN1cHBvcnQgZm9yIHJlc2l6ZSBDUSIpDQo+ID4gU2lnbmVkLW9mZi1ieTog
TGkgUm9uZ1FpbmcgPGxpcm9uZ3FpbmdAYmFpZHUuY29tPg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJz
L2luZmluaWJhbmQvaHcvbWx4NS9jcS5jIHwgMiArLQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgMSBp
bnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJz
L2luZmluaWJhbmQvaHcvbWx4NS9jcS5jDQo+ID4gYi9kcml2ZXJzL2luZmluaWJhbmQvaHcvbWx4
NS9jcS5jIGluZGV4IGIwYjExNzcuLjViZDUyMjcgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9p
bmZpbmliYW5kL2h3L21seDUvY3EuYw0KPiA+ICsrKyBiL2RyaXZlcnMvaW5maW5pYmFuZC9ody9t
bHg1L2NxLmMNCj4gPiBAQCAtMTMxOSw3ICsxMzE5LDcgQEAgc3RhdGljIGludCBjb3B5X3Jlc2l6
ZV9jcWVzKHN0cnVjdCBtbHg1X2liX2NxDQo+ID4gKmNxKQ0KPiA+DQo+ID4gIAl3aGlsZSAoZ2V0
X2NxZV9vcGNvZGUoc2NxZTY0KSAhPSBNTFg1X0NRRV9SRVNJWkVfQ1EpIHsNCj4gPiAgCQlkY3Fl
ID0gbWx4NV9mcmFnX2J1Zl9nZXRfd3FlKCZjcS0+cmVzaXplX2J1Zi0+ZmJjLA0KPiA+IC0JCQkJ
CSAgICAgKGkgKyAxKSAmIGNxLT5yZXNpemVfYnVmLT5uZW50KTsNCj4gPiArCQkJCQkgICAgIChp
ICsgMSkgJiAoY3EtPnJlc2l6ZV9idWYtPm5lbnQgLSAxKSk7DQo+IA0KPiBJIHRoaW5rIHRoZSBv
cmlnaW5hbCBpbnRlbnQgd2FzIHRvIHVzZSBgKGkgKyAxKSAlIGNxLT5yZXNpemVfYnVmLT5uZW50
YC4NCj4gDQo+IFRoYW5rcw0KDQpyZXNpemVfYnVmLT5uZW50IGlzIGd1YXJhbnRlZWQgdG8gYmUg
YSBwb3dlciBvZiB0d28gYnkgcm91bmR1cF9wb3dfb2ZfdHdvKGVudHJpZXMgKyAxKSwgDQphbmQg
c3dfb3duZXJzaGlwX2JpdCgpL2dldF9zd19jcWUoKSBpbiB0aGUgc2FtZSBwYXRoIGJvdGggcmVs
eSBvbiB0aGlzIGludmFyaWFudC4NClRoZXJlZm9yZSAmIChuZW50IC0gMSkgYW5kICUgbmVudCBh
cmUgZXF1aXZhbGVudCBoZXJlOyB0aGUgYml0d2lzZSBmb3JtIGlzIGtlcHQgZm9yIGNvbnNpc3Rl
bmN5DQp3aXRoIHRoZSBzdXJyb3VuZGluZyBjb2RlLg0KDQpUaGFua3MNCg0KW0xpLFJvbmdxaW5n
XSANCg0KDQoNCj4gDQo+ID4gIAkJZGNxZTY0ID0gZHNpemUgPT0gNjQgPyBkY3FlIDogZGNxZSAr
IDY0Ow0KPiA+ICAJCXN3X293biA9IHN3X293bmVyc2hpcF9iaXQoaSArIDEsIGNxLT5yZXNpemVf
YnVmLT5uZW50KTsNCj4gPiAgCQltZW1jcHkoZGNxZSwgc2NxZSwgZHNpemUpOw0KPiA+IC0tDQo+
ID4gMi45LjQNCj4gPg0K
