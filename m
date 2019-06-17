From: Szabolcs Nagy <Szabolcs.Nagy@arm.com>
Subject: Re: [PATCH v17 03/15] arm64: Introduce prctl() options to control the
 tagged user addresses ABI
Date: Mon, 17 Jun 2019 16:56:38 +0000
Message-ID: <fdf49115-2167-af8b-6078-48ac571f5aed@arm.com>
References: <cover.1560339705.git.andreyknvl@google.com>
 <a7a2933bea5fe57e504891b7eec7e9432e5e1c1a.1560339705.git.andreyknvl@google.com>
 <20190617135636.GC1367@arrakis.emea.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190617135636.GC1367@arrakis.emea.arm.com>
Content-Language: en-US
Content-ID: <6EB5105BE008A9488F6CD71841425FF5@eurprd08.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Catalin Marinas <Catalin.Marinas@arm.com>, Andrey Konovalov <andreyknvl@google.com>
Cc: nd <nd@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, Vincenzo Frascino <Vincenzo.Frascino@arm.com>, Will Deacon <Will.Deacon@arm.com>, Mark Rutland <Mark.Rutland@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.>
List-Id: linux-rdma@vger.kernel.org

T24gMTcvMDYvMjAxOSAxNDo1NiwgQ2F0YWxpbiBNYXJpbmFzIHdyb3RlOg0KPiBPbiBXZWQsIEp1
biAxMiwgMjAxOSBhdCAwMTo0MzoyMFBNICswMjAwLCBBbmRyZXkgS29ub3ZhbG92IHdyb3RlOg0K
Pj4gRnJvbTogQ2F0YWxpbiBNYXJpbmFzIDxjYXRhbGluLm1hcmluYXNAYXJtLmNvbT4NCj4+DQo+
PiBJdCBpcyBub3QgZGVzaXJhYmxlIHRvIHJlbGF4IHRoZSBBQkkgdG8gYWxsb3cgdGFnZ2VkIHVz
ZXIgYWRkcmVzc2VzIGludG8NCj4+IHRoZSBrZXJuZWwgaW5kaXNjcmltaW5hdGVseS4gVGhpcyBw
YXRjaCBpbnRyb2R1Y2VzIGEgcHJjdGwoKSBpbnRlcmZhY2UNCj4+IGZvciBlbmFibGluZyBvciBk
aXNhYmxpbmcgdGhlIHRhZ2dlZCBBQkkgd2l0aCBhIGdsb2JhbCBzeXNjdGwgY29udHJvbA0KPj4g
Zm9yIHByZXZlbnRpbmcgYXBwbGljYXRpb25zIGZyb20gZW5hYmxpbmcgdGhlIHJlbGF4ZWQgQUJJ
IChtZWFudCBmb3INCj4+IHRlc3RpbmcgdXNlci1zcGFjZSBwcmN0bCgpIHJldHVybiBlcnJvciBj
aGVja2luZyB3aXRob3V0IHJlY29uZmlndXJpbmcNCj4+IHRoZSBrZXJuZWwpLiBUaGUgQUJJIHBy
b3BlcnRpZXMgYXJlIGluaGVyaXRlZCBieSB0aHJlYWRzIG9mIHRoZSBzYW1lDQo+PiBhcHBsaWNh
dGlvbiBhbmQgZm9yaygpJ2VkIGNoaWxkcmVuIGJ1dCBjbGVhcmVkIG9uIGV4ZWN2ZSgpLg0KPj4N
Cj4+IFRoZSBQUl9TRVRfVEFHR0VEX0FERFJfQ1RSTCB3aWxsIGJlIGV4cGFuZGVkIGluIHRoZSBm
dXR1cmUgdG8gaGFuZGxlDQo+PiBNVEUtc3BlY2lmaWMgc2V0dGluZ3MgbGlrZSBpbXByZWNpc2Ug
dnMgcHJlY2lzZSBleGNlcHRpb25zLg0KPj4NCj4+IFNpZ25lZC1vZmYtYnk6IENhdGFsaW4gTWFy
aW5hcyA8Y2F0YWxpbi5tYXJpbmFzQGFybS5jb20+DQo+IA0KPiBBIHF1ZXN0aW9uIGZvciB0aGUg
dXNlci1zcGFjZSBmb2xrOiBpZiBhbiBhcHBsaWNhdGlvbiBvcHRzIGluIHRvIHRoaXMNCj4gQUJJ
LCB3b3VsZCB5b3Ugd2FudCB0aGUgc2lnY29udGV4dC5mYXVsdF9hZGRyZXNzIGFuZC9vciBzaWdp
bmZvLnNpX2FkZHINCj4gdG8gY29udGFpbiB0aGUgdGFnPyBXZSBjdXJyZW50bHkgY2xlYXIgaXQg
ZWFybHkgaW4gdGhlIGFybTY0IGVudHJ5LlMgYnV0DQo+IHdlIGNvdWxkIGZpbmQgYSB3YXkgdG8g
cGFzcyBpdCBkb3duIGlmIG5lZWRlZC4NCg0KdG8gbWUgaXQgbWFrZXMgc2Vuc2UgdG8ga2VlcCB0
aGUgdGFnIGluIHNpX2FkZHIgLyBmYXVsdF9hZGRyZXNzLg0KDQpidXQgaSBkb24ndCBrbm93IGlu
IGRldGFpbCBob3cgdGhvc2UgZmllbGRzIGFyZSB1c2VkIGN1cnJlbnRseS4NCg0Ka2VlcGluZyB0
aGUgdGFnIGlzIGNlcnRhaW5seSB1c2VmdWwgZm9yIE1URSB0byBkZWJ1ZyB3cm9uZyB0YWcNCmZh
aWx1cmVzIHVubGVzcyB0aGVyZSBpcyBhIHNlcGFyYXRlIG1lY2hhbmlzbSBmb3IgdGhhdC4NCg0K
