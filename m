From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v3 hmm 10/12] mm/hmm: Do not use list*_rcu() for
 hmm->ranges
Date: Mon, 17 Jun 2019 21:38:07 -0300
Message-ID: <20190618003807.GD30762@ziepe.ca>
References: <20190614004450.20252-1-jgg@ziepe.ca>
 <20190614004450.20252-11-jgg@ziepe.ca>
 <20190615141826.GJ17724@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <20190615141826.GJ17724@infradead.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Philip Yang <Philip.Yang@amd.com>, Ralph Campbell <rcampbell@nvidia.com>, linux-rdma@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>, Felix.Kuehling@amd.com, Ira Weiny <iweiny@intel.com>, dri-devel@lists.freedesktop.org, Souptick Joarder <jrdr.linux@gmail.com>, linux-mm@kvack.org, Jerome Glisse <jglisse@redhat.com>, amd-gfx@lists.freedesktop.org, Ben Skeggs <bskeggs@redhat.com>
List-Id: linux-rdma@vger.kernel.org

T24gU2F0LCBKdW4gMTUsIDIwMTkgYXQgMDc6MTg6MjZBTSAtMDcwMCwgQ2hyaXN0b3BoIEhlbGx3
aWcgd3JvdGU6Cj4gT24gVGh1LCBKdW4gMTMsIDIwMTkgYXQgMDk6NDQ6NDhQTSAtMDMwMCwgSmFz
b24gR3VudGhvcnBlIHdyb3RlOgo+ID4gIAlyYW5nZS0+aG1tID0gaG1tOwo+ID4gIAlrcmVmX2dl
dCgmaG1tLT5rcmVmKTsKPiA+IC0JbGlzdF9hZGRfcmN1KCZyYW5nZS0+bGlzdCwgJmhtbS0+cmFu
Z2VzKTsKPiA+ICsJbGlzdF9hZGQoJnJhbmdlLT5saXN0LCAmaG1tLT5yYW5nZXMpOwo+ID4gIAo+
ID4gIAkvKgo+ID4gIAkgKiBJZiB0aGVyZSBhcmUgYW55IGNvbmN1cnJlbnQgbm90aWZpZXJzIHdl
IGhhdmUgdG8gd2FpdCBmb3IgdGhlbSBmb3IKPiA+IEBAIC05MzQsNyArOTM0LDcgQEAgdm9pZCBo
bW1fcmFuZ2VfdW5yZWdpc3RlcihzdHJ1Y3QgaG1tX3JhbmdlICpyYW5nZSkKPiA+ICAJc3RydWN0
IGhtbSAqaG1tID0gcmFuZ2UtPmhtbTsKPiA+ICAKPiA+ICAJbXV0ZXhfbG9jaygmaG1tLT5sb2Nr
KTsKPiA+IC0JbGlzdF9kZWxfcmN1KCZyYW5nZS0+bGlzdCk7Cj4gPiArCWxpc3RfZGVsKCZyYW5n
ZS0+bGlzdCk7Cj4gPiAgCW11dGV4X3VubG9jaygmaG1tLT5sb2NrKTsKPiAKPiBMb29rcyBmaW5l
Ogo+IAo+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPgo+IAo+
IEJ0dywgaXMgdGhlcmUgYW55IHJlYXNvbiBuZXcgcmFuZ2VzIGFyZSBhZGRlZCB0byB0aGUgZnJv
bnQgYW5kIG5vdCB0aGUKPiB0YWlsIG9mIHRoZSBsaXN0PwoKQ291bGRuJ3QgZmluZCBvbmUuIEkg
dGhpbmsgb3JkZXIgb24gdGhpcyBsaXN0IGRvZXNuJ3QgbWF0dGVyLgoKSmFzb24KX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KZHJpLWRldmVsIG1haWxpbmcg
bGlzdApkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlzdHMuZnJlZWRl
c2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vZHJpLWRldmVs
