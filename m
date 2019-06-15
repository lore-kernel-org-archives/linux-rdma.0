From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v3 hmm 10/12] mm/hmm: Do not use list*_rcu() for
 hmm->ranges
Date: Sat, 15 Jun 2019 07:18:26 -0700
Message-ID: <20190615141826.GJ17724@infradead.org>
References: <20190614004450.20252-1-jgg@ziepe.ca>
 <20190614004450.20252-11-jgg@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20190614004450.20252-11-jgg-uk2M96/98Pc@public.gmane.org>
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
Cc: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Philip Yang <Philip.Yang-5C7GfCeVMHo@public.gmane.org>, Ralph Campbell <rcampbell-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Felix.Kuehling-5C7GfCeVMHo@public.gmane.org, Ira Weiny <iweiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Souptick Joarder <jrdr.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Ben Skeggs <bskeggs-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gVGh1LCBKdW4gMTMsIDIwMTkgYXQgMDk6NDQ6NDhQTSAtMDMwMCwgSmFzb24gR3VudGhvcnBl
IHdyb3RlOgo+ICAJcmFuZ2UtPmhtbSA9IGhtbTsKPiAgCWtyZWZfZ2V0KCZobW0tPmtyZWYpOwo+
IC0JbGlzdF9hZGRfcmN1KCZyYW5nZS0+bGlzdCwgJmhtbS0+cmFuZ2VzKTsKPiArCWxpc3RfYWRk
KCZyYW5nZS0+bGlzdCwgJmhtbS0+cmFuZ2VzKTsKPiAgCj4gIAkvKgo+ICAJICogSWYgdGhlcmUg
YXJlIGFueSBjb25jdXJyZW50IG5vdGlmaWVycyB3ZSBoYXZlIHRvIHdhaXQgZm9yIHRoZW0gZm9y
Cj4gQEAgLTkzNCw3ICs5MzQsNyBAQCB2b2lkIGhtbV9yYW5nZV91bnJlZ2lzdGVyKHN0cnVjdCBo
bW1fcmFuZ2UgKnJhbmdlKQo+ICAJc3RydWN0IGhtbSAqaG1tID0gcmFuZ2UtPmhtbTsKPiAgCj4g
IAltdXRleF9sb2NrKCZobW0tPmxvY2spOwo+IC0JbGlzdF9kZWxfcmN1KCZyYW5nZS0+bGlzdCk7
Cj4gKwlsaXN0X2RlbCgmcmFuZ2UtPmxpc3QpOwo+ICAJbXV0ZXhfdW5sb2NrKCZobW0tPmxvY2sp
OwoKTG9va3MgZmluZToKClNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0
LmRlPgoKQnR3LCBpcyB0aGVyZSBhbnkgcmVhc29uIG5ldyByYW5nZXMgYXJlIGFkZGVkIHRvIHRo
ZSBmcm9udCBhbmQgbm90IHRoZQp0YWlsIG9mIHRoZSBsaXN0PwpfX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fXwphbWQtZ2Z4IG1haWxpbmcgbGlzdAphbWQtZ2Z4
QGxpc3RzLmZyZWVkZXNrdG9wLm9yZwpodHRwczovL2xpc3RzLmZyZWVkZXNrdG9wLm9yZy9tYWls
bWFuL2xpc3RpbmZvL2FtZC1nZng=
