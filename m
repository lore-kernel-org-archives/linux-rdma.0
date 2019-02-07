From: Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH] lib/scatterlist: Provide a DMA page iterator
Date: Fri, 8 Feb 2019 01:23:16 +0200
Message-ID: <20190207232316.3min76e2xy3aqrxh@kekkonen.localdomain>
References: <20190104223531.GA1705@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <20190104223531.GA1705@ziepe.ca>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Thomas Hellstrom <thellstrom@vmware.com>, Sinclair Yeh <syeh@vmware.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Daniel Vetter <daniel.vetter@ffwll.ch>, Jian Xu Zheng <jian.xu.zheng@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, Bingbu Cao <bingbu.cao@intel.com>, Yong Zhi <yong.zhi@intel.com>, Shiraz Saleem <shiraz.saleem@intel.com>, Christoph Hellwig <hch@lst.de>, Tian Shu Qiu <tian.shu.qiu@intel.com>, "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

T24gRnJpLCBKYW4gMDQsIDIwMTkgYXQgMTA6MzU6NDNQTSArMDAwMCwgSmFzb24gR3VudGhvcnBl
IHdyb3RlOgo+IENvbW1pdCAyZGI3NmQ3YzNjNmQgKCJsaWIvc2NhdHRlcmxpc3Q6IHNnX3BhZ2Vf
aXRlcjogc3VwcG9ydCBzZyBsaXN0cyB3L28KPiBiYWNraW5nIHBhZ2VzIikgaW50cm9kdWNlZCB0
aGUgc2dfcGFnZV9pdGVyX2RtYV9hZGRyZXNzKCkgZnVuY3Rpb24gd2l0aG91dAo+IHByb3ZpZGlu
ZyBhIHdheSB0byB1c2UgaXQgaW4gdGhlIGdlbmVyYWwgY2FzZS4gSWYgdGhlIHNnX2RtYV9sZW4g
aXMgbm90Cj4gZXF1YWwgdG8gdGhlIGRtYV9sZW5ndGggY2FsbGVycyBjYW5ub3Qgc2FmZWx5IHVz
ZSB0aGUKPiBmb3JfZWFjaF9zZ19wYWdlL3NnX3BhZ2VfaXRlcl9kbWFfYWRkcmVzcyBjb21iaW5h
dGlvbi4KPiAKPiBSZXNvbHZlIHRoaXMgQVBJIG1pc3Rha2UgYnkgcHJvdmlkaW5nIGEgRE1BIHNw
ZWNpZmljIGl0ZXJhdG9yLAo+IGZvcl9lYWNoX3NnX2RtYV9wYWdlKCksIHRoYXQgdXNlcyB0aGUg
cmlnaHQgbGVuZ3RoIHNvCj4gc2dfcGFnZV9pdGVyX2RtYV9hZGRyZXNzKCkgd29ya3MgYXMgZXhw
ZWN0ZWQgd2l0aCBhbGwgc2dsaXN0cy4gQSBuZXcKPiBpdGVyYXRvciB0eXBlIGlzIGludHJvZHVj
ZWQgdG8gcHJvdmlkZSBjb21waWxlLXRpbWUgc2FmZXR5IGFnYWluc3Qgd3JvbmdseQo+IG1peGlu
ZyBhY2Nlc3NvcnMgYW5kIGl0ZXJhdG9ycy4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBKYXNvbiBHdW50
aG9ycGUgPGpnZ0BtZWxsYW5veC5jb20+CgpBY2tlZC1ieTogU2FrYXJpIEFpbHVzIDxzYWthcmku
YWlsdXNAbGludXguaW50ZWwuY29tPiAoaXB1My1jaW8yKQoKLS0gClNha2FyaSBBaWx1cwpzYWth
cmkuYWlsdXNAbGludXguaW50ZWwuY29tCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fCmRyaS1kZXZlbCBtYWlsaW5nIGxpc3QKZHJpLWRldmVsQGxpc3RzLmZy
ZWVkZXNrdG9wLm9yZwpodHRwczovL2xpc3RzLmZyZWVkZXNrdG9wLm9yZy9tYWlsbWFuL2xpc3Rp
bmZvL2RyaS1kZXZlbAo=
