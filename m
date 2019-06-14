From: David Laight <David.Laight@ACULAB.COM>
Subject: Re: [PATCH 16/16] dma-mapping: use exact allocation in
 dma_alloc_contiguous
Date: Fri, 14 Jun 2019 15:16:43 +0000
Message-ID: <d8009432a10549bbbda802021562a28b@AcuMS.aculab.com>
References: <20190614134726.3827-1-hch@lst.de>
 <20190614134726.3827-17-hch@lst.de>
 <a90cf7ec5f1c4166b53c40e06d4d832a@AcuMS.aculab.com>
 <20190614145001.GB9088@lst.de> <4113cd5f-5c13-e9c7-bc5e-dcf0b60e7054@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
In-Reply-To: <4113cd5f-5c13-e9c7-bc5e-dcf0b60e7054@arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/intel-gfx>
List-Post: <mailto:intel-gfx@lists.freedesktop.org>
List-Help: <mailto:intel-gfx-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=subscribe>
Errors-To: intel-gfx-bounces@lists.freedesktop.org
Sender: "Intel-gfx" <intel-gfx-bounces@lists.freedesktop.org>
To: 'Robin Murphy' <robin.murphy@arm.com>, 'Christoph Hellwig' <hch@lst.de>
Cc: Maxime Ripard <maxime.ripard@bootlin.com>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>, "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, David Airlie <airlied@linux.ie>, "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>, Intel Linux Wireless <linuxwifi@intel.com>, "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>, Ian Abbott <abbotti@mev.co.uk>, "moderated list:ARM
 PORT" <linux-arm-kernel@lists.infradead.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, H Hartley Sweeten <hsweeten@visionengravers.com>, iommu@lists
List-Id: linux-rdma@vger.kernel.org

RnJvbTogUm9iaW4gTXVycGh5DQo+IFNlbnQ6IDE0IEp1bmUgMjAxOSAxNjowNg0KLi4uDQo+IFdl
bGwsIGFwYXJ0IGZyb20gdGhlIGJpdCBpbiBETUEtQVBJLUhPV1RPIHdoaWNoIGhhcyBzYWlkIHRo
aXMgc2luY2UNCj4gZm9yZXZlciAod2VsbCwgYmVmb3JlIEdpdCBoaXN0b3J5LCBhdCBsZWFzdCk6
DQo+IA0KPiAiVGhlIENQVSB2aXJ0dWFsIGFkZHJlc3MgYW5kIHRoZSBETUEgYWRkcmVzcyBhcmUg
Ym90aA0KPiBndWFyYW50ZWVkIHRvIGJlIGFsaWduZWQgdG8gdGhlIHNtYWxsZXN0IFBBR0VfU0la
RSBvcmRlciB3aGljaA0KPiBpcyBncmVhdGVyIHRoYW4gb3IgZXF1YWwgdG8gdGhlIHJlcXVlc3Rl
ZCBzaXplLiAgVGhpcyBpbnZhcmlhbnQNCj4gZXhpc3RzIChmb3IgZXhhbXBsZSkgdG8gZ3VhcmFu
dGVlIHRoYXQgaWYgeW91IGFsbG9jYXRlIGEgY2h1bmsNCj4gd2hpY2ggaXMgc21hbGxlciB0aGFu
IG9yIGVxdWFsIHRvIDY0IGtpbG9ieXRlcywgdGhlIGV4dGVudCBvZiB0aGUNCj4gYnVmZmVyIHlv
dSByZWNlaXZlIHdpbGwgbm90IGNyb3NzIGEgNjRLIGJvdW5kYXJ5LiINCg0KSSBrbmV3IGl0IHdh
cyBzb21ld2hlcmUgOi0pDQpJbnRlcmVzdGluZ2x5IHRoYXQgYWxzbyBpbXBsaWVzIHRoYXQgdGhl
IGFkZHJlc3MgcmV0dXJuZWQgZm9yIGEgc2l6ZQ0Kb2YgKHNheSkgMTI4IHdpbGwgYWxzbyBiZSBw
YWdlIGFsaWduZWQuDQpJbiB0aGF0IGNhc2UgMTI4IGJ5dGUgYWxpZ25tZW50IHNob3VsZCBwcm9i
YWJseSBiZSBvayAtIGJ1dCBpdCBpcyBzdGlsbA0KYW4gQVBJIGNoYW5nZSB0aGF0IGNvdWxkIGhh
dmUgaG9ycmlkIGNvbnNlcXVlbmNlcy4NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVz
cyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEg
MVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCl9fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkludGVsLWdmeCBtYWlsaW5nIGxpc3QK
SW50ZWwtZ2Z4QGxpc3RzLmZyZWVkZXNrdG9wLm9yZwpodHRwczovL2xpc3RzLmZyZWVkZXNrdG9w
Lm9yZy9tYWlsbWFuL2xpc3RpbmZvL2ludGVsLWdmeA==
