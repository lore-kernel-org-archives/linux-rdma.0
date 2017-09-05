From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH v1] IB: Move PCI dependency from root KConfig to HW's
 KConfigs
Date: Tue, 5 Sep 2017 14:06:02 +0000
Message-ID: <1504620361.4135.7.camel@wdc.com>
References: <20170904152848.3471-1-yuval.shaia@oracle.com>
         <20170905040826.GB1070@mtr-leonro.local> <1504585010.3360.10.camel@wdc.com>
         <20170905082945.GB14107@yuvallap>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170905082945.GB14107@yuvallap>
Content-Language: en-US
Content-ID: <2A978B2EF49D424DB1FB661F4BB6CBE3-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org" <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gVHVlLCAyMDE3LTA5LTA1IGF0IDExOjI5ICswMzAwLCBZdXZhbCBTaGFpYSB3cm90ZToNCj4g
T24gVHVlLCBTZXAgMDUsIDIwMTcgYXQgMDQ6MTY6NTFBTSArMDAwMCwgQmFydCBWYW4gQXNzY2hl
IHdyb3RlOg0KPiA+IE9uIFR1ZSwgMjAxNy0wOS0wNSBhdCAwNzowOCArMDMwMCwgTGVvbiBSb21h
bm92c2t5IHdyb3RlOg0KPiA+ID4gV2h5IGRvIHdlIG5lZWQgdG8gYmUgZGVwZW5kZW50IG9uIENP
TkZJR19CUk9LRU4/DQo+ID4gPiBJcyBpdCBzdGlsbCB2YWxpZCBmb3IgSUIgc3RhY2s/DQo+ID4g
DQo+ID4gSGVsbG8gTGVvbiwNCj4gPiANCj4gPiBBcyBmYXIgYXMgSSBrbm93ICImJiBCUk9LRU4i
IG1ha2VzIHNlbnNlIGJ1dCAifHwgQlJPS0VOIiBub3QuIFRoZSAifHwgQlJPS0VOIiANCj4gPiBw
YXJ0IHdhcyBpbnRyb2R1Y2VkIHRocm91Z2ggdGhlIGZvbGxvd2luZyBwYXRjaDoNCj4gDQo+IENh
biB5b3UgZWxhYm9yYXRlIG1vcmUgb24gKDEpIHdoeSBCUk9LRU4gaXMgbmVlZGVkIGFuZCAoMikg
d2h5ICImJiIgbWFrZQ0KPiBzZW5zZSBhbmQgInx8IiBub3Q/DQoNCkhlbGxvIFl1dmFsLA0KDQpT
b3JyeSBpZiBJIHdhcyBub3QgY2xlYXIgZW5vdWdoLiBXaGF0IEkgbWVhbnQgaXMgdGhhdCBmb3Ig
YnJva2VuIGRyaXZlcnMgIiYmIEJST0tFTiINCnNob3VsZCBiZSB1c2VkIGluc3RlYWQgb2YgInx8
IEJST0tFTiIuICBNeSBvcGluaW9uIGlzIHRoYXQgInx8IEJST0tFTiIgaXMgbmVpdGhlcg0KbmVl
ZGVkIG5vciB0aGF0IGl0IG1ha2VzIHNlbnNlIGZvciBJbmZpbmlCYW5kLg0KDQpCYXJ0Lg==
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
