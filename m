From: "Estrin, Alex" <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH for-next 16/16] IB/ipoib: Fix for potential no-carrier
 state
Date: Fri, 26 Jan 2018 17:27:56 +0000
Message-ID: <F3529576D8E232409F431C309E29399336CFBE34@CRSMSX102.amr.corp.intel.com>
References: <20180126142640.6868.12402.stgit@scvm10.sc.intel.com>
         <20180126143323.6868.89162.stgit@scvm10.sc.intel.com>
         <1516986011.27592.207.camel@redhat.com> <20180126170610.GD23869@ziepe.ca>
 <1516986596.27592.209.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1516986596.27592.209.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

DQoNCj4gT24gRnJpLCAyMDE4LTAxLTI2IGF0IDEwOjA2IC0wNzAwLCBKYXNvbiBHdW50aG9ycGUg
d3JvdGU6DQo+ID4gT24gRnJpLCBKYW4gMjYsIDIwMTggYXQgMTI6MDA6MTFQTSAtMDUwMCwgRG91
ZyBMZWRmb3JkIHdyb3RlOg0KPiA+DQo+ID4gPiBkZXZpY2UsIHRoZXJlIGlzIHRoYXQgd2luZG93
IGZyb20gb3VyIGZpcnN0IGliX3F1ZXJ5X3BrZXkgY2FsbCB1bnRpbCB3ZQ0KPiA+ID4gY29tcGxl
dGUgdGhlIGliX3JlZ2lzdGVyX2V2ZW50X2hhbmRsZXIoKSBjYWxsIGZvciB0aGUgcGtleSB0byBj
aGFuZ2UuDQo+ID4gPiBJbnN0ZWFkIG9mIHRocm93aW5nIHRoZSBmbHVzaCByZWdhcmRsZXNzLCBp
dCBtaWdodCBiZSBuaWNlciB0byBkbzoNCj4gPg0KPiA+IENhbiB3ZSBtb3ZlIHRoZSBpYl9yZWdp
c3Rlcl9ldmVudF9oYW5kbGVyIHNvb25lcj8NCkhpIEphc29uLA0KSSBoYXZlIGxvb2tlZCBhdCB0
aGlzIHZhcmlhbnQsIGFuZCByZWplY3RlZCB0aGlzIGlkZWEsIGFzIGl0IHdvdWxkIHJlcXVpcmUN
CmEgcXVpdGUgc2VyaW91cyBpbml0aWFsaXphdGlvbiByZXdvcmsuIFNlZW0gcmlza3kgYW5kIHVu
bmVjZXNzYXJ5Lg0KQmVzaWRlcyBpdCB3b24ndCBjbG9zZSB0aGUgd2luZG93IGNvbXBsZXRlbHku
DQotQWxleC4NCiANCj4gSSBkaWRuJ3QgZG8gYSBmdWxsIGF1ZGl0LCBidXQgSSdtIG5vdCBzdXJl
IGl0J3Mgc2FmZSB0bywgc2ltcGx5IGJlY2F1c2UNCj4gd2UgaGF2ZW4ndCBmdWxseSBjb21wbGV0
ZWQgb3VyIGRldmljZSBzZXR1cCBhbmQgaWYgb3VyIGV2ZW50IGhhbmRsZXIgaXMNCj4gbGl2ZSwg
d2UgY2FuIGdldCBldmVudCB0cmlnZ2VyZWQgYWN0aXZpdGllcyB0aGF0IG1pZ2h0IGV4cGVjdCBl
dmVyeXRoaW5nDQo+IHRvIGJlIGRvbmUuICBJdCB3b3VsZCB0YWtlIGEgY29tcGxldGUgYXVkaXQg
dG8ga25vdyBmb3Igc3VyZS4NCj4gDQo+IC0tDQo+IERvdWcgTGVkZm9yZCA8ZGxlZGZvcmRAcmVk
aGF0LmNvbT4NCj4gICAgIEdQRyBLZXlJRDogQjgyNkEzMzMwRTU3MkZERA0KPiAgICAgS2V5IGZp
bmdlcnByaW50ID0gQUU2QiAxQkRBIDEyMkIgMjNCNCAyNjVCICAxMjc0IEI4MjYgQTMzMyAwRTU3
IDJGREQNCg==
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
