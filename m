From: "Koenig, Christian" <Christian.Koenig@amd.com>
Subject: Re: [PATCH] lib/scatterlist: Provide a DMA page iterator
Date: Tue, 15 Jan 2019 19:13:11 +0000
Message-ID: <c82076aa-a6ee-5ba2-a8d8-935fdbb7d5ca@amd.com>
References: <20190104223531.GA1705@ziepe.ca> <20190110234218.GM6890@ziepe.ca>
 <20190114094856.GB29604@lst.de>
 <1fb20ab4b171b281e9994b6c55734c120958530b.camel@vmware.com>
 <2b440a3b-ed2f-8fd6-a21e-97ca0b2f5db9@gmail.com>
 <20190115152029.GB2325@lst.de>
 <41d0616e95fb48942404fb54d82249f5700affb1.camel@vmware.com>
 <20190115183133.GA12350@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20190115183133.GA12350@lst.de>
Content-Language: en-US
Content-ID: <01DFD43BFF2D1B4DB471E42D38BF959C@namprd12.prod.outlook.com>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: "hch@lst.de" <hch@lst.de>, Thomas Hellstrom <thellstrom@vmware.com>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>, "jian.xu.zheng@intel.com" <jian.xu.zheng@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>, "bingbu.cao@intel.com" <bingbu.cao@intel.com>, "yong.zhi@intel.com" <yong.zhi@intel.com>, "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>, "tian.shu.qiu@intel.com" <tian.shu.qiu@intel.com>, "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

QW0gMTUuMDEuMTkgdW0gMTk6MzEgc2NocmllYiBoY2hAbHN0LmRlOg0KPiBPbiBUdWUsIEphbiAx
NSwgMjAxOSBhdCAwNjowMzozOVBNICswMDAwLCBUaG9tYXMgSGVsbHN0cm9tIHdyb3RlOg0KPj4g
SW4gdGhlIGdyYXBoaWNzIGNhc2UsIGl0J3MgcHJvYmFibHkgYmVjYXVzZSBpdCBkb2Vzbid0IGZp
dCB0aGUgZ3JhcGhpY3MNCj4+IHVzZS1jYXNlczoNCj4+DQo+PiAxKSBNZW1vcnkgdHlwaWNhbGx5
IG5lZWRzIHRvIGJlIG1hcHBhYmxlIGJ5IGFub3RoZXIgZGV2aWNlLiAodGhlICJkbWEtDQo+PiBi
dWYiIGludGVyZmFjZSkNCj4gQW5kIHRoZXJlIGlzIG5vdGhpbmcgcHJldmVudGluZyBkbWEtYnVm
IHNoYXJpbmcgb2YgdGhlc2UgYnVmZmVycy4NCj4gVW5saWtlIHRoZSBnZXRfc2d0YWJsZSBtZXNz
IGl0IGNhbiBhY3R1YWxseSB3b3JrIHJlbGlhYmx5IG9uDQo+IGFyY2hpdGVjdHVyZXMgdGhhdCBo
YXZlIHZpcnR1YWxseSB0YWdnZWQgY2FjaGVzIGFuZC9vciBkb24ndA0KPiBndWFyYW50ZWUgY2Fj
aGUgY29oZXJlbmN5IHdpdGggbWl4ZWQgYXR0cmlidXRlIG1hcHBpbmdzLg0KPg0KPj4gMikgRE1B
IGJ1ZmZlcnMgYXJlIGV4cG9ydGVkIHRvIHVzZXItc3BhY2UgYW5kIGlzIHN1Yi1hbGxvY2F0ZWQg
YnkgaXQuDQo+PiBNb3N0bHkgdGhlcmUgYXJlIG5vIEdQVSB1c2VyLXNwYWNlIGtlcm5lbCBpbnRl
cmZhY2VzIHRvIHN5bmMgLyBmbHVzaA0KPj4gc3VicmVnaW9ucyBhbmQgdGhlc2Ugc3luY3MgbWF5
IGhhcHBlbiBvbiBhIHNtYWxsZXItdGhhbi1jYWNoZS1saW5lDQo+PiBncmFudWxhcml0eS4NCj4g
SSBrbm93IG9mIG5vIGFyY2hpdGVjdHVyZXMgdGhhdCBjYW4gZG8gY2FjaGUgbWFpbnRhaW5hbmNl
IG9uIGEgbGVzcw0KPiB0aGFuIGNhY2hlIGxpbmUgYmFzaXMuICBFaXRoZXIgdGhlIGluc3RydWN0
aW9ucyByZXF1aXJlIHlvdSB0bw0KPiBzcGVjaWZjeSBjYWNoZSBsaW5lcywgb3IgdGhleSBkbyBz
b21ldGltZXMgbW9yZSwgc29tZXRpbWVzIGxlc3MNCj4gaW50ZWxsaWdlbnQgcm91bmRpbmcgdXAu
DQo+DQo+IE5vdGUgdGhhdCBhcyBsb25nIGRtYSBub24tY29oZXJlbnQgYnVmZmVycyBhcmUgZGV2
aWNlcyBvd25lZCBpdA0KPiBpcyB1cCB0byB0aGUgZGV2aWNlIGFuZCB0aGUgdXNlciBzcGFjZSBk
cml2ZXIgdG8gdGFrZSBjYXJlIG9mDQo+IGNvaGVyZW5jeSwgdGhlIGtlcm5lbCB2ZXJ5IG11Y2gg
aXMgb3V0IG9mIHRoZSBwaWN0dXJlLg0KDQpUaG9tYXMgaXMgY29ycmVjdCB0aGF0IHRoZSBpbnRl
cmZhY2UgeW91IHByb3Bvc2UgaGVyZSBkb2Vzbid0IHdvcmsgYXQgDQphbGwgZm9yIEdQVXMuDQoN
ClRoZSBrZXJuZWwgZHJpdmVyIGlzIG5vdCBpbmZvcm1lZCBvZiBmbHVzaC9zeW5jLCBidXQgcmF0
aGVyIGp1c3Qgc2V0dXBzIA0KY29oZXJlbnQgbWFwcGluZ3MgYmV0d2VlbiBzeXN0ZW0gbWVtb3J5
IGFuZCBkZXZpY2VzLg0KDQpJbiBvdGhlciB3b3JkcyB5b3UgaGF2ZSBhbiBhcnJheSBvZiBzdHJ1
Y3QgcGFnZXMgYW5kIG5lZWQgdG8gbWFwIHRoYXQgdG8gDQphIHNwZWNpZmljIGRldmljZSBhbmQg
c28gY3JlYXRlIGRtYV9hZGRyZXNzZXMgZm9yIHRoZSBtYXBwaW5ncy4NCg0KUmVnYXJkcywNCkNo
cmlzdGlhbi4NCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
CmRyaS1kZXZlbCBtYWlsaW5nIGxpc3QKZHJpLWRldmVsQGxpc3RzLmZyZWVkZXNrdG9wLm9yZwpo
dHRwczovL2xpc3RzLmZyZWVkZXNrdG9wLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2RyaS1kZXZlbAo=
