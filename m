From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v13 04/20] mm, arm64: untag user pointers passed to
 memory syscalls
Date: Thu, 28 Mar 2019 14:19:34 -0400
Message-ID: <20190328141934.38960af0@gandalf.local.home>
References: <cover.1553093420.git.andreyknvl@google.com>
 <44ad2d0c55dbad449edac23ae46d151a04102a1d.1553093421.git.andreyknvl@google.com>
 <20190322114357.GC13384@arrakis.emea.arm.com>
 <CAAeHK+xE-ywfpVHRhBJVGiqOe0+BYW9awUa10ZP4P6Ggc8nxMg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <CAAeHK+xE-ywfpVHRhBJVGiqOe0+BYW9awUa10ZP4P6Ggc8nxMg@mail.gmail.com>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Andrey Konovalov <andreyknvl@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Kate Stewart <kstewart@linuxfoundation.org>, kvm@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Alexei Starovoitov <ast@kernel.org>, dri-devel@lists.freedesktop.org, Linux Memory Management List <linux-mm@kvack.org>, Eric Dumazet <edumazet@google.com>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, Chintan Pandya <cpandya@codeaurora.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Shuah Khan <shuah@kernel.org>, Ingo Molnar <mingo@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Jacob Bramley <Jacob.Bramley@arm.com>, Daniel Borkmann <daniel@iogearbox.net>, linux-rdma@vger.kernel.org, amd-gfx@lists.freedesktop.org, Szabolcs Nagy <Szabolcs.Nagy@arm.com>, Ingo Molnar <mingo@redhat.com>, Dmitry Vyukov <dvyukov@google.c>
List-Id: linux-rdma@vger.kernel.org

T24gVGh1LCAyOCBNYXIgMjAxOSAxOToxMDowNyArMDEwMApBbmRyZXkgS29ub3ZhbG92IDxhbmRy
ZXlrbnZsQGdvb2dsZS5jb20+IHdyb3RlOgoKPiA+ID4gU2lnbmVkLW9mZi1ieTogQW5kcmV5IEtv
bm92YWxvdiA8YW5kcmV5a252bEBnb29nbGUuY29tPgo+ID4gPiAtLS0KPiA+ID4gIGlwYy9zaG0u
YyAgICAgIHwgMiArKwo+ID4gPiAgbW0vbWFkdmlzZS5jICAgfCAyICsrCj4gPiA+ICBtbS9tZW1w
b2xpY3kuYyB8IDUgKysrKysKPiA+ID4gIG1tL21pZ3JhdGUuYyAgIHwgMSArCj4gPiA+ICBtbS9t
aW5jb3JlLmMgICB8IDIgKysKPiA+ID4gIG1tL21sb2NrLmMgICAgIHwgNSArKysrKwo+ID4gPiAg
bW0vbW1hcC5jICAgICAgfCA3ICsrKysrKysKPiA+ID4gIG1tL21wcm90ZWN0LmMgIHwgMSArCj4g
PiA+ICBtbS9tcmVtYXAuYyAgICB8IDIgKysKPiA+ID4gIG1tL21zeW5jLmMgICAgIHwgMiArKwo+
ID4gPiAgMTAgZmlsZXMgY2hhbmdlZCwgMjkgaW5zZXJ0aW9ucygrKSAgCj4gPgo+ID4gSSB3b25k
ZXIgd2hldGhlciBpdCdzIGJldHRlciB0byBrZWVwIHRoZXNlIGFzIHdyYXBwZXJzIGluIHRoZSBh
cm02NAo+ID4gY29kZS4gIAo+IAo+IEkgZG9uJ3QgdGhpbmsgSSB1bmRlcnN0YW5kIHdoYXQgeW91
IHByb3Bvc2UsIGNvdWxkIHlvdSBlbGFib3JhdGU/CgpJIGJlbGlldmUgQ2F0YWxpbiBpcyBzYXlp
bmcgdGhhdCBpbnN0ZWFkIG9mIHBsYWNpbmcgdGhpbmdzIGxpa2U6CgpAQCAtMTU5Myw2ICsxNTkz
LDcgQEAgU1lTQ0FMTF9ERUZJTkUzKHNobWF0LCBpbnQsIHNobWlkLCBjaGFyIF9fdXNlciAqLCBz
aG1hZGRyLCBpbnQsIHNobWZsZykKIAl1bnNpZ25lZCBsb25nIHJldDsKIAlsb25nIGVycjsKIAor
CXNobWFkZHIgPSB1bnRhZ2dlZF9hZGRyKHNobWFkZHIpOwoKVG8gaW5zdGVhZCBoYXZlIHRoZSBz
aG1hZGRyIHNldCB0byB0aGUgdW50YWdnZWRfYWRkcigpIGJlZm9yZSBjYWxsaW5nCnRoZSBzeXN0
ZW0gY2FsbCwgYW5kIHBhc3NpbmcgdGhlIHVudGFnZ2VkIGFkZHIgdG8gdGhlIHN5c3RlbSBjYWxs
LCBhcwp0aGF0IGdvZXMgdGhyb3VnaCB0aGUgYXJtNjQgYXJjaGl0ZWN0dXJlIHNwZWNpZmljIGNv
ZGUgZmlyc3QuCgotLSBTdGV2ZQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fXwpkcmktZGV2ZWwgbWFpbGluZyBsaXN0CmRyaS1kZXZlbEBsaXN0cy5mcmVlZGVz
a3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9k
cmktZGV2ZWw=
