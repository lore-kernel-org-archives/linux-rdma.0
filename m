From: =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>
Subject: Re: [PATCH] lib/scatterlist: Provide a DMA page iterator
Date: Tue, 15 Jan 2019 15:24:55 +0100
Message-ID: <2b440a3b-ed2f-8fd6-a21e-97ca0b2f5db9@gmail.com>
References: <20190104223531.GA1705@ziepe.ca> <20190110234218.GM6890@ziepe.ca>
 <20190114094856.GB29604@lst.de>
 <1fb20ab4b171b281e9994b6c55734c120958530b.camel@vmware.com>
Reply-To: christian.koenig@amd.com
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <1fb20ab4b171b281e9994b6c55734c120958530b.camel@vmware.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Thomas Hellstrom <thellstrom@vmware.com>, "hch@lst.de" <hch@lst.de>, "jgg@ziepe.ca" <jgg@ziepe.ca>
Cc: "syeh@vmware.com" <syeh@vmware.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>, "jian.xu.zheng@intel.com" <jian.xu.zheng@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>, "bingbu.cao@intel.com" <bingbu.cao@intel.com>, "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>, "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>, "tian.shu.qiu@intel.com" <tian.shu.qiu@intel.com>, "yong.zhi@intel.com" <yong.zhi@intel.com>
List-Id: linux-rdma@vger.kernel.org

QW0gMTUuMDEuMTkgdW0gMTU6MTcgc2NocmllYiBUaG9tYXMgSGVsbHN0cm9tOgo+IEhpLCBDaHJp
c3RvcGgsCj4KPiBPbiBNb24sIDIwMTktMDEtMTQgYXQgMTA6NDggKzAxMDAsIENocmlzdG9waCBI
ZWxsd2lnIHdyb3RlOgo+PiBPbiBUaHUsIEphbiAxMCwgMjAxOSBhdCAwNDo0MjoxOFBNIC0wNzAw
LCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6Cj4+Pj4gQ2hhbmdlcyBzaW5jZSB0aGUgUkZDOgo+Pj4+
IC0gUmV3b3JrIHZtd2dmeCB0b28gW0NIXQo+Pj4+IC0gVXNlIGEgZGlzdGluY3QgdHlwZSBmb3Ig
dGhlIERNQSBwYWdlIGl0ZXJhdG9yIFtDSF0KPj4+PiAtIERvIG5vdCBoYXZlIGEgI2lmZGVmIFtD
SF0KPj4+IENocmlzdG9waEg6IFdpbGwgeW91IGFjaz8KPj4gVGhpcyBsb29rcyBnZW5lcmFsbHkg
ZmluZS4KPj4KPj4+IEFyZSB5b3Ugc3RpbGwgT0sgd2l0aCB0aGUgdm13Z2Z4IHJld29ya2luZywg
b3Igc2hvdWxkIHdlIGdvIGJhY2sgdG8KPj4+IHRoZSBvcmlnaW5hbCB2ZXJzaW9uIHRoYXQgZGlk
bid0IGhhdmUgdGhlIHR5cGUgc2FmZXR5IHNvIHRoaXMKPj4+IGRyaXZlcgo+Pj4gY2FuIGJlIGxl
ZnQgYnJva2VuPwo+PiBJIHRoaW5rIHRoZSBtYXAgbWV0aG9kIGluIHZtZ2Z4IHRoYXQganVzdCBk
b2VzIHZpcnRfdG9fcGh5cyBpcwo+PiBwcmV0dHkgYnJva2VuLiAgVGhvbWFzLCBjYW4geW91IGNo
ZWNrIGlmIHlvdSBzZWUgYW55IHBlcmZvcm1hbmNlCj4+IGRpZmZlcmVuY2Ugd2l0aCBqdXN0IGRv
aW5nIHRoZSBwcm9wZXIgZG1hIG1hcHBpbmcsIGFzIHRoYXQgZ2V0cyB0aGUKPj4gZHJpdmVyIG91
dCBvZiBpbnRlcmZhY2UgYWJ1c2UgbGFuZD8KPiBUaGUgcGVyZm9ybWFuY2UgZGlmZmVyZW5jZSBp
cyBub3QgcmVhbGx5IHRoZSBtYWluIHByb2JsZW0gaGVyZS4gVGhlCj4gcHJvYmxlbSBpcyB0aGF0
IGV2ZW4gdGhvdWdoIHdlIHV0aWxpemUgdGhlIHN0cmVhbWluZyBETUEgaW50ZXJmYWNlLCB3ZQo+
IHVzZSBpdCBvbmx5IHNpbmNlIHdlIGhhdmUgdG8gZm9yIERNQS1SZW1hcHBpbmcgYW5kIGFzc3Vt
ZSB0aGF0IHRoZQo+IG1lbW9yeSBpcyBjb2hlcmVudC4gVG8gYmUgYWJsZSB0byBiZSBhcyBjb21w
bGlhbnQgYXMgcG9zc2libGUgYW5kIGRpdGNoCj4gdGhlIHZpcnQtdG8tcGh5cyBtb2RlLCB3ZSAq
bmVlZCogYSBETUEgaW50ZXJmYWNlIGZsYWcgdGhhdCB0ZWxscyB1cwo+IHdoZW4gdGhlIGRtYV9z
eW5jX2Zvcl94eHggYXJlIG5vLW9wcy4gSWYgdGhleSBhcmVuJ3Qgd2UnbGwgcmVmdXNlIHRvCj4g
bG9hZCBmb3Igbm93LiBJJ20gbm90IHN1cmUsIGJ1dCBJIHRoaW5rIGFsc28gbm91dmVhdSBhbmQg
cmFkZW9uIHN1ZmZlcgo+IGZyb20gdGhlIHNhbWUgaXNzdWUuCgpZZWFoLCBpbmRlZWQuIEJvdW5j
ZSBidWZmZXJzIGFyZSBhbiBhYnNvbHV0ZSBuby1nbyBmb3IgR1BVcy4KCklmIHRoZSBETUEgQVBJ
IGZpbmRzIHRoYXQgYSBwaWVjZSBvZiBtZW1vcnkgaXMgbm90IGRpcmVjdGx5IGFjY2Vzc2libGUg
CmJ5IHRoZSBHUFUgd2UgbmVlZCB0byByZXR1cm4gYW4gZXJyb3IgYW5kIG5vdCB0cnkgdG8gdXNl
IGJvdW5jZSBidWZmZXJzIApiZWhpbmQgdGhlIHN1cmZhY2UuCgpUaGF0IGlzIHNvbWV0aGluZyB3
aGljaCBhbHdheXMgYW5ub3llZCBtZSB3aXRoIHRoZSBETUEgQVBJLCB3aGljaCBpcyAKb3RoZXJ3
aXNlIHJhdGhlciBjbGVhbmx5IGRlZmluZWQuCgpDaHJpc3RpYW4uCgo+Cj4+IFdoaWxlIHdlJ3Jl
IGF0IGl0IEkgdGhpbmsgd2UgbmVlZCB0byBtZXJnZSBteSBzZXJpZXMgaW4gdGhpcyBhcmVhCj4+
IGZvciA1LjAsIGJlY2F1c2Ugd2l0aG91dCB0aGF0IHRoZSBkcml2ZXIgaXMgYWxyZWFkeSBicm9r
ZW4uICBXaGVyZQo+PiBzaG91bGQgd2UgbWVyZ2UgaXQ/Cj4gSSBjYW4gbWVyZ2UgaXQgdGhyb3Vn
aCB2bXdnZngvZHJtLWZpeGVzLiBUaGVyZSBpcyBhbiBvdXRzdGFuZGluZyBpc3N1ZQo+IHdpdGgg
cGF0Y2ggMy4gRG8geW91IHdhbnQgbWUgdG8gZml4IHRoYXQgdXA/Cj4KPiBUaGFua3MsCj4gVGhv
bWFzCj4KPgo+IF9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
Cj4gZHJpLWRldmVsIG1haWxpbmcgbGlzdAo+IGRyaS1kZXZlbEBsaXN0cy5mcmVlZGVza3RvcC5v
cmcKPiBodHRwczovL2xpc3RzLmZyZWVkZXNrdG9wLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2RyaS1k
ZXZlbAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KZHJp
LWRldmVsIG1haWxpbmcgbGlzdApkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBz
Oi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vZHJpLWRldmVsCg==
