From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH v3 0/9] Introduce per-device completion queue pools
Date: Mon, 20 Nov 2017 21:29:49 +0000
Message-ID: <1511213388.2396.45.camel@wdc.com>
References: <20171108095742.25365-1-sagi@grimberg.me>
         <1510245771.2608.6.camel@wdc.com>
         <d5820b65-b428-7cd1-f7f1-7d8d89d21cf5@grimberg.me>
         <1510248716.2608.17.camel@wdc.com>
         <6af627c8-2814-d562-21a2-f10788e44458@grimberg.me>
         <20171113203444.GJ22610@ziepe.ca>
         <75a7cfe3-58e0-b416-0b5b-beba1e8207fd@grimberg.me>
         <20171114024822.GN22610@ziepe.ca>
         <fd911816-576f-5a8e-eb41-b9081c960685@grimberg.me>
         <20171120192402.GK29075@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171120192402.GK29075-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Content-ID: <423CF2C9B3A2764C948C0A9F46785974-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "jgg-uk2M96/98Pc@public.gmane.org" <jgg-uk2M96/98Pc@public.gmane.org>, "sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gTW9uLCAyMDE3LTExLTIwIGF0IDEyOjI0IC0wNzAwLCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6
DQo+IE9uIE1vbiwgTm92IDIwLCAyMDE3IGF0IDAyOjEwOjEzUE0gKzAyMDAsIFNhZ2kgR3JpbWJl
cmcgd3JvdGU6DQo+ID4gPiA+ID4gSXQgaXMgdG9vIGJhZCB3ZSBjYW4ndCByZS1zaXplIENRcy4u
IENhbiB3ZT8NCj4gPiA+ID4gDQo+ID4gPiA+IEkgd2lzaCB3ZSBjb3VsZCwgYnV0IGl0cyBhbiBv
cHRpb25hbCBmZWF0dXJlIHNvIEkgY2FuJ3Qgc2VlIGhvdyB3ZSBjYW4NCj4gPiA+ID4gdXNlIGl0
Lg0KPiA+ID4gDQo+ID4gPiBXZWxsLCBpdCBsb29rcyBsaWtlIG1seDQvNSBjYW4gZG8gaXQsIHdo
aWNoIGNvdmVycyBhIGh1Z2Ugc3dhdGggb2YNCj4gPiA+IGRlcGxveWVkIGhhcmR3YXJlLi4NCj4g
PiA+IA0KPiA+ID4gSSdkIHNheSBtYWtlIGFuIG9wdGltYWwgaW1wbGVtZW50YXRpb24gdXNpbmcg
cmVzaXplX2NxIGFuZCBqdXN0IGEgd29ya2luZw0KPiA+ID4gaW1wbGVtZW50YXRpb24gd2l0aG91
dCBpdD8NCj4gPiANCj4gPiBJIGNhbiBleHBlcmltZW50IHdpdGggaXQsIHN1cmUuIERvIHlvdSB0
aGluayB0aGF0IGl0cyBhIG11c3QgaGF2ZSBmb3INCj4gPiBmaXJzdCBwaGFzZSB0aG91Z2g/DQo+
IA0KPiBOb3QgY2xlYXIgdG8gbWUuLiBCYXJ0Pw0KDQpIaSBKYXNvbiwNCg0KSGF2aW5nIHRoZSBj
b21wbGV0aW9uIHF1ZXVlIHBvb2wgaW1wbGVtZW50YXRpb24gdXNlIHJlc2l6ZV9jcSBpbnRlcm5h
bGx5IGlmDQpzdXBwb3J0ZWQgYnkgdGhlIEhDQSBzb3VuZHMgaW50ZXJlc3RpbmcgdG8gbWUuIFRo
aXMgd291bGQgaGVscCB0byBhdm9pZCB0aGF0DQp0aGUgQ1EgcG9vbCBpbXBsZW1lbnRhdGlvbiB1
c2VzIG1vcmUgbWVtb3J5IHRoYW4gbmVlZGVkLiBTYWdpLCBpZiB5b3UgZG9uJ3QNCmhhdmUgdGhl
IHRpbWUgdG8gd29yayBvbiB0aGlzIHBsZWFzZSBsZXQgbWUga25vdy4gSW4gdGhhdCBjYXNlIEkg
d2lsbCB0cnkgdG8NCmZyZWUgdXAgc29tZSB0aW1lIGFuZCBpbXBsZW1lbnQgdGhpcyBteXNlbGYu
DQoNCkJhcnQu
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
