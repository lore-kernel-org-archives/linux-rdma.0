From: Ralph Campbell <rcampbell@nvidia.com>
Subject: Re: [PATCH v2 hmm 10/11] mm/hmm: Do not use list*_rcu() for
 hmm->ranges
Date: Fri, 7 Jun 2019 13:49:06 -0700
Message-ID: <57cf91db-bebe-24f0-29c3-64274f10d10b@nvidia.com>
References: <20190606184438.31646-1-jgg@ziepe.ca>
 <20190606184438.31646-11-jgg@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20190606184438.31646-11-jgg@ziepe.ca>
Content-Language: en-US
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Jerome Glisse <jglisse@redhat.com>, John
 Hubbard <jhubbard@nvidia.com>, Felix.Kuehling@amd.com
Cc: Andrea Arcangeli <aarcange@redhat.com>, linux-rdma@vger.kernel.org, amd-gfx@lists.freedesktop.org, linux-mm@kvack.org, Jason Gunthorpe <jgg@mellanox.com>, dri-devel@lists.freedesktop.org
List-Id: linux-rdma@vger.kernel.org

Ck9uIDYvNi8xOSAxMTo0NCBBTSwgSmFzb24gR3VudGhvcnBlIHdyb3RlOgo+IEZyb206IEphc29u
IEd1bnRob3JwZSA8amdnQG1lbGxhbm94LmNvbT4KPiAKPiBUaGlzIGxpc3QgaXMgYWx3YXlzIHJl
YWQgYW5kIHdyaXR0ZW4gd2hpbGUgaG9sZGluZyBobW0tPmxvY2sgc28gdGhlcmUgaXMKPiBubyBu
ZWVkIGZvciB0aGUgY29uZnVzaW5nIF9yY3UgYW5ub3RhdGlvbnMuCj4gCj4gU2lnbmVkLW9mZi1i
eTogSmFzb24gR3VudGhvcnBlIDxqZ2dAbWVsbGFub3guY29tPgo+IFJldmlld2VkLWJ5OiBKw6ly
w7RtZSBHbGlzc2UgPGpnbGlzc2VAcmVkaGF0LmNvbT4KClJldmlld2VkLWJ5OiBSYWxwaCBDYW1w
YmVsbCA8cmNhbXBiZWxsQG52aWRpYS5jb20+Cgo+IC0tLQo+ICAgbW0vaG1tLmMgfCA0ICsrLS0K
PiAgIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCj4gCj4g
ZGlmZiAtLWdpdCBhL21tL2htbS5jIGIvbW0vaG1tLmMKPiBpbmRleCBjMmZlY2IzZWNiMTFlMS4u
NzA5ZDEzOGRkNDkwMjcgMTAwNjQ0Cj4gLS0tIGEvbW0vaG1tLmMKPiArKysgYi9tbS9obW0uYwo+
IEBAIC05MTEsNyArOTExLDcgQEAgaW50IGhtbV9yYW5nZV9yZWdpc3RlcihzdHJ1Y3QgaG1tX3Jh
bmdlICpyYW5nZSwKPiAgIAltdXRleF9sb2NrKCZobW0tPmxvY2spOwo+ICAgCj4gICAJcmFuZ2Ut
PmhtbSA9IGhtbTsKPiAtCWxpc3RfYWRkX3JjdSgmcmFuZ2UtPmxpc3QsICZobW0tPnJhbmdlcyk7
Cj4gKwlsaXN0X2FkZCgmcmFuZ2UtPmxpc3QsICZobW0tPnJhbmdlcyk7Cj4gICAKPiAgIAkvKgo+
ICAgCSAqIElmIHRoZXJlIGFyZSBhbnkgY29uY3VycmVudCBub3RpZmllcnMgd2UgaGF2ZSB0byB3
YWl0IGZvciB0aGVtIGZvcgo+IEBAIC05NDEsNyArOTQxLDcgQEAgdm9pZCBobW1fcmFuZ2VfdW5y
ZWdpc3RlcihzdHJ1Y3QgaG1tX3JhbmdlICpyYW5nZSkKPiAgIAkJcmV0dXJuOwo+ICAgCj4gICAJ
bXV0ZXhfbG9jaygmaG1tLT5sb2NrKTsKPiAtCWxpc3RfZGVsX3JjdSgmcmFuZ2UtPmxpc3QpOwo+
ICsJbGlzdF9kZWwoJnJhbmdlLT5saXN0KTsKPiAgIAltdXRleF91bmxvY2soJmhtbS0+bG9jayk7
Cj4gICAKPiAgIAkvKiBEcm9wIHJlZmVyZW5jZSB0YWtlbiBieSBobW1fcmFuZ2VfcmVnaXN0ZXIo
KSAqLwo+IApfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpk
cmktZGV2ZWwgbWFpbGluZyBsaXN0CmRyaS1kZXZlbEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0
cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9kcmktZGV2ZWw=
