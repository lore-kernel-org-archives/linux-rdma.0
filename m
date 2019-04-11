From: Andrey Konovalov <andreyknvl-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v13 10/20] kernel,
 arm64: untag user pointers in prctl_set_mm*
Date: Thu, 11 Apr 2019 18:40:40 +0200
Message-ID: <CAAeHK+zeeTw7fpXoV6YYRyizGCL0d8pqDS=-z2pBoWmBzm+eTQ@mail.gmail.com>
References: <cover.1553093420.git.andreyknvl@google.com>
 <76f96eb9162b3a7fa5949d71af38bf8fdf6924c4.1553093421.git.andreyknvl@google.com>
 <20190322154136.GP13384@arrakis.emea.arm.com>
 <CAAeHK+yHp27eT+wTE3Uy4DkN8XN3ZjHATE+=HgjgRjrHjiXs3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
In-Reply-To: <CAAeHK+yHp27eT+wTE3Uy4DkN8XN3ZjHATE+=HgjgRjrHjiXs3Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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

T24gTW9uLCBBcHIgMSwgMjAxOSBhdCA2OjQ0IFBNIEFuZHJleSBLb25vdmFsb3YgPGFuZHJleWtu
dmxAZ29vZ2xlLmNvbT4gd3JvdGU6Cj4KPiBPbiBGcmksIE1hciAyMiwgMjAxOSBhdCA0OjQxIFBN
IENhdGFsaW4gTWFyaW5hcyA8Y2F0YWxpbi5tYXJpbmFzQGFybS5jb20+IHdyb3RlOgo+ID4KPiA+
IE9uIFdlZCwgTWFyIDIwLCAyMDE5IGF0IDAzOjUxOjI0UE0gKzAxMDAsIEFuZHJleSBLb25vdmFs
b3Ygd3JvdGU6Cj4gPiA+IEBAIC0yMTIwLDEzICsyMTM1LDE0IEBAIHN0YXRpYyBpbnQgcHJjdGxf
c2V0X21tKGludCBvcHQsIHVuc2lnbmVkIGxvbmcgYWRkciwKPiA+ID4gICAgICAgaWYgKG9wdCA9
PSBQUl9TRVRfTU1fQVVYVikKPiA+ID4gICAgICAgICAgICAgICByZXR1cm4gcHJjdGxfc2V0X2F1
eHYobW0sIGFkZHIsIGFyZzQpOwo+ID4gPgo+ID4gPiAtICAgICBpZiAoYWRkciA+PSBUQVNLX1NJ
WkUgfHwgYWRkciA8IG1tYXBfbWluX2FkZHIpCj4gPiA+ICsgICAgIGlmICh1bnRhZ2dlZF9hZGRy
KGFkZHIpID49IFRBU0tfU0laRSB8fAo+ID4gPiArICAgICAgICAgICAgICAgICAgICAgdW50YWdn
ZWRfYWRkcihhZGRyKSA8IG1tYXBfbWluX2FkZHIpCj4gPiA+ICAgICAgICAgICAgICAgcmV0dXJu
IC1FSU5WQUw7Cj4gPiA+Cj4gPiA+ICAgICAgIGVycm9yID0gLUVJTlZBTDsKPiA+ID4KPiA+ID4g
ICAgICAgZG93bl93cml0ZSgmbW0tPm1tYXBfc2VtKTsKPiA+ID4gLSAgICAgdm1hID0gZmluZF92
bWEobW0sIGFkZHIpOwo+ID4gPiArICAgICB2bWEgPSBmaW5kX3ZtYShtbSwgdW50YWdnZWRfYWRk
cihhZGRyKSk7Cj4gPiA+Cj4gPiA+ICAgICAgIHByY3RsX21hcC5zdGFydF9jb2RlICAgID0gbW0t
PnN0YXJ0X2NvZGU7Cj4gPiA+ICAgICAgIHByY3RsX21hcC5lbmRfY29kZSAgICAgID0gbW0tPmVu
ZF9jb2RlOwo+ID4KPiA+IERvZXMgdGhpcyBtZWFuIHRoYXQgd2UgYXJlIGxlZnQgd2l0aCB0YWdn
ZWQgYWRkcmVzc2VzIGZvciB0aGUKPiA+IG1tLT5zdGFydF9jb2RlIGV0Yy4gdmFsdWVzPyBJIHJl
YWxseSBkb24ndCB0aGluayB3ZSBzaG91bGQgYWxsb3cgdGhpcywKPiA+IEknbSBub3Qgc3VyZSB3
aGF0IHRoZSBpbXBsaWNhdGlvbnMgYXJlIGluIG90aGVyIHBhcnRzIG9mIHRoZSBrZXJuZWwuCj4g
Pgo+ID4gQXJndWFibHksIHRoZXNlIGFyZSBub3QgZXZlbiBwb2ludGVyIHZhbHVlcyBidXQgc29t
ZSBhZGRyZXNzIHJhbmdlcy4gSQo+ID4ga25vdyB3ZSBkZWNpZGVkIHRvIHJlbGF4IHRoaXMgbm90
aW9uIGZvciBtbWFwL21wcm90ZWN0L21hZHZpc2UoKSBzaW5jZQo+ID4gdGhlIHVzZXIgZnVuY3Rp
b24gcHJvdG90eXBlcyB0YWtlIHBvaW50ZXIgYXMgYXJndW1lbnRzIGJ1dCBpdCBmZWVscyBsaWtl
Cj4gPiB3ZSBhcmUgb3ZlcmRvaW5nIGl0IGhlcmUgKHN0cnVjdCBwcmN0bF9tbV9tYXAgZG9lc24n
dCBldmVuIGhhdmUKPiA+IHBvaW50ZXJzKS4KPiA+Cj4gPiBXaGF0IGlzIHRoZSB1c2UtY2FzZSBm
b3IgYWxsb3dpbmcgdGFnZ2VkIGFkZHJlc3NlcyBoZXJlPyBDYW4gdXNlciBzcGFjZQo+ID4gaGFu
ZGxlIHVudGFnZ2luZz8KPgo+IEkgZG9uJ3Qga25vdyBhbnkgdXNlIGNhc2VzIGZvciB0aGlzLiBJ
IGRpZCBpdCBiZWNhdXNlIGl0IHNlZW1zIHRvIGJlCj4gY292ZXJlZCBieSB0aGUgcmVsYXhlZCBB
QkkuIEknbSBub3QgZW50aXJlbHkgc3VyZSB3aGF0IHRvIGRvIGhlcmUsCj4gc2hvdWxkIEkganVz
dCBkcm9wIHRoaXMgcGF0Y2g/CgpwaW5nCgo+Cj4gPgo+ID4gLS0KPiA+IENhdGFsaW4KX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KYW1kLWdmeCBtYWlsaW5n
IGxpc3QKYW1kLWdmeEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVz
a3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9hbWQtZ2Z4
