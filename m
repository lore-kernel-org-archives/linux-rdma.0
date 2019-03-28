From: Andrey Konovalov <andreyknvl-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v13 04/20] mm,
 arm64: untag user pointers passed to memory syscalls
Date: Thu, 28 Mar 2019 19:10:07 +0100
Message-ID: <CAAeHK+xE-ywfpVHRhBJVGiqOe0+BYW9awUa10ZP4P6Ggc8nxMg@mail.gmail.com>
References: <cover.1553093420.git.andreyknvl@google.com>
 <44ad2d0c55dbad449edac23ae46d151a04102a1d.1553093421.git.andreyknvl@google.com>
 <20190322114357.GC13384@arrakis.emea.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
In-Reply-To: <20190322114357.GC13384-pQd4kjVL+RGcEQQL7YIRtlaTQe2KTcn/@public.gmane.org>
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

T24gRnJpLCBNYXIgMjIsIDIwMTkgYXQgMTI6NDQgUE0gQ2F0YWxpbiBNYXJpbmFzCjxjYXRhbGlu
Lm1hcmluYXNAYXJtLmNvbT4gd3JvdGU6Cj4KPiBPbiBXZWQsIE1hciAyMCwgMjAxOSBhdCAwMzo1
MToxOFBNICswMTAwLCBBbmRyZXkgS29ub3ZhbG92IHdyb3RlOgo+ID4gVGhpcyBwYXRjaCBpcyBh
IHBhcnQgb2YgYSBzZXJpZXMgdGhhdCBleHRlbmRzIGFybTY0IGtlcm5lbCBBQkkgdG8gYWxsb3cg
dG8KPiA+IHBhc3MgdGFnZ2VkIHVzZXIgcG9pbnRlcnMgKHdpdGggdGhlIHRvcCBieXRlIHNldCB0
byBzb21ldGhpbmcgZWxzZSBvdGhlcgo+ID4gdGhhbiAweDAwKSBhcyBzeXNjYWxsIGFyZ3VtZW50
cy4KPiA+Cj4gPiBUaGlzIHBhdGNoIGFsbG93cyB0YWdnZWQgcG9pbnRlcnMgdG8gYmUgcGFzc2Vk
IHRvIHRoZSBmb2xsb3dpbmcgbWVtb3J5Cj4gPiBzeXNjYWxsczogbWFkdmlzZSwgbWJpbmQsIGdl
dF9tZW1wb2xpY3ksIG1pbmNvcmUsIG1sb2NrLCBtbG9jazIsIGJyaywKPiA+IG1tYXBfcGdvZmYs
IG9sZF9tbWFwLCBtdW5tYXAsIHJlbWFwX2ZpbGVfcGFnZXMsIG1wcm90ZWN0LCBwa2V5X21wcm90
ZWN0LAo+ID4gbXJlbWFwLCBtc3luYyBhbmQgc2htZHQuCj4gPgo+ID4gVGhpcyBpcyBkb25lIGJ5
IHVudGFnZ2luZyBwb2ludGVycyBwYXNzZWQgdG8gdGhlc2Ugc3lzY2FsbHMgaW4gdGhlCj4gPiBw
cm9sb2d1ZXMgb2YgdGhlaXIgaGFuZGxlcnMuCj4gPgo+ID4gU2lnbmVkLW9mZi1ieTogQW5kcmV5
IEtvbm92YWxvdiA8YW5kcmV5a252bEBnb29nbGUuY29tPgo+ID4gLS0tCj4gPiAgaXBjL3NobS5j
ICAgICAgfCAyICsrCj4gPiAgbW0vbWFkdmlzZS5jICAgfCAyICsrCj4gPiAgbW0vbWVtcG9saWN5
LmMgfCA1ICsrKysrCj4gPiAgbW0vbWlncmF0ZS5jICAgfCAxICsKPiA+ICBtbS9taW5jb3JlLmMg
ICB8IDIgKysKPiA+ICBtbS9tbG9jay5jICAgICB8IDUgKysrKysKPiA+ICBtbS9tbWFwLmMgICAg
ICB8IDcgKysrKysrKwo+ID4gIG1tL21wcm90ZWN0LmMgIHwgMSArCj4gPiAgbW0vbXJlbWFwLmMg
ICAgfCAyICsrCj4gPiAgbW0vbXN5bmMuYyAgICAgfCAyICsrCj4gPiAgMTAgZmlsZXMgY2hhbmdl
ZCwgMjkgaW5zZXJ0aW9ucygrKQo+Cj4gSSB3b25kZXIgd2hldGhlciBpdCdzIGJldHRlciB0byBr
ZWVwIHRoZXNlIGFzIHdyYXBwZXJzIGluIHRoZSBhcm02NAo+IGNvZGUuCgpJIGRvbid0IHRoaW5r
IEkgdW5kZXJzdGFuZCB3aGF0IHlvdSBwcm9wb3NlLCBjb3VsZCB5b3UgZWxhYm9yYXRlPwpfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwphbWQtZ2Z4IG1haWxp
bmcgbGlzdAphbWQtZ2Z4QGxpc3RzLmZyZWVkZXNrdG9wLm9yZwpodHRwczovL2xpc3RzLmZyZWVk
ZXNrdG9wLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2FtZC1nZng=
