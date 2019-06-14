From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 12/16] staging/comedi: mark as broken
Date: Fri, 14 Jun 2019 15:47:22 +0200
Message-ID: <20190614134726.3827-13-hch@lst.de>
References: <20190614134726.3827-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
In-Reply-To: <20190614134726.3827-1-hch@lst.de>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/intel-gfx>
List-Post: <mailto:intel-gfx@lists.freedesktop.org>
List-Help: <mailto:intel-gfx-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=subscribe>
Errors-To: intel-gfx-bounces@lists.freedesktop.org
Sender: "Intel-gfx" <intel-gfx-bounces@lists.freedesktop.org>
To: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <maxime.ripard@bootlin.com>, Sean Paul <sean@poorly.run>, David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>, Jani Nikula <jani.nikula@linux.intel.com>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Ian Abbott <abbotti@mev.co.uk>, H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: devel@driverdev.osuosl.org, linux-s390@vger.kernel.org, Intel Linux Wireless <linuxwifi@intel.com>, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, intel-gfx@lists.freedesktop.org, linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, iommu@lists.linux-foundation.org, "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>, linux-media@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Y29tZWRpX2J1Zi5jIGFidXNlIHRoZSBETUEgQVBJIGluIGdyYXZlbHkgYnJva2VuIHdheXMsIGFz
IGl0IGFzc3VtZXMgaXQKY2FuIGNhbGwgdmlydF90b19wYWdlIG9uIHRoZSByZXN1bHQsIGFuZCB0
aGUganVzdCByZW1hcCBpdCBhcyB1bmNhY2hlZAp1c2luZyB2bWFwLiAgRGlzYWJsZSB0aGUgZHJp
dmVyIHVudGlsIHRoaXMgQVBJIGFidXNlIGhhcyBiZWVuIGZpeGVkLgoKU2lnbmVkLW9mZi1ieTog
Q2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+Ci0tLQogZHJpdmVycy9zdGFnaW5nL2NvbWVk
aS9LY29uZmlnIHwgMSArCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKykKCmRpZmYgLS1n
aXQgYS9kcml2ZXJzL3N0YWdpbmcvY29tZWRpL0tjb25maWcgYi9kcml2ZXJzL3N0YWdpbmcvY29t
ZWRpL0tjb25maWcKaW5kZXggMDQ5YjY1OWZhNmFkLi5lN2MwMjFkNzZjZmEgMTAwNjQ0Ci0tLSBh
L2RyaXZlcnMvc3RhZ2luZy9jb21lZGkvS2NvbmZpZworKysgYi9kcml2ZXJzL3N0YWdpbmcvY29t
ZWRpL0tjb25maWcKQEAgLTEsNiArMSw3IEBACiAjIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBH
UEwtMi4wCiBjb25maWcgQ09NRURJCiAJdHJpc3RhdGUgIkRhdGEgYWNxdWlzaXRpb24gc3VwcG9y
dCAoY29tZWRpKSIKKwlkZXBlbmRzIG9uIEJST0tFTgogCWhlbHAKIAkgIEVuYWJsZSBzdXBwb3J0
IGZvciBhIHdpZGUgcmFuZ2Ugb2YgZGF0YSBhY3F1aXNpdGlvbiBkZXZpY2VzCiAJICBmb3IgTGlu
dXguCi0tIAoyLjIwLjEKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fCkludGVsLWdmeCBtYWlsaW5nIGxpc3QKSW50ZWwtZ2Z4QGxpc3RzLmZyZWVkZXNrdG9w
Lm9yZwpodHRwczovL2xpc3RzLmZyZWVkZXNrdG9wLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2ludGVs
LWdmeA==
