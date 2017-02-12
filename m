From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 1/8] IB/srp: Avoid that duplicate responses trigger a
 kernel bug
Date: Sun, 12 Feb 2017 20:07:13 +0000
Message-ID: <1486930017.2918.3.camel@sandisk.com>
References: <20170210235611.3243-1-bart.vanassche@sandisk.com>
         <20170210235611.3243-2-bart.vanassche@sandisk.com>
         <20170212170537.GE14015@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170212170537.GE14015@mtr-leonro.local>
Content-Language: en-US
Content-ID: <7092017F60EABF4981318D5CC71F6550@sandisk.com>
Sender: stable-owner@vger.kernel.org
To: "leon@kernel.org" <leon@kernel.org>
Cc: "maxg@mellanox.com" <maxg@mellanox.com>, "israelr@mellanox.com" <israelr@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Steve Feeley <Steve.Feeley@sandisk.com>, "dledford@redhat.com" <dledford@redhat.com>, "loberman@redhat.com" <loberman@redhat.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

T24gU3VuLCAyMDE3LTAyLTEyIGF0IDE5OjA1ICswMjAwLCBMZW9uIFJvbWFub3Zza3kgd3JvdGU6
DQo+IE9uIEZyaSwgRmViIDEwLCAyMDE3IGF0IDAzOjU2OjA0UE0gLTA4MDAsIEJhcnQgVmFuIEFz
c2NoZSB3cm90ZToNCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9pbmZpbmliYW5kL3VscC9zcnAv
aWJfc3JwLmMgYi9kcml2ZXJzL2luZmluaWJhbmQvdWxwL3NycC9pYl9zcnAuYw0KPiA+IGluZGV4
IDc5YmY0ODQ3N2RkYi4uNDA2OGQzNGY1NDI3IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvaW5m
aW5pYmFuZC91bHAvc3JwL2liX3NycC5jDQo+ID4gKysrIGIvZHJpdmVycy9pbmZpbmliYW5kL3Vs
cC9zcnAvaWJfc3JwLmMNCj4gPiBAQCAtMTg5OSw3ICsxODk5LDE0IEBAIHN0YXRpYyB2b2lkIHNy
cF9wcm9jZXNzX3JzcChzdHJ1Y3Qgc3JwX3JkbWFfY2ggKmNoLCBzdHJ1Y3Qgc3JwX3JzcCAqcnNw
KQ0KPiA+ICAJCXNjbW5kID0gc2NzaV9ob3N0X2ZpbmRfdGFnKHRhcmdldC0+c2NzaV9ob3N0LCBy
c3AtPnRhZyk7DQo+ID4gIAkJaWYgKHNjbW5kKSB7DQo+ID4gIAkJCXJlcSA9ICh2b2lkICopc2Nt
bmQtPmhvc3Rfc2NyaWJibGU7DQo+ID4gLQkJCXNjbW5kID0gc3JwX2NsYWltX3JlcShjaCwgcmVx
LCBOVUxMLCBzY21uZCk7DQo+ID4gKwkJCWlmIChyZXEpIHsNCj4gPiArCQkJCXNjbW5kID0gc3Jw
X2NsYWltX3JlcShjaCwgcmVxLCBOVUxMLCBzY21uZCk7DQo+ID4gKwkJCX0gZWxzZSB7DQo+ID4g
KwkJCQlzaG9zdF9wcmludGsoS0VSTl9FUlIsIHRhcmdldC0+c2NzaV9ob3N0LA0KPiA+ICsJCQkJ
CSAgICAgIk5VTEwgaG9zdF9zY3JpYmJsZSBmb3IgcmVzcG9uc2Ugd2l0aCB0YWcgJSNsbHhcbiIs
DQo+ID4gKwkJCQkJICAgICByc3AtPnRhZyk7DQo+ID4gKwkJCQlzY21uZCA9IE5VTEw7DQo+ID4g
KwkJCX0NCj4gPiAgCQl9DQo+ID4gIAkJaWYgKCFzY21uZCkgew0KPiA+ICAJCQlzaG9zdF9wcmlu
dGsoS0VSTl9FUlIsIHRhcmdldC0+c2NzaV9ob3N0LA0KPiANCj4gWW91IGhhdmUgdGhlIGNoYW5j
ZSB0byBwcmludCB0aGUgbWVzc2FnZSBiZWxvdyB0b2dldGhlciB3aXRoIHlvdXIgbmV3DQo+IHBy
aW50LCBiZWNhdXNlIHNjbWQgd2lsbCBiZSBOVUxMLg0KPiANCj4gV2hhdCBhYm91dCB0byBkbyB0
aGUgZm9sbG93aW5nIGNoZWNrICJpZiAoc2NtZCAmJiBzY21kLT5ob3N0X3NjcmliYmxlKSINCj4g
aW5zdGVhZCBvZiB5b3VyIHByb3Bvc2VkIHBhdGNoPw0KDQpUaGF0IGFwcHJvYWNoIHdvdWxkIHN0
aWxsIHRyaWdnZXIgYSBrZXJuZWwgb29wcyBpZiBhIGR1cGxpY2F0ZSByZXNwb25zZSBpcw0KcmVj
ZWl2ZWQgYmVjYXVzZSB0aGUgc2Vjb25kIGFyZ3VtZW50IG9mIHNycF9jbGFpbV9yZXEoKSBtdXN0
IG5vdCBiZSBOVUxMLg0KDQpCYXJ0Lg==
