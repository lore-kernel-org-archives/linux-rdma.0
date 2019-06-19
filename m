From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v3 hmm 11/12] mm/hmm: Remove confusing comment and logic
 from hmm_release
Date: Wed, 19 Jun 2019 01:07:05 -0700
Message-ID: <20190619080705.GA5164@infradead.org>
References: <20190614004450.20252-1-jgg@ziepe.ca>
 <20190614004450.20252-12-jgg@ziepe.ca>
 <20190615142106.GK17724@infradead.org>
 <20190618004509.GE30762@ziepe.ca>
 <20190618053733.GA25048@infradead.org>
 <be4f8573-6284-04a6-7862-23bb357bfe3c@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <be4f8573-6284-04a6-7862-23bb357bfe3c-5C7GfCeVMHo@public.gmane.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/amd-gfx>
List-Post: <mailto:amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
List-Help: <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=subscribe>
Errors-To: amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Sender: "amd-gfx" <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
To: "Kuehling, Felix" <Felix.Kuehling-5C7GfCeVMHo@public.gmane.org>
Cc: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Yang,
 Philip" <Philip.Yang-5C7GfCeVMHo@public.gmane.org>, Ralph Campbell <rcampbell-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, "dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Ben Skeggs <bskeggs-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gV2VkLCBKdW4gMTksIDIwMTkgYXQgMTI6NTM6NTVBTSArMDAwMCwgS3VlaGxpbmcsIEZlbGl4
IHdyb3RlOgo+IFRoaXMgY29kZSBpcyBkZXJpdmVkIGZyb20gb3VyIG9sZCBNTVUgbm90aWZpZXIg
Y29kZS4gQmVmb3JlIEhNTSB3ZSB1c2VkIAo+IHRvIHJlZ2lzdGVyIGEgc2luZ2xlIE1NVSBub3Rp
ZmllciBwZXIgbW1fc3RydWN0IGFuZCBsb29rIHVwIHZpcnR1YWwgCj4gYWRkcmVzcyByYW5nZXMg
dGhhdCBoYWQgYmVlbiByZWdpc3RlcmVkIGZvciBtaXJyb3JpbmcgdmlhIGRyaXZlciBBUEkgCj4g
Y2FsbHMuIFRoZSBpZGVhIHdhcyB0byByZXVzZSBhIHNpbmdsZSBNTVUgbm90aWZpZXIgZm9yIHRo
ZSBsaWZlIHRpbWUgb2YgCj4gdGhlIHByb2Nlc3MuIEl0IHdvdWxkIHJlbWFpbiByZWdpc3RlcmVk
IHVudGlsIHdlIGdvdCBhIG5vdGlmaWVyX3JlbGVhc2UuCj4gCj4gaG1tX21pcnJvciB0b29rIHRo
ZSBwbGFjZSBvZiB0aGF0IHdoZW4gd2UgY29udmVydGVkIHRoZSBjb2RlIHRvIEhNTS4KPiAKPiBJ
IHN1cHBvc2Ugd2UgY291bGQgZGVzdHJveSB0aGUgbWlycm9yIGVhcmxpZXIsIHdoZW4gd2UgaGF2
ZSBubyBtb3JlIAo+IHJlZ2lzdGVyZWQgdmlydHVhbCBhZGRyZXNzIHJhbmdlcywgYW5kIGNyZWF0
ZSBhIG5ldyBvbmUgaWYgbmVlZGVkIGxhdGVyLgoKSSBkaWRuJ3Qgd3JpdGUgdGhlIGNvZGUsIGJ1
dCBpZiB5b3UgbG9vayBhdCBobW1fbWlycm9yIGl0IGFscmVhZHkgaXMKYSBtdWx0aXBsZXhlciBv
dmVyIHRoZSBtbXUgbm90aWZpZXIsIGFuZCB0aGUgaW50ZW50IGNsZWFybHkgc2VlbXMgdGhhdAp5
b3UgcmVnaXN0ZXIgb25lIHBlciByYW5nZSB0aGF0IHlvdSB3YW50IHRvIG1pcnJvciwgYW5kIG5v
dCBtdWx0aXBsZXgKaXQgb25jZSBhZ2Fpbi4gIEluIG90aGVyIHdvcmRzIC0gSSB0aGluayBlYWNo
IGFtZGdwdV9tbl9ub2RlIHNob3VsZApwcm9iYWJseSBoYXZlIGl0cyBvd24gaG1tX21pcnJvci4g
IEFuZCB3aGlsZSB0aGUgYW1kZ3B1X21uX25vZGUgb2JqZWN0cwphcmUgY3VycmVudGx5IHN0b3Jl
ZCBpbiBhbiBpbnRlcnZhbCB0cmVlIGl0IHNlZW1zIGxpa2UgdGhleSBhcmUgb25seQpsaW5lYXJs
eSBpdGVyYXRlZCBhbnl3YXksIHNvIGEgbGlzdCBhY3R1YWxseSBzZWVtcyBwcmV0dHkgc3VpdGFi
bGUuICBJZgpub3Qgd2UgbmVlZCB0byBpbXByb3ZlIHRoZSBjb3JlIGRhdGEgc3RydWN0dXJlcyBp
bnN0ZWFkIG9mIHdvcmtpbmcKYXJvdW5kIHRoZW0uCl9fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fCmFtZC1nZnggbWFpbGluZyBsaXN0CmFtZC1nZnhAbGlzdHMu
ZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlz
dGluZm8vYW1kLWdmeA==
