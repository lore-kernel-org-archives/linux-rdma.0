From: "hch@lst.de" <hch@lst.de>
Subject: Re: [PATCH] lib/scatterlist: Provide a DMA page iterator
Date: Wed, 16 Jan 2019 17:11:34 +0100
Message-ID: <20190116161134.GA29041@lst.de>
References: <20190104223531.GA1705@ziepe.ca> <20190110234218.GM6890@ziepe.ca>
 <20190114094856.GB29604@lst.de>
 <1fb20ab4b171b281e9994b6c55734c120958530b.camel@vmware.com>
 <20190115212501.GE22045@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <20190115212501.GE22045@ziepe.ca>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Thomas Hellstrom <thellstrom@vmware.com>, "syeh@vmware.com" <syeh@vmware.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>, "jian.xu.zheng@intel.com" <jian.xu.zheng@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>, "bingbu.cao@intel.com" <bingbu.cao@intel.com>, "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>, "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>, "hch@lst.de" <hch@lst.de>, "tian.shu.qiu@intel.com" <tian.shu.qiu@intel.com>, "yong.zhi@intel.com" <yong.zhi@intel.com>
List-Id: linux-rdma@vger.kernel.org

T24gVHVlLCBKYW4gMTUsIDIwMTkgYXQgMDI6MjU6MDFQTSAtMDcwMCwgSmFzb24gR3VudGhvcnBl
IHdyb3RlOgo+IFJETUEgbmVlZHMgc29tZXRoaW5nIHNpbWlsYXIgYXMgd2VsbCwgaW4gdGhpcyBj
YXNlIGRyaXZlcnMgdGFrZSBhCj4gc3RydWN0IHBhZ2UgKiBmcm9tIGdldF91c2VyX3BhZ2VzKCkg
YW5kIG5lZWQgdG8gaGF2ZSB0aGUgRE1BIG1hcCBmYWlsCj4gaWYgdGhlIHBsYXRmb3JtIGNhbid0
IERNQSBtYXAgaW4gYSB3YXkgdGhhdCBkb2VzIG5vdCByZXF1aXJlIGFueQo+IGFkZGl0aW9uYWwg
RE1BIEFQSSBjYWxscyB0byBlbnN1cmUgY29oZXJlbmNlLiAodGhpbmsgVXNlcnNwYWNlIFJETUEK
PiBNUidzKQoKQW55IHRpbWUgeW91IGRtYSBtYXAgcGFnZXMgeW91IG5lZWQgdG8gZG8gZnVydGhl
ciBETUEgQVBJIGNhbGxzIHRvCmVuc3VyZSBjb2hlcmVudCwgdGhhdCBpcyB0aGUgd2F5IGl0IGlz
IGltcGxlbWVudGVkLiAgVGhlc2UgY2FsbHMKanVzdCBoYXBwZW4gdG8gYmUgbm8tb3BzIHNvbWV0
aW1lcy4KCj4gVG9kYXkgd2UganVzdCBkbyB0aGUgbm9ybWFsIERNQSBtYXAgYW5kIHdoZW4gaXQg
cmFuZG9tbHkgZG9lc24ndCB3b3JrCj4gYW5kIGNvcnJ1cHRzIGRhdGEgdGVsbCB0aG9zZSBwZW9w
bGUgdGhlaXIgcGxhdGZvcm1zIGRvbid0IHN1cHBvcnQgUkRNQQo+IC0gaXQgd291bGQgYmUgbmlj
ZSB0byBoYXZlIGEgc2FmZXIgQVBJIGJhc2Ugc29sdXRpb24uLgoKTm93IHRoYXQgYWxsIHRoZXNl
IGRyaXZlcnMgYXJlIGNvbnNvbGlkYXRlZCBpbiByZG1hLWNvcmUgeW91IGNhbiBmaXgKdGhlIGNv
ZGUgdG8gYWN0dWFsbHkgZG8gdGhlIHJpZ2h0IHRoaW5nLiAgSXQgaXNuJ3QgdGhhdCB1c2Vyc3Bh
Y2UgRE1BCmNvaGVyZW50IGlzIGFueSBoYXJkZXIgdGhhbiBpbi1rZXJuZWwgRE1BIGNvaGVyZW5l
bmNlLiAgSXQganVzdCBpcwp0aGF0IG5vIG9uZSBib3RoZXJlZCB0byBkbyBpdCBwcm9wZXJseS4K
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KZHJpLWRldmVs
IG1haWxpbmcgbGlzdApkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlz
dHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vZHJpLWRldmVsCg==
