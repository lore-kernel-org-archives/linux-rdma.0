From: "Saleem, Shiraz" <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: SQ overflow seen running isert traffic with high block sizes
Date: Mon, 22 Jan 2018 17:49:40 +0000
Message-ID: <9DD61F30A802C4429A01CA4200E302A789EB485A@fmsmsx116.amr.corp.intel.com>
References: <BN3PR07MB25784033E7FCD062FA0A7855F8DD0@BN3PR07MB2578.namprd07.prod.outlook.com>
         <210f538f-8c98-f480-64fc-f2124ed6d01b@grimberg.me>
         <BN3PR07MB25786338EADC77A369A6D493F8DD0@BN3PR07MB2578.namprd07.prod.outlook.com>
         <1499970579.7987.8.camel@haakon3.daterainc.com>
         <BN3PR07MB2578E6561CC669922A322245F8A00@BN3PR07MB2578.namprd07.prod.outlook.com>
         <20171006224025.GA23364@ssaleem-MOBL4.amr.corp.intel.com>
         <1515992195.24576.156.camel@haakon3.daterainc.com>
         <CY1PR0701MB2012E53C69D1CE3E16BA320B88EB0@CY1PR0701MB2012.namprd07.prod.outlook.com>
         <20180115152236.GA15484@ssaleem-MOBL4.amr.corp.intel.com>
 <1516269522.24576.274.camel@haakon3.daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1516269522.24576.274.camel-XoQW25Eq2zs8TOCF0fvnoXxStJ4P+DSV@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "'Nicholas A. Bellinger'" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

PiBTdWJqZWN0OiBSZTogU1Egb3ZlcmZsb3cgc2VlbiBydW5uaW5nIGlzZXJ0IHRyYWZmaWMgd2l0
aCBoaWdoIGJsb2NrIHNpemVzDQo+IA0KPiANCj4gRmlyc3QsIHdvdWxkIGl0IGJlIGhlbHBmdWwg
dG8gbGltaXQgbWF4aW11bSBwYXlsb2FkIHNpemUgcGVyIEkvTyBmb3IgY29uc3VtZXJzDQo+IGJh
c2VkIG9uIG51bWJlciBvZiBpc2VyLXRhcmdldCBzcSBodyBzZ2VzLi4/DQo+IA0KQXNzdW1pbmcg
ZGF0YSBpcyBub3QgYWJsZSB0byBiZSBmYXN0IHJlZ2lzdGVyZWQgYXMgaWYgdmlydHVhbGx5IGNv
bnRpZ3VvdXM7DQphcnRpZmljaWFsbHkgbGltaXRpbmcgdGhlIGRhdGEgc2l6ZSBtaWdodCBub3Qg
YmUgdGhlIGJlc3Qgc29sdXRpb24uDQoNCkJ1dCBtYXggU0dFcyBkb2VzIG5lZWQgdG8gYmUgZXhw
b3NlZCBoaWdoZXIuIFNvbWV3aGVyZSBpbiB0aGUgc3RhY2ssDQp0aGVyZSBtaWdodCBuZWVkIHRv
IGJlIG11bHRpcGxlIFdScyBzdWJtaXR0ZWQgb3IgZGF0YSBjb3BpZWQuDQoNCj4gZGlmZiAtLWdp
dCBhL2RyaXZlcnMvdGFyZ2V0L2lzY3NpL2lzY3NpX3RhcmdldF9jb25maWdmcy5jDQo+IGIvZHJp
dmVycy90YXJnZXQvaXNjc2kvaXNjc2lfdGFyZ2V0X2NvbmZpZ2YNCj4gaW5kZXggMGViYzQ4MS4u
ZDhhNGNjNSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy90YXJnZXQvaXNjc2kvaXNjc2lfdGFyZ2V0
X2NvbmZpZ2ZzLmMNCj4gKysrIGIvZHJpdmVycy90YXJnZXQvaXNjc2kvaXNjc2lfdGFyZ2V0X2Nv
bmZpZ2ZzLmMNCj4gQEAgLTE1NTMsNiArMTU1Myw3IEBAIHN0YXRpYyB2b2lkIGxpb19yZWxlYXNl
X2NtZChzdHJ1Y3Qgc2VfY21kICpzZV9jbWQpDQo+ICAgICAgICAgLm1vZHVsZSAgICAgICAgICAg
ICAgICAgICAgICAgICA9IFRISVNfTU9EVUxFLA0KPiAgICAgICAgIC5uYW1lICAgICAgICAgICAg
ICAgICAgICAgICAgICAgPSAiaXNjc2kiLA0KPiAgICAgICAgIC5ub2RlX2FjbF9zaXplICAgICAg
ICAgICAgICAgICAgPSBzaXplb2Yoc3RydWN0IGlzY3NpX25vZGVfYWNsKSwNCj4gKyAgICAgICAu
bWF4X2RhdGFfc2dfbmVudHMgICAgICAgICAgICAgID0gMzIsIC8qIDMyICogUEFHRV9TSVpFID0g
TUFYSU1VTQ0KPiBUUkFOU0ZFUiBMRU5HVEggKi8NCj4gICAgICAgICAuZ2V0X2ZhYnJpY19uYW1l
ICAgICAgICAgICAgICAgID0gaXNjc2lfZ2V0X2ZhYnJpY19uYW1lLA0KPiAgICAgICAgIC50cGdf
Z2V0X3d3biAgICAgICAgICAgICAgICAgICAgPSBsaW9fdHBnX2dldF9lbmRwb2ludF93d24sDQo+
ICAgICAgICAgLnRwZ19nZXRfdGFnICAgICAgICAgICAgICAgICAgICA9IGxpb190cGdfZ2V0X3Rh
ZywNCj4gDQoNCkJUVywgdGhpcyBpcyBoZWxwaW5nIHRoZSBTUSBvdmVyZmxvdyBpc3N1ZS4NCg==
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
