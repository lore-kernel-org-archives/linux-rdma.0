From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH v2 0/5] Support for generalized use of make C={1,2} via a
 wrapper program
Date: Mon, 18 Dec 2017 17:56:57 +0000
Message-ID: <1513619815.2798.2.camel@wdc.com>
References: <cover.630ac8faeeda67bf7a778c158174422042942d08.1513430008.git-series.knut.omang@oracle.com>
         <20171216094745.5e41ac51@xeon-e3> <1513476850.31439.108.camel@oracle.com>
         <20171218050043.GA1307@ziepe.ca> <1513576817.31581.58.camel@perches.com>
         <20171218174604.GA19056@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171218174604.GA19056@ziepe.ca>
Content-Language: en-US
Content-ID: <5B34137F6E43E048AB6974A87AAEB18E@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "joe@perches.com" <joe@perches.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>
Cc: "corbet@lwn.net" <corbet@lwn.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "keescook@chromium.org" <keescook@chromium.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "willy@infradead.org" <willy@infradead.org>, "knut.omang@oracle.com" <knut.omang@oracle.com>, "nicolas.palix@imag.fr" <nicolas.palix@imag.fr>, "asmund.ostvold@oracle.com" <asmund.ostvold@oracle.com>, "john.haxby@oracle.com" <john.haxby@oracle.com>, "alexander.levin@verizon.com" <alexander.levin@verizon.com>, "mchehab@kernel.org" <mchehab@kernel.org>, "haakon.bugge@oracle.com" <haakon.bugge@oracle.com>, "michal.lkml@markovi.net" <michal.lkml@markovi.net>, "Gilles.Muller@lip6.fr" <Gilles.Muller@lip6.fr>, yama
List-Id: linux-rdma@vger.kernel.org

T24gTW9uLCAyMDE3LTEyLTE4IGF0IDEwOjQ2IC0wNzAwLCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6
DQo+IE9uIFN1biwgRGVjIDE3LCAyMDE3IGF0IDEwOjAwOjE3UE0gLTA4MDAsIEpvZSBQZXJjaGVz
IHdyb3RlOg0KPiANCj4gPiA+IFRvZGF5IHdoZW4gd2UgcnVuIGNoZWNrZXJzIHdlIGdldCBzbyBt
YW55IHdhcm5pbmdzIGl0IGlzIHRvbyBoYXJkIHRvDQo+ID4gPiBtYWtlIGFueSBzZW5zZSBvZiBp
dC4NCj4gPiANCj4gPiBIZXJlIGlzIGEgbGlzdCBvZiB0aGUgY2hlY2twYXRjaCBtZXNzYWdlcyBm
b3IgZHJpdmVycy9pbmZpbmliYW5kDQo+ID4gc29ydGVkIGJ5IHR5cGUuDQo+ID4gDQo+ID4gTWFu
eSBvZiB0aGVzZSBtaWdodCBiZSBjb3JyZWN0ZWQgYnkgdXNpbmcNCj4gPiANCj4gPiAkIC4vc2Ny
aXB0cy9jaGVja3BhdGNoLnBsIC1mIC0tZml4LWlucGxhY2UgLS10eXBlcz08VFlQRT4gXA0KPiA+
ICAgJChnaXQgbHMtZmlsZXMgZHJpdmVycy9pbmZpbmliYW5kLykNCj4gDQo+IEhvdyBtYW55IG9m
IHRoZXNlIGRvIHlvdSB0aGluayBpdCBpcyB3b3J0aCB0byBmaXg/DQo+IA0KPiBXZSBkbyBnZXQg
YSBzdGVhZHkgdHJpY2tsZSBvZiBjaGFuZ2VzIGluIHRoaXMgdG9waWMgZXZlcnkgY3ljbGUuDQo+
IA0KPiBJcyBpdCBiZXR0ZXIgdG8ganVzdCBkbyBhIGJpZyBudW1iZXIgb2YgdGhlbSBhbGwgYXQg
b25jZT8gRG8geW91IGhhdmUNCj4gYW4gaWRlYSBob3cgZGlzcnVwdGl2ZSB0aGlzIGtpbmQgb2Yg
d29yayBpcyB0byB0aGUgd2hvbGUgcGF0Y2ggZmxvdw0KPiBlZyBuZXcgcGF0Y2hlcyBubyBsb25n
ZXIgYXBwbHlpbmcgdG8gZm9yLW5leHQsIGJhY2twb3J0cyBubyBsb25nZXINCj4gYXBwbHlpbmcs
IG1lcmdlIGNvbmZsaWN0cz8NCg0KSW4gbXkgb3BpbmlvbiBwYXRjaGVzIHRoYXQgb25seSBjaGFu
Z2UgdGhlIGNvZGluZyBzdHlsZSBhbmQgZG8gbm90IGNoYW5nZSBhbnkNCmZ1bmN0aW9uYWxpdHkg
YXJlIGFubm95aW5nLiBCZWZvcmUgcG9zdGluZyBhIHBhdGNoIHRoYXQgZml4ZXMgYSBidWcgdGhl
IGNoYW5nZQ0KaGlzdG9yeSAoZ2l0IGxvZyAtcCkgaGFzIHRvIGJlIGNoZWNoZWQgdG8gZmlndXJl
IG91dCB3aGljaCBwYXRjaCBpbnRyb2R1Y2VkDQp0aGUgYnVnLiBQYXRjaGVzIHRoYXQgb25seSBj
aGFuZ2UgY29kaW5nIHN0eWxlIHBvbGx1dGUgdGhlIGNoYW5nZSBoaXN0b3J5Lg0KDQpCYXJ0Lg==
