From: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v13 12/20] uprobes, arm64: untag user pointers in
 find_active_uprobe
Date: Fri, 22 Mar 2019 15:46:58 +0000
Message-ID: <20190322154657.GR13384@arrakis.emea.arm.com>
References: <cover.1553093420.git.andreyknvl@google.com>
 <88d5255400fc6536d6a6895dd2a3aef0f0ecc899.1553093421.git.andreyknvl@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <88d5255400fc6536d6a6895dd2a3aef0f0ecc899.1553093421.git.andreyknvl-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
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

T24gV2VkLCBNYXIgMjAsIDIwMTkgYXQgMDM6NTE6MjZQTSArMDEwMCwgQW5kcmV5IEtvbm92YWxv
diB3cm90ZToKPiBUaGlzIHBhdGNoIGlzIGEgcGFydCBvZiBhIHNlcmllcyB0aGF0IGV4dGVuZHMg
YXJtNjQga2VybmVsIEFCSSB0byBhbGxvdyB0bwo+IHBhc3MgdGFnZ2VkIHVzZXIgcG9pbnRlcnMg
KHdpdGggdGhlIHRvcCBieXRlIHNldCB0byBzb21ldGhpbmcgZWxzZSBvdGhlcgo+IHRoYW4gMHgw
MCkgYXMgc3lzY2FsbCBhcmd1bWVudHMuCj4gCj4gZmluZF9hY3RpdmVfdXByb2JlKCkgdXNlcyB1
c2VyIHBvaW50ZXJzIChvYnRhaW5lZCB2aWEKPiBpbnN0cnVjdGlvbl9wb2ludGVyKHJlZ3MpKSBm
b3Igdm1hIGxvb2t1cHMsIHdoaWNoIGNhbiBvbmx5IGJ5IGRvbmUgd2l0aAo+IHVudGFnZ2VkIHBv
aW50ZXJzLgo+IAo+IFVudGFnIHVzZXIgcG9pbnRlcnMgaW4gdGhpcyBmdW5jdGlvbi4KPiAKPiBT
aWduZWQtb2ZmLWJ5OiBBbmRyZXkgS29ub3ZhbG92IDxhbmRyZXlrbnZsQGdvb2dsZS5jb20+Cj4g
LS0tCj4gIGtlcm5lbC9ldmVudHMvdXByb2Jlcy5jIHwgMiArKwo+ICAxIGZpbGUgY2hhbmdlZCwg
MiBpbnNlcnRpb25zKCspCj4gCj4gZGlmZiAtLWdpdCBhL2tlcm5lbC9ldmVudHMvdXByb2Jlcy5j
IGIva2VybmVsL2V2ZW50cy91cHJvYmVzLmMKPiBpbmRleCBjNWNkZTg3MzI5YzcuLmQzYTI3MTZh
ODEzYSAxMDA2NDQKPiAtLS0gYS9rZXJuZWwvZXZlbnRzL3Vwcm9iZXMuYwo+ICsrKyBiL2tlcm5l
bC9ldmVudHMvdXByb2Jlcy5jCj4gQEAgLTE5OTIsNiArMTk5Miw4IEBAIHN0YXRpYyBzdHJ1Y3Qg
dXByb2JlICpmaW5kX2FjdGl2ZV91cHJvYmUodW5zaWduZWQgbG9uZyBicF92YWRkciwgaW50ICpp
c19zd2JwKQo+ICAJc3RydWN0IHVwcm9iZSAqdXByb2JlID0gTlVMTDsKPiAgCXN0cnVjdCB2bV9h
cmVhX3N0cnVjdCAqdm1hOwo+ICAKPiArCWJwX3ZhZGRyID0gdW50YWdnZWRfYWRkcihicF92YWRk
cik7Cj4gKwo+ICAJZG93bl9yZWFkKCZtbS0+bW1hcF9zZW0pOwo+ICAJdm1hID0gZmluZF92bWEo
bW0sIGJwX3ZhZGRyKTsKPiAgCWlmICh2bWEgJiYgdm1hLT52bV9zdGFydCA8PSBicF92YWRkcikg
ewoKU2ltaWxhcmx5IGhlcmUsIHRoYXQncyBhIGJyZWFrcG9pbnQgYWRkcmVzcywgaGVuY2UgaW5z
dHJ1Y3Rpb24gcG9pbnRlcgooUEMpIHdoaWNoIGlzIHVudGFnZ2VkLgoKLS0gCkNhdGFsaW4KX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KYW1kLWdmeCBtYWls
aW5nIGxpc3QKYW1kLWdmeEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVl
ZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9hbWQtZ2Z4
