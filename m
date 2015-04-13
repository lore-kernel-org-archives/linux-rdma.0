From: "Hefty, Sean" <sean.hefty@intel.com>
Subject: RE: [PATCH v3 05/28] IB/Verbs: Reform IB-core sa_query
Date: Mon, 13 Apr 2015 18:45:08 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FC0A58@ORSMSX109.amr.corp.intel.com>
References: <552BB470.4090407@profitbricks.com>
 <552BB572.4040300@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <552BB572.4040300@profitbricks.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Wang <yun.wang@profitbricks.com>, Roland Dreier <roland@kernel.org>, Hal Rosenstock <hal.rosenstock@gmail.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Tom Tucker <tom@opengridcomputing.com>, Steve Wise <swise@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, Christoph Raisch <raisch@de.ibm.com>, infinipath <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, "Latif, Faisal" <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, "Weiny, Ira" <ira.weiny@intel.com>, Tom Talpey <tom@talpey.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

PiBAQCAtMTE1Myw5ICsxMTUzLDcgQEAgc3RhdGljIHZvaWQgaWJfc2FfYWRkX29uZShzdHJ1Y3Qg
aWJfZGV2aWNlICpkZXZpY2UpDQo+ICB7DQo+ICAJc3RydWN0IGliX3NhX2RldmljZSAqc2FfZGV2
Ow0KPiAgCWludCBzLCBlLCBpOw0KPiAtDQo+IC0JaWYgKHJkbWFfbm9kZV9nZXRfdHJhbnNwb3J0
KGRldmljZS0+bm9kZV90eXBlKSAhPSBSRE1BX1RSQU5TUE9SVF9JQikNCj4gLQkJcmV0dXJuOw0K
PiArCWludCBjb3VudCA9IDA7DQo+IA0KPiAgCWlmIChkZXZpY2UtPm5vZGVfdHlwZSA9PSBSRE1B
X05PREVfSUJfU1dJVENIKQ0KPiAgCQlzID0gZSA9IDA7DQo+IEBAIC0xMTc1LDcgKzExNzMsNyBA
QCBzdGF0aWMgdm9pZCBpYl9zYV9hZGRfb25lKHN0cnVjdCBpYl9kZXZpY2UgKmRldmljZSkNCj4g
DQo+ICAJZm9yIChpID0gMDsgaSA8PSBlIC0gczsgKytpKSB7DQo+ICAJCXNwaW5fbG9ja19pbml0
KCZzYV9kZXYtPnBvcnRbaV0uYWhfbG9jayk7DQo+IC0JCWlmIChyZG1hX3BvcnRfZ2V0X2xpbmtf
bGF5ZXIoZGV2aWNlLCBpICsgMSkgIT0NCj4gSUJfTElOS19MQVlFUl9JTkZJTklCQU5EKQ0KPiAr
CQlpZiAoIXJkbWFfdGVjaF9pYihkZXZpY2UsIGkgKyAxKSkNCg0KTm90ZSBmb3Igc29tZW9uZSB3
aG8gY2FyZXMuICBUaGlzIHBhdGNoIGRpZG4ndCBpbnRyb2R1Y2UgdGhpcyBwcm9ibGVtLCBidXQg
SSB0aGluayB0aGUgcG9ydCBudW1iZXIgc2hvdWxkIGJlICJpICsgcyIuDQoNCg==
