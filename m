From: John Hubbard <jhubbard@nvidia.com>
Subject: Re: [PATCH v2 hmm 10/11] mm/hmm: Do not use list*_rcu() for
 hmm->ranges
Date: Thu, 6 Jun 2019 20:40:07 -0700
Message-ID: <59b5de4b-e872-30f4-149e-f8a3bc946f22@nvidia.com>
References: <20190606184438.31646-1-jgg@ziepe.ca>
 <20190606184438.31646-11-jgg@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
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
To: Jason Gunthorpe <jgg@ziepe.ca>, Jerome Glisse <jglisse@redhat.com>, Ralph
 Campbell <rcampbell@nvidia.com>, Felix.Kuehling@amd.com
Cc: Andrea Arcangeli <aarcange@redhat.com>, linux-rdma@vger.kernel.org, amd-gfx@lists.freedesktop.org, linux-mm@kvack.org, Jason Gunthorpe <jgg@mellanox.com>, dri-devel@lists.freedesktop.org
List-Id: linux-rdma@vger.kernel.org

T24gNi82LzE5IDExOjQ0IEFNLCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6Cj4gRnJvbTogSmFzb24g
R3VudGhvcnBlIDxqZ2dAbWVsbGFub3guY29tPgo+IAo+IFRoaXMgbGlzdCBpcyBhbHdheXMgcmVh
ZCBhbmQgd3JpdHRlbiB3aGlsZSBob2xkaW5nIGhtbS0+bG9jayBzbyB0aGVyZSBpcwo+IG5vIG5l
ZWQgZm9yIHRoZSBjb25mdXNpbmcgX3JjdSBhbm5vdGF0aW9ucy4KPiAKPiBTaWduZWQtb2ZmLWJ5
OiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BtZWxsYW5veC5jb20+Cj4gUmV2aWV3ZWQtYnk6IErDqXLD
tG1lIEdsaXNzZSA8amdsaXNzZUByZWRoYXQuY29tPgo+IC0tLQo+ICBtbS9obW0uYyB8IDQgKyst
LQo+ICAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQo+IAo+
IGRpZmYgLS1naXQgYS9tbS9obW0uYyBiL21tL2htbS5jCj4gaW5kZXggYzJmZWNiM2VjYjExZTEu
LjcwOWQxMzhkZDQ5MDI3IDEwMDY0NAo+IC0tLSBhL21tL2htbS5jCj4gKysrIGIvbW0vaG1tLmMK
PiBAQCAtOTExLDcgKzkxMSw3IEBAIGludCBobW1fcmFuZ2VfcmVnaXN0ZXIoc3RydWN0IGhtbV9y
YW5nZSAqcmFuZ2UsCj4gIAltdXRleF9sb2NrKCZobW0tPmxvY2spOwo+ICAKPiAgCXJhbmdlLT5o
bW0gPSBobW07Cj4gLQlsaXN0X2FkZF9yY3UoJnJhbmdlLT5saXN0LCAmaG1tLT5yYW5nZXMpOwo+
ICsJbGlzdF9hZGQoJnJhbmdlLT5saXN0LCAmaG1tLT5yYW5nZXMpOwo+ICAKPiAgCS8qCj4gIAkg
KiBJZiB0aGVyZSBhcmUgYW55IGNvbmN1cnJlbnQgbm90aWZpZXJzIHdlIGhhdmUgdG8gd2FpdCBm
b3IgdGhlbSBmb3IKPiBAQCAtOTQxLDcgKzk0MSw3IEBAIHZvaWQgaG1tX3JhbmdlX3VucmVnaXN0
ZXIoc3RydWN0IGhtbV9yYW5nZSAqcmFuZ2UpCj4gIAkJcmV0dXJuOwo+ICAKPiAgCW11dGV4X2xv
Y2soJmhtbS0+bG9jayk7Cj4gLQlsaXN0X2RlbF9yY3UoJnJhbmdlLT5saXN0KTsKPiArCWxpc3Rf
ZGVsKCZyYW5nZS0+bGlzdCk7Cj4gIAltdXRleF91bmxvY2soJmhtbS0+bG9jayk7Cj4gIAo+ICAJ
LyogRHJvcCByZWZlcmVuY2UgdGFrZW4gYnkgaG1tX3JhbmdlX3JlZ2lzdGVyKCkgKi8KPiAKCkdv
b2QgcG9pbnQuIEknZCBvdmVybG9va2VkIHRoaXMgbWFueSB0aW1lcy4KCiAgICBSZXZpZXdlZC1i
eTogSm9obiBIdWJiYXJkIDxqaHViYmFyZEBudmlkaWEuY29tPgoKCnRoYW5rcywKLS0gCkpvaG4g
SHViYmFyZApOVklESUEKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX18KZHJpLWRldmVsIG1haWxpbmcgbGlzdApkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Au
b3JnCmh0dHBzOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vZHJpLWRl
dmVs
