From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 09/16] cnic: stop passing bogus gfp flags
 arguments to dma_alloc_coherent
Date: Fri, 14 Jun 2019 15:47:19 +0200
Message-ID: <20190614134726.3827-10-hch@lst.de>
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

ZG1hX2FsbG9jX2NvaGVyZW50IGlzIG5vdCBqdXN0IHRoZSBwYWdlIGFsbG9jYXRvci4gIFRoZSBv
bmx5IHZhbGlkCmFyZ3VtZW50cyB0byBwYXNzIGFyZSBlaXRoZXIgR0ZQX0FUT01JQyBvciBHRlBf
QVRPTUlDIHdpdGggcG9zc2libGUKbW9kaWZpZXJzIG9mIF9fR0ZQX05PUkVUUlkgb3IgX19HRlBf
Tk9XQVJOLgoKU2lnbmVkLW9mZi1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+Ci0t
LQogZHJpdmVycy9uZXQvZXRoZXJuZXQvYnJvYWRjb20vY25pYy5jIHwgNCArKy0tCiAxIGZpbGUg
Y2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L2Jyb2FkY29tL2NuaWMuYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0
L2Jyb2FkY29tL2NuaWMuYwppbmRleCA1N2RjM2NiZmYzNmUuLmJkMWM5OTM2ODBlNSAxMDA2NDQK
LS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvYnJvYWRjb20vY25pYy5jCisrKyBiL2RyaXZlcnMv
bmV0L2V0aGVybmV0L2Jyb2FkY29tL2NuaWMuYwpAQCAtMTAyOCw3ICsxMDI4LDcgQEAgc3RhdGlj
IGludCBfX2NuaWNfYWxsb2NfdWlvX3JpbmdzKHN0cnVjdCBjbmljX3Vpb19kZXYgKnVkZXYsIGlu
dCBwYWdlcykKIAl1ZGV2LT5sMl9yaW5nX3NpemUgPSBwYWdlcyAqIENOSUNfUEFHRV9TSVpFOwog
CXVkZXYtPmwyX3JpbmcgPSBkbWFfYWxsb2NfY29oZXJlbnQoJnVkZXYtPnBkZXYtPmRldiwgdWRl
di0+bDJfcmluZ19zaXplLAogCQkJCQkgICAmdWRldi0+bDJfcmluZ19tYXAsCi0JCQkJCSAgIEdG
UF9LRVJORUwgfCBfX0dGUF9DT01QKTsKKwkJCQkJICAgR0ZQX0tFUk5FTCk7CiAJaWYgKCF1ZGV2
LT5sMl9yaW5nKQogCQlyZXR1cm4gLUVOT01FTTsKIApAQCAtMTAzNiw3ICsxMDM2LDcgQEAgc3Rh
dGljIGludCBfX2NuaWNfYWxsb2NfdWlvX3JpbmdzKHN0cnVjdCBjbmljX3Vpb19kZXYgKnVkZXYs
IGludCBwYWdlcykKIAl1ZGV2LT5sMl9idWZfc2l6ZSA9IENOSUNfUEFHRV9BTElHTih1ZGV2LT5s
Ml9idWZfc2l6ZSk7CiAJdWRldi0+bDJfYnVmID0gZG1hX2FsbG9jX2NvaGVyZW50KCZ1ZGV2LT5w
ZGV2LT5kZXYsIHVkZXYtPmwyX2J1Zl9zaXplLAogCQkJCQkgICZ1ZGV2LT5sMl9idWZfbWFwLAot
CQkJCQkgIEdGUF9LRVJORUwgfCBfX0dGUF9DT01QKTsKKwkJCQkJICBHRlBfS0VSTkVMKTsKIAlp
ZiAoIXVkZXYtPmwyX2J1ZikgewogCQlfX2NuaWNfZnJlZV91aW9fcmluZ3ModWRldik7CiAJCXJl
dHVybiAtRU5PTUVNOwotLSAKMi4yMC4xCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fXwpJbnRlbC1nZnggbWFpbGluZyBsaXN0CkludGVsLWdmeEBsaXN0cy5m
cmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0
aW5mby9pbnRlbC1nZng=
