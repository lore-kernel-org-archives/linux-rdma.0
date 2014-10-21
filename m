From: Minh Duc Tran <MinhDuc.Tran-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH 1/1] IB/iser: Remove hard coded values for cqe and
 send_wr
Date: Tue, 21 Oct 2014 21:11:29 +0000
Message-ID: <d89b8c11-5f4f-4a70-b2de-3342c6b628a8@CMEXHTCAS2.ad.emulex.com>
References: <1412728888-13100-1-git-send-email-jkallickal@emulex.com>
	<543CD5D6.1020506@mellanox.com>
	<44d2d670-4785-4a76-8c05-f59791c999cf@CMEXHTCAS1.ad.emulex.com>
	<5443DBCA.4000002@dev.mellanox.co.il>
	<ecfd3441-253c-47bf-b2cb-030b2a00f689@CMEXHTCAS1.ad.emulex.com>
	<CAJ3xEMjbYL9M12UagW52ELdLkHZFnWbKDk0CXZfo_Sf82tjugA@mail.gmail.com>
	<eaf7c875-e7e1-43eb-b27a-fbd068aa32f1@CMEXHTCAS1.ad.emulex.com>
	<CAJ3xEMgnmZD8ONJcnor__eioMtfaO6MYMKfd6nbXncaWYXTG+g@mail.gmail.com>
 <CAJ3xEMi9uBB0fFqGj4nUOdYYezLzF135TLH-sswQ0G5hZQvAkA@mail.gmail.com>
 <54466C39.4070402@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54466C39.4070402-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jay Kallickal <jayamohank-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org" <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jayamohan Kallickal <Jayamohan.Kallickal-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

SGkgT3IsDQoNCj5TbyBqdXN0IHRvIHJlY2FwaGVyZS4NCj5XaXRoIHlvdXIgZHJpdmVyIG1heGlt
YWwgYXR0cmlidXRlcyBvZiA4SyBDUUVzIHBlciBDUSBhbmQgMzIgQ1FzIHBlciBkZXZpY2UsIGRv
L3doYXQgd2UgbmVlZCB0byBjaGFuZ2Ugcy50IHRoYXQgdGhlIGlzZXIgaW5pdGlhdG9yIGZ1bmN0
aW9uYWwgd2l0aCBpdCdzIGN1cnJlbnQgY29kZSBpcyBmdW5jdGlvbmFsIG9uIDMuMTgtcmMxPw0K
DQpZZXMsIEkndmUganVzdCB2ZXJpZmllZCB0aGUgcGF0Y2ggd2l0aCAzLjE4LXJjMSBvbiBib3Ro
IG9jcmRtYSBhbmQgbWx4NCBkcml2ZXJzLiAgVGhleSBhcmUgd29ya2luZyBhcyBleHBlY3RlZC4N
Cg0KPkFyZSB5b3UgaGl0dGluZyBhbiAoaW5hYmlsaXR5KSB0byBjcmVhdGUgYSBDUT8NCg0KWWVz
DQoNCj5JJ2QgMXN0IGFuZCBtb3N0IHdhbnQgdG8gbWFrZSBzdXJlIHdlIGFyZSBvcGVyYXRpdmUg
YW5kIGxhdGVyIGRvIGZ1cnRoZXIgaGFyZGVuaW5nLg0KDQpUaGlzIHBhdGNoIHNob3VsZCBub3Qg
YWR2ZXJzZWx5IGltcGFjdCB0aGUgaW1wbGVtZW50YXRpb24gd2l0aCB0aGUgcHJvcG9zZWQgVE9E
TyBsaXN0Lg0KDQo+T3IuDQoNCg0KU2luY2UgdGhlIHBhdGNoIGlzIGZpbmUsIHdvdWxkIGJlIGdy
ZWF0IGlmIHlvdSBjYW4gYWNjZXB0IHRoZSBwYXRjaC4NCg0KVGhhbmtzLg0KLW1pbmgNCg==
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
