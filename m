From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [RFC] mm/hmm: pass mmu_notifier_range to
 sync_cpu_device_pagetables
Date: Sat, 8 Jun 2019 11:50:16 +0000
Message-ID: <20190608115011.GB14873@mellanox.com>
References: <20190608001452.7922-1-rcampbell@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20190608001452.7922-1-rcampbell@nvidia.com>
Content-Language: en-US
Content-ID: <FFF05C274A0A8E44B62AD3BAF4C55A80@eurprd05.prod.outlook.com>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Ralph Campbell <rcampbell@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, John Hubbard <jhubbard@nvidia.com>, "Felix.Kuehling@amd.com" <Felix.Kuehling@amd.com>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Jerome Glisse <jglisse@redhat.com>, "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>
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
bnkgb2YgdGhlIEhNTSBBUElzCj4gYW5kIEkgdGhpbmsgaXQgd2lsbCBiZSB1c2VmdWwuCgpJIGFn
cmVlIHdpdGggQ0ggdGhhdCBzdHJ1Y3QgaG1tX3VwZGF0ZSBzZWVtcyBwYXJ0aWN1bGFybHkgcG9p
bnRsZXNzCmFuZCB3ZSByZWFsbHkgc2hvdWxkIGp1c3QgdXNlIG1tdV9ub3RpZmllcl9yYW5nZSBk
aXJlY3RseS4KCldlIG5lZWQgdG8gZmluZCBvdXQgZnJvbSB0aGUgRFJNIGZvbGtzIGlmIHdlIGNh
biBtZXJnZSB0aGlzIGtpbmQgb2YKc3R1ZmYgdGhyb3VnaCBobW0uZ2l0IGFuZCB0aGVuIHJlc29s
dmUgYW55IGNvbmZsaWN0cyB0aGF0IG1pZ2h0IGFyaXNlCmluIERSTSB0cmVlIG9yIGluIG5vdXZl
YXUgdHJlZT8KCkJ1dCBJIHdvdWxkIGxpa2UgdG8gc2VlIHRoaXMgcGF0Y2ggZ28gaW4gdGhpcyBj
eWNsZSwgdGhhbmtzCgpKYXNvbgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fXwpkcmktZGV2ZWwgbWFpbGluZyBsaXN0CmRyaS1kZXZlbEBsaXN0cy5mcmVlZGVz
a3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9k
cmktZGV2ZWw=
