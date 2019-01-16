From: =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>
Subject: Re: [PATCH] lib/scatterlist: Provide a DMA page iterator
Date: Wed, 16 Jan 2019 11:40:48 +0100
Message-ID: <744b82a0-bc81-06ee-307b-52ffda705e2c@gmail.com>
References: <20190104223531.GA1705@ziepe.ca> <20190110234218.GM6890@ziepe.ca>
 <20190114094856.GB29604@lst.de>
 <1fb20ab4b171b281e9994b6c55734c120958530b.camel@vmware.com>
 <20190115212501.GE22045@ziepe.ca>
Reply-To: christian.koenig@amd.com
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20190115212501.GE22045@ziepe.ca>
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
To: Jason Gunthorpe <jgg@ziepe.ca>, Thomas Hellstrom <thellstrom@vmware.com>
Cc: "syeh@vmware.com" <syeh@vmware.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>, "jian.xu.zheng@intel.com" <jian.xu.zheng@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>, "bingbu.cao@intel.com" <bingbu.cao@intel.com>, "yong.zhi@intel.com" <yong.zhi@intel.com>, "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>, "hch@lst.de" <hch@lst.de>, "tian.shu.qiu@intel.com" <tian.shu.qiu@intel.com>, "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

QW0gMTUuMDEuMTkgdW0gMjI6MjUgc2NocmllYiBKYXNvbiBHdW50aG9ycGU6Cj4gT24gVHVlLCBK
YW4gMTUsIDIwMTkgYXQgMDI6MTc6MjZQTSArMDAwMCwgVGhvbWFzIEhlbGxzdHJvbSB3cm90ZToK
Pj4gSGksIENocmlzdG9waCwKPj4KPj4gT24gTW9uLCAyMDE5LTAxLTE0IGF0IDEwOjQ4ICswMTAw
LCBDaHJpc3RvcGggSGVsbHdpZyB3cm90ZToKPj4+IE9uIFRodSwgSmFuIDEwLCAyMDE5IGF0IDA0
OjQyOjE4UE0gLTA3MDAsIEphc29uIEd1bnRob3JwZSB3cm90ZToKPj4+Pj4gQ2hhbmdlcyBzaW5j
ZSB0aGUgUkZDOgo+Pj4+PiAtIFJld29yayB2bXdnZnggdG9vIFtDSF0KPj4+Pj4gLSBVc2UgYSBk
aXN0aW5jdCB0eXBlIGZvciB0aGUgRE1BIHBhZ2UgaXRlcmF0b3IgW0NIXQo+Pj4+PiAtIERvIG5v
dCBoYXZlIGEgI2lmZGVmIFtDSF0KPj4+PiBDaHJpc3RvcGhIOiBXaWxsIHlvdSBhY2s/Cj4+PiBU
aGlzIGxvb2tzIGdlbmVyYWxseSBmaW5lLgo+Pj4KPj4+PiBBcmUgeW91IHN0aWxsIE9LIHdpdGgg
dGhlIHZtd2dmeCByZXdvcmtpbmcsIG9yIHNob3VsZCB3ZSBnbyBiYWNrIHRvCj4+Pj4gdGhlIG9y
aWdpbmFsIHZlcnNpb24gdGhhdCBkaWRuJ3QgaGF2ZSB0aGUgdHlwZSBzYWZldHkgc28gdGhpcwo+
Pj4+IGRyaXZlcgo+Pj4+IGNhbiBiZSBsZWZ0IGJyb2tlbj8KPj4+IEkgdGhpbmsgdGhlIG1hcCBt
ZXRob2QgaW4gdm1nZnggdGhhdCBqdXN0IGRvZXMgdmlydF90b19waHlzIGlzCj4+PiBwcmV0dHkg
YnJva2VuLiAgVGhvbWFzLCBjYW4geW91IGNoZWNrIGlmIHlvdSBzZWUgYW55IHBlcmZvcm1hbmNl
Cj4+PiBkaWZmZXJlbmNlIHdpdGgganVzdCBkb2luZyB0aGUgcHJvcGVyIGRtYSBtYXBwaW5nLCBh
cyB0aGF0IGdldHMgdGhlCj4+PiBkcml2ZXIgb3V0IG9mIGludGVyZmFjZSBhYnVzZSBsYW5kPwo+
PiBUaGUgcGVyZm9ybWFuY2UgZGlmZmVyZW5jZSBpcyBub3QgcmVhbGx5IHRoZSBtYWluIHByb2Js
ZW0gaGVyZS4gVGhlCj4+IHByb2JsZW0gaXMgdGhhdCBldmVuIHRob3VnaCB3ZSB1dGlsaXplIHRo
ZSBzdHJlYW1pbmcgRE1BIGludGVyZmFjZSwgd2UKPj4gdXNlIGl0IG9ubHkgc2luY2Ugd2UgaGF2
ZSB0byBmb3IgRE1BLVJlbWFwcGluZyBhbmQgYXNzdW1lIHRoYXQgdGhlCj4+IG1lbW9yeSBpcyBj
b2hlcmVudC4gVG8gYmUgYWJsZSB0byBiZSBhcyBjb21wbGlhbnQgYXMgcG9zc2libGUgYW5kIGRp
dGNoCj4+IHRoZSB2aXJ0LXRvLXBoeXMgbW9kZSwgd2UgKm5lZWQqIGEgRE1BIGludGVyZmFjZSBm
bGFnIHRoYXQgdGVsbHMgdXMKPj4gd2hlbiB0aGUgZG1hX3N5bmNfZm9yX3h4eCBhcmUgbm8tb3Bz
LiBJZiB0aGV5IGFyZW4ndCB3ZSdsbCByZWZ1c2UgdG8KPj4gbG9hZCBmb3Igbm93LiBJJ20gbm90
IHN1cmUsIGJ1dCBJIHRoaW5rIGFsc28gbm91dmVhdSBhbmQgcmFkZW9uIHN1ZmZlcgo+PiBmcm9t
IHRoZSBzYW1lIGlzc3VlLgo+IFJETUEgbmVlZHMgc29tZXRoaW5nIHNpbWlsYXIgYXMgd2VsbCwg
aW4gdGhpcyBjYXNlIGRyaXZlcnMgdGFrZSBhCj4gc3RydWN0IHBhZ2UgKiBmcm9tIGdldF91c2Vy
X3BhZ2VzKCkgYW5kIG5lZWQgdG8gaGF2ZSB0aGUgRE1BIG1hcCBmYWlsCj4gaWYgdGhlIHBsYXRm
b3JtIGNhbid0IERNQSBtYXAgaW4gYSB3YXkgdGhhdCBkb2VzIG5vdCByZXF1aXJlIGFueQo+IGFk
ZGl0aW9uYWwgRE1BIEFQSSBjYWxscyB0byBlbnN1cmUgY29oZXJlbmNlLiAodGhpbmsgVXNlcnNw
YWNlIFJETUEKPiBNUidzKQo+Cj4gVG9kYXkgd2UganVzdCBkbyB0aGUgbm9ybWFsIERNQSBtYXAg
YW5kIHdoZW4gaXQgcmFuZG9tbHkgZG9lc24ndCB3b3JrCj4gYW5kIGNvcnJ1cHRzIGRhdGEgdGVs
bCB0aG9zZSBwZW9wbGUgdGhlaXIgcGxhdGZvcm1zIGRvbid0IHN1cHBvcnQgUkRNQQo+IC0gaXQg
d291bGQgYmUgbmljZSB0byBoYXZlIGEgc2FmZXIgQVBJIGJhc2Ugc29sdXRpb24uLgoKT2gsIHll
cyByZWFsbHkgZ29vZCBwb2ludC4gV2UgaGF2ZSB0byBzdXBwb3J0IGdldF91c2VyX3BhZ2VzIChv
ciBITU0pIGluIAphIHNpbWlsYXIgbWFubmVyIG9uIEdQVXMgYXMgd2VsbC4KClJlZ2FyZHMsCkNo
cmlzdGlhbi4KCj4KPiBKYXNvbgo+IF9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fCj4gZHJpLWRldmVsIG1haWxpbmcgbGlzdAo+IGRyaS1kZXZlbEBsaXN0cy5m
cmVlZGVza3RvcC5vcmcKPiBodHRwczovL2xpc3RzLmZyZWVkZXNrdG9wLm9yZy9tYWlsbWFuL2xp
c3RpbmZvL2RyaS1kZXZlbAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX18KZHJpLWRldmVsIG1haWxpbmcgbGlzdApkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0
b3Aub3JnCmh0dHBzOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vZHJp
LWRldmVsCg==
