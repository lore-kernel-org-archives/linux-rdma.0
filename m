From: Kevin Brodsky <kevin.brodsky-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v13 09/20] net, arm64: untag user pointers in
 tcp_zerocopy_receive
Date: Mon, 25 Mar 2019 13:54:46 +0000
Message-ID: <e5ed4fff-acf6-7b85-bf8f-df558a9cd33f@arm.com>
References: <cover.1553093420.git.andreyknvl@google.com>
 <2280b62096ce1fa5c9e9429d18f08f82f4be1b0b.1553093421.git.andreyknvl@google.com>
 <20190322120434.GD13384@arrakis.emea.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
In-Reply-To: <20190322120434.GD13384-pQd4kjVL+RGcEQQL7YIRtlaTQe2KTcn/@public.gmane.org>
Content-Language: en-GB
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/amd-gfx>
List-Post: <mailto:amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
List-Help: <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=subscribe>
Errors-To: amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Sender: "amd-gfx" <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
To: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Andrey Konovalov <andreyknvl-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Kate Stewart <kstewart-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chintan Pandya <cpandya-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Vincenzo Frascino <vincenzo.frascino-5wv7dgnIgG8@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "David (ChunMing) Zhou" <David1.Zhou-5C7GfCeVMHo@public.gmane.org>, Jacob Bramley <Jacob.Bramley-5wv7dgnIgG8@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Szabolcs Nagy <Szabolcs.Nagy-5wv7dgnIgG8@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ramana Radhakrishnan <Ramana.Radhakrishnan-5wv7dgnIgG8@public.gmane.org>, Dave Martin <Dave.Ma>
List-Id: linux-rdma@vger.kernel.org

T24gMjIvMDMvMjAxOSAxMjowNCwgQ2F0YWxpbiBNYXJpbmFzIHdyb3RlOgo+IE9uIFdlZCwgTWFy
IDIwLCAyMDE5IGF0IDAzOjUxOjIzUE0gKzAxMDAsIEFuZHJleSBLb25vdmFsb3Ygd3JvdGU6Cj4+
IFRoaXMgcGF0Y2ggaXMgYSBwYXJ0IG9mIGEgc2VyaWVzIHRoYXQgZXh0ZW5kcyBhcm02NCBrZXJu
ZWwgQUJJIHRvIGFsbG93IHRvCj4+IHBhc3MgdGFnZ2VkIHVzZXIgcG9pbnRlcnMgKHdpdGggdGhl
IHRvcCBieXRlIHNldCB0byBzb21ldGhpbmcgZWxzZSBvdGhlcgo+PiB0aGFuIDB4MDApIGFzIHN5
c2NhbGwgYXJndW1lbnRzLgo+Pgo+PiB0Y3BfemVyb2NvcHlfcmVjZWl2ZSgpIHVzZXMgcHJvdmlk
ZWQgdXNlciBwb2ludGVycyBmb3Igdm1hIGxvb2t1cHMsIHdoaWNoCj4+IGNhbiBvbmx5IGJ5IGRv
bmUgd2l0aCB1bnRhZ2dlZCBwb2ludGVycy4KPj4KPj4gVW50YWcgdXNlciBwb2ludGVycyBpbiB0
aGlzIGZ1bmN0aW9uLgo+Pgo+PiBTaWduZWQtb2ZmLWJ5OiBBbmRyZXkgS29ub3ZhbG92IDxhbmRy
ZXlrbnZsQGdvb2dsZS5jb20+Cj4+IC0tLQo+PiAgIG5ldC9pcHY0L3RjcC5jIHwgMiArKwo+PiAg
IDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKykKPj4KPj4gZGlmZiAtLWdpdCBhL25ldC9p
cHY0L3RjcC5jIGIvbmV0L2lwdjQvdGNwLmMKPj4gaW5kZXggNmJhYTZkYzFiMTNiLi44NTVhMWY2
OGMxZWEgMTAwNjQ0Cj4+IC0tLSBhL25ldC9pcHY0L3RjcC5jCj4+ICsrKyBiL25ldC9pcHY0L3Rj
cC5jCj4+IEBAIC0xNzYxLDYgKzE3NjEsOCBAQCBzdGF0aWMgaW50IHRjcF96ZXJvY29weV9yZWNl
aXZlKHN0cnVjdCBzb2NrICpzaywKPj4gICAJaWYgKGFkZHJlc3MgJiAoUEFHRV9TSVpFIC0gMSkg
fHwgYWRkcmVzcyAhPSB6Yy0+YWRkcmVzcykKPj4gICAJCXJldHVybiAtRUlOVkFMOwo+PiAgIAo+
PiArCWFkZHJlc3MgPSB1bnRhZ2dlZF9hZGRyKGFkZHJlc3MpOwo+PiArCj4+ICAgCWlmIChzay0+
c2tfc3RhdGUgPT0gVENQX0xJU1RFTikKPj4gICAJCXJldHVybiAtRU5PVENPTk47Cj4gSSBkb24n
dCB0aGluayB3ZSBuZWVkIHRoaXMgcGF0Y2ggaWYgd2Ugc3RpY2sgdG8gVmluY2Vuem8ncyBBQkkK
PiByZXN0cmljdGlvbnMuIENhbiB6Yy0+YWRkcmVzcyBiZSBhbiBhbm9ueW1vdXMgbW1hcCgpPyBN
eSB1bmRlcnN0YW5kaW5nCj4gb2YgVENQX1pFUk9DT1BZX1JFQ0VJVkUgaXMgdGhhdCB0aGlzIGlz
IGFuIG1tYXAoKSBvbiBhIHNvY2tldCwgc28gdXNlcgo+IHNob3VsZCBub3QgdGFnIHN1Y2ggcG9p
bnRlci4KCkdvb2QgcG9pbnQsIEkgaGFkbid0IGxvb2tlZCBpbnRvIHRoZSBpbnRlcmZhY2UgcHJv
cGVybHkuIFRoZSBgdm1hLT52bV9vcHMgIT0gCiZ0Y3Bfdm1fb3BzYCBjaGVjayBqdXN0IGJlbG93
IG1ha2VzIHN1cmUgdGhhdCB0aGUgbWFwcGluZyBpcyBzcGVjaWZpY2FsbHkgdGllZCB0byBhIApU
Q1Agc29ja2V0LCBzbyBkZWZpbml0ZWx5IG5vdCBpbmNsdWRlZCBpbiB0aGUgQUJJIHJlbGF4YXRp
b24uCgo+IFdlIHdhbnQgdG8gYWxsb3cgdGFnZ2VkIHBvaW50ZXJzIHRvIHdvcmsgdHJhbnNwYXJl
bnRseSBvbmx5IGZvciBoZWFwIGFuZAo+IHN0YWNrLCBoZW5jZSB0aGUgcmVzdHJpY3Rpb24gdG8g
YW5vbnltb3VzIG1tYXAoKSBhbmQgdGhvc2UgYWRkcmVzc2VzCj4gYmVsb3cgc2JyaygwKS4KClRo
YXQncyBub3QgcXVpdGUgdHJ1ZTogaW4gdGhlIEFCSSByZWxheGF0aW9uIHYyLCBhbGwgcHJpdmF0
ZSBtYXBwaW5ncyB0aGF0IGFyZSBlaXRoZXIgCmFub255bW91cyBvciBiYWNrZWQgYnkgYSByZWd1
bGFyIGZpbGUgYXJlIGluY2x1ZGVkLiBUaGUgc2NvcGUgaXMgcXVpdGUgYSBiaXQgbGFyZ2VyIAp0
aGFuIGhlYXAgYW5kIHN0YWNrLCBldmVuIHRob3VnaCB0aGlzIGlzIHdoYXQgd2UncmUgcHJpbWFy
aWx5IGludGVyZXN0ZWQgaW4gZm9yIG5vdy4KCktldmluCl9fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fCmFtZC1nZnggbWFpbGluZyBsaXN0CmFtZC1nZnhAbGlz
dHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4v
bGlzdGluZm8vYW1kLWdmeA==
