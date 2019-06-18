From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v3 hmm 08/12] mm/hmm: Remove racy protection against
 double-unregistration
Date: Tue, 18 Jun 2019 06:27:22 -0700
Message-ID: <20190618132722.GA1633@infradead.org>
References: <20190614004450.20252-1-jgg@ziepe.ca>
 <20190614004450.20252-9-jgg@ziepe.ca>
 <20190615141612.GH17724@infradead.org>
 <20190618131324.GF6961@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20190618131324.GF6961-uk2M96/98Pc@public.gmane.org>
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
Cc: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Philip Yang <Philip.Yang-5C7GfCeVMHo@public.gmane.org>, Ralph Campbell <rcampbell-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Felix.Kuehling-5C7GfCeVMHo@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Ben Skeggs <bskeggs-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gVHVlLCBKdW4gMTgsIDIwMTkgYXQgMTA6MTM6MjRBTSAtMDMwMCwgSmFzb24gR3VudGhvcnBl
IHdyb3RlOgo+ID4gSSBkb24ndCBldmVuIHRoaW5rIHdlIGV2ZW4gbmVlZCB0byBib3RoZXIgd2l0
aCB0aGUgUE9JU09OLCBub3JtYWwgbGlzdAo+ID4gZGVidWdnaW5nIHdpbGwgYWxyZWFkeSBjYXRj
aCBhIGRvdWJsZSB1bnJlZ2lzdHJhdGlvbiBhbnl3YXkuCj4gCj4gbWlycm9yLT5obW0gaXNuJ3Qg
YSBsaXN0IHNvIGxpc3QgZGVidWdnaW5nIHdvbid0IGhlbHAuCj4gCj4gTXkgY29uY2VybiB3aGVu
IEkgd3JvdGUgdGhpcyB3YXMgdGhhdCBvbmUgb2YgdGhlIGluIGZsaWdodCBwYXRjaGVzIEkKPiBj
YW4ndCBzZWUgbWlnaHQgYmUgZGVwZW5kaW5nIG9uIHRoaXMgZG91YmxlLXVucmVnaXN0ZXItaXMt
c2FmZQo+IGJlaGF2aW9yLCBzbyBJIHdhbnRlZCB0aGVtIHRvIGNyYXNoIHJlbGlhYmx5Lgo+IAo+
IEl0IGlzIGEgcmVhbGx5IG92ZXJseSBjb25zZXJ2YXRpdmUgdGhpbmcgdG8gZG8uLgoKbWlycm9y
LT5saXN0IGlzIGEgbGlzdCwgYW5kIGlmIHdlIGRvIGEgbGlzdF9kZWwgb24gaXQgZHVyaW5nIHRo
ZQpzZWNvbmQgdW5yZWdpc3RyYXRpb24gaXQgd2lsbCB0cmlwIHVwIG9uIHRoZSBsaXN0IHBvaXNv
bmluZy4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KYW1k
LWdmeCBtYWlsaW5nIGxpc3QKYW1kLWdmeEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9s
aXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9hbWQtZ2Z4
