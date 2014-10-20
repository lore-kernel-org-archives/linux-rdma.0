From: Minh Duc Tran <MinhDuc.Tran-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH 1/1] IB/iser: Remove hard coded values for cqe and
 send_wr
Date: Mon, 20 Oct 2014 20:56:05 +0000
Message-ID: <84548761-6961-4f54-b35c-1f8385bef947@CMEXHTCAS2.ad.emulex.com>
References: <1412728888-13100-1-git-send-email-jkallickal@emulex.com>
	<543CD5D6.1020506@mellanox.com>
	<44d2d670-4785-4a76-8c05-f59791c999cf@CMEXHTCAS1.ad.emulex.com>
	<5443DBCA.4000002@dev.mellanox.co.il>
	<ecfd3441-253c-47bf-b2cb-030b2a00f689@CMEXHTCAS1.ad.emulex.com>
 <CAJ3xEMjbYL9M12UagW52ELdLkHZFnWbKDk0CXZfo_Sf82tjugA@mail.gmail.com>
 <544534DB.4070908@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <544534DB.4070908-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jay Kallickal <jayamohank-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org" <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jayamohan Kallickal <Jayamohan.Kallickal-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Pk9uIDEwLzIwLzIwMTQgMTE6MDEgQU0sIE9yIEdlcmxpdHogd3JvdGU6DQo+PiBPbiBNb24sIE9j
dCAyMCwgMjAxNCBhdCA4OjM2IEFNLCBNaW5oIER1YyBUcmFuIA0KPj4gPE1pbmhEdWMuVHJhbkBl
bXVsZXguY29tPiA+IC0tLSANCj4+IGEvZHJpdmVycy9pbmZpbmliYW5kL3VscC9pc2VyL2lzZXJf
dmVyYnMuYw0KPj4+ICsrKyBiL2RyaXZlcnMvaW5maW5pYmFuZC91bHAvaXNlci9pc2VyX3ZlcmJz
LmMNCj4+IEBAIC0xMTQsNiArMTE0LDkgQEAgc3RhdGljIGludCBpc2VyX2NyZWF0ZV9kZXZpY2Vf
aWJfcmVzKHN0cnVjdCBpc2VyX2RldmljZSAqZGV2aWNlKQ0KPj4+ICAgICAgICAgIGlmIChJU19F
UlIoZGV2aWNlLT5wZCkpDQo+Pj4gICAgICAgICAgICAgICAgICBnb3RvIHBkX2VycjsNCj4+Pg0K
Pj4+ICsgICAgICAgbWF4X2NxZSA9IChkZXZfYXR0ci0+bWF4X2NxZSA8IElTRVJfTUFYX0NRX0xF
TikgPw0KPj4+ICsgICAgICAgICAgICAgICAgICBkZXZfYXR0ci0+bWF4X2NxZSA6IElTRVJfTUFY
X0NRX0xFTjsNCj4+PiArDQo+Pg0KPj4gSWYgSSB3YXMgdGhlIG9jcmRtYSBtYWludGFpbmVyIEkg
d291bGQgc2F5IGxvYWQgYW5kIGNsZWFyOiBOTywgcGxlYXNlLg0KPj4NCj4+IFlvdXIgY3VycmVu
dCBvZmZlcmluZyBzdXBwb3J0cyAzMiBDUXMgcGVyIGRldmljZSwgYW5kIHRoaXMgbWVhbnMgdGhh
dCANCj4+IG9uIDMyIGNvcmUgbm9kZSB5b3Ugd2lsbCBiZSBhYmxlIHRvIHJ1biBvbmx5IGlTRVIs
IG5vIG90aGVyIFVMUC4NCg0KPlRoaXMgaXMgbWF4IENRIGVudHJpZXMsIGFyZSB5b3UgcmVmZXJy
aW5nIHRvIG1heF9jcT8gb3IgYW0gSSBtaXNzaW5nIHNvbWV0aGluZz8NCg0KPkkgdGVuZCB0byBh
Z3JlZSB0aGF0IGlmIHRoZSBkZXZpY2Ugc3VwcG9ydHMgc21hbGxlciBDUXMgd2Ugc2hvdWxkIG5v
dCBqdXN0IGZhaWwgZXZlcnl0aGluZywgYnV0IGFkanVzdCBhY2NvcmRpbmdseS4NCg0KPlNhZ2ku
DQoNClllcywgSSB0aGluayBPcidzIHJlc3BvbnNlIGlzIGEgYml0IGNvbmZ1c2luZyB3aGVuIHBv
c3QgdW5kZXIgdGhlIGJsb2NrIG9mIHBhdGNoIHdoaWNoIGlzIHJlbGF0aW5nIHRvIG1heCBDUSBl
bnRyaWVzIHBlciBDUSwgbm90IG1heCBDUXMuDQpUaG91Z2gsIHdlIGRpZCBtZW50aW9uIHN1cHBv
cnRpbmcgbW9yZSBDUXMgYXMgcGFydCBvZiB0aGUgVE9ETyBsaXN0IGF0IHNvbWUgcG9pbnRzIGlu
IHRoaXMgZGlzY3Vzc2lvbi4NClRoZSBwYXRjaCB3ZSBoYXZlIHBvc3RlZCB3aWxsIHdvcmsgd2l0
aCBjdXJyZW50IElCL2lzZXIgc3VwcG9ydGVkIENRcyBhcyB3ZWxsIGFzIG1heF9jcS8yIGluIHRo
ZSBUT0RPIGxpc3QuDQoNCi1NaW5oIA0K
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
