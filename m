From: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v13 15/20] drm/radeon, arm64: untag user pointers in
 radeon_ttm_tt_pin_userptr
Date: Fri, 22 Mar 2019 16:00:57 +0000
Message-ID: <20190322160057.GU13384@arrakis.emea.arm.com>
References: <cover.1553093420.git.andreyknvl@google.com>
 <038360a0a9dc0abaaaf3ad84a2d07fd544abce1a.1553093421.git.andreyknvl@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <038360a0a9dc0abaaaf3ad84a2d07fd544abce1a.1553093421.git.andreyknvl-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/amd-gfx>
List-Post: <mailto:amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
List-Help: <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=subscribe>
Errors-To: amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Sender: "amd-gfx" <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
To: Andrey Konovalov <andreyknvl-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Kate Stewart <kstewart-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chintan Pandya <cpandya-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Vincenzo Frascino <vincenzo.frascino-5wv7dgnIgG8@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "David (ChunMing) Zhou" <David1.Zhou-5C7GfCeVMHo@public.gmane.org>, Jacob Bramley <Jacob.Bramley-5wv7dgnIgG8@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Szabolcs Nagy <Szabolcs.Nagy-5wv7dgnIgG8@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ramana Radhakrishnan <Ramana.Radhakrishnan-5wv7dgnIgG8@public.gmane.org>, Dave Martin <Dave.Ma>
List-Id: linux-rdma@vger.kernel.org

T24gV2VkLCBNYXIgMjAsIDIwMTkgYXQgMDM6NTE6MjlQTSArMDEwMCwgQW5kcmV5IEtvbm92YWxv
diB3cm90ZToKPiBUaGlzIHBhdGNoIGlzIGEgcGFydCBvZiBhIHNlcmllcyB0aGF0IGV4dGVuZHMg
YXJtNjQga2VybmVsIEFCSSB0byBhbGxvdyB0bwo+IHBhc3MgdGFnZ2VkIHVzZXIgcG9pbnRlcnMg
KHdpdGggdGhlIHRvcCBieXRlIHNldCB0byBzb21ldGhpbmcgZWxzZSBvdGhlcgo+IHRoYW4gMHgw
MCkgYXMgc3lzY2FsbCBhcmd1bWVudHMuCj4gCj4gcmFkZW9uX3R0bV90dF9waW5fdXNlcnB0cigp
IHVzZXMgcHJvdmlkZWQgdXNlciBwb2ludGVycyBmb3Igdm1hCj4gbG9va3Vwcywgd2hpY2ggY2Fu
IG9ubHkgYnkgZG9uZSB3aXRoIHVudGFnZ2VkIHBvaW50ZXJzLgo+IAo+IFVudGFnIHVzZXIgcG9p
bnRlcnMgaW4gdGhpcyBmdW5jdGlvbi4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBBbmRyZXkgS29ub3Zh
bG92IDxhbmRyZXlrbnZsQGdvb2dsZS5jb20+Cj4gLS0tCj4gIGRyaXZlcnMvZ3B1L2RybS9yYWRl
b24vcmFkZW9uX3R0bS5jIHwgNSArKystLQo+ICAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25z
KCspLCAyIGRlbGV0aW9ucygtKQo+IAo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9kcm0vcmFk
ZW9uL3JhZGVvbl90dG0uYyBiL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcmFkZW9uX3R0bS5jCj4g
aW5kZXggOTkyMGE2ZmMxMWJmLi44NzJhOTg3OTYxMTcgMTAwNjQ0Cj4gLS0tIGEvZHJpdmVycy9n
cHUvZHJtL3JhZGVvbi9yYWRlb25fdHRtLmMKPiArKysgYi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9u
L3JhZGVvbl90dG0uYwo+IEBAIC00OTcsOSArNDk3LDEwIEBAIHN0YXRpYyBpbnQgcmFkZW9uX3R0
bV90dF9waW5fdXNlcnB0cihzdHJ1Y3QgdHRtX3R0ICp0dG0pCj4gIAlpZiAoZ3R0LT51c2VyZmxh
Z3MgJiBSQURFT05fR0VNX1VTRVJQVFJfQU5PTk9OTFkpIHsKPiAgCQkvKiBjaGVjayB0aGF0IHdl
IG9ubHkgcGluIGRvd24gYW5vbnltb3VzIG1lbW9yeQo+ICAJCSAgIHRvIHByZXZlbnQgcHJvYmxl
bXMgd2l0aCB3cml0ZWJhY2sgKi8KPiAtCQl1bnNpZ25lZCBsb25nIGVuZCA9IGd0dC0+dXNlcnB0
ciArIHR0bS0+bnVtX3BhZ2VzICogUEFHRV9TSVpFOwo+ICsJCXVuc2lnbmVkIGxvbmcgdXNlcnB0
ciA9IHVudGFnZ2VkX2FkZHIoZ3R0LT51c2VycHRyKTsKPiArCQl1bnNpZ25lZCBsb25nIGVuZCA9
IHVzZXJwdHIgKyB0dG0tPm51bV9wYWdlcyAqIFBBR0VfU0laRTsKPiAgCQlzdHJ1Y3Qgdm1fYXJl
YV9zdHJ1Y3QgKnZtYTsKPiAtCQl2bWEgPSBmaW5kX3ZtYShndHQtPnVzZXJtbSwgZ3R0LT51c2Vy
cHRyKTsKPiArCQl2bWEgPSBmaW5kX3ZtYShndHQtPnVzZXJtbSwgdXNlcnB0cik7Cj4gIAkJaWYg
KCF2bWEgfHwgdm1hLT52bV9maWxlIHx8IHZtYS0+dm1fZW5kIDwgZW5kKQo+ICAJCQlyZXR1cm4g
LUVQRVJNOwo+ICAJfQoKU2FtZSBjb21tZW50IGFzIG9uIHRoZSBwcmV2aW91cyBwYXRjaC4KCi0t
IApDYXRhbGluCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
CmFtZC1nZnggbWFpbGluZyBsaXN0CmFtZC1nZnhAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBz
Oi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vYW1kLWdmeA==
