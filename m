From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v3 hmm 08/12] mm/hmm: Remove racy protection against
 double-unregistration
Date: Wed, 19 Jun 2019 01:19:48 -0700
Message-ID: <20190619081948.GC24900@infradead.org>
References: <20190614004450.20252-1-jgg@ziepe.ca>
 <20190614004450.20252-9-jgg@ziepe.ca>
 <20190615141612.GH17724@infradead.org>
 <20190618131324.GF6961@ziepe.ca>
 <20190618132722.GA1633@infradead.org>
 <20190618185757.GP6961@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20190618185757.GP6961-uk2M96/98Pc@public.gmane.org>
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

T24gVHVlLCBKdW4gMTgsIDIwMTkgYXQgMDM6NTc6NTdQTSAtMDMwMCwgSmFzb24gR3VudGhvcnBl
IHdyb3RlOgo+IFdpdGggdGhlIHByZXZpb3VzIGxvb3NlIGNvdXBsaW5nIG9mIHRoZSBtaXJyb3Ig
YW5kIHRoZSByYW5nZSBzb21lIGNvZGUKPiBtaWdodCByYW5jZSB0byB0cnkgdG8gY3JlYXRlIGEg
cmFuZ2Ugd2l0aG91dCBhIG1pcnJvciwgd2hpY2ggd2lsbCBub3cKPiByZWxpYWJseSBjcmFzaCB3
aXRoIHRoZSBwb2lzb24uCj4gCj4gSXQgaXNuJ3Qgc28gbXVjaCB0aGUgZG91YmxlIHVucmVnaXN0
ZXIgdGhhdCB3b3JyaWVzIG1lLCBidXQgcmFjaW5nCj4gdW5yZWdpc3RlciB3aXRoIHJhbmdlIGZ1
bmN0aW9ucy4KCk9oIHdlbGwuICBJdCB3YXMganVzdCBhIG5pdHBpY2sgZm9yIHRoZSBoaWdobHkg
dW51c3VhbCBjb2RlIHBhdHRlcm5zCmluIHRoZSB0d28gdW5yZWdpc3RlciByb3V0aW5lcywgcHJv
YmFibHkgbm90IHdvcnRoIGZpZ2h0aW5nIG92ZXIgZXZlbgppZiBJIHN0aWxsIGRvbid0IHNlZSB0
aGUgcG9pbnQuCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
CmFtZC1nZnggbWFpbGluZyBsaXN0CmFtZC1nZnhAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBz
Oi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vYW1kLWdmeA==
