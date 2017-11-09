From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH v3 0/9] Introduce per-device completion queue pools
Date: Thu, 9 Nov 2017 17:31:57 +0000
Message-ID: <1510248716.2608.17.camel@wdc.com>
References: <20171108095742.25365-1-sagi@grimberg.me>
         <1510245771.2608.6.camel@wdc.com>
         <d5820b65-b428-7cd1-f7f1-7d8d89d21cf5@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <d5820b65-b428-7cd1-f7f1-7d8d89d21cf5-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Content-Language: en-US
Content-ID: <8BC65298D6454948A2DFC82C3A2BFFDE-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gVGh1LCAyMDE3LTExLTA5IGF0IDE5OjIyICswMjAwLCBTYWdpIEdyaW1iZXJnIHdyb3RlOg0K
PiBCdXQgSSdtIGFmcmFpZCBkb24ndCB1bmRlcnN0YW5kIGhvdyB0aGUgZmFjdCB0aGF0IFVMUHMg
d2lsbCBydW4gb24NCj4gZGlmZmVyZW50IHBvcnRzIG1hdHRlcj8gaG93IHdvdWxkIHRoZSBmYWN0
IHRoYXQgd2UgaGFkIHR3byBkaWZmZXJlbnQNCj4gcG9vbHMgb24gZGlmZmVyZW50IHBvcnRzIG1h
a2UgYSBkaWZmZXJlbmNlPw0KDQpJZiBlYWNoIFJETUEgcG9ydCBpcyBvbmx5IHVzZWQgYnkgYSBz
aW5nbGUgVUxQIHRoZW4gdGhlIFVMUCBkcml2ZXIgY2FuIHByb3ZpZGUNCmEgYmV0dGVyIHZhbHVl
IGZvciB0aGUgQ1Egc2l6ZSB0aGFuIElCX0NRRV9CQVRDSC4gSWYgQ1EgcG9vbHMgd291bGQgYmUg
Y3JlYXRlZA0KYnkgVUxQcyB0aGVuIGl0IHdvdWxkIGJlIGVhc3kgZm9yIFVMUHMgdG8gcGFzcyB0
aGVpciBjaG9pY2Ugb2YgQ1Egc2l6ZSB0byB0aGUNClJETUEgY29yZS4NCg0KSW4gY2FzZSBtdWx0
aXBsZSBVTFBzIHNoYXJlIGFuIFJETUEgcG9ydCB0aGVuIHdoaWNoIENRIGlzIGNob3NlbiBmb3Ig
dGhlIFVMUA0Kd2lsbCBkZXBlbmQgb24gdGhlIG9yZGVyIGluIHdoaWNoIHRoZSBVTFAgZHJpdmVy
cyBhcmUgbG9hZGVkLiBUaGlzIG1heSBsZWFkIHRvDQpoYXJkIHRvIGRlYnVnIHBlcmZvcm1hbmNl
IGlzc3VlcywgZS5nLiBkdWUgdG8gZGlmZmVyZW50IGxvY2sgY29udGVudGlvbg0KYmVoYXZpb3Iu
IFRoYXQncyBhbm90aGVyIHJlYXNvbiB3aHkgcGVyLVVMUCBDUSBwb29scyBsb29rIG1vcmUgaW50
ZXJlc3RpbmcgdG8NCm1lIHRoYW4gb25lIENRIHBvb2wgcGVyIEhDQS4NCg0KQmFydC4=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
