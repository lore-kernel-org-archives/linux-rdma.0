From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH v2 hmm 01/11] mm/hmm: fix use after free with struct hmm
 in the mmu notifiers
Date: Fri, 7 Jun 2019 10:42:28 -0300
Message-ID: <20190607134228.GG14802@ziepe.ca>
References: <20190606184438.31646-1-jgg@ziepe.ca>
 <20190606184438.31646-2-jgg@ziepe.ca>
 <9c72d18d-2924-cb90-ea44-7cd4b10b5bc2@nvidia.com>
 <20190607123432.GB14802@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20190607123432.GB14802-uk2M96/98Pc@public.gmane.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/amd-gfx>
List-Post: <mailto:amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
List-Help: <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=subscribe>
Errors-To: amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Sender: "amd-gfx" <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
To: John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ralph Campbell <rcampbell-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Felix.Kuehling-5C7GfCeVMHo@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

T24gRnJpLCBKdW4gMDcsIDIwMTkgYXQgMDk6MzQ6MzJBTSAtMDMwMCwgSmFzb24gR3VudGhvcnBl
IHdyb3RlOgoKPiBDSCBhbHNvIHBvaW50ZWQgb3V0IGEgbW9yZSBlbGVnYW50IHNvbHV0aW9uLCB3
aGljaCBpcyB0byBnZXQgdGhlIHdyaXRlCj4gc2lkZSBvZiB0aGUgbW1hcF9zZW0gZHVyaW5nIGht
bV9taXJyb3JfdW5yZWdpc3RlciAtIG5vIG5vdGlmaWVyCj4gY2FsbGJhY2sgY2FuIGJlIHJ1bm5p
bmcgaW4gdGhpcyBjYXNlLiBUaGVuIHdlIGRlbGV0ZSB0aGUga3JlZiwgc3JjdQo+IGFuZCBzbyBm
b3J0aC4KCk9vcHMsIGl0IHR1cm5zIG91dCB0aGlzIGlzIG9ubHkgdGhlIGNhc2UgZm9yIGludmFs
aWRhdGVfc3RhcnQvZW5kLCBub3QKcmVsZWFzZSwgc28gdGhpcyBkb2Vzbid0IGhlbHAgd2l0aCB0
aGUgU1JDVSB1bmxlc3Mgd2UgYWxzbyBjaGFuZ2UKZXhpdF9tbWFwIHRvIGNhbGwgcmVsZWFzZSB3
aXRoIHRoZSBtbWFwIHNlbSBoZWxkLgoKU28gSSB0aGluayB3ZSBoYXZlIHRvIHN0aWNrIHdpdGgg
dGhpcyBmb3Igbm93LgoKSmFzb24KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX18KYW1kLWdmeCBtYWlsaW5nIGxpc3QKYW1kLWdmeEBsaXN0cy5mcmVlZGVza3Rv
cC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9hbWQt
Z2Z4
