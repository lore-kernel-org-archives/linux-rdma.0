From: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v13 09/20] net, arm64: untag user pointers in
 tcp_zerocopy_receive
Date: Fri, 22 Mar 2019 12:04:35 +0000
Message-ID: <20190322120434.GD13384@arrakis.emea.arm.com>
References: <cover.1553093420.git.andreyknvl@google.com>
 <2280b62096ce1fa5c9e9429d18f08f82f4be1b0b.1553093421.git.andreyknvl@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2280b62096ce1fa5c9e9429d18f08f82f4be1b0b.1553093421.git.andreyknvl-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
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

T24gV2VkLCBNYXIgMjAsIDIwMTkgYXQgMDM6NTE6MjNQTSArMDEwMCwgQW5kcmV5IEtvbm92YWxv
diB3cm90ZToKPiBUaGlzIHBhdGNoIGlzIGEgcGFydCBvZiBhIHNlcmllcyB0aGF0IGV4dGVuZHMg
YXJtNjQga2VybmVsIEFCSSB0byBhbGxvdyB0bwo+IHBhc3MgdGFnZ2VkIHVzZXIgcG9pbnRlcnMg
KHdpdGggdGhlIHRvcCBieXRlIHNldCB0byBzb21ldGhpbmcgZWxzZSBvdGhlcgo+IHRoYW4gMHgw
MCkgYXMgc3lzY2FsbCBhcmd1bWVudHMuCj4gCj4gdGNwX3plcm9jb3B5X3JlY2VpdmUoKSB1c2Vz
IHByb3ZpZGVkIHVzZXIgcG9pbnRlcnMgZm9yIHZtYSBsb29rdXBzLCB3aGljaAo+IGNhbiBvbmx5
IGJ5IGRvbmUgd2l0aCB1bnRhZ2dlZCBwb2ludGVycy4KPiAKPiBVbnRhZyB1c2VyIHBvaW50ZXJz
IGluIHRoaXMgZnVuY3Rpb24uCj4gCj4gU2lnbmVkLW9mZi1ieTogQW5kcmV5IEtvbm92YWxvdiA8
YW5kcmV5a252bEBnb29nbGUuY29tPgo+IC0tLQo+ICBuZXQvaXB2NC90Y3AuYyB8IDIgKysKPiAg
MSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKQo+IAo+IGRpZmYgLS1naXQgYS9uZXQvaXB2
NC90Y3AuYyBiL25ldC9pcHY0L3RjcC5jCj4gaW5kZXggNmJhYTZkYzFiMTNiLi44NTVhMWY2OGMx
ZWEgMTAwNjQ0Cj4gLS0tIGEvbmV0L2lwdjQvdGNwLmMKPiArKysgYi9uZXQvaXB2NC90Y3AuYwo+
IEBAIC0xNzYxLDYgKzE3NjEsOCBAQCBzdGF0aWMgaW50IHRjcF96ZXJvY29weV9yZWNlaXZlKHN0
cnVjdCBzb2NrICpzaywKPiAgCWlmIChhZGRyZXNzICYgKFBBR0VfU0laRSAtIDEpIHx8IGFkZHJl
c3MgIT0gemMtPmFkZHJlc3MpCj4gIAkJcmV0dXJuIC1FSU5WQUw7Cj4gIAo+ICsJYWRkcmVzcyA9
IHVudGFnZ2VkX2FkZHIoYWRkcmVzcyk7Cj4gKwo+ICAJaWYgKHNrLT5za19zdGF0ZSA9PSBUQ1Bf
TElTVEVOKQo+ICAJCXJldHVybiAtRU5PVENPTk47CgpJIGRvbid0IHRoaW5rIHdlIG5lZWQgdGhp
cyBwYXRjaCBpZiB3ZSBzdGljayB0byBWaW5jZW56bydzIEFCSQpyZXN0cmljdGlvbnMuIENhbiB6
Yy0+YWRkcmVzcyBiZSBhbiBhbm9ueW1vdXMgbW1hcCgpPyBNeSB1bmRlcnN0YW5kaW5nCm9mIFRD
UF9aRVJPQ09QWV9SRUNFSVZFIGlzIHRoYXQgdGhpcyBpcyBhbiBtbWFwKCkgb24gYSBzb2NrZXQs
IHNvIHVzZXIKc2hvdWxkIG5vdCB0YWcgc3VjaCBwb2ludGVyLgoKV2Ugd2FudCB0byBhbGxvdyB0
YWdnZWQgcG9pbnRlcnMgdG8gd29yayB0cmFuc3BhcmVudGx5IG9ubHkgZm9yIGhlYXAgYW5kCnN0
YWNrLCBoZW5jZSB0aGUgcmVzdHJpY3Rpb24gdG8gYW5vbnltb3VzIG1tYXAoKSBhbmQgdGhvc2Ug
YWRkcmVzc2VzCmJlbG93IHNicmsoMCkuCgotLSAKQ2F0YWxpbgpfX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fXwphbWQtZ2Z4IG1haWxpbmcgbGlzdAphbWQtZ2Z4
QGxpc3RzLmZyZWVkZXNrdG9wLm9yZwpodHRwczovL2xpc3RzLmZyZWVkZXNrdG9wLm9yZy9tYWls
bWFuL2xpc3RpbmZvL2FtZC1nZng=
