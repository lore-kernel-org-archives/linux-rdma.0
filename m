From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH v1] IB: Move PCI dependency from root KConfig to HW's
 KConfigs
Date: Tue, 5 Sep 2017 04:16:51 +0000
Message-ID: <1504585010.3360.10.camel@wdc.com>
References: <20170904152848.3471-1-yuval.shaia@oracle.com>
         <20170905040826.GB1070@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170905040826.GB1070-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Content-ID: <0CE7B51C8C32BB4F93CC10F82E677755-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org" <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gVHVlLCAyMDE3LTA5LTA1IGF0IDA3OjA4ICswMzAwLCBMZW9uIFJvbWFub3Zza3kgd3JvdGU6
DQo+IFdoeSBkbyB3ZSBuZWVkIHRvIGJlIGRlcGVuZGVudCBvbiBDT05GSUdfQlJPS0VOPw0KPiBJ
cyBpdCBzdGlsbCB2YWxpZCBmb3IgSUIgc3RhY2s/DQoNCkhlbGxvIExlb24sDQoNCkFzIGZhciBh
cyBJIGtub3cgIiYmIEJST0tFTiIgbWFrZXMgc2Vuc2UgYnV0ICJ8fCBCUk9LRU4iIG5vdC4gVGhl
ICJ8fCBCUk9LRU4iIA0KcGFydCB3YXMgaW50cm9kdWNlZCB0aHJvdWdoIHRoZSBmb2xsb3dpbmcg
cGF0Y2g6DQoNCg0KRnJvbSBhMmIyZjQ1YmU3ZTkxMzhiZGU3ZmNiYTNiOGU5MjU3ZmVhMDRkMDg3
IE1vbiBTZXAgMTcgMDA6MDA6MDAgMjAwMQ0KRnJvbTogQWwgVmlybyA8dmlyb0B3d3cubGludXgu
b3JnLnVrPg0KRGF0ZTogVHVlLCAyMyBBdWcgMjAwNSAyMjo0NTo0MSArMDEwMA0KU3ViamVjdDog
W1BBVENIXSBbUEFUQ0hdIEtjb25maWcgZml4IChpbmZpbmliYW5kIGFuZCBQQ0kpDQoNCmluZmlu
aWJhbmQgdXNlcyBQQ0kgaGVscGVycyBhbGwgb3ZlciB0aGUgcGxhY2UgKGluY2x1ZGluZyB0aGUg
Y29yZSBwYXJ0cykgYW5kDQp3b24ndCBidWlsZCB3aXRob3V0IFBDSS4NCg0KU2lnbmVkLW9mZi1i
eTogQWwgVmlybyA8dmlyb0BwYXJjZWxmYXJjZS5saW51eC50aGVwbGFuZXQuY28udWs+DQpTaWdu
ZWQtb2ZmLWJ5OiBMaW51cyBUb3J2YWxkcyA8dG9ydmFsZHNAb3NkbC5vcmc+DQotLS0NCiBkcml2
ZXJzL2luZmluaWJhbmQvS2NvbmZpZyB8IDEgKw0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlv
bigrKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9pbmZpbmliYW5kL0tjb25maWcgYi9kcml2ZXJz
L2luZmluaWJhbmQvS2NvbmZpZw0KaW5kZXggNzljOGUyZGQ5YzMzLi4zMmNkZmIzMGU5YjQgMTAw
NjQ0DQotLS0gYS9kcml2ZXJzL2luZmluaWJhbmQvS2NvbmZpZw0KKysrIGIvZHJpdmVycy9pbmZp
bmliYW5kL0tjb25maWcNCkBAIC0xLDYgKzEsNyBAQA0KIG1lbnUgIkluZmluaUJhbmQgc3VwcG9y
dCINCiANCiBjb25maWcgSU5GSU5JQkFORA0KKwlkZXBlbmRzIG9uIFBDSSB8fCBCUk9LRU4NCiAJ
dHJpc3RhdGUgIkluZmluaUJhbmQgc3VwcG9ydCINCiAJLS0taGVscC0tLQ0KIAkgIENvcmUgc3Vw
cG9ydCBmb3IgSW5maW5pQmFuZCAoSUIpLiAgTWFrZSBzdXJlIHRvIGFsc28gc2VsZWN0DQo=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
