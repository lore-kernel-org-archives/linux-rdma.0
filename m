From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v3 hmm 09/12] mm/hmm: Poison hmm_range during unregister
Date: Tue, 18 Jun 2019 15:04:22 -0300
Message-ID: <20190618180422.GK6961@ziepe.ca>
References: <20190614004450.20252-1-jgg@ziepe.ca>
 <20190614004450.20252-10-jgg@ziepe.ca>
 <20190615141726.GI17724@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <20190615141726.GI17724@infradead.org>
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
Cc: Andrea Arcangeli <aarcange@redhat.com>, Philip Yang <Philip.Yang@amd.com>, Ralph Campbell <rcampbell@nvidia.com>, linux-rdma@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>, Felix.Kuehling@amd.com, dri-devel@lists.freedesktop.org, Souptick Joarder <jrdr.linux@gmail.com>, linux-mm@kvack.org, Jerome Glisse <jglisse@redhat.com>, amd-gfx@lists.freedesktop.org, Ira Weiny <ira.weiny@intel.com>, Ben Skeggs <bskeggs@redhat.com>
List-Id: linux-rdma@vger.kernel.org

T24gU2F0LCBKdW4gMTUsIDIwMTkgYXQgMDc6MTc6MjZBTSAtMDcwMCwgQ2hyaXN0b3BoIEhlbGx3
aWcgd3JvdGU6Cj4gPiAtCS8qIFNhbml0eSBjaGVjayB0aGlzIHJlYWxseSBzaG91bGQgbm90IGhh
cHBlbi4gKi8KPiA+IC0JaWYgKGhtbSA9PSBOVUxMIHx8IHJhbmdlLT5lbmQgPD0gcmFuZ2UtPnN0
YXJ0KQo+ID4gLQkJcmV0dXJuOwo+ID4gLQo+ID4gIAltdXRleF9sb2NrKCZobW0tPmxvY2spOwo+
ID4gIAlsaXN0X2RlbF9yY3UoJnJhbmdlLT5saXN0KTsKPiA+ICAJbXV0ZXhfdW5sb2NrKCZobW0t
PmxvY2spOwo+ID4gIAo+ID4gIAkvKiBEcm9wIHJlZmVyZW5jZSB0YWtlbiBieSBobW1fcmFuZ2Vf
cmVnaXN0ZXIoKSAqLwo+ID4gLQlyYW5nZS0+dmFsaWQgPSBmYWxzZTsKPiA+ICAJbW1wdXQoaG1t
LT5tbSk7Cj4gPiAgCWhtbV9wdXQoaG1tKTsKPiA+IC0JcmFuZ2UtPmhtbSA9IE5VTEw7Cj4gPiAr
Cj4gPiArCS8qCj4gPiArCSAqIFRoZSByYW5nZSBpcyBub3cgaW52YWxpZCBhbmQgdGhlIHJlZiBv
biB0aGUgaG1tIGlzIGRyb3BwZWQsIHNvCj4gPiArICAgICAgICAgKiBwb2lzb24gdGhlIHBvaW50
ZXIuICBMZWF2ZSBvdGhlciBmaWVsZHMgaW4gcGxhY2UsIGZvciB0aGUgY2FsbGVyJ3MKPiA+ICsg
ICAgICAgICAqIHVzZS4KPiA+ICsgICAgICAgICAqLwo+ID4gKwlyYW5nZS0+dmFsaWQgPSBmYWxz
ZTsKPiA+ICsJbWVtc2V0KCZyYW5nZS0+aG1tLCBQT0lTT05fSU5VU0UsIHNpemVvZihyYW5nZS0+
aG1tKSk7Cj4gCj4gRm9ybWF0dGluZyBzZWVtcyB0byBiZSBtZXNzZWQgdXAuICBCdXQgYWdhaW4g
SSBkb24ndCBzZWUgdGhlIHZhbHVlCj4gaW4gdGhlIHBvaXNvbmluZywganVzdCBsZXQgbm9ybWFs
IGxpbmtlZCBsaXN0IGRlYnVnZ2luZyBkbyBpdHMgd29yay4KPiBUaGUgb3RoZXIgY2xlYW51cHMg
bG9va3MgZmluZSB0byBtZS4KCnRhYnMgdnMgc3BhY2VzLCBJIGZpeGVkIGl0LiBUaGlzIG9uZSBp
cyBtb3JlIG11cmt5IHRoYW4gdGhlIG90aGVyIC0gaXQKaXMgdG8gcHJldmVudCB0aGUgY2FsbGVy
IGZyb20gdXNpbmcgYW55IG9mIHRoZSByYW5nZSBBUElzIGFmdGVyIHRoZQpyYW5nZSBpcyB1bnJl
Z2lzdGVyZWQsIGJ1dCB3ZSBjb3VsZCBhbHNvIHNhZmVseSB1c2UgTlVMTCBoZXJlLCBJCnRoaW5r
LgoKSmFzb24KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18K
ZHJpLWRldmVsIG1haWxpbmcgbGlzdApkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0
dHBzOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vZHJpLWRldmVs
