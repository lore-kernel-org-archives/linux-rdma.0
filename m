From: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v13 10/20] kernel, arm64: untag user pointers in
 prctl_set_mm*
Date: Fri, 22 Mar 2019 15:41:37 +0000
Message-ID: <20190322154136.GP13384@arrakis.emea.arm.com>
References: <cover.1553093420.git.andreyknvl@google.com>
 <76f96eb9162b3a7fa5949d71af38bf8fdf6924c4.1553093421.git.andreyknvl@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <76f96eb9162b3a7fa5949d71af38bf8fdf6924c4.1553093421.git.andreyknvl-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
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

T24gV2VkLCBNYXIgMjAsIDIwMTkgYXQgMDM6NTE6MjRQTSArMDEwMCwgQW5kcmV5IEtvbm92YWxv
diB3cm90ZToKPiBAQCAtMjEyMCwxMyArMjEzNSwxNCBAQCBzdGF0aWMgaW50IHByY3RsX3NldF9t
bShpbnQgb3B0LCB1bnNpZ25lZCBsb25nIGFkZHIsCj4gIAlpZiAob3B0ID09IFBSX1NFVF9NTV9B
VVhWKQo+ICAJCXJldHVybiBwcmN0bF9zZXRfYXV4dihtbSwgYWRkciwgYXJnNCk7Cj4gIAo+IC0J
aWYgKGFkZHIgPj0gVEFTS19TSVpFIHx8IGFkZHIgPCBtbWFwX21pbl9hZGRyKQo+ICsJaWYgKHVu
dGFnZ2VkX2FkZHIoYWRkcikgPj0gVEFTS19TSVpFIHx8Cj4gKwkJCXVudGFnZ2VkX2FkZHIoYWRk
cikgPCBtbWFwX21pbl9hZGRyKQo+ICAJCXJldHVybiAtRUlOVkFMOwo+ICAKPiAgCWVycm9yID0g
LUVJTlZBTDsKPiAgCj4gIAlkb3duX3dyaXRlKCZtbS0+bW1hcF9zZW0pOwo+IC0Jdm1hID0gZmlu
ZF92bWEobW0sIGFkZHIpOwo+ICsJdm1hID0gZmluZF92bWEobW0sIHVudGFnZ2VkX2FkZHIoYWRk
cikpOwo+ICAKPiAgCXByY3RsX21hcC5zdGFydF9jb2RlCT0gbW0tPnN0YXJ0X2NvZGU7Cj4gIAlw
cmN0bF9tYXAuZW5kX2NvZGUJPSBtbS0+ZW5kX2NvZGU7CgpEb2VzIHRoaXMgbWVhbiB0aGF0IHdl
IGFyZSBsZWZ0IHdpdGggdGFnZ2VkIGFkZHJlc3NlcyBmb3IgdGhlCm1tLT5zdGFydF9jb2RlIGV0
Yy4gdmFsdWVzPyBJIHJlYWxseSBkb24ndCB0aGluayB3ZSBzaG91bGQgYWxsb3cgdGhpcywKSSdt
IG5vdCBzdXJlIHdoYXQgdGhlIGltcGxpY2F0aW9ucyBhcmUgaW4gb3RoZXIgcGFydHMgb2YgdGhl
IGtlcm5lbC4KCkFyZ3VhYmx5LCB0aGVzZSBhcmUgbm90IGV2ZW4gcG9pbnRlciB2YWx1ZXMgYnV0
IHNvbWUgYWRkcmVzcyByYW5nZXMuIEkKa25vdyB3ZSBkZWNpZGVkIHRvIHJlbGF4IHRoaXMgbm90
aW9uIGZvciBtbWFwL21wcm90ZWN0L21hZHZpc2UoKSBzaW5jZQp0aGUgdXNlciBmdW5jdGlvbiBw
cm90b3R5cGVzIHRha2UgcG9pbnRlciBhcyBhcmd1bWVudHMgYnV0IGl0IGZlZWxzIGxpa2UKd2Ug
YXJlIG92ZXJkb2luZyBpdCBoZXJlIChzdHJ1Y3QgcHJjdGxfbW1fbWFwIGRvZXNuJ3QgZXZlbiBo
YXZlCnBvaW50ZXJzKS4KCldoYXQgaXMgdGhlIHVzZS1jYXNlIGZvciBhbGxvd2luZyB0YWdnZWQg
YWRkcmVzc2VzIGhlcmU/IENhbiB1c2VyIHNwYWNlCmhhbmRsZSB1bnRhZ2dpbmc/CgotLSAKQ2F0
YWxpbgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwphbWQt
Z2Z4IG1haWxpbmcgbGlzdAphbWQtZ2Z4QGxpc3RzLmZyZWVkZXNrdG9wLm9yZwpodHRwczovL2xp
c3RzLmZyZWVkZXNrdG9wLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2FtZC1nZng=
