From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v3 hmm 08/12] mm/hmm: Remove racy protection against
 double-unregistration
Date: Tue, 18 Jun 2019 15:57:57 -0300
Message-ID: <20190618185757.GP6961@ziepe.ca>
References: <20190614004450.20252-1-jgg@ziepe.ca>
 <20190614004450.20252-9-jgg@ziepe.ca>
 <20190615141612.GH17724@infradead.org>
 <20190618131324.GF6961@ziepe.ca>
 <20190618132722.GA1633@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <20190618132722.GA1633@infradead.org>
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

T24gVHVlLCBKdW4gMTgsIDIwMTkgYXQgMDY6Mjc6MjJBTSAtMDcwMCwgQ2hyaXN0b3BoIEhlbGx3
aWcgd3JvdGU6Cj4gT24gVHVlLCBKdW4gMTgsIDIwMTkgYXQgMTA6MTM6MjRBTSAtMDMwMCwgSmFz
b24gR3VudGhvcnBlIHdyb3RlOgo+ID4gPiBJIGRvbid0IGV2ZW4gdGhpbmsgd2UgZXZlbiBuZWVk
IHRvIGJvdGhlciB3aXRoIHRoZSBQT0lTT04sIG5vcm1hbCBsaXN0Cj4gPiA+IGRlYnVnZ2luZyB3
aWxsIGFscmVhZHkgY2F0Y2ggYSBkb3VibGUgdW5yZWdpc3RyYXRpb24gYW55d2F5Lgo+ID4gCj4g
PiBtaXJyb3ItPmhtbSBpc24ndCBhIGxpc3Qgc28gbGlzdCBkZWJ1Z2dpbmcgd29uJ3QgaGVscC4K
PiA+IAo+ID4gTXkgY29uY2VybiB3aGVuIEkgd3JvdGUgdGhpcyB3YXMgdGhhdCBvbmUgb2YgdGhl
IGluIGZsaWdodCBwYXRjaGVzIEkKPiA+IGNhbid0IHNlZSBtaWdodCBiZSBkZXBlbmRpbmcgb24g
dGhpcyBkb3VibGUtdW5yZWdpc3Rlci1pcy1zYWZlCj4gPiBiZWhhdmlvciwgc28gSSB3YW50ZWQg
dGhlbSB0byBjcmFzaCByZWxpYWJseS4KPiA+IAo+ID4gSXQgaXMgYSByZWFsbHkgb3Zlcmx5IGNv
bnNlcnZhdGl2ZSB0aGluZyB0byBkby4uCj4gCj4gbWlycm9yLT5saXN0IGlzIGEgbGlzdCwgYW5k
IGlmIHdlIGRvIGEgbGlzdF9kZWwgb24gaXQgZHVyaW5nIHRoZQo+IHNlY29uZCB1bnJlZ2lzdHJh
dGlvbiBpdCB3aWxsIHRyaXAgdXAgb24gdGhlIGxpc3QgcG9pc29uaW5nLgoKV2l0aCB0aGUgcHJl
dmlvdXMgbG9vc2UgY291cGxpbmcgb2YgdGhlIG1pcnJvciBhbmQgdGhlIHJhbmdlIHNvbWUgY29k
ZQptaWdodCByYW5jZSB0byB0cnkgdG8gY3JlYXRlIGEgcmFuZ2Ugd2l0aG91dCBhIG1pcnJvciwg
d2hpY2ggd2lsbCBub3cKcmVsaWFibHkgY3Jhc2ggd2l0aCB0aGUgcG9pc29uLgoKSXQgaXNuJ3Qg
c28gbXVjaCB0aGUgZG91YmxlIHVucmVnaXN0ZXIgdGhhdCB3b3JyaWVzIG1lLCBidXQgcmFjaW5n
CnVucmVnaXN0ZXIgd2l0aCByYW5nZSBmdW5jdGlvbnMuCgpKYXNvbgpfX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpkcmktZGV2ZWwgbWFpbGluZyBsaXN0CmRy
aS1kZXZlbEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5v
cmcvbWFpbG1hbi9saXN0aW5mby9kcmktZGV2ZWw=
