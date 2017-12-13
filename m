From: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH V3 net-next 3/8] net: hns3: Add HNS3 VF HCL(Hardware
 Compatibility Layer) Support
Date: Wed, 13 Dec 2017 13:02:30 +0000
Message-ID: <F4CC6FACFEB3C54C9141D49AD221F7F93BB764F6@FRAEML521-MBX.china.huawei.com>
References: <20171212175205.236-1-salil.mehta@huawei.com>
 <20171212175205.236-4-salil.mehta@huawei.com>
 <CAOFm3uGs2yO4jfFZSVzZMbE6cbgzzkSBDPFAO_fbt-1XKx7FpQ@mail.gmail.com>
 <F4CC6FACFEB3C54C9141D49AD221F7F93BB76189@FRAEML521-MBX.china.huawei.com>
 <CAOFm3uFH_X5Bfagpx=ai_EdEKAmBHrcPb-xhdO=E-gDhtq0rLw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOFm3uFH_X5Bfagpx=ai_EdEKAmBHrcPb-xhdO=E-gDhtq0rLw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Philippe Ombredanne <pombredanne-od1rfyK75/E@public.gmane.org>
Cc: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "Zhuangyuzeng (Yisen)" <yisen.zhuang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "lipeng (Y)" <lipeng321-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Salil Mehta <mehta.salil.lnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linuxarm <linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

SGkgUGhpbGlwcGUsDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogUGhp
bGlwcGUgT21icmVkYW5uZSBbbWFpbHRvOnBvbWJyZWRhbm5lQG5leGIuY29tXQ0KPiBTZW50OiBX
ZWRuZXNkYXksIERlY2VtYmVyIDEzLCAyMDE3IDEyOjU0IFBNDQo+IFRvOiBTYWxpbCBNZWh0YSA8
c2FsaWwubWVodGFAaHVhd2VpLmNvbT4NCj4gQ2M6IERhdmlkIFMuIE1pbGxlciA8ZGF2ZW1AZGF2
ZW1sb2Z0Lm5ldD47IFpodWFuZ3l1emVuZyAoWWlzZW4pDQo+IDx5aXNlbi56aHVhbmdAaHVhd2Vp
LmNvbT47IGxpcGVuZyAoWSkgPGxpcGVuZzMyMUBodWF3ZWkuY29tPjsgU2FsaWwNCj4gTWVodGEg
PG1laHRhLnNhbGlsLmxua0BnbWFpbC5jb20+OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBMS01M
IDxsaW51eC0NCj4ga2VybmVsQHZnZXIua2VybmVsLm9yZz47IGxpbnV4LXJkbWFAdmdlci5rZXJu
ZWwub3JnOyBMaW51eGFybQ0KPiA8bGludXhhcm1AaHVhd2VpLmNvbT4NCj4gU3ViamVjdDogUmU6
IFtQQVRDSCBWMyBuZXQtbmV4dCAzLzhdIG5ldDogaG5zMzogQWRkIEhOUzMgVkYNCj4gSENMKEhh
cmR3YXJlIENvbXBhdGliaWxpdHkgTGF5ZXIpIFN1cHBvcnQNCj4gDQo+IERlYXIgU2FsaWwsDQo+
IA0KPiBPbiBXZWQsIERlYyAxMywgMjAxNyBhdCAxMTozNSBBTSwgU2FsaWwgTWVodGEgPHNhbGls
Lm1laHRhQGh1YXdlaS5jb20+DQo+IHdyb3RlOg0KPiANCj4gPiBJIGNvdWxkIGFsc28gbWFrZSBv
dXQgZnJvbSBkaWZmZXJlbnQgYXJ0aWNsZXMsIGluY2x1ZGluZyBmcm9tIHRoZQ0KPiBiZWxvdywN
Cj4gPiBMaW51cyBzdWdnZXN0aW5nIG1vdmluZyB0byAiLy8iIHR5cGUgaW5zdGVhZCBvZiBzdGFy
cmVkIG9uZXMgZm9yDQo+IGhlYWRlcnMuDQo+ID4NCj4gPiBJdCBsb29rcyBTUERYIGNoYW5nZSBp
cyBzdGlsbCBhIHN1Z2dlc3Rpb24/DQo+IA0KPiBXZWxsLCBJIHRoaW5rIHRoaXMgaGFzIGJlZW4g
ZGlzY3Vzc2VkIGFuZCBhZ3JlZWQgYW1vbmcgbWFpbnRhaW5lcnMgYXQNCj4gdGhlIHBsdW1iZXJz
IHN1bW1pdCBhbmQgaGVyZSBvbiB0aGlzIGxpc3QuIEFuZCB3aGVuIEkgc2VlIFRob21hcyBkb2MN
Cj4gcGF0Y2hlcywgR3JlZyBwYXRjaGVzLCBvdGhlciBrZXkgbWFpbnRhaW5lcnMgYXMgd2VsbCBh
cyBMaW51cyBjb21tZW50cw0KPiBhbmQgcmV2aWV3cyBhbmQgZ3VpZGVsaW5lcywgSSBjYW4gY2Fu
IGhhcmRseSBzZWUgdGhpcyBhcyBqdXN0IGJlaW5nIGENCj4gInN1Z2dlc3Rpb24iLCBidXQgdGhh
dCdzIHlvdXIgY2FsbCB0byBjb25zaWRlciBpdCB0aGlzIHdheS4NCk9rLiBJIHVuZGVyc3RhbmQu
IFRoYW5rcyBmb3IgY29uZmlybWluZyBpdC4gSSB3aWxsIGRvIHRoZSBjaGFuZ2VzIGFzDQpzdWdn
ZXN0ZWQgYnkgeW91IGFuZCB0aGFua3MgZm9yIGJyaW5naW5nIHRoaXMgaW50byBub3RpY2UuDQoN
CkJlc3QgcmVnYXJkcw0KU2FsaWwNCg==
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
