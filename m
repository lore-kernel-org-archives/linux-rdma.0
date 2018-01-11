From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] RDMA/rxe: Fix a race condition related to the QP error
 state
Date: Thu, 11 Jan 2018 16:16:57 +0000
Message-ID: <1515687415.2752.6.camel@wdc.com>
References: <20180109192340.25702-1-bart.vanassche@wdc.com>
         <CAG9sBKM=Pfvis95=d9s=jObwVZR98Fj1HSqaOWYgnD-XQ1bYaQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <CAG9sBKM=Pfvis95=d9s=jObwVZR98Fj1HSqaOWYgnD-XQ1bYaQ@mail.gmail.com>
Content-Language: en-US
Content-ID: <52981C1906993849A390737FC8C63278@namprd04.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
To: "monis@mellanox.com" <monis@mellanox.com>
Cc: "jgg@mellanox.com" <jgg@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

T24gVGh1LCAyMDE4LTAxLTExIGF0IDEzOjI3ICswMjAwLCBNb25pIFNob3VhIHdyb3RlOg0KPiBN
YXliZSBJIGFtIG1pc3Npbmcgc29tZXRoaW5nIGJ1dCBJIHRoaW5rIHRoYXQgdGhlIHJhY2UgaXMg
d2hlbiBxcCBpcw0KPiBpbiBFUlJPUiBzdGF0ZSBhbmQgdGhlIGZvbGxvd2luZyBmdW5jdGlvbnMg
cnVuIGluIHBhcmFsbGVsDQo+ICogcnhlX2RyYWluX3JlcV9wa3RzIChjYWxsZWQgZnJvbSByeGVf
cmVxdWVzdGVyIGFmdGVyIHBvc3Rfc2VuZCkNCj4gKiByeGVfZHJhaW5fcmVzcF9wa3RzIChjYWxs
ZWQgZnJvbSByeGVfY29tcGxldGVyIGFmdGVyIG1vZGlmeSB0byBFUlJPUikNCj4gDQo+IEFtIEkg
cmlnaHQ/DQoNCkhlbGxvIE1vbmksDQoNCkkgdGhpbmsgdGhhdCdzIGEgcmVhbCByYWNlIGFuZCBh
IHJhY2UgdGhhdCBoYXMgdG8gYmUgZml4ZWQgYnV0IG5vdCB0aGUgcmFjZQ0KdGhhdCBjYXVzZWQg
dGhlIG1pc3NpbmcgY29tcGxldGlvbnMgaW4gdGhlIHRlc3RzIEkgcmFuIG15c2VsZi4NCg0KQmVz
dCByZWdhcmRzLA0KDQpCYXJ0Lg==
