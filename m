From: "Kuehling, Felix" <Felix.Kuehling@amd.com>
Subject: Re: [PATCH v14 12/17] drm/radeon, arm64: untag user pointers
Date: Tue, 30 Apr 2019 17:57:12 +0000
Message-ID: <bfe5e11e-6dc4-352f-57eb-d527f965a2ef@amd.com>
References: <cover.1556630205.git.andreyknvl@google.com>
 <9a50ef07d927cbccd9620894bda825e551168c3d.1556630205.git.andreyknvl@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <9a50ef07d927cbccd9620894bda825e551168c3d.1556630205.git.andreyknvl@google.com>
Content-Language: en-US
Content-ID: <ABB2DFC9857E044B9516BE64C1265F1E@namprd12.prod.outlook.com>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Andrey Konovalov <andreyknvl@google.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>, "Koenig@google.com" <Koenig@google.com>, Szabolcs Nagy <Szabolcs.Nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kostya Serebryany <kcc@google.com>, Chintan Pandya <cpandya@codeaurora.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Jacob Bramley <Jacob.Bramley@arm.com>, Leon Romanovsky <leon@kernel.org>, "Kuehling@google.com" <Kuehling@google.com>, Dave Martin <Dave.Martin@arm.com>, Evgeniy Stepanov <eugenis@google.com>, Kevin Brodsky <kevin.brodsky@arm.com>, Kees Cook <keescook@chromium.org>, Ruben Ayrapetyan <Ruben.Ayrapetyan@arm.com>, Lee Smith <Lee.Smith@arm.com>, "Deucher@google.com" <Deucher@google.com>, Alex Williamson <alex.williamson@redhat.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Yis
List-Id: linux-rdma@vger.kernel.org

T24gMjAxOS0wNC0zMCA5OjI1IGEubS4sIEFuZHJleSBLb25vdmFsb3Ygd3JvdGU6DQo+IFtDQVVU
SU9OOiBFeHRlcm5hbCBFbWFpbF0NCj4NCj4gVGhpcyBwYXRjaCBpcyBhIHBhcnQgb2YgYSBzZXJp
ZXMgdGhhdCBleHRlbmRzIGFybTY0IGtlcm5lbCBBQkkgdG8gYWxsb3cgdG8NCj4gcGFzcyB0YWdn
ZWQgdXNlciBwb2ludGVycyAod2l0aCB0aGUgdG9wIGJ5dGUgc2V0IHRvIHNvbWV0aGluZyBlbHNl
IG90aGVyDQo+IHRoYW4gMHgwMCkgYXMgc3lzY2FsbCBhcmd1bWVudHMuDQo+DQo+IHJhZGVvbl90
dG1fdHRfcGluX3VzZXJwdHIoKSB1c2VzIHByb3ZpZGVkIHVzZXIgcG9pbnRlcnMgZm9yIHZtYQ0K
PiBsb29rdXBzLCB3aGljaCBjYW4gb25seSBieSBkb25lIHdpdGggdW50YWdnZWQgcG9pbnRlcnMu
IFRoaXMgcGF0Y2gNCj4gdW50YWdzIHVzZXIgcG9pbnRlcnMgd2hlbiB0aGV5IGFyZSBiZWluZyBz
ZXQgaW4NCj4gcmFkZW9uX3R0bV90dF9waW5fdXNlcnB0cigpLg0KPg0KPiBJbiBhbWRncHVfZ2Vt
X3VzZXJwdHJfaW9jdGwoKSBhbiBNTVUgbm90aWZpZXIgaXMgc2V0IHVwIHdpdGggYSAodGFnZ2Vk
KQ0KPiB1c2Vyc3BhY2UgcG9pbnRlci4gVGhlIHVudGFnZ2VkIGFkZHJlc3Mgc2hvdWxkIGJlIHVz
ZWQgc28gdGhhdCBNTVUNCj4gbm90aWZpZXJzIGZvciB0aGUgdW50YWdnZWQgYWRkcmVzcyBnZXQg
Y29ycmVjdGx5IG1hdGNoZWQgdXAgd2l0aCB0aGUgcmlnaHQNCj4gQk8uIFRoaXMgcGF0Y2ggdW50
YWdzIHVzZXIgcG9pbnRlcnMgaW4gcmFkZW9uX2dlbV91c2VycHRyX2lvY3RsKCkuDQo+DQo+IFNp
Z25lZC1vZmYtYnk6IEFuZHJleSBLb25vdmFsb3YgPGFuZHJleWtudmxAZ29vZ2xlLmNvbT4NCj4g
LS0tDQo+ICAgZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yYWRlb25fZ2VtLmMgfCAyICsrDQo+ICAg
ZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yYWRlb25fdHRtLmMgfCAyICstDQo+ICAgMiBmaWxlcyBj
aGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4NCj4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcmFkZW9uX2dlbS5jIGIvZHJpdmVycy9ncHUvZHJtL3Jh
ZGVvbi9yYWRlb25fZ2VtLmMNCj4gaW5kZXggNDQ2MTdkZWM4MTgzLi45MGViNzhmYjVlYjIgMTAw
NjQ0DQo+IC0tLSBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcmFkZW9uX2dlbS5jDQo+ICsrKyBi
L2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcmFkZW9uX2dlbS5jDQo+IEBAIC0yOTEsNiArMjkxLDgg
QEAgaW50IHJhZGVvbl9nZW1fdXNlcnB0cl9pb2N0bChzdHJ1Y3QgZHJtX2RldmljZSAqZGV2LCB2
b2lkICpkYXRhLA0KPiAgICAgICAgICB1aW50MzJfdCBoYW5kbGU7DQo+ICAgICAgICAgIGludCBy
Ow0KPg0KPiArICAgICAgIGFyZ3MtPmFkZHIgPSB1bnRhZ2dlZF9hZGRyKGFyZ3MtPmFkZHIpOw0K
PiArDQo+ICAgICAgICAgIGlmIChvZmZzZXRfaW5fcGFnZShhcmdzLT5hZGRyIHwgYXJncy0+c2l6
ZSkpDQo+ICAgICAgICAgICAgICAgICAgcmV0dXJuIC1FSU5WQUw7DQo+DQo+IGRpZmYgLS1naXQg
YS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JhZGVvbl90dG0uYyBiL2RyaXZlcnMvZ3B1L2RybS9y
YWRlb24vcmFkZW9uX3R0bS5jDQo+IGluZGV4IDk5MjBhNmZjMTFiZi4uZGNlNzIyYzQ5NGMxIDEw
MDY0NA0KPiAtLS0gYS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JhZGVvbl90dG0uYw0KPiArKysg
Yi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JhZGVvbl90dG0uYw0KPiBAQCAtNzQyLDcgKzc0Miw3
IEBAIGludCByYWRlb25fdHRtX3R0X3NldF91c2VycHRyKHN0cnVjdCB0dG1fdHQgKnR0bSwgdWlu
dDY0X3QgYWRkciwNCj4gICAgICAgICAgaWYgKGd0dCA9PSBOVUxMKQ0KPiAgICAgICAgICAgICAg
ICAgIHJldHVybiAtRUlOVkFMOw0KPg0KPiAtICAgICAgIGd0dC0+dXNlcnB0ciA9IGFkZHI7DQo+
ICsgICAgICAgZ3R0LT51c2VycHRyID0gdW50YWdnZWRfYWRkcihhZGRyKTsNCg0KRG9pbmcgdGhp
cyBoZXJlIHNlZW1zIHVubmVjZXNzYXJ5LCBiZWNhdXNlIHlvdSBhbHJlYWR5IHVudGFnZ2VkIHRo
ZSANCmFkZHJlc3MgaW4gdGhlIG9ubHkgY2FsbGVyIG9mIHRoaXMgZnVuY3Rpb24gaW4gcmFkZW9u
X2dlbV91c2VycHRyX2lvY3RsLiANClRoZSBjaGFuZ2UgdGhlcmUgd2lsbCBhZmZlY3QgYm90aCB0
aGUgdXNlcnB0ciBhbmQgTU1VIG5vdGlmaWVyIHNldHVwIGFuZCANCm1ha2VzIHN1cmUgdGhhdCBi
b3RoIGFyZSBpbiBzeW5jLCB1c2luZyB0aGUgc2FtZSB1bnRhZ2dlZCBhZGRyZXNzLg0KDQpSZWdh
cmRzLA0KIMKgIEZlbGl4DQoNCg0KPiAgICAgICAgICBndHQtPnVzZXJtbSA9IGN1cnJlbnQtPm1t
Ow0KPiAgICAgICAgICBndHQtPnVzZXJmbGFncyA9IGZsYWdzOw0KPiAgICAgICAgICByZXR1cm4g
MDsNCj4gLS0NCj4gMi4yMS4wLjU5My5nNTExZWMzNDVlMTgtZ29vZw0KPg0KX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KZHJpLWRldmVsIG1haWxpbmcgbGlz
dApkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlzdHMuZnJlZWRlc2t0
b3Aub3JnL21haWxtYW4vbGlzdGluZm8vZHJpLWRldmVs
