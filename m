From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC] mm/hmm: pass mmu_notifier_range to
 sync_cpu_device_pagetables
Date: Tue, 2 Jul 2019 19:53:23 +0000
Message-ID: <20190702195317.GT31718@mellanox.com>
References: <20190608001452.7922-1-rcampbell@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
In-Reply-To: <20190608001452.7922-1-rcampbell-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Content-ID: <9EEF795A80FA1D4D8BB871FDEA45923F-wNKe6lTLrGecE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/amd-gfx>
List-Post: <mailto:amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
List-Help: <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=subscribe>
Errors-To: amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Sender: "amd-gfx" <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
To: Ralph Campbell <rcampbell-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, "Felix.Kuehling-5C7GfCeVMHo@public.gmane.org" <Felix.Kuehling-5C7GfCeVMHo@public.gmane.org>, "dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gRnJpLCBKdW4gMDcsIDIwMTkgYXQgMDU6MTQ6NTJQTSAtMDcwMCwgUmFscGggQ2FtcGJlbGwg
d3JvdGU6Cj4gSE1NIGRlZmluZXMgaXRzIG93biBzdHJ1Y3QgaG1tX3VwZGF0ZSB3aGljaCBpcyBw
YXNzZWQgdG8gdGhlCj4gc3luY19jcHVfZGV2aWNlX3BhZ2V0YWJsZXMoKSBjYWxsYmFjayBmdW5j
dGlvbi4gVGhpcyBpcwo+IHN1ZmZpY2llbnQgd2hlbiB0aGUgb25seSBhY3Rpb24gaXMgdG8gaW52
YWxpZGF0ZS4gSG93ZXZlciwKPiBhIGRldmljZSBtYXkgd2FudCB0byBrbm93IHRoZSByZWFzb24g
Zm9yIHRoZSBpbnZhbGlkYXRpb24gYW5kCj4gYmUgYWJsZSB0byBzZWUgdGhlIG5ldyBwZXJtaXNz
aW9ucyBvbiBhIHJhbmdlLCB1cGRhdGUgZGV2aWNlIGFjY2Vzcwo+IHJpZ2h0cyBvciByYW5nZSBz
dGF0aXN0aWNzLiBTaW5jZSBzeW5jX2NwdV9kZXZpY2VfcGFnZXRhYmxlcygpCj4gY2FuIGJlIGNh
bGxlZCBmcm9tIHRyeV90b191bm1hcCgpLCB0aGUgbW1hcF9zZW0gbWF5IG5vdCBiZSBoZWxkCj4g
YW5kIGZpbmRfdm1hKCkgaXMgbm90IHNhZmUgdG8gYmUgY2FsbGVkLgo+IFBhc3MgdGhlIHN0cnVj
dCBtbXVfbm90aWZpZXJfcmFuZ2UgdG8gc3luY19jcHVfZGV2aWNlX3BhZ2V0YWJsZXMoKQo+IHRv
IGFsbG93IHRoZSBmdWxsIGludmFsaWRhdGlvbiBpbmZvcm1hdGlvbiB0byBiZSB1c2VkLgo+IAo+
IFNpZ25lZC1vZmYtYnk6IFJhbHBoIENhbXBiZWxsIDxyY2FtcGJlbGxAbnZpZGlhLmNvbT4KPiAt
LS0KPiAKPiBJJ20gc2VuZGluZyB0aGlzIG91dCBub3cgc2luY2Ugd2UgYXJlIHVwZGF0aW5nIG1h
bnkgb2YgdGhlIEhNTSBBUElzCj4gYW5kIEkgdGhpbmsgaXQgd2lsbCBiZSB1c2VmdWwuCgpUaGlz
IG1ha2Ugc28gbXVjaCBzZW5zZSwgSSdkIGxpa2UgdG8gYXBwbHkgdGhpcyBpbiBobW0uZ2l0LCBp
cyB0aGVyZQphbnkgb2JqZWN0aW9uPwoKSmFzb24KX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX18KYW1kLWdmeCBtYWlsaW5nIGxpc3QKYW1kLWdmeEBsaXN0cy5m
cmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0
aW5mby9hbWQtZ2Z4
