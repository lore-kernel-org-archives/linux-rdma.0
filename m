From: Thomas Hellstrom <thellstrom@vmware.com>
Subject: Re: [PATCH] lib/scatterlist: Provide a DMA page iterator
Date: Tue, 15 Jan 2019 18:03:39 +0000
Message-ID: <41d0616e95fb48942404fb54d82249f5700affb1.camel@vmware.com>
References: <20190104223531.GA1705@ziepe.ca>	 <20190110234218.GM6890@ziepe.ca>
 <20190114094856.GB29604@lst.de>
 <1fb20ab4b171b281e9994b6c55734c120958530b.camel@vmware.com>
 <2b440a3b-ed2f-8fd6-a21e-97ca0b2f5db9@gmail.com>
 <20190115152029.GB2325@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20190115152029.GB2325@lst.de>
Content-Language: en-US
Content-ID: <FED2CBB835F5DD40B292A1B1B614FFB3@namprd05.prod.outlook.com>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: "hch@lst.de" <hch@lst.de>, "christian.koenig@amd.com" <christian.koenig@amd.com>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>, "jian.xu.zheng@intel.com" <jian.xu.zheng@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>, "bingbu.cao@intel.com" <bingbu.cao@intel.com>, "yong.zhi@intel.com" <yong.zhi@intel.com>, "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>, "tian.shu.qiu@intel.com" <tian.shu.qiu@intel.com>, "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

T24gVHVlLCAyMDE5LTAxLTE1IGF0IDE2OjIwICswMTAwLCBoY2hAbHN0LmRlIHdyb3RlOg0KPiBP
biBUdWUsIEphbiAxNSwgMjAxOSBhdCAwMzoyNDo1NVBNICswMTAwLCBDaHJpc3RpYW4gS8O2bmln
IHdyb3RlOg0KPiA+IFllYWgsIGluZGVlZC4gQm91bmNlIGJ1ZmZlcnMgYXJlIGFuIGFic29sdXRl
IG5vLWdvIGZvciBHUFVzLg0KPiA+IA0KPiA+IElmIHRoZSBETUEgQVBJIGZpbmRzIHRoYXQgYSBw
aWVjZSBvZiBtZW1vcnkgaXMgbm90IGRpcmVjdGx5DQo+ID4gYWNjZXNzaWJsZSBieSANCj4gPiB0
aGUgR1BVIHdlIG5lZWQgdG8gcmV0dXJuIGFuIGVycm9yIGFuZCBub3QgdHJ5IHRvIHVzZSBib3Vu
Y2UNCj4gPiBidWZmZXJzIGJlaGluZCANCj4gPiB0aGUgc3VyZmFjZS4NCj4gPiANCj4gPiBUaGF0
IGlzIHNvbWV0aGluZyB3aGljaCBhbHdheXMgYW5ub3llZCBtZSB3aXRoIHRoZSBETUEgQVBJLCB3
aGljaA0KPiA+IGlzIA0KPiA+IG90aGVyd2lzZSByYXRoZXIgY2xlYW5seSBkZWZpbmVkLg0KPiAN
Cj4gVGhhdCBpcyBleGFjdGx5IHdoYXQgSSB3YW50IHRvIGZpeCB3aXRoIG15IHNlcmllcyB0byBt
YWtlDQo+IERNQV9BVFRSX05PTl9DT05TSVNURU5UIG1vcmUgdXNlZnVsIGFuZCBhbHdheXMgYXZh
aWxhYmxlOg0KPiANCj4gaHR0cHM6Ly9uYTAxLnNhZmVsaW5rcy5wcm90ZWN0aW9uLm91dGxvb2su
Y29tLz91cmw9aHR0cHMlM0ElMkYlMkZsaXN0cy5saW51eGZvdW5kYXRpb24ub3JnJTJGcGlwZXJt
YWlsJTJGaW9tbXUlMkYyMDE4LURlY2VtYmVyJTJGMDMxOTg1Lmh0bWwmYW1wO2RhdGE9MDIlN0Mw
MSU3Q3RoZWxsc3Ryb20lNDB2bXdhcmUuY29tJTdDYjE3OTljNDA3MzAyNGE4MjRmOTQwOGQ2N2Fm
Y2ZjZWElN0NiMzkxMzhjYTNjZWU0YjRhYTRkNmNkODNkOWRkNjJmMCU3QzAlN0MwJTdDNjM2ODMx
NjI0MzQwODM0MTQwJmFtcDtzZGF0YT1KaVJCZnpaTXZOM2pvSjR2S2lFcmJ6WEFIYU56dUJjTGFw
UkpETCUyQnQ2SGMlM0QmYW1wO3Jlc2VydmVkPTANCj4gDQo+IFdpdGggdGhhdCB5b3UgYWxsb2Nh
dGUgdGhlIG1lbW9yeSB1c2luZyBkbWFfYWxsb2NfYXR0cnMgd2l0aA0KPiBETUFfQVRUUl9OT05f
Q09OU0lTVEVOVCwgYW5kIHVzZSBkbWFfc3luY19zaW5nbGVfKiB0byB0cmFuc2Zlcg0KPiBvd25l
cnNoaXAgdG8gdGhlIGNwdSBhbmQgYmFjayB0byB0aGUgZGV2aWNlLCB3aXRoIGEgZ3VyYW50ZWUg
dGhhdA0KPiB0aGVyZSB3b24ndCBiZSBhbnkgYm91bmNpbmcuICBTbyBmYXIgdGhlIGludGVyZXN0
IGJ5IHRoZSBwYXJ0aWVzIHRoYXQNCj4gcmVxdWVzdGVkIHRoZSBmZWF0dXJlIGhhcyBiZWVuIHJh
dGhlciBsYWNrbHVzdHJlLCB0aG91Z2guDQoNCkluIHRoZSBncmFwaGljcyBjYXNlLCBpdCdzIHBy
b2JhYmx5IGJlY2F1c2UgaXQgZG9lc24ndCBmaXQgdGhlIGdyYXBoaWNzDQp1c2UtY2FzZXM6DQoN
CjEpIE1lbW9yeSB0eXBpY2FsbHkgbmVlZHMgdG8gYmUgbWFwcGFibGUgYnkgYW5vdGhlciBkZXZp
Y2UuICh0aGUgImRtYS0NCmJ1ZiIgaW50ZXJmYWNlKQ0KMikgRE1BIGJ1ZmZlcnMgYXJlIGV4cG9y
dGVkIHRvIHVzZXItc3BhY2UgYW5kIGlzIHN1Yi1hbGxvY2F0ZWQgYnkgaXQuDQpNb3N0bHkgdGhl
cmUgYXJlIG5vIEdQVSB1c2VyLXNwYWNlIGtlcm5lbCBpbnRlcmZhY2VzIHRvIHN5bmMgLyBmbHVz
aA0Kc3VicmVnaW9ucyBhbmQgdGhlc2Ugc3luY3MgbWF5IGhhcHBlbiBvbiBhIHNtYWxsZXItdGhh
bi1jYWNoZS1saW5lDQpncmFudWxhcml0eS4NCg0KU28gdG8gaGVscCB0aGUgZ3JhcGhpY3MgZHJp
dmVyLCB0aGF0IGNvaGVyZW50IGZsYWcgd291bGQgYmUgbXVjaCBtb3JlDQp1c2VmdWwuDQoNCi9U
aG9tYXMNCg0KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18K
ZHJpLWRldmVsIG1haWxpbmcgbGlzdApkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0
dHBzOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vZHJpLWRldmVsCg==
