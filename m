From: Andrey Konovalov <andreyknvl-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v13 18/20] tee/optee,
 arm64: untag user pointers in check_mem_type
Date: Mon, 1 Apr 2019 18:31:02 +0200
Message-ID: <CAAeHK+xjCUqpyOuR_G=SQe2GURJTyZjEueYoKRBA+hbZeAFyvw@mail.gmail.com>
References: <cover.1553093420.git.andreyknvl@google.com>
 <665632a911273ab537ded9acb78f4bafd91cbc19.1553093421.git.andreyknvl@google.com>
 <20190322162223.GW13384@arrakis.emea.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
In-Reply-To: <20190322162223.GW13384-pQd4kjVL+RGcEQQL7YIRtlaTQe2KTcn/@public.gmane.org>
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

T24gRnJpLCBNYXIgMjIsIDIwMTkgYXQgNToyMiBQTSBDYXRhbGluIE1hcmluYXMgPGNhdGFsaW4u
bWFyaW5hc0Bhcm0uY29tPiB3cm90ZToKPgo+IE9uIFdlZCwgTWFyIDIwLCAyMDE5IGF0IDAzOjUx
OjMyUE0gKzAxMDAsIEFuZHJleSBLb25vdmFsb3Ygd3JvdGU6Cj4gPiBUaGlzIHBhdGNoIGlzIGEg
cGFydCBvZiBhIHNlcmllcyB0aGF0IGV4dGVuZHMgYXJtNjQga2VybmVsIEFCSSB0byBhbGxvdyB0
bwo+ID4gcGFzcyB0YWdnZWQgdXNlciBwb2ludGVycyAod2l0aCB0aGUgdG9wIGJ5dGUgc2V0IHRv
IHNvbWV0aGluZyBlbHNlIG90aGVyCj4gPiB0aGFuIDB4MDApIGFzIHN5c2NhbGwgYXJndW1lbnRz
Lgo+ID4KPiA+IGNoZWNrX21lbV90eXBlKCkgdXNlcyBwcm92aWRlZCB1c2VyIHBvaW50ZXJzIGZv
ciB2bWEgbG9va3VwcyAodmlhCj4gPiBfX2NoZWNrX21lbV90eXBlKCkpLCB3aGljaCBjYW4gb25s
eSBieSBkb25lIHdpdGggdW50YWdnZWQgcG9pbnRlcnMuCj4gPgo+ID4gVW50YWcgdXNlciBwb2lu
dGVycyBpbiB0aGlzIGZ1bmN0aW9uLgo+ID4KPiA+IFNpZ25lZC1vZmYtYnk6IEFuZHJleSBLb25v
dmFsb3YgPGFuZHJleWtudmxAZ29vZ2xlLmNvbT4KPiA+IC0tLQo+ID4gIGRyaXZlcnMvdGVlL29w
dGVlL2NhbGwuYyB8IDEgKwo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKQo+ID4K
PiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3RlZS9vcHRlZS9jYWxsLmMgYi9kcml2ZXJzL3RlZS9v
cHRlZS9jYWxsLmMKPiA+IGluZGV4IGE1YWZiZTZkZWU2OC4uZTNiZTIwMjY0MDkyIDEwMDY0NAo+
ID4gLS0tIGEvZHJpdmVycy90ZWUvb3B0ZWUvY2FsbC5jCj4gPiArKysgYi9kcml2ZXJzL3RlZS9v
cHRlZS9jYWxsLmMKPiA+IEBAIC01NjMsNiArNTYzLDcgQEAgc3RhdGljIGludCBjaGVja19tZW1f
dHlwZSh1bnNpZ25lZCBsb25nIHN0YXJ0LCBzaXplX3QgbnVtX3BhZ2VzKQo+ID4gICAgICAgaW50
IHJjOwo+ID4KPiA+ICAgICAgIGRvd25fcmVhZCgmbW0tPm1tYXBfc2VtKTsKPiA+ICsgICAgIHN0
YXJ0ID0gdW50YWdnZWRfYWRkcihzdGFydCk7Cj4gPiAgICAgICByYyA9IF9fY2hlY2tfbWVtX3R5
cGUoZmluZF92bWEobW0sIHN0YXJ0KSwKPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICBz
dGFydCArIG51bV9wYWdlcyAqIFBBR0VfU0laRSk7Cj4gPiAgICAgICB1cF9yZWFkKCZtbS0+bW1h
cF9zZW0pOwo+Cj4gSSBndWVzcyB3ZSBjb3VsZCBqdXN0IHVudGFnIHRoaXMgaW4gdGVlX3NobV9y
ZWdpc3RlcigpLiBUaGUgdGFnIGlzIG5vdAo+IHJlbGV2YW50IHRvIGEgVEVFIGltcGxlbWVudGF0
aW9uIChmaXJtd2FyZSkgYW55d2F5LgoKV2lsbCBkbyBpbiB2MTQsIHRoYW5rcyEKCj4KPiAtLQo+
IENhdGFsaW4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18K
YW1kLWdmeCBtYWlsaW5nIGxpc3QKYW1kLWdmeEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0cHM6
Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9hbWQtZ2Z4
