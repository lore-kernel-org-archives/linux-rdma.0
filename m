From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [RFC] mm/hmm: pass mmu_notifier_range to
 sync_cpu_device_pagetables
Date: Wed, 3 Jul 2019 02:03:33 +0200
Message-ID: <20190703000333.GA29316@lst.de>
References: <20190608001452.7922-1-rcampbell@nvidia.com>
 <20190702195317.GT31718@mellanox.com> <20190702224912.GA24043@lst.de>
 <20190702225911.GA11833@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20190702225911.GA11833-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/amd-gfx>
List-Post: <mailto:amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
List-Help: <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=subscribe>
Errors-To: amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Sender: "amd-gfx" <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ralph Campbell <rcampbell-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, "Felix.Kuehling-5C7GfCeVMHo@public.gmane.org" <Felix.Kuehling-5C7GfCeVMHo@public.gmane.org>, "dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gVHVlLCBKdWwgMDIsIDIwMTkgYXQgMTA6NTk6MTZQTSArMDAwMCwgSmFzb24gR3VudGhvcnBl
IHdyb3RlOgo+ID4gQXMgdGhpcyBjcmVhdGVzIGEgc29tZXdoYXQgaGFpcnkgY29uZmxpY3QgZm9y
IGFtZGdwdSwgd291bGRuJ3QgaXQgYmUKPiA+IGEgYmV0dGVyIGlkZWEgdG8gd2FpdCBhIGJpdCBh
bmQgYXBwbHkgaXQgZmlyc3QgdGhpbmcgZm9yIG5leHQgbWVyZ2UKPiA+IHdpbmRvdz8KPiAKPiBN
eSB0aGlua2luZyBpcyB0aGF0IEFNRCBHUFUgYWxyZWFkeSBoYXMgYSBtb25zdGVyIGNvbmZsaWN0
IGZyb20gdGhpczoKPiAKPiAgaW50IGhtbV9yYW5nZV9yZWdpc3RlcihzdHJ1Y3QgaG1tX3Jhbmdl
ICpyYW5nZSwKPiAtICAgICAgICAgICAgICAgICAgICAgIHN0cnVjdCBtbV9zdHJ1Y3QgKm1tLAo+
ICsgICAgICAgICAgICAgICAgICAgICAgc3RydWN0IGhtbV9taXJyb3IgKm1pcnJvciwKPiAgICAg
ICAgICAgICAgICAgICAgICAgIHVuc2lnbmVkIGxvbmcgc3RhcnQsCj4gICAgICAgICAgICAgICAg
ICAgICAgICB1bnNpZ25lZCBsb25nIGVuZCwKPiAgICAgICAgICAgICAgICAgICAgICAgIHVuc2ln
bmVkIHBhZ2Vfc2hpZnQpOwoKV2VsbCwgdGhhdCBzZWVtcyBsaWtlIGEgcmVsYXRpdmVseSBlYXN5
IHRvIGZpeCBjb25mbGljdCwgYXQgbGVhc3QgYXMKbG9uZyBhcyB5b3UgaGF2ZSB0aGUgbWlycm9y
IGVhc2lseSBhdmFpbGFibGUuICBUaGUgbm90aWZpZXIgY2hhbmdlCm9uIHRoZSBvdGhlciBoYW5k
IGJhc2ljYWxseSByZXF1aXJlcyByZXdyaXRpbmcgYWJvdXQgdHdvIGRvemVuIGxpbmVzCm9mIGNv
ZGUgZW50aXJlbHkuCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fCmFtZC1nZnggbWFpbGluZyBsaXN0CmFtZC1nZnhAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0
dHBzOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vYW1kLWdmeA==
