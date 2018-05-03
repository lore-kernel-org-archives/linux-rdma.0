From: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Subject: RE: [PATCH for-rc v2 1/6] IB/hfi1: Fix handling of FECN marked
 multicast packet
Date: Thu, 3 May 2018 12:54:22 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC62829957@fmsmsx120.amr.corp.intel.com>
References: <20180501123317.24520.8848.stgit@scvm10.sc.intel.com>
         <20180501123532.24520.80857.stgit@scvm10.sc.intel.com>
         <20180501180531.GB17027@ziepe.ca>
         <32E1700B9017364D9B60AED9960492BC6281B784@fmsmsx120.amr.corp.intel.com>
 <1525227892.11756.131.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1525227892.11756.131.camel@redhat.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, "Dalessandro, Dennis" <dennis.dalessandro@intel.com>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "Hiatt, Don" <don.hiatt@intel.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "Ruhl, Michael J" <michael.j.ruhl@intel.com>
List-Id: linux-rdma@vger.kernel.org

PiA+DQo+ID4gQnV0IEkgc2VlIERvdWcgcHVsbGVkIHRoZSBmaXg/DQo+IA0KPiBJdCdzIGluIG15
IHdpcCBicmFuY2gsIHNvIHVudGlsIEkgbWVyZ2UgaXQgaW50byB0aGUgb2ZmaWNpYWwgZm9yLXJj
DQo+IGJyYW5jaCwgSSBjYW4gc3RpbGwgZml4IHVwIG1pbm9yIHRoaW5ncyBsaWtlIHRoaXMuDQo+
IA0KDQpUaGUgcGF0Y2ggd29ya3Mgd2l0aG91dCB0aGUgY2FzdC4NCg0KSG93IGRvIHlvdSB3YW50
IHRvIGRvIHRoaXM6DQotIEEgdjIgLT4gdjMgb2YgdGhlIHBhdGNoPw0KLSBNYW51YWxseSBkZWxl
dGUgdGhlIGNhc3QgaW4geW91ciB3aXAgYnJhbmNoPw0KDQpIZXJlIGlzIHRoZSBkaWZmIGh1bmsg
Zm9yIHJlbW92aW5nIHRoZSBjYXN0IGZyb20gcmV0dXJuX2NucDoNCmRpZmYgLS1naXQgYS9kcml2
ZXJzL2luZmluaWJhbmQvaHcvaGZpMS91ZC5jIGIvZHJpdmVycy9pbmZpbmliYW5kL2h3L2hmaTEv
dWQuYw0KaW5kZXggOWFhN2Q4Ny4uNmFkMjAzZiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvaW5maW5p
YmFuZC9ody9oZmkxL3VkLmMNCisrKyBiL2RyaXZlcnMvaW5maW5pYmFuZC9ody9oZmkxL3VkLmMN
CkBAIC03MTksNyArNzE5LDcgQEAgdm9pZCByZXR1cm5fY25wKHN0cnVjdCBoZmkxX2licG9ydCAq
aWJwLCBzdHJ1Y3QgcnZ0X3FwICpxcCwgdTMyIHJlbW90ZV9xcG4sDQoNCiAgICAgICAgbHJoMCB8
PSAoc2M1ICYgMHhmKSA8PCAxMiB8IHNsIDw8IDQ7DQoNCi0gICAgICAgYnRoMCA9ICh1MzIpcGtl
eSB8IChJQl9PUENPREVfQ05QIDw8IDI0KTsNCisgICAgICAgYnRoMCA9IHBrZXkgfCAoSUJfT1BD
T0RFX0NOUCA8PCAyNCk7DQogICAgICAgIG9oZHItPmJ0aFswXSA9IGNwdV90b19iZTMyKGJ0aDAp
Ow0KDQogICAgICAgIG9oZHItPmJ0aFsxXSA9IGNwdV90b19iZTMyKHJlbW90ZV9xcG4gfCAoMSA8
PCBJQl9CRUNOX1NISUZUKSk7DQoNCk1pa2UNCg==
