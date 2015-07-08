From: Maninder Singh <maninder1.s-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 1/1] infiniband: Remove redundant NULL check before kfree
Date: Wed, 08 Jul 2015 04:23:33 +0000 (GMT)
Message-ID: <1037392254.437811436329408244.JavaMail.weblogic@ep2mlwas06a>
Reply-To: maninder1.s-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
MIME-version: 1.0
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org" <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, PANKAJ MISHRA <pankaj.m-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

SGVsbG8sDQoNCj4+ICsJCQlmb3IgKGkgPSAwOyBpIDwgZGV2LT5jYXBzLm51bV9wb3J0czsgaSsr
KQ0KPj4gKwkJCQlrZnJlZShkbVtpXSk7DQo+PiAJCQlnb3RvIG91dDsNCj4+IAkJfQ0KPj4gCX0N
Cj4+IC0tDQo+PiAxLjcuOS41DQo+PiANCj4NCj5JZiB5b3UgYXJlIGdvaW5nIHRvIGNoYW5nZSB0
aGlzLCB5b3UgbWlnaHQgYXMgd2VsbCBtYWtlIGl0IDEwMCUgY29ycmVjdDoNCj4NCj5ply07DQo+
d2hpbGUgKGkgPj0gMCkNCj4Ja2ZyZWUoZG1baV0pOw0KPg0KPlRoZW4geW91IGRvbpJ0IGhhdmUg
dG8gd29ycnkgYWJvdXQgd2hldGhlciBrZnJlZSB3b3JrcyBvbiBOVUxMLCBldmVyeSBpdGVtIHlv
dSBmcmVlIHdpbGwgYmUgZ3VhcmFudGVlZCB0byBiZSBub24tTlVMTC4NClRoYW5rcyBmb3Igc3Vn
Z2VzdGlvbiA6KQ0KU2VudCBuZXcgcGF0Y2ggd2l0aCBkZXNjcmliZWQgY2hhbmdlcywgSSB3YXMg
dGhpbmtpbmcgb25lIG1vcmUgdGhpbmcuDQoNCkluIGJlbG93IGNvZGUgOi0NCiAgICAgICAgaWYg
KCFpYmRldi0+c3Jpb3YuaXNfZ29pbmdfZG93bikNCiAgICAgICAgICAgIHF1ZXVlX3dvcmsoaWJk
ZXYtPnNyaW92LmRlbXV4W2ldLnVkX3dxLCAmZG1baV0tPndvcmspOw0KICAgICAgICBzcGluX3Vu
bG9ja19pcnFyZXN0b3JlKCZpYmRldi0+c3Jpb3YuZ29pbmdfZG93bl9sb2NrLCBmbGFncyk7DQog
ICAgfQ0Kb3V0Og0KICAgIGtmcmVlKGRtKTsNCiAgICByZXR1cm47DQoNCmRtIGlzIGZyZWVkIGFm
dGVyIHF1ZXVlX3dvcmssIGlzIGl0IGNvcnJlY3QgdG8gZnJlZSBkbSB3aGVuIG90aGVyIGRtW2ld
IGFyZSBhbGxvY2F0ZWQgPyBpIGRpZCBub3QgZ2V0IGl0Lg0KDQpUaGFua3MNCk1hbmluZGVyDQot
LS0tLS0tLS0tLS0=


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
