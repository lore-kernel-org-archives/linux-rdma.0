From: Andrey Konovalov <andreyknvl-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v13 15/20] drm/radeon,
 arm64: untag user pointers in radeon_ttm_tt_pin_userptr
Date: Tue, 2 Apr 2019 16:17:52 +0200
Message-ID: <CAAeHK+xAaxiyg7pea3-WX_9d-KvUHa8Pwmv8BRm7WVmqutmS5w@mail.gmail.com>
References: <cover.1553093420.git.andreyknvl@google.com>
 <038360a0a9dc0abaaaf3ad84a2d07fd544abce1a.1553093421.git.andreyknvl@google.com>
 <20190322160057.GU13384@arrakis.emea.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
In-Reply-To: <20190322160057.GU13384-pQd4kjVL+RGcEQQL7YIRtlaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/amd-gfx>
List-Post: <mailto:amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
List-Help: <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=subscribe>
Errors-To: amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Sender: "amd-gfx" <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
To: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Kate Stewart <kstewart-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chintan Pandya <cpandya-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Vincenzo Frascino <vincenzo.frascino-5wv7dgnIgG8@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "David (ChunMing) Zhou" <David1.Zhou-5C7GfCeVMHo@public.gmane.org>, Jacob Bramley <Jacob.Bramley-5wv7dgnIgG8@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Szabolcs Nagy <Szabolcs.Nagy-5wv7dgnIgG8@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dmitry Vyukov <dvyukov@go>
List-Id: linux-rdma@vger.kernel.org

T24gRnJpLCBNYXIgMjIsIDIwMTkgYXQgNTowMSBQTSBDYXRhbGluIE1hcmluYXMgPGNhdGFsaW4u
bWFyaW5hc0Bhcm0uY29tPiB3cm90ZToKPgo+IE9uIFdlZCwgTWFyIDIwLCAyMDE5IGF0IDAzOjUx
OjI5UE0gKzAxMDAsIEFuZHJleSBLb25vdmFsb3Ygd3JvdGU6Cj4gPiBUaGlzIHBhdGNoIGlzIGEg
cGFydCBvZiBhIHNlcmllcyB0aGF0IGV4dGVuZHMgYXJtNjQga2VybmVsIEFCSSB0byBhbGxvdyB0
bwo+ID4gcGFzcyB0YWdnZWQgdXNlciBwb2ludGVycyAod2l0aCB0aGUgdG9wIGJ5dGUgc2V0IHRv
IHNvbWV0aGluZyBlbHNlIG90aGVyCj4gPiB0aGFuIDB4MDApIGFzIHN5c2NhbGwgYXJndW1lbnRz
Lgo+ID4KPiA+IHJhZGVvbl90dG1fdHRfcGluX3VzZXJwdHIoKSB1c2VzIHByb3ZpZGVkIHVzZXIg
cG9pbnRlcnMgZm9yIHZtYQo+ID4gbG9va3Vwcywgd2hpY2ggY2FuIG9ubHkgYnkgZG9uZSB3aXRo
IHVudGFnZ2VkIHBvaW50ZXJzLgo+ID4KPiA+IFVudGFnIHVzZXIgcG9pbnRlcnMgaW4gdGhpcyBm
dW5jdGlvbi4KPiA+Cj4gPiBTaWduZWQtb2ZmLWJ5OiBBbmRyZXkgS29ub3ZhbG92IDxhbmRyZXlr
bnZsQGdvb2dsZS5jb20+Cj4gPiAtLS0KPiA+ICBkcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JhZGVv
bl90dG0uYyB8IDUgKysrLS0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAy
IGRlbGV0aW9ucygtKQo+ID4KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9u
L3JhZGVvbl90dG0uYyBiL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcmFkZW9uX3R0bS5jCj4gPiBp
bmRleCA5OTIwYTZmYzExYmYuLjg3MmE5ODc5NjExNyAxMDA2NDQKPiA+IC0tLSBhL2RyaXZlcnMv
Z3B1L2RybS9yYWRlb24vcmFkZW9uX3R0bS5jCj4gPiArKysgYi9kcml2ZXJzL2dwdS9kcm0vcmFk
ZW9uL3JhZGVvbl90dG0uYwo+ID4gQEAgLTQ5Nyw5ICs0OTcsMTAgQEAgc3RhdGljIGludCByYWRl
b25fdHRtX3R0X3Bpbl91c2VycHRyKHN0cnVjdCB0dG1fdHQgKnR0bSkKPiA+ICAgICAgIGlmIChn
dHQtPnVzZXJmbGFncyAmIFJBREVPTl9HRU1fVVNFUlBUUl9BTk9OT05MWSkgewo+ID4gICAgICAg
ICAgICAgICAvKiBjaGVjayB0aGF0IHdlIG9ubHkgcGluIGRvd24gYW5vbnltb3VzIG1lbW9yeQo+
ID4gICAgICAgICAgICAgICAgICB0byBwcmV2ZW50IHByb2JsZW1zIHdpdGggd3JpdGViYWNrICov
Cj4gPiAtICAgICAgICAgICAgIHVuc2lnbmVkIGxvbmcgZW5kID0gZ3R0LT51c2VycHRyICsgdHRt
LT5udW1fcGFnZXMgKiBQQUdFX1NJWkU7Cj4gPiArICAgICAgICAgICAgIHVuc2lnbmVkIGxvbmcg
dXNlcnB0ciA9IHVudGFnZ2VkX2FkZHIoZ3R0LT51c2VycHRyKTsKPiA+ICsgICAgICAgICAgICAg
dW5zaWduZWQgbG9uZyBlbmQgPSB1c2VycHRyICsgdHRtLT5udW1fcGFnZXMgKiBQQUdFX1NJWkU7
Cj4gPiAgICAgICAgICAgICAgIHN0cnVjdCB2bV9hcmVhX3N0cnVjdCAqdm1hOwo+ID4gLSAgICAg
ICAgICAgICB2bWEgPSBmaW5kX3ZtYShndHQtPnVzZXJtbSwgZ3R0LT51c2VycHRyKTsKPiA+ICsg
ICAgICAgICAgICAgdm1hID0gZmluZF92bWEoZ3R0LT51c2VybW0sIHVzZXJwdHIpOwo+ID4gICAg
ICAgICAgICAgICBpZiAoIXZtYSB8fCB2bWEtPnZtX2ZpbGUgfHwgdm1hLT52bV9lbmQgPCBlbmQp
Cj4gPiAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIC1FUEVSTTsKPiA+ICAgICAgIH0KPgo+
IFNhbWUgY29tbWVudCBhcyBvbiB0aGUgcHJldmlvdXMgcGF0Y2guCgpBcyBLZXZpbiB3cm90ZSBp
biB0aGUgYW1kIGRyaXZlciByZWxhdGVkIHRocmVhZCwgdGhlIGNhbGwgdHJhY2UgaXM6CnJhZGVv
bl9nZW1fdXNlcnB0cl9pb2N0bCgpLT5yYWRlb25fdHRtX3R0X3NldF91c2VycHRyKCktPi4uLi0+
cmFkZW9uX3R0bV90dF9waW5fdXNlcnB0cigpLT5maW5kX3ZtYSgpCgo+Cj4gLS0KPiBDYXRhbGlu
Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmFtZC1nZngg
bWFpbGluZyBsaXN0CmFtZC1nZnhAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlzdHMu
ZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vYW1kLWdmeA==
