From: Souptick Joarder <jrdr.linux@gmail.com>
Subject: Re: [PATCH v2 hmm 10/11] mm/hmm: Do not use list*_rcu() for
 hmm->ranges
Date: Sat, 8 Jun 2019 03:41:27 +0530
Message-ID: <CAFqt6zafAR3fqvKCTCLmGNVfbSP80KqqR8cT0bUj4CW4scgxpQ@mail.gmail.com>
References: <20190606184438.31646-1-jgg@ziepe.ca>
 <20190606184438.31646-11-jgg@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20190606184438.31646-11-jgg@ziepe.ca>
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
Cj4KPiBUaGlzIGxpc3QgaXMgYWx3YXlzIHJlYWQgYW5kIHdyaXR0ZW4gd2hpbGUgaG9sZGluZyBo
bW0tPmxvY2sgc28gdGhlcmUgaXMKPiBubyBuZWVkIGZvciB0aGUgY29uZnVzaW5nIF9yY3UgYW5u
b3RhdGlvbnMuCj4KPiBTaWduZWQtb2ZmLWJ5OiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BtZWxsYW5v
eC5jb20+Cj4gUmV2aWV3ZWQtYnk6IErDqXLDtG1lIEdsaXNzZSA8amdsaXNzZUByZWRoYXQuY29t
PgoKQWNrZWQtYnk6IFNvdXB0aWNrIEpvYXJkZXIgPGpyZHIubGludXhAZ21haWwuY29tPgoKPiAt
LS0KPiAgbW0vaG1tLmMgfCA0ICsrLS0KPiAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygr
KSwgMiBkZWxldGlvbnMoLSkKPgo+IGRpZmYgLS1naXQgYS9tbS9obW0uYyBiL21tL2htbS5jCj4g
aW5kZXggYzJmZWNiM2VjYjExZTEuLjcwOWQxMzhkZDQ5MDI3IDEwMDY0NAo+IC0tLSBhL21tL2ht
bS5jCj4gKysrIGIvbW0vaG1tLmMKPiBAQCAtOTExLDcgKzkxMSw3IEBAIGludCBobW1fcmFuZ2Vf
cmVnaXN0ZXIoc3RydWN0IGhtbV9yYW5nZSAqcmFuZ2UsCj4gICAgICAgICBtdXRleF9sb2NrKCZo
bW0tPmxvY2spOwo+Cj4gICAgICAgICByYW5nZS0+aG1tID0gaG1tOwo+IC0gICAgICAgbGlzdF9h
ZGRfcmN1KCZyYW5nZS0+bGlzdCwgJmhtbS0+cmFuZ2VzKTsKPiArICAgICAgIGxpc3RfYWRkKCZy
YW5nZS0+bGlzdCwgJmhtbS0+cmFuZ2VzKTsKPgo+ICAgICAgICAgLyoKPiAgICAgICAgICAqIElm
IHRoZXJlIGFyZSBhbnkgY29uY3VycmVudCBub3RpZmllcnMgd2UgaGF2ZSB0byB3YWl0IGZvciB0
aGVtIGZvcgo+IEBAIC05NDEsNyArOTQxLDcgQEAgdm9pZCBobW1fcmFuZ2VfdW5yZWdpc3Rlcihz
dHJ1Y3QgaG1tX3JhbmdlICpyYW5nZSkKPiAgICAgICAgICAgICAgICAgcmV0dXJuOwo+Cj4gICAg
ICAgICBtdXRleF9sb2NrKCZobW0tPmxvY2spOwo+IC0gICAgICAgbGlzdF9kZWxfcmN1KCZyYW5n
ZS0+bGlzdCk7Cj4gKyAgICAgICBsaXN0X2RlbCgmcmFuZ2UtPmxpc3QpOwo+ICAgICAgICAgbXV0
ZXhfdW5sb2NrKCZobW0tPmxvY2spOwo+Cj4gICAgICAgICAvKiBEcm9wIHJlZmVyZW5jZSB0YWtl
biBieSBobW1fcmFuZ2VfcmVnaXN0ZXIoKSAqLwo+IC0tCj4gMi4yMS4wCj4KX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KZHJpLWRldmVsIG1haWxpbmcgbGlz
dApkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlzdHMuZnJlZWRlc2t0
b3Aub3JnL21haWxtYW4vbGlzdGluZm8vZHJpLWRldmVs
