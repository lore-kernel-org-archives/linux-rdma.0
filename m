From: Andrey Konovalov <andreyknvl-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v13 10/20] kernel,
 arm64: untag user pointers in prctl_set_mm*
Date: Mon, 1 Apr 2019 18:44:34 +0200
Message-ID: <CAAeHK+yHp27eT+wTE3Uy4DkN8XN3ZjHATE+=HgjgRjrHjiXs3Q@mail.gmail.com>
References: <cover.1553093420.git.andreyknvl@google.com>
 <76f96eb9162b3a7fa5949d71af38bf8fdf6924c4.1553093421.git.andreyknvl@google.com>
 <20190322154136.GP13384@arrakis.emea.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
In-Reply-To: <20190322154136.GP13384-pQd4kjVL+RGcEQQL7YIRtlaTQe2KTcn/@public.gmane.org>
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

T24gRnJpLCBNYXIgMjIsIDIwMTkgYXQgNDo0MSBQTSBDYXRhbGluIE1hcmluYXMgPGNhdGFsaW4u
bWFyaW5hc0Bhcm0uY29tPiB3cm90ZToKPgo+IE9uIFdlZCwgTWFyIDIwLCAyMDE5IGF0IDAzOjUx
OjI0UE0gKzAxMDAsIEFuZHJleSBLb25vdmFsb3Ygd3JvdGU6Cj4gPiBAQCAtMjEyMCwxMyArMjEz
NSwxNCBAQCBzdGF0aWMgaW50IHByY3RsX3NldF9tbShpbnQgb3B0LCB1bnNpZ25lZCBsb25nIGFk
ZHIsCj4gPiAgICAgICBpZiAob3B0ID09IFBSX1NFVF9NTV9BVVhWKQo+ID4gICAgICAgICAgICAg
ICByZXR1cm4gcHJjdGxfc2V0X2F1eHYobW0sIGFkZHIsIGFyZzQpOwo+ID4KPiA+IC0gICAgIGlm
IChhZGRyID49IFRBU0tfU0laRSB8fCBhZGRyIDwgbW1hcF9taW5fYWRkcikKPiA+ICsgICAgIGlm
ICh1bnRhZ2dlZF9hZGRyKGFkZHIpID49IFRBU0tfU0laRSB8fAo+ID4gKyAgICAgICAgICAgICAg
ICAgICAgIHVudGFnZ2VkX2FkZHIoYWRkcikgPCBtbWFwX21pbl9hZGRyKQo+ID4gICAgICAgICAg
ICAgICByZXR1cm4gLUVJTlZBTDsKPiA+Cj4gPiAgICAgICBlcnJvciA9IC1FSU5WQUw7Cj4gPgo+
ID4gICAgICAgZG93bl93cml0ZSgmbW0tPm1tYXBfc2VtKTsKPiA+IC0gICAgIHZtYSA9IGZpbmRf
dm1hKG1tLCBhZGRyKTsKPiA+ICsgICAgIHZtYSA9IGZpbmRfdm1hKG1tLCB1bnRhZ2dlZF9hZGRy
KGFkZHIpKTsKPiA+Cj4gPiAgICAgICBwcmN0bF9tYXAuc3RhcnRfY29kZSAgICA9IG1tLT5zdGFy
dF9jb2RlOwo+ID4gICAgICAgcHJjdGxfbWFwLmVuZF9jb2RlICAgICAgPSBtbS0+ZW5kX2NvZGU7
Cj4KPiBEb2VzIHRoaXMgbWVhbiB0aGF0IHdlIGFyZSBsZWZ0IHdpdGggdGFnZ2VkIGFkZHJlc3Nl
cyBmb3IgdGhlCj4gbW0tPnN0YXJ0X2NvZGUgZXRjLiB2YWx1ZXM/IEkgcmVhbGx5IGRvbid0IHRo
aW5rIHdlIHNob3VsZCBhbGxvdyB0aGlzLAo+IEknbSBub3Qgc3VyZSB3aGF0IHRoZSBpbXBsaWNh
dGlvbnMgYXJlIGluIG90aGVyIHBhcnRzIG9mIHRoZSBrZXJuZWwuCj4KPiBBcmd1YWJseSwgdGhl
c2UgYXJlIG5vdCBldmVuIHBvaW50ZXIgdmFsdWVzIGJ1dCBzb21lIGFkZHJlc3MgcmFuZ2VzLiBJ
Cj4ga25vdyB3ZSBkZWNpZGVkIHRvIHJlbGF4IHRoaXMgbm90aW9uIGZvciBtbWFwL21wcm90ZWN0
L21hZHZpc2UoKSBzaW5jZQo+IHRoZSB1c2VyIGZ1bmN0aW9uIHByb3RvdHlwZXMgdGFrZSBwb2lu
dGVyIGFzIGFyZ3VtZW50cyBidXQgaXQgZmVlbHMgbGlrZQo+IHdlIGFyZSBvdmVyZG9pbmcgaXQg
aGVyZSAoc3RydWN0IHByY3RsX21tX21hcCBkb2Vzbid0IGV2ZW4gaGF2ZQo+IHBvaW50ZXJzKS4K
Pgo+IFdoYXQgaXMgdGhlIHVzZS1jYXNlIGZvciBhbGxvd2luZyB0YWdnZWQgYWRkcmVzc2VzIGhl
cmU/IENhbiB1c2VyIHNwYWNlCj4gaGFuZGxlIHVudGFnZ2luZz8KCkkgZG9uJ3Qga25vdyBhbnkg
dXNlIGNhc2VzIGZvciB0aGlzLiBJIGRpZCBpdCBiZWNhdXNlIGl0IHNlZW1zIHRvIGJlCmNvdmVy
ZWQgYnkgdGhlIHJlbGF4ZWQgQUJJLiBJJ20gbm90IGVudGlyZWx5IHN1cmUgd2hhdCB0byBkbyBo
ZXJlLApzaG91bGQgSSBqdXN0IGRyb3AgdGhpcyBwYXRjaD8KCj4KPiAtLQo+IENhdGFsaW4KX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KYW1kLWdmeCBtYWls
aW5nIGxpc3QKYW1kLWdmeEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVl
ZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9hbWQtZ2Z4
