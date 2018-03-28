From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: RFC on writel and writel_relaxed
Date: Wed, 28 Mar 2018 16:16:08 +0000
Message-ID: <a0cfcb83e2c34ae399beeea65582ff99@AcuMS.aculab.com>
References: <1e077f6a-90b6-cce9-6f0f-a8c003fec850@codeaurora.org>
         <20180327151029.GB17494@arm.com>
         <CAKgT0Uem6HT-Z=HBnSVcC4rnDL0yFyXEbr+FN3YYkJ=ExZpUPQ@mail.gmail.com>
         <1522186396.7364.61.camel@kernel.crashing.org>
         <CA+55aFw2R4pirO0m+jtj4F8AF2-tVi3guEaWOA-EBqNyFmh29w@mail.gmail.com>
         <1522198981.7364.81.camel@kernel.crashing.org>
         <CA+55aFyTeuXPmC5-1JGh2ow-rf5wMA6Vcv0aeS_q0_EnptSK9Q@mail.gmail.com>
         <1522211620.7364.94.camel@kernel.crashing.org>
         <CA+55aFw24R3YAujir59GdG+sBBQOA9WyXySEN3AcEYK99ZHuwQ@mail.gmail.com>
         <1522219376.7364.109.camel@kernel.crashing.org>
         <20180328090710.GB28871@arm.com>
         <1522230988.21446.7.camel@kernel.crashing.org>
         <a642dc060b484d98bc728eb1f4b5c600@AcuMS.aculab.com>
 <1522249950.21446.23.camel@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1522249950.21446.23.camel@kernel.crashing.org>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: 'Benjamin Herrenschmidt' <benh@kernel.crashing.org>, Will Deacon <will.deacon@arm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Alexander Duyck <alexander.duyck@gmail.com>, Sinan Kaya <okaya@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>, Oliver <oohall@gmail.com>, "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" <linuxppc-dev@lists.ozlabs.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

RnJvbTogQmVuamFtaW4gSGVycmVuc2NobWlkdA0KPiBTZW50OiAyOCBNYXJjaCAyMDE4IDE2OjEz
DQouLi4NCj4gPiBJJ3ZlIGFsd2F5cyB3b25kZXJlZCBleGFjdGx5IHdoYXQgdGhlIHR3aTtpc3lu
YyB3ZXJlIGZvciAtIGFsd2F5cyBzZWVtZWQNCj4gPiB2ZXJ5IGhlYXZ5IGhhbmRlZCBmb3IgbW9z
dCBtbWlvIHJlYWRzLg0KPiA+IFBhcnRpY3VsYXJseSBpZiB5b3UgYXJlIGRvaW5nIG1taW8gcmVh
ZHMgZnJvbSBhIGRhdGEgZmlmby4NCj4gDQo+IElmIHlvdSBkbyB0aGF0IHlvdSBzaG91bGQgdXNl
IHRoZSAicyIgdmVyc2lvbiBvZiB0aGUgYWNjZXNzb3JzLiBUaG9zZQ0KPiB3aWxsIG9ubHkgZG8g
dGhlIGFib3ZlIHRyaWNrIGF0IHRoZSBlbmQgb2YgdGhlIGFjY2VzcyBzZXJpZXMuIEFsc28gYQ0K
PiBGSUZPIG5lZWRzIHNwZWNpYWwgY2FyZSBhYm91dCBlbmRpYW5uZXNzIGFueXdheSwgc28geW91
IHNob3VsZCB1c2UNCj4gdGhvc2UgYWNjZXNzb3JzIHJlZ2FyZGxlc3MuIChIaW50OiB5b3UgbmV2
ZXIgZW5kaWFuIHN3YXAgYSBGSUZPIGV2ZW4gb24NCj4gQkUgb24gYSBMRSBkZXZpY2UsIHVubGVz
cyBzb21ldGhpbmcncyBiZWVuIHdpcmVkIHZlcnkgYmFkbHkgaW4gSFcpLg0KDQpUaGF0IHdhcyBh
Y3R1YWxseSBhIDY0IGJpdCB3aWRlIGZpZm8gY29ubmVjdGVkIHRvIGEgMTZiaXQgd2lkZSBQSU8g
aW50ZXJmYWNlLg0KUmVhZGluZyB0aGUgaGlnaCBhZGRyZXNzICdjbG9ja2VkJyB0aGUgZmlmby4N
ClNvIHRoZSBmaXJzdCAzIHJlYWRzIGNvdWxkIGhhcHBlbiBpbiBhbnkgb3JkZXIsIGJ1dCB0aGUg
NHRoIGhhZCB0byBiZSBsYXN0Lg0KVGhpcyBpcyBhIHNtYWxsIHBwYyBhbmQgd2Ugc2hvdmVsIGEg
bG90IG9mIGRhdGEgdGhyb3VnaCB0aGF0IGZpZm8uDQoNCldoZXRoZXIgaXQgbmVlZGVkIGJ5dGVz
d2FwcGluZyBkZXBlbmRlZCBjb21wbGV0ZWx5IG9uIGhvdyBvdXIgaGFyZHdhcmUgcGVvcGxlDQpo
YWQgYnVpbHQgdGhlIHBjYiAobm90IG1hZGUgZWFzeSBieSBzb21lIGRvY3MgdXNpbmcgdGhlIGli
bSBiaXQgbnVtYmVyaW5nKS4NCkluIGZhY3QgaXQgZGlkbid0Li4uLg0KDQpXaGlsZSB0aGF0IGRy
aXZlciBvbmx5IGhhZCB0byBydW4gb24gYSB2ZXJ5IHNwZWNpZmljIHNtYWxsIHBwYywgZ2VuZXJp
YyBkcml2ZXJzDQptaWdodCBoYXZlIHNpbWlsYXIgaXNzdWVzLg0KDQpJIHN1c3BlY3QgdGhhdCB3
cml0ZWwoKSBpcyBhbHdheXMgKG9yIHNob3VsZCBhbHdheXMgYmUpOg0KCWJhcnJpZXJfYmVmb3Jl
X3dyaXRlbCgpDQoJd3JpdGVsX3JlbGF4ZWQoKQ0KCWJhcnJpZXJfYWZ0ZXJfd3JpdGVsKCkNClNv
IGlmIGEgZHJpdmVyIG5lZWRzIHRvIGRvIG11bHRpcGxlIHdyaXRlcyAod2l0aG91dCBzdHJvbmcg
b3JkZXJpbmcpDQppdCBzaG91bGQgYmUgYWJsZSB0byByZXBlYXQgdGhlIHdyaXRlbF9yZWxheGVk
KCkgd2l0aCBvbmx5IG9uZSBzZXQNCm9mIGJhcnJpZXJzLg0KU2ltaWxhcmx5IGZvciByZWFkbCgp
Lg0KSW4gYWRkaXRpb24gYSBsZXNzZXIgYmFycmllciBpcyBwcm9iYWJseSBlbm91Z2ggYmV0d2Vl
biBhIHJlYWRsX3JlbGF4ZWQoKQ0KYW5kIGEgd3JpdGVsX3JlbGF4ZWQoKSB0aGF0IGlzIGNvbmRp
dGlvbmFsIG9uIHRoZSByZWFkIHZhbHVlLg0KDQoJRGF2aWQNCg0K
