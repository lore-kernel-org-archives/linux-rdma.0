From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH, resend 4/4] IB/srp: Add RDMA/CM support
Date: Fri, 5 Jan 2018 20:53:33 +0000
Message-ID: <1515185611.3254.21.camel@wdc.com>
References: <20180104222842.26756-1-bart.vanassche@wdc.com>
         <20180104222842.26756-5-bart.vanassche@wdc.com>
         <1515172870.3403.11.camel@redhat.com> <20180105173448.GY11348@ziepe.ca>
         <1515175618.3403.26.camel@redhat.com> <20180105192549.GA11348@ziepe.ca>
         <1515183835.3403.62.camel@redhat.com> <20180105203506.GD11348@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180105203506.GD11348-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Content-ID: <B57C648CC8F1E543AE87C029BFCF84CB-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "jgg-uk2M96/98Pc@public.gmane.org" <jgg-uk2M96/98Pc@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gRnJpLCAyMDE4LTAxLTA1IGF0IDEzOjM1IC0wNzAwLCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6
DQo+IEFueWhvdy4gQmFydCBzaG91bGQgbG9vayBhdCB3aGF0IGlzY3NpIGRvZXMgZm9yIG5hbWVz
cGFjZXMgYW5kIGNvcHkNCj4gdGhhdC4uIE5vIHNlbnNlIGluIGludmVudGluZyBzb21ldGhpbmcg
dW5pcXVlIGZvciBSRE1BLg0KDQpVbmxlc3MgaWYgSSBtaXNzZWQgc29tZXRoaW5nLCBuZXR3b3Jr
IG5hbWVzcGFjZSBzdXBwb3J0IHNlZW1zIHRvIGJlIG1pc3NpbmcNCmZyb20gdGhlIGlTQ1NJIGFu
ZCBGQ29FIGluaXRpYXRvciBkcml2ZXJzOg0KDQokIGdpdCBncmVwIC1uSCAnc3RydWN0IG5ldFte
WzphbG51bTpdX10nICovc2NzaQ0KJCBnaXQgZ3JlcCAtbkggJ2luaXRfbmV0JyAqL3Njc2kNCmRy
aXZlcnMvc2NzaS9jeGdiaS9saWJjeGdiaS5jOjU5MzoJcnQgPSBpcF9yb3V0ZV9vdXRwdXRfcG9y
dHMoJmluaXRfbmV0LCBmbDQsIE5VTEwsIGRhZGRyLCBzYWRkciwNCmRyaXZlcnMvc2NzaS9jeGdi
aS9saWJjeGdiaS5jOjY0MjoJCW5kZXYgPSBpcF9kZXZfZmluZCgmaW5pdF9uZXQsIGRhZGRyLT5z
aW5fYWRkci5zX2FkZHIpOw0KZHJpdmVycy9zY3NpL2N4Z2JpL2xpYmN4Z2JpLmM6NzA4OglyZXR1
cm4gKHN0cnVjdCBydDZfaW5mbyAqKWlwNl9yb3V0ZV9vdXRwdXQoJmluaXRfbmV0LCBOVUxMLCAm
ZmwpOw0KZHJpdmVycy9zY3NpL2N4Z2JpL2xpYmN4Z2JpLmM6NzkwOgkJZXJyID0gaXB2Nl9kZXZf
Z2V0X3NhZGRyKCZpbml0X25ldCwgaWRldiA/IGlkZXYtPmRldiA6IE5VTEwsDQpkcml2ZXJzL3Nj
c2kvZmNvZS9mY29lLmM6MTgxNToJbmV0ZGV2ID0gZGV2X2dldF9ieV9pbmRleCgmaW5pdF9uZXQs
IGVudHJ5LT5pZmluZGV4KTsNCmRyaXZlcnMvc2NzaS9mY29lL2Zjb2VfdHJhbnNwb3J0LmM6NzI3
OgkJcmV0dXJuIGRldl9nZXRfYnlfbmFtZSgmaW5pdF9uZXQsIGlmbmFtZSk7DQpkcml2ZXJzL3Nj
c2kvc2NzaV9uZXRsaW5rLmM6MTMzOglzY3NpX25sX3NvY2sgPSBuZXRsaW5rX2tlcm5lbF9jcmVh
dGUoJmluaXRfbmV0LCBORVRMSU5LX1NDU0lUUkFOU1BPUlQsDQpkcml2ZXJzL3Njc2kvc2NzaV90
cmFuc3BvcnRfaXNjc2kuYzo0NTMzOglubHMgPSBuZXRsaW5rX2tlcm5lbF9jcmVhdGUoJmluaXRf
bmV0LCBORVRMSU5LX0lTQ1NJLCAmY2ZnKTsNCg0KQmFydC4=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
