From: "Amrani, Ram" <Ram.Amrani@cavium.com>
Subject: RE: [PATCH] iser-target: Fix possible use-after-free in connection
 establishment error
Date: Tue, 28 Nov 2017 11:51:02 +0000
Message-ID: <BN3PR07MB25787833DA301FFDFC165A91F83A0@BN3PR07MB2578.namprd07.prod.outlook.com>
References: <20171126133104.22710-1-sagi@grimberg.me>
 <3676820c-544e-8ced-859a-ade8e6a0ef53@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <3676820c-544e-8ced-859a-ade8e6a0ef53@grimberg.me>
Content-Language: en-US
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>, Doug Ledford <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
List-Id: linux-rdma@vger.kernel.org

PiBPbiAxMS8yNi8yMDE3IDAzOjMxIFBNLCBTYWdpIEdyaW1iZXJnIHdyb3RlOg0KPiA+IEluIGNh
c2Ugd2UgZmFpbCB0byBlc3RhYmxpc2ggdGhlIGNvbm5lY3Rpb24gd2UgbXVzdCBkcmFpbiBvdXIg
cHJlLXBvc3RlZA0KPiA+IGxvZ2luIHJlY2lldmUgd29yayByZXF1ZXN0IGJlZm9yZSBjb250aW51
aW5nIHNhZmVseSB3aXRoIGNvbm5lY3Rpb24NCj4gPiB0ZWFyZG93bi4NCj4gPg0KPiA+IFJlcG9y
dGVkLWJ5OiBBbXJhbmksIFJhbSA8UmFtLkFtcmFuaUBjYXZpdW0uY29tPg0KPiA+IFNpZ25lZC1v
ZmYtYnk6IFNhZ2kgR3JpbWJlcmcgPHNhZ2lAZ3JpbWJlcmcubWU+DQo+ID4gLS0tDQo+ID4gICBk
cml2ZXJzL2luZmluaWJhbmQvdWxwL2lzZXJ0L2liX2lzZXJ0LmMgfCAxICsNCj4gPiAgIDEgZmls
ZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMv
aW5maW5pYmFuZC91bHAvaXNlcnQvaWJfaXNlcnQuYyBiL2RyaXZlcnMvaW5maW5pYmFuZC91bHAv
aXNlcnQvaWJfaXNlcnQuYw0KPiA+IGluZGV4IGNlYWJkYjg1ZGY4Yi4uOWQ0Nzg1YmEyNGNiIDEw
MDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvaW5maW5pYmFuZC91bHAvaXNlcnQvaWJfaXNlcnQuYw0K
PiA+ICsrKyBiL2RyaXZlcnMvaW5maW5pYmFuZC91bHAvaXNlcnQvaWJfaXNlcnQuYw0KPiA+IEBA
IC03NDEsNiArNzQxLDcgQEAgaXNlcnRfY29ubmVjdF9lcnJvcihzdHJ1Y3QgcmRtYV9jbV9pZCAq
Y21hX2lkKQ0KPiA+ICAgew0KPiA+ICAgCXN0cnVjdCBpc2VydF9jb25uICppc2VydF9jb25uID0g
Y21hX2lkLT5xcC0+cXBfY29udGV4dDsNCj4gPg0KPiA+ICsJaWJfZHJhaW5fcXAoaXNlcnRfY29u
bi0+cXApOw0KPiA+ICAgCWxpc3RfZGVsX2luaXQoJmlzZXJ0X2Nvbm4tPm5vZGUpOw0KPiA+ICAg
CWlzZXJ0X2Nvbm4tPmNtX2lkID0gTlVMTDsNCj4gPiAgIAlpc2VydF9wdXRfY29ubihpc2VydF9j
b25uKTsNCg0KV2l0aCB0aGlzIHBhdGNoIG91ciB0ZXN0IGJlaGF2ZXMgYXMgZXhwZWN0ZWQuDQoN
ClRoYW5rcywNClJhbQ0KDQo=
