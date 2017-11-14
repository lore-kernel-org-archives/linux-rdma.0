From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH v3 0/9] Introduce per-device completion queue pools
Date: Tue, 14 Nov 2017 16:21:28 +0000
Message-ID: <1510676487.2280.4.camel@wdc.com>
References: <20171108095742.25365-1-sagi@grimberg.me>
         <1510245771.2608.6.camel@wdc.com>
         <d5820b65-b428-7cd1-f7f1-7d8d89d21cf5@grimberg.me>
         <1510248716.2608.17.camel@wdc.com>
         <6af627c8-2814-d562-21a2-f10788e44458@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6af627c8-2814-d562-21a2-f10788e44458-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Content-Language: en-US
Content-ID: <DB86B1C6B8E1A943A3DD9FBFECE30339-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gTW9uLCAyMDE3LTExLTEzIGF0IDIyOjMxICswMjAwLCBTYWdpIEdyaW1iZXJnIHdyb3RlOg0K
PiBPbiBUaHUsIDIwMTctMTEtMDkgYXQgMTc6MzEgKzAwMDAsIEJhcnQgVmFuIEFzc2NoZSB3cm90
ZToNCj4gPiBJbiBjYXNlIG11bHRpcGxlIFVMUHMgc2hhcmUgYW4gUkRNQSBwb3J0IHRoZW4gd2hp
Y2ggQ1EgaXMgY2hvc2VuIGZvciB0aGUgVUxQDQo+ID4gd2lsbCBkZXBlbmQgb24gdGhlIG9yZGVy
IGluIHdoaWNoIHRoZSBVTFAgZHJpdmVycyBhcmUgbG9hZGVkLiBUaGlzIG1heSBsZWFkIHRvDQo+
ID4gaGFyZCB0byBkZWJ1ZyBwZXJmb3JtYW5jZSBpc3N1ZXMsIGUuZy4gZHVlIHRvIGRpZmZlcmVu
dCBsb2NrIGNvbnRlbnRpb24NCj4gPiBiZWhhdmlvci4gVGhhdCdzIGFub3RoZXIgcmVhc29uIHdo
eSBwZXItVUxQIENRIHBvb2xzIGxvb2sgbW9yZSBpbnRlcmVzdGluZyB0bw0KPiA+IG1lIHRoYW4g
b25lIENRIHBvb2wgcGVyIEhDQS4NCj4gDQo+IFRoZSBVTFAgaXMgZnJlZSB0byBwYXNzIGluIGFu
IGFmZmluaXR5IGhpbnQgdG8gZW5mb3JjZSBsb2NhbGl0eSB0byBhDQo+IHNwZWNpZmljIGNwdSBj
b3JlLiBXb3VsZCB0aGF0IHNvbHZlIHRoaXMgaXNzdWU/DQoNCk9ubHkgZm9yIG1seDUgYWRhcHRl
cnMgYmVjYXVzZSBvbmx5IHRoZSBtbHg1IGRyaXZlciBpbXBsZW1lbnRzDQouZ2V0X3ZlY3Rvcl9h
ZmZpbml0eSgpLiBGb3Igb3RoZXIgYWRhcHRlcnMgdGhlIGZvbGxvd2luZyBjb2RlIGlzIHVzZWQg
dG8gY2hvc2UgYQ0KdmVjdG9yOg0KDQogICAgdmVjdG9yID0gYWZmaW5pdHlfaGludCAlIGRldi0+
bnVtX2NvbXBfdmVjdG9yczsNCg0KVGhhdCBtZWFucyB3aGV0aGVyIG9yIG5vdCBhIHNpbmdsZSBD
USB3aWxsIGJlIHVzZWQgYnkgZGlmZmVyZW50IENQVXMgZGVwZW5kcyBvbg0KaG93IHRoZSBVTFAg
YXNzb2NpYXRlcyAnYWZmaW5pdHlfaGludCcgd2l0aCBDUFVzLg0KDQpCYXJ0Lg==
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
