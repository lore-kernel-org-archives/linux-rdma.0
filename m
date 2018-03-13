From: "Stephen  Bates" <sbates@raithlin.com>
Subject: Re: [PATCH v3 01/11] PCI/P2PDMA: Support peer-to-peer memory
Date: Tue, 13 Mar 2018 22:45:41 +0000
Message-ID: <47F026DE-AFD0-4F63-8D39-375D3684C7B1@raithlin.com>
References: <20180312193525.2855-1-logang@deltatee.com>
 <20180312193525.2855-2-logang@deltatee.com>
 <59fd2f5d-177f-334a-a9c4-0f8a6ec7c303@codeaurora.org>
 <24d8e5c2-065d-8bde-3f5d-7f158be9c578@deltatee.com>
 <52cbbbc4-c488-f83f-8d02-14d455b4efd7@codeaurora.org>
 <3e738f95-d73c-4182-2fa1-8664aafb1ab7@deltatee.com>
 <703aa92c-0c1c-4852-5887-6f6e6ccde0fb@codeaurora.org>
 <a0af83f8-2cbc-862b-6f8b-231991527cfc@deltatee.com>
 <3ea80992-a0fc-08f2-d93d-ae0ec4e3f4ce@codeaurora.org>
 <4eb6850c-df1b-fd44-3ee0-d43a50270b53@deltatee.com>
 <757fca36-dee4-e070-669e-f2788bd78e41@codeaurora.org>
 <4f761f55-4e9a-dccb-d12f-c59d2cd689db@deltatee.com>
 <016dc910-f96a-8a60-4bda-fa24eea98ea5@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <016dc910-f96a-8a60-4bda-fa24eea98ea5@codeaurora.org>
Content-Language: en-US
Content-ID: <CBB285235DCCC44AADEE04E9322EF6A5@CANPRD01.PROD.OUTLOOK.COM>
Sender: linux-kernel-owner@vger.kernel.org
To: Sinan Kaya <okaya@codeaurora.org>, Logan Gunthorpe <logang@deltatee.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Bjorn Helgaas <bhelgaas@google.com>, Jason Gunthorpe <jgg@mellanox.com>, Max Gurtovoy <maxg@mellanox.com>, Dan Williams <dan.j.williams@intel.com>, =?utf-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Alex Williamson <alex.williamson@redhat.com>
List-Id: linux-rdma@vger.kernel.org

SGkgU2luYW4NCg0KPiAgICBJZiBoYXJkd2FyZSBkb2Vzbid0IHN1cHBvcnQgaXQsIGJsYWNrbGlz
dGluZyBzaG91bGQgaGF2ZSBiZWVuIHRoZSByaWdodA0KPiAgICBwYXRoIGFuZCBJIHN0aWxsIHRo
aW5rIHRoYXQgeW91IHNob3VsZCByZW1vdmUgYWxsIHN3aXRjaCBidXNpbmVzcyBmcm9tIHRoZSBj
b2RlLg0KPiAgICBJIGRpZCBub3QgaGVhciBlbm91Z2gganVzdGlmaWNhdGlvbiBmb3IgaGF2aW5n
IGEgc3dpdGNoIHJlcXVpcmVtZW50DQo+ICAgIGZvciBQMlAuDQogIA0KV2UgZGlzYWdyZWUuIEFz
IGRvZXMgdGhlIGNvbW11bml0eSBiYXNlZCBvbiBmZWVkYmFjayBvbiBwcmV2aW91cyB2ZXJzaW9u
IG9mIHRoaXMgcGF0Y2ggc2V0Lg0KICANCj4gWW91IGFyZSBhbHNvIHNheWluZyB0aGF0IHJvb3Qg
cG9ydHMgaGF2ZSBpc3N1ZXMgbm90IGJlY2F1c2Ugb2YgZnVuY3Rpb25hbGl0eSBidXQNCj4gYmVj
YXVzZSBvZiBwZXJmb3JtYW5jZS4gDQoNCkkgaGF2ZSBzZWVuIGJvdGguICBTb21lIHN5c3RlbXMg
ZmFpbCBpbiBlbnRpcmV0eSB0byByb3V0ZSBUTFBzIGFjcm9zcyByb3V0ZSBwb3J0cy4gT3RoZXJz
IGRvIHJvdXRlIGJ1dCB3aXRoIHBvb3IgcGVyZm9ybWFuY2UuIEhhdmluZyBhIHJlcXVpcmVtZW50
IGZvciBhIHN3aXRjaCBpcyB0aGVyZWZvcmUgYSByZWFzb25hYmxlIGFuZCBzZW5zaWJsZSBtaW5p
bXVtIGNyaXRlcmlhIGZvciBlbmFibGluZyBwMnAuDQogICAgDQo+IElmIHlvdSBrbm93IHdoYXQg
aXMgYmFkLCBjcmVhdGUgYSBsaXN0IGFuZCBrZWVwIGFkZGluZyBpdC4gWW91IGNhbid0IGFzc3Vt
ZQ0KPiB1bml2ZXJzYWxseSB0aGF0IGFsbCByb290IHBvcnRzIGFyZSBicm9rZW4vIGhhdmUgYmFk
IHBlcmZvcm1hbmNlLg0KDQpJIGFjdHVhbGx5IHdhbnRlZCB0byBkbyBhIGJsYWNrbGlzdCBvcmln
aW5hbGx5IGJ1dCB0aGF0IGlkZWEgd2FzIG5vdCBhY2NlcHRlZCBieSB0aGUgY29tbXVuaXR5LiAN
CiAgICANCj4gICAgV2hhdCBpZiBJIGNvbWUgdXAgd2l0aCBhIHZlcnkgY2hlYXAvY3JhcHB5IHN3
aXRjaCAoc29tZXRoaW5nIGxpa2UgdXNlZCBpbiBkYXRhDQo+ICAgIG1pbmluZyk/DQo+IFdoYXQg
Z3VhcmFudGVlcyB0aGF0IFAyUCB3aWxsIHdvcmsgd2l0aCB0aGlzIGRldmljZT8gWW91IGFyZSBt
YWtpbmcgYW4NCj4gYXNzdW1wdGlvbiBoZXJlIHRoYXQgYWxsIHN3aXRjaGVzIGhhdmUgZ29vZCBw
ZXJmb3JtYW5jZS4NCg0KQSBzd2l0Y2ggbXVzdCBzdXBwb3J0IFAyUCBvciBpdCBpcyBpbiB2aW9s
YXRpb24gb2YgdGhlIFBDSWUgc3BlY2lmaWNhdGlvbi4NCiAgICANCj4gICAgSSBoYXZlIGJlZW4g
ZG9pbmcgbXkgYmVzdCB0byBwcm92aWRlIGZlZWRiYWNrLiBJdCBmZWVscyBsaWtlIHlvdSBhcmUg
dGhyb3dpbmcNCj4gICAgdGhlbSBvdmVyIHRoZSB3YWxsIHRvIGJlIGhvbmVzdC4NCg0KSSB0aGlu
ayBvbmUgaXNzdWUgU2luYW4gaXMgdGhhdCBhIGxvdCBvZiB5b3VyIGlkZWFzIGhhdmUgYmVlbiBk
aXNjdXNzZWQgaW4gcHJldmlvdXMgdmVyc2lvbnMgb2YgdGhlIHNlcmllcy4gU28geW91IGFyZSBh
c2tpbmcgdXMgdG8gbWFrZSBjaGFuZ2VzIHdoaWNoLCBpbiBzb21lIGNhc2VzLCB3ZSBrbm93IGFy
ZSBub3QgYWNjZXB0YWJsZSB0byBvdGhlcnMgaW4gdGhlIGNvbW11bml0eS4gVGhlIGlucHV0IGlz
IHdlbGNvbWUgYnV0IGl0IGZsaWVzIGluIHRoZSBmYWNlIG9mIG90aGVyIGlucHV0IHdlIGhhdmUg
cmVjZWl2ZWQuIA0KDQpIb3dldmVyIGlmIG90aGVyIGRldmVsb3BlcnMgZmVlbCBzdHJvbmdseSBh
Ym91dCB0aGUgYmxhY2tsaXN0L3doaXRlbGlzdCBhbmQgc3dpdGNoIGNyaXRlcmlhIHBsZWFzZSBz
cGVhayB1cCEgOy0pDQoNClN0ZXBoZW4NCg0KICAgIA0KDQo=
