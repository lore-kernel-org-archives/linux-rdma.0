From: Ralph Campbell <rcampbell-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 hmm 08/11] mm/hmm: Remove racy protection against
 double-unregistration
Date: Fri, 7 Jun 2019 13:33:08 -0700
Message-ID: <ab93b81f-8d78-8760-6fc7-d981d528026d@nvidia.com>
References: <20190606184438.31646-1-jgg@ziepe.ca>
 <20190606184438.31646-9-jgg@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
In-Reply-To: <20190606184438.31646-9-jgg-uk2M96/98Pc@public.gmane.org>
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
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, John
 Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Felix.Kuehling-5C7GfCeVMHo@public.gmane.org
Cc: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Ck9uIDYvNi8xOSAxMTo0NCBBTSwgSmFzb24gR3VudGhvcnBlIHdyb3RlOgo+IEZyb206IEphc29u
IEd1bnRob3JwZSA8amdnQG1lbGxhbm94LmNvbT4KPiAKPiBObyBvdGhlciByZWdpc3Rlci91bnJl
Z2lzdGVyIGtlcm5lbCBBUEkgYXR0ZW1wdHMgdG8gcHJvdmlkZSB0aGlzIGtpbmQgb2YKPiBwcm90
ZWN0aW9uIGFzIGl0IGlzIGluaGVyZW50bHkgcmFjeSwgc28ganVzdCBkcm9wIGl0Lgo+IAo+IENh
bGxlcnMgc2hvdWxkIHByb3ZpZGUgdGhlaXIgb3duIHByb3RlY3Rpb24sIGl0IGFwcGVhcnMgbm91
dmVhdSBhbHJlYWR5Cj4gZG9lcywgYnV0IGp1c3QgaW4gY2FzZSBkcm9wIGEgZGVidWdnaW5nIFBP
SVNPTi4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BtZWxsYW5veC5j
b20+Cj4gUmV2aWV3ZWQtYnk6IErDqXLDtG1lIEdsaXNzZSA8amdsaXNzZUByZWRoYXQuY29tPgoK
UmV2aWV3ZWQtYnk6IFJhbHBoIENhbXBiZWxsIDxyY2FtcGJlbGxAbnZpZGlhLmNvbT4KCj4gLS0t
Cj4gICBtbS9obW0uYyB8IDkgKystLS0tLS0tCj4gICAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRp
b25zKCspLCA3IGRlbGV0aW9ucygtKQo+IAo+IGRpZmYgLS1naXQgYS9tbS9obW0uYyBiL21tL2ht
bS5jCj4gaW5kZXggYzcwMmNkNzI2NTFiNTMuLjY4MDJkZTcwODBkMTcyIDEwMDY0NAo+IC0tLSBh
L21tL2htbS5jCj4gKysrIGIvbW0vaG1tLmMKPiBAQCAtMjg0LDE4ICsyODQsMTMgQEAgRVhQT1JU
X1NZTUJPTChobW1fbWlycm9yX3JlZ2lzdGVyKTsKPiAgICAqLwo+ICAgdm9pZCBobW1fbWlycm9y
X3VucmVnaXN0ZXIoc3RydWN0IGhtbV9taXJyb3IgKm1pcnJvcikKPiAgIHsKPiAtCXN0cnVjdCBo
bW0gKmhtbSA9IFJFQURfT05DRShtaXJyb3ItPmhtbSk7Cj4gLQo+IC0JaWYgKGhtbSA9PSBOVUxM
KQo+IC0JCXJldHVybjsKPiArCXN0cnVjdCBobW0gKmhtbSA9IG1pcnJvci0+aG1tOwo+ICAgCj4g
ICAJZG93bl93cml0ZSgmaG1tLT5taXJyb3JzX3NlbSk7Cj4gICAJbGlzdF9kZWxfaW5pdCgmbWly
cm9yLT5saXN0KTsKPiAtCS8qIFRvIHByb3RlY3QgdXMgYWdhaW5zdCBkb3VibGUgdW5yZWdpc3Rl
ciAuLi4gKi8KPiAtCW1pcnJvci0+aG1tID0gTlVMTDsKPiAgIAl1cF93cml0ZSgmaG1tLT5taXJy
b3JzX3NlbSk7Cj4gLQo+ICAgCWhtbV9wdXQoaG1tKTsKPiArCW1lbXNldCgmbWlycm9yLT5obW0s
IFBPSVNPTl9JTlVTRSwgc2l6ZW9mKG1pcnJvci0+aG1tKSk7Cj4gICB9Cj4gICBFWFBPUlRfU1lN
Qk9MKGhtbV9taXJyb3JfdW5yZWdpc3Rlcik7Cj4gICAKPiAKX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX18KYW1kLWdmeCBtYWlsaW5nIGxpc3QKYW1kLWdmeEBs
aXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1h
bi9saXN0aW5mby9hbWQtZ2Z4
