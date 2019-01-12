From: Shiraz Saleem <shiraz.saleem@intel.com>
Subject: Re: [PATCH] lib/scatterlist: Provide a DMA page iterator
Date: Sat, 12 Jan 2019 12:27:05 -0600
Message-ID: <20190112182704.GA15320@ssaleem-MOBL4.amr.corp.intel.com>
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
Cc: Thomas Hellstrom <thellstrom@vmware.com>, Sinclair Yeh <syeh@vmware.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Daniel Vetter <daniel.vetter@ffwll.ch>, Jian Xu Zheng <jian.xu.zheng@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, Sakari Ailus <sakari.ailus@linux.intel.com>, Bingbu Cao <bingbu.cao@intel.com>, Yong Zhi <yong.zhi@intel.com>, Christoph Hellwig <hch@lst.de>, Tian Shu Qiu <tian.shu.qiu@intel.com>, "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
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
ZyBhY2Nlc3NvcnMgYW5kIGl0ZXJhdG9ycy4KWy4uXQoKPiAgCj4gKy8qCj4gKyAqIHNnIHBhZ2Ug
aXRlcmF0b3IgZm9yIERNQSBhZGRyZXNzZXMKPiArICoKPiArICogVGhpcyBpcyB0aGUgc2FtZSBh
cyBzZ19wYWdlX2l0ZXIgaG93ZXZlciB5b3UgY2FuIGNhbGwKPiArICogc2dfcGFnZV9pdGVyX2Rt
YV9hZGRyZXNzKEBkbWFfaXRlcikgdG8gZ2V0IHRoZSBwYWdlJ3MgRE1BCj4gKyAqIGFkZHJlc3Mu
IHNnX3BhZ2VfaXRlcl9wYWdlKCkgY2Fubm90IGJlIGNhbGxlZCBvbiB0aGlzIGl0ZXJhdG9yLgo+
ICsgKi8KRG9lcyBpdCBtYWtlIHNlbnNlIHRvIGhhdmUgYSB2YXJpYW50IG9mIHNnX3BhZ2VfaXRl
cl9wYWdlKCkgdG8gZ2V0IHRoZQpwYWdlIGRlc2NyaXB0b3Igd2l0aCB0aGlzIGRtYV9pdGVyPyBU
aGlzIGNhbiBiZSB1c2VkIHdoZW4gd2Fsa2luZyBETUEtbWFwcGVkClNHIGxpc3RzIHdpdGggZm9y
X2VhY2hfc2dfZG1hX3BhZ2UuCgo+ICtzdHJ1Y3Qgc2dfZG1hX3BhZ2VfaXRlciB7Cj4gKwlzdHJ1
Y3Qgc2dfcGFnZV9pdGVyIGJhc2U7Cj4gK307Cj4gKwo+IApfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXwpkcmktZGV2ZWwgbWFpbGluZyBsaXN0CmRyaS1kZXZl
bEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFp
bG1hbi9saXN0aW5mby9kcmktZGV2ZWwK
