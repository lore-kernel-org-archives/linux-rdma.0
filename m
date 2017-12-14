From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCHv2 rdma-core 1/2] srp_daemon: handle SM lid change
Date: Thu, 14 Dec 2017 19:13:35 +0000
Message-ID: <1513278813.2475.49.camel@wdc.com>
References: <001cdcfd-8ace-261f-ab86-a09ae3582dd8@suse.com>
         <be797b2f-0317-f9ac-d0ec-5284632790b9@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <be797b2f-0317-f9ac-d0ec-5284632790b9-IBi9RG/b67k@public.gmane.org>
Content-Language: en-US
Content-ID: <566A84444FA0F542A6C82D88B1A53C71-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "nmoreychaisemartin-IBi9RG/b67k@public.gmane.org" <nmoreychaisemartin-IBi9RG/b67k@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "bvanassche-HInyCGIudOg@public.gmane.org" <bvanassche-HInyCGIudOg@public.gmane.org>, "stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org" <stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org>, "hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gV2VkLCAyMDE3LTEyLTEzIGF0IDEzOjMxICswMTAwLCBOaWNvbGFzIE1vcmV5LUNoYWlzZW1h
cnRpbiB3cm90ZToNCj4gV2hlbiBzcnBfZGFlbW9uIHdhcyBydW5uaW5nIGFuZCB0aGUgbWFzdGVy
IFNNIGhvc3QgY2hhbmdlcywNCj4gIHNycF9kYWVtb24gb3V0cHV0IHRoZXNlIGVycm9ycyBhdCBl
dmVyeSBzY2FuOg0KPiBzcnBfZGFlbW9uWzI1Mzk0XTogTm8gcmVzcG9uc2UgdG8gaW5mb3JtIGlu
Zm8gcmVnaXN0cmF0aW9uDQo+IHNycF9kYWVtb25bMjUzOTRdOiBGYWlsIHRvIHJlZ2lzdGVyIHRv
IHRyYXBzLCBtYXliZSB0aGVyZSBpcyBubyBvcGVuc20NCj4gIHJ1bm5pbmcgb24gZmFicmljIG9y
IElCIHBvcnQgaXMgZG93bg0KPiANCj4gVGhpcyB3YXMgaW50cm9kdWNlZCBieSBjb21taXQgNDk1
MmU1ZiBGaXggYSBtZW1vcnkgbGVhay4NCj4gQSBzaWRlIGVmZmVjdCBvZiB0aGlzIHBhdGNoIHdh
cyB0aGF0IGNyZWF0ZV9haCB3YXMgb25seSBjYWxsZWQgd2hlbiB0aGUNCj4gIHBvcnQgbGlkIGNo
YW5nZXMuIFdoaWNoIG1lYW50IHJlZ2lzdGVyX3RvX3RyYXBzIHVzZWQgYW4gb2xkZXIsIG9ic29s
ZXRlLA0KPiAgdmVyc2lvbiBvZiBzbV9saWQgYW5kIGZhaWxlZCB0byBjb25uZWN0IHRvIGl0Lg0K
PiANCj4gVGhpcyBwYXRjaCBmaXhlcyB0aGlzIGJlaGF2aW91ciBieSBjaGVja2luZyBmb3IgYm90
aCBsb2NhbCBsaWQgY2hhbmdlcyBhbmQNCj4gIFNNIGxpZCBjaGFuZ2VzLCBhbmQgY2FsbGluZyBj
cmVhdGVfYWggb24gYW55IG9mIHRoZXNlIGV2ZW50cy4NCg0KUmVwb3J0ZWQtYnk6IEJhcnQgVmFu
IEFzc2NoZSA8YmFydC52YW5hc3NjaGVAd2RjLmNvbT4NCg0KDQo=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
