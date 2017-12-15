From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH rdma-core] srp_daemon: Install signal handler for ibsrpdm
Date: Fri, 15 Dec 2017 17:50:54 +0000
Message-ID: <1513360253.2571.23.camel@wdc.com>
References: <20171214110241.4701-1-honli@redhat.com>
         <1513263572.2986.2.camel@wdc.com>
         <20171215013628.GA743@dhcp-13-42.nay.redhat.com>
         <20171215172800.GA12434@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171215172800.GA12434-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Content-ID: <920CB7711DA9754F92A987BF31D6ED6F-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "jgg-uk2M96/98Pc@public.gmane.org" <jgg-uk2M96/98Pc@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gRnJpLCAyMDE3LTEyLTE1IGF0IDEwOjI4IC0wNzAwLCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6
DQo+IFRob3VnaCBvdmVyYWxsLCB0aGVyZSBpcyByZWFsbHkgbm8gcmVhc29uIHRvIGV2ZW4gY2xl
YW51cCB0aGUgdGhyZWFkcywNCj4ganVzdCBjYWxsIGV4aXQ/DQoNCk1lbW9yeSBsZWFrIGRldGVj
dG9ycyBsaWtlIHRoZSBvbmUgaW4gVmFsZ3JpbmQgb25seSBwcm9kdWNlIG1lYW5pbmdmdWwgcmVz
dWx0cw0KaWYgdGhyZWFkcyBhcmUgc3RvcHBlZCBjbGVhbmx5IGJlZm9yZSBleGl0KCkgaXMgY2Fs
bGVkLg0KDQo+IEBAIC0xODg3LDcgKzE4ODgsOSBAQCBzdGF0aWMgdm9pZCBmcmVlX3JlcyhzdHJ1
Y3QgcmVzb3VyY2VzICpyZXMpDQo+ICAJCW1vZGlmeV9xcF90b19lcnIocmVzLT51ZF9yZXMtPnFw
KTsNCj4gIA0KPiAgCWlmIChyZXMtPnJlY29ubmVjdF90aHJlYWQpIHsNCj4gLQkJcHRocmVhZF9r
aWxsKHJlcy0+cmVjb25uZWN0X3RocmVhZCwgU0lHSU5UKTsNCj4gKwkJdWludDY0X3QgdmFsID0g
MTsNCj4gKw0KPiArCQl3cml0ZShyZXMtPnN5bmNfcmVzLT5zdG9wX2V2ZW50X2ZkLCAmdmFsLCBz
aXplb2YodmFsKSk7DQo+ICAJCXB0aHJlYWRfam9pbihyZXMtPnJlY29ubmVjdF90aHJlYWQsICZz
dGF0dXMpOw0KDQpUaGlzIHBhdGNoIGRvZXMgbm90IHJlbW92ZSBhbGwgcHRocmVhZF9raWxsKCkg
Y2FsbHMuIFRoZXJlIGFyZSB0d28gb3RoZXIgc3VjaA0KY2FsbHM6DQoNCiQgZ2l0IGdyZXAgLW5I
dyBwdGhyZWFkX2tpbGwNCnNycF9kYWVtb24vc3JwX2RhZW1vbi5jOjE4OTc6CQlwdGhyZWFkX2tp
bGwocmVzLT5hc3luY19ldl90aHJlYWQsIFNJR0lOVCk7DQpzcnBfZGFlbW9uL3NycF9kYWVtb24u
YzoxOTAxOgkJcHRocmVhZF9raWxsKHJlcy0+dHJhcF90aHJlYWQsIFNJR0lOVCk7DQoNCkJhcnQu
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
