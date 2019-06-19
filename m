From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v3 hmm 11/12] mm/hmm: Remove confusing comment and logic
 from hmm_release
Date: Wed, 19 Jun 2019 05:03:52 -0700
Message-ID: <20190619120352.GA31563@infradead.org>
References: <20190614004450.20252-1-jgg@ziepe.ca>
 <20190614004450.20252-12-jgg@ziepe.ca>
 <20190615142106.GK17724@infradead.org>
 <20190618004509.GE30762@ziepe.ca>
 <20190618053733.GA25048@infradead.org>
 <be4f8573-6284-04a6-7862-23bb357bfe3c@amd.com>
 <20190619080705.GA5164@infradead.org>
 <20190619115632.GC9360@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20190619115632.GC9360-uk2M96/98Pc@public.gmane.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/amd-gfx>
List-Post: <mailto:amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
List-Help: <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=subscribe>
Errors-To: amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Sender: "amd-gfx" <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Yang,
 Philip" <Philip.Yang-5C7GfCeVMHo@public.gmane.org>, Ralph Campbell <rcampbell-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, "Kuehling, Felix" <Felix.Kuehling-5C7GfCeVMHo@public.gmane.org>, "dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Ben Skeggs <bskeggs-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gV2VkLCBKdW4gMTksIDIwMTkgYXQgMDg6NTY6MzJBTSAtMDMwMCwgSmFzb24gR3VudGhvcnBl
IHdyb3RlOgo+IFRoaXMgbG9va3MgYSBsb3QgbGlrZSB0aGUgT0RQIGNvZGUgKGFtZGdwdV9tbl9u
b2RlID09IGliX3VtZW1fb2RwKQo+IAo+IFRoZSBpbnRlcnZhbCB0cmVlIGlzIHRvIHF1aWNrbHkg
ZmluZCB0aGUgZHJpdmVyIG9iamVjdChzKSB0aGF0IGhhdmUKPiB0aGUgdmlydHVhbCBwYWdlcyBk
dXJpbmcgaW52YWxpZGF0aW9uOgo+IAo+IHN0YXRpYyBpbnQgYW1kZ3B1X21uX3N5bmNfcGFnZXRh
Ymxlc19nZngoc3RydWN0IGhtbV9taXJyb3IgKm1pcnJvciwKPiAgICAgICAgICAgICAgICAgICAg
ICAgICBjb25zdCBzdHJ1Y3QgaG1tX3VwZGF0ZSAqdXBkYXRlKQo+IHsKPiAgICAgICAgIGl0ID0g
aW50ZXJ2YWxfdHJlZV9pdGVyX2ZpcnN0KCZhbW4tPm9iamVjdHMsIHN0YXJ0LCBlbmQpOwo+ICAg
ICAgICAgd2hpbGUgKGl0KSB7Cj4gICAgICAgICAgICAgICAgIFsuLl0KPiAgICAgICAgICAgICAg
ICAgYW1kZ3B1X21uX2ludmFsaWRhdGVfbm9kZShub2RlLCBzdGFydCwgZW5kKTsKPiAKPiBBbmQg
Zm9sbG93aW5nIHRoZSBPRFAgbW9kZWwgdGhlcmUgc2hvdWxkIGJlIGEgc2luZ2xlIGhtbV9taXJy
b3IgcGVyLW1tCj4gKHVzZXIgY2FuIGZvcmsgYW5kIHN0dWZmLCB0aGlzIGlzIHNvbWV0aGluZyBJ
IHdhbnQgdG8gaGF2ZSBjb3JlIGNvZGUKPiBoZWxwIHdpdGgpLiAKClRoYXQgbWFrZXMgdGhlIGht
bV9taXJyb3Igb2JqZWN0IHByZXR0eSBzaWxseSwgdGhvdWdoIGFzIHRoZSBzY29wZQppcyB0aGVu
IGV4YWN0bHkgdGhlIHNhbWUgYXMgdGhlIG1tdV9ub3RpZmllciBpdHNlbGYuCgo+IFRoZSBobW1f
bWlycm9yIGNhbiBlaXRoZXIgZXhpc3Qgc28gbG9uZyBhcyBvYmplY3RzIGV4aXN0LCBvciBpdCBj
YW4KPiBleGlzdCB1bnRpbCB0aGUgY2hhcmRldiBpcyBjbG9zZWQgLSBidXQgbmV2ZXIgbG9uZ2Vy
IHRoYW4gdGhlCj4gY2hhcmRldidzIGxpZmV0aW1lLgo+IAo+IE1heWJlIHdlIHNob3VsZCBiZSBj
b25zaWRlcmluZyBwcm92aWRpbmcgYSBtbXUgbm90aWZpZXIgJiBpbnRlcnZhbAo+IHRyZWUgJiBs
b2NrIGFic3RyYWN0aW9uIHNpbmNlIE9EUCAmIEFNRCBhcmUgdmVyeSBzaW1pbGFyIGhlcmUuLgoK
SXQgZGVmaW50aXZlbHkgc291bmRzIGxpa2UgYSBnb29kIGlkZWEgdG8gbW92ZSB0aGlzIGtpbmQg
b2Ygb2JqZWN0Cm1hbmFnZW1lbnQgaW50byBjb21tb24gY29kZS4gIE5vdXZlYSBhY3R1YWxseSBz
ZWVtcyBsaWtlIHRoZSBvZGQgb25lCm91dCBoZXJlIGJ5IG5vdCBoYXZpbmcgYSBsaXN0IG9mIG9i
amVjdHMgYmVsb3cgdGhlIG1pcnJvciwgYnV0IHRoZW4KYWdhaW4gYW5kIGludGVydmFsIHRyZWUg
d2l0aCBhIHNpbmdsZSBlbnRyeSB3b3VsZG4ndCByZWFsbHkgaHVydCBpdAplaXRoZXIuCl9fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmFtZC1nZnggbWFpbGlu
ZyBsaXN0CmFtZC1nZnhAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlzdHMuZnJlZWRl
c2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vYW1kLWdmeA==
