From: Thomas Hellstrom <thellstrom@vmware.com>
Subject: Re: [PATCH] lib/scatterlist: Provide a DMA page iterator
Date: Tue, 15 Jan 2019 14:17:26 +0000
Message-ID: <1fb20ab4b171b281e9994b6c55734c120958530b.camel@vmware.com>
References: <20190104223531.GA1705@ziepe.ca>	 <20190110234218.GM6890@ziepe.ca>
 <20190114094856.GB29604@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20190114094856.GB29604@lst.de>
Content-Language: en-US
Content-ID: <08354190753F9248B70A9EE8CA12BF44@namprd05.prod.outlook.com>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: "hch@lst.de" <hch@lst.de>, "jgg@ziepe.ca" <jgg@ziepe.ca>
Cc: "syeh@vmware.com" <syeh@vmware.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>, "jian.xu.zheng@intel.com" <jian.xu.zheng@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>, "bingbu.cao@intel.com" <bingbu.cao@intel.com>, "yong.zhi@intel.com" <yong.zhi@intel.com>, "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>, "tian.shu.qiu@intel.com" <tian.shu.qiu@intel.com>, "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

SGksIENocmlzdG9waCwNCg0KT24gTW9uLCAyMDE5LTAxLTE0IGF0IDEwOjQ4ICswMTAwLCBDaHJp
c3RvcGggSGVsbHdpZyB3cm90ZToNCj4gT24gVGh1LCBKYW4gMTAsIDIwMTkgYXQgMDQ6NDI6MThQ
TSAtMDcwMCwgSmFzb24gR3VudGhvcnBlIHdyb3RlOg0KPiA+ID4gQ2hhbmdlcyBzaW5jZSB0aGUg
UkZDOg0KPiA+ID4gLSBSZXdvcmsgdm13Z2Z4IHRvbyBbQ0hdDQo+ID4gPiAtIFVzZSBhIGRpc3Rp
bmN0IHR5cGUgZm9yIHRoZSBETUEgcGFnZSBpdGVyYXRvciBbQ0hdDQo+ID4gPiAtIERvIG5vdCBo
YXZlIGEgI2lmZGVmIFtDSF0NCj4gPiANCj4gPiBDaHJpc3RvcGhIOiBXaWxsIHlvdSBhY2s/DQo+
IA0KPiBUaGlzIGxvb2tzIGdlbmVyYWxseSBmaW5lLg0KPiANCj4gPiBBcmUgeW91IHN0aWxsIE9L
IHdpdGggdGhlIHZtd2dmeCByZXdvcmtpbmcsIG9yIHNob3VsZCB3ZSBnbyBiYWNrIHRvDQo+ID4g
dGhlIG9yaWdpbmFsIHZlcnNpb24gdGhhdCBkaWRuJ3QgaGF2ZSB0aGUgdHlwZSBzYWZldHkgc28g
dGhpcw0KPiA+IGRyaXZlcg0KPiA+IGNhbiBiZSBsZWZ0IGJyb2tlbj8NCj4gDQo+IEkgdGhpbmsg
dGhlIG1hcCBtZXRob2QgaW4gdm1nZnggdGhhdCBqdXN0IGRvZXMgdmlydF90b19waHlzIGlzDQo+
IHByZXR0eSBicm9rZW4uICBUaG9tYXMsIGNhbiB5b3UgY2hlY2sgaWYgeW91IHNlZSBhbnkgcGVy
Zm9ybWFuY2UNCj4gZGlmZmVyZW5jZSB3aXRoIGp1c3QgZG9pbmcgdGhlIHByb3BlciBkbWEgbWFw
cGluZywgYXMgdGhhdCBnZXRzIHRoZQ0KPiBkcml2ZXIgb3V0IG9mIGludGVyZmFjZSBhYnVzZSBs
YW5kPw0KDQpUaGUgcGVyZm9ybWFuY2UgZGlmZmVyZW5jZSBpcyBub3QgcmVhbGx5IHRoZSBtYWlu
IHByb2JsZW0gaGVyZS4gVGhlDQpwcm9ibGVtIGlzIHRoYXQgZXZlbiB0aG91Z2ggd2UgdXRpbGl6
ZSB0aGUgc3RyZWFtaW5nIERNQSBpbnRlcmZhY2UsIHdlDQp1c2UgaXQgb25seSBzaW5jZSB3ZSBo
YXZlIHRvIGZvciBETUEtUmVtYXBwaW5nIGFuZCBhc3N1bWUgdGhhdCB0aGUNCm1lbW9yeSBpcyBj
b2hlcmVudC4gVG8gYmUgYWJsZSB0byBiZSBhcyBjb21wbGlhbnQgYXMgcG9zc2libGUgYW5kIGRp
dGNoDQp0aGUgdmlydC10by1waHlzIG1vZGUsIHdlICpuZWVkKiBhIERNQSBpbnRlcmZhY2UgZmxh
ZyB0aGF0IHRlbGxzIHVzDQp3aGVuIHRoZSBkbWFfc3luY19mb3JfeHh4IGFyZSBuby1vcHMuIElm
IHRoZXkgYXJlbid0IHdlJ2xsIHJlZnVzZSB0bw0KbG9hZCBmb3Igbm93LiBJJ20gbm90IHN1cmUs
IGJ1dCBJIHRoaW5rIGFsc28gbm91dmVhdSBhbmQgcmFkZW9uIHN1ZmZlcg0KZnJvbSB0aGUgc2Ft
ZSBpc3N1ZS4NCg0KPiANCj4gV2hpbGUgd2UncmUgYXQgaXQgSSB0aGluayB3ZSBuZWVkIHRvIG1l
cmdlIG15IHNlcmllcyBpbiB0aGlzIGFyZWENCj4gZm9yIDUuMCwgYmVjYXVzZSB3aXRob3V0IHRo
YXQgdGhlIGRyaXZlciBpcyBhbHJlYWR5IGJyb2tlbi4gIFdoZXJlDQo+IHNob3VsZCB3ZSBtZXJn
ZSBpdD8NCg0KSSBjYW4gbWVyZ2UgaXQgdGhyb3VnaCB2bXdnZngvZHJtLWZpeGVzLiBUaGVyZSBp
cyBhbiBvdXRzdGFuZGluZyBpc3N1ZQ0Kd2l0aCBwYXRjaCAzLiBEbyB5b3Ugd2FudCBtZSB0byBm
aXggdGhhdCB1cD8NCg0KVGhhbmtzLA0KVGhvbWFzDQoNCg0KX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX18KZHJpLWRldmVsIG1haWxpbmcgbGlzdApkcmktZGV2
ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21h
aWxtYW4vbGlzdGluZm8vZHJpLWRldmVsCg==
