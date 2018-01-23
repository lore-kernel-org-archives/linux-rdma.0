From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH rdma-next] RDMA/srpt: Fix RCU debug build error
Date: Tue, 23 Jan 2018 22:30:08 +0000
Message-ID: <1516746607.3339.47.camel@wdc.com>
References: <20180123115013.12213-1-leonro@mellanox.com>
         <20180123152142.GB30619@mellanox.com> <1516723456.3339.3.camel@wdc.com>
         <20180123185732.GA1393@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180123185732.GA1393-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Content-ID: <97DF7CA72BF45B4C94BBBD552C862094-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gVHVlLCAyMDE4LTAxLTIzIGF0IDIwOjU3ICswMjAwLCBMZW9uIFJvbWFub3Zza3kgd3JvdGU6
DQo+IFNvIGhvdyBhcmUgd2UgZ29pbmcgdG8gc29sdmUgdGhhdCByZG1hL2Zvci1uZXh0IGRvZXNu
J3QgY29tcGlsZT8NCg0KSG93IGFib3V0IHRoZSBmb2xsb3dpbmc/DQoNCltQQVRDSF0gSUIvc3Jw
dDogRml4IENPTkZJR19ERUJVR19PQkpFQ1RTX1JDVV9IRUFEPXkgYnVpbGQNCg0KQXZvaWQgdGhh
dCB0aGUga2VybmVsIGJ1aWxkIGZhaWxzIGFzIGZvbGxvd3MgaWYgUkNVIGRlYnVnZ2luZyBpcw0K
ZW5hYmxlZDoNCg0KRVJST1I6ICJpbml0X3JjdV9oZWFkIiBbZHJpdmVycy9pbmZpbmliYW5kL3Vs
cC9zcnB0L2liX3NycHQua29dIHVuZGVmaW5lZCENCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvaW5m
aW5pYmFuZC91bHAvc3JwdC9pYl9zcnB0LmMgYi9kcml2ZXJzL2luZmluaWJhbmQvdWxwL3NycHQv
aWJfc3JwdC5jDQppbmRleCA1Y2NjNzVjMzg5ZTIuLmE3OGE3OTc5MTk1MCAxMDA2NDQNCi0tLSBh
L2RyaXZlcnMvaW5maW5pYmFuZC91bHAvc3JwdC9pYl9zcnB0LmMNCisrKyBiL2RyaXZlcnMvaW5m
aW5pYmFuZC91bHAvc3JwdC9pYl9zcnB0LmMNCkBAIC0xOTc3LDcgKzE5NzcsNiBAQCBzdGF0aWMg
c3RydWN0IHNycHRfbmV4dXMgKnNycHRfZ2V0X25leHVzKHN0cnVjdCBzcnB0X3BvcnQgKnNwb3J0
LA0KIAkJCW5leHVzID0gRVJSX1BUUigtRU5PTUVNKTsNCiAJCQlicmVhazsNCiAJCX0NCi0JCWlu
aXRfcmN1X2hlYWQoJnRtcF9uZXh1cy0+cmN1KTsNCiAJCUlOSVRfTElTVF9IRUFEKCZ0bXBfbmV4
dXMtPmNoX2xpc3QpOw0KIAkJbWVtY3B5KHRtcF9uZXh1cy0+aV9wb3J0X2lkLCBpX3BvcnRfaWQs
IDE2KTsNCiAJCW1lbWNweSh0bXBfbmV4dXMtPnRfcG9ydF9pZCwgdF9wb3J0X2lkLCAxNik7DQpA
QCAtMjE0Nyw3ICsyMTQ2LDYgQEAgc3RhdGljIGludCBzcnB0X2NtX3JlcV9yZWN2KHN0cnVjdCBz
cnB0X2RldmljZSAqY29uc3Qgc2RldiwNCiAJCWdvdG8gcmVqZWN0Ow0KIAl9DQogDQotCWluaXRf
cmN1X2hlYWQoJmNoLT5yY3UpOw0KIAlrcmVmX2luaXQoJmNoLT5rcmVmKTsNCiAJY2gtPnBrZXkg
PSBiZTE2X3RvX2NwdShwa2V5KTsNCiAJY2gtPm5leHVzID0gbmV4dXM7DQo=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
