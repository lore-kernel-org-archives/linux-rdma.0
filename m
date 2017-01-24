From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH 3/5] qedr: remove CQ spinlock from RDMA CM completion
 handlers
Date: Tue, 24 Jan 2017 11:05:28 +0000
Message-ID: <SN1PR07MB22071F3B44B7590F2F695B33F8750@SN1PR07MB2207.namprd07.prod.outlook.com>
References: <1485185187-18689-1-git-send-email-Ram.Amrani@qlogic.com>
 <1485185187-18689-4-git-send-email-Ram.Amrani@qlogic.com>
 <20170123191313.GB6005@mtr-leonro.local>
 <SN1PR07MB2207B69B469AC2113C757E6CF8750@SN1PR07MB2207.namprd07.prod.outlook.com>
 <20170124101616.GC6005@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170124101616.GC6005-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Ram Amrani <Ram.Amrani-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

PiBPbiBUdWUsIEphbiAyNCwgMjAxNyBhdCAwOTowMjo1NUFNICswMDAwLCBBbXJhbmksIFJhbSB3
cm90ZToNCj4gPiA+IERvbid0IHlvdSBuZWVkIHRvIHJlbW92ZSB0aGlzIGxvY2sgZnJvbSBzdHJ1
Y3QgcWVkcl9jcSB0b28/DQo+ID4NCj4gPiBUaGUgQ1EgbG9jayBoYXMgb3RoZXIgdXNlcyBzbyBp
dCBjYW5ub3QgYmUgZGVsZXRlZC4NCj4gDQo+IFdoYXQgZG8gSSBtaXNzIGhlcmU/DQo+IA0KPiBZ
b3VyIHBhdGNoIHJlbW92ZWQgYWxsIHVzYWdlcyBvZiB0aGlzIGxvY2suDQo+IA0KPiDinpwgIGxp
bnV4LXJkbWEgZ2l0OihtYXN0ZXIpIGdyZXAgLXJJIGNvbXBfaGFuZGxlcl9sb2NrIGRyaXZlcnMv
aW5maW5pYmFuZC9ody9xZWRyLyoNCj4gZHJpdmVycy9pbmZpbmliYW5kL2h3L3FlZHIvcWVkcl9j
bS5jOiBzcGluX2xvY2tfaXJxc2F2ZSgmY3EtPmNvbXBfaGFuZGxlcl9sb2NrLCBmbGFncyk7DQo+
IGRyaXZlcnMvaW5maW5pYmFuZC9ody9xZWRyL3FlZHJfY20uYzogc3Bpbl91bmxvY2tfaXJxcmVz
dG9yZSgmY3EtPmNvbXBfaGFuZGxlcl9sb2NrLCBmbGFncyk7DQo+IGRyaXZlcnMvaW5maW5pYmFu
ZC9ody9xZWRyL3FlZHJfY20uYzogc3Bpbl9sb2NrX2lycXNhdmUoJmNxLT5jb21wX2hhbmRsZXJf
bG9jaywgZmxhZ3MpOw0KPiBkcml2ZXJzL2luZmluaWJhbmQvaHcvcWVkci9xZWRyX2NtLmM6IHNw
aW5fdW5sb2NrX2lycXJlc3RvcmUoJmNxLT5jb21wX2hhbmRsZXJfbG9jaywgZmxhZ3MpOw0KPiBk
cml2ZXJzL2luZmluaWJhbmQvaHcvcWVkci9xZWRyLmg6CXNwaW5sb2NrX3QgY29tcF9oYW5kbGVy
X2xvY2s7DQo+IA0KPiANCg0KWWVhaCwgeW91IGFyZSByaWdodC4gSSBzZWUgbm93IHRoZSBvdGhl
ciBmdW5jdGlvbmFsaXR5IGlzbid0IHRoZXJlLg0KSSB3aWxsIHJlLWlzc3VlIHRoZSBzZXJpZXMu
DQpUaGFua3MhDQoNClJhbQ0KDQo=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
