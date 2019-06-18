From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v3 hmm 08/12] mm/hmm: Remove racy protection against
 double-unregistration
Date: Tue, 18 Jun 2019 10:13:24 -0300
Message-ID: <20190618131324.GF6961@ziepe.ca>
References: <20190614004450.20252-1-jgg@ziepe.ca>
 <20190614004450.20252-9-jgg@ziepe.ca>
 <20190615141612.GH17724@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <20190615141612.GH17724@infradead.org>
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

T24gU2F0LCBKdW4gMTUsIDIwMTkgYXQgMDc6MTY6MTJBTSAtMDcwMCwgQ2hyaXN0b3BoIEhlbGx3
aWcgd3JvdGU6Cj4gT24gVGh1LCBKdW4gMTMsIDIwMTkgYXQgMDk6NDQ6NDZQTSAtMDMwMCwgSmFz
b24gR3VudGhvcnBlIHdyb3RlOgo+ID4gRnJvbTogSmFzb24gR3VudGhvcnBlIDxqZ2dAbWVsbGFu
b3guY29tPgo+ID4gCj4gPiBObyBvdGhlciByZWdpc3Rlci91bnJlZ2lzdGVyIGtlcm5lbCBBUEkg
YXR0ZW1wdHMgdG8gcHJvdmlkZSB0aGlzIGtpbmQgb2YKPiA+IHByb3RlY3Rpb24gYXMgaXQgaXMg
aW5oZXJlbnRseSByYWN5LCBzbyBqdXN0IGRyb3AgaXQuCj4gPiAKPiA+IENhbGxlcnMgc2hvdWxk
IHByb3ZpZGUgdGhlaXIgb3duIHByb3RlY3Rpb24sIGl0IGFwcGVhcnMgbm91dmVhdSBhbHJlYWR5
Cj4gPiBkb2VzLCBidXQganVzdCBpbiBjYXNlIGRyb3AgYSBkZWJ1Z2dpbmcgUE9JU09OLgo+IAo+
IEkgZG9uJ3QgZXZlbiB0aGluayB3ZSBldmVuIG5lZWQgdG8gYm90aGVyIHdpdGggdGhlIFBPSVNP
Tiwgbm9ybWFsIGxpc3QKPiBkZWJ1Z2dpbmcgd2lsbCBhbHJlYWR5IGNhdGNoIGEgZG91YmxlIHVu
cmVnaXN0cmF0aW9uIGFueXdheS4KCm1pcnJvci0+aG1tIGlzbid0IGEgbGlzdCBzbyBsaXN0IGRl
YnVnZ2luZyB3b24ndCBoZWxwLgoKTXkgY29uY2VybiB3aGVuIEkgd3JvdGUgdGhpcyB3YXMgdGhh
dCBvbmUgb2YgdGhlIGluIGZsaWdodCBwYXRjaGVzIEkKY2FuJ3Qgc2VlIG1pZ2h0IGJlIGRlcGVu
ZGluZyBvbiB0aGlzIGRvdWJsZS11bnJlZ2lzdGVyLWlzLXNhZmUKYmVoYXZpb3IsIHNvIEkgd2Fu
dGVkIHRoZW0gdG8gY3Jhc2ggcmVsaWFibHkuCgpJdCBpcyBhIHJlYWxseSBvdmVybHkgY29uc2Vy
dmF0aXZlIHRoaW5nIHRvIGRvLi4KClRoYW5rcywKSmFzb24KX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX18KZHJpLWRldmVsIG1haWxpbmcgbGlzdApkcmktZGV2
ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21h
aWxtYW4vbGlzdGluZm8vZHJpLWRldmVs
