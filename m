From: "hch@lst.de" <hch@lst.de>
Subject: Re: [PATCH] lib/scatterlist: Provide a DMA page iterator
Date: Tue, 15 Jan 2019 19:31:33 +0100
Message-ID: <20190115183133.GA12350@lst.de>
References: <20190104223531.GA1705@ziepe.ca> <20190110234218.GM6890@ziepe.ca>
 <20190114094856.GB29604@lst.de>
 <1fb20ab4b171b281e9994b6c55734c120958530b.camel@vmware.com>
 <2b440a3b-ed2f-8fd6-a21e-97ca0b2f5db9@gmail.com>
 <20190115152029.GB2325@lst.de>
 <41d0616e95fb48942404fb54d82249f5700affb1.camel@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <41d0616e95fb48942404fb54d82249f5700affb1.camel@vmware.com>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>, "jian.xu.zheng@intel.com" <jian.xu.zheng@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "christian.koenig@amd.com" <christian.koenig@amd.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>, "bingbu.cao@intel.com" <bingbu.cao@intel.com>, "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>, "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>, "hch@lst.de" <hch@lst.de>, "tian.shu.qiu@intel.com" <tian.shu.qiu@intel.com>, "yong.zhi@intel.com" <yong.zhi@intel.com>
List-Id: linux-rdma@vger.kernel.org

T24gVHVlLCBKYW4gMTUsIDIwMTkgYXQgMDY6MDM6MzlQTSArMDAwMCwgVGhvbWFzIEhlbGxzdHJv
bSB3cm90ZToKPiBJbiB0aGUgZ3JhcGhpY3MgY2FzZSwgaXQncyBwcm9iYWJseSBiZWNhdXNlIGl0
IGRvZXNuJ3QgZml0IHRoZSBncmFwaGljcwo+IHVzZS1jYXNlczoKPiAKPiAxKSBNZW1vcnkgdHlw
aWNhbGx5IG5lZWRzIHRvIGJlIG1hcHBhYmxlIGJ5IGFub3RoZXIgZGV2aWNlLiAodGhlICJkbWEt
Cj4gYnVmIiBpbnRlcmZhY2UpCgpBbmQgdGhlcmUgaXMgbm90aGluZyBwcmV2ZW50aW5nIGRtYS1i
dWYgc2hhcmluZyBvZiB0aGVzZSBidWZmZXJzLgpVbmxpa2UgdGhlIGdldF9zZ3RhYmxlIG1lc3Mg
aXQgY2FuIGFjdHVhbGx5IHdvcmsgcmVsaWFibHkgb24KYXJjaGl0ZWN0dXJlcyB0aGF0IGhhdmUg
dmlydHVhbGx5IHRhZ2dlZCBjYWNoZXMgYW5kL29yIGRvbid0Cmd1YXJhbnRlZSBjYWNoZSBjb2hl
cmVuY3kgd2l0aCBtaXhlZCBhdHRyaWJ1dGUgbWFwcGluZ3MuCgo+IDIpIERNQSBidWZmZXJzIGFy
ZSBleHBvcnRlZCB0byB1c2VyLXNwYWNlIGFuZCBpcyBzdWItYWxsb2NhdGVkIGJ5IGl0Lgo+IE1v
c3RseSB0aGVyZSBhcmUgbm8gR1BVIHVzZXItc3BhY2Uga2VybmVsIGludGVyZmFjZXMgdG8gc3lu
YyAvIGZsdXNoCj4gc3VicmVnaW9ucyBhbmQgdGhlc2Ugc3luY3MgbWF5IGhhcHBlbiBvbiBhIHNt
YWxsZXItdGhhbi1jYWNoZS1saW5lCj4gZ3JhbnVsYXJpdHkuCgpJIGtub3cgb2Ygbm8gYXJjaGl0
ZWN0dXJlcyB0aGF0IGNhbiBkbyBjYWNoZSBtYWludGFpbmFuY2Ugb24gYSBsZXNzCnRoYW4gY2Fj
aGUgbGluZSBiYXNpcy4gIEVpdGhlciB0aGUgaW5zdHJ1Y3Rpb25zIHJlcXVpcmUgeW91IHRvCnNw
ZWNpZmN5IGNhY2hlIGxpbmVzLCBvciB0aGV5IGRvIHNvbWV0aW1lcyBtb3JlLCBzb21ldGltZXMg
bGVzcwppbnRlbGxpZ2VudCByb3VuZGluZyB1cC4KCk5vdGUgdGhhdCBhcyBsb25nIGRtYSBub24t
Y29oZXJlbnQgYnVmZmVycyBhcmUgZGV2aWNlcyBvd25lZCBpdAppcyB1cCB0byB0aGUgZGV2aWNl
IGFuZCB0aGUgdXNlciBzcGFjZSBkcml2ZXIgdG8gdGFrZSBjYXJlIG9mCmNvaGVyZW5jeSwgdGhl
IGtlcm5lbCB2ZXJ5IG11Y2ggaXMgb3V0IG9mIHRoZSBwaWN0dXJlLgpfX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpkcmktZGV2ZWwgbWFpbGluZyBsaXN0CmRy
aS1kZXZlbEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5v
cmcvbWFpbG1hbi9saXN0aW5mby9kcmktZGV2ZWwK
