From: Daniel Stone <daniel@fooishbar.org>
Subject: Re: [PATCH] lib/scatterlist: Provide a DMA page iterator
Date: Wed, 16 Jan 2019 16:36:33 +0000
Message-ID: <CAPj87rNAhGsGwNWRM1iO4rruVjQ+Yu=bDXS39Om9rL6PesuQYg@mail.gmail.com>
References: <20190114094856.GB29604@lst.de>
 <1fb20ab4b171b281e9994b6c55734c120958530b.camel@vmware.com>
 <2b440a3b-ed2f-8fd6-a21e-97ca0b2f5db9@gmail.com>
 <20190115152029.GB2325@lst.de>
 <41d0616e95fb48942404fb54d82249f5700affb1.camel@vmware.com>
 <20190115183133.GA12350@lst.de> <c82076aa-a6ee-5ba2-a8d8-935fdbb7d5ca@amd.com>
 <20190115205801.GA15432@lst.de>
 <01e5522bf88549bfdaea1430fece23cb3d1a1a55.camel@vmware.com>
 <8aadac80-da9b-b52a-a4bf-066406127117@amd.com> <20190116160639.GA28619@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20190116160639.GA28619@lst.de>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: "hch@lst.de" <hch@lst.de>
Cc: Thomas Hellstrom <thellstrom@vmware.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>, "jian.xu.zheng@intel.com" <jian.xu.zheng@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>, "bingbu.cao@intel.com" <bingbu.cao@intel.com>, "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>, "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>, "Koenig,
 Christian" <Christian.Koenig@amd.com>, "tian.shu.qiu@intel.com" <tian.shu.qiu@intel.com>, "yong.zhi@intel.com" <yong.zhi@intel.com>
List-Id: linux-rdma@vger.kernel.org

T24gV2VkLCAxNiBKYW4gMjAxOSBhdCAxNjowNiwgaGNoQGxzdC5kZSA8aGNoQGxzdC5kZT4gd3Jv
dGU6Cj4gT24gV2VkLCBKYW4gMTYsIDIwMTkgYXQgMDc6Mjg6MTNBTSArMDAwMCwgS29lbmlnLCBD
aHJpc3RpYW4gd3JvdGU6Cj4gPiBUbyBzdW1tYXJpemUgb25jZSBtb3JlOiBXZSBoYXZlIGFuIGFy
cmF5IG9mIHN0cnVjdCBwYWdlcyBhbmQgd2FudCB0bwo+ID4gY29oZXJlbnRseSBtYXAgdGhhdCB0
byBhIGRldmljZS4KPgo+IEFuZCB0aGUgYW5zd2VyIHRvIHRoYXQgaXMgdmVyeSBzaW1wbGU6IHlv
dSBjYW4ndC4gIFdoYXQgaXMgc28gaGFyZAo+IHRvIHVuZGVyc3RhbmQgYWJvdXQ/ICBJZiB5b3Ug
d2FudCB0byBtYXAgYXJiaXRyYXJ5IG1lbW9yeSBpdCBzaW1wbHkKPiBjYW4ndCBiZSBkb25lIGlu
IGEgY29oZXJlbnQgd2F5IG9uIGFib3V0IGhhbGYgb2Ygb3VyIHBsYXRmb3Jtcy4KPgo+ID4gSWYg
dGhhdCBpcyBub3QgcG9zc2libGUgYmVjYXVzZSBvZiB3aGF0ZXZlciByZWFzb24gd2Ugd2FudCB0
byBnZXQgYW4KPiA+IGVycm9yIGNvZGUgb3IgZXZlbiBub3QgbG9hZCB0aGUgZHJpdmVyIGZyb20g
dGhlIGJlZ2lubmluZy4KPgo+IFRoYXQgaXMgYSBidWxsc2hpdCBhdHRpdHVkZS4gIEp1c3QgbGlr
ZSBldmVyeW9uZSBlbHNlIG1ha2VzIHRoZWlyCj4gZHJpdmVycyB3b3JrIHlvdSBzaG91bGQgbm90
IGJlIGxhenkuCgpDYW4geW91IG5vdCB0YWxrIHRvIHBlb3BsZSBsaWtlIHRoYXQ/IEV2ZW4gaWYg
eW91IHRoaW5rIHRoYXQgaXMgYW4gT0sKd2F5IHRvIHRyZWF0IGFueW9uZSAtIHdoaWNoIGl0IGlz
bid0LCBjZXJ0YWlubHkgbm90IG9uIGRyaS1kZXZlbEAgd2l0aAp0aGUgZmQubyBDb2RlIG9mIENv
bmR1Y3QsIGFuZCBub3QgYWNjb3JkaW5nIHRvIHRoZSBrZXJuZWwncyBlaXRoZXIgLSBJCmhhdmUg
YWJzb2x1dGVseSBubyBpZGVhIGhvdyB5b3UgY2FuIGxvb2sgYXQgdGhlIHdvcmsgdGhlIEFNRCBw
ZW9wbGUKaGF2ZSBwdXQgaW4gb3ZlciBtYW55IHllYXJzIGFuZCBjb25jbHVkZSB0aGF0IHRoZXkn
cmUgJ2xhenknLgoKSWYgdGhpcyBtYWtlcyB5b3Ugc28gYW5ncnksIHN0ZXAgYmFjayBmcm9tIHRo
ZSBrZXlib2FyZCBmb3IgYSBmZXcKbWludXRlcywgYW5kIGlmIHlvdSBzdGlsbCBjYW4ndCBwYXJ0
aWNpcGF0ZSBpbiByZWFzb25hYmxlIGRpc2N1c3Npb24KbGlrZSBhbiBhZHVsdCwgbWF5YmUgc3Rl
cCBvdXQgb2YgdGhlIHRocmVhZCBlbnRpcmVseS4KX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX18KZHJpLWRldmVsIG1haWxpbmcgbGlzdApkcmktZGV2ZWxAbGlz
dHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4v
bGlzdGluZm8vZHJpLWRldmVsCg==
