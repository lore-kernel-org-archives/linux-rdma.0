From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: Kernel v4.16 / v4.17 SRP and SRPT patches
Date: Wed, 10 Jan 2018 18:40:25 +0000
Message-ID: <1515609623.2745.20.camel@wdc.com>
References: <5a5016c0.4c0a620a.ed2b3.60da@mx.google.com>
         <fcc3f226-848d-abc4-2a81-f4fd821761c9@wdc.com>
         <1515528956.3919.3.camel@redhat.com> <1515529869.3919.4.camel@redhat.com>
         <1515531079.2721.26.camel@wdc.com> <1515531652.26021.1.camel@redhat.com>
         <1515537614.26021.3.camel@redhat.com> <1515591723.26021.6.camel@redhat.com>
         <20180110182648.GI4518@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180110182648.GI4518-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Content-ID: <5513D3E83987DC4FA6B376AEA8DA7B49-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "jgg-uk2M96/98Pc@public.gmane.org" <jgg-uk2M96/98Pc@public.gmane.org>, "loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gV2VkLCAyMDE4LTAxLTEwIGF0IDExOjI2IC0wNzAwLCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6
DQo+IE9uIFdlZCwgSmFuIDEwLCAyMDE4IGF0IDA4OjQyOjAzQU0gLTA1MDAsIExhdXJlbmNlIE9i
ZXJtYW4gd3JvdGU6DQo+IA0KPiA+IFsgIDk0Ni42NDc1MTRdIGtlcm5lbCB0cmllZCB0byBleGVj
dXRlIE5YLXByb3RlY3RlZCBwYWdlIC0gZXhwbG9pdA0KPiA+IGF0dGVtcHQ/ICh1aWQ6IDApDQo+
ID4gWyAgOTQ2LjY5MTk1NF0gQlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5lbCBwYWdpbmcgcmVx
dWVzdCBhdA0KPiA+IDAwMDAwMDAwYTIxMjliOTMNCj4gPiBbICA5NDcuODg5NTUyXSBDYWxsIFRy
YWNlOg0KPiA+IFsgIDk0Ny45MDM3MjRdICA/IF9faWJfcHJvY2Vzc19jcSsweDU1LzB4YTAgW2li
X2NvcmVdDQo+ID4gWyAgOTQ3LjkzMTE3OV0gID8gaWJfY3FfcG9sbF93b3JrKzB4MWIvMHg2MCBb
aWJfY29yZV0NCj4gPiBbICA5NDcuOTU4MTUzXSAgPyBwcm9jZXNzX29uZV93b3JrKzB4MTQxLzB4
MzQwDQo+ID4gWyAgOTQ3Ljk4MTM2Ml0gID8gd29ya2VyX3RocmVhZCsweDQ3LzB4M2UwDQo+ID4g
WyAgOTQ4LjAwMjEwMl0gID8ga3RocmVhZCsweGY1LzB4MTMwDQo+ID4gWyAgOTQ4LjAyMDUzOF0g
ID8gcmVzY3Vlcl90aHJlYWQrMHgzODAvMHgzODANCj4gPiBbICA5NDguMDQzMTgwXSAgPyBrdGhy
ZWFkX2Fzc29jaWF0ZV9ibGtjZysweDkwLzB4OTANCj4gPiBbICA5NDguMDcwMTg0XSAgPyByZXRf
ZnJvbV9mb3JrKzB4MWYvMHgzMA0KPiANCj4gVGhlc2Ugb29wcydzIHlvdSBoYXZlIGFyZSB2ZXJ5
IHN1Z2dlc3RpdmUgdGhhdCBpYl93Yy0+d3JfY3FlDQo+IGlzIGdhcmJhZ2UuLg0KPiANCj4gRGlk
IFNSUCBmcmVlIGl0cyB3cl9jcWUgZGF0YSBiZWZvcmUgY29tcGxldGlvbiBzb21laG93Pw0KPiAN
Cj4gVHVybiBvbiBzbGFiIHBvaXNvbmluZyB0byBjb25maXJtPw0KDQpIZWxsbyBKYXNvbiwNCg0K
SXQncyBlYXN5IHRvIHNlZSBpbiBkcml2ZXJzL2luZmluaWJhbmQvY29yZS9jcS5jIHRoYXQgcG9s
bGluZyBpcyBzdG9wcGVkDQpiZWZvcmUgYSBjb21wbGV0aW9uIHF1ZXVlIGlzIGRlc3Ryb3llZCAo
c2VlIGFsc28gdGhlIGNhbmNlbF93b3JrX3N5bmMoJmNxLT53b3JrKQ0KYW5kIHRoZSBjcS0+ZGV2
aWNlLT5kZXN0cm95X2NxKGNxKSBjYWxscyBpbiBpYl9mcmVlX2NxKCkpLg0KDQpCVFcsIEkgcnVu
IGFsbCBteSB0ZXN0cyB3aXRoIFNMQUIgcG9pc29uaW5nIGVuYWJsZWQuIE15IFNSUCB0ZXN0cyBw
YXNzIGlmIEkgcnVuDQp0aGUgU1JQIGluaXRpYXRvciBhbmQgdGFyZ2V0IGRyaXZlcnMgb24gdG9w
IG9mIHRoZSBtbHg0IGFuZCByZG1hX3J4ZSBkcml2ZXJzLg0KDQpCYXJ0Lg==
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
