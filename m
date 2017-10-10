From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: Is ib_mtu iboe_get_mtu() slightly off?
Date: Tue, 10 Oct 2017 15:27:29 +0000
Message-ID: <VI1PR0502MB3008B64A8827C56272073737D1750@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <CAL1RGDX33tBR=x2sOp_F1605SY5nu_6YALr-XYE_LiuvsHQ1ng@mail.gmail.com>
 <VI1PR0502MB300886CB47BB3DFDE098A26AD1660@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <1507556073.46071.27.camel@redhat.com>
 <20171009134131.GB1252@mtr-leonro.local>
 <1507565652.46071.33.camel@redhat.com>
 <VI1PR0502MB3008900E038DEF6EEAB719DFD1740@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <c27ee8b9-a011-9b0b-b20a-433d9f74d4b1@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <c27ee8b9-a011-9b0b-b20a-433d9f74d4b1-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRG91ZyBMZWRmb3JkIFtt
YWlsdG86ZGxlZGZvcmRAcmVkaGF0LmNvbV0NCj4gU2VudDogVHVlc2RheSwgT2N0b2JlciAxMCwg
MjAxNyA5OjQ4IEFNDQo+IFRvOiBQYXJhdiBQYW5kaXQgPHBhcmF2QG1lbGxhbm94LmNvbT47IExl
b24gUm9tYW5vdnNreQ0KPiA8bGVvbkBrZXJuZWwub3JnPg0KPiBDYzogUm9sYW5kIERyZWllciA8
cm9sYW5kQHB1cmVzdG9yYWdlLmNvbT47IGxpbnV4LXJkbWFAdmdlci5rZXJuZWwub3JnDQo+IFN1
YmplY3Q6IFJlOiBJcyBpYl9tdHUgaWJvZV9nZXRfbXR1KCkgc2xpZ2h0bHkgb2ZmPw0KPiANCj4g
T24gMTAvOS8yMDE3IDQ6NDcgUE0sIFBhcmF2IFBhbmRpdCB3cm90ZToNCj4gDQo+ID4gU29ycnkg
Zm9yIG5vdCBBQ0tpbmcgdGhhdCBJIHdhcyBkb2luZyBpdCBsYXN0IHdlZWsuDQo+ID4gSWYgcG9z
c2libGUsIHBsZWFzZSBwaWNrIHRoZSBvbmUgdGhhdCBMZW9uIGlzIHNlbmRpbmcgYmVjYXVzZSBp
bnN0ZWFkDQo+ID4gb2YgZG9pbmcgY2FsY3VsYXRpb24gaW4gaGFsZiBjb21tZW50IGJhc2VkIGFu
ZCBoYWxmIGRlZmluZWQgYmFzZWQNCj4gPiBjb2RlLCBteSBwYXRjaCBkZWZpbmVzIGFsbCBuZWNl
c3NhcnkgaGVhZGVyIHNpemVzIGluIGNhbGN1bGF0aW9uLCBsaXR0bGUgY2xlYW4NCj4gd2F5Lg0K
PiANCj4gSW4gdGhpcyBpbnN0YW5jZSB3ZSBhcmUgbHVja3kgdGhhdCAwZGF5IHRlc3Rpbmcgd2Fz
IGJlaW5nIHNsb3cgeWVzdGVyZGF5IG9yIGVsc2UNCj4gdGhpcyB3b3VsZCBhbHJlYWR5IGJlIHB1
c2hlZCB0byBrLm8uICBTaW5jZSBpdCdzIG5vdCwgSSBjYW4gZHJvcCBteSBwYXRjaCBhbmQgdGFr
ZQ0KPiB5b3Vycy4NClRoYW5rcy4gTGVvbiB3aWxsIHNlbmQgdjEgd2hlcmUgVURQIGhlYWRlciB3
b3VsZCBiZSBjb3ZlcmVkIHRvby4NCg==
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
