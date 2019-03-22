From: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v13 13/20] bpf, arm64: untag user pointers in
 stack_map_get_build_id_offset
Date: Fri, 22 Mar 2019 15:52:27 +0000
Message-ID: <20190322155227.GS13384@arrakis.emea.arm.com>
References: <cover.1553093420.git.andreyknvl@google.com>
 <09d6b8e5c8275de85c7aba716578fbcb3cbce924.1553093421.git.andreyknvl@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <09d6b8e5c8275de85c7aba716578fbcb3cbce924.1553093421.git.andreyknvl-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
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

T24gV2VkLCBNYXIgMjAsIDIwMTkgYXQgMDM6NTE6MjdQTSArMDEwMCwgQW5kcmV5IEtvbm92YWxv
diB3cm90ZToKPiBUaGlzIHBhdGNoIGlzIGEgcGFydCBvZiBhIHNlcmllcyB0aGF0IGV4dGVuZHMg
YXJtNjQga2VybmVsIEFCSSB0byBhbGxvdyB0bwo+IHBhc3MgdGFnZ2VkIHVzZXIgcG9pbnRlcnMg
KHdpdGggdGhlIHRvcCBieXRlIHNldCB0byBzb21ldGhpbmcgZWxzZSBvdGhlcgo+IHRoYW4gMHgw
MCkgYXMgc3lzY2FsbCBhcmd1bWVudHMuCj4gCj4gc3RhY2tfbWFwX2dldF9idWlsZF9pZF9vZmZz
ZXQoKSB1c2VzIHByb3ZpZGVkIHVzZXIgcG9pbnRlcnMgZm9yIHZtYQo+IGxvb2t1cHMsIHdoaWNo
IGNhbiBvbmx5IGJ5IGRvbmUgd2l0aCB1bnRhZ2dlZCBwb2ludGVycy4KPiAKPiBVbnRhZyB1c2Vy
IHBvaW50ZXJzIGluIHRoaXMgZnVuY3Rpb24gZm9yIGRvaW5nIHRoZSBsb29rdXAgYW5kCj4gY2Fs
Y3VsYXRpbmcgdGhlIG9mZnNldCwgYnV0IHNhdmUgYXMgaXMgaW4gdGhlIGJwZl9zdGFja19idWls
ZF9pZAo+IHN0cnVjdC4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBBbmRyZXkgS29ub3ZhbG92IDxhbmRy
ZXlrbnZsQGdvb2dsZS5jb20+Cj4gLS0tCj4gIGtlcm5lbC9icGYvc3RhY2ttYXAuYyB8IDYgKysr
Ky0tCj4gIDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCj4g
Cj4gZGlmZiAtLWdpdCBhL2tlcm5lbC9icGYvc3RhY2ttYXAuYyBiL2tlcm5lbC9icGYvc3RhY2tt
YXAuYwo+IGluZGV4IDk1MGFiMmYyODkyMi4uYmI4OTM0MWQzZmFmIDEwMDY0NAo+IC0tLSBhL2tl
cm5lbC9icGYvc3RhY2ttYXAuYwo+ICsrKyBiL2tlcm5lbC9icGYvc3RhY2ttYXAuYwo+IEBAIC0z
MjAsNyArMzIwLDkgQEAgc3RhdGljIHZvaWQgc3RhY2tfbWFwX2dldF9idWlsZF9pZF9vZmZzZXQo
c3RydWN0IGJwZl9zdGFja19idWlsZF9pZCAqaWRfb2ZmcywKPiAgCX0KPiAgCj4gIAlmb3IgKGkg
PSAwOyBpIDwgdHJhY2VfbnI7IGkrKykgewo+IC0JCXZtYSA9IGZpbmRfdm1hKGN1cnJlbnQtPm1t
LCBpcHNbaV0pOwo+ICsJCXU2NCB1bnRhZ2dlZF9pcCA9IHVudGFnZ2VkX2FkZHIoaXBzW2ldKTsK
PiArCj4gKwkJdm1hID0gZmluZF92bWEoY3VycmVudC0+bW0sIHVudGFnZ2VkX2lwKTsKPiAgCQlp
ZiAoIXZtYSB8fCBzdGFja19tYXBfZ2V0X2J1aWxkX2lkKHZtYSwgaWRfb2Zmc1tpXS5idWlsZF9p
ZCkpIHsKPiAgCQkJLyogcGVyIGVudHJ5IGZhbGwgYmFjayB0byBpcHMgKi8KPiAgCQkJaWRfb2Zm
c1tpXS5zdGF0dXMgPSBCUEZfU1RBQ0tfQlVJTERfSURfSVA7Cj4gQEAgLTMyOCw3ICszMzAsNyBA
QCBzdGF0aWMgdm9pZCBzdGFja19tYXBfZ2V0X2J1aWxkX2lkX29mZnNldChzdHJ1Y3QgYnBmX3N0
YWNrX2J1aWxkX2lkICppZF9vZmZzLAo+ICAJCQltZW1zZXQoaWRfb2Zmc1tpXS5idWlsZF9pZCwg
MCwgQlBGX0JVSUxEX0lEX1NJWkUpOwo+ICAJCQljb250aW51ZTsKPiAgCQl9Cj4gLQkJaWRfb2Zm
c1tpXS5vZmZzZXQgPSAodm1hLT52bV9wZ29mZiA8PCBQQUdFX1NISUZUKSArIGlwc1tpXQo+ICsJ
CWlkX29mZnNbaV0ub2Zmc2V0ID0gKHZtYS0+dm1fcGdvZmYgPDwgUEFHRV9TSElGVCkgKyB1bnRh
Z2dlZF9pcAo+ICAJCQktIHZtYS0+dm1fc3RhcnQ7Cj4gIAkJaWRfb2Zmc1tpXS5zdGF0dXMgPSBC
UEZfU1RBQ0tfQlVJTERfSURfVkFMSUQ7Cj4gIAl9CgpDYW4gdGhlIGlwc1sqXSBoZXJlIGV2ZXIg
YmUgdGFnZ2VkPwoKLS0gCkNhdGFsaW4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18KYW1kLWdmeCBtYWlsaW5nIGxpc3QKYW1kLWdmeEBsaXN0cy5mcmVlZGVz
a3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9h
bWQtZ2Z4
