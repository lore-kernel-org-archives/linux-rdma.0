From: "Estrin, Alex" <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v2] IB/ipoib: fix for rare multicast join race condition.
Date: Mon, 8 Feb 2016 16:43:29 +0000
Message-ID: <F3529576D8E232409F431C309E29399328F6C892@CRSMSX102.amr.corp.intel.com>
References: <20160206135041.11630.77019.stgit@phlsvlogin03.ph.intel.com>
 <CAAk-MO8b_bpb=cd0Ki7wu3sUSG_rC+fS0sxhmdn5cA-91WfR4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAAk-MO8b_bpb=cd0Ki7wu3sUSG_rC+fS0sxhmdn5cA-91WfR4g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

SGkgRXJleiwNCiANCj4gQ2FuIHlvdSBwbGVhc2UgZWxhYm9yYXRlIHdoYXQgd2lsbCBhdm9pZCB0
aGUgb3RoZXIgdGFzayB0aGF0DQo+IGludmFsaWRhdGUgdGhlIHByaXYtPmJyb2FkY2FzdCAoaXBv
aWJfbWNhc3RfZGV2X2ZsdXNoKSB0byBkbyBpdCByaWdodA0KPiBhZnRlciB0aGF0IGNoZWNrPw0K
DQpJIHdhcyBjb25zaWRlcmluZyBjaGVjayBmb3IgSVBPSUJfRkxBR19PUEVSX1VQIGluIG1jYXN0
IHRhc2sgbG9vcCANCndvdWxkIGJlIHN1ZmZpY2llbnQgYXMgaXRzIHN0YXRlIGlzIHNlcmlhbGl6
ZWQgIGJ5IHByaXYtPmxvY2s6DQo+ID4gICAgICAgICBsaXN0X2Zvcl9lYWNoX2VudHJ5KG1jYXN0
LCAmcHJpdi0+bXVsdGljYXN0X2xpc3QsIGxpc3QpIHsNCj4gPiArICAgICAgICAgICAgICAgaWYg
KCF0ZXN0X2JpdChJUE9JQl9GTEFHX09QRVJfVVAsICZwcml2LT5mbGFncykpIHsNCg0KQW5kIEkg
Y2FuIHNlZSB5b3VyIHBvaW50IG5vdy4gV2UgdW5sb2NrIGJlZm9yZSBjYWxsaW5nIG1jYXN0X2pv
aW4oKS4NCkFwcGFyZW50bHkgY2hlY2sgZm9yIE9QRVJfVVAgZmxhZyBzaG91bGQgYmUgYWRkZWQg
YWxvbmcgcHJpdi0+YnJvYWRjYXN0IGNoZWNrDQphcyBpdCB3aWxsIGVuc3VyZSBpbmRpY2F0aW9u
IGlmIG1jYXN0IHdvcmtlciBpcyBjb21wZXRpbmcgd2l0aCBldmVudCBoYW5kbGVyIHdvcmtlci4N
Cg0KVGhhbmtzLA0KQWxleC4NCg0K
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
