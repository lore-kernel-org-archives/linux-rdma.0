From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH rdma-next v7 0/8] RDMA resource tracking
Date: Tue, 30 Jan 2018 21:22:03 +0000
Message-ID: <1517347322.2589.58.camel@wdc.com>
References: <1517256713.27592.241.camel@redhat.com>
         <20180130033436.GA17053@ziepe.ca> <20180130091654.GD2055@mtr-leonro.local>
         <034101d399de$01183730$0348a590$@opengridcomputing.com>
         <20180130155643.GC17053@ziepe.ca>
         <035a01d399e5$9ed499d0$dc7dcd70$@opengridcomputing.com>
         <20180130163330.GE17053@ziepe.ca> <1517339252.2589.34.camel@wdc.com>
         <20180130194639.GJ17053@ziepe.ca> <1517344962.2589.39.camel@wdc.com>
         <20180130204840.GK17053@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180130204840.GK17053-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Content-ID: <6955043BE856B94A8C6990BD2BF566D6-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "jgg-uk2M96/98Pc@public.gmane.org" <jgg-uk2M96/98Pc@public.gmane.org>
Cc: "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gVHVlLCAyMDE4LTAxLTMwIGF0IDEzOjQ4IC0wNzAwLCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6
DQo+IE9rLCBJIHRoaW5rIHRoYXQgaXMgdGhlIG9ubHkgbGlrZWx5IHRoaW5nIHJlY2VudGx5Li4N
Cj4gDQo+IEJ1dCB5b3VyIHByaW50IGFib3ZlIG11c3QgYmUgY2F1c2VkIGJ5IHRoaXMgbGluZSwg
cmlnaHQ6DQo+IA0KPiBzdGF0aWMgc3RydWN0IHNycF9mcl9wb29sICpzcnBfY3JlYXRlX2ZyX3Bv
b2woc3RydWN0IGliX2RldmljZSAqZGV2aWNlLA0KPiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgc3RydWN0IGliX3BkICpwZCwgaW50IHBvb2xfc2l6ZSwNCj4g
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGludCBtYXhfcGFn
ZV9saXN0X2xlbikNCj4gew0KPiAgICAgICAgIHJldCA9IC1FTk9NRU07DQo+ICAgICAgICAgcG9v
bCA9IGt6YWxsb2Moc2l6ZW9mKHN0cnVjdCBzcnBfZnJfcG9vbCkgKw0KPiAgICAgICAgICAgICAg
ICAgICAgICAgIHBvb2xfc2l6ZSAqIHNpemVvZihzdHJ1Y3Qgc3JwX2ZyX2Rlc2MpLCBHRlBfS0VS
TkVMKTsNCj4gICAgICAgICBpZiAoIXBvb2wpDQo+ICAgICAgICAgICAgICAgICBnb3RvIGVycjsN
Cj4gDQo+IFNpbmNlIHlvdSBkaWRuJ3QgcmVwb3J0IHRoZSBpYl9hbGxvY19tcigpIHByaW50IGl0
IGNhbid0IGJlIHRoZSBvdGhlcg0KPiBFTk9NRU0gY2FzZT8NCj4gDQo+IEhhcmQgdG8gc2VlIGhv
dyB0aGF0IGludGVyZXNlY3RzIHdpdGggcmVzb3VyY2UgdHJhY2tpbmcuLiBBcmUgeW91DQo+IHRo
aW5raW5nIG1lbW9yeSBjb3JydXB0aW9uPw0KDQpIZWxsbyBKYXNvbiwNCg0KSSBkb24ndCBzZWUg
YW55IHJlYXNvbiB0byBzdXNwZWN0IG1lbW9yeSBjb3JydXB0aW9uLiBrbWVtbGVhayBpc24ndCBy
ZXBvcnRpbmcNCmFueSBtZW1vcnkgbGVha3MuIE1heWJlIG1lbW9yeSBmcmFnbWVudGF0aW9uIGhh
cyBpbmNyZWFzZWQ/DQoNClRoYW5rcywNCg0KQmFydC4=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
