From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH rdma-next 0/3] Support out of order data placement
Date: Sat, 22 Jul 2017 15:11:52 +0000
Message-ID: <VI1PR0502MB30085360EB92EAD519086BBBD1A50@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <20170612064918.12510-1-leon@kernel.org>
 <6747e257-67b0-a364-be21-04f73ef82ffe@talpey.com>
 <VI1PR0502MB30080B672B80836FF0A328DCD1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <475e1873-e842-ecb9-d260-34777da57e51@talpey.com>
 <VI1PR0502MB3008B7FE60CAB3BD49907A1BD1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <d3a436a0-9ace-b11a-2e4c-387fc575877e@talpey.com>
 <VI1PR0502MB3008E04612EED6BC83F37115D1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <fbdcf05b-ccd8-bd9c-c9c8-86f373303250@talpey.com>
 <VI1PR0502MB30089271EB542493AA58060CD1C20@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <fb11f261-b80b-f71a-8076-204706267798@talpey.com>
 <VI1PR0502MB3008D488FEE8A7104A7B0A7CD1A60@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <142c2fed-baa5-1295-1458-be765c94b957@talpey.com>
 <VI1PR0502MB300886ED1B5B1363B55F53F0D1A50@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <e5cee768-586c-516a-6056-ea4a44f89134@talpey.com>
 <VI1PR0502MB30089915EB792CD20CA9D179D1A50@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <4444a96a-c1e6-ad33-204a-680982e19bfe@talpey.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4444a96a-c1e6-ad33-204a-680982e19bfe-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Idan Burstein <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFRvbSBUYWxwZXkgW21haWx0
bzp0b21AdGFscGV5LmNvbV0NCj4gU2VudDogU2F0dXJkYXksIEp1bHkgMjIsIDIwMTcgOTo1MiBB
TQ0KPiBUbzogUGFyYXYgUGFuZGl0IDxwYXJhdkBtZWxsYW5veC5jb20+OyBKYXNvbiBHdW50aG9y
cGUNCj4gPGpndW50aG9ycGVAb2JzaWRpYW5yZXNlYXJjaC5jb20+DQo+IENjOiBCYXJ0IFZhbiBB
c3NjaGUgPEJhcnQuVmFuQXNzY2hlQHNhbmRpc2suY29tPjsgbGVvbkBrZXJuZWwub3JnOw0KPiBk
bGVkZm9yZEByZWRoYXQuY29tOyBsaW51eC1yZG1hQHZnZXIua2VybmVsLm9yZzsgSWRhbiBCdXJz
dGVpbg0KPiA8aWRhbmJAbWVsbGFub3guY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHJkbWEt
bmV4dCAwLzNdIFN1cHBvcnQgb3V0IG9mIG9yZGVyIGRhdGEgcGxhY2VtZW50DQo+IA0KPiBXZWxs
LCBpZiB0aGUgYnJva2VuIGFwcGxpY2F0aW9ucyB3b24ndCB1c2UgdGhlIGV4dGVuc2lvbiwgYW5k
IHRoZSBleGlzdGluZw0KPiBzdG9yYWdlIHByb3RvY29scyBhbmQgYXBwbGljYXRpb25zIHdpbGwg
aGF2ZSB0byBjaGFuZ2UgYm90aCB0aGVpcg0KPiBpbXBsZW1lbnRhdGlvbiBhbmQgdGhlaXIgcHJv
dG9jb2wgdG8gdXNlIGl0LCB3aG8gZG8geW91IGVudmlzaW9uIGFjdHVhbGx5IGRvaW5nDQo+IHNv
Pw0KQ3VycmVudCBhcHBsaWNhdGlvbiBiaW5hcmllcyBhbmQgdGhlaXIgbWlkZGxld2FyZSBiaW5h
cmllcyBjYW4gY29udGludWUgdG8gd29yayBhcyBpcy4NCk5ldyBhcHBsaWNhdGlvbnMgcXVlcnkg
dGhpcyBmZWF0dXJlIGFuZCBlbmFibGUgdGhlbXNlbHZlcyB0byB0YWtlIGJlbmVmaXQgb2YgdGhp
cyBvcHRpb25hbCBleHRlbnNpb24uDQo=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
