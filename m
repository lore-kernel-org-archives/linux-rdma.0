From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v3 hmm 04/12] mm/hmm: Simplify hmm_get_or_create and make
 it reliable
Date: Sat, 15 Jun 2019 07:12:11 -0700
Message-ID: <20190615141211.GD17724@infradead.org>
References: <20190614004450.20252-1-jgg@ziepe.ca>
 <20190614004450.20252-5-jgg@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20190614004450.20252-5-jgg-uk2M96/98Pc@public.gmane.org>
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
Cc: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Philip Yang <Philip.Yang-5C7GfCeVMHo@public.gmane.org>, Ralph Campbell <rcampbell-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Felix.Kuehling-5C7GfCeVMHo@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ben Skeggs <bskeggs-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

PiArCXNwaW5fbG9jaygmbW0tPnBhZ2VfdGFibGVfbG9jayk7Cj4gKwlpZiAobW0tPmhtbSkgewo+
ICsJCWlmIChrcmVmX2dldF91bmxlc3NfemVybygmbW0tPmhtbS0+a3JlZikpIHsKPiArCQkJc3Bp
bl91bmxvY2soJm1tLT5wYWdlX3RhYmxlX2xvY2spOwo+ICsJCQlyZXR1cm4gbW0tPmhtbTsKPiAr
CQl9Cj4gKwl9Cj4gKwlzcGluX3VubG9jaygmbW0tPnBhZ2VfdGFibGVfbG9jayk7CgpUaGlzIGNv
dWxkIGJlY29tZToKCglzcGluX2xvY2soJm1tLT5wYWdlX3RhYmxlX2xvY2spOwoJaG1tID0gbW0t
PmhtbQoJaWYgKGhtbSAmJiBrcmVmX2dldF91bmxlc3NfemVybygmaG1tLT5rcmVmKSkKCQlnb3Rv
IG91dF91bmxvY2s7CglzcGluX3VubG9jaygmbW0tPnBhZ2VfdGFibGVfbG9jayk7CgphcyB0aGUg
bGFzdCB0d28gbGluZXMgb2YgdGhlIGZ1bmN0aW9uIGFscmVhZHkgZHJvcCB0aGUgcGFnZV90YWJs
ZV9sb2NrCmFuZCB0aGVuIHJldHVybiBobW0uICBPciBkcm9wIHRoZSAiaG1tID0gbW0tPmhtbSIg
YXNpZ25tZW50IGFib3ZlIGFuZApyZXR1cm4gbW0tPmhtbSBhcyB0aGF0IHNob3VsZCBiZSBhbHdh
eXMgaWRlbnRpY2FsIHRvIGhtbSBhdCB0aGUgZW5kCnRvIHNhdmUgYW5vdGhlciBsaW5lLgoKPiAr
CS8qCj4gKwkgKiBUaGUgbW0tPmhtbSBwb2ludGVyIGlzIGtlcHQgdmFsaWQgd2hpbGUgbm90aWZp
ZXIgb3BzIGNhbiBiZSBydW5uaW5nCj4gKwkgKiBzbyB0aGV5IGRvbid0IGhhdmUgdG8gZGVhbCB3
aXRoIGEgTlVMTCBtbS0+aG1tIHZhbHVlCj4gKwkgKi8KClRoZSBjb21tZW50IGNvbmZ1c2VzIG1l
LiAgSG93IGRvZXMgdGhlIHBhZ2VfdGFibGVfbG9jayByZWxhdGUgdG8KcG9zc2libHkgcnVubmlu
ZyBub3RpZmllcnMsIGFzIEkgY2FuJ3QgZmluZCB0aGF0IHdlIHRha2UKcGFnZV90YWJsZV9sb2Nr
PyAgT3IgaXMgaXQganVzdCBhYm91dCB0aGUgZmFjdCB0aGF0IHdlIG9ubHkgY2xlYXIKbW0tPmht
bSBpbiB0aGUgZnJlZSBjYWxsYmFjaywgYW5kIG5vdCBpbiBobW1fZnJlZT8KX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KYW1kLWdmeCBtYWlsaW5nIGxpc3QK
YW1kLWdmeEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5v
cmcvbWFpbG1hbi9saXN0aW5mby9hbWQtZ2Z4
