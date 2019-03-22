From: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v13 14/20] drm/amdgpu, arm64: untag user pointers in
 amdgpu_ttm_tt_get_user_pages
Date: Fri, 22 Mar 2019 15:59:55 +0000
Message-ID: <20190322155955.GT13384@arrakis.emea.arm.com>
References: <cover.1553093420.git.andreyknvl@google.com>
 <017804b2198a906463d634f84777b6087c9b4a40.1553093421.git.andreyknvl@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <017804b2198a906463d634f84777b6087c9b4a40.1553093421.git.andreyknvl-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
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

T24gV2VkLCBNYXIgMjAsIDIwMTkgYXQgMDM6NTE6MjhQTSArMDEwMCwgQW5kcmV5IEtvbm92YWxv
diB3cm90ZToKPiBUaGlzIHBhdGNoIGlzIGEgcGFydCBvZiBhIHNlcmllcyB0aGF0IGV4dGVuZHMg
YXJtNjQga2VybmVsIEFCSSB0byBhbGxvdyB0bwo+IHBhc3MgdGFnZ2VkIHVzZXIgcG9pbnRlcnMg
KHdpdGggdGhlIHRvcCBieXRlIHNldCB0byBzb21ldGhpbmcgZWxzZSBvdGhlcgo+IHRoYW4gMHgw
MCkgYXMgc3lzY2FsbCBhcmd1bWVudHMuCj4gCj4gYW1kZ3B1X3R0bV90dF9nZXRfdXNlcl9wYWdl
cygpIHVzZXMgcHJvdmlkZWQgdXNlciBwb2ludGVycyBmb3Igdm1hCj4gbG9va3Vwcywgd2hpY2gg
Y2FuIG9ubHkgYnkgZG9uZSB3aXRoIHVudGFnZ2VkIHBvaW50ZXJzLgo+IAo+IFVudGFnIHVzZXIg
cG9pbnRlcnMgaW4gdGhpcyBmdW5jdGlvbi4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBBbmRyZXkgS29u
b3ZhbG92IDxhbmRyZXlrbnZsQGdvb2dsZS5jb20+Cj4gLS0tCj4gIGRyaXZlcnMvZ3B1L2RybS9h
bWQvYW1kZ3B1L2FtZGdwdV90dG0uYyB8IDUgKysrLS0KPiAgMSBmaWxlIGNoYW5nZWQsIDMgaW5z
ZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKPiAKPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUv
ZHJtL2FtZC9hbWRncHUvYW1kZ3B1X3R0bS5jIGIvZHJpdmVycy9ncHUvZHJtL2FtZC9hbWRncHUv
YW1kZ3B1X3R0bS5jCj4gaW5kZXggNzNlNzFlNjFkYzk5Li44OTFiMDI3ZmEzM2IgMTAwNjQ0Cj4g
LS0tIGEvZHJpdmVycy9ncHUvZHJtL2FtZC9hbWRncHUvYW1kZ3B1X3R0bS5jCj4gKysrIGIvZHJp
dmVycy9ncHUvZHJtL2FtZC9hbWRncHUvYW1kZ3B1X3R0bS5jCj4gQEAgLTc1MSwxMCArNzUxLDEx
IEBAIGludCBhbWRncHVfdHRtX3R0X2dldF91c2VyX3BhZ2VzKHN0cnVjdCB0dG1fdHQgKnR0bSwg
c3RydWN0IHBhZ2UgKipwYWdlcykKPiAgCQkgKiBjaGVjayB0aGF0IHdlIG9ubHkgdXNlIGFub255
bW91cyBtZW1vcnkgdG8gcHJldmVudCBwcm9ibGVtcwo+ICAJCSAqIHdpdGggd3JpdGViYWNrCj4g
IAkJICovCj4gLQkJdW5zaWduZWQgbG9uZyBlbmQgPSBndHQtPnVzZXJwdHIgKyB0dG0tPm51bV9w
YWdlcyAqIFBBR0VfU0laRTsKPiArCQl1bnNpZ25lZCBsb25nIHVzZXJwdHIgPSB1bnRhZ2dlZF9h
ZGRyKGd0dC0+dXNlcnB0cik7Cj4gKwkJdW5zaWduZWQgbG9uZyBlbmQgPSB1c2VycHRyICsgdHRt
LT5udW1fcGFnZXMgKiBQQUdFX1NJWkU7Cj4gIAkJc3RydWN0IHZtX2FyZWFfc3RydWN0ICp2bWE7
Cj4gIAo+IC0JCXZtYSA9IGZpbmRfdm1hKG1tLCBndHQtPnVzZXJwdHIpOwo+ICsJCXZtYSA9IGZp
bmRfdm1hKG1tLCB1c2VycHRyKTsKPiAgCQlpZiAoIXZtYSB8fCB2bWEtPnZtX2ZpbGUgfHwgdm1h
LT52bV9lbmQgPCBlbmQpIHsKPiAgCQkJdXBfcmVhZCgmbW0tPm1tYXBfc2VtKTsKPiAgCQkJcmV0
dXJuIC1FUEVSTTsKCkkgdHJpZWQgdG8gdHJhY2sgdGhpcyBkb3duIGJ1dCBJIGZhaWxlZCB0byBz
ZWUgd2hldGhlciB1c2VyIGNvdWxkCnByb3ZpZGUgYW4gdGFnZ2VkIHBvaW50ZXIgaGVyZSAodW5k
ZXIgdGhlIHJlc3RyaWN0aW9ucyBhcyBwZXIgVmluY2Vuem8ncwpBQkkgZG9jdW1lbnQpLgoKLS0g
CkNhdGFsaW4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18K
YW1kLWdmeCBtYWlsaW5nIGxpc3QKYW1kLWdmeEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0cHM6
Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9hbWQtZ2Z4
