From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH] RDMA/cxgb3: Fix unintended sign extension
Date: Thu, 25 Oct 2018 16:03:35 +0000
Message-ID: <25e5b2a5255b42ca92add0177fa4832d@AcuMS.aculab.com>
References: <20181025143131.4048-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181025143131.4048-1-colin.king@canonical.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: 'Colin King' <colin.king@canonical.com>, Steve Wise <swise@chelsio.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Cc: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

RnJvbTogQ29saW4gS2luZw0KPiBTZW50OiAyNSBPY3RvYmVyIDIwMTggMTU6MzINCj4gDQo+IEZy
b206IENvbGluIElhbiBLaW5nIDxjb2xpbi5raW5nQGNhbm9uaWNhbC5jb20+DQo+IA0KPiBJbiB0
aGUgZXhwcmVzc2lvbiAidXR4X2xlbiA8PCAyOCIsIHV0eF9sZW4gc3RhcnRzIGFzIHU4LCBidXQg
aXMgcHJvbW90ZWQNCj4gdG8gYSBzaWduZWQgaW50LCB0aGVuIHNpZ24tZXh0ZW5kZWQgdG8gdTY0
LiAgSWYgdXR4X2xlbiBpcyAweGY4IG9yIGdyZWF0ZXINCj4gdGhlbiB0aGUgc2lnbiBleHRlbnNp
b24gd2lsbCBzZXQgYWxsIHRoZSB1cHBlciBiaXRzIG9mIHV0eF9jbWQgd2hpY2ggaXMNCj4gcHJv
YmFibHkgbm90IHdoYXQgd2FzIGludGVuZGVkLiAgQ2FzdCB0byB1dHhfbGVuIHRvIHU2NCAgdG8g
YXZvaWQgdGhlIHNpZ24NCj4gZXh0ZW5zaW9uLg0KDQpSVEZDLi4uDQp1dHhfbGVuIGlzIG9ubHkg
ZXZlciAxLCAyIG9yIDMuDQpUaGUgJ3Byb2JsZW0nIHdvdWxkIGFyaXNlIGlmIHV0eF9sZW4gPDwg
Mjggc2V0IHRoZSBoaWdoIGJpdC4NClRoaXMgY2FuIG9ubHkgaGFwcGVuIGlmIHV0eF9sZW4gaXMg
bW9yZSB0aGFuIDcgKE5GSSB3aGVyZSAweGY4IGNhbWUgZnJvbSkuDQoNCkluIGFueSBjYXNlIHRo
ZSBiZXN0IGZpeCBpcyB0byB1c2UgJ3Vuc2lnbmVkIGludCcgZm9yIHdyX2xlbiBhbmQgdXR4X2xl
bi4NClRoZXJlIGlzIG5vIHBvaW50IG1ha2luZyBsb2NhbCB2YXJpYWJsZSAob3IgZnVuY3Rpb25z
IHBhcmFtZXRlcnMvcmVzdWx0cykNCnNtYWxsZXIgdGhhdCAnaW50JyB1bmxlc3MgeW91IGV4cGxp
Y2l0bHkgd2FudCB0aGUgYXJpdGhtZXRpYyB0byB3cmFwLg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0
ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBL
ZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K
