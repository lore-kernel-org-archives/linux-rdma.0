From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] lib/scatterlist: Provide a DMA page iterator
Date: Mon, 14 Jan 2019 10:48:56 +0100
Message-ID: <20190114094856.GB29604@lst.de>
References: <20190104223531.GA1705@ziepe.ca> <20190110234218.GM6890@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <20190110234218.GM6890@ziepe.ca>
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
Cc: Thomas Hellstrom <thellstrom@vmware.com>, Sinclair Yeh <syeh@vmware.com>, linux-rdma@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>, Jian Xu Zheng <jian.xu.zheng@intel.com>, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, Sakari Ailus <sakari.ailus@linux.intel.com>, Bingbu Cao <bingbu.cao@intel.com>, Yong Zhi <yong.zhi@intel.com>, Shiraz Saleem <shiraz.saleem@intel.com>, Christoph Hellwig <hch@lst.de>, Tian Shu Qiu <tian.shu.qiu@intel.com>, linux-media@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

T24gVGh1LCBKYW4gMTAsIDIwMTkgYXQgMDQ6NDI6MThQTSAtMDcwMCwgSmFzb24gR3VudGhvcnBl
IHdyb3RlOgo+ID4gQ2hhbmdlcyBzaW5jZSB0aGUgUkZDOgo+ID4gLSBSZXdvcmsgdm13Z2Z4IHRv
byBbQ0hdCj4gPiAtIFVzZSBhIGRpc3RpbmN0IHR5cGUgZm9yIHRoZSBETUEgcGFnZSBpdGVyYXRv
ciBbQ0hdCj4gPiAtIERvIG5vdCBoYXZlIGEgI2lmZGVmIFtDSF0KPiAKPiBDaHJpc3RvcGhIOiBX
aWxsIHlvdSBhY2s/CgpUaGlzIGxvb2tzIGdlbmVyYWxseSBmaW5lLgoKPiAKPiBBcmUgeW91IHN0
aWxsIE9LIHdpdGggdGhlIHZtd2dmeCByZXdvcmtpbmcsIG9yIHNob3VsZCB3ZSBnbyBiYWNrIHRv
Cj4gdGhlIG9yaWdpbmFsIHZlcnNpb24gdGhhdCBkaWRuJ3QgaGF2ZSB0aGUgdHlwZSBzYWZldHkg
c28gdGhpcyBkcml2ZXIKPiBjYW4gYmUgbGVmdCBicm9rZW4/CgpJIHRoaW5rIHRoZSBtYXAgbWV0
aG9kIGluIHZtZ2Z4IHRoYXQganVzdCBkb2VzIHZpcnRfdG9fcGh5cyBpcwpwcmV0dHkgYnJva2Vu
LiAgVGhvbWFzLCBjYW4geW91IGNoZWNrIGlmIHlvdSBzZWUgYW55IHBlcmZvcm1hbmNlCmRpZmZl
cmVuY2Ugd2l0aCBqdXN0IGRvaW5nIHRoZSBwcm9wZXIgZG1hIG1hcHBpbmcsIGFzIHRoYXQgZ2V0
cyB0aGUKZHJpdmVyIG91dCBvZiBpbnRlcmZhY2UgYWJ1c2UgbGFuZD8KCldoaWxlIHdlJ3JlIGF0
IGl0IEkgdGhpbmsgd2UgbmVlZCB0byBtZXJnZSBteSBzZXJpZXMgaW4gdGhpcyBhcmVhCmZvciA1
LjAsIGJlY2F1c2Ugd2l0aG91dCB0aGF0IHRoZSBkcml2ZXIgaXMgYWxyZWFkeSBicm9rZW4uICBX
aGVyZQpzaG91bGQgd2UgbWVyZ2UgaXQ/Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fCmRyaS1kZXZlbCBtYWlsaW5nIGxpc3QKZHJpLWRldmVsQGxpc3RzLmZy
ZWVkZXNrdG9wLm9yZwpodHRwczovL2xpc3RzLmZyZWVkZXNrdG9wLm9yZy9tYWlsbWFuL2xpc3Rp
bmZvL2RyaS1kZXZlbAo=
