From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v2 hmm 02/11] mm/hmm: Use hmm_mirror not mm as an
 argument for hmm_range_register
Date: Wed, 12 Jun 2019 00:12:34 -0700
Message-ID: <20190612071234.GA20306@infradead.org>
References: <20190606184438.31646-1-jgg@ziepe.ca>
 <20190606184438.31646-3-jgg@ziepe.ca>
 <20190608085425.GB32185@infradead.org>
 <20190611194431.GC29375@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20190611194431.GC29375-uk2M96/98Pc@public.gmane.org>
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
Cc: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ralph Campbell <rcampbell-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Felix.Kuehling-5C7GfCeVMHo@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

T24gVHVlLCBKdW4gMTEsIDIwMTkgYXQgMDQ6NDQ6MzFQTSAtMDMwMCwgSmFzb24gR3VudGhvcnBl
IHdyb3RlOgo+IE9uIFNhdCwgSnVuIDA4LCAyMDE5IGF0IDAxOjU0OjI1QU0gLTA3MDAsIENocmlz
dG9waCBIZWxsd2lnIHdyb3RlOgo+ID4gRllJLCBJIHZlcnkgbXVjaCBkaXNhZ3JlZSB3aXRoIHRo
ZSBkaXJlY3Rpb24gdGhpcyBpcyBtb3ZpbmcuCj4gPiAKPiA+IHN0cnVjdCBobW1fbWlycm9yIGxp
dGVyYWxseSBpcyBhIHRyaXZpYWwgZHVwbGljYXRpb24gb2YgdGhlCj4gPiBtbXVfbm90aWZpZXJz
LiAgQWxsIHRoZXNlIGRyaXZlcnMgc2hvdWxkIGp1c3QgdXNlIHRoZSBtbXVfbm90aWZpZXJzCj4g
PiBkaXJlY3RseSBmb3IgdGhlIG1pcnJvcmluZyBwYXJ0IGluc3RlYWQgb2YgYnVpbGRpbmcgYSB0
aGluZyB3cmFwcGVyCj4gPiB0aGF0IGFkZHMgbm90aGluZyBidXQgaGVscGluZyB0byBtYW5hZ2Ug
dGhlIGxpZmV0aW1lIG9mIHN0cnVjdCBobW0sCj4gPiB3aGljaCBzaG91bGRuJ3QgZXhpc3QgdG8g
c3RhcnQgd2l0aC4KPiAKPiBDaHJpc3RvcGg6IFdoYXQgZG8geW91IHRoaW5rIGFib3V0IHRoaXMg
c2tldGNoIGJlbG93Pwo+IAo+IEl0IHdvdWxkIHJlcGxhY2UgdGhlIGhtbV9yYW5nZS9taXJyb3Iv
ZXRjIHdpdGggYSBkaWZmZXJlbnQgd2F5IHRvCj4gYnVpbGQgdGhlIHNhbWUgbG9ja2luZyBzY2hl
bWUgdXNpbmcgc29tZSBvcHRpb25hbCBoZWxwZXJzIGxpbmtlZCB0bwo+IHRoZSBtbXUgbm90aWZp
ZXI/Cj4gCj4gKGp1c3QgYSBza2V0Y2gsIHN0aWxsIG5lZWRzIGEgbG90IG1vcmUgdGhpbmtpbmcp
CgpJIGxpa2UgdGhlIGlkZWEuICBBIGZldyBuaXRwaWNrczogIENhbiB3ZSBhdm9pZCBoYXZpbmcg
dG8gc3RvcmUKdGhlIG1tIGluIHN0cnVjdCBtbXVfbm90aWZpZXI/ICBJIHRoaW5rIHdlIGNvdWxk
IGp1c3QgZWFzaWx5IHBhc3MKaXQgYXMgYSBwYXJhbWV0ZXIgdG8gdGhlIGhlbHBlcnMuICBUaGUg
d3JpdGUgbG9jayBjYXNlIG9mCm1tX2ludmxvY2tfc3RhcnRfd3JpdGVfYW5kX2xvY2sgaXMgcHJv
YmFibHkgd29ydGggZmFjdG9yaW5nIGludG8Kc2VwYXJhdGUgaGVscGVyPyBJIGNhbiBzZWUgY2Fz
ZXMgd2hlcmUgZHJpdmVycyB3YW50IHRvIGp1c3QgdXNlCml0IGRpcmVjdGx5IGlmIHRoZXkgbmVl
ZCB0byBmb3JjZSBnZXR0aW5nIHRoZSBsb2NrIHdpdGhvdXQgdGhlIGNoYW5jZQpvZiBhIGxvbmcg
d2FpdC4KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmFt
ZC1nZnggbWFpbGluZyBsaXN0CmFtZC1nZnhAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8v
bGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vYW1kLWdmeA==
