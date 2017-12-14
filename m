From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCHv2 rdma-core 2/2] srp_daemon: fix CQ handling
Date: Thu, 14 Dec 2017 19:17:31 +0000
Message-ID: <1513279049.2475.50.camel@wdc.com>
References: <001cdcfd-8ace-261f-ab86-a09ae3582dd8@suse.com>
         <7ed5d5af-0f53-c15f-e7f2-516f6786113f@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7ed5d5af-0f53-c15f-e7f2-516f6786113f-IBi9RG/b67k@public.gmane.org>
Content-Language: en-US
Content-ID: <429B91147128234B9A99DA1D43329D57-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "nmoreychaisemartin-IBi9RG/b67k@public.gmane.org" <nmoreychaisemartin-IBi9RG/b67k@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "bvanassche-HInyCGIudOg@public.gmane.org" <bvanassche-HInyCGIudOg@public.gmane.org>, "stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org" <stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org>, "hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gV2VkLCAyMDE3LTEyLTEzIGF0IDEzOjMyICswMTAwLCBOaWNvbGFzIE1vcmV5LUNoYWlzZW1h
cnRpbiB3cm90ZToNCj4gU00gdHJhcHMgYXJlIHBvbGxlZCB0aHJvdWdoIHBvbGxfY3Egd2hpY2gg
d2FpdGVkIGZvciBhIENRIGV2ZW50DQo+IGJlZm9yZSBwb2xsaW5nIHRoZSBDUSBpdHNlbGYuDQo+
IEhvd2V2ZXIgaXQgbWF5IGhhcHBlbnMgdGhhdCBtdWx0aXBsZSBjb21wbGV0aW9ucyBhcmUgYXR0
YWNoZWQNCj4gdG8gYSBzaW5nbGUgZXZlbnQuIEFzIHN0YXRlZCBieSB0aGUgaWJ2X2dldF9jcV9l
dmVudCBtYW4gcGFnZSwNCj4gaXQgaXMgcmVxdWlyZWQgdG8gcG9sbCB0aGUgdGhlIENRIHRvIGdl
dCB0aG9zZSBjb21wbGV0aW9ucw0KPiBhZnRlciB0aGUgY2FsbCB0byBpYnZfcmVxX25vdGlmeV9j
cS4NCj4gDQo+IEFzIGNvbXBsZXRpb25zIG5lZWQgdG8gYmUgaGFuZGxlZCBvbmUgYnkgb25lIGlu
IGFuIG91dGVyIGZ1bmN0aW9uLA0KPiBzdGFydCBieSBwb2xsaW5nIHRoZSBDUSBhbmQgcmV0dXJu
IHRoZSBjb21wbGV0aW9uIChpZiBhbnkpIGJlZm9yZQ0KPiB3YWl0aW5nIGZvciB0aGUgbmV4dCBj
b21wbGV0aW9uIGV2ZW50Lg0KPiBUaGlzIHdpbGwgYWxsb3cgZW1wdHlpbmcgYWxsIHBlbmRpbmcg
Y29tcGxldGlvbnMsIHRocm91Z2ggbXVsdGlwbGUgY2FsbHMNCj4gdG8gcG9sbF9jcSwgIGJlZm9y
ZSB3YWl0aW5nIGZvciBhIG5ldyBldmVudC4NCj4gDQo+IFRoZSBidWdneSB1c2UgY2FzZSBzZWVt
cyB0byBhcHBlYXIgd2hlbiB0aGUgbWFzdGVyIFNNIGlzIHN3aXRjaGVkIG11bHRpcGxlDQo+IHRp
bWVzIGJldHdlZW4gdHdvIG5vZGVzLiBBcyB0aGUgbnVtYmVyIG9mIHBpbmctcG9uZyBiZXR3ZWVu
IHRoZSBTTXMgaW5jcmVhc2VzLA0KPiB0aGUgbnVtYmVyIG9mIHRyYXBzIHNlbnQgdG8gbm90aWZ5
IHRoYXQgdGhlIFNNIGp1c3QgYmVjYW1lIG1hc3RlciBpbmNyZWFzZXMNCj4gdG9vLiBUaGlzIGNh
dXNlcyBidXJzdCBvZiBjb21wbGV0aW9ucyBsaW5rZWQgdG8gYSBzaW5nbGUgZXZlbnQuDQo+IE5v
dGUgdGhhdCB0aGUgcmFjZSBjb25kaXRpb24gaXMgYWxzbyBwb3NzaWJsZSBpbiBvdGhlciBzY2Vu
YXJpby4NCg0KUmV2aWV3ZWQtYnk6IEJhcnQgVmFuIEFzc2NoZSA8YmFydC52YW5hc3NjaGVAd2Rj
LmNvbT4NCg0KDQoNCg==
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
