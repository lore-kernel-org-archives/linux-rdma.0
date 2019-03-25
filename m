From: Kevin Brodsky <kevin.brodsky-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v13 14/20] drm/amdgpu, arm64: untag user pointers in
 amdgpu_ttm_tt_get_user_pages
Date: Mon, 25 Mar 2019 14:02:11 +0000
Message-ID: <d054d40e-3f38-5728-8116-3cb0a5957f9b@arm.com>
References: <cover.1553093420.git.andreyknvl@google.com>
 <017804b2198a906463d634f84777b6087c9b4a40.1553093421.git.andreyknvl@google.com>
 <20190322155955.GT13384@arrakis.emea.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
In-Reply-To: <20190322155955.GT13384-pQd4kjVL+RGcEQQL7YIRtlaTQe2KTcn/@public.gmane.org>
Content-Language: en-GB
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/amd-gfx>
List-Post: <mailto:amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
List-Help: <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=subscribe>
Errors-To: amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Sender: "amd-gfx" <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
To: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Andrey Konovalov <andreyknvl-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Kate Stewart <kstewart-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chintan Pandya <cpandya-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Vincenzo Frascino <vincenzo.frascino-5wv7dgnIgG8@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "David (ChunMing) Zhou" <David1.Zhou-5C7GfCeVMHo@public.gmane.org>, Jacob Bramley <Jacob.Bramley-5wv7dgnIgG8@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Szabolcs Nagy <Szabolcs.Nagy-5wv7dgnIgG8@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ramana Radhakrishnan <Ramana.Radhakrishnan-5wv7dgnIgG8@public.gmane.org>, Dave Martin <Dave.Ma>
List-Id: linux-rdma@vger.kernel.org

T24gMjIvMDMvMjAxOSAxNTo1OSwgQ2F0YWxpbiBNYXJpbmFzIHdyb3RlOgo+IE9uIFdlZCwgTWFy
IDIwLCAyMDE5IGF0IDAzOjUxOjI4UE0gKzAxMDAsIEFuZHJleSBLb25vdmFsb3Ygd3JvdGU6Cj4+
IFRoaXMgcGF0Y2ggaXMgYSBwYXJ0IG9mIGEgc2VyaWVzIHRoYXQgZXh0ZW5kcyBhcm02NCBrZXJu
ZWwgQUJJIHRvIGFsbG93IHRvCj4+IHBhc3MgdGFnZ2VkIHVzZXIgcG9pbnRlcnMgKHdpdGggdGhl
IHRvcCBieXRlIHNldCB0byBzb21ldGhpbmcgZWxzZSBvdGhlcgo+PiB0aGFuIDB4MDApIGFzIHN5
c2NhbGwgYXJndW1lbnRzLgo+Pgo+PiBhbWRncHVfdHRtX3R0X2dldF91c2VyX3BhZ2VzKCkgdXNl
cyBwcm92aWRlZCB1c2VyIHBvaW50ZXJzIGZvciB2bWEKPj4gbG9va3Vwcywgd2hpY2ggY2FuIG9u
bHkgYnkgZG9uZSB3aXRoIHVudGFnZ2VkIHBvaW50ZXJzLgo+Pgo+PiBVbnRhZyB1c2VyIHBvaW50
ZXJzIGluIHRoaXMgZnVuY3Rpb24uCj4+Cj4+IFNpZ25lZC1vZmYtYnk6IEFuZHJleSBLb25vdmFs
b3YgPGFuZHJleWtudmxAZ29vZ2xlLmNvbT4KPj4gLS0tCj4+ICAgZHJpdmVycy9ncHUvZHJtL2Ft
ZC9hbWRncHUvYW1kZ3B1X3R0bS5jIHwgNSArKystLQo+PiAgIDEgZmlsZSBjaGFuZ2VkLCAzIGlu
c2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCj4+Cj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2dw
dS9kcm0vYW1kL2FtZGdwdS9hbWRncHVfdHRtLmMgYi9kcml2ZXJzL2dwdS9kcm0vYW1kL2FtZGdw
dS9hbWRncHVfdHRtLmMKPj4gaW5kZXggNzNlNzFlNjFkYzk5Li44OTFiMDI3ZmEzM2IgMTAwNjQ0
Cj4+IC0tLSBhL2RyaXZlcnMvZ3B1L2RybS9hbWQvYW1kZ3B1L2FtZGdwdV90dG0uYwo+PiArKysg
Yi9kcml2ZXJzL2dwdS9kcm0vYW1kL2FtZGdwdS9hbWRncHVfdHRtLmMKPj4gQEAgLTc1MSwxMCAr
NzUxLDExIEBAIGludCBhbWRncHVfdHRtX3R0X2dldF91c2VyX3BhZ2VzKHN0cnVjdCB0dG1fdHQg
KnR0bSwgc3RydWN0IHBhZ2UgKipwYWdlcykKPj4gICAJCSAqIGNoZWNrIHRoYXQgd2Ugb25seSB1
c2UgYW5vbnltb3VzIG1lbW9yeSB0byBwcmV2ZW50IHByb2JsZW1zCj4+ICAgCQkgKiB3aXRoIHdy
aXRlYmFjawo+PiAgIAkJICovCj4+IC0JCXVuc2lnbmVkIGxvbmcgZW5kID0gZ3R0LT51c2VycHRy
ICsgdHRtLT5udW1fcGFnZXMgKiBQQUdFX1NJWkU7Cj4+ICsJCXVuc2lnbmVkIGxvbmcgdXNlcnB0
ciA9IHVudGFnZ2VkX2FkZHIoZ3R0LT51c2VycHRyKTsKPj4gKwkJdW5zaWduZWQgbG9uZyBlbmQg
PSB1c2VycHRyICsgdHRtLT5udW1fcGFnZXMgKiBQQUdFX1NJWkU7Cj4+ICAgCQlzdHJ1Y3Qgdm1f
YXJlYV9zdHJ1Y3QgKnZtYTsKPj4gICAKPj4gLQkJdm1hID0gZmluZF92bWEobW0sIGd0dC0+dXNl
cnB0cik7Cj4+ICsJCXZtYSA9IGZpbmRfdm1hKG1tLCB1c2VycHRyKTsKPj4gICAJCWlmICghdm1h
IHx8IHZtYS0+dm1fZmlsZSB8fCB2bWEtPnZtX2VuZCA8IGVuZCkgewo+PiAgIAkJCXVwX3JlYWQo
Jm1tLT5tbWFwX3NlbSk7Cj4+ICAgCQkJcmV0dXJuIC1FUEVSTTsKPiBJIHRyaWVkIHRvIHRyYWNr
IHRoaXMgZG93biBidXQgSSBmYWlsZWQgdG8gc2VlIHdoZXRoZXIgdXNlciBjb3VsZAo+IHByb3Zp
ZGUgYW4gdGFnZ2VkIHBvaW50ZXIgaGVyZSAodW5kZXIgdGhlIHJlc3RyaWN0aW9ucyBhcyBwZXIg
VmluY2Vuem8ncwo+IEFCSSBkb2N1bWVudCkuCgotPnVzZXJwdHIgaXMgc2V0IGJ5IHJhZGVvbl90
dG1fdHRfc2V0X3VzZXJwdHIoKSwgaXRzZWxmIGNhbGxlZCBmcm9tIApyYWRlb25fZ2VtX3VzZXJw
dHJfaW9jdGwoKS4gQW55IHBhZ2UtYWxpZ25lZCB2YWx1ZSBpcyBhbGxvd2VkLgoKS2V2aW4KX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KYW1kLWdmeCBtYWls
aW5nIGxpc3QKYW1kLWdmeEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVl
ZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9hbWQtZ2Z4
