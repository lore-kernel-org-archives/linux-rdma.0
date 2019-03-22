From: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v13 18/20] tee/optee, arm64: untag user pointers in
 check_mem_type
Date: Fri, 22 Mar 2019 16:22:23 +0000
Message-ID: <20190322162223.GW13384@arrakis.emea.arm.com>
References: <cover.1553093420.git.andreyknvl@google.com>
 <665632a911273ab537ded9acb78f4bafd91cbc19.1553093421.git.andreyknvl@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <665632a911273ab537ded9acb78f4bafd91cbc19.1553093421.git.andreyknvl-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
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

T24gV2VkLCBNYXIgMjAsIDIwMTkgYXQgMDM6NTE6MzJQTSArMDEwMCwgQW5kcmV5IEtvbm92YWxv
diB3cm90ZToKPiBUaGlzIHBhdGNoIGlzIGEgcGFydCBvZiBhIHNlcmllcyB0aGF0IGV4dGVuZHMg
YXJtNjQga2VybmVsIEFCSSB0byBhbGxvdyB0bwo+IHBhc3MgdGFnZ2VkIHVzZXIgcG9pbnRlcnMg
KHdpdGggdGhlIHRvcCBieXRlIHNldCB0byBzb21ldGhpbmcgZWxzZSBvdGhlcgo+IHRoYW4gMHgw
MCkgYXMgc3lzY2FsbCBhcmd1bWVudHMuCj4gCj4gY2hlY2tfbWVtX3R5cGUoKSB1c2VzIHByb3Zp
ZGVkIHVzZXIgcG9pbnRlcnMgZm9yIHZtYSBsb29rdXBzICh2aWEKPiBfX2NoZWNrX21lbV90eXBl
KCkpLCB3aGljaCBjYW4gb25seSBieSBkb25lIHdpdGggdW50YWdnZWQgcG9pbnRlcnMuCj4gCj4g
VW50YWcgdXNlciBwb2ludGVycyBpbiB0aGlzIGZ1bmN0aW9uLgo+IAo+IFNpZ25lZC1vZmYtYnk6
IEFuZHJleSBLb25vdmFsb3YgPGFuZHJleWtudmxAZ29vZ2xlLmNvbT4KPiAtLS0KPiAgZHJpdmVy
cy90ZWUvb3B0ZWUvY2FsbC5jIHwgMSArCj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigr
KQo+IAo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3RlZS9vcHRlZS9jYWxsLmMgYi9kcml2ZXJzL3Rl
ZS9vcHRlZS9jYWxsLmMKPiBpbmRleCBhNWFmYmU2ZGVlNjguLmUzYmUyMDI2NDA5MiAxMDA2NDQK
PiAtLS0gYS9kcml2ZXJzL3RlZS9vcHRlZS9jYWxsLmMKPiArKysgYi9kcml2ZXJzL3RlZS9vcHRl
ZS9jYWxsLmMKPiBAQCAtNTYzLDYgKzU2Myw3IEBAIHN0YXRpYyBpbnQgY2hlY2tfbWVtX3R5cGUo
dW5zaWduZWQgbG9uZyBzdGFydCwgc2l6ZV90IG51bV9wYWdlcykKPiAgCWludCByYzsKPiAgCj4g
IAlkb3duX3JlYWQoJm1tLT5tbWFwX3NlbSk7Cj4gKwlzdGFydCA9IHVudGFnZ2VkX2FkZHIoc3Rh
cnQpOwo+ICAJcmMgPSBfX2NoZWNrX21lbV90eXBlKGZpbmRfdm1hKG1tLCBzdGFydCksCj4gIAkJ
CSAgICAgIHN0YXJ0ICsgbnVtX3BhZ2VzICogUEFHRV9TSVpFKTsKPiAgCXVwX3JlYWQoJm1tLT5t
bWFwX3NlbSk7CgpJIGd1ZXNzIHdlIGNvdWxkIGp1c3QgdW50YWcgdGhpcyBpbiB0ZWVfc2htX3Jl
Z2lzdGVyKCkuIFRoZSB0YWcgaXMgbm90CnJlbGV2YW50IHRvIGEgVEVFIGltcGxlbWVudGF0aW9u
IChmaXJtd2FyZSkgYW55d2F5LgoKLS0gCkNhdGFsaW4KX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX18KYW1kLWdmeCBtYWlsaW5nIGxpc3QKYW1kLWdmeEBsaXN0
cy5mcmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9s
aXN0aW5mby9hbWQtZ2Z4
