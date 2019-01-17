From: Thomas Hellstrom <thellstrom@vmware.com>
Subject: Re: [PATCH] lib/scatterlist: Provide a DMA page iterator
Date: Thu, 17 Jan 2019 10:47:38 +0000
Message-ID: <c03889ffe2153cd84d263873bc8bd559c439177a.camel@vmware.com>
References: <20190104223531.GA1705@ziepe.ca>	 <20190110234218.GM6890@ziepe.ca>
 <20190114094856.GB29604@lst.de>
 <1fb20ab4b171b281e9994b6c55734c120958530b.camel@vmware.com>
 <20190115212501.GE22045@ziepe.ca> <20190116161134.GA29041@lst.de>
 <20190116172436.GM22045@ziepe.ca> <20190117093001.GB31303@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20190117093001.GB31303@lst.de>
Content-Language: en-US
Content-ID: <724C136F9533C74290DE9D9D2B8F64D1@namprd05.prod.outlook.com>
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
Cc: "syeh@vmware.com" <syeh@vmware.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>, "jian.xu.zheng@intel.com" <jian.xu.zheng@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>, "bingbu.cao@intel.com" <bingbu.cao@intel.com>, "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>, "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>, "tian.shu.qiu@intel.com" <tian.shu.qiu@intel.com>, "yong.zhi@intel.com" <yong.zhi@intel.com>
List-Id: linux-rdma@vger.kernel.org

T24gVGh1LCAyMDE5LTAxLTE3IGF0IDEwOjMwICswMTAwLCBoY2hAbHN0LmRlIHdyb3RlOg0KPiBP
biBXZWQsIEphbiAxNiwgMjAxOSBhdCAxMDoyNDozNkFNIC0wNzAwLCBKYXNvbiBHdW50aG9ycGUg
d3JvdGU6DQo+ID4gVGhlIGZhY3QgaXMgdGhlcmUgaXMgMCBpbmR1c3RyeSBpbnRlcmVzdCBpbiB1
c2luZyBSRE1BIG9uIHBsYXRmb3Jtcw0KPiA+IHRoYXQgY2FuJ3QgZG8gSFcgRE1BIGNhY2hlIGNv
aGVyZW5jeSAtIHRoZSBrZXJuZWwgc3lzY2FsbHMgcmVxdWlyZWQNCj4gPiB0bw0KPiA+IGRvIHRo
ZSBjYWNoZSBmbHVzaGluZyBvbiB0aGUgSU8gcGF0aCB3b3VsZCBqdXN0IGRlc3Ryb3kgcGVyZm9y
bWFuY2UNCj4gPiB0bw0KPiA+IHRoZSBwb2ludCBvZiBtYWtpbmcgUkRNQSBwb2ludGxlc3MuIEJl
dHRlciB0byB1c2UgbmV0ZGV2IG9uIHRob3NlDQo+ID4gcGxhdGZvcm1zLg0KPiANCj4gSW4gZ2Vu
ZXJhbCB0aGVyZSBpcyBubyBzeXNjYWxsIHJlcXVpcmVkIGZvciBkb2luZyBjYWNoZSBmbHVzaGlu
ZywgeW91DQo+IGp1c3QgaXNzdWUgdGhlIHByb3BlciBpbnN0cnVjdGlvbnMgZGlyZWN0bHkgZnJv
bSB1c2Vyc3BhY2UuDQoNCkJ1dCB3aGF0IGlmIHRoZXJlIGFyZSBvdGhlciBjb2hlcmVuY2UgaXNz
dWVzPyBMaWtlIGJvdW5jZS1idWZmZXJzPw0KSSdkIGxpa2UgdG8gKzEgb24gd2hhdCBKYXNvbiBz
YXlzIGFib3V0IGluZHVzdHJ5IGludGVyZXN0OiBGV0lXLCB2bXdnZngNCmlzIHByb2JhYmx5IG9u
ZSBvZiB0aGUgZ3JhcGhpY3MgZHJpdmVycyB0aGF0IHdvdWxkIGxlbmQgaXRzZWxmIGJlc3QgdG8N
CmRvIGEgZnVsbHktZG1hLWludGVyZmFjZSBjb21wbGlhbnQgZ3JhcGhpY3Mgc3RhY2sgZXhwZXJp
bWVudC4gQnV0IGJlaW5nDQphIHBhcmF2aXJ0dWFsIGRyaXZlciwgYWxsIHBsYXRmb3JtcyB3ZSBj
YW4gZXZlciBydW4gb24gYXJlIGZ1bGx5DQpjb2hlcmVudCB1bmxlc3Mgc29tZW9uZSBpbnRyb2R1
Y2VzIGEgZmFrZSBpbmNvaGVyZW5jeSBieSBmb3JjaW5nDQpzd2lvdGxiLiBQdXR0aW5nIG1hbnkg
bWFuLW1vbnRocyBvZiBlZmZvcnQgaW50byBzdXBwb3J0aW5nIHN5c3RlbXMgb24NCndoaWNoIHdl
IHdvdWxkIG5ldmVyIHJ1biBvbiBhbmQgY2FuIG5ldmVyIHRlc3Qgb24gY2FuIG5ldmVyIG1ha2Ug
bW9yZQ0KdGhhbiBhY2FkZW1pYyBzZW5zZS4NCg0KPiAgDQo+IA0KPiA+IFRoZSByZWFsaXR5IGlz
IHRoYXQgKmFsbCogdGhlIHN1YnN5dGVtcyBkb2luZyBETUEga2VybmVsIGJ5cGFzcyBhcmUNCj4g
PiBpZ25vcmluZyB0aGUgRE1BIG1hcHBpbmcgcnVsZXMsIEkgdGhpbmsgd2Ugc2hvdWxkIHN1cHBv
cnQgdGhpcw0KPiA+IGJldHRlciwNCj4gPiBhbmQganVzdCBhY2NlcHQgdGhhdCB1c2VyIHNwYWNl
IERNQSB3aWxsIG5vdCBiZSB1c2luZyBzeW5jaW5nLg0KPiA+IEJsb2NrDQo+ID4gYWNjZXNzIGlu
IGNhc2VzIHdoZW4gdGhpcyBpcyByZXF1aXJlZCwgb3RoZXJ3aXNlIGxldCBpdCB3b3JrIGFzIGlz
DQo+ID4gdG9kYXkuDQo+IA0KPiBJbiB0aGF0IGNhc2Ugd2UganVzdCBuZWVkIHRvIGJsb2NrIHVz
ZXJzcGFjZSBETUEgYWNjZXNzIGVudGlyZWx5Lg0KPiBXaGljaCBnaXZlbiB0aGUgYW1vdW50IG9m
IHByb2JsZW1zIGl0IGNyZWF0ZXMgc291bmRzIGxpa2UgYSBwcmV0dHkNCj4gZ29vZCBpZGVhIGFu
eXdheS4NCg0KSSdtIG5vdCBzdXJlIEknbSBmb2xsb3dpbmcgeW91IGhlcmUuIEFyZSB5b3Ugc3Vn
Z2VzdGluZyBzY3JhdGNoaW5nDQpzdXBwb3J0IGZvciBhbGwgKEdQKUdQVS0gYW5kIFJETUEgZHJp
dmVycz8NCg0KVGhhbmtzLA0KVGhvbWFzDQoNCg0KX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX18KZHJpLWRldmVsIG1haWxpbmcgbGlzdApkcmktZGV2ZWxAbGlz
dHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4v
bGlzdGluZm8vZHJpLWRldmVsCg==
