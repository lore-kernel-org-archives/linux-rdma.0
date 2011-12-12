From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH] IB/qib: Use kcalloc instead of kzalloc to allocate array
Date: Mon, 12 Dec 2011 09:46:25 -0800
Message-ID: <35AAF1E4A771E142979F27B51793A48888856EE83A@AVEXMB1.qlogic.org>
References: <1322600880.1534.306.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1322600880.1534.306.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Meyer <thomas-VsYtu1Qij5c@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

DQo+IFN1YmplY3Q6IFtQQVRDSF0gSUIvcWliOiBVc2Uga2NhbGxvYyBpbnN0ZWFkIG9mIGt6YWxs
b2MgdG8gYWxsb2NhdGUNCj4gYXJyYXkNCj4NCj4gVGhlIGFkdmFudGFnZSBvZiBrY2FsbG9jIGlz
LCB0aGF0IHdpbGwgcHJldmVudCBpbnRlZ2VyIG92ZXJmbG93cyB3aGljaA0KPiBjb3VsZA0KPiBy
ZXN1bHQgZnJvbSB0aGUgbXVsdGlwbGljYXRpb24gb2YgbnVtYmVyIG9mIGVsZW1lbnRzIGFuZCBz
aXplIGFuZCBpdCBpcw0KPiBhbHNvDQo+IGEgYml0IG5pY2VyIHRvIHJlYWQuDQo+DQo+IFRoZSBz
ZW1hbnRpYyBwYXRjaCB0aGF0IG1ha2VzIHRoaXMgY2hhbmdlIGlzIGF2YWlsYWJsZQ0KPiBpbiBo
dHRwczovL2xrbWwub3JnL2xrbWwvMjAxMS8xMS8yNS8xMDcNCj4NCj4gU2lnbmVkLW9mZi1ieTog
VGhvbWFzIE1leWVyIDx0aG9tYXNAbTN5M3IuZGU+DQoNClRoYW5rcyBmb3IgdGhlIHBhdGNoIQ0K
DQpBY2tlZC1ieTogTWlrZSBNYXJjaW5pc3p5biA8bWlrZS5tYXJjaW5pc3p5bkBxbG9naWMuY29t
Pg0KDQpUaGlzIG1lc3NhZ2UgYW5kIGFueSBhdHRhY2hlZCBkb2N1bWVudHMgY29udGFpbiBpbmZv
cm1hdGlvbiBmcm9tIFFMb2dpYyBDb3Jwb3JhdGlvbiBvciBpdHMgd2hvbGx5LW93bmVkIHN1YnNp
ZGlhcmllcyB0aGF0IG1heSBiZSBjb25maWRlbnRpYWwuIElmIHlvdSBhcmUgbm90IHRoZSBpbnRl
bmRlZCByZWNpcGllbnQsIHlvdSBtYXkgbm90IHJlYWQsIGNvcHksIGRpc3RyaWJ1dGUsIG9yIHVz
ZSB0aGlzIGluZm9ybWF0aW9uLiBJZiB5b3UgaGF2ZSByZWNlaXZlZCB0aGlzIHRyYW5zbWlzc2lv
biBpbiBlcnJvciwgcGxlYXNlIG5vdGlmeSB0aGUgc2VuZGVyIGltbWVkaWF0ZWx5IGJ5IHJlcGx5
IGUtbWFpbCBhbmQgdGhlbiBkZWxldGUgdGhpcyBtZXNzYWdlLg0K

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
