From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v3 hmm 06/12] mm/hmm: Hold on to the mmget for the
 lifetime of the range
Date: Wed, 19 Jun 2019 04:54:21 -0700
Message-ID: <20190619115421.GB19138@infradead.org>
References: <20190614004450.20252-1-jgg@ziepe.ca>
 <20190614004450.20252-7-jgg@ziepe.ca>
 <20190615141435.GF17724@infradead.org>
 <20190618151100.GI6961@ziepe.ca>
 <20190619081858.GB24900@infradead.org>
 <20190619113452.GB9360@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20190619113452.GB9360-uk2M96/98Pc@public.gmane.org>
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

T24gV2VkLCBKdW4gMTksIDIwMTkgYXQgMDg6MzQ6NTJBTSAtMDMwMCwgSmFzb24gR3VudGhvcnBl
IHdyb3RlOgo+IC8qKgo+ICAqIGxpc3RfZW1wdHlfY2FyZWZ1bCAtIHRlc3RzIHdoZXRoZXIgYSBs
aXN0IGlzIGVtcHR5IGFuZCBub3QgYmVpbmcgbW9kaWZpZWQKPiAgKiBAaGVhZDogdGhlIGxpc3Qg
dG8gdGVzdAo+ICAqCj4gICogRGVzY3JpcHRpb246Cj4gICogdGVzdHMgd2hldGhlciBhIGxpc3Qg
aXMgZW1wdHkgX2FuZF8gY2hlY2tzIHRoYXQgbm8gb3RoZXIgQ1BVIG1pZ2h0IGJlCj4gICogaW4g
dGhlIHByb2Nlc3Mgb2YgbW9kaWZ5aW5nIGVpdGhlciBtZW1iZXIgKG5leHQgb3IgcHJldikKPiAg
Kgo+ICAqIE5PVEU6IHVzaW5nIGxpc3RfZW1wdHlfY2FyZWZ1bCgpIHdpdGhvdXQgc3luY2hyb25p
emF0aW9uCj4gICogY2FuIG9ubHkgYmUgc2FmZSBpZiB0aGUgb25seSBhY3Rpdml0eSB0aGF0IGNh
biBoYXBwZW4KPiAgKiB0byB0aGUgbGlzdCBlbnRyeSBpcyBsaXN0X2RlbF9pbml0KCkuIEVnLiBp
dCBjYW5ub3QgYmUgdXNlZAo+ICAqIGlmIGFub3RoZXIgQ1BVIGNvdWxkIHJlLWxpc3RfYWRkKCkg
aXQuCj4gICovCj4gCj4gQWdyZWUgaXQgZG9lc24ndCBzZWVtIG9idmlvdXMgd2h5IHRoaXMgaXMg
cmVsZXZhbnQgd2hlbiBjaGVja2luZyB0aGUKPiBsaXN0IGhlYWQuLgo+IAo+IE1heWJlIHRoZSBj
b21tZW50IGlzIGEgYml0IG1pc2xlYWRpbmc/CgpGcm9tIGxvb2tpbmcgYXQgdGhlIGNvbW1pdCBs
b2cgaW4gdGhlIGhpc3RvcnkgdHJlZSBsaXN0X2VtcHR5X2NhcmVmdWwKd2FzIGluaXRpYWxseSBh
ZGRlZCBieSBMaW51cywgYW5kIHRoZW4gbWluZ28gYWRkZWQgdGhhdCBjb21tZW50IGxhdGVyLgpJ
IGRvbid0IHNlZSBob3cgbGlzdF9kZWxfaW5pdCB3b3VsZCBjaGFuZ2UgYW55dGhpbmcgaGVyZSwg
c28gSSBzdXNwZWN0Cmxpc3RfZGVsX2luaXQgd2FzIGp1c3QgdXNlZCBhcyBhIHNob3J0IGhhbmQg
Zm9yIGxpc3RfZGVsIG9yCmxpc3RfZGVsX2luaXQuCl9fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fCmFtZC1nZnggbWFpbGluZyBsaXN0CmFtZC1nZnhAbGlzdHMu
ZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlz
dGluZm8vYW1kLWdmeA==
