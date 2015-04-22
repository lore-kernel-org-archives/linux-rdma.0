From: "Hefty, Sean" <sean.hefty@intel.com>
Subject: RE: [PATCH v5 00/27] IB/Verbs: IB Management Helpers
Date: Wed, 22 Apr 2015 16:40:49 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FC64BD@ORSMSX109.amr.corp.intel.com>
References: <5534B8C9.506@profitbricks.com>
 <DB4PR05MB0863E9CCCD1BEA34F244EE2CB1EF0@DB4PR05MB0863.eurprd05.prod.outlook.com>
 <20150422024123.GA18675@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150422024123.GA18675@phlsvsds.ph.intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Weiny, Ira" <ira.weiny@intel.com>, Liran Liss <liranl@mellanox.com>
Cc: Michael Wang <yun.wang@profitbricks.com>, Roland Dreier <roland@kernel.org>, Hal Rosenstock <hal.rosenstock@gmail.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hal@dev.mellanox.co.il" <hal@dev.mellanox.co.il>, Tom Tucker <tom@opengridcomputing.com>, Steve Wise <swise@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, "raisch@de.ibm.com" <raisch@de.ibm.com>, infinipath <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, "Latif, Faisal" <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Tom Talpey <tom@talpey.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

PiA+IFNvLCBJIHRoaW5rIHRoYXQgb3VyICJvbGQtdHJhbnNwb3J0IiBiZWxvdyBpcyBqdXN0IGZp
bmUuDQo+ID4gTm8gbmVlZCB0byBjaGFuZ2UgaXQgKGFuZCB5b3UgYXJlbid0LCBzaW5jZSBpdCBp
cyBjdXJyZW50bHkgaW1wbGVtZW50ZWQNCj4gYXMgYSBmdW5jdGlvbikuDQo+IA0KPiBJIHRoaW5r
IHRoZXJlIGlzIGEgbmVlZCB0byBjaGFuZ2UgdGhpcy4gIEVuY29kaW5nIHRoZSB0cmFuc3BvcnQg
aW50byB0aGUNCj4gbm9kZQ0KPiB0eXBlIGlzIG5vdCBhIGdvb2QgaWRlYS4gIEhhdmluZyBkaWZm
ZXJlbnQgInRyYW5zcG9ydCBzZW1hbnRpY3MiIHdoaWxlDQo+IHN0aWxsDQo+IHJldHVybmluZyB0
aGUgc2FtZSB0cmFuc3BvcnQgZm9yIHRoZSBwb3J0IGlzIGNvbmZ1c2luZy4NCj4gDQo+IFRoZSBv
bmx5IHRoaW5nIHdoaWNoIGlzIGNsZWFyIGN1cnJlbnRseSBpcyBMaW5rIExheWVyLg0KPiANCj4g
QnV0IHRoZSB1c2Ugb2YgIkxpbmsgTGF5ZXIiIGluIHRoZSBjb2RlIGlzIHNvIGNvbnZvbHV0ZWQg
dGhhdCBpdCBpcyB2ZXJ5DQo+IGNvbmZ1c2luZy4NCg0KSSBhZ3JlZS4NCg0KT25lIGNvdWxkIGlt
cGxlbWVudCBzb2Z0d2FyZSBpV2FycCBvciBJQm9VRFAgKFJvQ0V2MikgcHJvdG9jb2xzIHRoYXQg
Y291bGQgcnVuIG92ZXIgYW55IGxpbmsgbGF5ZXIgYW5kIGludGVyb3BlcmF0ZSB3aXRoIGV4aXN0
aW5nIEhXIHNvbHV0aW9ucy4gIFRoZSBzdGFjayBzaG91bGRuJ3QgYmUgZGVhbGluZyB3aXRoIHRo
ZSBsaW5rIGxldmVsIGF0IGFsbCwgd2l0aCB0aGUgZXhjZXB0aW9uIG9mIHVzZXIgc3BhY2UgY29t
cGF0aWJpbGl0eS4NCg0KPiBEZWZpbmUgVHJhbnNwb3J0PyAgVGhlcmUgaGFzIGJlZW4gYSBsb3Qg
b2YgZGlzY3Vzc2lvbiBvdmVyIHdoYXQgYQ0KPiB0cmFuc3BvcnQgaXMNCj4gaW4gVmVyYnMuDQoN
CklNTywgd2Ugc2hvdWxkIHJlcGxhY2UgdXNpbmcgdGhlIHdvcmQgJ3RyYW5zcG9ydCcgd2l0aCBq
dXN0ICdyZG1hX3Byb3RvY29sJy4gIEFuZCBldmVuIHRoZW4gSSdtIG5vdCBjb252aW5jZWQgdGhh
dCBhbnl0aGluZyBzaG91bGQgY2FyZSwgYmV5b25kIHVzZXIgc3BhY2UgY29tcGF0aWJpbGl0eS4g
IFRoZSBjYXBzIGFyZSB3aGF0IG1hdHRlci4NCg0KLSBTZWFuDQoNCg==
