From: "Stephen  Bates" <sbates@raithlin.com>
Subject: Re: [PATCH v2 01/10] PCI/P2PDMA: Support peer to peer memory
Date: Thu, 1 Mar 2018 23:14:46 +0000
Message-ID: <9B84B347-2CCF-4250-89ED-B29892E76597@raithlin.com>
References: <20180228234006.21093-1-logang@deltatee.com>
 <20180228234006.21093-2-logang@deltatee.com>
 <20180301173752.GE13722@bhelgaas-glaptop.roam.corp.google.com>
 <b81503c2-9f07-b5f6-df06-64d1fdc53386@deltatee.com>
 <20180301230032.GA74737@bhelgaas-glaptop.roam.corp.google.com>
 <b3121c36-4ef5-0d8e-e8ef-418b48de9589@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <b3121c36-4ef5-0d8e-e8ef-418b48de9589@deltatee.com>
Content-Language: en-US
Content-ID: <F9761AF79384A74ABA750F9C634F06A9@CANPRD01.PROD.OUTLOOK.COM>
Sender: linux-kernel-owner@vger.kernel.org
To: Logan Gunthorpe <logang@deltatee.com>, Bjorn Helgaas <helgaas@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Bjorn Helgaas <bhelgaas@google.com>, Jason Gunthorpe <jgg@mellanox.com>, Max Gurtovoy <maxg@mellanox.com>, Dan Williams <dan.j.williams@intel.com>, =?utf-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Alex Williamson <alex.w>
List-Id: linux-rdma@vger.kernel.org

PiBJJ20gcHJldHR5IHN1cmUgdGhlIHNwZWMgZGlzYWxsb3dzIHJvdXRpbmctdG8tc2VsZiBzbyBk
b2luZyBhIFAyUCANCj4gdHJhbnNhY3Rpb24gaW4gdGhhdCBzZW5zZSBpc24ndCBnb2luZyB0byB3
b3JrIHVubGVzcyB0aGUgZGV2aWNlIA0KPiBzcGVjaWZpY2FsbHkgc3VwcG9ydHMgaXQgYW5kIGlu
dGVyY2VwdHMgdGhlIHRyYWZmaWMgYmVmb3JlIGl0IGdldHMgdG8gDQo+IHRoZSBwb3J0Lg0KDQpU
aGlzIGlzIGNvcnJlY3QuIFVubGVzcyB0aGUgZGV2aWNlIGludGVyY2VwdHMgdGhlIFRMUCBiZWZv
cmUgaXQgaGl0cyB0aGUgcm9vdC1wb3J0IHRoZW4gdGhpcyB3b3VsZCBiZSBjb25zaWRlcmVkIGEg
InJvdXRlIHRvIHNlbGYiIHZpb2xhdGlvbiBhbmQgYW4gZXJyb3IgZXZlbnQgd291bGQgb2NjdXIu
IFRoZSBzYW1lIGhvbGRzIGZvciB0aGUgZG93bnN0cmVhbSBwb3J0IG9uIGEgUENJIHN3aXRjaCAo
dW5sZXNzIHJvdXRlLXRvLXNlbGYgdmlvbGF0aW9ucyBhcmUgZGlzYWJsZWQgd2hpY2ggdmlvbGF0
ZXMgdGhlIHNwZWMgYnV0IHdoaWNoIEkgaGF2ZSBzZWVuIGRvbmUgaW4gY2VydGFpbiBhcHBsaWNh
dGlvbnMpLg0KICAgIA0KU3RlcGhlbg0KICAgIA0KICAgIA0KICAgIA0KDQo=
