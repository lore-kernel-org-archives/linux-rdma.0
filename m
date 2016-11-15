From: Rony Efraim <ronye-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next 0/4] Add packet pacing support for IB verbs
Date: Tue, 15 Nov 2016 14:43:16 +0000
Message-ID: <HE1PR0501MB272964518AB4EA8F67C14DC5CABF0@HE1PR0501MB2729.eurprd05.prod.outlook.com>
References: <1477909297-14491-1-git-send-email-leon@kernel.org>
 <1828884A29C6694DAF28B7E6B8A82373AB0A7B31@ORSMSX109.amr.corp.intel.com>
 <20161109064009.GE27883@leon.nu>
 <1828884A29C6694DAF28B7E6B8A82373AB0A7F0A@ORSMSX109.amr.corp.intel.com>
 <20161110072242.GC28957@leon.nu>
 <20161110164753.GD22004@obsidianresearch.com>
 <CAFo2czDeGUrA8yYAJ0r5-8q5T=Y=gZojjfHrLqxribZaexmbOA@mail.gmail.com>
  <HE1PR0501MB27291D7FD8782D6650C57E5ACABF0@HE1PR0501MB2729.eurprd05.prod.outlook.com>
 <DB5PR0501MB19281A8064B283BE35EDE821B0BF0@DB5PR0501MB1928.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <DB5PR0501MB19281A8064B283BE35EDE821B0BF0-1FH/Iesddo5/SeJcUcAJq8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

DQpPbiBUaHUsIE5vdiAxMCwgMjAxNiBhdCA2OjQ3IFBNICswMjAwLCBKYXNvbiBHdW50aG9ycGUg
d3JvdGU6DQo+T24gVGh1LCBOb3YgMTAsIDIwMTYgYXQgMDk6MjI6NDJBTSArMDIwMCwgTGVvbiBS
b21hbm92c2t5IHdyb3RlOg0KPj4gSSdsbCBsZXQgdG8gQm9kb25nIHRvIGVsYWJvcmF0ZSBvbiBp
dCBtb3JlLCBidXQgYXMgZmFyIGFzIEkgc2VlLCB0aGUgDQo+PiBBSCBhdHRyaWJ1dGUgaXMgcmVs
ZXZhbnQgdG8gVUQgUVAgb25seSwgd2hpbGUgdGhlIHBhY2tldCBwYWNpbmcgaXMgDQo+PiBpbnRl
bmRlZCBmb3IgYWxsIHR5cGVzIG9mIFFQcy4NCg0KPkluIElCIHN0YXRpYyByYXRlIGlzIHN1cHBv
c2VkIHRvIHdvcmsgZm9yIGFsbCBRUCB0eXBlcy4NCkluZGVlZCB3ZSBhbHJlYWR5IGhhdmUgYSBz
dGF0aWNfcmF0ZSBmaWVsZCwgd2hpY2ggYXBwbGllcyB0byBhbGwgSUIgdHJhZmZpYyAoaW5jbHVk
aW5nIFVEKS4NClRoZSBwcm9ibGVtIGlzOg0KLSBUaGlzIGZpZWxkIGlzIG9ubHkgdTgsIGFuZCB1
c2VzIElCIHN0YW5kYXJkIHJhdGUgZW51bWVyYXRpb25zLiBGb3IgcGFjaW5nLCB3ZSBuZWVkIGFy
Yml0cmFyeSByYXRlcy4NCi0gVGhlIGZpZWxkIGRvZXNuJ3QgYXBwbHkgdG8gUmF3IEV0aGVybmV0
IFFQcywgQUggb3IgQVYgd2hpY2ggaXNuJ3QgYXBwbGljYWJsZSB0byBSYXcgRXRoZXJuZXQuIEl0
IGlzIGluY29ycmVjdCB0byBzdXBwb3J0IEFWL0FIIGZvciBSYXcgRXRoZXJuZXQgUVBzLg0KIA0K
VGhlIHJhdGVfbGltaXQgY29uZmlndXJhdGlvbiBjYW1lIGZvcm0gdGhlIGFwcGxpY2F0aW9uIGxp
a2UgcmVxdWlyZWQgQlcgZm9yIHRoZSBzdHJlYW1pbmcgYW5kIG5vdCBmcm9tIHRoZSBmYWJyaWMg
KFNNKS4NClRoZSByYXRlX2xpbWl0IHJlc29sdXRpb24gaXMgbXVjaCBoaWdoZXIgYW5kIGl0IGlz
IDFLYi9zLg0KDQpCb3RoIG9mIHRoZSBmaWVsZHMgYXJlIGxpbWl0IHRoZSByYXRlIGJ1dCBjb21p
bmcgZnJvbSBhIGRpZmZlcmVudCBlbnRpdGllcyBhbmQgcmVxdWlyZWQgc2VwYXJhdGUgZmllbGRz
Lg0KVGhlIGFjdHVhbCBsaW1pdCBzaG91bGQgYmUgdGhlIG1pbmltdW0gb2YgYm90aCBvZiB0aGVt
Lg0KDQpSb255DQoNCj5KYXNvbg0K
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
