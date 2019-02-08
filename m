From: Thomas Hellstrom <thellstrom@vmware.com>
Subject: Re: [PATCH v2] lib/scatterlist: Provide a DMA page iterator
Date: Fri, 8 Feb 2019 07:44:36 +0000
Message-ID: <97c4d30915593e8a81cb6cd5f44dc09c9fc1343c.camel@vmware.com>
References: <20190207222647.GA30974@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20190207222647.GA30974@ziepe.ca>
Content-Language: en-US
Content-ID: <5A60ACE48A04D644AEDC311EDC845E29@namprd05.prod.outlook.com>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: "yong.zhi@intel.com" <yong.zhi@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "Christian.Koenig@amd.com" <Christian.Koenig@amd.com>, "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>, "jgg@mellanox.com" <jgg@mellanox.com>, "hch@lst.de" <hch@lst.de>, "tian.shu.qiu@intel.com" <tian.shu.qiu@intel.com>, "bingbu.cao@intel.com" <bingbu.cao@intel.com>, "daniel@fooishbar.org" <daniel@fooishbar.org>, "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>, "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
List-Id: linux-rdma@vger.kernel.org

T24gVGh1LCAyMDE5LTAyLTA3IGF0IDIyOjI2ICswMDAwLCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6
DQo+IENvbW1pdCAyZGI3NmQ3YzNjNmQgKCJsaWIvc2NhdHRlcmxpc3Q6IHNnX3BhZ2VfaXRlcjog
c3VwcG9ydCBzZyBsaXN0cw0KPiB3L28NCj4gYmFja2luZyBwYWdlcyIpIGludHJvZHVjZWQgdGhl
IHNnX3BhZ2VfaXRlcl9kbWFfYWRkcmVzcygpIGZ1bmN0aW9uDQo+IHdpdGhvdXQNCj4gcHJvdmlk
aW5nIGEgd2F5IHRvIHVzZSBpdCBpbiB0aGUgZ2VuZXJhbCBjYXNlLiBJZiB0aGUgc2dfZG1hX2xl
bigpIGlzDQo+IG5vdA0KPiBlcXVhbCB0byB0aGUgc2cgbGVuZ3RoIGNhbGxlcnMgY2Fubm90IHNh
ZmVseSB1c2UgdGhlDQo+IGZvcl9lYWNoX3NnX3BhZ2Uvc2dfcGFnZV9pdGVyX2RtYV9hZGRyZXNz
IGNvbWJpbmF0aW9uLg0KPiANCj4gUmVzb2x2ZSB0aGlzIEFQSSBtaXN0YWtlIGJ5IHByb3ZpZGlu
ZyBhIERNQSBzcGVjaWZpYyBpdGVyYXRvciwNCj4gZm9yX2VhY2hfc2dfZG1hX3BhZ2UoKSwgdGhh
dCB1c2VzIHRoZSByaWdodCBsZW5ndGggc28NCj4gc2dfcGFnZV9pdGVyX2RtYV9hZGRyZXNzKCkg
d29ya3MgYXMgZXhwZWN0ZWQgd2l0aCBhbGwgc2dsaXN0cy4NCj4gDQo+IEEgbmV3IGl0ZXJhdG9y
IHR5cGUgaXMgaW50cm9kdWNlZCB0byBwcm92aWRlIGNvbXBpbGUtdGltZSBzYWZldHkNCj4gYWdh
aW5zdA0KPiB3cm9uZ2x5IG1peGluZyBhY2Nlc3NvcnMgYW5kIGl0ZXJhdG9ycy4NCj4gDQo+IEFj
a2VkLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4gKGZvciBzY2F0dGVybGlzdCkN
Cj4gU2lnbmVkLW9mZi1ieTogSmFzb24gR3VudGhvcnBlIDxqZ2dAbWVsbGFub3guY29tPg0KPiAN
Cg0KRm9yIHRoZSB2bXdnZnggcGFydCwgDQpBY2tlZC1ieTogVGhvbWFzIEhlbGxzdHJvbSA8dGhl
bGxzdHJvbUB2bXdhcmUuY29tPg0KDQpJJ2xsIHRha2UgYSBkZWVwZXIgbG9vayB0byBwcm92aWRl
IGEgdm13Z2Z4IGZpeCBhcyBhIGZvbGxvdyB1cC4NCg0KVGhhbmtzLA0KVGhvbWFzDQoNCl9fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmRyaS1kZXZlbCBtYWls
aW5nIGxpc3QKZHJpLWRldmVsQGxpc3RzLmZyZWVkZXNrdG9wLm9yZwpodHRwczovL2xpc3RzLmZy
ZWVkZXNrdG9wLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2RyaS1kZXZlbAo=
