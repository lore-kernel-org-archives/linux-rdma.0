From: Souptick Joarder <jrdr.linux@gmail.com>
Subject: Re: [PATCH v2 hmm 07/11] mm/hmm: Use lockdep instead of comments
Date: Sat, 8 Jun 2019 03:46:00 +0530
Message-ID: <CAFqt6zbPYWiV+2d7-o8EYACKKM2s_M7U=9j3pRux1OWsEqrQAQ@mail.gmail.com>
References: <20190606184438.31646-1-jgg@ziepe.ca>
 <20190606184438.31646-8-jgg@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20190606184438.31646-8-jgg@ziepe.ca>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Ralph Campbell <rcampbell@nvidia.com>, linux-rdma@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>, Felix.Kuehling@amd.com, dri-devel@lists.freedesktop.org, Linux-MM <linux-mm@kvack.org>, Jerome Glisse <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, amd-gfx@lists.freedesktop.org
List-Id: linux-rdma@vger.kernel.org

T24gRnJpLCBKdW4gNywgMjAxOSBhdCAxMjoxNSBBTSBKYXNvbiBHdW50aG9ycGUgPGpnZ0B6aWVw
ZS5jYT4gd3JvdGU6Cj4KPiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BtZWxsYW5veC5jb20+
Cj4KPiBTbyB3ZSBjYW4gY2hlY2sgbG9ja2luZyBhdCBydW50aW1lLgoKTGl0dGxlIG1vcmUgZGVz
Y3JpcHRpdmUgY2hhbmdlIGxvZyB3b3VsZCBiZSBoZWxwZnVsLgpBY2tlZC1ieTogU291cHRpY2sg
Sm9hcmRlciA8anJkci5saW51eEBnbWFpbC5jb20+Cgo+Cj4gU2lnbmVkLW9mZi1ieTogSmFzb24g
R3VudGhvcnBlIDxqZ2dAbWVsbGFub3guY29tPgo+IFJldmlld2VkLWJ5OiBKw6lyw7RtZSBHbGlz
c2UgPGpnbGlzc2VAcmVkaGF0LmNvbT4KPiAtLS0KPiB2Mgo+IC0gRml4IG1pc3NpbmcgJiBpbiBs
b2NrZGVwcyAoSmFzb24pCj4gLS0tCj4gIG1tL2htbS5jIHwgNCArKy0tCj4gIDEgZmlsZSBjaGFu
Z2VkLCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCj4KPiBkaWZmIC0tZ2l0IGEvbW0v
aG1tLmMgYi9tbS9obW0uYwo+IGluZGV4IGY2N2JhMzI5ODNkOWYxLi5jNzAyY2Q3MjY1MWI1MyAx
MDA2NDQKPiAtLS0gYS9tbS9obW0uYwo+ICsrKyBiL21tL2htbS5jCj4gQEAgLTI1NCwxMSArMjU0
LDExIEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgbW11X25vdGlmaWVyX29wcyBobW1fbW11X25vdGlm
aWVyX29wcyA9IHsKPiAgICoKPiAgICogVG8gc3RhcnQgbWlycm9yaW5nIGEgcHJvY2VzcyBhZGRy
ZXNzIHNwYWNlLCB0aGUgZGV2aWNlIGRyaXZlciBtdXN0IHJlZ2lzdGVyCj4gICAqIGFuIEhNTSBt
aXJyb3Igc3RydWN0Lgo+IC0gKgo+IC0gKiBUSEUgbW0tPm1tYXBfc2VtIE1VU1QgQkUgSEVMRCBJ
TiBXUklURSBNT0RFICEKPiAgICovCj4gIGludCBobW1fbWlycm9yX3JlZ2lzdGVyKHN0cnVjdCBo
bW1fbWlycm9yICptaXJyb3IsIHN0cnVjdCBtbV9zdHJ1Y3QgKm1tKQo+ICB7Cj4gKyAgICAgICBs
b2NrZGVwX2Fzc2VydF9oZWxkX2V4Y2x1c2l2ZSgmbW0tPm1tYXBfc2VtKTsKPiArCj4gICAgICAg
ICAvKiBTYW5pdHkgY2hlY2sgKi8KPiAgICAgICAgIGlmICghbW0gfHwgIW1pcnJvciB8fCAhbWly
cm9yLT5vcHMpCj4gICAgICAgICAgICAgICAgIHJldHVybiAtRUlOVkFMOwo+IC0tCj4gMi4yMS4w
Cj4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KZHJpLWRl
dmVsIG1haWxpbmcgbGlzdApkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8v
bGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vZHJpLWRldmVs
