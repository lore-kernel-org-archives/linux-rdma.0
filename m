From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: [PATCH v3 hmm 08/12] mm/hmm: Remove racy protection against
 double-unregistration
Date: Thu, 13 Jun 2019 21:44:46 -0300
Message-ID: <20190614004450.20252-9-jgg@ziepe.ca>
References: <20190614004450.20252-1-jgg@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20190614004450.20252-1-jgg@ziepe.ca>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Jerome Glisse <jglisse@redhat.com>, Ralph Campbell <rcampbell@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, Felix.Kuehling@amd.com
Cc: Andrea Arcangeli <aarcange@redhat.com>, Philip Yang <Philip.Yang@amd.com>, linux-rdma@vger.kernel.org, amd-gfx@lists.freedesktop.org, linux-mm@kvack.org, Jason Gunthorpe <jgg@mellanox.com>, dri-devel@lists.freedesktop.org, Ben Skeggs <bskeggs@redhat.com>
List-Id: linux-rdma@vger.kernel.org

RnJvbTogSmFzb24gR3VudGhvcnBlIDxqZ2dAbWVsbGFub3guY29tPgoKTm8gb3RoZXIgcmVnaXN0
ZXIvdW5yZWdpc3RlciBrZXJuZWwgQVBJIGF0dGVtcHRzIHRvIHByb3ZpZGUgdGhpcyBraW5kIG9m
CnByb3RlY3Rpb24gYXMgaXQgaXMgaW5oZXJlbnRseSByYWN5LCBzbyBqdXN0IGRyb3AgaXQuCgpD
YWxsZXJzIHNob3VsZCBwcm92aWRlIHRoZWlyIG93biBwcm90ZWN0aW9uLCBpdCBhcHBlYXJzIG5v
dXZlYXUgYWxyZWFkeQpkb2VzLCBidXQganVzdCBpbiBjYXNlIGRyb3AgYSBkZWJ1Z2dpbmcgUE9J
U09OLgoKU2lnbmVkLW9mZi1ieTogSmFzb24gR3VudGhvcnBlIDxqZ2dAbWVsbGFub3guY29tPgpS
ZXZpZXdlZC1ieTogSsOpcsO0bWUgR2xpc3NlIDxqZ2xpc3NlQHJlZGhhdC5jb20+ClJldmlld2Vk
LWJ5OiBKb2huIEh1YmJhcmQgPGpodWJiYXJkQG52aWRpYS5jb20+ClJldmlld2VkLWJ5OiBSYWxw
aCBDYW1wYmVsbCA8cmNhbXBiZWxsQG52aWRpYS5jb20+ClRlc3RlZC1ieTogUGhpbGlwIFlhbmcg
PFBoaWxpcC5ZYW5nQGFtZC5jb20+Ci0tLQogbW0vaG1tLmMgfCA5ICsrLS0tLS0tLQogMSBmaWxl
IGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgNyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9t
bS9obW0uYyBiL21tL2htbS5jCmluZGV4IGMwZjYyMmY4NjIyM2MyLi5lM2UwYTgxMWEzYTc3NCAx
MDA2NDQKLS0tIGEvbW0vaG1tLmMKKysrIGIvbW0vaG1tLmMKQEAgLTI4MywxOCArMjgzLDEzIEBA
IEVYUE9SVF9TWU1CT0woaG1tX21pcnJvcl9yZWdpc3Rlcik7CiAgKi8KIHZvaWQgaG1tX21pcnJv
cl91bnJlZ2lzdGVyKHN0cnVjdCBobW1fbWlycm9yICptaXJyb3IpCiB7Ci0Jc3RydWN0IGhtbSAq
aG1tID0gUkVBRF9PTkNFKG1pcnJvci0+aG1tKTsKLQotCWlmIChobW0gPT0gTlVMTCkKLQkJcmV0
dXJuOworCXN0cnVjdCBobW0gKmhtbSA9IG1pcnJvci0+aG1tOwogCiAJZG93bl93cml0ZSgmaG1t
LT5taXJyb3JzX3NlbSk7CiAJbGlzdF9kZWxfaW5pdCgmbWlycm9yLT5saXN0KTsKLQkvKiBUbyBw
cm90ZWN0IHVzIGFnYWluc3QgZG91YmxlIHVucmVnaXN0ZXIgLi4uICovCi0JbWlycm9yLT5obW0g
PSBOVUxMOwogCXVwX3dyaXRlKCZobW0tPm1pcnJvcnNfc2VtKTsKLQogCWhtbV9wdXQoaG1tKTsK
KwltZW1zZXQoJm1pcnJvci0+aG1tLCBQT0lTT05fSU5VU0UsIHNpemVvZihtaXJyb3ItPmhtbSkp
OwogfQogRVhQT1JUX1NZTUJPTChobW1fbWlycm9yX3VucmVnaXN0ZXIpOwogCi0tIAoyLjIxLjAK
Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmRyaS1kZXZl
bCBtYWlsaW5nIGxpc3QKZHJpLWRldmVsQGxpc3RzLmZyZWVkZXNrdG9wLm9yZwpodHRwczovL2xp
c3RzLmZyZWVkZXNrdG9wLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2RyaS1kZXZlbA==
