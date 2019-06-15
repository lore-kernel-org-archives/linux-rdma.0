From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v3 hmm 09/12] mm/hmm: Poison hmm_range during unregister
Date: Sat, 15 Jun 2019 07:17:26 -0700
Message-ID: <20190615141726.GI17724@infradead.org>
References: <20190614004450.20252-1-jgg@ziepe.ca>
 <20190614004450.20252-10-jgg@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20190614004450.20252-10-jgg-uk2M96/98Pc@public.gmane.org>
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
Cc: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Philip Yang <Philip.Yang-5C7GfCeVMHo@public.gmane.org>, Ralph Campbell <rcampbell-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Felix.Kuehling-5C7GfCeVMHo@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Souptick Joarder <jrdr.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ben Skeggs <bskeggs-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

PiAtCS8qIFNhbml0eSBjaGVjayB0aGlzIHJlYWxseSBzaG91bGQgbm90IGhhcHBlbi4gKi8KPiAt
CWlmIChobW0gPT0gTlVMTCB8fCByYW5nZS0+ZW5kIDw9IHJhbmdlLT5zdGFydCkKPiAtCQlyZXR1
cm47Cj4gLQo+ICAJbXV0ZXhfbG9jaygmaG1tLT5sb2NrKTsKPiAgCWxpc3RfZGVsX3JjdSgmcmFu
Z2UtPmxpc3QpOwo+ICAJbXV0ZXhfdW5sb2NrKCZobW0tPmxvY2spOwo+ICAKPiAgCS8qIERyb3Ag
cmVmZXJlbmNlIHRha2VuIGJ5IGhtbV9yYW5nZV9yZWdpc3RlcigpICovCj4gLQlyYW5nZS0+dmFs
aWQgPSBmYWxzZTsKPiAgCW1tcHV0KGhtbS0+bW0pOwo+ICAJaG1tX3B1dChobW0pOwo+IC0JcmFu
Z2UtPmhtbSA9IE5VTEw7Cj4gKwo+ICsJLyoKPiArCSAqIFRoZSByYW5nZSBpcyBub3cgaW52YWxp
ZCBhbmQgdGhlIHJlZiBvbiB0aGUgaG1tIGlzIGRyb3BwZWQsIHNvCj4gKyAgICAgICAgICogcG9p
c29uIHRoZSBwb2ludGVyLiAgTGVhdmUgb3RoZXIgZmllbGRzIGluIHBsYWNlLCBmb3IgdGhlIGNh
bGxlcidzCj4gKyAgICAgICAgICogdXNlLgo+ICsgICAgICAgICAqLwo+ICsJcmFuZ2UtPnZhbGlk
ID0gZmFsc2U7Cj4gKwltZW1zZXQoJnJhbmdlLT5obW0sIFBPSVNPTl9JTlVTRSwgc2l6ZW9mKHJh
bmdlLT5obW0pKTsKCkZvcm1hdHRpbmcgc2VlbXMgdG8gYmUgbWVzc2VkIHVwLiAgQnV0IGFnYWlu
IEkgZG9uJ3Qgc2VlIHRoZSB2YWx1ZQppbiB0aGUgcG9pc29uaW5nLCBqdXN0IGxldCBub3JtYWwg
bGlua2VkIGxpc3QgZGVidWdnaW5nIGRvIGl0cyB3b3JrLgpUaGUgb3RoZXIgY2xlYW51cHMgbG9v
a3MgZmluZSB0byBtZS4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX18KYW1kLWdmeCBtYWlsaW5nIGxpc3QKYW1kLWdmeEBsaXN0cy5mcmVlZGVza3RvcC5vcmcK
aHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9hbWQtZ2Z4
