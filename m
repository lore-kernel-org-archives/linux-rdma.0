From: "Hefty, Sean" <sean.hefty@intel.com>
Subject: RE: [PATCH RFC] IB/verbs: introduce rdma_transport_is_ib() to check
 transport type
Date: Thu, 19 Mar 2015 17:02:28 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237399E821EA@ORSMSX109.amr.corp.intel.com>
References: <550AD2D6.7030800@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <550AD2D6.7030800@profitbricks.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Wang <yun.wang@profitbricks.com>, Roland Dreier <roland@kernel.org>, Hal Rosenstock <hal.rosenstock@gmail.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Or Gerlitz <ogerlitz@mellanox.com>, "Weiny, Ira" <ira.weiny@intel.com>, Moni Shoua <monis@mellanox.com>, "Nikolova, Tatyana E" <tatyana.e.nikolova@intel.com>, Steve Wise <swise@opengridcomputing.com>, Yan Burman <yanb@mellanox.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Bart Van Assche <bvanassche@acm.org>, Yann Droneaud <ydroneaud@opteya.com>, "David S. Miller" <davem@davemloft.net>, "Estrin, Alex" <alex.estrin@intel.com>, Doug Ledford <dledford@redhat.com>, Eric Dumazet <edumazet@google.com>, Erez Shitrit <erezsh@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Sagi Grimberg <sagig@mellanox.com>, Shachar Raindel <raindel@mellanox.com>, Eli Cohen <eli@dev.mellanox.co.il>, Matan Barak <matanb@mellanox.com>, "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
List-Id: linux-rdma@vger.kernel.org

PiBXZSBoYXZlIHBsZW50eSBvZiBwbGFjZXMgd2hlcmUgd2UgZG9uJ3QgY2FyZSB3aGF0IGV4YWN0
bHkgdGhlDQo+IHRyYW5zcG9ydCB0eXBlIGlzLCBidXQgb25seSBjYXJlIGlmIGl0J3MgSUIgdHlw
ZS4NCj4gDQo+IFRoaXMgcGF0Y2ggaW50cm9kdWNlIHJkbWFfdHJhbnNwb3J0X2lzX2liKCkgYXMg
c2hvcnRjdXRzIHRvIGNoZWNrDQo+IHdoZXRoZXIgYW4gJ2liX2RldmljZScgaXMgaW5maW5pYmFu
ZCB0cmFuc3BvcnQgdHlwZSwgd2hpY2ggaGVscCB1cyB0bw0KPiBzYXZlIHNvbWUgY29kZS4NCg0K
SW4gbW9zdCBvZiB0aGVzZSBwbGFjZXMsIHRoZSBjaGVjayB0aGF0IHdlIHdhbnQgaXMgd2hldGhl
ciBJQiBtYW5hZ2VtZW50IGlzIHVzZWQuICBUaGUgdHJhbnNwb3J0IGNoZWNrIGlzIGFuIGluZGly
ZWN0IHdheSBvZiBjaGVja2luZyBmb3IgdGhhdCwgYW5kIEkgYmVsaWV2ZSB3ZSBzaG91bGQgdXNl
IGEgbW9yZSBkaXJlY3QgbWV0aG9kIG9mIGNoZWNraW5nIGZvciB0aGUgZnVuY3Rpb25hbGl0eSB0
aGF0J3MgYWN0dWFsbHkgZGVzaXJlZC4NCg0KUGxlYXNlIHNlZSB0aGUgZm9sbG93aW5nIHRocmVh
ZCB0aGF0IGlzIHJlbGF0ZWQgdG8gdGhlc2UgY2hhbmdlczoNCg0KaHR0cDovL3d3dy5zcGluaWNz
Lm5ldC9saXN0cy9saW51eC1yZG1hL21zZzIzNDg0Lmh0bWwNCg0KLSBTZWFuDQo=
