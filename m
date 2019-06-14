From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: [PATCH v3 hmm 10/12] mm/hmm: Do not use list*_rcu() for hmm->ranges
Date: Thu, 13 Jun 2019 21:44:48 -0300
Message-ID: <20190614004450.20252-11-jgg@ziepe.ca>
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
Cc: Andrea Arcangeli <aarcange@redhat.com>, Philip Yang <Philip.Yang@amd.com>, linux-rdma@vger.kernel.org, Ira Weiny <iweiny@intel.com>, amd-gfx@lists.freedesktop.org, Souptick Joarder <jrdr.linux@gmail.com>, linux-mm@kvack.org, Jason Gunthorpe <jgg@mellanox.com>, dri-devel@lists.freedesktop.org, Ben Skeggs <bskeggs@redhat.com>
List-Id: linux-rdma@vger.kernel.org

RnJvbTogSmFzb24gR3VudGhvcnBlIDxqZ2dAbWVsbGFub3guY29tPgoKVGhpcyBsaXN0IGlzIGFs
d2F5cyByZWFkIGFuZCB3cml0dGVuIHdoaWxlIGhvbGRpbmcgaG1tLT5sb2NrIHNvIHRoZXJlIGlz
Cm5vIG5lZWQgZm9yIHRoZSBjb25mdXNpbmcgX3JjdSBhbm5vdGF0aW9ucy4KClNpZ25lZC1vZmYt
Ynk6IEphc29uIEd1bnRob3JwZSA8amdnQG1lbGxhbm94LmNvbT4KUmV2aWV3ZWQtYnk6IErDqXLD
tG1lIEdsaXNzZSA8amdsaXNzZUByZWRoYXQuY29tPgpSZXZpZXdlZC1ieTogSm9obiBIdWJiYXJk
IDxqaHViYmFyZEBudmlkaWEuY29tPgpBY2tlZC1ieTogU291cHRpY2sgSm9hcmRlciA8anJkci5s
aW51eEBnbWFpbC5jb20+ClJldmlld2VkLWJ5OiBSYWxwaCBDYW1wYmVsbCA8cmNhbXBiZWxsQG52
aWRpYS5jb20+CkFja2VkLWJ5OiBTb3VwdGljayBKb2FyZGVyIDxqcmRyLmxpbnV4QGdtYWlsLmNv
bT4KUmV2aWV3ZWQtYnk6IElyYSBXZWlueSA8aXdlaW55QGludGVsLmNvbT4KVGVzdGVkLWJ5OiBQ
aGlsaXAgWWFuZyA8UGhpbGlwLllhbmdAYW1kLmNvbT4KLS0tCiBtbS9obW0uYyB8IDQgKystLQog
MSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1n
aXQgYS9tbS9obW0uYyBiL21tL2htbS5jCmluZGV4IGUyMTQ2NjhjYmEzNDc0Li4yNmFmNTExY2Jk
ZDA3NSAxMDA2NDQKLS0tIGEvbW0vaG1tLmMKKysrIGIvbW0vaG1tLmMKQEAgLTkwOCw3ICs5MDgs
NyBAQCBpbnQgaG1tX3JhbmdlX3JlZ2lzdGVyKHN0cnVjdCBobW1fcmFuZ2UgKnJhbmdlLAogCiAJ
cmFuZ2UtPmhtbSA9IGhtbTsKIAlrcmVmX2dldCgmaG1tLT5rcmVmKTsKLQlsaXN0X2FkZF9yY3Uo
JnJhbmdlLT5saXN0LCAmaG1tLT5yYW5nZXMpOworCWxpc3RfYWRkKCZyYW5nZS0+bGlzdCwgJmht
bS0+cmFuZ2VzKTsKIAogCS8qCiAJICogSWYgdGhlcmUgYXJlIGFueSBjb25jdXJyZW50IG5vdGlm
aWVycyB3ZSBoYXZlIHRvIHdhaXQgZm9yIHRoZW0gZm9yCkBAIC05MzQsNyArOTM0LDcgQEAgdm9p
ZCBobW1fcmFuZ2VfdW5yZWdpc3RlcihzdHJ1Y3QgaG1tX3JhbmdlICpyYW5nZSkKIAlzdHJ1Y3Qg
aG1tICpobW0gPSByYW5nZS0+aG1tOwogCiAJbXV0ZXhfbG9jaygmaG1tLT5sb2NrKTsKLQlsaXN0
X2RlbF9yY3UoJnJhbmdlLT5saXN0KTsKKwlsaXN0X2RlbCgmcmFuZ2UtPmxpc3QpOwogCW11dGV4
X3VubG9jaygmaG1tLT5sb2NrKTsKIAogCS8qIERyb3AgcmVmZXJlbmNlIHRha2VuIGJ5IGhtbV9y
YW5nZV9yZWdpc3RlcigpICovCi0tIAoyLjIxLjAKCl9fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fCmRyaS1kZXZlbCBtYWlsaW5nIGxpc3QKZHJpLWRldmVsQGxp
c3RzLmZyZWVkZXNrdG9wLm9yZwpodHRwczovL2xpc3RzLmZyZWVkZXNrdG9wLm9yZy9tYWlsbWFu
L2xpc3RpbmZvL2RyaS1kZXZlbA==
