From: Ralph Campbell <rcampbell-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] mm/hmm: pass mmu_notifier_range to
 sync_cpu_device_pagetables
Date: Tue, 2 Jul 2019 13:11:28 -0700
Message-ID: <b0252869-588f-0333-1878-1f90b8b0c17b@nvidia.com>
References: <20190608001452.7922-1-rcampbell@nvidia.com>
 <20190702195317.GT31718@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
In-Reply-To: <20190702195317.GT31718-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/amd-gfx>
List-Post: <mailto:amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
List-Help: <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=subscribe>
Errors-To: amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Sender: "amd-gfx" <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, "Felix.Kuehling-5C7GfCeVMHo@public.gmane.org" <Felix.Kuehling-5C7GfCeVMHo@public.gmane.org>, "dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Ck9uIDcvMi8xOSAxMjo1MyBQTSwgSmFzb24gR3VudGhvcnBlIHdyb3RlOgo+IE9uIEZyaSwgSnVu
IDA3LCAyMDE5IGF0IDA1OjE0OjUyUE0gLTA3MDAsIFJhbHBoIENhbXBiZWxsIHdyb3RlOgo+PiBI
TU0gZGVmaW5lcyBpdHMgb3duIHN0cnVjdCBobW1fdXBkYXRlIHdoaWNoIGlzIHBhc3NlZCB0byB0
aGUKPj4gc3luY19jcHVfZGV2aWNlX3BhZ2V0YWJsZXMoKSBjYWxsYmFjayBmdW5jdGlvbi4gVGhp
cyBpcwo+PiBzdWZmaWNpZW50IHdoZW4gdGhlIG9ubHkgYWN0aW9uIGlzIHRvIGludmFsaWRhdGUu
IEhvd2V2ZXIsCj4+IGEgZGV2aWNlIG1heSB3YW50IHRvIGtub3cgdGhlIHJlYXNvbiBmb3IgdGhl
IGludmFsaWRhdGlvbiBhbmQKPj4gYmUgYWJsZSB0byBzZWUgdGhlIG5ldyBwZXJtaXNzaW9ucyBv
biBhIHJhbmdlLCB1cGRhdGUgZGV2aWNlIGFjY2Vzcwo+PiByaWdodHMgb3IgcmFuZ2Ugc3RhdGlz
dGljcy4gU2luY2Ugc3luY19jcHVfZGV2aWNlX3BhZ2V0YWJsZXMoKQo+PiBjYW4gYmUgY2FsbGVk
IGZyb20gdHJ5X3RvX3VubWFwKCksIHRoZSBtbWFwX3NlbSBtYXkgbm90IGJlIGhlbGQKPj4gYW5k
IGZpbmRfdm1hKCkgaXMgbm90IHNhZmUgdG8gYmUgY2FsbGVkLgo+PiBQYXNzIHRoZSBzdHJ1Y3Qg
bW11X25vdGlmaWVyX3JhbmdlIHRvIHN5bmNfY3B1X2RldmljZV9wYWdldGFibGVzKCkKPj4gdG8g
YWxsb3cgdGhlIGZ1bGwgaW52YWxpZGF0aW9uIGluZm9ybWF0aW9uIHRvIGJlIHVzZWQuCj4+Cj4+
IFNpZ25lZC1vZmYtYnk6IFJhbHBoIENhbXBiZWxsIDxyY2FtcGJlbGxAbnZpZGlhLmNvbT4KPj4g
LS0tCj4+Cj4+IEknbSBzZW5kaW5nIHRoaXMgb3V0IG5vdyBzaW5jZSB3ZSBhcmUgdXBkYXRpbmcg
bWFueSBvZiB0aGUgSE1NIEFQSXMKPj4gYW5kIEkgdGhpbmsgaXQgd2lsbCBiZSB1c2VmdWwuCj4g
Cj4gVGhpcyBtYWtlIHNvIG11Y2ggc2Vuc2UsIEknZCBsaWtlIHRvIGFwcGx5IHRoaXMgaW4gaG1t
LmdpdCwgaXMgdGhlcmUKPiBhbnkgb2JqZWN0aW9uPwo+IAo+IEphc29uCj4gCk5vdCBmcm9tIG1l
LiA6LSkKClRoYW5rcyEKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX18KYW1kLWdmeCBtYWlsaW5nIGxpc3QKYW1kLWdmeEBsaXN0cy5mcmVlZGVza3RvcC5vcmcK
aHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9hbWQtZ2Z4
