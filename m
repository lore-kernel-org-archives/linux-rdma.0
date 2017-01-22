From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v3 37/37] IB/rxe, IB/rdmavt: Use dma_virt_ops instead of
 duplicating it
Date: Sun, 22 Jan 2017 15:51:39 +0000
Message-ID: <1485100284.3158.1.camel@sandisk.com>
References: <20170120210437.26389-1-bart.vanassche@sandisk.com>
         <20170120210437.26389-38-bart.vanassche@sandisk.com>
         <20170122141141.GI28570@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170122141141.GI28570-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Content-ID: <BFEA67E85BA0DD48913BC3C10DBAD3CA-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "andrew.boyer-8PEkshWhKlo@public.gmane.org" <andrew.boyer-8PEkshWhKlo@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "jtoppins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <jtoppins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gU3VuLCAyMDE3LTAxLTIyIGF0IDE2OjExICswMjAwLCBMZW9uIFJvbWFub3Zza3kgd3JvdGU6
DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvaW5maW5pYmFuZC9zdy9yZG1hdnQvS2NvbmZpZyBi
L2RyaXZlcnMvaW5maW5pYmFuZC9zdy9yZG1hdnQvS2NvbmZpZw0KPiA+IGluZGV4IDFkYThkMDFh
Njg1NS4uZmRkMDAxY2UxM2Q4IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvaW5maW5pYmFuZC9z
dy9yZG1hdnQvS2NvbmZpZw0KPiA+ICsrKyBiL2RyaXZlcnMvaW5maW5pYmFuZC9zdy9yZG1hdnQv
S2NvbmZpZw0KPiA+IEBAIC0xLDUgKzEsNiBAQA0KPiA+ICBjb25maWcgSU5GSU5JQkFORF9SRE1B
VlQNCj4gPiAgCXRyaXN0YXRlICJSRE1BIHZlcmJzIHRyYW5zcG9ydCBsaWJyYXJ5Ig0KPiA+ICAJ
ZGVwZW5kcyBvbiA2NEJJVA0KPiA+ICsJc2VsZWN0IERNQV9WSVJUX09QUw0KPiANCj4gQmFydCwN
Cj4gU21hbGwgcXVlc3Rpb24sIGlzIGl0IGFuIGVhc3kgd2F5IHRvIHNlbGVjdCB0aGlzIG9wdGlv
bg0KPiBmb3Igd2hvbGUgSU5GSU5JQkFORCBpbnN0ZWFkIG9mIGRvaW5nIGZvciBldmVyeSBkcml2
ZXI/DQoNCkhlbGxvIExlb24sDQoNCmRtYV92aXJ0X29wcyBpcyB1c2VkIGJ5IG9ubHkgdGhyZWUg
UkRNQSBkcml2ZXJzIChoZmkxLCBxaWIgYW5kIHJ4ZSkuIFNvIEknbQ0Kbm90IHN1cmUgd2h5IHlv
dSB3b3VsZCBsaWtlIHRvIHNlbGVjdCBETUFfVklSVF9PUFMgZm9yIGFsbCBSRE1BIEhCQSBkcml2
ZXJzPw0KDQpCYXJ0Lg0K
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
