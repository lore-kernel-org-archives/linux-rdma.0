From: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v14 08/17] mm, arm64: untag user pointers in
 get_vaddr_frames
Date: Fri, 3 May 2019 17:51:13 +0100
Message-ID: <20190503165113.GJ55449@arrakis.emea.arm.com>
References: <cover.1556630205.git.andreyknvl@google.com>
 <8e20df035de677029b3f970744ba2d35e2df1db3.1556630205.git.andreyknvl@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <8e20df035de677029b3f970744ba2d35e2df1db3.1556630205.git.andreyknvl-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
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
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Koenig-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Szabolcs Nagy <Szabolcs.Nagy-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chintan Pandya <cpandya-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Felix <Felix.Kuehling-5C7GfCeVMHo@public.gmane.org>, Vincenzo Frascino <vincenzo.frascino-5wv7dgnIgG8@public.gmane.org>, Jacob Bramley <Jacob.Bramley-5wv7dgnIgG8@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Dave Martin <Dave.Martin-5wv7dgnIgG8@public.gmane.org>, Evgeniy Stepanov <eugenis-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kevin Brodsky <kevin.brodsky-5wv7dgnIgG8@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Ruben Ayrapetyan <Ruben.Ayrapetyan-5wv7dgnIgG8@public.gmane.org>, Ramana Radhakrishnan <Ramana.Radhakrishnan-5wv7dgnIgG8@public.gmane.org>, Deucher-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dmitry
List-Id: linux-rdma@vger.kernel.org

T24gVHVlLCBBcHIgMzAsIDIwMTkgYXQgMDM6MjU6MDRQTSArMDIwMCwgQW5kcmV5IEtvbm92YWxv
diB3cm90ZToKPiBUaGlzIHBhdGNoIGlzIGEgcGFydCBvZiBhIHNlcmllcyB0aGF0IGV4dGVuZHMg
YXJtNjQga2VybmVsIEFCSSB0byBhbGxvdyB0bwo+IHBhc3MgdGFnZ2VkIHVzZXIgcG9pbnRlcnMg
KHdpdGggdGhlIHRvcCBieXRlIHNldCB0byBzb21ldGhpbmcgZWxzZSBvdGhlcgo+IHRoYW4gMHgw
MCkgYXMgc3lzY2FsbCBhcmd1bWVudHMuCj4gCj4gZ2V0X3ZhZGRyX2ZyYW1lcyB1c2VzIHByb3Zp
ZGVkIHVzZXIgcG9pbnRlcnMgZm9yIHZtYSBsb29rdXBzLCB3aGljaCBjYW4KPiBvbmx5IGJ5IGRv
bmUgd2l0aCB1bnRhZ2dlZCBwb2ludGVycy4gSW5zdGVhZCBvZiBsb2NhdGluZyBhbmQgY2hhbmdp
bmcKPiBhbGwgY2FsbGVycyBvZiB0aGlzIGZ1bmN0aW9uLCBwZXJmb3JtIHVudGFnZ2luZyBpbiBp
dC4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBBbmRyZXkgS29ub3ZhbG92IDxhbmRyZXlrbnZsQGdvb2ds
ZS5jb20+Cj4gLS0tCj4gIG1tL2ZyYW1lX3ZlY3Rvci5jIHwgMiArKwo+ICAxIGZpbGUgY2hhbmdl
ZCwgMiBpbnNlcnRpb25zKCspCj4gCj4gZGlmZiAtLWdpdCBhL21tL2ZyYW1lX3ZlY3Rvci5jIGIv
bW0vZnJhbWVfdmVjdG9yLmMKPiBpbmRleCBjNjRkY2E2ZTI3YzIuLmM0MzFjYTgxZGFkNSAxMDA2
NDQKPiAtLS0gYS9tbS9mcmFtZV92ZWN0b3IuYwo+ICsrKyBiL21tL2ZyYW1lX3ZlY3Rvci5jCj4g
QEAgLTQ2LDYgKzQ2LDggQEAgaW50IGdldF92YWRkcl9mcmFtZXModW5zaWduZWQgbG9uZyBzdGFy
dCwgdW5zaWduZWQgaW50IG5yX2ZyYW1lcywKPiAgCWlmIChXQVJOX09OX09OQ0UobnJfZnJhbWVz
ID4gdmVjLT5ucl9hbGxvY2F0ZWQpKQo+ICAJCW5yX2ZyYW1lcyA9IHZlYy0+bnJfYWxsb2NhdGVk
Owo+ICAKPiArCXN0YXJ0ID0gdW50YWdnZWRfYWRkcihzdGFydCk7Cj4gKwo+ICAJZG93bl9yZWFk
KCZtbS0+bW1hcF9zZW0pOwo+ICAJbG9ja2VkID0gMTsKPiAgCXZtYSA9IGZpbmRfdm1hX2ludGVy
c2VjdGlvbihtbSwgc3RhcnQsIHN0YXJ0ICsgMSk7CgpJcyB0aGlzIHNvbWUgYnVmZmVyIHRoYXQg
dGhlIHVzZXIgbWF5IGhhdmUgbWFsbG9jJ2VkPyBJIGdvdCBsb3N0IHdoZW4KdHJ5aW5nIHRvIHRy
YWNrIGRvd24gdGhlIHByb3ZlbmllbmNlIG9mIHRoaXMgYnVmZmVyLgoKLS0gCkNhdGFsaW4KX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KYW1kLWdmeCBtYWls
aW5nIGxpc3QKYW1kLWdmeEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVl
ZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9hbWQtZ2Z4
