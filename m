From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 05/16] drm: don't mark pages returned from
 drm_pci_alloc reserved
Date: Fri, 14 Jun 2019 15:47:15 +0200
Message-ID: <20190614134726.3827-6-hch@lst.de>
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

V2UgYXJlIG5vdCBhbGxvd2VkIHRvIGNhbGwgdmlydF90b19wYWdlIG9uIHBhZ2VzIHJldHVybmVk
IGZyb20KZG1hX2FsbG9jX2NvaGVyZW50LCBhcyBpbiBtYW55IGNhc2VzIHRoZSB2aXJ0dWFsIGFk
ZHJlc3MgcmV0dXJuZWQKaXMgYWFjdHVhbGx5IGEga2VybmVsIGRpcmVjdCBtYXBwaW5nLiAgQWxz
byB0aGVyZSBnZW5lcmFsbHkgaXMgbm8KbmVlZCB0byBtYXJrIGRtYSBtZW1vcnkgYXMgcmVzZXJ2
ZWQuCgpTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4KLS0tCiBk
cml2ZXJzL2dwdS9kcm0vZHJtX2J1ZnMuYyB8IDE2ICstLS0tLS0tLS0tLS0tLS0KIDEgZmlsZSBj
aGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMTUgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJp
dmVycy9ncHUvZHJtL2RybV9idWZzLmMgYi9kcml2ZXJzL2dwdS9kcm0vZHJtX2J1ZnMuYwppbmRl
eCA3NDE4ODcyZDg3YzYuLmI2NDA0MzdjZTkwZiAxMDA2NDQKLS0tIGEvZHJpdmVycy9ncHUvZHJt
L2RybV9idWZzLmMKKysrIGIvZHJpdmVycy9ncHUvZHJtL2RybV9idWZzLmMKQEAgLTc3LDEzICs3
Nyw2IEBAIGRybV9kbWFfaGFuZGxlX3QgKmRybV9wY2lfYWxsb2Moc3RydWN0IGRybV9kZXZpY2Ug
KiBkZXYsIHNpemVfdCBzaXplLCBzaXplX3QgYWxpCiAJCXJldHVybiBOVUxMOwogCX0KIAotCS8q
IFhYWCAtIElzIHZpcnRfdG9fcGFnZSgpIGxlZ2FsIGZvciBjb25zaXN0ZW50IG1lbT8gKi8KLQkv
KiBSZXNlcnZlICovCi0JZm9yIChhZGRyID0gKHVuc2lnbmVkIGxvbmcpZG1haC0+dmFkZHIsIHN6
ID0gc2l6ZTsKLQkgICAgIHN6ID4gMDsgYWRkciArPSBQQUdFX1NJWkUsIHN6IC09IFBBR0VfU0la
RSkgewotCQlTZXRQYWdlUmVzZXJ2ZWQodmlydF90b19wYWdlKCh2b2lkICopYWRkcikpOwotCX0K
LQogCXJldHVybiBkbWFoOwogfQogCkBAIC05NywxNiArOTAsOSBAQCB2b2lkIF9fZHJtX2xlZ2Fj
eV9wY2lfZnJlZShzdHJ1Y3QgZHJtX2RldmljZSAqIGRldiwgZHJtX2RtYV9oYW5kbGVfdCAqIGRt
YWgpCiAJdW5zaWduZWQgbG9uZyBhZGRyOwogCXNpemVfdCBzejsKIAotCWlmIChkbWFoLT52YWRk
cikgewotCQkvKiBYWFggLSBJcyB2aXJ0X3RvX3BhZ2UoKSBsZWdhbCBmb3IgY29uc2lzdGVudCBt
ZW0/ICovCi0JCS8qIFVucmVzZXJ2ZSAqLwotCQlmb3IgKGFkZHIgPSAodW5zaWduZWQgbG9uZylk
bWFoLT52YWRkciwgc3ogPSBkbWFoLT5zaXplOwotCQkgICAgIHN6ID4gMDsgYWRkciArPSBQQUdF
X1NJWkUsIHN6IC09IFBBR0VfU0laRSkgewotCQkJQ2xlYXJQYWdlUmVzZXJ2ZWQodmlydF90b19w
YWdlKCh2b2lkICopYWRkcikpOwotCQl9CisJaWYgKGRtYWgtPnZhZGRyKQogCQlkbWFfZnJlZV9j
b2hlcmVudCgmZGV2LT5wZGV2LT5kZXYsIGRtYWgtPnNpemUsIGRtYWgtPnZhZGRyLAogCQkJCSAg
ZG1haC0+YnVzYWRkcik7Ci0JfQogfQogCiAvKioKLS0gCjIuMjAuMQoKX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KSW50ZWwtZ2Z4IG1haWxpbmcgbGlzdApJ
bnRlbC1nZnhAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlzdHMuZnJlZWRlc2t0b3Au
b3JnL21haWxtYW4vbGlzdGluZm8vaW50ZWwtZ2Z4
