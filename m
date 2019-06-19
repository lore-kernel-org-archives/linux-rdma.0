From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v3 hmm 06/12] mm/hmm: Hold on to the mmget for the
 lifetime of the range
Date: Wed, 19 Jun 2019 08:34:52 -0300
Message-ID: <20190619113452.GB9360@ziepe.ca>
References: <20190614004450.20252-1-jgg@ziepe.ca>
 <20190614004450.20252-7-jgg@ziepe.ca>
 <20190615141435.GF17724@infradead.org>
 <20190618151100.GI6961@ziepe.ca>
 <20190619081858.GB24900@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <20190619081858.GB24900@infradead.org>
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
Cc: Andrea Arcangeli <aarcange@redhat.com>, Philip Yang <Philip.Yang@amd.com>, Ralph Campbell <rcampbell@nvidia.com>, linux-rdma@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>, Felix.Kuehling@amd.com, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, Jerome Glisse <jglisse@redhat.com>, amd-gfx@lists.freedesktop.org, Ben Skeggs <bskeggs@redhat.com>
List-Id: linux-rdma@vger.kernel.org

T24gV2VkLCBKdW4gMTksIDIwMTkgYXQgMDE6MTg6NThBTSAtMDcwMCwgQ2hyaXN0b3BoIEhlbGx3
aWcgd3JvdGU6Cj4gPiAgCW11dGV4X2xvY2soJmhtbS0+bG9jayk7Cj4gPiAtCWxpc3RfZGVsKCZy
YW5nZS0+bGlzdCk7Cj4gPiArCWxpc3RfZGVsX2luaXQoJnJhbmdlLT5saXN0KTsKPiA+ICAJbXV0
ZXhfdW5sb2NrKCZobW0tPmxvY2spOwo+IAo+IEkgZG9uJ3Qgc2VlIHRoZSBwb2ludCB3aHkgdGhp
cyBpcyBhIGxpc3RfZGVsX2luaXQgLSB0aGF0IGp1c3QKPiByZWluaXRpYWxpemXRlSByYW5nZS0+
bGlzdCwgYnV0IGRvZXNuJ3QgY2hhbmdlIGFueXRoaW5nIGZvciB0aGUgbGlzdAo+IGhlYWQgaXQg
d2FzIHJlbW92ZWQgZnJvbS4gIChhbmQgaWYgdGhlIGxpc3RfZGVsX2luaXQgd2FzIGludGVuZGVk
Cj4gYSBsYXRlciBwYXRjaCBpbiB5b3VyIGJyYW5jaCByZXZlcnRzIGl0IHRvIHBsYWluIGxpc3Rf
ZGVsLi4pCgpKdXN0IGZvbGxvd2luZyB0aGUgaW5zdHJ1Y3Rpb25zOgoKLyoqCiAqIGxpc3RfZW1w
dHlfY2FyZWZ1bCAtIHRlc3RzIHdoZXRoZXIgYSBsaXN0IGlzIGVtcHR5IGFuZCBub3QgYmVpbmcg
bW9kaWZpZWQKICogQGhlYWQ6IHRoZSBsaXN0IHRvIHRlc3QKICoKICogRGVzY3JpcHRpb246CiAq
IHRlc3RzIHdoZXRoZXIgYSBsaXN0IGlzIGVtcHR5IF9hbmRfIGNoZWNrcyB0aGF0IG5vIG90aGVy
IENQVSBtaWdodCBiZQogKiBpbiB0aGUgcHJvY2VzcyBvZiBtb2RpZnlpbmcgZWl0aGVyIG1lbWJl
ciAobmV4dCBvciBwcmV2KQogKgogKiBOT1RFOiB1c2luZyBsaXN0X2VtcHR5X2NhcmVmdWwoKSB3
aXRob3V0IHN5bmNocm9uaXphdGlvbgogKiBjYW4gb25seSBiZSBzYWZlIGlmIHRoZSBvbmx5IGFj
dGl2aXR5IHRoYXQgY2FuIGhhcHBlbgogKiB0byB0aGUgbGlzdCBlbnRyeSBpcyBsaXN0X2RlbF9p
bml0KCkuIEVnLiBpdCBjYW5ub3QgYmUgdXNlZAogKiBpZiBhbm90aGVyIENQVSBjb3VsZCByZS1s
aXN0X2FkZCgpIGl0LgogKi8KCkFncmVlIGl0IGRvZXNuJ3Qgc2VlbSBvYnZpb3VzIHdoeSB0aGlz
IGlzIHJlbGV2YW50IHdoZW4gY2hlY2tpbmcgdGhlCmxpc3QgaGVhZC4uCgpNYXliZSB0aGUgY29t
bWVudCBpcyBhIGJpdCBtaXNsZWFkaW5nPwoKSmFzb24KX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX18KZHJpLWRldmVsIG1haWxpbmcgbGlzdApkcmktZGV2ZWxA
bGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxt
YW4vbGlzdGluZm8vZHJpLWRldmVs
