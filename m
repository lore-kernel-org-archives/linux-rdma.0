From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH rdma-next 2/2] IB/mlx5: Add scatter end padding support
Date: Thu, 19 Oct 2017 07:56:48 +0000
Message-ID: <BN3PR07MB2578139CB1C38C5228B395F6F8420@BN3PR07MB2578.namprd07.prod.outlook.com>
References: <20171017151857.11934-1-leon@kernel.org>
 <20171017151857.11934-3-leon@kernel.org>
 <BN3PR07MB25787107C19B694BB0BA39B4F84D0@BN3PR07MB2578.namprd07.prod.outlook.com>
 <7d53f1e2-239b-0415-5b28-875f1710c11a@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7d53f1e2-239b-0415-5b28-875f1710c11a-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

PiA+IFdoYXQncyB0aGUgZmVhdHVyZSBhc3NvY2lhdGVkIHdpdGggTUxYNV9XUV9FTkRfUEFEX01P
REVfQUxJR04/DQo+ID4gSXQgc2VlbXMgaXQgd2FzIHRoZXJlIGJlZm9yZSB0aGlzIHBhdGNoIHNl
cmllcyBhbmQgYmVhcnMgYSBzaW1pbGFyIG5hbWUuDQo+IA0KPiBSaWdodCwgdGhpcyBzZXJpZXMg
ZXhwb3NlcyB0aGlzIGFscmVhZHkgZXhpc3RpbmcgZmVhdHVyZSB0byB0aGUgdXNlci4NCg0KSSdt
IHVuZGVyIHRoZSBpbXByZXNzaW9uIHRoYXQgdGhleSBhcmUgc29tZXdoYXQgZGlmZmVyZW50IChw
ZXIgUVAgdHlwZT8/KSBmcm9tIHRoaXMgY29kZToNCg0KKwlpZiAoaW5pdF9hdHRyLT5jcmVhdGVf
ZmxhZ3MgJiBJQl9RUF9DUkVBVEVfU0NBVFRFUl9FTkRfUEFERElORykgew0KKwkJaWYgKCFNTFg1
X0NBUF9HRU4oZGV2LT5tZGV2LCBlbmRfcGFkKSkgew0KKwkJCW1seDVfaWJfZGJnKGRldiwgInNj
YXR0ZXIgZW5kIHBhZGRpbmcgaXMgbm90IHN1cHBvcnRlZFxuIik7DQorCQkJZXJyID0gLUVPUE5P
VFNVUFA7DQorCQkJZ290byBlcnI7DQorCQl9IGVsc2UgaWYgKGluaXRfYXR0ci0+cXBfdHlwZSAh
PSBJQl9RUFRfUkFXX1BBQ0tFVCkgew0KKwkJCU1MWDVfU0VUKHFwYywgcXBjLCBlbmRfcGFkZGlu
Z19tb2RlLA0KKwkJCQkgTUxYNV9XUV9FTkRfUEFEX01PREVfQUxJR04pOw0KKwkJfSBlbHNlIHsN
CisJCQlxcC0+ZmxhZ3MgfD0gTUxYNV9JQl9RUF9TQ0FUVEVSX0VORF9QQURESU5HOw0KKwkJfQ0K
Kwl9DQorDQoNCkJ1dCBpZiBpbmRlZWQgdGhleSBhcmUgdGhlIHNhbWUgdGhlbiBwbGVhc2UgY29u
c2lkZXIgdXNpbmcgdGhlIHNhbWUgbmFtZXMgdG8gaW5jcmVhc2UgcmVhZGFiaWxpdHkuDQoNClRo
YW5rcywNClJhbQ0KDQo=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
