From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Date: Thu, 24 Nov 2016 23:58:17 -0800
Message-ID: <20161125075817.GA18428@infradead.org>
References: <20161123190515.GA12146@obsidianresearch.com>
 <7bc38037-b6ab-943f-59db-6280e16901ab@amd.com>
 <20161123193228.GC12146@obsidianresearch.com>
 <c2c88376-5ba7-37d1-4d3e-592383ebb00a@amd.com>
 <20161123203332.GA15062@obsidianresearch.com>
 <dd60bca8-0a35-7a3a-d3ab-b95bc3d9b973@deltatee.com>
 <20161123215510.GA16311@obsidianresearch.com>
 <91d28749-bc64-622f-56a1-26c00e6b462a@deltatee.com>
 <20161124164249.GD20818@obsidianresearch.com>
 <9cc22068-ede8-c1bc-5d8b-cf6224a7ce05@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <9cc22068-ede8-c1bc-5d8b-cf6224a7ce05@deltatee.com>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Haggai Eran <haggaie@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "Kuehling,
 Felix" <Felix.Kuehling@amd.com>, Serguei Sagalovitch <serguei.sagalovitch@amd.com>, "Blinzer,
 Paul" <Paul.Blinzer@amd.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "Sander,
 Ben" <ben.sander@amd.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "Deucher,
 Alexander" <Alexander.Deucher@amd.com>, Dan Williams <dan.j.williams@intel.com>, "Koenig,
 Christian" <Christian.Koenig@amd.com>, "Linux-media@vger.kernel.org" <Linux-media@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

T24gVGh1LCBOb3YgMjQsIDIwMTYgYXQgMTE6MTE6MzRBTSAtMDcwMCwgTG9nYW4gR3VudGhvcnBl
IHdyb3RlOgo+ICogUmVndWxhciBEQVggaW4gdGhlIEZTIGRvZXNuJ3Qgd29yayBhdCB0aGlzIHRp
bWUgYmVjYXVzZSB0aGUgRlMgY2FuCj4gbW92ZSB0aGUgZmlsZSB5b3UgdGhpbmsgeW91ciB0cmFu
c2ZlciB0byBvdXQgZnJvbSB1bmRlciB5b3UuIFRob3VnaCBJCj4gdW5kZXJzdGFuZCB0aGVyZSdz
IGJlZW4gc29tZSB3b3JrIHdpdGggWEZTIHRvIHNvbHZlIHRoYXQgaXNzdWUuCgpUaGUgZmlsZSBz
eXN0ZW0gd2lsbCBuZXZlciBtb3ZlIGFueXRoaW5nIHVuZGVyIGxvY2tlZCBkb3duIHBhZ2VzLAps
b2NraW5nIGRvd24gcGFnZXMgaXMgdXNlZCBleGFjdGx5IHRvIHByb3RlY3QgYWdhaW5zdCB0aGF0
LiAgU28gYXMgbG9uZwphcyB3ZSBwYWdlIHN0cnVjdHVyZXMgYXZhaWxhYmxlIFJETUEgdG8vZnJv
bSBkZXZpY2UgbWVtb3J5IF9mcm9tIGtlcm5lbApzcGFjZV8gaXMgdHJpdmlhbCwgYWx0aG91Z2gg
Zm9yIGZpbGUgc3lzdGVtcyB0byB3b3JrIHByb3Blcmx5IHlvdQpyZWFsbHkgd2FudCBhIG5vdGlm
aWNhdGlvbiB0byB0aGUgY29uc3VtZXIgaWYgdGhlIGZpbGUgc3lzdGVtcyB3YW50cwp0byByZW1v
dmUgdGhlIG1hcHBpbmcuICBXZSBoYXZlIGltcGxlbWVudGVkIHRoYXQgdXNpbmcgRkxfTEFZT1VU
UyBsb2Nrcwpmb3IgTkZTRCwgYnV0IG9ubHkgWEZTIHN1cHBvcnRzIGl0IHNvIGZhci4gIFdpdGhv
dXQgdGhhdCBhIGxvbmcgdGVybQpsb2NrZWQgZG93biByZWdpb24gb2YgbWVtb3J5IChlLmcuIGEg
a2VybmVsIE1SKSB3b3VsZCBwcmV2ZW50IHZhcmlvdXMKZmlsZSBvcGVyYXRpb25zIHRoYXQgd291
bGQgc2ltcGx5IGhhbmcuCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fCmRyaS1kZXZlbCBtYWlsaW5nIGxpc3QKZHJpLWRldmVsQGxpc3RzLmZyZWVkZXNrdG9w
Lm9yZwpodHRwczovL2xpc3RzLmZyZWVkZXNrdG9wLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2RyaS1k
ZXZlbAo=
