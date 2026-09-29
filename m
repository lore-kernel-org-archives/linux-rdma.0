Received: from outbound.baidu.com (mx22.baidu.com [220.181.50.185])
	by smtp.subspace.kernel.org (Postfix) with SMTP id 7ABEF2F5495
	for <linux-rdma@vger.kernel.org>; Tue, 29 Sep 2026 01:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.181.50.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790644893; cv=none; b=EndaPZPpAikfox3gKTbjDGJG5ZHdR1gcmRS3wg2oPTW5LQaJdUumAzNSGUDAH5RApJLnsoY7EysxI4bgI2VuoCvv7elVbUKNaIGGW8xoFdL4PDvZ2EP2yG7i9NORMohLN0bcM9Z9x3LY0suOMfYZGR5t3beVF/ZNPGEQ6dXz/Qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790644893; c=relaxed/simple;
	bh=kIYudZggmzf0UQBHs1s6VMZzB6ot5Rioz3h0NNB1yjM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hzOiIMkCEoPSfdBDWEWOgdL4JahvWSiXQ7eFU9XVB723b5+qv+LCMqr52yglGPonIFqjaNMVHPGflCtX+CuF1bQywxmPxwbVdGkAVzv6V4QnW1/zQoqT5nn5qsouOpdYreJ349DuiYF07+ZYy/XAWr93ZzrNH5+sWvwvjJrg9k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b=AVYyPKpa; arc=none smtp.client-ip=220.181.50.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b="AVYyPKpa"
X-MD-Sfrom: lirongqing@baidu.com
X-MD-SrcIP: 172.31.50.48
From: "Li,Rongqing" <lirongqing@baidu.com>
To: Leon Romanovsky <leon@kernel.org>
CC: Jason Gunthorpe <jgg@ziepe.ca>, "linux-rdma@vger.kernel.org"
	<linux-rdma@vger.kernel.org>
Subject: =?gb2312?B?tPC4tDogWz8/Pz9dIFJlOiBbUEFUQ0hdIFJETUEvbWx4NTogQ2hlY2sgU0lH?=
 =?gb2312?Q?=5FERR_CQE_mkey_lookup_before_dereferencing?=
Thread-Topic: [????] Re: [PATCH] RDMA/mlx5: Check SIG_ERR CQE mkey lookup
 before dereferencing
Thread-Index: AQHdSB7HMsfknreNs02f0OELRaEgT7bj2r2AgAD2QVA=
Date: Tue, 29 Sep 2026 01:21:23 +0000
Message-ID: <eefbecee6ddd474f9d0d50e2eb28ed52@baidu.com>
References: <20260919100806.2320-1-lirongqing@baidu.com>
 <20260928183825.GZ563127@unreal>
In-Reply-To: <20260928183825.GZ563127@unreal>
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
	s=selector1; t=1790644884;
	bh=kIYudZggmzf0UQBHs1s6VMZzB6ot5Rioz3h0NNB1yjM=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type;
	b=AVYyPKpa/rktymLkaSLdQd3GcIrIUT2v12bdadb4dZ1n054BuTOY8gkgRwYjv73Xx
	 eyEpZtLTmujLRQTwRnf4RJUSeRX2RvhZQdCYc4IIRDCboGduJXan41Yj904FiJvyzW
	 0gE4VBTyLBbeNfUZNDvPRi3hJ1G0IICG/c+NGxevKfFVl43oihh/hx1JHG4ekQptmn
	 0ior1wNXxBOryrJ8e3LY48GngQ/JImgn/Zvlfwz1vWUWfgHLcNK72B41FqbciSbZH9
	 yM8gLUGY3U36sp+pt9BVBwMubXUhi6fQdt7zmVMqqXSW2i8w1Y0+YTFQNE8UeYIZjs
	 /+J8TeWZ8Vnyg==

DQo+IE9uIFNhdCwgU2VwIDE5LCAyMDI2IGF0IDA2OjA4OjA2UE0gKzA4MDAsIGxpcm9uZ3Fpbmcg
d3JvdGU6DQo+ID4gRnJvbTogTGkgUm9uZ1FpbmcgPGxpcm9uZ3FpbmdAYmFpZHUuY29tPg0KPiA+
DQo+ID4gSW4gbWx4NV9wb2xsX29uZSwgYSBNTFg1X0NRRV9TSUdfRVJSIGNvbXBsZXRpb24gbG9v
a3MgdXAgdGhlIHNpZ25hdHVyZQ0KPiA+IGNvbnRleHQgaW4gZGV2LT5zaWdfbXJzIHZpYSB4YV9s
b2FkKCkgYnV0IGRlcmVmZXJlbmNlcyB0aGUgcmVzdWx0DQo+ID4gd2l0aG91dCBhIE5VTEwgY2hl
Y2suIElmIHRoZSBjb3JyZXNwb25kaW5nIE1SIGhhcyBiZWVuIGNvbmN1cnJlbnRseQ0KPiA+IGRl
cmVnaXN0ZXJlZA0KPiANCj4gSXMgdGhpcyByZWFsIHNjZW5hcmlvPyBJbnRlZ3JpdHkgTVJzIGFy
ZSBpbi1rZXJuZWwgTVJzLCB0aGV5IHNob3VsZG4ndCBiZQ0KPiBjb25jdXJyZW50bHkgZGVyZWdp
c3RlcmVkLg0KPiANClRoYW5rcyBmb3IgdGhlIHJldmlldy4gWW91J3JlIHJpZ2h0IKGqIHRoZSBj
b25jdXJyZW50LWRlcmVnaXN0ZXIgc2NlbmFyaW8gSSBkZXNjcmliZWQgaXMgbm90IHJlYWNoYWJs
ZSBpbiBub3JtYWwgdXNlOiBNTFg1X0NRRV9TSUdfRVJSIGlzIG9ubHkgZ2VuZXJhdGVkIGZvciBz
aWduYXR1cmUgKElCX01SX1RZUEVfSU5URUdSSVRZKSBNUnMsIHdob3NlIG1rZXkgaXMgYWx3YXlz
IHByZXNlbnQgaW4gZGV2LT5zaWdfbXJzIHdoaWxlIHRoZSBvcGVyYXRpb24gaXMgaW4gZmxpZ2h0
LCBhbmQgdGhlIG51bGwgbWtleSBpcyBhbiBPRFAtb25seSBzcGVjaWFsIGNhc2UgdGhhdCBpcyBu
ZXZlciBpbnNlcnRlZCBpbnRvIHNpZ19tcnMuDQoNClRoYW5rcw0KDQpbTGksUm9uZ3FpbmddIA0K
DQoNCj4gVGhhbmtzDQo+IA0KPiA+ICh3aGljaCByZW1vdmVzIHRoZSB4YXJyYXkgZW50cnkgd2l0
aG91dCBob2xkaW5nIHRoZSBDUSBsb2NrKSwNCj4gPiB4YV9sb2FkKCkgcmV0dXJucyBOVUxMIGFu
ZCB0aGUgc3Vic2VxdWVudA0KPiA+IGdldF9zaWdfZXJyX2l0ZW0oc2lnX2Vycl9jcWUsICZzaWct
PmVycl9pdGVtKSBjcmFzaGVzIGluIGF0b21pYyBjb250ZXh0IHVuZGVyDQo+IHhhX2xvY2suDQo+
ID4NCj4gPiBBZGQgYSBOVUxMIGNoZWNrIHRoYXQgZHJvcHMgdGhlIGxvY2ssIGxvZ3MgYSB3YXJu
aW5nLCBhbmQgcmVwb2xscy4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IExpIFJvbmdRaW5nIDxs
aXJvbmdxaW5nQGJhaWR1LmNvbT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9pbmZpbmliYW5kL2h3
L21seDUvY3EuYyB8IDcgKysrKysrKw0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgNyBpbnNlcnRpb25z
KCspDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9pbmZpbmliYW5kL2h3L21seDUvY3Eu
Yw0KPiA+IGIvZHJpdmVycy9pbmZpbmliYW5kL2h3L21seDUvY3EuYyBpbmRleCA0OWI0YmYxLi5i
MGIxMTc3IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvaW5maW5pYmFuZC9ody9tbHg1L2NxLmMN
Cj4gPiArKysgYi9kcml2ZXJzL2luZmluaWJhbmQvaHcvbWx4NS9jcS5jDQo+ID4gQEAgLTU2Myw2
ICs1NjMsMTMgQEAgc3RhdGljIGludCBtbHg1X3BvbGxfb25lKHN0cnVjdCBtbHg1X2liX2NxICpj
cSwNCj4gPiAgCQl4YV9sb2NrKCZkZXYtPnNpZ19tcnMpOw0KPiA+ICAJCXNpZyA9IHhhX2xvYWQo
JmRldi0+c2lnX21ycywNCj4gPiAgCQkJCW1seDVfYmFzZV9ta2V5KGJlMzJfdG9fY3B1KHNpZ19l
cnJfY3FlLT5ta2V5KSkpOw0KPiA+ICsJCWlmICghc2lnKSB7DQo+ID4gKwkJCXhhX3VubG9jaygm
ZGV2LT5zaWdfbXJzKTsNCj4gPiArCQkJbWx4NV9pYl93YXJuKGRldiwgIkNRTjogMHgleCBHb3Qg
U0lHRVJSIG9uIHVua25vd24gbWtleToNCj4gMHgleFxuIiwNCj4gPiArCQkJCSAgICAgY3EtPm1j
cS5jcW4sDQo+ID4gKwkJCQkgICAgIGJlMzJfdG9fY3B1KHNpZ19lcnJfY3FlLT5ta2V5KSk7DQo+
ID4gKwkJCWdvdG8gcmVwb2xsOw0KPiA+ICsJCX0NCj4gPiAgCQlnZXRfc2lnX2Vycl9pdGVtKHNp
Z19lcnJfY3FlLCAmc2lnLT5lcnJfaXRlbSk7DQo+ID4gIAkJc2lnLT5zaWdfZXJyX2V4aXN0cyA9
IHRydWU7DQo+ID4gIAkJc2lnLT5zaWdlcnJfY291bnQrKzsNCj4gPiAtLQ0KPiA+IDIuOS40DQo+
ID4NCg==
