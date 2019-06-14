From: 'Christoph Hellwig' <hch@lst.de>
Subject: Re: [PATCH 16/16] dma-mapping: use exact allocation in
 dma_alloc_contiguous
Date: Fri, 14 Jun 2019 17:08:27 +0200
Message-ID: <20190614150827.GA9460@lst.de>
References: <20190614134726.3827-1-hch@lst.de>
 <20190614134726.3827-17-hch@lst.de>
 <a90cf7ec5f1c4166b53c40e06d4d832a@AcuMS.aculab.com>
 <20190614145001.GB9088@lst.de> <4113cd5f-5c13-e9c7-bc5e-dcf0b60e7054@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <4113cd5f-5c13-e9c7-bc5e-dcf0b60e7054@arm.com>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/intel-gfx>
List-Post: <mailto:intel-gfx@lists.freedesktop.org>
List-Help: <mailto:intel-gfx-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=subscribe>
Errors-To: intel-gfx-bounces@lists.freedesktop.org
Sender: "Intel-gfx" <intel-gfx-bounces@lists.freedesktop.org>
To: Robin Murphy <robin.murphy@arm.com>
Cc: Maxime Ripard <maxime.ripard@bootlin.com>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 'Christoph Hellwig' <hch@lst.de>, "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>, "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, David Airlie <airlied@linux.ie>, "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>, Intel Linux Wireless <linuxwifi@intel.com>, "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>, Ian Abbott <abbotti@mev.co.uk>, "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, H Hartley Sweeten <hsweeten@v>
List-Id: linux-rdma@vger.kernel.org

T24gRnJpLCBKdW4gMTQsIDIwMTkgYXQgMDQ6MDU6MzNQTSArMDEwMCwgUm9iaW4gTXVycGh5IHdy
b3RlOgo+IFRoYXQgc2FpZCwgSSBkb24ndCBiZWxpZXZlIHRoaXMgcGFydGljdWxhciBwYXRjaCBz
aG91bGQgbWFrZSBhbnkgCj4gYXBwcmVjaWFibGUgZGlmZmVyZW5jZSAtIGFsbG9jX3BhZ2VzX2V4
YWN0KCkgaXMgc3RpbGwgZ29pbmcgdG8gZ2l2ZSBiYWNrIAo+IHRoZSBzYW1lIGJhc2UgYWRkcmVz
cyBhcyB0aGUgcm91bmRlZCB1cCBvdmVyLWFsbG9jYXRpb24gd291bGQsIGFuZCAKPiBQQUdFX0FM
SUdOKClpbmcgdGhlIHNpemUgcGFzc2VkIHRvIGdldF9vcmRlcigpIGFscmVhZHkgc2VlbWVkIHRv
IGJlIAo+IHBvaW50bGVzcy4KClRydWUsIHdlIGFjdHVhbGx5IGRvIGdldCB0aGUgcmlnaHQgYWxp
Z25tZW50IGp1c3QgYWJvdXQgYW55d2hlcmUuCk5vdCAxMDAlIHN1cmUgYWJvdXQgdGhlIHZhcmlv
dXMgc3RhdGljIHBvb2wgaW1wbGVtZW50YXRpb25zLCBidXQgd2UKY2FuIG1ha2Ugc3VyZSBpZiBh
bnkgZGlkbid0IHdlJ2xsIGRvIHRoYXQgcmlnaHQgdGhpbmcgb25jZSB0aG9zZQpnZXQgY29uc29s
aWRhdGVkLgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpJ
bnRlbC1nZnggbWFpbGluZyBsaXN0CkludGVsLWdmeEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0
cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9pbnRlbC1nZng=
