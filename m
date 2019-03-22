From: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v13 11/20] tracing, arm64: untag user pointers in
 seq_print_user_ip
Date: Fri, 22 Mar 2019 15:45:14 +0000
Message-ID: <20190322154513.GQ13384@arrakis.emea.arm.com>
References: <cover.1553093420.git.andreyknvl@google.com>
 <c9553c3a4850d43c8af0c00e97850d70428b7de7.1553093421.git.andreyknvl@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <c9553c3a4850d43c8af0c00e97850d70428b7de7.1553093421.git.andreyknvl-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
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

T24gV2VkLCBNYXIgMjAsIDIwMTkgYXQgMDM6NTE6MjVQTSArMDEwMCwgQW5kcmV5IEtvbm92YWxv
diB3cm90ZToKPiBUaGlzIHBhdGNoIGlzIGEgcGFydCBvZiBhIHNlcmllcyB0aGF0IGV4dGVuZHMg
YXJtNjQga2VybmVsIEFCSSB0byBhbGxvdyB0bwo+IHBhc3MgdGFnZ2VkIHVzZXIgcG9pbnRlcnMg
KHdpdGggdGhlIHRvcCBieXRlIHNldCB0byBzb21ldGhpbmcgZWxzZSBvdGhlcgo+IHRoYW4gMHgw
MCkgYXMgc3lzY2FsbCBhcmd1bWVudHMuCj4gCj4gc2VxX3ByaW50X3VzZXJfaXAoKSB1c2VzIHBy
b3ZpZGVkIHVzZXIgcG9pbnRlcnMgZm9yIHZtYSBsb29rdXBzLCB3aGljaAo+IGNhbiBvbmx5IGJ5
IGRvbmUgd2l0aCB1bnRhZ2dlZCBwb2ludGVycy4KPiAKPiBVbnRhZyB1c2VyIHBvaW50ZXJzIGlu
IHRoaXMgZnVuY3Rpb24uCj4gCj4gU2lnbmVkLW9mZi1ieTogQW5kcmV5IEtvbm92YWxvdiA8YW5k
cmV5a252bEBnb29nbGUuY29tPgo+IC0tLQo+ICBrZXJuZWwvdHJhY2UvdHJhY2Vfb3V0cHV0LmMg
fCA1ICsrKy0tCj4gIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25z
KC0pCj4gCj4gZGlmZiAtLWdpdCBhL2tlcm5lbC90cmFjZS90cmFjZV9vdXRwdXQuYyBiL2tlcm5l
bC90cmFjZS90cmFjZV9vdXRwdXQuYwo+IGluZGV4IDU0MzczZDkzZTI1MS4uNjM3NmJlZTkzYzg0
IDEwMDY0NAo+IC0tLSBhL2tlcm5lbC90cmFjZS90cmFjZV9vdXRwdXQuYwo+ICsrKyBiL2tlcm5l
bC90cmFjZS90cmFjZV9vdXRwdXQuYwo+IEBAIC0zNzAsNiArMzcwLDcgQEAgc3RhdGljIGludCBz
ZXFfcHJpbnRfdXNlcl9pcChzdHJ1Y3QgdHJhY2Vfc2VxICpzLCBzdHJ1Y3QgbW1fc3RydWN0ICpt
bSwKPiAgewo+ICAJc3RydWN0IGZpbGUgKmZpbGUgPSBOVUxMOwo+ICAJdW5zaWduZWQgbG9uZyB2
bXN0YXJ0ID0gMDsKPiArCXVuc2lnbmVkIGxvbmcgdW50YWdnZWRfaXAgPSB1bnRhZ2dlZF9hZGRy
KGlwKTsKPiAgCWludCByZXQgPSAxOwo+ICAKPiAgCWlmIChzLT5mdWxsKQo+IEBAIC0zNzksNyAr
MzgwLDcgQEAgc3RhdGljIGludCBzZXFfcHJpbnRfdXNlcl9pcChzdHJ1Y3QgdHJhY2Vfc2VxICpz
LCBzdHJ1Y3QgbW1fc3RydWN0ICptbSwKPiAgCQljb25zdCBzdHJ1Y3Qgdm1fYXJlYV9zdHJ1Y3Qg
KnZtYTsKPiAgCj4gIAkJZG93bl9yZWFkKCZtbS0+bW1hcF9zZW0pOwo+IC0JCXZtYSA9IGZpbmRf
dm1hKG1tLCBpcCk7Cj4gKwkJdm1hID0gZmluZF92bWEobW0sIHVudGFnZ2VkX2lwKTsKPiAgCQlp
ZiAodm1hKSB7Cj4gIAkJCWZpbGUgPSB2bWEtPnZtX2ZpbGU7Cj4gIAkJCXZtc3RhcnQgPSB2bWEt
PnZtX3N0YXJ0Owo+IEBAIC0zODgsNyArMzg5LDcgQEAgc3RhdGljIGludCBzZXFfcHJpbnRfdXNl
cl9pcChzdHJ1Y3QgdHJhY2Vfc2VxICpzLCBzdHJ1Y3QgbW1fc3RydWN0ICptbSwKPiAgCQkJcmV0
ID0gdHJhY2Vfc2VxX3BhdGgocywgJmZpbGUtPmZfcGF0aCk7Cj4gIAkJCWlmIChyZXQpCj4gIAkJ
CQl0cmFjZV9zZXFfcHJpbnRmKHMsICJbKzB4JWx4XSIsCj4gLQkJCQkJCSBpcCAtIHZtc3RhcnQp
Owo+ICsJCQkJCQkgdW50YWdnZWRfaXAgLSB2bXN0YXJ0KTsKPiAgCQl9Cj4gIAkJdXBfcmVhZCgm
bW0tPm1tYXBfc2VtKTsKPiAgCX0KCkhvdyB3b3VsZCB3ZSBlbmQgdXAgd2l0aCBhIHRhZ2dlZCBh
ZGRyZXNzIGhlcmU/IERvZXMgImlwIiBoZXJlIGltcGx5Cmluc3RydWN0aW9uIHBvaW50ZXIsIHdo
aWNoIHdlIHdvdWxkbid0IHRhZz8KCi0tIApDYXRhbGluCl9fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fCmFtZC1nZnggbWFpbGluZyBsaXN0CmFtZC1nZnhAbGlz
dHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4v
bGlzdGluZm8vYW1kLWdmeA==
