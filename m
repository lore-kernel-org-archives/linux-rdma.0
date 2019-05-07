From: "Kuehling, Felix" <Felix.Kuehling-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [PATCH v15 12/17] drm/radeon, arm64: untag user pointers in
 radeon_gem_userptr_ioctl
Date: Tue, 7 May 2019 16:44:02 +0000
Message-ID: <7568118b-ad57-156c-464f-54fb3f90a783@amd.com>
References: <cover.1557160186.git.andreyknvl@google.com>
 <03fe9d923db75cf72678f3ce103838e67390751a.1557160186.git.andreyknvl@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
In-Reply-To: <03fe9d923db75cf72678f3ce103838e67390751a.1557160186.git.andreyknvl-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Content-ID: <AC55AB809D9E174784D2867A22094BC5-asWib9pRmPqcE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/amd-gfx>
List-Post: <mailto:amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
List-Help: <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=subscribe>
Errors-To: amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Sender: "amd-gfx" <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
To: Andrey Konovalov <andreyknvl-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Szabolcs Nagy <Szabolcs.Nagy-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Kostya Serebryany <kcc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Vincenzo Frascino <vincenzo.frascino-5wv7dgnIgG8@public.gmane.org>, Jacob Bramley <Jacob.Bramley-5wv7dgnIgG8@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dave Martin <Dave.Martin-5wv7dgnIgG8@public.gmane.org>, Evgeniy Stepanov <eugenis-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kevin Brodsky <kevin.brodsky-5wv7dgnIgG8@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Ruben Ayrapetyan <Ruben.Ayrapetyan-5wv7dgnIgG8@public.gmane.org>, Lee Smith <Lee.Smith-5wv7dgnIgG8@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mauro Carvalho Chehab <mchehab-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Koenig,
 Christian" <Christian.Koenig-5C7GfCeVMHo@public.gmane.org>, Ramana Radhakrishnan <Ramana.Radhakrishnan-5wv7dgnIgG8@public.gmane.org>, "Deucher,
 Alexander" <Alexander.D>
List-Id: linux-rdma@vger.kernel.org

T24gMjAxOS0wNS0wNiAxMjozMCBwLm0uLCBBbmRyZXkgS29ub3ZhbG92IHdyb3RlOg0KPiBbQ0FV
VElPTjogRXh0ZXJuYWwgRW1haWxdDQo+DQo+IFRoaXMgcGF0Y2ggaXMgYSBwYXJ0IG9mIGEgc2Vy
aWVzIHRoYXQgZXh0ZW5kcyBhcm02NCBrZXJuZWwgQUJJIHRvIGFsbG93IHRvDQo+IHBhc3MgdGFn
Z2VkIHVzZXIgcG9pbnRlcnMgKHdpdGggdGhlIHRvcCBieXRlIHNldCB0byBzb21ldGhpbmcgZWxz
ZSBvdGhlcg0KPiB0aGFuIDB4MDApIGFzIHN5c2NhbGwgYXJndW1lbnRzLg0KPg0KPiBJbiByYWRl
b25fZ2VtX3VzZXJwdHJfaW9jdGwoKSBhbiBNTVUgbm90aWZpZXIgaXMgc2V0IHVwIHdpdGggYSAo
dGFnZ2VkKQ0KPiB1c2Vyc3BhY2UgcG9pbnRlci4gVGhlIHVudGFnZ2VkIGFkZHJlc3Mgc2hvdWxk
IGJlIHVzZWQgc28gdGhhdCBNTVUNCj4gbm90aWZpZXJzIGZvciB0aGUgdW50YWdnZWQgYWRkcmVz
cyBnZXQgY29ycmVjdGx5IG1hdGNoZWQgdXAgd2l0aCB0aGUgcmlnaHQNCj4gQk8uIFRoaXMgZnVu
Y2F0aW9uIGFsc28gY2FsbHMgcmFkZW9uX3R0bV90dF9waW5fdXNlcnB0cigpLCB3aGljaCB1c2Vz
DQo+IHByb3ZpZGVkIHVzZXIgcG9pbnRlcnMgZm9yIHZtYSBsb29rdXBzLCB3aGljaCBjYW4gb25s
eSBieSBkb25lIHdpdGgNCj4gdW50YWdnZWQgcG9pbnRlcnMuDQo+DQo+IFRoaXMgcGF0Y2ggdW50
YWdzIHVzZXIgcG9pbnRlcnMgaW4gcmFkZW9uX2dlbV91c2VycHRyX2lvY3RsKCkuDQo+DQo+IFNp
Z25lZC1vZmYtYnk6IEFuZHJleSBLb25vdmFsb3YgPGFuZHJleWtudmxAZ29vZ2xlLmNvbT4NCkFj
a2VkLWJ5OiBGZWxpeCBLdWVobGluZyA8RmVsaXguS3VlaGxpbmdAYW1kLmNvbT4NCg0KDQo+IC0t
LQ0KPiAgIGRyaXZlcnMvZ3B1L2RybS9yYWRlb24vcmFkZW9uX2dlbS5jIHwgMiArKw0KPiAgIDEg
ZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKykNCj4NCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMv
Z3B1L2RybS9yYWRlb24vcmFkZW9uX2dlbS5jIGIvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yYWRl
b25fZ2VtLmMNCj4gaW5kZXggNDQ2MTdkZWM4MTgzLi45MGViNzhmYjVlYjIgMTAwNjQ0DQo+IC0t
LSBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcmFkZW9uX2dlbS5jDQo+ICsrKyBiL2RyaXZlcnMv
Z3B1L2RybS9yYWRlb24vcmFkZW9uX2dlbS5jDQo+IEBAIC0yOTEsNiArMjkxLDggQEAgaW50IHJh
ZGVvbl9nZW1fdXNlcnB0cl9pb2N0bChzdHJ1Y3QgZHJtX2RldmljZSAqZGV2LCB2b2lkICpkYXRh
LA0KPiAgICAgICAgICB1aW50MzJfdCBoYW5kbGU7DQo+ICAgICAgICAgIGludCByOw0KPg0KPiAr
ICAgICAgIGFyZ3MtPmFkZHIgPSB1bnRhZ2dlZF9hZGRyKGFyZ3MtPmFkZHIpOw0KPiArDQo+ICAg
ICAgICAgIGlmIChvZmZzZXRfaW5fcGFnZShhcmdzLT5hZGRyIHwgYXJncy0+c2l6ZSkpDQo+ICAg
ICAgICAgICAgICAgICAgcmV0dXJuIC1FSU5WQUw7DQo+DQo+IC0tDQo+IDIuMjEuMC4xMDIwLmdm
MjgyMGNmMDFhLWdvb2cNCj4NCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fCmFtZC1nZnggbWFpbGluZyBsaXN0CmFtZC1nZnhAbGlzdHMuZnJlZWRlc2t0b3Au
b3JnCmh0dHBzOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vYW1kLWdm
eA==
