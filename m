From: "Dalessandro, Dennis" <dennis.dalessandro@intel.com>
Subject: Re: [PATCH] IB/hfi1: Add missing error code assignment before test
Date: Wed, 10 Aug 2016 16:10:58 +0000
Message-ID: <1470845455.2576.6.camel@intel.com>
References: <1470807267-12714-1-git-send-email-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1470807267-12714-1-git-send-email-christophe.jaillet@wanadoo.fr>
Content-Language: en-US
Content-ID: <0818EF7E2B0CAD4F9A53BE887E31055D@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "christophe.jaillet@wanadoo.fr" <christophe.jaillet@wanadoo.fr>, "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>, "Marciniszyn, Mike" <mike.marciniszyn@intel.com>, "dledford@redhat.com" <dledford@redhat.com>, "Hefty, Sean" <sean.hefty@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Dalessandro, Dennis" <dennis.dalessandro@intel.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

T24gV2VkLCAyMDE2LTA4LTEwIGF0IDA3OjM0ICswMjAwLCBDaHJpc3RvcGhlIEpBSUxMRVQgd3Jv
dGU6DQo+IEl0IGlzIGxpa2VseSB0aGF0IGNoZWNraW5nIHRoZSByZXN1bHQgb2YgJ3NldHVwX2N0
eHQnIGlzIGV4cGVjdGVkDQo+IGhlcmUuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGhl
IEpBSUxMRVQgPGNocmlzdG9waGUuamFpbGxldEB3YW5hZG9vLmZyPg0KPiAtLS0NCj4gwqBkcml2
ZXJzL2luZmluaWJhbmQvaHcvaGZpMS9maWxlX29wcy5jIHwgMiArLQ0KPiDCoDEgZmlsZSBjaGFu
Z2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvaW5maW5pYmFuZC9ody9oZmkxL2ZpbGVfb3BzLmMNCj4gYi9kcml2ZXJzL2luZmluaWJh
bmQvaHcvaGZpMS9maWxlX29wcy5jDQo+IGluZGV4IDFlY2JlYzE5MjM1OC4uZWQ3NmJlMzliMjBi
IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL2luZmluaWJhbmQvaHcvaGZpMS9maWxlX29wcy5jDQo+
ICsrKyBiL2RyaXZlcnMvaW5maW5pYmFuZC9ody9oZmkxL2ZpbGVfb3BzLmMNCj4gQEAgLTIyMiw3
ICsyMjIsNyBAQCBzdGF0aWMgbG9uZyBoZmkxX2ZpbGVfaW9jdGwoc3RydWN0IGZpbGUgKmZwLA0K
PiB1bnNpZ25lZCBpbnQgY21kLA0KPiDCoAkJcmV0ID0gYXNzaWduX2N0eHQoZnAsICZ1aW5mbyk7
DQo+IMKgCQlpZiAocmV0IDwgMCkNCj4gwqAJCQlyZXR1cm4gcmV0Ow0KPiAtCQlzZXR1cF9jdHh0
KGZwKTsNCj4gKwkJcmV0ID0gc2V0dXBfY3R4dChmcCk7DQo+IMKgCQlpZiAocmV0KQ0KPiDCoAkJ
CXJldHVybiByZXQ7DQo+IMKgCQlyZXQgPSB1c2VyX2luaXQoZnApOw0KDQpUaGFua3MgZm9yIHRo
ZSBwYXRjaC4NCg0KQWNrZWQtYnk6IERlbm5pcyBEYWxlc3NhbmRybyA8ZGVubmlzLmRhbGVzc2Fu
ZHJvQGludGVsLmNvbT4=
