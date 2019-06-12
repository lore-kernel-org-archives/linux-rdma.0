From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v2 hmm 02/11] mm/hmm: Use hmm_mirror not mm as an
 argument for hmm_range_register
Date: Wed, 12 Jun 2019 05:11:20 -0700
Message-ID: <20190612121120.GA24966@infradead.org>
References: <20190606184438.31646-1-jgg@ziepe.ca>
 <20190606184438.31646-3-jgg@ziepe.ca>
 <20190608085425.GB32185@infradead.org>
 <20190611194431.GC29375@ziepe.ca>
 <20190612071234.GA20306@infradead.org>
 <20190612114125.GA3876@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20190612114125.GA3876-uk2M96/98Pc@public.gmane.org>
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

T24gV2VkLCBKdW4gMTIsIDIwMTkgYXQgMDg6NDE6MjVBTSAtMDMwMCwgSmFzb24gR3VudGhvcnBl
IHdyb3RlOgo+ID4gSSBsaWtlIHRoZSBpZGVhLiAgQSBmZXcgbml0cGlja3M6IENhbiB3ZSBhdm9p
ZCBoYXZpbmcgdG8gc3RvcmUgdGhlCj4gPiBtbSBpbiBzdHJ1Y3QgbW11X25vdGlmaWVyPyBJIHRo
aW5rIHdlIGNvdWxkIGp1c3QgZWFzaWx5IHBhc3MgaXQgYXMgYQo+ID4gcGFyYW1ldGVyIHRvIHRo
ZSBoZWxwZXJzLgo+IAo+IFllcywgYnV0IEkgdGhpbmsgYW55IGRyaXZlciB0aGF0IG5lZWRzIHRv
IHVzZSB0aGlzIEFQSSB3aWxsIGhhdmUgdG8KPiBob2xkIHRoZSAnc3RydWN0IG1tX3N0cnVjdCcg
YW5kIHRoZSAnc3RydWN0IG1tdV9ub3RpZmllcicgdG9nZXRoZXIgKGllCj4gT0RQIGRvZXMgdGhp
cyBpbiBpYl91Y29udGV4dF9wZXJfbW0pLCBzbyBpZiB3ZSBwdXQgaXQgaW4gdGhlIG5vdGlmaWVy
Cj4gdGhlbiBpdCBpcyB0cml2aWFsbHkgYXZhaWxhYmxlIGV2ZXJ3aGVyZSBpdCBpcyBuZWVkZWQs
IGFuZCB0aGUKPiBtbXVfbm90aWZpZXIgY29kZSB0YWtlcyBjYXJlIG9mIHRoZSBsaWZldGltZSBm
b3IgdGhlIGRyaXZlci4KClRydWUuICBXZWxsLCBtYXliZSBrZWVwIGl0IGZvciBub3cgYXQgbGVh
c3QuCgo+IFRoZSBlbnRpcmUgcHVycG9zZSBvZiB0aGUgaW52bG9jayBpcyB0byBhdm9pZCBnZXR0
aW5nIHRoZSB3cml0ZSBsb2NrCj4gb24gbW1hcF9zZW0gYXMgYSBmYXN0IHBhdGggLSBpZiB0aGUg
ZHJpdmVyIHdpc2hlcyB0byB1c2UgbW1hcF9zZW0KPiBsb2NraW5nIG9ubHkgdGhlbiBpdCBzaG91
bGQganVzdCBkbyBzbyBkaXJlY3RseSBhbmQgZm9yZ2V0IGFib3V0IHRoZQo+IGludmxvY2suCgpN
YXkgd29ycnkgaGVyZSBpcyB0aGF0IHRoZXJlIG1pZ2ggYmUgY2FzZXMgd2hlcmUgdGhlIGRyaXZl
ciBuZWVkcwp0byBleHBlZGl0ZSB0aGUgYWN0aW9uLCBpbiB3aGljaCBjYXNlIGp1bXBpbmcgc3Ry
YWlnaHQgdG8gdGhlIHdyaXRlCmxvY2suICBCdXQgYWdhaW4gd2UgY2FuIHByb2JhYmx5IHNraXAg
dGhpcyBmb3Igbm93IGFuZCBzZWUgaWYgaXQgcmVhbGx5CmVuZHMgdXAgYmVpbmcgbmVlZGVkLgpf
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwphbWQtZ2Z4IG1h
aWxpbmcgbGlzdAphbWQtZ2Z4QGxpc3RzLmZyZWVkZXNrdG9wLm9yZwpodHRwczovL2xpc3RzLmZy
ZWVkZXNrdG9wLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2FtZC1nZng=
