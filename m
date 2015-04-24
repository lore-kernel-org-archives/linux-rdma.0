From: Liran Liss <liranl@mellanox.com>
Subject: RE: [PATCH v5 00/27] IB/Verbs: IB Management Helpers
Date: Fri, 24 Apr 2015 14:49:49 +0000
Message-ID: <DB4PR05MB0863B7122F8FD7EFA4A80A9AB1EC0@DB4PR05MB0863.eurprd05.prod.outlook.com>
References: <5534B8C9.506@profitbricks.com>
 <DB4PR05MB0863E9CCCD1BEA34F244EE2CB1EF0@DB4PR05MB0863.eurprd05.prod.outlook.com>
 <20150422024123.GA18675@phlsvsds.ph.intel.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FC64BD@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FC64BD@ORSMSX109.amr.corp.intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Hefty, Sean" <sean.hefty@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Cc: Michael Wang <yun.wang@profitbricks.com>, Roland Dreier <roland@kernel.org>, Hal Rosenstock <hal.rosenstock@gmail.com>, "hal@dev.mellanox.co.il" <hal@dev.mellanox.co.il>, Tom Tucker <tom@opengridcomputing.com>, Steve Wise <swise@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, "raisch@de.ibm.com" <raisch@de.ibm.com>, infinipath <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, "Latif, Faisal" <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Tom Talpey <tom@talpey.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

PiBGcm9tOiBIZWZ0eSwgU2VhbiBbbWFpbHRvOnNlYW4uaGVmdHlAaW50ZWwuY29tXQ0KDQpbc25p
cF0NCj4gPiA+IFNvLCBJIHRoaW5rIHRoYXQgb3VyICJvbGQtdHJhbnNwb3J0IiBiZWxvdyBpcyBq
dXN0IGZpbmUuDQo+ID4gPiBObyBuZWVkIHRvIGNoYW5nZSBpdCAoYW5kIHlvdSBhcmVuJ3QsIHNp
bmNlIGl0IGlzIGN1cnJlbnRseQ0KPiA+ID4gaW1wbGVtZW50ZWQNCj4gPiBhcyBhIGZ1bmN0aW9u
KS4NCj4gPg0KPiA+IEkgdGhpbmsgdGhlcmUgaXMgYSBuZWVkIHRvIGNoYW5nZSB0aGlzLiAgRW5j
b2RpbmcgdGhlIHRyYW5zcG9ydCBpbnRvDQo+ID4gdGhlIG5vZGUgdHlwZSBpcyBub3QgYSBnb29k
IGlkZWEuICBIYXZpbmcgZGlmZmVyZW50ICJ0cmFuc3BvcnQNCj4gPiBzZW1hbnRpY3MiIHdoaWxl
IHN0aWxsIHJldHVybmluZyB0aGUgc2FtZSB0cmFuc3BvcnQgZm9yIHRoZSBwb3J0IGlzDQo+ID4g
Y29uZnVzaW5nLg0KPiA+DQo+ID4gVGhlIG9ubHkgdGhpbmcgd2hpY2ggaXMgY2xlYXIgY3VycmVu
dGx5IGlzIExpbmsgTGF5ZXIuDQo+ID4NCj4gPiBCdXQgdGhlIHVzZSBvZiAiTGluayBMYXllciIg
aW4gdGhlIGNvZGUgaXMgc28gY29udm9sdXRlZCB0aGF0IGl0IGlzDQo+ID4gdmVyeSBjb25mdXNp
bmcuDQo+IA0KPiBJIGFncmVlLg0KPiANCj4gT25lIGNvdWxkIGltcGxlbWVudCBzb2Z0d2FyZSBp
V2FycCBvciBJQm9VRFAgKFJvQ0V2MikgcHJvdG9jb2xzIHRoYXQNCj4gY291bGQgcnVuIG92ZXIg
YW55IGxpbmsgbGF5ZXIgYW5kIGludGVyb3BlcmF0ZSB3aXRoIGV4aXN0aW5nIEhXIHNvbHV0aW9u
cy4NCj4gVGhlIHN0YWNrIHNob3VsZG4ndCBiZSBkZWFsaW5nIHdpdGggdGhlIGxpbmsgbGV2ZWwg
YXQgYWxsLCB3aXRoIHRoZSBleGNlcHRpb24gb2YNCj4gdXNlciBzcGFjZSBjb21wYXRpYmlsaXR5
Lg0KPiANCj4gPiBEZWZpbmUgVHJhbnNwb3J0PyAgVGhlcmUgaGFzIGJlZW4gYSBsb3Qgb2YgZGlz
Y3Vzc2lvbiBvdmVyIHdoYXQgYQ0KPiA+IHRyYW5zcG9ydCBpcyBpbiBWZXJicy4NCj4gDQo+IElN
Tywgd2Ugc2hvdWxkIHJlcGxhY2UgdXNpbmcgdGhlIHdvcmQgJ3RyYW5zcG9ydCcgd2l0aCBqdXN0
ICdyZG1hX3Byb3RvY29sJy4NCj4gQW5kIGV2ZW4gdGhlbiBJJ20gbm90IGNvbnZpbmNlZCB0aGF0
IGFueXRoaW5nIHNob3VsZCBjYXJlLCBiZXlvbmQgdXNlcg0KPiBzcGFjZSBjb21wYXRpYmlsaXR5
LiAgVGhlIGNhcHMgYXJlIHdoYXQgbWF0dGVyLg0KPiANCj4gLSBTZWFuDQoNCkkgY29tcGxldGVs
eSBhZ3JlZS4NCklmIHdlIGV2ZXIgc2VlIGEgbmVlZCBmb3IgcmVwcmVzZW50aW5nIGEgc2V0IG9y
IHN1YnNldCBvZiBjcm9zcy1sYXllciBwcm90b2NvbHMgKGF0IGFueSBsZXZlbCwgTDItTDQsIHZh
cmlvdXMgZW5jYXBzdWxhdGlvbnMpLCB3ZSB3aWxsIGFkZCB0aGUgcHJvcGVyIG1hbmFnZW1lbnQg
aGVscGVycy4NCkZvciBleGFtcGxlOg0KLSByZG1hX3Byb3RvY29sX3JvY2UoKSAvKiBib3RoIHYx
IGFuZCB2MiAqLw0KLSByZG1hX3Byb3RvY29sX3JvY2VfdjEoKQ0KLSByZG1hX3Byb3RvY29sX3Jv
Y2VfdjIoKQ0KLSByZG1hX3Byb3RvY29sX3VzbmljKCkNCi0gcmRtYV9wcm90b2NvbF91c25pY191
ZHAoKQ0KDQo=
