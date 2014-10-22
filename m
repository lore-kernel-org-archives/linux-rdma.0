From: Minh Duc Tran <MinhDuc.Tran-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH 1/1] IB/iser: Remove hard coded values for cqe and
 send_wr
Date: Wed, 22 Oct 2014 04:29:30 +0000
Message-ID: <340a8ae7-4597-4514-a69d-9ef0d56a7e6e@CMEXHTCAS1.ad.emulex.com>
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
 <d89b8c11-5f4f-4a70-b2de-3342c6b628a8@CMEXHTCAS2.ad.emulex.com>
 <54472C2A.7060407@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54472C2A.7060407-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jay Kallickal <jayamohank-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org" <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jayamohan Kallickal <Jayamohan.Kallickal-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Pk9uIDEwLzIyLzIwMTQgMTI6MTEgQU0sIE1pbmggRHVjIFRyYW4gd3JvdGU6DQo+PiBIaSBPciwN
Cj4+DQo+Pj4gU28ganVzdCB0byByZWNhcGhlcmUuDQo+Pj4gV2l0aCB5b3VyIGRyaXZlciBtYXhp
bWFsIGF0dHJpYnV0ZXMgb2YgOEsgQ1FFcyBwZXIgQ1EgYW5kIDMyIENRcyBwZXIgZGV2aWNlLCBk
by93aGF0IHdlIG5lZWQgdG8gY2hhbmdlIHMudCB0aGF0IHRoZSBpc2VyIGluaXRpYXRvciBmdW5j
dGlvbmFsIHdpdGggaXQncyBjdXJyZW50IGNvZGUgaXMgZnVuY3Rpb25hbCBvbiAzLjE4LXJjMT8N
Cj4+IFllcywgSSd2ZSBqdXN0IHZlcmlmaWVkIHRoZSBwYXRjaCB3aXRoIDMuMTgtcmMxIG9uIGJv
dGggb2NyZG1hIGFuZCBtbHg0IGRyaXZlcnMuICBUaGV5IGFyZSB3b3JraW5nIGFzIGV4cGVjdGVk
Lg0KPj4NCj4+PiBBcmUgeW91IGhpdHRpbmcgYW4gKGluYWJpbGl0eSkgdG8gY3JlYXRlIGEgQ1E/
DQo+PiBZZXMNCg0KPlNvIGZvciAzLjE4IHdlIHNob3VsZCBiZSBPSyB3aXRoIG9uZSBsaW5lciBw
YXRjaCB0aGF0IG1ha2VzIHN1cmUgdGhlIHNpemUgb2YgdGhlIGNyZWF0ZWQgQ1EgaXMgbWF4ZWQg
b3V0IGFnYWluc3QgdGhlIHF1YW50aXR5IGFkdmVydGl6ZWQgaW4gdGhlIGRldmljZSBhdHRyaWJ1
dGVzLCBhZ3JlZT8NCg0KTm90IGp1c3QgdGhhdCBvbmUgbGluZXIgY2hhbmdlLiAgVGhlIGNoYW5n
ZSBpcyBhYm91dCAxMCBsaW5lcyBhbmQgdmVyeSBzaW1wbGUuICBJdCBzaG91bGQgdGFrZSB5b3Ug
YWJvdXQgMzAgc2Vjb25kcyB0byByZWFkIGl0LiAgV2UgbmVlZCB0aGUgd2hvbGUgcGF0Y2ggdG8g
Zml4IHR3byBwcm9ibGVtczoNCjEpIHRoZSBjcmVhdGUgQ1EgZmFpbHVyZSBkdWUgdG8gcmVxdWVz
dGVkIENRIGVudHJpZXMgdG9vIGxhcmdlLg0KMikgdGhlIGNyZWF0ZSBxcCBmYWlsdXJlIGR1ZSB0
byByZXF1ZXN0ZWQgd3IgZW50cmllcyB0b28gbGFyZ2UuICBPdXIgaHcgaGFzIGEgbGltaXQgb2Yg
YXJvdW5kIDJrIHdyIHBlciBxcCBpbiB0aGlzIHByb2ZpbGUuICBJc2VyIGNhbGxzIHRvIGNyZWF0
ZSBxcCB3aXRoIGEgaGFyZGNvZGVkIHZhbHVlIG9mIGFyb3VuZCA0ay4NCg0KSWYgeW91IGhhdmUg
b3RoZXIgaWRlYXMgaG93IHRvIHNvbHZlIG91ciBwcm9ibGVtLCBwbGVhc2UgbGV0IHVzIGtub3cu
DQoNClRoYW5rcy4NCi1NaW5oDQoNCg0K
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
