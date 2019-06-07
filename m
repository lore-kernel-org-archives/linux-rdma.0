From: Ralph Campbell <rcampbell-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 hmm 07/11] mm/hmm: Use lockdep instead of comments
Date: Fri, 7 Jun 2019 13:31:04 -0700
Message-ID: <a5c8ffcb-8fa7-3335-ed62-2bb56ddbdf65@nvidia.com>
References: <20190606184438.31646-1-jgg@ziepe.ca>
 <20190606184438.31646-8-jgg@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
In-Reply-To: <20190606184438.31646-8-jgg-uk2M96/98Pc@public.gmane.org>
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
IEd1bnRob3JwZSA8amdnQG1lbGxhbm94LmNvbT4KPiAKPiBTbyB3ZSBjYW4gY2hlY2sgbG9ja2lu
ZyBhdCBydW50aW1lLgo+IAo+IFNpZ25lZC1vZmYtYnk6IEphc29uIEd1bnRob3JwZSA8amdnQG1l
bGxhbm94LmNvbT4KPiBSZXZpZXdlZC1ieTogSsOpcsO0bWUgR2xpc3NlIDxqZ2xpc3NlQHJlZGhh
dC5jb20+CgpSZXZpZXdlZC1ieTogUmFscGggQ2FtcGJlbGwgPHJjYW1wYmVsbEBudmlkaWEuY29t
PgoKPiAtLS0KPiB2Mgo+IC0gRml4IG1pc3NpbmcgJiBpbiBsb2NrZGVwcyAoSmFzb24pCj4gLS0t
Cj4gICBtbS9obW0uYyB8IDQgKystLQo+ICAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygr
KSwgMiBkZWxldGlvbnMoLSkKPiAKPiBkaWZmIC0tZ2l0IGEvbW0vaG1tLmMgYi9tbS9obW0uYwo+
IGluZGV4IGY2N2JhMzI5ODNkOWYxLi5jNzAyY2Q3MjY1MWI1MyAxMDA2NDQKPiAtLS0gYS9tbS9o
bW0uYwo+ICsrKyBiL21tL2htbS5jCj4gQEAgLTI1NCwxMSArMjU0LDExIEBAIHN0YXRpYyBjb25z
dCBzdHJ1Y3QgbW11X25vdGlmaWVyX29wcyBobW1fbW11X25vdGlmaWVyX29wcyA9IHsKPiAgICAq
Cj4gICAgKiBUbyBzdGFydCBtaXJyb3JpbmcgYSBwcm9jZXNzIGFkZHJlc3Mgc3BhY2UsIHRoZSBk
ZXZpY2UgZHJpdmVyIG11c3QgcmVnaXN0ZXIKPiAgICAqIGFuIEhNTSBtaXJyb3Igc3RydWN0Lgo+
IC0gKgo+IC0gKiBUSEUgbW0tPm1tYXBfc2VtIE1VU1QgQkUgSEVMRCBJTiBXUklURSBNT0RFICEK
PiAgICAqLwo+ICAgaW50IGhtbV9taXJyb3JfcmVnaXN0ZXIoc3RydWN0IGhtbV9taXJyb3IgKm1p
cnJvciwgc3RydWN0IG1tX3N0cnVjdCAqbW0pCj4gICB7Cj4gKwlsb2NrZGVwX2Fzc2VydF9oZWxk
X2V4Y2x1c2l2ZSgmbW0tPm1tYXBfc2VtKTsKPiArCj4gICAJLyogU2FuaXR5IGNoZWNrICovCj4g
ICAJaWYgKCFtbSB8fCAhbWlycm9yIHx8ICFtaXJyb3ItPm9wcykKPiAgIAkJcmV0dXJuIC1FSU5W
QUw7Cj4gCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmFt
ZC1nZnggbWFpbGluZyBsaXN0CmFtZC1nZnhAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8v
bGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vYW1kLWdmeA==
